-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local _ = require("neverlose/chernobyl_library");
local l_system_0 = require("neverlose/dragging_system");
local l_monylinear_0 = require("neverlose/monylinear");
local l_clipboard_0 = require("neverlose/clipboard");
local l_smooth_0 = require("neverlose/smooth");
local l_liberia_0 = require("neverlose/liberia");
local l_mui_0 = require("neverlose/mui");
require("neverlose/extended_events");
local v8 = {
    build = "beta", 
    username = common.get_username(), 
    screen = render.screen_size(), 
    mouse = ui.get_mouse_position(), 
    ["anti aim"] = {
        condition = {
            [1] = "Standing", 
            [2] = "Running", 
            [3] = "Crouching", 
            [4] = "Slowwalking", 
            [5] = "Jumping", 
            [6] = "Crouching Air"
        }
    }, 
    fonts = {}, 
    to_bool = function(v7)
        if v7 == "false" then
            return false;
        elseif v7 == "true" then
            return true;
        else
            return nil;
        end;
    end, 
    fonts = {
        ["SP-7"] = {
            [9] = render.load_font("Verdana", 10, "a")
        }
    }
};
table.switcher = function(v9, v10)
    local v11 = v10[v9] or v10.default ~= nil and v10.default;
    return type(v11) == "function" and v11() or v11;
end;
table.find = function(v12, v13)
    for v14, v15 in pairs(v12) do
        if v15 == v13 then
            return v14;
        end;
    end;
    return -1;
end;
local v19 = {
    make = function(v16, v17, v18, ...)
        -- upvalues: l_monylinear_0 (ref)
        return l_monylinear_0:Animate(v16, v18, v17, ...);
    end
};
local v20 = getmetatable(color());
v20.mix = function(v21, v22, v23)
    return color(v21.r * v23 + v22.r * (1 - v23), v21.g * v23 + v22.g * (1 - v23), v21.b * v23 + v22.b * (1 - v23));
end;
v20.modulate_alpha = function(v24, v25)
    return color(v24.r, v24.g, v24.b, v25);
end;
local v26 = db.recode_chernobyl or {
    info = {
        total_killed = 0, 
        times_loaded = 0, 
        total_miss = 0, 
        total_death = 0, 
        total_hits = 0
    }
};
db_save = function(v27)
    -- upvalues: v26 (ref)
    local v28 = true;
    pcall(function()
        -- upvalues: v26 (ref), v27 (ref), v28 (ref)
        v26 = v27(db.recode_chernobyl);
        db.recode_chernobyl = v26;
        v28 = false;
    end);
    if v28 or not v26 then
        db.recode_chernobyl = {
            info = {
                total_killed = 0, 
                times_loaded = 0, 
                total_miss = 0, 
                total_death = 0, 
                total_hits = 0
            }
        };
    end;
end;
db_save(function(v29)
    v29.info.times_loaded = v29.info.times_loaded + 1;
    return v29;
end);
print = function(...)
    return print_raw("\a" .. color(252, 225, 0):to_hex():sub(1, 6) .. "[chernobyl] ", ...);
end;
local function v36(v30, v31, v32)
    return function(...)
        -- upvalues: v32 (ref), v30 (ref), v31 (ref)
        local l_status_0, l_result_0 = pcall(v32, ...);
        if not l_status_0 then
            local v35 = v30 .. " : " .. l_result_0:gsub(".{6}", "");
            if v31 then
                print_dev(v35);
                print(v35);
            end;
            return false, v35;
        else
            return l_result_0, l_status_0;
        end;
    end;
end;
local function v40(v37, v38, v39)
    -- upvalues: v36 (ref)
    events[v37]:set(v36(v38, true, v39));
end;
center = function(v41, v42)
    if not v42 then
        v42 = 5;
    end;
    return string.rep(" ", math.floor(v42 * 0.5 - string.len(v41) * 0.5)) .. v41 .. string.rep(" ", math.ceil(v42 * 0.5 - string.len(v41) * 0.5));
end;
percentage_color = function(v43, v44)
    v43 = v43 / 100;
    local v45 = -150 * v43 + 255;
    local v46 = 195 * v43;
    local v47 = 15 * v43;
    return v44 and color(v45, v46, v47, 255) or color(v45, v46, v47, 255):to_hex();
end;
smart_override = function(v48, v49, v50, v51)
    if v48 and v48 ~= 1 then
        if v50 ~= nil then
            if v49:get_override() ~= v50 then
                v49:override(v50);
            end;
        elseif v49:get_override() ~= v51 then
            v49:override(v51);
        end;
    elseif v48 == 1 then
        v49:override(nil);
    else
        v49:override(v50 ~= nil and v51 or nil);
    end;
