-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local smoothy = require "neverlose/smoothy"

local base64 = require "neverlose/base64"
local clipboard = require "neverlose/clipboard"

local inspect = require "neverlose/inspect"

-- Zero-width space
local ZWSP = "\xE2\x80\x8A"

-- Script name
local SCRIPT_NAME = "aesthetic beta"

local SCRIPT_BUILD = "Beta"
local SCRIPT_VERSION = "2.2"

local function merge(...)
    local str = ""

    for i = 1, select('#', ...) do
        str = str .. select(i, ...)
    end

    return str
end

local aux do
    aux = { }

    local UNITS_TO_FOOT = 0.0254 * 3.28084

    function aux.to_foot(units)
        return units * UNITS_TO_FOOT
    end

    function aux.to_keys(list)
        local keys = { }

        for k, v in pairs(list) do
            keys[v] = k
        end

        return keys
    end

    function aux.copy_exclude(list, exclude)
        local keys = aux.to_keys(exclude)

        local tmp = { }
        local count = 0

        for i = 1, #list do
            local value = list[i]

            if keys[value] ~= nil then
                goto continue
            end

            count = count + 1
            tmp[count] = list[i]

            ::continue::
        end

        return tmp, count
    end
end

local debug_overlay do
    debug_overlay = { }

    local Vector = ffi.typeof [[
        struct {
            float x, y, z;
        }
    ]]

    local Color = ffi.typeof [[
        struct {
            uint8_t r, g, b, a;
        }
    ]]

    local native_AddBoxOverlay = utils.get_vfunc(
        "engine.dll", "VDebugOverlay004", 1, ffi.typeof("void(__thiscall*)(void *thisptr, const $ &origin, const $ &mins, const $ &maxs, const $ &angles, int r, int g, int b, int a, float duration)", Vector, Vector, Vector, Vector)
    )

    local native_AddLineOverlayAlpha = utils.get_vfunc(
        "engine.dll", "VDebugOverlay004", 20, ffi.typeof("void(__thiscall*)(void *thisptr, const $ &origin, const $ &dest, int r, int g, int b, int a, bool noDepthTest, float duration)", Vector, Vector)
    )

    local native_AddBoxOverlayNew = utils.get_vfunc(
        "engine.dll", "VDebugOverlay004", 21, "void(__thiscall*)(void *thisptr, const $ &origin, const $ &mins, const $ &maxs, const $ &angles, $ *face_color, $ *edge_color, float duration)", Vector, Vector, Vector, Vector, Color, Color
    )

    function debug_overlay.box(origin, mins, maxs, angles, r, g, b, a, duration)
        origin = Vector(origin:unpack())
        mins = Vector(mins:unpack())
        maxs = Vector(maxs:unpack())
        angles = Vector(angles:unpack())

        native_AddBoxOverlay(origin, mins, maxs, angles, r, g, b, a, duration)
    end

    function debug_overlay.line(origin, dest, col, nodepth, duration)
        origin = Vector(origin:unpack())
        dest = Vector(dest:unpack())

        native_AddLineOverlayAlpha(origin, dest, col.r, col.g, col.b, col.a, nodepth, duration)
    end

    function debug_overlay.box_new(origin, mins, maxs, angles, face_color, edge_color, duration)
        origin = Vector(origin:unpack())
        mins = Vector(mins:unpack())
        maxs = Vector(maxs:unpack())
        angles = Vector(angles:unpack())

        face_color = Color(face_color:unpack())
        edge_color = Color(edge_color:unpack())

        native_AddBoxOverlayNew(origin, mins, maxs, angles, face_color, edge_color, duration)
    end
end

local software do
    software = { }

    software.rage = {
        main = {
            dormant_aimbot = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),

            hide_shots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
            hide_shots_options = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),

            double_tap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
            double_tap_lag_options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),

            peek_assist = {
                ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"),
                ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Style"),
                ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Auto Stop"),
                ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Retreat Mode")
            }
        },

        selection = {
            hit_chance = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"),
            minimum_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage")
        }
    }

    software.antiaim = {
        angles = {
            enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
            pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),

            yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
            yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
            yaw_add = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
            avoid_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
            hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),

            yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
            modifier_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),

            body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
            inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
            left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
            right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
            options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
            freestanding_body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),

            freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
            disable_yaw_modifiers = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
            body_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),

            extended_angles = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"),
            extended_pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"),
            extended_roll = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll")
        },

        fake_lag = {
            enabled = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"),
            limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit")
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
            movement = {
                air_strafe = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe")
            },

            in_game = {
                clan_tag = ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag")
            },

            other = {
                windows = ui.find("Miscellaneous", "Main", "Other", "Windows"),
                log_events = ui.find("Miscellaneous", "Main", "Other", "Log Events"),
                fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency")
            }
        }
    }
end

local icons do
    icons = { }

    local lookup = { }

    function icons.get(icon_name)
        local icon = lookup[icon_name]

        if icon == nil then
            icon = ui.get_icon(icon_name)
            lookup[icon_name] = icon
        end

        return icon
    end
end

local logging do
    logging = { }

    local SOUND_SUCCESS = "ui/beepclear.wav"
    local SOUND_FAILURE = "resource/warning.wav"

    local prefix = merge("\aA0B5DFFF", "aesthetic", "\aDEFAULT")
    local separator = merge("\aABABABFF", " · ", "\aDEFAULT")

    local playvol = cvar.playvol

    function logging.error(...)
        local msg = merge("\aFF0032FF", ...)

        playvol:call(SOUND_FAILURE, 1.0)
        print_raw(prefix .. separator .. msg)
    end

    function logging.success(...)
        local msg = merge("\a9AFF9AFF", ...)

        playvol:call(SOUND_SUCCESS, 1.0)
        print_raw(prefix .. separator .. msg)
    end
end

local configs do
    configs = { }

    local items = { }
    local lookup = { }

    local selector = nil

    local function get_item_value(item)
        local value = { item:get() }

        if item:type() == "color_picker" then
            local list = item:list()

            if list[1] == "" then
                value[1] = value[1]:to_hex()
            else
                local new_value = { }

                for i = 1, #list do
                    local name = list[i]
                    local colors = item:get(name)

                    local result = { }

                    for i = 1, #colors do
                        result[i] = colors[i]:to_hex()
                    end

                    new_value[name] = result
                end

                value = new_value
            end
        end

        return value
    end

    local function set_item_value(item, value)
        if item:type() == "color_picker" then
            if #value ~= 0 then
                item:set(color(value[1]))
                return
            end

            for k, v in pairs(value) do
                local colors = { }

                for i = 1, #v do
                    colors[i] = color(v[i])
                end

                item:set(k, colors)
            end

            return
        end

        item:set(unpack(value))
    end

    local function export_data()
        local data, count = { }, 0

        for i = 1, #items do
            local arr = items[i]

            local name = arr[2]
            local item = arr[3]

            local value = get_item_value(item)

            if value == nil then
                goto continue
            end

            data[name] = value
            ::continue::
        end

        return data, count
    end

    local function import_data(data)
        local count = 0
        local loaded_groups = { }

        for k, v in pairs(data) do
            local params = lookup[k]

            if params == nil then
                goto continue
            end

            local group = params[1]
            local item = params[3]

            if selector ~= nil and not selector:get(group) then
                goto continue
            end

            if item == nil then
                goto continue
            end

            set_item_value(item, v)
            loaded_groups[group] = true

            ::continue::
        end

        for _ in pairs(loaded_groups) do
            count = count + 1
        end

        return count
    end

    local function encode(data)
        local ok, content = pcall(json.stringify, data)

        if not ok then
            return false, "Unable to convert config"
        end

        local ok, str = pcall(base64.encode, content)

        if not ok then
            return false, "Unable to encode config"
        end

        return true, str
    end

    local function decode(str)
        local ok, content = pcall(base64.decode, str)

        if not ok then
            return false, "Unable to decode config"
        end

        local ok, data = pcall(json.parse, content)

        if not ok then
            return false, "Unable to parse config"
        end

        return true, data
    end

    local function load(str)
        if type(str) ~= "string" then
            return false, "Not supported type"
        end

        if str == "" then
            return false, "Config is empty"
        end

        local ok, data = decode(str)

        if not ok then
            return false, data
        end

        local ok, count = pcall(import_data, data)

        if not ok then
            return false, count
        end

        return true, count
    end

    function configs.bind(item)
        selector = item
    end

    function configs.add_item(group, name, item)
        if lookup[name] ~= nil then
            print(name .. " is already added")
        end

        local params = {
            group, name, item
        }

        lookup[name] = params
        table.insert(items, params)

        return item
    end

    function configs.import()
        local ok, str = pcall(clipboard.get)

        if not ok then
            logging.error(str)
            return
        end

        local ok, count = load(str)

        if not ok then
            logging.error(count)
            return
        end

        logging.success("Config loaded, imported ", count, " groups")
    end

    function configs.export_as_string()
        local ok, data = pcall(export_data)

        if not ok then
            return false, data
        end

        local ok, content = encode(data)

        if not ok then
            return false, content
        end

        return true, content
    end

    function configs.export()
        local ok, data = configs.export_as_string()

        if not ok then
            logging.error(data)
            return
        end

        clipboard.set(data)
        logging.success("Config exported to the clipboard")
    end

    function configs.load(str)
        local ok, count = load(str)

        if not ok then
            logging.error(count)
        end

        return ok, count
    end
end

