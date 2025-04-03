local base64 = require("primordial/base64.371")

local vtable = {}
function vtable.bind(module, interface, index, typestring)
    local iface = memory.create_interface(module, interface) or error(interface .. ": invalid interface")
    local instance = memory.get_vfunc(iface, index) or error(index .. ": invalid index")
    local success, typeof = pcall(ffi.typeof, typestring)

    if (not success) then
        error(typeof, 2)
    end

    local fnptr = ffi.cast(typeof, instance) or error(typestring .. ": invalid typecast")

    return function(...)
        return fnptr(tonumber(ffi.cast("void***", iface)), ...)
    end
-- end

function split (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

local clipboard = {}

clipboard.get_clipboard_text_count = vtable.bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
clipboard.set_clipboard_text = vtable.bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)")
clipboard.get_clipboard_text = vtable.bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")

function clipboard.import()
    local len = clipboard.get_clipboard_text_count()

    if (len > 0) then
        local char_arr = ffi.typeof("char[?]")(len)
        clipboard.get_clipboard_text(0, char_arr, len)

        return ffi.string(char_arr, len - 1)
    end
end

function clipboard.export(text)
    text = tostring(text)

    clipboard.set_clipboard_text(text, text:len())
end


local config_data = ""
















local function on_draw_watermark(watermark_text)
    return
end

callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)

local menu_items = {
    smart_options = menu.add_multi_selection("Anti-aim","Smart options",{"refigure antiaim","anti bruteforce","disable autobuy on pistol rounds", "scout fast recharge"}),
    animbreaker = menu.add_multi_selection("Anti-aim","Anim. breaker",{"dynamic legs","body lean"}),
    adjust_antiaim = menu.add_multi_selection("Anti-aim","Adjust antiaim on",{"manuals","freestand","warmup"}),
    refigure_random_1 = menu.add_slider("Refigure antiaims","[1] random values",-100, 100),
    refigure_random_2 = menu.add_slider("Refigure antiaims","[2] random values",-100, 100),
    antibruteforce_settings_time = menu.add_slider("Anti bruteforce","time",1, 20, 1, 0, "s"),
    configs = menu.add_selection("Anti-aim", "Preset", {"CUSTOM"}),
    preset = menu.add_selection("Anti-aim settings", "Condition", {"standing", "running", "slowwalk", "air", "crouch", "air crouch", "on Edge", "fakeduck"}),
    clantag_changer = menu.add_checkbox("Misc", "clantag", true),
    antiaim_settings = {}
}

menu.set_group_column("Misc", 2)
menu.set_group_column("Anti bruteforce", 2)
menu.set_group_column("Anti-aim settings", 1)
menu.set_group_column("Config system", 2)


local ui_refs = {
    pitch = menu.find("antiaim","main","angles","pitch"),
    yaw_add = menu.find("antiaim","main","angles","yaw add"),
    jitter_mode = menu.find("antiaim","main","angles","jitter mode"),
    jitter_type = menu.find("antiaim","main","angles","jitter type"),
    jitter_add = menu.find("antiaim","main","angles","jitter add"),

    side_stand = menu.find("antiaim", "main", "desync", "side#stand"),
    llimit_stand = menu.find("antiaim", "main", "desync", "left amount#stand"),
    rlimit_stand = menu.find("antiaim", "main", "desync", "right amount#stand"),

    override_move = menu.find("antiaim", "main", "desync", "override stand#move"),
    override_slowwalk = menu.find("antiaim", "main", "desync", "override stand#slow walk"),

    anti_bruteforce = menu.find("antiaim", "main", "desync", "anti bruteforce"),
    on_shot = menu.find("antiaim", "main", "desync", "on shot"),

    fakelag = menu.find("antiaim", "main", "fakelag", "amount"),
    fakelag_lc = menu.find("antiaim", "main", "fakelag", "break lag compensation"),

    autobuy = menu.find("misc", "utility", "buybot", "enable"),

    freestand = menu.find("antiaim", "main", "auto direction", "enable"),


}


local antiaims = {
    yaw_type = 3,
    yaw_left = 0,
    yaw_right = 0,
    modifier_type = 2,
    body_yaw = 0,
    fake_yaw_type = 2,
    static_desync = 0,
    desync_left = 0,
    desync_right = 0,
    data = 0,
    add_yaw_from_phase = 0,
    add_yaw_from_phase_desyncl = 0,
    add_yaw_from_phase_desyncr = 0,
    antibrute_distance = 0,
    pitchflick = 1,
    pitchflickspeed = 1,

    way3_add = 0,
    way3_add2 = 0,
    way3_add3 = 0,

}

local vars = {
    temp_vars = 0,
    temp_vars2 = 0,
    temp_time = 0,
    revs = 0,
    refigure = 0,
    i_state = {"Stand -", "Run -", "Slow -", "Air -", "Crouch -", "Air-C -", "Edge -", "Fakeduck -"},
    only_air_check = false,
    ground_tick = 1,
    end_time = 0,

    last_shot_tick = 0,
    in_recharge = false,
    shot = false,

    last_phase = 0,
}


for i = 1, 8 do
    menu_items.antiaim_settings[i] = {
        pitchflick =  menu.add_selection("Anti-aim settings", vars.i_state[i].." pitch flicker", {"Disable", "Enable"}),

        pitchflick_speed = menu.add_slider("Anti-aim settings", vars.i_state[i].." ticks", 1, 100, 1, 0, "t."),

        yaw_type = menu.add_selection("Anti-aim settings", vars.i_state[i].." Yaw type", {"NeverLose", "Default", "Mysolution", "3-Way Mysolution"}),

        _slider_3way = menu.add_slider("Anti-aim settings", vars.i_state[i].." 3-Way [1] ", -180, 180, 1, 0, "°"),
        _slider_3way2 = menu.add_slider("Anti-aim settings", vars.i_state[i].." 3-Way [2] ", -180, 180, 1, 0, "°"),
        _slider_3way3 = menu.add_slider("Anti-aim settings", vars.i_state[i].." 3-Way [3] ", -180, 180, 1, 0, "°"),

        slider_yaw_add_left = menu.add_slider("Anti-aim settings", vars.i_state[i].." left yaw add", -180, 180, 1, 0, "°"),
        slider_yaw_add_right = menu.add_slider("Anti-aim settings", vars.i_state[i].." right yaw add", -180, 180, 1, 0, "°"),

        modifier_type = menu.add_selection("Anti-aim settings", vars.i_state[i].." Modifier type", {"Disable", "Center"}),
        slider_body_yaw = menu.add_slider("Anti-aim settings", vars.i_state[i].." body degree", -180, 180, 1, 0, "°"),

        fake_yaw_type = menu.add_selection("Anti-aim settings", vars.i_state[i].." fake yaw type", {"jitter", "Left & Right"}),
        slider_static_desync = menu.add_slider("Anti-aim settings", vars.i_state[i].." fake yaw", 0, 60, 1, 0, "°"),
        slider_ldesync = menu.add_slider("Anti-aim settings", vars.i_state[i].." left fake yaw", 0, 60, 1, 0, "°"),
        slider_rdesync = menu.add_slider("Anti-aim settings", vars.i_state[i].." right fake yaw", 0, 60, 1, 0, "°"),

    }
    menu_items.antiaim_settings[i].yaw_type:set(3)
    menu_items.antiaim_settings[i].modifier_type:set(1)

