-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
--Requirements
local ffi = require("ffi") or error("Failed to load FFI")
local vector = require("vector") or error("Failed to load vector")
local csgo_weapon = require("gamesense/csgo_weapons") or error("Failed to load csgo_weapons | https://gamesense.pub/forums/viewtopic.php?id=18807")
local engineclient = require("gamesense/engineclient") or error("Failed to load csgo_weapons | https://gamesense.pub/forums/viewtopic.php?id=18807")
local http = require("gamesense/http") or error("Failed to load http | https://gamesense.pub/forums/viewtopic.php?id=19253")
local pui = require("gamesense/pui") or error("Failed to load pui | https://gamesense.pub/forums/viewtopic.php?id=41761")
local tab,place,place2,place3 =  "AA","Anti-aimbot angles","Fake lag","Other"

--[[
Ocean - \a009dc4FF
Skeet - \aCDCDCDFF
]]
--DefaultSkeetElements
local ElementsToHide = {
    Anti_Aimbot_Angles = {
        Enabled = ui.reference(tab, place, "Enabled"),
        Pitch = ui.reference(tab, place, "Pitch"),
        Pitch_Value = select(2,ui.reference(tab, place, "Pitch")),
        Yaw_Base = ui.reference(tab, place, "Yaw base"),
        Yaw = ui.reference(tab, place, "Yaw"),
        Yaw_Value = select(2,ui.reference(tab, place, "Yaw")),
        Yaw_Jitter = ui.reference(tab, place, "Yaw jitter"),
        Yaw_Jitter_Value = select(2,ui.reference(tab, place, "Yaw jitter")),
        Body_Yaw = ui.reference(tab, place, "Body yaw"),
        Body_Yaw_Value = select(2,ui.reference(tab, place, "Body yaw")),
        Freestanding_Body_Yaw = ui.reference(tab, place, "Freestanding body yaw"),
        Edge_Yaw = ui.reference(tab, place, "Edge yaw"),
        Freestanding = ui.reference(tab, place, "Freestanding"),
        Freestanding_Key = select(2,ui.reference(tab, place, "Freestanding")),
        Roll = ui.reference(tab, place, "Roll"),
    },
    Fake_Lag = {
        Enabled = ui.reference("AA", "Fake lag", "Enabled"),
        Enabled_Key = select(2,ui.reference("AA", "Fake lag", "Enabled")),
        Amount = ui.reference("AA", "Fake lag", "Amount"),
        Variance = ui.reference("AA", "Fake lag", "Variance"),
        Limit = ui.reference("AA", "Fake lag", "Limit"),
    },
    Other = {
        Slow_Motion = ui.reference("AA", "Other", "Slow motion"),
        Slow_Motion_key = select(2,ui.reference("AA", "Other", "Slow motion")),
        Leg_Movement = ui.reference("AA", "Other", "Leg movement"),
        On_Shot_Anti_Aim = ui.reference("AA", "Other", "On shot anti-aim"),
        On_Shot_Anti_Aim_key = select(2,ui.reference("AA", "Other", "On shot anti-aim")),
        Fake_Peek = ui.reference("AA", "Other", "Fake peek"),
        Fake_Peek_key = select(2,ui.reference("AA", "Other", "Fake peek")),
    }
}
--FutureReferences
local Menu_Reference = {
    --Rage
    Rage_Enable = {ui.reference("Rage", "Aimbot", "Enabled")},
    AutoFire = {ui.reference("Rage", "Other", "Automatic fire")},
    AutoPen = {ui.reference("Rage", "Other", "Automatic penetration")},
    Fov = ui.reference("Rage", "Other", "Maximum FOV"),
    ForceBaim = ui.reference("RAGE", "Aimbot", "Force body aim"),
    ForceSafe = ui.reference("RAGE", "Aimbot", "Force safe point"),
    MinDmg =  ui.reference( "RAGE" , "Aimbot" , "Minimum damage" ),
    MinDmgOvr =  {ui.reference( "RAGE" , "Aimbot" , "Minimum damage override" )},
    Fakeduck = ui.reference("Rage", "Other", "Duck peek assist"),
    Backtrack = ui.reference("Rage", "Other", "Accuracy boost"),
    DelayShot = ui.reference("Rage", "Other", "Delay Shot"),
    Multipoints =  ui.reference( "RAGE" , "Aimbot" , "Multi-point scale" ),

    --AA
    Enabled = ui.reference(tab, place, "Enabled"),
    Pitch = ui.reference(tab, place, "Pitch"),
    Pitch_Value = select(2,ui.reference(tab, place, "Pitch")),
    Yaw_Base = ui.reference(tab, place, "Yaw base"),
    Yaw = ui.reference(tab, place, "Yaw"),
    Yaw_Value = select(2,ui.reference(tab, place, "Yaw")),
    Yaw_Jitter = ui.reference(tab, place, "Yaw jitter"),
    Yaw_Jitter_Value = select(2,ui.reference(tab, place, "Yaw jitter")),
    Body_Yaw = ui.reference(tab, place, "Body yaw"),
    Body_Yaw_Value = select(2,ui.reference(tab, place, "Body yaw")),
    Freestanding_Body_Yaw = ui.reference(tab, place, "Freestanding body yaw"),
    Edge_Yaw = ui.reference(tab, place, "Edge yaw"),
    Freestanding = ui.reference(tab, place, "Freestanding"),
    Freestanding_Key = select(2,ui.reference(tab, place, "Freestanding")),
    Roll = ui.reference(tab, place, "Roll"),
    --AA FL
    FL_Enabled = {ui.reference("AA", "Fake lag", "Enabled")},
    Amount = ui.reference("AA", "Fake lag", "Amount"),
    Variance = ui.reference("AA", "Fake lag", "Variance"),
    Limit = ui.reference("AA", "Fake lag", "Limit"),
    --AA OTHER
    Slowwalk = {ui.reference(tab, place3, "Slow motion")},
    Leg_Movement = ui.reference("AA", "Other", "Leg movement"),
    On_Shot_Anti_Aim = ui.reference("AA", "Other", "On shot anti-aim"),
    On_Shot_Anti_Aim_key = select(2,ui.reference("AA", "Other", "On shot anti-aim")),
    Fake_Peek = ui.reference("AA", "Other", "Fake peek"),
    Fake_Peek_key = select(2,ui.reference("AA", "Other", "Fake peek")),

    --Visuals
    Thirdperson = {ui.reference("VISUALS", "Effects", "Force third person (alive)")},
    ScopeZoom = ui.reference("MISC", "Miscellaneous", "Override zoom FOV"),
    RemoveScope = ui.reference("VISUALS", "Effects", "Remove scope overlay"),
    Def_feature = ui.reference("VISUALS", "Other esp", "Feature indicators"),

    --Playerlist
    Players = ui.reference("PLAYERS", "Players", "Player list"),
    ApplyToAll = ui.reference("PLAYERS", "Adjustments", "Apply to all"),
    ResetAll = ui.reference("PLAYERS", "Players", "Reset all"),
    ForceBodyYaw = ui.reference("PLAYERS", "Adjustments", "Force body yaw"),
    ForceSlider = ui.reference("PLAYERS", "Adjustments", "Force body yaw value"),


    --Misc
    Clantag_Spammer = ui.reference("Misc", "Miscellaneous", "Clan tag spammer"),
    sv_pure = ui.reference("MISC", "Miscellaneous", "Disable sv_pure"),
    Ping = {ui.reference("Misc", "Miscellaneous", "Ping spike")},
    Menu_color = ui.reference("Misc", "Settings", "Menu color"),
    Anti_Untrusted = ui.reference("Misc", "Settings", "Anti-untrusted"),
    NameSteal = ui.reference("Misc", "Miscellaneous", "Steal player name"),

}
--MenuInfo
local Infos = {
    tabs = {"Aimbot", "AntiAim", "Visuals", "Misc"--[[, "Config"]]}, 
    aa_states = {"Stand", "Duck", "Move", "Slowwalk", "In-Air"},
    fl_states = {"Global", "Stand", "Duck", "Move", "Slowwalk", "In-Air"},
    aa_number = "Stand",
    fl_number = "Global",
}
--Menu
local FallbackName = { }
function setName(delay, name)
    client.delay_call(delay, function() 
        client.set_cvar("name", name)
    end)
