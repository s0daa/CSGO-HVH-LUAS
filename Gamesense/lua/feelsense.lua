-- if not _G.cycek.zalupa then error("Redownload loader")end;if _NAME~=nil then error("Redownload loader")end;function celestia_data()local a={username=_G.cycek and get_username(),build=_G.cycek and get_build()}return a end;
local celestia = celestia_data and celestia_data() or {
    username = "admin",
    build = "none"
}

LPH_JIT_MAX = function(...) return ... end
local ffi = require("ffi")
local http = require("gamesense/http")
local clipboard = require("gamesense/clipboard") or error("Install Clipboard library!")
local base64 = require("gamesense/base64")
local antiaim_funcs = require("gamesense/antiaim_funcs") 
local pui = require("gamesense/pui") or error("Install PUI")
local vector = require("vector")
local group = pui.group("aa","anti-aimbot angles") --pui
pui.accent = "77d136ff"


contains = function(tbl, arg)
    for index, value in next, tbl do 
        if value == arg then 
            return true end 
        end 
    return false
end

local x, o = '\x14\x14\x14\xFF', '\x0c\x0c\x0c\xFF'

local pattern = table.concat{
    x,x,o,x,
    o,x,o,x,
    o,x,x,x,
    o,x,o,x
}

local tex_id = renderer.load_rgba(pattern, 4, 4)

function render_ogskeet_border(x,y,w,h,a,text)
    renderer.rectangle(x - 10, y - 48 ,w + 20, h + 16,12,12,12,a)
    renderer.rectangle(x - 9, y - 47 ,w + 18, h + 14,60,60,60,a)
    renderer.rectangle(x - 8, y - 46 ,w + 16, h + 12,40,40,40,a)
    renderer.rectangle(x - 5, y - 43 ,w + 10, h + 6,60,60,60,a)
    renderer.rectangle(x - 4, y - 42 ,w + 8, h + 4,12,12,12,a)
    renderer.texture(tex_id, x - 4, y - 42, w + 8, h + 4, 255, 255, 255, a, "r")
    renderer.gradient(x - 4,y - 42, w /2, 1, 59, 175, 222, a, 202, 70, 205, a,true)               
    renderer.gradient(x - 4 + w / 2 ,y - 42, w /2 + 8.5, 1,202, 70, 205, a,204, 227, 53, a,true)
    renderer.text(x, y - 40, 255,255,255,a, "", nil, text)
end

local antiaim_shits = {
    jitter_type = {"Default", "Active"},
    yaw_type = {"Default", "l&r", "Delayed Switch"},
    defensive_yaw = {'Spin', 'Side-Way', 'Random', 'Static'},
    defensive_pitch = {'Up', 'Zero', 'Random', 'Switch-Ways', 'Progressive', 'Custom'},
    condition = {'Global', 'Stand', 'Walking', 'Running' , 'Aerobic', 'Aerobic+', 'Duck', 'Duck+Move'},
    condition_short = {'G', 'S', 'W', 'R' , 'A', 'A+', 'D', 'D+M'},
    teams = {"T", "CT"},
    pitch = {'Off','Default','Up', 'Down', 'Minimal', 'Random'},
    yaw = {'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'},
    yawbase = {'Local View','At Targets'}
}

local X, Y = client.screen_size()
local notify_data = {}

function rgba_to_hex(b,c,d,e)
    return string.format('%02x%02x%02x%02x',b,c,d,e)
end

function gradient_text(text, speed, r,g,b,a)
    local final_text = ''
    local curtime = globals.curtime()
    local center = math.floor(#text / 2) + 1  -- calculate the center of the text
    for i=1, #text do
        -- calculate the distance from the center character
        local distance = math.abs(i - center)
        -- calculate the alpha based on the distance and the speed and time
        a = 255 - math.abs(255 * math.sin(speed * curtime / 4 - distance * 4 / 20))
        local col = rgba_to_hex(r,g,b,a)
        final_text = final_text .. '\a' .. col .. text:sub(i, i)
    end
    return final_text
end

local other_func = {
    create_color_array = function(r, g, b, string)
        local colors = {}
        for i = 0, #string do
            local color = {r, g, b, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime() / 4 + i * 5 / 30))}
            table.insert(colors, color)
        end
        return colors
    end,
    lerp = function(a, b, t)
        return a + (b - a) * t
    end,
    clamp = function(x, minval, maxval)
        if x < minval then
            return minval
        elseif x > maxval then
            return maxval
        else
            return x
        end
    end
}

