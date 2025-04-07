local ffi = require("ffi")
local pui = require("gamesense/pui")
local vector = require("vector")
local http = require("gamesense/http")
local base64 = require("gamesense/base64")
local images = require("gamesense/images")
local clipboard = require("gamesense/clipboard")
local websocket = require("gamesense/websockets")
local json = require("json")

local obex_data = obex_fetch and obex_fetch() or {username = '.gg/rollmops & .gg/scriptleaks', build = 'best'}

renderer.rec = function(x, y, w, h, radius, color)
    radius = math.min(x/2, y/2, radius)
    local r, g, b, a = unpack(color)
    renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
    renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
    renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
    renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
    renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
    renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
    renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
end

renderer.rec_outline = function(x, y, w, h, radius, thickness, color)
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
end

renderer.shadow = function(x, y, w, h, width, rounding, accent, accent_inner)
	local thickness = 1
	local Offset = 1
	local r, g, b, a = unpack(accent)
	for k = 1, width do
		if a * (k/width)^(1) > 5 then
			local accent = {r, g, b, a * (k/width)^(2)}
			renderer.rec_outline(x + (k - width - Offset)*thickness, y + (k - width - Offset) * thickness, w - (k - width - Offset)*thickness*2, h + 1 - (k - width - Offset)*thickness*2, rounding + thickness * (width - k + Offset), thickness, accent)
		end
	end
end


local x_ind, y_ind = client.screen_size()

local lua_group = pui.group("aa", "anti-aimbot angles")
local other_group = pui.group("aa", "other")
pui.accent = "9FCA2BFF"

local aa_config = { '\vGlobal\r', '\vStand\r', '\vWalking\r', '\vRunning\r' , '\vAerobic\r', '\vAerobic+\r', '\vDuck\r', '\vDuck+Move\r' }
local aa_short = { '\vG\r', '\vS\r', '\vW\r', '\vR\r' , '\vA\r', '\vA+\r', '\vD\r', '\vD+M\r' }

local ref = {
    enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
	yawbase = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    fsbodyyaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
    edgeyaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
    fakeduck = ui.reference('RAGE', 'Other', 'Duck peek assist'),
    roll = { ui.reference('AA', 'Anti-aimbot angles', 'Roll') },
    hs = { ui.reference('AA',"other","on shot anti-aim")},
    dt = { ui.reference("RAGE","aimbot","Double tap")},
    --[1] = combobox/checkbox | [2] = slider/hotkey
    pitch = { ui.reference('AA', 'Anti-aimbot angles', 'pitch'), },
    rage = { ui.reference('RAGE', 'Aimbot', 'Enabled') },
    yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw') }, 
	yawjitter = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
	bodyyaw = { ui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
	freestand = { ui.reference('AA', 'Anti-aimbot angles', 'Freestanding') },
	slow = { ui.reference('AA', 'Other', 'Slow motion') }
}

local menu = {
    main = {
        enable_x = lua_group:checkbox("jitter"),
        enable = lua_group:checkbox("JITTER \v[DEV]"),
        tab = lua_group:combobox('\vJ · \rActive Tab', {"Main", "Anti-Aim", "Misc"}),
        label1 = lua_group:label("  \vJ · \rWelcome Back, \v"..obex_data.username),
        label2 = lua_group:label("  \vJ · \rLast Update - \v05.06.2024"),
    },
    antiaim = {
        aa_tab = lua_group:combobox('\vJ · \ranti~aim tab', {"Builder", "Other"}),
        aa_type = lua_group:combobox('\vJ · \rtype', {"gamesense", "exploit"}),
        addons = lua_group:multiselect('\vJ · \aFFC345FFAdditions', {'Shit AA On Warmup', 'Anti Backstab', "Safe head"}),
        yaw_direction = lua_group:multiselect('\vJ · \aFFC345FFYaw Directions', {'Freestanding', 'Manual AA'}),
        key_freestand = lua_group:hotkey('\vJ · \rFreestanding'),
        key_left = lua_group:hotkey('\vJ · \rManual Left'),
        key_right = lua_group:hotkey('\vJ · \rManual Right'),
        condition = lua_group:combobox('\vJ · \vCondition', aa_config),
    },
    misc = {
        fast_ladder = lua_group:checkbox("\vJ · \rFast Ladder"),
        log = lua_group:checkbox("\vJ · \rScreen Logs", {159, 202, 43}),
        arrows = lua_group:checkbox("\vJ · \rManual Arrows", {155, 155, 155}),
        debug_panel = lua_group:checkbox("\vJ · \rDebug Panel", {255,255,255}),
        defensive_peek = lua_group:checkbox("\vJ · \rDefensive Peek"),
        og_water = lua_group:checkbox("\vJ · \rAdditional Watermark", {255, 255, 255}),
        defensive_indicator = lua_group:checkbox("\vJ · \rDefensive Indicator", {255, 255, 255}),
        velocity_indicator = lua_group:checkbox("\vJ · \rVelocity Indicator", {255, 255, 255}),
        console_filter = lua_group:checkbox("\vJ · \rConsole Filter")
    },
}

local aa_gamesense = {}

for i=1, #aa_config do
    aa_gamesense[i] = {
        enable = lua_group:checkbox('override '..aa_config[i]),
        yaw_type = lua_group:combobox(aa_short[i]..' · yaw type', {"Default", "Slow"}),
        yaw_delay = lua_group:slider(aa_short[i]..' · delay', 1, 10, 4, true, 't', 1),
        yaw_left = lua_group:slider(aa_short[i]..' · yaw left', -180, 180, 0, true, '°', 1),
        yaw_right = lua_group:slider(aa_short[i]..' · yaw right', -180, 180, 0, true, '°', 1),
        mod_type = lua_group:combobox(aa_short[i]..' · jitter type', {'Off', 'Offset', 'Center', 'Random', 'Skitter'}),
        mod_dm = lua_group:slider(aa_short[i]..' · jitter', -180, 180, 0, true, '°', 1),
        body_yaw_type = lua_group:combobox(aa_short[i]..' · body yaw type', {'Off', 'Opposite', 'Jitter', 'Static'}),
        body_slider = lua_group:slider(aa_short[i]..' · body yaw amount', -180, 180, 0, true, '°', 1),
        freestanding_by = lua_group:checkbox(aa_short[i]..' · freestanding body yaw'),
        defensive = lua_group:checkbox(aa_short[i]..' · force defensive'),
        defensive_pitch = lua_group:combobox(aa_short[i]..' · defensive pitch', {'Disabled', 'Up', 'Zero', 'Random', 'Custom'}),
        pitch_amount = lua_group:slider(aa_short[i]..' · pitch amount', -89, 89, 0, true, '°', 1),
        defensive_yaw = lua_group:combobox(aa_short[i]..' · defensive yaw', {'Disabled', 'Sideways', 'Random', 'Spin', "3-Way", "5-Way", "L & R", "Custom"}),
        yaw_slider_def = lua_group:slider("\n ", 1, 200, 130, true, "%"),
        yaw_slider_custom_def = lua_group:slider("\n ", -180, 180, 130, true, "°"),
        yaw_left_def = lua_group:slider("Left", -100, 100, 0, true, "°"),
        yaw_right_def = lua_group:slider("Right", -100, 100, 0, true, "°"),
    }
end

local aa_builder = {}

for i=1, #aa_config do
    aa_builder[i] = {
        enable = lua_group:checkbox('Override '..aa_config[i]),
        options = lua_group:multiselect(aa_short[i]..' · \aFFC345FFOptions', {'Jitter Exploit', 'Randomize'}),
        yaw_type = lua_group:combobox(aa_short[i]..' · Yaw Type', {"Default", "Slow"}),
        yaw_delay = lua_group:slider(aa_short[i]..' · Delay', 1, 10, 4, true, 't', 1),
        yaw_left = lua_group:slider(aa_short[i]..' · Yaw Left', -180, 180, 0, true, '°', 1),
        yaw_right = lua_group:slider(aa_short[i]..' · Yaw Right', -180, 180, 0, true, '°', 1),
        yaw_precent = lua_group:slider(aa_short[i]..' · Yaw Randomize', 0, 100, 0, true, '%', 1),
        mod_type = lua_group:combobox(aa_short[i]..' · Modifier Type', {'Off', 'Offset', 'Center', 'Random', 'Skitter'}),
        mod_ticks = lua_group:slider(aa_short[i]..' · Ticks', 0, 3, 0, true, 't', 1),
        mod_dm = lua_group:slider(aa_short[i]..' · Jitter Default', -180, 180, 0, true, '°', 1),
        mod_precent = lua_group:slider(aa_short[i]..' · Randomize', 0, 100, 0, true, '%', 1),
        mod_adm = lua_group:slider(aa_short[i]..' · Jitter Active', -180, 180, 0, true, '°', 1),
        mod_aprecent = lua_group:slider(aa_short[i]..' · Active Randomize', 0, 100, 0, true, '%', 1),
        body_yaw_type = lua_group:combobox(aa_short[i]..' · Body Yaw Type', {'Off', 'Opposite', 'Jitter', 'Static'}),
        custom_desync = lua_group:slider(aa_short[i]..' · Custom Desync', -90, 90, 0, true, '°', 1),
        body_slider = lua_group:slider(aa_short[i]..' · Body Yaw Amount', -180, 180, 0, true, '°', 1),
    }
end

local jitter_access = {menu.main.enable_x, function() return true end}
local enable_check = {menu.main.enable, true}

local main_tab = {menu.main.tab, "Main"}
local aa_tab = {menu.main.tab, "Anti-Aim"}
local misc_tab = {menu.main.tab, "Misc"}
local aa_other = {menu.antiaim.aa_tab, "Other"}
local aa_tab_builder = {menu.antiaim.aa_tab, "Builder"}
local aa_type_gs = {menu.antiaim.aa_type, "gamesense"}
local aa_type_exp = {menu.antiaim.aa_type, "exploit"}

menu.main.enable_x:depend({menu.main.enable_x, function() return false end})
menu.main.enable:depend(jitter_access)

menu.main.tab:depend(jitter_access, enable_check)
menu.main.label1:depend(jitter_access, enable_check, main_tab)
menu.main.label2:depend(jitter_access, enable_check, main_tab)
menu.antiaim.aa_tab:depend(jitter_access, aa_tab, enable_check)
menu.antiaim.aa_type:depend(jitter_access, aa_tab, enable_check, aa_tab_builder)
menu.antiaim.addons:depend(jitter_access, aa_tab, enable_check, aa_other)
menu.antiaim.condition:depend(jitter_access, aa_tab, enable_check, aa_tab_builder)
menu.antiaim.yaw_direction:depend(jitter_access, enable_check, aa_other, aa_tab)
menu.antiaim.key_freestand:depend(jitter_access, enable_check, {menu.antiaim.yaw_direction, "Freestanding"}, aa_other, aa_tab)
menu.antiaim.key_left:depend(jitter_access, enable_check, {menu.antiaim.yaw_direction, "Manual AA"}, aa_other, aa_tab)
menu.antiaim.key_right:depend(jitter_access, enable_check, {menu.antiaim.yaw_direction, "Manual AA"}, aa_other, aa_tab)

menu.misc.fast_ladder:depend(jitter_access, enable_check, misc_tab)
menu.misc.log:depend(jitter_access, enable_check, misc_tab)
menu.misc.arrows:depend(jitter_access, enable_check, misc_tab)
menu.misc.og_water:depend(jitter_access, enable_check, misc_tab)
menu.misc.debug_panel:depend(jitter_access, enable_check, misc_tab)
menu.misc.defensive_peek:depend(jitter_access, enable_check, misc_tab)
menu.misc.velocity_indicator:depend(jitter_access, enable_check, misc_tab)
menu.misc.defensive_indicator:depend(jitter_access, enable_check, misc_tab)
menu.misc.console_filter:depend(jitter_access, enable_check, misc_tab)

for i=1, #aa_config do
    local cond_check = {menu.antiaim.condition, function() return (i ~= 1) end}
    local tab_cond = {menu.antiaim.condition, aa_config[i]}
    local cnd_en = {aa_builder[i].enable, function() if (i == 1) then return true else return aa_builder[i].enable:get() end end}
    local aa_tab = {menu.main.tab, "Anti-Aim"}
    local jit_ch = {aa_builder[i].mod_type, function() return aa_builder[i].mod_type:get() ~= "Off" end}
    local def_ch = {aa_builder[i].defensive_enable, true}
    local body_ch = {aa_builder[i].body_yaw_type, function() return aa_builder[i].body_yaw_type:get() ~= "Off" end}
    local random_ch = {aa_builder[i].options, 'Randomize'}
    local exploit_ch = {aa_builder[i].options, 'Jitter Exploit'}
    local delay_ch = {aa_builder[i].yaw_type, "Slow"}
    aa_builder[i].enable:depend(jitter_access, cond_check, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_exp)

    aa_builder[i].options:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_exp)
    aa_builder[i].yaw_type:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_exp)
    aa_builder[i].yaw_delay:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, delay_ch, aa_tab_builder, aa_type_exp)
    aa_builder[i].yaw_left:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_exp)
    aa_builder[i].yaw_right:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_exp)
    aa_builder[i].yaw_precent:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, random_ch, aa_tab_builder, aa_type_exp)
    aa_builder[i].mod_type:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_exp)
    aa_builder[i].mod_ticks:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, jit_ch, exploit_ch, aa_tab_builder, aa_type_exp)

    aa_builder[i].mod_dm:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, jit_ch, aa_tab_builder, aa_type_exp)
    aa_builder[i].mod_precent:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, jit_ch, random_ch, aa_tab_builder, aa_type_exp)

    aa_builder[i].mod_adm:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, jit_ch, exploit_ch, aa_tab_builder, aa_type_exp)
    aa_builder[i].mod_aprecent:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, jit_ch, random_ch, exploit_ch, aa_tab_builder, aa_type_exp)
    aa_builder[i].body_yaw_type:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_exp)
    aa_builder[i].custom_desync:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_exp)
    aa_builder[i].body_slider:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, body_ch, aa_tab_builder, aa_type_exp)
