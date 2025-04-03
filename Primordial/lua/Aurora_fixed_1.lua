engine.exec("clear")
print("https://discord.gg/Rh2UZgqvpg%22")
print("Check new version in Discord")
print("Welcome back, user! ")
print("dead-dync.lua | beta build")

local Find = gui.get_config_item
local Checkbox = gui.add_checkbox
local Slider = gui.add_slider
local Combo = gui.add_combo
local MultiCombo = gui.add_multi_combo
local AddKeybind = gui.add_keybind
local CPicker = gui.add_colorpicker
local AddButton = gui.add_button
local clipboard = require("clipboard")
local playerstate = 0;
local ConditionalStates = { }
local configs = {}

local pixel = render.font_esp
local calibri11 = render.create_font("calibri.ttf", 11, render.font_flag_outline)
local calibri13 = render.create_font("calibri.ttf", 13, render.font_flag_shadow)
local verdana = render.create_font("verdana.ttf", 13, render.font_flag_outline)
local tahoma = render.create_font("tahoma.ttf", 13, render.font_flag_shadow)


local refs = {
    yawadd = Find("Rage>Anti-Aim>Angles>Yaw add");
    yawaddamount = Find("Rage>Anti-Aim>Angles>Add");
    spin = Find("Rage>Anti-Aim>Angles>Spin");
    jitter = Find("Rage>Anti-Aim>Angles>Jitter");
    spinrange = Find("Rage>Anti-Aim>Angles>Spin range");
    spinspeed = Find("Rage>Anti-Aim>Angles>Spin speed");
    jitterrandom = Find("Rage>Anti-Aim>Angles>Random");
    jitterrange = Find("Rage>Anti-Aim>Angles>Jitter Range");
    desync = Find("Rage>Anti-Aim>Desync>Fake amount");
    compAngle = Find("Rage>Anti-Aim>Desync>Compensate angle");
    freestandFake = Find("Rage>Anti-Aim>Desync>Freestand fake");
    flipJittFake = Find("Rage>Anti-Aim>Desync>Flip fake with jitter");
    leanMenu = Find("Rage>Anti-Aim>Desync>Roll lean");
    leanamount = Find("Rage>Anti-Aim>Desync>Lean amount");
    ensureLean = Find("Rage>Anti-Aim>Desync>Ensure Lean");
    flipJitterRoll = Find("Rage>Anti-Aim>Desync>Flip lean with jitter");
};

local var = {
    player_states = {"Standing", "Moving", "Slow motion", "Air", "Air Duck", "Crouch"};
};

---speed function
function get_local_speed()
    local local_player = entities.get_entity(engine.get_local_player())
    if local_player == nil then
      return
    end
  
    local velocity_x = local_player:get_prop("m_vecVelocity[0]")
    local velocity_y = local_player:get_prop("m_vecVelocity[1]")
    local velocity_z = local_player:get_prop("m_vecVelocity[2]")
  
    local velocity = math.vec3(velocity_x, velocity_y, velocity_z)
    local speed = math.ceil(velocity:length2d())
    if speed < 10 then
        return 0
    else 
        return speed 
    end
end

--fps stuff
function accumulate_fps()
    return math.ceil(1 / global_vars.frametime)
end
--tickrate function
function get_tickrate()
    if not engine.is_in_game() then return end

    return math.floor( 1.0 / global_vars.interval_per_tick )
end
---ping function
function get_ping()
    if not engine.is_in_game() then return end

    return math.ceil(utils.get_rtt() * 1000);
end

-- character table string
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

-- encoding
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

--import and export system
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





local MenuSelection = Combo("[Aurora Main]", "lua>tab b", {"Ragebot", "Anti-Aim", "Anti-Aim Helpers", "Visuals"})

--ragebot
local DAMain = Checkbox("Dormant Aimbot", "lua>tab b")
local DA = AddKeybind("lua>tab b>Dormant Aimbot")
local FL0 = Checkbox("Better Hideshots", "lua>tab b")
local hstype = Combo("Hideshots Type", "lua>tab b", {"Favor firerate", "Favor fakelag", "Break lagcomp"})
local ragebotlogs = Checkbox("Ragebot logs", "lua>tab b")
--end of ragebot

--start of AA

ConditionalStates[0] = {
	player_state = Combo("[Conditions]", "lua>tab b", var.player_states);
}
for i=1, 6 do
	ConditionalStates[i] = {
        ---Anti-Aim
        yawadd = Checkbox("Yaw add " .. var.player_states[i], "lua>tab b");
        yawaddamount = Slider("Add " .. var.player_states[i], "lua>tab b", -180, 180, 1);
        spin = Checkbox("Spin " .. var.player_states[i], "lua>tab b");
        spinrange = Slider("Spin range " .. var.player_states[i], "lua>tab b", 0, 360, 1);
        spinspeed = Slider("Spin speed " .. var.player_states[i], "lua>tab b", 0, 360, 1);
        jitter = Checkbox("Jitter " .. var.player_states[i], "lua>tab b");
        jittertype = Combo("Jitter Type " .. var.player_states[i], "lua>tab b", {"Center", "Offset", "Random"});
        jitterrange = Slider("Jitter range " .. var.player_states[i], "lua>tab b", 0, 360, 1);
        ---Desync
        desynctype = Combo("Desync Type " .. var.player_states[i], "lua>tab b", {"Static", "Jitter", "Random"});
        desync = Slider("Desync " .. var.player_states[i], "lua>tab b", -60, 60, 1);
        compAngle = Slider("Comp " .. var.player_states[i], "lua>tab b", 0, 100, 1);
        flipJittFake = Checkbox("Flip fake " .. var.player_states[i], "lua>tab b");
        leanMenu = Combo("Roll lean " .. var.player_states[i], "lua>tab b", {"None", "Static", "Extend fake", "Invert fake", "Freestand", "Freestand Opposite", "Jitter"});
        leanamount = Slider("Lean amount " .. var.player_states[i], "lua>tab b", 0, 50, 1);
    };
end
local cImport = AddButton("Import settings", "LUA>TAB b", function() configs.import() end);
local cExport = AddButton("Export settings", "LUA>TAB b", function() configs.export() end);
local cDefault = AddButton("Load default settings", "LUA>TAB b", function() configs.importDefault() end);
local StaticFS = Checkbox("Static Freestand", "lua>tab b")
local FF = Checkbox("Fake Flick", "lua>tab b")
local FFK = AddKeybind("lua>tab b>Fake Flick")
local IV = Checkbox("Inverter", "lua>tab b")
local IVK = AddKeybind("lua>tab b>Inverter")
--end of AA
--visuals and misc
local colormains = Checkbox("Color", "lua>tab b")
local colormain = CPicker("lua>tab b>Color", false)
local indicatorsmain = Combo("Indicators", "lua>tab b", {"None", "Modern","Alternative"})
local watermark, keybinds = MultiCombo("Solus UI", "lua>tab b", {"Watermark","Keybinds list"})
local clantagmain = Checkbox("Clantag", "lua>tab b")
--end of visuals and misc

