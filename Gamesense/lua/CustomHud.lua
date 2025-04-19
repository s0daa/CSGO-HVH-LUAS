local font = render.create_font("VERDANAB.ttf", 17)
local font2 = render.create_font("VERDANAB.ttf", 32)
local easing = require("easing")
local wepfont = render.create_font("undefeated.ttf", 40)
local wepfont2 = render.create_font("undefeated.ttf", 22)
local Plakillamt = 0
local shot2 = 0;
local Shots = {} 
local enable;
local Checkbox      = gui.add_checkbox("Damage Markers", "lua>Tab A")
local ColorPicker   = gui.add_colorpicker("lua>Tab A>Damage Markers", true, render.color(255, 0, 50))
local t =  0;
local HPLEN = 0;
local APLEN = 0;
local CTcnt = 0;
local CTcntTotal = 0;
local LINCT = 0;
local LINT = 0;
local Tcnt = 0;
local TcntTotal = 0;
local i = 0
local curhealth = 0
local maxval = 0
local secval = 0
local nadval = 0
local nadval2 = 0
local nadval3 = 0
local dist = 55
local nS = "";
local pos1x = 657;
local pos1y = 712;
local pos2x = 657;
local pos2y = 712;
local pos3x = 657;
local pos3y = 712;
local Flashininv = false;
local Flashininv2 = false;
local Flashininv3 = false;
local S = "UNK";
local extra = 0;
local primheld = false;
local Secheld = false;
local sS = "UNK";
local justshot = false;
local tim = 0;
local cycleshit = 0;
local tim2 = 0;
local Playerdeath = {};
local hirearchy = 0;
local nadesnn = {}

function linear(t, b, c, d)
    return c * t / d + b
end

local var = cvar.sv_cheats
var:set_int(1)

local var2 = cvar.cl_drawhud
var2:set_int(0)

function weptofont(wepnam, sec, prome, nade)
    local ans = "UNK"
    local Nam = "UNK"
    if wepnam == "g3sg1" or wepnam == "CWeaponG3SG1" and prome then
        ans = "X"
        Nam = "G3SG1"
	elseif wepnam == "taser" and sec and prome or wepnam == "CWeaponTaser" then
        ans = "h"
        Nam = "TASER"	
    elseif wepnam == "scar20" or wepnam == "CWeaponSCAR20" and prome then
        ans = "Y"
        Nam = "SCAR20"
    elseif wepnam == "awp" or wepnam == "CWeaponAWP" and prome  then
        ans = "Z"
        Nam = "AWP"
    elseif wepnam == "ssg08" or wepnam == "CWeaponSSG08" and prome then
        ans = "a"
        Nam = "SSG08"
    elseif wepnam == "hegrenade" or wepnam == "CHEGrenade" and nade  then
        ans = "j"
        Nam = "Grenade"
    elseif wepnam == "inferno" or wepnam == "CIncendiaryGrenade" or wepnam == "CMolotovGrenade" and nade  then
        ans = "l"
        Nam = "inferno"
    elseif wepnam == "CFlashbang" and nade  then
        ans = "m"
        Nam = "Flash"
    elseif wepnam == "CSmokeGrenade" and nade  then
        ans = "k"
        Nam = "Smoke"
    elseif wepnam == "deagle" or wepnam == "CDEagle" and sec then
        ans = "A"
        Nam = "deagle"
    elseif wepnam == "elite" or wepnam == "CWeaponElite" and sec then
        ans = "B"
        Nam = "elite"
    elseif wepnam == "usp_silencer" or wepnam == "CWeaponHKP2000" and sec then
        ans = "G"
        Nam = "usp-s"
    elseif wepnam == "tec9" or wepnam == "CWeaponTec9" and sec then
        ans = "H"
        Nam = "tec9"
    elseif wepnam == "cz75a" or wepnam == "CWeaponP250" and sec then
        ans = "I"
        Nam = "cz75a"
    elseif wepnam == "knife" and sec and prome then
        ans = "1"
        Nam = "knife"
    end



    return ans,Nam
end


