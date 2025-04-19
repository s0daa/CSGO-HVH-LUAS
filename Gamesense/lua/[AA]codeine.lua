-- Codeine.lua by d3


local MenuSelection = gui.add_combo("Menu Selection", "lua>tab b", {"Home", "Ragebot Addons", "AA Addons", "Widgets", "Others", "Colors"})
local name =  gui.add_textbox("Main User", "LUA>TAB B")

-- ragebot

local resolver_reference = gui.get_config_item("rage>aimbot>aimbot>resolver mode")
local dsbfk = gui.add_checkbox("Disable Fakelag on HS", "lua>tab b")

-- visuals

local watermarkd = gui.add_checkbox("Watermark", "lua>tab b")
local infobar = gui.add_checkbox("Info Tab", "lua>tab b")
local arrowsn = gui.add_checkbox("Arrows", "lua>tab b")
local keybinds = gui.add_checkbox("Keybinds", "lua>tab b")
local indicatorsmain = gui.add_checkbox("Indicators", "lua>tab b")
local indicatorstype = gui.add_combo("Indicators | Type", "lua>tab b", {"Type 1", "Old"})
local infotabflag = gui.add_combo("Info Tab | Flag", "lua>tab b", {"Russia", "Germany", "Estonia", "Hungary", "Reichsflagge"})

-- others

local trashtalk = gui.add_checkbox("Trash talk", "lua>tab b")
local sound = gui.add_checkbox("Custom Sounds", "lua>tab b")
local soundsel = gui.add_combo("Select", "lua>tab b", {"Aways", "Flick", "Stapler"})
local clantag = gui.add_checkbox("Clantag", "lua>tab b")
local clantagtype = gui.add_combo("Clantag Type", "lua>tab b", {"Old", "Type 1", "Type 2"})
local aspectratiobutton = gui.add_checkbox("Aspect ratio", "lua>tab b")
local aspect_ratio_slider = gui.add_slider("[value]", "lua>tab b", 1, 200, 1)

-- aa addons

local Checkbox = gui.add_checkbox("Clock Inverter", "lua>tab b")
local keybind = gui.add_keybind("lua>tab b>Clock Inverter")

-- colors

local watermark_bcolor = gui.add_checkbox("Watermark Color", "lua>tab b")
local watermark_color = gui.add_colorpicker("lua>tab b>watermark color", true)
local keybinds_bcolor = gui.add_checkbox("Keybinds Color", "lua>tab b")
local keybinds_color = gui.add_colorpicker("lua>tab b>keybinds color", true)
local infobar_bcolor = gui.add_checkbox("Infobar Color", "lua>tab b")
local infobar_color = gui.add_colorpicker("lua>tab b>infobar color", true)
local indicator_bcolor = gui.add_checkbox("Indicator Color", "lua>tab b")
local indicator_color = gui.add_colorpicker("lua>tab b>indicator color", true)

local WorkAA = gui.add_checkbox("AntiAim Builder", "lua>tab b")

local States = gui.add_combo("Choose AntiAim Condition:", "lua>tab b", {"[None]", "[Standing]", "[Moving]","[Slow Walking]","[Crouching]","[In Air]"})


local standing_jittertoggle = gui.add_checkbox("[Standing] Jitter", "lua>tab b")
local standing_jitterrange = gui.add_slider("[Standing] Jitter range", "lua>tab b", 0, 360, 0)
local standing_faketoggle = gui.add_checkbox("[Standing] Fake", "lua>tab b")
local standing_fakeamount = gui.add_slider("[Standing] Fake Amount", "lua>tab b", 0, 100, 0)
local standing_compangle = gui.add_slider("[Standing] Compensate Angle", "lua>tab b", 0, 100, 0)
local standing_fakejitter= gui.add_checkbox("[Standing] Jitter Fake", "lua>tab b")

local moving_jittertoggle = gui.add_checkbox("[Moving] Jitter", "lua>tab b")
local moving_jitterrange = gui.add_slider("[Moving] Jitter range", "lua>tab b", 0, 360, 0)
local moving_faketoggle = gui.add_checkbox("[Moving] Fake", "lua>tab b")
local moving_fakeamount = gui.add_slider("[Moving] Fake Amount", "lua>tab b", 0, 100, 0)
local moving_compangle = gui.add_slider("[Moving] Compensate Angle", "lua>tab b", 0, 100, 0)
local moving_fakejitter= gui.add_checkbox("[Moving] Jitter Fake", "lua>tab b")

local slowwalk_jittertoggle = gui.add_checkbox("[Slow Walking] Jitter", "lua>tab b")
local slowwalk_jitterrange = gui.add_slider("[Slow Walking] Jitter range", "lua>tab b", 0, 360, 0)
local slowwalk_faketoggle = gui.add_checkbox("[Slow Walking] Fake", "lua>tab b")
local slowwalk_fakeamount = gui.add_slider("[Slow Walking] Fake Amount", "lua>tab b", 0, 100, 0)
local slowwalk_compangle = gui.add_slider("[Slow Walking] Compensate Angle", "lua>tab b", 0, 100, 0)
local slowwalk_fakejitter= gui.add_checkbox("[Slow Walking] Jitter Fake", "lua>tab b")


local crouching_jittertoggle = gui.add_checkbox("[Crouching] Jitter", "lua>tab b")
local crouching_jitterrange = gui.add_slider("[Crouching] Jitter range", "lua>tab b", 0, 360, 0)
local crouching_faketoggle = gui.add_checkbox("[Crouching] Fake", "lua>tab b")
local crouching_fakeamount = gui.add_slider("[Crouching] Fake Amount", "lua>tab b", 0, 100, 0)
local crouching_compangle = gui.add_slider("[Crouching] Compensate Angle", "lua>tab b", 0, 100, 0)
local crouching_fakejitter= gui.add_checkbox("[Crouching] Jitter Fake", "lua>tab b")