--updates menu elements and refs
function MenuElements()
    for i=1, 6 do
        local tab = MenuSelection:get_int()
        local state = ConditionalStates[0].player_state:get_int() + 1
        local yawAddCheck = ConditionalStates[i].yawadd:get_bool()
        local spinCheck = ConditionalStates[i].spin:get_bool()
        local jitterCheck = ConditionalStates[i].jitter:get_bool()
        local leanamountCheck = ConditionalStates[i].leanamount:get_int()
        local BH = FL0:get_bool()


        --ragebot
        gui.set_visible("lua>tab b>Dormant Aimbot", tab == 0);
        gui.set_visible("lua>tab b>Better Hideshots", tab == 0);
        gui.set_visible("lua>tab b>Hideshots Type", tab == 0 and BH);
        gui.set_visible("lua>tab b>Ragebot logs", tab == 0);
        --antiaim
        gui.set_visible("lua>tab b>[Conditions]", tab == 1);
        gui.set_visible("lua>tab b>Yaw add " .. var.player_states[i], tab == 1 and state == i);
        gui.set_visible("lua>tab b>Add " .. var.player_states[i], tab == 1 and state == i and yawAddCheck);
        gui.set_visible("lua>tab b>Spin " .. var.player_states[i], tab == 1 and state == i);
        gui.set_visible("lua>tab b>Spin range " .. var.player_states[i], tab == 1 and state == i and spinCheck);
        gui.set_visible("lua>tab b>Spin speed " .. var.player_states[i], tab == 1 and state == i and spinCheck);
        gui.set_visible("lua>tab b>Jitter " .. var.player_states[i], tab == 1 and state == i);
        gui.set_visible("lua>tab b>Jitter Type " .. var.player_states[i], tab == 1 and state == i and jitterCheck);
        gui.set_visible("lua>tab b>Jitter range " .. var.player_states[i], tab == 1 and state == i and jitterCheck);

        --desync
        gui.set_visible("lua>tab b>Desync Type " .. var.player_states[i], tab == 1 and state == i);
        gui.set_visible("lua>tab b>Desync " .. var.player_states[i], tab == 1 and state == i);
        gui.set_visible("lua>tab b>Comp " .. var.player_states[i], tab == 1 and state == i);
        gui.set_visible("lua>tab b>Flip fake " .. var.player_states[i], tab == 1 and state == i);
        gui.set_visible("lua>tab b>Roll lean " .. var.player_states[i], tab == 1 and state == i);
        gui.set_visible("lua>tab b>Lean Amount " .. var.player_states[i], tab == 1 and state == i);
        --config system
        gui.set_visible("lua>tab b>Import settings", tab == 1);
        gui.set_visible("lua>tab b>Export settings", tab == 1);
        gui.set_visible("lua>tab b>Load default settings", tab == 1);
        --aa helpers
        gui.set_visible("lua>tab b>Static Freestand", tab == 2);
        gui.set_visible("lua>tab b>Fake Flick", tab == 2);
        gui.set_visible("lua>tab b>Inverter", tab == 2);
        --visuals tab
        gui.set_visible("lua>tab b>Color", tab == 3);
        gui.set_visible("lua>tab b>Indicators", tab == 3);
        gui.set_visible("lua>tab b>Solus UI", tab == 3);
        gui.set_visible("lua>tab b>Clantag", tab == 3);
    end
end
--end of menu elements and refs
--ragebot start
local hs = gui.get_config_item("Rage>Aimbot>Aimbot>Hide shot")
local dt = gui.get_config_item("Rage>Aimbot>Aimbot>Double tap")
local limit = gui.get_config_item("Rage>Anti-Aim>Fakelag>Limit")

-- cache fakelag limit
local cache = {
  backup = limit:get_int(),
  override = false,
}

function RB()

if FL0:get_bool() then
  if hstype:get_int() == 0 and not dt:get_bool() then
    if hs:get_bool() then
        limit:set_int(1)
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
  end

  if FL0:get_bool() then
    if hstype:get_int() == 1 and not dt:get_bool() then
      if hs:get_bool() then
          limit:set_int(9)
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
    end

if FL0:get_bool() then
    if hstype:get_int() == 2 and not dt:get_bool() then
        if hs:get_bool() then
            limit:set_int(global_vars.tickcount % 32 >= 4 and 14 or 1)
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
end
end

local TargetDormant = Find("rage>aimbot>aimbot>target dormant")

local function DA()

TargetDormant:set_bool(DAMain:get_bool())
    local local_player = entities.get_entity(engine.get_local_player())
    if not engine.is_in_game() or not local_player:is_valid() or not DAMain:get_bool() then
        return
    end
end
--ragebot end
--start of getting AA states and setting valeus

function UpdateStateandAA()

    local isSW = info.fatality.in_slowwalk
    local local_player = entities.get_entity(engine.get_local_player())
    local inAir = local_player:get_prop("m_hGroundEntity") == -1
    local vel_x = math.floor(local_player:get_prop("m_vecVelocity[0]"))
    local vel_y = math.floor(local_player:get_prop("m_vecVelocity[1]"))
    local still = math.sqrt(vel_x ^ 2 + vel_y ^ 2) < 5
    local cupic = bit.band(local_player:get_prop("m_fFlags"),bit.lshift(2, 0)) ~= 0
    local flag = local_player:get_prop("m_fFlags")

    playerstate = 0

    if inAir and cupic then
        playerstate = 5
    else
        if inAir then
            playerstate = 4
        else
            if isSW then
                playerstate = 3
            else
                if cupic then
                    playerstate = 6
                else
                    if still and not cupic then
                        playerstate = 1
                    elseif not still then
                        playerstate = 2
                    end
                end
            end
        end
    end

    refs.yawadd:set_bool(ConditionalStates[playerstate].yawadd:get_bool());
    if ConditionalStates[playerstate].jittertype:get_int() == 1 then
        refs.yawaddamount:set_int((ConditionalStates[playerstate].yawaddamount:get_int()) + (global_vars.tickcount % 4 >= 2 and 0 or ConditionalStates[playerstate].jitterrange:get_int()))
    else
        refs.yawaddamount:set_int(ConditionalStates[playerstate].yawaddamount:get_int());
    end
    refs.spin:set_bool(ConditionalStates[playerstate].spin:get_bool());
    refs.jitter:set_bool(ConditionalStates[playerstate].jitter:get_bool());
    refs.spinrange:set_int(ConditionalStates[playerstate].spinrange:get_int());
    refs.spinspeed:set_int(ConditionalStates[playerstate].spinspeed:get_int());
    refs.jitterrandom:set_bool(ConditionalStates[playerstate].jittertype:get_int() == 2);
    --jitter types
    if ConditionalStates[playerstate].jittertype:get_int() == 0 or ConditionalStates[playerstate].jittertype:get_int() == 2 then
            refs.jitterrange:set_int(ConditionalStates[playerstate].jitterrange:get_int());
        else
            refs.jitterrange:set_int(0);
        end
    --desync
    if ConditionalStates[playerstate].desync:get_int() == 60 and ConditionalStates[playerstate].desynctype:get_int() == 0 then
        refs.desync:set_int((ConditionalStates[playerstate].desync:get_int() * 1.666666667) - 2);
        else if ConditionalStates[playerstate].desync:get_int() == -60 and ConditionalStates[playerstate].desynctype:get_int() == 0 then
            refs.desync:set_int((ConditionalStates[playerstate].desync:get_int() * 1.666666667) + 2);
              else if ConditionalStates[playerstate].desynctype:get_int() == 0 then 
                refs.desync:set_int(ConditionalStates[playerstate].desync:get_int() * 1.666666667);
                    else if ConditionalStates[playerstate].desynctype:get_int() == 1 and 0 >= ConditionalStates[playerstate].desync:get_int() then 
                        refs.desync:set_int(global_vars.tickcount % 4 >= 2 and -18 * 1.666666667 or ConditionalStates[playerstate].desync:get_int() * 1.666666667 + 2);
                            else if ConditionalStates[playerstate].desynctype:get_int() == 1 and ConditionalStates[playerstate].desync:get_int() >= 0 then 
                                refs.desync:set_int(global_vars.tickcount % 4 >= 2 and 18 * 1.666666667 or ConditionalStates[playerstate].desync:get_int() * 1.666666667 - 2);
                                    else if ConditionalStates[playerstate].desynctype:get_int() == 2 and ConditionalStates[playerstate].desync:get_int() >= 0 then 
                                        refs.desync:set_int(utils.random_int(0, ConditionalStates[playerstate].desync:get_int() * 1.666666667));
                                            else if ConditionalStates[playerstate].desynctype:get_int() == 2 and ConditionalStates[playerstate].desync:get_int() <= 0 then 
                                                refs.desync:set_int(utils.random_int(ConditionalStates[playerstate].desync:get_int() * 1.666666667, 0));
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
    refs.compAngle:set_int(ConditionalStates[playerstate].compAngle:get_int());
    refs.flipJittFake:set_bool(ConditionalStates[playerstate].flipJittFake:get_bool());
    refs.leanMenu:set_int(ConditionalStates[playerstate].leanMenu:get_int());
    refs.leanamount:set_int(ConditionalStates[playerstate].leanamount:get_int());
