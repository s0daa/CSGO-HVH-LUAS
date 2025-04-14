-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- Paradox by Roger --------------------------------------------------------------------------------
                                                                                         
--[[
                                  G55P5555555YYYYY5555555PPPP#                                      
                                    &P7~^^^^^::::...:::^^^~~~~~!Y#                                    
                                       G7~^^^^:::::..::^^^~~~!!~~~JB                                  
                                         BPPPPPPPPPPPPPPPGGG57~~~~^~?B                                
                                             BGGGGGGGGGGBBBB  P7~~~~^~?G                              
                                             B55555555555PPJ?P  G?~~~~^^7P&                           
                                                            #Y?P& G?~~~^^:~B                          
                                                              G~7& &?~~^^^.5                          
                                                            BJ?P&#Y!~~~^^^7#                          
                                            &5YYYYYYYYY5555J?G #Y!~~~~^~?B                            
                                            &BBBBBBBBBBBBBB# BJ!~!!~~!Y#                              
                                        #PPPPPPPPPPPPPPPPGGG?~^~~~~!5#                                
                                      #J::::::::::::::::^^^~~~~^^!5&                                  
                                    B?~^::.:::::::::::::^^^~~~~75&                                    
                                   P^^~~^:!JJJJJJJJJJJJJJYYYYYG                                       
                                   5:^~~~^Y                                                           
                                   P^^~~~^Y                                                           
                                   5:~~~~~5                                                           
                                   #J~~~~~5                                                           
                                     #Y!~^5                                                           
                                       &5!Y                                                           
                                         &#                                                           
]]

-- Libraries ---------------------------------------------------------------------------------------
local function get_lib(lib)
    local succ, lib = pcall(require, lib)
    if not succ then error(string.format("Failed to load library %s", lib)) end
    return lib
end

local vector, ease, images, base64, csgo_weapons, anti_aim, trace, __entity, clipboard = get_lib("vector"), get_lib("gamesense/easing"), get_lib("gamesense/images"), get_lib("gamesense/base64"), get_lib("gamesense/csgo_weapons"), get_lib("gamesense/antiaim_funcs"), get_lib("gamesense/trace"), get_lib("gamesense/entity"), get_lib("gamesense/clipboard")

--local aa = {
--    enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
--    pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch"),
--    yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
--    yaw_jitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
--    body_yaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
--    fs_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
--    edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
--    freestanding = ui.reference("AA", "Anti-aimbot angles", "Freestanding"),
--    roll = ui.reference("AA", "Anti-aimbot angles", "Roll"),
--    dt = ui.reference("RAGE", "Aimbot", "Double tap"),
--    enable_resolver = ui.new_checkbox("RAGE", "Other", "!! ZITTER REZOLVER.JS !!")
--} 
--
--local function tings()
--    if ui.get(aa.pitch) == "Off" then
--        pitch = 0
--    elseif ui.get(aa.pitch) == "Default" then
--        pitch = 1
--    elseif ui.get(aa.pitch) == "Up" then
--        pitch = 2
--    elseif ui.get(aa.pitch) == "Down" then
--        pitch = 3
--    elseif ui.get(aa.pitch) == "Minimal" then
--        pitch = 4
--    elseif ui.get(aa.pitch) == "Random" then
--        pitch = 5
--    end
--
--    if ui.get(aa.yaw[1]) == "Off" then
--        yaw = 0
--    elseif ui.get(aa.yaw[1]) == "180" then
--        yaw = 1
--    elseif ui.get(aa.yaw[1]) == "Spin" then
--        yaw = 2
--    elseif ui.get(aa.yaw[1]) == "Static" then
--        yaw = 3
--    elseif ui.get(aa.yaw[1]) == "180 Z" then
--        yaw = 4
--    elseif ui.get(aa.yaw[1]) == "Crosshair" then
--        yaw = 5
--    end
--
--    if ui.get(aa.yaw_jitter[1]) == "Off" then
--        yawjit = 0
--    elseif ui.get(aa.yaw_jitter[1]) == "Offset" then
--        yawjit = 1
--    elseif ui.get(aa.yaw_jitter[1]) == "Center" then
--        yawjit = 2
--    elseif ui.get(aa.yaw_jitter[1]) == "Random" then
--        yawjit = 3
--    end
--
--    if ui.get(aa.body_yaw[1]) == "Off" then
--        byaw = 0
--    elseif ui.get(aa.body_yaw[1]) == "Opposite" then
--        byaw = 1
--    elseif ui.get(aa.body_yaw[1]) == "Jitter" then
--        byaw = 2
--    elseif ui.get(aa.body_yaw[1]) == "Static" then
--        byaw = 3
--    end
--end
--
--
--local silent = ui.reference("RAGE", "other", "silent aim")
--local last_shot = 0
--local delay = 100
--local shots = 0
--
--local csgo_weapons = require "gamesense/csgo_weapons"
--
--client.set_event_callback("aim_fire", function(e)
--    shots = shots + 1
--    last_shot = e.tick
--end)
--
--client.set_event_callback("run_command", function(e)
--
--    local local_player = entity.get_local_player()
--
--    local weapon_ent = entity.get_player_weapon(local_player)
--
--    local weapon= csgo_weapons(weapon_ent)
--    
--    local tickbase = globals.servertickcount()
--
--    if weapon.name == "SCAR-20" or weapon.name == "G3SG1" then
--        if shots > 1 then
--
--            jeweph = math.floor((tickbase / math.random(100, 105)))
--
--            if tickbase > (last_shot + delay) then
--                ui.set(silent, true)
--                shots = 0
--            else
--                ui.set(silent, false)
--            end
--        end
--    else
--        shots = 0
--        ui.set(silent, true)
--    end
--
--    if shots > 0 then
--        jewseph = shots
--    end
--end)
--
--local colours = {}
--local c2 = {}
--local black = ""
--local cunt = {}
--
--local function is_dead()
--    dead = false
--    if ( entity.get_prop( entity.get_local_player( ), "m_iHealth" ) <= 0 ) then
--        dead = true
--    else
--        dead = false
--    end
--    return dead
--end
--
--local function dormant()
--    local dorms = {}
--
--    for _, enemy in pairs(entity.get_players(true)) do
--        table.insert(dorms, enemy)
--    end
--    return dorms
--end
--
--local function main()
--
--    local nigger = {}
--    tings()
--
--    local dormant = dormant()
--    local threat = client.current_threat()
--    local cur_threat = threat == nil and "nil" or entity.get_player_name(threat)
--    local shifting = anti_aim.get_tickbase_shifting()
--    local body_yaw = anti_aim.get_balance_adjust()
--    local players = globals.maxplayers()
--    local dt = ui.reference("Rage", "aimbot", "Double tap")
--    local dorm = #dormant * ( players / 2 )
--    local warning = ""
--    local players2 = entity.get_players(true)
--    local table = {}
--
--    if dorm >= 128 then
--        colours = {189, 36, 36, 255}
--    elseif dorm == 64 then
--        colours = {222, 181, 93, 255}
--    elseif dorm < 64 then
--        colours = {255, 255, 255, 255}
--    end
--
--    if cur_threat ~= "nil" then
--        if math.floor(entity.get_prop( threat, 'm_flPoseParameter', 11 ) * 120 - 60) <= -50 or math.floor(entity.get_prop( threat, 'm_flPoseParameter', 11 ) * 120 - 60) >= 50 then
--            warning = cur_threat .. " [" .. threat .. "] [ 2 ]"
--        elseif math.floor(entity.get_prop( threat, 'm_flPoseParameter', 11 ) * 120 - 60) <= -30 or math.floor(entity.get_prop( threat, 'm_flPoseParameter', 11 ) * 120 - 60) >= 30 then
--            warning = cur_threat .. " [" .. threat .. "] [ 1 ]"
--        elseif math.floor(entity.get_prop( threat, 'm_flPoseParameter', 11 ) * 120 - 60) >= -30 or math.floor(entity.get_prop( threat, 'm_flPoseParameter', 11 ) * 120 - 60) <= 30 then
--            warning = cur_threat .. " [" .. threat .. "]"
--        end
--    end
--
--    if is_dead() == false and #dormant * ( players / 2 ) ~= 0 and cur_threat ~= "nil" and shifting == 0 then
--        nigger = {
--            --cur_threat .. " [" .. threat .. "]",
--            dorm,
--            shifting,
--            math.floor(entity.get_prop( threat, 'm_flPoseParameter', 12 ) * 180 - 90),
--            math.floor(entity.get_prop( threat, 'm_flPoseParameter', 11 ) * 120 - 60),
--            ["lol"] = jewseph,
--        }
--    elseif cur_threat ~= "nil" then
--        nigger = {
--            --cur_threat .. " [" .. threat .. "]",
--            ui.get(aa.yaw_jitter[2]),
--            shifting,
--            body_yaw,
--        }
--    end
--    if #dormant ~= 0 and is_dead() == false and shifting > 10 and ui.get(dt) and cur_threat ~= "nil" then
--        nigger = {
--            --cur_threat .. " [" .. threat .. "]",
--            dorm,
--            ui.get(aa.yaw_jitter[2]),
--            shifting,
--            math.floor(entity.get_prop( threat, 'm_flPoseParameter', 12 ) * 180 - 90),
--            math.floor(entity.get_prop( threat, 'm_flPoseParameter', 11 ) * 120 - 60),
--            ["lol"] = jewseph,
--        }
--    end
--
--    if not is_dead() then
--        count = 0
--        for i, v in pairs(nigger) do
--            if i == "lol" then
--                if shots == 0 then
--                    goto skip
--                end
--            end
--            count = count + 1
--            renderer.text(8, 0 + (count * 20), 255, 255, 255, 255, "+", 0, v)
--            ::skip::
--        end
--
--        if cur_threat ~= "nil" then
--            renderer.text(8, 0, colours[1], colours[2], colours[3], colours[4], "+", 0, warning)
--        end
--    end
--end
--
--client.set_event_callback("paint", main)
--
--local store = {}
--local timer = 0
--
--client.set_event_callback("setup_command", function()
--    
--    if timer + 3 < globals.curtime() then
--        timer = globals.curtime()
--        return
--    end
--
--    local layers = entity.get_players(true)
--
--    for i, v in pairs(layers) do
--        local yaw = math.floor(entity.get_prop(v, 'm_flPoseParameter', 11) * 120 - 60)
--        local pitch = math.floor(entity.get_prop( v, 'm_flPoseParameter', 12 ) * 180 - 90)
--        if store[v] == nil then
--            store[v] = {
--                yaw = yaw,
--                pitch = pitch,
--                time = globals.curtime(),
--                time2 = globals.curtime(),
--                jittering = false,
--                exploiting = false
--            }
--        end
--
--        if store[v].yaw > 0 and yaw < 0  then
--            store[v].jittering = true
--            store[v].time = globals.curtime()
--        elseif store[v].yaw < 0 and yaw > 0 then
--            store[v].jittering = true
--            store[v].time = globals.curtime()
--        else
--            if store[v].time + 0.5 < globals.curtime() then
--                store[v].jittering = false
--            end
--
--            if store[v].pitch < 87 and pitch > -87 and pitch > 10 or pitch < -10 then
--                store[v].exploiting = true
--                store[v].time2 = globals.curtime()
--            elseif store[v].pitch > -87 and pitch < 87 and pitch > 10 or pitch < -10 then
--                store[v].exploiting = true
--                store[v].time2 = globals.curtime()
--            else
--                if store[v].time2 + 0.5 < globals.curtime() then
--                    store[v].exploiting = false
--                end
--            end
--        end
--
--        curtime = globals.curtime()
--        tickinterval = globals.tickinterval()
--        max_backtrackable_ticks = math.floor(0.2 / tickinterval)
--
--        for _, player in pairs(layers) do
--            player_weapon = entity.get_player_weapon(player)
--            last_shot_time = entity.get_prop(player_weapon, 'm_fLastShotTime')
--            if last_shot_time then
--                time_difference = curtime - last_shot_time
--                ticks_since_last_shot = time_difference / tickinterval
--            end
--        end
--    end
--end)
--
--local function is_hittable(ent)
--    ent = ent == enemy and client.current_threat() or ent
--
--    if entity.is_dormant(ent) or not entity.is_alive(ent) then
--        return end
--
--    return bit.band(entity.get_esp_data(ent).flags, 2048) ~= 0
--end
--
--local function is_def_dt(ent)
--    ent = ent == enemy and client.current_threat() or ent
--
--    if entity.is_dormant(ent) or not entity.is_alive(ent) then
--        return end
--
--    return bit.band(entity.get_esp_data(ent).flags, 131072) ~= 0
--end
--
--client.register_esp_flag('MC', 204, 204, 204, function(player)
--    local lp = entity.get_local_player()
--    if not entity.is_alive(lp) then return end
--
--    if entity.is_dormant(player) then return end
--
--    return not is_hittable()
--end)
--
--client.register_esp_flag('FC', 204, 204, 204, function(player)
--    local lp = entity.get_local_player()
--    if not entity.is_alive(lp) then return end
--
--    if entity.is_dormant(player) then return end
--
--    if store[player] == nil then return end
--
--    if not is_hittable() and is_def_dt() then
--        store[player].time2 = globals.curtime()
--    return end
--
--    jittering = store[player].time2 + 2.5 > globals.curtime() and store[player].time2 + 0.25 < globals.curtime() 
--    
--    return jittering
--end)
--
--client.register_esp_flag('MC', 204, 204, 204, function(player)
--    local lp = entity.get_local_player()
--    if not entity.is_alive(lp) then return end
--
--    if entity.is_dormant(player) then return end
--
--    if store[player] == nil then return end
--
--    if not is_hittable() then
--        store[player].time2 = globals.curtime()
--    return end
--
--    jittering = store[player].time2 + 0.25 > globals.curtime() or store[player].time2 + 2.5 < globals.curtime() 
--    
--    return jittering
--end)
--
--client.register_esp_flag('MD', 204, 204, 204, function(player)
--    local lp = entity.get_local_player()
--    if not entity.is_alive(lp) then return end
--
--    if entity.is_dormant(player) then return end
--
--    if ticks_since_last_shot == true or max_backtrackable_ticks == nil then return end
--
--    return ticks_since_last_shot < max_backtrackable_ticks + 90
--end)
--
--client.register_esp_flag('BT', 204, 204, 204, function(player)
--    local lp = entity.get_local_player()
--    if not entity.is_alive(lp) then return end
--
--    local pitch = math.floor(entity.get_prop( player , 'm_flPoseParameter', 12 ) * 180 - 90)
--
--    if entity.is_dormant(player) then return end
--
--    if store[player] == nil then return end
--
--    exploiting = pitch < 80 and is_def_dt()
--
--    return exploiting
--end)
--
--client.register_esp_flag('NN', 204, 204, 204, function(player)
--    local lp = entity.get_local_player()
--    if not entity.is_alive(lp) then return end
--
--    if entity.is_dormant(player) then return end
--
--    if store[player] == nil then return end
--
--    if not is_def_dt() then return end
--
--    if not is_hittable() and not is_def_dt() then
--        store[player].time2 = globals.curtime()
--    return end
--
--    jittering = store[player].time2 + 1 > globals.curtime() and store[player].time2 + 0.1 < globals.curtime() 
--    
--    return jittering
--end)
--
--client.register_esp_flag('TC', 204, 204, 204, function(player)
--    local lp = entity.get_local_player()
--    if not entity.is_alive(lp) then return end
--
--    if entity.is_dormant(player) then return end
--
--    if is_hittable() or is_def_dt() then return end
--
--    local yaw = math.floor(entity.get_prop(player, 'm_flPoseParameter', 11) * 120 - 60)
--    return yaw <= -50 or yaw >= 50
--end)
--
--client.register_esp_flag('MU', 204, 204, 204, function(player)
--    local lp = entity.get_local_player()
--    if not entity.is_alive(lp) then return end
--
--    if entity.is_dormant(player) then return end
--
--    if not is_def_dt() then return end
--
--    local yaw = math.floor(entity.get_prop(player, 'm_flPoseParameter', 11) * 120 - 60)
--    return yaw <= -30 or yaw >= 30
--end)
--
--client.register_esp_flag('LW', 204, 204, 204, function(player)
--    local lp = entity.get_local_player()
--    if not entity.is_alive(lp) then return end
--
--    if entity.is_dormant(player) then return end
--    
--    if is_def_dt() then return end
--
--    local yaw = math.floor(entity.get_prop(player, 'm_flPoseParameter', 11) * 120 - 60)
--    return yaw > -30 and yaw < 30
--end)
-- Luraph Macros -----------------------------------------------------------------------------------
LPH_NO_VIRTUALIZE = function(...) return ... end

-- UI Library -------------------------------------------------------------------------------------
local g_ui = _G.ui

local ui = { elements = {} }
ui.__index = ui

ui.new = function(elem, _type, uid, func)   

    local element = setmetatable({
        uid = uid or nil,
        ref = elem,
        callback = func or function() end,
        conditions = {},
        type = _type
    }, ui)

    table.insert(ui.elements, element)

    g_ui.set_callback(elem, function()
        element.callback(element)
        if element.type ~= "slider" and element.type ~= "color_picker" then
            ui.handle_visibility()
        end
    end)

    ui.handle_visibility()

    return element
end

ui.new_reference = function(elem)
    local element = setmetatable({
        uid = nil,
        ref = elem,
        callback = function() end,
        conditions = {}
    }, ui)

    g_ui.set_callback(elem, function()
        element.callback(element)
    end)

    return element
end

ui.get_config_elements = LPH_NO_VIRTUALIZE(function()
    local config = {}

    for _, element in pairs(ui.elements) do
        if element.uid ~= nil then
            table.insert(config, element)
        end
    end

    return config
end)

ui.get_config = LPH_NO_VIRTUALIZE(function()
    local config_elements = ui.get_config_elements()
    local config = {}

    for i, element in pairs(config_elements) do
        config[element.uid] = g_ui.get(element.ref)
    end

    return json.stringify(config)
end)

ui.load_config = LPH_NO_VIRTUALIZE(function(settings)
    local config_elements = ui.get_config_elements()

    local parsed = json.parse(settings)

    for i, element in pairs(config_elements) do
        for uid, value in pairs(parsed) do
            if uid == element.uid then
                local success, err = pcall(function() return g_ui.set(element.ref, value) end)
                if not success then  goto skip end
            end
            ::skip::
        end
    end
end)

ui.handle_visibility = LPH_NO_VIRTUALIZE(function()
    for _, element in pairs(ui.elements) do
        local visible = true
        for _, condition in pairs(element.conditions) do
            if not condition() then
                visible = false
                break
            end
        end

        for _, parent in pairs(element:get_parents()) do
            if not g_ui.get(parent.ref) then
                visible = false
                break
            end
        end

        g_ui.set_visible(element.ref, visible)
        element.visible = visible
        ::skip::
    end
end)

function ui:get_parents()
    local parents, parent = {}, self.parent

    while parent ~= nil do
        table.insert(parents, parent)
        parent = parent.parent
    end

    return parents
end

function ui:add_condition(condition)
    if type(condition) ~= "function" then
        print("[Roger-UI] Condition must be a function!")
        return self
    end

    table.insert(self.conditions, condition)

    return self
end

function ui:set_callback(callback)
    if type(callback) ~= "function" then
        print("[Roger-UI] An error occured while setting callback for element: " .. self.uid .. " - Expected function, got " .. type(callback))
        return self
    end

    self.callback = callback

    return self
end

function ui:get()
    return g_ui.get(self.ref)
end

function ui:set_visible(visible)
    g_ui.set_visible(self.ref, visible)
end

function ui:set(value)
    local success, err = pcall(g_ui.set, self.ref, value)

    if not success then
        print("[Roger-UI] An error occured while setting value for element: " .. tostring(self.uid) .. " - " .. err)
    end
end

function ui:update(...)
    g_ui.update(self.ref, ...)
end

function ui:name()
    return g_ui.name(self.ref)
end

function ui:init()
    
    if not pcall(function() return g_ui.get(self.parent.ref) end) then
        print("[Roger-UI] An error occured while creating element: " .. uid .. " - Invalid parent element type!")
        return
    end
    
    table.insert(self.elements, self)
    
    g_ui.set_callback(self.parent.ref, function()
        ui.handle_visibility()
        self.parent.callback(self.parent)
    end)

    g_ui.set_callback(self.ref, function()
        ui.handle_visibility()
        self.callback(self)
    end)
end

-- Child elements
function ui:checkbox(uid, ...)  
    local ref = g_ui.new_checkbox(...)
    local element = setmetatable({uid = uid, ref = ref, type = "checkbox", parent = self, callback = function() end, conditions = {}, config = uid ~= nil, visible = false }, ui)
    element:init()
    return element
end

function ui:slider(uid, ...)
    local ref = g_ui.new_slider(...)
    local element = setmetatable({uid = uid, ref = ref, type = "slider", parent = self, callback = function() end, conditions = {}, config = uid ~= nil, visible = false }, ui)
    element:init()
    return element
end

function ui:color_picker(uid, ...)
    local ref = g_ui.new_color_picker(...)
    local element = setmetatable({uid = uid, ref = ref, type = "color_picker", parent = self, callback = function() end, conditions = {}, config = uid ~= nil, visible = false }, ui)
    element:init()
    return element
end

function ui:combo(uid, ...)
    local ref = g_ui.new_combobox(...)
    local element = setmetatable({uid = uid, ref = ref, type = "combo", parent = self, callback = function() end, conditions = {}, config = uid ~= nil, visible = false }, ui)
    element:init()
    return element
end

function ui:hotkey(...)
    local ref = g_ui.new_hotkey(...)
    local element = setmetatable({uid = nil, ref = ref, type = "hotkey", parent = self, callback = function() end, conditions = {}, config = false, visible = false }, ui)
    element:init()
    return element
end

function ui:label(...)
    local ref = g_ui.new_label(...)
    local element = setmetatable({uid = nil, ref = ref, type = "label", parent = self, callback = function() end, conditions = {}, config = false, visible = false }, ui)
    element:init()
    return element
end

function ui:listbox(uid, ...)
    local ref = g_ui.new_listbox(...)
    local element = setmetatable({uid = uid, ref = ref, type = "listbox", parent = self, callback = function() end, conditions = {}, config = uid ~= nil, visible = false }, ui)
    element:init()
    return element
end

function ui:multiselect(uid, ...)
    local ref = g_ui.new_multiselect(...)
    local element = setmetatable({uid = uid, ref = ref, type = "multiselect", parent = self, callback = function() end, conditions = {}, config = uid ~= nil, visible = false }, ui)
    element:init()
    return element
