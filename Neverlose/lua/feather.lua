-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

_DEBUG = true

-- @region: libraries

local clipboard = require("neverlose/clipboard")
local base64 = require("neverlose/base64")
local gradient = require("neverlose/gradient")

-- @region: general

local script = {}

script.name = "feather"
script.build = "dev"
script.version = "1.0"

script.conditions = {"Stand", "Run", "Walk", "Duck", "Aero", "C-Aero"}

-- @region: screen

script.x = render.screen_size().x
script.y = render.screen_size().y

-- @region: groups

script.groups = {
    home_tabs = ui.create("> Home <", "Tabs", 1),
    home_config = ui.create("> Home <", "Config", 2),
    home_information = ui.create("> Home <", "Information", 2),
    home_links = ui.create("> Home <", "Links", 2),

    antiaim_general = ui.create("> Anti Aim <", "Global", 1),
    antiaim_builder = ui.create("> Anti Aim <", "Builder", 2),
    antiaim_misc = ui.create("> Anti Aim <", "Misc", 1),
    antiaim_presets = ui.create("> Anti Aim <", "Presets", 2),

    settings_tabs = ui.create("> Settings <", "Tabs", 1),
    settings_general = ui.create("> Settings <", "Global", 2),
    settings_main = ui.create("> Settings <", "Main", 2),
    settings_misc = ui.create("> Settings <", "Misc", 2)
}

-- @region: elements

script.elements = {}

script.n_elements = {}

script.item_groups = {}

script.hex_color = ui.get_style("Button"):to_hex()

script.n_elements.home_tabs = script.groups.home_tabs:list("Category", {"> " .. "Information", "> " .. "Configs", "> " .. "Links"})
script.n_elements.home_welcome = script.groups.home_information:label("> You're welcome, " .. "\a" .. script.hex_color .. common.get_username() .. "\aFFFFFFFF" .. "!")
script.n_elements.home_version = script.groups.home_information:label("> Current version: " .. "\a" .. script.hex_color .. script.version .. "\aFFFFFFFF" .. ". Have a good game!")

script.n_elements.home_discord = script.groups.home_information:button("                               > Discord <                                ", function()
    --panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/mZPPbUCRtg")
end, true)

script.elements.antiaim_enabled = script.groups.antiaim_general:switch("Enable", false)
script.elements.antiaim_manual = script.groups.antiaim_general:combo("Manual:", {"Off", "Left", "Right"})
script.elements.antiaim_mode = script.groups.antiaim_general:list("", {"> Builder", "> Presets"})
script.elements.antiaim_preset = script.groups.antiaim_presets:list("Select Preset", {"> Aggressive"})
script.elements.antiaim_condition = script.groups.antiaim_builder:combo("Select Condition:", script.conditions)
script.elements.antiaim_additionals = script.groups.antiaim_misc:listable("Additionals", {"> Leg Fucker", "> Warmup AA"})

script.elements.settings_enabled = script.groups.settings_general:switch("Enable", false)
script.n_elements.settings_tabs = script.groups.settings_tabs:list("Category", {"> Ragebot", "> Visuals", "> Others"})

script.elements.visuals_accent = script.groups.settings_main:color_picker("Visuals Accent", script.hex_color)
script.elements.visuals_indicators = script.groups.settings_main:switch("Crosshair Indicators", false)
script.elements.visuals_damage = script.groups.settings_main:switch("Damage Indicators", false)
script.elements.visuals_custom_scope = script.groups.settings_main:switch("Custom Scope ")

script.item_groups.custom_scope = script.elements.visuals_custom_scope:create()

script.elements.visuals_custom_scope_color = script.item_groups.custom_scope:color_picker("Color", color(255, 255, 255))
script.elements.visuals_custom_scope_length = script.item_groups.custom_scope:slider("Length", 0, 1000, 45)
script.elements.visuals_custom_scope_offset = script.item_groups.custom_scope:slider("Offset", 0, 500, 15)

script.elements.others_viewmodel = script.groups.settings_main:switch("Viewmodel", false)

script.item_groups.viewmodel = script.elements.others_viewmodel:create()

