local pui = require("gamesense/pui")
local color = require("gamesense/color")
local vector = require("vector")

local group = pui.group("AA", "Anti-aimbot angles")

local tabs = {"Settings", "Antiaims", "Configs"}

local refs = {
    aa = {
        pitch = pui.reference("AA", "Anti-aimbot angles", "Pitch"),
        pitch_val = select(2, pui.reference("AA", "Anti-aimbot angles", "Pitch")),
        yaw_base = pui.reference("AA", "Anti-aimbot angles", "Yaw base"),
        yaw = pui.reference("AA", "Anti-aimbot angles", "Yaw"),
        yaw_val = select(2, pui.reference("AA", "Anti-aimbot angles", "Yaw")),
        jitter = pui.reference("AA", "Anti-aimbot angles", "Yaw jitter"),
        jitter_val = select(2, pui.reference("AA", "Anti-aimbot angles", "Yaw jitter")),
        body = pui.reference("AA", "Anti-aimbot angles", "Body yaw"),
        body_val = select(2, pui.reference("AA", "Anti-aimbot angles", "Body yaw")),
        body_fs = pui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
        roll = pui.reference("AA", "Anti-aimbot angles", "Roll"),
    },
    otheraa = {
        fs = pui.reference("AA", "Anti-aimbot angles", "Freestanding"),
        edge = pui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
        aa_enabled = pui.reference("AA", "Anti-aimbot angles", "Enabled"),
    },
    other = {
        slowwalk = pui.reference("AA", "Other", "Slow motion"),
        dt = pui.reference("Rage", "Aimbot", "Double tap"),
        hs = pui.reference("AA", "Other", "On shot anti-aim"),
        dmg = {pui.reference("Rage", "Aimbot", "Minimum damage override")},
        dmg2 = pui.reference("Rage", "Aimbot", "Minimum damage"),
        scope = pui.reference("Visuals", "Effects", "Remove scope overlay"),
        legbreak = pui.reference("AA", "Other", "Leg movement"),
        fs = pui.reference("AA", "Anti-aimbot angles", "Freestanding"),
        baim = pui.reference("Rage", "Aimbot", "Force body aim"),
        safe = pui.reference("Rage", "Aimbot", "Force safe point"),
        fd = pui.reference("Rage", "Other", "Duck peek assist"),
        edge = pui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
        tag = pui.reference("Misc", "Miscellaneous", "Clan tag spammer"),
    }
}
local screen = {
    center = vector(client.screen_size()) * 0.5,
    size = vector(client.screen_size()),
}
local conditionlist = {
    "Default",
    "Standing",
    "Moving",
    "Slowwalking",
    "Crouching",
    "Crouching Move",
    "Air",
    "Crouching Air",
    "Safe Head",
    "Defensive",
    "Avoid Backstab",
}
local conditionlist2 = conditionlist
local steamname = panorama.open("CSGOHud").MyPersonaAPI.GetName()
client.color_log(175,175,255,"[Nouble]  \0")
client.color_log(225,225,225,"~  Welcome back, \0")
client.color_log(175,175,255,steamname)

local settings_tab = {
    "Crosshair Indicators","Damage Indicator","Manual Yaw Arrows",
    "Watermark", "Scope Overlay", "Aimbot Markers", "Aimbot Logs",
    "Velocity Warning", "Console Filter", "Animation Breakers",
    "Force Defensive", "Fast Ladder Move", "Clantag",
}
local arrays = {
    enabled = "\a"..color(175, 175, 255, 255):to_hex().." - Enabled",
    settings = {},
    antiaims = {},
}
for a,b in pairs(settings_tab) do 
    arrays.settings[b] = ""
end
for a,b in pairs(conditionlist2) do 
    arrays.antiaims[b] = ""
end
local arrays2 = {
    settings={},
    antiaims={},
}
local update_arrays2 = function()
    for a,b in pairs(settings_tab) do 
        arrays2.settings[a] = settings_tab[a]..arrays.settings[b]
    end
    for a,b in pairs(conditionlist2) do 
        arrays2.antiaims[a] = conditionlist2[a]..arrays.antiaims[b]
    end
