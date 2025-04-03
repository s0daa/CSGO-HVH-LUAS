--[[
    TO-DO LIST
    -  diff min dmg on specific hitbox


]]



ffi.cdef [[
    typedef int(__thiscall* get_clipboard_text_count)(void*);
    typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
    typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]
local LUA_BUILD = "Beta"


--- @region: Menu Elements
local MENU_ELEMENT = {
    
    --[[0]] SELECT_TABS = menu.add_list("Settings", "Tab Selection", {"Rage Bot", "Anti Aim", "Visuals","Misc"}),


    -- Anti Aim
        --Anti Aim Builder
            --Global 
            GLOBAL = {
                --[[1]] ANTIAIM_OVERRIDE = menu.add_checkbox("Anti Aim Builder", "Override Global"),
                --[[2]] ANTIAIM_YAWBASE = menu.add_selection("Anti Aim Builder", "Yaw Add Type", {"None","View Angle","At Target (Crosshair)","At Target (Distance)","Velocity"}),
                --[[3]] ANTIAIM_YAWADD = menu.add_selection("Anti Aim Builder", "Yaw Add Type", {"Default","Advanced"}),
                --[[3]] ANTIAIM_YAWADD_DEFAULT = menu.add_slider("Anti Aim Builder", "Yaw Add", -180, 180),
                --[[4]] ANTIAIM_YAWADD_LEFT = menu.add_slider("Anti Aim Builder", "Left Yaw Add", -180, 180),
                --[[5]] ANTIAIM_YAWADD_RIGHT = menu.add_slider("Anti Aim Builder", "Right Yaw Add", -180, 180),
                --[[6]] ANTIAIM_JITTER_TYPE = menu.add_selection("Anti Aim Builder", "Jitter Type", {"Offset","Center"}),
                --[[7]] ANTIAIM_JITTER_ADD = menu.add_slider("Anti Aim Builder", "Jitter Add", -180, 180),
                --[[8]] ANTIAIM_BODYLEAN_TYPE = menu.add_selection("Anti Aim Builder", "Body Lean Type", {"None","Static","Static Jitter","Random Jitter","Sway"}),                
                --[[9]] ANTIAIM_BODYLEAN_STATIC = menu.add_slider("Anti Aim Builder", "Body Lean Value", -180, 180),  
                --[[10]] ANTIAIM_BODYLEAN_JITTER = menu.add_slider("Anti Aim Builder", "Body Lean Jitter", 0, 100),    
                --[[11]] ANTIAIM_BODYLEAN_MOVING = menu.add_checkbox("Anti Aim Builder", "Moving Body Lean"),                             
                --[[12]] ANTIAIM_DESYNC_SIDE = menu.add_selection("Anti Aim Builder", "Desync Side", {"None","Left","Right","Jitter","Peek Fake", "Peek Real"}),    
                --[[13]] ANTIAIM_DESYNC_AMOUNT_TYPE = menu.add_selection("Anti Aim Builder", "Desync Amount Type", {"Default","Advanced"}), 
                --[[14]] ANTIAIM_DESYNC_DEFAULT = menu.add_slider("Anti Aim Builder", "Desync Amount", 0, 100),
                --[[15]] ANTIAIM_DESYNC_LEFT = menu.add_slider("Anti Aim Builder", "Left Desync Amount", 0, 100),
                --[[16]] ANTIAIM_DESYNC_RIGHT = menu.add_slider("Anti Aim Builder", "Right Desync Amount", 0, 100),     
                --[[17]] FAKELAG_ENABLE= menu.add_checkbox("Anti Aim Builder", "Override FakeLag "),
                --[[18]] FAKELAG_TYPE = menu.add_selection("Anti Aim Builder", "Fake Lag Type", {"Default","Random between","Switch between"}),                 
                --[[19]] FAKELAG_AMOUNT_1 = menu.add_slider("Anti Aim Builder", "Fake Lag Amount", 0, 15),
                --[[20]] FAKELAG_AMOUNT_2 = menu.add_slider("Anti Aim Builder", "Fake Lag Amount 2", 0, 15),
            },
            STANDING = {
                --[[21]] ANTIAIM_OVERRIDE = menu.add_checkbox("Anti Aim Builder", "Override Standing"),
                --[[22]] ANTIAIM_YAWBASE = menu.add_selection("Anti Aim Builder", "Yaw Add Type", {"None","View Angle","At Target (Crosshair)","At Target (Distance)","Velocity"}),
                --[[23]] ANTIAIM_YAWADD = menu.add_selection("Anti Aim Builder", "Yaw Add Type", {"Default","Advanced"}),
                --[[24]] ANTIAIM_YAWADD_DEFAULT = menu.add_slider("Anti Aim Builder", "Yaw Add", -180, 180),
                --[[25]] ANTIAIM_YAWADD_LEFT = menu.add_slider("Anti Aim Builder", "Left Yaw Add", -180, 180),
                --[[26]] ANTIAIM_YAWADD_RIGHT = menu.add_slider("Anti Aim Builder", "Right Yaw Add", -180, 180),
                --[[27]] ANTIAIM_JITTER_TYPE = menu.add_selection("Anti Aim Builder", "Jitter Type", {"Offset","Center"}),
                --[[28]] ANTIAIM_JITTER_ADD = menu.add_slider("Anti Aim Builder", "Jitter Add", -180, 180),
                --[[29]] ANTIAIM_BODYLEAN_TYPE = menu.add_selection("Anti Aim Builder", "Body Lean Type", {"None","Static","Static Jitter","Random Jitter","Sway"}),                
                --[[30]] ANTIAIM_BODYLEAN_STATIC = menu.add_slider("Anti Aim Builder", "Body Lean Value", -180, 180),  
                --[[31]] ANTIAIM_BODYLEAN_JITTER = menu.add_slider("Anti Aim Builder", "Body Lean Jitter", 0, 100),    
                --[[32]] ANTIAIM_BODYLEAN_MOVING = menu.add_checkbox("Anti Aim Builder", "Moving Body Lean"),                             
                --[[33]] ANTIAIM_DESYNC_SIDE = menu.add_selection("Anti Aim Builder", "Desync Side", {"None","Left","Right","Jitter","Peek Fake", "Peek Real"}),    
                --[[34]] ANTIAIM_DESYNC_AMOUNT_TYPE = menu.add_selection("Anti Aim Builder", "Desync Amount Type", {"Default","Advanced"}), 
                --[[35]] ANTIAIM_DESYNC_DEFAULT = menu.add_slider("Anti Aim Builder", "Desync Amount", 0, 100),
                --[[36]] ANTIAIM_DESYNC_LEFT = menu.add_slider("Anti Aim Builder", "Left Desync Amount", 0, 100),
                --[[37]] ANTIAIM_DESYNC_RIGHT = menu.add_slider("Anti Aim Builder", "Right Desync Amount", 0, 100),     
                --[[38]] FAKELAG_ENABLE= menu.add_checkbox("Anti Aim Builder", "Override FakeLag "),
                --[[39]] FAKELAG_TYPE = menu.add_selection("Anti Aim Builder", "Fake Lag Type", {"Default","Random between","Switch between"}),                 
                --[[40]] FAKELAG_AMOUNT_1 = menu.add_slider("Anti Aim Builder", "Fake Lag Amount", 0, 15),
                --[[41]] FAKELAG_AMOUNT_2 = menu.add_slider("Anti Aim Builder", "Fake Lag Amount 2", 0, 15),
            },
            RUNNING = {
                --[[42]] ANTIAIM_OVERRIDE = menu.add_checkbox("Anti Aim Builder", "Override Running"),
                --[[43]] ANTIAIM_YAWBASE = menu.add_selection("Anti Aim Builder", "Yaw Add Type", {"None","View Angle","At Target (Crosshair)","At Target (Distance)","Velocity"}),
                --[[44]] ANTIAIM_YAWADD = menu.add_selection("Anti Aim Builder", "Yaw Add Type", {"Default","Advanced"}),
                --[[45]] ANTIAIM_YAWADD_DEFAULT = menu.add_slider("Anti Aim Builder", "Yaw Add", -180, 180),
                --[[46]] ANTIAIM_YAWADD_LEFT = menu.add_slider("Anti Aim Builder", "Left Yaw Add", -180, 180),
                --[[47]] ANTIAIM_YAWADD_RIGHT = menu.add_slider("Anti Aim Builder", "Right Yaw Add", -180, 180),
                --[[48]] ANTIAIM_JITTER_TYPE = menu.add_selection("Anti Aim Builder", "Jitter Type", {"Offset","Center"}),
                --[[49]] ANTIAIM_JITTER_ADD = menu.add_slider("Anti Aim Builder", "Jitter Add", -180, 180),
                --[[50]] ANTIAIM_BODYLEAN_TYPE = menu.add_selection("Anti Aim Builder", "Body Lean Type", {"None","Static","Static Jitter","Random Jitter","Sway"}),                
                --[[51]] ANTIAIM_BODYLEAN_STATIC = menu.add_slider("Anti Aim Builder", "Body Lean Value", -180, 180),  
                --[[52]] ANTIAIM_BODYLEAN_JITTER = menu.add_slider("Anti Aim Builder", "Body Lean Jitter", 0, 100),    
                --[[53]] ANTIAIM_BODYLEAN_MOVING = menu.add_checkbox("Anti Aim Builder", "Moving Body Lean"),                             
                --[[54]] ANTIAIM_DESYNC_SIDE = menu.add_selection("Anti Aim Builder", "Desync Side", {"None","Left","Right","Jitter","Peek Fake", "Peek Real"}),    
                --[[55]] ANTIAIM_DESYNC_AMOUNT_TYPE = menu.add_selection("Anti Aim Builder", "Desync Amount Type", {"Default","Advanced"}), 
                --[[56]] ANTIAIM_DESYNC_DEFAULT = menu.add_slider("Anti Aim Builder", "Desync Amount", 0, 100),
                --[[58]] ANTIAIM_DESYNC_LEFT = menu.add_slider("Anti Aim Builder", "Left Desync Amount", 0, 100),
                --[[59]] ANTIAIM_DESYNC_RIGHT = menu.add_slider("Anti Aim Builder", "Right Desync Amount", 0, 100),     
                --[[60]] FAKELAG_ENABLE= menu.add_checkbox("Anti Aim Builder", "Override FakeLag "),
                --[[61]] FAKELAG_TYPE = menu.add_selection("Anti Aim Builder", "Fake Lag Type", {"Default","Random between","Switch between"}),                 
                --[[62]] FAKELAG_AMOUNT_1 = menu.add_slider("Anti Aim Builder", "Fake Lag Amount", 0, 15),
                --[[63]] FAKELAG_AMOUNT_2 = menu.add_slider("Anti Aim Builder", "Fake Lag Amount 2", 0, 15),
            },
            WALKING = {
                --[[64]] ANTIAIM_OVERRIDE = menu.add_checkbox("Anti Aim Builder", "Override Walking"),
                --[[65]] ANTIAIM_YAWBASE = menu.add_selection("Anti Aim Builder", "Yaw Add Type", {"None","View Angle","At Target (Crosshair)","At Target (Distance)","Velocity"}),
                --[[66]] ANTIAIM_YAWADD = menu.add_selection("Anti Aim Builder", "Yaw Add Type", {"Default","Advanced"}),
                --[[67]] ANTIAIM_YAWADD_DEFAULT = menu.add_slider("Anti Aim Builder", "Yaw Add", -180, 180),
                --[[68]] ANTIAIM_YAWADD_LEFT = menu.add_slider("Anti Aim Builder", "Left Yaw Add", -180, 180),
                --[[69]] ANTIAIM_YAWADD_RIGHT = menu.add_slider("Anti Aim Builder", "Right Yaw Add", -180, 180),
                --[[70]] ANTIAIM_JITTER_TYPE = menu.add_selection("Anti Aim Builder", "Jitter Type", {"Offset","Center"}),
                --[[71]] ANTIAIM_JITTER_ADD = menu.add_slider("Anti Aim Builder", "Jitter Add", -180, 180),
                --[[72]] ANTIAIM_BODYLEAN_TYPE = menu.add_selection("Anti Aim Builder", "Body Lean Type", {"None","Static","Static Jitter","Random Jitter","Sway"}),                
                --[[73]] ANTIAIM_BODYLEAN_STATIC = menu.add_slider("Anti Aim Builder", "Body Lean Value", -180, 180),  
                --[[74]] ANTIAIM_BODYLEAN_JITTER = menu.add_slider("Anti Aim Builder", "Body Lean Jitter", 0, 100),    
                --[[75]] ANTIAIM_BODYLEAN_MOVING = menu.add_checkbox("Anti Aim Builder", "Moving Body Lean"),                             
                --[[76]] ANTIAIM_DESYNC_SIDE = menu.add_selection("Anti Aim Builder", "Desync Side", {"None","Left","Right","Jitter","Peek Fake", "Peek Real"}),    
                --[[78]] ANTIAIM_DESYNC_AMOUNT_TYPE = menu.add_selection("Anti Aim Builder", "Desync Amount Type", {"Default","Random between","Switch between"}), 
                --[[79]] ANTIAIM_DESYNC_DEFAULT = menu.add_slider("Anti Aim Builder", "Desync Amount", 0, 100),
                --[[80]] ANTIAIM_DESYNC_LEFT = menu.add_slider("Anti Aim Builder", "Left Desync Amount", 0, 100),
                --[[81]] ANTIAIM_DESYNC_RIGHT = menu.add_slider("Anti Aim Builder", "Right Desync Amount", 0, 100),     
                --[[82]] FAKELAG_ENABLE= menu.add_checkbox("Anti Aim Builder", "Override FakeLag "),
                --[[83]] FAKELAG_TYPE = menu.add_selection("Anti Aim Builder", "Fake Lag Type", {"Default","Random between","Switch between"}),                 
                --[[84]] FAKELAG_AMOUNT_1 = menu.add_slider("Anti Aim Builder", "Fake Lag Amount", 0, 15),
                --[[85]] FAKELAG_AMOUNT_2 = menu.add_slider("Anti Aim Builder", "Fake Lag Amount 2", 0, 15),
            },
            JUMPING = {
                --[[86]] ANTIAIM_OVERRIDE = menu.add_checkbox("Anti Aim Builder", "Override Jumping"),
                --[[87]] ANTIAIM_YAWBASE = menu.add_selection("Anti Aim Builder", "Yaw Add Type", {"None","View Angle","At Target (Crosshair)","At Target (Distance)","Velocity"}),
                --[[88]] ANTIAIM_YAWADD = menu.add_selection("Anti Aim Builder", "Yaw Add Type", {"Default","Advanced"}),
                --[[89]] ANTIAIM_YAWADD_DEFAULT = menu.add_slider("Anti Aim Builder", "Yaw Add", -180, 180),
                --[[90]] ANTIAIM_YAWADD_LEFT = menu.add_slider("Anti Aim Builder", "Left Yaw Add", -180, 180),
                --[[91]] ANTIAIM_YAWADD_RIGHT = menu.add_slider("Anti Aim Builder", "Right Yaw Add", -180, 180),
                --[[92]] ANTIAIM_JITTER_TYPE = menu.add_selection("Anti Aim Builder", "Jitter Type", {"Offset","Center"}),
                --[[93]] ANTIAIM_JITTER_ADD = menu.add_slider("Anti Aim Builder", "Jitter Add", -180, 180),
                --[[94]] ANTIAIM_BODYLEAN_TYPE = menu.add_selection("Anti Aim Builder", "Body Lean Type", {"None","Static","Static Jitter","Random Jitter","Sway"}),                
                --[[95]] ANTIAIM_BODYLEAN_STATIC = menu.add_slider("Anti Aim Builder", "Body Lean Value", -180, 180),  
                --[[96]] ANTIAIM_BODYLEAN_JITTER = menu.add_slider("Anti Aim Builder", "Body Lean Jitter", 0, 100),    
                --[[97]] ANTIAIM_BODYLEAN_MOVING = menu.add_checkbox("Anti Aim Builder", "Moving Body Lean"),                             
                --[[98]] ANTIAIM_DESYNC_SIDE = menu.add_selection("Anti Aim Builder", "Desync Side", {"None","Left","Right","Jitter","Peek Fake", "Peek Real"}),    
                --[[99]] ANTIAIM_DESYNC_AMOUNT_TYPE = menu.add_selection("Anti Aim Builder", "Desync Amount Type", {"Default","Advanced"}), 
                --[[100]] ANTIAIM_DESYNC_DEFAULT = menu.add_slider("Anti Aim Builder", "Desync Amount", 0, 100),
                --[[101]] ANTIAIM_DESYNC_LEFT = menu.add_slider("Anti Aim Builder", "Left Desync Amount", 0, 100),
                --[[102]] ANTIAIM_DESYNC_RIGHT = menu.add_slider("Anti Aim Builder", "Right Desync Amount", 0, 100),     
                --[[103]] FAKELAG_ENABLE= menu.add_checkbox("Anti Aim Builder", "Override FakeLag "),
                --[[104]] FAKELAG_TYPE = menu.add_selection("Anti Aim Builder", "Fake Lag Type", {"Default","Random between","Switch between"}),                 
                --[[105]] FAKELAG_AMOUNT_1 = menu.add_slider("Anti Aim Builder", "Fake Lag Amount", 0, 15),
                --[[106]] FAKELAG_AMOUNT_2 = menu.add_slider("Anti Aim Builder", "Fake Lag Amount 2", 0, 15),
            },
            CROUCHING = {
                --[[107]] ANTIAIM_OVERRIDE = menu.add_checkbox("Anti Aim Builder", "Override Crouching"),
                --[[108]] ANTIAIM_YAWBASE = menu.add_selection("Anti Aim Builder", "Yaw Add Type", {"None","View Angle","At Target (Crosshair)","At Target (Distance)","Velocity"}),
                --[[109]] ANTIAIM_YAWADD = menu.add_selection("Anti Aim Builder", "Yaw Add Type", {"Default","Advanced"}),
                --[[110]] ANTIAIM_YAWADD_DEFAULT = menu.add_slider("Anti Aim Builder", "Yaw Add", -180, 180),
                --[[111]] ANTIAIM_YAWADD_LEFT = menu.add_slider("Anti Aim Builder", "Left Yaw Add", -180, 180),
                --[[112]] ANTIAIM_YAWADD_RIGHT = menu.add_slider("Anti Aim Builder", "Right Yaw Add", -180, 180),
                --[[113]] ANTIAIM_JITTER_TYPE = menu.add_selection("Anti Aim Builder", "Jitter Type", {"Offset","Center"}),
                --[[114]] ANTIAIM_JITTER_ADD = menu.add_slider("Anti Aim Builder", "Jitter Add", -180, 180),
                --[[115]] ANTIAIM_BODYLEAN_TYPE = menu.add_selection("Anti Aim Builder", "Body Lean Type", {"None","Static","Static Jitter","Random Jitter","Sway"}),                
                --[[116]] ANTIAIM_BODYLEAN_STATIC = menu.add_slider("Anti Aim Builder", "Body Lean Value", -180, 180),  
                --[[117]] ANTIAIM_BODYLEAN_JITTER = menu.add_slider("Anti Aim Builder", "Body Lean Jitter", 0, 100),    
                --[[118]] ANTIAIM_BODYLEAN_MOVING = menu.add_checkbox("Anti Aim Builder", "Moving Body Lean"),                             
                --[[119]] ANTIAIM_DESYNC_SIDE = menu.add_selection("Anti Aim Builder", "Desync Side", {"None","Left","Right","Jitter","Peek Fake", "Peek Real"}),    
                --[[120]] ANTIAIM_DESYNC_AMOUNT_TYPE = menu.add_selection("Anti Aim Builder", "Desync Amount Type", {"Default","Advanced"}), 
                --[[121]] ANTIAIM_DESYNC_DEFAULT = menu.add_slider("Anti Aim Builder", "Desync Amount", 0, 100),
                --[[122]] ANTIAIM_DESYNC_LEFT = menu.add_slider("Anti Aim Builder", "Left Desync Amount", 0, 100),
                --[[123]] ANTIAIM_DESYNC_RIGHT = menu.add_slider("Anti Aim Builder", "Right Desync Amount", 0, 100),     
                --[[124]] FAKELAG_ENABLE= menu.add_checkbox("Anti Aim Builder", "Override FakeLag "),
                --[[125]] FAKELAG_TYPE = menu.add_selection("Anti Aim Builder", "Fake Lag Type", {"Default","Random between","Switch between"}),                 
                --[[126]] FAKELAG_AMOUNT_1 = menu.add_slider("Anti Aim Builder", "Fake Lag Amount", 0, 15),
                --[[127]] FAKELAG_AMOUNT_2 = menu.add_slider("Anti Aim Builder", "Fake Lag Amount 2", 0, 15),
            },
        --[[107]] ANTIAIM_ENABLE = menu.add_checkbox("Anti Aim", "Enable AntiAim"),
        --[[0]] ANTIAIM_SELECT_TABS = menu.add_selection("Anti Aim", "Condition Selection", {"None","Global","Standing", "Running", "Walking","Jumping", "Crouching"}),

 


        --

    -- Visuals 
    --[[108]] CUSTOM_FONT_ENABLE = menu.add_checkbox("Visuals", "Custom ESP Font (might cause bugs and unstable fps)"),
    --[[109 ]] ANIMATIONBREAKERS = menu.add_multi_selection("Visuals", "Animation Breakers", {"Static Legs In Air", "Zero Pitch On Land", "Static Legs On Walk","Reversed Legs","Lean Body"}),


    --[[110 ]] TELEPORT = menu.add_checkbox("Misc", "Teleport On Key"),

            RAGE = {
            --[[111 ]]    CUSTOMDT_CHECK                = menu.add_checkbox("Rage Bot", "Override Doubletap", false),
            --[[112 ]]    CUSTOMDT_SPEED                = menu.add_slider("Rage Bot", "Doubletap Speed", 10, 22),
            --[[113 ]]    CUSTOMDT_CORRECTIONS          = menu.add_checkbox("Rage Bot", "Disable Clock Corrections", false),
            --[[114 ]]    RECHARGE_CHECK                = menu.add_checkbox("Rage Bot", "[Beta] Ussain Bold Recharge", false),
            --[[115 ]]    DISABLEINTERP_CHECK           = menu.add_checkbox("Rage Bot", "Disable Interpolation", false),
            --[[139 ]]    PREDICTION_CHECK              = menu.add_checkbox("Rage Bot", "Prediction Improvements (testing)", false),
            --[[140 ]]    CUSTOMMINDMG_HPP_CHECK        = menu.add_checkbox("Rage Bot", "[Beta] Enable HP+ Minimum Damage", false),
            --[[141 ]]    CUSTOMMINDMG_HPP_SELECTION    = menu.add_multi_selection("Rage Bot", "[Beta] Enable Safepoint Hitboxes",{"Scout","Awp"}),
            --[[142 ]]    CUSTOMMINDMG_HPP_SLIDER_SCOUT = menu.add_slider("Rage Bot", "[Beta] HP+ Value Scout", 0, 20),
            --[[143 ]]    CUSTOMMINDMG_HPP_SLIDER_AWP = menu.add_slider("Rage Bot", "[Beta] HP+ Value Awp", 0, 20),
            },

    -- Config
    CONFIG_IMPORT = menu.add_button("Settings", "Import Config",function() configs.import() end),
    CONFIG_EXPORT = menu.add_button("Settings", "Export Config",function() configs.export() end),
    CONFIG_LOADDEFAULT = menu.add_button("Settings", "Load Default Config",function() configs.default() end),
}
--- @endregion

--- @region: Menu Finds
local MENU_FIND = {
    ACCENT_COLOR = menu.find("misc","main","personalization","accent color")[2],

    ANTIAIM_ENABLE = menu.find("antiaim", "main", "general", "enable"),
    PITCH = menu.find("antiaim", "main", "angles", "pitch"),
    YAW_BASE = menu.find("antiaim", "main", "angles", "yaw base"),
    YAW_ADD = menu.find("antiaim", "main", "angles", "yaw add"),

    ROTATE = menu.find("antiaim", "main", "angles", "rotate"),
    ROTATE_RANGE = menu.find("antiaim", "main", "angles", "rotate range"),
    ROTATE_SPEED = menu.find("antiaim", "main", "angles", "rotate speed"),

    JITTER_MODE = menu.find("antiaim", "main", "angles", "jitter mode"),
    JITTER_TYPE = menu.find("antiaim", "main", "angles", "jitter type"),
    JITTER_ADD = menu.find("antiaim", "main", "angles", "jitter add"),

    BODY_LEAN = menu.find("antiaim", "main", "angles", "body lean"),
    BODY_LEAN_VALUE = menu.find("antiaim", "main", "angles", "body lean value"),
    BODY_LEAN_JITTER = menu.find("antiaim", "main", "angles", "body lean jitter"),
    BODY_LEAN_MOVING = menu.find("antiaim", "main", "angles", "moving body lean"),

    SIDE_STANDING = menu.find("antiaim", "main", "desync","side#stand"),
    LEFT_AMOUNT_STANDING = menu.find("antiaim", "main", "desync","left amount#stand"),
    RIGHT_AMOUNT_STANDING = menu.find("antiaim", "main", "desync","right amount#stand"),

    SIDE_MOVING = menu.find("antiaim", "main", "desync","side#move"),
    LEFT_AMOUNT_MOVING = menu.find("antiaim", "main", "desync","left amount#move"),
    RIGHT_AMOUNT_MOVING = menu.find("antiaim", "main", "desync","right amount#move"),

    SIDE_WALKING = menu.find("antiaim", "main", "desync","side#slow walk"),
    LEFT_AMOUNT_WALKING = menu.find("antiaim", "main", "desync","left amount#slow walk"),
    RIGHT_AMOUNT_WALKING = menu.find("antiaim", "main", "desync","right amount#slow walk"),

    FAKELAG_AMOUNT = menu.find("antiaim", "main", "fakelag", "amount"),
    SLOWWALK_KEY        = menu.find("misc", "main", "movement", "slow walk"       )[2]
}
--- @endregion




--- @region: ESP
local ESP_FONT = render.create_font("Verdana", 11, 310, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local ESP_FONT_SMALL = render.create_font("Verdana Bold", 6, 100, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local function on_player_esp(gayporn)
    if MENU_ELEMENT.CUSTOM_FONT_ENABLE:get() then
        gayporn:set_font(ESP_FONT)
        gayporn:set_small_font(ESP_FONT_SMALL)
    end
end


local function inQuad(t, b, c, d)
    t = t / d
    return c * (t*t) + b
end


local INDICATOR_FONT      = render.create_font("Small Fonts", 10, 100, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE)
local SCREEN_SIZE = render.get_screen_size()
local x, y           = SCREEN_SIZE.x / 2, SCREEN_SIZE.y / 2
local x2, y2           = SCREEN_SIZE.x / 2, SCREEN_SIZE.y / 2
local x3, y3           = SCREEN_SIZE.x / 2, SCREEN_SIZE.y / 2
local x4, y4           = SCREEN_SIZE.x / 2, SCREEN_SIZE.y / 2
local x5, y5           = SCREEN_SIZE.x / 2, SCREEN_SIZE.y / 2
local REFDT = menu.find('aimbot', 'general', 'exploits', 'doubletap', 'enable')[2]
local REFHS = menu.find('aimbot', 'general', 'exploits', 'hideshots', 'enable')[2]
local REFAP = menu.find('aimbot', 'general', 'misc', 'autopeek')[2]
local REFFL = menu.find("antiaim", "main", "fakelag", "amount")

local ENABLE_INDICATORS = menu.add_checkbox("Visuals", "Enable Indicators") --[[117]]
local Y_ADD = menu.add_slider("Visuals", "Indicator Y Add", 1, 200) --[[117]]
local ACCENT_COLOR = ENABLE_INDICATORS:add_color_picker("color")

local function indicators()

    local ETERNITY_LENGHT = render.get_text_size(INDICATOR_FONT, "eternity")
    local BETA_LENGHT = render.get_text_size(INDICATOR_FONT, "beta")
    local DT_LENGHT = render.get_text_size(INDICATOR_FONT, "DT")
    local HS_LENGHT = render.get_text_size(INDICATOR_FONT, "HS")
    local FL_LENGHT = render.get_text_size(INDICATOR_FONT, "FL")
    local AP_LENGHT = render.get_text_size(INDICATOR_FONT, "PEEK")
    local DMG_LENGHT = render.get_text_size(INDICATOR_FONT, "DMG")
    local ACTIVE_KEYS = 1 

    local CHOKE_VALUE = REFFL:get()
    local CHOKE = 0
    local CHARGE_PERCENTAGE = 0
    
    if CHOKE_VALUE == 0 then
        CHOKE = 0.01
    elseif CHOKE_VALUE == 1 then
        CHOKE = 0.5
    elseif CHOKE_VALUE == 2 then
        CHOKE = 0.1
    elseif CHOKE_VALUE == 3 then
        CHOKE = 0.15
    elseif CHOKE_VALUE == 4 then
        CHOKE = 0.2
    elseif CHOKE_VALUE == 5 then
        CHOKE = 0.25
    elseif CHOKE_VALUE == 6 then
        CHOKE = 0.3
    elseif CHOKE_VALUE == 7 then
        CHOKE = 0.35
    elseif CHOKE_VALUE == 8 then
        CHOKE = 0.4 
    elseif CHOKE_VALUE == 9 then
        CHOKE = 0.45 
    elseif CHOKE_VALUE == 10 then
        CHOKE = 0.5 
    elseif CHOKE_VALUE == 11 then
        CHOKE = 0.55 
    elseif CHOKE_VALUE == 12 then
        CHOKE = 0.65
    elseif CHOKE_VALUE == 13 then
        CHOKE = 0.75
    elseif CHOKE_VALUE == 14 then
        CHOKE = 0.85  
    elseif CHOKE_VALUE == 15 then
        CHOKE = 0.99
    end

    if exploits.get_charge() == 0 then
        CHARGE_PERCENTAGE = 0.0
    elseif exploits.get_charge() == 1 then
        CHARGE_PERCENTAGE = 0.1
    elseif exploits.get_charge() == 2 then
        CHARGE_PERCENTAGE = 0.2
    elseif exploits.get_charge() == 3 then
        CHARGE_PERCENTAGE = 0.3
    elseif exploits.get_charge() == 4 then
        CHARGE_PERCENTAGE = 0.35
    elseif exploits.get_charge() == 5 then
        CHARGE_PERCENTAGE = 0.4
    elseif exploits.get_charge() == 6 then
        CHARGE_PERCENTAGE = 0.45
    elseif exploits.get_charge() == 7 then
        CHARGE_PERCENTAGE = 0.5
    elseif exploits.get_charge() == 8 then
        CHARGE_PERCENTAGE = 0.6 
    elseif exploits.get_charge() == 9 then
        CHARGE_PERCENTAGE = 0.7 
    elseif exploits.get_charge() == 10 then
        CHARGE_PERCENTAGE = 0.8 
    elseif exploits.get_charge() == 11 then
        CHARGE_PERCENTAGE = 0.85 
    elseif exploits.get_charge() == 12 then
        CHARGE_PERCENTAGE = 0.9
    elseif exploits.get_charge() == 13 then
        CHARGE_PERCENTAGE = 0.95
    elseif exploits.get_charge() == 14 then
        CHARGE_PERCENTAGE = 0.99   
    end
    

    render.text(INDICATOR_FONT, "eternity", vec2_t(x - ETERNITY_LENGHT.x / 2 - BETA_LENGHT.x / 2, y + 10 +  Y_ADD:get()), color_t(255, 255, 255, 255)) 
    render.text(INDICATOR_FONT, "BETA", vec2_t(x - ETERNITY_LENGHT.x / 2 + ETERNITY_LENGHT.x + 2  - BETA_LENGHT.x / 2 , y + 10 +  Y_ADD:get()),ACCENT_COLOR:get())
    ACTIVE_KEYS = ACTIVE_KEYS + 1
    
    if REFDT:get() then 
        if exploits.get_charge() ~= 14 then
            render.text(INDICATOR_FONT, "DT", vec2_t(x4 - DT_LENGHT.x / 2 - 3, y4 +  (ACTIVE_KEYS*10) +  Y_ADD:get()), color_t(255, 0, 0, 200))
            render.progress_circle(vec2_t.new(x4 + DT_LENGHT.x / 2 + 2, y4 +  (ACTIVE_KEYS*10) +  Y_ADD:get() + 5.5 ), 2, color_t(255, 0, 0, 200), 1, CHARGE_PERCENTAGE)
            ACTIVE_KEYS = ACTIVE_KEYS + 1
        elseif exploits.get_charge() == 14 then   
            render.text(INDICATOR_FONT, "DT", vec2_t(x4 - DT_LENGHT.x / 2 - 3, y4 +  (ACTIVE_KEYS*10) +  Y_ADD:get()), ACCENT_COLOR:get())
            render.circle(vec2_t.new(x4 + DT_LENGHT.x / 2 + 2, y4 +  (ACTIVE_KEYS*10) +  Y_ADD:get() + 5.5),2, ACCENT_COLOR:get(),2)
            ACTIVE_KEYS = ACTIVE_KEYS + 1
        end
    end

    if REFHS:get() then
            render.text(INDICATOR_FONT, "HS", vec2_t(x2 - HS_LENGHT.x / 2, y2 +  (ACTIVE_KEYS*10) +  Y_ADD:get()), ACCENT_COLOR:get())
            ACTIVE_KEYS = ACTIVE_KEYS + 1
    end

    if not REFHS:get() and not REFDT:get() then
        render.text(INDICATOR_FONT, "FL", vec2_t(x4 - FL_LENGHT.x / 2 - 2, y4 +  (ACTIVE_KEYS*10) +  Y_ADD:get()), ACCENT_COLOR:get())
        render.progress_circle(vec2_t.new(x4 + FL_LENGHT.x / 2 + 2, y4 +  (ACTIVE_KEYS*10) +  Y_ADD:get() + 5.5 ), 2, ACCENT_COLOR:get(), 1, CHOKE)
        ACTIVE_KEYS = ACTIVE_KEYS + 1
    end

    if REFAP:get() then
        render.text(INDICATOR_FONT, "PEEK", vec2_t(x5 - AP_LENGHT.x / 2 , y5 +  (ACTIVE_KEYS*10)+  Y_ADD:get()), ACCENT_COLOR:get())
        ACTIVE_KEYS = ACTIVE_KEYS + 1
    end


    local player = entity_list.get_local_player()
    if player:get_prop("m_bIsScoped") == 1 then
        local final_pos = SCREEN_SIZE.x / 2 + 25 + BETA_LENGHT.x / 2
        local final_pos2 = SCREEN_SIZE.x / 2 +  ETERNITY_LENGHT.x / 2 - HS_LENGHT.x / 2 - 1
        local final_pos3 = SCREEN_SIZE.x / 2 +  ETERNITY_LENGHT.x / 2 - 1
        local final_pos4 = SCREEN_SIZE.x / 2 +  ETERNITY_LENGHT.x / 2 - DT_LENGHT.x / 2 + 1
        local final_pos5 = SCREEN_SIZE.x / 2 +  ETERNITY_LENGHT.x / 2 - 1

        x = inQuad(0.1, x, final_pos - x, 0.35)
        x2 = inQuad(0.1, x2, final_pos2 - x2, 0.35)
        x3 = inQuad(0.1, x3, final_pos3 - x3, 0.35)
        x4 = inQuad(0.1, x4, final_pos4 - x4, 0.35)
        x5 = inQuad(0.1, x5, final_pos5 - x5, 0.35)
    else
        local final_pos = SCREEN_SIZE.x / 2
        local final_pos2 = SCREEN_SIZE.x / 2
        local final_pos3 = SCREEN_SIZE.x / 2
        local final_pos4 = SCREEN_SIZE.x / 2
        local final_pos5 = SCREEN_SIZE.x / 2

        x = inQuad(0.1, x, final_pos - x, 0.35)
        x2 = inQuad(0.1, x2, final_pos2 - x2, 0.35)
        x3 = inQuad(0.1, x3, final_pos3 - x3, 0.35)
        x4 = inQuad(0.1, x3, final_pos4 - x3, 0.35)
        x5 = inQuad(0.1, x5, final_pos5 - x5, 0.35)
    end
end
--- @endregion

--- @region: Anti Aim
local condition = 1 
local function conditions() -- got the upvalues error so i made conditions in a seperate function
    local local_player          = entity_list.get_local_player()
    local velocity              = local_player:get_prop("m_vecVelocity"):length()   
    if velocity == 0 and not MENU_FIND.SLOWWALK_KEY:get() then  
        condition = 1 -- stand
    end
    if velocity > 1.1 and not MENU_FIND.SLOWWALK_KEY:get() then
        condition = 2 -- move
    end
    
    if MENU_FIND.SLOWWALK_KEY:get() then
        condition = 4 -- slow walk
    end
    

    if (not local_player:has_player_flag(e_player_flags.ON_GROUND)) then 
        condition = 3  -- air
    end 

    if  (local_player:has_player_flag(e_player_flags.DUCKING)) then 
      condition = 5 --crouch
    end

    if (local_player:has_player_flag(e_player_flags.DUCKING)) and (not local_player:has_player_flag(e_player_flags.ON_GROUND)) then  -- did this so crouching in air doesn't count as crouching condition
        condition = 3 -- air 
    end
end


local function AnitAimMain()
    conditions()
    
    if MENU_ELEMENT.ANTIAIM_ENABLE:get() then
        if condition == 1 then
            if MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get() then
                MENU_FIND.JITTER_MODE:set(2)
                MENU_FIND.YAW_BASE:set(MENU_ELEMENT.STANDING.ANTIAIM_YAWBASE:get())

                MENU_FIND.YAW_ADD:set(MENU_ELEMENT.STANDING.ANTIAIM_YAWADD:get())

                if MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:get() == 1 then
                    MENU_FIND.YAW_ADD:set(MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_DEFAULT:get())
                else
                    if antiaim.get_desync_side() == 2 then
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_RIGHT:get())
                    else
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_LEFT:get())
                    end
                end

                MENU_FIND.JITTER_TYPE:set(MENU_ELEMENT.STANDING.ANTIAIM_JITTER_TYPE:get())
                MENU_FIND.JITTER_ADD:set(MENU_ELEMENT.STANDING.ANTIAIM_JITTER_ADD:get())

                MENU_FIND.BODY_LEAN:set(MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_TYPE:get())

                if MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_TYPE:get() == 2 then        
                    MENU_FIND.BODY_LEAN_VALUE:set(MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_STATIC:get())
                elseif MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_TYPE:get() == 3 or 4 then
                    MENU_FIND.BODY_LEAN_JITTER:set(MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_JITTER:get()) 
                end 

                MENU_FIND.BODY_LEAN_MOVING:set(MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_MOVING:get())

                MENU_FIND.SIDE_STANDING:set(MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_SIDE:get())
                if MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_AMOUNT_TYPE:get() == 1 then
                    MENU_FIND.LEFT_AMOUNT_STANDING:set(MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_DEFAULT:get())
                    MENU_FIND.RIGHT_AMOUNT_STANDING:set(MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_DEFAULT:get())
                else
                    MENU_FIND.LEFT_AMOUNT_STANDING:set(MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_LEFT:get())
                    MENU_FIND.RIGHT_AMOUNT_STANDING:set(MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_RIGHT:get()) 
                end
            elseif MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get() then
                MENU_FIND.JITTER_MODE:set(2)
                MENU_FIND.YAW_BASE:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWBASE:get())

                MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:get())

                if MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:get() == 1 then
                    MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_DEFAULT:get())
                else
                    if antiaim.get_desync_side() == 2 then
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_RIGHT:get())
                    else
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_LEFT:get())
                    end
                end

                MENU_FIND.JITTER_TYPE:set(MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_TYPE:get())
                MENU_FIND.JITTER_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_ADD:get())

                MENU_FIND.BODY_LEAN:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get())

                if MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get() == 2 then        
                    MENU_FIND.BODY_LEAN_VALUE:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_STATIC:get())
                elseif MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get() == 3 or 4 then
                    MENU_FIND.BODY_LEAN_JITTER:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_JITTER:get()) 
                end 

                MENU_FIND.BODY_LEAN_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_MOVING:get())

                MENU_FIND.SIDE_STANDING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_SIDE:get())
                if MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_AMOUNT_TYPE:get() == 1 then
                    MENU_FIND.LEFT_AMOUNT_STANDING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_DEFAULT:get())
                    MENU_FIND.RIGHT_AMOUNT_STANDING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_DEFAULT:get())
                else
                    MENU_FIND.LEFT_AMOUNT_STANDING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_LEFT:get())
                    MENU_FIND.RIGHT_AMOUNT_STANDING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_RIGHT:get()) 
                end
            end
        elseif condition == 2 then
            if MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get() then
                MENU_FIND.JITTER_MODE:set(2)
                MENU_FIND.YAW_BASE:set(MENU_ELEMENT.RUNNING.ANTIAIM_YAWBASE:get())

                MENU_FIND.YAW_ADD:set(MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD:get())

                if MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:get() == 1 then
                    MENU_FIND.YAW_ADD:set(MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_DEFAULT:get())
                else
                    if antiaim.get_desync_side() == 2 then
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_RIGHT:get())
                    else
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_LEFT:get())
                    end
                end

                MENU_FIND.JITTER_TYPE:set(MENU_ELEMENT.RUNNING.ANTIAIM_JITTER_TYPE:get())
                MENU_FIND.JITTER_ADD:set(MENU_ELEMENT.RUNNING.ANTIAIM_JITTER_ADD:get())

                MENU_FIND.BODY_LEAN:set(MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_TYPE:get())

                if MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_TYPE:get() == 2 then        
                    MENU_FIND.BODY_LEAN_VALUE:set(MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_STATIC:get())
                elseif MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_TYPE:get() == 3 or 4 then
                    MENU_FIND.BODY_LEAN_JITTER:set(MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_JITTER:get()) 
                end 

                MENU_FIND.BODY_LEAN_MOVING:set(MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_MOVING:get())

                MENU_FIND.SIDE_MOVING:set(MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_SIDE:get())
                if MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_AMOUNT_TYPE:get() == 1 then
                    MENU_FIND.LEFT_AMOUNT_MOVING:set(MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_DEFAULT:get())
                    MENU_FIND.RIGHT_AMOUNT_MOVING:set(MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_DEFAULT:get())
                else
                    MENU_FIND.LEFT_AMOUNT_MOVING:set(MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_LEFT:get())
                    MENU_FIND.RIGHT_AMOUNT_MOVING:set(MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_RIGHT:get()) 
                end
            elseif MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get() then
                MENU_FIND.JITTER_MODE:set(2)
                 MENU_FIND.YAW_BASE:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWBASE:get())

                MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:get())

                if MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:get() == 1 then
                    MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_DEFAULT:get())
                else
                    if antiaim.get_desync_side() == 2 then
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_RIGHT:get())
                    else
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_LEFT:get())
                    end
                end

                MENU_FIND.JITTER_TYPE:set(MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_TYPE:get())
                MENU_FIND.JITTER_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_ADD:get())

                MENU_FIND.BODY_LEAN:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get())

                if MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get() == 2 then        
                    MENU_FIND.BODY_LEAN_VALUE:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_STATIC:get())
                elseif MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get() == 3 or 4 then
                    MENU_FIND.BODY_LEAN_JITTER:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_JITTER:get()) 
                end 

                MENU_FIND.BODY_LEAN_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_MOVING:get())

                MENU_FIND.SIDE_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_SIDE:get())
                if MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_AMOUNT_TYPE:get() == 1 then
                    MENU_FIND.LEFT_AMOUNT_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_DEFAULT:get())
                    MENU_FIND.RIGHT_AMOUNT_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_DEFAULT:get())
                else
                    MENU_FIND.LEFT_AMOUNT_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_LEFT:get())
                    MENU_FIND.RIGHT_AMOUNT_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_RIGHT:get()) 
                end
            end
        elseif condition == 3 then
            if MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get() then
                MENU_FIND.JITTER_MODE:set(2)
                MENU_FIND.YAW_BASE:set(MENU_ELEMENT.JUMPING.ANTIAIM_YAWBASE:get())

                MENU_FIND.YAW_ADD:set(MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD:get())

                if MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:get() == 1 then
                    MENU_FIND.YAW_ADD:set(MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_DEFAULT:get())
                else
                    if antiaim.get_desync_side() == 2 then
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_RIGHT:get())
                    else
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_LEFT:get())
                    end
                end

                MENU_FIND.JITTER_TYPE:set(MENU_ELEMENT.JUMPING.ANTIAIM_JITTER_TYPE:get())
                MENU_FIND.JITTER_ADD:set(MENU_ELEMENT.JUMPING.ANTIAIM_JITTER_ADD:get())

                MENU_FIND.BODY_LEAN:set(MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_TYPE:get())

                if MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_TYPE:get() == 2 then        
                    MENU_FIND.BODY_LEAN_VALUE:set(MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_STATIC:get())
                elseif MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_TYPE:get() == 3 or 4 then
                    MENU_FIND.BODY_LEAN_JITTER:set(MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_JITTER:get()) 
                end 

                MENU_FIND.BODY_LEAN_MOVING:set(MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_MOVING:get())

                MENU_FIND.SIDE_MOVING:set(MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_SIDE:get())
                if MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_AMOUNT_TYPE:get() == 1 then
                    MENU_FIND.LEFT_AMOUNT_MOVING:set(MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_DEFAULT:get())
                    MENU_FIND.RIGHT_AMOUNT_MOVING:set(MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_DEFAULT:get())
                else
                    MENU_FIND.LEFT_AMOUNT_MOVING:set(MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_LEFT:get())
                    MENU_FIND.RIGHT_AMOUNT_MOVING:set(MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_RIGHT:get()) 
                end
            elseif MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get() then
                MENU_FIND.JITTER_MODE:set(2)
                MENU_FIND.YAW_BASE:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWBASE:get())

                MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:get())

                if MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:get() == 1 then
                    MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_DEFAULT:get())
                else
                    if antiaim.get_desync_side() == 2 then
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_RIGHT:get())
                    else
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_LEFT:get())
                    end
                end

                MENU_FIND.JITTER_TYPE:set(MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_TYPE:get())
                MENU_FIND.JITTER_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_ADD:get())

                MENU_FIND.BODY_LEAN:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get())

                if MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get() == 2 then        
                    MENU_FIND.BODY_LEAN_VALUE:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_STATIC:get())
                elseif MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get() == 3 or 4 then
                    MENU_FIND.BODY_LEAN_JITTER:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_JITTER:get()) 
                end 

                MENU_FIND.BODY_LEAN_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_MOVING:get())

                MENU_FIND.SIDE_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_SIDE:get())
                if MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_AMOUNT_TYPE:get() == 1 then
                    MENU_FIND.LEFT_AMOUNT_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_DEFAULT:get())
                    MENU_FIND.RIGHT_AMOUNT_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_DEFAULT:get())
                else
                    MENU_FIND.LEFT_AMOUNT_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_LEFT:get())
                    MENU_FIND.RIGHT_AMOUNT_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_RIGHT:get()) 
                end
            end
        elseif condition == 4 then
            if MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get() then
                MENU_FIND.JITTER_MODE:set(2)
                MENU_FIND.YAW_BASE:set(MENU_ELEMENT.WALKING.ANTIAIM_YAWBASE:get())

                MENU_FIND.YAW_ADD:set(MENU_ELEMENT.WALKING.ANTIAIM_YAWADD:get())

                if MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:get() == 1 then
                    MENU_FIND.YAW_ADD:set(MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_DEFAULT:get())
                else
                    if antiaim.get_desync_side() == 2 then
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_RIGHT:get())
                    else
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_LEFT:get())
                    end
                end

                MENU_FIND.JITTER_TYPE:set(MENU_ELEMENT.WALKING.ANTIAIM_JITTER_TYPE:get())
                MENU_FIND.JITTER_ADD:set(MENU_ELEMENT.WALKING.ANTIAIM_JITTER_ADD:get())

                MENU_FIND.BODY_LEAN:set(MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_TYPE:get())

                if MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_TYPE:get() == 2 then        
                    MENU_FIND.BODY_LEAN_VALUE:set(MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_STATIC:get())
                elseif MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_TYPE:get() == 3 or 4 then
                    MENU_FIND.BODY_LEAN_JITTER:set(MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_JITTER:get()) 
                end 

                MENU_FIND.BODY_LEAN_MOVING:set(MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_MOVING:get())

                MENU_FIND.SIDE_WALKING:set(MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_SIDE:get())
                if MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_AMOUNT_TYPE:get() == 1 then
                    MENU_FIND.LEFT_AMOUNT_WALKING:set(MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_DEFAULT:get())
                    MENU_FIND.RIGHT_AMOUNT_WALKING:set(MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_DEFAULT:get())
                else
                    MENU_FIND.LEFT_AMOUNT_WALKING:set(MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_LEFT:get())
                    MENU_FIND.RIGHT_AMOUNT_WALKING:set(MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_RIGHT:get()) 
                end
            elseif MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get() then
                MENU_FIND.JITTER_MODE:set(2)
                MENU_FIND.YAW_BASE:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWBASE:get())

                MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:get())

                if MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:get() == 1 then
                    MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_DEFAULT:get())
                else
                    if antiaim.get_desync_side() == 2 then
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_RIGHT:get())
                    else
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_LEFT:get())
                    end
                end

                MENU_FIND.JITTER_TYPE:set(MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_TYPE:get())
                MENU_FIND.JITTER_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_ADD:get())

                MENU_FIND.BODY_LEAN:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get())

                if MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get() == 2 then        
                    MENU_FIND.BODY_LEAN_VALUE:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_STATIC:get())
                elseif MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get() == 3 or 4 then
                    MENU_FIND.BODY_LEAN_JITTER:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_JITTER:get()) 
                end 

                MENU_FIND.BODY_LEAN_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_MOVING:get())

                MENU_FIND.SIDE_WALKING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_SIDE:get())
                if MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_AMOUNT_TYPE:get() == 1 then
                    MENU_FIND.LEFT_AMOUNT_WALKING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_DEFAULT:get())
                    MENU_FIND.RIGHT_AMOUNT_WALKING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_DEFAULT:get())
                else
                    MENU_FIND.LEFT_AMOUNT_WALKING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_LEFT:get())
                    MENU_FIND.RIGHT_AMOUNT_WALKING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_RIGHT:get()) 
                end
            end
        elseif condition == 5 then
            if MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get() then
                MENU_FIND.JITTER_MODE:set(2)
                MENU_FIND.YAW_BASE:set(MENU_ELEMENT.CROUCHING.ANTIAIM_YAWBASE:get())

                MENU_FIND.YAW_ADD:set(MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD:get())

                if MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:get() == 1 then
                    MENU_FIND.YAW_ADD:set(MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_DEFAULT:get())
                else
                    if antiaim.get_desync_side() == 2 then
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_RIGHT:get())
                    else
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_LEFT:get())
                    end
                end

                MENU_FIND.JITTER_TYPE:set(MENU_ELEMENT.CROUCHING.ANTIAIM_JITTER_TYPE:get())
                MENU_FIND.JITTER_ADD:set(MENU_ELEMENT.CROUCHING.ANTIAIM_JITTER_ADD:get())

                MENU_FIND.BODY_LEAN:set(MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_TYPE:get())

                if MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_TYPE:get() == 2 then        
                    MENU_FIND.BODY_LEAN_VALUE:set(MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_STATIC:get())
                elseif MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_TYPE:get() == 3 or 4 then
                    MENU_FIND.BODY_LEAN_JITTER:set(MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_JITTER:get()) 
                end 

                MENU_FIND.BODY_LEAN_MOVING:set(MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_MOVING:get())

                MENU_FIND.SIDE_MOVING:set(MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_SIDE:get())
                if MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_AMOUNT_TYPE:get() == 1 then
                    MENU_FIND.LEFT_AMOUNT_MOVING:set(MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_DEFAULT:get())
                    MENU_FIND.RIGHT_AMOUNT_MOVING:set(MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_DEFAULT:get())
                else
                    MENU_FIND.LEFT_AMOUNT_MOVING:set(MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_LEFT:get())
                    MENU_FIND.RIGHT_AMOUNT_MOVING:set(MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_RIGHT:get()) 
                end
            elseif MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get() then
                MENU_FIND.JITTER_MODE:set(2)
                MENU_FIND.YAW_BASE:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWBASE:get())

                MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:get())

                if MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:get() == 1 then
                    MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_DEFAULT:get())
                else
                    if antiaim.get_desync_side() == 2 then
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_RIGHT:get())
                    else
                        MENU_FIND.YAW_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_LEFT:get())
                    end
                end

                MENU_FIND.JITTER_TYPE:set(MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_TYPE:get())
                MENU_FIND.JITTER_ADD:set(MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_ADD:get())

                MENU_FIND.BODY_LEAN:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get())

                if MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get() == 2 then        
                    MENU_FIND.BODY_LEAN_VALUE:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_STATIC:get())
                elseif MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get() == 3 or 4 then
                    MENU_FIND.BODY_LEAN_JITTER:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_JITTER:get()) 
                end 

                MENU_FIND.BODY_LEAN_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_MOVING:get())

                MENU_FIND.SIDE_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_SIDE:get())
                if MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_AMOUNT_TYPE:get() == 1 then
                    MENU_FIND.LEFT_AMOUNT_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_DEFAULT:get())
                    MENU_FIND.RIGHT_AMOUNT_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_DEFAULT:get())
                else
                    MENU_FIND.LEFT_AMOUNT_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_LEFT:get())
                    MENU_FIND.RIGHT_AMOUNT_MOVING:set(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_RIGHT:get()) 
                end
            end
        end
    end