function Inventory()
    primheld = false;
    Secheld = false;
    local LP = entities.get_entity(engine.get_local_player())
    local curwep = LP:get_weapon()
    local Prim  = entities.get_entity_from_handle(LP:get_prop("m_hMyWeapons", maxval))
    local sec = entities.get_entity_from_handle(LP:get_prop("m_hMyWeapons", secval))
        
        if(Prim == nil) then
            maxval = 0;
        end


        if(Prim ~=nil) then
            S = "UNK";
            local V;
            if(weptofont(Prim:get_class(), false, true, false) ~= "UNK") then
                S,V = weptofont(Prim:get_class(), false, true, false)
            else
                maxval = maxval + 1   
            end
            local CP = Prim:get_class()
            if(S ~= "UNK") then
                render.rect_filled_multicolor(1720, 712, 1920, 722+45,
                render.color(68, 68, 68 , 10), render.color(68, 68, 68 , 190),
                render.color(68, 68, 68 , 190), render.color(68, 68, 68 , 10))
                render.text(wepfont, 1720+110, 712+30, S, render.color(246, 182, 255), render.align_center, render.align_center)
                if(curwep ~= nil and CP == curwep:get_class()) then
                    primheld = true;
                    render.text(font, 1720-30, 712+30, V, render.color(246, 182, 255), render.align_center, render.align_center)
                    render.rect_filled_multicolor(1720, 712, 1920, 722+45,
                    render.color(248, 244, 249 , 10), render.color(248, 244, 249 , 190),
                    render.color(248, 244, 249 , 190), render.color(248, 244, 249 , 10))
                end

            end

        end






        if(sec == nil) then
            secval = 0;
        end
        

        
        if(sec ~=nil) then

            sS = "UNK";
            local sV = "UNK"
            if(weptofont(sec:get_class(), true, false, false) ~= "UNK") then
                sS,sV = weptofont(sec:get_class(), true, false, false)
            else
                secval = secval + 1   
            end
            local CP = sec:get_class()


            if(sS ~= "UNK") then
                render.rect_filled_multicolor(1720, 767, 1920, 822,
                render.color(68, 68, 68 , 10), render.color(68, 68, 68 , 190),
                render.color(68, 68, 68 , 190), render.color(68, 68, 68 , 10))
                render.text(wepfont, 1720+110, 767+30, sS, render.color(246, 182, 255), render.align_center, render.align_center)

                if(curwep ~= nil and CP == curwep:get_class()) then
                    Secheld = true
                    render.text(font, 1720-30, 767+30, sV, render.color(246, 182, 255), render.align_center, render.align_center)
                    render.rect_filled_multicolor(1720, 767, 1920, 822,
                    render.color(248, 244, 249 , 10), render.color(248, 244, 249 , 190),
                    render.color(248, 244, 249 , 190), render.color(248, 244, 249 , 10))
                end

            end

        end
        local rem = 0;

        if(sS == "UNK") then
            rem = 55;
        else
            rem = 0;
        end
        render.rect_filled_multicolor(1720, 822-rem, 1920, 877 - rem,
        render.color(68, 68, 68 , 10), render.color(68, 68, 68 , 190),
        render.color(68, 68, 68 , 190), render.color(68, 68, 68 , 10))
        render.text(wepfont, 1720+110, 822+30 - rem, "1", render.color(246, 182, 255), render.align_center, render.align_center)
        if(curwep ~= nil and curwep:get_class() ==  "CKnife") then
            render.text(font, 1720-30, 822+30 - rem, "Knife", render.color(246, 182, 255), render.align_center, render.align_center)
            render.rect_filled_multicolor(1720, 822 - rem, 1920, 877 - rem,
            render.color(248, 244, 249 , 10), render.color(248, 244, 249 , 190),
            render.color(248, 244, 249 , 190), render.color(248, 244, 249 , 10))
        end

            
    

        local nad = entities.get_entity_from_handle(LP:get_prop("m_hMyWeapons", nadval))
        local nad2 = entities.get_entity_from_handle(LP:get_prop("m_hMyWeapons", nadval2))
        local nad3 = entities.get_entity_from_handle(LP:get_prop("m_hMyWeapons", nadval3))

        local s1;
        local s2;
        local s3;

                
        if(nad ~=nil) then

            local ssS1 = "UNK";
            local sssV1 = "UNK";
            if(weptofont(nad:get_class(), false, false, true) ~= "UNK") then
                ssS1,sssV1 = weptofont(nad:get_class(), false, false, true)
            else
                nadval = nadval + 1   
            end
            local CP = nad:get_class()
            s1 = nad:get_class()
            local rem = 0;

            if(S == "UNK") then
                rem = 55;
            else
                rem = 0;
            end
            if(ssS1 ~= "UNK") then
                render.rect_filled_multicolor(1720, 657+rem, 1920, 712+rem,
                render.color(68, 68, 68 , 10), render.color(68, 68, 68 , 190),
                render.color(68, 68, 68 , 190), render.color(68, 68, 68 , 10))
                render.text(wepfont, 1720+110, 657+30+rem, ssS1, render.color(246, 182, 255), render.align_center, render.align_center)

                if(curwep ~= nil and CP == curwep:get_class()) then
                    render.text(font, 1720-30, 657+30+rem, sssV1, render.color(246, 182, 255), render.align_center, render.align_center)
                    render.rect_filled_multicolor(1720, 657+rem, 1920, 712+rem,
                    render.color(248, 244, 249 , 10), render.color(248, 244, 249 , 190),
                    render.color(248, 244, 249 , 190), render.color(248, 244, 249 , 10))
                end

            end

        end

        if(nad2 ~=nil) then

            local ssS2 = "UNK";
            local sssV2 = "UNK";
            if(weptofont(nad2:get_class(), false, false, true) ~= "UNK") and nad2:get_class() ~= s1 then
                ssS2,sssV2 = weptofont(nad2:get_class(), false, false, true)
            else
                nadval2 = nadval2 + 1   
            end
            local CP = nad2:get_class()
            s2 = nad2:get_class()
            local rem = 0;

            if(S == "UNK") then
                rem = 55;
            else
                rem = 0;
            end
            if(ssS2 ~= "UNK") then
                render.rect_filled_multicolor(1720, 602+rem, 1920, 657+rem,
                render.color(68, 68, 68 , 10), render.color(68, 68, 68 , 190),
                render.color(68, 68, 68 , 190), render.color(68, 68, 68 , 10))
                render.text(wepfont, 1720+110, 602+30+rem, ssS2, render.color(246, 182, 255), render.align_center, render.align_center)

                if(curwep ~= nil and CP == curwep:get_class()) then
                    render.text(font, 1720-30, 602+30+rem, sssV2, render.color(246, 182, 255), render.align_center, render.align_center)
                    render.rect_filled_multicolor(1720, 602+rem, 1920, 657+rem,
                    render.color(248, 244, 249 , 10), render.color(248, 244, 249 , 190),
                    render.color(248, 244, 249 , 190), render.color(248, 244, 249 , 10))
                end

            end

        end


        if(nad3 ~=nil) then

            local ssS3 = "UNK";
            local sssV3 = "UNK";
            if(weptofont(nad3:get_class(), false, false, true) ~= "UNK") and nad3:get_class() ~= s1 and nad3:get_class() ~= s2 then
                ssS3,sssV3 = weptofont(nad3:get_class(), false, false, true)
            else
                nadval3 = nadval3 + 1   
            end
            local CP = nad3:get_class()
            s3 = nad3:get_class()
            local rem = 0;

            if(S == "UNK") then
                rem = 55;
            else
                rem = 0;
            end
            if(ssS3 ~= "UNK") then
                render.rect_filled_multicolor(1720, 547+rem, 1920, 602+rem,
                render.color(68, 68, 68 , 10), render.color(68, 68, 68 , 190),
                render.color(68, 68, 68 , 190), render.color(68, 68, 68 , 10))
                render.text(wepfont, 1720+110, 547+30+rem, ssS3, render.color(246, 182, 255), render.align_center, render.align_center)

                if(curwep ~= nil and CP == curwep:get_class()) then
                    render.text(font, 1720-30, 547+30+rem, sssV3, render.color(246, 182, 255), render.align_center, render.align_center)
                    render.rect_filled_multicolor(1720, 547+rem, 1920, 602+rem,
                    render.color(248, 244, 249 , 10), render.color(248, 244, 249 , 190),
                    render.color(248, 244, 249 , 190), render.color(248, 244, 249 , 10))
                end

            end

        end