end
update_arrays2()
local menu = {
    tab = {
        select = group:combobox("\n main_tabs", tabs),
        group:label("\n"),
    },
    Settings = {
        tab = group:listbox("\n", arrays2.settings),
        ["Crosshair Indicators"] = {
            switch = group:checkbox("Enabled\n crosshair_ind"),
            gear = {
                elements = group:multiselect("Elements\n crosshair_ind", {"State", "Double tap", "On shot anti-aim", "Minimum damage override","Freestanding","Force body aim", "Force safe point", "Fake duck"}),
                color = group:color_picker("Color\n crosshair_ind", color(175,175,255,255))
            }
        },
        ["Damage Indicator"] = {
            switch = group:checkbox("Enabled\n damage_ind"),
            gear = {
                font = group:combobox("Font\n damage_ind", {"Small", "Default", "Big"}),
                always_on = group:checkbox("Always On\n damage_ind"),
            }
        },
        ["Manual Yaw Arrows"] = {
            switch = group:checkbox("Enabled\n manual_arrows"),
            gear = {
                distance = group:slider("Distance\nmanual_arrows",10,150,75, true, "px"),
                color = group:color_picker("damage_ind color", color(255,225))
            }
        },
        ["Watermark"] = {
            switch = group:checkbox("Enabled\n watermark"),
            gear = {
                color = group:color_picker("watermark color", color(175,175,255,255))
            }
        },
        ["Scope Overlay"] = {
            switch = group:checkbox("Enabled\n scope_overlay"),
            gear = {
                remove = group:multiselect("Remove lines", {"Top", "Right", "Left", "Bottom"})
            }
        },
        ["Aimbot Markers"] = {
            switch = group:checkbox("Enabled\n aimbot_markers"),
            gear = {
                when = group:multiselect("\nwhen aimbot_markers", {"On Hit", "On Miss"}),
                size = group:slider("Size\n aimbot_markers", 0, 16, 4, true, "px"),
                time = group:slider("Time\n aimbot_markers", 0, 16, 3, true, "s"),
                hit = group:label("Hit Color\n aimbot_markers", color(255)),
                miss = group:label("Miss Color\n aimbot_markers", color(255,145,145,255)),
                reason = group:checkbox("Show miss reason\n aimbot_markers"),
                preview = group:button("Preview Markers")
            }
        },
        ["Aimbot Logs"] = {
            switch = group:checkbox("Enabled\n aimbot_logs"),
            gear = {
                where = group:multiselect("\nwhen aimbot_logs", {"On Screen", "In Console"}),
            }
        },
        ["Velocity Warning"] = {
            switch = group:checkbox("Enabled\n velocity_warning"),
            gear = {
                bad = group:label("Bad Color", color(255,95,95,255)),
                good = group:label("Good Color", color(175,175,255,255)),
                back = group:label("Background Color", color(0,255))
            }
        },
        ["Console Filter"] = {
            switch = group:checkbox("Enabled\n console_filter"),
            gear = {
                
            }
        },
        ["Animation Breakers"] = {
            switch = group:checkbox("Enabled\n anim_breakers"),
            gear = {
                select = group:multiselect("\n anim_breakers", {"Force Falling", "Landing Pitch", "Sliding Slowwalk", "Moonwalk Mode", "Moonwalk Mode in Air", "Move Lean"})
            }
        },
        ["Force Defensive"] = {
            switch = group:checkbox("Enabled\n force_defensive"),
            gear = {
                select = group:multiselect("\n force_defensive", {"Standing","Moving","Slowwalking","Crouching","Crouching Move","Air","Crouching Air","Safe Head","Avoid Backstab"})
            }
        },
        ["Fast Ladder Move"] = {
            switch = group:checkbox("Enabled\n fast_ladder"),
            gear = {
            }
        },
        ["Clantag"] = {
            switch = group:checkbox("Enabled\n clan_tag"),
            gear = {
            }
        },
    },
    Antiaims = {
        group1 = {
            group:label("\vHotkeys"),
            group:label("\aAAAAAAAA_________________________________"),
            edge = group:label("Edge Yaw", 0x0),
            fs = group:label("Freestanding", 0x0),
            group:label(" "),
            left = group:label("\v~\r Left", 0x0),
            right = group:label("\v~\r Right", 0x0),
            forward = group:label("\v~\r Forward", 0x0),
            manual_disablers = group:multiselect("Disable on manual", {"Jitter", "Body yaw"}),
            -- group:label(" "),
            -- group:label("\vOther"),
            -- group:label("\aAAAAAAAA_________________________________"),
            -- safehead = group:multiselect("Safe head when", {"Height Advantage", "Crouching Air + Knife", "Crouching Air + Zeus"}),
            group:label(" "),
            antiaim = group:checkbox("\vAnti-aimbot angles"),
            qwe1 = group:label("\aAAAAAAAA_________________________________"),
            elements = group:listbox("Conditions", arrays2.antiaims),
            qwe2 = group:label("\aAAAAAAAA_________________________________"),
        },
        group2 = {},
    },
    Configs = {
        export = group:button("Export"),
        import = group:button("Import"),
        default = group:button("Default"),
    }
}
for a,b in pairs(conditionlist2) do
    menu.Antiaims.group2[b] = {
        enable = group:checkbox("\vEnabled \n"..b),
        preset = b ~= "Defensive" and b ~= "Avoid-Backstab" and b ~= "Safe Head" and group:combobox("Preset\n"..a, {"Preset 1", "Builder"}) or group:combobox("Preset\n"..a, {"Builder"}),
        pitch = group:combobox("Pitch\n"..a, {"Off", "Default", "Up", "Down", "Mininal", "Random", "Custom"}),
        pitch_custom = group:slider("Pitch Custom\n"..a, -89,89,0, true, "°", 1, {[89] = "Down", [-89] = "Up", [0] = "Zero"}),
        base = group:combobox("Yaw base\n"..a, {"Local view", "At targets"}),
        yaw = group:combobox("Yaw\n"..a, {"Off", "180", "Spin", "Static", "180 Z", "Crosshair", "L&R"}),
        yaw_val = group:slider("Yaw left\n"..a, -180,180,0, true, "°"),
        yaw_val2 = group:slider("Yaw right\n"..a, -180,180,0, true, "°"),
        yaw_delay = group:slider("Yaw Delay\n"..a, 1,20,0, true, "t"),
        yaw_jitter = group:combobox("Yaw Jitter\n"..a, {"Off", "Offset", "Center", "Random", "Skitter"}),
        yaw_jitter_type = group:combobox("Yaw Jitter Type\n"..a, {"Default", "Switch", "Random"}),
        yaw_jitter_val = group:slider("Yaw Jitter #1\n"..a, -180,180,0, true, "°"),
        yaw_jitter_val2 = group:slider("Yaw Jitter #2\n"..a, -180,180,0, true, "°"),
        yaw_jitter_random = group:slider("Yaw Jitter Random\n"..a, 0,180,0, true, "°"),
        body = group:combobox("Body Yaw\n"..a, {"Off", "Opposite", "Jitter", "Static", "Randomize jitter"}),
        body_val = group:slider("Body Yaw\n"..a, -180,180,0, true, "°"),
        body_fs = group:checkbox("Freestanding Body Yaw\n"..a),
        roll = group:slider("Roll\n"..a, -45,45,0, true, "°"),
    }