end

local phase_pos = 1


local phases = {
    [1] = menu.add_slider("Anti bruteforce","phase 1",-90, 90, 1, 0, "°"),
    [2] = nil,
    [3] = nil,
    [4] = nil,
    [5] = nil,
    [6] = nil,
    [7] = nil,
    [8] = nil,
    [9] = nil,
}

local phases_desyncL = {
    [1] = menu.add_slider("Anti bruteforce","Desync_L 1",0, 60, 1, 0, "°"),
    [2] = nil,
    [3] = nil,
    [4] = nil,
    [5] = nil,
    [6] = nil,
    [7] = nil,
    [8] = nil,
    [9] = nil,
}

local phases_desyncR = {
    [1] = menu.add_slider("Anti bruteforce","Desync_R 1",0, 60, 1, 0, "°"),
    [2] = nil,
    [3] = nil,
    [4] = nil,
    [5] = nil,
    [6] = nil,
    [7] = nil,
    [8] = nil,
    [9] = nil,
}

local function add_phase_in_anti_bruteforce()
    if phase_pos >= 9 then return end

    phase_pos = phase_pos + 1

    if phase_pos > 1 then
        phases[phase_pos] = menu.add_slider("Anti bruteforce","phase "..phase_pos,-90, 90, 1, 0, "°")
        phases_desyncL[phase_pos] = menu.add_slider("Anti bruteforce","Desync_L "..phase_pos,0, 60, 1, 0, "°")
        phases_desyncR[phase_pos] = menu.add_slider("Anti bruteforce","Desync_R "..phase_pos,0, 60, 1, 0, "°")

    end

    a:set_visible(false)
    if b then 
        b:set_visible(false)
    end

    a = menu.add_button("Anti bruteforce", "add phase", function ()

        add_phase_in_anti_bruteforce()
    end)

    b = menu.add_button("Anti bruteforce", "remove phase", function ()
        if phase_pos <= 1 then return end

        if phase_pos > 1 then
            if phases[phase_pos] ~= nil then
                phases[phase_pos]:set_visible(false)
                phases[phase_pos]:set(0)
                phases[phase_pos] = nil
            end

            if phases_desyncL[phase_pos] ~= nil then
                phases_desyncL[phase_pos]:set_visible(false)
                phases_desyncL[phase_pos]:set(0)
                phases_desyncL[phase_pos] = nil
            end

            if phases_desyncR[phase_pos] ~= nil then
                phases_desyncR[phase_pos]:set_visible(false)
                phases_desyncR[phase_pos]:set(0)
                phases_desyncR[phase_pos] = nil
            end
        end
    
        phase_pos = phase_pos - 1
    
    end)
    
end

a = menu.add_button("Anti bruteforce", "add phase", function ()
    add_phase_in_anti_bruteforce()

end)

