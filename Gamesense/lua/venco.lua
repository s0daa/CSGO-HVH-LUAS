--[[
    TODO: доделать анимбрикеры
]]


local vector = require("vector")
local pui = require("gamesense/pui")
local clipboard = require("gamesense/clipboard")
local c_entity = require("gamesense/entity")

local vencodata_text = [[
    ██╗░░░██╗███████╗███╗░░██╗░█████╗░░█████╗░░░░░█████╗░██╗░░░░░██████╗░██╗░░██╗░█████╗░
    ██║░░░██║██╔════╝████╗░██║██╔══██╗██╔══██╗░░░██╔══██╗██║░░░░░██╔══██╗██║░░██║██╔══██╗
    ╚██╗░██╔╝█████╗░░██╔██╗██║██║░░╚═╝██║░░██║░░░███████║██║░░░░░██████╔╝███████║███████║
    ░╚████╔╝░██╔══╝░░██║╚████║██║░░██╗██║░░██║░░░██╔══██║██║░░░░░██╔═══╝░██╔══██║██╔══██║
    ░░╚██╔╝░░███████╗██║░╚███║╚█████╔╝╚█████╔╝██╗██║░░██║███████╗██║░░░░░██║░░██║██║░░██║
    ░░░╚═╝░░░╚══════╝╚═╝░░╚══╝░╚════╝░░╚════╝░╚═╝╚═╝░░╚═╝╚══════╝╚═╝░░░░░╚═╝░░╚═╝╚═╝░░╚═╝
]]
local info_script = {
    username = ".gg/rollmops & .gg/scriptleaks",
    version = "alpha",
    basecolor = { 196, 2, 2, 255 },
    basecolor_light = { 240, 2, 2, 255 }
}

client.exec("clear")
client.color_log(255, 255, 255, " \n \n \n \n \n ")
client.color_log(info_script.basecolor_light[1], info_script.basecolor_light[2], info_script.basecolor_light[3], vencodata_text)
client.color_log(255, 255, 255, " \n \n \n \n \n ")





local function rgba_to_hex(r, g, b, a)
    return bit.tohex(r, 2) .. bit.tohex(g, 2) .. bit.tohex(b, 2) .. bit.tohex(a, 2)
end
local fade_text = function(rgba, text)
    local final_text = ""
    local curtime = globals.curtime()
    local r, g, b, a = unpack(rgba)

    for i = 1, #text do
        local color = rgba_to_hex(r, g, b, a * math.abs(1 * math.cos(2 * 3 * curtime / 4 + i * 5 / 30)))
        final_text = final_text .. "\a" .. color .. text:sub(i, i)
    end

    return final_text
end





local antiaim_cond = { '\vGlobal\r', '\vStand\r', '\vWalking\r', '\vRunning\r' , '\vAir\r', '\vAir+\r', '\vDuck\r' }
local short_cond = { '\vG ·\r', '\vS ·\r', '\vW ·\r', '\vR ·\r' ,'\vA ·\r', '\vA+ ·\r', '\vD ·\r' }

client.color_log(196, 2, 2, "[venco]\0")
client.color_log(255, 255, 255, " Welcome back, "..info_script.username)
client.color_log(196, 2, 2, "[venco]\0")
client.color_log(255, 255, 255, " you "..info_script.version.." build was loaded!")

local menu_ref = {
    antiaim = {
        slowwalk = { ui.reference('AA', 'Other', 'Slow motion') },
        enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
        pitch = {ui.reference("AA", "Anti-aimbot angles", "Pitch")},
        yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
        yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
        fsbodyyaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
        edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
        yaw_jitt = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
        body_yaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
        freestand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
        roll = ui.reference("AA", "Anti-aimbot angles", "Roll")
    },
    fakelag = {
        enabled = { ui.reference('AA', 'Fake lag', 'Enabled') },
        amount = ui.reference('AA', 'Fake lag', 'Amount'),
        variance = ui.reference('AA', 'Fake lag', 'Variance'),
        limit = ui.reference('AA', 'Fake lag', 'Limit')
    },
    other = {
        enabled_slw = { ui.reference('AA', 'Other', 'Slow Motion') },
        leg_movement = ui.reference('AA', 'Other', 'Leg movement'),
        osaa = {ui.reference('AA', 'Other', 'On Shot anti-aim')},
        fakepeek = {ui.reference('AA', 'Other', 'Fake peek')}
    }
}