end

for i=1, #aa_config do
    local cond_check = {menu.antiaim.condition, function() return (i ~= 1) end}
    local tab_cond = {menu.antiaim.condition, aa_config[i]}
    local cnd_en = {aa_gamesense[i].enable, function() if (i == 1) then return true else return aa_gamesense[i].enable:get() end end}
    local aa_tab = {menu.main.tab, "Anti-Aim"}
    local jit_ch = {aa_gamesense[i].mod_type, function() return aa_gamesense[i].mod_type:get() ~= "Off" end}
    local def_ch = {aa_gamesense[i].defensive_enable, true}
    local body_ch = {aa_gamesense[i].body_yaw_type, function() return aa_gamesense[i].body_yaw_type:get() ~= "Off" end}
    local random_ch = {aa_gamesense[i].options, 'Randomize'}
    local exploit_ch = {aa_gamesense[i].options, 'Jitter Exploit'}
    local delay_ch = {aa_gamesense[i].yaw_type, "Slow"}
    aa_gamesense[i].enable:depend(jitter_access, cond_check, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_gs)

    aa_gamesense[i].yaw_type:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_gs)
    aa_gamesense[i].yaw_delay:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, delay_ch, aa_tab_builder, aa_type_gs)
    aa_gamesense[i].yaw_left:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_gs)
    aa_gamesense[i].yaw_right:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_gs)
    aa_gamesense[i].mod_type:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_gs)
    aa_gamesense[i].mod_dm:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, jit_ch, aa_tab_builder, aa_type_gs)
    aa_gamesense[i].body_yaw_type:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_gs)
    aa_gamesense[i].body_slider:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, body_ch, aa_tab_builder, aa_type_gs)
    aa_gamesense[i].freestanding_by:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_gs)
    aa_gamesense[i].defensive:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_gs)
    aa_gamesense[i].defensive_pitch:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_gs)
    aa_gamesense[i].pitch_amount:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_gs, {aa_gamesense[i].defensive_pitch, "Custom"})
    aa_gamesense[i].defensive_yaw:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_gs)
    aa_gamesense[i].yaw_slider_custom_def:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_gs, {aa_gamesense[i].defensive_yaw, "Custom"})
    aa_gamesense[i].yaw_right_def:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_gs, {aa_gamesense[i].defensive_yaw, "L & R"})
    aa_gamesense[i].yaw_left_def:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_gs, {aa_gamesense[i].defensive_yaw, "L & R"})
    aa_gamesense[i].yaw_slider_def:depend(jitter_access, cnd_en, tab_cond, aa_tab, enable_check, aa_tab_builder, aa_type_gs, {aa_gamesense[i].defensive_yaw, "Spin"})
end

local function hide_original_menu(state)
    ui.set_visible(ref.enabled, state)
    ui.set_visible(ref.pitch[1], state)
    ui.set_visible(ref.pitch[2], state)
    ui.set_visible(ref.yawbase, state)
    ui.set_visible(ref.yaw[1], state)
    ui.set_visible(ref.yaw[2], state)
    ui.set_visible(ref.yawjitter[1], state)
	ui.set_visible(ref.roll[1], state)
    ui.set_visible(ref.yawjitter[2], state)
    ui.set_visible(ref.bodyyaw[1], state)
    ui.set_visible(ref.bodyyaw[2], state)
    ui.set_visible(ref.fsbodyyaw, state)
    ui.set_visible(ref.edgeyaw, state)
    ui.set_visible(ref.freestand[1], state)
    ui.set_visible(ref.freestand[2], state)
end

local function randomize_value(original_value, percent)
    local min_range = original_value - (original_value * percent / 100)
    local max_range = original_value + (original_value * percent / 100)
    return math.random(min_range, max_range)
end

local last_sim_time = 0
local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')
function is_defensive_active()
    local lp = entity.get_local_player()
    if lp == nil or not entity.is_alive(lp) then return end
    local m_flOldSimulationTime = ffi.cast("float*", ffi.cast("uintptr_t", native_GetClientEntity(lp)) + 0x26C)[0]
    local m_flSimulationTime = entity.get_prop(lp, "m_flSimulationTime")
    local delta = toticks(m_flOldSimulationTime - m_flSimulationTime)
    if delta > 0 then
        last_sim_time = globals.tickcount() + delta - toticks(client.real_latency())
    end
    return last_sim_time > globals.tickcount()
end

local function is_vulnerable()
    for _, v in ipairs(entity.get_players(true)) do
        local flags = (entity.get_esp_data(v)).flags
        if bit.band(flags, bit.lshift(1, 11)) ~= 0 then
            return true
        end
    end
    return false
end

local id = 1 
local id1 = 1  
local debug_state = "Global"

local function player_state(cmd)
    local lp = entity.get_local_player()
    if lp == nil then return end

    vecvelocity = { entity.get_prop(lp, 'm_vecVelocity') }
    flags = entity.get_prop(lp, 'm_fFlags')
    velocity = math.sqrt(vecvelocity[1]^2+vecvelocity[2]^2)
    groundcheck = bit.band(flags, 1) == 1
    jumpcheck = bit.band(flags, 1) == 0 or cmd.in_jump == 1
    ducked = entity.get_prop(lp, 'm_flDuckAmount') > 0.7
    duckcheck = ducked or ui.get(ref.fakeduck)
    slowwalk_key = ui.get(ref.slow[1]) and ui.get(ref.slow[2])

    if jumpcheck and duckcheck then return "Air+C"
    elseif jumpcheck then return "Air"
    elseif duckcheck and velocity > 10 then return "Duck-Moving"
    elseif duckcheck and velocity < 10 then return "Duck"
    elseif groundcheck and slowwalk_key and velocity > 10 then return "Walking"
    elseif groundcheck and velocity > 5 then return "Moving"
    elseif groundcheck and velocity < 5 then return "Stand"
    else return "Global" end