end
local OceanMenu = {
    ["Main"] = {
        OceanEnabler = ui.new_checkbox(tab, place, "\a009dc4FFOcean\aCDCDCDFF.Tech - Enable"),
        Top_Spacer = ui.new_label(tab, place, "ㅤㅤㅤㅤㅤ  \aCDCDCDFF[\a009dc4FFOcean\aCDCDCDFF.Tech] ㅤㅤㅤㅤㅤ"),
        TabSelection = ui.new_combobox(tab, place, "Tab Selection", Infos.tabs),
    },

    ["Aimbot"] = {
        Enable = ui.new_checkbox(tab, place, "\a009dc4FFAimbot\aCDCDCDFF - Enable"),
        Autofire = ui.new_checkbox(tab, place, "\a009dc4FFAimbot\aCDCDCDFF - Automatic fire"),
        Autofire_hotkey = ui.new_hotkey(tab, place, "\a009dc4FFAimbot\aCDCDCDFF - Automatic fire", true),
        Autopenetration = ui.new_checkbox(tab, place, "\a009dc4FFAimbot\aCDCDCDFF - Automatic penetration"),
        Autopenetration_hotkey = ui.new_hotkey(tab, place, "\a009dc4FFAimbot\aCDCDCDFF - Automatic penetration", true),
        DynamicFOV = ui.new_checkbox(tab, place, "\a009dc4FFAimbot\aCDCDCDFF - Dynamic FOV"),
        Min_Fov = ui.new_slider(tab, place, "\a009dc4FFAimbot\aCDCDCDFF - Min FOV", 1, 180, 5, true, "°"),
        Max_Fov = ui.new_slider(tab, place, "\a009dc4FFAimbot\aCDCDCDFF - Max FOV", 1, 180, 25, true, "°"),
        Prio_System = ui.new_checkbox(tab, place, "\a009dc4FFAimbot\aCDCDCDFF - Ragebot priority system"),
        Prio_System_color = ui.new_color_picker(tab, place, "\a009dc4FFAimbot\aCDCDCDFF - Ragebot priority system", 255, 219, 127, 225),
        Disablers_checkbox = ui.new_checkbox(tab, place, "\a009dc4FFAimbot\aCDCDCDFF - Ragebot Disablers"),
        Disablers = ui.new_multiselect(tab, place, "\a009dc4FFAimbot\aCDCDCDFF - Ragebot Disablers", "Through Smoke", "While Flashed"),
        Roll_Enable = ui.new_checkbox(tab, place, "\a009dc4FFAimbot\aCDCDCDFF - Custom Resolver [\aD6BE73FFWIP Feature\aCDCDCDFF]"),
        Roll_Overrides = ui.new_multiselect(tab, place, "\a009dc4FFAimbot\aCDCDCDFF - Options", "Resolve Roll", "Resolve Desync", "Resolve LBY", "Half-Pitch Resolver", "Experimental Slowwalk Resolver", "Experimental In-Air Resolver"),
        Roll_Override_L = ui.new_slider(tab, place, "\a009dc4FFAimbot\aCDCDCDFF - Roll Override Left", -90, 90, 50, true, "°"),
        Roll_Override_R = ui.new_slider(tab, place, "\a009dc4FFAimbot\aCDCDCDFF - Roll Override Right", -90, 90, -50, true, "°"),
        Roll_Warning = ui.new_label(tab, place, "Resolve 'Desync' and 'LBY' Together May Cause issues"),
        --Roll_Untrusted_Pitch = ui.new_checkbox(tab, place, "\a009dc4FFAimbot\aCDCDCDFF - Resolve Pitch"),
    },

    ["AntiAim"] = {
        Enable = ui.new_checkbox(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Enable"),
        Inverter = ui.new_hotkey(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Inverter"),
        Freestand = ui.new_hotkey(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Freestanding"),
        AtTarget = ui.new_hotkey(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - At Target"),
        PitchKey = ui.new_hotkey(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Pitch on Key"),
        HalfPitchKey = ui.new_hotkey(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Half Pitch on Key"),
        ManualLeft = ui.new_hotkey(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Manual Left Key"),
        ManualRight = ui.new_hotkey(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Manual Right Key"),
        ManualLeftSlider = ui.new_slider(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Manual Yaw Left", -180, 180, -100, true, "°"),
        ManualRightSlider = ui.new_slider(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Manual Yaw Right", -180, 180, 100, true, "°"),
        Extras = ui.new_multiselect(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Extras", "Lower Body Yaw", "Roll", "Freestanding", "Yaw: At Targets", "Pitch-Down \aCDCDCDFF(\aD6BE73FFUnsafe\aCDCDCDFF)", "Half-Pitch \aCDCDCDFF(\aD6BE73FFUnsafe\aCDCDCDFF)", "Manual Yaw \aCDCDCDFF(\aD6BE73FFUnsafe\aCDCDCDFF)", "In-Air Tick Manipulation \aCDCDCDFF(\aD6BE73FFTesting\aCDCDCDFF)"),
        Disablers = ui.new_multiselect(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Anti-Aim Disablers", "While Fakeduck", "Tabbed Out", "Low FPS"),
        States = ui.new_combobox(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - States", Infos.aa_states),
        aa_state = {},
    },

    ["FakeLag"] = {
        Enable = ui.new_checkbox(tab, place2, "\a009dc4FFFake-lag\aCDCDCDFF - Enabled"),
        Key = ui.new_hotkey(tab, place2, "\a009dc4FFFake-lag\aCDCDCDFF - Enabled", true),
        Restrict = ui.new_checkbox(tab, place2, "\a009dc4FFFake-lag\aCDCDCDFF - Restrict Fake-lag on R8"),
        States = ui.new_combobox(tab, place2, "\a009dc4FFFake-lag\aCDCDCDFF - States", Infos.fl_states),
        fl_state = {},
    },


    ["Visuals"] = {
        Feature = ui.new_multiselect(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Feature Indicator", "Auto Fire","Auto Wall","FOV","Duck peek assist","Force Baim","Force Safepoint","AA","FL","Min. Damage","Ping","Freestand","Yaw: At Targets","Pitch","On-Shot","State"),
        Feature_color = ui.new_color_picker(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Feature Indicator", 255, 255, 255, 225),
        Feature_color2 = ui.new_color_picker(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Feature Indicator ", 124, 195, 13, 255),
        Custom_Scope = ui.new_checkbox(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Custom Scope Settings"),
        First_Person = ui.new_multiselect(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - First Person Settings", "Remove scope overlay", "Custom Scope Zoom"),
        First_Person_Zoom = ui.new_slider(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - First Person Zoom", 0, 100, 100, true, "%"),
        Third_Person = ui.new_multiselect(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Third Person Settings", "Remove scope overlay", "Custom Scope Zoom"),
        Third_Person_Zoom = ui.new_slider(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Third Person Zoom", 0, 100, 100, true, "%"),
        Crosshair_Indicator = ui.new_checkbox(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Crosshair Indicator"),
        Crosshair_Indicator_color = ui.new_color_picker(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Crosshair Indicator", 0, 157, 196, 225),
        Crosshair_Indicator_color1 = ui.new_color_picker(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Crosshair Indicator1", 255, 255, 255, 225),
        Crosshair_Indicator_select = ui.new_multiselect(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Crosshair Indicator", "Name", "Ragebot", "Fov", "Safe", "Baim", "Min. Dmg"),
        Body_Yaw_indicator = ui.new_checkbox(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Body yaw Indicator"),
        Body_Yaw_indicator_color = ui.new_color_picker(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Body yaw Indicator", 255, 255, 255, 225),
        Body_Yaw_indicator_selections = ui.new_combobox(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Body yaw Indicator Style", "⮜ - ⮞", "◀ - ▶", "◃ - ▹", "— - —"),
        Body_Yaw_indicator_Desync = ui.new_checkbox(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Fake Amount Color"),  
        Body_Yaw_indicator_Invert = ui.new_checkbox(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Invert Body yaw Indicator"),
        Watermark = ui.new_checkbox(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Watermark"),
        Watermark_select = ui.new_combobox(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Watermark Style", "Legacy", "Modern"),
        Watermark_color = ui.new_color_picker(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Watermark", 0, 157, 196, 225),
        LynxHitprediction = ui.new_checkbox(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - LynX Hitprediction"),
        LynxHitprediction_Selection = ui.new_combobox(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Hitprediction Settings", "Hit", "Name", "Name(Health)"),
        LynxHitprediction_color = ui.new_color_picker(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - LynX Hitprediction", 0, 157, 196, 225),
        LynxHitprediction_color2 = ui.new_color_picker(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Hitprediction Settings", 0, 157, 196, 225),
        Hide_Settings = ui.new_checkbox(tab, place, "\a009dc4FFVisuals\aCDCDCDFF - Hide Settings"),
    },

    ["Misc"] = {
        EventLogs = ui.new_checkbox(tab, place, "\a009dc4FFMisc\aCDCDCDFF - Event Logs"),
        EventLogs_Output = ui.new_multiselect(tab, place, "\a009dc4FFMisc\aCDCDCDFF - Output Methodes", "Chat", "Console"),
        Shared_Feature = ui.new_checkbox(tab, place, "\a009dc4FFMisc\aCDCDCDFF - Scoreboard Icon"),
        Untrusted = ui.new_checkbox(tab, place, "\a009dc4FFMisc\aCDCDCDFF - Allow \aD6BE73FFUntrusted\aCDCDCDFF Features"),
        Clantag = ui.new_combobox(tab, place, "\a009dc4FFMisc\aCDCDCDFF - Clan tag spammers", "-", "Ocean.Tech", "Ocean.Tech Static"),
        NameSpam = ui.new_button(tab, place, "\a009dc4FFMisc\aCDCDCDFF - NameSpam", function()
            tempName = "Ocean.Tech > ALL"
            endname = "​Ocean.Tech​ ​>​ ​ALL​"
            lp = entity.get_local_player()
            lp_name = entity.get_player_name(lp)
            can_name = true
            if can_name == true then
                table.insert(FallbackName, lp_name)
                can_name = false
            end
            for V, N in pairs(FallbackName) do 
               Final = N
    
            end
    
            if Final == nil then return end
            tempName11 = tempName .. "​"
            ui.set(Menu_Reference.NameSteal, true)
            client.set_cvar("name", tempName)
            setName(0.15, endname)
            setName(0.25, tempName)
            setName(0.35, Final)
            for V, N in pairs(FallbackName) do 
                table.remove(FallbackName, V)
            end
            can_name = true
        end),
    },

    ["Other"] = {
        Slowwalk = ui.new_checkbox(tab, place3, "\a009dc4FFOther\aCDCDCDFF - Slow motion"),
        Slowwalk_Key = ui.new_hotkey(tab, place3, "\a009dc4FFOther\aCDCDCDFF - Slow motion", true),
        Leg_movement = ui.new_combobox(tab, place3, "\a009dc4FFOther\aCDCDCDFF - Leg movement", "Off", "Always slide", "Never slide", "Leg breaker"),
        Hideshots = ui.new_checkbox(tab, place3, "\a009dc4FFOther\aCDCDCDFF - \aAFAF5FFFOn shot anti-aim"),
        Hideshots_Key = ui.new_hotkey(tab, place3, "\a009dc4FFOther\aCDCDCDFF - \aAFAF5FFFOn shot anti-aim", true),
    },


}
--AA States
for k,v in pairs(Infos.aa_states) do 
    y = string.sub(v,1,1)
    StateName = string.gsub(v,y,string.upper(y))

    OceanMenu["AntiAim"].aa_state[v] = {}
    OceanMenu["AntiAim"].aa_state[v].BodyYaw = ui.new_combobox(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Body Yaw[\a009dc4FF"..StateName.."\aCDCDCDFF]", "Freestand", "Opposite", "Jitter")
    OceanMenu["AntiAim"].aa_state[v].Open = ui.new_combobox(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Body Yaw - Vis[\a009dc4FF"..StateName.."\aCDCDCDFF]", "Opposite", "Jitter")
    OceanMenu["AntiAim"].aa_state[v].Reverse = ui.new_checkbox(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Reverse Freestanding[\a009dc4FF"..StateName.."\aCDCDCDFF]")
    OceanMenu["AntiAim"].aa_state[v].Brute = ui.new_checkbox(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Anti-Bruteforce[\a009dc4FF"..StateName.."\aCDCDCDFF]")
    OceanMenu["AntiAim"].aa_state[v].Roll = ui.new_checkbox(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Roll[\a009dc4FF"..StateName.."\aCDCDCDFF]")
    OceanMenu["AntiAim"].aa_state[v].Roll_L = ui.new_slider(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Roll Left[\a009dc4FF"..StateName.."\aCDCDCDFF]", -45, 45, 0)
    OceanMenu["AntiAim"].aa_state[v].Roll_R = ui.new_slider(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Roll Right[\a009dc4FF"..StateName.."\aCDCDCDFF]", -45, 45, 0)
    OceanMenu["AntiAim"].aa_state[v].Untrusted_L = ui.new_slider(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Untrusted Roll Left[\a009dc4FF"..StateName.."\aCDCDCDFF]", -75, 75, 0)
    OceanMenu["AntiAim"].aa_state[v].Untrusted_R = ui.new_slider(tab, place, "\a009dc4FFAnti-Aim\aCDCDCDFF - Untrusted Roll Right[\a009dc4FF"..StateName.."\aCDCDCDFF]", -75, 75, 0)
end
--FL States
for c,o in pairs(Infos.fl_states) do 
    y = string.sub(o,1,1)
    StateName = string.gsub(o,y,string.upper(y))

    OceanMenu["FakeLag"].fl_state[o] = {}
    OceanMenu["FakeLag"].fl_state[o].Override = ui.new_checkbox(tab, place2, "\a009dc4FFFake-lag\aCDCDCDFF - Override Global [\a009dc4FF"..StateName.."\aCDCDCDFF]")
    OceanMenu["FakeLag"].fl_state[o].Amount = ui.new_combobox(tab, place2, "\a009dc4FFFake-lag\aCDCDCDFF - Amount [\a009dc4FF"..StateName.."\aCDCDCDFF]", "Dynamic", "Maximum", "Fluctuate")
    OceanMenu["FakeLag"].fl_state[o].Variance = ui.new_slider(tab, place2, "\a009dc4FFFake-lag\aCDCDCDFF - Variance [\a009dc4FF"..StateName.."\aCDCDCDFF]", 0, 100, 0, true, "%")
    OceanMenu["FakeLag"].fl_state[o].Limit = ui.new_slider(tab, place2, "\a009dc4FFFake-lag\aCDCDCDFF - Limit [\a009dc4FF"..StateName.."\aCDCDCDFF]", 1, 6, 0)
end
--Contains Function
local table_contains = function(tbl, value)
    for i = 1, #tbl do
        if tbl[i] == value then
            return true
        end
    end
    return false
end
--Menu Visibility
local function OceanMenu_visibility()
    G_Check = ui.get(OceanMenu["FakeLag"].States) == "Global"
    Desnyc_Check = table_contains(ui.get(OceanMenu["Aimbot"].Roll_Overrides), "Resolve Desync")
    LBY_Check = table_contains(ui.get(OceanMenu["Aimbot"].Roll_Overrides), "Resolve LBY")
    --Main
    ui.set_visible(OceanMenu["Main"].OceanEnabler, true)
    ui.set_visible(OceanMenu["Main"].Top_Spacer, ui.get(OceanMenu["Main"].OceanEnabler))
    ui.set_visible(OceanMenu["Main"].TabSelection, ui.get(OceanMenu["Main"].OceanEnabler))
    --Aimbot
    ui.set_visible(OceanMenu["Aimbot"].Enable, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Aimbot")
    ui.set_visible(OceanMenu["Aimbot"].Autofire, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Aimbot" and ui.get(OceanMenu["Aimbot"].Enable))
    ui.set_visible(OceanMenu["Aimbot"].Autofire_hotkey, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Aimbot" and ui.get(OceanMenu["Aimbot"].Enable) and ui.get(OceanMenu["Aimbot"].Autofire))
    ui.set_visible(OceanMenu["Aimbot"].Autopenetration, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Aimbot" and ui.get(OceanMenu["Aimbot"].Enable))
    ui.set_visible(OceanMenu["Aimbot"].Autopenetration_hotkey, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Aimbot" and ui.get(OceanMenu["Aimbot"].Enable) and ui.get(OceanMenu["Aimbot"].Autopenetration))
    ui.set_visible(OceanMenu["Aimbot"].DynamicFOV, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Aimbot" and ui.get(OceanMenu["Aimbot"].Enable))
    ui.set_visible(OceanMenu["Aimbot"].Min_Fov, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Aimbot" and ui.get(OceanMenu["Aimbot"].Enable) and ui.get(OceanMenu["Aimbot"].DynamicFOV))
    ui.set_visible(OceanMenu["Aimbot"].Max_Fov, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Aimbot" and ui.get(OceanMenu["Aimbot"].Enable) and ui.get(OceanMenu["Aimbot"].DynamicFOV))
    ui.set_visible(OceanMenu["Aimbot"].Prio_System, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Aimbot" and ui.get(OceanMenu["Aimbot"].Enable))
    ui.set_visible(OceanMenu["Aimbot"].Prio_System_color, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Aimbot" and ui.get(OceanMenu["Aimbot"].Enable) and ui.get(OceanMenu["Aimbot"].Prio_System))
    ui.set_visible(OceanMenu["Aimbot"].Disablers_checkbox, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Aimbot" and ui.get(OceanMenu["Aimbot"].Enable))
    ui.set_visible(OceanMenu["Aimbot"].Disablers, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Aimbot" and ui.get(OceanMenu["Aimbot"].Enable) and ui.get(OceanMenu["Aimbot"].Disablers_checkbox))
    ui.set_visible(OceanMenu["Aimbot"].Roll_Enable, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Aimbot" and ui.get(OceanMenu["Aimbot"].Enable))
    ui.set_visible(OceanMenu["Aimbot"].Roll_Overrides, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Aimbot" and ui.get(OceanMenu["Aimbot"].Enable) and ui.get(OceanMenu["Aimbot"].Roll_Enable))
    ui.set_visible(OceanMenu["Aimbot"].Roll_Override_L, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Aimbot" and ui.get(OceanMenu["Aimbot"].Enable) and ui.get(OceanMenu["Aimbot"].Roll_Enable) and table_contains(ui.get(OceanMenu["Aimbot"].Roll_Overrides), "Resolve Roll"))
    ui.set_visible(OceanMenu["Aimbot"].Roll_Override_R, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Aimbot" and ui.get(OceanMenu["Aimbot"].Enable) and ui.get(OceanMenu["Aimbot"].Roll_Enable) and table_contains(ui.get(OceanMenu["Aimbot"].Roll_Overrides), "Resolve Roll"))
    ui.set_visible(OceanMenu["Aimbot"].Roll_Warning, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Aimbot" and ui.get(OceanMenu["Aimbot"].Enable) and ui.get(OceanMenu["Aimbot"].Roll_Enable) and Desnyc_Check and LBY_Check)
    --ui.set_visible(OceanMenu["Aimbot"].Roll_Untrusted_Pitch, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Aimbot" and ui.get(OceanMenu["Aimbot"].Enable) and ui.get(OceanMenu["Aimbot"].Roll_Enable) and table_contains(ui.get(OceanMenu["Aimbot"].Roll_Overrides), "Resolve Roll"))
    --AnitAim
    ui.set_visible(OceanMenu["AntiAim"].Enable, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim")
    ui.set_visible(OceanMenu["AntiAim"].Inverter, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].Enable))
    ui.set_visible(OceanMenu["AntiAim"].Freestand, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].Enable) and table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Freestanding"))
    ui.set_visible(OceanMenu["AntiAim"].AtTarget, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].Enable) and table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Yaw: At Targets"))
    ui.set_visible(OceanMenu["AntiAim"].PitchKey, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].Enable) and table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Pitch-Down \aCDCDCDFF(\aD6BE73FFUnsafe\aCDCDCDFF)"))
    ui.set_visible(OceanMenu["AntiAim"].HalfPitchKey, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].Enable) and table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Half-Pitch \aCDCDCDFF(\aD6BE73FFUnsafe\aCDCDCDFF)"))
    ui.set_visible(OceanMenu["AntiAim"].ManualLeft, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].Enable) and table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Manual Yaw \aCDCDCDFF(\aD6BE73FFUnsafe\aCDCDCDFF)"))
    ui.set_visible(OceanMenu["AntiAim"].ManualRight, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].Enable) and table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Manual Yaw \aCDCDCDFF(\aD6BE73FFUnsafe\aCDCDCDFF)"))
    ui.set_visible(OceanMenu["AntiAim"].ManualLeftSlider, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].Enable) and table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Manual Yaw \aCDCDCDFF(\aD6BE73FFUnsafe\aCDCDCDFF)"))
    ui.set_visible(OceanMenu["AntiAim"].ManualRightSlider, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].Enable) and table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Manual Yaw \aCDCDCDFF(\aD6BE73FFUnsafe\aCDCDCDFF)"))
    ui.set_visible(OceanMenu["AntiAim"].Extras, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].Enable))
    ui.set_visible(OceanMenu["AntiAim"].Disablers, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].Enable))
    ui.set_visible(OceanMenu["AntiAim"].States, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].Enable))
    for k,v in pairs(Infos.aa_states) do
        ui.set_visible(OceanMenu["AntiAim"].aa_state[v].BodyYaw, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["AntiAim"].Enable) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].States) == v)
        ui.set_visible(OceanMenu["AntiAim"].aa_state[v].Open, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["AntiAim"].Enable) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].States) == v and ui.get(OceanMenu["AntiAim"].aa_state[v].BodyYaw)=="Freestand")
        ui.set_visible(OceanMenu["AntiAim"].aa_state[v].Reverse, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["AntiAim"].Enable) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].States) == v)
        ui.set_visible(OceanMenu["AntiAim"].aa_state[v].Brute, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["AntiAim"].Enable) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].States) == v)
        ui.set_visible(OceanMenu["AntiAim"].aa_state[v].Roll, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["AntiAim"].Enable) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].States) == v and table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Roll"))
        ui.set_visible(OceanMenu["AntiAim"].aa_state[v].Roll_L, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["AntiAim"].Enable) and ui.get(OceanMenu["AntiAim"].aa_state[v].Roll) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].States) == v and table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Roll") and not ui.get(OceanMenu["Misc"].Untrusted))
        ui.set_visible(OceanMenu["AntiAim"].aa_state[v].Roll_R, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["AntiAim"].Enable) and ui.get(OceanMenu["AntiAim"].aa_state[v].Roll) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].States) == v and table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Roll") and not ui.get(OceanMenu["Misc"].Untrusted))
        ui.set_visible(OceanMenu["AntiAim"].aa_state[v].Untrusted_L, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["AntiAim"].Enable) and ui.get(OceanMenu["AntiAim"].aa_state[v].Roll) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].States) == v and ui.get(OceanMenu["Misc"].Untrusted) and table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Roll"))
        ui.set_visible(OceanMenu["AntiAim"].aa_state[v].Untrusted_R, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["AntiAim"].Enable) and ui.get(OceanMenu["AntiAim"].aa_state[v].Roll) and ui.get(OceanMenu["Main"].TabSelection) == "AntiAim" and ui.get(OceanMenu["AntiAim"].States) == v and ui.get(OceanMenu["Misc"].Untrusted) and table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Roll"))
    end
    --FakeLag
    ui.set_visible(OceanMenu["FakeLag"].Enable, ui.get(OceanMenu["Main"].OceanEnabler))
    ui.set_visible(OceanMenu["FakeLag"].Key, ui.get(OceanMenu["Main"].OceanEnabler))
    ui.set_visible(OceanMenu["FakeLag"].Restrict, ui.get(OceanMenu["Main"].OceanEnabler))
    ui.set_visible(OceanMenu["FakeLag"].States, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["FakeLag"].Enable))
    for e,d in pairs(Infos.fl_states) do
        ui.set_visible(OceanMenu["FakeLag"].fl_state[d].Override, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["FakeLag"].States) == d and ui.get(OceanMenu["FakeLag"].Enable) and not G_Check)
        ui.set_visible(OceanMenu["FakeLag"].fl_state[d].Amount, G_Check and ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["FakeLag"].Enable) and ui.get(OceanMenu["FakeLag"].States) == d and not ui.get(OceanMenu["FakeLag"].fl_state[d].Override) or ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["FakeLag"].Enable) and ui.get(OceanMenu["FakeLag"].States) == d and ui.get(OceanMenu["FakeLag"].fl_state[d].Override) and not G_Check)
        ui.set_visible(OceanMenu["FakeLag"].fl_state[d].Variance, G_Check and ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["FakeLag"].Enable) and ui.get(OceanMenu["FakeLag"].States) == d and not ui.get(OceanMenu["FakeLag"].fl_state[d].Override) or ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["FakeLag"].Enable) and ui.get(OceanMenu["FakeLag"].States) == d and ui.get(OceanMenu["FakeLag"].fl_state[d].Override) and not G_Check)
        ui.set_visible(OceanMenu["FakeLag"].fl_state[d].Limit, G_Check and ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["FakeLag"].Enable) and ui.get(OceanMenu["FakeLag"].States) == d and not ui.get(OceanMenu["FakeLag"].fl_state[d].Override) or ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["FakeLag"].Enable) and ui.get(OceanMenu["FakeLag"].States) == d and ui.get(OceanMenu["FakeLag"].fl_state[d].Override) and not G_Check) 
    end
    --Visuals
    ui.set_visible(OceanMenu["Visuals"].Feature, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals")
    ui.set_visible(OceanMenu["Visuals"].Feature_color, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and not ui.get(OceanMenu["Visuals"].Hide_Settings))
    ui.set_visible(OceanMenu["Visuals"].Feature_color2, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and table_contains(ui.get(OceanMenu["Visuals"].Feature), "AA") and not ui.get(OceanMenu["Visuals"].Hide_Settings) or ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and table_contains(ui.get(OceanMenu["Visuals"].Feature), "FL") and not ui.get(OceanMenu["Visuals"].Hide_Settings))
    ui.set_visible(OceanMenu["Visuals"].Custom_Scope, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals")
    ui.set_visible(OceanMenu["Visuals"].First_Person, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and ui.get(OceanMenu["Visuals"].Custom_Scope) and not ui.get(OceanMenu["Visuals"].Hide_Settings))
    ui.set_visible(OceanMenu["Visuals"].First_Person_Zoom, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and ui.get(OceanMenu["Visuals"].Custom_Scope) and table_contains(ui.get(OceanMenu["Visuals"].First_Person), "Custom Scope Zoom") and not ui.get(OceanMenu["Visuals"].Hide_Settings))
    ui.set_visible(OceanMenu["Visuals"].Third_Person, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and ui.get(OceanMenu["Visuals"].Custom_Scope) and not ui.get(OceanMenu["Visuals"].Hide_Settings))
    ui.set_visible(OceanMenu["Visuals"].Third_Person_Zoom, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and ui.get(OceanMenu["Visuals"].Custom_Scope) and table_contains(ui.get(OceanMenu["Visuals"].Third_Person), "Custom Scope Zoom") and not ui.get(OceanMenu["Visuals"].Hide_Settings))
    ui.set_visible(OceanMenu["Visuals"].Crosshair_Indicator, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals")
    ui.set_visible(OceanMenu["Visuals"].Crosshair_Indicator_color, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and ui.get(OceanMenu["Visuals"].Crosshair_Indicator) and not ui.get(OceanMenu["Visuals"].Hide_Settings))
    ui.set_visible(OceanMenu["Visuals"].Crosshair_Indicator_color1, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and ui.get(OceanMenu["Visuals"].Crosshair_Indicator) and not ui.get(OceanMenu["Visuals"].Hide_Settings))
    ui.set_visible(OceanMenu["Visuals"].Crosshair_Indicator_select, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and ui.get(OceanMenu["Visuals"].Crosshair_Indicator) and not ui.get(OceanMenu["Visuals"].Hide_Settings))
    ui.set_visible(OceanMenu["Visuals"].Body_Yaw_indicator, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals")
    ui.set_visible(OceanMenu["Visuals"].Body_Yaw_indicator_color, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and ui.get(OceanMenu["Visuals"].Body_Yaw_indicator) and not ui.get(OceanMenu["Visuals"].Hide_Settings))
    ui.set_visible(OceanMenu["Visuals"].Body_Yaw_indicator_selections, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and ui.get(OceanMenu["Visuals"].Body_Yaw_indicator) and not ui.get(OceanMenu["Visuals"].Hide_Settings))
    ui.set_visible(OceanMenu["Visuals"].Body_Yaw_indicator_Desync, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and ui.get(OceanMenu["Visuals"].Body_Yaw_indicator) and not ui.get(OceanMenu["Visuals"].Hide_Settings))
    ui.set_visible(OceanMenu["Visuals"].Body_Yaw_indicator_Invert, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and ui.get(OceanMenu["Visuals"].Body_Yaw_indicator) and not ui.get(OceanMenu["Visuals"].Hide_Settings))
    ui.set_visible(OceanMenu["Visuals"].Watermark, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals")
    ui.set_visible(OceanMenu["Visuals"].Watermark_select, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and ui.get(OceanMenu["Visuals"].Watermark) and not ui.get(OceanMenu["Visuals"].Hide_Settings))
    ui.set_visible(OceanMenu["Visuals"].Watermark_color, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and ui.get(OceanMenu["Visuals"].Watermark) and not ui.get(OceanMenu["Visuals"].Hide_Settings))
    ui.set_visible(OceanMenu["Visuals"].LynxHitprediction, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals")
    ui.set_visible(OceanMenu["Visuals"].LynxHitprediction_Selection, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and ui.get(OceanMenu["Visuals"].LynxHitprediction) and not ui.get(OceanMenu["Visuals"].Hide_Settings))
    ui.set_visible(OceanMenu["Visuals"].LynxHitprediction_color, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and ui.get(OceanMenu["Visuals"].LynxHitprediction) and not ui.get(OceanMenu["Visuals"].Hide_Settings))
    ui.set_visible(OceanMenu["Visuals"].LynxHitprediction_color2, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals" and ui.get(OceanMenu["Visuals"].LynxHitprediction) and not ui.get(OceanMenu["Visuals"].Hide_Settings))
    ui.set_visible(OceanMenu["Visuals"].Hide_Settings, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Visuals")
    --Misc
    ui.set_visible(OceanMenu["Misc"].EventLogs, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Misc")
    ui.set_visible(OceanMenu["Misc"].EventLogs_Output, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Misc" and ui.get(OceanMenu["Misc"].EventLogs))
    ui.set_visible(OceanMenu["Misc"].Shared_Feature, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Misc")
    ui.set_visible(OceanMenu["Misc"].Untrusted, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Misc")
    ui.set_visible(OceanMenu["Misc"].Clantag, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Misc")
    ui.set_visible(OceanMenu["Misc"].NameSpam, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Main"].TabSelection) == "Misc")
    --Other
    ui.set_visible(OceanMenu["Other"].Slowwalk, ui.get(OceanMenu["Main"].OceanEnabler))
    ui.set_visible(OceanMenu["Other"].Slowwalk_Key, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Other"].Slowwalk))
    ui.set_visible(OceanMenu["Other"].Leg_movement, ui.get(OceanMenu["Main"].OceanEnabler))
    ui.set_visible(OceanMenu["Other"].Hideshots, ui.get(OceanMenu["Main"].OceanEnabler))
    ui.set_visible(OceanMenu["Other"].Hideshots_Key, ui.get(OceanMenu["Main"].OceanEnabler) and ui.get(OceanMenu["Other"].Hideshots))

    for i, n in pairs(ElementsToHide.Anti_Aimbot_Angles) do 
        ui.set_visible(n, not ui.get(OceanMenu["Main"].OceanEnabler))
    end
    for g, u in pairs(ElementsToHide.Fake_Lag) do 
        ui.set_visible(u, not ui.get(OceanMenu["Main"].OceanEnabler))
    end
    for r, h in pairs(ElementsToHide.Other) do 
        ui.set_visible(h, not ui.get(OceanMenu["Main"].OceanEnabler))
    end
end

--Math Shit
local libary = {}
libary.pi = 3.14159265358979323846

libary.d2r = function(value)
    return value * (libary.pi / 180)
end

libary.vectorangle = function(x,y,z)
    local fwd_x, fwd_y, fwd_z
    local sp, sy, cp, cy

    sy = math.sin(libary.d2r(y))
    cy = math.cos(libary.d2r(y))
    sp = math.sin(libary.d2r(x))
    cp = math.cos(libary.d2r(x))
    fwd_x = cp * cy
    fwd_y = cp * sy
    fwd_z = -sp
    return fwd_x, fwd_y, fwd_z
end

libary.multiplyvalues = function(x,y,z,val)
    x = x * val y = y * val z = z * val
    return x, y, z
end

--Checks

function is_freezetime()
    return entity.get_prop(entity.get_game_rules(), "m_bFreezePeriod") == 1
end

-- Functions 

--Clantag

local clantag = {
    Clantag1 = {
    "🫷",
    "🫷", 
    "🫷O",
    "🫷Oc", 
    "🫷Oce",
    "🫷Ocea", 
    "🫷Ocean",
    "🫷Ocean.", 
    "🫷Ocean.T",
    "🫷Ocean.Te", 
    "🫷Ocean.Tec",
    "🫷Ocean.Tech", 
    "🫷Ocean.Tech",
    "🫷Ocean.Tech", 
    "🫷Ocean.Tech", 
    "🫷Ocean.Tech",
    "🫷Ocean.Tech", 
    "🫷cean.Tech",
    "🫷ean.Tech", 
    "🫷an.Tech",
    "🫷n.Tech", 
    "🫷.Tech",
    "🫷Tech", 
    "🫷ech",
    "🫷ch", 
    "🫷h",
    "🫷",
    "🫷",
    },
    Clantag2 = {
        "",
        "", 
        "O",
        "Oc", 
        "Oce",
        "Ocea", 
        "Ocean",
        "Ocean.", 
        "Ocean.T",
        "Ocean.Te", 
        "Ocean.Tec",
        "Ocean.Tech", 
        "Ocean.Tech",
        "Ocean.Tech", 
        "Ocean.Tech", 
        "Ocean.Tech",
        "Ocean.Tech", 
        "cean.Tech",
        "ean.Tech", 
        "an.Tech",
        "n.Tech", 
        ".Tech",
        "Tech", 
        "ech",
        "ch", 
        "h",
        "",
        "",
    },
    Clantag3 = {
        "Ocean.Tech", 
        "Ocean.Tech", 
    },
    Clantag4 = {
        "🫷Ocean.Tech",  
        "🫷Ocean.Tech", 
    },
    timer = 0,
    reset = true
}

function containsSymbol(str, symbol)
    local symbolBytes = {symbol:byte(1, -1)}
    local symbolLength = #symbolBytes

    for i = 1, #str do
        local char = str:byte(i, i + symbolLength - 1)
        if char == symbolBytes[1] then
            local match = true
            for j = 2, symbolLength do
                if str:byte(i + j - 1) ~= symbolBytes[j] then
                    match = false
                    break
                end
            end
            if match then
                return true
            end
        end
    end

    return false
end


local Cache = {

    Local_Detected_Side = "",
    Desync = 0,
    AA_Brute = false,
    Is_Valve_Server = 0,
    GameRule = ffi.cast("intptr_t**", ffi.cast("intptr_t", client.find_signature("client.dll", "\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1")) + 2)[0],
    EnemyWallSide = "",
    EnemyLastWallSide = "",
    EnemyDesyncSide = "",
    EnemyDesyncAmount = "",
    EnemyLBYAmount = "",
    EnemyState = "",
    RollToResolve = 0,
    DesyncToResolve = 0,
    brutestate = false,
    Shot_Hitbox = "",
    Shot_TargetName = "",
    Shot_Hitchance = "",
    Shot_Backtrack = "",
    Shot_Damage = "",
    chokedcmds = 0,
    Scope_spacer = 28,
    Render_Minus0 = 0,
    Render_Minus9 = 9,
    Render_Minus10 = 10,
    Pitchresolver = "",
    desync_deg = 0,
    ManualAA = 0,
    Input = 0, 
    RagebotValues = {
        OldBacktrack = "",
        OldDelay = "",
        OldMulti = "",
        hasInfos = false,
    },

}


--AIMBOT
--NEEDED INFOS

local hitbox_e ={
	head = 0,
	pelvis = 2,
	body = 3,
	thorax = 4,
	chest = 5,
	left_thigh = 7,
	right_thigh = 8,
	left_foot = 11,
	right_foot = 12,
	left_hand = 13,
	right_hand = 14,
	left_upper_arm = 15,
	left_forearm = 16,
	right_upper_arm = 17,
	right_forearm = 18
}

local Aimbot_INFO = {
    DYNAMIC_FOV_DISTANCE_SCALE = 4000.0,
    DYNAMIC_FOV_UPDATE_INTERVAL = 4,
    DYNAMIC_FOV_MIN_DISTANCE = 1500.0,
    DYNAMIC_FOV_MAX_DISTANCE = 100.0,
    SMOKE_HITBOXES = { hitbox_e.head, hitbox_e.left_foot, hitbox_e.right_foot, hitbox_e.left_hand, hitbox_e.right_hand },
    SMOKE_PERSISTANCE_TIMER = 17.0,
    g_anUserWhitelisted = {},
    VISIBILITY_SCALE = 30.0,
    g_flFlashDurationCache = 0.0,
    g_flLastFlashUpdate = 0.0,
    g_pfnLineGoesThroughSmoke = ffi.cast(ffi.typeof("bool(__cdecl*)(float flFromX, float flFromY, float flFromZ, float flToX, float flToY, float flToZ)"), client.find_signature("client.dll", "\x55\x8B\xEC\x83\xEC\x08\x8B\x15\xCC\xCC\xCC\xCC\x0F") or error("client.dll!::LineGoesThroughSmoke could not be found. Signature is outdated.")),
}

local VISIBILITY_DIRECTIONS =
{
	{ 0.0, 0.0 },
	{ Aimbot_INFO.VISIBILITY_SCALE, 0.0 },
	{ -Aimbot_INFO.VISIBILITY_SCALE, 0.0 },
	{ 0.0, Aimbot_INFO.VISIBILITY_SCALE },
	{ 0.0, -Aimbot_INFO.VISIBILITY_SCALE }
}


--NEEDED FUNCTIONS
function time_to_ticks(time)
	return math.floor(time / globals.tickinterval() + .5)
end

function distance_to_dynamic_fov(min, max, dist)
	if dist >= Aimbot_INFO.DYNAMIC_FOV_MIN_DISTANCE then
		return min
	elseif dist <= Aimbot_INFO.DYNAMIC_FOV_MAX_DISTANCE then
		return max
	end
	
	return math.min(max, math.max(min, Aimbot_INFO.DYNAMIC_FOV_DISTANCE_SCALE / dist))
end

function iter_enemies(lambda)
	local anEnemies = entity.get_players(true)

	for i = 1, #anEnemies do
		lambda(anEnemies[i])
	end
end

function is_valid_target(ent)
	return ent ~= nil and not entity.is_dormant(ent) and entity.is_alive(ent)
end

function get_closest_enemy_distance()
	nLocalPlayer = entity.get_local_player()
	flaLocalHead = vector(client.eye_position())
	flMinimumDistance = Aimbot_INFO.DYNAMIC_FOV_DISTANCE_SCALE

	iter_enemies(function(target)
		flaEnemyHead = vector(entity.hitbox_position(target, hitbox_e.head))
		flDistance = flaLocalHead:dist(flaEnemyHead)
		
		if flDistance < flMinimumDistance then
			flMinimumDistance = flDistance
		end
	end)
	
	return flMinimumDistance
end

function is_rage_aimbot_running() 
	return ui.get(OceanMenu["Aimbot"].Autofire) and ui.get(OceanMenu["Aimbot"].Autofire_hotkey)
end

function get_screen_center()
	width, height = client.screen_size()

	return { width / 2, height / 2 }
end

function get_distance_2d(pos1, pos2)
	return math.sqrt(math.pow((pos1[1] - pos2[1]), 2) + math.pow((pos1[2] - pos2[2]), 2))
end

function get_closest_target_crosshair()
	anCenter = get.screen_center()
	nTarget = nil
	flClosest = 8192.0

	iter_enemies(function(target)
		flX, flY, flZ = entity.hitbox_position(target, hitbox_e.head)
		nX, nY = renderer.world_to_screen(flX, flY, flZ)

		-- Not on screen..
		if nX == nil then
			return
		end

		flDistance = get_distance_2d(anCenter, { nX, nY })

		if flDistance < flClosest then
			flClosest = flDistance
			nTarget = target
		end
	end)

	return nTarget
end

function update_ignore_behind_smokes()
	if ui.get(OceanMenu["Aimbot"].Autofire) and ui.get(OceanMenu["Aimbot"].Autofire_hotkey) then
		return
	end
    bSmokeExists = false
	anSmokeGrenadeProjectiles = entity.get_all("CSmokeGrenadeProjectile")
	nTickCount = globals.tickcount()
	flTickInterval = globals.tickinterval()

	for i = 1, #anSmokeGrenadeProjectiles do
		if entity.get_prop(anSmokeGrenadeProjectiles[i], "m_bDidSmokeEffect") == 1 and nTickCount < entity.get_prop(anSmokeGrenadeProjectiles[i], "m_nSmokeEffectTickBegin") + Aimbot_INFO.SMOKE_PERSISTANCE_TIMER / flTickInterval then
			bSmokeExists = true
		end
	end

	if not bSmokeExists then
		return
	end

	flLocalX, flLocalY, flLocalZ = client.eye_position()

	iter_enemies(function(target)
		-- Don't run the code on anyone if enemy is already whitelisted..
		if Aimbot_INFO.g_anUserWhitelisted[target] then
			return
		end

		bWhitelist = true

		for i = 1, #Aimbot_INFO.SMOKE_HITBOXES do
			-- If we already know that the target is visible, there is no reason to run more checks. Break out of the loop, and move on to the next target
			if not bWhitelist then
				break
			end

			-- "multipoints" XD. It works though! :)
			local flaEnemyHitbox = vector(entity.hitbox_position(target, Aimbot_INFO.SMOKE_HITBOXES[i]))

			for j = 1, #VISIBILITY_DIRECTIONS do
				if not Aimbot_INFO.g_pfnLineGoesThroughSmoke(flLocalX, flLocalY, flLocalZ, flaEnemyHitbox.x + VISIBILITY_DIRECTIONS[j][1], flaEnemyHitbox.y + VISIBILITY_DIRECTIONS[j][2], flaEnemyHitbox.z) then
					bWhitelist = false
	
					break
				end
			end
		end

		if bWhitelist then
			Aimbot_INFO.g_anUserWhitelisted[target] = true
		end
	end)
end

function get_weapon_definition_index(ent)
	nWeapon = entity.get_player_weapon(ent)

	if nWeapon ~= nil then
		return entity.get_prop(nWeapon, "m_iItemDefinitionIndex")
	end

	return nil
end

function update_honor_flashbangs()
	if not ui.get(OceanMenu["Aimbot"].Autofire) and ui.get(OceanMenu["Aimbot"].Autofire_hotkey) or ui.get(OceanMenu["Aimbot"].Autopenetration) and ui.get(OceanMenu["Aimbot"].Autopenetration_hotkey) then
		return
	end

	nLocalPlayer = entity.get_local_player()
	nWeapon = get_weapon_definition_index(nLocalPlayer)
	cPrefix = string.sub(csgo_weapon[nWeapon].type, 1, 1)
	
	if cPrefix ~= 'p' and -- pistol
		cPrefix ~= 's' and -- smg, shotgun, sniperrifle
		cPrefix ~= 'r' and -- rifle
		cPrefix ~= 'm' then -- machinegun
		return
	end

	flFlashDuration = entity.get_prop(nLocalPlayer, "m_flFlashDuration")
	flBlindnessThreshold = 44 * 0.05
	flCurtime = globals.curtime()

	if flFlashDuration > 0.0 then
		if Aimbot_INFO.g_flFlashDurationCache == 0.0 then
			Aimbot_INFO.g_flLastFlashUpdate = flCurtime
		end

		if flCurtime - Aimbot_INFO.g_flLastFlashUpdate < flFlashDuration - flBlindnessThreshold then
			iter_enemies(function(target)
				Aimbot_INFO.g_anUserWhitelisted[target] = true
			end)
		end
	end

	g_flFlashDurationCache = flFlashDuration
end

function update_whitelist()
	iter_enemies(function(target)
		plist.set(target, "Add to whitelist", Aimbot_INFO.g_anUserWhitelisted[target])
	end)

	Aimbot_INFO.g_anUserWhitelisted = {}
end

function update_fov()

    if not is_rage_aimbot_running() and globals.tickcount() % Aimbot_INFO.DYNAMIC_FOV_UPDATE_INTERVAL ~= 0 then
		return
	end

	local nMinimumFOV = ui.get(OceanMenu["Aimbot"].Min_Fov)
	local nMaximumFOV = ui.get(OceanMenu["Aimbot"].Max_Fov)
	local nDesiredFOV = nMinimumFOV

	-- Don't run distance checks if minimum is maximum. Spare CPU cycles ma'am?
	if nMinimumFOV ~= nMaximumFOV then
		nDesiredFOV = distance_to_dynamic_fov(nMinimumFOV, nMaximumFOV, get_closest_enemy_distance())
	end
    
    if ui.get(OceanMenu["Aimbot"].DynamicFOV) then
	    ui.set(Menu_Reference.Fov, nDesiredFOV)
    else
        return
    end

end

function ocean_prio()
    if not ui.get(OceanMenu["Aimbot"].Prio_System) then return end
    me = entity.get_local_player()
    for i, players in pairs(entity.get_players(true)) do
        plist.set(players, "High priority",false)
        weapon = entity.get_player_weapon(players)
        if weapon ~= nil then
            plist.set(players, "High priority", entity.get_classname(weapon) == "CWeaponAWP")
        end
        for i = 64 , 0 , -1 do
            idx = entity.get_prop(entity.get_prop(players, "m_hMyWeapons", i), "m_iItemDefinitionIndex")
            if idx == 49 then
                plist.set(players, "High priority", true)
            end
        end
        if entity.get_prop(players, "m_hCarriedHostage") == nil then return end
        plist.set(players, "High priority", true)
    end
end

function prio_flag()
    if not ui.get(OceanMenu["Aimbot"].Prio_System) then return end
    local r,g,b,a = ui.get(OceanMenu["Aimbot"].Prio_System_color)
    for i, players in pairs(entity.get_players(true)) do
        local bounding_box = {entity.get_bounding_box(players)}
        if #bounding_box == 5 and bounding_box[5] ~= 0 then
            local center = bounding_box[1] + (bounding_box[3] - bounding_box[1]) / 2
            if plist.get(players, "High priority") then
                renderer.text(center, bounding_box[2]- 18,  r, g, b, a, "dbc", 1000, "High priority")
            end
            --renderer.text(center, bounding_box[2] - 18, 255, 255, 255, 255, "dbc", 100, "LEFT")
        end

    end
end

function RagebotBinds()
    local_player = entity.get_local_player()
    if local_player == nil then return end
    if not ui.get(OceanMenu["Main"].OceanEnabler) then return end

    if ui.get(OceanMenu["Aimbot"].Autofire) and ui.get(OceanMenu["Aimbot"].Autofire_hotkey) then
        ui.set(Menu_Reference.Rage_Enable[1], true)
        ui.set(Menu_Reference.Rage_Enable[2], "Always on")
        ui.set(Menu_Reference.AutoFire[1], true)
    else
        ui.set(Menu_Reference.Rage_Enable[1], false)
        ui.set(Menu_Reference.Rage_Enable[2], "On hotkey")
        ui.set(Menu_Reference.AutoFire[1], false)
    end

    if ui.get(OceanMenu["Aimbot"].Autopenetration) and ui.get(OceanMenu["Aimbot"].Autopenetration_hotkey) then
        ui.set(Menu_Reference.AutoPen[1], true)
    else
        ui.set(Menu_Reference.AutoPen[1], false)
    end
end

--Resolver

function normalize(slot0)
	while slot0 > 180 do
		slot0 = slot0 - 360
	end

	while slot0 < -180 do
		slot0 = slot0 + 360
	end

	return slot0
end

function EnemySideDetection(player)
    if player == nil then return end
    eyepos_x, eyepos_y, eyepos_z = entity.get_prop(player, "m_vecAbsOrigin")
    offsetx, offsety, offsetz = entity.get_prop(player, "m_vecViewOffset")
    eyepos_z = eyepos_z + offsetz
    Lowestfrac = 1
    Dir = false
    Desync = entity.get_prop(player, "m_flPoseParameter", 11) * 120 - 60
    Cache.EnemyLBYAmount = -math.min(60, math.max(-60, normalize(entity.get_prop(player, "m_angEyeAngles[1]") - entity.get_prop(player, "m_flLowerBodyYawTarget"))))
    speed = math.sqrt(math.pow(entity.get_prop(player, "m_vecVelocity[0]"), 2) + math.pow(entity.get_prop(player, "m_vecVelocity[1]"), 2))
    duck = entity.get_prop(player, "m_flDuckAmount")
    on_ground = bit.band(entity.get_prop(player, "m_fFlags"), 1)
    if Desync > 3 then
        Cache.EnemyDesyncSide = "Left"
        Cache.EnemyDesyncAmount = Desync
    elseif Desync < -3 then
        Cache.EnemyDesyncSide = "Right"
        Cache.EnemyDesyncAmount = Desync
    else
        Cache.EnemyDesyncSide = "None"
        Cache.EnemyDesyncAmount = 0
    end
    Ppitch, Pyaw = entity.get_prop(player, "m_angRotation")
    FractionLeft, FractionRight = 0, 0
    AmountLeft, AmountRight = 0, 0
    for i = -70, 70, 5 do
        if i ~= 0 then
            fwdx, fwdy, fwdz = libary.vectorangle(0, Pyaw + i + Desync, 0)
            ffwx, ffwdy, ffwdz = libary.multiplyvalues(fwdx, fwdy, fwdz, 70)
            
            Fraction = client.trace_line(player, eyepos_x, eyepos_y, eyepos_z, eyepos_x + ffwx, eyepos_y + ffwdy, eyepos_z + ffwdz)

            if i > 0 then
                FractionLeft = FractionLeft + Fraction
                AmountLeft = AmountLeft + 1
            else
                FractionRight = FractionRight + Fraction
                AmountRight = AmountRight + 1
            end

        end

    end

    Averageleft, Averageright = FractionLeft / AmountLeft, FractionRight / AmountRight

    if Averageleft < Averageright then
        Cache.EnemyWallSide = "Right"
        Cache.EnemyLastWallSide = "Right"
    elseif Averageleft > Averageright then
        Cache.EnemyWallSide = "Left"
        Cache.EnemyLastWallSide = "Left"
    else
        Cache.EnemyWallSide = "None"
    end


    if on_ground==0 then
        Cache.EnemyState = "air"
    elseif speed < 10 and duck==1 and on_ground==1 then
        Cache.EnemyState = "duck"
    elseif speed > 25 and duck==1 and on_ground==1 then
        Cache.EnemyState = "duckmove"
    elseif  speed > 15 and speed < 80 then
        Cache.EnemyState = "slow"
    elseif speed > 120 and duck==0 then
        Cache.EnemyState = "move"
    elseif speed < 10 and on_ground==1 then
        Cache.EnemyState = "stand"
    end

    -- renderer.text(2, 502, 255, 255, 255, 255, nil, 1000, "Resolver Threat: "..entity.get_player_name(player))
    -- renderer.text(2, 513, 255, 255, 255, 255, nil, 1000, "Threat State: "..Cache.EnemyState)
    -- renderer.text(2, 524, 255, 255, 255, 255, nil, 1000, "Threat Detected Side: "..Cache.EnemyWallSide)
    -- renderer.text(2, 535, 255, 255, 255, 255, nil, 1000, "Threat Last Detected Side: "..Cache.EnemyLastWallSide)
    -- renderer.text(2, 546, 255, 255, 255, 255, nil, 1000, "Threat LBY Amount: "..Cache.EnemyLBYAmount)
    -- renderer.text(2, 557, 255, 255, 255, 255, nil, 1000, "Threat Desync Amount: "..Cache.EnemyDesyncAmount)
    -- renderer.text(2, 568, 255, 255, 255, 255, nil, 1000, "Threat Desync Side: "..Cache.EnemyDesyncSide)
    -- renderer.text(2, 579, 255, 255, 255, 255, nil, 1000, "Threat Current Roll Value: "..Cache.RollToResolve)
    -- renderer.text(2, 590, 255, 255, 255, 255, nil, 1000, "Threat Pitch Resolver: ")
    -- renderer.text(110, 590, 255, 255, 255, 255, nil, 1000, Cache.Pitchresolver)
    -- renderer.text(2, 601, 255, 255, 255, 255, nil, 1000, "Threat Bruteforce State: ")
    -- renderer.text(122, 601, 255, 255, 255, 255, nil, 1000, Cache.brutestate)
    -- renderer.text(2, 612, 255, 255, 255, 255, nil, 1000, "Threat Current Desync Value: "..Cache.DesyncToResolve)
end

function Roll_Resolver()
    if not ui.get(OceanMenu["Main"].OceanEnabler) then return end
    if not ui.get(OceanMenu["Aimbot"].Roll_Enable) then return end
    RO = table_contains(ui.get(OceanMenu["Aimbot"].Roll_Overrides), "Resolve Roll")
    can_resolve = true
    if RO then
        if Cache.EnemyState == "stand" then
            if Cache.EnemyWallSide == "Left" then
                if Cache.brutestate == false then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L)
                elseif Cache.brutestate == true then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)
                end
            elseif Cache.EnemyWallSide == "Right" then
                if Cache.brutestate == false then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)
                elseif Cache.brutestate == true then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L)
                end
            elseif Cache.EnemyWallSide == "None" then
                if Cache.EnemyLastWallSide == "Left" then
                    if Cache.brutestate == false then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L)
                    elseif Cache.brutestate == true then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)
                    end
                elseif Cache.EnemyLastWallSide == "Right" then
                    if Cache.brutestate == false then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)
                    elseif Cache.brutestate == true then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L)
                    end
                else
                    if Cache.brutestate == false then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L)
                    elseif Cache.brutestate == true then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)
                    end
                end
            end
        elseif Cache.EnemyState == "duck" then
            if Cache.EnemyWallSide == "Left" then
                if Cache.brutestate == false then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L)
                elseif Cache.brutestate == true then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)
                end
            elseif Cache.EnemyWallSide == "Right" then
                if Cache.brutestate == false then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)
                elseif Cache.brutestate == true then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L)
                end
            elseif Cache.EnemyWallSide == "None" then
                if Cache.EnemyLastWallSide == "Left" then
                    if Cache.brutestate == false then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L)
                    elseif Cache.brutestate == true then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)
                    end
                elseif Cache.EnemyLastWallSide == "Right" then
                    if Cache.brutestate == false then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)
                    elseif Cache.brutestate == true then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L)
                    end
                else
                    if Cache.brutestate == false then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L)
                    elseif Cache.brutestate == true then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)
                    end
                end
            end
        elseif Cache.EnemyState == "duckmove" then
            if Cache.EnemyWallSide == "Left" then
                if Cache.brutestate == false then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L) / 2
                elseif Cache.brutestate == true then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R) / 2
                end
            elseif Cache.EnemyWallSide == "Right" then
                if Cache.brutestate == false then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R) / 2
                elseif Cache.brutestate == true then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L) / 2
                end
            elseif Cache.EnemyWallSide == "None" then
                if Cache.EnemyLastWallSide == "Left" then
                    if Cache.brutestate == false then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L) / 2
                    elseif Cache.brutestate == true then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R) / 2 
                    end
                elseif Cache.EnemyLastWallSide == "Right" then
                    if Cache.brutestate == false then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R) / 2
                    elseif Cache.brutestate == true then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L) / 2
                    end
                else
                    if Cache.brutestate == false then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L)
                    elseif Cache.brutestate == true then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)
                    end
                end
            end
        elseif Cache.EnemyState == "slow" then
            if Cache.EnemyWallSide == "Left" then
                if Cache.brutestate == false then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L) / 2
                elseif Cache.brutestate == true then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R) / 2
                end
            elseif Cache.EnemyWallSide == "Right" then
                if Cache.brutestate == false then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R) / 2
                elseif Cache.brutestate == true then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L) / 2
                end
            elseif Cache.EnemyWallSide == "None" then
                if Cache.EnemyLastWallSide == "Left" then
                    if Cache.brutestate == false then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L) / 2
                    elseif Cache.brutestate == true then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R) / 2
                    end
                elseif Cache.EnemyLastWallSide == "Right" then
                    if Cache.brutestate == false then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R) / 2
                    elseif Cache.brutestate == true then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L) / 2
                    end
                else
                    if Cache.brutestate == false then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L)
                    elseif Cache.brutestate == true then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)
                    end
                end
            end
        elseif Cache.EnemyState == "move" then
            if Cache.EnemyWallSide == "Left" then
                if Cache.brutestate == false then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L) / 2
                elseif Cache.brutestate == true then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)/ 2
                end
            elseif Cache.EnemyWallSide == "Right" then
                if Cache.brutestate == false then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R) / 2
                elseif Cache.brutestate == true then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L) / 2
                end
            elseif Cache.EnemyWallSide == "None" then
                if Cache.EnemyLastWallSide == "Left" then
                    if Cache.brutestate == false then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L) / 2
                    elseif Cache.brutestate == true then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)/ 2
                    end
                elseif Cache.EnemyLastWallSide == "Right" then
                    if Cache.brutestate == false then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R) / 2
                    elseif Cache.brutestate == true then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L) / 2
                    end
                else
                    if Cache.brutestate == false then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L)
                    elseif Cache.brutestate == true then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)
                    end
                end
            end
        elseif Cache.EnemyState == "air" then
            if Cache.EnemyWallSide == "Left" then
                if Cache.brutestate == false then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L)
                elseif Cache.brutestate == true then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)
                end
            elseif Cache.EnemyWallSide == "Right" then
                if Cache.brutestate == false then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)
                elseif Cache.brutestate == true then
                    Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L)
                end
            elseif Cache.EnemyWallSide == "None" then
                if Cache.EnemyLastWallSide == "Left" then
                    if Cache.brutestate == false then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L)
                    elseif Cache.brutestate == true then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)
                    end
                elseif Cache.EnemyLastWallSide == "Right" then
                    if Cache.brutestate == false then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)
                    elseif Cache.brutestate == true then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L)
                    end
                else
                    if Cache.brutestate == false then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_L)
                    elseif Cache.brutestate == true then
                        Cache.RollToResolve = ui.get(OceanMenu["Aimbot"].Roll_Override_R)
                    end
                end
            end
        end
    else
        Cache.RollToResolve = 0
        can_resolve = false
    end

    --Resolve Part
    enemies = entity.get_players(true)
    for i=1, #enemies do
		entindex = enemies[i]
        _ , yaw = entity.get_prop ( entindex, 'm_angRotation' )
        pitch = 89 * ( ( 2 * entity.get_prop ( entindex, 'm_flPoseParameter', 12 ) ) - 1 )
        speed = math.sqrt(math.pow(entity.get_prop(entindex, "m_vecVelocity[0]"), 2) + math.pow(entity.get_prop(entindex, "m_vecVelocity[1]"), 2))

        if table_contains(ui.get(OceanMenu["Aimbot"].Roll_Overrides), "Half-Pitch Resolver") and pitch > 30 and speed < 80 then
            Cache.Pitchresolver = true

            if Cache.EnemyWallSide == "Left" then
                if Cache.EnemyState == "slow" then
                    entity.set_prop ( entindex, 'm_angEyeAngles', pitch, yaw, Cache.brutestate and 96 or -96 )
                    Cache.RollToResolve = Cache.brutestate and 96 or -96
                elseif Cache.EnemyState == "duck" or Cache.EnemyState == "duckmove" then
                    entity.set_prop ( entindex, 'm_angEyeAngles', pitch, yaw, Cache.brutestate and -90 or 96 )
                    Cache.RollToResolve = Cache.brutestate and -90 or 96 
                end
                elseif Cache.EnemyWallSide == "Right" then
                if Cache.EnemyState == "slow" then
                    entity.set_prop ( entindex, 'm_angEyeAngles', pitch, yaw, Cache.brutestate and 96 or -96 )
                    Cache.RollToResolve = Cache.brutestate and 96 or -96
                elseif Cache.EnemyState == "duck" or Cache.EnemyState == "duckmove" then
                    entity.set_prop ( entindex, 'm_angEyeAngles', pitch, yaw, Cache.brutestate and 96 or -90 )
                    Cache.RollToResolve = Cache.brutestate and 96 or -90
                end
                elseif Cache.EnemyWallSide == "None" then
                if Cache.EnemyState == "slow" then
                    entity.set_prop ( entindex, 'm_angEyeAngles', pitch, yaw, Cache.brutestate and 96 or -96 )
                    Cache.RollToResolve = Cache.brutestate and 96 or -96
                elseif Cache.EnemyState == "duck" or Cache.EnemyState == "duckmove" then
                    entity.set_prop ( entindex, 'm_angEyeAngles', pitch, yaw, Cache.brutestate and 96 or -90 )
                    Cache.RollToResolve = Cache.brutestate and 96 or -90
                end
            end

        else
            if can_resolve then
                Cache.Pitchresolver = false
                entity.set_prop ( entindex, 'm_angEyeAngles', pitch, yaw, Cache.RollToResolve )
            end
        end
    end