local air_jittertoggle = gui.add_checkbox("[In Air] Jitter", "lua>tab b")
local air_jitterrange = gui.add_slider("[In Air] Jitter range", "lua>tab b", 0, 360, 0)
local air_faketoggle = gui.add_checkbox("[In Air] Fake", "lua>tab b")
local air_fakeamount = gui.add_slider("[In Air] Fake Amount", "lua>tab b", 0, 100, 0)
local air_compangle = gui.add_slider("[In Air] Compensate Angle", "lua>tab b", 0, 100, 0)
local air_fakejitter= gui.add_checkbox("[In Air] Jitter Fake", "lua>tab b")

-- data
local nextfont = render.create_font("calibri.ttf", 23, render.font_flag_shadow)
local nextfont2 = render.create_font("calibri.ttf", 13, render.font_flag_shadow)
local nextfont3 = render.create_font("calibrib.ttf", 23, render.font_flag_shadow)
local fontdmg = render.create_font("verdana.ttf", 13, render.font_flag_shadow)
local pixel = render.font_esp
local calibri11 = render.create_font("calibri.ttf", 11, render.font_flag_outline)
local calibri13 = render.create_font("calibri.ttf", 13, render.font_flag_shadow)
local verdana = render.create_font("verdana.ttf", 13, render.font_flag_outline)
local tahoma = render.create_font("tahoma.ttf", 13, render.font_flag_shadow)
local verdana2 = render.create_font("verdana.ttf", 12, 0)
local logo = render.create_font("verdana.ttf", 45, render.font_flag_outline)

-- vars

