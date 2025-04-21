-- leaked 1

_DEBUG = false
local clipboard = require("neverlose/clipboard")
local base64 = require("neverlose/base64")
local gradient = require("neverlose/gradient")
local
    networking,
    ui_handler,
    menu,
    visuals,
    colors,
    callbacks,
    ffi_handler,
    conditional_antiaims,
    sync,
    neverlose_refs,
    defines,
    createmove,
    edge_yaw,
    antiaim_on_use,
    exploit_manipulations, 
    easy_peek,
    chams,
    fast_ladder,
    animations,
    indicators,
    solus,
    aimbot_logger,
    exploit_discharge,
    exploit_manipulation,
    revolver_helper,
    head_only,
    speed_warning,
    snaplines,
    hit_markers,
    grenades,
    console_color,
    aspect_ratio,
    thanos_snap,
    gamesense,
    viewmodel,
    local_player_angles,
    clantag,
    draggables,
    unmute_silenced,
    taskbar_notify, 
    panorama_ad = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}

callbacks.error_logged = false
callbacks.last_error_log = -1
callbacks.network_ratelimit = 5

networking.logError = function(message)
    local error_message = message:gsub("\a.{6}", "")

    if networking.active and not callbacks.error_logged then
        print("attemp to report")
        networking.sendMessage("crashlog", error_message)
        callbacks.error_logged = true
        callbacks.last_error_log = globals.realtime
    end

    print_raw(message)
    print_dev(error_message)
end
local safecall = function(name, report, f)
    return function(...)


        --local time_start = common.get_timestamp()

        local s, ret = pcall(f, ...)


       --local time_end = common.get_timestamp()
       --local diff = time_end - time_start

       --if diff > 1 then
       --    print(string.format("result: [%s]\t-> %.2fms", name, time_end - time_start))
       --end

        if not s then

            local retmessage = "safe call failed [" .. name .. "] -> " .. ret

            if report then
    
                networking.logError(retmessage)
            end

            return false, retmessage
        else
            return ret, s
        end

    end
end

ui_handler.configs = {}

neverlose_refs.dormant = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot")

neverlose_refs.hitboxes = ui.find("Aimbot", "Ragebot", "Selection", "Hitboxes")
neverlose_refs.multipoint = ui.find("Aimbot", "Ragebot", "Selection", "Multipoint")
neverlose_refs.inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter")

neverlose_refs.slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk")
neverlose_refs.fake_duck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck")

neverlose_refs.pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch")

neverlose_refs.yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw")
neverlose_refs.yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base")
neverlose_refs.yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset")
neverlose_refs.yaw_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab")

neverlose_refs.yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier")
neverlose_refs.yaw_modifier_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset")

neverlose_refs.body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw")
neverlose_refs.left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit")
neverlose_refs.right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit")
neverlose_refs.body_yaw_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options")
neverlose_refs.body_yaw_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding")

neverlose_refs.freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding")
neverlose_refs.disable_yaw_modif = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers")
neverlose_refs.body_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding")

neverlose_refs.extended_angles = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles")
neverlose_refs.extended_pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch")
neverlose_refs.extended_roll = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll")

neverlose_refs.fakelag = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled")
neverlose_refs.fakelag_limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit")
neverlose_refs.fakelag_var = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability")

neverlose_refs.hitchance = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance")

neverlose_refs.doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap")
neverlose_refs.doubletap_config = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options")
neverlose_refs.doubletap_fakelag = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit")

neverlose_refs.min_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage") 
neverlose_refs.prefer_body = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim")
neverlose_refs.prefer_safety = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points")

neverlose_refs.quick_peek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist")

neverlose_refs.hideshots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots")
neverlose_refs.hideshots_config = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options")

neverlose_refs.fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency")
neverlose_refs.legs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")

neverlose_refs.scope_overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")

neverlose_refs._vars = {}

for k, v in pairs(neverlose_refs) do
    if k ~= "_vars" then
        neverlose_refs._vars[k] = {
            tick = -1,
            var = v
        }
    end
end

neverlose_refs.deoverride_unused = function(unoverride_all)
    local ticks = globals.tickcount

    for k, v in pairs(neverlose_refs._vars) do
        if unoverride_all or math.difference(v.tick, ticks) > 16 then
            v.var:override()
        end
    end

end

neverlose_refs.override = function(name, value)

    local var = neverlose_refs._vars[name]

    --if new_var and new_var:get_id() ~= var.var:get_id() then
    --    print("update?")
    --    var.var:override()
    --    neverlose_refs._vars[name].var = new_var
    --end

    if var == nil then
        return
    end

    if type(value) == "table" and value._len then
        value._len = nil
    end

    var.var:override(value)
    
    var.tick = globals.tickcount

    return var.var
end


colors.black = color(0, 255)
colors.white = color(255)
colors.main = color(255, 120, 30, 255)

local   FL_ONGROUND	        = bit.lshift(1, 0)
local   FL_DUCKING	        = bit.lshift(1, 1)
local   FL_WATERJUMP        = bit.lshift(1, 3)
local   FL_ONTRAIN	        = bit.lshift(1, 4)
local   FL_INRAIN	        = bit.lshift(1, 5)
local   FL_FROZEN	        = bit.lshift(1, 6)
local   FL_ATCONTROLS       = bit.lshift(1, 7)
local   FL_CLIENT	        = bit.lshift(1, 8)
local   FL_FAKECLIENT       = bit.lshift(1, 9)
local   FL_INWATER	        = bit.lshift(1, 10)

local bind = function ( f, a )
    return function ( ... )
        return f ( a, ... )
    end
end

local lift = function ( t )
    return function ( )
        return t
    end
end

local call_later = function ( f, ... )
    local a = { ... }

    return function ( )
        return f ( unpack ( a ) )
    end
end

local call_chain = function ( ... )
    local c = nil

    for iter, fn in ipairs { ... } do
        c = fn ( c )
        if c == nil then
            return
        end
    end

    return c
end

local call_chain_action = bind ( call_later, call_chain )

local read = function ( k )
    return function ( t )
        return k == nil and t or t [ k ]
    end
end

local from_ext_table = function (tbl)
    return function ( t )
        return tbl[t]
    end
end

local write = function(args)
    if args == nil then
        return function(t)
            return t[f]()
        end
    else
        return function(t)
            return t[f](unpack(args))
        end
    end
end

local self_write = function(f, args)
    if args == nil then
        return function(t)
            return t[f](t)
        end
    else
        return function(t)
            return t[f](t, unpack(args))
        end
    end
end