end

local yaw_direction = 0
local last_press_t_dir = 0

local run_direction = function()
    if not menu.antiaim.yaw_direction:get("Manual AA") then
        yaw_direction = 0
        return 
    end

    if yaw_direction ~= 0 then
        ui.set(ref.freestand[1], false)
    end

	if menu.antiaim.yaw_direction:get("Manual AA") and menu.antiaim.key_right:get() and last_press_t_dir + 0.2 < globals.curtime() then
		yaw_direction = yaw_direction == 90 and 0 or 90
		last_press_t_dir = globals.curtime()
	elseif menu.antiaim.yaw_direction:get("Manual AA") and menu.antiaim.key_left:get() and last_press_t_dir + 0.2 < globals.curtime() then
		yaw_direction = yaw_direction == -90 and 0 or -90
		last_press_t_dir = globals.curtime()
	elseif last_press_t_dir > globals.curtime() then
		last_press_t_dir = globals.curtime()
    end
end

local menu_r, menu_g, menu_b, menu_a = 255,255,255,255
local notify=(function()local b=vector;local c=function(d,b,c)return d+(b-d)*c end;local e=function()return b(client.screen_size())end;local f=function(d,...)local c={...}local c=table.concat(c,"")return b(renderer.measure_text(d,c))end;local g={notifications={bottom={}},max={bottom=6}}g.__index=g;g.new_bottom=function(...)table.insert(g.notifications.bottom,{started=false,instance=setmetatable({active=false,timeout=5,color={["r"]=menu_r,["g"]=menu_g,["b"]=menu_b,a=0},x=e().x/2,y=e().y,text=...},g)})end;function g:handler()local d=0;local b=0;for d,b in pairs(g.notifications.bottom)do if not b.instance.active and b.started then table.remove(g.notifications.bottom,d)end end;for d=1,#g.notifications.bottom do if g.notifications.bottom[d].instance.active then b=b+1 end end;for c,e in pairs(g.notifications.bottom)do if c>g.max.bottom then return end;if e.instance.active then e.instance:render_bottom(d,b)d=d+1 end;if not e.started then e.instance:start()e.started=true end end end;function g:start()self.active=true;self.delay=globals.realtime()+self.timeout end;function g:get_text()local d=""for b,b in pairs(self.text)do local c=f("",b[1])local c,e,f=255,255,255;if b[2]then c,e,f=menu_r,menu_g,menu_b end;d=d..("\a%02x%02x%02x%02x%s"):format(c,e,f,self.color.a,b[1])end;return d end;local h=(function()local d={}d.rec=function(d,b,c,e,f,g,h,i,j)j=math.min(d/2,b/2,j)renderer.rectangle(d,b+j,c,e-j*2,f,g,h,i)renderer.rectangle(d+j,b,c-j*2,j,f,g,h,i)renderer.rectangle(d+j,b+e-j,c-j*2,j,f,g,h,i)renderer.circle(d+j,b+j,f,g,h,i,j,180,.25)renderer.circle(d-j+c,b+j,f,g,h,i,j,90,.25)renderer.circle(d-j+c,b-j+e,f,g,h,i,j,0,.25)renderer.circle(d+j,b-j+e,f,g,h,i,j,-90,.25)end;d.rec_outline=function(d,b,c,e,f,g,h,i,j,k)j=math.min(c/2,e/2,j)if j==1 then renderer.rectangle(d,b,c,k,f,g,h,i)renderer.rectangle(d,b+e-k,c,k,f,g,h,i)else renderer.rectangle(d+j,b,c-j*2,k,f,g,h,i)renderer.rectangle(d+j,b+e-k,c-j*2,k,f,g,h,i)renderer.rectangle(d,b+j,k,e-j*2,f,g,h,i)renderer.rectangle(d+c-k,b+j,k,e-j*2,f,g,h,i)renderer.circle_outline(d+j,b+j,f,g,h,i,j,180,.25,k)renderer.circle_outline(d+j,b+e-j,f,g,h,i,j,90,.25,k)renderer.circle_outline(d+c-j,b+j,f,g,h,i,j,-90,.25,k)renderer.circle_outline(d+c-j,b+e-j,f,g,h,i,j,0,.25,k)end end;d.glow_module_notify=function(b,c,e,f,g,h,i,j,k,l,m,n,o,p,p)local q=1;local r=1;if p then d.rec(b,c,e,f,i,j,k,l,h)end;for i=0,g do local j=l/2*(i/g)^3;d.rec_outline(b+(i-g-r)*q,c+(i-g-r)*q,e-(i-g-r)*q*2,f-(i-g-r)*q*2,m,n,o,j/1.5,h+q*(g-i+r),q)end end;return d end)()function g:render_bottom(g,i)local e=e()local j=6;local k="     "..self:get_text()local f=f("",k)local l=8;local m=5;local n=0+j+f.x;local n,o=n+m*2,12+10+1;local p,q=self.x-n/2,math.ceil(self.y-40+.4)local r=globals.frametime()if globals.realtime()<self.delay then self.y=c(self.y,e.y-45-(i-g)*o*1.4,r*7)self.color.a=c(self.color.a,255,r*2)else self.y=c(self.y,self.y-10,r*15)self.color.a=c(self.color.a,0,r*20)if self.color.a<=1 then self.active=false end end;local c,e,g,i=self.color.r,self.color.g,self.color.b,self.color.a;h.glow_module_notify(p,q,n,o,15,l,25,25,25,i,menu_r,menu_g,menu_b,i,true)local h=m;h=h+0+j;renderer.text(p+h,q+o/2-f.y/2,menu_r,menu_g,menu_b,i,"b",nil,"JT")renderer.text(p+h,q+o/2-f.y/2,c,e,g,i,"",nil,k)end;client.set_event_callback("paint_ui",function()g:handler()end)return g end)()

anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

local current_tickcount = 0
local to_jitter = false
function normalize_yaw(yaw) yaw = (yaw % 360 + 360) % 360 return yaw > 180 and yaw - 360 or yaw end

local function aa_setup(cmd)
    local lp = entity.get_local_player()
    if lp == nil then return end
    debug_state = player_state(cmd)
    if player_state(cmd) == "Duck-Moving" and aa_builder[8].enable:get() then id = 8
    elseif player_state(cmd) == "Duck" and aa_builder[7].enable:get() then id = 7
    elseif player_state(cmd) == "Air+C" and aa_builder[6].enable:get() then id = 6
    elseif player_state(cmd) == "Air" and aa_builder[5].enable:get() then id = 5
    elseif player_state(cmd) == "Moving" and aa_builder[4].enable:get() then id = 4
    elseif player_state(cmd) == "Walking" and aa_builder[3].enable:get() then id = 3
    elseif player_state(cmd) == "Stand" and aa_builder[2].enable:get() then id = 2
    else id = 1 end

    if player_state(cmd) == "Duck-Moving" and aa_gamesense[8].enable:get() then id1 = 8
    elseif player_state(cmd) == "Duck" and aa_gamesense[7].enable:get() then id1 = 7
    elseif player_state(cmd) == "Air+C" and aa_gamesense[6].enable:get() then id1 = 6
    elseif player_state(cmd) == "Air" and aa_gamesense[5].enable:get() then id1 = 5
    elseif player_state(cmd) == "Moving" and aa_gamesense[4].enable:get() then id1 = 4
    elseif player_state(cmd) == "Walking" and aa_gamesense[3].enable:get() then id1 = 3
    elseif player_state(cmd) == "Stand" and aa_gamesense[2].enable:get() then id1 = 2
    else id1 = 1 end

    run_direction()
    if aa_builder[id].custom_desync:get() ~= 0 then
        entity.set_prop(lp, "m_flLowerBodyYawTarget", aa_builder[id].custom_desync:get())
    end

    if menu.antiaim.aa_type:get() == "exploit" then
        if globals.tickcount() > current_tickcount + aa_builder[id].yaw_delay:get() then
            if cmd.chokedcommands == 0 then
               to_jitter = not to_jitter
               current_tickcount = globals.tickcount()
            end
        elseif globals.tickcount() <  current_tickcount then
            current_tickcount = globals.tickcount()
        end

        ui.set(ref.yawjitter[1], aa_builder[id].mod_type:get())
        ui.set(ref.fsbodyyaw, false)
        ui.set(ref.pitch[1], "Down")
        ui.set(ref.yawbase, "At targets")
        ui.set(ref.yaw[1], '180')
        ui.set(ref.roll[1], 0)

        if aa_builder[id].yaw_type:get() == "Slow" then
            ui.set(ref.bodyyaw[1], "Static")
            ui.set(ref.bodyyaw[2], to_jitter and 1 or -1)
        else
            ui.set(ref.bodyyaw[1], aa_builder[id].body_yaw_type:get())
            ui.set(ref.bodyyaw[2], aa_builder[id].body_slider:get())
        end

        cmd.force_defensive = aa_builder[id].options:get("Jitter Exploit")

        local desync_type = entity.get_prop(lp, 'm_flPoseParameter', 11) * 120 - 60
        local desync_side = desync_type > 0

        local yaw_amount = aa_builder[id].options:get("Randomize") and (desync_side and randomize_value(aa_builder[id].yaw_left:get(), aa_builder[id].yaw_precent:get()) or randomize_value(aa_builder[id].yaw_right:get(), aa_builder[id].yaw_precent:get())) or desync_side and aa_builder[id].yaw_left:get() or aa_builder[id].yaw_right:get()
        ui.set(ref.yaw[2], yaw_direction == 0 and yaw_amount or yaw_direction)

        local active_jit = is_defensive_active() and cmd.command_number % math.random(3, 6) > aa_builder[id].mod_ticks:get()

        if active_jit and aa_builder[id].options:get("Jitter Exploit") then
            ui.set(ref.yawjitter[2], aa_builder[id].options:get("Randomize") and randomize_value(aa_builder[id].mod_adm:get(), aa_builder[id].mod_aprecent:get()) or aa_builder[id].mod_adm:get())
        else
            ui.set(ref.yawjitter[2], aa_builder[id].options:get("Randomize") and randomize_value(aa_builder[id].mod_dm:get(), aa_builder[id].mod_precent:get()) or aa_builder[id].mod_dm:get())
        end
    else

        if globals.tickcount() > current_tickcount + aa_gamesense[id1].yaw_delay:get() then
            if cmd.chokedcommands == 0 then
               to_jitter = not to_jitter
               current_tickcount = globals.tickcount()
            end
        elseif globals.tickcount() <  current_tickcount then
            current_tickcount = globals.tickcount()
        end

        ui.set(ref.yawjitter[1], aa_gamesense[id1].mod_type:get())
        ui.set(ref.fsbodyyaw, aa_gamesense[id1].freestanding_by:get())
        ui.set(ref.pitch[1], "Down")
        ui.set(ref.yawbase, "At targets")
        ui.set(ref.yaw[1], '180')
        ui.set(ref.roll[1], 0)

        if aa_gamesense[id1].yaw_type:get() == "Slow" then
            ui.set(ref.bodyyaw[1], "Static")
            ui.set(ref.bodyyaw[2], to_jitter and 1 or -1)
        else
            ui.set(ref.bodyyaw[1], aa_gamesense[id1].body_yaw_type:get())
            ui.set(ref.bodyyaw[2], aa_gamesense[id1].body_slider:get())
        end

        cmd.force_defensive = aa_gamesense[id1].defensive:get()

        local desync_type = entity.get_prop(lp, 'm_flPoseParameter', 11) * 120 - 60
        local desync_side = desync_type > 0

        local yaw_amount = desync_side and aa_gamesense[id1].yaw_left:get() or aa_gamesense[id1].yaw_right:get()
        ui.set(ref.yaw[2], yaw_direction == 0 and yaw_amount or yaw_direction)
        ui.set(ref.yawjitter[2], aa_gamesense[id1].mod_dm:get())

        local pitch_tbl = {
            ['Disabled'] = 89,
            ['Up'] = -89,
            ['Zero'] = 0,
            ['Random'] = math.random(-89, 89),
            ['Custom'] = aa_gamesense[id1].pitch_amount:get()
        }
        
        local yaw_tbl = {
            ['Disabled'] = 0,
            ['Sideways'] = globals.tickcount() % 3 == 0 and client.random_int(-100, -90) or globals.tickcount() % 3 == 1 and 180 or globals.tickcount() % 3 == 2 and client.random_int(90, 100) or 0,
            ['Random'] = math.random(-180, 180),
            ['Spin'] = normalize_yaw(globals.curtime() * 1000 * (aa_gamesense[id1].yaw_slider_def:get() / 100)),
            ['3-Way'] = globals.tickcount() % 3 == 0 and client.random_int(-110, -90) or globals.tickcount() % 3 == 1 and client.random_int(90, 120) or globals.tickcount() % 3 == 2 and client.random_int(-180, -150) or 0,
            ['5-Way'] = globals.tickcount() % 5 == 0 and client.random_int(-90, -75) or globals.tickcount() % 5 == 1 and client.random_int(-45, -30) or globals.tickcount() % 5 == 2 and client.random_int(-180, -160) or globals.tickcount() % 5 == 3 and client.random_int(45, 60) or globals.tickcount() % 5 == 3 and client.random_int(90, 110) or 0,
            ['L & R'] = desync_side and aa_gamesense[id1].yaw_left_def:get() or aa_gamesense[id1].yaw_right_def:get(),
            ['Custom'] = aa_gamesense[id1].yaw_slider_custom_def:get()
        }

        if is_defensive_active() then
            if is_defensive_active() then
                ui.set(ref.pitch[1], "Custom")
                ui.set(ref.pitch[2], pitch_tbl[aa_gamesense[id1].defensive_pitch:get()])
    
                ui.set(ref.yaw[1], '180')
                ui.set(ref.yaw[2], yaw_tbl[aa_gamesense[id1].defensive_yaw:get()])
            end
        end
    end

    local players = entity.get_players(true)
    if menu.antiaim.addons:get("Shit AA On Warmup") then
        if entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod") == 1 then
            ui.set(ref.yaw[2], math.random(-180, 180))
            ui.set(ref.yawjitter[2], math.random(-180, 180))
            ui.set(ref.bodyyaw[2], math.random(-180, 180))
            ui.set(ref.pitch[1], "Custom")
            ui.set(ref.pitch[2], math.random(-89, 89)) 
        end
    end

    if menu.antiaim.addons:get("Safe head") then
        for i, v in pairs(players) do
            local local_player_origin = vector(entity.get_origin(entity.get_local_player()))
            local player_origin = vector(entity.get_origin(v))
            local difference = (local_player_origin.z - player_origin.z)
            local local_player_weapon = entity.get_classname(entity.get_player_weapon(entity.get_local_player()))

            --print(local_player_weapon)

            if (local_player_weapon == "CKnife" and id == 6 or id1 == 6) then    
                ui.set(ref.pitch[1], "down")
                ui.set(ref.yaw[1], "180")
                ui.set(ref.yaw[2], -1)
                ui.set(ref.yawbase, "At targets")
                ui.set(ref.yawjitter[1], "Off")
                ui.set(ref.bodyyaw[1], "Static")
                ui.set(ref.bodyyaw[2], 0)
            end
        end
    end

    if menu.antiaim.addons:get("Anti Backstab") then
        lp_orig_x, lp_orig_y, lp_orig_z = entity.get_prop(lp, "m_vecOrigin")
        for i=1, #players do
            if players == nil then return end
            enemy_orig_x, enemy_orig_y, enemy_orig_z = entity.get_prop(players[i], "m_vecOrigin")
            distance_to = anti_knife_dist(lp_orig_x, lp_orig_y, lp_orig_z, enemy_orig_x, enemy_orig_y, enemy_orig_z)
            weapon = entity.get_player_weapon(players[i])
            if weapon == nil then return end
            if entity.get_classname(weapon) == "CKnife" and distance_to <= 250 then
                ui.set(ref.yaw[2], 180)
                ui.set(ref.yawbase, "At targets")
            end
        end
    end

    ui.set(ref.freestand[1], menu.antiaim.yaw_direction:get("Freestanding"))
    ui.set(ref.freestand[2], menu.antiaim.key_freestand:get() and 'Always on' or 'On hotkey')

    if menu.misc.defensive_peek:get() then
        flags = entity.get_prop(lp, 'm_fFlags')
        if is_vulnerable() and bit.band(flags, 1) == 1 and cmd.in_jump == 0 then
            cmd.force_defensive = true
        end
    end
end

local screen = {client.screen_size()}
local center = {screen[1]/2, screen[2]/2} 

math.lerp = function(name, value, speed)
    return name + (value - name) * globals.absoluteframetime() * speed
end

renderer.log = function(text, icon, r, g, b)
    menu_r, menu_g, menu_b, menu_a = menu.misc.log:get_color()
    notify.new_bottom({ { text }, {" ", true} })
end

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}