function apply_config(array)
    local bool = false
    if array[1] == "false" then bool = false elseif array[1] == "true" then bool = true end
    menu_items.smart_options:set(1, bool)
    if array[2] == "false" then bool = false elseif array[2] == "true" then bool = true end
    menu_items.smart_options:set(2, bool)
    if array[3] == "false" then bool = false elseif array[3] == "true" then bool = true end
    menu_items.smart_options:set(3, bool)
    if array[4] == "false" then bool = false elseif array[4] == "true" then bool = true end
    menu_items.smart_options:set(4, bool)


    if array[91] == "false" then bool = false elseif array[91] == "true" then bool = true end
    menu_items.adjust_antiaim:set(1, bool)
    if array[92] == "false" then bool = false elseif array[92] == "true" then bool = true end
    menu_items.adjust_antiaim:set(2, bool)
    if array[93] == "false" then bool = false elseif array[93] == "true" then bool = true end
    menu_items.adjust_antiaim:set(3, bool)

    if array[94] == "false" then bool = false elseif array[94] == "true" then bool = true end
    menu_items.clantag_changer:set(bool)






    menu_items.refigure_random_1:set(tonumber(array[5]))
    menu_items.refigure_random_2:set(tonumber(array[6]))
    menu_items.antibruteforce_settings_time:set(tonumber(array[7]))
    menu_items.configs:set(tonumber(array[8]))
    menu_items.preset:set(tonumber(array[9]))


    menu_items.antiaim_settings[1].yaw_type:set(tonumber(array[10]));                menu_items.antiaim_settings[2].yaw_type:set(tonumber(array[19]));              menu_items.antiaim_settings[3].yaw_type:set(tonumber(array[28]));              menu_items.antiaim_settings[4].yaw_type:set(tonumber(array[37]));             menu_items.antiaim_settings[5].yaw_type:set(tonumber(array[46]));                                  menu_items.antiaim_settings[6].yaw_type:set(tonumber(array[55]));                     menu_items.antiaim_settings[7].yaw_type:set(tonumber(array[64]));                    menu_items.antiaim_settings[8].yaw_type:set(tonumber(array[73]));
    menu_items.antiaim_settings[1].slider_yaw_add_left:set(tonumber(array[11]));     menu_items.antiaim_settings[2].slider_yaw_add_left:set(tonumber(array[20]));   menu_items.antiaim_settings[3].slider_yaw_add_left:set(tonumber(array[29]));  menu_items.antiaim_settings[4].slider_yaw_add_left:set(tonumber(array[38]));             menu_items.antiaim_settings[5].slider_yaw_add_left:set(tonumber(array[47]));       menu_items.antiaim_settings[6].slider_yaw_add_left:set(tonumber(array[56]));                     menu_items.antiaim_settings[7].slider_yaw_add_left:set(tonumber(array[65]));                    menu_items.antiaim_settings[8].slider_yaw_add_left:set(tonumber(array[74]));
    menu_items.antiaim_settings[1].slider_yaw_add_right:set(tonumber(array[12]));    menu_items.antiaim_settings[2].slider_yaw_add_right:set(tonumber(array[21]));  menu_items.antiaim_settings[3].slider_yaw_add_right:set(tonumber(array[30]));   menu_items.antiaim_settings[4].slider_yaw_add_right:set(tonumber(array[39]));             menu_items.antiaim_settings[5].slider_yaw_add_right:set(tonumber(array[48]));  menu_items.antiaim_settings[6].slider_yaw_add_right:set(tonumber(array[57]));                     menu_items.antiaim_settings[7].slider_yaw_add_right:set(tonumber(array[66]));                    menu_items.antiaim_settings[8].slider_yaw_add_right:set(tonumber(array[75]));
    menu_items.antiaim_settings[1].modifier_type:set(tonumber(array[13]));           menu_items.antiaim_settings[2].modifier_type:set(tonumber(array[22]));         menu_items.antiaim_settings[3].modifier_type:set(tonumber(array[31]));          menu_items.antiaim_settings[4].modifier_type:set(tonumber(array[40]));            menu_items.antiaim_settings[5].modifier_type:set(tonumber(array[49]));                 menu_items.antiaim_settings[6].modifier_type:set(tonumber(array[58]));                     menu_items.antiaim_settings[7].modifier_type:set(tonumber(array[67]));                    menu_items.antiaim_settings[8].modifier_type:set(tonumber(array[76]));
    menu_items.antiaim_settings[1].slider_body_yaw:set(tonumber(array[14]));         menu_items.antiaim_settings[2].slider_body_yaw:set(tonumber(array[23]));       menu_items.antiaim_settings[3].slider_body_yaw:set(tonumber(array[32]));         menu_items.antiaim_settings[4].slider_body_yaw:set(tonumber(array[41]));             menu_items.antiaim_settings[5].slider_body_yaw:set(tonumber(array[50]));             menu_items.antiaim_settings[6].slider_body_yaw:set(tonumber(array[59]));                     menu_items.antiaim_settings[7].slider_body_yaw:set(tonumber(array[68]));                    menu_items.antiaim_settings[8].slider_body_yaw:set(tonumber(array[77]));
    menu_items.antiaim_settings[1].fake_yaw_type:set(tonumber(array[15]));           menu_items.antiaim_settings[2].fake_yaw_type:set(tonumber(array[24]));         menu_items.antiaim_settings[3].fake_yaw_type:set(tonumber(array[33]));          menu_items.antiaim_settings[4].fake_yaw_type:set(tonumber(array[42]));             menu_items.antiaim_settings[5].fake_yaw_type:set(tonumber(array[51]));                    menu_items.antiaim_settings[6].fake_yaw_type:set(tonumber(array[60]));                     menu_items.antiaim_settings[7].fake_yaw_type:set(tonumber(array[69]));                    menu_items.antiaim_settings[8].fake_yaw_type:set(tonumber(array[78]));
    menu_items.antiaim_settings[1].slider_static_desync:set(tonumber(array[16]));    menu_items.antiaim_settings[2].slider_static_desync:set(tonumber(array[25]));  menu_items.antiaim_settings[3].slider_static_desync:set(tonumber(array[34]));   menu_items.antiaim_settings[4].slider_static_desync:set(tonumber(array[43]));             menu_items.antiaim_settings[5].slider_static_desync:set(tonumber(array[52]));  menu_items.antiaim_settings[6].slider_static_desync:set(tonumber(array[61]));                     menu_items.antiaim_settings[7].slider_static_desync:set(tonumber(array[70]));                    menu_items.antiaim_settings[8].slider_static_desync:set(tonumber(array[79]));
    menu_items.antiaim_settings[1].slider_ldesync:set(tonumber(array[17]));          menu_items.antiaim_settings[2].slider_ldesync:set(tonumber(array[26]));        menu_items.antiaim_settings[3].slider_ldesync:set(tonumber(array[35]));         menu_items.antiaim_settings[4].slider_ldesync:set(tonumber(array[44]));             menu_items.antiaim_settings[5].slider_ldesync:set(tonumber(array[53]));             menu_items.antiaim_settings[6].slider_ldesync:set(tonumber(array[62]));                     menu_items.antiaim_settings[7].slider_ldesync:set(tonumber(array[71]));                    menu_items.antiaim_settings[8].slider_ldesync:set(tonumber(array[80]));
    menu_items.antiaim_settings[1].slider_rdesync:set(tonumber(array[18]));          menu_items.antiaim_settings[2].slider_rdesync:set(tonumber(array[27]));        menu_items.antiaim_settings[3].slider_rdesync:set(tonumber(array[36]));          menu_items.antiaim_settings[4].slider_rdesync:set(tonumber(array[45]));             menu_items.antiaim_settings[5].slider_rdesync:set(tonumber(array[54]));                  menu_items.antiaim_settings[6].slider_rdesync:set(tonumber(array[63]));                      menu_items.antiaim_settings[7].slider_rdesync:set(tonumber(array[72]));                    menu_items.antiaim_settings[8].slider_rdesync:set(tonumber(array[81]));


    menu_items.antiaim_settings[1].pitchflick:set(tonumber(array[95]))
    menu_items.antiaim_settings[1].pitchflick_speed:set(tonumber(array[96]))

    menu_items.antiaim_settings[2].pitchflick:set(tonumber(array[97]))
    menu_items.antiaim_settings[2].pitchflick_speed:set(tonumber(array[98]))

    menu_items.antiaim_settings[3].pitchflick:set(tonumber(array[99]))
    menu_items.antiaim_settings[3].pitchflick_speed:set(tonumber(array[100]))

    menu_items.antiaim_settings[4].pitchflick:set(tonumber(array[101]))
    menu_items.antiaim_settings[4].pitchflick_speed:set(tonumber(array[102]))

    menu_items.antiaim_settings[5].pitchflick:set(tonumber(array[103]))
    menu_items.antiaim_settings[5].pitchflick_speed:set(tonumber(array[104]))
    
    menu_items.antiaim_settings[6].pitchflick:set(tonumber(array[105]))
    menu_items.antiaim_settings[6].pitchflick_speed:set(tonumber(array[106]))

    menu_items.antiaim_settings[7].pitchflick:set(tonumber(array[107]))
    menu_items.antiaim_settings[7].pitchflick_speed:set(tonumber(array[108]))

    menu_items.antiaim_settings[8].pitchflick:set(tonumber(array[109]))
    menu_items.antiaim_settings[8].pitchflick_speed:set(tonumber(array[110]))

    ----------------------------------------------------------------------------

    menu_items.antiaim_settings[1]._slider_3way:set(tonumber(array[111]))
    menu_items.antiaim_settings[1]._slider_3way2:set(tonumber(array[112]))
    menu_items.antiaim_settings[1]._slider_3way3:set(tonumber(array[113]))

    menu_items.antiaim_settings[2]._slider_3way:set(tonumber(array[114]))
    menu_items.antiaim_settings[2]._slider_3way2:set(tonumber(array[115]))
    menu_items.antiaim_settings[2]._slider_3way3:set(tonumber(array[116]))

    menu_items.antiaim_settings[3]._slider_3way:set(tonumber(array[117]))
    menu_items.antiaim_settings[3]._slider_3way2:set(tonumber(array[118]))
    menu_items.antiaim_settings[3]._slider_3way3:set(tonumber(array[119]))

    menu_items.antiaim_settings[4]._slider_3way:set(tonumber(array[120]))
    menu_items.antiaim_settings[4]._slider_3way2:set(tonumber(array[121]))
    menu_items.antiaim_settings[4]._slider_3way3:set(tonumber(array[122]))

    menu_items.antiaim_settings[5]._slider_3way:set(tonumber(array[123]))
    menu_items.antiaim_settings[5]._slider_3way2:set(tonumber(array[124]))
    menu_items.antiaim_settings[5]._slider_3way3:set(tonumber(array[125]))
    
    menu_items.antiaim_settings[6]._slider_3way:set(tonumber(array[126]))
    menu_items.antiaim_settings[6]._slider_3way2:set(tonumber(array[127]))
    menu_items.antiaim_settings[6]._slider_3way3:set(tonumber(array[128]))

    menu_items.antiaim_settings[7]._slider_3way:set(tonumber(array[129]))
    menu_items.antiaim_settings[7]._slider_3way2:set(tonumber(array[130]))
    menu_items.antiaim_settings[7]._slider_3way3:set(tonumber(array[131]))

    menu_items.antiaim_settings[8]._slider_3way:set(tonumber(array[132]))
    menu_items.antiaim_settings[8]._slider_3way2:set(tonumber(array[133]))
    menu_items.antiaim_settings[8]._slider_3way3:set(tonumber(array[134]))

    if array[135] == "false" then bool = false elseif array[135] == "true" then bool = true end
    menu_items.animbreaker:set(1, bool)
    if array[136] == "false" then bool = false elseif array[136] == "true" then bool = true end
    menu_items.animbreaker:set(2, bool)


    phase_pos = 1

    for i = 1, 9 do
        if phases[i] ~= nil then phases[i]:set(0); phases[i]:set_visible(false) end
        if phases_desyncL[i] ~= nil then phases_desyncL[i]:set(0); phases_desyncL[i]:set_visible(false) end
        if phases_desyncR[i] ~= nil then phases_desyncR[i]:set(0); phases_desyncR[i]:set_visible(false) end
    end

    phases = {
        [1] = menu.add_slider("Anti bruteforce","phase 1",-90, 90, 1, 0, "°"),
        [2] = nil,
        [3] = nil,
        [4] = nil,
        [5] = nil,
        [6] = nil,
        [7] = nil,
        [8] = nil,
        [9] = nil,
    }

    phases_desyncL = {
        [1] = menu.add_slider("Anti bruteforce","Desync_L 1",0, 60, 1, 0, "°"),
        [2] = nil,
        [3] = nil,
        [4] = nil,
        [5] = nil,
        [6] = nil,
        [7] = nil,
        [8] = nil,
        [9] = nil,
    }

    phases_desyncR = {
        [1] = menu.add_slider("Anti bruteforce","Desync_R 1",0, 60, 1, 0, "°"),
        [2] = nil,
        [3] = nil,
        [4] = nil,
        [5] = nil,
        [6] = nil,
        [7] = nil,
        [8] = nil,
        [9] = nil,
    }


    phases[1]:set(tonumber(array[82]))

    phases_desyncL[1]:set(tonumber(array[137]))

    phases_desyncR[1]:set(tonumber(array[146]))


    if array[83] == "?" or array[138] == "?" or array[147] == "?" then phases[2] = nil; phases_desyncL[2] = nil; phases_desyncR[2] = nil else add_phase_in_anti_bruteforce(); phases[2]:set(tonumber(array[83])); phases_desyncL[2]:set(tonumber(array[138])); phases_desyncR[2]:set(tonumber(array[147]))  end
    if array[84] == "?" or array[139] == "?" or array[148] == "?" then phases[3] = nil; phases_desyncL[3] = nil; phases_desyncR[3] = nil else add_phase_in_anti_bruteforce(); phases[3]:set(tonumber(array[84])); phases_desyncL[3]:set(tonumber(array[139])); phases_desyncR[3]:set(tonumber(array[148]))  end
    if array[85] == "?" or array[140] == "?" or array[149] == "?" then phases[4] = nil; phases_desyncL[4] = nil; phases_desyncR[4] = nil else add_phase_in_anti_bruteforce(); phases[4]:set(tonumber(array[85])); phases_desyncL[4]:set(tonumber(array[140])); phases_desyncR[4]:set(tonumber(array[149]))  end
    if array[86] == "?" or array[141] == "?" or array[150] == "?" then phases[5] = nil; phases_desyncL[5] = nil; phases_desyncR[5] = nil else add_phase_in_anti_bruteforce(); phases[5]:set(tonumber(array[86])); phases_desyncL[5]:set(tonumber(array[141])); phases_desyncR[5]:set(tonumber(array[150]))  end
    if array[87] == "?" or array[142] == "?" or array[151] == "?" then phases[6] = nil; phases_desyncL[6] = nil; phases_desyncR[6] = nil else add_phase_in_anti_bruteforce(); phases[6]:set(tonumber(array[87])); phases_desyncL[6]:set(tonumber(array[142])); phases_desyncR[6]:set(tonumber(array[151]))  end
    if array[88] == "?" or array[143] == "?" or array[152] == "?" then phases[7] = nil; phases_desyncL[7] = nil; phases_desyncR[7] = nil else add_phase_in_anti_bruteforce(); phases[7]:set(tonumber(array[88])); phases_desyncL[7]:set(tonumber(array[143])); phases_desyncR[7]:set(tonumber(array[152]))  end
    if array[89] == "?" or array[144] == "?" or array[153] == "?" then phases[8] = nil; phases_desyncL[8] = nil; phases_desyncR[8] = nil else add_phase_in_anti_bruteforce(); phases[8]:set(tonumber(array[89])); phases_desyncL[8]:set(tonumber(array[144])); phases_desyncR[8]:set(tonumber(array[153]))  end
    if array[90] == "?" or array[145] == "?" or array[154] == "?" then phases[9] = nil; phases_desyncL[9] = nil; phases_desyncR[9] = nil else add_phase_in_anti_bruteforce(); phases[9]:set(tonumber(array[90])); phases_desyncL[9]:set(tonumber(array[145])); phases_desyncR[9]:set(tonumber(array[154]))  end