end
for a in pairs(menu.Settings) do
    if a == "tab" then goto skip end
    menu.Settings[a].switch:set_callback(function(self)
        arrays.settings[a] = self:get() and arrays.enabled or ""
        update_arrays2()
        menu.Settings.tab:update(arrays2.settings)
    end)
    ::skip::
end
for a in pairs(menu.Antiaims.group2) do
    menu.Antiaims.group2[a].enable:set_callback(function(self)
        arrays.antiaims[a] = self:get() and string.format("\a%s - %s", color(175,175,255,255):to_hex() ,menu.Antiaims.group2[a].preset:get()) or ""
        update_arrays2()
        menu.Antiaims.group1.elements:update(arrays2.antiaims)
    end)
    menu.Antiaims.group2[a].preset:set_callback(function()
        arrays.antiaims[a] = menu.Antiaims.group2[a].enable:get() and string.format("\a%s - %s", color(175,175,255,255):to_hex() ,menu.Antiaims.group2[a].preset:get()) or ""
        update_arrays2()
        menu.Antiaims.group1.elements:update(arrays2.antiaims)
    end)
end
local main_tab = menu.tab.select:get()
local settings_tab = function()
    local tab_get = menu.Settings.tab:get() or nil
    if tab_get == nil then return end
    local selected = settings_tab[tab_get+1]
    local work1 = main_tab == "Settings"
    for a in pairs(menu.Settings) do
        if a == "tab" then menu.Settings.tab:set_visible(work1) goto skip end
        local work2 = work1 and selected == a
        local self = menu.Settings[a]
        self.switch:set_visible(work2)
        local work3 = work2 and self.switch:get()
        for a,b in pairs(self.gear) do b:set_visible(work3)end
        ::skip::
    end