end

function ui:textbox(...)
    local ref = g_ui.new_textbox(...)
    local element = setmetatable({uid = nil, ref = ref, type = "textbox", parent = self, callback = function() end, conditions = {}, config = uid ~= nil, visible = false }, ui)
    element:init()
    return element
end

function ui:button(...)
    local ref = g_ui.new_button(...)
    local func = function() end
    for i, v in ipairs({...}) do
        if type(v) == "function" then
            func = v
            break
        end
    end
    local element = setmetatable({uid = nil, ref = ref, type = "button", parent = self, callback = func, conditions = {}, config = false, visible = false }, ui)
    element:init()
    return element
end

-- Native functions
function ui.new_string(...) return ui.new(g_ui.new_string(...), "string") end
function ui.new_checkbox(uid, ...) return ui.new(g_ui.new_checkbox(...), "checkbox", uid) end
function ui.new_slider(uid, ...) return ui.new(g_ui.new_slider(...), "slider", uid) end
function ui.new_color_picker(uid, ...) return ui.new(g_ui.new_color_picker(...), "color_picker", uid) end
function ui.new_combobox(uid, ...) return 
    ui.new(g_ui.new_combobox(...), "combobox", uid)
end
function ui.new_hotkey(...) return ui.new(g_ui.new_hotkey(...), "hotkey") end
function ui.new_label(...) return ui.new(g_ui.new_label(...), "label") end
function ui.new_listbox(uid, ...) return ui.new(g_ui.new_listbox(...), "listbox", uid) end
function ui.new_multiselect(uid, ...) return ui.new(g_ui.new_multiselect(...), "multiselect", uid) end
function ui.new_textbox(...) return ui.new(g_ui.new_textbox(...), "textbox") end

function ui.new_button(...)
    local func = function() end
    for i, v in ipairs({...}) do
        if type(v) == "function" then
            func = v
            break
        end
    end
    return ui.new(g_ui.new_button(...), "button", nil, func)
end

function ui.reference(...)
    local args = {...}
    local ref = g_ui.reference(...)

    if select(3, g_ui.reference(...)) then
        return ui.new_reference(select(1, g_ui.reference(...))), ui.new_reference(select(2, g_ui.reference(...))), ui.new_reference(select(3, g_ui.reference(...)))
    end

    if select(2, g_ui.reference(...)) then
        return ui.new_reference(select(1, g_ui.reference(...))), ui.new_reference(select(2, g_ui.reference(...)))
    end

    return ui.new_reference(g_ui.reference(...))
end

function ui.type(...) return g_ui.type(...) end

function ui.is_menu_open() return g_ui.is_menu_open() end
function ui.menu_position() return vector(g_ui.menu_position()) end
function ui.menu_size() return vector(g_ui.menu_size()) end
function ui.mouse_position() return vector(g_ui.mouse_position()) end

-- Color Library --------------------------------------------------------------
local color = {}
color.__index = color

function color.new(r, g, b, a)
    local self = setmetatable({}, color)

    self.r = r or 255
    self.g = g or 255
    self.b = b or 255
    self.a = a or 255

    return self
end

color.__add = function(a, b)
    return color.new(a.r + b.r, a.g + b.g, a.b + b.b, a.a + b.a)
end

color.__sub = function(a, b)
    return color.new(a.r - b.r, a.g - b.g, a.b - b.b, a.a - b.a)
end

color.__mul = function(a, b)
    return color.new(a.r * b.r, a.g * b.g, a.b * b.b, a.a * b.a)
end

color.__div = function(a, b)
    return color.new(a.r / b.r, a.g / b.g, a.b / b.b, a.a / b.a)
end

color.__eq = function(a, b)
    return a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a
end

color.__tostring = function(self)
    return string.format("color(%d, %d, %d, %d)", self.r, self.g, self.b, self.a)
end

function color:table()
    return { self.r, self.g, self.b, self.a }
end

function color:hex()
    return string.format("%02x%02x%02x%02x", self.r, self.g, self.b, self.a)
end

function color:unpack()
    return self.r, self.g, self.b, self.a
end

function color:lerp(color, amount)
    local r = self.r + (color.r - self.r) * amount
    local g = self.g + (color.g - self.g) * amount
    local b = self.b + (color.b - self.b) * amount
    local a = self.a + (color.a - self.a) * amount

    return color.new(r, g, b, a)
end

-- Obex -----------------------------------------------------------------------
local obex = obex_fetchlocal obex = obex_fetch and obex_fetch() or { username = "Admin", build = "Dev" }
local obex_builds = { ["User"] = "Standard", ["Beta"] = "Premium", ["Debug"] = "Deluxe", ["Private"] = "VIP"}
obex.build = obex_builds[obex.build] or obex.build

-- References -----------------------------------------------------------------
local gs = {    
    aa = {
        master = ui.reference("aa", "anti-aimbot angles", "Enabled"),
        yaw_base = ui.reference("aa", "anti-aimbot angles", "Yaw base"),
        pitch = ui.reference("aa", "anti-aimbot angles", "Pitch"),
        pitch_slider = select(2, ui.reference("aa", "anti-aimbot angles", "Pitch")),
        yaw = select(1, ui.reference("aa", "anti-aimbot angles", "Yaw")),
        yaw_offset = select(2, ui.reference("aa", "anti-aimbot angles", "Yaw")),
        yaw_jitter = select(1, ui.reference("aa", "anti-aimbot angles", "Yaw jitter")),
        yaw_jitter_offset = select(2, ui.reference("aa", "anti-aimbot angles", "Yaw jitter")),
        body_yaw = select(1, ui.reference("aa", "anti-aimbot angles", "Body yaw")),
        body_yaw_offset = select(2, ui.reference("aa", "anti-aimbot angles", "Body yaw")),
        freestanding_body_yaw = ui.reference("aa", "anti-aimbot angles", "Freestanding body yaw"),
        edge_yaw = ui.reference("aa", "anti-aimbot angles", "Edge yaw"),
        freestanding = ui.reference("aa", "anti-aimbot angles", "Freestanding"),
        freestanding_key = select(2, ui.reference("aa", "anti-aimbot angles", "Freestanding")),
        roll = ui.reference("aa", "anti-aimbot angles", "Roll")
    },
    misc = {
        hide_shots = select(1, ui.reference("AA", "Other", "On shot anti-aim")),
        hide_shots_key = select(2, ui.reference("AA", "Other", "On shot anti-aim")),
        fakeducking = ui.reference("RAGE", "Other", "Duck peek assist"),
        legs = ui.reference("AA", "Other", "Leg movement"),
        slow_motion = select(1, ui.reference("AA", "Other", "Slow motion")),
        slow_motion_key = select(2, ui.reference("AA", "Other", "Slow motion")),
        menu_color = ui.reference("Misc", "Settings", "Menu color"),
        thirdperson = select(1, ui.reference("Visuals", "Effects", "Force third person (alive)")),
        thirdperson_key = select(2, ui.reference("Visuals", "Effects", "Force third person (alive)")),
        clantag = ui.reference("MISC", "Miscellaneous", "Clan tag spammer"),
        menu_key = ui.reference("MISC", "settings", "menu key"),
        dpi = ui.reference("misc", "settings", "dpi scale"),
        ping_spike = select(1, ui.reference("misc", "miscellaneous", "Ping spike")),
        ping_spike_key = select(2, ui.reference("misc", "miscellaneous", "Ping spike")),
        ping_spike_value = select(3, ui.reference("misc", "miscellaneous", "Ping spike")),
    },
    rage = {
        double_tap = select(1, ui.reference("RAGE", "aimbot", "Double tap")),
        double_tap_key = select(2, ui.reference("RAGE", "aimbot", "Double tap")),
        baim = ui.reference("RAGE", "aimbot", "Force body aim"),
        prefer_bodyaim = ui.reference("RAGE", "aimbot", "Prefer body aim"),
        prefer_safepoint = ui.reference("RAGE", "Aimbot", "Prefer safe point"),
        safe = ui.reference("RAGE", "Aimbot", "Force safe point"),
        aimbot = ui.reference("RAGE", "Aimbot", "Enabled"),
        mdo = select(1, ui.reference("RAGE", "Aimbot", "Minimum damage override")),
        mdo_key = select(2, ui.reference("RAGE", "Aimbot", "Minimum damage override")),
        mdo_value = select(3, ui.reference("RAGE", "Aimbot", "Minimum damage override")),
    },
    fakelag = {
        enable = select(1, ui.reference("AA", "Fake lag", "Enabled")),
        enable_key = select(2, ui.reference("AA", "Fake lag", "Enabled")),
        limit = ui.reference("AA", "Fake lag", "Limit"),
        type = ui.reference("AA", "Fake lag", "Amount"),
        variance = ui.reference("AA", "Fake lag", "Variance")
    }
}

-- Vars -----------------------------------------------------------------------
local paradox = {}

paradox.client = {
    username = obex.username,
    build = obex.build,
    update = "17/03/2023"
}

paradox.cache = {
    aa = {
        states = { "Standing", "Moving", "Slow Walk", "Air", "Air Duck", "Duck", "Duck Move", "Fakelag", "Fakeduck"},
        teams = { "CT", "T" }
    },
    ab = {
        stages = {"Stage - 1", "Stage - 2", "Stage - 3"}
    },
    ui = {},
    cmd = {},
    menu = {
        is_menu_open = false
    },
    db = nil
}

paradox.menu = {
    info = {},
    aa = {
        builder = {}
    },
    ab = {
        builder = {}
    },
    visuals = {},
    misc = {},
    config = {}
}

