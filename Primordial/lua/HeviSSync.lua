local state = {}
local vars = {}
local logs = {}
local ffi_handler = {}
local tag_changer = {}
local ui = {}
local gunlist = {}
local configs = {}
local animation = {}
local cislonazemi = 1
local Ahojkonecnejtime = 0
local Cas_prave_Ted = 0
local Cas_prave_Ted2 = 0
local AntiAimScoutch11 = 0
local AntiAimScoutch12 = 0
local DMGHitmarker = 0
local FPSHolder = 0
local Animace1 = 0
local Animace2 = 0
local Animace3 = 0
local Animace4 = 0
local Animace5 = 0
local Animace6 = 0
local Animace7 = 0
local Animace8 = 0
local Animace9 = 0
local Animace10 = 0
local Animace11 = 0
local Animace12 = 0
local Animace13 = 0
local Animace_If_Menu_Open = 0
local IfEnemyOff = 0

--FFi 
ffi.cdef [[
    typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

--Animace
animation.lerp = function(start, vend, time)
    return start + (vend - start) * time
end

---------------------------------Znak při naštení


ColorsMainZnak, ColorsMainZnakHlavni = unpack(menu.find("misc", "main", "config", "accent color"))
    ZnakColor = ColorsMainZnakHlavni:get()

client.log('') client.log('') client.log('') client.log('')
client.log(ZnakColor, '-------------')
client.log(ZnakColor, '      H     ')
client.log(ZnakColor, '      H     ')
client.log(ZnakColor, '  HHHHHHHHH ')
client.log(ZnakColor, '   H  H     ')
client.log(ZnakColor, '    H H     ')
client.log(ZnakColor, '     HH     ')
client.log(ZnakColor, '      H     ')
client.log(ZnakColor, '      HH    ')
client.log(ZnakColor, '      H H   ')
client.log(ZnakColor, '      H  H  ')
client.log(ZnakColor, '  HHHHHHHHH ')
client.log(ZnakColor, '   H  H     ')
client.log(ZnakColor, '    H H     ')
client.log(ZnakColor, '     HH     ')
client.log(ZnakColor, '      H     ') 
client.log_screen(ZnakColor, '-------------')
client.log_screen(ZnakColor, '|--WELCOME--|')
client.log_screen(ZnakColor, '|----T-O----|')
client.log_screen(ZnakColor, '|-HEVISSYNC-|')
client.log_screen(ZnakColor, '-------------')
client.log('') client.log('') client.log('') client.log('')
client.log(ZnakColor, 'Join HeviSSync Discord')
client.log(ZnakColor, 'https://discord.gg/jcY8DBtUMy')

MainMenuText2 = menu.add_text("HeviSSync", "Open your 3rd eye with HeviSSync.") 
HeviSSyncMain = menu.add_multi_selection("HeviSSync", "Choose tab",{"AntiAim","AimBot","Visuals","Troll","Bots/Self Commands"})

WelcomeHEviSSyncInd = render.create_font("Verdana", 20, 615, e_font_flags.OUTLINE, e_font_flags.DROPSHADOW)
WelcomeHEviSSyncInd2 = render.create_font("Verdana", 12, 615, e_font_flags.OUTLINE, e_font_flags.DROPSHADOW)

function WelcometoHeviSSync()

    local RainbowColor = (global_vars.real_time() * 5) % 100

    accent_color_text, accent_color_color = unpack(menu.find("misc", "main", "config", "accent color"))
    detail = accent_color_color:get()

    if menu.is_open() then     
        Animace_If_Menu_Open = animation.lerp(Animace_If_Menu_Open, 20, global_vars.frame_time() * 3)
    else
        Animace_If_Menu_Open = animation.lerp(Animace_If_Menu_Open, -160, global_vars.frame_time() * 7)
    end

    render.rect_filled(vec2_t(860, 67+Animace_If_Menu_Open), vec2_t(200, 90), color_t(0,0,0))
    render.rect(vec2_t(860, 67+Animace_If_Menu_Open), vec2_t(200, 90), color_t.from_hsb(RainbowColor / 100, 1, 1))
    render.text(WelcomeHEviSSyncInd, "Welcome to", vec2_t(904, 74+Animace_If_Menu_Open), detail)
    render.text(WelcomeHEviSSyncInd, "HeviSSync.Lua", vec2_t(890, 95+Animace_If_Menu_Open), detail)
    render.text(WelcomeHEviSSyncInd2, "NAME: ".. user.name.."", vec2_t(922, 119+Animace_If_Menu_Open), detail)
    render.text(WelcomeHEviSSyncInd2, "UID: ".. user.uid.."", vec2_t(938, 136+Animace_If_Menu_Open), detail) 
end



-------------------------------------------------------------------------------------------------Anti Aim-------------------------------------------------------------------------------------------------
Font_For_Indicasstors2 = render.create_font("Smallest Pixel-7", 21, 615, e_font_flags.OUTLINE, e_font_flags.DROPSHADOW) 

---------------------------------AntiAim
--MenuFind (Angles)
Pitch = menu.find("antiaim","main", "angles","pitch")
YawBase = menu.find("antiaim","main", "angles","yaw base")
yawAdd = menu.find("antiaim","main", "angles","yaw add")
Rotate = menu.find("antiaim","main", "angles","rotate")
Rotate_range = menu.find("antiaim","main", "angles","rotate range")
Rotate_speed = menu.find("antiaim","main", "angles","rotate speed")
Jitter = menu.find("antiaim","main", "angles","jitter mode")
Jitter_add = menu.find("antiaim","main", "angles","jitter add")
BodyLean = menu.find("antiaim","main", "angles","body lean")
BodyLean_value = menu.find("antiaim","main", "angles","body lean value")
BodyLean_Moving = menu.find("antiaim","main", "angles","moving body lean")
Extend_angles = menu.find("antiaim","main", "extended angles","enable while moving")
Extend_pitch = menu.find("antiaim","main", "extended angles","pitch")
Extend_type = menu.find("antiaim","main", "extended angles","type")
Extend_offset = menu.find("antiaim","main", "extended angles","offset")
AntiBruteForce = menu.find("antiaim","main", "desync","anti bruteforce")
OnShot = menu.find("antiaim","main", "desync","on shot")
SloWWalkMain = menu.find("misc","main", "movement","slow walk")



--MenuFind (Desync/Stand)
side_stand = menu.find("antiaim","main", "desync","side#stand")
llimit_stand = menu.find("antiaim","main", "desync","left amount#stand")--1
rlimit_stand = menu.find("antiaim","main", "desync","right amount#stand")--2
--MenuFind (Desync/Move)
Ovveride_move = menu.find("antiaim","main", "desync","override stand#move")
side_move = menu.find("antiaim","main", "desync","side#move")
llimit_move = menu.find("antiaim","main", "desync","left amount#move")
rlimit_move = menu.find("antiaim","main", "desync","right amount#move")
--MenuFind (Desync/Slowwalk)
Ovveride_SlowWalk = menu.find("antiaim","main", "desync","override stand#slow walk")
side_SlowWalk = menu.find("antiaim","main", "desync","side#slow walk")
llimit_SlowWalk = menu.find("antiaim","main", "desync","left amount#slow walk")
rlimit_SlowWalk = menu.find("antiaim","main", "desync","right amount#slow walk")



--MenuAdd
AmtiAim_Cara = menu.add_text("AntiAim", "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
AntiAimMain = menu.add_selection("AntiAim","HevisAA Presets",{"OFF","Low Fake jitter","High Fake jitter","Body Lean","Static Jitter","AntiAim Builder"})
AntiAim_HowBigJitter = menu.add_slider( "AntiAim", "Jitter Distance", -100, 100 )
AmtiAim_JitterText = menu.add_text("AntiAim", "0 is optimal")
AmtiAim_Cara2s = menu.add_text("AntiAim", "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
ZeroPitchonlandandlegs = menu.add_checkbox("AntiAim", "Static legs in air")
AmtiAim_Cara2 = menu.add_text("AntiAim", "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")

--MenuAdd / AA Builder
AABUilder_Cara = menu.add_text("AA Builder", "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
AAMainType = menu.add_selection("AA Builder","Status",{"Standing", "Moving", "SlowWalking", "Jumping", "AirDuck", "Crouch Moving"})
--Standing
MainStayYaw = menu.add_slider( "AA Builder", "Main Yaw", -180, 180 ) 
AATypeStay = menu.add_selection("AA Builder","HevisAA Presets",{"Jitter", "L", "R"})
AntiAim_YawStay = menu.add_slider( "AA Builder", "L Yaw", -180, 180 )
AntiAim_LeftStay = menu.add_slider( "AA Builder", "L Fake", 0, 100 )
AntiAim_Yaw2Stay = menu.add_slider( "AA Builder", "R Yaw", -180, 180 )
AntiAim_RightStay = menu.add_slider( "AA Builder", "R Fake", 0, 100 )
--Moving
MainMovingYaw = menu.add_slider( "AA Builder", "Main Yaw", -180, 180 ) 
AATypeMOVE = menu.add_selection("AA Builder","HevisAA Presets",{"Jitter", "L", "R"})
AntiAim_YawMOVE = menu.add_slider( "AA Builder", "L Yaw", -180, 180 )
AntiAim_LeftMOVE = menu.add_slider( "AA Builder", "L Fake", 0, 100 )
AntiAim_Yaw2MOVE = menu.add_slider( "AA Builder", "R Yaw", -180, 180 )
AntiAim_RightMOVE = menu.add_slider( "AA Builder", "R Fake", 0, 100 )
--SlowWalking
MainSloWWalkingYaw = menu.add_slider( "AA Builder", "Main Yaw", -180, 180 ) 
AATypeSlowWalk = menu.add_selection("AA Builder","HevisAA Presets",{"Jitter", "L", "R"})
AntiAim_YawSlowWalk = menu.add_slider( "AA Builder", "L Yaw", -180, 180 )
AntiAim_LeftSlowWalk = menu.add_slider( "AA Builder", "L Fake", 0, 100 )
AntiAim_YawSlowWalk2 = menu.add_slider( "AA Builder", "R Yaw", -180, 180 )
AntiAim_RightSlowWalk = menu.add_slider( "AA Builder", "R Fake", 0, 100 )
--Jumping
MainJumpingYaw = menu.add_slider( "AA Builder", "Main Yaw", -180, 180 ) 
AATypeJumpo = menu.add_selection("AA Builder","HevisAA Presets",{"Jitter", "L", "R"})
AntiAim_YawJumpo = menu.add_slider( "AA Builder", "L Yaw", -180, 180 )
AntiAim_LeftJumpo = menu.add_slider( "AA Builder", "L Fake", 0, 100 )
AntiAim_Yaw2Jumpo = menu.add_slider( "AA Builder", "R Yaw", -180, 180 )
AntiAim_RightJumpo = menu.add_slider( "AA Builder", "R Fake", 0, 100 )
--AirDuck
MainAirDuckYaw = menu.add_slider( "AA Builder", "Main Yaw", -180, 180 ) 
AATypeAirDuck = menu.add_selection("AA Builder","HevisAA Presets",{"Jitter", "L", "R"})
AntiAim_YawAirDuck = menu.add_slider( "AA Builder", "L Yaw", -180, 180 )
AntiAim_LeftAirDuck = menu.add_slider( "AA Builder", "L Fake", 0, 100 )
AntiAim_Yaw2AirDuck = menu.add_slider( "AA Builder", "R Yaw", -180, 180 )
AntiAim_RightAirDuck = menu.add_slider( "AA Builder", "R Fake", 0, 100 )
--Crouch 
MainCrouchYaw = menu.add_slider( "AA Builder", "Main Yaw", -180, 180 ) 
AATypeSkrcMoving = menu.add_selection("AA Builder","HevisAA Presets",{"Jitter", "L", "R"})
AntiAim_YawSkrcMoving = menu.add_slider( "AA Builder", "L Yaw", -180, 180 )
AntiAim_LeftStaySkrcMoving = menu.add_slider( "AA Builder", "L Fake", 0, 100 )
AntiAim_Yaw2SkrcMoving = menu.add_slider( "AA Builder", "R Yaw", -180, 180 )
AntiAim_RightStaySkrcMoving = menu.add_slider( "AA Builder", "R Fake", 0, 100 )

AmtiAim_text1 = menu.add_text("AA Builder", "")
AmtiAim_text2 = menu.add_text("AA Builder", "-------------------------------------------------------------------")
AmtiAim_text3 = menu.add_text("AA Builder", "  -------FROM THERE, IT APPLIES TO EVERYONE--------")
AmtiAim_text4 = menu.add_text("AA Builder", "-------------------------------------------------------------------")
AmtiAim_text5 = menu.add_text("AA Builder", "")

AntiAim_YawBasew = menu.add_selection("AA Builder", "Pitch",{"None", "Down", "Up", "Zero", "Jitter"})
AntiAim_YawBased = menu.add_selection("AA Builder", "Yaw Base",{"None", "ViewAngle", "At Target (CroSSHair)", "Ad Target (Distance)", "Velocity"})
AntiAim_AntiBruteForce = menu.add_checkbox("AA Builder", "AntiBruteForce")
AntiAim_OnShot = menu.add_selection("AA Builder", "OnShot",{"None", "Opposite", "Same Side", "Random"})
AntiAim_Spin = menu.add_checkbox("AA Builder", "Rotation")
AntiAim_SpinRange = menu.add_slider("AA Builder", "Spin Range", 0, 360 )
AntiAim_SpinSpeed = menu.add_slider("AA Builder", "Spin Speed", 0, 100 )
AntiAim_Jitter = menu.add_selection("AA Builder", "Jitter Presets",{"None", "Static", "Random"})
AntiAim_JitterRange = menu.add_slider( "AA Builder", "Jitter Range", -180, 180 )
AABUilder_Cara2 = menu.add_text("AA Builder", "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")

state.get_velocity = function(entity)
    x = entity:get_prop("m_vecVelocity[0]")
    y = entity:get_prop("m_vecVelocity[1]")
    z = entity:get_prop("m_vecVelocity[2]")
    if x == nil then return end
    return math.sqrt(x*x + y*y + z*z)
end

crouch_key = input.find_key_bound_to_binding("duck")

state.Velocity_State = function() 

    -- localplayer
    entity = entity_list.get_local_player()
    velocity = math.floor(state.get_velocity(entity))
    crouch_in_air = entity_list.get_local_player():get_prop("m_fFlags") == 262
    jumping = bit.band(entity_list.get_local_player():get_prop("m_fFlags"), 1) == 0

    if SloWWalkMain[2]:get() then
        vars.player_state = "slow motion"
    elseif crouch_in_air then
        vars.player_state = "air duck"
    elseif jumping and not crouch_in_air then
        vars.player_state = "jumping"
    elseif input.is_key_held(crouch_key) then
        vars.player_state = "CrouchMoving"
    elseif velocity > 100 and not crouch_in_air then
        vars.player_state = "moving"
    else
        vars.player_state = "NotMovingg"
    end
end

TestAATimer = menu.add_checkbox("TimerSecret","TimerSecret")

function AntiAim_AAPresets()

    MainAAPreset = AntiAimMain:get()
    JitterDistance = AntiAim_HowBigJitter:get()

    ShowAntiAimPresets = HeviSSyncMain:get(1) 
    AmtiAim_Cara:set_visible(ShowAntiAimPresets)
    AntiAimMain:set_visible(ShowAntiAimPresets)
    AmtiAim_Cara2:set_visible(ShowAntiAimPresets)
    ZeroPitchonlandandlegs:set_visible(ShowAntiAimPresets)
    AmtiAim_Cara2s:set_visible(ShowAntiAimPresets)

    JitterSizeOnly = MainAAPreset == (5) and HeviSSyncMain:get(1) 
    AntiAim_HowBigJitter:set_visible(JitterSizeOnly)
    AmtiAim_JitterText:set_visible(JitterSizeOnly)

    AABuilderVisible = MainAAPreset == (6) and HeviSSyncMain:get(1) 
    AAMainType:set_visible(AABuilderVisible)
    AABUilder_Cara:set_visible(AABuilderVisible)
    AABUilder_Cara2:set_visible(AABuilderVisible)
    AntiAim_YawBasew:set_visible(AABuilderVisible)
    AntiAim_YawBased:set_visible(AABuilderVisible)
    AntiAim_AntiBruteForce:set_visible(AABuilderVisible)
    AntiAim_OnShot:set_visible(AABuilderVisible)
    AntiAim_Spin:set_visible(AABuilderVisible) 
    AntiAim_Jitter:set_visible(AABuilderVisible)
    AmtiAim_text1:set_visible(AABuilderVisible)
    AmtiAim_text2:set_visible(AABuilderVisible)
    AmtiAim_text3:set_visible(AABuilderVisible)
    AmtiAim_text4:set_visible(AABuilderVisible)
    AmtiAim_text5:set_visible(AABuilderVisible)

    SpinForAABuilder = AntiAim_Spin:get() == true and HeviSSyncMain:get(1) and MainAAPreset == (6)
    AntiAim_SpinRange:set_visible(SpinForAABuilder)
    AntiAim_SpinSpeed:set_visible(SpinForAABuilder)

    JitterForAABuilder = AntiAim_Jitter:get() == 2 and HeviSSyncMain:get(1) and MainAAPreset == (6) or AntiAim_Jitter:get() == 3 and HeviSSyncMain:get(1) and MainAAPreset == (6)
    AntiAim_JitterRange:set_visible(JitterForAABuilder)

    StantingAAPesets = AAMainType:get() == 1 and HeviSSyncMain:get(1) and MainAAPreset == (6)
    AATypeStay:set_visible(StantingAAPesets)
    AntiAim_YawStay:set_visible(StantingAAPesets)
    AntiAim_Yaw2Stay:set_visible(StantingAAPesets)
    AntiAim_LeftStay:set_visible(StantingAAPesets)
    AntiAim_RightStay:set_visible(StantingAAPesets)
    MainStayYaw:set_visible(StantingAAPesets)

    MovingAAPesets = AAMainType:get() == 2 and HeviSSyncMain:get(1) and MainAAPreset == (6)
    AATypeMOVE:set_visible(MovingAAPesets)
    AntiAim_YawMOVE:set_visible(MovingAAPesets)
    AntiAim_Yaw2MOVE:set_visible(MovingAAPesets)
    AntiAim_LeftMOVE:set_visible(MovingAAPesets)
    AntiAim_RightMOVE:set_visible(MovingAAPesets)
    MainMovingYaw:set_visible(MovingAAPesets)

    SloWWalkAAPesets = AAMainType:get() == 3 and HeviSSyncMain:get(1) and MainAAPreset == (6)
    AATypeSlowWalk:set_visible(SloWWalkAAPesets)
    AntiAim_YawSlowWalk:set_visible(SloWWalkAAPesets)
    AntiAim_YawSlowWalk2:set_visible(SloWWalkAAPesets)
    AntiAim_LeftSlowWalk:set_visible(SloWWalkAAPesets)
    AntiAim_RightSlowWalk:set_visible(SloWWalkAAPesets) 
    MainSloWWalkingYaw:set_visible(SloWWalkAAPesets) 

    JumpingAAPesets = AAMainType:get() == 4 and HeviSSyncMain:get(1) and MainAAPreset == (6)
    AATypeJumpo:set_visible(JumpingAAPesets)
    AntiAim_YawJumpo:set_visible(JumpingAAPesets)
    AntiAim_Yaw2Jumpo:set_visible(JumpingAAPesets)
    AntiAim_LeftJumpo:set_visible(JumpingAAPesets)
    AntiAim_RightJumpo:set_visible(JumpingAAPesets)
    MainJumpingYaw:set_visible(JumpingAAPesets)

    AirDuckAAPesets = AAMainType:get() == 5 and HeviSSyncMain:get(1) and MainAAPreset == (6)
    AATypeAirDuck:set_visible(AirDuckAAPesets)
    AntiAim_YawAirDuck:set_visible(AirDuckAAPesets)
    AntiAim_Yaw2AirDuck:set_visible(AirDuckAAPesets)
    AntiAim_LeftAirDuck:set_visible(AirDuckAAPesets)
    AntiAim_RightAirDuck:set_visible(AirDuckAAPesets)
    MainAirDuckYaw:set_visible(AirDuckAAPesets)

    CrouchMovingAAPesets = AAMainType:get() == 6 and HeviSSyncMain:get(1) and MainAAPreset == (6)
    AATypeSkrcMoving:set_visible(CrouchMovingAAPesets)
    AntiAim_YawSkrcMoving:set_visible(CrouchMovingAAPesets)
    AntiAim_Yaw2SkrcMoving:set_visible(CrouchMovingAAPesets)
    AntiAim_LeftStaySkrcMoving:set_visible(CrouchMovingAAPesets)
    AntiAim_RightStaySkrcMoving:set_visible(CrouchMovingAAPesets)
    MainCrouchYaw:set_visible(CrouchMovingAAPesets)

    TestAATimer:set_visible(false)

    if not engine.is_in_game() then return end
    if entity_list.get_local_player() == nil then return end
    if entity_list.get_local_player():is_alive() == (false) then return end

    Standing = vars.player_state == "NotMovingg"
    Moving = vars.player_state == "moving"
    SloWWalk = vars.player_state == "slow motion"
    In_Air = vars.player_state == "jumping"
    Air_crouch = vars.player_state == "air duck"  
    CruochMovingL = vars.player_state == "CrouchMoving"

    if AntiAimScoutch1 == 1 and CruochMovingL then 
        AntiAimScoutch1 = math.abs(AntiAimScoutch12)-1
    elseif input.is_key_pressed(e_keys.KEY_A) then
        AntiAimScoutch1 = math.abs(AntiAimScoutch12)+1 --A
    elseif AntiAimScoutch1 == 2 and CruochMovingL then 
        AntiAimScoutch1 = math.abs(AntiAimScoutch12)-2
    elseif input.is_key_pressed(e_keys.KEY_D) then
        AntiAimScoutch1 = math.abs(AntiAimScoutch12)+2 --D
    end

    if TestAATimer:get() == (false) then
        TestAATimer:set(true)
    elseif TestAATimer:get() then
        TestAATimer:set(false)
    end


    
    if MainAAPreset == (2) then -- Low AA Preset
        Pitch:set(2)
        YawBase:set(3)
        Rotate:set(false)
        Jitter:set(1)
        BodyLean:set(1)
        BodyLean_Moving:set(false)
        AntiBruteForce:set(false)
        OnShot:set(4)
        Ovveride_move:set(true)
        Ovveride_SlowWalk:set(true)

        if Standing then
            if TestAATimer:get() then
                
                yawAdd:set(-1)
                side_stand:set(2)
                llimit_stand:set(45)
            else
                yawAdd:set(13)
                side_stand:set(3)
                rlimit_stand:set(45)
            end
        elseif Moving then
            if TestAATimer:get() then
                yawAdd:set(-2)
                side_move:set(2)
                llimit_move:set(45)
            else
                yawAdd:set(8)
                side_move:set(3)
                rlimit_move:set(45)
            end
        elseif SloWWalk then
            if TestAATimer:get() then
                yawAdd:set(2)
                side_SlowWalk:set(2)
                llimit_SlowWalk:set(20)
            else
                yawAdd:set(8)
                side_SlowWalk:set(3)
                rlimit_SlowWalk:set(20)
            end
        elseif In_Air then
            if TestAATimer:get() then
                yawAdd:set(0)
                side_move:set(2)
                llimit_move:set(10)
            else
                yawAdd:set(5)
                side_move:set(3)
                rlimit_move:set(20)
            end   
        elseif Air_crouch then
            if TestAATimer:get() then
                yawAdd:set(12)
                side_move:set(2)
                llimit_move:set(10)
            else
                yawAdd:set(12)
                side_move:set(3)
                rlimit_move:set(15)
            end
        end
    end
    if MainAAPreset == (3) then -- High AA Preset
        Pitch:set(2)
        YawBase:set(3)
        Rotate:set(false)
        Jitter:set(1)
        BodyLean:set(1)
        BodyLean_Moving:set(false)
        AntiBruteForce:set(false)
        OnShot:set(4)
        Ovveride_move:set(true)
        Ovveride_SlowWalk:set(true)

        if Standing then
            if TestAATimer:get() then
                yawAdd:set(-3)
                side_stand:set(2)
                llimit_stand:set(100)
            else
                yawAdd:set(17)
                side_stand:set(3)
                rlimit_stand:set(100)
            end
        elseif Moving then
            if TestAATimer:get() then
                yawAdd:set(-12)
                side_move:set(2)
                llimit_move:set(100)
            else
                yawAdd:set(14)
                side_move:set(3)
                rlimit_move:set(100)
            end
        elseif SloWWalk then
            if TestAATimer:get() then
                yawAdd:set(-7)
                side_SlowWalk:set(2)
                llimit_SlowWalk:set(100)
            else
                yawAdd:set(20)
                side_SlowWalk:set(3)
                rlimit_SlowWalk:set(100)
            end
        elseif In_Air then
            if TestAATimer:get() then
                yawAdd:set(-5)
                side_move:set(2)
                llimit_move:set(100)
            else
                yawAdd:set(17)
                side_move:set(3)
                rlimit_move:set(100)
            end   
        elseif Air_crouch then
            if TestAATimer:get() then
                yawAdd:set(-6)
                side_move:set(2)
                llimit_move:set(100)
            else
                yawAdd:set(24)
                side_move:set(3)
                rlimit_move:set(100)
            end
        end
    end
    if MainAAPreset == (4) then -- Extreme AA Preset
        BodyLean:set(2)
        BodyLean_Moving:set(true)
        Pitch:set(2)
        YawBase:set(3)
        Rotate:set(true)
        Jitter:set(2)
        AntiBruteForce:set(false)
        OnShot:set(4)
        Ovveride_move:set(true)
        Ovveride_SlowWalk:set(true)

        if Standing then
            if TestAATimer:get() then
                yawAdd:set(11)
                side_stand:set(2)
                llimit_stand:set(100)
                BodyLean_value:set(50)
                Jitter_add:set(0)
                Rotate_range:set(0)
                Rotate_speed:set(0)
            else
                yawAdd:set(5)
                side_stand:set(3)
                rlimit_stand:set(100)
                BodyLean_value:set(-50)
                Jitter_add:set(0)
                Rotate_range:set(0)
                Rotate_speed:set(0)
            end
        elseif Moving then
                yawAdd:set(math.random(-6, 8))
                side_move:set(3)
                rlimit_move:set(100)
                BodyLean_value:set(-50)
                Jitter_add:set(0)
                Rotate_range:set(0)
                Rotate_speed:set(0)
        elseif SloWWalk then
                yawAdd:set(math.random(-6, 9))
                side_SlowWalk:set(3)
                llimit_SlowWalk:set(100)
                BodyLean_value:set(-50)
                Jitter_add:set(-2)
                Rotate_range:set(20)
                Rotate_speed:set(4)
        elseif In_Air then
            if TestAATimer:get() then
                yawAdd:set(-2)
                side_move:set(2)
                llimit_move:set(100)
                BodyLean_value:set(0)
                Jitter_add:set(0)
                Rotate_range:set(0)
                Rotate_speed:set(0)
            else
                yawAdd:set(32)
                side_move:set(3)
                rlimit_move:set(100)
                BodyLean_value:set(0)
                Jitter_add:set(0)
                Rotate_range:set(0)
                Rotate_speed:set(0)
            end
        elseif Air_crouch then
            if TestAATimer:get() then
                yawAdd:set(math.random(-12,-8))
                side_move:set(2)
                llimit_move:set(100)
                BodyLean_value:set(0)
                Jitter_add:set(0)
                Rotate_range:set(0)
                Rotate_speed:set(0)
            else
                yawAdd:set(math.random(26, 34))
                side_move:set(3)
                rlimit_move:set(21)
                BodyLean_value:set(0)
                Jitter_add:set(0)
                Rotate_range:set(0)
                Rotate_speed:set(0)
            end
        end
    end
    if MainAAPreset == (5) then -- Test AA Preset
        Pitch:set(2)
        YawBase:set(3)
        Rotate:set(false)
        Jitter:set(1)
        BodyLean:set(1)
        BodyLean_Moving:set(false)
        AntiBruteForce:set(false)
        OnShot:set(4)
        Ovveride_move:set(true)
        Ovveride_SlowWalk:set(true)

        if Standing then
            if TestAATimer:get() then             
                yawAdd:set(1-JitterDistance)
                side_stand:set(2)
                llimit_stand:set(4)
            else
                yawAdd:set(4+JitterDistance)
                side_stand:set(3)
                rlimit_stand:set(60)
            end
        elseif Moving then
            if TestAATimer:get() then
                yawAdd:set(-21-JitterDistance)
                side_move:set(2)
                llimit_move:set(100)
            else
                yawAdd:set(40+JitterDistance)
                side_move:set(3)
                rlimit_move:set(100)
            end
        elseif SloWWalk then
            if TestAATimer:get() then
                yawAdd:set(-4-JitterDistance)
                side_SlowWalk:set(2)
                llimit_SlowWalk:set(0)
            else
                yawAdd:set(4+JitterDistance)
                side_SlowWalk:set(3)
                rlimit_SlowWalk:set(0)
            end
            AntiBruteForce:set(false)
        elseif In_Air then
            if TestAATimer:get() then
                yawAdd:set(0-JitterDistance)
                side_move:set(2)
                llimit_move:set(10)
            else
                yawAdd:set(3+JitterDistance)
                side_move:set(3)
                rlimit_move:set(10)
            end 
        elseif Air_crouch then
            if TestAATimer:get() then
                yawAdd:set(8-JitterDistance)
                side_move:set(2) --V levo
                llimit_move:set(40)
            else
                yawAdd:set(25+JitterDistance)
                side_move:set(3) -- V pravo
                rlimit_move:set(58)
            end
        elseif AntiAimScoutch1 == (1) then --CruochMoving/A Push
            if TestAATimer:get() then
                yawAdd:set(1-JitterDistance)
                side_move:set(2)
                llimit_move:set(100)
            else
                yawAdd:set(21-JitterDistance)
                side_move:set(3)
                rlimit_move:set(100)
            end
        elseif AntiAimScoutch1 == (2) then --CruochMoving/D Push
            if TestAATimer:get() then
                yawAdd:set(1-JitterDistance)
                side_move:set(2)
                llimit_move:set(100)
            else
                yawAdd:set(21-JitterDistance)
                side_move:set(3)
                rlimit_move:set(100)
            end
        elseif CruochMovingL then --CruochMoving
            if TestAATimer:get() then
                yawAdd:set(1-JitterDistance)
                side_move:set(2)
                llimit_move:set(100)
            else
                yawAdd:set(21-JitterDistance)
                side_move:set(3)
                rlimit_move:set(100)
            end
        end
    end
    if MainAAPreset == (6) then -- AntiAIm Builder
        Ovveride_move:set(true)
        Ovveride_SlowWalk:set(true)
        Pitch:set(AntiAim_YawBasew:get())
        YawBase:set(AntiAim_YawBased:get())
        AntiBruteForce:set(AntiAim_AntiBruteForce:get())
        OnShot:set(AntiAim_OnShot:get())

        Rotate:set(AntiAim_Spin:get())
        Rotate_range:set(AntiAim_SpinRange:get())
        Rotate_speed:set(AntiAim_SpinSpeed:get())
        Jitter:set(AntiAim_Jitter:get())
        Jitter_add:set(AntiAim_JitterRange:get())

        if Standing then --Standing
            if AATypeStay:get() == 1 then
                if TestAATimer:get() then
                    yawAdd:set(AntiAim_YawStay:get()+MainStayYaw:get())
                    side_stand:set(2)
                    llimit_stand:set(AntiAim_LeftStay:get())
                else
                    yawAdd:set(AntiAim_Yaw2Stay:get()+MainStayYaw:get())
                    side_stand:set(3)
                    rlimit_stand:set(AntiAim_RightStay:get())  
                end 
            elseif AATypeStay:get() == 2 then
                yawAdd:set(AntiAim_YawStay:get()+MainStayYaw:get())
                side_stand:set(2)
                llimit_stand:set(AntiAim_LeftStay:get())
            elseif AATypeStay:get() == 3 then
                yawAdd:set(AntiAim_Yaw2Stay:get()+MainStayYaw:get())
                side_stand:set(3)
                rlimit_stand:set(AntiAim_RightStay:get()) 
            end
     elseif Moving then -- Moving
            if AATypeMOVE:get() == 1 then
                if TestAATimer:get() then
                    yawAdd:set(AntiAim_YawMOVE:get()+MainMovingYaw:get())
                    side_move:set(2)
                    llimit_move:set(AntiAim_LeftMOVE:get())
                else
                    yawAdd:set(AntiAim_Yaw2MOVE:get()+MainMovingYaw:get())
                    side_move:set(3)
                    rlimit_move:set(AntiAim_RightMOVE:get())  
                end 
            elseif AATypeMOVE:get() == 2 then
                yawAdd:set(AntiAim_YawMOVE:get()+MainMovingYaw:get())
                side_move:set(2)
                llimit_move:set(AntiAim_LeftMOVE:get())
            elseif AATypeMOVE:get() == 3 then
                yawAdd:set(AntiAim_Yaw2MOVE:get()+MainMovingYaw:get())
                side_move:set(3)
                rlimit_move:set(AntiAim_RightMOVE:get()) 
            end
        elseif SloWWalk then -- SloWWalking
            if AATypeSlowWalk:get() == 1 then
                if TestAATimer:get() then
                    yawAdd:set(AntiAim_YawSlowWalk:get()+MainSloWWalkingYaw:get())
                    side_SlowWalk:set(2)
                    llimit_SlowWalk:set(AntiAim_LeftSlowWalk:get())
                else
                    yawAdd:set(AntiAim_YawSlowWalk2:get()+MainSloWWalkingYaw:get())
                    side_SlowWalk:set(3)
                    rlimit_SlowWalk:set(AntiAim_RightSlowWalk:get())  
                end 
            elseif AATypeSlowWalk:get() == 2 then
                yawAdd:set(AntiAim_YawSlowWalk:get()+MainSloWWalkingYaw:get())
                side_SlowWalk:set(2)
                llimit_SlowWalk:set(AntiAim_LeftSlowWalk:get())
            elseif AATypeSlowWalk:get() == 3 then
                yawAdd:set(AntiAim_YawSlowWalk2:get()+MainSloWWalkingYaw:get())
                side_SlowWalk:set(3)
                rlimit_SlowWalk:set(AntiAim_RightSlowWalk:get()) 
            end
        elseif In_Air then -- In Air
            if AATypeJumpo:get() == 1 then
             if TestAATimer:get() then
                    yawAdd:set(AntiAim_YawJumpo:get()+MainJumpingYaw:get())
                    side_move:set(2)
                    llimit_move:set(AntiAim_LeftJumpo:get())
                else
                    yawAdd:set(AntiAim_Yaw2Jumpo:get()+MainJumpingYaw:get())
                    side_move:set(3)
                    rlimit_move:set(AntiAim_RightJumpo:get())  
                end 
            elseif AATypeJumpo:get() == 2 then
                yawAdd:set(AntiAim_YawJumpo:get()+MainJumpingYaw:get())
                side_move:set(2)
                llimit_move:set(AntiAim_LeftJumpo:get())
            elseif AATypeJumpo:get() == 3 then
                yawAdd:set(AntiAim_Yaw2Jumpo:get()+MainJumpingYaw:get())
                side_move:set(3)
                rlimit_move:set(AntiAim_RightJumpo:get()) 
            end
        elseif Air_crouch then -- Air_crouch
            if AATypeAirDuck:get() == 1 then
                if TestAATimer:get() then
                    yawAdd:set(AntiAim_YawAirDuck:get()+MainAirDuckYaw:get())
                    side_move:set(2)
                    llimit_move:set(AntiAim_LeftAirDuck:get())
                else
                    yawAdd:set(AntiAim_Yaw2AirDuck:get()+MainAirDuckYaw:get())
                    side_move:set(3)
                    rlimit_move:set(AntiAim_RightAirDuck:get())  
                end 
            elseif AATypeAirDuck:get() == 2 then
                yawAdd:set(AntiAim_YawAirDuck:get()+MainAirDuckYaw:get())
                side_move:set(2)
                llimit_move:set(AntiAim_LeftAirDuck:get())
            elseif AATypeAirDuck:get() == 3 then
                yawAdd:set(AntiAim_Yaw2AirDuck:get()+MainAirDuckYaw:get())
                side_move:set(3)
                rlimit_move:set(AntiAim_RightAirDuck:get()) 
            end
        elseif CruochMovingL then -- Cruoch Moving
            if AATypeSkrcMoving:get() == 1 then
                if TestAATimer:get() then
                    yawAdd:set(AntiAim_YawSkrcMoving:get()+MainCrouchYaw:get())
                    side_move:set(2)
                    llimit_move:set(AntiAim_LeftStaySkrcMoving:get())
                else
                    yawAdd:set(AntiAim_Yaw2SkrcMoving:get()+MainCrouchYaw:get())
                    side_move:set(3)
                    rlimit_move:set(AntiAim_RightStaySkrcMoving:get())  
                end 
            elseif AATypeSkrcMoving:get() == 2 then
                yawAdd:set(AntiAim_YawSkrcMoving:get()+MainCrouchYaw:get())
                side_move:set(2)
                llimit_move:set(AntiAim_LeftStaySkrcMoving:get())
            elseif AATypeSkrcMoving:get() == 3 then
                yawAdd:set(AntiAim_Yaw2SkrcMoving:get()+MainCrouchYaw:get())
                side_move:set(3)
                rlimit_move:set(AntiAim_RightStaySkrcMoving:get()) 
            end
        end
    end

end

function AntiAim_AnimationsClientSide(ctx)
    if ZeroPitchonlandandlegs:get() then       
		ctx:set_render_pose(e_poses.JUMP_FALL, 1)	  
    elseif ZeroPitchonlandandlegs:get() == false then
        ctx:set_render_pose(e_poses.JUMP_FALL, 0)
    end
end
---------------------------------Better Leg Fucker
--MenuAdd
AntiAim_BLFChecker = menu.add_checkbox("AntiAim","Better Leg Fucker")
AntiAim_BLFHowFast = menu.add_slider( "AntiAim", "LegFucker(Hidden)", 1, 8 )

AmtiAim_Cara3 = menu.add_text("AntiAim", "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")

--MenuFind
AntiAim_BLFFind = menu.find("antiaim","main","general","leg slide")

function AntiAim_LegFucker() 

    BetterLegFucker = HeviSSyncMain:get(1)
    AntiAim_BLFChecker:set_visible(BetterLegFucker)
    AmtiAim_Cara3:set_visible(BetterLegFucker)

    AntiAim_BLFHowFast:set_visible(false)
    

    if not engine.is_in_game() then return end
    if entity_list.get_local_player() == nil then return end
    if entity_list.get_local_player():is_alive() == (false) then return end

    BLFChecker = AntiAim_BLFChecker:get()
    
    if BLFChecker then
        if TestAATimer:get() then
            AntiAim_BLFFind:set(1)
        else
            AntiAim_BLFFind:set(3)  
        end
    end


end


-------------------------------------------------Better FakeLag
--MenuAdd
AntiAim_BFLChecker = menu.add_selection("AntiAim","Better FakeLag",{"OFF","Low Random", "High Random","1-7","10-15","Custom"})
AntiAim_BFLCustomeValue = menu.add_selection("AntiAim","Custome Mode",{"Switching Between","Random Between"})
AntiAim_BFLSliderOne = menu.add_slider("AntiAim", "First Value", 0, 15)
AntiAim_BFLSliderTwo = menu.add_slider("AntiAim", "Second Value", 0, 15)
AmtiAim_Cara4 = menu.add_text("AntiAim", "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")

--MenuFind
AntiAim_BFLFindSlider = menu.find("antiaim","main", "fakelag","amount")
AntiAim_BFLFindLagComp = menu.find("antiaim","main", "fakelag","break lag compensation")

function AntiAim_BetterFakeLag()
    BFLChecker = AntiAim_BFLChecker:get()
    
    --visibility
    ShowBFLMain = BFLChecker == (6) and HeviSSyncMain:get(1)
    AntiAim_BFLCustomeValue:set_visible(ShowBFLMain)
    AntiAim_BFLSliderOne:set_visible(ShowBFLMain)
    AntiAim_BFLSliderTwo:set_visible(ShowBFLMain)

    BetterLags = HeviSSyncMain:get(1)
    AntiAim_BFLChecker:set_visible(BetterLags)
    AmtiAim_Cara4:set_visible(BetterLags)

    if not engine.is_in_game() then return end
    if entity_list.get_local_player() == nil then return end
    if entity_list.get_local_player():is_alive() == (false) then return end

    BFLCustome = AntiAim_BFLCustomeValue:get()
    BFLOne = AntiAim_BFLSliderOne:get()
    BFLTwo = AntiAim_BFLSliderTwo:get()

    if BFLChecker == (2) then 
        AntiAim_BFLFindLagComp:set(true)
        AntiAim_BFLFindSlider:set(math.random(1, 7))
    elseif BFLChecker == (3) then
        AntiAim_BFLFindLagComp:set(true)
        AntiAim_BFLFindSlider:set(math.random(10, 15))
    end

    if BFLChecker == (4) then
        AntiAim_BFLFindLagComp:set(true)
        if TestAATimer:get() then
            AntiAim_BFLFindSlider:set(1)
         else
            AntiAim_BFLFindSlider:set(7)
        end
    end

    if BFLChecker == (5) then
        AntiAim_BFLFindLagComp:set(true)
        if TestAATimer:get() then
            AntiAim_BFLFindSlider:set(10)
         else
            AntiAim_BFLFindSlider:set(15)
        end
    end

    if BFLChecker == (6) and BFLCustome == (1) then
        AntiAim_BFLFindLagComp:set(true)
        if TestAATimer:get() then
            AntiAim_BFLFindSlider:set(BFLOne)
         else
            AntiAim_BFLFindSlider:set(BFLTwo)
        end
    elseif BFLChecker == (6) and BFLCustome == (2) then
        AntiAim_BFLFindSlider:set(math.random(BFLOne, BFLTwo))
    end
end

-------------------------------------------------------------------------------------------------Aim Bot-------------------------------------------------------------------------------------------------

-------------------------------------------------Extend Backtrack
--MenuAdd
AimBot_Cara = menu.add_text("AimBot", "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
AimBot_ExtendBTSelect = menu.add_selection("AimBot", "Extended backtrack", {"None","Manual", "AI ideal"})
AimBot_ExtendBTSlider = menu.add_slider("AimBot", "Backtrack amount", 0, 10)
AimBot_Cara2 = menu.add_text("AimBot", "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")

--MenuFind
Extend_BackTrack_Type = menu.find("aimbot","general", "fake ping","type")
Extend_BackTrack_amount = menu.find("aimbot","general", "fake ping","ping amount")

function AimBot_ExtendBt()
    EX_Selection = AimBot_ExtendBTSelect:get()
    EX_Slider = AimBot_ExtendBTSlider:get()
    --visibility
    MainExtendBT = HeviSSyncMain:get(2)
    AimBot_ExtendBTSelect:set_visible(MainExtendBT)
    AimBot_Cara:set_visible(MainExtendBT)
    AimBot_Cara2:set_visible(MainExtendBT)
        
    ShowToEX = EX_Selection == (2) and HeviSSyncMain:get(2)
    AimBot_ExtendBTSlider:set_visible(ShowToEX)

    if not engine.is_in_game() then return end
    if entity_list.get_local_player() == nil then return end
    if entity_list.get_local_player():is_alive() == (false) then 
    return end
   
    if EX_Selection == (1) then
        
        EX_HowMuchYouWant = math.abs(EX_Slider)*20+1

        Extend_BackTrack_Type:set(1)
        Extend_BackTrack_amount:set(EX_HowMuchYouWant)
    elseif EX_Selection == (2) then
        Extend_BackTrack_Type:set(2)
        Extend_BackTrack_amount:set(0)
    end

end



-------------------------------------------------------------------------------------------------Visual-------------------------------------------------------------------------------------------------
-------------------------------------------------Indicators
--MenuAdd
Visuals_Cara = menu.add_text("Visuals", "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
Visuals_indicators_Main = menu.add_selection("Visuals", "Indicators", {"None","Left", "Under Crosshair"})
Visuals_colors = Visuals_indicators_Main:add_color_picker("Indicators color")
Visuals_colors2 = Visuals_indicators_Main:add_color_picker("Indicators color2")
JakRychleCas3 = menu.add_slider( "Timer", "Timer", 1, 15 )
Visual_FontYouWant = menu.add_selection("Visuals", "Font", {"Smallest Pixel-7", "Verdana"})
Visual_Font_big = menu.add_slider( "Visuals", "Text size", -10, 10 )
Visual_UpDown = menu.add_slider( "Visuals", "Up/Down", -500, 500 )
Visuals_Cara2 = menu.add_text("Visuals", "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")

Visual = menu.add_slider( "Secret", "Text uplne", -10, 10 )





--MenuFind
Visuals_DTFind = menu.find("aimbot","general","exploits","doubletap","enable")
Visuals_HSFind = menu.find("aimbot","general","exploits","hideshots","enable")
Visuals_AutoPeekind = menu.find("aimbot","general","misc","autopeek")
Visuals_SlowWalkFind = menu.find("misc","main","movement","slow walk")
Visuals_FDFind = menu.find("antiaim","main","general","fake duck")
Visuals_ScoutDMG = menu.find("aimbot","scout","target overrides","force min. damage")
Visuals_AutoDMG = menu.find("aimbot","auto","target overrides","force min. damage")
Visuals_AWPDMG = menu.find("aimbot","awp","target overrides","force min. damage")
Visuals_DeagleDMG = menu.find("aimbot","deagle","target overrides","force min. damage")
Visuals_RevolverDMG = menu.find("aimbot","revolver","target overrides","force min. damage")
Visuals_pistolDMG = menu.find("aimbot","pistols","target overrides","force min. damage")
Visuals_otherDMG = menu.find("aimbot","other","target overrides","force min. damage")
Visuals_BodyLeanResolver = menu.find("aimbot","general","aimbot","body lean resolver")
Visuals_ResolverOverride = menu.find("aimbot","general","aimbot","override resolver")
Visuals_ExtendBT_Type = menu.find("aimbot","general","fake ping","type")
Visuals_ManualLeftFind = menu.find("antiaim","main","manual","left")
Visuals_ManualBackFind = menu.find("antiaim","main","manual","back")
Visuals_ManualRightFind = menu.find("antiaim","main","manual","right")
Visuals_DTCharge = menu.find("aimbot","general","exploits","uncharge delay")

Visuals_ScoutDMGMain = menu.find("aimbot","scout","targeting","min. damage")
Visuals_autoDMGMain = menu.find("aimbot","auto","targeting","min. damage")
Visuals_awpDMGMain = menu.find("aimbot","awp","targeting","min. damage")
Visuals_deagleDMGMain = menu.find("aimbot","deagle","targeting","min. damage")
Visuals_revolverDMGMain = menu.find("aimbot","revolver","targeting","min. damage")
Visuals_pistolsDMGMain = menu.find("aimbot","pistols","targeting","min. damage")
Visuals_otherDMGMain = menu.find("aimbot","other","targeting","min. damage")

Visuals_IfAAOF = menu.find("antiaim","main","general","disable states")

function Visuals_Indicators()

    local RainbowColor = (global_vars.real_time() * 5) % 100

    AYIndicators = 0

    Visual:set_visible(false)

    IndicatorsVisualMane = HeviSSyncMain:get(3)
    Visuals_Cara:set_visible(IndicatorsVisualMane)
    Visuals_indicators_Main:set_visible(IndicatorsVisualMane)
    Visuals_Cara2:set_visible(IndicatorsVisualMane)

    --visibility
    ShowOnlyForIndicators = Visuals_indicators_Main:get() == (2) and HeviSSyncMain:get(3)
    Visual_Font_big:set_visible(ShowOnlyForIndicators)
    Visual_UpDown:set_visible(ShowOnlyForIndicators)
    Visual_FontYouWant:set_visible(ShowOnlyForIndicators)

    Indicatorsdva = Visuals_indicators_Main:get() == 2 and HeviSSyncMain:get(3) 
    Visual_Font_big:set_visible(Indicatorsdva, false)
    Visual_UpDown:set_visible(Indicatorsdva, false)

    JakRychleCas3:set_visible(false)

   if not engine.is_in_game() then return end
   
    Visuals_localPlayer = entity_list.get_local_player()
    if Visuals_localPlayer == nil then return end
    Visual_isAlive = Visuals_localPlayer:is_alive()

    if Visual_isAlive == (false) then return end
  
    Standing = vars.player_state == "NotMovingg"
    Moving = vars.player_state == "moving"
    SloWWalk = vars.player_state == "slow motion"
    In_Air = vars.player_state == "jumping"
    Air_crouch = vars.player_state == "air duck"  
    CruochMovingL = vars.player_state == "CrouchMoving"

    EzENtitaNASpeed = entity_list.get_local_player()
    SPeedVelocity = math.floor(state.get_velocity(EzENtitaNASpeed))

    local Visual_local_player = entity_list.get_local_player()

    if (Visual_local_player and Visual_local_player:is_player() and Visual_local_player:is_alive()) then
        local active_weapon = Visual_local_player:get_active_weapon()

        if (active_weapon and active_weapon:is_weapon()) then
            visuals_NameGuns = active_weapon:get_name()
        end
    end

    JakRychleCas3:set(15)
    HowBIG = Visual_Font_big:get()
    UpDOwn = Visual_UpDown:get()
 
        FontForVisualsIndica = Visual_FontYouWant:get()
    --font
    if FontForVisualsIndica == (1) and Visuals_indicators_Main:get() == (2) then
        Font_For_Indicators2 = render.create_font("Smallest Pixel-7", 21+HowBIG, 615, e_font_flags.OUTLINE, e_font_flags.DROPSHADOW) 
    elseif FontForVisualsIndica == (2) and Visuals_indicators_Main:get() == (2) then 
        Font_For_Indicators2 = render.create_font("Verdana", 21+HowBIG, 615, e_font_flags.OUTLINE)
    end


    pixelForIndicarorsV2 = render.create_font("Smallest Pixel-7", 10, 20, e_font_flags.OUTLINE)   
    randomnumer = math.random(100, 250)
    Indicators_TickCharget_OnlyForDT = exploits.get_charge()
    IndicatorsMain = Visuals_indicators_Main:get() 

    Indicators_MainColor = color_t(Visuals_colors:get().r, Visuals_colors:get().g, Visuals_colors:get().b, Visuals_colors:get().a)

    Is_DT_On = Visuals_DTFind[2]:get()
    Is_HS_On = Visuals_HSFind[2]:get()
    Is_FD_On = Visuals_FDFind[2]:get()
    Is_AutoPeek_On = Visuals_AutoPeekind[2]:get()
    Is_SW_On = Visuals_SlowWalkFind[2]:get()
    Is_ScoutOvveride_On = Visuals_ScoutDMG[2]:get()
    Is_AutotOvveride_On = Visuals_AutoDMG[2]:get()
    Is_AWPOvveride_On = Visuals_AWPDMG[2]:get()
    Is_DeagleOvveride_On = Visuals_DeagleDMG[2]:get()
    Is_RevolverOvveride_On = Visuals_RevolverDMG[2]:get()
    Is_PistolOvveride_On = Visuals_pistolDMG[2]:get()
    Is_OtherOvveride_On = Visuals_otherDMG[2]:get()

    --    
    Is_ManualLeft_On = Visuals_ManualLeftFind[2]:get()
    Is_Manualback_On = Visuals_ManualBackFind[2]:get()
    Is_Manualright_On = Visuals_ManualRightFind[2]:get()

    --
    Is_BLR_ON = Visuals_BodyLeanResolver[2]:get()
    Is_RO_ON = Visuals_ResolverOverride[2]:get()
    Is_EXTENDBTType_ON = Visuals_ExtendBT_Type:get()

    ScoutOvverideDmg = Visuals_ScoutDMG[1]:get()
    autoOvverideDmg = Visuals_AutoDMG[1]:get()
    awpOvverideDmg = Visuals_AWPDMG[1]:get()
    deagleOvverideDmg = Visuals_DeagleDMG[1]:get()
    revolverOvverideDmg = Visuals_RevolverDMG[1]:get()
    pistolOvverideDmg = Visuals_pistolDMG[1]:get()
    otherOvverideDmg = Visuals_otherDMG[1]:get()
    
    SCoutDMGMAin = Visuals_ScoutDMGMain:get()
    AutoDMGMAin = Visuals_autoDMGMain:get()
    AWPDMGMAin = Visuals_awpDMGMain:get()
    DeagleDMGMAin = Visuals_deagleDMGMain:get()
    RevolverDMGMAin = Visuals_revolverDMGMain:get()
    PistolsDMGMAin = Visuals_pistolsDMGMain:get()
    otherDMGMAin = Visuals_otherDMGMain:get()

    Font_For_Indicators2CroSSHair = render.create_font("Smallest Pixel-7", 10+HowBIG, 200, e_font_flags.OUTLINE, e_font_flags.DROPSHADOW) 
    Font_For_Indicators2bigCroSSHair = render.create_font("Smallest Pixel-7", 40+HowBIG, 200, e_font_flags.OUTLINE, e_font_flags.DROPSHADOW) 
    Font_For_Indicators2ssCroSSHair = render.create_font("Smallest Pixel-7", 9+HowBIG, 200, e_font_flags.OUTLINE, e_font_flags.DROPSHADOW) 
    Font_For_Indicators33CroSSHair = render.create_font("Smallest Pixel-7", 20+HowBIG, 200, e_font_flags.OUTLINE, e_font_flags.DROPSHADOW) 
    Font_For_Indicators33CroSSHairss = render.create_font("Verdana", 15+HowBIG, 200, e_font_flags.OUTLINE, e_font_flags.DROPSHADOW) 
    Font_For_Indicators2CroSSHairSmol = render.create_font("Smallest Pixel-7", 7+HowBIG, 200, e_font_flags.OUTLINE, e_font_flags.DROPSHADOW) 

    LocalHrac = entity_list.get_local_player()
    inScope = LocalHrac:get_prop("m_bIsScoped")

    gunList = {
        {nazev = "ssg08", ovveride = Is_ScoutOvveride_On, dmg = SCoutDMGMAin, dmg_overrided = ScoutOvverideDmg},
        {nazev = "scar20", ovveride = Is_AutotOvveride_On, dmg = AutoDMGMAin, dmg_overrided = autoOvverideDmg},
        {nazev = "g3sg1", ovveride = Is_AutotOvveride_On, dmg = AutoDMGMAin, dmg_overrided = autoOvverideDmg},
        {nazev = "awp", ovveride = Is_AWPOvveride_On, dmg = AWPDMGMAin, dmg_overrided = awpOvverideDmg},
        {nazev = "deagle", ovveride = Is_DeagleOvveride_On, dmg = DeagleDMGMAin, dmg_overrided = deagleOvverideDmg},
        {nazev = "revolver", ovveride = Is_DeagleOvveride_On, dmg = RevolverDMGMAin, dmg_overrided = revolverOvverideDmg},
        --pistols
        {nazev = "p2000", ovveride = Is_PistolOvveride_On, dmg = PistolsDMGMAin, dmg_overrided = pistolOvverideDmg},
        {nazev = "elite", ovveride = Is_PistolOvveride_On, dmg = PistolsDMGMAin, dmg_overrided = pistolOvverideDmg},
        {nazev = "p250", ovveride = Is_PistolOvveride_On, dmg = PistolsDMGMAin, dmg_overrided = pistolOvverideDmg},
        {nazev = "fiveseven", ovveride = Is_PistolOvveride_On, dmg = PistolsDMGMAin, dmg_overrided = pistolOvverideDmg},
        {nazev = "glock", ovveride = Is_PistolOvveride_On, dmg = PistolsDMGMAin, dmg_overrided = pistolOvverideDmg},
        {nazev = "tec9", ovveride = Is_PistolOvveride_On, dmg = PistolsDMGMAin, dmg_overrided = pistolOvverideDmg},
        {nazev = "usp-s", ovveride = Is_PistolOvveride_On, dmg = PistolsDMGMAin, dmg_overrided = pistolOvverideDmg},
        --Others
        {nazev = "ak47", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg},
        {nazev = "sg556", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg},
        {nazev = "galilar", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg},
        {nazev = "mac10", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg},
        {nazev = "mp7", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg},
        {nazev = "ump45", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg},
        {nazev = "p90", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg},
        {nazev = "bizon", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg},
        {nazev = "nova", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg},
        {nazev = "xm1014", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg},
        {nazev = "sawedoff", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg},
        {nazev = "m249", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg},
        {nazev = "negev", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg},
        {nazev = "famas", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg},
        {nazev = "m4a1", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg},
        {nazev = "aug", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg},
        {nazev = "mp9", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg},
        {nazev = "mag7", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg},
        {nazev = "m4a1-s", ovveride = Is_OtherOvveride_On, dmg = otherDMGMAin, dmg_overrided = otherOvverideDmg}
    }

    if IndicatorsMain == (2) then
        ovveride_AllWeap = Is_ScoutOvveride_On == (true) or Is_AutotOvveride_On == (true) or Is_DeagleOvveride_On == (true) or Is_RevolverOvveride_On == (true) or Is_PistolOvveride_On == (true) or Is_OtherOvveride_On == (true) or Is_AWPOvveride_On == (true)

        

        --DT/HS/FD/Indicators
        if Is_FD_On == (true) then
            if global_vars.cur_time() - Cas_prave_Ted2 > JakRychleCas3:get() * 0.01 then   
                Cas_prave_Ted2 = global_vars.cur_time()    
                render.text(Font_For_Indicators2, "FD", vec2_t(20, 610+UpDOwn+AYIndicators), color_t(255, 0, 0, 100))
                AYIndicators = AYIndicators + 30
            else        
                render.text(Font_For_Indicators2, "FD", vec2_t(20, 610+UpDOwn+AYIndicators), Indicators_MainColor)
                AYIndicators = AYIndicators + 30                
            end
        elseif Is_DT_On == (true) and Indicators_TickCharget_OnlyForDT == (14) then
            render.text(Font_For_Indicators2, "DT", vec2_t(20, 610+UpDOwn+AYIndicators), Indicators_MainColor)
            render.text(Font_For_Indicators2, "〈 Charged 〉", vec2_t(55, 610+UpDOwn+AYIndicators), Indicators_MainColor)
            AYIndicators = AYIndicators + 30
        elseif Is_DT_On == (true) and Indicators_TickCharget_OnlyForDT<14 then
            render.text(Font_For_Indicators2, "DT", vec2_t(20, 610+UpDOwn+AYIndicators), color_t(255, 0, 0, 100))
            render.text(Font_For_Indicators2, "〈 " ..exploits.get_charge().." ☓ 〉", vec2_t(55, 610+UpDOwn), color_t(255, 0, 0, 100))   
            AYIndicators = AYIndicators + 30         
        elseif Is_HS_On == (true) and Indicators_TickCharget_OnlyForDT == (14) then
            render.text(Font_For_Indicators2, "HS", vec2_t(20, 610+UpDOwn+AYIndicators), Indicators_MainColor) 
            render.text(Font_For_Indicators2, "〈 Charged 〉", vec2_t(55, 610+UpDOwn+AYIndicators), Indicators_MainColor)
            AYIndicators = AYIndicators + 30
        elseif Is_HS_On == (true) and Indicators_TickCharget_OnlyForDT<14 then
            render.text(Font_For_Indicators2, "HS", vec2_t(20, 610+UpDOwn+AYIndicators), color_t(255, 0, 0, 100)) 
            render.text(Font_For_Indicators2, "〈 " ..exploits.get_charge().." ☓ 〉", vec2_t(55, 610+UpDOwn), color_t(255, 0, 0, 100)) 
            AYIndicators = AYIndicators + 30
        end

        if Is_AutoPeek_On then render.text(Font_For_Indicators2, "AutoPeek", vec2_t(20, 610+UpDOwn+AYIndicators), Indicators_MainColor) 
            AYIndicators = AYIndicators + 30 end
        if ovveride_AllWeap then render.text(Font_For_Indicators2, "DMG Override", vec2_t(20, 610+UpDOwn+AYIndicators), Indicators_MainColor)
            AYIndicators = AYIndicators + 30 end
        if Is_BLR_ON then render.text(Font_For_Indicators2, "Roll Resolver", vec2_t(20, 610+UpDOwn+AYIndicators), Indicators_MainColor)
            AYIndicators = AYIndicators + 30 end
        if Is_RO_ON then render.text(Font_For_Indicators2, "Resolver Override", vec2_t(20, 610+UpDOwn+AYIndicators), Indicators_MainColor)
            AYIndicators = AYIndicators + 30 end
             
        for key,value in pairs(gunList) do
            if value.ovveride and visuals_NameGuns == value.nazev then
                render.text(Font_For_Indicators2, "DMG : ".. value.dmg_overrided .."", vec2_t(20, 550+UpDOwn), Indicators_MainColor)
            elseif visuals_NameGuns == value.nazev then
                render.text(Font_For_Indicators2, "DMG : ".. value.dmg .."", vec2_t(20, 550+UpDOwn), Indicators_MainColor)
            elseif visuals_NameGuns == "knife" or visuals_NameGuns == "taser" then -- knife/taser
                render.text(Font_For_Indicators2, "DMG : Auto", vec2_t(20, 550+UpDOwn), Indicators_MainColor)
            end
        end

  
        if antiaim.get_manual_override() == 0 then
            render.text(Font_For_Indicators2, "", vec2_t(20, 520+UpDOwn), Indicators_MainColor)
        elseif antiaim.get_manual_override() == 1 then
            render.text(Font_For_Indicators2, "<----", vec2_t(20, 520+UpDOwn), Indicators_MainColor)
        elseif antiaim.get_manual_override() == 3 then
            render.text(Font_For_Indicators2, "---->", vec2_t(20, 520+UpDOwn), Indicators_MainColor)     
        elseif antiaim.get_manual_override() == 2 then
            render.text(Font_For_Indicators2, "▽", vec2_t(30+HowBIG, 520+UpDOwn), Indicators_MainColor)   
        end

        if Standing then
            render.text(Font_For_Indicators2, "State : Standing 〈 " ..SPeedVelocity.." 〉", vec2_t(20, 580+UpDOwn), Indicators_MainColor)
        elseif Moving then
            render.text(Font_For_Indicators2, "State : Moving 〈 " ..SPeedVelocity.." 〉", vec2_t(20, 580+UpDOwn), Indicators_MainColor)
        elseif SloWWalk then
            render.text(Font_For_Indicators2, "State : Slowwalking 〈 " ..SPeedVelocity.." 〉", vec2_t(20, 580+UpDOwn), Indicators_MainColor)
        elseif In_Air then
            render.text(Font_For_Indicators2, "State : In air 〈 " ..SPeedVelocity.." 〉", vec2_t(20, 580+UpDOwn), Indicators_MainColor)
        elseif Air_crouch then
            render.text(Font_For_Indicators2, "State : Crouch in air 〈 " ..SPeedVelocity.." 〉", vec2_t(20, 580+UpDOwn), Indicators_MainColor)
        elseif CruochMovingL then
            render.text(Font_For_Indicators2, "State : Crouching 〈 " ..SPeedVelocity.." 〉", vec2_t(20, 580+UpDOwn), Indicators_MainColor)
        end

    elseif IndicatorsMain == (3) then

        All_Weapons_Ovveride_Dmg = Is_ScoutOvveride_On and ScoutOvverideDmg or Is_AutotOvveride_On and autoOvverideDmg or awpOvverideDmg or deagleOvverideDmg or revolverOvverideDmg or pistolOvverideDmg or otherOvverideDmg

        if IndicatorsMain == (3) and inScope == (1) then     
            Animace1 = animation.lerp(Animace1, 19, global_vars.frame_time() * 6)
            Animace2 = animation.lerp(Animace2, 23, global_vars.frame_time() * 6)
            Animace3 = animation.lerp(Animace3, 35, global_vars.frame_time() * 6)
            Animace4 = animation.lerp(Animace4, 35, global_vars.frame_time() * 6)
            Animace5 = animation.lerp(Animace5, 56, global_vars.frame_time() * 6)
            Animace6 = animation.lerp(Animace6, 47, global_vars.frame_time() * 6)
            Animace7 = animation.lerp(Animace7, 34, global_vars.frame_time() * 6)
            Animace8 = animation.lerp(Animace8, 29, global_vars.frame_time() * 6)
            Animace9 = animation.lerp(Animace9, 29, global_vars.frame_time() * 6)
            Animace10 = animation.lerp(Animace10, 48, global_vars.frame_time() * 6)
            Animace11 = animation.lerp(Animace11, 34, global_vars.frame_time() * 6)
            Animace12 = animation.lerp(Animace12, 37, global_vars.frame_time() * 6)
            Animace13 = animation.lerp(Animace13, 36, global_vars.frame_time() * 6)
        else
            Animace1 = animation.lerp(Animace1, 0, global_vars.frame_time() * 6)
            Animace2 = animation.lerp(Animace2, 0, global_vars.frame_time() * 6)
            Animace3 = animation.lerp(Animace3, 0, global_vars.frame_time() * 6)
            Animace4 = animation.lerp(Animace4, 0, global_vars.frame_time() * 6) 
            Animace5 = animation.lerp(Animace5, 0, global_vars.frame_time() * 6)
            Animace6 = animation.lerp(Animace6, 0, global_vars.frame_time() * 6)
            Animace7 = animation.lerp(Animace7, 0, global_vars.frame_time() * 6)
            Animace8 = animation.lerp(Animace8, 0, global_vars.frame_time() * 6)
            Animace9 = animation.lerp(Animace9, 0, global_vars.frame_time() * 6)
            Animace10 = animation.lerp(Animace10, 0, global_vars.frame_time() * 6)
            Animace11 = animation.lerp(Animace11, 0, global_vars.frame_time() * 6)
            Animace12 = animation.lerp(Animace12, 0, global_vars.frame_time() * 6)
            Animace13 = animation.lerp(Animace13, 0, global_vars.frame_time() * 6)
        end

        local enemies_only = entity_list.get_players(true) 

        for _, enemy in pairs(enemies_only) do
            if enemy:is_alive() == false and Visual_isAlive and Visuals_IfAAOF:get(2) then
                IfEnemyNOtThere = math.abs(IfEnemyOff)+1
            elseif Visuals_IfAAOF:get(2) == false or enemy:is_alive() or Visual_isAlive == false then
                IfEnemyNOtThere = math.abs(IfEnemyOff)-1
            end
        end

        DMG_ovveride_AllWeapons = Is_ScoutOvveride_On or Is_AutotOvveride_On or Is_AWPOvveride_On or Is_DeagleOvveride_On or Is_RevolverOvveride_On or Is_PistolOvveride_On or Is_OtherOvveride_On
        
        render.text(Font_For_Indicators33CroSSHairss, "HeviSSync", vec2_t(926+Animace6, 550), Indicators_MainColor) AYIndicators = AYIndicators + 15


        if Is_FD_On or Is_HS_On == false and Is_DT_On == false then
            render.text(Font_For_Indicators2ssCroSSHair, "", vec2_t(970+Animace1, 552+AYIndicators), Indicators_MainColor)
        elseif exploits.get_charge() <= 1 then
            render.text(Font_For_Indicators2ssCroSSHair, "◯", vec2_t(970+Animace1, 552+AYIndicators), Visuals_colors2:get())
        elseif exploits.get_charge() > 1 and exploits.get_charge() <= 4 then
            render.text(Font_For_Indicators33CroSSHair, "◔", vec2_t(970+Animace1, 544+AYIndicators), Visuals_colors2:get())
        elseif exploits.get_charge() > 4 and exploits.get_charge() <= 7 then
            render.text(Font_For_Indicators33CroSSHair, "◑", vec2_t(970+Animace1, 543+AYIndicators), Visuals_colors2:get())
        elseif exploits.get_charge() > 7 and exploits.get_charge() <=13 then
            render.text(Font_For_Indicators33CroSSHair, "◕", vec2_t(970+Animace1, 542+AYIndicators), Visuals_colors2:get())
        elseif exploits.get_charge() > 13 then
            render.text(Font_For_Indicators33CroSSHair, "●", vec2_t(970+Animace1, 542+AYIndicators), Visuals_colors2:get())
        end

        if Is_FD_On then
            render.text(Font_For_Indicators2CroSSHair, "FD", vec2_t(956+Animace1, 550+AYIndicators), Indicators_MainColor) AYIndicators = AYIndicators + 10
        elseif Is_DT_On then
            render.text(Font_For_Indicators2CroSSHair, "DT", vec2_t(956+Animace1, 550+AYIndicators), Indicators_MainColor) AYIndicators = AYIndicators + 10
        elseif Is_HS_On then
            render.text(Font_For_Indicators2CroSSHair, "HS", vec2_t(956+Animace1, 550+AYIndicators), Indicators_MainColor) AYIndicators = AYIndicators + 10
        end

        if Standing then
            render.text(Font_For_Indicators2CroSSHair, "Standing", vec2_t(941+Animace7, 550+AYIndicators), Indicators_MainColor) AYIndicators = AYIndicators + 10
        elseif Moving then
            render.text(Font_For_Indicators2CroSSHair, "Moving", vec2_t(946+Animace8, 550+AYIndicators), Indicators_MainColor) AYIndicators = AYIndicators + 10
        elseif SloWWalk then
            render.text(Font_For_Indicators2CroSSHair, "Slowwalk", vec2_t(940+Animace4, 550+AYIndicators), Indicators_MainColor) AYIndicators = AYIndicators + 10
        elseif In_Air then
            render.text(Font_For_Indicators2CroSSHair, "In air", vec2_t(946+Animace9, 550+AYIndicators), Indicators_MainColor) AYIndicators = AYIndicators + 10
        elseif CruochMovingL then
            render.text(Font_For_Indicators2CroSSHair, "Crouching", vec2_t(938+Animace12, 550+AYIndicators), Indicators_MainColor) AYIndicators = AYIndicators + 10
        elseif Air_crouch then

        end
        
        for key,value in pairs(gunList) do
            if value.ovveride and visuals_NameGuns == value.nazev then
                render.text(Font_For_Indicators2CroSSHair, "DMG : ", vec2_t(941+Animace11, 550+AYIndicators), Indicators_MainColor)
                render.text(Font_For_Indicators2CroSSHair, "      ".. value.dmg_overrided .."", vec2_t(939+Animace11, 550+AYIndicators), Visuals_colors2:get()) AYIndicators = AYIndicators + 10
            end
        end

        if Is_AutoPeek_On then
            render.text(Font_For_Indicators2CroSSHair, "AutoPeek", vec2_t(940+Animace3, 550+AYIndicators), Indicators_MainColor) AYIndicators = AYIndicators + 10
        end

        if antiaim.get_manual_override() == 1 then 
            render.text(Font_For_Indicators2bigCroSSHair, "⇽", vec2_t(919, 515), Visuals_colors2:get())   
            render.text(Font_For_Indicators2CroSSHair, "Manual", vec2_t(948, 520), Indicators_MainColor)
        elseif antiaim.get_manual_override() == 2 then 
            render.text(Font_For_Indicators33CroSSHair, "▽", vec2_t(928, 533), Visuals_colors2:get())   
            render.text(Font_For_Indicators33CroSSHair, "▽", vec2_t(981, 533), Visuals_colors2:get())
            render.text(Font_For_Indicators2CroSSHair, "Manual", vec2_t(948, 520), Indicators_MainColor)
        elseif antiaim.get_manual_override() == 3 then 
            render.text(Font_For_Indicators2bigCroSSHair, "⇾", vec2_t(979, 515), Visuals_colors2:get())   
            render.text(Font_For_Indicators2CroSSHair, "Manual", vec2_t(948, 520), Indicators_MainColor)
        elseif antiaim.get_desync_side() == 0 then
            render.text(Font_For_Indicators2CroSSHair, "Direction :", vec2_t(939+Animace13, 550+AYIndicators), Indicators_MainColor) 
            render.text(Font_For_Indicators2CroSSHair, "             No", vec2_t(930+Animace13, 550+AYIndicators), Visuals_colors2:get())AYIndicators = AYIndicators + 10
        elseif antiaim.get_desync_side() == 1 then
            render.text(Font_For_Indicators2CroSSHair, "Direction :", vec2_t(939+Animace13, 550+AYIndicators), Indicators_MainColor) 
            render.text(Font_For_Indicators2CroSSHair, "             L", vec2_t(930+Animace13, 550+AYIndicators), Visuals_colors2:get())AYIndicators = AYIndicators + 10
        elseif antiaim.get_desync_side() == 2 then
            render.text(Font_For_Indicators2CroSSHair, "Direction :", vec2_t(939+Animace13, 550+AYIndicators), Indicators_MainColor) 
            render.text(Font_For_Indicators2CroSSHair, "             R", vec2_t(930+Animace13, 550+AYIndicators), Visuals_colors2:get())AYIndicators = AYIndicators + 10
        end

        if Air_crouch then
            render.text(Font_For_Indicators2CroSSHair, "Crouch in air", vec2_t(927+Animace10, 550+AYIndicators), Indicators_MainColor) AYIndicators = AYIndicators + 10
        end

        if Is_BLR_ON then
            render.text(Font_For_Indicators2CroSSHair, "BodyLean Resolver", vec2_t(919+Animace5, 550+AYIndicators), Indicators_MainColor) AYIndicators = AYIndicators + 10
        end
        if Is_RO_ON then
            render.text(Font_For_Indicators2CroSSHair, "Resolver Override", vec2_t(919+Animace5, 550+AYIndicators), Indicators_MainColor) AYIndicators = AYIndicators + 10
        end
    end  
end
-------------------------------------------------HitLogs
--MenuAdd
Visuals_HitLogs_MainPush = menu.add_multi_selection("Visuals", "HitLogs", {"Under Crosshair", "Console", "Chat"})
Visuals_colorsHotlogs = Visuals_HitLogs_MainPush:add_color_picker("HitLogs color")
Visuals_colorsHotlogss = Visuals_HitLogs_MainPush:add_color_picker("HitLogs color")
Visuals_HitLogsHitMiss = menu.add_multi_selection("Visuals", "Show only", {"Hits", "Miss"})
Visuals_Cara3 = menu.add_text("Visuals", "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")

function Visible_for_HitLogs()
    HitLogVisualMane = HeviSSyncMain:get(3)
    Visuals_HitLogs_MainPush:set_visible(HitLogVisualMane)
    Visuals_Cara3:set_visible(HitLogVisualMane)

    MisOrHitVisibility = Visuals_HitLogs_MainPush:get(1) and HeviSSyncMain:get(3) or Visuals_HitLogs_MainPush:get(2) and HeviSSyncMain:get(3) or Visuals_HitLogs_MainPush:get(3) and HeviSSyncMain:get(3)
    Visuals_HitLogsHitMiss:set_visible(MisOrHitVisibility)
end


function Visuals_HitLogs_Main()
    if Visuals_HitLogs_MainPush:get(1) then
        fonts =
        {
            regular = render.create_font("Verdana", 14, 800); 
        }


    if (engine.is_connected() ~= true) then
        return
    end

    time = global_vars.frame_time()

    screenSize = render.get_screen_size()
    screenWidth = screenSize.x
    screenHeight = screenSize.y

    for i = 1, #logs do
        log = logs[i]
        if log == nil then goto continue
        end
        x = screenWidth / 2
        y = screenHeight / 1.25 + (i * 15)
        alpha = 0

        if (log.state == 'appearing') then
            -- Fade in.
            progress = log.currentTime / log.lifeTime.fadeIn
            x = x - Lerp(log.offset, 0, Ease(progress))
            alpha = Lerp(0, 255, Ease(progress))

            log.currentTime = log.currentTime + time
            if (log.currentTime >= log.lifeTime.fadeIn) then
                log.state = 'visible'

                -- Reset time.
                log.currentTime = 0
            end


        elseif(log.state == 'visible') then
        -- Fully opaque.
        alpha = 255

        log.currentTime = log.currentTime + time
        if (log.currentTime >= log.lifeTime.visible) then
            log.state = 'disappearing'

            -- Reset Time.
            log.currentTime = 0
        end

        elseif(log.state == 'disappearing') then
            -- Fade out.
            local progress = log.currentTime / log.lifeTime.fadeOut
            x = x + Lerp(0, log.offset, Ease(progress))
            alpha = Lerp(255, 0, Ease(progress))

            log.currentTime = log.currentTime + time
            if(log.currentTime >= log.lifeTime.fadeOut) then
                table.remove(logs, i)
                goto continue
            end
        end

        -- Increase the total time.
        log.totalTime = log.totalTime + time

        alpha = math.floor(alpha)
        YourChoiceColor = color_t(Visuals_colorsHotlogs:get().r, Visuals_colorsHotlogs:get().g, Visuals_colorsHotlogs:get().b, Visuals_colorsHotlogs:get().a) 
        MenuColorMain = color_t(Visuals_colorsHotlogss:get().r, Visuals_colorsHotlogss:get().g, Visuals_colorsHotlogss:get().b, Visuals_colorsHotlogss:get().a) 

        message = {}

        -- Add header and body to message
        combined = {}

        for a = 1, #log.header do
            t = log.header[a]
            table.insert(combined, t)
        end

        for a = 1, #log.body do
             t = log.body[a]
            table.insert(combined, t)
        end

        for j = 1, #combined do
             data = combined[j]

             text = tostring(data[1])
             color = data[2]

            -- Push the data to the message.
            table.insert(message,{text, color and MenuColorMain or YourChoiceColor})
        end

        -- Draw log.
         render_font = nil
        if render_font == nil then
         stringFont = (1)
        if stringFont == 1 then render_font = fonts.regular
            end
        end

        render.string(x, y, message, 'c', render_font)
        ::continue::
        end
    end
end

hitgroupMap = {
    [0] = 'generic',
    [1] = 'head',
    [2] = 'chest',
    [3] = 'stomach',
    [4] = 'left arm',
    [5] = 'right arm',
    [6] = 'left leg',
    [7] = 'right leg',
    [8] = 'neck',
    [9] = 'gear'
}

function Visuals_hitlogs_hit(hit)
    name = hit.player:get_name()
    hitbox = hitgroupMap[hit.hitgroup]
    damage = hit.damage
    health = hit.player:get_prop('m_iHealth')
    caktrack = hit.backtrack_ticks

    if Visuals_HitLogs_MainPush:get(3) and Visuals_HitLogsHitMiss:get(1) then
        engine.execute_cmd("say 〈 HeviSSync 〉 Hit: "..name.." | In: "..hitbox.." | For: "..damage.."hp | Backtrack: "..caktrack.." | Remaining: "..health.."hp")
    end

    if Visuals_HitLogs_MainPush:get(2) and Visuals_HitLogsHitMiss:get(1) then
        client.log(color_t(255, 255, 255), "")
        client.log(color_t(0, 255, 0), "Hit: "..name.." | In: "..hitbox.." | For: "..damage.."hp | Backtrack: "..caktrack.." | Remaining: "..health.."hp")
        client.log(color_t(255, 255, 255), "")
    end

    if Visuals_HitLogs_MainPush:get(1) and Visuals_HitLogsHitMiss:get(1) then
    AddLog('PlayerHitEvent', {
        {'Hit ', false};
        {name .. ' ', true};
        {'in the ', false};
        {hitbox .. ' ', true};
        {'for ', false};
        {damage .. ' ', true};
        {'backtrack: ', false};
        {caktrack .. ' ', true};
        {'〈 damage remaining: ', false};
        {health, true};
        {' 〉 ', false};
    })
    end
end

function Visuals_HitLogs_Miss(miss)

    Jmenohrace = miss.player
    if Jmenohrace == nill then return end
    Jmeno = Jmenohrace:get_name()
    hitbox = hitgroupMap[miss.aim_hitgroup]
    damage = miss.aim_damage
    health = miss.player:get_prop('m_iHealth')
    reason = miss.reason_string
    caktrack = miss.backtrack_ticks

    if Visuals_HitLogs_MainPush:get(3) and Visuals_HitLogsHitMiss:get(2) then
        engine.execute_cmd("say 〈 HeviSSync 〉 Missed: "..Jmeno.." | In: "..hitbox.." | Due to: "..reason.." | Wanted damage: "..damage.."hp | Missed backtrack: "..caktrack)
    end

    
    if Visuals_HitLogs_MainPush:get(2) and Visuals_HitLogsHitMiss:get(2) then
        client.log(color_t(255, 255, 255), "")
        client.log(color_t(130, 20, 0), "Missed: "..Jmeno.." | In: "..hitbox.." | Due to: "..reason.." | Wanted damage: "..damage.."hp | Missed backtrack: "..caktrack)
        client.log(color_t(255, 255, 255), "")
    end

    if Visuals_HitLogs_MainPush:get(1) and Visuals_HitLogsHitMiss:get(2) then

    AddLog('PlayerHitEvent', {
        {'Missed ', false};
        {Jmeno .. ' ', true};
        {'in the ', false};
        {hitbox .. ' ', true};
        {'due to ', false};
        {reason .. ' ', true};
        {'backtrack: ', false};
        {caktrack .. ' ', true};
    })
    end
end

function AddLog(type, body)
    local log = {
        type = type,
        state = 'appearing',
        offset = 250,
        currentTime = 0,
        totalTime = 0,
        lifeTime = {
            fadeIn = 0.75,
            visible = 3,
            fadeOut = 0.75
        },
        header = {
            {'〈 ', false},
            {'HeviSSync', true},
            {' 〉 ', false},
        },
        body = body
    }
    table.insert(logs, log)
end

function Lerp(from, to, progress) 
    return from + (to - from) * progress
end

function Ease(progress)
    return progress < 0.5 and 15 * progress * progress * progress * progress * progress or 1 - math.pow(-2 * progress + 2, 5) / 2
end

render.string = function(x, y, data, alignment, font)
    -- Get total length for all the data.
    local length = 0
    for i = 1, #data do
        local text = data[i][1]
        
        local size = render.get_text_size(font, text)
        length = length + size.x
    end

    local offset = x
    for i = 1, #data do
        local text = data[i][1]
        local color = data[i][2]

        local sX = offset
        local sY = y

        -- Adjust position based on alignment
        if(alignment) == 'l' then
            sX = offset - length
        elseif(alignment) == 'c' then
            sX = offset - (length / 2)
        elseif(alignment) == 'r' then
            sX = offset
        end



        -- Draw the text.

        render.text(font, text, vec2_t(sX + 1, sY + 1), color_t(16, 16, 16, color.a))
        render.text(font, text, vec2_t(sX, sY), color)

        -- Add the length of the text to the offset.
        local size = render.get_text_size(font, text)
        offset = offset + size.x
    end
    
end


-------------------------------------------------HitMarker
--MenuAdd
HitMarkerMainSelect = menu.add_selection("Visuals", "Hit Markers", {"None", "Sniper", "卐", "☓", "•"})
hitmarkerColor = HitMarkerMainSelect:add_color_picker("hitmarker color")
HitMarkerDamageMain = menu.add_checkbox("Visuals", "Damage")
damageColor = HitMarkerDamageMain:add_color_picker("damage color")
HowBigHitMarker = menu.add_slider( "Visuals", "Size", 0, 50 )
Visuals_Cara4 = menu.add_text("Visuals", "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")


function on_world_hitmarker(screen_pos, world_pos, alpha_factor, damage, is_lethal, is_headshot)

    HowBigs = HowBigHitMarker:get()
    howsmoll = math.abs(HowBigs/2)
    howsmoll2 = math.abs(howsmoll/2)
    howsmoll3 = math.abs(howsmoll2/2)
    FontForHotMarker = render.create_font("Smallest Pixel-7", 14, 25)
    FontForHotMarker2 = render.create_font("Verdana", 14+HowBigs, 25)


    if HitMarkerMainSelect:get() == (2) then
        render.rect_filled(vec2_t(screen_pos.x-12-HowBigs, screen_pos.y-1), vec2_t(25+HowBigs+HowBigs, 2), hitmarkerColor:get())   
        render.rect_filled(vec2_t(screen_pos.x-12-HowBigs, screen_pos.y-1), vec2_t(25+HowBigs+HowBigs, 2), hitmarkerColor:get())   
        render.rect_filled(vec2_t(screen_pos.x-12-HowBigs, screen_pos.y-1), vec2_t(25+HowBigs+HowBigs, 2), hitmarkerColor:get())   
        render.rect_filled(vec2_t(screen_pos.x, screen_pos.y-13-HowBigs), vec2_t(2, 25+HowBigs+HowBigs), hitmarkerColor:get()) 
        render.rect_filled(vec2_t(screen_pos.x, screen_pos.y-13-HowBigs), vec2_t(2, 25+HowBigs+HowBigs), hitmarkerColor:get()) 
        render.rect_filled(vec2_t(screen_pos.x, screen_pos.y-13-HowBigs), vec2_t(2, 25+HowBigs+HowBigs), hitmarkerColor:get()) 
        render.circle(screen_pos, 12+HowBigs, hitmarkerColor:get())
        render.circle(screen_pos, 12+HowBigs, hitmarkerColor:get())
        render.circle(screen_pos, 12+HowBigs, hitmarkerColor:get())
    elseif  HitMarkerMainSelect:get() == (3)  then       
        render.text(FontForHotMarker2, "卐", vec2_t(screen_pos.x-5-howsmoll, screen_pos.y-5-howsmoll), hitmarkerColor:get())
    elseif  HitMarkerMainSelect:get() == (4)  then       
        render.text(FontForHotMarker2, "☓", vec2_t(screen_pos.x-4-howsmoll2, screen_pos.y-5-howsmoll), hitmarkerColor:get())
    elseif  HitMarkerMainSelect:get() == (5)  then       
        render.text(FontForHotMarker2, "•", vec2_t(screen_pos.x-3-howsmoll3, screen_pos.y-5-howsmoll), hitmarkerColor:get())
    end 

    if HitMarkerDamageMain:get() then
        damageString = tostring(damage)
        DMGManagerMain = damage

        if HitMarkerMainSelect:get() == (2) then
            if math.abs(DMGManagerMain)>=99 then
                render.text(FontForHotMarker, damageString, vec2_t(screen_pos.x-9, screen_pos.y-26-HowBigs), damageColor:get())
            elseif math.abs(DMGManagerMain)<99 then  
                render.text(FontForHotMarker, damageString, vec2_t(screen_pos.x-6, screen_pos.y-26-HowBigs), damageColor:get())
            end
        elseif HitMarkerMainSelect:get() == (3) then
            if math.abs(DMGManagerMain)>=99 then
                render.text(FontForHotMarker, damageString, vec2_t(screen_pos.x-9-howsmoll3, screen_pos.y-22-howsmoll), damageColor:get())
            elseif math.abs(DMGManagerMain)<99 then  
                render.text(FontForHotMarker, damageString, vec2_t(screen_pos.x-6-howsmoll3, screen_pos.y-22-howsmoll), damageColor:get())
            end
        elseif HitMarkerMainSelect:get() == (4) then
            if math.abs(DMGManagerMain)>=99 then
                render.text(FontForHotMarker, damageString, vec2_t(screen_pos.x-9, screen_pos.y-22-howsmoll2), damageColor:get())
            elseif math.abs(DMGManagerMain)<99 then  
                render.text(FontForHotMarker, damageString, vec2_t(screen_pos.x-6, screen_pos.y-22-howsmoll2), damageColor:get())
            end
        elseif HitMarkerMainSelect:get() == (5) then
            if math.abs(DMGManagerMain)>=99 then
                render.text(FontForHotMarker, damageString, vec2_t(screen_pos.x-9, screen_pos.y-17-howsmoll3), damageColor:get())
            elseif math.abs(DMGManagerMain)<99 then  
                render.text(FontForHotMarker, damageString, vec2_t(screen_pos.x-6, screen_pos.y-17-howsmoll3), damageColor:get())
            end
        end
    end
end

function Visuals_ShowFirHitMarker()
    HitMarkerMainVisiblePush = HitMarkerDamageMain:get()
    HitMarkerMainVisible = HitMarkerMainSelect:get()

    HitMarkerMain = HeviSSyncMain:get(3)
    HitMarkerMainSelect:set_visible(HitMarkerMain)
    HitMarkerDamageMain:set_visible(HitMarkerMain)
    Visuals_Cara4:set_visible(HitMarkerMain)

    WhatSizeHOitMarker = HeviSSyncMain:get(3) and HitMarkerMainVisiblePush or HeviSSyncMain:get(3) and HitMarkerMainVisible == (2) or HeviSSyncMain:get(3) and HitMarkerMainVisible == (3) or HeviSSyncMain:get(3) and HitMarkerMainVisible == (4) or HeviSSyncMain:get(3) and HitMarkerMainVisible == (5)
    HowBigHitMarker:set_visible(WhatSizeHOitMarker)
end

-------------------------------------------------Remove Watermark
--menuadd
DIsablePrimoAWtermark = menu.add_checkbox("Visuals", "Remove Primordial Watermark")
Visuals_Cara5 = menu.add_text("Visuals", "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")

WelcomeHEviSSyncIndsd = render.create_font("Verdana", 15, 615, e_font_flags.OUTLINE)

function watermarkDraw()
    accent_color_tesfdxt, accent_color_cosslor = unpack(menu.find("misc", "main", "config", "accent color"))
    details = accent_color_cosslor:get()

    PrimoridalDisablerWaterMarkk = DIsablePrimoAWtermark:get()
    if menu.is_open() then
        render.text(WelcomeHEviSSyncIndsd, "", vec2_t(870, 1100), details)        
    elseif PrimoridalDisablerWaterMarkk == (true) then
        return ""
    elseif PrimoridalDisablerWaterMarkk == (false) then
        return "primordial - " .. user.name.." - " .. user.uid
    end
end

function ShowForDisablerPrimo()
    Visual_Waternarkremover = HeviSSyncMain:get(3)
    DIsablePrimoAWtermark:set_visible(Visual_Waternarkremover)
    Visuals_Cara5:set_visible(Visual_Waternarkremover)
end


-------------------------------------------------------------------------------------------------Troll-------------------------------------------------------------------------------------------------
-------------------------------------------------Knife Flip
--Menu Add
Troll_Cara1 = menu.add_text("Troll", "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
Troll_FlipKnife = menu.add_checkbox("Troll", "Another knife")
Troll_Cara2 = menu.add_text("Troll", "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")


--MenuFind
KnifeFlipp = menu.find("visuals","other","general","switch knife side")

function Troll_flippingKnife_Main()

    FlipKnifeVisible = HeviSSyncMain:get(4)
    Troll_Cara1:set_visible(FlipKnifeVisible)
    Troll_FlipKnife:set_visible(FlipKnifeVisible)
    Troll_Cara2:set_visible(FlipKnifeVisible)

    if not engine.is_in_game() then return end
    if entity_list.get_local_player() == nil then return end
    if entity_list.get_local_player():is_alive() == (false) then 
        KnifeFlipp:set(false)
    return end

    if Troll_FlipKnife:get(true) then
        if TestAATimer:get() then
            KnifeFlipp:set(true)
        else
            KnifeFlipp:set(false)
        end
    end
end

-------------------------------------------------BodyMass Changer

Troll_AssOrBodyMassChanger = menu.add_selection("Troll", "Ass or KG cahnger?", {"OFF", "Ass", "KG"})
Troll_BodyMassChanger_WhatyouWant = menu.add_selection("Troll", "Ass/Kg Changer", {"Manual", "Random", "Reset to normal"})
Troll_BodyMassChanger = menu.add_slider( "Troll", "Ass/Kg Manual Changer", 0, 1000)
Troll_BodyMassChanger:set(100)
Troll_Cara3 = menu.add_text("Troll", "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")


function Troll_BodyMAssChanger()
    -- Return if the local player isn't alive
    local local_player = entity_list.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end

    if Troll_AssOrBodyMassChanger:get() == 1 then
        Troll_BodyMassChanger:set(100)
        local_player:set_prop("m_ScaleType", 0)
        local_player:set_prop("m_flModelScale", Troll_BodyMassChanger:get() / 100)  
    elseif Troll_AssOrBodyMassChanger:get() == 2 then
        local_player:set_prop("m_ScaleType", 0)
        local_player:set_prop("m_flModelScale", Troll_BodyMassChanger:get() / 100)
    elseif Troll_AssOrBodyMassChanger:get() == 3 then
        local_player:set_prop("m_ScaleType", 1)
        local_player:set_prop("m_flModelScale", Troll_BodyMassChanger:get() / 100)
    end

    if Troll_BodyMassChanger_WhatyouWant:get() == 2 then
        Troll_BodyMassChanger:set(math.random(0, 350))
    elseif Troll_BodyMassChanger_WhatyouWant:get() == 3 then
        Troll_BodyMassChanger:set(100)
        Troll_BodyMassChanger_WhatyouWant:set(1)
    end

end

function Troll_BodyMassChangerVision()

    Troll_BodyMassChangerVisibke = HeviSSyncMain:get(4)
    Troll_AssOrBodyMassChanger:set_visible(Troll_BodyMassChangerVisibke)
    Troll_Cara3:set_visible(Troll_BodyMassChangerVisibke)

    Troll_AssBodyMass_Changer = Troll_AssOrBodyMassChanger:get() == 2 and HeviSSyncMain:get(4) or Troll_AssOrBodyMassChanger:get() == 3 and HeviSSyncMain:get(4)
    Troll_BodyMassChanger_WhatyouWant:set_visible(Troll_AssBodyMass_Changer)
    Troll_BodyMassChanger:set_visible(Troll_AssBodyMass_Changer)

    Troll_BodyMassChanger_Slider = Troll_BodyMassChanger_WhatyouWant:get() == 1 and HeviSSyncMain:get(4) and Troll_AssOrBodyMassChanger:get() == 2 or Troll_BodyMassChanger_WhatyouWant:get() == 1 and HeviSSyncMain:get(4) and Troll_AssOrBodyMassChanger:get() == 3
    Troll_BodyMassChanger:set_visible(Troll_BodyMassChanger_Slider)


end




-------------------------------------------------------------------------------------------------Auto Config-------------------------------------------------------------------------------------------------
--MneuAdd


function AutoConfigMainButton()
    AntiAimMain:set(5)
    AntiAim_BFLChecker:set(3)
    AimBot_ExtendBTSelect:set(3)
    Visuals_indicators_Main:set(3)
    Visual_FontYouWant:set(1)
    HitMarkerMainSelect:set(5)
    HitMarkerDamageMain:set(true)
    DIsablePrimoAWtermark:set(false)
    AntiAim_BLFChecker:set(true)
    Visuals_HitLogs_MainPush:set(1, true)
    Visuals_HitLogs_MainPush:set(2, true)
    Visuals_HitLogsHitMiss:set(1, true)
    Visuals_HitLogsHitMiss:set(2, true)
    Visuals_colors:set(color_t(255, 0, 0))
    Visuals_colors2:set(color_t(255, 255, 255))
    Visuals_colorsHotlogs:set(color_t(0, 0, 0))
    Visuals_colorsHotlogss:set(color_t(255, 0, 0))
    Visuals_HitLogsHitMiss:set(1, true)
    Visuals_HitLogsHitMiss:set(2, true)
    ZeroPitchonlandandlegs:set(true)

end

AUtoConfigs = menu.add_button("Config System", "Load default config", AutoConfigMainButton)


-------------------------------------------------------------------------------------------------Config System-------------------------------------------------------------------------------------------------
--menu add 
cfg_import = menu.add_button("Config System", "Paste Config From Clipboard", function() configs.import() end)
cfg_export = menu.add_button("Config System", "Copy Config To Clipboard", function() configs.export() end)


VGUI_System010 =  memory.create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
VGUI_System = ffi.cast(ffi.typeof('void***'), VGUI_System010 )
get_clipboard_text_count = ffi.cast("get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
set_clipboard_text = ffi.cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
get_clipboard_text = ffi.cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")

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

configs.import = function(input) --- add here ur features
    local protected = function()
        local clipboard = input == nil and clipboard_import() or input
        local tbl = str_to_sub(clipboard, "|")
        AntiAimMain:set(tonumber(tbl[1]))
        AntiAim_HowBigJitter:set(tonumber(tbl[2]))
        ZeroPitchonlandandlegs:set(to_boolean(tbl[3]))
        MainStayYaw:set(tonumber(tbl[4]))
        AATypeStay:set(tonumber(tbl[5]))
        AntiAim_YawStay:set(tonumber(tbl[6]))
        AntiAim_LeftStay:set(tonumber(tbl[7]))
        AntiAim_Yaw2Stay:set(tonumber(tbl[8]))
        AntiAim_RightStay:set(tonumber(tbl[9]))
        MainMovingYaw:set(tonumber(tbl[10]))
        AATypeMOVE:set(tonumber(tbl[11]))
        AntiAim_YawMOVE:set(tonumber(tbl[12]))
        AntiAim_LeftMOVE:set(tonumber(tbl[13]))
        AntiAim_Yaw2MOVE:set(tonumber(tbl[14]))
        AntiAim_RightMOVE:set(tonumber(tbl[15]))
        MainSloWWalkingYaw:set(tonumber(tbl[16]))
        AATypeSlowWalk:set(tonumber(tbl[17]))
        AntiAim_YawSlowWalk:set(tonumber(tbl[18]))
        AntiAim_LeftSlowWalk:set(tonumber(tbl[19]))
        AntiAim_YawSlowWalk2:set(tonumber(tbl[20]))
        AntiAim_RightSlowWalk:set(tonumber(tbl[21]))
        MainJumpingYaw:set(tonumber(tbl[22]))
        AATypeJumpo:set(tonumber(tbl[23]))
        AntiAim_YawJumpo:set(tonumber(tbl[24]))
        AntiAim_LeftJumpo:set(tonumber(tbl[25]))
        AntiAim_Yaw2Jumpo:set(tonumber(tbl[26]))
        AntiAim_RightJumpo:set(tonumber(tbl[27]))
        MainAirDuckYaw:set(tonumber(tbl[28]))
        AATypeAirDuck:set(tonumber(tbl[29]))
        AntiAim_YawAirDuck:set(tonumber(tbl[30]))
        AntiAim_LeftAirDuck:set(tonumber(tbl[31]))
        AntiAim_Yaw2AirDuck:set(tonumber(tbl[32]))
        AntiAim_RightAirDuck:set(tonumber(tbl[33]))
        MainCrouchYaw:set(tonumber(tbl[34]))
        AATypeSkrcMoving:set(tonumber(tbl[35]))
        AntiAim_YawSkrcMoving:set(tonumber(tbl[36]))
        AntiAim_LeftStaySkrcMoving:set(tonumber(tbl[37]))
        AntiAim_Yaw2SkrcMoving:set(tonumber(tbl[38]))
        AntiAim_RightStaySkrcMoving:set(tonumber(tbl[39]))
        AntiAim_YawBasew:set(tonumber(tbl[40]))
        AntiAim_YawBased:set(tonumber(tbl[41]))
        AntiAim_AntiBruteForce:set(to_boolean(tbl[42]))
        AntiAim_OnShot:set(tonumber(tbl[43]))
        AntiAim_Spin:set(to_boolean(tbl[44]))
        AntiAim_SpinRange:set(tonumber(tbl[45]))
        AntiAim_SpinSpeed:set(tonumber(tbl[46]))
        AntiAim_Jitter:set(tonumber(tbl[47]))
        AntiAim_JitterRange:set(tonumber(tbl[48]))
        --Leg Fucker
        AntiAim_BLFChecker:set(to_boolean(tbl[49]))
        --Better FakeLag
        AntiAim_BFLChecker:set(tonumber(tbl[50]))
        AntiAim_BFLCustomeValue:set(tonumber(tbl[51]))
        AntiAim_BFLSliderOne:set(tonumber(tbl[52]))
        AntiAim_BFLSliderTwo:set(tonumber(tbl[53]))
        --Main Selection
        HeviSSyncMain:set(1, to_boolean(tbl[54]))
        HeviSSyncMain:set(2, to_boolean(tbl[55]))
        HeviSSyncMain:set(3, to_boolean(tbl[56]))
        HeviSSyncMain:set(4, to_boolean(tbl[57]))
        --Extended Backtrack
        AimBot_ExtendBTSelect:set(tonumber(tbl[58]))
        AimBot_ExtendBTSlider:set(tonumber(tbl[59]))
        --Indicaotrs
        Visuals_indicators_Main:set(tonumber(tbl[60]))
        Visuals_colors:set(color_t (tonumber(tbl[61]), tonumber(tbl[62]), tonumber(tbl[63])))
        Visual_FontYouWant:set(tonumber(tbl[64]))
        Visual_Font_big:set(tonumber(tbl[65]))
        Visual_UpDown:set(tonumber(tbl[66]))
        Visual:set(tonumber(tbl[67]))
        --Hit markers
        HitMarkerMainSelect:set(tonumber(tbl[68]))
        hitmarkerColor:set(color_t (tonumber(tbl[69]), tonumber(tbl[70]), tonumber(tbl[71])))
        HitMarkerDamageMain:set(to_boolean(tbl[72]))
        damageColor:set(color_t (tonumber(tbl[73]), tonumber(tbl[74]), tonumber(tbl[75])))
        HowBigHitMarker:set(tonumber(tbl[76]))
        --HitLogs
        Visuals_HitLogs_MainPush:set(1, to_boolean(tbl[77]))
        Visuals_HitLogs_MainPush:set(2, to_boolean(tbl[78]))
        Visuals_HitLogs_MainPush:set(3, to_boolean(tbl[79]))
        Visuals_colorsHotlogs:set(color_t (tonumber(tbl[80]), tonumber(tbl[81]), tonumber(tbl[82])))
        Visuals_colorsHotlogss:set(color_t (tonumber(tbl[83]), tonumber(tbl[84]), tonumber(tbl[85])))
        Visuals_HitLogsHitMiss:set(1, to_boolean(tbl[86]))
        Visuals_HitLogsHitMiss:set(2, to_boolean(tbl[87]))
        --Remove primo watermark
        DIsablePrimoAWtermark:set(to_boolean(tbl[88]))
        --Another knife
        Troll_FlipKnife:set(to_boolean(tbl[89]))
        --Indicators colors
        Visuals_colors2:set(color_t (tonumber(tbl[90]), tonumber(tbl[91]), tonumber(tbl[92])))
        --Ass/KG changer
        Troll_AssOrBodyMassChanger:set(tonumber(tbl[93]))
        Troll_BodyMassChanger_WhatyouWant:set(tonumber(tbl[94]))
        Troll_BodyMassChanger:set(tonumber(tbl[95]))

        client.log_screen("Config loaded")
    end
    local status, message = pcall(protected)
    if not status then
        client.log_screen("Failed to load config")
        return
    end
end


configs.export = function() --- add here ur features
	local str = {}
    --AA
	local str = tostring(AntiAimMain:get()) .. "|"
    .. tostring(AntiAim_HowBigJitter:get()) .. "|"
    .. tostring(ZeroPitchonlandandlegs:get()) .. "|"
    .. tostring(MainStayYaw:get()) .. "|"
    .. tostring(AATypeStay:get()) .. "|"
    .. tostring(AntiAim_YawStay:get()) .. "|"
    .. tostring(AntiAim_LeftStay:get()) .. "|"
    .. tostring(AntiAim_Yaw2Stay:get()) .. "|"
    .. tostring(AntiAim_RightStay:get()) .. "|"
    .. tostring(MainMovingYaw:get()) .. "|"
    .. tostring(AATypeMOVE:get()) .. "|"
    .. tostring(AntiAim_YawMOVE:get()) .. "|"
    .. tostring(AntiAim_LeftMOVE:get()) .. "|"
    .. tostring(AntiAim_Yaw2MOVE:get()) .. "|"
    .. tostring(AntiAim_RightMOVE:get()) .. "|"
    .. tostring(MainSloWWalkingYaw:get()) .. "|"
    .. tostring(AATypeSlowWalk:get()) .. "|"
    .. tostring(AntiAim_YawSlowWalk:get()) .. "|"
    .. tostring(AntiAim_LeftSlowWalk:get()) .. "|"
    .. tostring(AntiAim_YawSlowWalk2:get()) .. "|"
    .. tostring(AntiAim_RightSlowWalk:get()) .. "|"
    .. tostring(MainJumpingYaw:get()) .. "|"
    .. tostring(AATypeJumpo:get()) .. "|"
    .. tostring(AntiAim_YawJumpo:get()) .. "|"
    .. tostring(AntiAim_LeftJumpo:get()) .. "|"
    .. tostring(AntiAim_Yaw2Jumpo:get()) .. "|"
    .. tostring(AntiAim_RightJumpo:get()) .. "|"
    .. tostring(MainAirDuckYaw:get()) .. "|"
    .. tostring(AATypeAirDuck:get()) .. "|"
    .. tostring(AntiAim_YawAirDuck:get()) .. "|"
    .. tostring(AntiAim_LeftAirDuck:get()) .. "|"
    .. tostring(AntiAim_Yaw2AirDuck:get()) .. "|"
    .. tostring(AntiAim_RightAirDuck:get()) .. "|"
    .. tostring(MainCrouchYaw:get()) .. "|"
    .. tostring(AATypeSkrcMoving:get()) .. "|"
    .. tostring(AntiAim_YawSkrcMoving:get()) .. "|"
    .. tostring(AntiAim_LeftStaySkrcMoving:get()) .. "|"
    .. tostring(AntiAim_Yaw2SkrcMoving:get()) .. "|"
    .. tostring(AntiAim_RightStaySkrcMoving:get()) .. "|"
    .. tostring(AntiAim_YawBasew:get()) .. "|"
    .. tostring(AntiAim_YawBased:get()) .. "|"
    .. tostring(AntiAim_AntiBruteForce:get()) .. "|"
    .. tostring(AntiAim_OnShot:get()) .. "|"
    .. tostring(AntiAim_Spin:get()) .. "|"
    .. tostring(AntiAim_SpinRange:get()) .. "|"
    .. tostring(AntiAim_SpinSpeed:get()) .. "|"
    .. tostring(AntiAim_Jitter:get()) .. "|"
    .. tostring(AntiAim_JitterRange:get()) .. "|"
    --Leg Fucker
    .. tostring(AntiAim_BLFChecker:get()) .. "|"
    --Better FakeLag
    .. tostring(AntiAim_BFLChecker:get()) .. "|"
    .. tostring(AntiAim_BFLCustomeValue:get()) .. "|"
    .. tostring(AntiAim_BFLSliderOne:get()) .. "|"
    .. tostring(AntiAim_BFLSliderTwo:get()) .. "|"
    --MainTab
    .. tostring(HeviSSyncMain:get(1)) .. "|"
    .. tostring(HeviSSyncMain:get(2)) .. "|"
    .. tostring(HeviSSyncMain:get(3)) .. "|"
    .. tostring(HeviSSyncMain:get(4)) .. "|"
    --Extended Backtrack
    .. tostring(AimBot_ExtendBTSelect:get()) .. "|"
    .. tostring(AimBot_ExtendBTSlider:get()) .. "|"
    --Indicators
    .. tostring(Visuals_indicators_Main:get()) .. "|"
    .. tostring(Visuals_colors:get().r) .. "|"
    .. tostring(Visuals_colors:get().g) .. "|"
    .. tostring(Visuals_colors:get().b) .. "|"
    .. tostring(Visual_FontYouWant:get()) .. "|"
    .. tostring(Visual_Font_big:get()) .. "|"
    .. tostring(Visual_UpDown:get()) .. "|"
    .. tostring(Visual:get()) .. "|"
    --Hit marker
    .. tostring(HitMarkerMainSelect:get()) .. "|"
    .. tostring(hitmarkerColor:get().r) .. "|"
    .. tostring(hitmarkerColor:get().g) .. "|"
    .. tostring(hitmarkerColor:get().b) .. "|"
    .. tostring(HitMarkerDamageMain:get()) .. "|"
    .. tostring(damageColor:get().r) .. "|"
    .. tostring(damageColor:get().g) .. "|"
    .. tostring(damageColor:get().b) .. "|"
    .. tostring(HowBigHitMarker:get()) .. "|"
    --HitLogs
    .. tostring(Visuals_HitLogs_MainPush:get(1)) .. "|"
    .. tostring(Visuals_HitLogs_MainPush:get(2)) .. "|"
    .. tostring(Visuals_HitLogs_MainPush:get(3)) .. "|"
    .. tostring(Visuals_colorsHotlogs:get().r) .. "|"
    .. tostring(Visuals_colorsHotlogs:get().g) .. "|"
    .. tostring(Visuals_colorsHotlogs:get().b) .. "|"
    .. tostring(Visuals_colorsHotlogss:get().r) .. "|"
    .. tostring(Visuals_colorsHotlogss:get().g) .. "|"
    .. tostring(Visuals_colorsHotlogss:get().b) .. "|"
    .. tostring(Visuals_HitLogsHitMiss:get(1)) .. "|"
    .. tostring(Visuals_HitLogsHitMiss:get(2)) .. "|"
    --Remove Primordial watermark
    .. tostring(DIsablePrimoAWtermark:get()) .. "|"
    --Another knife
    .. tostring(Troll_FlipKnife:get()) .. "|"
    --IndicatorsCOlors
    .. tostring(Visuals_colors2:get().r) .. "|"
    .. tostring(Visuals_colors2:get().g) .. "|"
    .. tostring(Visuals_colors2:get().b) .. "|"
    --Ass/Body Changer
    .. tostring(Troll_AssOrBodyMassChanger:get()) .. "|"
    .. tostring(Troll_BodyMassChanger_WhatyouWant:get()) .. "|"
    .. tostring(Troll_BodyMassChanger:get()) .. "|"

    clipboard_export(str)
	client.log_screen("config was copied")
end


-------------------------------------------------------------------------------------------------Bots/Self Commands-------------------------------------------------------------------------------------------------
--Sv_cheats 1
function Training_setup()
    engine.execute_cmd("sv_cheats 1")
    engine.execute_cmd("mp_limitteams 0")
    engine.execute_cmd("mp_autoteambalance 0")
    engine.execute_cmd("mp_freezetime 0")
    engine.execute_cmd("mp_roundtime 60")
    engine.execute_cmd("mp_roundtime_defuse 60")
    engine.execute_cmd("mp_roundtime_hostage 60")
    engine.execute_cmd("mp_maxmoney 99999")
    engine.execute_cmd("mp_startmoney 99999")
    engine.execute_cmd("mp_buytime 9999")
    engine.execute_cmd("mp_buy_anywhere 1")
    engine.execute_cmd("ammo_grenade_limit_total 5")
    engine.execute_cmd("sv_infinite_ammo 1")
    engine.execute_cmd("bot_kick")
    engine.execute_cmd("sv_grenade_trajectory 1")
    engine.execute_cmd("sv_grenade_trajectory_time 10")
    engine.execute_cmd("sv_showimpacts 1")
    engine.execute_cmd("sv_showimpacts_time 10")
    engine.execute_cmd("mp_warmup_end") 
    engine.execute_cmd("mp_restartgame 1")
    client.log_screen("sv_cheats 1")
    client.log_screen("mp_limitteams 0")
    client.log_screen("mp_autoteambalance 0")
    client.log_screen("mp_freezetime 0")
    client.log_screen("mp_roundtime 60")
    client.log_screen("mp_roundtime_defuse 60")
    client.log_screen("mp_roundtime_hostage 60")
    client.log_screen("mp_maxmoney 99999")
    client.log_screen("mp_startmoney 99999")
    client.log_screen("mp_buytime 9999")
    client.log_screen("mp_buy_anywhere 1")
    client.log_screen("ammo_grenade_limit_total 5")
    client.log_screen("sv_infinite_ammo 1")
    client.log_screen("bot_kick")
    client.log_screen("sv_grenade_trajectory 1")
    client.log_screen("sv_grenade_trajectory_time 10")
    client.log_screen("sv_showimpacts 1")
    client.log_screen("mp_warmup_end")
    client.log_screen("mp_restartgame 1")
end
BC_Training_Setup = menu.add_button("Bots/Self Commands", "Basic Training Setup", Training_setup)

BC_Info = menu.add_text("Bots/Self Commands", "Bot Commands")
--Bot_add_CT
function Bot_Add_ct()
    engine.execute_cmd("bot_add ct")
    client.log_screen("bot_add ct")
end
BC_Bot_Add_ct = menu.add_button("Bots/Self Commands", "Add bot to CT", Bot_Add_ct)
--Bot_Add_T
function Bot_Add_t()
    engine.execute_cmd("bot_add t")
    client.log_screen("bot_add t")
end
BC_Bot_Add_t = menu.add_button("Bots/Self Commands", "Add bot to T", Bot_Add_t)
--Freezee bots
function freeze_Bots()
    engine.execute_cmd("bot_stop 1")
    client.log_screen("bot_stop 1")
end
Freeze_Bots = menu.add_button("Bots/Self Commands", "Freeze bots", freeze_Bots)
--bot_mimic
function Bot_mimicYou()
    engine.execute_cmd("bot_mimic 1")
    client.log_screen("bot_mimic 1")
end
BC_BotMimiCYOu = menu.add_button("Bots/Self Commands", "Bots do, what you do", Bot_mimicYou)
--Spawn bot
function SpawnBotInYou()
    engine.execute_cmd("bot_place")
    client.log_screen("bot placed")
end
BC_SpawnBOt = menu.add_button("Bots/Self Commands", "Spawn bot next to you", SpawnBotInYou)
--Noclip
function NoClip_Setup()
    engine.execute_cmd("noclip")
end
BC_Info2 = menu.add_text("Bots/Self Commands", "Player Commands")
BC_Noclip = menu.add_button("Bots/Self Commands", "noclip", NoClip_Setup)
--GOD
function InfiniteHP()
    engine.execute_cmd("god")
    client.log_screen("God Mode Activated")
end
InfiniteHP = menu.add_button("Bots/Self Commands", "Infinite Hp", InfiniteHP)
BC_Info3 = menu.add_text("Bots/Self Commands", "Restart")

--Reset button
function Resetbuttorndefault()
    engine.execute_cmd("bot_stop 0")
    engine.execute_cmd("bot_mimic 0")

end
BC_ResetToDefault = menu.add_button("Bots/Self Commands", "Reset to default", Resetbuttorndefault)

BC_Info4 = menu.add_text("Bots/Self Commands", "Just Reminder, This commands work only in")
BC_Info5 = menu.add_text("Bots/Self Commands", "singleplayer. If you wanna Off some commands, ")
BC_Info6 = menu.add_text("Bots/Self Commands", "all used commands will show up in console")

function Bot_commands_Visible()
    ShowBotCommands = HeviSSyncMain:get(5)
    BC_ResetToDefault:set_visible(ShowBotCommands)
    BC_Noclip:set_visible(ShowBotCommands)
    BC_SpawnBOt:set_visible(ShowBotCommands)
    BC_BotMimiCYOu:set_visible(ShowBotCommands)
    Freeze_Bots:set_visible(ShowBotCommands)
    BC_Bot_Add_t:set_visible(ShowBotCommands)
    BC_Bot_Add_ct:set_visible(ShowBotCommands)
    BC_Training_Setup:set_visible(ShowBotCommands)
    InfiniteHP:set_visible(ShowBotCommands)
    BC_Info:set_visible(ShowBotCommands)
    BC_Info2:set_visible(ShowBotCommands)
    BC_Info3:set_visible(ShowBotCommands)
    BC_Info4:set_visible(ShowBotCommands)
    BC_Info5:set_visible(ShowBotCommands)
    BC_Info6:set_visible(ShowBotCommands)
end


callbacks.add(e_callbacks.RUN_COMMAND, function(cmd)
    --Velocity
    state.Velocity_State()
end)

callbacks.add(e_callbacks.PAINT, function()
    --Welcome to Hevissync
    WelcometoHeviSSync()
    --AntiAim
    AntiAim_AAPresets()  
    --LegFucker 
    AntiAim_LegFucker()
    --Better FakeLag
    AntiAim_BetterFakeLag()
    --Extend BackTrack
    AimBot_ExtendBt()
    --Indicators
    Visuals_Indicators()
    --HitLogs
    Visible_for_HitLogs()
    Visuals_HitLogs_Main()
    --HitMarker
    Visuals_ShowFirHitMarker()
    --KnifeFlip
    Troll_flippingKnife_Main()
    --PrimoDisabler
    ShowForDisablerPrimo()
    --Ass/KG changer
    Troll_BodyMassChangerVision()
    --BotsCommands Visible
    Bot_commands_Visible()
end)

callbacks.add(e_callbacks.AIMBOT_MISS, Visuals_HitLogs_Miss)

callbacks.add(e_callbacks.AIMBOT_HIT, Visuals_hitlogs_hit)

callbacks.add(e_callbacks.WORLD_HITMARKER, on_world_hitmarker)

callbacks.add(e_callbacks.DRAW_WATERMARK, watermarkDraw)

callbacks.add(e_callbacks.ANTIAIM, AntiAim_AnimationsClientSide) 

callbacks.add(e_callbacks.SETUP_COMMAND, Troll_BodyMAssChanger)