end

function HealthArm(H,W,fnt,HP,AP)
    render.rect_filled_multicolor(0, H-2, 560, H-55,
    render.color(68, 68, 68 , 190), render.color(68, 68, 68 , 90),
    render.color(68, 68, 68 , 90), render.color(68, 68, 68 , 190))
    t = t + global_vars.frametime
    if(t>=1) then
        t = 1
    end

    HPLEN = linear(global_vars.frametime,HPLEN,(HP) - HPLEN, 0.1)
    APLEN = linear(global_vars.frametime,APLEN,(AP) - APLEN, 0.1)

    if (curhealth ~= HP) then
        
        render.rect_filled(115, H-21, 115+HPLEN*1.2 , H-26, render.color(180, 18, 218 ))
        render.text(fnt, 37, H-25, "HP", render.color(180, 18, 218 ), render.align_center, render.align_center)
        render.text(font2, 37+44, H-25, HP, render.color(180, 18, 218 ), render.align_center, render.align_center)


    else
        render.rect_filled(115, H-21, 115+HPLEN*1.2 , H-26, render.color(246, 182, 255))
        render.text(fnt, 37, H-25, "HP", render.color(246, 182, 255), render.align_center, render.align_center)
        render.text(font2, 37+44, H-25, HP, render.color(246, 182, 255), render.align_center, render.align_center)
    end
    render.rect_filled(373, H-21, 373+APLEN*1.2 , H-26, render.color(246, 182, 255))
    render.text(fnt, 260+37, H-25, "AP", render.color(246, 182, 255), render.align_center, render.align_center)
    render.text(font2, 295+44, H-25, AP, render.color(246, 182, 255), render.align_center, render.align_center)

    utils.run_delayed(500, function()
        curhealth = HP
    end)

 

