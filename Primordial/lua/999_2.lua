--stylez#0798, Саян обновил вам показ ваших биндов. | Саян updated bindlist for you.

local Solus = {
    SaveAlpha = {}, 
    Verdana = render.create_font("Verdana", 12, 24, e_font_flags.ANTIALIAS),
    Vector2 = vec2_t,
    RGBA = color_t,
}

local screensize = render.get_screen_size()


local solus_elements = menu.add_multi_selection("Solus UI", "Solus Elements", {"Keybinds", "Watermark", "Specatators"})
local glow = menu.add_checkbox("Solus UI", "Glow", true)
local glow_start = menu.add_slider("Solus UI", "Glow Start Alpha", 1, 255)
glow_start:set(100)
local glow_end = menu.add_slider("Solus UI", "Glow End Loop", 1, 20)
glow_end:set(5)
local glow_rounding = menu.add_slider("Solus UI", "Glow Rounding", 1, 20)
glow_rounding:set(4) 

local alpha_main = menu.add_slider("Solus UI", "Alpha of boxes", 0, 255)
alpha_main:set(120)

local animation_main = menu.add_slider("Solus UI", "Animation Speed", 5, 50)
animation_main:set(10)

local style_main = menu.add_list("Solus UI", "Solus Style", {"V1", "V2"})

local text = menu.add_text("Solus UI", "Solus Color")
solus_color = text:add_color_picker("Solus Color")

local key_pos_x = menu.add_slider("Solus UI -> Keybinds", "Position X", 0, screensize.x)
key_pos_x:set(400)
local key_pos_y = menu.add_slider("Solus UI -> Keybinds", "Position Y", 0, screensize.y)
key_pos_y:set(500)

local wat_pos_x = menu.add_slider("Solus UI -> Watermark", "Position X", 0, screensize.x)
wat_pos_x:set(1894)
local wat_pos_y = menu.add_slider("Solus UI -> Watermark", "Position Y", 0, screensize.y)
wat_pos_y:set(29)
local wat_text = menu.add_text_input("Solus UI -> Watermark", "Cheat name")
local wat_text1 = menu.add_text_input("Solus UI -> Watermark", "Player name")

local spec_pos_x = menu.add_slider("Solus UI -> Spectators", "Position X", 0, screensize.x)
spec_pos_x:set(800)
local spec_pos_y = menu.add_slider("Solus UI -> Spectators", "Position Y", 0, screensize.y)
spec_pos_y:set(400)

realweapon = 'scout'