end
local antiaims_tab = function()
    local work1 = main_tab == "Antiaims"
    for a in pairs(menu.Antiaims.group1) do
        menu.Antiaims.group1[a]:set_visible(work1)
    end
    if not menu.Antiaims.group1.antiaim:get() then
        menu.Antiaims.group1.qwe1:set_visible(false)
        menu.Antiaims.group1.qwe2:set_visible(false)
        menu.Antiaims.group1.elements:set_visible(false)
    end
end
local antiaims_tab2 = function()
    local selected = menu.Antiaims.group1.elements:get()
    local work = menu.Antiaims.group1.antiaim:get()
    for a,b in pairs(conditionlist2) do
        menu.Antiaims.group2[conditionlist2[1]].enable:set(true)
        menu.Antiaims.group2[conditionlist2[1]].enable:set_visible(false)
        local need_select = selected == a-1
        local all_work2 = work and menu.Antiaims.group2[b].enable:get() and need_select and menu.tab.select:get() == "Antiaims"
        menu.Antiaims.group2[b].preset:set_visible(all_work2)
        local all_work3 = all_work2 and menu.Antiaims.group2[b].preset:get() == "Builder"
        menu.Antiaims.group2[b].enable:set_visible(work and need_select and menu.tab.select:get() == "Antiaims")
        menu.Antiaims.group2[b].pitch:set_visible(all_work3)
        menu.Antiaims.group2[b].pitch_custom:set_visible(all_work3 and menu.Antiaims.group2[b].pitch:get() == "Custom")
        menu.Antiaims.group2[b].base:set_visible(all_work3)
        menu.Antiaims.group2[b].yaw:set_visible(all_work3)
        menu.Antiaims.group2[b].yaw_val:set_visible(all_work3 and menu.Antiaims.group2[b].yaw:get() ~= "Off")
        menu.Antiaims.group2[b].yaw_val2:set_visible(all_work3 and menu.Antiaims.group2[b].yaw:get() == "L&R" and menu.Antiaims.group2[b].yaw:get() ~= "Off")
        menu.Antiaims.group2[b].yaw_delay:set_visible(all_work3 and menu.Antiaims.group2[b].yaw:get() == "L&R" and menu.Antiaims.group2[b].yaw:get() ~= "Off")
        menu.Antiaims.group2[b].yaw_jitter:set_visible(all_work3 and menu.Antiaims.group2[b].yaw:get() ~= "Off")
        menu.Antiaims.group2[b].yaw_jitter_type:set_visible(all_work3 and menu.Antiaims.group2[b].yaw_jitter:get() ~= "Off" and menu.Antiaims.group2[b].yaw:get() ~= "Off")
        menu.Antiaims.group2[b].yaw_jitter_val:set_visible(all_work3 and menu.Antiaims.group2[b].yaw_jitter:get() ~= "Off" and menu.Antiaims.group2[b].yaw:get() ~= "Off")
        menu.Antiaims.group2[b].yaw_jitter_val2:set_visible(all_work3 and menu.Antiaims.group2[b].yaw_jitter_type:get() ~= "Default" and menu.Antiaims.group2[b].yaw_jitter:get() ~= "Off" and menu.Antiaims.group2[b].yaw:get() ~= "Off")
        menu.Antiaims.group2[b].yaw_jitter_random:set_visible(all_work3 and menu.Antiaims.group2[b].yaw_jitter:get() ~= "Off" and menu.Antiaims.group2[b].yaw:get() ~= "Off")
        menu.Antiaims.group2[b].body:set_visible(all_work3)
        menu.Antiaims.group2[b].body_val:set_visible(all_work3 and menu.Antiaims.group2[b].body:get() ~= "Off" and menu.Antiaims.group2[b].body:get() ~= "Opposite")
        menu.Antiaims.group2[b].body_fs:set_visible(all_work3 and menu.Antiaims.group2[b].body:get() ~= "Off" and menu.Antiaims.group2[b].body:get() ~= "Opposite")
        menu.Antiaims.group2[b].roll:set_visible(all_work3)
    end
