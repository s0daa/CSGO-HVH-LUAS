-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
client.exec("clear")
print("███╗   ███╗███████╗████████╗███████╗ ██████╗ ██████╗ ")
print("████╗ ████║██╔════╝╚══██╔══╝██╔════╝██╔═══██╗██╔══██╗")
print("██╔████╔██║█████╗     ██║   █████╗  ██║   ██║██████╔╝")
print("██║╚██╔╝██║██╔══╝     ██║   ██╔══╝  ██║   ██║██╔══██╗")
print("██║ ╚═╝ ██║███████╗   ██║   ███████╗╚██████╔╝██║  ██║")
local a={['gamesense/antiaim_funcs']='https://gamesense.pub/forums/viewtopic.php?id=29665',['gamesense/base64']='https://gamesense.pub/forums/viewtopic.php?id=21619',['gamesense/clipboard']='https://gamesense.pub/forums/viewtopic.php?id=28678',['gamesense/http']='https://gamesense.pub/forums/viewtopic.php?id=19253',
['gamesense/entity']='https://gamesense.pub/forums/viewtopic.php?id=27529',}local b={}for c,d in pairs(a)do if not pcall(require,c)then b[#b+1]=a[c]end end;for c=1,#b do error("pls sub the API/请订阅库 \n"..table.concat(b,", \n"))end
local antiaim_funcs = require('gamesense/antiaim_funcs')
local base64 = require('gamesense/base64')
local clipboard = require('gamesense/clipboard')
local ent = require "gamesense/entity"
local vector = require 'vector'
local debug = false
local tab1,tab2 = "AA","Anti-aimbot angles"
local staryaw = {
    status = {
        build = "1sTar",
        last_updatetime = "2023/7/3",
        username = 'admin'
    },
    pstate = {"Global","Standing","Moment","Inair","Inair +","Inair Duck","Inair Duck +","Duck","Slow Walk"},
    pstate_txt = {"G","S","M","A","A+","AD","AD+","D","SW"},
    aa = {
       
        enable = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
        pitch = {ui.reference("AA", "Anti-aimbot angles", "pitch")},
        leg = ui.reference("AA", "Other", "Leg Movement"),
        yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
        yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
        --fakeyawlimit = ui.reference("AA", "anti-aimbot angles", "Fake yaw limit"),
        fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
        edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
        fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
        dmg = ui.reference("RAGE", "Aimbot", "Minimum damage"),
        min_ovr = {ui.reference("RAGE", "Aimbot", "Minimum damage override")},
        roll = ui.reference("AA", "anti-aimbot angles", "Roll"),
        hc = ui.reference("RAGE", "Aimbot", "Minimum hit chance"),
        baim = ui.reference("RAGE", "Aimbot", "Force body aim"),
        preferbaim = ui.reference("RAGE", "Aimbot", "Prefer body aim"),
        prefersp = ui.reference("RAGE", "Aimbot", "Prefer safe point"),
        sp = { ui.reference("RAGE", "Aimbot", "Force safe point") },
        yawjitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
        bodyyaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
        fs = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
        quickpeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
        os = { ui.reference("AA", "Other", "On shot anti-aim") },
        sw = { ui.reference("AA", "Other", "Slow motion") },
        dt = { ui.reference("RAGE", "Aimbot", "Double tap") },
        ps = { ui.reference("MISC", "Miscellaneous", "Ping spike") },
        fakelag = ui.reference("AA", "Fake lag", "Limit"),
    },
}
local config = {
    export = {
        ['number'] = {},
        ['boolean'] = {},
        ['table'] = {},
        ['string'] = {}
    },
    __call = {},
    str_to_sub = function(input, sep)
        local t = {}
        for str in string.gmatch(input, "([^"..sep.."]+)") do
            t[#t + 1] = string.gsub(str, "\n", "")
        end
        return t
    end,
    arr_to_string = function(arr)
        arr = ui.get(arr)
        local str = ""
        for i=1, #arr do
            str = str .. arr[i] .. (i == #arr and "" or ",")
        end
    
        if str == "" then
            str = "-"
        end
    
        return str
    end, 
    to_boolean = function(str)
        if str == "true" or str == "false" then
            return (str == "true")
        else
            return str
        end
    end,
}
local load_config = function()
    local tbl = config.str_to_sub(base64.decode(clipboard.get(), 'base64'), "|")
    local p = 1
    for i,o in pairs(config.export['number']) do
        ui.set(o,tonumber(tbl[p]))
        p = p + 1
    end
    for i,o in pairs(config.export['string']) do
        ui.set(o,tbl[p])
        p = p + 1
    end
    for i,o in pairs(config.export['boolean']) do
        ui.set(o,config.to_boolean(tbl[p]))
        p = p + 1
    end
    for i,o in pairs(config.export['table']) do
        ui.set(o,config.str_to_sub(tbl[p],','))
        p = p + 1
    end
end
local load_cloudconfig = function()
    http.get('地址',function(s,r)

        if not s or r.status ~= 200 then
            log('Unable to get config due to an error: '..r.status)
            return
        end
        
        local tbl = config.str_to_sub(base64.decode(r.body, 'base64'), "|")
        local p = 1
        for i,o in pairs(config.export['number']) do
            ui.set(o,tonumber(tbl[p]))
            p = p + 1
        end
        for i,o in pairs(config.export['string']) do
            ui.set(o,tbl[p])
            p = p + 1
        end
        for i,o in pairs(config.export['boolean']) do
            ui.set(o,config.to_boolean(tbl[p]))
            p = p + 1
        end
        for i,o in pairs(config.export['table']) do
            ui.set(o,config.str_to_sub(tbl[p],','))
            p = p + 1
        end
    end)

end
local export_config = function()
    local str = ""
    for i,o in pairs(config.export['number']) do
        str = str .. tostring(ui.get(o)) .. '|'
    end
    for i,o in pairs(config.export['string']) do
        str = str .. (ui.get(o)) .. '|'
    end
    for i,o in pairs(config.export['boolean']) do
        str = str .. tostring(ui.get(o)) .. '|'
    end
    for i,o in pairs(config.export['table']) do
        str = str .. config.arr_to_string(o) .. '|'
    end
    clipboard.set(base64.encode(str, 'base64'))
end
local table_contains = function(tbl, val)
    for i=1,#tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end
local new = function(register)
    if type(register) ~= 'number' then
        log('unable to create new register,register should be a number')
    end

    if type(register) == 'number' then
        table.insert(config.export[type(ui.get(register))],register)
    end

     if type(register) == 'number' then
         table.insert(config.__call,register)
    end
    return register
end
local menu = {}
menu.switch = new(ui.new_checkbox(tab1,tab2,">> \aD0B0FFFFstaryaw Anti-Aim System  \aFFFFFFC8<<"))
menu.master_combo = new(ui.new_combobox(tab1,tab2,"Tab Selection",{"Global",'Anti-Aim',"Animations & Visual","Miscellaneous"}))
menu.info = {
    info_label = ui.new_label(tab1,tab2,'Welcome! \a96C83BFF All staryaw users'),
    info_label2 = ui.new_label(tab1,tab2,'1sTar: \a96C83BFF Thank you for your support and waiting to get the code recoded! Sincerest thanks!'),
    info_label4 = ui.new_label(tab1,tab2,'\a96C83BFF Users with staryaw can find 1sTar to bind the neverlose beta version for free'),
    info_label3 = ui.new_label(tab1,tab2,'Last update time: \a96C83BFF'..staryaw.status.last_updatetime),
    load_config = ui.new_button(tab1,tab2,"Load config from clipboard",load_config),
    export_config = ui.new_button(tab1,tab2,"Export config from clipboard",export_config),
   -- cloud_config = ui.new_button(tab1,tab2,"Load config from cloud",load_cloudconfig),
}
menu.anti_aim = {
    aa_combo = new(ui.new_combobox(tab1,tab2,'Settings',{"Antiaim builder","Keybinds"})),
    state = new(ui.new_combobox(tab1,tab2,"\aD0B0FFFFPlayer State",staryaw.pstate)),
    keybind = {
        manual_left = ui.new_hotkey(tab1,tab2,'Manual Left'),
        manual_right = ui.new_hotkey(tab1,tab2,'Manual Right'),
        manual_reset = ui.new_hotkey(tab1,tab2,'Manual Reset'),
        legit_aa = ui.new_hotkey(tab1,tab2,'Antiaim on use'),
        freestanding = ui.new_hotkey(tab1,tab2,'Freestanding'),
        edge_yaw = ui.new_hotkey(tab1,tab2,'Edge Yaw'),

    },
    temp_states = new(ui.new_slider(tab1,tab2,"TEMP_STATES",0,3,1)),
    builder= {}
}
for i = 1, #staryaw.pstate do
    menu.anti_aim.builder[i]={
        enable =  new(ui.new_checkbox("AA", "Anti-aimbot angles", "\a8BFF7CFF Enable States".."\a8BFF7CFF"..staryaw.pstate_txt[i])),
        yawlr_sett = new(ui.new_combobox("AA", "Anti-aimbot angles"," > \aD0B0FFFFYaw Settings".."\n8BFF7CFF"..staryaw.pstate_txt[i],{"Static","L&R","Slow jitter"})),
        yaw = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFYaw".."\nD0B0FFFF"..staryaw.pstate[i],-180,180,0)),
        yawl = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFYaw [L]".."\nD0B0FFFF"..staryaw.pstate[i],-180,180,0)),
        yawr = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFYaw [R]".."\nD0B0FFFF"..staryaw.pstate[i],-180,180,0)),
        yawspeed = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFYaw Speed".."\nD0B0FFFF"..staryaw.pstate[i],4,20,6)),
        yaw_sway = new(ui.new_combobox("AA", "Anti-aimbot angles","> \aD0B0FFFFYaw Sway".."\n8BFF7CFF"..staryaw.pstate_txt[i],{"Off","3-Way","5-way"})),
        yaws1 = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFYaw Sway [1]".."\nD0B0FFFF"..staryaw.pstate[i],-180,180,0)),
        yaws2 = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFYaw Sway [2]".."\nD0B0FFFF"..staryaw.pstate[i],-180,180,0)),
        yaws3 = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFYaw Sway [3]".."\nD0B0FFFF"..staryaw.pstate[i],-180,180,0)),
        yaws4 = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFYaw Sway [4]".."\nD0B0FFFF"..staryaw.pstate[i],-180,180,0)),
        jittermode = new(ui.new_combobox("AA", "Anti-aimbot angles"," > \aD0B0FFFFYaw Jitter Mode",{"Off","Offset","Center","Random","skitter"})),
        jitter = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFYaw Jitter Value".."\nD0B0FFFF"..staryaw.pstate[i],-180,180,0)),
        jitterl = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFYaw Jitter Value [L]".."\nD0B0FFFF"..staryaw.pstate[i],-180,180,0)),
        jitterr = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFYaw Jitter Value [R]".."\nD0B0FFFF"..staryaw.pstate[i],-180,180,0)),
        byawmode = new(ui.new_combobox("AA", "Anti-aimbot angles"," > \aD0B0FFFFBody Yaw Mode".."\nD0B0FFFF"..staryaw.pstate[i],{"Off","Jitter","Static"})),
        byaw = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFBody Yaw Value".."\nD0B0FFFF"..staryaw.pstate[i],-180,180,0)),
        byawl = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFBody Yaw Value [L]".."\nD0B0FFFF"..staryaw.pstate[i],-180,180,0)),
        byawr = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFBody Yaw Value [R]".."\nD0B0FFFF"..staryaw.pstate[i],-180,180,0)),
        fakelimit = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFFake yaw limit".."\nD0B0FFFF"..staryaw.pstate[i],0,60,60)),
        fakelimitl = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFFake yaw limit [L]".."\nD0B0FFFF"..staryaw.pstate[i],0,60,60)),
        fakelimitr = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFFake yaw limit [R]".."\nD0B0FFFF"..staryaw.pstate[i],0,60,60)),
        abf_sett = new(ui.new_combobox("AA", "Anti-aimbot angles"," > \aD0B0FFFFAnti-Bruteforce Setting".."\nD0B0FFFF"..staryaw.pstate[i],{"Off","Switch Yaw Offset","Switch Body Yaw Offset","Hybrid"})),
        abf_switch = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFAnti-Bruteforce >> Yaw".."\nD0B0FFFF"..staryaw.pstate[i],-180,180,0)),
        abf_switchb = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFFAnti-Bruteforce >> Body Yaw".."\nD0B0FFFF"..staryaw.pstate[i],-180,180,0)),
        Defensive = new(ui.new_checkbox("AA", "Anti-aimbot angles", " > \aD0B0FFFFDefensive".."\nD0B0FFFF"..staryaw.pstate[i])),
        Defensive_breaker = new(ui.new_combobox("AA", "Anti-aimbot angles", " > \aD0B0FFFF Defensive Breaker".."\nD0B0FFFF"..staryaw.pstate[i],{"On Peek","Always On"})),
        Defensive_Yaw_Mod = new(ui.new_combobox("AA", "Anti-aimbot angles"," > \aD0B0FFFF Defensive Yaw Mode".."\nD0B0FFFF"..staryaw.pstate[i], {"Center","Random", "Spin","Down","Without","Circular","Switch Left","Switch Right","Free Sway"})),
        Defensive_Spin = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFF Defensive Spin".."\nD0B0FFFF"..staryaw.pstate[i],1,90,25)),
        Defensive_Center = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFF Defensive Center".."\nD0B0FFFF"..staryaw.pstate[i],-180,180,0)),
        Defensive_Pitch = new(ui.new_combobox("AA", "Anti-aimbot angles"," > \aD0B0FFFF Defensive Pitch".."\nD0B0FFFF"..staryaw.pstate[i],{"Custom","Random","Paketa","Paketa 2","Switch Down","Switch Up","Increase Up"})),
        Defensive_Custom_Pitch = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFF Defensive Custom Pitch".."\nD0B0FFFF"..staryaw.pstate[i],-89,89,0)),
        -- Defensive_breaker = new(ui.new_combobox("AA", "Anti-aimbot angles"," > \aD0B0FFFF Defensive Breaker".."\nD0B0FFFF"..staryaw.pstate[i],{"Off","Normal","Pitch","Up","Spin","180 Z","Forward"})),
        -- Defensive_tab = new(ui.new_combobox("AA", "Anti-aimbot angles", " > \aD0B0FFFF Defensive TAB".."\nD0B0FFFF"..staryaw.pstate[i],{"Old","New"})),
        -- Defensive_Time_min=  new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFF Defensive Time [Min]".."\nD0B0FFFF"..staryaw.pstate[i],0,20,3)),
        -- Defensive_Time_max=  new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFF Defensive Time [Max]".."\nD0B0FFFF"..staryaw.pstate[i],0,20,18)),
        -- Defensive_Time = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFF Defensive Time".."\nD0B0FFFF"..staryaw.pstate[i],0,20,7)),
        -- Defensive_Spin_Pitch= new(ui.new_combobox("AA", "Anti-aimbot angles"," > \aD0B0FFFF Defensive Spin Pitch".."\nD0B0FFFF"..staryaw.pstate[i],{"Off","Down","Up"})),
        -- Defensive_Spin_Yaw = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFF Defensive Spin Yaw".."\nD0B0FFFF"..staryaw.pstate[i],0,180,20)),
        -- Defensive_yaw = new(ui.new_slider("AA", "Anti-aimbot angles"," > \aD0B0FFFF Defensive Yaw".."\nD0B0FFFF"..staryaw.pstate[i],-180,180,0)),
    }
end
menu.misc = {
    Animation_Breaker = new(ui.new_multiselect(tab1,tab2,"Animation Breaker",{"Legs Fucker", "0 Pitch on Land", "Legs in Air"})),
    legs_Air = new(ui.new_checkbox(tab1,tab2,"Moonwalk Allah On Air")),
    legs_Ground = new(ui.new_checkbox(tab1,tab2,"Moonwalk Allah On Ground")),
    killsay = new(ui.new_checkbox(tab1,tab2,"Trash talk")),
    anti_knife = new(ui.new_checkbox(tab1,tab2,"Anti-knife")),
    onshot = new(ui.new_checkbox(tab1,tab2,"Onshot-Fix")),
    quickfall = ui.new_checkbox(tab1,tab2, "Quick fall"),
    quick_fall_hotkey = ui.new_hotkey(tab1,tab2, "Quick fall hotkey", true),
    quickfall_mode = ui.new_combobox(tab1,tab2, "\nQuick fall mode", {"Favor quicker fall", "Favor landing accuracy"}),
    doubletap_key = ui.new_combobox(tab1,tab2, "Double tap restore", {"Toggle", "Always on", "On hotkey", "Off hotkey"}),
	fast_ladder = new(ui.new_checkbox(tab1,tab2,"Fast Ladder"))
}
menu.visual = {
    center_indicator = new(ui.new_checkbox(tab1,tab2,"Indicator-Center")),
    center_mode = new(ui.new_combobox(tab1,tab2,'Center mode',{"Text","Icon"})),
    label = new(ui.new_label(tab1,tab2, "Color 1 >>")),
	color = new(ui.new_color_picker(tab1,tab2, "log color", 208, 176, 255, 255)),
    label2 = new(ui.new_label(tab1,tab2, "Color 2 >>")),
	color2 = new(ui.new_color_picker(tab1,tab2, "log color 2", 208, 176, 255, 255)),
    speed = new(ui.new_slider(tab1,tab2,"Indicator-Center-Speed",1,20,3)),
    log_output = new(ui.new_multiselect(tab1,tab2, "Logs", {"Center", "Console"})),
    log_hit_label = new(ui.new_label(tab1,tab2, "Hit color")),
    log_hit_color = new(ui.new_color_picker(tab1,tab2, "Hit color picker", 163, 255, 15, 255)),
    log_miss_label = new(ui.new_label(tab1,tab2, "Miss color")),
    log_miss_color = new(ui.new_color_picker(tab1,tab2, "Miss color picker", 255, 50, 50, 255)),
    min_dmg = new(ui.new_checkbox(tab1,tab2,"Min DMG Indicator")),
}
local visible = function()
    local K = ui.get(menu.switch)
    local AA = ui.get(menu.master_combo) == "Anti-Aim" and K
    local VA = ui.get(menu.master_combo) == "Animations & Visual" and K
    local MS = ui.get(menu.master_combo) == "Miscellaneous" and K
    local buld = ui.get(menu.master_combo) == "Anti-Aim" and K and ui.get(menu.anti_aim.aa_combo) == "Antiaim builder"
    for k, v in pairs(menu.info) do
        ui.set_visible(menu.info[k], K and ui.get(menu.master_combo) == "Global")
    end
    ui.set_visible(menu.master_combo, K)
    ui.set_visible(menu.anti_aim.aa_combo, AA)
    ui.set_visible(menu.anti_aim.state, buld)
    ui.set_visible(menu.anti_aim.temp_states, false)
    for k, v in pairs(menu.anti_aim.keybind) do
        ui.set_visible(menu.anti_aim.keybind[k],AA and ui.get(menu.anti_aim.aa_combo) == "Keybinds")
    end
    for i = 1, #staryaw.pstate do
        local condition = staryaw.pstate[i]
        local lp_state = condition == ui.get(menu.anti_aim.state)
        local else_ = (i == 1 and true or ui.get(menu.anti_aim.builder[i].enable))
        ui.set_visible( menu.anti_aim.builder[i].enable , buld and i ~= 1 and lp_state)
        ui.set_visible( menu.anti_aim.builder[i].yawlr_sett , buld and lp_state and else_)
        ui.set_visible(menu.anti_aim.builder[i].yaw ,buld and lp_state and else_ and ui.get( menu.anti_aim.builder[i].yawlr_sett)=="Static" )
        ui.set_visible(menu.anti_aim.builder[i].yawr ,buld and lp_state and else_ and ui.get( menu.anti_aim.builder[i].yawlr_sett)~="Static" )
        ui.set_visible(menu.anti_aim.builder[i].yawl ,buld and lp_state and else_ and ui.get( menu.anti_aim.builder[i].yawlr_sett)~="Static" )
        ui.set_visible(menu.anti_aim.builder[i].yawspeed ,buld and lp_state and else_ and ui.get( menu.anti_aim.builder[i].yawlr_sett)=="Slow jitter" )
        -- yawspeed
        ui.set_visible( menu.anti_aim.builder[i].yaw_sway , buld and lp_state and else_)
        ui.set_visible( menu.anti_aim.builder[i].yaws1 , buld and lp_state and else_ and ui.get( menu.anti_aim.builder[i].yaw_sway)~= "Off" )
        ui.set_visible( menu.anti_aim.builder[i].yaws2 , buld and lp_state and else_ and ui.get( menu.anti_aim.builder[i].yaw_sway)~= "Off" )
        ui.set_visible( menu.anti_aim.builder[i].yaws3 , buld and lp_state and else_ and ui.get( menu.anti_aim.builder[i].yaw_sway)== "5-way" )
        ui.set_visible( menu.anti_aim.builder[i].yaws4 , buld and lp_state and else_ and ui.get( menu.anti_aim.builder[i].yaw_sway)== "5-way" )
        ui.set_visible( menu.anti_aim.builder[i].jittermode , buld and lp_state and else_)
        ui.set_visible( menu.anti_aim.builder[i].jitter , buld and lp_state and else_ and ui.get( menu.anti_aim.builder[i].yawlr_sett)=="Static")
        ui.set_visible( menu.anti_aim.builder[i].jitterl , buld and lp_state and else_ and ui.get( menu.anti_aim.builder[i].yawlr_sett)~="Static")
        ui.set_visible( menu.anti_aim.builder[i].jitterr , buld and lp_state and else_ and ui.get( menu.anti_aim.builder[i].yawlr_sett)~="Static")
        ui.set_visible( menu.anti_aim.builder[i].byawmode , buld and lp_state and else_)
        ui.set_visible( menu.anti_aim.builder[i].byaw , buld and lp_state and else_ and ui.get( menu.anti_aim.builder[i].yawlr_sett)=="Static")
        ui.set_visible( menu.anti_aim.builder[i].byawl , buld and lp_state and else_ and ui.get( menu.anti_aim.builder[i].yawlr_sett)~="Static")
        ui.set_visible( menu.anti_aim.builder[i].byawr , buld and lp_state and else_ and ui.get( menu.anti_aim.builder[i].yawlr_sett)~="Static")
        ui.set_visible( menu.anti_aim.builder[i].fakelimit , buld and lp_state and else_ and ui.get( menu.anti_aim.builder[i].yawlr_sett)=="Static")
        ui.set_visible( menu.anti_aim.builder[i].fakelimitl , buld and lp_state and else_ and ui.get( menu.anti_aim.builder[i].yawlr_sett)~="Static")
        ui.set_visible( menu.anti_aim.builder[i].fakelimitr , buld and lp_state and else_ and ui.get( menu.anti_aim.builder[i].yawlr_sett)~="Static")
        ui.set_visible( menu.anti_aim.builder[i].abf_sett , buld and lp_state and else_)
        ui.set_visible( menu.anti_aim.builder[i].abf_switch , buld and lp_state and else_ and ui.get(menu.anti_aim.builder[i].abf_sett)~= "Switch Body Yaw Offset" and ui.get(menu.anti_aim.builder[i].abf_sett)~= "Off")
        ui.set_visible( menu.anti_aim.builder[i].abf_switchb , buld and lp_state and else_ and ui.get(menu.anti_aim.builder[i].abf_sett)~= "Switch Yaw Offset" and ui.get(menu.anti_aim.builder[i].abf_sett)~= "Off")
        
        ui.set_visible(menu.anti_aim.builder[i].Defensive , buld and lp_state and else_)
        ui.set_visible(menu.anti_aim.builder[i].Defensive_breaker , buld and lp_state and else_ and ui.get(menu.anti_aim.builder[i].Defensive))
        ui.set_visible(menu.anti_aim.builder[i].Defensive_Yaw_Mod , buld and lp_state and else_ and ui.get(menu.anti_aim.builder[i].Defensive))
        ui.set_visible(menu.anti_aim.builder[i].Defensive_Spin , buld and lp_state and else_ and (ui.get(menu.anti_aim.builder[i].Defensive_Yaw_Mod) == "Spin" or ui.get(menu.anti_aim.builder[i].Defensive_Yaw_Mod) == "Circular")and ui.get(menu.anti_aim.builder[i].Defensive))
        ui.set_visible(menu.anti_aim.builder[i].Defensive_Center , buld and lp_state and else_ and ui.get(menu.anti_aim.builder[i].Defensive_Yaw_Mod) == "Center"and ui.get(menu.anti_aim.builder[i].Defensive))
        ui.set_visible(menu.anti_aim.builder[i].Defensive_Pitch , buld and lp_state and else_ and ui.get(menu.anti_aim.builder[i].Defensive))
        ui.set_visible(menu.anti_aim.builder[i].Defensive_Custom_Pitch , buld and lp_state and else_ and ui.get(menu.anti_aim.builder[i].Defensive_Pitch)=="Custom"and ui.get(menu.anti_aim.builder[i].Defensive))

        -- ui.set_visible( menu.anti_aim.builder[i].Defensive , buld and lp_state and else_)
        -- ui.set_visible( menu.anti_aim.builder[i].Defensive_Mod , buld and lp_state and else_ and ui.get(menu.anti_aim.builder[i].Defensive))
        -- ui.set_visible( menu.anti_aim.builder[i].Defensive_breaker , buld and lp_state and else_ and ui.get(menu.anti_aim.builder[i].Defensive))
        -- ui.set_visible( menu.anti_aim.builder[i].Defensive_tab , buld and lp_state and else_ and ui.get(menu.anti_aim.builder[i].Defensive))
        -- local def_tab = ui.get(menu.anti_aim.builder[i].Defensive_tab) == "Old"
        -- ui.set_visible( menu.anti_aim.builder[i].Defensive_Time_min , buld and lp_state and else_ and ui.get(menu.anti_aim.builder[i].Defensive) and ui.get( menu.anti_aim.builder[i].Defensive_breaker) ~= "Normal" and ui.get( menu.anti_aim.builder[i].Defensive_breaker) ~= "Off" and def_tab)
        -- ui.set_visible( menu.anti_aim.builder[i].Defensive_Time_max , buld and lp_state and else_ and ui.get(menu.anti_aim.builder[i].Defensive) and ui.get( menu.anti_aim.builder[i].Defensive_breaker) ~= "Normal"and ui.get( menu.anti_aim.builder[i].Defensive_breaker) ~= "Off" and def_tab)
        -- ui.set_visible( menu.anti_aim.builder[i].Defensive_Time , buld and lp_state and else_ and ui.get(menu.anti_aim.builder[i].Defensive) and ui.get( menu.anti_aim.builder[i].Defensive_breaker) == "Normal"and ui.get( menu.anti_aim.builder[i].Defensive_breaker) ~= "Off" and def_tab)
        -- ui.set_visible( menu.anti_aim.builder[i].Defensive_Spin_Pitch , buld and lp_state and else_ and ui.get(menu.anti_aim.builder[i].Defensive) and (ui.get( menu.anti_aim.builder[i].Defensive_breaker) == "Spin" or ui.get( menu.anti_aim.builder[i].Defensive_breaker) == "180 Z")and ui.get( menu.anti_aim.builder[i].Defensive_breaker) ~= "Off" and def_tab)

        -- ui.set_visible( menu.anti_aim.builder[i].Defensive_Spin_Yaw , buld and lp_state and else_ and ui.get(menu.anti_aim.builder[i].Defensive) and (ui.get( menu.anti_aim.builder[i].Defensive_breaker) == "Spin" or ui.get( menu.anti_aim.builder[i].Defensive_breaker) == "180 Z")  and ui.get( menu.anti_aim.builder[i].Defensive_breaker) ~= "Off")

        -- ui.set_visible( menu.anti_aim.builder[i].Defensive_yaw , buld and lp_state and else_ and ui.get(menu.anti_aim.builder[i].Defensive) and ui.get( menu.anti_aim.builder[i].Defensive_breaker) == "Normal"and ui.get( menu.anti_aim.builder[i].Defensive_breaker) ~= "Off")
    
    end
    ui.set_visible(menu.misc.Animation_Breaker, MS)
    ui.set_visible(menu.misc.legs_Air, MS and table_contains(ui.get(menu.misc.Animation_Breaker),'Legs in Air'))
    ui.set_visible(menu.misc.legs_Ground, MS and table_contains(ui.get(menu.misc.Animation_Breaker),'Legs Fucker'))
    ui.set_visible(menu.misc.killsay, MS)
    ui.set_visible(menu.misc.anti_knife, MS)
    ui.set_visible(menu.misc.onshot, MS)
	ui.set_visible(menu.misc.quickfall, MS)
	ui.set_visible(menu.misc.quickfall_mode, MS and ui.get(menu.misc.quickfall))
	ui.set_visible(menu.misc.quick_fall_hotkey, MS and ui.get(menu.misc.quickfall))
    ui.set_visible(menu.misc.doubletap_key, MS and ui.get(menu.misc.quickfall))
    
	ui.set_visible(menu.misc.fast_ladder, MS)
    ui.set_visible(menu.visual.center_indicator, VA)
    ui.set_visible(menu.visual.center_mode, VA and ui.get(menu.visual.center_indicator))
    ui.set_visible(menu.visual.min_dmg, VA)
    ui.set_visible(menu.visual.label, VA and ui.get(menu.visual.center_indicator) and ui.get(menu.visual.center_mode)=="Text")
    ui.set_visible(menu.visual.label2, VA and ui.get(menu.visual.center_indicator)and ui.get(menu.visual.center_mode)=="Text")
    ui.set_visible(menu.visual.color, VA and ui.get(menu.visual.center_indicator) and ui.get(menu.visual.center_mode)=="Text")
    ui.set_visible(menu.visual.color2, VA and ui.get(menu.visual.center_indicator)and ui.get(menu.visual.center_mode)=="Text")
    ui.set_visible(menu.visual.speed, VA and ui.get(menu.visual.center_indicator)and ui.get(menu.visual.center_mode)=="Text")

    ui.set_visible(menu.visual.log_output, VA)

    ui.set_visible(menu.visual.log_hit_label, VA and table_contains(ui.get(menu.visual.log_output),'Center'))
    ui.set_visible(menu.visual.log_hit_color, VA and table_contains(ui.get(menu.visual.log_output),'Center'))
    ui.set_visible(menu.visual.log_miss_label, VA and table_contains(ui.get(menu.visual.log_output),'Center') )
    ui.set_visible(menu.visual.log_miss_color, VA and table_contains(ui.get(menu.visual.log_output),'Center'))

    ui.set(staryaw.aa.roll,0)
    ui.set_visible(staryaw.aa.fs[1],debug)
    ui.set_visible(staryaw.aa.fs[2],debug)
	ui.set_visible(staryaw.aa.pitch[1],debug)
    ui.set_visible(staryaw.aa.pitch[2],debug)
	ui.set_visible(staryaw.aa.yawbase,debug)
	ui.set_visible(staryaw.aa.yaw[1],debug)
	ui.set_visible(staryaw.aa.yaw[2],debug)
	--ui.set_visible(staryaw.aa.fakeyawlimit,debug)
	ui.set_visible(staryaw.aa.fsbodyyaw,debug)
	ui.set_visible(staryaw.aa.edgeyaw,debug)
	ui.set_visible(staryaw.aa.yawjitter[1],debug)
	ui.set_visible(staryaw.aa.yawjitter[2],debug)
	ui.set_visible(staryaw.aa.bodyyaw[1],debug)
	ui.set_visible(staryaw.aa.bodyyaw[2],debug)
	ui.set_visible(staryaw.aa.roll,debug)


end
local handle_aa = {}
local handle_misc = {}
local handle_callbacks ={}
local handle_visual= {}
handle_aa.vars = {
    snum = 1,
    def_yaw = -120,
    sway_stage = 1,
    tick_var3 = 0,
}
local last_sim_time = 0
local defensive_until = 0
local function is_defensive_active(local_player)
    local tickcount = globals.tickcount()
    local sim_time = toticks(entity.get_prop(local_player, "m_flSimulationTime"))
    local sim_diff = sim_time - last_sim_time

    if sim_diff < 0 then
        defensive_until = tickcount + math.abs(sim_diff) - toticks(client.latency())
    end
    
    last_sim_time = sim_time

    return defensive_until > tickcount
end

local setting = {}
handle_aa.way = function(mod,a,b,c,d,e)
    if mod == "3" then
        return handle_aa.vars.sway_stage == 1 and a or handle_aa.vars.sway_stage == 2 and b or handle_aa.vars.sway_stage == 3 and c
    else
        return handle_aa.vars.sway_stage == 1 and a or handle_aa.vars.sway_stage == 2 and b or handle_aa.vars.sway_stage == 3 and c or handle_aa.vars.sway_stage == 4 and d or handle_aa.vars.sway_stage == 5 and e
    end
end
handle_aa.normalize_yaw1 = function(p)
    while p > 180 do
        p = p - 360
    end
    while p < -180 do
        p = p + 360
    end
    return p
end

handle_aa.desync = function(a, b, name, cmd)
    local inverted = handle_aa.normalize_yaw1( antiaim_funcs.get_body_yaw(1) - antiaim_funcs.get_abs_yaw() ) > 0
    local invert = (math.floor(math.min(60, (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60)))) > 0

    if name == "Yaw" or name == "Jitter" then
        if cmd.chokedcommands == 0 then
            return invert and b or a
        end
    end

    if ui.get(staryaw.aa.bodyyaw[1]) == "Jitter" then
        return inverted and a or b
    elseif ui.get(staryaw.aa.bodyyaw[1]) == "Static" then
        return invert and a or b
    else
        return a
    end
end

handle_aa.slow_jitter = function (a, b, cmd, speed)
    local half = math.floor((speed/2) + 0.5)
    return (cmd.command_number % speed >= half) and b or a
end

local v ={
    dir = 0,
    m_states = 0,
    left = false,
    right = false,
    back = false,
    override_dt = nil
}
handle_aa.direction = function()

    local k = menu.anti_aim.keybind
    ui.set(k.manual_left,"On hotkey")
    ui.set(k.manual_right,"On hotkey")
    ui.set(k.manual_reset,"On hotkey")
    ui.set(staryaw.aa.fs[2],"Always on")
    local fs,edge = ui.get(k.freestanding),ui.get(k.edge_yaw)
    ui.set(staryaw.aa.fs[1], ui.get(k.freestanding))
    ui.set(staryaw.aa.edgeyaw,edge)
    if ui.get(k.legit_aa) then
        ui.set(staryaw.aa.fs[1], "-")
        ui.set(staryaw.aa.edgeyaw, false)
    end


    if ui.get(menu.misc.quickfall) then
        if v.override_dt~= nil then
            ui.set(staryaw.aa.dt[2],v.override_dt and "Always on" or "On hotkey")
        else
            ui.set(staryaw.aa.dt[2], ui.get(menu.misc.doubletap_key))
        end
    end

    m_states = ui.get(menu.anti_aim.temp_states)

    left , right , back  = ui.get(k.manual_left) , ui.get(k.manual_right) , ui.get(k.manual_reset)

    if left == v.left and right == v.right and back == v.back then return end

    v.left,v.right,v.back = left,right,back

    if (left and m_states == 1) or (right and m_states == 2) or (back and m_states == 3) then ui.set(menu.anti_aim.temp_states,0) return end

    if left and m_states ~= 1 then ui.set(menu.anti_aim.temp_states,1) end

    if right and m_states ~= 2 then ui.set(menu.anti_aim.temp_states,2) end

    if back and m_states ~= 3 then ui.set(menu.anti_aim.temp_states,3) end

    if ui.get(menu.anti_aim.temp_states) == 0 then v.dir = 0 end

    if ui.get(menu.anti_aim.temp_states) == 1 then v.dir = -90 end

    if ui.get(menu.anti_aim.temp_states) == 2 then v.dir = 90 end

    if ui.get(menu.anti_aim.temp_states) == 3 then v.dir = 0 end

end

local settings = {
	snum = 1,
	defensive = 0,
	checker = 0,	
	pitch = 0,
	jitter = false,
	def_yaw = -120,
	switchChoke= false

}

handle_aa.set_antiaim =function(cmd)
    local local_player = entity.get_local_player()
	if not entity.is_alive(local_player) then
		return
	end

    handle_aa.direction()
    local vx, vy = entity.get_prop(local_player, "m_vecVelocity")
	local speed = math.floor(math.min(10000, math.sqrt(vx*vx + vy*vy) + 0.5))
	local onground = (bit.band(entity.get_prop(local_player, "m_fFlags"), 1) == 1)
	local infiniteduck = (bit.band(entity.get_prop(local_player, "m_fFlags"), 2) == 2)
	local ekey = client.key_state(0x45)
    local onexploit = ui.get(staryaw.aa.dt[2]) or ui.get(staryaw.aa.os[2])
    local ongroud  = (bit.band(entity.get_prop(local_player, "m_fFlags"), 1) == 1)
    v.override_dt = nil
    if client.key_state(0x20) or not ongroud then
        if infiniteduck then
            if onexploit then
                handle_aa.vars.snum = 7
            else
                handle_aa.vars.snum = 6
            end
        else
            if onexploit then
                handle_aa.vars.snum = 5
            else
                handle_aa.vars.snum = 4
            end
        end
    elseif ongroud and infiniteduck or ongroud and ui.get(staryaw.aa.fakeduck) then
        handle_aa.vars.snum = 8
    elseif  ui.get(staryaw.aa.sw[1]) and ui.get(staryaw.aa.sw[2])then
        handle_aa.vars.snum = 9
    elseif ongroud and speed > 5 then
        handle_aa.vars.snum = 3
       
    else
        handle_aa.vars.snum = 2
    end

    local i = ui.get(menu.anti_aim.builder[handle_aa.vars.snum].enable) and handle_aa.vars.snum or 1
     setting.yawmod = "180" 
    setting.way =ui.get(menu.anti_aim.builder[i].yaw_sway)=="3-Way" and 3 or ui.get(menu.anti_aim.builder[i].yaw_sway)=="5-way" and 5 or 0

    if globals.tickcount() - handle_aa.vars.tick_var3 > 1 and globals.chokedcommands() == 1 then
		if handle_aa.vars.sway_stage < setting.way then 
            handle_aa.vars.sway_stage = handle_aa.vars.sway_stage + 1
        elseif handle_aa.vars.sway_stage >= setting.way then
            handle_aa.vars.sway_stage = 1
        end
		handle_aa.vars.tick_var3 = globals.tickcount()
	elseif globals.tickcount() - handle_aa.vars.tick_var3 < -1 then
		handle_aa.vars.tick_var3 = globals.tickcount()
	end
    setting.yaw = ui.get(menu.anti_aim.builder[i].yaw)
    setting.jitter = ui.get(menu.anti_aim.builder[i].jitter)
    setting.byaw = ui.get(menu.anti_aim.builder[i].byaw)
    setting.fakelimit = ui.get(menu.anti_aim.builder[i].fakelimit)
    -- yawspeed
    if ui.get(menu.anti_aim.builder[i].yawlr_sett) == "L&R" then
        setting.yaw = handle_aa.desync(ui.get(menu.anti_aim.builder[i].yawl),ui.get(menu.anti_aim.builder[i].yawr), "Yaw", cmd)
        setting.jitter = handle_aa.desync(ui.get(menu.anti_aim.builder[i].jitterl),ui.get(menu.anti_aim.builder[i].jitterr), "Jitter", cmd)
        setting.byaw = handle_aa.desync(ui.get(menu.anti_aim.builder[i].byawl),ui.get(menu.anti_aim.builder[i].byawr))
        setting.fakelimit = handle_aa.desync(ui.get(menu.anti_aim.builder[i].fakelimitl),ui.get(menu.anti_aim.builder[i].fakelimitr))
    elseif ui.get(menu.anti_aim.builder[i].yawlr_sett) == "Slow jitter" then
        local speed = ui.get(menu.anti_aim.builder[i].yawspeed)

        setting.yaw = handle_aa.slow_jitter(ui.get(menu.anti_aim.builder[i].yawl),ui.get(menu.anti_aim.builder[i].yawr), cmd, speed)
        setting.jitter = handle_aa.slow_jitter(ui.get(menu.anti_aim.builder[i].jitterl),ui.get(menu.anti_aim.builder[i].jitterr), cmd, speed)
        setting.byaw = handle_aa.slow_jitter(ui.get(menu.anti_aim.builder[i].byawl),ui.get(menu.anti_aim.builder[i].byawr), cmd, speed)
        setting.fakelimit = handle_aa.slow_jitter(ui.get(menu.anti_aim.builder[i].fakelimitl),ui.get(menu.anti_aim.builder[i].fakelimitr), cmd, speed)
    end

    if ui.get(menu.anti_aim.builder[i].yaw_sway) == "3-Way" then
        if ui.get(menu.anti_aim.builder[i].yawlr_sett) == "Yaw L&R" then
            setting.yaw = handle_aa.way("3",ui.get(menu.anti_aim.builder[i].yaws1),setting.yaw,ui.get(menu.anti_aim.builder[i].yaws2)+ handle_aa.desync(-1 * ui.get((menu.anti_aim.builder[i].jitterl) / 2),
            ui.get(menu.anti_aim.builder[i].jitterr) / 2),0,0)
        else
            setting.yaw = handle_aa.way("3",ui.get(menu.anti_aim.builder[i].yaws1),setting.yaw,ui.get(menu.anti_aim.builder[i].yaws2),0,0)
        end
    elseif ui.get(menu.anti_aim.builder[i].yaw_sway) == "5-way" then
        if ui.get(menu.anti_aim.builder[i].yawlr_sett) == "Yaw L&R" then
            setting.yaw = handle_aa.way("5",ui.get(menu.anti_aim.builder[i].yaws1),ui.get(menu.anti_aim.builder[i].yaws2),setting.yaw,ui.get(menu.anti_aim.builder[i].yaws3),ui.get(menu.anti_aim.builder[i].yaws4)) + chokerev(-1 * (ui.get(menu.anti_aim.builder[i].jitterl) / 2),ui.get(menu.anti_aim.builder[i].jitterr) / 2)
        else
            setting.yaw = handle_aa.way("5",ui.get(menu.anti_aim.builder[i].yaws1),ui.get(menu.anti_aim.builder[i].yaws2),setting.yaw,ui.get(menu.anti_aim.builder[i].yaws3),ui.get(menu.anti_aim.builder[i].yaws4))
        end
    end



    settings.yaw = nil
    settings.pitch = "Down"
    if ui.get(menu.anti_aim.builder[i].Defensive) then
        if ui.get(menu.anti_aim.builder[i].Defensive_breaker) =="Always On" then
			cmd.force_defensive = 1
		else
			cmd.force_defensive = 0
		end
		local tickcountValidation do
            tickcountValidation = globals.tickcount() % 4 == 0
    
            if tickcountValidation then
                setting.switchChoke = not settings.switchChoke
            end
        end
		if is_defensive_active(entity.get_local_player())  then
			local def_yaw = ui.get(menu.anti_aim.builder[i].Defensive_Yaw_Mod) 
			if def_yaw == "Center" then
				if(globals.chokedcommands() == 0) then
					settings.jitter = not settings.jitter
				end
				settings.yaw = settings.jitter and ui.get(menu.anti_aim.builder[i].Defensive_Center)  / -2 or ui.get(menu.anti_aim.builder[i].Defensive_Center) / 2
			elseif  def_yaw == "Random" then
				settings.yaw = math.random(-180,180)
			elseif def_yaw== "Spin" then
				if globals.realtime() - globals.realtime() < 1 then
					settings.def_yaw = settings.def_yaw + ui.get(menu.anti_aim.builder[i].Defensive_Spin)
					if settings.def_yaw >= 180 then
						settings.def_yaw = -180
					end
				end
				settings.yaw = settings.def_yaw
			elseif def_yaw== "Circular" then
				if globals.realtime() - globals.realtime() < 1 then
					settings.def_yaw = settings.def_yaw + ui.get(menu.anti_aim.builder[i].Defensive_Spin)
					if settings.def_yaw >= 90 then
						settings.def_yaw = -90
					end
				end
				settings.yaw = settings.def_yaw
			elseif def_yaw== "Down" then
				settings.yaw = math.random(-180,-145)
			elseif def_yaw== "Without" then
			elseif def_yaw == "Switch Left" then
				settings.yaw =settings.switchChoke and 90 or 0
			elseif def_yaw == "Switch Right" then
				settings.yaw =settings.switchChoke and 0 or 90
			elseif def_yaw == "Free Sway" then
				settings.yaw =settings.switchChoke and math.random(0, 168) or math.random(-168, -31)
			end
			local pitch =ui.get(menu.anti_aim.builder[i].Defensive_Pitch)
			if pitch == "Custom" then
				settings.pitch =  ui.get(menu.anti_aim.builder[i].Defensive_Custom_Pitch)
			elseif pitch == "Random" then
				settings.pitch = math.random(-89, 89)
			elseif pitch == "Paketa" then
				local paketa = math.random(1,3)
				if  paketa == 3 then
					settings.pitch = -55 
				elseif paketa == 2 then
					settings.pitch = -5
				elseif paketa == 1 then
					settings.pitch = 89
				end
            elseif  pitch == "Paketa 2" then
                local paketa2 = math.random(1,4)
				if  paketa2 == 3 then
					settings.pitch = -55 
                elseif paketa2 == 4 then
                    settings.pitch = -89
				elseif paketa2 == 2 then
					settings.pitch = -5
				elseif paketa2 == 1 then
					settings.pitch = 89
				end
			elseif pitch == "Switch Up" then
				settings.pitch = settings.switchChoke and 0 or -89
			elseif pitch == "Switch Down" then
				settings.pitch = settings.switchChoke and 0 or 89
			elseif pitch == "Increase Up" then
				settings.pitch = settings.switchChoke and -89 or 89
			end
		end
    else
        settings.yaw = nil
        settings.pitch = "Down"
    end

    if setting.fakelimit == 60 then
        setting.fakelimit = 59
    end
	local mwork = ui.get(menu.anti_aim.temp_states) ~= 0
	if mwork then
		setting.yaw = ui.get(menu.anti_aim.temp_states) == 1 and -85 or ui.get(menu.anti_aim.temp_states) == 2 and 87 or setting.yaw
	end
    if mwork then
    	ui.set(staryaw.aa.yawbase,"Local view")
	else
		ui.set(staryaw.aa.yawbase,"At targets")
	end

    if type(settings.pitch) == "number" then
        ui.set(staryaw.aa.pitch[1], "Custom")
        ui.set(staryaw.aa.pitch[2], settings.pitch)
    else
        ui.set(staryaw.aa.pitch[1], settings.pitch)
    end

    ui.set(staryaw.aa.yaw[1],setting.yawmod)
    ui.set(staryaw.aa.yaw[2], settings.yaw or setting.yaw)
    ui.set(staryaw.aa.yawjitter[1],ui.get(menu.anti_aim.builder[i].jittermode))
    ui.set(staryaw.aa.yawjitter[2],setting.jitter)
    ui.set(staryaw.aa.bodyyaw[1],ui.get(menu.anti_aim.builder[i].byawmode))
    ui.set(staryaw.aa.bodyyaw[2],setting.byaw)
   -- ui.set(staryaw.aa.fakeyawlimit,setting.fakelimit)
end
handle_aa.defensive = function()
    local tickcount = globals.tickcount()
    local sim_time = toticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local sim_diff = sim_time - last_sim_time

    if sim_diff < 0 then
        defensive_until = tickcount + math.abs(sim_diff) - toticks(client.latency())
    end
    
    last_sim_time = sim_time

    return defensive_until > tickcount
end
handle_aa.onshotfix = function()

end
handle_aa.extrapolate_player_position = function(player, origin, ticks)
    local vel = {entity.get_prop(player, "m_vecVelocity")}

    if vel[1] == nil then
        return nil
    end

    local pred_tick = globals.tickinterval() * ticks

    return {
        origin[1] + (vel[1] * pred_tick),
        origin[2] + (vel[2] * pred_tick),
        origin[3] + (vel[3] * pred_tick)
    }
end
handle_aa.quickfall = function (cmd)

    if ui.get(menu.misc.quickfall) == false or ui.get(menu.misc.quick_fall_hotkey) == false then
        return
    end

    local air = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags") or 0, 1) == 0

    if air == false or cmd.in_jump == 1 or ui.get(staryaw.aa.dt[1]) == false or ui.get(staryaw.aa.dt[2]) == false then
        return
    end

    local origin = {entity.get_origin(entity.get_local_player())}

    if origin[1] == nil then
        return
    end

    local speed = ui.get(menu.misc.quickfall_mode) == "Favor quicker fall" and 17 or 0
    local pred_origin = handle_aa.extrapolate_player_position(entity.get_local_player(), origin, 12 + speed)

    if pred_origin[1] ~= nil then
        local trace = {client.trace_line(entity.get_local_player(), origin[1], origin[2], origin[3], pred_origin[1], pred_origin[2], pred_origin[3])}

        if trace[1] ~= 1 then
            v.override_dt = false
        end
    end
end
handle_aa.fast_ladder = function (cmd)
	if not ui.get(menu.misc.fast_ladder) then return end

	local local_player = entity.get_local_player()
	local pitch, yaw = client.camera_angles()

	if (entity.get_prop(local_player, 'm_MoveType') == 9) then
		cmd.yaw = math.floor(cmd.yaw+0.5)

		-- 往上爬
		if cmd.forwardmove > 0 then
			if pitch < 45 then
				cmd.pitch = 89
				cmd.in_moveright = 1
				cmd.in_moveleft = 0
				cmd.in_forward = 0
				cmd.in_back = 1
				if cmd.sidemove == 0 then
					cmd.yaw = cmd.yaw + 90
				end
				if cmd.sidemove < 0 then
					cmd.yaw = cmd.yaw + 150
				end
				if cmd.sidemove > 0 then
					cmd.yaw = cmd.yaw + 30
				end
			end 
		end

		-- 往下爬
		if cmd.forwardmove < 0 then
			cmd.pitch = 89
			cmd.in_moveleft = 1
			cmd.in_moveright = 0
			cmd.in_forward = 1
			cmd.in_back = 0
			if cmd.sidemove == 0 then
				cmd.yaw = cmd.yaw + 90
			end
			if cmd.sidemove > 0 then
				cmd.yaw = cmd.yaw + 150
			end
			if cmd.sidemove < 0 then
				cmd.yaw = cmd.yaw + 30
			end
		end
	end
end
handle_misc.killsay_value = {
    "𝕤𝕥𝕠𝕡 𝕥𝕣𝕪𝕚𝕟𝕘 𝕣𝕖𝕥𝕒𝕣𝕕, 𝕦 𝕨𝕠𝕟𝕥 𝕜𝕚𝕝𝕝 𝕞𝕖",
    "staryaw BEST",
    ",EZ",
    "XAXAXAXAXAXA (◣_◢)",
    "what you do dog??",
    "show me your attitude boy",
    "ezshot on walkbot xaxaxaxaxa",
    "我希望你再去练练",
    "并不是很耀眼的操作",
    "ezshot on walkbot xaxaxaxaxa",
}
handle_misc.killsay = function()
    if ui.get(menu.misc.killsay) then
        local sendconsole = client.exec
        local _first = handle_misc.killsay_value[math.random(1, #handle_misc.killsay_value)]
        if _first ~= nil  then
            local say = 'say ' .._first
           sendconsole(say)
        end
    end
end
handle_misc.anti_knife = function()
    if ui.get(menu.misc.anti_knife) then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
        local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")
        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = math.sqrt((x - lx)^2 + (y - ly)^2 + (z - lz)^2)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= 330 then
                ui.set(yaw_slider,180)
            end
        end
    end
end
local ground_ticks, end_time = 1, 0
handle_misc.Animation_Breaker = function()

    if not entity.is_alive(entity.get_local_player()) then
        return
    end
    local me = ent.get_local_player()
    local m_fFlags = me:get_prop("m_fFlags")
    local is_onground = bit.band(m_fFlags, 1) ~= 0
    if table_contains(ui.get(menu.misc.Animation_Breaker),'0 Pitch on Land') then
        local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)

        if on_ground == 1 then
            ground_ticks = ground_ticks + 1
        else
            ground_ticks = 0
            end_time = globals.curtime() + 1
        end 
    
        if ground_ticks > ui.get(ui.reference("AA", "Fake lag", "Limit"))+1 and end_time > globals.curtime() then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
        end
    end
    if table_contains(ui.get(menu.misc.Animation_Breaker),'Legs in Air') and not ui.get(menu.misc.legs_Air) then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
    elseif table_contains(ui.get(menu.misc.Animation_Breaker),'Legs in Air') and ui.get(menu.misc.legs_Air) then
        if not is_onground then
            local my_animlayer = me:get_anim_overlay(6) 
            my_animlayer.weight = 1
        end
    end
    if table_contains(ui.get(menu.misc.Animation_Breaker),'Legs Fucker') and not ui.get(menu.misc.legs_Ground) then
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
        ui.set(ui.reference("AA", "other", "leg movement"), "always slide")
    elseif table_contains(ui.get(menu.misc.Animation_Breaker),'Legs Fucker') and ui.get(menu.misc.legs_Ground) then
        ui.set(ui.reference("AA", "other", "leg movement"), "Off")
        entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 7)
    end






end

handle_visual.var = {
    scoped_fraction = 0,
	fraction = 0,
    dt_color = 0,
    inactive_fraction = 0,
    active_fraction = 0,
}
handle_visual.lerp=function(e,f,g)
    return e+(f-e)*g 
end;
handle_visual.rgba_to_hex = function(b, c, d, e)
    return string.format('%02x%02x%02x%02x', b, c, d, e)
end
handle_visual.clamp =function (x, minval, maxval)
    if x < minval then
        return minval
    elseif x > maxval then
        return maxval
    else
        return x
    end
end
handle_visual.text_fade_animation =  function (x, y, speed, color1, color2, text)
    local final_text = ''
    local curtime = globals.curtime()
    for i = 0, #text do
        local x = i * 10  
        local wave = math.cos(2 * speed * curtime / 4 + x / 30)
        local color = handle_visual.rgba_to_hex(
            handle_visual.lerp(color1.r, color2.r, handle_visual.clamp(wave, 0, 1)),
            handle_visual.lerp(color1.g, color2.g, handle_visual.clamp(wave, 0, 1)),
            handle_visual.lerp(color1.b, color2.b, handle_visual.clamp(wave, 0, 1)),
            color1.a
        ) 
        final_text = final_text .. '\a' .. color .. text:sub(i, i) 
    end
    
    renderer.text(x, y, color1.r, color1.g, color1.b, color1.a, "c-", nil, final_text )
end
handle_visual.m_render = {
    rec = function(self, x, y, w, h, radius, color)
        radius = math.min(x/2, y/2, radius)
        local r, g, b, a = unpack(color)
        renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
        renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
        renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
        renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
        renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
        renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
        renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
    end,

    rec_outline = function(self, x, y, w, h, radius, thickness, color)
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
    end,

    glow_module = function(self, x, y, w, h, width, rounding, accent, accent_inner)
        local thickness = 1
        local offset = 1
        local r, g, b, a = unpack(accent)
        if accent_inner then
            self:rec(x , y, w, h + 1, rounding, accent_inner)
            --renderer.blur(x , y, w, h)
            --m_render.rec_outline(x + width*thickness - width*thickness, y + width*thickness - width*thickness, w - width*thickness*2 + width*thickness*2, h - width*thickness*2 + width*thickness*2, color(r, g, b, 255), rounding, thickness)
        end
        for k = 0, width do
            if a * (k/width)^(1) > 5 then
                local accent = {r, g, b, a * (k/width)^(2)}
                self:rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
            end
        end
    end,
}
handle_visual.indicators_render = function()
    local me = entity.get_local_player()

    if not me or not entity.is_alive(me) or not ui.get(menu.visual.center_indicator) then
        return
    end
	local x, y = client.screen_size()
	local r, g, b = ui.get(menu.visual.color)

    local r1, g2, b3 = ui.get(menu.visual.color2)
    local scoped = entity.get_prop(me, "m_bIsScoped") == 1
    handle_visual.var.scoped_fraction = handle_visual.lerp(handle_visual.var.scoped_fraction, scoped and 40 or 0,globals.frametime() * 12)

    if ui.get(menu.visual.center_mode) == "Text" then
 
        local next_attack = entity.get_prop(me, "m_flNextAttack")
        local strike_w, strike_h = renderer.measure_text("-", "1STAR YAW")
        local aaa_alpha = math.floor(math.sin(globals.realtime() * 4) * (255/3-1) + 255/2) or 255
        local next_primary_attack = entity.get_prop(entity.get_player_weapon(me), "m_flNextPrimaryAttack")
        if next_attack ==nil or next_primary_attack == nil then
            return
        end
        local dt_active = not (math.max(next_primary_attack, next_attack) > globals.curtime()) 
 
        handle_visual.var.dt_color =  handle_visual.lerp(handle_visual.var.dt_color,dt_active and 255 or 0 ,globals.frametime() * 18.214)
        handle_visual.var.inactive_fraction = handle_visual.lerp(handle_visual.var.inactive_fraction,ui.get(staryaw.aa.dt[2]) and 255 or 0, globals.frametime() * 18.214)
        handle_visual.var.active_fraction =handle_visual.lerp(handle_visual.var.active_fraction,ui.get(staryaw.aa.dt[2]) and strike_h or 0, globals.frametime() * 12)
        handle_visual.text_fade_animation(x/2 + handle_visual.var.scoped_fraction, y/2 + 20, ui.get(menu.visual.speed), {r=r, g=g, b=b, a=255}, {r=r1, g=g2, b=b3, a=255}, "1STAR YAW")
        handle_visual.m_render:glow_module(x/2 + handle_visual.var.scoped_fraction - strike_w/2 + 4, y/2 + 20, strike_w - 3, 0, 10, 0, {r, g, b, 100 * math.abs(math.cos(globals.curtime()*2))}, {r, g, b, 100 * math.abs(math.cos(globals.curtime()*2))})

        renderer.text(x/2 + handle_visual.var.scoped_fraction,  y/2 + 20+strike_h, 255, handle_visual.var.dt_color, handle_visual.var.dt_color, handle_visual.var.inactive_fraction, "c-", nil, "DT" )
        local indicators = {}
        local function create(name, col)
            indicators[#indicators + 1] = {
                name = name,
                color = col,
                size = {renderer.measure_text("-", name)}
            }
        end
        local white = {255, 255, 255, 255}
        local disabled_color = {100, 100, 100, 195}
        create("", ui.get(staryaw.aa.os[2]) and white or disabled_color)
        create("",  ui.get(staryaw.aa.fakeduck) and white or disabled_color)
        create("", ui.get(menu.anti_aim.keybind.freestanding) and white or disabled_color)
        create("", ui.get(staryaw.aa.baim) and white or disabled_color)
    
        local x_offset = -25
        local ind_offset = (55 / #indicators) 
        for i = 1, #indicators do
            local indicator = indicators[i]
            renderer.text(x/2 + x_offset+handle_visual.var.scoped_fraction,y/2+20+strike_h+handle_visual.var.active_fraction, indicator.color[1], indicator.color[2], indicator.color[3], indicator.color[4],"c-", nil,indicator.name)
            x_offset = math.floor(x_offset + ind_offset + indicator.size[1] / #indicators)
        end
    elseif   ui.get(menu.visual.center_mode) == "Icon" then
        local svg  = '<svg t="1678609242861" class="icon" viewBox="0 0 1080 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="10651" width="200" height="200"><path d="M370.176 990.549333l120.775111-65.706666c34.133333-17.009778 78.506667-19.171556 118.328889 3.697777l122.709333 63.943112c92.046222 48.014222 195.754667-23.438222 181.191111-126.976l-23.552-138.865778c-5.632-39.822222 9.272889-78.506667 37.774223-106.894222l100.352-95.345778c75.264-71.509333 33.450667-195.584-66.673778-214.016l-136.476445-17.408a132.835556 132.835556 0 0 1-90.851555-68.494222l-62.293333-125.269334C626.119111 8.078222 495.331556 2.104889 447.317333 94.151111L383.317333 216.917333c-19.399111 35.214222-52.451556 60.131556-92.330666 65.763556l-135.395556 19.000889C55.466667 311.751111 11.889778 435.655111 86.812444 506.368l95.345778 100.352c28.444444 28.444444 41.984 67.185778 31.630222 109.226667l-25.315555 137.671111c-13.937778 103.537778 90.567111 182.215111 181.703111 136.931555" fill="#FED44A" p-id="10652"></path><path d="M192.967111 857.031111l25.372445-137.671111c10.353778-42.040889-7.793778-84.195556-36.181334-112.64L86.812444 506.311111C40.277333 464.156444 39.310222 399.303111 69.006222 350.435556 25.543111 445.895111 237.056 505.571556 317.667556 559.217778c84.081778 49.095111 55.466667 134.371556 55.466666 134.371555s-43.463111 95.459556-100.579555 209.123556c-48.014222 92.046222 38.456889 100.238222 66.901333 100.295111-87.608889 12.288-162.588444-58.424889-146.488889-145.976889" fill="#FFDE73" p-id="10653"></path><path d="M750.364444 400.896c-89.884444-3.584-113.550222-85.560889-113.550222-85.560889s-21.390222-94.492444-38.172444-214.016C573.838222-17.009778 482.645333 56.661333 482.645333 56.661333c58.140444-48.753778 153.713778-33.735111 188.814223 42.552889l62.293333 125.269334c16.952889 34.190222 53.304889 61.610667 90.851555 68.494222l137.614223 25.372444c62.577778 11.491556 102.286222 62.805333 102.115555 119.694222-3.413333 4.551111-2.275556 12.515556-9.102222 21.617778-8.931556-92.216889-210.432-51.768889-304.810667-58.766222" fill="#FEC54A" p-id="10654"></path><path d="M253.269333 881.038222c17.066667 5.745778 32.995556 3.527111 38.684445-13.539555l52.622222-117.077334c5.688889-17.066667-1.080889-36.408889-18.147556-42.097777-13.653333-10.296889-28.444444-0.113778-38.684444 13.539555l-56.035556 121.571556c-2.275556 12.515556 4.494222 31.857778 21.560889 37.603555" fill="#FFF2CA" p-id="10655"></path></svg>'
        local icon = renderer.load_svg(svg,50,50)
        renderer.texture(icon,x/2-20+handle_visual.var.scoped_fraction ,y/2+20,32,30, 255,255,255,175 * entity.get_prop(entity.get_local_player(), "m_flVelocityModifier"),'f' )

    end
  

end

handle_visual.min_dmg = function ()
    local localplayer = entity.get_local_player()
    if not localplayer or not entity.is_alive(localplayer) or not ui.get(menu.visual.min_dmg) then return end

    local screen_size = {client.screen_size()}

    local current_min
    if ui.get(staryaw.aa.min_ovr[1]) and ui.get(staryaw.aa.min_ovr[2]) then
        current_min = ui.get(staryaw.aa.min_ovr[3])
    else
        current_min = ui.get(staryaw.aa.dmg)
    end

    renderer.text(screen_size[1]/2+15, screen_size[2]/2-15, 255,255,255,255, "", 0, tostring(current_min))
end


handle_callbacks.paint = function()
    handle_visual.min_dmg()
    handle_visual.indicators_render()
end
handle_callbacks.paint_ui = function()
    visible()
end
handle_callbacks.setup_command = function(cmd)
    handle_aa.set_antiaim (cmd)
    handle_misc.anti_knife()
    handle_aa.onshotfix ()
	handle_aa.quickfall(cmd)
	handle_aa.fast_ladder(cmd)
end
handle_callbacks.aim_hit = function()
    handle_misc.killsay()
end
handle_callbacks.pre_render = function()
    handle_misc.Animation_Breaker()
end
function start()
    client.set_event_callback("paint", handle_callbacks.paint) 
    client.set_event_callback("paint_ui",  handle_callbacks.paint_ui)
    client.set_event_callback("setup_command", handle_callbacks.setup_command)
    client.set_event_callback("aim_hit", handle_callbacks.aim_hit)
    client.set_event_callback("pre_render", handle_callbacks.pre_render)
end
start()