script.elements.others_viewmodel_fov = script.item_groups.viewmodel:slider("FOV", 0, 100, 68)
script.elements.others_viewmodel_x = script.item_groups.viewmodel:slider("X Offset", -10, 10, 0)
script.elements.others_viewmodel_y = script.item_groups.viewmodel:slider("Y Offset", -10, 10, 0)
script.elements.others_viewmodel_z = script.item_groups.viewmodel:slider("Z Offset", -10, 10, 0)

script.elements.others_aspect_ratio = script.groups.settings_main:switch("Aspect Ratio", false)

script.item_groups.aspect_ratio = script.elements.others_aspect_ratio:create()

script.elements.others_aspect_ratio_value = script.item_groups.aspect_ratio:slider("Ratio", 0, 20, 0, 0.1)

script.elements.ragebot_hitlogs = script.groups.settings_main:switch("Hitlogs", false)

script.item_groups.hitlogs = script.elements.ragebot_hitlogs:create()

script.elements.ragebot_hitlogs_type = script.item_groups.hitlogs:listable("Type", {"Crosshair", "Console", "Screen"})

-- @region: builder

for _, var in pairs(script.conditions) do
    function text(t) 
        return string.format("%s > %s", var, t)
    end
    
    script.elements[var .. "[L] Yaw Add"] = script.groups.antiaim_builder:slider(text("[L] Yaw Add"), -180, 180, 0)
    script.elements[var .. "[R] Yaw Add"] = script.groups.antiaim_builder:slider(text("[R] Yaw Add"), -180, 180, 0)
    script.elements[var .. "Yaw Modifier"] = script.groups.antiaim_builder:combo(text("Yaw Modifier:"), {"Disabled", "Center", "Offset", "3-Way", "5-Way"})
    script.elements[var .. "[L] Modifier Add"] = script.groups.antiaim_builder:slider(text("[L] Modifier Add"), -180, 180, 0)
    script.elements[var .. "[R] Modifier Add"] = script.groups.antiaim_builder:slider(text("[R] Modifier Add"), -180, 180, 0)
    script.elements[var .. "Fake Yaw"] = script.groups.antiaim_builder:combo(text("Fake Yaw:"), {"Disabled", "Default"})
    script.elements[var .. "[L] Fake Limit"] = script.groups.antiaim_builder:slider(text("[L] Fake Limit"), 0, 60, 0)
    script.elements[var .. "[R] Fake Limit"] = script.groups.antiaim_builder:slider(text("[R] Fake Limit"), 0, 60, 0)
end

-- @region: animations

local animations = {}

function animations.lerp(a, b, t) return a + (b - a) * t end

-- @region: visibility

local visibility = {}

function visibility.update()
    local elements = {
        "[L] Yaw Add",
        "[R] Yaw Add",
        "Yaw Modifier",
        "[L] Modifier Add",
        "[R] Modifier Add",
        "Fake Yaw",
        "[L] Fake Limit",
        "[R] Fake Limit"
    }

    script.n_elements.home_welcome:visibility(script.n_elements.home_tabs:get() == 1)
    script.n_elements.home_version:visibility(script.n_elements.home_tabs:get() == 1)

    script.n_elements.home_discord:visibility(script.n_elements.home_tabs:get() == 3)

    script.elements.visuals_custom_scope:visibility(script.n_elements.settings_tabs:get() == 2 and script.elements.settings_enabled:get())
    script.elements.visuals_indicators:visibility(script.n_elements.settings_tabs:get() == 2 and script.elements.settings_enabled:get())
    script.elements.visuals_damage:visibility(script.n_elements.settings_tabs:get() == 2 and script.elements.settings_enabled:get())
    script.elements.visuals_accent:visibility(script.n_elements.settings_tabs:get() == 2 and script.elements.settings_enabled:get())

    script.elements.others_aspect_ratio:visibility(script.n_elements.settings_tabs:get() == 3 and script.elements.settings_enabled:get())
    script.elements.others_viewmodel:visibility(script.n_elements.settings_tabs:get() == 3 and script.elements.settings_enabled:get())

    script.elements.ragebot_hitlogs:visibility(script.n_elements.settings_tabs:get() == 1 and script.elements.settings_enabled:get())

    for _, var in pairs(script.conditions) do
        local antiaim_state = script.elements.antiaim_enabled:get()
        local condition_state = script.elements.antiaim_condition:get() == var
        local builder_state = script.elements.antiaim_mode:get() == 1
        local presets_state = script.elements.antiaim_mode:get() == 2

        script.elements.antiaim_condition:visibility(builder_state and antiaim_state)
        script.elements.antiaim_additionals:visibility(antiaim_state)
        script.elements.antiaim_preset:visibility(antiaim_state and presets_state)
        script.elements.antiaim_mode:visibility(antiaim_state)
        script.elements.antiaim_manual:visibility(antiaim_state)

        for _, element in pairs(elements) do
            local modifier_state = script.elements[var .. "Yaw Modifier"]:get() ~= "Disabled"
            local fake_yaw_state = script.elements[var .. "Fake Yaw"]:get() ~= "Disabled"
    
            if element == "[L] Modifier Add" or element == "[R] Modifier Add" then
                script.elements[var .. element]:visibility((condition_state and builder_state and modifier_state and antiaim_state))
            elseif element == "[L] Fake Limit" or element == "[R] Fake Limit" then
                script.elements[var .. element]:visibility((condition_state and builder_state and fake_yaw_state and antiaim_state))
            else
                script.elements[var .. element]:visibility((condition_state and builder_state and antiaim_state))
            end
        end
    end
