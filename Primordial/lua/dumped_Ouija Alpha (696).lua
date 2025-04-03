local args = {...}
local render_text = render.text
-- comment out smart stuff

-- CLASSY_SECURITY_INIT()
-- SECURITY_EXCEPTION_START()
-- local alpha_v = CLASSY_SECURITY_ALPHA()

local json = require("primordial/JSON Library.97")
local alpha_v = true
local lua_version =  alpha_v and "2.1.9" or "Release 2.1.9"
local alpha_v_text = alpha_v and "ALPHA" or ""
local screen_size = render.get_screen_size()
local forumInfo = {name = user.name, uid = user.uid}

local ui_handler = {}
local anti_brute = {}
local fonts = {}
local prim_ref = {}
local ouija_fs = {}
local configs = {}
local static_sizes = {}

static_sizes.kill_static = function()

    static_sizes.O_text_size = render.get_text_size(fonts.verdana, "O")
    static_sizes.U_text_size = render.get_text_size(fonts.verdana, "u")
    static_sizes.I_text_size = render.get_text_size(fonts.verdana, "i")
    static_sizes.J_text_size = render.get_text_size(fonts.verdana, "j")

    static_sizes.A_text_size = render.get_text_size(fonts.verdana, "a")

    static_sizes.dot_text_size = render.get_text_size(fonts.verdana, ".")
    static_sizes.L_text_size = render.get_text_size(fonts.verdana, "l")
    static_sizes.U2_text_size = render.get_text_size(fonts.verdana, "u")
    static_sizes.A2_text_size = render.get_text_size(fonts.verdana, "a")

    static_sizes.pre_pre_text_data = render.get_text_size(fonts.verdana_s, "[")
    static_sizes.pre_text_data = render.get_text_size(fonts.verdana_s, "Ouija.Lua")

end

fonts.refresh = function(value)

    fonts.verdana = nil
    fonts.pix = nil
    fonts.debug = nil 

    fonts.verdana = render.create_font("Verdana", value, 1, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
    fonts.verdana_s = render.create_font("Verdana", value-1, 1, e_font_flags.DROPSHADOW)
    fonts.pix = render.create_font("Smallest Pixel-7", value-2, 1, e_font_flags.DROPSHADOW)
    fonts.debug =render.create_font("Tahoma", value-2, 1, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)

    static_sizes.kill_static()

end

fonts.fish = render.create_font("Tahoma", 11, 1, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)

ui_handler.tab_list = {}
menu.add_text("Ouija.lua", "Welcome to Ouija.Lua " .. alpha_v_text .. " " .. lua_version)
ui_handler.combo_controller = menu.add_selection("Ouija.lua", "Tab Selection", ui_handler.tab_list)
ui_handler.current_tab = "string"
ui_handler.refs = {}

ui_handler.add_element = function(tab, element, complex, cheat_var, condition)

    if condition == nil then
        condition = function()
            return true
        end
    end
    if ui_handler.refs[tab] == nil then
        ui_handler.refs[tab] = {}
       
        table.insert(ui_handler.tab_list, tab)
        ui_handler.combo_controller:set_items(ui_handler.tab_list)
    end
    if ui_handler.refs[tab][element] ~= nil then
        error("Element", element, "already exists in", tab, "tab")
    end
    ui_handler.refs[tab][element] = {
        table = complex,
        ref = cheat_var,
        condition = function()
            return ui_handler.current_tab == tab and condition()
        end
    }

    return cheat_var
end

ui_handler.add_element("Visuals", "window_select", true, menu.add_multi_selection("Visuals", "Windows", {"Binds List", "Spectators List", "Watermark"}))
ui_handler.add_element("Visuals", "window_style", false, menu.add_selection("Visuals", "- Windows Style", {"Rounded", "Simple", "Half Round"}),function()
    return ui_handler.refs["Visuals"]["window_select"].ref:get(1) or ui_handler.refs["Visuals"]["window_select"].ref:get(2) or ui_handler.refs["Visuals"]["window_select"].ref:get(3)
end)
ui_handler.add_element("Visuals", "windows_grad", false, menu.add_checkbox("Visuals", "Use Gradient Color", false),function()
    return ui_handler.refs["Visuals"]["window_select"].ref:get(1) and ui_handler.refs["Visuals"]["window_style"].ref:get() == 2 or ui_handler.refs["Visuals"]["window_select"].ref:get(2) and ui_handler.refs["Visuals"]["window_style"].ref:get() == 2 or ui_handler.refs["Visuals"]["window_select"].ref:get(3) and ui_handler.refs["Visuals"]["window_style"].ref:get() == 2
end)
ui_handler.add_element("Visuals", "watermark_options", true, menu.add_multi_selection("Visuals","- Watermark Options", {"Replace lua name with primordial", "Show lua Version","Forum Name", "Forum UID", "KDR", "Ping", "Fps"}),function()
    return ui_handler.refs["Visuals"]["window_select"].ref:get(3)
end)

ui_handler.add_element("Visuals", "binds_x", false, menu.add_slider("Visuals", "hidden_binds_x_pos", 0,screen_size.x),function()
    return false
end)
ui_handler.add_element("Visuals", "binds_y", false, menu.add_slider("Visuals", "hidden_binds_y_pos", 0,screen_size.y),function()
    return false
end)
ui_handler.add_element("Visuals", "spec_x", false, menu.add_slider("Visuals", "hidden_spectators_x_pos", 0,screen_size.x),function()
    return false
end)
ui_handler.add_element("Visuals", "spec_y", false, menu.add_slider("Visuals", "hidden_spectators_y_pos", 0,screen_size.y),function()
    return false
end)
ui_handler.add_element("Visuals", "water_x", false, menu.add_slider("Visuals", "hidden_water_x_pos", 0,screen_size.x),function()
    return false
end)
ui_handler.add_element("Visuals", "water_y", false, menu.add_slider("Visuals", "hidden_water_y_pos", 0,screen_size.y),function()
    return false
end)

ui_handler.add_element("Visuals", "notifications", false, menu.add_checkbox("Visuals", "Enable Notifications", false))
ui_handler.add_element("Visuals", "notifications_screen", true, menu.add_multi_selection("Visuals","- On Screen Notifications", {"Hitlogs", "Misslogs", "AA Info"}),function()
    return ui_handler.refs["Visuals"]["notifications"].ref:get()
end)
ui_handler.add_element("Visuals", "notifications_console", true, menu.add_multi_selection("Visuals","- In Console Notifications", {"Hitlogs", "Misslogs", "AA Info"}),function()
    return ui_handler.refs["Visuals"]["notifications"].ref:get()
end)
ui_handler.add_element("Visuals", "hit_color_text", false, menu.add_text("Visuals", "- Notifications Hit Color"), function()
    return ui_handler.refs["Visuals"]["notifications"].ref:get() and ui_handler.refs["Visuals"]["notifications_console"].ref:get(1) or ui_handler.refs["Visuals"]["notifications"].ref:get() and ui_handler.refs["Visuals"]["notifications_screen"].ref:get(1)
end)
ui_handler.add_element("Visuals", "miss_color_text", false, menu.add_text("Visuals", "- Notifications Miss Color"), function()
    return ui_handler.refs["Visuals"]["notifications"].ref:get() and ui_handler.refs["Visuals"]["notifications_console"].ref:get(2) or ui_handler.refs["Visuals"]["notifications"].ref:get() and ui_handler.refs["Visuals"]["notifications_screen"].ref:get(2)
end)
ui_handler.add_element("Visuals", "aa_info_color_text", false, menu.add_text("Visuals", "- Notifications AA Info Color"), function()
    return ui_handler.refs["Visuals"]["notifications"].ref:get() and ui_handler.refs["Visuals"]["notifications_console"].ref:get(3) or ui_handler.refs["Visuals"]["notifications"].ref:get() and ui_handler.refs["Visuals"]["notifications_screen"].ref:get(3)
end)
ui_handler.add_element("Visuals", "hitmarker", false, menu.add_checkbox("Visuals", "Enabe World Hitmarker", false))
ui_handler.add_element("Visuals", "autopeek", false, menu.add_checkbox("Visuals", "Enable Pentagram AutoPeek", false))
ui_handler.add_element("Visuals", "fish_esp", false, menu.add_checkbox("Visuals", "Enable Jordan ESP", false),function()
    return alpha_v 
end)
ui_handler.add_element("Visuals", "brute_vis", false, menu.add_checkbox("Visuals", "Visualise Anti Brute Force", false))

ui_handler.add_element("Visuals", "undercrosshair", false, menu.add_checkbox("Indicators", "Crosshair Indicators", false))
ui_handler.add_element("Visuals", "undercrosshair_offset", false, menu.add_slider("Indicators", "Crosshair Indicators Offset", 0, math.floor(screen_size.y/3)), function()
    return false
end)
ui_handler.add_element("Visuals", "undercrosshair_display", true, menu.add_multi_selection("Indicators", "- Display options", {"Lua Name", "AA-Info", "Double Tap", "Hide Shots", "Fake Duck", "Damage Override"}), function()
    return ui_handler.refs["Visuals"]["undercrosshair"].ref:get()
end)
ui_handler.add_element("Visuals", "undercrosshair_options", true, menu.add_multi_selection("Indicators", "- Indicator options", {"Move when scoped", "Use Short Bind Names", "Binds Inline"}), function()
    return ui_handler.refs["Visuals"]["undercrosshair"].ref:get()
end)
ui_handler.add_element("Visuals", "undercrosshair_config", false, menu.add_selection("Indicators", "Undercrosshair Config", {"-","Lua Name", "AA-Info", "Colors"}), function()
    return ui_handler.refs["Visuals"]["undercrosshair"].ref:get()
end)
ui_handler.add_element("Visuals", "lua_name_animated", false, menu.add_checkbox("Indicators", "- Animate Lua Name", false), function()
    return ui_handler.refs["Visuals"]["undercrosshair"].ref:get() and ui_handler.refs["Visuals"]["undercrosshair_display"].ref:get(1) and ui_handler.refs["Visuals"]["undercrosshair_config"].ref:get() == 2
end)
ui_handler.add_element("Visuals", "lua_name_style", false, menu.add_selection("Indicators", "- Lua Name Style", {"Solid", "AA Side", "Animated", "Gradient"}), function()
    return ui_handler.refs["Visuals"]["undercrosshair"].ref:get() and ui_handler.refs["Visuals"]["undercrosshair_display"].ref:get(1) and ui_handler.refs["Visuals"]["undercrosshair_config"].ref:get() == 2
end)
ui_handler.add_element("Visuals", "lua_name_grad1", false, menu.add_text("Indicators", "- Gradient Color 1"), function()
    return ui_handler.refs["Visuals"]["undercrosshair"].ref:get() and ui_handler.refs["Visuals"]["undercrosshair_display"].ref:get(1) and ui_handler.refs["Visuals"]["undercrosshair_config"].ref:get() == 2 and ui_handler.refs["Visuals"]["lua_name_style"].ref:get() == 4
end)
ui_handler.add_element("Visuals", "lua_name_grad2", false, menu.add_text("Indicators", "- Gradient Color 2"), function()
    return ui_handler.refs["Visuals"]["undercrosshair"].ref:get() and ui_handler.refs["Visuals"]["undercrosshair_display"].ref:get(1) and ui_handler.refs["Visuals"]["undercrosshair_config"].ref:get() == 2 and ui_handler.refs["Visuals"]["lua_name_style"].ref:get() == 4
end)
ui_handler.add_element("Visuals", "lua_name_grad3", false, menu.add_text("Indicators", "- Gradient Color 3"), function()
    return ui_handler.refs["Visuals"]["undercrosshair"].ref:get() and ui_handler.refs["Visuals"]["undercrosshair_display"].ref:get(1) and ui_handler.refs["Visuals"]["undercrosshair_config"].ref:get() == 2 and ui_handler.refs["Visuals"]["lua_name_style"].ref:get() == 4
end)
ui_handler.add_element("Visuals", "aa_info_color", false, menu.add_checkbox("Indicators", "- Use Desync Color", false), function()
    return ui_handler.refs["Visuals"]["undercrosshair"].ref:get() and ui_handler.refs["Visuals"]["undercrosshair_display"].ref:get(2) and ui_handler.refs["Visuals"]["undercrosshair_config"].ref:get() == 3
end)
ui_handler.add_element("Visuals", "aa_info_display", false, menu.add_selection("Indicators", "- AA Info Display", {"AA State", "AA Info"}), function()
    return ui_handler.refs["Visuals"]["undercrosshair"].ref:get() and ui_handler.refs["Visuals"]["undercrosshair_display"].ref:get(2) and ui_handler.refs["Visuals"]["undercrosshair_config"].ref:get() == 3
end)
ui_handler.add_element("Visuals", "double_tap_color_text", false ,menu.add_text("Indicators", "- Double Tap Color"), function()
    return ui_handler.refs["Visuals"]["undercrosshair"].ref:get() and ui_handler.refs["Visuals"]["undercrosshair_display"].ref:get(3) and ui_handler.refs["Visuals"]["undercrosshair_config"].ref:get() == 4
end)
ui_handler.add_element("Visuals", "hideshots_color_text", false ,menu.add_text("Indicators", "- Hideshots Color"), function()
    return ui_handler.refs["Visuals"]["undercrosshair"].ref:get() and ui_handler.refs["Visuals"]["undercrosshair_display"].ref:get(4) and ui_handler.refs["Visuals"]["undercrosshair_config"].ref:get() == 4
end)
ui_handler.add_element("Visuals", "fakeduck_color_text", false ,menu.add_text("Indicators", "- Fake Duck Color"), function()
    return ui_handler.refs["Visuals"]["undercrosshair"].ref:get() and ui_handler.refs["Visuals"]["undercrosshair_display"].ref:get(5) and ui_handler.refs["Visuals"]["undercrosshair_config"].ref:get() == 4
end)
ui_handler.add_element("Visuals", "damage_override_color_text", false ,menu.add_text("Indicators", "- Damage Override Color"), function()
    return ui_handler.refs["Visuals"]["undercrosshair"].ref:get() and ui_handler.refs["Visuals"]["undercrosshair_display"].ref:get(5) and ui_handler.refs["Visuals"]["undercrosshair_config"].ref:get() == 4
end)
ui_handler.add_element("Visuals", "dmg_indicator", false, menu.add_selection("Indicators", "Damage Indicator", {"Disabled","Align Left", "Center", "Align Right"}))
ui_handler.add_element("Visuals", "dmg_offset", false, menu.add_slider("Indicators", "- Damage Indicator Offset", 0, 100), function()
    return ui_handler.refs["Visuals"]["dmg_indicator"].ref:get()> 1
end)
ui_handler.add_element("Visuals", "arrows", false, menu.add_selection("Indicators", "Arrows", {"Disabled", "Direction arrows","Anti Aim Arrows"}))
ui_handler.add_element("Visuals", "arrows_offset", false, menu.add_slider("Indicators", "- Arrows Offset", 10, math.floor(screen_size.x/5)), function()
    return ui_handler.refs["Visuals"]["arrows"].ref:get() > 1
end)

local aa_conditions = {"standing_","slowwalk_","running_","crouching_","in_air_","crouch_in_air_", "warmup_", "dormant_"}
local aa_conditions_comp = {"Standing","Slowwalk","Running","Crouching","In Air","Crouch In Air", "Warmup", "Dormant"}

ui_handler.add_element("Anti Aim", "enable_aa", false, menu.add_checkbox("Anti Aim", "Enable Anti Aim", false))
ui_handler.add_element("Anti Aim", "Anti Aim mode", false, menu.add_selection("Anti Aim", "Anti Aim Mode", {"Preset | Jitter", "Preset | Static", "Preset | Roll", "Custom"}), function()
    return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get()
end)
ui_handler.add_element("Anti Aim", "condition_select", false, menu.add_selection("Anti Aim", "- Anti Aim Condition", aa_conditions_comp), function()
    return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4
end)


for i = 1, #aa_conditions do 
    if i == 7 or i == 8 then 
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "enable" , false, menu.add_checkbox(aa_conditions_comp[i] .. " Condition", "Enable " .. aa_conditions_comp[i] .. " condition", false), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "aa_mode", false, menu.add_selection(aa_conditions_comp[i] .. " Condition", "AA Mode", {"Preset | Jitter", "Preset | Jitter", "Preset | Roll", "Custom"}), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get()
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yaw_add_mode", false, menu.add_selection(aa_conditions_comp[i] .. " Condition", "Yaw Add Mode", {"Static", "Jitter"}), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yaw_add_L", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Yaw Add Left", -120, 120), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "yaw_add_mode"].ref:get() == 1
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yaw_add_R", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Yaw Add Right", -120, 120), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "yaw_add_mode"].ref:get() == 1
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yaw_jitter_L", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Yaw Jitter Left", -120, 120), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "yaw_add_mode"].ref:get() == 2
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yaw_jitter_R", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Yaw Jitter Right", -120, 120), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "yaw_add_mode"].ref:get() == 2
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yaw_rotate", false, menu.add_checkbox(aa_conditions_comp[i] .. " Condition","Yaw rotate", false), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yaw_rotate_range", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Rotate range", 0, 360), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "yaw_rotate"].ref:get()
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yaw_rotate_speed", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Rotate speed", 0, 100), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "yaw_rotate"].ref:get()
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "desync_side", false, menu.add_selection(aa_conditions_comp[i] .. " Condition", "Desync side", {"Left", "Right", "Peek Fake", "Peek Real"}), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "max_limit", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Max Desync limit", 0, 100), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "min_limit", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Min Desync limit", 0, 100), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yawjitter_mode", false, menu.add_selection(aa_conditions_comp[i] .. " Condition", "Yaw Jitter Mode", {"Disabled", "Static", "Random"}), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yawjitter_type", false, menu.add_selection(aa_conditions_comp[i] .. " Condition", "Yaw Jitter Type", {"Offset", "Center"}), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "yawjitter_mode"].ref:get() > 1
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yawjitter_range", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Yaw Jitter Range", -90, 90), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "yawjitter_mode"].ref:get() > 1
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "seperator", false, menu.add_text(aa_conditions_comp[i] .. " Condition", ""), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "jitter_condition", true, menu.add_multi_selection(aa_conditions_comp[i] .. " Condition", "[Advanced] Jitter on condition", {"Always", "On peek", "Anti-Brute", "Dormant"}), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i].. "lean_condition", true, menu.add_multi_selection(aa_conditions_comp[i] .. " Condition", "[Advanced] Body lean on condition", {"Always", "Lethal"}), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "body_lean_type", false, menu.add_selection(aa_conditions_comp[i] .. " Condition", "Body lean type", { "Static", "Static Jitter", "Random Jitter", "Sway"}), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(1) or ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(2) or ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(3)
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "body_lean_range_L", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Body lean range Left", -50, 50), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(1) or ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(2) or ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(3)
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "body_lean_range_R", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Body lean range Right", -50, 50), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(1) or ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(2) or ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(3)
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "moving_body_lean", false, menu.add_checkbox(aa_conditions_comp[i] .. " Condition","Moving Body Lean", false), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "enable"].ref:get() and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(1) or ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(2) or ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(3)
        end)
    else
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "aa_mode", false, menu.add_selection(aa_conditions_comp[i] .. " Condition", "AA Mode", {"Preset | Jitter", "Preset | Static", "Preset | Roll", "Custom"}), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yaw_add_mode", false, menu.add_selection(aa_conditions_comp[i] .. " Condition", "Yaw Add Mode", {"Static", "Jitter"}), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yaw_add_L", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Yaw Add Left", -120, 120), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "yaw_add_mode"].ref:get() == 1   
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yaw_add_R", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Yaw Add Right", -120, 120), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "yaw_add_mode"].ref:get() == 1
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yaw_jitter_L", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Yaw Jitter Left", -90, 90), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "yaw_add_mode"].ref:get() == 2
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yaw_jitter_R", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Yaw Jitter Right", -90, 90), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "yaw_add_mode"].ref:get() == 2
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yaw_rotate", false, menu.add_checkbox(aa_conditions_comp[i] .. " Condition","Yaw rotate", false), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yaw_rotate_range", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Rotate range", 0, 360), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "yaw_rotate"].ref:get()
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yaw_rotate_speed", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Rotate speed", 0, 100), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "yaw_rotate"].ref:get()
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "desync_side", false, menu.add_selection(aa_conditions_comp[i] .. " Condition", "Desync side", {"Left", "Right", "Peek Fake", "Peek Real"}), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "max_limit", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Max Desync limit", 0, 100), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "min_limit", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Min Desync limit", 0, 100), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yawjitter_mode", false, menu.add_selection(aa_conditions_comp[i] .. " Condition", "Yaw Jitter Mode", {"Disabled", "Static", "Random"}), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yawjitter_type", false, menu.add_selection(aa_conditions_comp[i] .. " Condition", "Yaw Jitter Type", {"Offset", "Center"}), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "yawjitter_mode"].ref:get() > 1
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "yawjitter_range", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Yaw Jitter Range", -90, 90), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "yawjitter_mode"].ref:get() > 1
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "seperator", false, menu.add_text(aa_conditions_comp[i] .. " Condition", ""), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "jitter_condition", true, menu.add_multi_selection(aa_conditions_comp[i] .. " Condition", "[Advanced] Jitter on condition", {"Always", "On peek", "Anti-Brute", "Dormant"}), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i].. "lean_condition", true, menu.add_multi_selection(aa_conditions_comp[i] .. " Condition", "[Advanced] Body lean on condition", {"Always", "Lethal"}), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "body_lean_type", false, menu.add_selection(aa_conditions_comp[i] .. " Condition", "Body lean type", { "Static", "Static Jitter", "Random Jitter", "Sway"}), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(1) or ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(2) or ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(3)
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "body_lean_range_L", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Body lean range Left", -50, 50), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(1) or ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(2) or ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(3)
        end)
        ui_handler.add_element("Anti Aim", aa_conditions[i] .. "body_lean_range_R", false, menu.add_slider(aa_conditions_comp[i] .. " Condition", "Body lean range Right", -50, 50), function()
            return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == i and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(1) or ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(2) or ui_handler.refs["Anti Aim"][aa_conditions[i] .. "lean_condition"].ref:get(3)
        end)
    end