pui.macros.dot = '\v•  \r'
pui.macros.dot_red = "\aE01F1FFF•  \r"
pui.macros.fs = '\v⟳  \r'
pui.macros.left_manual = '\v⇦  \r'
pui.macros.right_manual = '\v⇨  \r'
pui.macros.forward_manual = '\v⇧  \r'
pui.macros.antiaim_vinco = '\vve\aC40202FFnco \v• \r'
pui.macros.fl_vinco = '\aC40202FFvenco \r'
local aa_group = pui.group("aa", "anti-aimbot angles")
local cfg_group = pui.group("aa", "other")
vencolabelaa = aa_group:label("venco")
tab_selector = aa_group:combobox('\f<dot_red> \f<fl_vinco> Tab Selector', {"Info", "Anti~Aimbot", "Visuals", "Misc"})
aa_group:label("--------------------------------------")
aa_group:label("\f<dot_red>Welcome back, \aE01F1FFF"..info_script.username):depend({tab_selector, "Info"})
aa_group:label("\f<dot_red>Version: \aE01F1FFF"..info_script.version):depend({tab_selector, "Info"})

-- Anti-Aimbot
aa_tab = aa_group:combobox("\f<antiaim_vinco>AntiAim Tab", {"Settings", "Builder"}):depend({tab_selector, "Anti~Aimbot"})
aa_group:label("--------------------------------------"):depend({tab_selector, "Anti~Aimbot"})
aa_pitch = aa_group:combobox("\f<antiaim_vinco>Pitch", {"Disabled", "Down"}):depend({tab_selector, "Anti~Aimbot"}, {aa_tab, "Settings"})
aa_yaw_base = aa_group:combobox("\f<antiaim_vinco>Yaw Base", {"Local View", "At Targets"}):depend({tab_selector, "Anti~Aimbot"}, {aa_tab, "Settings"})
aa_fs_enable = aa_group:checkbox("\f<antiaim_vinco>Enable Freestanding"):depend({tab_selector, "Anti~Aimbot"}, {aa_tab, "Settings"})
aa_fs_key = aa_group:hotkey('\f<antiaim_vinco>Freestanding'):depend({tab_selector, "Anti~Aimbot"}, {aa_tab, "Settings"}, aa_fs_enable)
aa_condition = aa_group:combobox('\f<antiaim_vinco>Condition', antiaim_cond):depend({tab_selector, "Anti~Aimbot"}, {aa_tab, "Builder"})

-- Fake Lag

local fl_group = pui.group("aa", "fake lag")
vencolabelfl = fl_group:label("venco")
enable_fl = fl_group:checkbox("\f<dot_red>Enable \f<fl_vinco>fakelag system")
fl_limit = fl_group:slider("\f<dot_red>Fakelag Limit", 1, 15, 0):depend(enable_fl)
fl_variance = fl_group:slider("\f<dot_red>Fakelag Variance", 0, 100, 0, true, "%", 1):depend(enable_fl)
fl_type = fl_group:combobox("\f<dot_red>Fakelag Type", {"Dynamic", "Maximum", "Fluctuate", "Randomized"}):depend(enable_fl)

-- Other

local oth_group = pui.group("aa", "other")
vencolabeloth = oth_group:label("venco")
oth_sw = oth_group:checkbox("\f<dot_red> Slow Walk")
oth_sw_kb = oth_group:hotkey("\f<dot_red> Slow Walk Key")
oth_lm = oth_group:combobox("\f<dot_red> Leg Movment", {"Disabled", "Always", "Never"})
oth_osaa = oth_group:checkbox("\f<dot_red> OSAA")
oth_osaa_kb = oth_group:hotkey("\f<dot_red> OSAA Key")

-- Visuals
center_indic = aa_group:checkbox("\f<dot_red>Centered Indicators"):depend({tab_selector, "Visuals"})
hitlogs_select = aa_group:multiselect("\f<dot_red>Hitlogs", "On Screen", "On Console"):depend({tab_selector, "Visuals"})
misslogs_select = aa_group:multiselect("\f<dot_red>Misslogs", "On Screen", "On Console"):depend({tab_selector, "Visuals"})

-- Misc
trash_talk_enable = aa_group:checkbox("\f<dot_red>Trash Talk"):depend({tab_selector, "Misc"})