end

--- @endregion


--- @region: fakelag
local function on_finish_command(cmd)
    -- if MENU_ELEMENT.FAKELAG_ENABLE:get() then
    --   MENU_FIND.FAKELAG_AMOUNT:set(math.random(MENU_ELEMENT.FAKELAG_AMOUNT_1:get(),MENU_ELEMENT.FAKELAG_AMOUNT_2:get()))
    -- end
    if condition == 1 then
        if MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get() then
            if MENU_ELEMENT.STANDING.FAKELAG_ENABLE:get() then
                if MENU_ELEMENT.STANDING.FAKELAG_ENABLE:get() then
                    if MENU_ELEMENT.STANDING.FAKELAG_TYPE:get() == 2 then
                        MENU_FIND.FAKELAG_AMOUNT:set(math.random(MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_1:get(),MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_2:get()))
                    elseif MENU_ELEMENT.STANDING.FAKELAG_TYPE:get() == 3 then
                        if MENU_FIND.FAKELAG_AMOUNT:get() == MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_1:get() then
                            MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_2:get())
                        else
                            MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_1:get())
                        end
                    else
                        MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_1:get())
                    end
                end
            end
        elseif MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get() then
            if MENU_ELEMENT.GLOBAL.FAKELAG_ENABLE:get() then
                if MENU_ELEMENT.GLOBAL.FAKELAG_TYPE:get() == 2 then
                    MENU_FIND.FAKELAG_AMOUNT:set(math.random(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get(),MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_2:get()))
                elseif MENU_ELEMENT.GLOBAL.FAKELAG_TYPE:get() == 3 then
                    if MENU_FIND.FAKELAG_AMOUNT:get() == MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get() then
                        MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_2:get())
                    else
                        MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get())
                    end
                else
                    MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get())
                end
            end
        end
    end
    if condition == 2 then
        if MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get() then
            if MENU_ELEMENT.RUNNING.FAKELAG_ENABLE:get() then
                if MENU_ELEMENT.RUNNING.FAKELAG_TYPE:get() == 2 then
                    MENU_FIND.FAKELAG_AMOUNT:set(math.random(MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_1:get(),MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_2:get()))
                elseif MENU_ELEMENT.RUNNING.FAKELAG_TYPE:get() == 3 then
                    if MENU_FIND.FAKELAG_AMOUNT:get() == MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_1:get() then
                        MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_2:get())
                    else
                        MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_1:get())
                    end
                else
                    MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_1:get())
                end
            end
        elseif MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get() then
            if MENU_ELEMENT.GLOBAL.FAKELAG_ENABLE:get() then
                if MENU_ELEMENT.GLOBAL.FAKELAG_TYPE:get() == 2 then
                    MENU_FIND.FAKELAG_AMOUNT:set(math.random(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get(),MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_2:get()))
                elseif MENU_ELEMENT.GLOBAL.FAKELAG_TYPE:get() == 3 then
                    if MENU_FIND.FAKELAG_AMOUNT:get() == MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get() then
                        MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_2:get())
                    else
                        MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get())
                    end
                else
                    MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get())
                end
            end
        end
    end
    if condition == 3 then
        if MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get() then
            if MENU_ELEMENT.JUMPING.FAKELAG_ENABLE:get() then
                if MENU_ELEMENT.JUMPING.FAKELAG_TYPE:get() == 2 then
                    MENU_FIND.FAKELAG_AMOUNT:set(math.random(MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_1:get(),MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_2:get()))
                elseif MENU_ELEMENT.JUMPING.FAKELAG_TYPE:get() == 3 then
                    if MENU_FIND.FAKELAG_AMOUNT:get() == MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_1:get() then
                        MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_2:get())
                    else
                        MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_1:get())
                    end
                else
                    MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_1:get())
                end
            end
        elseif MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get() then
            if MENU_ELEMENT.GLOBAL.FAKELAG_ENABLE:get() then
                if MENU_ELEMENT.GLOBAL.FAKELAG_TYPE:get() == 2 then
                    MENU_FIND.FAKELAG_AMOUNT:set(math.random(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get(),MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_2:get()))
                elseif MENU_ELEMENT.GLOBAL.FAKELAG_TYPE:get() == 3 then
                    if MENU_FIND.FAKELAG_AMOUNT:get() == MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get() then
                        MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_2:get())
                    else
                        MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get())
                    end
                else
                    MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get())
                end
            end
        end
    end
    if condition == 4 then
        if MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get() then
            if MENU_ELEMENT.WALKING.FAKELAG_ENABLE:get() then
                if MENU_ELEMENT.WALKING.FAKELAG_ENABLE:get() then
                    if MENU_ELEMENT.WALKING.FAKELAG_TYPE:get() == 2 then
                        MENU_FIND.FAKELAG_AMOUNT:set(math.random(MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_1:get(),MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_2:get()))
                    elseif MENU_ELEMENT.WALKING.FAKELAG_TYPE:get() == 3 then
                        if MENU_FIND.FAKELAG_AMOUNT:get() == MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_1:get() then
                            MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_2:get())
                        else
                            MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_1:get())
                        end
                    else
                        MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_1:get())
                    end
                end
            end
        elseif MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get() then
            if MENU_ELEMENT.GLOBAL.FAKELAG_ENABLE:get() then
                if MENU_ELEMENT.GLOBAL.FAKELAG_TYPE:get() == 2 then
                    MENU_FIND.FAKELAG_AMOUNT:set(math.random(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get(),MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_2:get()))
                elseif MENU_ELEMENT.GLOBAL.FAKELAG_TYPE:get() == 3 then
                    if MENU_FIND.FAKELAG_AMOUNT:get() == MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get() then
                        MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_2:get())
                    else
                        MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get())
                    end
                else
                    MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get())
                end
            end
        end
    end
    if condition == 5 then
        if MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get() then
            if MENU_ELEMENT.CROUCHING.FAKELAG_ENABLE:get() then
                if MENU_ELEMENT.CROUCHING.FAKELAG_TYPE:get() == 2 then
                    MENU_FIND.FAKELAG_AMOUNT:set(math.random(MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_1:get(),MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_2:get()))
                elseif MENU_ELEMENT.CROUCHING.FAKELAG_TYPE:get() == 3 then
                    if MENU_FIND.FAKELAG_AMOUNT:get() == MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_1:get() then
                        MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_2:get())
                    else
                        MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_1:get())
                    end
                else
                    MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_1:get())
                end
            end
        elseif MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get() then
            if MENU_ELEMENT.GLOBAL.FAKELAG_TYPE:get() == 2 then
                MENU_FIND.FAKELAG_AMOUNT:set(math.random(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get(),MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_2:get()))
            elseif MENU_ELEMENT.GLOBAL.FAKELAG_TYPE:get() == 3 then
                if MENU_FIND.FAKELAG_AMOUNT:get() == MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get() then
                    MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_2:get())
                else
                    MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get())
                end
            else
                MENU_FIND.FAKELAG_AMOUNT:set(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get())
            end
        end
    end