paradox.menu.tab = {
    list = {"Info", "Antiaim", "Antibrute", "Visuals", "Misc", "Config"},
    icon = {
        ["Config"]    = images.load(base64.decode("iVBORw0KGgoAAAANSUhEUgAAADQAAAA0CAYAAADFeBvrAAAACXBIWXMAAAsTAAALEwEAmpwYAAABRklEQVR4nO2aTU7DQAxGvWqlLmEDKpyq1wBOBMdoewIorILYIU6Birp9rdVUqqoMGUR+HNdvG03il2/yN7FICTAGHoBX4Ac7bIAVMJNcgCnwjn2egEmdzDhTZg7cSEfosYBFRR1vwMVvA3Wa5dCZzFFtt4laPoCr1CA1rqWFYrOOQ5pPFa7a8XqgQsoXcP2XAdaFDtPv0pMQ5WWzv/vhQ0h59CakzLwJPXsT2ngTIoSaIhLKJKZcUyTPcFcJYevzoRGhReXrersyyzaFBoHgDMEZgjMEZwhnJDTv49nzj/W6WiFzMjkP3OxXEGsQQsYhEjIOkZBxiISMQyRkHCIh4xAJGYdIyDicU0JrR0LfydYYGabQSjfcO1okuTu0lxV9/21o4K9EAYyOGwCrpIZCoQ6n5iONrGyHzOrQ6hmt8aWseZ/MTmQLOiWIKALpIxQAAAAASUVORK5CYII=")),
        ["Info"]      = images.load(base64.decode("iVBORw0KGgoAAAANSUhEUgAABDgAAAQ4BAMAAAAePnG8AAAAG1BMVEVHcEzPpfNPQVyhg7rmxv/Wqf/etv/QnP/41v8i6F42AAAABHRSTlMA0zWYYLk0MwAAIABJREFUeNrs3U2u7LYRhmEDWYFjJOPAO4izBUHoqQeSxgEozT0QtAENetkRWT8sqaU+UwZ4H/g6SHzjc4Gu86lYJHV++QUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD4//Z7G/ggWvS3fw7Vurl1rf/zOC5VOnTZ+yd75/pD+HfUf7V9ub9+/fXX3/7zx+//4hNpyb/HsXxM0zSt6zqJYS3/rfyDOVtGK4z8OefyeP1YHa+jKtLSp+X4VSylQI6vt4xai/lrhYrMRfLbHxRIO9Hxj+Pjl89qWI+Pq/zK/6Hf23MuD62N/Ff+oLtSHa8fgmPP1dGl/vgllaHhMS+54Lwit6u/qI6GokNKQzJjPR4o8h2d86Mmhz5SJASWrs+f++vH4DhSprPUOH6lkhxLzKpt+iiO7e98KC1FR/6ojvoojo9rLQ8YqY1hzMmxzJ4c8oH/WB27tBzHb7QCkdrIz5VRy2MoX+xSGuv2J9HRWnTkaiihIX/X0jgKJz9VRk8O1f3QlXoj2kmb0ttTZV6OINKwWm+TYyU6moqOwT4s7TdWzQ5JjuMbfbEFi/aW5WMv7lqP3RYqITeksEpy5I5Dwio/xm6eK0RHY9HhSxVrOQZbrBy1IT2HLFRkxXIkR28L1f2zE9VmtCu50eX/Q7J+dCxNTKmNXI3btTpydRIdzUXHak1HyY76YAnPlaWWh9XGKzvVhq5TJDqkNPpQHqOtVQapxmtuTNtEdDQUHVIatlrR5BhKdczSkGpthIY0SXkcdXBUw/u2Ospvq7WRvDakIc2F+LmS3fJzjehoLDomXc5upToGH4KV1cVotSH9Q1/mFxIe+6U6XjE75HfKWnaxnlSSY32Yc+SvT3Q0FR1WGqupw3Mfn1tt9PqJW89xfrDs71entVHmZSnFAWnpODQ5tmm6Kw2io8HoWEM7ai1pfqpociRrSnUB4smRa2MPtZGTw8rjWK5Y0xGfK9JyDNNtdBxNB9HRVnT4xoqOOaaQHLPvuS31seItafeRHAedc3T+WPEhmCXHNNwPSGV4T3S0FR2Tz0hLbuicYz7POWpDKvsmuTSOpuN9qQ5Pjvy7l1wd1nOMdbXy1JHm9RLR0VJ02IT0cwRmG2+LzTlkFeI9R3mwvM8tqVeHLlmWOuj4MTkkuoiOpqLDeg2JDlnJDtJzhAmpTdBLQ5F0ufI67eDHxWz61nOs9z1peawRHS1Fx7oOa1Wro05IdQZ+lMQ5Okpy1Ox4va3n0OToddO+972Vb8mx6VkSoqOl6PDYkKVs2Fqx5JB+VAok5Ql679URk+Oojjz78OMcMTeuyXHfc+Q/ANHRVHRMQ+1Ha88RD/tI03EakebHSq6N2HWck8PnHOk0IX1MjnKmhOhoMTp8xqGLWdl4G88dh6xQO32yvG7mYFYfYXfFoiPurazrwxTs+OpER0PRcVquaHL4CMy3VlJYsHTPk45ulxmYHwezQYec9Zl1n+/uoSLhNRAdTUWHDjrKYqH2HPmxolMwPc/Rd7a5ouuV0mKcdt9ybuw6B0uyt+LJIbUhyXH7XMlzsPwn+C/R0VB0nJ8rk09Ix9HaUV/Iyjkebzq68xhsD23HZVs2z01G27C/jQ5bShMdbXUd3pAO+lwpO/Z6hvS0KesDDE+Oj5b05fuyKVbHbOcE1+l2yKGDsPz1iY42o2Pwuwm16VjCGVJ5tNSmo/vcti/VkWpp6Fkff6xM9/tu21YXS0RHQ9HxOQObh3gzIXnTkf/W+1HSV3famZUJejwPJosV37Qf/AjpfXBsemqA6GgxOobLcmWMBzq050i+Xnl9HBaszxXf4l/0fHHpOWY70DzdjcDq6Xeio63oOJ0vDscEkx8T1Nro+85vsHTnx8q+v+tpsBIwdbFSHyvDuj73HDJmITqai46hnC+ennoO3bIvyeE3FK6HBV/1DLrmRkqnO03r4/Q8nCgZiY72uo6QHKU0RrvTlPz0ufQcnXWll0HHux4ktSmY35XV5FjLeeaHpsOeakRHe11H/r72GZgfPw/ZIcuQztqO/TIklfn5S6ekdpM6+V3Z+cveijUd8gcgOtqKjjgEyw3CEs4J5uro/FpT72fQr8fBdEpqhzp6e6roEWM/CXYvbPwRHY1Fx7DGQYftyvb5rzDm6CUUSnW8rpOOspS1e5F6W/Z8yz4X4f1ZH7nLbbf8iY7GFiz2VNHh+bjM8aasjjrkHE//LTn8ctM5Obw8viaH/gmIjraio9xoqskR9t30xlvv12VPO7OX5Yrt2usrGLTnsMM+t3chbdPeb87MdB3tLVi8Ix3DOxh6Wa7YUUHdNenCoY7LesU27mNyLLKWLS8EeXisaHLoH4DoaCo6as8xh9VK2ZXVVzDIMTDpN7Q2Xt3nldmXX2zyt7cczW29Rv04Pt/qu2OGhehoKDpCNzqMp+uQdqdJzpDq0WGvjtflLXJ2qKNeltXqkJ5jGh6Wsqe9t6M+iY4Gu4465/Ctt3CgQ6ekvjd7Wa4cpbHrKePOd+x7bUhrbXwZdGh2HcVJdDQUHVIaa51z2HU3O0VazvpY32Fd6fW6/e5NR+rq5srseyvr82pFDivac42uo6noGOplyPjyFrtlL1MwnZN2qT5WrmtZazrCNftlDq8TfJye143ZfP6drqOxBUvsOebrdbe6L1smYX5H4bz3Vk+ShhPGpTZGe0Pdt+SY6nEjoqOp6NBvXOk5ZNBRJqRhtWL7K7q98nmow5sOPwy2hJ5jGLan5NAj8H5QkehoLDoGn4F5cticI9mebJmC1d23j53ZsPlmK9lZ3hj3PTkmOUUaDioSHQ1FR71GLT3HHGtD3nCtJ4fDzbf9cgY9bNuHt9TmLXt51eSXQUfpOSZbL7FgaSw6/F2TY0iO6wljbUltObufr0XKBYW9O1+XrcnxePhcz5/71Rm6jtaiw19u7e/nKKuVxd4IpuvZcH/lY73yqu9iONWGv4h//ToD87X0SHS02XXInGP0OUedkXa996NJtu3LkZ/3zY3qFA+R+jnB8sLkp+Soh4zlyUZ0NBcdeqnJz3PUE8Z2nqPeT8jvQr+8sPbtZzp8gD7PS/05DU/j89Pr13N1MOtoKzrC1YT5fEjQ2o1eb8L6O37yWON9XcxK05HiLfswBXs0aUdanio5vYiO1qJjjFOw3s9z+IkfGaH38frK++650oW7suPXH5oQ3u4z1eRgwdJYdFxfjF9f/KTrV9mb7bv6QxQu2yu733yztzDoiNR/jte35PDLEdIW03W0Fh3zUA8YpzohTbZXL7cin18s6Buz6fQKhp+SQ1+GWk+xljUT0dFYdOhTxZ8r/gbjvvMpaR9fLPjZdPityJTskr2/g+Frz6FHOma7PkN0tBUdcW9lsR37Lhz36SxF7pPjHTZm/Seu/Lxa2epPp5SVrJxzJjpaio5TP1qro7erkPVFxqkeQj+d6Xj7dftk+27ac0w/9Bz5yVJHceUoK9HR2oLlPOeoQzB9qugWbX9/8a2Owfya/eI//u/LaqW8hMHPgumFXWYdjUXHGCakPgPrtDzkbaTJ5h7adbwvczB/sPiFt1Ie69eeQ96HGtaypUaJjraiI+ytyFOl/pg3/fl+tgl3d1QwNB1L7w8W3VyZviXH5D++ND/bymqWrqOt6JhL13HdldX5hs/PNT50Y/ZyHEybjjwMOf1c2e/JsW1+/Fy6YmYd7UXHXFey6dRz9GHKoUN0P/Bz+zZjPXzu91bKUZ8vb4zb7FpT2ZnVe5lER1NdR3x5S5mf2wtq5c0+ettesqM8Vy43FKw8Uvc/9s5mV24bicKw8wJzE9y527HzAjEGyD4DgeitFxLXE4i9dwBC6wF64ceeJquKLKqp7nZgA4LqKPYqu3vLH0/9nSrLsmfOVp4gB98gHMnZFnMdO0NHNW9pNqkdmT4N4vHjypTx5cbi56RrpMWBIfrt+WKZIq3k4P4K0LGzMqnaTCg1UmnHUo1DxQaN/NxcIVaFjjMfpE4l0juFDr/U2BipMxuAjp2h4+VHfZ9+uf6hb7PzFqO63QB0mPze+n6CuoDORVKgw9z34dEytZgajmjOmvvev91v2gdSpIQOLN0DHUv1bynxAdUBdMjWWyKHZ82R79uy9gA6zKODTgONtdIRCB9AB9Dh60bkOE08zMoZLdABdMQ6gT6VpdmsTIEO2+igzlsZ6BDBgc1ZoGOdrnAiS803GAwaR0c2k/P1UcnRwQWPCbUO8+jQjdnAQ+ijZCxAh2nVEdUsGGcsU2myQHWYRkdc6ixYLnIQOUp0AB2m0UFepL6SYxrVuwJ0WEaHlxOmLEllyHiiwUEkLEBHrXNQUExCDiQsltHhmzHSMg82keYYMddhGh2crhSr2jBxd5YUKdBhXXU02SxtWNWBQaDDKjqaEqls2k90RYFXWYAOY+h4W7vj16Y9R0cAOqx+L+vyeSl0pDoY7yhgJMzm9+6tSw5xCplkqxqD6LbR4VWhg9LXTA4ueOSpQaDDLDq40KFcBVmR0tQPBtEtoyOq0wkjD3K0229Ah1V00HJCXaaWuY7SgYPqMIwO75vFpolHSANbyOGE086+9x+/8/frb3dUB29EyjAY9+258QZb4719PxUj6yc+xy5g5MnBR//W38+b6IirQUGqi+YHhoIELmE7+353q+uhQy9c+EC54/CohtbLrdPTvzbR0RxdGSmVJSlahjvCGejYJTpm/sMe1/WjiMlXeurtrolPd92g469t1ZH7smp7ZZIYUQ5y0x9Ax/7QQZZg1UZwFpSUc5ByRSOciw1Yxz/wyxY6IhfB/Kg0x8RjPyHItQ/UOvaEDj5S7lyBh3YEG6qBnHa0ZgPBDjnuoUMboJdhQWnDBfZlBzp2hQ4OhxIdQ3G3LtHBV6jP7D0qpsW9k3+b6KDTCeqIaWmxyF+66AB07El1zHIxlI8nzCxCq0DNxvlFkIrm2LhBvY2OxvmJn5UgvZVJLjoAHTtCB+mLmc7/OTKbbHMVVxKWQo5AjtY9c8ktdMRcQR9jK0jVmHFgF0ygY0focOI/mh8UdamJXxU3yL0ePsDDz8rW9fpNdLSecWogTIqlFB5Ax57Q4YZZrkS6qjtqsuI4k3VMjlz5JrvzXnRsoCNfJU7k0H1Z7sHxo8LHPoCOXamO5iVpXhXOYOYaG3SAJ2yTYxMdq33ZIKtNun5+DZAZ6NgVOupx2dkN6uAKpy4znSjnd+UqG7nOsXGffAMdvrUUDIwOJUr5FMwMdOyq1uEaBaqqYKxDKHoqOeQg5DehI/Jh6thkLG2ykq/BAB17Qgc/G65hRo0UKo1xthJKmWPzqlsfHUyOdudN2UDVI1ID0LEn1eGU3pjXIVLk6lkqpJKvbJ1J6KMjqvOyozr4JkMdJZmF6thVmXSQDosb2uaK6FOtSKXvtn0PsosO6a6U9gqNkGZvQQkNPjE2/Ilfyo7Q8XCaYxjkQHmZ57hzmmkDHatlar6gPk1yZUPOz0F17Oj7PmNgbw/Q4dUutTIknXiJJdc5EjvSCwZ0HOz78AAdqWgW5dabnHvje6ZS55DLlUDHwb73j9CxjHk9IbavCo92UCZLhY5rco2ExRo6VsksD3WIzXV+Uya+auqADmPo8EQOtdk0NuVzrnPkQi3QYQwdfXIEWYdMBRS5ajoAHcbQ8Zoz2dhmK0G2IhU4UhUO6LCHjjG2NXS2MhZwTEwOB3RYRIdvuisy7jPVQ+pMDqDDXMKSsBHbqY6psCNUzZFK+UCHOXSstxNopIPHizU5gA5z6MhF0vVIRx0VVOQYBqDDGDqayGCfSaqASfGcBkuADpuqoy11jHoYLEh45F7wBeiwpjrKEVE59ybbkFQ9T4+K7HIDHcbQseKGXJqtksOd5VkBOuypDiU7xORaNmXPQo4UHacT0GEOHaM4GQdpy46h6a0UcpyADnOqo3lUQgiSr0i2ksiRX5Vh+A9+nsbQUd8V3qYOxdqnJcflK2od1tCxWk4YZY1aJMeZUtnT9b8L0GELHa86mS2n7UtrRWIjR8cJ6LCFjg+jLnTQ/XJ+VII0V/hZuVy+Ah2m0PH+1bfDYK0Fw7kK0lMKD6DjsOjwj9HB25BneVWu70oWpCdCxz/w87SFjriSpCGPoNfyOYmOU/4QHIdFR4x9dKw6b/lRCeVVkVXuKzhAjiOjw/dVR6wLCnI44RwazXGlxjU6QI7josMvy+dtdEzSmq16dD5XcKRXBeQ4MDp87KqOJlvhXJaGz+dSIU3g+ApyHFl1+LuqI3Auq9qyEhuXay4LchwaHf6qSR/UOibJZc/tPMcF2crhVccDdEzFS7CMF89SPke2cviExce7qmMcy25CWrKfZYb0NIAcx0YHWT19+e0eOuSKl5CjzPpAkFpAh/9lEx1BDRiHojlKyx7l80OrjmRmew8d5SI1V0hrgRSaw0LC4u+hYywXADM5krEPJyvIVo6ODh+zPe3nDXTwkn3tymZyqCIYyHFodMQH6CgTHWceBJPeCrKV46OD7g1/2UTHqE5qrMYEQY6jo4OiYxsd5FVbySE7TaiQGkAH21rfUR0sR6vmmEEOG+iIct+tgw517Y2zlbk+K9AcBtCR7yv4sYeOKCVSZUNal+wvF5Dj4OgQcozxZi36XclWQhnnUC17QgeC47joKJoj+s/r//laJjrULuSs1iEvXzHPceDvJ6p0ZI/JL11wVGP8okidyFE03g79fcqSY8zoWP+aX9TNpmoz6eqU4PVRQePtwOB4qydlb8Dxqtaa8rDP1O7KXjAmeHBw5O6KvwOOUj6vdoJ0a+6SNQeelWODg+vnfXDotabA3i2FHEhlDw6Ohdqyfhsc4jOpurK0Kosi2NHBQbHRA0dr0lHmi6sPKchxdHBwKnsLjtg+KkwOdy5VDmQrx1ccuXp+C47YHBDV3i3noXq3IFs5ODiWLjjqaY2gp8+LID3lrSaQ49DgyOjogKM1yM+xUa7xKHsOCNJDg8Nf/9yCI5/lqSYM2hW/2VsBOQ4NjuT9dBccbNBRyeFqgRTPysEVh19uwJFu8jS3E1pyOElWUD4/OjhuFccbOfv4atBRN6lVbwXrkIcHx9IBR5r9iboIViyM3WpKEOQwBg46Iep1ESxtNUkuWyqk0BwGwbF4Msf3jQXDmhx52gfZijnF4X0ih9fZSp3nmNtCB4LDluLIr0pJZgNnK3UbUulR2FsbA8cS5Wz5uvfWkIPAAWN8c+CIutCR73iF9aGmS+68/Q/gMAWOyGsso27LhuZQkyvkADhspSq0V60LHWHULqQ1kx2gOKwpDs/PipoEU1v2tSub6hwAhy1w8Cx6fldWu7KTOILNAIdNcEh0xFF1ZoNeTajDPgCHSXBEVSKdpuoXV7uyV0H6B8BhDBxLFR2x3NVQV2XVKR6Aw1iqEnmNZVSCNOTNldx4m+VVuQoOgMMgOAo59OaKNsbnXBbgMAaO6j2pps8nbtm3/sUAh0VweLKB8uqofdCn7GeAwyw4mBx+3XZTM6TpAzjsgSP7XUuJVIZIcwFdTmqwuzXAYREcpEh16y3U85BZcziAwyo4eO1+VPGxPsYDcFgFx0J6NFY1qsvnvPAGcBgEh7RWch1MwiO0V4dTdAAcNsGRrfJHkh1+/aywCynAYRIcrEcXLUhXXdmr5vgZP02L4IhCjipIQ6hHh/N4sQM4jIJjudUczammRI4/8dO0qThiroONethHpgQnnj4HOMyCQw57LSP7t0wrckBx7Ob7+J2+lydTFYqNptTBk2BSIf0vwLGT7/fh2c85TifOIdBz4P3S/e4rjjpirHZXFDkAjt08BvNTgXH995z/UVNoTPn4FqWkve8uOLIrKfdl601qMYwDOPYFDhnZvBcbV25cyZHRkfA/3SXHfcVB8Mjj56XWQcM+PEMKcOwHHAkd9+PDZXLMqXjpMjkSO0a6ofJ3wOF5EkxlK8rZB6nKfsAxD254+mWhbxJy9GPjITiKIOVJQclWqH4OcOxLcTzSHW7IUxbXL8XH9ZeYPDVGnwf+vhUcVOhY7VInFcPm1lAcOwIH7R66J3IVjg1NjqUTHTfguA0fX1wYyuqKpCsAx37A4YYn0JHBMdfYuJKDNEdXkD4Gh19823hTFzUAjt2Aw+XfvHuuypHkqAjSQMmKvw2PW+vAHjkolS3ZbPHnADh2pDieFKNDGvpN6Yoo0lTo8F1BegOOm/CJy0pxlDNeAMeewOE4i3V3X5YkS9J2s0uH5klyZHLEVAZ7BI6x8/J4dYmYrX34GA/AsaNUxfHv/nEVTAnS9KoEfla+HRycqxTTOC06AI79pCp5zvu5+rlTz8pEmiPtnfwdcPiFN1fUyluaIr2SA+DYDTjm4UkxmjZJ5iJIJ66Q9godz4AjnwSMmhyBBzoAjv2AY8jmW3P/XTltk+Ms5Lgpnz+TqtR9SOUZR+uQAMd+wMHk6L0rlzU6UnQkc2ESpNKW9Uv8dnD4yE17P7ZtWYBjR+D4ti9Fx2qeY92WfXlcHG1LpNR742xlAjh28r3/+AO+9b/8l7gRGjlhUYWO7H4OcFj63i1+2WQHN+19meeA4jD1vXjvt+Qo7yYo2yeAwxQ4Xse4PFQdpXwOcJgCR7eEqjv29arGNAIcpsCxOWQaa6XDFz0KcFhKh17C1hxhnj5f9VYADkvfh/O0NWUq5FDePgCHKXD8M0gRtdNaKd74Qg6AwxY4Uh11a+upmMax6AA4bIHjnJ+Vfr7ieeWt2Ft/BjhsgYNbMPdEhwx0ABzWwHHm3ZbYCw0WpBHgMAqONBWUBk375FDnQwEOY6lKeVY6a08lXfEAh0FwjJOsMPT3F9RAxzVAAA5L4HglO4XAqqNTII31ZDnAYQ0cvNw4hq06GO8meIDDGjhSB56flc67krlRrX0ADlvgqHvRU7+EzuTI/i0Ahy1wpOio6cq4xE4NTHorAIcxcNC1RwmPW6uGGMuJyAhwmAKHpysIHBtJki6dWgfnsQCHKXCUE+TZeTAPdYz+1p6D6udQHLbAwa4K9VlJoiMuXSvS8QvAYQoc3E8T0XGmdfybZNZDcZgDxxsP/ulcdj3V4aV87qE4bKUqdQO29FeyBVDXogPgMAWOssjGjsRTYDdbv7L2SbEBcJgCh96dn+pQhx9VdMRifg5w2FIcOUcdfZuvZHTEm5srSFX28v367x//fUpSojjeSx0sTaE3kjTShDHAsZfvp7W7vRzbc+5Jy7i1MWn3MA/vz6eMJShFeqM60rMCcPyfvWtZtRw5gt8weOP14B+w23g/IIpcGyStbUpCPyDOeqAQ+mxX5auyJJ32GLwoUKrvdEP3mc1V3siIyFcvz9+HhHu9MBiaR/7if1nyQzEV6fpKXfSDqkT7/7S8wgttqxPmwNEZcKT6WnktYOATKrxS8I9HRyTkCLiydqmHm+bZbIKzVgdW3/aPpR2zA0dHwDEcqcQGLwXMgRFwARxDRwjPy2phSPLVIscQNUPREYWZ5xCokYfUbJN4KnKQknXg6AU4ANKRn4HWiSJ2lNhgzhG+nOSB78ARgq6d5CMKhBm1yUsqs9RnPM/mJFyxSB04ugGOM8G2beVmFy2bpeO+ChzDHz/YRMjBvGWVg4DMODivyMIey0ipIQxXxWFWceDoBjhSQuQ4DskHRDxMdDywjsRfaZDfzTlAWVmLSyJHTRwzL4MzTgdR0l1OwmGIOOPoCDhOOM6MHbiXtoTHwISD8gpFzCNIYGZJ8Igc69rsyafYoNRCgoWdDmUdH2r7KanHgaMb4DghnRs+fKttpSMICBxDfFQqIJwjPV2LpP9bOIfsyacTGyJmRa5g3mHWwS6YA0dHwFGigykpaZNyQ3jV6CDaEYafkFKwsREMI10XSzo+2OQl9ZVFPjLJP8+Uehw4egGOHBtn4RwJ5QqGAv7Uc1b5JmOZc2BWSQ2CEPzIfepFssZMBwGrmDVypVmk71KlK+A4z+PckJGmcBBlQDFL7nkIX1fjA0MG3I5syIWNGh471td2zitz1Stshey8s8WBoyfGgbFxIOuI6xH5J595KBtg4UGswLfzK6RW+BzgqlJ1Zy1SeKn2dGxygmOX8SYHjs6Ao2SWHB7DBlHPj6vPgYHyRawA26QNL+WwUs4h1ZWdEgvf6arIIWqWjTAHjq6AI0NHDo2Q00qkNKJOKZVWfsZFv6oVqa2oP/5BQkoHVcbZkI7m1qh3jvYHHJlznLCVVx2Ek/6ssoLeBjRiJdXYGOoNYr7OM3K/16yzsOOddFDl3oGjH3PUREexSLNkCUIbOD7uyJGMA8ZqBWx1pV62X6eJkUPUCIkWrMzqQLUcsc409ePA0Q9wSFo5t3MD5KRVbiBofOUcafhOSeshUTxBjC0bLEd03BGhI3/gqAWW8gEHjl6AY6jAcW7pSAQeJE4i9+yEb5WVoRZVLg56xNpKZHN8HWlLC7URo3v+2bmlQygpFW7zlwNHN8ABAJvEBqnZWLAjiFEqrWHhgYwq47hERmiQA+3zparZWS8xidMRK+sYvY+jI+DIwVGRA4qYPZB0MCnVg+Ut7Ujmt/R0MZJO28c6fKANHTyy9PlgIykBx6Yf8iG3fp5/5B/+LFKsYNm2SioxROKzew6qZRE3UstHh6Badlpt0f7D7YDULIgHhSWvEDFx4OgFOGJGjhobsElXB8tRKbrFG+WAwTIOMFAiuFHzipyZHffd9HrtbJLW2Jh8A1hXwDH8MWfoAAAQHklEQVQUdXJuBjqyYKmlVUwpMXwpyCb46QFzjQ1t6GCjY69Hp6Vsf/CVc18d2BNwDMNhYiMHyiEPpQaJjgY6kIgm016MZZZkh1aorhtbD2weWcjOFB22y5j7jB04ugGOEDAO2vAAYR2By/ePaqXhn+lamA3GP59qQ8dcOwV5BUdpFiRGSrLGgaMb4IglrYCJDSjIkbDnh5vIf9LiQyU3sUlNvHAPKTeRVs4x27k27unIscGsY1nHxYGjH+AYiqmxVblSYINM9CR6hUu04UszB/53lyuB1UpgREBzfKbooJlp7upg5KAS3ernEToCjrhSWtHoKL2CPKTACBCk0ydeYSNZ+zzdCrOKHNMqyGHtc94zmqOjIMdGEOPA0Q1wrPm1r4dFDm4IS4QcbHzF4bHRR8IkAUi/YLKUo7pgS40OdMGowZziA2/GFtKB4eHA0QtwYA/gsTV5JWFDGKtZmmSKZHOE5wZBeC7BcYNxaGOD9lXvzdGMIlfE6nDg6EiqYF7B2KjYkSg6ND4G7v15aC0WCQstHeVAig1yVBuMuKjEB+IJO+gOHP0AB/YPH9vaSNksWCDnFHI62PyK/31iBdj2sCsYTM1+WcZJZhNmU7NH6EDkKJ/027E9MY78o72tZHRstWyPA05Nzx9VWR4G7I0NduOkUdTKsqy1tjLyMCyPIBgf7Aj/9LfSC3BEXMCxBiQdBjkKIR1SEmUahoeUovI1DXf+wTmF5rGDNTpm3tEhdFQKsxOmFQeOboADBwdybBwHy1lNK8cJpa3jOmpwH2YidwOgOufQbG8paetSXNnrzOPOO861kfTf/la6YRxly0J5exuapPY5ijo9kn3TX8puSa1RGOC290nnISsfnZs7svtnrIuuf3fg6IZxFA5YBkuOI8Yms5SG4yPderuuwJEUQYCzCzRyhXYwYHxMWlvRHR27bjjXAQVnHP0ABymJuK7bjXRkIXskGx9NO4eQC+YcKTEDSdcdDI1aWXg2oSIHLWLQ+QRnHD0BB4ZGiNsaL6RjO7NgOdL31nJNKoIccGkBEp9DCm+YV3QD/mzWBmJ4lJJ+dI+jI+DgYhdyjrV1OnJsZNIB8CWrmEJs0tmmy864aOfsK3LsY20jFaeDtKwDRy/PX+sOWnQmW6eDo+O4EQ8rVUBNUkouX3rB1lvljdSK7qMtldqy/smBoxfg+PNqo2NDI8xyjkxK05HSdUPgU5SARolNQ9xDqlq2IIfZC/bZK+f4IOfwqko3jIMrYqs0UmDt7WiiA92LZ+jQSmxK6qKD3eXC9Rg7LLvodAKX3nTlKK2rdeDoyuNQ5AjHEW56JSeWHAHbnZPCjX0klC9wkSvRtBhPk5hgMhG5m8vCJWaccXRkjlbgwL7v4046Ej5PXAIjokRDbRGEh8iJdXCFW4wXmXfcaYcLq5UMHg4c/QBHaO4ilPC4Isd5nOXdX+HA2ByaT8C0hd1W+wSZh9TV+IocM42uYAu6M44+gWMl4AiN05FJR8aOk1zQR9qB1nmqyJGYk4KNj0gerCxw0R5j0ytIwysOHL0Axy021gfkQDELADB82QMG2vCTUv17aAdXWKyYmv3O+yR5NxhV3hw4+jFHQxsdx3psIV49dGQdD/cQ9FKCVbDwsDvuusNYyrK1+Mbh4WP1HQFHPXSxNMjRQkdGDmKkcGnjSVpZYb6qnT4J2sigPcgiV4zPQfNMOr3iwNGPxyF9v6uJjfVSXims45S8AnfvCwQ5yApJyXR4WAudt00SclgDfeYOdL+r0htwcAfOyqv8tpVa0NMFObDCMrRGabJOGCsUsdBtS0fTRIpqRZdNSpMxZRa/5NYRcAxqW2JoTGqGlZafJrMkIqVDy0u5PK+cg53UZOr4YrbXkTdEDjQ6ZvFI2STNGcaBoxvgCAOt6lqokG4ox5V0FJ+UXvvTRBtwYcUe1UiXnBKp7Mt9gos1OvjizsfvqvQEHOY2aCakdZ7oRjoYOQa4OmEJ+0aZeACnntSWVq6dgrhtUvafcxspT7A4cHQDHMXVpr0IRaywYNnWWCqz6YocnFcojdAvlSZAjWBJWtAvvUG0E1sLb2bxE1XtdSbSgaMj4Cj7WGTjAcbGZCqzbWZJnFiugkXigINCjDC4DK/InSepvPG1prqNFGcUHDj6AY4SHavcT6pWBy2YvJIOoaQJ2QWYNdbslUPd0HHZwiAnF9b1um1Sq/azH2Tq6fmLmg/F4yg/zEVjVh8MLnV7csJqx2CqTefczkFBA8NlX5wtywbeU1tig6r2u5yX9WXFnQWHMAGqd6heOQZCDrjklcSle1C/AxQmCDlKkCAnhcY7D3a1Dw/amw3oXHtz4OgROVCrTFQsJc5xHA9qFtBEB+kYNSueEFH4D44cM28vgytcll3MXY3ZjFM7cHSGHKYhvATGogb63SQtOMLQoYtGKYkk8c4ppaTn46FVrvDip3pThRpIHTg6Qw6eF+CsQoe0kHLEeCUdBjqSJg5ZMgkyupLUMk330koTHbXhhwdmHTj6RA6CDgyQpbpg5/1h5IA68JgUOYB7R1OdggNt9THRMRktO6t/7uXY3oJDBGYbG2VmlpwOuEXGSawCakMgAkclIuSU3o9qxIsLNi6NDebmaG/BESpyaFZBxRIycgxPyFGMsBPscnPOMkxEk4ja60zTcNnto7PUtOX6l19+OHD0xzmKabkQCSg0kdVsoMSSqppl8frbL//n508/fvzt11/9dfTMOUpsjNXr2Li88rt/n1ytkC21UGKhyjoihwfHqwmpbn+cytoU2T0ei5bdwIPj3YS0Igd9idVRkCOBB8eL04q0kJJ8mPQ+Y2YcpbziyPHe4IhMSCcRK7h6XASLcw4npLEiBxthCB0RSYcHx4sJaW3rxDVdEy7zW7TPePDgeG9a4ZkmLnVMdBN64rnI4Gnl5WpFGnAUORYJD+z4+c2/T29OK4QcVAibjF4hLevI8WpCqkNoVCdFo6OQjtJ6vA2OHK/nHJMpoS+8fNylrCOHIgdV3ohycGKJ0ZHDOcdihlflbAGecgMPDlcrdVZgGhd1Ohw53p5WhHPUzqyF0koo96k9OF5NSIVzjKN2dVJPR7mi4MjxZuTgwluFjqXw0oXajIctenC8NzgGXglmx0gqJXXkeHVa4V6fyQyvjrWTNAweHC+Xsrrfz0IHiZXoaeXVUjayWhn5spYx0F3Kvjk46rb6pZkykuJbcOR4M3KEoDeim6zCY5EeHK9WK80JlCY6XK28PK0Y5OAeQbVIaXol/su/Ty9WK0XKmuvyhnV4Wnm9z2Fm7FtCujhyuM8hamVsOCkb6MGR472cg0dlcTGonDEwrMORwzkHt5COV7mSH0eOt3MOssAm2bNTbTBHjhcHR6g1+1asOHJ4cAwVOeQi36wt6Isjx7vTSp2VrcgxU/WNoMOD481phecSprGVK9wq6FL2vVLWqpUL5+BuMEcOVysqZPeZaQcXZh053ptWeG3stNyMDkeOlweHbH1aTVLZx9nmFQ+O13IOmYas7RwYG7vWZT04Xu1zyEaw8fJMjhyOHHZHrckrRdoWLevB8XbkWCcjVoR1LJ5WXMrqEa/HvOLB8Vq1olJWHdIMHbPVsh4cL04rNCm7SsF+1+RSNk/mxOLB8XYpa+dW9v+0dwc3kttAFECBdQQGPPZ5L753Dou9+6BmAqPOgFD6bokskuoeTQJ87zABDAqfRbKoTv0UzLIydXK0pwnL2qJj/0m+OvCzKo55e47hV2Xjtj6lNoG+SA5b2cfp18P7CbrkmL7nqD8f3kZ94vh838s+7opj0uI4Htl/1iv7e29Hcy2PvSNVHNMmx69+CBbtaM45hsEkx9Q9R/sVr3G3suS4ln1Wx3/+T7PuVmrPMU765H0WLGY6LCtzJ8fnadgn53Z6XjpSySE5yquVVE86yinYXXJMvpUdf/7vKI+UTl9ikBzTLiv9AwzjkGDO7XmC5Jh3WSm7leEDDPUELCfJITn6p1vWtqrkuJjdmw7JMXPPMR6CpSWN8+d7dEiOSYsjjs9P/eieHbU69l2M5Jh4K/tZh8+XqI7jpKNf20uOiZeV3+OnW3JPjtiuSI6Jk+MRP6jRXq2U5MiSQ8/x2X+q/JjlOO1W7pJj6mWlPVsZpsD6bmWVHJKjvVrJx71KG+m4L5Jj1uQYZn3W3nO0QcG75Jg4OfqDtzo+mlJ9LRsjxpJj4uQoT5raCGnZzR6HHXoOyRG/ZB+T52kZZ0iXVXFMmxzHdmV91KeyqQwJHgdhSXLMnhz1i2DxVDaV8/P+XFZyTL1bqYNgMeqTjs1KTjHPsSiOeXuOR//0edvHDuPnTkinLY765fM+CFZCY3iaIDnmXVb2ReV3HwRL8QHj/l5WzzF5cgxfmiy50R+v2K3MnRx9hLR0Gzn35wnOOab176+3nmNpTUeutyuKY04/hl+VbTOCOZ3PSO1WZo2OSI62rJT6yPFVMOcc8/rjJTliDGyYMdZzTBwd+062vUwodyq538reF7uVeaPjMQ6fp3JCWkojqkNxzBsd9WolnlEf/UYJEMuK6BiHz4/cONRJsNWyMrNb/Z2m/tt/uW5XLCui468hOXLsVlL7ArplZeroGHqOWFaOCkluZUXH3234PMeikvuPrug5Jo+OtZ2CjdVRvzWpOOaOjvb54tislNf2WXJwO1+8PW1lUtBuhT069t1K3ciWaZ+4lZUcouMew+dtXSknHZJj+uj4aN+2zud+1MUbt6V+niPXU4420SE5RMfH8Gglbym1nwCUHNxO126lK9VzMERHGpqOeNckObjFHNhTHu5lJQclOlKf52i/q+H4nGd0RGnExVud9lEc7NFReo6trit1Fkxx8IyOcu/2emevONijIw3ikb3kYI+O1nTUU7AsOWjRMWxksxlSXqMj19Pz+rFauxUiOkpl7H/aQ3vJQY2OtBwb2W24eVMc1OjYUj3niCt7dyu06IjNSpYcnKPjn3JCuvWeQ3IQ0bGlrW1n9+pwK8sYHduRHovk4DU69o5jGy/tFQctOupWtk6CWVY4dR2Sg6vo2OohWDnocELK2HXstdEfRCoOTl1Hf7nihJTXrqPc2WfJwVvXMfSjkoPXrqN/UFBxcI6O+AVRuxXeomNYWBQHrxuW2MrqOXjfsMT4ueLgNTqSX4fkm+goTYfi4IvocHzOxYaltqSWFd6i4yO7sucqOpb6IlJxcBUdlhW+iA7LCt9Eh0MwLrsOPQeX0aHn4PuuQ3FwGR2Kg6+7DsXBd9GhOLiMDsXBVXSYBOM6OhQHl9GhOLiMDsXBZXQoDi6jQ3FwGR1/+h9w5ad/AVd++BcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADA2f+ZQetDAT521gAAAABJRU5ErkJggg==")),
        ["Antibrute"] = images.load(base64.decode("iVBORw0KGgoAAAANSUhEUgAAAfQAAAH0CAMAAAD8CC+4AAAAAXNSR0IB2cksfwAAAAlwSFlzAAALEwAACxMBAJqcGAAAAwBQTFRFAAAA////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Bz0LCAAAAQB0Uk5TAAECAwUHCAYEDA8KFhEJIRoTDi8tJR0QQjwyKCIbFQtUS0E3Jh8YZ1xSRz0z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")),
        ["Antiaim"]   = images.load(base64.decode("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")),
        ["Visuals"]   = images.load(base64.decode("iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAABmJLR0QA/wD/AP+gvaeTAAACwklEQVRoge2YO28TQRRGvzF0KOkgxC4xEkGiQ2l4KJRIgGh5FAhET+jS5ReYEuUFVUSLSH4FJVIAJa5AedNBgZXAodixMt74MbO7EwfFR7K0O75z73dnZ2b3jjRgwMnGxHIMlCQ9tLeLxhhixYoC8JgDHsWKU4rlWFLVub4YK0jMBI6Ek5MAMAyMxRRj41wGhn3tvRKwDlckfQZm7Q7Ti0aH604xSsCsjbMCDPlo88KOistCrySAKrAGrAIXPMQvpGIU+7TtyAcl4em3nfjZIjT7BKoV4PdVnoEJehNbx3OSntqmTWNMOWUzIumupHFJo7Z5Q9JHSUvGmJ2U/ZakEXv7RtJzY8zfEF1B2CdRAzaAF057BZgH9unMnp2KZaffpPVVK2JKZk3qGrDdRXiaH8CtvohNA0wAjQDxTRrAjX6Lr9jRzMoOMNo7UrwE5nOIbzKTR0PmeoBkt1mXdCqPAEn7kirp3cmXPKv+nvKLl6TTku7k6dwCB5VUJfXXH0nvjTF1e381a9A2jCt5BwioSrqvw4OzLp/KjtZKKs2qY7dUwPxv8sHxW+9id6iyO471QFDtfGgKSVq0Tq6k2n9Jeufcb4Tp6orr67akB5LOpGw+peLnA3hW4BR6klVHnm30nJKF1e4phrAvqWyM2c3SOfMasPv226z9Heayis8NUAZ2c0ydbeB8X8Q7Sdwk28fcb+B6X8U3Ifmc3goQvwtM9EtsiaQM3AQmnfZRYIakaOnEHvAaZ9oAL62vTAVNjJLyrA5KyuZ/60pKyuX0guWoSkriFfW1lM9CTjvaBfp/j1XIfrBVt79qD9u4B1sk56LfreMZn5EHphwxUx72Jecpf6PIo0UbYAi4FGA/7SQwHdBvLES893eMMeanpK++9lkxxnwJsT+O9UAQgwS6UHeu12IFyfst341mZYeKrKQGDBjQwj9xiyOIITS/uQAAAABJRU5ErkJggg==")),
        ["Misc"]      = images.load(base64.decode("iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAABmJLR0QA/wD/AP+gvaeTAAACWUlEQVRoge2ZsW4TQRCG/40tmqAgemInUtIAEu4Cb0CchgYkBK/jBwgIUVNESDS8gBtsKQ+AEJWxA/gBQoGUUPBReJGs47y3c751hHyfdM16duafvbvZ9ZxUU1NTU7MELoVTYF/SI0kbfui3pPfOuVGKeJUCOGDCv4yBJAtWKUArR/xftquOt1FskiuyAbQXrOidwNS7Ob6c99Uoo8UMsAUM/Ip+ANp+vAkcAf3AHeh7m6af0/Y+8D63ViH+NCPqHOgBXwLCs4z8nPPM+GmyJPxjMzSILMsAiH60o6sCsCtpXCp7OzvOua8xhpaX+EzSoJweE4NY8ZJxIwNuSfoo6aZVVSQ/JHWcc2exE0xl1Dk3lfTaqsrAK4t4M8xKZVG1uQCOgQNg018HwAv/W4gRvsSmSuCoQMAUuBeY3/E2IbophLeAh4Q3qYuQ+EwSoTvR97FaVQjfJ/9glsexwe/LSJ9jYC/kq+glfixpJ1LXSaSdxXZX0pOQQVEC1yIDSdJng+0ng21QQ6nTaAVUFrfI0S+Dr9uJbIMaihJ4J2kSGeh5pJ0kPYu0m3gNywFsE1dGOxG+OsBlwE91ZTQneLeg7E1DSXBVG9mcgCaz7T7EJbM6fx+47q8Hfiy08pD6KOGT6BWIWIaeVc/6HKeZdSBOlE68JN2Q9AZD/2it/lJ+kzQsp8fEUNL3JJ4Jt1WKqtM8q2+rZJJY1NjqUtzY6nJVja25JBos2CmBw0AChwvmtDD0gpLCipu7lcOsWTvOEZ+kvZ7qA8eepKeSNv3QT0lv/4sPHDU1NTXrxR8yaoA8EZCxiwAAAABJRU5ErkJggg=="))
    },
    active = "Antiaim",
    alpha = 0
}