local presets do
    presets = { }

    local DB_NAME = "aesthetic-db"

    local data = db[DB_NAME] or { }

    local pinned_list = { }
    local preset_list = { }

    local trim do
        local match = string.match

        function trim(s)
            return match(s, "^()%s*$")
                and "" or match(s, "^%s*(.*%S)")
        end
    end

    local function create_preset(author, name, time, content)
        local preset = { }

        preset.name = name
        preset.author = author

        preset.content = content

        preset.created_at = time
        preset.updated_at = time

        return preset
    end

    local function create_blank(name)
        local ok, data = configs.export_as_string()

        if not ok then
            return nil
        end

        return create_preset(
            common.get_username(), name, common.get_unixtime(), data
        )
    end

    local function find_by_name(name)
        for i = #preset_list, 1, -1 do
            local preset = preset_list[i]

            if preset.name == name then
                return preset, i
            end
        end

        return nil, -1
    end

    local function save_database()
        db[DB_NAME] = data
    end

    function presets.load(name)
        name = trim(name)

        local selected = find_by_name(name)

        if selected == nil or selected.content == nil then
            return
        end

        local ok, count = configs.load(selected.content)

        if not ok then
            return
        end

        logging.success("Config loaded, imported ", count, " groups")
    end

    function presets.save(name)
        name = trim(name)

        local selected, index = find_by_name(name)

        if selected == nil then
            local config = create_blank(name)

            if config == nil then
                return false, "Unable to create new preset"
            end

            selected = config
            table.insert(data, config)
        end

        if index ~= -1 and index <= #pinned_list then
            return false, "Can't modify in-built preset"
        end

        local ok, content = configs.export_as_string()

        if not ok then
            return false, "Unable to export config"
        end

        selected.content = content
        selected.updated_at = common.get_unixtime()

        save_database()
        return true, nil
    end

    function presets.delete(name)
        name = trim(name)

        local _, index = find_by_name(name)

        if index ~= -1 and index <= #pinned_list then
            return false, "Can't delete in-built preset"
        end

        local data_index = index - #pinned_list
        table.remove(data, data_index)

        return true, nil
    end

    function presets.get(index)
        return preset_list[index]
    end

    function presets.get_list()
        local count = #preset_list

        if count == 0 then
            return { "No availabe presets" }
        end

        local list = { }

        for i = 1, count do
            local preset = preset_list[i]

            local name = preset.name

            if i <= #pinned_list then
                name = name .. "\a{Link Active}" .. "\x20" .. "*"
            end

            list[i] = name
        end

        return list
    end

    function presets.update_data()
        preset_list = { }

        for i = 1, #pinned_list do
            table.insert(preset_list, pinned_list[i])
        end

        table.sort(data, function(a, b)
            return a.name < b.name
        end)

        for i = 1, #data do
            table.insert(preset_list, data[i])
        end
    end

    table.insert(pinned_list, create_preset(
        "HexColor", "Default", 1721306338,
        "eyJBaXIgQ3JvdWNoX0NvdW50ZXItVGVycm9yaXN0X2JvZHlfeWF3IjpbdHJ1ZV0sIkFpciBDcm91Y2hfQ291bnRlci1UZXJyb3Jpc3RfZGVsYXkiOlswLjBdLCJBaXIgQ3JvdWNoX0NvdW50ZXItVGVycm9yaXN0X2VuYWJsZWQiOlt0cnVlXSwiQWlyIENyb3VjaF9Db3VudGVyLVRlcnJvcmlzdF9mcmVlc3RhbmRpbmdfYm9keV95YXciOlsiT2ZmIl0sIkFpciBDcm91Y2hfQ291bnRlci1UZXJyb3Jpc3RfbGVmdF9saW1pdCI6WzYwLjBdLCJBaXIgQ3JvdWNoX0NvdW50ZXItVGVycm9yaXN0X21vZGlmaWVyX29mZnNldCI6WzAuMF0sIkFpciBDcm91Y2hfQ291bnRlci1UZXJyb3Jpc3RfbW9kaWZpZXJfcmFuZG9tIjpbMi4wXSwiQWlyIENyb3VjaF9Db3VudGVyLVRlcnJvcmlzdF9vcHRpb25zIjpbWyJKaXR0ZXIiLCJSYW5kb21pemUgSml0dGVyIl1dLCJBaXIgQ3JvdWNoX0NvdW50ZXItVGVycm9yaXN0X3BpdGNoIjpbIkRvd24iXSwiQWlyIENyb3VjaF9Db3VudGVyLVRlcnJvcmlzdF9yZWNvcmQiOlsiW1tcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl1dIl0sIkFpciBDcm91Y2hfQ291bnRlci1UZXJyb3Jpc3RfcmVjb3JkX2ludmVyc2VfaW52ZXJ0ZXIiOlt0cnVlXSwiQWlyIENyb3VjaF9Db3VudGVyLVRlcnJvcmlzdF9yaWdodF9saW1pdCI6WzYwLjBdLCJBaXIgQ3JvdWNoX0NvdW50ZXItVGVycm9yaXN0X3R5cGUiOlsiRGVmYXVsdCJdLCJBaXIgQ3JvdWNoX0NvdW50ZXItVGVycm9yaXN0X3lhdyI6WyJCYWNrd2FyZCJdLCJBaXIgQ3JvdWNoX0NvdW50ZXItVGVycm9yaXN0X3lhd19iYXNlIjpbIkF0IFRhcmdldCJdLCJBaXIgQ3JvdWNoX0NvdW50ZXItVGVycm9yaXN0X3lhd19tb2RpZmllciI6WyJPZmZzZXQiXSwiQWlyIENyb3VjaF9Db3VudGVyLVRlcnJvcmlzdF95YXdfb2Zmc2V0X2xlZnQiOlstMjQuMF0sIkFpciBDcm91Y2hfQ291bnRlci1UZXJyb3Jpc3RfeWF3X29mZnNldF9yaWdodCI6WzQwLjBdLCJBaXIgQ3JvdWNoX1RlcnJvcmlzdF9ib2R5X3lhdyI6W3RydWVdLCJBaXIgQ3JvdWNoX1RlcnJvcmlzdF9kZWxheSI6WzAuMF0sIkFpciBDcm91Y2hfVGVycm9yaXN0X2VuYWJsZWQiOlt0cnVlXSwiQWlyIENyb3VjaF9UZXJyb3Jpc3RfZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjpbIk9mZiJdLCJBaXIgQ3JvdWNoX1RlcnJvcmlzdF9sZWZ0X2xpbWl0IjpbNjAuMF0sIkFpciBDcm91Y2hfVGVycm9yaXN0X21vZGlmaWVyX29mZnNldCI6WzAuMF0sIkFpciBDcm91Y2hfVGVycm9yaXN0X21vZGlmaWVyX3JhbmRvbSI6WzIuMF0sIkFpciBDcm91Y2hfVGVycm9yaXN0X29wdGlvbnMiOltbIkppdHRlciIsIlJhbmRvbWl6ZSBKaXR0ZXIiXV0sIkFpciBDcm91Y2hfVGVycm9yaXN0X3BpdGNoIjpbIkRvd24iXSwiQWlyIENyb3VjaF9UZXJyb3Jpc3RfcmVjb3JkIjpbIltbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdXSJdLCJBaXIgQ3JvdWNoX1RlcnJvcmlzdF9yZWNvcmRfaW52ZXJzZV9pbnZlcnRlciI6W3RydWVdLCJBaXIgQ3JvdWNoX1RlcnJvcmlzdF9yaWdodF9saW1pdCI6WzYwLjBdLCJBaXIgQ3JvdWNoX1RlcnJvcmlzdF90eXBlIjpbIkRlZmF1bHQiXSwiQWlyIENyb3VjaF9UZXJyb3Jpc3RfeWF3IjpbIkJhY2t3YXJkIl0sIkFpciBDcm91Y2hfVGVycm9yaXN0X3lhd19iYXNlIjpbIkF0IFRhcmdldCJdLCJBaXIgQ3JvdWNoX1RlcnJvcmlzdF95YXdfbW9kaWZpZXIiOlsiT2Zmc2V0Il0sIkFpciBDcm91Y2hfVGVycm9yaXN0X3lhd19vZmZzZXRfbGVmdCI6Wy0xNS4wXSwiQWlyIENyb3VjaF9UZXJyb3Jpc3RfeWF3X29mZnNldF9yaWdodCI6WzQ1LjBdLCJBaXIgQ3JvdWNoX2Vfc3BhbV93aGlsZV9zYWZlX2hlYWQiOltmYWxzZV0sIkFpciBDcm91Y2hfZW5hYmxlZCI6W3RydWVdLCJBaXIgQ3JvdWNoX3BpdGNoIjpbIlN0YXRpYyJdLCJBaXIgQ3JvdWNoX3BpdGNoX29mZnNldCI6Wzg5LjBdLCJBaXIgQ3JvdWNoX3BpdGNoX29mZnNldF8xIjpbODkuMF0sIkFpciBDcm91Y2hfcGl0Y2hfb2Zmc2V0XzIiOlstODkuMF0sIkFpciBDcm91Y2hfeWF3IjpbIjMtV2F5Il0sIkFpciBDcm91Y2hfeWF3X29mZnNldCI6Wy01LjBdLCJDcm91Y2hpbmcgTW92ZV9Db3VudGVyLVRlcnJvcmlzdF9ib2R5X3lhdyI6W2ZhbHNlXSwiQ3JvdWNoaW5nIE1vdmVfQ291bnRlci1UZXJyb3Jpc3RfZGVsYXkiOlswLjBdLCJDcm91Y2hpbmcgTW92ZV9Db3VudGVyLVRlcnJvcmlzdF9lbmFibGVkIjpbdHJ1ZV0sIkNyb3VjaGluZyBNb3ZlX0NvdW50ZXItVGVycm9yaXN0X2ZyZWVzdGFuZGluZ19ib2R5X3lhdyI6WyJPZmYiXSwiQ3JvdWNoaW5nIE1vdmVfQ291bnRlci1UZXJyb3Jpc3RfbGVmdF9saW1pdCI6WzYwLjBdLCJDcm91Y2hpbmcgTW92ZV9Db3VudGVyLVRlcnJvcmlzdF9tb2RpZmllcl9vZmZzZXQiOlswLjBdLCJDcm91Y2hpbmcgTW92ZV9Db3VudGVyLVRlcnJvcmlzdF9tb2RpZmllcl9yYW5kb20iOlswLjBdLCJDcm91Y2hpbmcgTW92ZV9Db3VudGVyLVRlcnJvcmlzdF9vcHRpb25zIjpbW11dLCJDcm91Y2hpbmcgTW92ZV9Db3VudGVyLVRlcnJvcmlzdF9waXRjaCI6WyJEaXNhYmxlZCJdLCJDcm91Y2hpbmcgTW92ZV9Db3VudGVyLVRlcnJvcmlzdF9yZWNvcmQiOlsiW1tcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl1dIl0sIkNyb3VjaGluZyBNb3ZlX0NvdW50ZXItVGVycm9yaXN0X3JlY29yZF9pbnZlcnNlX2ludmVydGVyIjpbdHJ1ZV0sIkNyb3VjaGluZyBNb3ZlX0NvdW50ZXItVGVycm9yaXN0X3JpZ2h0X2xpbWl0IjpbNjAuMF0sIkNyb3VjaGluZyBNb3ZlX0NvdW50ZXItVGVycm9yaXN0X3R5cGUiOlsiUmVjb3JkcyJdLCJDcm91Y2hpbmcgTW92ZV9Db3VudGVyLVRlcnJvcmlzdF95YXciOlsiRGlzYWJsZWQiXSwiQ3JvdWNoaW5nIE1vdmVfQ291bnRlci1UZXJyb3Jpc3RfeWF3X2Jhc2UiOlsiTG9jYWwgVmlldyJdLCJDcm91Y2hpbmcgTW92ZV9Db3VudGVyLVRlcnJvcmlzdF95YXdfbW9kaWZpZXIiOlsiRGlzYWJsZWQiXSwiQ3JvdWNoaW5nIE1vdmVfQ291bnRlci1UZXJyb3Jpc3RfeWF3X29mZnNldF9sZWZ0IjpbMC4wXSwiQ3JvdWNoaW5nIE1vdmVfQ291bnRlci1UZXJyb3Jpc3RfeWF3X29mZnNldF9yaWdodCI6WzAuMF0sIkNyb3VjaGluZyBNb3ZlX1RlcnJvcmlzdF9ib2R5X3lhdyI6W2ZhbHNlXSwiQ3JvdWNoaW5nIE1vdmVfVGVycm9yaXN0X2RlbGF5IjpbMC4wXSwiQ3JvdWNoaW5nIE1vdmVfVGVycm9yaXN0X2VuYWJsZWQiOlt0cnVlXSwiQ3JvdWNoaW5nIE1vdmVfVGVycm9yaXN0X2ZyZWVzdGFuZGluZ19ib2R5X3lhdyI6WyJPZmYiXSwiQ3JvdWNoaW5nIE1vdmVfVGVycm9yaXN0X2xlZnRfbGltaXQiOls2MC4wXSwiQ3JvdWNoaW5nIE1vdmVfVGVycm9yaXN0X21vZGlmaWVyX29mZnNldCI6WzAuMF0sIkNyb3VjaGluZyBNb3ZlX1RlcnJvcmlzdF9tb2RpZmllcl9yYW5kb20iOlswLjBdLCJDcm91Y2hpbmcgTW92ZV9UZXJyb3Jpc3Rfb3B0aW9ucyI6W1tdXSwiQ3JvdWNoaW5nIE1vdmVfVGVycm9yaXN0X3BpdGNoIjpbIkRpc2FibGVkIl0sIkNyb3VjaGluZyBNb3ZlX1RlcnJvcmlzdF9yZWNvcmQiOlsiW1tcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNy4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTI3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMjcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0yNi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdXSJdLCJDcm91Y2hpbmcgTW92ZV9UZXJyb3Jpc3RfcmVjb3JkX2ludmVyc2VfaW52ZXJ0ZXIiOlt0cnVlXSwiQ3JvdWNoaW5nIE1vdmVfVGVycm9yaXN0X3JpZ2h0X2xpbWl0IjpbNjAuMF0sIkNyb3VjaGluZyBNb3ZlX1RlcnJvcmlzdF90eXBlIjpbIlJlY29yZHMiXSwiQ3JvdWNoaW5nIE1vdmVfVGVycm9yaXN0X3lhdyI6WyJEaXNhYmxlZCJdLCJDcm91Y2hpbmcgTW92ZV9UZXJyb3Jpc3RfeWF3X2Jhc2UiOlsiTG9jYWwgVmlldyJdLCJDcm91Y2hpbmcgTW92ZV9UZXJyb3Jpc3RfeWF3X21vZGlmaWVyIjpbIkRpc2FibGVkIl0sIkNyb3VjaGluZyBNb3ZlX1RlcnJvcmlzdF95YXdfb2Zmc2V0X2xlZnQiOlswLjBdLCJDcm91Y2hpbmcgTW92ZV9UZXJyb3Jpc3RfeWF3X29mZnNldF9yaWdodCI6WzAuMF0sIkNyb3VjaGluZyBNb3ZlX2Vfc3BhbV93aGlsZV9zYWZlX2hlYWQiOltmYWxzZV0sIkNyb3VjaGluZyBNb3ZlX2VuYWJsZWQiOlt0cnVlXSwiQ3JvdWNoaW5nIE1vdmVfcGl0Y2giOlsiUmFuZG9tIl0sIkNyb3VjaGluZyBNb3ZlX3BpdGNoX29mZnNldCI6Wy04OS4wXSwiQ3JvdWNoaW5nIE1vdmVfcGl0Y2hfb2Zmc2V0XzEiOlstNjUuMF0sIkNyb3VjaGluZyBNb3ZlX3BpdGNoX29mZnNldF8yIjpbLTQwLjBdLCJDcm91Y2hpbmcgTW92ZV95YXciOlsiU2lkZSBCYXNlZCJdLCJDcm91Y2hpbmcgTW92ZV95YXdfb2Zmc2V0IjpbLTguMF0sIkNyb3VjaGluZ19Db3VudGVyLVRlcnJvcmlzdF9ib2R5X3lhdyI6W2ZhbHNlXSwiQ3JvdWNoaW5nX0NvdW50ZXItVGVycm9yaXN0X2RlbGF5IjpbMC4wXSwiQ3JvdWNoaW5nX0NvdW50ZXItVGVycm9yaXN0X2VuYWJsZWQiOlt0cnVlXSwiQ3JvdWNoaW5nX0NvdW50ZXItVGVycm9yaXN0X2ZyZWVzdGFuZGluZ19ib2R5X3lhdyI6WyJPZmYiXSwiQ3JvdWNoaW5nX0NvdW50ZXItVGVycm9yaXN0X2xlZnRfbGltaXQiOls2MC4wXSwiQ3JvdWNoaW5nX0NvdW50ZXItVGVycm9yaXN0X21vZGlmaWVyX29mZnNldCI6WzAuMF0sIkNyb3VjaGluZ19Db3VudGVyLVRlcnJvcmlzdF9tb2RpZmllcl9yYW5kb20iOlswLjBdLCJDcm91Y2hpbmdfQ291bnRlci1UZXJyb3Jpc3Rfb3B0aW9ucyI6W1tdXSwiQ3JvdWNoaW5nX0NvdW50ZXItVGVycm9yaXN0X3BpdGNoIjpbIkRpc2FibGVkIl0sIkNyb3VjaGluZ19Db3VudGVyLVRlcnJvcmlzdF9yZWNvcmQiOlsiW1tcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdXSJdLCJDcm91Y2hpbmdfQ291bnRlci1UZXJyb3Jpc3RfcmVjb3JkX2ludmVyc2VfaW52ZXJ0ZXIiOlt0cnVlXSwiQ3JvdWNoaW5nX0NvdW50ZXItVGVycm9yaXN0X3JpZ2h0X2xpbWl0IjpbNjAuMF0sIkNyb3VjaGluZ19Db3VudGVyLVRlcnJvcmlzdF90eXBlIjpbIlByZXNldCJdLCJDcm91Y2hpbmdfQ291bnRlci1UZXJyb3Jpc3RfeWF3IjpbIkRpc2FibGVkIl0sIkNyb3VjaGluZ19Db3VudGVyLVRlcnJvcmlzdF95YXdfYmFzZSI6WyJMb2NhbCBWaWV3Il0sIkNyb3VjaGluZ19Db3VudGVyLVRlcnJvcmlzdF95YXdfbW9kaWZpZXIiOlsiRGlzYWJsZWQiXSwiQ3JvdWNoaW5nX0NvdW50ZXItVGVycm9yaXN0X3lhd19vZmZzZXRfbGVmdCI6WzAuMF0sIkNyb3VjaGluZ19Db3VudGVyLVRlcnJvcmlzdF95YXdfb2Zmc2V0X3JpZ2h0IjpbMC4wXSwiQ3JvdWNoaW5nX1RlcnJvcmlzdF9ib2R5X3lhdyI6W2ZhbHNlXSwiQ3JvdWNoaW5nX1RlcnJvcmlzdF9kZWxheSI6WzAuMF0sIkNyb3VjaGluZ19UZXJyb3Jpc3RfZW5hYmxlZCI6W3RydWVdLCJDcm91Y2hpbmdfVGVycm9yaXN0X2ZyZWVzdGFuZGluZ19ib2R5X3lhdyI6WyJPZmYiXSwiQ3JvdWNoaW5nX1RlcnJvcmlzdF9sZWZ0X2xpbWl0IjpbNjAuMF0sIkNyb3VjaGluZ19UZXJyb3Jpc3RfbW9kaWZpZXJfb2Zmc2V0IjpbMC4wXSwiQ3JvdWNoaW5nX1RlcnJvcmlzdF9tb2RpZmllcl9yYW5kb20iOlswLjBdLCJDcm91Y2hpbmdfVGVycm9yaXN0X29wdGlvbnMiOltbXV0sIkNyb3VjaGluZ19UZXJyb3Jpc3RfcGl0Y2giOlsiRGlzYWJsZWQiXSwiQ3JvdWNoaW5nX1RlcnJvcmlzdF9yZWNvcmQiOlsiW1tcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTMxLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzcuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0zMS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM3LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC0zMS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMzEuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTMxLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzNy4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtMzEuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXV0iXSwiQ3JvdWNoaW5nX1RlcnJvcmlzdF9yZWNvcmRfaW52ZXJzZV9pbnZlcnRlciI6W3RydWVdLCJDcm91Y2hpbmdfVGVycm9yaXN0X3JpZ2h0X2xpbWl0IjpbNjAuMF0sIkNyb3VjaGluZ19UZXJyb3Jpc3RfdHlwZSI6WyJQcmVzZXQiXSwiQ3JvdWNoaW5nX1RlcnJvcmlzdF95YXciOlsiRGlzYWJsZWQiXSwiQ3JvdWNoaW5nX1RlcnJvcmlzdF95YXdfYmFzZSI6WyJMb2NhbCBWaWV3Il0sIkNyb3VjaGluZ19UZXJyb3Jpc3RfeWF3X21vZGlmaWVyIjpbIkRpc2FibGVkIl0sIkNyb3VjaGluZ19UZXJyb3Jpc3RfeWF3X29mZnNldF9sZWZ0IjpbMC4wXSwiQ3JvdWNoaW5nX1RlcnJvcmlzdF95YXdfb2Zmc2V0X3JpZ2h0IjpbMC4wXSwiQ3JvdWNoaW5nX2Vfc3BhbV93aGlsZV9zYWZlX2hlYWQiOltmYWxzZV0sIkNyb3VjaGluZ19lbmFibGVkIjpbdHJ1ZV0sIkNyb3VjaGluZ19waXRjaCI6WyJTd2l0Y2giXSwiQ3JvdWNoaW5nX3BpdGNoX29mZnNldCI6WzAuMF0sIkNyb3VjaGluZ19waXRjaF9vZmZzZXRfMSI6Wy01Ny4wXSwiQ3JvdWNoaW5nX3BpdGNoX29mZnNldF8yIjpbLTYwLjBdLCJDcm91Y2hpbmdfeWF3IjpbIlJhbmRvbSJdLCJDcm91Y2hpbmdfeWF3X29mZnNldCI6Wy0xNTMuMF0sIkluIEFpcl9Db3VudGVyLVRlcnJvcmlzdF9ib2R5X3lhdyI6W2ZhbHNlXSwiSW4gQWlyX0NvdW50ZXItVGVycm9yaXN0X2RlbGF5IjpbMC4wXSwiSW4gQWlyX0NvdW50ZXItVGVycm9yaXN0X2VuYWJsZWQiOlt0cnVlXSwiSW4gQWlyX0NvdW50ZXItVGVycm9yaXN0X2ZyZWVzdGFuZGluZ19ib2R5X3lhdyI6WyJPZmYiXSwiSW4gQWlyX0NvdW50ZXItVGVycm9yaXN0X2xlZnRfbGltaXQiOls2MC4wXSwiSW4gQWlyX0NvdW50ZXItVGVycm9yaXN0X21vZGlmaWVyX29mZnNldCI6WzAuMF0sIkluIEFpcl9Db3VudGVyLVRlcnJvcmlzdF9tb2RpZmllcl9yYW5kb20iOlswLjBdLCJJbiBBaXJfQ291bnRlci1UZXJyb3Jpc3Rfb3B0aW9ucyI6W1tdXSwiSW4gQWlyX0NvdW50ZXItVGVycm9yaXN0X3BpdGNoIjpbIkRpc2FibGVkIl0sIkluIEFpcl9Db3VudGVyLVRlcnJvcmlzdF9yZWNvcmQiOlsiW1tcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXV0iXSwiSW4gQWlyX0NvdW50ZXItVGVycm9yaXN0X3JlY29yZF9pbnZlcnNlX2ludmVydGVyIjpbZmFsc2VdLCJJbiBBaXJfQ291bnRlci1UZXJyb3Jpc3RfcmlnaHRfbGltaXQiOls2MC4wXSwiSW4gQWlyX0NvdW50ZXItVGVycm9yaXN0X3R5cGUiOlsiUHJlc2V0Il0sIkluIEFpcl9Db3VudGVyLVRlcnJvcmlzdF95YXciOlsiRGlzYWJsZWQiXSwiSW4gQWlyX0NvdW50ZXItVGVycm9yaXN0X3lhd19iYXNlIjpbIkxvY2FsIFZpZXciXSwiSW4gQWlyX0NvdW50ZXItVGVycm9yaXN0X3lhd19tb2RpZmllciI6WyJEaXNhYmxlZCJdLCJJbiBBaXJfQ291bnRlci1UZXJyb3Jpc3RfeWF3X29mZnNldF9sZWZ0IjpbMC4wXSwiSW4gQWlyX0NvdW50ZXItVGVycm9yaXN0X3lhd19vZmZzZXRfcmlnaHQiOlswLjBdLCJJbiBBaXJfVGVycm9yaXN0X2JvZHlfeWF3IjpbZmFsc2VdLCJJbiBBaXJfVGVycm9yaXN0X2RlbGF5IjpbMC4wXSwiSW4gQWlyX1RlcnJvcmlzdF9lbmFibGVkIjpbdHJ1ZV0sIkluIEFpcl9UZXJyb3Jpc3RfZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjpbIk9mZiJdLCJJbiBBaXJfVGVycm9yaXN0X2xlZnRfbGltaXQiOls2MC4wXSwiSW4gQWlyX1RlcnJvcmlzdF9tb2RpZmllcl9vZmZzZXQiOlswLjBdLCJJbiBBaXJfVGVycm9yaXN0X21vZGlmaWVyX3JhbmRvbSI6WzAuMF0sIkluIEFpcl9UZXJyb3Jpc3Rfb3B0aW9ucyI6W1tdXSwiSW4gQWlyX1RlcnJvcmlzdF9waXRjaCI6WyJEaXNhYmxlZCJdLCJJbiBBaXJfVGVycm9yaXN0X3JlY29yZCI6WyJbW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMzUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwzNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDM1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl1dIl0sIkluIEFpcl9UZXJyb3Jpc3RfcmVjb3JkX2ludmVyc2VfaW52ZXJ0ZXIiOlt0cnVlXSwiSW4gQWlyX1RlcnJvcmlzdF9yaWdodF9saW1pdCI6WzYwLjBdLCJJbiBBaXJfVGVycm9yaXN0X3R5cGUiOlsiUmVjb3JkcyJdLCJJbiBBaXJfVGVycm9yaXN0X3lhdyI6WyJEaXNhYmxlZCJdLCJJbiBBaXJfVGVycm9yaXN0X3lhd19iYXNlIjpbIkxvY2FsIFZpZXciXSwiSW4gQWlyX1RlcnJvcmlzdF95YXdfbW9kaWZpZXIiOlsiRGlzYWJsZWQiXSwiSW4gQWlyX1RlcnJvcmlzdF95YXdfb2Zmc2V0X2xlZnQiOlswLjBdLCJJbiBBaXJfVGVycm9yaXN0X3lhd19vZmZzZXRfcmlnaHQiOlswLjBdLCJJbiBBaXJfZW5hYmxlZCI6W2ZhbHNlXSwiSW4gQWlyX3BpdGNoIjpbIlN0YXRpYyJdLCJJbiBBaXJfcGl0Y2hfb2Zmc2V0IjpbODkuMF0sIkluIEFpcl9waXRjaF9vZmZzZXRfMSI6Wy02MC4wXSwiSW4gQWlyX3BpdGNoX29mZnNldF8yIjpbLTM5LjBdLCJJbiBBaXJfeWF3IjpbIlJhbmRvbSJdLCJJbiBBaXJfeWF3X29mZnNldCI6Wy05LjBdLCJJbiBVc2VfQ291bnRlci1UZXJyb3Jpc3RfYm9keV95YXciOlt0cnVlXSwiSW4gVXNlX0NvdW50ZXItVGVycm9yaXN0X2JvbWJfZV9maXgiOlt0cnVlXSwiSW4gVXNlX0NvdW50ZXItVGVycm9yaXN0X2RlbGF5IjpbMC4wXSwiSW4gVXNlX0NvdW50ZXItVGVycm9yaXN0X2VuYWJsZWQiOlt0cnVlXSwiSW4gVXNlX0NvdW50ZXItVGVycm9yaXN0X2ZyZWVzdGFuZGluZ19ib2R5X3lhdyI6WyJPZmYiXSwiSW4gVXNlX0NvdW50ZXItVGVycm9yaXN0X2xlZnRfbGltaXQiOlswLjBdLCJJbiBVc2VfQ291bnRlci1UZXJyb3Jpc3RfbW9kaWZpZXJfb2Zmc2V0IjpbMC4wXSwiSW4gVXNlX0NvdW50ZXItVGVycm9yaXN0X21vZGlmaWVyX3JhbmRvbSI6WzAuMF0sIkluIFVzZV9Db3VudGVyLVRlcnJvcmlzdF9vcHRpb25zIjpbW11dLCJJbiBVc2VfQ291bnRlci1UZXJyb3Jpc3RfcGl0Y2giOlsiRGlzYWJsZWQiXSwiSW4gVXNlX0NvdW50ZXItVGVycm9yaXN0X3JlY29yZCI6WyIiXSwiSW4gVXNlX0NvdW50ZXItVGVycm9yaXN0X3JlY29yZF9pbnZlcnNlX2ludmVydGVyIjpbZmFsc2VdLCJJbiBVc2VfQ291bnRlci1UZXJyb3Jpc3RfcmlnaHRfbGltaXQiOlswLjBdLCJJbiBVc2VfQ291bnRlci1UZXJyb3Jpc3RfdHlwZSI6WyJEZWZhdWx0Il0sIkluIFVzZV9Db3VudGVyLVRlcnJvcmlzdF95YXciOlsiRGlzYWJsZWQiXSwiSW4gVXNlX0NvdW50ZXItVGVycm9yaXN0X3lhd19iYXNlIjpbIkxvY2FsIFZpZXciXSwiSW4gVXNlX0NvdW50ZXItVGVycm9yaXN0X3lhd19tb2RpZmllciI6WyJEaXNhYmxlZCJdLCJJbiBVc2VfQ291bnRlci1UZXJyb3Jpc3RfeWF3X29mZnNldF9sZWZ0IjpbMC4wXSwiSW4gVXNlX0NvdW50ZXItVGVycm9yaXN0X3lhd19vZmZzZXRfcmlnaHQiOlswLjBdLCJJbiBVc2VfVGVycm9yaXN0X2JvZHlfeWF3IjpbdHJ1ZV0sIkluIFVzZV9UZXJyb3Jpc3RfYm9tYl9lX2ZpeCI6W3RydWVdLCJJbiBVc2VfVGVycm9yaXN0X2RlbGF5IjpbMC4wXSwiSW4gVXNlX1RlcnJvcmlzdF9lbmFibGVkIjpbdHJ1ZV0sIkluIFVzZV9UZXJyb3Jpc3RfZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjpbIk9mZiJdLCJJbiBVc2VfVGVycm9yaXN0X2xlZnRfbGltaXQiOlswLjBdLCJJbiBVc2VfVGVycm9yaXN0X21vZGlmaWVyX29mZnNldCI6WzAuMF0sIkluIFVzZV9UZXJyb3Jpc3RfbW9kaWZpZXJfcmFuZG9tIjpbMC4wXSwiSW4gVXNlX1RlcnJvcmlzdF9vcHRpb25zIjpbW11dLCJJbiBVc2VfVGVycm9yaXN0X3BpdGNoIjpbIkRpc2FibGVkIl0sIkluIFVzZV9UZXJyb3Jpc3RfcmVjb3JkIjpbIiJdLCJJbiBVc2VfVGVycm9yaXN0X3JlY29yZF9pbnZlcnNlX2ludmVydGVyIjpbZmFsc2VdLCJJbiBVc2VfVGVycm9yaXN0X3JpZ2h0X2xpbWl0IjpbMC4wXSwiSW4gVXNlX1RlcnJvcmlzdF90eXBlIjpbIkRlZmF1bHQiXSwiSW4gVXNlX1RlcnJvcmlzdF95YXciOlsiRGlzYWJsZWQiXSwiSW4gVXNlX1RlcnJvcmlzdF95YXdfYmFzZSI6WyJMb2NhbCBWaWV3Il0sIkluIFVzZV9UZXJyb3Jpc3RfeWF3X21vZGlmaWVyIjpbIkRpc2FibGVkIl0sIkluIFVzZV9UZXJyb3Jpc3RfeWF3X29mZnNldF9sZWZ0IjpbMC4wXSwiSW4gVXNlX1RlcnJvcmlzdF95YXdfb2Zmc2V0X3JpZ2h0IjpbMC4wXSwiTW92aW5nX0NvdW50ZXItVGVycm9yaXN0X2JvZHlfeWF3IjpbZmFsc2VdLCJNb3ZpbmdfQ291bnRlci1UZXJyb3Jpc3RfZGVsYXkiOlswLjBdLCJNb3ZpbmdfQ291bnRlci1UZXJyb3Jpc3RfZW5hYmxlZCI6W3RydWVdLCJNb3ZpbmdfQ291bnRlci1UZXJyb3Jpc3RfZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjpbIk9mZiJdLCJNb3ZpbmdfQ291bnRlci1UZXJyb3Jpc3RfbGVmdF9saW1pdCI6WzYwLjBdLCJNb3ZpbmdfQ291bnRlci1UZXJyb3Jpc3RfbW9kaWZpZXJfb2Zmc2V0IjpbMC4wXSwiTW92aW5nX0NvdW50ZXItVGVycm9yaXN0X21vZGlmaWVyX3JhbmRvbSI6WzAuMF0sIk1vdmluZ19Db3VudGVyLVRlcnJvcmlzdF9vcHRpb25zIjpbW11dLCJNb3ZpbmdfQ291bnRlci1UZXJyb3Jpc3RfcGl0Y2giOlsiRGlzYWJsZWQiXSwiTW92aW5nX0NvdW50ZXItVGVycm9yaXN0X3JlY29yZCI6WyJbW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdXSJdLCJNb3ZpbmdfQ291bnRlci1UZXJyb3Jpc3RfcmVjb3JkX2ludmVyc2VfaW52ZXJ0ZXIiOlt0cnVlXSwiTW92aW5nX0NvdW50ZXItVGVycm9yaXN0X3JpZ2h0X2xpbWl0IjpbNjAuMF0sIk1vdmluZ19Db3VudGVyLVRlcnJvcmlzdF90eXBlIjpbIlJlY29yZHMiXSwiTW92aW5nX0NvdW50ZXItVGVycm9yaXN0X3lhdyI6WyJEaXNhYmxlZCJdLCJNb3ZpbmdfQ291bnRlci1UZXJyb3Jpc3RfeWF3X2Jhc2UiOlsiTG9jYWwgVmlldyJdLCJNb3ZpbmdfQ291bnRlci1UZXJyb3Jpc3RfeWF3X21vZGlmaWVyIjpbIkRpc2FibGVkIl0sIk1vdmluZ19Db3VudGVyLVRlcnJvcmlzdF95YXdfb2Zmc2V0X2xlZnQiOlswLjBdLCJNb3ZpbmdfQ291bnRlci1UZXJyb3Jpc3RfeWF3X29mZnNldF9yaWdodCI6WzAuMF0sIk1vdmluZ19UZXJyb3Jpc3RfYm9keV95YXciOltmYWxzZV0sIk1vdmluZ19UZXJyb3Jpc3RfZGVsYXkiOlswLjBdLCJNb3ZpbmdfVGVycm9yaXN0X2VuYWJsZWQiOlt0cnVlXSwiTW92aW5nX1RlcnJvcmlzdF9mcmVlc3RhbmRpbmdfYm9keV95YXciOlsiT2ZmIl0sIk1vdmluZ19UZXJyb3Jpc3RfbGVmdF9saW1pdCI6WzYwLjBdLCJNb3ZpbmdfVGVycm9yaXN0X21vZGlmaWVyX29mZnNldCI6WzAuMF0sIk1vdmluZ19UZXJyb3Jpc3RfbW9kaWZpZXJfcmFuZG9tIjpbMC4wXSwiTW92aW5nX1RlcnJvcmlzdF9vcHRpb25zIjpbW11dLCJNb3ZpbmdfVGVycm9yaXN0X3BpdGNoIjpbIkRpc2FibGVkIl0sIk1vdmluZ19UZXJyb3Jpc3RfcmVjb3JkIjpbIltbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI0LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMzkuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM5LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLC02Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjQuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsLTYyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwzOS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwtNjIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXV0iXSwiTW92aW5nX1RlcnJvcmlzdF9yZWNvcmRfaW52ZXJzZV9pbnZlcnRlciI6W3RydWVdLCJNb3ZpbmdfVGVycm9yaXN0X3JpZ2h0X2xpbWl0IjpbNjAuMF0sIk1vdmluZ19UZXJyb3Jpc3RfdHlwZSI6WyJSZWNvcmRzIl0sIk1vdmluZ19UZXJyb3Jpc3RfeWF3IjpbIkRpc2FibGVkIl0sIk1vdmluZ19UZXJyb3Jpc3RfeWF3X2Jhc2UiOlsiTG9jYWwgVmlldyJdLCJNb3ZpbmdfVGVycm9yaXN0X3lhd19tb2RpZmllciI6WyJEaXNhYmxlZCJdLCJNb3ZpbmdfVGVycm9yaXN0X3lhd19vZmZzZXRfbGVmdCI6WzAuMF0sIk1vdmluZ19UZXJyb3Jpc3RfeWF3X29mZnNldF9yaWdodCI6WzAuMF0sIk1vdmluZ19lbmFibGVkIjpbdHJ1ZV0sIk1vdmluZ19waXRjaCI6WyJTdGF0aWMiXSwiTW92aW5nX3BpdGNoX29mZnNldCI6Wzg5LjBdLCJNb3ZpbmdfcGl0Y2hfb2Zmc2V0XzEiOlswLjBdLCJNb3ZpbmdfcGl0Y2hfb2Zmc2V0XzIiOlswLjBdLCJNb3ZpbmdfeWF3IjpbIlJhbmRvbSJdLCJNb3ZpbmdfeWF3X29mZnNldCI6Wy0xMS4wXSwiU2hhcmVkX0NvdW50ZXItVGVycm9yaXN0X2JvZHlfeWF3IjpbZmFsc2VdLCJTaGFyZWRfQ291bnRlci1UZXJyb3Jpc3RfZGVsYXkiOlswLjBdLCJTaGFyZWRfQ291bnRlci1UZXJyb3Jpc3RfZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjpbIk9mZiJdLCJTaGFyZWRfQ291bnRlci1UZXJyb3Jpc3RfbGVmdF9saW1pdCI6WzYwLjBdLCJTaGFyZWRfQ291bnRlci1UZXJyb3Jpc3RfbW9kaWZpZXJfb2Zmc2V0IjpbMC4wXSwiU2hhcmVkX0NvdW50ZXItVGVycm9yaXN0X21vZGlmaWVyX3JhbmRvbSI6WzAuMF0sIlNoYXJlZF9Db3VudGVyLVRlcnJvcmlzdF9vcHRpb25zIjpbW11dLCJTaGFyZWRfQ291bnRlci1UZXJyb3Jpc3RfcGl0Y2giOlsiRGlzYWJsZWQiXSwiU2hhcmVkX0NvdW50ZXItVGVycm9yaXN0X3JlY29yZCI6WyIiXSwiU2hhcmVkX0NvdW50ZXItVGVycm9yaXN0X3JlY29yZF9pbnZlcnNlX2ludmVydGVyIjpbZmFsc2VdLCJTaGFyZWRfQ291bnRlci1UZXJyb3Jpc3RfcmlnaHRfbGltaXQiOls2MC4wXSwiU2hhcmVkX0NvdW50ZXItVGVycm9yaXN0X3R5cGUiOlsiRGVmYXVsdCJdLCJTaGFyZWRfQ291bnRlci1UZXJyb3Jpc3RfeWF3IjpbIkRpc2FibGVkIl0sIlNoYXJlZF9Db3VudGVyLVRlcnJvcmlzdF95YXdfYmFzZSI6WyJMb2NhbCBWaWV3Il0sIlNoYXJlZF9Db3VudGVyLVRlcnJvcmlzdF95YXdfbW9kaWZpZXIiOlsiRGlzYWJsZWQiXSwiU2hhcmVkX0NvdW50ZXItVGVycm9yaXN0X3lhd19vZmZzZXRfbGVmdCI6WzAuMF0sIlNoYXJlZF9Db3VudGVyLVRlcnJvcmlzdF95YXdfb2Zmc2V0X3JpZ2h0IjpbMC4wXSwiU2hhcmVkX1RlcnJvcmlzdF9ib2R5X3lhdyI6W2ZhbHNlXSwiU2hhcmVkX1RlcnJvcmlzdF9kZWxheSI6WzAuMF0sIlNoYXJlZF9UZXJyb3Jpc3RfZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjpbIk9mZiJdLCJTaGFyZWRfVGVycm9yaXN0X2xlZnRfbGltaXQiOls2MC4wXSwiU2hhcmVkX1RlcnJvcmlzdF9tb2RpZmllcl9vZmZzZXQiOlswLjBdLCJTaGFyZWRfVGVycm9yaXN0X21vZGlmaWVyX3JhbmRvbSI6WzAuMF0sIlNoYXJlZF9UZXJyb3Jpc3Rfb3B0aW9ucyI6W1tdXSwiU2hhcmVkX1RlcnJvcmlzdF9waXRjaCI6WyJEb3duIl0sIlNoYXJlZF9UZXJyb3Jpc3RfcmVjb3JkIjpbIiJdLCJTaGFyZWRfVGVycm9yaXN0X3JlY29yZF9pbnZlcnNlX2ludmVydGVyIjpbZmFsc2VdLCJTaGFyZWRfVGVycm9yaXN0X3JpZ2h0X2xpbWl0IjpbNjAuMF0sIlNoYXJlZF9UZXJyb3Jpc3RfdHlwZSI6WyJEZWZhdWx0Il0sIlNoYXJlZF9UZXJyb3Jpc3RfeWF3IjpbIkJhY2t3YXJkIl0sIlNoYXJlZF9UZXJyb3Jpc3RfeWF3X2Jhc2UiOlsiTG9jYWwgVmlldyJdLCJTaGFyZWRfVGVycm9yaXN0X3lhd19tb2RpZmllciI6WyJEaXNhYmxlZCJdLCJTaGFyZWRfVGVycm9yaXN0X3lhd19vZmZzZXRfbGVmdCI6WzAuMF0sIlNoYXJlZF9UZXJyb3Jpc3RfeWF3X29mZnNldF9yaWdodCI6WzAuMF0sIlNsb3cgV2Fsa19Db3VudGVyLVRlcnJvcmlzdF9ib2R5X3lhdyI6W2ZhbHNlXSwiU2xvdyBXYWxrX0NvdW50ZXItVGVycm9yaXN0X2RlbGF5IjpbMC4wXSwiU2xvdyBXYWxrX0NvdW50ZXItVGVycm9yaXN0X2VuYWJsZWQiOlt0cnVlXSwiU2xvdyBXYWxrX0NvdW50ZXItVGVycm9yaXN0X2ZyZWVzdGFuZGluZ19ib2R5X3lhdyI6WyJPZmYiXSwiU2xvdyBXYWxrX0NvdW50ZXItVGVycm9yaXN0X2xlZnRfbGltaXQiOls2MC4wXSwiU2xvdyBXYWxrX0NvdW50ZXItVGVycm9yaXN0X21vZGlmaWVyX29mZnNldCI6WzAuMF0sIlNsb3cgV2Fsa19Db3VudGVyLVRlcnJvcmlzdF9tb2RpZmllcl9yYW5kb20iOlswLjBdLCJTbG93IFdhbGtfQ291bnRlci1UZXJyb3Jpc3Rfb3B0aW9ucyI6W1tdXSwiU2xvdyBXYWxrX0NvdW50ZXItVGVycm9yaXN0X3BpdGNoIjpbIkRpc2FibGVkIl0sIlNsb3cgV2Fsa19Db3VudGVyLVRlcnJvcmlzdF9yZWNvcmQiOlsiW1tcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjMuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDcuMCxmYWxzZSxmYWxzZSxcIlNwaW5cIiwtNS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdXSJdLCJTbG93IFdhbGtfQ291bnRlci1UZXJyb3Jpc3RfcmVjb3JkX2ludmVyc2VfaW52ZXJ0ZXIiOlt0cnVlXSwiU2xvdyBXYWxrX0NvdW50ZXItVGVycm9yaXN0X3JpZ2h0X2xpbWl0IjpbNjAuMF0sIlNsb3cgV2Fsa19Db3VudGVyLVRlcnJvcmlzdF90eXBlIjpbIlJlY29yZHMiXSwiU2xvdyBXYWxrX0NvdW50ZXItVGVycm9yaXN0X3lhdyI6WyJEaXNhYmxlZCJdLCJTbG93IFdhbGtfQ291bnRlci1UZXJyb3Jpc3RfeWF3X2Jhc2UiOlsiTG9jYWwgVmlldyJdLCJTbG93IFdhbGtfQ291bnRlci1UZXJyb3Jpc3RfeWF3X21vZGlmaWVyIjpbIkRpc2FibGVkIl0sIlNsb3cgV2Fsa19Db3VudGVyLVRlcnJvcmlzdF95YXdfb2Zmc2V0X2xlZnQiOlswLjBdLCJTbG93IFdhbGtfQ291bnRlci1UZXJyb3Jpc3RfeWF3X29mZnNldF9yaWdodCI6WzAuMF0sIlNsb3cgV2Fsa19UZXJyb3Jpc3RfYm9keV95YXciOltmYWxzZV0sIlNsb3cgV2Fsa19UZXJyb3Jpc3RfZGVsYXkiOlswLjBdLCJTbG93IFdhbGtfVGVycm9yaXN0X2VuYWJsZWQiOlt0cnVlXSwiU2xvdyBXYWxrX1RlcnJvcmlzdF9mcmVlc3RhbmRpbmdfYm9keV95YXciOlsiT2ZmIl0sIlNsb3cgV2Fsa19UZXJyb3Jpc3RfbGVmdF9saW1pdCI6WzYwLjBdLCJTbG93IFdhbGtfVGVycm9yaXN0X21vZGlmaWVyX29mZnNldCI6WzAuMF0sIlNsb3cgV2Fsa19UZXJyb3Jpc3RfbW9kaWZpZXJfcmFuZG9tIjpbMC4wXSwiU2xvdyBXYWxrX1RlcnJvcmlzdF9vcHRpb25zIjpbW11dLCJTbG93IFdhbGtfVGVycm9yaXN0X3BpdGNoIjpbIkRpc2FibGVkIl0sIlNsb3cgV2Fsa19UZXJyb3Jpc3RfcmVjb3JkIjpbIltbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTIzLjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQ3LjAsZmFsc2UsZmFsc2UsXCJTcGluXCIsLTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXV0iXSwiU2xvdyBXYWxrX1RlcnJvcmlzdF9yZWNvcmRfaW52ZXJzZV9pbnZlcnRlciI6W3RydWVdLCJTbG93IFdhbGtfVGVycm9yaXN0X3JpZ2h0X2xpbWl0IjpbNjAuMF0sIlNsb3cgV2Fsa19UZXJyb3Jpc3RfdHlwZSI6WyJSZWNvcmRzIl0sIlNsb3cgV2Fsa19UZXJyb3Jpc3RfeWF3IjpbIkRpc2FibGVkIl0sIlNsb3cgV2Fsa19UZXJyb3Jpc3RfeWF3X2Jhc2UiOlsiTG9jYWwgVmlldyJdLCJTbG93IFdhbGtfVGVycm9yaXN0X3lhd19tb2RpZmllciI6WyJEaXNhYmxlZCJdLCJTbG93IFdhbGtfVGVycm9yaXN0X3lhd19vZmZzZXRfbGVmdCI6WzAuMF0sIlNsb3cgV2Fsa19UZXJyb3Jpc3RfeWF3X29mZnNldF9yaWdodCI6WzAuMF0sIlNsb3cgV2Fsa19lbmFibGVkIjpbZmFsc2VdLCJTbG93IFdhbGtfcGl0Y2giOlsiU3RhdGljIl0sIlNsb3cgV2Fsa19waXRjaF9vZmZzZXQiOlswLjBdLCJTbG93IFdhbGtfcGl0Y2hfb2Zmc2V0XzEiOlswLjBdLCJTbG93IFdhbGtfcGl0Y2hfb2Zmc2V0XzIiOlswLjBdLCJTbG93IFdhbGtfeWF3IjpbIlNpZGUgQmFzZWQiXSwiU2xvdyBXYWxrX3lhd19vZmZzZXQiOlswLjBdLCJTdGFuZGluZ19Db3VudGVyLVRlcnJvcmlzdF9ib2R5X3lhdyI6W2ZhbHNlXSwiU3RhbmRpbmdfQ291bnRlci1UZXJyb3Jpc3RfZGVsYXkiOlswLjBdLCJTdGFuZGluZ19Db3VudGVyLVRlcnJvcmlzdF9lbmFibGVkIjpbdHJ1ZV0sIlN0YW5kaW5nX0NvdW50ZXItVGVycm9yaXN0X2ZyZWVzdGFuZGluZ19ib2R5X3lhdyI6WyJPZmYiXSwiU3RhbmRpbmdfQ291bnRlci1UZXJyb3Jpc3RfbGVmdF9saW1pdCI6WzYwLjBdLCJTdGFuZGluZ19Db3VudGVyLVRlcnJvcmlzdF9tb2RpZmllcl9vZmZzZXQiOlswLjBdLCJTdGFuZGluZ19Db3VudGVyLVRlcnJvcmlzdF9tb2RpZmllcl9yYW5kb20iOlswLjBdLCJTdGFuZGluZ19Db3VudGVyLVRlcnJvcmlzdF9vcHRpb25zIjpbW11dLCJTdGFuZGluZ19Db3VudGVyLVRlcnJvcmlzdF9waXRjaCI6WyJEaXNhYmxlZCJdLCJTdGFuZGluZ19Db3VudGVyLVRlcnJvcmlzdF9yZWNvcmQiOlsiW1tcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdXSJdLCJTdGFuZGluZ19Db3VudGVyLVRlcnJvcmlzdF9yZWNvcmRfaW52ZXJzZV9pbnZlcnRlciI6W2ZhbHNlXSwiU3RhbmRpbmdfQ291bnRlci1UZXJyb3Jpc3RfcmlnaHRfbGltaXQiOls2MC4wXSwiU3RhbmRpbmdfQ291bnRlci1UZXJyb3Jpc3RfdHlwZSI6WyJSZWNvcmRzIl0sIlN0YW5kaW5nX0NvdW50ZXItVGVycm9yaXN0X3lhdyI6WyJEaXNhYmxlZCJdLCJTdGFuZGluZ19Db3VudGVyLVRlcnJvcmlzdF95YXdfYmFzZSI6WyJMb2NhbCBWaWV3Il0sIlN0YW5kaW5nX0NvdW50ZXItVGVycm9yaXN0X3lhd19tb2RpZmllciI6WyJEaXNhYmxlZCJdLCJTdGFuZGluZ19Db3VudGVyLVRlcnJvcmlzdF95YXdfb2Zmc2V0X2xlZnQiOlswLjBdLCJTdGFuZGluZ19Db3VudGVyLVRlcnJvcmlzdF95YXdfb2Zmc2V0X3JpZ2h0IjpbMC4wXSwiU3RhbmRpbmdfVGVycm9yaXN0X2JvZHlfeWF3IjpbZmFsc2VdLCJTdGFuZGluZ19UZXJyb3Jpc3RfZGVsYXkiOlswLjBdLCJTdGFuZGluZ19UZXJyb3Jpc3RfZW5hYmxlZCI6W3RydWVdLCJTdGFuZGluZ19UZXJyb3Jpc3RfZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjpbIk9mZiJdLCJTdGFuZGluZ19UZXJyb3Jpc3RfbGVmdF9saW1pdCI6WzYwLjBdLCJTdGFuZGluZ19UZXJyb3Jpc3RfbW9kaWZpZXJfb2Zmc2V0IjpbMC4wXSwiU3RhbmRpbmdfVGVycm9yaXN0X21vZGlmaWVyX3JhbmRvbSI6WzAuMF0sIlN0YW5kaW5nX1RlcnJvcmlzdF9vcHRpb25zIjpbW11dLCJTdGFuZGluZ19UZXJyb3Jpc3RfcGl0Y2giOlsiRGlzYWJsZWQiXSwiU3RhbmRpbmdfVGVycm9yaXN0X3JlY29yZCI6WyJbW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTQuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01OS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01Mi4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTUyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTguMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01NS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01NC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU5LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU5LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTMuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01Ni4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01My4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTkuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01Ni4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01OS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTUyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTYwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTMuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01NC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC02MC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTUyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTUyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTMuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01NC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01NS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU0LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTguMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01NC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU4LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTUyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01Ni4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01Ni4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU4LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU3LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNjAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01Mi4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01OC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTUzLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTYuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01My4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01NS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTUyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTkuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTguMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01Ni4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC02MC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU0LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNjAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTUuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC02MC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01OS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU5LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTUyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTQuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01OC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01My4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTYwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTUyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01Ny4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC02MC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU2LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTUyLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNjAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNjAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01Ni4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01Ni4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTUzLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTYwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTMuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01NC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01OS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU3LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTUzLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTIuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01My4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC02MC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTYuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTkuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01OC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01NS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU0LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTkuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTguMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01My4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC02MC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTUzLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU5LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTkuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNjAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01Ni4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01OS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU1LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU1LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTUuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTcuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01NS4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01NC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU4LjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTYwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTcuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTkuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01Ny4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01NC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTUyLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU2LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNjAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTguMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01Ny4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsMTAuMCxmYWxzZSxmYWxzZSxcIkNlbnRlclwiLC01OS4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTUzLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwxMC4wLGZhbHNlLGZhbHNlLFwiQ2VudGVyXCIsLTU0LjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTIuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDEwLjAsZmFsc2UsZmFsc2UsXCJDZW50ZXJcIiwtNTguMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtcIkppdHRlclwiXSxcIk9mZlwiXV0iXSwiU3RhbmRpbmdfVGVycm9yaXN0X3JlY29yZF9pbnZlcnNlX2ludmVydGVyIjpbZmFsc2VdLCJTdGFuZGluZ19UZXJyb3Jpc3RfcmlnaHRfbGltaXQiOls2MC4wXSwiU3RhbmRpbmdfVGVycm9yaXN0X3R5cGUiOlsiUmVjb3JkcyJdLCJTdGFuZGluZ19UZXJyb3Jpc3RfeWF3IjpbIkRpc2FibGVkIl0sIlN0YW5kaW5nX1RlcnJvcmlzdF95YXdfYmFzZSI6WyJMb2NhbCBWaWV3Il0sIlN0YW5kaW5nX1RlcnJvcmlzdF95YXdfbW9kaWZpZXIiOlsiRGlzYWJsZWQiXSwiU3RhbmRpbmdfVGVycm9yaXN0X3lhd19vZmZzZXRfbGVmdCI6WzAuMF0sIlN0YW5kaW5nX1RlcnJvcmlzdF95YXdfb2Zmc2V0X3JpZ2h0IjpbMC4wXSwiU3RhbmRpbmdfZV9zcGFtX3doaWxlX3NhZmVfaGVhZCI6W2ZhbHNlXSwiU3RhbmRpbmdfZW5hYmxlZCI6W2ZhbHNlXSwiU3RhbmRpbmdfcGl0Y2giOlsiU3RhdGljIl0sIlN0YW5kaW5nX3BpdGNoX29mZnNldCI6Wzg5LjBdLCJTdGFuZGluZ19waXRjaF9vZmZzZXRfMSI6WzAuMF0sIlN0YW5kaW5nX3BpdGNoX29mZnNldF8yIjpbMC4wXSwiU3RhbmRpbmdfeWF3IjpbIlJhbmRvbSJdLCJTdGFuZGluZ195YXdfb2Zmc2V0IjpbLTE4MC4wXSwiYWlfcGVlay1jb2xvciI6WyI5M0JCQzY5MiJdLCJhaV9wZWVrLWhpdGJveGVzIjpbWyJDaGVzdCIsIlN0b21hY2giXV0sImFpX3BlZWstaGl0Y2hhbmNlIjpbMzUuMF0sImFpX3BlZWstb3B0aW9ucyI6W1siVW5zYWZlIE1vZGUiLCJPbmx5IFdpdGggRFQiXV0sImFpX3BlZWstcmF0ZV9saW1pdCI6WzIuMF0sImFpX3BlZWstc2ltdWxhdGlvbiI6WzMwLjBdLCJhaV9wZWVrLXdlYXBvbnMiOltbIlNTRy0wOCIsIkRlYWdsZSIsIlBpc3RvbHMiXV0sImFpbWJvdF9sb2dzLXNlbGVjdCI6W1siQWltYm90IiwiUHVyY2hhc2VzIl1dLCJhbmdsZXMtZW5hYmxlZCI6W3RydWVdLCJhbmltYXRpb25zLWFpcl9sZWdzIjpbIkRpc2FibGVkIl0sImFuaW1hdGlvbnMtYWlyX2xlZ3Nfd2VpZ2h0IjpbMTAwLjBdLCJhbmltYXRpb25zLWVuYWJsZWQiOltmYWxzZV0sImFuaW1hdGlvbnMtZ3JvdW5kX2xlZ3MiOlsiRGlzYWJsZWQiXSwiYW5pbWF0aW9ucy1sZWdzX29mZnNldF8xIjpbMTAwLjBdLCJhbmltYXRpb25zLWxlZ3Nfb2Zmc2V0XzIiOlsxMDAuMF0sImFuaW1hdGlvbnMtbW92ZV9sZWFuIjpbNzguMF0sImFuaW1hdGlvbnMtcGl0Y2hfb25fbGFuZCI6WyJEaXNhYmxlZCJdLCJhc3BlY3RfcmF0aW8tZW5hYmxlZCI6W3RydWVdLCJhc3BlY3RfcmF0aW8tcHJvcG9ydGlvbiI6WzEyOC4wXSwiYXZvaWRfYmFja3N0YWItZW5hYmxlZCI6W3RydWVdLCJicmVha19sYy1jb25kaXRpb25zIjpbWyJDcm91Y2hpbmciLCJDcm91Y2hpbmcgTW92ZSIsIkFpciBDcm91Y2giXV0sImJyZWFrX2xjLWRpc2FibGVycyI6W1siUGluIFB1bGxlZCIsIkhvbGRpbmcgR3JlbmFkZSJdXSwiYnJlYWtfbGMtZW5hYmxlZCI6W3RydWVdLCJicmVha19sYy10cmlnZ2VycyI6W1siV2VhcG9uIFN3aXRjaCIsIkZsYXNoZWQiLCJSZWxvYWRpbmciLCJGbGluY2hpbmciXV0sImRhbWFnZV9pbmRpY2F0b3ItY29sb3IiOlsiRkZGRkZGRkYiXSwiZGFtYWdlX2luZGljYXRvci1lbmFibGVkIjpbZmFsc2VdLCJkYW1hZ2VfaW5kaWNhdG9yLWZvbnQiOlsiRGVmYXVsdCJdLCJkZWZlbnNpdmUtY29uZGl0aW9uIjpbIkFpciBDcm91Y2giXSwiZGVmZW5zaXZlLWRpc2FibGVycyI6W1siRnJlZXN0YW5kaW5nIiwiTWFudWFscyJdXSwiZGVmZW5zaXZlLWVuYWJsZWQiOlt0cnVlXSwiZGlzYWJsZV9mYWtlbGFnLWVuYWJsZWQiOltmYWxzZV0sImRpc2FibGVfZmFrZWxhZy1zZWxlY3QiOltbXV0sImRvcm1hbnRfYWltYm90LWF1dG9fc2NvcGUiOlt0cnVlXSwiZG9ybWFudF9haW1ib3QtZW5hYmxlZCI6W3RydWVdLCJkb3JtYW50X2FpbWJvdC1oaXRib3hlcyI6W1siSGVhZCIsIkNoZXN0IiwiU3RvbWFjaCJdXSwiZG9ybWFudF9haW1ib3QtaGl0Y2hhbmNlIjpbNzAuMF0sImRvcm1hbnRfYWltYm90LW1pbmltdW1fZGFtYWdlIjpbMC4wXSwiZmFrZV9sYXRlbmN5LWVuYWJsZWQiOltmYWxzZV0sImZha2VfbGF0ZW5jeS12YWx1ZSI6WzEyMi4wXSwiZmFzdF9sYWRkZXItZW5hYmxlZCI6W3RydWVdLCJmcmVlc3RhbmRpbmctZGlzYWJsZXJzIjpbW11dLCJmcmVlc3RhbmRpbmctdHdlYWtzIjpbWyJEaXNhYmxlIFlhdyBNb2RpZmllcnMiXV0sImdyZW5hZGVfdmlzdWFscy1lbmFibGVkIjpbdHJ1ZV0sImdyZW5hZGVfdmlzdWFscy1wcmVkaWN0aW9uIjpbdHJ1ZV0sImdyZW5hZGVfdmlzdWFscy1wcm94aW1pdHlfd2FybmluZyI6W2ZhbHNlXSwiaGl0X21hcmtlci1kYW1hZ2UtY29sb3IiOnsiQm9keSI6WyI5NDk0OTRFMyJdLCJIZWFkIjpbIjkxNkY2RkUzIl0sIk1pc21hdGNoIjpbIjk3OTc5N0UzIl19LCJoaXRfbWFya2VyLWRhbWFnZS1kdXJhdGlvbiI6WzMuMF0sImhpdF9tYXJrZXItZGFtYWdlLWVuYWJsZWQiOlt0cnVlXSwiaGl0X21hcmtlci1kYW1hZ2Utc3BlZWQiOlsxMjguMF0sImhpdF9tYXJrZXItZW5hYmxlZCI6W3RydWVdLCJoaXRfbWFya2VyLXNjcmVlbi1jb2xvciI6WyJGRkZGRkZGRiJdLCJoaXRfbWFya2VyLXNjcmVlbi1lbmFibGVkIjpbZmFsc2VdLCJoaXRfbWFya2VyLXdvcmxkLWNvbG9yIjp7Ikhvcml6b250YWwiOlsiMDBGRkZGRkYiXSwiVmVydGljYWwiOlsiMDBGRjAwRkYiXX0sImhpdF9tYXJrZXItd29ybGQtZW5hYmxlZCI6W3RydWVdLCJoaXRfbWFya2VyLXdvcmxkLXNpemUiOlszLjBdLCJoaXRfbWFya2VyLXdvcmxkLXRoaWNrbmVzcyI6WzEuMF0sImhpdGNoYW5jZS1lbmFibGVkIjpbdHJ1ZV0sImhpdGNoYW5jZV9BV1BfZGlzdGFuY2UiOlszNTQuMF0sImhpdGNoYW5jZV9BV1BfaW5fYWlyIjpbLTEuMF0sImhpdGNoYW5jZV9BV1Bfbm9fc2NvcGUiOlstMS4wXSwiaGl0Y2hhbmNlX0F1dG9TbmlwZXJzX2Rpc3RhbmNlIjpbNDE4LjBdLCJoaXRjaGFuY2VfQXV0b1NuaXBlcnNfaW5fYWlyIjpbLTEuMF0sImhpdGNoYW5jZV9BdXRvU25pcGVyc19ub19zY29wZSI6WzQ1LjBdLCJoaXRjaGFuY2VfUGlzdG9sc19pbl9haXIiOlszNS4wXSwiaGl0Y2hhbmNlX1I4IFJldm9sdmVyX2luX2FpciI6WzM4LjBdLCJoaXRjaGFuY2VfU1NHLTA4X2Rpc3RhbmNlIjpbMzI1LjBdLCJoaXRjaGFuY2VfU1NHLTA4X2luX2FpciI6WzQ4LjBdLCJoaXRjaGFuY2VfU1NHLTA4X2p1bXBfc2NvdXQiOlt0cnVlXSwiaGl0Y2hhbmNlX1NTRy0wOF9ub19zY29wZSI6Wy0xLjBdLCJraWxsX3NheS1kaXNhYmxlcnMiOltbIk9uIFdhcm11cCJdXSwia2lsbF9zYXktZW5hYmxlZCI6W3RydWVdLCJraWxsX3NheS10cmlnZ2VycyI6W1siT24gS2lsbCIsIk9uIERlYXRoIl1dLCJtYW51YWxfeWF3LWFycm93cyI6WyJDbGFzc2ljIl0sIm1hbnVhbF95YXctY29sb3IiOnsiQXJyb3dzIjpbIkZGRkZGRkZGIl0sIkRlc3luYyI6WyIyMzgwRkZGRiJdfSwibWFudWFsX3lhdy1tYW51YWxfZWRnZSI6W3RydWVdLCJtYW51YWxfeWF3LXN0YXRpY19tYW51YWxzIjpbdHJ1ZV0sIm5vX2ZhbGxfZGFtYWdlLWVuYWJsZWQiOlt0cnVlXSwicGVuZXRyYXRpb25faW5kaWNhdG9yLWNvbG9yIjpbIkZGRkZGRkZGIl0sInBlbmV0cmF0aW9uX2luZGljYXRvci1lbmFibGVkIjpbZmFsc2VdLCJwZW5ldHJhdGlvbl9pbmRpY2F0b3ItZm9udCI6WyJEZWZhdWx0Il0sInNhZmVfaGVhZC1jb25kaXRpb25zIjpbWzIuMCw0LjAsNS4wLDYuMF1dLCJzYWZlX2hlYWQtZW5hYmxlZCI6W3RydWVdLCJzY29wZV9vdmVybGF5LWNvbG9yIjpbIkJGQkVCRUFCIl0sInNjb3BlX292ZXJsYXktZW5hYmxlZCI6W3RydWVdLCJzY29wZV9vdmVybGF5LWV4Y2x1ZGUiOltbXV0sInNjb3BlX292ZXJsYXktb2Zmc2V0IjpbNi4wXSwic2NvcGVfb3ZlcmxheS1wb3NpdGlvbiI6WzE5NC4wXSwic3VwZXJfdG9zcy1lbmFibGVkIjpbdHJ1ZV0sInZpZXdtb2RlbC1lbmFibGVkIjpbdHJ1ZV0sInZpZXdtb2RlbC1mb3YiOls1NzAuMF0sInZpZXdtb2RlbC1vZmZzZXRfeCI6WzAuMF0sInZpZXdtb2RlbC1vZmZzZXRfeSI6WzEwLjBdLCJ2aWV3bW9kZWwtb2Zmc2V0X3oiOlsxMC4wXSwidmlld21vZGVsLW9wcG9zaXRlX2tuaWZlX2hhbmQiOltmYWxzZV0sIndhdGVybWFyay1jb2xvciI6eyJEdW8iOlsiMjgyODI4RkYiLCJGRkZGRkZGRiJdLCJTaW5nbGUiOlsiRkZGRkZGRkYiXX0sIndhdGVybWFyay1yZW1vdmFscyI6W1siQW5pbWF0aW9uIiwiU2hhZG93Il1dfQ=="
    ))

    presets.update_data()
    events.shutdown(save_database)