end

local c = 1;
local b  = 1.3;
function on_game_event(event)
    if event:get_name() == "round_prestart" then
        TcntTotal = 0
        CTcntTotal = 0
        Plakillamt = 0
        Tcnt = 0;
        CTcnt = 0;
        entities.for_each_player(function(player)
            if(player:get_prop("m_iTeamNum") == 2)  then
                TcntTotal = TcntTotal + 1
            end
        
            if(player:get_prop("m_iTeamNum") == 3)  then
                CTcntTotal = CTcntTotal + 1
            end
        end)
    
    end


    if event:get_name() == "player_death" then
        if((engine.get_player_for_user_id(event:get_int("attacker"))) == engine.get_local_player()) then
            Plakillamt = Plakillamt + 1;
        end
        local p = entities.get_entity(engine.get_player_for_user_id(event:get_int("userid")))
        table.insert(Playerdeath,
        {
            Victim = entities.get_entity(engine.get_player_for_user_id(event:get_int("userid"))),
            Attacker = entities.get_entity(engine.get_player_for_user_id(event:get_int("attacker"))),
            WeaponName = event:get_string("weapon"),
            waittime = 1,
            fadetime = 1,
            twidth = 0,
            Atckwidth = 0,
        }

    
    )
        if(p:get_prop("m_iTeamNum") == 2)  then
            Tcnt = Tcnt + 1
        end

        if(p:get_prop("m_iTeamNum") == 3)  then
            CTcnt = CTcnt + 1
        end

        tim2 = timer(4.2, global_vars.curtime)
        c = 1;
        b  = 1.3;

    end



    if event:get_name() == "weapon_fire" then
        if(engine.get_player_for_user_id(event:get_int("userid")) == engine.get_local_player()) then
            justshot = true;
            tim = timer(cycleshit, global_vars.curtime)
        end

    end

end

function PlaCount (W,H)
    local ct = 0;
    local te = 0;
    entities.for_each_player(function(player)
        if(player:get_prop("m_iTeamNum") == 2 and player:is_alive())  then
            te = te + 1
        end

        if(player:get_prop("m_iTeamNum") == 3 and player:is_alive())  then
            ct = ct + 1
        end
    end)



    if(tim2 > global_vars.curtime) then
        LINCT = linear(global_vars.frametime*10,LINCT,(CTcnt) - LINCT, 0.1)
        LINT = linear(global_vars.frametime,LINT,(Tcnt) - LINT, 0.1)
        b = b - (1 / 3) * global_vars.frametime
        if b <= 0 then  
        c = c - (1 / 0.25) * global_vars.frametime
        end
    
        render.rect_filled(W/2-70, 150, W/2-30, 110, render.color(237, 237, 238,120*c))
        render.rect_filled(W/2+70, 150, W/2+30, 110, render.color(237, 237, 238,120*c))
    
    

        render.rect_filled_multicolor(W/2+70, 150, W/2+30, ((110) + ((40/TcntTotal) * LINT)),
        render.color(255, 0, 0*c), render.color(255, 0, 0*c),
        render.color(255, 0, 0*c), render.color(255, 0, 0*c))
    
        render.rect_filled_multicolor(W/2-70, 150, W/2-30, ((110) + ((40/CTcntTotal) * LINCT)),
        render.color(56, 112, 150,255*c), render.color(0, 113, 243 ,255*c),
        render.color(56, 112, 150,255*c), render.color(0, 113, 243 ,255*c))
        render.text(font, W/2+50, 130, te, render.color(255, 255, 255,255*c), render.align_center, render.align_center)
        render.text(font, W/2-50, 130, ct, render.color(255, 255, 255,255*c), render.align_center, render.align_center)
    else
        c = 1;
        b  = 1.3;
    
    end
    


