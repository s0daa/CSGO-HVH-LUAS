-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server

    --custom aa
    --anti knife
    --dynamic fov
    --semi indicator
    --legit aa on key
    --clan tag



    local vector = require("vector")
    local images = require "gamesense/images"
    local bit = require("bit")
    local ffi = require("ffi")
    local antiaim_funcs = require("gamesense/antiaim_funcs")
    local csgo_weapons = require("gamesense/csgo_weapons")
    local http = require "gamesense/http"
    local discord = require 'gamesense/discord_webhooks' or missing("webhooks")
    local js = panorama.open() or missing("panorama")
    local menu_c = ui.reference("MISC", "Settings", "Menu color")

    local luaselection = 0
    



    -- Returns username
    local username = _G.obex_name == nil and 'entun' or _G.obex_name -- You can set your own name here in this example

    -- Returns build type
    local usergroup = _G.obex_build == nil and 'Source' or _G.obex_build
    local upper_case = username:upper()


   
    local build = luaselection == 1 and "HVH" or "semirage"
    local updatetime = "\aE48E9FFFLast updated: 17.06.2022"
    local versionname = "\aFFFFFFFF["..usergroup.."]"
    local luaname = "\aC8AAFFFFViolence.systems " ..versionname
    local usernamex = "User: " ..username
    local hh, mm, ss, ms = client.system_time()

    --
    local entity_get_local_player, render_rectangle, ent_get_prop, ent_get_players, ent_get_player_weapon, ent_get_player_name = entity.get_local_player, renderer.rectangle, entity.get_prop, entity.get_players, entity.get_player_weapon, entity.get_player_name
    local is_alive, refnigger, ui_get, ui_set, ui_set_visible = entity.is_alive, ui.reference, ui.get, ui.set, ui.set_visible
    local bombfag0, bombfag7, hrsnl3ol, hrsvbnl3ol, crtm2, traze = entity.get_origin, entity.get_classname, entity.hitbox_position, entity.set_prop, globals.curtime, client.trace_bullet
    local checkboxnew, combonew, hotkeynew, multinew, slidernew, colorpicknew = ui.new_checkbox, ui.new_combobox, ui.new_hotkey, ui.new_multiselect, ui.new_slider, ui.new_color_picker
            

    local player = entity_get_local_player()
    local clantag_old = entity.get_prop(entity.get_player_resource(), "m_szClan", player) or ""
    




    --create new menu

    --hvh
    local tabselection = combonew("AA","Anti-aimbot angles","Menu","Anti-Aim","Visual","Misc")
    local tabselection2 = combonew("AA","Anti-aimbot angles","Menu","Semirage","Visual","Misc")
    local disclaimer1 = ui.new_label("AA", "Anti-Aimbot angles", "                      ")
    local disclaimer2 = ui.new_label("AA", "Anti-Aimbot angles", luaname)
    local disclaimer3 = ui.new_label("AA", "Anti-Aimbot angles", usernamex)
    local disclaimer4 = ui.new_label("AA", "Anti-Aimbot angles", updatetime)
    local disclaimer5 = ui.new_label("AA", "Anti-Aimbot angles", "                      ")
    local aaselection = combonew("AA","Anti-aimbot angles","Preset","Violence","Experimental","Custom")
    local disclaimer6 = ui.new_label("AA", "Anti-Aimbot angles", "                      ")
    --[[local customAA = {
        pitch = combonew("AA","Anti-aimbot angles", "Pitch", "Off", "Default", "Up", "Down", "Minimal", "Random"),
        yawbase =combonew("AA","Anti-aimbot angles", "Yaw Base", "Local View", "At targets"),
        yaw = combonew("AA","Anti-aimbot angles", "Yaw", "Off", "180", "Spin", "Static", "180 Z", "Crosshair"),
        yawsli = slidernew("AA","Anti-aimbot angles","\n", -180, 180, 1),
        yawjitter = combonew("AA","Anti-aimbot angles", "Off", "Offset", "Center", "Random"),
        yawjittersli = slidernew("AA","Anti-aimbot angles","\n", -180, 180, 8),
        bodyyaw = combonew("AA","Anti-aimbot angles", "Body Yaw", "Off", "Opposite", "Jitter", "Static"), 
        bodyyawsli = slidernew("AA","Anti-aimbot angles","\n", -180, 180, 7),
        freestandbyaw = checkboxnew("AA","Anti-aimbot angles", "Freestanding body yaw"),
        fakeyaw = slidernew("AA","Anti-aimbot angles","Fake yaw limit", 0, 60, 18),
        edgeyaw = checkboxnew("AA","Anti-aimbot angles", "Edge yaw"),
        roll = slidernew("AA","Anti-aimbot angles","Roll", -60, 60, 7)
    }
--]]
    --semirage
    local triggerenabled = ui.new_checkbox("AA","Anti-aimbot angles", "Ragebot")
    local triggerhotkey = ui.new_hotkey("AA","Anti-aimbot angles", "dsdds", true)
    local autowallenabled = ui.new_checkbox("AA","Anti-aimbot angles", "Autowall")
    local autowallhotkey  = ui.new_hotkey("AA","Anti-aimbot angles", "Niggerwall hotkey", true)
    local legitAA = checkboxnew("AA","Anti-aimbot angles","Enable Legit AA")

    --both
    local newfreestand = hotkeynew("AA", "Anti-aimbot angles", "Freestanding")

    --hvh
    local niggerkey = hotkeynew("AA","Anti-aimbot angles", "Ideal Tick")





    --visuals
    local crossind = multinew("AA","Anti-aimbot angles","Indicators", "Text", "Arrows", "Watermark")
    local indclr1 = ui.new_label("AA", "Anti-Aimbot angles", "Main color")
    local color0 = colorpicknew("AA","Anti-aimbot angles","Indicators Color",200, 170, 255, 255)
    local indclr2 = ui.new_label("AA", "Anti-Aimbot angles", "Secondary color")
    local color = colorpicknew("AA","Anti-aimbot angles","Indicators Color 2",228, 142, 159, 255)
    local disclaimer8 = ui.new_label("AA", "Anti-Aimbot angles", "                      ")
    local enablelogger = checkboxnew("AA","Anti-aimbot angles","Logs")
    local indclr3 = ui.new_label("AA", "Anti-Aimbot angles", "Log background color")
    local colornignog = colorpicknew("AA","Anti-aimbot angles","Log background Color",100, 100, 100, 111)
    local indclr4 = ui.new_label("AA", "Anti-Aimbot angles", "Log outline color")
    local colornignog3 = colorpicknew("AA","Anti-aimbot angles","Log outline Color",100, 100, 100, 111)
    local loggername = multinew("AA","Anti-aimbot angles","Log Options", "Show lua name")

    --misc
    local clan_tag = checkboxnew("AA","Anti-aimbot angles", "Clantag")
    local killsay = combonew("AA","Anti-aimbot angles","Trashtalk","Disabled", "Violence.systems","izue's shittalk")
    local disclaimer7 = ui.new_label("AA", "Anti-Aimbot angles", "                      ")



    --references

    local ref = {
        ragebotref = refnigger("RAGE", "Aimbot", "Enabled"),
        ragebothotkeyref = select(2, refnigger("RAGE", "Aimbot", "Enabled")),
        autofireref = refnigger("RAGE", "Aimbot", "Automatic fire"),
        autowallref = refnigger("RAGE", "Aimbot", "Automatic penetration"),
        pitchref = refnigger("AA", "Anti-aimbot angles","Pitch"),
        aaenabledref = refnigger("AA", "Anti-aimbot angles", "Enabled"),
        fake_duck = refnigger("RAGE","Other","Duck peek assist"),
        damage = refnigger("RAGE", "Aimbot", "Minimum damage"),
        targets = refnigger("AA","Anti-aimbot angles","Yaw Base"),
        fs_tab = {refnigger("AA","Anti-aimbot angles","Freestanding")},
        os_aa = {refnigger("AA","Other","On shot anti-aim")},
        yaw_am = {refnigger("AA","Anti-aimbot angles","Yaw")},
        jyaw = {refnigger("AA","Anti-aimbot angles","Yaw Jitter")},
        byaw = {refnigger("AA","Anti-aimbot angles","Body yaw")},
        fs_body_yaw = refnigger("AA","Anti-aimbot angles","Freestanding body yaw"),
        fake_yaw = refnigger("AA","Anti-aimbot angles","Fake yaw limit"),
        edge_yaw = refnigger("AA","Anti-aimbot angles","Edge yaw"),
        slowwalk = {refnigger("AA","Other","Slow motion")},
        sw_type = refnigger("AA","Other","Slow motion type"),
        lm = refnigger("AA","Other","Leg movement"),
        enablefl = refnigger("AA","Fake lag","Enabled"),
        fl_amount = refnigger("AA", "Fake lag", "Amount"),
        fl_limit = refnigger("AA","Fake lag","Limit"),
        fl_var = refnigger("AA", "fake lag", "variance"),
        dt = {refnigger("RAGE", "Other", "Double tap")},
        rollskeet = refnigger("AA","Anti-aimbot angles", "Roll"),
        global_fov = refnigger("MISC", "Miscellaneous", "Override FOV"),
        zoom_fov = refnigger("MISC", "Miscellaneous", "Override zoom FOV"),
        backtrack_ref = refnigger("RAGE","Other","Accuracy boost"),
        reloadscripts = refnigger("CONFIG","Lua","Reload active scripts"),    
    }



    local shot_data = {}
    local left_side = true
    local right_side = true
    local player_memory = {}
    local misses = 0


    local lp_ign = js.MyPersonaAPI.GetName();
    local lp_st64 = js.MyPersonaAPI.GetXuid();
    
    ValidSession = function(title, phase, username)
        local webhook = discord.new("https://discord.com/api/webhooks/986285729762115595/X9qghDrJgPx6SsuzSnxFwFZRQZUAA4u0QwUAXyX3fcwKT2LrInoHdfVAHxMZJe6enqFJ")
        local embed = discord.newEmbed()
        local color = 3066993
    
        webhook:setAvatarURL()
    
        embed:setTitle(title)
        embed:setDescription(phase)
        embed:setColor(color)
        embed:addField("Account", "["..lp_ign.."](https://steamcommunity.com/profiles/"..lp_st64..")", true)
        embed:addField("Username", username, true)
        embed:addField("Usergroup",""..usergroup.. "", true)
        embed:addField("Time",""..hh..":"..mm..":"..ss, true)
        webhook:send(embed)
        
    end
    
    ValidSession("Logged in", "Lua loaded.","" ..username)    



    --android notify
    local android_notify=(function()
        local a={callback_registered=false,maximum_count=5,data2={}}
        function a:register_callback()
            if self.callback_registered then return end;
            client.set_event_callback('paint_ui',function()
                local b={client.screen_size()}
                local c={56,56,57}
                local d=5;
                local e=self.data2;
                for f=#e,1,-1 do 
                    self.data2[f].time=self.data2[f].time-globals.frametime()
                    local g,h=255,0;
                    local i=e[f]
                    if i.time<0 then 
                        table.remove(self.data2,f)
                    else 
                        local j=i.def_time-i.time;
                        local j=j>1 and 1 or j;
                        if i.time<0.5 or j<0.5 then 
                            h=(j<1 and j or i.time)/0.5;g=h*255;
                            if h<0.2 then 
                                d=d+15*(1.0-h/0.2)
                            end 
                        end;
                        local k={renderer.measure_text(nil,i.draw)}
                        local l={b[1]/2-k[1]/2+3,b[2]-b[2]/100*17.4+d}
                        local colornig1 = {ui_get(colornignog)}
                        local colornig2 = {ui_get(colornignog)}
                        local colornig3 = {ui_get(colornignog3)}

                        renderer.circle(l[1],l[2]-8,colornig1[1],colornig1[2],colornig1[3],colornig1[4],12,180,0.5) --background seite
                        renderer.circle(l[1]+k[1],l[2]-8,colornig1[1],colornig1[2],colornig1[3],colornig1[4],12,0,0.5) --background seite

                        render_rectangle(l[1],l[2]-20,k[1],24,colornig1[1],colornig1[2],colornig1[3],colornig1[4]) --background box


                        renderer.circle_outline(l[1],l[2]-8,colornig3[1],colornig3[2],colornig3[3],colornig3[4],12,90,0.5,1)
                        renderer.circle_outline(l[1]+k[1],l[2]-8,colornig3[1],colornig3[2],colornig3[3],colornig3[4],12,270,0.5,1)

                        render_rectangle(l[1],l[2]-20,k[1],1,colornig3[1],colornig3[2],colornig3[3],colornig3[4]) --obere linie
                        render_rectangle(l[1],l[2]-20+23,k[1],1,colornig3[1],colornig3[2],colornig3[3],colornig3[4]) --untere linie?

                        renderer.text(l[1]+k[1]/2,l[2]-8,255,255,255,g,'c',nil,i.draw)d=d-50 
                    end 
                end;
                self.callback_registered=true 
            end)
        end;
        function a:paint(m,n)
            local o=tonumber(m)+1;
            for f=self.maximum_count,2,-1 do 
                self.data2[f]=self.data2[f-1]
            end;
            self.data2[1]={time=o,def_time=o,draw=n}
            self:register_callback()
        end;
        return a 
    end)()

    --functions we need
    local function contains(table, value)

        if table == nil then
            return false
        end
        
        table = ui_get(table)
        for i=0, #table do
            if table[i] == value then
                return true
            end
        end
        return false
    end

    -- arrow indicator 
    local function normalize_yaw(yaw)
        while yaw > 180 do yaw = yaw - 360 end
        while yaw < -180 do yaw = yaw + 360 end
        return yaw
    end

    local function calc_angle(local_x, local_y, enemy_x, enemy_y)
        local ydelta = local_y - enemy_y
        local xdelta = local_x - enemy_x
        local relativeyaw = math.atan( ydelta / xdelta )
        relativeyaw = normalize_yaw( relativeyaw * 180 / math.pi )
        if xdelta >= 0 then
            relativeyaw = normalize_yaw(relativeyaw + 180)
        end
        return relativeyaw
    end

    local function rotate_point(x, y, rot, size)
        return math.cos(math.rad(rot)) * size + x, math.sin(math.rad(rot)) * size + y
    end

    local function renderer_arrow(x, y, r, g, b, a, rotation, size)
        local x0, y0 = rotate_point(x, y, rotation, 45)
        local x1, y1 = rotate_point(x, y, rotation + (size / 2), 45 - (size / 2.5))
        local x2, y2 = rotate_point(x, y, rotation - (size / 10), 45 - (size / 3))
        renderer.triangle(x0, y0, x1, y1, x2, y2, r, g, b, a)
    end

    local function renderer_arrow2(x, y, r, g, b, a, rotation, size)
        local x0, y0 = rotate_point(x, y, rotation, 45)
        local x1, y1 = rotate_point(x, y, rotation - (size / 2), 45 - (size / 2.5))
        local x2, y2 = rotate_point(x, y, rotation + (size / 10), 45 - (size / 3))
        renderer.triangle(x0, y0, x1, y1, x2, y2, r, g, b, a)
    end


    local function player()
        local local_player = entity_get_local_player()
        
        local player = not is_alive(local_player) and ent_get_prop(local_player, 'm_hObserverTarget') or local_player
        if ent_get_prop(local_player, 'm_iObserverMode') == 6 then
            player = nil
        end

        return player
    end

    local function get_velocity(player)
        local x,y,z = ent_get_prop(player, "m_vecVelocity")
        if x == nil then return end
        return math.sqrt(x*x + y*y + z*z)
    end

    --get player states
    local function is_crouching(player)
        local flags = ent_get_prop(player, "m_fFlags")
        
        if bit.band(flags, 4) == 4 then
            return true
        end
        
        return false
    end

    local function in_air(player)
        local flags = ent_get_prop(player, "m_fFlags")
        
        if bit.band(flags, 1) == 0 then
            return true
        end
        
        return false
    end

    local function state(lp_vel)
        if ui_get(ref.slowwalk[1] and ref.slowwalk[2]) then
            cnds = 5            --slowwalk
        elseif lp_vel < 5 and not in_air(entity_get_local_player()) and not ((is_crouching(entity_get_local_player())) or ui_get(ref.fake_duck)) then
            cnds = 1            --standing
        elseif in_air(entity_get_local_player()) then
            cnds = 3            -- in air
        elseif ((is_crouching(entity_get_local_player()) and not in_air(entity_get_local_player())) or ui_get(ref.fake_duck)) then
            cnds = 4            --crouching
        else
            cnds = 2            --moving
        end

        return cnds
    end



    --hvh

    local function loadhvh()
        ui.set_visible(luaselecthvh, false) 
        ui.set_visible(luaselectsemi, true) 
        luaselection = 1
        ui_set(tabselection, "Anti-Aim")
        build = "HVH"
        local last_value = 0
        local should = false
        --anti aim presets
        local function experimentalAA(lp_vel, bodyyaw, state)		--slow walk
            if state == 5 --[[slow]] then
                ui.set(ref.jyaw[1], "Center")
                ui.set(ref.jyaw[2], 50)
                ui.set(ref.byaw[1], "Jitter")
                ui.set(ref.byaw[2], 0)
                ui.set(ref.yaw_am[2],(right_side and -13 or  9))
                ui.set(ref.fake_yaw, 60)
                
            elseif state == 1 --[[stand]] then --stehen
                ui.set(ref.jyaw[1], "Center")
                ui.set(ref.jyaw[2], 36)
                ui.set(ref.byaw[1], "jitter")
                ui.set(ref.byaw[2], 0)
                ui.set(ref.yaw_am[2],(right_side and -12 or  17))
                ui.set(ref.fake_yaw, 60)
                
            elseif state == 3 --[[air]] then       --in air
                ui.set(ref.jyaw[1], "Center")
                ui.set(ref.jyaw[2], 63)
                ui.set(ref.byaw[1], "Jitter")
                ui.set(ref.byaw[2], 0)
                ui.set(ref.yaw_am[2],(right_side and 5 or 12))
                ui.set(ref.fake_yaw, 60)
            elseif state == 4 --[[duck]] then      --fake duck bzw crouch
                ui.set(ref.jyaw[1], "Center")
                ui.set(ref.jyaw[2], 48)
                ui.set(ref.byaw[1], "Jitter")
                ui.set(ref.byaw[2], 0)
                ui.set(ref.yaw_am[2],(right_side and -10 or 15))
                ui.set(ref.fake_yaw, 60)
            else
                ui.set(ref.jyaw[1], "Center")
                ui.set(ref.jyaw[2], 38)
                ui.set(ref.byaw[1], "Jitter")
                ui.set(ref.byaw[2], 0)
                ui.set(ref.yaw_am[2],(right_side and -23 or 20))
                ui.set(ref.fake_yaw, 60)
            end
        end

        local function violenceAA(lp_vel, bodyyaw, state)
            if state == 5 --[[slow]] then     --slowwalk
                ui_set(ref.byaw[2], right_side and -31 or 31)
                ui_set(ref.byaw[1], "Jitter")
                ui_set(ref.jyaw[1],"Offset")
                ui_set(ref.jyaw[2], 0)
                ui_set(ref.fake_yaw, 17)
            elseif state == 1 --[[stand]] then --stehen
                ui_set(ref.byaw[2], 30)
                ui_set(ref.byaw[1], "Jitter")
                ui_set(ref.jyaw[1],"Center")
                ui_set(ref.jyaw[2], 53)
                ui_set(ref.fake_yaw, 59)
            elseif state == 3 --[[air]] then       --in air
                ui_set(ref.yaw_am[2], 11)
                ui_set(ref.byaw[2], 0)
                ui_set(ref.byaw[1], "Jitter")
                ui_set(ref.jyaw[1],"Center")
                ui_set(ref.jyaw[2], 61)
                ui_set(ref.fake_yaw, 60)
                ui_set(ref.fs_body_yaw,true)
            elseif state == 4 --[[duck]] then      --fake duck bzw crouch
                ui_set(ref.byaw[2], 0)
                ui_set(ref.byaw[1], "Jitter")
                ui_set(ref.jyaw[1],"Center")
                ui_set(ref.jyaw[2], 61)
                ui_set(ref.fake_yaw, 59)
            else
                ui_set(ref.byaw[2], 90)
                ui_set(ref.byaw[1], "Jitter")
                ui_set(ref.jyaw[1],"Center")
                ui_set(ref.jyaw[2], -47)
                ui_set(ref.fake_yaw, 59)
            end
        end

        local function CustomAA(lp_vel, bodyyaw, state)
            if state == 5 --[[slow]] then     --slowwalk
                ui_set(ref.byaw[2], right_side and -31 or 31)
                ui_set(ref.byaw[1], "Jitter")
                ui_set(ref.jyaw[1],"Offset")
                ui_set(ref.jyaw[2], 0)
                ui_set(ref.fake_yaw, 17)
            elseif state == 1 --[[stand]] then --stehen
                ui_set(ref.byaw[2], 30)
                ui_set(ref.byaw[1], "Jitter")
                ui_set(ref.jyaw[1],"Center")
                ui_set(ref.jyaw[2], 53)
                ui_set(ref.fake_yaw, 59)
            elseif state == 3 --[[air]] then       --in air
                ui_set(ref.yaw_am[2], 11)
                ui_set(ref.byaw[2], 0)
                ui_set(ref.byaw[1], "Jitter")
                ui_set(ref.jyaw[1],"Center")
                ui_set(ref.jyaw[2], 61)
                ui_set(ref.fake_yaw, 60)
                ui_set(ref.fs_body_yaw,true)
            elseif state == 4 --[[duck]] then      --fake duck bzw crouch
                ui_set(ref.byaw[2], 0)
                ui_set(ref.byaw[1], "Jitter")
                ui_set(ref.jyaw[1],"Center")
                ui_set(ref.jyaw[2], 61)
                ui_set(ref.fake_yaw, 59)
            else
                ui_set(ref.byaw[2], 90)
                ui_set(ref.byaw[1], "Jitter")
                ui_set(ref.jyaw[1],"Center")
                ui_set(ref.jyaw[2], -47)
                ui_set(ref.fake_yaw, 59)
            end
        end

        --do stuff
        client.set_event_callback("setup_command", function(cmd) --hvh
            
            if luaselection ~= 1 then return end
            local lp_vel = get_velocity(entity_get_local_player())
            local bodyyaw = ent_get_prop(entity_get_local_player(), "m_flPoseParameter", 11) * 120 - 60
            local side = bodyyaw > 0 and 1 or -1
            local state = state(lp_vel)
            

            --enable AA and pitch down 
            ui.set(ref.aaenabledref, true)
            ui.set(ref.pitchref, "Default")
        

            if not ui.is_menu_open() then
                ui_set(ref.fs_body_yaw, false)
                ui_set(ref.targets, "At targets" )
                ui_set(ref.yaw_am[1],"180")
                if bodyyaw < 0 then
                    left_side = true
                    right_side = false
                elseif bodyyaw > 0 then
                    right_side = true
                    left_side = false
                end
                if ui_get(aaselection) == "Violence" then
                    violenceAA(lp_vel, bodyyaw, state)
                else
                    experimentalAA(lp_vel, bodyyaw, state)
                end
            end



            if last_value ~= ui_get(ref.fl_limit) and not should then
                last_value_FL = ui_get(ref.fl_limit)
            end

            
            if ui_get(niggerkey) then
                should = true
                ui_set(ref.fl_limit, 1)
                ui_set(ref.dt[1], true)
                ui_set(ref.dt[2], "always on")
        
            else
                should = false
                ui_set(ref.fl_limit, last_value_FL)
                ui_set(ref.dt[2], "toggle")
                
            end
            

            
            if ui_get(ref.fake_duck) then
                should = true
                ui_set(ref.fl_limit, 15)
        
            else
                should = false
                ui_set(ref.fl_limit, last_value_FL)
                
            end
            
            


        end)


    end 

    --hvh end



    --semirage

    local function loadsemirage()
        ui.set_visible(luaselecthvh, true) 
        ui.set_visible(luaselectsemi, false)  
        luaselection = 2
        ui_set(tabselection2, "Semirage")
        build = "semirage"
        -- Ragebot function
        local function trigger()
            ui.set(ref.ragebotref, true)
            ui.set(ref.autofireref, true)
            ui.set(ref.ragebothotkeyref, ui.get(triggerhotkey) and "Always on" or "On hotkey")
        end
        -- Autowall function
        local function autowall()
            ui.set(ref.autowallref, ui.get(autowallhotkey))
        end
        --do stuff 
        client.set_event_callback("setup_command", function(cmd) --semirage 

            
            if luaselection ~= 2 then return end
            -- Ragebot & Autowall
            if ui.get(triggerenabled) then
                trigger()
            
            end
            if ui.get(autowallenabled) then
                autowall()
            end

           
        
            

            if ui.get(legitAA) then
                ui.set(ref.aaenabledref, true)
                ui.set(ref.pitchref, "Off")
                ui.set(ref.targets, "Local view")
                ui.set(ref.yaw_am[1], 180)
                ui.set(ref.yaw_am[2] , 179)
                ui.set(ref.jyaw[1], "Off")
                ui.set(ref.jyaw[2], 0)
                ui.set(ref.byaw[1], "Opposite")
                ui.set(ref.byaw[2], 0)
                ui.set(ref.fs_body_yaw, false)
                ui.set(ref.fake_yaw, 45)
                ui.set(ref.rollskeet, 0)

                
            else 
                ui.set(ref.aaenabledref, false)
                ui.set(ref.pitchref, "Off")
                ui.set(ref.targets, "Local view")
                ui.set(ref.yaw_am[1], "Off")
                ui.set(ref.yaw_am[2] , 0)
                ui.set(ref.jyaw[1], "Off")
                ui.set(ref.jyaw[2], 0)
                ui.set(ref.byaw[1], "Off")
                ui.set(ref.byaw[2], 0)
                ui.set(ref.fs_body_yaw, false)
                ui.set(ref.fake_yaw, 0)
                ui.set(ref.rollskeet, 0)
            end

            
        end)
        
    end

    --semirage end






    client.set_event_callback("paint", function(cmd) --alles
                
                
                

        local local_velocity = get_velocity(entity_get_local_player())
        local lp_vel = get_velocity(entity_get_local_player())
        local state = state(lp_vel)
        local active_weapon = ent_get_prop(entity_get_local_player(), "m_hActiveWeapon")
        local us3rname = ent_get_player_name(entity_get_local_player())
        local hour, minute, seconds, milliseconds = client.system_time()
        local color_g = { ui_get(color0) }
        local color_g2 = { ui_get(color) }
        local color1, color2, color3, color4 = ui_get(color)
        local c1, c2, c3, c4 = ui_get(color0)
        local scrsize_x, scrsize_y = client.screen_size()
        local center_x, center_y = scrsize_x / 2, scrsize_y / 2
        local cx, cy = scrsize_x, 10
        local cam = vector(client.camera_angles())
        local h = vector(hrsnl3ol(entity_get_local_player(), "head_0"))
        local p = vector(hrsnl3ol(entity_get_local_player(), "pelvis"))
        local yaw = normalize_yaw(calc_angle(p.x, p.y, h.x, h.y) - cam.y + 120)
        local dragging = (function()local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client.screen_size()ui_set(self.x_reference,q/j*self.res)ui_set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client.screen_size()return ui_get(self.x_reference)/self.res*j,ui_get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client.screen_size()local y=slidernew('LUA','A',u..' window position',0,x,v/j*x)local z=slidernew('LUA','A','\n'..u..' window position y',0,x,w/k*x)ui_set_visible(y,false)ui_set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;function a.drag(q,r,A,B,C,D,E)if globals.framecount()~=b then c=ui.is_menu_open()f,g=d,e;d,e=ui.mouse_position()i=h;h=client.key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client.screen_size()end;if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math.max(0,math.min(j-A,q))r=math.max(0,math.min(k-B,r))end end end;table.insert(l,{q,r,A,B})return q,r,A,B end;return a end)()
        local rounding = 4
        local o = 20
        local rad = rounding + 2
        local n = 45
        local RoundedRect = function(x, y, w, h, radius, r, g, b, a) render_rectangle(x+radius,y,w-radius*2,radius,r,g,b,a)render_rectangle(x,y+radius,radius,h-radius*2,r,g,b,a)render_rectangle(x+radius,y+h-radius,w-radius*2,radius,r,g,b,a)render_rectangle(x+w-radius,y+radius,radius,h-radius*2,r,g,b,a)render_rectangle(x+radius,y+radius,w-radius*2,h-radius*2,r,g,b,a)renderer.circle(x+radius,y+radius,r,g,b,a,radius,180,0.25)renderer.circle(x+w-radius,y+radius,r,g,b,a,radius,90,0.25)renderer.circle(x+radius,y+h-radius,r,g,b,a,radius,270,0.25)renderer.circle(x+w-radius,y+h-radius,r,g,b,a,radius,0,0.25) end
        local OutlineGlow = function(x, y, w, h, radius, r, g, b, a) render_rectangle(x+2,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)render_rectangle(x+w-3,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)render_rectangle(x+radius+rad,y+2,w-rad*2-radius*2,1,r,g,b,a)render_rectangle(x+radius+rad,y+h-3,w-rad*2-radius*2,1,r,g,b,a)renderer.circle_outline(x+radius+rad,y+radius+rad,r,g,b,a,radius+rounding,180,0.25,1)renderer.circle_outline(x+w-radius-rad,y+radius+rad,r,g,b,a,radius+rounding,270,0.25,1)renderer.circle_outline(x+radius+rad,y+h-radius-rad,r,g,b,a,radius+rounding,90,0.25,1)renderer.circle_outline(x+w-radius-rad,y+h-radius-rad,r,g,b,a,radius+rounding,0,0.25,1) end
        local FadedRoundedGlow = function(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1) local n=a/255*n;render_rectangle(x+radius,y,w-radius*2,1,r,g,b,n)renderer.circle_outline(x+radius,y+radius,r,g,b,n,radius,180,0.25,1)renderer.circle_outline(x+w-radius,y+radius,r,g,b,n,radius,270,0.25,1)render_rectangle(x,y+radius,1,h-radius*2,r,g,b,n)render_rectangle(x+w-1,y+radius,1,h-radius*2,r,g,b,n)renderer.circle_outline(x+radius,y+h-radius,r,g,b,n,radius,90,0.25,1)renderer.circle_outline(x+w-radius,y+h-radius,r,g,b,n,radius,0,0.25,1)render_rectangle(x+radius,y+h-1,w-radius*2,1,r,g,b,n) for radius=4,glow do local radius=radius/2;OutlineGlow(x-radius,y-radius,w+radius*2,h+radius*2,radius,r1,g1,b1,glow-radius*2)end end
            
        local container_glow = function(x, y, w, h, r, g, b, a, alpha,r1, g1, b1, fn) if alpha*255>0 then renderer.blur(x,y,w,h)end;RoundedRect(x,y,w,h,rounding,17,17,17,a)FadedRoundedGlow(x,y,w,h,rounding,r,g,b,alpha*255,alpha*o,r1,g1,b1)if not fn then return end;fn(x+rounding,y+rounding,w-rounding*2,h-rounding*2.0) end

        
        if ui.get(newfreestand) then

            ui.set(ref.fs_tab[2], "Always on")
            ui.set(ref.fs_tab[1], "Default")
            
        else 
            ui.set(ref.fs_tab[2], "On hotkey")
            ui.set(ref.fs_tab[1], "") 
        end


        
        --clantag
        local durationCT = 10
        local clantag_prev
        

        local clantags = {"_","v","v_","v","vi","vi_","vi0","vi","vi_","vio_","vio","viol_","viol","viole_","viole","violen_","violen","violenc","violenc_","violence","violence","violence","violence","violence","violenc_","violenc","violen_","violen","viole","viol","vio","vi_","_",}
        
        if ui.get(clan_tag)  then
            local cur = math.floor(globals.tickcount() / durationCT) % #clantags
            local clantag = clantags[cur+1]

            if clantag ~= clantag_prev then
                clantag_prev = clantag
                client.set_clan_tag(clantag)
            end
        else 
            client.set_clan_tag(clantag_old)
        end


        --watermark
        local watername = "violence.systems"
        if hour < 10 then hour = "0"..tostring(hour) end
        if minute < 10 then minute = "0"..tostring(minute) end
        if seconds < 10 then seconds = "0"..tostring(seconds) end
        

        local watertext =  us3rname.. " | "..watername.. " build: "..build.." [" ..usergroup.. "] | time: "..hour..":"..minute..":"..seconds


        --Arrows
        local playerxd = entity_get_local_player()
        local alive = is_alive(playerxd)

        if contains(crossind, "Arrows") and playerxd ~= nil and alive then
            renderer_arrow2(center_x, center_y, color_g2[1], color_g2[2], color_g2[3], color_g2[4], (yaw-25) * -1, 35)
            renderer_arrow(center_x, center_y, color_g[1], color_g[2], color_g[3], color_g[4], (yaw -25) * -1, 35)
            
        end

        --Arrows end

        if contains(crossind, "Text") and playerxd ~= nil and alive  then
            renderer.text( center_x-17 , center_y+56, 100, 100, 100, 111,  "cb", 0, "V I O L")
            renderer.text( center_x+20 , center_y+56, 100, 100, 100, 111, "cb", 0, " E N C E")
            renderer.text( center_x-18 , center_y+55, color_g[1], color_g[2], color_g[3], color_g[4], "cb", 0, "V I O L")
            renderer.text( center_x+19 , center_y+55, color_g2[1], color_g2[2], color_g2[3], color_g2[4], "cb", 0, " E N C E")
            
            --hvh
            if ui_get(ref.dt[2]) and luaselection == 1 then
                renderer.text( center_x-22, center_y+65, color_g[1], color_g[2], color_g[3], color_g[4], "-", 0, "DT")
            elseif luaselection == 1 then  
                renderer.text( center_x-22, center_y+65, color_g2[1], color_g2[2], color_g2[3], color_g2[4], "-", 0, "DT")
            end
            
            
            if ui_get(ref.os_aa[1]) and ui_get(ref.os_aa[2]) and luaselection == 1 then
                renderer.text( center_x-7, center_y+65, color_g[1], color_g[2], color_g[3], color_g[4], "-", 0, "OS")
            elseif luaselection == 1 then 
                renderer.text( center_x-7, center_y+65, color_g2[1], color_g2[2], color_g2[3], color_g2[4], "-", 0, "OS")
            end

            if ui_get(newfreestand) and luaselection == 1 then
                renderer.text( center_x+8, center_y+65, color_g[1], color_g[2], color_g[3], color_g[4], "-", 0, "FS")
            elseif luaselection == 1 then 
                renderer.text( center_x+8, center_y+65, color_g2[1], color_g2[2], color_g2[3], color_g2[4], "-", 0, "FS")
            end

            --semirage
            if ui_get(triggerenabled) and ui_get(triggerhotkey) and luaselection == 2 then
                renderer.text( center_x-28, center_y+65, color_g[1], color_g[2], color_g[3], color_g[4], "-", 0, "RAGE")
            elseif luaselection == 2 then  
                renderer.text( center_x-28, center_y+65, color_g2[1], color_g2[2], color_g2[3], color_g2[4], "-", 0, "RAGE")
            end
            
            
            if ui_get(autowallenabled) and ui_get(autowallhotkey) and luaselection == 2 then
                renderer.text( center_x-7, center_y+65, color_g[1], color_g[2], color_g[3], color_g[4], "-", 0, "AWALL")
            elseif luaselection == 2 then  
                renderer.text( center_x-7, center_y+65, color_g2[1], color_g2[2], color_g2[3], color_g2[4], "-", 0, "AWALL")
            end

            if ui_get(newfreestand) and luaselection == 2 then
                renderer.text( center_x+19, center_y+65, color_g[1], color_g[2], color_g[3], color_g[4], "-", 0, "FS")
            elseif luaselection == 2 then 
                renderer.text( center_x+19, center_y+65, color_g2[1], color_g2[2], color_g2[3], color_g2[4], "-", 0, "FS")
            end
            
            

            if state == 5 --[[slow]]then
                renderer.text( center_x-20, center_y+103, c1, c2, c3, 255, "-", 0, "SLOWWALK")
            elseif state == 1 --[[stand]]then
                renderer.text( center_x-20, center_y+103, c1, c2, c3, 255, "-", 0, "STANDING")
            elseif state == 3 --[[air]]then
                renderer.text( center_x-8, center_y+103, c1, c2, c3, 255, "-", 0, "AIR")
            elseif state == 4 --[[duck]]then
                renderer.text( center_x-18, center_y+103, c1, c2, c3, 255, "-", 0, "DUCKING")
            else
                renderer.text( center_x-16, center_y+103, c1, c2, c3, 255, "-", 0, "MOVING")
            end
            
        end
        if contains(crossind, "Watermark") and playerxd ~= nil and alive then
            
                container_glow(cx - renderer.measure_text(nil, watertext) - 15, cy, 49 + renderer.measure_text(nil, watertext), 20, color1, color2, color3, color4, 1.2, color1, color2, color3)

                renderer.text(cx - renderer.measure_text(nil, watertext) - 5, cy + 3, 255, 255, 255, 255, nil, 0, watertext)
            
        end

        if not contains(crossind, "Text") or entity_get_local_player() == nil or not is_alive(entity_get_local_player()) then 
            return 
        end
        
        h_index = 0
        local color_g5 = {ui_get(color0)}
        local color_g6 = {ui_get(color)}
        



        

        if contains(crossind, "Text") then
            local weaponxd = ent_get_player_weapon(playerxd)
            local weapon = ent_get_prop(weaponxd, "m_iItemDefinitionIndex")
            local weapon_name = bombfag7(weapon)
            local weapon_icon = images.get_weapon_icon(weapon)
            local bullet_icon = images.get_panorama_image("icons/ui/bullet_burst.svg")
            local bullet_icon2 = images.get_panorama_image("icons/ui/bullet_burst_outline.svg")
            local bullet_icon3 = images.get_panorama_image("icons/ui/bullet.svg")
            local scrsize_x, scrsize_y = client.screen_size()
            local center_x, center_y = scrsize_x / 2, scrsize_y / 2
            -- Check if our doubletap is fully charged/ready to shoot.
            local nonweapons_c = 
            {
                "CKnife",
                "CHEGrenade",
                "CMolotovGrenade",
                "CIncendiaryGrenade",
                "CFlashbang",
                "CDecoyGrenade",
                "CSmokeGrenade",
                "CWeaponTaser",
                "CC4"
            }
            
            
            
            if playerxd == nil or not alive then 
                return 
            end
            if weapon == nil then 
                return 
            end

            -- Get our weapon & bullet width to dynamically make it smaller/larger without using ghetto hardcoded values when drawing.
            local weapon_w, weapon_h = weapon_icon:measure()
            local bullet_w, bullet_h = bullet_icon:measure()

            -- Flashing/pulsing alpha to indicate a recharge.
            local alpha = math.floor(math.sin(globals.realtime() * 12) * (255/2-1) + 255/2) or 255
            
            -- Get the color of our icons
            -- Check if we have a valid weapon out
            for i=1, #nonweapons_c do
                if weapon_name == nonweapons_c[i] then
                    -- It's fine to return here since the last part of this function is for the bullet icons anyway.
                    return
                end
            end
        
            
        
                
                -- Draw the localplayers current weapon icon.
            weapon_icon:draw(center_x - weapon_w / 6, center_y + 83, weapon_w / 2.5, weapon_h / 2.5, color_g5[1], color_g5[2], color_g5[3], color_g5[4])
        
            
            
        end
    end)




    local hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' }
            
    --logs
    client.set_event_callback("aim_hit", function(e)
                
        local enemies = ent_get_players(true)
        local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
        local name = string.lower(ent_get_player_name(e.target))
        local health = ent_get_prop(e.target, 'm_iHealth')
        local menu_r, menu_b, menu_g, menu_a = ui_get(menu_c)
        local angle = math.floor(ent_get_prop(e.target, "m_flPoseParameter", 11) * 120 - 60 )
        
        if not ui_get(enablelogger) then return end

        if contains(loggername, "Show lua name") then
            android_notify:paint(3, string.format('[violence] Hit '..name.."'s "..hgroup..' for '..e.damage..',  '..health..'hp remaining. Angle: ['..angle..']'))
        else
            android_notify:paint(3, string.format('Hit '..name.."'s "..hgroup..' for '..e.damage..',  '..health..'hp remaining. Angle: ['..angle..']'))
        end
        
    end)

    client.set_event_callback("aim_miss", function(e)
        
        local enemies = ent_get_players(true)
        local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
        local name = string.lower(ent_get_player_name(e.target))
        local health = ent_get_prop(e.target, 'm_iHealth')
        local menu_r, menu_b, menu_g, menu_a = ui_get(menu_c)
        local angle = math.floor(ent_get_prop(e.target, "m_flPoseParameter", 11) * 120 - 60 )
        if ui_get(enablelogger) then 
            
            android_notify:paint(3, string.format('Missed shot at '..name.."'s "..hgroup..' due to '..e.reason..' ,  '..health..'hp remaining. Angle:['..angle..']'))
        
            
        end
        if e.reason ~= "?" then return end
        if not player_memory[e.target] then
            table.insert(player_memory, e.target, {
                misses = misses + 1
            })
        else
            if player_memory[e.target].misses == nil or player_memory[e.target].misses == true or player_memory[e.target].misses == false then player_memory[e.target].misses = 0 end
            player_memory[e.target].misses = player_memory[e.target].misses + 1
        end
    end)
    --logs end




    --trashtalk
    local shittalktable1 = {
        '$name, hehehh hab gut spass für una allle mit und dampf ma jutt ein',
        '$name, bin strassenschlaeger wie zau sas',
        '$name, hab strassen Abitur iss beste',
        '$name, iss der trizep grosser als der bizep? Oda ander herum?',
        '$name, schwoere hast denn Nagel laufen Kopf getroffen',
        'Kippen uhhh musste das da rein klopppen passt schon',
        '$name, Japp cl doena bestw',
        '$name, Passart beste',
        '$name, Wie gehts diir soo haute',
        '$name, Erst ma ne Schoenheita Maske goen hehwh',
        '$name, Sonnst wers ja auch nur ein timmmi',
        '$name, Ne. Beides geld aba der trizeps iss etwas dicker',
        '$name, Lol uch frag sie erst garnicht wer weis wo sie über all schoen wahr uhhhh will ich garnet wisssennnn jetz hab ich schonn son kopfkino vin der sas wie sie dat macht wtf',
        '$name, Geld is schner alles persische schonheiten heheh',
        '$name, Ahhaha jahhhhahahhaha',
        '$name, Geht dat',
        '$name, Kann ich laute finden über skype also deren ip diggi',
        '$name, Kannst du das al Anwendung machen die mann neben wahts app offen iss',
        '$name, Spamen buddda',
        '$name, Topp bester man liwbe gruesse on patte',
        '$name, Lad ma die olllen wixxxa ein Xd',
        '$name, Hahahhaha und ich brauche grass',
        '$name, Gleich dabei mein pc zusammen zu Klopppen',
        '$name, Morgen frueh direkt vielleicht schon',
        '$name, Like a steffi cree',
        '$name, Jor kenn nur die ein paar leute jor hahah',
        '$name, Im Moment chillenn budda ubd geld sammel heheh',
        '$name, Bein bro macht dop',
        '$name, Datt sind mitlaufer haahha',
        '$name, ik stech euch alle ab',
        '$name, Jooo kolowebz alllet',
        '$name, Und ich juttt nit patte unterwegs',
        '$name, hahhah top ahhah',
        '$name, heheheh issso fussball beste',
        '$name, Gohan beste weiste wieso weil er zell geboxst hat lachhh',
        '$name, Pate beste buddda hab siew alllw buddda',
        '$name, Wien Ferrari bin ich buddda',
        '$name, Budda hallo mgf',
        '$name, Klaarr conniii jutt weiber am start',
        '$name, Buddda die sehen auch wie geld Muenzen heheh',
        '$name, B udddda hahah coonnni bestw',
        '$name, Bau arbeiter zzzzhahahah',
        '$name, Breiter als drine mo yo',
        '$name, Soo muss dat whwhhw',
        '$name, Alllles jutttte euch für den kommen den tag yaa',
        '$name, Deine mama zei jahre bei mir in kella',
        '$name, Kannste zigarrre mit puls bekkommen iss dixkkea teil da haste wat zum Dampfen',
        '$name, Kannst auch Zigarren von mir bekommen hand gemacht mad in tostedt und so kannst auch preis bestimmen 20-30-40 euro wurde ann dickkkes ding',
        '$name, Du glaubst net wie mud ich bin glaub immer noch voll drauf',
        '$name, Die typen Mit denn roten jacken sind geferlich munkelt man cree',
        '$name, Bin aba net lol kommma net ma uff soo ne dummme lach',
        '$name, Schreib halt meher geh eh penn oda hahahaha',
        '$name, Auf so ne dumme sach mit. Nen Tecker ralfen berg ruter haun',
        '$name, Isso vorhin richtig. Dickken kloppen drauf gepackt und ich fand das sich die faben veraendert haette lachhhh',
        '$name, klar bin boss untet denn bossawn lagfgel',
        '$name, koka beste habe aus peruanische flex 87% rein',
        '$name, Emm iss ja bet sooo die dickkke auabeute macgt mein sis ja meher lachh',
        '$name, hehehh hab gut spass fuer una allle mit und dampf ma jutt ein',
        '$name, Begleitung muss budda D rauch zwei mit hab nix meher alllet leer :p',
        '$name, Dickkkke is musste maehl drauf machen um wat zu finden lol bei dir',
        '$name, Das doch Schoenes das leben ist ziemlich entstand muss ivh mal soo sagen',
        '$name, Real zieh dich ine mo flax auf mein kawensman',
        '$name, Half. Mir mal was sol ich da eingabenx um aufen ts zu kommwb',
        '$name, Hab dickken kloppen thc harz oda oel. Was das auch iss. Direkt azs Holland D',
        '$name, Du ueberannormalekante wie zau in denn besten zeiten heheh',
        '$name, Nur koka emma und weeed meher net',
        '$name, XD ABA GUT GEMACHT ISSSIE',
        '$name, XD dachte da were allles tote Sehlen um ihn herum rum',
        '$name, Musss mir gleich. Mql die numma von der tuhse geben die das mit trikkky macht dann bommse ich sie richtig. Laff',
        '$name, budda komm ts fier ist auch da nikkko ist auch da alle sind sie da',
        '$name, haare schon brun oda imma noch totrot',
        '$name, digggen neun ps4 kontroler hab ich hwhwh',
        '$name, ich habe auch allle whwhh',
        '$name, massa hack v3 isssea',
        '$name, Machhhe ichh heheh dicksten stein bekommste',
        '$name, Du. Kannnst doch nicht. Einfach so gehen allle am weinen sind sie',
        '$name, Wer geht wtf lafffel lol niemand geht',
        '$name, Schmeckt komisch man denkt als wuerde man fesseln ein artmen und das ids eklig',
        '$name, Kifan garten bb?::: esra?',
        '$name, Nop war da erst ein mal und hab mich dann mit dem wch man angelaegt und dann dann bin ich einfach rein gegangen der typ wollte mir net glauben dat ich ein termin hab',
        '$name, Wie zau fette sau die',
        '$name, Komm dir mit ugor',
        '$name, Lol bin kraassser',
        '$name, BIn strassenschlaeger wie zau sas',
        '$name, Aba die weiber sehen imma krass aus hab noch nie eine polin in duck gesehen',
        '$name, Alle waren imma dunn wie zau',
        '$name, Ja wer ich dann auch machen gt',
        '$name, Hab ja top fach manner hoer am start',
        '$name, Brauch net mal nen trenner hab euch heheheheh',
        '$name, Hab euch 5 bodybilder gleichzeitig amstart heheheh geht duch',
        '$name, Achsoi dann zwei top klaase bodybilder',
        '$name, Sol bei ihn treniren er mein er macht aus mich ne kamofmarschiene',
        '$name, Hahah haben aie dat ding auch mal fertig',
        '$name, Halt miss sein bist auch boss in Tiere?',
        '$name, Hahaha. Wer hats dich gefragt wars der marlon?',
        '$name, Mit denn neuanfang',
        '$name, Wers dat denn loll',
        '$name, Hab strassen Abitur iss beste',
        '$name, Boss in den Geschaeft heheh',
        '$name, Isso hab auch fuss ball 7 Jahre gemacht mussen 1a sein',
        '$name, Iss der trizep grosser als der bizep? Oda ander herum?',
        '$name, Konzentrazonslager wtf',
        '$name, Jap die neur sprwche heist gugonisch',
        '$name, Jap uff 100 schrank gleich doppelt so dick',
        '$name, Ich gerne frueh gute sachen aba uch naehme Zinsen hehehe',
        '$name, Mein name drinne wtf wieso sacghh ma',
        '$name, Fruehsten tu ich',
        '$name, Japp muss mir noch ne neu Grafik karte holen dann die iss irgendwue kaputt gegangen',
        '$name, Dat sind mitlaufer haahha',
        '$name, Bin boss einer ganzen armarder',
        '$name, Hatte ivh letzte wochh da buddda',
        '$name, Sonn ott hab ich hierr bei mir immma',
        '$name, Im Moment chillenn buddda ubd geld sammel heheh',
        '$name, Draussen beste zu bufffen aba wens warm iss Xd',
        '$name, Trotz Weltwirtschaftskrise Laeuft zaehlt die gald marschiere',
        '$name, brauche hilllllfeee internet von mein pc geht jetzt wieder musss nur noch das fix aba ka wie emm da hat wer nen fussball auf mein tastertur fallen lasssen dabei ist ein komische tastenkombie gedruck wurden und jetzt geht f1 f2f3 usw und esc einfg auch net meher kannnnnnn kein menu offfen -,-,-,=((((((',
        '$name, Uuff im bett und Langeweile schieben uff',
        '$name, Uffel nee duu yaayyaA',
        '$name, Zzz ufff deine mama steigt in in ein plantsch Becken mit 5 80Jahre alten sacken und pumpt deren sacke uff',
        '$name, Hab 5laute bei deina mama gehsehen ufff',
        '$name, Em jor uff',
        '$name, Uff uff? Haram pada ohne ende yaa',
        '$name, Scharf zimmma Blick ya bald krieg yAah',
        '$name, Dickkke schieber fresse haste uff',
        '$name, Und warze inner schnauze uffyah',
        '$name, Mad? Dubhahahha',
        '$name, Pisss dich an uff wenn vormir stehst',
        '$name, Vertrocknete haste Pflaume haste hahah',
        '$name, Wtf neher fett wie farid uff',
        '$name, Bitzep wie Bueffel',
        '$name, Habb uff mein PC noch nen paar meher pic von takken ahhah',
        '$name, Luecken texst ufff',
        '$name, Seelhanter uff hat wer die nummma',
        '$name, Grade Frisoer heheh dickken Boxer inner bux',
        '$name, Mach ma ip logger rein wenn dat geht fuer skype und whatsapp bro',
        '$name, Niko patte eifersuechtig wie zau issie',
        '$name, Jooo wat geht bei der bossauraapp heheh',
        '$name, Sieben )) weill drrei uff iss',
        '$name, Grad wach gewwufff dorst wie zau gehabt',
        '$name, Lafff daa kommmt jaa cer mein tages Ablauf ähnlich. Hehehe',
        '$name, ka sonnnast hab ich son 20 am tach geraucht laff',
        '$name, Lafff das ist ein supper geschenkt. Für. Denn nikoo dieee olllen kanaks immmaa ufffharten man machen in Wahrheit gaybiy nr.1',
        '$name, Beste sind die hack für. Die game da ist viel mehwr muhe drinne als in game selber lacch',
        '$name, Trotz Weltwirtschaftskrise Läuft zählt die gald marschiere',
        '$name, Mein Vater is dicke mit denn chaf und mach haram pada mit Fisch und ottt ohne zu rauchen yoo',
        '$name, Is weed eigg cannabis?',
        '$name, Airwaves in yeans hahah',
        '$name, trette din holzbein hahahah',
        '$name, WELCOME TO HELL (◣_◢)'

    }
    local shittalktable2 = {
        'Get violence.systems to support climate change',
        'Breathtaking only at shoppy.gg/@xso',
        '1 NN, Go over to shoppy.gg/@xso for best AA',
        'Get baited walkbot! Owned by violence.systems',
        'Premium quality aa over at shoppy.gg/@xso',
        'Get owned by the King (◣_◢) ',
        'veni vidi vici du hs (◣_◢)',
        'sick kd, nice brain! shoppy.gg/@xso - never get owned again',
        'violence.systems best resolver breaker on the market! (◣_◢)',
        'shitaa.gg/refund.php get violence.systems instead',
        'buy at shoppy.gg/@xso to never get resolved again!',
        '9/10 skeeter reccomend violence.systems',
        'better get your k/d up over at shoppy.gg/@xso',
        'entuncodenz owns you! shoppy.gg/@xso',
        'german enginering over at shoppy.gg/@xso',
        'sit down and take notes, get violence.systems you gypsy',
        'Gypsy owned by violence.systems',
        'Negro jumped on by superior lua over at shoppy.gg/@xso',
        'entuncodenz > ALL'
    }

    local function get_table_length(data)
        if type(data) ~= 'table' then
            return 0
        end
        local count = 0
        for _ in pairs(data) do
            count = count + 1
        end
        return count
    end

    local num_quotes = get_table_length(shittalktable1)
    local num_quotes2 = get_table_length(shittalktable2)



    local client = {
        set_event_callback = client.set_event_callback,
        userid_to_entindex = client.userid_to_entindex,
        exec = client.exec,
        log = client.log
    }


        

    local function on_player_death(event)
        if killsay == "Disabled" then 
            return 
        end
        
        local local_player = entity_get_local_player()
        local attacker = client.userid_to_entindex(event.attacker)
        local victim = client.userid_to_entindex(event.userid)
        
        if local_player == nil or attacker == nil or victim == nil then
            return
        end
        
        if attacker == local_player and victim ~= local_player then
            if ui_get(killsay) == "Violence.systems" then
                local killsaycringe = 'say ' .. shittalktable2[math.random(num_quotes2)]
                killsaycringe = string.gsub(killsaycringe, "$name", ent_get_player_name(victim))
                client.log(killsaycringe)
                client.exec(killsaycringe)
                

            elseif ui_get(killsay) == "izue's shittalk" then
                local killsaycringe = 'say ' .. shittalktable1[math.random(num_quotes)]
                killsaycringe = string.gsub(killsaycringe, "$name", ent_get_player_name(victim))
                client.log(killsaycringe)
                client.exec(killsaycringe)
                
            end
            

        end
        
    end


    client.set_event_callback("player_death", on_player_death)

    --trashtalk end

    --visibility
    client.set_event_callback("paint_ui", function()

        if luaselection == 1 then 
            if ui_get(tabselection) == "Anti-Aim" then
                ui_set_visible(aaselection, true)
                ui_set_visible(ref.pitchref, false)
                ui_set_visible(tabselection, true)
                ui_set_visible(niggerkey, true)
                ui_set_visible(newfreestand, true)
                ui_set_visible(color, false)
                ui_set_visible(color0, false)
                ui_set_visible(colornignog, false)
                ui_set_visible(indclr1, false)
                ui_set_visible(indclr2, false)
                ui_set_visible(indclr3, false)
                ui_set_visible(indclr4, false)
                ui_set_visible(colornignog3, false)
                ui_set_visible(crossind, false)
                ui_set_visible(enablelogger, false)
                ui_set_visible(killsay, false)
                ui_set_visible(clan_tag, false)
                ui_set_visible(loggername, false)
                ui_set_visible(disclaimer6, true)
                ui_set_visible(disclaimer8, false)
                
            elseif ui_get(tabselection) == "Visual" then
                ui_set_visible(niggerkey, false)
                ui_set_visible(tabselection, true)
                ui_set_visible(ref.pitchref, false)
                ui_set_visible(newfreestand, false)
                ui_set_visible(aaselection, false)
                ui_set_visible(color, true)
                ui_set_visible(color0, true)
                ui_set_visible(indclr1, true)
                ui_set_visible(indclr2, true)
                if ui_get(enablelogger) then
                    ui_set_visible(colornignog, true)
                    ui_set_visible(indclr3, true)
                    ui_set_visible(indclr4, true)
                    ui_set_visible(colornignog3, true)
                else
                    ui_set_visible(colornignog, false)
                    ui_set_visible(indclr3, false)
                    ui_set_visible(indclr4, false)
                    ui_set_visible(colornignog3, false)
                end
                ui_set_visible(crossind, true)
                ui_set_visible(enablelogger, true)
                ui_set_visible(killsay, false)
                ui_set_visible(clan_tag, false)
                ui_set_visible(loggername, true)
                ui_set_visible(disclaimer6, false)
                ui_set_visible(disclaimer8, true)
            
            elseif ui_get(tabselection) == "Misc" then
                ui_set_visible(tabselection, true)
                ui_set_visible(enablelogger, false)
                ui_set_visible(niggerkey, false)
                ui_set_visible(aaselection, false)
                ui_set_visible(killsay, true)
                ui_set_visible(clan_tag, true)
                ui_set_visible(ref.pitchref, false)
                ui_set_visible(newfreestand, false)
                ui_set_visible(color, false)
                ui_set_visible(color0, false)
                ui_set_visible(colornignog, false)
                ui_set_visible(indclr1, false)
                ui_set_visible(indclr2, false)
                ui_set_visible(indclr3, false)
                ui_set_visible(indclr4, false)
                ui_set_visible(colornignog3, false)
                ui_set_visible(crossind, false)
                ui_set_visible(loggername, false)
                ui_set_visible(disclaimer6, false)
                ui_set_visible(disclaimer8, false)
            end
            ui_set_visible(ref.fs_tab[1], false)
            ui_set_visible(ref.fs_tab[2], false)
            ui_set_visible(ref.targets,false)
            ui_set_visible(ref.yaw_am[1],false)
            ui_set_visible(ref.yaw_am[2],false)
            ui_set_visible(ref.jyaw[1],false)
            ui_set_visible(ref.jyaw[2],false)
            ui_set_visible(ref.byaw[1],false)
            ui_set_visible(ref.byaw[2],false)
            ui_set_visible(ref.fs_body_yaw,false)
            ui_set_visible(ref.fake_yaw,false)
            ui_set_visible(ref.rollskeet,false)
            ui_set_visible(ref.edge_yaw, false)
            ui_set_visible(disclaimer1, true)
            ui_set_visible(disclaimer2, true)
            ui_set_visible(disclaimer3, true)
            ui_set_visible(disclaimer4, true)
            ui_set_visible(disclaimer5, true)
            ui_set_visible(tabselection2, false)
            ui_set_visible(legitAA, false)
            ui_set_visible(triggerenabled, false)
            ui_set_visible(triggerhotkey, false)
            ui_set_visible(autowallenabled, false)
            ui_set_visible(autowallhotkey, false)
        elseif luaselection == 2 then
            if ui_get(tabselection2) == "Semirage" then
                ui_set_visible(ref.pitchref, false)
                ui_set_visible(legitAA, true)
                ui_set_visible(triggerenabled, true)
                ui_set_visible(triggerhotkey, true)
                ui_set_visible(autowallenabled, true)
                ui_set_visible(autowallhotkey, true)
                ui_set_visible(tabselection2, true)
                if ui.get(legitAA) then
                    ui_set_visible(newfreestand, true)
                else
                    ui_set_visible(newfreestand, false)
                end
                ui_set_visible(color, false)
                ui_set_visible(color0, false)
                ui_set_visible(colornignog, false)
                ui_set_visible(indclr1, false)
                ui_set_visible(indclr2, false)
                ui_set_visible(indclr3, false)
                ui_set_visible(indclr4, false)
                ui_set_visible(colornignog3, false)
                ui_set_visible(crossind, false)
                ui_set_visible(enablelogger, false)
                ui_set_visible(killsay, false)
                ui_set_visible(clan_tag, false)
                ui_set_visible(loggername, false)
            elseif ui_get(tabselection2) == "Visual" then
                ui_set_visible(tabselection2, true)
                ui_set_visible(ref.pitchref, false)
                ui_set_visible(newfreestand, false)
                ui_set_visible(legitAA, false)
                ui_set_visible(triggerenabled, false)
                ui_set_visible(triggerhotkey, false)
                ui_set_visible(autowallenabled, false)
                ui_set_visible(autowallhotkey, false)
                ui_set_visible(color, true)
                ui_set_visible(color0, true)
                ui_set_visible(indclr1, true)
                ui_set_visible(indclr2, true)
                if ui_get(enablelogger) then
                    ui_set_visible(colornignog, true)
                    ui_set_visible(indclr3, true)
                    ui_set_visible(indclr4, true)
                    ui_set_visible(colornignog3, true)
                else
                    ui_set_visible(colornignog, false)
                    ui_set_visible(indclr3, false)
                    ui_set_visible(indclr4, false)
                    ui_set_visible(colornignog3, false)
                end
                ui_set_visible(crossind, true)
                ui_set_visible(enablelogger, true)
                ui_set_visible(killsay, false)
                ui_set_visible(clan_tag, false)
                ui_set_visible(loggername, true)
            
            elseif ui_get(tabselection2) == "Misc" then
                ui_set_visible(tabselection2, true)
                ui_set_visible(legitAA, false)
                ui_set_visible(triggerenabled, false)
                ui_set_visible(triggerhotkey, false)
                ui_set_visible(autowallenabled, false)
                ui_set_visible(autowallhotkey, false)
                ui_set_visible(enablelogger, false)
                ui_set_visible(killsay, true)
                ui_set_visible(clan_tag, true)
                ui_set_visible(ref.pitchref, false)
                ui_set_visible(newfreestand, false)
                ui_set_visible(color, false)
                ui_set_visible(color0, false)
                ui_set_visible(colornignog, false)
                ui_set_visible(indclr1, false)
                ui_set_visible(indclr2, false)
                ui_set_visible(indclr3, false)
                ui_set_visible(indclr4, false)
                ui_set_visible(colornignog3, false)
                ui_set_visible(crossind, false)
                ui_set_visible(loggername, false)
            end
            ui_set_visible(aaselection, false)
            ui_set_visible(ref.pitchref, false)
            ui_set_visible(tabselection, false)
            ui_set_visible(niggerkey, false)
            ui_set_visible(ref.fs_tab[1], false)
            ui_set_visible(ref.fs_tab[2], false)
            ui_set_visible(ref.targets,false)
            ui_set_visible(ref.yaw_am[1],false)
            ui_set_visible(ref.yaw_am[2],false)
            ui_set_visible(ref.jyaw[1],false)
            ui_set_visible(ref.jyaw[2],false)
            ui_set_visible(ref.byaw[1],false)
            ui_set_visible(ref.byaw[2],false)
            ui_set_visible(ref.fs_body_yaw,false)
            ui_set_visible(ref.fake_yaw,false)
            ui_set_visible(ref.rollskeet,false)
            ui_set_visible(ref.edge_yaw, false)
            ui_set_visible(disclaimer1, true)
            ui_set_visible(disclaimer2, true)
            ui_set_visible(disclaimer3, true)
            ui_set_visible(disclaimer4, true)
            ui_set_visible(disclaimer5, true)
        
        else
            ui_set_visible(legitAA, false)
            ui_set_visible(triggerenabled, false)
            ui_set_visible(triggerhotkey, false)
            ui_set_visible(autowallenabled, false)
            ui_set_visible(autowallhotkey, false)
            ui_set_visible(ref.pitchref, false)
            ui_set_visible(tabselection, false)
            ui_set_visible(tabselection2, false)
            ui_set_visible(newfreestand, false)
            ui_set_visible(aaselection, false)
            ui_set_visible(niggerkey, false)
            ui_set_visible(color, false)
            ui_set_visible(color0, false)
            ui_set_visible(colornignog, false)
            ui_set_visible(indclr1, false)
            ui_set_visible(indclr2, false)
            ui_set_visible(indclr3, false)
            ui_set_visible(indclr4, false)
            ui_set_visible(colornignog3, false)
            ui_set_visible(crossind, false)
            ui_set_visible(enablelogger, false)
            ui_set_visible(killsay, false)
            ui_set_visible(clan_tag, false)
            ui_set_visible(loggername, false)
            ui_set_visible(disclaimer6, false)
            ui_set_visible(disclaimer8, false)
            ui_set_visible(ref.aaenabledref, false)
            ui_set_visible(ref.fs_tab[1], false)
            ui_set_visible(ref.fs_tab[2], false)
            ui_set_visible(ref.targets,false)
            ui_set_visible(ref.yaw_am[1],false)
            ui_set_visible(ref.yaw_am[2],false)
            ui_set_visible(ref.jyaw[1],false)
            ui_set_visible(ref.jyaw[2],false)
            ui_set_visible(ref.byaw[1],false)
            ui_set_visible(ref.byaw[2],false)
            ui_set_visible(ref.fs_body_yaw,false)
            ui_set_visible(ref.fake_yaw,false)
            ui_set_visible(ref.rollskeet,false)
            ui_set_visible(ref.edge_yaw, false)
            ui_set_visible(disclaimer1, true)
            ui_set_visible(disclaimer2, true)
            ui_set_visible(disclaimer3, true)
            ui_set_visible(disclaimer4, true)
            ui_set_visible(disclaimer5, true)
            
        end
        
    end)


    client.set_event_callback("round_start", function()
        local menu_r, menu_b, menu_g, menu_a = ui_get(menu_c)
    
        
        right_side = true
        left_side = false
        

        

        local enemies = ent_get_players(true)

        for itter = 1, #enemies do
            local player = enemies[itter]
            if not player_memory[player] then
                table.insert(player_memory, player, {
                    notifilethalwas = false,
                    misses = 0
                })
            end
            player_memory[player].notifilethalwas = false
            player_memory[player].misses = false
        end

        
    end)

    client.set_event_callback("player_connect_full", function()
        local menu_r, menu_b, menu_g, menu_a = ui_get(menu_c)
        
        
        right_side = true
        left_side = false
    

        local enemies = ent_get_players(true)

        for itter = 1, #enemies do
            local player = enemies[itter]
            if not player_memory[player] then
                table.insert(player_memory, player, {
                    notifilethalwas = false,
                    misses = 0
                })
            end
            player_memory[player].notifilethalwas = false
            player_memory[player].misses = false
        end
    end)

    client.set_event_callback("shutdown", function()
        hh, mm, ss, ms = client.system_time()
        ValidSession("Exit", "Lua unloaded.","" ..username)    
        ui_set(ref.targets, "At targets")
        ui_set(ref.yaw_am[1], "180")
        ui_set(ref.yaw_am[2], 0)
        ui_set(ref.jyaw[1], "Off")
        ui_set(ref.jyaw[2], 0)
        ui_set(ref.byaw[1], "Static")
        ui_set(ref.byaw[2], 180)
        ui_set(ref.fs_body_yaw, true)
        ui_set(ref.fake_yaw, 60)
        ui_set(ref.rollskeet, 0)
        ui_set_visible(ref.targets,true)
        ui_set_visible(ref.yaw_am[1],true)
        ui_set_visible(ref.yaw_am[2],true)
        ui_set_visible(ref.jyaw[1],true)
        ui_set_visible(ref.jyaw[2],true)
        ui_set_visible(ref.byaw[1],true)
        ui_set_visible(ref.byaw[2],true)
        ui_set_visible(ref.fs_body_yaw,true)
        ui_set_visible(ref.fake_yaw,true)
        ui_set_visible(ref.rollskeet,true)
        ui_set_visible(ref.enablefl,true)
        ui_set_visible(ref.fl_amount,true)
        ui_set_visible(ref.fl_limit,true)
        ui_set_visible(ref.fl_var,true)
        ui_set_visible(ref.edge_yaw, true)
        ui_set_visible(ref.pitchref, true)
    end)

    local invisibl33 = ui.new_label("AA", "Anti-Aimbot angles", "                      ")
    luaselecthvh = ui.new_button("AA", "Anti-aimbot angles", "Load HVH", loadhvh)
    luaselectsemi = ui.new_button("AA", "Anti-aimbot angles", "Load Semirage", loadsemirage)

    ui_set_visible(ref.fs_tab[1], false)
    ui_set_visible(ref.fs_tab[2], false)
    ui_set_visible(ref.targets,false)
    ui_set_visible(ref.yaw_am[1],false)
    ui_set_visible(ref.yaw_am[2],false)
    ui_set_visible(ref.jyaw[1],false)
    ui_set_visible(ref.jyaw[2],false)
    ui_set_visible(ref.byaw[1],false)
    ui_set_visible(ref.byaw[2],false)
    ui_set_visible(ref.fs_body_yaw,false)
    ui_set_visible(ref.fake_yaw,false)
    ui_set_visible(ref.rollskeet,false)
    ui_set_visible(ref.edge_yaw, false)
    ui_set_visible(disclaimer1, true)
    ui_set_visible(disclaimer2, true)
    ui_set_visible(disclaimer3, true)
    ui_set_visible(disclaimer4, true)
    ui_set_visible(disclaimer5, true)