references = {
    minimum_damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    minimum_damage_override = {ui.reference("RAGE", "Aimbot", "Minimum damage override")},
    double_tap = {ui.reference('RAGE', 'Aimbot', 'Double tap')},
    ps = { ui.reference("MISC", "Miscellaneous", "Ping spike") },
    duck_peek_assist = ui.reference('RAGE', 'Other', 'Duck peek assist'),
    enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
	pitch = {ui.reference('AA', 'Anti-aimbot angles', 'Pitch')},
    yaw_base = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw')},
    yaw_jitter = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter')},
    body_yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')},
    freestanding_body_yaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
	edge_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
	freestanding = {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')},
    roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll'),
    slow_motion = {ui.reference('AA', 'Other', 'Slow motion')},
    leg_movement = ui.reference('AA', 'Other', 'Leg movement'),
    on_shot_anti_aim = {ui.reference('AA', 'Other', 'On shot anti-aim')}
}

local ref = {
    aa_enable = ui.reference("AA","anti-aimbot angles","enabled"),
    pitch = ui.reference("AA","anti-aimbot angles","pitch"),
    pitch_value = select(2, ui.reference("AA","anti-aimbot angles","pitch")),
    yaw_base = ui.reference("AA","anti-aimbot angles","yaw base"),
    yaw = ui.reference("AA","anti-aimbot angles","yaw"),
    yaw_value = select(2, ui.reference("AA","anti-aimbot angles","yaw")),
    yaw_jitter = ui.reference("AA","Anti-aimbot angles","Yaw Jitter"),
    yaw_jitter_value = select(2, ui.reference("AA","Anti-aimbot angles","Yaw Jitter")),
    body_yaw = ui.reference("AA","Anti-aimbot angles","Body yaw"),
    body_yaw_value = select(2, ui.reference("AA","Anti-aimbot angles","Body yaw")),
    freestand_body_yaw = ui.reference("AA","Anti-aimbot angles","freestanding body yaw"),
    edgeyaw = ui.reference("AA","anti-aimbot angles","edge yaw"),
    freestand = {ui.reference("AA","anti-aimbot angles","freestanding")},
    roll = ui.reference("AA","anti-aimbot angles","roll"),
    slide = {ui.reference("AA","other","slow motion")},
    fakeduck = ui.reference("rage","other","duck peek assist"),
    quick_peek = {ui.reference("rage", "other", "quick peek assist")},
    doubletap = {ui.reference("rage", "aimbot", "double tap")},
}

local hide_refs = LPH_JIT_MAX(function(value)
    value = not value
    ui.set_visible(ref.aa_enable, value) ui.set_visible(ref.pitch, value) ui.set_visible(ref.pitch_value, value)
    ui.set_visible(ref.yaw_base, value) ui.set_visible(ref.yaw, value) ui.set_visible(ref.yaw_value, value)
    ui.set_visible(ref.yaw_jitter, value) ui.set_visible(ref.yaw_jitter_value, value) ui.set_visible(ref.body_yaw, value)
    ui.set_visible(ref.body_yaw_value, value) ui.set_visible(ref.edgeyaw, value) ui.set_visible(ref.freestand[1], value)
    ui.set_visible(ref.freestand[2], value) ui.set_visible(ref.roll, value) ui.set_visible(ref.freestand_body_yaw, value)
end)

local versions = {
    ["stable"] = {"[STABLE]", {255,255,255}},
    ["beta"] = {"[BETA]",{255, 46, 43}},
    ["private"] = {"[ALPHA]",{183, 78, 78}},
}

local feelsense = {
    main = {
        enable_lua = group:checkbox("\vFeel\rSense".." ~ \r".. celestia.username .. "[\v" .. celestia.build .. "\r]"),
        tab = group:combobox('Current Tab', {'Anti~Aim', 'Visuals', "Misc",'Configs'})
    },

    antiaim = {
        aa_modes = group:combobox("\n ", {"Builder", "Other"}),
        condition = group:combobox("Condition", antiaim_shits.condition),
        team_sel = group:combobox("Team", antiaim_shits.teams)
    },

    other = {
        anti_b = group:checkbox("Anti-backstab"),
        safe_head = group:checkbox("Safe-Head"),
        freestanding = group:hotkey("Freestanding"),
        freestanding_defensive = group:checkbox("Freestanding defensive peek"),
        freestanding_disablers = group:multiselect("Freestanding disablers", antiaim_shits.condition)
    },

    visuals = {
        watermark = group:checkbox("Watermark", {119, 209, 54}),
        watermark_pos = group:combobox("Watermark Place", {"Left", "Right", "Bottom"}),
        hitlogs_enable = group:checkbox("Hitlogs", {119,209,54}),
        hitlogs = group:multiselect("Hitlogs", "Hit", "Miss", "Other"),
    },

    config = {
        import = group:button("Import Config", function() import_cfg() end),
        export = group:button("Export Config", function() export_cfg() end),
        default = group:button("Default Config", function() default_cfg() end),
    }
}

feelsense.visuals.hitlogs_enable:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Visuals"})
feelsense.visuals.hitlogs:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Visuals"}, {feelsense.visuals.hitlogs_enable, true})
feelsense.other.anti_b:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Other"})
feelsense.other.safe_head:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Other"})
feelsense.other.freestanding:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Other"})
feelsense.other.freestanding_defensive:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Other"})
feelsense.other.freestanding_disablers:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Other"})
feelsense.visuals.watermark:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Visuals"})
feelsense.visuals.watermark_pos:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Visuals"}, {feelsense.visuals.watermark, false})
feelsense.main.tab:depend({feelsense.main.enable_lua, true})
feelsense.antiaim.aa_modes:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"})
feelsense.antiaim.condition:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Builder"})
feelsense.antiaim.team_sel:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Builder"})
feelsense.config.import:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Configs"})
feelsense.config.export:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Configs"})
feelsense.config.default:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Configs"})

aa_builder = {}
for _, team in ipairs(antiaim_shits.teams) do
    aa_builder[team] = {}
    for _, state in ipairs(antiaim_shits.condition) do
        aa_builder[team][state] = {}
        local menu = aa_builder[team][state]

        menu.enable = group:checkbox("Override ~ \v" .. state .. "\n" .. team)
        menu.pitch = group:combobox("Pitch", antiaim_shits.pitch)
        menu.yawbase = group:combobox("Yaw Base", antiaim_shits.yawbase)
        menu.yaw = group:combobox("Yaw", antiaim_shits.yaw)
        menu.yaw_mode = group:combobox("\n ", antiaim_shits.yaw_type)
        menu.yaw_slider_static = group:slider("Yaw", -180, 180, 0, true, "°", 1)
        menu.yaw_slider_l = group:slider("Yaw Left", -180, 180, 0, true, "°", 1)
        menu.yaw_slider_r = group:slider("Yaw Right", -180, 180, 0, true, "°", 1)
        menu.yaw_slider_delay = group:slider("Delay Ticks", 1, 10, 3, true, "%", 1)
        menu.mod_type = group:combobox('Modifier Type', {'Off','Offset','Center','Random', 'Skitter'})
        menu.jitter_type = group:combobox('Jitter Type', "Default", "l&r")
        menu.mod_j = group:slider('Jitter', -180, 180, 0, true, '°', 1)
        menu.mod_l = group:slider('Jitter Default', -180, 180, 0, true, '°', 1)
        menu.mod_r = group:slider('Jitter Active', -180, 180, 0, true, '°', 1)
        menu.body_yaw = group:combobox('Body Yaw', {'Off','Opposite','Jitter','Static'})
        menu.body_slider = group:slider('Body Yaw Amount', -180, 180, 0, true, '°', 1)
        menu.force_def = group:checkbox("Force defensive")
        menu.defensive = group:checkbox('Defensive Anti~Aim')
        menu.defensive_yaw = group:combobox('Defensive Yaw', {"Spin", "Side-Way", "Random", "Static"})
        menu.yaw_amount = group:slider('Offset', -180, 180, -180, true, '°', 1)
        menu.spin = group:slider('Spin Speed', -100, 100, 30, true, '%', 1)
        menu.defensive_pitch = group:combobox('Defensive Pitch', {"Custom", "Up", "Zero", "Random", "Switch-Ways", "Progressive"})
        menu.pitch_amount = group:slider('Pitch Amount', -89, 89, -49, true, '°', 1)
        local test_team = team == "CT" and "T" or "CT"
        menu.export_opposite_team = group:button("export to ["..test_team.." - "..state.."]", LPH_JIT_MAX(function()
            LPH_JIT_MAX(export_state_to(state, team, test_team))
        end))
        menu.export_state = group:button("export ["..team.. " - "..state.."]", LPH_JIT_MAX(function()
            LPH_JIT_MAX(export_state(state, team))
        end))
        menu.import_state = group:button("import ["..team.. " - "..state.."]", LPH_JIT_MAX(function()
            LPH_JIT_MAX(import_state(clipboard.get(), state, team))
        end))
    end
end

--{aa_builder[tt][ss].yaw_mode, function() return aa_builder[tt][ss].yaw_mode.value ~= "static" end}
for i, tt in ipairs(antiaim_shits.teams) do
    for k, ss in ipairs(antiaim_shits.condition) do 
        aa_builder[tt][ss].force_def:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Builder"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true})
        aa_builder[tt][ss].defensive:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Builder"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {aa_builder[tt][ss].force_def, true})
        aa_builder[tt][ss].defensive_yaw:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Builder"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {aa_builder[tt][ss].force_def, true}, {aa_builder[tt][ss].defensive, true})
        aa_builder[tt][ss].yaw_amount:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Builder"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {aa_builder[tt][ss].force_def, true}, {aa_builder[tt][ss].defensive, true})
        aa_builder[tt][ss].spin:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Builder"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {aa_builder[tt][ss].force_def, true}, {aa_builder[tt][ss].defensive, true}, {aa_builder[tt][ss].defensive_yaw, "Spin"})
        aa_builder[tt][ss].defensive_pitch:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Builder"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {aa_builder[tt][ss].force_def, true}, {aa_builder[tt][ss].defensive, true})
        aa_builder[tt][ss].pitch_amount:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Builder"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {aa_builder[tt][ss].force_def, true}, {aa_builder[tt][ss].defensive, true}, {aa_builder[tt][ss].defensive_pitch, "Custom"})
        aa_builder[tt][ss].enable:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Builder"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]})
        aa_builder[tt][ss].yawbase:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Builder"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true})
        aa_builder[tt][ss].pitch:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {feelsense.antiaim.aa_modes, "Builder"})
        aa_builder[tt][ss].export_opposite_team:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {feelsense.antiaim.aa_modes, "Builder"})
        aa_builder[tt][ss].export_state:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {feelsense.antiaim.aa_modes, "Builder"})
        aa_builder[tt][ss].import_state:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {feelsense.antiaim.aa_modes, "Builder"})
        aa_builder[tt][ss].yaw:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {feelsense.antiaim.aa_modes, "Builder"})
        aa_builder[tt][ss].yaw_mode:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {aa_builder[tt][ss].yaw, function() return aa_builder[tt][ss].yaw.value ~= "Off" end}, {feelsense.antiaim.aa_modes, "Builder"})
        aa_builder[tt][ss].yaw_slider_static:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {aa_builder[tt][ss].yaw, function() return aa_builder[tt][ss].yaw.value ~= "Off" end}, {aa_builder[tt][ss].yaw_mode, "Default"}, {feelsense.antiaim.aa_modes, "Builder"})
        aa_builder[tt][ss].yaw_slider_l:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {aa_builder[tt][ss].yaw, function() return aa_builder[tt][ss].yaw.value ~= "Off" end}, {aa_builder[tt][ss].yaw_mode, function() return aa_builder[tt][ss].yaw_mode.value ~= "Default" end}, {feelsense.antiaim.aa_modes, "Builder"})
        aa_builder[tt][ss].yaw_slider_r:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {aa_builder[tt][ss].yaw, function() return aa_builder[tt][ss].yaw.value ~= "Off" end}, {aa_builder[tt][ss].yaw_mode, function() return aa_builder[tt][ss].yaw_mode.value ~= "Default" end}, {feelsense.antiaim.aa_modes, "Builder"})
        aa_builder[tt][ss].yaw_slider_delay:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {aa_builder[tt][ss].yaw, function() return aa_builder[tt][ss].yaw.value ~= "Off" end}, {aa_builder[tt][ss].yaw_mode, "Delayed Switch"}, {feelsense.antiaim.aa_modes, "Builder"})
        aa_builder[tt][ss].mod_type:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Builder"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true})
        aa_builder[tt][ss].jitter_type:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Builder"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {aa_builder[tt][ss].mod_type, function() return aa_builder[tt][ss].mod_type.value ~= "Off" end})
        aa_builder[tt][ss].mod_j:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Builder"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {aa_builder[tt][ss].jitter_type, function() return aa_builder[tt][ss].jitter_type.value == "Default" end}, {aa_builder[tt][ss].mod_type, function() return aa_builder[tt][ss].mod_type.value ~= "Off" end})
        aa_builder[tt][ss].mod_l:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Builder"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {aa_builder[tt][ss].jitter_type, function() return aa_builder[tt][ss].jitter_type.value ~= "Default" end}, {aa_builder[tt][ss].mod_type, function() return aa_builder[tt][ss].mod_type.value ~= "Off" end})
        aa_builder[tt][ss].mod_r:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Builder"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {aa_builder[tt][ss].jitter_type, function() return aa_builder[tt][ss].jitter_type.value ~= "Default" end}, {aa_builder[tt][ss].mod_type, function() return aa_builder[tt][ss].mod_type.value ~= "Off" end})
        aa_builder[tt][ss].body_yaw:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Builder"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true})
        aa_builder[tt][ss].body_slider:depend({feelsense.main.enable_lua, true}, {feelsense.main.tab, "Anti~Aim"}, {feelsense.antiaim.aa_modes, "Builder"}, {feelsense.antiaim.condition, antiaim_shits.condition[k]}, {feelsense.antiaim.team_sel, antiaim_shits.teams[i]}, {aa_builder[tt][ss].enable, true}, {aa_builder[tt][ss].body_yaw, function() return aa_builder[tt][ss].body_yaw.value ~= "Off" end})

    end