end

-- @region: utility

local utility = {}

function utility.get_condition()
    local local_player = entity.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end

    local flags = local_player.m_fFlags
    local velocity_x = local_player["m_vecVelocity[0]"]
    local velocity_y = local_player["m_vecVelocity[1]"]
    local speed = math.sqrt(velocity_x ^ 2 + velocity_y ^ 2)

    local conditions = {
        [1] = function () 
            if (bit.band(flags, 1) ~= 0 or bit.band(flags, 4) ~= 4) then 
                return false; end 
            return "C-Aero"; 
        end;

        [2] = function ()
            if (bit.band(flags, 1) ~= 0) then 
                return false; end 
            return "Aero"; 
        end;

        [3] = function ()
            if (bit.band(flags, 4) ~= 4) then 
                return false; end 
            return "Duck"; 
        end; 

        [4] = function () 
            if (not ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() or speed < 3) then 
                return false; end 
            return "Walk";
        end; 

        [5] = function () 
            if (speed < 3) then 
                return false; end 
            return "Run"
        end;

        [6] = function ()
            return "Stand"
        end
    }

    for _ = 1, #conditions do
        local con = conditions[_];
        if (con() ~= false) then
            return con();
        end; end
    return nil;
end

function utility.aspect_ratio()
    cvar.r_aspectratio:float((script.elements.others_aspect_ratio:get() and (script.elements.settings_enabled:get() and (script.elements.others_aspect_ratio_value:get() / 10) or 0) or 0))
end

function utility.viewmodel()
    cvar.viewmodel_fov:int((script.elements.others_viewmodel:get() and (script.elements.settings_enabled:get() and script.elements.others_viewmodel_fov:get() or 60) or 60), true)
	cvar.viewmodel_offset_x:float((script.elements.others_viewmodel:get() and (script.elements.settings_enabled:get() and script.elements.others_viewmodel_x:get() or 0) or 0), true)
	cvar.viewmodel_offset_y:float((script.elements.others_viewmodel:get() and (script.elements.settings_enabled:get() and script.elements.others_viewmodel_y:get() or -1) or -1), true)
	cvar.viewmodel_offset_z:float((script.elements.others_viewmodel:get() and (script.elements.settings_enabled:get() and script.elements.others_viewmodel_z:get() or 0) or 0), true)
end

function utility.get_bind(name)
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

function utility.sidebar()
    local animation = gradient.text_animate(string.upper(string.sub(script.name, 1, 1)) .. string.sub(script.name, 2, 15) .. " [" .. string.upper(string.sub(script.build, 1, 1)) .. string.sub(script.build, 2, 15) .. "]", -0.75, {
        ui.get_style("Switch Active")
    })

    animation:animate()

    ui.sidebar(animation:get_animated_text(), "feather-pointed")
end

-- @region: visuals

local visuals = {}

visuals.custom_scope_animation = 0

