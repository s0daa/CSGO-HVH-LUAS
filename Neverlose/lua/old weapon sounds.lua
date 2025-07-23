-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local l_manager_0 = require("neverlose/file_manager");
local v1 = ffi.cast("void**", utils.opcode_scan("client.dll", "8B 35 CC CC CC CC FF 10 0F B7 C0", 2))[0];
local v2 = utils.get_vfunc(2, "void*(__thiscall*)(void*, unsigned int)");
local v3 = panorama.loadstring("    return {\n        localize: (str) => {\n            return $.Localize(str)\n        }\n    }\n", "CSGOMainMenu")();
local v4 = 0;
local v5 = common.get_game_directory() .. "/sound/";
local v6 = {
    [40] = {
        ["CS:GO (legacy)"] = "legacy/ssg08.wav", 
        CS2 = "weapons/ssg08/ssg08_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/ssg08.wav", 
        ["CS:GO"] = {
            [1] = "weapons/ssg08/ssg08_01.wav"
        }
    }, 
    [9] = {
        ["CS:GO (legacy)"] = "legacy/awp.wav", 
        CS2 = "weapons/awp/awp_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/awp.wav", 
        ["CS:GO"] = {
            [1] = "weapons/awp/awp_01.wav", 
            [2] = "weapons/awp/awp_02.wav"
        }
    }, 
    [38] = {
        ["CS:GO (legacy)"] = "legacy/scar20.wav", 
        CS2 = "weapons/scar20/scar20_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/scar20.wav", 
        ["CS:GO"] = {
            [1] = "weapons/scar20/scar20_01.wav", 
            [2] = "weapons/scar20/scar20_02.wav", 
            [3] = "weapons/scar20/scar20_03.wav"
        }
    }, 
    [11] = {
        ["CS:GO (legacy)"] = "legacy/g3sg1.wav", 
        CS2 = "weapons/g3sg1/g3sg1_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/g3sg1.wav", 
        ["CS:GO"] = {
            [1] = "weapons/g3sg1/g3sg1_01.wav", 
            [2] = "weapons/g3sg1/g3sg1_02.wav", 
            [3] = "weapons/g3sg1/g3sg1_03.wav"
        }
    }, 
    [1] = {
        ["CS:GO (legacy)"] = "legacy/deserteagle.wav", 
        CS2 = "weapons/deagle/deagle_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/deserteagle.wav", 
        ["CS:GO"] = {
            [1] = "weapons/deagle/deagle_01.wav", 
            [2] = "weapons/deagle/deagle_02.wav"
        }
    }, 
    [64] = {
        ["CS:GO (legacy)"] = "weapons/revolver/revolver-1_01.wav", 
        CS2 = "weapons/revolver/revolver-1_01.wav", 
        Custom = "", 
        ["CS:Source"] = "weapons/revolver/revolver-1_01.wav", 
        ["CS:GO"] = {
            [1] = "weapons/revolver/revolver-1_01.wav"
        }
    }, 
    [3] = {
        ["CS:GO (legacy)"] = "legacy/fiveseven.wav", 
        CS2 = "weapons/fiveseven/fiveseven_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/fiveseven.wav", 
        ["CS:GO"] = {
            [1] = "weapons/fiveseven/fiveseven_01.wav"
        }
    }, 
    [30] = {
        ["CS:GO (legacy)"] = "legacy/tec9.wav", 
        CS2 = "weapons/tec9/tec9_02.wav", 
        Custom = "", 
        ["CS:Source"] = "css/tec9.wav", 
        ["CS:GO"] = {
            [1] = "weapons/tec9/tec9_02.wav"
        }
    }, 
    [61] = {
        ["CS:GO (legacy)"] = "legacy/usp.wav", 
        CS2 = "weapons/usp/usp_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/usp.wav", 
        ["CS:GO"] = {
            [1] = "weapons/usp/usp_01.wav", 
            [2] = "weapons/usp/usp_02.wav", 
            [3] = "weapons/usp/usp_03.wav"
        }
    }, 
    [4] = {
        ["CS:GO (legacy)"] = "legacy/glock18.wav", 
        CS2 = "cs2/glock18.wav", 
        Custom = "", 
        ["CS:Source"] = "css/glock18.wav", 
        ["CS:GO"] = {
            [1] = "weapons/glock18/glock_01.wav", 
            [2] = "weapons/glock18/glock_02.wav"
        }
    }, 
    [2] = {
        ["CS:GO (legacy)"] = "legacy/elites.wav", 
        CS2 = "weapons/elite/elites_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/elites.wav", 
        ["CS:GO"] = {
            [1] = "weapons/elite/elites_01.wav", 
            [2] = "weapons/elite/elites_02.wav", 
            [3] = "weapons/elite/elites_03.wav", 
            [4] = "weapons/elite/elites_04.wav"
        }
    }, 
    [63] = {
        ["CS:GO (legacy)"] = "legacy/cz75.wav", 
        CS2 = "weapons/cz75a/cz75_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/cz75.wav", 
        ["CS:GO"] = {
            [1] = "weapons/cz75a/cz75_01.wav", 
            [2] = "weapons/cz75a/cz75_02.wav", 
            [3] = "weapons/cz75a/cz75_03.wav"
        }
    }, 
    [32] = {
        ["CS:GO (legacy)"] = "legacy/p2000.wav", 
        CS2 = "weapons/hkp2000/hkp2000_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/p2000.wav", 
        ["CS:GO"] = {
            [1] = "weapons/hkp2000/hkp2000_01.wav", 
            [2] = "weapons/hkp2000/hkp2000_02.wav", 
            [3] = "weapons/hkp2000/hkp2000_03.wav"
        }
    }, 
    [36] = {
        ["CS:GO (legacy)"] = "legacy/p250.wav", 
        CS2 = "weapons/p250/p250_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/p250.wav", 
        ["CS:GO"] = {
            [1] = "weapons/p250/p250_01.wav"
        }
    }, 
    [7] = {
        ["CS:GO (legacy)"] = "legacy/ak47.wav", 
        CS2 = "cs2/ak47.wav", 
        Custom = "", 
        ["CS:Source"] = "css/ak47.wav", 
        ["CS:GO"] = {
            [1] = "weapons/ak47/ak47_01.wav"
        }
    }, 
    [16] = {
        ["CS:GO (legacy)"] = "legacy/m4a4.wav", 
        CS2 = "weapons/m4a1/m4a1_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/m4a4.wav", 
        ["CS:GO"] = {
            [1] = "weapons/m4a1/m4a1_01.wav", 
            [2] = "weapons/m4a1/m4a1_02.wav"
        }
    }, 
    [60] = {
        ["CS:GO (legacy)"] = "legacy/m4a1.wav", 
        CS2 = "weapons/m4a1/m4a1_silencer_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/m4a1.wav", 
        ["CS:GO"] = {
            [1] = "weapons/m4a1/m4a1_silencer_01.wav"
        }
    }, 
    [8] = {
        ["CS:GO (legacy)"] = "legacy/aug.wav", 
        CS2 = "weapons/aug/aug_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/aug.wav", 
        ["CS:GO"] = {
            [1] = "weapons/aug/aug_01.wav", 
            [2] = "weapons/aug/aug_02.wav", 
            [3] = "weapons/aug/aug_03.wav", 
            [4] = "weapons/aug/aug_04.wav"
        }
    }, 
    [39] = {
        ["CS:GO (legacy)"] = "legacy/sg553.wav", 
        CS2 = "weapons/sg556/sg556_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/sg553.wav", 
        ["CS:GO"] = {
            [1] = "weapons/sg556/sg556_01.wav", 
            [2] = "weapons/sg556/sg556_02.wav", 
            [3] = "weapons/sg556/sg556_03.wav", 
            [4] = "weapons/sg556/sg556_04.wav"
        }
    }, 
    [10] = {
        ["CS:GO (legacy)"] = "legacy/famas.wav", 
        CS2 = "cs2/famas.wav", 
        Custom = "", 
        ["CS:Source"] = "css/famas.wav", 
        ["CS:GO"] = {
            [1] = "weapons/famas/famas_01.wav", 
            [2] = "weapons/famas/famas_02.wav", 
            [3] = "weapons/famas/famas_03.wav", 
            [4] = "weapons/famas/famas_04.wav"
        }
    }, 
    [13] = {
        ["CS:GO (legacy)"] = "legacy/galilar.wav", 
        CS2 = "cs2/galilar.wav", 
        Custom = "", 
        ["CS:Source"] = "css/galilar.wav", 
        ["CS:GO"] = {
            [1] = "weapons/galilar/galil_01.wav", 
            [2] = "weapons/galilar/galil_02.wav", 
            [3] = "weapons/galilar/galil_03.wav", 
            [4] = "weapons/galilar/galil_04.wav"
        }
    }, 
    [27] = {
        ["CS:GO (legacy)"] = "legacy/mag7.wav", 
        CS2 = "weapons/mag7/mag7_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/mag7.wav", 
        ["CS:GO"] = {
            [1] = "weapons/mag7/mag7_01.wav", 
            [2] = "weapons/mag7/mag7_02.wav"
        }
    }, 
    [29] = {
        ["CS:GO (legacy)"] = "legacy/sawedoff.wav", 
        CS2 = "weapons/sawedoff/sawedoff-1.wav", 
        Custom = "", 
        ["CS:Source"] = "css/sawedoff.wav", 
        ["CS:GO"] = {
            [1] = "weapons/sawedoff/sawedoff-1.wav"
        }
    }, 
    [25] = {
        ["CS:GO (legacy)"] = "legacy/xm1014.wav", 
        CS2 = "weapons/xm1014/xm1014-1.wav", 
        Custom = "", 
        ["CS:Source"] = "css/xm1014.wav", 
        ["CS:GO"] = {
            [1] = "weapons/xm1014/xm1014-1.wav"
        }
    }, 
    [35] = {
        ["CS:GO (legacy)"] = "legacy/nova.wav", 
        CS2 = "weapons/nova/nova-1.wav", 
        Custom = "", 
        ["CS:Source"] = "css/nova.wav", 
        ["CS:GO"] = {
            [1] = "weapons/nova/nova-1.wav"
        }
    }, 
    [28] = {
        ["CS:GO (legacy)"] = "legacy/negev.wav", 
        CS2 = "weapons/negev/negev_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/negev.wav", 
        ["CS:GO"] = {
            [1] = "weapons/negev/negev_01.wav", 
            [2] = "weapons/negev/negev_02.wav", 
            [3] = "weapons/negev/negev_clean_01.wav", 
            [4] = "weapons/negev/negev_clean_02.wav"
        }
    }, 
    [14] = {
        ["CS:GO (legacy)"] = "legacy/m249.wav", 
        CS2 = "weapons/m249/m249-1.wav", 
        Custom = "", 
        ["CS:Source"] = "css/m249.wav", 
        ["CS:GO"] = {
            [1] = "weapons/m249/m249-1.wav"
        }
    }, 
    [17] = {
        ["CS:GO (legacy)"] = "legacy/mac10.wav", 
        CS2 = "weapons/mac10/mac10_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/mac10.wav", 
        ["CS:GO"] = {
            [1] = "weapons/mac10/mac10_01.wav", 
            [2] = "weapons/mac10/mac10_02.wav"
        }
    }, 
    [19] = {
        ["CS:GO (legacy)"] = "legacy/p90.wav", 
        CS2 = "weapons/p90/p90_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/p90.wav", 
        ["CS:GO"] = {
            [1] = "weapons/p90/p90_01.wav", 
            [2] = "weapons/p90/p90_02.wav"
        }
    }, 
    [23] = {
        ["CS:GO (legacy)"] = "legacy/mp5.wav", 
        CS2 = "weapons/mp5/mp5_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/mp5.wav", 
        ["CS:GO"] = {
            [1] = "weapons/mp5/mp5_01.wav"
        }
    }, 
    [24] = {
        ["CS:GO (legacy)"] = "legacy/ump45.wav", 
        CS2 = "weapons/ump45/ump45_02.wav", 
        Custom = "", 
        ["CS:Source"] = "css/ump45.wav", 
        ["CS:GO"] = {
            [1] = "weapons/ump45/ump45_02.wav"
        }
    }, 
    [26] = {
        ["CS:GO (legacy)"] = "legacy/bizon.wav", 
        CS2 = "weapons/bizon/bizon_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/bizon.wav", 
        ["CS:GO"] = {
            [1] = "weapons/bizon/bizon_01.wav", 
            [2] = "weapons/bizon/bizon_02.wav"
        }
    }, 
    [33] = {
        ["CS:GO (legacy)"] = "legacy/mp7.wav", 
        CS2 = "weapons/mp7/mp7_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/mp7.wav", 
        ["CS:GO"] = {
            [1] = "weapons/mp7/mp7_01.wav", 
            [2] = "weapons/mp7/mp7_02.wav", 
            [3] = "weapons/mp7/mp7_03.wav", 
            [4] = "weapons/mp7/mp7_04.wav"
        }
    }, 
    [34] = {
        ["CS:GO (legacy)"] = "legacy/mp9.wav", 
        CS2 = "weapons/mp9/mp9_01.wav", 
        Custom = "", 
        ["CS:Source"] = "css/mp9.wav", 
        ["CS:GO"] = {
            [1] = "weapons/mp9/mp9_01.wav", 
            [2] = "weapons/mp9/mp9_02.wav", 
            [3] = "weapons/mp9/mp9_03.wav", 
            [4] = "weapons/mp9/mp9_04.wav"
        }
    }
};
local v7 = {
    custom = {
        [1] = "CS2", 
        [2] = "CS:GO", 
        [3] = "CS:GO (legacy)", 
        [4] = "CS:Source", 
        [5] = "Custom"
    }, 
    presets = {
        [1] = "CS2", 
        [2] = "CS:GO (legacy)", 
        [3] = "CS:Source"
    }, 
    converter = {
        ["CS:GO (legacy)"] = 3, 
        ["CS:Source"] = 4, 
        CS2 = 1
    }
};
local v8 = {
    [1] = 40, 
    [2] = 9, 
    [3] = 38, 
    [4] = 11, 
    [5] = 1, 
    [6] = 64, 
    [7] = 3, 
    [8] = 30, 
    [9] = 61, 
    [10] = 4, 
    [11] = 2, 
    [12] = 63, 
    [13] = 32, 
    [14] = 36, 
    [15] = 7, 
    [16] = 16, 
    [17] = 60, 
    [18] = 8, 
    [19] = 39, 
    [20] = 10, 
    [21] = 13, 
    [22] = 27, 
    [23] = 29, 
    [24] = 25, 
    [25] = 35, 
    [26] = 28, 
    [27] = 14, 
    [28] = 17, 
    [29] = 19, 
    [30] = 23, 
    [31] = 24, 
    [32] = 26, 
    [33] = 33, 
    [34] = 34
};
local v9 = {};
local v10 = {
    yellow = "\aB6B665FF", 
    red = "\aB33A3AFF", 
    default = "\aDEFAULT", 
    primary = "\a" .. ui.get_style("Link Active"):to_hex(), 
    disabled = "\a" .. ui.get_style("Disabled Text"):to_hex()
};
local v14 = setmetatable({}, {
    __index = function(v11, v12)
        local v13 = ui.get_icon(v12);
        rawset(v11, v12, v13);
        return v13;
    end
});
local v15 = {
    main = {
        group = ui.create("\n", 1)
    }
};
v15.main.master_switch = v15.main.group:switch("Enabled");
v15.main.download_progress = v15.main.group:slider("downloading", 0, 100, 0, 1, "%"):disabled(true);
v15.main.actions = v15.main.master_switch:create():label("actions"):disabled(true);
v15.main.discord_button = v15.main.master_switch:create():button("", nil, true):tooltip("\226\139\133 Join the community discord.");
v15.main.folder_button = v15.main.master_switch:create():button("", nil, true):tooltip("\226\139\133 Open the folder location where you can put custom sound files.");
v15.main.download_button = v15.main.master_switch:create():button("", nil, true):tooltip("\226\139\133 Manually start the download of all preset sounds." .. "\n\n" .. v10.yellow .. v14["circle-exclamation-check"] .. "  If its not working, enable a VPN.");
v15.main.debug_mode = v15.main.master_switch:create():switch(v10.yellow .. v14.code .. v10.default .. "   Debug mode"):disabled(true);
v15.mode = {
    group = ui.create("Mode", 1)
};
v15.mode.sound_mode = v15.mode.group:list("", {
    [1] = v14.cloud .. v10.default .. "   Presets", 
    [2] = v14.gears .. v10.default .. "   Custom builder"
});
v15.preset_style = {
    group = ui.create("Style", 2)
};
v15.preset_style.sound_style = v15.preset_style.group:list("", v7.presets);
v15.preset_volume = {
    group = ui.create("Volume", 2)
};
v15.preset_volume.volume_slider = v15.preset_volume.group:slider("", 10, 101, 101, 1, function(v16)
    return v16 == 101 and "Auto." or v16 .. "%";
end);
v15.custom_builder = {
    group = ui.create("Weapons", 2)
};
v15.custom_builder.weapon_selector = v15.custom_builder.group:list("", v9);
v15.custom_builder.weapon_options = {
    text = v15.custom_builder.group:label("")
};
v15.custom_builder.weapon_options.style = v15.custom_builder.weapon_options.text:create():list("", v7.custom);
v15.custom_builder.weapon_options.filepath = v15.custom_builder.weapon_options.text:create():input("", "weapons/awp/awp_distant.wav"):tooltip("\226\139\133 Enter the relative path to your custom sound file, which must be placed inside the \"csgo/sound/\" folder." .. "\n\n\aB6B665FF" .. v14["lightbulb-exclamation-on"] .. "  Please note that only the .wav filetype is supported.");
v15.custom_builder.weapon_options.volume = v15.custom_builder.weapon_options.text:create():slider("Volume", 10, 101, 101, 1, function(v17)
    return v17 == 101 and "Auto." or v17 .. "%";
end);
v15.configuration = {
    group = ui.create("config_information"):visibility(false)
};
for _, v19 in ipairs(v8) do
    v15.configuration[v19] = {
        style = v15.configuration.group:list("", v7.custom), 
        filepath = v15.configuration.group:input("", "weapons/awp/awp_distant.wav"), 
        volume = v15.configuration.group:slider("Volume", 10, 101, 101, 1)
    };
