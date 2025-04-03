local pui = require "neverlose/pui"
local clipboard = require "neverlose/clipboard"
local gradient = require "neverlose/gradient"
local smoothy = require "neverlose/smoothy"
local drag_system = require "neverlose/drag_system"
local animations = require("neverlose/animations") 
local base64 = require ("neverlose/base64")
local MTools = require("neverlose/mtools");
local bomb = require "neverlose/bomb"

local _dbg = {
    colors = {
        --accent = color("#8FBCD7D8"),
        white = color("#FFFFFF"),
        red = color("FA3F3FFF"),
        yellow = color("#DED158FF"),
        pink = color("#A87391FF"),
        accent = color("#A87391FF")
    },
    _lua = {
        name = "frost.lua",
        build = "dev",
        branch = "recode",
        version = "beta",
        username = common.get_username(),
        update = "11.11.11"
    }
}

reference = {
    antiaim = {
        conditions = {
            "Global",
            "Standing",
            "Walking",
            "Slowed",
            "Crouch",
            "Snaking",
            "Air",
            "Air snaking",
            "On Freestand",
        },
        force_defensive = {
            "Standing",
            "Walking",
            "Slowed",
            "Crouch",
            "Snaking",
            "Air",
            "Air snaking"
        },
        uppercond = {
            "STANDING",
            "WALKING",
            "SLOWED",
            "CROUCH",
            "SNAKING",
            "AIR",
            "AIR SNAKING"
        }
    }
}

-- @REGION: colors
pui.colors.accent = _dbg.colors.accent
pui.colors.white = _dbg.colors.white
pui.colors.red = _dbg.colors.red
pui.colors.yellow = _dbg.colors.yellow
pui.colors.pink = _dbg.colors.pink
pui.colors.pink = _dbg.colors.pink
-- @ENDREGION

local _ui = {
    menulist = {
        left_upper = pui.create("tab", "\n", 1),
        right_upper = pui.create("tab", "\n\n", 2),
        left_lower = pui.create("tab", "\n\n\n", 1),
        right_lower = pui.create("tab", "\n\n\n\n", 2),
        left_downless = pui.create("tab", "\n\n\n\n\n", 1),
        right_downless = pui.create("tab", "\n\n\n\n\n\n", 2),
    },
    reference = {
        antiaim = {
            enable = pui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
            pitch = pui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
            yaw = pui.find("Aimbot", "Anti Aim", "Angles", "Yaw", {
                base = "Base",
                offset = "Offset",
                avoid_backstab = "Avoid Backstab",
                hidden = "Hidden"
            }),
            yaw_modifier = pui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", {
                offset = "Offset"
            }),
            body_yaw = pui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", {
                inverter = "Inverter",
                left_limit = "Left Limit",
                right_limit = "Right Limit",
                options = "Options",
                freestanding = "Freestanding"
            }),
            freestanding = pui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", {
                disable_yaw_modifiers = "Disable Yaw Modifiers",
                body_freestanding = "Body Freestanding"
            }),
            extended_angels = pui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", {
                extended_roll = "Extended Roll",
                extended_pitch = "Extended Pitch"
            }),
            slow_walk = pui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
            fake_duck = pui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck")
        },
        ragebot = {
            doubletap = pui.find("Aimbot", "Ragebot", "Main", "Double Tap", {
                options = "Lag Options"
            })
        }
    }
}

local hometab do
    tab_selector = _ui.menulist.left_upper:list("\n",
     {
        "                           \v\f<door-open>\a[white]  Home", 
        "                    \v\f<rotate>\a[white]   Anti-Aimbot", 
        "                         \v\f<eye>\a[white]  Visuals", 
        "                           \v\f<sparkles>\a[white]   Misc"
    })
    _ui.menulist.left_upper:label("\a[white]                   ".._dbg._lua.name.."   \f<copyright>   2023-2025")
    -- config_selector = _ui.menulist.right_upper:list("\n", 
    --         {
    --             "\f<file>   Local",
    --             "\f<database>   Cloud"
    --         }):depend({tab_selector, 1})
        
    --general_warning = _ui.menulist.left_upper:label("\a[yellow]\f<triangle-exclamation>\a[white]  This script is in developing stage, please send any bugs into discord tickets, you support developer team")
    --    :depend({tab_selector, 1})
    -- cloud_warning = _ui.menulist.left_upper:label("\a[yellow]\f<triangle-exclamation>\a[white]  Cloud config may be didnt fetch because server down or server on technical works, check discord for see status of server")
    --     :depend({tab_selector, 1}, {config_selector, 2})

    --_ui.menulist.right_upper:list("\n", {"Config 1", "Config 2"}):depend({tab_selector, 1}, {config_selector, 1})

    _ui.menulist.right_lower:label("\v\f<hand-wave>\a[white]  Welcome back   |   \v".._dbg._lua.username):depend({tab_selector, 1})
    _ui.menulist.right_lower:label("\v\f<code-branch>\a[white]   Your branch is    |   \v".._dbg._lua.branch):depend({tab_selector, 1})
    _ui.menulist.right_lower:label("\v\f<code-compare>\a[white]   Your version is   |   \v".._dbg._lua.version):depend({tab_selector, 1})
    _ui.menulist.left_lower:label("\v\f<discord>\a[white]   Discord Server"):depend({tab_selector, 1})
    _ui.menulist.left_lower:button(" \v\f<discord>\a[white] ", 
        function() 
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/2q9YVZgFdz") 
        end, 
    true):depend({tab_selector, 1})

    _ui.menulist.left_lower:label("\v\f<link>\a[white]   Configuration"):depend({tab_selector, 1})
    _ui.menulist.left_lower:button(" \v\f<link>\a[white] ", 
        function() 
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=Wkpj33") 
        end, 
    true):depend({tab_selector, 1})

    _ui.menulist.left_lower:label("\v\f<youtube>\a[white]   YouTube"):depend({tab_selector, 1})
    _ui.menulist.left_lower:button(" \v\f<youtube>\a[white] ", 
        function() 
            panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@v_1966") 
        end, 
    true):depend({tab_selector, 1})
    

end

local antiaim do
    antiaim = {}
    antiaim_ui = {}
    local aareference = _ui.reference.antiaim
    aareference.enable:set(false) -- Disable antiaim while start lua
    antiaim_ui.tabber = _ui.menulist.right_upper:list("\n", "\v\f<gear>\a[white]    Settings", "\v\f<arrow-trend-up>\a[white]   Addons"):depend({tab_selector, 2})

    antiaim_ui.global_switch = _ui.menulist.left_upper:switch("\v\f<toggle-on>   Enable"):depend({tab_selector, 2})
    antiaim_ui.selector_condition = _ui.menulist.right_upper:combo("\v\f<chart-bar>\a[white]   Condition", reference.antiaim.conditions):depend(antiaim_ui.global_switch, {tab_selector, 2}, {antiaim_ui.tabber, 1})
    antiaim_ui.freestanding = _ui.menulist.right_lower:switch("\v\f<key-skeleton-left-right>\a[white]   Freestand", false, function(gear)
        return {
            modifications = gear:listable("\n", {"Disable yaw modifiers", "Body Freestanding"}),
            cond = gear:selectable("Disable while", reference.antiaim.force_defensive)
        }
    end):depend(antiaim_ui.global_switch, {tab_selector, 2}, {antiaim_ui.tabber, 2})

    antiaim_ui.manuals = _ui.menulist.right_lower:combo("\v\f<person-swimming>\a[white]   Manuals", {"Disabled", "Left", "Right"}):depend(antiaim_ui.global_switch, {tab_selector, 2}, {antiaim_ui.tabber, 2})

    antiaim_ui.force_defensive = _ui.menulist.right_lower:label("\v\f<shield-halved>\a[white]   Force Defensive", function(gear)
            return {
                cond = gear:listable("\n", reference.antiaim.force_defensive)
            }
        end, "Allowing attempts to invalidate your backtrack records in selected conditions"):depend(antiaim_ui.global_switch, {tab_selector, 2}, {antiaim_ui.tabber, 2})

    
    antiaim_ui.avoid_backstab = _ui.menulist.left_downless:switch("\v\f<scalpel-line-dashed>\a[white]   Avoid Backstab", false, "Force rotate player to enemy if he have knife in hands"):depend(antiaim_ui.global_switch, {tab_selector, 2}, {antiaim_ui.tabber, 2})
    antiaim_ui.warmupdis = _ui.menulist.left_downless:switch("\v\f<signal-stream-slash>\a[white]   Warmup Disablers", false, "Disable aa while warmup"):depend(antiaim_ui.global_switch, {tab_selector, 2}, {antiaim_ui.tabber, 2})

    antiaim_ui.safe_head = _ui.menulist.left_downless:selectable("\v\f<head-side>\a[white]   Safe Head", {"On Air+C with knife"}, "Hide your head while selected conditions active"):depend(antiaim_ui.global_switch, {tab_selector, 2}, {antiaim_ui.tabber, 2})
    
    for x, y in ipairs(reference.antiaim.conditions) do
        antiaim[x] = {}
        enaa = {antiaim_ui.global_switch, function() if(x == 1) then return true else return antiaim[x].override:get() end end}

        antiaim[x].override = _ui.menulist.right_upper:switch("\v\f<wand-magic-sparkles>\a[white] Override "..reference.antiaim.conditions[x])
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]},
                {antiaim_ui.selector_condition, function() return reference.antiaim.conditions ~= "Global" end }, {antiaim_ui.tabber, 1}
            )
        
        antiaim[x].yaw = _ui.menulist.right_lower:combo("\v\f<right-left>\a[white]   Yaw", {"Backward", "Static"}, function(gear)
            return {
                yaw_base = gear:list("\v\f<layer-group>\a[white]   Base", {"Local View", "At targets"})
            }
        end)
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]}, antiaim[x].override, {antiaim_ui.tabber, 1})
        
        antiaim[x].yaw_static_angel = _ui.menulist.right_lower:slider("\v\f<rotate>\a[white]   Angel", -180, 180, 0)
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]}, antiaim[x].override, {antiaim[x].yaw, "Static"}, {antiaim_ui.tabber, 1})

        antiaim[x].yaw_left_angel = _ui.menulist.right_lower:slider("\v\f<arrow-left>\a[white]   Left Angel", -180, 180, 0)
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]}, antiaim[x].override, {antiaim[x].yaw, "Backward"}, {antiaim_ui.tabber, 1})

        antiaim[x].yaw_right_angel = _ui.menulist.right_lower:slider("\v\f<arrow-right>\a[white]   Right Angel", -180, 180, 0)
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]}, antiaim[x].override, {antiaim[x].yaw, "Backward"}, {antiaim_ui.tabber, 1})
        
        antiaim[x].yaw_modifier = _ui.menulist.right_downless:combo("\v\f<layer-group>\a[white]   Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "3-Way"})
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]}, antiaim[x].override, {antiaim_ui.tabber, 1})

        antiaim[x].yaw_mod_angel = _ui.menulist.right_downless:slider("\v\f<rotate>\a[white]   Angel", -180, 180, 0)
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]}, antiaim[x].override, {antiaim_ui.tabber, 1})
        
        antiaim[x].desync = _ui.menulist.right_downless:label("\v\f<wave-sine>\a[white]   Desync", function(gear, item)
                return {
                    left_angel = gear:slider("\v\f<chart-line-up>\a[white]   Left Angel", 0, 60, 60),
                    right_angel = gear:slider("\v\f<chart-line-down>\a[white]   Right Angel", 0, 60, 60),
                    delay_ticks = gear:slider("\v\f<arrow-down-short-wide>\a[white]   Delay", 1, 14, 0, 1, "t"),
                    randomisation_delay = gear:slider("\v\f<arrow-trend-up>\a[white]   Randomize delay", 0, 30, 0, 1, "%")
                }
            end, "Desync (Body Yaw) is just the act of desynchronizing the Client feet yaw with the Server feet yaw")
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]}, antiaim[x].override, {antiaim_ui.tabber, 1})

        antiaim[x].defensive = _ui.menulist.left_lower:switch("\v\f<shield>\a[white]   Hidden", false, "Invalidate the lagcomp server records and broke pitch, yaw\nPlease enable condition in Force defensive!")
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]}, antiaim[x].override, {antiaim_ui.tabber, 1})

        antiaim[x].defensive_pitch = _ui.menulist.left_lower:combo("\v\f<bone-break>\a[white]   Pitch", {"Up", "Down", "Zero", "Sway", "Random"})
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]}, antiaim[x].override, antiaim[x].defensive, {antiaim_ui.tabber, 1})
        antiaim[x].defensive_pitch_random_min = _ui.menulist.left_lower:slider("\v\f<bone-break>\a[white]   Random Min", -89, 89, 0)
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]}, antiaim[x].override, antiaim[x].defensive, {antiaim[x].defensive_pitch, "Random"})
        antiaim[x].defensive_pitch_random_max = _ui.menulist.left_lower:slider("\v\f<bone-break>\a[white]   Random Max", -89, 89, 0)
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]}, antiaim[x].override, antiaim[x].defensive, {antiaim[x].defensive_pitch, "Random"})
        antiaim[x].defensive_pitch_sway_value = _ui.menulist.left_lower:slider("\v\f<bone-break>\a[white]   Sway Amount", -89, 89, 0)
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]}, antiaim[x].override, antiaim[x].defensive, {antiaim[x].defensive_pitch, "Sway"})

            antiaim[x].defensive_yaw = _ui.menulist.left_lower:combo("\v\f<bone-break>\a[white]   Yaw", {"Angels", "Opposite", "Spin", "Random"})
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]}, antiaim[x].override, antiaim[x].defensive, {antiaim_ui.tabber, 1})
        antiaim[x].defensive_yaw_random_first = _ui.menulist.left_lower:slider("\v\f<bone-break>\a[white]   Random First", -180, 180, 0)
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]}, antiaim[x].override, antiaim[x].defensive, {antiaim[x].defensive_yaw, "Random"})
        antiaim[x].defensive_yaw_random_second = _ui.menulist.left_lower:slider("\v\f<bone-break>\a[white]   Random Second", -180, 180, 0)
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]}, antiaim[x].override, antiaim[x].defensive, {antiaim[x].defensive_yaw, "Random"})
        antiaim[x].defensive_yaw_spin_speed = _ui.menulist.left_lower:slider("\v\f<bone-break>\a[white]   Spin Speed", -90, 90, 0)
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]}, antiaim[x].override, antiaim[x].defensive, {antiaim[x].defensive_yaw, "Spin"})
       
        antiaim[x].defensive_chocke_value = _ui.menulist.left_lower:slider("\v\f<bone-break>\a[white]   Chocking", 0, 7, 0, false, "", "break command number\ndefault - 0\nextra - 5\nbreakable - 7\nneed vs skeet users")
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]}, antiaim[x].override, antiaim[x].defensive, {antiaim_ui.tabber, 1})

        antiaim[x].defensive_delay_yaw = _ui.menulist.left_lower:switch("\v\f<bone-break>\a[white]   Delay", false, function(gear, item)
            return {
                amount = gear:slider("Delay Ticks", 0, 7, 0, 1, function(self) if self == 0 then return 'Off' else return self..'t' end end):depend(item),
                randomisation = gear:slider("Randomize", 0, 10, 0, 1, function(self) if self == 0 then return 'Off' else return self..'t' end end):depend(item)
            }
            end)
            :depend(antiaim_ui.global_switch, {tab_selector, 2},{antiaim_ui.selector_condition, reference.antiaim.conditions[x]}, antiaim[x].override, antiaim[x].defensive, {antiaim_ui.tabber, 1})
    end

    local time_to_ticks = function(t)
        return math.floor(0.5 + (t / globals.tickinterval))
    end

    local warmupaa = function()
        if not antiaim_ui.warmupdis:get() then return end

        local gametul = entity.get_game_rules();
        if not (gametul ~= nil and gametul.m_bWarmupPeriod) then
            return
        else
            aareference.yaw.offset:override(0)
            aareference.body_yaw.options:override({})
            aareference.body_yaw.inverter:override(true)
            aareference.yaw.hidden:override(false)
            aareference.yaw_modifier:override("Spin")
            aareference.yaw_modifier.offset:override(180)
        end
    end

    local safehead = function(cmd, stateid)
        if (bit.band(entity.get_local_player().m_fFlags, 1) == 0 and entity.get_local_player().m_flDuckAmount > 0.7) and antiaim_ui.safe_head:get(1) and entity.get_local_player():get_player_weapon(false):get_weapon_info().weapon_type == 0 then
            aareference.yaw.offset:override(0)
            aareference.body_yaw.options:override({})
            aareference.body_yaw.inverter:override(true)
            rage.antiaim:inverter(true)
            aareference.yaw.hidden:override(false)
        end
    end


    local condition = function()
        local local_player = entity.get_local_player()
        if not local_player then return "not connected" end
        local on_ground = bit.band(local_player.m_fFlags, 1) == 1
        local jump = bit.band(local_player.m_fFlags, 1) == 0
        local crouch = local_player.m_flDuckAmount > 0.7
        local vx, vy, vz = local_player.m_vecVelocity.x, local_player.m_vecVelocity.y, local_player.m_vecVelocity.z
        local move = math.sqrt(vx ^ 2 + vy ^ 2) > 5
    
        if jump and crouch then return reference.antiaim.conditions[8] end
        if antiaim_ui.freestanding:get() then return reference.antiaim.conditions[9] end
        --if aareference.fake_duck:get() then return reference.antiaim.conditions[10] end
        if crouch and move then return reference.antiaim.conditions[6] end
        if jump then return reference.antiaim.conditions[7] end
        if crouch then return reference.antiaim.conditions[5] end
        if on_ground and aareference.slow_walk:get() and move then return reference.antiaim.conditions[4] end
        if on_ground and not move then return reference.antiaim.conditions[2] end
        if on_ground and move then return reference.antiaim.conditions[3] end
    end

    local excondition = function()
        local local_player = entity.get_local_player()
        if not local_player then return "not connected" end
        local on_ground = bit.band(local_player.m_fFlags, 1) == 1
        local jump = bit.band(local_player.m_fFlags, 1) == 0
        local crouch = local_player.m_flDuckAmount > 0.7
        local vx, vy, vz = local_player.m_vecVelocity.x, local_player.m_vecVelocity.y, local_player.m_vecVelocity.z
        local move = math.sqrt(vx ^ 2 + vy ^ 2) > 5
    
        if jump and crouch then return reference.antiaim.force_defensive[7] end
        if crouch and move then return reference.antiaim.force_defensive[5] end
        if jump then return reference.antiaim.force_defensive[6] end
        if crouch then return reference.antiaim.force_defensive[4] end
        if on_ground and aareference.slow_walk:get() and move then return reference.antiaim.force_defensive[3] end
        if on_ground and not move then return reference.antiaim.force_defensive[1] end
        if on_ground and move then return reference.antiaim.force_defensive[2] end
    end

    local freestanding = function()
        if antiaim_ui.freestanding.modifications:get(1) then
            aareference.freestanding.disable_yaw_modifiers:override(true)
        else
            aareference.freestanding.disable_yaw_modifiers:override(false)
        end

        if antiaim_ui.freestanding.modifications:get(2) then
            aareference.freestanding.body_freestanding:override(true)
        else
            aareference.freestanding.body_freestanding:override(false)
        end
        if antiaim_ui.manuals:get("Left") then
            aareference.yaw.offset:override(-90)
        end
        if antiaim_ui.manuals:get("Right") then
            aareference.yaw.offset:override(90)
        end

    end

    local function get_inverter(tickss)
        local delay = tickss

        local is_delay_jitter = delay ~= nil and delay > 0

        local should_return_delay = is_delay_jitter and ctx.body_yaw

        if should_return_delay then
            return last_delay_side, true
        end

        if is_jitter and not contains(options, "Randomize Jitter") then
            return bit.band(localplayer.sent_packets, 1) ~= 0, true
        end
        return rage.antiaim:inverter(), false
    end

    local current_tick = time_to_ticks(globals.realtime)
    local function smoothJitter(switchyaw1, switchyaw2, tickss)
        local switch = false
        local speed = tickss*4

        if globals.tickcount % (8 + speed) > 2 + speed / 2 then
            switch = not switch
        end

        rage.antiaim:inverter(switch)
        return rage.antiaim:inverter() and switchyaw1 or switchyaw2
        --return switch and switchyaw1 or switchyaw2
    end

    local stateid = function()
        if antiaim[2].override:get() and condition() == reference.antiaim.conditions[2] then 
            return 2
        elseif antiaim[3].override:get() and condition() == reference.antiaim.conditions[3] then 
            return 3
        elseif antiaim[4].override:get() and condition() == reference.antiaim.conditions[4] then 
            return 4
        elseif antiaim[5].override:get() and condition() == reference.antiaim.conditions[5] then 
            return 5
        elseif antiaim[6].override:get() and condition() == reference.antiaim.conditions[6] then 
            return 6
        elseif antiaim[7].override:get() and condition() == reference.antiaim.conditions[7] then 
            return 7
        elseif antiaim[8].override:get() and condition() == reference.antiaim.conditions[8] then 
            return 8
        elseif antiaim[9].override:get() and condition() == reference.antiaim.conditions[9] then 
            return 9
        else
            return 1
        end
    end

    force_defensive_extention = function()
        if excondition() == reference.antiaim.force_defensive[1] then 
            return 1
        elseif excondition() == reference.antiaim.force_defensive[2] then 
            return 2
        elseif excondition() == reference.antiaim.force_defensive[3] then 
            return 3
        elseif excondition() == reference.antiaim.force_defensive[4] then 
            return 4
        elseif excondition() == reference.antiaim.force_defensive[5] then 
            return 5
        elseif excondition() == reference.antiaim.force_defensive[6] then 
            return 6
        elseif excondition() == reference.antiaim.force_defensive[7] then 
            return 7
        elseif excondition() == reference.antiaim.force_defensive[8] then 
            return 8
        end
    end

    local override_yaw = function(cmd, stateid)
        if antiaim[stateid].yaw:get() == "Static" then
            aareference.yaw:override("Static")
            aareference.yaw.offset:override(antiaim[stateid].yaw_static_angel:get())
        end
        if antiaim[stateid].yaw:get() == "Backward"then
            aareference.yaw:override("Backward")
            if antiaim[stateid].desync.delay_ticks:get() ~=1 then
                local yaw_delay = antiaim[stateid].desync.delay_ticks:get()
                local randomization = antiaim[stateid].desync.randomisation_delay:get() * 3
                local yawleft = antiaim[stateid].yaw_left_angel:get() + utils.random_int(0, randomization)
                local yawright = antiaim[stateid].yaw_right_angel:get() + utils.random_int(0, randomization)

                --print_dev(smoothJitter(antiaim[stateid].yaw_left_angel:get(), antiaim[stateid].yaw_right_angel:get(),yaw_delay ))
                aareference.body_yaw.options:override({})
                aareference.yaw.offset:override(smoothJitter(yawleft, yawright, yaw_delay ))
                aareference.body_yaw.inverter:override(false)
            else
                aareference.body_yaw.options:override("Jitter")
                aareference.yaw.offset:override(rage.antiaim:inverter() and antiaim[stateid].yaw_left_angel:get() or antiaim[stateid].yaw_right_angel:get())
                aareference.body_yaw.inverter:override(false)
            end

        end
        if not antiaim_ui.freestanding.cond:get(force_defensive_extention()) then
            aareference.freestanding:override(antiaim_ui.freestanding:get())
        else
            aareference.freestanding:override(false)
        end


        if antiaim_ui.freestanding.modifications:get(1) then
            aareference.freestanding.disable_yaw_modifiers:override(true)
        else
            aareference.freestanding.disable_yaw_modifiers:override(false)
        end

        if antiaim_ui.freestanding.modifications:get(2) then
            aareference.freestanding.body_freestanding:override(true)
        else
            aareference.freestanding.body_freestanding:override(false)
        end

        if antiaim_ui.manuals:get() == "Left" then
            aareference.yaw.offset:override(-90)
        end
        if antiaim_ui.manuals:get() == "Right" then
            aareference.yaw.offset:override(90)
        end
    end

    local defensivePitch = function(pitch, stateid)
        if pitch:get() == "Up" then
            return -89
        end
    
        if pitch:get() == "Down" then
            return 89
        end
    
        if pitch:get() == "Zero" then
            return 0
        end
    
        if pitch:get() == "Random" then
            return utils.random_int(antiaim[stateid].defensive_pitch_random_min:get(), antiaim[stateid].defensive_pitch_random_max:get())
        end
    
        if pitch:get() == "Sway" then
            return ((globals.curtime * 7) % 2 - 1) * antiaim[stateid].defensive_pitch_sway_value:get()
        end

        return 0
    end

    local defensiveYaw = function(yaw, stateid)

        local yaw_delay = antiaim[stateid].defensive_delay_yaw.amount:get() * 4
        local randomization = antiaim[stateid].defensive_delay_yaw.randomisation:get() * 3

        if yaw:get() == "Angels" then
            if antiaim[stateid].defensive_delay_yaw:get() then
        
                return smoothJitter((-90 + 20) + math.random(0, randomization), 90 + math.random(0, randomization), yaw_delay)
            else
                return (rage.antiaim:inverter() and -90 or 90)
            end
        end

        if yaw:get() == "Opposite" then
            if antiaim[stateid].defensive_delay_yaw:get() then
                
                return smoothJitter((-180 + 20) + math.random(0, randomization), 180 + math.random(0, randomization), yaw_delay)
            else
                return 180
            end
        end

        if yaw:get() == "Spin" then
            return globals.curtime * (70 * antiaim[stateid].defensive_yaw_spin_speed:get()) % 360
        end

        if yaw:get() == "Random" then
            if antiaim[stateid].defensive_delay_yaw:get() then
                defensive_random_first = antiaim[stateid].defensive_yaw_random_first:get()
                defensive_random_first_second = antiaim[stateid].defensive_yaw_random_second:get()
                
                return smoothJitter(defensive_random_first + math.random(0, randomization), defensive_random_first_second + math.random(0, randomization), yaw_delay)
            else
                return utils.random_int(antiaim[stateid].defensive_yaw_random_first:get(), antiaim[stateid].defensive_yaw_random_second:get())
            end
        end

        return 0
    end

    local force_defensive = function(stateid)
        --print_dev(antiaim_ui.force_defensive.cond:get(stateid - 1))
        if antiaim_ui.force_defensive.cond:get(stateid) then
            _ui.reference.ragebot.doubletap.options:override("Always On")
        else
            _ui.reference.ragebot.doubletap.options:override("On Peek")
        end
    end

    local setup = function(cmd)
        if not antiaim_ui.global_switch:get() then return end
        local stateid = stateid()
        local defstateid = force_defensive_extention()

        aareference.enable:override(antiaim_ui.global_switch:get())
        ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"):override(antiaim_ui.avoid_backstab:get())
        aareference.body_yaw:override(true)
        -- @region: yaw base
        if antiaim[stateid].yaw.yaw_base:get() == 1 then
            aareference.yaw.base:override("local view")
        end
        if antiaim[stateid].yaw.yaw_base:get() == 2 then
            aareference.yaw.base:override("at target")
        end

        override_yaw(cmd, stateid)
        safehead(cmd, stateid)
        
        if antiaim[stateid].defensive:get() then
            aareference.yaw.hidden:override(true)
            rage.antiaim:override_hidden_pitch(defensivePitch(antiaim[stateid].defensive_pitch, stateid))
                rage.antiaim:override_hidden_yaw_offset(defensiveYaw(antiaim[stateid].defensive_yaw, stateid))
                cmd.force_defensive = cmd.command_number % antiaim[stateid].defensive_chocke_value:get() == 0
        else
            aareference.yaw.hidden:override(false)
        end

        aareference.yaw_modifier:override(antiaim[stateid].yaw_modifier:get())
        aareference.yaw_modifier.offset:override(antiaim[stateid].yaw_mod_angel:get())
        force_defensive(defstateid)
        warmupaa()
    end

    events.createmove(setup)