end
--end of getting AA states and setting valeus
--start of static freestand
local AAfreestand = Find("Rage>Anti-Aim>Angles>Freestand")
local add = Find("Rage>Anti-Aim>Angles>Add")
local jitter = Find("Rage>Anti-Aim>Angles>Jitter Range")
local attargets = Find("Rage>Anti-Aim>Angles>At fov target")
local flipfake = Find("Rage>Anti-Aim>Desync>Flip fake with jitter")
local compfreestand = Find("Rage>Anti-Aim>Desync>Compensate Angle")
local fakefreestand = Find("Rage>Anti-Aim>Desync>Fake Amount")
local freestandfake  = Find("Rage>Anti-Aim>Desync>Freestand Fake")
local add_backup = add:get_int()
local jitter_backup = jitter:get_int()
local attargets_backup = attargets:get_bool()
local flipfake_backup = flipfake:get_bool()
local compfreestand_backup = compfreestand:get_int()
local fakefreestand_backup = fakefreestand:get_int()
local freestandfake_backup = freestandfake:get_int()
local restore_aa = false

local function StaticFreestand()
    if AAfreestand:get_bool() and StaticFS:get_bool() then
        add:set_int(0)
        jitter:set_int(0)
        flipfake:set_bool(false)
        compfreestand:set_int(0)
        freestandfake:set_int(0)
        restore_aa = true
    else
        if (restore_aa == true) then
            add:set_int(add_backup)
            jitter:set_int(jitter_backup)
            attargets:set_bool(attargets_backup)
            flipfake:set_bool(flipfake_backup)
            compfreestand:set_int(compfreestand_backup)
            freestandfake:set_int(freestandfake_backup)
            restore_aa = false
        else
            add_backup = add:get_int()
            jitter_backup = jitter:get_int()
            attargets_backup = attargets:get_bool()
            flipfake_backup = flipfake:get_bool()
            compfreestand_backup = compfreestand:get_int()
            freestandfake_backup = freestandfake:get_int()
        end
    end
end
--end of static freestand
local add = Find("Rage>Anti-Aim>Angles>Add")
local fakeangle = Find("Rage>Anti-Aim>Desync>Fake Amount")
local fakeamount = fakeangle:get_int() >= 0

local function fakeflick()
    if FF:get_bool() then
        if global_vars.tickcount % 19 == 13 and fakeangle:get_int() >= 0 then
            add:set_int(92)
        else
            if global_vars.tickcount % 19 == 13 and 0 >= fakeangle:get_int() then
                add:set_int(-92)
            end
        end 
    end
end
--end of fakeflick
local fakeangle = Find("Rage>Anti-Aim>Desync>Fake Amount")
local function InvertDesync()
    if IV:get_bool() then
        fakeangle:set_int(fakeangle:get_int() * -1)
    end
end
--end of inverter
--aa end
local function WM()
    
    local player = entities.get_entity(engine.get_local_player())
    if player == nil then return end
    if watermark:get_bool() then
    local latency  = math.floor((utils.get_rtt() or 0)*1000)
    local Time = utils.get_time()
    local realtime = string.format("%02d:%02d:%02d", Time.hour, Time.min, Time.sec)
    local watermarkText = ' Aurora [Fixed] / Version 1.3 / ' .. realtime .. ' time / Delay: ' .. latency .. 'ms';
    
        w, h = render.get_text_size(verdana, watermarkText);
        local watermarkWidth = w;
        x, y = render.get_screen_size();
        x, y = x - watermarkWidth - 5, y * 0.010;
    
        render.rect_filled_rounded(x - 4, y - 3, x + watermarkWidth + 2, y + h + 2.5, colormain:get_color(), 6, render.all);
        render.rect_filled_rounded(x - 2, y - 1, x + watermarkWidth, y + h , render.color(24, 24, 26, 255), 4, render.all);
        render.text(verdana, x - 2.5, y - 1.2, watermarkText, render.color(255, 255, 255));
    end
end

local screen_size = {render.get_screen_size()}
local keybindsx = Slider("keybindsx", "lua>tab a", 0, screen_size[1], 1)
local keybindsy = Slider("keybindsy", "lua>tab a", 0, screen_size[2], 1)
gui.set_visible("lua>tab a>keybindsx", false)
gui.set_visible("lua>tab a>keybindsy", false)

local function KB()

if keybinds:get_bool() then

local lp = entities.get_entity(engine.get_local_player())
if not lp then return end
if not lp:is_alive() then return end