end

function timer(duration, curtime)
    local start = curtime + duration;

    return start;
end

local reload = false
local s = false
local val = 0
local teste = 1055;
function AmmoHud()
    local LP = entities.get_entity(engine.get_local_player())
    local wep = LP:get_weapon()
    if(wep ~= nil) then
        local index = wep:get_prop("m_iItemDefinitionIndex")
        local inf = utils.get_weapon_info(index)
        local cycle_time = 0;
        cycleshit = inf.cycle_time;
        local nextattacktime = LP:get_prop("m_flNextAttack") - global_vars.curtime;

        if(nextattacktime < 0) then
            nextattacktime = 0
        end

        if(nextattacktime > 2) then
            reload = true
            if(s == false) then
                val = nextattacktime
                s = true
            end
        end
        if(nextattacktime <= 0.01) then
            reload = false
            s = false
        end



        if(reload == true) then
            teste = (1760 + (1600 - 1760) * (((nextattacktime*10/val*10))/100))
            render.rect_filled(1600, 1055, teste, (1055-10), render.color(246, 182, 255))

        end




        local wait = 0.5





        if(wep:get_prop("m_iClip1") ~= -1) then
            render.rect_filled_multicolor(1920, 1080-2, 1570, 1080-55,
            render.color(68, 68, 68 , 190), render.color(68, 68, 68 , 30),
            render.color(68, 68, 68 , 30), render.color(68, 68, 68 , 190))
            if(primheld == true) then
                render.text(wepfont, 1850, 1055-2, S, render.color(246, 182, 255), render.align_center, render.align_center)
            elseif Secheld == true then
                render.text(wepfont, 1850, 1055-2, sS, render.color(246, 182, 255), render.align_center, render.align_center)
            end
            if(reload ~= true) then
                render.text(font2, 1700, 1055-2, wep:get_prop("m_iClip1", 0), render.color(246, 182, 255), render.align_center, render.align_center)
                render.text(font2, 1730, 1055-2, "/", render.color(246, 182, 255), render.align_center, render.align_center)
                render.text(font2, 1760, 1055-2, inf.max_clip1, render.color(246, 182, 255), render.align_center, render.align_center)
            end

            
        end



        if(justshot == true) then
            cycle_time = linear(global_vars.frametime,cycle_time,(cycle_time-255),0.1)
            if(primheld == true) then
                render.text(wepfont, 1850, 1055-2, S, render.color(255, 0, 0), render.align_center, render.align_center)
            elseif Secheld == true then
                render.text(wepfont, 1850, 1055-2, sS, render.color(255, 0, 0), render.align_center, render.align_center)
            end
            if(tim < global_vars.curtime) then
                justshot = false
            end


        end
    end


end