end;
v15.custom_builder.weapon_options.style:set_callback(function(v20)
    -- upvalues: v15 (ref), v8 (ref)
    local v21 = v8[v15.custom_builder.weapon_selector:get()];
    v15.configuration[v21].style:set(v20:get());
end, true);
v15.custom_builder.weapon_options.filepath:set_callback(function(v22)
    -- upvalues: v15 (ref), v8 (ref), v6 (ref)
    local v23 = v8[v15.custom_builder.weapon_selector:get()];
    v15.configuration[v23].filepath:set(v22:get());
    v6[v23].Custom = v22:get();
end, true);
v15.custom_builder.weapon_options.volume:set_callback(function(v24)
    -- upvalues: v15 (ref), v8 (ref)
    local v25 = v8[v15.custom_builder.weapon_selector:get()];
    v15.configuration[v25].volume:set(v24:get());
end, true);
v15.custom_builder.weapon_selector:set_callback(function(v26)
    -- upvalues: v8 (ref), v15 (ref)
    local v27 = v8[v26:get()];
    v15.custom_builder.weapon_options.style:set(v15.configuration[v27].style:get());
    v15.custom_builder.weapon_options.filepath:set(v15.configuration[v27].filepath:get());
    v15.custom_builder.weapon_options.volume:set(v15.configuration[v27].volume:get());
end, true);
local function v32(v28, v29)
    for _, v31 in ipairs(v28) do
        if v29:find(v31, 1, true) then
            return true;
        end;
    end;
    return false;
