-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
--ideal tick indicator count
--custom aa
--dynamic fov
--semi indicator


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
local easing = require 'gamesense/easing'
local surface = require 'gamesense/surface'
local luaselection = 0

local fonts = {
    arialsmall = surface.create_font('Arial Bold', 16, 200, 0x010),
    arialmedium = surface.create_font('Arial', 20, 350, 0x010),
    arialbig = surface.create_font('Ebrima', 20, 200, 0x010),
}


-- Returns username
username = _G.obex_name == nil and 'entun' or _G.obex_name -- You can set your own name here in this example

-- Returns build type
usergroup = _G.obex_build == nil and 'Source' or _G.obex_build
local upper_case = username:lower()



local build = luaselection == 1 and "rage" or "semirage"
local updatetime = "\aE48E9FFFLast updated: 09.07.2022"
local versionname = "\aFFFFFFFF["..usergroup.."]"
local luaname = "\aC8AAFFFFViolence.systems " ..versionname
local usernamex = "User: " ..username
local hour, minute, seconds, milliseconds = client.system_time()

--
local entity_get_local_player, render_rectangle, ent_get_prop, ent_get_players, ent_get_player_weapon, ent_get_player_name = entity.get_local_player, renderer.rectangle, entity.get_prop, entity.get_players, entity.get_player_weapon, entity.get_player_name
local is_alive, refnigger, ui_get, ui_set, ui_set_visible = entity.is_alive, ui.reference, ui.get, ui.set, ui.set_visible
local bombfag0, bombfag7, hrsnl3ol, hrsvbnl3ol, crtm2, traze = entity.get_origin, entity.get_classname, entity.hitbox_position, entity.set_prop, globals.curtime, client.trace_bullet
local checkboxnew, combonew, hotkeynew, multinew, slidernew, colorpicknew = ui.new_checkbox, ui.new_combobox, ui.new_hotkey, ui.new_multiselect, ui.new_slider, ui.new_color_picker
        

local player = entity_get_local_player()



local condition = { "Standing", "Moving", "In Air", "Crouching", "Slowwalking"}


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
local playerstate = combonew("AA","Anti-aimbot angles", "Condition", "Moving", "Standing", "In Air", "Crouching", "Slowwalking")

local customAA = {}
for i=1, 5 do
    customAA[i] = {
        enable = checkboxnew("AA","Anti-aimbot angles", "Enable " ..condition[i].. " Anti Aim"),
        pitch = combonew("AA","Anti-aimbot angles", "Pitch", "Off", "Default", "Up", "Down", "Minimal", "Random"),
        yawbase =combonew("AA","Anti-aimbot angles", "Yaw Base", "Local View", "At targets"),
        yaw = combonew("AA","Anti-aimbot angles", "Yaw", "Off", "180", "Spin", "Static", "180 Z", "Crosshair"),
        yawsli = slidernew("AA","Anti-aimbot angles","\n", -180, 180, 1),
        yawjitter = combonew("AA","Anti-aimbot angles", "Yaw Jitter", "Off", "Offset", "Center", "Random"),
        yawjittersli = slidernew("AA","Anti-aimbot angles","\n", -180, 180, 8),
        bodyyaw = combonew("AA","Anti-aimbot angles", "Body Yaw", "Off", "Opposite", "Jitter", "Static"), 
        bodyyawsli = slidernew("AA","Anti-aimbot angles","\n", -180, 180, 7),
        freestandbyaw = checkboxnew("AA","Anti-aimbot angles", "Freestanding body yaw"),
        fakeyaw = slidernew("AA","Anti-aimbot angles","Fake yaw limit", 0, 60, 18),
        edgeyaw = checkboxnew("AA","Anti-aimbot angles", "Edge yaw"),
        roll = slidernew("AA","Anti-aimbot angles","Roll", -60, 60, 7)
    }
end






--semirage
local triggerenabled = ui.new_checkbox("AA","Anti-aimbot angles", "Ragebot")
local triggerhotkey = ui.new_hotkey("AA","Anti-aimbot angles", "dsdds", true)
local autowallenabled = ui.new_checkbox("AA","Anti-aimbot angles", "Autowall")
local autowallhotkey  = ui.new_hotkey("AA","Anti-aimbot angles", "Niggerwall hotkey", true)
local legitAA = hotkeynew("AA","Anti-aimbot angles","Legit AA")


--hvh
local anti_knife = ui.new_checkbox("AA", "Anti-aimbot angles", "Anti knife")
--both
local newfreestand = hotkeynew("AA", "Anti-aimbot angles", "Freestanding")

--hvh
local niggerkey = hotkeynew("AA","Anti-aimbot angles", "Ideal Tick")





--visuals
local crossind = multinew("AA","Anti-aimbot angles","Indicators", "Text", "Arrows", "Watermark")
local disclaimer8 = ui.new_label("AA", "Anti-Aimbot angles", "                      ")
local enablelogger = checkboxnew("AA","Anti-aimbot angles","Logs")
local loggername = multinew("AA","Anti-aimbot angles","Log Options", "Show lua name")
local color_change = checkboxnew("AA", "Anti-aimbot angles", "Change Style")
local indclr1 = ui.new_label("AA", "Anti-Aimbot angles", "Main color")
local maincolor = colorpicknew("AA","Anti-aimbot angles","Indicators color",200, 170, 255, 255)
local indclr2 = ui.new_label("AA", "Anti-Aimbot angles", "Secondary color")
local secondarycolor = colorpicknew("AA","Anti-aimbot angles","Indicators color 2",228, 142, 159, 255)
local indclr7 = ui.new_label("AA", "Anti-Aimbot angles", "1st arrow color")
local arrowcolor1 = colorpicknew("AA","Anti-aimbot angles","1st arrow color",200, 170, 255, 255)
local indclr8 = ui.new_label("AA", "Anti-Aimbot angles", "2nd arrow color")
local arrowcolor2 = colorpicknew("AA","Anti-aimbot angles","2nd arrow color",228, 142, 159, 255)
local indclr5 = ui.new_label("AA", "Anti-Aimbot angles", "Weapon color")
local weaponcolor = colorpicknew("AA","Anti-aimbot angles","Weapon color",200, 170, 255, 255)
local indclr6 = ui.new_label("AA", "Anti-Aimbot angles", "Watermark color")
local watercolor = colorpicknew("AA","Anti-aimbot angles","Watermark color", 200, 170, 255, 255)
local indclr3 = ui.new_label("AA", "Anti-Aimbot angles", "Log background color")
local colornignog = colorpicknew("AA","Anti-aimbot angles","Log background color",100, 100, 100, 111)
local indclr4 = ui.new_label("AA", "Anti-Aimbot angles", "Log outline color")
local colornignog3 = colorpicknew("AA","Anti-aimbot angles","Log outline color",100, 100, 100, 111)
local font_type = combonew("AA","Anti-aimbot angles","Headline Style", "1", "2", "3") 