end

--- @endregion



--- @region: RAGE



local min_damage_s = menu.find("aimbot", "scout", "target overrides", "min. damage")
local min_damage_a = menu.find("aimbot", "awp", "target overrides", "min. damage")

local function on_hitscan(ctx, cmd, unpredicted_data)
   if MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_CHECK:get() then
        if MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SLIDER_SCOUT:get(1) and ragebot.get_active_cfg() == 1 and not min_damage_s[2]:get() then -- scout
            ctx:set_min_dmg(ctx.health + MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SLIDER_SCOUT:get())
        elseif MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SLIDER_SCOUT:get(2) and ragebot.get_active_cfg() == 2 and not min_damage_a[2]:get() then
            ctx:set_min_dmg(ctx.health + MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SLIDER_AWP:get())
        end  
    end
end

callbacks.add(e_callbacks.HITSCAN, on_hitscan)

local function customdt()
    if MENU_ELEMENT.RAGE.CUSTOMDT_CHECK:get() then
        cvars.sv_maxusrcmdprocessticks:set_int(MENU_ELEMENT.RAGE.CUSTOMDT_SPEED:get())
        if MENU_ELEMENT.RAGE.CUSTOMDT_CORRECTIONS:get() then
            cvars.cl_clock_correction:set_int(0)
        end
    elseif not MENU_ELEMENT.RAGE.CUSTOMDT_CHECK:get() then
        cvars.sv_maxusrcmdprocessticks:set_int(16)
        cvars.cl_clock_correction:set_int(1)
    end