function visuals.custom_scope()
    local local_player = entity.get_local_player()

    if not local_player or not local_player:is_alive() then
        return
    end

    ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):override("Remove All")

    if not local_player.m_bIsScoped then
        visuals.custom_scope_animation = animations.lerp(visuals.custom_scope_animation, 0, 17 * globals.frametime)
    else
        visuals.custom_scope_animation = animations.lerp(visuals.custom_scope_animation, 1, 17 * globals.frametime)
    end

    if script.elements.visuals_custom_scope:get() and script.elements.settings_enabled:get() then
        render.gradient(vector(render.screen_size().x / 2 - script.elements.visuals_custom_scope_offset:get() * visuals.custom_scope_animation, render.screen_size().y / 2), vector(render.screen_size().x / 2 - script.elements.visuals_custom_scope_offset:get() * visuals.custom_scope_animation - script.elements.visuals_custom_scope_length:get() * visuals.custom_scope_animation, render.screen_size().y / 2 + 1), script.elements.visuals_custom_scope_color:get(), color(255, 255, 255, 0), script.elements.visuals_custom_scope_color:get(), color(255, 255, 255, 0))
        render.gradient(vector(render.screen_size().x / 2 + script.elements.visuals_custom_scope_offset:get() * visuals.custom_scope_animation + 1, render.screen_size().y / 2), vector(render.screen_size().x / 2 + script.elements.visuals_custom_scope_offset:get() * visuals.custom_scope_animation + script.elements.visuals_custom_scope_length:get() * visuals.custom_scope_animation, render.screen_size().y / 2 + 1), script.elements.visuals_custom_scope_color:get(), color(255, 255, 255, 0), script.elements.visuals_custom_scope_color:get(), color(255, 255, 255, 0))
        render.gradient(vector(render.screen_size().x / 2, render.screen_size().y / 2 + script.elements.visuals_custom_scope_offset:get() * visuals.custom_scope_animation), vector(render.screen_size().x / 2 + 1, render.screen_size().y / 2 + script.elements.visuals_custom_scope_offset:get() * visuals.custom_scope_animation + script.elements.visuals_custom_scope_length:get() * visuals.custom_scope_animation), script.elements.visuals_custom_scope_color:get(), script.elements.visuals_custom_scope_color:get(), color(255, 255, 255, 0), color(255, 255, 255, 0))
        render.gradient(vector(render.screen_size().x / 2, render.screen_size().y / 2 - script.elements.visuals_custom_scope_offset:get() * visuals.custom_scope_animation), vector(render.screen_size().x / 2 + 1, render.screen_size().y / 2 - script.elements.visuals_custom_scope_offset:get() * visuals.custom_scope_animation - script.elements.visuals_custom_scope_length:get() * visuals.custom_scope_animation), script.elements.visuals_custom_scope_color:get(), script.elements.visuals_custom_scope_color:get(), color(255, 255, 255, 0), color(255, 255, 255, 0))
    else
        ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):override("Remove Overlay")
    end
end

visuals.scope_offset = 0
visuals.scope_value = 0

local idata = {[""] = {alpha_k = 0}}

