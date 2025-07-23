-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS



local pui = require "neverlose/pui"
local clipboard = require "neverlose/clipboard"
local base64 = require "neverlose/base64"
local bomb = require "neverlose/bomb"

ffi.cdef[[
    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);

    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef struct {
        char  pad_0000[20];
        int m_nOrder;
        int m_nSequence;
        float m_flPrevCycle;
        float m_flWeight;
        float m_flWeightDeltaRate;
        float m_flPlaybackRate;
        float m_flCycle;
        void *m_pOwner;
        char  pad_0038[4];
    } animstate_layer_t;
]]

local uintptr_t = ffi.typeof("uintptr_t**")
local get_entity_address = utils.get_vfunc("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
local animslsg = nil

math.lerp = function(a, b, t)
    return a + t * (b - a)
end

local animations = { } do
    animations.max_lerp_low_fps = (1 / 45) * 100
    animations.color_lerp = function(start, end_pos, time)
        local frametime = globals.frametime * 100
        time = time * math.min(frametime, animations.max_lerp_low_fps)
        return start:lerp(end_pos, time)
    end
    
    animations.lerp = function(start, end_pos, time)
        if start == end_pos then
            return end_pos
        end
    
        local frametime = globals.frametime * 170
        time = time * math.min(frametime, animations.max_lerp_low_fps)
    
        local val = start + (end_pos - start) * math.clamp(time, 0.01, 1)
    
        if(math.abs(val - end_pos) < 0.01) then
            return end_pos
        end
    
        return val
    end

    animations.base_speed = 0.095
    animations._list = {}

    animations.new = function(name, new_value, speed, init)
        speed = speed or animations.base_speed
        
        local is_color = type(new_value) == "userdata"

        if animations._list[name] == nil then
            animations._list[name] = (init and init) or (is_color and color(255) or 0)
        end

        local interp_func

        if is_color then
            interp_func = animations.color_lerp
        else
            interp_func = animations.lerp
        end

        animations._list[name] = interp_func(animations._list[name], new_value, speed)
        
        return animations._list[name]
    end
end

local screen_size = render.screen_size()

-- s/o shelzy1337

local drag = {
    group = ui.create("##drag"), -- поменять к чертвовой матери

    data = {},
    items = {},
    sliders = {},
    updated_data = {},
    hovered_something = false,
    black_background = 0,

    in_bounds = function(mouse_position, position, size)
        return mouse_position.x >= position.x and mouse_position.x <= position.x + size.x and mouse_position.y >= position.y and mouse_position.y <= position.y + size.y
    end,

    lerp = function(start, end_pos, time)
        time = time or 0.095
    
        if math.abs(start - end_pos) < 1 then
            return end_pos
        end
    
        time = globals.frametime * time * 120
    
        return start + (end_pos - start) * time
    end,

    limit_positions = function(position, size, ending)
        if position.x <= 0 then
            position.x = 0
        end
    
        if position.x + size.x >= ending.x - 1 then
            position.x = ending.x - size.x - 1
        end
    
        if position.y <= 0 then
            position.y = 0
        end
    
        if position.y + size.y >= ending.y - 1 then
            position.y = ending.y - size.y - 1
        end
    end
}

drag.new = function(name, box, default, rulers, border, size)
    if name == nil or type(name) ~= "string" then
        error("Name of item is invalid!")
    end

    if box == nil or type(box) ~= "number" then
        box = 0
    end

    if default == nil or type(default) ~= "userdata" then
        default = vector(0, 0)
    end

    if size == nil or type(size) ~= "userdata" then
        size = vector(0, 0)
    end

    local animations = {}

    if animations[name] == nil then
        animations[name] = {
            rulers = {},
            border = 0,
            box = 0
        }
    end

    if drag.updated_data[name] == nil then
        drag.updated_data[name] = {
            position = vector(0, 0),
            size = vector(0, 0),
            enabled = true
        }
    end

    drag.sliders[name] = {
        x = drag.group:slider("slider_x_" .. name, border and border[1].x or 0, border and border[2].x or screen_size.x, default.x),
        y = drag.group:slider("slider_y_" .. name, border and border[1].y or 0, border and border[2].y or screen_size.y, default.y),
    }

    drag.sliders[name].x:visibility(false)
    drag.sliders[name].y:visibility(false)

    return function(fn)
        events.render(function()
            local ui_alpha = ui.get_alpha()
            local mouse_position = ui.get_mouse_position()
            local is_button_down = common.is_button_down(0x01)

            drag.data[name] = {
                position = vector(drag.sliders[name].x:get(), drag.sliders[name].y:get()),
                size = size,
                enabled = true
            }

            if drag.items[name] == nil then
                drag.items[name] = {
                    position = vector(0, 0),
                    is_hovered = false
                }
            end

            if border then
                animations[name].border = drag.lerp(animations[name].border, drag.updated_data[name].enabled and drag.items[name].is_hovered and 50 or 0)

                if ui_alpha > 0 and animations[name].border > 0 then
                    render.rect_outline(border[1], border[2], color(255, ui_alpha * animations[name].border), 1, 4)
                end
            end

            local adjust_rulers = {
                x = false,
                y = false
            }

            if rulers then
                for k, v in pairs(rulers) do
                    local dist = math.abs(v[1] == "x" and v[2].x - mouse_position.x or v[2].y - mouse_position.y)
                    local allow = dist < 10

                    if allow and drag.items[name].is_hovered then
                        if v[1] == "x" then
                            adjust_rulers.x = true
                            drag.sliders[name].x:set(v[2].x - drag.updated_data[name].size.x * 0.5)
                        else
                            adjust_rulers.y = true
                            drag.sliders[name].y:set(v[2].y - drag.updated_data[name].size.y * 0.5)
                        end
                    end

                    if animations[name].rulers[k] == nil then
                        animations[name].rulers[k] = 0
                    end

                    animations[name].rulers[k] = drag.lerp(animations[name].rulers[k], drag.updated_data[name].enabled and drag.items[name].is_hovered and (allow and 150 or 50) or 0)

                    if ui_alpha > 0 and animations[name].rulers[k] > 0 then
                        render.line(v[2], v[3], color(255, ui_alpha * animations[name].rulers[k]), 1)
                    end
                end
            end

            animations[name].box = drag.lerp(animations[name].box, drag.updated_data[name].enabled and (drag.items[name].is_hovered and 75 or 25) or 0)
            
            if ui_alpha > 0 then
                if box == 1 then
                    render.rect_outline(drag.updated_data[name].position, drag.updated_data[name].position + drag.updated_data[name].size, color(255, ui_alpha * animations[name].box), 1, 4)
                elseif box == 2 then
                    render.rect(drag.updated_data[name].position, drag.updated_data[name].position + drag.updated_data[name].size, color(200, ui_alpha * animations[name].box), 4)
                    render.rect_outline(drag.updated_data[name].position, drag.updated_data[name].position + drag.updated_data[name].size, color(200, ui_alpha * animations[name].box), 1, 4)
                end
            end

            fn(drag.data[name])

            drag.updated_data[name] = drag.data[name]

            local in_bounds = drag.in_bounds(mouse_position, drag.data[name].position, drag.data[name].size)
            local on_screen = drag.in_bounds(mouse_position, vector(0, 0), screen_size)

            if drag.updated_data[name].enabled and in_bounds and on_screen and not drag.hovered_something then
                
                drag.hovered_something = true

                if is_button_down and not drag.items[name].is_hovered then
                    drag.items[name].position = drag.data[name].position - mouse_position
                    drag.items[name].is_hovered = true
                end
            end

            if not on_screen then
                drag.items[name].is_hovered = false
            end
        
            if not is_button_down then
                drag.items[name].is_hovered = false
                drag.hovered_something = false
            end

            if drag.updated_data[name].enabled and drag.items[name].is_hovered and ui_alpha > 0 then
                local current_position = vector(
                    mouse_position.x + drag.items[name].position.x,
                    mouse_position.y + drag.items[name].position.y
                )

                drag.limit_positions(current_position, drag.data[name].size, border and border[2] or screen_size) --это тоже пиздец полный, да и впринципе все здесь

                if not adjust_rulers.x then
                    drag.sliders[name].x:set(current_position.x)
                end

                if not adjust_rulers.y then
                    drag.sliders[name].y:set(current_position.y)
                end
            end
        end)
    end
end

events.render(function()
    local ui_alpha = ui.get_alpha()
    drag.black_background = drag.lerp(drag.black_background, drag.hovered_something and 125 or 0)

    if ui_alpha > 0 and drag.black_background > 0 then
        render.rect(vector(0, 0), screen_size, color(0, ui_alpha * drag.black_background), 0) 
    end
end)

local refs = {
    pitch = pui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    yaw = pui.find("Aimbot", "Anti Aim", "Angles", "Yaw", {
        base = "Base",
        offset = "Offset",
        avoid_backstab = "Avoid Backstab",
        hidden = "Hidden"
    }),
    yaw_modifier = pui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", {
        offset = "Offset"
    }),
    body_yaw = pui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", {
        inverter = "Inverter",
        left_limit = "Left Limit",
        right_limit = "Right Limit",
        options = "Options",
        freestanding = "Freestanding"
    }),
    freestanding = pui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", {
        disable_yaw_modifiers = "Disable Yaw Modifiers",
        body_freestanding = "Body Freestanding"
    }),
    slow_walk = pui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    fake_duck = pui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    legs_movement = pui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    lag_options = pui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
    hide_shots_options = pui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
    scope_overlay = pui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"),
    doubletap = pui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    hide_shots = pui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    minimum_damage = pui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
    field_of_view = ui.find("Visuals", "World", "Main", "Field of View"),
    override_zoom = pui.find("Visuals", "World", "Main", "Override Zoom", {
        force_viewmodel = "Force Viewmodel",
        scope_overlay = "Scope Overlay"
    }),
    fake_latency = pui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
    air_strafe = pui.find("Miscellaneous", "Main", "Movement", "Air Strafe"),
    pistols_hitchance = pui.find("Aimbot", "Ragebot", "Selection", "Pistols", "Hit Chance"),
    auto_snipers_hitchance = pui.find("Aimbot", "Ragebot", "Selection", "AutoSnipers", "Hit Chance"),
    awp_hitchance = pui.find("Aimbot", "Ragebot", "Selection", "AWP", "Hit Chance"),
    ssg08_hitchance = pui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Hit Chance"),
    revolver_hitchance = pui.find("Aimbot", "Ragebot", "Selection", "R8 Revolver", "Hit Chance"),
    body_aim = ui.find("Aimbot", "Ragebot", "Safety", "SSG-08", "Body Aim"),
    safe_point = ui.find("Aimbot", "Ragebot", "Safety", "SSG-08", "Safe Points"),
    dormant_aimbot = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
    weapon_actions = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions")
}

local sidebar = pui.sidebar("\vNyaHook", "paw")