end

function makeNegative(value)
    return -value
end

function makePositive(value)
    return math.abs(value)
end

function Desync_Resolver()
    if not ui.get(OceanMenu["Main"].OceanEnabler) then return end
    if not ui.get(OceanMenu["Aimbot"].Roll_Enable) then return end
    DO = table_contains(ui.get(OceanMenu["Aimbot"].Roll_Overrides), "Resolve Desync")
    Target = client.current_threat()
    if Target == nil then
        return
    end
    client.update_player_list()
    desync_amount = -math.min(60, math.max(-60, normalize(entity.get_prop(Target, "m_angEyeAngles[1]") - entity.get_prop(Target, "m_flLowerBodyYawTarget"))))
    desync_amount_Brute = math.min(60, math.max(-60, normalize(entity.get_prop(Target, "m_angEyeAngles[1]") - entity.get_prop(Target, "m_flLowerBodyYawTarget"))))

    HP_Check = table_contains(ui.get(OceanMenu["Aimbot"].Roll_Overrides), "Half-Pitch Resolver")
    ESR_Check = table_contains(ui.get(OceanMenu["Aimbot"].Roll_Overrides), "Experimental Slowwalk Resolver")
    EIAR_Check = table_contains(ui.get(OceanMenu["Aimbot"].Roll_Overrides), "Experimental In-Air Resolver")
    if EIAR_Check  then
        -- RagebotValues = {
        --     OldBacktrack = "",
        --     OldDelay = "",
        --     OldMulti = "",
        --     hasInfos = false,
        -- },
        if Cache.EnemyState == "air" then
            if not Cache.RagebotValues.hasInfos then
                Cache.RagebotValues.OldBacktrack = ui.get(Menu_Reference.Backtrack)
                Cache.RagebotValues.OldDelay = ui.get(Menu_Reference.DelayShot)
                -- Cache.RagebotValues.OldMulti = ui.get(Menu_Reference.Multipoints)
                Cache.RagebotValues.hasInfos = true
            end
            if Cache.RagebotValues.hasInfos then 
                ui.set(Menu_Reference.DelayShot, true)
                ui.set(Menu_Reference.Backtrack, "Low")
                -- ui.set(Menu_Reference.Multipoints, 35)

            end
        else
            if Cache.RagebotValues.OldBacktrack == "" or Cache.RagebotValues.OldDelay == "" or Cache.RagebotValues.OldMulti == "" then 
                Cache.RagebotValues.OldBacktrack = ui.get(Menu_Reference.Backtrack)
                Cache.RagebotValues.OldDelay = ui.get(Menu_Reference.DelayShot)
                -- Cache.RagebotValues.OldMulti = ui.get(Menu_Reference.Multipoints)
                Cache.RagebotValues.hasInfos = true
            else
                Cache.RagebotValues.hasInfos = false
            end 
            ui.set(Menu_Reference.DelayShot, Cache.RagebotValues.OldDelay)
            -- ui.set(Menu_Reference.Multipoints, Cache.RagebotValues.OldMulti)
            ui.set(Menu_Reference.Backtrack, Cache.RagebotValues.OldBacktrack)
        end
    end

    enemies = entity.get_players(true)
    for i=1, #enemies do
		entindex = enemies[i]
        _ , yaw = entity.get_prop ( entindex, 'm_angRotation' )
        pitch = 89 * ( ( 2 * entity.get_prop ( entindex, 'm_flPoseParameter', 12 ) ) - 1 )
        speedd = math.sqrt(math.pow(entity.get_prop(entindex, "m_vecVelocity[0]"), 2) + math.pow(entity.get_prop(entindex, "m_vecVelocity[1]"), 2))


                    if HP_Check and pitch > 30 and speedd < 80 or ESR_Check and speedd < 80 or HP_Check and ESR_Check and --[[pitch > 30 and]] speedd < 80 or EIAR_Check then
                        if HP_Check and pitch > 30 and speedd < 80 then
                            if Cache.EnemyWallSide == "Left" then
                                if Cache.EnemyState == "slow" then
                                    ui.set(Menu_Reference.ForceBodyYaw, true)
                                    ui.set(Menu_Reference.ForceSlider, Cache.brutestate and -60 or 60)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = Cache.brutestate and -60 or 60
                                elseif Cache.EnemyState == "duck" or Cache.EnemyState == "duckmove" then
                                    ui.set(Menu_Reference.ForceBodyYaw, true)
                                    ui.set(Menu_Reference.ForceSlider, Cache.brutestate and 60 or -60)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = Cache.brutestate and 60 or -60
                                else
                                    ui.set(Menu_Reference.ForceBodyYaw, false)
                                    ui.set(Menu_Reference.ForceSlider, 0)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = 0
                                end
                            elseif Cache.EnemyWallSide == "Right" then
                                if Cache.EnemyState == "slow" then
                                    ui.set(Menu_Reference.ForceBodyYaw, true)
                                    ui.set(Menu_Reference.ForceSlider, Cache.brutestate and 60 or -60)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = Cache.brutestate and 60 or -60
                                elseif Cache.EnemyState == "duck" or Cache.EnemyState == "duckmove" then
                                    ui.set(Menu_Reference.ForceBodyYaw, true)
                                    ui.set(Menu_Reference.ForceSlider, Cache.brutestate and -60 or 60)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = Cache.brutestate and -60 or 60
                                else
                                    ui.set(Menu_Reference.ForceBodyYaw, false)
                                    ui.set(Menu_Reference.ForceSlider, 0)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = 0
                                end
                            elseif Cache.EnemyWallSide == "None" then
                                if Cache.EnemyState == "slow" then
                                    ui.set(Menu_Reference.ForceBodyYaw, true)
                                    ui.set(Menu_Reference.ForceSlider, Cache.brutestate and 60 or -60)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = Cache.brutestate and 60 or -60
                                elseif Cache.EnemyState == "duck" or Cache.EnemyState == "duckmove" then
                                    ui.set(Menu_Reference.ForceBodyYaw, true)
                                    ui.set(Menu_Reference.ForceSlider, Cache.brutestate and -60 or 60)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = Cache.brutestate and -60 or 60
                                else
                                    ui.set(Menu_Reference.ForceBodyYaw, false)
                                    ui.set(Menu_Reference.ForceSlider, 0)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = 0
                                end
                            end
                        end
                        if ESR_Check and speedd < 80 then
                            if Cache.EnemyWallSide == "Left" then
                                if Cache.EnemyState == "slow" then
                                    ui.set(Menu_Reference.ForceBodyYaw, true)
                                    ui.set(Menu_Reference.ForceSlider, Cache.brutestate and -60 or 60)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = Cache.brutestate and -60 or 60
                                else
                                    ui.set(Menu_Reference.ForceBodyYaw, true)
                                    ui.set(Menu_Reference.ForceSlider, 0)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = 0
                                end
                            elseif Cache.EnemyWallSide == "Right" then
                                if Cache.EnemyState == "slow" then
                                    ui.set(Menu_Reference.ForceBodyYaw, true)
                                    ui.set(Menu_Reference.ForceSlider, Cache.brutestate and 60 or -60)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = Cache.brutestate and 60 or -60
                                else
                                    ui.set(Menu_Reference.ForceBodyYaw, true)
                                    ui.set(Menu_Reference.ForceSlider, 0)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = 0
                                end
                            elseif Cache.EnemyWallSide == "None" then
                                if Cache.EnemyState == "slow" then
                                    ui.set(Menu_Reference.ForceBodyYaw, true)
                                    ui.set(Menu_Reference.ForceSlider, Cache.brutestate and 60 or -60)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = Cache.brutestate and 60 or -60
                                else
                                    ui.set(Menu_Reference.ForceBodyYaw, false)
                                    ui.set(Menu_Reference.ForceSlider, 0)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = 0
                                end
                            end
                        end
                        if EIAR_Check then
                            if Cache.EnemyLastWallSide == "Left" then
                                if Cache.EnemyState == "air" then
                                    ui.set(Menu_Reference.ForceBodyYaw, true)
                                    ui.set(Menu_Reference.ForceSlider, Cache.brutestate and -60 or 60)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = Cache.brutestate and -60 or 60
                                else
                                    ui.set(Menu_Reference.ForceBodyYaw, true)
                                    ui.set(Menu_Reference.ForceSlider, 0)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = 0
                                end
                            elseif Cache.EnemyLastWallSide == "Right" then
                                if Cache.EnemyState == "air" then
                                    ui.set(Menu_Reference.ForceBodyYaw, true)
                                    ui.set(Menu_Reference.ForceSlider, Cache.brutestate and 60 or -60)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = Cache.brutestate and 60 or -60
                                else
                                    ui.set(Menu_Reference.ForceBodyYaw, true)
                                    ui.set(Menu_Reference.ForceSlider, 0)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = 0
                                end
                            elseif Cache.EnemyLastWallSide == "None" then
                                if Cache.EnemyState == "air" then
                                    ui.set(Menu_Reference.ForceBodyYaw, true)
                                    ui.set(Menu_Reference.ForceSlider, Cache.brutestate and 60 or -60)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = Cache.brutestate and 60 or -60
                                else
                                    ui.set(Menu_Reference.ForceBodyYaw, false)
                                    ui.set(Menu_Reference.ForceSlider, 0)  
                                    ui.set(Menu_Reference.ApplyToAll, true)
                                    Cache.DesyncToResolve = 0
                                end
                            end
                        end
                        Desync_Can_Off = true
                    elseif table_contains(ui.get(OceanMenu["Aimbot"].Roll_Overrides), "Resolve LBY") then
                        if Cache.EnemyState == "stand" then
                            if Cache.brutestate == false then
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, desync_amount)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = desync_amount
                            elseif Cache.brutestate == true then
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, desync_amount_Brute)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = desync_amount_Brute
                            end
                        elseif Cache.EnemyState == "duck" then
                            if Cache.brutestate == false then
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, desync_amount)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = desync_amount
                            elseif Cache.brutestate == true then
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, desync_amount_Brute)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = desync_amount_Brute
                            end
                        elseif Cache.EnemyState == "duckmove" then
                            if Cache.EnemyWallSide == "Left" then
                                if Cache.brutestate == false then
                                    Cache.desync_deg = -60
                                elseif Cache.brutestate == true then
                                    Cache.desync_deg = 60
                                end
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.desync_deg/2)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.desync_deg/2
                            elseif Cache.EnemyWallSide == "Right" then
                                if Cache.brutestate == false then
                                    Cache.desync_deg = 60
                                elseif Cache.brutestate == true then
                                    Cache.desync_deg = -60
                                end
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.desync_deg/2)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.desync_deg/2
                            elseif Cache.EnemyWallSide == "None" then
                                if last_detected == "Left" then
                                    if Cache.brutestate == false then
                                        Cache.desync_deg = -60
                                    elseif Cache.brutestate == true then
                                        Cache.desync_deg = 60
                                    end
                                elseif last_detected == "Right" then
                                    if Cache.brutestate == false then
                                        Cache.desync_deg = 60
                                    elseif Cache.brutestate == true then
                                        Cache.desync_deg = -60
                                    end
                                end
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.desync_deg / 2)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.desync_deg/2
                            end
                        elseif Cache.EnemyState == "slow" then
                            if Cache.EnemyWallSide == "Left" then
                                if Cache.brutestate == false then
                                    Cache.desync_deg = -60
                                elseif Cache.brutestate == true then
                                    Cache.desync_deg = 60
                                end
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.desync_deg)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.desync_deg
                            elseif Cache.EnemyWallSide == "Right" then
                                if Cache.brutestate == false then
                                    Cache.desync_deg = 60
                                elseif Cache.brutestate == true then
                                    Cache.desync_deg = -60
                                end
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.desync_deg)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.desync_deg
                            elseif Cache.EnemyWallSide == "None" then
                                if last_detected == "Left" then
                                    if Cache.brutestate == false then
                                        Cache.desync_deg = -60
                                    elseif Cache.brutestate == true then
                                        Cache.desync_deg = 60
                                    end
                                elseif last_detected == "Right" then
                                    if Cache.brutestate == false then
                                        Cache.desync_deg = 60
                                    elseif Cache.brutestate == true then
                                        Cache.desync_deg = -60
                                    end
                                end
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.desync_deg)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.desync_deg
                            end
                        elseif Cache.EnemyState == "move" then
                            if Cache.EnemyWallSide == "Left" then
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.desync_deg/2)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.desync_deg/2
                            elseif Cache.EnemyWallSide == "Right" then
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.desync_deg/2)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.desync_deg/2
                            elseif Cache.EnemyWallSide == "None" then
                                if last_detected == "Left" then
                                    if Cache.brutestate == false then
                                        Cache.desync_deg = -56
                                    elseif Cache.brutestate == true then
                                        Cache.desync_deg = 56
                                    end
                                elseif last_detected == "Right" then
                                    if Cache.brutestate == false then
                                        Cache.desync_deg = 56
                                    elseif Cache.brutestate == true then
                                        Cache.desync_deg = -56
                                    end
                                end
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.desync_deg/2)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.desync_deg/2
                            end
                        elseif Cache.EnemyState == "air" then
                            if Cache.EnemyWallSide == "Left" then
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.desync_deg/2)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.desync_deg/2
                            elseif Cache.EnemyWallSide == "Right" then
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.desync_deg/2)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.desync_deg/2
                            elseif Cache.EnemyWallSide == "None" then
                                if last_detected == "Left" then
                                    if Cache.brutestate == false then
                                        Cache.desync_deg = -60
                                    elseif Cache.brutestate == true then
                                        Cache.desync_deg = 60
                                    end
                                elseif last_detected == "Right" then
                                    if Cache.brutestate == false then
                                        Cache.desync_deg = 60
                                    elseif Cache.brutestate == true then
                                        Cache.desync_deg = -60
                                    end
                                end
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.desync_deg/2)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.desync_deg/2
                            end 
                        else
                            ui.set(Menu_Reference.ForceBodyYaw, false)
                            ui.set(Menu_Reference.ForceSlider, 0)  
                            ui.set(Menu_Reference.ApplyToAll, true)
                            Cache.DesyncToResolve = 0
                        end
                        Desync_Can_Off = true
                    elseif table_contains(ui.get(OceanMenu["Aimbot"].Roll_Overrides), "Resolve Desync") then
                        if Cache.EnemyState == "stand" then
                            if Cache.brutestate == false then
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.EnemyDesyncAmount)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.EnemyDesyncAmount
                            elseif Cache.brutestate == true then
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, -Cache.EnemyDesyncAmount)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = -Cache.EnemyDesyncAmount
                            end
                        elseif Cache.EnemyState == "duck" then
                            if Cache.brutestate == false then
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.EnemyDesyncAmount)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.EnemyDesyncAmount
                            elseif Cache.brutestate == true then
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, -Cache.EnemyDesyncAmount)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = -Cache.EnemyDesyncAmount
                            end
                        elseif Cache.EnemyState == "duckmove" then
                            if Cache.EnemyWallSide == "Left" then
                                if Cache.brutestate == false then
                                    Cache.EnemyDesyncAmount = -60
                                elseif Cache.brutestate == true then
                                    Cache.EnemyDesyncAmount = 60
                                end
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.EnemyDesyncAmount/2)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.EnemyDesyncAmount/2
                            elseif Cache.EnemyWallSide == "Right" then
                                if Cache.brutestate == false then
                                    Cache.EnemyDesyncAmount = 60
                                elseif Cache.brutestate == true then
                                    Cache.EnemyDesyncAmount = -60
                                end
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.EnemyDesyncAmount/2)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.EnemyDesyncAmount/2
                            elseif Cache.EnemyWallSide == "None" then
                                if last_detected == "Left" then
                                    if Cache.brutestate == false then
                                        Cache.EnemyDesyncAmount = -60
                                    elseif Cache.brutestate == true then
                                        Cache.EnemyDesyncAmount = 60
                                    end
                                elseif last_detected == "Right" then
                                    if Cache.brutestate == false then
                                        Cache.EnemyDesyncAmount = 60
                                    elseif Cache.brutestate == true then
                                        Cache.EnemyDesyncAmount = -60
                                    end
                                end
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.EnemyDesyncAmount / 2)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.EnemyDesyncAmount/2
                            end
                        elseif Cache.EnemyState == "slow" then
                            if Cache.EnemyWallSide == "Left" then
                                if Cache.brutestate == false then
                                    Cache.EnemyDesyncAmount = -60
                                elseif Cache.brutestate == true then
                                    Cache.EnemyDesyncAmount = 60
                                end
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.EnemyDesyncAmount)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.EnemyDesyncAmount
                            elseif Cache.EnemyWallSide == "Right" then
                                if Cache.brutestate == false then
                                    Cache.EnemyDesyncAmount = 60
                                elseif Cache.brutestate == true then
                                    Cache.EnemyDesyncAmount = -60
                                end
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.EnemyDesyncAmount)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.EnemyDesyncAmount
                            elseif Cache.EnemyWallSide == "None" then
                                if last_detected == "Left" then
                                    if Cache.brutestate == false then
                                        Cache.EnemyDesyncAmount = -60
                                    elseif Cache.brutestate == true then
                                        Cache.EnemyDesyncAmount = 60
                                    end
                                elseif last_detected == "Right" then
                                    if Cache.brutestate == false then
                                        Cache.EnemyDesyncAmount = 60
                                    elseif Cache.brutestate == true then
                                        Cache.EnemyDesyncAmount = -60
                                    end
                                end
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.EnemyDesyncAmount)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.EnemyDesyncAmount
                            end
                        elseif Cache.EnemyState == "move" then
                            if Cache.EnemyWallSide == "Left" then
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.EnemyDesyncAmount/2)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.EnemyDesyncAmount/2
                            elseif Cache.EnemyWallSide == "Right" then
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.EnemyDesyncAmount/2)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.EnemyDesyncAmount/2
                            elseif Cache.EnemyWallSide == "None" then
                                if last_detected == "Left" then
                                    if Cache.brutestate == false then
                                        Cache.EnemyDesyncAmount = -56
                                    elseif Cache.brutestate == true then
                                        Cache.EnemyDesyncAmount = 56
                                    end
                                elseif last_detected == "Right" then
                                    if Cache.brutestate == false then
                                        Cache.EnemyDesyncAmount = 56
                                    elseif Cache.brutestate == true then
                                        Cache.EnemyDesyncAmount = -56
                                    end
                                end
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.EnemyDesyncAmount/2)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.EnemyDesyncAmount/2
                            end
                        elseif Cache.EnemyState == "air" then
                            if Cache.EnemyWallSide == "Left" then
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.EnemyDesyncAmount/2)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.EnemyDesyncAmount/2
                            elseif Cache.EnemyWallSide == "Right" then
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.EnemyDesyncAmount/2)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.EnemyDesyncAmount/2
                            elseif Cache.EnemyWallSide == "None" then
                                if last_detected == "Left" then
                                    if Cache.brutestate == false then
                                        Cache.EnemyDesyncAmount = -60
                                    elseif Cache.brutestate == true then
                                        Cache.EnemyDesyncAmount = 60
                                    end
                                elseif last_detected == "Right" then
                                    if Cache.brutestate == false then
                                        Cache.EnemyDesyncAmount = 60
                                    elseif Cache.brutestate == true then
                                        Cache.EnemyDesyncAmount = -60
                                    end
                                end
                                ui.set(Menu_Reference.ForceBodyYaw, true)
                                ui.set(Menu_Reference.ForceSlider, Cache.EnemyDesyncAmount/2)
                                ui.set(Menu_Reference.ApplyToAll, true)
                                Cache.DesyncToResolve = Cache.EnemyDesyncAmount/2
                            end 
                        end
                        Desync_Can_Off = true
                    else
                        if Desync_Can_Off == true then
                            ui.set(Menu_Reference.ForceBodyYaw, false)
                            ui.set(Menu_Reference.ForceSlider, 0)
                            ui.set(Menu_Reference.ApplyToAll, true)
                            Cache.DesyncToResolve = 0
                            Desync_Can_Off = false
                        end
                    end

    end