end



function update_config() 
    config_data = ""

    for i = 1, 4 do
        config_data = config_data .. tostring(menu_items.smart_options:get(i)) .. "|"
    end
    
    config_data = config_data .. menu_items.refigure_random_1:get() .. "|" .. menu_items.refigure_random_2:get() .. "|" .. menu_items.antibruteforce_settings_time:get() .. "|" .. menu_items.configs:get() .. "|" .. menu_items.preset:get() .. "|"
    
    for i = 1, 8 do
        config_data = config_data .. tostring(menu_items.antiaim_settings[i].yaw_type:get()) .. "|"
        config_data = config_data .. tostring(menu_items.antiaim_settings[i].slider_yaw_add_left:get()) .. "|"
        config_data = config_data .. tostring(menu_items.antiaim_settings[i].slider_yaw_add_right:get()) .. "|"
        config_data = config_data .. tostring(menu_items.antiaim_settings[i].modifier_type:get()) .. "|"
        config_data = config_data .. tostring(menu_items.antiaim_settings[i].slider_body_yaw:get()) .. "|"
        config_data = config_data .. tostring(menu_items.antiaim_settings[i].fake_yaw_type:get()) .. "|"
        config_data = config_data .. tostring(menu_items.antiaim_settings[i].slider_static_desync:get()) .. "|"
        config_data = config_data .. tostring(menu_items.antiaim_settings[i].slider_ldesync:get()) .. "|"
        config_data = config_data .. tostring(menu_items.antiaim_settings[i].slider_rdesync:get()) .. "|"
    end

    for i = 1, 9 do
        if type(phases[i]) == "userdata" then
            config_data = config_data .. tostring(phases[i]:get()) .. "|"
        else
            config_data = config_data .. "?" .. "|"
        end
    end

    for i = 1, 3 do
        config_data = config_data .. tostring(menu_items.adjust_antiaim:get(i)) .. "|"
    end

    config_data = config_data .. tostring(menu_items.clantag_changer:get()) .. "|"

    for i = 1, 8 do 
        config_data = config_data .. tostring(menu_items.antiaim_settings[i].pitchflick:get()) .. "|"
        config_data = config_data .. tostring(menu_items.antiaim_settings[i].pitchflick_speed:get()) .. "|"
    end

    for i = 1, 8 do 
        config_data = config_data .. tostring(menu_items.antiaim_settings[i]._slider_3way:get()) .. "|"
        config_data = config_data .. tostring(menu_items.antiaim_settings[i]._slider_3way2:get()) .. "|"
        config_data = config_data .. tostring(menu_items.antiaim_settings[i]._slider_3way3:get()) .. "|"
    end

    config_data = config_data .. tostring(menu_items.animbreaker:get(1)) .. "|"
    config_data = config_data .. tostring(menu_items.animbreaker:get(2)) .. "|"

    for i = 1, 9 do
        if type(phases_desyncL[i]) == "userdata" then
            config_data = config_data .. tostring(phases_desyncL[i]:get()) .. "|"
        else
            config_data = config_data .. "?" .. "|"
        end
    end

    for i = 1, 9 do
        if type(phases_desyncR[i]) == "userdata" then
            config_data = config_data .. tostring(phases_desyncR[i]:get()) .. "|"
        else
            config_data = config_data .. "?" .. "|"
        end
    end