if not engine.is_in_game() then return end

    local pos = {keybindsx:get_int(), keybindsy:get_int()}

    local size_offset = 0

    local binds =
    {
        Find("lua>tab b>Dormant Aimbot"):get_bool(),
        Find("rage>aimbot>aimbot>double tap"):get_bool(),
        Find("rage>aimbot>aimbot>hide shot"):get_bool(),
        Find("rage>aimbot>ssg08>scout>override"):get_bool(), -- override dmg is taken from the scout
        Find("rage>aimbot>aimbot>force extra safety"):get_bool(),
        Find("rage>aimbot>aimbot>headshot only"):get_bool(),
        Find("misc>movement>fake duck"):get_bool(),
        Find("rage>anti-aim>angles>freestand"):get_bool(),
        Find("lua>tab b>Fake Flick"):get_bool(),
        Find("lua>tab b>Inverter"):get_bool(),
    }

    local binds_name = 
    {
        "Dormant Aimbot",
        "Double tap",
        "On Shot anti-aim",
        "Damage override",
        "Force extra safety",
        "Headshot only",
        "Duck peek assist",
        "Freestanding",
        "Fake flick",
        "Inverter"
    }


    size_offset = 80

    animated_size_offset = animate(animated_size_offset or 0, true, size_offset, 60, true, false)

    local size = {75 + animated_size_offset, 22}

    local enabled = "[active]"
    local text_size = render.get_text_size(tahoma, enabled) + 7

    local override_active = binds[1] or binds[2] or binds[3] or binds[4] or binds[5] or binds[6] or binds[7] or binds[8] or binds[9] or binds[10] or binds[11] or binds[12]

    drag(keybindsx, keybindsy, size[1] + 15, size[2] + 15)

    -- top rect
    render.push_clip_rect(pos[1], pos[2], pos[1] + size[1], pos[2] + 22)
    render.rect_filled_rounded(pos[1], pos[2], pos[1] + size[1], pos[2] + size[2], render.color(colormain:get_color().r,colormain:get_color().g,colormain:get_color().b, 255), 8)
    render.pop_clip_rect()

    -- bot rect
    render.push_clip_rect(pos[1], pos[2] + 17, pos[1] + size[1], pos[2] + 22)
    render.rect_filled_rounded(pos[1], pos[2], pos[1] + size[1], pos[2] + 22, render.color(colormain:get_color().r,colormain:get_color().g,colormain:get_color().b, 255), 8)
    render.pop_clip_rect()

    -- other
    render.rect_filled_rounded(pos[1] + 2, pos[2] + 2, pos[1] + size[1] - 2, pos[2] + 20, render.color(24, 24, 26, 255), 6)
    render.text(calibri13, pos[1] + size[1] / 2 - render.get_text_size(tahoma, "keybinds") / 2 - 1, pos[2] + 4, "keybinds", render.color(255, 255, 255, 255))


    local bind_offset = 0
    
    if binds[1] then
    render.text(tahoma, pos[1] + 6, pos[2] + size[2] + 2, binds_name[1], render.color(255, 255, 255, 255))
    render.text(tahoma, pos[1] + size[1] - text_size, pos[2] + size[2] + 2, enabled, render.color(255, 255, 255, 255))
    bind_offset = bind_offset + 15
    end

    if binds[2] then
    render.text(tahoma, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[2], render.color(255, 255, 255, 255))
    render.text(tahoma, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255))
    bind_offset = bind_offset + 15
    end

    if binds[3] then
    render.text(tahoma, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[3], render.color(255, 255, 255, 255))
    render.text(tahoma, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255))
    bind_offset = bind_offset + 15
    end
 
    if binds[4] then
    render.text(tahoma, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[4], render.color(255, 255, 255, 255))
    render.text(tahoma, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255))
    bind_offset = bind_offset + 15
    end

    if binds[5] then
    render.text(tahoma, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[5], render.color(255, 255, 255, 255))
    render.text(tahoma, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255))
    bind_offset = bind_offset + 15
    end

    if binds[6] then
    render.text(tahoma, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[6], render.color(255, 255, 255, 255))
    render.text(tahoma, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255))
    bind_offset = bind_offset + 15
    end

    if binds[7] then
    render.text(tahoma, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[7], render.color(255, 255, 255, 255))
    render.text(tahoma, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255))
    bind_offset = bind_offset + 15
    end

    if binds[8] then
    render.text(tahoma, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[8], render.color(255, 255, 255, 255))
    render.text(tahoma, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255))
    bind_offset = bind_offset + 15
    end

    if binds[9] then
    render.text(tahoma, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[9], render.color(255, 255, 255, 255))
    render.text(tahoma, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255))
    bind_offset = bind_offset + 15
    end

    if binds[10] then
    render.text(tahoma, pos[1] + 6, pos[2] + size[2] + 2 + bind_offset, binds_name[10], render.color(255, 255, 255, 255))
    render.text(tahoma, pos[1] + size[1] - text_size, pos[2] + size[2] + 2 + bind_offset, enabled, render.color(255, 255, 255, 255))
    bind_offset = bind_offset + 15
    end
end
end

--indicators and arrows start
local offset_scope = 0

function ID()

local lp = entities.get_entity(engine.get_local_player())
if not lp then return end
if not lp:is_alive() then return end
local scoped = lp:get_prop("m_bIsScoped")
offset_scope = animation(scoped, offset_scope, 25, 10)

local function Clamp(Value, Min, Max)
    return Value < Min and Min or (Value > Max and Max or Value)
end

if indicatorsmain:get_int() == 1 then
    
    local alpha2 = math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255)
    local lp = entities.get_entity(engine.get_local_player())
    if not lp then return end
    if not lp:is_alive() then return end
    local screen_width, screen_height = render.get_screen_size( )
    local x = screen_width / 2
    local y = screen_height / 2
    local ay = 0

    local RAGE = Find("rage>aimbot>aimbot>aimbot"):get_bool()
    local is_dt = Find("rage>aimbot>aimbot>double tap"):get_bool()
    local is_hs = Find("rage>aimbot>aimbot>hide shot"):get_bool()
    local DMG = Find("rage>aimbot>ssg08>scout>override"):get_bool()
    local SP = Find("rage>aimbot>aimbot>force extra safety"):get_bool()
    local FS = Find("rage>anti-aim>angles>freestand"):get_bool()
--main text
    local text =  "AURORA"
    local text2 = "LIVE"
    local text3 = "DT"
    local text4 = "DMG"
    local text5 = "FS"
    local text6 = "SP"
    local text7 = "OS"

    local textx, texty = render.get_text_size(pixel, text)
    local text2x, text2y = render.get_text_size(pixel, text2)
    local text3x, text3y = render.get_text_size(pixel, text3)
    local text4x, text4y = render.get_text_size(pixel, text4)
    local text5x, text5y = render.get_text_size(pixel, text5)
    local text6x, text6y = render.get_text_size(pixel, text6)
    local text7x, text7y = render.get_text_size(pixel, text7)