end

--ANTIAIM

function MicroMove(cmd)
    if not ui.get(OceanMenu["AntiAim"].Enable) then return end
    if not ui.get(Menu_Reference.Enabled) then return end
    if entity.get_local_player() == nil then return end
    game_rule = entity.get_game_rules()
    LPitch, LYaw = entity.get_prop(entity.get_local_player(), "m_angEyeAngles")
    Lx, Ly, Lz = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
    Lspeed = math.sqrt(Lx ^ 2 + Ly ^ 2) 
    if cmd.chokedcommands == 0 or Lspeed > 2 or cmd.in_use == 1 or cmd.in_attack == 1 or is_freezetime() then return end
    if ui.get(Menu_Reference.Slowwalk[1]) and ui.get(Menu_Reference.Slowwalk[2]) and Lspeed > 15 then
        cmd.forwardmove = 0.1
        cmd.in_forward = 0

    else
        cmd.forwardmove = 0.1
        cmd.in_forward = 1

    end
end

local brute_reset = function()
    Cache.AA_Brute = false
end

function vectorDist(A,B,C)
    d = (A-B) / A:dist(B)
    v = C - B
    t = v:dot(d) 
    P = B + d:scaled(t)
    
    return P:dist(C)
end

function bullet_impact(e)
    shooter = client.userid_to_entindex(e.userid)
    if not entity.is_enemy(shooter) or not entity.is_alive(entity.get_local_player()) then return end
    if not ui.get(OceanMenu["AntiAim"].aa_state[state].Brute) then return end
    shot_start_pos 	= vector(entity.get_prop(shooter, "m_vecOrigin"))
	shot_start_pos.z 		= shot_start_pos.z + entity.get_prop(shooter, "m_vecViewOffset[2]")
	eye_pos			= vector(client.eye_position())
	shot_end_pos 		= vector(e.x, e.y, e.z)
	closest			= vectorDist(shot_start_pos, shot_end_pos, eye_pos)

    if closest < 32 then 
        if Cache.AA_Brute == false and can_brute == true then
            Cache.AA_Brute = true
            can_brute = false
        elseif Cache.AA_Brute == true and can_brute == true then
            Cache.AA_Brute = false
            can_brute = false
        end
    end
    can_brute = true