end
ui_handler.add_element("Anti Aim", "crouching_moving_body_lean", false, menu.add_checkbox("Crouching" .. " Condition","Moving Body Lean", false), function()
    return ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() and ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["condition_select"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["crouching_" .. "aa_mode"].ref:get() == 4 and ui_handler.refs["Anti Aim"]["crouching_" .. "lean_condition"].ref:get(1) or ui_handler.refs["Anti Aim"]["crouching_" .. "lean_condition"].ref:get(2) or ui_handler.refs["Anti Aim"]["crouching_" .. "lean_condition"].ref:get(3)
end)

ui_handler.add_element("Anti Aim", "anti_knife", false, menu.add_checkbox("Anti Aim Misc", "Enable Anti Knife", false))
ui_handler.add_element("Anti Aim", "anti_knife_dist", false, menu.add_slider("Anti Aim Misc", "- Anti Knife Distance", 0, 300), function()
    return ui_handler.refs["Anti Aim"]["anti_knife"].ref:get()
end)
ui_handler.add_element("Anti Aim", "anim_breakers", true, menu.add_multi_selection("Anti Aim Misc", "Anim breakers", {"Zero Pitch on land", "Static Legs"}))

ui_handler.add_element("Anti Aim", "fl_options", false, menu.add_checkbox("Anti Aim Misc", "Enable Fake Lag Settings", false))
ui_handler.add_element("Anti Aim", "fl_mode", false, menu.add_selection("Anti Aim Misc", "- Fake Lag Mode", {"Static", "Adaptive"}), function()
    return ui_handler.refs["Anti Aim"]["fl_options"].ref:get()
end)
ui_handler.add_element("Anti Aim", "fl_amount", false, menu.add_slider("Anti Aim Misc", "- Fake Lag Amount", 0, 15), function()
    return ui_handler.refs["Anti Aim"]["fl_options"].ref:get()
end)
ui_handler.add_element("Anti Aim", "fl_break_lg", false, menu.add_checkbox("Anti Aim Misc", "- Break Lag Comp", false), function()
    return ui_handler.refs["Anti Aim"]["fl_options"].ref:get()
end)
ui_handler.add_element("Anti Aim", "fl_in_air", false, menu.add_checkbox("Anti Aim Misc", "- Disable in air", false), function()
    return ui_handler.refs["Anti Aim"]["fl_options"].ref:get()
end)

local rage_weapons = {"Scout", "Auto", "AWP", "Pistols", "Deagle/Revolver"}

ui_handler.add_element("Ragebot", "enable_rage", false, menu.add_checkbox("Ragebot Weapons", "Enable Weapon Settings", false))
ui_handler.add_element("Ragebot", "rage_vis", false, menu.add_checkbox("Ragebot Weapons", "[Visual] Show ragebot state", false), function()
    return ui_handler.refs["Ragebot"]["enable_rage"].ref:get()
end)
ui_handler.add_element("Ragebot", "weapon_select", false, menu.add_selection("Ragebot Weapons", "Weapon Select", rage_weapons), function()
    return ui_handler.refs["Ragebot"]["enable_rage"].ref:get()
end)
local rage_weapons_conditions = {"Global", "In Air", "Self Height Advantage", "Target Height Advantage","On Doubletap"}
local rage_weapons_hitboxes = {"Head", "Body", "Limbs"}
for i = 1, #rage_weapons do 
    ui_handler.add_element("Ragebot", rage_weapons[i].. "_enable", false, menu.add_checkbox("Ragebot Weapons", "[" .. rage_weapons[i] .. "] Enable", false), function()
        return ui_handler.refs["Ragebot"]["enable_rage"].ref:get() and ui_handler.refs["Ragebot"]["weapon_select"].ref:get() == i
    end)
    ui_handler.add_element("Ragebot", rage_weapons[i] .. "_condition", false, menu.add_selection("Ragebot Weapons", "[" .. rage_weapons[i] .. "] Select Condition", rage_weapons_conditions), function()
        return ui_handler.refs["Ragebot"]["enable_rage"].ref:get() and ui_handler.refs["Ragebot"]["weapon_select"].ref:get() == i and ui_handler.refs["Ragebot"][rage_weapons[i] .. "_enable"].ref:get()
    end)
    for l = 1, #rage_weapons_conditions do 
        ui_handler.add_element("Ragebot", rage_weapons[i] .. rage_weapons_conditions[l] .. "_enable", false, menu.add_checkbox("Ragebot Weapons", "[" .. rage_weapons[i] .. "][" .. rage_weapons_conditions[l] ..  "] Enable", false), function()
            return ui_handler.refs["Ragebot"]["enable_rage"].ref:get() and ui_handler.refs["Ragebot"]["weapon_select"].ref:get() == i and ui_handler.refs["Ragebot"][rage_weapons[i] .. "_enable"].ref:get() and ui_handler.refs["Ragebot"][rage_weapons[i] .. "_condition"].ref:get() == l
        end)
        ui_handler.add_element("Ragebot", rage_weapons[i] .. rage_weapons_conditions[l] .. "_seperator1", false, menu.add_text("Ragebot Weapons", "[" .. rage_weapons[i] .. "][" .. rage_weapons_conditions[l] ..  "] Settings:"), function()
            return ui_handler.refs["Ragebot"]["enable_rage"].ref:get() and ui_handler.refs["Ragebot"]["weapon_select"].ref:get() == i and ui_handler.refs["Ragebot"][rage_weapons[i] .. "_enable"].ref:get() and ui_handler.refs["Ragebot"][rage_weapons[i] .. "_condition"].ref:get() == l and ui_handler.refs["Ragebot"][rage_weapons[i] .. rage_weapons_conditions[l] .. "_enable"].ref:get()
        end)
        ui_handler.add_element("Ragebot", rage_weapons[i] .. rage_weapons_conditions[l] .. "_hitbox_select", false, menu.add_selection("Ragebot Weapons", "[" .. rage_weapons[i] .. "][" .. rage_weapons_conditions[l] ..  "] Select Hitbox", rage_weapons_hitboxes), function()
            return ui_handler.refs["Ragebot"]["enable_rage"].ref:get() and ui_handler.refs["Ragebot"]["weapon_select"].ref:get() == i and ui_handler.refs["Ragebot"][rage_weapons[i] .. "_enable"].ref:get() and ui_handler.refs["Ragebot"][rage_weapons[i] .. "_condition"].ref:get() == l and ui_handler.refs["Ragebot"][rage_weapons[i] .. rage_weapons_conditions[l] .. "_enable"].ref:get()
        end)
        for j = 1, #rage_weapons_hitboxes do 
            ui_handler.add_element("Ragebot", rage_weapons[i] .. rage_weapons_conditions[l] .. rage_weapons_hitboxes[j] .. "_damage_accuracy", false, menu.add_slider("Ragebot Weapons", "Damage Accuracy", 0, 100), function()
                return ui_handler.refs["Ragebot"]["enable_rage"].ref:get() and ui_handler.refs["Ragebot"]["weapon_select"].ref:get() == i and ui_handler.refs["Ragebot"][rage_weapons[i] .. "_enable"].ref:get() and ui_handler.refs["Ragebot"][rage_weapons[i] .. "_condition"].ref:get() == l and ui_handler.refs["Ragebot"][rage_weapons[i] .. rage_weapons_conditions[l] .. "_enable"].ref:get() and ui_handler.refs["Ragebot"][rage_weapons[i] .. rage_weapons_conditions[l] .. "_hitbox_select"].ref:get() == j
            end)
        end
    end
end

ui_handler.add_element("Ragebot", "in_air_autostop", false, menu.add_checkbox("Ragebot Functions", "In Air Autostop", false))

ui_handler.add_element("Misc", "clantag", false, menu.add_checkbox("Main", "Enable Clantag", false))
ui_handler.add_element("Misc", "killsay", false, menu.add_checkbox("Main", "Enable Killsay", false))
ui_handler.add_element("Misc", "deathsay", false, menu.add_checkbox("Main", "Enable Deathsay", false))
ui_handler.add_element("Misc", "dpi", false, menu.add_slider("Main", "DPI Scale", 5,25))

ui_handler.refs["Misc"]["dpi"].ref:set(13)

menu.set_group_column("Anti Aim Misc", 1)
menu.set_group_column("Anti Aim", 1)
for i = 1, #aa_conditions do 
    menu.set_group_column(aa_conditions_comp[i] .. " Condition", 2)
end
local colors = {
    undercrosshair = ui_handler.refs["Visuals"]["undercrosshair"].ref:add_color_picker("Undercrosshair color"),
    doubletap = ui_handler.refs["Visuals"]["double_tap_color_text"].ref:add_color_picker("Doubletap color"),
    hideshots = ui_handler.refs["Visuals"]["hideshots_color_text"].ref:add_color_picker("Hideshots color"),
    fakeduck = ui_handler.refs["Visuals"]["fakeduck_color_text"].ref:add_color_picker("Fakeduck color"),
    dmg = ui_handler.refs["Visuals"]["damage_override_color_text"].ref:add_color_picker("Damage Override color"),
    g1 = ui_handler.refs["Visuals"]["lua_name_grad1"].ref:add_color_picker("Gradient 1"),
    g2 = ui_handler.refs["Visuals"]["lua_name_grad2"].ref:add_color_picker("Gradient 2"),
    g3 = ui_handler.refs["Visuals"]["lua_name_grad3"].ref:add_color_picker("Gradient 3"),
    hit_color = ui_handler.refs["Visuals"]["hit_color_text"].ref:add_color_picker("Hit color"),
    miss_color = ui_handler.refs["Visuals"]["miss_color_text"].ref:add_color_picker("Miss color"),
    aa_info_color = ui_handler.refs["Visuals"]["aa_info_color_text"].ref:add_color_picker("AA Info color"),
    hitmarker = ui_handler.refs["Visuals"]["hitmarker"].ref:add_color_picker("Hitmarker color"),
    snaplines = ui_handler.refs["Visuals"]["brute_vis"].ref:add_color_picker("Anti brute color"),
    autopeek = ui_handler.refs["Visuals"]["autopeek"].ref:add_color_picker("Pentagram AutoPeek color"),
    windows_grad1 = ui_handler.refs["Visuals"]["windows_grad"].ref:add_color_picker("Windows Gradient 1"),
    windows_grad2 = ui_handler.refs["Visuals"]["windows_grad"].ref:add_color_picker("Windows Gradient 2"),
    -- main = color_t(255, 255, 255, 255),
    main = menu.find("Misc", "Main", "Personalization", "Accent Color"),
    white = color_t(255, 255, 255, 255),
    black = color_t(0, 0, 0, 255),
}

local dpi = ui_handler.refs["Misc"]["dpi"].ref:get()
fonts.refresh(dpi)

prim_ref.yaw_add = menu.find("antiaim", "main", "angles", "yaw add")
prim_ref.yaw_rotate = menu.find("antiaim", "main", "angles", "rotate")
prim_ref.yaw_rotate_range = menu.find("antiaim", "main", "angles", "rotate range")
prim_ref.yaw_rotate_speed = menu.find("antiaim", "main", "angles", "rotate speed")
prim_ref.jitter_mode = menu.find("antiaim", "main", "angles", "jitter mode")
prim_ref.jitter_type = menu.find("antiaim", "main", "angles", "jitter type")
prim_ref.jitter_add = menu.find("antiaim", "main", "angles", "jitter add")
prim_ref.body_lean = menu.find("antiaim", "main", "angles", "body lean")
prim_ref.body_lean_value = menu.find("antiaim", "main", "angles", "body lean value")
prim_ref.body_lean_jitter = menu.find("antiaim", "main", "angles", "body lean jitter")
prim_ref.body_lean_move_enable = menu.find("antiaim", "main", "angles", "moving body lean")
prim_ref.stand_desync_side = menu.find("antiaim", "main", "desync", "side")
prim_ref.slowwalk_desync_side = menu.find("antiaim", "main", "desync", "side#slow walk")
prim_ref.moving_desync_side = menu.find("antiaim", "main", "desync", "side#move")
prim_ref.stand_left_limit = menu.find("antiaim", "main", "desync", "Left Amount")
prim_ref.stand_right_limit = menu.find("antiaim", "main", "desync", "Right Amount")
prim_ref.slowwalk_left_limit = menu.find("antiaim", "main", "desync","left amount#slow walk")
prim_ref.slowwalk_right_limit = menu.find("antiaim", "main", "desync","right amount#slow walk")
prim_ref.moving_left_limit = menu.find("antiaim", "main", "desync", "left amount#move")
prim_ref.moving_right_limit = menu.find("antiaim", "main", "desync", "right amount#move")
prim_ref.dt_enabled = menu.find("aimbot", "general", "exploits", "doubletap","enable")[2]
prim_ref.hs_enabled = menu.find("aimbot", "general", "exploits", "hideshots","enable")[2]
prim_ref.fd_enabled = menu.find("antiaim", "main","general", "fakeduck")[2]
prim_ref.autopeek = menu.find("aimbot", "general", "misc", "autopeek")[2]
prim_ref.min_dmg = {}
prim_ref.min_dmg.auto = menu.find("aimbot", "auto", "target overrides","min. damage")
prim_ref.min_dmg.scout = menu.find("aimbot", "scout", "target overrides","min. damage")
prim_ref.min_dmg.awp = menu.find("aimbot", "awp", "target overrides","min. damage")
prim_ref.min_dmg.deagle = menu.find("aimbot", "deagle", "target overrides","min. damage")
prim_ref.min_dmg.revolver = menu.find("aimbot", "revolver", "target overrides","min. damage")
prim_ref.min_dmg.pistols = menu.find("aimbot", "pistols", "target overrides","min. damage")
prim_ref.min_dmg.other = menu.find("aimbot", "other", "target overrides","min. damage")

prim_ref.fakelag = menu.find("antiaim", "main", "fakelag","amount")
prim_ref.fakelag_lc = menu.find("antiaim", "main", "fakelag","break lag compensation")

local function to_address(cdata)
    if cdata == nil then return nil end

    local as_uintptr = ffi.cast("unsigned long", cdata)
    if (as_uintptr == nil) then return nil end

    return tonumber(as_uintptr)
end

local ffi_vec3_t = ffi.typeof([[
    struct{
        float x,y,z;
    }
]])

ffi.cdef [[
    typedef int(__thiscall* get_clipboard_text_count)(void*);
    typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
    typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

local launcher_sig = ffi.cast(ffi.typeof("void***"), memory.find_pattern("launcher.dll", "FF 15 ? ? ? ? 68 ? ? ? ? FF 74 24 14") or error("launcher sig not found!", 1))
local launch_site = ffi.cast("void*(__thiscall*)(int, const char*, const char*, int, int, int)", launcher_sig) or error("launch function is nil", 1)

local function site_launch(url)
    return launch_site(0, "open", url, 0, 0, 1)
end

local VGUI_System010 =  memory.create_interface("vgui2.dll", "VGUI_System010") or print("Error finding VGUI_System010")
local VGUI_System = ffi.cast(ffi.typeof('void***'), VGUI_System010 )
local get_clipboard_text_count = ffi.cast( "get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print("get_clipboard_text_count Invalid")
local set_clipboard_text = ffi.cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print("set_clipboard_text Invalid")
local get_clipboard_text = ffi.cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print("get_clipboard_text Invalid")

local function clipboard_import( )
    local clipboard_text_length = get_clipboard_text_count( VGUI_System )
    local clipboard_data = ""

    if clipboard_text_length > 0 then
        local buffer = ffi.new("char[?]", clipboard_text_length)
        local size = clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length)

        get_clipboard_text(VGUI_System, 0, buffer, size)

        clipboard_data = ffi.string( buffer, clipboard_text_length-1 )
    end
    return clipboard_data
end

local function clipboard_export(string)
    if string then
        set_clipboard_text(VGUI_System, string, string:len())
    end
end

local attachment_type_t = ffi.typeof("bool(__thiscall*)(void*,int,$&)",ffi_vec3_t)
local active_weapon_fn = ffi.typeof("void*(__thiscall*)(void*)")
local first_person_t = ffi.typeof("int(__thiscall*)(void*,void*)")
local third_person_t = ffi.typeof("int(__thiscall*)(void*)")
local class_ptr_t = ffi.typeof("void***")

local raw_filesys = memory.create_interface("filesystem_stdio.dll", "VBaseFileSystem011") or error("VBaseFileSystem011 inferface is nil")
local raw_filesys_full = memory.create_interface("filesystem_stdio.dll", "VFileSystem017") or error("VFileSystem017 inferface is nil")

local filesys_class = ffi.cast(ffi.typeof("void***"), raw_filesys) or error("filesystem class is nil")
local full_filesys_class = ffi.cast(ffi.typeof("void***"), raw_filesys_full) or error("full filesystem class is nil")

local raw_funcs = {
    file_size = ffi.cast(ffi.typeof("unsigned int(__thiscall*)(void*, void*)"), filesys_class[0][7]) or error("file size func is nil"),
    open_file = ffi.cast(ffi.typeof("void*(__thiscall*)(void*, const char*, const char*, const char*)"), filesys_class[0][2]) or error("open_file func is nil"),
    close_file = ffi.cast(ffi.typeof("void(__thiscall*)(void*, void*)"), filesys_class[0][3]) or error("close_file func is nil"),
    read_file = ffi.cast(ffi.typeof("int(__thiscall*)(void*, void*, int, void*)"), filesys_class[0][0]) or error("read_file func is nil"),
    write_file = ffi.cast(ffi.typeof("int(__thiscall*)(void*, void const*, int, void*)"), filesys_class[0][1]) or error("write_file func is nil"),
    file_exist = ffi.cast(ffi.typeof("bool(__thiscall*)(void*, const char*, const char*)"), filesys_class[0][10]) or error("file_exist func is nil"),
    make_directory = ffi.cast(ffi.typeof("void(__thiscall*)(void*, const char*, const char*)"), full_filesys_class[0][22]) or error("make_directory func is nil"),
    directory_exist = ffi.cast(ffi.typeof("bool(__thiscall*)(void*, const char*, const char*)"), full_filesys_class[0][23]) or error("directory_exist func is nil")
}


function ouija_fs.read(file)
    local handle = raw_funcs.open_file(filesys_class, file, "r", nil)

    if handle == -1 then 
        return print("filesystem handle error") 
    end

    local size = raw_funcs.file_size(filesys_class, handle)
    local output = ffi.new("char[?]", size + 1)

    raw_funcs.read_file(filesys_class, output, size, handle)
    raw_funcs.close_file(filesys_class, handle)
    
    return ffi.string(output)
end

function ouija_fs.write(file, buffer)
    local handle = raw_funcs.open_file(filesys_class, file, "w", nil)

    if handle == -1 then 
        return print("filesystem handle error") 
    end

    raw_funcs.write_file(filesys_class, buffer, #buffer, handle)
    raw_funcs.close_file(filesys_class, handle)
end

function ouija_fs.exists(file)
    return raw_funcs.file_exist(filesys_class, file, nil)
end

function ouija_fs.directory_exists(dir)
    return raw_funcs.directory_exist(full_filesys_class, dir, nil)
end

function ouija_fs.create_directory(dir)
    return raw_funcs.make_directory(full_filesys_class, dir, nil)
end

local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+/abcdefghijklmnopqrstuvwxyz'

configs.base64_encode = function(data)
    return ((data:gsub('.', function(x)
        local r, b = '', x:byte()
        for i = 8, 1, -1 do
            r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0')
        end
        return r;
    end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c = 0
        for i = 1, 6 do c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0) end
        return b:sub(c + 1, c + 1)
    end) .. ({'', '==', '='})[#data % 3 + 1])
end
configs.base64_decode = function(data)
    data = string.gsub(data, '[^' .. b .. '=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r, f = '', (b:find(x) - 1)
        for i = 6, 1, -1 do
            r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and '1' or '0')
        end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c = 0
        for i = 1, 8 do c = c + (x:sub(i, i) == '1' and 2 ^ (8 - i) or 0) end
        return string.char(c)
    end))
end

configs.color_list = {
    "undercrosshair",
    "doubletap",
    "hideshots",
    "fakeduck",
    "dmg",
    "g1",
    "g2",
    "g3",
    "hit_color",
    "miss_color",
    "aa_info_color",
    "hitmarker",
    "snaplines",
    "autopeek",
    "windows_grad1",
    "windows_grad2"
}

configs.make = function()
    local menu_items = {}
    for k, v in pairs(ui_handler.refs) do
        local temp_table_tab = {}
        for j, l in pairs(v) do
            local temp_table_element = {}
            if l.table then 
                local temp_table_table = {}
                for i=1, #l.ref:get_items() do
                    temp_table_table[i] = l.ref:get(i)
                    temp_table_element.value = temp_table_table
                end
            else
                temp_table_element.value = l.ref:get()
            end

            temp_table_tab[j] = temp_table_element
        end
       
        menu_items[k] = temp_table_tab
    end
    local temp_table_colors = {}

    for k, v in pairs(configs.color_list) do
        temp_table_colors[v] = {colors[v]:get().r,colors[v]:get().g,colors[v]:get().b,colors[v]:get().a}
    end

    menu_items["colors"] = temp_table_colors

    local config_output = json.encode(menu_items)
    config_output = configs.base64_encode(config_output)
    return(config_output)
end

configs.load = function(text)

    local decoded = configs.base64_decode(text)

    local imported = json.parse(decoded)

    if imported == nil then error("Fatal script error - [please reload lua and make sure you are using an updated config code]") return end

    for k, v in pairs(imported) do
        for j, l in pairs(v) do
            if k == "colors" then 
                colors[j]:set(color_t(l[1],l[2],l[3],l[4]))
            else
                if ui_handler.refs[k][j] then
                    if l.value ~= nil then
                        if type(l.value) == "table" then
                            for i=1, #l.value do
                                ui_handler.refs[k][j].ref:set(i, l.value[i])
                            end
                        else
                            ui_handler.refs[k][j].ref:set(l.value)
                        end
                    end
                end
            end
        end
    end
    
    client.log_screen(colors.white,"Ouija.lua", colors.main[2]:get(), "[Configs]", colors.white, "Config successfully loaded!")
end

local function lerp(a, b, t) return a + (b - a) * t end
local function lerp_color(a, b, t) return color_t(math.floor(lerp(a.r, b.r, t)), math.floor(lerp(a.g, b.g, t)), math.floor(lerp(a.b, b.b, t)), math.floor(lerp(a.a, b.a, t))) end

local function clamp(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
end

local function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function coordinate_transform(angle, distance)
    angle = angle * math.pi / 180
    local table_vars = {
        x_coord = distance * math.cos(angle),
        y_coord = distance * math.sin(angle)
    }
    return table_vars
end

local function get_velocity(player)
    if player == nil then
        return 0
    else
        local vel = {}
        vel[1] = player:get_prop("m_vecVelocity[0]")
        vel[2] = player:get_prop("m_vecVelocity[1]")
        if vel[2] == nil or vel[1] == nil then return end
        vel[3] = math.sqrt(vel[1] * vel[1] + vel[2] * vel[2])
        return math.floor(math.min(350, vel[3]))
    end
end

local function normalize_yaw(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end
    return yaw
end

local function calc_shit(xdelta, ydelta)
    if xdelta == 0 and ydelta == 0 then return 0 end
    return math.deg(math.atan2(ydelta, xdelta))
end

local function get_alive_enemies()
    local ret = {}
    local players = entity_list.get_players(true)
    if #players < 0 then return {} end

    for i, player in pairs(players) do
        if player:is_player() and player:is_valid() then
            if player:is_alive() and not player:is_dormant() then
                table.insert(ret, player)
            end
        end
    end
    return ret
end

-- 1 still
-- 2 slowwalk
-- 3 running
-- 4 crouching
-- 5 in air
-- 6 crouching in air
-- 7 warmup
-- 8 dormant


local aa_state = "-"

local condition = function(player)
    if player == nil then
        print("Condition error, no player found")
    else
        if ui_handler.refs["Anti Aim"]["warmup_enable"].ref:get() then
            if in_warmup then return 7 end
        end
        if ui_handler.refs["Anti Aim"]["dormant_enable"].ref:get() then
            if #get_alive_enemies() == 0 then aa_state = "dormant" return 8 end
        end
        local speed = math.floor(get_velocity(player))
        local duck_amount = player:get_prop("m_flDuckAmount")
        local playerflags = player:get_prop("m_fFlags")
        -- standing
        if (speed <= 2) and duck_amount ~= 1 and bit.band(playerflags, 1) ~= 0 then
            aa_state = "standing"
            return 1
        end
        -- slowwalking
        if speed <= 90 and speed > 2 and duck_amount ~= 1 and bit.band(playerflags, 1) ~= 0 then 
            aa_state = "slowwalk"
            return 2 
        end
        -- running
        if speed > 90 and bit.band(playerflags, 1) ~= 0 then 
            aa_state = "running"
            return 3 
        end
        -- ducking
        if duck_amount == 1 then
            if bit.band(playerflags, 1) ~= 0 then
                aa_state = "crouch"
                return 4
            else
                aa_state = "crouch in air"
                return 6
            end
        end
        -- In Air
        if bit.band(playerflags, 1) == 0 then 
            aa_state = "in air"
            return 5
        end
        return false
    end
end

local function get_closest_enemy()
    local best_dist = 180
    local best_enemy = nil
    local local_player = entity_list.get_local_player()
    if not local_player or local_player == nil then return end
    if not local_player:is_alive() then
    else
        local local_origin = local_player:get_render_origin()
        local local_screen_orig = render.world_to_screen(local_origin)
        local screen = render.get_screen_size()
        local eye = local_player:get_eye_position()
        local view_angles = engine.get_view_angles()
        local enemys = entity_list.get_players(true)

        for i = 1, #enemys do
            if not enemys[i]:is_player() then goto skip end
            if not enemys[i]:is_dormant() and enemys[i]:is_alive() then
                local origin = enemys[i]:get_render_origin()
                local screen_orig = render.world_to_screen(origin)
                local cur_fov = math.abs(normalize_yaw(calc_shit(eye.x - origin.x,eye.y - origin.y) -view_angles.y + 180))
                if (cur_fov < best_dist) then
                    best_dist = cur_fov
                    best_enemy = enemys[i]
                end
            end
            ::skip::
        end
    end

    return best_enemy
end

local function math_closest_point_on_ray(ray_from, ray_to, desired_point)
    local to = desired_point - ray_from
    local direction = ray_to - ray_from
    local ray_length = math.sqrt(direction.x^2 + direction.y^2 + direction.z^2)

    direction.x = direction.x / ray_length
    direction.y = direction.y / ray_length
    direction.z = direction.z / ray_length

    local direction_along = direction.x * to.x + direction.y * to.y + direction.z * to.z
    if direction_along < 0 then return ray_from end
    if direction_along > ray_length then return ray_to end

    return vec3_t(ray_from.x + direction.x * direction_along, ray_from.y + direction.y * direction_along, ray_from.z + direction.z * direction_along)
end

local sv_gravity = cvars.sv_gravity
local function copy_vec(v) return vec3_t(v.x, v.y, v.z) end
local function extrapolate(ent, flags, ticks)
    local gravity = bit.band(flags, 1) == 0 and -sv_gravity:get_float() or 0
    local velocity = ent:get_prop("m_vecVelocity")
    local origin = ent:get_hitbox_pos(e_hitboxes.NECK)
    local extrapolated = origin +vec3_t( velocity.x * ticks * global_vars.interval_per_tick(),
    velocity.y * ticks * global_vars.interval_per_tick(),
    velocity.z * ticks * global_vars.interval_per_tick() +(gravity * (ticks *global_vars.interval_per_tick() *ticks *global_vars.interval_per_tick())) /2)
    return copy_vec(extrapolated)
end
local data1 = false
local data2 = false
local data3 = false
local function canseeentity(localplayer, entity)
    if not entity or not localplayer then return false end
    local canhit = false
    local data_active

    local eye = localplayer:get_eye_position()
    local flags = entity:get_prop("m_fFlags")
    local localflags = localplayer:get_prop("m_fFlags")

    local extrapolated = extrapolate(entity, flags, 25)
    local local_extrapolated = extrapolate(localplayer, localflags, 17)

    if extrapolated == nil or local_extrapolated == nil then
        print("extrapolate error")
        return
    end
    if data2 == false and data3 == false then
        data1 = localplayer:is_point_visible(vec3_t(extrapolated.x, extrapolated.y,entity:get_hitbox_pos(e_hitboxes.CHEST).z))
        data_active = "passive"
    end
    if data1 == false then
        data2 = entity:is_point_visible(vec3_t(local_extrapolated.x,local_extrapolated.y,localplayer:get_hitbox_pos(e_hitboxes.CHEST).z))
        data_active = "active 2"
    end
    if data1 == false and data2 == false then
        data3 = entity:is_point_visible(vec3_t(local_extrapolated.x +coordinate_transform(antiaim.get_real_angle() +180, 35).x_coord,
        local_extrapolated.y +coordinate_transform(antiaim.get_real_angle() +180, 35).y_coord,
        localplayer:get_hitbox_pos(e_hitboxes.CHEST).z))
        data_active = "active 1"
    end
    if data1 == true or data2 == true or data3 == true then canhit = true end
    local return_table = {bool = canhit, text = data_active}
    return return_table
end

function render.rect_half_round(start_pos, end_pos, color, width, round)
    render.rect(vec2_t.new(start_pos.x + round, start_pos.y), vec2_t.new(end_pos.x - round * 2, end_pos.y - end_pos.y + width), color)
    render.rect_fade(vec2_t.new(start_pos.x, start_pos.y + round), vec2_t.new(start_pos.x - start_pos.x + width, end_pos.y - round * 2), color_t.new(color.r, color.g, color.b, color.a), color_t.new(color.r, color.g, color.b, math.floor(color.a / 5)), false)
    render.rect_fade(vec2_t.new(start_pos.x + end_pos.x - width, start_pos.y + round), vec2_t.new(end_pos.x - end_pos.x + width, end_pos.y - round * 2), color_t.new(color.r, color.g, color.b, color.a), color_t.new(color.r, color.g, color.b, math.floor(color.a / 5)), false)
    if round ~= 0 and width ~= 0 then
        render.push_clip(vec2_t.new(start_pos.x + end_pos.x - round, start_pos.y + round - round), vec2_t.new(round, round))
        render.progress_circle(vec2_t.new(start_pos.x + end_pos.x - round, start_pos.y + round - 1), round - width, color, width, 1)
        render.pop_clip()
        render.push_clip(vec2_t.new(start_pos.x + round - round, start_pos.y + round - round), vec2_t.new(round, round))
        render.progress_circle(vec2_t.new(start_pos.x + round - 1, start_pos.y + round - 1), round - width, color, width, 1)
        render.pop_clip()
    end
end


local clantag_freeze = false
local anti_brute_logs = {}
local total_brute = 0
local notification_logs = {}
local gothit = false

local function add_notification(type, data)
    local types = type == "ab" and "Anti Brute | " or type == "hit" and "Ragebot Hit | " or type == "miss" and "Ragebot Miss | " or "" and "| "

    notification_logs[#notification_logs + 1] = {
        "[", "Ouija.Lua", "] ", types, data, global_vars.tick_count() + 300
    }
end

anti_brute.reset_ab_logs = function()
    total_brute = 0
    if #anti_brute_logs > 0 then 
        for i = 1, #anti_brute_logs do 
            table.remove(anti_brute_logs, 1)
        end
    end
end

anti_brute.visuals = {}
anti_brute.visuals.debug = {}
anti_brute.visuals.debug.view_angles = 0
anti_brute.visuals.debug.ang_to_point = 0

local brute_able = false
local g_cont_time = 0

anti_brute.anti_bruteforce_impact = function(impact, enemy_pos, lp_pos, e_uid, cont_time)
    local close_point = math_closest_point_on_ray(impact,enemy_pos,lp_pos)
    local distance = ((lp_pos.x - close_point.x) ^ 2 + (lp_pos.y - close_point.y) ^ 2 + (lp_pos.z - close_point.z) ^ 2) ^ 0.5
    if distance > 55 then return end
    if ui_handler.refs["Visuals"]["brute_vis"].ref:get() then
        anti_brute.visuals.point_p = lp_pos
        anti_brute.visuals.point = close_point
        anti_brute.visuals.point_time = global_vars.tick_count() + 255
    end
    brute_able = true
    anti_brute.brute_add(e_uid)
    g_cont_time = cont_time + 1
end

local events_fun = function(event)
    local localplayer = entity_list.get_local_player()

    if event.name == "round_start" then
        clantag_freeze = false
        if total_brute> 0 then 
            if ui_handler.refs["Visuals"]["notifications_screen"].ref:get(3) then 
                add_notification("ab", "Reset due to new round")
            end
            if ui_handler.refs["Visuals"]["notifications_console"].ref:get(3) then 
                client.log("[", colors.aa_info_color:get(), "Ouija.lua",
                                colors.white, "] Anti Aim Reset",
                                colors.aa_info_color:get(), "|",
                                colors.white, "new round")
            end
            anti_brute.reset_ab_logs()
        end
    end

    if event.name == "player_death" then
        local attacker = entity_list.get_player_from_userid(event.attacker)
        local victim = entity_list.get_player_from_userid(event.userid)
        if engine.get_player_index_from_user_id(event.userid) == engine.get_local_player_index() then
            brute_able = false
            gothit = true
            if total_brute> 0 then 
                anti_brute.reset_ab_logs()
                if ui_handler.refs["Visuals"]["notifications"].ref:get() then
                    if ui_handler.refs["Visuals"]["notifications_screen"].ref:get(3) then 
                        add_notification("ab", "Reset due to local player death")
                    end
                    if ui_handler.refs["Visuals"]["notifications_console"].ref:get(3) then 
                        client.log("[", colors.aa_info_color:get(), "Ouija.lua",
                                        colors.white, "] Anti Aim Reset",
                                        colors.aa_info_color:get(), "|",
                                        colors.white, "player death")
                    end
                end
            end
            if ui_handler.refs["Misc"]["deathsay"].ref:get() then
                engine.execute_cmd("say " .. "Femboys make me so hard" )
            end
        end
        if ui_handler.refs["Misc"]["killsay"].ref:get() and attacker == localplayer and not victim == nil then
            local kill_says = {
                "1'ed by Ouija.LUA",
                "nn " .. tostring(victim:get_name()) .. " deleted by ouija.lua",
                "You wouldnt have died with ouija.lua",
                "Thanks for increasing my kd", "Ouija.lua - just the best",
                "Get good get Ouija.lua",
                "Another kill for me, and another death for " ..
                    tostring(victim:get_name()), "I let ouija.lua carry me"
            }
            if localplayer:is_alive() then
                engine.execute_cmd("say " ..kill_says[client.random_int(1, #kill_says)])
            end
        end
         -- if engine.get_player_index_from_user_id(event.userid) ==
         --     engine.get_local_player_index() then
         --     if lua_menu.visuals.logs_options:get(3) then
         --         if lua_menu.visuals.logs_in:get(1) then
         --             if anti_brute_total > 0 then
         --                 notification_logs[#notification_logs + 1] = {
         --                     "[", "Ouija.lua",
         --                     "] " .. "Anti Aim Reset | player death",
         --                     global_vars.tick_count() + 275, 100, 100
         --                 }
         --             end
         --         end
         --         if lua_menu.visuals.logs_in:get(2) then
         --             if anti_brute_total > 0 then
         --                 client.log("[", accent_color_color:get(), "Ouija.lua",
         --                            colors.console_gray, "] Anti Aim Reset",
         --                            accent_color_color:get(), " | ",
         --                            colors.console_gray, "player death")
         --             end
         --         end
         --     end
         -- end

        local ab_target_death = false

        if #anti_brute_logs > 0 then 
            for i = 1, #anti_brute_logs do 
                if anti_brute_logs[i][2] == event.userid then
                    ab_target_death = true
                end
            end
            if ab_target_death then 
                anti_brute.reset_ab_logs()
                if ui_handler.refs["Visuals"]["notifications"].ref:get() then
                    if ui_handler.refs["Visuals"]["notifications_screen"].ref:get(3) then
                        add_notification("ab", "Reset due to target death")
                    end
                    if ui_handler.refs["Visuals"]["notifications_console"].ref:get(3) then
                        client.log("[", colors.aa_info_color:get(), "Ouija.lua",
                        colors.white, "] Anti Aim Reset",
                        colors.aa_info_color:get(), "|",
                        colors.white, "target death")
                    end
                end
            end
        end
    end
    if event.name == "bullet_impact" then
        local e_uid = event.userid
        if e_uid == nil then return end
        if not localplayer or localplayer == nil then return end
        if localplayer:is_alive() == false then return end

        if #anti_brute_logs > 0 then
            for i = 1, #anti_brute_logs do 
                if anti_brute_logs[i][1] - 160 == global_vars.tick_count() then return end
            end
        end
        
        if engine.get_player_index_from_user_id(event.userid) == engine.get_local_player_index() then return end
        if not entity_list.get_player_from_userid(event.userid):is_enemy() then return end
        if e_uid == -1 then return end

        local x = event.x
        local y = event.y
        local z = event.z

        local impact_vec = vec3_t.new(x, y, z) 
        local enemy_eye_pos = entity_list.get_player_from_userid(event.userid):get_eye_position()
        local local_flags = localplayer:get_prop("m_fFlags")
        local cont_time = global_vars.tick_count() + 10
        gothit = false

        anti_brute.anti_bruteforce_impact(impact_vec, enemy_eye_pos, extrapolate(localplayer, local_flags, -3), e_uid, cont_time)
    end

    if event.name == "cs_win_panel_match" then clantag_freeze = true end
end

local hitboxes = {
    "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg",
    "right leg", "neck"
}

callbacks.add(e_callbacks.AIMBOT_HIT, function(shot)
if not ui_handler.refs["Visuals"]["notifications"].ref:get() then return end
    local entity = shot.player
    local Name = entity:get_name()
    if shot.aim_damage > shot.damage then
        if ui_handler.refs["Visuals"]["notifications_screen"].ref:get(1) then
            add_notification("hit", "Hit " .. tostring(shot.player:get_name()) .. " in the " .. tostring(hitboxes[shot.hitgroup + 1]) .. " for -" .. 
            tostring(shot.damage) .. " damage [targeted for -" .. tostring(shot.aim_damage) .. "]") 
        end
        if ui_handler.refs["Visuals"]["notifications_console"].ref:get(1) then
            client.log(colors.white, "[", colors.hit_color:get(), "Ouija.lua", colors.white, "]",
            colors.white, "Hit",
            colors.hit_color:get(), tostring(shot.player:get_name()), 
            colors.white, "in the",
            colors.hit_color:get(), tostring(hitboxes[shot.hitgroup + 1]),
            colors.white, "for -",
            colors.hit_color:get(), tostring(shot.damage), 
            colors.white, "damage",
            colors.white, "[targeted:",
            colors.hit_color:get(), tostring(hitboxes[shot.aim_hitgroup + 1]),
            colors.white, "for -",
            colors.hit_color:get(), tostring(shot.aim_damage),
            colors.white, "][bt:",
            colors.hit_color:get(), tostring(shot.backtrack_ticks),
            colors.white, "| sp:",
            colors.hit_color:get(), tostring(shot.safepoint),
            colors.white, "]")
        end 
    else
        if ui_handler.refs["Visuals"]["notifications_screen"].ref:get(1) then
            add_notification("hit", "Hit " .. tostring(shot.player:get_name()) .. " in the " .. tostring(hitboxes[shot.hitgroup + 1]) .. " for -" .. 
            tostring(shot.damage) .. " damage")
        end
        if ui_handler.refs["Visuals"]["notifications_console"].ref:get(1) then
            client.log(colors.white, "[", colors.hit_color:get(), "Ouija.lua", colors.white, "]",
            colors.white, "Hit",
            colors.hit_color:get(), tostring(shot.player:get_name()), 
            colors.white, "in the",
            colors.hit_color:get(), tostring(hitboxes[shot.hitgroup + 1]),
            colors.white, "for -",
            colors.hit_color:get(), tostring(shot.damage), 
            colors.white, "damage",
            colors.white, "][bt:",
            colors.hit_color:get(), tostring(shot.backtrack_ticks),
            colors.white, "| sp:",
            colors.hit_color:get(), tostring(shot.safepoint),
            colors.white, "]")
        end 
    end
end)

callbacks.add(e_callbacks.AIMBOT_MISS, function(shot)
if not ui_handler.refs["Visuals"]["notifications"].ref:get() then return end
    local entity = shot.player
    local Name = entity:get_name()
    -- if lua_menu.visuals.logs_in:get(1) then
    --     notification_logs[#notification_logs + 1] = {"[", "Ouija.lua","] " .. "Missed " .. 
    --     tostring(Name) .. "s " .. tostring(hitboxes[shot.aim_hitgroup + 1]) .. " due to " ..
    --     tostring(shot.reason_string) .. " [backtrack: " ..
    --     tostring(shot.backtrack_ticks) .. "]",
    --     global_vars.tick_count() + 275, 100, 100
    --     }
    -- end
    if ui_handler.refs["Visuals"]["notifications_screen"].ref:get(2) then
        add_notification("miss", "Missed shot due to " .. tostring(shot.reason_string) .. ", targeted " .. tostring(hitboxes[shot.aim_hitgroup + 1]) .. " for -" .. 
        tostring(shot.aim_damage) .. " damage")
    end
    if ui_handler.refs["Visuals"]["notifications_console"].ref:get(2) then
        local safe_text = shot.safepoint and "Yes" or "No"
        client.log(colors.white, "[", colors.miss_color:get(), "Ouija.lua", colors.white, "]",
        colors.white, "Missed " .. tostring(Name).. "'s",
        colors.miss_color:get(), tostring(hitboxes[shot.aim_hitgroup + 1]),
        colors.white, "due to",
        colors.miss_color:get(), tostring(shot.reason_string),
        colors.white, "[bt:", colors.miss_color:get(), tostring(shot.backtrack_ticks), 
        colors.white, "]")
    end
end)

local ffi_set_clantag = ffi.cast("int(__fastcall*)(const char*, const char*)",memory.find_pattern("engine.dll","53 56 57 8B DA 8B F9 FF 15"))
local function set_clantag(tag) ffi_set_clantag(tag, tag) end

local tag_s = alpha_v and {
    "o", 
    "ou", 
    "oui", 
    "ouij", 
    "ouija", 
    "ouija⛦", 
    "ouija⛦[", 
    "ouija⛦[]", 
    "ouija⛦[A]", 
    "ouija⛦[AL]", 
    "ouija⛦[ALP]", 
    "ouija⛦[ALPH]", 
    "ouija⛦[ALPHA]", 
    "ouija⛦[ALPHA]", 
    "ouija⛦[ALPHA]", 
    "ouija⛦[ALPH]",     
    "ouija⛦[ALP]", 
    "ouija⛦[AL]", 
    "ouija⛦[A]", 
    "ouija⛦[]", 
    "ouija⛦[", 
    "ouija⛦", 
    "ouija", 
    "ouij", 
    "oui", 
    "ou", 
    "o", 
    "", 
    "o", 
    "ou", 
    "oui", 
    "ouij", 
    "ouija", 
    "ouija⛦", 
    "ouija⛦[", 
    "ouija⛦[]", 
    "ouija⛦[P]", 
    "ouija⛦[Pr]", 
    "ouija⛦[Pri]", 
    "ouija⛦[Prim]", 
    "ouija⛦[Prim]",
    "ouija⛦[Pri]",
    "ouija⛦[Pr]",
    "ouija⛦[P]",
    "ouija⛦[]", 
    "ouija⛦[", 
    "ouija⛦", 
    "ouija", 
    "ouij", 
    "oui", 
    "ou", 
    "o", 
    "", 
} or {
    "o", 
    "ou", 
    "oui", 
    "ouij", 
    "ouija", 
    "ouija⛦", 
    "ouija⛦L", 
    "ouija⛦L", 
    "ouija⛦Lu", 
    "ouija⛦Lu", 
    "ouija⛦Lua", 
    "ouija⛦Lua", 
    "ouija⛦Lua", 
    "ouija⛦Lua", 
    "ouija⛦Lua", 
    "ouija⛦Lua",     
    "ouija⛦Lua", 
    "ouija⛦Lu", 
    "ouija⛦Lu", 
    "ouija⛦L", 
    "ouija⛦L", 
    "ouija⛦", 
    "ouija", 
    "ouij", 
    "oui", 
    "ou", 
    "o", 
    "", 
    "o", 
    "ou", 
    "oui", 
    "ouij", 
    "ouija", 
    "ouija⛦", 
    "ouija⛦[", 
    "ouija⛦[]", 
    "ouija⛦[P]", 
    "ouija⛦[Pr]", 
    "ouija⛦[Pri]", 
    "ouija⛦[Prim]", 
    "ouija⛦[Prim]",
    "ouija⛦[Pri]",
    "ouija⛦[Pr]",
    "ouija⛦[P]",
    "ouija⛦[]", 
    "ouija⛦[", 
    "ouija⛦", 
    "ouija", 
    "ouij", 
    "oui", 
    "ou", 
    "o", 
    "", 
}

-- local tag_s = {
--     "o", "ou", "oui", "ouij", "ouija", "ouija⛦", "ouija⛦l", "ouija⛦lu",
--     "ouija⛦lua", "ouija⛦lua", "ouija⛦lua", "ouija⛦lua", "ouija⛦lu",
--     "ouija⛦l", "ouija⛦", "ouija", "ouij", "oui", "ou", "o", "", ""
-- }
local last_tag_iter
local clantag_active = false
local clantag_fuc = function()
    local latency = engine.get_latency() / global_vars.interval_per_tick()
    local tickcount_pred = math.floor(global_vars.cur_time()* 12) + latency
    local iter = math.floor(math.fmod(tickcount_pred / 4, #tag_s))
    if iter ~= last_tag_iter then
        if clantag_freeze == true then
            set_clantag(tag_s[14], tag_s[14])
        else
            set_clantag(tag_s[iter], tag_s[iter])
        end
        last_tag_iter = iter
    end
end

-- 1 still
-- 2 slowwalk
-- 3 running
-- 4 crouching
-- 5 in air
-- 6 crouching in air
-- 7 warmup
-- 8 dormant

local def_jitter_values = {
    {6,false,0,0,2,2,-22,1,0,0,false,4,98,98},
    {-12,true,31,92,2,1,30,1,0,0,false,6,98,98},
    {6,false,0,0,2,2,-13,1,0,0,false,4,98,98},
    {10,false,0,0,2,2,26,1,0,0,false,4,98,98},
    {-17,true,31,92,2,1,38,1,0,0,false,4,98,98},
    {0,false,0,0,2,2,-23,1,0,0,false,4,60,60},
    {0,false,0,0,1,1,0,1,0,0,false,4,100,100},
    {0,false,0,0,1,1,0,1,0,0,false,4,100,100}    
}

local def_static_values = {
    {-16,8,false,0,0,3,1,3,1,0,0,false,5,98,98},
    {-20,20,false,0,0,1,1,3,1,0,0,false,5,98,98},
    {10,-10,false,0,0,2,1,3,1,0,0,false,2,98,98},
    {-20,20,false,0,0,2,1,-6,1,0,0,false,6,98,98},
    {-10,10,true,15,15,2,1,3,1,0,0,false,2,98,98},
    {-10,10,true,15,15,2,1,3,1,0,0,false,2,40,40},
    {-16,8,false,0,0,3,1,3,1,0,0,false,5,98,98},
    {-16,8,false,0,0,3,1,3,1,0,0,false,5,98,98}  
}

local def_roll_values = {
    {"this gets set in condition"},
    {"this gets set in condition"},
    {10,false,0,0,2,2,0,1,0,0,false,5,100,100},
    {0,false,0,0,2,2,-4,2,40,0,true,6,90,90},
    {0,false,0,0,2,2,10,2,0,0,true,6,90,90},
    {0,false,0,0,2,2,-4,2,40,0,true,6,90,90},
    {0,false,0,0,2,2,-4,2,40,0,true,6,90,90},
    {0,false,0,0,2,2,-4,2,0,0,false,6,90,90}
}

local anti_aim_fun = function(ctx, localplayer)
    local lp_condition = condition(localplayer)
    local desync_side = antiaim.get_desync_side()
    if ui_handler.refs["Anti Aim"]["enable_aa"].ref:get() then
        local function set_jitter()
            menu.find("antiaim", "main", "desync", "override stand#move"):set(true)
            menu.find("antiaim", "main", "desync", "override stand#slow walk"):set(true)
            prim_ref.yaw_add:set(def_jitter_values[lp_condition][1])
            prim_ref.yaw_rotate:set(def_jitter_values[lp_condition][2])
            prim_ref.yaw_rotate_range:set(def_jitter_values[lp_condition][3])
            prim_ref.yaw_rotate_speed:set(def_jitter_values[lp_condition][4])
            prim_ref.jitter_mode:set(def_jitter_values[lp_condition][5])
            prim_ref.jitter_type:set(def_jitter_values[lp_condition][6])
            prim_ref.jitter_add:set(def_jitter_values[lp_condition][7])
            prim_ref.body_lean:set(def_jitter_values[lp_condition][8])
            prim_ref.body_lean_value:set(def_jitter_values[lp_condition][9])
            prim_ref.body_lean_jitter:set(def_jitter_values[lp_condition][10])
            prim_ref.body_lean_move_enable:set(def_jitter_values[lp_condition][11])
            if lp_condition == 1 then
                prim_ref.stand_desync_side:set(def_jitter_values[lp_condition][12])
                prim_ref.stand_left_limit:set(def_jitter_values[lp_condition][13])
                prim_ref.stand_right_limit:set(def_jitter_values[lp_condition][14])
            elseif lp_condition == 2 then
                prim_ref.slowwalk_desync_side:set(def_jitter_values[lp_condition][12])
                prim_ref.slowwalk_left_limit:set(def_jitter_values[lp_condition][13])
                prim_ref.slowwalk_right_limit:set(def_jitter_values[lp_condition][14])
            elseif lp_condition == 4 then
                prim_ref.moving_desync_side:set(def_jitter_values[lp_condition][12])
                prim_ref.moving_left_limit:set(def_jitter_values[lp_condition][13])
                prim_ref.moving_right_limit:set(def_jitter_values[lp_condition][14])
                prim_ref.stand_desync_side:set(def_jitter_values[lp_condition][12])
                prim_ref.stand_left_limit:set(def_jitter_values[lp_condition][13])
                prim_ref.stand_right_limit:set(def_jitter_values[lp_condition][14])
            else
                prim_ref.moving_desync_side:set(def_jitter_values[lp_condition][12])
                prim_ref.moving_left_limit:set(def_jitter_values[lp_condition][13])
                prim_ref.moving_right_limit:set(def_jitter_values[lp_condition][14])
            end
        end
    
        local function set_static()
            def_static_values[3][13] = math.floor(clamp(((global_vars.tick_count() % 64)/12),2,3))
            menu.find("antiaim", "main", "desync", "override stand#move"):set(true)
            menu.find("antiaim", "main", "desync", "override stand#slow walk"):set(true)
            if desync_side == 1 then
                prim_ref.yaw_add:set(def_static_values[lp_condition][1])
            else
                prim_ref.yaw_add:set(def_static_values[lp_condition][2])
            end
            prim_ref.yaw_rotate:set(def_static_values[lp_condition][3])
            prim_ref.yaw_rotate_range:set(def_static_values[lp_condition][4])
            prim_ref.yaw_rotate_speed:set(def_static_values[lp_condition][5])
            prim_ref.jitter_mode:set(def_static_values[lp_condition][6])
            prim_ref.jitter_type:set(def_static_values[lp_condition][7])
            prim_ref.jitter_add:set(def_static_values[lp_condition][8])
            prim_ref.body_lean:set(def_static_values[lp_condition][9])
            prim_ref.body_lean_value:set(def_static_values[lp_condition][10])
            prim_ref.body_lean_jitter:set(def_static_values[lp_condition][11])
            prim_ref.body_lean_move_enable:set(def_static_values[lp_condition][12])
            if lp_condition == 1 then
                prim_ref.stand_desync_side:set(def_static_values[lp_condition][13])
                prim_ref.stand_left_limit:set(def_static_values[lp_condition][14])
                prim_ref.stand_right_limit:set(def_static_values[lp_condition][15])
            elseif lp_condition == 2 then
                prim_ref.slowwalk_desync_side:set(def_static_values[lp_condition][13])
                prim_ref.slowwalk_left_limit:set(def_static_values[lp_condition][14])
                prim_ref.slowwalk_right_limit:set(def_static_values[lp_condition][15])
            elseif lp_condition == 4 then
                prim_ref.moving_desync_side:set(def_jitter_values[lp_condition][12])
                prim_ref.moving_left_limit:set(def_jitter_values[lp_condition][13])
                prim_ref.moving_right_limit:set(def_jitter_values[lp_condition][14])
                prim_ref.stand_desync_side:set(def_jitter_values[lp_condition][12])
                prim_ref.stand_left_limit:set(def_jitter_values[lp_condition][13])
                prim_ref.stand_right_limit:set(def_jitter_values[lp_condition][14])
            else
                prim_ref.moving_desync_side:set(def_jitter_values[lp_condition][12])
                prim_ref.moving_left_limit:set(def_jitter_values[lp_condition][13])
                prim_ref.moving_right_limit:set(def_jitter_values[lp_condition][14])
            end
        end
    
        local function set_roll()
            prim_ref.body_lean:set(2)
            menu.find("antiaim", "main", "desync", "override stand#move"):set(true)
            menu.find("antiaim", "main", "desync", "override stand#slow walk"):set(true)
            if condition(localplayer) == 1 or condition(localplayer) == 2 then -- standing or slow walking
                prim_ref.jitter_mode:set(1)
                prim_ref.stand_desync_side:set(5)
                prim_ref.yaw_rotate:set(false)
                prim_ref.stand_left_limit:set(80)
                prim_ref.stand_right_limit:set(75)
                prim_ref.slowwalk_left_limit:set(50)
                prim_ref.slowwalk_right_limit:set(50)
                if desync_side == 1 then
                    prim_ref.body_lean_value:set(-50)
                    prim_ref.yaw_add:set(-47)
                else
                    prim_ref.body_lean_value:set(50)
                    prim_ref.yaw_add:set(45)
                end
            else
                prim_ref.yaw_add:set(def_roll_values[lp_condition][1])
                prim_ref.yaw_rotate:set(def_roll_values[lp_condition][2])
                prim_ref.yaw_rotate_range:set(def_roll_values[lp_condition][3])
                prim_ref.yaw_rotate_speed:set(def_roll_values[lp_condition][4])
                prim_ref.jitter_mode:set(def_roll_values[lp_condition][5])
                prim_ref.jitter_type:set(def_roll_values[lp_condition][6])
                prim_ref.jitter_add:set(def_roll_values[lp_condition][7])
                prim_ref.body_lean:set(def_roll_values[lp_condition][8])
                prim_ref.body_lean_value:set(def_roll_values[lp_condition][9])
                prim_ref.body_lean_jitter:set(def_roll_values[lp_condition][10])
                prim_ref.body_lean_move_enable:set(def_roll_values[lp_condition][11])
                if lp_condition == 1 then
                    prim_ref.stand_desync_side:set(def_roll_values[lp_condition][12])
                    prim_ref.stand_left_limit:set(def_roll_values[lp_condition][13])
                    prim_ref.stand_right_limit:set(def_roll_values[lp_condition][14])
                elseif lp_condition == 2 then
                    prim_ref.slowwalk_desync_side:set(def_roll_values[lp_condition][12])
                    prim_ref.slowwalk_left_limit:set(def_roll_values[lp_condition][13])
                    prim_ref.slowwalk_right_limit:set(def_roll_values[lp_condition][14])
                elseif lp_condition == 4 then
                    prim_ref.moving_desync_side:set(def_jitter_values[lp_condition][12])
                    prim_ref.moving_left_limit:set(def_jitter_values[lp_condition][13])
                    prim_ref.moving_right_limit:set(def_jitter_values[lp_condition][14])
                    prim_ref.stand_desync_side:set(def_jitter_values[lp_condition][12])
                    prim_ref.stand_left_limit:set(def_jitter_values[lp_condition][13])
                    prim_ref.stand_right_limit:set(def_jitter_values[lp_condition][14])
                else
                    prim_ref.moving_desync_side:set(def_jitter_values[lp_condition][12])
                    prim_ref.moving_left_limit:set(def_jitter_values[lp_condition][13])
                    prim_ref.moving_right_limit:set(def_jitter_values[lp_condition][14])
                end
            end
        end

        local main_aa_mode = ui_handler.refs["Anti Aim"]["Anti Aim mode"].ref:get()
        if main_aa_mode == 1 then
            set_jitter()
        elseif main_aa_mode == 2 then
            set_static()
        elseif main_aa_mode == 3 then
            set_roll()
        elseif main_aa_mode == 4 then
            if ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "aa_mode"].ref:get() == 1 then
                set_jitter()
            elseif ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "aa_mode"].ref:get() == 2 then
                set_static()
            elseif ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "aa_mode"].ref:get() == 3 then
                set_roll()
            else
                local function side_condition()
                    if ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "jitter_condition"].ref:get(1) then
                        return 4
                    elseif ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "jitter_condition"].ref:get(3) and #anti_brute_logs > 0 then
                        return 4
                    elseif ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "jitter_condition"].ref:get(4) and #get_alive_enemies() == 0 then
                        return 4
                    elseif ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "jitter_condition"].ref:get(2) then
                        return math.floor((global_vars.tick_count() % 4)/2)+5
                    elseif ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "desync_side"].ref:get() < 3 then
                        return ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "desync_side"].ref:get() + 1
                    else
                        return ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "desync_side"].ref:get() + 2
                    end
                end
                local function roll_condition()
                    if ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "lean_condition"].ref:get(1) then
                        return true
                    elseif ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "lean_condition"].ref:get(2) and localplayer:get_prop("m_iHealth") < 93 then
                        return true
                    else
                        return false
                    end
                end
                local roll_enable = roll_condition()
                local dsy_limits = ((global_vars.tick_count() % 12) > 6) and ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "max_limit"].ref:get() or ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "min_limit"].ref:get()
                local dsy_side = side_condition()
                menu.find("antiaim", "main", "desync", "override stand#move"):set(true)
                menu.find("antiaim", "main", "desync", "override stand#slow walk"):set(true)
                if ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "yaw_add_mode"].ref:get() == 1 then
                    if desync_side == 1 then
                        prim_ref.yaw_add:set(ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "yaw_add_L"].ref:get())
                    else 
                        prim_ref.yaw_add:set(ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "yaw_add_R"].ref:get())
                    end
                else
                    if desync_side == 1 then
                        prim_ref.yaw_add:set(ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "yaw_jitter_L"].ref:get()*(round((2/(math.abs(90)^(90*math.sin(0.5*global_vars.tick_count()))+1))-1)))
                    else 
                        prim_ref.yaw_add:set(ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "yaw_jitter_R"].ref:get()*(round((2/(math.abs(90)^(90*math.sin(0.5*global_vars.tick_count()))+1))-1)))
                    end
                end
                prim_ref.yaw_rotate:set(ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "yaw_rotate"].ref:get())
                prim_ref.yaw_rotate_range:set(ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "yaw_rotate_range"].ref:get())
                prim_ref.yaw_rotate_speed:set(ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "yaw_rotate_speed"].ref:get())
                prim_ref.jitter_mode:set(ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "yawjitter_mode"].ref:get())
                prim_ref.jitter_type:set(ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "yawjitter_type"].ref:get())
                prim_ref.jitter_add:set(ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "yawjitter_range"].ref:get())
                if roll_enable then
                    prim_ref.body_lean:set(ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "body_lean_type"].ref:get()+1)
                else
                    prim_ref.body_lean:set(0)
                end
                if desync_side == 1 then
                    prim_ref.body_lean_value:set(ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "body_lean_range_L"].ref:get())
                    prim_ref.body_lean_jitter:set(ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "body_lean_range_L"].ref:get())
                else
                    prim_ref.body_lean_value:set(ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "body_lean_range_R"].ref:get())
                    prim_ref.body_lean_jitter:set(ui_handler.refs["Anti Aim"][aa_conditions[lp_condition] .. "body_lean_range_R"].ref:get())
                end
                if lp_condition == 4 then
                    prim_ref.body_lean_move_enable:set(ui_handler.refs["Anti Aim"]["crouching_moving_body_lean"].ref:get())
                else
                    prim_ref.body_lean_move_enable:set(lp_condition == 2 or lp_condition == 3 or lp_condition == 5 or lp_condition == 6) 
                end
                if lp_condition == 1 then
                    prim_ref.stand_desync_side:set(dsy_side)
                    prim_ref.stand_left_limit:set(dsy_limits)
                    prim_ref.stand_right_limit:set(dsy_limits)
                elseif lp_condition == 2 then
                    prim_ref.slowwalk_desync_side:set(dsy_side)
                    prim_ref.slowwalk_left_limit:set(dsy_limits)
                    prim_ref.slowwalk_right_limit:set(dsy_limits)
                elseif lp_condition == 4 then
                    prim_ref.moving_desync_side:set(dsy_side)
                    prim_ref.moving_left_limit:set(dsy_limits)
                    prim_ref.moving_right_limit:set(dsy_limits)
                    prim_ref.stand_desync_side:set(dsy_side)
                    prim_ref.stand_left_limit:set(dsy_limits)
                    prim_ref.stand_right_limit:set(dsy_limits)
                else
                    prim_ref.moving_desync_side:set(dsy_side)
                    prim_ref.moving_left_limit:set(dsy_limits)
                    prim_ref.moving_right_limit:set(dsy_limits)
                end
            end
        end
    end