end

local config_items = {
    feelsense.antiaim,
    aa_builder
}

local package = pui.setup(config_items)

function export_state_to(state, team, toteam)
    local config = pui.setup({aa_builder[team][state]})

    local data = config:save()
    local encrypted = base64.encode( json.stringify(data) )

    import_state(encrypted, state, toteam)
end

function export_state(state, team)
    local config = pui.setup({aa_builder[team][state]})

    local data = config:save()
    local encrypted = base64.encode( json.stringify(data) )

    clipboard.set(encrypted)
    new_notify("Successfully! Exported state", 119, 209, 54,255)
end

function import_state(encrypted, state,team)
    local data = json.parse(base64.decode(encrypted))

    local config = pui.setup({aa_builder[team][state]})
    config:load(data)
    new_notify("Successfully! Imported state", 119, 209, 54,255)
end

function import_cfg(data) 
    decrypted = json.parse(base64.decode(data ~= nil and data or clipboard.get()))
    package:load(decrypted)
    new_notify("Successfully! Imported settings from clipboard", 119, 209, 54,255)
end

function export_cfg()
    data = package:save()
    local encrypted = base64.encode(json.stringify(data))
    clipboard.set(encrypted)
    new_notify("Successfully! Exported settings to clipboard", 119, 209, 54,255)