function visuals.indicators()
    local local_player = entity.get_local_player()

    if not local_player or not local_player:is_alive() then
        return
    end

    local condition = utility.get_condition()

    if condition == nil then
        return
    end

    local name_animation = gradient.text_animate(string.upper(script.name), -0.75, {
        script.elements.visuals_accent:get(), 
        color(90, 90, 90)
    })

    name_animation:animate()

    local offset = render.measure_text(2, nil, string.upper(script.name))

    local active_binds = {}

    local damage = utility.get_bind("Min. Damage")[1]
    local doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"):get()
    local onshot = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"):get()

    local binds = { 
        {text = "DMG", state = damage, vcolor = color(220, 220, 220), number = 1},
        {text = "DT", state = doubletap, vcolor = color(220, 220, 220), number = damage and 2 or 1},
        {text = "HS", state = onshot, vcolor = color(220, 220, 220), number = (damage and doubletap) and 3 or (damage or doubletap) and 2 or 1}
    }

    for key, value in pairs(binds) do
        if value.state then
            table.insert(active_binds, {text = value.text, vcolor = value.vcolor})
        else
            table.remove(active_binds, key)
        end

        if idata[value.text] == nil then
            idata[value.text] = {alpha_k = 0}
        end
    end

    for key, value in pairs(active_binds) do
        for i = 1, #binds do
            if binds[i].text == value.text then
                binds[i].number = key
            end
        end
    end

    if local_player.m_bIsScoped then
        visuals.scope_value = animations.lerp(visuals.scope_value, 1, globals.frametime * 20)
    else
        visuals.scope_value = animations.lerp(visuals.scope_value, 0, globals.frametime * 20)
    end

    local scope_fixed = visuals.scope_value <= 0.01 and 0 or (visuals.scope_value >= 0.99 and 1 or visuals.scope_value)

    visuals.scope_offset = 35 * scope_fixed

    if script.elements.visuals_indicators:get() and script.elements.settings_enabled:get() then
        render.text(2, vector(script.x / 2 + 1 + visuals.scope_offset, script.y / 2 + 15), script.elements.visuals_accent:get(), "c", name_animation:get_animated_text())
        
        render.text(2, vector(script.x / 2 + 1 + visuals.scope_offset, script.y / 2 + 12 + offset.y), color(220, 220, 220), "c", string.upper(condition))

        for key, value in pairs(binds) do
            idata[value.text].alpha_k = value.state and animations.lerp(idata[value.text].alpha_k, 1, globals.frametime * 20) or 0
            
            render.text(2, vector(script.x / 2 + 1 + visuals.scope_offset, script.y / 2 + 9 + offset.y * 2 + offset.y * (value.number - 1) - 3 * (value.number - 1)), color(220, 220, 220, idata[value.text].alpha_k * 255), "c", value.text)
        end
    end
end

function visuals.damage()
    local local_player = entity.get_local_player()

    if not local_player or not local_player:is_alive() then
        return
    end

    if script.elements.visuals_damage:get() and script.elements.settings_enabled:get() then
        local damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get()

        render.text(2, vector(script.x / 2 + 6, script.y / 2 - 16), color(255, 255, 255, 255), nil, tostring(damage))
    end
end

-- @region: screen

local screen = {}

function screen.update()
    script.x = render.screen_size().x
    
    script.y = render.screen_size().y
end

-- @region: antiaim

local antiaim = {}

antiaim.side = false

function antiaim.desync_side(cmd)
    if globals.choked_commands ~= 0 then 
        return
    end

    antiaim.side = rage.antiaim:inverter()
end

function antiaim.fake_override()
    ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"):set("Down")
    ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"):set("Backward")
    ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"):set("At Target")
    ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"):override(25)
    ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"):set("Offset")
    ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"):override(-55)
    ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"):set(true)
    ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"):override(45)
    ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"):override(45)
    ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"):override({"Jitter"})
    ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"):override("Off")
end

function antiaim.override(cmd)
    local local_player = entity.get_local_player()

    if not local_player or not local_player:is_alive() then
        return
    end

    local condition = utility.get_condition()

    if condition == nil then
        return
    end

    function value(n)
        return script.elements[condition .. n]:get()
    end

    if not script.elements.antiaim_enabled:get() then
        ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"):set(false)

        antiaim.fake_override()

        return
    else
        ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"):set(true)
    end

    if script.elements.antiaim_additionals:get(2) and entity.get_game_rules().m_bWarmupPeriod then
        antiaim.fake_override()

        return
    end

    if script.elements.antiaim_mode:get(1) then
        ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"):set("Down")
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"):set("Backward")
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"):set(script.elements.antiaim_manual:get() == "Off" and "At Target" or "Backward")
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"):override(script.elements.antiaim_manual:get() == "Off" and (antiaim.side and -value("[L] Yaw Add") or -value("[R] Yaw Add")) or (script.elements.antiaim_manual:get() == "Left" and -90 or (script.elements.antiaim_manual:get() == "Right" and 90 or 0)))
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"):set(value("Yaw Modifier"))
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"):override(antiaim.side and value("[L] Modifier Add") or value("[R] Modifier Add"))
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"):set(value("Fake Yaw") ~= "Disabled")
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"):override(antiaim.side and value("[L] Fake Limit") or 33)
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"):override(antiaim.side and value("[R] Fake Limit") or 33)
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"):override({"Jitter"})
        ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"):override("Off")
    end
end

function antiaim.leg_fucker(cmd)
    if script.elements.antiaim_additionals:get(1) then
        ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):set(antiaim.side and "Sliding" or "Walking")
    end
end