end

local anti_knife_active = false

local anti_knife = function(cmd, local_player)
    local function GetEnemiesWithKnife()
        local ret = {}
        local players = entity_list.get_players()
        if #players < 0 then return {} end
    
        for i, player in pairs(players) do
            local health = player:get_prop("m_iHealth")
            if player:is_enemy() and health > 0 and not player:is_dormant() then
                if player:get_active_weapon() == nil then else  
                    local player_active_weapon = player:get_active_weapon():get_name()
                    if not player_active_weapon then return end
                    if player_active_weapon == "knife" then
                        table.insert(ret, player)
                    end
                end
            end
        end
        return ret
    end
    anti_knife_active = false
    if not local_player then return end
    local enemies = GetEnemiesWithKnife()
    if not enemies or #enemies < 0 then return end
    local min_distance = ui_handler.refs["Anti Aim"]["anti_knife_dist"].ref:get() + 100
    local local_player_origin = local_player:get_render_origin()
    for i, enemy in pairs(enemies) do
        local enemy_origin = enemy:get_render_origin()
        local distance_from_local_to_enemy = math.sqrt((enemy_origin.x - local_player_origin.x)^2 + (enemy_origin.y - local_player_origin.y)^2 + (enemy_origin.z - local_player_origin.z)^2)
        if min_distance >= distance_from_local_to_enemy then
            anti_knife_active = true
            local view_angles = engine.get_view_angles()
            prim_ref.yaw_add:set(180)
            cmd:set_pitch(view_angles.x)
        end
    end