end

function GetState(cmd)
    local_player = entity.get_local_player()
    if local_player == nil then return end
    vx, vy, vz = entity.get_prop(local_player, "m_vecVelocity")
    LP_Still = math.sqrt(vx ^ 2 + vy ^ 2) < 3
    LP_Slow = ui.get(Menu_Reference.Slowwalk[1]) and ui.get(Menu_Reference.Slowwalk[2])
    LP_Flags = entity.get_prop(local_player, "m_fFlags")
    LP_Ground = bit.band(entity.get_prop(local_player, "m_fFlags"), 1) == 1
    Old_State = state 
    if bit.band(LP_Flags, 1) == 0 then
        state = "In-Air"
        if state ~= Old_State then
            brute_reset()
        end
    elseif cmd.in_duck == 1 and LP_Ground or ui.get(Menu_Reference.Fakeduck) then
        state = "Duck"
        if state ~= Old_State then
            brute_reset()
        end
    elseif LP_Slow then
        state = "Slowwalk"
        if state ~= Old_State then
            brute_reset()
        end
    elseif not LP_Still then
        state = "Move"
        if state ~= Old_State then
            brute_reset()
        end
    elseif LP_Still then
        state = "Stand"
        if state ~= Old_State then
            brute_reset()
        end
    end
end

function LocalSideDetection(player)
    if player == nil then return end
    if state == nil then return end
    eyepos_x, eyepos_y, eyepos_z = entity.get_prop(player, "m_vecAbsOrigin")
    offsetx, offsety, offsetz = entity.get_prop(player, "m_vecViewOffset")
    eyepos_z = eyepos_z + offsetz
    Lowestfrac = 1
    Dir = false
    Desync = entity.get_prop(player, "m_flPoseParameter", 11) * 120 - 60
    Cache.Desync = Desync
    ReverseFreestand = ui.get(OceanMenu["AntiAim"].aa_state[state].Reverse)
    Ppitch, Pyaw = entity.get_prop(player, "m_angRotation")
    FractionLeft, FractionRight = 0, 0
    AmountLeft, AmountRight = 0, 0
    for i = -70, 70, 5 do
        if i ~= 0 then
            fwdx, fwdy, fwdz = libary.vectorangle(0, Pyaw + i + Desync, 0)
            ffwx, ffwdy, ffwdz = libary.multiplyvalues(fwdx, fwdy, fwdz, 70)
            
            Fraction = client.trace_line(player, eyepos_x, eyepos_y, eyepos_z, eyepos_x + ffwx, eyepos_y + ffwdy, eyepos_z + ffwdz)

            if i > 0 then
                FractionLeft = FractionLeft + Fraction
                AmountLeft = AmountLeft + 1
            else
                FractionRight = FractionRight + Fraction
                AmountRight = AmountRight + 1
            end

        end

    end

    Averageleft, Averageright = FractionLeft / AmountLeft, FractionRight / AmountRight

    if Averageleft < Averageright then
        if ReverseFreestand then
            Cache.Local_Detected_Side = "Right"
        else
            Cache.Local_Detected_Side = "Left"
        end
    elseif Averageleft > Averageright then
        if ReverseFreestand then
            Cache.Local_Detected_Side = "Left"
        else
            Cache.Local_Detected_Side = "Right"
        end
    else
        Cache.Local_Detected_Side = "None"
    end
    
end