function antiaim.no_defensive()
    rage.exploit:allow_defensive(false)
end

function antiaim.handler(cmd)
    antiaim.desync_side(cmd)

    antiaim.leg_fucker(cmd)

    antiaim.override(cmd)
end

-- @region: config

local config = {}

function config.import()
    local config = clipboard.get()
    
    local protect, config_data = pcall(function()
        json.parse(base64.decode(config))
    end), json.parse(base64.decode(config))

    if protect then
        for key, value in pairs(config_data) do
            local item = script.elements[key]

            if item then
                item:set(value)
            end
        end

        print("Succesfully imported config")
    end
end

function config.default()
    local config = "eyJBZXJvRmFrZSBZYXciOiJEZWZhdWx0IiwiQWVyb1lhdyBNb2RpZmllciI6IkNlbnRlciIsIkFlcm9bTF0gRmFrZSBMaW1pdCI6NjAuMCwiQWVyb1tMXSBNb2RpZmllciBBZGQiOi00MS4wLCJBZXJvW0xdIFlhdyBBZGQiOjUuMCwiQWVyb1tSXSBGYWtlIExpbWl0Ijo2MC4wLCJBZXJvW1JdIE1vZGlmaWVyIEFkZCI6LTM5LjAsIkFlcm9bUl0gWWF3IEFkZCI6LTIuMCwiQy1BZXJvRmFrZSBZYXciOiJEZWZhdWx0IiwiQy1BZXJvWWF3IE1vZGlmaWVyIjoiQ2VudGVyIiwiQy1BZXJvW0xdIEZha2UgTGltaXQiOjYwLjAsIkMtQWVyb1tMXSBNb2RpZmllciBBZGQiOi00Mi4wLCJDLUFlcm9bTF0gWWF3IEFkZCI6NC4wLCJDLUFlcm9bUl0gRmFrZSBMaW1pdCI6NjAuMCwiQy1BZXJvW1JdIE1vZGlmaWVyIEFkZCI6LTQ1LjAsIkMtQWVyb1tSXSBZYXcgQWRkIjotOS4wLCJEdWNrRmFrZSBZYXciOiJEZWZhdWx0IiwiRHVja1lhdyBNb2RpZmllciI6IkNlbnRlciIsIkR1Y2tbTF0gRmFrZSBMaW1pdCI6NjAuMCwiRHVja1tMXSBNb2RpZmllciBBZGQiOi00MC4wLCJEdWNrW0xdIFlhdyBBZGQiOjkuMCwiRHVja1tSXSBGYWtlIExpbWl0Ijo2MC4wLCJEdWNrW1JdIE1vZGlmaWVyIEFkZCI6LTQwLjAsIkR1Y2tbUl0gWWF3IEFkZCI6MC4wLCJSdW5GYWtlIFlhdyI6IkRlZmF1bHQiLCJSdW5ZYXcgTW9kaWZpZXIiOiJDZW50ZXIiLCJSdW5bTF0gRmFrZSBMaW1pdCI6NjAuMCwiUnVuW0xdIE1vZGlmaWVyIEFkZCI6LTYxLjAsIlJ1bltMXSBZYXcgQWRkIjo1LjAsIlJ1bltSXSBGYWtlIExpbWl0Ijo2MC4wLCJSdW5bUl0gTW9kaWZpZXIgQWRkIjotNTkuMCwiUnVuW1JdIFlhdyBBZGQiOi0zLjAsIlN0YW5kRmFrZSBZYXciOiJEZWZhdWx0IiwiU3RhbmRZYXcgTW9kaWZpZXIiOiJDZW50ZXIiLCJTdGFuZFtMXSBGYWtlIExpbWl0Ijo2MC4wLCJTdGFuZFtMXSBNb2RpZmllciBBZGQiOi02MC4wLCJTdGFuZFtMXSBZYXcgQWRkIjo0LjAsIlN0YW5kW1JdIEZha2UgTGltaXQiOjYwLjAsIlN0YW5kW1JdIE1vZGlmaWVyIEFkZCI6LTQ5LjAsIlN0YW5kW1JdIFlhdyBBZGQiOjMuMCwiV2Fsa0Zha2UgWWF3IjoiRGVmYXVsdCIsIldhbGtZYXcgTW9kaWZpZXIiOiJDZW50ZXIiLCJXYWxrW0xdIEZha2UgTGltaXQiOjYwLjAsIldhbGtbTF0gTW9kaWZpZXIgQWRkIjotMzQuMCwiV2Fsa1tMXSBZYXcgQWRkIjoxNS4wLCJXYWxrW1JdIEZha2UgTGltaXQiOjYwLjAsIldhbGtbUl0gTW9kaWZpZXIgQWRkIjotMjkuMCwiV2Fsa1tSXSBZYXcgQWRkIjotMTAuMCwiYW50aWFpbV9hZGRpdGlvbmFscyI6WzEuMCwyLjBdLCJhbnRpYWltX2NvbmRpdGlvbiI6IlN0YW5kIiwiYW50aWFpbV9lbmFibGVkIjp0cnVlLCJhbnRpYWltX21hbnVhbCI6Ik9mZiIsImFudGlhaW1fbW9kZSI6MS4wLCJhbnRpYWltX3ByZXNldCI6MS4wLCJvdGhlcnNfYXNwZWN0X3JhdGlvIjp0cnVlLCJvdGhlcnNfYXNwZWN0X3JhdGlvX3ZhbHVlIjoxNS4wLCJvdGhlcnNfdmlld21vZGVsIjp0cnVlLCJvdGhlcnNfdmlld21vZGVsX2ZvdiI6NjguMCwib3RoZXJzX3ZpZXdtb2RlbF94IjowLjAsIm90aGVyc192aWV3bW9kZWxfeSI6LTkuMCwib3RoZXJzX3ZpZXdtb2RlbF96IjowLjAsInJhZ2Vib3RfaGl0bG9ncyI6dHJ1ZSwicmFnZWJvdF9oaXRsb2dzX3R5cGUiOlsyLjAsMy4wXSwic2V0dGluZ3NfZW5hYmxlZCI6dHJ1ZSwidmlzdWFsc19hY2NlbnQiOm51bGwsInZpc3VhbHNfY3VzdG9tX3Njb3BlIjp0cnVlLCJ2aXN1YWxzX2N1c3RvbV9zY29wZV9jb2xvciI6bnVsbCwidmlzdWFsc19jdXN0b21fc2NvcGVfbGVuZ3RoIjozNS4wLCJ2aXN1YWxzX2N1c3RvbV9zY29wZV9vZmZzZXQiOjE1LjAsInZpc3VhbHNfZGFtYWdlIjp0cnVlLCJ2aXN1YWxzX2luZGljYXRvcnMiOnRydWV9"
    
    local protect, config_data = pcall(function()
        json.parse(base64.decode(config))
    end), json.parse(base64.decode(config))

    if protect then
        for key, value in pairs(config_data) do
            local item = script.elements[key]

            if item then
                item:set(value)
            end
        end

        print("Succesfully imported config")
    end