local aa_sys = {}
for i = 1, #antiaim_cond do
    aa_sys[i] = {
        label = aa_group:label('\f<antiaim_vinco>Editing \v'..antiaim_cond[i]),
        enable = aa_group:checkbox('\f<antiaim_vinco>Enable | \v'..antiaim_cond[i]),
        yaw_type = aa_group:combobox('\f<antiaim_vinco>Yaw Type', {"Default", "Delay"}),
        yaw_delay = aa_group:slider('\f<antiaim_vinco>Delay Ticks', 1, 10, 4, true, 't', 1),
        yaw_left = aa_group:slider('\f<antiaim_vinco>Yaw Left', -180, 180, 0, true, '', 1),
        yaw_right = aa_group:slider('\f<antiaim_vinco>Yaw Right', -180, 180, 0, true, ' ', 1),
        mod_type = aa_group:combobox('\f<antiaim_vinco>Jitter Type', {'Off', 'Offset', 'Center', 'Random', 'Skitter'}),
        mod_dm = aa_group:slider('\f<antiaim_vinco>Offset', -180, 180, 0, true, '', 1),
        desync_mode = aa_group:combobox("\f<antiaim_vinco>Desync Mode", {"venco", "gamsense"}),
    }
end

for i=1, #antiaim_cond do
    local antiaimbot_tab = {tab_selector, "Anti~Aimbot"}
    local builder_tab = {aa_tab, "Builder"}
    local tab_cond = {aa_condition, antiaim_cond[i]}
    local cnd_en = aa_sys[i].enable
    local delay_selected = {aa_sys[i].yaw_type, "Delay"}
    local jitter_type = {aa_sys[i].mod_type, function() return aa_sys[i].mod_type:get() ~= "Off" end}
    aa_sys[i].label:depend(antiaimbot_tab, builder_tab, tab_cond)
    aa_sys[i].enable:depend(antiaimbot_tab, builder_tab, tab_cond)
    aa_sys[i].yaw_type:depend(cnd_en, antiaimbot_tab, builder_tab, tab_cond)
    aa_sys[i].yaw_delay:depend(cnd_en, delay_selected, antiaimbot_tab, builder_tab, tab_cond)
    aa_sys[i].yaw_left:depend(cnd_en, antiaimbot_tab, builder_tab, tab_cond)
    aa_sys[i].yaw_right:depend(cnd_en, antiaimbot_tab, builder_tab, tab_cond)
    aa_sys[i].mod_type:depend(cnd_en, antiaimbot_tab, builder_tab, tab_cond)
    aa_sys[i].mod_dm:depend(cnd_en, antiaimbot_tab, builder_tab, tab_cond, jitter_type)
    aa_sys[i].desync_mode:depend(cnd_en, antiaimbot_tab, builder_tab, tab_cond)
end

local function get_velocity(player)
    local x, y, z = entity.get_prop(player, "m_vecVelocity")
    if x == nil then
        return
    end
    return math.sqrt(x * x + y * y + z * z)
end


local function get_player_state()
    local me = entity.get_local_player()
    local m_fFlags = entity.get_prop(me, 'm_fFlags')
    local m_bDucked = entity.get_prop(me, 'm_flDuckAmount') > 0.7
    local speedvec = { entity.get_prop(me, 'm_vecVelocity') }
    local speed = math.sqrt(speedvec[1]^2+speedvec[2]^2)
    local slowwalk = ui.get(menu_ref.antiaim.slowwalk[1]) and ui.get(menu_ref.antiaim.slowwalk[2])
    local in_air = false
    local air_tick = 0
    local current_tickcount = 0
    --local frestanding = antiaim_tab.freestand:get()
    if bit.band(m_fFlags, bit.lshift(1, 0)) == 0 then
        in_air = true
        air_tick = globals.tickcount() + 3
    else
        in_air = (air_tick > globals.tickcount()) and true or false
    end

    if in_air and m_bDucked then
        return 'AIR-C'
    end

    if in_air then
        return 'AIR'
    end

    if m_bDucked then
        return 'DUCKED'
    end

    if slowwalk then
        return 'WALK'
    end

    if speed < 8 then
        return 'STAND'
    else
        return 'RUN'
    end
end