end

local fake_lag = function(ctx, localplayer)
    if ui_handler.refs["Anti Aim"]["fl_mode"].ref:get() == 1 then
        prim_ref.fakelag:set(ui_handler.refs["Anti Aim"]["fl_amount"].ref:get())
    elseif ui_handler.refs["Anti Aim"]["fl_mode"].ref:get() == 2 then
        prim_ref.fakelag:set(math.floor(math.abs(math.sin(global_vars.tick_count()*0.025)) * ui_handler.refs["Anti Aim"]["fl_amount"].ref:get())+1)
        if prim_ref.fakelag:get() < 3 then
            prim_ref.fakelag:set(client.random_int(6, 8))
        end
    end

    local playerflags = localplayer:get_prop("m_fFlags")

    if ui_handler.refs["Anti Aim"]["fl_in_air"].ref:get() and bit.band(playerflags, 1) == 0 then
        prim_ref.fakelag:set(0)
        prim_ref.fakelag_lc:set(false)
    else
        prim_ref.fakelag_lc:set(ui_handler.refs["Anti Aim"]["fl_break_lg"].ref:get())
    end

    -- prim_ref.fakelag_lc:set(ui_handler.refs["Anti Aim"]["fl_break_lg"].ref:get())

end

local autostop = {
    anglesM = 0,
    main = function(self, cmd, localplayer)
        -- local dbg = forumInfo.name == "AmandaF"
        local dbg = false
        local fall_vel = localplayer:get_prop("m_flFallVelocity")
        local cur_threat = get_closest_enemy()
        local air_strafe = menu.find("misc", "main", "movement", "autostrafer")
        if fall_vel ~= 0 then end
        if cur_threat == nil then air_strafe:set(true) if dbg then print("No threat - 2399") end return end
        if fall_vel < 0 then
            local lp_weap = localplayer:get_active_weapon()
            if lp_weap == nil or lp_weap:get_weapon_data().console_name ~= "weapon_ssg08" then air_strafe:set(true) return end
            -- if lp_weap:get_weapon_reload() >= 0 then if dbg then print("Reload Error - 2403") end return end
            if global_vars.cur_time() <= lp_weap:get_prop("m_flNextPrimaryAttack") then if dbg then print("Waiting for next attack - 2404") end return end
            local inacc = lp_weap:get_weapon_inaccuracy()
            if inacc > 0.18 then 
                if not localplayer:get_prop("m_bIsScoped") then
                    print("Scoping")
                    cmd.buttons = bit.bor(cmd.buttons, 2048)
                end
            end
            if inacc > 0.15 then if dbg then if dbg then print("Not enough acc - 2411") end end return end
            -- trace.bullet(localplayer:get_eye_position(), cur_threat:get_hitbox_position(1), localplayer, cur_threat)
            local trace = trace.bullet(localplayer:get_eye_position(), cur_threat:get_hitbox_pos(e_hitboxes.HEAD), localplayer, cur_threat)
            if (trace.valid and trace.damage > 5) then 
                local vangles = engine.get_view_angles()
                local lc_pos = localplayer:get_render_origin()
                local line_end = extrapolate(localplayer, localplayer:get_prop("m_fFlags"), -10)
    
                if dbg then print("Stopping now") end
    
                local moveTo_x = lc_pos.x - line_end.x
                local moveTo_y = lc_pos.y - line_end.y
                local tv_x = -20*(moveTo_x * math.cos(vangles.y / 180 * math.pi) + moveTo_y * math.sin(vangles.y / 180 * math.pi))
                local tv_y = 20*(moveTo_y * math.cos(vangles.y / 180 * math.pi) - moveTo_x * math.sin(vangles.y / 180 * math.pi))
                air_strafe:set(false)
                cmd.move.x = tv_x
                cmd.move.y = tv_y
            else 
                if dbg then  print("Not enough dmg - 2414") end
            end 
        else
            if dbg then print("Fall_vel - 2428") end
            air_strafe:set(true)
        end
    end
}