end

----------------------------------------------------
function import_config()
    local status, message = pcall(function ()
    config_data = clipboard.import()
    if string.len(config_data) < 150 then 
        error("wrong config")
        return
    end
    config_data = string.sub(config_data, 12, string.len(config_data))
    config_data = string.sub(config_data, 1, string.len(config_data)-string.len(base64.encode("mleb")))
    config_data = base64.decode(config_data)
    if config_data == nil then
        error("wrong config")
        return
    end
    apply_config(split(config_data, "|"))
    end)

end

menu.add_button("Config system", "Load default preset", function() 
    local status, message = pcall(function ()
        -- OLD - Mysolut1on_ZmFsc2V8dHJ1ZXx0cnVlfGZhbHNlfDB8MHwzfDN8M3wzfC02fC02fDJ8MHwxfDYwfDB8MHwzfC0yNnw4fDJ8LTY2fDJ8NjB8NTJ8NTV8M3wtMjJ8MjJ8Mnw3MHwxfDYwfDB8MHwzfDh8LTh8MnwtMTJ8Mnw2MHw1Mnw1NXwzfC0xOHwxMnwyfDQwfDF8NjB8MHwwfDN8MTV8NnwyfC0zfDJ8NjB8NTV8NTh8M3wtMjZ8OHwyfC02NnwyfDYwfDUyfDU1fDN8MHwwfDJ8MHwxfDB8MHwwfC0xMXwxNnwtNXwyOXw/fD98P3w/fD98dHJ1ZXx0cnVlfGZhbHNlfA==bWxlYg==
        -- 2-way old - Mysolut1on_ZmFsc2V8dHJ1ZXx0cnVlfGZhbHNlfDB8MHwzfDN8N3wzfC02fC02fDJ8MHwxfDYwfDB8MHwzfC0zM3w0MXwxfC02NnwyfDYwfDYwfDYwfDN8LTIwfDM0fDF8NzB8MXw2MHwwfDB8M3wtMjB8LTMwfDF8LTEyfDJ8NjB8NjB8NjB8M3wtMzB8Mzl8MXw0MHwxfDYwfDB8MHwzfC0yMXwxOHwxfC0zfDJ8NjB8NjB8NjB8M3wtMzN8NDF8MXwtNjZ8Mnw2MHw2MHw2MHwzfDB8MHwyfDB8MXwwfDB8MHwtMTF8MTZ8LTV8Mjl8P3w/fD98P3w/fHRydWV8dHJ1ZXxmYWxzZXx0cnVlfA==bWxlYg==
        config_data = "Mysolut1on_ZmFsc2V8dHJ1ZXx0cnVlfGZhbHNlfDB8MHwzfDF8Mnw0fDB8MHwxfDB8MXw2MHwwfDB8NHwwfDB8MXwxMDN8MXwxOXwwfDB8NHwwfDB8MXwwfDF8MjV8MHwwfDR8MHwwfDF8MHwxfDU4fDB8MHw0fDB8MHwxfDB8MXw0MHwwfDB8M3w0fDI0fDF8MHwxfDU4fDB8MHwzfDB8MHwyfDB8MXwwfDB8MHwzfDB8MHwyfDB8MXwwfDB8MHwxMnwtMjF8MTl8MHwwfD98P3w/fD98dHJ1ZXx0cnVlfGZhbHNlfHRydWV8MXwxfDF8MXwxfDF8MXw2MnwxfDF8MXwxfDF8MXwxfDF8LTI5fDIzfDQ5fC0zMXwtNTB8NDB8MzV8LTIzfC0yM3wtNnw0Mnw0MnwtMTh8Mzd8Mzd8MHwwfDB8MHwwfDB8MHwwfDB8dHJ1ZXx0cnVlfDM5fDUxfDU3fDU4fDI5fD98P3w/fD98MzN8NDR8NTh8MzB8MzF8P3w/fD98P3w=bWxlYg=="
        if string.len(config_data) < 150 then 
            error("wrong config")
            return
        end
        config_data = string.sub(config_data, 12, string.len(config_data))
        config_data = string.sub(config_data, 1, string.len(config_data)-string.len(base64.encode("mleb")))
        config_data = base64.decode(config_data)
        if config_data == nil then
            error("wrong config")
            return
        end
        apply_config(split(config_data, "|"))
    
    end)

    if not status then print("config imported") end

end)