end

function config.export()
    local config_data = {}

    for key, value in pairs(script.elements) do
        local item = value:get()
        
        config_data[key] = item
    end

    clipboard.set(base64.encode(json.stringify(config_data)))

    print("Succesfully exported config")
end

config.v_import = script.groups.home_config:button("                                > Import <                                 ", config.import, true)

config.v_export = script.groups.home_config:button("                                > Export <                                 ", config.export, true)

config.v_list = script.groups.home_config:list("", {"Default"})

config.v_load = script.groups.home_config:button("                                   > Load <                                  ", config.default, true)

function config.update()
    config.v_import:visibility(script.n_elements.home_tabs:get() == 2)

    config.v_export:visibility(script.n_elements.home_tabs:get() == 2)

    config.v_list:visibility(script.n_elements.home_tabs:get() == 2)

    config.v_load:visibility(script.n_elements.home_tabs:get() == 2)
end

-- @region: callbacks

events.render:set(function()
    visuals.custom_scope()
    
    visuals.indicators()

    visuals.damage()
    
    visibility.update()

    utility.sidebar()

    config.update()
    
    screen.update()
end)

events.createmove:set(function(cmd)
    antiaim.handler(cmd)

    antiaim.no_defensive()

    utility.aspect_ratio()

    utility.viewmodel()
end)

events.mouse_input:set(function()
    return not (ui.get_alpha() > 0)
end)