local ground_tick = 1
local end_time = 0

local pitch_zero = function(ctx)
    local lp = entity_list.get_local_player()
    if not lp then return end
    local on_land = bit.band(lp:get_prop("m_fFlags"), bit.lshift(1, 0)) ~= 0
    local curtime = global_vars.cur_time()
    local playerflags = lp:get_prop("m_fFlags")
    if on_land == true then
        ground_tick = ground_tick + 1
    else
        ground_tick = 0
        end_time = curtime + 1
    end
    if ground_tick > 1 and end_time > curtime and
    ui_handler.refs["Anti Aim"]["anim_breakers"].ref:get(1) == true then
        ctx:set_render_pose(e_poses.BODY_PITCH, 0.5)
    end
    if bit.band(playerflags, 1) == 0 and ui_handler.refs["Anti Aim"]["anim_breakers"].ref:get(2) == true then
        ctx:set_render_pose(e_poses.JUMP_FALL, 1)
    end
end

local function getweapon(localplayer)
    local weapon_name = nil
    local active_weapon = localplayer:get_active_weapon()
    if active_weapon == nil then return end
    weapon_name = active_weapon:get_name()
    return weapon_name
end

local rage_handle = {
    weaps = rage_weapons,
    get_weap = function(self, localplayer)
        local weapon_name = getweapon(localplayer)
        local enemies = get_alive_enemies()
        for i = 1, #enemies do 
            local ent = entity_list.get_entity(enemies[i]:get_index())
            local abs_origin = localplayer:get_bounds()
            -- debug_overlay.add_sphere(abs_origin, 100, 100, 5, color_t(255, 255, 255), 1.0)
        end

        if weapon_name == "ssg08" then
    
        elseif weapon_name == "scar20" or weapon_name == "g3sg1" then
            
        elseif weapon_name == "awp" then

        elseif weapon_name == "glock" or weapon_name == "p250" or weapon_name == "cz75a" or weapon_name == "usp-s" or weapon_name == "tec9" or weapon_name == "p2000" or weapon_name == "fiveseven" or weapon_name == "elite" then

        elseif weapon_name == "deagle" or "revolver"then
        
        else

        end
    end,
    get_state = function(self, localplayer)
        local enemies = get_alive_enemies()
    end,

}

local dmg_ind = function(localplayer)
    if not localplayer or localplayer == nil then return end
    if not localplayer:is_alive() then return end

    local dmg_ind = ui_handler.refs["Visuals"]["dmg_indicator"].ref:get()
    local dmg_offset = ui_handler.refs["Visuals"]["dmg_offset"].ref:get()


    local weapon_name = getweapon(localplayer)

    local dmg_value = 0

    if weapon_name == "scar20" or weapon_name == "g3sg1" then
        dmg_value = prim_ref.min_dmg.auto[1]:get()
    elseif weapon_name == "awp" then
        dmg_value = prim_ref.min_dmg.awp[1]:get()
    elseif weapon_name == "deagle" then
        dmg_value = prim_ref.min_dmg.deagle[1]:get()
    elseif weapon_name == "glock" or weapon_name == "p250" or weapon_name == "cz75a" or weapon_name == "usp-s" or weapon_name == "tec9" or weapon_name == "p2000" or weapon_name == "fiveseven" or weapon_name == "elite" then
        dmg_value = prim_ref.min_dmg.pistols[1]:get()
    elseif weapon_name == "revolver" then
        dmg_value = prim_ref.min_dmg.revolver[1]:get()
    elseif weapon_name == "ssg08" then
        dmg_value = prim_ref.min_dmg.scout[1]:get()
    elseif prim_ref.min_dmg.other[1]:get() then
        dmg_value = prim_ref.min_dmg.other[1]:get()
    else
        dmg_value = 0
    end
    if prim_ref.min_dmg.auto[2]:get() or prim_ref.min_dmg.awp[2]:get() or prim_ref.min_dmg.deagle[2]:get() or prim_ref.min_dmg.other[2]:get() or prim_ref.min_dmg.pistols[2]:get() or prim_ref.min_dmg.revolver[2]:get() or prim_ref.min_dmg.scout[2]:get() then
        local pos = dmg_ind == 2 and vec2_t(screen_size.x/2 - dpi - dmg_offset, screen_size.y/2 - dpi - dmg_offset) or dmg_ind == 3 and vec2_t(screen_size.x/2, screen_size.y/2 - dpi - dmg_offset) or  dmg_ind == 4 and vec2_t(screen_size.x/2 + dpi + dmg_offset, screen_size.y/2 - dpi - dmg_offset) or vec2_t(screen_size.x/2, screen_size.y/2)
        render_text(fonts.verdana, tostring(dmg_value), pos, colors.white, true)
    end
end

local arrows_func = function(localplayer, view)
    if not localplayer or localplayer == nil then return end
    if not localplayer:is_alive() then return end

    local offset = ui_handler.refs["Visuals"]["arrows_offset"].ref:get()

    local function render_triangles(s)
        local view_angles = view
        local fake_rot = antiaim.get_fake_angle()
        local graphical_fake = view_angles.y - fake_rot - 90
        local fixed_fake = normalize_yaw(graphical_fake)
        local down_color = color_t(0, 0, 0, 127)
        local left_color = color_t(0, 0, 0, 127)
        local right_color = color_t(0, 0, 0, 127)

        if fixed_fake > 45 and fixed_fake < 135 then
            down_color = colors.main[2]:get()
        end
        if fixed_fake > -45 and fixed_fake < 45 then
            right_color = colors.main[2]:get()
        end
        if math.abs(fixed_fake) > 135 then
            left_color = colors.main[2]:get()
        end
        if fixed_fake < -45 and fixed_fake > -135 then
            right_color = colors.main[2]:get()
            left_color = colors.main[2]:get()
        end

        render.triangle_filled(vec2_t.new(screen_size.x / 2, screen_size.y / 2 +(10 + s)), dpi,down_color, 180)
        
        render.triangle_filled(vec2_t.new(screen_size.x / 2 -(15 +s),screen_size.y / 2), dpi, left_color, 270)
       
        render.triangle_filled(vec2_t.new(screen_size.x / 2 +(15 +s),screen_size.y / 2), dpi, right_color, 90)
       
    end

    local function invert_triangles(s)
        local active_tri

        local left_color = color_t(0, 0, 0, 127)
        local right_color = color_t(0, 0, 0, 127)

        if antiaim.get_desync_side() == 1 then
            right_color = colors.main[2]:get()
        else
            left_color = colors.main[2]:get()
        end

        render.triangle_filled(vec2_t.new(screen_size.x / 2 -(15 +s),screen_size.y / 2), dpi, left_color, 270)
        render.triangle_filled(vec2_t.new(screen_size.x / 2 +(15 +s),screen_size.y / 2), dpi, right_color, 90)
    end

    if ui_handler.refs["Visuals"]["arrows"].ref:get() == 2 then
        render_triangles(offset)
    elseif ui_handler.refs["Visuals"]["arrows"].ref:get() == 3 then
        invert_triangles(offset)
    end
end

local drg_xhair = 0
local memory_xhair = vec2_t(0,0)
local drg_binds = 0
local memory_binds = vec2_t(0,0)
local drg_spec = 0
local memory_spec = vec2_t(0,0)
local drg_water = 0
local memory_water = vec2_t(0,0)