local function aim_hit(e)
    if not menu.misc.log:get() then return end
	local group = hitgroup_names[e.hitgroup + 1] or '?'
    menu_r, menu_g, menu_b, menu_a = menu.misc.log:get_color()
    notify.new_bottom({ { "Hit " }, {entity.get_player_name(e.target), true}, {" in the "}, {group, true}, {" for "}, {e.damage, true}, {" "} })
end
client.set_event_callback('aim_hit', aim_hit)

local function aim_miss(e)
    if not menu.misc.log:get() then return end
	local group = hitgroup_names[e.hitgroup + 1] or '?'
    menu_r, menu_g, menu_b, menu_a = menu.misc.log:get_color()
    notify.new_bottom({ { "Missed " }, {entity.get_player_name(e.target), true}, {" in the "}, {group, true}, {" due to "}, {e.reason, true}, {". hs: "}, {math.floor(e.hit_chance), true} })
   -- renderer.log(string.format('Missed %s in the %s due to %s. hs: %s', entity.get_player_name(e.target), group, e.reason, math.floor(e.hit_chance)), "⚠ ", 255, 42, 42)
end
client.set_event_callback('aim_miss', aim_miss)


local lastmiss = 0
local function GetClosestPoint(A, B, P)
    a_to_p = { P[1] - A[1], P[2] - A[2] }
    a_to_b = { B[1] - A[1], B[2] - A[2] }

    atb2 = a_to_b[1]^2 + a_to_b[2]^2

    atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
    t = atp_dot_atb / atb2
    
    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
end

client.set_event_callback("bullet_impact", function(e)  
    if not menu.misc.log:get() then return end
    if not entity.is_alive(entity.get_local_player()) then return end
    local ent = client.userid_to_entindex(e.userid)
    if ent ~= client.current_threat() then return end
    if entity.is_dormant(ent) or not entity.is_enemy(ent) then return end

    local ent_origin = { entity.get_prop(ent, "m_vecOrigin") }
    ent_origin[3] = ent_origin[3] + entity.get_prop(ent, "m_vecViewOffset[2]")
    local local_head = { entity.hitbox_position(entity.get_local_player(), 0) }
    local closest = GetClosestPoint(ent_origin, { e.x, e.y, e.z }, local_head)
    local delta = { local_head[1]-closest[1], local_head[2]-closest[2] }
    local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)

    if bruteforce then return end
    if math.abs(delta_2d) <= 60 and globals.curtime() - lastmiss > 0.015 then
        lastmiss = globals.curtime()
        shot_time = globals.realtime()
        renderer.log(entity.get_player_name(ent).." Shot At You", "⚠ ", 108, 255, 98)
    end
end)