end

local resource do
    resource = { }

    local COLUMN_LEFT = 1
    local COLUMN_RIGHT = 2

    local function get_space(count)
        return string.rep(ZWSP, count)
    end

    local function add_space(text, count)
        local space = string.rep(ZWSP, count)
        local result = space .. text .. space

        return result
    end

    local function create_link(url)
        return function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL(url)
        end
    end

    local general = { } do
        local TAB = icons.get "house-blank"

        local groups = { } do
            groups.profile = ui.create(TAB, "Profile", COLUMN_LEFT)
            groups.recommendations = ui.create(TAB, "Recommendations", COLUMN_LEFT)
            groups.config = ui.create(TAB, "Config", COLUMN_RIGHT)
        end

        local main = { } do
            groups.profile:label(
                merge("\a{Link Active}", get_space(1), icons.get "user", "\aDEFAULT", get_space(7), common.get_username())
            )

            groups.profile:label(
                merge("\a{Link Active}", get_space(1), icons.get "code-branch", "\aDEFAULT", get_space(7), SCRIPT_VERSION, get_space(3), "\a{Link Active}", SCRIPT_BUILD)
            )
        end

        local config = { } do
            local list = {
                "Anti-Aim",
                "Ragebot",
                "Visuals",
                "Movement",
                "Hotkeys"
            }

            local preset_list = groups.config:list("##PRESET_LIST", presets.get_list())
            local preset_name = groups.config:input("##PRESET_NAME", "Default")

            local select = groups.config:selectable("Categories", list)

            groups.config:button(add_space(merge("\a{Link Active}", icons.get "play", get_space(3), "\aDEFAULT", "Load"), 3), function()
                presets.load(preset_name:get())
            end, true)

            groups.config:button(add_space(merge("\a{Link Active}", icons.get "floppy-disk", get_space(3), "\aDEFAULT", "Save"), 3), function()
                presets.save(preset_name:get())
                presets.update_data()

                preset_list:update(presets.get_list())
            end, true)

            groups.config:button(add_space(merge("\aFF3232FF", icons.get "trash"), 4), function()
                presets.delete(preset_name:get())
                presets.update_data()

                preset_list:update(presets.get_list())
            end, true):tooltip("Deletes selected preset.")

            groups.config:button(add_space(icons.get "copy", 3), configs.export, true)
                :tooltip("Exports current preset to clipboard.")

            groups.config:button(add_space(icons.get "clipboard", 3), configs.import, true)
                :tooltip("Imports preset from clipboard.")

            preset_list:set_callback(function(item)
                local value = item:get()

                if value == nil or value <= 0 then
                    return
                end

                local preset = presets.get(value)

                if preset == nil then
                    return
                end

                preset_name:set(preset.name)
            end)

            configs.bind(select)
        end

        local recommendations = { } do
            groups.recommendations:label("Themes") do
                groups.recommendations:button(
                    merge(get_space(1), "\aFFFFFFFF", icons.get "circle", get_space(1), "##THEME_1"), create_link("https://neverlose.cc/getitem?c=Dk6aTerwXWo8okd4-h1AAugwIKH"), true
                ):tooltip("Aesthetic Steel")

                groups.recommendations:button(
                    merge(get_space(1), "\aEA5A5AFF", icons.get "circle", get_space(1), "##THEME_2"), create_link("https://neverlose.cc/getitem?c=zoT0ayPWOpgr1hwN-1K8TUG1Ric"), true
                ):tooltip("Aesthetic Ruby")

                groups.recommendations:button(
                    merge(get_space(1), "\a686D9DFF", icons.get "circle", get_space(1), "##THEME_3"), create_link("https://neverlose.cc/getitem?c=mSshx653pi3TyLcT-D7-D8mi2uK"), true
                ):tooltip("Aesthetic Sapphire")
            end

            groups.recommendations:label("Configs") do
                groups.recommendations:button(
                    merge(get_space(2), "\a80AAFFFF", icons.get "user", "\aDEFAULT", get_space(3), "Stable", get_space(1), "##CONFIG_1"), create_link("https://market.neverlose.cc/7cTn9F"), true
                ):tooltip("Shameless's Stable Config")

                groups.recommendations:button(
                    merge(get_space(2), "\aFFFF60FF", icons.get "user-crown", "\aDEFAULT", get_space(3), "Beta", get_space(1), "##CONFIG_2"), create_link("https://market.neverlose.cc/oxyF4G"), true
                ):tooltip("Shameless's Beta Config")
            end

            groups.recommendations:label("Links") do
                groups.recommendations:button(
                    merge(get_space(2), "\aD71E21FF", icons.get "youtube", "\aDEFAULT", get_space(3), "YouTube", get_space(1), "##LINK_1"), create_link("http://dsc.gg/fastleakss"), true
                ):tooltip("Youtube Channel")

                groups.recommendations:button(
                    merge(get_space(2), "\a5662F6FF", icons.get "discord", "\aDEFAULT", get_space(3), "Discord", get_space(1), "##LINK_2"), create_link("http://dsc.gg/fastleakss"), true
                ):tooltip("discord server")
            end
        end

        resource.general = general
    end

    local antiaim = { } do
        local TAB = icons.get "shield"

        local list = {
            "Shared",
            "Standing",
            "Moving",
            "Slow Walk",
            "Crouching",
            "Crouching Move",
            "In Air",
            "Air Crouch",
            "In Use"
        }

        local teams = {
            "Terrorist",
            "Counter-Terrorist"
        }

        local groups = { } do
            groups.angles = ui.create(TAB, "Angles", COLUMN_LEFT)
            groups.builder = ui.create(TAB, "##BUILDER", COLUMN_LEFT)
            groups.recorder = ui.create(TAB, "##RECORDER", COLUMN_LEFT)

            groups.extra = ui.create(TAB, "Extra", COLUMN_RIGHT)
            groups.hotkeys = ui.create(TAB, "Hotkeys", COLUMN_RIGHT)
        end

        local freestanding = { } do
            freestanding.label = groups.hotkeys:label(
                merge("\a{Link Active}", get_space(1), icons.get "compass-drafting", get_space(6), "\aDEFAULT", "Freestanding")
            )

            local group = freestanding.label:create() do
                freestanding.enabled = group:switch("Freestanding")

                freestanding.disablers = configs.add_item("Hotkeys", "freestanding-disablers",
                    group:selectable("Disablers", {
                        "Standing",
                        "Moving",
                        "Slow Walk",
                        "Crouching",
                        "Crouching Move",
                        "In Air",
                        "Air Crouch"
                    })
                )

                freestanding.tweaks = configs.add_item("Hotkeys", "freestanding-tweaks",
                    group:selectable("Tweaks", {
                        "Disable Yaw Modifiers",
                        "Freestanding Body Yaw"
                    })
                )
            end

            antiaim.freestanding = freestanding
        end

        local manual_yaw = { } do
            manual_yaw.label = groups.hotkeys:label(
                merge("\a{Link Active}", get_space(1), icons.get "arrows-left-right", get_space(6), "\aDEFAULT", "Manual Yaw")
            )

            local group = manual_yaw.label:create() do
                manual_yaw.option = group:combo("Manual Yaw", {
                    "Disabled",
                    "Left",
                    "Right",
                    "Backward",
                    "Forward"
                })

                manual_yaw.arrows = configs.add_item("Hotkeys", "manual_yaw-arrows",
                    group:combo("Arrows", {
                        "Disabled",
                        "Classic",
                        "Modern",
                        "Team-Skeet"
                    })
                )

                manual_yaw.color = configs.add_item("Hotkeys", "manual_yaw-color",
                    manual_yaw.arrows:color_picker({
                        ["Arrows"] = { color(175, 255, 55, 255) },
                        ["Desync"] = { color(35, 128, 255, 255) }
                    })
                )

                manual_yaw.manual_edge = configs.add_item("Hotkeys", "manual_yaw-manual_edge",
                    group:switch("Edge bait")
                )

                manual_yaw.static_manuals = configs.add_item("Hotkeys", "manual_yaw-static_manuals",
                    group:switch("Static Manuals")
                )
            end

            antiaim.manual_yaw = manual_yaw
        end

        local avoid_backstab = { } do
            avoid_backstab.enabled = configs.add_item("Anti-Aim", "avoid_backstab-enabled", groups.extra:switch(
                merge("\a{Link Active}", get_space(1), icons.get "knife-kitchen", get_space(6), "\aDEFAULT", "Avoid Backstab")
            ))

            antiaim.avoid_backstab = avoid_backstab
        end

        local animations = { } do
            animations.enabled = configs.add_item("Anti-Aim", "animations-enabled", groups.extra:switch(
                merge("\a{Link Active}", get_space(1), icons.get "sparkles", get_space(7), "\aDEFAULT", "Animations")
            ))

            local group = animations.enabled:create() do
                animations.air_legs = configs.add_item("Anti-Aim", "animations-air_legs",
                    group:combo("Air Legs", {
                        "Disabled",
                        "Static",
                        "Moonwalk"
                    })
                )

                animations.air_legs_weight = configs.add_item("Anti-Aim", "animations-air_legs_weight",
                    group:slider("Weight", 0, 100, 100, nil, "%")
                )

                animations.ground_legs = configs.add_item("Anti-Aim", "animations-ground_legs",
                    group:combo("Ground Legs", {
                        "Disabled",
                        "Static",
                        "Jitter",
                        "Moonwalk"
                    })
                )

                animations.legs_offset_1 = configs.add_item("Anti-Aim", "animations-legs_offset_1",
                    group:slider("Legs Offset [1]", 0, 100, 100)
                )

                animations.legs_offset_2 = configs.add_item("Anti-Aim", "animations-legs_offset_2",
                    group:slider("Legs Offset [2]", 0, 100, 100)
                )

                animations.pitch_on_land = configs.add_item("Anti-Aim", "animations-pitch_on_land",
                    group:combo("Pitch on Land", {
                        "Disabled",
                        "Pitch Zero"
                    })
                )

                animations.move_lean = configs.add_item("Anti-Aim", "animations-move_lean",
                    group:slider("Move Lean", -1, 100, -1, nil, function(value)
                        if value == -1 then
                            return "NL"
                        end

                        if value == 0 then
                            return "Off"
                        end

                        return value .. "x"
                    end)
                )

                animations.air_legs:set_callback(function(item)
                    local value = item:get() == "Static"

                    animations.air_legs_weight:visibility(value)
                end, true)

                animations.ground_legs:set_callback(function(item)
                    local value = item:get() == "Jitter"

                    animations.legs_offset_1:visibility(value)
                    animations.legs_offset_2:visibility(value)
                end, true)
            end

            antiaim.animations = animations
        end

        local defensive = { } do
            local defensive_list = {
                "Standing",
                "Moving",
                "Slow Walk",
                "Crouching",
                "Crouching Move",
                "In Air",
                "Air Crouch"
            }

            local function update_items()
                local value = defensive.condition:get()

                for i = 1, #defensive_list do
                    local state = defensive_list[i]
                    local items = defensive[state]

                    if items == nil then
                        goto continue
                    end

                    local is_current_state = value == state
                    items.enabled:visibility(is_current_state)

                    local is_build_visible = is_current_state

                    if not items.enabled:get() then
                        is_build_visible = false
                    end

                    items.pitch:visibility(is_build_visible)
                    items.yaw:visibility(is_build_visible)

                    local pitch_value = items.pitch:get() do
                        local is_static = pitch_value == "Static"

                        items.pitch_offset:visibility(is_build_visible and is_static)

                        items.pitch_offset_1:visibility(is_build_visible and not is_static)
                        items.pitch_offset_2:visibility(is_build_visible and not is_static)
                    end

                    local yaw_value = items.yaw:get() do
                        local is_offset_visible = yaw_value ~= "Side Based"
                            and yaw_value ~= "Opposite"

                        items.yaw_offset:visibility(is_build_visible and is_offset_visible)
                    end

                    if items.e_spam_while_safe_head ~= nil then
                        items.e_spam_while_safe_head:visibility(is_build_visible)
                    end

                    ::continue::
                end
            end

            local function create_interface(group, state)
                local items = { }

                items.enabled = configs.add_item("Anti-Aim", state .. "_enabled",
                    group:switch("Enabled##" .. state):set_callback(update_items)
                )

                items.pitch = configs.add_item("Anti-Aim", state .. "_pitch",
                    group:combo("Pitch##" .. state, {
                        "Static",
                        "Switch",
                        "Random"
                    }):set_callback(update_items)
                )

                items.pitch_offset = configs.add_item("Anti-Aim", state .. "_pitch_offset",
                    group:slider("Pitch offset##" .. state, -89, 89, 0)
                )

                items.pitch_offset_1 = configs.add_item("Anti-Aim", state .. "_pitch_offset_1",
                    group:slider("Pitch offset 1##" .. state, -89, 89, 0)
                )

                items.pitch_offset_2 = configs.add_item("Anti-Aim", state .. "_pitch_offset_2",
                    group:slider("Pitch offset 2##" .. state, -89, 89, 0)
                )

                items.yaw = configs.add_item("Anti-Aim", state .. "_yaw",
                    group:combo("Yaw##" .. state, {
                        "Side Based",
                        "Opposite",
                        "Spin",
                        "Random",
                        "3-Way",
                        "5-Way"
                    }):set_callback(update_items)
                )

                items.yaw_offset = configs.add_item("Anti-Aim", state .. "_yaw_offset",
                    group:slider("Yaw Offset##" .. state, -180, 180, 0)
                )

                if state ~= "Moving" and state ~= "Slow Walk" and state ~= "In Air" then
                    items.e_spam_while_safe_head = configs.add_item("Anti-Aim", state .. "_e_spam_while_safe_head",
                        group:switch("E Spam While Safe Head##" .. state)
                    )
                end

                return items
            end

            defensive.enabled = configs.add_item("Anti-Aim", "defensive-enabled", groups.extra:switch(
                merge("\a{Link Active}", icons.get "face-hand-peeking", get_space(5), "\aDEFAULT", "Hidden Builder")
            ))

            local group = defensive.enabled:create() do
                defensive.disablers = configs.add_item("Anti-Aim", "defensive-disablers",
                    group:selectable("Disablers", { "Freestanding", "Manuals" })
                )

                defensive.condition = configs.add_item("Anti-Aim", "defensive-condition",
                    group:combo("Condition", defensive_list)
                )

                for i = 1, #defensive_list do
                    local state = defensive_list[i]

                    defensive[state] = create_interface(
                        group, state
                    )
                end

                defensive.condition:set_callback(function(item)
                    update_items()
                end, true)
            end

            antiaim.defensive = defensive
        end

        local safe_head = { } do
            safe_head.enabled = configs.add_item("Anti-Aim", "safe_head-enabled", groups.extra:switch(
                merge(get_space(1), "\a{Link Active}", icons.get "shield-heart", get_space(6), "\aDEFAULT", "Head Behind Chest")
            ))

            local group = safe_head.enabled:create() do
                safe_head.conditions = configs.add_item("Anti-Aim", "safe_head-conditions",
                    group:listable("Conditions", {
                        "Standing",
                        "Crouch",
                        "Air Crouch",
                        "Air Crouch Knife",
                        "Air Crouch Taser",
                        "Distance"
                    }
                ))
            end

            antiaim.safe_head = safe_head
        end

        local break_lc = { } do
            break_lc.enabled = configs.add_item("Anti-Aim", "break_lc-enabled", groups.extra:switch(
                merge("\a{Link Active}", get_space(1), icons.get "circle-nodes", get_space(6), "\aDEFAULT", "Break LC")
            ))

            local group = break_lc.enabled:create() do
                break_lc.conditions = configs.add_item("Anti-Aim", "break_lc-conditions",
                    group:selectable("Conditions", {
                        "Standing",
                        "Moving",
                        "Slow Walk",
                        "Crouching",
                        "Crouching Move",
                        "In Air",
                        "Air Crouch"
                    }
                ))

                break_lc.disablers = configs.add_item("Anti-Aim", "break_lc-disablers",
                    group:selectable("Disablers", {
                        "Hide Shots",
                        "Pin Pulled",
                        "Holding Grenade"
                    }
                ))

                break_lc.triggers = configs.add_item("Anti-Aim", "break_lc-triggers",
                    group:selectable("Triggers", {
                        "Weapon Switch",
                        "Flashed",
                        "Reloading",
                        "Flinching"
                    }
                ))
            end

            antiaim.break_lc = break_lc
        end

        local disable_fakelag = { } do
            disable_fakelag.enabled = configs.add_item("Anti-Aim", "disable_fakelag-enabled", groups.extra:switch(
                merge("\a{Link Active}",  icons.get "bolt-slash", get_space(5), "\aDEFAULT", "Disable Fake Lag")
            ))

            local group = disable_fakelag.enabled:create() do
                disable_fakelag.select = configs.add_item("Anti-Aim", "disable_fakelag-select",
                    group:selectable("Disablers", {
                        "Standing",
                        "Hide Shots",
                        "Double Tap"
                    })
                )
            end

            antiaim.disable_fakelag = disable_fakelag
        end

        local angles = { } do
            local function update_items()
                local is_using_preset = false
                local is_recorder_panel_visible = false

                local value = angles.enabled:get()
                    and angles.condition:get() or -1

                for i = 1, #list do
                    local state = list[i]
                    local items = angles[state]

                    if items == nil then
                        goto continue
                    end

                    local is_current_state = value == state

                    local current_team = items.team:get()
                    items.team:visibility(is_current_state)

                    for i = 1, #teams do
                        local team = teams[i]
                        local builder = items[team]

                        local is_current_team = current_team == team

                        local is_build_visible = is_current_state and is_current_team
                        local is_recorder_visible = false

                        if builder.enabled ~= nil then
                            builder.enabled:visibility(is_build_visible)

                            if not builder.enabled:get() then
                                is_build_visible = false
                            end
                        end

                        local type = builder.type:get()

                        builder.type:visibility(is_build_visible)

                        if type == "Records" and is_build_visible then
                            is_recorder_visible = true
                            is_recorder_panel_visible = true
                        end

                        if type ~= "Default" then
                            is_build_visible = false
                        end

                        if is_current_state and type ~= "Records" and type ~= "Default" then
                            is_using_preset = true
                        end

                        builder.record_inverse_inverter:visibility(is_recorder_visible)

                        builder.pitch:visibility(is_build_visible)
                        builder.yaw:visibility(is_build_visible)
                        builder.yaw_modifier:visibility(is_build_visible and builder.yaw:get() ~= "Disabled")
                        builder.body_yaw:visibility(is_build_visible)
                    end

                    ::continue::
                end

                angles.preset_warning:visibility(is_using_preset)
                groups.recorder:visibility(is_recorder_panel_visible)
            end

            local function create_interface(group, state, team)
                local items = { }

                local key = state .. "_" .. team

                if state ~= "Shared" then
                    items.enabled = configs.add_item("Anti-Aim", key .. "_enabled",
                        group:switch("Enabled##" .. key):set_callback(update_items)
                    )

                    if state == "In Use" then
                        local enabled_group = items.enabled:create() do
                            items.bomb_e_fix = configs.add_item("Anti-Aim", key .. "_bomb_e_fix",
                                enabled_group:switch("Bomb E Fix")
                            )
                        end
                    end
                end

                items.type = configs.add_item("Anti-Aim", key .. "_type",
                    group:combo("Type##" .. key, {
                        "Default",
                        "Records",
                        "Preset",
                        "Meta"
                    }):set_callback(update_items)
                )

                items.record = configs.add_item("Anti-Aim", key .. "_record",
                    group:value("record_" .. key, "")
                )

                items.record_inverse_inverter = configs.add_item("Anti-Aim", key .. "_record_inverse_inverter",
                    group:switch("Inverse Inverter##" .. key)
                )

                items.pitch = configs.add_item("Anti-Aim", key .. "_pitch",
                    group:combo("Pitch##" .. key, software.antiaim.angles.pitch:list()):set_callback(update_items)
                )

                items.yaw = configs.add_item("Anti-Aim", key .. "_yaw",
                    group:combo("Yaw##" .. key, software.antiaim.angles.yaw:list()):set_callback(update_items)
                )

                local yaw_group = items.yaw:create() do
                    items.yaw_base = configs.add_item("Anti-Aim", key .. "_yaw_base",
                        yaw_group:combo("Base", software.antiaim.angles.yaw_base:list())
                    )

                    items.yaw_offset_left = configs.add_item("Anti-Aim", key .. "_yaw_offset_left",
                        yaw_group:slider("Offset Left", -180, 180, 0)
                    )

                    items.yaw_offset_right = configs.add_item("Anti-Aim", key .. "_yaw_offset_right",
                        yaw_group:slider("Offset Right", -180, 180, 0)
                    )
                end

                items.yaw_modifier = configs.add_item("Anti-Aim", key .. "_yaw_modifier",
                    group:combo("Yaw Modifier##" .. key, software.antiaim.angles.yaw_modifier:list()):set_callback(update_items)
                )

                local yaw_modifier_group = items.yaw_modifier:create() do
                    items.modifier_offset = configs.add_item("Anti-Aim", key .. "_modifier_offset",
                        yaw_modifier_group:slider("Offset", -180, 180, 0)
                    )

                    items.modifier_random = configs.add_item("Anti-Aim", key .. "_modifier_random",
                        yaw_modifier_group:slider("Random", 0, 180, 0)
                    )
                end

                items.body_yaw = configs.add_item("Anti-Aim", key .. "_body_yaw",
                    group:switch("Body Yaw##" .. key):set_callback(update_items)
                )

                local body_yaw_group = items.body_yaw:create() do
                    items.left_limit = configs.add_item("Anti-Aim", key .. "_left_limit",
                        body_yaw_group:slider("Left Limit", 0, 60, 60)
                    )

                    items.right_limit = configs.add_item("Anti-Aim", key .. "_right_limit",
                        body_yaw_group:slider("Right Limit", 0, 60, 60)
                    )

                    items.options = configs.add_item("Anti-Aim", key .. "_options",
                        body_yaw_group:selectable("Options", software.antiaim.angles.options:list())
                    )

                    items.delay = configs.add_item("Anti-Aim", key .. "_delay",
                        body_yaw_group:slider("Delay", 0, 16, 0, nil, function(value)
                            if value == 0 then
                                return "Off"
                            end

                            return nil
                        end)
                    )

                    items.freestanding_body_yaw = configs.add_item("Anti-Aim", key .. "_freestanding_body_yaw",
                        body_yaw_group:combo("Freestanding", software.antiaim.angles.freestanding_body_yaw:list())
                    )

                    items.options:set_callback(function(item)
                        items.delay:visibility(item:get("Jitter"))
                    end, true)
                end

                return items
            end

            local function get_data_values(list)
                local data = { }

                if list.enabled ~= nil then
                    data.enabled = list.enabled:get()
                end

                data.type = list.type:get()
                data.pitch = list.pitch:get()

                data.record = list.record:get()
                data.record_inverse_inverter = list.record_inverse_inverter:get()

                data.yaw = list.yaw:get()
                data.yaw_base = list.yaw_base:get()
                data.yaw_offset_left = list.yaw_offset_left:get()
                data.yaw_offset_right = list.yaw_offset_right:get()

                data.yaw_modifier = list.yaw_modifier:get()
                data.modifier_offset = list.modifier_offset:get()
                data.modifier_random = list.modifier_random:get()

                data.body_yaw = list.body_yaw:get()
                data.left_limit = list.left_limit:get()
                data.right_limit = list.right_limit:get()
                data.options = list.options:get()
                data.delay = list.delay:get()
                data.freestanding_body_yaw = list.freestanding_body_yaw:get()

                return data
            end

            local function get_current_values()
                local custom = angles[angles.condition:get()]

                if custom == nil then
                    return nil
                end

                return custom[custom.team:get()]
            end

            local function get_another_values()
                local custom = angles[angles.condition:get()]

                if custom == nil then
                    return nil
                end

                local team = custom.team:get() == teams[1]
                    and teams[2] or teams[1]

                return custom[team]
            end

            local function get_current_data()
                local values = get_current_values()

                if values == nil then
                    return nil
                end

                return get_data_values(values)
            end

            local function set_data_values(values, data)
                if values == nil then
                    return false
                end

                if values.enabled ~= nil and data.enabled ~= nil then
                    values.enabled:set(data.enabled)
                end

                values.type:set(data.type)
                values.pitch:set(data.pitch)

                values.record:set(data.record)
                values.record_inverse_inverter:set(data.record_inverse_inverter)

                values.yaw:set(data.yaw)
                values.yaw_base:set(data.yaw_base)
                values.yaw_offset_left:set(data.yaw_offset_left)
                values.yaw_offset_right:set(data.yaw_offset_right)

                values.yaw_modifier:set(data.yaw_modifier)
                values.modifier_offset:set(data.modifier_offset)
                values.modifier_random:set(data.modifier_random)

                values.body_yaw:set(data.body_yaw)
                values.left_limit:set(data.left_limit)
                values.right_limit:set(data.right_limit)
                values.options:set(data.options)
                values.delay:set(data.delay)
                values.freestanding_body_yaw:set(data.freestanding_body_yaw)

                return true
            end

            angles.enabled = configs.add_item("Anti-Aim", "angles-enabled", groups.angles:switch(
                merge("\a{Link Active}",  icons.get "toggle-on", get_space(6), "\aDEFAULT", "Override Anti-Aims")
            ))

            angles.condition = groups.angles:combo(
                merge("\a{Link Active}", get_space(1), icons.get "user", get_space(7), "\aDEFAULT", "Condition"), list
            )

            local condition_group = angles.condition:create() do
                local function export_data()
                    local ok, data = pcall(get_current_data)

                    if not ok or data == nil then
                        return false, "Can't get current data"
                    end

                    local ok, content = pcall(json.stringify, data)

                    if not ok then
                        return false, "Can't stringify thru json"
                    end

                    local ok, encoded = pcall(base64.encode, content)

                    if not ok then
                        return false, "Can't encode thru base64"
                    end

                    return true, encoded
                end

                local function import_data()
                    local ok, encoded = pcall(clipboard.get)

                    if not ok then
                        return false, "Can't get clipboard data"
                    end

                    if encoded == nil then
                        return false, "Can't match valid data"
                    end

                    local ok, content = pcall(base64.decode, encoded)

                    if not ok then
                        return false, "Can't decode thru base64"
                    end

                    local ok, data = pcall(json.parse, content)

                    if not ok or data == nil then
                        return false, "Can't parse thru json"
                    end

                    return true, data
                end

                local function copy()
                    local ok, data = export_data()

                    if not ok then
                        logging.error(data)
                        return
                    end

                    local ok, msg = pcall(clipboard.set, data)

                    if not ok then
                        logging.error(msg)
                        return
                    end

                    logging.success("Anti-Aims were copied")
                end

                local function paste()
                    local ok, data = import_data()

                    if not ok then
                        logging.error(data)
                        return
                    end

                    local ok, msg = pcall(set_data_values, get_current_values(), data)

                    if not ok then
                        logging.error(msg)
                        return
                    end

                    logging.success("Anti-Aims were inserted")
                end

                local function send()
                    local data = get_current_data()

                    if data == nil then
                        logging.error("Unable to get current data")
                        return
                    end

                    local ok, msg = pcall(set_data_values, get_another_values(), data)

                    if not ok then
                        logging.error(msg)
                        return
                    end

                    logging.success("Anti-Aims were sent to the other side")
                end

                condition_group:button(
                    merge(get_space(5), "\a{Link Active}", icons.get "copy", get_space(5), "\aDEFAULT", "Copy", get_space(5)), copy, true
                )

                condition_group:button(
                    merge(get_space(5), "\a{Link Active}", icons.get "paste", get_space(5), "\aDEFAULT", "Paste", get_space(5)), paste, true
                )

                condition_group:button(
                    merge(get_space(5), "\a{Link Active}", icons.get "share", get_space(5), "\aDEFAULT", "Send to Another Side", get_space(5)), send, true
                )
            end

            for i = 1, #list do
                local state = list[i]

                local items = { }

                items.team = groups.angles:combo(merge("\a{Link Active}", get_space(1), icons.get "user-plus", get_space(4), "\aDEFAULT", "Side##" .. state), teams)
                    :set_callback(update_items)

                for j = 1, #teams do
                    local team = teams[j]

                    items[team] = create_interface(
                        groups.builder, state, team
                    )
                end

                angles[state] = items
            end

            angles.preset_warning = groups.builder:label(merge(
                "\aFFD43BFF", ui.get_icon "triangle-exclamation", get_space(5),
                "\aDEFAULT", "Anti-Aims overriden with current preset"
            ))

            angles.sequence_list = groups.recorder:list("##SEQUENCE", { "None" })

            angles.save_sequence = groups.recorder:button("Save sequence", nil, true)
            angles.import_record = groups.recorder:button("Import record", nil, true)

            angles.link_to_recorder = groups.recorder:button("Link to Recorder", create_link("https://neverlose.cc/market/item?id=a90nl4"), true)

            angles.set_start = groups.recorder:button("Set start", nil, true)
            angles.set_end = groups.recorder:button("Set end", nil, true)

            angles.enabled:set_callback(function(item)
                local value = item:get()

                angles.condition:visibility(value)
                groups.builder:visibility(value)

                update_items()
            end, true)

            angles.condition:set_callback(update_items, true)

            antiaim.angles = angles
        end

        resource.antiaim = antiaim
    end

    local features = { } do
        local TAB = icons.get "lines-leaning"

        local groups = { } do
            groups.ragebot = ui.create(TAB, "Ragebot", COLUMN_LEFT)
            groups.movement = ui.create(TAB, "Movement", COLUMN_LEFT)
            groups.visuals = ui.create(TAB, "Visuals", COLUMN_RIGHT)
        end

        local ragebot = { } do
            local dormant_aimbot = { } do
                dormant_aimbot.label = groups.ragebot:label(
                    merge("\a{Link Active}", get_space(1), icons.get "gun", get_space(5), "\aDEFAULT", "Dormant Aimbot")
                )

                local group = dormant_aimbot.label:create() do
                    dormant_aimbot.enabled = configs.add_item("Ragebot", "dormant_aimbot-enabled",
                        group:switch("Dormant Aimbot")
                    )

                    dormant_aimbot.hitboxes = configs.add_item("Ragebot", "dormant_aimbot-hitboxes",
                        group:selectable("Hitboxes", {
                            "Head", "Chest", "Stomach", "Legs"
                        })
                    )

                    dormant_aimbot.hitchance = configs.add_item("Ragebot", "dormant_aimbot-hitchance",
                        group:slider("Accuracy", 50, 85, 60, nil, "%")
                    )

                    dormant_aimbot.minimum_damage = configs.add_item("Ragebot", "dormant_aimbot-minimum_damage",
                        group:slider("Minimum damage", 0, 126, 10, nil, function(value)
                            if value == 0 then
                                return "Inherited"
                            end

                            if value > 100 then
                                return "HP + " .. value
                            end

                            return value
                        end)
                    )

                    dormant_aimbot.auto_scope = configs.add_item("Ragebot", "dormant_aimbot-auto_scope",
                        group:switch("Auto Scope")
                    )
                end

                ragebot.dormant_aimbot = dormant_aimbot
            end

            local ai_peek = { } do
                ai_peek.enabled = groups.ragebot:switch(
                    merge("\a{Link Active}", get_space(1), icons.get "user-robot", get_space(7), "\aDEFAULT", "AI Peek")
                )

                local group = ai_peek.enabled:create() do
                    ai_peek.simulation = configs.add_item("Ragebot", "ai_peek-simulation", group:slider(
                        "Simulation", 25, 35, 30, 0.01, "s"
                    ))

                    ai_peek.rate_limit = configs.add_item("Ragebot", "ai_peek-rate_limit", group:slider(
                        "Rate Limit", 0, 30, 3, 0.01, "s"
                    ))

                    ai_peek.hitchance = configs.add_item("Ragebot", "ai_peek-hitchance", group:slider(
                        "Hit Chance", 0, 100, 35, nil, function(num)
                            if num == 0 then return "Default" else return num .. "%" end
                        end
                    ))

                    ai_peek.hitboxes = configs.add_item("Ragebot", "ai_peek-hitboxes", group:selectable(
                        "Hitboxes", {
                            "Head",
                            "Chest",
                            "Stomach",
                            "Arms",
                            "Legs"
                        }
                    ))

                    ai_peek.weapons = configs.add_item("Ragebot", "ai_peek-weapons", group:selectable(
                        "Weapons", {
                            "Snipers",
                            "Pistols"
                        }
                    ))


                    ai_peek.color = configs.add_item("Ragebot", "ai_peek-color", group:color_picker(
                        "Color", color(255, 0, 0, 255)
                    ))

                    ai_peek.simulation:tooltip "Sets the duration of the Peek, adjustable if \'AI Peek\' can't make it in time"
                    ai_peek.rate_limit:tooltip "Adjusts scanning frequency, will be useful for computers with poor performance"
                    ai_peek.hitchance:tooltip "Sets hit chance in ragebot when \'AI peeking\'"
                    ai_peek.weapons:tooltip "Which weapon should trigger the \'AI Peek\'"
                    ai_peek.color:tooltip "Changes the color of the overlay"

                    local old_hitboxes = ai_peek.hitboxes:get() do
                        if #old_hitboxes == 0 then
                            local hitboxes = {
                                "Head",
                                "Chest",
                                "Stomach"
                            }

                            ai_peek.hitboxes:set(hitboxes)
                            old_hitboxes = hitboxes
                        end

                        ai_peek.hitboxes:set_callback(function(item)
                            local value = item:get()

                            if #value > 0 then
                                old_hitboxes = value
                            else
                                ai_peek.hitboxes:set(old_hitboxes)
                            end
                        end)
                    end
                end

                ragebot.ai_peek = ai_peek
            end

            local fake_latency = { } do
                fake_latency.enabled = configs.add_item("Ragebot", "fake_latency-enabled", groups.ragebot:switch(
                    merge("\a{Link Active}", get_space(1), icons.get "satellite-dish", get_space(6), "\aDEFAULT", "Extended Fake Ping")
                ))

                local group = fake_latency.enabled:create() do
                    fake_latency.value = configs.add_item("Ragebot", "fake_latency-value",
                        group:slider("Fake Latency", 0, 200, 0, nil)
                    )
                end

                ragebot.fake_latency = fake_latency
            end

            local hitchance = { } do
                local list = { "Pistols", "AutoSnipers", "AWP", "SSG-08", "R8 Revolver" } do
                    hitchance.list = list
                end

                hitchance.enabled = configs.add_item("Ragebot", "hitchance-enabled", groups.ragebot:switch(
                    merge("\a{Link Active}", get_space(1), icons.get "square-sliders-vertical", get_space(7), "\aDEFAULT", "Hit Chance")
                ))

                local group = hitchance.enabled:create() do
                    hitchance.type = group:list("Weapon", list)

                    local function on_display(value)
                        return value == -1 and "Off" or value .. "%"
                    end

                    local function update_visibility(value)
                        for i = 1, #list do
                            local weapon = list[i]
                            local items = hitchance[weapon]

                            local is_visible = i == value

                            items.in_air:visibility(is_visible)

                            if items.no_scope ~= nil then
                                items.no_scope:visibility(is_visible)
                                items.distance:visibility(is_visible and items.no_scope:get() > -1)
                            end

                            if items.jump_scout ~= nil then
                                items.jump_scout:visibility(is_visible)
                            end
                        end
                    end

                    for i = 1, #list do
                        local weapon = list[i]

                        local items = { } do
                            items.in_air = configs.add_item("Ragebot", "hitchance_" .. weapon .. "_in_air",
                                group:slider("In-Air##" .. weapon, -1, 100, -1, nil, on_display)
                            )

                            if weapon ~= "Pistols" and weapon ~= "R8 Revolver" then
                                items.no_scope = configs.add_item("Ragebot", "hitchance_" .. weapon .. "_no_scope",
                                    group:slider("No-Scope##" .. weapon, -1, 100, -1, nil, on_display)
                                )

                                items.distance = configs.add_item("Ragebot", "hitchance_" .. weapon .. "_distance",
                                    group:slider("Distance##" .. weapon, 30, 1001, 325, 0.1, function(value)
                                        if value == 1001 then
                                            return "Inf"
                                        end

                                        return string.format("%.1fft", value * 0.1)
                                    end)
                                )

                                items.no_scope:set_callback(function()
                                    update_visibility(hitchance.type:get())
                                end)
                            end

                            if weapon == "SSG-08" then
                                items.jump_scout = configs.add_item("Ragebot", "hitchance_" .. weapon .. "_jump_scout",
                                    group:switch("Jump Scout##" .. weapon)
                                )
                            end
                        end

                        hitchance[weapon] = items
                    end

                    hitchance.type:set_callback(function(item)
                        update_visibility(item:get())
                    end, true)
                end

                ragebot.hitchance = hitchance
            end

            local aimbot_logs = { } do
                aimbot_logs.select = configs.add_item("Ragebot", "aimbot_logs-select", groups.ragebot:selectable(
                    merge("\a{Link Active}", get_space(1), icons.get "calendar-pen", get_space(7), "\aDEFAULT", "Log Events"),
                    { "Aimbot", "Purchases" }
                ))

                ragebot.aimbot_logs = aimbot_logs
            end

            features.ragebot = ragebot
        end

        local movement = { } do
            local super_toss = { } do
                super_toss.enabled = configs.add_item("Movement", "super_toss-enabled", groups.movement:switch(
                    merge("\a{Link Active}", get_space(1), icons.get "calculator-simple", get_space(6), "\aDEFAULT", "Super Toss")
                ))

                movement.super_toss = super_toss
            end

            local fast_ladder = { } do
                fast_ladder.enabled = configs.add_item("Movement", "fast_ladder-enabled", groups.movement:switch(
                    merge("\a{Link Active}", get_space(1), icons.get "gauge-max", get_space(6), "\aDEFAULT", "Fast Ladder")
                ))

                movement.fast_ladder = fast_ladder
            end

            local no_fall_damage = { } do
                no_fall_damage.enabled = configs.add_item("Movement", "no_fall_damage-enabled", groups.movement:switch(
                    merge("\a{Link Active}", get_space(1), icons.get "person-falling", get_space(7), "\aDEFAULT", "No Fall Damage")
                ))

                movement.no_fall_damage = no_fall_damage
            end

            features.movement = movement
        end

        local visuals = { } do
            local watermark = { } do
                watermark.label = groups.visuals:label(
                    merge("\a{Link Active}", get_space(2), icons.get "tag", get_space(6), "\aDEFAULT", "Watermark")
                )

                local group = watermark.label:create() do
                    watermark.color = configs.add_item("Visuals", "watermark-color",
                        group:color_picker("Color", {
                            ["Single"] = {
                                color(255, 255, 255, 255),
                            },

                            ["Duo"] = {
                                color(255, 255, 255, 255),
                                color(50, 50, 50, 255)
                            }
                        })
                    )

                    watermark.removals = configs.add_item("Visuals", "watermark-removals",
                        group:selectable("Removals", {
                            "Arrows", "Animation", "Shadow"
                        })
                    )
                end

                visuals.watermark = watermark
            end

            local aspect_ratio = { } do
                local ratios = {
                    "16:9",
                    "16:10",
                    "4:3",
                    "5:4"
                }

                local values = {
                    ["16:10"] = 160,
                    ["16:9"] = 177,
                    ["4:3"] = 133,
                    ["5:4"] = 125
                }

                aspect_ratio.enabled = configs.add_item("Visuals", "aspect_ratio-enabled", groups.visuals:switch(
                    merge("\a{Link Active}", get_space(1), icons.get "expand-wide", get_space(6), "\aDEFAULT", "Aspect Ratio")
                ))

                local group = aspect_ratio.enabled:create() do
                    local keys = { } do
                        for i = 1, #ratios do
                            local ratio = ratios[i]
                            local value = values[ratio]

                            keys[value] = ratio
                        end
                    end

                    local function on_display(value)
                        if value == 0.0 then
                            return "Off"
                        end

                        return keys[value]
                    end

                    aspect_ratio.proportion = configs.add_item("Visuals", "aspect_ratio-proportion",
                        group:slider("Proportion", 0, 200, 0, 0.01, on_display)
                    )

                    for i = 1, #ratios do
                        local ratio = ratios[i]
                        local value = values[ratio]

                        local function callback()
                            aspect_ratio.proportion:set(value)
                        end

                        group:button(add_space(ratio, math.ceil(#ratio * 1.34)), callback, true)
                    end
                end

                visuals.aspect_ratio = aspect_ratio
            end

            local viewmodel = { } do
                viewmodel.enabled = configs.add_item("Visuals", "viewmodel-enabled", groups.visuals:switch(
                    merge("\a{Link Active}", get_space(1), icons.get "hand", get_space(6), "\aDEFAULT", "Viewmodel")
                ))

                local group = viewmodel.enabled:create() do
                    viewmodel.fov = configs.add_item("Visuals", "viewmodel-fov",
                        group:slider("Field of View", 0, 1000, 680, 0.1)
                    )

                    viewmodel.offset_x = configs.add_item("Visuals", "viewmodel-offset_x",
                        group:slider("Offset X", -100, 100, 25, 0.1)
                    )

                    viewmodel.offset_y = configs.add_item("Visuals", "viewmodel-offset_y",
                        group:slider("Offset Y", -100, 100, 0, 0.1)
                    )

                    viewmodel.offset_z = configs.add_item("Visuals", "viewmodel-offset_z",
                        group:slider("Offset Z", -100, 100, -15, 0.1)
                    )

                    viewmodel.opposite_knife_hand = configs.add_item("Visuals", "viewmodel-opposite_knife_hand",
                        group:switch("Opposite Knife Hand")
                    )
                end

                visuals.viewmodel = viewmodel
            end

            local hit_marker = { } do
                hit_marker.enabled = configs.add_item("Visuals", "hit_marker-enabled", groups.visuals:switch(
                    merge("\a{Link Active}", get_space(1), icons.get "bullseye-arrow", get_space(6), "\aDEFAULT", "Hit Marker")
                ))

                local group = hit_marker.enabled:create() do
                    hit_marker.type = group:list("Type", { "Damage", "Screen", "World" })

                    local damage = { } do
                        damage.enabled = configs.add_item("Visuals", "hit_marker-damage-enabled",
                            group:switch("Enable##DAMAGE")
                        )

                        damage.speed = configs.add_item("Visuals", "hit_marker-damage-speed",
                            group:slider("Speed##Damage", 0, 128, 58, nil, "u/s")
                        )

                        damage.duration = configs.add_item("Visuals", "hit_marker-damage-duration",
                            group:slider("Duration##Damage", 1, 8, 4, nil, "s")
                        )

                        damage.color = configs.add_item("Visuals", "hit_marker-damage-color",
                            group:color_picker("Color##DAMAGE", {
                                ["Body"] = { color(255, 255, 255, 255) },
                                ["Head"] = { color(150, 185, 5, 255) },
                                ["Mismatch"] = { color(255, 0, 0, 255) }
                            })
                        )

                        damage.speed:tooltip("Sets the airspeed in units per second")

                        hit_marker.damage = damage
                    end

                    local screen = { } do
                        screen.enabled = configs.add_item("Visuals", "hit_marker-screen-enabled",
                            group:switch("Enable##SCREEN")
                        )

                        screen.color = configs.add_item("Visuals", "hit_marker-screen-color",
                            group:color_picker("Color##SCREEN")
                        )

                        hit_marker.screen = screen
                    end

                    local world = { } do
                        world.enabled = configs.add_item("Visuals", "hit_marker-world-enabled",
                            group:switch("Enable##WORLD")
                        )

                        world.size = configs.add_item("Visuals", "hit_marker-world-size",
                            group:slider("Size##WORLD", 2, 5, 4, nil, "px")
                        )

                        world.thickness = configs.add_item("Visuals", "hit_marker-world-thickness",
                            group:slider("Thickness##WORLD", 1, 5, 2, nil, "px")
                        )

                        world.color = configs.add_item("Visuals", "hit_marker-world-color",
                            group:color_picker("Color##WORLD", {
                                ["Vertical"] = { color(0, 255, 0, 255) },
                                ["Horizontal"] = { color(0, 255, 255, 255) }
                            })
                        )

                        hit_marker.world = world
                    end

                    hit_marker.type:set_callback(function(item)
                        local value = item:get()

                        local is_damage = value == 1 do
                            damage.enabled:visibility(is_damage)

                            damage.speed:visibility(is_damage)
                            damage.duration:visibility(is_damage)

                            damage.color:visibility(is_damage)
                        end

                        local is_screen = value == 2 do
                            screen.enabled:visibility(is_screen)
                            screen.color:visibility(is_screen)
                        end

                        local is_world = value == 3 do
                            world.enabled:visibility(is_world)

                            world.size:visibility(is_world)
                            world.thickness:visibility(is_world)

                            world.color:visibility(is_world)
                        end
                    end, true)
                end

                visuals.hit_marker = hit_marker
            end

            local scope_overlay = { } do
                scope_overlay.enabled = configs.add_item("Visuals", "scope_overlay-enabled", groups.visuals:switch(
                    merge("\a{Link Active}", get_space(1),icons.get "crosshairs-simple", get_space(6), "\aDEFAULT", "Scope Overlay")
                ))

                local group = scope_overlay.enabled:create() do
                    scope_overlay.position = configs.add_item("Visuals", "scope_overlay-position",
                        group:slider("Position", 0, 500, 105)
                    )

                    scope_overlay.offset = configs.add_item("Visuals", "scope_overlay-offset",
                        group:slider("Offset", 0, 500, 10)
                    )

                    scope_overlay.exclude = configs.add_item("Visuals", "scope_overlay-exclude",
                        group:selectable("Exclude", {
                            "Left", "Right", "Top", "Bottom"
                        })
                    )

                    scope_overlay.color = configs.add_item("Visuals", "scope_overlay-color",
                        group:color_picker("Color")
                    )
                end

                visuals.scope_overlay = scope_overlay
            end

            local grenade_visuals = { } do
                grenade_visuals.enabled = configs.add_item("Visuals", "grenade_visuals-enabled", groups.visuals:switch(
                    merge("\a{Link Active}", get_space(1), icons.get "bomb", get_space(6), "\aDEFAULT", "Grenade Visuals")
                ))

                local group = grenade_visuals.enabled:create() do
                    grenade_visuals.prediction = configs.add_item("Visuals", "grenade_visuals-prediction",
                        group:switch("Prediction")
                    )

                    grenade_visuals.proximity_warning = configs.add_item("Visuals", "grenade_visuals-proximity_warning",
                        group:switch("Proximity Warning")
                    )
                end

                visuals.grenade_visuals = grenade_visuals
            end

            local damage_indicator = { } do
                damage_indicator.enabled = configs.add_item("Visuals", "damage_indicator-enabled", groups.visuals:switch(
                    merge("\a{Link Active}",  icons.get "claw-marks", get_space(6), "\aDEFAULT", "Damage Indicator")
                ))

                local group = damage_indicator.enabled:create() do
                    damage_indicator.font = configs.add_item("Visuals", "damage_indicator-font",
                        group:combo("Font", {
                            "Default", "Small", "Museo"
                        })
                    )

                    damage_indicator.color = configs.add_item("Visuals", "damage_indicator-color",
                        group:color_picker("Color")
                    )
                end

                visuals.damage_indicator = damage_indicator
            end

            local penetration_indicator = { } do
                penetration_indicator.enabled = configs.add_item("Visuals", "penetration_indicator-enabled", groups.visuals:switch(
                    merge("\a{Link Active}", get_space(1), icons.get "block-brick", get_space(7), "\aDEFAULT", "Penetration Indicator")
                ))

                local group = penetration_indicator.enabled:create() do
                    penetration_indicator.font = configs.add_item("Visuals", "penetration_indicator-font",
                        group:combo("Font", {
                            "Default", "Small", "Museo"
                        })
                    )

                    penetration_indicator.color = configs.add_item("Visuals", "penetration_indicator-color",
                        group:color_picker("Color")
                    )
                end

                visuals.penetration_indicator = penetration_indicator
            end

            local kill_say = { } do
                kill_say.enabled = configs.add_item("Visuals", "kill_say-enabled", groups.visuals:switch(
                    merge("\a{Link Active}",  icons.get "comments", get_space(5), "\aDEFAULT", "Talking shit")
                ))

                local group = kill_say.enabled:create() do
                    kill_say.triggers = configs.add_item("Visuals", "kill_say-triggers",
                        group:selectable("Triggers", {
                            "On Kill", "On Death", "Rampage"
                        })
                    )

                    kill_say.disablers = configs.add_item("Visuals", "kill_say-disablers",
                        group:selectable("Disablers", {
                            "On Warmup"
                        })
                    )
                end

                visuals.kill_say = kill_say
            end

            features.visuals = visuals
        end

        resource.features = features
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

local sidebar do
    local function on_render()
        if ui.get_alpha() <= 0 then
            return
        end

        local style = ui.get_style()

        local text = SCRIPT_NAME do
            text = decorators.wave(text, style["Link Active"], style["Disabled Text"])
        end

        ui.sidebar(text, "cannabis")
    end

    events.render(on_render)
end

local localplayer do
    localplayer = { }

    local pre_flags = 0
    local post_flags = 0

    localplayer.is_onground = false

    localplayer.is_moving = false
    localplayer.is_crouched = false

    localplayer.velocity2d = 0
    localplayer.duck_amount = 0

    localplayer.eye_position = vector()

    localplayer.team_num = 0
    localplayer.sent_packets = 0

    local function on_createmove(e)
        local me = entity.get_local_player()

        if me == nil then
            return
        end

        pre_flags = me.m_fFlags

        localplayer.velocity2d = me.m_vecVelocity:length2d()

        if e.choked_commands == 0 then
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
            if software.antiaim.misc.slow_walk:get() then
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

local windows do
    windows = { }

    local list = { }

    local hovered_window = nil
    local foreground_window = nil

    local group = ui.create("Windows")
        :visibility(false)

    local function extract(str)
        local ok, data = pcall(json.parse, str)

        if not ok then
            return nil
        end

        return data
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

    local Draggable = { } do
        Draggable.__index = Draggable

        function Draggable:__new(name, flags)
            if type(flags) ~= "table" then
                flags = { }
            end

            return setmetatable({
                item = group:value(name, ""),

                is_active = true,
                is_hovered = false,
                is_clamped = flags.clamped == true,

                pos = vector(),
                size = vector(),
                anchor = vector()
            }, self)
        end

        function Draggable:get_pos()
            return self.pos
        end

        function Draggable:set_pos(pos)
            local screen = render.screen_size()
            local new_pos = pos:clone()

            if self.is_clamped then
                new_pos.x = math.clamp(new_pos.x, 0, screen.x - self.size.x)
                new_pos.y = math.clamp(new_pos.y, 0, screen.y - self.size.y)
            end

            if self.pos ~= new_pos then
                self.item:set(json.stringify({
                    x = new_pos.x + self.size.x * self.anchor.x,
                    y = new_pos.y + self.size.y * self.anchor.y
                }))
            end

            self.pos = new_pos
            return self
        end

        function Draggable:get_size()
            return self.size
        end

        function Draggable:set_size(size)
            local delta = size - self.size
            local new_pos = self.pos - delta * self.anchor

            self.size = size
            self:set_pos(new_pos)

            return self
        end

        function Draggable:get_anchor()
            return self.anchor
        end

        function Draggable:set_anchor(anchor)
            self.anchor = anchor
            return self
        end

        function Draggable:build()
            local value = self.item:get()
            local data = extract(value)

            if data ~= nil then
                if data.x ~= nil and data.y ~= nil then
                    self.pos = vector(
                        data.x, data.y
                    )
                end
            end

            table.insert(list, self)
            return self
        end
    end

    local function is_collided(point, a, b)
        return point.x >= a.x and point.x <= b.x
            and point.y >= a.y and point.y <= b.y
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

    local function on_createmove(e)
        local blocked = foreground_window ~= nil
            or hovered_window ~= nil

        if not blocked then
            return
        end

        e.in_attack = false
        e.in_attack2 = false
    end

    function windows.new(name, flags)
        return Draggable:__new(name, flags)
    end

    events.render(on_render)
    events.createmove(on_createmove)
end

local watermark do
    local FONT = 1
    local TEXT = SCRIPT_NAME

    local BLACK_COLOR = color(0, 0, 0, 255)
    local WHITE_COLOR = color(255, 255, 255, 255)

    -- ui variables
    local col = WHITE_COLOR
    local col_type = "Single"

    local is_arrows_removed = false
    local is_animation_removed = false
    local is_shadow_removed = false

    local function lerp(a, b, t)
        return a + t * (b - a)
    end

    local function get_text_array(text)
        local arr = { }
        local size = #text

        for i = 1, size do
            arr[i] = text:sub(i, i)
        end

        return arr, size
    end

    local function get_caps_animation(text, time)
        local arr, size = get_text_array(text)
        local index = math.floor(time % size) + 1

        arr[index] = arr[index]:upper()
        return table.concat(arr, nil, 1, size)
    end

    local function on_render()
        local screen = render.screen_size()
        local position = vector(screen.x * 0.5, screen.y - 5)

        local text = TEXT

        local text_color = col_type == "Single"
            and col or color()

        if not is_animation_removed then
            text = get_caps_animation(text, globals.realtime * 5.0)
        end

        if not is_arrows_removed then
            text = "-› " .. text .. " ‹-"
        end

        if col_type == "Duo" then
            text = decorators.wave(text, col[1], col[2])
        end

        local text_size = render.measure_text(FONT, "", text)

        position.x = position.x - text_size.x * 0.5 + 0.5
        position.y = position.y - text_size.y

        if not is_shadow_removed then
            local shadow_pos = position:clone()
            local shadow_size = vector(text_size.x, 0)

            shadow_pos.y = shadow_pos.y + (text_size.y + 1) * 0.5

            render.shadow(shadow_pos, shadow_pos + shadow_size, BLACK_COLOR, 32)
        end

        render.text(1, position, text_color, "", text)
    end

    resource.features.visuals.watermark.color:set_callback(function(item)
        col_type, col = item:get()

        if type(col) == "table" then
            for i = 1, #col do
                col[i].a = lerp(75, 255, col[i].a / 255)
            end
        else
            col.a = lerp(75, 255, col.a / 255)
        end
    end, true)

    resource.features.visuals.watermark.removals:set_callback(function(item)
        is_arrows_removed = item:get("Arrows")
        is_animation_removed = item:get("Animation")
        is_shadow_removed = item:get("Shadow")
    end, true)

    --events.render(on_render)
end

local aspect_ratio do
    local r_aspectratio = cvar.r_aspectratio

    local state = false
    local aspect = 0.0

    local function unset_ratio()
        r_aspectratio:float(tonumber(r_aspectratio:string()), true)
    end

    local function set_ratio(value)
        r_aspectratio:float(value, true)
    end

    local function on_shutdown()
        unset_ratio()
    end

    resource.features.visuals.aspect_ratio.proportion:set_callback(function(item)
        aspect = item:get() * 0.01

        if state then
            set_ratio(aspect)
        end
    end, true)

    resource.features.visuals.aspect_ratio.enabled:set_callback(function(item)
        state = item:get()
        events.shutdown(on_shutdown, state)

        if not state then
            unset_ratio()
            return
        end

        set_ratio(aspect)
    end, true)
end

local viewmodel do
    local WEAPONTYPE_KNIFE = 0

    local viewmodel_fov = cvar.viewmodel_fov

    local viewmodel_offset_x = cvar.viewmodel_offset_x
    local viewmodel_offset_y = cvar.viewmodel_offset_y
    local viewmodel_offset_z = cvar.viewmodel_offset_z

    local cl_righthand = cvar.cl_righthand

    local old_weaponselect = 0

    local state = false
    local is_knife = false

    local fov = 0

    local offset_x = 0
    local offset_y = 0
    local offset_z = 0

    local opposite_knife_hand = false

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

    local function unset_viewmodel()
        viewmodel_fov:float(tonumber(viewmodel_fov:string()), true)

        viewmodel_offset_x:float(tonumber(viewmodel_offset_x:string()), true)
        viewmodel_offset_y:float(tonumber(viewmodel_offset_y:string()), true)
        viewmodel_offset_z:float(tonumber(viewmodel_offset_z:string()), true)

        cl_righthand:int(cl_righthand:string() == "1" and 1 or 0, true)
    end

    local function set_viewmodel()
        if not state then
            return
        end

        local is_right = cl_righthand:string() == "1"

        viewmodel_fov:float(fov, true)

        viewmodel_offset_x:float(offset_x, true)
        viewmodel_offset_y:float(offset_y, true)
        viewmodel_offset_z:float(offset_z, true)

        if opposite_knife_hand then
            if is_right then
                cl_righthand:int(is_knife and 0 or 1, true)
            else
                cl_righthand:int(is_knife and 1 or 0, true)
            end

        else
            cl_righthand:int(cl_righthand:string() == "1" and 1 or 0, true)
        end
    end

    local function on_shutdown()
        unset_viewmodel()
    end

    local function on_createmove(e)
        if old_weaponselect ~= 0 then
            is_knife = is_knife_equiped()
        end

        if opposite_knife_hand then
            set_viewmodel()
        end

        old_weaponselect = e.weaponselect
    end

    local function update_knife_callback()
        if state and opposite_knife_hand then
            events.createmove(on_createmove, true)
            cl_righthand:set_callback(set_viewmodel)
        else
            events.createmove(on_createmove, false)
            cl_righthand:unset_callback(set_viewmodel)
        end
    end

    local function update_shutdown_callback()
        events.shutdown(on_shutdown, state)
    end

    resource.features.visuals.viewmodel.fov:set_callback(function(item)
        fov = item:get() * 0.1
        set_viewmodel()
    end, true)

    resource.features.visuals.viewmodel.offset_x:set_callback(function(item)
        offset_x = item:get() * 0.1
        set_viewmodel()
    end, true)

    resource.features.visuals.viewmodel.offset_y:set_callback(function(item)
        offset_y = item:get() * 0.1
        set_viewmodel()
    end, true)

    resource.features.visuals.viewmodel.offset_z:set_callback(function(item)
        offset_z = item:get() * 0.1
        set_viewmodel()
    end, true)

    resource.features.visuals.viewmodel.opposite_knife_hand:set_callback(function(item)
        opposite_knife_hand = item:get()
        is_knife = is_knife_equiped()

        set_viewmodel()
        update_knife_callback()
    end, true)

    resource.features.visuals.viewmodel.enabled:set_callback(function(item)
        state = item:get()

        update_knife_callback()
        update_shutdown_callback()

        if not state then
            unset_viewmodel()
            return
        end

        set_viewmodel()
    end, true)
end

local hit_marker do
    local enabled = false

    local damage_marker do
        damage_marker = { }

        local STATE_BODY = 0
        local STATE_HEAD = 1
        local STATE_MISMATCH = 2

        local list = { }

        local state = false

        local speed = 0
        local duration = 0.0

        local colors = {
            ["Body"] = resource.features.visuals.hit_marker.damage.color:get("Body")[1],
            ["Head"] = resource.features.visuals.hit_marker.damage.color:get("Head")[1],
            ["Mismatch"] = resource.features.visuals.hit_marker.damage.color:get("Mismatch")[1]
        }

        local function get_color(state)
            if state == STATE_BODY then
                return colors["Body"]
            end

            if state == STATE_HEAD then
                return colors["Head"]
            end

            if state == STATE_MISMATCH then
                return colors["Mismatch"]
            end

            return color()
        end

        local function on_render()
            if not globals.is_in_game then
                return
            end

            local dt = globals.frametime
            local time = globals.realtime

            for i = #list, 1, -1 do
                local data = list[i]

                if time > data.remaining then
                    table.remove(list, i)
                    goto continue
                end

                data.pos.z = data.pos.z + speed * dt
                ::continue::
            end

            for i = 1, #list do
                local data = list[i]

                local alpha = 1.0

                local text = data.damage
                local color = get_color(data.state)

                local liferemaining = data.remaining - time

                if liferemaining < 0.7 then
                    alpha = liferemaining / 0.7
                end

                local screen = render.world_to_screen(data.pos)

                if screen == nil then
                    goto continue
                end

                color = color:clone()
                color.a = color.a * alpha

                render.text(1, screen, color, "c", text)
                ::continue::
            end
        end

        local function on_aim_ack(e)
            local data = list[#list]

            if data == nil then
                return
            end

            if data.damage < e.wanted_damage then
                data.state = STATE_MISMATCH
            end
        end

        local function on_player_hurt(e)
            local me = entity.get_local_player()

            local userid = entity.get(e.userid, true)
            local attacker = entity.get(e.attacker, true)

            if userid == me or attacker ~= me then
                return
            end

            local pos = userid:get_eye_position()

            local state = e.hitgroup == 1
                and STATE_HEAD or STATE_BODY

            local damage = e.dmg_health
            local remaining = globals.realtime + duration

            table.insert(list, {
                pos = pos,
                state = state,
                damage = damage,
                remaining = remaining
            })
        end

        function damage_marker.bind()
            local is_enabled = enabled and state

            -- clear table
            if not is_enabled then
                for i = 1, #list do
                    list[i] = nil
                end
            end

            events.render(on_render, is_enabled)
            events.aim_ack(on_aim_ack, is_enabled)
            events.player_hurt(on_player_hurt, is_enabled)
        end

        resource.features.visuals.hit_marker.damage.speed:set_callback(function(item)
            speed = item:get()
        end, true)

        resource.features.visuals.hit_marker.damage.duration:set_callback(function(item)
            duration = item:get()
        end, true)

        resource.features.visuals.hit_marker.damage.color:set_callback(function(item)
            local current, col = item:get()
            colors[current] = col
        end, true)

        resource.features.visuals.hit_marker.damage.enabled:set_callback(function(item)
            state = item:get()
            damage_marker.bind()
        end, true)
    end

    local screen_marker do
        screen_marker = { }

        local state = false
        local color = color()

        local hurt_time = 0.0

        local function on_render()
            if not globals.is_in_game or hurt_time <= 0 then
                return
            end

            local alpha = 1.0

            if hurt_time < 0.25 then
                alpha = hurt_time / 0.25
            end

            local col = color:clone()
            local center = render.screen_size() * 0.5

            col.a = col.a * alpha

            render.line(vector(center.x - 10, center.y - 10), vector(center.x - 5, center.y - 5), col)
            render.line(vector(center.x + 10, center.y - 10), vector(center.x + 5, center.y - 5), col)
            render.line(vector(center.x + 10, center.y + 10), vector(center.x + 5, center.y + 5), col)
            render.line(vector(center.x - 10, center.y + 10), vector(center.x - 5, center.y + 5), col)

            hurt_time = math.max(hurt_time - globals.frametime, 0.0)
        end

        local function on_player_hurt(e)
            local me = entity.get_local_player()

            local userid = entity.get(e.userid, true)
            local attacker = entity.get(e.attacker, true)

            if userid == me or attacker ~= me then
                return
            end

            hurt_time = 0.5
        end

        function screen_marker.bind()
            local is_enabled = enabled and state

            -- clear time
            if not is_enabled then
                hurt_time = 0.0
            end

            events.render(on_render, is_enabled)
            events.player_hurt(on_player_hurt, is_enabled)
        end

        resource.features.visuals.hit_marker.screen.color:set_callback(function(item)
            color = item:get()
        end, true)

        resource.features.visuals.hit_marker.screen.enabled:set_callback(function(item)
            state = item:get()
            screen_marker.bind()
        end, true)
    end

    local world_marker do
        world_marker = { }

        local list = { }

        local state = false

        local size = 0
        local thickness = 0

        local colors = {
            ["Vertical"] = resource.features.visuals.hit_marker.world.color:get("Vertical")[1],
            ["Horizontal"] = resource.features.visuals.hit_marker.world.color:get("Horizontal")[1]
        }

        local function on_render()
            if not globals.is_in_game then
                return
            end

            local dt = globals.frametime
            local time = globals.realtime

            for i = #list, 1, -1 do
                local data = list[i]

                if time > data.time then
                    table.remove(list, i)
                end
            end

            for i = 1, #list do
                local data = list[i]

                local alpha = 1.0

                local liferemaining = data.time - time

                if liferemaining < 0.7 then
                    alpha = liferemaining / 0.7
                end

                local screen = render.world_to_screen(data.point)

                if screen == nil then
                    goto continue
                end

                local thickness = thickness * 0.5
                local size = size + thickness

                local color_w = colors["Horizontal"]:clone()
                local color_h = colors["Vertical"]:clone()

                local vert_0 = vector(screen.x - thickness, screen.y - size)
                local vert_1 = vector(screen.x + thickness, screen.y + size)

                local hori_0 = vector(screen.x - size, screen.y - thickness)
                local hori_1 = vector(screen.x + size, screen.y + thickness)

                color_w.a = color_w.a * alpha
                color_h.a = color_h.a * alpha

                render.rect(hori_0, hori_1, color_w)
                render.rect(vert_0, vert_1, color_h)

                ::continue::
            end
        end

        local function on_aim_ack(e)
            local time = globals.realtime + 3.0

            table.insert(list, {
                time = time,
                point = e.aim
            })
        end

        function world_marker.bind()
            local is_enabled = enabled and state

            -- clear table
            if not is_enabled then
                for i = 1, #list do
                    list[i] = nil
                end
            end

            events.render(on_render, is_enabled)
            events.aim_ack(on_aim_ack, is_enabled)
        end

        resource.features.visuals.hit_marker.world.size:set_callback(function(item)
            size = item:get()
        end, true)

        resource.features.visuals.hit_marker.world.thickness:set_callback(function(item)
            thickness = item:get()
        end, true)

        resource.features.visuals.hit_marker.world.color:set_callback(function(item)
            local current, col = item:get()
            colors[current] = col
        end, true)

        resource.features.visuals.hit_marker.world.enabled:set_callback(function(item)
            state = item:get()
            world_marker.bind()
        end, true)
    end

    resource.features.visuals.hit_marker.enabled:set_callback(function(item)
        enabled = item:get()

        damage_marker.bind()
        screen_marker.bind()
        world_marker.bind()
    end, true)
end

local scope_overlay do
    local RESOLUTION = 1 / 1080

    local smoothy_alpha = smoothy.new(0.0)

    local position = 0
    local offset = 0

    local color = color()

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

        local color_a = color:clone()
        local color_b = color:clone()

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

    resource.features.visuals.scope_overlay.position:set_callback(function(item)
        position = item:get()
    end, true)

    resource.features.visuals.scope_overlay.offset:set_callback(function(item)
        offset = item:get()
    end, true)

    resource.features.visuals.scope_overlay.color:set_callback(function(item)
        color = item:get()
    end, true)

    resource.features.visuals.scope_overlay.exclude:set_callback(function(item)
        excluded_left = item:get("Left")
        excluded_right = item:get("Right")
        excluded_top = item:get("Top")
        excluded_bottom = item:get("Bottom")
    end, true)

    resource.features.visuals.scope_overlay.enabled:set_callback(function(item)
        local value = item:get()
        update_override(value)

        events.render(on_render, value)
        events.shutdown(on_shutdown, value)
    end, true)
end

local grenade_visuals do
    local state = false

    local grenade_prediction do
        grenade_prediction = { }

        local path_color_ref = software.visuals.world.other.grenade_prediction.color
        local color_hit_ref = software.visuals.world.other.grenade_prediction.color_hit

        local enabled = false
        local last_event = nil

        local function render_point(position, col)
            render.circle(position, col, 2.4, 0, 1.0)
            render.circle_outline(position, color(0, 0, 0, 128), 3.5, 0, 1.0, 1)
        end

        local function draw_prediction(e)
            local paths = #e.path
            local collisions = #e.collisions

            if paths == 1 then
                return
            end

            local damage = e.damage
            local is_hit = damage > 0

            local prev_position = nil

            local line_color = is_hit and color_hit_ref[1]:get()
                and color_hit_ref[2]:get() or path_color_ref:get()

            for i = 1, paths do
                local position = render.world_to_screen(e.path[i])

                if prev_position ~= nil and position ~= nil then
                    render.poly_line(line_color, position + 1, prev_position + 1)
                end

                prev_position = position
            end

            for i = 1, collisions - 1 do
                local position = render.world_to_screen(e.collisions[i])

                if position == nil then
                    goto continue
                end

                render_point(position, color(255, 255, 255, 200))
                ::continue::
            end

            local point = e.path[paths] do
                local position = render.world_to_screen(point)

                if position == nil then
                    goto continue
                end

                local target = e.target

                local point_color = is_hit
                    and color(0, 255, 40, 255)
                    or color(255, 0, 40, 255)

                render_point(position, point_color)

                if target ~= nil then
                    local origin = target:get_origin()
                    local distance = origin:dist(point)

                    local feets = aux.to_foot(distance)
                    local health = target.m_iHealth

                    local text_pos = vector(position.x, position.y - 10)

                    if e.type == "Molly" and feets <= 14.5 then
                        local text_color = feets < 12.5
                            and color(129, 171, 52, 255)
                            or color(255, 255, 255, 200)

                        render.text(1, text_pos, text_color, "c", string.format("%.1f ft", feets))
                    end

                    if e.type == "Frag" and is_hit then
                        local is_critical = damage > 50
                            or damage >= health

                        local text_color = is_critical
                            and color(129, 171, 52, 255)
                            or color(255, 255, 255, 200)

                        render.text(1, text_pos, text_color, "c", string.format("%d dmg", damage))
                    end
                end

                ::continue::
            end
        end

        local function on_render()
            if last_event ~= nil then
                draw_prediction(last_event)
            end

            last_event = nil
        end

        local function on_grenade_prediction(e)
            last_event = e
            return false
        end

        function grenade_prediction.bind()
            local is_enabled = state and enabled

            events.render(on_render, is_enabled)
            events.grenade_prediction(on_grenade_prediction, is_enabled)
        end

        resource.features.visuals.grenade_visuals.prediction:set_callback(function(item)
            enabled = item:get()
            grenade_prediction.bind()
        end, true)
    end

    local grenade_warning do
        grenade_warning = { }

        local GetCreationTime = utils.get_netvar_offset("DT_BaseCSGrenadeProjectile", "m_nExplodeEffectTickBegin") + 0x10

        local DEFAULT_WARNING_RADIUS = 30

        local MIN_UPSCALE_DISTANCE = 48
        local MAX_UPSCALE_DISTANCE = 204

        local DELTA_UPSCALE_DISTANCE = MAX_UPSCALE_DISTANCE - MIN_UPSCALE_DISTANCE

        local enabled = false

        local function get_creation_time(entity)
            return ffi.cast("float*", ffi.cast("unsigned long", entity[0]) + GetCreationTime)[0]
        end

        local function get_radius_upscale(distance)
            local clamped = math.clamp(distance, MIN_UPSCALE_DISTANCE, MAX_UPSCALE_DISTANCE)
            local upscale = 1.0 - (clamped - MIN_UPSCALE_DISTANCE) / DELTA_UPSCALE_DISTANCE

            return upscale * upscale
        end

        local function get_warning_radius(distance)
            local upscale = get_radius_upscale(distance) * 20

            return DEFAULT_WARNING_RADIUS + upscale
        end

        local function get_warning_percent(e)
            local is_projectile = e.entity["m_nExplodeEffectTickBegin"] ~= nil

            local remaining_time = e.expire_time - globals.curtime

            local expire_time = not is_projectile and 7.0
                or e.expire_time - get_creation_time(e.entity)

            return remaining_time / expire_time
        end

        local function get_warning_text(e, distance)
            if e.type == "Molly" then
                return math.ceil(distance * 0.0798)
            end

            return e.damage
        end

        local function get_screen_position(e, radius)
            local pos = render.get_offscreen(e.origin, 0.9, true)
            local screen_size = render.screen_size()

            pos.x = math.clamp(pos.x, radius, screen_size.x - radius)
            pos.y = math.clamp(pos.y, radius, screen_size.y - radius)

            return pos
        end

        local function is_beign_drawn(e, me)
            local position = me:get_origin()

            local threshold = e.type == "Frag"
                and 350 or 408

            local distance = position:distsqr(e.origin)

            return distance <= threshold * threshold
        end

        local function render_warning_gradient(e, pos, radius, distance)
            if e.type == "Frag" then
                if e.damage == 0 then
                    return nil
                end

                local damage = math.clamp(e.damage, 0, 55)
                local weight = damage / 55

                weight = math.sqrt(weight)

                local inner = color():as_hsl(
                    0, 1.0, 0.5 * weight, 0.685
                )

                outer = inner:clone()
                outer.a = 0

                render.circle_gradient(pos, outer, inner, radius, 0, 1.0)

                return nil
            end

            if e.type == "Molly" then
                if distance > 155 then
                    return nil
                end

                local inner = color(255, 0, 0, 175)

                outer = inner:clone()
                outer.a = 0

                render.circle_gradient(pos, outer, inner, radius, 0, 1.0)

                return nil
            end
        end

        local function draw_grenade_warning(e, origin)
            local distance = origin:dist(e.closest_point)
            local radius = get_warning_radius(distance)

            local pos = get_screen_position(e, radius)

            if pos == nil then
                return false
            end

            if e.type ~= "Molly" and e.damage == 0 then
                return
            end

            local percent = get_warning_percent(e)

            render.circle(pos, color(0, 0, 0, 200), radius, 0, 1.0)
            render_warning_gradient(e, pos, radius, distance)

            render.circle_outline(pos, color(255, 255, 255, 200), radius - 1, 0, percent, 2)

            local texture = e.icon do
                local icon_color = color(255, 255, 255, 230)

                local icon_size = vector(texture.width, texture.height) * 1.0
                local icon_pos = pos - icon_size / 2 - vector(0, 10)

                render.texture(texture, icon_pos, icon_size, icon_color)
            end

            local text = get_warning_text(e, distance) do
                local text_pos = pos + vector(0, 12)
                local text_color = color(255, 255, 255, 230)

                render.text(4, text_pos, text_color, "c", text)
            end
        end

        local function on_grenade_warning(e)
            local me = entity.get_local_player()

            if me == nil then
                return false
            end

            if not is_beign_drawn(e, me) then
                return false
            end

            local origin = me:get_origin()

            if origin == nil then
                return false
            end

            draw_grenade_warning(e, origin)
            return false
        end

        function grenade_warning.bind()
            events.grenade_warning(on_grenade_warning, state and enabled)
        end

        resource.features.visuals.grenade_visuals.proximity_warning:set_callback(function(item)
            enabled = item:get()
            grenade_warning.bind()
        end, true)
    end

    resource.features.visuals.grenade_visuals.enabled:set_callback(function(item)
        state = item:get()

        grenade_prediction.bind()
        grenade_warning.bind()
    end, true)
end

local damage_indicator do
    local FONTS = {
        ["Default"] = 1,
        ["Small"] = 2,
        ["Museo"] = render.load_font("museo500", 12, "ad")
    }

    local PADDING_W = 4.0
    local PADDING_H = 4.0

    local smoothy_rect = smoothy.new(0.0)

    local screen = render.screen_size()

    local window = windows.new("damage_indicator")
        :set_anchor(vector(0.0, 1.0))
        :set_pos(vector(screen.x * 0.5 + 12, screen.y * 0.5 - 12))
        :build()

    local ref = software.rage.selection.minimum_damage

    local col = color()
    local font_type = "Default"

    local function on_render()
        local me = entity.get_local_player()

        if me == nil or not me:is_alive() then
            return
        end

        local font = FONTS[font_type]

        if font == nil then
            return
        end

        local is_rect_dragged = window.is_dragged
        local is_rect_drawing = ui.get_alpha() > 0.0

        local target_alpha = is_rect_drawing and (is_rect_dragged and 0.5 or 1.0)
        local rect_alpha = smoothy_rect(0.05, target_alpha)

        local pos = window:get_pos()
        local text = tostring(ref:get())

        local text_size = render.measure_text(font, "s", text)
        local rect_size = text_size + vector(PADDING_W, PADDING_H) * 2.0 + vector(1, 0)

        local text_pos = pos + rect_size * 0.5 + vector(1, 0)

        local rect_color = color(200, 200, 200, 128)
        rect_color.a = rect_color.a * rect_alpha

        render.rect_outline(pos, pos + rect_size, rect_color, 1, 4)
        render.text(font, text_pos, col, "cs", text)

        window:set_size(rect_size)
    end

    resource.features.visuals.damage_indicator.font:set_callback(function(item)
        font_type = item:get()
    end, true)

    resource.features.visuals.damage_indicator.color:set_callback(function(item)
        col = item:get()
    end, true)

    resource.features.visuals.damage_indicator.enabled:set_callback(function(item)
        events.render(on_render, item:get())
    end, true)
end

local penetration_indicator do
    local FONTS = {
        ["Default"] = 1,
        ["Small"] = 2,
        ["Museo"] = render.load_font("museo500", 12, "ad")
    }

    local PADDING_W = 4.0
    local PADDING_H = 4.0

    local smoothy_rect = smoothy.new(0.0)

    local screen = render.screen_size()

    local window = windows.new("penetration_indicator")
        :set_anchor(vector(0.5, 1.0))
        :set_pos(vector(screen.x * 0.5, screen.y * 0.5 - 12))
        :build()

    local damage = 0

    local col = color()
    local font_type = "Default"

    local function is_weapon_gun(type)
        return type >= 1 and type <= 6
    end

    local function get_weapon_damage(e)
        local me = entity.get_local_player()

        if me == nil then
            return 0
        end

        local weapon = me:get_player_weapon()

        if weapon == nil then
            return 0
        end

        local weapon_info = weapon:get_weapon_info()

        if weapon_info == nil then
            return 0
        end

        local weapon_type = weapon_info.weapon_type

        if not is_weapon_gun(weapon_type) then
            return 0
        end

        local view = render.camera_angles()
        local forward = vector():angles(view)

        local eyepos = me:get_eye_position()
        local end_pos = eyepos + forward * 8192

        local trace = utils.trace_line(eyepos, end_pos, me, 0x4600400B)

        local fraction = trace.fraction

        if fraction == 1.0 then
            return 0
        end

        local dmg = utils.trace_bullet(me, trace.end_pos, trace.end_pos + forward * 128)
        return dmg
    end

    local function on_render()
        local me = entity.get_local_player()

        if me == nil or not me:is_alive() then
            return
        end

        local font = FONTS[font_type]

        if font == nil then
            return
        end

        local is_rect_dragged = window.is_dragged
        local is_rect_drawing = ui.get_alpha() > 0.0

        local target_alpha = is_rect_drawing and (is_rect_dragged and 0.5 or 1.0)
        local rect_alpha = smoothy_rect(0.05, target_alpha)

        if not is_rect_drawing and damage <= 0 then
            return
        end

        local pos = window:get_pos()
        local text = tostring(damage)

        local text_size = render.measure_text(font, "s", text)
        local rect_size = text_size + vector(PADDING_W, PADDING_H) * 2.0 + vector(1, 0)

        local text_pos = pos + rect_size * 0.5 + vector(1, 0)

        local rect_color = color(200, 200, 200, 128)
        rect_color.a = rect_color.a * rect_alpha

        render.rect_outline(pos, pos + rect_size, rect_color, 1, 4)
        render.text(font, text_pos, col, "cs", text)

        window:set_size(rect_size)
    end

    local function on_createmove(e)
        damage = get_weapon_damage(e)
    end


    resource.features.visuals.penetration_indicator.font:set_callback(function(item)
        font_type = item:get()
    end, true)

    resource.features.visuals.penetration_indicator.color:set_callback(function(item)
        col = item:get()
    end, true)

    resource.features.visuals.penetration_indicator.enabled:set_callback(function(item)
        local value = item:get()

        events.render(on_render, value)
        events.createmove(on_createmove, value)
    end, true)
end

local ragebot_logs do
    local HURT_ACTS = {
        ["knife"] = "Knifed",
        ["inferno"] = "Burned",
        ["hegrenade"] = "Naded"
    }

    local HITGROUP = {
        [0]  = "generic",
        [1]  = "head",
        [2]  = "chest",
        [3]  = "stomach",
        [4]  = "left arm",
        [5]  = "right arm",
        [6]  = "left leg",
        [7]  = "right leg",
        [8]  = "neck",
        [10] = "gear"
    }

    local fire_time = 0.0

    local function colorf(fmt, repl)
        local count = 0

        local result = fmt:gsub("%${(.-)}", function(str)
            count = count + 1

            return string.format(
                "\a%s%s\aDEFAULT", repl[count], str
            )
        end)

        return result
    end

    local function prefixf(str)
        return "\aA0B5DFFF" .. "aesthetic" .. "\aABABABFF" .. " · " .. "\aDEFAULT" .. str
    end

    local function get_hitgroup(id)
        return HITGROUP[id] or "?"
    end

    local function on_aim_fire(e)
        fire_time = globals.server_tick
    end

    local function on_aim_miss(e)
        local target = e.target

        if target == nil then
            return
        end

        local hitchance = e.hitchance
        local backtrack = e.backtrack

        local wanted_hitgroup = e.wanted_hitgroup

        local target_name = target:get_name()

        local details do
            local list = { }

            table.insert(list, string.format("hc: \a97B1BBFF%d%%\aDEFAULT", hitchance))
            table.insert(list, string.format("history: \a97B1BBFF%dt\aDEFAULT", backtrack))

            details = table.concat(list, "\aABABABFF · \aDEFAULT")
        end

        local text do
            local palette = { "E33636FF", "97B1BBFF", "9AFF9AFF" }

            local fmt = string.format(
                "Missed ${%s}'s ${%s} due to ${%s} (%s)",
                target_name, get_hitgroup(wanted_hitgroup), e.state, details
            )

            text = colorf(fmt, palette)
        end

        print_dev(text)
        print_raw(prefixf(text))
    end

    local function on_aim_hit(e)
        local target = e.target

        if target == nil then
            return
        end

        local elapsed = math.max(globals.server_tick - fire_time - 1, 0)

        local hitchance = e.hitchance
        local backtrack = e.backtrack

        local damage = e.damage
        local hitgroup = e.hitgroup

        local wanted_damage = e.wanted_damage
        local wanted_hitgroup = e.wanted_hitgroup

        local target_name = target:get_name()

        local details = { } do
            local sep = "\aABABABFF · \aDEFAULT"

            table.insert(details, string.format("hc: \a97B1BBFF%d%%\aDEFAULT", hitchance))
            table.insert(details, string.format("history: \a97B1BBFF%dt\aDEFAULT", backtrack))

            details.dev = table.concat(details, sep)

            table.insert(details, string.format("elapsed: \a97B1BBFF%dt\aDEFAULT", elapsed))
            details.raw = table.concat(details, sep)
        end

        local text = { } do
            local damage_text = string.format("\a97B1BBFF%d\aDEFAULT", damage)
            local hitgroup_text = string.format("\a97B1BBFF%s\aDEFAULT", get_hitgroup(hitgroup))

            if damage ~= wanted_damage then
                damage_text = damage_text .. string.format("(\a97B1BBFF%d\aDEFAULT)", wanted_damage)
            end

            if hitgroup ~= wanted_hitgroup then
                hitgroup_text = hitgroup_text .. string.format("(\a97B1BBFF%s\aDEFAULT)", get_hitgroup(wanted_hitgroup))
            end

            local palette = { "E33636FF" }

            local fmt_dev = string.format("Hit ${%s} in the %s for %s damage (%s)", target_name, hitgroup_text, damage_text, details.dev)
            local fmt_raw = string.format("Hit ${%s} in the %s for %s damage (%s)", target_name, hitgroup_text, damage_text, details.raw)

            text.dev = colorf(fmt_dev, palette)
            text.raw = colorf(fmt_raw, palette)
        end

        print_dev(text.dev)
        print_raw(prefixf(text.raw))
    end

    local function on_aim_ack(e)
        if e.state ~= nil then
            on_aim_miss(e)
        else
            on_aim_hit(e)
        end
    end

    local function on_player_hurt(e)
        local me = entity.get_local_player()

        local userid = entity.get(e.userid, true)
        local attacker = entity.get(e.attacker, true)

        if me == userid or me ~= attacker then
            return
        end

        local act = HURT_ACTS[e.weapon]

        if act == nil then
            return
        end

        local name = userid:get_name()

        local health = e.health
        local damage = e.dmg_health

        local text = string.format("%s ${%s} for ${%d} damage (${%d} health remaining)", act, name, damage, health) do
            text = colorf(text, { "E33636FF", "97B1BBFF", "97B1BBFF" })
        end

        print_dev(text)
        print_raw(prefixf(text))
    end

    local function on_item_purchase(e)
        local userid = entity.get(e.userid, true)

        if userid == nil or not userid:is_enemy() then
            return
        end

        local weapon = e.weapon

        if weapon == "weapon_unknown" then
            return
        end

        local name = userid:get_name()

        local text = string.format("${%s} bought ${%s}", name, weapon) do
            text = colorf(text, { "E33636FF", "97B1BBFF" })
        end

        print_dev(text)
        print_raw(prefixf(text))
    end

    resource.features.ragebot.aimbot_logs.select:set_callback(function(item)
        local has_aimbot = item:get("Aimbot")
        local has_purchases = item:get("Purchases")

        events.aim_fire(on_aim_fire, has_aimbot)
        events.aim_ack(on_aim_ack, has_aimbot)

        events.player_hurt(on_player_hurt, has_aimbot)
        events.item_purchase(on_item_purchase, has_purchases)
    end, true)
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

    local function on_createmove(e)
        software.rage.main.dormant_aimbot:override(false)

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

        if e.in_jump and not onground then
            return
        end

        local weapon_type = weapon_info.weapon_type

        if not is_weapon_gun(weapon_type) or weapon.m_iClip1 <= 0 then
            return false
        end

        local targets = get_aimbot_targets()
        local hitboxes = resource.features.ragebot.dormant_aimbot.hitboxes:get()

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

        local hitchance = resource.features.ragebot.dormant_aimbot.hitchance:get()
        local desired_damage = resource.features.ragebot.dormant_aimbot.minimum_damage:get()

        if desired_damage == 0 then
            desired_damage = software.rage.selection.minimum_damage:get()
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

        e.block_movement = 1

        if resource.features.ragebot.dormant_aimbot.auto_scope:get() then
            local is_onground = not e.in_jump and onground

            local is_scoped = me.m_bIsScoped or me.m_bResumeZoom
            local is_sniper = weapon_info.weapon_type == WEAPONTYPE_SNIPER_RIFLE

            if not is_scoped and is_sniper and is_onground then
                e.in_attack2 = true
            end
        end

        if inaccuracy < 0.01 then
            e.view_angles = angles
            e.in_attack = true

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
        software.rage.main.dormant_aimbot:override()
    end

    resource.features.ragebot.dormant_aimbot.enabled:set_callback(function(item)
        local value = item:get()

        if not value then
            software.rage.main.dormant_aimbot:override()
        end

        events.shutdown(on_shutdown, value)
        events.createmove(on_createmove, value)

        events.weapon_fire(on_weapon_fire, value)
        events.player_hurt(on_player_hurt, value)
    end, true)
end

local ai_peek do
    local FL_ONGROUND = bit.lshift(1, 0)

    local HITGROUP_GENERIC  = 0
    local HITGROUP_HEAD     = 1
    local HITGROUP_CHEST    = 2
    local HITGROUP_STOMACH  = 3
    local HITGROUP_LEFTARM  = 4
    local HITGROUP_RIGHTARM	= 5
    local HITGROUP_LEFTLEG  = 6
    local HITGROUP_RIGHTLEG	= 7
    local HITGROUP_GEAR     = 10

    local HITBOX_HEAD            = 0
    local HITBOX_NECK            = 1
    local HITBOX_PELVIS          = 2
    local HITBOX_STOMACH         = 3
    local HITBOX_LOWER_CHEST     = 4
    local HITBOX_CHEST           = 5
    local HITBOX_UPPER_CHEST     = 6
    local HITBOX_RIGHT_THIGH     = 7
    local HITBOX_LEFT_THIGH      = 8
    local HITBOX_RIGHT_CALF      = 9
    local HITBOX_LEFT_CALF       = 10
    local HITBOX_RIGHT_FOOT      = 11
    local HITBOX_LEFT_FOOT       = 12
    local HITBOX_RIGHT_HAND      = 13
    local HITBOX_LEFT_HAND       = 14
    local HITBOX_RIGHT_UPPER_ARM = 15
    local HITBOX_RIGHT_FOREARM   = 16
    local HITBOX_LEFT_UPPER_ARM  = 17
    local HITBOX_LEFT_FOREARM    = 18

    local to_hitgroups = {
        [HITBOX_HEAD] = HITGROUP_HEAD,

        [HITBOX_CHEST] = HITGROUP_CHEST,
        [HITBOX_STOMACH] = HITGROUP_STOMACH,

        [HITBOX_LEFT_THIGH] = HITGROUP_LEFTLEG,
        [HITBOX_RIGHT_THIGH] = HITGROUP_RIGHTLEG,

        [HITBOX_LEFT_FOOT] = HITGROUP_LEFTLEG,
        [HITBOX_RIGHT_FOOT] = HITGROUP_RIGHTLEG,

        [HITBOX_LEFT_UPPER_ARM] = HITGROUP_LEFTARM,
        [HITBOX_RIGHT_UPPER_ARM] = HITGROUP_RIGHTARM
    }

    local data = nil

    local rate_time = 0
    local retreat_pos = nil

    local function clear_data()
        data = nil
        rate_time = 0
    end

    local function reset_peek()
        software.rage.main.double_tap:override()
        software.rage.main.peek_assist[4]:override()

    end

    local function prepare_extra_features()
        local hitchance = resource.features.ragebot.ai_peek.hitchance:get()

        software.rage.main.peek_assist[4]:override("On Shot")
    end

    local function get_hitbox_damage_mult(hitgroup)
        if hitgroup == HITGROUP_HEAD then
            return 4.0
        end

        if hitgroup == HITGROUP_STOMACH then
            return 1.25
        end

        if hitgroup == HITGROUP_LEFTLEG then
            return 0.75
        end

        if hitgroup == HITGROUP_RIGHTLEG then
            return 0.75
        end

        return 1.0
    end

    local function scale_damage(enemy, damage, hitgroup, weapon_armor_ratio)
        damage = damage * get_hitbox_damage_mult(hitgroup)

        if enemy.m_ArmorValue > 0 then
            if hitgroup == HITGROUP_HEAD then
                if enemy.m_bHasHelmet then
                    damage = damage * (weapon_armor_ratio * 0.5)
                end
            else
                damage = damage * (weapon_armor_ratio * 0.5)
            end
        end

        return damage
    end

    local function simulate_damage(start_pos, end_pos, enemy, hitgroup, data)
        local delta = end_pos - start_pos

        local damage = data.damage
        local armor_ratio = data.armor_ratio

        local range = data.range
        local range_modifier = data.range_modifier

        local length = math.min(range, delta:length())

        damage = damage * math.pow(range_modifier, length * 0.002)
        damage = scale_damage(enemy, damage, hitgroup, armor_ratio)

        return damage
    end

    local function get_simulation_time()
        return resource.features.ragebot.ai_peek.simulation:get() * 0.01
    end

    local function get_rate_limit()
        return resource.features.ragebot.ai_peek.rate_limit:get() * 0.01
    end

    local function get_wish_damage()
        return software.rage.selection.minimum_damage:get()
    end

    local function get_ground_pos(player)
        if player == nil then
            return
        end

        local origin = player:get_origin()

        if bit.band(player.m_fFlags, FL_ONGROUND) == 0 then
            local tr = utils.trace_line(
                origin, origin - vector(0, 0, 8192), player, 0x201400B
            )

            return tr.end_pos
        end

        return origin
    end

    local function get_hitbox_list()
        local list = { }

        if resource.features.ragebot.ai_peek.hitboxes:get "Head" then
            table.insert(list, HITBOX_HEAD)
        end

        if resource.features.ragebot.ai_peek.hitboxes:get "Chest" then
            table.insert(list, HITBOX_CHEST)
        end

        if resource.features.ragebot.ai_peek.hitboxes:get "Stomach" then
            table.insert(list, HITBOX_STOMACH)
        end

        if resource.features.ragebot.ai_peek.hitboxes:get "Arms" then
            table.insert(list, HITBOX_LEFT_UPPER_ARM)
            table.insert(list, HITBOX_RIGHT_UPPER_ARM)
        end

        if resource.features.ragebot.ai_peek.hitboxes:get "Legs" then
            table.insert(list, HITBOX_LEFT_THIGH)
            table.insert(list, HITBOX_RIGHT_THIGH)

            table.insert(list, HITBOX_LEFT_CALF)
            table.insert(list, HITBOX_RIGHT_CALF)
        end

        return list
    end

    local function get_hitgroup(hitbox)
        return to_hitgroups[hitbox]
            or HITGROUP_GENERIC
    end

    local function get_entity_ptr(entity)
        return entity[0]
    end

    local function get_weapon_type(weapon, weapon_info)
        local weapon_index = weapon:get_weapon_index()
        local weapon_type = weapon_info.weapon_type


        if weapon_type == 1 then
            return "Pistols"
        end

        if weapon_type == 5 then
            return 'Snipers'
        end

        return nil
    end

    local function get_wish_hitboxes(list, player, weapon, target, wish_damage)
        local hitboxes = { }

        local eye_pos = player:get_eye_position()
        local weapon_info = weapon:get_weapon_info()

        local target_health = target.m_iHealth

        for i = 1, #list do
            local hitbox = list[i]
            local hitgroup = get_hitgroup(hitbox)

            local pos = target:get_hitbox_position(hitbox)
            local damage = simulate_damage(eye_pos, pos, target, hitgroup, weapon_info)

            local cant_hit = damage < wish_damage
            local cant_kill = damage < target_health

            if cant_hit and cant_kill then
                goto continue
            end

            table.insert(hitboxes, {
                index = i,
                pos = pos
            })

            ::continue::
        end

        return hitboxes
    end

    local function is_valid_player(player)
        if player == nil then
            return false
        end

        local ok, result = pcall(get_entity_ptr, player)

        if not ok or result == nil then
            return false
        end

        return true
    end

    local function is_valid_data(data)
        return is_valid_player(data.target)
    end

    local function is_key_released(cmd)
        return not cmd.in_forward
            and not cmd.in_back
            and not cmd.in_moveleft
            and not cmd.in_moveright
    end

    local function is_allowed_weapon(weapon)
        return resource.features.ragebot.ai_peek.weapons:get(weapon)
    end

    local function is_player_ready(player, weapon, weapon_info)
        if player == nil or weapon == nil then
            return false
        end

        -- if weapon can't shot at all
        if weapon_info.max_clip1 == 0 or weapon.m_iClip1 == 0 then
            return false
        end

        if globals.curtime < player.m_flNextAttack then
            return false
        end

        if globals.curtime < weapon.m_flNextPrimaryAttack then
            return false
        end

        return true
    end

    local function should_update_data()
        if not software.rage.main.double_tap:get() then
            return false
        end

        return true
    end

    local function create_data(ctx, target)
        local data = { }

        data.ctx = ctx
        data.target = target

        data.simtime = 0
        data.retreat = -1

        return data
    end

    local function create_sim_movement(player)
        return player:simulate_movement(
            nil, vector(), 0x01
        )
    end

    local function trace_bullet(from_player, from, to)
        local damage, tr = utils.trace_bullet(
            from_player, from, to, function(ent)
                return ent ~= from_player
                    and ent:is_enemy()
            end
        )

        return damage, tr
    end

    local function update_sim_hitscan(ctx, player, target, hitboxes, wish_damage)
        local health = target.m_iHealth

        local eye_pos = ctx.origin +
            vector(0, 0, ctx.view_offset)

        for i = 1, #hitboxes do
            local hitbox = hitboxes[i]

            local damage, tr = trace_bullet(
                player, eye_pos, hitbox.pos
            )

            local can_hit = damage >= wish_damage
            local can_kill = damage >= health

            if can_hit or can_kill then
                return ctx, true
            end
        end

        return ctx, false
    end

    local function update_retreat_point(player)
        local me = entity.get_local_player()

        if not me or me == nil then
            return
        end
        
        if not player or player == nil then
            player = me
        end

        if retreat_pos == nil then
            retreat_pos = get_ground_pos(player)
        end
    end

    local function update_simulation(cmd, player, target, ctx, angle, hitboxes, wish_damage)
        cmd.view_angles.y = angle
        ctx:think(1)

        if bit.band(ctx.flags, FL_ONGROUND) == 0 then
            return nil, false
        end

        local _, found_damage = update_sim_hitscan(
            ctx, player, target, hitboxes, wish_damage
        )

        if found_damage then
            ctx:think(1)
        end

        return ctx, found_damage
    end

    local function update_peek_data(cmd, player, weapon)
        if not should_update_data() then
            return false
        end

        local dt = globals.frametime

        local rate_limit = get_rate_limit()
        local wish_damage = get_wish_damage()

        local hitbox_list = get_hitbox_list()

        if data ~= nil and is_valid_data(data) then
            local ctx = data.ctx
            local target = data.target

            local health = target.m_iHealth

            if wish_damage >= 100 then
                wish_damage = wish_damage + health - 100
            end

            local hitboxes = get_wish_hitboxes(
                hitbox_list, player, weapon, target, wish_damage
            )

            local _, found_damage = update_sim_hitscan(
                ctx, player, target, hitboxes, wish_damage
            )

            if found_damage then
                data.simtime = 0
            end

            data.simtime = data.simtime + dt
            return true
        end

        if rate_limit > 0 then
            if rate_time > 0 then
                rate_time = rate_time - dt
                return false
            end

            rate_time = rate_limit
        end

        -- skip if not planning to stay
        if not is_key_released(cmd) then
            return false
        end

        -- skip if player is in air
        local m_fFlags = player.m_fFlags

        if bit.band(m_fFlags, FL_ONGROUND) == 0 then
            return false
        end

        -- skip if speed 2d > 80
        local velocity = player.m_vecVelocity

        if velocity:length2dsqr() > (80 * 80) then
            return false
        end

        -- make new target
        local threat = entity.get_threat()

        if threat == nil or threat:is_dormant() then
            return false
        end

        local health = threat.m_iHealth

        if wish_damage >= 100 then
            wish_damage = wish_damage + health - 100
        end

        local hitboxes = get_wish_hitboxes(
            hitbox_list, player, weapon, threat, wish_damage
        )

        local left_angle, right_angle do
            local player_origin = player:get_origin()
            local threat_origin = threat:get_origin()

            local delta = threat_origin - player_origin
            local angles = delta:angles()

            local yaw = angles.y + 180

            left_angle = yaw - 90
            right_angle = yaw + 90
        end

        -- backup usercmd
        local old_viewangles = cmd.view_angles:clone()

        local old_forwardmove = cmd.forwardmove
        local old_sidemove = cmd.sidemove

        local old_in_duck = cmd.in_duck
        local old_in_jump = cmd.in_jump
        local old_in_speed = cmd.in_speed

        -- setting up usercmd
        cmd.forwardmove = 450
        cmd.sidemove = 0

        cmd.in_duck = false
        cmd.in_jump = false
        cmd.in_speed = false

        -- creating context
        local left_ctx = create_sim_movement(player)
        local right_ctx = create_sim_movement(player)

        local left_step = 0
        local right_step = 0

        for i = 1, 20 do
            if left_step ~= -1 then
                left_step = i

                local ctx, found_damage = update_simulation(
                    cmd, player, threat, left_ctx, left_angle, hitboxes, wish_damage
                )

                if ctx == nil then
                    left_step = -1
                end

                if found_damage then
                    data = create_data(
                        ctx, threat
                    )

                    break
                end
            end

            if right_step ~= -1 then
                right_step = i

                local ctx, found = update_simulation(
                    cmd, player, threat, right_ctx, right_angle, hitboxes, wish_damage
                )

                if ctx == nil then
                    right_step = -1
                end

                if found then
                    data = create_data(
                        ctx, threat
                    )

                    break
                end
            end
        end

        -- restore usercmd
        cmd.view_angles.y = old_viewangles.y

        cmd.forwardmove = old_forwardmove
        cmd.sidemove = old_sidemove

        cmd.in_duck = old_in_duck
        cmd.in_jump = old_in_jump
        cmd.in_speed = old_in_speed

        return data ~= nil
    end

    local function update_movement(cmd, player, destination)
        local origin = player:get_origin()
        local delta = destination - origin

        local lengthsqr = delta:length2dsqr()

        if lengthsqr < (5.0 * 5.0) then
            local velocity = player.m_vecVelocity

            local speed = velocity:length()
            local angles = velocity:angles()

            cmd.move_yaw = angles.y

            cmd.forwardmove = -speed
            cmd.sidemove = 0

            return true, lengthsqr
        end

        local angles = delta:angles()

        cmd.move_yaw = angles.y

        cmd.forwardmove = 450
        cmd.sidemove = 0

        return false, lengthsqr
    end

    local function block_movement_keys(cmd)
        cmd.in_duck = false
        cmd.in_jump = false
        cmd.in_speed = false

        cmd.in_forward = true
        cmd.in_back = false
        cmd.in_moveleft = false
        cmd.in_moveright = false
    end

    local function update_ai_peek(cmd, player, weapon, weapon_info)
        update_retreat_point(player)

        local is_ready = is_player_ready(
            player, weapon, weapon_info
        )

        local is_updated = update_peek_data(
            cmd, player, weapon
        )

        if data == nil then
            return
        end

        local simtime = get_simulation_time()

        if data.simtime > simtime then
            is_updated = false
        end

        if weapon_info.weapon_type == 5 and not player.m_bIsScoped then
            is_updated = false
        end

        if data.retreat <= 0 then
            if is_ready and is_updated then
                local ctx = data.ctx

                local is_quick_stop, lengthsqr = update_movement(
                    cmd, player, ctx.origin
                )

                block_movement_keys(cmd)
                prepare_extra_features()

                data.retreat = 0

                if is_quick_stop then
                    data.retreat = 1
                end

                debug_overlay.box_new(
                    ctx.origin,
                    ctx.obb_mins,
                    ctx.obb_maxs,
                    vector(),
                    color(0, 0, 0, 0),
                    resource.features.ragebot.ai_peek.color:get(),
                    globals.tickinterval * 2
                )

                return
            end
        end

        if data.retreat == -1 then
            return
        end

        local is_quick_stop, lengthsqr = update_movement(
            cmd, player, retreat_pos
        )

        block_movement_keys(cmd)

        data.retreat = data.retreat + 1

        if data.retreat >= 3 then
            software.rage.main.double_tap:override(false)
        end

        if is_ready and is_quick_stop then
            clear_data()
            reset_peek()
        end
    end

    local function on_createmove(cmd)
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

        local weapon_type = get_weapon_type(
            weapon, weapon_info
        )

        if not is_allowed_weapon(weapon_type) then
            return
        end

        update_ai_peek(cmd, me, weapon, weapon_info)
    end

    local function on_aim_fire()
        if data == nil then
            return nil
        end

        data.retreat = 1
    end

    resource.features.ragebot.ai_peek.enabled:set_callback(function(item)
        local value = item:get()

        if not value then
            clear_data()
            reset_peek()
            
            retreat_pos = nil
        end

        if value then
            retreat_pos = update_retreat_point()
        end

        events.aim_fire(on_aim_fire, value)
        events.createmove(on_createmove, value)
    end, true)
end

local kill_say do
    local MESSAGES = {
        ["On Kill"] = {
            {
                { "SHAMELESS достает из кейса: ★ Мать этого бомжа", 2.50 },
            },

            {
                { "1", 0.70 },
                {"желейка хуевая)", 1.7},
            },

            {
                { "ахахахха", 1.20 },
                { "позорище еба", 2.1},
                { "ебаное", 1.4},
            },

            {
                { "слоумо позорное", 1.60 },
                { "очень медленный", 2.0},
            },

            {
                {"1", 1.2 },
            },

            {
                {"зря ты умер", 1.8},
                {"команду подвел", 1},
            },

            {
                {"я использую aesthetic", 2.1},
                {"лучший скрипт", 1.2},
                {"на нл", 1},
            },

            {
                {"[etdfz gbljhfcbyf", 2.1},
                {"хуевая пидорасина", 2.1},
            },

            {
                {"спокойной ночи", 2.1},
                {"в сон отпрвил аххах", 2.6},
            },

            {
                {"куда пикнул засранец", 2.1},
                {"лучше бы по-другому сыграл", 2.9},
            },

            {
                {"ᴨоᴄᴛᴀʙиᴧ ᴛʙою чоᴛᴋоᴄᴛь ᴨод ᴄоʍнᴇниᴇ", 2.8}
            },
            {
                {"иди сюда", 1},
                {"к папочке", 1.9}
            },
            {
                {"THIS IS LCCCCCCC (◣_◢)", 2.3},
            },
            {
                {"ты точно человек?", 1.9},
                {"а то играешь как животное хуевое", 2.6}
            },
            {
                {"Shameless. Подписаться", 2},
                {"Maut. Отписаться", 2.5}
            },
            {
                {"сосал?", 1.2},
                {"соври", 1.8},
                {"не ври", 2}
            },
            {
                {"первый", 1.8},
                {"лй", 1.8},
                {"последний день на хвх", 1.8},
                {"зашел таких как ты поубивать", 1.9}
            },
            {
                {"бля как так-то", 2.0},
                {"не получилось забайтить", 2.4},
                {"да?", 1.4}
            },
            {
                {"чот я тебя тапаю все время", 2.3},
                {"луасенс или что ты используешь", 2.8}
            },
            {
                {"нормально я тебя забайтил", 2.4}
            },
            {
                {"ты умер по какой причине???", 2.2}
            },
            {
                {"сорян", 1.6},
                {"просто чит сегодня бодрый", 2.3}
            },
            {
                {"зря пикнул братан", 1.9}
            },
            {
                {"какой же все таки хуевый у тебя чит", 3}
            },
            {
                {"повезло", 1},
                {"мне", 1}
            },
            {
                {"новая приватная настройка у мя", 2.1}
            },
            {
                {"легчайший килл", 2.0},
                {"для сильнейшего игрока", 2.4}
            },
            {
                {"переигран пидорас", 2.1}
            },
            {
                {"прошу", 1.7},
                {"не ливай с сервера", 2.3}
            },
            {
                {"1", 1},
                {"negjq ,jv;", 2},
                {"тупой бомж*", 2},
            },
            {
                {"ахахаха", 2},
                {"и ты себя игроком считаешь?", 2.5},
            },
            {
                {"ой долбаеб", 2},
                {"лучше ливай с сервера", 2},
                {"!admin", 2},

            },
            {
                {"отпиздил хаченка", 2},
                {"SMERT XA4AM LUA", 2}
            },
            {
                {"пархай как папочка", 2},
                {"жаль что я тебя тапнул", 2.5}
            },
            {
                {"ты куда пикнул", 2},
                {"догодяга ебаная", 2.5}
            },
            {
                {"слабачок нищий", 2},
                {"без аккаунта нормального", 2.5}
            },
            {
                {"спи чмо", 2}
            },
            {
                {"welcome to hell пидорас", 2.3}
            },
            {
                {"12", 1},
                {"1", 1}
            },
            {
                {"упала шлюха", 2},
                {"зря пикаешь такое", 2.5}
            },
            {
                {"Создатель LUA MonixLITE ◣_◢", 2}
            },
            {
                {"by filev", 2}
            },
            {
                {"все это ты до и после хуй те в рот", 3}
            },
            {
                {"на пенисяку говори", 2},
                {"уебище", 1.6}
            }

        },
        ["On Death"] = {
            {
                { "сука", 1.1},
                {"лаки ебаное", 1.4},
            },
            {
                {"зачем ты так со мной?(", 2}
            },
            {
                {"ну не повезло мне", 2},
                {"с кем не бывает?", 2}
            },
            {
                {"я хуевый", 1.8},
                {"простите команда", 2}
            },
            {
                {"анлак", 1.5},
                {"в очередной раз", 1.4}
            },
            {
                {"бля ты совсем долбаеб", 1.9},
                {"куда ты пикаешь пидорасина", 2}
            },
            {
                {"ну ПИДОРАС ебаный", 2},
                {"КУДА Я МИССНУЛ", 1.5},
            },
            {
                {"ну конечно", 1.3},
                {"опять запредиктили", 1.9},
                {"и опять в отжатие", 2}
            },
            {
                {"ДА КАК ТЫ МЕНЯ УБИЛ", 2},
                {"я же с читами", 1.4}

            },
            {
                {"хуйня тапнула", 2},
                {"красава доминик", 2}
            },
            {
                {"ndfhm t,fyfz ujhb d fle", 3}
            },

            {
                {"как я опять умер???", 2},
                {"вроде стараюсь как могу", 2.5}
            },
            {
                {"да ебаная клавиатура", 2.5},
                {"у меня с пробелом хуйня какая то", 3}
            },
            {
                {"не", 1.5},
                {"сегодня вообще нихуя не стреляет чит", 3}
            },
            {
                {"нормально у меня аипик забайтился", 3},
                {"а не", 1.5},
                {"чит не стрельнул прост", 2.3}
            },
            {
                {"ага", 2},
                {"ты типа не лаки", 2},
                {"да?", 1.3}
            }

        },
        ["Rampage"] = {
            {
                {"1", 1.5}
            },
            {
                {"карма пидорас", 2}
            }
        }

    }

    local query = { }

    local msg_index = 0
    local rampage_target = nil

    local function clear_query()
        for i = 1, #query do
            query[i] = nil
        end
    end

    local function in_warmup_period()
        local game_rules = entity.get_game_rules()

        if game_rules == nil then
            return false
        end

        return game_rules.m_bWarmupPeriod
    end

    local function find_random_msg(type)
        local msg_list = MESSAGES[type]

        if msg_list == nil then
            return nil
        end

        msg_index = msg_index % #msg_list
        msg_index = msg_index + 1

        return msg_list[msg_index + 1]
    end

    local function send_to_queue(type)
        if not resource.features.visuals.kill_say.triggers:get(type) then
            return
        end

        local msg = find_random_msg(type)

        if msg == nil then
            return
        end

        for i = 1, #msg do
            local data = msg[i]

            table.insert(query, {
                data[1],
                data[2]
            })
        end
    end

    local function say_to_chat(text)
        utils.console_exec("say " .. text)
    end

    local function on_round_start(e)
        rampage_target = nil
    end

    local function on_player_death(e)
        local me = entity.get_local_player()

        local userid = entity.get(e.userid, true)
        local attacker = entity.get(e.attacker, true)

        if me == userid and me ~= attacker then
            rampage_target = attacker
            send_to_queue "On Death"

            return
        end

        if me ~= userid and me == attacker then
            send_to_queue "On Kill"

            return
        end

        if rampage_target == userid and me ~= attacker then
            send_to_queue "Rampage"

            return
        end
    end

    local function on_net_update_start()
        if resource.features.visuals.kill_say.disablers:get "On Warmup" and in_warmup_period() then
            clear_query()
            return
        end

        local msg = query[1]

        if msg == nil then
            return
        end

        msg[2] = msg[2] - globals.frametime

        if msg[2] > 0 then
            return
        end

        say_to_chat(msg[1])
        table.remove(query, 1)
    end

    resource.features.visuals.kill_say.enabled:set_callback(function(item)
        local value = item:get()

        events.round_start(on_round_start, value)
        events.player_death(on_player_death, value)
        events.net_update_start(on_net_update_start, value)
    end, true)
end

local fake_latency do
    local state = false
    local value = 0

    local sv_maxunlag = cvar.sv_maxunlag

    local ref = software.misc.main.other.fake_latency

    local function unset_override()
        ref:override()
        sv_maxunlag:float(tonumber(sv_maxunlag:string()), true)
    end

    local function set_override()
        ref:override(value)
        sv_maxunlag:float(0.400, true)
    end

    local function update_fake_latency()
        if not state then
            return
        end

        set_override()
    end

    local function on_shutdown()
        unset_override()
    end

    resource.features.ragebot.fake_latency.value:set_callback(function(item)
        value = item:get()
        update_fake_latency()
    end, true)

    resource.features.ragebot.fake_latency.enabled:set_callback(function(item)
        state = item:get()

        if not state then
            unset_override()
        end

        update_fake_latency()
        events.shutdown(on_shutdown, state)
    end, true)
end

local super_toss do
    local GRENADE_SECONDARY_DAMPENING = 0.3

    local function lerp(a, b, t)
        return a + t * (b - a)
    end

    local function resolve_grenade_throw(goal_angles, throw_velocity, throw_strength, abs_velocity)
        goal_angles.x = goal_angles.x - 10 + math.abs(goal_angles.x) / 9

        local goal_forward = vector():angles(goal_angles)
        local player_vel = abs_velocity * 1.25

        local vel = math.clamp(throw_velocity * 0.9, 15, 750)
        local clamped_throw_strength = math.clamp(throw_strength, 0, 1)

        vel = vel * lerp(GRENADE_SECONDARY_DAMPENING, 1.0, clamped_throw_strength)

        local new_forward = goal_forward

        for _ = 1, 8 do
            new_forward = (goal_forward * (new_forward * vel + player_vel):length() - player_vel) / vel
            new_forward:normalize()
        end

        local new_angles = new_forward:angles()

        if new_angles.x > -10 then
            new_angles.x = 0.9 * new_angles.x + 9
        else
            new_angles.x = 1.125 * new_angles.x + 11.25
        end

        return new_angles
    end

    local function on_grenade_override_view(e)
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

        e.angles = resolve_grenade_throw(e.angles, weapon_info.throw_velocity, weapon.m_flThrowStrength, e.velocity)
    end

    local last_local_velocity = vector()
    local local_velocity = vector()

    local function on_createmove(cmd)
        if cmd.jitter_move ~= true then
            return
        end

        local me = entity.get_local_player()

        if me == nil then
            return
        end

        local weapon = me:get_player_weapon()

        if weapon == nil then
            return
        end

        local weapon_info = weapon:get_weapon_info()

        if weapon_info == nil or weapon_info.weapon_type ~= 9 then
            return
        end

        if weapon.m_fThrowTime < (globals.curtime - to_time(globals.clock_offset)) then
            return
        end

        cmd.in_speed = true

        local simulation_ctx = me:simulate_movement()
        simulation_ctx:think()

        cmd.view_angles = resolve_grenade_throw(cmd.view_angles, weapon_info.throw_velocity, weapon.m_flThrowStrength, simulation_ctx.velocity)
    end

    resource.features.movement.super_toss.enabled:set_callback(function(item)
        local value = item:get()

        events.createmove(on_createmove, value)
        events.grenade_override_view(on_grenade_override_view, value)
    end, true)
end

local hitchance do
    local WEAPONIDX_SSG08 = 40

    local list = resource.features.ragebot.hitchance.list

    local hitchance_ref = software.rage.selection.hit_chance
    local air_strafe_ref = software.misc.main.movement.air_strafe

    local ref_list = { } do
        for i = 1, #list do
            local weapon = list[i]

            ref_list[weapon] = {
                hitchance = ui.find("Aimbot", "Ragebot", "Selection", weapon, "Hit Chance"),
                auto_scope = ui.find("Aimbot", "Ragebot", "Accuracy", weapon, "Auto Scope")
            }
        end
    end

    local function is_bind_applied()
        local binds = ui.get_binds(true)

        for i = 1, #binds do
            local bind = binds[i]

            local value = bind.value
            local reference = bind.reference

            if reference:get() ~= value then
                goto continue
            end

            if reference:id() == hitchance_ref:id() then
                return true
            end

            ::continue::
        end

        return false
    end

    local function is_velocity_small(velocity)
        return math.abs(velocity.x) < 10.0
            and math.abs(velocity.y) < 10.0
    end

    local function is_should_jump_scout()
        local me = entity.get_local_player()

        if me == nil then
            return false
        end

        local weapon = me:get_player_weapon()

        if weapon == nil then
            return false
        end

        local index = weapon:get_weapon_index()

        if index ~= WEAPONIDX_SSG08 then
            return false
        end

        local velocity = me.m_vecVelocity

        if not is_velocity_small(velocity) then
            return false
        end

        return true
    end

    local function is_should_no_scope(player, threat, max_distance)
        if player.m_bIsScoped or threat == nil then
            return false
        end

        if max_distance == 1001 then
            return true
        end

        local player_origin = player:get_origin()
        local threat_origin = threat:get_origin()

        local delta = threat_origin - player_origin
        local distance = aux.to_foot(delta:length())

        return distance <= max_distance * 0.1
    end

    local function get_weapon_type(weapon)
        local index = weapon:get_weapon_index()

        local weapon_info = weapon:get_weapon_info()
        local weapon_type = weapon_info.weapon_type

        if weapon_type == 1 then
            if index == 64 then
                return "R8 Revolver"
            end

            return "Pistols"
        end

        if weapon_type == 5 then
            if index == 9 then
                return "AWP"
            end

            if index == 40 then
                return "SSG-08"
            end

            return "AutoSnipers"
        end

        return nil
    end

    local function unset_override()
        local list = resource.features.ragebot.hitchance.list

        for i = 1, #list do
            local weapon = list[i]
            local refs = ref_list[weapon]

            if refs == nil then
                goto continue
            end

            refs.hitchance:override()
            refs.auto_scope:override()

            ::continue::
        end

        air_strafe_ref:override()
    end

    local function update_hitchance()
        if is_bind_applied() then
            return
        end

        local me = entity.get_local_player()

        if me == nil then
            return
        end

        local weapon = me:get_player_weapon()

        if weapon == nil then
            return
        end

        local weapon_type = get_weapon_type(weapon)

        if weapon_type == nil then
            return
        end

        local refs = ref_list[weapon_type]

        if refs == nil then
            return
        end

        local items = resource.features.ragebot.hitchance[weapon_type]

        if items == nil then
            return
        end

        local hitchance = nil

        if items.in_air ~= nil then
            local value = items.in_air:get()

            if value ~= -1 and not localplayer.is_onground then
                hitchance = value
            end
        end

        if items.no_scope ~= nil then
            local threat = entity.get_threat()

            local value = items.no_scope:get()
            local distance = items.distance:get()

            if value ~= -1 and is_should_no_scope(me, threat, distance) then
                hitchance = value
                refs.auto_scope:override(false)
            end
        end

        if items.jump_scout ~= nil then
            if items.jump_scout:get() and is_should_jump_scout() then
                air_strafe_ref:override(false)
            end
        end

        if hitchance ~= nil then
            refs.hitchance:override(hitchance)
        end
    end

    local function on_shutdown()
        unset_override()
    end

    local function on_createmove()
        unset_override()
        update_hitchance()
    end

    resource.features.ragebot.hitchance.enabled:set_callback(function(item)
        local value = item:get()

        if not value then
            unset_override()
        end

        events.createmove(on_shutdown, value)
        events.createmove(on_createmove, value)
    end, true)
end

local fast_ladder do
    local MOVETYPE_LADDER = 9

    local function update_ladder_movement(e)
        local pitch = render.camera_angles().x

        if e.forwardmove > 0 then
            if pitch < 45 then
                e.view_angles.x = 89

                e.in_moveright = 1
                e.in_moveleft = 0
                e.in_forward = 0
                e.in_back = 1

                if e.sidemove == 0 then
                    e.view_angles.y = e.view_angles.y + 90
                end

                if e.sidemove < 0 then
                    e.view_angles.y = e.view_angles.y + 150
                end

                if e.sidemove > 0 then
                    e.view_angles.y = e.view_angles.y + 30
                end
            end
        end

        if e.forwardmove < 0 then
            e.view_angles.x = 89

            e.in_moveleft = 1
            e.in_moveright = 0
            e.in_forward = 1
            e.in_back = 0

            if e.sidemove == 0 then
                e.view_angles.y = e.view_angles.y + 90
            end

            if e.sidemove > 0 then
                e.view_angles.y = e.view_angles.y + 150
            end

            if e.sidemove < 0 then
                e.view_angles.y = e.view_angles.y + 30
            end
        end
    end

    local function on_createmove(e)
        local me = entity.get_local_player()

        if me == nil then
            return
        end

        local movetype = me.m_MoveType

        if movetype ~= MOVETYPE_LADDER then
            return
        end

        update_ladder_movement(e)
    end

    resource.features.movement.fast_ladder.enabled:set_callback(function(item)
        events.createmove(on_createmove, item:get())
    end, true)
end

local no_fall_damage do
    local state = false

    local MATH_TAU = math.pi * 2.0
    local STEP = MATH_TAU / 8

    local function trace_fall(player, length)
        local origin = player:get_origin()

        for i = 0, MATH_TAU, STEP do
            local sin = math.sin(i)
            local cos = math.cos(i)

            local x = origin.x + cos * 10
            local y = origin.y + sin * 10

            local start_pos = vector(x, y, origin.z)
            local end_pos = start_pos:clone()

            end_pos.z = end_pos.z - length

            local trace = utils.trace_line(start_pos, end_pos, player)

            if trace.fraction ~= 1 then
                return true
            end
        end

        return false
    end

    local function on_createmove(e)
        local me = entity.get_local_player()

        if me == nil then
            return
        end

        local velocity = me.m_vecVelocity

        if velocity.z >= -500 then
            state = false
            return
        end

        if trace_fall(me, 15) then
            state = false
        elseif trace_fall(me, 75) then
            state = true
        end

        e.in_duck = state
    end

    resource.features.movement.no_fall_damage.enabled:set_callback(function(item)
        events.createmove(on_createmove, item:get())
    end, true)
end

local presets_aa do
    presets_aa = { }

    local list = { }

    local function get_data(name, state, team)
        local data = list[name]

        if data == nil then
            return nil
        end

        data = data[team]

        if data == nil then
            return nil
        end

        return data[state]
    end

    local function import_data(data)
        if data == nil then
            return false, "Can't match valid data"
        end

        local ok, content = pcall(base64.decode, data)

        if not ok then
            return false, "Can't decode thru base64"
        end

        local ok, data = pcall(json.parse, content)

        if not ok or data == nil then
            return false, "Can't parse thru json"
        end

        return true, data
    end

    local function extract_preset(value)
        for _, team_value in pairs(value) do
            for state_key, state_value in pairs(team_value) do
                local ok, data = import_data(state_value)

                if not ok then
                    logging.error(data)
                    return nil
                end

                team_value[state_key] = data
            end
        end

        return value
    end

    local function create_preset(name)
        return function(value)
            list[name] = extract_preset(value)
        end
    end

    function presets_aa.update(ctx, name, state, team)
        local preset = list[name]

        if preset == nil then
            return false
        end

        local data = get_data(name, state, team)
            or get_data(name, "Shared", team)

        if data == nil then
            return false
        end

        ctx.pitch = data.pitch

        ctx.yaw = data.yaw
        ctx.yaw_base = data.yaw_base
        ctx.yaw_left = data.yaw_offset_left
        ctx.yaw_right = data.yaw_offset_right

        ctx.yaw_modifier = data.yaw_modifier
        ctx.modifier_offset = data.modifier_offset
        ctx.modifier_random = data.modifier_random

        ctx.body_yaw = data.body_yaw
        ctx.left_limit = data.left_limit
        ctx.right_limit = data.right_limit
        ctx.options = data.options
        ctx.delay = data.delay
        ctx.freestanding_body_yaw = data.freestanding_body_yaw

        return true
    end

    create_preset "Preset" {
        ["Terrorist"] = {
            ["Shared"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjMuMCwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NTguMCwibW9kaWZpZXJfb2Zmc2V0IjotNzIuMCwibW9kaWZpZXJfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIl0sInBpdGNoIjoiRG93biIsInJpZ2h0X2xpbWl0Ijo1OC4wLCJ0eXBlIjoiRGVmYXVsdCIsInlhdyI6IkJhY2t3YXJkIiwieWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfb2Zmc2V0X2xlZnQiOi01LjAsInlhd19vZmZzZXRfcmlnaHQiOjAuMH0=",
            ["Slow Walk"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjAuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6MTAuMCwibW9kaWZpZXJfb2Zmc2V0IjozLjAsIm1vZGlmaWVyX3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbXSwicGl0Y2giOiJEb3duIiwicmlnaHRfbGltaXQiOjEwLjAsInR5cGUiOiJEZWZhdWx0IiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfYmFzZSI6IkxvY2FsIFZpZXciLCJ5YXdfbW9kaWZpZXIiOiJPZmZzZXQiLCJ5YXdfb2Zmc2V0X2xlZnQiOjAuMCwieWF3X29mZnNldF9yaWdodCI6MC4wfQ==",
            ["Standing"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjMuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotNDIuMCwibW9kaWZpZXJfcmFuZG9tIjoyLjAsIm9wdGlvbnMiOlsiSml0dGVyIl0sInBpdGNoIjoiRG93biIsInJlY29yZCI6IiIsInJlY29yZF9pbnZlcnNlX2ludmVydGVyIjpmYWxzZSwicmlnaHRfbGltaXQiOjYwLjAsInR5cGUiOiJEZWZhdWx0IiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfYmFzZSI6IkF0IFRhcmdldCIsInlhd19tb2RpZmllciI6IkNlbnRlciIsInlhd19vZmZzZXRfbGVmdCI6LTkuMCwieWF3X29mZnNldF9yaWdodCI6MTUuMH0=",
            ["Crouching"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjAuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotMTAuMCwibW9kaWZpZXJfcmFuZG9tIjoxMS4wLCJvcHRpb25zIjpbIkppdHRlciIsIlJhbmRvbWl6ZSBKaXR0ZXIiXSwicGl0Y2giOiJEb3duIiwicmVjb3JkIjoiIiwicmVjb3JkX2ludmVyc2VfaW52ZXJ0ZXIiOmZhbHNlLCJyaWdodF9saW1pdCI6NjAuMCwidHlwZSI6IkRlZmF1bHQiLCJ5YXciOiJCYWNrd2FyZCIsInlhd19iYXNlIjoiQXQgVGFyZ2V0IiwieWF3X21vZGlmaWVyIjoiQ2VudGVyIiwieWF3X29mZnNldF9sZWZ0IjotMjQuMCwieWF3X29mZnNldF9yaWdodCI6MzAuMH0=",
            ["Crouching Move"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjAuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotMTQuMCwibW9kaWZpZXJfcmFuZG9tIjo1LjAsIm9wdGlvbnMiOlsiSml0dGVyIiwiUmFuZG9taXplIEppdHRlciJdLCJwaXRjaCI6IkRvd24iLCJyZWNvcmQiOiIiLCJyZWNvcmRfaW52ZXJzZV9pbnZlcnRlciI6ZmFsc2UsInJpZ2h0X2xpbWl0Ijo2MC4wLCJ0eXBlIjoiRGVmYXVsdCIsInlhdyI6IkJhY2t3YXJkIiwieWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfb2Zmc2V0X2xlZnQiOi0yLjAsInlhd19vZmZzZXRfcmlnaHQiOjM1LjB9",
            ["In Air"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjAuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotNTIuMCwibW9kaWZpZXJfcmFuZG9tIjoxMC4wLCJvcHRpb25zIjpbIkppdHRlciJdLCJwaXRjaCI6IkRvd24iLCJyZWNvcmQiOiIiLCJyZWNvcmRfaW52ZXJzZV9pbnZlcnRlciI6ZmFsc2UsInJpZ2h0X2xpbWl0Ijo2MC4wLCJ0eXBlIjoiRGVmYXVsdCIsInlhdyI6IkJhY2t3YXJkIiwieWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfb2Zmc2V0X2xlZnQiOjguMCwieWF3X29mZnNldF9yaWdodCI6MC4wfQ==",
            ["Air Crouch"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjAuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotMTUuMCwibW9kaWZpZXJfcmFuZG9tIjo0LjAsIm9wdGlvbnMiOlsiSml0dGVyIiwiUmFuZG9taXplIEppdHRlciJdLCJwaXRjaCI6IkRvd24iLCJyZWNvcmQiOiIiLCJyZWNvcmRfaW52ZXJzZV9pbnZlcnRlciI6ZmFsc2UsInJpZ2h0X2xpbWl0Ijo2MC4wLCJ0eXBlIjoiRGVmYXVsdCIsInlhdyI6IkJhY2t3YXJkIiwieWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfb2Zmc2V0X2xlZnQiOi0xNS4wLCJ5YXdfb2Zmc2V0X3JpZ2h0IjozNC4wfQ==",
            ["Moving"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjAuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotMTkuMCwibW9kaWZpZXJfcmFuZG9tIjo1LjAsIm9wdGlvbnMiOlsiSml0dGVyIl0sInBpdGNoIjoiRG93biIsInJlY29yZCI6IiIsInJlY29yZF9pbnZlcnNlX2ludmVydGVyIjpmYWxzZSwicmlnaHRfbGltaXQiOjYwLjAsInR5cGUiOiJEZWZhdWx0IiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfYmFzZSI6IkF0IFRhcmdldCIsInlhd19tb2RpZmllciI6IkNlbnRlciIsInlhd19vZmZzZXRfbGVmdCI6LTguMCwieWF3X29mZnNldF9yaWdodCI6MzEuMH0=",
        },

        ["Counter-Terrorist"] = {
            ["Shared"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjMuMCwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NTguMCwibW9kaWZpZXJfb2Zmc2V0IjotNzIuMCwibW9kaWZpZXJfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIl0sInBpdGNoIjoiRG93biIsInJpZ2h0X2xpbWl0Ijo1OC4wLCJ0eXBlIjoiRGVmYXVsdCIsInlhdyI6IkJhY2t3YXJkIiwieWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfb2Zmc2V0X2xlZnQiOi01LjAsInlhd19vZmZzZXRfcmlnaHQiOjAuMH0=",
            ["Slow Walk"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjYuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX3JhbmRvbSI6NS4wLCJvcHRpb25zIjpbIkppdHRlciJdLCJwaXRjaCI6IkRvd24iLCJyZWNvcmQiOiIiLCJyZWNvcmRfaW52ZXJzZV9pbnZlcnRlciI6ZmFsc2UsInJpZ2h0X2xpbWl0Ijo2MC4wLCJ0eXBlIjoiRGVmYXVsdCIsInlhdyI6IkJhY2t3YXJkIiwieWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfb2Zmc2V0X2xlZnQiOi0zNS4wLCJ5YXdfb2Zmc2V0X3JpZ2h0Ijo0Ni4wfQ==",
            ["Standing"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjMuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotNDIuMCwibW9kaWZpZXJfcmFuZG9tIjoyLjAsIm9wdGlvbnMiOlsiSml0dGVyIl0sInBpdGNoIjoiRG93biIsInJlY29yZCI6IiIsInJlY29yZF9pbnZlcnNlX2ludmVydGVyIjpmYWxzZSwicmlnaHRfbGltaXQiOjYwLjAsInR5cGUiOiJEZWZhdWx0IiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfYmFzZSI6IkF0IFRhcmdldCIsInlhd19tb2RpZmllciI6IkNlbnRlciIsInlhd19vZmZzZXRfbGVmdCI6LTkuMCwieWF3X29mZnNldF9yaWdodCI6MTUuMH0=",
            ["Crouching"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjAuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotMTAuMCwibW9kaWZpZXJfcmFuZG9tIjoxMS4wLCJvcHRpb25zIjpbIkppdHRlciIsIlJhbmRvbWl6ZSBKaXR0ZXIiXSwicGl0Y2giOiJEb3duIiwicmVjb3JkIjoiIiwicmVjb3JkX2ludmVyc2VfaW52ZXJ0ZXIiOmZhbHNlLCJyaWdodF9saW1pdCI6NjAuMCwidHlwZSI6IkRlZmF1bHQiLCJ5YXciOiJCYWNrd2FyZCIsInlhd19iYXNlIjoiQXQgVGFyZ2V0IiwieWF3X21vZGlmaWVyIjoiQ2VudGVyIiwieWF3X29mZnNldF9sZWZ0IjotMjQuMCwieWF3X29mZnNldF9yaWdodCI6MzAuMH0=",
            ["Crouching Move"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjAuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotNy4wLCJtb2RpZmllcl9yYW5kb20iOjUuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJSYW5kb21pemUgSml0dGVyIl0sInBpdGNoIjoiRG93biIsInJlY29yZCI6IltbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXV0iLCJyZWNvcmRfaW52ZXJzZV9pbnZlcnRlciI6ZmFsc2UsInJpZ2h0X2xpbWl0Ijo2MC4wLCJ0eXBlIjoiRGVmYXVsdCIsInlhdyI6IkJhY2t3YXJkIiwieWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfb2Zmc2V0X2xlZnQiOi0xNS4wLCJ5YXdfb2Zmc2V0X3JpZ2h0IjozMi4wfQ==",
            ["In Air"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjAuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotNTIuMCwibW9kaWZpZXJfcmFuZG9tIjoxMC4wLCJvcHRpb25zIjpbIkppdHRlciJdLCJwaXRjaCI6IkRvd24iLCJyZWNvcmQiOiJbW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdXSIsInJlY29yZF9pbnZlcnNlX2ludmVydGVyIjpmYWxzZSwicmlnaHRfbGltaXQiOjYwLjAsInR5cGUiOiJEZWZhdWx0IiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfYmFzZSI6IkF0IFRhcmdldCIsInlhd19tb2RpZmllciI6IkNlbnRlciIsInlhd19vZmZzZXRfbGVmdCI6OC4wLCJ5YXdfb2Zmc2V0X3JpZ2h0IjowLjB9",
            ["Air Crouch"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjAuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotMTUuMCwibW9kaWZpZXJfcmFuZG9tIjo0LjAsIm9wdGlvbnMiOlsiSml0dGVyIiwiUmFuZG9taXplIEppdHRlciJdLCJwaXRjaCI6IkRvd24iLCJyZWNvcmQiOiJbW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwtMS4wLHRydWUsdHJ1ZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCx0cnVlLGZhbHNlLFwiT2Zmc2V0XCIsMS4wLHRydWUsdHJ1ZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCx0cnVlLGZhbHNlLFwiT2Zmc2V0XCIsMS4wLHRydWUsdHJ1ZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCx0cnVlLGZhbHNlLFwiT2Zmc2V0XCIsNS4wLHRydWUsZmFsc2UsNTcuMCw1Ny4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCx0cnVlLGZhbHNlLFwiT2Zmc2V0XCIsNS4wLHRydWUsZmFsc2UsNTcuMCw1Ny4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCx0cnVlLGZhbHNlLFwiT2Zmc2V0XCIsMC4wLHRydWUsZmFsc2UsNTcuMCw1Ny4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCx0cnVlLGZhbHNlLFwiT2Zmc2V0XCIsMC4wLHRydWUsZmFsc2UsNTcuMCw1Ny4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCx0cnVlLGZhbHNlLFwiT2Zmc2V0XCIsMi4wLHRydWUsdHJ1ZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCx0cnVlLGZhbHNlLFwiT2Zmc2V0XCIsMC4wLHRydWUsdHJ1ZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCx0cnVlLGZhbHNlLFwiT2Zmc2V0XCIsLTEuMCx0cnVlLHRydWUsNTcuMCw1Ny4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLC0xLjAsdHJ1ZSx0cnVlLDU3LjAsNTcuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwtMS4wLHRydWUsZmFsc2UsNTcuMCw1Ny4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCx0cnVlLGZhbHNlLFwiT2Zmc2V0XCIsMy4wLHRydWUsZmFsc2UsNTcuMCw1Ny4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCx0cnVlLGZhbHNlLFwiT2Zmc2V0XCIsNS4wLHRydWUsZmFsc2UsNTcuMCw1Ny4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCx0cnVlLGZhbHNlLFwiT2Zmc2V0XCIsMC4wLHRydWUsZmFsc2UsNTcuMCw1Ny4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCx0cnVlLGZhbHNlLFwiT2Zmc2V0XCIsMC4wLHRydWUsdHJ1ZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdXSIsInJlY29yZF9pbnZlcnNlX2ludmVydGVyIjpmYWxzZSwicmlnaHRfbGltaXQiOjYwLjAsInR5cGUiOiJEZWZhdWx0IiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfYmFzZSI6IkF0IFRhcmdldCIsInlhd19tb2RpZmllciI6IkNlbnRlciIsInlhd19vZmZzZXRfbGVmdCI6LTE1LjAsInlhd19vZmZzZXRfcmlnaHQiOjM0LjB9",
            ["Moving"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjAuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotMTkuMCwibW9kaWZpZXJfcmFuZG9tIjo1LjAsIm9wdGlvbnMiOlsiSml0dGVyIl0sInBpdGNoIjoiRG93biIsInJlY29yZCI6IiIsInJlY29yZF9pbnZlcnNlX2ludmVydGVyIjpmYWxzZSwicmlnaHRfbGltaXQiOjYwLjAsInR5cGUiOiJEZWZhdWx0IiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfYmFzZSI6IkF0IFRhcmdldCIsInlhd19tb2RpZmllciI6IkNlbnRlciIsInlhd19vZmZzZXRfbGVmdCI6LTguMCwieWF3X29mZnNldF9yaWdodCI6MzEuMH0=",

        }

    }

    create_preset "Meta" {
        ["Terrorist"] = {
            ["Shared"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjMuMCwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NTguMCwibW9kaWZpZXJfb2Zmc2V0IjotNzIuMCwibW9kaWZpZXJfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIl0sInBpdGNoIjoiRG93biIsInJpZ2h0X2xpbWl0Ijo1OC4wLCJ0eXBlIjoiRGVmYXVsdCIsInlhdyI6IkJhY2t3YXJkIiwieWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfb2Zmc2V0X2xlZnQiOi01LjAsInlhd19vZmZzZXRfcmlnaHQiOjAuMH0=",
            ["Slow Walk"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjE2LjAsImVuYWJsZWQiOnRydWUsImZyZWVzdGFuZGluZ19ib2R5X3lhdyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsIm1vZGlmaWVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9yYW5kb20iOjUuMCwib3B0aW9ucyI6WyJKaXR0ZXIiXSwicGl0Y2giOiJEb3duIiwicmVjb3JkIjoiIiwicmVjb3JkX2ludmVyc2VfaW52ZXJ0ZXIiOmZhbHNlLCJyaWdodF9saW1pdCI6NjAuMCwidHlwZSI6IkRlZmF1bHQiLCJ5YXciOiJCYWNrd2FyZCIsInlhd19iYXNlIjoiQXQgVGFyZ2V0IiwieWF3X21vZGlmaWVyIjoiQ2VudGVyIiwieWF3X29mZnNldF9sZWZ0IjotMzUuMCwieWF3X29mZnNldF9yaWdodCI6NDYuMH0=",
            ["Standing"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjMuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotNDIuMCwibW9kaWZpZXJfcmFuZG9tIjoyLjAsIm9wdGlvbnMiOlsiSml0dGVyIl0sInBpdGNoIjoiRG93biIsInJlY29yZCI6IiIsInJlY29yZF9pbnZlcnNlX2ludmVydGVyIjpmYWxzZSwicmlnaHRfbGltaXQiOjYwLjAsInR5cGUiOiJEZWZhdWx0IiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfYmFzZSI6IkF0IFRhcmdldCIsInlhd19tb2RpZmllciI6IkNlbnRlciIsInlhd19vZmZzZXRfbGVmdCI6LTkuMCwieWF3X29mZnNldF9yaWdodCI6MTUuMH0=",
            ["Crouching"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjkuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotOC4wLCJtb2RpZmllcl9yYW5kb20iOjUuMCwib3B0aW9ucyI6WyJKaXR0ZXIiXSwicGl0Y2giOiJEb3duIiwicmVjb3JkIjoiIiwicmVjb3JkX2ludmVyc2VfaW52ZXJ0ZXIiOmZhbHNlLCJyaWdodF9saW1pdCI6NjAuMCwidHlwZSI6IkRlZmF1bHQiLCJ5YXciOiJCYWNrd2FyZCIsInlhd19iYXNlIjoiQXQgVGFyZ2V0IiwieWF3X21vZGlmaWVyIjoiMy1XYXkiLCJ5YXdfb2Zmc2V0X2xlZnQiOi0yOC4wLCJ5YXdfb2Zmc2V0X3JpZ2h0IjozMC4wfQ==",
            ["Crouching Move"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjAuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotMTQuMCwibW9kaWZpZXJfcmFuZG9tIjo1LjAsIm9wdGlvbnMiOlsiSml0dGVyIiwiUmFuZG9taXplIEppdHRlciJdLCJwaXRjaCI6IkRvd24iLCJyZWNvcmQiOiIiLCJyZWNvcmRfaW52ZXJzZV9pbnZlcnRlciI6ZmFsc2UsInJpZ2h0X2xpbWl0Ijo2MC4wLCJ0eXBlIjoiRGVmYXVsdCIsInlhdyI6IkJhY2t3YXJkIiwieWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfb2Zmc2V0X2xlZnQiOi0yLjAsInlhd19vZmZzZXRfcmlnaHQiOjM1LjB9",
            ["In Air"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjAuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotNTIuMCwibW9kaWZpZXJfcmFuZG9tIjoxMC4wLCJvcHRpb25zIjpbIkF2b2lkIE92ZXJsYXAiLCJKaXR0ZXIiXSwicGl0Y2giOiJEb3duIiwicmVjb3JkIjoiW1tcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXV0iLCJyZWNvcmRfaW52ZXJzZV9pbnZlcnRlciI6ZmFsc2UsInJpZ2h0X2xpbWl0Ijo2MC4wLCJ0eXBlIjoiRGVmYXVsdCIsInlhdyI6IkJhY2t3YXJkIiwieWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJ5YXdfbW9kaWZpZXIiOiJEaXNhYmxlZCIsInlhd19vZmZzZXRfbGVmdCI6OC4wLCJ5YXdfb2Zmc2V0X3JpZ2h0IjotMy4wfQ==",
            ["Air Crouch"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjAuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NTkuMCwibW9kaWZpZXJfb2Zmc2V0IjotOC4wLCJtb2RpZmllcl9yYW5kb20iOjEzLjAsIm9wdGlvbnMiOlsiSml0dGVyIl0sInBpdGNoIjoiRG93biIsInJlY29yZCI6IltbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLC0xLjAsdHJ1ZSx0cnVlLDU3LjAsNTcuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwxLjAsdHJ1ZSx0cnVlLDU3LjAsNTcuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwxLjAsdHJ1ZSx0cnVlLDU3LjAsNTcuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiw1LjAsdHJ1ZSxmYWxzZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiw1LjAsdHJ1ZSxmYWxzZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwwLjAsdHJ1ZSxmYWxzZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwwLjAsdHJ1ZSxmYWxzZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwyLjAsdHJ1ZSx0cnVlLDU3LjAsNTcuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwwLjAsdHJ1ZSx0cnVlLDU3LjAsNTcuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwtMS4wLHRydWUsdHJ1ZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCx0cnVlLGZhbHNlLFwiT2Zmc2V0XCIsLTEuMCx0cnVlLHRydWUsNTcuMCw1Ny4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLC0xLjAsdHJ1ZSxmYWxzZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwzLjAsdHJ1ZSxmYWxzZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiw1LjAsdHJ1ZSxmYWxzZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwwLjAsdHJ1ZSxmYWxzZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwwLjAsdHJ1ZSx0cnVlLDU3LjAsNTcuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl1dIiwicmVjb3JkX2ludmVyc2VfaW52ZXJ0ZXIiOmZhbHNlLCJyaWdodF9saW1pdCI6NTkuMCwidHlwZSI6IkRlZmF1bHQiLCJ5YXciOiJCYWNrd2FyZCIsInlhd19iYXNlIjoiQXQgVGFyZ2V0IiwieWF3X21vZGlmaWVyIjoiT2Zmc2V0IiwieWF3X29mZnNldF9sZWZ0IjotMTEuMCwieWF3X29mZnNldF9yaWdodCI6MjEuMH0=",
            ["Moving"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjAuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotMTkuMCwibW9kaWZpZXJfcmFuZG9tIjo1LjAsIm9wdGlvbnMiOlsiSml0dGVyIl0sInBpdGNoIjoiRG93biIsInJlY29yZCI6IiIsInJlY29yZF9pbnZlcnNlX2ludmVydGVyIjpmYWxzZSwicmlnaHRfbGltaXQiOjYwLjAsInR5cGUiOiJEZWZhdWx0IiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfYmFzZSI6IkF0IFRhcmdldCIsInlhd19tb2RpZmllciI6IkNlbnRlciIsInlhd19vZmZzZXRfbGVmdCI6LTguMCwieWF3X29mZnNldF9yaWdodCI6MzEuMH0=",

        },

        ["Counter-Terrorist"] = {
            ["Shared"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjMuMCwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NTguMCwibW9kaWZpZXJfb2Zmc2V0IjotNzIuMCwibW9kaWZpZXJfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIl0sInBpdGNoIjoiRG93biIsInJpZ2h0X2xpbWl0Ijo1OC4wLCJ0eXBlIjoiRGVmYXVsdCIsInlhdyI6IkJhY2t3YXJkIiwieWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJ5YXdfbW9kaWZpZXIiOiJDZW50ZXIiLCJ5YXdfb2Zmc2V0X2xlZnQiOi01LjAsInlhd19vZmZzZXRfcmlnaHQiOjAuMH0=",
            ["Slow Walk"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjE2LjAsImVuYWJsZWQiOnRydWUsImZyZWVzdGFuZGluZ19ib2R5X3lhdyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsIm1vZGlmaWVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9yYW5kb20iOjUuMCwib3B0aW9ucyI6WyJKaXR0ZXIiXSwicGl0Y2giOiJEb3duIiwicmVjb3JkIjoiIiwicmVjb3JkX2ludmVyc2VfaW52ZXJ0ZXIiOmZhbHNlLCJyaWdodF9saW1pdCI6NjAuMCwidHlwZSI6IkRlZmF1bHQiLCJ5YXciOiJCYWNrd2FyZCIsInlhd19iYXNlIjoiQXQgVGFyZ2V0IiwieWF3X21vZGlmaWVyIjoiQ2VudGVyIiwieWF3X29mZnNldF9sZWZ0IjotMzUuMCwieWF3X29mZnNldF9yaWdodCI6NDYuMH0=",
            ["Standing"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjAuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotNDIuMCwibW9kaWZpZXJfcmFuZG9tIjozLjAsIm9wdGlvbnMiOlsiSml0dGVyIl0sInBpdGNoIjoiRG93biIsInJlY29yZCI6IiIsInJlY29yZF9pbnZlcnNlX2ludmVydGVyIjpmYWxzZSwicmlnaHRfbGltaXQiOjYwLjAsInR5cGUiOiJEZWZhdWx0IiwieWF3IjoiQmFja3dhcmQiLCJ5YXdfYmFzZSI6IkF0IFRhcmdldCIsInlhd19tb2RpZmllciI6IkNlbnRlciIsInlhd19vZmZzZXRfbGVmdCI6LTkuMCwieWF3X29mZnNldF9yaWdodCI6MTUuMH0=",
            ["Crouching"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjkuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotOC4wLCJtb2RpZmllcl9yYW5kb20iOjUuMCwib3B0aW9ucyI6WyJKaXR0ZXIiXSwicGl0Y2giOiJEb3duIiwicmVjb3JkIjoiIiwicmVjb3JkX2ludmVyc2VfaW52ZXJ0ZXIiOmZhbHNlLCJyaWdodF9saW1pdCI6NjAuMCwidHlwZSI6IkRlZmF1bHQiLCJ5YXciOiJCYWNrd2FyZCIsInlhd19iYXNlIjoiQXQgVGFyZ2V0IiwieWF3X21vZGlmaWVyIjoiMy1XYXkiLCJ5YXdfb2Zmc2V0X2xlZnQiOi0yOC4wLCJ5YXdfb2Zmc2V0X3JpZ2h0IjozMC4wfQ==",
            ["Crouching Move"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjUuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjoxMC4wLCJtb2RpZmllcl9yYW5kb20iOjE2LjAsIm9wdGlvbnMiOlsiSml0dGVyIl0sInBpdGNoIjoiRG93biIsInJlY29yZCI6IltbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDMuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDQuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDIuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDEuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDUuMCx0cnVlLGZhbHNlLDU2LjAsNTYuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDM1LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLDcuMCx0cnVlLHRydWUsNTYuMCw1Ni4wLFtcIkppdHRlclwiXSxcIk9mZlwiXV0iLCJyZWNvcmRfaW52ZXJzZV9pbnZlcnRlciI6ZmFsc2UsInJpZ2h0X2xpbWl0Ijo2MC4wLCJ0eXBlIjoiRGVmYXVsdCIsInlhdyI6IkJhY2t3YXJkIiwieWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJ5YXdfbW9kaWZpZXIiOiIzLVdheSIsInlhd19vZmZzZXRfbGVmdCI6LTIwLjAsInlhd19vZmZzZXRfcmlnaHQiOjM5LjB9",
            ["In Air"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjAuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibW9kaWZpZXJfb2Zmc2V0IjotNTIuMCwibW9kaWZpZXJfcmFuZG9tIjoxMC4wLCJvcHRpb25zIjpbIkF2b2lkIE92ZXJsYXAiLCJKaXR0ZXIiXSwicGl0Y2giOiJEb3duIiwicmVjb3JkIjoiW1tcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLHRydWUsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMjUuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsdHJ1ZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0yNS4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTI1LjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSxmYWxzZSw2MC4wLDYwLjAsW10sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLDQwLjAsZmFsc2UsZmFsc2UsXCJEaXNhYmxlZFwiLDAuMCx0cnVlLGZhbHNlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsNDAuMCxmYWxzZSxmYWxzZSxcIkRpc2FibGVkXCIsMC4wLHRydWUsZmFsc2UsNjAuMCw2MC4wLFtdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLGZhbHNlLGZhbHNlLFwiRGlzYWJsZWRcIiwwLjAsdHJ1ZSx0cnVlLDYwLjAsNjAuMCxbXSxcIk9mZlwiXV0iLCJyZWNvcmRfaW52ZXJzZV9pbnZlcnRlciI6ZmFsc2UsInJpZ2h0X2xpbWl0Ijo2MC4wLCJ0eXBlIjoiRGVmYXVsdCIsInlhdyI6IkJhY2t3YXJkIiwieWF3X2Jhc2UiOiJBdCBUYXJnZXQiLCJ5YXdfbW9kaWZpZXIiOiJEaXNhYmxlZCIsInlhd19vZmZzZXRfbGVmdCI6OC4wLCJ5YXdfb2Zmc2V0X3JpZ2h0IjotMy4wfQ==",
            ["Air Crouch"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjAuMCwiZW5hYmxlZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2JvZHlfeWF3IjoiT2ZmIiwibGVmdF9saW1pdCI6NTkuMCwibW9kaWZpZXJfb2Zmc2V0IjotOC4wLCJtb2RpZmllcl9yYW5kb20iOjEzLjAsIm9wdGlvbnMiOlsiSml0dGVyIl0sInBpdGNoIjoiRG93biIsInJlY29yZCI6IltbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLC0xLjAsdHJ1ZSx0cnVlLDU3LjAsNTcuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwxLjAsdHJ1ZSx0cnVlLDU3LjAsNTcuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwxLjAsdHJ1ZSx0cnVlLDU3LjAsNTcuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiw1LjAsdHJ1ZSxmYWxzZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiw1LjAsdHJ1ZSxmYWxzZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwwLjAsdHJ1ZSxmYWxzZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwwLjAsdHJ1ZSxmYWxzZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwyLjAsdHJ1ZSx0cnVlLDU3LjAsNTcuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwwLjAsdHJ1ZSx0cnVlLDU3LjAsNTcuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl0sW1wiRG93blwiLFwiQmFja3dhcmRcIixcIkF0IFRhcmdldFwiLC0xOS4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwtMS4wLHRydWUsdHJ1ZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiwtMTkuMCx0cnVlLGZhbHNlLFwiT2Zmc2V0XCIsLTEuMCx0cnVlLHRydWUsNTcuMCw1Ny4wLFtcIkppdHRlclwiXSxcIk9mZlwiXSxbXCJEb3duXCIsXCJCYWNrd2FyZFwiLFwiQXQgVGFyZ2V0XCIsLTE5LjAsdHJ1ZSxmYWxzZSxcIk9mZnNldFwiLC0xLjAsdHJ1ZSxmYWxzZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwzLjAsdHJ1ZSxmYWxzZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiw1LjAsdHJ1ZSxmYWxzZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwwLjAsdHJ1ZSxmYWxzZSw1Ny4wLDU3LjAsW1wiSml0dGVyXCJdLFwiT2ZmXCJdLFtcIkRvd25cIixcIkJhY2t3YXJkXCIsXCJBdCBUYXJnZXRcIiw0MC4wLHRydWUsZmFsc2UsXCJPZmZzZXRcIiwwLjAsdHJ1ZSx0cnVlLDU3LjAsNTcuMCxbXCJKaXR0ZXJcIl0sXCJPZmZcIl1dIiwicmVjb3JkX2ludmVyc2VfaW52ZXJ0ZXIiOmZhbHNlLCJyaWdodF9saW1pdCI6NTkuMCwidHlwZSI6IkRlZmF1bHQiLCJ5YXciOiJCYWNrd2FyZCIsInlhd19iYXNlIjoiQXQgVGFyZ2V0IiwieWF3X21vZGlmaWVyIjoiT2Zmc2V0IiwieWF3X29mZnNldF9sZWZ0IjotMTEuMCwieWF3X29mZnNldF9yaWdodCI6MjEuMH0=",
            ["Moving"] = "eyJib2R5X3lhdyI6dHJ1ZSwiZGVsYXkiOjEwLjAsImVuYWJsZWQiOnRydWUsImZyZWVzdGFuZGluZ19ib2R5X3lhdyI6IlBlZWsgUmVhbCIsImxlZnRfbGltaXQiOjYwLjAsIm1vZGlmaWVyX29mZnNldCI6LTIyLjAsIm1vZGlmaWVyX3JhbmRvbSI6OS4wLCJvcHRpb25zIjpbIkF2b2lkIE92ZXJsYXAiLCJKaXR0ZXIiLCJBbnRpIEJydXRlZm9yY2UiXSwicGl0Y2giOiJEb3duIiwicmVjb3JkIjoiIiwicmVjb3JkX2ludmVyc2VfaW52ZXJ0ZXIiOmZhbHNlLCJyaWdodF9saW1pdCI6NjAuMCwidHlwZSI6IkRlZmF1bHQiLCJ5YXciOiJCYWNrd2FyZCIsInlhd19iYXNlIjoiQXQgVGFyZ2V0IiwieWF3X21vZGlmaWVyIjoiRGlzYWJsZWQiLCJ5YXdfb2Zmc2V0X2xlZnQiOi0zLjAsInlhd19vZmZzZXRfcmlnaHQiOi0zLjB9",

        }

    }
end




local recorder do
    recorder = { }

    local KEY = "BqvbCHsU5NwhxAzGKjFgytIT0oXlurekOdS8ZiPVaEnR7219Q6mM3DfLW4YpcJ+/="

    local cached = { }
    local running_tick = 0

    local record_data = nil
    local is_importing = false

    local render_state = false

    local start_seq = 1
    local end_seq = 1

    local function transform(data)
        local ok, result = pcall(json.parse, data)

        if not ok then
            return false, "Can't parse data"
        end

        return true, result
    end

    local function import_data(str)
        local ok, result = pcall(base64.decode, str, KEY)

        if not ok then
            return false, "Can't decode data"
        end

        return true, result
    end

    local function convert_value(value)
        if type(value) == "table" then
            value = "[ " .. table.concat(value, ", ") .. " ]"
        end

        return value
    end

    local function add_value_to_draw(draw_list, key, value)
        local text = string.format("%s: \a{Link Active}%s\aDEFAULT", key, convert_value(value))
        local measure = render.measure_text(1, "", text)

        local value = {
            text = text,
            measure = measure
        }

        table.insert(draw_list, value)
        return value
    end

    local function get_current_items()
        local condition = resource.antiaim.angles.condition:get()
        local items = resource.antiaim.angles[condition]

        if items == nil then
            return nil
        end

        return items[items.team:get()]
    end

    local function get_sequence_char(tick)
        if tick == start_seq and tick == end_seq then
            return icons.get "arrow-right" .. ZWSP:rep(3)
        end

        if tick == start_seq then
            return icons.get "arrow-down" .. ZWSP:rep(4)
        end

        if tick == end_seq then
            return icons.get "arrow-up" .. ZWSP:rep(4)
        end

        if tick > start_seq and tick < end_seq then
            return ZWSP:rep(2) .. icons.get "pipe" .. ZWSP:rep(6)
        end

        return ZWSP:rep(9)
    end

    local function get_record(state, item)
        local value = item:get()

        if value == "" then
            return nil
        end

        local cache = cached[state]

        if cache == nil or cache[1] ~= value then
            local ok, data = transform(value)

            if not ok then
                return nil
            end

            cached[state] = { value, data }
        end

        return cached[state]
    end

    local function get_sequence_list()
        if record_data == nil then
            return { }
        end

        local list = { }

        for i = 1, #record_data do
            local data = record_data[i]

            local text = merge(
                get_sequence_char(i),
                "\a{Link Active}", i, "\aDEFAULT", ":", "\x20",
                "Yaw: ", "\a{Link Active}", data[4], "\aDEFAULT", "\x20",
                "Modifier: ", "\a{Link Active}", data[8], "\aDEFAULT"
            )

            list[i] = text
        end

        return list
    end

    local function set_record(data)
        local items = get_current_items()

        if items == nil then
            return nil
        end

        local ok, content = pcall(json.stringify, data)

        if not ok then
            return nil
        end

        items.record:set(content)
    end

    local function update_sequence_list()
        resource.antiaim.angles.sequence_list:update(
            get_sequence_list()
        )
    end

    local function update_record_items()
        resource.antiaim.angles.sequence_list:visibility(is_importing)
        resource.antiaim.angles.save_sequence:visibility(is_importing)

        resource.antiaim.angles.set_start:visibility(is_importing)
        resource.antiaim.angles.set_end:visibility(is_importing)

        resource.antiaim.angles.import_record:visibility(not is_importing)
        resource.antiaim.angles.link_to_recorder:visibility(not is_importing)
    end

    local function update_record_antiaim(ctx, data, inverse_inverter)
        local new_options = { } do
            local options = data[13]

            for i = 1, #options do
                local option = options[i]

                if option ~= "Jitter" and option ~= "Randomize Jitter" then
                    table.insert(new_options, option)
                end
            end
        end

        local inverter = data[10]

        if inverse_inverter then
            inverter = not inverter
        end

        ctx.pitch = data[1]

        ctx.yaw = data[2]
        ctx.yaw_base = data[3]
        ctx.yaw_add = data[4]
        ctx.hidden = data[6]

        ctx.yaw_modifier = data[7]
        ctx.modifier_offset = data[8]

        ctx.body_yaw = data[9]
        ctx.inverter = inverter
        ctx.left_limit = data[11]
        ctx.right_limit = data[12]
        ctx.options = new_options
        ctx.freestanding_body_yaw = data[14]

        if not ctx.ignore_inverter then
            rage.antiaim:inverter(inverter)
        end
    end

    local function on_render()
        if not is_importing or record_data == nil then
            return
        end

        local index = resource.antiaim.angles.sequence_list:get()
        local data = record_data[index]

        if data == nil then
            return
        end

        local alpha = ui.get_alpha()
        local screen = render.screen_size()

        local max_height = 0
        local position = vector(15, screen.y * 0.5)

        local col = color(255, 255, 255, 200 * alpha)

        local draw_list = { } do
            max_height = max_height + add_value_to_draw(draw_list, "Pitch", data[1]).measure.y

            max_height = max_height + add_value_to_draw(draw_list, "Yaw", data[2]).measure.y
            max_height = max_height + add_value_to_draw(draw_list, "Yaw - Base", data[3]).measure.y
            max_height = max_height + add_value_to_draw(draw_list, "Yaw - Offset", data[4]).measure.y
            max_height = max_height + add_value_to_draw(draw_list, "Yaw - Avoid Backstab", data[5]).measure.y
            max_height = max_height + add_value_to_draw(draw_list, "Yaw - Hidden", data[6]).measure.y

            max_height = max_height + add_value_to_draw(draw_list, "Yaw Modifier", data[7]).measure.y
            max_height = max_height + add_value_to_draw(draw_list, "Yaw Modifier - Offset", data[8]).measure.y

            max_height = max_height + add_value_to_draw(draw_list, "Body Yaw", data[9]).measure.y
            max_height = max_height + add_value_to_draw(draw_list, "Body Yaw - Inverter", data[10]).measure.y
            max_height = max_height + add_value_to_draw(draw_list, "Body Yaw - Left Limit", data[11]).measure.y
            max_height = max_height + add_value_to_draw(draw_list, "Body Yaw - Right Limit", data[12]).measure.y
            max_height = max_height + add_value_to_draw(draw_list, "Body Yaw - Options", data[13]).measure.y
            max_height = max_height + add_value_to_draw(draw_list, "Body Yaw - Freestanding", data[14]).measure.y
        end

        position.y = position.y - max_height * 0.5

        for i = 1, #draw_list do
            local info = draw_list[i]

            local text = info.text
            local measure = info.measure

            render.text(1, position, col, "", text)
            position.y = position.y + measure.y
        end
    end

    function recorder.set_render_state(value)
        if value == render_state then
            return
        end

        render_state = value
        events.render(on_render, value)
    end

    function recorder.update(ctx, items, state)
        local inverse_inverter = false

        if items.record_inverse_inverter ~= nil then
            inverse_inverter = items.record_inverse_inverter:get()
        end

        if is_importing and record_data ~= nil then
            local index = resource.antiaim.angles.sequence_list:get()
            local data = record_data[index]

            if data ~= nil then
                update_record_antiaim(ctx, data, inverse_inverter)
            end

            return
        end

        local record = get_record(state, items.record)

        if record == nil then
            return
        end

        local arr = record[2]

        if arr == nil then
            return
        end

        if globals.choked_commands == 0 then
            if running_tick >= #arr then
                running_tick = 0
            end

            running_tick = running_tick + 1
        end

        local data = arr[running_tick]

        if data == nil then
            return
        end

        update_record_antiaim(ctx, data, inverse_inverter)
    end

    resource.antiaim.angles.import_record:set_callback(function()
        local ok, content = import_data(clipboard.get())

        if not ok then
            logging.error(content)
            return
        end

        local ok, data = transform(content)

        if not ok then
            logging.error(data)
            return
        end

        record_data = data
        is_importing = true

        start_seq = 1
        end_seq = #data

        update_sequence_list()
        update_record_items()
    end)

    resource.antiaim.angles.save_sequence:set_callback(function()
        if record_data == nil then
            return
        end

        local list = { }

        for i = start_seq, end_seq do
            table.insert(list, record_data[i])
        end

        set_record(list)

        record_data = nil
        is_importing = false

        update_record_items()
    end)

    resource.antiaim.angles.set_start:set_callback(function()
        local value = resource.antiaim.angles.sequence_list:get()

        if value > end_seq then
            end_seq = #record_data
        end

        start_seq = value
        update_sequence_list()
    end)

    resource.antiaim.angles.set_end:set_callback(function()
        local value = resource.antiaim.angles.sequence_list:get()

        if value < start_seq then
            start_seq = 1
        end

        end_seq = value
        update_sequence_list()
    end)

    update_record_items()
end

local builder do
    builder = { }

    local function get_items(state, team)
        local items = resource.antiaim.angles[state]

        if items == nil then
            return nil
        end

        return items[team]
    end

    function builder.get_items(state, team)
        return get_items(state, team)
    end

    function builder.get_team(team)
        if team == 2 then
            return "Terrorist"
        end

        if team == 3 then
            return "Counter-Terrorist"
        end

        return nil
    end

    function builder.update(ctx, state, team_num)
        recorder.set_render_state(false)

        if not resource.antiaim.angles.enabled:get() then
            return false
        end

        local team = builder.get_team(team_num)

        if team == nil then
            return
        end

        local items = get_items(state, team)

        if items == nil then
            return false
        end

        if not items.enabled:get() then
            items = get_items("Shared", team)

            if items == nil then
                return false
            end
        end

        local typeof = items.type:get()

        if presets_aa.update(ctx, typeof, state, team) then
            return true
        end

        if typeof == "Records" then
            recorder.update(ctx, items, state)
            recorder.set_render_state(true)

            return true
        end

        ctx.pitch = items.pitch:get()

        ctx.yaw = items.yaw:get()
        ctx.yaw_base = items.yaw_base:get()
        ctx.yaw_left = items.yaw_offset_left:get()
        ctx.yaw_right = items.yaw_offset_right:get()

        ctx.yaw_modifier = items.yaw_modifier:get()
        ctx.modifier_offset = items.modifier_offset:get()

        ctx.modifier_offset = ctx.modifier_offset + utils.random_int(
            -items.modifier_random:get(), items.modifier_random:get()
        )

        ctx.body_yaw = items.body_yaw:get()
        ctx.left_limit = items.left_limit:get()
        ctx.right_limit = items.right_limit:get()
        ctx.options = items.options:get()
        ctx.delay = items.delay:get()
        ctx.freestanding_body_yaw = items.freestanding_body_yaw:get()

        return true
    end
end

local defensive do
    defensive = { }

    local function should_update(manual_yaw)
        if not resource.antiaim.defensive.enabled:get() then
            return false
        end

        local is_freestanding_disabler = resource.antiaim.freestanding.enabled:get()
            and resource.antiaim.defensive.disablers:get("Freestanding")

        if is_freestanding_disabler then
            return false
        end

        local is_manual_yaw_disabler = manual_yaw ~= nil
            and resource.antiaim.defensive.disablers:get("Manuals")

        if is_manual_yaw_disabler then
            return false
        end

        return true
    end

    local function get_items(state)
        return resource.antiaim.defensive[state]
    end

    local function get_pitch(ctx, items)
        local value = items.pitch:get()

        if value == "Static" then
            return items.pitch_offset:get()
        end

        if value == "Switch" then
            return bit.band(localplayer.sent_packets, 1) ~= 0
                and items.pitch_offset_1:get()
                or items.pitch_offset_2:get()
        end

        if value == "Random" then
            return utils.random_int(
                items.pitch_offset_1:get(),
                items.pitch_offset_2:get()
            )
        end

        return 0
    end

    local function get_yaw(ctx, items)
        local side = ctx:get_inverter()

        local value = items.yaw:get()
        local offset = items.yaw_offset:get()

        if value == "Side Based" then
            return side and -90 or 90
        end

        if value == "Opposite" then
            return -180
        end

        if value == "Spin" then
            return globals.curtime * (offset * 12) % 360
        end

        if value == "Random" then
            return utils.random_int(-offset, offset)
        end

        if value == "3-Way" then
            local pattern = { -1.0, 0.0, 1.0 }
            local index = localplayer.sent_packets % #pattern

            return pattern[index + 1] * offset
        end

        if value == "5-Way" then
            local pattern = { -1.0, -0.5, 0.0, 0.5, 1.0 }
            local index = localplayer.sent_packets % #pattern

            return pattern[index + 1] * offset
        end

        return 0
    end

    local function update_by_safe_head(ctx)
        local offset = ctx.yaw_add or 0

        rage.antiaim:override_hidden_pitch(0)
        rage.antiaim:override_hidden_yaw_offset(-180 + offset)

        ctx.hidden = true
    end

    local function update_by_items(ctx, items)
        local pitch = get_pitch(ctx, items)
        local yaw = get_yaw(ctx, items)

        rage.antiaim:override_hidden_pitch(pitch)
        rage.antiaim:override_hidden_yaw_offset(yaw)

        ctx.hidden = true
    end

    function defensive.update(ctx, state, manual_yaw, is_safe_head)
        if not should_update(manual_yaw) then
            return false
        end

        local items = get_items(state)

        if items == nil or not items.enabled:get() then
            return false
        end

        if is_safe_head then
            if items.e_spam_while_safe_head ~= nil and items.e_spam_while_safe_head:get() then
                update_by_safe_head(ctx)
                return true
            end

            return false
        end

        update_by_items(ctx, items)
        return true
    end
end

local safe_head do
    safe_head = { }

    local function should_update()
        return resource.antiaim.safe_head.enabled:get()
    end

    local function get_condition(me, threat)
        local weapon = me:get_player_weapon()

        if weapon == nil then
            return nil
        end

        local weapon_info = weapon:get_weapon_info()

        if weapon_info == nil then
            return nil
        end

        local weapon_name = weapon_info.weapon_name
        local weapon_index = weapon:get_weapon_index()

        -- fun fact: taser is also a knife type of weapon
        local is_knife = weapon_name == "weapon_knife"
        local is_taser = weapon_index == 31

        local my_origin = me:get_origin()
        local threat_origin = threat:get_origin()

        local delta = threat_origin - my_origin

        local height = -delta.z
        local distancesqr = delta:length2dsqr()

        if localplayer.is_onground then
            local is_distance_state = not localplayer.is_moving
                or localplayer.is_crouched

            if is_distance_state and height >= 10 and distancesqr > 1000 * 1000 then
                return "Distance"
            end

            if localplayer.is_crouched then
                if height >= 48 then
                    return "Crouch"
                end
            else
                if not localplayer.is_moving and height >= 24 then
                    return "Standing"
                end
            end

            return nil
        end

        if localplayer.is_crouched then
            if is_taser and height > -20 and distancesqr < 500 * 500 then
                return "Air Crouch Taser"
            end

            if is_knife and height > -100 then
                return 'Air Crouch Knife'
            end

            if height > 130 then
                return "Air Crouch"
            end
        end

        return nil
    end

    local function update_context(ctx, condition)
        if condition == "Air Crouch Knife" then
            ctx.pitch = "Down"
            ctx.yaw_base = "At Target"

            ctx.yaw = "Backward" do
                ctx.yaw_add = 37

                ctx.yaw_left = 0
                ctx.yaw_right = 0
            end

            ctx.yaw_modifier = "Disabled" do
                ctx.modifier_offset = 0
            end

            ctx.body_yaw = true do
                ctx.inverter = false
                rage.antiaim:inverter(false)

                ctx.left_limit = 60
                ctx.right_limit = 60

                ctx.options = { }
            end

            ctx.hidden = false

            return
        end

        ctx.pitch = "Down"
        ctx.yaw_base = "At Target"

        ctx.yaw = "Backward" do
            ctx.yaw_add = 0

            ctx.yaw_left = 0
            ctx.yaw_right = 0
        end

        ctx.yaw_modifier = "Disabled" do
            ctx.modifier_offset = 0
        end

        ctx.body_yaw = true do
            ctx.inverter = false

            ctx.left_limit = 0
            ctx.right_limit = 0

            ctx.options = { }
        end

        ctx.hidden = false
    end

    function safe_head.update(ctx, manual_yaw, is_freestanding)
        if not should_update() or manual_yaw ~= nil or is_freestanding then
            return false
        end

        local me = entity.get_local_player()

        if me == nil then
            return false
        end

        local threat = entity.get_threat()

        if threat == nil then
            return false
        end

        local condition = get_condition(me, threat)

        if condition == nil then
            return false
        end

        local is_enabled = resource.antiaim.safe_head.conditions:get(condition)

        if not is_enabled then
            return false
        end

        update_context(ctx, condition)
        return true
    end
end

local break_lc do
    break_lc = { }

    local WEAPONTYPE_GRENADE = 9

    local m_flFlashBangTime = utils.get_netvar_offset("DT_CSPlayer", "m_flFlashDuration") - 0x10

    local function get_flashbang_time(player)
        return ffi.cast("float*", ffi.cast("unsigned int", player[0]) + m_flFlashBangTime)[0]
    end

    local function is_fps_below_tickrate()
        return globals.absoluteframetime > globals.tickinterval
    end

    local function is_weapon_grenade(weapon)
        local weapon_info = weapon:get_weapon_info()
        local weapon_type = weapon_info.weapon_type

        return weapon_type == WEAPONTYPE_GRENADE
    end

    local function is_disabled(weapon)
        if resource.antiaim.break_lc.disablers:get("Hide Shots") then
            local is_hide_shots = software.rage.main.hide_shots:get()
                and not software.rage.main.double_tap:get()

            if is_hide_shots then
                return true
            end
        end

        if resource.antiaim.break_lc.disablers:get("Pin Pulled") then
            if weapon.m_bPinPulled then
                return true
            end
        end

        if resource.antiaim.break_lc.disablers:get("Holding Grenade") then
            if is_weapon_grenade(weapon) then
                return true
            end
        end

        return false
    end

    local function is_statement()
        return resource.antiaim.break_lc.conditions:get(conditions.get())
    end

    local function is_triggered(me, weapon)
        if resource.antiaim.break_lc.triggers:get("Weapon Switch") then
            if me.m_flNextAttack > globals.curtime then
                return true
            end
        end

        if resource.antiaim.break_lc.triggers:get("Flashed") then
            -- 75 is optimal, I guess
            if get_flashbang_time(me) > 75 then
                return true
            end
        end

        if resource.antiaim.break_lc.triggers:get("Reloading") then
            if weapon:get_weapon_reload() ~= -1 then
                return true
            end
        end

        if resource.antiaim.break_lc.triggers:get("Flinching") then
            local flinch_seq = me:get_anim_overlay(10)

            if flinch_seq.cycle < 0.99 then
                return true
            end
        end

        return false
    end

    local function should_update()
        return rage.exploit:get() > 0
            and not is_fps_below_tickrate()
    end

    local function force_break_lagcomp(state)
        local game_rules = entity.get_game_rules()
        local freeze_period = game_rules.m_bFreezePeriod

        if freeze_period then
            state = false
        end

        software.rage.main.double_tap_lag_options:override(state and "Always on" or "")
        software.rage.main.hide_shots_options:override(state and "Break LC" or "Favor Fire Rate")
    end

    function break_lc.erase()
        software.rage.main.double_tap_lag_options:override()
        software.rage.main.hide_shots_options:override()
    end

    function break_lc.update(e)
        if not resource.antiaim.break_lc.enabled:get() then
            return false
        end

        local me = entity.get_local_player()

        if me == nil then
            return false
        end

        local weapon = me:get_player_weapon()

        if weapon == nil then
            return false
        end

        if not should_update() then
            return false
        end

        if is_disabled(weapon) then
            force_break_lagcomp(false)
            return false
        end

        local should_override = is_statement()
            or is_triggered(me, weapon)

        if should_override then
            force_break_lagcomp(true)
            return true
        end
    end
end

local legit_aa do
    legit_aa = { }

    local TEAM_CT = 3
    local WEAPONIDX_C4 = 34

    local MAX_BOMB_DISTANCE_SQR = 100 * 100

    local is_traced = false

    local function is_state_enabled(items)
        if items.enabled ~= nil and not items.enabled:get() then
            return false
        end

        return true
    end

    local function is_near_bomb(entity, origin)
        local position = entity:get_origin()
        local delta = position - origin

        return delta:length2dsqr() < MAX_BOMB_DISTANCE_SQR
    end

    local function can_player_plant(player, items)
        if not player.m_bInBombZone then
            return false
        end

        if items.bomb_e_fix:get() then
            local weapon = player:get_player_weapon()

            if weapon == nil then
                return false
            end

            return weapon:get_classid() == WEAPONIDX_C4
        end

        return true
    end

    local function can_player_defuse(player)
        if player.m_iTeamNum ~= TEAM_CT then
            return false
        end

        local origin = player:get_origin()

        local entities = entity.get_entities "CPlantedC4"

        for i = 1, #entities do
            local c4 = entities[i]

            if not c4.m_bBombTicking then
                goto continue
            end

            if is_near_bomb(c4, origin) then
                return true
            end

            ::continue::
        end

        return false
    end

    local function can_player_pickup(player)
        local view = render.camera_angles()
        local eye_pos = player:get_eye_position()

        local forward = vector():angles(view)
        local eye_sight = eye_pos + forward * 128

        local tr = utils.trace_line(eye_pos, eye_sight, player, 0xFFFFFFFF, 0)

        if tr.entity == nil or tr.fraction == 1.0 then
            return false
        end

        if player.m_bInBombZone then
            local classname = tr.entity:get_classname()

            if classname:find "CWeapon" then
                return true
            end

            return false
        end

        return true
    end

    local function can_player_rescue(player, tr)
        local entity = tr.entity

        if entity == nil then
            return false
        end

        local classid = entity:get_classid()

        if classid ~= 97 then
            return false
        end

        local entity_origin = entity:get_origin()
        local player_origin = player:get_origin()

        local delta = entity_origin - player_origin
        local lengthsqr = delta:length2dsqr()

        return lengthsqr < 3000
    end

    local function should_acting(player, items)
        return can_player_plant(player, items)
            or can_player_defuse(player)
    end

    local function get_trace(player)
        local view = render.camera_angles()
        local eye_pos = player:get_eye_position()

        local forward = vector():angles(view)
        local eyesight = eye_pos + forward * 128

        local mins = vector(-1, -1, -1)
        local maxs = vector(1, 1, 1)

        local mask = bit.bor(0x1, 0x2, 0x8, 0x4000, 0x2000000) -- MASK_SOLID

        return utils.trace_hull(eye_pos, eyesight, mins, maxs, player, mask, 0)
    end

    local function get_builder_items()
        local team = builder.get_team(
            localplayer.team_num
        )

        if team == nil then
            return nil
        end

        local items = builder.get_items("In Use", team)

        if items == nil then
            return nil
        end

        return items
    end

    function legit_aa.think(e)
        local items = get_builder_items()

        if items == nil or not is_state_enabled(items) then
            return false
        end

        local me = entity.get_local_player()

        if me == nil then
            return false
        end

        local is_using = e.in_use == true
        local is_acting = should_acting(me, items)

        if not is_using or is_acting then
            is_traced = false
            return false
        end

        local tr = get_trace(me)

        if can_player_rescue(me, tr) then
            return false
        end

        if not is_traced then
            is_traced = true

            if can_player_pickup(me) then
                return false
            end
        end

        return true
    end

    function legit_aa.update(e, ctx)
        e.in_use = false

        if ctx.yaw_add == nil then
            ctx.yaw_add = 0
        end

        ctx.freestanding = false
        ctx.extended_angles = false

        ctx.hidden = false
    end
end

local manual_aa do
    manual_aa = { }

    local values = {
        ["Left"] = -90,
        ["Right"] = 90,

        ["Forward"] = 180,
        ["Backward"] = 0
    }

    local function should_manual_edge()
        if not resource.antiaim.manual_yaw.manual_edge:get() then
            return false
        end

        local condition = conditions.get()

        return condition == "Crouching"
            or condition == "Crouching Move"
    end

    local function should_be_static()
        return resource.antiaim.manual_yaw.static_manuals:get()
    end

    function manual_aa.think(ctx)
        local value = values[resource.antiaim.manual_yaw.option:get()]

        if value ~= nil and should_be_static() then
            ctx.ignore_inverter = true
        end

        return value
    end

    function manual_aa.update(ctx, value, is_breaking_lc)
        if ctx.yaw_add == nil then
            ctx.yaw_add = 0
        end

        if is_breaking_lc and should_manual_edge() then
            ctx.hidden = true

            ctx.yaw_add = 0
            ctx.yaw_modifier = "Disabled"

            ctx.options = { }

            rage.antiaim:override_hidden_pitch(0)
            rage.antiaim:override_hidden_yaw_offset(180)
        end

        ctx.yaw_base = "Local View"
        ctx.yaw_add = ctx.yaw_add + value

        ctx.freestanding = false

        if should_be_static() then
            ctx.yaw_add = value
            ctx.yaw_modifier = "Disabled"

            ctx.options = {
                "Avoid overlap",
                "Anti Bruteforce"
            }

            ctx.delay = nil

            ctx.inverter = nil
            ctx.freestanding_body_yaw = "Peek Fake"
        end
    end
end

local manual_arrows do
    local PADDING = 40

    local FONT_CLASSIC = render.load_font("Verdana", 20, "abd")
    local FONT_MODERN  = render.load_font("Verdana", 27, "ab")

    local COLOR_DISABLED = color(0, 0, 0, 127)

    local type = "Disabled"

    local colors = {
        ["Arrows"] = resource.antiaim.manual_yaw.color:get("Arrows")[1],
        ["Desync"] = resource.antiaim.manual_yaw.color:get("Desync")[1]
    }

    local function on_render()
        local me = entity.get_local_player()

        if me == nil or not me:is_alive() then
            return
        end

        local manual = resource.antiaim.manual_yaw.option:get()

        local screen = render.screen_size()
        local center = screen * 0.5

        local color_arrows = colors["Arrows"]
        local color_desync = colors["Desync"]

        if type == "Classic" then
            if manual == "Left" then
                local text = "<"

                local text_size = render.measure_text(FONT_CLASSIC, "s", text)

                local text_pos = vector(
                    center.x - text_size.x - PADDING + 1,
                    center.y - text_size.y * 0.5 - 1
                )

                render.text(FONT_CLASSIC, text_pos, color_arrows, "s", text)
            end

            if manual == "Right" then
                local text = ">"

                local text_size = render.measure_text(FONT_CLASSIC, "s", text)

                local text_pos = vector(
                    center.x + PADDING,
                    center.y - text_size.y * 0.5 - 1
                )

                render.text(FONT_CLASSIC, text_pos, color_arrows, "s", text)
            end

            return
        end

        if type == "Modern" then
            local shadow_col = color_arrows:alpha_modulate(255)

            if manual == "Left" then
                local text = "⮜"

                local text_size = render.measure_text(FONT_MODERN, "s", text)

                local text_pos = vector(
                    center.x - text_size.x - PADDING + 1,
                    center.y - text_size.y * 0.5 - 1
                )

                local shadow_pos = vector(
                    text_pos.x + text_size.x * 0.5, center.y
                )

                render.shadow(shadow_pos, shadow_pos, shadow_col, FONT_MODERN.height + 4)
                render.text(FONT_MODERN, text_pos, color_arrows, "s", text)
            end

            if manual == "Right" then
                local text = "⮞"

                local text_size = render.measure_text(FONT_MODERN, "s", text)

                local text_pos = vector(
                    center.x + PADDING,
                    center.y - text_size.y * 0.5 - 1
                )

                local shadow_pos = vector(
                    text_pos.x + text_size.x * 0.5, center.y
                )

                render.shadow(shadow_pos, shadow_pos, shadow_col, FONT_MODERN.height + 4)
                render.text(FONT_MODERN, text_pos, color_arrows, "s", text)
            end

            return
        end

        if type == "Team-Skeet" then
            local width = 2
            local height = 18

            local gap = 2
            local padding = 47

            local peak = math.floor(height * 0.75)

            local real_rotation = rage.antiaim:get_rotation(false)
            local fake_rotation = rage.antiaim:get_rotation(true)

            local delta_rotation = math.normalize_yaw(fake_rotation - real_rotation)

            local is_left_desync = delta_rotation < 0
            local is_right_desync = delta_rotation > 0

            -- left
            do
                local position = center - vector(padding, 0)

                local rect_size = vector(width, height)
                local rect_pos = position - vector(rect_size.x, rect_size.y * 0.5)

                local rect_color = is_left_desync and color_desync or COLOR_DISABLED
                local poly_color = manual == "Left" and color_arrows or COLOR_DISABLED

                render.rect(rect_pos, rect_pos + rect_size, rect_color)
                position.x = position.x - (rect_size.x + gap)

                local point_0 = vector(position.x, position.y - height * 0.5)
                local point_1 = vector(position.x, position.y + height * 0.5)
                local point_2 = vector(position.x - peak, position.y)

                render.poly(poly_color, point_0, point_1, point_2)
            end

            do
                local position = center + vector(padding + 1, 0)

                local rect_size = vector(width, height)
                local rect_pos = position - vector(0, rect_size.y * 0.5)

                local rect_color = is_right_desync and color_desync or COLOR_DISABLED
                local poly_color = manual == "Right" and color_arrows or COLOR_DISABLED

                render.rect(rect_pos, rect_pos + rect_size, rect_color)
                position.x = position.x + (rect_size.x + gap)

                local point_0 = vector(position.x, position.y - height * 0.5)
                local point_1 = vector(position.x, position.y + height * 0.5)
                local point_2 = vector(position.x + peak, position.y)

                render.poly(poly_color, point_0, point_1, point_2)
            end
        end
    end

    resource.antiaim.manual_yaw.color:set_callback(function(item)
        local current, col = item:get()
        colors[current] = col
    end, true)

    resource.antiaim.manual_yaw.arrows:set_callback(function(item)
        local value = item:get()

        local is_enabled = value ~= "Disabled"

        if is_enabled then
            type = value
        end

        events.render(on_render, is_enabled)
    end, true)
end

local freestanding do
    freestanding = { }

    local function should_work()
        if not resource.antiaim.freestanding.enabled:get() then
            return false
        end

        local state = conditions.get()

        if resource.antiaim.freestanding.disablers:get(state) then
            return false
        end

        return true
    end

    function freestanding.update(ctx)
        if not should_work() then
            ctx.freestanding = false
            return false
        end

        ctx.freestanding = true

        ctx.disable_yaw_modifiers = resource.antiaim.freestanding.tweaks:get("Disable Yaw Modifiers")
        ctx.body_freestanding = resource.antiaim.freestanding.tweaks:get("Freestanding Body Yaw")

        if ctx.disable_yaw_modifiers and rage.antiaim:get_target(true) then
            ctx.yaw_add = 0
            ctx.yaw_modifier = "Disabled"

            ctx.ignore_inverter = true
        end

        return true
    end
end

local disable_fakelag do
    disable_fakelag = { }

    local is_standing = false
    local is_hide_shots = false
    local is_double_tap = false

    local function unset_override()
        software.antiaim.fake_lag.enabled:override()
    end

    local function set_override()
        software.antiaim.fake_lag.enabled:override(false)
    end

    local function should_disable()
        if is_standing and not localplayer.is_moving then
            return true
        end

        if is_hide_shots and software.rage.main.hide_shots:get() then
            return true
        end

        if is_double_tap and software.rage.main.double_tap:get() then
            return true
        end

        return false
    end

    local function on_shutdown()
        unset_override()
    end

    local function on_createmove()
        if should_disable() then
            set_override()
        else
            unset_override()
        end
    end

    resource.antiaim.disable_fakelag.select:set_callback(function(item)
        is_standing = item:get("Standing")
        is_hide_shots = item:get("Hide Shots")
        is_double_tap = item:get("Double Tap")
    end, true)

    resource.antiaim.disable_fakelag.enabled:set_callback(function(item)
        local value = item:get()

        if not value then
            unset_override()
        end

        events.shutdown(on_shutdown, value)
        events.createmove(on_createmove, value)
    end, true)
end

local avoid_backstab do
    avoid_backstab = { }

    function avoid_backstab.update(ctx)
        ctx.avoid_backstab = resource.antiaim.avoid_backstab.enabled:get()
    end
end

local animations do
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

    local function update_air_legs(player, animlayers)
        local value = resource.antiaim.animations.air_legs:get()

        if value == "Static" then
            local weight = resource.antiaim.animations.air_legs_weight:get()
            player.m_flPoseParameter[6] = weight * 0.01

            return
        end

        if value == "Moonwalk" then
            local layer = animlayers[6]

            layer.m_flWeight = 1.0
            layer.m_flCycle = (globals.curtime * 0.55) % 1

            return
        end
    end

    local function update_ground_legs(player, animlayers)
        local value = resource.antiaim.animations.ground_legs:get()

        if value == "Static" then
            player.m_flPoseParameter[0] = 1.0
            software.antiaim.misc.leg_movement:override("Sliding")

            return
        end

        if value == "Jitter" then
            local tickcount = globals.tickcount

            local offset_1 = resource.antiaim.animations.legs_offset_1:get()
            local offset_2 = resource.antiaim.animations.legs_offset_2:get()

            local mul = 1.0 / (tickcount % 8 >= 4 and 200 or 400)
            local offset = tickcount % 4 >= 2 and offset_1 or offset_2

            player.m_flPoseParameter[0] = offset * mul
            software.antiaim.misc.leg_movement:override("Sliding")

            return
        end

        if value == "Moonwalk" then
            player.m_flPoseParameter[7] = 0.0
            software.antiaim.misc.leg_movement:override("Walking")

            return
        end

        software.antiaim.misc.leg_movement:override()
    end

    local function update_pitch_on_land(player, animstate)
        local value = resource.antiaim.animations.pitch_on_land:get()

        if value == "Pitch Zero" then
            if animstate.landing then
                player.m_flPoseParameter[12] = 0.5
            end

            return
        end
    end

    local function update_move_lean(animlayers)
        local value = resource.antiaim.animations.move_lean:get()

        if value == -1 or not localplayer.is_moving then
            return
        end

        animlayers[12].m_flWeight = value
    end

    local function on_post_update_clientside_animation(player)
        local me = entity.get_local_player()

        if player ~= me then
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
            update_ground_legs(player, animlayers)
            update_pitch_on_land(player, animstate)
        else
            update_air_legs(player, animlayers)
        end

        update_move_lean(animlayers)
    end

    resource.antiaim.animations.enabled:set_callback(function(item)
        local value = item:get()

        if not value then
            software.antiaim.misc.leg_movement:override()
        end

        events.post_update_clientside_animation(on_post_update_clientside_animation, value)
    end, true)
end

local antiaim do
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

    local function get_inverter(ctx)
        if not ctx.ignore_inverter then
            local delay = ctx.delay
            local options = ctx.options

            local is_jitter = contains(options, "Jitter")

            local is_delay_jitter = delay ~= nil and options ~= nil
                and delay > 0 and is_jitter

            local should_return_delay = is_delay_jitter and ctx.body_yaw

            if should_return_delay then
                return last_delay_side, true
            end

            if is_jitter and not contains(options, "Randomize Jitter") then
                return bit.band(localplayer.sent_packets, 1) ~= 0, true
            end
        end

        return rage.antiaim:inverter(), false
    end

    local function update_inverter(ctx, e)
        if e.choked_commands ~= 0 then
            return false
        end

        local me = entity.get_local_player()

        if me == nil then
            return false
        end

        local anim_state = me:get_anim_state()

        if anim_state == nil then
            return false
        end

        local delay = ctx.delay
        local options = ctx.options

        local is_updating_delay_jitter = ctx.body_yaw ~= nil
            and delay ~= nil and options ~= nil
            and delay > 0 and contains(options, "Jitter")

        if is_updating_delay_jitter then
            last_delay_tick = last_delay_tick + 1

            -- should update delay
            if last_delay_tick > delay then
                last_delay_tick = 0
                last_delay_side = not last_delay_side

                if contains(options, "Randomize Jitter") then
                    if utils.random_int(0, 1) == 1 then
                        last_delay_side = not last_delay_side
                    end
                end
            end

            if contains(options, "Avoid Overlap") then
                local max_desync = rage.antiaim:get_max_desync()

                local real_rotation = rage.antiaim:get_rotation(false)
                local fake_rotation = rage.antiaim:get_rotation(true)

                local delta_rotation = math.normalize_yaw(fake_rotation - real_rotation)
                local abs_rotation = math.abs(delta_rotation)

                local overlap = 1 - math.clamp(abs_rotation, 0, max_desync) / max_desync

                if overlap > 0.3 then
                    last_delay_side = not last_delay_side
                end
            end
        end

        return true
    end

    local ctx do
        ctx = { }

        local Context = { } do
            Context.__index = Context

            local function modify_body_yaw(ctx, e)
                local side, is_changed = get_inverter(ctx)

                if is_changed then
                    ctx.inverter = side
                    rage.antiaim:inverter(side)
                end
            end

            local function modify_yaw_modifier(ctx, e)
                if ctx.modifier_offset == nil then
                    return
                end

                local side, is_changed = get_inverter(ctx)

                if ctx.yaw_modifier == "Offset" then
                    local offset = side and ctx.modifier_offset or 0

                    if not ctx.yaw_add then
                        ctx.yaw_add = 0
                    end

                    ctx.yaw_add = ctx.yaw_add + offset
                    ctx.modifier_offset = 0
                end

                if ctx.yaw_modifier == "Center" then
                    local offset = ctx.modifier_offset * 0.5

                    if not side then
                        offset = -offset
                    end

                    if not ctx.yaw_add then
                        ctx.yaw_add = 0
                    end

                    ctx.yaw_add = ctx.yaw_add + offset
                    ctx.modifier_offset = 0
                end
            end

            local function modify_yaw(ctx)
                local side = get_inverter(ctx)

                if ctx.yaw_left ~= nil and ctx.yaw_right ~= nil then
                    local offset = side and ctx.yaw_left or ctx.yaw_right

                    if not ctx.yaw_add then
                        ctx.yaw_add = 0
                    end

                    ctx.yaw_add = ctx.yaw_add + offset
                end
            end

            local function apply_context(ctx)
                software.antiaim.angles.enabled:override(ctx.enabled)
                software.antiaim.angles.pitch:override(ctx.pitch)

                software.antiaim.angles.yaw:override(ctx.yaw)
                software.antiaim.angles.yaw_base:override(ctx.yaw_base)
                software.antiaim.angles.yaw_add:override(ctx.yaw_add)
                software.antiaim.angles.avoid_backstab:override(ctx.avoid_backstab)
                software.antiaim.angles.hidden:override(ctx.hidden)

                software.antiaim.angles.yaw_modifier:override(ctx.yaw_modifier)
                software.antiaim.angles.modifier_offset:override(ctx.modifier_offset)

                software.antiaim.angles.body_yaw:override(ctx.body_yaw)
                software.antiaim.angles.inverter:override(ctx.inverter)
                software.antiaim.angles.left_limit:override(ctx.left_limit)
                software.antiaim.angles.right_limit:override(ctx.right_limit)
                software.antiaim.angles.options:override(ctx.options)
                software.antiaim.angles.freestanding_body_yaw:override(ctx.freestanding_body_yaw)

                software.antiaim.angles.freestanding:override(ctx.freestanding)
                software.antiaim.angles.disable_yaw_modifiers:override(ctx.disable_yaw_modifiers)
                software.antiaim.angles.body_freestanding:override(ctx.body_freestanding)

                software.antiaim.angles.extended_angles:override(ctx.extended_angles)
                software.antiaim.angles.extended_pitch:override(ctx.extended_pitch)
                software.antiaim.angles.extended_roll:override(ctx.extended_roll)
            end

            function Context:erase()
                for k in pairs(self) do
                    self[k] = nil
                end
            end

            function Context:get_inverter()
                return get_inverter(self)
            end

            function Context:update(e)
                if e ~= nil then
                    update_inverter(self, e)

                    modify_body_yaw(self, e)
                    modify_yaw_modifier(self, e)
                    modify_yaw(self, e)
                end

                apply_context(self)
            end

            function Context:__tostring()
                local list = { }

                for k, v in pairs(self) do
                    if type(v) == "table" then
                        v = table.concat(v, ", ")
                    end

                    table.insert(list, string.format("%s: %s", k, v))
                end

                return table.concat(list, "\n")
            end
        end

        setmetatable(ctx, Context)
    end

    local function apply(e, ctx)
        local team = localplayer.team_num
        local condition = conditions.get()

        break_lc.erase()

        local is_breaking_lc = break_lc.update(e)

        local is_legit_aa = legit_aa.think(e)
        local manual_yaw = manual_aa.think(ctx)

        avoid_backstab.update(ctx)

        if is_legit_aa then
            builder.update(ctx, "In Use", team)
            legit_aa.update(e, ctx)

            return
        end

        local is_freestanding = freestanding.update(ctx)

        builder.update(ctx, condition, team)
        local is_safe_head = safe_head.update(ctx, manual_yaw, is_freestanding)

        defensive.update(ctx, condition, manual_yaw, is_safe_head)

        if manual_yaw ~= nil then
            manual_aa.update(ctx, manual_yaw, is_breaking_lc)
            return
        end
    end

    local function on_shutdown()
        ctx:erase()
        ctx:update()
    end

    local function on_createmove(e)
        ctx:erase()

        apply(e, ctx)
        ctx:update(e)
    end

    local function on_createmove_run()
        ctx:erase()
        ctx:update()
    end

    events.shutdown(on_shutdown)

    events.createmove(on_createmove)
    events.createmove_run(on_createmove_run)
end

local player_esp do
    local distance_flag do
        esp.enemy:new_text("Distance", "1 ft", function(player)
            local me = entity.get_local_player()

            if me == nil then
                return nil
            end

            local my_origin = me:get_origin()
            local player_origin = player:get_origin()

            local delta = player_origin - my_origin
            local distance = aux.to_foot(delta:length())

            return string.format("%i ft", distance)
        end)
    end
end