local id = 1
local current_tickcount = 0
local to_jitter = false
local function setup_builder(cmd)
    ui.set(menu_ref.antiaim.enabled, true)
    ui.set(menu_ref.antiaim.yaw[1], "180")


    local lp = entity.get_local_player()
    if lp == nil then return end
    local desync_type = entity.get_prop(lp, 'm_flPoseParameter', 11) * 120 - 60
	desync_side = desync_type > 0 and 1 or -1

    if get_player_state() == "DUCKED" and aa_sys[7].enable:get() then id = 7
    elseif get_player_state() == "AIR-C" and aa_sys[6].enable:get() then id = 6
    elseif get_player_state() == "AIR" and aa_sys[5].enable:get() then id = 5
    elseif get_player_state() == "RUN" and aa_sys[4].enable:get() then id = 4
    elseif get_player_state() == "WALK" and aa_sys[3].enable:get() then id = 3
    elseif get_player_state() == "STAND" and aa_sys[2].enable:get() then id = 2
    else id = 1 end

    ui.set(menu_ref.antiaim.fsbodyyaw, false)
    if aa_pitch:get() == "Disabled" then
        ui.set(menu_ref.antiaim.pitch[1], "Custom")
        ui.set(menu_ref.antiaim.pitch[2], 0)
    else
        ui.set(menu_ref.antiaim.pitch[1], "Custom")
        ui.set(menu_ref.antiaim.pitch[2], 89)
    end
    ui.set(menu_ref.antiaim.yawbase, aa_yaw_base:get())

    ui.set(menu_ref.antiaim.yaw_jitt[1], aa_sys[id].mod_type:get())
    ui.set(menu_ref.antiaim.yaw_jitt[2], aa_sys[id].mod_dm:get())
    --print(aa_sys[i].yaw_delay:get())
    if aa_sys[id].yaw_type:get() == "Delay" then
        if globals.tickcount() > current_tickcount + aa_sys[id].yaw_delay:get() then
            if cmd.chokedcommands == 0 then
                to_jitter = not to_jitter
                current_tickcount = globals.tickcount()
            end
        elseif globals.tickcount() <  current_tickcount then
            current_tickcount = globals.tickcount()
        end
        ui.set(menu_ref.antiaim.body_yaw[1], "Static")
        ui.set(menu_ref.antiaim.body_yaw[2], to_jitter and 1 or -1)
        if desync_side == 1 then
            ui.set(menu_ref.antiaim.yaw[2], aa_sys[id].yaw_left:get() )
        elseif desync_side == -1 then
            ui.set(menu_ref.antiaim.yaw[2], aa_sys[id].yaw_right:get() )
        end
    else
        if globals.tickcount() > current_tickcount + 1 then
            if cmd.chokedcommands == 0 then
                to_jitter = not to_jitter
                current_tickcount = globals.tickcount()
            end
        elseif globals.tickcount() <  current_tickcount then
            current_tickcount = globals.tickcount()
        end
        
        if aa_sys[id].yaw_left:get() == 0 and aa_sys[id].yaw_right:get() == 0 then
            ui.set(menu_ref.antiaim.body_yaw[1], "Static")
            ui.set(menu_ref.antiaim.body_yaw[2], -60)
        else
            ui.set(menu_ref.antiaim.body_yaw[1], "Static")
            ui.set(menu_ref.antiaim.body_yaw[2], to_jitter and 1 or -1)
        end

        if desync_side == 1 then
            ui.set(menu_ref.antiaim.yaw[2], aa_sys[id].yaw_left:get() )
        elseif desync_side == -1 then
            ui.set(menu_ref.antiaim.yaw[2], aa_sys[id].yaw_right:get() )
        end
    end
    ui.set(menu_ref.antiaim.freestand[1], aa_fs_enable:get())
    ui.set(menu_ref.antiaim.freestand[2], aa_fs_key:get() and 'Always on' or 'On hotkey')
end

local function setup_fakelag()
    ui.set(menu_ref.fakelag.enabled[1], enable_fl:get())
    ui.set(menu_ref.fakelag.enabled[2], 'Always on')
    ui.set(menu_ref.fakelag.variance, fl_variance:get())
    ui.set(menu_ref.fakelag.limit, fl_limit:get())
    ui.set(menu_ref.fakelag.amount, "Maximum")
end

local function setup_other_aa_tab()
    if oth_lm:get() == "Disabled" then
        ui.set(menu_ref.other.leg_movement, "Off")
    end
    if oth_lm:get() == "Always" then
        ui.set(menu_ref.other.leg_movement, "Always slide")
    end
    if oth_lm:get() == "Never" then
        ui.set(menu_ref.other.leg_movement, "Never slide")
    end

    ui.set(menu_ref.other.enabled_slw[1], oth_sw:get())
    ui.set(menu_ref.other.enabled_slw[2], oth_sw_kb:get() and 'Always on' or 'On hotkey')
    ui.set(menu_ref.other.osaa[1], oth_osaa:get())
    ui.set(menu_ref.other.osaa[2], oth_osaa_kb:get() and 'Always on' or 'On hotkey')