local name_dynamics_offset = 0
local centex_s = 0
local a_centex_s = 0
local i_centex_s = 0
local smooth_delta = 0
local current = 0
local undercrosshair = function(localplayer, view_angles, frametime, menu_vis)
    local under_x_color = colors.undercrosshair:get()
    local undercrosshair_offset = ui_handler.refs["Visuals"]["undercrosshair_offset"].ref:get()
    local y_position = 0

    if not localplayer or localplayer == nil then return end
    if not localplayer:is_alive() then return end

    local center = vec2_t(screen_size.x/2, screen_size.y/2)

    local scoped = ui_handler.refs["Visuals"]["undercrosshair_options"].ref:get(1) and localplayer:get_prop("m_bIsScoped") == 1 or false

    local centex = scoped and 0 or 0.5
    centex_s = round(lerp(centex_s, centex, 15 * frametime),5)
    if centex_s > 0.49 then centex_s = 0.5 end
    if centex_s < 0.01 then centex_s = 0.0 end

    local i_centex = scoped and 1 or 0
    i_centex_s = round(lerp(i_centex_s, i_centex, 25 * frametime),5)
    if i_centex_s > 0.98 then i_centex_s = 1 end
    if i_centex_s < 0.01 then i_centex_s = 0.0 end

    local a_centex = scoped and 0 or 1
    a_centex_s = round(lerp(a_centex_s, a_centex, 25 * frametime),5)
    if a_centex_s > 0.98 then a_centex_s = 1 end
    if a_centex_s < 0.01 then a_centex_s = 0.0 end


    local function drag_xhair(pos_x, pos_y, size_x, size_y, mouse_pos) -- binds -------------------------------

        if mouse_pos.x >= pos_x and mouse_pos.x <= pos_x + size_x and mouse_pos.y >= pos_y and mouse_pos.y <= pos_y + size_y then
            if input.is_key_held(e_keys.MOUSE_LEFT) and drg_binds == 0 and drg_xhair == 0 and drg_spec == 0 and drg_water == 0 then
                drg_xhair = 1
                memory_xhair.y = pos_y - mouse_pos.y
            end
        end

        if not input.is_key_held(e_keys.MOUSE_LEFT) then drg_xhair = 0 end

        if drg_xhair == 1 and menu_vis then
            ui_handler.refs["Visuals"]["undercrosshair_offset"].ref:set((mouse_pos.y - screen_size.y / 2) + memory_xhair.y - 10)
        end

        if menu_vis then
            render.rect(vec2_t(pos_x + (size_x/2)*i_centex, pos_y),vec2_t(size_x, size_y - dpi+3),color_t(250, 250, 250, 120))
        end
        if undercrosshair_offset <= -10 then
            ui_handler.refs["Visuals"]["undercrosshair_offset"].ref:set(-9)
        end
        if undercrosshair_offset > 450 then
            ui_handler.refs["Visuals"]["undercrosshair_offset"].ref:set(450)
        end
    end

    local dynamics_vals = scoped and 0 or (get_velocity(localplayer)/350)*(dpi*4)

    if ui_handler.refs["Visuals"]["lua_name_animated"].ref:get() and ui_handler.refs["Visuals"]["undercrosshair_options"].ref:get(1) then
    name_dynamics_offset = lerp(name_dynamics_offset, dynamics_vals,10* frametime)
        if name_dynamics_offset <= 1 then name_dynamics_offset = 0 end 
    else
        name_dynamics_offset = 0
    end
    
    if ui_handler.refs["Visuals"]["undercrosshair_display"].ref:get(1) then

        local O_color
        local U_color
        local I_color
        local J_color
        local A_color
        local dot_color
        local L_color
        local U2_color
        local A2_color

        local full_lua_name_size = static_sizes.O_text_size.x + static_sizes.U_text_size.x + static_sizes.I_text_size.x + static_sizes.J_text_size.x + static_sizes.A_text_size.x + static_sizes.dot_text_size.x + static_sizes.L_text_size.x + static_sizes.U2_text_size.x + static_sizes.A2_text_size.x 
        local style = ui_handler.refs["Visuals"]["lua_name_style"].ref:get()
        local invt = antiaim.get_desync_side()
        if style == 1 then
             O_color = under_x_color
             U_color = under_x_color
             I_color = under_x_color
             J_color = under_x_color
             A_color = under_x_color
             dot_color = under_x_color
             L_color = under_x_color
             U2_color = under_x_color
             A2_color = under_x_color
        elseif style == 2 then
            if invt == 1 then
                O_color = under_x_color
                U_color = under_x_color
                I_color = under_x_color
                J_color = under_x_color 

                A_color = color_t(math.floor(under_x_color.r*(0.6)), math.floor(under_x_color.g*(0.6)), math.floor(under_x_color.b*(0.6)),under_x_color.a) 
                dot_color = color_t(math.floor(under_x_color.r*(0.5)), math.floor(under_x_color.g*(0.5)), math.floor(under_x_color.b*(0.5)),under_x_color.a) 
                L_color = color_t(math.floor(under_x_color.r*(0.3)), math.floor(under_x_color.g*(0.3)), math.floor(under_x_color.b*(0.3)),under_x_color.a) 
                U2_color = color_t(math.floor(under_x_color.r*(0.2)), math.floor(under_x_color.g*(0.2)), math.floor(under_x_color.b*(0.2)),under_x_color.a) 
                A2_color = color_t(math.floor(under_x_color.r*(0.1)), math.floor(under_x_color.g*(0.1)), math.floor(under_x_color.b*(0.1)),under_x_color.a) 
            else
                O_color = color_t(math.floor(under_x_color.r*(0.1)), math.floor(under_x_color.g*(0.2)), math.floor(under_x_color.b*(0.2)),under_x_color.a) 
                U_color = color_t(math.floor(under_x_color.r*(0.2)), math.floor(under_x_color.g*(0.3)), math.floor(under_x_color.b*(0.3)),under_x_color.a)
                I_color = color_t(math.floor(under_x_color.r*(0.4)), math.floor(under_x_color.g*(0.4)), math.floor(under_x_color.b*(0.4)),under_x_color.a) 
                J_color =color_t(math.floor(under_x_color.r*(0.5)), math.floor(under_x_color.g*(0.5)), math.floor(under_x_color.b*(0.5)),under_x_color.a) 

                A_color = under_x_color 
                dot_color = under_x_color 
                L_color = under_x_color 
                U2_color = under_x_color 
                A2_color = under_x_color 
            end
        elseif style == 3 then
            local blink_color = color_t(255,255,255,math.floor(math.abs(math.sin(global_vars.tick_count()*0.025)) * 255))
            O_color = color_t(under_x_color.r, under_x_color.g, under_x_color.b,under_x_color.a) 
            U_color = color_t(under_x_color.r, under_x_color.g, under_x_color.b,under_x_color.a)
            I_color = color_t(under_x_color.r, under_x_color.g, under_x_color.b,under_x_color.a)
            J_color = color_t(under_x_color.r, under_x_color.g, under_x_color.b,under_x_color.a)
            A_color = color_t(under_x_color.r, under_x_color.g, under_x_color.b,under_x_color.a)

            dot_color = blink_color
            L_color = blink_color
            U2_color = blink_color
            A2_color = blink_color
        elseif style == 4 then
            local color_g1 = colors.g1:get()
            local color_g2 = colors.g2:get()
            local color_g3 = colors.g3:get()

            O_color = color_g1
            U_color = color_t(
            math.floor((color_g1.r)*0.75)+math.floor((color_g2.r)*0.25),
            math.floor((color_g1.g)*0.75)+math.floor((color_g2.g)*0.25),
            math.floor((color_g1.b)*0.75)+math.floor((color_g2.b)*0.25),
            math.floor((color_g1.a)*0.75)+math.floor((color_g2.a)*0.25))
            I_color = color_t(
            math.floor((color_g1.r)*0.5)+math.floor((color_g2.r)*0.5),
            math.floor((color_g1.g)*0.5)+math.floor((color_g2.g)*0.5),
            math.floor((color_g1.b)*0.5)+math.floor((color_g2.b)*0.5),
            math.floor((color_g1.a)*0.5)+math.floor((color_g2.a)*0.5))
            J_color = color_t(
            math.floor((color_g1.r)*0.25)+math.floor((color_g2.r)*0.75),
            math.floor((color_g1.g)*0.25)+math.floor((color_g2.g)*0.75),
            math.floor((color_g1.b)*0.25)+math.floor((color_g2.b)*0.75),
            math.floor((color_g1.a)*0.25)+math.floor((color_g2.a)*0.75))
            A_color = color_g2
            dot_color = color_t(
            math.floor((color_g2.r)*0.75)+math.floor((color_g3.r)*0.25),
            math.floor((color_g2.g)*0.75)+math.floor((color_g3.g)*0.25),
            math.floor((color_g2.b)*0.75)+math.floor((color_g3.b)*0.25),
            math.floor((color_g2.a)*0.75)+math.floor((color_g3.a)*0.25))
            L_color = color_t(
            math.floor((color_g2.r)*0.5)+math.floor((color_g3.r)*0.5),
            math.floor((color_g2.g)*0.5)+math.floor((color_g3.g)*0.5),
            math.floor((color_g2.b)*0.5)+math.floor((color_g3.b)*0.5),
            math.floor((color_g2.a)*0.5)+math.floor((color_g3.a)*0.5))
            U2_color = color_t(
            math.floor((color_g2.r)*0.25)+math.floor((color_g3.r)*0.75),
            math.floor((color_g2.g)*0.25)+math.floor((color_g3.g)*0.75),
            math.floor((color_g2.b)*0.25)+math.floor((color_g3.b)*0.75),
            math.floor((color_g2.a)*0.25)+math.floor((color_g3.a)*0.75))
            A2_color = color_g3
        end

        render_text(fonts.verdana, "O",vec2_t((center.x - full_lua_name_size*centex_s) - name_dynamics_offset+ (2*i_centex_s), center.y+11+undercrosshair_offset),O_color)
        render_text(fonts.verdana, "u",vec2_t((center.x - full_lua_name_size*centex_s) +static_sizes.O_text_size.x - name_dynamics_offset*0.75+ (2*i_centex_s), center.y+11+undercrosshair_offset),U_color)
        render_text(fonts.verdana, "i",vec2_t((center.x - full_lua_name_size*centex_s) +static_sizes.O_text_size.x+static_sizes.U_text_size.x - name_dynamics_offset*0.5+ (2*i_centex_s), center.y+11+undercrosshair_offset),I_color)
        render_text(fonts.verdana, "j",vec2_t((center.x - full_lua_name_size*centex_s) +static_sizes.O_text_size.x+static_sizes.U_text_size.x +static_sizes.I_text_size.x - name_dynamics_offset*0.25+ (2*i_centex_s), center.y+11+undercrosshair_offset),J_color)

        render_text(fonts.verdana, "a",vec2_t((center.x - full_lua_name_size*centex_s) +static_sizes.O_text_size.x+static_sizes.U_text_size.x +static_sizes.I_text_size.x + static_sizes.J_text_size.x+ (2*i_centex_s), center.y+11+undercrosshair_offset),A_color)

        render_text(fonts.verdana, ".",vec2_t((center.x - full_lua_name_size*centex_s) +static_sizes.O_text_size.x+static_sizes.U_text_size.x +static_sizes.I_text_size.x + static_sizes.J_text_size.x +static_sizes.A_text_size.x + name_dynamics_offset*0.25+ (2*i_centex_s), center.y+11+undercrosshair_offset),dot_color)
        render_text(fonts.verdana, "l",vec2_t((center.x - full_lua_name_size*centex_s) +static_sizes.O_text_size.x+static_sizes.U_text_size.x +static_sizes.I_text_size.x + static_sizes.J_text_size.x +static_sizes.A_text_size.x + static_sizes.dot_text_size.x+ name_dynamics_offset*0.5+ (2*i_centex_s), center.y+11+undercrosshair_offset),L_color)
        render_text(fonts.verdana, "u",vec2_t((center.x - full_lua_name_size*centex_s) +static_sizes.O_text_size.x+static_sizes.U_text_size.x +static_sizes.I_text_size.x + static_sizes.J_text_size.x +static_sizes.A_text_size.x + static_sizes.dot_text_size.x+ static_sizes.L_text_size.x + name_dynamics_offset*0.75+ (2*i_centex_s), center.y+11+undercrosshair_offset),U2_color)
        render_text(fonts.verdana, "a",vec2_t((center.x - full_lua_name_size*centex_s) +static_sizes.O_text_size.x+static_sizes.U_text_size.x +static_sizes.I_text_size.x + static_sizes.J_text_size.x +static_sizes.A_text_size.x + static_sizes.dot_text_size.x+ static_sizes.L_text_size.x+ static_sizes.U2_text_size.x + name_dynamics_offset+ (2*i_centex_s), center.y+11+undercrosshair_offset),A2_color)
        y_position = y_position + dpi
    end

    if ui_handler.refs["Visuals"]["undercrosshair_display"].ref:get(2) then
        --============ Anti aim setting ==============================
        local graphical_real = view_angles.y - antiaim.get_real_angle() -90
        local graphical_fake = view_angles.y - antiaim.get_fake_angle() - 90
    
        local goodcodeyaw_diff = clamp(math.floor(180 -math.abs(math.abs(graphical_fake -graphical_real) - 180)),0,60)
    
        smooth_delta = lerp(smooth_delta, goodcodeyaw_diff, 10 * frametime)
        local invert_text = antiaim.get_desync_side() == 1 and "left" or "right"
        --============ Anti aim setting ==============================

        local aa_info_color
        local aa_info_string = ""
        if  ui_handler.refs["Visuals"]["aa_info_display"].ref:get() == 1 then
            -- if legit_aa_state then aa_state = "legit" end
            if anti_knife_active then aa_state = "knife" end
            if #anti_brute_logs > 0 then aa_state = "anti brute" end
            -- aa_info_string = aa_state
            aa_info_string = aa_state
        end
        if ui_handler.refs["Visuals"]["aa_info_display"].ref:get() == 2 then
            aa_info_string = invert_text
        end
        
        local condition_text_size = render.get_text_size(fonts.pix, aa_info_string)

        if ui_handler.refs["Visuals"]["aa_info_color"].ref:get() then
            aa_info_color = color_t(math.floor((1-clamp(smooth_delta/60,0,1))*255), math.floor(clamp(smooth_delta/30,0,1)*255), 0, 255)
        else
            aa_info_color = colors.undercrosshair:get()
        end
        if  ui_handler.refs["Visuals"]["aa_info_display"].ref:get() == 2 then
        local first_bracket_size = render.get_text_size(fonts.pix, "[") 
        local degress_sign_size = render.get_text_size(fonts.pix, "°")
        local yaw_delta_text_size = scoped and render.get_text_size(fonts.pix, "00") or render.get_text_size(fonts.pix, tostring(goodcodeyaw_diff)) 
        
        render_text(fonts.pix, "°", vec2_t(center.x - (degress_sign_size.x*a_centex_s) - (first_bracket_size.x*a_centex_s) - (3*a_centex_s) + (yaw_delta_text_size.x*i_centex_s) + (3*i_centex_s), center.y+11+undercrosshair_offset+y_position), aa_info_color)  
        render_text(fonts.pix, tostring(goodcodeyaw_diff), vec2_t(center.x - degress_sign_size.x*a_centex_s - yaw_delta_text_size.x*a_centex_s - first_bracket_size.x*a_centex_s- (3*a_centex_s)+ (3*i_centex_s), center.y+11+undercrosshair_offset+y_position), colors.white)  
        render_text(fonts.pix, "[", vec2_t(center.x - (first_bracket_size.x*a_centex_s)- (3*a_centex_s)+(yaw_delta_text_size.x*i_centex_s  + degress_sign_size.x*i_centex_s)+ (3*i_centex_s), center.y+11+undercrosshair_offset+y_position), aa_info_color)  
        render_text(fonts.pix, aa_info_string, vec2_t(center.x +(yaw_delta_text_size.x*i_centex_s + first_bracket_size.x*i_centex_s + degress_sign_size.x*i_centex_s) - (3*a_centex_s)+ (3*i_centex_s), center.y+11+undercrosshair_offset+y_position), colors.white)  
        render_text(fonts.pix, "]", vec2_t(center.x+(yaw_delta_text_size.x*i_centex_s + first_bracket_size.x*i_centex_s + degress_sign_size.x*i_centex_s)+condition_text_size.x - (3*a_centex_s)+ (3*i_centex_s), center.y+11+undercrosshair_offset+y_position), aa_info_color)  

        else
        render_text(fonts.pix, aa_info_string, vec2_t(center.x - condition_text_size.x*centex_s+ (3*i_centex_s), center.y+11+undercrosshair_offset+y_position), aa_info_color)
        end

        y_position = y_position +dpi-4
    end
    local exp_charge = exploits.get_charge()
    local max_charge = exploits.get_max_charge()
    local math_num = exp_charge+max_charge
    local short = ui_handler.refs["Visuals"]["undercrosshair_options"].ref:get(2)
    local inline = ui_handler.refs["Visuals"]["undercrosshair_options"].ref:get(3)

    local inline_table = {}

    if ui_handler.refs["Visuals"]["undercrosshair_display"].ref:get(3) and prim_ref.dt_enabled:get() then
        local dt_r_color = math_num == 0 and color_t(colors.doubletap:get().r,colors.doubletap:get().g,colors.doubletap:get().b,0) or color_t(clamp(math.floor(colors.doubletap:get().r*exp_charge/max_charge),0,255),
                                                                                                                                                clamp(math.floor(colors.doubletap:get().g*exp_charge/max_charge),0,255),
                                                                                                                                                clamp(math.floor(colors.doubletap:get().b*exp_charge/max_charge),0,255),
                                                                                                                                                clamp(math.floor(255*exp_charge/max_charge),0,255))
        local dt_text = short and "DT" or "doubletap"
        local doubletap_text_size = render.get_text_size(fonts.pix, dt_text)

        if inline then 
            table.insert(inline_table, dt_text)
        else
            render_text(fonts.pix, dt_text, vec2_t(center.x - doubletap_text_size.x*centex_s+ (3*i_centex_s), center.y+11+undercrosshair_offset+y_position), color_t(120,120,120,255))
            render_text(fonts.pix, dt_text, vec2_t(center.x - doubletap_text_size.x*centex_s+ (3*i_centex_s), center.y+11+undercrosshair_offset+y_position), dt_r_color)    
     
            y_position = y_position + dpi-4
        end
    end

    if ui_handler.refs["Visuals"]["undercrosshair_display"].ref:get(4) and prim_ref.hs_enabled:get() then
        local hs_r_color = math_num == 0 and color_t(colors.hideshots:get().r,colors.hideshots:get().g,colors.hideshots:get().b,0) or color_t(clamp(math.floor(colors.hideshots:get().r*exp_charge/max_charge),0,255),clamp(math.floor(colors.hideshots:get().g*exp_charge/max_charge),0,255),clamp(math.floor(colors.hideshots:get().b*exp_charge/max_charge),0,255),clamp(math.floor(255*exp_charge/max_charge),0,255))
        local hs_text = short and "HS" or "hideshots"
        local hideshots_text_size = render.get_text_size(fonts.pix, hs_text)

        if inline then 
            table.insert(inline_table, hs_text)
        else
            render_text(fonts.pix, hs_text, vec2_t(center.x - hideshots_text_size.x*centex_s+ (3*i_centex_s), center.y+11+undercrosshair_offset+y_position), color_t(120,120,120,255))
            render_text(fonts.pix, hs_text, vec2_t(center.x - hideshots_text_size.x*centex_s+ (3*i_centex_s), center.y+11+undercrosshair_offset+y_position), hs_r_color)    
     
            y_position = y_position + dpi-4
        end
    end

    if ui_handler.refs["Visuals"]["undercrosshair_display"].ref:get(5) and prim_ref.fd_enabled:get() then
        local fd_color_mod = clamp(localplayer:get_prop("m_flDuckAmount") +0.6, 0, 1)
        local fd_text = short and "FD" or "fakeduck"
        local fakeduck_text_size = render.get_text_size(fonts.pix, fd_text)

        if inline then 
            table.insert(inline_table, fd_text)
        else
            render_text(fonts.pix, fd_text, vec2_t(center.x - fakeduck_text_size.x*centex_s+ (3*i_centex_s), center.y+11+undercrosshair_offset+y_position), color_t(
            math.floor(colors.fakeduck:get().r * fd_color_mod),
            math.floor(colors.fakeduck:get().g * fd_color_mod),
            math.floor(colors.fakeduck:get().b * fd_color_mod),
            255))
            y_position = y_position + dpi-4
        end
    end
    local dmgE = ui_handler.refs["Visuals"]["undercrosshair_display"].ref:get(6)
    if dmgE and 
    prim_ref.min_dmg.auto[2]:get() or dmgE and prim_ref.min_dmg.awp[2]:get() or dmgE and prim_ref.min_dmg.deagle[2]:get() or dmgE and prim_ref.min_dmg.other[2]:get() or dmgE and prim_ref.min_dmg.pistols[2]:get() or dmgE and prim_ref.min_dmg.revolver[2]:get() or dmgE and prim_ref.min_dmg.scout[2]:get() then
        local dmg_text = short and "DMG" or "damage"
        local dmg_text_size = render.get_text_size(fonts.pix, dmg_text)

        if inline then 
            table.insert(inline_table, dmg_text)
        else
            render_text(fonts.pix, dmg_text, vec2_t(center.x - dmg_text_size.x*centex_s+ (3*i_centex_s), center.y+11+undercrosshair_offset+y_position), colors.dmg:get())
            y_position = y_position + dpi-4
        end
    end

    local inline_text = ""
    if ui_handler.refs["Visuals"]["undercrosshair_options"].ref:get(3) then
        if #inline_table > 0 then
            if #inline_table == 1 then 
                inline_text = inline_table[1]
            else
                for i = 1, #inline_table do
                    if i == 1 then
                        inline_text = inline_table[i]
                    else
                        inline_text = inline_text .. "/" .. inline_table[i]
                    end
                end
            end
            local inline_text_size = render.get_text_size(fonts.pix, inline_text)
            render_text(fonts.pix, inline_text, vec2_t(center.x - inline_text_size.x*centex_s+ (3*i_centex_s), center.y+11+undercrosshair_offset+y_position), colors.dmg:get())
            y_position = y_position + dpi-4
        end
    end
    drag_xhair(center.x - (name_dynamics_offset + dpi+20*2),
    (screen_size.y / 2) + undercrosshair_offset + 11,  
    (dpi+20*2+name_dynamics_offset)*2,
    dpi+y_position, input.get_mouse_pos())
end

local hotkey_list = {}
local smooth_x_size_binds = 0
local binds_fade = 0
local binds_fade_value = 0

local binds_func = function(localplayer, menu_vis)
    local binds_offset = 2
    binds_fade_value = 0
    hotkey_list = {}
    local add_hotkey = function(ref, name, weapon_config)
        table.insert(hotkey_list, {
            ref = ref,
            name = name,
            weapon_config = weapon_config,
            alpha = 0
        })
    end
    add_hotkey(menu.find("aimbot", "general", "misc", "autopeek")[2],"Auto peek")
    add_hotkey(menu.find("aimbot", "general", "aimbot","body lean resolver")[2], "Body lean resolver")
    add_hotkey(menu.find("aimbot", "general", "exploits", "doubletap","enable")[2], "Double tap")
    add_hotkey(menu.find("aimbot", "general", "exploits", "hideshots","enable")[2], "Hide shots")
    for iter, data in ipairs {
        {"auto", e_ragebot_cfg.AUTO_SNIPER}, 
        {"scout", e_ragebot_cfg.SCOUT},
        {"awp", e_ragebot_cfg.AWP}, 
        {"deagle", e_ragebot_cfg.HEAVY_PISTOLS},
        {"pistols", e_ragebot_cfg.PISTOLS}, 
        {"other", e_ragebot_cfg.OTHER}
    } do
        local menu_group, weapon_config = unpack(data)
        add_hotkey(menu.find("aimbot", menu_group, "target overrides","force lethal shot", 0), "Force Lethal", weapon_config)
        add_hotkey(menu.find("aimbot", menu_group, "target overrides","force min. damage", 0), "Damage override", weapon_config)
        add_hotkey(menu.find("aimbot", menu_group, "target overrides","force hitbox", 0), "Force hitbox", weapon_config)
        add_hotkey(menu.find("aimbot", menu_group, "target overrides","force safepoint", 0), "Force safe point", weapon_config)
        add_hotkey(menu.find("aimbot", menu_group, "target overrides","force hitchance", 0), "Force hit chance", weapon_config)
    end
    add_hotkey(menu.find("antiaim", "main", "general", "fake duck", 1),"Fake duck")
    add_hotkey(menu.find("antiaim", "main", "general", "lock angle", 1),"Lock angle")
    add_hotkey(menu.find("antiaim", "main", "manual", "invert desync", 1),"Anti Aim inverter")
    add_hotkey(menu.find("antiaim", "main", "manual", "invert body lean", 1),"Body lean inverter")
    add_hotkey(menu.find("antiaim", "main", "auto direction", "enable", 1),"Freestanding")
    add_hotkey(menu.find("misc", "main", "movement", "slow walk", 1),"Slow walk")
    add_hotkey(menu.find("misc", "main", "movement", "edge jump", 1),"Edge jump")
    add_hotkey(menu.find("misc", "main", "movement", "sneak", 1), "Sneak")
    add_hotkey(menu.find("misc", "main", "movement", "edge bug helper", 1),"Edgebug")
    add_hotkey(menu.find("misc", "main", "movement", "jump bug", 1),"Jumpbug")
    add_hotkey(menu.find("misc", "nade helper", "general", "autothrow", 1),"Autothrow")
    add_hotkey(menu.find("misc", "utility", "general", "fire extinguisher", 1), "Fire extinguisher")
    add_hotkey(menu.find("misc", "utility", "general", "freecam", 1),"Freecam")

    local menu_open_alpha = 0
    local binds_s_x = 75
    local binds_s_y = dpi + 5

    local function binds_drag(pos_x, pos_y, size_x, size_y, mouse_pos) -- binds -------------------------------
        if mouse_pos.x >= pos_x and mouse_pos.x <= pos_x + size_x and mouse_pos.y >= pos_y and mouse_pos.y <= pos_y + size_y then
            if input.is_key_held(e_keys.MOUSE_LEFT) and drg_binds == 0 and drg_xhair == 0 and drg_spec == 0 and drg_water == 0 then 
                drg_binds = 1
                memory_binds.x = pos_x - mouse_pos.x
                memory_binds.y = pos_y - mouse_pos.y
            end
        end
        if not input.is_key_held(e_keys.MOUSE_LEFT) then drg_binds = 0 end
        if drg_binds == 1 and menu_vis then
            ui_handler.refs["Visuals"]["binds_x"].ref:set(math.floor(mouse_pos.x +memory_binds.x))
            ui_handler.refs["Visuals"]["binds_y"].ref:set(math.floor(mouse_pos.y +memory_binds.y))
        end
        if menu_vis then end
        if ui_handler.refs["Visuals"]["binds_x"].ref:get() + size_x > screen_size.x then
            ui_handler.refs["Visuals"]["binds_x"].ref:set(math.floor(screen_size.x - size_x))
        end
        if ui_handler.refs["Visuals"]["binds_x"].ref:get() < 0 then
            ui_handler.refs["Visuals"]["binds_x"].ref:set(0)
        end
        if ui_handler.refs["Visuals"]["binds_y"].ref:get() + size_y > screen_size.y then
            ui_handler.refs["Visuals"]["binds_y"].ref:set(math.floor(screen_size.y - size_y))
        end
        if ui_handler.refs["Visuals"]["binds_y"].ref:get() < 0 then
            ui_handler.refs["Visuals"]["binds_y"].ref:set(0)
        end
    end
    local bindsx = ui_handler.refs["Visuals"]["binds_x"].ref:get()
    local bindsy = ui_handler.refs["Visuals"]["binds_y"].ref:get()

    -- print(colors.undercrosshair)

    local binds_color = color_t(255, 255, 255, 255)

    if menu.is_open() == true or engine.is_in_game() == true then
        if ui_handler.refs["Visuals"]["window_style"].ref:get() == 1 then
            render.rect_filled(vec2_t(bindsx, bindsy),vec2_t(smooth_x_size_binds, binds_s_y), color_t(5, 5, 5,clamp(math.floor(binds_fade * 255), 0, 230)),5)
            render.rect(vec2_t(bindsx, bindsy),vec2_t(smooth_x_size_binds, binds_s_y),color_t(binds_color.r, binds_color.g, binds_color.b,clamp(math.floor(binds_fade * 255), 0, 240)), 5)
            render.rect(vec2_t(bindsx - 0.5, bindsy - 0.5),vec2_t(smooth_x_size_binds + 1, binds_s_y + 1),color_t(binds_color.r, binds_color.g, binds_color.b,clamp(math.floor(binds_fade * 255), 0, 240 / 2)),5)
        elseif ui_handler.refs["Visuals"]["window_style"].ref:get() == 2 then
            render.rect_filled(vec2_t(bindsx, bindsy),vec2_t(smooth_x_size_binds, binds_s_y), color_t(5, 5, 5,clamp(math.floor(binds_fade * 255), 0, 230)))
            if ui_handler.refs["Visuals"]["windows_grad"].ref:get() then
                local start_c = color_t(colors.windows_grad1:get().r, colors.windows_grad1:get().g, colors.windows_grad1:get().b,clamp(math.floor(binds_fade * 255), 0, 240))
                local end_c = color_t(colors.windows_grad2:get().r, colors.windows_grad2:get().g, colors.windows_grad2:get().b,clamp(math.floor(binds_fade * 255), 0, 240))
                render.rect_fade(vec2_t(bindsx, bindsy-1),vec2_t(smooth_x_size_binds, 1),end_c,start_c, true)
            else
                render.rect(vec2_t(bindsx, bindsy-1),vec2_t(smooth_x_size_binds, 1),color_t(binds_color.r, binds_color.g, binds_color.b,clamp(math.floor(binds_fade * 255), 0, 240)))
            end
        elseif ui_handler.refs["Visuals"]["window_style"].ref:get() == 3 then
            render.rect_filled(vec2_t(bindsx, bindsy),vec2_t(smooth_x_size_binds, binds_s_y), color_t(5, 5, 5,clamp(math.floor(binds_fade * 255), 0, 230)),5)
            render.rect_half_round(vec2_t.new(bindsx-1, bindsy-2), vec2_t.new(smooth_x_size_binds+3, binds_s_y*1.37),color_t(binds_color.r, binds_color.g, binds_color.b,clamp(math.floor(binds_fade * 255), 0, 240)), 1, 8)
        end 
        render_text(fonts.verdana, "Binds", vec2_t(bindsx + smooth_x_size_binds / 2,bindsy + binds_s_y / 2), color_t(255, 255, 255,clamp( math.floor( binds_fade *255),0, 255)), true)
    end
    local key_modes = {"[toggled]", "[holding]", "[on]", "[on]", "mode 5"}
    if engine.is_in_game() == true then
        local function is_active(binds)
            local rage_config = ragebot.get_active_cfg()
            if binds.ref == nil then return false end
            if binds.ref == true then
                if binds.weapon_config == nil then
                    return true
                else
                    if binds.weapon_config ~= rage_config then
                        return false
                    else
                        return true
                    end
                end
            else
                return false
            end
        end
        for i = 1, #hotkey_list do
            if is_active(hotkey_list[i]) == true then
                binds_fade_value = 1
                if render.get_text_size(fonts.verdana_s, hotkey_list[i].name).x + render.get_text_size(fonts.verdana_s, tostring(key_modes[hotkey_list[i].ref:get_mode() + 1])).x +20 > binds_s_x then
                    binds_s_x = render.get_text_size(fonts.verdana_s,hotkey_list[i].name).x +render.get_text_size(fonts.verdana_s, tostring( key_modes[hotkey_list[i].ref:get_mode() +1])).x +15
                end
                render_text(fonts.verdana_s, hotkey_list[i].name, vec2_t(bindsx + 3,bindsy + binds_s_y + binds_offset),color_t(255, 255, 255,math.floor(binds_fade * 255)))
                render_text(fonts.verdana_s, tostring(key_modes[hotkey_list[i].ref:get_mode() + 1]),vec2_t(bindsx + smooth_x_size_binds -render.get_text_size(fonts.verdana_s,tostring(key_modes[hotkey_list[i].ref:get_mode() +1])).x,
                bindsy + binds_s_y + binds_offset),color_t(255, 255, 255,math.floor(binds_fade * 255)))
                binds_offset = binds_offset + dpi
            end
        end
    end
    if menu.is_open() == true then
        binds_fade = 1
    else
        binds_fade = lerp(binds_fade, binds_fade_value, 20 *clamp(global_vars.frame_time(), 0.001, 0.008))
    end
    smooth_x_size_binds = round(lerp(smooth_x_size_binds, binds_s_x,20 *clamp(global_vars.frame_time(),0.001, 0.008)), 3)
    binds_drag(bindsx, bindsy, smooth_x_size_binds, binds_s_y, input.get_mouse_pos())