function Solus.GetSpectators() 
    local local_player = entity_list.get_local_player_or_spectating()
    local t = {}
    local players = entity_list.get_players()

    if not players then return end

    for i,v in pairs(players) do
        if not v then return end
        if v:is_alive() or v:is_dormant() then return {} end
        local playername = v:get_name()
        if playername == "<blank>" then return {} end
        local observing = entity_list.get_entity(v:get_prop("m_hObserverTarget"))
        if not observing then return {} end
        if observing:get_index() == local_player:get_index() then
            t[#t+1] = {text = playername}
        end
    end
    return t
end

function Solus.GetBinds(active)
    local t = {}
    local _def = {
        {text = 'On shot anti-aim', toggle = menu.find("aimbot", "general", "exploits", "hideshots", "enable")[2]:get()},
        {text = 'Duck peek assist', toggle = menu.find("antiaim", "main", "general", "fake duck", "enable")[2]:get()},
        {text = 'Quick peek assist', toggle = menu.find("aimbot", "general", "misc", "autopeek", "enable")[2]:get()},
        {text = 'Force body aim', toggle = menu.find("aimbot", realweapon, "target overrides", "force hitbox")[2]:get()},
        {text = 'Force safe point', toggle = menu.find("aimbot", realweapon, "target overrides", "force safepoint")[2]:get()},
        {text = 'Damage override', toggle = menu.find("aimbot", realweapon, "target overrides", "force min. damage")[2]:get()},
        {text = 'Double tap', toggle = menu.find("aimbot", "general", "exploits", "doubletap", "enable")[2]:get()},
        {text = 'Freestanding', toggle = menu.find("antiaim","main","auto direction","enable")[2]:get()},
		{text = 'Ping', toggle = menu.find("aimbot","general","fake ping","enable")[2]:get()},
		{text = 'Hitchance override', toggle = menu.find("aimbot", realweapon, "target overrides", "force hitchance")[2]:get()},
		{text = 'Dormant Aimbot', toggle = menu.find("aimbot", "general", "aimbot", "enable")[2]:get()},
		{text = 'Manual : Left', toggle = menu.find("antiaim", "main", "manual", "left")[2]:get()},
		{text = 'Manual : Right', toggle = menu.find("antiaim", "main", "manual", "right")[2]:get()},
		{text = 'AA Invert', toggle = menu.find("antiaim", "main", "manual", "invert desync")[2]:get()},
		{text = 'Nade throw', toggle = menu.find("misc", "utility", "nade helper", "autothrow")[2]:get()},
    }
    if active then 
        for k,v in pairs(_def) do 
            if v.toggle then 
                t[#t+1] = {text = v.text}
            end
        end
    else
        t = _def
    end
    return t
end


function Solus.DrawRect(x, y, w, h, r, g, b, a, rounding,disablefill)
    local hh = not disablefill and render.rect_filled or render.rect
    hh(Solus.Vector2(math.floor(x-w/2),math.floor(y-h/2)), Solus.Vector2(w, h), Solus.RGBA(r, g, b, a), rounding)
end

function Solus.FindLongest(input)
    if type(input)~="table" then
        print("1st parameter must be a table")
        return nil
    end
    local temp={}
    temp[1]=0
    temp[2]=nil
    for a,b in pairs(input) do
        if string.len(input[a].text)>temp[1] then
        temp[1]=string.len(input[a].text)
        temp[2]=a
        end
    end
    if temp[2]==nil then
        return {text = 'xd'}
    else
        return input[temp[2]]
    end
   
end


function Solus.DrawText(text,x,y,font,center,r,g,b,a)
    text = tostring(text)
    if center then 
        render.text(font, text, Solus.Vector2(x,y+5), Solus.RGBA(r,g,b,a),true --[[even if its nil it still makes the text centred so imma keep in this retarded way]])
    else
        render.text(font, text, Solus.Vector2(x,y), Solus.RGBA(r,g,b,a))
    end
end

local r,g,b = solus_color:get().r, solus_color:get().g, solus_color:get().b

function fromTo(val,from,to,alpha)
    local r = math.floor(from.r - (from.r - to.r) * val)
    local g = math.floor(from.g - (from.g - to.g) * val)
    local b = math.floor(from.b - (from.b - to.b) * val)

    return {r = r, g = g, b = b, a = (alpha or 255)}
end

function Solus.Animate(precenteges, start, destination)
    return start+(destination-start)*precenteges
end

local _FINALR, _FINALG, _FINALB = 22, 22, 22

local style = 1 


function Solus.Box(text,x,y,width,alpha)
    if style_main:get() == 2 then 
       
        Solus.DrawRect(x + width / 2,y - 1+0.9,width+4,18,0,0,0,math.floor(alpha/255*alpha_main:get()),4,false)
        if not glow:get() then 

            Solus.DrawRect(x + width / 2 + 1,y - 11,width+1,1,r,g,b,alpha,0,false)
            Solus.DrawRect(x + width / 2+0.5,y + 9,width+1,1,_FINALR, _FINALG, _FINALB,alpha,0,false)

            Solus.DrawRect(x + width + 2,y - 10,1,1,r,g,b,alpha,0,false)
            Solus.DrawRect(x + width + 2,y - 9,1,1,r,g,b,alpha,0,false)


            Solus.DrawRect(x - 2 + 1,y - 10,1,1,r,g,b,alpha,0,false)
            Solus.DrawRect(x - 1 + 1,y - 9,1,1,r,g,b,alpha,0,false)
            for i = 0, 14 do 
                local f = fromTo((i > 12 and 12 or i) / 12, {r = r, g = g, b = b}, { r = _FINALR, g = _FINALG, b = _FINALB}, alpha)
                local _r, _g, _b = f.r, f.g, f.b
                Solus.DrawRect(x - 2 + 1,y - 8 + i,1,1,_r, _g, _b,alpha,0,false)
            end

            f = fromTo(13 / 14, {r = r, g = g, b = b}, { r = _FINALR, g = _FINALG, b = _FINALB}, alpha)
            Solus.DrawRect(x - 1 + 1,y + 8,1,1,f.r,f.g,f.b,alpha,0,false)
            f = fromTo(14 / 14, {r = r, g = g, b = b}, { r = _FINALR, g = _FINALG, b = _FINALB}, alpha)
            Solus.DrawRect(x - 1 + 1,y + 7,1,1,f.r,f.g,f.b,alpha,0,false)

            for i = 0, 14 do 
                local f = fromTo((i > 12 and 12 or i) / 12, {r = r, g = g, b = b}, { r = _FINALR, g = _FINALG, b = _FINALB}, alpha)
                local _r, _g, _b = f.r, f.g, f.b
                Solus.DrawRect(x + width + 2 + 1,y - 8 + i,1,1,_r, _g, _b,alpha,0,false)
            end

            f = fromTo(13 / 14, {r = r, g = g, b = b}, { r = _FINALR, g = _FINALG, b = _FINALB}, alpha)
            Solus.DrawRect(x + width + 1 + 1,y + 8,1,1,f.r,f.g,f.b,alpha,0,false)
            f = fromTo(14 / 14, {r = r, g = g, b = b}, { r = _FINALR, g = _FINALG, b = _FINALB}, alpha)
            Solus.DrawRect(x + width + 1 + 1,y + 7,1,1,f.r,f.g,f.b,alpha,0,false)

         
        end
        Solus.DrawText(text,x + width / 2,y+1 - 7,Solus.Verdana,true,1,1,1,alpha)
        Solus.DrawText(text,x + width / 2,y - 7,Solus.Verdana,true,200,200,200,alpha)
        local start, end_ = glow_start:get(), glow_end:get()

        if glow:get() then 
            for i = 0, end_ do 
                Alpha = math.floor(start - i * (start / end_))
                Solus.DrawRect(x + width / 2,y - 1,width+4 + i * 2 + 1,21 + i * 2,r,g,b,Alpha,glow_rounding:get(),true)
            end
        end
    else
        Solus.DrawRect(x + width / 2,y - 1,width,20,0,0,0,math.floor(alpha/255*alpha_main:get()),0,false)
        Solus.DrawRect(x + width / 2,y - 11,width,2,r,g,b,alpha,0,false)
        Solus.DrawText(text,x + width / 2,y+1 - 7,Solus.Verdana,true,1,1,1,alpha)
        Solus.DrawText(text,x + width / 2,y - 7,Solus.Verdana,true,200,200,200,alpha)

    end
end

local weapons = {
    ["glock"] = {name = 'pistols'},
    ["p250"] = {name = 'pistols'},
    ["cz75a"] = {name = 'pistols'},
    ["usp-s"] = {name = 'pistols'},
    ["tec9"] = {name = 'pistols'},
    ["p2000"] = {name = 'pistols'},
    ["fiveseven"] = {name = 'pistols'},
    ["elite"] = {name = 'pistols'},
    ["scar20"]  = {name = 'auto'},
    ["g3sg1"] = {name = 'auto'},
    ["awp"] = {name = 'awp'},
    ['ssg08'] = {name = 'scout'},
    ['deagle'] = {name = 'deagle'},
    ['revolver'] = {name = 'revolver'},
}  

callbacks.add(e_callbacks.PAINT, function()
    local x,y = wat_pos_x:get(),wat_pos_y:get() 
    local localplayer = entity_list.get_local_player()
    glow_rounding:set_visible(glow:get())
    glow_start:set_visible(glow:get())
    glow_end:set_visible(glow:get())
    if localplayer then 
       

        r,g,b = solus_color:get().r, solus_color:get().g, solus_color:get().b

        if solus_elements:get(2) then 
            local h, m, s = client.get_local_time()
            local text = string.format("%s | %s | %s ms | %s tick | %02d:%02d:%02d", wat_text:get() ~= '' and wat_text:get() or 'primordial.dev', wat_text1:get() ~= '' and wat_text1:get() or user.name, math.floor(engine.get_latency(e_latency_flows.INCOMING)), client.get_tickrate(), h, m, s)
            local wat_width = render.get_text_size(Solus.Verdana, text).x
            Solus.Box(text,x - wat_width ,y,wat_width+10,255)
            if localplayer then 
                actvwep = localplayer:get_active_weapon() 
                if actvwep then 
                    actvwepName = actvwep:get_name() 
                    if actvwepName then 
                        realweapon = weapons[actvwepName] and weapons[actvwepName].name or 'other'
                    else
                        realweapon = 'other'

                    end
                end
            end
        end

        if solus_elements:get(3) then 

            local x,y = spec_pos_x:get(),spec_pos_y:get() 
            local text = Solus.FindLongest(Solus.GetSpectators()) or 'nigga'
            local spec_width_default = render.get_text_size(Solus.Verdana, text.text).x 
            spec_width_default = spec_width_default < 111 and 111 or spec_width_default
            if not spec_width then 
                spec_width = spec_width_default
            end
            spec_width = Solus.Animate(animation_main:get()/100, spec_width, spec_width_default)
            if not spec_alpha then 
                spec_alpha = 0
            end 
            if #Solus.GetSpectators() > 0 then 
                spec_alpha = math.floor(Solus.Animate(animation_main:get()/100, spec_alpha, 255))
            else
                spec_alpha = math.floor(Solus.Animate(animation_main:get()/100, spec_alpha, 0))
            end
            Solus.Box('spectators',x,y,spec_width,spec_alpha)
            if spec_alpha > 0 then 
                for k,v in pairs(Solus.GetSpectators()) do 
                    Solus.DrawText(v.text,x,y + k * 15 + 1,Solus.Verdana,false,1,1,1,255)
                    Solus.DrawText(v.text,x,y + k * 15,Solus.Verdana,false,200,200,200,255)
                
                end
            end
        end
        if solus_elements:get(1) then 
            local x,y = key_pos_x:get(),key_pos_y:get() 
            local text = Solus.FindLongest(Solus.GetBinds(true)) or 'nigga'
            local key_width_default = render.get_text_size(Solus.Verdana, text.text).x + render.get_text_size(Solus.Verdana, '     [toggled]').x
            key_width_default = key_width_default < 111 and 111 or key_width_default
            if not key_width then 
                key_width = key_width_default
            end
            key_width = Solus.Animate(animation_main:get()/100, key_width, key_width_default)

            if not key_alpha then 
                key_alpha = 0
            end
            if #Solus.GetBinds(true) > 0 then 
                key_alpha = math.floor(Solus.Animate(animation_main:get()/100, key_alpha, 255))
            else
                key_alpha = math.floor(Solus.Animate(animation_main:get()/100, key_alpha, 0))
            end
            if key_alpha > 0 then 
                Solus.Box('keybinds',x,y,key_width,key_alpha)

                local loop = 0
                for k,v in pairs(Solus.GetBinds(false)) do 
                    if not Solus.SaveAlpha[v.text..'keybinds'] then 
                        Solus.SaveAlpha[v.text..'keybinds'] = 0 
                    end
                    if v.toggle then 
                        Solus.SaveAlpha[v.text..'keybinds'] = math.floor(Solus.Animate(animation_main:get()/100, Solus.SaveAlpha[v.text..'keybinds'], 255))
                    else
                        Solus.SaveAlpha[v.text..'keybinds'] = math.floor(Solus.Animate(animation_main:get()/100*2, Solus.SaveAlpha[v.text..'keybinds'], 0))
                    end
                    if Solus.SaveAlpha[v.text..'keybinds'] > 0 then 
                        loop = loop + 1
                        Solus.DrawText(v.text,x,y + loop * 15 + 1,Solus.Verdana,false,1,1,1,Solus.SaveAlpha[v.text..'keybinds'])
                        Solus.DrawText(v.text,x,y + loop * 15,Solus.Verdana,false,200,200,200,Solus.SaveAlpha[v.text..'keybinds'])
                        local text_size = render.get_text_size(Solus.Verdana, '[enabled]').x
                        Solus.DrawText('[enabled]',x + key_width - text_size,y + loop * 15 + 1,Solus.Verdana,false,1,1,1,Solus.SaveAlpha[v.text..'keybinds'])
                        Solus.DrawText('[enabled]',x + key_width - text_size,y + loop * 15,Solus.Verdana,false,200,200,200,Solus.SaveAlpha[v.text..'keybinds'])
                    end
                end
            end
        end
    end
end)