end;
local function v51(v33, v34, v35)
    local l_r_0 = v33.r;
    local l_g_0 = v33.g;
    local l_b_0 = v33.b;
    local l_a_0 = v33.a;
    local l_r_1 = v34.r;
    local l_g_1 = v34.g;
    local l_b_1 = v34.b;
    local l_a_1 = v34.a;
    local v44 = "";
    local v45 = #v35 - 1;
    local v46 = (l_r_1 - l_r_0) / v45;
    local v47 = (l_g_1 - l_g_0) / v45;
    local v48 = (l_b_1 - l_b_0) / v45;
    local v49 = (l_a_1 - l_a_0) / v45;
    for v50 = 1, v45 + 1 do
        v44 = v44 .. ("\a%02x%02x%02x%02x%s"):format(l_r_0, l_g_0, l_b_0, l_a_0, v35:sub(v50, v50));
        l_r_0 = l_r_0 + v46;
        l_g_0 = l_g_0 + v47;
        l_b_0 = l_b_0 + v48;
        l_a_0 = l_a_0 + v49;
    end;
    return v44;
end;
local function v64(v52, v53, v54, v55)
    if not v52:visibility() then
        return;
    else
        local v56 = "\001";
        local v57 = v52:list();
        local v58 = v55 or v52:get();
        if v57[v58] == nil then
            return;
        else
            local v59 = {};
            for v60, v61 in pairs(v57) do
                local v62 = v61:find(v56, 1, true);
                local v63 = v62 and v61:sub(v62 + #v56) or v61;
                if v60 == v58 then
                    v59[v60] = v53 .. v56 .. v63;
                elseif v54 then
                    v59[v60] = v54 .. v56 .. v63;
                else
                    v59[v60] = v63;
                end;
            end;
            v52:update(v59);
            return;
        end;
    end;
end;
local function v65(v66)
    -- upvalues: v4 (ref), v5 (ref), l_manager_0 (ref), v10 (ref), v14 (ref), v65 (ref)
    if not v66 then
        v66 = 1;
    end;
    v4 = v66;
    if v66 == 1 then
        common.add_notify("Custom Weapon Sounds", "Download started");
    end;
    if v66 == 91 then
        files.create_folder(v5);
        l_manager_0.download("https://gitlab.com/mogel/misc/-/raw/main/weapon-sounds.zip", v5 .. "temp.zip");
        l_manager_0.extract(v5 .. "temp.zip", v5);
        l_manager_0.delete(v5 .. "temp.zip");
        v66 = 100;
        v4 = 100;
        cvar.snd_restart:call();
    end;
    if v66 == 100 then
        if not l_manager_0.exists(v5 .. "cs2/ak47.wav") and not l_manager_0.exists(v5 .. "legacy/ak47.wav") and not l_manager_0.exists(v5 .. "css/ak47.wav") then
            common.add_notify("Custom Weapon Sounds", v10.red .. v14["triangle-exclamation"] .. v10.default .. "  Download failed, try using a VPN");
        else
            common.add_notify("Custom Weapon Sounds", v10.primary .. v14["badge-check"] .. v10.default .. "  Download completed");
        end;
        utils.execute_after(3.25, function()
            -- upvalues: v4 (ref)
            v4 = 0;
        end);
        return;
    else
        utils.execute_after(0.15, function()
            -- upvalues: v65 (ref), v66 (ref)
            v65(v66 + 1);
        end);
        return;
    end;
end;
local function v74()
    -- upvalues: v15 (ref), v7 (ref), v8 (ref)
    local v67 = nil;
    local v68 = nil;
    if v15.mode.sound_mode:get() == 1 then
        local v69 = v15.preset_style.sound_style:get();
        local v70 = v15.preset_volume.volume_slider:get();
        v67 = v7.converter[v7.presets[v69]];
        v68 = v70;
    end;
    for _, v72 in ipairs(v8) do
        local v73 = v15.configuration[v72];
        v73.style:override(v67);
        v73.volume:override(v68);
    end;
end;
local function v87()
    -- upvalues: v10 (ref), v51 (ref), v15 (ref), v4 (ref), v64 (ref), v14 (ref), v9 (ref), v8 (ref), v7 (ref)
    if ui.get_alpha() > 0 then
        local v75 = ui.get_style("Link Active");
        local v76 = ui.get_style("Sidebar Text");
        local v77 = ui.get_style("Disabled Text");
        v10.primary = "\a" .. v75:to_hex();
        v10.disabled = "\a" .. v77:to_hex();
        ui.sidebar(v51(v75, v76, "Weapon Sounds"), "waveform-lines");
        local v78 = v15.main.master_switch:get() and v4 == 0;
        local v79 = v15.mode.sound_mode:get();
        v64(v15.mode.sound_mode, v10.primary, v10.disabled);
        v15.mode.group:name(v10.primary .. v14.option .. v10.default .. "  Mode");
        v15.main.actions:name(v10.primary .. v14["screwdriver-wrench"] .. "  " .. v10.default .. "  Actions");
        v15.main.discord_button:name("  " .. v10.primary .. v14.discord .. "  ");
        v15.main.folder_button:name("  " .. v10.primary .. v14["folder-open"] .. "  ");
        v15.main.download_button:name("  " .. v10.primary .. v14.download .. "  ");
        v15.preset_style.group:visibility(v79 == 1);
        v15.preset_volume.group:visibility(v79 == 1);
        v15.custom_builder.group:visibility(v79 == 2);
        v15.main.download_button:disabled(v4 ~= 0);
        v15.main.download_progress:name(v10.primary .. v14.spinner .. v10.default .. "  downloading");
        v15.main.download_progress:visibility(v4 ~= 0);
        v15.main.download_progress:set(v4);
        if v79 == 1 then
            v15.preset_style.group:name(v10.primary .. v14["bars-staggered"] .. v10.default .. "  Style");
            v15.preset_volume.group:name(v10.primary .. v14["volume-high"] .. v10.default .. "  Volume");
            v64(v15.preset_style.sound_style, v10.primary .. "\226\128\162  " .. v10.default);
        else
            v15.custom_builder.group:name(v10.primary .. v14.gun .. v10.default .. "  Weapons");
            v64(v15.custom_builder.weapon_options.style, v10.primary .. "\226\128\162  " .. v10.default);
            local l_weapon_selector_0 = v15.custom_builder.weapon_selector;
            local v81 = v9[l_weapon_selector_0:get()];
            v15.custom_builder.weapon_options.text:name(v10.primary .. v14["pen-to-square"] .. v10.default .. "   Configure selected");
            v15.custom_builder.weapon_options.style:name(v10.primary .. v14["caret-right"] .. v10.default .. "  " .. v81);
            v15.custom_builder.weapon_options.filepath:visibility(v15.custom_builder.weapon_options.style:get() == 5);
            v15.custom_builder.weapon_options.volume:visibility(v15.custom_builder.weapon_options.style:get() ~= 2);
            local v82 = {};
            for v83, v84 in ipairs(v9) do
                local v85 = v8[v83];
                local v86 = v15.configuration[v85].style:get();
                if v86 ~= 2 then
                    v82[v83] = v84 .. v10.disabled .. "  \226\128\162  " .. v10.primary .. v7.custom[v86];
                else
                    v82[v83] = v84;
                end;
            end;
            l_weapon_selector_0:update(v82);
        end;
        v15.mode.sound_mode:disabled(not v78);
        v15.preset_style.sound_style:disabled(not v78);
        v15.preset_volume.volume_slider:disabled(not v78);
        v15.custom_builder.weapon_selector:disabled(not v78);
        v15.custom_builder.weapon_options.text:disabled(not v78);
    end;
end;
for v88, v89 in ipairs(v8) do
    local v90 = v2(v1, v89);
    if v90 ~= nil then
        local v91 = ffi.cast("char**", ffi.cast("char*", v90) + 136)[0];
        if v91 ~= nil then
            local v92 = ffi.string(v91);
            v9[v88] = v3.localize(v92) or " ";
        end;
    end;
end;
v15.main.discord_button:set_callback(function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.com/invite/kapPFV2zhd");
end);
v15.main.folder_button:set_callback(function()
    -- upvalues: l_manager_0 (ref), v5 (ref)
    l_manager_0.open(v5);
end);
v15.main.download_button:set_callback(function()
    -- upvalues: v65 (ref)
    v65();
end);
v15.main.master_switch:set_callback(function(v93)
    -- upvalues: v4 (ref), l_manager_0 (ref), v5 (ref), v65 (ref)
    if v93:get() and v4 == 0 and not l_manager_0.exists(v5 .. "cs2/ak47.wav") and not l_manager_0.exists(v5 .. "legacy/ak47.wav") and not l_manager_0.exists(v5 .. "css/ak47.wav") then
        v65();
    end;
end, true);
events.pre_render(v74);
events.render(v87);
events.emit_sound:set(function(v94)
    -- upvalues: v15 (ref), v4 (ref), v6 (ref), v32 (ref), v7 (ref)
    if not v15.main.master_switch:get() or v4 ~= 0 then
        return;
    else
        local v95 = entity.get_local_player();
        if not v95 then
            return;
        elseif v94.entity ~= v95 then
            return;
        else
            local v96 = v95:get_player_weapon();
            if not v96 then
                return;
            else
                local v97 = v96:get_weapon_index();
                if not v15.configuration[v97] then
                    return;
                else
                    local v98 = v15.configuration[v97].style:get_override() or v15.configuration[v97].style:get();
                    local v99 = v15.configuration[v97].filepath:get();
                    local v100 = v15.configuration[v97].volume:get_override() or v15.configuration[v97].volume:get();
                    if v98 ~= 2 then
                        local v101 = v6[v97];
                        if v101 and v32(v101["CS:GO"], v94.sound_name) then
                            local v102 = v98 == 5 and v99 or v101[v7.custom[v98]];
                            if v102 then
                                local l_volume_0 = v94.volume;
                                local v104 = v100 == 101 and l_volume_0 or v100 / 100;
                                v94.volume = 0;
                                cvar.playvol:call(v102, v104);
                            end;
                        end;
                    end;
                    return;
                end;
            end;
        end;
    end;
end);
events.config_state:set(function(_)
    config_loaded = true;
end);
if not config_loaded then
    for _, v107 in ipairs(v8) do
        v15.configuration[v107].style:set(2);
    end;
    v15.preset_style.sound_style:set(2);
    v15.custom_builder.weapon_options.style:set(2);
end;