end
local configs_tab = function()
    local work1 = main_tab == "Configs"
    for a in pairs(menu.Configs) do
        menu.Configs[a]:set_visible(work1)
    end
end
local animations = {
    lerp_ = function (self, start, end_, speed, delta)
        if (math.abs(start - end_) < (delta or 0.01)) then
            return end_
        end
        speed = speed or 0.095
        local time = globals.frametime() * (175 * speed)
        return ((end_ - start) * time + start)
    end,
}
local FL_ONGROUND = bit.lshift(1, 0)
local on_ground_ticks = 60
local lp_state
local function is_knifeable(lp)
    local knife_range = 128
    local origin = vector(entity.get_origin(lp))
    local enemies = entity.get_players(true)
    for _,v in ipairs(enemies) do
        local weapon = entity.get_player_weapon(v)
        local weapon_class = entity.get_classname(weapon)

        if weapon_class == "CKnife" then
            local enemy_origin = vector(entity.get_origin(v))
            local dist = origin:dist(enemy_origin)

            if dist <= knife_range then
                return true
            end
        end
    end

    return false
end
local function GetCurrentState()
    local lp = entity.get_local_player()
    if not lp then return "none" end
    local velocity = {entity.get_prop(lp, "m_vecVelocity")}
    local speed = math.sqrt(velocity[1] * velocity[1] + velocity[2] * velocity[2])
    local avoid_backstab = is_knifeable(lp)
    local duck_amount = entity.get_prop(lp, "m_flDuckAmount")

    local flags = entity.get_prop(lp, "m_fFlags")
    local on_ground = bit.band(flags, FL_ONGROUND) == FL_ONGROUND
    on_ground_ticks = on_ground and on_ground_ticks + 1 or 0

    local origin = vector(entity.get_origin(lp))
    local threat = client.current_threat()
    local height_to_threat = 0
    if threat then
        local threat_origin = vector(entity.get_origin(threat))
        height_to_threat = origin.z-threat_origin.z
    end
    local weapon = entity.get_player_weapon(lp)
    local weapon_class = entity.get_classname(weapon)
    -- local safehead = (menu.Antiaims.safehead:get("Height Advantage") and height_to_threat > 50 or 
    -- menu.Antiaims.safehead:get("Crouching Air + Knife") and on_ground_ticks <= 1 and duck_amount >= 0.9 and weapon_class == "CKnife" or 
    -- menu.Antiaims.safehead:get("Crouching Air + Zeus") and on_ground_ticks <= 1 and duck_amount >= 0.9 and weapon_class == "CWeaponTaser")
    local states = {
        {name = "avoid backstab", condition = menu.Antiaims.group2["Avoid Backstab"].enable:get() and avoid_backstab, priority = 9},
        {name = "safe head", condition = safehead and menu.Antiaims.group2["Safe Head"].enable:get(), priority = 8},
        {name = "crouching air", condition = on_ground_ticks <= 1 and duck_amount >= 0.9, priority = 7},
        {name = "air", condition = on_ground_ticks <= 1, priority = 6},
        {name = "crouching move", condition = duck_amount >= 0.9 and speed > 2, priority = 4},
        {name = "crouching", condition = duck_amount >= 0.9, priority = 3},
        {name = "slowwalking", condition = refs.other.slowwalk.hotkey:get() and speed > 2, priority = 2},
        {name = "moving", condition = speed > 2, priority = 1},
        {name = "standing", condition = speed < 2 and on_ground_ticks > 1, priority = 0},
    }
    table.sort(states, function(a, b) return a.priority > b.priority end)
    for _, state in ipairs(states) do
        if state.condition then
            return state.name
        end
    end
end
local function add_indicator(check, table1, name, text, priority, color1)
    if check then table.insert(table1, {Name = name, Text = text, Priority = priority, Color = color1})end