end

local smooth_x_size_spec = 0
local spec_fade = 0
local spec_fade_value = 0

local spec_func = function(localplayer, menu_vis)
    local sp_offset = 2
    local other_sp_offset = 0
    spec_fade_value = 0

    local function is_spectating(player)
        if not engine.is_in_game() then return false end
        local player_target = localplayer:get_prop("m_hObserverTarget")

        local players = entity_list.get_players()
        if player == nil then return end
        if player == localplayer then return false end
        if player:is_dormant() then return false end
        if not player:is_player() then return end
        if player:is_alive() == true then return false end
        local target = player:get_prop("m_hObserverTarget")
        if target == nil then end
        local targetfix = entity_list.get_entity(target)
        if localplayer:is_alive() == true then
            if targetfix == localplayer then return true end
        else
            if target == player_target then return true end
        end
    end

    local spec_s_x = 75
    local spec_s_y = dpi+5

    local function spec_drag(pos_x, pos_y, size_x, size_y, mouse_pos) -- spectators -------------------------------

        if mouse_pos.x >= pos_x and mouse_pos.x <= pos_x + size_x and mouse_pos.y >= pos_y and mouse_pos.y <= pos_y + size_y then
            if input.is_key_held(e_keys.MOUSE_LEFT) and drg_binds == 0 and drg_xhair == 0 and drg_spec == 0 and drg_water == 0 then 
                drg_spec = 1
                memory_spec.x = pos_x - mouse_pos.x
                memory_spec.y = pos_y - mouse_pos.y
            end
        end

        if not input.is_key_held(e_keys.MOUSE_LEFT) then drg_spec = 0 end

        if drg_spec == 1 and menu_vis then
            ui_handler.refs["Visuals"]["spec_x"].ref:set(math.floor(mouse_pos.x +memory_spec.x))
            ui_handler.refs["Visuals"]["spec_y"].ref:set(math.floor(mouse_pos.y +memory_spec.y))
        end

        if ui_handler.refs["Visuals"]["spec_x"].ref:get() + size_x > screen_size.x then
            ui_handler.refs["Visuals"]["spec_x"].ref:set(math.floor(screen_size.x - size_x))
        end
        if ui_handler.refs["Visuals"]["spec_x"].ref:get() < 0 then
            ui_handler.refs["Visuals"]["spec_x"].ref:set(0)
        end

        if ui_handler.refs["Visuals"]["spec_y"].ref:get() + size_y > screen_size.y then
            ui_handler.refs["Visuals"]["spec_y"].ref:set(math.floor(screen_size.y - size_y))
        end
        if ui_handler.refs["Visuals"]["spec_y"].ref:get() < 0 then
            ui_handler.refs["Visuals"]["spec_y"].ref:set(0)
        end
    end

    local specx = ui_handler.refs["Visuals"]["spec_x"].ref:get()
    local specy = ui_handler.refs["Visuals"]["spec_y"].ref:get()

    local specs_color = colors.main[2]:get()

    if menu.is_open() == true or engine.is_in_game() == true then
        if ui_handler.refs["Visuals"]["window_style"].ref:get() == 1 then
            render.rect_filled(vec2_t(specx, specy), vec2_t(smooth_x_size_spec, spec_s_y), color_t(5, 5, 5, clamp( math.floor(spec_fade *255),0,230)),5)
            render.rect(vec2_t(specx, specy), vec2_t(smooth_x_size_spec, spec_s_y), color_t(specs_color.r, specs_color.g, specs_color.b, clamp(math.floor(spec_fade * 255), 0, 240)), 5)
            render.rect(vec2_t(specx - 0.5, specy - 0.5),vec2_t(smooth_x_size_spec + 1, spec_s_y + 1), color_t(specs_color.r, specs_color.g, specs_color.b, clamp(math.floor(spec_fade * 255), 0, 240 / 2)), 5)
        elseif ui_handler.refs["Visuals"]["window_style"].ref:get() == 2 then
            render.rect_filled(vec2_t(specx, specy),vec2_t(smooth_x_size_spec, spec_s_y), color_t(5, 5, 5,clamp(math.floor(spec_fade * 255), 0, 230)))
            if ui_handler.refs["Visuals"]["windows_grad"].ref:get() then
                local start_c = color_t(colors.windows_grad1:get().r, colors.windows_grad1:get().g, colors.windows_grad1:get().b,clamp(math.floor(spec_fade * 255), 0, 240))
                local end_c = color_t(colors.windows_grad2:get().r, colors.windows_grad2:get().g, colors.windows_grad2:get().b,clamp(math.floor(spec_fade * 255), 0, 240))
                render.rect_fade(vec2_t(specx, specy-1),vec2_t(smooth_x_size_spec, 1),end_c,start_c, true)
            else
                render.rect(vec2_t(specx, specy-1),vec2_t(smooth_x_size_spec, 1),color_t(specs_color.r, specs_color.g, specs_color.b,clamp(math.floor(spec_fade * 255), 0, 240)))
            end
        elseif ui_handler.refs["Visuals"]["window_style"].ref:get() == 3 then
            render.rect_filled(vec2_t(specx, specy),vec2_t(smooth_x_size_spec, spec_s_y), color_t(5, 5, 5,clamp(math.floor(spec_fade * 255), 0, 230)),5)
            render.rect_half_round(vec2_t.new(specx-1, specy-2), vec2_t.new(smooth_x_size_spec+3, spec_s_y*1.37),color_t(specs_color.r, specs_color.g, specs_color.b,clamp(math.floor(spec_fade * 255), 0, 240)), 1, 8)
        end 
        render_text(fonts.verdana, "Spectators", vec2_t(specx + smooth_x_size_spec / 2, specy + spec_s_y / 2), color_t(255, 255, 255, clamp(math.floor(spec_fade * 255), 0, 255)), true)
    end

    if engine.is_in_game() == true then

        local players = entity_list.get_players()

        for i = 1, #players do
            if is_spectating(players[i]) == true then
                if render.get_text_size(fonts.verdana_s,tostring(players[i]:get_name())).x + 20 > spec_s_x then
                    spec_s_x = render.get_text_size(fonts.verdana_s,tostring(players[i]:get_name())).x + 15
                end
            end
        end

        for i = 1, #players do
            if engine.is_in_game() == true then
                if menu.is_open() == true or is_spectating(players[i]) == true then
                    spec_fade_value = 1
                    if is_spectating(players[i]) == true then
                        other_sp_offset = other_sp_offset + math.floor(spec_s_y - 5)
                    end
                end
            end
        end
        for i = 1, #players do
            if engine.is_in_game() == true then
                if menu.is_open() == true or is_spectating(players[i]) ==
                    true then
                    spec_fade_value = 1
                    if is_spectating(players[i]) == true then
                        render_text(fonts.verdana_s,tostring(players[i]:get_name()),vec2_t(specx + 3,specy + spec_s_y + sp_offset),color_t(255, 255, 255, clamp( math.floor(spec_fade * 255),0, 255)))
                        sp_offset = sp_offset + math.floor(11)
                    end
                end
            end
        end
    end

    if menu.is_open() == true then
        spec_fade = 1
    else
        spec_fade = lerp(spec_fade, spec_fade_value, 20 * clamp(global_vars.frame_time(), 0.001, 0.008))
    end
    
    smooth_x_size_spec = round(lerp(smooth_x_size_spec, spec_s_x, 20 * clamp(global_vars.frame_time(), 0.001, 0.008)), 3)

    spec_drag(specx, specy, smooth_x_size_spec, spec_s_y, input.get_mouse_pos())
end

local smooth_x_size_water = 0

