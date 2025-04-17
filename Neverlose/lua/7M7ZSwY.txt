local pui = require("neverlose/pui")

local aa_tab_builder = pui.create("\v".. ui.get_icon("shield-halved").." Builder", "Builder")

local aa_table = {
    states = {"Stand", "Run", "Jump", "Jump+", "Duck", "Slowwalk"},
}

local _ui = {
    aa_tab = {
        state = aa_tab_builder:combo("Condition", aa_table.states)
    }
}

local vars = {
    refs = {
        invert = pui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
        bodyyaw_options = pui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options")
    }
}

local includes_tbl = {
    ['hidden'] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
    ['lagopt'] = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
    ['hsopt'] = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
    ['antibs'] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    ['pitch'] = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    ['yaw'] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
    ['yawbase'] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    ['bodyyaw'] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    ['bodyyawleft'] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    ['bodyyawright'] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    ['bodyyawopt'] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    ['yawmodifiers'] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    ['yawmodifiersvalue'] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    ['yawoffset'] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset")
}

aa_builder = {}
for state_key, state_name in ipairs(aa_table.states) do
    aa_builder[state_key] = {}
    local menu = aa_builder[state_key]

    menu.bb_yaw = aa_tab_builder:switch("Yaw", false, nil, function(yaw_bb)  -- useless, you dont even need to enable this switch :clown:
        return {
            mode = yaw_bb:combo("Mode", {"L&R Yaw", "Slow Yaw", "Sway Yaw"}),
            yaw_left = yaw_bb:slider("left", -180, 180, 0),
            yaw_right = yaw_bb:slider("right", -180, 180, 0),
            switch_delay = yaw_bb:slider("delay", 1, 20, 2),    
        }
    end)

    menu.bb_modifier = aa_tab_builder:combo("Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"}, false, nil, function(modify_bb)
        return {
            yaw_mods = modify_bb:slider("Offset", -180, 180, 0),
        }
    end)

    menu.bb_desync = aa_tab_builder:switch("Desync", false, nil, function(body_yaw)
        return {
            left_limit = body_yaw:slider("Left Limit",1,60, 59),
            right_limit = body_yaw:slider("Right Limit",1,60, 59),
            options = body_yaw:selectable("Options", {"Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce"}),
        }
    end)

    menu.bb_defensive = aa_tab_builder:switch("Defensive AA", false, nil, function(defen_bb)
        return {
            pitch = defen_bb:combo("Pitch", {"Up", "Down", "Zero", "Random", "Custom"}),
            pitch_value = defen_bb:slider("Pitch value", -89, 89, 0),
            yaw = defen_bb:combo("Yaw", {"Custom", "Spin", "Random", "Sideway"}),
            yaw_value = defen_bb:slider("Yaw value", -180, 180, 0),
        }
    end)

    menu.bb_antibs = aa_tab_builder:switch("avoid backstab")
end

for i, ss in ipairs(aa_table.states) do
    local menu = aa_builder[i]
    menu.bb_yaw:depend({_ui.aa_tab.state, ss})
    menu.bb_modifier:depend({_ui.aa_tab.state, ss})
    menu.bb_desync:depend({_ui.aa_tab.state, ss})
    menu.bb_defensive:depend({_ui.aa_tab.state, ss})
    menu.bb_antibs:depend({_ui.aa_tab.state, ss})

    menu.bb_yaw.switch_delay:depend({menu.bb_yaw.mode, "Slow Yaw"})
    menu.bb_defensive.pitch_value:depend({menu.bb_defensive.pitch, "Custom"})
    menu.bb_defensive.yaw_value:depend({menu.bb_defensive.yaw, "Custom"})
end

function player_invert()
    return math.normalize_yaw(entity.get_local_player().m_flPoseParameter[11] * 120 - 60) / 2 < 0
end

function get_states(cmd)
    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end

    local r1_0 = (function(r0_1)
        local r1_1 = r0_1["m_vecVelocity[0]"]
        local r2_1 = r0_1["m_vecVelocity[1]"]
        return math.sqrt(r1_1 * r1_1 + r2_1 * r2_1)
    end)(lp) -- get speed func

    local idx = 0

    local r2_0 = bit.band(lp.m_fFlags, bit.lshift(1, 0)) == 0
    local r3_0 = 0.8 < lp.m_flDuckAmount
    if r1_0 < 5 and not r3_0 and not r2_0 and ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() == false then
        idx = 1 -- stand
    elseif not r2_0 and r1_0 > 4 and not r3_0 and ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() == false then
        idx = 2 -- run
    elseif r2_0 and not r3_0 and ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() == false then
        idx = 5 -- jump
    elseif r2_0 and r3_0 and ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() == false then
        idx = 6 -- jump+
    elseif not r2_0 and r3_0 and ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() == false then
        idx = 3 -- duck
    elseif ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() == true then
        idx = 4 -- slowwalk
    end

    return idx
end


-- menu.bb_yaw = aa_tab_builder:switch("Yaw", false, nil, function(yaw_bb) 
--     return {
--         mode = yaw_bb:combo("Mode", {"L&R Yaw", "Slow Yaw", "Sway Yaw"}),
--         yaw_left = yaw_bb:slider("left", -180, 180, 0),
--         yaw_right = yaw_bb:slider("right", -180, 180, 0),
--         switch_delay = yaw_bb:slider("delay", 1, 20, 2),    
--     }
-- end)