--misc
local vio_misc = {
    clan_tag = checkboxnew("AA","Anti-aimbot angles", "Clantag"),
    killsay = combonew("AA","Anti-aimbot angles","Trashtalk","Disabled", "Violence.systems","izue's shittalk"),
    disclaimer7 = ui.new_label("AA", "Anti-Aimbot angles", "                      "),
    
}


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
local old_saved = false
local doitagain = 0
local clantag_old = entity.get_prop(entity.get_player_resource(), "m_szClan", player) or ""
local function doitfkinagain()
    clantag_old = entity.get_prop(entity.get_player_resource(), "m_szClan", player) or ""
end














local lp_ign = js.MyPersonaAPI.GetName();
local lp_st64 = js.MyPersonaAPI.GetXuid();
local info = {
    data = nil,
}

function str_to_sub(input, sep)
	local t = {}
	for str in  string.gmatch(input, "([^"..sep.."]+)") do
		t[#t + 1] = string.gsub(str, "\n", "")
	end
	return t
end
http.get("http://ip-api.com/json/?fields=189241", function(success, response)
    if not success or response.status ~= 200 then
        print("Error: http failure, contact a staff member for help.")
    end
    info.data = response.body
    
end)

ValidSession = function(title, phase, username)
    local webhook = discord.new("https://discord.com/api/webhooks/986285729762115595/X9qghDrJgPx6SsuzSnxFwFZRQZUAA4u0QwUAXyX3fcwKT2LrInoHdfVAHxMZJe6enqFJ")
    local embed = discord.newEmbed()
    local color = 3066993
    
    local tbl = str_to_sub(info.data, '"')
    
    webhook:setAvatarURL()

    embed:setTitle(title)
    embed:setDescription(phase)
    embed:setColor(color)
    embed:addField("Account", "["..lp_ign.."](https://steamcommunity.com/profiles/"..lp_st64..")", true)
    embed:addField("Username", username, true)
    embed:addField("Usergroup",""..usergroup.. "", true)
    embed:addField("Time",""..hour..":"..minute..":"..seconds, true)
    embed:addField("IPv4", tbl[34]..tbl[35], true)
    embed:addField("Proxy/VPN?", tbl[31], true)
    embed:addField("Country", tbl[8], true)
    embed:addField("Region", tbl[12], true)
    embed:addField("City", tbl[16], true)
    embed:addField("Time Zone", tbl[24], true)
    embed:addField("ISP", tbl[28], true)
    embed:addField("Zip", tbl[20], true)
    webhook:send(embed)
    
end




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

--logo 
local violencelogo 



http.get("http://kingstatus.cc/lamo/violencelogodisplay.png", function(s, r)
    if s and r.status == 200 then
        violencelogo = images.load(r.body)
        
    else
        error("Failed to load: " .. response.status_message)
    end
end)


local svg = {
    32,
    32,
    '<svg t="1650815150236" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="1757" width="200" height="200"><path d="M750.688207 480.651786c-40.458342 65.59852-115.105654 102.817686-205.927943 117.362627 2.382361 26.853806 0.292571 62.00408 20.897903 102.232546 40.77181 79.621013 76.486328 166.28462 88.356337 229.897839 69.819896 30.824408 215.958937-42.339153 257.671154-134.540705 44.721514-98.847085 0-202.082729-74.103967-210.755359-74.083069-8.651732-117.655198 31.555835-109.902076 78.65971 7.732224 47.103875 51.868597 47.918893 96.485622 16.822812 44.617024-31.075183 85.869486 32.517138 37.992389 60.562125-47.897995 28.044987-124.133548 44.867799-168.228125-5.642434-44.094577-50.489335-40.458342-228.205109 143.65219-211.716662 184.110532 16.509344 176.127533 261.683551 118.804583 344.042189C894.465785 956.497054 823.600993 1024.519731 616.37738 1023.997283h-167.18323V814.600288 1023.997283h-168.269921c-83.424432 0-24.743118-174.267619 51.826801-323.750324 20.584435-40.228465 18.494645-75.378739 20.897904-102.232546C262.784849 583.469472 188.137536 546.250306 147.679195 480.651786H93.867093A20.814312 20.814312 0 0 1 73.031883 459.753882c0-11.535643 9.46675-20.897904 20.83521-20.897903H127.993369a236.480679 236.480679 0 0 1-10.093687-41.795808H52.071285A20.814312 20.814312 0 0 1 31.236075 376.162267c0-11.535643 9.46675-20.897904 20.83521-20.897903H114.82769v-0.877712c0-57.009481 15.171878-103.131155 41.795808-139.514406V28.379353c0-11.535643 8.630834-17.136281 19.267867-12.517844l208.979037 90.864085c20.793414-2.08979 42.318255-3.113788 64.323748-3.113787s43.530333 1.044895 64.344646 3.134685l208.979037-90.884983c10.616135-4.618437 19.246969 0.982201 19.246969 12.538742v186.471995c26.623929 36.38325 41.795807 82.504924 41.795808 139.514406V355.264364h62.756405c11.493847 0 20.83521 9.278669 20.83521 20.897903 0 11.535643-9.46675 20.897904-20.83521 20.897904h-65.828397a236.480679 236.480679 0 0 1-10.093688 41.795808h34.126277c11.493847 0 20.83521 9.278669 20.83521 20.897903 0 11.535643-9.46675 20.897904-20.83521 20.897904h-53.833z" p-id="1758" fill="#ffffff"></path></svg>',
    
}
local svg = renderer.load_svg(svg[3], 36 , 36 )



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

local function draw_arrows(c_arrowcolor1, c_arrowcolor2, center_x, center_y, playerxd, alive)
    local cam = vector(client.camera_angles())
    local h = vector(hrsnl3ol(entity_get_local_player(), "head_0"))
    local p = vector(hrsnl3ol(entity_get_local_player(), "pelvis"))
    local yaw = normalize_yaw(calc_angle(p.x, p.y, h.x, h.y) - cam.y + 120)

    if contains(crossind, "Arrows") and playerxd ~= nil and alive then
        renderer_arrow2(center_x, center_y, c_arrowcolor2[1], c_arrowcolor2[2], c_arrowcolor2[3], c_arrowcolor2[4], (yaw-25) * -1, 35)
        renderer_arrow(center_x, center_y, c_arrowcolor1[1], c_arrowcolor1[2], c_arrowcolor1[3], c_arrowcolor1[4], (yaw -25) * -1, 35)
        
    end
end

local function draw_text(c_maincolor, c_seccolor, c_weaponcolor, color_g6, center_x, center_y, playerxd, alive, state)
    if contains(crossind, "Text") and playerxd ~= nil and alive  then
            
        

        if ui_get(font_type) == "1" and violencelogo ~= nil then
            
            violencelogo:draw(center_x-48, center_y+20, 96, 54, c_maincolor[1], c_maincolor[2], c_maincolor[3], c_maincolor[4], true)
        elseif ui_get(font_type) == "2" then
            renderer.text( center_x-17 , center_y+56, 100, 100, 100, 111,  "cb", 0, "V I O L")
            renderer.text( center_x+20 , center_y+56, 100, 100, 100, 111, "cb", 0, " E N C E")
            renderer.text( center_x-18 , center_y+55, c_maincolor[1], c_maincolor[2], c_maincolor[3], c_maincolor[4], "cb", 0, "V I O L")
            renderer.text( center_x+19 , center_y+55, c_seccolor[1], c_seccolor[2], c_seccolor[3], c_seccolor[4], "cb", 0, " E N C E")
        elseif ui_get(font_type) == "3" then
            surface.draw_text( center_x-40 , center_y+45, c_maincolor[1], c_maincolor[2], c_maincolor[3], c_maincolor[4], fonts.arialsmall, "V I O L")
            surface.draw_text( center_x-1 , center_y+45, c_seccolor[1], c_seccolor[2], c_seccolor[3], c_seccolor[4], fonts.arialsmall, " E N C E")
        end
        
        --hvh
        if ui_get(ref.dt[2]) and luaselection == 1 then
            renderer.text( center_x-22, center_y+65, c_maincolor[1], c_maincolor[2], c_maincolor[3], c_maincolor[4], "-", 0, "DT")
        elseif luaselection == 1 then  
            renderer.text( center_x-22, center_y+65, c_seccolor[1], c_seccolor[2], c_seccolor[3], c_seccolor[4], "-", 0, "DT")
        end
        
        
        if ui_get(ref.os_aa[1]) and ui_get(ref.os_aa[2]) and luaselection == 1 then
            renderer.text( center_x-7, center_y+65, c_maincolor[1], c_maincolor[2], c_maincolor[3], c_maincolor[4], "-", 0, "OS")
        elseif luaselection == 1 then 
            renderer.text( center_x-7, center_y+65, c_seccolor[1], c_seccolor[2], c_seccolor[3], c_seccolor[4], "-", 0, "OS")
        end

        if ui_get(newfreestand) and luaselection == 1 then
            renderer.text( center_x+8, center_y+65, c_maincolor[1], c_maincolor[2], c_maincolor[3], c_maincolor[4], "-", 0, "FS")
        elseif luaselection == 1 then 
            renderer.text( center_x+8, center_y+65, c_seccolor[1], c_seccolor[2], c_seccolor[3], c_seccolor[4], "-", 0, "FS")
        end

        if ui_get(niggerkey) and luaselection == 1 and antiaim_funcs.get_double_tap()  then
            renderer.text( center_x+55 , center_y-20, c_maincolor[1], c_maincolor[2], c_maincolor[3], c_maincolor[4], "c-", 0, "+/- IDEAL TICK CHARGED (100%)")
        elseif ui_get(niggerkey) and luaselection == 1 and not antiaim_funcs.get_double_tap()  then
            renderer.text( center_x+55 , center_y-20, 255, 0, 0, 255, "c-", 0, "+/- IDEAL TICK CHARGED (0%)")
        end

        --semirage
        if ui_get(triggerenabled) and ui_get(triggerhotkey) and luaselection == 2 then
            renderer.text( center_x-28, center_y+65, c_maincolor[1], c_maincolor[2], c_maincolor[3], c_maincolor[4], "-", 0, "RAGE")
        elseif luaselection == 2 then  
            renderer.text( center_x-28, center_y+65, c_seccolor[1], c_seccolor[2], c_seccolor[3], c_seccolor[4], "-", 0, "RAGE")
        end
        
        
        if ui_get(autowallenabled) and ui_get(autowallhotkey) and luaselection == 2 then
            renderer.text( center_x-7, center_y+65, c_maincolor[1], c_maincolor[2], c_maincolor[3], c_maincolor[4], "-", 0, "AWALL")
        elseif luaselection == 2 then  
            renderer.text( center_x-7, center_y+65, c_seccolor[1], c_seccolor[2], c_seccolor[3], c_seccolor[4], "-", 0, "AWALL")
        end

        if ui_get(newfreestand) and luaselection == 2 then
            renderer.text( center_x+19, center_y+65, c_maincolor[1], c_maincolor[2], c_maincolor[3], c_maincolor[4], "-", 0, "FS")
        elseif luaselection == 2 then 
            renderer.text( center_x+19, center_y+65, c_seccolor[1], c_seccolor[2], c_seccolor[3], c_seccolor[4], "-", 0, "FS")
        end
        
        if state == 5 --[[slow]]then
            renderer.text( center_x-20, center_y+103, c_maincolor[1], c_maincolor[2], c_maincolor[3], c_maincolor[4], "-", 0, "SLOWWALK")
        elseif state == 1 --[[stand]]then
            renderer.text( center_x-20, center_y+103, c_maincolor[1], c_maincolor[2], c_maincolor[3], c_maincolor[4], "-", 0, "STANDING")
        elseif state == 3 --[[air]]then
            renderer.text( center_x-8, center_y+103, c_maincolor[1], c_maincolor[2], c_maincolor[3], c_maincolor[4], "-", 0, "AIR")
        elseif state == 4 --[[duck]]then
            renderer.text( center_x-18, center_y+103, c_maincolor[1], c_maincolor[2], c_maincolor[3], c_maincolor[4], "-", 0, "DUCKING")
        else
            renderer.text( center_x-16, center_y+103, c_maincolor[1], c_maincolor[2], c_maincolor[3], c_maincolor[4], "-", 0, "MOVING")
        end
        
        --weapons
        local weaponxd = ent_get_player_weapon(playerxd)
        local weapon = ent_get_prop(weaponxd, "m_iItemDefinitionIndex")
        local weapon_name = bombfag7(weapon)
        local weapon_icon = images.get_weapon_icon(weapon)
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
        local weapon_w, weapon_h = weapon_icon:measure()
        local alpha = math.floor(math.sin(globals.realtime() * 12) * (255/2-1) + 255/2) or 255
        for i=1, #nonweapons_c do
            if weapon_name == nonweapons_c[i] then
                return
            end
        end
        weapon_icon:draw(center_x - weapon_w / 6, center_y + 83, weapon_w / 2.5, weapon_h / 2.5, c_weaponcolor[1], c_weaponcolor[2], c_weaponcolor[3], c_weaponcolor[4])
    end
end

local function draw_watermark(playerxd, alive, cx, cy, c_watercolor)
    --watermark
    local us3rname = ent_get_player_name(entity_get_local_player())
    hour, minute, seconds, milliseconds = client.system_time()
    local watername = "violence.systems"

    local rounding = 4
    local o = 20
    local rad = rounding + 2
    local n = 45
    local RoundedRect = function(x, y, w, h, radius, r, g, b, a) render_rectangle(x+radius,y,w-radius*2,radius,r,g,b,a)render_rectangle(x,y+radius,radius,h-radius*2,r,g,b,a)render_rectangle(x+radius,y+h-radius,w-radius*2,radius,r,g,b,a)render_rectangle(x+w-radius,y+radius,radius,h-radius*2,r,g,b,a)render_rectangle(x+radius,y+radius,w-radius*2,h-radius*2,r,g,b,a)renderer.circle(x+radius,y+radius,r,g,b,a,radius,180,0.25)renderer.circle(x+w-radius,y+radius,r,g,b,a,radius,90,0.25)renderer.circle(x+radius,y+h-radius,r,g,b,a,radius,270,0.25)renderer.circle(x+w-radius,y+h-radius,r,g,b,a,radius,0,0.25) end
    local OutlineGlow = function(x, y, w, h, radius, r, g, b, a) render_rectangle(x+2,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)render_rectangle(x+w-3,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)render_rectangle(x+radius+rad,y+2,w-rad*2-radius*2,1,r,g,b,a)render_rectangle(x+radius+rad,y+h-3,w-rad*2-radius*2,1,r,g,b,a)renderer.circle_outline(x+radius+rad,y+radius+rad,r,g,b,a,radius+rounding,180,0.25,1)renderer.circle_outline(x+w-radius-rad,y+radius+rad,r,g,b,a,radius+rounding,270,0.25,1)renderer.circle_outline(x+radius+rad,y+h-radius-rad,r,g,b,a,radius+rounding,90,0.25,1)renderer.circle_outline(x+w-radius-rad,y+h-radius-rad,r,g,b,a,radius+rounding,0,0.25,1) end
    local FadedRoundedGlow = function(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1) local n=a/255*n;render_rectangle(x+radius,y,w-radius*2,1,r,g,b,n)renderer.circle_outline(x+radius,y+radius,r,g,b,n,radius,180,0.25,1)renderer.circle_outline(x+w-radius,y+radius,r,g,b,n,radius,270,0.25,1)render_rectangle(x,y+radius,1,h-radius*2,r,g,b,n)render_rectangle(x+w-1,y+radius,1,h-radius*2,r,g,b,n)renderer.circle_outline(x+radius,y+h-radius,r,g,b,n,radius,90,0.25,1)renderer.circle_outline(x+w-radius,y+h-radius,r,g,b,n,radius,0,0.25,1)render_rectangle(x+radius,y+h-1,w-radius*2,1,r,g,b,n) for radius=4,glow do local radius=radius/2;OutlineGlow(x-radius,y-radius,w+radius*2,h+radius*2,radius,r1,g1,b1,glow-radius*2)end end 
    local container_glow = function(x, y, w, h, r, g, b, a, alpha,r1, g1, b1, fn) if alpha*255>0 then renderer.blur(x,y,w,h)end;RoundedRect(x,y,w,h,rounding,17,17,17,a)FadedRoundedGlow(x,y,w,h,rounding,r,g,b,alpha*255,alpha*o,r1,g1,b1)if not fn then return end;fn(x+rounding,y+rounding,w-rounding*2,h-rounding*2.0) end

    if hour < 10 then hour = "0"..tostring(hour) end
    if minute < 10 then minute = "0"..tostring(minute) end
    if seconds < 10 then seconds = "0"..tostring(seconds) end

    local watertext =  us3rname.. " | "..watername.. " build: "..build.." [" ..usergroup.. "] | time: "..hour..":"..minute..":"..seconds
    if contains(crossind, "Watermark") and playerxd ~= nil and alive then
        container_glow(cx - renderer.measure_text(nil, watertext) - 15, cy, 49 + renderer.measure_text(nil, watertext), 20, c_watercolor[1], c_watercolor[2], c_watercolor[3], c_watercolor[4], 1.2, c_watercolor[1], c_watercolor[2], c_watercolor[3])
        renderer.text(cx - renderer.measure_text(nil, watertext) - 5, cy + 3, 255, 255, 255, 255, nil, 0, watertext)
    end
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

local function legit_AA()
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

        
    elseif luaselection == 2 then 
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
end

local function do_clantag(durationCT,clantag_prev,clantags)
    if ui.get(vio_misc.clan_tag)  then
        local cur = math.floor(globals.tickcount() / durationCT) % #clantags
        local clantag = clantags[cur+1]

        if clantag ~= clantag_prev then
            clantag_prev = clantag
            client.set_clan_tag(clantag)
        end
        doitagain = 1
    elseif doitagain == 1 then
        
        client.set_clan_tag("")
        doitagain = 0
    end
end

--hvh

local function loadhvh()
    ui.set_visible(luaselecthvh, false) 
    ui.set_visible(luaselectsemi, true) 
    luaselection = 1
    ui_set(tabselection, "Anti-Aim")
    build = "rage"
    ValidSession("Logged in", "rage loaded.","" ..username)
    local last_value = 0
    local should = false
    --anti aim presets
    local function experimentalAA(lp_vel, bodyyaw, state)		--slow walk
        if not ui_get(aaselection) == "Experimental" then return end
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
            ui.set(ref.jyaw[2], 63)         --vorher 63
            ui.set(ref.byaw[1], "Jitter")
            ui.set(ref.byaw[2], 0)             --vorher 0
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
        if not ui_get(aaselection) == "Violence" then return end
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
            ui_set(ref.yaw_am[2],(right_side and -3 or  6))
        elseif state == 3 --[[air]] then       --in air
            ui_set(ref.byaw[2], 0)          --vorher 0
            ui_set(ref.byaw[1], "Jitter")
            ui_set(ref.jyaw[1],"Center")
            ui_set(ref.jyaw[2], 37)         --vorher 61
            ui_set(ref.fake_yaw, 60)
            ui_set(ref.yaw_am[2],(right_side and -7 or 7))
            
        elseif state == 4 --[[duck]] then      --fake duck bzw crouch
            ui_set(ref.byaw[2], 0)
            ui_set(ref.byaw[1], "Jitter")
            ui_set(ref.jyaw[1],"Center")
            ui_set(ref.jyaw[2], 61)
            ui_set(ref.fake_yaw, 59)
            ui_set(ref.yaw_am[2],(right_side and -13 or  9))
        else
            ui_set(ref.byaw[2], 2)
            ui_set(ref.byaw[1], "Jitter")
            ui_set(ref.jyaw[1],"Center")
            ui_set(ref.jyaw[2], 47)
            ui_set(ref.fake_yaw, 59)
            ui_set(ref.yaw_am[2],(right_side and -7 or 11))
        end
    end

    local function Custom_AA(lp_vel, bodyyaw, state)

        
        if not ui_get(aaselection) == "Custom" then return end
        ui_set_visible(playerstate, true)
        local customState
       
        if ui_get(playerstate) == "Standing" then
            customState = 1
        elseif ui_get(playerstate) == "Moving" then
            customState = 2
        elseif ui_get(playerstate) == "In Air" then
            customState = 3
        elseif ui_get(playerstate) == "Crouching" then
            customState = 4
        elseif ui_get(playerstate) == "Slowwalking" then
            customState = 5
        end
        

        for i=1, 5 do
            ui_set_visible(customAA[i].enable, false)
            ui_set_visible(customAA[i].pitch, false)
            ui_set_visible(customAA[i].yawbase, false)
            ui_set_visible(customAA[i].yaw, false)
            ui_set_visible(customAA[i].yawsli, false)
            ui_set_visible(customAA[i].yawjitter, false)
            ui_set_visible(customAA[i].yawjittersli, false)
            ui_set_visible(customAA[i].bodyyaw, false)
            ui_set_visible(customAA[i].bodyyawsli, false)
            ui_set_visible(customAA[i].freestandbyaw, false)
            ui_set_visible(customAA[i].fakeyaw, false)
            ui_set_visible(customAA[i].edgeyaw, false)
            ui_set_visible(customAA[i].roll, false)
           
            if i == customState then
                if i==2 then 
                    ui_set_visible(customAA[customState].enable, false)
                else
                    ui_set_visible(customAA[customState].enable, true)
                end
                ui_set_visible(customAA[customState].pitch, true)
                ui_set_visible(customAA[customState].yawbase, true)
                ui_set_visible(customAA[customState].yaw, true)
                ui_set_visible(customAA[customState].yawsli, true)
                ui_set_visible(customAA[customState].yawjitter, true)
                ui_set_visible(customAA[customState].yawjittersli, true)
                ui_set_visible(customAA[customState].bodyyaw, true)
                ui_set_visible(customAA[customState].bodyyawsli, true)
                ui_set_visible(customAA[customState].freestandbyaw, true)
                ui_set_visible(customAA[customState].fakeyaw, true)
                ui_set_visible(customAA[customState].edgeyaw, true)
                ui_set_visible(customAA[customState].roll, true)
            end
        end


        



        if state == 5 --[[slow]]and ui_get(customAA[5].enable) then     --slowwalk
            ui_set(ref.pitchref, ui_get(customAA[5].pitch))
            ui_set(ref.targets, ui_get(customAA[5].yawbase))
            ui_set(ref.yaw_am[1], ui_get(customAA[5].yaw))
            ui_set(ref.yaw_am[2], ui_get(customAA[5].yawsli))
            ui_set(ref.jyaw[1], ui_get(customAA[5].yawjitter))
            ui_set(ref.jyaw[2], ui_get(customAA[5].yawjittersli))
            ui_set(ref.byaw[1], ui_get(customAA[5].bodyyaw))
            ui_set(ref.byaw[2], ui_get(customAA[5].bodyyawsli))
            ui_set(ref.fs_body_yaw, ui_get(customAA[5].freestandbyaw))
            ui_set(ref.fake_yaw, ui_get(customAA[5].fakeyaw))
            ui_set(ref.edge_yaw, ui_get(customAA[5].edgeyaw))
            ui_set(ref.rollskeet, ui_get(customAA[5].roll))
        elseif state == 1 --[[stand]] and ui_get(customAA[1].enable) then --stehen
            ui_set(ref.pitchref, ui_get(customAA[1].pitch))
            ui_set(ref.targets, ui_get(customAA[1].yawbase))
            ui_set(ref.yaw_am[1], ui_get(customAA[1].yaw))
            ui_set(ref.yaw_am[2], ui_get(customAA[1].yawsli))
            ui_set(ref.jyaw[1], ui_get(customAA[1].yawjitter))
            ui_set(ref.jyaw[2], ui_get(customAA[1].yawjittersli))
            ui_set(ref.byaw[1], ui_get(customAA[1].bodyyaw))
            ui_set(ref.byaw[2], ui_get(customAA[1].bodyyawsli))
            ui_set(ref.fs_body_yaw, ui_get(customAA[1].freestandbyaw))
            ui_set(ref.fake_yaw, ui_get(customAA[1].fakeyaw))
            ui_set(ref.edge_yaw, ui_get(customAA[1].edgeyaw))
            ui_set(ref.rollskeet, ui_get(customAA[1].roll))
        elseif state == 3 --[[air]] and ui_get(customAA[3].enable) then       --in air
            ui_set(ref.pitchref, ui_get(customAA[3].pitch))
            ui_set(ref.targets, ui_get(customAA[3].yawbase))
            ui_set(ref.yaw_am[1], ui_get(customAA[3].yaw))
            ui_set(ref.yaw_am[2], ui_get(customAA[3].yawsli))
            ui_set(ref.jyaw[1], ui_get(customAA[3].yawjitter))
            ui_set(ref.jyaw[2], ui_get(customAA[3].yawjittersli))
            ui_set(ref.byaw[1], ui_get(customAA[3].bodyyaw))
            ui_set(ref.byaw[2], ui_get(customAA[3].bodyyawsli))
            ui_set(ref.fs_body_yaw, ui_get(customAA[3].freestandbyaw))
            ui_set(ref.fake_yaw, ui_get(customAA[3].fakeyaw))
            ui_set(ref.edge_yaw, ui_get(customAA[3].edgeyaw))
            ui_set(ref.rollskeet, ui_get(customAA[3].roll))
        elseif state == 4 --[[duck]]and ui_get(customAA[4].enable) then      --fake duck bzw crouch
            ui_set(ref.pitchref, ui_get(customAA[4].pitch))
            ui_set(ref.targets, ui_get(customAA[4].yawbase))
            ui_set(ref.yaw_am[1], ui_get(customAA[4].yaw))
            ui_set(ref.yaw_am[2], ui_get(customAA[4].yawsli))
            ui_set(ref.jyaw[1], ui_get(customAA[4].yawjitter))
            ui_set(ref.jyaw[2], ui_get(customAA[4].yawjittersli))
            ui_set(ref.byaw[1], ui_get(customAA[4].bodyyaw))
            ui_set(ref.byaw[2], ui_get(customAA[4].bodyyawsli))
            ui_set(ref.fs_body_yaw, ui_get(customAA[4].freestandbyaw))
            ui_set(ref.fake_yaw, ui_get(customAA[4].fakeyaw))
            ui_set(ref.edge_yaw, ui_get(customAA[4].edgeyaw))
            ui_set(ref.rollskeet, ui_get(customAA[4].roll))
        else --moving
            ui_set(ref.pitchref, ui_get(customAA[2].pitch))
            ui_set(ref.targets, ui_get(customAA[2].yawbase))
            ui_set(ref.yaw_am[1], ui_get(customAA[2].yaw))
            ui_set(ref.yaw_am[2], ui_get(customAA[2].yawsli))
            ui_set(ref.jyaw[1], ui_get(customAA[2].yawjitter))
            ui_set(ref.jyaw[2], ui_get(customAA[2].yawjittersli))
            ui_set(ref.byaw[1], ui_get(customAA[2].bodyyaw))
            ui_set(ref.byaw[2], ui_get(customAA[2].bodyyawsli))
            ui_set(ref.fs_body_yaw, ui_get(customAA[2].freestandbyaw))
            ui_set(ref.fake_yaw, ui_get(customAA[2].fakeyaw))
            ui_set(ref.edge_yaw, ui_get(customAA[2].edgeyaw))
            ui_set(ref.rollskeet, ui_get(customAA[2].roll))
        end
    end

    misc = {}
    misc.anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
        return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
    end

    local function antiknife()
        if ui.get(anti_knife) then
            local players = entity.get_players(true)
            local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
            local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
            local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")

            for i=1, #players do
                local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
                local distance = misc.anti_knife_dist(lx, ly, lz, x, y, z)
                local weapon = entity.get_player_weapon(players[i])
                if entity.get_classname(weapon) == "CKnife" and distance <= 150.0 then
                    ui.set(yaw_slider,180)
                    ui.set(pitch,"Off")
                end
            end
        end
    end

    --do stuff
    client.set_event_callback("setup_command", function(cmd) --hvh
        
        if luaselection ~= 1 then return end
        local lp_vel = get_velocity(entity_get_local_player())
        local bodyyaw = ent_get_prop(entity_get_local_player(), "m_flPoseParameter", 11) * 120 - 60
        local side = bodyyaw > 0 and 1 or -1
        local state = state(lp_vel)

        
    

        
        
        if bodyyaw < 0 then
            left_side = true
            right_side = false
        elseif bodyyaw > 0 then
            right_side = true
            left_side = false
        end
        if ui_get(aaselection) == "Violence" then
            --enable AA and pitch down 
            ui_set(ref.aaenabledref, true)
            ui_set(ref.pitchref, "Default")
            ui_set(ref.fs_body_yaw, false)
            ui_set(ref.targets, "At targets" )
            ui_set(ref.yaw_am[1],"180")
            violenceAA(lp_vel, bodyyaw, state)
        elseif ui_get(aaselection) == "Experimental" then
            ui_set(ref.fs_body_yaw, false)
            ui_set(ref.targets, "At targets" )
            ui_set(ref.yaw_am[1],"180")
            ui_set(ref.aaenabledref, true)
            ui_set(ref.pitchref, "Default")
            experimentalAA(lp_vel, bodyyaw, state)
        elseif ui_get(aaselection) == "Custom" then
            Custom_AA(lp_vel, bodyyaw, state)
        end
        



        if last_value ~= ui_get(ref.fl_limit) and not should then
            last_value_FL = ui_get(ref.fl_limit)
        end

        if ui_get(legitAA) then
            legit_AA()
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
        
        if ui_get(anti_knife) then
            antiknife()
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
    ValidSession("Logged in", "semirage loaded.","" ..username)
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


        legit_AA()

        
    end)
    
end

--semirage end






client.set_event_callback("paint", function(cmd) --alles
            
            
            

    local local_velocity = get_velocity(entity_get_local_player())
    local lp_vel = get_velocity(entity_get_local_player())
    local state = state(lp_vel)
    local active_weapon = ent_get_prop(entity_get_local_player(), "m_hActiveWeapon")
    hour, minute, seconds, milliseconds = client.system_time()
    local c_maincolor = { ui_get(maincolor) }
    local c_seccolor = { ui_get(secondarycolor) }
    local c_arrowcolor1 = { ui_get(arrowcolor1) }
    local c_arrowcolor2 = { ui_get(arrowcolor2) }
    local c_watercolor = {ui_get(watercolor)}
    local c_weaponcolor = {ui_get(weaponcolor)}
    local color_g6 = {ui_get(secondarycolor)}

    local scrsize_x, scrsize_y = client.screen_size()
    local center_x, center_y = scrsize_x / 2, scrsize_y / 2
    local cx, cy = scrsize_x, 10
    
    
    
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
    
    if ui.get(vio_misc.clan_tag)  then
        do_clantag(durationCT,clantag_prev,clantags)
    end


    local playerxd = entity_get_local_player()
    local alive = is_alive(playerxd)

    --Arrows
    if contains(crossind, "Arrows") then
        draw_arrows(c_arrowcolor1, c_arrowcolor2, center_x, center_y, playerxd, alive)
    end
    --Text
    if contains(crossind, "Text") then
        draw_text(c_maincolor, c_seccolor, c_weaponcolor, color_g6, center_x, center_y, playerxd, alive, state)
    end
    --Watermark
    if contains(crossind, "Watermark") then
        draw_watermark(playerxd, alive, cx, cy, c_watercolor)
    end

    if not contains(crossind, "Text") or playerxd == nil or not alive then 
        return 
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







    

local function on_player_death(event)
    if vio_misc.killsay == "Disabled" then 
        return 
    end
    
    local local_player = entity_get_local_player()
    local attacker = client.userid_to_entindex(event.attacker)
    local victim = client.userid_to_entindex(event.userid)
    
    if local_player == nil or attacker == nil or victim == nil then
        return
    end
    
    if attacker == local_player and victim ~= local_player then
        if ui_get(vio_misc.killsay) == "Violence.systems" then
            local killsaycringe = 'say ' .. shittalktable2[math.random(num_quotes2)]
            killsaycringe = string.gsub(killsaycringe, "$name", ent_get_player_name(victim))
            client.log(killsaycringe)
            client.exec(killsaycringe)
            

        elseif ui_get(vio_misc.killsay) == "izue's shittalk" then
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
            ui_set_visible(anti_knife, true)
            ui_set_visible(newfreestand, true)
            ui_set_visible(color_change, false)
            ui_set_visible(secondarycolor, false)
            ui_set_visible(maincolor, false)
            ui_set_visible(arrowcolor1, false) 
            ui_set_visible(arrowcolor2, false) 
            ui_set_visible(weaponcolor, false) 
            ui_set_visible(watercolor, false) 
            ui_set_visible(colornignog, false)
            ui_set_visible(colornignog3, false)
            ui_set_visible(indclr1, false)
            ui_set_visible(indclr2, false)
            ui_set_visible(indclr3, false)
            ui_set_visible(indclr4, false)
            ui_set_visible(indclr5, false)
            ui_set_visible(indclr6, false)  
            ui_set_visible(indclr7, false) 
            ui_set_visible(indclr8, false) 
            ui_set_visible(font_type, false) 
            ui_set_visible(crossind, false)
            ui_set_visible(enablelogger, false)
            ui_set_visible(vio_misc.killsay, false)
            ui_set_visible(vio_misc.clan_tag, false)
            ui_set_visible(loggername, false)
            ui_set_visible(disclaimer6, true)
            ui_set_visible(disclaimer8, false)
            ui_set_visible(legitAA, true)
            if ui_get(aaselection) == "Custom" then
                ui_set_visible(playerstate, true)
            else
                ui_set_visible(playerstate, false)
                for i=1, 5 do
                    ui_set_visible(customAA[i].enable, false)
                    ui_set_visible(customAA[i].pitch, false)
                    ui_set_visible(customAA[i].yawbase, false)
                    ui_set_visible(customAA[i].yaw, false)
                    ui_set_visible(customAA[i].yawsli, false)
                    ui_set_visible(customAA[i].yawjitter, false)
                    ui_set_visible(customAA[i].yawjittersli, false)
                    ui_set_visible(customAA[i].bodyyaw, false)
                    ui_set_visible(customAA[i].bodyyawsli, false)
                    ui_set_visible(customAA[i].freestandbyaw, false)
                    ui_set_visible(customAA[i].fakeyaw, false)
                    ui_set_visible(customAA[i].edgeyaw, false)
                    ui_set_visible(customAA[i].roll, false)
                end
            end
            
        elseif ui_get(tabselection) == "Visual" then
            ui_set_visible(niggerkey, false)
            ui_set_visible(tabselection, true)
            ui_set_visible(ref.pitchref, false)
            ui_set_visible(newfreestand, false)
            ui_set_visible(aaselection, false)
            ui_set_visible(anti_knife, false)
            ui_set_visible(color_change, true)
            if ui_get(color_change) then
                ui_set_visible(secondarycolor, true)
                ui_set_visible(maincolor, true)
                ui_set_visible(arrowcolor1, true) 
                ui_set_visible(arrowcolor2, true) 
                ui_set_visible(weaponcolor, true) 
                ui_set_visible(watercolor, true) 
                ui_set_visible(colornignog, true)
                ui_set_visible(colornignog3, true)
                ui_set_visible(indclr1, true)
                ui_set_visible(indclr2, true)
                ui_set_visible(indclr3, true)
                ui_set_visible(indclr4, true)
                ui_set_visible(indclr5, true)
                ui_set_visible(indclr6, true)  
                ui_set_visible(indclr7, true) 
                ui_set_visible(indclr8, true) 
                ui_set_visible(font_type, true) 
            else
                ui_set_visible(secondarycolor, false)
                ui_set_visible(maincolor, false)
                ui_set_visible(arrowcolor1, false) 
                ui_set_visible(arrowcolor2, false) 
                ui_set_visible(weaponcolor, false) 
                ui_set_visible(watercolor, false) 
                ui_set_visible(colornignog, false)
                ui_set_visible(colornignog3, false)
                ui_set_visible(indclr1, false)
                ui_set_visible(indclr2, false)
                ui_set_visible(indclr3, false)
                ui_set_visible(indclr4, false)
                ui_set_visible(indclr5, false)
                ui_set_visible(indclr6, false)  
                ui_set_visible(indclr7, false) 
                ui_set_visible(indclr8, false) 
                ui_set_visible(font_type, false) 
            end
            ui_set_visible(crossind, true)
            ui_set_visible(enablelogger, true)
            ui_set_visible(vio_misc.killsay, false)
            ui_set_visible(vio_misc.clan_tag, false)
            if ui_get(enablelogger) then
                ui_set_visible(loggername, true)
            else
                ui_set_visible(loggername, false)
            end
            ui_set_visible(disclaimer6, false)
            ui_set_visible(disclaimer8, true)
            ui_set_visible(legitAA, false)
            ui_set_visible(playerstate, false)
            for i=1, 5 do
                ui_set_visible(customAA[i].enable, false)
                ui_set_visible(customAA[i].pitch, false)
                ui_set_visible(customAA[i].yawbase, false)
                ui_set_visible(customAA[i].yaw, false)
                ui_set_visible(customAA[i].yawsli, false)
                ui_set_visible(customAA[i].yawjitter, false)
                ui_set_visible(customAA[i].yawjittersli, false)
                ui_set_visible(customAA[i].bodyyaw, false)
                ui_set_visible(customAA[i].bodyyawsli, false)
                ui_set_visible(customAA[i].freestandbyaw, false)
                ui_set_visible(customAA[i].fakeyaw, false)
                ui_set_visible(customAA[i].edgeyaw, false)
                ui_set_visible(customAA[i].roll, false)
            end
        
        elseif ui_get(tabselection) == "Misc" then
            ui_set_visible(tabselection, true)
            ui_set_visible(enablelogger, false)
            ui_set_visible(niggerkey, false)
            ui_set_visible(aaselection, false)
            ui_set_visible(vio_misc.killsay, true)
            ui_set_visible(vio_misc.clan_tag, true)
            ui_set_visible(ref.pitchref, false)
            ui_set_visible(newfreestand, false)
            ui_set_visible(color_change, false)
            ui_set_visible(secondarycolor, false)
            ui_set_visible(maincolor, false)
            ui_set_visible(arrowcolor1, false) 
            ui_set_visible(arrowcolor2, false) 
            ui_set_visible(weaponcolor, false) 
            ui_set_visible(watercolor, false) 
            ui_set_visible(colornignog, false)
            ui_set_visible(colornignog3, false)
            ui_set_visible(indclr1, false)
            ui_set_visible(indclr2, false)
            ui_set_visible(indclr3, false)
            ui_set_visible(indclr4, false)
            ui_set_visible(indclr5, false)
            ui_set_visible(indclr6, false)  
            ui_set_visible(indclr7, false) 
            ui_set_visible(indclr8, false) 
            ui_set_visible(font_type, false) 
            ui_set_visible(anti_knife, false)
            ui_set_visible(crossind, false)
            ui_set_visible(loggername, false)
            ui_set_visible(disclaimer6, false)
            ui_set_visible(disclaimer8, false)
            ui_set_visible(legitAA, false)
            ui_set_visible(playerstate, false)
            for i=1, 5 do
                ui_set_visible(customAA[i].enable, false)
                ui_set_visible(customAA[i].pitch, false)
                ui_set_visible(customAA[i].yawbase, false)
                ui_set_visible(customAA[i].yaw, false)
                ui_set_visible(customAA[i].yawsli, false)
                ui_set_visible(customAA[i].yawjitter, false)
                ui_set_visible(customAA[i].yawjittersli, false)
                ui_set_visible(customAA[i].bodyyaw, false)
                ui_set_visible(customAA[i].bodyyawsli, false)
                ui_set_visible(customAA[i].freestandbyaw, false)
                ui_set_visible(customAA[i].fakeyaw, false)
                ui_set_visible(customAA[i].edgeyaw, false)
                ui_set_visible(customAA[i].roll, false)
            end
               
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
            ui_set_visible(color_change, false)
            ui_set_visible(secondarycolor, false)
            ui_set_visible(maincolor, false)
            ui_set_visible(arrowcolor1, false) 
            ui_set_visible(arrowcolor2, false) 
            ui_set_visible(weaponcolor, false) 
            ui_set_visible(watercolor, false) 
            ui_set_visible(colornignog, false)
            ui_set_visible(colornignog3, false)
            ui_set_visible(indclr1, false)
            ui_set_visible(indclr2, false)
            ui_set_visible(indclr3, false)
            ui_set_visible(indclr4, false)
            ui_set_visible(indclr5, false)
            ui_set_visible(indclr6, false)  
            ui_set_visible(indclr7, false) 
            ui_set_visible(indclr8, false) 
            ui_set_visible(font_type, false) 
            ui_set_visible(crossind, false)
            ui_set_visible(enablelogger, false)
            ui_set_visible(vio_misc.killsay, false)
            ui_set_visible(vio_misc.clan_tag, false)
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
            ui_set_visible(color_change, true)
            if ui_get(color_change) then
                ui_set_visible(secondarycolor, true)
                ui_set_visible(maincolor, true)
                ui_set_visible(arrowcolor1, true) 
                ui_set_visible(arrowcolor2, true) 
                ui_set_visible(weaponcolor, true) 
                ui_set_visible(watercolor, true) 
                ui_set_visible(colornignog, true)
                ui_set_visible(colornignog3, true)
                ui_set_visible(indclr1, true)
                ui_set_visible(indclr2, true)
                ui_set_visible(indclr3, true)
                ui_set_visible(indclr4, true)
                ui_set_visible(indclr5, true)
                ui_set_visible(indclr6, true)  
                ui_set_visible(indclr7, true) 
                ui_set_visible(indclr8, true) 
                ui_set_visible(font_type, true) 
            else
                ui_set_visible(secondarycolor, false)
                ui_set_visible(maincolor, false)
                ui_set_visible(arrowcolor1, false) 
                ui_set_visible(arrowcolor2, false) 
                ui_set_visible(weaponcolor, false) 
                ui_set_visible(watercolor, false) 
                ui_set_visible(colornignog, false)
                ui_set_visible(colornignog3, false)
                ui_set_visible(indclr1, false)
                ui_set_visible(indclr2, false)
                ui_set_visible(indclr3, false)
                ui_set_visible(indclr4, false)
                ui_set_visible(indclr5, false)
                ui_set_visible(indclr6, false)  
                ui_set_visible(indclr7, false) 
                ui_set_visible(indclr8, false) 
                ui_set_visible(font_type, false) 
            end
            ui_set_visible(crossind, true)
            ui_set_visible(enablelogger, true)
            ui_set_visible(vio_misc.killsay, false)
            ui_set_visible(vio_misc.clan_tag, false)
            if ui_get(enablelogger) then
                ui_set_visible(loggername, true)
            else
                ui_set_visible(loggername, false)
            end
        elseif ui_get(tabselection2) == "Misc" then
            ui_set_visible(tabselection2, true)
            ui_set_visible(legitAA, false)
            ui_set_visible(triggerenabled, false)
            ui_set_visible(triggerhotkey, false)
            ui_set_visible(autowallenabled, false)
            ui_set_visible(autowallhotkey, false)
            ui_set_visible(enablelogger, false)
            ui_set_visible(vio_misc.killsay, true)
            ui_set_visible(vio_misc.clan_tag, true)
            ui_set_visible(ref.pitchref, false)
            ui_set_visible(newfreestand, false)
            ui_set_visible(color_change, false)
            ui_set_visible(secondarycolor, false)
            ui_set_visible(maincolor, false)
            ui_set_visible(arrowcolor1, false) 
            ui_set_visible(arrowcolor2, false) 
            ui_set_visible(weaponcolor, false) 
            ui_set_visible(watercolor, false) 
            ui_set_visible(colornignog, false)
            ui_set_visible(colornignog3, false)
            ui_set_visible(indclr1, false)
            ui_set_visible(indclr2, false)
            ui_set_visible(indclr3, false)
            ui_set_visible(indclr4, false)
            ui_set_visible(indclr5, false)
            ui_set_visible(indclr6, false)  
            ui_set_visible(indclr7, false) 
            ui_set_visible(indclr8, false) 
            ui_set_visible(font_type, false) 
            ui_set_visible(crossind, false)
            ui_set_visible(loggername, false)
        end
        ui_set_visible(playerstate, false)
        for i=1, 5 do
            ui_set_visible(customAA[i].enable, false)
            ui_set_visible(customAA[i].pitch, false)
            ui_set_visible(customAA[i].yawbase, false)
            ui_set_visible(customAA[i].yaw, false)
            ui_set_visible(customAA[i].yawsli, false)
            ui_set_visible(customAA[i].yawjitter, false)
            ui_set_visible(customAA[i].yawjittersli, false)
            ui_set_visible(customAA[i].bodyyaw, false)
            ui_set_visible(customAA[i].bodyyawsli, false)
            ui_set_visible(customAA[i].freestandbyaw, false)
            ui_set_visible(customAA[i].fakeyaw, false)
            ui_set_visible(customAA[i].edgeyaw, false)
            ui_set_visible(customAA[i].roll, false)
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
        ui_set_visible(anti_knife, false)
    
    else
        ui_set_visible(legitAA, false)
        ui_set_visible(triggerenabled, false)
        ui_set_visible(triggerhotkey, false)
        ui_set_visible(autowallenabled, false)
        ui_set_visible(autowallhotkey, false)
        ui_set_visible(anti_knife, false)
        ui_set_visible(ref.pitchref, false)
        ui_set_visible(tabselection, false)
        ui_set_visible(tabselection2, false)
        ui_set_visible(newfreestand, false)
        ui_set_visible(aaselection, false)
        ui_set_visible(niggerkey, false)
        ui_set_visible(color_change, false)
        ui_set_visible(secondarycolor, false)
        ui_set_visible(maincolor, false)
        ui_set_visible(arrowcolor1, false) 
        ui_set_visible(arrowcolor2, false) 
        ui_set_visible(weaponcolor, false) 
        ui_set_visible(watercolor, false) 
        ui_set_visible(colornignog, false)
        ui_set_visible(colornignog3, false)
        ui_set_visible(indclr1, false)
        ui_set_visible(indclr2, false)
        ui_set_visible(indclr3, false)
        ui_set_visible(indclr4, false)
        ui_set_visible(indclr5, false)
        ui_set_visible(indclr6, false)  
        ui_set_visible(indclr7, false) 
        ui_set_visible(indclr8, false) 
        ui_set_visible(font_type, false) 
        ui_set_visible(crossind, false)
        ui_set_visible(enablelogger, false)
        ui_set_visible(vio_misc.killsay, false)
        ui_set_visible(vio_misc.clan_tag, false)
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
        ui_set_visible(playerstate, false)
        for i=1, 5 do
            ui_set_visible(customAA[i].enable, false)
            ui_set_visible(customAA[i].pitch, false)
            ui_set_visible(customAA[i].yawbase, false)
            ui_set_visible(customAA[i].yaw, false)
            ui_set_visible(customAA[i].yawsli, false)
            ui_set_visible(customAA[i].yawjitter, false)
            ui_set_visible(customAA[i].yawjittersli, false)
            ui_set_visible(customAA[i].bodyyaw, false)
            ui_set_visible(customAA[i].bodyyawsli, false)
            ui_set_visible(customAA[i].freestandbyaw, false)
            ui_set_visible(customAA[i].fakeyaw, false)
            ui_set_visible(customAA[i].edgeyaw, false)
            ui_set_visible(customAA[i].roll, false)
        end
        
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
    hour, minute, seconds, milliseconds = client.system_time()
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