menu.add_button("Config system", "Import config", import_config)

menu.add_button("Config system", "Export config",function ()
    update_config()
    config_data = "Mysolut1on_"..base64.encode(config_data)..base64.encode("mleb")
    clipboard.export(config_data)
end)
-----------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------
----------------------------------------------------------------------------


-------------------------------------------------------------------------
-------------------------------------------------------------------------
-------------------------------------------------------------------------

--region get_player_state
function get_player_state()
    local velocity = {
        velocityX = math.abs(entity_list.get_local_player():get_prop("m_vecVelocity").x),
        velocityY = math.abs(entity_list.get_local_player():get_prop("m_vecVelocity").y),
        velocityZ = math.abs(entity_list.get_local_player():get_prop("m_vecVelocity").z),
    }

    local flags = {
        crouch = entity_list.get_local_player():has_player_flag(e_player_flags.DUCKING),
        slowwalk_bind = menu.find("misc","main","movement","slow walk")[2]:get(),
        fakeduck_bind = menu.find("antiaim","main", "general","fakeduck")[2]:get(),
    }

    local curtime = global_vars.cur_time()

    if velocity.velocityZ == 0 then
        vars.ground_tick = vars.ground_tick + 1
    else
        vars.ground_tick = 0
        vars.end_time = curtime + 0.2
    end

    if vars.ground_tick > 1 and vars.end_time > curtime then
        if flags.crouch == false then
            return 4
        else
            return 6
        end
    end
    

    


    if flags.fakeduck_bind and velocity.velocityZ == 0 then return 8 end

    if velocity.velocityZ ~= 0 then if flags.crouch == false then return 4 end; return 6 end

    if velocity.velocityX < 8 and velocity.velocityY < 8 and velocity.velocityZ == 0 and flags.crouch == false then return 1 end

    if flags.crouch == false and velocity.velocityZ == 0 and flags.slowwalk_bind == false and velocity.velocityX ~= 0 and velocity.velocityY ~= 0 then return 2 end

    if velocity.velocityZ == 0 and flags.slowwalk_bind then return 3 end

    if flags.crouch and velocity.velocityZ == 0 then return 5 end

    return 7
    end
--endregion


--region events
local function on_event(event)
    if not entity_list.get_local_player() then return end

    if ((entity_list.get_local_player():get_prop("m_iAccount") <= 800 and menu_items.smart_options:get(3) and ui_refs.autobuy:get()) or (game_rules.get_prop("m_totalRoundsPlayed") == 0)) then
        ui_refs.autobuy:set(false)
        print("buybot disabled due to start pistol round")
    else
        ui_refs.autobuy:set(true)
    end

    if menu_items.smart_options:get(1) == true then
        vars.refigure = client.random_int(menu_items.refigure_random_1:get(), menu_items.refigure_random_2:get())
    else
        vars.refigure = 0
    end

    if menu_items.smart_options:get(2) == true then
        vars.temp_time = 0
        antiaims.add_yaw_from_phase = 0
        antiaims.add_yaw_from_phase_desyncl = 0
        antiaims.add_yaw_from_phase_desyncr = 0

    end

end

callbacks.add(e_callbacks.EVENT, on_event, "round_prestart")



local function on_event(event)
    if not entity_list.get_local_player() then return end
    if not entity_list.get_local_player():is_alive() then return end
    if not entity_list.get_local_player():get_active_weapon() then return end
    if not entity_list.get_player_from_userid(event.userid) then return end
    if entity_list.get_player_from_userid(event.userid):get_index() == entity_list.get_local_player():get_index() and entity_list.get_local_player():get_active_weapon():get_name() == "ssg08" then
        vars.last_shot_tick = globals.tick_count()
        vars.shot = true
    end
end


callbacks.add(e_callbacks.EVENT, on_event, "weapon_fire")
--endregion

--region antibruteforce

local function GetClosestPoint(A, B, P)
    A = {A.x, A.y}
    P = {P.x, P.y, P.z}

    local a_to_p = { P[1] - A[1], P[2] - A[2] }
    local a_to_b = { B[1] - A[1], B[2] - A[2] }
    local ab = a_to_b[1]^2 + a_to_b[2]^2
    local dots = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
    local t = dots / ab

    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
end

function anti_bruteforce()
    local phase = antiaims.data


    if menu_items.smart_options:get(2) then
        if not entity_list.get_local_player() then return end 
        if not entity_list.get_local_player():is_alive() then return end
        if phase > #phases then
            antiaims.data = 1
            phase = antiaims.data
        end
        if phases[phase] == nil then return end
        if phases_desyncL[phase] == nil then return end
        if phases_desyncR[phase] == nil then return end
        if phase == vars.last_phase then antiaims.data = 0; return else vars.last_phase = phase end
        --notif:add_notification("Anti-bruteforce", "phase: ".. phase.. ", distance: "..math.floor(antiaims.antibrute_distance), menu_items.antibruteforce_settings_time:get())
        antiaims.add_yaw_from_phase = phases[phase]:get()
        antiaims.add_yaw_from_phase_desyncl = phases_desyncL[phase]:get()
        antiaims.add_yaw_from_phase_desyncr = phases_desyncR[phase]:get()
        vars.temp_time = globals.cur_time()
    else
        antiaims.add_yaw_from_phase = 0
        antiaims.add_yaw_from_phase_desyncl = 0
        antiaims.add_yaw_from_phase_desyncr = 0
        vars.temp_time = 0
    end

end


callbacks.add(e_callbacks.EVENT, function(c)

    local ent = entity_list.get_player_from_userid(c.userid)
    if not ent then return end
    if not entity_list.get_local_player() then return end 
    if not entity_list.get_local_player():is_alive() then return end
    if ent:is_enemy() then
        local ent_shoot = ent:get_render_origin()
        ent_shoot.y = ent_shoot.y + ent:get_prop("m_vecViewOffset[2]")
        local player_head = entity_list.get_local_player():get_render_origin()
        local closest = GetClosestPoint(ent_shoot, { c.x, c.y, c.z }, player_head)
        local delta = { player_head[1]-closest[1], player_head[2]-closest[2] }
        local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)
        if math.abs(delta_2d) < 50 then
            antiaims.data = antiaims.data + 1
            antiaims.antibrute_distance = math.abs(delta_2d)
            client.delay_call(anti_bruteforce, 0.1)
        end
    end
end, "bullet_impact")

--endregion