-- menu.bb_modifier = aa_tab_builder:combo("Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"}, false, nil, function(modify_bb)
--     return {
--         yaw_mods = modify_bb:slider("Offset", -180, 180, 0)
--     }
-- end)

-- menu.bb_desync = aa_tab_builder:switch("Desync", false, nil, function(body_yaw)
--     return {
--         left_limit = body_yaw:slider("Left Limit",1,60, 59),
--         right_limit = body_yaw:slider("Right Limit",1,60, 59),
--         options = body_yaw:selectable("Options", {"Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce"})
--     }
-- end)

-- menu.bb_defensive = aa_tab_builder:switch("Defensive AA", false, nil, function(defen_bb)
--     return {
--         pitch = defen_bb:combo("Pitch", {"Up", "Down", "Zero", "Random", "Custom"}),
--         pitch_value = defen_bb:slider("Pitch value", -89, 89, 0),
--         yaw = defen_bb:combo("Yaw", {"Custom", "Spin", "Random", "Sideway"})
--         yaw_value = defen_bb:slider("Yaw value", -180, 180, 0)
--     }
-- end)


-- local includes_tbl = {
--     ['hidden'] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
--     ['lagopt'] = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
--     ['hsopt'] = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
--     ['antibs'] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
--     ['pitch'] = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
--     ['yaw'] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
--     ['yawbase'] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
--     ['bodyyaw'] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
--     ['bodyyawleft'] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
--     ['bodyyawright'] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
--     ['bodyyawopt'] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
--     ['yawmodifiers'] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
--     ['yawmodifiersvalue'] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
--['yawoffset'] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset")
-- }

function antiaim_main(cmd)
    local r1_0 = entity.get_local_player()
    if not r1_0 then
    return 
    end

    local state = aa_builder[get_states(cmd)]

    print(get_states())

    if state.bb_defensive:get() then
        rage.exploit:allow_defensive(true)
        includes_tbl["lagopt"]:override("Always On")
        includes_tbl["hsopt"]:override("Break LC")
      else
        rage.exploit:allow_defensive(false)
        includes_tbl["lagopt"]:override(includes_tbl["lagopt"]:get())
        includes_tbl["hsopt"]:override(includes_tbl["hsopt"]:get())
    end
    includes_tbl["antibs"]:override(state.bb_antibs:get())

    includes_tbl["pitch"]:override("Down")
    includes_tbl["yaw"]:override("Backward")
    includes_tbl["yawbase"]:override("At Target")
    includes_tbl["yawmodifiers"]:override(state.bb_modifier:get())
    includes_tbl["bodyyaw"]:override(state.bb_desync:get())
    includes_tbl["bodyyawleft"]:override(state.bb_desync.left_limit:get())
    includes_tbl["bodyyawright"]:override(state.bb_desync.right_limit:get())

    if state.bb_yaw.mode:get() == "L&R Yaw" then
        includes_tbl["bodyyawopt"]:override(state.bb_desync.options:get())
        local r2_0 = includes_tbl["yawmodifiersvalue"]
        local r3_0 = r2_0
        r2_0 = r2_0.override
        r4_0 = state.bb_modifier.yaw_mods:get() 
        r2_0(r3_0, r4_0)
        r2_0 = includes_tbl["yawoffset"]
        r3_0 = r2_0
        r2_0 = r2_0.override
          if player_invert() then
            r4_0_0 = state.bb_yaw.yaw_right:get()
          else
            r4_0_0 = state.bb_yaw.yaw_left:get()
          end
        r2_0(r3_0, r4_0_0)
    elseif state.bb_yaw.mode:get() == "Slow Yaw" then
        local r2_0 = state.bb_yaw.switch_delay:get() / 2 <= globals.tickcount % state.bb_yaw.switch_delay:get()
        rage.antiaim:inverter(r2_0)
        includes_tbl["bodyyawopt"]:override("")
        r3_0 = includes_tbl["yawmodifiersvalue"]
        local r4_0 = r3_0
        r3_0 = r3_0.override
          r5_0 = state.bb_modifier.yaw_mods:get()
        r3_0(r4_0, r5_0)
        r3_0 = includes_tbl["yawoffset"]
        r4_0 = r3_0
        r3_0 = r3_0.override
          if r2_0 then
            r5_0_0 = state.bb_yaw.yaw_left:get()
          else
            r5_0_0 = state.bb_yaw.yaw_right:get()
          end
        r3_0(r4_0, r5_0_0)
    elseif state.bb_yaw.mode:get() == "Sway Yaw" then 
        local r2_0 = state.bb_yaw.yaw_left:get()
        local r6_0 = r2_0 + globals.tickcount % (state.bb_yaw.yaw_right:get() - r2_0) / (state.bb_yaw.switch_delay:get() - 20 + 1) * (state.bb_yaw.switch_delay:get() - 20 + 1)
        vars.refs.invert:override(false)
        vars.refs.bodyyaw_options:override(state.bb_desync.options:get())
        local r7_0 = includes_tbl["yawmodifiersvalue"]
        local r8_0 = r7_0
        r7_0 = r7_0.override
          r9_0 = state.bb_modifier.yaw_mods:get()
        r7_0(r8_0, r9_0)
        r7_0 = includes_tbl["yawoffset"]
        r8_0 = r7_0
        r7_0 = r7_0.override
          r9_0_0 = r6_0
        r7_0(r8_0, r9_0_0)
    end
end

events.createmove:set(function(cmd)
    antiaim_main(cmd)
    get_states(cmd)
end)