end

-- faster recharge
local function fasterrecharge()
    if MENU_ELEMENT.RAGE.RECHARGE_CHECK:get() then
        exploits.force_recharge()
    end
end

-- interpolation
local function disableinterp()
    if MENU_ELEMENT.RAGE.DISABLEINTERP_CHECK:get() then
        cvars.cl_interpolate:set_int(0)
    else
        cvars.cl_interpolate:set_int(1)
    end
end

-- prediction
local function betterprediction()
    if MENU_ELEMENT.RAGE.PREDICTION_CHECK:get() then
        cvars.sv_maxupdaterate:set_int(128)
    else
        cvars.sv_maxupdaterate:set_int(64)
    end
end

--- @endregion


--- @item: Animation Breakers
local anim_breaker = {}

anim_breaker.ground_ticks = 1
anim_breaker.end_time = 0

function anim_breaker.handle(ctx)
	local player = entity_list.get_local_player()

	if (player == nil or not player:is_alive()) then
		return
	end

	local on_ground = player:has_player_flag(e_player_flags.ON_GROUND)

	if (MENU_ELEMENT.ANIMATIONBREAKERS:get(1)) then
		if (not on_ground) then
			ctx:set_render_pose(e_poses.JUMP_FALL, 1)
		end
	end

	if (MENU_ELEMENT.ANIMATIONBREAKERS:get(2)) then
		if (on_ground) then
			anim_breaker.ground_ticks = anim_breaker.ground_ticks + 1
		else
            anim_breaker.ground_ticks = 0
            anim_breaker.end_time = global_vars.cur_time() + 1
		end

		if (anim_breaker.ground_ticks > (MENU_FIND.FAKELAG_AMOUNT:get() + 1) and anim_breaker.end_time > global_vars.cur_time()) then
			ctx:set_render_pose(e_poses.BODY_PITCH, 0.5)
		end
	end

	if (MENU_ELEMENT.ANIMATIONBREAKERS:get(3)) then
		if (MENU_FIND.SLOWWALK_KEY:get()) then
			ctx:set_render_pose(e_poses.MOVE_BLEND_WALK, 0)
		end
	end

	if (MENU_ELEMENT.ANIMATIONBREAKERS:get(4)) then
		ctx:set_render_pose(e_poses.RUN, 0)
	end

	if (MENU_ELEMENT.ANIMATIONBREAKERS:get(5)) then
		if (not on_ground) then
			ctx:set_render_animlayer(e_animlayers.LEAN, 0.75, 1)
		end
	end
