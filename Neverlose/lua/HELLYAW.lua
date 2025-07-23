-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local lib, mui, drag, monylinear, smooth, nade_prediction = require("neverlose/liberia"), require("neverlose/mui"), require("neverlose/dragging_system"), require("neverlose/monylinear"), require("neverlose/smooth"), (require("neverlose/grenade_prediction")("M1337NP") or { "Oops... The library's broken." })
local clipboard = require("neverlose/clipboard")
print = function(...)
    return print_raw("\aFF3333FF[HELLYAW] ", ...)
end

local references = {}
references.main = {
    ["Username"] = common.get_username(),
    ["Screen size"] = render.screen_size(),
    ["Mouse position"] = ui.get_mouse_position(),
    ["LUA Build"] = "Recode",
    ["Conditions"] = {"standing", "running", "crouching", "slowwalking", "jumping", "crouching air"}
}

references.list = {
    ["Angles"] = ui.find("Aimbot", "Anti Aim", "Angles"):visibility(true),
    ["Angles enabled"] = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"):visibility(false),
    ["Pitch"] = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"):visibility(false),
    ["Yaw"] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"):visibility(false),
    ["Yaw base"] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    ["Yaw offset"] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    ["Avoid backstab"] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    ["Hidden"] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
    ["Yaw modifier"] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"):visibility(false),
    ["Yaw modifier offset"] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    ["Body yaw"] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"):visibility(false),
    ["Inverter"] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
    ["Left limit"] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    ["Right limit"] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    ["Options"] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    ["Freestanding"] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    ["Fake Lag"] = ui.find("Aimbot", "Anti Aim", "Fake Lag"):visibility(false),
    ["Misc"] = ui.find("Aimbot", "Anti Aim", "Misc"):visibility(false),
    ["Freestanding NL"] = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"):visibility(false),
    ["Freestanding modifiers"] = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    ["Freestanding body"] = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),

    ["Extended angles"] = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"):visibility(false),
    ["Extended pitch"] = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"),
    ["Extended roll"] = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll"),

    ["Leg movement"] = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):visibility(false),
    ["Fake duck"] = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck")
}

references.list_need = {
    ["Double tap"] = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    ["Hide shots"] = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots")
}

cvar.clear:call()
references.list["Angles enabled"]:override(true)
references.list["Pitch"]:override("Down")
references.list["Yaw"]:override("Backward")
references.list["Avoid backstab"]:override(true)
references.list["Body yaw"]:override(true)

local lua_tabs = {
    ["anti aim"] = {
        universal = ui.find("Aimbot", "Anti Aim"):create("Universal", 1),
        constructor = ui.find("Aimbot", "Anti Aim"):create("Constructor", 1),
        extra = ui.find("Aimbot", "Anti Aim"):create("Extra options", 1),
        builder = ui.find("Aimbot", "Anti Aim"):create("Anti aim builder", 2),
    }
}

local menu = {
    ["anti aim"] = {
        logs_on_screen = mui.multi_combo(lua_tabs["anti aim"].universal, "\a{Link Active}[ \aDEFAULTdisplay logs \a{Link Active}]", {"notify", "dev", "console"}, function(gear)
            return {
                brute_logs = mui.switch(gear, "brute logs"),
                clr_notify = mui.color_edit(gear, "Color", color(196, 196, 255, 196))
            }
        end),
        visuals = mui.multi_combo(lua_tabs["anti aim"].universal, "\a{Link Active}[ \aDEFAULTinterface \a{Link Active}]", {"indicators", "manual arrows", "watermark", "grenade prediction", "grenade proximity warning"}, function(gear)
            return {
                clr_indicator = mui.color_edit(gear, "Color indicator", color(196, 196, 255, 196)),
                clr_arrows = mui.color_edit(gear, "Color arrows", color(114, 255, 246, 223)),
                arrows_offset = mui.slider(gear, "Offset", 10, 0, 75, 1),
                scale = mui.slider(gear, "Scale", 14, 8, 30, 1)
            }
        end),
        esp_flags = mui.multi_combo(lua_tabs["anti aim"].universal, "\a{Link Active}[ \aDEFAULTesp flags \a{Link Active}]", {"r8 helper", "weapon damage"}),
        potnie_opcii = mui.multi_combo(lua_tabs["anti aim"].constructor, "\a{Link Active}[ \aDEFAULThelpers \a{Link Active}]", {"anti bruteforce", "cross exploit", "avoid collisions", "super toss", "fast ladder", "nade throw fix", "no fall damage", "automatic grenade release"}, function(gear)
            return {
                air_lag = mui.switch(gear, "\aFF66FFFFair lag exploit \aFFFFFFFF[bind]"),
                selected = mui.multi_combo(gear, "select grenades", { "high explosive", "molotov", "smoke" }),
                damage = mui.slider(gear, "min. damage", 0, 0, 100, 1),
                speed = mui.slider(gear, "speed modulation", 0, 0, 425, 1, nil, function(value)
                    if value == 0 then return "off" end
                    return ("%su"):format(value)
                end)
            }
        end),
        anim_breakers = mui.multi_combo(lua_tabs["anti aim"].constructor, "\a{Link Active}[ \aDEFAULTanim. breakers \a{Link Active}]", {"in air", "on ground", "body lean", "reset pitch on land"}, function(gear)
            return {
                in_air_options = mui.combo(gear, "in air options", {"static", "moonwalk"}),
                on_ground_options = mui.combo(gear, "on ground options", {"follow direction", "jitter legs", "moonwalk"}),
                body_lean_amount = mui.slider(gear, "body lean amount", 0, 0, 100, 1)
            }
        end),
        
        defensive_tweaks = mui.multi_combo(lua_tabs["anti aim"].constructor, "\a{Link Active}[ \aDEFAULTdefensive break \a{Link Active}]", {"standing", "moving", "slow motion", "crouch", "air", "weapon switch", "low velocity", "threat mode"}),
        manual_mode = mui.combo(lua_tabs["anti aim"].constructor, "\a{Link Active}[ \aDEFAULTyaw base \a{Link Active}]", {"none", "forward", "left", "right"}, function(gear)
            return {
                defensive_aa = mui.switch(gear, "defensive aa"),
                option = mui.switch(gear, "static manual"),
                option_f = mui.switch(gear, "static while freestanding")
            }
        end),
        freestand_nl = mui.switch(lua_tabs["anti aim"].extra, "freestanding", nil, function(gear)
            return {
                disable_yaw_modifiers = mui.switch(gear, "disable yaw modifiers"),
                body_freestanding = mui.switch(gear, "body freestanding")
            }
        end),
        dormant_aimbot = mui.switch(lua_tabs["anti aim"].extra, "dormant aimbot \a6633FFFF[beta]", nil, function(gear)
            return {
                damage = mui.slider(gear, "damage", 1, 1, 100)
            }
        end),
        active_condition = mui.combo(lua_tabs["anti aim"].builder, "\a{Link Active}[ \aDEFAULTsetup condition \a{Link Active}]", references.main["Conditions"]),
        mui.button(lua_tabs["anti aim"].extra, "      press for get info about config system      ", false, function()
            cvar.clear:call()

            common.add_notify("hellyaw", [[Load the default config, type - //load
Share the settings, type - //share
Import settings, type - //import

Commands abbreviated - //l | //s | //i

                OPEN CONSOLE
            ]])
            print([[

                If you want to load the default config, type - //load
                If you want to share the settings, type - //share
                If you want to import settings, type - //import



                Commands are also abbreviated - //l || //s || //i

            ]])
        end)
    }
}

for i = 1, #references.main["Conditions"] do
    local condition = references.main["Conditions"][i]
    menu["anti aim"][("%s.%s"):format(condition, "enable")] = mui.switch(lua_tabs["anti aim"].builder, ("apply settings for \aFF3300ff%s"):format(string.lower(condition)))
    menu["anti aim"][("%s.%s"):format(condition, "yaw_base")] = mui.combo(lua_tabs["anti aim"].builder, "yaw base", {"local view", "at target"})
    menu["anti aim"][("%s.%s"):format(condition, "offset_left")] = mui.slider(lua_tabs["anti aim"].builder, "yaw add left", 0, -180, 180, 1, nil, "°")
    menu["anti aim"][("%s.%s"):format(condition, "offset_right")] = mui.slider(lua_tabs["anti aim"].builder, "yaw add right", 0, -180, 180, 1, nil, "°")
    menu["anti aim"][("%s.%s"):format(condition, "yaw_modifier")] = mui.combo(lua_tabs["anti aim"].builder, "yaw modifier", {"disabled", "center", "random center", "progressive", "offset", "3-way", "5-way"}, function(gear)
        return {
            yaw_modifier_offset = mui.slider(gear, "modifier offset", 0, -180, 180, 1, nil, "°")
        }
    end)
    menu["anti aim"][("%s.%s"):format(condition, "left_limit")] = mui.slider(lua_tabs["anti aim"].builder, "left limit", 60, 0, 60, 1, nil, "°")
    menu["anti aim"][("%s.%s"):format(condition, "right_limit")] = mui.slider(lua_tabs["anti aim"].builder, "right limit", 60, 0, 60, 1, nil, "°")
    menu["anti aim"][("%s.%s"):format(condition, "fake_options")] = mui.multi_combo(lua_tabs["anti aim"].builder, "fake options", {"avoid overlap", "jitter", "randomize jitter"}, function(gear)
        return {
            delay_tick_type = mui.combo(gear, "mode", {"static", "developer"}),
            delay_tick = mui.slider(gear, "delay tick", 0, 0, 100, 1, nil, function(value)
                return ("%s%%"):format(value)
            end),
            start = mui.slider(gear, "start", 22, 0, 100),
            stop = mui.slider(gear, "stop", 22, 0, 100),
            random = mui.slider(gear, "random", 22, 0, 100)
        }
    end)
    menu["anti aim"][("%s.%s"):format(condition, "freestanding")] = mui.combo(lua_tabs["anti aim"].builder, "freestanding", {"off", "peek fake", "peek real"})
    menu["anti aim"][("%s.%s"):format(condition, "hidden_lc")] = mui.switch(lua_tabs["anti aim"].builder, "hidden lc", nil,  function(gear)
        return {
            pitch_mode = mui.combo(gear, "defensive pitch", {"disabled", "custom", "random ways", "hellyaw"}),
            pitch_slider = mui.slider(gear, "pitch", 0, -89, 89),
            yaw_mode = mui.combo(gear, "defensive yaw", {"disabled", "custom", "random ways", "ribalka"}),
            switch_type = mui.combo(gear, "switch type", {"advanced", "inverter"}),
            yaw_slider_1 = mui.slider(gear, "yaw left", 0, -180, 180),
            yaw_slider_2 = mui.slider(gear, "yaw right", 0, -180, 180)
        }
    end)
    menu["anti aim"][("%s.%s"):format(condition, "enable")]:set_callback(function(enable)
        local override_condition = (condition == menu["anti aim"].active_condition:get())
        menu["anti aim"][("%s.%s"):format(condition, "yaw_base")]:visibility(override_condition and enable:get())
        menu["anti aim"][("%s.%s"):format(condition, "offset_left")]:visibility(override_condition and enable:get())
        menu["anti aim"][("%s.%s"):format(condition, "offset_right")]:visibility(override_condition and enable:get())
        menu["anti aim"][("%s.%s"):format(condition, "yaw_modifier")]:visibility(override_condition and enable:get())
        menu["anti aim"][("%s.%s"):format(condition, "yaw_modifier")]:set_callback(function(yaw_modifier)
            menu["anti aim"][("%s.%s"):format(condition, "yaw_modifier")]["gear"].yaw_modifier_offset:visibility(override_condition and enable:get() and yaw_modifier:get() ~= "Disabled")
        end, true)
        menu["anti aim"][("%s.%s"):format(condition, "left_limit")]:visibility(override_condition and enable:get())
        menu["anti aim"][("%s.%s"):format(condition, "right_limit")]:visibility(override_condition and enable:get())
        menu["anti aim"][("%s.%s"):format(condition, "fake_options")]:visibility(override_condition and enable:get())
        menu["anti aim"][("%s.%s"):format(condition, "freestanding")]:visibility(override_condition and enable:get())
        menu["anti aim"][("%s.%s"):format(condition, "hidden_lc")]:visibility(override_condition and enable:get())
        menu["anti aim"][("%s.%s"):format(condition, "hidden_lc")]["gear"].pitch_mode:set_callback(function(type)
            menu["anti aim"][("%s.%s"):format(condition, "hidden_lc")]["gear"].pitch_slider:visibility(override_condition and enable:get() and type:get() == "custom")
        end, true)
        menu["anti aim"][("%s.%s"):format(condition, "hidden_lc")]["gear"].yaw_mode:set_callback(function(type)
            menu["anti aim"][("%s.%s"):format(condition, "hidden_lc")]["gear"].switch_type:visibility(override_condition and enable:get() and type:get() == "custom")
            menu["anti aim"][("%s.%s"):format(condition, "hidden_lc")]["gear"].yaw_slider_1:visibility(override_condition and enable:get() and type:get() == "custom")
            menu["anti aim"][("%s.%s"):format(condition, "hidden_lc")]["gear"].yaw_slider_2:visibility(override_condition and enable:get() and type:get() == "custom")
        end, true)
        menu["anti aim"][("%s.%s"):format(condition, "fake_options")]:set_callback(function(fake_options)
            local mode = menu["anti aim"][("%s.%s"):format(condition, "fake_options")]["gear"].delay_tick_type
            mode:visibility(override_condition and enable:get() and fake_options:get("Jitter"))
            menu["anti aim"][("%s.%s"):format(condition, "fake_options")]["gear"].delay_tick:visibility(mode:get() == "static" and override_condition and enable:get() and fake_options:get("Jitter"))
            menu["anti aim"][("%s.%s"):format(condition, "fake_options")]["gear"].start:visibility(mode:get() ~= "static" and override_condition and enable:get() and fake_options:get("Jitter"))
            menu["anti aim"][("%s.%s"):format(condition, "fake_options")]["gear"].stop:visibility(mode:get() ~= "static" and override_condition and enable:get() and fake_options:get("Jitter"))
            menu["anti aim"][("%s.%s"):format(condition, "fake_options")]["gear"].random:visibility(mode:get() ~= "static" and override_condition and enable:get() and fake_options:get("Jitter"))
            mode:set_callback(function(mode)
                menu["anti aim"][("%s.%s"):format(condition, "fake_options")]["gear"].delay_tick:visibility(mode:get() == "static" and override_condition and enable:get() and fake_options:get("Jitter"))
                menu["anti aim"][("%s.%s"):format(condition, "fake_options")]["gear"].start:visibility(mode:get() ~= "static" and override_condition and enable:get() and fake_options:get("Jitter"))
                menu["anti aim"][("%s.%s"):format(condition, "fake_options")]["gear"].stop:visibility(mode:get() ~= "static" and override_condition and enable:get() and fake_options:get("Jitter"))
                menu["anti aim"][("%s.%s"):format(condition, "fake_options")]["gear"].random:visibility(mode:get() ~= "static" and override_condition and enable:get() and fake_options:get("Jitter"))
            end, true)
        end, true)
    end, true)
end

menu["anti aim"].active_condition:set_callback(function(condition)
    for i = 1, #references.main["Conditions"] do
        local condition_t = references.main["Conditions"][i]
        menu["anti aim"][("%s.%s"):format(condition_t, "enable")]:visibility(condition:get() == condition_t)
        menu["anti aim"][("%s.%s"):format(condition_t, "enable")]:set(menu["anti aim"][("%s.%s"):format(condition_t, "enable")]:get())
    end
end, true)