local function on_run_command(cmd, unpredicted_data)
    if not entity_list.get_local_player() then return end
    if not entity_list.get_local_player():is_alive() then return end
    if not entity_list.get_local_player():get_active_weapon() then return end
    
    if entity_list.get_local_player():get_active_weapon():get_name() == "ssg08" and menu_items.smart_options:get(4) then
            
        if globals.tick_count() - vars.last_shot_tick > 9 and vars.shot then
            vars.in_recharge = true
            vars.shot = false
        end

        if vars.in_recharge then 
            exploits.force_uncharge()
            if exploits.get_charge() ~= 0 then
                vars.in_recharge = false
            end
        end
    end

    

end

callbacks.add(e_callbacks.RUN_COMMAND, on_run_command)

function antiaimm(ctx)


    if (antiaim.get_manual_override() == 1 and menu_items.adjust_antiaim:get(1)) or (antiaim.get_manual_override() == 2 and menu_items.adjust_antiaim:get(1))  or (antiaim.get_manual_override() == 3 and menu_items.adjust_antiaim:get(1))  or (ui_refs.freestand[2]:get() and  menu_items.adjust_antiaim:get(2)) or (game_rules.get_prop("m_bWarmupPeriod") and menu_items.adjust_antiaim:get(3))then
        ui_refs.yaw_add:set(0)
        ui_refs.rlimit_stand:set(100)
        ui_refs.llimit_stand:set(100)
        ui_refs.side_stand:set(5)
        return
    end

    if not entity_list.get_local_player() then return end
    if not entity_list.get_local_player():is_alive() then return end

    if globals.cur_time() - vars.temp_time >= menu_items.antibruteforce_settings_time:get() then
        vars.temp_time = 0
        antiaims.add_yaw_from_phase = 0
        antiaims.add_yaw_from_phase_desyncl = 0
        antiaims.add_yaw_from_phase_desyncr = 0
    end

    --[[
    1 = standing
    2 = running
    3 = slowwalk
    4 = air
    5 = crouch
    6 = air crouch
    7 = edge
    8 = fakeduck
    --]]


    if menu_items.configs:get() == 1 then
        -- custom
        menu_items.preset:set_visible(true)
        for i = 1, 8 do
            if get_player_state() == i then
                antiaims.yaw_type = menu_items.antiaim_settings[i].yaw_type:get()
                antiaims.yaw_left = menu_items.antiaim_settings[i].slider_yaw_add_left:get()
                antiaims.yaw_right = menu_items.antiaim_settings[i].slider_yaw_add_right:get()
                antiaims.modifier_type = menu_items.antiaim_settings[i].modifier_type:get()
                antiaims.body_yaw = menu_items.antiaim_settings[i].slider_body_yaw:get()
                antiaims.fake_yaw_type = menu_items.antiaim_settings[i].fake_yaw_type:get()
                antiaims.static_desync = menu_items.antiaim_settings[i].slider_static_desync:get()
                antiaims.desync_left = menu_items.antiaim_settings[i].slider_ldesync:get()
                antiaims.desync_right = menu_items.antiaim_settings[i].slider_rdesync:get()
                antiaims.pitchflick = menu_items.antiaim_settings[i].pitchflick:get()
                antiaims.pitchflickspeed = menu_items.antiaim_settings[i].pitchflick_speed:get()

                antiaims.way3_add = menu_items.antiaim_settings[i]._slider_3way:get()
                antiaims.way3_add2 = menu_items.antiaim_settings[i]._slider_3way2:get()
                antiaims.way3_add3 = menu_items.antiaim_settings[i]._slider_3way3:get()

                if globals.tick_count() % antiaims.pitchflickspeed < 2 and menu_items.antiaim_settings[i].pitchflick:get() == 2 and exploits.get_charge() > 10 then
                    ui_refs.pitch:set(3)
                else
                    ui_refs.pitch:set(2)
                end
            end
        end
    end


    --region jitter mode
    if antiaims.yaw_type == 1 then
        if exploits.get_charge() > 0 then
            ui_refs.fakelag:set(0)
            ui_refs.fakelag_lc:get(true)
        end

        if math.abs(globals.frame_count() - vars.temp_vars) > 0 then
            vars.revs = vars.revs == 1 and 0 or 1
            vars.temp_vars = globals.frame_count()
        end

    elseif antiaims.yaw_type == 2 then
        if exploits.get_charge() > 0 then
            ui_refs.fakelag:set(14)
            ui_refs.fakelag_lc:get(true)
        end
        if math.abs(global_vars.tick_count() - vars.temp_vars) > 1 then
            vars.revs = vars.revs == 1 and 0 or 1
            vars.temp_vars = global_vars.tick_count()
        end
    else
        if exploits.get_charge() > 0 then
            ui_refs.fakelag:set(1)
            ui_refs.fakelag_lc:get(true)
        end

        if math.abs(globals.frame_count() - vars.temp_vars) > 1 then
            vars.revs = vars.revs == 1 and 0 or 1
            vars.temp_vars = globals.frame_count()
        end
    end



    if exploits.get_charge() < 1 then
        ui_refs.fakelag:set(14)
        ui_refs.fakelag_lc:get(true)
    end
    --endregion


    -- apply antiaim
    if vars.revs == 0 then
        if antiaims.modifier_type == 2 and antiaims.yaw_type ~= 4 then
            if antiaims.body_yaw > 0 then
                yaw_add = antiaims.yaw_left - antiaims.body_yaw / -2 + antiaims.add_yaw_from_phase + vars.refigure
            else
                yaw_add = antiaims.yaw_left - antiaims.body_yaw / 2 + antiaims.add_yaw_from_phase + vars.refigure
            end
        else
            yaw_add = antiaims.yaw_left + antiaims.add_yaw_from_phase + vars.refigure
        end
        ui_refs.side_stand:set(3)

    else
        if antiaims.modifier_type == 2 and antiaims.yaw_type ~= 4 then
            if antiaims.body_yaw > 0 then
                yaw_add = antiaims.yaw_left - antiaims.body_yaw / -2 + antiaims.add_yaw_from_phase + vars.refigure
            else
                yaw_add = antiaims.yaw_left - antiaims.body_yaw / 2 + antiaims.add_yaw_from_phase + vars.refigure
            end
        else
            yaw_add = antiaims.yaw_right + antiaims.add_yaw_from_phase + vars.refigure
        end
        ui_refs.side_stand:set(2)
    end

    if antiaims.yaw_type == 1 or antiaims.yaw_type == 2 or antiaims.yaw_type == 3 then
        ui_refs.yaw_add:set(yaw_add)
    elseif antiaims.yaw_type == 4 then
        if globals.tick_count() % 3 == 0 then
            ui_refs.yaw_add:set(antiaims.way3_add)
        elseif globals.tick_count() % 3 == 1 then
            ui_refs.yaw_add:set(antiaims.way3_add2)
        elseif globals.tick_count() % 3 == 2 then
            ui_refs.yaw_add:set(antiaims.way3_add3)
        end

    end


    ui_refs.jitter_mode:set(2)
    ui_refs.jitter_type:set(2)
    ui_refs.jitter_add:set(0)

    if antiaims.yaw_type == 4 or antiaims.yaw_type == 5 then
        ui_refs.side_stand:set(3)
    end


    -- set desync
    -- is antibrute ready
    if antiaims.add_yaw_from_phase_desyncl ~= 0 and antiaims.add_yaw_from_phase_desyncr ~= 0 then
        ui_refs.rlimit_stand:set(antiaims.add_yaw_from_phase_desyncr * 10/6)
        ui_refs.llimit_stand:set(antiaims.add_yaw_from_phase_desyncl * 10/6)

    elseif antiaims.fake_yaw_type == 2 then
        ui_refs.rlimit_stand:set(antiaims.desync_right * 10/6)
        ui_refs.llimit_stand:set(antiaims.desync_left * 10/6)

    else
        ui_refs.rlimit_stand:set(antiaims.static_desync * 10/6)
        ui_refs.llimit_stand:set(antiaims.static_desync * 10/6)
    end





    -- Animbreaker
    if menu_items.animbreaker:get(1) then

    ctx:set_render_pose(e_poses.RUN, 0)
    ctx:set_render_pose(e_poses.JUMP_FALL, 1)
    ctx:set_render_pose(e_poses.MOVE_BLEND_WALK, 0)
    end

    if menu_items.animbreaker:get(2) then
    ctx:set_render_animlayer(e_animlayers.LEAN, 1)
    end