end

local visuals do

    visuals = {}
    local widgets = {}

    local lerp = function(a, b, t)
        return a + (b - a) * t
    end

    mindmg_x = _ui.menulist.right_upper:slider("x_dmg", 1, render.screen_size().x /2, render.screen_size().x + 10)
    mindmg_y = _ui.menulist.right_upper:slider("y_dmg", 1, render.screen_size().y/2, render.screen_size().y - 25)
    mindmg_x:visibility(false)
    mindmg_y:visibility(false)
    
    visuals.watermark = _ui.menulist.right_upper:label("\v\f<input-text>\a[white]   Watermark", function(gear)
        return {
            text_color = gear:color_picker("Text color", color("#FFFFFFFF")),
            settings = gear:selectable("Disablers", {"Arrows", "Animation"})
        }
    end):depend({tab_selector, 3})

    visuals.widgets = _ui.menulist.right_upper:label("\v\f<star>\a[white]   Widgets", function(gear)
        return {
            solus_widgets = gear:selectable("Widgets", {"Watermark", "Keybinds", "Spectator list"}),
            solus_combo = gear:combo("Style", {"Selfo", "Half-rounded"}),
            solus_combo2 = gear:combo("Cheat name", {"Neverlose", "Gamesense"}),
            accent_col = gear:color_picker("Accent color", color(139, 146, 248)),  
        }
    end):depend({tab_selector, 3})

    local log_events do

        visuals.log_events = {}
        visuals.log_events.selector = _ui.menulist.right_upper:label("\v\f<water-ladder>\a[white]   Log Events", function(gear)
            return {
                selects = gear:listable("\n", {"Render", "Events", "Console"}),
                hitcolor = gear:color_picker("Hit Color", color("#769786FF")),
                misscolor = gear:color_picker("Miss Color", color("#AA7777FF")),
                purchase_color = gear:color_picker("Purchase Color", color("#AA7777FF")),
            }
        end):depend({tab_selector, 3})
        -- visuals.log_events.selector.hitcolor:depend({visuals.log_events.selector.selects, 1})
        -- visuals.log_events.selector.misscolor:depend({visuals.log_events.selector.selects, 1})
        -- visuals.log_events.selector.purchase_color:depend({visuals.log_events.selector.selects, 2})
    
        local screen_center = render.screen_size()/2
    
        local hitlog = {}
    
    
        hitgroups = {
            [0] = 'generic',
            'head', 'chest', 'stomach',
            'left arm', 'right arm',
            'left leg', 'right leg',
            'neck', 'generic', 'gear'
        }
    
        local on_aim_ack = function(ctx)
    
            local local_player = entity.get_local_player()
            local enenmy = entity.get(ctx.target)
            local enenmy_damage = ctx.damage
            local enenmy_wanted_damage = ctx.wanted_damage
            local enenmy_wanted_hitgroup = hitgroups[ctx.wanted_hitgroup]
            local hitchance = ctx.hitchance
            local misstype = ctx.state
            local backtrack = ctx.backtrack
            if not enenmy then return end
            if enenmy == nil then return end
            local health = enenmy["m_iHealth"]
            local hitgroup = hitgroups[ctx.hitgroup]
        
    
            if misstype == nil then
                if not globals.is_connected and not globals.is_in_game then return false end
                if visuals.log_events.selector.selects:get(3) then
                    print_raw("\aFFFFFFFF[ hit ] \a"..visuals.log_events.selector.hitcolor:get():to_hex()..enenmy:get_name().."\aFFFFFFFF to \a"..visuals.log_events.selector.hitcolor:get():to_hex()..hitgroup.."\aFFFFFFFF with \a"..visuals.log_events.selector.hitcolor:get():to_hex()..enenmy_damage.."\aFFFFFFFF dmg".."\aFFFFFFFF ( hitchance: \a"..visuals.log_events.selector.hitcolor:get():to_hex()..hitchance.."\aFFFFFFFF, wanted damage: \a"..visuals.log_events.selector.hitcolor:get():to_hex()..enenmy_wanted_damage.."\aFFFFFFFF, health: \a"..visuals.log_events.selector.hitcolor:get():to_hex()..health.."\aFFFFFFFF, wanted hitgroup: \a"..visuals.log_events.selector.hitcolor:get():to_hex()..enenmy_wanted_hitgroup.." \aFFFFFFFF)")
                end
                if visuals.log_events.selector.selects:get(1) then
                    --print_dev(visuals.log_events.selector.hitcolor:get())
                    print_dev("\a"..visuals.log_events.selector.hitcolor:get():to_hex().."{ frost }\aFFFFFFFF ~ hit \a"..visuals.log_events.selector.hitcolor:get():to_hex()..enenmy:get_name().."\aFFFFFFFF to \a"..visuals.log_events.selector.hitcolor:get():to_hex()..hitgroup.."\aFFFFFFFF with \a"..visuals.log_events.selector.hitcolor:get():to_hex()..enenmy_damage.."\aFFFFFFFF dmg")
                    hitlog[#hitlog+1] = {("Hit \a"..visuals.log_events.selector.hitcolor:get():to_hex()..enenmy:get_name().." \aFFFFFFFFin the \a"..visuals.log_events.selector.hitcolor:get():to_hex()..hitgroup.."\aFFFFFFFF for \a"..visuals.log_events.selector.hitcolor:get():to_hex()..enenmy_damage), 0, globals.curtime, visuals.log_events.selector.hitcolor:get():to_hex(), visuals.log_events.selector.hitcolor:get()}
                end
            end
    
            if misstype ~= nil then
                if visuals.log_events.selector.selects:get(3) then
                    print_raw("\aFFFFFFFF[ miss ] \a"..visuals.log_events.selector.misscolor:get():to_hex()..enenmy:get_name().."shot \aFFFFFFFF due to \a"..visuals.log_events.selector.misscolor:get():to_hex()..misstype.."\aFFFFFFFF in \a"..visuals.log_events.selector.misscolor:get():to_hex()..enenmy_wanted_hitgroup.." \aFFFFFFFF( hitchance: \a"..visuals.log_events.selector.misscolor:get():to_hex()..hitchance.."\aFFFFFFFF, wanted Damage: \a"..visuals.log_events.selector.misscolor:get():to_hex()..enenmy_wanted_damage.."\aFFFFFFFF, backtrack: \a"..visuals.log_events.selector.misscolor:get():to_hex()..backtrack.."\aFFFFFFFF )")
                end
                if visuals.log_events.selector.selects:get(1) then
                    print_dev("\a"..visuals.log_events.selector.misscolor:get():to_hex().."{ frost }\aFFFFFFFF ~ miss \a"..visuals.log_events.selector.misscolor:get():to_hex()..enenmy:get_name().."shot \aFFFFFFFF due to \a"..visuals.log_events.selector.misscolor:get():to_hex()..misstype.."\aFFFFFFFF in \a"..visuals.log_events.selector.misscolor:get():to_hex()..enenmy_wanted_hitgroup.." \aFFFFFFFF")
                    hitlog[#hitlog+1] = {("Missed \a"..visuals.log_events.selector.misscolor:get():to_hex().."shot \aFFFFFFFFdue to \a"..visuals.log_events.selector.misscolor:get():to_hex()..misstype), 0, globals.curtime, visuals.log_events.selector.misscolor:get():to_hex(), visuals.log_events.selector.misscolor:get()}
                end
            end
        
        end
    
        local item_purchase = function(e)
    
            local userid = entity.get(e.userid, true)
    
            if userid == nil or not userid:is_enemy()  then
                return
            end
    
            local weapon = e.weapon
    
            if weapon == "weapon_unknown" then
                return
            end
    
            local name = userid:get_name()
            local text = "\a"..visuals.log_events.selector.purchase_color:get():to_hex().."frost \aFFFFFFFF~ \a"..visuals.log_events.selector.purchase_color:get():to_hex()..name.." \aFFFFFFFFbought \a"..visuals.log_events.selector.purchase_color:get():to_hex()..weapon
            if visuals.log_events.selector.selects:get(2) then
                print_dev(text)
            end
            if visuals.log_events.selector.selects:get(3) then
                print_raw(text)
            end
        end
    
        local lerp = function(name, value, speed)
            return name + (value - name) * globals.frametime * speed
        end
    
        local notifications = function() 
            local screen = render.screen_size() 
            local y_start = screen.y * 0.9 
            local y_add = 0 
             
            for i, data in ipairs(hitlog) do 
                if globals.curtime - data[3] < 4.0 and not (#hitlog > 5 and i < #hitlog - 5) then
                    data[2] = lerp(data[2], 255, 10)
                else
                    data[2] = lerp(data[2], 0, 10)
                end
         
                local accent_color = data[5]
         
                local text_size = render.measure_text(1, "", data[1] ).x 
                local icon_size = render.measure_text(1, "", ui.get_icon("snowflake") ).x  
                local spacing = 10 
         
                local border = 10 
         
                local total_size = border * 4 + icon_size + spacing + text_size 
                --icon rect 
                render.rect( vector(screen.x / 2 - total_size / 2, y_start + y_add - 7), vector(screen.x / 2 - total_size / 2 + icon_size + border * 2, y_start + y_add + 21), color(15, 15, 15, data[2] * 0.3), 6) 
                render.push_clip_rect( vector(screen.x / 2 - total_size / 2, y_start + y_add + 19 ), vector(screen.x / 2 - total_size / 2 + icon_size + border * 2, y_start + y_add + 21 ) ) 
                render.rect( vector(screen.x / 2 - total_size / 2, y_start + y_add - 7), vector(screen.x / 2 - total_size / 2 + icon_size + border * 2, y_start + y_add + 21), color(accent_color.r, accent_color.g, accent_color.b, data[2] * 0.8), 6) 
                render.pop_clip_rect() 
                render.text( 1, vector(screen.x / 2 - total_size / 2 + border, y_start + y_add ), color(255, 255, 255, data[2]), nil, "\a"..data[4]..ui.get_icon("snowflake")) 
         
                --text rect 
                render.rect( vector(screen.x / 2 - total_size / 2 + icon_size + border * 2 + spacing, y_start + y_add - 7), vector(screen.x / 2 - total_size / 2 + icon_size + border * 4 + spacing + text_size, y_start + y_add + 21), color(15, 15, 15, data[2] * 0.3), 6) 
                 
                render.push_clip_rect(  vector(screen.x / 2 - total_size / 2 + icon_size + border * 2 + spacing, y_start + y_add + 19 ), vector(screen.x / 2 - total_size / 2 + icon_size + border * 4 + spacing + text_size, y_start + y_add + 21) ) 
                render.rect( vector(screen.x / 2 - total_size / 2 + icon_size + border * 2 + spacing, y_start + y_add - 7), vector(screen.x / 2 - total_size / 2 + icon_size + border * 4 + spacing + text_size, y_start + y_add + 21), color(accent_color.r, accent_color.g, accent_color.b, data[2] * 0.8), 6) 
                render.pop_clip_rect() 
                render.text( 1, vector(screen.x / 2 - total_size / 2 + icon_size + border * 3 + spacing - 2, y_start + y_add ), color(255, 255, 255, data[2]), nil, data[1]) 
         
                --render.rect(vector(screen.x / 2 - text_size  - 10, y / 1.15 - y_add - 6), vector(x / 2 + size + 10, y / 1.15 - y_add + 20), color(15, 15, 15, data[2]), 12) 
         
         
                --[[render.rect(vector(x / 2 - size - 10, y / 1.15 - y_add - 6), vector(x / 2 + size + 10, y / 1.15 - y_add + 20), color(15, 15, 15, data[2]), 12) 
                render.shadow(vector(x / 2 - size - 10, y / 1.15 - y_add - 6), vector(x / 2 + size + 10, y / 1.15 - y_add + 20), color(accent_color.r, accent_color.g, accent_color.b, data[2] * 0.8), 40, 0, 12) 
                render.text(1, vector(x / 2 - size, y / 1.15 - y_add), color(255, 255, 255, data[2]), nil, logs.text) 
                ]] 
         
         
                y_add = y_add - 35 * data[2] / 255 
         
                if data[3] + 5 < globals.realtime then 
                    data[2] = lerp(data[2], 0, 0.095) 
                end 
         
                if data[2] < 1 or #hitlog > 5 then 
                    table.remove(hitlog, i) 
                end 
    
            end 
        end
    
        
        
    
        events.item_purchase:set(item_purchase)
        events.aim_ack:set(on_aim_ack)
        events.render:set(notifications)
    end

    visuals.aspectratio = _ui.menulist.right_upper:slider("\v\f<image>\a[white]   Aspect ratio", 0, 200, 0, 0.01, function(self) if self == 0 then return 'Off' end end):depend({tab_selector, 3})

    visuals.viewmodel = _ui.menulist.right_upper:switch("\v\f<hands>\a[white]   Viewmodel changer", false, function(gear, item)
        return {
            fov = gear:slider("Fov", -100, 100, 68, 1):depend(item),
            x = gear:slider("X", -10, 10, 2.5, 0.5):depend(item),
            y = gear:slider("Y", -10, 10, 0, 0.5):depend(item),
            z = gear:slider("Z", -10, 10, -1.5, 0.5):depend(item),
            cs2_animation = gear:switch("CS2 Viewmodel In Scope"):depend(item)
        }
    end):depend({tab_selector, 3})

    visuals.smooth_camera_animations = _ui.menulist.left_lower:switch("\v\f<telescope>\a[white]   Smooth Zoom animations"):depend({tab_selector, 3})
    visuals.min_dmg_indication = _ui.menulist.left_lower:switch("\v\f<input-text>\a[white]   Min. DMG Indication", false, function(gear, item)
        return {
            font = gear:slider("Font", 1, 4, 1, 1,
            function(self) 
                if self == 1 then 
                    return 'Default'
                end
                if self == 2 then 
                    return 'Small'
                end
                if self == 3 then 
                    return 'Console'
                end
                if self == 4 then 
                    return 'Museo'
                end
            end):depend(item)
        }
    end):depend({tab_selector, 3})
    visuals.gamesense_indicators = _ui.menulist.left_lower:switch("\vGS    \a[white]Indicators", false, function(gear, item)
        return 
        {
            typeS = gear:list("\n", {"Old", "New"}):depend(item),
            select = gear:selectable("Select", {"Double Tap", "Hideshots", "Freestanding", "Force Baim", "Min. damage override", "Hitchance Override", "Ping reduce", "Fake Duck", "Dormant aim", "Force safepoint", "Bomb info", "Hit/Miss"}):depend(item)
        }
    end):depend({tab_selector, 3})

    local gsindic do
        local refs = {
            pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
            yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
            hidden_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
            yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
            yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
            yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
            modifier_degree = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
            body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
            left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
            right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
            options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
            inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
            freestanding_body = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
            avoid_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
            fakeduck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
            slowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
            freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
            yaw_mod = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
            body_fs = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
            doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
            lag_options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
            hideshots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
            hideshots_options = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
            legs_movement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
            body_aim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
            safe_point = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
            dormant_aimbot = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
            fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
            force_viewmodel = ui.find("Visuals", "World", "Main", "Override Zoom", "Force Viewmodel"),
            pistols_hitchance = ui.find("Aimbot", "Ragebot", "Selection", "Pistols", "Hit Chance"),
            auto_snipers_hitchance = ui.find("Aimbot", "Ragebot", "Selection", "AutoSnipers", "Hit Chance"),
            awp_hitchance = ui.find("Aimbot", "Ragebot", "Selection", "AWP", "Hit Chance"),
            ssg08_hitchance = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Hit Chance"),
            revolver_hitchance = ui.find("Aimbot", "Ragebot", "Selection", "R8 Revolver", "Hit Chance"),
            weapon_actions = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"),
            bullet_impact_duration = ui.find("Visuals", "World", "Other", "Bullet Impacts", "Duration"),
        }
        local x = render.screen_size().x
        local y = render.screen_size().y
        local calibri = render.load_font("Calibri Bold", 24, "ad")

        local bomb_img = render.load_image("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x64\x00\x00\x00\x5C\x08\x03\x00\x00\x00\xAF\x15\xE0\xA6\x00\x00\x00\x01\x73\x52\x47\x42\x01\xD9\xC9\x2C\x7F\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0B\x13\x00\x00\x0B\x13\x01\x00\x9A\x9C\x18\x00\x00\x02\xDF\x50\x4C\x54\x45\x00\x00\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x76\x99\x69\x74\x00\x00\x00\xF5\x74\x52\x4E\x53\x00\x01\x43\x93\x58\x06\x5A\xFB\xFF\xFD\x96\x04\xD5\xF9\x02\x0E\xE3\x18\x16\xEA\x2B\x1B\xEF\x36\x29\x73\x72\x1E\xF2\x3F\x75\x6B\x20\xEB\xF4\x32\x21\xF6\x47\x2F\xE7\xE2\x37\x5E\xB7\x0F\x23\xF8\x51\x08\xB3\x9A\x7D\xF7\x63\x00\x70\x7A\xC1\x25\x6E\x2D\xE0\x62\xFC\xC2\x28\x76\xAE\x88\x0B\xC9\x5D\x7E\xFA\xE9\x27\x5C\xDF\x12\x31\x84\xD8\x8C\xCF\x97\x3A\x8A\x03\xAC\xDA\x1C\x6C\x2E\x42\x8F\x7B\xA1\x4B\x95\x10\xCA\x13\x55\x3D\x1A\x33\x0A\x4E\x69\x82\xBB\x41\xC7\x80\x87\x91\x9E\xA6\xAA\x86\x7F\x5F\x26\xDC\xFE\x49\xE8\x17\xC3\x46\x89\x92\xBA\x2C\xC0\xB8\xA3\x9F\xA8\xAF\xB1\xB5\xBC\xD4\x7C\xF3\x9D\x24\x0D\x8E\x5B\x05\xD9\xD1\x99\xF1\xCC\xCB\x9B\x4F\x14\xCE\xC5\xCD\x19\x30\xF5\x07\xDE\x15\xA4\x1D\x11\xE5\x83\x2A\xA0\x71\xD6\xD0\xC6\xB9\xA9\x6D\x52\x35\xDD\x0C\xE4\x64\xED\xBF\xC4\x8D\x77\x85\x8B\x90\xEE\xE6\xA5\x78\xEC\x09\x60\x1F\x81\xAB\x9C\x98\x38\x61\x4A\xB2\x34\x4C\xDB\xA7\xD2\x45\x39\x53\xB0\xF0\xBD\x94\x4D\xB4\x44\x54\x3E\xA2\x22\x59\x6A\xE1\xD7\xAD\x40\x48\x3B\xBE\x65\x74\x34\x72\x01\xD4\x00\x00\x07\x6E\x49\x44\x41\x54\x78\x9C\xED\x9A\xF9\x5B\xD4\x46\x18\xC7\xB3\x22\x32\x2B\x8B\x8A\x58\xD0\x42\xE5\x10\x54\x28\x42\x11\x70\x11\x11\x10\x95\x22\x28\x56\x2C\x88\x14\x05\xE4\xB4\x1C\xC5\x20\x60\x45\xBC\x51\x01\xA1\x88\x88\xA2\xA2\x78\x71\x15\x15\x0B\x88\x78\x0B\x15\x54\x14\xCF\x0A\x78\xB6\xB5\xD5\x5A\xDB\xDA\xEB\x0F\x68\x66\x26\xBB\x9B\x84\xDD\x25\x86\xA5\xCF\xD3\x3E\xBE\xBF\x64\xE7\x9B\xF7\x7D\x3F\x39\x66\x92\x77\x26\x4B\x10\x02\x4C\x34\x40\x6B\xA0\xB6\x90\xC0\x37\xB1\x41\x3A\x40\x3C\xB8\x9F\x19\xBA\x12\x00\x80\xDE\x90\xFE\x85\x0C\x1D\x46\x41\x80\x7E\xFF\x42\x86\x1B\x40\xC8\x88\xFE\x85\xBC\x63\x08\x21\x46\x9A\x4B\x38\x72\xD4\xBB\x3D\x0E\xD9\xD8\x04\x42\xDE\xE3\xA8\xA2\x91\xA3\x4D\xCD\x04\x31\xF4\xCD\x01\xB0\x18\xC3\x11\x2D\xAD\x20\x64\x2C\x47\x1D\x37\x1E\x00\x6B\x1B\x21\x90\xF7\x61\x3A\xDB\x09\x6C\xD1\xCE\x1E\xAA\x1F\xB0\x45\x87\x89\x50\x74\x14\x02\xB1\x13\xC3\x50\x27\x8E\xE8\x0C\xC5\x49\x2C\x4D\xEA\xA2\x03\xC5\xC9\x42\x20\x84\x2B\x0C\x15\xB3\x6F\xCB\x14\x3D\x28\xBA\xB1\xB4\xA9\xE3\xA1\xE6\x6E\x26\x08\xE2\xE1\x09\x83\xA7\x39\x30\x35\x2F\xA4\x4D\x67\x4A\xBA\x33\xA0\x04\x66\x0A\x62\x10\xDE\x1F\xA2\x68\x1F\xA6\x36\x02\x49\xB3\x18\x8A\xD4\xC3\x17\x4A\x7E\xB3\x85\x41\x88\x39\x28\xA3\xFF\x5C\x86\xF4\x11\x92\xE6\x31\x14\xCB\x00\x24\xCD\x17\xFC\xA8\xF9\x18\xC5\x07\x32\xE2\x83\x90\xB2\x40\x21\x04\x2F\x44\x4A\xC8\x27\x42\x19\x44\x28\xBA\x03\x16\x8B\x14\xCA\x62\x94\x32\x4C\x21\x8C\x45\x02\x08\x17\xCC\x90\xDD\x95\x08\x85\xB2\x04\x09\x91\xF2\x76\x14\xF6\x88\x8E\x11\x0E\x21\xC6\xC4\x42\x8B\x53\x08\x4B\x91\xF0\xA9\xBC\x1D\x9F\x90\xE8\x96\xE4\xF8\x59\x72\x1F\x18\x6F\xED\x7F\x63\x52\xE3\x50\xDB\x65\x83\x44\xB2\x66\x82\xA9\x9B\x13\x49\x92\x29\xCB\x23\xB1\x05\xA6\xA6\xA5\xF3\xB4\x88\x40\x18\xA0\xB5\xE2\x73\x97\x95\x19\x6C\x86\xFE\x74\x77\xAA\x57\xDB\x7B\xE1\x96\x03\x69\x0F\x34\x61\xAB\x18\x7D\x7C\xC8\x94\xF9\xAB\x32\x91\xBA\x1A\x0B\x6E\x62\x8D\x30\xA8\x27\xB5\xB7\x8C\x61\xB6\x60\x0D\xAD\x19\xAC\xC5\xCA\x3A\x0D\x31\x80\xF3\x7A\x9C\xD0\x7B\x83\xBF\x4C\xB2\x5A\x42\x63\xFD\xD5\x05\xBE\x91\x85\xA2\x7C\x1B\xCD\xE5\x42\xD6\x26\xD9\xB9\x19\xF0\xCB\x10\xB0\x79\x4B\x76\x8E\xC2\x22\xB2\xD3\x72\xD3\x17\x6E\xCD\x9B\x98\xBF\x25\xEB\x8B\x02\xEC\xB2\x0D\xE5\x93\x47\x78\x92\x51\xF2\x9B\x54\xC8\x07\x61\xA1\xF6\x6D\x14\x8B\x9D\x52\x98\x10\xCF\xED\x45\x0C\x0F\x5E\x7D\xCB\x7A\x07\x0F\x48\x31\x03\xE2\xB7\x73\x17\xD3\x83\x57\xE7\x2A\xD9\xA5\x34\x3B\x1B\xA2\x25\x87\x18\x6A\x71\x0A\x65\x3E\x0C\x20\x11\x29\xC9\xCD\x85\x04\xA2\x06\xF5\x8A\xCB\x32\xD2\xE5\x78\xF0\x82\xEC\x56\xC7\x90\x41\xF6\xA0\xC6\xDE\xD2\xD5\x5C\x04\x4F\xC8\x3E\x3E\x90\xFD\xA8\x51\x76\x40\x89\x07\x2F\xC8\x41\x3E\x90\xED\xAA\x3D\x78\x41\x0E\xF1\x81\xA4\xF6\x11\x12\x0D\x3D\x63\xE2\x0E\x1F\x11\x89\xCA\x2B\x66\x0E\x25\x2A\xC3\x4B\x8D\xE3\x35\x0D\x29\x80\x9E\xB9\x85\x3A\x55\xD5\xC3\xFD\x80\xD5\x72\x62\x52\xA6\x78\x8D\x62\x42\x41\x43\x72\xFA\x08\x91\x48\x29\xCF\x2F\x01\x30\xA9\x39\x7A\x0C\x96\x75\xC7\xA9\x9F\xB5\x5C\xC8\x89\xBE\x42\xE0\x38\xB1\xFC\x2A\x2B\xD6\x41\x64\x63\x10\xB8\x96\x98\xBD\xA0\xC4\x67\x82\xA6\x21\x75\x6A\x8B\x5C\x0D\x41\x02\x82\xFF\x05\x48\x88\xDA\x45\x0E\x1A\x82\x0B\xD9\xF1\xC3\xAA\x4A\x0A\xEA\xF7\x35\xB8\x9E\x9C\x91\xDE\xB8\x67\xDE\xA9\xA6\xD3\x4B\x45\xFC\x20\x67\x1C\x78\x40\xB2\x55\x1C\xB4\xA1\x1B\x3F\x88\xFB\x59\x1E\x90\x34\x55\x57\x66\x95\x4A\x88\x39\xAA\x79\xF6\xE2\xC6\xB9\x28\x1E\x90\x74\x55\x10\x13\x55\x90\xCC\xF3\x28\x44\x82\x5B\x17\xD4\x2E\xA4\xF4\x06\x89\x56\x05\xB9\x38\x81\x09\x11\x5F\xCA\x6B\x6E\x19\xCD\xB0\x96\xC9\xDB\x66\x91\x49\x5F\xA7\x6C\xB8\xDC\xDC\xBA\xD1\x96\x03\x11\x5B\xB4\x5D\x71\x2F\x91\x48\x0E\xBB\xE6\x5F\x6D\xBD\x66\xDA\x14\xA3\x02\xD2\x6E\x44\x5C\x2F\x52\x40\x78\x59\x23\x82\x1C\xF5\x56\xD2\xDD\x95\x07\xB4\x4A\x45\xE1\x37\x04\x41\x94\x9A\xCC\xC5\x6A\xF3\xAC\xB8\x8E\xCA\xA8\x51\xA8\x51\x65\x46\x94\x5F\x18\xCB\x80\x18\xEE\x27\x6F\xE6\x9A\x50\xDD\xAC\x99\x24\xB3\x9D\xA9\x6E\xB1\x35\x29\xE9\x96\x0E\x35\x4A\xC3\x48\xF2\xB6\x2F\x5F\x48\xBD\x11\x7E\x8D\xD7\xC0\x86\xAF\x87\x94\xB8\x03\xEE\x32\x20\xF7\xE0\x3E\x12\x80\x32\xB8\x0D\x03\x7A\x41\xD4\x46\xBA\x05\xB4\x75\xC0\xF6\x49\xEC\x93\xDB\x1B\xA4\x74\x28\x6E\x49\xBF\x81\xAD\xFB\xC1\x44\x67\x3B\x58\xC4\x80\xA0\xC5\xAD\x2E\x00\x3A\xF1\xD6\x1F\xD5\xBD\x81\xA0\x1B\x3D\x09\x22\xB1\xCF\x83\x5E\x20\x7A\xB0\xA0\xDC\x71\xF9\xA1\x44\xD2\x4E\xB5\x2A\x3A\x08\xDD\x13\x78\x69\x4E\x06\x81\x67\x45\x3C\x02\x00\x4D\x3E\x1F\xD3\xD5\xCB\x6D\xB0\xAA\x12\x6E\xB5\xF8\x41\xF2\xA8\x1F\xDA\xF7\xE9\x84\x99\xCD\x54\x1E\x67\x36\xE4\x11\x74\x6D\x02\xE0\x09\xDC\x2E\xA1\xEB\xB0\x5B\x74\xD1\x97\x8D\x7D\xD2\x7A\x81\xC0\x4B\x7E\x4F\xD6\x05\xFC\x6B\x08\x22\x15\xB0\x21\xA7\x6A\x29\x73\x02\x20\xDC\x4C\xBF\xBA\xA6\x11\x54\x94\x0D\xAF\x5E\x5A\x74\x08\x98\x07\x41\x9D\x9E\x18\x5C\xED\x05\x72\x9A\xBA\x1B\x0D\x32\xC8\x64\x6A\x86\xE1\x2A\x91\x48\xEC\xA8\xBD\x79\x12\x13\x15\x1D\xB6\xA7\xE1\x07\xE4\x01\x65\x6F\x05\xB4\x7F\x1C\x35\x3B\xAA\xA3\x7D\xCD\xD9\xCF\xA9\xC1\xBC\x21\xF8\x51\xDF\xB0\xDC\x58\x05\x04\xCE\x5F\x02\x69\xDF\xA7\xEC\xFD\x37\x91\xA8\x53\x25\x09\xF8\x96\xDA\x7A\x76\x4B\x4A\x2C\xA0\x60\x20\xA9\x6B\xA3\x36\xCE\x25\x92\xEE\x0A\x3A\x10\xD7\x5D\x56\xA0\xDD\xAD\x47\x79\x8E\xF6\xC3\x05\xB2\x8C\x76\xEC\xDB\x10\x4B\x1B\xEC\xD5\x46\xB1\xDF\x21\xB1\x39\x46\x5A\x69\x33\x0D\x00\xC7\xB3\xC4\xF5\xE4\x6E\x00\xBE\xAF\x15\xE9\x06\xED\x05\xBE\xE7\xE3\x89\x1D\xCF\xDA\x70\x20\x5E\x7F\x84\x87\xF0\xC3\x5D\x65\x90\x68\xD8\x25\xCB\x1F\x5A\xB1\x4E\x1F\xDE\xF8\x83\xF4\x6F\x38\xF8\x88\xD5\x00\xA0\x3A\x28\x14\xF8\xA1\x5A\x74\x06\xB0\x46\xC3\x2B\x15\xFB\xE0\x15\x1D\x3C\xA9\x0A\xEB\xE8\x09\x11\xFF\x08\x7F\xCE\x1D\xF0\x3C\x36\x96\x05\x91\xCA\x7A\xD7\x63\xB8\x3F\x19\x80\xA9\x70\xFB\x02\x04\xA0\x9A\x7A\x3F\x3D\x4E\xE8\xDB\x86\xD7\xA6\x86\xE1\x46\x48\x53\x30\x17\x02\xCE\x58\xD2\x4D\x11\xFB\x4C\x64\x90\xC5\x70\x5F\x17\x3D\x5E\x64\x83\x31\x82\x1E\xF9\x3F\x61\x9F\x15\x28\x41\xB7\x2C\x3C\xFD\xA5\x94\x03\x01\x75\x03\xF1\x1B\xD6\x4C\x39\xA4\x0B\xEE\xF3\x01\xE0\x67\xB8\x7D\x05\xAE\xA0\xD5\xC2\x3C\x70\x0C\xF5\x44\x7A\x14\x87\xA3\x04\x97\xE5\xF3\xC3\xAA\x04\x2E\x04\x00\xFB\x89\xC5\x24\x19\xF6\x0B\x50\x6A\x05\x17\x29\x2B\x01\xE0\xD7\xAD\xD9\x39\xE9\xD4\xAD\x0B\x89\xC8\x79\x90\x6F\x08\x7C\x2F\x41\xDD\x10\xFB\xBC\xC2\x09\x2D\x9F\xCA\xBA\x1B\x28\x9E\xCB\x85\xF4\xD5\x3C\x9F\xD0\x19\x77\x25\x94\x66\xD2\x5A\x3E\x3D\x0D\xB4\xD6\x14\x64\x8D\x97\xFC\xEA\x54\x27\xD6\xD1\x53\x51\x7A\x79\xEF\x74\xB7\xFA\x58\xDE\xD6\xC8\x2C\x65\x8F\x5C\xC3\x07\x2F\xFB\x40\x30\xD5\xBD\x4F\xB9\xC5\x15\x15\x15\x85\x06\x7E\x55\xBF\xD9\xB1\x46\x06\x61\xD6\xB2\xCF\xB0\x30\x57\x3E\x6B\x1E\x11\xDB\x17\x6B\x4A\x7E\xFD\xFA\xC5\xA6\x91\x4A\x66\x8A\xDA\x9D\x71\xF1\x3D\xD5\xB7\xF6\x5F\x31\x6F\x17\x92\x24\x9D\x7C\x18\x8B\xFD\x2F\x49\x68\xBF\x2B\x84\x3F\xA0\x0B\x39\x5D\x6D\x55\xAE\xDE\x12\xD1\x77\x24\xF1\x33\x85\xF2\x02\xF5\xDD\xF9\x0A\xE1\x39\xEE\xCD\xA6\xC2\x21\xA5\x28\xC1\x6E\x6F\x85\x62\x83\x94\x14\x85\xA0\xBD\x0C\x29\xD1\x6A\x67\x31\xEA\x6C\x10\x8A\xF7\x65\x7E\xBA\x2C\x47\x52\x12\x43\xE9\x44\xAF\x2A\x4F\x37\x6E\x30\x4F\xBB\x8E\x0F\xD2\x91\xB9\x16\xD5\xF3\x73\xD3\x90\xE3\x48\xAA\x57\xB6\x78\xC3\xC3\x6E\xA0\x3B\x72\xC1\x92\xA9\x79\xA1\xA7\x5F\x0B\x53\x8A\xA9\x47\x14\x0F\x61\x90\x3F\x51\xF0\x24\x29\x53\xCB\x40\x65\xBC\x0B\xCB\xEF\x39\x02\xAF\x13\xF4\x57\x80\xB5\xE8\x44\x6C\xD9\x6B\x05\x45\x68\xDD\x32\x91\xA5\x69\x47\x40\xCD\xBE\x4B\x08\x64\x25\x0C\x3D\x57\xCB\x16\xF1\xB7\x5F\xCE\xA5\xE9\x40\xAF\x8C\x40\x21\x90\x32\x18\x39\x87\x23\x76\xA0\xF2\x6E\x27\x47\xFD\x8B\xBA\x60\x3A\xA1\x42\x20\xBA\x91\x56\x86\x4E\xDC\x85\x95\x1A\x34\xF1\xE6\x7C\x60\x26\x1C\xFE\x0E\x28\xBD\xA7\xB9\xBF\x67\x1C\x41\x25\xE3\x7A\x8D\xE5\x53\x6A\xD5\x7E\x10\xA2\xC1\x7F\x16\x28\x33\xFC\x47\x0C\xCB\xDE\x1D\xFB\x62\xBA\x70\x96\xE1\xAB\x76\xD1\x5B\x03\x56\x4C\x41\xA6\xF5\x33\x83\x88\x69\x4D\xBF\x93\xD1\xBB\x9B\xDC\xFE\x01\x51\x90\x30\x2B\x44\x5E\xBA\x6C\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82", vector(32, 27))

        local function calc_dist(pos1, pos2)
            local lx = pos1.x
            local ly = pos1.y
            local lz = pos1.z
            local tx = pos2.x
            local ty = pos2.y
            local tz = pos2.z
            local dx = lx - tx
            local dy = ly - ty
            local dz = lz - tz
            return math.sqrt(dx * dx + dy * dy + dz * dz);
        end

        local hitted, reg_shot = 0, 0

        local get_bind = function(name)
            local state = false
            local value = 0
            local binds = ui.get_binds()
            for i = 1, #binds do
                if binds[i].name == name and binds[i].active then
                    state = true
                    value = binds[i].value
                end
            end
            return {state, value}
        end

        local hitrate_stuff = function(e)
            if e.state == nil then hitted = hitted + 1 end
            reg_shot = reg_shot + 1
        end

        local function render_indicators(text, colors, ind_dst, img)
            local ts = render.measure_text(calibri, "ad", text)
            local x = 28
            local y = y - 350
            if img then
                render.gradient(vector(5, y + 3 - ind_dst), vector(x + ((img.width) + (ts.x)) / 2 + 3, y + 37 - ind_dst), color(0, 0, 0, 0), color(0, 0, 0, 80), color(0, 0, 0, 0), color(0, 0, 0, 80))
                render.gradient(vector(x + ((img.width) + (ts.x)) / 2 + 3, y + 3 - ind_dst), vector(x + (ts.x) + (img.width) + 29, y + 37 - ind_dst), color(0, 0, 0, 80), color(0, 0, 0, 0), color(0, 0, 0, 80), color(0, 0, 0, 0))
                render.texture(img, vector(x, y + 6 - ind_dst), colors)
                render.text(calibri, vector(x + (img.width) + 6, y + 10 - ind_dst), colors, "d", text)
            else
                render.gradient(vector(5, y + 3 - ind_dst), vector(x + (ts.x) / 2, y + 37 - ind_dst), color(0, 0, 0, 0), color(0, 0, 0, 80), color(0, 0, 0, 0), color(0, 0, 0, 80))
                render.gradient(vector(x + (ts.x) / 2, y + 3 - ind_dst), vector(x + (ts.x) + 23, y + 37 - ind_dst), color(0, 0, 0, 80), color(0, 0, 0, 0), color(0, 0, 0, 80), color(0, 0, 0, 0))
                render.text(calibri, vector(x, y + 4 - ind_dst + 5), colors, "d", text)
            end
        end

        local render_new_indic = function(text, colors, offset, icon) 
            local ts = render.measure_text(calibri, "ad", text)
            local x = 13
            local y = y - 350

            --render.gradient(vector(5, y + 3 - offset), vector(x + (ts.x) / 2, y + 37 - offset), color(0, 0, 0, 0), color(0, 0, 0, 80), color(0, 0, 0, 0), color(0, 0, 0, 80))
            --render.rect(vector(5, y + 3 - offset), vector(10, y - 4), color())
            render.gradient(vector(5, y + 3 - offset), vector(x + (ts.x) / 2, y + 37 - offset), color(0, 0, 0, 80), color(0, 0, 0, 0), color(0, 0, 0, 80), color(0, 0, 0, 0))
            render.text(calibri, vector(x, y + 4 - offset + 5), colors, "", ui.get_icon(icon).." "..text)
            render.rect(vector(x - 10, y + 5- offset), vector(x - 4 , y + 35 - offset), colors)
        end

        gamesense_indicators = function()
            if not visuals.gamesense_indicators:get() then return end
            local lp = entity.get_local_player()
            if lp == nil or not lp:is_alive() then return end  
            if lp == nil or not lp:is_alive() then hitted, reg_shot = 0, 0 end
        
        	local ind_dst = 0
            local ind_spr = 41
        
            local x = 28
            local y = y - 350

            if visuals.gamesense_indicators.typeS:get() == 2 then
        
                if visuals.gamesense_indicators.select:get("Hit/Miss") then
        	    	local percent = hitted > 0 and reg_shot > 0 and (hitted / reg_shot) * 100 or 0
                    render_new_indic(string.format("%d/%d (%.1f)", hitted, reg_shot, percent), color(215, 215, 215, 255), ind_dst, "")
        	    	ind_dst = ind_dst + ind_spr
        	    end
            
                if visuals.gamesense_indicators.select:get("Ping Reduce") and refs.fake_latency:get() > 0 then
        	    	render_new_indic("PING", color(150, 189, 18, 255), ind_dst, "satellite-dish")
        	    	ind_dst = ind_dst + ind_spr
        	    end
            
        	    if visuals.gamesense_indicators.select:get("Double Tap") and visuals.gamesense_indicators.select:get("Hideshots") then
        	    	if refs.doubletap:get() and refs.hideshots:get() then
        	    		render_new_indic("DT", rage.exploit:get() == 1 and color(215, 215, 215, 255) or color(255, 0, 0, 255), ind_dst, "sparkles")
        	    		ind_dst = ind_dst + ind_spr
        	    	elseif refs.hideshots:get() then
        	    		render_new_indic("OSAA", color(215, 215, 215, 255), ind_dst, "sparkles")
        	    		ind_dst = ind_dst + ind_spr
        	    	elseif refs.doubletap:get() then
        	    		render_new_indic("DT", rage.exploit:get() == 1 and color(215, 215, 215, 255) or color(255, 0, 0, 255), ind_dst, "sparkles")
        	    		ind_dst = ind_dst + ind_spr
        	    	end
                elseif visuals.gamesense_indicators.select:get("Doubletap") and refs.doubletap:get() then
        	    	render_new_indic("DT", rage.exploit:get() == 1 and color(215, 215, 215, 255) or color(255, 0, 0, 255), ind_dst, "sparkles")
                    --render_new_indic("sd", color(255, 0, 0, 255), ind_dst, "snowflake")
        	    	ind_dst = ind_dst + ind_spr
        	    elseif visuals.gamesense_indicators.select:get("Hideshots") and refs.hideshots:get() then
        	    	render_new_indic("OSAA", color(215, 215, 215, 255), ind_dst, "sparkles")
        	    	ind_dst = ind_dst + ind_spr
        	    end

                if visuals.gamesense_indicators.select:get("Freestanding") and refs.freestanding:get() then
        	    	render_new_indic("FS", color(215, 215, 215, 255), ind_dst, "key-skeleton-left-right")
        	    	ind_dst = ind_dst + ind_spr
        	    end
            
                if visuals.gamesense_indicators.select:get("Force Baim") and refs.body_aim:get() == "Force" then
        	    	render_new_indic("BODY", color(215, 215, 215, 255), ind_dst, "child")
        	    	ind_dst = ind_dst + ind_spr
        	    end
            
                if visuals.gamesense_indicators.select:get("Min. damage override") and get_bind("Min. Damage")[1] then
                    render_new_indic("MD", color(215, 215, 215, 255), ind_dst, "input-numeric")
        	    	--render_indicators("MD", color(215, 215, 215, 255), ind_dst)
        	    	ind_dst = ind_dst + ind_spr
        	    end
            
                if visuals.gamesense_indicators.select:get("Hitchance Override") and get_bind("Hit Chance")[1] then
        	    	render_new_indic("HC", color(215, 215, 215, 255), ind_dst, "input-numeric")
        	    	ind_dst = ind_dst + ind_spr
        	    end

        	    if visuals.gamesense_indicators.select:get("Fake Duck") and refs.fakeduck:get() then
        	    	render_new_indic("DUCK", color(215, 215, 215, 255), ind_dst, "duck")
        	    	ind_dst = ind_dst + ind_spr
        	    end
            
                local dormant_work = #entity.get_players(true, false) ~= #entity.get_players(true, true)
                if visuals.gamesense_indicators.select:get("Dormant aim") and refs.dormant_aimbot:get() then
                    if dormant_work then
                        render_new_indic("DA", color(215, 215, 215, 255), ind_dst, "eye-slash")
                    else
                        render_new_indic("DA", color(255, 0, 0, 255), ind_dst, "eye-slash")
                    end
                    ind_dst = ind_dst + ind_spr
                end
            
                if visuals.gamesense_indicators.select:get("Force safepoint") and refs.safe_point:get() == "Force" then
        	    	render_new_indic("SAFE", color(215, 215, 215, 255), ind_dst, "child")
        	    	ind_dst = ind_dst + ind_spr
        	    end
            
        	    if visuals.gamesense_indicators.select:get("Bomb Info") then
        	    	local c4 = entity.get_entities("CPlantedC4")[1];
        	    	if c4 ~= nil then
                        local lp = entity.get_local_player()
                        if lp == nil then return end
                        local time = ((c4.m_flC4Blow - globals.curtime) * 10) / 10
                        local defused = c4.m_bBombDefused
        	    		if math.floor(time) >= -1 and not defused then
                            local defusestart = c4.m_hBombDefuser ~= 4294967295
                            local defuselength = c4.m_flDefuseLength
                            local defusetimer = defusestart and math.floor((c4.m_flDefuseCountDown - globals.curtime) * 10) / 10 or -1
        	    			if defusetimer > 0 and not abort_defuse then
                                local col = math.floor(time) > defusetimer and color(58, 191, 54, 160) or color(252, 18, 19, 125)
                                local barlength = (((screen.y - 50) / defuselength) * (defusetimer))
                                render.rect(vector(0, 0), vector(16, screen.y), color(25, 25, 25, 160))
                                render.rect(vector(0, screen.y - barlength), vector(16, screen.y), col)
                            end
        	    			local bombsite = c4.m_nBombSite == 0 and "A" or "B"
                            local health = lp.m_iHealth
                            local armor = lp.m_ArmorValue
                            local will_die = false
                            local eLoc = c4.m_vecOrigin
                            local lLoc = lp.m_vecOrigin
                            local distance = calc_dist(eLoc, lLoc)
                            local a = 450.7
                            local b = 75.68
                            local c = 789.2
                            local d = (distance - b) / c;
        	    			local damage = a * math.exp(-d * d)
                            if armor > 0 then
                                local newDmg = damage * 0.5;
                                local armorDmg = (damage - newDmg) * 0.5
                                if armorDmg > armor then
                                    armor = armor * (1 / .5)
                                    newDmg = damage - armorDmg
                                end
                                damage = newDmg;
                            end
        	    			local dmg = math.ceil(damage)
                            if dmg >= health then
                                will_die = true
                            else
                                will_die = false
                            end
                            if time > 0.01 then
                                render_new_indic(bombsite .. " - " .. string.format("%.1f", time >= 0 and time or 0) .. "s", color(215, 215, 215, 255), ind_dst, "bomb")
                                ind_dst = ind_dst + ind_spr
                            
                                if lp:is_alive() then
                                    if will_die then
                                        render_new_indic("FATAL", color(255, 0, 0, 255), ind_dst, "bomb")
                                        ind_dst = ind_dst + ind_spr
                                    elseif damage > 0.5 then
                                        render_new_indic("-" .. dmg .. " HP", color(255, 240, 100, 255), ind_dst, "bomb")
                                        ind_dst = ind_dst + ind_spr
                                    end
                                end
                            end
        	    		end
        	    	end
                
        	    	if bomb.state == false then
        	    		render_new_indic(bomb.site, color(255, 240, 100, 255), ind_dst, "bomb")
                        ts = render.measure_text(calibri, "ad", bomb.site) + vector(20, 0)
                        render.circle_outline(vector(x + ts.x + 32, y + ts.y/2 - ind_dst + 9), color(0, 0, 0, 255), 9.5, 0, 1, 4)
                        render.circle_outline(vector(x + ts.x + 32, y + ts.y/2 - ind_dst + 9), color(255, 255, 255, 255), 9, 0, bomb.plant_percentage, 3)
        	    		ind_dst = ind_dst + ind_spr
                    end
        	    end
            end
            if visuals.gamesense_indicators.typeS:get() == 1 then
                if visuals.gamesense_indicators.select:get("Hit/Miss") then
        	    	local percent = hitted > 0 and reg_shot > 0 and (hitted / reg_shot) * 100 or 0
                    render_indicators(string.format("%d/%d (%.1f)", hitted, reg_shot, percent), color(215, 215, 215, 255), ind_dst)
        	    	ind_dst = ind_dst + ind_spr
        	    end
            
                if visuals.gamesense_indicators.select:get("Ping Reduce") and refs.fake_latency:get() > 0 then
        	    	render_indicators("PING", color(150, 189, 18, 255), ind_dst)
        	    	ind_dst = ind_dst + ind_spr
        	    end
            
        	    if visuals.gamesense_indicators.select:get("Double Tap") and visuals.gamesense_indicators.select:get("Hideshots") then
        	    	if refs.doubletap:get() and refs.hideshots:get() then
        	    		render_indicators("DT", rage.exploit:get() == 1 and color(215, 215, 215, 255) or color(255, 0, 0, 255), ind_dst)
        	    		ind_dst = ind_dst + ind_spr
        	    	elseif refs.hideshots:get() then
        	    		render_indicators("OSAA", color(215, 215, 215, 255), ind_dst)
        	    		ind_dst = ind_dst + ind_spr
        	    	elseif refs.doubletap:get() then
        	    		render_indicators("DT", rage.exploit:get() == 1 and color(215, 215, 215, 255) or color(255, 0, 0, 255), ind_dst)
        	    		ind_dst = ind_dst + ind_spr
        	    	end
                elseif visuals.gamesense_indicators.select:get("Doubletap") and refs.doubletap:get() then
        	    	render_indicators("DT", rage.exploit:get() == 1 and color(215, 215, 215, 255) or color(255, 0, 0, 255), ind_dst)
                    --render_indicators("sd", color(255, 0, 0, 255), ind_dst, "snowflake")
        	    	ind_dst = ind_dst + ind_spr
        	    elseif visuals.gamesense_indicators.select:get("Hideshots") and refs.hideshots:get() then
        	    	render_indicators("OSAA", color(215, 215, 215, 255), ind_dst)
        	    	ind_dst = ind_dst + ind_spr
        	    end

                if visuals.gamesense_indicators.select:get("Freestanding") and refs.freestanding:get() then
        	    	render_indicators("FS", color(215, 215, 215, 255), ind_dst)
        	    	ind_dst = ind_dst + ind_spr
        	    end
            
                if visuals.gamesense_indicators.select:get("Force Baim") and refs.body_aim:get() == "Force" then
        	    	render_indicators("BODY", color(215, 215, 215, 255), ind_dst)
        	    	ind_dst = ind_dst + ind_spr
        	    end
            
                if visuals.gamesense_indicators.select:get("Min. damage override") and get_bind("Min. Damage")[1] then
                    render_indicators("MD", color(215, 215, 215, 255), ind_dst)
        	    	--render_indicators("MD", color(215, 215, 215, 255), ind_dst)
        	    	ind_dst = ind_dst + ind_spr
        	    end
            
                if visuals.gamesense_indicators.select:get("Hitchance Override") and get_bind("Hit Chance")[1] then
        	    	render_indicators("HC", color(215, 215, 215, 255), ind_dst)
        	    	ind_dst = ind_dst + ind_spr
        	    end

        	    if visuals.gamesense_indicators.select:get("Fake Duck") and refs.fakeduck:get() then
        	    	render_indicators("DUCK", color(215, 215, 215, 255), ind_dst)
        	    	ind_dst = ind_dst + ind_spr
        	    end
            
                local dormant_work = #entity.get_players(true, false) ~= #entity.get_players(true, true)
                if visuals.gamesense_indicators.select:get("Dormant aim") and refs.dormant_aimbot:get() then
                    if dormant_work then
                        render_indicators("DA", color(215, 215, 215, 255), ind_dst)
                    else
                        render_indicators("DA", color(255, 0, 0, 255), ind_dst)
                    end
                    ind_dst = ind_dst + ind_spr
                end
            
                if visuals.gamesense_indicators.select:get("Force safepoint") and refs.safe_point:get() == "Force" then
        	    	render_indicators("SAFE", color(215, 215, 215, 255), ind_dst)
        	    	ind_dst = ind_dst + ind_spr
        	    end
            
        	    if visuals.gamesense_indicators.select:get("Bomb Info") then
        	    	local c4 = entity.get_entities("CPlantedC4")[1];
        	    	if c4 ~= nil then
                        local lp = entity.get_local_player()
                        if lp == nil then return end
                        local time = ((c4.m_flC4Blow - globals.curtime) * 10) / 10
                        local defused = c4.m_bBombDefused
        	    		if math.floor(time) >= -1 and not defused then
                            local defusestart = c4.m_hBombDefuser ~= 4294967295
                            local defuselength = c4.m_flDefuseLength
                            local defusetimer = defusestart and math.floor((c4.m_flDefuseCountDown - globals.curtime) * 10) / 10 or -1
        	    			if defusetimer > 0 and not abort_defuse then
                                local col = math.floor(time) > defusetimer and color(58, 191, 54, 160) or color(252, 18, 19, 125)
                                local barlength = (((screen.y - 50) / defuselength) * (defusetimer))
                                render.rect(vector(0, 0), vector(16, screen.y), color(25, 25, 25, 160))
                                render.rect(vector(0, screen.y - barlength), vector(16, screen.y), col)
                            end
        	    			local bombsite = c4.m_nBombSite == 0 and "A" or "B"
                            local health = lp.m_iHealth
                            local armor = lp.m_ArmorValue
                            local will_die = false
                            local eLoc = c4.m_vecOrigin
                            local lLoc = lp.m_vecOrigin
                            local distance = calc_dist(eLoc, lLoc)
                            local a = 450.7
                            local b = 75.68
                            local c = 789.2
                            local d = (distance - b) / c;
        	    			local damage = a * math.exp(-d * d)
                            if armor > 0 then
                                local newDmg = damage * 0.5;
                                local armorDmg = (damage - newDmg) * 0.5
                                if armorDmg > armor then
                                    armor = armor * (1 / .5)
                                    newDmg = damage - armorDmg
                                end
                                damage = newDmg;
                            end
        	    			local dmg = math.ceil(damage)
                            if dmg >= health then
                                will_die = true
                            else
                                will_die = false
                            end
                            if time > 0.01 then
                                render_indicators(bombsite .. " - " .. string.format("%.1f", time >= 0 and time or 0) .. "s", color(215, 215, 215, 255), ind_dst, bomb_img)
                                ind_dst = ind_dst + ind_spr
                            
                                if lp:is_alive() then
                                    if will_die then
                                        render_indicators("FATAL", color(255, 0, 0, 255), ind_dst)
                                        ind_dst = ind_dst + ind_spr
                                    elseif damage > 0.5 then
                                        render_indicators("-" .. dmg .. " HP", color(255, 240, 100, 255), ind_dst)
                                        ind_dst = ind_dst + ind_spr
                                    end
                                end
                            end
        	    		end
        	    	end
                
        	    	if bomb.state == false then
        	    		render_indicators(bomb.site, color(255, 240, 100, 255), ind_dst, bomb_img)
                        ts = render.measure_text(calibri, "ad", bomb.site) + vector(20, 0)
                        render.circle_outline(vector(x + ts.x + 32, y + ts.y/2 - ind_dst + 9), color(0, 0, 0, 255), 9.5, 0, 1, 4)
                        render.circle_outline(vector(x + ts.x + 32, y + ts.y/2 - ind_dst + 9), color(255, 255, 255, 255), 9, 0, bomb.plant_percentage, 3)
        	    		ind_dst = ind_dst + ind_spr
                    end
        	    end
            end
        end
        events.aim_ack:set(function(e) 
            hitrate_stuff(e)
        end)
        events.render:set(function() 
            gamesense_indicators()
        end)
    end
    smoothy_fov = nil
    local smooth_camera_animations = function(e)
        if not visuals.smooth_camera_animations:get() then return end
        if smoothy_fov == nil then
            smoothy_fov = smoothy.new(e.fov)
        end

        e.fov = smoothy_fov:update(0.05, e.fov)
    end

    local viewmodel = function()
        if entity.get_local_player() == nil then return end
        if visuals.viewmodel:get() then
            cvar.viewmodel_fov:int(visuals.viewmodel.fov:get(), true)
	    	cvar.viewmodel_offset_x:float(visuals.viewmodel.x:get(), true)
	    	cvar.viewmodel_offset_y:float(visuals.viewmodel.y:get(), true)
	    	cvar.viewmodel_offset_z:float(visuals.viewmodel.z:get(), true)
            if visuals.viewmodel.cs2_animation:get() and entity.get_local_player().m_bIsScoped then
                if x_smooth == nil then
                    x_smooth = smoothy.new(visuals.viewmodel.x:get())
                end
                --print_dev(x_smooth:update(-0.05, visuals.viewmodel.x:get()))

                cvar.viewmodel_fov:int(68, true)
	    	    cvar.viewmodel_offset_x:float(-2, true)
	    	    cvar.viewmodel_offset_y:float(-0.5, true)
	    	    cvar.viewmodel_offset_z:float(-5, true)
            end
        else
            cvar.viewmodel_fov:int(68)
            cvar.viewmodel_offset_x:float(2.5)
            cvar.viewmodel_offset_y:float(0)
            cvar.viewmodel_offset_z:float(-1.5)
        end
    end

    local aspectratio = function()
        cvar.r_aspectratio:float(visuals.aspectratio:get() / 100)
    end

    local watermark = function()
        text = ui.get_icon("snowflake").."  FROST REBORN  "..ui.get_icon("snowflake")

        if not visuals.watermark.settings:get("Arrows") then
            text = "          -> " .. text .. " <-"
        else
            text = "          "..text
        end
        if not visuals.watermark.settings:get("Animation") then
            MTools.Animation:Register("MTools");
            MTools.Animation:Update("MTools", 6);
            local Color = MTools.Animation:Lerp("MTools", "Color", (globals.tickcount % 100 >= 50), color(255, 255, 255, 255), color(0, 0, 0, 0));
            render.text(2, vector(render.screen_size().x/2, render.screen_size().y/2* 1.99), visuals.watermark.text_color:get(), "c", "\a"..Color:to_hex()..text)
        else
            render.text(2, vector(render.screen_size().x/2, render.screen_size().y/2* 1.99 ), visuals.watermark.text_color:get(), "c", text)
        end
    end

    damageindic = drag_system.register({mindmg_x, mindmg_y}, vector(20, 20), "Damage Idication", function(self)
        if not entity.get_local_player() then return end
        if not entity.get_local_player():is_alive() then return end
        if not visuals.min_dmg_indication:get() then return end
        local dmg = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get()
        local dmged = tostring(dmg)

        if dmg > 100 then
            dmged = "+"..MTools.String.Cut(tostring(dmg), 2)

        end
        if dmg > 110 then
            dmged = "+"..MTools.String.Cut(tostring(dmg), 1)
        end
        if dmg == 0 then
            dmged = "Auto"
        end
        

        render.text(visuals.min_dmg_indication.font:get(), vector(self.position.x + 11, self.position.y + 10), color(), "cbd", dmged)
        render.rect_outline(vector(self.position.x - 3, self.position.y), vector(self.position.x + self.size.x + 3, self.position.y + self.size.y), color(255, 255, 255, 100*ui.get_alpha()), 1, 3)
    end)

    local x, y, alphabinds, alpha_k, width_k, width_ka, data_k, width_spec = render.screen_size().x, render.screen_size().y, 0, 1, 0, 0, { [''] = {alpha_k = 0}}, 1
    widgets.lerpx = function(time,a,b) return a * (1-time) + b * time end
    widgets.pos_x = _ui.menulist.right_upper:slider("posx", 0, x, 150):visibility(false)
    widgets.pos_y = _ui.menulist.right_upper:slider("posy", 0, y, 150):visibility(false)
    widgets.pos_x1 = _ui.menulist.right_upper:slider("posx1", 0, x, 250):visibility(false)
    widgets.pos_y1 = _ui.menulist.right_upper:slider("posy1", 0, y, 250):visibility(false)

    widgets.window = function(x, y, w, h, name, alpha)
        -- widgets.pos_x:visibility(true)
        -- widgets.pos_y:visibility(true)
        -- widgets.pos_x1:visibility(true)
        -- widgets.pos_y1:visibility(true) 
    	local name_size = render.measure_text(1, "", name) 
    	local r, g, b = visuals.widgets.accent_col:get().r, visuals.widgets.accent_col:get().g, visuals.widgets.accent_col:get().b
        local r2, g2, b2 = visuals.widgets.accent_col:get().r, visuals.widgets.accent_col:get().g, visuals.widgets.accent_col:get().b

        if visuals.widgets.solus_combo:get() == 'Half-rounded' then
            render.rect_outline(vector(x - 1, y), vector(x + w + 4, y + h + 1), color(r, g, b, alpha/5), 1, 4)
            render.rect(vector(x + 3, y), vector(x + w, y + 1), color(r2, g2, b2, alpha), 4)
            render.rect(vector(x, y + 1), vector(x + w + 3, y + 16), color(0, 0, 0, alpha/4), 4)
            render.circle_outline(vector(x + 3, y + 4), color(r2, g2, b2, alpha), 4.5, 175, 0.33, 1)
            render.circle_outline(vector(x + w, y + 4), color(r2, g2, b2, alpha), 4.5, 260, 0.30, 1)
            render.gradient(vector(x - 1, y + 2), vector(x, y + h - 4), color(r2, g2, b2, alpha), color(r2, g2, b2, 0), color(r2, g2, b2, alpha/2), color(r2, g2, b2, 0))
            render.gradient(vector(x + w + 3, y + 2), vector(x + w + 4, y + h - 4), color(r2, g2, b2, alpha), color(r2, g2, b2, 0), color(r2, g2, b2, alpha/2), color(r2, g2, b2, 0))
            render.text(1, vector(x+1 + w / 2 + 1 - name_size.x / 2,	y + h / 2 -  name_size.y/2), color(255, 255, 255, alpha), "", name)
        elseif visuals.widgets.solus_combo:get() == 'Selfo'  then
            --render.rect(vector(x, y), vector(x + w + 3, y + 2), color(r2, g2, b2, alpha), 4)
            render.rect(vector(x, y + 1), vector(x + w + 2, y + 22), color(0, 0, 0, alpha/4), 0)
            render.line(vector(x + w + 2, y), vector(x + w + 2, y + 22), color(r2, g2, b2, alpha))
            render.line(vector(x, y + 1), vector(x, y + 22), color(r2, g2, b2, alpha))
            render.shadow(vector(x, y + 1), vector(x, y + 22), color(r2, g2, b2, alpha), 10)
            render.shadow(vector(x + w + 2, y), vector(x + w + 2, y + 22), color(r2, g2, b2, alpha), 10)
            render.shadow(vector(x, y + 1), vector(x + w + 2, y + 22), color(r2, g2, b2, alpha), 10)
            render.text(1, vector(x+1 + w / 2 + 1 - name_size.x / 2,	y + 2 + h / 2 -  name_size.y/2), color(255, 255, 255, alpha), "", name)
        end
    end

    widgets.watermark = function()

        if visuals.widgets.solus_widgets:get('Watermark') then
            local ticks = math.floor(1.0 / globals.tickinterval)
            local user_name = common.get_username()
        
            function get_ping()
                local netchannel = utils.net_channel()
            
                if netchannel == nil then
                    return 0
                end
            
                return math.floor(netchannel.latency[1] * 1000)
            end
            
            local actual_time = ""
            local latency_text = ""
            local nexttext = ""
        
            actual_time = common.get_date("%H:%M")
        
            if not globals.is_in_game then
                latency_text = ''
            else
                latency_text = ' | '..get_ping().."ms"
            end
        
            solushex = color(visuals.widgets.accent_col:get().r, visuals.widgets.accent_col:get().g, visuals.widgets.accent_col:get().b, 255):to_hex()
            if visuals.widgets.solus_combo2:get() == "Neverlose" then
                local nexttext = ('never\a'..solushex..'lose \aFFFFFFFF| '..common.get_username()..latency_text.." | "..actual_time)
                local text_size = render.measure_text(1, "", nexttext).x
                widgets.window(x - text_size-19, 10, text_size + 4, 16, nexttext, 255)
            end
            if visuals.widgets.solus_combo2:get() == "Gamesense" then
                local nexttext = ('game\a'..solushex..'sense \aFFFFFFFF| '..common.get_username()..latency_text.." | "..actual_time)
                local text_size = render.measure_text(1, "", nexttext).x
                widgets.window(x - text_size-19, 10, text_size + 4, 16, nexttext, 255)
            end
        end
    end

    widgets.keybinds = drag_system.register({widgets.pos_x, widgets.pos_y}, vector(120, 60), "Keybinds", function(self)
        if visuals.widgets.solus_widgets:get('Keybinds') then
            local max_width = 0
            local frametime = globals.frametime * 16
            local add_y = 0
            local total_width = 66
            local active_binds = {}
            
            local binds = ui.get_binds()
            for i = 1, #binds do
                    local bind = binds[i]
                    local get_mode = binds[i].mode == 1 and 'holding' or (binds[i].mode == 2 and 'toggled') or '[?]'
                    local get_value = binds[i].value
            
                    local c_name = binds[i].name
                    if c_name == 'Peek Assist' then c_name = 'Quick peek assist' end
                    if c_name == 'Edge Jump' then c_name = 'Jump at edge' end
                    if c_name == 'Hide Shots' then c_name = 'On shot anti-aim' end
                    if c_name == 'Minimum Damage' then c_name = 'Minimum damage' end
                    if c_name == 'Fake Latency' then c_name = 'Ping spike' end
                    if c_name == 'Fake Duck' then c_name = 'Duck peek assist' end
                    if c_name == 'Safe Points' then c_name = 'Safe point' end
                    if c_name == 'Body Aim' then c_name = 'Body aim' end
                    if c_name == 'Double Tap' then c_name = 'Double tap' end
                    if c_name == 'Yaw Base' then c_name = 'Manual override' end
                    if c_name == 'Slow Walk' then c_name = 'Slow motion' end
            
            
                    local bind_state_size = render.measure_text(1, "", get_mode)
                    local bind_name_size = render.measure_text(1, "", c_name)
                    if data_k[bind.name] == nil then data_k[bind.name] = {alpha_k = 0} end
                    data_k[bind.name].alpha_k = widgets.lerpx(frametime, data_k[bind.name].alpha_k, (bind.active and 255 or 0))
            
                    if visuals.widgets.solus_combo:get() == 'Half-rounded' then
                        render.text(1, vector(self.position.x+3, self.position.y + 19 + add_y), color(255, data_k[bind.name].alpha_k), '', c_name)
                    
                        if c_name == 'Minimum damage' or c_name == 'Ping spike' then
                            render.text(1, vector(self.position.x + (width_ka - bind_state_size.x) - render.measure_text(1, nil, get_value).x + 28, self.position.y + 19 + add_y), color(255, data_k[bind.name].alpha_k), '',  '['..get_value..']')
                        else
                            render.text(1, vector(self.position.x + (width_ka - bind_state_size.x - 8), self.position.y + 19 + add_y), color(255, data_k[bind.name].alpha_k), '',  '['..get_mode..']')
                        end
                    else
                        render.text(1, vector(self.position.x+3, self.position.y + 22 + add_y), color(255, data_k[bind.name].alpha_k), '', c_name)
                    
                        if c_name == 'Minimum damage' or c_name == 'Ping spike' then
                            render.text(1, vector(self.position.x + (width_ka - bind_state_size.x) - render.measure_text(1, nil, get_value).x + 28, self.position.y + 22 + add_y), color(255, data_k[bind.name].alpha_k), '',  '['..get_value..']')
                        else
                            render.text(1, vector(self.position.x + (width_ka - bind_state_size.x - 8), self.position.y + 22 + add_y), color(255, data_k[bind.name].alpha_k), '',  '['..get_mode..']')
                        end
                    end

                    add_y = add_y + 16 * data_k[bind.name].alpha_k/255
                
                    --drag
                    local width_k = bind_state_size.x + bind_name_size.x + 18
                    if width_k > 130-11 then
                        if width_k > max_width then
                            max_width = width_k
                        end
                    end
                
                    if binds.active then
                            table.insert(active_binds, binds)
                        end
                    end
                
                    alpha_k = widgets.lerpx(frametime, alpha_k, (ui.get_alpha() > 0 or add_y > 0) and 1 or 0)
                    width_ka = widgets.lerpx(frametime,width_ka, math.max(max_width, 130-11))
                    if ui.get_alpha()>0 or add_y > 6 then alphabinds = widgets.lerpx(frametime, alphabinds, math.max(ui.get_alpha()*255, (add_y > 1 and 255 or 0)))
                    elseif add_y < 15.99 and ui.get_alpha() == 0 then alphabinds = widgets.lerpx(frametime, alphabinds, 0) end
                    if ui.get_alpha() or #active_binds > 0 then
                        widgets.window(self.position.x, self.position.y, width_ka, 16, 'keybinds', alphabinds)
                    end
            end
    end)

    widgets.spectator = drag_system.register({widgets.pos_x1, widgets.pos_y1}, vector(120, 60), "Spect", function(self)
            if visuals.widgets.solus_widgets:get('Spectator list') then
            local width_spec = 120
            if width_spec > 160-11 then
                if width_spec > max_width then
                    max_width = width_spec
                end
            end
        
                if ui.get_alpha() > 0.3 or (ui.get_alpha() > 0.3 and not globals.is_in_game) then widgets.window(self.position.x, self.position.y, width_spec, 16, 'spectators', 255) end
        
                local me = entity.get_local_player()
                if me == nil then return end
        
                local speclist = me:get_spectators()
        
                if me.m_hObserverTarget and (me.m_iObserverMode == 4 or me.m_iObserverMode == 5) then
                    me = me.m_hObserverTarget
                end
        
                local speclist = me:get_spectators()
                if speclist == nil then return end
                for idx,player_ptr in pairs(speclist) do
                    local name = player_ptr:get_name()
                    local tx = render.measure_text(1, '', name).x
                    name_sub = string.len(name) > 30 and string.sub(name, 0, 30) .. "..." or name;
                    local avatar = player_ptr:get_steam_avatar()
                    if (avatar == nil or avatar.width <= 5) then avatar = fnay end
        
                    if player_ptr:is_bot() and not player_ptr:is_player() then goto skip end
                    render.text(1, vector(self.position.x + 17, self.position.y + 5 + (idx*15)), color(), 'u', name_sub)
                    render.texture(avatar, vector(self.position.x + 1, self.position.y + 5 + (idx*15)), vector(12, 12), color(), 'f', 0)
                    ::skip::
                end
        
            
                if #me:get_spectators() > 0 or (me.m_iObserverMode == 4 or me.m_iObserverMode == 5) then
                    widgets.window(self.position.x, self.position.y, width_spec, 16, 'spectators', 255)
                end
                
                end
        end)


    events.override_view:set(smooth_camera_animations)

    events.mouse_input:set(function()
        if ui.get_alpha() > 0 then
            return false
        end
    end)

    local grenade_warning do

        visuals.grenade_warning = {}
        visuals.grenade_warning.enable = _ui.menulist.left_lower:switch("\v\f<bomb>\a[white]   Grenade Warning", false, function(gear, item)
            return {
                colored = gear:color_picker("\n"):depend(item)
            }
        end):depend({tab_selector, 3})
        local GetCreationTime = utils.get_netvar_offset("DT_BaseCSGrenadeProjectile", "m_nExplodeEffectTickBegin") + 0x10
    
        local function get_creation_time(entity)
            return ffi.cast("float*", ffi.cast("uint32_t", entity[0]) + GetCreationTime)[0]
        end
    
        local function get_remaining_percent(e)
            local is_projectile = e.entity["m_nExplodeEffectTickBegin"] ~= nil
    
            local remaining_time = e.expire_time - globals.curtime
    
            local expire_time = not is_projectile and 7.0
                or e.expire_time - get_creation_time(e.entity)
    
            return remaining_time / expire_time
        end
    
        local function get_screen_position(e, radius)
            local pos = render.get_offscreen(e.origin, 0.9, true)
            local screen_size = render.screen_size()
    
            pos.y = pos.y - 22
    
            pos.x = math.clamp(pos.x, radius, screen_size.x - radius)
            pos.y = math.clamp(pos.y, radius, screen_size.y - radius)
    
            return pos
        end
    
        local function get_warning_text(e, distance)
            if e.type == "Molly" then
                return math.ceil(distance * 0.0798).."ft"
            end
    
            return e.damage.."dmg"
        end
    
        local function get_danger_volume(e, distance)
            if e.type == "Molly" then
                return math.map(distance, 100, 150, 1.0, 0.0, true)
            end
    
            return math.map(e.damage, 5, 35, 0.0, 1.0, true)
        end
    
        local function get_duration(e)
            return math.ceil(e.expire_time * 0.0798)
        end
    
        local function draw_grenade_warning(e, origin)
            local position = get_screen_position(e, 22)
    
            if position == nil then
                return false
            end
    
            local distance = origin:dist(e.closest_point)
            local danger_volume = get_danger_volume(e, distance)
    
            local safety_color = color(255, 255, 255, 200)
            local danger_color = color(200, 40, 60, 255)
            local outlinecolor = visuals.grenade_warning.enable.colored:get()
    
            local pos_a = position - 22
            local pos_b = position + 22
    
            local alpha = 1.0
            local style = ui.get_style()
            local icon_color = outlinecolor:lerp(danger_color, danger_volume)
    
            --container.draw(pos_a, pos_b, style, alpha)
            --render.circle(position, color(0, 0, 0, 200), 27, 90, 1)
            --render.circle_outline(position, outlinecolor, 27, 90, 1, 1.5)
    
            render.rect(vector(position.x - 25, position.y - 25), vector(position.x + 25, position.y + 25), color(0, 0, 0, 200), 5)
            --render.gradient(vector(position.x - 25, position.y - 25), vector(position.x + 25, position.y + 25), color(0, 0, 0, 0), color(0, 0, 0, 0), color(255, 255, 255, 255), color(255, 255, 255, 255), 5)
            render.rect(vector(position.x - 25, position.y + 22), vector(position.x + 25, position.y + 25), outlinecolor, 2)
            --render.rect_outline(vector(position.x - 25, position.y - 25), vector(position.x + 25, position.y + 25), style["Link"], 1.5, 2)
            --render.rect(vector(position.x - 25, position.y + 25), vector(position.x + 11, position.y - 2115), color(0, 0, 0, 200), 5)
    
            local icon = e.icon do
                local percent = get_remaining_percent(e)
    
                local icon_size = vector(icon.width, icon.height) * 1
                local icon_pos = position - icon_size * 0.5 - vector(0, 7)
    
                icon_pos.y = icon_pos.y - 1
                icon_pos = icon_pos:floor()
    
                --print_dev(get_duration(e))
    
                render.texture(e.icon, icon_pos, icon_size, icon_color)
    
                local clip_a = vector(icon_pos.x + 12, icon_pos.y + icon_size.y * (1.0 - percent) + 12)
                local clip_b = vector(icon_pos.x + icon_size.x + 12, icon_pos.y + icon_size.y + 12)
    
                --render.push_clip_rect(clip_a, clip_b)
                --render.texture(e.icon, icon_pos, icon_size, icon_color)
    
                --render.pop_clip_rect()
            end
    
            local text = get_warning_text(e, distance) do
                local text_font = 1
                local text_flags = "d"
    
                local text_size = render.measure_text(text_font, text_flags, text)
                local text_pos = position + vector(-text_size.x * 0.5, 4):floor()
    
                local text_color = safety_color--:lerp(danger_color, danger_volume)
    
                render.text(text_font, text_pos, text_color, text_flags, text)
            end
        end
    
        local function on_grenade_warning(e)
            local me = entity.get_local_player()
    
            if me == nil then
                return false
            end
    
            local origin = me:get_origin()
            draw_grenade_warning(e, origin)
    
            return false
        end
    
        local function update_event_callbacks(value)
            events.grenade_warning(on_grenade_warning, value)
        end
    
        visuals.grenade_warning.enable:set_callback(function(item)
            update_event_callbacks(item:get())
        end)
    end
    
    local hit_marker do
        visuals.hitmarker = {
            fade_time = 0.5,
            wait_time = 1.0,
            shots = {}
        }
    
        crossmarker = {
            wait_time = 0.0
        }
    
        visuals.hitmarker.enable = _ui.menulist.right_upper:switch("\v\f<marker>\a[white]   Hitmarker", false, function(gear, item)
            return {
                hittype = gear:selectable("Style", {"GS", "Plus", "Snowflake"}):depend(item),
            }
        end):depend({tab_selector, 3})
        visuals.hitmarker.stpp = visuals.hitmarker.enable:create()
        visuals.hitmarker.gscolor = visuals.hitmarker.stpp:color_picker("Gamesense Color"):depend({visuals.hitmarker.enable.hittype, "GS"}, visuals.hitmarker.enable)
        visuals.hitmarker.pluscolor = visuals.hitmarker.stpp:color_picker("Plus Color"):depend({visuals.hitmarker.enable.hittype, "Plus"}, visuals.hitmarker.enable)
        visuals.hitmarker.snowflakecolor = visuals.hitmarker.stpp:color_picker("Snowflake Color"):depend({visuals.hitmarker.enable.hittype, "Snowflake"}, visuals.hitmarker.enable)
    
        visuals.hitmarker_paint_plus = function()
            if not visuals.hitmarker.enable:get() then return end
            for i, Shot in pairs(visuals.hitmarker.shots) do
                if Shot.FadeTime <= 0 then
                    visuals.hitmarker.shots[i] = nil
                else
                    Shot.WaitTime = Shot.WaitTime - globals.frametime
                    if Shot.WaitTime <= 0 then
                        Shot.FadeTime  = Shot.FadeTime - ((1 / visuals.hitmarker.fade_time) * globals.frametime)
                    end
        
                    if Shot.Position.x ~= nil and Shot.Position.y ~= nil and Shot.Position.z ~= nil then
                        local pos = render.world_to_screen(vector(Shot.Position.x, Shot.Position.y, Shot.Position.z))
                        if pos ~= nil then
                            local x, y = pos.x, pos.y
                            local ss = render.screen_size() 
                            local r, g, b, a = visuals.hitmarker.pluscolor:get():unpack()
                            if visuals.hitmarker.enable.hittype:get("Plus") then
                                render.rect(vector(x - (1/ss.x) * ss.x, y - (5/ss.y) * ss.y), vector(x + (1/ss.x) * ss.x, y + (5/ss.y) * ss.y), color(r, g, b, a * Shot.FadeTime), 0, true)
                                render.rect(vector(x - (5/ss.x) * ss.x, y - (1/ss.y) * ss.y), vector(x + (5/ss.x) * ss.x, y + (1/ss.y) * ss.y), color(r, g, b, a * Shot.FadeTime), 0, true)
                            end
                            if visuals.hitmarker.enable.hittype:get("Snowflake") then
                                render.text(1, pos, visuals.hitmarker.snowflakecolor:get(), "c", ui.get_icon("snowflake"))
                            end
                        end
                    end
                end
            end
        end
    
        visuals.hitmarker_paint_gs = function()
            if not visuals.hitmarker.enable:get() then return end
            if not visuals.hitmarker.enable.hittype:get("GS") then return end
            if not globals.is_in_game or crossmarker.wait_time <= 0 then
                return
            end
    
            local alpha = 1.0
    
            if crossmarker.wait_time < 0.25 then
                alpha = crossmarker.wait_time / 0.25
            end
    
            local col = visuals.hitmarker.gscolor:get()
            col.a = col.a * alpha
    
            local center = render.screen_size() * 0.5
    
            render.line(vector(center.x - 10, center.y - 10), vector(center.x - 5, center.y - 5), col)
            render.line(vector(center.x + 10, center.y - 10), vector(center.x + 5, center.y - 5), col)
            render.line(vector(center.x + 10, center.y + 10), vector(center.x + 5, center.y + 5), col)
            render.line(vector(center.x - 10, center.y + 10), vector(center.x - 5, center.y + 5), col)
    
            crossmarker.wait_time = math.max(crossmarker.wait_time - globals.frametime, 0.0)
    
        end
    
        gs_on_player_hurt = function(e)
            local me = entity.get_local_player()
    
            local userid = entity.get(e.userid, true)
            local attacker = entity.get(e.attacker, true)
    
            if userid == me or attacker ~= me then
                return
            end
    
            crossmarker.wait_time = 0.5
        end
        
        plus_on_aim_ack = function(Shot)
            visuals.hitmarker.shots[Shot.id] = {
                Position = Shot.aim,
                WaitTime = visuals.hitmarker.wait_time,
                FadeTime = 1,
                Reason = Shot.state,
            }
        end
    
        events.render:set(visuals.hitmarker_paint_plus)
        events.render:set(visuals.hitmarker_paint_gs)
    
        events.aim_ack:set(plus_on_aim_ack)
        events.player_hurt:set(gs_on_player_hurt)
        
        events.round_start:set(function()
            visuals.hitmarker.shots = {}
        end)
        
        events.player_spawned:set(function(e)
            visuals.hitmarker.shots = {}
        end)
    end
    
    local scope_overlay do
        visuals.scope_overlay  = {}
        visuals.scope_overlay.enable = _ui.menulist.right_upper:switch("\v\f<crosshairs>\a[white]   Scope Overlay", false, function(gear, item)
            return {
                scope_style = gear:combo('select style', {'default', 'reversed'}):depend(item),
                remove_line = gear:selectable('exclude line', {'left', 'right', 'up', 'down'}):depend(item),
                scope_gap = gear:slider("scope gap", 0, 500, 7):depend(item),
                scope_size = gear:slider("scope size", 0, 1000, 105):depend(item),
                scope_color = gear:color_picker("scope color", color(255, 255, 255)):depend(item),
                xstyle = gear:switch("x styled"):depend(item)
            }
            end):depend({tab_selector, 3})
        
        local RESOLUTION = 1 / render.screen_size().y
    
        local smoothy_alpha = smoothy.new(0.0)
    
        local function on_render()
            if not visuals.scope_overlay.enable:get() then return end
            local me = entity.get_local_player()
    
            if me == nil or not me:is_alive() then
                return
            end
    
            local is_scoped = me.m_bIsScoped
    
            local position = visuals.scope_overlay.enable.scope_size:get()
            local offset = visuals.scope_overlay.enable.scope_gap:get()
        
            local scope_color = visuals.scope_overlay.enable.scope_color:get()
        
            local excluded_left = visuals.scope_overlay.enable.remove_line:get("left")
            local excluded_right = visuals.scope_overlay.enable.remove_line:get("right")
            local excluded_top = visuals.scope_overlay.enable.remove_line:get("up")
            local excluded_bottom = visuals.scope_overlay.enable.remove_line:get("down")
        
    
            local alpha = smoothy_alpha(0.05, is_scoped)
    
            if alpha == 0.0 then
                return
            end
    
            local screen = render.screen_size()
            local center = screen * 0.5
    
            local offset = offset * screen.y * RESOLUTION
            local position = position * screen.y * RESOLUTION
    
            offset = math.floor(offset)
            position = math.floor(position)
    
            local delta = position - offset
    
            local color_a = scope_color:clone()
            local color_b = scope_color:clone()
    
            if visuals.scope_overlay.enable.scope_style:get() == "reversed" then
                color_b.a = color_a.a * alpha
                color_a.a = 0
            end
    
            if visuals.scope_overlay.enable.scope_style:get() == "default" then
                color_a.a = color_a.a * alpha
                color_b.a = 0
            end
    
            if visuals.scope_overlay.enable.xstyle:get() then
                render.push_rotation(-45)
            end
    
            if not excluded_top then
                local pos_a = vector(center.x, center.y - offset + 1)
                local pos_b = vector(pos_a.x + 1, center.y - position)
    
                render.gradient(pos_a, pos_b, color_a, color_a, color_b, color_b)
            end
    
            if not excluded_bottom then
                local pos_a = vector(center.x, center.y + offset)
                local pos_b = vector(pos_a.x + 1, center.y + position)
    
                render.gradient(pos_a, pos_b, color_a, color_a, color_b, color_b)
            end
    
            if not excluded_left then
                local pos_a = vector(center.x - offset + 1, center.y)
                local pos_b = vector(pos_a.x - delta, center.y + 1)
    
                render.gradient(pos_a, pos_b, color_a, color_b, color_a, color_b)
            end
    
            if not excluded_right then
                local pos_a = vector(center.x + offset, center.y)
                local pos_b = vector(pos_a.x + delta, center.y + 1)
    
                render.gradient(pos_a, pos_b, color_a, color_b, color_a, color_b)
            end
    
            if visuals.scope_overlay.enable.xstyle:get() then
                render.pop_rotation()
            end
        end
    
        events.render:set(on_render)
    end

    local crosshair_indic do
        visuals.crosshair  = {}

        visuals.crosshair.enable = _ui.menulist.right_upper:switch("\v\f<terminal>\a[white]   Indicators"):depend({tab_selector, 3})

        local onrender = function()
            if not visuals.crosshair.enable:get() then return end
            local self = entity.get_local_player()
            if not self or not self:is_alive() then
                return
            end

            local offset = 10
            
            local dmg = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get_override()
            local centerx, centery = render.screen_size().x / 2, render.screen_size().y / 2 + 25
            local textmssr = render.measure_text(2, "c", "FROST REBORN")

            local gradient_txt = gradient.text_animate("FROST REBORN", -1.5, {ui.get_style("Link Active"), color(25, 25, 25, 255)})
            gradient_txt:animate()

            local centerx_stable = animations.new("First scope x-value", centerx):update(animations.types.IN_OUT_CIRC, self.m_bIsScoped and centerx + 30 or centerx)

            local centerx_line = animations.new("centerx_line", centerx):update(animations.types.IN_OUT_CIRC, self.m_bIsScoped and centerx + 65 or centerx)
            local centerx_plusline = animations.new("centerx_plusline", (centerx + textmssr.x - 5)):update(animations.types.IN_OUT_CIRC, self.m_bIsScoped and (centerx + textmssr.x - 35) or (centerx + textmssr.x - 5))

            local centerx_minusline = animations.new("centerx_minusline", (centerx - textmssr.x - 5)):update(animations.types.IN_OUT_CIRC, self.m_bIsScoped and (centerx - textmssr.x + 35) or (centerx - textmssr.x + 5))
            local centerx_line2 = animations.new("centerx_line2", centerx):update(animations.types.IN_OUT_CIRC, self.m_bIsScoped and centerx + 65 or centerx)
            render.text(2, vector(centerx_stable, centery), color(255), "c", gradient_txt:get_animated_text())
            render.text(2, vector(centerx_stable, centery + offset), color(255), "c", reference.antiaim.uppercond[force_defensive_extention()])
            offset = offset + 10

            local active_binds = ui.get_binds()
	        for i in pairs(active_binds) do
	        	if active_binds[i].name == "Min. Damage" then
                    --local dmgcolor = color(69, 69, 69, 255)
                    --    :lerp(color(204, 115, 103), active_binds[i].active)
	        		if active_binds[i].active then
                        render.text(2, vector(centerx_stable, centery + offset), color(), "c", "DMG")
                        offset = offset + 10
	        		end
	        	end
                if active_binds[i].name == "Hide Shots" then
                    --local dmgcolor = color(69, 69, 69, 255)
                    --    :lerp(color(204, 115, 103), active_binds[i].active)
	        		if active_binds[i].active then
                        render.text(2, vector(centerx_stable, centery + offset), color(), "c", "OSAA")
                        offset = offset + 10
	        		end
	        	end
                if active_binds[i].name == "Double Tap" then
                    --local dmgcolor = color(69, 69, 69, 255)
                    --    :lerp(color(204, 115, 103), active_binds[i].active)
	        		if active_binds[i].active then
                        render.text(2, vector(centerx_stable, centery + offset), color(), "c", "DT")
                        offset = offset + 10
	        		end
	        	end
	        end
        end

        events.render:set(onrender)
    end

    events.render:set(function() 
        watermark()
        aspectratio()
        viewmodel()
        damageindic:update()
        widgets.watermark()
        widgets.keybinds:update()
        widgets.spectator:update()
        sbtext = gradient.text_animate("FROST RECODE", -1.5, {ui.get_style("Link Active"), color(25, 25, 25, 255)})
    sbtext:animate()
    pui.sidebar(sbtext:get_animated_text(), "snowflake")
    end)
end

local misc do
    misc = {}
    local aipeek do
        misc.aipeekbot = {}
        misc.aipeekbot.peekbot = _ui.menulist.right_upper:label("\v\f<airbnb>\a[white]   Ai Peek Bot", function(gear)
            return {
                bindbutton = gear:switch("[AI] Peek Bot", false, "\a[yellow]\f<triangle-exclamation>\a[white]  This function need good pc, please not use if you have bad pc, its maybe down your fps to so lower values"),
                dot_offset = gear:slider('[AI] Start', 0, 20, 8 ),
                dot_span = gear:slider('[AI] Span', 0, 35, 5 ),
                dot_amount = gear:slider('[AI] Count', 0, 10, 3 ),
                gear:label("\a[yellow]\f<triangle-exclamation>\a[white]  May be buggy, normaly working only for scout, in newest update will be fixed")
            }
        end, "\a[yellow]\f<triangle-exclamation>\a[white]  This function need good pc, please not use if you have bad pc, its maybe down your fps to so lower values"):depend({tab_selector, 4})
    
        local target_enemy_lagcomp = { }
        local function createEnemyRecord( player )
            local data = { }
        
            data.player = player
        
            data.last_simtime = 0
            data.origin = player:get_origin( )
        
            data.breaking_lc = false
            data.defensive_active_until = 0
            data.defensive = false
        
            function data.update( )
                local simtime = to_ticks( player.m_flSimulationTime )
                local origin = player:get_origin( )
        
                local delta = simtime - data.last_simtime
        
                if delta < 0 then
                    data.defensive_active_until = globals.tickcount + math.abs( delta )
                else
                    data.breaking_lc = ( data.origin - origin ):length2dsqr( ) > 4096
        
                    data.origin = origin
                end
        
                data.last_simtime = simtime
        
                data.defensive = data.defensive_active_until > globals.tickcount
            end
        
            target_enemy_lagcomp[ player ] = data
        
            return data
        end
        
        -- god forbid this hardcode shit please dont send me into hell 🙏🙏🙏🙏
        local tickToDist = {
            0,
            0.33566926072059,
            0.90550823109139,
            1.7094571925458,
            2.7475758645732,
            4.0198045277169,
            5.5243356897069,
            7.2423273783409,
            9.1564213090631,
            11.250673856852,
            13.510480438002,
            15.922361837797,
            18.473989413581,
            21.153990043142,
            23.951936812474,
            26.858254779359,
            29.864120158319,
            32.961441695549,
            36.142785057665,
            39.401338315411,
            42.730817707458,
            46.125502156263,
            49.580063421207,
            53.08964170921,
            56.649735547569,
            60.256252190999,
            63.905432011078,
            67.59383918326,
            71.318242246617,
            75.075708340563,
            78.863628408227,
            82.67942790961,
            86.520915828495,
            90.385926351936,
            94.272651987509,
            98.17890171902,
            102.08515145053,
            105.99140118205,
            109.89765091356,
            113.80390064508,
            117.7101503766,
            121.61640010812,
            125.52264983965,
            129.42889957117,
            133.3351493027,
            137.24139903422,
            141.14764876575,
            145.05389849727,
            148.9601482288,
            152.86639796033,
            156.77264769186,
            160.67889742339,
            164.58514715492,
            168.49139688645,
            172.39764661798,
            176.30389634951,
            180.21014608104,
            184.11639581258,
            188.02264554411,
            191.92889527564,
            195.83514500718,
            199.74139473871,
            203.64764447024,
            207.55389420178,
        }
        
        -- local function canHitInTick( player, start_pos, wanted_pos, ticks )
            -- local sim_ctx = player:simulate_movement( )
            -- sim_ctx:think( ticks )
        
            -- local wanted_distance = ( wanted_pos - player:get_origin( ) ):length2d( )
            -- local predicted_distance = ( sim_ctx.origin - player:get_origin( ) ):length2d( )
        
            -- return predicted_distance >= wanted_distance
        -- end
        
        local function canHitInTick( wanted_pos_distance, max_speed, ticks )
            local distance_mult = max_speed / 250
            local wanted_distance = wanted_pos_distance * distance_mult
        
            local max_distance = tickToDist[ ticks ] * distance_mult
        
            return wanted_distance <= max_distance
        end
        
        
        local _dbg_visuals = { }
        local visuals = {
            peeking_points = { },
            found_point = nil,
        }
        local function visualize_debugged_data( positions, tgt )
            if type( positions ) ~= 'table' then
                positions = { positions }
            end
        
            _dbg_visuals[ tgt:get_name( ) ] = positions
        end
        
        local function visual_peekpopint_set( points )
            visuals.peeking_points = points
        end
        
        local enemy_hitboxes = {
            [ 'head' ] = 1,
            [ 'stomach' ] = 2,
            [ 'chest' ] = 3,
            [ 'limbs' ] = 4
        }
        
        local hitboxes = {
            { 0 },
            { 2, 3, 4 },
            { 5, 6 },
            {
                13, 14, 15, 16, 17, 18, -- arms
                7, 8, 9, 10, -- legs
                11, 1, -- feet
            },
        }
        
        local cache = {
            autopeek_position = vector( 0, 0, 0 ),
            last_seen = 0,
            found_position = vector( 0, 0, 0 ),
            found_position_dist = 1,
        }
        
        local closest_enemy = nil
        
        local function reset_cache( )
            cache.last_seen = 0
            cache.found_position = vector( 0, 0, 0 )
        end 
        
        local function getEnmyAsClosed( )
            local screen_center = render.screen_size( ) / 2
           
            local smallest_distance = math.huge
            local closest_enemy_found = nil
        
            local enemies = entity.get_players( true )
            for i = 1, #enemies do
                local enemy = enemies[ i ]
        
                if enemy == nil then
                    goto continue
                end
        
                --* only check for enemies that are alive and not dormant
                if not enemy:is_alive( ) or enemy:is_dormant( ) then
                    goto continue
                end
                
                local enemy_position = enemy:get_origin( )
                
                local enemy_screen = enemy_position:to_screen( )
                
                if enemy_screen == nil or enemy_screen.x == nil or enemy_screen.y == nil then
                    goto continue
                end
        
                local distance = ( enemy_screen - screen_center ):length( )
        
                if distance < smallest_distance then
                    smallest_distance = distance
                    closest_enemy_found = enemy
                end
        
                ::continue::
            end
        
            closest_enemy = closest_enemy_found
        end
        
        local function get_multipoint( ent, hitbox_center, scale )
            local target_pos = ent:get_origin( )
        
            local lp = entity.get_local_player( )
            local lp_pos = lp:get_origin( )
        
            local lp_to_tgt = target_pos - lp_pos
            local ang = lp_to_tgt:angles( )
            local new_yaw = ang.y
        
            local max_check_dist = 5
        
            local mp_poses = { }
        
            for side = -1, 1, 2 do
                local yaw = new_yaw + ( 90 * side )
                local yaw_rad = math.rad( yaw )
        
                local x = math.cos( yaw_rad )
                local y = math.sin( yaw_rad )
        
                local mp_start = hitbox_center + vector( x * max_check_dist, y * max_check_dist, 0 )
                local diff = hitbox_center - mp_start
        
                local trace = utils.trace_line( mp_start, hitbox_center, lp )
        
                local mp_pos = hitbox_center + ( diff * ( 1 - trace.fraction ) ) * scale
        
                table.insert( mp_poses, mp_pos )
            end
        
            return mp_poses
        end
        
        local function getHeadMP( ent, hitbox_center, scale )
            local lp = entity.get_local_player( )
            local side_mp = get_multipoint( ent, hitbox_center, scale )
        
            local max_check_dist = -5
            local mp_start = hitbox_center + vector( 0, 0, max_check_dist )
            local diff = hitbox_center - mp_start
        
            local trace = utils.trace_line( mp_start, hitbox_center, lp )
        
            local mp_pos = hitbox_center + ( diff * ( 1 - trace.fraction ) ) * scale
        
            table.insert( side_mp, mp_pos )
        
            return side_mp
        end
        
        local function playersPointGet( player )
            -- TODO: multipoint head, chest stomach
            -- TODO: add menu customization for multipoints and normal hitboxes
        
            local points = { }
            local points_names = { }
        
            local extra_calc = true
        
            local find = {
                head = true,
                chest = true,
                stomach = true,
                limbs = 3
            }
        
            local mp = {
                head = extra_calc,
                chest = extra_calc,
                stomach = extra_calc,
                limbs = false
            }
        
            local mp_scale = {
                head = 80 / 100,
                chest = 60 / 100,
                stomach = 65 / 100,
                limbs = 0
            }
        
            if find.head then
                local head_hitboxes = hitboxes[ enemy_hitboxes[ 'head' ] ]
        
                for i = 1, #head_hitboxes do
                    local head = player:get_hitbox_position( head_hitboxes[ i ] )
        
                    if not mp.head then
                        table.insert( points, head )
                        table.insert( points_names, 'head' )
                    else
                        local multipoints = getHeadMP( player, head, mp_scale.head )
        
                        for mp_idx = 1, #multipoints do
                            table.insert( points, multipoints[ mp_idx ] )
                            table.insert( points_names, 'head' )
                        end
                    end
                end
            end
        
            if find.chest then
                local chest_hitboxes = hitboxes[ enemy_hitboxes[ 'chest' ] ]
                for i = 1, #chest_hitboxes do
                    local chest = player:get_hitbox_position( chest_hitboxes[ i ] )
        
                    if not mp.chest then
                        table.insert( points, chest )
                        table.insert( points_names, 'chest' )
                    else
                        local multipoints = get_multipoint( player, chest, mp_scale.chest )
                        
                        for mp_idx = 1, #multipoints do
                            table.insert( points, multipoints[ mp_idx ] )
                            table.insert( points_names, 'chest' )
                        end
                    end
                end
            end
        
            if find.stomach then
                local stomach_hitboxes = hitboxes[ enemy_hitboxes[ 'stomach' ] ]
                for i = 1, #stomach_hitboxes do
                    local stomach = player:get_hitbox_position( stomach_hitboxes[ i ] )
                    
                    if not mp.stomach then
                        table.insert( points, stomach )
                        table.insert( points_names, 'stomach' )
                    else
                        local multipoints = get_multipoint( player, stomach, mp_scale.stomach )
        
                        for mp_idx = 1, #multipoints do
                            table.insert( points, multipoints[ mp_idx ] )
                            table.insert( points_names, 'stomach' )
                        end
                    end
                end
            end
        
            if find.limbs then
                local limbs_hitboxes = hitboxes[ enemy_hitboxes[ 'limbs' ] ]
                for i = 1, #limbs_hitboxes do
                    local limb = player:get_hitbox_position( limbs_hitboxes[ i ] )
                    table.insert( points, limb )
                    table.insert( points_names, 'limb' )
                end
            end
        
            return { points, points_names }
        end
        
        local function peekPoints_get( lp )
            local lp_origin = lp:get_origin( )
            local lp_eye = lp:get_eye_position( )
        
            local ang = render.camera_angles( )
            local yaw = ang.y
        
            local head_height = lp_eye.z - lp_origin.z
        
            -- we want 3 dots on boths sides of the player
            -- so:
            -- . . . p . . .
            -- p = player
            -- . = dot
            -- the dots are spaced out over a distance of 32 units
        
            local start_offset = misc.aipeekbot.peekbot.dot_offset:get( )
            local dots = misc.aipeekbot.peekbot.dot_amount:get( )
            local total_distance = misc.aipeekbot.peekbot.dot_span:get( )
            local gap = total_distance / dots
        
            local dot_positions = { }
        
            for i = -1, 1, 2 do
                local dot_yaw = yaw + ( 90 * i )
        
                -- convert yaw to forwardvector (vector with length 1)
                local forwardvector = vector( math.cos( math.rad( dot_yaw ) ), math.sin( math.rad( dot_yaw ) ), 0 )
        
                for dot_iter = 1, dots do
                    -- get dot position disregarding the ground
                    local dot_position = lp_eye + ( forwardvector * ( gap * dot_iter ) ) + ( forwardvector * start_offset )
        
                    -- find ground height from dot position
                    local trace_res = utils.trace_line( dot_position, dot_position + vector( 0, 0, -200 ), lp )
        
                    -- if we hit the ground, set the dot position to the ground position + head height	
                    local trace_fraction = trace_res.fraction
                    if trace_fraction < 1 then
                        local end_pos = trace_res.end_pos + vector( 0, 0, head_height )
        
                        -- if the dot is too high, break the loop
                        if ( end_pos.z - lp_origin.z ) > 40 then
                            dot_iter = dots
                        end
        
                        dot_position = end_pos
                    end
                    
                    -- trace from eye to dot position to check if we can see the dot
                    trace_res = utils.trace_line( lp_eye, dot_position, entity.get_players( ) )
                    if trace_res.fraction == 1 then
                        -- if we can see the dot, add it to the table
                        table.insert( dot_positions, dot_position )
                    else
                        -- set point pos to smallest dist from the wall
                        local last_dot_pos = lp_eye + ( ( forwardvector * ( gap * dot_iter ) ) + ( forwardvector * start_offset ) ) * trace_res.fraction - forwardvector * 19
                        last_dot_pos.z = dot_position.z
                        -- if we cant see the dot, break the loop
                        table.insert( dot_positions, last_dot_pos )
                        break
                    end
                end
            end
        
            return dot_positions
        end
        
        local function canHitEnmyPos( lp, position, target, target_hitpoints, announce )
            local minimum_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get( )
        
            local c_yes = color( 'FFABBC' ):to_hex( )
            local c_mismatch = color( 'ABB3FF' ):to_hex( )
        
            if minimum_damage > 100 then
                minimum_damage = target.m_iHealth + ( minimum_damage - 100 )
            end
        
            for j = 1, #target_hitpoints do
                local hitpoint = target_hitpoints[ 1 ][ j ]
                local simulated_dmg, trace = utils.trace_bullet( lp, position, hitpoint, lp )
                local hit_entity = trace.entity
                if hit_entity ~= nil then
                    local hit_player_name = hit_entity:get_name( )
                    local target_health = hit_entity.m_iHealth
                    local dmg_diff = simulated_dmg - minimum_damage
                    if dmg_diff > 0 then
                        dmg_diff = '\a00FF00FF+' .. dmg_diff
                    else
                        dmg_diff = '\aFF0000FF' .. dmg_diff
                    end
                    if hit_entity and hit_entity == target then
                        local wanted_dmg = minimum_damage
                        if minimum_damage > 100 then
                            wanted_dmg = target_health + ( minimum_damage - 100 )
                        end
                        if simulated_dmg >= target_health or simulated_dmg > wanted_dmg then
                            cache.found_position = position
                            cache.found_position_dist = ( cache.autopeek_position - cache.found_position ):length2d( )
                            if announce ~= nil then
                                print_raw( ( '\a%snl\a8a8a8aFF . \aa3a3a3FFpeeking \a%s%s \aa3a3a3FFfor \a%s%i \aa3a3a3FFin \a%s%s \aa3a3a3FF[%s\aa3a3a3FF]' ):format(
                                    c_mismatch, c_yes, hit_player_name, c_yes, simulated_dmg, c_yes, target_hitpoints[ 2 ][ j ], dmg_diff
                                ) )
                            end
                            return true, position, hit_entity
                        end
                    elseif hit_entity ~= nil and hit_entity:is_alive( ) then
                        local wanted_dmg = minimum_damage
                        if minimum_damage > 100 then
                            wanted_dmg = target_health + ( minimum_damage - 100 )
                        end
                        if simulated_dmg >= target_health or simulated_dmg > wanted_dmg then
                            cache.found_position = position
                            return true, position, hit_entity
                        end
                    end
                end
            end
        
            return false
        end
        
        local function canHitEnmyPosset( lp, positions, target, target_hitpoints )
        
            for i = 1, #positions do
                local position = positions[ i ]
                
                visuals.found_point = i
        
                local state, pos, ent = canHitEnmyPos( lp, position, target, target_hitpoints, true )
        
                if state then
                    return true, pos, ent
                end
            end
        
            visuals.found_point = nil
            return false, nil, nil
        end
        
        local function isShootReady( lp, cmd )
            local slowdown = lp.m_flVelocityModifier < 0.9
            local has_user_input = cmd.in_moveleft == 1 or cmd.in_moveright == 1 or cmd.in_back == 1 or cmd.in_forward == 1 or cmd.in_jump == 1
            local wep = entity.get_local_player( ):get_player_weapon( )
        
            local next_shot_ready = false
            if wep then
                local reloading = wep.m_bInReload == 1
                local next_attack_ready = wep.m_flNextPrimaryAttack < globals.curtime
        
                if not reloading and next_attack_ready then
                    next_shot_ready = true
                end
            end
            
            local can_normally_shoot = next_shot_ready --! and can_hit_normal( tgt )
        
            return not ( ( slowdown or has_user_input or not next_shot_ready ) and not can_normally_shoot )
        end
        
        local function retreatToPos( cmd, lp, lp_pos, new_pos )
            local distance = lp_pos:dist( new_pos ) + 5
            local unit_vec = ( new_pos - lp_pos ):normalized( )
            
            new_pos = lp_pos + unit_vec * ( distance + 5 )
        
            if cmd.forwardmove == 0 and cmd.sidemove == 0 and not cmd.in_forward and not cmd.in_back and not cmd.in_moveleft and not cmd.in_moveright then
                if distance >= 0.5 then
                    local fwd1 = new_pos - lp_pos
        
                    local pos1 = new_pos + fwd1:normalized( )*10
        
                    local fwd = pos1 - lp_pos
                    local ang = fwd:angles()
                    local yaw = ang.y
        
                    if yaw == nil then
                        return
                    end
        
                    cmd.move_yaw = yaw
                    cmd.in_speed = 0
        
                    cmd.in_moveleft, cmd.in_moveright = 0, 0
                    cmd.sidemove = 0
        
        
                    if distance > 8 then
                        cmd.forwardmove = 900000
                    else
                        local wishspeed = math.min( 450, math.max( 1.1+lp.m_flDuckAmount * 10, distance * 9 ) )
                        local vel = lp.m_vecAbsVelocity:length2d( )
                        if vel >= math.min( 250, wishspeed )+15 then
                            cmd.forwardmove = 0
                            cmd.in_forward = 0
                        else
                            cmd.forwardmove = math.max( 6, vel >= math.min( 250, wishspeed ) and wishspeed * 0.9 or wishspeed )
                            cmd.in_forward = 1
                        end
                    end
                end
            end
        end
        
        local function handle_peek( cmd )
            local lp = entity.get_local_player( )
            local lp_pos = lp:get_eye_position( )
        
            cache.found_position.z = lp_pos.z
            retreatToPos( cmd, lp, lp_pos, cache.found_position )
        end
        
        local function handle_retreat( cmd )
            local lp = entity.get_local_player( )
            local lp_pos = lp:get_eye_position( )
        
            retreatToPos( cmd, lp, lp_pos, cache.autopeek_position )
        end
        
        
        local debug = {
            state = 'disabled',
            step = 0,
            visual_step = 0,
        }
        
        local function set_state( new_state )
            debug.state = new_state
        end
        
        local e_visual_steps = {
            IDLE = 0,
            FINDING_TARGET = 1,
            SEARCHING_HITPOINTS = 2,
            CHECKING_HITPOINTS = 3,
            PEEKING = 4,
            RETREATING = 5,
            WAITING_FOR_SHOT = 6,
            NO_ENEMIES = 7,
            DT_NOT_CHARGED = 8,
        }
        
        local visual_texts = {
            [ e_visual_steps.IDLE ] = 'idle',
            [ e_visual_steps.FINDING_TARGET ] = 'finding target',
            [ e_visual_steps.SEARCHING_HITPOINTS ] = 'searching hitpoints',
            [ e_visual_steps.CHECKING_HITPOINTS ] = 'checking hitpoints',
            [ e_visual_steps.PEEKING ] = 'peeking',
            [ e_visual_steps.RETREATING ] = 'retreating',
            [ e_visual_steps.WAITING_FOR_SHOT ] = 'waiting for shot',
            [ e_visual_steps.NO_ENEMIES ] = 'no enemies',
            [ e_visual_steps.DT_NOT_CHARGED ] = 'dt not charged',
        }
        
        local e_steps = {
            IDLE = 0,
            FINDING_TARGET = 1,
            SEARCHING_HITPOINTS = 2,
            CHECKING_HITPOINTS = 3,
            PEEKING = 4,
            RETREATING = 5,
        }
        
        local function set_step( step )
            debug.step = step
        end
        
        local function set_visual_step( step )
            debug.visual_step = step
        end
        
        local peeking_points = { }
        local function setuo_peek( cmd )
            local lp = entity.get_local_player( )
        
            if not lp then return end
        
            local pos = lp.m_vecOrigin
            local autopeek_state = misc.aipeekbot.peekbot.bindbutton:get( )
            ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"):override(autopeek_state)
            if not autopeek_state then
                cache.autopeek_position = pos
        
                peeking_points = peekPoints_get( lp )
        
                reset_cache( )
                set_state( 'disabled' )
                set_step( e_steps.IDLE )
                set_visual_step( e_visual_steps.IDLE )
                ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"):override()
                return
            end
        
            visual_peekpopint_set( peeking_points )
        
            set_state( 'idle' )
        
            local distance = ( cache.autopeek_position - cache.found_position ):length2d( )
            local can_run = canHitInTick( distance, 250, 24 )
        
            local can_shoot = isShootReady( lp, cmd )
        
            local can_hit_old_record = cache.last_peek_pos ~= nil and cache.last_peek_ent ~= nil and cache.last_peek_ent:is_player( )  and cache.last_peek_ent:is_alive( ) and canHitEnmyPos( lp, cache.last_peek_pos , cache.last_peek_ent, playersPointGet( cache.last_peek_ent ) )
        
            if ( ( cache.last_seen + 24 ) >= globals.tickcount or can_hit_old_record ) and can_run and can_shoot then
                handle_peek( cmd )
                set_state( 'peeking' )
                set_step( e_steps.PEEKING )
                set_visual_step( e_visual_steps.PEEKING )
                return --!!!!!!!!!!!!!!!!!!! REMOVE IF BAD
            elseif ( cache.autopeek_position - pos ):length2d( ) > 5 then
                handle_retreat( cmd )
                set_state( 'retreating' )
                
                set_step( e_steps.RETREATING )
                set_visual_step( e_visual_steps.RETREATING )
                return --!!!!!!!!!!!!!!!!!!! REMOVE IF BAD
            end
        
            if not can_shoot then
                set_step( e_steps.IDLE )
                set_visual_step( e_visual_steps.WAITING_FOR_SHOT )
                return
            end
        
            local dt_charged = rage.exploit:get( ) and _ui.reference.ragebot.doubletap:get( )
        
            if not dt_charged then
                set_step( e_steps.FINDING_TARGET )
                set_visual_step( e_visual_steps.DT_NOT_CHARGED )
                return
            end
            
            local targets = entity.get_players( true ) or { closest_enemy }
        
            if #targets == 0 or targets[ 1 ] == nil then
                reset_cache( )
                set_state( 'idle' )
                set_step( e_steps.IDLE )
                set_visual_step( e_visual_steps.NO_ENEMIES )
                return
            end
        
            if can_shoot then
                set_step( e_steps.FINDING_TARGET )
                set_visual_step( e_visual_steps.FINDING_TARGET )
            end
        
        
            for idx = 1, #targets do
                local target = targets[ idx ]
        
                if not target or not target:is_alive( ) or target:is_dormant( ) then
                    goto continue
                end
                
                local target_data = target_enemy_lagcomp[ target ]
        
                if target_data == nil then
                    target_data = createEnemyRecord( target )
                end
        
                target_data.update( )
        
                local is_lc = target_data.breaking_lc
                local is_defensive =  target_data.defensive
                local can_peek = not is_lc and not is_defensive
        
                local hitpoints = playersPointGet( target )
                visualize_debugged_data( hitpoints[ 1 ], target )
        
                set_step( e_steps.SEARCHING_HITPOINTS )
                set_visual_step( e_visual_steps.SEARCHING_HITPOINTS )
        
                if not can_peek then
                    set_step( e_steps.CHECKING_HITPOINTS )
                    set_visual_step( e_visual_steps.CHECKING_HITPOINTS )
                    goto continue
                end
        
                local can_hit, peek_pos, peek_ent = canHitEnmyPosset( lp, peeking_points, target, hitpoints )
        
                if can_hit then
        
                    cache.last_seen = globals.tickcount
                    cache.last_peek_pos = peek_pos
                    cache.last_peek_ent = peek_ent
                    break
                end
        
                ::continue::
            end
        end
        
        events.createmove:set( setuo_peek )
        events.aim_fire:set( function( )
            -- reset the last_seen variable since we just shot and want to retreat
            cache.last_seen = 0
        end )
        
        local x, y = 400, 400
        
    
        
        local visual_points = {
            last_pressed = 0,
            last_state = false,
            animation_time = .2,
        }
        
        local function ease_in_back( time )
            local c1 = 1.70158
            local c3 = c1 + 1
        
            return c3 * time * time * time - c1 * time * time
        end
        
        local function render_peeking_point( pos, state )
            render.circle(
                pos,
                color( 255, 255, 255, 255 ),
                5, 0, 1
            )
        
            if state then
                --renderer.circle_outline(x, y, r, g, b, a, radius, start_degrees, percentage, thickness)
                render.circle_outline(
                    pos,
                    color( 0, 255, 0, 255 ),
                    6, 0, 1,
                    2
                )
            end
        end
        
        local function render_peeking_points( )
            local ap_state = misc.aipeekbot.peekbot.bindbutton:get( )
        
            if ap_state ~= visual_points.last_state then
                visual_points.last_pressed = globals.curtime
                visual_points.last_state = ap_state
            end
        
            -- clamp the difference to 0->visual_points.animation_time
            local diff = globals.curtime - visual_points.last_pressed
            diff = math.min( diff, visual_points.animation_time )
        
            local animation_factor = ease_in_back( diff / visual_points.animation_time )
        
            if not ap_state then
                animation_factor = 1 - animation_factor
            end
        
            if not ap_state and animation_factor <= 0.1 then return end
        
            local points = visuals.peeking_points
        
            for i = 1, #points do
                local point = points[ i ]
        
                local pos = render.world_to_screen( point )
        
                if pos ~= nil and pos.x ~= nil and pos.y ~= nil then
                    render_peeking_point( pos, visuals.found_point == i )
                end
            end
        end
        
        events.render:set( function( )
            render_peeking_points( )
        
            if misc.aipeekbot.peekbot.bindbutton:get( ) then
                getEnmyAsClosed( )
            end
        end )
        
        
        local function update_peek_points( )
            local lp = entity.get_local_player( )
        
            if not lp then return end
        
            peeking_points = peekPoints_get( lp )
            visual_peekpopint_set( peeking_points )
        end
        
        misc.aipeekbot.peekbot.dot_amount:set_callback( update_peek_points )
        misc.aipeekbot.peekbot.dot_offset:set_callback( update_peek_points )
        misc.aipeekbot.peekbot.dot_span:set_callback( update_peek_points )
    end

    local dormantaimbot do
        misc.dormant_aimbot = {}
    
        misc.dormant_aimbot.enable = _ui.menulist.right_upper:switch("\v\f<block-brick-fire>\r\a[white]  Dormant aimbot", false, function(gear, item)
            return {
                hitboxes = gear:selectable("Hitboxes", {"Head", "Chest", "Stomach", "Legs"}):depend(item),
                hitchance = gear:slider("Hitchance", 50, 85, 60, nil, "%"):depend(item),
                damage = gear:slider("Damage", -1, 130, -1, nil, function(value)
                                if value == -1 then
                                    return "Thread"
                                end
                                
                                if value > 100 then
                                    return "+" .. (value - 100)
                                end
                                
                                return nil
                            end):depend(item),
                auto_scope = gear:switch("Auto Scope"):depend(item)
            }
        end):depend({tab_selector, 4})
    
        local WEAPONTYPE_SNIPER_RIFLE = 5
    
        local aim_target
        local aim_point
        local aim_hitbox
        local aim_damage
        local aim_accuracy
    
        local is_hit = false
        local is_shot = false
    
        local target_index = 1
        local round_started = 0.0
    
        local e_hitbox = {
            [0]  = "Generic",
            [1]  = "Head",
            [2]  = "Chest",
            [3]  = "Stomach",
            [4]  = "Chest",
            [5]  = "Chest",
            [6]  = "Legs",
            [7]  = "Legs",
            [8]  = "Head",
            [10] = "Gear"
        }
    
        local hitbox_points = {
            {
                scale = 5,
                hitbox = "Stomach",
                vec = vector(0, 0, 40)
            },
    
            {
                scale = 6,
                hitbox = "Chest",
                vec = vector(0, 0, 50)
            },
    
            {
                scale = 3,
                hitbox = "Head",
                vec = vector(0, 0, 58)
            },
    
            {
                scale = 4,
                hitbox = "Legs",
                vec = vector(0, 0, 20)
            }
        }
    
        local function contains(list, value)
            for i = 1, #list do
                if list[i] == value then
                    return true
                end
            end
    
            return false
        end
    
        local function is_weapon_gun(type)
            return type >= 1 and type <= 6
        end
    
        local function get_aimbot_targets()
            local list = { }
    
            local player_resource = entity.get_player_resource()
    
            for i = 1, globals.max_players do
                local player = entity.get(i)
    
                if player == nil then
                    goto continue
                end
    
                local is_target_valid = player_resource.m_bConnected[i]
                    and player:is_enemy() and player:is_dormant()
    
                if not is_target_valid then
                    goto continue
                end
    
                table.insert(list, player)
                ::continue::
            end
    
            return list
        end
    
        local function create_multipoints(from, to, radius)
            local angles = from:to(to):angles()
            local radian = math.rad(angles.y + 90)
    
            local forward = vector(math.cos(radian), math.sin(radian), 0)
            local direction = forward * radius
    
            return {
                {
                    text = "Middle",
                    vec = to
                },
    
                {
                    text = "Left",
                    vec = to + direction
                },
    
                {
                    text = "Right",
                    vec = to - direction
                }
            }
        end
    
        local function trace_bullet(player, start_pos, end_pos, skip)
            local damage, trace = utils.trace_bullet(player, start_pos, end_pos, skip)
    
            if trace ~= nil then
                local ent = trace.entity
    
                if ent == nil then
                    return 0, trace
                end
    
                if ent:is_player() and not ent:is_enemy() then
                    return 0, trace
                end
            end
    
            return damage, trace
        end
    
        local function on_createmove(cmd)
            ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"):override(false)
    
            local me = entity.get_local_player()
    
            if me == nil then
                return
            end
    
            local weapon = me:get_player_weapon()
    
            if weapon == nil then
                return
            end
    
            local weapon_info = weapon:get_weapon_info()
    
            if weapon_info == nil then
                return
            end
    
            local inaccuracy = weapon:get_inaccuracy()
    
            if inaccuracy == nil then
                return
            end
    
            local tickcount = globals.tickcount
    
            local eye_pos = me:get_eye_position()
            local simtime = me:get_simulation_time().current
    
            local onground = bit.band(me.m_fFlags, bit.lshift(1, 0)) ~= 0
    
            if tickcount < round_started then
                return
            end
    
            if cmd.in_jump and not onground then
                return
            end
    
            local weapon_type = weapon_info.weapon_type
    
            if not is_weapon_gun(weapon_type) or weapon.m_iClip1 <= 0 then
                return false
            end
    
            local targets = get_aimbot_targets()
            local hitboxes = misc.dormant_aimbot.enable.hitboxes:get()
    
            if tickcount % #targets ~= 0 then
                target_index = target_index + 1
            else
                target_index = 1
            end
    
            local target = targets[target_index]
    
            if target == nil then
                return
            end
    
            local bbox = target:get_bbox()
            local origin = target:get_origin()
    
            local duck_amount = target.m_flDuckAmount
    
            local hitchance = misc.dormant_aimbot.enable.hitchance:get()
            local desired_damage = misc.dormant_aimbot.enable.damage:get()
    
            if desired_damage == -1 then
                desired_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"):get()
            end
    
            if desired_damage > 100 then
                desired_damage = desired_damage - 100 + target.m_iHealth
            end
    
            local points = { }
    
            for i = 1, #hitbox_points do
                local data = hitbox_points[i]
    
                local vec = data.vec
                local scale = data.scale
                local hitbox = data.hitbox
    
                if hitbox == "Head" then
                    vec = vec - vector(0, 0, 10 * duck_amount)
                end
    
                if hitbox == "Chest" then
                    vec = vec - vector(0, 0, 4 * duck_amount)
                end
    
                if #hitboxes ~= 0 then
                    if contains(hitboxes, hitbox) then
                        table.insert(points, {
                            vec = vec,
                            scale = scale,
                            hitbox = hitbox
                        })
                    end
                else
                    table.insert(points, 1, {
                        vec = vec,
                        scale = scale,
                        hitbox = hitbox
                    })
                end
            end
    
            local is_available_to_shoot = weapon_info.is_revolver and weapon.m_flNextPrimaryAttack < simtime
                or math.max(me.m_flNextAttack, weapon.m_flNextPrimaryAttack, weapon.m_flNextSecondaryAttack) < simtime
    
            if not is_available_to_shoot then
                return
            end
    
            local found_pos
            local found_damage
    
            if hitchance >= math.floor(bbox.alpha * 100) + 5 then
                return
            end
    
            for j = 1, #points do
                local point = points[j]
                local multipoints = create_multipoints(eye_pos, origin + point.vec, point.scale)
    
                for k = 1, #multipoints do
                    local multipoint = multipoints[k]
                    local aimpoint = multipoint.vec
    
                    local damage, tr = trace_bullet(me, eye_pos, aimpoint, function(ent)
                        return ent == target
                    end)
    
                    if tr ~= nil and tr:is_visible() then
                        goto continue
                    end
    
                    if damage ~= 0 and desired_damage < damage then
                        found_pos = aimpoint
                        found_damage = damage
    
                        aim_target = target
                        aim_hitbox = point.hitbox
                        aim_damage = damage
                        aim_point = multipoint.text
                        aim_accuracy = bbox.alpha
    
                        break
                    end
    
                    ::continue::
                end
    
                if found_pos and found_damage then
                    break
                end
            end
    
            if not found_pos or not found_damage then
                return
            end
    
            local angles = eye_pos:to(found_pos):angles()
    
            cmd.block_movement = 1
    
            if misc.dormant_aimbot.enable.auto_scope:get() then
                local is_onground = not cmd.in_jump and onground
    
                local is_scoped = me.m_bIsScoped or me.m_bResumeZoom
                local is_sniper = weapon_info.weapon_type == WEAPONTYPE_SNIPER_RIFLE
    
                if not is_scoped and is_sniper and is_onground then
                    cmd.in_attack2 = true
                end
            end
    
            if inaccuracy < 0.01 then
                cmd.view_angles = angles
                cmd.in_attack = true
    
                is_shot = true
            end
        end
    
        local function on_weapon_fire(e)
            utils.execute_after(0.03, function()
                if entity.get(e.userid, true) == entity.get_local_player() then
                    if is_shot and not is_hit then
                        events["dormant_miss"]:call {
                            userid = aim_target,
                            aim_hitbox = aim_hitbox,
                            aim_damage = aim_damage,
                            aim_point = aim_point,
                            accuracy = aim_accuracy
                        }
                    end
    
                    is_hit = false
                    is_shot = false
    
                    aim_target = nil
                    aim_hitbox = nil
                    aim_damage = nil
                    aim_point = nil
                    aim_accuracy = nil
                end
            end)
        end
    
        local function on_player_hurt(e)
            local me = entity.get_local_player()
    
            local userid = entity.get(e.userid, true)
            local attacker = entity.get(e.attacker, true)
    
            if userid == nil or attacker ~= me then
                return
            end
    
            local bbox = userid:get_bbox()
    
            if bbox == nil then
                return
            end
    
            if userid:is_dormant() and is_shot == true then
                is_hit = true
    
                events["dormant_hit"]:call {
                    userid = userid,
                    attacker = attacker,
                    health = e.health,
                    armor = e.armor,
                    weapon = e.weapon,
                    dmg_health = e.dmg_health,
                    dmg_armor = e.dmg_armor,
                    hitgroup = e.hitgroup,
                    accuracy = bbox.alpha,
                    hitbox = e_hitbox[e.hitgroup],
                    aim_point = aim_point,
                    aim_hitbox = aim_hitbox,
                    aim_damage = aim_damage
                }
            end
        end
    
        local function on_shutdown()
            ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"):override()
        end
    
        misc.dormant_aimbot.enable:set_callback(function(item)
            local value = item:get()
    
            if not value then
                ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"):override()
            end
    
            events.shutdown(on_shutdown, value)
            events.createmove(on_createmove, value)
    
            events.weapon_fire(on_weapon_fire, value)
            events.player_hurt(on_player_hurt, value)
        end, true)
    end

    local supertoss do
        misc.supertoss = {}
    
        misc.supertoss.enable = _ui.menulist.right_upper:switch("\v\f<hands>\a[white]   Nade Stabilization"):depend({tab_selector, 4})
    
        -- https://gitlab.com/KittenPopo/csgo-2018-source/-/blob/main/game/shared/cstrike15/weapon_basecsgrenade.cpp#L555
        -- Thx zeromemory for source from havoc hack
    
        local function lerp(a, b, t)
            return a + t * (b - a)
        end
    
        local function get_throw_toss(throw_angle, throw_velocity, throw_strength, abs_velocity)
            local vel = math.clamp(throw_velocity, 15, 750)
            local clamped_throw_strength = math.clamp(throw_strength, 0.0, 1.0)
    
            vel = vel * lerp(0.3, 1.0, clamped_throw_strength)
    
            local forward = vector():angles(throw_angle)
            local throw = forward * vel - abs_velocity
    
            return throw:angles()
        end
    
        local on_createmove = function(cmd)
            if not misc.supertoss.enable:get() then return end
            if render.camera_angles() ~= cmd.view_angles:clone() then
                return
            end
    
            local me = entity.get_local_player()
    
            if me == nil then
                return
            end
    
            local weapon = me:get_player_weapon()
    
            if weapon == nil then
                return
            end
    
            local weapon_info = weapon:get_weapon_info()
    
            if weapon_info == nil then
                return
            end
    
            local weapon_type = weapon_info.weapon_type
    
            if weapon_type ~= 9 then
                return
            end
    
            local predicted_time = globals.curtime - to_time(globals.clock_offset)
    
            if weapon.m_fThrowTime < predicted_time then
                return
            end
    
            cmd.in_speed = true
    
            cmd.view_angles = get_throw_toss(
                render.camera_angles(),
                weapon_info.throw_velocity,
                weapon.m_flThrowStrength,
                me.m_vecVelocity
            )
        end
    
        local on_grenade_override_view = function(e)
            if not misc.supertoss.enable:get() then return end
            local me = entity.get_local_player()
    
            if me == nil then
                return
            end
    
            local weapon = me:get_player_weapon()
    
            if weapon == nil then
                return
            end
    
            local weapon_info = weapon:get_weapon_info()
    
            if weapon_info == nil then
                return
            end
    
            e.angles = get_throw_toss(
                e.angles,
                weapon_info.throw_velocity,
                weapon.m_flThrowStrength,
                e.velocity
            )
        end
    
        events.createmove:set(on_createmove)
        events.grenade_override_view:set(on_grenade_override_view)
    end
    
    misc.fastladder = _ui.menulist.right_upper:switch("\v\f<water-ladder>\a[white]   Fast ladder"):depend({tab_selector, 4})
    misc.nofalldamage = _ui.menulist.right_upper:switch("\v\f<person-falling>\a[white]   No Fall Damage"):depend({tab_selector, 4})

    local nflstate = false

    local tracefaill = function(player, length)
        local origin = player:get_origin()

        for i = 0, math.pi * 2.0, math.pi * 2.0 / 8 do
            local sin = math.sin(i)
            local cos = math.cos(i)

            local x = origin.x + cos * 10
            local y = origin.y + sin * 10

            local start_pos = vector(x, y, origin.z)

            local end_pos = start_pos:clone()
            end_pos.z = end_pos.z - length

            local trace = utils.trace_line(start_pos, end_pos, player)

            if trace.fraction < 1.0 then
                return true
            end
        end

        return false
    end

    local nofalldamage_setup = function(e)
        if not misc.nofalldamage:get() then return end
        local me = entity.get_local_player()

        if me == nil then
            return
        end

        local velocity = me.m_vecVelocity

        if velocity.z >= -500 then
            nflstate = false
            return
        end

        if tracefaill(me, 15) then
            nflstate = false
        elseif tracefaill(me, 75) then
            nflstate = true
        end

        e.in_duck = nflstate
    end

    local laddermove = function(e)
        local pitch = render.camera_angles().x

        if e.forwardmove > 0 then
            if pitch < 45 then
                e.view_angles.x = 89

                e.in_moveright = 1
                e.in_moveleft = 0
                e.in_forward = 0
                e.in_back = 1

                if e.sidemove == 0 then
                    e.view_angles.y = e.view_angles.y + 90
                end

                if e.sidemove < 0 then
                    e.view_angles.y = e.view_angles.y + 150
                end

                if e.sidemove > 0 then
                    e.view_angles.y = e.view_angles.y + 30
                end
            end
        end

        if e.forwardmove < 0 then
            e.view_angles.x = 89

            e.in_moveleft = 1
            e.in_moveright = 0
            e.in_forward = 1
            e.in_back = 0

            if e.sidemove == 0 then
                e.view_angles.y = e.view_angles.y + 90
            end

            if e.sidemove > 0 then
                e.view_angles.y = e.view_angles.y + 150
            end

            if e.sidemove < 0 then
                e.view_angles.y = e.view_angles.y + 30
            end
        end
    end

    local function fastladder_setup(e)
        if not misc.fastladder:get() then return end
        local me = entity.get_local_player()
        if me == nil then
            return
        end
        local movetype = me.m_MoveType
        if movetype ~= 9 then
            return
        end
        laddermove(e)
    end

    events.createmove:set(function(cmd)
        nofalldamage_setup(cmd)
        fastladder_setup(cmd)
    end)
end

local animation_breaker do
    local animations = {}

    local animlayer_t = ffi.typeof [[
        struct {
            float  m_flLayerAnimtime;
            float  m_flLayerFadeOuttime;

            // dispatch flags
            void  *m_pDispatchedStudioHdr;
            int    m_nDispatchedSrc;
            int    m_nDispatchedDst;

            int    m_nOrder;
            int    m_nSequence;
            float  m_flPrevCycle;
            float  m_flWeight;
            float  m_flWeightDeltaRate;

            // used for automatic crossfades between sequence changes;
            float  m_flPlaybackRate;
            float  m_flCycle;
            int    m_pOwner;
            int    m_nInvalidatePhysicsBits;
        } **
    ]]

    animations.enable = _ui.menulist.right_upper:switch("\v\f<magnifying-glass>\r   Animations", false):depend({tab_selector, 4})
    animations.gear = animations.enable:create()
    --animations.type = animations.gear:selectable("\n", {"landing pitch","static leg in air","static leg in crouch","static leg in slow-walk","move Lean","skeet leg fucker","earthquake","kangaroo"}):depend({tab_selector, 4}, animations.enable)
    animations.type_inair = animations.gear:selectable("In Air", {"static"}):depend(animations.enable)
    animations.type_onground = animations.gear:selectable("On Ground", {"static leg in crouch", "static leg in slow-walk", "skeet leg fucker"}):depend(animations.enable)
    animations.type_addons = animations.gear:selectable("Addons", {"landing pitch", "earthquake", "kangaroo"}):depend(animations.enable)
    animations.moveleanforce = animations.gear:slider("move lean force", 0, 100, 100, nil, "%"):depend(animations.enable)
    animations.moveleanonground = animations.gear:switch("on ground force"):depend(animations.enable)

    local function get_animation_layer(player)
        return ffi.cast(animlayer_t, ffi.cast("uintptr_t", player[0]) + 0x2990)[0]
    end

    local function get_earthquake_value(frequency)
        local current_tick = globals.tickcount / 10
        local factor = 0.5 + 0.5 * math.sin(current_tick * frequency)

        return factor * 100
    end

    local function update_static_leg_in_air(player, animlayers)
        if not animations.type_inair:get "static leg in air" then
            return
        end

        player.m_flPoseParameter[6] = 1
    end

    local function update_static_leg_in_crouch(player, animlayers)
        if not animations.type_onground:get "static leg in crouch" then
            return
        end

        player.m_flPoseParameter[8] = 0
    end

    local function update_static_leg_in_slow_walk(player, animlayers)
        if not animations.type_onground:get "static leg in slow-walk" then
            return
        end

        if not ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() then
            return
        end

        player.m_flPoseParameter[9] = 0
    end

    local function update_leg_fucker(player, animlayers)
        if not animations.type_onground:get "skeet leg fucker" then
            return
        end

        player.m_flPoseParameter[0] = utils.random_float(0.8 / 10, 1)
        if utils.random_int(0, 1) == 1 then
            ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override("Sliding")
        else
            ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override("Default")
        end
    end

    local function update_move_lean(player, animlayers)
        if not animations.type_addons:get "move lean" then
            return
        end

        if player.is_onground and not animations.moveleanonground:get() then
            return
        end

        local weight = animlayers[12].m_flWeight
        local amount = animations.moveleanforce:get()

        animlayers[12].m_flWeight = math.clamp(weight + weight * amount, 0.0, 1.0)
    end

    local function update_landing_pitch(player, animstate)
        if not animations.type_addons:get "landing pitch" then
            return
        end

        if animstate.landing then
            player.m_flPoseParameter[12] = 0.5
        end
    end

    local function update_earthquake(player, animlayers)
        if not animations.type_addons:get "earthquake" then
            return
        end

        if player.is_onground and animations.type_onground:get "skeet leg fucker" then
            return
        end

        if globals.tickcount % 10 > 1 then
            animlayers[12].m_flWeight = get_earthquake_value(7) / 100
        end
    end

    local function update_kangaroo(player)
        if not animations.type_addons:get "kangaroo" then
            return
        end

        if player.is_onground and animations.type_onground:get "skeet leg fucker" then
            return
        end

        player.m_flPoseParameter[3] = math.random(0, 10) / 10
        player.m_flPoseParameter[6] = math.random(0, 10) / 10
        player.m_flPoseParameter[7] = math.random(0, 10) / 10

        if animations.type_inair:get "static leg in air" then
            player.m_flPoseParameter[6] = 1
        end
    end

    local function on_update_csa(player)
        local me = entity.get_local_player()

        if me ~= player then
            return
        end

        local animstate = player:get_anim_state()

        if animstate == nil then
            return
        end

        local animlayers = get_animation_layer(player)

        if animlayers == nil then
            return
        end

        update_leg_fucker(player, animlayers)
            update_landing_pitch(player, animstate)

            update_static_leg_in_crouch(player, animlayers)
            update_static_leg_in_slow_walk(player, animlayers)
        update_static_leg_in_air(player, animlayers)
        

        update_kangaroo(player)

        update_move_lean(player, animlayers)
        update_earthquake(player, animlayers)
    end

    local function on_shutdown()
        ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"):override()
    end

    local function update_event_callbacks(value)
        events.shutdown(on_shutdown, value)
        events.post_update_clientside_animation(on_update_csa, value)
    end

    local function on_enabled(item)
        local value = item:get()

        if not value then
            on_shutdown()
        end

        update_event_callbacks(value)
    end

    animations.enable:set_callback(on_enabled, true)
end


pui_config = pui.setup({antiaim_ui, antiaim, visuals, misc}, true)
local config_system do
    cfg_system = {}
    configs_db = db.frostyylua or { }
    configs_db.cfg_list = configs_db.cfg_list or {}
    configs_db.menu_list = configs_db.menu_list or {}
    --print_dev(configs_db.menu_list)

    cfg_system.save_config = function(id)
        local raw = pui_config:save()
        configs_db.cfg_list[id][2] = base64.encode(json.stringify(raw))
        db.frostyylua = configs_db
    end
    
    cfg_system.update_values = function(id)
        local name = configs_db.cfg_list[id][1]
        local new_name = name
        for k, v in ipairs(configs_db.cfg_list) do
            configs_db.menu_list[k] = v[1]
        end
        configs_db.menu_list[id] = new_name
    end
    
    cfg_system.create_config = function(name)
        if type(name) ~= 'string' then return end
        if name == nil or name == '' or name == ' ' then return end
        for i=#configs_db.menu_list, 1, -1 do if configs_db.menu_list[i] == name then common.add_notify('[xd]', 'Change Name') return end end
        if #configs_db.cfg_list > 6 then common.add_notify('[xd]', 'Too Much Configs') return end
        local completed = {name, ''}
        table.insert(configs_db.cfg_list, completed)
        table.insert(configs_db.menu_list, name)
        db.frostyylua = configs_db
        cvar.play:call("ambient\\tones\\elev1")
    end
    
    cfg_system.remove_config = function(id)
        local item = configs_db.cfg_list[id][1]
        for i=#configs_db.cfg_list, 1, -1 do if configs_db.cfg_list[i][1] == item then table.remove(configs_db.cfg_list, i) table.remove(configs_db.menu_list, i) end end
        db.frostyylua = configs_db
        cvar.play:call("ambient\\tones\\elev1")
    end
    
    cfg_system.load_config = function(id)
        if configs_db.cfg_list[id][2] == nil or configs_db.cfg_list[id][2] == '' then print(string.format('Error[data_base[%s]]', id)) return end
        if id > #configs_db.cfg_list then print(string.format('Error[data_base[%s]]', id)) return end
        pui_config:load(json.parse(base64.decode(configs_db.cfg_list[id][2])))
        cvar.play:call("ambient\\tones\\elev1")
    end
end

local config_local do 
    cfg_selector = _ui.menulist.right_upper:list('\n', configs_db.menu_list):depend({tab_selector, 1})
    name = _ui.menulist.right_upper:input('\n\n'):depend({tab_selector, 1})

    load = _ui.menulist.right_upper:button("                                \v\f<play>\a[white]   Load                                     ", function()
        cfg_system.update_values(cfg_selector:get())
        cfg_system.load_config(cfg_selector:get())
        cfg_selector:update(configs_db.menu_list)
    end, true):depend({tab_selector, 1})

    create = _ui.menulist.right_upper:button("                             \v\f<layer-plus>\a[white]   Create                                    ", function()
        cfg_system.create_config(name:get())
        cfg_selector:update(configs_db.menu_list)
    end, true):depend({tab_selector, 1})

    remove  = _ui.menulist.right_upper:button("         \v\f<trash-xmark>       ", function()
        cfg_system.remove_config(cfg_selector:get())
        cfg_selector:update(configs_db.menu_list)
        cvar.play:call("ambient\\tones\\elev1")
    end, true, "Delete selected config"):depend({tab_selector, 1})

    save = _ui.menulist.right_upper:button("      \v\f<floppy-disk>       ", function()
        cfg_system.save_config(cfg_selector:get())
        cvar.play:call("ambient\\tones\\elev1")
    end, true, "Save selected config"):depend({tab_selector, 1})
 
    import = _ui.menulist.right_upper:button("      \v\f<download>      ", function()
        pui_config:load(json.parse(base64.decode(clipboard.get())))
        cvar.play:call("ambient\\tones\\elev1")
    end, true, "Import selected config"):depend({tab_selector, 1})
    
    export = _ui.menulist.right_upper:button("      \v\f<upload>      ", function()
        clipboard.set(base64.encode(json.stringify(pui_config:save())))
        cvar.play:call("ambient\\tones\\elev1")
    end, true, "Export selected config"):depend({tab_selector, 1})
end