local de_en_coding = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local base64 = {
    encode = function(data)
        return ((data:gsub(".", function(x)
            local r,de_en_coding= "", x:byte()
            for i=8,1,-1 do r=r..(de_en_coding%2^i-de_en_coding%2^(i-1)>0 and "1" or "0") end
            return r
        end).."0000"):gsub("%d%d%d?%d?%d?%d?", function(x)
            if (#x < 6) then return "" end
            local c=0
            for i=1,6 do c=c+(x:sub(i,i)=="1" and 2^(6-i) or 0) end
            return de_en_coding:sub(c+1,c+1)
        end)..({ "", "", "" })[#data%3+1])
    end,
    decode = function(data)
        data = string.gsub(data, "[^"..de_en_coding.."]", "")
        return (data:gsub(".", function(x)
            if (x == "") then return "" end
            local r,f="",(de_en_coding:find(x)-1)
            for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and "1" or "0") end
            return r
        end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
            if (#x ~= 8) then return "" end
            local c=0
            for i=1,8 do c=c+(x:sub(i,i)=="1" and 2^(8-i) or 0) end
                return string.char(c)
        end))
    end
}

local configs = {} do
    configs.parse_data = function()
        local buffer = mui.configs.save(menu, { "anti aim" })
        local data = ("hellyaw_%s"):format(base64.encode(json.stringify(buffer)))
        clipboard.set(data)
        utils.console_exec("play ui/beepclear")
        print([[
            The config was copied to the clipboard!
            ]])
    end
    configs.paste_data = function(buffer)
        local is_successfull, converted_data = pcall(function()
            local text do
                text = buffer or clipboard.get()
                text = text:gsub("hellyaw_", ""):match("[%w%+%/]+%=*")
                text = base64.decode(text)
            end

            local from_json = json.parse(text)
            return from_json
        end)
        if not is_successfull then
            print([[
                Config loaded with error!
                ]])
            return
        end
        local buffer = mui.configs.load(menu, converted_data)
        utils.console_exec("play ui/beepclear")
        if not buffer then
            print([[
                Your config is successfully imported!
            ]])
        else
            print([[
                The settings are successfully loaded!
            ]])
        end
    end
end

events.console_input:set(function(text)
    if text == "//load" or text == "//l" or text == "//load " or text == "//l " then
        configs.paste_data("hellyaw_W1siY29tYm8iLCJhbnRpIGFpbSIsImNyb3VjaGluZyBhaXIuZnJlZXN0YW5kaW5nIiwib2ZmIl0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsImNyb3VjaGluZyBhaXIuaGlkZGVuX2xjIix0cnVlXSxbInN3aXRjaCIsImFudGkgYWltIiwiY3JvdWNoaW5nIGFpci5oaWRkZW5fbGMiLCJoZWxseWF3IixudWxsLG51bGwsWyJwaXRjaF9tb2RlIiwiY3JvdWNoaW5nIGFpci5oaWRkZW5fbGMiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiY3JvdWNoaW5nIGFpci5oaWRkZW5fbGMiLC05MC4wLG51bGwsbnVsbCxbInlhd19zbGlkZXJfMSIsImNyb3VjaGluZyBhaXIuaGlkZGVuX2xjIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcgYWlyLmhpZGRlbl9sYyIsMC4wLG51bGwsbnVsbCxbInBpdGNoX3NsaWRlciIsImNyb3VjaGluZyBhaXIuaGlkZGVuX2xjIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcgYWlyLmhpZGRlbl9sYyIsInJpYmFsa2EiLG51bGwsbnVsbCxbInlhd19tb2RlIiwiY3JvdWNoaW5nIGFpci5oaWRkZW5fbGMiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiY3JvdWNoaW5nIGFpci5oaWRkZW5fbGMiLDkwLjAsbnVsbCxudWxsLFsieWF3X3NsaWRlcl8yIiwiY3JvdWNoaW5nIGFpci5oaWRkZW5fbGMiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsImNyb3VjaGluZyBhaXIuaGlkZGVuX2xjIiwiYWR2YW5jZWQiLG51bGwsbnVsbCxbInN3aXRjaF90eXBlIiwiY3JvdWNoaW5nIGFpci5oaWRkZW5fbGMiLCJjb21ibyJdXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsInZpc3VhbHMiLFsiaW5kaWNhdG9ycyJdXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsInZpc3VhbHMiLCJDNEM0RkZDNCIsbnVsbCxudWxsLFsiY2xyX2luZGljYXRvciIsInZpc3VhbHMiLCJjb2xvcl9waWNrZXIiXV0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJsb2dzX29uX3NjcmVlbiIsWyJub3RpZnkiLCJkZXYiLCJjb25zb2xlIl1dLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwibG9nc19vbl9zY3JlZW4iLGZhbHNlLG51bGwsbnVsbCxbImJydXRlX2xvZ3MiLCJsb2dzX29uX3NjcmVlbiIsInN3aXRjaCJdXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsImxvZ3Nfb25fc2NyZWVuIiwiQzRDNEZGQzQiLG51bGwsbnVsbCxbImNscl9ub3RpZnkiLCJsb2dzX29uX3NjcmVlbiIsImNvbG9yX3BpY2tlciJdXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsImRlZmVuc2l2ZV90d2Vha3MiLFsiY3JvdWNoIiwiYWlyIiwid2VhcG9uIHN3aXRjaCIsImxvdyB2ZWxvY2l0eSIsInRocmVhdCBtb2RlIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJzdGFuZGluZy5lbmFibGUiLHRydWVdLFsic2xpZGVyIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcgYWlyLnJpZ2h0X2xpbWl0Iiw2MC4wXSxbImNvbWJvIiwiYW50aSBhaW0iLCJzdGFuZGluZy55YXdfYmFzZSIsImF0IHRhcmdldCJdLFsic2xpZGVyIiwiYW50aSBhaW0iLCJzdGFuZGluZy5vZmZzZXRfbGVmdCIsOS4wXSxbInNsaWRlciIsImFudGkgYWltIiwic3RhbmRpbmcub2Zmc2V0X3JpZ2h0Iiw5LjBdLFsiY29tYm8iLCJhbnRpIGFpbSIsInN0YW5kaW5nLnlhd19tb2RpZmllciIsImNlbnRlciJdLFsiY29tYm8iLCJhbnRpIGFpbSIsInN0YW5kaW5nLnlhd19tb2RpZmllciIsLTY3LjAsbnVsbCxudWxsLFsieWF3X21vZGlmaWVyX29mZnNldCIsInN0YW5kaW5nLnlhd19tb2RpZmllciIsInNsaWRlciJdXSxbInNsaWRlciIsImFudGkgYWltIiwic3RhbmRpbmcubGVmdF9saW1pdCIsNjAuMF0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsInN0YW5kaW5nLnJpZ2h0X2xpbWl0Iiw2MC4wXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsInN0YW5kaW5nLmZha2Vfb3B0aW9ucyIsWyJqaXR0ZXIiXV0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJzdGFuZGluZy5mYWtlX29wdGlvbnMiLDAuMCxudWxsLG51bGwsWyJkZWxheV90aWNrIiwic3RhbmRpbmcuZmFrZV9vcHRpb25zIiwic2xpZGVyIl1dLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwic3RhbmRpbmcuZmFrZV9vcHRpb25zIiwyMi4wLG51bGwsbnVsbCxbInJhbmRvbSIsInN0YW5kaW5nLmZha2Vfb3B0aW9ucyIsInNsaWRlciJdXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsInN0YW5kaW5nLmZha2Vfb3B0aW9ucyIsMjIuMCxudWxsLG51bGwsWyJzdG9wIiwic3RhbmRpbmcuZmFrZV9vcHRpb25zIiwic2xpZGVyIl1dLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwic3RhbmRpbmcuZmFrZV9vcHRpb25zIiwic3RhdGljIixudWxsLG51bGwsWyJkZWxheV90aWNrX3R5cGUiLCJzdGFuZGluZy5mYWtlX29wdGlvbnMiLCJjb21ibyJdXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsInN0YW5kaW5nLmZha2Vfb3B0aW9ucyIsMjIuMCxudWxsLG51bGwsWyJzdGFydCIsInN0YW5kaW5nLmZha2Vfb3B0aW9ucyIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJzdGFuZGluZy5mcmVlc3RhbmRpbmciLCJvZmYiXSxbInN3aXRjaCIsImFudGkgYWltIiwic3RhbmRpbmcuaGlkZGVuX2xjIixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsInN0YW5kaW5nLmhpZGRlbl9sYyIsImN1c3RvbSIsbnVsbCxudWxsLFsicGl0Y2hfbW9kZSIsInN0YW5kaW5nLmhpZGRlbl9sYyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJzdGFuZGluZy5oaWRkZW5fbGMiLDAuMCxudWxsLG51bGwsWyJ5YXdfc2xpZGVyXzEiLCJzdGFuZGluZy5oaWRkZW5fbGMiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsInN0YW5kaW5nLmhpZGRlbl9sYyIsLTg5LjAsbnVsbCxudWxsLFsicGl0Y2hfc2xpZGVyIiwic3RhbmRpbmcuaGlkZGVuX2xjIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJzdGFuZGluZy5oaWRkZW5fbGMiLCJjdXN0b20iLG51bGwsbnVsbCxbInlhd19tb2RlIiwic3RhbmRpbmcuaGlkZGVuX2xjIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsInN0YW5kaW5nLmhpZGRlbl9sYyIsMC4wLG51bGwsbnVsbCxbInlhd19zbGlkZXJfMiIsInN0YW5kaW5nLmhpZGRlbl9sYyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwic3RhbmRpbmcuaGlkZGVuX2xjIiwiYWR2YW5jZWQiLG51bGwsbnVsbCxbInN3aXRjaF90eXBlIiwic3RhbmRpbmcuaGlkZGVuX2xjIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsInJ1bm5pbmcuZW5hYmxlIix0cnVlXSxbInN3aXRjaCIsImFudGkgYWltIiwiZnJlZXN0YW5kX25sIixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsImZyZWVzdGFuZF9ubCIsZmFsc2UsbnVsbCxudWxsLFsiZGlzYWJsZV95YXdfbW9kaWZpZXJzIiwiZnJlZXN0YW5kX25sIiwic3dpdGNoIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJmcmVlc3RhbmRfbmwiLGZhbHNlLG51bGwsbnVsbCxbImJvZHlfZnJlZXN0YW5kaW5nIiwiZnJlZXN0YW5kX25sIiwic3dpdGNoIl1dLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwiZXNwX2ZsYWdzIixbInI4IGhlbHBlciIsIndlYXBvbiBkYW1hZ2UiXV0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsInJ1bm5pbmcub2Zmc2V0X2xlZnQiLC0yNC4wXSxbInNsaWRlciIsImFudGkgYWltIiwicnVubmluZy5vZmZzZXRfcmlnaHQiLDM5LjBdLFsiY29tYm8iLCJhbnRpIGFpbSIsInJ1bm5pbmcueWF3X21vZGlmaWVyIiwiZGlzYWJsZWQiXSxbImNvbWJvIiwiYW50aSBhaW0iLCJydW5uaW5nLnlhd19tb2RpZmllciIsLTcyLjAsbnVsbCxudWxsLFsieWF3X21vZGlmaWVyX29mZnNldCIsInJ1bm5pbmcueWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsic2xpZGVyIiwiYW50aSBhaW0iLCJydW5uaW5nLmxlZnRfbGltaXQiLDYwLjBdLFsic2xpZGVyIiwiYW50aSBhaW0iLCJydW5uaW5nLnJpZ2h0X2xpbWl0Iiw2MC4wXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsInJ1bm5pbmcuZmFrZV9vcHRpb25zIixbImppdHRlciJdXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsInJ1bm5pbmcuZmFrZV9vcHRpb25zIiwyNS4wLG51bGwsbnVsbCxbImRlbGF5X3RpY2siLCJydW5uaW5nLmZha2Vfb3B0aW9ucyIsInNsaWRlciJdXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsInJ1bm5pbmcuZmFrZV9vcHRpb25zIiwyMi4wLG51bGwsbnVsbCxbInJhbmRvbSIsInJ1bm5pbmcuZmFrZV9vcHRpb25zIiwic2xpZGVyIl1dLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwicnVubmluZy5mYWtlX29wdGlvbnMiLDIyLjAsbnVsbCxudWxsLFsic3RvcCIsInJ1bm5pbmcuZmFrZV9vcHRpb25zIiwic2xpZGVyIl1dLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwicnVubmluZy5mYWtlX29wdGlvbnMiLCJzdGF0aWMiLG51bGwsbnVsbCxbImRlbGF5X3RpY2tfdHlwZSIsInJ1bm5pbmcuZmFrZV9vcHRpb25zIiwiY29tYm8iXV0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJydW5uaW5nLmZha2Vfb3B0aW9ucyIsMjIuMCxudWxsLG51bGwsWyJzdGFydCIsInJ1bm5pbmcuZmFrZV9vcHRpb25zIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsInJ1bm5pbmcuZnJlZXN0YW5kaW5nIiwib2ZmIl0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsInJ1bm5pbmcuaGlkZGVuX2xjIixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsInJ1bm5pbmcuaGlkZGVuX2xjIiwiY3VzdG9tIixudWxsLG51bGwsWyJwaXRjaF9tb2RlIiwicnVubmluZy5oaWRkZW5fbGMiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwicnVubmluZy5oaWRkZW5fbGMiLC05MC4wLG51bGwsbnVsbCxbInlhd19zbGlkZXJfMSIsInJ1bm5pbmcuaGlkZGVuX2xjIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJydW5uaW5nLmhpZGRlbl9sYyIsLTM1LjAsbnVsbCxudWxsLFsicGl0Y2hfc2xpZGVyIiwicnVubmluZy5oaWRkZW5fbGMiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsInJ1bm5pbmcuaGlkZGVuX2xjIiwiY3VzdG9tIixudWxsLG51bGwsWyJ5YXdfbW9kZSIsInJ1bm5pbmcuaGlkZGVuX2xjIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsInJ1bm5pbmcuaGlkZGVuX2xjIiw5MC4wLG51bGwsbnVsbCxbInlhd19zbGlkZXJfMiIsInJ1bm5pbmcuaGlkZGVuX2xjIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJydW5uaW5nLmhpZGRlbl9sYyIsImFkdmFuY2VkIixudWxsLG51bGwsWyJzd2l0Y2hfdHlwZSIsInJ1bm5pbmcuaGlkZGVuX2xjIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsImNyb3VjaGluZy5lbmFibGUiLHRydWVdLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwicG90bmllX29wY2lpIixbImZhc3QgbGFkZGVyIiwibm8gZmFsbCBkYW1hZ2UiXV0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJwb3RuaWVfb3BjaWkiLGZhbHNlLG51bGwsbnVsbCxbImFpcl9sYWciLCJwb3RuaWVfb3BjaWkiLCJzd2l0Y2giXV0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJwb3RuaWVfb3BjaWkiLDAuMCxudWxsLG51bGwsWyJkYW1hZ2UiLCJwb3RuaWVfb3BjaWkiLCJzbGlkZXIiXV0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJwb3RuaWVfb3BjaWkiLFtdLG51bGwsbnVsbCxbInNlbGVjdGVkIiwicG90bmllX29wY2lpIiwic2VsZWN0YWJsZSJdXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsInBvdG5pZV9vcGNpaSIsMC4wLG51bGwsbnVsbCxbInNwZWVkIiwicG90bmllX29wY2lpIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsImNyb3VjaGluZy55YXdfYmFzZSIsImF0IHRhcmdldCJdLFsic2xpZGVyIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcub2Zmc2V0X2xlZnQiLDkuMF0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsImNyb3VjaGluZy5vZmZzZXRfcmlnaHQiLDkuMF0sWyJjb21ibyIsImFudGkgYWltIiwiY3JvdWNoaW5nLnlhd19tb2RpZmllciIsImNlbnRlciJdLFsiY29tYm8iLCJhbnRpIGFpbSIsImNyb3VjaGluZy55YXdfbW9kaWZpZXIiLC02Ny4wLG51bGwsbnVsbCxbInlhd19tb2RpZmllcl9vZmZzZXQiLCJjcm91Y2hpbmcueWF3X21vZGlmaWVyIiwic2xpZGVyIl1dLFsic2xpZGVyIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcubGVmdF9saW1pdCIsNjAuMF0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsImNyb3VjaGluZy5yaWdodF9saW1pdCIsNjAuMF0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcuZmFrZV9vcHRpb25zIixbImppdHRlciJdXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsImNyb3VjaGluZy5mYWtlX29wdGlvbnMiLDAuMCxudWxsLG51bGwsWyJkZWxheV90aWNrIiwiY3JvdWNoaW5nLmZha2Vfb3B0aW9ucyIsInNsaWRlciJdXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsImNyb3VjaGluZy5mYWtlX29wdGlvbnMiLDIyLjAsbnVsbCxudWxsLFsicmFuZG9tIiwiY3JvdWNoaW5nLmZha2Vfb3B0aW9ucyIsInNsaWRlciJdXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsImNyb3VjaGluZy5mYWtlX29wdGlvbnMiLDIyLjAsbnVsbCxudWxsLFsic3RvcCIsImNyb3VjaGluZy5mYWtlX29wdGlvbnMiLCJzbGlkZXIiXV0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcuZmFrZV9vcHRpb25zIiwic3RhdGljIixudWxsLG51bGwsWyJkZWxheV90aWNrX3R5cGUiLCJjcm91Y2hpbmcuZmFrZV9vcHRpb25zIiwiY29tYm8iXV0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcuZmFrZV9vcHRpb25zIiwyMi4wLG51bGwsbnVsbCxbInN0YXJ0IiwiY3JvdWNoaW5nLmZha2Vfb3B0aW9ucyIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcuZnJlZXN0YW5kaW5nIiwib2ZmIl0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsImNyb3VjaGluZy5oaWRkZW5fbGMiLHRydWVdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcuaGlkZGVuX2xjIiwiY3VzdG9tIixudWxsLG51bGwsWyJwaXRjaF9tb2RlIiwiY3JvdWNoaW5nLmhpZGRlbl9sYyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcuaGlkZGVuX2xjIiwtOTAuMCxudWxsLG51bGwsWyJ5YXdfc2xpZGVyXzEiLCJjcm91Y2hpbmcuaGlkZGVuX2xjIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcuaGlkZGVuX2xjIiwtODkuMCxudWxsLG51bGwsWyJwaXRjaF9zbGlkZXIiLCJjcm91Y2hpbmcuaGlkZGVuX2xjIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcuaGlkZGVuX2xjIiwiZGlzYWJsZWQiLG51bGwsbnVsbCxbInlhd19tb2RlIiwiY3JvdWNoaW5nLmhpZGRlbl9sYyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcuaGlkZGVuX2xjIiw5MC4wLG51bGwsbnVsbCxbInlhd19zbGlkZXJfMiIsImNyb3VjaGluZy5oaWRkZW5fbGMiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsImNyb3VjaGluZy5oaWRkZW5fbGMiLCJhZHZhbmNlZCIsbnVsbCxudWxsLFsic3dpdGNoX3R5cGUiLCJjcm91Y2hpbmcuaGlkZGVuX2xjIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsInNsb3d3YWxraW5nLmVuYWJsZSIsZmFsc2VdLFsiY29tYm8iLCJhbnRpIGFpbSIsIm1hbnVhbF9tb2RlIiwibm9uZSJdLFsiY29tYm8iLCJhbnRpIGFpbSIsIm1hbnVhbF9tb2RlIix0cnVlLG51bGwsbnVsbCxbImRlZmVuc2l2ZV9hYSIsIm1hbnVhbF9tb2RlIiwic3dpdGNoIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsIm1hbnVhbF9tb2RlIixmYWxzZSxudWxsLG51bGwsWyJvcHRpb24iLCJtYW51YWxfbW9kZSIsInN3aXRjaCJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJtYW51YWxfbW9kZSIsZmFsc2UsbnVsbCxudWxsLFsib3B0aW9uX2YiLCJtYW51YWxfbW9kZSIsInN3aXRjaCJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJzbG93d2Fsa2luZy55YXdfYmFzZSIsImxvY2FsIHZpZXciXSxbInNsaWRlciIsImFudGkgYWltIiwic2xvd3dhbGtpbmcub2Zmc2V0X2xlZnQiLDAuMF0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsInNsb3d3YWxraW5nLm9mZnNldF9yaWdodCIsMC4wXSxbImNvbWJvIiwiYW50aSBhaW0iLCJzbG93d2Fsa2luZy55YXdfbW9kaWZpZXIiLCJkaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsInNsb3d3YWxraW5nLnlhd19tb2RpZmllciIsMC4wLG51bGwsbnVsbCxbInlhd19tb2RpZmllcl9vZmZzZXQiLCJzbG93d2Fsa2luZy55YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsInNsb3d3YWxraW5nLmxlZnRfbGltaXQiLDYwLjBdLFsic2xpZGVyIiwiYW50aSBhaW0iLCJzbG93d2Fsa2luZy5yaWdodF9saW1pdCIsNjAuMF0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJzbG93d2Fsa2luZy5mYWtlX29wdGlvbnMiLFtdXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsInNsb3d3YWxraW5nLmZha2Vfb3B0aW9ucyIsMC4wLG51bGwsbnVsbCxbImRlbGF5X3RpY2siLCJzbG93d2Fsa2luZy5mYWtlX29wdGlvbnMiLCJzbGlkZXIiXV0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJzbG93d2Fsa2luZy5mYWtlX29wdGlvbnMiLDIyLjAsbnVsbCxudWxsLFsicmFuZG9tIiwic2xvd3dhbGtpbmcuZmFrZV9vcHRpb25zIiwic2xpZGVyIl1dLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwic2xvd3dhbGtpbmcuZmFrZV9vcHRpb25zIiwyMi4wLG51bGwsbnVsbCxbInN0b3AiLCJzbG93d2Fsa2luZy5mYWtlX29wdGlvbnMiLCJzbGlkZXIiXV0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJzbG93d2Fsa2luZy5mYWtlX29wdGlvbnMiLCJzdGF0aWMiLG51bGwsbnVsbCxbImRlbGF5X3RpY2tfdHlwZSIsInNsb3d3YWxraW5nLmZha2Vfb3B0aW9ucyIsImNvbWJvIl1dLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwic2xvd3dhbGtpbmcuZmFrZV9vcHRpb25zIiwyMi4wLG51bGwsbnVsbCxbInN0YXJ0Iiwic2xvd3dhbGtpbmcuZmFrZV9vcHRpb25zIiwic2xpZGVyIl1dLFsiY29tYm8iLCJhbnRpIGFpbSIsInNsb3d3YWxraW5nLmZyZWVzdGFuZGluZyIsIm9mZiJdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJzbG93d2Fsa2luZy5oaWRkZW5fbGMiLGZhbHNlXSxbInN3aXRjaCIsImFudGkgYWltIiwic2xvd3dhbGtpbmcuaGlkZGVuX2xjIiwiZGlzYWJsZWQiLG51bGwsbnVsbCxbInBpdGNoX21vZGUiLCJzbG93d2Fsa2luZy5oaWRkZW5fbGMiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwic2xvd3dhbGtpbmcuaGlkZGVuX2xjIiwwLjAsbnVsbCxudWxsLFsieWF3X3NsaWRlcl8xIiwic2xvd3dhbGtpbmcuaGlkZGVuX2xjIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJzbG93d2Fsa2luZy5oaWRkZW5fbGMiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9zbGlkZXIiLCJzbG93d2Fsa2luZy5oaWRkZW5fbGMiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsInNsb3d3YWxraW5nLmhpZGRlbl9sYyIsImRpc2FibGVkIixudWxsLG51bGwsWyJ5YXdfbW9kZSIsInNsb3d3YWxraW5nLmhpZGRlbl9sYyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJzbG93d2Fsa2luZy5oaWRkZW5fbGMiLDAuMCxudWxsLG51bGwsWyJ5YXdfc2xpZGVyXzIiLCJzbG93d2Fsa2luZy5oaWRkZW5fbGMiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsInNsb3d3YWxraW5nLmhpZGRlbl9sYyIsImFkdmFuY2VkIixudWxsLG51bGwsWyJzd2l0Y2hfdHlwZSIsInNsb3d3YWxraW5nLmhpZGRlbl9sYyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJqdW1waW5nLmVuYWJsZSIsdHJ1ZV0sWyJjb21ibyIsImFudGkgYWltIiwicnVubmluZy55YXdfYmFzZSIsImF0IHRhcmdldCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsImp1bXBpbmcueWF3X2Jhc2UiLCJhdCB0YXJnZXQiXSxbInNsaWRlciIsImFudGkgYWltIiwianVtcGluZy5vZmZzZXRfbGVmdCIsMC4wXSxbInNsaWRlciIsImFudGkgYWltIiwianVtcGluZy5vZmZzZXRfcmlnaHQiLDAuMF0sWyJjb21ibyIsImFudGkgYWltIiwianVtcGluZy55YXdfbW9kaWZpZXIiLCJkaXNhYmxlZCJdLFsiY29tYm8iLCJhbnRpIGFpbSIsImp1bXBpbmcueWF3X21vZGlmaWVyIiwtNjIuMCxudWxsLG51bGwsWyJ5YXdfbW9kaWZpZXJfb2Zmc2V0IiwianVtcGluZy55YXdfbW9kaWZpZXIiLCJzbGlkZXIiXV0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsImp1bXBpbmcubGVmdF9saW1pdCIsNjAuMF0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsImp1bXBpbmcucmlnaHRfbGltaXQiLDYwLjBdLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwianVtcGluZy5mYWtlX29wdGlvbnMiLFsiaml0dGVyIl1dLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwianVtcGluZy5mYWtlX29wdGlvbnMiLDAuMCxudWxsLG51bGwsWyJkZWxheV90aWNrIiwianVtcGluZy5mYWtlX29wdGlvbnMiLCJzbGlkZXIiXV0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJqdW1waW5nLmZha2Vfb3B0aW9ucyIsMjIuMCxudWxsLG51bGwsWyJyYW5kb20iLCJqdW1waW5nLmZha2Vfb3B0aW9ucyIsInNsaWRlciJdXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsImp1bXBpbmcuZmFrZV9vcHRpb25zIiwyMi4wLG51bGwsbnVsbCxbInN0b3AiLCJqdW1waW5nLmZha2Vfb3B0aW9ucyIsInNsaWRlciJdXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsImp1bXBpbmcuZmFrZV9vcHRpb25zIiwic3RhdGljIixudWxsLG51bGwsWyJkZWxheV90aWNrX3R5cGUiLCJqdW1waW5nLmZha2Vfb3B0aW9ucyIsImNvbWJvIl1dLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwianVtcGluZy5mYWtlX29wdGlvbnMiLDIyLjAsbnVsbCxudWxsLFsic3RhcnQiLCJqdW1waW5nLmZha2Vfb3B0aW9ucyIsInNsaWRlciJdXSxbImNvbWJvIiwiYW50aSBhaW0iLCJqdW1waW5nLmZyZWVzdGFuZGluZyIsIm9mZiJdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJqdW1waW5nLmhpZGRlbl9sYyIsdHJ1ZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsImp1bXBpbmcuaGlkZGVuX2xjIiwiZGlzYWJsZWQiLG51bGwsbnVsbCxbInBpdGNoX21vZGUiLCJqdW1waW5nLmhpZGRlbl9sYyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJqdW1waW5nLmhpZGRlbl9sYyIsLTkwLjAsbnVsbCxudWxsLFsieWF3X3NsaWRlcl8xIiwianVtcGluZy5oaWRkZW5fbGMiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsImp1bXBpbmcuaGlkZGVuX2xjIiwtMTUuMCxudWxsLG51bGwsWyJwaXRjaF9zbGlkZXIiLCJqdW1waW5nLmhpZGRlbl9sYyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwianVtcGluZy5oaWRkZW5fbGMiLCJkaXNhYmxlZCIsbnVsbCxudWxsLFsieWF3X21vZGUiLCJqdW1waW5nLmhpZGRlbl9sYyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJqdW1waW5nLmhpZGRlbl9sYyIsOTAuMCxudWxsLG51bGwsWyJ5YXdfc2xpZGVyXzIiLCJqdW1waW5nLmhpZGRlbl9sYyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwianVtcGluZy5oaWRkZW5fbGMiLCJhZHZhbmNlZCIsbnVsbCxudWxsLFsic3dpdGNoX3R5cGUiLCJqdW1waW5nLmhpZGRlbl9sYyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcgYWlyLmVuYWJsZSIsdHJ1ZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsImRvcm1hbnRfYWltYm90IixmYWxzZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsImRvcm1hbnRfYWltYm90IiwxLjAsbnVsbCxudWxsLFsiZGFtYWdlIiwiZG9ybWFudF9haW1ib3QiLCJzbGlkZXIiXV0sWyJjb21ibyIsImFudGkgYWltIiwiY3JvdWNoaW5nIGFpci55YXdfYmFzZSIsImF0IHRhcmdldCJdLFsic2xpZGVyIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcgYWlyLm9mZnNldF9sZWZ0IiwtMzkuMF0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsImNyb3VjaGluZyBhaXIub2Zmc2V0X3JpZ2h0IiwzNC4wXSxbImNvbWJvIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcgYWlyLnlhd19tb2RpZmllciIsImRpc2FibGVkIl0sWyJjb21ibyIsImFudGkgYWltIiwiY3JvdWNoaW5nIGFpci55YXdfbW9kaWZpZXIiLC02MC4wLG51bGwsbnVsbCxbInlhd19tb2RpZmllcl9vZmZzZXQiLCJjcm91Y2hpbmcgYWlyLnlhd19tb2RpZmllciIsInNsaWRlciJdXSxbInNsaWRlciIsImFudGkgYWltIiwiY3JvdWNoaW5nIGFpci5sZWZ0X2xpbWl0Iiw2MC4wXSxbImNvbWJvIiwiYW50aSBhaW0iLCJhY3RpdmVfY29uZGl0aW9uIiwiY3JvdWNoaW5nIGFpciJdLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwiY3JvdWNoaW5nIGFpci5mYWtlX29wdGlvbnMiLFsiaml0dGVyIl1dLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwiY3JvdWNoaW5nIGFpci5mYWtlX29wdGlvbnMiLDMyLjAsbnVsbCxudWxsLFsiZGVsYXlfdGljayIsImNyb3VjaGluZyBhaXIuZmFrZV9vcHRpb25zIiwic2xpZGVyIl1dLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwiY3JvdWNoaW5nIGFpci5mYWtlX29wdGlvbnMiLDIyLjAsbnVsbCxudWxsLFsicmFuZG9tIiwiY3JvdWNoaW5nIGFpci5mYWtlX29wdGlvbnMiLCJzbGlkZXIiXV0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcgYWlyLmZha2Vfb3B0aW9ucyIsMjIuMCxudWxsLG51bGwsWyJzdG9wIiwiY3JvdWNoaW5nIGFpci5mYWtlX29wdGlvbnMiLCJzbGlkZXIiXV0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJjcm91Y2hpbmcgYWlyLmZha2Vfb3B0aW9ucyIsInN0YXRpYyIsbnVsbCxudWxsLFsiZGVsYXlfdGlja190eXBlIiwiY3JvdWNoaW5nIGFpci5mYWtlX29wdGlvbnMiLCJjb21ibyJdXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsImNyb3VjaGluZyBhaXIuZmFrZV9vcHRpb25zIiwyMi4wLG51bGwsbnVsbCxbInN0YXJ0IiwiY3JvdWNoaW5nIGFpci5mYWtlX29wdGlvbnMiLCJzbGlkZXIiXV1d")
    end
    if text == "//share" or text == "//s" or text == "//share " or text == "//s " then
        configs.parse_data()
    end
    if text == "//import" or text == "//i" or text == "//import " or text == "//i " then
        configs.paste_data(clipboard.get())
    end
end)

local count_shots = 0
local hitlogs = {}

local sauron_logs = {} do
    sauron_logs.list = {}
    sauron_logs.render = function()
        local x, y = (references.main["Screen size"].x * 0.5), (references.main["Screen size"].y + 32)
        local offset = 0
        local color_t = menu["anti aim"].logs_on_screen[0].clr_notify:get()
        for i = 1, #sauron_logs.list do
            local object = sauron_logs.list[i]
            if ((object.timeout + 4) > globals.realtime and not (#sauron_logs.list > 7 and i < (#sauron_logs.list - 7))) then
                object.alpha = smooth.lerp(object.alpha, 255, 3)
                object.offset[1] = smooth.unclamped_lerp(object.offset[1], 255, 5)
                object.offset[2] = smooth.unclamped_lerp(object.offset[2], 0, 5)
                object.offset[3] = smooth.unclamped_lerp(object.offset[3], 255, 3)
            else
                object.alpha = smooth.lerp(object.alpha, -1, 8)
                object.offset[1] = smooth.unclamped_lerp(object.offset[1], 255, 5)
                object.offset[2] = smooth.unclamped_lerp(object.offset[2], 255, 5)
                object.offset[3] = smooth.unclamped_lerp(object.offset[3], 128, 3)
                if (object.alpha < 0) then
                    object.remove = true
                end
            end
            local alpha = {
                self = (object.alpha / 255),
                [1] = (object.offset[1] / 255),
                [2] = (object.offset[2] / 255),
                [3] = (object.offset[3] / 255),
            }
            local size = (render.measure_text(1, nil,  object.content).x * 0.5 + 15)
            local position = vector(x, y + offset * alpha[1] + (32 * alpha[2]) - (64 * alpha[3]))
            render.rect(position - vector(size, 12), position + vector(size, 12), color(16, 16, 16, color_t.a * alpha.self), 8)
            render.rect_outline(position - vector(size, 12), position + vector(size, 12), color_t:alpha_modulate(200 * alpha.self), 1.25, 8)
            render.text(1, position, color(255, 255, 255, 255 * alpha.self), "c", object.content)
            offset = (offset - (32 * alpha.self))
        end
        for i = 1, #sauron_logs.list do
            local object = sauron_logs.list[i]
            if (not object or object.remove) then
                table.remove(sauron_logs.list, i)
            end
        end
    end
    sauron_logs.push = function(text)
        table.insert(sauron_logs.list, {
            content = text,
            timeout = globals.realtime,
            alpha = 0,
            offset = {
                [1] = -255,
                [2] = 0,
                [3] = 0,
            },
            remove = false
        })
    end
end

menu["anti aim"].potnie_opcii:set_callback(function(el)
    menu["anti aim"].potnie_opcii[0].air_lag:visibility(el:get("cross exploit"))
    menu["anti aim"].potnie_opcii[0].selected:visibility(el:get("automatic grenade release"))
    menu["anti aim"].potnie_opcii[0].damage:visibility(el:get("automatic grenade release"))
    menu["anti aim"].potnie_opcii[0].speed:visibility(el:get("automatic grenade release"))
end, true)

local is_local_player_valid = function()
    local local_player = entity.get_local_player()
    if not local_player then return false, nil end

    if not globals.is_in_game and not globals.is_connected then return false, nil end
    if not local_player:is_alive() then return false, nil end

    return true, local_player
end

local all_anti_aim_functions = {}
all_anti_aim_functions.main_constructor = {}
all_anti_aim_functions.main_constructor.converter = {
    ["global"] = "G",
    ["standing"] = "S",
    ["running"] = "R",
    ["crouching"] = "C",
    ["slowwalking"] = "SW",
    ["jumping"] = "J",
    ["crouching air"] = "AC"
}
all_anti_aim_functions.main_constructor.converter_v2 = {
    ["G"] = "global",
    ["S"] = "standing",
    ["M"] = "running",
    ["SW"] = "slowwalking",
    ["C"] = "crouching",
    ["A"] = "jumping",
    ["AC"] = "crouching air"
}
all_anti_aim_functions.main_constructor.data = {
    manual = {
        ["left"] = -90,
        ["right"] = 90,
        ["forward"] = 180
    },
    high_ground = false,
    low_ground = false,
    legit_aa = false,
    weapon_switch = false,
    bruteforce = false,
    safe_mode = false,
    dangerous_mode = false,
    anti_aim = {
        jitter_speed_b = {
            state = false,
            tick = 0
        },
        jitter_speed = {
            state = false,
            tick = 0
        }
    }
}
all_anti_aim_functions.main_constructor.presets = {
    ["Safe"] = {
        ["S"] =  { 14, "Disabled", 0, 60, 60, ""},
        ["M"] =  { 12, "Disabled", 0, 60, 60, ""},
        ["SW"] = { 11, "Disabled", 0, 60, 60, ""},
        ["C"] =  { 10, "Disabled", 0, 60, 60, ""},
        ["A"] =  { 15, "Disabled", 0, 60, 60, ""},
        ["AC"] = { 15, "Disabled", 0, 60, 60, ""}
    }
}
all_anti_aim_functions.main_constructor.brute_tick = globals.tickcount
all_anti_aim_functions.main_constructor.vars = { is_anti_bruteforcing = false, anti_bruteforcing_timer = globals.realtime }
all_anti_aim_functions.main_constructor.is_anti_bruteforce_applied = function(bullet_vector, enemy_eye_position, self_eye_position)
    local is_local_player_valid, my_index = is_local_player_valid()
    if is_local_player_valid then
        local closest_point = bullet_vector:closest_ray_point(enemy_eye_position, self_eye_position)
        local bullet_distance = closest_point:dist(self_eye_position)
        if bullet_distance > 50 then
            return
        end
        if all_anti_aim_functions.main_constructor.brute_tick ~= globals.tickcount then
            if all_anti_aim_functions.main_constructor.condition ~= "C" then
                all_anti_aim_functions.main_constructor.data.anti_aim["Inverter"] = not all_anti_aim_functions.main_constructor.data.anti_aim["Inverter"]
                if menu["anti aim"].logs_on_screen:get("notify") and menu["anti aim"].logs_on_screen[0].brute_logs:get() then
                    local text = ("\a%s[HELLYAW]\aDEFAULT Anti-aim switched due to enemy shot [side: %s | choke: %s | stage: %s]"):format(
                        menu["anti aim"].logs_on_screen[0].clr_notify:get():alpha_modulate(255):to_hex(),
                        all_anti_aim_functions.main_constructor.data.anti_aim["Inverter"],
                        globals.choked_commands,
                        math.random(1, 10)
                    )
                    sauron_logs.push(text)
                end
                all_anti_aim_functions.main_constructor.brute_tick = globals.tickcount
            end
        end
    end
end
all_anti_aim_functions.main_constructor.trigger_anti_bruteforce = function(event)
    local is_local_player_valid, my_index = is_local_player_valid()
    if is_local_player_valid then
        local self_eye_position = my_index:get_origin()
        local attacker = entity.get(event.userid, true)
        if not attacker or attacker == my_index or not attacker:is_enemy() or attacker:is_dormant() then
            return
        end
        local bullet_vector = vector(event.x, event.y, event.z)
        local enemy_eye_position = attacker:get_origin()
        all_anti_aim_functions.main_constructor.is_anti_bruteforce_applied(bullet_vector, enemy_eye_position, self_eye_position)
    end
end
all_anti_aim_functions.main_constructor.calculate_angles = function(local_x, local_y, enemy_x, enemy_y)
    local delta_y = local_y - enemy_y
    local delta_x = local_x - enemy_x

    local relative_yaw = math.atan(delta_y / delta_x)
    relative_yaw = math.normalize_yaw(relative_yaw * 180 / math.pi)

    if delta_x >= 0 then
        relative_yaw = math.normalize_yaw(relative_yaw + 180)
    end

    return relative_yaw
end
all_anti_aim_functions.main_constructor.angle_to_vec = function(pitch, yaw)
    local p = pitch / 180 * math.pi
    local y = yaw / 180 * math.pi

    local sin_p = math.sin(p)
    local cos_p = math.cos(p)
    local sin_y = math.sin(y)
    local cos_y = math.cos(y)

    return {
        cos_p * cos_y,
        cos_p * sin_y,
        -sin_p
    }
end
all_anti_aim_functions.main_constructor.update_enemies = function()
    local is_local_player_valid, my_index = is_local_player_valid()
    if is_local_player_valid then
        local fov_enemy, maximum_fov = nil, 180
        local enemies = entity.get_players(true, true)
        for i = 1, #enemies do
            local enemy = enemies[i]
            if enemy:is_alive() then
                local my_origin = my_index:get_origin()
                local enemy_origin = enemy:get_origin()
                local world_to_screen = (
                    my_origin.x - enemy_origin.x == 0 and my_origin.y - enemy_origin.z == 0
                ) and 0 or math.deg(
                    math.atan2(
                        my_origin.y - enemy_origin.y, my_origin.x - enemy_origin.x
                    )
                ) - my_index:get_eye_position().y + 180
                local calculated_fov = math.abs(math.normalize_yaw(world_to_screen))
                if not fov_enemy or calculated_fov <= maximum_fov then
                    fov_enemy = enemy
                    maximum_fov = calculated_fov
                end
            end
        end
        return ({
            enemy = fov_enemy,
            fov = maximum_fov
        })
    end
end
all_anti_aim_functions.main_constructor.get_hit_side = function()
    local is_local_player_valid, my_index = is_local_player_valid()
    if is_local_player_valid then
        local data, current_enemy = all_anti_aim_functions.main_constructor.update_enemies(), nil
        if data ~= nil then current_enemy = data.enemy end
        if current_enemy ~= nil then
            local predict_damage = function(x, y, z)
                local a, b, c = {}, {}, {}
                local enemy_head_position = current_enemy:get_hitbox_position(1)
                local ticks = 40
                a[1], b[1], c[1] = enemy_head_position.x, enemy_head_position.y, enemy_head_position.z
                a[2], b[2], c[2] = enemy_head_position.x + ticks, enemy_head_position.y, enemy_head_position.z
                a[3], b[3], c[3] = enemy_head_position.x - ticks, enemy_head_position.y, enemy_head_position.z

                a[4], b[4], c[4] = enemy_head_position.x, enemy_head_position.y + ticks, enemy_head_position.z
                a[5], b[5], c[5] = enemy_head_position.x, enemy_head_position.y - ticks, enemy_head_position.z
                a[6], b[6], c[6] = enemy_head_position.x, enemy_head_position.y, enemy_head_position.z + ticks
                a[7], b[7], c[7] = enemy_head_position.x, enemy_head_position.y, enemy_head_position.z - ticks
                for i = 1, 7, 1 do
                    local damage = 0
                    local trace_damage = utils.trace_bullet(
                        current_enemy, vector(a[i], b[i], c[i]), vector(x, y, z)
                    )
                    if trace_damage > damage then
                        damage = trace_damage
                    end

                    return damage
                end
            end
            local my_eye_position = my_index:get_eye_position()
            local enemy_head_position = current_enemy:get_hitbox_position(0)
            local calculated_yaw = all_anti_aim_functions.main_constructor.calculate_angles(
                my_eye_position.x, my_eye_position.y, enemy_head_position.x, enemy_head_position.y
            )
            local left_direction_x, left_direction_y = all_anti_aim_functions.main_constructor.angle_to_vec(
                0, (calculated_yaw + 90)
            ), all_anti_aim_functions.main_constructor.angle_to_vec(0, (calculated_yaw + 90))
            local right_direction_x, right_direction_y = all_anti_aim_functions.main_constructor.angle_to_vec(
                0, (calculated_yaw - 90)
            ), all_anti_aim_functions.main_constructor.angle_to_vec(0, (calculated_yaw - 90))

            local rend_x = my_eye_position.x + right_direction_x[1] * 10
            local rend_y = my_eye_position.y + right_direction_y[1] * 10
            local lend_x = my_eye_position.x + left_direction_x[1] * 10
            local lend_y = my_eye_position.y + left_direction_y[1] * 10
            local rend_x_2 = my_eye_position.x + right_direction_x[1] * 100
            local rend_y_2 = my_eye_position.y + left_direction_y[1] * 100
            local lend_x_2 = my_eye_position.x + left_direction_x[1] * 100
            local lend_y_2 = my_eye_position.y + left_direction_y[1] * 100

            local left_trace = predict_damage(rend_x, rend_y, my_eye_position.z)
            local right_trace = predict_damage(lend_x, lend_y, my_eye_position.z)
            local left_trace_2 = predict_damage(rend_x_2, rend_y_2, my_eye_position.z)
            local right_trace_2 = predict_damage(lend_x_2, lend_y_2, my_eye_position.z)
            local hit_side = (
                (left_trace > 0 or right_trace > 0 or left_trace_2 > 0 or right_trace_2 > 0) and
                (
                    left_trace > right_trace and 0.5 or right_trace > left_trace and -0.5
                    or left_trace_2 > right_trace_2 and 1 or right_trace_2 > left_trace_2 -1
                ) or 0.0
            )

            return hit_side
        end
    end
end

all_anti_aim_functions.main_constructor.is_doubletap = function()
    local is_local_player_valid, my_index = is_local_player_valid()
    if not is_local_player_valid then return end
    local weapon = my_index:get_player_weapon()
    if not weapon then
        return false
    end
    local next_attack = my_index["m_flNextAttack"] + 0.25
    local jewfag = weapon.m_flNextPrimaryAttack
    if jewfag == nil then
        return
    end
    local next_primary_attack = jewfag + 0.3
    if next_attack == nil or next_primary_attack == nil then
        return false
    end
    return next_attack - globals.curtime < 0 and next_primary_attack - globals.curtime < 0
end

all_anti_aim_functions.main_constructor.dynamic_fake_yaw = function()
    local is_local_player_valid, my_index = is_local_player_valid()
    if is_local_player_valid then
        local body_yaw_angle = 60
        if rage.antiaim:get_target() ~= nil then
            local lby_fraction = math.abs(my_index.m_flLowerBodyYawTarget / 180)
            local duck_amount = my_index.m_flDuckAmount
            local side = all_anti_aim_functions.main_constructor.get_hit_side()
            if entity.get_threat() ~= nil and not entity.get_threat():is_dormant() then
                if duck_amount > 0.4 then
                    body_yaw_angle = 58
                else
                    if lby_fraction > 0.5 then
                        body_yaw_angle = 60
                    else
                        body_yaw_angle = 58
                    end
                end
            else
                if duck_amount > 0.4 and not all_anti_aim_functions.main_constructor.condition == "A" then
                    body_yaw_angle = 45
                else
                    if lby_fraction > 0.5 then
                        body_yaw_angle = math.floor(58 * lby_fraction)
                    else
                        if side == 0.5 or side == -0.5 then
                            body_yaw_angle = 35
                        elseif side == 1 or side == -1 then
                            body_yaw_angle = 15
                        else
                            body_yaw_angle = 58
                        end
                    end
                end
            end
        end
        return body_yaw_angle
    end
end
all_anti_aim_functions.main_constructor.condition = "G"
all_anti_aim_functions.main_constructor.reversed_yaw_offset = function()
    local is_local_player_valid, my_index = is_local_player_valid()
    if is_local_player_valid then
        local yaw_path = 15
        if entity.get_threat() ~= nil then
            local lby_fraction = math.abs(my_index.m_flLowerBodyYawTarget / 180)
            local duck_amount = my_index.m_flDuckAmount
            local side = all_anti_aim_functions.main_constructor.get_hit_side()
            if not entity.get_threat():is_dormant() then
                if duck_amount > 0.4 then
                    yaw_path = 20
                else
                    yaw_path = lby_fraction > 0.5 and -20 or 25
                end
            else
                if duck_amount > 0.4 and not all_anti_aim_functions.main_constructor.condition == "A" then
                    yaw_path = 0
                else
                    if lby_fraction > 0.5 then
                        yaw_path = 0
                    else
                        if side == 0.5 or side == -0.5 then
                            yaw_path = globals.tickcount % 4 >= 2 and -15 or 15
                        elseif side == 1 or side == -1 then
                            yaw_path = -20
                        else
                            yaw_path = 15
                        end
                    end
                end
            end
        end
        return yaw_path
    end
end
all_anti_aim_functions.main_constructor.setup = function(table)
    local construction = all_anti_aim_functions.main_constructor
    local current_desync_angle = construction.dynamic_fake_yaw()
    references.list["Yaw offset"]:override(table[5] or construction.reversed_yaw_offset())
    references.list["Yaw modifier"]:override(table[1])
    references.list["Yaw modifier offset"]:override(table[2])
    references.list["Left limit"]:override(table[6] or current_desync_angle)
    references.list["Right limit"]:override(table[7] or current_desync_angle)
    references.list["Options"]:override(table[3])
    references.list["Inverter"]:override(menu["anti aim"].potnie_opcii:get("anti bruteforce") and all_anti_aim_functions.main_constructor.data.anti_aim["Inverter"] or table[4])
    references.list["Freestanding"]:override(table[8] or "Off")
end

all_anti_aim_functions.main_constructor.defensive_trigger = function(reference, local_player)
    local state = lib.anti_aim.condition.get()
    if menu["anti aim"].potnie_opcii:get("cross exploit") and menu["anti aim"].potnie_opcii[0].air_lag:get() then
        return false
    end
    if reference:get("crouch") and state == "C" then
        return true
    end
    if reference:get("air") and (state == "A" or state == "AC") then
        return true
    end
    if reference:get("slow motion") and state == "SW" then
        return true
    end
    if reference:get("moving") and state == "M" then
        return true
    end
    if reference:get("standing") and state == "S" then
        return true
    end
    if reference:get("weapon switch") and not all_anti_aim_functions.main_constructor.is_doubletap() then
        return true
    end
    if reference:get("threat mode") and entity.get_threat(true) ~= nil then
        return true
    end
    if reference:get("low velocity") and local_player["m_vecVelocity"]:length() < 160 and state ~= "S" and state ~= "SW" then
        return true
    end

    return false
end
all_anti_aim_functions.main_constructor.get_desync_side = function(index)
    local is_local_player_valid, my_index = is_local_player_valid()
    if not is_local_player_valid then return end

    if globals.choked_commands ~= 0 then
        return
    end
    local body_yaw = my_index.m_flPoseParameter[11] * 120 - 60

    return body_yaw > 0
end
all_anti_aim_functions.main_constructor.executor = function(cmd)
    local is_local_player_valid, my_index = is_local_player_valid()
    if is_local_player_valid then
        local data, current_enemy = all_anti_aim_functions.main_constructor.update_enemies(), nil
        if data ~= nil then
            current_enemy = data.enemy
        end
        local condition = lib.anti_aim.condition.get({
            (menu["anti aim"][("%s.%s"):format("standing", "enable")]:get() and "S" or ""),
            (menu["anti aim"][("%s.%s"):format("running", "enable")]:get() and "M" or ""),
            (menu["anti aim"][("%s.%s"):format("slowwalking", "enable")]:get() and "SW" or ""),
            (menu["anti aim"][("%s.%s"):format("crouching", "enable")]:get() and "C" or ""),
            (menu["anti aim"][("%s.%s"):format("jumping", "enable")]:get() and "A" or ""),
            (menu["anti aim"][("%s.%s"):format("crouching air", "enable")]:get() and "AC" or ""),
        })

        condition = all_anti_aim_functions.main_constructor.converter_v2[condition]
        local defensive_trigger = all_anti_aim_functions.main_constructor.defensive_trigger(menu["anti aim"].defensive_tweaks, my_index) or false
        ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override(ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"):get() and "On Peek" or (defensive_trigger and "Always On" or "On Peek"))
        ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"):override(defensive_trigger and "Break LC" or "Favor Fire Rate")
        local antiaim_data = all_anti_aim_functions.main_constructor.data
        local current_weapon = my_index:get_player_weapon()
        local weapon_data = nil
        if current_weapon ~= nil then
            weapon_data = current_weapon:get_weapon_info()
        end
        if current_enemy ~= nil then
            local local_head = my_index:get_hitbox_position(0)
            local enemy_head = current_enemy:get_hitbox_position(0)
            antiaim_data.high_ground = local_head.z > (enemy_head.z + 90)
            antiaim_data.low_ground = local_head.z < (enemy_head.z - 20)
        end
        references.list["Avoid backstab"]:override(true)
        if condition == "global" then
            condition = lib.anti_aim.condition.get()
            if not defensive_trigger then
                if menu["anti aim"].manual_mode:get() == "none" then
                    all_anti_aim_functions.main_constructor.setup({"Disabled", 0, "", false})
                end
            end
            references.list["Hidden"]:override(defensive_trigger)
            if defensive_trigger then
                rage.antiaim:override_hidden_pitch(({-45, -25, -15, -5})[math.random(4)])
                rage.antiaim:override_hidden_yaw_offset(my_index["m_nTickBase"] % 3 ~= 1 and -90 or 90)
                all_anti_aim_functions.main_constructor.setup({
                    "Disabled",
                    0,
                    {"Jitter", "Randomize Jitter"},
                    false,
                    0,
                    condition == "C" and 45 or 60,
                    condition == "C" and 45 or 60,
                    (condition == "AC" or condition == "A") and "Peek Real" or "Off"
                })
            end
        else
            local aa_data = function(name, search, gear)
                if not gear then
                    if search then
                        return menu["anti aim"][("%s.%s"):format(condition, name)]:get(search)
                    else
                        return menu["anti aim"][("%s.%s"):format(condition, name)]:get()
                    end
                else
                    if search then
                        return menu["anti aim"][("%s.%s"):format(condition, name)]["gear"][gear]:get(search)
                    else
                        return menu["anti aim"][("%s.%s"):format(condition, name)]["gear"][gear]:get()
                    end
                end
            end
            if globals.choked_commands == 0 then
                local speed_invert do
                    if aa_data("fake_options", nil, "delay_tick_type") == "developer" then
                        speed_invert = utils.random_int(aa_data("fake_options", nil, "start"), aa_data("fake_options", nil, "stop")) - math.random(aa_data("fake_options", nil, "random"))
                    elseif aa_data("fake_options", nil, "delay_tick_type") == "static" then
                        speed_invert = aa_data("fake_options", nil, "delay_tick")
                    end
                end
                local jit_speed = math.ceil(16 / 100 * speed_invert)
                if antiaim_data.anti_aim.jitter_speed_b.tick > jit_speed then
                    antiaim_data.anti_aim.jitter_speed_b.state = not antiaim_data.anti_aim.jitter_speed_b.state
                    antiaim_data.anti_aim.jitter_speed_b.tick = 0
                end
                antiaim_data.anti_aim.jitter_speed_b.tick = antiaim_data.anti_aim.jitter_speed_b.tick + 1
                local desync_side do
                    if speed_invert ~= 0 then
                        desync_side = antiaim_data.anti_aim.jitter_speed_b.state
                    else
                        desync_side = all_anti_aim_functions.main_constructor.get_desync_side()
                    end
                end
                all_anti_aim_functions.main_constructor.setup({
                    (aa_data("yaw_modifier") == "random center" or aa_data("yaw_modifier") == "progressive") and "Center" or aa_data("yaw_modifier"),
                    (aa_data("yaw_modifier") == "progressive" and (aa_data("yaw_modifier", nil, "yaw_modifier_offset") == 0 and 0 or -40-((globals.curtime * 20) % math.abs(aa_data("yaw_modifier", nil, "yaw_modifier_offset"))))) or aa_data("yaw_modifier") == "random center" and -math.random(aa_data("yaw_modifier", nil, "yaw_modifier_offset")) or aa_data("yaw_modifier", nil, "yaw_modifier_offset"),
                    speed_invert ~= 0 and "" or aa_data("fake_options"),
                    (speed_invert ~= 0 and antiaim_data.anti_aim.jitter_speed_b.state or false),
                    desync_side and aa_data("offset_left") or aa_data("offset_right"),
                    aa_data("left_limit"),
                    aa_data("right_limit"),
                    aa_data("freestanding")
                })
                references.list["Hidden"]:override(rage.exploit:get() == 1 and aa_data("hidden_lc") or false)
                references.list["Yaw base"]:override(aa_data("yaw_base"))
                if aa_data("hidden_lc") then
                    if aa_data("hidden_lc", nil, "pitch_mode") == "custom" then
                        rage.antiaim:override_hidden_pitch(aa_data("hidden_lc", nil, "pitch_slider"))
                    elseif aa_data("hidden_lc", nil, "pitch_mode") == "random ways" then
                        rage.antiaim:override_hidden_pitch(({math.random(-89, 89), -45, 0})[math.random(3)])
                    elseif aa_data("hidden_lc", nil, "pitch_mode") == "hellyaw" then
                        rage.antiaim:override_hidden_pitch(-50 + math.random(33))
                    end

                    if aa_data("hidden_lc", nil, "yaw_mode") == "custom" then
                        if aa_data("hidden_lc", nil, "switch_type") == "advanced" then
                            rage.antiaim:override_hidden_yaw_offset(my_index["m_nTickBase"] % 3 ~= 1 and aa_data("hidden_lc", nil, "yaw_slider_1") or aa_data("hidden_lc", nil, "yaw_slider_2"))
                        else
                            rage.antiaim:override_hidden_yaw_offset(rage.antiaim:inverter() and aa_data("hidden_lc", nil, "yaw_slider_1") or aa_data("hidden_lc", nil, "yaw_slider_2"))
                        end
                    elseif aa_data("hidden_lc", nil, "yaw_mode") == "random ways" then
                        rage.antiaim:override_hidden_yaw_offset(globals.tickcount % 3 >= 2 and ( globals.tickcount * 75 ) % 180 or -(( globals.tickcount * 75 ) % 180 ))
                    elseif aa_data("hidden_lc", nil, "yaw_mode") == "ribalka" then
                        rage.antiaim:override_hidden_yaw_offset(globals.tickcount % 4 >= 2 and math.random(-75, -180) or math.random(75, 180))
                    end
                end
            end
        end
        if menu["anti aim"].potnie_opcii:get("cross exploit") then
            cvar.sv_maxusrcmdprocessticks:int(19)
            if ui.get_alpha() > 0 then
                ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):override()
                ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"):override()
            else
                if menu["anti aim"].potnie_opcii[0].air_lag:get() and (references.list_need["Double tap"]:get() or references.list_need["Hide shots"]:get()) then
                    all_anti_aim_functions.main_constructor.setup({"Center", -60, {"Jitter"}, false, 0})
                    ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"):override(17)
                    ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):override(globals.tickcount % 18 == 0)
                else
                    ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"):override()
                    ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):override()
                end
            end
        end
        if menu["anti aim"].manual_mode:get() ~= "none" then
            if menu["anti aim"].manual_mode[0].defensive_aa:get() then
                rage.antiaim:override_hidden_pitch(0)
                rage.antiaim:override_hidden_yaw_offset(180)
            end
            references.list["Hidden"]:override(menu["anti aim"].manual_mode[0].defensive_aa:get())
            references.list["Freestanding NL"]:override(false)
            references.list["Yaw base"]:override("Local View")
            if menu["anti aim"].manual_mode[0].option:get() then references.list["Options"]:override("") end
            all_anti_aim_functions.main_constructor.setup(
                {"Disabled", 0, "", false, antiaim_data.manual[menu["anti aim"].manual_mode:get()], menu["anti aim"].manual_mode[0].option:get() and 0 or 60, menu["anti aim"].manual_mode[0].option:get() and 0 or 60})
        else
            references.list["Freestanding NL"]:override()
        end
        if references.list["Freestanding NL"]:get() then
            references.list["Hidden"]:override(false)
        end
        if menu["anti aim"].manual_mode[0].option_f:get() and references.list["Freestanding NL"]:get() and menu["anti aim"].manual_mode:get() == "none" then
            references.list["Left limit"]:override(0)
            references.list["Right limit"]:override(0)
            references.list["Yaw offset"]:override(0)
            references.list["Options"]:override("")
        end

        if (current_weapon and weapon_data) and (weapon_data.weapon_name == "weapon_knife" or weapon_data.weapon_name == "weapon_taser") and (condition == "crouching air" or condition == "AC") then
            all_anti_aim_functions.main_constructor.setup({"Disabled", 0, "", false, 25})
        end
        references.list["Freestanding NL"]:set(menu["anti aim"].freestand_nl:get())
        references.list["Freestanding modifiers"]:set(menu["anti aim"].freestand_nl[0].disable_yaw_modifiers:get())
        references.list["Freestanding body"]:set(menu["anti aim"].freestand_nl[0].body_freestanding:get())
    end
end

all_anti_aim_functions.main_constructor.edge_bug = {}
all_anti_aim_functions.main_constructor.edge_bug.in_duck = nil
all_anti_aim_functions.main_constructor.edge_bug.createmove = function(cmd)
    if all_anti_aim_functions.main_constructor.edge_bug.in_duck ~= nil then
        cmd.in_duck = all_anti_aim_functions.main_constructor.edge_bug.in_duck
    end
end
all_anti_aim_functions.main_constructor.edge_bug.pre_render = function()
    all_anti_aim_functions.main_constructor.edge_bug.in_duck = nil
    local is_local_player_valid, my_index = is_local_player_valid()
    if is_local_player_valid then
        local origin = my_index:get_origin()
        local velocity_z = my_index["m_vecVelocity"].z
        if velocity_z <= -500 then
            local fraction = utils.trace_line(origin, origin + vector(0, 0, -256), local_player).fraction
            if fraction <= 0.26 and fraction > 0.05 then
                all_anti_aim_functions.main_constructor.edge_bug.in_duck = true
            elseif fraction <= 0.04 then
                all_anti_aim_functions.main_constructor.edge_bug.in_duck = false
            end
        end
    end
end
ui.find("Aimbot", "Anti Aim", "Fake Lag"):disabled(false)
ui.find("Aimbot", "Anti Aim", "Misc"):disabled(false)
ui.find("Aimbot", "Anti Aim", "Angles"):disabled(false)

all_anti_aim_functions.main_constructor.super_toss = {}

all_anti_aim_functions.main_constructor.super_toss.active = false
all_anti_aim_functions.main_constructor.super_toss.check_active = function()
    all_anti_aim_functions.main_constructor.super_toss.active = false
    local is_local_player_valid, my_index = is_local_player_valid()
    if not is_local_player_valid then
        return
    end
    if my_index.m_MoveType == 8 then
        return
    end
    local weapon = my_index:get_player_weapon()
    if weapon == nil then
        return
    end
    local weapon_info = weapon:get_weapon_info()
    if weapon_info == nil then
        return
    end
    if weapon_info.weapon_type ~= 9 then
        return
    end
    all_anti_aim_functions.main_constructor.super_toss.active = true
end

ffi.cdef([[
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef struct {
        float x;
        float y;
        float z;
    } vector_t;
    
    typedef struct {
        char  pad_0000[20];
        int order; //0x0014
        int sequence; //0x0018
        float prev_cycle; //0x001C
        float weight; //0x0020
        float weight_delta_rate; //0x0024
        float playback_rate; //0x0028
        float cycle; //0x002C
        void *owner; //0x0030
        char  pad_0038[4]; //0x0034
    } c_animlayers;
]])
all_anti_aim_functions.main_constructor.super_toss.ang_vec = function(ang)
    return vector(math.cos(ang.x * math.pi / 180) * math.cos(ang.y * math.pi / 180), math.cos(ang.x * math.pi / 180) * math.sin(ang.y * math.pi / 180), -math.sin(ang.x * math.pi / 180))
end
all_anti_aim_functions.main_constructor.super_toss.last_angles = vector(0, 0, 0)
all_anti_aim_functions.main_constructor.super_toss.target_angles = vector(0, 0, 0)

all_anti_aim_functions.main_constructor.super_toss.on_pre_render = function()
    all_anti_aim_functions.main_constructor.super_toss.check_active()
    all_anti_aim_functions.main_constructor.super_toss.last_angles = render.camera_angles()
    if all_anti_aim_functions.main_constructor.super_toss.active == true and common.is_in_thirdperson() == false then
        render.camera_angles(all_anti_aim_functions.main_constructor.super_toss.target_angles)
    end
end
all_anti_aim_functions.main_constructor.super_toss.on_override_view = function(zv)
    if menu["anti aim"].potnie_opcii:get("super toss") then
        if all_anti_aim_functions.main_constructor.super_toss.active == true then
            zv.view = all_anti_aim_functions.main_constructor.super_toss.last_angles
            render.camera_angles(all_anti_aim_functions.main_constructor.super_toss.last_angles)
        end
    end
end
all_anti_aim_functions.main_constructor.super_toss.on_createmove = function(cmd)
    if all_anti_aim_functions.main_constructor.super_toss.active ~= true then
        return
    end
    local is_local_player_valid, my_index = is_local_player_valid()
    if not is_local_player_valid then
        return
    end
    local weapon = my_index:get_player_weapon()

    if not weapon or weapon.m_bPinPulled == nil then
        return
    end

    local throw_time = weapon.m_fThrowTime

    if throw_time > 0 and throw_time < globals.curtime then
        return
    end

    local weapon_info = weapon:get_weapon_info()

    if weapon_info == nil then
        return
    end

    local lp_addr = ffi.cast("uintptr_t", my_index[0])

    local ang_throw = vector(cmd.view_angles.x, cmd.view_angles.y, 0)
    ang_throw.x = ang_throw.x - (90 - math.abs(ang_throw.x)) * 10 / 90
    ang_throw = all_anti_aim_functions.main_constructor.super_toss.ang_vec(ang_throw)

    local throw_strength = math.clamp(weapon.m_flThrowStrength or 0, 0, 1)
    local fl_velocity = math.clamp(weapon_info.throw_velocity * 0.9, 15, 750)
    fl_velocity = fl_velocity * (throw_strength * 0.7 + 0.3)

    local localplayer_velocity = ffi.cast("vector_t*", lp_addr + 0x94)[0]
    localplayer_velocity = vector(localplayer_velocity.x, localplayer_velocity.y, localplayer_velocity.z)
    local vec_throw = (ang_throw * fl_velocity + localplayer_velocity * 1.45)
    vec_throw = vec_throw:angles()
    local yaw_difference = cmd.view_angles.y - vec_throw.y
    while yaw_difference > 180 do
        yaw_difference = yaw_difference - 360
    end
    while yaw_difference < -180 do
        yaw_difference = yaw_difference + 360
    end
    local pitch_difference = cmd.view_angles.x - vec_throw.x - 10
    while pitch_difference > 90 do -- вронг? вронг
        pitch_difference = pitch_difference - 45
    end
    while pitch_difference < -90 do
        pitch_difference = pitch_difference + 45
    end
    all_anti_aim_functions.main_constructor.super_toss.target_angles.y = cmd.view_angles.y + yaw_difference
    cmd.view_angles.y = cmd.view_angles.y + yaw_difference
    all_anti_aim_functions.main_constructor.super_toss.target_angles.x = math.clamp(cmd.view_angles.x + pitch_difference, -89, 89)
    cmd.view_angles.x = math.clamp(cmd.view_angles.x + pitch_difference, -89, 89)
end

all_anti_aim_functions.main_constructor.avoid_collisions = {}
all_anti_aim_functions.main_constructor.avoid_collisions.createmove = function(cmd)
    local is_local_player_valid, my_index = is_local_player_valid()
    if is_local_player_valid then
        local dm = 15 + 3 * 3
        local camera_angles = render.camera_angles()
        local yaw = camera_angles.y
        local origin = my_index["m_vecOrigin"]
        local velocity = my_index["m_vecVelocity"]:length()
        local min = math.huge
        local val = math.huge
        for i = 1, 180 do
            local dir = vector():angles(vector(0, (yaw + i - 90), 0))
            local end_pos = vector(origin.x + dir.x * 70, origin.y + dir.y * 70, origin.z + 60)
            local tracer = utils.trace_line(origin, end_pos, nil, nil, 1)
            if origin:dist(tracer.end_pos) < min then
                min = origin:dist(tracer.end_pos)
                val = i
            end
        end

        if min < 25 + dm and cmd.in_jump and not (cmd.in_moveright or cmd.in_moveleft or cmd.in_back or cmd.in_duck or cmd.in_speed) then
            cmd.forwardmove = math.abs(velocity * math.cos(math.rad(val)))
            cmd.sidemove = (velocity * math.sin(math.rad(val)) * (math.abs(val - 90) < 40 and (25 + dm - min) / 15 or 1)) * (val >= 90 and 1 or -1)
        end
    end
end
local dormant_aimbot = {} do
    dormant_aimbot.utils = {data = { miss_info = { }, shot_info = { }, round_started = 0 } }
    dormant_aimbot.utils.auto_stop = function(cmd, speed)
        local min_speed = math.sqrt((cmd.forwardmove * cmd.forwardmove) + (cmd.sidemove * cmd.sidemove))
        if (speed <= 0 or min_speed <= 0) then return end
        if (cmd.in_duck) then
            speed = (speed * 2.94117647)
        end
        if (min_speed <= speed) then return end
        local speed_factor = (speed / min_speed)
        cmd.forwardmove = (cmd.forwardmove * speed_factor)
        cmd.sidemove = (cmd.sidemove * speed_factor)
    end
    dormant_aimbot.utils.calc_angle = function(vector_1, vector_2)
        local result = vector(0, 0, 0)
        local vector_3 = vector((vector_1.x - vector_2.x), (vector_1.y - vector_2.y), (vector_1.z - vector_2.z))
        local hyp = math.sqrt((vector_3.x * vector_3.x) + (vector_3.y * vector_3.y))
        result.x = (math.atan(vector_3.z / hyp) * (180 / math.pi))
        result.y = (math.atan(vector_3.y / vector_3.x) * (180 / math.pi))
        result.z = 0
        if (vector_3.x >= 0) then
            result.y = (result.y + 180)
        end
        return result
    end
    dormant_aimbot.utils.extrapolate_position = function(pos,ticks,player)
        local xyi = player.m_vecVelocity
        if xyi == nil then return end
        for _ = 0, ticks do
            pos.x = pos.x - (xyi.x * globals.tickinterval)
            pos.y = pos.y - (xyi.y * globals.tickinterval)
            pos.z = pos.z - (xyi.z * globals.tickinterval)
        end
        return pos
    end
    events.createmove(function(cmd)
        if not menu["anti aim"].dormant_aimbot:get() then return end
        local is_local_player_valid, my_index = is_local_player_valid()
        if is_local_player_valid then
            local lp_eye_position = my_index:get_eye_position()
            entity.get_players(true, true, function(player)
                if not player:is_dormant() or not player:is_alive() then
                    dormant_aimbot.utils.data.miss_info[player:get_index()] = nil
                    return
                end
                if player:is_alive() and player.m_iHealth > 0 then
                    local hitbox_position = player:get_origin()
                    if dormant_aimbot.utils.data.miss_info[player:get_index()] == nil then
                        dormant_aimbot.utils.data.miss_info[player:get_index()] = {
                            missed = 0, last_origin = hitbox_position:floor(), new_shot_pos = (player:get_hitbox_position(0) + vector(0, 0, math.random(-8, -4)))
                        }
                    end

                    if hitbox_position:floor() ~= dormant_aimbot.utils.data.miss_info[player:get_index()].last_origin then
                        dormant_aimbot.utils.data.miss_info[player:get_index()] = {
                            missed = 0, last_origin = hitbox_position:floor(), new_shot_pos = (player:get_hitbox_position(0) + vector(0, 0, math.random(-8, -4)))
                        }
                    end


                    local my_weapon = my_index:get_player_weapon()
                    if not my_weapon then
                    	return
                    end

                    local inaccuracy = my_weapon:get_inaccuracy()
                    if inaccuracy == nil then
                    	return
                    end

                    local weapon_info = my_weapon:get_weapon_info()
                    if weapon_info == nil then
                        return
                    end
                    local weapon = my_weapon:get_weapon_index()
                    local weapon_type = weapon_info.weapon_type
                    if weapon_type == 0 or weapon_type == 9 or my_weapon:get_weapon_reload() ~= -1 or weapon == 31 then return end
                    if player:get_origin():length2d() > weapon_info.range then return end

                    local tickcount = globals.tickcount
                    local simtime = my_index.m_flSimulationTime - 0.04
                    if tickcount < dormant_aimbot.utils.data.round_started then return end
                    local can_shoot, hs_fix = nil, ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"):get() and 0.2 or 0

                    if weapon == 64 then
                    	can_shoot = simtime > my_weapon.m_flNextPrimaryAttack + hs_fix
                    elseif weapon_type == 1 and not weapon == 64 and not weapon == 1 then
                    	can_shoot = false
                    else
                    	can_shoot = simtime > math.max(my_index.m_flNextAttack + hs_fix, my_weapon.m_flNextPrimaryAttack + hs_fix, my_weapon.m_flNextSecondaryAttack)
                    end

                    if not can_shoot then return end
                    local is_AWP = weapon == 9
                    local is_scout = weapon == 40

                    local max_misses = is_AWP and 2 or (is_scout or weapon == 64) and 3 or 5
                    if dormant_aimbot.utils.data.miss_info[player:get_index()].missed >= max_misses then
                        return
                    end
                    local damage, trace = utils.trace_bullet(my_index, lp_eye_position, dormant_aimbot.utils.data.miss_info[player:get_index()].new_shot_pos)
                    if damage >= 0 then
                        dormant_aimbot.utils.data.miss_info[player:get_index()].new_shot_pos = player:get_hitbox_position(0) + (dormant_aimbot.utils.data.miss_info[player:get_index()].missed >= 1 and vector(0, 0, math.random(-14, 0)) or vector())
                    end

                    local can_hit = trace.entity:is_enemy() and (damage >= menu["anti aim"].dormant_aimbot[0].damage:get()) and (not player:is_visible())

                    if not can_hit then return end
                    if menu["anti aim"].dormant_aimbot:get() then
                        local view_angles = lp_eye_position:to(dormant_aimbot.utils.data.miss_info[player:get_index()].new_shot_pos):angles()

                        if not my_index.m_bIsScoped and weapon_type == 5 and not cmd.in_jump then
                            cmd.in_attack2 = true
                        end
                        dormant_aimbot.utils.auto_stop(cmd, (my_index.m_bIsScoped and weapon_info.max_player_speed_alt or weapon_info.max_player_speed)*0.33)

                        if inaccuracy < 0.03 and (ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get() and cmd.choked_commands == 0 or true) then
                            cmd.view_angles = view_angles
                            cmd.in_attack = true
                            if not dormant_aimbot.utils.data.shot_info[player:get_index()] or not dormant_aimbot.utils.data.shot_info[player:get_index()].hurted then
                                dormant_aimbot.utils.data.miss_info[player:get_index()].missed = dormant_aimbot.utils.data.miss_info[player:get_index()].missed + 1
                                dormant_aimbot.utils.data.miss_info[player:get_index()].new_shot_pos = player:get_origin() + vector(0, 0, 40+math.random(-8, -4))
                            end
                        end
                    end
                end
            end)
        end
    end)

    dormant_aimbot.utils.getbbox = function(ent, pos)
        local vecmin = ent.m_vecMins
        local vecmax = ent.m_vecMaxs
        local min = pos + vecmin
        local max = pos + vecmax
        local points = {
            vector(min.x, min.y, min.z),
            vector(min.x, max.y, min.z),
            vector(max.x, max.y, min.z),
            vector(max.x, min.y, min.z),
            vector(max.x, max.y, max.z),
            vector(min.x, max.y, max.z),
            vector(min.x, min.y, max.z),
            vector(max.x, min.y, max.z)
        }
        local bFlb = render.world_to_screen(points[4]) or vector(0, 0)
        local bBrt = render.world_to_screen(points[6]) or vector(0, 0)
        local bBlb = render.world_to_screen(points[1]) or vector(0, 0)
        local bFrt = render.world_to_screen(points[5]) or vector(0, 0)
        local bFrb = render.world_to_screen(points[3]) or vector(0, 0)
        local bBrb = render.world_to_screen(points[2]) or vector(0, 0)
        local bBlt = render.world_to_screen(points[7]) or vector(0, 0)
        local bFlt = render.world_to_screen(points[8]) or vector(0, 0)
        if not bFlb and not bBrt and not bBlb and not bFrt and not bFrb and not bBrb and not bBlt and not bFlt then
            return false
        end
        local arr = { bFlb, bBrt, bBlb, bFrt, bFrb, bBrb, bBlt, bFlt }
        local left = bFlb.x
        local top = bFlb.y
        local right = bFlb.x
        local bottom = bFlb.y
        for i = 1, 8 do
            if left > arr[i].x then
                left = arr[i].x
            end
            if top < arr[i].y then
                top = arr[i].y
            end
            if right < arr[i].x then
                right = arr[i].x
            end
            if bottom > arr[i].y then
                bottom = arr[i].y
            end
        end
        local box = { x = 0, y = 0, w = 0, h = 0 }
        box.x = math.floor(left)
        box.y = math.floor(bottom)
        box.w = math.floor(right - left)
        box.h = math.floor(top - bottom)
        return box
    end

    events.render(function()
        if not menu["anti aim"].dormant_aimbot:get() then return end
        entity.get_players(true, true, function(player)
            if not player:is_dormant() then return end
            if dormant_aimbot.utils.data.miss_info[player:get_index()] ~= nil and dormant_aimbot.utils.data.miss_info[player:get_index()].new_shot_pos and dormant_aimbot.utils.data.miss_info[player:get_index()].new_shot_pos:to_screen() then
                local box = dormant_aimbot.utils.getbbox(player, dormant_aimbot.utils.data.miss_info[player:get_index()].last_origin)
                local pos = { player:get_bbox().pos1 or vector(box.x, box.y + 3), player:get_bbox().pos2 or vector(box.x + box.w, box.y + 1 + box.h) }
                if (not pos[1] or pos[1].x < 0 or pos[1].x > render.screen_size().x or pos[1].y < 0 or pos[1].y > render.screen_size().y) then return end
                if (not pos[2] or pos[2].x < 0 or pos[2].x > render.screen_size().x or pos[2].y < 0 or pos[2].y > render.screen_size().y) then return end

                render.rect_outline(player:get_bbox().pos1 or vector(box.x, box.y + 3), player:get_bbox().pos2 or vector(box.x + box.w, box.y + 1 + box.h), color(160, 0, 0, 200))
                if not player:get_bbox().pos1 then
                    render.text(1, vector(box.x + box.w * .5, box.y - 4), color(200, 200), 'c', player:get_name())
                    render.text(1, vector(box.x - 2, box.y + 1), color(200, 200), 'r', player.m_iHealth)
                end
            end
        end)
    end)

    events.round_prestart(function(e)
        local freezetime = (cvar.mp_freezetime:float()+1) / globals.tickinterval
        dormant_aimbot.utils.data.round_started = globals.tickcount + freezetime
        dormant_aimbot.utils.data.miss_info = {}
    end)

    events.weapon_fire(function(e)
        local attacker = entity.get(e.userid, true)
        if attacker == entity.get_local_player() then
            dormant_aimbot.utils.data.shot_info = {}
        end
    end)
    events.player_death(function(e)
        local userid = entity.get(e.userid, true)
        if dormant_aimbot.utils.data.shot_info[userid:get_index()] == nil then
            dormant_aimbot.utils.data.shot_info[userid:get_index()] = {}
        end
        if dormant_aimbot.utils.data.miss_info[userid:get_index()] then
            dormant_aimbot.utils.data.miss_info[userid:get_index()].missed = 0
        end
        dormant_aimbot.utils.data.shot_info[userid:get_index()].hurted = true
    end)
    events.player_hurt(function(e)
        local attacker = entity.get(e.attacker, true)
        local userid = entity.get(e.userid, true)
        local local_player = entity.get_local_player()

        if attacker == local_player then
            if dormant_aimbot.utils.data.shot_info[userid:get_index()] == nil then
                dormant_aimbot.utils.data.shot_info[userid:get_index()] = {}
            end
            if dormant_aimbot.utils.data.miss_info[userid:get_index()] then
                dormant_aimbot.utils.data.miss_info[userid:get_index()].missed = 0
            end
            dormant_aimbot.utils.data.shot_info[userid:get_index()].hurted = true
        end
    end)
end
local auto_release = {} do
    auto_release.utils = {} do
        auto_release.utils.damage_calculation = function(damage, armor)
            local fl = {
                ["armor"] = {
                    ration = 0.5,
                    bonus = 0.5
                }
            }
            if (armor > 0) then
                local new = {} do
                    new.damage = damage * fl["armor"].ration
                    new.armor = (damage - new.damage) * fl["armor"].bonus
                end
                if new.armor > armor then
                    new.armor = armor * (1 / fl["armor"].bonus)
                    new.damage = damage - new.armor
                end
                damage = new.damage
            end
            return damage
        end
        auto_release.utils.auto_stop = function(cmd, speed)
            local min_speed = math.sqrt((cmd.forwardmove * cmd.forwardmove) + (cmd.sidemove * cmd.sidemove))
            if speed <= 0 or min_speed <= 0 then return end
            if cmd.in_duck == 1 then
                speed = speed * 2.94117647
            end
            if min_speed <= speed then return end
            local speed_factor = speed / min_speed
            cmd.forwardmove = cmd.forwardmove * speed_factor
            cmd.sidemove = cmd.sidemove * speed_factor
        end
    end
    auto_release.createmove = function(cmd)
        local is_local_player_valid, my_index = is_local_player_valid()
        if is_local_player_valid then
            local enemy = entity.get_threat()
            if not enemy or not enemy:is_alive() then return end
            local grenade_type = "undefined" do
                local player_weapon = my_index:get_player_weapon()
                if not player_weapon then return end
                local info = player_weapon:get_weapon_info()
                if not info then return end
                local selected = menu["anti aim"].potnie_opcii[0].selected
                local name = info.weapon_name
                if name == "weapon_hegrenade" and selected:get("high explosive") then
                    grenade_type = "HE"
                elseif (name == "weapon_molotov" or name == "weapon_incgrenade") and selected:get("molotov") then
                    grenade_type = "molotov"
                elseif name == "weapon_smokegrenade" and selected:get("smoke") then
                    grenade_type = "smoke"
                end
            end
            if grenade_type == "undefined" then return end
            if not bit.band(cmd.buttons, 1) == 1 then return end
            nade_prediction.createmove(cmd)
            local list = nade_prediction.get_positions()
            if #list < 1 then return end
            local last_pos = list[#list] do
                if last_pos then
                    last_pos = last_pos.origin
                    local tracer = utils.trace_hull(last_pos, enemy:get_origin(), vector(0, 0, 0), vector(0, 0, 0))
                    local in_attack = false
                    if grenade_type == "HE" then
                        local multiplication = ((enemy:get_origin() - last_pos):length() - 25) / 140
                        local damage = math.max(math.floor(auto_release.utils.damage_calculation((105 * math.exp(-multiplication * multiplication)), enemy:get_resource().m_iArmor)), 0)
                        if damage ~= 0 and (damage >= menu["anti aim"].potnie_opcii[0].damage:get()) then
                            in_attack = true
                        end
                    elseif grenade_type == "molotov" then
                        local distance = (enemy:get_origin() - last_pos):length()
                        if distance < 135 and tracer.fraction > 0.3 then
                            in_attack = true
                        end
                    elseif grenade_type == "smoke" then
                        entity.get_entities("CInferno", true, function(inferno)
                            local origin = inferno:get_origin()
                            if origin then
                                local distance = (origin - last_pos):length()
                                if distance < 200 and tracer.fraction > 0.3 then
                                    in_attack = true
                                end
                            end
                        end)
                    end
                    local speed = menu["anti aim"].potnie_opcii[0].speed:get()
                    if speed > 0 then auto_release.utils.auto_stop(cmd, speed) end
                    if in_attack then cmd.in_attack = globals.tickcount % 4 >= 2 end
                end
            end
        end
    end
end
all_anti_aim_functions.main_constructor.throw_fix = {}
all_anti_aim_functions.main_constructor.throw_fix.createmove = function(cmd)
    local is_local_player_valid, my_index = is_local_player_valid()
    if is_local_player_valid then
        local lp_weap = my_index:get_player_weapon()
        if lp_weap ~= nil and (cmd.in_attack or cmd.in_attack2) and lp_weap.m_bPinPulled ~= nil and lp_weap.m_bPinPulled then
            cmd.send_packet = false
            cmd.force_defensive = false
            ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):override("Disabled")
            ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):override("Auto Pistols")
            ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Quick-Switch"):override(false)
        else
            ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):override()
            ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Quick-Switch"):override()
        end
    end
end
all_anti_aim_functions.main_constructor.fast_ladder = {}
all_anti_aim_functions.main_constructor.fast_ladder.createmove = function(cmd)
    local is_local_player_valid, my_index = is_local_player_valid()
    if is_local_player_valid and my_index["m_MoveType"] == 9 and cmd.view_angles.x < 50 then
        local current_weapon = my_index:get_player_weapon()
        if current_weapon ~= nil then
            for _, v in pairs({43, 44, 45, 46, 47, 48}) do
                if my_index:get_player_weapon() == nil then return end
                if my_index:get_player_weapon():get_weapon_index() == v then return end
            end
        end

        local y_add = 113
        if cmd.in_forward and cmd.in_moveleft then
            cmd.in_back = 1
            cmd.in_forward = 0
            cmd.in_moveleft = 0
            cmd.in_moveright = 1
            y_add = 180
        elseif cmd.in_forward and cmd.in_moveright then
            cmd.in_back = 1
            cmd.in_forward = 0
            cmd.in_moveleft = 1
            cmd.in_moveright = 0
            y_add = 180
        elseif cmd.in_back and cmd.in_moveright then
            cmd.in_back = 0
            cmd.in_forward = 1
            cmd.in_moveleft = 1
            cmd.in_moveright = 0
            y_add = 180
        elseif cmd.in_back and cmd.in_moveleft then
            cmd.in_back = 0
            cmd.in_forward = 1
            cmd.in_moveleft = 0
            cmd.in_moveright = 1
            y_add = 180
        elseif cmd.in_moveleft then
            cmd.in_back = 0
            cmd.in_forward = 0
            cmd.in_moveleft = 0
            cmd.in_moveright = 1
            y_add = 180
        elseif cmd.in_moveright then
            cmd.in_back = 0
            cmd.in_forward = 0
            cmd.in_moveleft = 1
            cmd.in_moveright = 0
            y_add = 180
        elseif cmd.in_forward then
            cmd.in_back = 1
            cmd.in_forward = 0
            cmd.in_moveleft = 0
            cmd.in_moveright = 1
        elseif cmd.in_back then
            cmd.in_back = 0
            cmd.in_forward = 1
            cmd.in_moveleft = 1
            cmd.in_moveright = 0
            y_add = 96
        end

        local pitch, yaw = 90, render.camera_angles().y + y_add
        cmd.view_angles.x = pitch
        cmd.view_angles.y = yaw
    end
end

events.override_view:set(all_anti_aim_functions.main_constructor.super_toss.on_override_view)
events.pre_render:set(function()
    if menu["anti aim"].potnie_opcii:get("super toss") then
        all_anti_aim_functions.main_constructor.super_toss.on_pre_render()
    end
    if menu["anti aim"].potnie_opcii:get("no fall damage") then
        all_anti_aim_functions.main_constructor.edge_bug.pre_render()
    end
end)

local get_desync = function(comma_index)
    local real_rotation = rage.antiaim:get_rotation(true)
    local fake_rotation = rage.antiaim:get_rotation()
    local max_delta = rage.antiaim:get_max_desync()
    local delta = math.min(math.abs(real_rotation - fake_rotation), max_delta)

    return tonumber(string.format("%." .. comma_index .. "f", delta))
end

events.bullet_impact:set(function(event)
    if menu["anti aim"].potnie_opcii:get("anti bruteforce") then
        all_anti_aim_functions.main_constructor.trigger_anti_bruteforce(event)
    end
end)
local hitgroups = {
    [0] = "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "generic", "gear"
}
local reasons = {
    ["spread"] = "spread",
    ["correction"] = "resolver",
    ["misprediction"] = "resolver",
    ["prediction error"] = "prediction error",
    ["backtrack failure"] = "backtrack failure",
    ["damage rejection"] = "damage rejection",
    ["unregistered shot"] = "unregistered shot",
    ["player death"] = "player death",
    ["death"] = "death"
}

sauron_logs.push(("\a%s[HELLYAW]\aDEFAULT %s"):format(menu["anti aim"].logs_on_screen[0].clr_notify:get():alpha_modulate(255):to_hex(), "no no no mister fish"))
local function aim_ack(shot)
    if not is_local_player_valid() or #menu["anti aim"].logs_on_screen:get() == 0 then
        return
    end
    local hitbox = hitgroups[shot.hitgroup]
    local target = shot.target
    local target_name = target:get_name()
    local hit_damage = shot.damage
    local hit_hitchance = shot.hitchance
    local wanted_damage = shot.wanted_damage
    local wanted_hitgroup = hitgroups[shot.wanted_hitgroup]
    local delta = get_desync(0)
    local backtrack = shot.backtrack
    local spread = shot.spread and string.format("%.2f", shot.spread) or "unknown"
    local miss_reason = reasons[shot.state]
    local remain = math.max(0, target.m_iHealth)
    count_shots = count_shots + 1
    if count_shots > 99 then
        count_shots = 0
    end
    if remain <= 0 then
        remain = 0
    end
    local is_missmatch = hit_damage ~= wanted_damage
    local first_correction = math.floor(hit_hitchance / 100) + 1
    local second_correction = utils.random_int(-15, 15)
    local text_console =
        ("\a9fca2aFFRegistered %sth shot in %s's %s for %s damage [angle: 0.%s°, %s:%s°] ( hitchance: %s | history(Δ): %s | %s health %s )"):format(
        count_shots,
        target_name,
        hitbox,
        hit_damage,
        utils.random_int(0, 60),
        first_correction,
        second_correction,
        hit_hitchance,
        backtrack,
        remain,
        is_missmatch and "| missmatch: [dmg: " .. wanted_damage .. "]" or ""
    )
    if not shot.state then
        text_console =
            ("\a9fca2aFFRegistered %sth shot in %s's %s for %s damage [angle: 0.%s°, %s:%s°] ( hitchance: %s | history(Δ): %s | %s health %s)"):format(
            count_shots,
            target_name,
            hitbox,
            hit_damage,
            utils.random_int(0, 60),
            first_correction,
            second_correction,
            hit_hitchance,
            backtrack,
            remain,
            is_missmatch and "| missmatch: [dmg: " .. wanted_damage .. "]" or ""
        )
    else
        text_console =
            ("\aff7373FFMissed %sth shot at %s's %s due to %s [angle: 0.%s°, %s:%s°] ( damage: %s | hitchance: %s | history(Δ): %s | %s health %s)"):format(
            count_shots,
            target_name,
            wanted_hitgroup,
            miss_reason,
            utils.random_int(0, 60),
            first_correction,
            second_correction,
            wanted_damage,
            hit_hitchance,
            backtrack,
            remain,
            is_missmatch and "| missmatch: [dmg: " .. wanted_damage .. "]" or ""
        )
    end
    if menu["anti aim"].logs_on_screen:get("console") then
        print_raw("[HELLYAW] " .. text_console)
    end
    if menu["anti aim"].logs_on_screen:get("dev") then
        print_dev(text_console)
    end
    if menu["anti aim"].logs_on_screen:get("notify") then
        local color_t = menu["anti aim"].logs_on_screen[0].clr_notify:get():alpha_modulate(255)
        local text =
            ("\a%s[HELLYAW]\aDEFAULT %s"):format(
            color_t:to_hex(),
            (not shot.state and
                ("Registered shot at %s's %s for %s damage [angle: %s°] (hitchance: %s | history: %s)"):format(
                    target_name,
                    hitbox,
                    hit_damage,
                    spread,
                    hit_hitchance,
                    backtrack
                ) or
                shot.state and
                    ("Missed shot at %s's %s due to %s [delta: %s, bt=%s, spread: %s°]"):format(
                        target_name,
                        wanted_hitgroup,
                        miss_reason,
                        delta,
                        backtrack,
                        spread
                    ) or
                "")
        )
        sauron_logs.push(text)
    end
end
events.aim_ack(aim_ack)
local function get_weapon_verb(weapon)
    local verbs = {knife = "Knifed", hegrenade = "Naded", inferno = "Burned"}
    return verbs[weapon]
end
events.player_hurt:set(function(e)
    local local_player = entity.get_local_player()
    local userid = entity.get(e.userid, true)
    local attacker = entity.get(e.attacker, true)
    if not userid or attacker ~= local_player then
        return
    end
    local weapon_verb = get_weapon_verb(e.weapon)
    if weapon_verb then
        local text =
            ("%s %s for %i damage (%i remaining)"):format(
            weapon_verb,
            userid:get_name():lower(),
            e.dmg_health,
            e.health
        )
        if menu["anti aim"].logs_on_screen:get("console") then
            print_raw("[HELLYAW] \a9fca2aFF" .. text)
        end
        if menu["anti aim"].logs_on_screen:get("dev") then
            print_dev("\a9fca2aFF" .. text)
        end
        local color_t = menu["anti aim"].logs_on_screen[0].clr_notify:get():alpha_modulate(255)
        if menu["anti aim"].logs_on_screen:get("notify") then
            sauron_logs.push("\a" .. color_t:to_hex() .. "[HELLYAW] \aDEFAULT" .. text)
        end
    end
end)

local gradient = {} do
    gradient.make = function(text, speed, colors, ...)
        return monylinear:Animate(text, colors, speed, ...)
    end
end

local indicators = {} do
    indicators.main = {
        tab = false,
        desync = 0,
        font = render.load_font("Verdana Bold", 8, "ba"),
        font_arrow = render.load_font("Acta Symbols W95 Arrows", 14, "ab")
    }
    indicators.executer = function()
        local is_local_player_valid, my_index = is_local_player_valid()
        if not is_local_player_valid then indicators.main.tab = false end
        local enable = smooth.linear("HELLYAW", "Indicator enable", true)
        local detect_inverter = false do
            if references.list["Options"]:get_override() ~= nil and table.find(references.list["Options"]:get_override(), "Jitter") or false then
                detect_inverter = not rage.antiaim:inverter()
            else
                detect_inverter = references.list["Inverter"]:get_override()
            end
        end

        local tab = smooth.linear("HELLYAW", "Indicator tab", not (is_local_player_valid and indicators.main.tab or false), 0, 1) * enable
        local alpha = smooth.linear("HELLYAW", "Indicator alpha", (is_local_player_valid and (my_index:is_alive() or ui.get_alpha() > 0) or (ui.get_alpha() > 0))) * enable * tab
        local scope = smooth.linear("HELLYAW", "Indicator scope", (is_local_player_valid and my_index.m_bIsScoped or false))
        local inverter_side = smooth.linear("HELLYAW 2", "Inverter side", not detect_inverter, 0, 20)

        local object = {} do
            object.offset = 20
            object.name = gradient.make(("HELLYAW"), 5, {
                color(255, 255, 255, 255),
                menu["anti aim"].visuals[0].clr_indicator:get()
            })
            object.size = {name = (render.measure_text(indicators.main.font, nil, object.name).x * 0.5 + 9)}
        end
        if menu["anti aim"].visuals:get("indicators") then
            local binds = {} do
                binds.dt = references.list_need["Double tap"]:get() and color(255, 255, 255, 255) or color(128, 128, 128, 255)
                binds.fs = references.list["Freestanding NL"]:get() and color(255, 255, 255, 255) or color(128, 128, 128, 255)
                binds.hs = references.list_need["Hide shots"]:get() and color(255, 255, 255, 255) or color(128, 128, 128, 255)
            end

            local position = vector(references.main["Screen size"].x * 0.5 + object.size.name * scope, references.main["Screen size"].y * 0.5 + object.offset)
            render.text(indicators.main.font, position, color(255, 255, 255, 255 * alpha), "c", object.name)
            render.rect(position - vector(object.size.name - 9, -5), position + vector(object.size.name - 10, 9), color(8, 8, 8, 255 * alpha))
            render.rect(position - vector(object.size.name - 30 + inverter_side, -7), position + vector(object.size.name - 11 - inverter_side, 2), color(255, 255, 255, 255 * alpha))
            render.text(2, position - vector(object.size.name - 15, -14), binds.dt:alpha_modulate(255 * alpha), "c", "DT")
            render.text(2, position - vector(0, -14), binds.fs:alpha_modulate(255 * alpha), "c", "FS")
            render.text(2, position - vector(-object.size.name + 15, -14), binds.hs:alpha_modulate(255 * alpha), "c", "HS")
        end
    end
    indicators.manual_arrows = function()
        local is_local_player_valid, my_index = is_local_player_valid()
        local manual_active = menu["anti aim"].manual_mode:get()
        local scope = smooth.linear("HELLYAW", "Indicator scope", (is_local_player_valid and my_index.m_bIsScoped or false))
        local enable = smooth.linear("HELLYAW", "Arrows enable", manual_active ~= "none" and manual_active ~= "forward")
        local alpha = smooth.linear("HELLYAW", "Arrows alpha", (is_local_player_valid and (my_index:is_alive() or ui.get_alpha() > 0) or (ui.get_alpha() > 0))) * enable
        if manual_active ~= "none" then
            local position_X = vector(references.main["Screen size"].x * 0.5 - 20 - menu["anti aim"].visuals[0].arrows_offset:get(), references.main["Screen size"].y * 0.5 + 2- 12 * scope)
            local position_Z = vector(references.main["Screen size"].x * 0.5 + 19 + menu["anti aim"].visuals[0].arrows_offset:get(), references.main["Screen size"].y * 0.5 + 2- 12 * scope)
            if manual_active == "left" then
                render.text(indicators.main.font_arrow, position_X, menu["anti aim"].visuals[0].clr_arrows:get():alpha_modulate(255 * alpha), "c", "X")
            elseif manual_active == "right" then
                render.text(indicators.main.font_arrow, position_Z, menu["anti aim"].visuals[0].clr_arrows:get():alpha_modulate(255 * alpha), "c", "Z")
            end
        end
    end
    menu["anti aim"].visuals[0].scale:set_callback(function(value)
        indicators.main.font_arrow = render.load_font("Acta Symbols W95 Arrows", value:get(), "ab")
    end, true)
    indicators.converter = {
        ["G"] = "*GLOBAL*",
        ["S"] = "*STANDING*",
        ["M"] = "*MOVING*",
        ["SW"] = "*SLOWWALK*",
        ["C"] = "*CROUCH*",
        ["A"] = "*JUMPING*",
        ["AC"] = "*CROUCH AIR*",
    }
    indicators.watermark = function()
        local is_local_player_valid, my_index = is_local_player_valid()
        if is_local_player_valid then
            local state = indicators.converter[lib.anti_aim.condition.get()]:lower():gsub("*", "")
            local add_x, add_y = references.main["Screen size"].x / 2 - (references.main["Screen size"].x / 2 - 10), references.main["Screen size"].y / 2 - 35
            render.text(10,
                vector(add_x, add_y),
                color(255, 255, 255, 255),
                nil,
                "hellyaw - v. 2.0.0 beta; user: "..references.main["Username"]
            )

            local data, current_enemy = all_anti_aim_functions.main_constructor.update_enemies(), nil
            if data ~= nil then
                current_enemy = data.enemy
            end

            render.text(10,
                vector(add_x, add_y + 12),
                color(204, 204, 255, 255),
                nil,
                ("> enemy info: debug - %s;"):format(current_enemy ~= nil and current_enemy.m_angEyeAngles or "target not found")
            )
            render.text(10,
                vector(add_x, add_y + 24),
                color(255, 102, 102, 215),
                nil,
                ("> player info: state - %s; lag - %s"):format(state, references.list_need["Double tap"]:get() and (ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"):get_override() == "Always On" and true or false) or false)
            )
        end
    end
end

local wpn_ignored = {
    CKnife = true,
    CWeaponTaser = true,
    CC4 = true,
    CHEGrenade = true,
    CSmokeGrenade = true,
    CMolotovGrenade = true,
    CSensorGrenade = true,
    CFlashbang = true,
    CDecoyGrenade = true,
    CIncendiaryGrenade = true
}

local default_damage = esp.enemy:new_text("-\aFF3C3CFF100\aDEFAULT-", "-\aFF3C3CFF100\aDEFAULT-", function(player)
    local is_local_player_valid, my_index = is_local_player_valid()
    if is_local_player_valid then
        local weapon = my_index:get_player_weapon()
        if weapon and not wpn_ignored[weapon:get_classname()] then
            local weapon_info = weapon:get_weapon_info()
            if weapon_info and player and player:is_alive() and not player:is_dormant() then
                local range_modifier = weapon_info.range_modifier
                local damage = weapon_info.damage * 1.25
                local armor_ratio = weapon_info.armor_ratio * 0.5
                local target_health = player.m_iHealth
                local armor_value = player.m_ArmorValue
                local final_damage = (damage * ((armor_value and armor_value > 0) and armor_ratio or 1)) * (range_modifier ^ (my_index:get_origin():dist(player:get_origin()) / 500))
                if final_damage >= target_health then
                    return ("-\aFF3C3CFF%d\aDEFAULT-"):format(final_damage)
                else
                    return ("-%d-"):format(final_damage)
                end
            end
        end
    end
end)
---------------
local grenade_warning = {} do
    grenade_warning.img = render.load_image_from_file("materials/panorama/images/icons/equipment/inferno.svg", vector(30, 28))
    grenade_warning.img2 = render.load_image_from_file("materials/panorama/images/icons/equipment/hegrenade.svg", vector(19, 32))
    grenade_warning.font = render.load_font("calibri", 11, "ab")
    grenade_warning.warning_data = { }
    events.pre_render(function()
        for k, v in pairs(grenade_warning.warning_data) do
            if not v.entity or not entity.get(v.entity) then
                grenade_warning.warning_data[k] = nil
            end
        end
    end)
    events.grenade_warning(function(e)
        if not menu["anti aim"].visuals:get("grenade proximity warning") then return end
        local time = e.expire_time - globals.curtime
        local index = ('%s%s%s'):format(e.expire_time, e.origin, e.type)
        if not grenade_warning.warning_data[index] then
            grenade_warning.warning_data[index] = {
                entity = e.entity,
                start_time = time,
                realtime = globals.realtime,
            }
        end

        if time < 0.015 then
            grenade_warning.warning_data[index] = nil
        end
        if not grenade_warning.warning_data[index] then return end
        local local_player = entity.get_local_player()
        if not local_player then return end
        local local_player = local_player:is_alive() and local_player or local_player.m_hObserverTarget
        if not local_player then return end
        local screen_pos = e.origin:to_screen() and e.origin:to_screen() or render.get_offscreen(e.origin, 0.92, true)

        local start_time = grenade_warning.warning_data[index].start_time
        if e.type == "Molly" and grenade_warning.warning_data[index] then
            local dist = e.closest_point:dist(local_player:get_origin())
            local dist_multiplier = math.clamp(180 - dist, 0, 100) * 0.01
            render.texture(grenade_warning.img, screen_pos - vector(15, 25), color(255, 220))
            render.text(grenade_warning.font, screen_pos + vector(0, 12), color(255, 220), 'c', ('%.0f'):format(e.origin:dist(local_player:get_origin()) * 0.08128))
        else
            local dist = e.origin:dist(local_player:get_origin())
            local dist_multiplier = e.damage >= 1 and math.clamp(346 - dist, 0, 100)*0.01 or 0
            local size_multiplier = e.damage >= 1 and math.clamp(250 - dist, 0, 100)*0.01 or 0
            render.texture(grenade_warning.img2, screen_pos - vector(10, 27), color(255, 220))
            render.text(grenade_warning.font, screen_pos + vector(0, 12), color(255, 220), 'c', e.damage)
        end
        return false
    end)
    events.grenade_warning(function(e)
        if not menu["anti aim"].visuals:get("grenade proximity warning") then return end
        local time = e.expire_time - globals.curtime
        local index = ('%s%s%s'):format(e.expire_time, e.origin, e.type)
        if not grenade_warning.warning_data[index] then
            grenade_warning.warning_data[index] = {
                entity = e.entity,
                start_time = time,
                realtime = globals.realtime,
            }
        end

        if time < 0.015 then
            grenade_warning.warning_data[index] = nil
        end
        if not grenade_warning.warning_data[index] then return end
        local local_player = entity.get_local_player()
        if not local_player then return end
        local local_player = local_player:is_alive() and local_player or local_player.m_hObserverTarget
        if not local_player then return end
        local screen_pos = e.origin:to_screen() and e.origin:to_screen() or render.get_offscreen(e.origin, 0.92, true)

        local start_time = grenade_warning.warning_data[index].start_time
        if e.type == "Molly" and grenade_warning.warning_data[index] then
            local dist = e.closest_point:dist(local_player:get_origin())
            local dist_multiplier = math.clamp(180 - dist, 0, 100) * 0.01
            render.circle_gradient(screen_pos, color(0, 220), color(255 * dist_multiplier, 0, 0, 220), 30 + 20 * dist_multiplier, 360, 1)
            render.circle_outline(screen_pos, color(255, 220), 29.5 + 20 * dist_multiplier, 360, e.entity:get_classname() == 'CMolotovProjectile' and time / start_time or time / 7, 2)
            render.texture(grenade_warning.img, screen_pos - vector(15, 25), color(255, 220))
            render.text(grenade_warning.font, screen_pos + vector(0, 12), color(255, 220), 'c', ('%.0f'):format(e.origin:dist(local_player:get_origin()) * 0.08128))
        else
            local dist = e.origin:dist(local_player:get_origin())
            local dist_multiplier = e.damage >= 1 and math.clamp(346 - dist, 0, 100)*0.01 or 0
            local size_multiplier = e.damage >= 1 and math.clamp(250 - dist, 0, 100)*0.01 or 0

            render.circle_gradient(screen_pos, color(0, 220), e.damage >= 1 and color(100, 220):lerp(color(255, 10, 10, 220), dist_multiplier) or color(0, 220), 30 + 20 * size_multiplier, 360, 1)
            render.circle_outline(screen_pos, color(255, 220), 29.5 + 20 * size_multiplier, 360, time * .63, 2)
            render.texture(grenade_warning.img2, screen_pos - vector(10, 27), color(255, 220))
            render.text(grenade_warning.font, screen_pos + vector(0, 12), color(255, 220), 'c', e.damage)
        end

        return false
    end)
    grenade_warning.prediction_info = { }
    events.grenade_prediction(function(e)
        if not menu["anti aim"].visuals:get("grenade prediction") then return end
        grenade_warning.prediction_info = e
        return false
    end)

    local trajectory_color = ui.find("Visuals", "World", "Other", "Grenade Prediction", "Color")
    local _, trajectory_hit_color = ui.find("Visuals", "World", "Other", "Grenade Prediction", "Color Hit")
    events.render(function()
        if not menu["anti aim"].visuals:get("grenade prediction") then return end
        if not grenade_warning.prediction_info.type then return end
        for i = 1, #grenade_warning.prediction_info.path do
            local pos1 = render.world_to_screen(grenade_warning.prediction_info.path[math.max(1, i-1)])
            local pos2 = render.world_to_screen(grenade_warning.prediction_info.path[i])
            render.line(pos1, pos2, grenade_warning.prediction_info.damage >= 1 and trajectory_hit_color:get() or trajectory_color:get())
        end
        if #grenade_warning.prediction_info.path > 1 then
            for i = 1, #grenade_warning.prediction_info.collisions - 1 do
                local pos = render.world_to_screen(grenade_warning.prediction_info.collisions[i])
                render.circle(pos, color(0, 150), 3, 360, 1)
                render.circle(pos, color(), 2, 360, 1)
            end
            local pos = render.world_to_screen(grenade_warning.prediction_info.path[#grenade_warning.prediction_info.path])
            render.circle(pos, color(0, 150), 3, 360, 1)
            local clr = grenade_warning.prediction_info.damage >= 1 and color(0, 255, 0, 255) or color(255, 0, 0, 255)
            render.circle(pos, clr, 2.4, 360, 1)
            if grenade_warning.prediction_info.damage >= 1 and pos then
                local prefix = grenade_warning.prediction_info.type == 'Molly' and ('%.1f ft'):format(grenade_warning.prediction_info.damage*0.083529) or grenade_warning.prediction_info.type == 'Flash' and grenade_warning.prediction_info.damage..'%' or grenade_warning.prediction_info.damage..' dmg'
                render.text(1, pos - vector(0, 9), color(), 'c', prefix)
            end
        end
        grenade_warning.prediction_info = { }
    end)
end

---------------
local r8_helper = esp.enemy:new_text("Revolver Helper", ("\a%sDMG+"):format(color(50, 205, 50, 255):to_hex()), function(player)
    local is_local_player_valid, my_index = is_local_player_valid()
    if is_local_player_valid then
        local distance = my_index:get_origin():dist(player:get_origin())
        local weapon = my_index:get_player_weapon()
        if weapon and weapon:get_weapon_index() == 64 and player.m_ArmorValue == 0 then
            if distance < 585 and distance > 511 then
                return ("\a%sDMG"):format(color(255, 0, 0, 255):to_hex())
            elseif distance < 511 then
                return ("\a%sDMG+"):format(color(50, 205, 50, 255):to_hex())
            elseif distance < 555 then
                ui.find("Aimbot", "Ragebot", "Selection", "R8 Revolver", "Min. Damage"):override(100)
            end
        end
    end
end)

menu["anti aim"].esp_flags:set_callback(function(e)
    r8_helper:set(e:get("r8 helper"))
    default_damage:set(e:get("weapon damage"))
end, true)

events.render:set(function()
    smooth.new("HELLYAW") do
        smooth.update("HELLYAW", 8)
    end
    smooth.new("HELLYAW 2") do
        smooth.update("HELLYAW 2", 2)
    end
    sauron_logs.render()
    indicators.executer()
    if menu["anti aim"].visuals:get("watermark") then indicators.watermark() end
    if menu["anti aim"].visuals:get("manual arrows") then indicators.manual_arrows() end
end)

events.createmove:set(function(cmd)
    indicators.main.tab = bit.band(cmd.buttons, 65536) == 65536
    all_anti_aim_functions.main_constructor.executor(cmd)
    lib.anti_aim.condition.update()
    if menu["anti aim"].potnie_opcii:get("no fall damage") then
        all_anti_aim_functions.main_constructor.edge_bug.createmove(cmd)
    end
    if menu["anti aim"].potnie_opcii:get("super toss") then
        all_anti_aim_functions.main_constructor.super_toss.on_createmove(cmd)
    end
    if menu["anti aim"].potnie_opcii:get("fast ladder") then
        all_anti_aim_functions.main_constructor.fast_ladder.createmove(cmd)
    end
    if menu["anti aim"].potnie_opcii:get("automatic grenade release") then
        auto_release.createmove(cmd)
    end
    if menu["anti aim"].potnie_opcii:get("avoid collisions") then
        all_anti_aim_functions.main_constructor.avoid_collisions.createmove(cmd)
    end
    if menu["anti aim"].potnie_opcii:get("nade throw fix") then
        all_anti_aim_functions.main_constructor.throw_fix.createmove(cmd)
    end
end)

events.shutdown:set(function()
    for _, element in pairs(references.list) do
        element:visibility(true)
    end
end)

local buttons = {} do
    buttons.open = mui.button(lua_tabs["anti aim"].universal, "                           open anti aim tab                           ", true, function(el)
        for _, element in pairs(references.list) do
            element:visibility(true)
        end
        for _, element in pairs(menu["anti aim"]) do
            element:visibility(false)
        end
        buttons.close:visibility(true)
        el:visibility(false)
    end)

    buttons.close = mui.button(lua_tabs["anti aim"].universal, "                            back to hellyaw                             ", false, function(el)
        for _, element in pairs(references.list) do
            element:visibility(false)
        end
        for _, element in pairs(menu["anti aim"]) do
            element:visibility(true)
        end
        menu["anti aim"].active_condition:set("standing")
        el:visibility(false)
        buttons.open:visibility(true)
    end)
end
buttons.close:visibility(false)
events.cs_win_panel_match:set(function()
    indicators.main.tab = true
end)
_G._OSVERSION = "OpenOS 1.5"

local animations = {} do
    animations.ground_ticks = 1
    animations.end_time = 0
end

local get_anim_overlay = function(ent, layer)
    layer = layer or 1
    if ffi.cast(ffi.typeof('void***'), ent) == ffi.cast(ffi.typeof('void***'), entity.get_local_player()[0]) then
        ent = entity.get_local_player()[0]
    else
        ent = ffi.cast(ffi.typeof('void***'), ent)
    end
    return ffi.cast('c_animlayers**', ffi.cast('char*', ent) + 0x2990)[0][layer]
end

events.post_update_clientside_animation(function(e)
    local player = entity.get_local_player()
    if player == nil then
        return
    end

    if e ~= player then
        return
    end

    if not player:is_alive() then
        return
    end

    local self_anim_overlay = get_anim_overlay(player[0], 6)
    local self_anim_overlay_12 = get_anim_overlay(player[0], 12)

    local velocity = math.abs(player.m_vecVelocity:length() - 1)
    if menu["anti aim"].anim_breakers:get("in air") then
        if menu["anti aim"].anim_breakers[0].in_air_options:get() == "moonwalk" then
            if velocity > 2 then
                self_anim_overlay.weight = 1
                player.m_flPoseParameter[7] = 1
                player.m_flPoseParameter[6] = 1
            end
        else
            player.m_flPoseParameter[6] = 1
        end
    end
    if menu["anti aim"].anim_breakers:get("on ground") then
        if menu["anti aim"].anim_breakers[0].on_ground_options:get() == "follow direction" then
            player.m_flPoseParameter[0] = 1
            references.list["Leg movement"]:override("Sliding")
        elseif menu["anti aim"].anim_breakers[0].on_ground_options:get() == "moonwalk" then
            player.m_flPoseParameter[7] = 1
            references.list["Leg movement"]:override("Walking")
        else
            player.m_flPoseParameter[0] = (globals.tickcount % 3 >= 1.5 and 1 or 0.8)
            references.list["Leg movement"]:override("Sliding")
        end
    end
    if velocity >= 3 and menu["anti aim"].anim_breakers:get("body lean") then
        self_anim_overlay_12.weight = menu["anti aim"].anim_breakers[0].body_lean_amount:get() * 0.05
    end
    if menu["anti aim"].anim_breakers:get("reset pitch on land") then
        local on_ground = bit.band(player.m_fFlags, 1)

        if on_ground == 1 then
            animations.ground_ticks = animations.ground_ticks + 1
        else
            animations.ground_ticks = 0
            animations.end_time = globals.curtime + 1
        end
        if animations.ground_ticks > ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"):get() + 1 and animations.end_time > globals.curtime then
            player.m_flPoseParameter[12] = 0.5
        end
    end
end)