local clipboard = require("clipboard")

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local function enc(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

-- decoding
local function dec(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
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

local function animation(check, name, value, speed) 
    if check then 
        return name + (value - name) * global_vars.frametime * speed / 1.5
    else 
        return name - (value + name) * global_vars.frametime * speed / 1.5
        
    end
end

local x, y = render.get_screen_size()
local hs = gui.get_config_item("Rage>Aimbot>Aimbot>Hide shot")
local limit = gui.get_config_item("Rage>Anti-Aim>Fakelag>Limit")
local cache = {
    backup = limit:get_int(),
    override = false,
}

local first = {
    'renew poor cantina subscription',
    'buy Codeine.lua for fatality',
    'kys poor freak',
    'ur mom adored my black cum',
    'smellin your mommas perfume',
    '1',
    'l2p botik',
    'refund spirtware',
    'get fatal with Codeine',
    'u sell that hs?',
    'ez nigga'
}
local old_time = 0;
local animation = { --change the text to whatever you want for your clantag

    "℞ c ",
    "℞ co ",
    "℞ cod ",
    "℞ code ",
    "℞ codei ",
    "℞ codein ",
    "℞ codeine ",
    "℞ codein ",
    "℞ codei ",
    "℞ code ",
    "℞ cod ",
    "℞ co ",
    "℞ c ",
  
}

local animation2 = { --change the text to whatever you want for your clantag

    " c ",
    " co ",
    " cod ",
    " code ",
    " codei ",
    " codein ",
    " codeine ",
    "  codein ",
    " c codei ",
    " co code ",
    " cod cod ",
    " code co ",
    " codei c ",
    " codein c ",
    " codeine ",
    " codeine",
    " codein ",
    " codei ",
    " code ",
    " cod ",
    " co ",
    " c ",

  
}
local animation3 = { --change the text to whatever you want for your clantag

    "c ",
    "co ",
    "cod ",
    "code ",
    "codei ",
    "codein ",
    "codeine ",
    "codeine. ",
    "codeine.l ",
    "codeine.lu ",
    "codeine.lua ",
    "codeine.lu ",
    "codeine.l ",
    "codeine. ",
    "codeine ",
    "codein ",
    "codei ",
    "code ",
    "cod ",
    "co ",

  
}

local configs = {}

configs.import = function(input)
    local protected = function()
        local clipboardP = input == nil and dec(clipboard.get()) or input
        local tbl = str_to_sub(clipboardP, "|")
        aspectratiobutton:set_bool(to_boolean(tbl[1]))
        aspect_ratio_slider:set_int(tonumber(tbl[2]))
        infotabflag:set_int(tonumber(tbl[3]))
        indicatorstype:set_int(tonumber(tbl[4]))
        clantagtype:set_int(tonumber(tbl[5]))
        soundsel:set_int(tonumber(tbl[6]))
        sound:set_bool(to_boolean(tbl[7]))
        trashtalk:set_bool(to_boolean(tbl[8]))
        indicatorsmain:set_bool(to_boolean(tbl[9]))
        clantag:set_bool(to_boolean(tbl[10]))
        keybinds:set_bool(to_boolean(tbl[11]))
        arrowsn:set_bool(to_boolean(tbl[12]))
        watermarkd:set_bool(to_boolean(tbl[13]))
        infobar:set_bool(to_boolean(tbl[14]))
        dsbfk:set_bool(to_boolean(tbl[15]))
        air_fakejitter:set_bool(to_boolean(tbl[17]))
        air_faketoggle:set_bool(to_boolean(tbl[18]))
        air_jittertoggle:set_bool(to_boolean(tbl[19]))
        air_jitterrange:set_int(tonumber(tbl[20]))
        air_compangle:set_int(tonumber(tbl[21]))
        air_fakeamount:set_int(tonumber(tbl[22]))
        crouching_fakejitter:set_bool(to_boolean(tbl[23]))
        crouching_faketoggle:set_bool(to_boolean(tbl[24]))
        crouching_jittertoggle:set_bool(to_boolean(tbl[25]))
        crouching_jitterrange:set_int(tonumber(tbl[26]))
        crouching_compangle:set_int(tonumber(tbl[27]))
        crouching_fakeamount:set_int(tonumber(tbl[28]))
        slowwalk_fakejitter:set_bool(to_boolean(tbl[29]))
        slowwalk_faketoggle:set_bool(to_boolean(tbl[30]))
        slowwalk_jittertoggle:set_bool(to_boolean(tbl[31]))
        slowwalk_jitterrange:set_int(tonumber(tbl[32]))
        slowwalk_compangle:set_int(tonumber(tbl[33]))
        slowwalk_fakeamount:set_int(tonumber(tbl[34]))
        moving_fakejitter:set_bool(to_boolean(tbl[35]))
        moving_faketoggle:set_bool(to_boolean(tbl[36]))
        moving_jittertoggle:set_bool(to_boolean(tbl[37]))
        moving_jitterrange:set_int(tonumber(tbl[38]))
        moving_compangle:set_int(tonumber(tbl[39]))
        moving_fakeamount:set_int(tonumber(tbl[40]))
        standing_fakejitter:set_bool(to_boolean(tbl[41]))
        standing_faketoggle:set_bool(to_boolean(tbl[42]))
        standing_jittertoggle:set_bool(to_boolean(tbl[43]))
        standing_jitterrange:set_int(tonumber(tbl[44]))
        standing_compangle:set_int(tonumber(tbl[45]))
        standing_fakeamount:set_int(tonumber(tbl[46]))
        WorkAA:set_bool(to_boolean(tbl[47]))
        States:set_bool(to_boolean(tbl[48]))


        print("-- loaded config")
        
    end
    local status, message = pcall(protected)
    if not status then
        print("-- config expired or not working")
        return
    end
end

configs.export = function()
    local str = { 
        tostring(aspectratiobutton:get_bool()) .. "|",
        tostring(aspect_ratio_slider:get_int()) .. "|",
        tostring(infotabflag:get_int()) .. "|",
        tostring(indicatorstype:get_int()) .. "|",
        tostring(clantagtype:get_int()) .. "|",
        tostring(soundsel:get_int()) .. "|",
        tostring(sound:get_bool()) .. "|",
        tostring(trashtalk:get_bool()) .. "|",
        tostring(indicatorsmain:get_bool()) .. "|",
        tostring(clantag:get_bool()) .. "|",
        tostring(keybinds:get_bool()) .. "|",
        tostring(arrowsn:get_bool()) .. "|",
        tostring(watermarkd:get_bool()) .. "|",
        tostring(infobar:get_bool()) .. "|",
        tostring(dsbfk:get_bool()) .. "|",
        tostring(air_fakejitter:get_bool()) .. "|",
        tostring(air_faketoggle:get_bool()) .. "|",
        tostring(air_jittertoggle:get_bool()) .. "|",
        tostring(air_jitterrange:get_int()) .. "|",
        tostring(air_compangle:get_int()) .. "|",
        tostring(air_fakeamount:get_int()) .. "|",
        tostring(crouching_fakejitter:get_bool()) .. "|",
        tostring(crouching_faketoggle:get_bool()) .. "|",
        tostring(crouching_jittertoggle:get_bool()) .. "|",
        tostring(crouching_jitterrange:get_int()) .. "|",
        tostring(crouching_compangle:get_int()) .. "|",
        tostring(crouching_fakeamount:get_int()) .. "|",
        tostring(slowwalk_fakejitter:get_bool()) .. "|",
        tostring(slowwalk_faketoggle:get_bool()) .. "|",
        tostring(slowwalk_jittertoggle:get_bool()) .. "|",
        tostring(slowwalk_jitterrange:get_int()) .. "|",
        tostring(slowwalk_compangle:get_int()) .. "|",
        tostring(slowwalk_fakeamount:get_int()) .. "|",
        tostring(moving_fakejitter:get_bool()) .. "|",
        tostring(moving_faketoggle:get_bool()) .. "|",
        tostring(moving_jittertoggle:get_bool()) .. "|",
        tostring(moving_jitterrange:get_int()) .. "|",
        tostring(moving_compangle:get_int()) .. "|",
        tostring(moving_fakeamount:get_int()) .. "|",
        tostring(standing_fakejitter:get_bool()) .. "|",
        tostring(standing_faketoggle:get_bool()) .. "|",
        tostring(standing_jittertoggle:get_bool()) .. "|",
        tostring(standing_jitterrange:get_int()) .. "|",
        tostring(standing_compangle:get_int()) .. "|",
        tostring(standing_fakeamount:get_int()) .. "|",
        tostring(WorkAA:get_bool()) .. "|",
        tostring(States:get_bool()) .. "|",
    }
    
        clipboard.set(enc(table.concat(str)))
        print("-- copied in the clipboard")

end

local theimport = gui.add_button("Import settings", "LUA>TAB b", function() configs.import() end);
local theexport = gui.add_button("Export settings", "LUA>TAB b", function() configs.export() end);

local function get_muzzle_pos()
    local lp = entities.get_entity(engine.get_local_player())
    if not lp or not lp:is_alive() then return end
    local lp_address = get_client_entity(engine.get_local_player())
    local weapon = lp:get_weapon()
    if not weapon then return end
    local weapon_address = get_client_entity(weapon:get_index())
    local viewmodel_handle = lp:get_prop("m_hViewModel[0]")
    local viewmodel = entities.get_entity_from_handle(viewmodel_handle)
    local viewmodel_address = get_client_entity(viewmodel:get_index())
    local viewmodel_vtbl = ffi.cast(interface_type, viewmodel_address)[0]
    local weapon_vtbl = ffi.cast(interface_type, weapon_address)[0]
    local get_viewmodel_attachment_fn = ffi.cast("c_entity_get_attachment_t", viewmodel_vtbl[84])
    local get_muzzle_attachment_index_fn = ffi.cast("c_weapon_get_muzzle_attachment_index_first_person_t", weapon_vtbl[468])
    local vec3 = ffi.new("Vector")
    local muzzle_attachment_index = get_muzzle_attachment_index_fn(weapon_address, viewmodel_address)
    local state = get_viewmodel_attachment_fn(viewmodel_address, muzzle_attachment_index, vec3)
    local vec3_pos = math.vec3(vec3.x, vec3.y, vec3.z)
    return vec3_pos
end

function gui_system() 

    currenttab = MenuSelection:get_int()





    if currenttab == 2  then

        AntiAim = true
        if WorkAA:get_bool() then
            AAON = true
            if States:get_int() == 1 then
                CS = true
            else 
                CS = false
            end
            if States:get_int() == 2 then
                CM = true
            else 
                CM = false
            end
            if States:get_int() == 3 then
                CSW = true
            else 
                CSW = false
            end
            if States:get_int() == 4 then
                CC = true
            else 
                CC = false
            end
            if States:get_int() == 5 then
                CA = true
            else 
                CA = false
            end
        else
            AAON = false
            CS = false
            CM = false
            CSW = false
            CC = false
            CA = false
        end
    else
        AAON = false
        CS = false
        CM = false
        CSW = false
        CC = false
        CA = false
        AntiAim = false
    
    end


    if not gui.is_menu_open() then
        AntiAim = false
        AAON = false
        CS = false
        CM = false
        CSW = false
        CC = false
        CA = false
    end
    gui.set_visible("lua>tab b>AntiAim Builder", AntiAim)
    gui.set_visible("lua>tab b>Choose AntiAim Condition:", AAON)
    gui.set_visible("lua>tab b>[Standing] Jitter", CS)
    gui.set_visible("lua>tab b>[Standing] Jitter range", CS)
    gui.set_visible("lua>tab b>[Standing] Fake", CS)
    gui.set_visible("lua>tab b>[Standing] Fake Amount", CS)
    gui.set_visible("lua>tab b>[Standing] Compensate Angle", CS)
    gui.set_visible("lua>tab b>[Standing] Jitter Fake", CS)
    gui.set_visible("lua>tab b>[Moving] Jitter", CM)
    gui.set_visible("lua>tab b>[Moving] Jitter range", CM)
    gui.set_visible("lua>tab b>[Moving] Fake", CM)
    gui.set_visible("lua>tab b>[Moving] Fake Amount", CM)
    gui.set_visible("lua>tab b>[Moving] Compensate Angle", CM)
    gui.set_visible("lua>tab b>[Moving] Jitter Fake", CM)
    gui.set_visible("lua>tab b>[Slow Walking] Jitter", CSW)
    gui.set_visible("lua>tab b>[Slow Walking] Jitter range", CSW)
    gui.set_visible("lua>tab b>[Slow Walking] Fake", CSW)
    gui.set_visible("lua>tab b>[Slow Walking] Fake Amount", CSW)
    gui.set_visible("lua>tab b>[Slow Walking] Compensate Angle", CSW)
    gui.set_visible("lua>tab b>[Slow Walking] Jitter Fake", CSW)
    gui.set_visible("lua>tab b>[Crouching] Jitter", CC)
    gui.set_visible("lua>tab b>[Crouching] Jitter range", CC)
    gui.set_visible("lua>tab b>[Crouching] Fake", CC)
    gui.set_visible("lua>tab b>[Crouching] Fake Amount", CC)
    gui.set_visible("lua>tab b>[Crouching] Compensate Angle", CC)
    gui.set_visible("lua>tab b>[Crouching] Jitter Fake", CC)
    gui.set_visible("lua>tab b>[In Air] Jitter", CA)
    gui.set_visible("lua>tab b>[In Air] Jitter range", CA)
    gui.set_visible("lua>tab b>[In Air] Fake", CA)
    gui.set_visible("lua>tab b>[In Air] Fake Amount", CA)
    gui.set_visible("lua>tab b>[In Air] Compensate Angle", CA)
    gui.set_visible("lua>tab b>[In Air] Jitter Fake", CA)
end


function guiscc()
    local tab = MenuSelection:get_int()
    local indicatorsenb = indicatorsmain:get_bool()
    local sounden = sound:get_bool()
    local infobar = infobar:get_bool()
    local aspectratiobuttonx = aspectratiobutton:get_bool()
    -- ragebot
    gui.set_visible("lua>tab b>Disable Fakelag on HS", tab == 1)

    -- aa addons
    gui.set_visible("lua>tab b>Clock Inverter", tab == 2)

    -- visuals
    gui.set_visible("lua>tab b>Watermark", tab == 3)
    gui.set_visible("lua>tab b>info tab", tab == 3)
    gui.set_visible("lua>tab b>keybinds", tab == 3)
    gui.set_visible("lua>tab b>indicators", tab == 3)
    gui.set_visible("lua>tab b>arrows", tab == 3)
    gui.set_visible("lua>tab b>indicators | type", tab == 3 and indicatorsenb)
    gui.set_visible("lua>tab b>Info Tab | Flag", tab == 3 and infobar)

    -- home
    gui.set_visible("lua>tab b>main user", tab == 0)
    gui.set_visible("lua>tab b>Import settings", tab == 0)
    gui.set_visible("lua>tab b>Export settings", tab == 0)

    -- others
    gui.set_visible("lua>tab b>select", tab == 4 and sounden)
    gui.set_visible("lua>tab b>custom sounds", tab == 4)
    gui.set_visible("lua>tab b>Trash talk", tab == 4)
    gui.set_visible("lua>tab b>Clantag", tab == 4)
    gui.set_visible("lua>tab b>Clantag Type", tab == 4 and clantag:get_bool())
    gui.set_visible("lua>tab b>Aspect ratio", tab == 4)
    gui.set_visible("lua>tab b>[value]", tab == 4 and aspectratiobuttonx)

    -- colours
    gui.set_visible("lua>tab b>keybinds color", tab == 5)
    gui.set_visible("lua>tab b>infobar color", tab == 5)
    gui.set_visible("lua>tab b>watermark color", tab == 5)
    gui.set_visible("lua>tab b>indicator color", tab == 5)
end

function clantagfc()
    local ctype = clantagtype:get_int()
    if clantag:get_bool() then
        local defaultct = gui.get_config_item("misc>various>clan tag")
        local realtime = math.floor((global_vars.realtime) * 1.5)
        if old_time ~= realtime then
            if ctype == 0 then
                utils.set_clan_tag(animation[realtime % #animation+1]);
            end
            if ctype == 1 then
                utils.set_clan_tag(animation2[realtime % #animation2+1]);
            end
            if ctype == 2 then
                utils.set_clan_tag(animation3[realtime % #animation3+1]);
            end
        old_time = realtime;
        defaultct:set_bool(false);
        end
    end
end

function on_player_death(event)
    if trashtalk:get_bool() then
    local lp = engine.get_local_player();
    local attacker = engine.get_player_for_user_id(event:get_int('attacker'));
    local userid = engine.get_player_for_user_id(event:get_int('userid'));
    local userInfo = engine.get_player_info(userid);
        if attacker == lp and userid ~= lp then
            engine.exec("say " .. first[utils.random_int(1, #first)] .. "")
        end
    else
    end
end

local fake_amount = gui.get_config_item("Rage>Anti-Aim>Desync>Fake amount")

function clock_inverter()
    if engine.is_in_game() == false then return 
    end

    if Checkbox:get_bool() == true then
        fake_amount:set_int(-fake_amount:get_int())
    else
        fake_amount:set_int(fake_amount:get_int())
    end
end

function fakelagrgb()
    if dsbfk:get_bool() then
        if hs:get_bool() then
            limit:set_int(1)
        end
        cache.override = true
        else
        if cache.override then
            limit:set_int(cache.backup)
            cache.override = false
        else
            cache.backup = limit:get_int()
        end
    end
end

function gui_controller()
    local text =  "Codeine.lua anti-aim"
    local username = name:get_string()
    local textx, texty = render.get_text_size(pixel, text)
    local text2 = "user: " .. username .. ""
    local text2x, text2y = render.get_text_size(pixel, text2)
    local infotabflag = infotabflag:get_int()
    local alpha2 = math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255)
    if infobar:get_bool() then
        render.rect_filled_multicolor(5, y / 2, 80, (y / 2) + 19,infobar_color:get_color(), render.color(0,0,0,0),render.color(0,0,0,0), infobar_color:get_color())
        render.text(pixel, 37,(y / 2) + 2, "Codeine.lua anti-aim", render.color(255,255,255,255))
        render.text(pixel, 37 + textx,(y / 2) + 1, " experiments", infobar_color:get_color())
        render.text(pixel, 37,(y / 2) + 10, "user: " .. username .. "", render.color(255,255,255,255))
        render.text(pixel, 37 + text2x,(y / 2) + 10, "  Faded", render.color(infobar_color:get_color().r, infobar_color:get_color().g, infobar_color:get_color().b, alpha2))
        if infotabflag == 0 then
            render.rect_filled(7, (y / 2) + 2, 32, (y / 2) + 7,render.color(255,255,255,255))
            render.rect_filled(7, (y / 2) + 7, 32, (y / 2) + 12,render.color(28, 53, 120,255))
            render.rect_filled(7, (y / 2) + 12, 32, (y / 2) + 17,render.color(2228, 24, 28,255))
        end
        if infotabflag == 1 then
            render.rect_filled(7, (y / 2) + 2, 32, (y / 2) + 7,render.color(0, 0, 0, 255))
            render.rect_filled(7, (y / 2) + 7, 32, (y / 2) + 12,render.color(221, 0, 0,255))
            render.rect_filled(7, (y / 2) + 12, 32, (y / 2) + 17,render.color(255, 204, 0,255))
        end
        if infotabflag == 2 then
            render.rect_filled(7, (y / 2) + 2, 32, (y / 2) + 7,render.color(0, 114, 206, 255))
            render.rect_filled(7, (y / 2) + 7, 32, (y / 2) + 12,render.color(0,0,0,255))
            render.rect_filled(7, (y / 2) + 12, 32, (y / 2) + 17,render.color(255,255,255,255))
        end
        if infotabflag == 3 then
            render.rect_filled(7, (y / 2) + 2, 32, (y / 2) + 7,render.color(206, 41, 57, 255))
            render.rect_filled(7, (y / 2) + 7, 32, (y / 2) + 12,render.color(255, 255, 255,255))
            render.rect_filled(7, (y / 2) + 12, 32, (y / 2) + 17,render.color(71, 112, 80,255))
        end
        if infotabflag == 4 then
            render.rect_filled(7, (y / 2) + 2, 32, (y / 2) + 7,render.color(0, 0,0,255))
            render.rect_filled(7, (y / 2) + 7, 32, (y / 2) + 12,render.color(255,255,255,255))
            render.rect_filled(7, (y / 2) + 12, 32, (y / 2) + 17,render.color(255, 17, 0,255))
        end
    end
end

local r_aspectratio = cvar.r_aspectratio

local default_value = r_aspectratio:get_float()

local function set_aspect_ratio(multiplier)
    local screen_width,screen_height = render.get_screen_size()

    local value = (screen_width * multiplier) / screen_height

    if multiplier == 1 then
        value = 0
    end
    r_aspectratio:set_float(value)
end

function aspect_ratio2()
    local aspect_ratio = aspect_ratio_slider:get_int() * 0.01
    aspect_ratio = 2 - aspect_ratio
    set_aspect_ratio(aspect_ratio)
end

function watermark()
    local textone = "Codeine.lua"
    if watermarkd:get_bool() or player==nil then
        local x, y=render.get_screen_size()
        local player=entities.get_entity(engine.get_local_player())
        local text="fatality.win | Codeine.lua | soldier"
        local textx, texty=render.get_text_size(font, text)
        render.rect_filled_rounded(x-12,8, x-textx-18, 25, render.color(watermark_color:get_color().r, watermark_color:get_color().g, watermark_color:get_color().b, 50), 1.5, render.all)
        render.text(font, x-textx-14,13, text, render.color(255,255, 255, 255))
    end
end

function arrowsd()
    if arrowsn:get_bool() then
        render.text(render.font_esp, (1920 / 2) + 75, 535, ">", render.color(255,255,255,255))
        render.text(render.font_esp, (1920 / 2) - 75, 535, "<", render.color(255,255,255,255))
    end
end






font = render.font_esp

local function animation(check, name, value, speed) 
    if check then 
        return name + (value - name) * global_vars.frametime * speed / 1.5
    else 
        return name - (value + name) * global_vars.frametime * speed / 1.5
        
    end
end

local offset_scope = 0
local dton = 0
local alpha = 0

function indicators()

    local lp = entities.get_entity(engine.get_local_player())
    if not lp then return end
    if not lp:is_alive() then return end
    local scoped = lp:get_prop("m_bIsScoped")
    offset_scope = animation(scoped, offset_scope, 25, 10)
    
    local function Clamp(Value, Min, Max)
        return Value < Min and Min or (Value > Max and Max or Value)
    end
        
        local alpha2 = math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255)
        local lp = entities.get_entity(engine.get_local_player())
        if not lp then return end
        if not lp:is_alive() then return end
        local screen_width, screen_height = render.get_screen_size( )
        local x = screen_width / 2
        local y = screen_height / 2
        local ay = 0
    
    
    if indicatorsmain:get_bool() and indicatorstype:get_int() == 0 then
        
        local alpha2 = math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255)
        local lp = entities.get_entity(engine.get_local_player())
        if not lp then return end
        if not lp:is_alive() then return end
        local local_player = entities.get_entity(engine.get_local_player())
        local ay = 0
        local desync_percentage = Clamp(math.abs(local_player:get_prop("m_flPoseParameter", 11) * 120 - 60.5), 0.5 / 60, 60) / 56
        local w, h = 35, 3
        local screen_width, screen_height = render.get_screen_size( )
        local x = screen_width / 2
        local y = screen_height / 2
        local textx , texty = render.get_text_size(font, "Codeine") 
        local color1 = render.color(indicator_color:get_color().r, indicator_color:get_color().g, indicator_color:get_color().b, 255)
        local color2 = render.color(indicator_color:get_color().r - 70, indicator_color:get_color().g - 90, indicator_color:get_color().b - 70, 185)
    
        local text =  "Codeine.lua°"
        local text2 = "alpha"
        local textx, texty = render.get_text_size(pixel, text)
        local textx2, texty2 = render.get_text_size(pixel, text2)
    
        render.text(font, x+offset_scope + 7 , y + 15 + texty, "Codeine", render.color("#FFFFFF"))
        local textx , texty = render.get_text_size(font, utils.random_int(15, 100).."%") 
        render.text(font, x+offset_scope + 16 , y + 25 + texty, utils.random_int(15, 100).."%", render.color("#FFFFFF"))
        local dt = gui.get_config_item("Rage>Aimbot>Aimbot>Double tap"):get_bool()
        local dmg = gui.get_config_item("rage>aimbot>ssg08>scout>override"):get_bool()
        if dt then
            dton = 10
        elseif not dt then
            dton = 0
        end
        if dt then
            local textx , texty = render.get_text_size(font, "DT") 
            render.text(font, x+ offset_scope - textx + 27  , y + 35 + texty, "DT", render.color("#A1FF97"))
        end
        if not dmg then
            local textx , texty = render.get_text_size(font, "DMG") 
            render.text(font, x+ offset_scope - textx + 32  , y + 35 + texty + dton, "DMG", render.color(255,255,255,150))
        elseif dmg then

            local textx , texty = render.get_text_size(font, "DMG") 
            render.text(font, x+ offset_scope - textx + 32  , y + 35 + texty + dton, "DMG", render.color(255,255,255,255))
        end
        local hs = gui.get_config_item("Rage>Aimbot>Aimbot>Hide shot"):get_bool()
        if not hs then
            local textx , texty = render.get_text_size(font, "HS") 
            render.text(font, x+ offset_scope - textx + 44  , y + 35 + texty + dton, "HS", render.color(255,255,255,150))
        elseif hs then

            local textx , texty = render.get_text_size(font, "HS") 
            render.text(font, x+ offset_scope - textx + 44 , y + 35 + texty + dton, "HS", render.color(255,255,255,255))
        end
        local dormant = gui.get_config_item("Rage>Aimbot>Aimbot>target dormant"):get_bool()
        if not dormant then
            local textx , texty = render.get_text_size(font, "DA") 
            render.text(font, x+ offset_scope - textx + 14  , y + 35 + texty + dton, "DA", render.color(255,255,255,150))
        elseif dormant then

            local textx , texty = render.get_text_size(font, "DA") 
            render.text(font, x+ offset_scope - textx + 14 , y+ 35 + texty + dton, "DA", render.color(255,255,255,255))
        end
    end
end

function ID()

    local lp = entities.get_entity(engine.get_local_player())
    if not lp then return end
    if not lp:is_alive() then return end
    local scoped = lp:get_prop("m_bIsScoped")
    offset_scope = animation(scoped, offset_scope, 25, 10)
    
        
        local alpha2 = math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255)
        local lp = entities.get_entity(engine.get_local_player())
        if not lp then return end
        if not lp:is_alive() then return end
        local screen_width, screen_height = render.get_screen_size( )
        local x = screen_width / 2
        local y = screen_height / 2
        local ay = 0
    
    
    if indicatorsmain:get_bool() and indicatorstype:get_int() == 1 then
        
        local alpha2 = math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255)
        local lp = entities.get_entity(engine.get_local_player())
        if not lp then return end
        if not lp:is_alive() then return end
        local local_player = entities.get_entity(engine.get_local_player())
        local ay = 0
        local w, h = 35, 3
        local screen_width, screen_height = render.get_screen_size( )
        local x = screen_width / 2
        local y = screen_height / 2
        local color1 = render.color(indicator_color:get_color().r, indicator_color:get_color().g, indicator_color:get_color().b, 255)
        local color2 = render.color(indicator_color:get_color().r - 70, indicator_color:get_color().g - 90, indicator_color:get_color().b - 70, 185)
    
        local text =  "Codeine.lua°"
        local text2 = "alpha"
        local textx, texty = render.get_text_size(pixel, text)
        local textx2, texty2 = render.get_text_size(pixel, text2)
    
        render.text(pixel, x+offset_scope - 4, y + 16, text, render.color(indicator_color:get_color().r, indicator_color:get_color().g, indicator_color:get_color().b, 255))
        render.text(pixel, x+offset_scope + 11, y + 30, text2, render.color(71, 71, 71, alpha2))
    
        render.rect_filled(x + 0 +offset_scope, y + 24, x+offset_scope + w + 9, y + 25 + h + 1, render.color("#000000"))
        render.rect_filled(x+offset_scope + 1, y + 25, x+offset_scope + w + 8, y + 25 + h, render.color(255, 255, 255, 255))
    
    end
    end

-- screen size
local screen_size = {render.get_screen_size()}

-- fonts
local verdana = render.font_esp

-- menu
local keybinds_x = gui.add_slider("keybinds_x", "lua>tab a", 0, screen_size[1], 1)
local keybinds_y = gui.add_slider("keybinds_y", "lua>tab a", 0, screen_size[2], 1)
gui.set_visible("lua>tab a>keybinds_x", false)
gui.set_visible("lua>tab a>keybinds_y", false)


function animate(value, cond, max, speed, dynamic, clamp)

    -- animation speed
    speed = speed * global_vars.frametime * 20

    -- static animation
    if dynamic == false then
        if cond then
            value = value + speed
        else
            value = value - speed
        end
    
    -- dynamic animation
    else
        if cond then
            value = value + (max - value) * (speed / 100)
        else
            value = value - (0 + value) * (speed / 100)
        end
    end

    -- clamp value
    if clamp then
        if value > max then
            value = max
        elseif value < 0 then
            value = 0
        end
    end

    return value
end

function drag(var_x, var_y, size_x, size_y)
    local mouse_x, mouse_y = input.get_cursor_pos()

    local drag = false

    if input.is_key_down(0x01) then
        if mouse_x > var_x:get_int() and mouse_y > var_y:get_int() and mouse_x < var_x:get_int() + size_x and mouse_y < var_y:get_int() + size_y then
            drag = true
        end
    else
        drag = false
    end

    if (drag) then
        var_x:set_int(mouse_x - (size_x / 2))
        var_y:set_int(mouse_y - (size_y / 2))
    end

end
function on_keybinds()

    if not keybinds:get_bool() then return end

    local pos = {keybinds_x:get_int(), keybinds_y:get_int()}

    local size_offset = 0

    local binds =
    {
        gui.get_config_item("rage>aimbot>aimbot>double tap"):get_bool(),
        gui.get_config_item("rage>aimbot>aimbot>hide shot"):get_bool(),
        gui.get_config_item("rage>aimbot>ssg08>scout>override"):get_bool(), -- override dmg is taken from the scout
        gui.get_config_item("rage>aimbot>aimbot>headshot only"):get_bool(),
        gui.get_config_item("misc>movement>fake duck"):get_bool()
    }

    local binds_name = 
    {
        "Doubletap",
        "Hideshots",
        "Min. Damage",
        "HeadShot Only",
        "Fake duck",
        "HeadShot Only",
    }

    if not binds[4] then
        if not binds[5] then
            if not binds[3] then
                if not binds[1] then
                    if not binds[6] then
                        if not binds[2] then
                            size_offset = 0
                        else
                            size_offset = 38
                        end
                    else
                        size_offset = 40
                    end
                else
                    size_offset = 41
                end
            else
                size_offset = 54
            end
        else
            size_offset = 63
        end
    else
        size_offset = 70
    end

    animated_size_offset = animate(animated_size_offset or 0, true, size_offset, 60, true, false)

    local size = {100 + animated_size_offset, 22}

    local enabled = "[enabled]"
    local text_size = render.get_text_size(verdana, enabled) + 7

    local override_active = binds[3] or binds[4] or binds[5] or binds[6] or binds[7] or binds[8]
    local other_binds_active = binds[1] or binds[2] or binds[9] or binds[10] or binds[11]

    drag(keybinds_x, keybinds_y, size[1], size[2])

    alpha = animate(alpha or 0, gui.is_menu_open() or override_active or other_binds_active, 1, 0.5, false, true)

    -- glow
    for i = 1, 10 do
        render.rect_filled_rounded(pos[1] - i, pos[2] - i, pos[1] + size[1] + i, pos[2] + size[2] + i, render.color(keybinds_color:get_color().r, keybinds_color:get_color().g, keybinds_color:get_color().b, (20 - (2 * i)) * alpha), 10)
    end

    -- top rect
    render.push_clip_rect(pos[1], pos[2], pos[1] + size[1], pos[2] + 5)
    render.rect_filled_rounded(pos[1], pos[2], pos[1] + size[1], pos[2] + size[2], render.color(0, 0, 0, 105 * alpha), 5)
    render.pop_clip_rect()

    -- bot rect
    render.push_clip_rect(pos[1], pos[2] + 17, pos[1] + size[1], pos[2] + 22)
    render.rect_filled_rounded(pos[1], pos[2], pos[1] + size[1], pos[2] + 22, render.color(0, 0, 0, 105 * alpha), 5)
    render.pop_clip_rect()

    -- other colormain:get_color().r
    render.rect_filled_multicolor(pos[1], pos[2] + 5, pos[1] + size[1], pos[2] + 17, render.color(keybinds_color:get_color().r, keybinds_color:get_color().g, keybinds_color:get_color().b, 255 * alpha), render.color(keybinds_color:get_color().r, keybinds_color:get_color().g, keybinds_color:get_color().b, 255 * alpha), render.color(keybinds_color:get_color().r, keybinds_color:get_color().g, keybinds_color:get_color().b, 255 * alpha), render.color(keybinds_color:get_color().r, keybinds_color:get_color().g, keybinds_color:get_color().b, 255 * alpha))
    render.rect_filled_rounded(pos[1] + 2, pos[2] + 2, pos[1] + size[1] - 2, pos[2] + 20, render.color(0, 0, 0, 255 * alpha), 5)
    render.text(verdana, pos[1] + size[1] / 2 - render.get_text_size(verdana, "keybinds") / 2 - 1, pos[2] + 7, "keybinds", render.color(255, 255, 255, 255 * alpha))


    local bind_offset = 0
    dt_alpha = animate(dt_alpha or 0, binds[1], 1, 0.5, false, true)
    render.text(verdana, pos[1] + 6, pos[2] + size[2] + 2, binds_name[1], render.color(255, 255, 255, 255 * dt_alpha))
    render.text(verdana, pos[1] + size[1] - text_size, pos[2] + size[2] + 2, enabled, render.color(255, 255, 255, 255 * dt_alpha))
    if binds[1] then
        bind_offset = bind_offset + 11
    end

    hs_alpha = animate(hs_alpha or 0, binds[2], 1, 0.5, false, true)
    render.text(verdana, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[2], render.color(255, 255, 255, 255 * hs_alpha))
    render.text(verdana, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255 * hs_alpha))
    if binds[2] then
        bind_offset = bind_offset + 11
    end

    dmg_alpha = animate(dmg_alpha or 0, binds[3], 1, 0.5, false, true)
    render.text(verdana, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[3], render.color(255, 255, 255, 255 * dmg_alpha))
    render.text(verdana, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255 * dmg_alpha))
    if binds[3] then
        bind_offset = bind_offset + 11
    end

    fs_alpha = animate(fs_alpha or 0, binds[4], 1, 0.5, false, true)
    render.text(verdana, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[4], render.color(255, 255, 255, 255 * fs_alpha))
    render.text(verdana, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255 * fs_alpha))
    if binds[4] then
        bind_offset = bind_offset + 11
    end

    ho_alpha = animate(ho_alpha or 0, binds[5], 1, 0.5, false, true)
    render.text(verdana, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[5], render.color(255, 255, 255, 255 * ho_alpha))
    render.text(verdana, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255 * ho_alpha))
    if binds[5] then
        bind_offset = bind_offset + 11
    end

    fd_alpha = animate(fd_alpha or 0, binds[6], 1, 0.5, false, true)
    render.text(verdana, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[6], render.color(255, 255, 255, 255 * fd_alpha))
    render.text(verdana, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255 * fd_alpha))

end

function on_shot_registered(shot)
    local sounds = soundsel:get_int()
    if sounds == 0 and sound:get_bool() then
        if shot.server_damage <= 0 then return end
        engine.exec("play aways.wav")
    end
    if sounds == 1 and sound:get_bool() then
        if shot.server_damage <= 0 then return end
        engine.exec("play flick.wav")
    end
    if sounds == 2 and sound:get_bool() then
        if shot.server_damage <= 0 then return end
        engine.exec("play stapler.wav")
    end
end

local font = render.font_esp

local jittertoggle = gui.get_config_item("rage>anti-aim>angles>jitter")
local jitterrange = gui.get_config_item("rage>anti-aim>angles>jitter range")
local faketoggle = gui.get_config_item("rage>anti-aim>desync>fake")
local fakeamount = gui.get_config_item("rage>anti-aim>desync>fake amount")
local compangle = gui.get_config_item("rage>anti-aim>desync>compensate angle")
local fsfake = gui.get_config_item("rage>anti-aim>desync>freestand fake")
local fakejitter = gui.get_config_item("rage>anti-aim>desync>flip fake with jitter")
local slide = gui.get_config_item("misc>movement>slide")



function builder()
    if engine.is_in_game() == false then return end
    if WorkAA:get_bool() then
        local slowwalk = slide:get_bool()
        local lplr = entities.get_entity(engine.get_local_player())
        local flag = lplr:get_prop("m_fFlags")
        local air = lplr:get_prop("m_hGroundEntity") == -1
        local velocity_x = math.floor(lplr:get_prop("m_vecVelocity[0]"))
        local velocity_y = math.floor(lplr:get_prop("m_vecVelocity[1]"))
        local speed = math.sqrt(velocity_x ^ 2 + velocity_y ^ 2)
        local crouch = input.is_key_down(0x11)

        if slowwalk and not air and flag ~= 263 then
            jittertoggle:set_bool(slowwalk_jittertoggle:get_bool())
            jitterrange:set_int(slowwalk_jitterrange:get_int())
            faketoggle:set_bool(slowwalk_faketoggle:get_bool())
            fakeamount:set_int(slowwalk_fakeamount:get_int())
            compangle:set_int(slowwalk_compangle:get_int())
            fakejitter:set_bool(slowwalk_fakejitter:get_bool())

        else if speed > 2 and not air and not crouch then  
            jittertoggle:set_bool(moving_jittertoggle:get_bool())
            jitterrange:set_int(moving_jitterrange:get_int())
            faketoggle:set_bool(moving_faketoggle:get_bool())
            fakeamount:set_int(moving_fakeamount:get_int())
            compangle:set_int(moving_compangle:get_int())
            fakejitter:set_bool(moving_fakejitter:get_bool())

        else if speed <= 2 and flag == 257 then
            jittertoggle:set_bool(standing_jittertoggle:get_bool())
            jitterrange:set_int(standing_jitterrange:get_int())
            faketoggle:set_bool(standing_faketoggle:get_bool())
            fakeamount:set_int(standing_fakeamount:get_int())
            compangle:set_int(standing_compangle:get_int())
            fakejitter:set_bool(standing_fakejitter:get_bool())

        else if crouch then
            jittertoggle:set_bool(crouching_jittertoggle:get_bool())
            jitterrange:set_int(crouching_jitterrange:get_int())
            faketoggle:set_bool(crouching_faketoggle:get_bool())
            fakeamount:set_int(crouching_fakeamount:get_int())
            compangle:set_int(crouching_compangle:get_int())
            fakejitter:set_bool(crouching_fakejitter:get_bool())

        else if air and flag ~= 262 then
            jittertoggle:set_bool(air_jittertoggle:get_bool())
            jitterrange:set_int(air_jitterrange:get_int())
            faketoggle:set_bool(air_faketoggle:get_bool())
            fakeamount:set_int(air_fakeamount:get_int())
            compangle:set_int(air_compangle:get_int())
            fakejitter:set_bool(air_fakejitter:get_bool())

        else if flag == 262 then
            jittertoggle:set_bool(crouching_jittertoggle:get_bool())
            jitterrange:set_int(crouching_jitterrange:get_int())
            faketoggle:set_bool(crouching_faketoggle:get_bool())
            fakeamount:set_int(crouching_fakeamount:get_int())
            compangle:set_int(crouching_compangle:get_int())
            fakejitter:set_bool(crouching_fakejitter:get_bool())
        
        end
        end
        end
        end
        end
    end
end
end


function on_shutdown()
    utils.set_clan_tag("");
    resolver_reference:set_int(default)
end

function on_paint()
    watermark()
    gui_controller()
    guiscc()
    on_keybinds()
    fakelagrgb()
    clock_inverter()
    clantagfc()
    gui_system()
    builder()
    aspect_ratio2()
    indicators()
    ID()
    arrowsd()
end