end
local x_add = 0 
local flag
local crosshair_ind = function()
    local lp = entity.get_local_player()
    if not lp then return end
    if not entity.is_alive(lp) then return end
    if not menu.Settings["Crosshair Indicators"].switch:get() then return end
    if not lp_state then return end
    local self = menu.Settings["Crosshair Indicators"].gear
    local accent = color(self.color:get())
    local y_add = 30
    local hex_ = accent:to_hex()
    local hex = "\a"..hex_
    local name = true and "Nouble" or ""
    local version = true and "Nightly" or ""
    local space_ = name ~= "" and version ~= ""
    local space = space_ and " " or ""
    local crosshair_table = {}
    add_indicator(true,crosshair_table, "LUA Name", name..space..hex..version,   1,color(255,255,255,255))
    add_indicator(true and self.elements:get("State"),crosshair_table, "State",lp_state,   2,accent)
    add_indicator(refs.other.dt.hotkey:get() and self.elements:get("Double tap"),crosshair_table, "DT","DT",3,color(255,255,255,255))
    add_indicator(refs.other.hs.hotkey:get() and self.elements:get("On shot anti-aim"),crosshair_table, "OSAA","HIDE",4,color(255,255,255,255))
    add_indicator(refs.other.dmg.hotkey:get() and self.elements:get("Minimum damage override"),crosshair_table, "DMG","DMG",5,color(255,255,255,255))
    add_indicator(refs.other.fs:get() and refs.other.fs.hotkey:get() and self.elements:get("Freestanding"),crosshair_table, "FS","FS",6,color(255,255,255,255))
    add_indicator(refs.other.baim:get() and self.elements:get("Force body aim"),crosshair_table, "BAIM","BAIM",7,color(255,255,255,255))
    add_indicator(refs.other.safe:get() and self.elements:get("Force safe point"),crosshair_table, "SAFE","SAFE",8,color(255,255,255,255))
    add_indicator(refs.other.fd:get() and self.elements:get("Fake duck"),crosshair_table, "FD","FD",9,color(255,255,255,255))
    table.sort(crosshair_table, function(a, b) return a.Priority < b.Priority end)
    if entity.get_prop(lp, 'm_bIsScoped') == 1 then
        flag = "-"
        y_add = y_add - 6
        x_add = animations:lerp_(x_add, 10, .1)
    else
        flag = "c-"
        x_add = animations:lerp_(x_add, 0, .1)
    end
    for _, entry in pairs(crosshair_table) do
        renderer.text(screen.center.x + x_add, screen.center.y + y_add, entry.Color.r,  entry.Color.g,  entry.Color.b,  entry.Color.a, flag, 0, entry.Text:upper())
        y_add = y_add + 9
    end
end
local damage_alpha = 0
local damage_ind = function()
    local lp = entity.get_local_player()
    if not lp then return end
    if not entity.is_alive(lp) then return end
    if not menu.Settings["Damage Indicator"].switch:get() then return end
    local work = refs.other.dmg[1].hotkey:get() and refs.other.dmg[1]:get() or menu.Settings["Damage Indicator"].gear.always_on:get()
    damage_alpha = animations:lerp_(damage_alpha, work and 255 or 0, 0.1)
    if damage_alpha == 0 then return end
    local font = menu.Settings["Damage Indicator"].gear.font:get()
    local font_ = font == "Small" and "-" or font == "Default" and "" or font == "Big" and "+"
    renderer.text(screen.center.x+15, screen.center.y-16, 255, 255, 255, damage_alpha, "c"..font_, 0, refs.other.dmg[1].hotkey:get() and refs.other.dmg[2]:get() or refs.other.dmg2:get())

end

client.set_event_callback('paint_ui', function()
    for a,b in pairs(refs.aa) do
        b:set_visible(false)
    end
    refs.otheraa.edge:set_visible(false)
    refs.otheraa.fs:set_visible(false)
    refs.otheraa.aa_enabled:set_visible(false)
    main_tab = menu.tab.select:get()
    settings_tab()
    antiaims_tab()
    antiaims_tab2()
    configs_tab()
end)
client.set_event_callback('paint', function()
    crosshair_ind()
    damage_ind()
end)
client.set_event_callback('setup_command', function()
    lp_state = GetCurrentState()
end)