local water_func = function(localplayer, menu_vis, in_game, frametime) 
    local ping_val = in_game and clamp(math.floor(engine.get_latency(e_latency_flows) *1000) - 8, 0, 999) or 0
    local kills = in_game and player_resource.get_prop("m_iKills", engine.get_local_player_index()) or 0
    local deaths = in_game and player_resource.get_prop("m_iDeaths", engine.get_local_player_index()) or 0
    local kdr = deaths > 0 and kills/deaths or kills
    local good_kdr = string.format("%.2f", clamp(kdr,0,999))

    local version_text = ui_handler.refs["Visuals"]["watermark_options"].ref:get(2) and lua_version or ""
    local name_text = ui_handler.refs["Visuals"]["watermark_options"].ref:get(1) and "Primordial" or "Ouija.LUA " .. alpha_v_text .. " " .. version_text
    local user_text_name = ui_handler.refs["Visuals"]["watermark_options"].ref:get(3) and forumInfo.name or ""
    local user_text_uid = ui_handler.refs["Visuals"]["watermark_options"].ref:get(3) and ui_handler.refs["Visuals"]["watermark_options"].ref:get(4) and " [" .. forumInfo.uid .. "]" or "" 
    local user_text = user_text_name .. user_text_uid
    local kdr_text = ui_handler.refs["Visuals"]["watermark_options"].ref:get(5) and "KDR: " .. good_kdr or ""
    local ping_text = ui_handler.refs["Visuals"]["watermark_options"].ref:get(6) and tostring(ping_val) .. "ms" or ""
    local fps_text = ui_handler.refs["Visuals"]["watermark_options"].ref:get(7) and math.floor(1 / frametime).. " FPS" or ""

    local fps_fake = ui_handler.refs["Visuals"]["watermark_options"].ref:get(7) and "000 FPS" or ""
    
    local watermark_text = {}
    
    watermark_text[#watermark_text + 1] = name_text
    watermark_text[#watermark_text + 1] = user_text 
    watermark_text[#watermark_text + 1] = kdr_text 
    watermark_text[#watermark_text + 1] = ping_text
    watermark_text[#watermark_text + 1] = fps_fake

    local full_watermk_text

    for i = 1, #watermark_text do
        if watermark_text[i] == "" then
            goto skip
        end
        if i == 1 then
            full_watermk_text = watermark_text[i]
        else
            full_watermk_text = full_watermk_text .. " | " .. watermark_text[i]
        end
        ::skip::
    end

    local full_watermk_size = render.get_text_size(fonts.verdana, full_watermk_text)

    watermark_text[5] = fps_text

    for i = 1, #watermark_text do
        if watermark_text[i] == "" then
            goto skip
        end
        if i == 1 then
            full_watermk_text = watermark_text[i]
        else
            full_watermk_text = full_watermk_text .. " | " .. watermark_text[i]
        end
        ::skip::
    end

    local water_s_x = full_watermk_size.x
    local water_s_y = dpi + 5

    local function water_drag(pos_x, pos_y, size_x, size_y, mouse_pos) -- spectators -------------------------------
        if mouse_pos.x >= pos_x and mouse_pos.x <= pos_x + size_x and mouse_pos.y >= pos_y and mouse_pos.y <= pos_y + size_y then
            if input.is_key_held(e_keys.MOUSE_LEFT) and drg_binds == 0 and drg_spec == 0 and drg_water == 0 and drg_xhair == 0 then
                drg_water = 1
                memory_water.x = pos_x - mouse_pos.x
                memory_water.y = pos_y - mouse_pos.y
            end
        end

        if not input.is_key_held(e_keys.MOUSE_LEFT) then drg_water = 0 end

        if drg_water == 1 and menu_vis then
            ui_handler.refs["Visuals"]["water_x"].ref:set(math.floor(mouse_pos.x +memory_water.x))
            ui_handler.refs["Visuals"]["water_y"].ref:set(math.floor(mouse_pos.y +memory_water.y))
        end

        if ui_handler.refs["Visuals"]["water_x"].ref:get() + size_x-3 > screen_size.x then
            ui_handler.refs["Visuals"]["water_x"].ref:set(math.floor(screen_size.x - size_x-3))
        end
        if ui_handler.refs["Visuals"]["water_x"].ref:get() < 6 then
            ui_handler.refs["Visuals"]["water_x"].ref:set(6)
        end

        if ui_handler.refs["Visuals"]["water_y"].ref:get() + size_y > screen_size.y then
            ui_handler.refs["Visuals"]["water_y"].ref:set(math.floor(screen_size.y - size_y))
        end
        if ui_handler.refs["Visuals"]["water_y"].ref:get() < 0 then
            ui_handler.refs["Visuals"]["water_y"].ref:set(0)
        end
    end

    local waterx = ui_handler.refs["Visuals"]["water_x"].ref:get()
    local watery = ui_handler.refs["Visuals"]["water_y"].ref:get()

    local windows_color = colors.main[2]:get()

    smooth_x_size_water = water_s_x + 4

    if ui_handler.refs["Visuals"]["window_style"].ref:get() == 1 then
        render.rect_filled(vec2_t(waterx, watery), vec2_t(smooth_x_size_water, water_s_y), color_t(5, 5, 5, 240),5)
        render.rect(vec2_t(waterx, watery), vec2_t(smooth_x_size_water, water_s_y), color_t(windows_color.r, windows_color.g, windows_color.b, 240), 5)
        render.rect(vec2_t(waterx - 0.5, watery - 0.5),vec2_t(smooth_x_size_water + 1, water_s_y + 1), color_t(windows_color.r, windows_color.g, windows_color.b, 120), 5)
    elseif ui_handler.refs["Visuals"]["window_style"].ref:get() == 2 then
        render.rect_filled(vec2_t(waterx, watery),vec2_t(smooth_x_size_water, water_s_y), color_t(5, 5, 5,240))
        if ui_handler.refs["Visuals"]["windows_grad"].ref:get() then
            local start_c = color_t(colors.windows_grad1:get().r, colors.windows_grad1:get().g, colors.windows_grad1:get().b,240)
            local end_c = color_t(colors.windows_grad2:get().r, colors.windows_grad2:get().g, colors.windows_grad2:get().b,240)
            render.rect_fade(vec2_t(waterx, watery-1),vec2_t(smooth_x_size_water, 1),end_c,start_c, true)
        else
            render.rect(vec2_t(waterx, watery-1),vec2_t(smooth_x_size_water, 1),color_t(windows_color.r, windows_color.g, windows_color.b,240))
        end
    elseif ui_handler.refs["Visuals"]["window_style"].ref:get() == 3 then
        render.rect_filled(vec2_t(waterx, watery),vec2_t(smooth_x_size_water, water_s_y), color_t(5, 5, 5,230),5)
        render.rect_half_round(vec2_t.new(waterx-1, watery-1), vec2_t.new(smooth_x_size_water+3, water_s_y*1.37),color_t(windows_color.r, windows_color.g, windows_color.b,240), 1, 8)
    end 

    render_text(fonts.verdana, full_watermk_text , vec2_t(waterx+2,watery+2), colors.white)

    water_drag(waterx, watery, water_s_x, water_s_y, input.get_mouse_pos())
end

local smooth_scale = 0
local scale = 0
local done = false
local lp_origin = vec3_t(0,0,0)
local autopeek = function(localplayer, frametime)
    if not localplayer or localplayer == nil then return end
    if not localplayer:is_alive() then return end

    smooth_scale = lerp(smooth_scale, scale, 12 * frametime)

    if prim_ref.autopeek:get() then

        scale = 12
        if not done then
            lp_origin = localplayer:get_render_origin()
            done = true
        end

        if done then
            local screen_pos = render.world_to_screen(lp_origin)
            if screen_pos == nil then return end

            local last_edge
            local last_edge2
            local last_edge3
            local last_edge4
            
            for angle_deg = 0, 360, 72 do -- draw star
                local offset_vector = angle_t(0, angle_deg +((global_vars.tick_count() %64) / 64) * 72, 0):to_vector():scaled(smooth_scale)
                local offset_vector2 = angle_t(0, angle_deg +((global_vars.tick_count() %64) / 64) * 72 - 72 * 2,0):to_vector():scaled(smooth_scale - 0.2) 
                offset_vector.z = 0
                local screen_pos_edge = render.world_to_screen(lp_origin +offset_vector)
                local screen_pos_edge2 = render.world_to_screen(lp_origin + offset_vector2)
                if screen_pos_edge ~= nil then
                    if last_edge ~= nil then
                        render.line(last_edge, screen_pos_edge, colors.autopeek:get())
                    end
                    last_edge = screen_pos_edge
                    if screen_pos_edge2 ~= nil then
                        render.line(last_edge, screen_pos_edge2, colors.autopeek:get())
                    end
                end
            end
            
            for angle_deg = 0, 360, 10 do
                local offset_vector = angle_t(0, angle_deg +(0) * 72 - 72 * 2,0):to_vector():scaled(smooth_scale-2)
                local offset_vector2 = angle_t(0, angle_deg +(0) * 72 - 72 * 2,0):to_vector():scaled(smooth_scale)

                local screen_pos_edge2 = render.world_to_screen(lp_origin + offset_vector2)

                if screen_pos_edge2 ~= nil then
                    
                    if last_edge2 ~= nil then
                        render.line(last_edge2, screen_pos_edge2, colors.autopeek:get())
                    end
                    
                end
                    last_edge2 = screen_pos_edge2
            end
        end
    else
        smooth_scale = 0
        done = false
    end
end

local fish_esp = function()
    local cur_ent = "fish"
    local screen_pos = {}
    local screen_pos2 = {}
    local ent = entity_list.get_entities_by_name("CFish")
    if #ent == 0 then ent = entity_list.get_entities_by_name("CChicken") cur_ent = "chicken" end
    for i=1, #ent do
        local ent_pos = vec3_t(ent[i]:get_prop("m_x"), ent[i]:get_prop("m_y"), ent[i]:get_prop("m_z"))
        local ent_angle = ent[i]:get_prop("m_angle")
        screen_pos[i] = cur_ent == "fish" and render.world_to_screen(ent_pos) or render.world_to_screen(ent[i]:get_prop("m_vecOrigin"))
        screen_pos2[i] = {ent_pos, ent_angle}
        if screen_pos == nil then return end
        if screen_pos2 == nil then return end
    end
    for i=1, #screen_pos do
        if screen_pos[i] == nil then return end
        render.rect(vec2_t(screen_pos[i].x-7, screen_pos[i].y-10), vec2_t(14,24), color_t(255, 255, 255, 225))
        render.rect(vec2_t(screen_pos[i].x-9, screen_pos[i].y-10), vec2_t(1, 24), color_t(150, 255, 150, 255))
        render_text(fonts.fish, "le " .. cur_ent, vec2_t(screen_pos[i].x, screen_pos[i].y-15), color_t(255, 255, 255, 255),true)
    end
    for i=1, #screen_pos2 do
        if screen_pos2[i][1] == nil or screen_pos2[i][2] == nil then else
            render.line(render.world_to_screen(screen_pos2[i][1]), render.world_to_screen(vec3_t(screen_pos2[i][1].x+coordinate_transform(screen_pos2[i][2],-8).x_coord,screen_pos2[i][1].y+coordinate_transform(screen_pos2[i][2],-8).y_coord,screen_pos2[i][1].z)), colors.white)
            render.line(render.world_to_screen(vec3_t(screen_pos2[i][1].x+coordinate_transform(screen_pos2[i][2],-3).x_coord,screen_pos2[i][1].y+coordinate_transform(screen_pos2[i][2],-3).y_coord,screen_pos2[i][1].z)), render.world_to_screen(vec3_t(screen_pos2[i][1].x+coordinate_transform(screen_pos2[i][2],-4).x_coord,screen_pos2[i][1].y+coordinate_transform(screen_pos2[i][2],-4).y_coord,screen_pos2[i][1].z+2)), colors.white)
            render.line(render.world_to_screen(vec3_t(screen_pos2[i][1].x+coordinate_transform(screen_pos2[i][2],-1.5).x_coord,screen_pos2[i][1].y+coordinate_transform(screen_pos2[i][2],-2).y_coord,screen_pos2[i][1].z)), render.world_to_screen(vec3_t(screen_pos2[i][1].x+coordinate_transform(screen_pos2[i][2],-3).x_coord,screen_pos2[i][1].y+coordinate_transform(screen_pos2[i][2],-3).y_coord,screen_pos2[i][1].z+1.5)), colors.white)
            render.line(render.world_to_screen(vec3_t(screen_pos2[i][1].x+coordinate_transform(screen_pos2[i][2],-8).x_coord,screen_pos2[i][1].y+coordinate_transform(screen_pos2[i][2],-8).y_coord,screen_pos2[i][1].z)), render.world_to_screen(vec3_t(screen_pos2[i][1].x+coordinate_transform(screen_pos2[i][2],-10).x_coord,screen_pos2[i][1].y+coordinate_transform(screen_pos2[i][2],-10).y_coord,screen_pos2[i][1].z+2)), colors.white)
            render.line(render.world_to_screen(vec3_t(screen_pos2[i][1].x+coordinate_transform(screen_pos2[i][2],-8).x_coord,screen_pos2[i][1].y+coordinate_transform(screen_pos2[i][2],-8).y_coord,screen_pos2[i][1].z)), render.world_to_screen(vec3_t(screen_pos2[i][1].x+coordinate_transform(screen_pos2[i][2],-10).x_coord,screen_pos2[i][1].y+coordinate_transform(screen_pos2[i][2],-10).y_coord,screen_pos2[i][1].z-2)), colors.white)
        end
    end
end

local on_world_hitmarker = function(screen_pos, world_pos, alpha_factor, damage,is_lethal, is_headshot)
    local localplayer = entity_list.get_local_player()
    render.push_alpha_modifier(alpha_factor)
    render.line(vec2_t(screen_pos.x + 5, screen_pos.y),vec2_t(screen_pos.x - 5, screen_pos.y),colors.hitmarker:get())
    render.line(vec2_t(screen_pos.x, screen_pos.y + 5),vec2_t(screen_pos.x, screen_pos.y - 5),colors.hitmarker:get())
    return true
end

anti_brute.brute_add = function(euid)
    if g_cont_time < global_vars.tick_count() and gothit == false then
        anti_brute_logs[#anti_brute_logs + 1] = {
            global_vars.tick_count() + 160, euid
        }
        total_brute = total_brute + 1 
        if ui_handler.refs["Visuals"]["notifications"].ref:get() then
            if ui_handler.refs["Visuals"]["notifications_console"].ref:get(3) then
                client.log(colors.white, "[", colors.aa_info_color:get(), "Ouija.lua", colors.white, "]", colors.white, "Anti Aim switched due to brute force")
            end
            if #anti_brute_logs > 5 then return end
            if ui_handler.refs["Visuals"]["notifications_screen"].ref:get(3) then
                add_notification("ab", "Switched due to anti brute")
            end
        end
        gothit = false
        brute_able = false
        g_cont_time = 0
    end
end

local notifications = function(localplayer, tickcount, in_game)
    if #anti_brute_logs > 0 and tickcount >= anti_brute_logs[1][1] then table.remove(anti_brute_logs,1) end
    if not in_game and #notification_logs > 0 then
        repeat table.remove(notification_logs, 1) until #notification_logs == 0
    end
 
    local notif_color = colors.main[2]:get()
    local pre_pre_text_data = static_sizes.pre_pre_text_data
    local pre_text_data = static_sizes.pre_text_data
    if #notification_logs > 0 then
        if #notification_logs > 12 then
            table.remove(notification_logs, 1)
        end
        if tickcount >= notification_logs[1][6] + 5 then
            table.remove(notification_logs, 1)
        end

        for i = 1, #notification_logs do
            if notification_logs[i][4] == "Ragebot Hit | " then
                notif_color = colors.hit_color:get()
            end
            if notification_logs[i][4] == "Ragebot Miss | " then
                notif_color = colors.miss_color:get()
            end
            if notification_logs[i][4] == "Anti Brute | " then
                notif_color = colors.aa_info_color:get()
            end
            local size = render.get_text_size(fonts.verdana_s, notification_logs[i][1] .. notification_logs[i][2] .. notification_logs[i][3] .. " " .. notification_logs[i][4] .. notification_logs[i][5])

            render.rect_filled(vec2_t((screen_size.x/2 - math.floor(clamp(((notification_logs[i][6]- tickcount)/15), 0, 1)*size.x)/2)-4, (screen_size.y - 120 - i * (14 * 1.5))-2), vec2_t((math.floor(clamp(((notification_logs[i][6]- tickcount)/20), 0, 1)*size.x))+8, size.y +4), color_t(5,5,5,math.floor(clamp(((notification_logs[i][6]- tickcount)/40), 0, 1)*230)),(dpi/2)+1)
            render.rect(vec2_t((screen_size.x/2 - math.floor(clamp(((notification_logs[i][6]- tickcount)/15), 0, 1)*size.x)/2)-4, (screen_size.y - 120 - i * (14 * 1.5))-2), vec2_t((math.floor(clamp(((notification_logs[i][6]- tickcount)/20), 0, 1)*size.x))+8, size.y +4), color_t(notif_color.r, notif_color.g, notif_color.b,math.floor(clamp(((notification_logs[i][6]- tickcount)/15), 0, 1)*255)),(dpi/2)+1)
            render.rect(vec2_t((screen_size.x/2 - math.floor(clamp(((notification_logs[i][6]- tickcount)/15), 0, 1)*size.x)/2)-4, (screen_size.y - 120 - i * (14 * 1.5))-3), vec2_t((math.floor(clamp(((notification_logs[i][6]- tickcount)/20), 0, 1)*size.x))+8, size.y +6), color_t(notif_color.r, notif_color.g, notif_color.b,math.floor(clamp(((notification_logs[i][6]- tickcount)/15), 0, 1)*255)),(dpi/2)+1)
            
            render_text(fonts.verdana_s, tostring(notification_logs[i][1]),
                        vec2_t(((screen_size.x / 2) -(size.x) / 2), screen_size.y - 120 - i * (14 * 1.5)),
                        color_t(255, 255, 255, math.floor(clamp(((notification_logs[i][6]- tickcount)/50), 0, 1)*255)))

            render_text(fonts.verdana_s, tostring(notification_logs[i][2]),
                        vec2_t(((screen_size.x / 2) + pre_pre_text_data.x - (size.x) / 2), screen_size.y - 120 - i * (14 * 1.5)),
                        color_t(notif_color.r, notif_color.g, notif_color.b,math.floor(clamp(((notification_logs[i][6]- tickcount)/50), 0, 1)*255)))

            render_text(fonts.verdana_s, tostring(notification_logs[i][3] .. " " .. notification_logs[i][4] .. notification_logs[i][5]),
                        vec2_t(((screen_size.x / 2) + pre_pre_text_data.x + pre_text_data.x - (size.x) / 2), screen_size.y - 120 - i * (14 * 1.5)),
                        color_t(255, 255, 255, math.floor(clamp(((notification_logs[i][6]- tickcount)/50), 0, 1)*255)))
        end
    end
end

local ascii_art = {       
" ",                                                                                             
"      OOOOOOOOO                         iiii   jjjj                           LLLLLLLLLLL                                                 ",
"    OO:::::::::OO                      i::::i j::::j                          L:::::::::L                                                 ",
"  OO:::::::::::::OO                     iiii   jjjj                           L:::::::::L                                                 ",
" O:::::::OOO:::::::O                                                          LL:::::::LL                                                 ",
" O::::::O   O::::::Ouuuuuu    uuuuuu  iiiiiiijjjjjjj  aaaaaaaaaaaaa             L:::::L               uuuuuu    uuuuuu    aaaaaaaaaaaaa   ",
" O:::::O     O:::::Ou::::u    u::::u  i:::::ij:::::j  a::::::::::::a            L:::::L               u::::u    u::::u    a::::::::::::a  ",
" O:::::O     O:::::Ou::::u    u::::u   i::::i j::::j  aaaaaaaaa:::::a           L:::::L               u::::u    u::::u    aaaaaaaaa:::::a ",
" O:::::O     O:::::Ou::::u    u::::u   i::::i j::::j           a::::a           L:::::L               u::::u    u::::u             a::::a ",
" O:::::O     O:::::Ou::::u    u::::u   i::::i j::::j    aaaaaaa:::::a           L:::::L               u::::u    u::::u      aaaaaaa:::::a ",
" O:::::O     O:::::Ou::::u    u::::u   i::::i j::::j  aa::::::::::::a           L:::::L               u::::u    u::::u    aa::::::::::::a ",
" O:::::O     O:::::Ou::::u    u::::u   i::::i j::::j a::::aaaa::::::a           L:::::L               u::::u    u::::u   a::::aaaa::::::a ",
" O::::::O   O::::::Ou:::::uuuu:::::u   i::::i j::::ja::::a    a:::::a           L:::::L         LLLLLLu:::::uuuu:::::u  a::::a    a:::::a ",
" O:::::::OOO:::::::Ou:::::::::::::::uui::::::ij::::ja::::a    a:::::a         LL:::::::LLLLLLLLL:::::Lu:::::::::::::::uua::::a    a:::::a ",
"  OO:::::::::::::OO  u:::::::::::::::ui::::::ij::::ja:::::aaaa::::::a  ...... L::::::::::::::::::::::L u:::::::::::::::ua:::::aaaa::::::a ",
"    OO:::::::::OO     uu::::::::uu:::ui::::::ij::::j a::::::::::aa:::a .::::. L::::::::::::::::::::::L  uu::::::::uu:::u a::::::::::aa:::a",
"      OOOOOOOOO         uuuuuuuu  uuuuiiiiiiiij::::j  aaaaaaaaaa  aaaa ...... LLLLLLLLLLLLLLLLLLLLLLLL    uuuuuuuu  uuuu  aaaaaaaaaa  aaaa",
"                                              j::::j                                                                                      ",
"                                    jjjj      j::::j                                                                                      ",
"                                   j::::jj   j:::::j                                                                                      ",
"                                   j::::::jjj::::::j                                                                                      ",
"                                    jj::::::::::::j                                                                                       ",
"                                      jjj::::::jjj                                                                                        ",
"                                         jjjjjj                                                                                           ",
" "
}

local ascii_alpha = {                                                                                                                                                                                                      
"               AAA               LLLLLLLLLLL             PPPPPPPPPPPPPPPPP   HHHHHHHHH     HHHHHHHHH               AAA               ",
"              A:::A              L:::::::::L             P::::::::::::::::P  H:::::::H     H:::::::H              A:::A              ",
"             A:::::A             L:::::::::L             P::::::PPPPPP:::::P H:::::::H     H:::::::H             A:::::A             ",
"            A:::::::A            LL:::::::LL             PP:::::P     P:::::PHH::::::H     H::::::HH            A:::::::A            ",
"           A:::::::::A             L:::::L                 P::::P     P:::::P  H:::::H     H:::::H             A:::::::::A           ",
"          A:::::A:::::A            L:::::L                 P::::P     P:::::P  H:::::H     H:::::H            A:::::A:::::A          ",
"         A:::::A A:::::A           L:::::L                 P::::PPPPPP:::::P   H::::::HHHHH::::::H           A:::::A A:::::A         ",
"        A:::::A   A:::::A          L:::::L                 P:::::::::::::PP    H:::::::::::::::::H          A:::::A   A:::::A        ",
"       A:::::A     A:::::A         L:::::L                 P::::PPPPPPPPP      H:::::::::::::::::H         A:::::A     A:::::A       ",
"      A:::::AAAAAAAAA:::::A        L:::::L                 P::::P              H::::::HHHHH::::::H        A:::::AAAAAAAAA:::::A      ",
"     A:::::::::::::::::::::A       L:::::L                 P::::P              H:::::H     H:::::H       A:::::::::::::::::::::A     ",
"    A:::::AAAAAAAAAAAAA:::::A      L:::::L         LLLLLL  P::::P              H:::::H     H:::::H      A:::::AAAAAAAAAAAAA:::::A    ",
"   A:::::A             A:::::A   LL:::::::LLLLLLLLL:::::LPP::::::PP          HH::::::H     H::::::HH   A:::::A             A:::::A   ",
"  A:::::A               A:::::A  L::::::::::::::::::::::LP::::::::P          H:::::::H     H:::::::H  A:::::A               A:::::A  ",
" A:::::A                 A:::::A L::::::::::::::::::::::LP::::::::P          H:::::::H     H:::::::H A:::::A                 A:::::A ",
"AAAAAAA                   AAAAAAALLLLLLLLLLLLLLLLLLLLLLLLPPPPPPPPPP          HHHHHHHHH     HHHHHHHHHAAAAAAA                   AAAAAAA",
" "    
}

local ascii_color = color_t(255, 255, 255, 255)
for i = 1, #ascii_art do
    client.log(ascii_color, ascii_art[i])
    ascii_color.g = ascii_color.g - 8
    ascii_color.b = ascii_color.b - 8
end
if alpha_v then
    ascii_color.g = 150
    ascii_color.b = 150
    for i = 1, #ascii_alpha do 
        client.log(ascii_color, ascii_alpha[i])
        ascii_color.g = ascii_color.g - 5
        ascii_color.b = ascii_color.b - 5
    end
end
add_notification("", "Welcome to Ouija.Lua" .. alpha_v_text .. " ".. forumInfo.name .. ". The current script version is " .. lua_version)

callbacks.add(e_callbacks.ANTIAIM, function(ctx)
    local localplayer = entity_list.get_local_player()
    if not engine.is_in_game() then return end
    if localplayer == nil then return end
    if not localplayer then return end

    pitch_zero(ctx)
    anti_aim_fun(ctx, localplayer)

    if ui_handler.refs["Anti Aim"]["anti_knife"].ref:get() then
        anti_knife(ctx, localplayer)
    end
    
    if ui_handler.refs["Anti Aim"]["fl_options"].ref:get() then
        fake_lag(ctx, localplayer)
    end

end)


callbacks.add(e_callbacks.PAINT, function() 
    local menu_vis = menu.is_open()
    local localplayer = entity_list.get_local_player()
    local view_angles = engine.get_view_angles()
    local frametime = global_vars.frame_time()
    local tickcount = global_vars.tick_count()
    local in_game = engine.is_in_game()

    if menu_vis then

        -- colors.main = menu.find("Misc", "Main", "Personalization", "Accent Color")
        -- print("color 2924")
        if dpi ~= ui_handler.refs["Misc"]["dpi"].ref:get() then 
            dpi = ui_handler.refs["Misc"]["dpi"].ref:get()
            fonts.refresh(dpi)
        end
        -- ui_handler setvisible
        ui_handler.current_tab = ui_handler.tab_list[ui_handler.combo_controller:get()]
        menu.set_group_visibility("Configs",  ui_handler.current_tab == "Misc") 
        for k, v in pairs(ui_handler.refs) do
            for j, l in pairs(v) do
                ui_handler.refs[k][j].ref:set_visible(l.condition()) 
            end
        end
    end
    if ui_handler.refs["Visuals"]["window_select"].ref:get(1) then
        binds_func(localplayer,menu_vis)
    end
    if ui_handler.refs["Visuals"]["window_select"].ref:get(2) then
        spec_func(localplayer,menu_vis)
    end
    if ui_handler.refs["Visuals"]["window_select"].ref:get(3) then
        water_func(localplayer,menu_vis,in_game,frametime)
    end
    notifications(localplayer, tickcount, in_game)
    if not engine.is_in_game() then return end
    if localplayer == nil or not localplayer:is_valid() then return end
    if not localplayer:is_alive() then return end
    if ui_handler.refs["Visuals"]["undercrosshair"].ref:get() then
        undercrosshair(localplayer, view_angles, frametime, menu_vis)
    end
    if ui_handler.refs["Visuals"]["fish_esp"].ref:get() then
        fish_esp()
    end
    if ui_handler.refs["Visuals"]["autopeek"].ref:get() then
        autopeek(localplayer, frametime)
    end
    if ui_handler.refs["Visuals"]["dmg_indicator"].ref:get() > 1 then
        dmg_ind(localplayer)
    end
    if ui_handler.refs["Visuals"]["arrows"].ref:get() > 1 then
        arrows_func(localplayer, view_angles)
    end
    if ui_handler.refs["Visuals"]["brute_vis"].ref:get() then
        if anti_brute.visuals.point ~= nil and anti_brute.visuals.point_p ~= nil then
            local screen_point = render.world_to_screen(anti_brute.visuals.point)
            local screen_point_p = render.world_to_screen(anti_brute.visuals.point_p)
            local sc = colors.snaplines:get() 
            if screen_point ~= nil and screen_point_p ~= nil then
                render.line(screen_point,screen_point_p, color_t(sc.r,sc.g,sc.b,math.floor(anti_brute.visuals.point_time - global_vars.tick_count())))
                if math.floor(anti_brute.visuals.point_time - global_vars.tick_count()) <= 5 then
                    anti_brute.visuals.point = nil
                    anti_brute.visuals.point_p = nil
                end
            end
        end
    end
    if ui_handler.refs["Ragebot"]["enable_rage"].ref:get() then
        local cur_weapon = rage_handle:get_weap(localplayer) 
        render_text(fonts.pix, "ragebot >", vec2_t(50, screen_size.y/2), color_t(255,255,255,255))
    end
end)


callbacks.add(e_callbacks.EVENT, function(event)
    if event == nil then return end
    events_fun(event) 
end)

callbacks.add(e_callbacks.NET_UPDATE, function()
    if engine.is_in_game() then
        if ui_handler.refs["Misc"]["clantag"].ref:get() then
            clantag_fuc()
            clantag_active = true
        else
            if clantag_active then
                set_clantag("")
                clantag_active = false
            end
        end
    else

    end
end)

callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
    local localplayer = entity_list.get_local_player()
    if not localplayer or localplayer == nil then return end
    if not localplayer:is_alive() then return end   
    local view_angles = engine.get_view_angles()
    if ui_handler.refs["Ragebot"]["in_air_autostop"].ref:get() then
        autostop:main(cmd,localplayer)
    end
end)

callbacks.add(e_callbacks.WORLD_HITMARKER,function(screen_pos, world_pos, alpha_factor, damage, is_lethal,is_headshot)
    if ui_handler.refs["Visuals"]["hitmarker"].ref:get() then
        on_world_hitmarker(screen_pos, world_pos, alpha_factor, damage, is_lethal, is_headshot)
    end
end)
if ouija_fs.directory_exists("/ouija") then -- returns true if the directory exists and false if it doesn't
    if ouija_fs.exists("ouija\\load.txt") then
        client.log_screen(colors.white,"Ouija.lua", colors.main[2]:get(), "[Configs]", colors.white, "Local config found, loading...")
        local cfg_string = ouija_fs.read("ouija\\load.txt")
        configs.load(cfg_string)
    end
else
    ouija_fs.create_directory("/ouija") -- creates the directory if it doesn't exist
end
menu.add_button("Configs", "Save local config", function()
    local config_code = configs.make()
    ouija_fs.write("ouija\\load.txt", config_code) 
    client.log_screen(colors.white,"Ouija.lua", colors.main[2]:get(), "[Configs]", colors.white, "Local config saved!")
end)
menu.add_button("Configs", "Reload local config", function()
    local cfg_string = ouija_fs.read("ouija\\load.txt") 
    configs.load(cfg_string)
end)
menu.add_separator("Configs")
menu.add_button("Configs", "Export config to clipboard", function()
    local config_code = configs.make()
    clipboard_export(config_code)
    client.log_screen(colors.white,"Ouija.lua", colors.main[2]:get(), "[Configs]", colors.white, "Config code exported to clipboard")
end)
menu.add_button("Configs", "Load Config from clipboard", function()
    local clipboard = clipboard_import()
    if clipboard == "" then
        print("Error: No config found in clipboard")
    return end
    configs.load(clipboard)
end)

callbacks.add(e_callbacks.SHUTDOWN, function() 
    set_clantag("") 
end)

-- SECURITY_EXCEPTION_END()