end
--- @endregion

--- @item: TELEPORT

TELEPORT_KEY  = MENU_ELEMENT.TELEPORT:add_keybind("Teleport")
local function TeleportOnKey()
	if TELEPORT_KEY:get() then
        exploits.force_uncharge()
        exploits.force_recharge()
	end
end





--- @endregion



--- @region: config 
local VGUI_System010 =  memory.create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
local VGUI_System = ffi.cast(ffi.typeof("void***"), VGUI_System010 )
local get_clipboard_text_count = ffi.cast("get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
local set_clipboard_text = ffi.cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
local get_clipboard_text = ffi.cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")

clipboard_import = function()
    local clipboard_text_length = get_clipboard_text_count(VGUI_System)
 
    if clipboard_text_length > 0 then
        local buffer = ffi.new("char[?]", clipboard_text_length)
        local size = clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length)
 
        get_clipboard_text(VGUI_System, 0, buffer, size )
 
        return ffi.string( buffer, clipboard_text_length-1)
    end

    return ""
end

local function clipboard_export(string)
    if string then
        set_clipboard_text(VGUI_System, string, string:len())
    end
end

local function str_to_sub(text, sep)
    local t = {}
    for str in string.gmatch(text, "([^"..sep.."]+)") do
        t[#t + 1] = string.gsub(str, "\n", " ")
    end
    return t
end

local function to_boolean(str)
    if str == "true" or str == "false" then
        return (str == "true")
    else
        return str
    end
end

configs = {}
configs.import = function(input)
    local protected = function()
        local clipboard = input == nil and clipboard_import() or input
        local tbl = str_to_sub(clipboard, "|")



            -- GLOBAL
            --[[1]] MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:set(to_boolean(tbl[1]))
            --[[2]] MENU_ELEMENT.GLOBAL.ANTIAIM_YAWBASE:set(tonumber(tbl[2]))
            --[[3]] MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:set(tonumber(tbl[3]))
            --[[3]] MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_DEFAULT:set(tonumber(tbl[4]))
            --[[4]] MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_LEFT:set(tonumber(tbl[5]))
            --[[5]] MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_RIGHT:set(tonumber(tbl[6]))
            --[[6]] MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_TYPE:set(tonumber(tbl[7]))
            --[[7]] MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_ADD:set(tonumber(tbl[8]))
            --[[8]] MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:set(tonumber(tbl[9]))                
            --[[9]] MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_STATIC:set(tonumber(tbl[10])) 
            --[[10]] MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_JITTER:set(tonumber(tbl[11]))  
            --[[11]] MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_MOVING:set(to_boolean(tbl[12]))                            
            --[[12]] MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_SIDE:set(tonumber(tbl[13]))
            --[[13]] MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_AMOUNT_TYPE:set(tonumber(tbl[14]))
            --[[14]] MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_DEFAULT:set(tonumber(tbl[15]))
            --[[15]] MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_LEFT:set(tonumber(tbl[16]))
            --[[16]] MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_RIGHT:set(tonumber(tbl[17]))    
            --[[17]] MENU_ELEMENT.GLOBAL.FAKELAG_ENABLE:set(to_boolean(tbl[18]))
            --[[18]] MENU_ELEMENT.GLOBAL.FAKELAG_TYPE:set(tonumber(tbl[19]))
            --[[19]] MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:set(tonumber(tbl[20]))
            --[[20]] MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_2:set(tonumber(tbl[21]))

            --[[1]] MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:set(to_boolean(tbl[22]))
            --[[2]] MENU_ELEMENT.STANDING.ANTIAIM_YAWBASE:set(tonumber(tbl[23]))
            --[[3]] MENU_ELEMENT.STANDING.ANTIAIM_YAWADD:set(tonumber(tbl[24]))
            --[[3]] MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_DEFAULT:set(tonumber(tbl[25]))
            --[[4]] MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_LEFT:set(tonumber(tbl[26]))
            --[[5]] MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_RIGHT:set(tonumber(tbl[27]))
            --[[6]] MENU_ELEMENT.STANDING.ANTIAIM_JITTER_TYPE:set(tonumber(tbl[28]))
            --[[7]] MENU_ELEMENT.STANDING.ANTIAIM_JITTER_ADD:set(tonumber(tbl[29]))
            --[[8]] MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_TYPE:set(tonumber(tbl[30]))                
            --[[9]] MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_STATIC:set(tonumber(tbl[31])) 
            --[[10]] MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_JITTER:set(tonumber(tbl[32]))  
            --[[11]] MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_MOVING:set(to_boolean(tbl[33]))                            
            --[[12]] MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_SIDE:set(tonumber(tbl[34]))
            --[[13]] MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_AMOUNT_TYPE:set(tonumber(tbl[35]))
            --[[14]] MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_DEFAULT:set(tonumber(tbl[36]))
            --[[15]] MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_LEFT:set(tonumber(tbl[37]))
            --[[16]] MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_RIGHT:set(tonumber(tbl[38]))    
            --[[17]] MENU_ELEMENT.STANDING.FAKELAG_ENABLE:set(to_boolean(tbl[39]))
            --[[18]] MENU_ELEMENT.STANDING.FAKELAG_TYPE:set(tonumber(tbl[40]))
            --[[19]] MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_1:set(tonumber(tbl[41]))
            --[[20]] MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_2:set(tonumber(tbl[42]))
            
            --[[1]] MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:set(to_boolean(tbl[43])) --RUNNING
            --[[2]] MENU_ELEMENT.RUNNING.ANTIAIM_YAWBASE:set(tonumber(tbl[44]))
            --[[3]] MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD:set(tonumber(tbl[45]))
            --[[3]] MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_DEFAULT:set(tonumber(tbl[46]))
            --[[4]] MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_LEFT:set(tonumber(tbl[47]))
            --[[5]] MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_RIGHT:set(tonumber(tbl[48]))
            --[[6]] MENU_ELEMENT.RUNNING.ANTIAIM_JITTER_TYPE:set(tonumber(tbl[49]))
            --[[7]] MENU_ELEMENT.RUNNING.ANTIAIM_JITTER_ADD:set(tonumber(tbl[50]))
            --[[8]] MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_TYPE:set(tonumber(tbl[51]))                
            --[[9]] MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_STATIC:set(tonumber(tbl[52])) 
            --[[10]] MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_JITTER:set(tonumber(tbl[53]))  
            --[[11]] MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_MOVING:set(to_boolean(tbl[54]))                            
            --[[12]] MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_SIDE:set(tonumber(tbl[55]))
            --[[13]] MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_AMOUNT_TYPE:set(tonumber(tbl[56]))
            --[[14]] MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_DEFAULT:set(tonumber(tbl[57]))
            --[[15]] MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_LEFT:set(tonumber(tbl[58]))
            --[[16]] MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_RIGHT:set(tonumber(tbl[59]))    
            --[[17]] MENU_ELEMENT.RUNNING.FAKELAG_ENABLE:set(to_boolean(tbl[60]))
            --[[18]] MENU_ELEMENT.RUNNING.FAKELAG_TYPE:set(tonumber(tbl[61]))
            --[[19]] MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_1:set(tonumber(tbl[62]))
            --[[20]] MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_2:set(tonumber(tbl[63]))

            --[[1]] MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:set(to_boolean(tbl[64]))
            --[[2]] MENU_ELEMENT.WALKING.ANTIAIM_YAWBASE:set(tonumber(tbl[65]))
            --[[3]] MENU_ELEMENT.WALKING.ANTIAIM_YAWADD:set(tonumber(tbl[66]))
            --[[3]] MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_DEFAULT:set(tonumber(tbl[67]))
            --[[4]] MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_LEFT:set(tonumber(tbl[68]))
            --[[5]] MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_RIGHT:set(tonumber(tbl[69]))
            --[[6]] MENU_ELEMENT.WALKING.ANTIAIM_JITTER_TYPE:set(tonumber(tbl[70]))
            --[[7]] MENU_ELEMENT.WALKING.ANTIAIM_JITTER_ADD:set(tonumber(tbl[71]))
            --[[8]] MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_TYPE:set(tonumber(tbl[72]))                
            --[[9]] MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_STATIC:set(tonumber(tbl[73])) 
            --[[10]] MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_JITTER:set(tonumber(tbl[74]))  
            --[[11]] MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_MOVING:set(to_boolean(tbl[75]))                            
            --[[12]] MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_SIDE:set(tonumber(tbl[76]))
            --[[13]] MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_AMOUNT_TYPE:set(tonumber(tbl[77]))
            --[[14]] MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_DEFAULT:set(tonumber(tbl[78]))
            --[[15]] MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_LEFT:set(tonumber(tbl[79]))
            --[[16]] MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_RIGHT:set(tonumber(tbl[80]))    
            --[[17]] MENU_ELEMENT.WALKING.FAKELAG_ENABLE:set(to_boolean(tbl[81]))
            --[[18]] MENU_ELEMENT.WALKING.FAKELAG_TYPE:set(tonumber(tbl[82]))
            --[[19]] MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_1:set(tonumber(tbl[83]))
            --[[20]] MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_2:set(tonumber(tbl[84]))

            --[[1]] MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:set(to_boolean(tbl[85]))
            --[[2]] MENU_ELEMENT.JUMPING.ANTIAIM_YAWBASE:set(tonumber(tbl[86]))
            --[[3]] MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD:set(tonumber(tbl[87]))
            --[[3]] MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_DEFAULT:set(tonumber(tbl[88]))
            --[[4]] MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_LEFT:set(tonumber(tbl[89]))
            --[[5]] MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_RIGHT:set(tonumber(tbl[90]))
            --[[6]] MENU_ELEMENT.JUMPING.ANTIAIM_JITTER_TYPE:set(tonumber(tbl[91]))
            --[[7]] MENU_ELEMENT.JUMPING.ANTIAIM_JITTER_ADD:set(tonumber(tbl[92]))
            --[[8]] MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_TYPE:set(tonumber(tbl[93]))                
            --[[9]] MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_STATIC:set(tonumber(tbl[94])) 
            --[[10]] MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_JITTER:set(tonumber(tbl[95]))  
            --[[11]] MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_MOVING:set(to_boolean(tbl[96]))                            
            --[[12]] MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_SIDE:set(tonumber(tbl[97]))
            --[[13]] MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_AMOUNT_TYPE:set(tonumber(tbl[98]))
            --[[14]] MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_DEFAULT:set(tonumber(tbl[99]))
            --[[15]] MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_LEFT:set(tonumber(tbl[100]))
            --[[16]] MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_RIGHT:set(tonumber(tbl[101]))    
            --[[17]] MENU_ELEMENT.JUMPING.FAKELAG_ENABLE:set(to_boolean(tbl[102]))
            --[[18]] MENU_ELEMENT.JUMPING.FAKELAG_TYPE:set(tonumber(tbl[103]))
            --[[19]] MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_1:set(tonumber(tbl[104]))
            --[[20]] MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_2:set(tonumber(tbl[105]))

            --[[1]] MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:set(to_boolean(tbl[106]))
            --[[2]] MENU_ELEMENT.CROUCHING.ANTIAIM_YAWBASE:set(tonumber(tbl[107]))
            --[[3]] MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD:set(tonumber(tbl[108]))
            --[[3]] MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_DEFAULT:set(tonumber(tbl[109]))
            --[[4]] MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_LEFT:set(tonumber(tbl[110]))
            --[[5]] MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_RIGHT:set(tonumber(tbl[111]))
            --[[6]] MENU_ELEMENT.CROUCHING.ANTIAIM_JITTER_TYPE:set(tonumber(tbl[112]))
            --[[7]] MENU_ELEMENT.CROUCHING.ANTIAIM_JITTER_ADD:set(tonumber(tbl[113]))
            --[[8]] MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_TYPE:set(tonumber(tbl[114]))                
            --[[9]] MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_STATIC:set(tonumber(tbl[115])) 
            --[[10]] MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_JITTER:set(tonumber(tbl[116]))  
            --[[11]] MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_MOVING:set(to_boolean(tbl[117]))                            
            --[[12]] MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_SIDE:set(tonumber(tbl[118]))
            --[[13]] MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_AMOUNT_TYPE:set(tonumber(tbl[119]))
            --[[14]] MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_DEFAULT:set(tonumber(tbl[120]))
            --[[15]] MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_LEFT:set(tonumber(tbl[121]))
            --[[16]] MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_RIGHT:set(tonumber(tbl[122]))    
            --[[17]] MENU_ELEMENT.CROUCHING.FAKELAG_ENABLE:set(to_boolean(tbl[123]))
            --[[18]] MENU_ELEMENT.CROUCHING.FAKELAG_TYPE:set(tonumber(tbl[124]))
            --[[19]] MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_1:set(tonumber(tbl[125]))
            --[[20]] MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_2:set(tonumber(tbl[126]))
                    MENU_ELEMENT.ANTIAIM_ENABLE:set(to_boolean(tbl[127])) 
                    MENU_ELEMENT.CUSTOM_FONT_ENABLE:set(to_boolean(tbl[128])) 
                    MENU_ELEMENT.ANIMATIONBREAKERS:set(1,to_boolean(tbl[129])) 
                    MENU_ELEMENT.ANIMATIONBREAKERS:set(2,to_boolean(tbl[129])) 
                    MENU_ELEMENT.ANIMATIONBREAKERS:set(3,to_boolean(tbl[129])) 
                    MENU_ELEMENT.ANIMATIONBREAKERS:set(4,to_boolean(tbl[129])) 
                    MENU_ELEMENT.ANIMATIONBREAKERS:set(5,to_boolean(tbl[129])) 
                    MENU_ELEMENT.TELEPORT:set(to_boolean(tbl[130])) 
                    MENU_ELEMENT.RAGE.CUSTOMDT_CHECK:set(to_boolean(tbl[131])) 
                    MENU_ELEMENT.RAGE.CUSTOMDT_SPEED:set(tonumber(tbl[132]))
                    MENU_ELEMENT.RAGE.CUSTOMDT_CORRECTIONS:set(to_boolean(tbl[133])) 
                    MENU_ELEMENT.RAGE.RECHARGE_CHECK:set(to_boolean(tbl[134])) 
                    MENU_ELEMENT.RAGE.DISABLEINTERP_CHECK:set(to_boolean(tbl[135])) 
                    MENU_ELEMENT.RAGE.PREDICTION_CHECK:set(to_boolean(tbl[136])) 
                    ENABLE_INDICATORS:set(to_boolean(tbl[137])) 
                    Y_ADD:set(tonumber(tbl[138]))
                    MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_CHECK:set(to_boolean(tbl[139])) 
                    MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SELECTION:set(1,to_boolean(tbl[140])) 
                    MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SELECTION:set(2,to_boolean(tbl[140])) 
                    MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SLIDER_SCOUT:set(tonumber(tbl[141]))
                    MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SLIDER_AWP:set(tonumber(tbl[142]))

        --multiselect:set(1, to_boolean(tbl[2])) bei multiselect f+r alle values eins machen
        --multiselect:set(2, to_boolean(tbl[3]))
        client.log_screen("Config Sucessfully", MENU_FIND.ACCENT_COLOR:get() ," Loaded!")
    end
    local status, message = pcall(protected)
    if not status then
        client.log_screen("Failed to ", MENU_FIND.ACCENT_COLOR:get() ,"Load Config")
        return
    end
end

configs.export = function()
    local str = {}
    local str = tostring(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get()) .. "|"   --GLOBAL
    .. tostring(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWBASE:get(1)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:get(2)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_DEFAULT:get(3)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_LEFT:get(4)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_RIGHT:get(5)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_TYPE:get(6)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_ADD:get(7)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get(8)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_STATIC:get(9)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_JITTER:get(10)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_MOVING:get(11)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_SIDE:get(12)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_AMOUNT_TYPE:get(13)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_DEFAULT:get(14)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_LEFT:get(15)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_RIGHT:get(16)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.FAKELAG_ENABLE:get(17)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.FAKELAG_TYPE:get(18)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:get(19)) .. "|"
    .. tostring(MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_2:get(20)) .. "|"

    .. tostring(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get(21)) .. "|"   --STANDING
    .. tostring(MENU_ELEMENT.STANDING.ANTIAIM_YAWBASE:get(22)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.ANTIAIM_YAWADD:get(23)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_DEFAULT:get(24)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_LEFT:get(25)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_RIGHT:get(26)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.ANTIAIM_JITTER_TYPE:get(27)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.ANTIAIM_JITTER_ADD:get(28)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_TYPE:get(29)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_STATIC:get(30)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_JITTER:get(31)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_MOVING:get(32)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_SIDE:get(33)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_AMOUNT_TYPE:get(34)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_DEFAULT:get(35)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_LEFT:get(36)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_RIGHT:get(37)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.FAKELAG_ENABLE:get(38)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.FAKELAG_TYPE:get(39)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_1:get(40)) .. "|"
    .. tostring(MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_2:get(41)) .. "|"

    .. tostring(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get(42)) .. "|"   --RUNNING
    .. tostring(MENU_ELEMENT.RUNNING.ANTIAIM_YAWBASE:get(43)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD:get(44)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_DEFAULT:get(45)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_LEFT:get(46)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_RIGHT:get(47)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.ANTIAIM_JITTER_TYPE:get(48)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.ANTIAIM_JITTER_ADD:get(49)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_TYPE:get(50)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_STATIC:get(51)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_JITTER:get(52)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_MOVING:get(53)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_SIDE:get(54)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_AMOUNT_TYPE:get(55)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_DEFAULT:get(56)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_LEFT:get(57)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_RIGHT:get(58)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.FAKELAG_ENABLE:get(59)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.FAKELAG_TYPE:get(60)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_1:get(61)) .. "|"
    .. tostring(MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_2:get(62)) .. "|"

    .. tostring(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get(63)) .. "|"   --WALKING
    .. tostring(MENU_ELEMENT.WALKING.ANTIAIM_YAWBASE:get(64)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.ANTIAIM_YAWADD:get(65)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_DEFAULT:get(66)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_LEFT:get(67)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_RIGHT:get(68)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.ANTIAIM_JITTER_TYPE:get(69)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.ANTIAIM_JITTER_ADD:get(70)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_TYPE:get(71)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_STATIC:get(72)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_JITTER:get(73)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_MOVING:get(74)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_SIDE:get(75)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_AMOUNT_TYPE:get(76)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_DEFAULT:get(77)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_LEFT:get(78)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_RIGHT:get(79)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.FAKELAG_ENABLE:get(80)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.FAKELAG_TYPE:get(81)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_1:get(82)) .. "|"
    .. tostring(MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_2:get(83)) .. "|"

    

    local str2 = {}
    local str2 = tostring(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get(84)) .. "|"   --JUMPING
    .. tostring(MENU_ELEMENT.JUMPING.ANTIAIM_YAWBASE:get(85)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD:get(86)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_DEFAULT:get(87)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_LEFT:get(88)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_RIGHT:get(89)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.ANTIAIM_JITTER_TYPE:get(90)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.ANTIAIM_JITTER_ADD:get(91)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_TYPE:get(92)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_STATIC:get(93)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_JITTER:get(94)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_MOVING:get(95)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_SIDE:get(96)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_AMOUNT_TYPE:get(97)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_DEFAULT:get(98)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_LEFT:get(99)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_RIGHT:get(100)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.FAKELAG_ENABLE:get(101)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.FAKELAG_TYPE:get(102)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_1:get(103)) .. "|"
    .. tostring(MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_2:get(104)) .. "|"

    .. tostring(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get(105)) .. "|"   --CROUCHING
    .. tostring(MENU_ELEMENT.CROUCHING.ANTIAIM_YAWBASE:get(106)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD:get(107)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_DEFAULT:get(108)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_LEFT:get(109)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_RIGHT:get(110)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.ANTIAIM_JITTER_TYPE:get(111)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.ANTIAIM_JITTER_ADD:get(112)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_TYPE:get(113)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_STATIC:get(114)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_JITTER:get(115)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_MOVING:get(116)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_SIDE:get(117)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_AMOUNT_TYPE:get(118)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_DEFAULT:get(119)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_LEFT:get(120)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_RIGHT:get(121)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.FAKELAG_ENABLE:get(122)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.FAKELAG_TYPE:get(123)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_1:get(124)) .. "|"
    .. tostring(MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_2:get(125)) .. "|"

    .. tostring(MENU_ELEMENT.ANTIAIM_ENABLE:get(126)) .. "|"
    .. tostring(MENU_ELEMENT.CUSTOM_FONT_ENABLE:get(127)) .. "|"
    .. tostring(MENU_ELEMENT.ANIMATIONBREAKERS:get(128)) .. "|"
    .. tostring(MENU_ELEMENT.TELEPORT:get(129)) .. "|"
    .. tostring(MENU_ELEMENT.RAGE.CUSTOMDT_CHECK:get(130)) .. "|"
    .. tostring(MENU_ELEMENT.RAGE.CUSTOMDT_SPEED:get(131)) .. "|"
    .. tostring(MENU_ELEMENT.RAGE.CUSTOMDT_CORRECTIONS:get(132)) .. "|"
    .. tostring(MENU_ELEMENT.RAGE.RECHARGE_CHECK:get(133)) .. "|"
    .. tostring(MENU_ELEMENT.RAGE.DISABLEINTERP_CHECK:get(134)) .. "|"
    .. tostring(MENU_ELEMENT.RAGE.PREDICTION_CHECK:get(135)) .. "|"
    .. tostring(ENABLE_INDICATORS:get(136)) .. "|"
    .. tostring(Y_ADD:get(137)) .. "|"
    .. tostring(MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_CHECK:get(138)) .. "|"
    .. tostring(MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SELECTION:get(139)) .. "|" 
    .. tostring(MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SLIDER_SCOUT:get(140)) .. "|"
    .. tostring(MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SLIDER_AWP:get(141)) .. "|"

    .. " -= eternity " ..LUA_BUILD.. " =- |"


    client.log_screen("Config Sucessfully", MENU_FIND.ACCENT_COLOR:get() ," Exported")
    clipboard_export(str .. str2)
end


configs.default = function()
	local data = "true|2|2|0|-10|15|2|16|1|0|0|false|5|1|60|0|0|true|2|11|15|true|2|2|0|-10|15|2|16|1|0|0|false|5|1|60|0|0|true|2|11|15|true|2|2|0|-10|15|2|16|1|0|0|false|5|1|60|0|0|true|2|11|15|true|2|2|0|-10|15|2|16|1|0|0|false|5|1|60|0|0|true|2|11|15|true|2|2|0|-10|15|2|16|1|0|0|false|5|1|60|0|0|true|2|11|15|true|2|2|0|-10|15|2|16|1|0|0|false|5|1|60|0|0|true|2|11|15|true|false|false|true|true|18|false|false|false|true|true|5|true|true|3|1| -= eternity Beta =- |"

	configs.import(data)
end
--- @endregion

--- @region: MainSort
local function SortMenu()
    -- Tabs

    -- Rage
    if MENU_ELEMENT.SELECT_TABS:get() == 1 then 
        MENU_ELEMENT.RAGE.CUSTOMDT_CHECK:set_visible(true)
        MENU_ELEMENT.RAGE.CUSTOMDT_SPEED:set_visible(MENU_ELEMENT.RAGE.CUSTOMDT_CHECK:get())
        MENU_ELEMENT.RAGE.CUSTOMDT_CORRECTIONS:set_visible(true)
        MENU_ELEMENT.RAGE.RECHARGE_CHECK:set_visible(true)
        MENU_ELEMENT.RAGE.PREDICTION_CHECK:set_visible(true)
        MENU_ELEMENT.RAGE.CUSTOMDT_CORRECTIONS:set_visible(false)
        MENU_ELEMENT.RAGE.DISABLEINTERP_CHECK:set_visible(false)
        MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_CHECK:set_visible(true)
        MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SELECTION:set_visible(MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_CHECK:get())  

        if MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SELECTION:get(1) then
            MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SLIDER_SCOUT:set_visible(MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_CHECK:get())
        else
            MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SLIDER_SCOUT:set_visible(false)
        end
        if MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SELECTION:get(2) then
            MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SLIDER_AWP:set_visible(MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_CHECK:get())
        else
            MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SLIDER_AWP:set_visible(false)
        end
    else
        MENU_ELEMENT.RAGE.CUSTOMDT_CHECK:set_visible(false)
        MENU_ELEMENT.RAGE.CUSTOMDT_SPEED:set_visible(false)
        MENU_ELEMENT.RAGE.CUSTOMDT_CORRECTIONS:set_visible(false)
        MENU_ELEMENT.RAGE.RECHARGE_CHECK:set_visible(false)
        MENU_ELEMENT.RAGE.DISABLEINTERP_CHECK:set_visible(false)
        MENU_ELEMENT.RAGE.PREDICTION_CHECK:set_visible(false)
        MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_CHECK:set_visible(false)
        MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SELECTION:set_visible(false)  
        MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SLIDER_SCOUT:set_visible(false)
        MENU_ELEMENT.RAGE.CUSTOMMINDMG_HPP_SLIDER_AWP:set_visible(false)
    end
    -- AntiAim
    if MENU_ELEMENT.SELECT_TABS:get() == 2 then 
        MENU_ELEMENT.ANTIAIM_ENABLE:set_visible(true)
    else
        MENU_ELEMENT.ANTIAIM_ENABLE:set_visible(false)
    end
    -- Visuals
    if MENU_ELEMENT.SELECT_TABS:get() == 3 then 
        ENABLE_INDICATORS:set_visible(true)
        Y_ADD:set_visible(true)
        ACCENT_COLOR:set_visible(true)
        MENU_ELEMENT.CUSTOM_FONT_ENABLE:set_visible(true)
        MENU_ELEMENT.ANIMATIONBREAKERS:set_visible(true)
        
    else
        ENABLE_INDICATORS:set_visible(false)
        Y_ADD:set_visible(false)
        ACCENT_COLOR:set_visible(false)
        MENU_ELEMENT.CUSTOM_FONT_ENABLE:set_visible(false)
        MENU_ELEMENT.ANIMATIONBREAKERS:set_visible(false)
    end
    -- Misc 
    if MENU_ELEMENT.SELECT_TABS:get() == 4 then 
        MENU_ELEMENT.TELEPORT:set_visible(true)
    else
        MENU_ELEMENT.TELEPORT:set_visible(false)
    end
    
    -- Anti Aim Tab
    if MENU_ELEMENT.SELECT_TABS:get() == 2 and MENU_ELEMENT.ANTIAIM_ENABLE:get() then
        MENU_ELEMENT.ANTIAIM_SELECT_TABS:set_visible(true)
    else
        MENU_ELEMENT.ANTIAIM_SELECT_TABS:set_visible(false)
    end

    
end
--- @endregion

--- @region: Builder Sort 
local function SortBuilderGlobal()
    if MENU_ELEMENT.SELECT_TABS:get() == 2 and MENU_ELEMENT.ANTIAIM_ENABLE:get() then
        if MENU_ELEMENT.ANTIAIM_SELECT_TABS:get() == 2 then
            MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:set_visible(true)
            MENU_ELEMENT.GLOBAL.ANTIAIM_YAWBASE:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())
            MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())

            if MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:get() == 1 then
                MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_DEFAULT:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_LEFT:set_visible(false)
                MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_RIGHT:set_visible(false)
            else
                MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_DEFAULT:set_visible(false)
                MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_LEFT:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_RIGHT:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())
            end
        
            MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_TYPE:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())
            MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_ADD:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())
            
            MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())   
            if MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get() == 1 then
                MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
                MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            elseif MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get() == 2 then
                MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_STATIC:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get()) 
                MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
            elseif MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get() == 3 or 4 then
                MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_JITTER:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            elseif MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get() == 5 then
                MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
                MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            end

            if MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:get() ~= 1 then
                MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_MOVING:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())  
            else
                MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_MOVING:set_visible(false)
            end

            MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_SIDE:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())
            
            MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_AMOUNT_TYPE:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())
            if MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_AMOUNT_TYPE:get() == 1 then
                MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_DEFAULT:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_LEFT:set_visible(false)
                MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_RIGHT:set_visible(false) 
            else
                MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_LEFT:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_RIGHT:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())     
                MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_DEFAULT:set_visible(false)
            end
            
            MENU_ELEMENT.GLOBAL.FAKELAG_ENABLE:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())
            if MENU_ELEMENT.GLOBAL.FAKELAG_ENABLE:get() then
                MENU_ELEMENT.GLOBAL.FAKELAG_TYPE:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get()) 
                MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())  
                if MENU_ELEMENT.GLOBAL.FAKELAG_TYPE:get() == 2 then
                    MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_2:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())
                elseif MENU_ELEMENT.GLOBAL.FAKELAG_TYPE:get() == 3 then
                    MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_2:set_visible(MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:get())
                else
                    MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_2:set_visible(false)
                end
            else
                MENU_ELEMENT.GLOBAL.FAKELAG_TYPE:set_visible(false)   
                MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:set_visible(false)
                MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_2:set_visible(false)
            end
            
            
        else
            MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:set_visible(false)
            MENU_ELEMENT.GLOBAL.ANTIAIM_YAWBASE:set_visible(false)
            MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:set_visible(false)
            MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_DEFAULT:set_visible(false)
            MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_LEFT:set_visible(false)
            MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_RIGHT:set_visible(false)
            MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_TYPE:set_visible(false)
            MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_ADD:set_visible(false)
            MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:set_visible(false)               
            MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
            MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_MOVING:set_visible(false)                           
            MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_SIDE:set_visible(false)
            MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_AMOUNT_TYPE:set_visible(false)
            MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_DEFAULT:set_visible(false)
            MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_LEFT:set_visible(false)
            MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_RIGHT:set_visible(false)     
            MENU_ELEMENT.GLOBAL.FAKELAG_ENABLE:set_visible(false)
            MENU_ELEMENT.GLOBAL.FAKELAG_TYPE:set_visible(false)               
            MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:set_visible(false)
            MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_2:set_visible(false)
        end
    else
        MENU_ELEMENT.GLOBAL.ANTIAIM_OVERRIDE:set_visible(false)
        MENU_ELEMENT.GLOBAL.ANTIAIM_YAWBASE:set_visible(false)
        MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD:set_visible(false)
        MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_DEFAULT:set_visible(false)
        MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_LEFT:set_visible(false)
        MENU_ELEMENT.GLOBAL.ANTIAIM_YAWADD_RIGHT:set_visible(false)
        MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_TYPE:set_visible(false)
        MENU_ELEMENT.GLOBAL.ANTIAIM_JITTER_ADD:set_visible(false)
        MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_TYPE:set_visible(false)               
        MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
        MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
        MENU_ELEMENT.GLOBAL.ANTIAIM_BODYLEAN_MOVING:set_visible(false)                           
        MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_SIDE:set_visible(false)
        MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_AMOUNT_TYPE:set_visible(false)
        MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_DEFAULT:set_visible(false)
        MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_LEFT:set_visible(false)
        MENU_ELEMENT.GLOBAL.ANTIAIM_DESYNC_RIGHT:set_visible(false)     
        MENU_ELEMENT.GLOBAL.FAKELAG_ENABLE:set_visible(false)
        MENU_ELEMENT.GLOBAL.FAKELAG_TYPE:set_visible(false)               
        MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_1:set_visible(false)
        MENU_ELEMENT.GLOBAL.FAKELAG_AMOUNT_2:set_visible(false)
    end