end

function default_cfg()
    http.get("https://raw.githubusercontent.com/wyscigufa9/feelsense_cfg/main/feelsense_default.txt", function(r, s)
        if r then
            import_cfg(s.body)
            new_notify("Successfully! Loaded default config", 119, 209, 54,255)
        else
            error("Failed to load default config")
        end
    end)
end

local ground_tick = 1
current_tickcount = 0
current_flickcount = 0
to_flick = false
to_jitter = false
local last_sim_time = 0
local defensive_until = 0

local ctx = (LPH_JIT_MAX(function()
    local ctx = {}

    ctx.m_render = {
        rec = function(self, x, y, w, h, radius, color)
            radius = math.min(x/2, y/2, radius)
            local r, g, b, a = unpack(color)
            renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
            renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
            renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
            renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
            renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
            renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
            renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
        end,

        rec_outline = function(self, x, y, w, h, radius, thickness, color)
            radius = math.min(w/2, h/2, radius)
            local r, g, b, a = unpack(color)
            if radius == 1 then
                renderer.rectangle(x, y, w, thickness, r, g, b, a)
                renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
            else
                renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
                renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
                renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
                renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
                renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
                renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
                renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
                renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
            end
        end,

        glow_module = function(self, x, y, w, h, width, rounding, accent, accent_inner)
            local thickness = 1
            local offset = 1
            local r, g, b, a = unpack(accent)
            if accent_inner then
                self:rec(x , y, w, h + 1, rounding, accent_inner)
            end
            for k = 0, width do
                if a * (k/width)^(1) > 5 then
                    local accent = {r, g, b, a * (k/width)^(2)}
                    self:rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
                end
            end
        end,

        pandora_og = function(self, x,y,w,h,r,g,b,a, text)
            self:rec(x,y,w,h,3, {0,0,0,255})
            self:rec_outline(x + 1, y + 1, w - 2, h - 2, 3, 1, {45,45,45,255})
            self:rec(x + 3, y + 3, w - 6, h - 6, 2, {15,15,15,255})
            renderer.text(x + 5, y + 6, r,g,b,a, '', nil, text)
        end
    }

    ctx.helps = {
        speed = LPH_JIT_MAX(function()
            if not entity.get_local_player() then return end
            local first_velocity, second_velocity = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
            local speed = math.floor(math.sqrt(first_velocity*first_velocity+second_velocity*second_velocity))
            
            return speed
        end),
        get_state = LPH_JIT_MAX(function(speed)
            if not entity.is_alive(entity.get_local_player()) then return end
            local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
            local land = bit.band(flags, bit.lshift(1, 0)) ~= 0
            if land == true then ground_tick = ground_tick + 1 else ground_tick = 0 end
        
            if bit.band(flags, 1) == 1 then
                if ground_tick < 10 then if bit.band(flags, 4) == 4 then return "Aerobic+" else return "Aerobic" end end
                if bit.band(flags, 4) == 4 and speed > 9 then 
                    return "Duck+Move"
                end
                if bit.band(flags, 4) == 4 or ui.get(ref.fakeduck) then 
                    return "Duck" -- crouching
                else
                    if speed <= 3 then
                        return "Stand" -- standing
                    else
                        if ui.get(ref.slide[2]) then
                            return "Walking" -- slowwalk
                        else
                            return "Running" -- moving
                        end
                    end
                end
            elseif bit.band(flags, 1) == 0 then
                if bit.band(flags, 4) == 4 then
                    return "Aerobic+" -- air-c
                else
                    return "Aerobic" -- air
                end
            end
        end),
        get_team = LPH_JIT_MAX(function()
            local me = entity.get_local_player()
            if me == nil then return end
			local index = entity.get_prop(me, "m_iTeamNum")

			return index == 2 and "T" or "CT"
        end),
        is_defensive_active = LPH_JIT_MAX(function()
            local tickcount = globals.tickcount()
            local sim_time = toticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
            local sim_diff = sim_time - last_sim_time
            if sim_diff < 0 then
                defensive_until = globals.tickcount() + math.abs(sim_diff) - toticks(client.latency())
            end
            last_sim_time = sim_time
            return defensive_until > tickcount
        end)
    }

    ctx.antiaim = {
        run = LPH_JIT_MAX(function(cmd)
            local me = entity.get_local_player()
            if not entity.is_alive(me) then return end
            local bodyYaw = entity.get_prop(me, "m_flPoseParameter", 11) * 120 - 60
            local side = bodyYaw > 0 and 1 or -1

            local state = ctx.helps.get_state(ctx.helps.speed())
            if aa_builder[ctx.helps.get_team()][ctx.helps.get_state(ctx.helps.speed())].enable.value == false then state = "Global" end 
            local aa_values = aa_builder[ctx.helps.get_team()][state]

            if aa_values.enable.value then
                ui.set(ref.pitch,aa_values.pitch.value)

                desync_type = entity.get_prop(me, 'm_flPoseParameter', 11) * 120 - 60
                desync_side = desync_type > 0 and 1 or 0
            
                if globals.tickcount() > current_tickcount + aa_values.yaw_slider_delay.value then
                    if cmd.chokedcommands == 0 then
                       to_jitter = not to_jitter
                       current_tickcount = globals.tickcount()
                    end
                elseif globals.tickcount() <  current_tickcount then
                    current_tickcount = globals.tickcount()
                end
            
                ui.set(ref.yaw, aa_values.yaw.value)
                if aa_values.yaw_mode.value == "Default" then
                    ui.set(ref.yaw_value, aa_values.yaw_slider_static.value)
                elseif aa_values.yaw_mode.value == "l&r" then
                    if desync_side == 1 then
                        ui.set(ref.yaw_value, aa_values.yaw_slider_l.value)
                    else
                        ui.set(ref.yaw_value, aa_values.yaw_slider_r.value)
                    end
                else
                    if to_jitter then
                        ui.set(ref.yaw_value, aa_values.yaw_slider_l.value)
                        ui.set(ref.body_yaw_value, -1)
                    else
                        ui.set(ref.yaw_value, aa_values.yaw_slider_r.value)
                        ui.set(ref.body_yaw_value, 1)
                    end
                    ui.set(ref.body_yaw, "Static")
                end

                active_jit = cmd.command_number % client.random_int(3,6) == 1

                ui.set(ref.yaw_jitter, aa_values.mod_type.value)
                if aa_values.jitter_type.value == "Default" then
                    ui.set(ref.yaw_jitter_value, aa_values.mod_j.value)
                else
                    if not active_jit and desync_side == math.random(0, 1) then
                        ui.set(ref.yaw_jitter_value, aa_values.mod_r.value)
                    else
                        ui.set(ref.yaw_jitter_value, aa_values.mod_l.value)
                    end
                end
            
                if aa_values.yaw_mode.value ~= "Delayed Switch" then
                    ui.set(ref.body_yaw, aa_values.body_yaw.value)
                    ui.set(ref.body_yaw_value, aa_values.body_slider.value)
                end

                cmd.force_defensive = aa_values.force_def.value

                if aa_values.force_def.value and aa_values.defensive.value then
                    if ctx.helps.is_defensive_active() and cmd.chokedcommands == 1 then
                        if aa_values.defensive_yaw.value == "Spin" then
                            ui.set(ref.yaw, "Spin")
                            ui.set(ref.yaw_value, aa_values.spin.value)
                        elseif aa_values.defensive_yaw.value == "Side-Way" then
                            ui.set(ref.yaw_value, desync_side == 1 and 90 or -90)
                        elseif aa_values.defensive_yaw.value == "Random" then
                            ui.set(ref.yaw_value, math.random(-180, 180))
                        elseif aa_values.defensive_yaw.value == "Static" then
                            ui.set(ref.yaw_value, aa_values.yaw_amount.value)
                        end
            
                        ui.set(ref.pitch, "Custom") 
                        if aa_values.defensive_pitch.value == "Up" then
                            ui.set(ref.pitch_value, -89)
                        elseif aa_values.defensive_pitch.value == "Zero" then
                            ui.set(ref.pitch_value, 0)
                        elseif aa_values.defensive_pitch.value == "Random" then
                            ui.set(ref.pitch_value, math.random(-89, 89))
                        elseif aa_values.defensive_pitch.value == "Switch-Ways" then
                            ui.set(ref.pitch_value, desync_side == 1 and 49 or -49) 
                        elseif aa_values.defensive_pitch.value == "Progressive" then
                            ui.set(ref.pitch_value, (globals.tickcount() % 17)*10-89) 
                        elseif aa_values.defensive_pitch.value == "Custom" then
                            ui.set(ref.pitch_value, aa_values.pitch_amount.value) 
                        end
                    end
                end
            end

            -- other = {
            --     anti_b = group:checkbox("Anti-backstab"),
            --     safe_head = group:checkbox("Safe-Head"),
            --     freestanding = group:hotkey("Freestanding"),
            --     freestanding_disablers = group:multiselect("Freestanding disablers", antiaim_shits.condition)
            -- },
            --current_flickcount

            if contains(feelsense.other.freestanding_disablers.value, state) then
                ui.set(ref.freestand[1], false)
            else
                if feelsense.other.freestanding:get() == true then
                    ui.set(ref.freestand[1], true)
                    ui.set(ref.freestand[2], "Always on")
                else
                    ui.set(ref.freestand[1], false)
                    ui.set(ref.freestand[2], "On hotkey")
                end
            end

            if globals.tickcount() > current_flickcount + 4 then
                if cmd.chokedcommands >= 0 then
                    to_flick = not to_flick
                    current_flickcount = globals.tickcount()
                end
            elseif globals.tickcount() <  current_tickcount then
                current_flickcount = globals.tickcount()
            end

            if feelsense.other.freestanding:get() == true and feelsense.other.freestanding_defensive.value then
                if ctx.helps.is_defensive_active() and cmd.chokedcommands >= 0 then
                    local guwno_obliczenie = math.max(-60, math.min(60, math.floor((entity.get_prop(entity.get_local_player(),"m_flPoseParameter", 11) or 0)*120-60+0.5)))
                    if guwno_obliczenie > -8 then
                        --(to_flick)
                        ui.set(ref.yaw_value, 90)
                        ui.set(ref.freestand[1], to_flick)
                    end
                    if guwno_obliczenie > 8 then
                        --print(to_flick)
                        ui.set(ref.yaw_value, -90)
                        ui.set(ref.freestand[1], to_flick)
                    end
                end
            end

            if feelsense.other.safe_head.value == true then
                for i, v in pairs(entity.get_players(true)) do
                    local local_player_origin = vector(entity.get_origin(entity.get_local_player()))
                    local player_origin = vector(entity.get_origin(v))
                    local difference = (local_player_origin.z - player_origin.z)
                    local local_player_weapon = entity.get_classname(entity.get_player_weapon(entity.get_local_player()))
        
                    if (local_player_weapon == "CKnife" and state == "Aerobic+" and difference > -70) then    
                        ui.set(ref.pitch, "down")
                        ui.set(ref.yaw, "180")
                        ui.set(ref.yaw_value, -1)
                        ui.set(ref.yaw_base, "At targets")
                        ui.set(ref.yaw_jitter, "Off")
                        ui.set(ref.body_yaw, "Static")
                        ui.set(ref.body_yaw_value, 0)
                        ui.set(ref.freestand_body_yaw, false)
                    end
                end
            end
            
            if feelsense.other.anti_b.value == true then
                for i, v in pairs(entity.get_players(true)) do
                    local player_weapon = entity.get_classname(entity.get_player_weapon(v))
                    local player_distance = math.floor(vector(entity.get_origin(v)):dist(vector(entity.get_origin(entity.get_local_player()))) / 7)
        
                    if player_weapon == "CKnife" then
                        if player_distance < 25 then
                            ui.set(ref.yaw, "180")
                            ui.set(ref.yaw_value, -180)
                            ui.set(ref.yaw_base, "At targets")
                            ui.set(ref.yaw_jitter, "Off")
                        end
                    end
                end
            end
        end)
    }

    ctx.notify = {
        easeInOut = function(t)
			return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3;
		end,
        clamp = function(val, lower, upper)
			if lower > upper then lower, upper = upper, lower end
			return math.max(lower, math.min(upper, val))
		end,
        render = LPH_JIT_MAX(function()
            local Offset = 0
            for i, info_noti in ipairs(notify_data) do
                if i > 7 then
                    table.remove(notify_data, i)
                end

                if info_noti.text ~= nil and info_noti.text ~= "" then
                    if info_noti.timer + 4.1 < globals.realtime() then
                        info_noti.fraction = ctx.notify.clamp(info_noti.fraction - globals.frametime() / 0.3, 0, 1)
                    else
                        info_noti.fraction = ctx.notify.clamp(info_noti.fraction + globals.frametime() / 0.3, 0, 1)
                        info_noti.time_left = ctx.notify.clamp(info_noti.time_left + globals.frametime() / 4.1, 0, 1)
                    end
                end
                
                local fraction = ctx.notify.easeInOut(info_noti.fraction)
                
                local width = vector(renderer.measure_text("c", info_noti.text))
                local color = info_noti.color

                --ctx.m_render:pandora_og(X /2 - width.x /2, Y - 200 - 100 + 31 * i * fraction, width.x + 10, 25, color[1], color[2], color[3],255 * fraction, info_noti.text)

                ctx.m_render:glow_module(X /2 - width.x /2 - 10, Y - 200 - 100 + 31 * i * fraction, width.x + 28, 20, 10, 8, {color[1], color[2], color[3],60 * fraction}, {15,15,15,255 * fraction})
                renderer.text(X /2 - width.x /2 - 10 + 5, Y - 200 - 100 + 31 * i * fraction + 4, color[1], color[2], color[3],255*fraction, 'b', 0, "FS")
                renderer.text(X /2 - width.x /2 - 25 + 38, Y - 200 - 100 + 31 * i * fraction + 4, 255,255,255,255*fraction, '', 0, info_noti.text)

                if info_noti.timer + 4.3 < globals.realtime() then
                    table.remove(notify_data,i)
                end
            end
        end)
    }

    ctx.watermark = {
        colored = LPH_JIT_MAX(function(r,g,b,a, text, r2,g2,b2,a2) 
            return "\a"..rgba_to_hex(r,g,b,a)..text.."\a"..rgba_to_hex(r2,g2,b2,a2)
        end),
        round = LPH_JIT_MAX(function(num, numDecimalPlaces)
            local mult = 10^(numDecimalPlaces or 0)
            return math.floor(num * mult + 0.5) / mult
        end),
        draw = LPH_JIT_MAX(function()
            local r,g,b,a = feelsense.visuals.watermark:get_color()
            local systemtime = { client.system_time() }
            local time = ('%02d:%02d'):format(systemtime[1] % 12, systemtime[2])
            local jaki_format = systemtime[1] > 12 and "pm" or "am"
            local text = ("%s  / %s  %s ms %s %s"):format(ctx.watermark.colored(r,g,b,255, "feelsense ["..celestia.build.."]", 255,255,255,220), ctx.watermark.colored(255,255,255,255, celestia.username, 255,255,255,220), ctx.watermark.colored(r,g,b,255, ctx.watermark.round(client.latency() * 1000, 0), 255,255,255,220), ctx.watermark.colored(r,g,b,255, time, 255,255,255,220), ctx.watermark.colored(255,255,255,220, jaki_format, 255,255,255,220))
            local width = vector(renderer.measure_text("", text))


            if feelsense.visuals.watermark.value then
                ctx.m_render:pandora_og(X - width.x - 20, 10, width.x + 10, 25, 255,255,255,220, text)
            else
                local text = "F E E L "
                local text2 = "S E N S E"
                local width = vector(renderer.measure_text("", text .. text2))
                local color = versions[celestia.build][2]
                if feelsense.visuals.watermark_pos.value == "Left" then
                    renderer.text(20, Y / 2 - 50, 255,255,255,255, "", nil, "\a"..rgba_to_hex(color[1], color[2], color[3], 255)..text.. gradient_text(text2, 4, 190,190,190, 255).. " \a"..rgba_to_hex(color[1], color[2], color[3], 255)..versions[celestia.build][1])
                elseif feelsense.visuals.watermark_pos.value == "Right" then
                    renderer.text(X - 140, Y / 2 - 50, 255,255,255,255, "", nil, "\a"..rgba_to_hex(color[1], color[2], color[3], 255)..text.. gradient_text(text2, 4, 190,190,190, 255).. " \a"..rgba_to_hex(color[1], color[2], color[3], 255)..versions[celestia.build][1])
                elseif feelsense.visuals.watermark_pos.value == "Bottom" then
                    renderer.text(X / 2, Y - 10, 255,255,255,255, "c", nil, "\a"..rgba_to_hex(color[1], color[2], color[3], 255)..text.. gradient_text(text2, 4, 190,190,190, 255).. " \a"..rgba_to_hex(color[1], color[2], color[3], 255)..versions[celestia.build][1])
                end
            end
        end)
    }

    return ctx
end))()