--StateIndicator
    local StateIndicator = "STANDING"
    local StateIndicator1 = "RUNNING"
    local StateIndicator2 = "WALKING"
    local StateIndicator3 = "IN-AIR"
    local StateIndicator4 = "IN-AIR+"
    local StateIndicator5 = "DUCKING"

    local StateIndicatorx, StateIndicatory = render.get_text_size(pixel, StateIndicator)
    local StateIndicator1x, StateIndicator1y = render.get_text_size(pixel, StateIndicator1)
    local StateIndicator2x, StateIndicator2y = render.get_text_size(pixel, StateIndicator2)
    local StateIndicator3x, StateIndicator3y = render.get_text_size(pixel, StateIndicator3)
    local StateIndicator4x, StateIndicator4y = render.get_text_size(pixel, StateIndicator4)
    local StateIndicator5x, StateIndicator5y = render.get_text_size(pixel, StateIndicator5)

        render.text(pixel, x+offset_scope, y + 6, text, render.color(255,255, 255, 255))
        render.text(pixel, x+offset_scope + 33, y + 6, text2, render.color(colormain:get_color().r, colormain:get_color().g, colormain:get_color().b, alpha2))

    if playerstate == 1 and not scoped then
        render.text(pixel, x+offset_scope + 7, y + 16, StateIndicator, colormain:get_color())
    else
        if playerstate == 2 and not scoped then
            render.text(pixel, x+offset_scope + 8, y + 16, StateIndicator1, colormain:get_color())
        else
            if playerstate == 3 and not scoped then
                render.text(pixel, x+offset_scope + 7, y + 16, StateIndicator2, colormain:get_color())
            else
                if playerstate == 4 and not scoped then
                    render.text(pixel, x+offset_scope + 14, y + 16, StateIndicator3, colormain:get_color())
                else
                    if playerstate == 5 and not scoped then
                        render.text(pixel, x+offset_scope + 12, y + 16, StateIndicator4, colormain:get_color())
                    else
                        if playerstate == 6 and not scoped then
                            render.text(pixel, x+offset_scope + 8, y + 16, StateIndicator5, colormain:get_color())
                        else
                            if playerstate == 1 and scoped then
                                render.text(pixel, x+offset_scope, y + 16, StateIndicator, colormain:get_color())
                            else
                                if playerstate == 2 and scoped then
                                    render.text(pixel, x+offset_scope, y + 16, StateIndicator1, colormain:get_color())
                                else
                                    if playerstate == 3 and scoped then
                                        render.text(pixel, x+offset_scope, y + 16, StateIndicator2, colormain:get_color())
                                    else
                                        if playerstate == 4 and scoped then
                                            render.text(pixel, x+offset_scope, y + 16, StateIndicator3, colormain:get_color())
                                        else
                                            if playerstate == 5 and scoped then
                                                render.text(pixel, x+offset_scope, y + 16, StateIndicator4, colormain:get_color())
                                            else
                                                if playerstate == 6 and scoped then
                                                    render.text(pixel, x+offset_scope, y + 16, StateIndicator5, colormain:get_color())
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if is_dt and info.fatality.can_fastfire and not scoped then
        render.text(pixel, x+offset_scope + 22, y + 26+ay, text3, render.color(75, 255, 75, 255))
        ay = ay + 10
    else if is_dt and not info.fatality.can_fastfire and not scoped then
            render.text(pixel, x+offset_scope + 22, y + 26+ay, text3, render.color(255, 0, 0, 185))
            ay = ay + 10
    else if is_dt and info.fatality.can_fastfire and scoped then
        render.text(pixel, x+offset_scope, y + 26+ay, text3, render.color(75, 255, 75, 255))
        ay = ay + 10
    else
        if is_dt and not info.fatality.can_fastfire and scoped then
            render.text(pixel, x+offset_scope, y + 26+ay, text3, render.color(255, 0, 0, 185))
            ay = ay + 10
        end
        end
    end
end

    if is_hs then
            render.text(pixel, x+offset_scope + 18, y + 26+ay, text7, render.color(255,255, 255, 255))
        else
            render.text(pixel, x+offset_scope + 18, y + 26+ay, text7, render.color(255,255, 255, 128))
        end

    if DMG then
            render.text(pixel, x+offset_scope, y + 26+ay, text4, render.color(255,255, 255, 255))
        else
            render.text(pixel, x+offset_scope, y + 26+ay, text4, render.color(255,255, 255, 128))
        end

    if FS then
            render.text(pixel, x+offset_scope + 30, y + 26+ay, text5, render.color(255,255, 255, 255))
        else
            render.text(pixel, x+offset_scope + 30, y + 26+ay, text5, render.color(255,255, 255, 128))
        end

    if SP then
            render.text(pixel, x+offset_scope + 42, y + 26+ay, text6, render.color(255,255, 255, 255))
        else
            render.text(pixel, x+offset_scope + 42, y + 26+ay, text6, render.color(255,255, 255, 128))
        end
    end

if indicatorsmain:get_int() == 2 then
    
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
    local color1 = render.color(colormain:get_color().r, colormain:get_color().g, colormain:get_color().b, 255)
    local color2 = render.color(colormain:get_color().r - 70, colormain:get_color().g - 90, colormain:get_color().b - 70, 185)

    local text =  "Aurora°"
    local textx, texty = render.get_text_size(pixel, text)

    render.text(calibri11, x+offset_scope + 5, y + 6, text, render.color(colormain:get_color().r, colormain:get_color().g, colormain:get_color().b, 255))

    render.rect_filled(x + 4 +offset_scope, y + 17, x+offset_scope + w + 5, y + 18 + h + 1, render.color("#000000"))
    render.rect_filled_multicolor(x+offset_scope + 5, y + 18, x+offset_scope + 2 + w * desync_percentage, y + 18 + h, color1, color2, color2, color1)

end
end
--indicators and arrows end``

--syncing clantag
local old_time = 0;
local animation = {

			"d",
            "de",
            "dea",
            "dead",
            "dead-",
            "dead-s",			
            "dead-sy",			
            "dead-syn",
            "dead-sync",
            "dead-sync.",
            "dead-sync.l",
            "dead-sync.lu",
            "dead-sync.lua",
            "dead-sync.lua",
            "dead-sync.lua",
            "dead-sync.lu",	
            "dead-sync.l",
            "dead-sync.",
            "dead-sync",
            "dead-syn",
            "dead-sy",			
            "dead-s",			
            "dead-",
            "dead",
            "dea",
            "de",
			"d",	
        }