end;
local v52 = {
    global = {
        location = ui.create("\240\159\147\140 Info", ui.get_icon("map-location-dot") .. "  Info \194\187 location", 1), 
        welcome = ui.create("\240\159\147\140 Info", ui.get_icon("door-open") .. "  Info \194\187 general", 2), 
        statistic = ui.create("\240\159\147\140 Info", ui.get_icon("square-poll-vertical") .. "  Info \194\187 average statistics", 2), 
        links = ui.create("\240\159\147\140 Info", ui.get_icon("octagon-check") .. "  Info \194\187 Buttons", 1), 
        configs = ui.create("\240\159\147\140 Info", ui.get_icon("database") .. "  Info \194\187 local configs"), 
        config_system = ui.create("\240\159\147\140 Info", ui.get_icon("bookmark") .. "  Info \194\187 config system")
    }, 
    ["anti aim"] = {
        extensions = ui.create("\240\159\155\161\239\184\143 Anti Aim", "Anti-aim \194\187 extensions"), 
        builder = ui.create("\240\159\155\161\239\184\143 Anti Aim", "Anti-aim \194\187 builder"), 
        animation_breakers = ui.create("\240\159\155\161\239\184\143 Anti Aim", "Anti-aim \194\187 Animation Breakers")
    }, 
    settings = {
        widgets = ui.create("\240\159\166\139 Settings", "Visuals \194\187 Widgets"), 
        modify = ui.create("\240\159\166\139 Settings", "Visuals \194\187 Modifications"), 
        main = ui.create("\240\159\166\139 Settings", "Misc \194\187 Main"), 
        other = ui.create("\240\159\166\139 Settings", "Misc \194\187 Other")
    }
};
local v53 = {
    Pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"), 
    Yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"), 
    ["Yaw Base"] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
    ["Yaw Offset"] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
    Hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"), 
    ["Yaw Modifier"] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"), 
    ["Modifier Offset"] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"), 
    ["Body Yaw"] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
    Inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
    ["Left Limit"] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
    ["Right Limit"] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
    ["Fake Options"] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
    Freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"), 
    ["Freestanding NL"] = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
    ["Double Tap"] = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
    ["Hide Shots"] = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
    ["Fakelag Limit"] = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"), 
    ["Double Tap Options"] = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"), 
    ["Hide Shots Options"] = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"), 
    ["Fake Duck"] = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
    ["Body Aim"] = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"), 
    ["Safe Points"] = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"), 
    ["Scope Overlay"] = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"), 
    ["Dormant Aimbot"] = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"), 
    ["Leg Movement"] = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
};
local v67 = {
    global = {
        location = l_mui_0.table(v52.global.location, "Current location:", {}), 
        text_1 = l_mui_0.text(v52.global.welcome, ("Dear !h<!s<Link Active>>%s!d, have a good game!\nYour build is !h<!s<Link Active>>%s!d with version !h<!s<Link Active>>3.1.1!d."):format(v8.username, v8.build)), 
        text_2 = l_mui_0.text(v52.global.statistic, ("In script:\n\t!h<3F4042FF>!i<angle-right>!d Script has been loaded in !h<!s<Link Active>>%s!d ms!\n\t!h<3F4042FF>!i<angle-right>!d You loaded this script !h<!s<Link Active>>%s!d times!"):format(math.random(1, 5), v26.info.times_loaded)), 
        text_3 = l_mui_0.text(v52.global.statistic, "In game:\n\t!h<3F4042FF>!i<angle-right>!d You killed !h<!s<Link Active>>%s!d people and died !h<!s<Link Active>>%s!d times!\n\t!h<3F4042FF>!i<angle-right>!d Your KD ratio is !h<!s<Link Active>>%.2f!d, rating - !h<%s>%s%%!d"), 
        text_4 = l_mui_0.text(v52.global.statistic, "In cheat:\n\t!h<3F4042FF>!i<angle-right>!d You hit !h<!s<Link Active>>%s!d shots and missed !h<!s<Link Active>>%s!d times!\n\t!h<3F4042FF>!i<angle-right>!d Your SM ratio is !h<!s<Link Active>>%.2f!d, rating - !h<%s>%s%%!d"), 
        text_5 = l_mui_0.text(v52.global.statistic, "Average:\n\t!h<3F4042FF>!i<angle-right>!d Personal script loyal rating - !h<%s>%s%%!d"), 
        button_1 = l_mui_0.button(v52.global.statistic, center("Reset all statistics", 70), false), 
        button_2 = l_mui_0.button(v52.global.links, center("!h<!s<Link Active>>!i<discord>!d  Join to discord server", 90), false, function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/rCbEaBwh3G");
        end), 
        button_4 = l_mui_0.button(v52.global.links, center("!h<!s<Link Active>>!i<piggy-bank>!d  Paid config for script", 95), true, function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=lwxpsh");
        end), 
        button_5 = l_mui_0.button(v52.global.links, center("!h<!s<Link Active>>!i<file>!d  Load default settings", 89), true, function()
            configs.paste_data("chernobyl_eyJBZGQgcGhhc2UgYW1sic3dpdGNoIiwiYW50aSBhaW0iLCJSdW5uaW5nLmVuYWJsZSIsdHJ1ZV0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsIlJ1bm5pbmcub2Zmc2V0X2xlZnQiLC0zMC4wXSxbInNsaWRlciIsImFudGkgYWltIiwiUnVubmluZy5vZmZzZXRfcmlnaHQiLDMzLjBdLFsiY29tYm8iLCJhbnRpIGFpbSIsIlJ1bm5pbmcueWF3X21vZGlmaWVyIiwiRGlzYWJsZWQiXSxbInNsaWRlciIsImFudGkgYWltIiwiUnVubmluZy55YXdfbW9kaWZpZXJfb2Zmc2V0IiwwLjBdLFsic2xpZGVyIiwiYW50aSBhaW0iLCJSdW5uaW5nLmxlZnRfbGltaXQiLDYwLjBdLFsic2xpZGVyIiwiYW50aSBhaW0iLCJSdW5uaW5nLnJpZ2h0X2xpbWl0Iiw2MC4wXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsIlJ1bm5pbmcuZmFrZV9vcHRpb25zIixbIkppdHRlciJdXSxbInNsaWRlciIsImFudGkgYWltIiwiUnVubmluZy5kZWxheV90aWNrIiwzLjBdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJSdW5uaW5nLmhpZGRlbl9sYyIsdHJ1ZV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlJ1bm5pbmcuaGlkZGVuX2xjIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfc2xpZGVyIiwiUnVubmluZy5oaWRkZW5fbGMiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlJ1bm5pbmcuaGlkZGVuX2xjIiw3My4wLG51bGwsbnVsbCxbInNlbnNpdGl2aXR5IiwiUnVubmluZy5oaWRkZW5fbGMiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlJ1bm5pbmcuaGlkZGVuX2xjIiwiU3dpdGNoIExlZnQiLG51bGwsbnVsbCxbInR5cGUiLCJSdW5uaW5nLmhpZGRlbl9sYyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJSdW5uaW5nLmhpZGRlbl9sYyIsIlN3aXRjaCBVcCIsbnVsbCxudWxsLFsicGl0Y2giLCJSdW5uaW5nLmhpZGRlbl9sYyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2hpbmcuZW5hYmxlIix0cnVlXSxbImNvbWJvIiwiYW50aSBhaW0iLCJ5YXdfYmFzZSIsIkRpc2FibGVkIl0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsIkNyb3VjaGluZy5vZmZzZXRfbGVmdCIsLTMwLjBdLFsic2xpZGVyIiwiYW50aSBhaW0iLCJDcm91Y2hpbmcub2Zmc2V0X3JpZ2h0IiwzMC4wXSxbImNvbWJvIiwiYW50aSBhaW0iLCJDcm91Y2hpbmcueWF3X21vZGlmaWVyIiwiRGlzYWJsZWQiXSxbInNsaWRlciIsImFudGkgYWltIiwiQ3JvdWNoaW5nLnlhd19tb2RpZmllcl9vZmZzZXQiLDAuMF0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsImJvbWJzaXRlX2ZpeCIsdHJ1ZV0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsIkNyb3VjaGluZy5yaWdodF9saW1pdCIsNjAuMF0sWyJjb21ibyIsImFudGkgYWltIiwiYmFja3RyYWNrX3R5cGUiLCJUaHJlYXQiXSxbInNsaWRlciIsImFudGkgYWltIiwiQ3JvdWNoaW5nLmRlbGF5X3RpY2siLDAuMF0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaGluZy5oaWRkZW5fbGMiLHRydWVdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2hpbmcuaGlkZGVuX2xjIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfc2xpZGVyIiwiQ3JvdWNoaW5nLmhpZGRlbl9sYyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoaW5nLmhpZGRlbl9sYyIsMC4wLG51bGwsbnVsbCxbInNlbnNpdGl2aXR5IiwiQ3JvdWNoaW5nLmhpZGRlbl9sYyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoaW5nLmhpZGRlbl9sYyIsIk1ldGEiLG51bGwsbnVsbCxbInR5cGUiLCJDcm91Y2hpbmcuaGlkZGVuX2xjIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaGluZy5oaWRkZW5fbGMiLCJTd2l0Y2ggVXAiLG51bGwsbnVsbCxbInBpdGNoIiwiQ3JvdWNoaW5nLmhpZGRlbl9sYyIsImNvbWJvIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93d2Fsa2luZy5lbmFibGUiLHRydWVdLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwiY29ycmVjdF9vcHRpb25zIixbIkRvdWJsZSBUYXAiLCJIaWRlIFNob3RzIl1dLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwiYnJlYWtfbGMiLFsiU3RhbmRpbmciLCJSdW5uaW5nIiwiQ3JvdWNoaW5nIiwiU2xvd3dhbGtpbmciLCJKdW1waW5nIiwiQ3JvdWNoaW5nIEFpciJdXSxbInNsaWRlciIsImFudGkgYWltIiwiU2xvd3dhbGtpbmcub2Zmc2V0X3JpZ2h0Iiw0NC4wXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsImFuaW1fYnJlYWtlcnMiLFsiSW4gYWlyIiwiT24gZ3JvdW5kIiwiQm9keSBsZWFuIiwiUmVzZXQgcGl0Y2ggb24gbGFuZCJdXSxbInNsaWRlciIsImFudGkgYWltIiwiU2xvd3dhbGtpbmcueWF3X21vZGlmaWVyX29mZnNldCIsMC4wXSxbInNsaWRlciIsImFudGkgYWltIiwiU2xvd3dhbGtpbmcubGVmdF9saW1pdCIsNjAuMF0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsIlNsb3d3YWxraW5nLnJpZ2h0X2xpbWl0Iiw2MC4wXSxbInNlbGVjdGFibGUiLCJhbnRpIGFpbSIsIlNsb3d3YWxraW5nLmZha2Vfb3B0aW9ucyIsWyJKaXR0ZXIiXV0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsIlNsb3d3YWxraW5nLmRlbGF5X3RpY2siLDAuMF0sWyJjb21ibyIsImFudGkgYWltIiwiaW5fYWlyX29wdGlvbnMiLCJNb29ud2FsayJdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJKdW1waW5nLmVuYWJsZSIsdHJ1ZV0sWyJjb21ibyIsImFudGkgYWltIiwib25fZ3JvdW5kX29wdGlvbnMiLCJKaXR0ZXIgbGVncyJdLFsic2xpZGVyIiwiYW50aSBhaW0iLCJKdW1waW5nLm9mZnNldF9sZWZ0IiwtMjkuMF0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsIkp1bXBpbmcub2Zmc2V0X3JpZ2h0IiwyNC4wXSxbImNvbWJvIiwiYW50aSBhaW0iLCJKdW1waW5nLnlhd19tb2RpZmllciIsIkRpc2FibGVkIl0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsIkp1bXBpbmcueWF3X21vZGlmaWVyX29mZnNldCIsMC4wXSxbInNsaWRlciIsImFudGkgYWltIiwiSnVtcGluZy5sZWZ0X2xpbWl0Iiw2MC4wXSxbInNsaWRlciIsImFudGkgYWltIiwiSnVtcGluZy5yaWdodF9saW1pdCIsNjAuMF0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJKdW1waW5nLmZha2Vfb3B0aW9ucyIsWyJKaXR0ZXIiXV0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsIkp1bXBpbmcuZGVsYXlfdGljayIsMC4wXSxbInN3aXRjaCIsImFudGkgYWltIiwiSnVtcGluZy5oaWRkZW5fbGMiLHRydWVdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJKdW1waW5nLmhpZGRlbl9sYyIsMC4wLG51bGwsbnVsbCxbInBpdGNoX3NsaWRlciIsIkp1bXBpbmcuaGlkZGVuX2xjIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJKdW1waW5nLmhpZGRlbl9sYyIsMC4wLG51bGwsbnVsbCxbInNlbnNpdGl2aXR5IiwiSnVtcGluZy5oaWRkZW5fbGMiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkp1bXBpbmcuaGlkZGVuX2xjIiwiTWV0YSIsbnVsbCxudWxsLFsidHlwZSIsIkp1bXBpbmcuaGlkZGVuX2xjIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkp1bXBpbmcuaGlkZGVuX2xjIiwiU3dpdGNoIFVwIixudWxsLG51bGwsWyJwaXRjaCIsIkp1bXBpbmcuaGlkZGVuX2xjIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaGluZyBBaXIuZW5hYmxlIix0cnVlXSxbInNsaWRlciIsImFudGkgYWltIiwiQ3JvdWNoaW5nIEFpci5vZmZzZXRfbGVmdCIsLTE5LjBdLFsic2xpZGVyIiwiYW50aSBhaW0iLCJDcm91Y2hpbmcgQWlyLm9mZnNldF9yaWdodCIsMzkuMF0sWyJjb21ibyIsImFudGkgYWltIiwiQ3JvdWNoaW5nIEFpci55YXdfbW9kaWZpZXIiLCJEaXNhYmxlZCJdLFsic2xpZGVyIiwiYW50aSBhaW0iLCJDcm91Y2hpbmcgQWlyLnlhd19tb2RpZmllcl9vZmZzZXQiLDAuMF0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsIkNyb3VjaGluZyBBaXIubGVmdF9saW1pdCIsNjAuMF0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsIkNyb3VjaGluZyBBaXIucmlnaHRfbGltaXQiLDYwLjBdLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwiQ3JvdWNoaW5nIEFpci5mYWtlX29wdGlvbnMiLFsiSml0dGVyIl1dLFsic2xpZGVyIiwiYW50aSBhaW0iLCJDcm91Y2hpbmcgQWlyLmRlbGF5X3RpY2siLDAuMF0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaGluZyBBaXIuaGlkZGVuX2xjIix0cnVlXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoaW5nIEFpci5oaWRkZW5fbGMiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9zbGlkZXIiLCJDcm91Y2hpbmcgQWlyLmhpZGRlbl9sYyIsInNsaWRlciJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiQ3JvdWNoaW5nIEFpci5oaWRkZW5fbGMiLDAuMCxudWxsLG51bGwsWyJzZW5zaXRpdml0eSIsIkNyb3VjaGluZyBBaXIuaGlkZGVuX2xjIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJDcm91Y2hpbmcgQWlyLmhpZGRlbl9sYyIsIkZyZWUgU3dheSIsbnVsbCxudWxsLFsidHlwZSIsIkNyb3VjaGluZyBBaXIuaGlkZGVuX2xjIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIkNyb3VjaGluZyBBaXIuaGlkZGVuX2xjIiwiU3dpdGNoIFVwIixudWxsLG51bGwsWyJwaXRjaCIsIkNyb3VjaGluZyBBaXIuaGlkZGVuX2xjIiwiY29tYm8iXV0sWyJjb21ibyIsImFudGkgYWltIiwiY29uZGl0aW9uIiwiUnVubmluZyJdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZy5lbmFibGUiLHRydWVdLFsic2xpZGVyIiwiYW50aSBhaW0iLCJDcm91Y2hpbmcubGVmdF9saW1pdCIsNjAuMF0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJleHRlbnNpb25zIixbIkxlZ2l0IGFudGktYWltIG9uIEUiLCJBZGp1c3QgbWFudWFsIGFudGktYWltIiwiQ29ycmVjdCBsYWdzIG9uIGV4cGxvaXRzIiwiVmlnaWxhbnQgbGFnY29tcCBicmVha2luZyIsIkZhc3QgbGFkZGVyIl1dLFsic2xpZGVyIiwiYW50aSBhaW0iLCJTdGFuZGluZy5vZmZzZXRfbGVmdCIsLTMwLjBdLFsic2xpZGVyIiwiYW50aSBhaW0iLCJTdGFuZGluZy5vZmZzZXRfcmlnaHQiLDMwLjBdLFsiY29tYm8iLCJhbnRpIGFpbSIsIlN0YW5kaW5nLnlhd19tb2RpZmllciIsIkRpc2FibGVkIl0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsIlN0YW5kaW5nLnlhd19tb2RpZmllcl9vZmZzZXQiLDAuMF0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsIlN0YW5kaW5nLmxlZnRfbGltaXQiLDYwLjBdLFsic2xpZGVyIiwiYW50aSBhaW0iLCJTdGFuZGluZy5yaWdodF9saW1pdCIsNjAuMF0sWyJzZWxlY3RhYmxlIiwiYW50aSBhaW0iLCJTdGFuZGluZy5mYWtlX29wdGlvbnMiLFsiSml0dGVyIl1dLFsic2xpZGVyIiwiYW50aSBhaW0iLCJTdGFuZGluZy5kZWxheV90aWNrIiwzLjBdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZy5oaWRkZW5fbGMiLHRydWVdLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZy5oaWRkZW5fbGMiLDAuMCxudWxsLG51bGwsWyJwaXRjaF9zbGlkZXIiLCJTdGFuZGluZy5oaWRkZW5fbGMiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlN0YW5kaW5nLmhpZGRlbl9sYyIsMC4wLG51bGwsbnVsbCxbInNlbnNpdGl2aXR5IiwiU3RhbmRpbmcuaGlkZGVuX2xjIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTdGFuZGluZy5oaWRkZW5fbGMiLCJTd2l0Y2giLG51bGwsbnVsbCxbInR5cGUiLCJTdGFuZGluZy5oaWRkZW5fbGMiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU3RhbmRpbmcuaGlkZGVuX2xjIiwiUmFuZG9tIixudWxsLG51bGwsWyJwaXRjaCIsIlN0YW5kaW5nLmhpZGRlbl9sYyIsImNvbWJvIl1dLFsic2VsZWN0YWJsZSIsImFudGkgYWltIiwiQ3JvdWNoaW5nLmZha2Vfb3B0aW9ucyIsWyJKaXR0ZXIiXV0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsIlNsb3d3YWxraW5nLm9mZnNldF9sZWZ0IiwtNDQuMF0sWyJjb21ibyIsImFudGkgYWltIiwicHJlc2V0IiwiSml0dGVyIl0sWyJzbGlkZXIiLCJhbnRpIGFpbSIsImJvZHlfbGVhbl9hbW91bnQiLDEwMC4wXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvd3dhbGtpbmcuaGlkZGVuX2xjIix0cnVlXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvd3dhbGtpbmcuaGlkZGVuX2xjIiwwLjAsbnVsbCxudWxsLFsicGl0Y2hfc2xpZGVyIiwiU2xvd3dhbGtpbmcuaGlkZGVuX2xjIiwic2xpZGVyIl1dLFsic3dpdGNoIiwiYW50aSBhaW0iLCJTbG93d2Fsa2luZy5oaWRkZW5fbGMiLDY3LjAsbnVsbCxudWxsLFsic2Vuc2l0aXZpdHkiLCJTbG93d2Fsa2luZy5oaWRkZW5fbGMiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJhbnRpIGFpbSIsIlNsb3d3YWxraW5nLmhpZGRlbl9sYyIsIlNwaW4iLG51bGwsbnVsbCxbInR5cGUiLCJTbG93d2Fsa2luZy5oaWRkZW5fbGMiLCJjb21ibyJdXSxbInN3aXRjaCIsImFudGkgYWltIiwiU2xvd3dhbGtpbmcuaGlkZGVuX2xjIiwiVXAiLG51bGwsbnVsbCxbInBpdGNoIiwiU2xvd3dhbGtpbmcuaGlkZGVuX2xjIiwiY29tYm8iXV0sWyJjb21ibyIsImFudGkgYWltIiwiU2xvd3dhbGtpbmcueWF3X21vZGlmaWVyIiwiRGlzYWJsZWQiXSxbInN3aXRjaCIsInNldHRpbmdzIiwid2lkZ2V0cyIsdHJ1ZV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsIndpZGdldHMiLDUuMCxudWxsLG51bGwsWyJ4X2RlYnVnX2JveCIsIndpZGdldHMiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsIndpZGdldHMiLDQ0MC4wLG51bGwsbnVsbCxbInlfZGVidWdfYm94Iiwid2lkZ2V0cyIsInNsaWRlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwid2lkZ2V0cyIsODcyLjAsbnVsbCxudWxsLFsieF92ZWxvY2l0eV93YXJuaW5nIiwid2lkZ2V0cyIsInNsaWRlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwid2lkZ2V0cyIsMjcwLjAsbnVsbCxudWxsLFsieV92ZWxvY2l0eV93YXJuaW5nIiwid2lkZ2V0cyIsInNsaWRlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwid2lkZ2V0cyIsODA1LjAsbnVsbCxudWxsLFsieF93YXRlcm1hcmsiLCJ3aWRnZXRzIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJ3aWRnZXRzIiwxMDU1LjAsbnVsbCxudWxsLFsieV93YXRlcm1hcmsiLCJ3aWRnZXRzIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJ3aWRnZXRzIiwiQi1DIixudWxsLG51bGwsWyJzdGFwbGVkX3dhdGVybWFyayIsIndpZGdldHMiLCJjb21ibyJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwid2lkZ2V0cyIsNDg3LjAsbnVsbCxudWxsLFsieV9zcGVjdGF0b3JzIiwid2lkZ2V0cyIsInNsaWRlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwid2lkZ2V0cyIsIkZGRkZGRkZGIixudWxsLG51bGwsWyJjb2xvciIsIndpZGdldHMiLCJjb2xvcl9waWNrZXIiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsIndpZGdldHMiLFsiV2F0ZXJtYXJrIiwiS2V5YmluZHMiLCJTcGVjdGF0b3JzIiwiRGVidWcgQm94IiwiVmVsb2NpdHkgV2FybmluZyJdLG51bGwsbnVsbCxbInNlbGVjdGVkIiwid2lkZ2V0cyIsInNlbGVjdGFibGUiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsIndpZGdldHMiLDUwNy4wLG51bGwsbnVsbCxbInlfa2V5YmluZHMiLCJ3aWRnZXRzIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJ3aWRnZXRzIiwyOTUuMCxudWxsLG51bGwsWyJ4X2tleWJpbmRzIiwid2lkZ2V0cyIsInNsaWRlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwid2lkZ2V0cyIsMzUuMCxudWxsLG51bGwsWyJhbHBoYXMiLCJ3aWRnZXRzIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJ3aWRnZXRzIiwxNjA3LjAsbnVsbCxudWxsLFsieF9zcGVjdGF0b3JzIiwid2lkZ2V0cyIsInNsaWRlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwid2lkZ2V0cyIsIk1lbnUgU3R5bGUiLG51bGwsbnVsbCxbImFjY2VudCIsIndpZGdldHMiLCJjb21ibyJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwic2Vuc2VfaW5kaWNhdG9ycyIsZmFsc2VdLFsic3dpdGNoIiwic2V0dGluZ3MiLCJzZW5zZV9pbmRpY2F0b3JzIixbXSxudWxsLG51bGwsWyJkaXNwbGF5Iiwic2Vuc2VfaW5kaWNhdG9ycyIsInNlbGVjdGFibGUiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsInNlbnNlX2luZGljYXRvcnMiLGZhbHNlLG51bGwsbnVsbCxbInNwZWN0YXRvcnMiLCJzZW5zZV9pbmRpY2F0b3JzIiwic3dpdGNoIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJncmVuYWRlX3JhZGl1cyIsZmFsc2VdLFsic3dpdGNoIiwic2V0dGluZ3MiLCJncmVuYWRlX3JhZGl1cyIsIjdGN0ZGRkZGIixudWxsLG51bGwsWyJzbW9rZSIsImdyZW5hZGVfcmFkaXVzIiwiY29sb3JfcGlja2VyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJncmVuYWRlX3JhZGl1cyIsWyJTbW9rZSIsIk1vbG90b3YiXSxudWxsLG51bGwsWyJkaXNwbGF5IiwiZ3JlbmFkZV9yYWRpdXMiLCJzZWxlY3RhYmxlIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJncmVuYWRlX3JhZGl1cyIsIkZGN0Y3RkZGIixudWxsLG51bGwsWyJtb2xvdG92IiwiZ3JlbmFkZV9yYWRpdXMiLCJjb2xvcl9waWNrZXIiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsImFpcl9zdHJhZmVfZml4IixmYWxzZV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsImJvb3N0X2ZyYW1lcmF0ZSIsZmFsc2VdLFsic3dpdGNoIiwic2V0dGluZ3MiLCJ2aWV3bW9kZWxfY2hhbmdlciIsZmFsc2VdLFsic3dpdGNoIiwic2V0dGluZ3MiLCJ2aWV3bW9kZWxfY2hhbmdlciIsMjUuMCxudWxsLG51bGwsWyJ2aWV3bW9kZWxfeCIsInZpZXdtb2RlbF9jaGFuZ2VyIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJ2aWV3bW9kZWxfY2hhbmdlciIsMC4wLG51bGwsbnVsbCxbInZpZXdtb2RlbF95Iiwidmlld21vZGVsX2NoYW5nZXIiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsInZpZXdtb2RlbF9jaGFuZ2VyIiwtMTUuMCxudWxsLG51bGwsWyJ2aWV3bW9kZWxfeiIsInZpZXdtb2RlbF9jaGFuZ2VyIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJ2aWV3bW9kZWxfY2hhbmdlciIsMC4wLG51bGwsbnVsbCxbImFzcGVjdF9yYXRpbyIsInZpZXdtb2RlbF9jaGFuZ2VyIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJ2aWV3bW9kZWxfY2hhbmdlciIsNzgxLjAsbnVsbCxudWxsLFsidmlld21vZGVsX2ZvdiIsInZpZXdtb2RlbF9jaGFuZ2VyIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJjbGFudGFnX3NwYW1tZXIiLGZhbHNlXSxbInN3aXRjaCIsInNldHRpbmdzIiwidGFza2Jhcl9ub3RpZnkiLGZhbHNlXSxbInN3aXRjaCIsInNldHRpbmdzIiwidHJhc2h0YWxrIixmYWxzZV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsInRyYXNodGFsayIsWzEuMCwyLjAsMy4wLDQuMF0sbnVsbCxudWxsLFsidHJhc2h0YWxrX29wdGlvbnMiLCJ0cmFzaHRhbGsiLCJsaXN0YWJsZSJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwiY3Jvc3NoYWlyX2luZGljYXRvcnMiLHRydWVdLFsic3dpdGNoIiwic2V0dGluZ3MiLCJjcm9zc2hhaXJfaW5kaWNhdG9ycyIsIkJGRjQwMkZGIixudWxsLG51bGwsWyJjb2xvciIsImNyb3NzaGFpcl9pbmRpY2F0b3JzIiwiY29sb3JfcGlja2VyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJjcm9zc2hhaXJfaW5kaWNhdG9ycyIsWyJQbGF5ZXIgU3RhdGUiLCJEb3VibGUgVGFwIiwiSGlkZSBTaG90cyIsIkJvZHkgQWltIiwiU2FmZSBQb2ludHMiLCJGcmVlc3RhbmRpbmciLCJGYWtlIER1Y2siXSxudWxsLG51bGwsWyJkaXNwbGF5IiwiY3Jvc3NoYWlyX2luZGljYXRvcnMiLCJzZWxlY3RhYmxlIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJjcm9zc2hhaXJfaW5kaWNhdG9ycyIsIk1lbnUgU3R5bGUiLG51bGwsbnVsbCxbImFjY2VudCIsImNyb3NzaGFpcl9pbmRpY2F0b3JzIiwiY29tYm8iXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsInJldm9sdmVyX2hlbHBlciIsdHJ1ZV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsInJhZ2Vib3RfbG9ncyIsdHJ1ZV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsInJhZ2Vib3RfbG9ncyIsMzA2LjAsbnVsbCxudWxsLFsieCIsInJhZ2Vib3RfbG9ncyIsInNsaWRlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwicmFnZWJvdF9sb2dzIiwwLjAsbnVsbCxudWxsLFsieSIsInJhZ2Vib3RfbG9ncyIsInNsaWRlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwicmFnZWJvdF9sb2dzIixbIk9uIFNjcmVlbiIsIkNvbnNvbGUiXSxudWxsLG51bGwsWyJkaXNwbGF5IiwicmFnZWJvdF9sb2dzIiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwidGVsZXBvcnRfaW5fYWlyIixmYWxzZV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsInRlbGVwb3J0X2luX2FpciIsMC4wLG51bGwsbnVsbCxbInRpY2tzIiwidGVsZXBvcnRfaW5fYWlyIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJ0ZWxlcG9ydF9pbl9haXIiLFsiU2NvdXQiXSxudWxsLG51bGwsWyJ0ZWxlcG9ydF93ZWFwb25zIiwidGVsZXBvcnRfaW5fYWlyIiwic2VsZWN0YWJsZSJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwidGVsZXBvcnRfaW5fYWlyIiwxLjAsbnVsbCxudWxsLFsiZGFtYWdlIiwidGVsZXBvcnRfaW5fYWlyIiwic2xpZGVyIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJkcm9wX25hZGVzIixmYWxzZV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsImRyb3BfbmFkZXMiLDEuMCxudWxsLG51bGwsWyJkcm9wX2JpbmQiLCJkcm9wX25hZGVzIiwiaG90a2V5Il1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJjdXN0b21fc2NvcGUiLHRydWVdLFsic3dpdGNoIiwic2V0dGluZ3MiLCJjdXN0b21fc2NvcGUiLCJEZWZhdWx0IixudWxsLG51bGwsWyJzdHlsZSIsImN1c3RvbV9zY29wZSIsImNvbWJvIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJjdXN0b21fc2NvcGUiLHRydWUsbnVsbCxudWxsLFsic3ByZWFkIiwiY3VzdG9tX3Njb3BlIiwic3dpdGNoIl1dLFsic3dpdGNoIiwic2V0dGluZ3MiLCJjdXN0b21fc2NvcGUiLCJGRkZGRkZGRiIsbnVsbCxudWxsLFsiY29sb3IiLCJjdXN0b21fc2NvcGUiLCJjb2xvcl9waWNrZXIiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsImN1c3RvbV9zY29wZSIsMTUuMCxudWxsLG51bGwsWyJvZmZzZXQiLCJjdXN0b21fc2NvcGUiLCJzbGlkZXIiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsImN1c3RvbV9zY29wZSIsMTkwLjAsbnVsbCxudWxsLFsiaW5pdGlhbCIsImN1c3RvbV9zY29wZSIsInNsaWRlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwidW5tdXRlX3NpbGVuY2VkIixmYWxzZV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsInlhd19wb3NpdGlvbl9hcnJvd3MiLHRydWVdLFsic3dpdGNoIiwic2V0dGluZ3MiLCJ5YXdfcG9zaXRpb25fYXJyb3dzIiwiOTFBNUU1RkYiLG51bGwsbnVsbCxbIm1hbnVhbF9jb2xvciIsInlhd19wb3NpdGlvbl9hcnJvd3MiLCJjb2xvcl9waWNrZXIiXV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsInlhd19wb3NpdGlvbl9hcnJvd3MiLCI5MUE1RTVGRiIsbnVsbCxudWxsLFsiaW52ZXJ0X2NvbG9yIiwieWF3X3Bvc2l0aW9uX2Fycm93cyIsImNvbG9yX3BpY2tlciJdXSxbInN3aXRjaCIsInNldHRpbmdzIiwiaGl0X21hcmtlciIsdHJ1ZV0sWyJzd2l0Y2giLCJzZXR0aW5ncyIsIm5vX2ZhbGxfZGFtYWdlIix0cnVlXSxbInN3aXRjaCIsInNldHRpbmdzIiwic2hhcmVkX2xvZ28iLHRydWVdXQUmtsUFNrMVdVMmxyYjJaVGIybHFaMDVQVlVwU1UwbFZXVWRUUWxWSldVaG1hVWhUUVdwcGEyNWtaa3BCVTJacWJtdHFhMjVtVTJsaVpHaHFabUpuZFhsVFFraFZSa1ZUVW1scWJtaG1VMHRLVGsxRlptNXFhMmxYVTA1RlptSjFSVk5DVlVoR1UwSkZWVWhaUm1KdVpWTlhUa2xLVFdabmFXcHVTMDFYUlVsS1RrMUxVdw_CHERNOBYL");
        end), 
        local_config_selected = l_mui_0.table(v52.global.configs, "Config selected:", {
            [1] = ""
        }), 
        local_config_name = l_mui_0.text_box(v52.global.configs, "!h<!s<Link Active>>!i<file-signature>!d Config name:", ""), 
        local_save = l_mui_0.button(v52.global.configs, center("!h<!s<Link Active>>!i<upload>!d  Save", 46), true), 
        local_load = l_mui_0.button(v52.global.configs, center("!h<!s<Link Active>>!i<download>!d  Load", 46), true), 
        local_delete = l_mui_0.button(v52.global.configs, center("!h<!s<Link Active>>!i<trash>!d  Delete", 45), true), 
        button_9 = l_mui_0.button(v52.global.config_system, center("!h<!s<Link Active>>!i<file-export>!d  Export config to clipboard", 90), true, function()
            configs.parse_data();
        end), 
        button_10 = l_mui_0.button(v52.global.config_system, center("!h<!s<Link Active>>!i<file-import>!d  Import config from clipboard", 87), true, function()
            configs.paste_data();
        end)
    }, 
    ["anti aim"] = {
        extensions = l_mui_0.multi_combo(v52["anti aim"].extensions, "Anti-aim extensions:", {
            [1] = "Legit anti-aim on E", 
            [2] = "Adjust manual anti-aim", 
            [3] = "Break self backtrack", 
            [4] = "Correct lags on exploits", 
            [5] = "Vigilant lagcomp breaking", 
            [6] = "Automatically generated yaw/desync position", 
            [7] = "Cross teleport", 
            [8] = "Fast fall", 
            [9] = "Fast ladder"
        }), 
        yaw_base = l_mui_0.combo(v52["anti aim"].extensions, "Manual yaw base: ", {
            [1] = "Disabled", 
            [2] = "Left", 
            [3] = "Right", 
            [4] = "Forward", 
            [5] = "Freestanding"
        }), 
        bombsite_fix = l_mui_0.switch(v52["anti aim"].extensions, "\a33FF99ff!i<ban-bug>!d Bombsite E-Fix"), 
        backtrack_type = l_mui_0.combo(v52["anti aim"].extensions, "Break type based on: ", {
            [1] = "Threat", 
            [2] = "Auto"
        }), 
        generated_type = l_mui_0.multi_combo(v52["anti aim"].extensions, "Generate options:", {
            [1] = "Global offset position", 
            [2] = "Body yaw angle deviation", 
            [3] = "Ignore unreliable values"
        }), 
        correct_options = l_mui_0.multi_combo(v52["anti aim"].extensions, "Correct options: ", {
            [1] = "Double Tap", 
            [2] = "Hide Shots"
        }), 
        break_lc = l_mui_0.multi_combo(v52["anti aim"].extensions, "\aFFFF33FF!i<circle-question>!d Decisive controls:", v8["anti aim"].condition), 
        cross_teleport = l_mui_0.text(v52["anti aim"].extensions, "\aFF0000ff!i<circle-exclamation>!d  \"Cross Teleport\" feature is still under development and may not work correctly!"), 
        anim_breakers = l_mui_0.multi_combo(v52["anti aim"].animation_breakers, "\aFF3333FF!i<brake-warning>!d Anim. breakers", {
            [1] = "In air", 
            [2] = "On ground", 
            [3] = "Body lean", 
            [4] = "Reset pitch on land"
        }), 
        in_air_options = l_mui_0.combo(v52["anti aim"].animation_breakers, "In air options", {
            [1] = "Static", 
            [2] = "Moonwalk"
        }), 
        on_ground_options = l_mui_0.combo(v52["anti aim"].animation_breakers, "On ground options", {
            [1] = "Follow direction", 
            [2] = "Jitter legs", 
            [3] = "Moonwalk"
        }), 
        body_lean_amount = l_mui_0.slider(v52["anti aim"].animation_breakers, "Body lean amount", 0, 0, 100, 1, nil, function(v54)
            if v54 == 0 then
                return "off";
            else
                return v54 .. "%";
            end;
        end), 
        preset = l_mui_0.combo(v52["anti aim"].builder, "Current preset:", {
            [1] = "Jitter"
        }), 
        condition = l_mui_0.combo(v52["anti aim"].builder, "Setup condition:", v8["anti aim"].condition)
    }, 
    settings = {
        widgets = l_mui_0.switch(v52.settings.widgets, "Widgets", false, function(v55)
            -- upvalues: l_mui_0 (ref), v8 (ref)
            return {
                selected = l_mui_0.multi_combo(v55, "Selected", {
                    [1] = "Watermark", 
                    [2] = "Keybinds", 
                    [3] = "Spectators", 
                    [4] = "Debug Box", 
                    [5] = "Velocity Warning"
                }), 
                alphas = l_mui_0.slider(v55, "Active items alpha", 35, 0, 255, 1), 
                accent = l_mui_0.combo(v55, "Accent color", {
                    [1] = "Menu Style", 
                    [2] = "Custom"
                }), 
                color = l_mui_0.color_edit(v55, "Color", color(200, 200, 200, 255)), 
                x_watermark = l_mui_0.slider(v55, "x_watermark", v8.screen.x - 100, 0, v8.screen.x, 1), 
                y_watermark = l_mui_0.slider(v55, "y_watermark", 0, 0, v8.screen.y, 1), 
                stapled_watermark = l_mui_0.combo(v55, "stapled_watermark", {
                    [1] = "T-R", 
                    [2] = "T-L", 
                    [3] = "B-C", 
                    [4] = "None"
                }), 
                x_keybinds = l_mui_0.slider(v55, "x_keybinds", 5, 0, v8.screen.x, 1), 
                y_keybinds = l_mui_0.slider(v55, "y_keybinds", v8.screen.y * 0.5 - 10, 0, v8.screen.y, 1), 
                x_spectators = l_mui_0.slider(v55, "x_spectators", 105, 0, v8.screen.x, 1), 
                y_spectators = l_mui_0.slider(v55, "y_spectators", v8.screen.y * 0.5 - 10, 0, v8.screen.y, 1), 
                x_debug_box = l_mui_0.slider(v55, "x_debug_box", 5, 0, v8.screen.x, 1), 
                y_debug_box = l_mui_0.slider(v55, "y_debug_box", v8.screen.y * 0.5 - 100, 0, v8.screen.y, 1), 
                x_velocity_warning = l_mui_0.slider(v55, "x_velocity_warning", v8.screen.x * 0.5 - 87.5, 0, v8.screen.x, 1), 
                y_velocity_warning = l_mui_0.slider(v55, "y_velocity_warning", v8.screen.y * 0.25, 0, v8.screen.y, 1)
            };
        end), 
        crosshair_indicators = l_mui_0.switch(v52.settings.widgets, "Crosshair indicators", false, function(v56)
            -- upvalues: l_mui_0 (ref)
            return {
                display = l_mui_0.multi_combo(v56, "Display elements", {
                    [1] = "Player State", 
                    [2] = "Double Tap", 
                    [3] = "Hide Shots", 
                    [4] = "Body Aim", 
                    [5] = "Safe Points", 
                    [6] = "Freestanding", 
                    [7] = "Fake Duck"
                }), 
                accent = l_mui_0.combo(v56, "Accent color", {
                    [1] = "Menu Style", 
                    [2] = "Custom"
                }), 
                color = l_mui_0.color_edit(v56, "Color", ui.get_style("Link Active"))
            };
        end), 
        custom_scope = l_mui_0.switch(v52.settings.widgets, "Custom scope", false, function(v57)
            -- upvalues: l_mui_0 (ref)
            return {
                color = l_mui_0.color_edit(v57, "Color", color()), 
                initial = l_mui_0.slider(v57, "Initial", 190, 0, 500, 1), 
                offset = l_mui_0.slider(v57, "Offset", 15, 0, 500, 1), 
                spread = l_mui_0.switch(v57, "Spread based", true), 
                style = l_mui_0.combo(v57, "Style", {
                    [1] = "Default", 
                    [2] = "T"
                })
            };
        end), 
        sense_indicators = l_mui_0.switch(v52.settings.widgets, "500$ indicators", false, function(v58)
            -- upvalues: l_mui_0 (ref)
            return {
                display = l_mui_0.multi_combo(v58, "Display", {
                    [1] = "Double Tap", 
                    [2] = "Hide Shots", 
                    [3] = "Dormant Aimbot", 
                    [4] = "Minimum Damage", 
                    [5] = "Hit Chance", 
                    [6] = "Freestanding", 
                    [7] = "Fake Duck", 
                    [8] = "Fake Latency", 
                    [9] = "Body Aim", 
                    [10] = "Safe Points", 
                    [11] = "Bomb Info", 
                    [12] = "Defusing", 
                    [13] = "Aimbot Stats", 
                    [14] = "Fake Lag"
                }), 
                spectators = l_mui_0.switch(v58, "Spectators", false)
            };
        end), 
        yaw_position_arrows = l_mui_0.switch(v52.settings.widgets, "Yaw position arrows", false, function(v59)
            -- upvalues: l_mui_0 (ref)
            return {
                manual_color = l_mui_0.color_edit(v59, "Manual Color", color(145, 165, 229, 255)), 
                invert_color = l_mui_0.color_edit(v59, "Invert Color", color(145, 165, 229, 255))
            };
        end), 
        no_fall_damage = l_mui_0.switch(v52.settings.main, "No fall damage", false), 
        revolver_helper = l_mui_0.switch(v52.settings.main, "Revolver helper", false), 
        teleport_in_air = l_mui_0.switch(v52.settings.main, "Teleport in air", false, function(v60)
            -- upvalues: l_mui_0 (ref)
            return {
                teleport_weapons = l_mui_0.multi_combo(v60, "Weapons", {
                    [1] = "AWP", 
                    [2] = "AutoSnipers", 
                    [3] = "Scout", 
                    [4] = "Deagle", 
                    [5] = "Revolver", 
                    [6] = "Nades", 
                    [7] = "Other", 
                    [8] = "Pistols", 
                    [9] = "Rifle/LMG", 
                    [10] = "SMG", 
                    [11] = "Shotgun", 
                    [12] = "Taser"
                }), 
                damage = l_mui_0.slider(v60, "Min. damage", 0, 0, 100, 1, nil, function(v61)
                    return v61 == 0 and "Lethal" or v61;
                end), 
                ticks = l_mui_0.slider(v60, "Predicted ticks", 0, 0, 15)
            };
        end), 
        boost_framerate = l_mui_0.switch(v52.settings.main, "Boost framerate", false), 
        clantag_spammer = l_mui_0.switch(v52.settings.main, "Clantag spammer", false), 
        taskbar_notify = l_mui_0.switch(v52.settings.modify, "Nothing", false), 
        trashtalk = l_mui_0.switch(v52.settings.modify, "Shit talking", false, function(v62)
            -- upvalues: l_mui_0 (ref)
            return {
                trashtalk_options = l_mui_0.multi_table(v62, "Shit talking options:", {
                    [1] = "On kill", 
                    [2] = "On assist", 
                    [3] = "On self death", 
                    [4] = "On killers death"
                })
            };
        end), 
        unmute_silenced = l_mui_0.switch(v52.settings.modify, "Unmute silenced players", false), 
        hit_marker = l_mui_0.switch(v52.settings.modify, "Hit marker", false), 
        shared_logo = l_mui_0.switch(v52.settings.modify, "Nothing", false), 
        ragebot_logs = l_mui_0.switch(v52.settings.other, "Ragebot logs", false, function(v63)
            -- upvalues: l_mui_0 (ref), v8 (ref)
            return {
                display = l_mui_0.multi_combo(v63, "Display", {
                    [1] = "On Screen", 
                    [2] = "Console"
                }), 
                x = l_mui_0.slider(v63, "x", 0, 0, v8.screen.x, 1), 
                y = l_mui_0.slider(v63, "y", 0, 0, v8.screen.y, 1)
            };
        end), 
        grenade_radius = l_mui_0.switch(v52.settings.other, "Grenade radius", false, function(v64)
            -- upvalues: l_mui_0 (ref)
            return {
                display = l_mui_0.multi_combo(v64, "Display", {
                    [1] = "Smoke", 
                    [2] = "Molotov"
                }), 
                smoke = l_mui_0.color_edit(v64, "Smoke", color(127, 127, 255)), 
                molotov = l_mui_0.color_edit(v64, "Molotov", color(255, 127, 127))
            };
        end), 
        air_strafe_fix = l_mui_0.switch(v52.settings.other, "Air strafe fix", false), 
        viewmodel_changer = l_mui_0.switch(v52.settings.other, "Viewmodel changer", false, function(v65)
            -- upvalues: l_mui_0 (ref)
            return {
                viewmodel_fov = l_mui_0.slider(v65, "Offset FOV", 680, -1800, 1800, 0.1), 
                viewmodel_x = l_mui_0.slider(v65, "Offset X", 25, -1800, 1800, 0.1), 
                viewmodel_y = l_mui_0.slider(v65, "Offset Y", 0, -1800, 1800, 0.1), 
                viewmodel_z = l_mui_0.slider(v65, "Offset Z", -15, -1800, 1800, 0.1), 
                aspect_ratio = l_mui_0.slider(v65, "Aspect ratio", 0, 0, 500, 0.01)
            };
        end), 
        drop_nades = l_mui_0.switch(v52.settings.other, "Drop grenades", false, function(v66)
            -- upvalues: l_mui_0 (ref)
            return {
                drop_bind = l_mui_0.hotkey(v66, "Bind")
            };
        end)
    }
};
v67.settings.viewmodel_changer:set_callback(function(v68)
    -- upvalues: v67 (ref)
    v67.settings.viewmodel_changer[0].viewmodel_fov:visibility(v68:get());
    v67.settings.viewmodel_changer[0].viewmodel_x:visibility(v68:get());
    v67.settings.viewmodel_changer[0].viewmodel_y:visibility(v68:get());
    v67.settings.viewmodel_changer[0].viewmodel_z:visibility(v68:get());
    v67.settings.viewmodel_changer[0].aspect_ratio:visibility(v68:get());
end, true);
v67.settings.teleport_in_air:set_callback(function(v69)
    -- upvalues: v67 (ref)
    v67.settings.teleport_in_air[0].teleport_weapons:visibility(v69:get());
    v67.settings.teleport_in_air[0].damage:visibility(v69:get());
    v67.settings.teleport_in_air[0].ticks:visibility(v69:get());
end, true);
v67.settings.grenade_radius:set_callback(function(v70)
    -- upvalues: v67 (ref)
    v67.settings.grenade_radius[0].display:visibility(v70:get());
    v67.settings.grenade_radius[0].display:set_callback(function(v71)
        -- upvalues: v67 (ref), v70 (ref)
        v67.settings.grenade_radius[0].smoke:visibility(v70:get() and v71:get("Smoke"));
        v67.settings.grenade_radius[0].molotov:visibility(v70:get() and v71:get("Molotov"));
    end, true);
end, true);
v67.settings.drop_nades:set_callback(function(v72)
    -- upvalues: v67 (ref)
    v67.settings.drop_nades[0].drop_bind:visibility(v72:get());
end, true);
v67.settings.trashtalk:set_callback(function(v73)
    -- upvalues: v67 (ref)
    v67.settings.trashtalk[0].trashtalk_options:visibility(v73:get());
end, true);
v67.settings.widgets:set_callback(function(v74)
    -- upvalues: v67 (ref)
    v67.settings.widgets[0].selected:visibility(v74:get());
    v67.settings.widgets[0].selected:set_callback(function(v75)
        -- upvalues: v67 (ref), v74 (ref)
        v67.settings.widgets[0].alphas:visibility(v74:get() and (v75:get("Keybinds") or v75:get("Spectators")));
        v67.settings.widgets[0].accent:visibility(v74:get() and #v75:get() > 0);
        v67.settings.widgets[0].accent:set_callback(function(v76)
            -- upvalues: v67 (ref), v74 (ref), v75 (ref)
            v67.settings.widgets[0].color:visibility(v74:get() and #v75:get() > 0 and v76:get() == "Custom");
        end, true);
    end, true);
end, true);
v67.settings.crosshair_indicators:set_callback(function(v77)
    -- upvalues: v67 (ref)
    v67.settings.crosshair_indicators[0].display:visibility(v77:get());
    v67.settings.crosshair_indicators[0].accent:visibility(v77:get());
    v67.settings.crosshair_indicators[0].accent:set_callback(function(v78)
        -- upvalues: v67 (ref), v77 (ref)
        v67.settings.crosshair_indicators[0].color:visibility(v77:get() and v78:get() == "Custom");
    end, true);
end, true);
v67.settings.custom_scope:set_callback(function(v79)
    -- upvalues: v53 (ref), v67 (ref)
    v53["Scope Overlay"]:override(v79:get() and "Remove All" or nil);
    v67.settings.custom_scope[0].color:visibility(v79:get());
    v67.settings.custom_scope[0].initial:visibility(v79:get());
    v67.settings.custom_scope[0].offset:visibility(v79:get());
    v67.settings.custom_scope[0].spread:visibility(v79:get());
    v67.settings.custom_scope[0].style:visibility(v79:get());
end, true);
v67.settings.sense_indicators:set_callback(function(v80)
    -- upvalues: v67 (ref)
    v67.settings.sense_indicators[0].display:visibility(v80:get());
    v67.settings.sense_indicators[0].spectators:visibility(v80:get());
end, true);
v67.settings.ragebot_logs:set_callback(function(v81)
    -- upvalues: v67 (ref)
    v67.settings.ragebot_logs[0].display:visibility(v81:get());
end, true);
v67.settings.yaw_position_arrows:set_callback(function(v82)
    -- upvalues: v67 (ref)
    v67.settings.yaw_position_arrows[0].manual_color:visibility(v82:get());
    v67.settings.yaw_position_arrows[0].invert_color:visibility(v82:get());
end, true);
v67.settings.hit_marker:set_callback(function(v83)
    -- upvalues: v8 (ref)
    ui.find("Visuals", "World", "Other", "Hit Marker", "3D Marker"):override(v8.to_bool(v83:get() and "false" or nil));
end, true);
v67.settings.widgets[0].x_watermark:visibility(false);
v67.settings.widgets[0].y_watermark:visibility(false);
v67.settings.widgets[0].stapled_watermark:visibility(false);
v67.settings.widgets[0].x_keybinds:visibility(false);
v67.settings.widgets[0].y_keybinds:visibility(false);
v67.settings.widgets[0].x_spectators:visibility(false);
v67.settings.widgets[0].y_spectators:visibility(false);
v67.settings.widgets[0].x_debug_box:visibility(false);
v67.settings.widgets[0].y_debug_box:visibility(false);
v67.settings.widgets[0].x_velocity_warning:visibility(false);
v67.settings.widgets[0].y_velocity_warning:visibility(false);
v67.settings.ragebot_logs[0].x:visibility(false);
v67.settings.ragebot_logs[0].y:visibility(false);
v67["anti aim"].anim_breakers:set_callback(function(v84)
    -- upvalues: v67 (ref)
    v67["anti aim"].in_air_options:visibility(v84:get("In air"));
    v67["anti aim"].on_ground_options:visibility(v84:get("On ground"));
    v67["anti aim"].body_lean_amount:visibility(v84:get("Body lean"));
end, true);
v67["anti aim"].extensions:set_callback(function(v85)
    -- upvalues: v67 (ref)
    v67["anti aim"].yaw_base:visibility(v85:get("Adjust manual anti-aim"));
    v67["anti aim"].correct_options:visibility(v85:get("Correct lags on exploits"));
    v67["anti aim"].generated_type:visibility(v85:get("Automatically generated yaw/desync position"));
    v67["anti aim"].bombsite_fix:visibility(v85:get("Legit anti-aim on E"));
    v67["anti aim"].break_lc:visibility(v85:get("Vigilant lagcomp breaking"));
    v67["anti aim"].backtrack_type:visibility(v85:get("Break self backtrack"));
    v67["anti aim"].cross_teleport:visibility(v85:get("Cross teleport"));
end, true);
for v86 = 1, #v8["anti aim"].condition do
    local v87 = v8["anti aim"].condition[v86];
    v67["anti aim"][("%s.%s"):format(v87, "enable")] = l_mui_0.switch(v52["anti aim"].builder, ("Override settings for !h<C4BFEFFF>%s!d"):format(string.lower(v87)));
    v67["anti aim"][("%s.%s"):format(v87, "yaw_base")] = l_mui_0.combo(v52["anti aim"].builder, "yaw base", {
        [1] = "Local View", 
        [2] = "At Target"
    });
    v67["anti aim"][("%s.%s"):format(v87, "offset_left")] = l_mui_0.slider(v52["anti aim"].builder, "offset left", 0, -180, 180, 1, nil, "\194\176");
    v67["anti aim"][("%s.%s"):format(v87, "offset_right")] = l_mui_0.slider(v52["anti aim"].builder, "offset right", 0, -180, 180, 1, nil, "\194\176");
    v67["anti aim"][("%s.%s"):format(v87, "yaw_modifier")] = l_mui_0.combo(v52["anti aim"].builder, "yaw modifier", {
        [1] = "Disabled", 
        [2] = "Center", 
        [3] = "Offset", 
        [4] = "Random", 
        [5] = "Spin", 
        [6] = "3-Way", 
        [7] = "5-Way", 
        [8] = "Proggresive"
    });
    v67["anti aim"][("%s.%s"):format(v87, "yaw_modifier_offset")] = l_mui_0.slider(v52["anti aim"].builder, "yaw modifier offset", 0, -180, 180, 1, nil, "\194\176");
    v67["anti aim"][("%s.%s"):format(v87, "left_limit")] = l_mui_0.slider(v52["anti aim"].builder, "left limit", 60, 0, 60, 1, nil, "\194\176");
    v67["anti aim"][("%s.%s"):format(v87, "right_limit")] = l_mui_0.slider(v52["anti aim"].builder, "right limit", 60, 0, 60, 1, nil, "\194\176");
    v67["anti aim"][("%s.%s"):format(v87, "fake_options")] = l_mui_0.multi_combo(v52["anti aim"].builder, "fake options", {
        [1] = "Avoid Overlap", 
        [2] = "Jitter", 
        [3] = "Randomize Jitter", 
        [4] = "Anti Bruteforce"
    });
    v67["anti aim"][("%s.%s"):format(v87, "delay_tick")] = l_mui_0.slider(v52["anti aim"].builder, "delay tick", 0, 0, 100, 1, nil, function(v88)
        if v88 == 0 then
            return "NL";
        else
            return ("%s%%"):format(v88);
        end;
    end);
    v67["anti aim"][("%s.%s"):format(v87, "hidden_lc")] = l_mui_0.switch(v52["anti aim"].builder, "!h<FFFF33FF>!i<circle-question>!d  hide lc anti aim", false, function(v89)
        -- upvalues: l_mui_0 (ref)
        return {
            pitch = l_mui_0.combo(v89, "pitch", {
                [1] = "Down", 
                [2] = "Disabled", 
                [3] = "Up", 
                [4] = "Random", 
                [5] = "Medium", 
                [6] = "Switch Up", 
                [7] = "Switch Down", 
                [8] = "Custom"
            }), 
            pitch_slider = l_mui_0.slider(v89, "angle", 0, -89, 89, 1, nil, "\194\176"), 
            type = l_mui_0.combo(v89, "type", {
                [1] = "Disabled", 
                [2] = "Neverlose", 
                [3] = "Meta", 
                [4] = "Switch", 
                [5] = "Spin", 
                [6] = "Free Sway", 
                [7] = "Forward", 
                [8] = "Switch Left", 
                [9] = "Switch Right", 
                [10] = "Custom"
            }), 
            sensitivity = l_mui_0.slider(v89, "sensitivity", 0, 0, 100, 1, nil, "%"), 
            yaw_slider_1 = l_mui_0.slider(v89, "offset left", 0, -180, 180, 1, nil, "\194\176"), 
            yaw_slider_2 = l_mui_0.slider(v89, "offset right", 0, -180, 180, 1, nil, "\194\176")
        };
    end);
    do
        local l_v87_0 = v87;
        v67["anti aim"][("%s.%s"):format(l_v87_0, "enable")]:set_callback(function(v91)
            -- upvalues: l_v87_0 (ref), v67 (ref)
            local v92 = l_v87_0 == v67["anti aim"].condition:get();
            v67["anti aim"][("%s.%s"):format(l_v87_0, "yaw_base")]:visibility(v92 and v91:get());
            v67["anti aim"][("%s.%s"):format(l_v87_0, "offset_left")]:visibility(v92 and v91:get());
            v67["anti aim"][("%s.%s"):format(l_v87_0, "offset_right")]:visibility(v92 and v91:get());
            v67["anti aim"][("%s.%s"):format(l_v87_0, "yaw_modifier")]:visibility(v92 and v91:get());
            v67["anti aim"][("%s.%s"):format(l_v87_0, "yaw_modifier")]:set_callback(function(v93)
                -- upvalues: v67 (ref), l_v87_0 (ref), v92 (ref), v91 (ref)
                v67["anti aim"][("%s.%s"):format(l_v87_0, "yaw_modifier_offset")]:visibility(v92 and v91:get() and v93:get() ~= "Disabled");
            end, true);
            v67["anti aim"][("%s.%s"):format(l_v87_0, "left_limit")]:visibility(v92 and v91:get());
            v67["anti aim"][("%s.%s"):format(l_v87_0, "right_limit")]:visibility(v92 and v91:get());
            v67["anti aim"][("%s.%s"):format(l_v87_0, "fake_options")]:visibility(v92 and v91:get());
            v67["anti aim"][("%s.%s"):format(l_v87_0, "fake_options")]:set_callback(function(v94)
                -- upvalues: v67 (ref), l_v87_0 (ref), v92 (ref), v91 (ref)
                v67["anti aim"][("%s.%s"):format(l_v87_0, "delay_tick")]:visibility(v92 and v91:get() and v94:get("Jitter"));
            end, true);
            v67["anti aim"][("%s.%s"):format(l_v87_0, "hidden_lc")]:visibility(v92 and v91:get());
            v67["anti aim"][("%s.%s"):format(l_v87_0, "hidden_lc")].gear.pitch:set_callback(function(v95)
                -- upvalues: v67 (ref), l_v87_0 (ref), v92 (ref), v91 (ref)
                v67["anti aim"][("%s.%s"):format(l_v87_0, "hidden_lc")].gear.pitch_slider:visibility(v92 and v91:get() and v95:get() == "Custom");
            end, true);
            v67["anti aim"][("%s.%s"):format(l_v87_0, "hidden_lc")].gear.type:set_callback(function(v96)
                -- upvalues: v67 (ref), l_v87_0 (ref), v92 (ref), v91 (ref)
                v67["anti aim"][("%s.%s"):format(l_v87_0, "hidden_lc")].gear.sensitivity:visibility(v92 and v91:get() and v96:get() == "Spin");
                v67["anti aim"][("%s.%s"):format(l_v87_0, "hidden_lc")].gear.yaw_slider_2:visibility(v92 and v91:get() and v96:get() == "Custom");
                v67["anti aim"][("%s.%s"):format(l_v87_0, "hidden_lc")].gear.yaw_slider_1:visibility(v92 and v91:get() and v96:get() == "Custom");
            end, true);
        end, true);
    end;
end;
v67["anti aim"].bombsite_fix:tooltip("In the bomb zone, pressing E will not set off the bomb.");
v67["anti aim"].condition:set_callback(function(v97)
    -- upvalues: v8 (ref), v67 (ref)
    for v98 = 1, #v8["anti aim"].condition do
        local v99 = v8["anti aim"].condition[v98];
        v67["anti aim"][("%s.%s"):format(v99, "enable")]:visibility(v97:get() == v99);
        v67["anti aim"][("%s.%s"):format(v99, "enable")]:set(v67["anti aim"][("%s.%s"):format(v99, "enable")]:get());
    end;
end, true);
local v100 = {};
local v101 = {
    main = {
        switch_choke = false, 
        already = false, 
        is_in_bombsite = false, 
        enabled = true, 
        legit_aa = false, 
        legit_time = globals.realtime
    }, 
    data = {
        Hidden = false, 
        ["Fake Options"] = "", 
        ["Yaw Offset"] = 0, 
        Yaw = "Backward", 
        Freestanding = "Off", 
        Pitch = "Disabled", 
        ["Right Limit"] = 60, 
        ["Left Limit"] = 60, 
        Inverter = false, 
        ["Body Yaw"] = true, 
        ["Yaw Modifier"] = "Disabled"
    }, 
    converter = {
        SW = "Slowwalking", 
        M = "Running", 
        S = "Standing", 
        C = "Crouching", 
        G = "Global", 
        AC = "Crouching Air", 
        A = "Jumping"
    }, 
    jitter_speed = {
        state = false, 
        tick = 0
    }, 
    hidden_lc = {
        pitch = {
            ["Switch Down"] = 8, 
            ["Switch Up"] = 2004, 
            Disabled = 0, 
            Up = -89, 
            Down = 89, 
            Medium = 2006, 
            Random = 1337, 
            Custom = 228
        }
    }, 
    presets = {
        Jitter = {
            Global = {
                [1] = 0, 
                [2] = 0, 
                [3] = "Center", 
                [4] = 0, 
                [5] = 0, 
                [6] = 0, 
                [7] = nil, 
                [8] = "Off", 
                [7] = {}
            }, 
            Standing = {
                [1] = -3, 
                [2] = 30, 
                [3] = "Center", 
                [4] = -40, 
                [5] = 58, 
                [6] = 58, 
                [7] = "Jitter", 
                [8] = "Off"
            }, 
            Running = {
                [1] = -14, 
                [2] = 10, 
                [3] = "Center", 
                [4] = -52, 
                [5] = 36, 
                [6] = 36, 
                [7] = "Jitter", 
                [8] = "Off"
            }, 
            Slowwalking = {
                [1] = -30, 
                [2] = 42, 
                [3] = "Center", 
                [4] = -15, 
                [5] = 45, 
                [6] = 45, 
                [7] = "Jitter", 
                [8] = "Off"
            }, 
            Crouching = {
                [1] = -30, 
                [2] = 42, 
                [3] = "Center", 
                [4] = -15, 
                [5] = 45, 
                [6] = 45, 
                [7] = "Jitter", 
                [8] = "Off"
            }, 
            Jumping = {
                [1] = -17, 
                [2] = 30, 
                [3] = "Center", 
                [4] = -25, 
                [5] = 58, 
                [6] = 58, 
                [7] = "Jitter", 
                [8] = "Off"
            }, 
            ["Crouching Air"] = {
                [1] = 6, 
                [2] = 13, 
                [3] = "Center", 
                [4] = -64, 
                [5] = 58, 
                [6] = 58, 
                [7] = "Jitter", 
                [8] = "Off"
            }
        }
    }
};
v101.legit_aa = function(v102)
    -- upvalues: v101 (ref)
    v101.main.legit_aa = false;
    if not v102.in_use then
        v101.main.legit_time = globals.realtime;
        return;
    else
        local v103 = entity.get_local_player();
        if v103 == nil then
            return;
        else
            local v104 = v103:get_origin();
            local v105 = entity.get_entities("CPlantedC4");
            local v106 = 999;
            if #v105 > 0 then
                v106 = v104:dist((v105[1]:get_origin()));
            end;
            local v107 = entity.get_entities("CHostage");
            local v108 = 999;
            if #v107 > 0 and v107[1] and v107[2] then
                local v109 = {
                    v107[1]:get_origin(), 
                    v107[2]:get_origin()
                };
                v108 = math.min(v104:dist(v109[1]), v104:dist(v109[2]));
            end;
            if v108 < 65 and v103.m_iTeamNum ~= 2 then
                return;
            elseif v106 < 65 and v103.m_iTeamNum ~= 2 then
                return;
            elseif v102.in_use and globals.realtime - v101.main.legit_time < 0.02 then
                return;
            else
                v102.in_use = false;
                v101.main.legit_aa = true;
                return;
            end;
        end;
    end;
end;
v101.deg_to_rad = function(v110)
    return v110 * (math.pi / 180);
end;
v101.angle_to_vector = function(v111)
    -- upvalues: v101 (ref)
    local v112 = math.cos(v101.deg_to_rad(v111.x));
    local v113 = math.sin(v101.deg_to_rad(v111.x));
    local v114 = math.cos(v101.deg_to_rad(v111.y));
    local v115 = math.sin(v101.deg_to_rad(v111.y));
    local v116 = vector(0, 0, 0);
    v116.x = v112 * v114;
    v116.y = v112 * v115;
    v116.z = -v113;
    return v116;
end;
v101.bombsite_fix = function(v117)
    -- upvalues: v101 (ref), v67 (ref)
    local v118 = entity.get_local_player();
    v101.is_in_bombsite = false;
    if v67["anti aim"].extensions:get("Legit anti-aim on E") and v67["anti aim"].bombsite_fix:get() and v118 and v118:is_alive() and globals.is_connected and v118.m_iTeamNum == 2 then
        if not (function()
            -- upvalues: v101 (ref), v118 (ref)
            for v119 = 18, 360, 18 do
                v119 = math.normalize_yaw(v119);
                v101.vecnew = v118:get_origin();
                local v120 = vector(0, v119, 0);
                local v121 = v101.vecnew + v101.angle_to_vector(v120) * 64;
                local v122 = utils.trace_line(v101.vecnew, v121, v118, 4294967295);
                if v122.entity and v122.entity:get_classname() == "CBaseDoor" then
                    return true;
                end;
            end;
            return false;
        end)() then
            if v101.is_in_bombsite and bit.band(v117.buttons, 32) == 32 then
                v117.buttons = bit.band(v117.buttons, bit.bnot(32));
            end;
        else
            v101.is_in_bombsite = false;
        end;
    end;
end;
v101.break_self_backtrack = function(v123)
    -- upvalues: v67 (ref), l_liberia_0 (ref)
    if v67["anti aim"].extensions:get("Break self backtrack") then
        local v124 = entity.get_local_player();
        if v124 and v124:is_alive() then
            local v125 = l_liberia_0.anti_aim.condition.get();
            if v125 == "G" then
                return;
            else
                local v126 = v125 == "A" or v125 == "AC";
                if v67["anti aim"].backtrack_type:get() == "Threat" then
                    if entity.get_threat(true) then
                        v123.force_defensive = true;
                    end;
                else
                    v123.force_defensive = v126 and math.random(18) >= 15;
                end;
            end;
        end;
    end;
end;
v101.correct_lags_on_exploits = function()
    -- upvalues: v67 (ref), v53 (ref), v8 (ref)
    if v67["anti aim"].extensions:get("Correct lags on exploits") then
        local v127 = entity.get_local_player();
        if v127 and v127:is_alive() and not v53["Fake Duck"]:get() then
            if v67["anti aim"].correct_options:get("Double Tap") and v53["Double Tap"]:get() then
                smart_override(v8.enabled, v53["Fakelag Limit"], 1, 14);
            end;
            if v67["anti aim"].correct_options:get("Hide Shots") and v53["Hide Shots"]:get() then
                smart_override(v8.enabled, v53["Fakelag Limit"], 1, 14);
            end;
            if not v53["Hide Shots"]:get() and not v53["Double Tap"]:get() then
                smart_override(v8.enabled, v53["Fakelag Limit"], nil, nil);
            end;
        else
            smart_override(v8.enabled, v53["Fakelag Limit"], nil, 14);
        end;
    else
        smart_override(v8.enabled, v53["Fakelag Limit"], nil, 14);
    end;
end;
v101.fast_ladder = function(v128)
    -- upvalues: v67 (ref)
    if v67["anti aim"].extensions:get("Fast ladder") then
        local v129 = entity.get_local_player();
        if v129 and v129:is_alive() and v129.m_MoveType == 9 then
            for _, v131 in pairs({
                [1] = 43, 
                [2] = 44, 
                [3] = 45, 
                [4] = 46, 
                [5] = 47, 
                [6] = 48
            }) do
                if v129:get_player_weapon() == nil then
                    return;
                elseif v129:get_player_weapon():get_weapon_index() == v131 then
                    return;
                end;
            end;
            local v132 = 113;
            if v128.in_forward and v128.in_moveleft then
                v128.in_back = 1;
                v128.in_forward = 0;
                v128.in_moveleft = 0;
                v128.in_moveright = 1;
                v132 = 180;
            elseif v128.in_forward and v128.in_moveright then
                v128.in_back = 1;
                v128.in_forward = 0;
                v128.in_moveleft = 1;
                v128.in_moveright = 0;
                v132 = 180;
            elseif v128.in_back and v128.in_moveright then
                v128.in_back = 0;
                v128.in_forward = 1;
                v128.in_moveleft = 1;
                v128.in_moveright = 0;
                v132 = 180;
            elseif v128.in_back and v128.in_moveleft then
                v128.in_back = 0;
                v128.in_forward = 1;
                v128.in_moveleft = 0;
                v128.in_moveright = 1;
                v132 = 180;
            elseif v128.in_moveleft then
                v128.in_back = 0;
                v128.in_forward = 0;
                v128.in_moveleft = 0;
                v128.in_moveright = 1;
                v132 = 180;
            elseif v128.in_moveright then
                v128.in_back = 0;
                v128.in_forward = 0;
                v128.in_moveleft = 1;
                v128.in_moveright = 0;
                v132 = 180;
            elseif v128.in_forward then
                v128.in_back = 1;
                v128.in_forward = 0;
                v128.in_moveleft = 0;
                v128.in_moveright = 1;
            elseif v128.in_back then
                v128.in_back = 0;
                v128.in_forward = 1;
                v128.in_moveleft = 1;
                v128.in_moveright = 0;
                v132 = 96;
            end;
            local v133 = 90;
            local v134 = render.camera_angles().y + v132;
            v128.view_angles.x = v133;
            v128.view_angles.y = v134;
        end;
    end;
end;
v101.ffobject = {
    time = 0, 
    jump = false
};
v101.fast_fall = function(v135)
    -- upvalues: v67 (ref), v101 (ref)
    if v67["anti aim"].extensions:get("Fast fall") then
        local v136 = entity.get_local_player();
        if v136 and v136:is_alive() then
            local v137 = v136:get_origin();
            local v138 = (v136.m_vecVelocity * vector(1, 1, 0)):length();
            if v137 and v138 > 255 then
                local l_fraction_0 = utils.trace_line(v137, v137 + vector(0, 0, -256), v136).fraction;
                if v135.in_jump then
                    v101.ffobject.jump = true;
                    v101.ffobject.time = globals.curtime;
                elseif v101.ffobject.jump and l_fraction_0 <= 0.1 and globals.curtime - v101.ffobject.time > 0.1 then
                    rage.exploit:force_teleport();
                    v101.ffobject.jump = false;
                    v101.ffobject.time = 0;
                end;
            end;
        end;
    end;
end;
v101.cross_teleport = function()
    -- upvalues: v67 (ref), v101 (ref)
    if v67["anti aim"].extensions:get("Cross teleport") then
        local v140 = entity.get_local_player();
        if v140 and v140:is_alive() then
            local v141 = false;
            for _, v143 in pairs(entity.get_players(true, false)) do
                local v144, v145 = utils.trace_bullet(v143, v143:get_eye_position(), v140:get_eye_position());
                if v143 ~= v140 and v145 ~= nil and v144 > 0 and not v143:is_dormant() and v145:did_hit_non_world() then
                    v141 = true;
                end;
            end;
            if v141 and not bit.band(v140.m_fFlags, bit.lshift(1, 0)) ~= 0 then
                if not v101.main.already then
                    rage.exploit:force_teleport();
                    v101.main.already = true;
                end;
            else
                v101.main.already = false;
            end;
        end;
    end;
end;
v101.vigilant_lagcomp_breaking = function()
    -- upvalues: v67 (ref), v101 (ref), l_liberia_0 (ref), v8 (ref), v53 (ref)
    if v67["anti aim"].extensions:get("Correct lags on exploits") then
        local v146 = entity.get_local_player();
        if v146 and v146:is_alive() then
            local v147 = v101.converter[l_liberia_0.anti_aim.condition.get()];
            smart_override(v8.enabled, v53["Double Tap Options"], v67["anti aim"].break_lc:get(v147) and "Always On" or nil, "On Peek");
            smart_override(v8.enabled, v53["Hide Shots Options"], v67["anti aim"].break_lc:get(v147) and "Break LC" or nil, "Favor Fire Rate");
        end;
    end;
end;
v101.round_counter = 0;
v101.round_yaw_random = math.random(-5, 5);
v101.round_body_random = math.random(-10, 10);
v101.generate_offset = function()
    -- upvalues: v67 (ref), v101 (ref)
    if v67["anti aim"].extensions:get("Automatically generated yaw/desync position") then
        math.randomseed(globals.tickcount);
        v101.round_counter = v101.round_counter + 1;
        if v101.round_counter > 5 then
            v101.round_counter = 0;
        end;
        if v67["anti aim"].generated_type:get("Global offset position") then
            v101.round_yaw_random = table.switcher(v101.round_counter, {
                [0] = math.random(-10, 10), 
                [1] = math.random(-15, 20), 
                [2] = math.random(-12, 15), 
                [3] = math.random(-23, 22), 
                [4] = math.random(-12, 16), 
                [5] = math.random(-16, 30)
            });
        else
            v101.round_yaw_random = 0;
        end;
        if v67["anti aim"].generated_type:get("Body yaw angle deviation") then
            v101.round_body_random = table.switcher(v101.round_counter, {
                [0] = math.random(-22, 22), 
                [1] = math.random(-15, 10), 
                [2] = math.random(-30, 8), 
                [3] = math.random(-6, 28), 
                [4] = math.random(-24, 7), 
                [5] = math.random(-16, 26)
            });
        else
            v101.round_body_random = 0;
        end;
        if v67["anti aim"].generated_type:get("Ignore unreliable values") then
            if v101.data["Left Limit"] < 40 then
                v101.round_body_random = math.random(15);
            end;
            if v101.data["Right Limit"] < 40 then
                v101.round_body_random = math.random(15);
            end;
        end;
    else
        local l_v101_0 = v101;
        local l_v101_1 = v101;
        local v150 = 0;
        l_v101_1.round_body_random = 0;
        l_v101_0.round_yaw_random = v150;
    end;
end;
v101.executer = function()
    -- upvalues: l_liberia_0 (ref), v67 (ref), v101 (ref), v53 (ref), v8 (ref), v100 (ref)
    local v151 = entity.get_local_player();
    if not v151 or not v151:is_alive() then
        return;
    else
        local v152 = l_liberia_0.anti_aim.condition.get({
            [1] = v67["anti aim"][("%s.%s"):format("Standing", "enable")]:get() and "S" or "", 
            [2] = v67["anti aim"][("%s.%s"):format("Running", "enable")]:get() and "M" or "", 
            [3] = v67["anti aim"][("%s.%s"):format("Slowwalking", "enable")]:get() and "SW" or "", 
            [4] = v67["anti aim"][("%s.%s"):format("Crouching", "enable")]:get() and "C" or "", 
            [5] = v67["anti aim"][("%s.%s"):format("Jumping", "enable")]:get() and "A" or "", 
            [6] = v67["anti aim"][("%s.%s"):format("Crouching Air", "enable")]:get() and "AC" or ""
        });
        v152 = v101.converter[v152];
        if globals.choked_commands == 0 then
            v101.main.switch_choke = globals.tickcount % 4 == 0;
            local v153 = not rage.antiaim:inverter();
            v101.data.Pitch = "Down";
            v101.data.Yaw = "Backward";
            v101.data["Body Yaw"] = true;
            if v152 == "Global" then
                v152 = l_liberia_0.anti_aim.condition.get();
                v152 = v101.converter[v152];
                local v154 = v101.presets[v67["anti aim"].preset:get()][v152];
                if not v154 then
                    return;
                else
                    v101.data["Yaw Offset"] = (v153 and v154[1] or v154[2]) + v101.round_yaw_random;
                    v101.data["Yaw Modifier"] = v154[3];
                    v101.data["Modifier Offset"] = v154[4];
                    v101.data["Left Limit"] = v154[5] - math.abs(v101.round_body_random);
                    v101.data["Right Limit"] = v154[6] - math.abs(v101.round_body_random);
                    v101.data["Fake Options"] = v154[7];
                    v101.data.Hidden = false;
                    v101.data["Yaw Base"] = "At Target";
                end;
            else
                local function v158(v155, v156, v157)
                    -- upvalues: v67 (ref), v152 (ref)
                    if not v157 then
                        if v156 then
                            return v67["anti aim"][("%s.%s"):format(v152, v155)]:get(v156);
                        else
                            return v67["anti aim"][("%s.%s"):format(v152, v155)]:get();
                        end;
                    elseif v156 then
                        return v67["anti aim"][("%s.%s"):format(v152, v155)].gear[v157]:get(v156);
                    else
                        return v67["anti aim"][("%s.%s"):format(v152, v155)].gear[v157]:get();
                    end;
                end;
                v101.data["Yaw Base"] = v158("yaw_base");
                local v159 = math.ceil(0.16 * v158("delay_tick"));
                if v159 > 0 and v158("fake_options", "Jitter") then
                    if v159 < v101.jitter_speed.tick then
                        v101.jitter_speed.state = not v101.jitter_speed.state;
                        v101.jitter_speed.tick = 0;
                    end;
                    v101.data.Inverter = v101.jitter_speed.state;
                    v101.jitter_speed.tick = v101.jitter_speed.tick + 1;
                    v153 = v101.jitter_speed.state;
                else
                    v101.jitter_speed.state = v153;
                end;
                v101.data["Yaw Offset"] = v153 and v158("offset_left") or v158("offset_right");
                if v158("yaw_modifier") == "Proggresive" then
                    v101.data["Yaw Modifier"] = "Center";
                    v101.data["Modifier Offset"] = v158("yaw_modifier_offset") == 0 and 0 or globals.curtime * 20 % math.abs(v158("yaw_modifier_offset"));
                else
                    v101.data["Yaw Modifier"] = v158("yaw_modifier");
                    v101.data["Modifier Offset"] = v158("yaw_modifier_offset");
                end;
                v101.data["Left Limit"] = v158("left_limit") - math.abs(v101.round_body_random);
                v101.data["Right Limit"] = v158("right_limit") - math.abs(v101.round_body_random);
                v101.data["Fake Options"] = v158("fake_options");
                v101.data.Hidden = v158("hidden_lc");
                if v158("hidden_lc") then
                    local v160 = v101.hidden_lc.pitch[v158("hidden_lc", nil, "pitch")];
                    if v160 == 1337 then
                        v160 = math.random(-89, 89);
                    elseif v160 == 2006 then
                        v160 = -89 + math.random(10, 33);
                    elseif v160 == 2004 then
                        v160 = v101.main.switch_choke and 0 or -89;
                    elseif v160 == 228 then
                        v160 = v158("hidden_lc", nil, "pitch_slider");
                    elseif v160 == 8 then
                        v160 = v101.main.switch_choke and 0 or 89;
                    end;
                    rage.antiaim:override_hidden_pitch(math.floor(v160));
                    local v161 = v158("hidden_lc", nil, "type");
                    if v161 ~= "Neverlose" then
                        if v161 == "Disabled" then
                            rage.antiaim:override_hidden_yaw_offset(0);
                        elseif v161 == "Meta" then
                            rage.antiaim:override_hidden_yaw_offset(globals.tickcount % 3 >= 2 and math.random(-180, -99) or math.random(99, 180));
                        elseif v161 == "Switch" then
                            rage.antiaim:override_hidden_yaw_offset(v153 and math.random(0, 168) or math.random(-168, -31));
                        elseif v161 == "Free Sway" then
                            rage.antiaim:override_hidden_yaw_offset(v153 and math.random(0, 168) or math.random(-168, -31));
                        elseif v161 == "Spin" then
                            rage.antiaim:override_hidden_yaw_offset(globals.tickcount * (v158("hidden_lc", nil, "sensitivity") * 2) % 360);
                        elseif v161 == "Forward" then
                            rage.antiaim:override_hidden_yaw_offset(math.random(-180, -145));
                        elseif v161 == "Switch Left" then
                            rage.antiaim:override_hidden_yaw_offset(v101.main.switch_choke and 90 or 0);
                        elseif v161 == "Switch Right" then
                            rage.antiaim:override_hidden_yaw_offset(v101.main.switch_choke and 0 or 90);
                        elseif v161 == "Custom" then
                            rage.antiaim:override_hidden_yaw_offset(v153 and v158("hidden_lc", nil, "yaw_slider_1") or v158("hidden_lc", nil, "yaw_slider_2"));
                        end;
                    end;
                end;
                if v159 > 0 then
                    local v162 = v158("fake_options");
                    table.remove(v162, table.find(v162, "Jitter"));
                    v101.data["Fake Options"] = v162;
                end;
            end;
            if v67["anti aim"].extensions:get("Adjust manual anti-aim") then
                if v67["anti aim"].yaw_base:get() ~= "Disabled" and v67["anti aim"].yaw_base:get() ~= "Freestanding" then
                    v101.data["Yaw Base"] = "Local View";
                    v101.data["Yaw Offset"] = 180;
                    v101.data["Fake Options"] = "";
                    v101.data["Yaw Modifier"] = "Disabled";
                    v101.data.Hidden = false;
                    v101.data.Inverter = false;
                    if v67["anti aim"].yaw_base:get() == "Left" then
                        v101.data["Yaw Offset"] = -90;
                    elseif v67["anti aim"].yaw_base:get() == "Right" then
                        v101.data["Yaw Offset"] = 90;
                    elseif v67["anti aim"].yaw_base:get() == "Forward" then
                        v101.data["Yaw Offset"] = 180;
                    end;
                end;
                if v67["anti aim"].yaw_base:get() ~= "Disabled" then
                    v101.data.Hidden = false;
                end;
                v53["Freestanding NL"]:override(v67["anti aim"].yaw_base:get() == "Freestanding");
                ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"):override(true);
                ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"):override(true);
            end;
            if v101.main.legit_aa or v101.is_in_bombsite and common.is_button_down(69) then
                v53["Freestanding NL"]:override(false);
                v101.data.Pitch = "Disabled";
                v101.data["Yaw Offset"] = 180;
                v101.data.Hidden = false;
            end;
            smart_override(v8.enabled, ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"), true, false);
            smart_override(v8.enabled, v53.Pitch, v101.data.Pitch, "Disabled");
            smart_override(v8.enabled, v53.Yaw, v101.data.Yaw, "Disabled");
            smart_override(v8.enabled, v53["Yaw Base"], v101.data["Yaw Base"], "Local View");
            smart_override(v8.enabled, v53["Yaw Offset"], v101.data["Yaw Offset"], 0);
            smart_override(v8.enabled, v53["Yaw Modifier"], v101.data["Yaw Modifier"], "Disabled");
            smart_override(v8.enabled, v53["Modifier Offset"], v101.data["Modifier Offset"], 0);
            smart_override(v8.enabled, v53["Body Yaw"], v101.data["Body Yaw"], false);
            smart_override(v8.enabled, v53["Left Limit"], v101.data["Left Limit"], 0);
            smart_override(v8.enabled, v53["Right Limit"], v101.data["Right Limit"], 0);
            smart_override(v8.enabled, v53.Inverter, v101.data.Inverter, false);
            smart_override(v8.enabled, v53["Fake Options"], v101.data["Fake Options"], {});
            smart_override(v8.enabled, v53.Freestanding, v101.data.Freestanding, "Off");
            smart_override(v8.enabled, v53.Hidden, v101.data.Hidden, false);
        end;
        v100.drop_grenades();
        return;
    end;
end;
v8.enabled = true;
ui.find("Aimbot", "Anti Aim", "Angles"):disabled(true);
v40("console_input", "switch_anti_aim", function(v163)
    -- upvalues: v8 (ref)
    if v163:lower() == "!aa" then
        if v8.enabled == 1 then
            ui.find("Aimbot", "Anti Aim", "Angles"):disabled(true);
            v8.enabled = true;
        else
            ui.find("Aimbot", "Anti Aim", "Angles"):disabled(false);
            v8.enabled = 1;
        end;
    end;
end);
local v164 = {};
v164 = {
    dragging = false, 
    cvars = {
        sv_maxusrcmdprocessticks = cvar.sv_maxusrcmdprocessticks:int()
    }, 
    colors = {
        first = color(20, 20, 20, 255), 
        second = color(100, 100, 100, 255), 
        third = color(40, 40, 40, 255), 
        two_first = color(20, 20, 20, 255)
    }, 
    fonts = {
        [16] = render.load_font("Verdana", 16, "abo")
    }
};
v164.numbers = {
    charge = 1, 
    desync = 60, 
    velocity = 100, 
    sv_maxusrcmdprocessticks = v164.cvars.sv_maxusrcmdprocessticks - 2
};
v164.spectators = {
    list = {}, 
    executer = function(v165)
        -- upvalues: v164 (ref)
        if not v165 then
            v164.spectators.list = {};
            return v164.spectators.list;
        else
            local v166 = {};
            if v165:is_alive() then
                v166 = v165:get_spectators();
            else
                local l_m_hObserverTarget_0 = v165.m_hObserverTarget;
                if not l_m_hObserverTarget_0 then
                    v164.spectators.list = {};
                    return v164.spectators.list;
                else
                    v166 = l_m_hObserverTarget_0:get_spectators();
                end;
            end;
            if v166 == {} then
                v164.spectators.list = {};
            end;
            for v168 = 1, 64 do
                v164.spectators.list[v168] = {
                    active = false, 
                    index = v168
                };
            end;
            if v166 ~= nil then
                for _, v170 in pairs(v166) do
                    local v171 = v170:get_index();
                    do
                        local l_v170_0 = v170;
                        v164.spectators.list[v171] = {
                            index = v171, 
                            active = (function()
                                -- upvalues: l_v170_0 (ref), v165 (ref)
                                if l_v170_0 == v165 then
                                    return false;
                                else
                                    return true;
                                end;
                            end)()
                        };
                    end;
                end;
            end;
            return v164.spectators.list;
        end;
    end
};
v164.draw_style = function(v173, v174, v175, v176, v177, v178)
    -- upvalues: v67 (ref), v164 (ref), l_smooth_0 (ref)
    local v179 = v67.settings.widgets[0].accent:get() == "Menu Style" and ui.get_style("Block Background") or v67.settings.widgets[0].color:get();
    local v180 = vector(v179.r, v179.g):dist(vector(255, 255)) + vector(v179.b, v179.a):dist(vector(255, 255)) < 500;
    if v67.settings.widgets[0].accent:get() == "Custom" then
        v180 = false;
    end;
    local v181 = {
        first = v180 and color(200, 200, 200, 255) or v179 * 2, 
        second = v180 and color(175, 175, 175, 255) or v179 * 5, 
        third = v180 and color(150, 150, 150, 255) or v179 * 3
    };
    v164.colors.first = l_smooth_0.lerp(v164.colors.first, v181.first, 6);
    v164.colors.second = l_smooth_0.lerp(v164.colors.second, v181.second, 6);
    v164.colors.third = l_smooth_0.lerp(v164.colors.third, v181.third, 6);
    v164.colors.two_first = l_smooth_0.lerp(v164.colors.two_first, v181.first, 6);
    v164.colors.first.a = 255 * v178;
    v164.colors.second.a = 255 * v178;
    v164.colors.third.a = 255 * v178;
    render.rect_outline(vector(v174 - 1, v175 - 1), vector(v174 + v176 + 1, v175 + v177 + 1), v164.colors.first);
    render.rect_outline(vector(v174 + 1, v175 + 1), vector(v174 + v176 - 1, v175 + v177 - 1), v164.colors.second, 3);
    render.rect(vector(v174 + 2, v175 + 2), vector(v174 + v176 - 2, v175 + v177 - 2), v164.colors.third);
    if v173 ~= nil then
        render.push_clip_rect(vector(v174 + 2, v175 + 2), vector(v174 + v176 - 2, v175 + v177 - 2));
        render.text(1, vector(v174 + v176 * 0.5 + 1, v175 + v177 * 0.5), color(222, 222, 222, 255 * v178), "c", v173);
        render.pop_clip_rect();
    end;
end;
v164.stapled = function(v182, v183, v184, v185, v186)
    -- upvalues: l_smooth_0 (ref), v164 (ref), v8 (ref)
    if v186 ~= "Watermark" then
        return "";
    else
        local v187 = "None";
        local v188 = l_smooth_0.linear("CHERNOBYL", ("%s.Stapled Alpha"):format(v186), v164.dragging);
        if v188 < 0.1 then
            return "";
        else
            local v189 = {
                [1] = {
                    [1] = 5, 
                    [2] = 5, 
                    [3] = nil, 
                    [4] = nil, 
                    [5] = "T-L", 
                    [3] = v184 + 5, 
                    [4] = v185 + 5
                }, 
                [2] = {
                    [1] = nil, 
                    [2] = 5, 
                    [3] = nil, 
                    [4] = nil, 
                    [5] = "T-R", 
                    [1] = v8.screen.x - v184 - 5, 
                    [3] = v184, 
                    [4] = v185 + 5
                }, 
                [3] = {
                    [1] = nil, 
                    [2] = nil, 
                    [3] = nil, 
                    [4] = nil, 
                    [5] = "B-C", 
                    [1] = v8.screen.x * 0.5 - v184 * 0.5, 
                    [2] = v8.screen.y - v185 - 10, 
                    [3] = v184, 
                    [4] = v185 + 5
                }
            };
            for v190 = 1, #v189 do
                local v191 = v189[v190];
                local v192, v193, v194, v195, v196 = unpack(v191);
                local v197 = l_smooth_0.linear("CHERNOBYL", ("%s.%s"):format(v186, v196), v8.mouse:dist(vector(v192 + v194 * 0.5, v193 + v195 * 0.5)) < v8.screen.x * 0.33);
                render.rect(vector(v192, v193), vector(v192 + v194, v193 + v195), color(96, 96, 96, 150 * v188 * v197));
                render.text(1, vector(v192 + v194 * 0.5, v193 + v195 * 0.5), color(222, 222, 222, 200 * v188 * v197), "c", "DRAG THE WIDGET HERE TO ATTACH");
                local v198 = false;
                if v192 <= v182 and v182 <= v192 + v194 and v193 <= v183 and v183 <= v193 + v195 or v192 <= v182 + v184 and v182 + v184 <= v192 + v194 and v193 <= v183 + v185 and v183 + v185 <= v193 + v195 or v192 <= v182 + v184 and v182 + v184 <= v192 + v194 and v193 <= v183 and v183 <= v193 + v195 or v192 <= v182 and v182 <= v192 + v194 and v193 <= v183 + v185 and v183 + v185 <= v193 + v195 then
                    v198 = true;
                end;
                if v197 > 0.1 and v198 then
                    v187 = v196;
                end;
            end;
            return v187;
        end;
    end;
end;
v164.list = {
    l_system_0.register(v67.settings.widgets[0].x_watermark, v67.settings.widgets[0].y_watermark, 100, 20, function(v199)
        -- upvalues: v8 (ref), v164 (ref), l_smooth_0 (ref), v67 (ref)
        local l_x_0 = v199.position.x;
        local l_y_0 = v199.position.y;
        local l_x_1 = v199.size.x;
        local l_y_1 = v199.size.y;
        v199.name = "Watermark";
        v199.name_menu = "Watermark";
        local v204 = 0;
        local v205 = utils.net_channel();
        if v205 ~= nil then
            local v206 = v205.latency[1];
            v204 = string.format("%1.f", math.max(0, v206) * 1000);
        end;
        v205 = ("chernobyl.lua ~ %s \aCDAF8BFF|\aDEFAULT %s \aCDAF8BFF|\aDEFAULT %s ~ %s \aCDAF8BFF|\aDEFAULT %sms"):format(v8.build, v8.username, common.get_date("%H:%M"), common.get_date("%A"), v204);
        v164.draw_style(v205, l_x_0, l_y_0, l_x_1, l_y_1, v199.alpha);
        v199.size.x = l_smooth_0.lerp(v199.size.x, render.measure_text(1, nil, v205).x + 12, 7.5);
        if v67.settings.widgets[0].stapled_watermark:get() == "T-R" then
            v67.settings.widgets[0].x_watermark:set(v8.screen.x - v199.size.x - 5);
            v67.settings.widgets[0].y_watermark:set(5);
        elseif v67.settings.widgets[0].stapled_watermark:get() == "T-L" then
            v67.settings.widgets[0].x_watermark:set(5);
            v67.settings.widgets[0].y_watermark:set(5);
        elseif v67.settings.widgets[0].stapled_watermark:get() == "B-C" then
            v67.settings.widgets[0].x_watermark:set(v8.screen.x * 0.5 - v199.size.x * 0.5);
            v67.settings.widgets[0].y_watermark:set(v8.screen.y - v199.size.y - 5);
        end;
    end, 5), 
    l_system_0.register(v67.settings.widgets[0].x_keybinds, v67.settings.widgets[0].y_keybinds, 100, 20, function(v207)
        -- upvalues: v164 (ref), l_smooth_0 (ref), v67 (ref)
        local l_x_2 = v207.position.x;
        local l_y_2 = v207.position.y;
        local l_x_3 = v207.size.x;
        local v211 = 20;
        v207.name = "Keybinds";
        v207.name_menu = "Keybinds";
        v164.draw_style("keybinds", l_x_2, l_y_2, l_x_3, v211, (v207.global_alpha or 1) * v207.alpha);
        v207.length = 95;
        local v212 = {
            offset = 2, 
            list = ui.get_binds()
        };
        v212.executer = function()
            -- upvalues: v212 (ref), l_smooth_0 (ref), l_x_2 (ref), l_y_2 (ref), l_x_3 (ref), v211 (ref), v164 (ref), v67 (ref), v207 (ref)
            for v213 = #v212.list, 1, -1 do
                local v214 = v212.list[v213];
                local v215 = l_smooth_0.linear("CHERNOBYL", ("Bind.%s.Alpha"):format(v214.reference:name()), v214.active);
                local v216 = ("%s"):format(v214.mode == 1 and ui.get_icon("circle-dot") or ui.get_icon("toggle-on"));
                if type(v214.value) == "number" then
                    v216 = ("%s"):format(v214.value);
                end;
                render.rect(vector(l_x_2, l_y_2 + v212.offset + 20), vector(l_x_2 + l_x_3, l_y_2 + v211 + v212.offset + 15), v164.colors.third * color(255, 255, 255, v67.settings.widgets[0].alphas:get() * v207.alpha * v215));
                render.text(1, vector(l_x_2 + 2, l_y_2 + v211 + v212.offset + 1), color(255, 255, 255, 255 * v207.alpha * v215), nil, v214.name);
                render.text(1, vector(l_x_2 + l_x_3 - 2, l_y_2 + v211 + v212.offset + 1), color(255, 255, 255, 255 * v207.alpha * v215), "r", v216);
                v212.offset = v212.offset + 16 * v215;
                local v217 = render.measure_text(1, nil, v214.name).x + render.measure_text(1, nil, v216).x + 20;
                if v207.length <= v217 then
                    v207.length = v217;
                end;
            end;
            v207.size.y = v212.offset + 22;
        end;
        v212.executer();
        v207.size.x = l_smooth_0.unclamped_lerp(v207.size.x, v207.length, 15);
        v207.global_alpha = l_smooth_0.linear("CHERNOBYL", ("%s.%s"):format(v207.name, "Alpha"), v212.offset > 2 or ui.get_alpha() > 0);
    end, 5), 
    l_system_0.register(v67.settings.widgets[0].x_spectators, v67.settings.widgets[0].y_spectators, 100, 20, function(v218)
        -- upvalues: v164 (ref), l_smooth_0 (ref), v67 (ref)
        local v219 = entity.get_local_player();
        local l_x_4 = v218.position.x;
        local l_y_3 = v218.position.y;
        local l_x_5 = v218.size.x;
        local v223 = 20;
        v218.name = "Spectators";
        v218.name_menu = "Spectators";
        v164.draw_style("spectators", l_x_4, l_y_3, l_x_5, v223, (v218.global_alpha or 1) * v218.alpha);
        v218.length = 95;
        local v224 = {
            offset = 2, 
            list = v164.spectators.executer(v219)
        };
        v224.executer = function()
            -- upvalues: v224 (ref), l_smooth_0 (ref), l_x_4 (ref), l_y_3 (ref), l_x_5 (ref), v223 (ref), v164 (ref), v67 (ref), v218 (ref)
            for v225 = #v224.list, 1, -1 do
                local v226 = v224.list[v225];
                local v227 = entity.get(v226.index);
                if v227 then
                    local v228 = string.sub(v227:get_name(), 1, 32);
                    local v229 = ui.get_icon("eye");
                    local v230 = l_smooth_0.linear("CHERNOBYL", ("Player.%s.Alpha"):format(v228), v226.active);
                    render.rect(vector(l_x_4, l_y_3 + v224.offset + 20), vector(l_x_4 + l_x_5, l_y_3 + v223 + v224.offset + 15), v164.colors.third * color(255, 255, 255, v67.settings.widgets[0].alphas:get() * v218.alpha * v230));
                    render.push_clip_rect(vector(l_x_4, l_y_3 + v224.offset + 20), vector(l_x_4 + l_x_5 - 15, l_y_3 + v223 + v224.offset + 15));
                    render.text(1, vector(l_x_4 + 2, l_y_3 + v223 + v224.offset + 1), color(255, 255, 255, 255 * v218.alpha * v230), nil, v228);
                    render.pop_clip_rect();
                    render.text(1, vector(l_x_4 + l_x_5 - 2, l_y_3 + v223 + v224.offset + 1), color(255, 255, 255, 255 * v218.alpha * v230), "r", v229);
                    v224.offset = v224.offset + 16 * v230;
                    local v231 = (render.measure_text(1, nil, v228).x + render.measure_text(1, nil, v229).x + 15) * v230;
                    if v218.length <= v231 then
                        v218.length = v231;
                    end;
                end;
            end;
            v218.size.y = v224.offset + 22;
        end;
        v224.executer();
        v218.size.x = l_smooth_0.unclamped_lerp(v218.size.x, v218.length, 15);
        v218.global_alpha = l_smooth_0.linear("CHERNOBYL", ("%s.%s"):format(v218.name, "Alpha"), v224.offset > 2 or ui.get_alpha() > 0);
    end, 5), 
    l_system_0.register(v67.settings.widgets[0].x_debug_box, v67.settings.widgets[0].y_debug_box, 125, 85, function(v232)
        -- upvalues: v164 (ref), l_smooth_0 (ref)
        local l_x_6 = v232.position.x;
        local l_y_4 = v232.position.y;
        local l_x_7 = v232.size.x;
        local l_y_5 = v232.size.y;
        v232.name = "Debug_Box";
        v232.name_menu = "Debug Box";
        v164.draw_style(nil, l_x_6, l_y_4, l_x_7, l_y_5, v232.alpha);
        render.rect(vector(l_x_6 + 3, l_y_4 + 18), vector(l_x_6 + l_x_7 - 3, l_y_4 + 20), v164.colors.second * color(255, 255, 255, 255 * v232.alpha));
        render.text(1, vector(l_x_6 + l_x_7 * 0.5, l_y_4 + 10), color(255, 255, 255, 255 * v232.alpha), "c", "DEBUG BOX");
        render.text(1, vector(l_x_6 + 5, l_y_4 + 25), color(255, 255, 255, 255 * v232.alpha), nil, "DESYNC");
        render.rect_outline(vector(l_x_6 + 50, l_y_4 + 26), vector(l_x_6 + 50 + 68, l_y_4 + 26 + 11), v164.colors.first * color(255, 255, 255, 255 * v232.alpha), 4);
        v164.numbers.desync = l_smooth_0.lerp(v164.numbers.desync, tonumber(string.format("%.1f", math.min(math.abs(rage.antiaim:get_rotation() - rage.antiaim:get_rotation(true)) / 2, 60))), 8);
        v164.numbers.desync = math.clamp(v164.numbers.desync, 1, 100);
        render.rect(vector(l_x_6 + 50, l_y_4 + 26), vector(l_x_6 + 50 + 68.5 * (v164.numbers.desync / 60), l_y_4 + 26 + 11), v164.colors.second * color(255, 255, 255, 255 * v232.alpha));
        l_y_4 = l_y_4 + 20;
        render.text(1, vector(l_x_6 + 5, l_y_4 + 25), color(255, 255, 255, 255 * v232.alpha), nil, "CHARGE");
        render.rect_outline(vector(l_x_6 + 50, l_y_4 + 26), vector(l_x_6 + 50 + 68, l_y_4 + 26 + 11), v164.colors.first * color(255, 255, 255, 255 * v232.alpha), 4);
        v164.numbers.charge = l_smooth_0.lerp(v164.numbers.charge, rage.exploit:get(), 8);
        render.rect(vector(l_x_6 + 50, l_y_4 + 26), vector(l_x_6 + 50 + 68.5 * v164.numbers.charge, l_y_4 + 26 + 11), v164.colors.second * color(255, 255, 255, 255 * v232.alpha));
        l_y_4 = l_y_4 + 20;
        render.text(1, vector(l_x_6 + 5, l_y_4 + 25), color(255, 255, 255, 255 * v232.alpha), nil, "FL TICK");
        render.rect_outline(vector(l_x_6 + 50, l_y_4 + 26), vector(l_x_6 + 50 + 68, l_y_4 + 26 + 11), v164.colors.first * color(255, 255, 255, 255 * v232.alpha), 4);
        v164.numbers.sv_maxusrcmdprocessticks = l_smooth_0.lerp(v164.numbers.sv_maxusrcmdprocessticks, globals.choked_commands, 8);
        render.rect(vector(l_x_6 + 50, l_y_4 + 26), vector(l_x_6 + 50 + 68.5 * (v164.numbers.sv_maxusrcmdprocessticks / v164.cvars.sv_maxusrcmdprocessticks), l_y_4 + 26 + 11), v164.colors.second * color(255, 255, 255, 255 * v232.alpha));
    end, 5), 
    l_system_0.register(v67.settings.widgets[0].x_velocity_warning, v67.settings.widgets[0].y_velocity_warning, 175, 20, function(v237)
        -- upvalues: l_smooth_0 (ref), v67 (ref), v8 (ref), v164 (ref)
        local v238 = entity.get_local_player();
        local l_x_8 = v237.position.x;
        local l_y_6 = v237.position.y;
        local l_x_9 = v237.size.x;
        local l_y_7 = v237.size.y;
        local v243 = ui.get_mouse_position();
        local v244 = l_smooth_0.linear("CHERNOBYL", "VW.Mouse.Alpha", l_x_8 < v243.x and v243.x < l_x_8 + l_x_9 and l_y_6 < v243.y and v243.y < l_y_6 + l_y_7) * ui.get_alpha();
        if v244 > 0 then
            render.text(1, vector(l_x_8, l_y_6 + l_y_7), color(222, 222, 222, 255 * v244), nil, "Press RMB to center align");
            if common.is_button_down(2) then
                v67.settings.widgets[0].x_velocity_warning:set(v8.screen.x * 0.5 - v237.size.x * 0.5 - 0.5);
                v237.position.x = v8.screen.x * 0.5 - v237.size.x * 0.5 - 0.5;
            end;
        end;
        v237.name = "Velocity_Warning";
        v237.name_menu = "Velocity Warning";
        local v245 = l_smooth_0.linear("CHERNOBYL_SLOW", "Rounds VW", globals.tickcount % 300 >= 150);
        local v246 = not v238 and (ui.get_alpha() >= 0.5 and v245 or v245) or v238:is_alive() and v238.m_flVelocityModifier or 1;
        local v247 = l_smooth_0.linear("CHERNOBYL", ("%s.%s"):format(v237.name, "Alpha"), v238 and (not (v246 >= 1) or not (ui.get_alpha() <= 0)) or ui.get_alpha() > 0);
        v164.draw_style(nil, l_x_8, l_y_6 + 10, l_x_9, 10, v247 * v237.alpha);
        render.text(1, vector(l_x_8 + l_x_9 * 0.5, l_y_6 + 2.5), color(255, 255 * v237.alpha * v247), "c", ("max speed decreased by %s%%"):format(("%.0f"):format(math.abs(-(v246 * 100 - 100)))));
        render.rect(vector(l_x_8 + 4, l_y_6 + 14), vector(l_x_8 + l_x_9 * v246 - 4, l_y_6 + l_y_7 - 4), percentage_color(v246 * 100, true) * color(255, 255 * v237.alpha * v247));
    end, 5)
};
v164.executer = function()
    -- upvalues: v8 (ref), v164 (ref), l_smooth_0 (ref), v67 (ref), l_system_0 (ref)
    v8.mouse = ui.get_mouse_position();
    v164.dragging = false;
    for v248 = #v164.list, 1, -1 do
        local v249 = v164.list[v248];
        if v249.dragging.active then
            v164.dragging = true;
        end;
        v249.alpha = l_smooth_0.linear("CHERNOBYL", ("Alpha.%s"):format(v249.index), not v249.dragging.active, 0.8, 1);
        if not v67.settings.widgets:get() or not v67.settings.widgets[0].selected:get(v249.name_menu) then
            v249.enable = false;
            v249.global_alpha = 0;
        else
            v249.enable = true;
        end;
        for v250 = 1, #v164.list do
            local v251 = v164.list[v250];
            if v251 ~= v249 then
                l_smooth_0.auxiliary.animation.CHERNOBYL.table.active[("Alpha.%s"):format(v251.index)] = true;
            end;
        end;
        if v249.dragging.active then
            local v252 = v164.stapled(v249.position.x, v249.position.y, v249.size.x, v249.size.y, v249.name);
            if v249.name and v252 ~= "" and v67.settings.widgets[0][("stapled_%s"):format(string.lower(v249.name))] then
                v67.settings.widgets[0][("stapled_%s"):format(string.lower(v249.name))]:set(v252);
            end;
        end;
    end;
    l_system_0.set_priority();
end;
cvar.sv_maxusrcmdprocessticks:set_callback(function(v253)
    -- upvalues: v164 (ref)
    v164.cvars.sv_maxusrcmdprocessticks = v253:int();
end);
local v254 = {
    main = {
        tab = false
    }, 
    converter = {
        SW = "Slowwalking", 
        M = "Running", 
        S = "Standing", 
        C = "Crouching", 
        G = "Global", 
        AC = "Crouching Air", 
        A = "Jumping"
    }
};
v254.executer = function()
    -- upvalues: v254 (ref), l_smooth_0 (ref), v67 (ref), v19 (ref), v8 (ref), l_liberia_0 (ref), v53 (ref)
    local v255 = entity.get_local_player();
    if not v255 then
        v254.main.tab = false;
    end;
    local v256 = l_smooth_0.linear("CHERNOBYL", "Indicator enable", v67.settings.crosshair_indicators:get());
    local v257 = false;
    if v255 then
        local v258 = v255:get_player_weapon();
        if not v258 then
            return;
        else
            local v259 = v258:get_weapon_info();
            if not v259 then
                return;
            else
                v257 = v259.weapon_type == 9;
            end;
        end;
    end;
    local v260 = l_smooth_0.linear("CHERNOBYL", "Indicator grenade", not v255 or not v257 or false, 0.5, 1) * v256;
    local v261 = l_smooth_0.linear("CHERNOBYL", "Indicator tab", not v255 or not v254.main.tab or false, 0, 1) * v256;
    local v262 = l_smooth_0.linear("CHERNOBYL", "Indicator alpha", v255 and (v255:is_alive() or not (ui.get_alpha() <= 0)) or ui.get_alpha() > 0) * v256 * v260 * v261;
    local v263 = l_smooth_0.linear("CHERNOBYL", "Indicator scope", v255 and v255.m_bIsScoped or false);
    local v264 = {
        offset = 20, 
        name = v19.make(("CHERNOBYL%s"):format(v8.build == "stable" and ".LUA" or (" %s"):format(v8.build):upper()), 3, {
            [1] = color(255, 255, 255, 255), 
            [2] = v67.settings.crosshair_indicators[0].accent:get() == "Menu Style" and ui.get_style("Link Active") or v67.settings.crosshair_indicators[0].color:get()
        }), 
        condition = l_liberia_0.anti_aim.condition.get()
    };
    v264.condition = v254.converter[v264.condition]:upper();
    v264.size = {
        name = render.measure_text(2, nil, v264.name).x * 0.5 + 9, 
        condition = render.measure_text(2, nil, v264.condition).x * 0.5 + 9
    };
    render.text(2, vector(v8.screen.x * 0.5 + v264.size.name * v263, v8.screen.y * 0.5 + v264.offset), color(255, 255, 255, 255 * v262), "c", v264.name);
    if v67.settings.crosshair_indicators[0].display:get("Player State") then
        v264.offset = v264.offset + 8;
        render.text(2, vector(v8.screen.x * 0.5 + v264.size.condition * v263, v8.screen.y * 0.5 + v264.offset), color(255, 255, 255, 255 * v262), "c", v264.condition);
    end;
    local v265 = {
        offset = 8, 
        list = {
            [1] = {
                name = {
                    [1] = "Freestanding", 
                    [2] = "FREESTAND"
                }, 
                active = v53["Freestanding NL"]:get()
            }, 
            [2] = {
                name = {
                    [1] = "Double Tap", 
                    [2] = rage.exploit:get() > 0 and "\a00FF33FFRAPID" or "\aFF3300FFCHARGE"
                }, 
                active = v53["Double Tap"]:get()
            }, 
            [3] = {
                name = {
                    [1] = "Hide Shots", 
                    [2] = "HIDE"
                }, 
                active = v53["Hide Shots"]:get()
            }, 
            [4] = {
                name = {
                    [1] = "Body Aim", 
                    [2] = "BODY"
                }, 
                active = v53["Body Aim"]:get() == "Force"
            }, 
            [5] = {
                name = {
                    [1] = "Safe Points", 
                    [2] = "SAFE"
                }, 
                active = v53["Safe Points"]:get() == "Force"
            }, 
            [6] = {
                name = {
                    [1] = "Fake Duck", 
                    [2] = "DUCK"
                }, 
                active = v53["Fake Duck"]:get()
            }
        }
    };
    v265.executer = function()
        -- upvalues: v265 (ref), l_smooth_0 (ref), v67 (ref), v8 (ref), v263 (ref), v264 (ref), v262 (ref)
        for v266 = 1, #v265.list do
            local v267 = v265.list[v266];
            local v268 = l_smooth_0.linear("CHERNOBYL", ("Indicator bind %s"):format(v267.name[1]), v267.active and v67.settings.crosshair_indicators[0].display:get(v267.name[1]));
            local v269 = render.measure_text(2, nil, v267.name[2]).x * 0.5 + 9;
            render.text(2, vector(v8.screen.x * 0.5 + v269 * v263, v8.screen.y * 0.5 + v264.offset + v265.offset), color(255, 255, 255, 255 * v268 * v262), "c", v267.name[2]);
            v265.offset = v265.offset + 8 * v268;
        end;
    end;
    v265.executer();
end;
local v270 = {
    main = {
        inaccuracy = 0
    }
};
v270.executer = function()
    -- upvalues: v67 (ref), v270 (ref), l_smooth_0 (ref), v254 (ref), v8 (ref)
    local v271 = entity.get_local_player();
    if not v271 or not v271:is_alive() or not v67.settings.custom_scope:get() then
        return;
    else
        local v272 = v271:get_player_weapon();
        if not v272 then
            return;
        else
            if v67.settings.custom_scope[0].spread:get() then
                v270.main.inaccuracy = l_smooth_0.unclamped_lerp(v270.main.inaccuracy, v272:get_inaccuracy() * 100, 5);
            else
                v270.main.inaccuracy = 0;
            end;
            local v273 = {
                alpha = 0, 
                color_o = v67.settings.custom_scope[0].color:get() * color(255, 255, 255, 0), 
                color_t = v67.settings.custom_scope[0].color:get(), 
                initial = v67.settings.custom_scope[0].initial:get(), 
                offset = v67.settings.custom_scope[0].offset:get() + v270.main.inaccuracy, 
                style = v67.settings.custom_scope[0].style:get(), 
                alpha = l_smooth_0.linear("CHERNOBYL", "Custom scope alpha", v271.m_bIsScoped and not v254.main.tab)
            };
            v273.color_t.a = 255 * v273.alpha;
            local v274 = {
                x = v8.screen.x * 0.5, 
                y = v8.screen.y * 0.5
            };
            if v273.style == "Default" then
                render.gradient(vector(v274.x, v274.y - v273.initial), vector(v274.x + 1, v274.y - v273.offset + 1), v273.color_o, v273.color_o, v273.color_t, v273.color_t);
            end;
            render.gradient(vector(v274.x, v274.y + v273.initial + 1), vector(v274.x + 1, v274.y + v273.offset), v273.color_o, v273.color_o, v273.color_t, v273.color_t);
            render.gradient(vector(v274.x - v273.offset + 1, v274.y), vector(v274.x - v273.initial, v274.y + 1), v273.color_t, v273.color_o, v273.color_t, v273.color_o);
            render.gradient(vector(v274.x + v273.initial + 1, v274.y), vector(v274.x + v273.offset, v274.y + 1), v273.color_o, v273.color_t, v273.color_o, v273.color_t);
            return;
        end;
    end;
end;
local v275 = {
    main = {
        list = {}, 
        hit_groups = {
            [0] = "generic", 
            [1] = "head", 
            [2] = "chest", 
            [3] = "stomach", 
            [4] = "left arm", 
            [5] = "right arm", 
            [6] = "left leg", 
            [7] = "right leg", 
            [8] = "neck", 
            [9] = "generic", 
            [10] = "gear"
        }
    }
};
v275.window = l_system_0.register(v67.settings.ragebot_logs[0].x, v67.settings.ragebot_logs[0].y, 600, 120, function(v276)
    -- upvalues: l_smooth_0 (ref), v67 (ref), v8 (ref), v275 (ref)
    local l_x_10 = v276.position.x;
    local l_y_8 = v276.position.y;
    local l_x_11 = v276.size.x;
    local l_y_9 = v276.size.y;
    v276.name = "Aimbot_logs";
    v276.name_menu = "Aimbot_logs";
    local v281 = ui.get_mouse_position();
    local v282 = l_smooth_0.linear("CHERNOBYL", "RBL.Mouse.Alpha", l_x_10 < v281.x and v281.x < l_x_10 + l_x_11 and l_y_8 < v281.y and v281.y < l_y_8 + l_y_9) * ui.get_alpha();
    if v282 > 0 then
        render.text(1, vector(l_x_10, l_y_8 + l_y_9), color(222, 222, 222, 255 * v282), nil, "Press RMB to center align");
        if common.is_button_down(2) then
            v67.settings.ragebot_logs[0].x:set(v8.screen.x * 0.5 - v276.size.x * 0.5 - 0.5);
            v276.position.x = v8.screen.x * 0.5 - v276.size.x * 0.5 - 0.5;
        end;
    end;
    render.rect(vector(l_x_10, l_y_8), vector(l_x_10 + l_x_11, l_y_8 + l_y_9), color(96, 96, 96, 32 * ui.get_alpha()));
    local v283 = {
        offset = l_y_8 + l_y_9 * 0.5 <= v8.screen.y * 0.5 and 10 or l_y_9 - 10
    };
    for v284 = 1, #v275.main.list do
        local v285 = v275.main.list[v284];
        if globals.realtime - v285.timeout < 5 and (#v275.main.list <= 8 or v284 >= #v275.main.list - 8) then
            v285.offset = l_smooth_0.unclamped_lerp(v285.offset, 100, 10);
        else
            v285.offset = l_smooth_0.unclamped_lerp(v285.offset, 0, 10);
        end;
        if v285.offset < 1 then
            v285.delete = true;
        end;
        local v286 = v285.offset / 100;
        local v287 = "up";
        if l_y_8 + l_y_9 * 0.5 <= v8.screen.y * 0.5 then
            v283.offset = v283.offset + 12 * v286;
            v287 = "up";
        else
            v283.offset = v283.offset - 12 * v286;
            v287 = "down";
        end;
        if l_x_10 <= v8.screen.x * 0.25 then
            render.text(1, vector(l_x_10 + 5, l_y_8 - 6.5 + v283.offset + (v287 == "up" and -12 * v286 or 12 * v286)), color(255, 255, 255, 255 * v286), nil, v285.text);
        elseif l_x_10 + l_x_11 >= v8.screen.x * 0.75 then
            render.text(1, vector(l_x_10 + l_x_11 - render.measure_text(1, nil, v285.text).x - 5, l_y_8 - 6.5 + v283.offset + (v287 == "up" and -12 * v286 or 12 * v286)), color(255, 255, 255, 255 * v286), nil, v285.text);
        else
            render.text(1, vector(l_x_10 + l_x_11 * 0.5, l_y_8 + v283.offset + (v287 == "up" and -12 * v286 or 12 * v286)), color(255, 255, 255, 255 * v286), "c", v285.text);
        end;
    end;
    for v288 = 1, #v275.main.list do
        local v289 = v275.main.list[v288];
        if not v289 or v289.delete then
            table.remove(v275.main.list, v288);
        end;
    end;
end);
v275.executer = function()
    -- upvalues: v275 (ref), v67 (ref)
    v275.window.enable = v67.settings.ragebot_logs:get() and v67.settings.ragebot_logs[0].display:get("On Screen");
end;
v275.aim_ack = function(v290)
    -- upvalues: v67 (ref), v275 (ref)
    if not v67.settings.ragebot_logs:get() then
        return;
    else
        local function v295(v291)
            -- upvalues: v275 (ref)
            local v292 = "";
            for _, v294 in pairs(v291) do
                v292 = v292 .. ("\a%02x%02x%02x%02x%s"):format(v294[1].r, v294[1].g, v294[1].b, v294[1].a, v294[2]);
            end;
            table.insert(v275.main.list, {
                offset = 1, 
                delete = false, 
                text = v292, 
                timeout = globals.realtime
            });
            v292 = string.gsub(v292, "\a%x%x%x%x%x%x%x%x", "");
        end;
        local function v300()
            -- upvalues: v290 (ref), v275 (ref)
            local v296 = "";
            local v297 = v290.hitgroup ~= v290.wanted_hitgroup;
            local v298 = v290.damage ~= v290.wanted_damage;
            if v297 or v298 then
                v296 = string.format(" | mismatch: %s", (function()
                    -- upvalues: v298 (ref), v290 (ref), v297 (ref), v275 (ref)
                    local v299 = "";
                    if v298 then
                        v299 = v290.wanted_damage;
                    end;
                    if v297 then
                        v299 = v299 .. (v297 and " in " .. v275.main.hit_groups[v290.wanted_hitgroup] or "");
                    end;
                    return v299;
                end)());
            end;
            return v296;
        end;
        local l_target_0 = v290.target;
        local v302 = {
            hit = color(128, 255, 128, 255), 
            miss = color(255, 128, 128, 255)
        };
        if not v290.state then
            if v67.settings.ragebot_logs[0].display:get("On Screen") then
                v295({
                    [1] = {
                        [1] = nil, 
                        [2] = "Hit ", 
                        [1] = color(255, 255, 255, 200)
                    }, 
                    [2] = {
                        v302.hit, 
                        l_target_0:get_name()
                    }, 
                    [3] = {
                        [1] = nil, 
                        [2] = "'s in the ", 
                        [1] = color(255, 255, 255, 200)
                    }, 
                    [4] = {
                        [1] = v302.hit, 
                        [2] = v275.main.hit_groups[v290.hitgroup]
                    }, 
                    [5] = {
                        [1] = nil, 
                        [2] = " for ", 
                        [1] = color(255, 255, 255, 200)
                    }, 
                    [6] = {
                        [1] = v302.hit, 
                        [2] = v290.damage
                    }, 
                    [7] = {
                        [1] = nil, 
                        [2] = " damage (", 
                        [1] = color(255, 255, 255, 200)
                    }, 
                    [8] = {
                        v302.hit, 
                        math.max(0, l_target_0.m_iHealth)
                    }, 
                    [9] = {
                        [1] = nil, 
                        [2] = " health remaining)", 
                        [1] = color(255, 255, 255, 200)
                    }
                });
            end;
            if v67.settings.ragebot_logs[0].display:get("Console") then
                print(("Hit %s's in the %s for %s damage (%s health remaining) [backtrack: %s%s]"):format(l_target_0:get_name(), v275.main.hit_groups[v290.hitgroup], v290.damage, math.max(0, l_target_0.m_iHealth), v290.backtrack, v300()));
            end;
        else
            v290.state = v290.state == "correction" and "resolver" or v290.state;
            if v67.settings.ragebot_logs[0].display:get("On Screen") then
                v295({
                    [1] = {
                        [1] = nil, 
                        [2] = "Missed ", 
                        [1] = color(255, 255, 255, 200)
                    }, 
                    [2] = {
                        v302.miss, 
                        l_target_0:get_name()
                    }, 
                    [3] = {
                        [1] = nil, 
                        [2] = "'s in ", 
                        [1] = color(255, 255, 255, 200)
                    }, 
                    [4] = {
                        [1] = v302.miss, 
                        [2] = v275.main.hit_groups[v290.wanted_hitgroup]
                    }, 
                    [5] = {
                        [1] = nil, 
                        [2] = " due to ", 
                        [1] = color(255, 255, 255, 200)
                    }, 
                    [6] = {
                        [1] = v302.miss, 
                        [2] = v290.state
                    }
                });
            end;
            if v67.settings.ragebot_logs[0].display:get("Console") then
                print(("Missed %s's in %s due to %s [backtrack: %s%s]"):format(l_target_0:get_name(), v275.main.hit_groups[v290.wanted_hitgroup], v290.state, v290.backtrack, v300()));
            end;
        end;
        return;
    end;
end;
local v310 = {
    grenade = {
        lerp = function(v303, v304, v305)
            return vector((v304.x - v303.x) * v305 + v303.x, (v304.y - v303.y) * v305 + v303.y, (v304.z - v303.z) * v305 + v303.z);
        end, 
        find = function(v306, v307)
            local v308 = 0;
            for v309 = 1, #v306 do
                if v306[v309].Name == v307 then
                    v308 = v309;
                end;
            end;
            return v308;
        end, 
        list = {}
    }
};
v310.grenade_radius_func = function()
    -- upvalues: v67 (ref), v310 (ref), l_smooth_0 (ref)
    local v311 = entity.get_local_player();
    if v311 == nil or not v67.settings.grenade_radius:get() then
        return;
    else
        local v312 = v311:get_origin();
        if v67.settings.grenade_radius[0].display:get("Smoke") then
            local v313 = entity.get_entities("CSmokeGrenadeProjectile");
            for v314 = 1, #v313 do
                local v315 = v313[v314];
                local v316 = v315:get_origin();
                if v315.m_bDidSmokeEffect then
                    local v317 = "Smoke " .. v316.x .. v316.y .. v316.z;
                    if v310.grenade.find(v310.grenade.list, v317) == 0 then
                        table.insert(v310.grenade.list, {
                            Alpha = 255, 
                            Radius = 0, 
                            Type = "Smoke", 
                            Name = v317, 
                            Time = globals.curtime
                        });
                    end;
                    local v318 = v310.grenade.list[v310.grenade.find(v310.grenade.list, v317)];
                    if globals.curtime - v318.Time > 17.75 then
                        v318.Alpha = l_smooth_0.unclamped_lerp(v318.Alpha, 0, 10);
                    end;
                    if v312:dist(v316) < 1250 then
                        v318.Alpha = l_smooth_0.unclamped_lerp(v318.Alpha, 255, 10);
                    else
                        v318.Alpha = l_smooth_0.unclamped_lerp(v318.Alpha, 0, 10);
                    end;
                    v318.Radius = l_smooth_0.unclamped_lerp(v318.Radius, 100, 10);
                    render.circle_3d_outline(v315:get_origin(), v67.settings.grenade_radius[0].smoke:get() * color(255, 255, 255, 255 * (v318.Alpha / 255)), 127 * (v318.Radius / 100), 0, 1);
                end;
            end;
        end;
        if v67.settings.grenade_radius[0].display:get("Molotov") then
            local v319 = entity.get_entities("CInferno");
            for v320 = 1, #v319 do
                local v321 = v319[v320];
                local v322 = v321:get_origin();
                local v323 = "Molotov " .. v322.x .. v322.y .. v322.z;
                if v310.grenade.find(v310.grenade.list, v323) == 0 then
                    table.insert(v310.grenade.list, {
                        Alpha = 255, 
                        Radius = 0, 
                        Type = "Molotov", 
                        Name = v323, 
                        Time = globals.curtime
                    });
                end;
                local v324 = v310.grenade.list[v310.grenade.find(v310.grenade.list, v323)];
                if globals.curtime - v324.Time > 6.75 then
                    v324.Alpha = l_smooth_0.unclamped_lerp(v324.Alpha, 0, 10);
                end;
                if v312:dist(v322) < 1250 then
                    v324.Alpha = l_smooth_0.unclamped_lerp(v324.Alpha, 255, 10);
                else
                    v324.Alpha = l_smooth_0.unclamped_lerp(v324.Alpha, 0, 10);
                end;
                v324.Radius = l_smooth_0.unclamped_lerp(v324.Radius, 100, 10);
                local v325 = {
                    MaxDist = 100, 
                    Radius_Molotov = 0, 
                    Radius_Cell = 40, 
                    Cells = {}
                };
                for v326 = 1, 64 do
                    if v321.m_bFireIsBurning[v326] then
                        table.insert(v325.Cells, vector(v321.m_fireXDelta[v326], v321.m_fireYDelta[v326], v321.m_fireZDelta[v326]));
                    end;
                end;
                for v327 = 1, #v325.Cells do
                    for v328 = 1, #v325.Cells do
                        local v329 = v325.Cells[v327]:dist2d(v325.Cells[v328]);
                        if v325.MaxDist < v329 then
                            v325.MaxDist = v329;
                            v325.MACell = v325.Cells[v327];
                            v325.MBCell = v325.Cells[v328];
                        end;
                    end;
                end;
                if v325.MACell ~= nil and v325.MBCell ~= nil then
                    local v330 = v322 + v310.grenade.lerp(v325.MACell, v325.MBCell, 0.5);
                    render.circle_3d_outline(v330, v67.settings.grenade_radius[0].molotov:get() * color(255, 255, 255, 255 * (v324.Alpha / 255)), (v325.MaxDist / 2 + v325.Radius_Cell) * (v324.Radius / 100), 0, 1);
                end;
            end;
        end;
        if #v67.settings.grenade_radius[0].display:get() > 0 then
            for v331 = 1, #v310.grenade.list do
                local v332 = v310.grenade.list[v331];
                local v333 = 20;
                do
                    local l_v332_0, l_v333_0 = v332, v333;
                    pcall(function()
                        -- upvalues: l_v333_0 (ref), l_v332_0 (ref)
                        l_v333_0 = l_v332_0.Type == "Molotov" and 8 or l_v332_0.Type == "Smoke" and 19;
                    end);
                    if l_v332_0 == nil or l_v333_0 < globals.curtime - l_v332_0.Time then
                        table.remove(v310.grenade.list, v331);
                    end;
                end;
            end;
        end;
        return;
    end;
end;
local v341 = {
    extrapolate_position = function(v336, v337, v338)
        local l_m_vecVelocity_0 = v338.m_vecVelocity;
        for _ = 0, v337 do
            v336 = v336 + l_m_vecVelocity_0 * globals.tickinterval;
        end;
        return v336;
    end
};
v341.createmove = function(v342)
    -- upvalues: v67 (ref), v53 (ref), v341 (ref), v101 (ref), l_liberia_0 (ref)
    if v67.settings.teleport_in_air:get() and v53["Double Tap"]:get() and rage.exploit:get() == 1 then
        local v343 = entity.get_local_player();
        if not v343 then
            return;
        else
            local v344 = false;
            local v345 = false;
            local v346 = v343:get_player_weapon();
            if v346 == nil then
                return;
            else
                local v347 = v346:get_weapon_index();
                if v347 == nil then
                    return;
                else
                    local l_weapon_type_0 = v346:get_weapon_info().weapon_type;
                    if l_weapon_type_0 == nil then
                        return;
                    else
                        local v349 = {
                            is_AWP = v347 == 9, 
                            is_auto = v347 == 38 or v347 == 11, 
                            is_scout = v347 == 40, 
                            is_deagle = v347 == 1, 
                            is_r8 = v347 == 64, 
                            is_nades = l_weapon_type_0 == 9, 
                            is_pistols = l_weapon_type_0 == 1 and v347 ~= 1 and v347 ~= 64, 
                            is_smg = v347 == 34 or not (v347 ~= 23) or not (v347 ~= 24) or not (v347 ~= 19) or not (v347 ~= 26) or not (v347 ~= 33) or v347 == 17, 
                            is_shotguns = v347 == 35 or not (v347 ~= 25) or not (v347 ~= 27) or v347 == 29, 
                            is_rifle = l_weapon_type_0 == 3 and v347 ~= 35 and v347 ~= 25 and v347 ~= 27 and v347 ~= 29 and v347 ~= 35 and v347 ~= 25 and v347 ~= 27 and v347 ~= 29, 
                            is_taser = v347 == 31
                        };
                        for _, v351 in pairs({
                            [1] = {
                                Value = "AWP", 
                                active_weapon = v349.is_AWP
                            }, 
                            [2] = {
                                Value = "AutoSnipers", 
                                active_weapon = v349.is_auto
                            }, 
                            [3] = {
                                Value = "Scout", 
                                active_weapon = v349.is_scout
                            }, 
                            [4] = {
                                Value = "Deagle", 
                                active_weapon = v349.is_deagle
                            }, 
                            [5] = {
                                Value = "Revolver", 
                                active_weapon = v349.is_r8
                            }, 
                            [6] = {
                                Value = "Nades", 
                                active_weapon = v349.is_nades
                            }, 
                            [7] = {
                                Value = "Other", 
                                active_weapon = not v349.is_AWP and not v349.is_auto and not v349.is_scout and not v349.is_deagle and not v349.is_r8 and not v349.is_nades and not v349.is_pistols and not v349.is_rifle and not v349.is_smg and not v349.is_shotguns and not v349.is_taser
                            }, 
                            [8] = {
                                Value = "Pistols", 
                                active_weapon = v349.is_pistols
                            }, 
                            [9] = {
                                Value = "Rifle/LMG", 
                                active_weapon = v349.is_rifle
                            }, 
                            [10] = {
                                Value = "SMG", 
                                active_weapon = v349.is_smg
                            }, 
                            [11] = {
                                Value = "Shotgun", 
                                active_weapon = v349.is_shotguns
                            }, 
                            [12] = {
                                Value = "Taser", 
                                active_weapon = v349.is_taser
                            }
                        }) do
                            if v67.settings.teleport_in_air[0].teleport_weapons:get(v351.Value) and v351.active_weapon then
                                v344 = true;
                            end;
                        end;
                        local v352 = v67.settings.teleport_in_air[0].damage:get();
                        local l_m_iHealth_0 = v343.m_iHealth;
                        local v354 = v341.extrapolate_position(v343:get_hitbox_position(3), v67.settings.teleport_in_air[0].ticks:get(), v343);
                        if v344 then
                            for _, v356 in pairs(entity.get_players(true, true)) do
                                local v357 = v356:get_hitbox_position(0);
                                local v358 = utils.trace_bullet(v356, v357, v354, v356);
                                local v359 = v352 <= v358;
                                if v352 == 0 then
                                    v359 = l_m_iHealth_0 <= v358;
                                end;
                                if v356 and v356:is_enemy() and v356:is_alive() and v359 then
                                    v345 = true;
                                end;
                            end;
                        end;
                        local v360 = v101.converter[l_liberia_0.anti_aim.condition.get()];
                        if (v360 == "Jumping" or v360 == "Crouching Air") and v345 and v343.m_vecVelocity:length() > 25 then
                            v342.force_defensive = true;
                            rage.exploit:force_teleport();
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
local v388 = {
    calibri = render.load_font("calibri", vector(24, 23.5), "ab"), 
    shadow = function(_, v362, v363, v364)
        render.gradient(v362 - vector(10), vector(v362.x + v363.x / 2, v363.y), color(0, 0), v364, color(0, 0), v364);
        render.gradient(vector(v362.x + v363.x / 2, v362.y), v363 + vector(10), v364, color(0, 0), v364, color(0, 0));
    end, 
    image = render.load_image_from_file("materials/panorama/images/icons/ui/bomb_c4.svg", vector(64, 64)), 
    indicator = function(v365, v366, v367, v368, v369, v370, v371)
        -- upvalues: v8 (ref)
        local v372 = render.measure_text(v365.calibri, nil, v371 and " " .. v370 or v370);
        local v373 = render.get_scale(2);
        v372.x = (v371 and 32 * v373 or 0) + v372.x;
        local v374 = vector(14, v8.screen.y / 1.55 - 1 + (v372.y + 17) * v365.adder);
        v365:shadow(vector(v374.x - 10, v374.y - 7), vector(v374.x + v372.x + 7, v374.y + v372.y + 2), color(0, 55));
        if v371 then
            render.texture(v365.image, v374 - vector(0, 6), vector(32 * v373, 31 * v373), color(v366, v367, v368, v369));
        end;
        render.text(v365.calibri, v374 + vector(v371 and 32 * v373 or 0, 0), color(0, 100), nil, v371 and " " .. v370 or v370);
        render.text(v365.calibri, v374 + vector(v371 and 32 * v373 or 0, 1), color(0, 55), nil, v371 and " " .. v370 or v370);
        render.text(v365.calibri, v374 + vector(v371 and 32 * v373 or 1, 1), color(0, 100), nil, v371 and " " .. v370 or v370);
        render.text(v365.calibri, v374 + vector(v371 and 32 * v373 or 0, 0), color(v366, v367, v368, v369), nil, v371 and " " .. v370 or v370);
        return color(v366, v367, v368, v369), vector(render.measure_text(v365.calibri, "as", v371 and " " .. v370 or v370, true).x, v374.y), v374;
    end, 
    on_plant_time = 0, 
    planting_site = "", 
    planting = false, 
    adder = 0, 
    clear_planting_info = function(v375)
        v375.planting = false;
        v375.on_plant_time = 0;
        v375.planting_site = "";
    end, 
    bomb_beginplant = function(v376, v377)
        local v378 = entity.get_player_resource();
        if not v378 then
            return;
        else
            local l_m_bombsiteCenterA_0 = v378.m_bombsiteCenterA;
            local l_m_bombsiteCenterB_0 = v378.m_bombsiteCenterB;
            local v381 = entity.get(v377.site);
            if not v381 then
                return;
            else
                local v382 = v381.m_vecMins:lerp(v381.m_vecMaxs, 0.5);
                v376.planting_site = v382:distsqr(l_m_bombsiteCenterA_0) < v382:distsqr(l_m_bombsiteCenterB_0) and "A" or "B";
                v376.on_plant_time = globals.curtime;
                v376.planting = true;
                return;
            end;
        end;
    end, 
    is_doubletap = function()
        -- upvalues: v53 (ref)
        if not v53["Double Tap"]:get() or rage.exploit:get() ~= 1 then
            return false;
        else
            local v383 = entity.get_local_player();
            if not v383 or not v383:is_alive() then
                return;
            else
                local v384 = v383:get_player_weapon();
                if not v384 then
                    return false;
                else
                    local v385 = v383.m_flNextAttack + 0.25;
                    local l_m_flNextPrimaryAttack_0 = v384.m_flNextPrimaryAttack;
                    if l_m_flNextPrimaryAttack_0 == nil then
                        return;
                    else
                        local v387 = l_m_flNextPrimaryAttack_0 + 0.3;
                        if v385 == nil or v387 == nil then
                            return false;
                        else
                            return v385 - globals.curtime < 0 and v387 - globals.curtime < 0;
                        end;
                    end;
                end;
            end;
        end;
    end, 
    vars = {
        hits = 0, 
        shots = 0, 
        old_choke = 0, 
        choke4 = 0, 
        choke3 = 0, 
        choke2 = 0, 
        choke1 = 0, 
        choke0 = 0
    }
};
v388.aim_ack = function(v389)
    -- upvalues: v388 (ref)
    v388.vars.shots = v388.vars.shots + 1;
    if not v389.state then
        v388.vars.hits = v388.vars.hits + 1;
    end;
end;
v388.executer_indicators = function(v390)
    -- upvalues: v67 (ref), v388 (ref), v53 (ref), v8 (ref)
    local v391 = entity.get_local_player();
    if v391 == nil or not globals.is_in_game or not globals.is_connected or not v67.settings.sense_indicators:get() then
        return;
    else
        local v392 = ui.get_binds();
        local v393 = false;
        local v394 = false;
        for v395 = 1, #v392 do
            if tostring(v392[v395].reference):find("Min. Damage") ~= nil and v392[v395].active then
                v393 = true;
            end;
            if tostring(v392[v395].reference):find("Hit Chance") ~= nil and v392[v395].active then
                v394 = true;
            end;
        end;
        v390.adder = 1;
        if v391:is_alive() then
            if v67.settings.sense_indicators[0].display:get("Hit Chance") and v394 then
                v390:indicator(255, 255, 255, 245, "HITCHANCE OVR");
                v390.adder = v390.adder - 1;
            end;
            if v67.settings.sense_indicators[0].display:get("Fake Lag") then
                v390:indicator(255, 255, 255, 245, ("%i-%i-%i-%i-%i"):format(v390.vars.choke4, v390.vars.choke3, v390.vars.choke2, v390.vars.choke1, v390.vars.choke0));
                v390.adder = v390.adder - 1;
                if globals.choked_commands < v390.vars.old_choke then
                    v390.vars.choke0 = v390.vars.choke1;
                    v390.vars.choke1 = v390.vars.choke2;
                    v390.vars.choke2 = v390.vars.choke3;
                    v390.vars.choke3 = v390.vars.choke4;
                    v390.vars.choke4 = v390.vars.old_choke;
                end;
                v390.vars.old_choke = globals.choked_commands;
            end;
            if v67.settings.sense_indicators[0].display:get("Aimbot Stats") then
                local v396 = v388.vars.hits == 0 and v388.vars.shots == 0 and 0 or v388.vars.hits / v388.vars.shots * 100 or 0;
                v390:indicator(255, 255, 255, 245, ("%i / %i (%.1f)"):format(v388.vars.hits, v388.vars.shots, v396));
                v390.adder = v390.adder - 1;
            end;
            local v397 = utils.net_channel();
            if globals.is_connected and v397 and v67.settings.sense_indicators[0].display:get("Fake Latency") then
                local v398 = v397.latency[1];
                local v399 = v397.latency[0];
                local v400 = math.min(math.max(0, math.abs((v399 + v398) * 1000) / 200), 1);
                local v401 = nil;
                if v400 < 0.5 then
                    v401 = color(167, 194, 41):mix(color(255, 233, 161), v400 * 2);
                else
                    v401 = color(169, 233, 18):mix(color(167, 194, 41), (v400 - 0.5) * 2);
                end;
                if ui.find("Miscellaneous", "Main", "Other", "Fake Latency"):get() ~= 0 then
                    v390:indicator(v401.r, v401.g, v401.b, 205, "PING");
                    v390.adder = v390.adder - 1;
                end;
            end;
            if not v53["Fake Duck"]:get() and v53["Double Tap"]:get() and v67.settings.sense_indicators[0].display:get("Double Tap") then
                v390:indicator(v390:is_doubletap() and 255 or 255, v390:is_doubletap() and 255 or 0, v390:is_doubletap() and 255 or 50, v390:is_doubletap() and 205 or 245, "DT");
                v390.adder = v390.adder - 1;
            end;
            if not v53["Fake Duck"]:get() and v53["Hide Shots"]:get() and not v53["Double Tap"]:get() and v67.settings.sense_indicators[0].display:get("Hide Shots") then
                v390:indicator(255, 255, 255, 205, "OSAA");
                v390.adder = v390.adder - 1;
            end;
            if v53["Dormant Aimbot"]:get() and v67.settings.sense_indicators[0].display:get("Dormant Aimbot") then
                local v402 = 255;
                local v403 = 255;
                local v404 = 255;
                local v405 = 205;
                if entity.get_threat() and entity.get_threat():is_dormant() then
                    local v406 = 255;
                    local v407 = 0;
                    local v408 = 50;
                    v405 = 245;
                    v404 = v408;
                    v403 = v407;
                    v402 = v406;
                end;
                v390:indicator(v402, v403, v404, v405, "DA");
                v390.adder = v390.adder - 1;
            end;
            if v53["Fake Duck"]:get() and v67.settings.sense_indicators[0].display:get("Fake Duck") then
                v390:indicator(255, 255, 255, 205, "DUCK");
                v390.adder = v390.adder - 1;
            end;
            if v53["Safe Points"]:get() == "Force" and v67.settings.sense_indicators[0].display:get("Safe Points") then
                v390:indicator(255, 255, 255, 205, "SAFE");
                v390.adder = v390.adder - 1;
            end;
            if v53["Body Aim"]:get() == "Force" and v67.settings.sense_indicators[0].display:get("Body Aim") then
                v390:indicator(255, 255, 255, 205, "BODY");
                v390.adder = v390.adder - 1;
            end;
            if v393 and v67.settings.sense_indicators[0].display:get("Minimum Damage") then
                v390:indicator(255, 255, 255, 205, "MD");
                v390.adder = v390.adder - 1;
            end;
            if (v53["Freestanding NL"]:get_override() or v53["Freestanding NL"]:get()) and v67.settings.sense_indicators[0].display:get("Freestanding") then
                v390:indicator(255, 255, 255, 205, "FS");
                v390.adder = v390.adder - 1;
            end;
        end;
        entity.get_entities("CPlantedC4", false, function(v409)
            -- upvalues: v67 (ref), v8 (ref), v391 (ref), v390 (ref)
            if not v409 or v409.m_bBombDefused then
                return;
            else
                if v67.settings.sense_indicators[0].display:get("Bomb Info") or v67.settings.sense_indicators[0].display:get("Defusing") then
                    local v410 = v409.m_flC4Blow - globals.curtime;
                    if v410 >= 0 then
                        local v411 = v409.m_hBombDefuser ~= nil;
                        local l_m_flDefuseLength_0 = v409.m_flDefuseLength;
                        local v413 = v411 and (v409.m_flDefuseCountDown - globals.curtime) / 1 or -1;
                        if v413 > 0 and v67.settings.sense_indicators[0].display:get("Defusing") then
                            local v414 = v413 < v410 and color(40, 140, 50, 200) or color(255, 0, 0, 200);
                            local v415 = (v8.screen.y + 70) / l_m_flDefuseLength_0 * v413;
                            render.rect(vector(0, 0), vector(20, v8.screen.y), color(5, 200));
                            render.rect(vector(1, v8.screen.y - v415), vector(19, v8.screen.y), v414);
                        end;
                        local v416 = v409.m_nBombSite == 0 and "A" or "B";
                        local v417 = v391:is_alive() and entity.get_local_player() or v391.m_hObserverTarget;
                        local v418 = v417 and v417.m_iHealth or 0;
                        if v67.settings.sense_indicators[0].display:get("Bomb Info") then
                            v390:indicator(255, 255, 255, 205, ("%s - %.1fs"):format(v416, v410), true);
                            v390.adder = v390.adder - 1;
                        end;
                        if v417 and v417:get_eye_position() then
                            local v419 = (v417:is_alive() and v417:get_eye_position() or v417 and v417.m_hObserverTarget and v417.m_hObserverTarget:get_eye_position() or v417:get_eye_position()):dist(v409:get_origin());
                            local v420 = nil;
                            v420 = 500;
                            local v421 = v420 * 3.5;
                            v420 = v420 * math.exp(-(v419 * v419 / (v421 * 2 / 3 * (v421 / 3))));
                            v420 = math.max(v420, 0);
                            local l_m_ArmorValue_0 = v417.m_ArmorValue;
                            local v423 = 0.5;
                            local v424 = 0.5;
                            if l_m_ArmorValue_0 > 0 then
                                local v425 = v420 * v423;
                                if l_m_ArmorValue_0 < (v420 - v425) * v424 then
                                    v425 = v420 - l_m_ArmorValue_0 * (1 / v424);
                                end;
                                v420 = v425;
                            end;
                            if v67.settings.sense_indicators[0].display:get("Bomb Info") and v417 then
                                if v418 < v420 then
                                    v390:indicator(255, 0, 50, 245, "FATAL");
                                    v390.adder = v390.adder - 1;
                                elseif v420 > 1 then
                                    v390:indicator(252, 243, 105, 205, ("-%i HP"):format(v420));
                                    v390.adder = v390.adder - 1;
                                end;
                            end;
                        end;
                    end;
                end;
                return;
            end;
        end);
        local v426 = nil;
        if v390.planting and v67.settings.sense_indicators[0].display:get("Bomb Info") then
            local _, v428 = v390:indicator(252, 243, 105, 205, v390.planting_site, true);
            v390.adder = v390.adder - 1;
            local v429 = 3.125 - (3.125 + v390.on_plant_time - globals.curtime);
            if v429 > 3.125 then
                v429 = 3.125;
            end;
            render.circle_outline(vector(render.measure_text(v390.calibri, "as", v390.planting_site, true).x + 20 * render.get_scale(2), v428.y + 8 * render.get_scale(2)), color(0, 0, 0, 200), 11 * render.get_scale(2), 0, 1, 5 * render.get_scale(2));
            render.circle_outline(vector(render.measure_text(v390.calibri, "as", v390.planting_site, true).x + 20 * render.get_scale(2), v428.y + 8 * render.get_scale(2)), color(213, 213, 214, 255), 10 * render.get_scale(2), 0, v429 * 0.32114155788, 3 * render.get_scale(2));
        elseif v426 ~= 0 then
            v426 = 0;
        end;
        return;
    end;
end;
v388.get_spectators = function(v430)
    local v431 = nil;
    if v430:is_alive() then
        v431 = v430:get_spectators();
    else
        local l_m_hObserverTarget_1 = v430.m_hObserverTarget;
        if not l_m_hObserverTarget_1 then
            return;
        else
            v431 = l_m_hObserverTarget_1:get_spectators();
        end;
    end;
    return v431;
end;
v388.executer_spectators = function()
    -- upvalues: v67 (ref), v388 (ref), v8 (ref)
    local v433 = entity.get_local_player();
    if not v67.settings.sense_indicators:get() then
        return;
    elseif not v433 or not v67.settings.sense_indicators[0].spectators:get() then
        return;
    else
        local v434 = v388.get_spectators(v433);
        if not v434 then
            return;
        else
            local v435 = 0;
            for v436 = 1, #v434 do
                local v437 = v434[v436]:get_name();
                if v437 ~= "GOTV" then
                    render.text(1, vector(v8.screen.x - 9, 5 + v435), color(255, 200), "r", v437);
                    v435 = v435 + 12;
                end;
            end;
            return;
        end;
    end;
end;
local v438 = {
    iverter = false, 
    camera_angles = vector(), 
    anti_aim_rotation = 0
};
v438.executer = function()
    -- upvalues: v67 (ref), v438 (ref), v8 (ref), l_smooth_0 (ref), v254 (ref)
    local v439 = entity.get_local_player();
    if not v439 or not v439:is_alive() or not v67.settings.yaw_position_arrows:get() then
        return;
    else
        local v440 = false;
        if v439 then
            local v441 = v439:get_player_weapon();
            if not v441 then
                return;
            else
                local v442 = v441:get_weapon_info();
                if not v442 then
                    return;
                else
                    v440 = v442.weapon_type == 9;
                end;
            end;
        end;
        if globals.choked_commands == 0 then
            v438.anti_aim_rotation = rage.antiaim:get_rotation();
            v438.camera_angles = render.camera_angles() - math.normalize_yaw(v439:get_anim_state().eye_yaw - v439:get_anim_state().abs_yaw);
            v438.inverter = rage.antiaim:inverter();
        end;
        local v443 = v8.screen * 0.5 - vector(0, 2);
        local v444 = l_smooth_0.linear("CHERNOBYL", "Arrows grenade", not v439 or not v440 or false, 0.5, 1);
        local v445 = l_smooth_0.linear("CHERNOBYL", "Arrows tab", not v439 or not v254.main.tab or false, 0, 1);
        local v446 = l_smooth_0.linear("CHERNOBYL", "Arrows scope", not v439.m_bIsScoped, 0.5, 1) * v444 * v445;
        local v447 = v67.settings.yaw_position_arrows[0].invert_color:get();
        local v448 = v67.settings.yaw_position_arrows[0].manual_color:get();
        local v449 = v438.inverter and color(35, 150 * v446) or v447:modulate_alpha(v447.a * v446);
        local v450 = v438.inverter and v447:modulate_alpha(v447.a * v446) or color(35, 150 * v446);
        local v451 = v67["anti aim"].yaw_base:get() == "Right" and v448:modulate_alpha(v448.a * v446) or color(35, 150 * v446);
        local v452 = v67["anti aim"].yaw_base:get() == "Left" and v448:modulate_alpha(v448.a * v446) or color(35, 150 * v446);
        render.poly(v451, vector(v443.x + 55, v443.y + 2), vector(v443.x + 42, v443.y - 7), vector(v443.x + 42, v443.y + 11));
        render.poly(v452, vector(v443.x - 55, v443.y + 2), vector(v443.x - 42, v443.y - 7), vector(v443.x - 42, v443.y + 11));
        render.rect(vector(v443.x + 38, v443.y - 7), vector(v443.x + 38 + 2, v443.y - 7 + 18), v449);
        render.rect(vector(v443.x - 40, v443.y - 7), vector(v443.x - 40 + 2, v443.y - 7 + 18), v450);
        return;
    end;
end;
local v453 = {
    main = {
        list = {}
    }
};
v453.aim_fire = function(v454)
    -- upvalues: v67 (ref), v453 (ref)
    if v67.settings.hit_marker:get() then
        table.insert(v453.main.list, {
            delete = false, 
            position = v454.aim, 
            timeout = globals.curtime + ui.find("Visuals", "World", "Other", "Bullet Impacts", "Duration"):get()
        });
    end;
end;
v453.round_start = function()
    -- upvalues: v453 (ref)
    v453.main.list = {};
end;
v453.player_disconnect = function(v455)
    -- upvalues: v453 (ref)
    if entity.get(v455.userid, true) == entity.get_local_player() then
        v453.main.list = {};
    end;
end;
v453.player_connect_full = function(v456)
    -- upvalues: v453 (ref)
    if entity.get(v456.userid, true) == entity.get_local_player() then
        v453.main.list = {};
    end;
end;
v453.executer = function()
    -- upvalues: v67 (ref), v453 (ref)
    if v67.settings.hit_marker:get() then
        local v457 = entity.get_local_player();
        if not v457 or not v457:is_alive() then
            v453.main.list = {};
            return;
        else
            for v458 = 1, #v453.main.list do
                local v459 = v453.main.list[v458];
                if globals.curtime <= v459.timeout then
                    local v460 = v459.position:to_screen();
                    if v460 then
                        render.line(vector(v460.x - 6, v460.y), vector(v460.x + 6, v460.y), color(0, 255, 255, 255));
                        render.line(vector(v460.x, v460.y - 6), vector(v460.x, v460.y + 6), color(0, 255, 0, 255));
                    end;
                else
                    v459.delete = true;
                end;
            end;
            for v461 = 1, #v453.main.list do
                local v462 = v453.main.list[v461];
                if not v462 or v462.delete then
                    table.remove(v453.main.list, v461);
                end;
            end;
        end;
    end;
end;
local v463 = {
    last_killer = nil, 
    trashtalk_list = {}, 
    trashtalk_type = {
        KILL = 1, 
        KILLERS_DEATH = 4, 
        SELF_DEATH = 3, 
        ASSIST = 2
    }
};
v463.add_in_kill_queue = function(v464)
    -- upvalues: v463 (ref), v67 (ref)
    local v465 = entity.get_local_player();
    if not v465 then
        return;
    else
        local v466 = entity.get(v464.userid, true);
        local v467 = entity.get(v464.attacker, true);
        local v468 = entity.get(v464.assister, true);
        if v466 == v467 then
            return;
        else
            if v466 == v465 then
                v463.last_killer = v467;
            end;
            if math.random(1, 5) == 1 then
                return;
            else
                if v67.settings.trashtalk[0].trashtalk_options:get("On Kill") and v467 == v465 then
                    table.insert(v463.trashtalk_list, {
                        real_time = globals.realtime, 
                        type = v463.trashtalk_type.KILL
                    });
                end;
                if v67.settings.trashtalk[0].trashtalk_options:get("On Assist") and v468 == v465 and v465:is_alive() then
                    table.insert(v463.trashtalk_list, {
                        real_time = globals.realtime, 
                        type = v463.trashtalk_type.ASSIST
                    });
                end;
                if v67.settings.trashtalk[0].trashtalk_options:get("On Self Death") and v466 == v465 then
                    table.insert(v463.trashtalk_list, {
                        real_time = globals.realtime, 
                        type = v463.trashtalk_type.SELF_DEATH
                    });
                end;
                if v67.settings.trashtalk[0].trashtalk_options:get("On Killers Death") and v466 == v463.last_killer then
                    table.insert(v463.trashtalk_list, {
                        real_time = globals.realtime, 
                        type = v463.trashtalk_type.KILLERS_DEATH
                    });
                    v463.last_killer = nil;
                end;
                return;
            end;
        end;
    end;
end;
v463.data_base = {
    [1] = {
        [1] = {
            [1] = "1"
        }, 
        [2] = {
            [1] = "1", 
            [2] = "\208\181\208\177\208\176\208\189\208\189\209\139\208\185 \208\191\208\184\208\180\208\190\209\128\208\176\209\129"
        }, 
        [3] = {
            [1] = "\208\178 \209\129\208\190\208\189", 
            [2] = "\209\133\209\131\208\181\209\129\208\190\209\129"
        }, 
        [4] = {
            [1] = "\208\189\208\176\209\133\209\131\208\185 \209\129 \208\191\208\187\209\143\208\182\208\176", 
            [2] = "\208\191\208\184\208\180\208\190\209\128\208\176\209\129"
        }, 
        [5] = {
            [1] = "\208\159\208\151\208\165\208\170\208\144\208\151\208\170\208\144\208\159\208\165\208\151\208\144\208\159\208\165\208\170", 
            [2] = "1 \208\180\208\190\208\187\208\177\208\176\208\181\208\177"
        }, 
        [6] = {
            [1] = "1", 
            [2] = "\208\181\208\177\208\176\208\189\208\189\209\139\208\185", 
            [3] = "\208\191\208\184\208\180\208\190\209\128\208\176", 
            [4] = "\209\129"
        }, 
        [7] = {
            [1] = "\208\151\208\165\208\159\208\170\208\151\208\165\208\170\208\144\208\159\208\170\208\165\208\159\208\144", 
            [2] = "\208\162\208\171 \208\167\208\149 \208\161\208\158\208\146\208\161\208\149\208\156 \208\148\208\158\208\155\208\145\208\144\208\149\208\145?"
        }, 
        [8] = {
            [1] = "\209\129\208\191\208\176\209\130\209\140", 
            [2] = "\209\129\209\139\208\189 \208\177\208\187\209\143\208\180\208\184"
        }, 
        [9] = {
            [1] = "1."
        }, 
        [10] = {
            [1] = "\208\190\208\191\209\128\208\176\208\178\208\180\208\176\208\185\209\129\209\143", 
            [2] = "\208\188\208\189\208\181", 
            [3] = "\208\178 \209\133\209\131\208\185", 
            [4] = "\208\191\208\184\208\180\208\190\209\128\208\176\209\129"
        }, 
        [11] = {
            [1] = "1", 
            [2] = "\208\188\208\176\209\130\209\140 \209\130\208\178\208\190\209\142 \208\181\208\177\208\176\208\187", 
            [3] = "\209\129\209\139\208\189 \209\136\208\187\209\142\209\133\208\184"
        }, 
        [12] = {
            [1] = "cya@yt", 
            [2] = "\209\129\209\139\208\189 \209\136\208\176\208\187\208\176\208\178\209\139"
        }, 
        [13] = {
            [1] = "iq?"
        }, 
        [14] = {
            [1] = "\208\183\209\133\209\138\208\191\208\176\208\178\208\183\209\138\209\133\208\191\208\178\208\176\208\183\209\138\209\133", 
            [2] = "\208\189\208\176\208\185\209\129 \208\176\208\176", 
            [3] = "\208\191\208\184\208\180\208\190\209\128\208\176\209\129"
        }, 
        [15] = {
            [1] = "1", 
            [2] = "\208\181\208\177\208\176\208\189\208\189\209\139\208\185", 
            [3] = "\208\183\208\176\209\130\209\131\208\191\208\190\208\186"
        }, 
        [16] = {
            [1] = "\208\186\208\176\208\186\208\190\208\185", 
            [2] = "\208\182\208\181", 
            [3] = "\209\130\209\139", 
            [4] = "\209\130\209\131\208\191\208\190\208\185"
        }
    }, 
    [2] = {
        [1] = {
            [1] = "\209\131\208\181\208\177\208\184\209\137\208\181", 
            [2] = "\208\189\208\176\209\133\209\131\208\185 \209\130\209\139 \208\186\208\184\208\187\208\187 \209\129\208\191\208\184\208\183\208\180\208\184\208\187?"
        }, 
        [2] = {
            [1] = "\208\189\208\181 \208\191\208\184\208\183\208\180\208\184 \208\186\208\184\208\187\208\187\209\139 \208\191\208\184\208\180\208\190\209\128\208\176\209\129"
        }, 
        [3] = {
            [1] = "\208\191\208\190\208\180\209\129\208\190\209\129 \208\181\208\177\209\131\209\135\208\184\208\185"
        }, 
        [4] = {
            [1] = "\208\189\209\131 \208\189\208\176\209\133\209\131\209\143 \208\180\208\190\208\187\208\177\208\190\208\181\208\177"
        }, 
        [5] = {
            [1] = "\209\143 \208\177\209\139 \209\131\208\177\208\184\208\187 \208\180\208\176\209\131\208\189 \209\130\209\131\208\191\208\190\208\185"
        }, 
        [6] = {
            [1] = "\209\129\209\139\208\189 \208\181\208\177\209\131\209\135\208\181\208\185 \209\136\208\187\209\142\209\133\208\184 \209\141\209\130\208\190 \208\188\208\190\208\185 \208\186\208\184\208\187\208\187 \208\177\209\139\208\187"
        }
    }, 
    [3] = {
        [1] = {
            [1] = "\208\151\208\159\208\165\208\170\208\144\208\151\208\165\208\170\208\144\208\159\208\151\208\159\208\165\208\170\208\144", 
            [2] = "\209\130\209\131\208\191\208\190\208\185", 
            [3] = "\208\191\208\184\208\180\208\190\209\128\208\176\209\129"
        }, 
        [2] = {
            [1] = "\209\131\208\181\208\177\208\184\209\137\208\181", 
            [2] = "\208\186\208\176\208\186 \209\130\209\139 \208\188\208\181\208\189\209\143 \209\131\208\177\208\184\208\187"
        }, 
        [3] = {
            [1] = "\208\189\209\131 \208\181\208\177\208\176\208\189\209\139\208\185 \209\129\209\139\208\189 \209\136\208\187\209\142\209\133\208\184", 
            [2] = "\208\186\208\176\208\186 \209\130\209\139 \208\188\208\181\208\189\209\143 \208\186\209\131\208\188\208\176\209\128\208\184\209\136\209\140"
        }, 
        [4] = {
            [1] = "\208\151\208\146\208\170\208\165\208\144\208\170\208\151\208\146\208\165\208\144\208\159\208\144\208\159\208\151\208\170", 
            [2] = "\209\135\208\181 \209\130\209\139 \209\129\208\180\208\181\208\187\208\176\208\187"
        }, 
        [5] = {
            [1] = "\209\129\209\139\208\189 \209\136\208\187\209\142\209\133\208\184", 
            [2] = "\208\188\208\176\209\130\209\140 \209\130\208\178\208\190\209\142 \208\181\208\177\208\176\208\187"
        }, 
        [6] = {
            [1] = "\208\186\208\176\208\186\208\190\208\185 \209\130\209\139 \209\130\209\131\208\191\208\190\208\185", 
            [2] = "\209\130\209\139 \208\188\209\131\208\178\208\176\209\130\209\140\209\129\209\143 \208\182\208\181 \208\189\208\181 \209\131\208\188\208\181\208\181\209\136\209\140"
        }, 
        [7] = {
            [1] = "\208\180\208\190\208\187\208\177\208\176\208\181\208\177", 
            [2] = "\208\188\208\176\209\130\209\140 \209\130\208\178\208\190\209\142 \208\181\208\177\208\176\208\187"
        }, 
        [8] = {
            [1] = "\208\177\208\176\209\130\209\140\208\186\208\176 \209\130\208\178\208\190\208\181\208\179\208\190 \208\189\208\190\208\179\208\176\208\188\208\184 \208\191\208\184\208\189\208\176\208\187"
        }, 
        [9] = {
            [1] = "\208\181\208\177\208\176\208\189\208\189\209\139\208\185", 
            [2] = "\208\191\208\184\208\180\208\190\209\128\208\176\209\129", 
            [3] = "\209\135\208\181 \209\130\209\139 \208\180\208\181\208\187\208\176\208\181\209\136\209\140"
        }, 
        [10] = {
            [1] = "\208\186\208\176\208\186\208\190\208\185 \209\130\209\139 \209\133\209\131\208\181\208\178\209\139\208\185", 
            [2] = "\209\129\209\139\208\189 \208\181\208\177\208\176\208\189\208\189\208\190\208\185 \208\177\208\187\209\143\208\180\208\184"
        }, 
        [11] = {
            [1] = "\208\188\208\176\209\131\209\133\209\131 \209\130\208\178\208\190\209\142 \208\191\208\184\208\189\208\176\208\187 \208\189\208\190\208\179\208\176\208\188\208\184"
        }, 
        [12] = {
            [1] = "\208\189\209\131 \209\129\209\139\208\189 \209\136\208\187\209\142\209\133\208\184", 
            [2] = "\209\143 \208\178\209\129\209\142 \209\130\208\178\208\190\209\142 \209\129\208\181\208\188\209\140\209\142 \208\191\208\181\209\128\208\181\209\128\208\181\208\183\208\176\208\187"
        }, 
        [13] = {
            [1] = "\208\186\208\176\208\186\208\190\208\185 \209\130\209\139 \209\130\209\131\208\191\208\190\208\185", 
            [2] = "\208\180\208\190\208\187\208\177\208\176\208\181\208\177"
        }, 
        [14] = {
            [1] = "\209\129\209\139\208\189 \209\130\208\178\208\176\209\128\208\184 \209\130\209\131\208\191\208\190\208\185", 
            [2] = "\208\186\208\176\208\186 \208\182\208\181 \209\130\209\139 \208\188\208\181\208\189\209\143 \208\183\208\176\208\181\208\177\208\176\208\187"
        }, 
        [15] = {
            [1] = "\209\130\208\176\208\186\208\190\208\185", 
            [2] = "\209\130\208\190", 
            [3] = "\208\177\208\187\209\143\208\180\209\140", 
            [4] = "\209\131\208\177\209\140\208\181\209\130"
        }, 
        [16] = {
            [1] = "\208\189\209\131 \208\181\208\177\208\176\208\189\208\189\209\139\208\185 \208\183\208\176\209\130\209\131\208\191\208\190\208\186", 
            [2] = "\208\186\208\176\208\186\208\190\208\185 \209\130\209\139 \209\130\209\131\208\191\208\190\208\185"
        }
    }, 
    [4] = {
        [1] = {
            [1] = "1"
        }, 
        [2] = {
            [1] = "\209\129\208\191\208\176\209\130\209\140 \208\189\208\176\209\133\209\131\208\185"
        }, 
        [3] = {
            [1] = "1", 
            [2] = "\209\129\209\139\208\189 \208\181\208\177\208\176\208\189\208\189\208\190\208\185 \208\177\208\187\209\143\208\180\208\184"
        }, 
        [4] = {
            [1] = "\209\129\208\191\208\184 \208\191\208\184\208\180\208\190\209\128\208\176\209\129"
        }, 
        [5] = {
            [1] = "1", 
            [2] = "\209\129\209\139\208\189 \209\130\208\178\208\176\209\128\208\184"
        }, 
        [6] = {
            [1] = "1", 
            [2] = "\208\181\208\177\208\176\208\189\208\189\209\139\208\185 \208\183\208\176\209\130\209\131\208\191\208\190\208\186"
        }, 
        [7] = {
            [1] = "\208\191\208\190\208\186\208\176\208\183\208\176\208\187 \208\188\208\190\208\183\208\179", 
            [2] = "\208\191\208\184\208\180\208\190\209\128\208\176\209\129"
        }, 
        [8] = {
            [1] = "\208\191\208\190 \208\191\209\128\208\184\208\186\208\176\208\183\209\131", 
            [2] = "\209\131\208\188\208\181\209\128 \208\180\208\190\208\187\208\177\208\190\208\181\208\177"
        }
    }
};
v463.current_phase = {
    [1] = {
        [1] = 0, 
        [2] = 0
    }, 
    [2] = {
        [1] = 0, 
        [2] = 0
    }, 
    [3] = {
        [1] = 0, 
        [2] = 0
    }, 
    [4] = {
        [1] = 0, 
        [2] = 0
    }
};
v463.control_queue = function()
    -- upvalues: v67 (ref), v463 (ref)
    if #v67.settings.trashtalk[0].trashtalk_options:get() == 0 or #v463.trashtalk_list == 0 then
        return;
    else
        local l_realtime_0 = globals.realtime;
        local v470 = v463.trashtalk_list[1];
        if v470.real_time == l_realtime_0 then
            return;
        else
            if not v470.delay_data then
                v463.current_phase[v470.type][1] = v463.current_phase[v470.type][1] + 1;
                if v463.current_phase[v470.type][1] > #v463.data_base[v470.type] then
                    v463.current_phase[v470.type][1] = 1;
                end;
                v470.delay_data = {
                    counter = 1, 
                    time = math.random(1.5, 4), 
                    step_time = math.random(1.5, 2), 
                    last_id = {}, 
                    current_target = v463.data_base[v470.type][v463.current_phase[v470.type][1]], 
                    max_counter = math.min(#v463.data_base[v470.type][v463.current_phase[v470.type][1]], #v463.data_base[v470.type])
                };
            end;
            if l_realtime_0 % v470.real_time > (v470.delay_data.counter == 1 and v470.delay_data.time or v470.delay_data.step_time) then
                v463.current_phase[v470.type][2] = v463.current_phase[v470.type][2] + 1;
                if v463.current_phase[v470.type][2] > #v470.delay_data.current_target then
                    v463.current_phase[v470.type][2] = 1;
                end;
                local v471 = v463.current_phase[v470.type][2];
                while v470.delay_data.last_id[v471] do
                    math.randomseed(common.get_unixtime());
                    v471 = math.random(1, #v470.delay_data.current_target);
                end;
                utils.console_exec(("%s \243\160\131\144%s"):format(v470.type == v463.trashtalk_type.ASSIST and "say_team" or "say", v470.delay_data.current_target[v471]));
                v470.delay_data.last_id[v471] = true;
                v470.real_time = l_realtime_0;
                v470.delay_data.time = math.max(#v470.delay_data.current_target[math.min(v471 + 1, #v470.delay_data.current_target)] * 0.1, 0.7);
                v470.delay_data.step_time = math.max(#v470.delay_data.current_target[math.min(v471 + 1, #v470.delay_data.current_target)] * 0.1, 0.7);
                v470.delay_data.counter = v470.delay_data.counter + 1;
                if v470.delay_data.counter > v470.delay_data.max_counter then
                    v463.current_phase[v470.type][2] = 0;
                    v463.trashtalk_list = {};
                end;
            end;
            return;
        end;
    end;
end;
v40("player_death", "trashtalk_death", function(v472)
    -- upvalues: v67 (ref), v463 (ref)
    if v67.settings.trashtalk:get() and #v67.settings.trashtalk[0].trashtalk_options:get() > 0 then
        v463.add_in_kill_queue(v472);
    end;
end);
v40("pre_render", "trashtalk_pre_render", function()
    -- upvalues: v67 (ref), v463 (ref)
    if v67.settings.trashtalk:get() and #v67.settings.trashtalk[0].trashtalk_options:get() > 0 then
        v463.control_queue();
    end;
end);
local v476 = {
    time_to_ticks = function(v473)
        return math.floor(v473 / globals.tickinterval + 0.5);
    end, 
    vars = {
        clantag_cache = "", 
        set_clantag = function(v474, v475)
            if v475 ~= v474.clantag_cache then
                common.set_clan_tag(v475);
                v474.clantag_cache = v475;
            end;
        end
    }
};
v476.animation = function(v477, v478)
    -- upvalues: v476 (ref)
    local v479 = "               " .. v477 .. "                      ";
    local v480 = utils.net_channel();
    if v480 == nil then
        return;
    else
        local v481 = (globals.tickcount + v476.time_to_ticks(v480.latency[0] + 0.321)) / v476.time_to_ticks(0.3);
        v481 = v478[math.floor(v481 % #v478) + 1] + 1;
        return v479:sub(v481, v481 + 15);
    end;
end;
v476.clan_tag_prev = "";
v476.executer = function()
    -- upvalues: v67 (ref), v476 (ref)
    if not entity.get_local_player() then
        return;
    else
        if v67.settings.clantag_spammer:get() then
            local v482 = v476.animation("chernobyl", {
                [1] = 0, 
                [2] = 2, 
                [3] = 3, 
                [4] = 4, 
                [5] = 5, 
                [6] = 6, 
                [7] = 7, 
                [8] = 8, 
                [9] = 9, 
                [10] = 10, 
                [11] = 11, 
                [12] = 11, 
                [13] = 11, 
                [14] = 11, 
                [15] = 11, 
                [16] = 11, 
                [17] = 11, 
                [18] = 11, 
                [19] = 12, 
                [20] = 13, 
                [21] = 14, 
                [22] = 15, 
                [23] = 16, 
                [24] = 17, 
                [25] = 18, 
                [26] = 19, 
                [27] = 20, 
                [28] = 21, 
                [29] = 22, 
                [30] = 23
            });
            local v483 = entity.get_game_rules();
            if v483.m_gamePhase == 5 or v483.m_timeUntilNextPhaseStarts ~= 0 then
                v476.vars:set_clantag(v476.animation("chernobyl", {
                    [1] = 11
                }));
            end;
            if v482 ~= v476.clan_tag_prev then
                v476.vars:set_clantag(v482);
            end;
            v476.clan_tag_prev = v482;
        end;
        return;
    end;
end;
v67.settings.clantag_spammer:set_callback(function(v484)
    if not v484:get() then
        common.set_clan_tag("\000");
    end;
end);
v40("pre_render", "clantag_spammer", v476.executer);
v100.set_viewmodel = function(v485, v486, v487, v488, v489)
    cvar.viewmodel_fov:float(v485 * 0.1, true);
    cvar.viewmodel_offset_x:float(v486 * 0.1, true);
    cvar.viewmodel_offset_y:float(v487 * 0.1, true);
    cvar.viewmodel_offset_z:float(v488 * 0.1, true);
    cvar.r_aspectratio:float(v489 * 0.01, true);
end;
v100.handle_viewmodel = function()
    -- upvalues: v67 (ref), v100 (ref)
    local v490 = v67.settings.viewmodel_changer[0].viewmodel_fov:get();
    local v491 = v67.settings.viewmodel_changer[0].viewmodel_x:get();
    local v492 = v67.settings.viewmodel_changer[0].viewmodel_y:get();
    local v493 = v67.settings.viewmodel_changer[0].viewmodel_z:get();
    local v494 = v67.settings.viewmodel_changer[0].aspect_ratio:get();
    v100.set_viewmodel(v490, v491, v492, v493, v494);
end;
v100.handle_menu = function()
    -- upvalues: v67 (ref), v100 (ref)
    if v67.settings.viewmodel_changer:get() then
        v100.handle_viewmodel();
    end;
end;
v67.settings.viewmodel_changer[0].viewmodel_fov:set_callback(function()
    -- upvalues: v100 (ref)
    return v100.handle_viewmodel();
end);
v67.settings.viewmodel_changer[0].viewmodel_x:set_callback(function()
    -- upvalues: v100 (ref)
    return v100.handle_viewmodel();
end);
v67.settings.viewmodel_changer[0].viewmodel_y:set_callback(function()
    -- upvalues: v100 (ref)
    return v100.handle_viewmodel();
end);
v67.settings.viewmodel_changer[0].viewmodel_z:set_callback(function()
    -- upvalues: v100 (ref)
    return v100.handle_viewmodel();
end);
v67.settings.viewmodel_changer[0].aspect_ratio:set_callback(function()
    -- upvalues: v100 (ref)
    return v100.handle_viewmodel();
end);
v67.settings.viewmodel_changer:set_callback(function()
    -- upvalues: v100 (ref)
    return v100.handle_menu();
end, true);
v100.DAG = false;
v100.drop_grenades = function()
    -- upvalues: v67 (ref), v100 (ref)
    local v495 = entity.get_local_player();
    if not v67.settings.drop_nades:get() then
        return;
    elseif v495 == nil or not v67.settings.drop_nades[0].drop_bind:get() then
        v100.DAG = false;
        return;
    elseif v100.DAG then
        return;
    else
        local v496 = v495:get_player_weapon(true);
        local v497 = 0.05;
        ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"):override(false);
        for v498 = 1, #v496 do
            local v499 = v496[v498]:get_weapon_info();
            do
                local l_v499_0 = v499;
                if l_v499_0 ~= nil and l_v499_0.weapon_type == 9 then
                    utils.execute_after(v497, function()
                        -- upvalues: l_v499_0 (ref)
                        utils.console_exec("use weapon_knife;");
                        utils.console_exec(("use %s;"):format(l_v499_0.console_name));
                        utils.console_exec("drop;");
                    end);
                    v497 = v497 + 0.05;
                end;
            end;
        end;
        utils.execute_after(v497 + 0.05, function()
            ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"):override(nil);
        end);
        v100.DAG = true;
        return;
    end;
end;
v100.air_strafe_fix = function(v501)
    -- upvalues: v67 (ref)
    if v67.settings.air_strafe_fix:get() then
        if v501.in_moveleft or v501.in_moveright or v501.in_back or v501.in_forward then
            return;
        else
            local v502 = entity.get_local_player();
            if v502 and v502:is_alive() and (v502.m_vecVelocity * vector(1, 1, 0)):length() <= 3 then
                v501.in_speed = true;
            end;
        end;
    end;
end;
v100.in_duck = nil;
v100.no_fall_damage_createmove = function(v503)
    -- upvalues: v67 (ref), v100 (ref)
    if v67.settings.no_fall_damage:get() and v100.in_duck ~= nil then
        v503.in_duck = v100.in_duck;
    end;
end;
v100.no_fall_damage_pre_render = function()
    -- upvalues: v100 (ref), v67 (ref)
    v100.in_duck = nil;
    if v67.settings.no_fall_damage:get() then
        local v504 = entity.get_local_player();
        if not v504 then
            return;
        else
            local v505 = v504:get_origin();
            if not v505 then
                return;
            elseif v504.m_vecVelocity.z <= -500 then
                local l_fraction_1 = utils.trace_line(v505, v505 + vector(0, 0, -256), v504).fraction;
                if l_fraction_1 <= 0.26 and l_fraction_1 > 0.05 then
                    v100.in_duck = true;
                elseif l_fraction_1 <= 0.04 then
                    v100.in_duck = false;
                end;
            end;
        end;
    end;
end;
v100.revolver_helper = esp.enemy:new_text("Revolver Helper", ("\a%sDMG+"):format(color(50, 205, 50, 255):to_hex()), function(v507)
    local v508 = entity.get_local_player();
    ui.find("Aimbot", "Ragebot", "Selection", "R8 Revolver", "Min. Damage"):override(nil);
    if v508 == nil or not v508:is_alive() then
        return;
    else
        local v509 = v508:get_origin():dist((v507:get_origin()));
        local v510 = v508:get_player_weapon();
        if v510 == nil then
            return;
        else
            if v510:get_weapon_index() == 64 and v507.m_ArmorValue == 0 then
                if v509 < 585 and v509 > 511 then
                    return ("\a%sDMG"):format(color(255, 0, 0, 255):to_hex());
                elseif v509 < 511 then
                    return ("\a%sDMG+"):format(color(50, 205, 50, 255):to_hex());
                end;
            end;
            return;
        end;
    end;
end);
v67.settings.revolver_helper:set_callback(function(v511)
    -- upvalues: v100 (ref)
    v100.revolver_helper:set(v511:get());
end, true);
v100.hwnd_ptr = ffi.cast("uintptr_t***", ffi.cast("uintptr_t", utils.opcode_scan("engine.dll", "8B 0D ?? ?? ?? ?? 85 C9 74 16 8B 01 8B")) + 2)[0][0] + 2;
v100.flash_window = ffi.cast("int(__stdcall*)(uintptr_t, int)", utils.opcode_scan("gameoverlayrenderer.dll", "55 8B EC 83 EC 14 8B 45 0C F7"));
v100.insn_jmp_ecx = ffi.cast("int(__thiscall*)(uintptr_t)", utils.opcode_scan("gameoverlayrenderer.dll", "FF E1"));
v100.get_foreground_window = ffi.cast("uintptr_t**", ffi.cast("uintptr_t", utils.opcode_scan("gameoverlayrenderer.dll", "FF 15 ?? ?? ?? ?? 3B C6 74")) + 2)[0][0];
v100.panorama = panorama.GameStateAPI;
v100.unmute_silenced = function()
    -- upvalues: v67 (ref), v100 (ref)
    if v67.settings.unmute_silenced:get() then
        local v512 = entity.get_players();
        if v512 then
            for _, v514 in pairs(v512) do
                local v515 = v100.panorama.GetPlayerXuidStringFromEntIndex(v514:get_index());
                if v100.panorama.IsSelectedPlayerMuted(v515) then
                    v100.panorama.ToggleMute(v515);
                end;
            end;
        end;
    end;
end;
v67.global.location:set_callback(function(v516)
    -- upvalues: l_mui_0 (ref), v52 (ref), v67 (ref)
    local v517 = {
        l_mui_0.header(("!h<!s<Link Active>>%s!i<globe>!d   Global tab"):format(v516:get() == 1 and "!i<arrow-right>  " or "")), 
        l_mui_0.header(("!h<!s<Link Active>>%s!i<floppy-disks>!d   Local configs"):format(v516:get() == 2 and "!i<arrow-right>  " or ""))
    };
    local v518 = {
        [1] = {
            [1] = "welcome", 
            [2] = "statistic", 
            [3] = "links"
        }, 
        [2] = {
            [1] = "configs", 
            [2] = "config_system"
        }
    };
    for v519 = 1, #v517 do
        for v520 = 1, #v518[v519] do
            v52.global[v518[v519][v520]]:visibility(v519 == v516:get());
        end;
    end;
    v67.global.location:update(v517);
end, true);
local v521 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
local v538 = {
    encode = function(v522)
        -- upvalues: v521 (ref)
        return (v522:gsub(".", function(v523)
            local v524 = "";
            local v525 = v523:byte();
            for v526 = 8, 1, -1 do
                v524 = v524 .. (v525 % 2 ^ v526 - v525 % 2 ^ (v526 - 1) > 0 and "1" or "0");
            end;
            return v524;
        end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(v527)
            -- upvalues: v521 (ref)
            if #v527 < 6 then
                return "";
            else
                local v528 = 0;
                for v529 = 1, 6 do
                    v528 = v528 + (v527:sub(v529, v529) == "1" and 2 ^ (6 - v529) or 0);
                end;
                return v521:sub(v528 + 1, v528 + 1);
            end;
        end) .. ({
            [1] = "", 
            [2] = "", 
            [3] = ""
        })[#v522 % 3 + 1];
    end, 
    decode = function(v530)
        -- upvalues: v521 (ref)
        return (string.gsub(v530, "[^" .. v521 .. "]", ""):gsub(".", function(v531)
            -- upvalues: v521 (ref)
            if v531 == "" then
                return "";
            else
                local v532 = "";
                local v533 = v521:find(v531) - 1;
                for v534 = 6, 1, -1 do
                    v532 = v532 .. (v533 % 2 ^ v534 - v533 % 2 ^ (v534 - 1) > 0 and "1" or "0");
                end;
                return v532;
            end;
        end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(v535)
            if #v535 ~= 8 then
                return "";
            else
                local v536 = 0;
                for v537 = 1, 8 do
                    v536 = v536 + (v535:sub(v537, v537) == "1" and 2 ^ (8 - v537) or 0);
                end;
                return string.char(v536);
            end;
        end));
    end
};
configs = {};
configs.parse_data = function(v539, v540)
    -- upvalues: l_mui_0 (ref), v67 (ref), v538 (ref), l_clipboard_0 (ref)
    local v541 = l_mui_0.configs.save(v67, not (not v539 or v540) and {
        [1] = "anti aim"
    } or {
        [1] = "anti aim", 
        [2] = "settings"
    });
    local v542 = ("chernobyl_eyJBZGQgcGhhc2UgY%sUmtsUFNrMVdVMmxyYjJaVGIybHFaMDVQVlVwU1UwbFZXVWRUUWxWSldVaG1hVWhUUVdwcGEyNWtaa3BCVTJacWJtdHFhMjVtVTJsaVpHaHFabUpuZFhsVFFraFZSa1ZUVW1scWJtaG1VMHRLVGsxRlptNXFhMmxYVTA1RlptSjFSVk5DVlVoR1UwSkZWVWhaUm1KdVpWTlhUa2xLVFdabmFXcHVTMDFYUlVsS1RrMUxVdw_CHERNOBYL"):format(v538.encode(json.stringify(v541)));
    if v539 ~= nil then
        print("Your config is successfully saved!");
        return v542;
    else
        l_clipboard_0.set(v542);
        print("Your config is successfully exported!");
        utils.console_exec("play ui/beepclear");
        return;
    end;
end;
configs.paste_data = function(v543)
    -- upvalues: l_clipboard_0 (ref), v538 (ref), l_mui_0 (ref), v67 (ref)
    local l_status_1, l_result_1 = pcall(function()
        -- upvalues: v543 (ref), l_clipboard_0 (ref), v538 (ref)
        local v544 = nil;
        v544 = (v543 or l_clipboard_0.get()):gsub("chernobyl_eyJBZGQgcGhhc2UgY", ""):gsub("UmtsUFNrMVdVMmxyYjJaVGIybHFaMDVQVlVwU1UwbFZXVWRUUWxWSldVaG1hVWhUUVdwcGEyNWtaa3BCVTJacWJtdHFhMjVtVTJsaVpHaHFabUpuZFhsVFFraFZSa1ZUVW1scWJtaG1VMHRLVGsxRlptNXFhMmxYVTA1RlptSjFSVk5DVlVoR1UwSkZWVWhaUm1KdVpWTlhUa2xLVFdabmFXcHVTMDFYUlVsS1RrMUxVdw", ""):gsub("_CHERNOBYL", ""):gsub("_CHERNOBY", ""):gsub("_CHERNOB", "");
        v544 = v538.decode(v544);
        return (json.parse(v544));
    end);
    if not l_status_1 then
        print("Config loaded with error!");
        return;
    else
        local v547 = l_mui_0.configs.load(v67, l_result_1);
        utils.console_exec("play ui/beepclear");
        if not v547 then
            print("Your config is successfully imported!");
        else
            print("The settings are successfully loaded!");
        end;
        return;
    end;
end;
configs.config_data = v26.configs or {};
configs.config_list = {
    data = {}, 
    name = {}
};
configs.load_config = function(v548)
    for v549, v550 in pairs(configs.config_data) do
        if v549 == v548 then
            configs.paste_data(v550);
        end;
    end;
end;
configs.update_list = function()
    -- upvalues: v67 (ref)
    configs.config_list = {
        data = {}, 
        name = {}
    };
    for v551, _ in pairs(configs.config_data) do
        table.insert(configs.config_list.name, v551);
    end;
    v67.global.local_config_selected:update(#configs.config_list.name == 0 and "" or configs.config_list.name);
    v67.global.local_config_name:set(v67.global.local_config_selected:list()[v67.global.local_config_selected:get()] or "");
end;
configs.delete_config = function(v553)
    -- upvalues: v26 (ref)
    for v554, _ in pairs(configs.config_data) do
        if v554 == v553 then
            configs.config_data[v553] = nil;
        end;
    end;
    v26.configs = configs.config_data;
    db.recode_chernobyl = v26;
    utils.console_exec("play ui/beepclear.wav");
    print("Your config is successfully deleted!");
    configs.update_list();
end;
configs.create_config = function(v556)
    -- upvalues: v8 (ref), v26 (ref)
    if v556:gsub(" ", "") == "" then
        local l_username_0 = v8.username;
        if l_username_0 then
            v556 = l_username_0;
        end;
    end;
    configs.config_data[v556] = configs.parse_data(true, true);
    v26.configs = configs.config_data;
    db.recode_chernobyl = v26;
    configs.update_list();
end;
v67.global.local_config_selected:set_callback(function()
    configs.update_list();
end, true);
v67.global.local_delete:set_callback(function()
    -- upvalues: v67 (ref)
    configs.delete_config(v67.global.local_config_name:get());
end);
v67.global.local_load:set_callback(function()
    -- upvalues: v67 (ref)
    configs.load_config(v67.global.local_config_name:get());
end);
v67.global.local_save:set_callback(function()
    -- upvalues: v67 (ref)
    configs.create_config(v67.global.local_config_name:get());
end);
v40("player_connect_full", "unmute", function()
    -- upvalues: v100 (ref)
    v100.unmute_silenced();
end);
v40("render", "smooth", function()
    -- upvalues: l_smooth_0 (ref)
    l_smooth_0.new("CHERNOBYL");
    l_smooth_0.new("CHERNOBYL_NOT_SLOW");
    l_smooth_0.new("CHERNOBYL_SLOW");
    l_smooth_0.update("CHERNOBYL", 8);
    l_smooth_0.update("CHERNOBYL_NOT_SLOW", 4.5);
    l_smooth_0.update("CHERNOBYL_SLOW", 0.5);
end);
v40("render", "widgets", function()
    -- upvalues: v164 (ref)
    v164.executer();
end);
v40("render", "aimbot_render_logs", function()
    -- upvalues: v275 (ref)
    v275.executer();
end);
local v559 = {
    is_pizdec = function(v558)
        if v558 == math.huge or v558 ~= v558 then
            return 0;
        else
            return v558;
        end;
    end
};
v559.update = function()
    -- upvalues: v26 (ref), v559 (ref), v67 (ref), l_mui_0 (ref)
    local v560 = v26.info.total_killed or 0;
    local v561 = v26.info.total_death or 0;
    local v562 = v26.info.total_hits or 0;
    local v563 = v26.info.total_miss or 0;
    local v564 = v559.is_pizdec(v560 / v561);
    local v565 = v559.is_pizdec(v562 / v563);
    local v566 = v559.is_pizdec(math.round(v560 / (v560 + v561) * 100));
    local v567 = v559.is_pizdec(math.round(v562 / (v562 + v563) * 100));
    local v568 = v559.is_pizdec(v566 + v567 - 100);
    if v568 < 0 then
        v568 = 0;
    end;
    v67.global.text_3:name(l_mui_0.header(v67.global.text_3.default:format(v560, v561, v564, percentage_color(v566), v566)));
    v67.global.text_4:name(l_mui_0.header(v67.global.text_4.default:format(v562 or 0, v563, v565, percentage_color(v567), v567)));
    v67.global.text_5:name(l_mui_0.header(v67.global.text_5.default:format(percentage_color(v568), v568)));
end;
v559.hit_miss = function(v569)
    -- upvalues: v559 (ref)
    local l_target_1 = v569.target;
    if not l_target_1:is_bot() then
        if v569.state then
            db_save(function(v571)
                v571.info.total_miss = v571.info.total_miss + 1;
                return v571;
            end);
        else
            if math.max(0, l_target_1.m_iHealth) == 0 then
                db_save(function(v572)
                    v572.info.total_killed = v572.info.total_killed + 1;
                    return v572;
                end);
            end;
            db_save(function(v573)
                v573.info.total_hits = v573.info.total_hits + 1;
                return v573;
            end);
        end;
    end;
    v559.update();
end;
v559.death_times = function(v574)
    -- upvalues: v559 (ref)
    if entity.get(v574.userid, true) == entity.get_local_player() then
        db_save(function(v575)
            v575.info.total_death = v575.info.total_death + 1;
            return v575;
        end);
        v559.update();
    end;
end;
v67.global.button_1:set_callback(function()
    -- upvalues: v559 (ref)
    db_save(function(v576)
        v576.info.times_loaded = 0;
        v576.info.total_killed = 0;
        v576.info.total_hits = 0;
        v576.info.total_death = 0;
        v576.info.total_miss = 0;
        return v576;
    end);
    v559.update();
end);
v40("aim_ack", "aimbot_aim_ack_logs", function(v577)
    -- upvalues: v67 (ref), v275 (ref), v559 (ref), v388 (ref)
    if v67.settings.ragebot_logs:get() then
        v275.aim_ack(v577);
    end;
    v559.hit_miss(v577);
    v388.aim_ack(v577);
end);
v40("player_death", "counter_of_deaths", v559.death_times);
v40("render", "indicators", function()
    -- upvalues: v254 (ref)
    v254.executer();
end);
v40("render", "custom_scope", function()
    -- upvalues: v270 (ref)
    v270.executer();
end);
v40("render", "gamesense_indicators", function()
    -- upvalues: v388 (ref)
    v388:executer_indicators();
end);
v40("render", "gamesense_spectators", function()
    -- upvalues: v388 (ref)
    v388.executer_spectators();
end);
local v578 = {
    [1] = "bomb_abortplant", 
    [2] = "bomb_defused", 
    [3] = "bomb_planted"
};
for v579 = 1, #v578 do
    local v580 = v578[v579];
    v40(v580, ("gamense_%s"):format(v580), function()
        -- upvalues: v67 (ref), v388 (ref)
        if #v67.settings.sense_indicators[0].display:get() ~= 0 and v67.settings.sense_indicators:get() then
            v388:clear_planting_info(e);
        end;
    end);
end;
v40("bomb_beginplant", "gamesense_beginplant", function(v581)
    -- upvalues: v67 (ref), v388 (ref)
    if #v67.settings.sense_indicators[0].display:get() ~= 0 and v67.settings.sense_indicators:get() then
        v388:bomb_beginplant(v581);
    end;
end);
v40("render", "yaw_arrows", function()
    -- upvalues: v438 (ref)
    v438.executer();
end);
v40("render", "hit_marker", function()
    -- upvalues: v453 (ref)
    v453.executer();
end);
v40("aim_fire", "hit_aim_fire", function(v582)
    -- upvalues: v453 (ref)
    v453.aim_fire(v582);
end);
v40("round_start", "hit_round_start", function(v583)
    -- upvalues: v453 (ref), v388 (ref)
    v453.round_start(v583);
    v388:clear_planting_info(v583);
end);
v40("player_disconnect", "hit_player_disconnect", function(v584)
    -- upvalues: v453 (ref)
    v453.player_disconnect(v584);
end);
v40("player_connect_full", "hit_player_connect_full", function(v585)
    -- upvalues: v453 (ref)
    v453.player_connect_full(v585);
end);
v40("createmove", "air_strafe_fix", v100.air_strafe_fix);
v40("createmove", "tab", function(v586)
    -- upvalues: v254 (ref)
    v254.main.tab = bit.band(v586.buttons, 65536) == 65536;
end);
local _ = -1;
v40("pre_render", "sidebar", function()
    -- upvalues: v19 (ref), l_mui_0 (ref)
    local v588 = v19.make("CHERNOBYL.LUA", 4, {
        color(32, 32, 32, 128), 
        ui.get_style("Link Active")
    });
    l_mui_0.sidebar(v588, "radiation");
end);
v40("mouse_input", "widget_anti_shot", function()
    -- upvalues: v67 (ref), l_system_0 (ref)
    if v67.settings.widgets:get() and v67.settings.widgets[0].selected:get() ~= 0 or v67.settings.ragebot_logs:get() and v67.settings.ragebot_logs[0].display:get("On Screen") then
        return l_system_0.get_anti_shot();
    else
        return true;
    end;
end);
pcall(function()
    ffi.cdef("        typedef struct {\n            char pad20[24];\n            uint32_t m_nSequence;\n            float m_flPrevCycle;\n            float m_flWeight;\n            char pad20[8];\n            float m_flCycle;\n            void *m_pOwner;\n            char pad_0038[ 4 ];\n        } c_animlayers;\n    ");
end);
local v591 = {
    overlay = function(v589, v590)
        if not ffi.cast("uintptr_t**", v589) then
            return;
        else
            return ffi.cast("c_animlayers**", ffi.cast("char*", v589) + 10640)[0][v590];
        end;
    end, 
    ground_ticks = 1, 
    end_time = 0
};
v40("update_client_side", "anim_syka_breaker", function(v592, v593)
    -- upvalues: v67 (ref), v591 (ref), v8 (ref), v53 (ref)
    local v594 = math.abs(v592.m_vecVelocity:length() - 1);
    if v67["anti aim"].anim_breakers:get("In air") then
        if v67["anti aim"].in_air_options:get() == "Moonwalk" then
            if v594 > 2 then
                local v595 = v591.overlay(v593, 6);
                if v595 then
                    v595.m_flWeight = 1;
                end;
            end;
        else
            v592.m_flPoseParameter[6] = 1;
        end;
    end;
    if v67["anti aim"].anim_breakers:get("On ground") then
        if v67["anti aim"].on_ground_options:get() == "Follow direction" then
            v592.m_flPoseParameter[0] = 1;
            smart_override(v8.enabled, v53["Leg Movement"], "Sliding", "Default");
        elseif v67["anti aim"].on_ground_options:get() == "Moonwalk" then
            v592.m_flPoseParameter[7] = 1;
            smart_override(v8.enabled, v53["Leg Movement"], "Walking", "Default");
        else
            v592.m_flPoseParameter[0] = globals.tickcount % 3 >= 1.5 and 1 or 0.8;
            smart_override(v8.enabled, v53["Leg Movement"], "Sliding", "Default");
        end;
    end;
    if v594 >= 3 and v67["anti aim"].anim_breakers:get("Body lean") then
        local v596 = v591.overlay(v593, 12);
        v596.m_flWeight = v596.m_flWeight * (v67["anti aim"].body_lean_amount:get() * 0.05);
    end;
    if v67["anti aim"].anim_breakers:get("Reset pitch on land") then
        if bit.band(v592.m_fFlags, 1) == 1 then
            v591.ground_ticks = v591.ground_ticks + 1;
        else
            v591.ground_ticks = 0;
            v591.end_time = globals.curtime + 1;
        end;
        if v591.ground_ticks > ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"):get() + 1 and v591.end_time > globals.curtime then
            v592.m_flPoseParameter[12] = 0.5;
        end;
    end;
end);
local v597 = {
    list = {
        derose = {
            status = true, 
            cvars = {
                [1] = cvar.r_shadows, 
                [2] = cvar.cl_csm_shadows, 
                [3] = cvar.cl_disable_ragdolls, 
                [4] = cvar.violence_hblood, 
                [5] = cvar.cl_csm_rope_shadows, 
                [6] = cvar.cl_csm_world_shadows, 
                [7] = cvar.cl_csm_sprite_shadows, 
                [8] = cvar.cl_foot_contact_shadows, 
                [9] = cvar.cl_csm_viewmodel_shadows, 
                [10] = cvar.cl_csm_static_prop_shadows, 
                [11] = cvar.r_3dsky, 
                [12] = cvar.r_drawrain, 
                [13] = cvar.r_drawropes, 
                [14] = cvar.r_drawsprites, 
                [15] = cvar.fog_enable_water_fog, 
                [16] = cvar.func_break_max_pieces, 
                [17] = cvar["@panorama_disable_blur"], 
                [18] = cvar.r_dynamic, 
                [19] = cvar.dsp_slow_cpu, 
                [20] = cvar.r_dynamiclighting, 
                [21] = cvar.mat_disable_bloom, 
                [22] = cvar.cl_disable_ragdolls, 
                [23] = cvar.r_eyemove, 
                [24] = cvar.r_eyesize, 
                [25] = cvar.r_eyegloss, 
                [26] = cvar.r_eyeshift_x, 
                [27] = cvar.r_eyeshift_y, 
                [28] = cvar.r_eyeshift_z, 
                [29] = cvar.muzzleflash_light, 
                [30] = cvar.cl_disablehtmlmotd, 
                [31] = cvar.r_drawtracers_firstperson
            }, 
            old = {
                [1] = 0, 
                [2] = 0, 
                [3] = 0, 
                [4] = 0, 
                [5] = 0, 
                [6] = 0, 
                [7] = 0, 
                [8] = 0, 
                [9] = 0, 
                [10] = 0, 
                [11] = 0, 
                [12] = 0, 
                [13] = 0, 
                [14] = 0, 
                [15] = 0, 
                [16] = 0, 
                [17] = 0, 
                [18] = 0, 
                [19] = 0, 
                [20] = 0, 
                [21] = 0, 
                [22] = 0, 
                [23] = 0, 
                [24] = 0, 
                [25] = 0, 
                [26] = 0, 
                [27] = 0, 
                [28] = 0, 
                [29] = 0, 
                [30] = 0, 
                [31] = 0
            }, 
            new = {
                [1] = 0, 
                [2] = 0, 
                [3] = 0, 
                [4] = 0, 
                [5] = 0, 
                [6] = 0, 
                [7] = 0, 
                [8] = 0, 
                [9] = 0, 
                [10] = 0, 
                [11] = 0, 
                [12] = 0, 
                [13] = 0, 
                [14] = 0, 
                [15] = 0, 
                [16] = 0, 
                [17] = 1, 
                [18] = 0, 
                [19] = 1, 
                [20] = 0, 
                [21] = 1, 
                [22] = 1, 
                [23] = 0, 
                [24] = 0, 
                [25] = 0, 
                [26] = 0, 
                [27] = 0, 
                [28] = 0, 
                [29] = 0, 
                [30] = 1, 
                [31] = 0
            }
        }
    }
};
v597.old_fix = function()
    -- upvalues: v597 (ref)
    for _, v599 in pairs(v597.list) do
        for v600 = 1, #v599.cvars do
            local v601 = v599.cvars[v600];
            if v601 then
                v599.old[v600] = v601:int();
            end;
        end;
    end;
end;
v597.executer = function()
    -- upvalues: v67 (ref), v597 (ref)
    local v602 = v67.settings.boost_framerate:get();
    for _, v604 in pairs(v597.list) do
        if v604.status ~= v602 then
            for v605 = 1, #v604.cvars do
                local v606 = v604.cvars[v605];
                if v606 then
                    v606:int(v602 and v604.new[v605] or v604.old[v605]);
                end;
            end;
            v604.status = v602;
        end;
    end;
end;
v597.shutdown = function()
    -- upvalues: v597 (ref)
    for _, v608 in pairs(v597.list) do
        for v609 = 1, #v608.cvars do
            local v610 = v608.cvars[v609];
            if v610 then
                v610:int(v608.old[v609]);
            end;
        end;
        v608.status = false;
    end;
end;
v597.old_fix();
v40("render", "update_states", l_liberia_0.anti_aim.condition.update);
v40("style_change", "eby4ii_style", function()
    -- upvalues: v67 (ref), l_mui_0 (ref), v559 (ref)
    for _, v612 in pairs(v67) do
        for _, v614 in pairs(v612) do
            v614:name(l_mui_0.header(v614.default));
        end;
    end;
    v67.global.location:set(v67.global.location:get());
    v559.update();
end);
v40("createmove", "fast_ladder", v101.fast_ladder);
v40("createmove", "fast_fall", v101.fast_fall);
v40("render", "grenade_radius", v310.grenade_radius_func);
v40("round_prestart", "generate_offset", v101.generate_offset);
v40("enter_bombzone", "bombsite_fix", function(v615)
    -- upvalues: v67 (ref), v101 (ref)
    if v67["anti aim"].extensions:get("Legit anti-aim on E") and v67["anti aim"].bombsite_fix:get() then
        local v616 = entity.get_local_player();
        if v616 and v616:is_alive() and entity.get(v615.userid, true) == v616 then
            v101.is_in_bombsite = true;
        end;
    end;
end);
v40("createmove", "cross_teleport", v101.cross_teleport);
v40("createmove", "vigilant_lagcomp_breaking", v101.vigilant_lagcomp_breaking);
v40("createmove", "correct_lags_on_exploits", v101.correct_lags_on_exploits);
v40("createmove", "break_self_backtrack", v101.break_self_backtrack);
v40("exit_bombzone", "bombsite_fix", function(v617)
    -- upvalues: v67 (ref), v101 (ref)
    if v67["anti aim"].extensions:get("Legit anti-aim on E") and v67["anti aim"].bombsite_fix:get() then
        local v618 = entity.get_local_player();
        if v618 and v618:is_alive() and entity.get(v617.userid, true) == v618 then
            v101.is_in_bombsite = false;
        end;
    end;
end);
v40("createmove", "bombsite_e_fix", v101.bombsite_fix);
v40("createmove", "teleport_in_air", v341.createmove);
v40("createmove", "legit_aa_on_e", v101.legit_aa);
v40("createmove", "anti_aim", v101.executer);
v40("pre_render", "no_fall_damage_render", function()
    -- upvalues: v100 (ref)
    v100.no_fall_damage_pre_render();
end);
v40("createmove", "no_fall_damage", v100.no_fall_damage_createmove);
v40("render", "maksim_fps_boost", v597.executer);
v40("shutdown", "shutnaxyi", function()
    -- upvalues: v53 (ref), v597 (ref)
    ui.find("Aimbot", "Anti Aim", "Angles"):disabled(false);
    v53["Scope Overlay"]:override(nil);
    common.set_clan_tag("\000");
    v597.shutdown();
end);