function OceanAntiAim(cmd)
    local_player = entity.get_local_player()
    if local_player == nil then return end
    if not ui.get(OceanMenu["Main"].OceanEnabler) then return end
    AntiAimSwitch = ui.get(OceanMenu["AntiAim"].Enable)
    Disabler_FD = table_contains(ui.get(OceanMenu["AntiAim"].Disablers), "While Fakeduck")
    Disabler_TO = table_contains(ui.get(OceanMenu["AntiAim"].Disablers), "Tabbed Out")
    Disabler_FPS = table_contains(ui.get(OceanMenu["AntiAim"].Disablers), "Low FPS")
    if AntiAimSwitch and ui.get(OceanMenu["Main"].OceanEnabler) then
        if Disabler_FD and ui.get(Menu_Reference.Fakeduck) or Disabler_TO and engineclient.is_app_active()==false or Disabler_FPS and math.floor(1 / globals.absoluteframetime() + 0.5) < 45 then
            ui.set(ElementsToHide.Anti_Aimbot_Angles.Enabled, false)
            AntiaimCheck = false
        else
            ui.set(ElementsToHide.Anti_Aimbot_Angles.Enabled, true)
            AntiaimCheck = true
        end

    else
        ui.set(ElementsToHide.Anti_Aimbot_Angles.Enabled, false)
        AntiaimCheck = false
    end
    BodyYawSetting = ui.get(OceanMenu["AntiAim"].aa_state[state].BodyYaw)
    TempBodyYaw = ui.get(OceanMenu["AntiAim"].aa_state[state].Open)
    Untrusted = ui.get(OceanMenu["Misc"].Untrusted)
    RollSelected = table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Roll")
    if Untrusted then
        ui.set(Menu_Reference.Anti_Untrusted, false)
        UntrustedOVR = true

        if RollSelected and ui.get(OceanMenu["AntiAim"].aa_state[state].Roll) then
            LeftRoll = ui.get(OceanMenu["AntiAim"].aa_state[state].Untrusted_L)
            RightRoll = ui.get(OceanMenu["AntiAim"].aa_state[state].Untrusted_R)
        else
            LeftRoll = 0
            RightRoll = 0
        end

    else
        if UntrustedOVR == true then
            ui.set(Menu_Reference.Anti_Untrusted, true)
            UntrustedOVR = false
        end
        if RollSelected and ui.get(OceanMenu["AntiAim"].aa_state[state].Roll) then
            LeftRoll = ui.get(OceanMenu["AntiAim"].aa_state[state].Roll_L)
            RightRoll = ui.get(OceanMenu["AntiAim"].aa_state[state].Roll_R)
        else
            LeftRoll = 0
            RightRoll = 0
        end

    end
    if BodyYawSetting == "Freestand" then
        if Cache.Local_Detected_Side == "Left" then
            BodyYawResult = "Static"
            if ui.get(OceanMenu["AntiAim"].aa_state[state].Brute) and Cache.AA_Brute then
                BodyYawValue = 60
            else
                BodyYawValue = -60
            end
        elseif Cache.Local_Detected_Side == "Right" then
            BodyYawResult = "Static"
            if ui.get(OceanMenu["AntiAim"].aa_state[state].Brute) and Cache.AA_Brute then
                BodyYawValue = -60
            else
                BodyYawValue = 60
            end
        else
            if TempBodyYaw == "Opposite" then
                BodyYawResult = "Static"
                if ui.get(OceanMenu["AntiAim"].aa_state[state].Brute) and Cache.AA_Brute == true then
                    BodyYawValue = ui.get(OceanMenu["AntiAim"].Inverter) and 60 or -60
                else
                    BodyYawValue = ui.get(OceanMenu["AntiAim"].Inverter) and -60 or 60
                end
            elseif TempBodyYaw == "Jitter" then
                BodyYawResult = "Jitter"
                BodyYawValue = 0
            end
        end
    elseif BodyYawSetting == "Opposite" then
        BodyYawResult = "Static"
        if ui.get(OceanMenu["AntiAim"].aa_state[state].Brute) and Cache.AA_Brute then
            BodyYawValue = ui.get(OceanMenu["AntiAim"].Inverter) and 60 or -60
        else
            BodyYawValue = ui.get(OceanMenu["AntiAim"].Inverter) and -60 or 60
        end
    elseif BodyYawSetting == "Jitter" then
        BodyYawResult = "Jitter"
        BodyYawValue = 0
    end

    ui.set(ElementsToHide.Anti_Aimbot_Angles.Body_Yaw, BodyYawResult)
    ui.set(ElementsToHide.Anti_Aimbot_Angles.Body_Yaw_Value, BodyYawValue)

    FreestandSelected = table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Freestanding")
    TargetSelect = table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Yaw: At Targets")
    PitchSelect = table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Pitch-Down \aCDCDCDFF(\aD6BE73FFUnsafe\aCDCDCDFF)")
    HalfPitchSelect = table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Half-Pitch \aCDCDCDFF(\aD6BE73FFUnsafe\aCDCDCDFF)")
    ManualSelect = table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Manual Yaw \aCDCDCDFF(\aD6BE73FFUnsafe\aCDCDCDFF)")
    --LBY
    if table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Lower Body Yaw") then
        Weapon = csgo_weapon[entity.get_prop(entity.get_player_weapon(local_player), "m_iItemDefinitionIndex")]
        Is_Ladder = entity.get_prop(local_player, "m_MoveType") == 9
        if Is_Ladder then return end
        if Weapon == nil or Weapon.type == "grenade" then return end
        if cmd.in_use == 1 then return end
        if is_freezetime() then return end
        if not AntiaimCheck then return end
        Tpitch, Tyaw = entity.get_prop(local_player, "m_angEyeAngles")
        Current_Threat = client.current_threat()
        
        if cmd.chokedcommands == 0 and cmd.in_attack ~= 1 then
            if TargetSelect and ui.get(OceanMenu["AntiAim"].AtTarget) then
                if Current_Threat == nil then
                    cmd.yaw = cmd.yaw + BodyYawValue
                else
                    cmd.yaw = Tyaw + BodyYawValue/2
                end
            elseif ManualSelect then
                if Cache.ManualAA == 1 then
                    cmd.yaw = ui.get(OceanMenu["AntiAim"].ManualLeftSlider) + BodyYawValue
                elseif Cache.ManualAA == 2 then
                    cmd.yaw = ui.get(OceanMenu["AntiAim"].ManualRightSlider) + BodyYawValue
                end
            end

            cmd.yaw = cmd.yaw + BodyYawValue
            cmd.allow_send_packet = false
        end
        MicroMove(cmd)   
    end

    if table_contains(ui.get(OceanMenu["AntiAim"].Extras), "In-Air Tick Manipulation \aCDCDCDFF(\aD6BE73FFTesting\aCDCDCDFF)") then
        if state == "In-Air" then 
            if cmd.chokedcommands == 0 then
                cmd.force_defensive = 1 
            end
        end
    end

    --Extras
    if FreestandSelected and ui.get(OceanMenu["AntiAim"].Freestand) then
        ui.set(Menu_Reference.Freestanding, true)
        ui.set(Menu_Reference.Freestanding_Key, "Always on")
    else
        ui.set(Menu_Reference.Freestanding, false)
    end

    if TargetSelect and ui.get(OceanMenu["AntiAim"].AtTarget) then
        ui.set(Menu_Reference.Yaw_Base, "At targets")
    else
        ui.set(Menu_Reference.Yaw_Base, "Local view")
    end

    if PitchSelect and ui.get(OceanMenu["AntiAim"].PitchKey) then
        ui.set(Menu_Reference.Pitch, "Down")  
        ui.set(Menu_Reference.Yaw, "180")
        ui.set(Menu_Reference.Yaw_Value, 0)
    elseif ManualSelect then
    
        ui.set(OceanMenu["AntiAim"].ManualLeft, "On hotkey")
        ui.set(OceanMenu["AntiAim"].ManualRight, "On hotkey")
        if Cache.Input + 0.22 < globals.curtime() then
            if Cache.ManualAA == 0 then
                if ui.get(OceanMenu["AntiAim"].ManualLeft) then
                    Cache.ManualAA = 1
                    Cache.Input = globals.curtime()
                elseif ui.get(OceanMenu["AntiAim"].ManualRight) then
                    Cache.ManualAA = 2
                    Cache.Input = globals.curtime()
                end
            elseif Cache.ManualAA == 1 then
                if ui.get(OceanMenu["AntiAim"].ManualRight) then
                    Cache.ManualAA = 2
                    Cache.Input = globals.curtime()
                elseif ui.get(OceanMenu["AntiAim"].ManualLeft) then
                    Cache.ManualAA = 0
                    Cache.Input = globals.curtime()
                end
            elseif Cache.ManualAA == 2 then
                if ui.get(OceanMenu["AntiAim"].ManualLeft) then
                    Cache.ManualAA = 1
                    Cache.Input = globals.curtime()
                elseif ui.get(OceanMenu["AntiAim"].ManualRight) then
                    Cache.ManualAA = 0
                    Cache.Input = globals.curtime()
                end
            end
        end

        if Cache.ManualAA == 0 then
            ui.set(Menu_Reference.Yaw, "180")
            ui.set(Menu_Reference.Yaw_Value, 180)
        elseif Cache.ManualAA == 1 then
            ui.set(Menu_Reference.Yaw, "180")
            ui.set(Menu_Reference.Yaw_Value, ui.get(OceanMenu["AntiAim"].ManualLeftSlider))
        elseif Cache.ManualAA == 2 then
            ui.set(Menu_Reference.Yaw, "180")
            ui.set(Menu_Reference.Yaw_Value, ui.get(OceanMenu["AntiAim"].ManualRightSlider))
        end

    elseif HalfPitchSelect and ui.get(OceanMenu["AntiAim"].HalfPitchKey) then
        ui.set(Menu_Reference.Pitch, "Custom")
        ui.set(Menu_Reference.Pitch_Value, 45)
        ui.set(Menu_Reference.Yaw, "180")
        ui.set(Menu_Reference.Yaw_Value, 180)
    else
        ui.set(Menu_Reference.Pitch, "Off")
        ui.set(Menu_Reference.Pitch_Value, 0)
        ui.set(Menu_Reference.Yaw, "180")
        ui.set(Menu_Reference.Yaw_Value, 180)
    end
    --Roll
    if Cache.Desync > 3 then
        DesyncSide = "Left"
    elseif Cache.Desync < 3 then
        DesyncSide = "Right"
    end
    

    Is_MM = ffi.cast("bool*", Cache.GameRule[0] + 124)

    if Is_MM ~= nil then
       
        if Untrusted and RollSelected and ui.get(OceanMenu["AntiAim"].aa_state[state].Roll) then
            if DesyncSide == "Left" then
                ui.set(Menu_Reference.Roll, 0)
                cmd.roll = LeftRoll
            elseif DesyncSide == "Right" then
                ui.set(Menu_Reference.Roll, 0)
                cmd.roll = RightRoll
            end

        elseif RollSelected and ui.get(OceanMenu["AntiAim"].aa_state[state].Roll) and not Untrusted then
            if DesyncSide == "Left" then
                ui.set(Menu_Reference.Roll, LeftRoll)
                cmd.roll = LeftRoll
            elseif DesyncSide == "Right" then
                ui.set(Menu_Reference.Roll, RightRoll)
                cmd.roll = RightRoll
            end
        else
            ui.set(Menu_Reference.Roll, 0)
            cmd.roll = 0
        end

        if Is_MM[0] == true then
            Is_MM[0] = 0
            Cache.Is_Valve_Server = 1
        end
    end

end

function Fakelag(cmd)
    local_player = entity.get_local_player()
    if local_player == nil then return end
    --WeaponCheck
    WeaponEnt = entity.get_player_weapon(local_player)
    WeaponIDX = entity.get_prop(WeaponEnt, "m_iItemDefinitionIndex")
    Weapon = csgo_weapon[WeaponIDX]
    R8 = Weapon.name == "R8 Revolver"

    if ui.get(OceanMenu["FakeLag"].Enable) and ui.get(OceanMenu["FakeLag"].Key) then
        if ui.get(OceanMenu["FakeLag"].Restrict) and R8 and ui.get(Menu_Reference.Rage_Enable[1]) and ui.get(Menu_Reference.Rage_Enable[2]) then
            ui.set(Menu_Reference.FL_Enabled[1], false)
        else
            ui.set(Menu_Reference.FL_Enabled[1], true)
        end
        ui.set(Menu_Reference.FL_Enabled[2], "Always on")
        if ui.get(OceanMenu["FakeLag"].fl_state[state].Override) then
            ui.set(Menu_Reference.Amount, ui.get(OceanMenu["FakeLag"].fl_state[state].Amount))
            ui.set(Menu_Reference.Variance, ui.get(OceanMenu["FakeLag"].fl_state[state].Variance))
            ui.set(Menu_Reference.Limit, ui.get(OceanMenu["FakeLag"].fl_state[state].Limit))
        else
            ui.set(Menu_Reference.Amount, ui.get(OceanMenu["FakeLag"].fl_state[Infos.fl_number].Amount))
            ui.set(Menu_Reference.Variance, ui.get(OceanMenu["FakeLag"].fl_state[Infos.fl_number].Variance))
            ui.set(Menu_Reference.Limit, ui.get(OceanMenu["FakeLag"].fl_state[Infos.fl_number].Limit))
        end
    else
        ui.set(Menu_Reference.FL_Enabled[1], false)
    end
end

function Other()
    local_player = entity.get_local_player()
    if local_player == nil then return end
    if not ui.get(OceanMenu["Main"].OceanEnabler) then return end
    if ui.get(OceanMenu["Other"].Slowwalk) and ui.get(OceanMenu["Other"].Slowwalk_Key) then
        ui.set(Menu_Reference.Slowwalk[1], true)
        ui.set(Menu_Reference.Slowwalk[2], "Always on")
    else
        ui.set(Menu_Reference.Slowwalk[1], false)
        ui.set(Menu_Reference.Slowwalk[2], "On hotkey")
    end
    if ui.get(OceanMenu["Other"].Leg_movement) == "Off" then
        ui.set(Menu_Reference.Leg_Movement, "Off")
    elseif ui.get(OceanMenu["Other"].Leg_movement) == "Always slide" then
        ui.set(Menu_Reference.Leg_Movement, "Always slide")
    elseif ui.get(OceanMenu["Other"].Leg_movement) == "Never slide" then
        ui.set(Menu_Reference.Leg_Movement, "Never slide")
    elseif ui.get(OceanMenu["Other"].Leg_movement) == "Leg breaker" then
        leg_types = {[1] = "Off", [2] = "Always slide", [3] = "Never slide"}
        ui.set(Menu_Reference.Leg_Movement, leg_types[math.random(1, 3)])
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
    end
    if ui.get(OceanMenu["Other"].Hideshots) and ui.get(OceanMenu["Other"].Hideshots_Key) then
        ui.set(Menu_Reference.On_Shot_Anti_Aim, true)
        ui.set(Menu_Reference.On_Shot_Anti_Aim_key, "Always on")
    else
        ui.set(Menu_Reference.On_Shot_Anti_Aim, false)
        ui.set(Menu_Reference.On_Shot_Anti_Aim_key, "On hotkey")
    end
end
--Visuals

function indicator_circle(x, y, r, g, b, a, percentage, outline)
    outline = outline or true
    start_degrees, radius = 0, 9

    if outline then
        renderer.circle_outline(x, y, 0, 0, 0, 200, radius, start_degrees, 1.0, 5)
    end
    renderer.circle_outline(x, y, r, g, b, a, radius-1, start_degrees, percentage, 3)
end
local function Clamp(Value, Min, Max)
    return Value < Min and Min or (Value > Max and Max or Value)
end

function FeatureIndicator()
    local_player = entity.get_local_player()
    if local_player == nil then return end
    if not ui.get(OceanMenu["Main"].OceanEnabler) then return end
    r,g,b,a = ui.get(OceanMenu["Visuals"].Feature_color)
    rr,gg,bb,aa = ui.get(OceanMenu["Visuals"].Feature_color2)
    RO = table_contains(ui.get(OceanMenu["Aimbot"].Roll_Overrides), "Resolve Roll")
    DO = table_contains(ui.get(OceanMenu["Aimbot"].Roll_Overrides), "Resolve Desync")
    desync = Clamp(math.abs(entity.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 59), 0.5 / 60, 60) / 56
    if not entity.is_alive(local_player) then return end
    ui.set(Menu_Reference.Def_feature, "-")
    ui.set_visible(Menu_Reference.Def_feature, false)

    Feature_AF = table_contains(ui.get(OceanMenu["Visuals"].Feature), "Auto Fire")
    Feature_AW = table_contains(ui.get(OceanMenu["Visuals"].Feature), "Auto Wall")
    Feature_FOV = table_contains(ui.get(OceanMenu["Visuals"].Feature), "FOV")
    Feature_DUCK = table_contains(ui.get(OceanMenu["Visuals"].Feature), "Duck peek assist")
    Feature_FB = table_contains(ui.get(OceanMenu["Visuals"].Feature), "Force Baim")
    Feature_FS = table_contains(ui.get(OceanMenu["Visuals"].Feature), "Force Safepoint")
    Feature_AA = table_contains(ui.get(OceanMenu["Visuals"].Feature), "AA")
    Feature_FL = table_contains(ui.get(OceanMenu["Visuals"].Feature), "FL")
    Feature_MD = table_contains(ui.get(OceanMenu["Visuals"].Feature), "Min. Damage")
    Feature_Ping = table_contains(ui.get(OceanMenu["Visuals"].Feature), "Ping")
    Feature_FREES = table_contains(ui.get(OceanMenu["Visuals"].Feature), "Freestand")
    Feature_AT = table_contains(ui.get(OceanMenu["Visuals"].Feature), "Yaw: At Targets")
    Feature_PITCH = table_contains(ui.get(OceanMenu["Visuals"].Feature), "Pitch")
    Feature_HALFPITCH = table_contains(ui.get(OceanMenu["Visuals"].Feature), "Half-Pitch")
    Feature_OS = table_contains(ui.get(OceanMenu["Visuals"].Feature), "On-Shot")
    Feature_ST = table_contains(ui.get(OceanMenu["Visuals"].Feature), "State")
    Feature_RE = table_contains(ui.get(OceanMenu["Visuals"].Feature), "Resolver")

    Free = table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Freestanding")
    AT = table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Yaw: At Targets")
    Pitchonkey = table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Pitch-Down \aCDCDCDFF(\aD6BE73FFUnsafe\aCDCDCDFF)")
    HalfPitch = table_contains(ui.get(OceanMenu["AntiAim"].Extras), "Pitch-Down \aCDCDCDFF(\aD6BE73FFUnsafe\aCDCDCDFF)")


    if Feature_OS and ui.get(Menu_Reference.On_Shot_Anti_Aim) and ui.get(Menu_Reference.On_Shot_Anti_Aim_key) then
        renderer.indicator(r,g,b,a, "OS")
    end
    if Feature_FB and ui.get(Menu_Reference.ForceBaim) then
        renderer.indicator(r,g,b,a, "BAIM")
    end
    if Feature_FS and ui.get(Menu_Reference.ForceSafe) then
        renderer.indicator(r,g,b,a, "SAFE")
    end
    if Feature_DUCK and ui.get(Menu_Reference.Fakeduck) then
        renderer.indicator(r,g,b,a, "DUCK")
    end
    if Feature_ST then 
        renderer.indicator(r,g,b,a, state)
    end
    if Feature_PITCH and ui.get(OceanMenu["AntiAim"].PitchKey) and Pitchonkey then
        renderer.indicator(r,g,b,a, "Pitch")
    end
    if Feature_HALFPITCH and ui.get(OceanMenu["AntiAim"].HalfPitchKey) and HalfPitch then
        renderer.indicator(r,g,b,a, "Half-Pitch")
    end
    if Feature_AT and ui.get(OceanMenu["AntiAim"].AtTarget) and AT then
        renderer.indicator(r,g,b,a, "AT")
    end
    if Feature_FREES and ui.get(OceanMenu["AntiAim"].Freestand) and Free then
        renderer.indicator(r,g,b,a, "FS")
    end
    if Feature_MD and ui.get(Menu_Reference.MinDmgOvr[2]) then
        renderer.indicator(r,g,b,a, "DMG: "..ui.get(Menu_Reference.MinDmgOvr[3]))
    end
    if Feature_FL and ui.get(Menu_Reference.FL_Enabled[1]) and ui.get(Menu_Reference.FL_Enabled[2]) then
        y = renderer.indicator(r, g, b, a, 'FL')
        indicator_circle(72, y + 18, rr, gg, bb, aa, Cache.chokedcmds / ui.get(Menu_Reference.Limit))
    end
    if Feature_AA and ui.get(OceanMenu["AntiAim"].Enable) then
        y = renderer.indicator(r, g, b, a, 'AA')
        indicator_circle(72, y + 18, rr, gg, bb, aa, desync)
    end
    if Feature_Ping and ui.get(Menu_Reference.Ping[1]) and ui.get(Menu_Reference.Ping[2]) then
        renderer.indicator(r,g,b,a, "PING")
    end
    if Feature_AW and ui.get(Menu_Reference.AutoPen[1]) then
        renderer.indicator(r,g,b,a, "AW")
    end
    if Feature_AF and ui.get(Menu_Reference.AutoFire[1]) then
        renderer.indicator(r,g,b,a, "TM")
    end
    if Feature_FOV then
        renderer.indicator(r,g,b,a, "FOV: "..ui.get(Menu_Reference.Fov).."°")
    end

    