end

local function SortBuilderStanding()
    if MENU_ELEMENT.SELECT_TABS:get() == 2 and MENU_ELEMENT.ANTIAIM_ENABLE:get() then
        if MENU_ELEMENT.ANTIAIM_SELECT_TABS:get() == 3 then
            MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:set_visible(true)
            MENU_ELEMENT.STANDING.ANTIAIM_YAWBASE:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())
            MENU_ELEMENT.STANDING.ANTIAIM_YAWADD:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())

            if MENU_ELEMENT.STANDING.ANTIAIM_YAWADD:get() == 1 then
                MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_DEFAULT:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_LEFT:set_visible(false)
                MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_RIGHT:set_visible(false)
            else
                MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_DEFAULT:set_visible(false)
                MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_LEFT:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_RIGHT:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())
            end
        
            MENU_ELEMENT.STANDING.ANTIAIM_JITTER_TYPE:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())
            MENU_ELEMENT.STANDING.ANTIAIM_JITTER_ADD:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())
            
            MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_TYPE:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())   
            if MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_TYPE:get() == 1 then
                MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
                MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            elseif MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_TYPE:get() == 2 then
                MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_STATIC:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get()) 
                MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
            elseif MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_TYPE:get() == 3 or 4 then
                MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_JITTER:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            elseif MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_TYPE:get() == 5 then
                MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
                MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            end

            if MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_TYPE:get() ~= 1 then
                MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_MOVING:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())  
            else
                MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_MOVING:set_visible(false)
            end

            MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_SIDE:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())
            
            MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_AMOUNT_TYPE:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())
            if MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_AMOUNT_TYPE:get() == 1 then
                MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_DEFAULT:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_LEFT:set_visible(false)
                MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_RIGHT:set_visible(false) 
            else
                MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_LEFT:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_RIGHT:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())     
                MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_DEFAULT:set_visible(false)
            end
            
            MENU_ELEMENT.STANDING.FAKELAG_ENABLE:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())
            if MENU_ELEMENT.STANDING.FAKELAG_ENABLE:get() then
                MENU_ELEMENT.STANDING.FAKELAG_TYPE:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get()) 
                MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_1:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())  
                if MENU_ELEMENT.STANDING.FAKELAG_TYPE:get() == 2 then
                    MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_2:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())
                elseif MENU_ELEMENT.STANDING.FAKELAG_TYPE:get() == 3 then
                    MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_2:set_visible(MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:get())
                else
                    MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_2:set_visible(false)
                end
            else
                MENU_ELEMENT.STANDING.FAKELAG_TYPE:set_visible(false)   
                MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_1:set_visible(false)
                MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_2:set_visible(false)
            end
            
            
        else
            MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:set_visible(false)
            MENU_ELEMENT.STANDING.ANTIAIM_YAWBASE:set_visible(false)
            MENU_ELEMENT.STANDING.ANTIAIM_YAWADD:set_visible(false)
            MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_DEFAULT:set_visible(false)
            MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_LEFT:set_visible(false)
            MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_RIGHT:set_visible(false)
            MENU_ELEMENT.STANDING.ANTIAIM_JITTER_TYPE:set_visible(false)
            MENU_ELEMENT.STANDING.ANTIAIM_JITTER_ADD:set_visible(false)
            MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_TYPE:set_visible(false)               
            MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
            MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_MOVING:set_visible(false)                           
            MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_SIDE:set_visible(false)
            MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_AMOUNT_TYPE:set_visible(false)
            MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_DEFAULT:set_visible(false)
            MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_LEFT:set_visible(false)
            MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_RIGHT:set_visible(false)     
            MENU_ELEMENT.STANDING.FAKELAG_ENABLE:set_visible(false)
            MENU_ELEMENT.STANDING.FAKELAG_TYPE:set_visible(false)               
            MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_1:set_visible(false)
            MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_2:set_visible(false)
        end
    else
        MENU_ELEMENT.STANDING.ANTIAIM_OVERRIDE:set_visible(false)
        MENU_ELEMENT.STANDING.ANTIAIM_YAWBASE:set_visible(false)
        MENU_ELEMENT.STANDING.ANTIAIM_YAWADD:set_visible(false)
        MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_DEFAULT:set_visible(false)
        MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_LEFT:set_visible(false)
        MENU_ELEMENT.STANDING.ANTIAIM_YAWADD_RIGHT:set_visible(false)
        MENU_ELEMENT.STANDING.ANTIAIM_JITTER_TYPE:set_visible(false)
        MENU_ELEMENT.STANDING.ANTIAIM_JITTER_ADD:set_visible(false)
        MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_TYPE:set_visible(false)               
        MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
        MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
        MENU_ELEMENT.STANDING.ANTIAIM_BODYLEAN_MOVING:set_visible(false)                           
        MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_SIDE:set_visible(false)
        MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_AMOUNT_TYPE:set_visible(false)
        MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_DEFAULT:set_visible(false)
        MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_LEFT:set_visible(false)
        MENU_ELEMENT.STANDING.ANTIAIM_DESYNC_RIGHT:set_visible(false)     
        MENU_ELEMENT.STANDING.FAKELAG_ENABLE:set_visible(false)
        MENU_ELEMENT.STANDING.FAKELAG_TYPE:set_visible(false)               
        MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_1:set_visible(false)
        MENU_ELEMENT.STANDING.FAKELAG_AMOUNT_2:set_visible(false)
    end