function KillList()
    local LP = entities.get_entity(engine.get_local_player())
    for cc, Pla in pairs(Playerdeath) do   
        local wepname = Pla.WeaponName
        local amtstored = table.getn(Playerdeath);
		if (Pla.Victim:get_player_info() ~= nil) then
			Pla.twidth = (render.get_text_size(font, Pla.Victim:get_player_info().name));
			Pla.Atckwidth = (render.get_text_size(font, Pla.Attacker:get_player_info().name));  
			if(Pla.Attacker:get_player_info().name == LP:get_player_info().name) then
				render.rect_filled_multicolor(1765-(Pla.Atckwidth + Pla.twidth), 105+(33*cc), 1980, 73+(33*cc),
				render.color(188, 19, 0, 40), render.color(188, 19, 0, 120),
				render.color(188, 19, 0, 120), render.color(188, 19, 0, 40))
				render.text(font, 1790-(Pla.Atckwidth + Pla.twidth), 90+(33*cc), Pla.Attacker:get_player_info().name, render.color(255, 255, 255, 255*Pla.fadetime), render.align_center, render.align_center)
				render.text(font, 1940-(Pla.Atckwidth + Pla.twidth), 90+(33*cc), Pla.Victim:get_player_info().name, render.color(255, 255, 255, 255*Pla.fadetime), render.align_center, render.align_center)
				render.text(wepfont2, 1860-(Pla.Atckwidth + Pla.twidth), 90+(33*cc), weptofont(wepname, true, true, true), render.color(255, 255, 255, 255*Pla.fadetime), render.align_center, render.align_center)
			else
				render.rect_filled_multicolor(1765-(Pla.Atckwidth + Pla.twidth), 105+(33*cc), 1980, 73+(33*cc),
				render.color(124, 124, 124, 40), render.color(124, 124, 124, 120),
				render.color(124, 124, 124, 120), render.color(124, 124, 124, 40))
				render.text(font, 1790-(Pla.Atckwidth + Pla.twidth), 90+(33*cc), Pla.Attacker:get_player_info().name, render.color(255, 255, 255, 255*Pla.fadetime), render.align_center, render.align_center)
				render.text(font, 1940-(Pla.Atckwidth + Pla.twidth), 90+(33*cc), Pla.Victim:get_player_info().name, render.color(255, 255, 255, 255*Pla.fadetime), render.align_center, render.align_center)
				render.text(wepfont2, 1860-(Pla.Atckwidth + Pla.twidth), 90+(33*cc), weptofont(wepname, true, true, true), render.color(255, 255, 255, 255*Pla.fadetime), render.align_center, render.align_center)
			end

			Pla.waittime = Pla.waittime - (1 / 3) * global_vars.frametime
			if Pla.waittime <= 0 then  
				Pla.fadetime = Pla.fadetime - (1 / 0.25) * global_vars.frametime
			end
			if Pla.fadetime <= 0 then
				table.remove(Playerdeath, cc)
			end

		end
	end

end

local t = 0
local shot2 = 0;
local Shots = {} 
local enable;

local font = render.create_font("VERDANAB.ttf", 17)

local function mark(poser)
    local Col = ColorPicker:get_color()
    for i, Shot in pairs(Shots) do    
        if Shot.easing >= 1 then
            Shot.easing = 1
        elseif Shot.easing < 1 then
            Shot.easing = Shot.easing + (global_vars.frametime)
        end
        local x,y = utils.world_to_screen(Shot.Position:unpack())
        if x ~= nil and Shot.Damage > 0 then
            render.text(font, x, (y + easing.in_sine(Shot.easing) * -25),math.floor(Shot.Damage * Shot.easing) , render.color(Col.r, Col.g, Col.b, 255*Shot.FadeTime), render.align_center, render.align_center)
        end
        
        Shot.WaitTime = Shot.WaitTime - (1 / 3) * global_vars.frametime
        if Shot.WaitTime <= 0 then  
            Shot.FadeTime = Shot.FadeTime - (1 / 0.25) * global_vars.frametime
        end

        if Shot.FadeTime <= 0 then
            table.remove(Shots, i)
        end
    end
   
end

function on_shot_registered(shot_info)
    shot2 = 1
    if enable then
        table.insert(Shots, 
        {
            Position    = shot_info.client_impacts[#shot_info.client_impacts],
            Damage = shot_info.server_damage,
            FadeTime    = 1,
            WaitTime    = 0.5,
            easing = 0,
        })
    end

end

function on_paint()
    if(engine.is_in_game()) then
        enable = Checkbox:get_bool()

        if shot2 == 1 and enable then
            mark(pos)
        end
       
        local W,H = render.get_screen_size()
        Inventory()
        HealthArm(H,W,font,entities.get_entity(engine.get_local_player()):get_prop("m_iHealth"), entities.get_entity(engine.get_local_player()):get_prop("m_ArmorValue") )
        PlaCount(W,H)
        AmmoHud()
        KillList()
        enable = Checkbox:get_bool()
    

    end
   
end