end

function gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
	output = ''
	len = #text-1
	rinc = (r2 - r1) / len
	ginc = (g2 - g1) / len
	binc = (b2 - b1) / len
	ainc = (a2 - a1) / len
	for i=1, len+1 do
		output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))

		r1 = r1 + rinc
		g1 = g1 + ginc
		b1 = b1 + binc
		a1 = a1 + ainc
	end
	return output
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

function Crosshair_Indicator()
    if not ui.get(OceanMenu["Main"].OceanEnabler) then return end
    localplayer = entity.get_local_player()
    if not entity.is_alive(localplayer) then return end
    if not ui.get(OceanMenu["Visuals"].Crosshair_Indicator) then return end
    IName = table_contains(ui.get(OceanMenu["Visuals"].Crosshair_Indicator_select), "Name")
    IRagebot = table_contains(ui.get(OceanMenu["Visuals"].Crosshair_Indicator_select), "Ragebot")
    IFov = table_contains(ui.get(OceanMenu["Visuals"].Crosshair_Indicator_select), "Fov")
    ISafe = table_contains(ui.get(OceanMenu["Visuals"].Crosshair_Indicator_select), "Safe")
    IBaim = table_contains(ui.get(OceanMenu["Visuals"].Crosshair_Indicator_select), "Baim")
    IDmg = table_contains(ui.get(OceanMenu["Visuals"].Crosshair_Indicator_select), "Min. Dmg")
    screen = {client.screen_size()}
    x_offset, y_offset = screen[1], screen[2]
    x, y =  x_offset/2,y_offset/2 
    r,g,b,a = ui.get(OceanMenu["Visuals"].Crosshair_Indicator_color)
    rr,gg,bb,aa = ui.get(OceanMenu["Visuals"].Crosshair_Indicator_color1)
    Scope = entity.get_prop(entity.get_local_player(), 'm_bIsScoped') == 1
    desync = entity.get_prop(entity.get_local_player(), 'm_flPoseParameter', 11) * 120 - 60
    C_side = desync > 3

    Cache.Scope_spacer = lerp(Cache.Scope_spacer, Scope and 28 or 0, 15 * globals.frametime())

    if ui.get(OceanMenu["Visuals"].Body_Yaw_indicator_Invert)==false then
        if C_side == false then
            lua_name =  gradient_text(r, g, b, a, rr, gg, bb, aa, 'Ocean')

        elseif C_side == true then
            lua_name =  gradient_text(rr, gg, bb, aa, r, g, b, a, 'Ocean')
        end
    else
        if C_side == true then
            lua_name =  gradient_text(r, g, b, a, rr, gg, bb, aa, 'Ocean')

        elseif C_side == false then
            lua_name =  gradient_text(rr, gg, bb, aa, r, g, b, a, 'Ocean')

        end
    end
    Spacer = 0
    if IName then
        renderer.text(x-15+Cache.Scope_spacer, y+15, r, g, b, 255, "b", 100, lua_name)
        Spacer = Spacer + 13
    end
    if IRagebot then
        if ui.get(OceanMenu["Aimbot"].Autofire)==true and ui.get(OceanMenu["Aimbot"].Autofire_hotkey) and ui.get(OceanMenu["Aimbot"].Autopenetration)==true and ui.get(OceanMenu["Aimbot"].Autopenetration_hotkey) then
            renderer.text(x-14+Cache.Scope_spacer, y+15+Spacer, r, g, b, 255, "-", 100, "AF")
            renderer.text(x-3+Cache.Scope_spacer, y+15+Spacer, 225, 225, 225, 255, "-", 100, ":")
            renderer.text(x+2+Cache.Scope_spacer, y+15+Spacer, r, g, b, 255, "-", 100, "AW")
        elseif ui.get(OceanMenu["Aimbot"].Autofire)==true and ui.get(OceanMenu["Aimbot"].Autofire_hotkey) and not ui.get(OceanMenu["Aimbot"].Autopenetration_hotkey) then
            renderer.text(x-14+Cache.Scope_spacer, y+15+Spacer, r, g, b, 255, "-", 100, "AF")
            renderer.text(x-3+Cache.Scope_spacer, y+15+Spacer, 225, 225, 225, 255, "-", 100, ":")
            renderer.text(x+2+Cache.Scope_spacer, y+15+Spacer, 138, 138, 138, 255, "-", 100, "AW")
        elseif ui.get(OceanMenu["Aimbot"].Autopenetration)==true and ui.get(OceanMenu["Aimbot"].Autopenetration_hotkey) and not ui.get(OceanMenu["Aimbot"].Autofire_hotkey) then
            renderer.text(x-14+Cache.Scope_spacer, y+15+Spacer, 138, 138, 138, 255, "-", 100, "AF")
            renderer.text(x-3+Cache.Scope_spacer, y+15+Spacer, 225, 225, 225, 255, "-", 100, ":")
            renderer.text(x+2+Cache.Scope_spacer, y+15+Spacer, r, g, b, 255, "-", 100, "AW")
        else
            renderer.text(x-14+Cache.Scope_spacer, y+15+Spacer, 138, 138, 138, 255, "-", 100, "AF")
            renderer.text(x-3+Cache.Scope_spacer, y+15+Spacer, 225, 225, 225, 255, "-", 100, ":")
            renderer.text(x+2+Cache.Scope_spacer, y+15+Spacer, 138, 138, 138, 255, "-", 100, "AW")
        end
        Spacer = Spacer + 13
    end
    if IFov then
        renderer.text(x-12+Cache.Scope_spacer, y+12+Spacer, 225, 225, 225, 255, "-", 100, "FOV:")
        renderer.text(x+6+Cache.Scope_spacer, y+12+Spacer, r, g, b, 255, "-", 100, ui.get(Menu_Reference.Fov))
        Spacer = Spacer + 10
    end
    if IDmg and ui.get(Menu_Reference.MinDmgOvr[2]) then
        renderer.text(x-12+Cache.Scope_spacer, y+12+Spacer, 225, 225, 225, 255, "-", 100, "DMG:")
        renderer.text(x+6+Cache.Scope_spacer, y+12+Spacer, r, g, b, 255, "-", 100, ui.get(Menu_Reference.MinDmgOvr[3]))
        Spacer = Spacer + 10
    end
    if ISafe and ui.get(Menu_Reference.ForceSafe) then
        renderer.text(x-10+Cache.Scope_spacer, y+12+Spacer, 225, 225, 225, 255, "-", 100, "SAFE")
        Spacer = Spacer + 10
    end
    if IBaim and ui.get(Menu_Reference.ForceBaim) then
        renderer.text(x-10+Cache.Scope_spacer, y+12+Spacer, 225, 225, 225, 255, "-", 100, "BAIM")
        Spacer = Spacer + 10
    end
end

function Bodyyaw_indicator()
    if not ui.get(OceanMenu["Main"].OceanEnabler) then return end
    localplayer = entity.get_local_player()
    if not entity.is_alive(localplayer) then return end
	if not ui.get(OceanMenu["Visuals"].Body_Yaw_indicator) then return end

    x, y = client.screen_size()
    Width = (x / 2)
    Height = (y / 2)
    desync = math.min(57, math.abs(entity.get_prop(localplayer, "m_flPoseParameter", 11) * 120 - 60))
    ddesync = entity.get_prop(entity.get_local_player(), 'm_flPoseParameter', 11) * 120 - 60
    D_side = ddesync > 3
    TRed,TGreen, TBlue, TAlpha = ui.get(OceanMenu["Visuals"].Body_Yaw_indicator_color)
    if ui.get(OceanMenu["Visuals"].Body_Yaw_indicator_Desync) == true then
        CRed = 255 - desync * 2.29824561404
        CGreen = desync * 3.42105263158
        CBlue = desync * 0.22807017543
        CAlpha = 255
    else
        CRed, CGreen, CBlue, CAlpha = ui.get(OceanMenu["Visuals"].Body_Yaw_indicator_color)
    end
    
    if ui.get(OceanMenu["Visuals"].Body_Yaw_indicator_Invert)==false then
        if ui.get(OceanMenu["Visuals"].Body_Yaw_indicator_selections) == "⮜ - ⮞" then
            Left_Side = "⮜"
            Right_Side = "⮞"
            Render_Flag = "b+"
            Render_Minus = 0
        elseif ui.get(OceanMenu["Visuals"].Body_Yaw_indicator_selections) == "◀ - ▶" then
            Left_Side = "◀"
            Right_Side = "▶"
            Render_Flag = "b"
            Render_Minus = 9
        elseif ui.get(OceanMenu["Visuals"].Body_Yaw_indicator_selections) == "◃ - ▹" then
            Left_Side = "◃"
            Right_Side = "▹"
            Render_Flag = "b+"
            Render_Minus = 0
        elseif ui.get(OceanMenu["Visuals"].Body_Yaw_indicator_selections) == "— - —" then
            Left_Side = "➖"
            Right_Side = "➖"
            Render_Flag = "b"
            Render_Minus = 10
        end
    else
        if ui.get(OceanMenu["Visuals"].Body_Yaw_indicator_selections) == "⮜ - ⮞" then
            Right_Side = "⮞"
            Left_Side = "⮜"
            Render_Flag = "b+"
            Render_Minus = 0
        elseif ui.get(OceanMenu["Visuals"].Body_Yaw_indicator_selections) == "◀ - ▶" then
            Right_Side = "▶"
            Left_Side = "◀"
            Render_Flag = "b"
            Render_Minus = 9
        elseif ui.get(OceanMenu["Visuals"].Body_Yaw_indicator_selections) == "◃ - ▹" then
            Right_Side = "▹"
            Left_Side = "◃"
            Render_Flag = "b+"
            Render_Minus = 0
        elseif ui.get(OceanMenu["Visuals"].Body_Yaw_indicator_selections) == "— - —" then
            Right_Side = "➖"
            Left_Side = "➖"
            Render_Flag = "b"
            Render_Minus = 10
        end
    end


    if ui.get(OceanMenu["Visuals"].Body_Yaw_indicator_Invert)==false then
        if D_side == false then
            renderer.text(Width - 65, Height - 16.5 + Render_Minus, CRed, CGreen, CBlue, CAlpha, Render_Flag, 0, Left_Side)
        elseif D_side == true then
            renderer.text(Width + 50, Height - 16.5 + Render_Minus, CRed, CGreen, CBlue, CAlpha, Render_Flag, 0, Right_Side)
        end
    else
        if D_side == true then
            renderer.text(Width - 65, Height - 16.5 + Render_Minus, CRed, CGreen, CBlue, CAlpha, Render_Flag, 0, Left_Side)
        elseif D_side == false then
            renderer.text(Width + 50, Height - 16.5 + Render_Minus, CRed, CGreen, CBlue, CAlpha, Render_Flag, 0, Right_Side)
        end
    end
    
end

function CustomScope()
    FR = table_contains(ui.get(OceanMenu["Visuals"].First_Person), "Remove scope overlay")
    F = table_contains(ui.get(OceanMenu["Visuals"].First_Person), "Custom Scope Zoom")
    TR = table_contains(ui.get(OceanMenu["Visuals"].Third_Person), "Remove scope overlay")
    T = table_contains(ui.get(OceanMenu["Visuals"].Third_Person), "Custom Scope Zoom")
   
    if ui.get(OceanMenu["Visuals"].Custom_Scope) then

        Scope = entity.get_prop(entity.get_local_player(), 'm_bIsScoped', 11)

        if ui.get(Menu_Reference.Thirdperson[1]) and ui.get(Menu_Reference.Thirdperson[2]) then
            if TR then
                ui.set(Menu_Reference.RemoveScope, true)
            else
                ui.set(Menu_Reference.RemoveScope, false)
            end
            if T then
                ui.set(Menu_Reference.ScopeZoom, ui.get(OceanMenu["Visuals"].Third_Person_Zoom))
            end
        else
            if FR then
                ui.set(Menu_Reference.RemoveScope, true)
            else
                ui.set(Menu_Reference.RemoveScope, false)
            end
            if F then
                ui.set(Menu_Reference.ScopeZoom, ui.get(OceanMenu["Visuals"].First_Person_Zoom))
            end
        end
    end
end

function rectangle_outline(x, y, w, h, r, g, b, a, s)
	renderer.rectangle(x, y, w, s, r, g, b, a)
	renderer.rectangle(x, y+h-s, w, s, r, g, b, a)
	renderer.rectangle(x, y+s, s, h-s*2, r, g, b, a)
	renderer.rectangle(x+w-s, y+s, s, h-s*2, r, g, b, a)
end

function inverse_lerp(a, b, weight)
    return (weight - a) / (b - a)
end

function shadow(x, y, w, h, r, g, b, a, thinkness, radius)
	if thinkness == nil or thinkness < 1 then
		thinkness = 1;
	end

	if radius == nil or radius < 0 then
		radius = 0;
	end

	local limit = math.min(w * 0.5, h * 0.5);

	radius = math.min(limit, radius);
	thinkness = thinkness + radius;

	local rd = radius * 2;
	x, y, w, h = x + radius - 1, y + radius - 1, w - rd + 2, h - rd + 2;

	local factor = 1;
	local step = inverse_lerp(radius, thinkness, radius + 1);

	for k = radius, thinkness do
	  local kd = k * 2;
	  local rounding = radius == 0 and radius or k;

	  rectangle_outline(x - k, y - k, w + kd, h + kd, r, g, b, a * factor / 3, 1, rounding);
	  factor = factor - step;
	end
end

function Watermark()
    if not ui.get(OceanMenu["Main"].OceanEnabler) then return end
    x, y = client.screen_size()
    r, g, b, a = ui.get(OceanMenu["Visuals"].Watermark_color)
    water_name =  gradient_text(r, g, b, 255, 255, 255, 255, 255, 'Ocean.Tech')
    fps = math.floor(1 / globals.absoluteframetime() + 0.5)
    ping = math.floor(math.min(1000, client.latency() * 1000) + 0.5)
    hours, minutes, seconds = client.system_time()
    time = string.format("%02d:%02d:%02d", hours, minutes, seconds)

    if ui.get(OceanMenu["Visuals"].Watermark) and ui.get(OceanMenu["Visuals"].Watermark_select) == "Modern" and entity.get_local_player() then
        shadow(x - 193, y - y + 10, 188, 20, r, g, b, 255, 3, 0)
        shadow(x - 265, y - y + 10, 64.9, 20, r, g, b, 255, 3, 0)
        renderer.gradient(x - 193, y - y + 10, 188, 20, 16, 16, 20, a, 23, 23, 28, a, true)
        renderer.gradient(x - 265, y - y + 10, 64.9, 20, 16, 16, 20, a, 23, 23, 28, a, true)
        renderer.text(x - 261   , y - y + 14, r, g, b, 255, nil, 100, water_name)
        renderer.text(x - 190, y - y + 14, 255, 255, 255, 255, nil, 100, "Fps: ",fps)
        renderer.text(x - 145, y - y + 14, 255, 255, 255, 255, nil, 100, "| Ping: ",ping)
        renderer.text(x - 95, y - y + 14, 255, 255, 255, 255, nil, 100, " | Time: ",time)
              --renderer.rectangle(x - 193, y - y + 10, 188, 3, r, g, b, 255)
              --renderer.rectangle(x - 265, y - y + 10, 64, 3, r, g, b, 255)
    end

    if ui.get(OceanMenu["Visuals"].Watermark) and ui.get(OceanMenu["Visuals"].Watermark_select) == "Legacy" and entity.get_local_player() then
        renderer.gradient(x - 193, y - y + 10, 188, 20, 26, 26, 30, a, 33, 33, 38, a, true)
        renderer.gradient(x - 265, y - y + 10, 64.9, 20, 26, 26, 30, a, 33, 33, 38, a, true)
        renderer.rectangle(x - 265, y - y + 10, 64, 3, r, g, b, 255)
        renderer.rectangle(x - 193, y - y + 10, 188, 3, r, g, b, 255)
        renderer.text(x - 260, y - y + 15, r, g, b, 255, nil, 100, water_name)
        renderer.text(x - 190, y - y + 15, 255, 255, 255, 255, nil, 100, "Fps: ",fps)
        renderer.text(x - 145, y - y + 15, 255, 255, 255, 255, nil, 100, "| Ping: ",ping)
        renderer.text(x - 95, y - y + 15, 255, 255, 255, 255, nil, 100, " | Time: ",time)
    end
end

--LYNX HITPREDICTION
local function calculateVectorAngles(vector1, vector2)
    local vectorA, vectorB
    if vector2 == nil then
        vectorB, vectorA = vector1, vector(client.eye_position())
        if vectorA.x == nil then
            return
        end
    else
        vectorA, vectorB = vector1, vector2
    end
    local vectorDiff = vectorB - vectorA
    if vectorDiff.x == 0 and vectorDiff.y == 0 then
        return 0, vectorDiff.z > 0 and 270 or 90
    else
        local angleY = math.deg(math.atan2(vectorDiff.y, vectorDiff.x))
        local hypotenuse = math.sqrt(vectorDiff.x * vectorDiff.x + vectorDiff.y * vectorDiff.y)
        local angleX = math.deg(math.atan2(-vectorDiff.z, hypotenuse))
        return angleX, angleY
    end
end

-- Function to check overlap
local function checkOverlap(object1, object2)
    if object1 and not object2 then
        return object1
    elseif not object1 and object2 then
        return object2
    end
    if object1.is_active and object2.is_active then
        if object1.length < object2.length then
            object2.is_active = false
            return object1
        elseif object1.length > object2.length then
            object1.is_active = false
            return object2
        end
    else
        return object1.is_active and object1 or object2
    end