end

local function SortBuilderRunning()
    if MENU_ELEMENT.SELECT_TABS:get() == 2 and MENU_ELEMENT.ANTIAIM_ENABLE:get() then
        if MENU_ELEMENT.ANTIAIM_SELECT_TABS:get() == 4 then
            MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:set_visible(true)
            MENU_ELEMENT.RUNNING.ANTIAIM_YAWBASE:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())
            MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())

            if MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD:get() == 1 then
                MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_DEFAULT:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_LEFT:set_visible(false)
                MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_RIGHT:set_visible(false)
            else
                MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_DEFAULT:set_visible(false)
                MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_LEFT:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_RIGHT:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())
            end
        
            MENU_ELEMENT.RUNNING.ANTIAIM_JITTER_TYPE:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())
            MENU_ELEMENT.RUNNING.ANTIAIM_JITTER_ADD:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())
            
            MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_TYPE:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())   
            if MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_TYPE:get() == 1 then
                MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
                MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            elseif MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_TYPE:get() == 2 then
                MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_STATIC:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get()) 
                MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
            elseif MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_TYPE:get() == 3 or 4 then
                MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_JITTER:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            elseif MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_TYPE:get() == 5 then
                MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
                MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            end

            if MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_TYPE:get() ~= 1 then
                MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_MOVING:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())  
            else
                MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_MOVING:set_visible(false)
            end

            MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_SIDE:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())
            
            MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_AMOUNT_TYPE:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())
            if MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_AMOUNT_TYPE:get() == 1 then
                MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_DEFAULT:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_LEFT:set_visible(false)
                MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_RIGHT:set_visible(false) 
            else
                MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_LEFT:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_RIGHT:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())     
                MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_DEFAULT:set_visible(false)
            end
            
            MENU_ELEMENT.RUNNING.FAKELAG_ENABLE:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())
            if MENU_ELEMENT.RUNNING.FAKELAG_ENABLE:get() then
                MENU_ELEMENT.RUNNING.FAKELAG_TYPE:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get()) 
                MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_1:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())  
                if MENU_ELEMENT.RUNNING.FAKELAG_TYPE:get() == 2 then
                    MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_2:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())
                elseif MENU_ELEMENT.RUNNING.FAKELAG_TYPE:get() == 3 then
                        MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_2:set_visible(MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:get())
                else
                    MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_2:set_visible(false)
                end
            else
                MENU_ELEMENT.RUNNING.FAKELAG_TYPE:set_visible(false)   
                MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_1:set_visible(false)
                MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_2:set_visible(false)
            end
            
            
        else
            MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:set_visible(false)
            MENU_ELEMENT.RUNNING.ANTIAIM_YAWBASE:set_visible(false)
            MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD:set_visible(false)
            MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_DEFAULT:set_visible(false)
            MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_LEFT:set_visible(false)
            MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_RIGHT:set_visible(false)
            MENU_ELEMENT.RUNNING.ANTIAIM_JITTER_TYPE:set_visible(false)
            MENU_ELEMENT.RUNNING.ANTIAIM_JITTER_ADD:set_visible(false)
            MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_TYPE:set_visible(false)               
            MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
            MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_MOVING:set_visible(false)                           
            MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_SIDE:set_visible(false)
            MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_AMOUNT_TYPE:set_visible(false)
            MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_DEFAULT:set_visible(false)
            MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_LEFT:set_visible(false)
            MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_RIGHT:set_visible(false)     
            MENU_ELEMENT.RUNNING.FAKELAG_ENABLE:set_visible(false)
            MENU_ELEMENT.RUNNING.FAKELAG_TYPE:set_visible(false)               
            MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_1:set_visible(false)
            MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_2:set_visible(false)
        end
    else
        MENU_ELEMENT.RUNNING.ANTIAIM_OVERRIDE:set_visible(false)
        MENU_ELEMENT.RUNNING.ANTIAIM_YAWBASE:set_visible(false)
        MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD:set_visible(false)
        MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_DEFAULT:set_visible(false)
        MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_LEFT:set_visible(false)
        MENU_ELEMENT.RUNNING.ANTIAIM_YAWADD_RIGHT:set_visible(false)
        MENU_ELEMENT.RUNNING.ANTIAIM_JITTER_TYPE:set_visible(false)
        MENU_ELEMENT.RUNNING.ANTIAIM_JITTER_ADD:set_visible(false)
        MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_TYPE:set_visible(false)               
        MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
        MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
        MENU_ELEMENT.RUNNING.ANTIAIM_BODYLEAN_MOVING:set_visible(false)                           
        MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_SIDE:set_visible(false)
        MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_AMOUNT_TYPE:set_visible(false)
        MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_DEFAULT:set_visible(false)
        MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_LEFT:set_visible(false)
        MENU_ELEMENT.RUNNING.ANTIAIM_DESYNC_RIGHT:set_visible(false)     
        MENU_ELEMENT.RUNNING.FAKELAG_ENABLE:set_visible(false)
        MENU_ELEMENT.RUNNING.FAKELAG_TYPE:set_visible(false)               
        MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_1:set_visible(false)
        MENU_ELEMENT.RUNNING.FAKELAG_AMOUNT_2:set_visible(false)
    end
end