paradox.util = {
    dt_charged = false,
    team = {[2] = "T", [3] = "CT"},
    background_texture = renderer.load_rgba("\x14\x14\x14\xFF\x14\x14\x14\xFF\x0c\x0c\x0c\xFF\x14\x14\x14\xFF\x0c\x0c\x0c\xFF\x14\x14\x14\xFF\x0c\x0c\x0c\xFF\x14\x14\x14\xFF\x0c\x0c\x0c\xFF\x14\x14\x14\xFF\x14\x14\x14\xFF\x14\x14\x14\xFF\x0c\x0c\x0c\xFF\x14\x14\x14\xFF\x0c\x0c\x0c\xFF\x14\x14\x14\xFF", 4, 4)
}

paradox.math = {
    round = LPH_NO_VIRTUALIZE(function(val, idp)
        local mult = 10^(idp or 0)
        return math.floor(val * mult + 0.5) / mult
    end),

    lerp = LPH_NO_VIRTUALIZE(function(a, b, t)
        return a + (b - a) * t
    end),
    
    closest_point = LPH_NO_VIRTUALIZE(function(a, b, point)
        local a2point = point - a
        local a2b = b - a
    
        local a2b_mag = a2b.x^2 + a2b.y^2
    
        local dot_product = a2point:dot(a2b) / a2b_mag
    
        return a + a2b * dot_product
    end),

    distance_to_line = LPH_NO_VIRTUALIZE(function(a, b, point)
        local ab = b - a
        local t = math.min(math.max((point - a):dot(ab) / ab:dot(ab), 0), 1)
        return (point - (a + ab * t)):length()
    end)
}