--clantag menu element
local function CT()
    if clantagmain:get_bool() then
        local defaultct = Find("misc>various>clan tag")
        local realtime = math.floor((global_vars.realtime) * 1.725)
        if old_time ~= realtime then
            utils.set_clan_tag(animation[realtime % #animation+1]);
        old_time = realtime;
        defaultct:set_bool(false);
        end
    end
end
--clantag end
--ragebot logs
local function main(shot)
if shot.manual then return end
    local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
    local p = entities.get_entity(shot.target)
    local n = p:get_player_info()
    local hitgroup = shot.server_hitgroup
    local clienthitgroup = shot.client_hitgroup
    local health = p:get_prop("m_iHealth")

        if ragebotlogs:get_bool() then
            if shot.server_damage > 0 then
                print( "[``dead-sync.lua] Hurt " , n.name  , "'s ", hitgroup_names[hitgroup + 1]," for " , shot.server_damage, " damage [hc=", math.floor(shot.hitchance), ", bt=", math.floor(shot.backtrack),"]")
            else
                print( "[dead-sync.lua] Missed " , n.name  , "'s ", hitgroup_names[shot.client_hitgroup + 1]," due to ", shot.result)
            end
        end

end
--ragebot logs end

--import and export system
configs.import = function(input)
    local protected = function()
        local clipboardP = input == nil and dec(clipboard.get()) or input
        local tbl = str_to_sub(clipboardP, "|")
        ConditionalStates[1].yawadd:set_bool(to_boolean(tbl[1]))
        ConditionalStates[1].yawaddamount:set_int(tonumber(tbl[2]))
        ConditionalStates[1].spin:set_bool(to_boolean(tbl[3]))
        ConditionalStates[1].spinrange:set_int(tonumber(tbl[4]))
        ConditionalStates[1].spinspeed:set_int(tonumber(tbl[5]))
        ConditionalStates[1].jitter:set_bool(to_boolean(tbl[6]))
        ConditionalStates[1].jittertype:set_int(tonumber(tbl[7]))
        ConditionalStates[1].jitterrange:set_int(tonumber(tbl[8]))
        ConditionalStates[1].desynctype:set_int(tonumber(tbl[9]))
        ConditionalStates[1].desync:set_int(tonumber(tbl[10]))
        ConditionalStates[1].compAngle:set_int(tonumber(tbl[11]))
        ConditionalStates[1].flipJittFake:set_bool(to_boolean(tbl[12]))
        ConditionalStates[1].leanMenu:set_int(tonumber(tbl[13]))
        ConditionalStates[1].leanamount:set_int(tonumber(tbl[14]))
        ConditionalStates[2].yawadd:set_bool(to_boolean(tbl[15]))
        ConditionalStates[2].yawaddamount:set_int(tonumber(tbl[16]))
        ConditionalStates[2].spin:set_bool(to_boolean(tbl[17]))
        ConditionalStates[2].spinrange:set_int(tonumber(tbl[18]))
        ConditionalStates[2].spinspeed:set_int(tonumber(tbl[19]))
        ConditionalStates[2].jitter:set_bool(to_boolean(tbl[20]))
        ConditionalStates[2].jittertype:set_int(tonumber(tbl[21]))
        ConditionalStates[2].jitterrange:set_int(tonumber(tbl[22]))
        ConditionalStates[2].desynctype:set_int(tonumber(tbl[23]))
        ConditionalStates[2].desync:set_int(tonumber(tbl[24]))
        ConditionalStates[2].compAngle:set_int(tonumber(tbl[25]))
        ConditionalStates[2].flipJittFake:set_bool(to_boolean(tbl[26]))
        ConditionalStates[2].leanMenu:set_int(tonumber(tbl[27]))
        ConditionalStates[2].leanamount:set_int(tonumber(tbl[28]))
        ConditionalStates[3].yawadd:set_bool(to_boolean(tbl[29]))
        ConditionalStates[3].yawaddamount:set_int(tonumber(tbl[30]))
        ConditionalStates[3].spin:set_bool(to_boolean(tbl[31]))
        ConditionalStates[3].spinrange:set_int(tonumber(tbl[32]))
        ConditionalStates[3].spinspeed:set_int(tonumber(tbl[33]))
        ConditionalStates[3].jitter:set_bool(to_boolean(tbl[34]))
        ConditionalStates[3].jittertype:set_int(tonumber(tbl[35]))
        ConditionalStates[3].jitterrange:set_int(tonumber(tbl[36]))
        ConditionalStates[3].desynctype:set_int(tonumber(tbl[37]))
        ConditionalStates[3].desync:set_int(tonumber(tbl[38]))
        ConditionalStates[3].compAngle:set_int(tonumber(tbl[39]))
        ConditionalStates[3].flipJittFake:set_bool(to_boolean(tbl[40]))
        ConditionalStates[3].leanMenu:set_int(tonumber(tbl[41]))
        ConditionalStates[3].leanamount:set_int(tonumber(tbl[42]))
        ConditionalStates[4].yawadd:set_bool(to_boolean(tbl[43]))
        ConditionalStates[4].yawaddamount:set_int(tonumber(tbl[44]))
        ConditionalStates[4].spin:set_bool(to_boolean(tbl[45]))
        ConditionalStates[4].spinrange:set_int(tonumber(tbl[46]))
        ConditionalStates[4].spinspeed:set_int(tonumber(tbl[47]))
        ConditionalStates[4].jitter:set_bool(to_boolean(tbl[48]))
        ConditionalStates[4].jittertype:set_int(tonumber(tbl[49]))
        ConditionalStates[4].jitterrange:set_int(tonumber(tbl[50]))
        ConditionalStates[4].desync:set_int(tonumber(tbl[51]))
        ConditionalStates[4].desynctype:set_int(tonumber(tbl[52]))
        ConditionalStates[4].compAngle:set_int(tonumber(tb4l[53]))
        ConditionalStates[4].flipJittFake:set_bool(to_boolean(tbl[54]))
        ConditionalStates[4].leanMenu:set_int(tonumber(tbl[55]))
        ConditionalStates[4].leanamount:set_int(tonumber(tbl[56]))
        ConditionalStates[5].yawadd:set_bool(to_boolean(tbl[57]))
        ConditionalStates[5].yawaddamount:set_int(tonumber(tbl[58]))
        ConditionalStates[5].spin:set_bool(to_boolean(tbl[59]))
        ConditionalStates[5].spinrange:set_int(tonumber(tbl[60]))
        ConditionalStates[5].spinspeed:set_int(tonumber(tbl[61]))
        ConditionalStates[5].jitter:set_bool(to_boolean(tbl[62]))
        ConditionalStates[5].jittertype:set_int(tonumber(tbl[63]))
        ConditionalStates[5].jitterrange:set_int(tonumber(tbl[64]))
        ConditionalStates[5].desynctype:set_int(tonumber(tbl[65]))
        ConditionalStates[5].desync:set_int(tonumber(tbl[66]))
        ConditionalStates[5].compAngle:set_int(tonumber(tbl[67]))
        ConditionalStates[5].flipJittFake:set_bool(to_boolean(tbl[68]))
        ConditionalStates[5].leanMenu:set_int(tonumber(tbl[69]))
        ConditionalStates[5].leanamount:set_int(tonumber(tbl[70]))
        ConditionalStates[6].yawadd:set_bool(to_boolean(tbl[71]))
        ConditionalStates[6].yawaddamount:set_int(tonumber(tbl[72]))
        ConditionalStates[6].spin:set_bool(to_boolean(tbl[73]))
        ConditionalStates[6].spinrange:set_int(tonumber(tbl[74]))
        ConditionalStates[6].spinspeed:set_int(tonumber(tbl[75]))
        ConditionalStates[6].jitter:set_bool(to_boolean(tbl[76]))
        ConditionalStates[6].jittertype:set_int(tonumber(tbl[77]))
        ConditionalStates[6].jitterrange:set_int(tonumber(tbl[78]))
        ConditionalStates[6].desynctype:set_int(tonumber(tbl[79]))
        ConditionalStates[6].desync:set_int(tonumber(tbl[80]))
        ConditionalStates[6].compAngle:set_int(tonumber(tbl[81]))
        ConditionalStates[6].flipJittFake:set_bool(to_boolean(tbl[82]))
        ConditionalStates[6].leanMenu:set_int(tonumber(tbl[83]))
        ConditionalStates[6].leanamount:set_int(tonumber(tbl[84]))


        print("Config loaded")
        
    end
    local status, message = pcall(protected)
    if not status then
        print("Failed to load config")
        return
    end
end


configs.export = function()
    local str = { 
        tostring(ConditionalStates[1].yawadd:get_bool()) .. "|",
        tostring(ConditionalStates[1].yawaddamount:get_int()) .. "|",
        tostring(ConditionalStates[1].spin:get_bool()) .. "|",
        tostring(ConditionalStates[1].spinrange:get_int()) .. "|",
        tostring(ConditionalStates[1].spinspeed:get_int()) .. "|",
        tostring(ConditionalStates[1].jitter:get_bool()) .. "|",
        tostring(ConditionalStates[1].jittertype:get_int()) .. "|",
        tostring(ConditionalStates[1].jitterrange:get_int()) .. "|",
        tostring(ConditionalStates[1].desynctype:get_int()) .. "|",
        tostring(ConditionalStates[1].desync:get_int()) .. "|",
        tostring(ConditionalStates[1].compAngle:get_int()) .. "|",
        tostring(ConditionalStates[1].flipJittFake:get_bool()) .. "|",
        tostring(ConditionalStates[1].leanMenu:get_int()) .. "|",
        tostring(ConditionalStates[1].leanamount:get_int()) .. "|",
        tostring(ConditionalStates[2].yawadd:get_bool()) .. "|",
        tostring(ConditionalStates[2].yawaddamount:get_int()) .. "|",
        tostring(ConditionalStates[2].spin:get_bool()) .. "|",
        tostring(ConditionalStates[2].spinrange:get_int()) .. "|",
        tostring(ConditionalStates[2].spinspeed:get_int()) .. "|",
        tostring(ConditionalStates[2].jitter:get_bool()) .. "|",
        tostring(ConditionalStates[2].jittertype:get_int()) .. "|",
        tostring(ConditionalStates[2].jitterrange:get_int()) .. "|",
        tostring(ConditionalStates[2].desynctype:get_int()) .. "|",
        tostring(ConditionalStates[2].desync:get_int()) .. "|",
        tostring(ConditionalStates[2].compAngle:get_int()) .. "|",
        tostring(ConditionalStates[2].flipJittFake:get_bool()) .. "|",
        tostring(ConditionalStates[2].leanMenu:get_int()) .. "|",
        tostring(ConditionalStates[2].leanamount:get_int()) .. "|",
        tostring(ConditionalStates[3].yawadd:get_bool()) .. "|",
        tostring(ConditionalStates[3].yawaddamount:get_int()) .. "|",
        tostring(ConditionalStates[3].spin:get_bool()) .. "|",
        tostring(ConditionalStates[3].spinrange:get_int()) .. "|",
        tostring(ConditionalStates[3].spinspeed:get_int()) .. "|",
        tostring(ConditionalStates[3].jitter:get_bool()) .. "|",
        tostring(ConditionalStates[3].jittertype:get_int()) .. "|",
        tostring(ConditionalStates[3].jitterrange:get_int()) .. "|",
        tostring(ConditionalStates[3].desynctype:get_int()) .. "|",
        tostring(ConditionalStates[3].desync:get_int()) .. "|",
        tostring(ConditionalStates[3].compAngle:get_int()) .. "|",
        tostring(ConditionalStates[3].flipJittFake:get_bool()) .. "|",
        tostring(ConditionalStates[3].leanMenu:get_int()) .. "|",
        tostring(ConditionalStates[3].leanamount:get_int()) .. "|",
        tostring(ConditionalStates[4].yawadd:get_bool()) .. "|",
        tostring(ConditionalStates[4].yawaddamount:get_int()) .. "|",
        tostring(ConditionalStates[4].spin:get_bool()) .. "|",
        tostring(ConditionalStates[4].spinrange:get_int()) .. "|",
        tostring(ConditionalStates[4].spinspeed:get_int()) .. "|",
        tostring(ConditionalStates[4].jitter:get_bool()) .. "|",
        tostring(ConditionalStates[4].jittertype:get_int()) .. "|",
        tostring(ConditionalStates[4].jitterrange:get_int()) .. "|",
        tostring(ConditionalStates[4].desynctype:get_int()) .. "|",
        tostring(ConditionalStates[4].desync:get_int()) .. "|",
        tostring(ConditionalStates[4].compAngle:get_int()) .. "|",
        tostring(ConditionalStates[4].flipJittFake:get_bool()) .. "|",
        tostring(ConditionalStates[4].leanMenu:get_int()) .. "|",
        tostring(ConditionalStates[4].leanamount:get_int()) .. "|",
        tostring(ConditionalStates[5].yawadd:get_bool()) .. "|",
        tostring(ConditionalStates[5].yawaddamount:get_int()) .. "|",
        tostring(ConditionalStates[5].spin:get_bool()) .. "|",
        tostring(ConditionalStates[5].spinrange:get_int()) .. "|",
        tostring(ConditionalStates[5].spinspeed:get_int()) .. "|",
        tostring(ConditionalStates[5].jitter:get_bool()) .. "|",
        tostring(ConditionalStates[5].jittertype:get_int()) .. "|",
        tostring(ConditionalStates[5].jitterrange:get_int()) .. "|",
        tostring(ConditionalStates[5].desynctype:get_int()) .. "|",
        tostring(ConditionalStates[5].desync:get_int()) .. "|",
        tostring(ConditionalStates[5].compAngle:get_int()) .. "|",
        tostring(ConditionalStates[5].flipJittFake:get_bool()) .. "|",
        tostring(ConditionalStates[5].leanMenu:get_int()) .. "|",
        tostring(ConditionalStates[5].leanamount:get_int()) .. "|",
        tostring(ConditionalStates[6].yawadd:get_bool()) .. "|",
        tostring(ConditionalStates[6].yawaddamount:get_int()) .. "|",
        tostring(ConditionalStates[6].spin:get_bool()) .. "|",
        tostring(ConditionalStates[6].spinrange:get_int()) .. "|",
        tostring(ConditionalStates[6].spinspeed:get_int()) .. "|",
        tostring(ConditionalStates[6].jitter:get_bool()) .. "|",
        tostring(ConditionalStates[6].jittertype:get_int()) .. "|",
        tostring(ConditionalStates[6].jitterrange:get_int()) .. "|",
        tostring(ConditionalStates[6].desynctype:get_int()) .. "|",
        tostring(ConditionalStates[6].desync:get_int()) .. "|",
        tostring(ConditionalStates[6].compAngle:get_int()) .. "|",
        tostring(ConditionalStates[6].flipJittFake:get_bool()) .. "|",
        tostring(ConditionalStates[6].leanMenu:get_int()) .. "|",
        tostring(ConditionalStates[6].leanamount:get_int()) .. "|",
    }
    
        clipboard.set(enc(table.concat(str)))
        print("config was copied")

end

configs.importDefault = function(input)
    input = "dHJ1ZXwtMzJ8ZmFsc2V8MHwwfHRydWV8MXw2MHwyfC02MHwxMDB8ZmFsc2V8MHwwfHRydWV8LTMwfGZhbHNlfDB8MHx0cnVlfDF8NjB8MXw2MHwxMDB8ZmFsc2V8MHwwfHRydWV8LTIwfGZhbHNlfDB8MHx0cnVlfDF8NDV8MHwtNjB8MTAwfGZhbHNlfDB8MHx0cnVlfDN8ZmFsc2V8MHwwfHRydWV8MHw1MnwxfC02MHwxMDB8dHJ1ZXwwfDB8dHJ1ZXw2fGZhbHNlfDB8MHx0cnVlfDB8NDJ8MXw2MHwxMDB8dHJ1ZXwwfDB8dHJ1ZXwzfGZhbHNlfDB8MHx0cnVlfDB8MjR8Mnw2MHwxMDB8dHJ1ZXwwfDB8"
    local clipboardp = dec(input)
    local tbl = str_to_sub(clipboardp, "|")
    ConditionalStates[1].yawadd:set_bool(to_boolean(tbl[1]))
    ConditionalStates[1].yawaddamount:set_int(tonumber(tbl[2]))
    ConditionalStates[1].spin:set_bool(to_boolean(tbl[3]))
    ConditionalStates[1].spinrange:set_int(tonumber(tbl[4]))
    ConditionalStates[1].spinspeed:set_int(tonumber(tbl[5]))
    ConditionalStates[1].jitter:set_bool(to_boolean(tbl[6]))
    ConditionalStates[1].jittertype:set_int(tonumber(tbl[7]))
    ConditionalStates[1].jitterrange:set_int(tonumber(tbl[8]))
    ConditionalStates[1].desynctype:set_int(tonumber(tbl[9]))
    ConditionalStates[1].desync:set_int(tonumber(tbl[10]))
    ConditionalStates[1].compAngle:set_int(tonumber(tbl[11]))
    ConditionalStates[1].flipJittFake:set_bool(to_boolean(tbl[12]))
    ConditionalStates[1].leanMenu:set_int(tonumber(tbl[13]))
    ConditionalStates[1].leanamount:set_int(tonumber(tbl[14]))
    ConditionalStates[2].yawadd:set_bool(to_boolean(tbl[15]))
    ConditionalStates[2].yawaddamount:set_int(tonumber(tbl[16]))
    ConditionalStates[2].spin:set_bool(to_boolean(tbl[17]))
    ConditionalStates[2].spinrange:set_int(tonumber(tbl[18]))
    ConditionalStates[2].spinspeed:set_int(tonumber(tbl[19]))
    ConditionalStates[2].jitter:set_bool(to_boolean(tbl[20]))
    ConditionalStates[2].jittertype:set_int(tonumber(tbl[21]))
    ConditionalStates[2].jitterrange:set_int(tonumber(tbl[22]))
    ConditionalStates[2].desynctype:set_int(tonumber(tbl[23]))
    ConditionalStates[2].desync:set_int(tonumber(tbl[24]))
    ConditionalStates[2].compAngle:set_int(tonumber(tbl[25]))
    ConditionalStates[2].flipJittFake:set_bool(to_boolean(tbl[26]))
    ConditionalStates[2].leanMenu:set_int(tonumber(tbl[27]))
    ConditionalStates[2].leanamount:set_int(tonumber(tbl[28]))
    ConditionalStates[3].yawadd:set_bool(to_boolean(tbl[29]))
    ConditionalStates[3].yawaddamount:set_int(tonumber(tbl[30]))
    ConditionalStates[3].spin:set_bool(to_boolean(tbl[31]))
    ConditionalStates[3].spinrange:set_int(tonumber(tbl[32]))
    ConditionalStates[3].spinspeed:set_int(tonumber(tbl[33]))
    ConditionalStates[3].jitter:set_bool(to_boolean(tbl[34]))
    ConditionalStates[3].jittertype:set_int(tonumber(tbl[35]))
    ConditionalStates[3].jitterrange:set_int(tonumber(tbl[36]))
    ConditionalStates[3].desynctype:set_int(tonumber(tbl[37]))
    ConditionalStates[3].desync:set_int(tonumber(tbl[38]))
    ConditionalStates[3].compAngle:set_int(tonumber(tbl[39]))
    ConditionalStates[3].flipJittFake:set_bool(to_boolean(tbl[40]))
    ConditionalStates[3].leanMenu:set_int(tonumber(tbl[41]))
    ConditionalStates[3].leanamount:set_int(tonumber(tbl[42]))
    ConditionalStates[4].yawadd:set_bool(to_boolean(tbl[43]))
    ConditionalStates[4].yawaddamount:set_int(tonumber(tbl[44]))
    ConditionalStates[4].spin:set_bool(to_boolean(tbl[45]))
    ConditionalStates[4].spinrange:set_int(tonumber(tbl[46]))
    ConditionalStates[4].spinspeed:set_int(tonumber(tbl[47]))
    ConditionalStates[4].jitter:set_bool(to_boolean(tbl[48]))
    ConditionalStates[4].jittertype:set_int(tonumber(tbl[49]))
    ConditionalStates[4].jitterrange:set_int(tonumber(tbl[50]))
    ConditionalStates[4].desync:set_int(tonumber(tbl[51]))
    ConditionalStates[4].desynctype:set_int(tonumber(tbl[52]))
    ConditionalStates[4].compAngle:set_int(tonumber(tbl[53]))
    ConditionalStates[4].flipJittFake:set_bool(to_boolean(tbl[54]))
    ConditionalStates[4].leanMenu:set_int(tonumber(tbl[55]))
    ConditionalStates[4].leanamount:set_int(tonumber(tbl[56]))
    ConditionalStates[5].yawadd:set_bool(to_boolean(tbl[57]))
    ConditionalStates[5].yawaddamount:set_int(tonumber(tbl[58]))
    ConditionalStates[5].spin:set_bool(to_boolean(tbl[59]))
    ConditionalStates[5].spinrange:set_int(tonumber(tbl[60]))
    ConditionalStates[5].spinspeed:set_int(tonumber(tbl[61]))
    ConditionalStates[5].jitter:set_bool(to_boolean(tbl[62]))
    ConditionalStates[5].jittertype:set_int(tonumber(tbl[63]))
    ConditionalStates[5].jitterrange:set_int(tonumber(tbl[64]))
    ConditionalStates[5].desynctype:set_int(tonumber(tbl[65]))
    ConditionalStates[5].desync:set_int(tonumber(tbl[66]))
    ConditionalStates[5].compAngle:set_int(tonumber(tbl[67]))
    ConditionalStates[5].flipJittFake:set_bool(to_boolean(tbl[68]))
    ConditionalStates[5].leanMenu:set_int(tonumber(tbl[69]))
    ConditionalStates[5].leanamount:set_int(tonumber(tbl[70]))
    ConditionalStates[6].yawadd:set_bool(to_boolean(tbl[71]))
    ConditionalStates[6].yawaddamount:set_int(tonumber(tbl[72]))
    ConditionalStates[6].spin:set_bool(to_boolean(tbl[73]))
    ConditionalStates[6].spinrange:set_int(tonumber(tbl[74]))
    ConditionalStates[6].spinspeed:set_int(tonumber(tbl[75]))
    ConditionalStates[6].jitter:set_bool(to_boolean(tbl[76]))
    ConditionalStates[6].jittertype:set_int(tonumber(tbl[77]))
    ConditionalStates[6].jitterrange:set_int(tonumber(tbl[78]))
    ConditionalStates[6].desynctype:set_int(tonumber(tbl[79]))
    ConditionalStates[6].desync:set_int(tonumber(tbl[80]))
    ConditionalStates[6].compAngle:set_int(tonumber(tbl[81]))
    ConditionalStates[6].flipJittFake:set_bool(to_boolean(tbl[82]))
    ConditionalStates[6].leanMenu:set_int(tonumber(tbl[83]))
    ConditionalStates[6].leanamount:set_int(tonumber(tbl[84]))

    print("Config loaded")
end

--callbacks
function on_shutdown()
    utils.set_clan_tag("");
end

function on_shot_registered(shot)
    main(shot)
end

function on_create_move()
    UpdateStateandAA()
    StaticFreestand()
    fakeflick()
    InvertDesync()
end

function on_paint()
    MenuElements()
    RB()
    DA()
    WM()
    KB()
    ID()
    CT()
end