function new_notify(string, r, g, b, a)
    local notification = {
        text = string,
        timer = globals.realtime(),
        color = { r, g, b, a },
        alpha = 0,
        fraction = 0,
        time_left = 0
    }

    if #notify_data == 0 then
        notification.y = Y + 20
    else
        local lastNotification = notify_data[#notify_data]
        notification.y = lastNotification.y + 20 
    end

    table.insert(notify_data, notification)
end

local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}

local function aim_hit(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local r,g,b,a = feelsense.visuals.hitlogs_enable:get_color()

    --https://docs.gamesense.gs/docs/events/aim_hit
    if contains(feelsense.visuals.hitlogs.value, "Hit") then
        new_notify(string.format("Hit %s in the %s for %d damage (%d health remaining)", entity.get_player_name(e.target), group, e.damage, entity.get_prop(e.target, "m_iHealth") ), r,g,b,255)
    end
end

client.set_event_callback("aim_hit", aim_hit)

local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}

local function aim_miss(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"

    if contains(feelsense.visuals.hitlogs.value, "Miss") then
        new_notify(string.format("Missed %s (%s) due to %s", entity.get_player_name(e.target), group, e.reason), 255,40,40,255)
    end
end

client.set_event_callback("aim_miss", aim_miss)

local weapon_to_verb = { knife = 'Knifed', hegrenade = 'Naded', inferno = 'Burned' }
client.set_event_callback('player_hurt', function(e)
    if not contains(feelsense.visuals.hitlogs.value, "Other") then return end
	
	local attacker_id = client.userid_to_entindex(e.attacker)

	if attacker_id == nil or attacker_id ~= entity.get_local_player() then
        return
    end

	if weapon_to_verb[e.weapon] ~= nil then
        local target_id = client.userid_to_entindex(e.userid)
		local target_name = entity.get_player_name(target_id)

		--print(string.format("%s %s for %i damage (%i remaining)", weapon_to_verb[e.weapon], string.lower(target_name), e.dmg_health, e.health))
		-- client.color_log(124, 252, 0, "aegis ~\0")
		-- client.color_log(200, 200, 200, string.format(" %s\0", weapon_to_verb[e.weapon]))
		-- client.color_log(124, 252, 0, string.format(" %s\0", target_name))
		-- client.color_log(200, 200, 200, " for\0")
		-- client.color_log(124, 252, 0, string.format(" %s\0", e.dmg_health))
		-- client.color_log(200, 200, 200, " damage\0")
		-- client.color_log(200, 200, 200, " (\0")
		-- client.color_log(124, 252, 0, string.format("%s\0", e.health))
		-- client.color_log(200, 200, 200, " health remaining)")

        local r,g,b,a = feelsense.visuals.hitlogs_enable:get_color()
        new_notify(weapon_to_verb[e.weapon].." "..target_name.. " for".." "..e.dmg_health.." damage", r,g,b,a)
	end
end)

client.set_event_callback("paint_ui", LPH_JIT_MAX(function()
    LPH_JIT_MAX(hide_refs(feelsense.main.enable_lua.value))
end))

client.set_event_callback("paint", LPH_JIT_MAX(function()
    LPH_JIT_MAX(ctx.watermark.draw())
    LPH_JIT_MAX(ctx.notify.render())
end))

client.set_event_callback("setup_command", LPH_JIT_MAX(function(cmd)
    LPH_JIT_MAX(ctx.antiaim.run(cmd))
end))