end

callbacks.add(e_callbacks.ANTIAIM, antiaimm)


local function on_shutdown()
    client.set_clantag("")
end

callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)


local delay = 0
local index = 0
local switch = false
local enabledisable = false
local clantag = {
    [-3] = "⌛ ",
    [-2] = "⌛ ",
    [-1] = "⌛ ",
    [0]  = "⌛ ",
    [1]  = "⌛ m",
    [2]  = "⌛ my",
    [3]  = "⌛ mys",
    [4]  = "⌛ myso",
    [5]  = "⌛ mysol",
    [6]  = "⌛ mysolu",
    [7]  = "⌛ mysolut",
    [8]  = "⌛ mysoluti",
    [9]  = "⌛ mysolutio",
    [10] = "⌛ mysolution",
    [11] = "⌛ mysolution",
    [12] = "⌛ mysolution",
    [13] = "⌛ mysolution",
}

function on_paint()

    if menu_items.clantag_changer:get() then
        enabledisable = false
        if global_vars.cur_time( ) - delay > 0.5 then
            if index > #clantag and switch == false then
                switch = true
            elseif index < -3 and switch == true then
                switch = false
            end

            if switch == true then
                index = index - 1
            else
                index = index + 1
            end

            if clantag[index] ~= nil then
                client.set_clantag(clantag[index])
            end
            delay = global_vars.cur_time( )
        end

    else
        if enabledisable == false then
            client.set_clantag("")
        end
        enabledisable = true
    end


    ui_refs.override_move:set(false)
    ui_refs.override_slowwalk:set(false)
    ui_refs.anti_bruteforce:set(false)
    ui_refs.on_shot:set(0)




    if menu_items.smart_options:get(1) == true then
        menu_items.refigure_random_1:set_visible(true)
        menu_items.refigure_random_2:set_visible(true)
    else
        menu_items.refigure_random_1:set_visible(false)
        menu_items.refigure_random_2:set_visible(false)
        vars.refigure = 0
    end

    if menu_items.smart_options:get(2) == true then
        menu_items.antibruteforce_settings_time:set_visible(true)
    else
        menu_items.antibruteforce_settings_time:set_visible(false)
        antiaims.left_phase = 0
        antiaims.right_phase = 0
    end


    for i = 1, 8 do
        menu_items.antiaim_settings[i].yaw_type:set_visible(menu_items.preset:get() == i and menu_items.configs:get() == 1)
        menu_items.antiaim_settings[i].slider_yaw_add_left:set_visible(menu_items.preset:get() == i and menu_items.configs:get() == 1 and menu_items.antiaim_settings[i].yaw_type:get() ~= 4);
        menu_items.antiaim_settings[i].slider_yaw_add_right:set_visible(menu_items.preset:get() == i and menu_items.configs:get() == 1 and menu_items.antiaim_settings[i].yaw_type:get() ~= 4);
        menu_items.antiaim_settings[i].modifier_type:set_visible(menu_items.preset:get() == i and menu_items.configs:get() == 1 and menu_items.antiaim_settings[i].yaw_type:get() ~= 4)
        menu_items.antiaim_settings[i].slider_body_yaw:set_visible(menu_items.preset:get() == i and menu_items.configs:get() == 1 and menu_items.antiaim_settings[i].modifier_type:get() == 2 and menu_items.antiaim_settings[i].yaw_type:get() ~= 4);
        menu_items.antiaim_settings[i].fake_yaw_type:set_visible(menu_items.preset:get() == i and menu_items.configs:get() == 1)
        menu_items.antiaim_settings[i].slider_static_desync:set_visible(menu_items.preset:get() == i and menu_items.configs:get() == 1 and menu_items.antiaim_settings[i].fake_yaw_type:get() == 1);
        menu_items.antiaim_settings[i].slider_rdesync:set_visible(menu_items.preset:get() == i and menu_items.configs:get() == 1 and menu_items.antiaim_settings[i].fake_yaw_type:get() == 2);
        menu_items.antiaim_settings[i].slider_ldesync:set_visible(menu_items.preset:get() == i and menu_items.configs:get() == 1 and menu_items.antiaim_settings[i].fake_yaw_type:get() == 2);
        menu_items.antiaim_settings[i].pitchflick:set_visible(menu_items.preset:get() == i and menu_items.configs:get() == 1);
        menu_items.antiaim_settings[i].pitchflick_speed:set_visible(menu_items.preset:get() == i and menu_items.configs:get() == 1 and menu_items.antiaim_settings[i].pitchflick:get() == 2);

        menu_items.antiaim_settings[i]._slider_3way:set_visible(menu_items.preset:get() == i and menu_items.configs:get() == 1 and menu_items.antiaim_settings[i].yaw_type:get() == 4);
        menu_items.antiaim_settings[i]._slider_3way2:set_visible(menu_items.preset:get() == i and menu_items.configs:get() == 1 and menu_items.antiaim_settings[i].yaw_type:get() == 4);
        menu_items.antiaim_settings[i]._slider_3way3:set_visible(menu_items.preset:get() == i and menu_items.configs:get() == 1 and menu_items.antiaim_settings[i].yaw_type:get() == 4);

    end
    menu_items.preset:set_visible(menu_items.configs:get() == 1)



end

callbacks.add(e_callbacks.PAINT, on_paint)