local write = function ( f )
    return function ( t )
        local t1 = { unpack ( t ) }
        t1 [ #t1 + 1 ] = f ( )
        return t1
    end
end



-- { condition, value }

local match = function ( ... )
    local a = { ... }

    return setmetatable ( { }, {
        __index = function ( t, k )
            for iter, data in ipairs ( a ) do
                local f, v = unpack ( data )

                if f ( k ) then
                    return v
                end
            end
        end
    } )
end

getmetatable(color()).override = function (c, k, n)
    local cl = c:clone()

    cl [k] = n

    return cl
end

networking.sendMessage = function(action, data)

end

sync.current_channel = "unknown channel"
sync.prev_channel = "offline"

sync.applied_info = {}
sync.players = {}

sync.add_info = function(steamid, arg, val)
    
    if steamid == nil then
        return nil
    end

    if sync.players[steamid] == nil then
        sync.players[steamid] = {}
    end

    sync.players[steamid][arg] = val
end

sync.add_applied_info = function(steamid, arg, val)
    
    if sync.applied_info[steamid] == nil then
        sync.applied_info[steamid] = {}
    end

    sync.applied_info[steamid][arg] = val
end

sync.last_local_icon = nil
sync.icon = function()

end

sync.render_nymbus = function(ptr, clr)

    local ptr_origin = ptr:get_hitbox_position(0)
    local eye_pos = ptr:get_eye_position()
    eye_pos.z = math.max(eye_pos.z + 8, ptr_origin.z + 8)

    render.circle_3d_outline(eye_pos, clr, 6, 0, 1, 2)

end

sync.nymbus = safecall("nymbus", true, function()
    if not ui_handler.elements["features"]["shared_features"] then
        return
    end

    if not globals.is_in_game then
        return
    end

    local player = entity.get_local_player()

    local players = entity.get_players(false, false, function(ptr)

        if ptr == player then

            if ui_handler.elements["features"]["nymbus"] and ui_handler.elements["features"]["nymbus_self"] then
                sync.render_nymbus(ptr, ui_handler.elements["features"]["nymbus_clr"])
            end

            return
        end

        if not ptr:is_alive() then
            return
        end

        local info = ptr:get_player_info()

        if info == nil then
            return
        end

        local steamid = info.steamid64
        local sync_info = sync.players[steamid]

        if sync_info == nil or not sync_info.nymbus then
            return
        end       

        sync.add_applied_info(steamid, "nymbus", sync_info.nymbus)

        local clr = sync_info.nymbus_clr

        if clr == nil then
            clr = color(255, 255, 0, 255)
        else
            clr = color(clr)
        end

        sync.render_nymbus(ptr, clr)
    end)
end)

networking.get_sync_data = function()

    return {}
end

networking.sync_data = function()
    networking.sendMessage("sync_message", {sync = networking.get_sync_data()})
end

networking.active = false

ui_handler.configs_list = {}

ui_handler.on_config_desc_update = function()

    local data = ui_handler.configs_list[ui_handler.get_active_config_element()]

    if data == nil then -- ну и пиздец полный

        ui_handler.refs["cfg"]["config_info_label"].ref:name("Config not selected!")
        return
    end

    local config_info = string.format("%s\n%s\n%s",
        defines.colored_text({"Name: "}, {data.visible_name, colors.link_active}),
        defines.colored_text({"Author: "}, {data.original_author, colors.link_active}),
        defines.colored_text({"Last Edit: "}, {data.last_edited, colors.link_active})
    )

    ui_handler.refs["cfg"]["config_info_label"].ref:name(config_info)
end

networking.is_banned = false
networking.auth_phase = false

networking.auth_data = {}

networking.format_online_string = function(online)
    return defines.colored_text({" Currently Online: ", colors.active_text}, {online, colors.link_active})
end

networking.get_online_string = function()
    if networking.auth_data.online == nil then
        return networking.format_online_string(0)
    end

    return networking.format_online_string(networking.auth_data.online)
end

networking.handlers = {
    auth = function(data)

        
    end,

    discord = function(data)
        common.add_notify("Discord Role", data)
    end,

    config_save = function(data)

    end,

    config_create = function(data)

        

    end,

    config_load = function(data)

    end,

    config_parse = function(data)

    end,

    config_delete = function(data)

    end, 

    sync = function(data)

    end,

    sync_mass = function(data)

    end,
    counter = function(data)

    end
}

for k, v in pairs(networking.handlers) do
    networking.handlers[k] = safecall(k, true, v)
end

ui_handler.update_welcome = function()
    ui_handler.refs["info"]["info_label"].ref:name(ui_handler.generate_welcome_text())
    ui_handler.global_update_callback()
end

defines.username = common.get_username()
defines.steamid = panorama.MyPersonaAPI.GetXuid()
defines.steam_name = panorama.MyPersonaAPI.GetName()
defines.screen_size = render.screen_size()

defines.centered_text = function(str)
    local space = ""

    if #str > 44 then
        return ""
    end


    for i = 1, 44 - #str do
        space = space .. "\x20"
    end

    return space .. str
end

defines.get_bind = function(name)
    local state = false
    local value = 0
    local binds = ui.get_binds()
    for i = 1, #binds do
        if binds[i].name == name and binds[i].active then
            state = true
            value = binds[i].value
        end
    end
    return {state, value}
end

--print_raw(defines.colored_text({"chlen", color(255, 0, 0, 255)}, {"dick", color(0, 255, 0, 255)}))

local panic = false

if db.dy_panic == nil then
    db.dy_panic = defines.username
elseif db.dy_panic ~= defines.username then
    panic = true
end

networking.callbacks = {
    open = function(data)

    end,
    error = function(data)

    end,
    message = function(data, message)

    end,
    close = function(data)

    end,
}

networking.request_mass = function()
end

ui_handler.elements = {}
ui_handler.refs = {}

ui_handler.global_update_callback = safecall("global_update", true, function()

    for k, v in pairs(ui_handler.refs) do
        for name, table_reference in pairs(v) do
            if table_reference ~= nil and table_reference.condition then
                table_reference.update_value(table_reference.ref)
                table_reference.ref:visibility(table_reference.condition() or false)
            end
        end
    end

end)

ui_handler.reverse_tbl = function(tbl)

    local value_list = tbl
    local value_list_num = #value_list

    local tmp = {}
    for k, v in pairs(value_list) do
        if k ~= "_len" then
            tmp[v] = true
        end
    end

    return tmp
end

ui_handler.new_element = function(tab, name, include_in_config, cheat_var, condition)

    if include_in_config == nil then
        include_in_config = true
    end

    if type(cheat_var) ~= "userdata" then
        error("Failed to create " .. name .. ": " .. type(cheat_var))
        return
    end

    if ui_handler.refs[tab] == nil then
        ui_handler.refs[tab] = {}
        ui_handler.elements[tab] = {}
    end

    if ui_handler.refs[tab][name] ~= nil then
        print(string.format("[UI_HANDLER] Element already exists: %s->%s", tab, name))
        error("[UI_HANDLER] error")
    end

    ui_handler.refs[tab][name] = {
        ref = cheat_var,
        condition = condition,
        config = include_in_config
    }

    local update_value = function(new_value)

        local menu_type = new_value:type()
        local val = new_value:get()
        if menu_type == "selectable" then

            local tmp = ui_handler.reverse_tbl(val)

            ui_handler.elements[tab][name] = tmp
            ui_handler.elements[tab][name]._len = value_list_num -- мне лень ставить метатаблицу, пишов нахуй

        elseif menu_type == "listable" then
            local list = new_value:list()
            local len = #list

            local tmp = {}
            for k, v in ipairs(val) do
                tmp[list[v]] = k
            end

            ui_handler.elements[tab][name] = tmp
            ui_handler.elements[tab][name]._len = len
        else
            ui_handler.elements[tab][name] = val
        end

    end

    ui_handler.refs[tab][name].update_value = update_value

    cheat_var:set_callback(update_value, true)
    cheat_var:set_callback(ui_handler.global_update_callback)
    return cheat_var
end

ui_handler.groups = {}
menu = {
    __index = function(self, index, args)
        return (function(group, ...)


            local item_group
            if group.__name ~= "sol.Lua::LuaGroup" then
                local group_hash = string.format("%s%s", group[2] == nil and "unk" or group[2], group[1])
                item_group = ui_handler.groups[group_hash]
                if item_group == nil then
                    if group[2] ~= nil then
                        ui_handler.groups[group_hash] = ui.create(group[1], group[2])
                    else
                        ui_handler.groups[group_hash] = ui.create(group[1]) -- тут беды с таблицами, поэтому нуль туда запустить не выйдет
                    end
                    item_group = ui_handler.groups[group_hash]
                end
            else
                item_group = group
            end

            local item = item_group[index](item_group, ...)
            return (function(tab, uniq_name, in_config, fn)
                ui_handler.new_element(tab, uniq_name, in_config, item, fn)
                return function(afn)

                    if afn ~= nil then
                        afn(item:create()) -- мб привязку как то организовать более автоматическую
                    end

                    return item
                end
            end)
        end)
    end
}

menu = setmetatable(menu, menu)

ui_handler.configs.parse_json_tooltips = function()
    local ftbl = {}

    for j, l in pairs(ui_handler.refs) do

        local tbl = {}

        for k, v in pairs(l) do

            tbl[k] = ui_handler.refs[j][k].ref:get_tooltip()

            ::skip::
        end

        ftbl[j] = tbl

    end

    clipboard.set(json.encode(ftbl))
end

ui_handler.configs.apply_tooltips = function(list)
    for j, l in pairs(list) do
        for k, v in pairs(l) do
            if ui_handler.refs[j] and ui_handler.refs[j][k] then
                ui_handler.refs[j][k].ref:tooltip(v)  
            end
        end
    end
end

ui_handler.configs.parse = function()

    local ftbl = {}

    for j, l in pairs(ui_handler.refs) do

        local tbl = {}

        for k, v in pairs(l) do

            if not v.config then
                goto skip
            end

            local is_color = false
            if getmetatable(ui_handler.elements[j][k]) and ui_handler.elements[j][k].__name then
                is_color = ui_handler.elements[j][k].__name == "sol.ImColor"
            end

            local val = ui_handler.elements[j][k]
            local type = v.ref:get_type()

            if type == "listable" or type == "selectable" then
                val = v.ref:get()
            end

            --ui_handler.reverse_tbl
            tbl[k] = is_color and ui_handler.elements[j][k]:to_hex() or val

            ::skip::
        end

        ftbl[j] = tbl

    end

    return json.encode(ftbl)
end

ui_handler.configs.load = function(data)

    for k, v in pairs(data) do

        if ui_handler.refs[k] ~= nil then

            for j, l in pairs(v) do

                if ui_handler.refs[k][j] ~= nil then

                    local protected = function()
                        if type(l) == "string" and l:match("^#?%x%x%x%x%x%x%x%x$") then
                            local clr = color(l)
                            ui_handler.refs[k][j].ref:set(clr)
                            ui_handler.elements[k][j] = clr
                        else
                            ui_handler.refs[k][j].ref:set(l)
                            ui_handler.elements[k][j] = l
                        end
                    end

                    pcall(protected)
                    
                end
            end
        end
    end

    ui_handler.global_update_callback()
    draggables.adjust()
end

ui_handler.get_active_config_element = function()

    local list = ui_handler.refs["cfg"]["config_list"].ref:list()

    if list == nil then
        return nil
    end

    return list[ui_handler.elements["cfg"]["config_list"]]
end

ui_handler.get_config_code = function(name)

    local tbl = ui_handler.configs_list[name]

    if tbl == nil then
        return nil
    end

    return tbl.name
end

defines.colored_text = function(...)
    local data = {...}
    local str = ""
    for i = 1, #data do

        if data[i] == nil or data[i][1] == nil then
            goto skip
        end

        if data[i][2] == nil then
            str = str .. data[i][1]
        else
            str = str .. ("\a%s%s\aDEFAULT"):format(data[i][2]:to_hex(), data[i][1])
        end

        ::skip::
    end

    return str
end

ui_handler.hashed_icons = {}
ui_handler.get_icon = function(icon)
    if ui_handler.hashed_icons[icon] == nil then
        ui_handler.hashed_icons[icon] = ui.get_icon(icon)
    end

    return ui_handler.hashed_icons[icon]
end

ui_handler.hashed_styles = {}
ui_handler.get_style = function(style)

    if ui_handler.hashed_styles[style] == nil then
        ui_handler.hashed_styles[style] = ui.get_style(style)
    end

    return ui_handler.hashed_styles[style]

end

colors.link_active = ui_handler.get_style("Link Active")
colors.active_text = ui_handler.get_style("Active Text")

ui_handler.generate_welcome_text = function()
    return defines.colored_text(
        {ui_handler.get_icon("user-cog"), colors.link_active},
        {" Build: ", colors.active_text}, 
        {"Alpha\n\n", colors.link_active},
        {ui_handler.get_icon("users"), colors.link_active},
        {networking.get_online_string() .. "\n\n", colors.link_active},
        {ui_handler.get_icon("user-check"), colors.link_active},
        {" Logged in as ", colors.active_text}, 
        {defines.username .. "\n\n", colors.link_active},
        {ui_handler.get_icon("user-tag"), colors.link_active},
        {" Discord: ", colors.active_text}, 
        {(db.discord_id ~= nil and db.discord_id.username or "Please stfu!") .. "\n\n", colors.link_active},
        {"\a" .. colors.active_text:to_hex() .. defines.centered_text("drainyaw.nl © 2020 - 2023"), colors.active_text}
    )
end

ui_handler.welcome_text = ui_handler.generate_welcome_text()

ui_handler.groups_name = {
    setup = {
        information = {defines.colored_text({ui_handler.get_icon("user-check"), colors.link_active}, {" Setup"}), defines.colored_text({ui_handler.get_icon("home"), colors.link_active}, {" Home"})},
        settings = {defines.colored_text(   {ui_handler.get_icon("user-check"), colors.link_active}, {" Setup"}), defines.colored_text({ui_handler.get_icon("database"), colors.link_active}, {" Settings"})},
        additional = {defines.colored_text( {ui_handler.get_icon("user-check"), colors.link_active}, {" Setup"}), defines.colored_text({ui_handler.get_icon("lightbulb"), colors.link_active}, {" Other"})}
    },

    features = {
        ragebot =       {defines.colored_text({ui_handler.get_icon("user-edit"), colors.link_active}, {" Additions"}), defines.colored_text({ui_handler.get_icon("crosshairs"), colors.link_active}, {" Ragebot"})},
        interface =     {defines.colored_text({ui_handler.get_icon("user-edit"), colors.link_active}, {" Additions"}), defines.colored_text({ui_handler.get_icon("palette"), colors.link_active}, {" Interface"})},
        additional =    {defines.colored_text({ui_handler.get_icon("user-edit"), colors.link_active}, {" Additions"}), defines.colored_text({ui_handler.get_icon("cogs"), colors.link_active}, {" Other"})},
        miscellaneous = {defines.colored_text({ui_handler.get_icon("user-edit"), colors.link_active}, {" Additions"}), defines.colored_text({ui_handler.get_icon("wrench"), colors.link_active}, {" Miscellaneous"})}
    },

    antiaim = {
        general = {defines.colored_text({ui_handler.get_icon("user-shield"), colors.link_active}, {" Anti-Aim"}), defines.colored_text({ui_handler.get_icon("sitemap"), colors.link_active}, {" General"})},
        builder = {defines.colored_text({ui_handler.get_icon("user-shield"), colors.link_active}, {" Anti-Aim"}), defines.colored_text({ui_handler.get_icon("sliders-h"), colors.link_active}, {" Builder"})}
    }
}

menu.list(ui_handler.groups_name.setup.settings, "", {"\aFF0000FFConfigs not found :("})("cfg", "config_list", false)

menu.label(ui_handler.groups_name.setup.settings, "Loading..")("cfg", "config_info_label", false)

menu.input(ui_handler.groups_name.setup.settings, "Name", "New Config")("cfg", "create_config_name", false)

menu.button(ui_handler.groups_name.setup.settings, defines.colored_text({ui_handler.get_icon("file-upload"), colors.link_active}, {" Apply"}), function()

end, true)

menu.button(ui_handler.groups_name.setup.settings, defines.colored_text({ui_handler.get_icon("plus"), colors.link_active}, {" Create"}), function()

end, true)

menu.button(ui_handler.groups_name.setup.settings, defines.colored_text({ui_handler.get_icon("save"), colors.link_active}, {" Save"}), function()

end, true)

menu.button(ui_handler.groups_name.setup.settings, defines.colored_text({ui_handler.get_icon("trash-alt"), colors.link_active}, {" Delete"}), function()

end, true)

menu.button(ui_handler.groups_name.setup.settings, defines.colored_text({ui_handler.get_icon("file-export"), colors.link_active}, {" Export Config"}), function()
    local data = ui_handler.configs_list[ui_handler.get_active_config_element()]

    if data == nil then
        common.add_notify("Configs", "Something went wrong!")
        return
    end

    clipboard.set(data.share_name)
    
    common.add_notify("Configs", "Config succesfully exported!")
end, true)

menu.button(ui_handler.groups_name.setup.settings, defines.colored_text({ui_handler.get_icon("file-import"), colors.link_active}, {" Import Config"}), function()

end, true)

menu.label(ui_handler.groups_name.setup.information, ui_handler.welcome_text)("info", "info_label", false)

menu.button(ui_handler.groups_name.setup.additional, defines.colored_text({ui_handler.get_icon("university"), colors.link_active}, {" Join Discord"}), function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/og4leaks")
end, true)("info", "join_discord", false)

menu.button(ui_handler.groups_name.setup.additional, defines.colored_text({ui_handler.get_icon("tag"), colors.link_active}, {" Get Discord Role"}), function()
    
end, true)("info", "get_discord_role", false, function()
    return db.discord_id ~= nil and networking.active
end)

menu.button(ui_handler.groups_name.setup.additional, defines.colored_text({"Best leaks"}), function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("discord.gg/og4leaks")
end, true)
menu.button(ui_handler.groups_name.setup.additional, defines.colored_text({"Best leaks"}), function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("discord.gg/og4leak")
end, true)
menu.button(ui_handler.groups_name.setup.additional, defines.colored_text({"Best leaks"}), function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("discord.gg/og4leak")
end, true)
menu.button(ui_handler.groups_name.setup.additional, defines.colored_text({"Best leaks"}), function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("discord.gg/og4leak")
end, true)

ui_handler.refs["cfg"]["config_list"].ref:set_callback(ui_handler.on_config_desc_update, true)

math.static_lerp = function(start, end_pos, time)
    return start + (end_pos - start) * time
end

math.static_color_lerp = function(start, end_pos, time)
    return start:lerp(end_pos, time)
end

math.color_lerp = function(start, end_pos, time)
    local frametime = globals.frametime * 100
    time = time * frametime
    return start:lerp(end_pos, time)
end

math.abs = math.abs -- memes

math.difference = function (num1, num2)
    return math.abs(num1 - num2)
end

math.lerp = function(start, end_pos, time)

    if start == end_pos then
        return end_pos
    end

    local frametime = globals.frametime * 170
    time = time * frametime

    local val = start + (end_pos - start) * time

    if(math.abs(val - end_pos) < 0.01) then
        return end_pos
    end

    return val
end

math.normalize_yaw = math.normalize_yaw

animations.base_speed = 0.07
animations._list = {}
animations.new = function(name, new_value, speed, init)
    speed = speed or animations.base_speed
    local is_color = type(new_value) ~= "number"

    if animations._list[name] == nil then
        animations._list[name] = (init and init) or (is_color and colors.white or 0)
    end

    local interp_func

    if is_color then
        interp_func = math.color_lerp
    else
        interp_func = math.lerp
    end

    animations._list[name] = interp_func(animations._list[name], new_value, speed)
    return animations._list[name] -- требую моржовые операторы в луа
end

math.vector_lerp = function(vecSource, vecDestination, flPercentage)
    return vecSource:lerp(vecDestination, flPercentage)
end

ffi.cdef[[
    typedef int(__fastcall* clantag_t)(const char*, const char*);
    typedef void*(__thiscall* get_client_entity_t)(void*, int);

    typedef struct
    {
        float x;
        float y;
        float z;
    } Vector_t;

    typedef struct
    {
        char    pad0[0x60]; // 0x00
        void* pEntity; // 0x60
        void* pActiveWeapon; // 0x64
        void* pLastActiveWeapon; // 0x68
        float        flLastUpdateTime; // 0x6C
        int            iLastUpdateFrame; // 0x70
        float        flLastUpdateIncrement; // 0x74
        float        flEyeYaw; // 0x78
        float        flEyePitch; // 0x7C
        float        flGoalFeetYaw; // 0x80
        float        flLastFeetYaw; // 0x84
        float        flMoveYaw; // 0x88
        float        flLastMoveYaw; // 0x8C // changes when moving/jumping/hitting ground
        float        flLeanAmount; // 0x90
        char         pad1[0x4]; // 0x94
        float        flFeetCycle; // 0x98 0 to 1
        float        flMoveWeight; // 0x9C 0 to 1
        float        flMoveWeightSmoothed; // 0xA0
        float        flDuckAmount; // 0xA4
        float        flHitGroundCycle; // 0xA8
        float        flRecrouchWeight; // 0xAC
        Vector_t        vecOrigin; // 0xB0
        Vector_t        vecLastOrigin;// 0xBC
        Vector_t        vecVelocity; // 0xC8
        Vector_t        vecVelocityNormalized; // 0xD4
        Vector_t        vecVelocityNormalizedNonZero; // 0xE0
        float        flVelocityLenght2D; // 0xEC
        float        flJumpFallVelocity; // 0xF0
        float        flSpeedNormalized; // 0xF4 // clamped velocity from 0 to 1
        float        flRunningSpeed; // 0xF8
        float        flDuckingSpeed; // 0xFC
        float        flDurationMoving; // 0x100
        float        flDurationStill; // 0x104
        bool        bOnGround; // 0x108
        bool        bHitGroundAnimation; // 0x109
        char    pad2[0x2]; // 0x10A
        float        flNextLowerBodyYawUpdateTime; // 0x10C
        float        flDurationInAir; // 0x110
        float        flLeftGroundHeight; // 0x114
        float        flHitGroundWeight; // 0x118 // from 0 to 1, is 1 when standing
        float        flWalkToRunTransition; // 0x11C // from 0 to 1, doesnt change when walking or crouching, only running
        char    pad3[0x4]; // 0x120
        float        flAffectedFraction; // 0x124 // affected while jumping and running, or when just jumping, 0 to 1
        char    pad4[0x208]; // 0x128
        float        flMinBodyYaw; // 0x330
        float        flMaxBodyYaw; // 0x334
        float        flMinPitch; //0x338
        float        flMaxPitch; // 0x33C
        int            iAnimsetVersion; // 0x340
    } CCSGOPlayerAnimationState_534535_t;
]]

ffi_handler.bind_argument = function(fn, arg)
    return function(...)
        return fn(arg, ...)
    end
end

ffi_handler.sigs = {
    set_clantag = {"engine.dll", "53 56 57 8B DA 8B F9 FF 15"},
    get_pose_params = {"client.dll", "55 8B EC 8B 45 08 57 8B F9 8B 4F 04 85 C9 75 15"},
    weapon_system = {"client.dll", "8B 35 ? ? ? ? FF 10 0F B7 C0", 2}
}

ffi_handler.engine_client = ffi.cast(ffi.typeof("void***"), utils.create_interface("engine.dll", "VEngineClient014"))
ffi_handler.entity_list_003 = ffi.cast(ffi.typeof("uintptr_t**"), utils.create_interface("client.dll", "VClientEntityList003"))
ffi_handler.get_entity_address = ffi_handler.bind_argument(ffi.cast("get_client_entity_t", ffi_handler.entity_list_003[0][3]), ffi_handler.entity_list_003)
ffi_handler.console_is_visible = ffi_handler.bind_argument(ffi.cast("bool(__thiscall*)(void*)", ffi_handler.engine_client[0][11]), ffi_handler.engine_client)
ffi_handler.raw_hwnd = utils.opcode_scan("engine.dll", "8B 0D ?? ?? ?? ?? 85 C9 74 16 8B 01 8B")
ffi_handler.raw_FlashWindow = utils.opcode_scan("gameoverlayrenderer.dll", "55 8B EC 83 EC 14 8B 45 0C F7")
ffi_handler.raw_insn_jmp_ecx = utils.opcode_scan("gameoverlayrenderer.dll", "FF E1")
ffi_handler.raw_GetForegroundWindow = utils.opcode_scan("gameoverlayrenderer.dll", "FF 15 ?? ?? ?? ?? 3B C6 74")
ffi_handler.hwnd_ptr = ((ffi.cast("uintptr_t***", ffi.cast("uintptr_t", ffi_handler.raw_hwnd) + 2)[0])[0] + 2)
ffi_handler.flash_window = ffi.cast("int(__stdcall*)(uintptr_t, int)", ffi_handler.raw_FlashWindow)
ffi_handler.insn_jmp_ecx = ffi.cast("int(__thiscall*)(uintptr_t)", ffi_handler.raw_insn_jmp_ecx)
ffi_handler.GetForegroundWindow = (ffi.cast("uintptr_t**", ffi.cast("uintptr_t", ffi_handler.raw_GetForegroundWindow) + 2)[0])[0]

conditional_antiaims.states = {
    unknown = -1,
    standing = 1,
    moving = 2,
    slowwalk = 3,
    crouching = 4,
    moving_crouch = 5,
    air = 6,
    air_crouch = 7
}

conditional_antiaims.states_names = {}
for k, v in pairs(conditional_antiaims.states) do
    conditional_antiaims.states_names[v] = k:sub(1,1):upper() .. k:sub(2, #k)
end

conditional_antiaims.player_state = 1
conditional_antiaims.update_player_state = function(cmd)

    local localplayer = entity.get_local_player()

    if localplayer == nil then
        return
    end

    local flags = localplayer.m_fFlags

    local is_crouching = bit.band(flags, FL_DUCKING) ~= 0
    local on_ground = bit.band(flags, FL_ONGROUND) ~= 0
    local is_not_moving = localplayer.m_vecVelocity:length() < 2
    local is_slowwalk = neverlose_refs.slow_walk:get()
    local is_jumping = cmd.in_jump

    if is_crouching and (is_jumping or not on_ground) then
        conditional_antiaims.player_state = conditional_antiaims.states.air_crouch
        return
    end

    if is_jumping or not on_ground then
        conditional_antiaims.player_state = conditional_antiaims.states.air
        return
    end

    if is_slowwalk then
        conditional_antiaims.player_state = conditional_antiaims.states.slowwalk
        return
    end

    if not is_crouching and is_not_moving then
        conditional_antiaims.player_state = conditional_antiaims.states.standing
        return
    end

    if is_crouching and not is_not_moving and not is_slowwalk then
        conditional_antiaims.player_state = conditional_antiaims.states.moving_crouch
        return
    end

    if is_crouching and is_not_moving then
        conditional_antiaims.player_state = conditional_antiaims.states.crouching
        return
    end

    if not is_crouching and not is_not_moving and not is_slowwalk then
        conditional_antiaims.player_state = conditional_antiaims.states.moving
        return
    end

    conditional_antiaims.player_state = conditional_antiaims.states.unknown
end

conditional_antiaims.manual_yaws = {
    ["Forward"] = 180,
    ["Backward"] = 0,
    ["Left"] = -90,
    ["Right"] = 90
}

conditional_antiaims.is_manuals = function()
    local base = ui_handler.elements["aa"]["manuals"]
    return base ~= "Disabled", base
end

conditional_antiaims.round_end = false

events.round_end:set(function()
    conditional_antiaims.round_end = true
end)

events.round_start:set(function()
    conditional_antiaims.round_end = false
end)

conditional_antiaims.disablers = function(parameter)
    local rules = entity.get_game_rules()

    if rules == nil then
        return false
    end

    local players = entity.get_players(true, false)

    if players == nil then
        return false
    end

    if parameter == "Warmup" and rules.m_bWarmupPeriod or parameter == "Dormant" and #players == 0 or parameter == "Round End" and conditional_antiaims.round_end then
        return true
    else
        return false
    end
end

conditional_antiaims.set_yaw_base = function(cmd)
    if not ui_handler.elements["aa"]["enable"] then
        return
    end
    
    local is_manuals, manual_yaw = conditional_antiaims.is_manuals()

    local is_predefined = conditional_antiaims.manual_yaws[manual_yaw]

    local new_config = {}
    if ui_handler.elements["aa"]["disablers"]["On Warmup"] and conditional_antiaims.disablers("Warmup") or ui_handler.elements["aa"]["disablers"]["On Dormant"] and conditional_antiaims.disablers("Dormant") or ui_handler.elements["aa"]["disablers"]["On Round End"] and conditional_antiaims.disablers("Round End") then
        new_config.pitch = "Disabled"
        new_config.yaw_offset = 0
        new_config.yaw_base = "Local View"
        new_config.yaw = "Disabled"
        new_config.freestanding = false
        new_config.body_yaw = false
    elseif antiaim_on_use.enabled then
        new_config.pitch = "Disabled"
        new_config.yaw_offset = 180
        new_config.yaw_base = "Local View"
        new_config.yaw = "Backward"
        new_config.freestanding = false   
    elseif edge_yaw.is_edging then
        new_config.yaw_offset = edge_yaw.angle
        new_config.yaw_base = "Local View"
        new_config.yaw = "Backward"
        new_config.freestanding = false      
    elseif is_manuals then

        if ui_handler.elements["aa"]["helpers"]["Static Manual Yaw"] and (manual_yaw == "Freestanding" or manual_yaw == "Left" or manual_yaw == "Right") then
            new_config.yaw_modifier = "Disabled"
            new_config.body_yaw_freestanding = "Peek Fake"
        end

        if is_predefined then
            new_config.yaw_offset = is_predefined
        else
            new_config.yaw_offset = 0
        end

        if manual_yaw == "At Target" then
            new_config.yaw_base = "At Target"
        else
            new_config.yaw_base = "Local View"
        end

        new_config.yaw = "Backward"
        new_config.freestanding = (manual_yaw == "Freestanding")
        new_config.body_yaw_options = {}
    end

    if ui_handler.elements["aa"]["helpers"]["Avoid-Backstab"] then
        new_config.yaw_backstab = true
    else
        new_config.yaw_backstab = false
    end

    if ui_handler.elements["aa"]["helpers"]["Static Fakelags Yaw"] and not neverlose_refs.doubletap:get() and not neverlose_refs.hideshots:get() then
        if is_predefined then
            new_config.yaw_offset = is_predefined
        else
            new_config.yaw_offset = 0
        end
        new_config.yaw_modifier = "Disabled"
        new_config.body_yaw_freestanding = "Off"
        new_config.lby_mode = "Opposite"
        new_config.body_yaw_options = {}
        new_config.right_limit = 60
        new_config.left_limit = 60
    end

    for k, v in pairs(new_config) do
        neverlose_refs.override(k, v)
    end

end

events.createmove:set(conditional_antiaims.update_player_state)

menu.switch(ui_handler.groups_name.antiaim.general, "Enable Anti-Aim")("aa", "enable", true)

menu.switch(ui_handler.groups_name.antiaim.general, "Edge Yaw")("aa", "edge_yaw", true, function()
    return ui_handler.elements["aa"]["enable"]
end)

menu.switch(ui_handler.groups_name.antiaim.general, defines.colored_text({ui_handler.get_icon("exclamation-circle"), colors.link_active}, {" Anim. Corrections"}))("aa", "anim_breakers", true, function()
    return ui_handler.elements["aa"]["enable"]
end)(function(group)
    menu.selectable(group, "Options", {"Static Legs", "High Pitch", "Move Lean"})("aa", "anim_breakers_additional", true, function()
        return ui_handler.elements["aa"]["anim_breakers"]
    end)

    menu.combo(group, "Leg Movement", {"Default", "Static", "Walking"})("aa", "static_legs", true, function()
        return ui_handler.elements["aa"]["anim_breakers"]
    end)

end)

menu.selectable(ui_handler.groups_name.antiaim.general, "Anti-Aim Disablers", {"On Warmup", "On Dormant", "On Round End"})("aa", "disablers", true, function()
    return ui_handler.elements["aa"]["enable"]
end)

menu.selectable(ui_handler.groups_name.antiaim.general, "Anti-Aim Helpers", {"Anti-Aim on Use", "Avoid-Backstab", "Fast Ladder Move", "Static Manual Yaw", "Static Fakelags Yaw"})("aa", "helpers", true, function()
    return ui_handler.elements["aa"]["enable"]
end)

menu.combo(ui_handler.groups_name.antiaim.general, "Manual Yaw", {"Disabled", "Forward", "Backward", "Left", "Right", "At Target", "Freestanding"})("aa", "manuals", true, function()
    return ui_handler.elements["aa"]["enable"]
end)

menu.combo(ui_handler.groups_name.antiaim.builder, "Condition", {"Loading..."})("aa", "condition_combo", true, function()
    return ui_handler.elements["aa"]["enable"]
end)

conditional_antiaims.conditions = {}
conditional_antiaims.condition_names = {}
conditional_antiaims.create_ui = function(name, idx)
    local current_condition = {}
    local menu_group = ui_handler.groups_name.antiaim.builder
    local name_unique = "\aFFFFFF00" .. name
    local itemname_start = "conditions_" .. name .. "_"
    local yaw_modifiers = {"Disabled", "Center", "Offset", "Oneway"}

    local condition_fn = function()
        return ui_handler.elements["aa"]["enable"] and ui_handler.elements["aa"]["condition_combo"] == name
    end

    if name ~= "Shared" then
        current_condition.switch = menu.switch(menu_group, "Override " .. name)("aa", itemname_start .. "override", true, condition_fn)
    end

    current_condition.pitch = menu.combo(menu_group, neverlose_refs.pitch:name() .. name_unique, neverlose_refs.pitch:list())("aa", itemname_start .. "pitch", true, condition_fn)
    current_condition.yaw = menu.combo(menu_group, neverlose_refs.yaw:name() .. name_unique, neverlose_refs.yaw:list())("aa", itemname_start .. "yaw", true, condition_fn)(function(group)
        current_condition.left_yaw_offset = menu.slider(group, "Left " .. neverlose_refs.yaw_offset:name() .. name_unique, -180, 180, 0)("aa", itemname_start .. "left_yaw_offset")
        current_condition.right_yaw_offset = menu.slider(group, "Right " .. neverlose_refs.yaw_offset:name() .. name_unique, -180, 180, 0)("aa", itemname_start .. "right_yaw_offset")
    end)

    current_condition.yaw_modifier = menu.combo(menu_group, neverlose_refs.yaw_modifier:name() .. name_unique, yaw_modifiers)("aa", itemname_start .. "yaw_modifier", true, condition_fn)(function(group)
        current_condition.yaw_modifier_offset = menu.slider(group, neverlose_refs.yaw_modifier_offset:name() .. name_unique, -180, 180, 0)("aa", itemname_start .. "yaw_modifier_offset", true, function()
            return ui_handler.elements["aa"][itemname_start .. "yaw_modifier"] ~= "Oneway"
        end)
        current_condition.yaw_modifier_offset_way = menu.slider(group, neverlose_refs.yaw_modifier_offset:name() .. name_unique .. "way", -180, 180, 0)("aa", itemname_start .. "yaw_modifier_offset_way", true, function()
            return ui_handler.elements["aa"][itemname_start .. "yaw_modifier"] == "Oneway"
        end)
    end)

    current_condition.body_yaw = menu.switch(menu_group, neverlose_refs.body_yaw:name() .. name_unique, true)("aa", itemname_start .. "body_yaw", true, condition_fn)(function(group)
        current_condition.left_limit = menu.slider(group, neverlose_refs.left_limit:name() .. name_unique, 0, 60, 60)("aa", itemname_start .. "left_limit", true)
        current_condition.right_limit = menu.slider(group, neverlose_refs.right_limit:name() .. name_unique, 0, 60, 60)("aa", itemname_start .. "right_limit", true)
        current_condition.body_yaw_options = menu.selectable(group, neverlose_refs.body_yaw_options:name() .. name_unique, neverlose_refs.body_yaw_options:list())("aa", itemname_start .. "body_yaw_options", true)
        current_condition.body_yaw_freestanding = menu.combo(group, neverlose_refs.body_yaw_freestanding:name() .. name_unique, neverlose_refs.body_yaw_freestanding:list())("aa", itemname_start .. "body_yaw_freestanding", true)
    end)

    current_condition.fakelag = menu.switch(menu_group, "Fake Lag" .. name_unique, true)("aa", itemname_start .. "fakelag", true, condition_fn)(function(group)
        current_condition.fakelag_limit = menu.slider(group, neverlose_refs.fakelag_limit:name() .. name_unique, 1, 15, 14)("aa", itemname_start .. "fakelag_limit", true)
        current_condition.fakelag_var = menu.slider(group, neverlose_refs.fakelag_var:name() .. name_unique, 1, 15, 14)("aa", itemname_start .. "fakelag_var", true)
    end)

    for k, v in pairs(current_condition) do
        if type(v) == "function" then
            current_condition[k] = current_condition[k]()
        end
    end

    return current_condition
end

defines.menu_combo_sanitizer = function(tbl)
    local tmp = {}

    for k, v in pairs(tbl) do
        table.insert(tmp, k)
    end

    return tmp
end

conditional_antiaims.set_ui = safecall("set_ui", true, function(new_config)
    for k, v in pairs(new_config) do
        local new_val = v
        if type(v) == "table" then
            new_val = defines.menu_combo_sanitizer(new_val)
        end
        neverlose_refs.override(k, new_val)
    end
end)

conditional_antiaims.get_cond_values = function(idx)
    
    local cond_tbl = conditional_antiaims.conditions[idx]
    if cond_tbl == nil then
        return
    end

    local new_config = {}

    for k, v in pairs(cond_tbl.ui) do
        local tbl_name = "conditions_" .. cond_tbl.name .. "_"
        new_config[k] = ui_handler.elements["aa"][tbl_name .. k]
    end

    return new_config
end

conditional_antiaims.get_active_idx = function()
    for k, v in ipairs(conditional_antiaims.conditions) do
        if k ~= 1 and v.condition() and v.ui.switch:get() --[[пихуй]] then
            return k
        end
    end

    return 1
end

conditional_antiaims.get_active_condition = function(idx, element)
    local cond_tbl = conditional_antiaims.conditions[idx]
    if cond_tbl == nil then
        return
    end

    local tbl_name = "conditions_" .. cond_tbl.name .. "_"
    return ui_handler.elements["aa"][tbl_name .. element]
end

conditional_antiaims.current_side = false
conditional_antiaims.desync_delta = 0

conditional_antiaims.get_desync_delta = function()
    local player = entity.get_local_player()

    if player == nil then
        return
    end

    conditional_antiaims.desync_delta = math.normalize_yaw(player.m_flPoseParameter[11] * 120 - 60) / 2
end

conditional_antiaims.get_desync_side = function()
    conditional_antiaims.current_side = conditional_antiaims.desync_delta < 0
end

conditional_antiaims.set_yaw_right_left = safecall("set yaw right left", true, function(new_config)
    local desync_side = conditional_antiaims.current_side
    new_config.yaw_offset = desync_side and new_config.right_yaw_offset or new_config.left_yaw_offset
end)

conditional_antiaims.new_meta_antiaims = safecall("new_meta", true, function(new_config)
    local current_condition = conditional_antiaims.get_active_idx()

    local value = new_config.yaw_modifier_offset_way

    if new_config.yaw_modifier == "Oneway" then
        if globals.tickcount % 3 == 1 then
            value = 0
        else
            value = new_config.yaw_modifier_offset_way
        end

        new_config.yaw_modifier = "Center"
    else
        value = new_config.yaw_modifier_offset
    end

    new_config.yaw_modifier_offset = value 


end)

conditional_antiaims.handle_update = function(cmd)
    
    if cmd.choked_commands > 0 then
        return
    end

    conditional_antiaims.get_desync_delta(cmd)
    conditional_antiaims.get_desync_side(cmd)

    local current_condition = conditional_antiaims.get_active_idx()
    local new_config = conditional_antiaims.get_cond_values(current_condition)

    conditional_antiaims.set_yaw_right_left(new_config)
    conditional_antiaims.new_meta_antiaims(new_config)
    conditional_antiaims.set_ui(new_config)
end

conditional_antiaims.create_condition = function(name, condition)

    local cond_idx = #conditional_antiaims.conditions + 1
    conditional_antiaims.conditions[cond_idx] = {
        name = name,
        condition = condition,
    }

    conditional_antiaims.conditions[cond_idx].ui = conditional_antiaims.create_ui(name, cond_idx)

    table.insert(conditional_antiaims.condition_names, name)

    ui_handler.refs["aa"]["condition_combo"].ref:update(conditional_antiaims.condition_names)
end

fast_ladder.handle = function(cmd)
    if not ui_handler.elements["aa"]["enable"] then
        return
    end

    if not ui_handler.elements["aa"]["helpers"]["Fast Ladder Move"] then
        return
    end

    if createmove.shared_data.movetype ~= 9 then
        return
    end

    local player = entity.get_local_player()

    if cmd.sidemove == 0 then
        cmd.view_angles.y = cmd.view_angles.y + 45
    end

    if cmd.in_forward and cmd.sidemove < 0 then
        cmd.view_angles.y = cmd.view_angles.y + 90
    end

    if cmd.in_back and cmd.sidemove > 0 then
        cmd.view_angles.y = cmd.view_angles.y + 90
    end


    cmd.in_moveleft = cmd.in_back
    cmd.in_moveright = cmd.in_forward

    if cmd.view_angles.x < 0 then
        cmd.view_angles.x = -45
    end
end

defines.reverse_table = function(tbl)
    local tmp = {}

    for k, v in pairs(tbl) do
        tmp[v] = k
    end

    return tmp
end

antiaim_on_use.enabled = false
antiaim_on_use.handle = function(cmd)

    antiaim_on_use.enabled = false

    if not ui_handler.elements["aa"]["enable"] then
        return
    end
    

    if not cmd.in_use or not ui_handler.elements["aa"]["helpers"]["Anti-Aim on Use"] then
        return
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local active_weapon = player:get_player_weapon()

    if active_weapon == nil then
        return
    end

    local is_bomb_in_hand = active_weapon:get_classname() == "CC4"

    local is_in_bombzone = player.m_bInBombZone
    local is_planting = is_in_bombzone and is_bomb_in_hand

    local planted_c4_table = entity.get_entities("CPlantedC4")
    local is_c4_planted = #planted_c4_table > 0
    local bomb_distance = 100

    if is_c4_planted then
        local c4_entity = planted_c4_table[1]

        local c4_origin = c4_entity:get_origin()
        local my_origin = player:get_origin()

        bomb_distance = my_origin:dist(c4_origin)
    end

    local is_defusing = bomb_distance < 62 and player.m_iTeamNum == 3

    if is_defusing then
        return
    end

    local camera_angles = render.camera_angles()

    local eye_position = player:get_eye_position()
    local forward_vector = vector():angles(camera_angles.x, camera_angles.y)

    local trace_end = eye_position + forward_vector * 100

    local trace = utils.trace_line(eye_position, trace_end, player, 0x4600400B)

    local is_using = cmd.in_use
    if trace and trace.fraction < 1 and trace.entity then
        local class_name = trace.entity:get_classname()
        is_using = class_name ~= "CWorld" and class_name ~= "CFuncBrush" and class_name ~= "CCSPlayer"
    elseif trace.fraction == 1 then
       is_using = false 
    end

    if not is_using and not is_planting then
        cmd.in_use = false
        antiaim_on_use.enabled = true
    end

end

conditional_antiaims.create_condition("Shared", function()
    return true
end)

conditional_antiaims.create_condition("Standing", function()
    return conditional_antiaims.player_state == conditional_antiaims.states.standing
end)


conditional_antiaims.create_condition("Moving", function()
    return conditional_antiaims.player_state == conditional_antiaims.states.moving
end)

conditional_antiaims.create_condition("Slowwalk", function()
    return conditional_antiaims.player_state == conditional_antiaims.states.slowwalk
end)

conditional_antiaims.create_condition("Crouch", function()
    return conditional_antiaims.player_state == conditional_antiaims.states.crouching
end)

conditional_antiaims.create_condition("Crouch & Move", function()
    return conditional_antiaims.player_state == conditional_antiaims.states.moving_crouch
end)

conditional_antiaims.create_condition("Air", function()
    return conditional_antiaims.player_state == conditional_antiaims.states.air
end)

conditional_antiaims.create_condition("Air & Crouch", function()
    return conditional_antiaims.player_state == conditional_antiaims.states.air_crouch
end)

edge_yaw.is_edging = false
edge_yaw.angle = 0
edge_yaw.vecTraceStart = vector(0, 0, 0)

edge_yaw.on_edge = function(cmd)

    edge_yaw.is_edging = false
    if conditional_antiaims.player_state == conditional_antiaims.states.air then
        return
    end

    if not ui_handler.elements["aa"]["enable"] then
        return
    end
    

    if not ui_handler.elements["aa"]["edge_yaw"] then
        return
    end

    local player = entity.get_local_player()

    if cmd.send_packet then 
        edge_yaw.vecTraceStart = player:get_eye_position() 
    end

    local aTraceEnd = {}

    local angViewAngles = render.camera_angles()
    local distances = {}


    for flYaw = 18, 360, 18 do
        flYaw = math.normalize_yaw(flYaw)

        local vecTraceEnd = edge_yaw.vecTraceStart + vector():angles(0, flYaw) * 198

        local traceInfo = utils.trace_line(edge_yaw.vecTraceStart, vecTraceEnd, player, 0x46004003)
        table.insert(distances, edge_yaw.vecTraceStart:dist(traceInfo.end_pos))

        local flFraction = traceInfo.fraction
        local pEntity = traceInfo.entity

        if pEntity and pEntity:get_classname() == 'CWorld' and flFraction < 0.3 then
            aTraceEnd[#aTraceEnd+1] = {
                vecTraceEnd = vecTraceEnd,
                flYaw = flYaw
            }

        end
    end

    table.sort(distances)

    if distances[1] > 30 then
        return
    end

    table.sort(aTraceEnd, function(a, b)
        return a.flYaw < b.flYaw
    end)

    table.remove(aTraceEnd, #aTraceEnd)

    local angEdge

    if #aTraceEnd >= 3 then
        local vecTraceCenter = aTraceEnd[1].vecTraceEnd:lerp(aTraceEnd[#aTraceEnd].vecTraceEnd, 0.5)

        angEdge = (edge_yaw.vecTraceStart - vecTraceCenter):angles()
    end

    if angEdge then

        local flYaw = angViewAngles.y
        local flEdgeYaw = angEdge.y


        local flDiff = math.normalize_yaw(flEdgeYaw - flYaw)
        if math.abs(flDiff) < 90 then 
            flDiff = 0
            flYaw = math.normalize_yaw(flEdgeYaw + 180)
        end

        local flNewYaw = -flYaw
        flNewYaw = math.normalize_yaw(flNewYaw + flEdgeYaw + flDiff + 180)

        --[[local flEdgeYaw = angEdge.y
        local flYaw = render.camera_angles().y
        local flDiff = math.normalize(flEdgeYaw - flYaw - 180)

        if math.abs(math.normalize(flDiff - 180)) < 90 then
            flDiff = 0
            flEdgeYaw = flYaw
        end

        flEdgeYaw = math.normalize(flEdgeYaw + flDiff)

        cmd.view_angles.y = flEdgeYaw]]

        edge_yaw.angle = flNewYaw
        edge_yaw.is_edging = true
    end

end

draggables.menu = {}
draggables.items = {"watermark", "keybinds", "spectators", "speed_warning"}
for k, v in pairs(draggables.items) do
    draggables.menu[v] = 
    {
        pos_x = menu.slider(ui_handler.groups_name.antiaim.general, v.."_pos_x", 0, defines.screen_size.x, math.floor(0.1*defines.screen_size.x))("drag", v.."_pos_x", true, function()
            return false
        end),
        pos_y = menu.slider(ui_handler.groups_name.antiaim.general, v.."_pos_y", 0, defines.screen_size.y, math.floor(0.1*k*defines.screen_size.y))("drag", v.."_pos_y", true, function()
            return false
        end),
    }
end

draggables.adjust = function()
    local default_screen_size = vector(2560, 1440)
    local dpi_scale = defines.screen_size/default_screen_size
    for k, item in pairs(draggables.items) do
        ui_handler.refs["drag"][item .. "_pos_x"].ref:set(ui_handler.elements["drag"][item .. "_pos_x"]*dpi_scale.x)
        ui_handler.refs["drag"][item .. "_pos_x"].ref:set(ui_handler.elements["drag"][item .. "_pos_x"]*dpi_scale.y)
    end
end

draggables.in_bounds = function(vec1, vec2)
    local mouse_pos = ui.get_mouse_position()
    return mouse_pos.x >= vec1.x and mouse_pos.x <= vec2.x and mouse_pos.y >= vec1.y and mouse_pos.y <= vec2.y 
end

draggables.drag = {}
draggables.current_drugging_item = nil
draggables.hovered_something = false
draggables.drag_handle = function(x, y, w, h, item, alpha)
    if alpha == nil then
        alpha = 0
    end

    if draggables.drag[item] == nil then
        draggables.drag[item] = {}
        draggables.drag[item].drag_position = vector(0,0)
        draggables.drag[item].is_dragging = false
    end

    if draggables.in_bounds(vector(x, y), vector(x + w, y + h)) and draggables.in_bounds(vector(0, 0), vector(defines.screen_size.x, defines.screen_size.y)) then
        draggables.hovered_something = true
        if common.is_button_down(0x01) and draggables.drag[item].is_dragging == false and (draggables.current_drugging_item == nil or draggables.current_drugging_item == item) then
            draggables.drag[item].is_dragging = true
            draggables.current_drugging_item = item
            draggables.drag[item].drag_position = vector(x - ui.get_mouse_position().x, y - ui.get_mouse_position().y)
        end
    end

    if not draggables.in_bounds(vector(0, 0), vector(defines.screen_size.x, defines.screen_size.y)) then
        draggables.drag[item].is_dragging = false
    end

    if not common.is_button_down(0x01) then
        draggables.drag[item].is_dragging = false
        draggables.current_drugging_item = nil
    end

    if draggables.drag[item].is_dragging and ui.get_alpha() > 0 then
        ui_handler.refs["drag"][item .. "_pos_x"].ref:set(ui.get_mouse_position().x + draggables.drag[item].drag_position.x)
        ui_handler.refs["drag"][item .. "_pos_y"].ref:set(ui.get_mouse_position().y + draggables.drag[item].drag_position.y)
    end

    if alpha > 0 then
        render.rect_outline(vector(x, y), vector(x + w, y + h), color(255, 255, 255, ui.get_alpha()/2*alpha), 1, 4)
    end
end

events.mouse_input:set(function()
    if (draggables.hovered_something or draggables.current_drugging_item) and ui.get_alpha() > 0 then
        return false
    end
end)

visuals.render_solus_rect = function(x, y, w, h, clr, background_clr, shadow_clr, shadow, rounding, blur, pulse)
    shadow = pulse and (shadow or 50)*visuals.shadow_frac or (shadow or 50)
    if shadow >= 1 then
        render.shadow(vector(x, y), vector(x + w, y + h), shadow_clr, shadow, 0, rounding)
    end

    --render.push_clip_rect(vector(x - 2, y), vector(x + w + 2, y + h/5))
    --render.rect_outline(vector(x - 1, y), vector(x + w + 1, y + h), clr, 1, rounding)
    
    local alpha_trans = background_clr:override("a", 0)
    local white_gradient = background_clr:override("a", background_clr.a)
    --render.pop_clip_rect()
    
    local gradient_pos = {
        vector(x - 1, y),
        vector(x + w + 1, y + h)
    }

    local zero_alpha_white = clr:override("a", 0)
    render.gradient(gradient_pos[1] - 1, gradient_pos[2] + 1, clr, clr, zero_alpha_white, zero_alpha_white, rounding)

    if blur then
        render.gradient(gradient_pos[1], gradient_pos[2], white_gradient, white_gradient, alpha_trans, alpha_trans, rounding)
        render.blur(vector(x, y + 1), vector(x + w, y + h), 1, background_clr.a/255, rounding)
        render.rect(vector(x, y + 1), vector(x + w, y + h), background_clr:override("a", background_clr.a/1.5), rounding)
    else
        render.gradient(gradient_pos[1], gradient_pos[2], white_gradient, white_gradient, alpha_trans, alpha_trans, rounding)
        render.rect(vector(x, y + 1), vector(x + w, y + h), background_clr, rounding)
    end
end

visuals.render_skeet_rect = function(x, y, w, h, clr, shadow_clr, shadow, pulse)
    local adaptive = {
        color(20, 20, 20, 255),
        color(30, 30, 30, 255),
        color(40, 40, 40, 255),
        color(60, 60, 60, 255),
    }
    shadow = pulse and (shadow or 50)*visuals.shadow_frac or (shadow or 50)
    if shadow >= 1 then
        render.shadow(vector(x, y), vector(x + w, y + h), shadow_clr, shadow, 0)
    end

    render.rect_outline(vector(x - 6, y - 6), vector(x + w + 6, y + h + 6), adaptive[2]:override("a", clr.a), 1)
    render.rect_outline(vector(x - 5, y - 5), vector(x + w + 5, y + h + 5), adaptive[4]:override("a", clr.a), 1)
    render.rect_outline(vector(x - 4, y - 4), vector(x + w + 4, y + h + 4), adaptive[3]:override("a", clr.a), 1)
    render.rect_outline(vector(x - 3, y - 3), vector(x + w + 3, y + h + 3), adaptive[3]:override("a", clr.a), 3)
    render.rect_outline(vector(x - 1, y - 1), vector(x + w + 1, y + h + 1), adaptive[4]:override("a", clr.a), 2)
    render.rect(vector(x, y), vector(x + w, y + h), adaptive[1]:override("a", clr.a))
    if ui_handler.elements["features"]["solus_settings_position"] ~= "None" then
        if ui_handler.elements["features"]["solus_settings_header"] == "Gradient" then
            if ui_handler.elements["features"]["solus_settings_position"] == "Top" then
                render.gradient(vector(x, y), vector(x + w/2, y + 1),
                    color(55, 177, 218, 255):override("a", clr.a), color(201, 84, 205, 255):override("a", clr.a), color(55, 177, 218, 255):override("a", clr.a), color(201, 84, 205, 255):override("a", clr.a)
                )
                render.gradient(vector(x + w/2, y), vector(x + w, y + 1),
                    color(201, 84, 205, 255):override("a", clr.a), color(204, 207, 53, 255):override("a", clr.a), color(201, 84, 205, 255):override("a", clr.a), color(204, 207, 53, 255):override("a", clr.a)
                )
            else
                render.gradient(vector(x, y + h), vector(x + w/2, y + h - 1),
                    color(55, 177, 218, 255):override("a", clr.a), color(201, 84, 205, 255):override("a", clr.a), color(55, 177, 218, 255):override("a", clr.a), color(201, 84, 205, 255):override("a", clr.a)
                )
                render.gradient(vector(x + w/2, y + h), vector(x + w, y + h - 1),
                    color(201, 84, 205, 255):override("a", clr.a), color(204, 207, 53, 255):override("a", clr.a), color(201, 84, 205, 255):override("a", clr.a), color(204, 207, 53, 255):override("a", clr.a)
                )
            end
        else
            if ui_handler.elements["features"]["solus_settings_position"] == "Top" then
                render.rect(vector(x, y), vector(x + w, y + 1), clr:override("a", clr.a))
            else
                render.rect(vector(x, y + h), vector(x + w, y + h - 1), clr:override("a", clr.a), 0, true)
            end
        end
    end
end

indicators.verdana_bold = render.load_font("Verdana", 11, "bda")
indicators.verdana17 = render.load_font("Verdana", 17, "bdau")
indicators.verdana30 = render.load_font("Verdana", 34, "au")
indicators.antiaim_states = {
    "T-90",
    "RUNNING",
    "+BOSSAA+",
    "CROUCH",
    "CROUCH+M",
    "AEROBIC",
    "AEROBIC+C",
}
indicators.handle = function()
    --render.rect(vector(0, 0), defines.screen_size, color(0, 0, 0, 255))
    local enabled = ui_handler.elements["features"]["screen_indicators"]

    local screen_indicators_additional = ui_handler.elements["features"]["screen_indicators_additional"]

    local manual_arrows =   screen_indicators_additional["Manual Arrows"]
    local desync_line =     screen_indicators_additional["Desync Line"]
    local lua_build =       screen_indicators_additional["Lua Build"]
    local lua_name =        screen_indicators_additional["Lua Name"]
    local antiaim_state =   screen_indicators_additional["Anti-Aim State"]
    local keybinds =        screen_indicators_additional["Keybinds"]

    local screen_indicators_logo = ui_handler.elements["features"]["screen_indicators_logo"]
    local manual_arrows_style = ui_handler.elements["features"]["screen_indicators_arrows"]
    local manual_arrows_dst = ui_handler.elements["features"]["screen_indicators_arrows_dst"]
    local manual_arrows_color = ui_handler.elements["features"]["screen_indicators_arrows_color"]
    local antiaim_state_name = antiaim_on_use.enabled and "180°" or conditional_antiaims.disablers("Dormant") and "SEARCH" or indicators.antiaim_states[conditional_antiaims.player_state]
    local glow_strength = ui_handler.elements["features"]["screen_indicators_glow"]/2
    local first_color = ui_handler.elements["features"]["screen_indicators_first"]
    local second_color = ui_handler.elements["features"]["screen_indicators_second"]

    local anim = {}
    anim.main = animations.new("indicators_main", enabled and 255 or 0)

    if anim.main < 1 then
        return
    end

    local player = entity.get_local_player()

    if player == nil or not player:is_alive() then
        return
    end

    local add_y = 20

    anim.manual_arrows = {}

    local max_alpha = createmove.shared_data.scoped and 40 or 255
    anim.manual_arrows.alpha1 = animations.new("manual_arrows_alpha1", enabled and manual_arrows and manual_arrows_style == "Simple" and max_alpha or 0, 0.04)
    if anim.manual_arrows.alpha1 > 1 then
        render.text(indicators.verdana17, vector(defines.screen_size.x/2 - 10 - manual_arrows_dst, defines.screen_size.y/2 - 11),         
        ui_handler.elements["aa"]["manuals"] == "Left" and manual_arrows_color:override("a", anim.manual_arrows.alpha1) or 
        color(150, 150, 150, 255):override("a", anim.manual_arrows.alpha1/255*manual_arrows_color.a), nil, "<")
        
        render.text(indicators.verdana17, vector(defines.screen_size.x/2 + manual_arrows_dst, defines.screen_size.y/2 - 11), 
        ui_handler.elements["aa"]["manuals"] == "Right" and manual_arrows_color:override("a", anim.manual_arrows.alpha1) or 
        color(150, 150, 150, 255):override("a", anim.manual_arrows.alpha1/255*manual_arrows_color.a), nil, ">")
    end

    anim.manual_arrows.alpha2 = animations.new("manual_arrows_alpha2", enabled and manual_arrows and manual_arrows_style == "TeamSkeet" and max_alpha or 0, 0.04)
    if anim.manual_arrows.alpha2 > 1 then
        render.rect(
            vector((defines.screen_size.x/2) - manual_arrows_dst - 12, (defines.screen_size.y/2) - 10), 
            vector((defines.screen_size.x/2) - manual_arrows_dst - 10, (defines.screen_size.y/2) + 10), 
            conditional_antiaims.current_side and first_color:override("a", anim.manual_arrows.alpha2) or 
            color(0, 0, 0, 255):override("a", anim.manual_arrows.alpha2/255*manual_arrows_color.a), 
            0, true
        )
        render.rect(
            vector((defines.screen_size.x/2) + manual_arrows_dst + 12, (defines.screen_size.y/2) - 10), 
            vector((defines.screen_size.x/2) + manual_arrows_dst + 10, (defines.screen_size.y/2) + 10), 
            not conditional_antiaims.current_side and first_color:override("a", anim.manual_arrows.alpha2) or 
            color(0, 0, 0, 255):override("a", anim.manual_arrows.alpha2/255*manual_arrows_color.a), 
            0, true
        )
        render.poly(
            ui_handler.elements["aa"]["manuals"] == "Left" and manual_arrows_color:override("a", anim.manual_arrows.alpha2) or color(0, 0, 0, 255):override("a", anim.manual_arrows.alpha2/255*manual_arrows_color.a), 
            vector((defines.screen_size.x/2) - manual_arrows_dst - 13, (defines.screen_size.y/2) + 9),
            vector((defines.screen_size.x/2) - manual_arrows_dst - 26, (defines.screen_size.y/2)), 
            vector((defines.screen_size.x/2) - manual_arrows_dst - 13, (defines.screen_size.y/2) - 9)
        )
        render.poly(
            ui_handler.elements["aa"]["manuals"] == "Right" and manual_arrows_color:override("a", anim.manual_arrows.alpha2) or color(0, 0, 0, 255):override("a", anim.manual_arrows.alpha2/255*manual_arrows_color.a),
            vector((defines.screen_size.x/2) + manual_arrows_dst + 13, (defines.screen_size.y/2) - 9 ), 
            vector((defines.screen_size.x/2) + manual_arrows_dst + 26, (defines.screen_size.y/2)), 
            vector((defines.screen_size.x/2) + manual_arrows_dst + 13, (defines.screen_size.y/2) + 9)
        )
    end

    anim.manual_arrows = {}
    anim.manual_arrows.alpha3 = animations.new("manual_arrows_alpha3", enabled and manual_arrows and manual_arrows_style == "Branded" and max_alpha or 0, 0.04)
    if anim.manual_arrows.alpha3 > 1 then
        render.text(indicators.verdana30, vector(defines.screen_size.x/2 - 10 - manual_arrows_dst, defines.screen_size.y/2 - 21),         
        ui_handler.elements["aa"]["manuals"] == "Left" and manual_arrows_color:override("a", anim.manual_arrows.alpha3) or 
        color(150, 150, 150, 255):override("a", anim.manual_arrows.alpha3/255*manual_arrows_color.a), nil, "‹")
        
        render.text(indicators.verdana30, vector(defines.screen_size.x/2 + manual_arrows_dst, defines.screen_size.y/2 - 21), 
        ui_handler.elements["aa"]["manuals"] == "Right" and manual_arrows_color:override("a", anim.manual_arrows.alpha3) or 
        color(150, 150, 150, 255):override("a", anim.manual_arrows.alpha3/255*manual_arrows_color.a), nil, "›")
    end

    anim.desync_line = {}
    anim.desync_line.delta = animations.new("desync_line_delta", math.abs(math.min(60, player.m_flPoseParameter[11]*120 - 60))/2, 0.05)
    anim.desync_line.alpha = animations.new("desync_line_alpha", enabled and desync_line and anim.desync_line.delta > 3 and 255 or 0)
    anim.desync_line.move = animations.new("desync_line_move", createmove.shared_data.scoped and -render.measure_text(indicators.verdana_bold, nil, "drainyaw").x/2 - 10 or 0)
    if anim.desync_line.alpha > 1 then
        render.rect(            
            vector(defines.screen_size.x/2 - anim.desync_line.move - anim.desync_line.delta - 1, defines.screen_size.y/2 + add_y - 1),
            vector(defines.screen_size.x/2 - anim.desync_line.move + anim.desync_line.delta + 1, defines.screen_size.y/2 + add_y + 3),
            colors.black:override("a", anim.desync_line.alpha)
        )
        render.rect(            
            vector(defines.screen_size.x/2 - anim.desync_line.move - anim.desync_line.delta, defines.screen_size.y/2 + add_y),
            vector(defines.screen_size.x/2 - anim.desync_line.move + anim.desync_line.delta, defines.screen_size.y/2 + add_y + 2),
            first_color:override("a", anim.desync_line.alpha)
        )
        add_y = add_y + anim.desync_line.alpha/255*5
    end

    anim.lua_build = {}
    anim.lua_build.alpha = animations.new("lua_build_alpha", enabled and lua_build and (globals.realtime%1.5 > 0.75 and 255 or 40) or 0, 0.04)
    anim.lua_build.adding = animations.new("lua_build_adding", enabled and lua_build and 10 or 0)
    anim.lua_build.move = animations.new("lua_build_move", createmove.shared_data.scoped and -render.measure_text(2, nil, "ALPHA").x/1.2 or render.measure_text(2, nil, "ALPHA").x/2)
    if anim.lua_build.alpha > 1 then
        render.text(2, vector(defines.screen_size.x/2 - anim.lua_build.move, defines.screen_size.y/2 + add_y), first_color:override("a", anim.lua_build.alpha), nil, "ALPHA")
        add_y = add_y + anim.lua_build.adding
    end

    anim.lua_name = {}
    anim.lua_name.alpha = animations.new("lua_name_alpha", enabled and lua_name and 255 or 0)
    anim.lua_name.move = animations.new("lua_name_move", createmove.shared_data.scoped and -10 or render.measure_text(indicators.verdana_bold, nil, "drainyaw").x/2)
    anim.lua_name.animated_text = colors.gradient_text("drainyaw", 1.7, {first_color, second_color})
    anim.lua_name.text = {
        ["Static"] = defines.colored_text({"drainyaw", first_color}),
        ["Multi-Color"] = defines.colored_text({"drai", first_color}, {"nyaw", second_color}), 
        ["Gradient"] = gradient.text("drainyaw", false, {first_color, second_color}),
        ["Animated"] = anim.lua_name.animated_text:get_animated_text()
    }
    if anim.lua_name.alpha > 1 then
        render.shadow(
            vector(defines.screen_size.x/2 - anim.lua_name.move, defines.screen_size.y/2 + add_y + 7),
            vector(defines.screen_size.x/2 + render.measure_text(indicators.verdana_bold, nil, "drainyaw").x - anim.lua_name.move, defines.screen_size.y/2 + add_y + 7),
            first_color:override("a", anim.lua_name.alpha),
            glow_strength
        )
        render.text(indicators.verdana_bold, vector(defines.screen_size.x/2 - anim.lua_name.move, defines.screen_size.y/2 + add_y), colors.white:override("a", anim.lua_name.alpha), nil, anim.lua_name.text[screen_indicators_logo])
        anim.lua_name.animated_text:animate()
        add_y = add_y + anim.lua_name.alpha/255*10
    end

    anim.antiaim_state = {}
    anim.antiaim_state.alpha = animations.new("antiaim_state_alpha", enabled and antiaim_state and 255 or 0, 0.04)
    anim.antiaim_state.move = animations.new("antiaim_state_move", createmove.shared_data.scoped and -10 or render.measure_text(2, nil, antiaim_state_name).x/2)
    if anim.antiaim_state.alpha > 1 then
        render.text(2, vector(defines.screen_size.x/2 - anim.antiaim_state.move, defines.screen_size.y/2 + add_y), second_color:override("a", anim.antiaim_state.alpha), nil, antiaim_state_name)
        add_y = add_y + anim.antiaim_state.alpha/255*9
    end

    local binds = {
        {nil, neverlose_refs.doubletap:get_override() or neverlose_refs.doubletap:get()},
        {"HIDE", neverlose_refs.hideshots:get_override() or neverlose_refs.hideshots:get()},
        {"BODY", neverlose_refs.prefer_body:get_override() == "Force" or neverlose_refs.prefer_body:get() == "Force"},
        {"SAFE", neverlose_refs.prefer_safety:get_override() == "Force" or neverlose_refs.prefer_safety:get() == "Force"},
        {"AUTO", neverlose_refs.freestanding:get_override() or neverlose_refs.freestanding:get()},
        {"EDGE", edge_yaw.is_edging},
        {"DUCK", neverlose_refs.fake_duck:get_override() or neverlose_refs.fake_duck:get()},
        {"ROLL", neverlose_refs.extended_angles:get_override() or neverlose_refs.extended_angles:get()},
    }
    
    anim.binds = {}
    anim.exploit_charge = animations.new("exploit_charge", rage.exploit:get())
    for k, v in pairs(binds) do
        v[1] = v[1] or "DT\x20\x20\x20\x20\x20\x20\x20\x20"
        if anim.binds[v[1]] == nil then
            anim.binds[v[1]] = {}
            anim.binds[v[1]].move = 0
            anim.binds[v[1]].alpha = 0
        end

        anim.binds[v[1]].alpha = animations.new("indicators_alpha_" .. v[1], enabled and keybinds and v[2] and 255 or 0)
        anim.binds[v[1]].move = animations.new("indicators_move_" .. v[1], createmove.shared_data.scoped and -10 or render.measure_text(2, nil, v[1]).x/2)

        if anim.binds[v[1]].alpha > 1 then
            render.text(2, vector(defines.screen_size.x/2 - anim.binds[v[1]].move, defines.screen_size.y/2 + add_y), first_color:override("a", anim.binds[v[1]].alpha), nil, v[1])
            if v[1]:find("DT") then
                render.circle_outline(vector(defines.screen_size.x/2 - anim.binds[v[1]].move + 15, defines.screen_size.y/2 + add_y + 6), colors.white:override("a", anim.binds[v[1]].alpha), 4, 0, anim.exploit_charge, 1.5)
            end
            add_y = add_y + anim.binds[v[1]].alpha/255*9
        end
    end
end

menu.switch(ui_handler.groups_name.features.interface, defines.colored_text({ui_handler.get_icon("compass"), colors.link_active}, {" Elements"}))("features", "screen_indicators", true)(function(group)
    menu.selectable(group, "Settings", {"Manual Arrows", "Desync Line", "Lua Build", "Lua Name", "Anti-Aim State", "Keybinds"})("features", "screen_indicators_additional", true, function()
        return ui_handler.elements["features"]["screen_indicators"]
    end)
    
    menu.combo(group, "Logo Style", {"Static", "Multi-Color", "Gradient", "Animated"})("features", "screen_indicators_logo", true, function()
        return ui_handler.elements["features"]["screen_indicators"] and ui_handler.elements["features"]["screen_indicators_additional"]["Lua Name"]
    end)

    menu.combo(group, "Arrows Style", {"Branded", "Simple", "TeamSkeet"})("features", "screen_indicators_arrows", true, function()
        return ui_handler.elements["features"]["screen_indicators"] and ui_handler.elements["features"]["screen_indicators_additional"]["Manual Arrows"]
    end)

    menu.slider(group, "Arrows Dst", 30, 125, 111)("features", "screen_indicators_arrows_dst", true, function()
        return ui_handler.elements["features"]["screen_indicators"] and ui_handler.elements["features"]["screen_indicators_additional"]["Manual Arrows"]
    end)

    menu.color_picker(group, "Arrows Color")("features", "screen_indicators_arrows_color", true, function()
        return ui_handler.elements["features"]["screen_indicators"] and ui_handler.elements["features"]["screen_indicators_additional"]["Manual Arrows"]
    end)

    menu.slider(group, "Glow Strength", 0, 100, 75, 1, function(value) return value == 0 and "Off" or value.."%" end)("features", "screen_indicators_glow", true, function()
        return ui_handler.elements["features"]["screen_indicators"] and ui_handler.elements["features"]["screen_indicators_additional"]["Lua Name"]
    end)

    menu.color_picker(group, "First Color")("features", "screen_indicators_first", true, function()
        return ui_handler.elements["features"]["screen_indicators"] and (ui_handler.elements["features"]["screen_indicators_additional"]["Desync Line"] or ui_handler.elements["features"]["screen_indicators_additional"]["Lua Build"] or ui_handler.elements["features"]["screen_indicators_additional"]["Lua Name"] or ui_handler.elements["features"]["screen_indicators_additional"]["Keybinds"])
    end)

    menu.color_picker(group, "Second Color")("features", "screen_indicators_second", true, function()
        return ui_handler.elements["features"]["screen_indicators"] and (ui_handler.elements["features"]["screen_indicators_additional"]["Lua Name"] or ui_handler.elements["features"]["screen_indicators_additional"]["Anti-Aim State"])
    end)
end)

gamesense.spectators = function()
    if not ui_handler.elements["features"]["gamesense_indicators"] then
        return
    end

    if not ui_handler.elements["features"]["gamesense_indicators_spectators"] then
        return
    end

    local spectator = visuals.get_spectators()
    
    if spectator == nil then
        return
    end

    local x, y = defines.screen_size.x, 5
    local add_y = 0

    for k, v in pairs(spectator) do
        ts = render.measure_text(1, nil, v:get_name())
        render.text(1, vector(x - ts.x - 5, y + add_y), colors.white, nil, v:get_name())
        add_y = add_y + 16
    end
end

events.item_purchase:set(function(e)
    if not ui_handler.elements["features"]["gamesense_indicators"] then
        return
    end

    if not ui_handler.elements["features"]["gamesense_indicators_purchace"] then
        return
    end

    local entity = entity.get(e.userid, true)
    
    local hit_color = "\aA3E908"-- .. ui_handler.elements["features"]["aimbot_logger_hit_color"]:to_hex():sub(0, 6)

    local name = entity:get_name() or "?"
    local wpn = e.weapon or "weapon_unknown"
    local weapon = wpn

    if weapon == "unknown" then
        return
    end

    print_raw((hit_color.."[drainyaw]\aFFFFFF %s bought %s"):format(name, weapon))
    print_dev(("%s bought %s"):format(name, weapon))
end)

local c4_info =
{
    last_site = "",
    last_beep = 0,
    last_beep_diff = 1,

    planting_site = nil,
    planting_started_at = nil,
    planting_player = nil,
    planting_time = 3.125,

    mp_c4timer = cvar.mp_c4timer,

    reset = function(self, e)
        self.planting_site = nil
        self.planting_player = nil
    end,

    beep = function(self, c)
        self.last_beep_diff = math.clamp(globals.curtime - self.last_beep, 0, 1)
        self.last_beep = globals.curtime
    end,

    begin_plant = function(self, e)
        local player_resource = entity.get_player_resource()

        if not player_resource then
            return
        end

        local center_a, center_b =
            player_resource.m_bombsiteCenterA,
            player_resource.m_bombsiteCenterB

        local site = entity.get(e.site)

        if not site then
            return
        end

        local mins, maxs =
            site.m_vecMins, site.m_vecMaxs

        local center = mins:lerp(maxs, 0.5)
        local distance_a, distance_b = center:distsqr(center_a), center:distsqr(center_b)

        self.planting_site = distance_b > distance_a and "A" or "B"
        self.planting_started_at = globals.curtime
        self.planting_player = entity.get(e.userid, true)

        self.last_site = self.planting_site
    end,

    damage_apply_armor = function(self, damage, armor_value)
        local armor_ratio = 0.5
        local armor_bonus = 0.5

        if armor_value > 0 then
            local flNew = damage * armor_ratio
            local flArmor = (damage - flNew) * armor_bonus

            if flArmor > armor_value then
                flArmor = armor_value * (1 / armor_bonus)
                flNew = damage - flArmor
            end

            damage = flNew
        end

        return damage
    end,

    calculate_damage = function(self, from_player, other, armor_value)
        local eye_position = from_player:get_eye_position()
        local distance = eye_position:dist(other:get_origin())

        local damage, fatal = 500, false
        local radius = damage * 3.5

        damage = damage * math.exp(-((distance * distance) / ((radius * 2 / 3) * (radius / 3))))
        damage = math.floor(self:damage_apply_armor(math.max(damage, 0), armor_value))

        return damage
    end,

    get_active_bomb = function(self, from_player)
        local curtime = globals.curtime
        local from_player = from_player or entity.get_local_player()

        local armor_value = from_player.m_ArmorValue
        local health = from_player.m_iHealth

        if self.planting_player then
            local plant_percentage = (curtime - self.planting_started_at) / self.planting_time

            if plant_percentage > 0 and plant_percentage < 1 then
                local game_rules = entity.get_game_rules()

                if game_rules.m_bBombPlanted == 1 then
                    return
                end

                return {
                    type = 1,
                    from = from_player,
                    site = self.planting_site,
                    percentage = plant_percentage,
                    damage = self:calculate_damage(from_player, self.planting_player, armor_value)
                }
            end
        else
            local result

            entity.get_entities("CPlantedC4", true, function(c4)
                if c4.m_bBombDefused then
                    return
                end

                local explodes_at = c4.m_flC4Blow

                local site = c4.m_nBombSite == 0 and "A" or "B"
                local time_left = explodes_at - globals.curtime

                if time_left >= 0 then
                    local fatal = false
                    local damage = self:calculate_damage(from_player, c4, armor_value)

                    if from_player:is_alive() then
                        if damage >= 1 then
                            if damage >= health then
                                fatal = true
                            end
                        end
                    end

                    result = {
                        type = 2,
                        site = site,
                        entity = c4,
                        time_left = explodes_at - curtime,
                        from = from_player,
                        damage = damage or -1,
                    }

                    return false
                end
            end)

            return result
        end
    end,
}

events.bomb_beginplant:set(function(e) c4_info:begin_plant(e) end)
events.bomb_abortplant:set(function() c4_info:reset() end)
events.bomb_planted:set(function() c4_info:reset() end)
events.round_start:set(function() c4_info:reset() end)

events.emit_sound:set(function(c)
    if c.sound_name:find("weapons/c4/c4_beep") then
        c4_info:beep(c)
    end
end)

gamesense.calibri = render.load_font("Calibri Bold", 23, "da")
gamesense.render = function(string, ay, col, circle, circle_color, circle_degree)
    local x, y = defines.screen_size.x/100 + 2, defines.screen_size.y/1.48 - 5

    if circle == nil then
        circle = false
    end

    if circle_color == nil then
        circle_color = color(255, 255, 255, 255)
    end

    if circle_degree == nil then
        circle_degree = 360
    end
    
    ts = render.measure_text(gamesense.calibri, "s", string)
    render.gradient(vector(x/1.9, y + ay), vector(x/1.9 + (ts.x) / 2, y + ay + ts.y + 6), color(0, 0, 0, 0), color(0, 0, 0, col.a/8), color(0, 0, 0, 0), color(0, 0, 0, col.a/8))
    render.gradient(vector(x/1.9 + (ts.x) / 2, y + ay), vector(x/1.9 + (ts.x), y + ay + ts.y + 6), color(0, 0, 0, col.a/8), color(0, 0, 0, 0), color(0, 0, 0, col.a/8), color(0, 0, 0, 0))
    render.text(gamesense.calibri, vector(x, y + 4 + ay), col, "s", string)

    if circle then
        render.circle_outline(vector(x + ts.x+18, y+ay+ts.y/2+2), color(0, 0, 0, 255), 10.5, 0, 1, 4)
        render.circle_outline(vector(x + ts.x+18, y+ay+ts.y/2+2), circle_color, 10, 0, circle_degree, 3)
    end
end

gamesense.handle = function()

end

menu.switch(ui_handler.groups_name.features.interface, defines.colored_text({ui_handler.get_icon("dharmachakra"), color("A3E908FF")}, {" Game"}, {"Sense", color("A3E908FF")}))("features", "gamesense_indicators", true)(function(group)
    menu.switch(group, "Spectators")("features", "gamesense_indicators_spectators", true, function()
        return ui_handler.elements["features"]["gamesense_indicators"]
    end)
    menu.switch(group, "Purchace")("features", "gamesense_indicators_purchace", true, function()
        return ui_handler.elements["features"]["gamesense_indicators"]
    end)
    menu.listable(group, "Settings", {"Exploit", "Dormant Aimbot", "Fake Latency", "DoubleTap", "Damage", "Freestanding", "Fake Duck", "Body Aim", "Safe Points", "Bomb Info"})("features","gamesense_indicators_list", true, function()
        return ui_handler.elements["features"]["gamesense_indicators"]
    end)
end)

menu.switch(ui_handler.groups_name.features.interface, defines.colored_text({ui_handler.get_icon("image"), colors.link_active}, {" Watermark"}))("features", "solus_watermark", true)(function(group)
    menu.combo(group, "Lock To", {"None", "Upper Right", "Bottom Center", "Under Radar"})("features", "solus_watermark_position", true, function()
        return ui_handler.elements["features"]["solus_watermark"]
    end)

    menu.selectable(group, "Settings", {"Nickname", "Framerate", "Latency", "Time"})("features", "solus_watermark_settings", true, function()
        return ui_handler.elements["features"]["solus_watermark"]
    end)

    menu.combo(group, "Separator", {"Space", "Line", "Dot"})("features", "solus_watermark_separator", true, function()
        return ui_handler.elements["features"]["solus_watermark"]
    end)

    menu.combo(group, "Logo Style", {"Static", "Multi-Color", "Gradient", "Animated"})("features", "solus_watermark_logo", true, function()
        return ui_handler.elements["features"]["solus_watermark"]
    end)

    menu.color_picker(group, "Logo First Color", color(255, 255, 255, 255))("features", "solus_watermark_logo_first", true, function()
        return ui_handler.elements["features"]["solus_watermark"]
    end)

    menu.color_picker(group, "Logo Second Color", color(255, 255, 255, 255))("features", "solus_watermark_logo_second", true, function()
        return ui_handler.elements["features"]["solus_watermark"] and ui_handler.elements["features"]["solus_watermark_logo"] ~= "Static"
    end)

    menu.combo(group, "Nickname", {"Default", "Steam", "Custom"})("features", "solus_watermark_nickname", true, function()
        return ui_handler.elements["features"]["solus_watermark"] and ui_handler.elements["features"]["solus_watermark_settings"]["Nickname"]
    end)

    menu.input(group, "")("features", "solus_watermark_custom_name", true, function()
        return ui_handler.elements["features"]["solus_watermark"] and ui_handler.elements["features"]["solus_watermark_nickname"] == "Custom"
    end)

    menu.switch(group, "12H Format")("features", "solus_watermark_time_format", true, function()
        return ui_handler.elements["features"]["solus_watermark"] and ui_handler.elements["features"]["solus_watermark_settings"]["Time"]
    end)
end)

menu.switch(ui_handler.groups_name.features.interface, defines.colored_text({ui_handler.get_icon("keyboard"), colors.link_active}, {" Keybinds"}))("features", "solus_keybinds", true)(function(group)
    menu.slider(group, "Min. Width", 80, 120, 80)("features", "solus_keybinds_width", true, function()
        return ui_handler.elements["features"]["solus_keybinds"]
    end)

    menu.switch(group, "Disable Bind Value")("features", "solus_keybinds_value", true, function()
        return ui_handler.elements["features"]["solus_keybinds"]
    end)
end)

menu.switch(ui_handler.groups_name.features.interface, defines.colored_text({ui_handler.get_icon("glasses"), colors.link_active}, {" Spectators"}))("features", "solus_spectators", true)(function(group)
    menu.slider(group, "Min. Width", 80, 120, 80)("features", "solus_spectators_width", true, function()
        return ui_handler.elements["features"]["solus_spectators"]
    end)

    menu.switch(group, "Avatars")("features", "solus_spectators_avatars", true, function()
        return ui_handler.elements["features"]["solus_spectators"]
    end)
end)

aimbot_logger.data = {}

aimbot_logger.hitboxes = {"generic","head", "chest", "stomach","left arm", "right arm","left leg", "right leg","neck", "generic", "gear"}

menu.label(ui_handler.groups_name.features.interface, defines.colored_text({ui_handler.get_icon("layer-group"), colors.link_active}, {" Interface Design"}))("features", "solus_settings", false, function()
    return ui_handler.elements["features"]["solus_watermark"] or ui_handler.elements["features"]["solus_keybinds"] or ui_handler.elements["features"]["solus_spectators"] --or ui_handler.elements["features"]["aimbot_logger"]
end)(function(group)
    menu.combo(group, "Style", {"Branded", "GameSense"})("features", "solus_settings_style", true)

    menu.combo(group, "Header Pos.", {"None", "Top", "Bottom"})("features", "solus_settings_position", true, function()
        return ui_handler.elements["features"]["solus_settings_style"] == "GameSense"
    end)

    menu.combo(group, "Header Style", {"Colored", "Gradient"})("features", "solus_settings_header", true, function()
        return ui_handler.elements["features"]["solus_settings_style"] == "GameSense" and ui_handler.elements["features"]["solus_settings_position"] ~= "None"
    end)

    menu.slider(group, "Height", 1, 15, 5, 1, "px")("features", "solus_settings_background", true)

    menu.slider(group, "Rounding", 1, 10, 5, 1, function(value) return value == 1 and "Off" or value.."px" end)("features", "solus_settings_rounding", true, function()
        return ui_handler.elements["features"]["solus_settings_style"] == "Branded"
    end)

    menu.slider(group, "Glow Strength", 0, 100, 75, 1, function(value) return value == 0 and "Off" or value.."%" end)("features", "solus_settings_glow", true)

    menu.switch(group, "Pulse")("features", "solus_settings_pulse", true, function()
        return ui_handler.elements["features"]["solus_settings_glow"] ~= 0
    end)

    menu.switch(group, "Gradient")("features", "solus_settings_blur", true, function()
        return ui_handler.elements["features"]["solus_settings_style"] == "Branded"
    end)

    menu.color_picker(group, "Accent Color", color(255, 255, 255, 255))("features", "solus_settings_color", true)

    menu.color_picker(group, "Background Color", color(0, 0, 0, 255))("features", "solus_settings_background_color", true)

    menu.color_picker(group, "Glow Color", color(255, 255, 255, 255))("features", "solus_settings_glow_color", true, function()
        return ui_handler.elements["features"]["solus_settings_glow"] ~= 0
    end)
end)

defines.teleport_weapons_names = {"AWP", "SSG-08", "AutoSnipers", "Heavy Pistols", "Pistols", "Rifle", "SMG", "Shotgun", "Nades", "Taser", "Knife"}
defines.teleport_weapons_id = {
    ["AWP"] = {9}, 
    ["SSG-08"] = {40}, 
    ["AutoSnipers"] = {11, 38}, 
    ["Heavy Pistols"] = {1, 64}, 
    ["Pistols"] = {2, 3, 4, 30, 32, 36, 61, 63}, 
    ["Rifle"] = {7, 8, 10, 13, 16, 39, 60}, 
    ["SMG"] = {17, 19, 23, 24, 33, 34}, 
    ["Shotgun"] = {25, 27, 29, 35}, 
    ["Nades"] = {43, 44, 45, 46, 47, 48}, 
    ["Taser"] = {31}, 
    ["Knife"] = {41, 42, 59, 500, 503, 505, 506, 507, 508, 509, 512, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 525}
}

exploit_discharge.work = false
exploit_discharge.teleported = false
exploit_discharge.handle = function()
    if not ui_handler.elements["features"]["exploit_discharge"] then
        return
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local weapon = player:get_player_weapon()

    if weapon == nil then
        return
    end

    local weapon_id = weapon:get_weapon_index()

    if weapon_id == nil then
        return
    end

    local players = entity.get_players(true)

    if players == nil or #players == 0 then
        return
    end

    local can_hit = function(entity)
        local damage, trace = utils.trace_bullet(entity, entity:get_hitbox_position(3), player:get_hitbox_position(3))
    
        if damage > 0 then
            if trace.entity and trace.entity == player then
                return true
            end
        end
    
        return false
    end

    local in_air = conditional_antiaims.player_state == conditional_antiaims.states.air or conditional_antiaims.player_state == conditional_antiaims.states.air_crouch

    local allow_teleport = false
    for k, v in pairs(defines.teleport_weapons_id) do
        if ui_handler.elements["features"]["exploit_discharge_weapons"][k] then
            for i = 1, #v do
                if v[i] == weapon_id then
                    allow_teleport = true
                else
                    exploit_discharge.teleported = false 
                end
            end
        end
    end

    local teleport_ready = false

    if allow_teleport then
        for k, enemy in pairs(players) do
            if enemy == local_player then
                return
            end

            if can_hit(enemy) then
                teleport_ready = true
            else
                exploit_discharge.teleported = false
            end
        end
    end

    exploit_discharge.work = false

    if neverlose_refs.doubletap:get() and in_air then
        exploit_discharge.work = true
        if teleport_ready and not exploit_discharge.teleported then
            rage.exploit:force_teleport()
            exploit_discharge.teleported = true
        end
    end
end

menu.switch(ui_handler.groups_name.features.ragebot, "Exploit Discharge")("features", "exploit_discharge", true)(function(group)
    menu.selectable(group, "Weapons", defines.teleport_weapons_names)("features", "exploit_discharge_weapons", true, function()
        return ui_handler.elements["features"]["exploit_discharge"]
    end)
end)

exploit_manipulations.handle = function()
    
    local in_air = conditional_antiaims.player_state == conditional_antiaims.states.air or conditional_antiaims.player_state == conditional_antiaims.states.air_crouch

    local exploit_manipulation_settings = ui_handler.elements["features"]["exploit_manipulation_settings"]

    neverlose_refs.override("doubletap_config",
        (in_air and ui_handler.elements["features"]["exploit_manipulation"] and exploit_manipulation_settings["Double Tap"])
        and "Always On"
        or nil 
    )

    neverlose_refs.override("doubletap_fakelag", 
        (in_air and ui_handler.elements["features"]["exploit_manipulation"] and exploit_manipulation_settings["Double Tap"])
        and 1
        or nil 
    )

    neverlose_refs.override("hideshots_config",
        (in_air and ui_handler.elements["features"]["exploit_manipulation"] and exploit_manipulation_settings["Hide Shots"])
        and "Break LC"
        or nil 
    )

end

menu.switch(ui_handler.groups_name.features.ragebot, "Exploit Manipulation")("features", "exploit_manipulation", true)(function(group)
    menu.selectable(group, "Settings", {"Hide Shots", "Double Tap"})("features", "exploit_manipulation_settings", true, function()
        return  ui_handler.elements["features"]["exploit_manipulation"]
    end)
end)

visuals.eye = render.load_image([[<svg width="12" height="9" viewBox="0 0 12 9" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M6 5.78571C6.33354 5.78571 6.65341 5.65026 6.88926 5.40914C7.1251 5.16802 7.2576 4.84099 7.2576 4.5C7.2576 4.15901 7.1251 3.83198 6.88926 3.59086C6.65341 3.34974 6.33354 3.21429 6 3.21429C5.66646 3.21429 5.34659 3.34974 5.11074 3.59086C4.8749 3.83198 4.7424 4.15901 4.7424 4.5C4.7424 4.84099 4.8749 5.16802 5.11074 5.40914C5.34659 5.65026 5.66646 5.78571 6 5.78571Z" fill="white"/><path fill-rule="evenodd" clip-rule="evenodd" d="M0 4.5C0.80109 1.89193 3.18424 0 6 0C8.81576 0 11.1989 1.89193 12 4.5C11.1989 7.10807 8.81576 9 6 9C3.18424 9 0.80109 7.10807 0 4.5ZM8.5152 4.5C8.5152 5.18199 8.2502 5.83604 7.77851 6.31827C7.30682 6.80051 6.66707 7.07143 6 7.07143C5.33293 7.07143 4.69318 6.80051 4.22149 6.31827C3.7498 5.83604 3.4848 5.18199 3.4848 4.5C3.4848 3.81801 3.7498 3.16396 4.22149 2.68173C4.69318 2.19949 5.33293 1.92857 6 1.92857C6.66707 1.92857 7.30682 2.19949 7.77851 2.68173C8.2502 3.16396 8.5152 3.81801 8.5152 4.5Z" fill="white"/></svg>]], vector(12, 9))
visuals.keys = render.load_image([[<svg width="10" height="11" viewBox="0 0 10 11" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M2.30769 4.34615C2.30769 3.93813 2.46978 3.54681 2.7583 3.2583C3.04681 2.96978 3.43813 2.80769 3.84615 2.80769H8.46154C8.86956 2.80769 9.26088 2.96978 9.54939 3.2583C9.83791 3.54681 10 3.93813 10 4.34615V8.96154C10 9.36956 9.83791 9.76088 9.54939 10.0494C9.26088 10.3379 8.86956 10.5 8.46154 10.5H3.84615C3.43813 10.5 3.04681 10.3379 2.7583 10.0494C2.46978 9.76088 2.30769 9.36956 2.30769 8.96154V4.34615Z" fill="white"/><path d="M1.53846 0.5C1.13044 0.5 0.739122 0.662087 0.450605 0.950605C0.162087 1.23912 0 1.63044 0 2.03846V6.65385C0 7.06187 0.162087 7.45319 0.450605 7.7417C0.739122 8.03022 1.13044 8.19231 1.53846 8.19231V3.57692C1.53846 2.72725 2.22725 2.03846 3.07692 2.03846H7.69231C7.69231 1.63044 7.53022 1.23912 7.2417 0.950605C6.95319 0.662087 6.56187 0.5 6.15385 0.5H1.53846Z" fill="white"/></svg>]], vector(10, 11))
visuals.list = render.load_image([[<svg width="8" height="7" viewBox="0 0 8 7" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M0 0.583333C0 0.428624 0.0602039 0.280251 0.167368 0.170854C0.274531 0.0614583 0.419876 0 0.571429 0H7.42857C7.58012 0 7.72547 0.0614583 7.83263 0.170854C7.9398 0.280251 8 0.428624 8 0.583333C8 0.738043 7.9398 0.886416 7.83263 0.995812C7.72547 1.10521 7.58012 1.16667 7.42857 1.16667H0.571429C0.419876 1.16667 0.274531 1.10521 0.167368 0.995812C0.0602039 0.886416 0 0.738043 0 0.583333ZM0 3.5C0 3.34529 0.0602039 3.19692 0.167368 3.08752C0.274531 2.97812 0.419876 2.91667 0.571429 2.91667H7.42857C7.58012 2.91667 7.72547 2.97812 7.83263 3.08752C7.9398 3.19692 8 3.34529 8 3.5C8 3.65471 7.9398 3.80308 7.83263 3.91248C7.72547 4.02187 7.58012 4.08333 7.42857 4.08333H0.571429C0.419876 4.08333 0.274531 4.02187 0.167368 3.91248C0.0602039 3.80308 0 3.65471 0 3.5ZM0 6.41667C0 6.26196 0.0602039 6.11358 0.167368 6.00419C0.274531 5.89479 0.419876 5.83333 0.571429 5.83333H7.42857C7.58012 5.83333 7.72547 5.89479 7.83263 6.00419C7.9398 6.11358 8 6.26196 8 6.41667C8 6.57138 7.9398 6.71975 7.83263 6.82915C7.72547 6.93854 7.58012 7 7.42857 7H0.571429C0.419876 7 0.274531 6.93854 0.167368 6.82915C0.0602039 6.71975 0 6.57138 0 6.41667Z" fill="white" fill-opacity="0.25"/></svg>]], vector(9, 9))

visuals.font_water = render.load_font("Calibri", 11, "bau")

visuals.render_container = function(width, height, text, name, enabled, adding, color)
    local accent_clr = color or ui_handler.elements["features"]["solus_settings_color"]
    local background_clr = ui_handler.elements["features"]["solus_settings_background_color"]
    local glow_clr = color or ui_handler.elements["features"]["solus_settings_glow_color"]
    local height = height or ui_handler.elements["features"]["solus_settings_background"]
    local glow_strength = ui_handler.elements["features"]["solus_settings_glow"]/2
    local rounding = ui_handler.elements["features"]["solus_settings_rounding"]
    local blur = ui_handler.elements["features"]["solus_settings_blur"]
    local pulse = ui_handler.elements["features"]["solus_settings_pulse"]
    local watermark_pos = ui_handler.elements["features"]["solus_watermark_position"]
    local style = ui_handler.elements["features"]["solus_settings_style"]

    local text_size = render.measure_text(visuals.font_water, nil, text)
    local positions = {}

    if ui_handler.elements["drag"][name .. "_pos_x"] then
        positions = {
            ["None"] = vector(ui_handler.elements["drag"][name .. "_pos_x"], ui_handler.elements["drag"][name .. "_pos_y"]),
            ["Upper Right"] = vector(defines.screen_size.x - (text_size.x + 20), 10),
            ["Bottom Center"] = vector(defines.screen_size.x/2 - text_size.x/2, defines.screen_size.y-30),
            ["Under Radar"] = vector(25, defines.screen_size.y/5.5 + cvar.hud_scaling:float()*200)
        }
    end

    local settings = {
        ["hitlogs"] = vector(defines.screen_size.x/2 - text_size.x/2, defines.screen_size.y*0.79),
        ["watermark"] = positions[watermark_pos],
    }

    local pos = settings[name] or vector(ui_handler.elements["drag"][name .. "_pos_x"], ui_handler.elements["drag"][name .. "_pos_y"])
    
    adding = adding or 0

    local anim = {}
    if type(enabled) == "number" then
        anim.alpha = enabled
        anim.width = text_size.x + width + 10
    else
        anim.alpha = animations.new(name .. "_main", enabled and (name == "watermark" and watermark_pos ~= "None" and 255 or draggables.current_drugging_item == name and ui.get_alpha() > 0 and 100 or 255) or 0)
        anim.width = text_size.x + animations.new(name .. "_width2", width + 10)
    end

    if style == "Branded" then
        visuals.render_solus_rect(pos.x, pos.y + adding - 1, anim.width, height + 15, accent_clr:override("a", anim.alpha), background_clr:override("a", background_clr.a/255*anim.alpha), glow_clr:override("a", anim.alpha), glow_strength, rounding, blur, pulse)
    else
        visuals.render_skeet_rect(pos.x, pos.y + adding - 1, anim.width, height + 15, accent_clr:override("a", anim.alpha), glow_clr:override("a", anim.alpha), glow_strength, pulse)
    end

    if name ~= "watermark" and name ~= "hitlogs" and name ~= "speed_warning" then
        render.texture(name == "keybinds" and visuals.keys, vector(pos.x + 7, pos.y + height/2 + 2), name == "keybinds" and vector(10, 11), accent_clr:override("a", anim.alpha))
        render.texture(name == "spectators" and visuals.eye, vector(pos.x + 6, pos.y + height/2 + 3), name == "spectators" and vector(12, 9), accent_clr:override("a", anim.alpha))
        render.texture(visuals.list, vector(pos.x + anim.width - 14, pos.y + height/2 + 3), vector(8, 8), colors.white:override("a", anim.alpha))
    end
    render.text(visuals.font_water, name ~= "watermark" and name ~= "hitlogs" and name ~= "speed_warning" and vector(pos.x + 22, pos.y + adding + height/2 + 2) or vector(pos.x + 5, pos.y + adding + height/2 + 1), colors.white:override("a", anim.alpha), nil, text)

    draggables.drag_handle(pos.x, pos.y + adding, text_size.x + width + 10, height + 19, name)
end

visuals.shadow_frac = 0

visuals.update_shadow_frac = function()
    local frac = math.fmod(globals.realtime * 8, 45)

    if frac <= 7.5 then
        return frac / 7.5
    elseif frac <= 30 then
        return 1
    elseif frac <= 37.5 then
        return 1 - ( frac - 30 ) / 7.5
    else
        return 0
    end
end

visuals.watermark_data = {
    last_update = -1,
    time = "00:00:00",
    fps = math.floor(1/globals.frametime),
}

colors.hashes = {}
colors.gradient_text = function(text, magic_value, clrs)

    local clrs_hash = ""

    for k, v in ipairs(clrs) do
        clrs_hash = clrs_hash .. v:to_hex()
    end

    local hash = text .. magic_value .. clrs_hash

    if colors.hashes[hash] == nil then
        colors.hashes[hash] = gradient.text_animate(text, magic_value, clrs)
    end

    return colors.hashes[hash]

end

visuals.build_watermark_text = function()
    local logo = ui_handler.elements["features"]["solus_watermark_logo"]
    local logo_first = ui_handler.elements["features"]["solus_watermark_logo_first"]
    local logo_second = ui_handler.elements["features"]["solus_watermark_logo_second"]
    local nickname_type = ui_handler.elements["features"]["solus_watermark_nickname"]

    local nickname =    ui_handler.elements["features"]["solus_watermark_settings"]["Nickname"]
    local framerate =   ui_handler.elements["features"]["solus_watermark_settings"]["Framerate"]
    local ping =        ui_handler.elements["features"]["solus_watermark_settings"]["Latency"]
    local time =        ui_handler.elements["features"]["solus_watermark_settings"]["Time"]

    local separator = ui_handler.elements["features"]["solus_watermark_separator"]

    local separators = {
        ["Space"] = "  ",
        ["Line"] = " | ",
        ["Dot"] = " · ",
    }

    local animated_logo = colors.gradient_text("drainyaw", 1.7, {logo_first, logo_second})
    animated_logo:animate()

    local logo_type = {
        ["Static"] = defines.colored_text({"drainyaw", logo_first}),
        ["Multi-Color"] = defines.colored_text({"drai", logo_first}, {"nyaw", logo_second}), 
        ["Gradient"] = gradient.text("drainyaw", false, {logo_first, logo_second}),
        ["Animated"] = animated_logo:get_animated_text()
    }

    local text = logo_type[logo]

    local anim = {}
    anim.nickname = animations.new("nickname_watermark", nickname and 255 or 0)
    if anim.nickname > 3 then
        local tmp = {
            ["Default"] = defines.username,
            ["Steam"] = defines.steam_name,
            ["Custom"] = ui_handler.elements["features"]["solus_watermark_custom_name"]
        }

        text = text .. "\a" .. colors.white:override("a", anim.nickname):to_hex() .. separators[separator] .. tmp[nickname_type]
    end
    
    anim.framerate = animations.new("framerate_watermark", framerate and 255 or 0)
    if anim.framerate > 3 then
        text = text .. "\a" .. colors.white:override("a", anim.framerate):to_hex() .. separators[separator] .. visuals.watermark_data.fps .. " fps"
    end

    anim.ping = animations.new("ping_watermark", ping and 255 or 0)
    if anim.ping > 3 then
        local net = utils.net_channel()

        if net ~= nil then
            text = text .. "\a" .. colors.white:override("a", anim.ping):to_hex() .. separators[separator] .. math.floor(net.avg_latency[1] * 1000) .. " ms"
        end
    end

    anim.time = animations.new("time_watermark", time and 255 or 0)
    if anim.time > 3 then
        text = text .. "\a" .. colors.white:override("a", anim.time):to_hex() .. separators[separator] .. visuals.watermark_data.time
    end

    return text
end

visuals.get_binds = function()
    local binds = {}
    local cheat_binds = ui.get_binds()
    for i = 1, #cheat_binds do
        table.insert(binds, 1, cheat_binds[i])
    end
    return binds
end

visuals.binds_width = 0
visuals.binds_width2 = 0
visuals.build_binds = function(enabled)
    local binds = visuals.get_binds()
    local width = ui_handler.elements["features"]["solus_keybinds_width"]
    local anim = {}
    local active = {}
    local add_y = ui_handler.elements["features"]["solus_settings_background"] + (ui_handler.elements["features"]["solus_settings_style"] == "Branded" and 17 or 23)

    local pos = vector(ui_handler.elements["drag"]["keybinds_pos_x"], ui_handler.elements["drag"]["keybinds_pos_y"])

    for k, bind in pairs(binds) do

        local bind = {
            name = bind.name,
            active = bind.active,
            mode = bind.mode,
            value = bind.value
        }

        if anim[bind.name] == nil then
            anim[bind.name] = 0
        end

        anim[bind.name] = animations.new("keybinds_" .. bind.name, enabled and bind.active and 255 or 0, 0.095)
        if anim[bind.name] < 0.01 then goto skip end
        local state = ui_handler.elements["features"]["solus_keybinds_value"] and (bind.active and "on" or "off") or (type(bind.value) ~= "number" and type(bind.value) ~= "string" and (bind.mode == 1 and "hold" or "toggled") or bind.value)
        render.text(1, vector(pos.x + 2, pos.y + add_y) - (ui_handler.elements["features"]["solus_settings_style"] == "Branded" and vector(0, 0) or vector(5, 0)), colors.white:override("a", anim[bind.name]), nil, bind.name)
        render.text(1, vector(pos.x + visuals.binds_width + 21 - render.measure_text(1, nil, ("[%s]"):format(state)).x, pos.y + add_y) + (ui_handler.elements["features"]["solus_settings_style"] == "Branded" and vector(0, 0) or vector(2, 0)), colors.white:override("a", anim[bind.name]), nil, ("[%s]"):format(state))

        local measured_text_state_x     = render.measure_text(1, nil, ("[%s]"):format(state)).x
        local measured_text_bindname_x  = render.measure_text(1, nil, bind.name).x

        if (measured_text_bindname_x + measured_text_state_x) > (width) then
            width = (measured_text_bindname_x + measured_text_state_x)
        end

        if bind.active then
            table.insert(active, bind)
        end

        add_y = add_y + anim[bind.name]/255*17

        ::skip::
    end

    visuals.binds_width = animations.new("keybinds_width", width)
    visuals.binds_width2 = width

    return enabled and (#active > 0 or ui.get_alpha() > 0)
end

visuals.get_spectators = function()
    local spectators = {}

    local local_player, target = entity.get_local_player()

    if local_player ~= nil then
        if local_player.m_hObserverTarget then
            target = local_player.m_hObserverTarget
        else
            target = local_player
        end

        local players = entity.get_players(false, false)

        if players ~= nil then
            for k, player in pairs(players) do
                local obtarget = player.m_hObserverTarget

                if obtarget and obtarget == target then
                    table.insert(spectators, player)
                end
            end
        end
    end

    return spectators
end

visuals.specs_width = 0
visuals.build_specs = function(enabled)
    local specs = visuals.get_spectators()
    local width = ui_handler.elements["features"]["solus_spectators_width"]
    local anim = {}
    local active = {}
    local add_y = ui_handler.elements["features"]["solus_settings_background"] + (ui_handler.elements["features"]["solus_settings_style"] == "Branded" and 17 or 23)

    local pos = vector(ui_handler.elements["drag"]["spectators_pos_x"], ui_handler.elements["drag"]["spectators_pos_y"])

    for k, spec in pairs(specs) do

        local spec_name = spec:get_name()

        if anim[spec_name] == nil then
            anim[spec_name] = 0
        end

        anim[spec_name] = animations.new("spectators_" .. spec_name, enabled and spec and 255 or 0, 0.095)
        if anim[spec_name] < 0.01 then goto skip end

        local animated_alpha = colors.white:override("a", anim[spec_name])
        render.text(1, vector(pos.x + 2, pos.y + add_y), animated_alpha, nil, spec_name)
        if ui_handler.elements["features"]["solus_spectators_avatars"] then
            render.texture(spec:get_steam_avatar(), vector(pos.x + visuals.specs_width + 9, pos.y + 2 + add_y), vector(13, 13), animated_alpha, "f", 20)
        end

        local measured_text = render.measure_text(1, nil, spec_name).x
        if measured_text > width then
            width = measured_text
        end

        if spec then
            table.insert(active, spec)
        end

        add_y = add_y + anim[spec_name]/255*17

        ::skip::
    end

    visuals.specs_width = animations.new("spectators_width", width)

    return enabled and (#active > 0 or ui.get_alpha() > 0)
end

--chams.material_first = materials.create("first_hands_material", [[
--    "VertexLitGeneric"
--    {
--        "$basetexture" "glowOverlay"
--        "$additive" "1"
--		"$envmap" "models/effects/cube_white"
--		"$envmapfresnel" "1"
--		"$wireframe" "1"
--		"$envmapfresnelminmaxexp" "[0 0.5 50]"
--    }
--]])
--
--chams.material_second = materials.create("second_hands_material", [[
--    "VertexLitGeneric"
--    {
--        "$basetexture" "sprites/light_glow04"
--        "$additive" "1"
--        "$wireframe" "1"
--        "$nocull" "1"
--        "Proxies"
--        {
--            "TextureScroll"
--            {
--                "texturescrollvar" "$BasetextureTransform"
--                "texturescrollrate" "0.25"
--                "texturescrollangle" "90"
--            }
--        }
--    }
--]])
--
--menu.switch({"features", "Other"}, "Hand Chams")("features", "hand_chams")(function(group)
--    menu.color_picker(group, "Color 1", color(255, 0, 255, 255))("features", "hand_chams_color_1st")
--    menu.color_picker(group, "Color 2", color(255, 0, 255, 255))("features", "hand_chams_color_2nd")
--end)
--
--chams.handle = function(ctx)
--
--    local first_color = ui_handler.elements["features"]["hand_chams_color_1st"] or colors.black
--
--    chams.material_first:shader_param("envmaptint", "[0 0 0]")--string.format("[%d %d %d]", first_color.r, first_color.g, first_color.b))
--    chams.material_first:color_modulate(first_color)
--
--    chams.material_second:color_modulate(ui_handler.elements["features"]["hand_chams_color_2nd"] or colors.black)
--    
--    chams.material_first:alpha_modulate(255)
--    chams.material_second:alpha_modulate(80)
--
--    ctx:draw(chams.material_first)
--    ctx:draw(chams.material_second)
--
--    return false
--end

callbacks.register = function(event, name, fn)
    events[event]:set(safecall(name, event ~= "shutdown", fn))
end

--callbacks.register("draw_model", "chams", chams.handle)

easy_peek.settings = {
    ["Freestand"] = {"freestanding", true},
    ["Prefer Body"] = {"prefer_body", "Prefer"},
    ["Prefer Safety"] = {"prefer_safety", "Prefer"},
    ["Peek Assist"] = {"quick_peek", true},
    ["DoubleTap"] = {"doubletap", true},
    ["Minimum Damage"] = {"min_damage", function()
        return ui_handler.elements["features"]["easy_peek_damage"]
    end}
}

easy_peek.handle = safecall("easy_peek", true, function(cmd)

    local is_enabled = ui_handler.elements["features"]["easypeek"]

    if not is_enabled then
        return
    end

    local ref = ui_handler.refs["features"]["easy_peek_options"].ref

    local tbl = ref:get()

    for k, v in ipairs(tbl) do
        local tmp = easy_peek.settings[v]
        if tmp then
            neverlose_refs.override(tmp[1], type(tmp[2]) == "function" and tmp[2]() or tmp[2])
        end
    end

end)

menu.switch(ui_handler.groups_name.features.ragebot, "Easy Peek")("features", "easypeek", true)(function(group)
    menu.selectable(group, "Options", {"Freestand", "DoubleTap", "Peek Assist", "Prefer Body", "Prefer Safety", "Minimum Damage"})("features", "easy_peek_options", true)

    menu.slider(group, "Minimum Damage", 1, 100, 10)("features", "easy_peek_damage", true, function()
        return ui_handler.elements["features"]["easy_peek_options"]["Minimum Damage"]
    end)
end)

esp.enemy:new_text("Revolver Helper", "DMG+", function(enemy)
    if not ui_handler.elements["features"]["revolver_helper"] then
        return
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local wpn = player:get_player_weapon()

    if wpn == nil then
        return
    end

    local wpn_id = wpn:get_weapon_index()

    if wpn_id == nil then
        return
    end

    local damage, trace = utils.trace_bullet(player, player:get_hitbox_position(3), enemy:get_hitbox_position(3))
	local health = enemy.m_iHealth

    if damage == nil then
        return
    end

    if trace == nil then
        return
    end

    if health == nil then
        return
    end
    
	if health < damage and wpn_id == 64 then
		return "DMG+"
	end
end)

revolver_helper.handle = function()
    if not ui_handler.elements["features"]["revolver_helper"] then
        return
    end

    local player = entity.get_local_player()
    
    if player == nil or not player:is_alive() then
        return
    end

    local wpn = player:get_player_weapon()

    if wpn == nil then
        return
    end

    local wpn_id = wpn:get_weapon_index()

    if wpn_id == nil then
        return
    end

    if wpn_id ~= 64 then
        return
    end

    
    local target = entity.get_threat()

    if target == nil then
        return
    end
    
    if player:get_origin():dist(target:get_origin()) > 700 then
        return
    end

    local damage, trace = utils.trace_bullet(player, player:get_hitbox_position(3), target:get_hitbox_position(3))
    local health = target.m_iHealth

    if damage == nil then
        return
    end

    if trace == nil then
        return
    end

    if health == nil then
        return
    end

    local magic_vector = vector(0, 0, 40)
    render.line(render.world_to_screen(player:get_origin() + magic_vector), render.world_to_screen(target:get_origin() + magic_vector), health < damage and color(50, 220, 50, 255) or color(220, 50, 50, 255))
end

menu.switch(ui_handler.groups_name.features.ragebot, "R8 Helper")("features", "revolver_helper", true)

head_only.handle = function()
    if not ui_handler.elements["features"]["head_only"] then
        return
    end

    neverlose_refs.override("multipoint", "Head")
    neverlose_refs.override("hitboxes", "Head")
end

menu.switch(ui_handler.groups_name.features.ragebot, "Head Only")("features", "head_only", true)

visuals.watermark_data.fps_arr = {}
visuals.watermark_data.fps_avg = 0
visuals.per_second_update = safecall("per_second_update", true, function()
    local time = math.floor(globals.realtime)
    if visuals.watermark_data.last_update ~= time then

        local is_12hr = ui_handler.elements["features"]["solus_watermark_time_format"] 
        local format = is_12hr and "I" or "H"

        visuals.watermark_data.time = common.get_date("%" .. format .. ":%M" .. (is_12hr and " %p" or ""), common.get_unixtime())

        if callbacks.error_logged then

            if callbacks.last_error_log + callbacks.network_ratelimit < time then
                callbacks.error_logged = false
            end

        end

        visuals.watermark_data.fps = visuals.watermark_data.fps_avg
        visuals.watermark_data.last_update = time
    end




    local frametime = math.floor(1/globals.frametime)
    local avg = 0

    local tbl_size = #visuals.watermark_data.fps_arr

    if tbl_size > 10 then
        table.remove(visuals.watermark_data.fps_arr, 1)
    end

    table.insert(visuals.watermark_data.fps_arr, frametime)
    for i = 1, tbl_size do
        avg = avg + visuals.watermark_data.fps_arr[i]
    end

    visuals.watermark_data.fps_avg = math.floor(avg / tbl_size)
end)

snaplines.handle = function()
    local enabled = ui_handler.elements["features"]["snaplines"]
    local anim = {}

    anim.main = animations.new("snaplines", enabled and 255 or 0)

    if anim.main < 1 then
        return
    end

    local player = entity.get_local_player()
    
    if player == nil or not player:is_alive() then
        return
    end

    local players = entity.get_players()

    if players == nil or #players == 1 then
        return
    end

    local clr = ui_handler.elements["features"]["snaplines_color"]
    local magic_vector = vector(0, 0, 40)
    local player_origin = player:get_origin()

    if ui_handler.elements["features"]["snaplines_type"] == "On All" then
        for k, enemy in pairs(players) do
            anim.on_all = {}
            anim.on_all[enemy:get_name()] = animations.new("snaplines_all_" .. enemy:get_name(), enabled and enemy:is_alive() and enemy:is_enemy() and not enemy:is_dormant() and 255 or 0)
            if anim.on_all[enemy:get_name()] > 1 then
                render.line(render.world_to_screen(player_origin + magic_vector), render.world_to_screen(enemy:get_origin() + magic_vector), clr:override("a", anim.on_all[enemy:get_name()]))
            end
        end
    else
        local target = entity.get_threat()
        anim.target = animations.new("snaplines_all", enabled and target ~= nil and target:is_alive() and not target:is_dormant() and 255 or 0)
        if anim.target > 1 then
            render.line(render.world_to_screen(player_origin + magic_vector), render.world_to_screen(target:get_origin() + magic_vector), clr:override("a", anim.target))
        end
    end
end

menu.switch(ui_handler.groups_name.features.additional, "Snaplines")("features", "snaplines", true)(function(group)
    menu.combo(group, "Type", {"On All", "At Target"})("features", "snaplines_type", true, function()
        return ui_handler.elements["features"]["snaplines"]
    end)

    menu.color_picker(group, "Accent Color", color(255, 255, 255, 255))("features", "snaplines_color", true, function()
        return ui_handler.elements["features"]["snaplines"]
    end)
end)

hit_markers.data = {}

events.player_hurt:set(function(e)
    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local victim = entity.get(e.userid, true)

    if victim == nil then
        return
    end

    local attacker = entity.get(e.attacker, true)

    if attacker == nil then
        return
    end

    local r, g, b = 255, 255, 255

    if attacker == player then
        if e.hitgroup == 1 then
            r, g, b = 149, 184, 6
        end
    
        if e.dmg_health < neverlose_refs.min_damage:get() and e.health ~= 0 then
            r, g, b = 255, 0, 0
        end

        table.insert(hit_markers.data, 
            {
                position = victim:get_hitbox_position(e.hitgroup),
                damage = e.dmg_health,
                damage_clr = color(r, g, b, 255),
                alpha_kibit = 0,
                alpha_crosshair = 0,
                time = globals.realtime,
            }
        )
    end
end)

hit_markers.alpha = 0

hit_markers.handle = function()
    if not ui_handler.elements["features"]["hit_markers"] or ui_handler.elements["features"]["hit_markers_type"]._len == 0 then
        return
    end
    
    local kibit =           ui_handler.elements["features"]["hit_markers_type"]["Kibit"]
    local crosshair =       ui_handler.elements["features"]["hit_markers_type"]["Crosshair"]
    local damage =          ui_handler.elements["features"]["hit_markers_type"]["Damage"]
    local first_color =     ui_handler.elements["features"]["snaplines_first_color"]
    local second_color =    ui_handler.elements["features"]["snaplines_second_color"]
    local x, y = defines.screen_size.x/2, defines.screen_size.y/2
    for k, v in pairs(hit_markers.data) do
        local pos = render.world_to_screen(v.position)

        if v.time + 0.5 > globals.realtime then
            v.alpha_kibit = math.lerp(v.alpha_kibit, 255, 0.095)
            v.alpha_crosshair = math.lerp(v.alpha_crosshair, 255, 0.095)
        end

        if pos ~= nil then
            if kibit then
                render.rect(vector(pos.x - 5, pos.y - 1), vector(pos.x + 5, pos.y + 1), first_color:override("a", v.alpha_kibit), 0, true)
                render.rect(vector(pos.x - 1, pos.y - 5), vector(pos.x + 1, pos.y + 5), second_color:override("a", v.alpha_kibit), 0, true)
            end

            if damage then
                render.text(1, vector(pos.x-4, pos.y - 120 + ((v.time + 3) - globals.realtime)/3*100), v.damage_clr:override("a", ((v.time + 3) - globals.realtime)/3*255), nil, v.damage)
            end
        end

        if v.time + 3 < globals.realtime then
            v.alpha_kibit = math.lerp(v.alpha_kibit, 0, 0.095/3)
        end

        if v.time + 0.3 < globals.realtime then
            v.alpha_crosshair = math.lerp(v.alpha_crosshair, 0, 0.1)
        end

        if v.alpha_kibit < 0.01 and (v.time + 3 < globals.realtime) then
            table.remove(hit_markers.data, k)
        end
        hit_markers.alpha = v.alpha_crosshair
    end

    if crosshair then
        render.line(vector(x - 5, y - 5), vector(x - 10, y - 10), color(255, 255, 255, hit_markers.alpha))
        render.line(vector(x + 5, y + 5), vector(x + 10, y + 10), color(255, 255, 255, hit_markers.alpha))
        render.line(vector(x - 5, y + 5), vector(x - 10, y + 10), color(255, 255, 255, hit_markers.alpha))
        render.line(vector(x + 5, y - 5), vector(x + 10, y - 10), color(255, 255, 255, hit_markers.alpha))
    end
end

menu.switch(ui_handler.groups_name.features.additional, "Hit Markers")("features", "hit_markers", true)(function(group)
    menu.selectable(group, "Type", {"Kibit", "Crosshair", "Damage"})("features", "hit_markers_type", true, function()
        return ui_handler.elements["features"]["hit_markers"]
    end)

    menu.color_picker(group, "First Color", color(0, 255, 0, 255))("features", "snaplines_first_color", true, function()
        return ui_handler.elements["features"]["hit_markers"] and ui_handler.elements["features"]["hit_markers_type"]["Kibit"]
    end)

    menu.color_picker(group, "Second Color", color(0, 255, 255, 255))("features", "snaplines_second_color", true, function()
        return ui_handler.elements["features"]["hit_markers"] and ui_handler.elements["features"]["hit_markers_type"]["Kibit"]
    end)
end)

grenades.get = function()
    local player = entity.get_local_player()
    
    if player == nil then
        return
    end

    local position = player:get_origin()

    local CSmokeGrenadeProjectile = entity.get_entities("CSmokeGrenadeProjectile")
    local CInferno = entity.get_entities("CInferno")

    local smoke = {{position = vector(0, 0, 0), percentage = 0, alpha = 0, draw = false}}
    local molotov = {{position = vector(0, 0, 0), percentage = 0, radius = 0, alpha = 0, draw = false, teammate = false}}

    local tickcount = globals.tickcount
    local tickinterval = globals.tickinterval
    local max_render_distance = 100

    if CSmokeGrenadeProjectile ~= nil then

        for k, v in pairs(CSmokeGrenadeProjectile) do
            if smoke[k] == nil then
                smoke[k] = {}
            end

            smoke[k].percentage = (17.55 -  tickinterval * (tickcount - v.m_nSmokeEffectTickBegin))/17.55
            smoke[k].position = v:get_origin()
            smoke[k].alpha = v:get_bbox().alpha*255

            if v.m_bDidSmokeEffect and position:dist(smoke[k].position) < max_render_distance then
                smoke[k].draw = true
            end
        end
    end

    if CInferno ~= nil then
        local is_not_friendly_fire = cvar.mp_friendlyfire:int() == 0

        for k, v in pairs(CInferno) do
            if molotov[k] == nil then
                molotov[k] = {}
            end

            molotov[k].percentage = (7 -  tickinterval * (tickcount - v.m_nFireEffectTickBegin))/7
            molotov[k].position = v:get_origin()
            molotov[k].alpha = v:get_bbox().alpha*255

            local m_hOwnerEntity = v.m_hOwnerEntity

            if thrower ~= nil and is_not_friendly_fire and m_hOwnerEntity ~= player and not m_hOwnerEntity:is_enemy() then
                molotov[k].teammate = true
            end

            local Cell_Radius = 40
            local Molotov_Radius = 0
            local Cells = {}
            local Maximum_Distance = 0
            local Cell_Max_A, Cell_Max_B
            for i = 1, 64 do
                if v.m_bFireIsBurning[i] == true then
                    table.insert(Cells, vector(v.m_fireXDelta[i], v.m_fireYDelta[i], v.m_fireZDelta[i]))
                end
            end

            local cells_num = #Cells
            for v = 1, cells_num do
                for k = 1, cells_num do
                    local Distance = Cells[v]:dist(Cells[k])
                    if Distance > Maximum_Distance then
                        Maximum_Distance = Distance
                        Cell_Max_A = Cells[v]
                        Cell_Max_B = Cells[k]
                    end
                end
            end

            if Cell_Max_A ~= nil and Cell_Max_B ~= nil and position:dist(molotov[k].position) < max_render_distance then
                molotov[k].draw = true
                molotov[k].radius = (Maximum_Distance/2 + Cell_Radius)
            end
        end
    end

    return {smoke = smoke, molotov = molotov}
end

grenades.handle = function()
    if not ui_handler.elements["features"]["grenade_radius"] or ui_handler.elements["features"]["grenade_radius_type"]._len == 0 then
        return
    end

    local grenade_radius_style = ui_handler.elements["features"]["grenade_radius_style"]

    local molotov_enabled = ui_handler.elements["features"]["grenade_radius_type"]["Molotov"]
    local smoke_enabled   = ui_handler.elements["features"]["grenade_radius_type"]["Smoke"]

    if not molotov_enabled and not smoke_enabled then
        return
    end

    local grenade = grenades.get()
    
    if grenade == nil then
        return
    end

    local enemy_molotov_color = ui_handler.elements["features"]["grenade_radius_enemy_molotov_color"]
    local team_molotov_color = ui_handler.elements["features"]["grenade_radius_team_molotov_color"]
    local smoke_color = ui_handler.elements["features"]["grenade_radius_smoke_color"]

    local magic_alpha_molotov = {
        team =  {
            team_molotov_color.a / 255,
            team_molotov_color:override("a", 0),
            team_molotov_color
        },
        enemy = {
            enemy_molotov_color.a / 255,
            enemy_molotov_color:override("a", 0),
            enemy_molotov_color
        }
    }

    local anim = {}

    anim.molotov_radius = {}
    for i = 1, #grenade.molotov do
        local v = grenade.molotov[i]
        anim.molotov_radius[i] = animations.new("molotov_radius_" .. i, v.draw and v.radius or 0, 0.095)
        if v.draw and molotov_enabled then
            local clr = magic_alpha_molotov[v.teammate and "team" or "enemy"]
            if grenade_radius_style == "Outline" then
                render.circle_3d_outline (v.position, clr[3]:override("a", clr[1] * v.alpha), anim.molotov_radius[i], 0, 1, 1.5)
            elseif grenade_radius_style == "Filled" then
                render.circle_3d(v.position, clr[3]:override("a", clr[1] * v.alpha), anim.molotov_radius[i], 0, 1)
                render.circle_3d_outline (v.position, clr[3]:override("a", clr[1] * v.alpha), anim.molotov_radius[i], 0, v.percentage, 1.5)
            else
                render.circle_3d_gradient(v.position, clr[3]:override("a", clr[1] * v.alpha / 2), clr[2], anim.molotov_radius[i], 0, 1)
                render.circle_3d_outline (v.position, clr[3]:override("a", clr[1] * v.alpha), anim.molotov_radius[i], 0, v.percentage, 1.5)
            end
        end
    end

    local magic_alpha_smoke = smoke_color.a / 255
    local smoke_zero_alpha = smoke_color:override("a", 0)

    anim.smoke_radius = {}
    for i = 1, #grenade.smoke do
        local v = grenade.smoke[i]
        anim.smoke_radius[i] = animations.new("smoke_radius_" .. i, v.draw and 125 or 0, 0.095)
        if v.draw and smoke_enabled then
            local clr = smoke_color
            if grenade_radius_style == "Outline" then
                render.circle_3d_outline(v.position, clr:override("a",  magic_alpha_smoke * v.alpha), anim.smoke_radius[i], 0, 1, 1.5)
            elseif grenade_radius_style == "Filled" then
                render.circle_3d(v.position, clr:override("a", magic_alpha_smoke * v.alpha), anim.smoke_radius[i], 0, 1)
                render.circle_3d_outline(v.position, clr:override("a",  magic_alpha_smoke * v.alpha), anim.smoke_radius[i], 0, v.percentage, 1.5)
            else
                render.circle_3d_gradient(v.position, clr:override("a", magic_alpha_smoke * v.alpha / 2), smoke_zero_alpha, anim.smoke_radius[i], 0, 1)
                render.circle_3d_outline(v.position, clr:override("a",  magic_alpha_smoke * v.alpha), anim.smoke_radius[i], 0, v.percentage, 1.5)
            end
        end
    end
end

menu.switch(ui_handler.groups_name.features.additional, "Grenade Radius")("features", "grenade_radius", true)(function(group)
    menu.selectable(group, "Grenades", {"Molotov", "Smoke"})("features", "grenade_radius_type", true, function()
        return ui_handler.elements["features"]["grenade_radius"]
    end)

    menu.combo(group, "Style", {"Outline", "Gradient", "Filled"})("features", "grenade_radius_style", true, function()
        return ui_handler.elements["features"]["grenade_radius"] and (ui_handler.elements["features"]["grenade_radius_type"]["Molotov"] or ui_handler.elements["features"]["grenade_radius_type"]["Smoke"])
    end)

    menu.color_picker(group, "Enemy Molotov Color", color(245, 90, 90, 255))("features", "grenade_radius_enemy_molotov_color", true, function()
        return ui_handler.elements["features"]["grenade_radius"] and ui_handler.elements["features"]["grenade_radius_type"]["Molotov"]
    end)

    menu.color_picker(group, "Team Molotov Color", color(90, 245, 90, 255))("features", "grenade_radius_team_molotov_color", true, function()
        return ui_handler.elements["features"]["grenade_radius"] and ui_handler.elements["features"]["grenade_radius_type"]["Molotov"]
    end)

    menu.color_picker(group, "Smoke Color", color(130, 130, 255, 255))("features", "grenade_radius_smoke_color", true, function()
        return ui_handler.elements["features"]["grenade_radius"] and ui_handler.elements["features"]["grenade_radius_type"]["Smoke"]
    end)
end)

--це пиздец
speed_warning.bytes = {
    [[<svg width="23" height="25" viewBox="0 0 23 25" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M11.0424 3.70542C11.0424 2.97256 11.2582 2.25615 11.6625 1.6468C12.0667 1.03745 12.6414 0.562514 13.3137 0.28206C13.986 0.00160549 14.7257 -0.0717742 15.4394 0.0712003C16.1532 0.214175 16.8087 0.567081 17.3233 1.08529C17.8378 1.60351 18.1883 2.26375 18.3302 2.98253C18.4722 3.70131 18.3993 4.44635 18.1209 5.12342C17.8424 5.8005 17.3708 6.37921 16.7657 6.78636C16.1607 7.19352 15.4493 7.41084 14.7217 7.41084C13.7468 7.40779 12.8127 7.01641 12.1234 6.32217C11.434 5.62793 11.0454 4.68722 11.0424 3.70542ZM23 12.6911C23 12.4454 22.9031 12.2098 22.7306 12.036C22.5581 11.8623 22.3241 11.7647 22.0802 11.7647C21.932 11.7635 21.7858 11.7993 21.6548 11.8689H21.6663C21.6548 11.8689 20.9189 12.2279 19.5737 12.0889C18.2285 11.95 16.1819 11.3478 13.4454 9.18249C11.7208 7.8277 9.04179 6.33395 6.04089 6.91292C4.22425 7.26031 3.17796 8.19824 3.06298 8.30246C2.97256 8.38373 2.89921 8.48241 2.84724 8.59267C2.79527 8.70293 2.76574 8.82256 2.76039 8.94449C2.75503 9.06643 2.77395 9.18821 2.81605 9.30266C2.85814 9.41712 2.92256 9.52193 3.00549 9.61093C3.17019 9.79207 3.39957 9.89993 3.64321 9.91079C3.88685 9.92164 4.12479 9.83461 4.30473 9.66883C4.43121 9.55304 7.27114 7.07504 11.7322 10.2015C11.1857 12.0455 10.3344 13.7836 9.21425 15.3428L8.93831 15.7017C6.76524 18.5039 4.09777 19.7545 1.01639 19.4419C0.772438 19.4173 0.528788 19.4913 0.339039 19.6477C0.14929 19.804 0.0289856 20.0299 0.00459052 20.2756C-0.0198045 20.5213 0.0537085 20.7667 0.208958 20.9578C0.364207 21.1489 0.588475 21.27 0.832425 21.2946C1.21185 21.3293 1.56828 21.3409 1.92471 21.3409C5.67296 21.3409 8.43241 19.3261 10.341 16.906C12.5716 17.5081 16.5613 19.245 16.5613 24.0736C16.5613 24.3193 16.6582 24.555 16.8307 24.7287C17.0032 24.9024 17.2372 25 17.4811 25C17.7251 25 17.959 24.9024 18.1315 24.7287C18.304 24.555 18.4009 24.3193 18.4009 24.0736C18.4009 21.2135 17.2397 18.8166 15.0436 17.1376C13.8478 16.2228 12.5141 15.6554 11.4563 15.308C12.2176 14.0671 12.8349 12.7422 13.2959 11.3594C16.2623 13.4321 18.6079 13.9416 20.1946 13.9416C21.7812 13.9416 22.4366 13.5364 22.5056 13.49C22.653 13.4155 22.7771 13.3015 22.8643 13.1606C22.9516 13.0196 22.9985 12.8571 23 12.6911Z" fill="white"/></svg>]]
}

speed_warning.image_running = render.load_image(speed_warning.bytes[1], vector(23, 25))

speed_warning.handle = function()
    local anim = {}
    anim.main = animations.new("speed_warning_main", ui_handler.elements["features"]["speed_warning"] and 255 or 0)

    if anim.main < 1 then
        return
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local m_flVelocityModifier = ui.get_alpha() > 0 and player.m_flVelocityModifier == 1 and 1-ui.get_alpha()/2 or player:is_alive() and player.m_flVelocityModifier or 1
    
    anim.speed_warning = animations.new("speed_warning", ui_handler.elements["features"]["speed_warning"] and (ui.get_alpha() > 0 and draggables.current_drugging_item == "speed_warning" and 100 or m_flVelocityModifier ~= 1 and 255) or 0)

    local pos = vector(ui_handler.elements["drag"]["speed_warning_pos_x"], ui_handler.elements["drag"]["speed_warning_pos_y"])
    local speed_warning_accent_color = ui_handler.elements["features"]["speed_warning_accent_color"]

    --triangle
    if ui_handler.elements["features"]["speed_warning_style"] == "Circled" then
        render.circle(vector(pos.x + 60, pos.y + 30), colors.black:override("a", anim.speed_warning/2), 24, 0, 1)
        render.circle_outline(vector(pos.x + 60, pos.y + 30), speed_warning_accent_color:override("a", anim.speed_warning), 25, 0, m_flVelocityModifier, 3)
        render.texture(speed_warning.image_running, vector(pos.x + 51, pos.y + 19), vector(18, 20), colors.white:override("a", anim.speed_warning))
        draggables.drag_handle(pos.x, pos.y, 120, 60, "speed_warning", anim.main)
    else
        visuals.render_container(70, 8, "  Speed", "speed_warning", anim.speed_warning, nil, speed_warning_accent_color:override("a", anim.speed_warning))
        render.rect(vector(pos.x + 43, pos.y + 6), vector(pos.x + 102, pos.y + 16), speed_warning_accent_color:override("a", anim.speed_warning/3), 4)
        render.rect(vector(pos.x + 44, pos.y + 8), vector(pos.x + m_flVelocityModifier*55 + 45, pos.y + 14), speed_warning_accent_color:override("a", anim.speed_warning), 4)
    end
end

menu.switch(ui_handler.groups_name.features.additional, "Speed Warning")("features", "speed_warning", true)(function(group)

    menu.combo(group, "Style", {"Circled", "Rounded"})("features", "speed_warning_style", true, function()
        return ui_handler.elements["features"]["speed_warning"]
    end)

    menu.color_picker(group, "Accent Color")("features", "speed_warning_accent_color", true, function()
        return ui_handler.elements["features"]["speed_warning"]
    end)
end)

local scope_overlay = {}

scope_overlay.rotation = 0
scope_overlay.shadow_anim = 0
scope_overlay.handle = function()
    local scope_overlay_enable =       ui_handler.elements["features"]["scope_overlay"]

    if not scope_overlay_enable then
        return
    end
    
    neverlose_refs.override("scope_overlay", "Remove All")

    local scope_overlay_style =        ui_handler.elements["features"]["scope_overlay_style"]
    local spread_dependensy =          ui_handler.elements["features"]["scope_overlay_spread"]
    local scope_overlay_size =         ui_handler.elements["features"]["scope_overlay_size"]
    local scope_overlay_gap =          ui_handler.elements["features"]["scope_overlay_gap"]
    local scope_overlay_accent_color = ui_handler.elements["features"]["scope_overlay_accent_color"]
    local scope_overlay_breath_color = ui_handler.elements["features"]["scope_overlay_breath_color"]
    local scope_overlay_glow         = ui_handler.elements["features"]["scope_overlay_glow"]

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local weapon = player:get_player_weapon()

    if weapon == nil then
        return
    end

    local m_bIsScoped = createmove.shared_data.scoped

    local anim = animations.new("scope_overlay", scope_overlay_enable and m_bIsScoped and 1 or 0)
    
    if anim < 0.1 then
        return
    end

    local spread = spread_dependensy and animations.new("spread_dependensy", weapon:get_inaccuracy()*75) + scope_overlay_gap or scope_overlay_gap

    local clr = {
        scope_overlay_accent_color:override("a", scope_overlay_accent_color.a * anim),
        scope_overlay_breath_color:override("a", scope_overlay_breath_color.a * anim)
    }

    scope_overlay_size = scope_overlay_size * anim
    
    local position = defines.screen_size/2


    scope_overlay.rotation = animations.new("scop_ratator", scope_overlay_style == "X" and 45 or 0)
    scope_overlay.shadow_anim = animations.new("scope_shadow_anim", scope_overlay_glow and 15 or 1)

    if scope_overlay.rotation ~= 0 then
        render.push_rotation(scope_overlay.rotation, defines.screen_size / 2)
    end



    if scope_overlay.shadow_anim ~= 1 then
        -- left
        render.shadow(
            position - vector(scope_overlay_size + spread, -1), position - vector(spread, 0),
            clr[1],
            scope_overlay.shadow_anim
        )

        -- right
        render.shadow(
            position + vector(spread, 1), position + vector(scope_overlay_size + spread, 0),
            clr[1],
            scope_overlay.shadow_anim
        )

        -- footer
        render.shadow(
            position + vector(0, spread), position + vector(-1, scope_overlay_size + spread),
            clr[1],
            scope_overlay.shadow_anim
        )
    end

    

    render.gradient(position - vector(scope_overlay_size + spread, -1), position - vector(spread, 0), clr[2], clr[1], clr[2], clr[1])

    render.gradient(position + vector(scope_overlay_size + spread, 1), position + vector(spread, 0), clr[2], clr[1], clr[2], clr[1])
    if scope_overlay_style ~= "T" then

        -- header

        if scope_overlay.shadow_anim ~= 1 then
            render.shadow(
                position - vector(-1, scope_overlay_size + spread), position - vector(0, spread),
                clr[1],
                scope_overlay.shadow_anim
            )
        end

        render.gradient(position - vector(-1, scope_overlay_size + spread), position - vector(0, spread), clr[2], clr[2], clr[1], clr[1])
    end


    render.gradient(position + vector(1, scope_overlay_size + spread), position + vector(0, spread), clr[2], clr[2], clr[1], clr[1])

    if scope_overlay.rotation ~= 0 then
        render.pop_rotation()
    end

end

menu.switch(ui_handler.groups_name.features.additional, "Scope Overlay")("features", "scope_overlay", true)(function(group)
    menu.combo(group, "Style", {"Default", "T", "X"})("features", "scope_overlay_style", true, function()
        return ui_handler.elements["features"]["scope_overlay"]
    end)

    menu.switch(group, "Spread Dependensy")("features", "scope_overlay_spread", true, function()
        return ui_handler.elements["features"]["scope_overlay"]
    end)

    menu.switch(group, "Glow")("features", "scope_overlay_glow", true, function()
        return ui_handler.elements["features"]["scope_overlay"]
    end)

    menu.slider(group, "Size", 0, 300, 100)("features", "scope_overlay_size", true, function()
        return ui_handler.elements["features"]["scope_overlay"]
    end)

    menu.slider(group, "Gap", 0, 300, 5)("features", "scope_overlay_gap", true, function()
        return ui_handler.elements["features"]["scope_overlay"]
    end)

    menu.color_picker(group, "First Color", colors.white)("features", "scope_overlay_accent_color", true, function()
        return ui_handler.elements["features"]["scope_overlay"]
    end)

    menu.color_picker(group, "Second Color", colors.white:override("a", 0))("features", "scope_overlay_breath_color", true, function()
        return ui_handler.elements["features"]["scope_overlay"]
    end)
end)

local_player_angles.text_line = function(str, dst, location, origin, yaw, clr)
    location = vector(location.x + math.cos(math.rad(yaw))*dst, location.y + math.sin(math.rad(yaw))*dst, location.z)

	local world = render.world_to_screen(location)

    if world == nil then return end

    render.line(origin, world, clr)
    render.text(2, world - vector(5, 5), clr, nil, str)
end

local_player_angles.handle = function()
    local enabled = ui_handler.elements["features"]["local_player_angles"] and ui_handler.elements["features"]["local_player_angles_type"]._len ~= 0

    local anim = {}

    anim.main = animations.new("local_player_angles", enabled and 255 or 0)

    if anim.main < 1 then
        return
    end

    local player = entity.get_local_player()

    if player == nil or not player:is_alive() then
        return
    end

    if not common.is_in_thirdperson() then
        return
    end

    local player_pos = player:get_origin()
	player_pos.z = player_pos.z + 1

    local world = render.world_to_screen(player_pos)

    local local_player_angles_type = ui_handler.elements["features"]["local_player_angles_type"]


    anim.real = animations.new("local_player_angles_real", enabled and local_player_angles_type["Real"] and 255 or 0)

    if anim.real > 1 then
        local yaw = rage.antiaim:get_rotation() + player.m_flPoseParameter[11] * 120 - 60

        local_player_angles.text_line("REAL", 30, player_pos, world, yaw, ui_handler.elements["features"]["local_player_angles_real"]:override("a", anim.real))
    end

    anim.fake = animations.new("local_player_angles_fake", enabled and local_player_angles_type["Fake"] and 255 or 0)

    if anim.fake > 1 then
        local yaw = player.m_angEyeAngles.y

        local_player_angles.text_line("FAKE", 30, player_pos, world, yaw, ui_handler.elements["features"]["local_player_angles_fake"]:override("a", anim.fake))
    end

    anim.camera = animations.new("local_player_angles_camera", enabled and local_player_angles_type["Camera"] and 255 or 0)

    if anim.camera > 1 then
        local yaw = render.camera_angles().y

        local_player_angles.text_line("CAM", 30, player_pos, world, yaw, ui_handler.elements["features"]["local_player_angles_camera"]:override("a", anim.camera))
    end
end

menu.switch(ui_handler.groups_name.features.additional, "Local Player Angles")("features", "local_player_angles", true)(function(group)
    menu.selectable(group, "Additional", {"Real", "Fake", "Camera"})("features", "local_player_angles_type", true, function()
        return ui_handler.elements["features"]["local_player_angles"]
    end)

    menu.color_picker(group, "Real Color", color(28, 132, 255, 220))("features", "local_player_angles_real", true, function()
        return ui_handler.elements["features"]["local_player_angles"] and ui_handler.elements["features"]["local_player_angles_type"]["Real"]
    end)

    menu.color_picker(group, "Fake Color", color(0, 164, 52, 220))("features", "local_player_angles_fake", true, function()
        return ui_handler.elements["features"]["local_player_angles"] and ui_handler.elements["features"]["local_player_angles_type"]["Fake"]
    end)

    menu.color_picker(group, "Camera Color", color(255, 255, 255, 220))("features", "local_player_angles_camera", true, function()
        return ui_handler.elements["features"]["local_player_angles"] and ui_handler.elements["features"]["local_player_angles_type"]["Camera"]
    end)
end)

thanos_snap.cvar = cvar.cl_ragdoll_physics_enable
thanos_snap.cvar_int_raw = cvar.cl_ragdoll_physics_enable.int
thanos_snap.last_update = math.floor(globals.realtime)
thanos_snap.handle = function()
    
    local desired_value = ui_handler.elements["features"]["thanos_snap"] and 0 or 1
    local actual_value = thanos_snap.cvar_int_raw(thanos_snap.cvar)

    if desired_value ~= actual_value then
        thanos_snap.cvar_int_raw(thanos_snap.cvar, ui_handler.elements["features"]["thanos_snap"] and 0 or 1)
    end
end

thanos_snap.destroy = function()
    thanos_snap.cvar:int(1)
end

menu.switch(ui_handler.groups_name.features.additional, "Thanos Snap")("features", "thanos_snap", true)

console_color.material = {"vgui_white", "vgui/hud/800corner1", "vgui/hud/800corner2", "vgui/hud/800corner3", "vgui/hud/800corner4"}

console_color.last = color(0, 0, 0, 255)
console_color.change = function(clr)
    if console_color.last ~= clr then
        for _, mat in pairs(console_color.material) do
            materials.get_materials(mat)[1]:alpha_modulate(clr.a/255)
            materials.get_materials(mat)[1]:color_modulate(color(clr.r, clr.g, clr.b))
        end
        console_color.last = clr
    end
end

console_color.handle = function()

    local clr = (ui_handler.elements["features"]["console_color_changer"] and ffi_handler.console_is_visible()) and ui_handler.elements["features"]["console_color_changer_color"] or colors.white
    console_color.change(clr)
end

menu.switch(ui_handler.groups_name.features.miscellaneous, "Console Color")("features", "console_color_changer", true)(function(group)
    menu.color_picker(group, "Accent Color", color(255, 255, 255, 255))("features", "console_color_changer_color", true, function()
        return ui_handler.elements["features"]["console_color_changer"]
    end)
end)

aspect_ratio.cvar = cvar.r_aspectratio
aspect_ratio.cvar_float_raw = aspect_ratio.cvar.float

aspect_ratio.handle = function(init)

    local desired_value = animations.new("aspect_ratio", ui_handler.elements["features"]["aspect_ratio_changer_value"] / 100, nil, ui_handler.elements["features"]["aspect_ratio_changer_value"] / 100)

    if ui_handler.elements["features"]["aspect_ratio_changer_value"] == 50 then
        desired_value = 0
    end

    if not ui_handler.elements["features"]["aspect_ratio_changer"] then
        desired_value = 0
    end

    local actual_value = aspect_ratio.cvar_float_raw(aspect_ratio.cvar)

    if desired_value ~= actual_value then
        aspect_ratio.cvar_float_raw(aspect_ratio.cvar, desired_value)
    end

end

aspect_ratio.destroy = function()
    aspect_ratio.cvar_float_raw(aspect_ratio.cvar, 0)
end

aspect_ratio.ratios = {
    [177] = "16:9",
    [161] = "16:10",
    [150] = "3:2",
    [133] = "4:3",
    [125] = "5:4",
}

menu.switch(ui_handler.groups_name.features.miscellaneous, "Aspect Ratio")("features", "aspect_ratio_changer", true)(function(group)
    menu.slider(group, "Value", 50, 300, 0, 0.01, function(value) 
        return aspect_ratio.ratios[value] or value == 50 and 0 
    end)("features", "aspect_ratio_changer_value", true, function()
        return ui_handler.elements["features"]["aspect_ratio_changer"]
    end)

    local itter = 0
    for k, v in pairs(aspect_ratio.ratios) do
        itter = itter + 1
        menu.button(group, v, function()
            ui_handler.refs["features"]["aspect_ratio_changer_value"].ref:set(k)
        end, true)("features", "aspect_ratio_changer_" .. itter, false, function()
            return ui_handler.elements["features"]["aspect_ratio_changer"]
        end)
    end

end)

viewmodel.cvars = {
    viewmodel_fov       = cvar.viewmodel_fov,
    viewmodel_offset_x  = cvar.viewmodel_offset_x,
    viewmodel_offset_y  = cvar.viewmodel_offset_y,
    viewmodel_offset_z  = cvar.viewmodel_offset_z
}

viewmodel.handle = function()
    if ui_handler.elements["features"]["viewmodel_changer"] then
        viewmodel.cvars.viewmodel_fov      :float(ui_handler.elements["features"]["viewmodel_changer_fov"  ]   , true)
        viewmodel.cvars.viewmodel_offset_x :float(ui_handler.elements["features"]["viewmodel_changer_x"    ]   , true)
        viewmodel.cvars.viewmodel_offset_y :float(ui_handler.elements["features"]["viewmodel_changer_y"    ]   , true)
        viewmodel.cvars.viewmodel_offset_z :float(ui_handler.elements["features"]["viewmodel_changer_z"    ]   , true)
    else
        viewmodel.cvars.viewmodel_fov      :float(68   )
        viewmodel.cvars.viewmodel_offset_x :float(2.5  )
        viewmodel.cvars.viewmodel_offset_y :float(0    )
        viewmodel.cvars.viewmodel_offset_z :float(-1.5 )
    end
end

viewmodel.destroy = function()
    viewmodel.cvars.viewmodel_fov      :float(68   )
    viewmodel.cvars.viewmodel_offset_x :float(2.5  )
    viewmodel.cvars.viewmodel_offset_y :float(0    )
    viewmodel.cvars.viewmodel_offset_z :float(-1.5 )
end

menu.switch(ui_handler.groups_name.features.miscellaneous, "Viewmodel")("features", "viewmodel_changer", true)(function(group)
    menu.slider(group, "FOV", 0, 100, 68)("features", "viewmodel_changer_fov", true, function()
        return ui_handler.elements["features"]["viewmodel_changer"]
    end)
    menu.slider(group, "X", -10, 10, 1)("features", "viewmodel_changer_x", true, function()
        return ui_handler.elements["features"]["viewmodel_changer"]
    end)
    menu.slider(group, "Y", -10, 10, 1)("features", "viewmodel_changer_y", true, function()
        return ui_handler.elements["features"]["viewmodel_changer"]
    end)
    menu.slider(group, "Z", -10, 10, -1)("features", "viewmodel_changer_z", true, function()
        return ui_handler.elements["features"]["viewmodel_changer"]
    end)
    menu.button(group, "                    Default Values                    ", function()
        ui_handler.refs["features"]["viewmodel_changer_fov"  ].ref:set(68   )
        ui_handler.refs["features"]["viewmodel_changer_x"    ].ref:set(2.5  )
        ui_handler.refs["features"]["viewmodel_changer_y"    ].ref:set(0    )
        ui_handler.refs["features"]["viewmodel_changer_z"    ].ref:set(-1.5 )
    end, true)("features", "viewmodel_changer_default", false, function()
        return ui_handler.elements["features"]["viewmodel_changer"]
    end)
end)

unmute_silenced.toggle_mute = panorama.FriendsListAPI.ToggleMute
unmute_silenced.is_muted = panorama.FriendsListAPI.IsSelectedPlayerMuted


unmute_silenced.handle = function()
    if not ui_handler.elements["features"]["mute_everyone"] then
        return
    end

    local combo_status = ui_handler.elements["features"]["mute_everyone_settings"]

    local players = entity.get_players(ui_handler.elements["features"]["mute_enemy"], true, function(player)
        local info = player:get_player_info()
        local steamid64 = info.steamid64
        local is_muted = unmute_silenced.is_muted(steamid64)

        if combo_status == "Unmute" and is_muted then
            unmute_silenced.toggle_mute(steamid64)
        elseif combo_status == "Mute" and not is_muted then
            unmute_silenced.toggle_mute(steamid64)
        end
    end)
end

menu.switch(ui_handler.groups_name.features.miscellaneous, "Auto Mute/Unmute")("features", "mute_everyone", true)(function(group)
    menu.switch(group, "Only Enemy")("features", "mute_enemy", true, function()
        return ui_handler.elements["features"]["mute_everyone"]
    end)():set_callback(unmute_silenced.handle)

    menu.combo(group, "Settings", {"Mute", "Unmute"})("features", "mute_everyone_settings", true, function()
        return ui_handler.elements["features"]["mute_everyone"]
    end)():set_callback(unmute_silenced.handle)
end):set_callback(unmute_silenced.handle)

sync.clr_changed = false
sync.latest_send = -1
sync.change_delay = 0.5
menu.switch(ui_handler.groups_name.features.miscellaneous, "Shared Features")("features", "shared_features")(function(group)
    menu.switch(group, "Nymbus")("features", "nymbus")()
    menu.switch(group, "Show on Self")("features", "nymbus_self", true, function()
        return ui_handler.elements["features"]["nymbus"]
    end)()

    menu.color_picker(group, "Nymbus Color", color(255, 255, 0, 255))("features", "nymbus_clr")():set_callback(function(val)
        sync.clr_changed = true
        sync.latest_send = globals.realtime + sync.change_delay
    end)

    menu.list(group, "Icon", {"Anime 1"})("features", "icon")():visibility(false)
end)

sync.handle_clr_update = function()

end

clantag.cache = nil
clantag.set = function(str)
    if str ~= clantag.cache then
        common.set_clan_tag(str)
        clantag.cache = str
    end
end

clantag.anim = function(text, indices)
    local net_channel = utils.net_channel()
    if net_channel == nil then return end

    local text_anim = "               " .. text .. "                      " 
    local latency = net_channel.latency[0] / globals.tickinterval
    local tickcount = globals.tickcount + latency
    local i = tickcount / (0.3 / globals.tickinterval)
    i = math.floor(i % #indices)
    i = indices[i+1]+1

    return string.sub(text_anim, i, i+15)
end

clantag.clear = function()
    clantag.set("")
end

clantag.handle = function()
    if not ui_handler.elements["features"]["clantag"] then
        return
    end

    if not globals.is_connected then 
        return 
    end

    local net_channel = utils.net_channel()
    if net_channel == nil then return end

    local tbl = {
        ["Branded"] = "drainyaw.nl",
        ["GameSense"] = "gamesense",
        ["Custom"] = ui_handler.elements["features"]["clantag_custom"]
    }

    local text = clantag.anim(tbl[ui_handler.elements["features"]["clantag_type"]], {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22})

    clantag.set(text)
end

menu.switch(ui_handler.groups_name.features.miscellaneous, "Clantag")("features", "clantag", true)(function(group)
    menu.combo(group, "Type", {"Branded", "GameSense", "Custom"})("features", "clantag_type", true, function()
        return ui_handler.elements["features"]["clantag"]
    end)
    menu.input(group, "")("features", "clantag_custom", true, function()
        return ui_handler.elements["features"]["clantag"] and ui_handler.elements["features"]["clantag_type"] == "Custom"
    end)
end):set_callback(clantag.clear)

taskbar_notify.get_csgo_hwnd = function()
    return ffi_handler.hwnd_ptr[0]
end

taskbar_notify.get_foreground_hwnd = function()
    return ffi_handler.insn_jmp_ecx(ffi_handler.GetForegroundWindow)
end

taskbar_notify.notify_user = function()
    local csgo_hwnd = taskbar_notify.get_csgo_hwnd()
    if ui_handler.elements["features"]["alert_on_round"] and taskbar_notify.get_foreground_hwnd() ~= csgo_hwnd then
        ffi_handler.flash_window(csgo_hwnd, 1)
    end
end

events.round_start:set(function()
    taskbar_notify.notify_user()
end)

menu.switch(ui_handler.groups_name.features.miscellaneous, "Alert on New Round")("features", "alert_on_round", true)

createmove.shared_data = {
    scoped = false,
    movetype = -1,
    pin_pulled = false,
    throw_time = 0
}

createmove.collect_shared = function()
    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local weapon = player:get_player_weapon()

    if weapon == nil then
        return
    end

    createmove.shared_data.scoped = player.m_bIsScoped
    createmove.shared_data.movetype = player.m_MoveType
    createmove.shared_data.pin_pulled = weapon.m_bPinPulled
    createmove.shared_data.throw_time = weapon.m_fThrowTime
end

neverlose_refs.last_update = globals.tickcount
callbacks.register("createmove", "createmove.collect_shared", createmove.collect_shared)
callbacks.register("createmove", "conditions_update", conditional_antiaims.handle_update)
callbacks.register("createmove", "antiaim_on_use.handle", antiaim_on_use.handle)
callbacks.register("createmove", "fast_ladder", fast_ladder.handle)
callbacks.register("createmove", "edge_yaw.on_edge", edge_yaw.on_edge)
callbacks.register("createmove", "exploit_manipulations.handle", exploit_manipulations.handle)
callbacks.register("createmove", "easy_peek", easy_peek.handle)
callbacks.register("createmove", "head_only", head_only.handle)
callbacks.register("createmove", "yaw_base_sanitizer", conditional_antiaims.set_yaw_base)
callbacks.register("createmove", "exploit_discharge", exploit_discharge.handle)
--
callbacks.register("round_start", "anti-silencer", unmute_silenced.handle)

callbacks.register("createmove", "shaking_model", function(cmd)
    cmd.animate_move_lean = ui_handler.elements["aa"]["enable"] and ui_handler.elements["aa"]["anim_breakers"] and (ui_handler.elements["aa"]["anim_breakers_additional"]["Move Lean"] or false)
end)
callbacks.register("createmove", "reverse_overrides", function()
    local tick = globals.tickcount

    if tick == neverlose_refs.last_update then
        return
    end

    neverlose_refs.last_update = tick
    neverlose_refs.deoverride_unused()

end)

local kbytes_used = {}

callbacks.register("render", "main_render", function()

    if _DEBUG then
        table.insert(kbytes_used, 1, collectgarbage("count"))

        if #kbytes_used > 150 then
            table.remove(kbytes_used, 150)
        end

        local kbytes_active = 0
        for k, v in ipairs(kbytes_used) do
            kbytes_active = kbytes_active + v
        end

        render.text(1, vector(100, 100), colors.white, nil, string.format("memory: %.2f", kbytes_active / #kbytes_used)) 
    end

    draggables.hovered_something = false
    visuals.per_second_update()
    visuals.shadow_frac = visuals.update_shadow_frac()

    visuals.render_container(0, nil, visuals.build_watermark_text(), "watermark", ui_handler.elements["features"]["solus_watermark"])

    local enabled = visuals.build_binds(ui_handler.elements["features"]["solus_keybinds"])
    visuals.render_container(visuals.binds_width2 - 30, nil, "Keybinds", "keybinds", enabled)

    local enabled = visuals.build_specs(ui_handler.elements["features"]["solus_spectators"])
    visuals.render_container(visuals.specs_width - 38, nil, "Spectators", "spectators", enabled)
end)

callbacks.register("render", "icon", sync.icon)
callbacks.register("render", "nymb", sync.nymbus)
callbacks.register("render", "indicators", indicators.handle)
callbacks.register("render", "snaplines", snaplines.handle)
callbacks.register("render", "grenade_radius", grenades.handle)
callbacks.register("render", "console_color", console_color.handle)
callbacks.register("render", "aspect_ratio", aspect_ratio.handle)
callbacks.register("render", "viewmodel", viewmodel.handle)
--callbacks.register("render", "aimbot_logger", aimbot_logger.handle)
callbacks.register("render", "revolver_helper", revolver_helper.handle)
callbacks.register("render", "hit_markers", hit_markers.handle)
callbacks.register("render", "thanos_snap", thanos_snap.handle)
callbacks.register("render", "local_player_angles", local_player_angles.handle)
callbacks.register("render", "clantag", clantag.handle)
callbacks.register("render", "speed_warning", speed_warning.handle)
callbacks.register("render", "scope_overlay", scope_overlay.handle)
callbacks.register("render", "gamesense", gamesense.handle)
callbacks.register("render", "gamesense_spectators", gamesense.spectators)
callbacks.register("render", "sync.handle_clr_update", sync.handle_clr_update)

callbacks.register("player_spawned", "update_info", function()
    sync.applied_info = {}
    sync.last_local_icon = nil
end)

callbacks.register("shutdown", "unload", function()

    
    print_dev("Closing server connection!")

    neverlose_refs.deoverride_unused(true)

    entity.get_players(false, true, function(ptr)

        ptr:set_icon()

    end)

end)

callbacks.register("shutdown", "aspect_ratio", aspect_ratio.destroy)
callbacks.register("shutdown", "viewmodel", viewmodel.destroy)
callbacks.register("shutdown", "thanos_snap", thanos_snap.destroy)

--menu.button(ui_handler.groups_name.setup.information, "parse tooltips", function()
--    safecall("parse tooltip", true, function()
--        ui_handler.configs.parse_json_tooltips()
--    end)()
--end, true)
--
--menu.button(ui_handler.groups_name.setup.information, "apply tooltips", function()
--
--    safecall("apply tooltip", true, function()
--        ui_handler.configs.apply_tooltips(json.decode(clipboard.get()))  
--    end)()
--
--end, true)
ui.sidebar("DrainYaw Alpha", ui_handler.get_icon("paw"))
ui_handler.global_update_callback()