local menu = { } do
    menu.icon_text = function(icon, text, color)
        icon = icon and ui.get_icon(icon) or ""
        text = text or ""
        color = color or "\v"

        local dst_start = ""
        local dst_end = ""
        local icon_size = render.measure_text(1, nil, icon).x

        local width = 12 - (icon_size * 0.5)
        width = (math.floor(width + 0.5) - 2)

        if math.fmod(icon_size, 2) ~= 0 then
            dst_end = " "
            width = width - 1
        end

        for i = 1, width do
            dst_end = dst_end .. " "
        end

        return color .. icon .. "\aDEFAULT" .. dst_end .. "" .. text
    end

    menu.tabs = {
        home = {
            nyahook = pui.create("\f<house-night>", "##nyahook", 1),
            under_nyahook = pui.create("\f<house-night>", "##under_nyahook", 1),
            under_nyahook_2 = pui.create("\f<house-night>", "##under_nyahook_2", 1),
            image = pui.create("\f<house-night>", "##image", 2)
        },
        anti_aim = {
            left_branch = pui.create("\f<user-shield>", "##left_branch", 1),
            left_builder_state = pui.create("\f<user-shield>", "##left_builder_state", 1),
            left_builder = pui.create("\f<user-shield>", "##left_builder", 1),
            left_builder_2 = pui.create("\f<user-shield>", "##left_builder_2", 1),
            left_builder_3 = pui.create("\f<user-shield>", "##left_builder_3", 1),
            left_builder_presets = pui.create("\f<user-shield>", "##left_builder_presets", 1),
            right_builder_branch = pui.create("\f<user-shield>", "##right_builder_branch", 2),
            right_builder = pui.create("\f<user-shield>", "##right_builder", 2),
            right_builder_down = pui.create("\f<user-shield>", "##right_builder_down", 2),
            right_builder_down_2 = pui.create("\f<user-shield>", "##right_builder_down_2", 2),
            right_builder_down_3 = pui.create("\f<user-shield>", "##right_builder_down_3", 2),
            right_enhancements = pui.create("\f<user-shield>", "##right_enhancements", 2)
        },
        other = {
            select_tab = pui.create("\f<gears>", "##select_tab", 1),
            right_visuals_on_screen = pui.create("\f<gears>", "##right_visuals_on_screen", 2),
            left_visuals_widgets = pui.create("\f<gears>", "##left_visuals_widgets", 1),
            right_visuals_modifications = pui.create("\f<gears>", "##right_visuals_modifications", 2),
            right_misc_in_game = pui.create("\f<gears>", "##right_misc_in_game", 2),
            right_misc_ragebot = pui.create("\f<gears>", "##right_misc_ragebot", 2),
            left_misc_movement = pui.create("\f<gears>", "##left_misc_movement", 1),
            left_misc_other = pui.create("\f<gears>", "##left_misc_other", 1),
            right_configs = pui.create("\f<gears>", "##right_configs", 2),
        }
    }

    menu.home = 
    {
        select_tab = menu.tabs.other.select_tab:list("\n", {"Visuals", "Misc"}),

        welcome = menu.tabs.home.nyahook:label("Welcome to the \vDebug\r version of \vNyaHook\r!"),

        user = menu.tabs.home.under_nyahook:label(menu.icon_text("hand-wave", "Welcome back, \v" .. common.get_username())),
        current_build = menu.tabs.home.under_nyahook:label(menu.icon_text("rectangle-terminal", "Current build: \vDebug")),

        socials = menu.tabs.home.under_nyahook_2:label(menu.icon_text("square-share-nodes", "Socials")),
        discord_server = menu.tabs.home.under_nyahook_2:button("\aC0BCFFFF\f<discord>\r", function() 
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/fastleaks")
        end, true),
        youtube = menu.tabs.home.under_nyahook_2:button("\aFF6A6AFF\f<youtube>\r", function() 
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@zordside")
        end, true),
        warning = menu.tabs.home.under_nyahook_2:label(menu.icon_text("paw", "Be blessed with \vNyaHook\r!")),
    }

    menu.anti_aim_conditions = 
    {
        "Shared",
        "Standing", 
        "Moving", 
        "Air", 
        "Air Crouching", 
        "Crouching", 
        "Crouching Moving", 
        "Slow Walking",
        "Freestanding",
        "Manual Yaw",
    }

    menu.anti_aim =
    {
        branch = menu.tabs.anti_aim.right_builder_branch:list("##branch", {"State Builder", "Defensive Builder"}),
        manual_yaw = menu.tabs.anti_aim.left_builder:combo(menu.icon_text("arrows-repeat", "Manual Yaw"), {"Disabled", "Left", "Right", "Forward"}, function(gear)
            return 
            {
                manual_over_fs = gear:switch("Manual Over FS")
            }
        end),
        freestanding = menu.tabs.anti_aim.left_builder:switch(menu.icon_text("arrows-turn-to-dots", "Freestanding"), false, function(gear)
            return 
            {
                disable_yaw_modifiers = gear:switch("Disable Yaw Modifiers"),
                body_freestanding = gear:switch("Body Freestanding"),
            }
        end),
        edge_yaw = menu.tabs.anti_aim.left_builder_2:switch(menu.icon_text("compass-drafting", "Edge Yaw"), false, function(gear)
            return 
            {
                ignore_manuals = gear:switch("Ignore Manuals")
            }
        end),
        avoid_backstab = menu.tabs.anti_aim.left_builder_2:switch(menu.icon_text("scalpel-line-dashed", "Avoid Backstab")),
        safe_head = menu.tabs.anti_aim.left_builder_2:switch(menu.icon_text("compress", "Safe Head"), false, function(gear)
            return 
            {
                triggers = gear:selectable("Triggers", {"Knife", "Taser", "Above Enemy"}),
                height_difference = gear:slider("Height Difference", 30, 180, 80)
            }
        end),
        disablers = menu.tabs.anti_aim.left_builder_2:selectable(menu.icon_text("circle-xmark", "Disablers"), {"On Warmup", "On Round End"}),
        force_defensive = menu.tabs.anti_aim.left_builder_3:selectable(menu.icon_text("shield", "Force Defensive"), {select(2, table.unpack(menu.anti_aim_conditions))}, function(gear)
            return
            {
                method = gear:list("\n", {"Default", "Custom", "Random"}),
                always_on = gear:switch("Always On"),
                custom_ticks = gear:slider("Ticks", 1, 30, 0, 1, "t"),
                random_ticks_first = gear:slider("First Value", 1, 30, 0, 1, "t"),
                random_ticks_second = gear:slider("Second Value", 1, 30, 0, 1, "t"),
            }
        end),
        flick_exploit = menu.tabs.anti_aim.left_builder_3:switch(menu.icon_text("shuffle", "Flick Exploit"), false, function(gear)
            return 
            {
                inverter = gear:switch("Inverter")  
            }
        end),
        lag_exploit = menu.tabs.anti_aim.left_builder_3:switch(menu.icon_text("person-circle-exclamation", "Lag Exploit"), false, function(gear)
            return 
            {
                ticks = gear:slider("Ticks", 1, 32, 16, 1, "t")
            }
        end),
        
        current_state = menu.tabs.anti_aim.left_builder_state:combo(menu.icon_text("chart-pyramid", "Current State"), menu.anti_aim_conditions),
        preset_manager = { },
        builder = { }
    }

    menu.anti_aim.tooltips = 
    {
        menu.anti_aim.flick_exploit:tooltip("Works only on slow-walk! \n \n • This feature is flicking your head in the opposite direction by using defensive mechanics and allowing you to be impenetrable. \n \n • Make sure that the slow-walk in cheat is binded.")
    }

    for i = 1, #menu.anti_aim_conditions do
        menu.anti_aim.builder[i] = 
        {
            enable_state = menu.tabs.anti_aim.left_builder_state:switch("Override \v" .. menu.anti_aim_conditions[i]),
            yaw_amount = menu.tabs.anti_aim.right_builder_down:slider(menu.icon_text("arrows-left-right", "Yaw"), -180, 180, 0, 1, "°", false, function(gear)
                return {
                    add_left_yaw = gear:slider(menu.icon_text("left-long", "Add Left"), -180, 180, 0, 1, "°"),
                    add_right_yaw = gear:slider(menu.icon_text("right-long", "Add Right"), -180, 180, 0, 1, "°")
                }
            end),
            yaw_randomize = menu.tabs.anti_aim.right_builder_down:slider(menu.icon_text("arrow-trend-down", "Randomize"), 0, 100, 0, 1, function(value)
                return value == 0 and "Off" or string.format("%s%%", value)
            end),
            yaw_fluctation = menu.tabs.anti_aim.right_builder_down:slider(menu.icon_text("arrow-up-square-triangle", "Fluctation"), 0, 100, 0, 1, false, function(gear)
                return {
                    fluctation_phase_time = gear:slider("Phase Time", 0, 100, 0, 1),
                    fluctation_delay_1 = gear:slider("Phase Delay [1]", 0, 100, 0, 1),
                    fluctation_delay_2 = gear:slider("Phase Delay [2]", 0, 100, 0, 1),
                    fluctation_delay_3 = gear:slider("Phase Delay [3]", 0, 100, 0, 1)
                }
            end),
            yaw_jitter = menu.tabs.anti_aim.right_builder_down_2:combo(menu.icon_text("arrows-spin", "Yaw Modifier"), {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"}, function()
                return 
                {
                    amount = menu.tabs.anti_aim.right_builder_down_2:slider(menu.icon_text("arrow-up-wide-short", "Amount"), -180, 180, 0, 1, "°"),
                    randomize = menu.tabs.anti_aim.right_builder_down_2:slider(menu.icon_text("arrow-trend-up", "Randomize"), 0, 100, 0, 1, function(value)
                        return value == 0 and "Off" or string.format("%s%%", value)
                    end),
                }
            end),
            fake_limit = menu.tabs.anti_aim.right_builder_down_3:slider(menu.icon_text("angle-90", "Fake Limit"), 0, 60, 60, 1, "°"),
            fake_limit_randomize = menu.tabs.anti_aim.right_builder_down_3:slider(menu.icon_text("arrow-trend-down", "Randomize"), 0, 100, 0, 1, function(value)
                return value == 0 and "Off" or string.format("%s%%", value)
            end),
            body_jitter = menu.tabs.anti_aim.right_builder_down_3:switch(menu.icon_text("spinner", "Body Jitter"), false, function(gear)
                return {
                    body_jitter_switch_method = gear:combo(menu.icon_text("stack-overflow", "Method"), {"Default", "Progressive"}),
                    body_jitter_switch_ticks = gear:slider(menu.icon_text("arrow-down-short-wide", "Switch Ticks"), 2, 10, 1, 1, function(value)
                        return value == 2 and "Off" or string.format("%st", value)
                    end),
                    body_jitter_switch_minimum = gear:slider(menu.icon_text("arrow-down-short-wide", "Min. Value"), 2, 10, 1, 1, "t"),
                    body_jitter_switch_maximum = gear:slider(menu.icon_text("arrow-up-wide-short", "Max. Value"), 2, 10, 1, 1, "t"),
                    body_jitter_randomize_switch = gear:slider(menu.icon_text("arrow-trend-up", "Randomize"), 2, 10, 1, 1, function(value)
                        return value == 2 and "Off" or string.format("%st", value)
                    end),
                }
            end),
            
            defensive_aa = menu.tabs.anti_aim.right_builder_down:switch(menu.icon_text("eye-slash", "Defensive")),
            
            pitch = menu.tabs.anti_aim.right_builder_down_2:combo(menu.icon_text("arrow-up-from-square", "Pitch"), {"Disabled", "Down", "Up", "Random", "Custom"}),
            pitch_random_first = menu.tabs.anti_aim.right_builder_down_2:slider(menu.icon_text("arrow-up-short-wide", "Random First"), -89, 89, 0),
            pitch_random_second = menu.tabs.anti_aim.right_builder_down_2:slider(menu.icon_text("arrow-up-wide-short", "Random Second"), -89, 89, 0),
            pitch_custom = menu.tabs.anti_aim.right_builder_down_2:slider(menu.icon_text("arrow-up-square-triangle", "Custom"), -89, 89, 0),
            
            yaw = menu.tabs.anti_aim.right_builder_down_3:combo(menu.icon_text("arrow-up-right-and-arrow-down-left-from-center", "Yaw\n"), {"Hidden", "L&R\n", "Forward", "Sideways", "Random\n", "Spin", "Custom\n"}),
            defensive_yaw_left_amount = menu.tabs.anti_aim.right_builder_down_3:slider(menu.icon_text("left-long", "Left Amount\n"), -180, 180, 0, 1, "°"),
            defensive_yaw_right_amount = menu.tabs.anti_aim.right_builder_down_3:slider(menu.icon_text("right-long", "Right Amount\n"), -180, 180, 0, 1, "°"),
            defensive_yaw_delay = menu.tabs.anti_aim.right_builder_down_3:slider(menu.icon_text("arrow-down-short-wide", "Delay\n"), 2, 10, 1, 1, function(value)
                return value == 2 and "Off" or string.format("%st", value)
            end),
            yaw_random_first = menu.tabs.anti_aim.right_builder_down_3:slider(menu.icon_text("arrow-up-short-wide", "Random First\n"), -180, 180, 0),
            yaw_random_second = menu.tabs.anti_aim.right_builder_down_3:slider(menu.icon_text("arrow-up-wide-short", "Random Second\n"), -180, 180, 0),
            yaw_spin_speed = menu.tabs.anti_aim.right_builder_down_3:slider(menu.icon_text("arrows-retweet", "Spin Speed"), 1, 30, 1),
            yaw_custom = menu.tabs.anti_aim.right_builder_down_3:slider(menu.icon_text("arrow-up-square-triangle", "Custom\n"), -180, 180, 0),
        }
    end

    menu.visuals = 
    {
        centered_indicators = menu.tabs.other.right_visuals_on_screen:switch(menu.icon_text("list-check", "Centered Indicators"), false, function(gear)
            return 
            {
                offset = gear:slider("Offset", 0, 100, 15),
                centered_indicators_color = gear:color_picker("Color", color(255, 180, 226, 255)),
            }
        end),
        gamesense_indicators = menu.tabs.other.right_visuals_on_screen:switch(menu.icon_text("list-dropdown", "Game\a00FF00FFSense\r Indicators"), false, function(gear)
            return 
            {
                style = gear:combo("Style", {"Classic", "Modern"}),
                select = gear:selectable("Select", {"Double Tap", "Hide Shots", "Fake Latency", "Min. Damage Override", "Body Aim", "Force Safe Point", "Freestanding", "Dormant Aimbot", "Bomb Information", "Hit/Miss Rate"}),
                animated = gear:switch("Animated")
            }
        end),
        manual_arrows = menu.tabs.other.right_visuals_on_screen:switch(menu.icon_text("code-simple", "Manual Arrows"), false, function(gear)
            return 
            {
                offset = gear:slider("Offset", 0, 100, 30),
                arrows_style = gear:combo("Style", {"Classic", "Modern"}),
                arrows_color = gear:color_picker("Color", color(255, 180, 226, 255)),
            }
        end),
        damage_indicator = menu.tabs.other.right_visuals_on_screen:switch(menu.icon_text("arrow-down-9-1", "Damage Indicator"), false, function(gear)
            return 
            {
                font = gear:combo("Font", {"Default", "Pixel", "Bold"})
            }
        end),
        custom_scope_overlay = menu.tabs.other.right_visuals_on_screen:switch(menu.icon_text("binoculars", "Custom Scope Overlay"), false, function(gear)
            return 
            {
                size = gear:slider("Size", 0, 300, 100),
                gap = gear:slider("Gap", 0, 300, 5),
                inverted = gear:switch("Inverted"),
                t_pose = gear:switch("T Pose"),
                scope_color = gear:color_picker("Color", color(170, 170, 170, 255)),
                viewmodel_in_scope = gear:switch("Viewmodel In Scope"),
            }
        end),
        watermark = menu.tabs.other.left_visuals_widgets:switch(menu.icon_text("table-pivot", "Watermark"), false, function(gear)
            return 
            {
                style = gear:combo("Style", {"Classic", "Modern", "Minimalistic"}),
                watermark_color = gear:color_picker("Color", color())
            }
        end),
        keybinds = menu.tabs.other.left_visuals_widgets:switch(menu.icon_text("keyboard", "Keybinds"), false, function(gear)
            return 
            {
                keybinds_color = gear:color_picker("Color", color())
            }
        end),
        spectators = menu.tabs.other.left_visuals_widgets:switch(menu.icon_text("eye", "Spectators"), false, function(gear)
            return 
            {
                spectators_color = gear:color_picker("Color", color())
            }
        end),
        velocity_indicator = menu.tabs.other.left_visuals_widgets:switch(menu.icon_text("gauge-min", "Velocity"), false, function(gear)
            return 
            {
                velocity_indicator_color = gear:color_picker("Color", color(255, 180, 226, 255))
            }
        end),
        hitmarker = menu.tabs.other.left_visuals_widgets:switch(menu.icon_text("xmark-large", "Hitmarker"), false, function(gear)
            return 
            {
                hitmarker_color = gear:color_picker("Color", color(255))
            }
        end),
        animated_zoom = menu.tabs.other.right_visuals_modifications:switch(menu.icon_text("magnifying-glass-plus", "Animated Zoom")),
        client_side_animations = menu.tabs.other.right_visuals_modifications:switch(menu.icon_text("layer-group", "Client-Side Animations"), false, function(gear)
            return 
            {
                ground_legs = gear:combo("Ground Legs", {"Disabled", "Reversed", "Jitter", "Moonwalk"}),
                air_legs = gear:combo("Air Legs", {"Disabled", "Static", "Jitter", "Moonwalk"}),
                addons = gear:selectable("Addons", {"Move Lean", "Earthquake", "Pitch Zero On Land"}),
                move_lean_amount = gear:slider("Move Lean Amount", 0, 100, 0, 1, "%")
            }
        end),
        grenade_warning = menu.tabs.other.right_visuals_modifications:switch(menu.icon_text("triangle-exclamation", "Grenade Warning"))
    }

    menu.misc = 
    {
        in_game = {
            trashtalk = menu.tabs.other.right_misc_in_game:switch(menu.icon_text("face-pouting", "Trashtalk")),
            clantag = menu.tabs.other.right_misc_in_game:switch(menu.icon_text("tag", "Clantag")),
            aspect_ratio = menu.tabs.other.right_misc_in_game:switch(menu.icon_text("screencast", "Aspect Ratio"), false, function(gear)
                return 
                {
                    ratio = gear:slider("Ratio", 0, 200, 0, 0.01),
                    button_16_10 = gear:button("16:10", function()
                        menu.misc.in_game.aspect_ratio.ratio:set(160)
                    end, true),
                    button_16_9 = gear:button("16:9", function()
                        menu.misc.in_game.aspect_ratio.ratio:set(180)
                    end, true),
                    button_5_4 = gear:button("5:4", function()
                        menu.misc.in_game.aspect_ratio.ratio:set(125)
                    end, true),
                    button_4_3 = gear:button("4:3", function()
                        menu.misc.in_game.aspect_ratio.ratio:set(133)
                    end, true),
                    button_3_2 = gear:button("3:2", function()
                        menu.misc.in_game.aspect_ratio.ratio:set(150)
                    end, true)
                }
            end),
            viewmodel_changer = menu.tabs.other.right_misc_in_game:switch(menu.icon_text("hand", "Viewmodel Changer"), false, function(gear)
                return 
                {
                    viewmodel_fov = gear:slider("Fov", -10000, 10000, 6800, 0.01),
                    viewmodel_x = gear:slider("X", -1000, 1000, 250, 0.01),
                    viewmodel_y = gear:slider("Y", -2000, 2000, 0, 0.01),
                    viewmodel_z = gear:slider("Z", -1000, 1000, -150, 0.01),
                    viewmodel_reset = gear:button("Reset", function()
                        menu.misc.in_game.viewmodel_changer.viewmodel_fov:set(6800)
                        menu.misc.in_game.viewmodel_changer.viewmodel_x:set(250)
                        menu.misc.in_game.viewmodel_changer.viewmodel_y:set(0)
                        menu.misc.in_game.viewmodel_changer.viewmodel_z:set(-150)
                    end, true)
                }
            end),
            keep_model_transparency = menu.tabs.other.right_misc_in_game:switch(menu.icon_text("face-dotted", "Keep Model Transparency")),
        },
        movement = {
            no_fall_damage = menu.tabs.other.left_misc_movement:switch(menu.icon_text("person-falling-burst", "No Fall Damage")),
            fast_ladder = menu.tabs.other.left_misc_movement:switch(menu.icon_text("water-ladder", "Fast Ladder")),
            edge_stop = menu.tabs.other.left_misc_movement:switch(menu.icon_text("arrow-down-up-lock", "Edge Stop")),
            jump_scout = menu.tabs.other.left_misc_movement:switch(menu.icon_text("person-ski-jumping", "Jump Scout")),
            super_toss = menu.tabs.other.left_misc_movement:switch(menu.icon_text("sensor-fire", "Super Toss")),
        },
        ragebot = {
            aimbot_logs = menu.tabs.other.right_misc_ragebot:switch(menu.icon_text("right-to-bracket", "Aimbot Logs"), false, function(gear)
                return 
                {
                    output = gear:selectable("Output", {"Console", "Event", "Notify"}),
                    purchase_logs = gear:switch("Purchase Logs"),
                    hit_color = gear:color_picker("Hit Color", color(0, 255, 0, 255)),
                    miss_color = gear:color_picker("Miss Color", color(230, 150, 150, 255)),
                    push_notify_log = gear:button("Push Notify Log", function() end, true)
                }
            end),
            fake_latency = menu.tabs.other.right_misc_ragebot:slider(menu.icon_text("signal-bars", "Fake Latency"), 0, 300, 0, 1, "ms"),
            hitchance = menu.tabs.other.right_misc_ragebot:switch(menu.icon_text("person-rifle", "Hitchance"), false, function(gear)
                return 
                {
                    current_weapon = gear:list("\n", {"Pistols", "Auto-Snipers", "Awp", "SSG-08", "R8 Revolver"}),
                    enable_pistols = gear:switch("Override \vPistols", false),
                    pistols_air_amount = gear:slider("In-Air", 0, 100, 0, 1, "%"),
                    enable_auto_snipers = gear:switch("Override \vAuto-Snipers", false),
                    auto_snipers_no_scope_amount = gear:slider("No-Scope", 0, 100, 0, 1, "%"),
                    auto_snipers_air_amount = gear:slider("In-Air", 0, 100, 0, 1, "%"),
                    enable_awp = gear:switch("Override \vAwp", false),
                    awp_no_scope_amount = gear:slider("No-Scope", 0, 100, 0, 1, "%"),
                    awp_air_amount = gear:slider("In-Air", 0, 100, 0, 1, "%"),
                    enable_ssg08 = gear:switch("Override \vSSG-08", false),
                    ssg08_no_scope_amount = gear:slider("No-Scope", 0, 100, 0, 1, "%"),
                    ssg08_air_amount = gear:slider("In-Air", 0, 100, 0, 1, "%"),
                    enable_revolver = gear:switch("Override \vR8 Revolver", false),
                    revolver_air_amount = gear:slider("In-Air", 0, 100, 0, 1, "%"),
                }
            end),
            grenade_throw_fix = menu.tabs.other.right_misc_ragebot:switch(menu.icon_text("bomb", "Grenade Throw Fix")),
            decrease_hold_aim_ticks = menu.tabs.other.left_misc_other:switch(menu.icon_text("person-burst", "Decrease Hold Aim Ticks")),
        }
    }

    depend = 
    {
        anti_aim_depend = 
        {
            menu.anti_aim.force_defensive.method:depend( menu.anti_aim.force_defensive ),
            menu.anti_aim.force_defensive.always_on:depend( menu.anti_aim.force_defensive, { menu.anti_aim.force_defensive.method, 1 } ),
            menu.anti_aim.force_defensive.custom_ticks:depend( menu.anti_aim.force_defensive, { menu.anti_aim.force_defensive.method, 2 } ),
            menu.anti_aim.force_defensive.random_ticks_first:depend( menu.anti_aim.force_defensive, { menu.anti_aim.force_defensive.method, 3 } ),
            menu.anti_aim.force_defensive.random_ticks_second:depend( menu.anti_aim.force_defensive, { menu.anti_aim.force_defensive.method, 3 } ),
            
            menu.anti_aim.flick_exploit.inverter:depend( menu.anti_aim.flick_exploit ),

            menu.anti_aim.lag_exploit.ticks:depend( menu.anti_aim.lag_exploit ),

            menu.anti_aim.safe_head.triggers:depend(menu.anti_aim.safe_head),
            menu.anti_aim.safe_head.height_difference:depend(menu.anti_aim.safe_head, { menu.anti_aim.safe_head.triggers, "Above Enemy" }),

            menu.anti_aim.edge_yaw.ignore_manuals:depend(menu.anti_aim.edge_yaw),
        },
        visuals_depend = 
        {
            menu.visuals.centered_indicators:depend({ menu.home.select_tab, 1 }),
            menu.visuals.centered_indicators.offset:depend( menu.visuals.centered_indicators ),
            menu.visuals.centered_indicators.centered_indicators_color:depend( menu.visuals.centered_indicators ),

            menu.visuals.gamesense_indicators:depend({ menu.home.select_tab, 1 }),
            menu.visuals.gamesense_indicators.style:depend( menu.visuals.gamesense_indicators ),
            menu.visuals.gamesense_indicators.select:depend( menu.visuals.gamesense_indicators ),
            menu.visuals.gamesense_indicators.animated:depend( menu.visuals.gamesense_indicators ),

            menu.visuals.manual_arrows:depend({ menu.home.select_tab, 1 }),
            menu.visuals.manual_arrows.arrows_style:depend( menu.visuals.manual_arrows ),
            menu.visuals.manual_arrows.arrows_color:depend( menu.visuals.manual_arrows ),
            menu.visuals.manual_arrows.offset:depend( menu.visuals.manual_arrows ),

            menu.visuals.damage_indicator:depend({ menu.home.select_tab, 1 }),
            menu.visuals.damage_indicator.font:depend( menu.visuals.damage_indicator ),

            menu.visuals.custom_scope_overlay:depend({ menu.home.select_tab, 1 }),
            menu.visuals.custom_scope_overlay.size:depend( menu.visuals.custom_scope_overlay ),
            menu.visuals.custom_scope_overlay.gap:depend( menu.visuals.custom_scope_overlay ),
            menu.visuals.custom_scope_overlay.inverted:depend( menu.visuals.custom_scope_overlay ),
            menu.visuals.custom_scope_overlay.t_pose:depend( menu.visuals.custom_scope_overlay ),
            menu.visuals.custom_scope_overlay.scope_color:depend( menu.visuals.custom_scope_overlay ),
            menu.visuals.custom_scope_overlay.viewmodel_in_scope:depend( menu.visuals.custom_scope_overlay ),

            menu.visuals.hitmarker:depend({ menu.home.select_tab, 1 }),
            menu.visuals.hitmarker.hitmarker_color:depend( menu.visuals.hitmarker ),

            menu.visuals.watermark:depend({ menu.home.select_tab, 1 }),
            menu.visuals.watermark.style:depend( menu.visuals.watermark ),
            menu.visuals.watermark.watermark_color:depend( menu.visuals.watermark ),

            menu.visuals.keybinds:depend({ menu.home.select_tab, 1 }),
            menu.visuals.keybinds.keybinds_color:depend( menu.visuals.keybinds ),

            menu.visuals.spectators:depend({ menu.home.select_tab, 1 }),
            menu.visuals.spectators.spectators_color:depend( menu.visuals.spectators ),

            menu.visuals.velocity_indicator:depend({ menu.home.select_tab, 1 }),
            menu.visuals.velocity_indicator.velocity_indicator_color:depend( menu.visuals.velocity_indicator ),

            menu.visuals.animated_zoom:depend({ menu.home.select_tab, 1 }),

            menu.visuals.client_side_animations:depend({ menu.home.select_tab, 1 }),
            menu.visuals.client_side_animations.ground_legs:depend( menu.visuals.client_side_animations ),
            menu.visuals.client_side_animations.air_legs:depend( menu.visuals.client_side_animations ),
            menu.visuals.client_side_animations.addons:depend( menu.visuals.client_side_animations ),
            menu.visuals.client_side_animations.move_lean_amount:depend( menu.visuals.client_side_animations, { menu.visuals.client_side_animations.addons, "Move Lean" } ),

            menu.visuals.grenade_warning:depend({ menu.home.select_tab, 1 }),
        },
        misc_depend = 
        {
            menu.misc.in_game.trashtalk:depend({ menu.home.select_tab, 2 }),

            menu.misc.in_game.clantag:depend({ menu.home.select_tab, 2 }),

            menu.misc.in_game.aspect_ratio:depend({ menu.home.select_tab, 2 }),
            menu.misc.in_game.aspect_ratio.ratio:depend( menu.misc.in_game.aspect_ratio ),
            menu.misc.in_game.aspect_ratio.button_16_10:depend( menu.misc.in_game.aspect_ratio ),
            menu.misc.in_game.aspect_ratio.button_16_9:depend( menu.misc.in_game.aspect_ratio ),
            menu.misc.in_game.aspect_ratio.button_5_4:depend( menu.misc.in_game.aspect_ratio ),
            menu.misc.in_game.aspect_ratio.button_4_3:depend( menu.misc.in_game.aspect_ratio ),
            menu.misc.in_game.aspect_ratio.button_3_2:depend( menu.misc.in_game.aspect_ratio ),

            menu.misc.in_game.viewmodel_changer:depend({ menu.home.select_tab, 2 }),
            menu.misc.in_game.viewmodel_changer.viewmodel_fov:depend( menu.misc.in_game.viewmodel_changer ),
            menu.misc.in_game.viewmodel_changer.viewmodel_x:depend( menu.misc.in_game.viewmodel_changer ),
            menu.misc.in_game.viewmodel_changer.viewmodel_y:depend( menu.misc.in_game.viewmodel_changer ),
            menu.misc.in_game.viewmodel_changer.viewmodel_z:depend( menu.misc.in_game.viewmodel_changer ),
            menu.misc.in_game.viewmodel_changer.viewmodel_reset:depend( menu.misc.in_game.viewmodel_changer ),

            menu.misc.in_game.keep_model_transparency:depend({ menu.home.select_tab, 2 }),

            menu.misc.movement.no_fall_damage:depend({ menu.home.select_tab, 2 }),
            menu.misc.movement.fast_ladder:depend({ menu.home.select_tab, 2 }),
            menu.misc.movement.edge_stop:depend({ menu.home.select_tab, 2 }),
            menu.misc.movement.jump_scout:depend({ menu.home.select_tab, 2 }),
            menu.misc.movement.super_toss:depend({ menu.home.select_tab, 2 }),

            menu.misc.ragebot.aimbot_logs:depend({ menu.home.select_tab, 2 }),
            menu.misc.ragebot.aimbot_logs.output:depend( menu.misc.ragebot.aimbot_logs ),
            menu.misc.ragebot.aimbot_logs.hit_color:depend( menu.misc.ragebot.aimbot_logs ),
            menu.misc.ragebot.aimbot_logs.miss_color:depend( menu.misc.ragebot.aimbot_logs ),
            menu.misc.ragebot.aimbot_logs.purchase_logs:depend( menu.misc.ragebot.aimbot_logs ),
            menu.misc.ragebot.aimbot_logs.push_notify_log:depend( menu.misc.ragebot.aimbot_logs, { menu.misc.ragebot.aimbot_logs.output, "Notify" } ),

            menu.misc.ragebot.fake_latency:depend({ menu.home.select_tab, 2 }),

            menu.misc.ragebot.hitchance:depend({ menu.home.select_tab, 2 }),

            menu.misc.ragebot.hitchance.current_weapon:depend(menu.misc.ragebot.hitchance),

            menu.misc.ragebot.hitchance.enable_pistols:depend(menu.misc.ragebot.hitchance, {menu.misc.ragebot.hitchance.current_weapon, 1}),
            menu.misc.ragebot.hitchance.enable_auto_snipers:depend(menu.misc.ragebot.hitchance, {menu.misc.ragebot.hitchance.current_weapon, 2}),
            menu.misc.ragebot.hitchance.enable_awp:depend(menu.misc.ragebot.hitchance, {menu.misc.ragebot.hitchance.current_weapon, 3}),
            menu.misc.ragebot.hitchance.enable_ssg08:depend(menu.misc.ragebot.hitchance, {menu.misc.ragebot.hitchance.current_weapon, 4}),
            menu.misc.ragebot.hitchance.enable_revolver:depend(menu.misc.ragebot.hitchance, {menu.misc.ragebot.hitchance.current_weapon, 5}),

            menu.misc.ragebot.hitchance.pistols_air_amount:depend(menu.misc.ragebot.hitchance, {menu.misc.ragebot.hitchance.current_weapon, 1}, menu.misc.ragebot.hitchance.enable_pistols),

            menu.misc.ragebot.hitchance.auto_snipers_air_amount:depend(menu.misc.ragebot.hitchance, {menu.misc.ragebot.hitchance.current_weapon, 2}, menu.misc.ragebot.hitchance.enable_auto_snipers),
            menu.misc.ragebot.hitchance.auto_snipers_no_scope_amount:depend(menu.misc.ragebot.hitchance, {menu.misc.ragebot.hitchance.current_weapon, 2}, menu.misc.ragebot.hitchance.enable_auto_snipers),

            menu.misc.ragebot.hitchance.awp_air_amount:depend(menu.misc.ragebot.hitchance, {menu.misc.ragebot.hitchance.current_weapon, 3}, menu.misc.ragebot.hitchance.enable_awp),
            menu.misc.ragebot.hitchance.awp_no_scope_amount:depend(menu.misc.ragebot.hitchance, {menu.misc.ragebot.hitchance.current_weapon, 3}, menu.misc.ragebot.hitchance.enable_awp),

            menu.misc.ragebot.hitchance.ssg08_air_amount:depend(menu.misc.ragebot.hitchance, {menu.misc.ragebot.hitchance.current_weapon, 4}, menu.misc.ragebot.hitchance.enable_ssg08),
            menu.misc.ragebot.hitchance.ssg08_no_scope_amount:depend(menu.misc.ragebot.hitchance, {menu.misc.ragebot.hitchance.current_weapon, 4}, menu.misc.ragebot.hitchance.enable_ssg08),

            menu.misc.ragebot.hitchance.revolver_air_amount:depend(menu.misc.ragebot.hitchance, {menu.misc.ragebot.hitchance.current_weapon, 5}, menu.misc.ragebot.hitchance.enable_revolver),

            menu.misc.ragebot.grenade_throw_fix:depend({ menu.home.select_tab, 2 }),

            menu.misc.ragebot.decrease_hold_aim_ticks:depend({ menu.home.select_tab, 2 }),
        }
    }
    
    for i = 1, #menu.anti_aim_conditions do
        enaa = {menu.anti_aim.builder[i].enable_state, function() if(i == 1) then return true else return menu.anti_aim.builder[i].enable_state:get() end end}
    
        menu.anti_aim.builder[i].enable_state:depend( { menu.anti_aim.branch, function() return menu.anti_aim.branch.value ~= 3 end }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, { menu.anti_aim.current_state, function() return menu.anti_aim.current_state.value ~= "Shared" end } )
        -- menu.anti_aim.builder[i].state_label:depend( { menu.anti_aim.branch, function() return menu.anti_aim.branch.value ~= 3 end }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] } )
        menu.anti_aim.builder[i].yaw_amount:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, enaa )
        menu.anti_aim.builder[i].yaw_amount.add_left_yaw:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, enaa )
        menu.anti_aim.builder[i].yaw_amount.add_right_yaw:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, enaa )
        menu.anti_aim.builder[i].yaw_randomize:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, enaa )
        menu.anti_aim.builder[i].yaw_fluctation:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, enaa )
        menu.anti_aim.builder[i].yaw_fluctation.fluctation_phase_time:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, { menu.anti_aim.builder[i].yaw_fluctation, function() return menu.anti_aim.builder[i].yaw_fluctation.value > 0 end }, enaa )
        menu.anti_aim.builder[i].yaw_fluctation.fluctation_delay_1:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, { menu.anti_aim.builder[i].yaw_fluctation, function() return menu.anti_aim.builder[i].yaw_fluctation.value > 0 end }, enaa )
        menu.anti_aim.builder[i].yaw_fluctation.fluctation_delay_2:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, { menu.anti_aim.builder[i].yaw_fluctation, function() return menu.anti_aim.builder[i].yaw_fluctation.value > 0 end }, enaa )
        menu.anti_aim.builder[i].yaw_fluctation.fluctation_delay_3:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, { menu.anti_aim.builder[i].yaw_fluctation, function() return menu.anti_aim.builder[i].yaw_fluctation.value > 0 end }, enaa )
        menu.anti_aim.builder[i].yaw_jitter:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, enaa )
        menu.anti_aim.builder[i].yaw_jitter.amount:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, { menu.anti_aim.builder[i].yaw_jitter, function() return menu.anti_aim.builder[i].yaw_jitter.value ~= "Disabled" end }, enaa )
        menu.anti_aim.builder[i].yaw_jitter.randomize:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, { menu.anti_aim.builder[i].yaw_jitter, function() return menu.anti_aim.builder[i].yaw_jitter.value ~= "Disabled" end }, enaa )
        menu.anti_aim.builder[i].fake_limit:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, enaa )
        menu.anti_aim.builder[i].fake_limit_randomize:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, enaa )
        menu.anti_aim.builder[i].body_jitter:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, enaa )
        menu.anti_aim.builder[i].body_jitter.body_jitter_switch_method:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, menu.anti_aim.builder[i].body_jitter, enaa )
        menu.anti_aim.builder[i].body_jitter.body_jitter_switch_ticks:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, menu.anti_aim.builder[i].body_jitter, { menu.anti_aim.builder[i].body_jitter.body_jitter_switch_method, "Default" }, enaa )
        menu.anti_aim.builder[i].body_jitter.body_jitter_switch_minimum:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, menu.anti_aim.builder[i].body_jitter, { menu.anti_aim.builder[i].body_jitter.body_jitter_switch_method, "Progressive" }, enaa )
        menu.anti_aim.builder[i].body_jitter.body_jitter_switch_maximum:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, menu.anti_aim.builder[i].body_jitter, { menu.anti_aim.builder[i].body_jitter.body_jitter_switch_method, "Progressive" }, enaa )
        menu.anti_aim.builder[i].body_jitter.body_jitter_randomize_switch:depend( { menu.anti_aim.branch, 1 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, menu.anti_aim.builder[i].body_jitter, { menu.anti_aim.builder[i].body_jitter.body_jitter_switch_ticks, function() return menu.anti_aim.builder[i].body_jitter.body_jitter_switch_ticks.value > 1 end }, enaa )
    
        menu.anti_aim.builder[i].defensive_aa:depend( { menu.anti_aim.branch, 2 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, enaa )
    
        menu.anti_aim.builder[i].pitch:depend( { menu.anti_aim.branch, 2 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, menu.anti_aim.builder[i].defensive_aa, enaa )
        menu.anti_aim.builder[i].pitch_random_first:depend( { menu.anti_aim.branch, 2 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, menu.anti_aim.builder[i].defensive_aa, { menu.anti_aim.builder[i].pitch, "Random" }, enaa )
        menu.anti_aim.builder[i].pitch_random_second:depend( { menu.anti_aim.branch, 2 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, menu.anti_aim.builder[i].defensive_aa, { menu.anti_aim.builder[i].pitch, "Random" }, enaa )
        menu.anti_aim.builder[i].pitch_custom:depend( { menu.anti_aim.branch, 2 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, menu.anti_aim.builder[i].defensive_aa, { menu.anti_aim.builder[i].pitch, "Custom" }, enaa )
    
        menu.anti_aim.builder[i].yaw:depend( { menu.anti_aim.branch, 2 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, menu.anti_aim.builder[i].defensive_aa, enaa )
        menu.anti_aim.builder[i].defensive_yaw_left_amount:depend( { menu.anti_aim.branch, 2 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, menu.anti_aim.builder[i].defensive_aa, { menu.anti_aim.builder[i].yaw, "L&R\n" }, enaa )
        menu.anti_aim.builder[i].defensive_yaw_right_amount:depend( { menu.anti_aim.branch, 2 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, menu.anti_aim.builder[i].defensive_aa, { menu.anti_aim.builder[i].yaw, "L&R\n" }, enaa )
        menu.anti_aim.builder[i].defensive_yaw_delay:depend( { menu.anti_aim.branch, 2 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, menu.anti_aim.builder[i].defensive_aa, { menu.anti_aim.builder[i].yaw, "L&R\n" }, enaa )
        menu.anti_aim.builder[i].yaw_random_first:depend( { menu.anti_aim.branch, 2 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, menu.anti_aim.builder[i].defensive_aa, { menu.anti_aim.builder[i].yaw, "Random\n" }, enaa )
        menu.anti_aim.builder[i].yaw_random_second:depend( { menu.anti_aim.branch, 2 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, menu.anti_aim.builder[i].defensive_aa, { menu.anti_aim.builder[i].yaw, "Random\n" }, enaa )
        menu.anti_aim.builder[i].yaw_spin_speed:depend( { menu.anti_aim.branch, 2 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, menu.anti_aim.builder[i].defensive_aa, { menu.anti_aim.builder[i].yaw, "Spin" }, enaa )
        menu.anti_aim.builder[i].yaw_custom:depend( { menu.anti_aim.branch, 2 }, { menu.anti_aim.current_state, menu.anti_aim_conditions[i] }, menu.anti_aim.builder[i].defensive_aa, { menu.anti_aim.builder[i].yaw, "Custom\n" }, enaa )
    end

    update_select_tab = function()
        local other_select = menu.home.select_tab
        local anti_aim_branch_select = menu.anti_aim.branch

        local select_tab_branch = {
            [1] = {"»  " .. "\a{Link Active}" .. ui.get_icon("person-circle-check").. "  \aDEFAULTState Builder", "\v" .. ui.get_icon("cubes") .. "  Defensive Builder"},
            [2] = {ui.get_icon("person-circle-check") .. "  State Builder", "»  " .. "\a{Link Active}" .. ui.get_icon("cubes") .. "  \aDEFAULTDefensive Builder"},
            [3] = {ui.get_icon("person-circle-check") .. "  State Builder", ui.get_icon("cubes") .. "  \aDEFAULTDefensive Builder"},
        }

        local select_tab_other = {
            [1] = {"»  " .. "\a{Link Active}" .. ui.get_icon("paintbrush").. "  \aDEFAULTVisuals", "\v" .. ui.get_icon("gears") .. "  Misc"},
            [2] = {"\v" .. ui.get_icon("paintbrush").. "  Visuals", "»  " .. "\a{Link Active}" .. ui.get_icon("gears") .. "  \aDEFAULTMisc"},
        }

        anti_aim_branch_select:update(select_tab_branch[anti_aim_branch_select:get()])
        other_select:update(select_tab_other[other_select:get()])
    end

    menu.home.select_tab:set_callback(update_select_tab)
    menu.anti_aim.branch:set_callback(update_select_tab)

    update_select_tab()
end

local anti_aim = { } do
    anti_aim.player_data = { } do
        anti_aim.player_data.entindex = -1
        anti_aim.player_data.alive = false
        anti_aim.player_data.onground = true
        anti_aim.player_data.velocity = 0.0
        anti_aim.player_data.duckamount = 0.0
        anti_aim.player_data.stamina = 80.0
        anti_aim.player_data.onground_ticks = 0
        anti_aim.player_data.stateid = 1

        anti_aim.player_data.velocity_mod = function(indx)
            local vel = indx.m_vecVelocity
            local velocity = math.sqrt(vel.x * vel.x + vel.y * vel.y)
            
            return velocity
        end

        anti_aim.player_data.is_onground = function(indx)
            if not bit.band(indx.m_fFlags,1) == 0 then return false end
    
            local onground = bit.band(indx.m_fFlags,1)

            if onground == 1 then
                anti_aim.player_data.onground_ticks = anti_aim.player_data.onground_ticks + 1
            else
                anti_aim.player_data.onground_ticks = 0
            end
    
            return anti_aim.player_data.onground_ticks > 4
        end

        anti_aim.player_data.state_trigger = function(indx)
            local manual_yaw = menu.anti_aim.manual_yaw:get()

            if manual_yaw ~= "Disabled" then
                return 10
            end

            local freestand_hotkey = menu.anti_aim.freestanding:get()

            if freestand_hotkey then
                return 9
            end

            if not anti_aim.player_data.onground then
                if anti_aim.player_data.duckamount > 0.5 then
                    return 5
                else
                    return 4
                end
            end

            local fake_duck_state = refs.fake_duck:get()
    
            if anti_aim.player_data.duckamount > 0.5 or fake_duck_state then
                if anti_aim.player_data.velocity > 4 then
                    return 7
                else
                    return 6
                end
            end
    
            local slow_motion_state = refs.slow_walk:get()
    
            if slow_motion_state then
                return 8
            end
    
            if anti_aim.player_data.velocity > 4 then
                return 3
            end
    
            return 2
        end

        anti_aim.player_data.write_player_data = function()
            local lp = entity.get_local_player()
            if lp == nil then return end

            anti_aim.player_data.entindex = lp
            anti_aim.player_data.alive = anti_aim.player_data.entindex:is_alive()

            if anti_aim.player_data.alive then
                anti_aim.player_data.onground = anti_aim.player_data.is_onground(anti_aim.player_data.entindex)
                anti_aim.player_data.velocity = anti_aim.player_data.velocity_mod(anti_aim.player_data.entindex)
                anti_aim.player_data.duckamount = anti_aim.player_data.entindex.m_flDuckAmount
                anti_aim.player_data.stamina = anti_aim.player_data.entindex.m_flStamina
                anti_aim.player_data.stateid = anti_aim.player_data.state_trigger()
            end
        end
    end

    is_inverted = false
    is_inverted_defensive = false
    switch = false
    ticks = 1
    current_tickcount = 0
    yaw_offset = 0
    edge_angle = 0
    is_edging = false
    yaw_spin_add = 0
    safe_head_trigger = false
    edge_angle = 0
    is_edging = false
    round_end_trigger = false
    left_value = 0
    right_value = 0
    fluctation_amount = 0

    anti_aim.get_desync_side = function()
        local lp = entity.get_local_player()
        if lp == nil then return end
    
        if globals.choked_commands ~= 0 then return end
    
        local body_yaw = lp.m_flPoseParameter[11] * 120 - 60
    
        return body_yaw > 0
    end

    anti_aim.override_defensive = function()
        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end

        local stateid = anti_aim.player_data.stateid

        if menu.anti_aim.force_defensive:get(stateid - 1) then
            refs.lag_options:override("Always On")
            refs.hide_shots_options:override("Break LC")
        else
            refs.lag_options:override("On Peek")
            refs.hide_shots_options:override("Favor Fire Rate")
        end
    end

    anti_aim.builder = function(cmd)
        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end

        local weapon = lp:get_player_weapon()
        if not weapon or weapon == nil then return end
    
        local weapon_info = weapon:get_weapon_info()
        if not weapon_info or weapon_info == nil then return end
    
        local weapon_classname = weapon:get_classname()
        if not weapon_classname or weapon_classname == nil then return end

        local is_taser = weapon_classname == "CWeaponTaser"
        local is_knife = weapon_classname == "CKnife"
        local is_grenade = weapon_info.weapon_type == 9

        local stateid = anti_aim.player_data.stateid

        local is_enabled = menu.anti_aim.builder[stateid].enable_state:get()

        if not is_enabled then 
            stateid = 1 
        end 

        is_inverted = not rage.antiaim:inverter()

        local lp_origin = lp:get_origin()

        local threat = entity.get_threat()
        local threat_origin = threat ~= nil and threat:get_origin() or lp_origin
    
        if menu.anti_aim.safe_head.triggers:get(1) and is_knife and stateid == 5 then
            safe_head_trigger = true
        elseif menu.anti_aim.safe_head.triggers:get(2) and is_taser and stateid == 5 then
            safe_head_trigger = true
        elseif menu.anti_aim.safe_head.triggers:get(3) and lp_origin.z - threat_origin.z > menu.anti_aim.safe_head.height_difference:get() and (stateid == 5 or stateid == 6 or stateid == 7 or stateid == 2) then
            safe_head_trigger = true
        else
            safe_head_trigger = false
        end
        
        local is_default_switch = menu.anti_aim.builder[stateid].body_jitter.body_jitter_switch_method:get() == "Default" and menu.anti_aim.builder[stateid].body_jitter.body_jitter_switch_ticks:get() > 2
        local is_progressive_switch = menu.anti_aim.builder[stateid].body_jitter.body_jitter_switch_method:get() == "Progressive" and (menu.anti_aim.builder[stateid].body_jitter.body_jitter_switch_maximum:get() > 2 or menu.anti_aim.builder[stateid].body_jitter.body_jitter_switch_minimum:get() > 2)
        
        if menu.anti_aim.builder[stateid].body_jitter:get() and not (menu.anti_aim.builder[stateid].yaw_jitter:get() == "Offset" or menu.anti_aim.builder[stateid].yaw_jitter:get() == "Spin" or menu.anti_aim.builder[stateid].yaw_jitter:get() == "3-Way" or menu.anti_aim.builder[stateid].yaw_jitter:get() == "5-Way") then
            if menu.anti_aim.builder[stateid].body_jitter.body_jitter_switch_method:get() == "Default" then 
                if is_default_switch then
                    if globals.tickcount % (menu.anti_aim.builder[stateid].body_jitter.body_jitter_randomize_switch:get() > 2 and utils.random_int(menu.anti_aim.builder[stateid].body_jitter.body_jitter_switch_ticks:get(), menu.anti_aim.builder[stateid].body_jitter.body_jitter_randomize_switch:get()) or menu.anti_aim.builder[stateid].body_jitter.body_jitter_switch_ticks:get()) == 0 then
                        switch = not switch
                    end
                end
        
                is_inverted = switch
            else
                if globals.tickcount % (menu.anti_aim.builder[stateid].body_jitter.body_jitter_randomize_switch:get() > 2 and utils.random_int(ticks, menu.anti_aim.builder[stateid].body_jitter.body_jitter_randomize_switch:get()) or ticks) == 0 then
                    switch = not switch
    
                    if ticks < menu.anti_aim.builder[stateid].body_jitter.body_jitter_switch_maximum:get() then
                        ticks = ticks + 1
                    elseif ticks < menu.anti_aim.builder[stateid].body_jitter.body_jitter_switch_minimum:get() then
                        ticks = ticks + 1
                    else
                        ticks = ticks - 1
                    end
                end
        
                is_inverted = switch
            end

            if (is_default_switch or is_progressive_switch) and not (menu.anti_aim.builder[stateid].yaw_jitter:get() == "Offset" or menu.anti_aim.builder[stateid].yaw_jitter:get() == "Spin" or menu.anti_aim.builder[stateid].yaw_jitter:get() == "3-Way" or menu.anti_aim.builder[stateid].yaw_jitter:get() == "5-Way") then
                rage.antiaim:inverter(is_inverted)
            end
    
            refs.body_yaw.options:override("Jitter")
        else
            refs.body_yaw.options:override("")
        end
    
        refs.body_yaw:override(true)
        refs.body_yaw.left_limit:override(menu.anti_aim.builder[stateid].fake_limit:get() - utils.random_int(0, menu.anti_aim.builder[stateid].fake_limit_randomize:get() / 2))
        refs.body_yaw.right_limit:override(menu.anti_aim.builder[stateid].fake_limit:get() - utils.random_int(0, menu.anti_aim.builder[stateid].fake_limit_randomize:get() / 2))
        
        refs.pitch:override("Down")
        
        refs.yaw:override("Backward") 
        refs.yaw.base:override("At Target")
        refs.yaw.avoid_backstab:override(menu.anti_aim.avoid_backstab:get())

        if menu.anti_aim.builder[stateid].yaw_fluctation:get() > 0 then
            if globals.tickcount % menu.anti_aim.builder[stateid].yaw_fluctation.fluctation_phase_time:get() == menu.anti_aim.builder[stateid].yaw_fluctation.fluctation_delay_1:get() then
                left_value = menu.anti_aim.builder[stateid].yaw_amount.add_left_yaw:get() + utils.random_int(0, menu.anti_aim.builder[stateid].yaw_fluctation:get() / 2)
                right_value = menu.anti_aim.builder[stateid].yaw_amount.add_right_yaw:get() + utils.random_int(0, menu.anti_aim.builder[stateid].yaw_fluctation:get() / 2)
            elseif globals.tickcount % menu.anti_aim.builder[stateid].yaw_fluctation.fluctation_phase_time:get() == menu.anti_aim.builder[stateid].yaw_fluctation.fluctation_delay_2:get() then
                left_value = menu.anti_aim.builder[stateid].yaw_amount.add_left_yaw:get() - utils.random_int(0, menu.anti_aim.builder[stateid].yaw_fluctation:get() / 2)
                right_value = menu.anti_aim.builder[stateid].yaw_amount.add_right_yaw:get() - utils.random_int(0, menu.anti_aim.builder[stateid].yaw_fluctation:get() / 2)
            elseif globals.tickcount % menu.anti_aim.builder[stateid].yaw_fluctation.fluctation_phase_time:get() == menu.anti_aim.builder[stateid].yaw_fluctation.fluctation_delay_3:get() then
                left_value = menu.anti_aim.builder[stateid].yaw_amount.add_left_yaw:get() + ((utils.random_int(0, menu.anti_aim.builder[stateid].yaw_fluctation:get() / 2) - utils.random_int(0, (menu.anti_aim.builder[stateid].yaw_fluctation:get() / 2) + 15)) / 2)
                right_value = menu.anti_aim.builder[stateid].yaw_amount.add_right_yaw:get() + ((utils.random_int(0, menu.anti_aim.builder[stateid].yaw_fluctation:get() / 2) - utils.random_int(0, (menu.anti_aim.builder[stateid].yaw_fluctation:get() / 2) + 15)) / 2)
            end
        else
            left_value = menu.anti_aim.builder[stateid].yaw_amount.add_left_yaw:get()
            right_value = menu.anti_aim.builder[stateid].yaw_amount.add_right_yaw:get()
        end

        if is_default_switch or is_progressive_switch then
            yaw_offset = ((rage.antiaim:inverter() and left_value or right_value) + utils.random_int(0, menu.anti_aim.builder[stateid].yaw_randomize:get() / 2)) + menu.anti_aim.builder[stateid].yaw_amount:get()
        else
            if globals.choked_commands == 0 then
                yaw_offset = (anti_aim.get_desync_side() and left_value or right_value) + utils.random_int(0, menu.anti_aim.builder[stateid].yaw_randomize:get() / 2) + menu.anti_aim.builder[stateid].yaw_amount:get()
            end
        end
        
        if is_default_switch or is_progressive_switch then
            if menu.anti_aim.builder[stateid].yaw_jitter:get() ~= "Disabled" then
                refs.yaw_modifier:override("Disabled")
                refs.yaw_modifier.offset:override(0)
        
                if menu.anti_aim.builder[stateid].yaw_jitter:get() == "Center" then
                    yaw_offset = ((rage.antiaim:inverter() and menu.anti_aim.builder[stateid].yaw_jitter.amount:get() / 2 or -menu.anti_aim.builder[stateid].yaw_jitter.amount:get() / 2) + yaw_offset) + utils.random_int(0, menu.anti_aim.builder[stateid].yaw_jitter.randomize:get() / 2) + menu.anti_aim.builder[stateid].yaw_amount:get()
                elseif menu.anti_aim.builder[stateid].yaw_jitter:get() == "Random" then
                    yaw_offset = (rage.antiaim:inverter() and utils.random_int(menu.anti_aim.builder[stateid].yaw_jitter.amount:get() / 2, menu.anti_aim.builder[stateid].yaw_jitter.amount:get() / 2 - 15) or utils.random_int(-menu.anti_aim.builder[stateid].yaw_jitter.amount:get() / 2, -menu.anti_aim.builder[stateid].yaw_jitter.amount:get() / 2 + 15)) + menu.anti_aim.builder[stateid].yaw_amount:get()
                end
            else
                refs.yaw_modifier:override("Disabled")
                refs.yaw_modifier.offset:override(0)
            end
        else
            refs.yaw_modifier:override(menu.anti_aim.builder[stateid].yaw_jitter:get())
            refs.yaw_modifier.offset:override(menu.anti_aim.builder[stateid].yaw_jitter.amount:get() + utils.random_float(0, menu.anti_aim.builder[stateid].yaw_jitter.randomize:get() / 2))
        end
        
        refs.yaw.offset:override(yaw_offset)

        if menu.anti_aim.builder[stateid].defensive_aa:get() and not safe_head_trigger and not is_grenade then
            refs.yaw.hidden:override(true)
            refs.lag_options:override("Always On")
            refs.hide_shots_options:override("Break LC")

            if menu.anti_aim.builder[stateid].pitch:get() == "Disabled" then
                rage.antiaim:override_hidden_pitch(0)
            elseif menu.anti_aim.builder[stateid].pitch:get() == "Down" then
                rage.antiaim:override_hidden_pitch(89)
            elseif menu.anti_aim.builder[stateid].pitch:get() == "Up" then
                rage.antiaim:override_hidden_pitch(-89)
            elseif menu.anti_aim.builder[stateid].pitch:get() == "Random" then
                rage.antiaim:override_hidden_pitch(utils.random_float(menu.anti_aim.builder[stateid].pitch_random_first:get(), menu.anti_aim.builder[stateid].pitch_random_second:get()))
            elseif menu.anti_aim.builder[stateid].pitch:get() == "Custom" then
                rage.antiaim:override_hidden_pitch(menu.anti_aim.builder[stateid].pitch_custom:get())
            end

            if menu.anti_aim.builder[stateid].yaw:get() == "L&R\n" then
                if menu.anti_aim.builder[stateid].defensive_yaw_delay:get() > 2 then
                    if globals.tickcount % menu.anti_aim.builder[stateid].defensive_yaw_delay:get() == 0 then
                        is_inverted_defensive = not is_inverted_defensive
                    end

                    rage.antiaim:override_hidden_yaw_offset(is_inverted_defensive and menu.anti_aim.builder[stateid].defensive_yaw_left_amount:get() or menu.anti_aim.builder[stateid].defensive_yaw_right_amount:get())
                else
                    if globals.choked_commands == 0 then
                        rage.antiaim:override_hidden_yaw_offset(anti_aim.get_desync_side() and menu.anti_aim.builder[stateid].defensive_yaw_left_amount:get() or menu.anti_aim.builder[stateid].defensive_yaw_right_amount:get())
                    end
                end
            elseif menu.anti_aim.builder[stateid].yaw:get() == "Forward" then
                rage.antiaim:override_hidden_yaw_offset(180)
            elseif menu.anti_aim.builder[stateid].yaw:get() == "Sideways" then
                rage.antiaim:override_hidden_yaw_offset(is_inverted and -120 or 120)
            elseif menu.anti_aim.builder[stateid].yaw:get() == "Random\n" then
                rage.antiaim:override_hidden_yaw_offset(utils.random_float(menu.anti_aim.builder[stateid].yaw_random_first:get(), menu.anti_aim.builder[stateid].yaw_random_second:get()))
            elseif menu.anti_aim.builder[stateid].yaw:get() == "Spin" then
                if yaw_spin_add >= 180 then
                    yaw_spin_add = -180
                else
                    yaw_spin_add = yaw_spin_add + menu.anti_aim.builder[stateid].yaw_spin_speed:get() + 15
                end

                rage.antiaim:override_hidden_yaw_offset(yaw_spin_add)
            elseif menu.anti_aim.builder[stateid].yaw:get() == "Custom\n" then
                rage.antiaim:override_hidden_yaw_offset(menu.anti_aim.builder[stateid].yaw_custom:get())
            end
        else
            refs.yaw.hidden:override(false)
        end

        function safe_head_values()
            refs.yaw.offset:override(0)
            refs.yaw.hidden:override(false)
            refs.yaw_modifier:override("Disabled")
            refs.yaw_modifier.offset:override(0)
            refs.body_yaw:override(true)
            refs.body_yaw.left_limit:override(0)
            refs.body_yaw.right_limit:override(0)
            refs.body_yaw.options:override("")
            rage.antiaim:inverter(false)
        end

        if menu.anti_aim.safe_head:get() then
            if safe_head_trigger then
                safe_head_values()
            end
        end
        
        if menu.anti_aim.force_defensive:get(stateid + 1) then
            if menu.anti_aim.force_defensive.method:get() == 1 and menu.anti_aim.force_defensive.always_on:get() then
                cmd.force_defensive = true
            elseif menu.anti_aim.force_defensive.method:get() == 2 then
                cmd.force_defensive = cmd.command_number % menu.anti_aim.force_defensive.custom_ticks:get() == 0
            elseif menu.anti_aim.force_defensive.method:get() == 3 then
                cmd.force_defensive = cmd.command_number % utils.random_int(menu.anti_aim.force_defensive.random_ticks_first:get(), menu.anti_aim.force_defensive.random_ticks_second:get()) == 0
            end
        end

        if menu.anti_aim.flick_exploit:get() then
            if refs.slow_walk:get() then 
                rage.antiaim:inverter(true)
        
                refs.yaw.hidden:override(true)
                refs.yaw_modifier:override("Disabled")
                refs.yaw_modifier.offset:override(0)
                refs.body_yaw.options:override("")

                rage.antiaim:override_hidden_pitch(89)
                rage.antiaim:override_hidden_yaw_offset(menu.anti_aim.flick_exploit.inverter:get() and 120 or -120)

                refs.yaw.offset:override(menu.anti_aim.flick_exploit.inverter:get() and 20 or -20)

                cmd.force_defensive = cmd.command_number % 8 == 0

                refs.lag_options:override("Always On")
                refs.hide_shots_options:override("Break LC")
            end
        end

        if menu.anti_aim.lag_exploit:get() and (stateid == 4 or stateid == 5) then
            if globals.tickcount % menu.anti_aim.lag_exploit.ticks:get() == 0 then
                rage.exploit:force_teleport()
            else
                rage.exploit:force_charge()
            end
        end

        function edge_trigger()
            is_edging = false
        
            if cmd.send_packet then 
                vecTraceStart = lp:get_eye_position() 
            end
        
            local aTraceEnd = {}
        
            local angViewAngles = render.camera_angles()
            local distances = {}
        
            for flYaw = 18, 360, 18 do
                flYaw = math.normalize_yaw(flYaw)
        
                local vecTraceEnd = vecTraceStart + vector():angles(0, flYaw) * 198
        
                local traceInfo = utils.trace_line(vecTraceStart, vecTraceEnd, player, 0x46004003)
                table.insert(distances, vecTraceStart:dist(traceInfo.end_pos))
        
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
        
            if distances[1] > 30 then return end
        
            table.sort(aTraceEnd, function(a, b) return a.flYaw < b.flYaw end)
        
            table.remove(aTraceEnd, #aTraceEnd)
        
            local angEdge
        
            if #aTraceEnd >= 3 then
                local vecTraceCenter = aTraceEnd[1].vecTraceEnd:lerp(aTraceEnd[#aTraceEnd].vecTraceEnd, 0.5)
        
                angEdge = (vecTraceStart - vecTraceCenter):angles()
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
        
                edge_angle = flNewYaw
                is_edging = true
            end
        end

        edge_trigger()

        function disablers_values()
            refs.pitch:override("Disabled")
            refs.yaw.offset:override((globals.tickcount % 360) * 15)
            refs.yaw.hidden:override(false)
            refs.yaw_modifier:override("Disabled")
            refs.yaw_modifier.offset:override(0)
            refs.body_yaw:override(false)
            refs.body_yaw.left_limit:override(0)
            refs.body_yaw.right_limit:override(0)
            refs.body_yaw.options:override("")
        end

        if menu.anti_aim.disablers:get(1) and entity.get_game_rules().m_bWarmupPeriod then
            disablers_values()
        elseif menu.anti_aim.disablers:get(2) and round_end_trigger then
            disablers_values()
        end
    end

    anti_aim.addons = function()
        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end

        if menu.anti_aim.manual_yaw:get() ~= "Disabled" then
            refs.yaw.base:override("Local View")

            if menu.anti_aim.manual_yaw:get() == "Left" then
                refs.yaw.offset:override(-90)
            elseif menu.anti_aim.manual_yaw:get() == "Right" then
                refs.yaw.offset:override(90)
            elseif menu.anti_aim.manual_yaw:get() == "Forward" then
                refs.yaw.offset:override(180)
            end
        end

        if menu.anti_aim.manual_yaw:get() ~= "Disabled" and menu.anti_aim.manual_yaw.manual_over_fs:get() then
            refs.freestanding:override(false)
            refs.freestanding.disable_yaw_modifiers:override(false)
            refs.freestanding.body_freestanding:override(false)
        else
            refs.freestanding:override(menu.anti_aim.freestanding:get())
            refs.freestanding.disable_yaw_modifiers:override(menu.anti_aim.freestanding.disable_yaw_modifiers:get())
            refs.freestanding.body_freestanding:override(menu.anti_aim.freestanding.body_freestanding:get())
        end

        if menu.anti_aim.edge_yaw:get() and is_edging and not (menu.anti_aim.manual_yaw:get() ~= "Disabled" and menu.anti_aim.edge_yaw.ignore_manuals:get()) then
            refs.yaw.offset:override(edge_angle)
            refs.yaw_modifier:override("Disabled")
            refs.yaw_modifier.offset:override(0)
            refs.yaw.hidden:override(false)
        end

        refs.yaw.avoid_backstab:override(menu.anti_aim.avoid_backstab:get())
    end
end

local screen_x, screen_y = render.screen_size().x, render.screen_size().y

local visuals = { } do
    visuals.animated_text = function(text, speed, color_start, color_end, alpha)
        local first = color_start and color(color_start.r, color_start.g, color_start.b, alpha) or color(255, 200, 255, alpha)
        local second = color_end and color(color_end.r, color_end.g, color_end.b, alpha) or color(100, 100, 100, alpha)

        local res = ""

        for idx = 1, #text + 1 do
            local letter = text:sub(idx, idx)

            local alpha1 = (idx - 1) / (#text - 1)
            local m_speed = globals.realtime * ((50 / 25) or 1.0)
            local m_factor = m_speed % math.pi

            local c_speed = speed or 1
            local m_sin = math.sin(m_factor * c_speed + (alpha1 or 0))
            local m_abs = math.abs(m_sin)
            local clr = first:lerp(second, m_abs)

            res = ("%s\a%s%s"):format(res, clr:to_hex(), letter)
        end

        return res
    end

    visuals.mouse_check = function(first, second)
        if ui.get_alpha() < 1 then return false end
        local pos = ui.get_mouse_position()
        return pos.x >= first.x and pos.x <= second.x and pos.y >= first.y and pos.y <= second.y 
    end

    visuals.get_bind = function(name)
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

    visuals.fonts = 
    {
        verdana = render.load_font("Verdana", 16, "ad"),
        verdana_bold = render.load_font("Verdana", 21, "bad"),
        calibri_bold = render.load_font("Calibri Bold", 24, "ad"),
    }

    local bomb_img = render.load_image("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x64\x00\x00\x00\x5C\x08\x03\x00\x00\x00\xAF\x15\xE0\xA6\x00\x00\x00\x01\x73\x52\x47\x42\x01\xD9\xC9\x2C\x7F\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0B\x13\x00\x00\x0B\x13\x01\x00\x9A\x9C\x18\x00\x00\x02\xDF\x50\x4C\x54\x45\x00\x00\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x76\x99\x69\x74\x00\x00\x00\xF5\x74\x52\x4E\x53\x00\x01\x43\x93\x58\x06\x5A\xFB\xFF\xFD\x96\x04\xD5\xF9\x02\x0E\xE3\x18\x16\xEA\x2B\x1B\xEF\x36\x29\x73\x72\x1E\xF2\x3F\x75\x6B\x20\xEB\xF4\x32\x21\xF6\x47\x2F\xE7\xE2\x37\x5E\xB7\x0F\x23\xF8\x51\x08\xB3\x9A\x7D\xF7\x63\x00\x70\x7A\xC1\x25\x6E\x2D\xE0\x62\xFC\xC2\x28\x76\xAE\x88\x0B\xC9\x5D\x7E\xFA\xE9\x27\x5C\xDF\x12\x31\x84\xD8\x8C\xCF\x97\x3A\x8A\x03\xAC\xDA\x1C\x6C\x2E\x42\x8F\x7B\xA1\x4B\x95\x10\xCA\x13\x55\x3D\x1A\x33\x0A\x4E\x69\x82\xBB\x41\xC7\x80\x87\x91\x9E\xA6\xAA\x86\x7F\x5F\x26\xDC\xFE\x49\xE8\x17\xC3\x46\x89\x92\xBA\x2C\xC0\xB8\xA3\x9F\xA8\xAF\xB1\xB5\xBC\xD4\x7C\xF3\x9D\x24\x0D\x8E\x5B\x05\xD9\xD1\x99\xF1\xCC\xCB\x9B\x4F\x14\xCE\xC5\xCD\x19\x30\xF5\x07\xDE\x15\xA4\x1D\x11\xE5\x83\x2A\xA0\x71\xD6\xD0\xC6\xB9\xA9\x6D\x52\x35\xDD\x0C\xE4\x64\xED\xBF\xC4\x8D\x77\x85\x8B\x90\xEE\xE6\xA5\x78\xEC\x09\x60\x1F\x81\xAB\x9C\x98\x38\x61\x4A\xB2\x34\x4C\xDB\xA7\xD2\x45\x39\x53\xB0\xF0\xBD\x94\x4D\xB4\x44\x54\x3E\xA2\x22\x59\x6A\xE1\xD7\xAD\x40\x48\x3B\xBE\x65\x74\x34\x72\x01\xD4\x00\x00\x07\x6E\x49\x44\x41\x54\x78\x9C\xED\x9A\xF9\x5B\xD4\x46\x18\xC7\xB3\x22\x32\x2B\x8B\x8A\x58\xD0\x42\xE5\x10\x54\x28\x42\x11\x70\x11\x11\x10\x95\x22\x28\x56\x2C\x88\x14\x05\xE4\xB4\x1C\xC5\x20\x60\x45\xBC\x51\x01\xA1\x88\x88\xA2\xA2\x78\x71\x15\x15\x0B\x88\x78\x0B\x15\x54\x14\xCF\x0A\x78\xB6\xB5\xD5\x5A\xDB\xDA\xEB\x0F\x68\x66\x26\xBB\x9B\x84\xDD\x25\x86\xA5\xCF\xD3\x3E\xBE\xBF\x64\xE7\x9B\xF7\x7D\x3F\x39\x66\x92\x77\x26\x4B\x10\x02\x4C\x34\x40\x6B\xA0\xB6\x90\xC0\x37\xB1\x41\x3A\x40\x3C\xB8\x9F\x19\xBA\x12\x00\x80\xDE\x90\xFE\x85\x0C\x1D\x46\x41\x80\x7E\xFF\x42\x86\x1B\x40\xC8\x88\xFE\x85\xBC\x63\x08\x21\x46\x9A\x4B\x38\x72\xD4\xBB\x3D\x0E\xD9\xD8\x04\x42\xDE\xE3\xA8\xA2\x91\xA3\x4D\xCD\x04\x31\xF4\xCD\x01\xB0\x18\xC3\x11\x2D\xAD\x20\x64\x2C\x47\x1D\x37\x1E\x00\x6B\x1B\x21\x90\xF7\x61\x3A\xDB\x09\x6C\xD1\xCE\x1E\xAA\x1F\xB0\x45\x87\x89\x50\x74\x14\x02\xB1\x13\xC3\x50\x27\x8E\xE8\x0C\xC5\x49\x2C\x4D\xEA\xA2\x03\xC5\xC9\x42\x20\x84\x2B\x0C\x15\xB3\x6F\xCB\x14\x3D\x28\xBA\xB1\xB4\xA9\xE3\xA1\xE6\x6E\x26\x08\xE2\xE1\x09\x83\xA7\x39\x30\x35\x2F\xA4\x4D\x67\x4A\xBA\x33\xA0\x04\x66\x0A\x62\x10\xDE\x1F\xA2\x68\x1F\xA6\x36\x02\x49\xB3\x18\x8A\xD4\xC3\x17\x4A\x7E\xB3\x85\x41\x88\x39\x28\xA3\xFF\x5C\x86\xF4\x11\x92\xE6\x31\x14\xCB\x00\x24\xCD\x17\xFC\xA8\xF9\x18\xC5\x07\x32\xE2\x83\x90\xB2\x40\x21\x04\x2F\x44\x4A\xC8\x27\x42\x19\x44\x28\xBA\x03\x16\x8B\x14\xCA\x62\x94\x32\x4C\x21\x8C\x45\x02\x08\x17\xCC\x90\xDD\x95\x08\x85\xB2\x04\x09\x91\xF2\x76\x14\xF6\x88\x8E\x11\x0E\x21\xC6\xC4\x42\x8B\x53\x08\x4B\x91\xF0\xA9\xBC\x1D\x9F\x90\xE8\x96\xE4\xF8\x59\x72\x1F\x18\x6F\xED\x7F\x63\x52\xE3\x50\xDB\x65\x83\x44\xB2\x66\x82\xA9\x9B\x13\x49\x92\x29\xCB\x23\xB1\x05\xA6\xA6\xA5\xF3\xB4\x88\x40\x18\xA0\xB5\xE2\x73\x97\x95\x19\x6C\x86\xFE\x74\x77\xAA\x57\xDB\x7B\xE1\x96\x03\x69\x0F\x34\x61\xAB\x18\x7D\x7C\xC8\x94\xF9\xAB\x32\x91\xBA\x1A\x0B\x6E\x62\x8D\x30\xA8\x27\xB5\xB7\x8C\x61\xB6\x60\x0D\xAD\x19\xAC\xC5\xCA\x3A\x0D\x31\x80\xF3\x7A\x9C\xD0\x7B\x83\xBF\x4C\xB2\x5A\x42\x63\xFD\xD5\x05\xBE\x91\x85\xA2\x7C\x1B\xCD\xE5\x42\xD6\x26\xD9\xB9\x19\xF0\xCB\x10\xB0\x79\x4B\x76\x8E\xC2\x22\xB2\xD3\x72\xD3\x17\x6E\xCD\x9B\x98\xBF\x25\xEB\x8B\x02\xEC\xB2\x0D\xE5\x93\x47\x78\x92\x51\xF2\x9B\x54\xC8\x07\x61\xA1\xF6\x6D\x14\x8B\x9D\x52\x98\x10\xCF\xED\x45\x0C\x0F\x5E\x7D\xCB\x7A\x07\x0F\x48\x31\x03\xE2\xB7\x73\x17\xD3\x83\x57\xE7\x2A\xD9\xA5\x34\x3B\x1B\xA2\x25\x87\x18\x6A\x71\x0A\x65\x3E\x0C\x20\x11\x29\xC9\xCD\x85\x04\xA2\x06\xF5\x8A\xCB\x32\xD2\xE5\x78\xF0\x82\xEC\x56\xC7\x90\x41\xF6\xA0\xC6\xDE\xD2\xD5\x5C\x04\x4F\xC8\x3E\x3E\x90\xFD\xA8\x51\x76\x40\x89\x07\x2F\xC8\x41\x3E\x90\xED\xAA\x3D\x78\x41\x0E\xF1\x81\xA4\xF6\x11\x12\x0D\x3D\x63\xE2\x0E\x1F\x11\x89\xCA\x2B\x66\x0E\x25\x2A\xC3\x4B\x8D\xE3\x35\x0D\x29\x80\x9E\xB9\x85\x3A\x55\xD5\xC3\xFD\x80\xD5\x72\x62\x52\xA6\x78\x8D\x62\x42\x41\x43\x72\xFA\x08\x91\x48\x29\xCF\x2F\x01\x30\xA9\x39\x7A\x0C\x96\x75\xC7\xA9\x9F\xB5\x5C\xC8\x89\xBE\x42\xE0\x38\xB1\xFC\x2A\x2B\xD6\x41\x64\x63\x10\xB8\x96\x98\xBD\xA0\xC4\x67\x82\xA6\x21\x75\x6A\x8B\x5C\x0D\x41\x02\x82\xFF\x05\x48\x88\xDA\x45\x0E\x1A\x82\x0B\xD9\xF1\xC3\xAA\x4A\x0A\xEA\xF7\x35\xB8\x9E\x9C\x91\xDE\xB8\x67\xDE\xA9\xA6\xD3\x4B\x45\xFC\x20\x67\x1C\x78\x40\xB2\x55\x1C\xB4\xA1\x1B\x3F\x88\xFB\x59\x1E\x90\x34\x55\x57\x66\x95\x4A\x88\x39\xAA\x79\xF6\xE2\xC6\xB9\x28\x1E\x90\x74\x55\x10\x13\x55\x90\xCC\xF3\x28\x44\x82\x5B\x17\xD4\x2E\xA4\xF4\x06\x89\x56\x05\xB9\x38\x81\x09\x11\x5F\xCA\x6B\x6E\x19\xCD\xB0\x96\xC9\xDB\x66\x91\x49\x5F\xA7\x6C\xB8\xDC\xDC\xBA\xD1\x96\x03\x11\x5B\xB4\x5D\x71\x2F\x91\x48\x0E\xBB\xE6\x5F\x6D\xBD\x66\xDA\x14\xA3\x02\xD2\x6E\x44\x5C\x2F\x52\x40\x78\x59\x23\x82\x1C\xF5\x56\xD2\xDD\x95\x07\xB4\x4A\x45\xE1\x37\x04\x41\x94\x9A\xCC\xC5\x6A\xF3\xAC\xB8\x8E\xCA\xA8\x51\xA8\x51\x65\x46\x94\x5F\x18\xCB\x80\x18\xEE\x27\x6F\xE6\x9A\x50\xDD\xAC\x99\x24\xB3\x9D\xA9\x6E\xB1\x35\x29\xE9\x96\x0E\x35\x4A\xC3\x48\xF2\xB6\x2F\x5F\x48\xBD\x11\x7E\x8D\xD7\xC0\x86\xAF\x87\x94\xB8\x03\xEE\x32\x20\xF7\xE0\x3E\x12\x80\x32\xB8\x0D\x03\x7A\x41\xD4\x46\xBA\x05\xB4\x75\xC0\xF6\x49\xEC\x93\xDB\x1B\xA4\x74\x28\x6E\x49\xBF\x81\xAD\xFB\xC1\x44\x67\x3B\x58\xC4\x80\xA0\xC5\xAD\x2E\x00\x3A\xF1\xD6\x1F\xD5\xBD\x81\xA0\x1B\x3D\x09\x22\xB1\xCF\x83\x5E\x20\x7A\xB0\xA0\xDC\x71\xF9\xA1\x44\xD2\x4E\xB5\x2A\x3A\x08\xDD\x13\x78\x69\x4E\x06\x81\x67\x45\x3C\x02\x00\x4D\x3E\x1F\xD3\xD5\xCB\x6D\xB0\xAA\x12\x6E\xB5\xF8\x41\xF2\xA8\x1F\xDA\xF7\xE9\x84\x99\xCD\x54\x1E\x67\x36\xE4\x11\x74\x6D\x02\xE0\x09\xDC\x2E\xA1\xEB\xB0\x5B\x74\xD1\x97\x8D\x7D\xD2\x7A\x81\xC0\x4B\x7E\x4F\xD6\x05\xFC\x6B\x08\x22\x15\xB0\x21\xA7\x6A\x29\x73\x02\x20\xDC\x4C\xBF\xBA\xA6\x11\x54\x94\x0D\xAF\x5E\x5A\x74\x08\x98\x07\x41\x9D\x9E\x18\x5C\xED\x05\x72\x9A\xBA\x1B\x0D\x32\xC8\x64\x6A\x86\xE1\x2A\x91\x48\xEC\xA8\xBD\x79\x12\x13\x15\x1D\xB6\xA7\xE1\x07\xE4\x01\x65\x6F\x05\xB4\x7F\x1C\x35\x3B\xAA\xA3\x7D\xCD\xD9\xCF\xA9\xC1\xBC\x21\xF8\x51\xDF\xB0\xDC\x58\x05\x04\xCE\x5F\x02\x69\xDF\xA7\xEC\xFD\x37\x91\xA8\x53\x25\x09\xF8\x96\xDA\x7A\x76\x4B\x4A\x2C\xA0\x60\x20\xA9\x6B\xA3\x36\xCE\x25\x92\xEE\x0A\x3A\x10\xD7\x5D\x56\xA0\xDD\xAD\x47\x79\x8E\xF6\xC3\x05\xB2\x8C\x76\xEC\xDB\x10\x4B\x1B\xEC\xD5\x46\xB1\xDF\x21\xB1\x39\x46\x5A\x69\x33\x0D\x00\xC7\xB3\xC4\xF5\xE4\x6E\x00\xBE\xAF\x15\xE9\x06\xED\x05\xBE\xE7\xE3\x89\x1D\xCF\xDA\x70\x20\x5E\x7F\x84\x87\xF0\xC3\x5D\x65\x90\x68\xD8\x25\xCB\x1F\x5A\xB1\x4E\x1F\xDE\xF8\x83\xF4\x6F\x38\xF8\x88\xD5\x00\xA0\x3A\x28\x14\xF8\xA1\x5A\x74\x06\xB0\x46\xC3\x2B\x15\xFB\xE0\x15\x1D\x3C\xA9\x0A\xEB\xE8\x09\x11\xFF\x08\x7F\xCE\x1D\xF0\x3C\x36\x96\x05\x91\xCA\x7A\xD7\x63\xB8\x3F\x19\x80\xA9\x70\xFB\x02\x04\xA0\x9A\x7A\x3F\x3D\x4E\xE8\xDB\x86\xD7\xA6\x86\xE1\x46\x48\x53\x30\x17\x02\xCE\x58\xD2\x4D\x11\xFB\x4C\x64\x90\xC5\x70\x5F\x17\x3D\x5E\x64\x83\x31\x82\x1E\xF9\x3F\x61\x9F\x15\x28\x41\xB7\x2C\x3C\xFD\xA5\x94\x03\x01\x75\x03\xF1\x1B\xD6\x4C\x39\xA4\x0B\xEE\xF3\x01\xE0\x67\xB8\x7D\x05\xAE\xA0\xD5\xC2\x3C\x70\x0C\xF5\x44\x7A\x14\x87\xA3\x04\x97\xE5\xF3\xC3\xAA\x04\x2E\x04\x00\xFB\x89\xC5\x24\x19\xF6\x0B\x50\x6A\x05\x17\x29\x2B\x01\xE0\xD7\xAD\xD9\x39\xE9\xD4\xAD\x0B\x89\xC8\x79\x90\x6F\x08\x7C\x2F\x41\xDD\x10\xFB\xBC\xC2\x09\x2D\x9F\xCA\xBA\x1B\x28\x9E\xCB\x85\xF4\xD5\x3C\x9F\xD0\x19\x77\x25\x94\x66\xD2\x5A\x3E\x3D\x0D\xB4\xD6\x14\x64\x8D\x97\xFC\xEA\x54\x27\xD6\xD1\x53\x51\x7A\x79\xEF\x74\xB7\xFA\x58\xDE\xD6\xC8\x2C\x65\x8F\x5C\xC3\x07\x2F\xFB\x40\x30\xD5\xBD\x4F\xB9\xC5\x15\x15\x15\x85\x06\x7E\x55\xBF\xD9\xB1\x46\x06\x61\xD6\xB2\xCF\xB0\x30\x57\x3E\x6B\x1E\x11\xDB\x17\x6B\x4A\x7E\xFD\xFA\xC5\xA6\x91\x4A\x66\x8A\xDA\x9D\x71\xF1\x3D\xD5\xB7\xF6\x5F\x31\x6F\x17\x92\x24\x9D\x7C\x18\x8B\xFD\x2F\x49\x68\xBF\x2B\x84\x3F\xA0\x0B\x39\x5D\x6D\x55\xAE\xDE\x12\xD1\x77\x24\xF1\x33\x85\xF2\x02\xF5\xDD\xF9\x0A\xE1\x39\xEE\xCD\xA6\xC2\x21\xA5\x28\xC1\x6E\x6F\x85\x62\x83\x94\x14\x85\xA0\xBD\x0C\x29\xD1\x6A\x67\x31\xEA\x6C\x10\x8A\xF7\x65\x7E\xBA\x2C\x47\x52\x12\x43\xE9\x44\xAF\x2A\x4F\x37\x6E\x30\x4F\xBB\x8E\x0F\xD2\x91\xB9\x16\xD5\xF3\x73\xD3\x90\xE3\x48\xAA\x57\xB6\x78\xC3\xC3\x6E\xA0\x3B\x72\xC1\x92\xA9\x79\xA1\xA7\x5F\x0B\x53\x8A\xA9\x47\x14\x0F\x61\x90\x3F\x51\xF0\x24\x29\x53\xCB\x40\x65\xBC\x0B\xCB\xEF\x39\x02\xAF\x13\xF4\x57\x80\xB5\xE8\x44\x6C\xD9\x6B\x05\x45\x68\xDD\x32\x91\xA5\x69\x47\x40\xCD\xBE\x4B\x08\x64\x25\x0C\x3D\x57\xCB\x16\xF1\xB7\x5F\xCE\xA5\xE9\x40\xAF\x8C\x40\x21\x90\x32\x18\x39\x87\x23\x76\xA0\xF2\x6E\x27\x47\xFD\x8B\xBA\x60\x3A\xA1\x42\x20\xBA\x91\x56\x86\x4E\xDC\x85\x95\x1A\x34\xF1\xE6\x7C\x60\x26\x1C\xFE\x0E\x28\xBD\xA7\xB9\xBF\x67\x1C\x41\x25\xE3\x7A\x8D\xE5\x53\x6A\xD5\x7E\x10\xA2\xC1\x7F\x16\x28\x33\xFC\x47\x0C\xCB\xDE\x1D\xFB\x62\xBA\x70\x96\xE1\xAB\x76\xD1\x5B\x03\x56\x4C\x41\xA6\xF5\x33\x83\x88\x69\x4D\xBF\x93\xD1\xBB\x9B\xDC\xFE\x01\x51\x90\x30\x2B\x44\x5E\xBA\x6C\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", vector(32, 27))
    
    visuals.render_gradient_text = function(font, text, colors, add_y, bomb)
        local measure_text = render.measure_text(font, nil, text).x

        if menu.visuals.gamesense_indicators.style:get() == "Classic" then
            render.gradient(vector(30 + measure_text / 2, screen_y - 310 - add_y), vector(45 + (bomb and bomb_img.width or 0) + measure_text, screen_y - 275 - add_y), color(0, 0, 0, colors.a - 190), color(0, 0, 0, 0), color(0, 0, 0, colors.a - 190), color(0, 0, 0, 0))
            render.gradient(vector(30 + measure_text / 2, screen_y - 310 - add_y), vector(15, screen_y - 275 - add_y), color(0, 0, 0, colors.a - 190), color(0, 0, 0, 0), color(0, 0, 0, colors.a - 190), color(0, 0, 0, 0))
            render.text(font, vector(30 + (bomb and bomb_img.width + 5 or 0), screen_y - 303 - add_y), colors, nil, text)
        else
            render.gradient(vector(10, screen_y - 310 - add_y), vector(45 + (bomb and bomb_img.width or 0) + measure_text, screen_y - 275 - add_y), color(0, 0, 0, colors.a - 190), color(0, 0, 0, 0), color(0, 0, 0, colors.a - 190), color(0, 0, 0, 0))
            render.rect(vector(10, screen_y - 275 - add_y), vector(15, screen_y - 310 - add_y), colors, 0, true)
            render.text(font, vector(30 + (bomb and bomb_img.width + 5 or 0), screen_y - 303 - add_y), colors, nil, text)
        end

        if bomb then
            render.texture(bomb_img, vector(30, screen_y - 307 - add_y), colors)
        end
    end

    local watermark_image = render.load_image(network.get("https://i.pinimg.com/736x/6f/26/8e/6f268e552dcfbd59727b4675ca2009da.jpg"))

    visuals.watermark = function()
        local lp = entity.get_local_player()
        if lp == nil then return end

        local neverlose_username = common.get_username()
        if neverlose_username == nil then return end
    
        local net_channel = utils.net_channel()
        if net_channel == nil then return end

        local latency = net_channel.avg_latency[1] * 1000

        local watermark_color = menu.visuals.watermark.watermark_color:get()

        local neverlose_username = common.get_username()

        local measure_username = render.measure_text(2, nil, neverlose_username:upper())

        if not menu.visuals.watermark:get() then 
            if not menu.visuals.centered_indicators:get() then
                render.text(4, vector(screen_x / 2, screen_y - 15), color(255), "c", "*ੈ✩‧₊˚༺ nyahook ༻*ੈ✩‧₊˚")
            end
        else
            if menu.visuals.watermark.style:get() == "Modern" then 
                render.texture(watermark_image, vector(10, screen_y / 2 + 25), vector(25, 25))
    
                render.text(2, vector(38, screen_y / 2 + 26), color(255, 180, 226, 255), nil, "NYA")
                render.text(2, vector(render.measure_text(2, nil, "nya").x + 38, screen_y / 2 + 26), color(255), nil, "HOOK [DEBUG]")
                render.text(2, vector(38, screen_y / 2 + 36), color(255), nil, "USERNAME: " .. neverlose_username:upper())
            elseif menu.visuals.watermark.style:get() == "Classic" then
                local time = common.get_system_time()
                local time_text = string.format('%02d:%02d:%02d', time.hours, time.minutes, time.seconds)

                local watermark_text = "Nyahook | ".. common.get_username() .." | delay: ".. math.floor(latency) .."ms | ".. time_text ..""

                render.rect(vector(screen_x - 15 - render.measure_text(1, nil, watermark_text).x, 8), vector(screen_x - 7, 10), color(menu.visuals.watermark.watermark_color:get().r, menu.visuals.watermark.watermark_color:get().g, menu.visuals.watermark.watermark_color:get().b, 150), 0)
                render.rect(vector(screen_x - 15 - render.measure_text(1, nil, watermark_text).x, 10), vector(screen_x - 7, 30), color(10, 10, 10, 105), 0)

                render.text(1, vector(screen_x - render.measure_text(1, nil, watermark_text).x - 10, 13), color(255, 255, 255, 255), nil, watermark_text)
            elseif menu.visuals.watermark.style:get() == "Minimalistic" then
                render.text(1, vector(screen_x - render.measure_text(1, nil, "nyahook ~ debug : username: " .. common.get_username()).x - 7, 5), watermark_color, nil, "nya")
                render.text(1, vector(screen_x - render.measure_text(1, nil, "hook ~ debug : username: " .. common.get_username()).x - 7, 5), color(255), nil, "hook ~ debug : username: " .. common.get_username())
                render.text(1, vector(screen_x - render.measure_text(1, nil, "latency: " .. math.floor(latency) .. "ms").x - 7, 15), color(255), nil, "latency: " .. math.floor(latency) .. "ms")
            end
        end
    end

    local drag_keybinds do
        local total_dist = 0
        drag.new("keybinds", nil, vector(300, 400), nil)(function(drag)
            if not menu.visuals.keybinds:get() then return end
            
            local binds = ui.get_binds()
            local add_y_binds = 0
            local last_bind_spacing = 0
            local measure_y = 0
            local binds_mode = ""
            local bind_spacing = 0
            local bind_name = ""
            local active = false
            local maximum_offset = 150

            for k, v in pairs(binds) do
                if v.active ~= nil then
                    active = true
                else
                    active = false
                end

                if v.name == "Double Tap" then
                    bind_name = "Double Nya"
                    binds_mode = v.mode == 1 and "holding" or "toggled"
                elseif v.name == "Hide Shots" then
                    bind_name = "Hide Nya"
                    binds_mode = v.mode == 1 and "holding" or "toggled"
                elseif v.name == "Min. Damage" then
                    bind_name = "Min. Nya"
                    binds_mode = v.value
                else
                    bind_name = v.name
                    binds_mode = v.mode == 1 and "holding" or "toggled"
                end

                measure_y = render.measure_text(1, nil, bind_name).y
            
                local animated_add_y_binds = animations.new("animated_add_y_" .. bind_name, v.active and 255 or 0, 0.1)
                
                add_y_binds = add_y_binds + (k ~= 1 and 14 or 10) * animated_add_y_binds / 255

                if (render.measure_text(1, nil, "[".. binds_mode .."]").x + render.measure_text(1, nil, bind_name).x) > bind_spacing then
                    bind_spacing = (render.measure_text(1, nil, "[".. binds_mode .."]").x + render.measure_text(1, nil, bind_name).x)
                end

                maximum_offset = maximum_offset < bind_spacing and bind_spacing or maximum_offset

                render.text(1, vector(drag.position.x + 2, drag.position.y + add_y_binds + 10), color(255, 255, 255, animated_add_y_binds), nil, bind_name)
                render.text(1, vector(drag.position.x + maximum_offset - render.measure_text(1, nil, "[".. binds_mode .."]").x, drag.position.y + add_y_binds + 10), color(255, 255, 255, animated_add_y_binds), nil, "[".. binds_mode .."]")
            end

            total_dist = maximum_offset

            local animated_alpha_rect = animations.new("animated_alpha_rect", ui.get_alpha() > 0 and 255 or active and 255 or 0, 0.1)

            render.rect(drag.position, drag.position - 2 + vector(total_dist, 0) + vector(2, 20), color(10, 10, 10, animated_alpha_rect - 150), 1)
            render.rect(drag.position, drag.position - 2 - vector(0, 20) + vector(total_dist + 2, 0), color(menu.visuals.keybinds.keybinds_color:get().r, menu.visuals.keybinds.keybinds_color:get().g, menu.visuals.keybinds.keybinds_color:get().b, animated_alpha_rect), 1)
            render.text(1, vector(drag.position.x + total_dist / 2 - 20, drag.position.y + 3), color(255, 255, 255, animated_alpha_rect), nil, "keybinds")
        
            drag.size = vector(total_dist, 20)
        end)
    end

    local drag_spectators do 
        local total_dist = 0
        local maximum_offset = 150
        drag.new("spectators", nil, vector(500, 400), nil)(function(drag)
            get_spectators = function()
                local lp = entity.get_local_player()
                if lp == nil then return end
            
                if lp:is_alive() then
                    return lp:get_spectators()
                end
            
                local observer_target = lp.m_hObserverTarget
            
                if observer_target ~= nil then
                    return observer_target:get_spectators()
                end
            end

            if not menu.visuals.spectators:get() then return end

            local spectators = get_spectators()
            if spectators == nil then return end

            local add_y_spectators = 0
            local measure_y = 0
            local spectators_spacing = 0
            local animated_spectators = 0

            for k, v in pairs(spectators) do
                local name = v:get_name()
                local avatar = v:get_steam_avatar()
                
                measure_y = render.measure_text(1, nil, name).y

                animated_spectators = animations.new("animated_spectators_" .. name, #spectators > 0 and 255 or 0, 0.1)
                
                add_y_spectators = add_y_spectators + 18 * animated_spectators / 255
                
                if (render.measure_text(1, nil, name).x + 16) > spectators_spacing then
                    spectators_spacing = render.measure_text(1, nil, name).x + 16
                end

                maximum_offset = maximum_offset < spectators_spacing and spectators_spacing or maximum_offset

                render.text(1, vector(drag.position.x + 25, drag.position.y + add_y_spectators + 4), color(255, 255, 255, animated_spectators), nil, name)
                render.texture(avatar, vector(drag.position.x + 2, drag.position.y + add_y_spectators + 2), vector(16, 16), color(255, 255, 255, animated_spectators), "", 4)
            end

            total_dist = maximum_offset

            local animated_alpha_rect = animations.new("animated_alpha_rect_spectators", ui.get_alpha() > 0 and 255 or #spectators > 0 and 255 or 0, 0.1)

            render.rect(drag.position, drag.position - 2 + vector(total_dist, 20), color(10, 10, 10, animated_alpha_rect - 150), 1)
            render.rect(drag.position, drag.position - 2 - vector(0, 20) + vector(total_dist, 0), color(menu.visuals.spectators.spectators_color:get().r, menu.visuals.spectators.spectators_color:get().g, menu.visuals.spectators.spectators_color:get().b, animated_alpha_rect), 1)
            render.text(1, vector(drag.position.x + total_dist / 2 - 28 + 2, drag.position.y + 3), color(255, 255, 255, animated_alpha_rect), nil, "spectators")

            drag.size = vector(total_dist, 20)
        end)
    end

    local drag_velocity_indicator do
        drag.new("velocity", 2, vector(screen_x / 2 - 100, 200), {
            {"x", vector(screen_x * 0.5, 0), vector(screen_x * 0.5, screen_y)}
        })(function(drag)
            local lp = entity.get_local_player()
            if lp == nil or not lp:is_alive() then return end
    
            if not menu.visuals.velocity_indicator:get() then return end
    
            local velocity_modifier = animations.new("velocity_modifier2", ui.get_alpha() > 0 and lp.m_flVelocityModifier * 0.5 or lp.m_flVelocityModifier, 0.05)
    
            local velocity_alpha = animations.new("velocity_alpha", ui.get_alpha() > 0 and 255 or (lp.m_flVelocityModifier < 1 and 255 or 0), 0.1)
    
            render.text(1, drag.position + vector(100, 10), color(255, 255, 255, velocity_alpha), "c", string.format("Max velocity reduced by %s%%", math.floor(velocity_modifier * 100)))
            render.rect(vector(drag.position.x + 5, drag.position.y + 19), vector(drag.position.x - 5 + 200, drag.position.y + 22), color(0, 0, 0, velocity_alpha), 0)
            render.rect(vector(drag.position.x + 5, drag.position.y + 19), vector(drag.position.x - 5 + math.floor(velocity_modifier * 200), drag.position.y + 22), color(menu.visuals.velocity_indicator.velocity_indicator_color:get().r, menu.visuals.velocity_indicator.velocity_indicator_color:get().g, menu.visuals.velocity_indicator.velocity_indicator_color:get().b, velocity_alpha), 0)
        
            drag.size = vector(200, 30)
        end)
    end

    visuals.total_hits, visuals.total_registered_shots = 0, 0

    visuals.gamesense_indicators = function()
        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end

        if not menu.visuals.gamesense_indicators:get() then return end

        local add_y_gamesense = 0
        local add_y_gamesense_bomb = 0

        local is_animated = menu.visuals.gamesense_indicators.animated:get()

        local charged_color = is_animated and animations.new("charged_color", rage.exploit:get() == 1 and color(200) or color(255, 0, 0), 0.05) or (rage.exploit:get() == 1 and color(200) or color(255, 0, 0))

        local can_dormant = #entity.get_players(true, false) ~= #entity.get_players(true, true)

        local dormant_color = animations.new("dormant_color", can_dormant and color(200) or color(255, 0, 0), 0.05)

        visuals.percent = visuals.total_hits > 0 and visuals.total_registered_shots > 0 and (visuals.total_hits / visuals.total_registered_shots) * 100 or 0

        local is_modern = menu.visuals.gamesense_indicators.style:get() == "Modern"

        local icons_text = {
            "",
            (rage.exploit:get() == 1 and "" or ""),
            "",
            "",
            "",
            "",
            "",
            "",
            ""
        }

        local indicators_text = {
            { "Meow", color(200), menu.visuals.gamesense_indicators.select:get("Hit/Miss Rate") },
            { "DT", color(charged_color.r, charged_color.g, charged_color.b, 255), menu.visuals.gamesense_indicators.select:get("Double Tap") and refs.doubletap:get() },
            { "OS-AA", color(200), menu.visuals.gamesense_indicators.select:get("Hide Shots") and refs.hide_shots:get() and not refs.doubletap:get() },
            { "PING", color(150, 190, 50, 255), menu.visuals.gamesense_indicators.select:get("Fake Latency") and refs.fake_latency:get() > 0 },
            { "MD", color(200), menu.visuals.gamesense_indicators.select:get("Min. Damage Override") and visuals.get_bind("Min. Damage")[1] },
            { "BODY", color(200), menu.visuals.gamesense_indicators.select:get("Body Aim") and refs.body_aim:get() == "Force" },
            { "SAFE", color(200), menu.visuals.gamesense_indicators.select:get("Force Safe Point") and refs.safe_point:get() == "Force" },
            { "FS", color(200), menu.visuals.gamesense_indicators.select:get("Freestanding") and refs.freestanding:get_override() },
            { "DA", color(dormant_color.r, dormant_color.g, dormant_color.b, 255), menu.visuals.gamesense_indicators.select:get("Dormant Aimbot") and refs.dormant_aimbot:get() },
        }

        local bomb_alpha = is_animated and animations.new("bomb_alpha", menu.visuals.gamesense_indicators.select:get("Bomb Information") and bomb.state ~= nil and 255 or 0 or 0, 0.05) or (bomb.state ~= nil and 255 or 0)
        local bomb_alpha_damage = is_animated and animations.new("bomb_alpha_damage", menu.visuals.gamesense_indicators.select:get("Bomb Information") and bomb.dmg == "-0 HP" and 0 or bomb.state == true and 255 or 0 or 0, 0.05) or (bomb.dmg == "-0 HP" and 0 or bomb.state == true and 255 or 0) 
        local bomb_circle_alpha = is_animated and animations.new("bomb_circle_alpha", menu.visuals.gamesense_indicators.select:get("Bomb Information") and bomb.state == false and 255 or 0 or 0, 0.05) or (bomb.state == false and 255 or 0)

        add_y_gamesense = add_y_gamesense + 41 * bomb_alpha / 255
        add_y_gamesense = add_y_gamesense + 41 * bomb_alpha_damage / 255

        local hit_miss_text = string.format("%d/%d (%.1f)", visuals.total_hits, visuals.total_registered_shots, visuals.percent)

        for k, v in pairs(indicators_text) do
            local gamesense_alpha = is_animated and animations.new("animated_alpha_gamesense_" .. v[1], v[3] and 255 or 0, 0.05) or (v[3] and 255 or 0)

            add_y_gamesense = add_y_gamesense + 41 * gamesense_alpha / 255

            if gamesense_alpha > 0 then
                visuals.render_gradient_text(visuals.fonts.calibri_bold, (is_modern and (icons_text[k] .. "  ") or "") .. (v[1] == "Meow" and hit_miss_text or v[1]), color(v[2].r, v[2].g, v[2].b, gamesense_alpha), add_y_gamesense, false)
            end
        end

        if bomb.state ~= nil and bomb.site ~= nil then 
            local bomb_site = bomb.state ~= nil and (bomb.site == "B" and "B" or "A") or bomb.site
            local bomb_text = bomb.state == true and bomb_site .. " - " .. string.format("%.1f", bomb.c4time) .. "s" or bomb_site
    
            add_y_gamesense_bomb = add_y_gamesense_bomb + 41 * bomb_alpha / 255
            add_y_gamesense_bomb_damage = add_y_gamesense_bomb + 41 * bomb_alpha_damage / 255
    
            local bomb_color = is_animated and animations.new("bomb_color", menu.visuals.gamesense_indicators.select:get("Bomb Information") and bomb.state == false and color(255, 240, 140) or color(200) or 0, 0.05) or (bomb.state == false and color(255, 240, 140) or color(200))
            local bomb_damage_color = is_animated and animations.new("bomb_damage_color", menu.visuals.gamesense_indicators.select:get("Bomb Information") and bomb.dmg == "FATAL" and color(255, 0, 0) or color(255, 240, 100) or 0, 0.05) or (bomb.dmg == "FATAL" and color(255, 0, 0) or color(255, 240, 100))
    
            visuals.render_gradient_text(visuals.fonts.calibri_bold, bomb.dmg, color(bomb_damage_color.r, bomb_damage_color.g, bomb_damage_color.b, bomb_alpha_damage), add_y_gamesense_bomb_damage, false)
            visuals.render_gradient_text(visuals.fonts.calibri_bold, bomb_text, color(bomb_color.r, bomb_color.g, bomb_color.b, bomb_alpha), add_y_gamesense_bomb, true)
    
            render.circle_outline(vector(50 + bomb_img.width + render.measure_text(visuals.fonts.calibri_bold, nil, bomb_text).x, screen_y - 292 - add_y_gamesense_bomb), color(0, 0, 0, bomb_circle_alpha), 10, 0, 1, 3)
            render.circle_outline(vector(50 + bomb_img.width + render.measure_text(visuals.fonts.calibri_bold, nil, bomb_text).x, screen_y - 292 - add_y_gamesense_bomb), color(200, 200, 200, bomb_circle_alpha), 10, 0, bomb.plant_percentage, 3)
        end
    end

    visuals.centered_indicators = function()
        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end

        if not menu.visuals.centered_indicators:get() then return end
    
        local add_y = 0
    
        local scoped = lp.m_bIsScoped
        local scope_add = animations.new("scope_add", scoped and 105 or 0, 0.05)
        local scoped_value = math.min(scope_add, 100) / 100

        local state = anti_aim.player_data.stateid
        if state == nil then return end
    
        local measure_text_label = render.measure_text(2, "c", "N Y A H O O K").x
        local measure_text_state = render.measure_text(2, nil, menu.anti_aim_conditions[state]:upper()).x

        local accent_color = menu.visuals.centered_indicators.centered_indicators_color:get()

        local offset_y = menu.visuals.centered_indicators.offset:get()

        render.text(2, vector(screen_x / 2 + ((measure_text_label + 5) / 2) * scoped_value, screen_y / 2 + 20 + offset_y), color(255), "c", visuals.animated_text("N Y A H O O K", -1, color(90, 90, 90, scoped and 150 or 255), accent_color, 255))
        
        local animated_measure = animations.new("measured_state", measure_text_state, 0.2)
    
        visuals.crosshair_indicators_tbl = {
            { "DT", refs.doubletap:get() },
            { "OS-AA", not refs.doubletap:get() and refs.hide_shots:get() },
            { "DMG", visuals.get_bind("Min. Damage")[1] },
        }
    
        for k, v in ipairs(visuals.crosshair_indicators_tbl) do
            local measure_text_binds = render.measure_text(2, nil, v[1]).x
            local alpha_key = animations.new("bind_" .. v[1], v[2] and 255 or 0, 0.05)
            local alpha = math.min(alpha_key, 100) / 100

            add_y = add_y + 10 * alpha
    
            if alpha > 0.01 then
                render.text(2, vector(screen_x / 2 + ((measure_text_binds + 5) / 2) * scoped_value, screen_y / 2 + 20 + add_y + offset_y), color(255, 255, 255, (scoped and 150 or 255) * alpha), "c", v[1])
            end
        end

        render.text(2, vector(screen_x / 2 - (animated_measure / 2) + ((animated_measure / 2) + 2) * scoped_value, screen_y / 2 + 24 + add_y + offset_y), color(255, 255, 255, scoped and 150 or 255), nil, menu.anti_aim_conditions[state]:upper())
    end

    visuals.manual_arrows = function()
        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end

        if not menu.visuals.manual_arrows:get() then return end

        local arrows_color = menu.visuals.manual_arrows.arrows_color:get()

        local scoped = lp.m_bIsScoped

        local manual_arrows_refs = {
            r1 = animations.new("r1", menu.anti_aim.manual_yaw:get() == "Right" and arrows_color.r or 255, 0.1),
            g1 = animations.new("g1", menu.anti_aim.manual_yaw:get() == "Right" and arrows_color.g or 255, 0.1),
            b1 = animations.new("b1", menu.anti_aim.manual_yaw:get() == "Right" and arrows_color.b or 255, 0.1),
    
            r2 = animations.new("r2", menu.anti_aim.manual_yaw:get() == "Left" and arrows_color.r or 255, 0.1),
            g2 = animations.new("g2", menu.anti_aim.manual_yaw:get() == "Left" and arrows_color.g or 255, 0.1),
            b2 = animations.new("b2", menu.anti_aim.manual_yaw:get() == "Left" and arrows_color.b or 255, 0.1),
    
            alpha = animations.new("a1", scoped and 0 or menu.anti_aim.manual_yaw:get() ~= "Disabled" and 255 or 0, 0.1)
        }

        if ui.get_alpha() > 0 then
            if menu.visuals.manual_arrows.arrows_style:get() == "Classic" then
                render.text(visuals.fonts.verdana_bold, vector(screen_x / 2 + menu.visuals.manual_arrows.offset:get(), screen_y / 2), color(manual_arrows_refs.r1, manual_arrows_refs.g1, manual_arrows_refs.b1, ui.get_alpha() * 200), "c", ">")
                render.text(visuals.fonts.verdana_bold, vector(screen_x / 2 - menu.visuals.manual_arrows.offset:get() + 2, screen_y / 2), color(manual_arrows_refs.r2, manual_arrows_refs.g2, manual_arrows_refs.b2, ui.get_alpha() * 200), "c", "<")
            else
                render.text(visuals.fonts.verdana, vector(screen_x / 2 + menu.visuals.manual_arrows.offset:get(), screen_y / 2), color(manual_arrows_refs.r1, manual_arrows_refs.g1, manual_arrows_refs.b1, ui.get_alpha() * 200), "c", "❱")
                render.text(visuals.fonts.verdana, vector(screen_x / 2 - menu.visuals.manual_arrows.offset:get() + 2, screen_y / 2), color(manual_arrows_refs.r2, manual_arrows_refs.g2, manual_arrows_refs.b2, ui.get_alpha() * 200), "c", "❰")
            end
        else
            if menu.visuals.manual_arrows.arrows_style:get() == "Classic" then
                render.text(visuals.fonts.verdana_bold, vector(screen_x / 2 + menu.visuals.manual_arrows.offset:get(), screen_y / 2), color(manual_arrows_refs.r1, manual_arrows_refs.g1, manual_arrows_refs.b1, manual_arrows_refs.alpha), "c", ">")
                render.text(visuals.fonts.verdana_bold, vector(screen_x / 2 - menu.visuals.manual_arrows.offset:get() + 2, screen_y / 2), color(manual_arrows_refs.r2, manual_arrows_refs.g2, manual_arrows_refs.b2, manual_arrows_refs.alpha), "c", "<")
            else
                render.text(visuals.fonts.verdana, vector(screen_x / 2 + menu.visuals.manual_arrows.offset:get(), screen_y / 2), color(manual_arrows_refs.r1, manual_arrows_refs.g1, manual_arrows_refs.b1, manual_arrows_refs.alpha), "c", "❱")
                render.text(visuals.fonts.verdana, vector(screen_x / 2 - menu.visuals.manual_arrows.offset:get() + 2, screen_y / 2), color(manual_arrows_refs.r2, manual_arrows_refs.g2, manual_arrows_refs.b2, manual_arrows_refs.alpha), "c", "❰")
            end
        end
    end

    local drag_damage_indicator do
        drag.new("damage_indicator", 2, vector(screen_x / 2 + 3, screen_y / 2 - 20), nil,
        {
            screen_size * 0.5 - vector(50, 50),
            screen_size * 0.5 + vector(50, 50)
        })(function(drag)
            local lp = entity.get_local_player()
            if lp == nil or not lp:is_alive() then return end

            if not menu.visuals.damage_indicator:get() then return end
            
            local weapon_damage = refs.minimum_damage:get() > 0 and refs.minimum_damage:get() or "AUTO"

            local font = 
            {
                ["Default"] = 1,
                ["Pixel"] = 2,
                ["Bold"] = 4
            }
            
            render.text(font[menu.visuals.damage_indicator.font:get()], drag.position + vector(4, 3), color(255), nil, weapon_damage)

            drag.size = vector(render.measure_text(font[menu.visuals.damage_indicator.font:get()], nil, weapon_damage).x + 8, 18)
        end)
    end

    visuals.custom_scope_overlay = function() 
        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end

        if not menu.visuals.custom_scope_overlay:get() then 
            refs.override_zoom.force_viewmodel:override(false)
            refs.override_zoom.scope_overlay:override("Remove Overlay")

            return 
        end

        if menu.visuals.custom_scope_overlay:get() then
            refs.override_zoom.scope_overlay:override("Remove All")
        else
            refs.override_zoom.scope_overlay:override("Remove Overlay")
        end

        if menu.visuals.custom_scope_overlay.viewmodel_in_scope:get() then
            refs.override_zoom.force_viewmodel:override(true)
        else
            refs.override_zoom.force_viewmodel:override(false)
        end

        size_scope_overlay = animations.new("size_scope_overlay", lp.m_bIsScoped and menu.visuals.custom_scope_overlay.size:get() or 0, 0.1) 
        gap_scope_overlay = animations.new("gap_scope_overlay", lp.m_bIsScoped and menu.visuals.custom_scope_overlay.gap:get() or 0, 0.1) 

        first_scope_color = color(menu.visuals.custom_scope_overlay.scope_color:get().r, menu.visuals.custom_scope_overlay.scope_color:get().g, menu.visuals.custom_scope_overlay.scope_color:get().b, menu.visuals.custom_scope_overlay.inverted:get() and 0 or menu.visuals.custom_scope_overlay.scope_color:get().a)
		second_scope_color = color(menu.visuals.custom_scope_overlay.scope_color:get().r, menu.visuals.custom_scope_overlay.scope_color:get().g, menu.visuals.custom_scope_overlay.scope_color:get().b, menu.visuals.custom_scope_overlay.inverted:get() and menu.visuals.custom_scope_overlay.scope_color:get().a or 0)
 
        render.gradient(vector(screen_x / 2 - gap_scope_overlay + 1, screen_y / 2), vector(screen_x / 2 - gap_scope_overlay - size_scope_overlay, screen_y / 2 + 1), first_scope_color, second_scope_color, first_scope_color, second_scope_color)
        render.gradient(vector(screen_x / 2 + gap_scope_overlay, screen_y / 2), vector(screen_x / 2 + gap_scope_overlay + size_scope_overlay, screen_y / 2 + 1), first_scope_color, second_scope_color, first_scope_color, second_scope_color)
        render.gradient(vector(screen_x / 2, screen_y / 2 + gap_scope_overlay + 1), vector(screen_x / 2 + 1, screen_y / 2 + gap_scope_overlay + size_scope_overlay), first_scope_color, first_scope_color, second_scope_color, second_scope_color)
        
        if not menu.visuals.custom_scope_overlay.t_pose:get() then
            render.gradient(vector(screen_x / 2, screen_y / 2 - gap_scope_overlay), vector(screen_x / 2 + 1, screen_y / 2 - gap_scope_overlay - size_scope_overlay), first_scope_color, first_scope_color, second_scope_color, second_scope_color)
        end
    end

    visuals.hitmarker_refs = {
        hitmarker_alpha = 255,
        hitmarker_ack = function(e)
            local target = entity.get(e.target)
            if not target or target == nil then return end
    
            if e.state == nil then
                shot_hit = true
                visuals.hitmarker_refs.hitmarker_alpha = 255        
            end
        end
    }

    visuals.hitmarker = function() 
        if not menu.visuals.hitmarker:get() then return end

        if shot_hit then 
            visuals.hitmarker_refs.hitmarker_alpha = visuals.hitmarker_refs.hitmarker_alpha - 1

            if visuals.hitmarker_refs.hitmarker_alpha < 25 then 
                shot_hit = false 
            end
        end

        if shot_hit then
            render.line(vector(screen_x / 2 - 4 * 2, screen_y / 2 - 4 * 2), vector(screen_x / 2 - ( 4 ), screen_y / 2 - ( 4 )), color(menu.visuals.hitmarker.hitmarker_color:get().r, menu.visuals.hitmarker.hitmarker_color:get().g, menu.visuals.hitmarker.hitmarker_color:get().b, visuals.hitmarker_refs.hitmarker_alpha))
            render.line(vector(screen_x / 2 - 4 * 2, screen_y / 2 + 4 * 2), vector(screen_x / 2 - ( 4 ), screen_y / 2 + ( 4 )), color(menu.visuals.hitmarker.hitmarker_color:get().r, menu.visuals.hitmarker.hitmarker_color:get().g, menu.visuals.hitmarker.hitmarker_color:get().b, visuals.hitmarker_refs.hitmarker_alpha))
            render.line(vector(screen_x / 2 + 4 * 2, screen_y / 2 + 4 * 2), vector(screen_x / 2 + ( 4 ), screen_y / 2 + ( 4 )), color(menu.visuals.hitmarker.hitmarker_color:get().r, menu.visuals.hitmarker.hitmarker_color:get().g, menu.visuals.hitmarker.hitmarker_color:get().b, visuals.hitmarker_refs.hitmarker_alpha))
            render.line(vector(screen_x / 2 + 4 * 2, screen_y / 2 - 4 * 2), vector(screen_x / 2 + ( 4 ), screen_y / 2 - ( 4 )), color(menu.visuals.hitmarker.hitmarker_color:get().r, menu.visuals.hitmarker.hitmarker_color:get().g, menu.visuals.hitmarker.hitmarker_color:get().b, visuals.hitmarker_refs.hitmarker_alpha))
        end
    end

    visuals.animated_zoom = function(e)
        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end
    
        local weapon = lp:get_player_weapon()
        if weapon == nil then return end
    
        local zoom_level = weapon.m_zoomLevel
        local scoped = lp.m_bIsScoped

        local zoom_fov = 0

        if not menu.visuals.animated_zoom:get() then return end
    
        if scoped then
            if zoom_level == 1 then
                zoom_fov = refs.override_zoom:get()
            elseif zoom_level == 2 then
                zoom_fov = refs.override_zoom:get() * 2
            end
        end
    
        local animated_fov = animations.new("animated_fov", refs.field_of_view:get() - zoom_fov)

        e.fov = animated_fov
    end

    visuals.client_side_animations = function()
        local lp = entity.get_local_player()
        if lp == nil or not lp:is_alive() then return end
        if lp:get_index() == nil then return end

        if not menu.visuals.client_side_animations:get() then return end
        
        animslsg = get_entity_address(lp:get_index())
    
        local animstate = lp:get_anim_state()
        if animstate == nil then return end
    
        move = math.sqrt(lp.m_vecVelocity.x ^ 2 + lp.m_vecVelocity.y ^ 2) > 5
        jump = bit.band(lp.m_fFlags, 1) == 0

        if menu.visuals.client_side_animations.ground_legs:get() == "Reversed" then
            lp.m_flPoseParameter[0] = 1
            refs.legs_movement:override("Sliding")
        elseif menu.visuals.client_side_animations.ground_legs:get() == "Jitter" then
            lp.m_flPoseParameter[0] = utils.random_float(0.1, 1.0)
            refs.legs_movement:override("Sliding")
        elseif menu.visuals.client_side_animations.ground_legs:get() == "Moonwalk" and move and not jump then
            lp.m_flPoseParameter[7] = 1
            refs.legs_movement:override("Walking")
        end
    
        if menu.visuals.client_side_animations.air_legs:get() == "Static" then
            lp.m_flPoseParameter[6] = 1
        elseif menu.visuals.client_side_animations.air_legs:get() == "Jitter" then
            lp.m_flPoseParameter[6] = globals.tickcount % 4 > 1 and math.random(math.random(0.1, 5), 5) / 10 or math.random(0.1, 1)
        elseif menu.visuals.client_side_animations.air_legs:get() == "Moonwalk" and jump and move then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][6].m_flWeight = 1
        else
            lp.m_flPoseParameter[6] = 0
        end
    
        if menu.visuals.client_side_animations.addons:get("Pitch Zero On Land") and animstate.landing then
            lp.m_flPoseParameter[12] = 0.5
        elseif menu.visuals.client_side_animations.addons:get("Move Lean") and move then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][12].m_flWeight = menu.visuals.client_side_animations.move_lean_amount:get() / 100
        elseif menu.visuals.client_side_animations.addons:get("Earthquake") then
            ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', animslsg) + 0x2990)[0][12].m_flWeight = utils.random_float(0.1, 1)
        end
    end

    visuals.grenade_warning = function(e)
        local lp = entity.get_local_player()
        if lp == nil then return end

        if not menu.visuals.grenade_warning:get() then return end
    
        local entity = e.entity
        if entity == nil then return end
    
        local grenade_origin = e.origin
        local grenade_origin_screen = grenade_origin:to_screen() or render.get_offscreen(grenade_origin, 1, true)
        
        local grenade_icon = e.icon
        local grenade_type = e.type
    
        local grenade_damage = e.damage
    
        local lp_origin = lp:get_origin()

        local distance_to_grenade = lp_origin:dist(grenade_origin)
    
        local closest_point = lp_origin:dist(e.closest_point)
    
        local grenade_time = e.expire_time - globals.curtime
    
        local adjust_position = {
            ["Molly"] = entity:get_classname() == "CMolotovProjectile" and vector(5, 22) or vector(13, 20),
            ["Frag"] = vector(7, 20)
        }
    
        local adjust_text = {
            ["Molly"] = tostring(math.floor(closest_point * 0.08128)),
            ["Frag"] = grenade_damage
        }
    
        local adjust_timer = {
            ["Molly"] = entity:get_classname() == "CMolotovProjectile" and grenade_time * (1 / 1.5) or grenade_time * (1 / 7.125),
            ["Frag"] = grenade_time * (1 / 1.5)
        }

        local grenade_gradient = {
            ["Molly"] = distance_to_grenade < 220 and 60 or 0,
            ["Frag"] = grenade_damage > lp.m_iHealth and 60 or 0
        }

        render.circle(grenade_origin_screen, color(10, 10, 10, 220), 30, 0, 1)

        render.shadow(grenade_origin_screen, grenade_origin_screen + 1, color(255, 0, 0, 255), grenade_gradient[grenade_type], 1, 100)
        render.shadow(grenade_origin_screen, grenade_origin_screen + 1, color(255, 0, 0, 255), grenade_gradient[grenade_type], 1, 100)
        render.shadow(grenade_origin_screen, grenade_origin_screen + 1, color(255, 0, 0, 255), grenade_gradient[grenade_type], 1, 100)
        render.shadow(grenade_origin_screen, grenade_origin_screen + 1, color(255, 0, 0, 255), grenade_gradient[grenade_type], 1, 100)

        render.circle_outline(grenade_origin_screen, color(255), 30, 0, adjust_timer[grenade_type], 2)
    
        render.texture(grenade_icon, grenade_origin_screen - adjust_position[grenade_type], color(255))
        render.text(4, grenade_origin_screen + vector(0, 13), color(255, 255, 255, 255), "c", adjust_text[grenade_type])
    
        return false
    end
end

local misc = { } do
    misc.super_toss_references = {
        get_throw_toss = function(goal_angles, throw_velocity, throw_strength, abs_velocity)
            goal_angles.x = goal_angles.x - 10 + math.abs(goal_angles.x) / 9
    
            local goal_forward = vector():angles(goal_angles)
            local player_vel = abs_velocity * 1.25
    
            local vel = math.clamp(throw_velocity * 0.9, 15, 750)
            local clamped_throw_strength = math.clamp(throw_strength, 0, 1)
    
            vel = vel * math.lerp(0.3, 1.0, clamped_throw_strength)
    
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
    }

    misc.in_game = {
        trashtalk = {
            phrases = {
                "так слышь я не понимаю ты хуй сосёшь же пидр",
                "броук ебанный",
                "ты чё девка ебанная хуя не сосала моего давно да",
                "действительно офк не насасывай чмошник",
                "ща я тебе чисто мать тут поебу сынищка ебанная",
                "просто тебе тут хуем по лбу стучать буду",
                "давай не гори целочный хуесос",
                "какой же нахуй позор",
                "давай быстрее",
                "те тут мать ебали чел",
                "пидорас ты же обосраный сидишь с трусами на голове хуесос ебанный интернетный",
                "ты чё тут ебало открывешь нахуй даун ебанный",
                "слышь хуй лови",
                "ты долбаеб без нижнего ряда зубов родился",
                "хуй держи",
                "говорю хуй соси ау",
                "да лан всё не соси",
                "ебу тебя педик",
                "просто плевок тебе моим хуем тебе в рот",
                "фрик ебанный сука ты тут",
                "твоя мамаша шлюндра хуя сосёт пока ты пишешь",
                "давай быстрее выговаривайся целочка маленькая",
                "твой рот ща поебанн будет аххаа",
                "отца ебал те",
                "Пидр у тебя пробирка на ебле",
                "ты же комнатный дрочила ебанный",
                "забитый клещ быстрее давай",
                "сосируй тут",
                "это ты манерность из себя корчишь долбаеб 10летний",
                "сосируй там",
                "сосируй та",
                "ты же слабоумный в действительности",
                "сопливый убей себя",
                "у тебя пробка из под вина в жопе",
                "до этого долбаеба так долго все доходит пиздец",
                "ты же тут 5 минут не выдержал",
                "школьник ты ебанный рот твой поебал нормально да",
                "девочка маленькая давай быстрее там хуй насасывай",
                "фриканутая шлюшка моя ты тут?",
                "уродливый девственник быстрее давай там",
                "скуффнутый гей",
                "насилую тебя сучку",
                "сопливая чмошница",
                "ничтожный приблядок",
                "деревенский обсос",
                "жесть парни как он сосёт ахахах",
                "слабахарактерный интернетный ноулайфер",
                "офк насасывай мне бля бомж",
                "ну заводиись ток петух ебанный",
                "пидормот ебаный жмотнутый",
                "овощь ебанный затупнутый",
                "просто пиздить тебе мать буду",
                "отсталый гомосек сука",
                "жалкий пасынок индиго",
                "почему ты в себя перестал верить выблядок",
                "ты же медляк ебанный не пытайся бифиться с хуем моим",
                "жалкий выродок какой ты хуевый я  вахуе с тебя",
                "деревенский обсос",
                "лан малой слышь хуй соси",
                "я же клянусь ты пидр ебанный слабый",
                "дерьмо маленькое не соси",
                "я тебе просто ебало сломаю нахуй",
                "калека ты ебанная сука",
                "существо ебанное",
                "не соси ты уже чмошник",
                "просто ебу тебя со скоростью света",
                "давай давай дави свои 100впм дерьмо",
                "давай давай",
                "пока мамашу тебе тут ебём",
                "ты же не понимаешь что ты пидр ебанный ахахаха",
                "чильнись потухни уже хуйпачос ебанный",
                "просто пидора убью тебя ебанный хуесос нищий",
                "норм я тя с няхуком ебу слыш",
                "ＮＹＡＨＯＯＫ >>> пидорасы разлетелись",
                "Я играю с приватной луа NyaHook (◣ _ ◢)",
                "а... ты что не с няхуком? >W<",
                "ты где ходишь?",
                "Ｔｈｅ Ｂｅｓｔ ｏｆ Ｍｏｚａｒｔ",
                "sizo hvh x suprastin",
                "destroyed by infect legend",
                "by sovez1337 x santiz",
                "{2v2} Mapsat vs Kamel (scoof) & Kentry (king)",
                "𝟏 𝐝𝐚𝐲 𝐚𝐭 𝐮𝐧𝐦𝐚𝐭𝐜𝐡𝐞𝐝.𝐠𝐠 𝐅𝐞𝐚𝐭 𝐍𝐲𝐚𝐇𝐨𝐨𝐤",
                "[2ᴠ2] ʟᴇᴠᴀᴋɪɴᴅᴇʀ999 ᴠs ᴀʟʟ ᴅᴏɢs *ʀxᴅxʏxᴢ, ᴠʟᴀsᴛᴇʟɪɴ, ᴍᴀᴜᴛ, ᴋʀᴇɴᴅɪx, ʜᴇᴍsᴏ*",
                "ᛊᎶᚤᚳ ᛠᛒᛜᚿᛜ ᛖᚤᛠⰓ ᛈⰓᛁᚺ ᛞᚳᚿᛜᚷᛋ",
                "footjob - @preferbaim",
                "выруби крутилки чмо",
                "🤙 +W CONFIG BY 🤖YURI🤖",
                "FREE RAGE CFG BY SHELZY1337 ツ",
                "☢WARNING☢ REBELLION DETECTED!",
                "♚ $ bluhgang $ JS vs trash users portugals bots st1vaha,vitma,kitty,fnay,rayzen ♚",
                "Джон Гарик aka TRXSTR — Водка 2",
                "▄︻̷̿┻̿═━一 лови в еблище",
                "✿*∗˵╰༼✪ᗜ✪༽╯˵∗*✿",
                "✌(ツ) FREE ONETAP V3 CRACK / BRILAHA",
                "000.cfg",
                "Внимание! Бобёр пытался залезть по скользкой крыше в окно к девушке, которая его прикормила, но не смог и развёл лапки в сторону.",
                "LC делай братик",
            },
            trashtalk = function(e)
                local lp = entity.get_local_player()
                if lp == nil then return end
        
                if not menu.misc.in_game.trashtalk:get() then return end
        
                local lp_info = lp:get_player_info()
                if lp_info == nil then return end
        
                local player = lp_info['userid']

                local end_ptr = entity.get(e.userid, true)
        
                if e.userid ~= player and player == e.attacker then
                    utils.console_exec('say 1')

                    if end_ptr:get_xuid() == "76561199581438938" then
                        utils.execute_after(2, function()
                            utils.console_exec('say ' .. tostring(misc.in_game.trashtalk.phrases[math.random(#misc.in_game.trashtalk.phrases)]))
                        end)
                    else
                        utils.execute_after(2, function()
                            utils.console_exec('say ' .. tostring(misc.in_game.trashtalk.phrases[math.random(#misc.in_game.trashtalk.phrases)]))
                        end)
                    end
                end
            end,
        },
        clantag = function()
            local lp = entity.get_local_player()
            if lp == nil then return end

            if not globals.is_connected then return end

            local clantag = "NyaHook"

            if menu.misc.in_game.clantag:get() then
                common.set_clan_tag(clantag)
            else
                common.set_clan_tag("")
            end
        end,
        menu.misc.in_game.clantag:set_callback(function() misc.in_game.clantag() end),
        aspect_ratio = function()
            if menu.misc.in_game.aspect_ratio:get() then
                cvar.r_aspectratio:float(menu.misc.in_game.aspect_ratio.ratio:get() / 100)
            else
                cvar.r_aspectratio:float(0)
            end
        end,
        viewmodel_changer = function()
            if menu.misc.in_game.viewmodel_changer:get() then
                cvar.viewmodel_fov:float(menu.misc.in_game.viewmodel_changer.viewmodel_fov:get() / 100, true)
                cvar.viewmodel_offset_x:float(menu.misc.in_game.viewmodel_changer.viewmodel_x:get() / 100, true)
                cvar.viewmodel_offset_y:float(menu.misc.in_game.viewmodel_changer.viewmodel_y:get() / 100, true)
                cvar.viewmodel_offset_z:float(menu.misc.in_game.viewmodel_changer.viewmodel_z:get() / 100, true)
            else
                cvar.viewmodel_fov:float(68)
                cvar.viewmodel_offset_x:float(2.5)
                cvar.viewmodel_offset_y:float(0)
                cvar.viewmodel_offset_z:float(-1.5)
            end
        end,
        keep_model_transparency = function()
            local lp = entity.get_local_player()
            if lp == nil or not lp:is_alive() then return end

            if not menu.misc.in_game.keep_model_transparency:get() then return end
    
            return (lp.m_bIsScoped or lp.m_bResumeZoom) and 100 or 255
        end
    }

    misc.movement = {
        no_fall_damage = function(cmd)
            local lp = entity.get_local_player()
            if lp == nil then return end
    
            if not menu.misc.movement.no_fall_damage:get() then return end
    
            local origin = lp:get_origin()
    
            if lp.m_vecVelocity.z <= -500 then
                if utils.trace_line(vector(origin.x,origin.y,origin.z),vector(origin.x,origin.y,origin.z - 15)).fraction ~= 1 then
                    cmd.in_duck = 0
                elseif utils.trace_line(vector(origin.x,origin.y,origin.z),vector(origin.x,origin.y,origin.z - 55)).fraction ~= 1 then
                    cmd.in_duck = 1
                end
            end
        end,
        fast_ladder = function(cmd)
            local lp = entity.get_local_player()
            if lp == nil then return end
    
            if not menu.misc.movement.fast_ladder:get() then return end
        
            if lp.m_MoveType == 9 then
                cmd.view_angles.y = math.floor(cmd.view_angles.y + 0.5)
        
                if cmd.forwardmove > 0 then
                    if cmd.view_angles.x < 45 then
                        cmd.view_angles.x = 89
                        cmd.in_moveright = 1
                        cmd.in_moveleft = 0
                        cmd.in_forward = 0
                        cmd.in_back = 1
        
                        if cmd.sidemove == 0 then
                            cmd.view_angles.y = cmd.view_angles.y + 90
                        end
        
                        if cmd.sidemove < 0 then
                            cmd.view_angles.y = cmd.view_angles.y + 150
                        end
        
                        if cmd.sidemove > 0 then
                            cmd.view_angles.y = cmd.view_angles.y + 30
                        end
                    end
                elseif cmd.forwardmove < 0 then
                    cmd.view_angles.x = 89
                    cmd.in_moveleft = 1
                    cmd.in_moveright = 0
                    cmd.in_forward = 1
                    cmd.in_back = 0
        
                    if cmd.sidemove == 0 then
                        cmd.view_angles.y = cmd.view_angles.y + 90
                    end
        
                    if cmd.sidemove > 0 then
                        cmd.view_angles.y = cmd.view_angles.y + 150
                    end
        
                    if cmd.sidemove < 0 then
                        cmd.view_angles.y = cmd.view_angles.y + 30
                    end
                end
            end
        end,
        edge_stop = function(cmd)
            local lp = entity.get_local_player()
            if lp == nil then return end
    
            if not menu.misc.movement.edge_stop:get() then return end

            local lp_origin = lp:get_origin()

            sim = lp:simulate_movement(lp_origin)
            sim:think(5)

            if sim.velocity.z < 0 then
                cmd.block_movement = 2
            end
        end,
        jump_scout = function(cmd)
            local lp = entity.get_local_player()
            if lp == nil then return end
    
            if not menu.misc.movement.jump_scout:get() then return end

            local velocity = math.sqrt(lp.m_vecVelocity.x * lp.m_vecVelocity.x + lp.m_vecVelocity.y * lp.m_vecVelocity.y)

            if velocity < 2 then
                refs.air_strafe:override(false)
            else
                refs.air_strafe:override()
            end
        end,
        on_grenade_override_view = function(cmd)
            if not menu.misc.movement.super_toss:get() then return end

            local lp = entity.get_local_player()
            if lp == nil then return end
    
            local weapon = lp:get_player_weapon()
            if weapon == nil then return end
    
            local weapon_info = weapon:get_weapon_info()
            if weapon_info == nil then return end
    
            cmd.angles = misc.super_toss_references.get_throw_toss(cmd.angles, weapon_info.throw_velocity, weapon.m_flThrowStrength, cmd.velocity)
        end,
        super_toss = function(cmd)
            if not menu.misc.movement.super_toss:get() then return end

            if cmd.jitter_move ~= true then return end
    
            local lp = entity.get_local_player()
            if lp == nil then return end
    
            local weapon = lp:get_player_weapon()
            if weapon == nil then return end
    
            local weapon_info = weapon:get_weapon_info()
            if weapon_info == nil or weapon_info.weapon_type ~= 9 then return end
    
            if weapon.m_fThrowTime < (globals.curtime - to_time(globals.clock_offset)) then return end
    
            cmd.in_speed = true
    
            local simulation_ctx = lp:simulate_movement()
            simulation_ctx:think()
    
            cmd.view_angles = misc.super_toss_references.get_throw_toss(cmd.view_angles, weapon_info.throw_velocity, weapon.m_flThrowStrength, simulation_ctx.velocity)
        end
    }

    misc.logs = {
        notify_data = { },
        notifications = function()
            for i, logs in ipairs(misc.logs.notify_data) do
                if logs.time + 1 > globals.realtime and i <= 5 then
                    logs.alpha = animations.lerp(logs.alpha, 255, 0.05)
                    logs.alpha_text = animations.lerp(logs.alpha_text, 255, 0.05)
                    logs.add_x = animations.lerp(logs.add_x, 1, 0.05)
                end

                local accent_color = logs.color
    
                local string = "\a" .. accent_color:to_hex() .. ui.get_icon("paw") .. " \aDEFAULT" .. tostring(logs.text)
    
                local size = render.measure_text(1, "", tostring(string)).x / 2
    
                if logs.alpha <= 0 then
                    logs[i] = nil
                else
                    logs.add_y = animations.lerp(logs.add_y, i * 40, 0.05)

                    render.shadow(vector(screen_x / 2 - size - 12, screen_y - 80 - logs.add_y - 6), vector(screen_x / 2 + size + 12, screen_y - 80 - logs.add_y + 20), color(accent_color.r, accent_color.g, accent_color.b, logs.alpha - 60), 50, 0, 5)
                    render.rect(vector(screen_x / 2 - size - 12, screen_y - 80 - logs.add_y - 6), vector(screen_x / 2 + size + 12, screen_y - 80 - logs.add_y + 20), color(15, 15, 15, logs.alpha), 5)
                    
                    local rect_size = size + 40

                    render.text(1, vector(screen_x / 2 - size, screen_y - 80 - logs.add_y), color(255, 255, 255, logs.alpha_text), nil, string)
    
                    if logs.time + 3 < globals.realtime or i > 5 then
                        logs.alpha = animations.lerp(logs.alpha, 0, 0.05)
                        logs.alpha_text = animations.lerp(logs.alpha_text, 0, 0.05)
                        logs.add_x = animations.lerp(logs.add_x, 0, 0.05)
                        logs.add_y = animations.lerp(logs.add_y, i * 60, 0.05)
                    end
                end
    
                if logs.alpha < 1 then
                    table.remove(misc.logs.notify_data, i)
                end
            end
        end,
        hitgroup_str = {
            [0] = 'generic',
            'head', 'chest', 'stomach',
            'left arm', 'right arm',
            'left leg', 'right leg',
            'neck', 'generic', 'gear'
        },
        aimbot = function(e)
            if not menu.misc.ragebot.aimbot_logs:get() then return end
    
            local state = e.state
    
            local target = entity.get(e.target)
            if target == nil then return end
    
            local target_name = target:get_name()
    
            local hitgroup = misc.logs.hitgroup_str[e.hitgroup]
            local wanted_hitgroup = misc.logs.hitgroup_str[e.wanted_hitgroup]
    
            local damage = e.damage
            local wanted_damage = e.wanted_damage
    
            local health = target.m_iHealth
            local backtrack = e.backtrack
            local hitchance = e.hitchance

            local hit_color = menu.misc.ragebot.aimbot_logs.hit_color:get():to_hex()
            local miss_color = menu.misc.ragebot.aimbot_logs.miss_color:get():to_hex()
    
            if state == nil then
                if menu.misc.ragebot.aimbot_logs.output:get("Notify") then
                    table.insert(misc.logs.notify_data, 1, {
                        text = string.format("\v Hit %s in the %s for %s damage", target_name, hitgroup, damage), 
                        alpha = 0, alpha_text = 0, add_x = 0, add_y = 0, time = globals.realtime, color = menu.misc.ragebot.aimbot_logs.hit_color:get()})
                else
                    misc.logs.notify_data = {}
                end
    
                if menu.misc.ragebot.aimbot_logs.output:get("Console") then
                    print_raw(string.format("[\a".. hit_color .."Nya\aDEFAULTHook] \a".. hit_color .."Hit\aDEFAULT %s in the %s(%s) for \a".. hit_color .."%s\aDEFAULT(\a".. hit_color .."%s\aDEFAULT) damage [health remaining: \a".. hit_color .."%s\aDEFAULT | bt: \a".. hit_color .."%st\aDEFAULT | hc: \a".. hit_color .."%s%%\aDEFAULT]", target_name, hitgroup, wanted_hitgroup, damage, wanted_damage, health, backtrack, hitchance))
                end
    
                if menu.misc.ragebot.aimbot_logs.output:get("Event") then
                    print_dev(string.format("\a".. hit_color .."Hit\aDEFAULT %s in the %s(%s) for \a".. hit_color .."%s\aDEFAULT(\a".. hit_color .."%s\aDEFAULT) damage [health remaining: \a".. hit_color .."%s\aDEFAULT | bt: \a".. hit_color .."%st\aDEFAULT | hc: \a".. hit_color .."%s%%\aDEFAULT]", target_name, hitgroup, wanted_hitgroup, damage, wanted_damage, health, backtrack, hitchance))
                end
            else
                if menu.misc.ragebot.aimbot_logs.output:get("Notify") then
                    table.insert(misc.logs.notify_data, 1, {
                        text = string.format("\v Missed shot at %s due to %s in the %s", target_name, state, wanted_hitgroup), 
                        alpha = 0, alpha_text = 0, add_x = 0, add_y = 0, time = globals.realtime, color = menu.misc.ragebot.aimbot_logs.miss_color:get()})
                else
                    misc.logs.notify_data = {}
                end
    
                if menu.misc.ragebot.aimbot_logs.output:get("Console") then
                    print_raw(string.format("[\a".. miss_color .."Nya\aDEFAULTHook] \a".. miss_color .."Missed\aDEFAULT shot at %s due to \a".. miss_color .."%s\aDEFAULT in the %s for \a".. miss_color .."%s\aDEFAULT damage [bt: \a".. miss_color .."%st\aDEFAULT | hc: \a".. miss_color .."%s%%\aDEFAULT]", target_name, state, wanted_hitgroup, wanted_damage, backtrack, hitchance))
                end
    
                if menu.misc.ragebot.aimbot_logs.output:get("Event") then
                    print_dev(string.format("\a".. miss_color .."Missed\aDEFAULT shot at %s due to \a".. miss_color .."%s\aDEFAULT in the %s for \a".. miss_color .."%s\aDEFAULT damage [bt: \a".. miss_color .."%st\aDEFAULT | hc: \a".. miss_color .."%s%%\aDEFAULT]", target_name, state, wanted_hitgroup, wanted_damage, backtrack, hitchance))
                end
            end
        end,
        additional = function(e)
            if not menu.misc.ragebot.aimbot_logs:get() then return end
    
            local lp = entity.get_local_player()
            if lp == nil then return end
    
            local attacker = entity.get(e.attacker, true)
            if attacker == nil then return end
    
            local target = entity.get(e.userid, true)   
            if target == nil then return end
    
            local target_name = target:get_name()
    
            local weapon = e.weapon
        
            if weapon == 'hegrenade' then 
                type_hit = 'Naded'
            end
        
            if weapon == 'inferno' then
                type_hit = 'Burned'
            end
        
            if weapon == 'knife' then 
                type_hit = 'Knifed'
            end

            local hit_color = menu.misc.ragebot.aimbot_logs.hit_color:get():to_hex()
        
            if weapon == 'hegrenade' or weapon == 'inferno' or weapon == 'knife' then
                if lp == attacker then
                    if menu.misc.ragebot.aimbot_logs.output:get("Console") then
                        print_raw(string.format("[\a".. hit_color .."Nya\aDEFAULTHook] \a".. hit_color .."%s\aDEFAULT %s for \a".. hit_color .."%s\aDEFAULT damage [health remaining: \a".. hit_color .."%s\aDEFAULT]", type_hit, target_name, e.dmg_health, e.health))
                    end
        
                    if menu.misc.ragebot.aimbot_logs.output:get("Event") then
                        print_dev(string.format("\a".. hit_color .."%s\aDEFAULT %s for \a".. hit_color .."%s\aDEFAULT damage [health remaining: \a".. hit_color .."%s\aDEFAULT]", type_hit, target_name, e.dmg_health, e.health))
                    end
                end
            end
        end,
        purchase = function(e)
            if not menu.misc.ragebot.aimbot_logs:get() then return end
    
            if menu.misc.ragebot.aimbot_logs.purchase_logs:get() then
                local target = entity.get(e.userid, true)
                if target == nil or not target:is_enemy() then return end
    
                local target_name = target:get_name()
    
                local weapon = e.weapon
                if weapon == 'weapon_unknown' then return end
    
                if menu.misc.ragebot.aimbot_logs.output:get("Console") then
                    print_raw(string.format("[\aFFABDEFFNya\aDEFAULTHook] %s bought %s", target_name, weapon))
                end
    
                if menu.misc.ragebot.aimbot_logs.output:get("Event") then
                    print_dev(string.format("%s bought %s", target_name, weapon))
                end
            end
        end
    }

    misc.ragebot = {
        fake_latency = function()
            cvar.sv_maxunlag:float(0.400)
            refs.fake_latency:set(menu.misc.ragebot.fake_latency:get())
        end,
        hitchance = function(cmd)
            local lp = entity.get_local_player()
            if lp == nil or not lp:is_alive() then return end
        
            local weapon = lp:get_player_weapon()
            if weapon == nil then return end
            
            local weapon_index = weapon:get_weapon_index()
            if weapon_index == nil then return end
        
            if menu.misc.ragebot.hitchance:get() then
                if stateid == 4 or stateid == 5 then
                    if menu.misc.ragebot.hitchance.enable_pistols:get() and (weapon_index == 1 or weapon_index == 2 or weapon_index == 3 or weapon_index == 4 or weapon_index == 32 or weapon_index == 36 or weapon_index == 61) then
                        refs.pistols_hitchance:override(menu.misc.ragebot.hitchance.pistols_air_amount:get())
                    end
        
                    if menu.misc.ragebot.hitchance.enable_auto_snipers:get() and (weapon_index == 38 or weapon_index == 11) then
                        refs.auto_snipers_hitchance:override(menu.misc.ragebot.hitchance.auto_snipers_air_amount:get())
                    end
        
                    if menu.misc.ragebot.hitchance.enable_awp:get() and (weapon_index == 9) then
                        refs.awp_hitchance:override(menu.misc.ragebot.hitchance.awp_air_amount:get())
                    end
        
                    if menu.misc.ragebot.hitchance.enable_ssg08:get() and (weapon_index == 40) then
                        refs.ssg08_hitchance:override(menu.misc.ragebot.hitchance.ssg08_air_amount:get())
                    end
        
                    if menu.misc.ragebot.hitchance.enable_revolver:get() and (weapon_index == 64) then
                        refs.revolver_hitchance:override(menu.misc.ragebot.hitchance.revolver_air_amount:get())
                    end
                else
                    refs.pistols_hitchance:override()
                    refs.auto_snipers_hitchance:override()
                    refs.awp_hitchance:override()
                    refs.ssg08_hitchance:override()
                    refs.revolver_hitchance:override()
                end
                
                if not lp.m_bIsScoped or stateid == 4 or stateid == 5 then
                    if stateid == 4 or stateid == 5 then
                        if menu.misc.ragebot.hitchance.enable_pistols:get() and (weapon_index == 1 or weapon_index == 2 or weapon_index == 3 or weapon_index == 4 or weapon_index == 32 or weapon_index == 36 or weapon_index == 61) then
                            refs.pistols_hitchance:override(menu.misc.ragebot.hitchance.pistols_air_amount:get())
                        end
        
                        if menu.misc.ragebot.hitchance.enable_auto_snipers:get() and (weapon_index == 38 or weapon_index == 11) then
                            refs.auto_snipers_hitchance:override(menu.misc.ragebot.hitchance.auto_snipers_air_amount:get())
                        end
            
                        if menu.misc.ragebot.hitchance.enable_awp:get() and (weapon_index == 9) then
                            refs.awp_hitchance:override(menu.misc.ragebot.hitchance.awp_air_amount:get())
                        end
            
                        if menu.misc.ragebot.hitchance.enable_ssg08:get() and (weapon_index == 40) then
                            refs.ssg08_hitchance:override(menu.misc.ragebot.hitchance.ssg08_air_amount:get())
                        end
            
                        if menu.misc.ragebot.hitchance.enable_revolver:get() and (weapon_index == 64) then
                            refs.revolver_hitchance:override(menu.misc.ragebot.hitchance.revolver_air_amount:get())
                        end
                    else
                        if menu.misc.ragebot.hitchance.enable_auto_snipers:get() and (weapon_index == 38 or weapon_index == 11) then
                            refs.auto_snipers_hitchance:override(menu.misc.ragebot.hitchance.auto_snipers_no_scope_amount:get())
                        end
            
                        if menu.misc.ragebot.hitchance.enable_awp:get() and (weapon_index == 9) then
                            refs.awp_hitchance:override(menu.misc.ragebot.hitchance.awp_no_scope_amount:get())
                        end
        
                        if menu.misc.ragebot.hitchance.enable_ssg08:get() and (weapon_index == 40) then
                            refs.ssg08_hitchance:override(menu.misc.ragebot.hitchance.ssg08_no_scope_amount:get())
                        end
                    end
                else
                    refs.pistols_hitchance:override()
                    refs.auto_snipers_hitchance:override()
                    refs.awp_hitchance:override()
                    refs.ssg08_hitchance:override()
                    refs.revolver_hitchance:override()
                end
            else
                refs.pistols_hitchance:override()
                refs.auto_snipers_hitchance:override()
                refs.awp_hitchance:override()
                refs.ssg08_hitchance:override()
                refs.revolver_hitchance:override()
            end
        end,
        grenade_throw_fix = function()
            if not menu.misc.ragebot.grenade_throw_fix:get() then return end

            local lp = entity.get_local_player()
            if lp == nil or not lp:is_alive() then return end

            local weapon = lp:get_player_weapon()
            if not weapon or weapon == nil then return end
        
            local weapon_info = weapon:get_weapon_info()
            if not weapon_info or weapon_info == nil then return end
        
            local is_grenade = weapon_info.weapon_type == 9

            if is_grenade then
                refs.weapon_actions:override("")
            else
                refs.weapon_actions:override()
            end
        end,
        menu.misc.ragebot.decrease_hold_aim_ticks:set_callback(function(self)
            cvar.sv_maxusrcmdprocessticks_holdaim:int(self:get() and 0 or 1)
        end)
    }

    menu.misc.ragebot.aimbot_logs.push_notify_log:set_callback(function()
        table.insert(misc.logs.notify_data, 1, {
            text = "\v Hit zordside in the head for 192 damage (0 health remaining)", 
            alpha = 0, alpha_text = 0, add_x = 0, add_y = 0, time = globals.realtime, color = menu.misc.ragebot.aimbot_logs.hit_color:get()})

        table.insert(misc.logs.notify_data, 1, {
            text = "\v Missed shot at zordside due to resolver in the head for 192 damage", 
            alpha = 0, alpha_text = 0, add_x = 0, add_y = 0, time = globals.realtime, color = menu.misc.ragebot.aimbot_logs.miss_color:get()})
    end)
end

menu.anti_aim.preset_manager.main = { } do
    local include_anti_aim_builder = pui.setup({ menu.anti_aim.builder }, true)

    preset_manager_label = menu.tabs.anti_aim.left_builder_presets:label("\vPreset manager\r which will give you easy access to share your custom preset.")

    load_recommended_anti_aim_settings = menu.tabs.anti_aim.left_builder_presets:button("\v\f<stars>\r  Meta Preset", function()
        include_anti_aim_builder:load(json.parse(base64.decode("W1t7ImJvZHlfaml0dGVyIjp0cnVlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjpmYWxzZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJSYW5kb20iLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjowLjAsInBpdGNoX3JhbmRvbV9zZWNvbmQiOjI3LjAsInlhdyI6IlJhbmRvbVxuIiwieWF3X2N1c3RvbSI6MC4wLCJ5YXdfaml0dGVyIjoiRGlzYWJsZWQiLCJ5YXdfbW9kZSI6IlN0YXRpYyIsInlhd19yYW5kb21fZmlyc3QiOjAuMCwieWF3X3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3X3NwaW5fc3BlZWQiOjEuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wfSwifnlhd19tb2RlIjp7ImFtb3VudCI6MC4wLCJsZWZ0X2Ftb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMCwicmlnaHRfYW1vdW50IjowLjB9fSx7ImJvZHlfaml0dGVyIjp0cnVlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjp0cnVlLCJmYWtlX2xpbWl0Ijo2MC4wLCJmYWtlX2xpbWl0X3JhbmRvbWl6ZSI6MC4wLCJwaXRjaCI6IkRpc2FibGVkIiwicGl0Y2hfY3VzdG9tIjowLjAsInBpdGNoX3JhbmRvbV9maXJzdCI6MC4wLCJwaXRjaF9yYW5kb21fc2Vjb25kIjowLjAsInlhdyI6IkhpZGRlbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd19tb2RlIjoiU3RhdGljIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MS4wLCJ+eWF3X2ppdHRlciI6eyJhbW91bnQiOi02Mi4wLCJyYW5kb21pemUiOjE1LjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50IjoxMi4wLCJsZWZ0X2Ftb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMCwicmlnaHRfYW1vdW50IjowLjB9fSx7ImJvZHlfaml0dGVyIjp0cnVlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjp0cnVlLCJmYWtlX2xpbWl0Ijo2MC4wLCJmYWtlX2xpbWl0X3JhbmRvbWl6ZSI6MC4wLCJwaXRjaCI6IlJhbmRvbSIsInBpdGNoX2N1c3RvbSI6MC4wLCJwaXRjaF9yYW5kb21fZmlyc3QiOi04OS4wLCJwaXRjaF9yYW5kb21fc2Vjb25kIjo0NS4wLCJ5YXciOiJTcGluIiwieWF3X2N1c3RvbSI6MC4wLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwieWF3X21vZGUiOiJMJlIiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoxNS4wLCJ+eWF3X2ppdHRlciI6eyJhbW91bnQiOi0zNy4wLCJyYW5kb21pemUiOjEwLjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50IjoxMi4wLCJsZWZ0X2Ftb3VudCI6LTI0LjAsInJhbmRvbWl6ZSI6NS4wLCJyaWdodF9hbW91bnQiOjE1LjB9fSx7ImJvZHlfaml0dGVyIjp0cnVlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjp0cnVlLCJmYWtlX2xpbWl0Ijo2MC4wLCJmYWtlX2xpbWl0X3JhbmRvbWl6ZSI6MC4wLCJwaXRjaCI6IkN1c3RvbSIsInBpdGNoX2N1c3RvbSI6NDUuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjowLjAsInBpdGNoX3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3IjoiU3BpbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkRpc2FibGVkIiwieWF3X21vZGUiOiJTdGF0aWMiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoxNS4wLCJ+eWF3X2ppdHRlciI6eyJhbW91bnQiOi02Mi4wLCJyYW5kb21pemUiOjUuMH0sIn55YXdfbW9kZSI6eyJhbW91bnQiOjcuMCwibGVmdF9hbW91bnQiOjAuMCwicmFuZG9taXplIjowLjAsInJpZ2h0X2Ftb3VudCI6MC4wfX0seyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJSYW5kb20iLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjotODkuMCwicGl0Y2hfcmFuZG9tX3NlY29uZCI6NDUuMCwieWF3IjoiU3BpbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkRpc2FibGVkIiwieWF3X21vZGUiOiJMJlIiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoxNS4wLCJ+eWF3X2ppdHRlciI6eyJhbW91bnQiOi0xMC4wLCJyYW5kb21pemUiOjUuMH0sIn55YXdfbW9kZSI6eyJhbW91bnQiOjAuMCwibGVmdF9hbW91bnQiOi0yNC4wLCJyYW5kb21pemUiOjExLjAsInJpZ2h0X2Ftb3VudCI6NDIuMH19LHsiYm9keV9qaXR0ZXIiOnRydWUsImJvZHlfaml0dGVyX2RlbGF5IjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21heGltdW0iOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWV0aG9kIjoiRGVmYXVsdCIsImJvZHlfaml0dGVyX2RlbGF5X21pbmltdW0iOjIuMCwiYm9keV9qaXR0ZXJfcmFuZG9taXplX2RlbGF5IjoyLjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX3lhd19sZWZ0X2Ftb3VudCI6MC4wLCJkZWZlbnNpdmVfeWF3X3JpZ2h0X2Ftb3VudCI6MC4wLCJlbmFibGVfc3RhdGUiOnRydWUsImZha2VfbGltaXQiOjYwLjAsImZha2VfbGltaXRfcmFuZG9taXplIjowLjAsInBpdGNoIjoiVXAiLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjotODkuMCwicGl0Y2hfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXciOiJGb3J3YXJkIiwieWF3X2N1c3RvbSI6MC4wLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwieWF3X21vZGUiOiJTdGF0aWMiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjozMC4wLCJ+eWF3X2ppdHRlciI6eyJhbW91bnQiOi02MC4wLCJyYW5kb21pemUiOjAuMH0sIn55YXdfbW9kZSI6eyJhbW91bnQiOjEyLjAsImxlZnRfYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wLCJyaWdodF9hbW91bnQiOjAuMH19LHsiYm9keV9qaXR0ZXIiOnRydWUsImJvZHlfaml0dGVyX2RlbGF5IjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21heGltdW0iOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWV0aG9kIjoiRGVmYXVsdCIsImJvZHlfaml0dGVyX2RlbGF5X21pbmltdW0iOjIuMCwiYm9keV9qaXR0ZXJfcmFuZG9taXplX2RlbGF5IjoyLjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX3lhd19sZWZ0X2Ftb3VudCI6MC4wLCJkZWZlbnNpdmVfeWF3X3JpZ2h0X2Ftb3VudCI6MC4wLCJlbmFibGVfc3RhdGUiOnRydWUsImZha2VfbGltaXQiOjYwLjAsImZha2VfbGltaXRfcmFuZG9taXplIjowLjAsInBpdGNoIjoiRGlzYWJsZWQiLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjowLjAsInBpdGNoX3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3IjoiSGlkZGVuIiwieWF3X2N1c3RvbSI6MC4wLCJ5YXdfaml0dGVyIjoiRGlzYWJsZWQiLCJ5YXdfbW9kZSI6IkwmUiIsInlhd19yYW5kb21fZmlyc3QiOjAuMCwieWF3X3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3X3NwaW5fc3BlZWQiOjEuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wfSwifnlhd19tb2RlIjp7ImFtb3VudCI6MC4wLCJsZWZ0X2Ftb3VudCI6LTQwLjAsInJhbmRvbWl6ZSI6NS4wLCJyaWdodF9hbW91bnQiOjI3LjB9fSx7ImJvZHlfaml0dGVyIjp0cnVlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjp0cnVlLCJmYWtlX2xpbWl0Ijo2MC4wLCJmYWtlX2xpbWl0X3JhbmRvbWl6ZSI6MC4wLCJwaXRjaCI6IlJhbmRvbSIsInBpdGNoX2N1c3RvbSI6MC4wLCJwaXRjaF9yYW5kb21fZmlyc3QiOi00NS4wLCJwaXRjaF9yYW5kb21fc2Vjb25kIjo0NS4wLCJ5YXciOiJTcGluIiwieWF3X2N1c3RvbSI6MC4wLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwieWF3X21vZGUiOiJMJlIiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoyMC4wLCJ+eWF3X2ppdHRlciI6eyJhbW91bnQiOjAuMCwicmFuZG9taXplIjowLjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50IjowLjAsImxlZnRfYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wLCJyaWdodF9hbW91bnQiOjAuMH19LHsiYm9keV9qaXR0ZXIiOmZhbHNlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjpmYWxzZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJEaXNhYmxlZCIsInBpdGNoX2N1c3RvbSI6MC4wLCJwaXRjaF9yYW5kb21fZmlyc3QiOjAuMCwicGl0Y2hfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXciOiJIaWRkZW4iLCJ5YXdfY3VzdG9tIjowLjAsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJ5YXdfbW9kZSI6IlN0YXRpYyIsInlhd19yYW5kb21fZmlyc3QiOjAuMCwieWF3X3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3X3NwaW5fc3BlZWQiOjEuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjozOC4wLCJyYW5kb21pemUiOjAuMH0sIn55YXdfbW9kZSI6eyJhbW91bnQiOjAuMCwibGVmdF9hbW91bnQiOjAuMCwicmFuZG9taXplIjowLjAsInJpZ2h0X2Ftb3VudCI6MC4wfX1dXQ==")))
        configs.cfg_selector:update(configdata.menu_list)
        common.add_notify("NyaHook", "The meta preset was successfully loaded!")
        cvar.play:call("ambient\\office\\button1")
    end, true)

    import_anti_aim_settings = menu.tabs.anti_aim.left_builder_presets:button("Import", function()
        include_anti_aim_builder:load(json.parse(base64.decode(clipboard.get())))
        cvar.play:call("ambient\\tones\\elev1")
    end, true)

    export_anti_aim_settings = menu.tabs.anti_aim.left_builder_presets:button("Export", function()
        clipboard.set(base64.encode(json.stringify(include_anti_aim_builder:save())))
        cvar.play:call("ambient\\tones\\elev1")
    end, true)
end

local config_system = { } do
    local config = pui.setup({ menu }, true)

    configdata = db.nyahook_dbshka or { }
    configdata.cfg_list = configdata.cfg_list or {{'Default', 'W3siYW50aV9haW0iOnsiYXZvaWRfYmFja3N0YWIiOnRydWUsImJyYW5jaCI6MS4wLCJidWlsZGVyIjpbeyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6ZmFsc2UsImZha2VfbGltaXQiOjYwLjAsImZha2VfbGltaXRfcmFuZG9taXplIjowLjAsInBpdGNoIjoiUmFuZG9tIiwicGl0Y2hfY3VzdG9tIjowLjAsInBpdGNoX3JhbmRvbV9maXJzdCI6MC4wLCJwaXRjaF9yYW5kb21fc2Vjb25kIjoyNy4wLCJ5YXciOiJSYW5kb21cbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkRpc2FibGVkIiwieWF3X21vZGUiOiJTdGF0aWMiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoxLjAsIn55YXdfaml0dGVyIjp7ImFtb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMH0sIn55YXdfbW9kZSI6eyJhbW91bnQiOjAuMCwibGVmdF9hbW91bnQiOjAuMCwicmFuZG9taXplIjowLjAsInJpZ2h0X2Ftb3VudCI6MC4wfX0seyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJEaXNhYmxlZCIsInBpdGNoX2N1c3RvbSI6MC4wLCJwaXRjaF9yYW5kb21fZmlyc3QiOjAuMCwicGl0Y2hfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXciOiJIaWRkZW4iLCJ5YXdfY3VzdG9tIjowLjAsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJ5YXdfbW9kZSI6IlN0YXRpYyIsInlhd19yYW5kb21fZmlyc3QiOjAuMCwieWF3X3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3X3NwaW5fc3BlZWQiOjEuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotNjIuMCwicmFuZG9taXplIjoxNS4wfSwifnlhd19tb2RlIjp7ImFtb3VudCI6MTIuMCwibGVmdF9hbW91bnQiOjAuMCwicmFuZG9taXplIjowLjAsInJpZ2h0X2Ftb3VudCI6MC4wfX0seyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJSYW5kb20iLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjotODkuMCwicGl0Y2hfcmFuZG9tX3NlY29uZCI6NDUuMCwieWF3IjoiU3BpbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd19tb2RlIjoiTCZSIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MTUuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotMzcuMCwicmFuZG9taXplIjoxMC4wfSwifnlhd19tb2RlIjp7ImFtb3VudCI6MTIuMCwibGVmdF9hbW91bnQiOi0yNC4wLCJyYW5kb21pemUiOjUuMCwicmlnaHRfYW1vdW50IjoxNS4wfX0seyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJDdXN0b20iLCJwaXRjaF9jdXN0b20iOjQ1LjAsInBpdGNoX3JhbmRvbV9maXJzdCI6MC4wLCJwaXRjaF9yYW5kb21fc2Vjb25kIjowLjAsInlhdyI6IlNwaW4iLCJ5YXdfY3VzdG9tIjowLjAsInlhd19qaXR0ZXIiOiJEaXNhYmxlZCIsInlhd19tb2RlIjoiU3RhdGljIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MTUuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotNjIuMCwicmFuZG9taXplIjo1LjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50Ijo3LjAsImxlZnRfYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wLCJyaWdodF9hbW91bnQiOjAuMH19LHsiYm9keV9qaXR0ZXIiOnRydWUsImJvZHlfaml0dGVyX2RlbGF5IjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21heGltdW0iOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWV0aG9kIjoiRGVmYXVsdCIsImJvZHlfaml0dGVyX2RlbGF5X21pbmltdW0iOjIuMCwiYm9keV9qaXR0ZXJfcmFuZG9taXplX2RlbGF5IjoyLjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX3lhd19sZWZ0X2Ftb3VudCI6MC4wLCJkZWZlbnNpdmVfeWF3X3JpZ2h0X2Ftb3VudCI6MC4wLCJlbmFibGVfc3RhdGUiOnRydWUsImZha2VfbGltaXQiOjYwLjAsImZha2VfbGltaXRfcmFuZG9taXplIjowLjAsInBpdGNoIjoiUmFuZG9tIiwicGl0Y2hfY3VzdG9tIjowLjAsInBpdGNoX3JhbmRvbV9maXJzdCI6LTg5LjAsInBpdGNoX3JhbmRvbV9zZWNvbmQiOjQ1LjAsInlhdyI6IlNwaW4iLCJ5YXdfY3VzdG9tIjowLjAsInlhd19qaXR0ZXIiOiJEaXNhYmxlZCIsInlhd19tb2RlIjoiTCZSIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MTUuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotMTAuMCwicmFuZG9taXplIjo1LjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50IjowLjAsImxlZnRfYW1vdW50IjotMjQuMCwicmFuZG9taXplIjoxMS4wLCJyaWdodF9hbW91bnQiOjQyLjB9fSx7ImJvZHlfaml0dGVyIjp0cnVlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjp0cnVlLCJmYWtlX2xpbWl0Ijo2MC4wLCJmYWtlX2xpbWl0X3JhbmRvbWl6ZSI6MC4wLCJwaXRjaCI6IlVwIiwicGl0Y2hfY3VzdG9tIjowLjAsInBpdGNoX3JhbmRvbV9maXJzdCI6LTg5LjAsInBpdGNoX3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3IjoiRm9yd2FyZCIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd19tb2RlIjoiU3RhdGljIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MzAuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotNjAuMCwicmFuZG9taXplIjowLjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50IjoxMi4wLCJsZWZ0X2Ftb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMCwicmlnaHRfYW1vdW50IjowLjB9fSx7ImJvZHlfaml0dGVyIjp0cnVlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjp0cnVlLCJmYWtlX2xpbWl0Ijo2MC4wLCJmYWtlX2xpbWl0X3JhbmRvbWl6ZSI6MC4wLCJwaXRjaCI6IkRpc2FibGVkIiwicGl0Y2hfY3VzdG9tIjowLjAsInBpdGNoX3JhbmRvbV9maXJzdCI6MC4wLCJwaXRjaF9yYW5kb21fc2Vjb25kIjowLjAsInlhdyI6IkhpZGRlbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkRpc2FibGVkIiwieWF3X21vZGUiOiJMJlIiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoxLjAsIn55YXdfaml0dGVyIjp7ImFtb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMH0sIn55YXdfbW9kZSI6eyJhbW91bnQiOjAuMCwibGVmdF9hbW91bnQiOi00MC4wLCJyYW5kb21pemUiOjUuMCwicmlnaHRfYW1vdW50IjoyNy4wfX0seyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJSYW5kb20iLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjotNDUuMCwicGl0Y2hfcmFuZG9tX3NlY29uZCI6NDUuMCwieWF3IjoiU3BpbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd19tb2RlIjoiTCZSIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MjAuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wfSwifnlhd19tb2RlIjp7ImFtb3VudCI6MC4wLCJsZWZ0X2Ftb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMCwicmlnaHRfYW1vdW50IjowLjB9fSx7ImJvZHlfaml0dGVyIjpmYWxzZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6ZmFsc2UsImZha2VfbGltaXQiOjYwLjAsImZha2VfbGltaXRfcmFuZG9taXplIjowLjAsInBpdGNoIjoiRGlzYWJsZWQiLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjowLjAsInBpdGNoX3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3IjoiSGlkZGVuIiwieWF3X2N1c3RvbSI6MC4wLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwieWF3X21vZGUiOiJTdGF0aWMiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoxLjAsIn55YXdfaml0dGVyIjp7ImFtb3VudCI6MzguMCwicmFuZG9taXplIjowLjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50IjowLjAsImxlZnRfYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wLCJyaWdodF9hbW91bnQiOjAuMH19XSwiY3VycmVudF9zdGF0ZSI6IkNyb3VjaGluZyIsImVkZ2VfeWF3IjpmYWxzZSwiZmxpY2tfZXhwbG9pdCI6ZmFsc2UsImZvcmNlX2RlZmVuc2l2ZSI6WyJBaXIiLCJBaXItY3JvdWNoaW5nIiwifiJdLCJmcmVlc3RhbmRpbmciOmZhbHNlLCJsYWdfZXhwbG9pdCI6ZmFsc2UsIm1hbnVhbF95YXciOiJEaXNhYmxlZCIsInNhZmVfaGVhZCI6dHJ1ZSwifmVkZ2VfeWF3Ijp7Imlnbm9yZV9tYW51YWxzIjp0cnVlfSwifmZsaWNrX2V4cGxvaXQiOnsiaW52ZXJ0ZXIiOmZhbHNlfSwifmZvcmNlX2RlZmVuc2l2ZSI6eyJhbHdheXNfb24iOmZhbHNlLCJjdXN0b21fdGlja3MiOjEuMCwibWV0aG9kIjoxLjAsInJhbmRvbV90aWNrc19maXJzdCI6MTIuMCwicmFuZG9tX3RpY2tzX3NlY29uZCI6MjIuMH0sIn5mcmVlc3RhbmRpbmciOnsiYm9keV9mcmVlc3RhbmRpbmciOnRydWUsImRpc2FibGVfeWF3X21vZGlmaWVycyI6dHJ1ZX0sIn5sYWdfZXhwbG9pdCI6eyJ0aWNrcyI6MTYuMH0sIn5tYW51YWxfeWF3Ijp7Im1hbnVhbF9vdmVyX2ZzIjp0cnVlLCJzdGF0aWNfeWF3Ijp0cnVlfSwifnNhZmVfaGVhZCI6eyJ0cmlnZ2VycyI6WyJBaXItQ3JvdWNoIEtuaWZlIiwifiJdfX0sImhvbWUiOnsic2VsZWN0X3RhYiI6Mi4wfSwibWlzYyI6eyJpbl9nYW1lIjp7ImFzcGVjdF9yYXRpbyI6dHJ1ZSwiY2xhbnRhZyI6ZmFsc2UsImtlZXBfbW9kZWxfdHJhbnNwYXJlbmN5Ijp0cnVlLCJ0cmFzaHRhbGsiOnRydWUsInZpZXdtb2RlbF9jaGFuZ2VyIjp0cnVlLCJ+YXNwZWN0X3JhdGlvIjp7InJhdGlvIjoxMzMuMH0sIn52aWV3bW9kZWxfY2hhbmdlciI6eyJ2aWV3bW9kZWxfZm92Ijo2NzAwLjAsInZpZXdtb2RlbF94IjoxMDAuMCwidmlld21vZGVsX3kiOi00MDAuMCwidmlld21vZGVsX3oiOjUwLjB9fSwibW92ZW1lbnQiOnsiZWRnZV9zdG9wIjpmYWxzZSwiZmFzdF9sYWRkZXIiOnRydWUsImp1bXBfc2NvdXQiOnRydWUsIm5vX2ZhbGxfZGFtYWdlIjp0cnVlfSwicmFnZWJvdCI6eyJhaW1ib3RfbG9ncyI6dHJ1ZSwiYW50aV9haW1fY29ycmVjdGlvbiI6ZmFsc2UsImRlY3JlYXNlX2hvbGRfYWltX3RpY2tzIjpmYWxzZSwiZmFrZV9sYXRlbmN5IjowLjAsImdyZW5hZGVfdGhyb3dfZml4Ijp0cnVlLCJoaXRjaGFuY2UiOnRydWUsIn5haW1ib3RfbG9ncyI6eyJoaXRfY29sb3IiOiIjQkE5RkRERkYiLCJtaXNzX2NvbG9yIjoiI0U2OTY5NkZGIiwib3V0cHV0IjpbIkNvbnNvbGUiLCJFdmVudCIsIk5vdGlmeSIsIn4iXSwicHVyY2hhc2VfbG9ncyI6dHJ1ZX0sIn5oaXRjaGFuY2UiOnsiYXV0b19zbmlwZXJzX2Fpcl9hbW91bnQiOjMzLjAsImF1dG9fc25pcGVyc19ub19zY29wZV9hbW91bnQiOjUwLjAsImF3cF9haXJfYW1vdW50IjozMy4wLCJhd3Bfbm9fc2NvcGVfYW1vdW50Ijo1MC4wLCJjdXJyZW50X3dlYXBvbiI6NC4wLCJlbmFibGVfYXV0b19zbmlwZXJzIjp0cnVlLCJlbmFibGVfYXdwIjpmYWxzZSwiZW5hYmxlX3Bpc3RvbHMiOnRydWUsImVuYWJsZV9yZXZvbHZlciI6dHJ1ZSwiZW5hYmxlX3NzZzA4Ijp0cnVlLCJwaXN0b2xzX2Fpcl9hbW91bnQiOjMzLjAsInJldm9sdmVyX2Fpcl9hbW91bnQiOjMzLjAsInNzZzA4X2Fpcl9hbW91bnQiOjMzLjAsInNzZzA4X25vX3Njb3BlX2Ftb3VudCI6NTAuMH19fSwidmlzdWFscyI6eyJhbmltYXRlZF96b29tIjpmYWxzZSwiY2VudGVyZWRfaW5kaWNhdG9ycyI6ZmFsc2UsImNsaWVudF9zaWRlX2FuaW1hdGlvbnMiOnRydWUsImN1c3RvbV9zY29wZV9vdmVybGF5Ijp0cnVlLCJkYW1hZ2VfaW5kaWNhdG9yIjp0cnVlLCJnYW1lc2Vuc2VfaW5kaWNhdG9ycyI6ZmFsc2UsImdyZW5hZGVfd2FybmluZyI6ZmFsc2UsImhpdG1hcmtlciI6ZmFsc2UsImtleWJpbmRzIjpmYWxzZSwibWFudWFsX2Fycm93cyI6ZmFsc2UsInNwZWN0YXRvcnMiOmZhbHNlLCJ2ZWxvY2l0eV9pbmRpY2F0b3IiOnRydWUsIndhdGVybWFyayI6dHJ1ZSwifmNlbnRlcmVkX2luZGljYXRvcnMiOnsiY2VudGVyZWRfaW5kaWNhdG9yc19jb2xvciI6IiNFNzk1QzdGRiIsIm9mZnNldCI6NDAuMH0sIn5jbGllbnRfc2lkZV9hbmltYXRpb25zIjp7ImFkZG9ucyI6WyJNb3ZlIExlYW4iLCJ+Il0sImFpcl9sZWdzIjoiRGlzYWJsZWQiLCJncm91bmRfbGVncyI6IkRpc2FibGVkIiwibW92ZV9sZWFuX2Ftb3VudCI6MTAwLjB9LCJ+Y3VzdG9tX3Njb3BlX292ZXJsYXkiOnsiZ2FwIjo1LjAsImludmVydGVkIjpmYWxzZSwic2NvcGVfY29sb3IiOiIjQUFBQUFBRkYiLCJzaXplIjoxNTAuMCwidF9wb3NlIjpmYWxzZSwidmlld21vZGVsX2luX3Njb3BlIjpmYWxzZX0sIn5kYW1hZ2VfaW5kaWNhdG9yIjp7ImZvbnQiOiJEZWZhdWx0In0sIn5nYW1lc2Vuc2VfaW5kaWNhdG9ycyI6eyJhbmltYXRlZCI6ZmFsc2UsInNlbGVjdCI6WyJEb3VibGUgVGFwIiwiSGlkZSBTaG90cyIsIkZha2UgTGF0ZW5jeSIsIk1pbi4gRGFtYWdlIE92ZXJyaWRlIiwiQm9keSBBaW0iLCJGb3JjZSBTYWZlIFBvaW50IiwiRnJlZXN0YW5kaW5nIiwiRG9ybWFudCBBaW1ib3QiLCJCb21iIEluZm9ybWF0aW9uIiwiSGl0L01pc3MgUmF0ZSIsIn4iXSwic3R5bGUiOiJDbGFzc2ljIn0sIn5ncmVuYWRlX3dhcm5pbmciOnsiZ3JlbmFkZV93YXJuaW5nX2NvbG9yIjoiI0IxOUNENEZGIn0sIn5oaXRtYXJrZXIiOnsiaGl0bWFya2VyX2NvbG9yIjoiI0ZGRkZGRkZGIn0sIn5rZXliaW5kcyI6eyJrZXliaW5kc19jb2xvciI6IiNGRkZGRkZGRiJ9LCJ+bWFudWFsX2Fycm93cyI6eyJhcnJvd3NfY29sb3IiOiIjQjk5MUNCRkYiLCJhcnJvd3Nfc3R5bGUiOiJDbGFzc2ljIiwib2Zmc2V0Ijo1OC4wfSwifnNwZWN0YXRvcnMiOnsic3BlY3RhdG9yc19jb2xvciI6IiNGRkZGRkZGRiJ9LCJ+dmVsb2NpdHlfaW5kaWNhdG9yIjp7InZlbG9jaXR5X2luZGljYXRvcl9jb2xvciI6IiNGRkI0RTJGRiJ9LCJ+d2F0ZXJtYXJrIjp7InN0eWxlIjoiTW9kZXJuIiwid2F0ZXJtYXJrX2NvbG9yIjoiI0FDOTVDMkZGIn19fV0='}}
    configdata.menu_list = configdata.menu_list or {'Default'}
    
    configdata.cfg_list[1][2] = "W3siYW50aV9haW0iOnsiYXZvaWRfYmFja3N0YWIiOnRydWUsImJyYW5jaCI6MS4wLCJidWlsZGVyIjpbeyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6ZmFsc2UsImZha2VfbGltaXQiOjYwLjAsImZha2VfbGltaXRfcmFuZG9taXplIjowLjAsInBpdGNoIjoiUmFuZG9tIiwicGl0Y2hfY3VzdG9tIjowLjAsInBpdGNoX3JhbmRvbV9maXJzdCI6MC4wLCJwaXRjaF9yYW5kb21fc2Vjb25kIjoyNy4wLCJ5YXciOiJSYW5kb21cbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkRpc2FibGVkIiwieWF3X21vZGUiOiJTdGF0aWMiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoxLjAsIn55YXdfaml0dGVyIjp7ImFtb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMH0sIn55YXdfbW9kZSI6eyJhbW91bnQiOjAuMCwibGVmdF9hbW91bnQiOjAuMCwicmFuZG9taXplIjowLjAsInJpZ2h0X2Ftb3VudCI6MC4wfX0seyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJEaXNhYmxlZCIsInBpdGNoX2N1c3RvbSI6MC4wLCJwaXRjaF9yYW5kb21fZmlyc3QiOjAuMCwicGl0Y2hfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXciOiJIaWRkZW4iLCJ5YXdfY3VzdG9tIjowLjAsInlhd19qaXR0ZXIiOiJDZW50ZXIiLCJ5YXdfbW9kZSI6IlN0YXRpYyIsInlhd19yYW5kb21fZmlyc3QiOjAuMCwieWF3X3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3X3NwaW5fc3BlZWQiOjEuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotNjIuMCwicmFuZG9taXplIjoxNS4wfSwifnlhd19tb2RlIjp7ImFtb3VudCI6MTIuMCwibGVmdF9hbW91bnQiOjAuMCwicmFuZG9taXplIjowLjAsInJpZ2h0X2Ftb3VudCI6MC4wfX0seyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJSYW5kb20iLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjotODkuMCwicGl0Y2hfcmFuZG9tX3NlY29uZCI6NDUuMCwieWF3IjoiU3BpbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd19tb2RlIjoiTCZSIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MTUuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotMzcuMCwicmFuZG9taXplIjoxMC4wfSwifnlhd19tb2RlIjp7ImFtb3VudCI6MTIuMCwibGVmdF9hbW91bnQiOi0yNC4wLCJyYW5kb21pemUiOjUuMCwicmlnaHRfYW1vdW50IjoxNS4wfX0seyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJDdXN0b20iLCJwaXRjaF9jdXN0b20iOjQ1LjAsInBpdGNoX3JhbmRvbV9maXJzdCI6MC4wLCJwaXRjaF9yYW5kb21fc2Vjb25kIjowLjAsInlhdyI6IlNwaW4iLCJ5YXdfY3VzdG9tIjowLjAsInlhd19qaXR0ZXIiOiJEaXNhYmxlZCIsInlhd19tb2RlIjoiU3RhdGljIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MTUuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotNjIuMCwicmFuZG9taXplIjo1LjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50Ijo3LjAsImxlZnRfYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wLCJyaWdodF9hbW91bnQiOjAuMH19LHsiYm9keV9qaXR0ZXIiOnRydWUsImJvZHlfaml0dGVyX2RlbGF5IjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21heGltdW0iOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWV0aG9kIjoiRGVmYXVsdCIsImJvZHlfaml0dGVyX2RlbGF5X21pbmltdW0iOjIuMCwiYm9keV9qaXR0ZXJfcmFuZG9taXplX2RlbGF5IjoyLjAsImRlZmVuc2l2ZV9hYSI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX3lhd19sZWZ0X2Ftb3VudCI6MC4wLCJkZWZlbnNpdmVfeWF3X3JpZ2h0X2Ftb3VudCI6MC4wLCJlbmFibGVfc3RhdGUiOnRydWUsImZha2VfbGltaXQiOjYwLjAsImZha2VfbGltaXRfcmFuZG9taXplIjowLjAsInBpdGNoIjoiUmFuZG9tIiwicGl0Y2hfY3VzdG9tIjowLjAsInBpdGNoX3JhbmRvbV9maXJzdCI6LTg5LjAsInBpdGNoX3JhbmRvbV9zZWNvbmQiOjQ1LjAsInlhdyI6IlNwaW4iLCJ5YXdfY3VzdG9tIjowLjAsInlhd19qaXR0ZXIiOiJEaXNhYmxlZCIsInlhd19tb2RlIjoiTCZSIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MTUuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotMTAuMCwicmFuZG9taXplIjo1LjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50IjowLjAsImxlZnRfYW1vdW50IjotMjQuMCwicmFuZG9taXplIjoxMS4wLCJyaWdodF9hbW91bnQiOjQyLjB9fSx7ImJvZHlfaml0dGVyIjp0cnVlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjp0cnVlLCJmYWtlX2xpbWl0Ijo2MC4wLCJmYWtlX2xpbWl0X3JhbmRvbWl6ZSI6MC4wLCJwaXRjaCI6IlVwIiwicGl0Y2hfY3VzdG9tIjowLjAsInBpdGNoX3JhbmRvbV9maXJzdCI6LTg5LjAsInBpdGNoX3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3IjoiRm9yd2FyZCIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd19tb2RlIjoiU3RhdGljIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MzAuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjotNjAuMCwicmFuZG9taXplIjowLjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50IjoxMi4wLCJsZWZ0X2Ftb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMCwicmlnaHRfYW1vdW50IjowLjB9fSx7ImJvZHlfaml0dGVyIjp0cnVlLCJib2R5X2ppdHRlcl9kZWxheSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tYXhpbXVtIjoyLjAsImJvZHlfaml0dGVyX2RlbGF5X21ldGhvZCI6IkRlZmF1bHQiLCJib2R5X2ppdHRlcl9kZWxheV9taW5pbXVtIjoyLjAsImJvZHlfaml0dGVyX3JhbmRvbWl6ZV9kZWxheSI6Mi4wLCJkZWZlbnNpdmVfYWEiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2RlbGF5IjoyLjAsImRlZmVuc2l2ZV95YXdfbGVmdF9hbW91bnQiOjAuMCwiZGVmZW5zaXZlX3lhd19yaWdodF9hbW91bnQiOjAuMCwiZW5hYmxlX3N0YXRlIjp0cnVlLCJmYWtlX2xpbWl0Ijo2MC4wLCJmYWtlX2xpbWl0X3JhbmRvbWl6ZSI6MC4wLCJwaXRjaCI6IkRpc2FibGVkIiwicGl0Y2hfY3VzdG9tIjowLjAsInBpdGNoX3JhbmRvbV9maXJzdCI6MC4wLCJwaXRjaF9yYW5kb21fc2Vjb25kIjowLjAsInlhdyI6IkhpZGRlbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkRpc2FibGVkIiwieWF3X21vZGUiOiJMJlIiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoxLjAsIn55YXdfaml0dGVyIjp7ImFtb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMH0sIn55YXdfbW9kZSI6eyJhbW91bnQiOjAuMCwibGVmdF9hbW91bnQiOi00MC4wLCJyYW5kb21pemUiOjUuMCwicmlnaHRfYW1vdW50IjoyNy4wfX0seyJib2R5X2ppdHRlciI6dHJ1ZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6dHJ1ZSwiZmFrZV9saW1pdCI6NjAuMCwiZmFrZV9saW1pdF9yYW5kb21pemUiOjAuMCwicGl0Y2giOiJSYW5kb20iLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjotNDUuMCwicGl0Y2hfcmFuZG9tX3NlY29uZCI6NDUuMCwieWF3IjoiU3BpbiIsInlhd19jdXN0b20iOjAuMCwieWF3X2ppdHRlciI6IkNlbnRlciIsInlhd19tb2RlIjoiTCZSIiwieWF3X3JhbmRvbV9maXJzdCI6MC4wLCJ5YXdfcmFuZG9tX3NlY29uZCI6MC4wLCJ5YXdfc3Bpbl9zcGVlZCI6MjAuMCwifnlhd19qaXR0ZXIiOnsiYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wfSwifnlhd19tb2RlIjp7ImFtb3VudCI6MC4wLCJsZWZ0X2Ftb3VudCI6MC4wLCJyYW5kb21pemUiOjAuMCwicmlnaHRfYW1vdW50IjowLjB9fSx7ImJvZHlfaml0dGVyIjpmYWxzZSwiYm9keV9qaXR0ZXJfZGVsYXkiOjIuMCwiYm9keV9qaXR0ZXJfZGVsYXlfbWF4aW11bSI6Mi4wLCJib2R5X2ppdHRlcl9kZWxheV9tZXRob2QiOiJEZWZhdWx0IiwiYm9keV9qaXR0ZXJfZGVsYXlfbWluaW11bSI6Mi4wLCJib2R5X2ppdHRlcl9yYW5kb21pemVfZGVsYXkiOjIuMCwiZGVmZW5zaXZlX2FhIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19kZWxheSI6Mi4wLCJkZWZlbnNpdmVfeWF3X2xlZnRfYW1vdW50IjowLjAsImRlZmVuc2l2ZV95YXdfcmlnaHRfYW1vdW50IjowLjAsImVuYWJsZV9zdGF0ZSI6ZmFsc2UsImZha2VfbGltaXQiOjYwLjAsImZha2VfbGltaXRfcmFuZG9taXplIjowLjAsInBpdGNoIjoiRGlzYWJsZWQiLCJwaXRjaF9jdXN0b20iOjAuMCwicGl0Y2hfcmFuZG9tX2ZpcnN0IjowLjAsInBpdGNoX3JhbmRvbV9zZWNvbmQiOjAuMCwieWF3IjoiSGlkZGVuIiwieWF3X2N1c3RvbSI6MC4wLCJ5YXdfaml0dGVyIjoiQ2VudGVyIiwieWF3X21vZGUiOiJTdGF0aWMiLCJ5YXdfcmFuZG9tX2ZpcnN0IjowLjAsInlhd19yYW5kb21fc2Vjb25kIjowLjAsInlhd19zcGluX3NwZWVkIjoxLjAsIn55YXdfaml0dGVyIjp7ImFtb3VudCI6MzguMCwicmFuZG9taXplIjowLjB9LCJ+eWF3X21vZGUiOnsiYW1vdW50IjowLjAsImxlZnRfYW1vdW50IjowLjAsInJhbmRvbWl6ZSI6MC4wLCJyaWdodF9hbW91bnQiOjAuMH19XSwiY3VycmVudF9zdGF0ZSI6IkNyb3VjaGluZyIsImVkZ2VfeWF3IjpmYWxzZSwiZmxpY2tfZXhwbG9pdCI6ZmFsc2UsImZvcmNlX2RlZmVuc2l2ZSI6WyJBaXIiLCJBaXItY3JvdWNoaW5nIiwifiJdLCJmcmVlc3RhbmRpbmciOmZhbHNlLCJsYWdfZXhwbG9pdCI6ZmFsc2UsIm1hbnVhbF95YXciOiJEaXNhYmxlZCIsInNhZmVfaGVhZCI6dHJ1ZSwifmVkZ2VfeWF3Ijp7Imlnbm9yZV9tYW51YWxzIjp0cnVlfSwifmZsaWNrX2V4cGxvaXQiOnsiaW52ZXJ0ZXIiOmZhbHNlfSwifmZvcmNlX2RlZmVuc2l2ZSI6eyJhbHdheXNfb24iOmZhbHNlLCJjdXN0b21fdGlja3MiOjEuMCwibWV0aG9kIjoxLjAsInJhbmRvbV90aWNrc19maXJzdCI6MTIuMCwicmFuZG9tX3RpY2tzX3NlY29uZCI6MjIuMH0sIn5mcmVlc3RhbmRpbmciOnsiYm9keV9mcmVlc3RhbmRpbmciOnRydWUsImRpc2FibGVfeWF3X21vZGlmaWVycyI6dHJ1ZX0sIn5sYWdfZXhwbG9pdCI6eyJ0aWNrcyI6MTYuMH0sIn5tYW51YWxfeWF3Ijp7Im1hbnVhbF9vdmVyX2ZzIjp0cnVlLCJzdGF0aWNfeWF3Ijp0cnVlfSwifnNhZmVfaGVhZCI6eyJ0cmlnZ2VycyI6WyJBaXItQ3JvdWNoIEtuaWZlIiwifiJdfX0sImhvbWUiOnsic2VsZWN0X3RhYiI6Mi4wfSwibWlzYyI6eyJpbl9nYW1lIjp7ImFzcGVjdF9yYXRpbyI6dHJ1ZSwiY2xhbnRhZyI6ZmFsc2UsImtlZXBfbW9kZWxfdHJhbnNwYXJlbmN5Ijp0cnVlLCJ0cmFzaHRhbGsiOnRydWUsInZpZXdtb2RlbF9jaGFuZ2VyIjp0cnVlLCJ+YXNwZWN0X3JhdGlvIjp7InJhdGlvIjoxMzMuMH0sIn52aWV3bW9kZWxfY2hhbmdlciI6eyJ2aWV3bW9kZWxfZm92Ijo2NzAwLjAsInZpZXdtb2RlbF94IjoxMDAuMCwidmlld21vZGVsX3kiOi00MDAuMCwidmlld21vZGVsX3oiOjUwLjB9fSwibW92ZW1lbnQiOnsiZWRnZV9zdG9wIjpmYWxzZSwiZmFzdF9sYWRkZXIiOnRydWUsImp1bXBfc2NvdXQiOnRydWUsIm5vX2ZhbGxfZGFtYWdlIjp0cnVlfSwicmFnZWJvdCI6eyJhaW1ib3RfbG9ncyI6dHJ1ZSwiYW50aV9haW1fY29ycmVjdGlvbiI6ZmFsc2UsImRlY3JlYXNlX2hvbGRfYWltX3RpY2tzIjpmYWxzZSwiZmFrZV9sYXRlbmN5IjowLjAsImdyZW5hZGVfdGhyb3dfZml4Ijp0cnVlLCJoaXRjaGFuY2UiOnRydWUsIn5haW1ib3RfbG9ncyI6eyJoaXRfY29sb3IiOiIjQkE5RkRERkYiLCJtaXNzX2NvbG9yIjoiI0U2OTY5NkZGIiwib3V0cHV0IjpbIkNvbnNvbGUiLCJFdmVudCIsIk5vdGlmeSIsIn4iXSwicHVyY2hhc2VfbG9ncyI6dHJ1ZX0sIn5oaXRjaGFuY2UiOnsiYXV0b19zbmlwZXJzX2Fpcl9hbW91bnQiOjMzLjAsImF1dG9fc25pcGVyc19ub19zY29wZV9hbW91bnQiOjUwLjAsImF3cF9haXJfYW1vdW50IjozMy4wLCJhd3Bfbm9fc2NvcGVfYW1vdW50Ijo1MC4wLCJjdXJyZW50X3dlYXBvbiI6NC4wLCJlbmFibGVfYXV0b19zbmlwZXJzIjp0cnVlLCJlbmFibGVfYXdwIjpmYWxzZSwiZW5hYmxlX3Bpc3RvbHMiOnRydWUsImVuYWJsZV9yZXZvbHZlciI6dHJ1ZSwiZW5hYmxlX3NzZzA4Ijp0cnVlLCJwaXN0b2xzX2Fpcl9hbW91bnQiOjMzLjAsInJldm9sdmVyX2Fpcl9hbW91bnQiOjMzLjAsInNzZzA4X2Fpcl9hbW91bnQiOjMzLjAsInNzZzA4X25vX3Njb3BlX2Ftb3VudCI6NTAuMH19fSwidmlzdWFscyI6eyJhbmltYXRlZF96b29tIjpmYWxzZSwiY2VudGVyZWRfaW5kaWNhdG9ycyI6ZmFsc2UsImNsaWVudF9zaWRlX2FuaW1hdGlvbnMiOnRydWUsImN1c3RvbV9zY29wZV9vdmVybGF5Ijp0cnVlLCJkYW1hZ2VfaW5kaWNhdG9yIjp0cnVlLCJnYW1lc2Vuc2VfaW5kaWNhdG9ycyI6ZmFsc2UsImdyZW5hZGVfd2FybmluZyI6ZmFsc2UsImhpdG1hcmtlciI6ZmFsc2UsImtleWJpbmRzIjpmYWxzZSwibWFudWFsX2Fycm93cyI6ZmFsc2UsInNwZWN0YXRvcnMiOmZhbHNlLCJ2ZWxvY2l0eV9pbmRpY2F0b3IiOnRydWUsIndhdGVybWFyayI6dHJ1ZSwifmNlbnRlcmVkX2luZGljYXRvcnMiOnsiY2VudGVyZWRfaW5kaWNhdG9yc19jb2xvciI6IiNFNzk1QzdGRiIsIm9mZnNldCI6NDAuMH0sIn5jbGllbnRfc2lkZV9hbmltYXRpb25zIjp7ImFkZG9ucyI6WyJNb3ZlIExlYW4iLCJ+Il0sImFpcl9sZWdzIjoiRGlzYWJsZWQiLCJncm91bmRfbGVncyI6IkRpc2FibGVkIiwibW92ZV9sZWFuX2Ftb3VudCI6MTAwLjB9LCJ+Y3VzdG9tX3Njb3BlX292ZXJsYXkiOnsiZ2FwIjo1LjAsImludmVydGVkIjpmYWxzZSwic2NvcGVfY29sb3IiOiIjQUFBQUFBRkYiLCJzaXplIjoxNTAuMCwidF9wb3NlIjpmYWxzZSwidmlld21vZGVsX2luX3Njb3BlIjpmYWxzZX0sIn5kYW1hZ2VfaW5kaWNhdG9yIjp7ImZvbnQiOiJEZWZhdWx0In0sIn5nYW1lc2Vuc2VfaW5kaWNhdG9ycyI6eyJhbmltYXRlZCI6ZmFsc2UsInNlbGVjdCI6WyJEb3VibGUgVGFwIiwiSGlkZSBTaG90cyIsIkZha2UgTGF0ZW5jeSIsIk1pbi4gRGFtYWdlIE92ZXJyaWRlIiwiQm9keSBBaW0iLCJGb3JjZSBTYWZlIFBvaW50IiwiRnJlZXN0YW5kaW5nIiwiRG9ybWFudCBBaW1ib3QiLCJCb21iIEluZm9ybWF0aW9uIiwiSGl0L01pc3MgUmF0ZSIsIn4iXSwic3R5bGUiOiJDbGFzc2ljIn0sIn5ncmVuYWRlX3dhcm5pbmciOnsiZ3JlbmFkZV93YXJuaW5nX2NvbG9yIjoiI0IxOUNENEZGIn0sIn5oaXRtYXJrZXIiOnsiaGl0bWFya2VyX2NvbG9yIjoiI0ZGRkZGRkZGIn0sIn5rZXliaW5kcyI6eyJrZXliaW5kc19jb2xvciI6IiNGRkZGRkZGRiJ9LCJ+bWFudWFsX2Fycm93cyI6eyJhcnJvd3NfY29sb3IiOiIjQjk5MUNCRkYiLCJhcnJvd3Nfc3R5bGUiOiJDbGFzc2ljIiwib2Zmc2V0Ijo1OC4wfSwifnNwZWN0YXRvcnMiOnsic3BlY3RhdG9yc19jb2xvciI6IiNGRkZGRkZGRiJ9LCJ+dmVsb2NpdHlfaW5kaWNhdG9yIjp7InZlbG9jaXR5X2luZGljYXRvcl9jb2xvciI6IiNGRkI0RTJGRiJ9LCJ+d2F0ZXJtYXJrIjp7InN0eWxlIjoiTW9kZXJuIiwid2F0ZXJtYXJrX2NvbG9yIjoiI0FDOTVDMkZGIn19fV0="
    config_system.save_config = function(id)
        if id == 1 then return end
        local raw = config:save()
        configdata.cfg_list[id][2] = base64.encode(json.stringify(raw))
        cvar.play:call("ambient\\tones\\elev1")
        db.nyahook_dbshka = configdata
    end
    
    config_system.update_values = function(id)
        local name = configdata.cfg_list[id][1]
        local new_name = name .. "\a{Link Active} ~ Loaded"

        for k, v in ipairs(configdata.cfg_list) do
            configdata.menu_list[k] = v[1]
        end

        configdata.menu_list[id] = new_name
    end
    
    config_system.create_config = function(name)
        if type(name) ~= 'string' then return end
        if name == nil or name == '' or name == ' ' then return end
        for i=#configdata.menu_list, 1, -1 do if configdata.menu_list[i] == name then common.add_notify('\vNyaHook', 'Config with this name has already been created.') return end end
        if #configdata.cfg_list > 10 then common.add_notify('\vNyaHook', 'Too much configs') return end
        local completed = {name, ''}
        table.insert(configdata.cfg_list, completed)
        table.insert(configdata.menu_list, name)
        db.nyahook_dbshka = configdata
    end
    
    config_system.remove_config = function(id)
        if id == 1 then return end
        local item = configdata.cfg_list[id][1]
        for i=#configdata.cfg_list, 1, -1 do if configdata.cfg_list[i][1] == item then table.remove(configdata.cfg_list, i) table.remove(configdata.menu_list, i) end end
        db.nyahook_dbshka = configdata
    end
    
    config_system.load_config = function(id)
        if configdata.cfg_list[id][2] == nil or configdata.cfg_list[id][2] == '' then print("Error[data_base[".. id .."]]") return end
        if id > #configdata.cfg_list then print("Error[data_base[".. id .."]]") return end
        config:load(json.parse(base64.decode(configdata.cfg_list[id][2])))
        cvar.play:call("ambient\\tones\\elev1")
    end

    configs = {
        cfg_selector = menu.tabs.home.image:list('', configdata.menu_list),
        name = menu.tabs.home.image:input("\v\f<file-pen>\r" .. "  Config name"),
        
        create = menu.tabs.home.image:button("                                 \v\f<paintbrush-fine>\r  Create                               ", function()
            config_system.create_config(configs.name:get())
            configs.cfg_selector:update(configdata.menu_list)
        end, true),
    
        load = menu.tabs.home.image:button("   \v\f<upload>\r  Load   ", function()
            config_system.update_values(configs.cfg_selector:get())
            config_system.load_config(configs.cfg_selector:get())
            configs.cfg_selector:update(configdata.menu_list)
        end, true),

        save = menu.tabs.home.image:button("   \v\f<floppy-disk>\r  Save   ", function()
            config_system.save_config(configs.cfg_selector:get())
        end, true),

        remove  = menu.tabs.home.image:button("    \v\f<trash-xmark>\r  Remove    ", function()
            config_system.remove_config(configs.cfg_selector:get())
            configs.cfg_selector:update(configdata.menu_list)
        end, true),

        import = menu.tabs.home.image:button("                 \v\f<file-import>\r                 ", function()
            config:load(json.parse(base64.decode(clipboard.get())))
            cvar.play:call("ambient\\tones\\elev1")
        end, true),
    
        export = menu.tabs.home.image:button("                 \v\f<file-export>\r                  ", function()
            clipboard.set(base64.encode(json.stringify(config:save())))
            cvar.play:call("ambient\\tones\\elev1")
        end, true),
    }

    configs.import:tooltip("• Import config from clipboard.")
    configs.export:tooltip("• Export config to clipboard.")
end

events.render:set(function()
    visuals.watermark()
    visuals.gamesense_indicators()
    visuals.centered_indicators()
    visuals.manual_arrows()
    visuals.custom_scope_overlay()
    visuals.hitmarker()

    misc.in_game.aspect_ratio()
    misc.in_game.viewmodel_changer()

    misc.logs.notifications()

    misc.ragebot.fake_latency()
end)

events.createmove:set(function(cmd)
    anti_aim.player_data.write_player_data()
    anti_aim.override_defensive()
    anti_aim.builder(cmd)
    anti_aim.addons()
    
    misc.movement.no_fall_damage(cmd)
    misc.movement.fast_ladder(cmd)
    misc.movement.edge_stop(cmd)
    misc.movement.jump_scout(cmd)
    misc.movement.super_toss(cmd)

    misc.ragebot.hitchance(cmd)
    misc.ragebot.grenade_throw_fix()
end)

events.grenade_override_view:set(misc.movement.on_grenade_override_view)

events.player_death:set(misc.in_game.trashtalk.trashtalk)

events.aim_ack:set(function(e)
    misc.logs.aimbot(e)
    visuals.hitmarker_refs.hitmarker_ack(e)

    if e.state == nil then visuals.total_hits = visuals.total_hits + 1 end
    visuals.total_registered_shots = visuals.total_registered_shots + 1
end)

events.player_hurt:set(misc.logs.additional)

events.item_purchase:set(misc.logs.purchase)

events.localplayer_transparency:set(misc.in_game.keep_model_transparency)

events.override_view:set(visuals.animated_zoom)

events.post_update_clientside_animation:set(visuals.client_side_animations)

events.grenade_warning:set(visuals.grenade_warning)

events.round_end:set(function()
    round_end_trigger = true
end)

events.round_start:set(function()
    round_end_trigger = false

    table.insert(misc.logs.notify_data, 1, {
        text = string.format("\v Reset on new round!", target_name, state, wanted_hitgroup), 
        alpha = 0, alpha_text = 0, add_x = 0, add_y = 0, time = globals.realtime, color = menu.misc.ragebot.aimbot_logs.hit_color:get()})

    anti_aim.player_data.entindex = -1
    anti_aim.player_data.alive = false
    anti_aim.player_data.onground = true
    anti_aim.player_data.velocity = 0.0
    anti_aim.player_data.duckamount = 0.0
    anti_aim.player_data.stamina = 80.0
    anti_aim.player_data.onground_ticks = 0
    anti_aim.player_data.stateid = 1
end)

events.shutdown:set(function()
    cvar.sv_maxunlag:float(0.200)

    cvar.r_aspectratio:float(0)

    cvar.viewmodel_fov:float(68)
    cvar.viewmodel_offset_x:float(2.5)
    cvar.viewmodel_offset_y:float(0)
    cvar.viewmodel_offset_z:float(-1.5)

    cvar.sv_maxusrcmdprocessticks_holdaim:int(1)

    db.nyahook_dbshka = configdata
end)

events.mouse_input:set(function()
    if ui.get_alpha() > 0 then
        return false
    end
end)