local function fastladder(e)
    local local_player = entity.get_local_player()
    local pitch, yaw = client.camera_angles()
    if entity.get_prop(local_player, "m_MoveType") == 9 then
        e.yaw = math.floor(e.yaw+0.5)
        e.roll = 0
            if e.forwardmove == 0 then
                if e.sidemove ~= 0 then
                    e.pitch = 89
                    e.yaw = e.yaw + 180
                    if e.sidemove < 0 then
                        e.in_moveleft = 0
                        e.in_moveright = 1
                    end
                    if e.sidemove > 0 then
                        e.in_moveleft = 1
                        e.in_moveright = 0
                    end
                end
            end
            if e.forwardmove > 0 then
                if pitch < 45 then
                    e.pitch = 89
                    e.in_moveright = 1
                    e.in_moveleft = 0
                    e.in_forward = 0
                    e.in_back = 1
                    if e.sidemove == 0 then
                        e.yaw = e.yaw + 90
                    end
                    if e.sidemove < 0 then
                        e.yaw = e.yaw + 150
                    end
                    if e.sidemove > 0 then
                        e.yaw = e.yaw + 30
                    end
                end 
            end
            if e.forwardmove < 0 then
                e.pitch = 89
                e.in_moveleft = 1
                e.in_moveright = 0
                e.in_forward = 1
                e.in_back = 0
                if e.sidemove == 0 then
                    e.yaw = e.yaw + 90
                end
                if e.sidemove > 0 then
                    e.yaw = e.yaw + 150
                end
                if e.sidemove < 0 then
                    e.yaw = e.yaw + 30
                end
            end
    end
end


local screensize_x, screensize_y = client.screen_size()

local def_alpha = 0
local vel_alpha = 0
local function render_defensive()
    local lp = entity.get_local_player()
    if not lp then return end
    if not entity.is_alive(lp) then return end

    local r,g,b,a = menu.misc.defensive_indicator:get_color()

    def_alpha = math.lerp(def_alpha, is_defensive_active() and 1 or 0, 20)

    renderer.shadow(screensize_x/2-50, screensize_y/3, 100, 5, 5, 0, {r,g,b, 100*def_alpha})

    renderer.text(screensize_x/2, screensize_y/3-15, 255, 255, 255, 255*def_alpha, "c-b", 0, "- defensive -")
    renderer.rectangle(screensize_x/2-50, screensize_y/3, 100, 5, 20, 20, 20, 255*def_alpha)
    renderer.rectangle(screensize_x/2-49, screensize_y/3+1, 98*def_alpha, 3, r,g,b, 255*def_alpha)
end

local function render_velocity()
    local lp = entity.get_local_player()
    if not lp then return end
    if not entity.is_alive(lp) then return end
    local vel_mod = entity.get_prop(lp, "m_flVelocityModifier")

    local r,g,b,a = menu.misc.velocity_indicator:get_color()

    vel_alpha = math.lerp(vel_alpha, vel_mod ~= 1 and 1 or 0, 20)
    renderer.shadow(screensize_x/2-50, screensize_y/4, 100, 5, 5, 0, {r,g,b, 100*vel_alpha})
    renderer.text(screensize_x/2, screensize_y/4-15, 255, 255, 255, 255*vel_alpha, "c-b", 0, "- velocity -")
    renderer.rectangle(screensize_x/2-50, screensize_y/4, 100, 5, 20, 20, 20, 255*vel_alpha)
    renderer.rectangle(screensize_x/2-49, screensize_y/4+1, 98*vel_mod, 3, r,g,b, 255*vel_alpha)
end