end


hide_original_menu = function(state)
    ui.set_visible(menu_ref.antiaim.enabled, state)
    ui.set_visible(menu_ref.antiaim.pitch[1], state)
    ui.set_visible(menu_ref.antiaim.pitch[2], state)
    ui.set_visible(menu_ref.antiaim.yawbase, state)
    ui.set_visible(menu_ref.antiaim.yaw[1], state)
    ui.set_visible(menu_ref.antiaim.yaw[2], state)
    ui.set_visible(menu_ref.antiaim.yaw_jitt[1], state)
    ui.set_visible(menu_ref.antiaim.roll, state)
    ui.set_visible(menu_ref.antiaim.yaw_jitt[2], state)
    ui.set_visible(menu_ref.antiaim.body_yaw[1], state)
    ui.set_visible(menu_ref.antiaim.body_yaw[2], state)
    ui.set_visible(menu_ref.antiaim.fsbodyyaw, state)
    ui.set_visible(menu_ref.antiaim.edgeyaw, state)
    ui.set_visible(menu_ref.antiaim.freestand[1], state)
    ui.set_visible(menu_ref.antiaim.freestand[2], state)
    --other
    ui.set_visible(menu_ref.other.enabled_slw[1], state)
    ui.set_visible(menu_ref.other.enabled_slw[2], state)
    ui.set_visible(menu_ref.other.osaa[1], state)
    ui.set_visible(menu_ref.other.osaa[2], state)
    ui.set_visible(menu_ref.other.leg_movement, state)
    ui.set_visible(menu_ref.other.fakepeek[1], state)
    ui.set_visible(menu_ref.other.fakepeek[2], state)
    --fakelag
    ui.set_visible(menu_ref.fakelag.enabled[1], state)
    ui.set_visible(menu_ref.fakelag.enabled[2], state)
    ui.set_visible(menu_ref.fakelag.amount, state)
    ui.set_visible(menu_ref.fakelag.variance, state)
    ui.set_visible(menu_ref.fakelag.limit, state)
end

local function create_lua_name()
    vencolabelaa:set(fade_text(info_script.basecolor, "               venco.lua"))
    vencolabelfl:set(fade_text(info_script.basecolor, "               venco.lua"))
    vencolabeloth:set(fade_text(info_script.basecolor, "               venco.lua"))
end

local function paint_ui()
    local center_screen = vector(client.screen_size()) / 2

    if center_indic:get() then
        local scoped = entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 1 and true or false
        if scoped then
            renderer.text(center_screen.x + 33, center_screen.y + 25, 255, 255, 255, 255, "cdb", 0, fade_text(info_script.basecolor, "venco.lua"))
            renderer.text(center_screen.x + 33, center_screen.y + 35, 255, 255, 255, 255, "cd", 0, fade_text(info_script.basecolor, "build "..info_script.version))
        else
            renderer.text(center_screen.x, center_screen.y + 25, 255, 255, 255, 255, "cdb", 0, fade_text(info_script.basecolor, "venco.lua"))
            renderer.text(center_screen.x, center_screen.y + 35, 255, 255, 255, 255, "cd", 0, fade_text(info_script.basecolor, "build "..info_script.version))
        end
    else
        renderer.text(center_screen.x, center_screen.y + 500, 255, 255, 255, 255, "cdb", 0, fade_text(info_script.basecolor, "v e n c o . l u a ").." \aC40202FF~ "..info_script.username.." ~ "..fade_text(info_script.basecolor, info_script.version))
    end
end

-- hitlogs
local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
local hitlog = {}
local id = 1