local function SortBuilderWalking()
    if MENU_ELEMENT.SELECT_TABS:get() == 2 and MENU_ELEMENT.ANTIAIM_ENABLE:get() then
        if MENU_ELEMENT.ANTIAIM_SELECT_TABS:get() == 5 then
            MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:set_visible(true)
            MENU_ELEMENT.WALKING.ANTIAIM_YAWBASE:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())
            MENU_ELEMENT.WALKING.ANTIAIM_YAWADD:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())

            if MENU_ELEMENT.WALKING.ANTIAIM_YAWADD:get() == 1 then
                MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_DEFAULT:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_LEFT:set_visible(false)
                MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_RIGHT:set_visible(false)
            else
                MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_DEFAULT:set_visible(false)
                MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_LEFT:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_RIGHT:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())
            end
        
            MENU_ELEMENT.WALKING.ANTIAIM_JITTER_TYPE:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())
            MENU_ELEMENT.WALKING.ANTIAIM_JITTER_ADD:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())
            
            MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_TYPE:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())   
            if MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_TYPE:get() == 1 then
                MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
                MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            elseif MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_TYPE:get() == 2 then
                MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_STATIC:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get()) 
                MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
            elseif MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_TYPE:get() == 3 or 4 then
                MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_JITTER:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            elseif MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_TYPE:get() == 5 then
                MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
                MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            end

            if MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_TYPE:get() ~= 1 then
                MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_MOVING:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())  
            else
                MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_MOVING:set_visible(false)
            end

            MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_SIDE:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())
            
            MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_AMOUNT_TYPE:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())
            if MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_AMOUNT_TYPE:get() == 1 then
                MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_DEFAULT:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_LEFT:set_visible(false)
                MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_RIGHT:set_visible(false) 
            else
                MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_LEFT:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_RIGHT:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())     
                MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_DEFAULT:set_visible(false)
            end
            
            MENU_ELEMENT.WALKING.FAKELAG_ENABLE:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())
            if MENU_ELEMENT.WALKING.FAKELAG_ENABLE:get() then
                MENU_ELEMENT.WALKING.FAKELAG_TYPE:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get()) 
                MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_1:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())  
                if MENU_ELEMENT.WALKING.FAKELAG_TYPE:get() == 2 then
                    MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_2:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())
                elseif MENU_ELEMENT.WALKING.FAKELAG_TYPE:get() == 3 then
                    MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_2:set_visible(MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:get())
                else
                    MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_2:set_visible(false)
                end
            else
                MENU_ELEMENT.WALKING.FAKELAG_TYPE:set_visible(false)   
                MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_1:set_visible(false)
                MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_2:set_visible(false)
            end
            
            
        else
            MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:set_visible(false)
            MENU_ELEMENT.WALKING.ANTIAIM_YAWBASE:set_visible(false)
            MENU_ELEMENT.WALKING.ANTIAIM_YAWADD:set_visible(false)
            MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_DEFAULT:set_visible(false)
            MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_LEFT:set_visible(false)
            MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_RIGHT:set_visible(false)
            MENU_ELEMENT.WALKING.ANTIAIM_JITTER_TYPE:set_visible(false)
            MENU_ELEMENT.WALKING.ANTIAIM_JITTER_ADD:set_visible(false)
            MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_TYPE:set_visible(false)               
            MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
            MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_MOVING:set_visible(false)                           
            MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_SIDE:set_visible(false)
            MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_AMOUNT_TYPE:set_visible(false)
            MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_DEFAULT:set_visible(false)
            MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_LEFT:set_visible(false)
            MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_RIGHT:set_visible(false)     
            MENU_ELEMENT.WALKING.FAKELAG_ENABLE:set_visible(false)
            MENU_ELEMENT.WALKING.FAKELAG_TYPE:set_visible(false)               
            MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_1:set_visible(false)
            MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_2:set_visible(false)
        end
    else
        MENU_ELEMENT.WALKING.ANTIAIM_OVERRIDE:set_visible(false)
        MENU_ELEMENT.WALKING.ANTIAIM_YAWBASE:set_visible(false)
        MENU_ELEMENT.WALKING.ANTIAIM_YAWADD:set_visible(false)
        MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_DEFAULT:set_visible(false)
        MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_LEFT:set_visible(false)
        MENU_ELEMENT.WALKING.ANTIAIM_YAWADD_RIGHT:set_visible(false)
        MENU_ELEMENT.WALKING.ANTIAIM_JITTER_TYPE:set_visible(false)
        MENU_ELEMENT.WALKING.ANTIAIM_JITTER_ADD:set_visible(false)
        MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_TYPE:set_visible(false)               
        MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
        MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
        MENU_ELEMENT.WALKING.ANTIAIM_BODYLEAN_MOVING:set_visible(false)                           
        MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_SIDE:set_visible(false)
        MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_AMOUNT_TYPE:set_visible(false)
        MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_DEFAULT:set_visible(false)
        MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_LEFT:set_visible(false)
        MENU_ELEMENT.WALKING.ANTIAIM_DESYNC_RIGHT:set_visible(false)     
        MENU_ELEMENT.WALKING.FAKELAG_ENABLE:set_visible(false)
        MENU_ELEMENT.WALKING.FAKELAG_TYPE:set_visible(false)               
        MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_1:set_visible(false)
        MENU_ELEMENT.WALKING.FAKELAG_AMOUNT_2:set_visible(false)
    end
end

local function SortBuilderJumping()
    if MENU_ELEMENT.SELECT_TABS:get() == 2 and MENU_ELEMENT.ANTIAIM_ENABLE:get() then
        if MENU_ELEMENT.ANTIAIM_SELECT_TABS:get() == 6 then
            MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:set_visible(true)
            MENU_ELEMENT.JUMPING.ANTIAIM_YAWBASE:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())
            MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())

            if MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD:get() == 1 then
                MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_DEFAULT:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_LEFT:set_visible(false)
                MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_RIGHT:set_visible(false)
            else
                MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_DEFAULT:set_visible(false)
                MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_LEFT:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_RIGHT:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())
            end
        
            MENU_ELEMENT.JUMPING.ANTIAIM_JITTER_TYPE:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())
            MENU_ELEMENT.JUMPING.ANTIAIM_JITTER_ADD:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())
            
            MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_TYPE:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())   
            if MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_TYPE:get() == 1 then
                MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
                MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            elseif MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_TYPE:get() == 2 then
                MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_STATIC:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get()) 
                MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
            elseif MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_TYPE:get() == 3 or 4 then
                MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_JITTER:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            elseif MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_TYPE:get() == 5 then
                MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
                MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            end

            if MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_TYPE:get() ~= 1 then
                MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_MOVING:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())  
            else
                MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_MOVING:set_visible(false)
            end

            MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_SIDE:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())
            
            MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_AMOUNT_TYPE:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())
            if MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_AMOUNT_TYPE:get() == 1 then
                MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_DEFAULT:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_LEFT:set_visible(false)
                MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_RIGHT:set_visible(false) 
            else
                MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_LEFT:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_RIGHT:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())     
                MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_DEFAULT:set_visible(false)
            end
            
            MENU_ELEMENT.JUMPING.FAKELAG_ENABLE:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())
            if MENU_ELEMENT.JUMPING.FAKELAG_ENABLE:get() then
                MENU_ELEMENT.JUMPING.FAKELAG_TYPE:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get()) 
                MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_1:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())  
                if MENU_ELEMENT.JUMPING.FAKELAG_TYPE:get() == 2 then
                    MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_2:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())
                elseif MENU_ELEMENT.JUMPING.FAKELAG_TYPE:get() == 3 then
                    MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_2:set_visible(MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:get())
                else
                    MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_2:set_visible(false)
                end
            else
                MENU_ELEMENT.JUMPING.FAKELAG_TYPE:set_visible(false)   
                MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_1:set_visible(false)
                MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_2:set_visible(false)
            end
            
            
        else
            MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:set_visible(false)
            MENU_ELEMENT.JUMPING.ANTIAIM_YAWBASE:set_visible(false)
            MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD:set_visible(false)
            MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_DEFAULT:set_visible(false)
            MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_LEFT:set_visible(false)
            MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_RIGHT:set_visible(false)
            MENU_ELEMENT.JUMPING.ANTIAIM_JITTER_TYPE:set_visible(false)
            MENU_ELEMENT.JUMPING.ANTIAIM_JITTER_ADD:set_visible(false)
            MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_TYPE:set_visible(false)               
            MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
            MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_MOVING:set_visible(false)                           
            MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_SIDE:set_visible(false)
            MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_AMOUNT_TYPE:set_visible(false)
            MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_DEFAULT:set_visible(false)
            MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_LEFT:set_visible(false)
            MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_RIGHT:set_visible(false)     
            MENU_ELEMENT.JUMPING.FAKELAG_ENABLE:set_visible(false)
            MENU_ELEMENT.JUMPING.FAKELAG_TYPE:set_visible(false)               
            MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_1:set_visible(false)
            MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_2:set_visible(false)
        end
    else
        MENU_ELEMENT.JUMPING.ANTIAIM_OVERRIDE:set_visible(false)
        MENU_ELEMENT.JUMPING.ANTIAIM_YAWBASE:set_visible(false)
        MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD:set_visible(false)
        MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_DEFAULT:set_visible(false)
        MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_LEFT:set_visible(false)
        MENU_ELEMENT.JUMPING.ANTIAIM_YAWADD_RIGHT:set_visible(false)
        MENU_ELEMENT.JUMPING.ANTIAIM_JITTER_TYPE:set_visible(false)
        MENU_ELEMENT.JUMPING.ANTIAIM_JITTER_ADD:set_visible(false)
        MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_TYPE:set_visible(false)               
        MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
        MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
        MENU_ELEMENT.JUMPING.ANTIAIM_BODYLEAN_MOVING:set_visible(false)                           
        MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_SIDE:set_visible(false)
        MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_AMOUNT_TYPE:set_visible(false)
        MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_DEFAULT:set_visible(false)
        MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_LEFT:set_visible(false)
        MENU_ELEMENT.JUMPING.ANTIAIM_DESYNC_RIGHT:set_visible(false)     
        MENU_ELEMENT.JUMPING.FAKELAG_ENABLE:set_visible(false)
        MENU_ELEMENT.JUMPING.FAKELAG_TYPE:set_visible(false)               
        MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_1:set_visible(false)
        MENU_ELEMENT.JUMPING.FAKELAG_AMOUNT_2:set_visible(false)
    end
end

local function SortBuilderCrouching()
    if MENU_ELEMENT.SELECT_TABS:get() == 2 and MENU_ELEMENT.ANTIAIM_ENABLE:get() then
        if MENU_ELEMENT.ANTIAIM_SELECT_TABS:get() == 7 then
            MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:set_visible(true)
            MENU_ELEMENT.CROUCHING.ANTIAIM_YAWBASE:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())
            MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())

            if MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD:get() == 1 then
                MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_DEFAULT:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_LEFT:set_visible(false)
                MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_RIGHT:set_visible(false)
            else
                MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_DEFAULT:set_visible(false)
                MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_LEFT:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_RIGHT:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())
            end
        
            MENU_ELEMENT.CROUCHING.ANTIAIM_JITTER_TYPE:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())
            MENU_ELEMENT.CROUCHING.ANTIAIM_JITTER_ADD:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())
            
            MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_TYPE:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())   
            if MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_TYPE:get() == 1 then
                MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
                MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            elseif MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_TYPE:get() == 2 then
                MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_STATIC:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get()) 
                MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
            elseif MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_TYPE:get() == 3 or 4 then
                MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_JITTER:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            elseif MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_TYPE:get() == 5 then
                MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
                MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            end

            if MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_TYPE:get() ~= 1 then
                MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_MOVING:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())  
            else
                MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_MOVING:set_visible(false)
            end

            MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_SIDE:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())
            
            MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_AMOUNT_TYPE:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())
            if MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_AMOUNT_TYPE:get() == 1 then
                MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_DEFAULT:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_LEFT:set_visible(false)
                MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_RIGHT:set_visible(false) 
            else
                MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_LEFT:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())
                MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_RIGHT:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())     
                MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_DEFAULT:set_visible(false)
            end
            
            MENU_ELEMENT.CROUCHING.FAKELAG_ENABLE:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())
            if MENU_ELEMENT.CROUCHING.FAKELAG_ENABLE:get() then
                MENU_ELEMENT.CROUCHING.FAKELAG_TYPE:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get()) 
                MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_1:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())  
                if MENU_ELEMENT.CROUCHING.FAKELAG_TYPE:get() == 2 then
                    MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_2:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())
                elseif MENU_ELEMENT.CROUCHING.FAKELAG_TYPE:get() == 3 then
                    MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_2:set_visible(MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:get())
                else
                    MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_2:set_visible(false)
                end
            else
                MENU_ELEMENT.CROUCHING.FAKELAG_TYPE:set_visible(false)   
                MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_1:set_visible(false)
                MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_2:set_visible(false)
            end
            
            
        else
            MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:set_visible(false)
            MENU_ELEMENT.CROUCHING.ANTIAIM_YAWBASE:set_visible(false)
            MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD:set_visible(false)
            MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_DEFAULT:set_visible(false)
            MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_LEFT:set_visible(false)
            MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_RIGHT:set_visible(false)
            MENU_ELEMENT.CROUCHING.ANTIAIM_JITTER_TYPE:set_visible(false)
            MENU_ELEMENT.CROUCHING.ANTIAIM_JITTER_ADD:set_visible(false)
            MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_TYPE:set_visible(false)               
            MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
            MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
            MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_MOVING:set_visible(false)                           
            MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_SIDE:set_visible(false)
            MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_AMOUNT_TYPE:set_visible(false)
            MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_DEFAULT:set_visible(false)
            MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_LEFT:set_visible(false)
            MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_RIGHT:set_visible(false)     
            MENU_ELEMENT.CROUCHING.FAKELAG_ENABLE:set_visible(false)
            MENU_ELEMENT.CROUCHING.FAKELAG_TYPE:set_visible(false)               
            MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_1:set_visible(false)
            MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_2:set_visible(false)
        end
    else
        MENU_ELEMENT.CROUCHING.ANTIAIM_OVERRIDE:set_visible(false)
        MENU_ELEMENT.CROUCHING.ANTIAIM_YAWBASE:set_visible(false)
        MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD:set_visible(false)
        MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_DEFAULT:set_visible(false)
        MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_LEFT:set_visible(false)
        MENU_ELEMENT.CROUCHING.ANTIAIM_YAWADD_RIGHT:set_visible(false)
        MENU_ELEMENT.CROUCHING.ANTIAIM_JITTER_TYPE:set_visible(false)
        MENU_ELEMENT.CROUCHING.ANTIAIM_JITTER_ADD:set_visible(false)
        MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_TYPE:set_visible(false)               
        MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_STATIC:set_visible(false) 
        MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_JITTER:set_visible(false)
        MENU_ELEMENT.CROUCHING.ANTIAIM_BODYLEAN_MOVING:set_visible(false)                           
        MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_SIDE:set_visible(false)
        MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_AMOUNT_TYPE:set_visible(false)
        MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_DEFAULT:set_visible(false)
        MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_LEFT:set_visible(false)
        MENU_ELEMENT.CROUCHING.ANTIAIM_DESYNC_RIGHT:set_visible(false)     
        MENU_ELEMENT.CROUCHING.FAKELAG_ENABLE:set_visible(false)
        MENU_ELEMENT.CROUCHING.FAKELAG_TYPE:set_visible(false)               
        MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_1:set_visible(false)
        MENU_ELEMENT.CROUCHING.FAKELAG_AMOUNT_2:set_visible(false)
    end
end
--- @endregion


local function on_draw_watermark(watermark_text)
    -- returning any string will override the watermark text
    return "Eternity [" ..LUA_BUILD.. "] - " .. user.name
end

callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)

client.log_screen("Eternity.gg Successfully", MENU_FIND.ACCENT_COLOR:get() ," Loaded!")
client.log_screen("Welcome Back ", MENU_FIND.ACCENT_COLOR:get() , user.name, "[" , user.uid , "] !")


--- @region: callbacks
callbacks.add(e_callbacks.PAINT,function()
    SortMenu()
    SortBuilderGlobal()
    SortBuilderStanding()
    SortBuilderRunning()
    SortBuilderWalking()
    SortBuilderJumping()
    SortBuilderCrouching()
    if entity_list.get_local_player_or_spectating() and ENABLE_INDICATORS:get() then
        indicators()
    end
end)

callbacks.add(e_callbacks.SETUP_COMMAND, function()
    TeleportOnKey()
    AnitAimMain()
end) 

callbacks.add(e_callbacks.ANTIAIM, anim_breaker.handle)
callbacks.add(e_callbacks.FINISH_COMMAND, on_finish_command)
callbacks.add(e_callbacks.PLAYER_ESP, on_player_esp)