end

-- Function to scan side
local function scanSide(entityIndex, origin, target, direction, position, side)
    local scanLength, hitFraction, counter = 15, 0, 0
    local previousPosition = position
    while hitFraction < 1 and scanLength < scan_length do
        position = origin + direction * scanLength
        _, hitFraction = client.trace_bullet(entityIndex, target.x, target.y, target.z, position.x, position.y, position.z)
        scanLength = scanLength + scan_width

		local fraction, entity_index = client.trace_line( entity.get_local_player(),
			previousPosition.x, previousPosition.y, previousPosition.z,
			position.x, position.y, position.z
		)
        if fraction < 1 and counter > 4 then
            return nil
        end
        previousPosition = position
        counter = counter + 1
    end
    return scanLength <= scan_length and {is_active = true, vector = position, index = entityIndex, length = scanLength, side = side} or nil
end

-- Function to calculate right angle
local function calculateRightAngle(angle)
    local sinX = math.sin(math.rad(angle.x))
    local cosX = math.cos(math.rad(angle.x))
    local sinY = math.sin(math.rad(angle.y))
    local cosY = math.cos(math.rad(angle.y))
    local sinZ = math.sin(math.rad(angle.z))
    local cosZ = math.cos(math.rad(angle.z))
    return vector(-1.0 * sinZ * sinX * cosY + -1.0 * cosZ * -sinY, -1.0 * sinZ * sinX * sinY + -1.0 * cosZ * cosY, -1.0 * sinZ * cosX)
end

-- Function to get scan result
local function getScanResult(entityIndex)
    if entityIndex == -1 then
        return nil
    end
    if not entity.is_alive(entityIndex) or not entity.is_enemy(entityIndex) then
        return nil
    end
    local localPlayer = entity.get_local_player()
    local eyePosition = vector(client.eye_position())
    local localOrigin = vector(entity.get_origin(localPlayer))
    local entityOrigin = vector(entity.get_prop(entityIndex, "m_vecOrigin"))
    local entityView = entityOrigin + vector(entity.get_prop(entityIndex, "m_vecViewOffset"))
    local angleX, angleY = calculateVectorAngles(localOrigin, entityOrigin)
    local angleVector = vector(angleX, angleY, 0)
    local rightAngleVector = calculateRightAngle(angleVector)
    local leftAngleVector = rightAngleVector*-1
    local leftPosition = eyePosition + leftAngleVector * scan_width
    local rightPosition = eyePosition + rightAngleVector * scan_width
    local hitboxPosition = vector(entity.hitbox_position(localPlayer, 1))
    local _, hitFraction = client.trace_bullet(entityIndex, entityView.x, entityView.y, entityView.z, hitboxPosition.x, hitboxPosition.y, hitboxPosition.z)
    if hitFraction <= 0 then
        local leftScan = scanSide(entityIndex, eyePosition, entityView, leftAngleVector, leftPosition, "left")
        local rightScan = scanSide(entityIndex, eyePosition, entityView, rightAngleVector, rightPosition, "right")
        return (leftScan or rightScan) and checkOverlap(leftScan, rightScan) or nil
    else
        return nil
    end
end

-- Define main functions
local function angleScan()
    local target = client.current_threat()
	if not target then return end

    local target_result = getScanResult(target)
    local t_scan_result = getScanResult(scan_result and scan_result.index or -1)      

    if not t_scan_result and target_result then
        scan_result = target_result
    elseif t_scan_result and target_result then   
        scan_result = target_result.length < t_scan_result.length and target_result or t_scan_result
    elseif not t_scan_result and not target_result then
        scan_result = nil
    end
end

local function drawHitLines()
    if not scan_result then return end

    local local_player  = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then return end

    local local_origin  = vector(entity.get_origin(local_player))
	local target = client.current_threat()
	if target == nil then return end
	local target_name = entity.get_player_name(target)
	local target_health = entity.get_prop(target, 'm_iHealth')


    local tr, tg, tb, ta = ui.get(OceanMenu["Visuals"].LynxHitprediction_color)
    local lr, lg, lb, la = ui.get(OceanMenu["Visuals"].LynxHitprediction_color2)

    local pos = scan_result.vector
    local xl, yl = renderer.world_to_screen(pos.x, pos.y, pos.z)

    if ui.get(OceanMenu["Visuals"].LynxHitprediction_Selection) == "Hit" then
        Draw_Text = "Hit"
    elseif ui.get(OceanMenu["Visuals"].LynxHitprediction_Selection) == "Name" then
        Draw_Text = target_name
    elseif ui.get(OceanMenu["Visuals"].LynxHitprediction_Selection) == "Name(Health)" then
        Draw_Text = target_name.."("..target_health..")"
    end

    if xl ~= nil and yl ~= nil then
        local x, y = renderer.world_to_screen(pos.x, pos.y, local_origin.z)
        renderer.text(xl, yl - 15, tr, tg, tb, ta, "bcd", 0, Draw_Text)
        renderer.line(xl, yl, x, y, lr, lg, lb, la)    
    end
end

local function paint()
	local local_player = entity.get_local_player()
	if not local_player then return end
    
    local is_alive = entity.is_alive(local_player)
    if not is_alive then return end

    scan_width, scan_length = 2 * 2, 4 * 40

    drawHitLines()
end


local function on_enable()
	local enabled = ui.get(OceanMenu["Visuals"].LynxHitprediction)
	local call = client[enabled and 'set_event_callback' or 'unset_event_callback']
	call('paint', paint)
	call('run_command', angleScan)
end
ui.set_callback(OceanMenu["Visuals"].LynxHitprediction, on_enable)
--END

--Misc
--FFI Chat PRINT

ffi.cdef[[
typedef void***(__thiscall* FindHudElement_t)(void*, const char*);
typedef void(__cdecl* ChatPrintf_t)(void*, int, int, const char*, ...);
]]
local signature_gHud = "\xB9\xCC\xCC\xCC\xCC\x88\x46\x09"
local signature_FindElement = "\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x57\x8B\xF9\x33\xF6\x39\x77\x28"
local match = client.find_signature("client_panorama.dll", signature_gHud) or error("sig1 not found")
local hud = ffi.cast("void**", ffi.cast("char*", match) + 1)[0] or error("hud is nil")
match = client.find_signature("client_panorama.dll", signature_FindElement) or error("FindHudElement not found")
local find_hud_element = ffi.cast("FindHudElement_t", match)
local hudchat = find_hud_element(hud, "CHudChat") or error("CHudChat not found")
local chudchat_vtbl = hudchat[0] or error("CHudChat instance vtable is nil")
local print_to_chat = ffi.cast("ChatPrintf_t", chudchat_vtbl[27])

local function print_chat(text)
    print_to_chat(hudchat, 0, 0, text)
end

lua_log = function(...) 
    --0, 157, 196
    r, g, b = ui.get(Menu_Reference.Menu_color)
    client.color_log(255, 255, 255, "[\0")
    client.color_log(r, g, b, "Ocean\0")
    client.color_log(255, 255, 255, ".Tech]\0")
    local arg_index = 1
    while select(arg_index, ...) ~= nil do
        client.color_log(217, 217, 217, " ", select(arg_index, ...), "\0")
        arg_index = arg_index + 1
    end
    client.color_log(217, 217, 217, " ")
end


local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}

function aim_fire(e)
    Cache.Shot_Hitbox = hitgroup_names[e.hitgroup + 1] or '?'
    Cache.Shot_TargetName = entity.get_player_name(e.target)
    Cache.Shot_Hitchance = math.floor(e.hit_chance + 0.5)
    Cache.Shot_Backtrack = time_to_ticks(e.backtrack)
    Cache.Shot_Damage = e.damage
end

function aim_hit(e)
    Hit_Hitbox = hitgroup_names[e.hitgroup + 1] or '?'
    Hit_TargetName = entity.get_player_name(e.target)
    Hit_Hitchance = math.floor(e.hit_chance + 0.5)
    Hit_Damage = e.damage
    Hit_HP = entity.get_prop(e.target, 'm_iHealth')
    Percent = "%"
    if Hit_HP > 0 then 
        Hit_HPLEFT = Hit_HP.." health remaining"
    else
        Hit_HPLEFT = "Dead"
    end
    if Hit_HP > 0 then 
        Hit_HPLEFTC = "\x07"..Hit_HP.."\x01 health remaining"
    else
        Hit_HPLEFTC = "\x07Dead\x01"
    end
    if ui.get(OceanMenu["Aimbot"].Roll_Enable) then
        Cache.brutestate = false
    end
    if ui.get(OceanMenu["Misc"].EventLogs) and table_contains(ui.get(OceanMenu["Misc"].EventLogs_Output), "Console") then
        if Hit_Hitbox ~= Cache.Shot_Hitbox or Hit_Damage ~= Cache.Shot_Damage then
            lua_log(string.format("Hit %s's %s(%s) for %d(%d) with (%s%s hc) (%s)", Hit_TargetName, Hit_Hitbox, Cache.Shot_Hitbox, Hit_Damage, Cache.Shot_Damage, Cache.Shot_Hitchance, Percent, Hit_HPLEFT))
        else
            lua_log(string.format("Hit %s's %s for %d with (%s%s hc) (%s)", Hit_TargetName, Hit_Hitbox, Hit_Damage, Cache.Shot_Hitchance, Percent, Hit_HPLEFT))
        end
    end
    if ui.get(OceanMenu["Misc"].EventLogs) and table_contains(ui.get(OceanMenu["Misc"].EventLogs_Output), "Chat") then
        print_chat(string.format("[\x0bOcean\x01.Tech\x01] Hit \x07%s\x01 in \x07%s\x01 for \x07%d\x01 (%s)", Hit_TargetName, Hit_Hitbox, Hit_Damage, Hit_HPLEFTC))
    end

end

function aim_miss(e)
    Miss_TargetName = entity.get_player_name(e.target)
    Miss_Hitbox = hitgroup_names[e.hitgroup + 1] or '?'
    Miss_Hitchance = math.floor(e.hit_chance + 0.5)
    Miss_Reason = e.reason
    if Miss_Reason == "spread" then
        Cache.brutestate = Cache.brutestate
    else
        if Cache.brutestate == true then
            Cache.brutestate = false
        elseif Cache.brutestate == false then
            Cache.brutestate = true
        end
    end
    if ui.get(OceanMenu["Misc"].EventLogs) and table_contains(ui.get(OceanMenu["Misc"].EventLogs_Output), "Console") then
        if Miss_Hitbox ~= Cache.Shot_Hitbox then
            lua_log(string.format("Missed %s's %s(%s) for %d with (%s%s hc) due to %s", Miss_TargetName, Miss_Hitbox, Cache.Shot_Hitbox, Cache.Shot_Damage, Miss_Hitchance, Percent, Miss_Reason))
        else
            lua_log(string.format("Missed %s's %s for %d with (%s%s hc) due to %s", Miss_TargetName, Miss_Hitbox, Cache.Shot_Damage, Miss_Hitchance, Percent, Miss_Reason))
        end
    end
    if ui.get(OceanMenu["Misc"].EventLogs) and table_contains(ui.get(OceanMenu["Misc"].EventLogs_Output), "Chat") then
        print_chat(string.format("[\x0bOcean\x01.Tech\x01] Missed \x07%s\x01's \x07%s\x01 due to \x07%s", Miss_TargetName, Miss_Hitbox, Miss_Reason))
    end
end

function Clantag()

    if ui.get(Menu_Reference.Clantag_Spammer) and can_ovr == true then
        ui.set(OceanMenu["Misc"].Clantag, "-")
        can_ovr = false
        can_ovvr = true
        can_ovvvr = true
    end

    if not ui.get(OceanMenu["Main"].OceanEnabler) then return end
    LocalPlayer = entity.get_local_player()
    N_tag = ui.get(OceanMenu["Misc"].Clantag) == "-"
    OT_tag = ui.get(OceanMenu["Misc"].Clantag) == "Ocean.Tech"
    OTS_tag = ui.get(OceanMenu["Misc"].Clantag) == "Ocean.Tech Static"
    Identifier = "🫷"
    curtime = math.floor(globals.curtime() * 2.75)
    if ui.get(OceanMenu["Misc"].Shared_Feature)then
        ui.set(Menu_Reference.sv_pure, true)
        can_ovvvr = true
    end
    if N_tag then
        if ui.get(OceanMenu["Misc"].Shared_Feature)then
            if not ui.get(Menu_Reference.Clantag_Spammer) then
                client.set_clan_tag("🫷")
                can_ovvvr = true
            end
           
        else
            if can_ovvvr == true then
                client.set_clan_tag("")
                can_ovvvr = false
            end
        end

    elseif OT_tag then
        if can_ovvr == true then
            ui.set(Menu_Reference.Clantag_Spammer, false)
            can_ovvr = false
        end
        can_ovvvr = true
        if ui.get(OceanMenu["Misc"].Shared_Feature) then
            if clantag.timer ~= curtime then
                client.set_clan_tag(clantag.Clantag1[curtime % #clantag.Clantag1 + 1])
                clantag.timer = curtime
            end
        else
            if clantag.timer ~= curtime then
                client.set_clan_tag(clantag.Clantag2[curtime % #clantag.Clantag2 + 1])
                clantag.timer = curtime
            end
        end
        can_ovr = true
    elseif OTS_tag then
        if can_ovvr == true then
            ui.set(Menu_Reference.Clantag_Spammer, false)
            can_ovvr = false
        end
        can_ovvvr = true
        if ui.get(OceanMenu["Misc"].Shared_Feature) then
            client.set_clan_tag(clantag.Clantag4[curtime % #clantag.Clantag4 + 1])
        else
            client.set_clan_tag(clantag.Clantag3[curtime % #clantag.Clantag3 + 1])
        end
        can_ovr = true
    end

    if clan_tag ~= clan_tag_prev then
        if ui.get(OceanMenu["Misc"].Shared_Feature)then
            client.set_clan_tag(clan_tag)
        else
            client.set_clan_tag(clan_tag)
        end
    end
    clan_tag_prev = clan_tag
    clantag_fix = true
end

local native_CreateDirectory = vtable_bind('filesystem_stdio.dll', 'VFileSystem017', 22, 'void(__thiscall*)(void*, const char*, const char*)')
local writedir = function(path, pathID)
    native_CreateDirectory(({path:gsub('/', '\\')})[1], pathID)
end
local has_image = readfile('csgo/materials/panorama/images/icons/xp/level1315112.png')
function image_recursive()
    if not has_image then
        http.get('https://cdn.discordapp.com/attachments/825913505793441852/1115959775386161323/level1315112.png', function(success, response)
            if not success or response.status ~= 200 then
                client.delay_call(3, image_recursive)
            else
                writedir('/csgo/materials/panorama/images/icons/xp', 'GAME')
                writefile('csgo/materials/panorama/images/icons/xp/level1315112.png', response.body)
            end
        end)
    end
end
image_recursive()

function SharedIcon(c)
    Identifier = "🫷"
    if globals.tickcount() % 64 == 0 then
            for ent = 1, globals.maxplayers() do
                if entity.get_classname(ent) == 'CCSPlayer' then
                player_resource = entity.get_player_resource()
                user_detected = entity.get_prop(player_resource, 'm_szClan', ent)
                if user_detected and ui.get(OceanMenu["Misc"].Shared_Feature) and containsSymbol(user_detected, Identifier) then
                    entity.set_prop(player_resource, 'm_nPersonaDataPublicLevel', '1315112', ent)
                else
                    entity.set_prop(player_resource, 'm_nPersonaDataPublicLevel', '0', ent)
                end
            end
        end
    end
end

--Reset's 
function local_death(e)
    victim = client.userid_to_entindex(e.userid)
    localplayer = entity.get_local_player()
    if Cache.brutestate == true then
        if victim == localplayer then
            Cache.brutestate = false
        end
    end
    Cache.AA_Brute = false
end
function reset_globals()
	Aimbot_INFO.g_flFlashDurationCache = 0.0
	Aimbot_INFO.g_flLastFlashUpdate = 0.0
end
function on_player_spawn()
    reset_globals()
    Cache.AA_Brute = false
end
function on_round_start()
    if Cache.brutestate == true then
        Cache.brutestate = false
    end
    reset_globals()
    Cache.AA_Brute = false
end

--Callback AREA
client.set_event_callback("setup_command", function(cmd)
    GetState(cmd)
    OceanAntiAim(cmd)
    Fakelag(cmd)
    Other()
    RagebotBinds()
end)
client.set_event_callback("run_command", function(e)
    update_fov()
    if table_contains(ui.get(OceanMenu["Aimbot"].Disablers), "Through Smoke") and ui.get(OceanMenu["Aimbot"].Disablers_checkbox) then
        update_ignore_behind_smokes()
    end
    if table_contains(ui.get(OceanMenu["Aimbot"].Disablers), "While Flashed") and ui.get(OceanMenu["Aimbot"].Disablers_checkbox) then
        update_honor_flashbangs()
    end
    update_whitelist()
    ocean_prio()
    Cache.chokedcmds = e.chokedcommands
end)
client.set_event_callback("paint_ui", function()
    local_player = entity.get_local_player()
    LocalSideDetection(local_player)
    Enemy = client.current_threat()
    EnemySideDetection(Enemy)
    prio_flag()
    Watermark()
    FeatureIndicator()
    Crosshair_Indicator()
    Bodyyaw_indicator()
    CustomScope()
    SharedIcon()
    Clantag()
    Desync_Resolver()
    if ui.is_menu_open() then
        OceanMenu_visibility()
    end
    --retard check
    if ui.get(OceanMenu["Aimbot"].Min_Fov) >= ui.get(OceanMenu["Aimbot"].Max_Fov) then
        ui.set(OceanMenu["Aimbot"].Max_Fov, ui.get(OceanMenu["Aimbot"].Min_Fov))
    end


end)
client.set_event_callback("bullet_impact", function(e)
    bullet_impact(e)
end)
client.set_event_callback("net_update_start", function()
    Roll_Resolver()
end)
client.set_event_callback("aim_fire", function(e)
    aim_fire(e)
end)
client.set_event_callback("aim_hit", function(e)
    aim_hit(e)
end)
client.set_event_callback("aim_miss", function(e)
    aim_miss(e)
end)
client.set_event_callback("player_death", function(e)
    local_death(e)
end)
client.set_event_callback("player_spawned", function()
    on_player_spawn()
end)
client.set_event_callback("round_start", function()
    on_round_start()
end)
client.set_event_callback("shutdown", function()
    for i, v in pairs(ElementsToHide.Anti_Aimbot_Angles) do 
        ui.set_visible(v, true)
    end
    for g, u in pairs(ElementsToHide.Fake_Lag) do 
        ui.set_visible(u, true)
    end
    for r, h in pairs(ElementsToHide.Other) do 
        ui.set_visible(h, true)
    end
    if globals.mapname() == nil then Cache.Is_Valve_Server = 0 end
    Is_MM = ffi.cast("bool*", Cache.GameRule[0] + 124)
    if Is_MM ~= nil then
        if Is_MM[0] == false and Cache.Is_Valve_Server == 1 then
            Is_MM[0] = 1
            Cache.Is_Valve_Server = 0
        end
    end
    ui.set_visible(Menu_Reference.Def_feature, true)
end)