local function aim_hit(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"

    if hitlogs_select:get("On Console") then
        print(string.format(
            "Hit %s in the %s for %d damage (%d health remaining)",
            entity.get_player_name(e.target), group, e.damage,
            entity.get_prop(e.target, "m_iHealth")
        ))
    end

    if hitlogs_select:get("On Screen") then
        hitlog[#hitlog+1] = {("Hit \aC40202FF@"..entity.get_player_name(e.target).."\aFFFFFFFF to \aC40202FF"..group.."\aFFFFFFFF for \aC40202FF"..e.damage.."\aFFFFFFFF damage (\aC40202FF"..entity.get_prop(e.target, "m_iHealth").."\aFFFFFFFF health remaining)"), globals.tickcount() + 250, 0}
    end
end

local function aim_miss(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"

    if misslogs_select:get("On Console") then
        print(string.format(
            "Missed %s (%s) due to %s",
            entity.get_player_name(e.target), group, e.reason
        ))
    end

    if misslogs_select:get("On Screen") then
        hitlog[#hitlog+1] = {("Missed shot \aC40202FF@"..entity.get_player_name(e.target).."\aFFFFFFFF to \aC40202FF"..group.."\aFFFFFFFF because \aC40202FF"..e.reason), globals.tickcount() + 250, 0}
    end

end

local function paint_hitlog()
    local screen = vector(client.screen_size())
    if #hitlog > 0 then
        if globals.tickcount() >= hitlog[1][2] then
            if hitlog[1][3] > 0 then
                hitlog[1][3] = hitlog[1][3] - 20
            elseif hitlog[1][3] <= 0 then
                table.remove(hitlog, 1)
            end
        end
        if #hitlog > 6 then
            table.remove(hitlog, 1)
        end
        if globals.is_connected == false then
            table.remove(hitlog, #hitlog)
        end
        for i = 1, #hitlog do
            text_size = renderer.measure_text("b", hitlog[i][1])
           if hitlog[i][3] < 255 then 
                hitlog[i][3] = hitlog[i][3] + 10 
            end
            renderer.text(screen.x/2 - text_size/2 + (hitlog[i][3]/35), screen.y/1.3 + 13 * i, 255, 255, 255, 230, "", 0, hitlog[i][1])
		end
    end
end

local tt_sel = {
    sound_cloud = {
        "АХАХАХ ДАЛАБЕБ ТЫ ЧЕ НЕ ПОДШАРЕН ЗА soundlcoud.com/rxdxyz?",
        "далабеб послушай код10 уже",
        "не шлюха ебать ты мне отсосала, я кста под код10 играю",
        "какой же код10 ахуенный",
        "code10 always on top",
        "angelozepam",
        "sc.com/angelhvh"
    },
    default = {
        "нормально ты мне отсосал сын шлюхи",
        "изи мапав хуесос",
        "soso delay",
        "xd bob",
        "hdf newcomer",
        "kys ez hdf"
    }
}

local userid_to_entindex, get_local_player, is_enemy, console_cmd = client.userid_to_entindex, entity.get_local_player, entity.is_enemy, client.exec

local function on_trashtalk(e)
    if not trash_talk_enable:get() then return end
    local victim_userid, attacker_userid = e.userid, e.attacker
    if victim_userid == nil or attacker_userid == nil then
        return
    end
    local victim_entindex = userid_to_entindex(victim_userid)
    local attacker_entindex = userid_to_entindex(attacker_userid)
    if attacker_entindex == get_local_player() and is_enemy(victim_entindex) then
        client.delay_call(0.2, function() console_cmd("say ", tt_sel.sound_cloud[math.random(1, #tt_sel.sound_cloud)]) end)
    end
end

-- confg
local config_items = {aa_sys}

local package, data, encrypted, decrypted = pui.setup(config_items), "", "", ""
config.export = function()
    data = package:save()
    encrypted = json.stringify(data)
    clipboard.set(encrypted)
    print("\aE01F1FFFExported")
end
config.import = function(input)
    decrypted = json.parse(input ~= nil and input or clipboard.get())
    package:load(decrypted)
    print("\aE01F1FFFImported")
end
buttom_import = cfg_group:button("\aE01F1FFFImport Config", function() 
    config.import()
end)
buttom_export = cfg_group:button("\aE01F1FFFExport Config", function() 
    config.export()
end)

client.set_event_callback("setup_command", function(cmd)
    setup_builder(cmd)
    setup_fakelag()
    setup_other_aa_tab()
end)

client.set_event_callback('paint_ui', function()
    hide_original_menu(false)
    create_lua_name()
end)

client.set_event_callback('paint', function()
    paint_ui()
    paint_hitlog()
end)

client.set_event_callback('shutdown', function()
    hide_original_menu(true)
end)

client.set_event_callback("aim_hit", aim_hit)
client.set_event_callback("aim_miss", aim_miss)
client.set_event_callback("player_death", on_trashtalk)