round = function(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function debug_panel()
    local lp = entity.get_local_player()
    if lp == nil then return end
    local threat = client.current_threat()
    local threat_name = "unknown"
    local r,g,b,a = menu.misc.debug_panel:get_color()
    local enemy_lby = 0
    if threat then
        threat_name = entity.get_player_name(threat)
        enemy_lby = math.floor(entity.get_prop(threat, 'm_flPoseParameter', 11) * 120 - 60)
    end
    -- renderer.gradient(20, screensize_y/2 + 15, textsizex/2, 2, 255, 255, 255, 50, 255, 255, 255, 255, true)
    -- renderer.gradient(20 + textsizex/2,screensize_y/2 + 15, textsizex/2, 2, 255, 255, 255, 255, 255, 255, 255, 50, true)
    -- renderer.text(20, screensize_y/2 + textsizey*1.5, 255, 255, 255, 255, "d", 0, "user: "..current_pc.username:sub(1, 12))

    local text = "Jitter  ["..obex_data.build.."]  |  "..obex_data.username.."  |  "..round(client.latency() * 1000, 0).."ms"
    local width = vector(renderer.measure_text("-",string.upper(text)))
    X = 10
    renderer.gradient(X, screensize_y/2 + 25, width.x / 2 + 7, width.y + 5, 0,0,0,0, 0,0,0,140, true)
    renderer.gradient(X + width.x / 2 + 7, screensize_y/2 + 25, width.x / 2 + 7, width.y + 5, 0,0,0,140, 0,0,0,0, true)
    renderer.gradient(X + width.x / 2 + 7, screensize_y/2 + 25 + width.y + 6, width.x / 2 + 7, 1, r,g,b,255, r,g,b,0, true)
    renderer.gradient(X, screensize_y/2 + 25 + width.y + 6, width.x /2 + 7, 1, r,g,b,0, r,g,b,255, true)
    renderer.text(X + 5, screensize_y/2 + 25 + 3, 255, 255, 255, 255, "-", 0, string.upper(text))
    renderer.text(X + 5, screensize_y/2 + 25 + width.y + 9, 255, 255, 255, 255, "-", 0, string.upper("state: "..debug_state))
    if threat then
        renderer.text(X + 5, screensize_y/2 + 25 + width.y + 18, 255, 255, 255, 255, "-", 0, string.upper("target: "..threat_name:sub(1, 12).." "..enemy_lby.."°"))
    end
end

local rgba_to_hex = function(r, g, b, a)
    return string.format('%02x%02x%02x%02x', r, g, b, a)
end

local function og_water()
    local lp = entity.get_local_player()
    if not lp then return end
    if not entity.is_alive(lp) then return end
    local r,g,b,a = menu.misc.og_water:get_color()
    local wtr_color = rgba_to_hex(r,g,b,255)
    local steamid = entity.get_steam64(lp)
    local steam_avatar = images.get_steam_avatar(steamid)
    renderer.gradient(screensize_x-140, 0, 140, 50, r,g,b, 0, r,g,b, 200, true)
    renderer.text(screensize_x-120, 5, 255, 255, 255, 255, "b", 0, "jitter \a"..wtr_color.."[dev]")
    renderer.text(screensize_x-120, 18, 255, 255, 255, 255, "", 0, "build: \a"..wtr_color..string.lower(obex_data.build))
    renderer.text(screensize_x-120, 30, 255, 255, 255, 255, "", 0, "user: \a"..wtr_color..obex_data.username:sub(1, 7))
    steam_avatar:draw(screensize_x-45, 30 - 25, 40, 40, 255, 255, 255, 255)
end

local function render_arrows()
    local lp = entity.get_local_player()
    if not lp then return end
    if not entity.is_alive(lp) then return end
    local r,g,b,a = menu.misc.arrows:get_color()
    if yaw_direction == -90 then
        renderer.text(screensize_x/2 - 50, screensize_y/2, 255, 255, 255, 255, "c+", 0, "<")
    else
        renderer.text(screensize_x/2 - 50, screensize_y/2, r,g,b,a, "c+", 0, "<")
    end
    if yaw_direction == 90 then
        renderer.text(screensize_x/2 + 50, screensize_y/2, 255, 255, 255, 255, "c+", 0, ">")
    else
        renderer.text(screensize_x/2 + 50, screensize_y/2, r,g,b,a, "c+", 0, ">")
    end
end

local config_items = {menu, aa_builder, aa_gamesense}

local package, data, encrypted, decrypted = pui.setup(config_items), "", "", ""
config = {}

config.export = function()
    data = package:save()
    encrypted = base64.encode(json.stringify(data))
    clipboard.set(encrypted)
    print("Succesfully Exported")
end

config.import = function(input)
    decrypted = json.parse(base64.decode(input ~= nil and input or clipboard.get()))
    package:load(decrypted)
    print("Succesfully Imported!")
end

import = lua_group:button("Import Config", function() 
    config.import()
end):depend(jitter_access, aa_tab, enable_check)

export = lua_group:button("Export Config", function() 
    config.export()
end):depend(jitter_access, aa_tab, enable_check)

default = lua_group:button("Defensive Config", function() 
    config.import("W3sibWFpbiI6eyJlbmFibGUiOnRydWUsInRhYiI6IkFudGktQWltIiwiZW5hYmxlX3giOnRydWV9LCJhbnRpYWltIjp7ImtleV9sZWZ0IjpbMSw5MCwifiJdLCJ5YXdfZGlyZWN0aW9uIjpbIn4iXSwiY29uZGl0aW9uIjoiXHUwMDBiR2xvYmFsXHIiLCJhYV90YWIiOiJCdWlsZGVyIiwia2V5X3JpZ2h0IjpbMSwwLCJ+Il0sImtleV9mcmVlc3RhbmQiOlsxLDAsIn4iXSwiYWRkb25zIjpbIn4iXSwiYWFfdHlwZSI6ImdhbWVzZW5zZSJ9LCJtaXNjIjp7Im9nX3dhdGVyIjp0cnVlLCJkZWZlbnNpdmVfcGVlayI6ZmFsc2UsImZhc3RfbGFkZGVyIjpmYWxzZSwiZGVmZW5zaXZlX2luZGljYXRvciI6ZmFsc2UsIm9nX3dhdGVyX2MiOiIjRkZGRkZGRkYiLCJ2ZWxvY2l0eV9pbmRpY2F0b3JfYyI6IiNGRkZGRkZGRiIsImFycm93cyI6dHJ1ZSwiYXJyb3dzX2MiOiIjOUI5QjlCRkYiLCJkZWZlbnNpdmVfaW5kaWNhdG9yX2MiOiIjRkZGRkZGRkYiLCJ2ZWxvY2l0eV9pbmRpY2F0b3IiOmZhbHNlLCJlbmFibGVfZ2xvdyI6ZmFsc2UsImRlYnVnX3BhbmVsIjpmYWxzZSwibG9nIjpmYWxzZX19LFt7ImVuYWJsZSI6ZmFsc2UsInlhd190eXBlIjoiRGVmYXVsdCIsInlhd19wcmVjZW50IjowLCJ5YXdfZGVsYXkiOjQsImN1c3RvbV9kZXN5bmMiOjAsIm1vZF9hZG0iOjc5LCJtb2RfcHJlY2VudCI6MjgsIm1vZF90eXBlIjoiQ2VudGVyIiwiYm9keV95YXdfdHlwZSI6IkppdHRlciIsImJvZHlfc2xpZGVyIjotMSwib3B0aW9ucyI6WyJKaXR0ZXIgRXhwbG9pdCIsIlJhbmRvbWl6ZSIsIn4iXSwibW9kX3RpY2tzIjoxLCJtb2RfZG0iOjU1LCJ5YXdfbGVmdCI6MCwieWF3X3JpZ2h0IjowLCJtb2RfYXByZWNlbnQiOjI4fSx7ImVuYWJsZSI6dHJ1ZSwieWF3X3R5cGUiOiJEZWZhdWx0IiwieWF3X3ByZWNlbnQiOjAsInlhd19kZWxheSI6NCwiY3VzdG9tX2Rlc3luYyI6MSwibW9kX2FkbSI6ODAsIm1vZF9wcmVjZW50IjoyMCwibW9kX3R5cGUiOiJDZW50ZXIiLCJib2R5X3lhd190eXBlIjoiSml0dGVyIiwiYm9keV9zbGlkZXIiOi0xLCJvcHRpb25zIjpbIkppdHRlciBFeHBsb2l0IiwifiJdLCJtb2RfdGlja3MiOjEsIm1vZF9kbSI6NTUsInlhd19sZWZ0IjowLCJ5YXdfcmlnaHQiOjAsIm1vZF9hcHJlY2VudCI6MjB9LHsiZW5hYmxlIjpmYWxzZSwieWF3X3R5cGUiOiJEZWZhdWx0IiwieWF3X3ByZWNlbnQiOjAsInlhd19kZWxheSI6NCwiY3VzdG9tX2Rlc3luYyI6MCwibW9kX2FkbSI6MCwibW9kX3ByZWNlbnQiOjAsIm1vZF90eXBlIjoiQ2VudGVyIiwiYm9keV95YXdfdHlwZSI6Ik9mZiIsImJvZHlfc2xpZGVyIjowLCJvcHRpb25zIjpbIn4iXSwibW9kX3RpY2tzIjowLCJtb2RfZG0iOjAsInlhd19sZWZ0IjowLCJ5YXdfcmlnaHQiOjAsIm1vZF9hcHJlY2VudCI6MH0seyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiRGVmYXVsdCIsInlhd19wcmVjZW50IjowLCJ5YXdfZGVsYXkiOjQsImN1c3RvbV9kZXN5bmMiOjAsIm1vZF9hZG0iOjg2LCJtb2RfcHJlY2VudCI6MjAsIm1vZF90eXBlIjoiQ2VudGVyIiwiYm9keV95YXdfdHlwZSI6IkppdHRlciIsImJvZHlfc2xpZGVyIjotMSwib3B0aW9ucyI6WyJKaXR0ZXIgRXhwbG9pdCIsIlJhbmRvbWl6ZSIsIn4iXSwibW9kX3RpY2tzIjoxLCJtb2RfZG0iOjU3LCJ5YXdfbGVmdCI6MCwieWF3X3JpZ2h0IjowLCJtb2RfYXByZWNlbnQiOjIwfSx7ImVuYWJsZSI6dHJ1ZSwieWF3X3R5cGUiOiJEZWZhdWx0IiwieWF3X3ByZWNlbnQiOjAsInlhd19kZWxheSI6NCwiY3VzdG9tX2Rlc3luYyI6MCwibW9kX2FkbSI6ODUsIm1vZF9wcmVjZW50IjoxNSwibW9kX3R5cGUiOiJDZW50ZXIiLCJib2R5X3lhd190eXBlIjoiSml0dGVyIiwiYm9keV9zbGlkZXIiOi0xLCJvcHRpb25zIjpbIkppdHRlciBFeHBsb2l0IiwiUmFuZG9taXplIiwifiJdLCJtb2RfdGlja3MiOjEsIm1vZF9kbSI6NjAsInlhd19sZWZ0IjozLCJ5YXdfcmlnaHQiOjMsIm1vZF9hcHJlY2VudCI6MjB9LHsiZW5hYmxlIjp0cnVlLCJ5YXdfdHlwZSI6IkRlZmF1bHQiLCJ5YXdfcHJlY2VudCI6MCwieWF3X2RlbGF5Ijo0LCJjdXN0b21fZGVzeW5jIjowLCJtb2RfYWRtIjo5OSwibW9kX3ByZWNlbnQiOjEwLCJtb2RfdHlwZSI6IkNlbnRlciIsImJvZHlfeWF3X3R5cGUiOiJKaXR0ZXIiLCJib2R5X3NsaWRlciI6LTEsIm9wdGlvbnMiOlsiSml0dGVyIEV4cGxvaXQiLCJSYW5kb21pemUiLCJ+Il0sIm1vZF90aWNrcyI6MSwibW9kX2RtIjo1NSwieWF3X2xlZnQiOjksInlhd19yaWdodCI6OSwibW9kX2FwcmVjZW50IjoxMH0seyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiRGVmYXVsdCIsInlhd19wcmVjZW50IjowLCJ5YXdfZGVsYXkiOjQsImN1c3RvbV9kZXN5bmMiOjAsIm1vZF9hZG0iOjkwLCJtb2RfcHJlY2VudCI6MTAsIm1vZF90eXBlIjoiQ2VudGVyIiwiYm9keV95YXdfdHlwZSI6IkppdHRlciIsImJvZHlfc2xpZGVyIjotMSwib3B0aW9ucyI6WyJKaXR0ZXIgRXhwbG9pdCIsIlJhbmRvbWl6ZSIsIn4iXSwibW9kX3RpY2tzIjoxLCJtb2RfZG0iOjY4LCJ5YXdfbGVmdCI6NiwieWF3X3JpZ2h0Ijo2LCJtb2RfYXByZWNlbnQiOjIwfSx7ImVuYWJsZSI6dHJ1ZSwieWF3X3R5cGUiOiJEZWZhdWx0IiwieWF3X3ByZWNlbnQiOjAsInlhd19kZWxheSI6NCwiY3VzdG9tX2Rlc3luYyI6MCwibW9kX2FkbSI6ODAsIm1vZF9wcmVjZW50IjoxNSwibW9kX3R5cGUiOiJDZW50ZXIiLCJib2R5X3lhd190eXBlIjoiSml0dGVyIiwiYm9keV9zbGlkZXIiOi0xLCJvcHRpb25zIjpbIkppdHRlciBFeHBsb2l0IiwiUmFuZG9taXplIiwifiJdLCJtb2RfdGlja3MiOjEsIm1vZF9kbSI6NTUsInlhd19sZWZ0Ijo2LCJ5YXdfcmlnaHQiOjYsIm1vZF9hcHJlY2VudCI6MjB9XSxbeyJlbmFibGUiOmZhbHNlLCJ5YXdfdHlwZSI6IkRlZmF1bHQiLCJtb2RfdHlwZSI6IkNlbnRlciIsInlhd19kZWxheSI6NCwicGl0Y2hfYW1vdW50IjotODksImRlZmVuc2l2ZV9waXRjaCI6IkN1c3RvbSIsInlhd19sZWZ0IjozLCJib2R5X3NsaWRlciI6LTEsImRlZmVuc2l2ZSI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2J5IjpmYWxzZSwibW9kX2RtIjo3MCwiYm9keV95YXdfdHlwZSI6IkppdHRlciIsInlhd19yaWdodCI6MywiZGVmZW5zaXZlX3lhdyI6IkRlZmF1bHQifSx7ImVuYWJsZSI6ZmFsc2UsInlhd190eXBlIjoiRGVmYXVsdCIsIm1vZF90eXBlIjoiT2ZmIiwieWF3X2RlbGF5Ijo0LCJwaXRjaF9hbW91bnQiOjAsImRlZmVuc2l2ZV9waXRjaCI6Ik9mZiIsInlhd19sZWZ0IjowLCJib2R5X3NsaWRlciI6MCwiZGVmZW5zaXZlIjpmYWxzZSwiZnJlZXN0YW5kaW5nX2J5IjpmYWxzZSwibW9kX2RtIjowLCJib2R5X3lhd190eXBlIjoiT2ZmIiwieWF3X3JpZ2h0IjowLCJkZWZlbnNpdmVfeWF3IjoiT2ZmIn0seyJlbmFibGUiOmZhbHNlLCJ5YXdfdHlwZSI6IkRlZmF1bHQiLCJtb2RfdHlwZSI6Ik9mZiIsInlhd19kZWxheSI6NCwicGl0Y2hfYW1vdW50IjowLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJ5YXdfbGVmdCI6MCwiYm9keV9zbGlkZXIiOjAsImRlZmVuc2l2ZSI6ZmFsc2UsImZyZWVzdGFuZGluZ19ieSI6ZmFsc2UsIm1vZF9kbSI6MCwiYm9keV95YXdfdHlwZSI6Ik9mZiIsInlhd19yaWdodCI6MCwiZGVmZW5zaXZlX3lhdyI6Ik9mZiJ9LHsiZW5hYmxlIjp0cnVlLCJ5YXdfdHlwZSI6IlNsb3ciLCJtb2RfdHlwZSI6Ik9mZiIsInlhd19kZWxheSI6NCwicGl0Y2hfYW1vdW50IjotMTEsImRlZmVuc2l2ZV9waXRjaCI6Ik9mZiIsInlhd19sZWZ0IjotMzMsImJvZHlfc2xpZGVyIjowLCJkZWZlbnNpdmUiOnRydWUsImZyZWVzdGFuZGluZ19ieSI6ZmFsc2UsIm1vZF9kbSI6MCwiYm9keV95YXdfdHlwZSI6Ik9mZiIsInlhd19yaWdodCI6MzYsImRlZmVuc2l2ZV95YXciOiJPZmYifSx7ImVuYWJsZSI6dHJ1ZSwieWF3X3R5cGUiOiJEZWZhdWx0IiwibW9kX3R5cGUiOiJPZmYiLCJ5YXdfZGVsYXkiOjQsInBpdGNoX2Ftb3VudCI6MCwiZGVmZW5zaXZlX3BpdGNoIjoiQ3VzdG9tIiwieWF3X2xlZnQiOjMsImJvZHlfc2xpZGVyIjotMSwiZGVmZW5zaXZlIjp0cnVlLCJmcmVlc3RhbmRpbmdfYnkiOmZhbHNlLCJtb2RfZG0iOjAsImJvZHlfeWF3X3R5cGUiOiJKaXR0ZXIiLCJ5YXdfcmlnaHQiOjMsImRlZmVuc2l2ZV95YXciOiJEZWZhdWx0In0seyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiRGVmYXVsdCIsIm1vZF90eXBlIjoiQ2VudGVyIiwieWF3X2RlbGF5Ijo0LCJwaXRjaF9hbW91bnQiOjAsImRlZmVuc2l2ZV9waXRjaCI6Ik9mZiIsInlhd19sZWZ0Ijo5LCJib2R5X3NsaWRlciI6LTEsImRlZmVuc2l2ZSI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2J5IjpmYWxzZSwibW9kX2RtIjoxMCwiYm9keV95YXdfdHlwZSI6IkppdHRlciIsInlhd19yaWdodCI6OSwiZGVmZW5zaXZlX3lhdyI6IkRlZmF1bHQifSx7ImVuYWJsZSI6ZmFsc2UsInlhd190eXBlIjoiRGVmYXVsdCIsIm1vZF90eXBlIjoiT2ZmIiwieWF3X2RlbGF5Ijo0LCJwaXRjaF9hbW91bnQiOjAsImRlZmVuc2l2ZV9waXRjaCI6Ik9mZiIsInlhd19sZWZ0IjowLCJib2R5X3NsaWRlciI6MCwiZGVmZW5zaXZlIjpmYWxzZSwiZnJlZXN0YW5kaW5nX2J5IjpmYWxzZSwibW9kX2RtIjowLCJib2R5X3lhd190eXBlIjoiT2ZmIiwieWF3X3JpZ2h0IjowLCJkZWZlbnNpdmVfeWF3IjoiT2ZmIn0seyJlbmFibGUiOmZhbHNlLCJ5YXdfdHlwZSI6IkRlZmF1bHQiLCJtb2RfdHlwZSI6Ik9mZiIsInlhd19kZWxheSI6NCwicGl0Y2hfYW1vdW50IjowLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJ5YXdfbGVmdCI6MCwiYm9keV9zbGlkZXIiOjAsImRlZmVuc2l2ZSI6ZmFsc2UsImZyZWVzdGFuZGluZ19ieSI6ZmFsc2UsIm1vZF9kbSI6MCwiYm9keV95YXdfdHlwZSI6Ik9mZiIsInlhd19yaWdodCI6MCwiZGVmZW5zaXZlX3lhdyI6Ik9mZiJ9XV0=")
end):depend(jitter_access, aa_tab, enable_check)

default = lua_group:button("Default Config", function() 
    config.import("W3sibWFpbiI6eyJlbmFibGUiOnRydWUsInRhYiI6IkFudGktQWltIiwiZW5hYmxlX3giOnRydWV9LCJhbnRpYWltIjp7ImtleV9sZWZ0IjpbMSw5MCwifiJdLCJ5YXdfZGlyZWN0aW9uIjpbIn4iXSwiY29uZGl0aW9uIjoiXHUwMDBiR2xvYmFsXHIiLCJhYV90YWIiOiJCdWlsZGVyIiwia2V5X3JpZ2h0IjpbMSwwLCJ+Il0sImtleV9mcmVlc3RhbmQiOlsxLDAsIn4iXSwiYWRkb25zIjpbIn4iXSwiYWFfdHlwZSI6ImV4cGxvaXQifSwibWlzYyI6eyJvZ193YXRlciI6dHJ1ZSwiZGVmZW5zaXZlX3BlZWsiOmZhbHNlLCJmYXN0X2xhZGRlciI6ZmFsc2UsImRlZmVuc2l2ZV9pbmRpY2F0b3IiOmZhbHNlLCJvZ193YXRlcl9jIjoiI0ZGRkZGRkZGIiwidmVsb2NpdHlfaW5kaWNhdG9yX2MiOiIjRkZGRkZGRkYiLCJhcnJvd3MiOnRydWUsImFycm93c19jIjoiIzlCOUI5QkZGIiwiZGVmZW5zaXZlX2luZGljYXRvcl9jIjoiI0ZGRkZGRkZGIiwidmVsb2NpdHlfaW5kaWNhdG9yIjpmYWxzZSwiZW5hYmxlX2dsb3ciOmZhbHNlLCJkZWJ1Z19wYW5lbCI6ZmFsc2UsImxvZyI6ZmFsc2V9fSxbeyJlbmFibGUiOmZhbHNlLCJ5YXdfdHlwZSI6IkRlZmF1bHQiLCJ5YXdfcHJlY2VudCI6MCwieWF3X2RlbGF5Ijo0LCJjdXN0b21fZGVzeW5jIjowLCJtb2RfYWRtIjo3OSwibW9kX3ByZWNlbnQiOjI4LCJtb2RfdHlwZSI6IkNlbnRlciIsImJvZHlfeWF3X3R5cGUiOiJKaXR0ZXIiLCJib2R5X3NsaWRlciI6LTEsIm9wdGlvbnMiOlsiSml0dGVyIEV4cGxvaXQiLCJSYW5kb21pemUiLCJ+Il0sIm1vZF90aWNrcyI6MSwibW9kX2RtIjo1NSwieWF3X2xlZnQiOjAsInlhd19yaWdodCI6MCwibW9kX2FwcmVjZW50IjoyOH0seyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiRGVmYXVsdCIsInlhd19wcmVjZW50IjowLCJ5YXdfZGVsYXkiOjQsImN1c3RvbV9kZXN5bmMiOjEsIm1vZF9hZG0iOjgwLCJtb2RfcHJlY2VudCI6MjAsIm1vZF90eXBlIjoiQ2VudGVyIiwiYm9keV95YXdfdHlwZSI6IkppdHRlciIsImJvZHlfc2xpZGVyIjotMSwib3B0aW9ucyI6WyJKaXR0ZXIgRXhwbG9pdCIsIn4iXSwibW9kX3RpY2tzIjoxLCJtb2RfZG0iOjU1LCJ5YXdfbGVmdCI6MCwieWF3X3JpZ2h0IjowLCJtb2RfYXByZWNlbnQiOjIwfSx7ImVuYWJsZSI6ZmFsc2UsInlhd190eXBlIjoiRGVmYXVsdCIsInlhd19wcmVjZW50IjowLCJ5YXdfZGVsYXkiOjQsImN1c3RvbV9kZXN5bmMiOjAsIm1vZF9hZG0iOjAsIm1vZF9wcmVjZW50IjowLCJtb2RfdHlwZSI6IkNlbnRlciIsImJvZHlfeWF3X3R5cGUiOiJPZmYiLCJib2R5X3NsaWRlciI6MCwib3B0aW9ucyI6WyJ+Il0sIm1vZF90aWNrcyI6MCwibW9kX2RtIjowLCJ5YXdfbGVmdCI6MCwieWF3X3JpZ2h0IjowLCJtb2RfYXByZWNlbnQiOjB9LHsiZW5hYmxlIjp0cnVlLCJ5YXdfdHlwZSI6IkRlZmF1bHQiLCJ5YXdfcHJlY2VudCI6MCwieWF3X2RlbGF5Ijo0LCJjdXN0b21fZGVzeW5jIjowLCJtb2RfYWRtIjo4NiwibW9kX3ByZWNlbnQiOjIwLCJtb2RfdHlwZSI6IkNlbnRlciIsImJvZHlfeWF3X3R5cGUiOiJKaXR0ZXIiLCJib2R5X3NsaWRlciI6LTEsIm9wdGlvbnMiOlsiSml0dGVyIEV4cGxvaXQiLCJSYW5kb21pemUiLCJ+Il0sIm1vZF90aWNrcyI6MSwibW9kX2RtIjo1NywieWF3X2xlZnQiOjAsInlhd19yaWdodCI6MCwibW9kX2FwcmVjZW50IjoyMH0seyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiRGVmYXVsdCIsInlhd19wcmVjZW50IjowLCJ5YXdfZGVsYXkiOjQsImN1c3RvbV9kZXN5bmMiOjAsIm1vZF9hZG0iOjg1LCJtb2RfcHJlY2VudCI6MTUsIm1vZF90eXBlIjoiQ2VudGVyIiwiYm9keV95YXdfdHlwZSI6IkppdHRlciIsImJvZHlfc2xpZGVyIjotMSwib3B0aW9ucyI6WyJKaXR0ZXIgRXhwbG9pdCIsIlJhbmRvbWl6ZSIsIn4iXSwibW9kX3RpY2tzIjoxLCJtb2RfZG0iOjYwLCJ5YXdfbGVmdCI6MywieWF3X3JpZ2h0IjozLCJtb2RfYXByZWNlbnQiOjIwfSx7ImVuYWJsZSI6dHJ1ZSwieWF3X3R5cGUiOiJEZWZhdWx0IiwieWF3X3ByZWNlbnQiOjAsInlhd19kZWxheSI6NCwiY3VzdG9tX2Rlc3luYyI6MCwibW9kX2FkbSI6OTksIm1vZF9wcmVjZW50IjoxMCwibW9kX3R5cGUiOiJDZW50ZXIiLCJib2R5X3lhd190eXBlIjoiSml0dGVyIiwiYm9keV9zbGlkZXIiOi0xLCJvcHRpb25zIjpbIkppdHRlciBFeHBsb2l0IiwiUmFuZG9taXplIiwifiJdLCJtb2RfdGlja3MiOjEsIm1vZF9kbSI6NTUsInlhd19sZWZ0Ijo5LCJ5YXdfcmlnaHQiOjksIm1vZF9hcHJlY2VudCI6MTB9LHsiZW5hYmxlIjp0cnVlLCJ5YXdfdHlwZSI6IkRlZmF1bHQiLCJ5YXdfcHJlY2VudCI6MCwieWF3X2RlbGF5Ijo0LCJjdXN0b21fZGVzeW5jIjowLCJtb2RfYWRtIjo5MCwibW9kX3ByZWNlbnQiOjEwLCJtb2RfdHlwZSI6IkNlbnRlciIsImJvZHlfeWF3X3R5cGUiOiJKaXR0ZXIiLCJib2R5X3NsaWRlciI6LTEsIm9wdGlvbnMiOlsiSml0dGVyIEV4cGxvaXQiLCJSYW5kb21pemUiLCJ+Il0sIm1vZF90aWNrcyI6MSwibW9kX2RtIjo2OCwieWF3X2xlZnQiOjYsInlhd19yaWdodCI6NiwibW9kX2FwcmVjZW50IjoyMH0seyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiRGVmYXVsdCIsInlhd19wcmVjZW50IjowLCJ5YXdfZGVsYXkiOjQsImN1c3RvbV9kZXN5bmMiOjAsIm1vZF9hZG0iOjgwLCJtb2RfcHJlY2VudCI6MTUsIm1vZF90eXBlIjoiQ2VudGVyIiwiYm9keV95YXdfdHlwZSI6IkppdHRlciIsImJvZHlfc2xpZGVyIjotMSwib3B0aW9ucyI6WyJKaXR0ZXIgRXhwbG9pdCIsIlJhbmRvbWl6ZSIsIn4iXSwibW9kX3RpY2tzIjoxLCJtb2RfZG0iOjU1LCJ5YXdfbGVmdCI6NiwieWF3X3JpZ2h0Ijo2LCJtb2RfYXByZWNlbnQiOjIwfV0sW3siZW5hYmxlIjpmYWxzZSwieWF3X3R5cGUiOiJEZWZhdWx0IiwibW9kX3R5cGUiOiJDZW50ZXIiLCJ5YXdfZGVsYXkiOjQsInBpdGNoX2Ftb3VudCI6LTg5LCJkZWZlbnNpdmVfcGl0Y2giOiJDdXN0b20iLCJ5YXdfbGVmdCI6MywiYm9keV9zbGlkZXIiOi0xLCJkZWZlbnNpdmUiOnRydWUsImZyZWVzdGFuZGluZ19ieSI6ZmFsc2UsIm1vZF9kbSI6NzAsImJvZHlfeWF3X3R5cGUiOiJKaXR0ZXIiLCJ5YXdfcmlnaHQiOjMsImRlZmVuc2l2ZV95YXciOiJEZWZhdWx0In0seyJlbmFibGUiOmZhbHNlLCJ5YXdfdHlwZSI6IkRlZmF1bHQiLCJtb2RfdHlwZSI6Ik9mZiIsInlhd19kZWxheSI6NCwicGl0Y2hfYW1vdW50IjowLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJ5YXdfbGVmdCI6MCwiYm9keV9zbGlkZXIiOjAsImRlZmVuc2l2ZSI6ZmFsc2UsImZyZWVzdGFuZGluZ19ieSI6ZmFsc2UsIm1vZF9kbSI6MCwiYm9keV95YXdfdHlwZSI6Ik9mZiIsInlhd19yaWdodCI6MCwiZGVmZW5zaXZlX3lhdyI6Ik9mZiJ9LHsiZW5hYmxlIjpmYWxzZSwieWF3X3R5cGUiOiJEZWZhdWx0IiwibW9kX3R5cGUiOiJPZmYiLCJ5YXdfZGVsYXkiOjQsInBpdGNoX2Ftb3VudCI6MCwiZGVmZW5zaXZlX3BpdGNoIjoiT2ZmIiwieWF3X2xlZnQiOjAsImJvZHlfc2xpZGVyIjowLCJkZWZlbnNpdmUiOmZhbHNlLCJmcmVlc3RhbmRpbmdfYnkiOmZhbHNlLCJtb2RfZG0iOjAsImJvZHlfeWF3X3R5cGUiOiJPZmYiLCJ5YXdfcmlnaHQiOjAsImRlZmVuc2l2ZV95YXciOiJPZmYifSx7ImVuYWJsZSI6dHJ1ZSwieWF3X3R5cGUiOiJTbG93IiwibW9kX3R5cGUiOiJPZmYiLCJ5YXdfZGVsYXkiOjQsInBpdGNoX2Ftb3VudCI6LTExLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJ5YXdfbGVmdCI6LTMzLCJib2R5X3NsaWRlciI6MCwiZGVmZW5zaXZlIjp0cnVlLCJmcmVlc3RhbmRpbmdfYnkiOmZhbHNlLCJtb2RfZG0iOjAsImJvZHlfeWF3X3R5cGUiOiJPZmYiLCJ5YXdfcmlnaHQiOjM2LCJkZWZlbnNpdmVfeWF3IjoiT2ZmIn0seyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiRGVmYXVsdCIsIm1vZF90eXBlIjoiT2ZmIiwieWF3X2RlbGF5Ijo0LCJwaXRjaF9hbW91bnQiOjAsImRlZmVuc2l2ZV9waXRjaCI6IkN1c3RvbSIsInlhd19sZWZ0IjozLCJib2R5X3NsaWRlciI6LTEsImRlZmVuc2l2ZSI6dHJ1ZSwiZnJlZXN0YW5kaW5nX2J5IjpmYWxzZSwibW9kX2RtIjowLCJib2R5X3lhd190eXBlIjoiSml0dGVyIiwieWF3X3JpZ2h0IjozLCJkZWZlbnNpdmVfeWF3IjoiRGVmYXVsdCJ9LHsiZW5hYmxlIjp0cnVlLCJ5YXdfdHlwZSI6IkRlZmF1bHQiLCJtb2RfdHlwZSI6IkNlbnRlciIsInlhd19kZWxheSI6NCwicGl0Y2hfYW1vdW50IjowLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJ5YXdfbGVmdCI6OSwiYm9keV9zbGlkZXIiOi0xLCJkZWZlbnNpdmUiOnRydWUsImZyZWVzdGFuZGluZ19ieSI6ZmFsc2UsIm1vZF9kbSI6MTAsImJvZHlfeWF3X3R5cGUiOiJKaXR0ZXIiLCJ5YXdfcmlnaHQiOjksImRlZmVuc2l2ZV95YXciOiJEZWZhdWx0In0seyJlbmFibGUiOmZhbHNlLCJ5YXdfdHlwZSI6IkRlZmF1bHQiLCJtb2RfdHlwZSI6Ik9mZiIsInlhd19kZWxheSI6NCwicGl0Y2hfYW1vdW50IjowLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJ5YXdfbGVmdCI6MCwiYm9keV9zbGlkZXIiOjAsImRlZmVuc2l2ZSI6ZmFsc2UsImZyZWVzdGFuZGluZ19ieSI6ZmFsc2UsIm1vZF9kbSI6MCwiYm9keV95YXdfdHlwZSI6Ik9mZiIsInlhd19yaWdodCI6MCwiZGVmZW5zaXZlX3lhdyI6Ik9mZiJ9LHsiZW5hYmxlIjpmYWxzZSwieWF3X3R5cGUiOiJEZWZhdWx0IiwibW9kX3R5cGUiOiJPZmYiLCJ5YXdfZGVsYXkiOjQsInBpdGNoX2Ftb3VudCI6MCwiZGVmZW5zaXZlX3BpdGNoIjoiT2ZmIiwieWF3X2xlZnQiOjAsImJvZHlfc2xpZGVyIjowLCJkZWZlbnNpdmUiOmZhbHNlLCJmcmVlc3RhbmRpbmdfYnkiOmZhbHNlLCJtb2RfZG0iOjAsImJvZHlfeWF3X3R5cGUiOiJPZmYiLCJ5YXdfcmlnaHQiOjAsImRlZmVuc2l2ZV95YXciOiJPZmYifV1d")
end):depend(jitter_access, aa_tab, enable_check)

client.set_event_callback("paint", function()
    if not entity.is_alive(entity.get_local_player()) then return end
    renderer.text(20, y_ind/2, 255, 255, 255, 255, "", 0, "\a7C7C7CFFJ I T T E R \aB74E4EFF[DEV]")
end)

client.set_event_callback("setup_command", function(cmd)
    if not menu.main.enable:get() then return end
    aa_setup(cmd)
    if menu.misc.fast_ladder:get() then
        fastladder(cmd)
    end
end)

client.set_event_callback('paint_ui', function()
    hide_original_menu(not (menu.main.enable:get()))
    menu.main.enable_x:set(true)
end)

client.set_event_callback('paint', function()
    if menu.misc.defensive_indicator:get() then
        render_defensive()
    end
    if menu.misc.velocity_indicator:get() then
        render_velocity()
    end
    if menu.misc.debug_panel:get() then
        debug_panel()
    end
    if menu.misc.og_water:get() then
        og_water()
    end
    if menu.misc.arrows:get() then
        render_arrows()
    end
end)

client.set_event_callback('shutdown', function()
    hide_original_menu(true)
end)

menu.misc.console_filter:set_callback(function(self)
    cvar.con_filter_text:set_string("cool text")
    cvar.con_filter_enable:set_int(1)
end)

menu_r, menu_g, menu_b, menu_a = menu.misc.log:get_color()
notify.new_bottom({ { "Loaded" }, {"...", true}, {" "} })