paradox.func = {
    dump = function(arr)
        if type(arr) == 'table' then
            local s = '{ '
            for k,v in pairs(arr) do
                if type(k) ~= 'number' then k = '"'..k..'"' end
                s = s .. '['..k..'] = ' .. paradox.func.dump(v) .. ','
            end
            return s .. '} '
        else
            return tostring(arr)
        end
    end,

    glow = LPH_NO_VIRTUALIZE(function(pos, size, col, amount)
        local radius = 10
        local x, y = pos.x, pos.y
        local r, g, b, a = col:unpack()
        local w, h = size.x, size.y

        -- we need to compensate for the size of the circle and repect the size of the box

        local circ = {
            {x = x + w, y = y - h},
            {x = x - w, y = y - h},
            {x = x - w, y = y + h},
            {x = x + w, y = y + h}
        }

        for a = 1, amount do
            local alpha = 10 - (10 / amount * a)
            for b = 1, 4 do
                -- offset the circle to make it fade out
                local offset = 0.5 * a
                local x, y = circ[b].x, circ[b].y

                if b == 1 then
                    x = x + offset
                    y = y - offset
                elseif b == 2 then
                    x = x - offset
                    y = y - offset
                elseif b == 3 then
                    y = y + offset
                    x = x - offset
                elseif b == 4 then
                    y = y + offset
                    x = x + offset
                end
                renderer.circle(x, y, r, g, b, alpha, radius, 90 * b, 0.25)
            end
        end
    end),

    gradient_text = LPH_NO_VIRTUALIZE(function(text, col, speed)
        local final_text = ''
        local curtime = globals.curtime()
        local r, g, b, a = col.r, col.g, col.b, col.a
        local center = math.floor(#text / 2) + 1  -- calculate the center of the text
        for i=1, #text do
            -- calculate the distance from the center character
            local distance = math.abs(i - center)
            -- calculate the alpha based on the distance and the speed and time
            a = 255 - math.abs(255 * math.sin(speed * curtime / 4 - distance * 4 / 20))
            local col = color.new(r, g, b, a):hex()
            final_text = final_text .. '\a' .. col .. text:sub(i, i)
        end
        return final_text
    end),

    index = LPH_NO_VIRTUALIZE(function(tbl, val)
        for k, v in next, tbl do
            if v == val then
                return k
            end
        end
    end),

    attack_fix = function(cmd)
        if paradox.cache.menu.is_menu_open then
            if cmd.in_attack then
                cmd.in_attack = 0
            end
        end
    end,
    contains = LPH_NO_VIRTUALIZE(function(tbl, val)
        for k, v in next, tbl do
            if v == val then
                return true
            end
        end
    end),

    keys = LPH_NO_VIRTUALIZE(function(tbl)
        local keys = {}
        for k, v in next, tbl do
            table.insert(keys, k)
        end
        return keys
    end),

    closest_player = LPH_NO_VIRTUALIZE(function(enemies_only, dist)
        local local_player = entity.get_local_player()
        local local_pos = vector(entity.get_origin(local_player))
    
        for ent = 1, globals.maxplayers() do
            if not entity.is_alive(ent) then goto continue end
            if enemies_only and not entity.is_enemy(ent) then goto continue end
    
            local ent_pos = vector(entity.get_origin(ent))
            local ent_dist = local_pos:dist(ent_pos)
    
            if ent_dist < dist then
                return ent
            end
    
            ::continue::
        end
    
        return nil
    end),

    players_in_range = LPH_NO_VIRTUALIZE(function(enemies_only, dist)
        local local_player = entity.get_local_player()
        local local_pos = vector(entity.get_origin(local_player))
    
        local players = {}
    
        for ent = 1, globals.maxplayers() do
            if not entity.is_alive(ent) then goto continue end
            if enemies_only and not entity.is_enemy(ent) then goto continue end
    
            local ent_pos = vector(entity.get_origin(ent))
            local ent_dist = local_pos:dist(ent_pos)
    
            if ent_dist < dist then
                table.insert(players, ent)
            end
    
            ::continue::
        end
    
        return players
    end),

    is_hovering = LPH_NO_VIRTUALIZE(function(pos, size)
        local mouse_pos = ui.mouse_position()
        return mouse_pos.x > pos.x and mouse_pos.x < pos.x + size.x and mouse_pos.y > pos.y and mouse_pos.y < pos.y + size.y
    end),
    
    hovering_menu = LPH_NO_VIRTUALIZE(function()
        local menu_pos = ui.menu_position() - vector(0, 58)
        local menu_size = ui.menu_size() + vector(0, 58)
        return paradox.func.is_hovering(menu_pos, menu_size)
    end),

    print = LPH_NO_VIRTUALIZE(function(col, ...)
        local args = {...}

        client.color_log(col.r, col.g, col.b, "{Paradox} \0")

        for i = 1, #args do
            local r, g, b = 200, 200, 200
            local arg = args[i]

            if arg:find("<<") then
                arg = arg:gsub("<<", "")
                r, g, b = col:unpack()
            end

            client.color_log(r, g, b, arg .. (i == #args and "\0" or " \0"))
            if i == #args then client.color_log(200, 200, 200, ".") end
        end
    end),
    
    clamp = LPH_NO_VIRTUALIZE(function(val, min, max)
        return math.max(min, math.min(max, val))
    end),

    hide_aa = LPH_NO_VIRTUALIZE(function(bool)
        for _, v in pairs(gs.aa) do
            v:set_visible(not bool)
        end
    end)
}

paradox.visuals = {
    indicator_fix = {
        indicators = {}
    },
    keybinds = {
        modes = { "always", "holding", "toggled", "off hotkey" },
        hovering_binds = false,
        hovering = false,
        dragging = false,
        in_drag = false,
        drag_pos = vector(0, 0),
        pos = vector(500, 500),
        size = vector(0, 0),
        opacity = 0,
        icon = images.load(base64.decode("iVBORw0KGgoAAAANSUhEUgAAAFoAAABaCAYAAAA4qEECAAAABmJLR0QA/wD/AP+gvaeTAAABpklEQVR4nO3cwUkDQRiG4W9EiKB2YAeKOdpEKtgCTE161w4swluCYgVWoOvBXMbDJjI7ukhi9lszvs8twwq/L0OiQxgJAAAAAAAAAAAA6wnfLcYYDyRNJVWSTiUdOofaQW+SHiXdSroKIbznD3wJHWM8kXQn6bz38co0lzQJITyni63Qy518LyL/1lzSRbqz97IHpiLyNowlXaYLeejKN0vxWi3zt45XSUfWccpVhxCOVy/y0NE/T7lCCJ9987cO9ITQJoQ2IbQJoU321/2B9JM01fUXy397vgs72oTQJoQ2IbQJoU046+gRZx0DILQJoU0IbUJok62ddXTZlTOKbf1eXdjRJoQ2IbQJoU0IbcJZR4846xgAoU0IbUJoE0KbDPa9jr+G73UUgtAmhDYhtAmhTTjr6BFnHQMgtAmhTQhtQmiTPHQ9yBRleklf5KGfjIOUrtUyD31jHKR0rZb5PywjNRejjJ0TFWim5mKUxWqhtaOXN6ZM1Nyggs3M1Fz1s0gXuw61R2puUKkknYk7PH5SS3pQc3nVdR4ZAAAAAAAAAAAAm/gATHl6VR/z5kIAAAAASUVORK5CYII=")),
    },

    indicators = {
        state = { pos = vector(0, 0), enabled = true },
        title = { text = "PARADOX", pos = vector(0, 0), enabled = true },
        dmg = { key = function() return gs.rage.mdo:get() and gs.rage.mdo_key:get() end, alpha = 0, text = "DMG", pos = vector(0, 0), enabled = true },
        binds = {
            baim = { key = function() return gs.rage.baim:get() end, color = color.new(255, 255, 255), text = "BAIM", pos = vector(0, 0), enabled = true },
            safe = { key = function() return gs.rage.safe:get() end, color = color.new(255, 255, 255), text = "SAFE", pos = vector(0, 0), enabled = true },
            fs = { key = function() return gs.aa.freestanding:get() end, color = color.new(255, 255, 255), text = "FS", pos = vector(0, 0), enabled = true },
            dt = { key = function() return gs.rage.double_tap_key:get() and gs.rage.double_tap:get() end, color = color.new(255, 255, 255), text = "DT", pos = vector(0, 0), enabled = true },
            hs = { key = function() return gs.misc.hide_shots_key:get() and gs.misc.hide_shots:get() end, color = color.new(255, 255, 255), text = "HIDE", pos = vector(0, 0), enabled = true },
        }
    },

    warnings = {
        radius = 300,
        dragging = false,
        hovering = false,
        zeus = {
            icon = "weapon_taser"
        }, 
        knife = {
            icon = "knife_karambit"
        }
    },
    
    forced_watermark = {
        text = "Paradox.pub",
        pos = vector(client.screen_size()/2, select(2, client.screen_size())-55)
    },

    watermark = {
        size = vector(0, 0),
        pos = vector(client.screen_size(), 10),
        options = {
            name = {
                state = true,
                text = "User: <<%s>>",
                value = paradox.client.username,
                index = 1,
                hovering = false,
                alpha = 255
            },
            build = {
                state = true,
                text = "Build: <<%s>>",
                value = paradox.client.build,
                index = 2,
                hovering = false,
                alpha = 255
            },
            update = {
                state = true,
                text = "Update: <<%s>>",
                value = paradox.client.update,
                index = 3,
                hovering = false,
                alpha = 255
            },
            fps = {
                state = true,
                text = "FPS: <<%s>>",
                value = 0,
                index = 4,
                hovering = false,
                alpha = 255
            },
            ping = {
                state = true,
                text = "Ping: <<%s>>",
                value = 0,
                index = 5,
                hovering = false,
                alpha = 255
            }
        }
    },

    logo = images.load(base64.decode("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"))
}

paradox.misc = {}


paradox.db = {
    name = "paradoxyawdata",
    fetch = function(self)
        return database.read(self.name) or {}
    end,
    
    cache = function(self)
        paradox.cache.db = self:fetch()
        --paradox.func.print(color.new(204, 135, 255), "Cached database")
    end,
    
    save_default = function(self)
        local data = self:fetch()
    
        if data == {} or data == nil then
            paradox.func.print(color.new(255, 135, 135), "No ", "<<database",  "found! Creating", "<<default", "database.")
        end
    
        local default = {
            configs = {},
            last_config = nil,
            keybinds = {["Min damage"] = true, ["Double Tap"] = true, ["Hide Shots"] = true, ["Quick peek assist"] = true, ["Force body aim"] = true, ["Force safe point"] = true, ["Fake Duck"] = true, ["Ping Spike"] = true, ["Freestanding"] = true},
            pos = {
                keybinds = { x = 300, y = 500 },
                spectators = { x = 600, y = 50 },
                defensive = { x = client.screen_size()/2 - 50, y = 200 },
            },
            warnings = {
                radius = 300
            },
            watermark = {
                options = {
                    name = true, build = true, update = true, fps = true, ping = true
                }
            },
            notifications = {
                ["Hit"] = true,
                ["Miss"] = true,
                ["Damaged"] = true,
                ["Antibrute"] = true
            }
        }
    
        local change = false
    
        for i, v in pairs(default) do
            if not data[i] then
                change = true
                data[i] = v
                paradox.func.print(color.new(204, 135, 255), "Updated", "<<database", "with", "<<default", "value for", "<<" .. i)
            end
        end
    
        if change then
            database.write(self.name, data)
            paradox.func.print(color.new(204, 135, 255), "Saved", "<<default", "database")
        end
    end,
    
    save = function(self, data)
        database.write(self.name, data)
        --paradox.func.print(color.new(204, 135, 255), "Saved database")
    end,
    
    load = LPH_NO_VIRTUALIZE(function(self)
        local data = paradox.cache.db
        
        paradox.config.list = data.configs
        paradox.config.last_config = data.last_config
        paradox.menu.config.list:update(paradox.func.keys(paradox.config.list))

        -- highlight loaded config
        if paradox.config.list[paradox.config.last_config] == nil then return end
        local list = paradox.func.keys(paradox.config.list)
        local col = color.new(paradox.menu.visuals.main_color:get())
        list[paradox.func.index(list, paradox.config.last_config)] = "\a" .. col:hex() .. "➥ " .. paradox.config.last_config
        paradox.menu.config.list:update(list)

        paradox.visuals.keybinds.pos = vector(data.pos.keybinds.x, data.pos.keybinds.y)
        paradox.visuals.warnings.radius = data.warnings.radius
        for name, v in pairs(paradox.visuals.keybinds.list) do
            v.enabled = data.keybinds[name]
        end
    
        for name, v in pairs(paradox.visuals.notify.preview.list) do
            v.enabled = data.notifications[name]
        end
    
        for option, v in pairs(paradox.visuals.watermark.options) do
            v.state = data.watermark.options[option]
        end
    
        --paradox.func.print(color.new(204, 135, 255), "Loaded database")
    end)
}

-- Config Funcs -------------------------------------------------------------------
paradox.config = {
    list = { ["Loading..."] = nil },
    last_config = nil,

    save = function(self, name)
        if name == "" or name == nil then return end
    
        local config = ui.get_config()

        local data = paradox.config.list
    
        if data[name] == nil then
            paradox.visuals.notify.new(4, color.new(204, 135, 255), string.format("Successfully <<created>> config: <<%s>>", name))
        else
            paradox.visuals.notify.new(4, color.new(204, 135, 255), string.format("Successfully <<saved>> config: <<%s>>", name))
        end
    
        data[name] = config
    end,
    
    load = LPH_NO_VIRTUALIZE(function(self, name)
        local data = paradox.config.list
    
        if data == nil then
            return
        end
    
        if data[name] == nil then
            paradox.visuals.notify.new(4, color.new(255, 135, 135), string.format("Config <<%s>> doesnt exist!", name))
            return
        end
    
        local config = data[name]
    
        ui.load_config(config)
        paradox.visuals.notify.new(4, color.new(204, 135, 255), string.format("Successfully <<loaded>> config: <<%s>>", name))
        self.last_config = name
    end),

    load_last = function(self)
        if self.last_config == nil then return end
        self:load(self.last_config)
    end,
    
    delete = function(self, name)
        local data = paradox.config.list
    
        if data == nil then
            return
        end
    
        if data[name] == nil then
            paradox.visuals.notify.new(4, color.new(255, 135, 135), string.format("Config <<%s>> doesnt exist!", name))
            return
        end
    
        data[name] = nil
        paradox.visuals.notify.new(4, color.new(204, 135, 255), string.format("Successfully <<deleted>> config: <<%s>>", name))
    end,
    
    import = function(self, settings)    
        ui.load_config(config)
        paradox.visuals.notify.new(4, color.new(204, 135, 255), string.format("Successfully <<imported>> settings"))
    end,
    
    export = function()    
        local config = ui.get_config()
    
        clipboard.set(config)
        paradox.visuals.notify.new(4, color.new(204, 135, 255), string.format("Successfully <<exported>> settings"))
    end
}

-- Listeners ---------------------------------------------------------------------
paradox.menu.gamesense_tab = {
    offset = vector(6, 20),
    scale = {["100%"] = 1, ["125%"] = 1.25, ["150%"] = 1.5, ["175%"] = 1.75, ["200%"] = 2},
    tabs = {"Rage", "AA", "Legit", "Visuals", "Misc", "Skins", "Players", "Config", "Lua"},
    active = "Rage",

    listener = function(self)
        if not paradox.cache.menu.is_menu_open then return end
        local mouse = ui.mouse_position()
        local menu = ui.menu_position()
        local menu_size = ui.menu_size()
        local size = vector(75 * self.scale[gs.misc.dpi:get()], 64.1 * self.scale[gs.misc.dpi:get()])
        for i = 1, #self.tabs do
            local v = self.tabs[i]
            local hovering = mouse.x >= menu.x + self.offset.x and mouse.x <= menu.x + self.offset.x + size.x and mouse.y >= menu.y + self.offset.y + (size.y * (i-1)) and mouse.y <= menu.y + self.offset.y + (size.y * (i))
            if hovering and paradox.menu.mouse.clicked then
                paradox.menu.gamesense_tab.active = v
            end
        end
    end
}

paradox.menu.mouse = {
    clicked = false,
    down = false,

    listener = function(self)
        if not paradox.cache.menu.is_menu_open then return end
        local mouse_down = client.key_state(0x01)
    
        self.clicked = false
    
        if mouse_down then
            if not self.down then
                self.clicked = true
            end
            self.down = true
        else
            self.down = false
        end
    end
}

paradox.stats = {
    ping = 0,
    fps = 0,
    last = 0,

    listener = function(self)
        local frametime = globals.frametime()
        local latency = client.latency()
    
        if globals.realtime() > self.last + 1 then
            self.fps = math.floor(1/frametime)
            self.ping = math.floor(latency * 1000)
            self.last = globals.realtime()
        end
    end
}

-- Menu Elements -----------------------------------------------------------------

local create_thing = function(var, identifier, condition, ab)
    ab = ab or false

    if ab then
        var.enabled = ui.new_checkbox(identifier..":e", "aa", "anti-aimbot angles", "Enabled \n" .. identifier):add_condition(function() return condition() end)
    end

    local con = function() return (ab and (condition() and var.enabled:get()) or condition()) end

    var.pitch = ui.new_combobox(identifier..":pc", "aa", "anti-aimbot angles", "\n" .. identifier .. " Pitch", {"Pitch - Down", "Pitch - Up"}):add_condition(function() return con() end)
    var.yaw = ui.new_combobox(identifier..":yc", "aa", "anti-aimbot angles", "\n" .. identifier .. " Yaw", {"Yaw - Static", "Yaw - L&R Jitter"}):add_condition(function() return con() end)
    var.yaw_offset = ui.new_slider(identifier..":yoc", "aa", "anti-aimbot angles", "\n" .. identifier .. " Yaw offset", -180, 180, 0, true, "°"):add_condition(function() return con() and var.yaw:get():find("Static") end)
    var.yaw_offset_left = ui.new_slider(identifier..":yolc", "aa", "anti-aimbot angles", "\n" .. identifier .. " Yaw offset left", -180, 180, 0, true, "°L"):add_condition(function() return con() and var.yaw:get():find("Jitter") end)
    var.yaw_offset_right = ui.new_slider(identifier..":yorc", "aa", "anti-aimbot angles", "\n" .. identifier .. " Yaw offset right", -180, 180, 0, true, "°R"):add_condition(function() return con() and var.yaw:get():find("Jitter") end)
    var.body_yaw = ui.new_combobox(identifier..":byc", "aa", "anti-aimbot angles", "\n" .. identifier .. " Body yaw", {"Body Yaw - Static", "Body Yaw - Jitter"}):add_condition(function() return con() end)
    var.body_yaw_offset = ui.new_slider(identifier..":byoc", "aa", "anti-aimbot angles", "\n" .. identifier .. " Body yaw offset", -180, 180, 0, true, "°"):add_condition(function() return con() end)
    var.choke_method = ui.new_combobox(identifier..":chm", "aa", "anti-aimbot angles", "\n" .. identifier .. " Choke method", {"Choke - Default", "Choke - Tickbase"}):add_condition(function() return con() end)

    --if not ab then
    --    ui.new_label("aa", "anti-aimbot angles", "\n spacer"):add_condition(function() return con() end)
    --    var.defensive_condition = ui.new_combobox(identifier..":dc", "aa", "anti-aimbot angles", "Defensive Yaw\n" .. identifier, {"Off", "On peek", "Always"}):add_condition(function() return con() end)
    --    var.defensive_pitch = ui.new_combobox(identifier..":dpc", "aa", "anti-aimbot angles", "\n" .. identifier .. " Defensive pitch", {"Pitch - Down", "Pitch - Up"}):add_condition(function() return con() end)
    --    var.defensive_yaw = ui.new_combobox(identifier..":dyc", "aa", "anti-aimbot angles", "\n" .. identifier .. " Defensive yaw", {"Yaw - Original", "Yaw - Spin"}):add_condition(function() return con() end)
    --    var.defensive_interval = ui.new_slider(identifier..":dic", "aa", "anti-aimbot angles", "\n" .. identifier .. " Defensive interval", 2, 20, 0, true, "t"):add_condition(function() return con() and var.defensive_condition:get() ~= "Off" end)
    --end
end

paradox.menu.aa.state = ui.new_combobox(nil, "aa", "anti-aimbot angles", "\nState", paradox.cache.aa.states):add_condition(function() return paradox.menu.tab.active == "Antiaim" or paradox.menu.tab.active == "Antibrute" end)
paradox.menu.aa.team = ui.new_combobox(nil, "aa", "anti-aimbot angles", "\nTeam", paradox.cache.aa.teams):add_condition(function() return paradox.menu.tab.active == "Antiaim" end)
paradox.menu.ab.stage = ui.new_combobox(nil, "aa", "anti-aimbot angles", "\nStage", paradox.cache.ab.stages):add_condition(function() return paradox.menu.tab.active == "Antibrute" end)

for a = 2, 3 do
    local team = paradox.util.team[a]
    for b = 1, #paradox.cache.aa.states do
        local state = paradox.cache.aa.states[b]
        local identifier = team.."_"..state
        local condition = function() return paradox.menu.tab.active == "Antiaim" and paradox.menu.aa.state:get() == state and paradox.menu.aa.team:get() == team end
        if paradox.menu.aa.builder[team] == nil then
            paradox.menu.aa.builder[team] = {}
        end
        paradox.menu.aa.builder[team][state] = {}
        create_thing(paradox.menu.aa.builder[team][state], identifier, condition)
    end
end

for a = 1, #paradox.cache.aa.states do
    local state = paradox.cache.aa.states[a]
    local identifier = "ab-"..state
    local condition = function() return paradox.menu.tab.active == "Antibrute" and paradox.menu.aa.state:get() == state end
    if paradox.menu.ab.builder[state] == nil then
        paradox.menu.ab.builder[state] = {}
    end
    for b = 1, 3 do
        local stage = b
        local identifier = "ab-"..stage.."_"..state
        local condition = function() return condition() and paradox.menu.ab.stage:get():find(stage) end
        paradox.menu.ab.builder[state][stage] = {}
        create_thing(paradox.menu.ab.builder[state][stage], identifier, condition, true)
    end
end

paradox.menu.ab.reset_conditions = ui.new_multiselect("abrc", "aa", "anti-aimbot angles", "Reset conditions", {"Timeout", "Death", "Round end"}):add_condition(function() return paradox.menu.tab.active == "Antibrute" end)
paradox.menu.ab.timeout = ui.new_slider("abt", "aa", "anti-aimbot angles", "➥ Timeout", 1, 10, 0, true, "s"):add_condition(function() return paradox.menu.tab.active == "Antibrute" and paradox.func.contains(paradox.menu.ab.reset_conditions:get(), "Timeout") end)

paradox.menu.aa.yaw_overrides = ui.new_multiselect("yo", "aa", "anti-aimbot angles", "Yaw overrides", {"Freestanding", "Manual yaw"}):add_condition(function() return paradox.menu.tab.active == "Antiaim" end)
paradox.menu.aa.freestand_disablers = ui.new_multiselect("fsd", "aa", "anti-aimbot angles", "Freestanding disablers", paradox.cache.aa.states):add_condition(function() return paradox.menu.tab.active == "Antiaim" and paradox.func.contains(paradox.menu.aa.yaw_overrides:get(), "Freestanding") end)

paradox.menu.aa.freestanding = ui.new_hotkey("aa", "anti-aimbot angles", "Freestanding"):add_condition(function() return paradox.menu.tab.active == "Antiaim" and paradox.func.contains(paradox.menu.aa.yaw_overrides:get(), "Freestanding") end)
paradox.menu.aa.manual_left = ui.new_hotkey("aa", "anti-aimbot angles", "Manual left"):add_condition(function() return paradox.menu.tab.active == "Antiaim" and paradox.func.contains(paradox.menu.aa.yaw_overrides:get(), "Manual yaw") end)
paradox.menu.aa.manual_right = ui.new_hotkey("aa", "anti-aimbot angles", "Manual right"):add_condition(function() return paradox.menu.tab.active == "Antiaim"and paradox.func.contains(paradox.menu.aa.yaw_overrides:get(), "Manual yaw") end)
paradox.menu.aa.manual_back = ui.new_hotkey("aa", "anti-aimbot angles", "Manual back"):add_condition(function() return paradox.menu.tab.active == "Antiaim"and paradox.func.contains(paradox.menu.aa.yaw_overrides:get(), "Manual yaw") end)
paradox.menu.aa.manual_forward = ui.new_hotkey("aa", "anti-aimbot angles", "Manual forward"):add_condition(function() return paradox.menu.tab.active == "Antiaim"and paradox.func.contains(paradox.menu.aa.yaw_overrides:get(), "Manual yaw") end)

ui.new_label("aa", "anti-aimbot angles", "\n spacer"):add_condition(function() return paradox.menu.tab.active == "Antiaim" or paradox.menu.tab.active == "Antibrute" end)
paradox.menu.aa.copy_state = ui.new_combobox(nil, "aa", "anti-aimbot angles", "\nCopy State", paradox.cache.aa.states):add_condition(function() return paradox.menu.tab.active == "Antiaim" or paradox.menu.tab.active == "Antibrute" end)
paradox.menu.aa.copy_team = ui.new_combobox(nil, "aa", "anti-aimbot angles", "\nCopy Team", paradox.cache.aa.teams):add_condition(function() return paradox.menu.tab.active == "Antiaim" end)
paradox.menu.aa.copy_stage = ui.new_combobox(nil, "aa", "anti-aimbot angles", "\nCopy Stage", paradox.cache.ab.stages):add_condition(function() return paradox.menu.tab.active == "Antibrute" end)
paradox.menu.aa.copy = ui.new_button("aa", "anti-aimbot angles", "Copy", function() end):add_condition(function() return paradox.menu.tab.active == "Antiaim" or paradox.menu.tab.active == "Antibrute" end)

paradox.menu.visuals.features = ui.new_multiselect(nil, "aa", "anti-aimbot angles", "Features", {"Keybinds", "\a8f2525ffSpectators", "Watermark", "\a8f2525ffDefensive", "\a8f2525ffAntibrute", "Zeus warning", "Knife warning"}):add_condition(function() return paradox.menu.tab.active == "Visuals" end)
paradox.menu.visuals.main_color = ui.new_color_picker(nil, "aa", "anti-aimbot angles", "\nMain color", 204, 135, 255, 255):add_condition(function() return paradox.menu.tab.active == "Visuals" end)
paradox.menu.visuals.indicators = ui.new_combobox(nil, "aa", "anti-aimbot angles", "Indicators", {"Off", "Default"}):add_condition(function() return paradox.menu.tab.active == "Visuals" end)
paradox.menu.visuals.indicator_color = ui.new_color_picker(nil, "aa", "anti-aimbot angles", "\nIndicator color", 204, 135, 255, 255):add_condition(function() return paradox.menu.tab.active == "Visuals" end)

ui.new_label("aa", "anti-aimbot angles", "➥ Zeus warning color"):add_condition(function() return paradox.menu.tab.active == "Visuals" and paradox.func.contains(paradox.menu.visuals.features:get(), "Zeus warning") end)
paradox.menu.visuals.zeus_warning_color = ui.new_color_picker(nil, "aa", "anti-aimbot angles", "\nZeus warning color", 255, 255, 0, 255):add_condition(function() return paradox.menu.tab.active == "Visuals" and paradox.func.contains(paradox.menu.visuals.features:get(), "Zeus warning") end)
ui.new_label("aa", "anti-aimbot angles", "➥ Knife warning color"):add_condition(function() return paradox.menu.tab.active == "Visuals" and paradox.func.contains(paradox.menu.visuals.features:get(), "Knife warning") end)
paradox.menu.visuals.knife_warning_color = ui.new_color_picker(nil, "aa", "anti-aimbot angles", "\nKnife warning color", 255, 255, 255, 255):add_condition(function() return paradox.menu.tab.active == "Visuals" and paradox.func.contains(paradox.menu.visuals.features:get(), "Knife warning") end)

paradox.menu.misc.animations_air = ui.new_combobox(nil, "aa", "anti-aimbot angles", "\acc87ffffAnimations\acbcbcbff Air", {"Off", "Static legs", "Static legs 2", "Moonwalk", "Dance"}):add_condition(function()
    return paradox.menu.tab.active == "Misc"
end)

paradox.menu.misc.animations_ground = ui.new_combobox(nil, "aa", "anti-aimbot angles", "\acc87ffffAnimations\acbcbcbff Ground", {"Off", "Static legs", "Dance"}):add_condition(function()
    return paradox.menu.tab.active == "Misc"
end)

paradox.menu.config.list = ui.new_listbox(nil, "aa", "anti-aimbot angles", "\n Config list", paradox.func.keys(paradox.config.list)):add_condition(function() return paradox.menu.tab.active == "Config" end)
paradox.menu.config.name = ui.new_textbox("aa", "anti-aimbot angles", "\n Config name", function() end):add_condition(function() return paradox.menu.tab.active == "Config" end)
paradox.menu.config.load = ui.new_button("aa", "anti-aimbot angles", "Load", function() end):add_condition(function() return paradox.menu.tab.active == "Config" end)
paradox.menu.config.save = ui.new_button("aa", "anti-aimbot angles", "Save", function() end):add_condition(function() return paradox.menu.tab.active == "Config" end)
paradox.menu.config.delete = ui.new_button("aa", "anti-aimbot angles", "Delete", function() end):add_condition(function() return paradox.menu.tab.active == "Config" end)
paradox.menu.config.import = ui.new_button("aa", "anti-aimbot angles", "Import", function() end):add_condition(function() return paradox.menu.tab.active == "Config" end)
paradox.menu.config.export = ui.new_button("aa", "anti-aimbot angles", "Export", function() end):add_condition(function() return paradox.menu.tab.active == "Config" end)

ui.new_label("aa", "anti-aimbot angles", "Welcome back, \a" .. color.new(paradox.menu.visuals.main_color:get()):hex() .. paradox.client.username):add_condition(function()
    return paradox.menu.tab.active == "Info"
end)

paradox.menu.info.build = ui.new_label("aa", "anti-aimbot angles", "Build: \a" .. color.new(paradox.menu.visuals.main_color:get()):hex() .. paradox.client.build):add_condition(function()
    return paradox.menu.tab.active == "Info"
end)

paradox.menu.info.discord = ui.new_button("aa", "anti-aimbot angles", "Join our Discord", function()
end):add_condition(function() 
    return paradox.menu.tab.active == "Info"
end)

paradox.menu.info.discord:set_callback(function()
    clipboard.set("https://discord.gg/paradoxpub")
    paradox.visuals.notify.new(2, color.new(204, 135, 255), "Discord link copied to clipboard")
end)

ui.handle_visibility()

-- Antibrute ----------------------------------------------------------------------
paradox.ab = {
    state = (function()
        local states = {}
        for i = 1, #paradox.cache.aa.states do
            states[paradox.cache.aa.states[i]] = {
                active = false,
                stage = 1,
                last = 0
            }
        end
        return states
    end)(),

    last_shot = 0,

    on_bullet_impact = function(self, e)
        local local_player = entity.get_local_player()
        if local_player == nil then return end
        if not entity.is_alive(local_player) then return end
    
        local shooter = client.userid_to_entindex(e.userid)
        if shooter == nil then return end

        if shooter == local_player then return end
        if not entity.is_enemy(shooter) then return end
     
        local team_name = paradox.util.team[entity.get_prop(local_player, "m_iTeamNum")]
        if team_name == nil then return end
    
        local ab = paradox.ab.state[paradox.aa.state]
        local ab_state = self.state[paradox.aa.state][ab.stage]
    
        local shooter_origin = vector(entity.get_origin(shooter)) + vector(0, 0, entity.get_prop(shooter, "m_vecViewOffset[2]"))
        local head = vector(entity.hitbox_position(local_player, 0))
        local impact = vector(e.x, e.y, e.z)
        local closest = paradox.math.closest_point(shooter_origin, impact, head)
        local closest_delta = closest - head
        local dist = closest_delta:length()
    
        if dist > 45 then return end

        if self.last_shot + 0.1 > globals.curtime() then return end
    
        if not paradox.menu.ab.builder[paradox.aa.state][1].enabled:get() then return end
    
        self.last_shot = globals.curtime()
        
        if not ab.active then
            ab.active = true
            ab.stage = 1
            ab.last = globals.curtime()
            if paradox.visuals.notify.preview.list["Antibrute"].enabled then
                paradox.visuals.notify.new(2, color.new(204, 135, 255), string.format("Antibrute <<activated>> by <<%s>> for stage <<%s>> of <<%s>>", entity.get_player_name(shooter), ab.stage, paradox.aa.state))
            end
            return
        end
    
        local next_stage = ab.stage + 1

        local max = 1
        for i = 1, 3 do
            local next_state = paradox.menu.ab.builder[paradox.aa.state][i]
            if next_state.enabled:get() then
                max = i
            end
        end
        
        if next_stage > max then
            ab.active = false
            ab.stage = 1
            if paradox.visuals.notify.preview.list["Antibrute"].enabled then
                paradox.visuals.notify.new(2, color.new(204, 135, 255), string.format("Antibrute <<reset>> due to <<%s misses>> for <<%s>>", max, paradox.aa.state))
            end
            return
        end
    
        local next_state = paradox.ab.state[paradox.aa.state][next_stage]
    
        ab.stage = next_stage
        ab.last = globals.curtime()
    
        if paradox.visuals.notify.preview.list["Antibrute"].enabled then  
            paradox.visuals.notify.new(2, color.new(204, 135, 255), string.format("Antibrute <<triggered>> by <<%s>> for stage <<%s>> of <<%s>>", entity.get_player_name(shooter), ab.stage, paradox.aa.state))
        end
    end,

    timeout = function(self)
        if not paradox.func.contains(paradox.cache.menu.ab_reset_conditions, "Timeout") then return end
        local local_player = entity.get_local_player()
        if local_player == nil then return end
        local team_name = paradox.util.team[entity.get_prop(local_player, "m_iTeamNum")]
        if team_name == nil then return end
    
        local ab = paradox.ab.state[paradox.aa.state]
        local ab_state = paradox.menu.ab.builder[paradox.aa.state][ab.stage]
        if ab_state == nil then return end
    
        local timeout = paradox.menu.ab.timeout:get()
    
        if ab.active then
            if ab.last + timeout < globals.curtime() then
                ab.active = false
                ab.stage = 1
                if paradox.visuals.notify.preview.list["Antibrute"].enabled then
                    paradox.visuals.notify.new(2, color.new(204, 135, 255), string.format("Antibrute <<reset>> for <<%s>> due to <<timeout>>", paradox.aa.state))
                end
            end
        end
    end,
    
    reset_all = function(self, e)
        local reset = false
        for state, ab in pairs(paradox.ab.state) do
            if ab.active then
                ab.active = false
                ab.stage = 1
                reset = true
            end
        end
    
        return reset
    end,
    
    on_death = function(self, e)
        if not paradox.func.contains(paradox.cache.menu.ab_reset_conditions, "Death") then return end
        local victim = client.userid_to_entindex(e.userid)
    
        local local_player = entity.get_local_player()
        if local_player == nil then return end
    
        if victim ~= local_player then return end
    
        if self:reset_all() then
            paradox.visuals.notify.new(2, color.new(204, 135, 255), "Antibrute <<reset>> for <<all>> due to <<death>>")
        end
    end,
    
    on_round_end = function(self)
        if not paradox.func.contains(paradox.cache.menu.ab_reset_conditions, "Round end") then return end
    
        if self:reset_all() then
            if paradox.visuals.notify.preview.list["Antibrute"].enabled then
                paradox.visuals.notify.new(2, color.new(204, 135, 255), "Antibrute <<reset>> due to <<round end>>")
            end
        end
    end
}

-- Antiaim ----------------------------------------------------------------------
paradox.aa = {
    state = "Standing",
    ground_ticks = 0,
    in_use = false,

    update_state = LPH_NO_VIRTUALIZE(function(self, cmd)
        local local_player = entity.get_local_player()
        if local_player == nil then return end
        if not entity.is_alive(local_player) then return end
    
        local flags = entity.get_prop(local_player, "m_fFlags")
        local speed = math.floor(vector(entity.get_prop(local_player, "m_vecVelocity")):length2d())
    
        local on_ground = bit.band(flags, 1) == 0
    
        self.ground_ticks = on_ground and 0 or (self.ground_ticks < 5 and self.ground_ticks + 1 or self.ground_ticks)
    
        local air = self.ground_ticks < 5
        local air_crouching = air and cmd.in_duck == 1
        local standing = speed <= 1
        local crouching = cmd.in_duck == 1 and standing
        local move_crouching = speed >= 2 and cmd.in_duck == 1
        local moving = speed >= 2
        local slowwalking = gs.misc.slow_motion:get() and gs.misc.slow_motion_key:get() and not standing
        local fakelagging = not gs.rage.double_tap_key:get() and not gs.misc.hide_shots_key:get()
        local fakeducking = gs.misc.fakeducking:get()
    
        if standing then
            state = "Standing"
        end
        if crouching then
            state = "Duck"
        end
        if moving then
            state = "Moving"
        end
        if move_crouching then
            state = "Duck Move"
        end
        if slowwalking then
            state = "Slow Walk"
        end
        if air then
            state = "Air"
        end
        if air_crouching then
            state = "Air Duck"
        end
        if fakelagging then
            state = "Fakelag"
        end
        if fakeducking then
            state = "Fakeduck"
        end
    
        self.state = state
    end),

    on_setup_command = function(self, cmd)
        local local_player = entity.get_local_player()
        if local_player == nil then return end
    
        local freestanding = paradox.menu.aa.freestanding:get() and not self.in_use and not (paradox.func.contains(paradox.menu.aa.freestand_disablers:get(), self.state))
    
        gs.aa.freestanding_key:set("Always on")
        gs.aa.freestanding:set(freestanding)
    
        if self.in_use then
            gs.aa.pitch:set("Off")
            gs.aa.yaw:set("Off")
            gs.aa.yaw_base:set("Local view")
            gs.aa.body_yaw:set("Static")
            gs.aa.yaw_jitter:set("Off")
            gs.aa.yaw_jitter_offset:set(0)
            gs.aa.yaw_offset:set(0)
            gs.aa.body_yaw_offset:set(180)
            gs.aa.freestanding_body_yaw:set(true)
            return
        end
    
        if freestanding then
            gs.aa.pitch:set("Minimal")
            gs.aa.yaw:set("180")
            gs.aa.yaw_base:set("At targets")
            gs.aa.body_yaw:set("Static")
            gs.aa.yaw_jitter:set("Off")
            gs.aa.yaw_jitter_offset:set(0)
            gs.aa.yaw_offset:set(0)
            gs.aa.body_yaw_offset:set(180)
            gs.aa.freestanding_body_yaw:set(false)
            return
        end
    
        gs.aa.pitch:set("Off")
        gs.aa.yaw:set("Off")
        gs.aa.yaw_base:set("Local view")
        gs.aa.body_yaw:set("Static")
        gs.aa.yaw_jitter:set("Off")
        gs.aa.yaw_jitter_offset:set(0)
        gs.aa.yaw_offset:set(0)
        gs.aa.body_yaw_offset:set(180)
        gs.aa.freestanding_body_yaw:set(true)
    
        self.desync:on_setup_command(cmd)
    end
}

paradox.aa.defensive = {
    active = false,
    last = 0,

    on_setup_command = function(self, cmd)
        local local_player = entity.get_local_player()
        if local_player == nil then return end
        if not entity.is_alive(local_player) then return end

        local tickbase = entity.get_prop(local_player, "m_nTickBase")

        local team_name = paradox.util.team[entity.get_prop(local_player, "m_iTeamNum")]

        local state = paradox.menu.aa.builder[team_name][paradox.aa.state]
        --if state.defensive_condition:get() == "Off" then self.active = false return end
        --local interval = state.defensive_interval:get()

        -- activate defensive based on interval

       -- self.active = false

        --if self.last + interval <= tickbase then
        --    self.active = true
        --    self.last = tickbase
        --end



    end
}

paradox.aa.anti_backstab = {
    active = false,
    angle = 0,

    on_setup_command = function(self, cmd)
        --if not paradox.menu.misc.anti_backstab:get() then return end
        local local_player = entity.get_local_player()
        if local_player == nil then return end
        if not entity.is_alive(local_player) then return end
    
        self.active = false
        self.angle = 0
    
        local local_pos = vector(entity.get_origin(local_player))
    
        local threat = paradox.func.closest_player(true, 250)
    
        local threat_weapon_ent = entity.get_player_weapon(threat)
        if threat_weapon_ent == nil then return end
    
        local threat_weapon = csgo_weapons(threat_weapon_ent)
        if threat_weapon == nil then return end
    
        if threat_weapon.type ~= "knife" then return end
    
        if threat == nil then return end
        local threat_pos = vector(entity.get_origin(threat))
        local _, angle = local_pos:to(threat_pos):angles()
    
        self.angle = angle
        self.active = true
    end
}

paradox.aa.manual = {
    state = "back",
    left = false,
    right = false,
    back = false,
    forward = false,

    on_setup_command = LPH_NO_VIRTUALIZE(function(self)
        if not paradox.func.contains(paradox.cache.menu.yaw_overrides, "Manual yaw") then return end
        local states = {["left"] = paradox.menu.aa.manual_left:get(), ["right"] = paradox.menu.aa.manual_right:get(), ["back"] = paradox.menu.aa.manual_back:get(), ["forward"] = paradox.menu.aa.manual_forward:get()}
    
        for state, active in pairs(states) do
            if active then
                if self[state] then
                    self.state = state == self.state and "back" or state
                    self[state] = false
                end
            else
                self[state] = true
            end
        end
    end)
}

paradox.aa.desync = {
    choke = {
        last_tick = 0,
    },
    jitter = false,
    base_yaw = 0,
    on_ladder = false,

    cancel = LPH_NO_VIRTUALIZE(function(self, cmd)
        local local_player = entity.get_local_player()
        if local_player == nil then return end
        local weapon_ent = entity.get_player_weapon(local_player)
        if weapon_ent == nil then return false end
        local weapon = csgo_weapons(weapon_ent)
        if weapon == nil then return false end
    
        local ready = globals.curtime() >= entity.get_prop(local_player, "m_flNextAttack")
        local weapon_ready = globals.curtime() >= entity.get_prop(weapon_ent, "m_flNextPrimaryAttack")
        local is_grenade = weapon.type == "grenade"
        local pin_pulled = entity.get_prop(weapon_ent, "m_bPinPulled")
        local throw_time = entity.get_prop(weapon_ent, "m_fThrowTime")
        local throwing = cmd.in_attack == 1 or cmd.in_attack2 == 1
        local frozen = entity.get_prop(local_player, "m_bGunGameImmunity") == 1
        local stab = weapon.type == "knife" and cmd.in_attack2 == 1 and ready and weapon_ready 
        local throwing_nade = is_grenade and (throwing or pin_pulled) and throw_time > 0 and throw_time < globals.curtime()
    
        return (cmd.in_attack == 1 and ready and weapon_ready and not is_grenade) or frozen or stab or self.on_ladder or cmd.in_use == 1 or throwing_nade
    end),

    on_setup_command = function(self, cmd)
        local bFreezePeriod = entity.get_prop(entity.get_game_rules(), "m_bFreezePeriod")
        if (bFreezePeriod == 1) then return end

        if self:cancel(cmd) then return end
        local local_player = entity.get_local_player()
        if local_player == nil then return end
        if not entity.is_alive(local_player) then return end

        local team_name = paradox.util.team[entity.get_prop(local_player, "m_iTeamNum")]
    
        local local_origin = vector(entity.get_origin(local_player))
        local tickbase = entity.get_prop(local_player, "m_nTickBase")
    
        local ab = paradox.ab.state[paradox.aa.state]
        local ab_state = paradox.menu.ab.builder[paradox.aa.state][ab.stage]
        local aa_state = paradox.menu.aa.builder[team_name][paradox.aa.state]
        local state = ab.active and ab_state or aa_state
        
        local gui_team, gui_state, gui_stage = paradox.cache.menu.team, paradox.cache.menu.state, tonumber(paradox.cache.menu.stage)
    
        if paradox.cache.menu.is_menu_open and paradox.menu.gamesense_tab.active == "AA" then
            if  paradox.menu.tab.active == "Antiaim" then
                state = paradox.menu.aa.builder[gui_team][gui_state]
            elseif paradox.menu.tab.active == "Antibrute" then
                state = paradox.menu.ab.builder[gui_state][gui_stage]
            end
        end
    
        local pitch = state.pitch:get():sub(9)
        local yaw = state.yaw:get()
        local yaw_offset = state.yaw_offset:get()
        local yaw_offset_left = state.yaw_offset_left:get()
        local yaw_offset_right = state.yaw_offset_right:get()
        local body_yaw = state.body_yaw:get()
        local body_yaw_offset = state.body_yaw_offset:get()
        local choke_method = state.choke_method:get()
        local manual = paradox.aa.manual.state ~= "back"

        --local defensive_condition = aa_state.defensive_condition:get()
        --local defensive_pitch = aa_state.defensive_pitch:get():sub(9)
        --local defensive_yaw = aa_state.defensive_yaw:get():sub(6)
        --local defensive_interval = aa_state.defensive_interval:get()
    
        local local_pitch, local_yaw = client.camera_angles()
    
        local base_yaw = local_yaw + 180
        local final_yaw, final_pitch = local_yaw, local_pitch
        local threat = client.current_threat()
    
        local pitches = {["Down"] = 89, ["Up"] = -89}
    
        final_pitch = pitches[pitch] or local_pitch
    
        if threat ~= nil then
            local threat_origin = vector(entity.get_origin(threat))
            base_yaw = vector(local_origin:to(threat_origin):angles()).y + 180
        end
    
        if choke_method:find("Tickbase") then
            if cmd.chokedcommands == 0 then
                if tickbase > self.choke.last_tick + 2 then
                    self.jitter = not self.jitter
                    self.choke.last_tick = tickbase
                end
            end
        else
            if cmd.chokedcommands == 0 then
                self.jitter = not self.jitter
            end
        end
    
        local no_jitter = false
    
        local inverted = (math.min(60, entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60)) > 0
        local manual_offset = {["left"] = -90, ["right"] = 90, ["forward"] = 180}
        local offset = (yaw:find("Jitter")) and (inverted and yaw_offset_left or yaw_offset_right) or yaw_offset
        local fake_offset = 120
    
        if body_yaw:find("Jitter") then
            fake_offset = (self.jitter and 60 or -60)
        else
            fake_offset = (body_yaw_offset > 0 and 120 or -120)
        end
    
        if manual then
            offset = manual_offset[paradox.aa.manual.state]
            fake_offset = -120
            base_yaw = local_yaw + 180
        end
    
        if paradox.aa.anti_backstab.active then
            offset = 0
            fake_offset = -120
            base_yaw = paradox.aa.anti_backstab.angle
            final_pitch = 0
        end
    
        --if paradox.aa.defensive.active then
        --    cmd.force_defensive = true
        --    final_pitch = pitches[defensive_pitch]
        --    offset = defensive_yaw == "Original" and offset or (tickbase * 10) % 360
        --else
        --    cmd.force_defensive = false
        --end
    
        if cmd.chokedcommands == 0 then
            cmd.allow_send_packet = false
            final_yaw = base_yaw + fake_offset + offset
        else
            final_yaw = base_yaw + offset
        end
    
        cmd.yaw = final_yaw
        cmd.pitch = final_pitch
    end,

    on_run_command = function(self, cmd)
        local local_player = entity.get_local_player()
        if local_player == nil then return end
        if not entity.is_alive(local_player) then return end
        self.on_ladder = entity.get_prop(local_player, "m_MoveType") == 9 and (paradox.cache.cmd.forwardmove ~= 0 or paradox.cache.cmd.sidemove ~= 0)
    end
}

-- Visuals -----------------------------------------------------------------------
paradox.visuals.indicator_fix.render = function(self)
    local h = select(2, client.screen_size())
    
    local starting = h - 350

    for index, indicator in ipairs(self.indicators) do index = index - 1 -- this is how you fix lua tables lol
        local width, height = renderer.measure_text('d+', indicator.text)
        local offset = index * (height + 12)

        local gradient_width = math.floor(width)                                                                                                                             
        
        local y = starting - offset

        renderer.gradient(0                 , y, gradient_width, height + 4, 0, 0, 0, 0, 0, 0, 0, 50, true)
        renderer.gradient(gradient_width , y, gradient_width, height + 4, 0, 0, 0, 50, 0, 0, 0, 0, true)
        renderer.text(14, y + 2, indicator.r, indicator.g, indicator.b, indicator.a, 'd+', 0, indicator.text)
    end

    self.indicators = {}
end

paradox.visuals.forced_watermark.render = LPH_NO_VIRTUALIZE(function(self)
    if paradox.func.contains(paradox.cache.menu.visual_features, "Watermark") then return end
    local x, y = self.pos.x, self.pos.y
    local col = color.new(paradox.menu.visuals.main_color:get())
    local float = math.sin(globals.realtime() * 2) * 15
    local text = paradox.func.gradient_text(self.text, color.new(col.r, col.g, col.b, 255), 5)
    renderer.text(x, y + float, 255, 255, 255, 255, "c", 0, text)
end)

-- watermark
paradox.visuals.watermark.render = LPH_NO_VIRTUALIZE(function(self)
    if not paradox.func.contains(paradox.cache.menu.visual_features, "Watermark") then return end

    local screen = paradox.cache.ui.screen_size
    local offset = 10
    local inner_offset = 8

    local options = {}
    local items = {}
    local values = {}

    self.options.fps.value = paradox.stats.fps
    self.options.ping.value = paradox.stats.ping

    for key, value in pairs(self.options) do
      table.insert(options, value)
    end
    
    -- Sort the table by the "index" field:
    table.sort(options, function(a, b) return a.index < b.index end)

    local col = color.new(paradox.menu.visuals.main_color:get())

    for option, v in pairs(options) do
        if v.state or paradox.cache.menu.is_menu_open then
            if option == 5 and entity.get_local_player() == nil and not paradox.cache.menu.is_menu_open then goto continue end
            local text = v.text
            v.alpha = paradox.math.lerp(v.alpha, (v.hovering and (v.state and 150 or 100) or (v.state and 255 or 50)), globals.frametime()*30)
            local hex_col = color.new(col.r, col.g, col.b, v.alpha):hex()
            text = text:gsub("%<<", "\a" .. hex_col)
            text = text:gsub("%>>", "\a" .. color.new(255, 255, 255, 255):hex())

            table.insert(items, text)
            table.insert(values, v.value)
        end
        ::continue::
    end

    local text = string.format(table.concat(items, "\a6e6e6eff | \affffffff"), unpack(values))

    local mouse = ui.mouse_position()

    local x, y = self.pos.x, self.pos.y
    local w, h = self.size.x, self.size.y

    local total_width = 0

    for option, v in pairs(options) do
        local text = v.text
        text = text:gsub("%<<", ""):gsub("%>>", "")
        text = string.format(text, v.value)
        local size = vector(renderer.measure_text("c", text), 30)
        local x, y = self.pos.x + total_width + offset, self.pos.y
        v.hovering = mouse.x > x and mouse.x < x + size.x and mouse.y > y and mouse.y < y + size.y
        total_width = total_width + size.x + renderer.measure_text("c", " | ")
    end
      


    for option, v in pairs(self.options) do
        if v.hovering and paradox.menu.mouse.clicked then
            v.state = not v.state
        end
    end

    local empty = #items == 0

    local tsize = vector(renderer.measure_text("c", 0, text))
    self.size.x = ease.linear(globals.frametime()*20, self.size.x, (tsize.x + inner_offset*2) - self.size.x, 1)

    self.pos.x = ease.linear(globals.frametime()*20, self.pos.x, (screen.x - self.size.x - offset) - self.pos.x, 1)
    self.pos.y = offset
    local x, y = self.pos.x, self.pos.y
    local icon_size = 30
    local h = 30

    if self.size.x > 23 then
        renderer.rectangle(x, y, self.size.x, h, 0, 0, 0, 255)
        renderer.rectangle(x + 1, y + 1, self.size.x - 2, h-2, 57, 57, 57, 255)
        renderer.rectangle(x + 2, y + 2, self.size.x - 4, h-4, 40, 40, 40, 255)
        renderer.rectangle(x + 3, y + 3, self.size.x - 6, h-6, 57, 57, 57, 255)
        renderer.rectangle(x + 4, y + 4, self.size.x - 8, h-8, 22, 22, 22, 255)
    end
 

    -- change the icon pos based on #items ~= 0
    local icon_pos = empty and x - (offset/2) or x - icon_size - (offset/2)

    renderer.rectangle(icon_pos, y, icon_size, icon_size, 0, 0, 0, 255)
    renderer.rectangle(icon_pos + 1, y + 1, icon_size - 2, icon_size-2, 57, 57, 57, 255)
    renderer.rectangle(icon_pos + 2, y + 2, icon_size - 4, icon_size-4, 40, 40, 40, 255)
    renderer.rectangle(icon_pos + 3, y + 3, icon_size - 6, icon_size-6, 57, 57, 57, 255)
    renderer.rectangle(icon_pos + 4, y + 4, icon_size - 8, icon_size-8, 22, 22, 22, 255)

    paradox.visuals.logo:draw(icon_pos - 1, y + h/2 - (icon_size/2), icon_size, nil, col.r, col.g, col.b, 255, true)
    renderer.text(x + tsize.x/2 + inner_offset, y + h/2 , 255, 255, 255, 255, "c", 0, text)
end)

-- Indicators
paradox.visuals.indicators.render = LPH_NO_VIRTUALIZE(function(self)
    if paradox.menu.visuals.indicators:get() == "Off" then return end
    local local_player = entity.get_local_player()
    if local_player == nil then return end
    if not entity.is_alive(local_player) then return end

    local screen = paradox.cache.ui.screen_size

    local col = color.new(paradox.menu.visuals.main_color:get())
    local col2 = color.new(paradox.menu.visuals.indicator_color:get())
    local pulse = math.abs(math.sin(globals.curtime() * 12) * 255)
    local scoped = entity.get_prop(local_player, "m_bIsScoped") == 1


    if paradox.menu.visuals.indicators:get() == "Default" then
        self.title.text = paradox.func.gradient_text("PARADOX.PUB", col, 10)
        self.dmg.text = gs.rage.mdo_value:get()

        local binds = string.format("\a%sBAIM   \a%sFS   \a%sSAFE", self.binds.baim.color:hex(), self.binds.fs.color:hex(), self.binds.safe.color:hex())
        local exploit = string.format("\a%sDT", self.binds.dt.color:hex())
    
        local hss = renderer.measure_text("c-", "HIDE") + 10
        local dts = renderer.measure_text("c-", "DT") + 10
        local bindss = renderer.measure_text("c-", binds) + 10
        local exploits = renderer.measure_text("c-", exploit) + 10
        local titles = renderer.measure_text("c-", self.title.text) + 10
        local states = renderer.measure_text("c-", paradox.aa.state:upper()) + 10
        if self.title.pos ~= vector(screen.x/2, screen.y/2 + 15) then
            self.title.pos = ease.linear(globals.frametime()*12, self.title.pos, vector(screen.x/2 + (scoped and titles/2 or 0), screen.y/2 + 25) - self.title.pos, 1)
        end
    
        self.dmg.pos = vector(screen.x/2 + 10, screen.y/2 - 10)
        self.state.pos = ease.linear(globals.frametime()*12, self.state.pos, vector(screen.x/2 + (scoped and states/2 or 0), screen.y/2 + 25) - self.state.pos, 1)
        self.binds.dt.pos = ease.linear(globals.frametime()*12, self.binds.dt.pos, vector(screen.x/2 - (self.binds.hs.key() and not scoped and renderer.measure_text("c-", "HIDE")/2 or 0) + (scoped and exploits/2 or 0), screen.y/2 + 25 + 24) - self.binds.dt.pos, 1)
        self.binds.hs.pos = ease.linear(globals.frametime()*12, self.binds.hs.pos, vector(screen.x/2 + (self.binds.hs.key() and not scoped and renderer.measure_text("c-", "HIDE")/2 or 0) + (scoped and hss/2 or 0), screen.y/2 + 25 + 24 + (scoped and 8 or 0)) - self.binds.hs.pos, 1)
        self.binds.baim.pos = ease.linear(globals.frametime()*12, self.binds.baim.pos, vector(screen.x/2 + (scoped and bindss/2 or 0), screen.y/2 + 25) - self.binds.baim.pos, 1)

        self.dmg.alpha = paradox.math.lerp(self.dmg.alpha, ((self.dmg.key() and self.dmg.enabled) or paradox.cache.menu.is_menu_open) and 255 or 0, globals.frametime()*30)

        self.binds.baim.color = self.binds.baim.color:lerp(self.binds.baim.key() and col2 or color.new(255, 255, 255, 100), globals.frametime()*20)
        self.binds.fs.color = self.binds.fs.color:lerp(self.binds.fs.key() and col2 or color.new(255, 255, 255, 100), globals.frametime()*20)
        self.binds.safe.color = self.binds.safe.color:lerp(self.binds.safe.key() and col2 or color.new(255, 255, 255, 100), globals.frametime()*20)
        self.binds.hs.color = self.binds.hs.color:lerp((self.binds.hs.key()) and ((paradox.util.dt_charged) and color.new(255, 255, 255, 100) or col2) or color.new(255, 255, 255, 0), globals.frametime()*20)
        self.binds.dt.color = self.binds.dt.color:lerp((self.binds.dt.key() and (paradox.util.dt_charged and col2 or color.new(255, 80, 80, pulse)) or color.new(255, 255, 255, 100)), globals.frametime()*20)


        renderer.text(self.dmg.pos.x, self.dmg.pos.y, 255, 255, 255, self.dmg.alpha, "c", 0, self.dmg.text)
        renderer.text(self.title.pos.x, self.title.pos.y, 0, 0, 0, 50, "c-", 0, "PARADOX.PUB")
        renderer.text(self.title.pos.x, self.title.pos.y, 255, 255, 255, 255, "c-", 0, self.title.text)
        renderer.text(self.binds.baim.pos.x, self.binds.baim.pos.y + 8, 255, 255, 255, 255, "c-", 0, binds)

        renderer.text(self.state.pos.x, self.state.pos.y + 16, 255, 255, 255, 255, "c-", 0, paradox.aa.state:upper())
        renderer.text(self.binds.dt.pos.x, self.binds.dt.pos.y, 255, 255, 255, 255, "c-", 0, exploit)
        renderer.text(self.binds.hs.pos.x, self.binds.hs.pos.y, self.binds.hs.color.r, self.binds.hs.color.g, self.binds.hs.color.b, self.binds.hs.color.a, "c-", 0, self.binds.hs.text)

        if paradox.aa.manual.state == "left" then
            renderer.text(screen.x/2 - 50, screen.y/2 - 3, col.r, col.g, col.b, col.a, "c+", 0, "⯇")
        elseif paradox.aa.manual.state == "right" then
            renderer.text(screen.x/2 + 50, screen.y/2 - 3, col.r, col.g, col.b, col.a, "c+", 0, "⯈")
        elseif paradox.aa.manual.state == "forward" then
            renderer.text(screen.x/2, screen.y/2 - 50, col.r, col.g, col.b, col.a, "c+", 0, "⯅")
        end

    end
end)

-- Warnings ---------------------------------------------------------------------
paradox.visuals.warnings.zeus.render = function(self)
    if not paradox.func.contains(paradox.cache.menu.visual_features, "Zeus warning") or paradox.cache.menu.is_menu_open then return end
    local local_player = entity.get_local_player()
    if local_player == nil then return end
    if not entity.is_alive(local_player) then return end

    local screen = paradox.cache.ui.screen_size
    local x, y = screen.x/2, screen.y/2

    local threats = paradox.func.players_in_range(true, 1000)
    if threats == nil then return end
    if #threats == 0 then return end

    local view = vector(client.camera_angles())
    local local_pos = vector(entity.get_origin(local_player))

    local img = images.get_weapon_icon("weapon_taser")
    local img_size = vector(img:measure())

    local knife_angle = paradox.aa.anti_backstab.angle

    for _, threat in pairs(threats) do
        local threat_weapon_ent = entity.get_player_weapon(threat)
        if threat_weapon_ent == nil then goto continue end
    
        local threat_weapon = csgo_weapons(threat_weapon_ent)
        if threat_weapon == nil then goto continue end
    
        if threat_weapon.type ~= "taser" then goto continue end

        local threat_pos = vector(entity.get_origin(threat))
        local threat_pos2d = vector(renderer.world_to_screen(threat_pos:unpack()))
        local angle = vector(local_pos:to(threat_pos):angles())

        local delta = view.y - angle.y - 90

        local angle_rad = math.rad(delta)

        local diff = math.abs(knife_angle - angle.y)

        local radius = paradox.visuals.warnings.radius

        local x2 = paradox.func.clamp(x + math.cos(angle_rad)*radius, img_size.x, screen.x - img_size.x)
        local y2 = paradox.func.clamp(y + math.sin(angle_rad)*radius*0.59375, img_size.y, screen.y - img_size.y)

        local pulsating = math.abs(math.sin(globals.curtime() * 5) * 255)
        local within_distance = local_pos:dist(threat_pos) < 300
        
        local color = within_distance and color.new(255, 0, 0) or color.new(paradox.menu.visuals.zeus_warning_color:get())

        local on_screen = threat_pos2d.x > 0 and threat_pos2d.x < screen.x and threat_pos2d.y > 0 and threat_pos2d.y < screen.y

        local size = on_screen and (math.abs(math.sin(globals.curtime() * 5) * 10) + 30) or 30


        img:draw(x2 - 10, y2 - 10, size, nil, color.r, color.g, color.b, pulsating, true)

        ::continue::
    end
end

paradox.visuals.warnings.knife.render = function(self)
    if not paradox.func.contains(paradox.cache.menu.visual_features, "Knife warning") or paradox.cache.menu.is_menu_open then return end
    local local_player = entity.get_local_player()
    if local_player == nil then return end
    if not entity.is_alive(local_player) then return end

    local local_pos = vector(entity.get_origin(local_player))

    local screen = paradox.cache.ui.screen_size
    local x, y = screen.x/2, screen.y/2

    local closest = paradox.func.closest_player(true, 250)

    local threat_weapon_ent = entity.get_player_weapon(closest)
    if threat_weapon_ent == nil then return end

    local threat_weapon = csgo_weapons(threat_weapon_ent)
    if threat_weapon == nil then return end

    if threat_weapon.type ~= "knife" then return end

    local closest_pos = vector(entity.get_origin(closest))
    local closest_angle = select(2, local_pos:to(closest_pos):angles())
    local closest_pos2d = vector(renderer.world_to_screen(closest_pos:unpack()))

    local view = vector(client.camera_angles())
    local delta = view.y - closest_angle - 90

    local knife_img = images.get_weapon_icon("knife_karambit")

    local angle_rad = math.rad(delta)
    local radius = paradox.visuals.warnings.radius

    local img_size = vector(knife_img:measure())

    local x2 = paradox.func.clamp(x + math.cos(angle_rad)*radius, img_size.x, screen.x - img_size.x)
    local y2 = paradox.func.clamp(y + math.sin(angle_rad)*radius*0.59375, img_size.y, screen.y - img_size.y) 
    
    local on_screen = closest_pos2d.x > 0 and closest_pos2d.x < screen.x and closest_pos2d.y > 0 and closest_pos2d.y < screen.y

    local size = on_screen and (math.abs(math.sin(globals.curtime() * 5) * 10) + 40) or 40

    local pulsating = math.abs(math.sin(globals.curtime() * 5) * 255)
    local color = color.new(paradox.menu.visuals.knife_warning_color:get())

    knife_img:draw(x2 - 10, y2 - 10, size, nil, color.r, color.g, color.b, pulsating, true)
end

paradox.visuals.warnings.preview = function(self)
    if not paradox.cache.menu.is_menu_open then return end
    if not (paradox.menu.tab.active == "Visuals" and paradox.menu.gamesense_tab.active == "AA")  then return end
    if not paradox.func.contains(paradox.cache.menu.visual_features, "Knife warning") and not paradox.func.contains(paradox.cache.menu.visual_features, "Zeus warning") then return end
    local screen = paradox.cache.ui.screen_size
    local x, y = screen.x/2, screen.y/2
    local mouse = ui.mouse_position()

    for name, warning in pairs(self) do
        if type(warning) ~= "table" then goto continue end
        if name ~= "knife" and name ~= "zeus" then goto continue end
        if not paradox.func.contains(paradox.cache.menu.visual_features, name == "zeus" and "Zeus warning" or "Knife warning") then goto continue end

        local angle = paradox.math.lerp(0, 360, globals.realtime()/4 % 1)

        if name == "knife" then
            angle = angle - 180
        end

        local angle_rad = math.rad(angle)

        local img = images.get_weapon_icon(warning.icon)
        local img_size = vector(img:measure())

        local radius = self.radius

        local x2 = paradox.func.clamp(x + math.cos(angle_rad)*radius, img_size.x, screen.x - img_size.x)
        local y2 = paradox.func.clamp(y + math.sin(angle_rad)*radius*0.59375, img_size.y, screen.y - img_size.y)

        local pulsating = math.abs(math.sin(globals.curtime() * 5) * 255)

        local col = color.new(paradox.menu.visuals[name.."_warning_color"]:get())

        local size = name == "knife" and 40 or 30

        img:draw(x2 - 10, y2 - 10, size, nil, col.r, col.g, col.b, pulsating, true)
        ::continue::
    end

    local segments = 100
    local step = 360/segments
    local last_x, last_y = nil, nil
    for i = 0, segments do
        local angle = paradox.math.lerp(0, 360, i/segments)
        local angle_rad = math.rad(angle)

        local x2 = x + math.cos(angle_rad)*self.radius
        local y2 = y + math.sin(angle_rad)*self.radius*0.59375

        local alpha = 50

        if self.hovering then
            alpha = 100
        end

        if self.dragging then
            alpha = 150
        end

        if last_x ~= nil then
            renderer.line(last_x, last_y, x2, y2, 255, 255, 255, alpha)
        end

        last_x, last_y = x2, y2
    end

    if not paradox.func.hovering_menu() and not (paradox.visuals.keybinds.dragging or paradox.visuals.keybinds.hovering or paradox.visuals.keybinds.hovering_binds or paradox.visuals.notify.preview.hovering) then
        if not self.dragging then
            -- check if the mouse is within 10 pixels of the line of the segment
            for i = 0, segments do
                local angle = paradox.math.lerp(0, 360, i/segments)
                local angle_rad = math.rad(angle)

                local x2 = x + math.cos(angle_rad)*self.radius
                local y2 = y + math.sin(angle_rad)*self.radius*0.59375

                if last_x ~= nil then
                    local dist = paradox.math.distance_to_line(vector(last_x, last_y), vector(x2, y2), mouse)
                    self.hovering = dist < 10
                    if dist < 10 then
                        break
                    end
                end

                last_x, last_y = x2, y2
            end
        end
    else
        self.hovering = false
    end

    if client.key_state(0x01) then
        if self.hovering then
            self.dragging = true
        end
    else
        self.dragging = false
    end

    if self.dragging then
        -- when setting the radius, take into account that the circle is an ellipse (0.59375)
        local dx = mouse.x - x 
        local dy = mouse.y - y 

        local angle = math.deg(math.atan2(dy, dx))

        local diff = angle

        self.radius = vector(dx, dy/0.59375):length()
    end
end

-- Keybinds ---------------------------------------------------------------------
paradox.visuals.keybinds.max_size = LPH_NO_VIRTUALIZE(function(self)
    local h = 25
    local size = vector(0, h+5)
    for name, bind in pairs(self.list) do
        local mode = self:mode(bind.ref)
        local text_size = vector(renderer.measure_text("b", name))
        local mode_size = vector(renderer.measure_text("b", mode))
        local state = ui.is_menu_open() and true or (bind.enabled and ui.get(bind.ref) or false)
        if not state then goto skip end
        size.x = math.max(size.x, text_size.x + mode_size.x + 50)
        size.y = size.y + 15
        ::skip::
    end

    return size.x == 0 and vector(renderer.measure_text("b", "Binds"), size.y) or size
end)

paradox.visuals.keybinds.mode = function(self, ref)
    local key = { ui.get(ref) }
    local mode = key[2]
    
    if mode == nil then
        return "nil"
    end
    
    return self.modes[mode + 1]
end

paradox.visuals.keybinds.visible = LPH_NO_VIRTUALIZE(function(self)

    if paradox.cache.menu.is_menu_open then
        return true
    end

    local local_player = entity.get_local_player()

    if local_player == nil then
        return false
    end

    if not entity.is_alive(local_player) then
        return false
    end

    for name, bind in pairs(self.list) do
        if (bind.enabled and ui.get(bind.ref) or false) then
            return true
        end
    end
    return false
end)

paradox.visuals.keybinds.list = (function()
    local refs = { ["Min damage"] = {ui.reference("rage", "aimbot", "minimum damage override")}, ["Double Tap"] = {ui.reference("rage", "aimbot", "double tap")}, ["Hide Shots"] = {ui.reference("aa", "other", "on shot anti-aim")}, ["Quick peek assist"] = {ui.reference("rage", "other", "quick peek assist")}, ["Force body aim"] = ui.reference("rage", "aimbot", "force body aim"), ["Force safe point"] = ui.reference("rage", "aimbot", "force safe point"), ["Fake Duck"] = ui.reference("rage", "other", "duck peek assist"), ["Ping Spike"] = {ui.reference("misc", "miscellaneous", "ping spike")}, ["Freestanding"] = paradox.menu.aa.freestanding }
    local list = {}
    for bind, ref in pairs(refs) do
        list[bind] = {
            ["pos"] = vector(500, 500),
            ["opacity"] = 0,
            ["hovering"] = false,
            ["ref"] = type(ref) == "table" and ref[2] or ref,
            ["enabled"] = true
        }
    end
    return list
end)()

paradox.visuals.keybinds.render = LPH_NO_VIRTUALIZE(function(self)
    if not paradox.func.contains(paradox.cache.menu.visual_features, "Keybinds") then
        self.size = vector(0, 0)
        return
    end

    local screen = paradox.cache.ui.screen_size
    local col = color.new(paradox.menu.visuals.main_color:get())
    local mouse = ui.mouse_position()
    local mouse_down = client.key_state(0x01)
    local max_size = self:max_size()
    local padding = 10

    self.size = ease.linear(globals.frametime()*30, self.size, vector(max_size.x + padding*2, max_size.y) - self.size, 1)
    
    self.opacity = ease.linear(globals.frametime()*30, self.opacity, ((self:visible() or paradox.cache.menu.is_menu_open) and 255 or 0) - self.opacity, 1)

    if not paradox.func.hovering_menu() and not (paradox.visuals.warnings.dragging or paradox.visuals.warnings.hovering)  then
        if not self.dragging then
            if self.hovering then
                hovering = mouse.x >= self.pos.x - 5 and mouse.x <= self.pos.x + self.size.x + 5 and mouse.y >= self.pos.y - 5 and mouse.y <= self.pos.y + 25 + 5
            else
                hovering = mouse.x >= self.pos.x and mouse.x <= self.pos.x + self.size.x and mouse.y >= self.pos.y and mouse.y <= self.pos.y + 25
            end
        end
    else
        hovering = false
    end

    self.hovering = hovering
    if mouse_down then
        if self.hovering then
            self.dragging = true
        end
    else
        self.dragging = false
    end

    if self.dragging then
        if not self.in_drag then
            self.drag_pos = vector(self.pos.x - mouse.x, self.pos.y - mouse.y)
            self.in_drag = true
        end
        self.pos = vector(mouse.x + self.drag_pos.x, mouse.y + self.drag_pos.y)
    else
        self.in_drag = false
    end

    local img = self.icon

    if self.opacity >= 30 then
        renderer.blur(self.pos.x, self.pos.y, self.size.x, max_size.y)
    end
    
    local h = 25
    renderer.rectangle(self.pos.x,      self.pos.y,     self.size.x,        h, 0, 0, 0,             self.opacity)
    renderer.rectangle(self.pos.x + 1,  self.pos.y + (1), self.size.x - 2,    (h-2), 57, 57, 57,    self.opacity)
    renderer.rectangle(self.pos.x + 2,  self.pos.y + (2), self.size.x - 4,    (h-4), 40, 40, 40,    self.opacity)
    renderer.rectangle(self.pos.x + 3,  self.pos.y + (3), self.size.x - 6,   (h-6), 57, 57, 57,     self.opacity)
    renderer.texture(paradox.util.background_texture, self.pos.x + 4, self.pos.y + 4, self.size.x - 8, h - 8, 255, 255, 255, self.opacity, "r")

    img:draw(self.pos.x + self.size.x - padding*2 -2, self.pos.y + 5, 15, 15, col.r, col.g, col.b, self.opacity)
    renderer.text(self.pos.x + padding, self.pos.y - select(2, renderer.measure_text("b", "Binds"))/2 + h/2, 255, 255, 255, self.opacity, "b", 0, "Binds")


    local hovering_binds = false
    for name, bind in pairs(self.list) do
        if bind.hovering then
            hovering_binds = true
            break
        end
    end
    self.hovering_binds = hovering_binds

    local count = 0
    for name, bind in pairs(self.list) do
        local ref = bind.ref
        local state = self:visible() and (paradox.cache.menu.is_menu_open and true or (bind.enabled and ui.get(ref) or false)) or false
        local mode = (name == "Min damage" and gs.rage.mdo_value:get() or (name == "Ping Spike" and gs.misc.ping_spike_value:get() or self:mode(ref)))

        if not paradox.cache.menu.is_menu_open then
            bind.pos = ease.linear(globals.frametime()*22, bind.pos, vector(self.pos.x, self.pos.y + (h+5) + (count*15)) - bind.pos, 1)
        else
            bind.pos = vector(self.pos.x, self.pos.y + (h+5) + (count*15))
        end
        
        bind.opacity = ease.linear(globals.frametime()*30, bind.opacity, (paradox.cache.menu.is_menu_open and (bind.hovering and (bind.enabled and 200 or 150) or (bind.enabled and 255 or 100)) or (state and 255 or 0)) - bind.opacity, 1)
        
        if bind.opacity <= 5 then
            goto skip
        end

        local mode_size = vector(renderer.measure_text("b", mode))
        local name_size = vector(renderer.measure_text("b", name))

        renderer.text(bind.pos.x + padding/2, bind.pos.y, 255, 255, 255, bind.opacity, "b", 0, name)
        renderer.text(bind.pos.x + self.size.x - mode_size.x - padding/2, bind.pos.y, 255, 255, 255, bind.opacity, "b", 0, mode)


        if paradox.cache.menu.is_menu_open then
            bind.hovering = mouse.x >= bind.pos.x + padding/2 and mouse.x <= bind.pos.x + self.size.x - padding/2 and mouse.y >= bind.pos.y and mouse.y <= bind.pos.y + 14 and not (paradox.func.hovering_menu() or paradox.visuals.warnings.dragging)
            if bind.hovering and not paradox.visuals.warnings.hovering then
                if paradox.menu.mouse.clicked then
                    bind.enabled = not bind.enabled
                end
            end

        end
        count = count + 1
        ::skip::
    end
end)

-- Custom Tabs ------------------------------------------------------------------
paradox.menu.tab.render = function(self)
    if paradox.menu.gamesense_tab.active ~= "AA" then return end

    if self.alpha < 1 and not paradox.cache.menu.is_menu_open then return end

    self.alpha = ease.linear(globals.frametime()*30, self.alpha, (paradox.cache.menu.is_menu_open and 255 or 0) - self.alpha, 1)

    local mouse = ui.mouse_position()
    local menu = ui.menu_position()
    local menu_size = ui.menu_size()

    local h = 50

    renderer.rectangle(menu.x, menu.y - (h+6), menu_size.x, (h+6), 0, 0, 0, self.alpha)
    renderer.rectangle(menu.x + 1, menu.y - ((h+6)-1), menu_size.x - 2, ((h+6)-1), 57, 57, 57, self.alpha)
    renderer.rectangle(menu.x + 2, menu.y - ((h+6)-2), menu_size.x - 4, ((h+6)-2), 40, 40, 40, self.alpha)
    renderer.rectangle(menu.x + 5, menu.y - ((h+6)-5), menu_size.x - 10, ((h+6)-5), 57, 57, 57, self.alpha)
    renderer.rectangle(menu.x + 6, menu.y - ((h+6)-6), menu_size.x - 12, h, 12,12,12, self.alpha)
    

    for i = 1, #self.list do
        local tab = self.list[i]
        local tab_size = vector((menu_size.x - 12) / #self.list, h)
        local tab_pos = vector(menu.x + 6 + (tab_size.x * (i - 1)), menu.y - h)
        local hovering = paradox.func.is_hovering(tab_pos, tab_size)
        local active = self.active == tab

        if hovering then
            if paradox.menu.mouse.clicked then
                self.active = tab
                ui.handle_visibility()
            end
        end

        local c = active and 255 or hovering and 200 or 150

        if active then
            renderer.rectangle(tab_pos.x, tab_pos.y, tab_size.x, tab_size.y, 30, 30, 30, self.alpha)
            renderer.texture(paradox.util.background_texture, tab_pos.x + 1, tab_pos.y, tab_size.x - 2, tab_size.y, 255, 255, 255, self.alpha, 'r')
        end

        if self.icon[tab] then
            local icon = self.icon[tab]
            local icon_size = vector(icon:measure())    
            local sizes = { ["Info"] = 50, ["Config"] = "20"}
            local render_size = sizes[tab] or 30
            icon:draw(tab_pos.x + (tab_size.x / 2) - (render_size/2), tab_pos.y + (tab_size.y / 2) - (render_size/2), render_size, render_size, c, c, c, self.alpha, true)
        else
            renderer.text(tab_pos.x + tab_size.x / 2, tab_pos.y + tab_size.y / 2, 255, 255, 255, self.alpha, "c", 0, tab)
        end
    end
end

-- Notification Funcs -------------------------------------------------------------------
paradox.visuals.notify = {
    h = 25,
    gap = 5,
    padding = 10,
    notifications = {},
    max = 5,
    condition = function() return not (paradox.cache.menu.is_menu_open and paradox.menu.tab.active == "Visuals") end,

    queue = function()
        if #paradox.visuals.notify.notifications <= paradox.visuals.notify.max then
            return 0
        end
        return #paradox.visuals.notify.notifications - paradox.visuals.notify.max
    end,
    
    clear = function()
        for i=1, paradox.visuals.notify.queue() do
            table.remove(paradox.visuals.notify.notifications, #paradox.visuals.notify.notifications)
        end
    end,
    
    new = function(timeout, color, text)
        table.insert(paradox.visuals.notify.notifications, {
            started = false,
            instance = setmetatable({
                ["active"]  = false,
                ["timeout"] = timeout,
                ["color"]   = color,
                ["x"]       = client.screen_size()/2,
                ["y"]       = select(2, client.screen_size())/1.08,
                ["text"]    = text,
            }, paradox.visuals.notify)
        })
    end,
    
    handler = LPH_NO_VIRTUALIZE(function(self)
        local count = 0
        local visible_amount = 0
    
        for index, notification in pairs(self.notifications) do
            if not notification.instance.active and notification.started then
                table.remove(self.notifications, index)
            end
        end
    
        for i = 1, #self.notifications do
            if self.notifications[i].instance.active then
                visible_amount = visible_amount + 1
            end
        end
    
        for index, notification in pairs(self.notifications) do
    
            if not self.condition() then
                notification.instance.started = false
                goto skip
            end
    
            if index > self.max then
                goto skip
            end
            
            if notification.instance.active then
                notification.instance:render(count, visible_amount)
                count = count + 1
            end
    
            if not notification.started then
                notification.instance:start()
                notification.started = true
            end
    
        end
    
        ::skip::
    end),
    
    start = function(self)
        self.active = true
        self.delay = globals.realtime() + self.timeout
    end,
    
    
    render = LPH_NO_VIRTUALIZE(function(self, index, visible_amount)
        local screen = paradox.cache.ui.screen_size
        local x, y, padding, h, gap = self.x, self.y, self.padding, self.h, self.gap
        
        local text = self.text
    
        text = text:gsub("%<<", "\a" .. self.color:hex()):gsub("%>>", "\a" .. color.new(255, 255, 255, self.color.a):hex())
    
        if globals.realtime() < self.delay then
            self.y = ease.linear(globals.frametime()*12, self.y, (( screen.y/1.1 ) - ( (visible_amount - index) * (h + gap) )) - self.y, 1)
            self.color.a = ease.linear(globals.frametime()*12, self.color.a, 255 - self.color.a, 1)
        else
            self.y = ease.linear(globals.frametime()*12, self.y, (( screen.y/1.12 ) - ( (visible_amount - index) * (h + gap) )) - self.y, 1)
            self.color.a = ease.linear(globals.frametime()*18, self.color.a, 0 - self.color.a, 1)
    
            if self.color.a <= 5 then
                self.active = false
            end
        end
    
        local w = renderer.measure_text("c", 0, text)
    
        local h = 27
        local logo_size = 20
    
        renderer.rectangle(x     - w/2 - (padding/2),  y- (h/2),       w     + (h/2) + 20 ,       h    , 0, 0, 0,           self.color.a)
        renderer.rectangle(x + 1 - w/2 - (padding/2),  y- (h/2) + (1), w - 2 + (h/2) + 20,   (h-2), 57, 57, 57,    self.color.a)
        renderer.rectangle(x + 2 - w/2 - (padding/2),  y- (h/2) + (2), w - 4 + (h/2) + 20,   (h-4), 40, 40, 40,    self.color.a)
        renderer.rectangle(x + 3 - w/2 - (padding/2),  y- (h/2) + (3), w - 6 + (h/2) + 20,   (h-6), 57, 57, 57,     self.color.a)
        renderer.rectangle(x + 4 - w/2 - (padding/2),  y- (h/2) + (4), w - 8 + (h/2) + 20,   (h-8), 22, 22, 22,     self.color.a)
        renderer.text(20 + x, y, 255, 255, 255, self.color.a, "c", 0, text)
        paradox.visuals.logo:draw(5 + x - w/2 - padding, y - (h/2) - 1, 30, 30, self.color.r, self.color.g, self.color.b, self.color.a)
    end)
}

paradox.visuals.notify.__index = paradox.visuals.notify

-- Notifications Preview ------------------------------------------------------
paradox.visuals.notify.preview = {
    alpha = 0,
    hovering = false,
    list = {
        ["Hit"] = {
            color = color.new(60, 255, 60, 255),
            text = "Hit <<enemy>> in the <<head>> for <<100>> damage",
            enabled = true,
            hovering = false
        },
        ["Miss"] = {
            color = color.new(255, 60, 60, 255),
            text = "Missed <<paradox user>> in the <<head>> due to <<resolver>>",
            enabled = true,
            hovering = false
        },
        ["Damaged"] = {
            color = color.new(222, 89, 49, 255),
            text = "Took <<100>> damage from <<enemy>> in the <<Leg>>",
            enabled = true,
            hovering = false
        },
        ["Antibrute"] = {
            color = color.new(204, 135, 255, 255),
            text = "Antibrute <<switched>> by <<enemy>> due to <<miss>>",
            enabled = true,
            hovering = false
        }
    },

    render = LPH_NO_VIRTUALIZE(function(self)
        local screen = paradox.cache.ui.screen_size
        local mouse = ui.mouse_position()
        local x, y, padding, height, gap = screen.x/2, screen.y/1.1, paradox.visuals.notify.padding, paradox.visuals.notify.h, paradox.visuals.notify.gap
    
        if paradox.cache.menu.is_menu_open and paradox.menu.tab.active:find("Visuals") and paradox.menu.gamesense_tab.active == "AA" then
            self.alpha = ease.linear(globals.frametime()*12, self.alpha, 255 - self.alpha, 1)
        else
            self.alpha = ease.linear(globals.frametime()*24, self.alpha, 0 - self.alpha, 1)
        end
    
        if self.alpha <= 5 then
            return
        end

        local hovering = false
        for name, noti in pairs(self.list) do
            if noti.hovering then
                hovering = true
                break
            end
        end
        self.hovering = hovering
    
        for name, noti in pairs(self.list) do
            local text = noti.text
            local col = noti.color
            local h = 27
    
            text = text:gsub("%<<", "\a" .. color.new(col.r, col.g, col.b, 255):hex()):gsub("%>>", "\a" .. color.new(255, 255, 255, 255):hex())
    
            local w = renderer.measure_text("c", 0, text)
            
            y = y - height - gap
            noti.hovering = (mouse.x >= x - w/2 - (padding/2) and mouse.x <= x + (w/2) + (h/2) + 20 and mouse.y >= y - (h/2) and mouse.y <= y + h/2) and not (paradox.func.hovering_menu() or paradox.visuals.warnings.dragging or paradox.visuals.keybinds.dragging or paradox.visuals.keybinds.hovering or paradox.visuals.keybinds.hovering_binds)
    
            local alpha = math.min(self.alpha, (noti.enabled and (noti.hovering and 150 or 255) or (noti.hovering and 100 or 80)))
    
            col.a = ease.linear(globals.frametime()*24, col.a, alpha - col.a, 1)
    
            text = noti.text
            text = text:gsub("%<<", "\a" .. col:hex()):gsub("%>>", "\a" .. color.new(255, 255, 255, col.a):hex())
    
            w = renderer.measure_text("c", 0, text)
    
            if noti.hovering and not paradox.func.hovering_menu() then
                if paradox.menu.mouse.clicked then
                    noti.enabled = not noti.enabled
                end
            end
    
            renderer.rectangle(x     - w/2 - (padding/2),  y- (h/2),       w     + (h/2) + 20 ,       h    , 0, 0, 0, col.a)
            renderer.rectangle(x + 1 - w/2 - (padding/2),  y- (h/2) + (1), w - 2 + (h/2) + 20,   (h-2), 57, 57, 57,   col.a)
            renderer.rectangle(x + 2 - w/2 - (padding/2),  y- (h/2) + (2), w - 4 + (h/2) + 20,   (h-4), 40, 40, 40,   col.a)
            renderer.rectangle(x + 3 - w/2 - (padding/2),  y- (h/2) + (3), w - 6 + (h/2) + 20,   (h-6), 57, 57, 57,   col.a)
            renderer.rectangle(x + 4 - w/2 - (padding/2),  y- (h/2) + (4), w - 8 + (h/2) + 20,   (h-8), 22, 22, 22,   col.a)
            renderer.text(20 + x, y, 255, 255, 255, alpha, "c", 0, text)
            paradox.visuals.logo:draw(5 + x - w/2 - padding, y - (h/2) - 1, 30, 30, col.r, col.g, col.b, col.a)
        end
    end)
}

-- Optimizations -----------------------------------------------------------------
paradox.cache.optimize = function(self, menu_check)
    self.menu.is_menu_open = ui.is_menu_open()

    if not self.menu.is_menu_open and menu_check then return end

    self.ui.screen_size = vector(client.screen_size())
    self.menu.state = paradox.menu.aa.state:get()
    self.menu.team = paradox.menu.aa.team:get()
    self.menu.stage = paradox.menu.ab.stage:get():sub(9)
    self.menu.visual_features = paradox.menu.visuals.features:get()
    self.menu.yaw_overrides = paradox.menu.aa.yaw_overrides:get()
    self.menu.ab_reset_conditions = paradox.menu.ab.reset_conditions:get()
end

-- Welcome Message ---------------------------------------------------------------
client.exec("clear")
client.color_log(204, 135, 255, " ")
client.color_log(204, 135, 255, " ")
client.color_log(204, 135, 255, " ")
client.color_log(204, 135, 255, " ")
client.color_log(204, 135, 255, " ")
client.color_log(204, 135, 255, "           G55P5555555YYYYY5555555PPPP#")
client.color_log(204, 135, 255, "           &P7~^^^^^::::...:::^^^~~~~~!Y#")
client.color_log(204, 135, 255, "              G7~^^^^:::::..::^^^~~~!!~~~JB")
client.color_log(204, 135, 255, "                BPPPPPPPPPPPPPPPGGG57~~~~^~?B")
client.color_log(204, 135, 255, "                    BGGGGGGGGGGBBBB  P7~~~~^~?G")
client.color_log(204, 135, 255, "                    B55555555555PPJ?P  G?~~~~^^7P& ")
client.color_log(204, 135, 255, "                                   #Y?P& G?~~~^^:~B")
client.color_log(204, 135, 255, "                                     G~7& &?~~^^^.5")
client.color_log(204, 135, 255, "                                   BJ?P&#Y!~~~^^^7#")
client.color_log(204, 135, 255, "                   &5YYYYYYYYY5555J?G #Y!~~~~^~?B")
client.color_log(204, 135, 255, "                   &BBBBBBBBBBBBBB# BJ!~!!~~!Y#")
client.color_log(204, 135, 255, "               #PPPPPPPPPPPPPPPPGGG?~^~~~~!5#")
client.color_log(204, 135, 255, "             #J::::::::::::::::^^^~~~~^^!5&")
client.color_log(204, 135, 255, "           B?~^::.:::::::::::::^^^~~~~75&")
client.color_log(204, 135, 255, "          P^^~~^:!JJJJJJJJJJJJJJYYYYYG")
client.color_log(204, 135, 255, "          5:^~~~^Y")
client.color_log(204, 135, 255, "          P^^~~~^Y   Welcome to Paradox, " .. paradox.client.username)
client.color_log(204, 135, 255, "          5:~~~~~5")
client.color_log(204, 135, 255, "          #J~~~~~5   Build: " .. paradox.client.build)
client.color_log(204, 135, 255, "            #Y!~^5   Last update: " .. paradox.client.update)
client.color_log(204, 135, 255, "              &5!Y   Our Discord: discord.gg/paradoxpub")
client.color_log(204, 135, 255, "                &#")
client.color_log(204, 135, 255, " ")
client.color_log(204, 135, 255, " ")
client.color_log(204, 135, 255, " ")
client.color_log(204, 135, 255, " ")
client.color_log(204, 135, 255, " ")

paradox.db:save_default()
paradox.db:cache()
paradox.db:load()

paradox.visuals.notify.new(4, color.new(204, 135, 255), "Welcome to Paradox, <<" .. paradox.client.username .. ">>!")

paradox.config:load_last()

-- UI Callbacks ------------------------------------------------------------------
paradox.menu.aa.copy:set_callback(function()
    local state = paradox.cache.menu.state
    local team = paradox.cache.menu.team
    local stage = tonumber(paradox.cache.menu.stage)
    local copy_state = paradox.menu.aa.copy_state:get()
    local copy_team = paradox.menu.aa.copy_team:get()
    local copy_stage = tonumber(paradox.menu.aa.copy_stage:get():sub(9))

    if paradox.menu.tab.active == "Antiaim" then
        for i, v in pairs(paradox.menu.aa.builder[copy_team][copy_state]) do
            v:set(paradox.menu.aa.builder[team][state][i]:get())
            ::skip::
        end
    elseif paradox.menu.tab.active == "Antibrute" then
        for i, v in pairs(paradox.menu.ab.builder[copy_state][copy_stage]) do
            v:set(paradox.menu.ab.builder[state][stage][i]:get())
            ::skip::
        end
    end
end)

paradox.menu.config.list:set_callback(function(e)
    if e:get() == nil then return end

    local configs = paradox.func.keys(paradox.config.list)

    local name = configs[e:get()+1]

    if name == "" or name == nil then return end

    paradox.menu.config.name:set(name)

    if paradox.config.list[paradox.config.last_config] == nil then return end
    local list = paradox.func.keys(paradox.config.list)
    local col = color.new(paradox.menu.visuals.main_color:get())
    list[paradox.func.index(list, paradox.config.last_config)] = "\a" .. col:hex() .. "➥ " .. paradox.config.last_config
    paradox.menu.config.list:update(list)
end)

paradox.menu.config.save:set_callback(function()
    local name = paradox.menu.config.name:get()

    local succ, err = xpcall(function()
        paradox.config:save(name)
    end, function()
        paradox.visuals.notify.new(2, color.new(255, 135, 135), "Failed to <<save>> config: <<" .. name .. ">>")
    end)

    paradox.menu.config.list:update(paradox.func.keys(paradox.config.list))
    paradox.menu.config.list:set(paradox.func.index(paradox.func.keys(paradox.config.list), name)-1)

    if succ then
        if paradox.config.list[paradox.config.last_config] == nil then return end
        local list = paradox.func.keys(paradox.config.list)
        local col = color.new(paradox.menu.visuals.main_color:get())
        list[paradox.func.index(list, paradox.config.last_config)] = "\a" .. col:hex() .. "➥ " .. paradox.config.last_config
        paradox.menu.config.list:update(list)
    end

end)

paradox.menu.config.load:set_callback(function()
    if paradox.menu.config.list:get() == nil then return end

    local configs = paradox.func.keys(paradox.config.list)
    local name = configs[paradox.menu.config.list:get()+1]
    
    local succ, err = xpcall(function()
        paradox.config:load(name)
    end, function()
        paradox.visuals.notify.new(2, color.new(255, 135, 135), "Failed to <<load>> config: <<" .. name .. ">>")
    end)


    if succ then
        if paradox.config.list[paradox.config.last_config] == nil then return end
        local list = paradox.func.keys(paradox.config.list)
        local col = color.new(paradox.menu.visuals.main_color:get())
        list[paradox.func.index(list, paradox.config.last_config)] = "\a" .. col:hex() .. "➥ " .. paradox.config.last_config
        paradox.menu.config.list:update(list)
    end
end)

paradox.menu.config.delete:set_callback(function()
    if paradox.menu.config.list:get() == nil then return end
    local configs = paradox.func.keys(paradox.config.list)
    local name = configs[paradox.menu.config.list:get()+1]
    
    local succ, err = xpcall(function()
        paradox.config:delete(name)
    end, function()
        paradox.visuals.notify.new(2, color.new(255, 135, 135), "Failed to <<delete>> config: <<" .. name .. ">>")
    end)

    configs = paradox.func.keys(paradox.config.list)

    paradox.menu.config.list:update(configs)
    if #configs ~= 0 then
        paradox.menu.config.list:set(0)
        paradox.menu.config.name:set(configs[1])
    end


    if succ then
        if name == paradox.config.last_config then paradox.config.last_config = nil end
        if paradox.config.list[paradox.config.last_config] == nil then return end
        local list = paradox.func.keys(paradox.config.list)
        local col = color.new(paradox.menu.visuals.main_color:get())
        list[paradox.func.index(list, paradox.config.last_config)] = "\a" .. col:hex() .. "➥ " .. paradox.config.last_config
        paradox.menu.config.list:update(list)
    end

end)

paradox.menu.config.import:set_callback(function()
    local succ, err = xpcall(function()
        ui.load_config(base64.decode(clipboard.get()))
        paradox.visuals.notify.new(2, color.new(204, 135, 255), "Successfully <<imported>> settings!")
    end, function()
        paradox.visuals.notify.new(2, color.new(255, 135, 135), "Failed to <<import>> settings!")
    end)
end)

paradox.menu.config.export:set_callback(function()
    local succ, err = xpcall(function()
        clipboard.set(base64.encode(ui.get_config()))
        paradox.visuals.notify.new(2, color.new(204, 135, 255), "Successfully <<exported>> settings!")
    end, function()
        paradox.visuals.notify.new(2, color.new(255, 135, 135), "Failed to <<export>> settings!")
    end)
end)

-- Event Callbacks ---------------------------------------------------------------------
paradox.cache:optimize(false)


local reverse = false
local last_dance = 0
client.set_event_callback("pre_render", function()
    local local_player = entity.get_local_player()
    if local_player == nil then return end
    if not entity.is_alive(local_player) then return end

    local flags = entity.get_prop(local_player, "m_fFlags")
    local air = bit.band(flags, 1) == 0

    local lp = __entity.new(local_player)

    -- dancing shit
    local time = globals.curtime()*1.5 % 1
    if math.floor(time*10) == 0 and globals.curtime() > last_dance + 0.5 then
        reverse = not reverse
        last_dance = globals.curtime()
    end

    local layer4 = lp:get_anim_overlay(4)
    local layer6 = lp:get_anim_overlay(6)
    local layer7 = lp:get_anim_overlay(7)

    if air then
        if paradox.menu.misc.animations_air:get() == "Moonwalk" then
            layer6.weight = 1
        elseif paradox.menu.misc.animations_air:get() == "Static legs 2" then
            layer4.weight = 0
            layer4.cycle = 0
            layer4.playback_rate = 0
            layer4.sequence = 11
        elseif paradox.menu.misc.animations_air:get() == "Static legs" then
            layer4.weight = 0.5
            layer4.cycle = 0.5
        elseif paradox.menu.misc.animations_air:get() == "Dance" then
            local startValue = 0.67
            local endValue = 0.75
            layer6.weight = 0.3
            layer6.cycle = paradox.math.lerp(reverse and endValue or startValue, reverse and startValue or endValue, time)
            layer6.sequence = 11
        end
    else
        if paradox.menu.misc.animations_ground:get() == "Static legs" then
            -- make static legs while on ground
            layer6.weight = 0
            layer7.weight = 0

        elseif paradox.menu.misc.animations_ground:get() == "Dance" then
            local startValue = 0.67
            local endValue = 0.75
            layer6.weight = 0.3
            layer6.cycle = paradox.math.lerp(reverse and endValue or startValue, reverse and startValue or endValue, time)
            layer6.sequence = 11
        end
    end
end)

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
client.set_event_callback("aim_hit", function(e)
    local hitgroup = hitgroup_names[e.hitgroup + 1] or "?"

    if paradox.visuals.notify.preview.list["Hit"].enabled then
        paradox.visuals.notify.new(5, color.new(60, 255, 60), string.format("Hit <<%s>> in the <<%s>> for <<%d>> damage", entity.get_player_name(e.target), hitgroup, e.damage))
    end
end)

client.set_event_callback("aim_miss", function(e)
    local hitgroup = hitgroup_names[e.hitgroup + 1] or "?"

    if paradox.visuals.notify.preview.list["Miss"].enabled then
        paradox.visuals.notify.new(5, color.new(255, 60, 60), string.format("Missed <<%s>> in the <<%s>> due to <<%s>>", entity.get_player_name(e.target), hitgroup, e.reason))
    end
end)

client.set_event_callback("player_hurt", function(e)
    local local_player = entity.get_local_player()
    if local_player == nil then return end

    local attacker = client.userid_to_entindex(e.attacker)
    local victim  = client.userid_to_entindex(e.userid)

    if attacker == local_player then return end
    if victim ~= local_player then return end

    if paradox.visuals.notify.preview.list["Damaged"].enabled then
        paradox.visuals.notify.new(5, color.new(255, 60, 60), string.format("Took <<%d>> damage from <<%s>> in the <<%s>>", e.dmg_health, entity.get_player_name(attacker), hitgroup_names[e.hitgroup + 1]))
    end
end)



client.set_event_callback("player_death", function(e)
    paradox.ab:on_death(e)
end)

client.set_event_callback("round_end", function()
    paradox.ab:on_round_end()
end)

client.set_event_callback("bullet_impact", function(e)
    paradox.ab:on_bullet_impact(e)
end)

client.set_event_callback("run_command", function(cmd)
    paradox.aa.desync:on_run_command(cmd)
end)

client.set_event_callback("setup_command", function(cmd)
    paradox.cache.cmd.forwardmove = cmd.forwardmove
    paradox.cache.cmd.sidemove = cmd.sidemove
    
    paradox.func.attack_fix(cmd)
    paradox.aa:update_state(cmd)
    paradox.aa.anti_backstab:on_setup_command()
    paradox.aa.manual:on_setup_command()
    paradox.ab:timeout()
    paradox.aa:on_setup_command(cmd)
    paradox.aa.defensive:on_setup_command(cmd)
end)

client.set_event_callback("indicator", function(indicator)
    if indicator.text == "DT" then
        paradox.util.dt_charged = (indicator.r == 255 and indicator.g == 255 and indicator.b == 255)
    end

    paradox.visuals.indicator_fix.indicators[#paradox.visuals.indicator_fix.indicators + 1] = indicator
end)

client.set_event_callback("paint", function()
    paradox.visuals.warnings.knife:render()
    paradox.visuals.warnings.zeus:render()
    paradox.visuals.indicators:render()
    paradox.visuals.forced_watermark:render()
    paradox.visuals.indicator_fix:render()
end)

client.set_event_callback("paint_ui", function()
    gs.aa.master:set(true)

    if paradox.cache.menu.is_menu_open then
        paradox.func.hide_aa(true)
    end

    if entity.get_local_player() == nil and paradox.aa.desync.choke.last_tick ~= 0 then
        paradox.aa.desync.choke.last_tick = 0
    end

    paradox.cache:optimize()

    paradox.menu.gamesense_tab:listener()
    paradox.menu.mouse:listener()
    paradox.stats:listener()

    paradox.visuals.notify:handler()
    paradox.visuals.notify.preview:render()

    paradox.visuals.keybinds:render()
    paradox.visuals.warnings:preview()
    paradox.visuals.watermark:render()

    paradox.menu.tab:render()
end)

client.set_event_callback("shutdown", function()
    paradox.func.hide_aa(false)

    local data = paradox.cache.db

    data.last_config = paradox.config.last_config
    data.configs = paradox.config.list
    data.pos.keybinds.x, data.pos.keybinds.y = paradox.visuals.keybinds.pos.x, paradox.visuals.keybinds.pos.y
    data.warnings.radius = paradox.visuals.warnings.radius
    for name, v in pairs(paradox.visuals.keybinds.list) do
        data.keybinds[name] = v.enabled
    end

    for name, v in pairs(paradox.visuals.notify.preview.list) do
        data.notifications[name] = v.enabled
    end

    for option, v in pairs(paradox.visuals.watermark.options) do
        data.watermark.options[option] = v.state
    end

    paradox.db:save(data)
end)
