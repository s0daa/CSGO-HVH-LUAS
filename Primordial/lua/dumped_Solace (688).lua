local ffi = require("ffi")
local http = require("primordial/Lightweight HTTP Library.46")
local panorama = require("primordial/panorama-library.248")

local http = http.new({
    task_interval = 1, -- polling intervals
    enable_debug = false, -- print http requests to the console
    timeout = 20 -- request expiration time
})

openlink = function (link)
  local overlay = panorama.SteamOverlayAPI
  local openbrowser = overlay.OpenExternalBrowserURL
  openbrowser(link)
end

ffi.cdef[[
    typedef int(__thiscall* get_clipboard_text_length)(void*);
    typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
    typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

local VGUI_System = ffi.cast(ffi.typeof("void***"), memory.create_interface("vgui2.dll", "VGUI_System010"))
local get_clipboard_text_length = ffi.cast("get_clipboard_text_length", VGUI_System[0][7])
local get_clipboard_text = ffi.cast("get_clipboard_text", VGUI_System[0][11])
local set_clipboard_text = ffi.cast("set_clipboard_text", VGUI_System[0][9])

local function Clipboard_Get()
    local clipboard_text_length = get_clipboard_text_length(VGUI_System)

    if (clipboard_text_length > 0) then
        local buffer = ffi.new("char[?]", clipboard_text_length) or error("Cannot get buffer")
        get_clipboard_text(VGUI_System, 0, buffer, clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length))
        return ffi.string(buffer, clipboard_text_length - 1)
    end
    return ""
end

local function Clipboard_Set(text)
    set_clipboard_text(VGUI_System, text, #text)
end

local b ='KmAWpuFBOhdbI1orP2UN5vnSJcxVRgazk97ZfQqL0yHCl84wTj3eYXiD6stEGM+/=$#@!%^'

local enc = function(data)
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

local dec = function(data)
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

local abfunc = {

    dist = function(self, a, b, c)
        local bc = c - b;
        local ba = a - b;

        if (self.vdot(ba, bc) <= 0.0) then
            return ba:length();
        end
        local ca = a - c;
        if (self.vdot(ca, bc) >= 0.0) then 
            return ca:length();
        end
        return (self.vcross(bc, ba)):length() / bc:length();
    end,
    vdot = function(b, c)
        return b.x * c.x + b.y * c.y + b.z * c.z
    end,
    vcross = function(b, c)
        return vec3_t(b.y * c.z - b.z * c.y, b.z * c.x - b.x * c.z, b.x * c.y - b.y * c.x)
    end,
}

local refs = {
    yawadd = menu.find("antiaim","main", "angles","yaw add"),
    rotate = menu.find("antiaim","main", "angles","rotate"),
    rotaterange = menu.find("antiaim","main", "angles","rotate range"),
    rotatespeed = menu.find("antiaim","main", "angles","rotate speed"),
    jittermode = menu.find("antiaim","main", "angles","jitter mode"),
    jittertype = menu.find("antiaim","main", "angles","jitter type"),
    jitteradd = menu.find("antiaim","main", "angles","jitter add"),
    D_side = menu.find("antiaim","main", "desync","side"),
    D_side = menu.find("antiaim","main", "desync","side#stand"),
    leftdesyncamount = menu.find("antiaim","main", "desync","left amount"),
    rightdesyncamount = menu.find("antiaim","main", "desync","right amount"),
    moveoverride = menu.find("antiaim","main", "desync","override stand#move"),
    DT = menu.find("aimbot", "general", "exploits", "doubletap", "enable")[2],
    HS = menu.find("aimbot", "general", "exploits", "hideshots", "enable")[2],
    FS = menu.find("antiaim","main","auto direction","enable")[2],
    pingspikeenable = menu.find("aimbot","general", "fake ping","enable")[2],
    pingspike = menu.find("aimbot","general", "fake ping","ping amount"),
    slowwalk = menu.find("misc","main","movement","slow walk")[2],
    fakeduck = menu.find("antiaim","main","general","fakeduck")[2],
}

if refs.yawadd:get() == nil then
    return
end

local player_states = {
    "Fakelag",
    "Stand",
    "Move",
    "Slow-Walk",
    "Air",
    "Air+C",
    "Duck"
}

local pstates = {
    "F",
    "S",
    "M",
    "SW",
    "A",
    "AC",
    "D"
}

local globals = {
    time_since_shot = 0,
    distance = 0,
    miss = 0,
    brute = false,
    Yawadd = nil,
    Yawleft = nil,
    Yawright = nil,
    YawleftR = nil,
    YawrightR = nil,
    YRandomization = nil,
    YawAddSway = nil,
    SpinAmount = nil,
    TWYaw1 = nil,
    TWYaw2 = nil,
    TWYaw3 = nil,
    Jitteramount = nil,
    JitterL = nil,
    JitterR = nil,
    JitterLR = nil,
    JitterRR = nil,
    JRandomization = nil,
    desyncside = nil,
    desyncleftamount = nil,
    desyncrightamount = nil,
}



local ui = {
    tabs = menu.add_selection("Solace | Tabs", "Current Tab:", {"Solace | Information", "Solace | Anti-aim", "Solace | Misc/Visuals"}),
    antiaimstate = menu.add_selection("Solace | Anti-aim", "State", player_states),
    infotext = menu.add_text("Solace | Information", ">> Latest update log:"),
    discordbutton = menu.add_button("Solace | Links", "Join our discord server", function() panorama.open().SteamOverlayAPI.OpenURL('https://discord.gg/solace') end),
    tokenbutton = menu.add_button("Solace | Links", "Generate discord auth token", function() authtoken() end),
    Animslist = menu.add_multi_selection("Solace | Misc", "Clientside animations", {"Backwards legs", "Static legs in air", "Lean in air", "0 pitch on land"}),
    Indicators = menu.add_selection("Solace | Visuals", "Indicators", {"-", "Solace"}),
}

Antiaim = {}
Antibrute = {}

for i = 1, 7 do
    Antiaim[i] = {
        EnableAA = menu.add_checkbox("Solace | Anti-aim", "["..pstates[i].."] Enable condition", false),
        label0 = menu.add_text("Solace | Anti-aim", ""),
        Yawmode = menu.add_selection("Solace | Anti-aim","["..pstates[i].."] Yaw type", {"Static", "Jitter", "Jitter random", "Sway", "Spin", "3-Way"}),
        Yawadd  = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Yaw add", -180, 180),
        Yawleft = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Yaw add left", 0.01, 180),
        Yawright = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Yaw add right", 0.01, 180),
        YawleftR = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Yaw add left", 0.01, 180),
        YawrightR = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Yaw add right", 0.01, 180),
        YRandomization = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Randomization", 0.01, 180),
        YawAddSway = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Sway Amount", 0, 180),
        SwaySpeed = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Sway Speed", 1, 8),
        SpinAmount = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Spin Amount", 0.1, 180),
        SpinSpeed = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Spin Speed", 1, 12),
        TWYaw1 = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Yaw offset 1", -180, 180),
        TWYaw2 = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Yaw offset 2", -180, 180),
        TWYaw3 = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Yaw offset 3", -180, 180),
        label1 = menu.add_text("Solace | Anti-aim", ""),
        Jittermode = menu.add_selection("Solace | Anti-aim","["..pstates[i].."] Jitter Mode", {"None", "Static", "Random"}),
        Jittertype = menu.add_selection("Solace | Anti-aim","["..pstates[i].."] Jitter Type", {"Offset", "Center", "L&R Center", "L&R Random"}),
        Jitteramount = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Jitter amount", -180, 180),
        JitterL = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Jitter left", 0.1, 180),
        JitterR = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Jitter right", 0.1, 180),
        JitterLR = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Jitter left random", 0.1, 180),
        JitterRR = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Jitter right random", 0.1, 180),
        JRandomization = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Randomization", 0.1, 180),
        label3 = menu.add_text("Solace | Anti-aim", ""),
        DesyncSide = menu.add_selection("Solace | Anti-aim","["..pstates[i].."] Desync Side", {"None", "Left", "Right", "Jitter", "Peek fake","Peek real", "body sway"}),
        Desyncleft = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Desync left", 0, 100),
        Desyncright = menu.add_slider("Solace | Anti-aim", "["..pstates[i].."] Desync right", 0, 100),

    }
end

for i = 1, 7 do
    Antibrute[i] = {
        EnableAB = menu.add_checkbox("Solace | Anti-brute", "["..pstates[i].."] Enable anti-bruteforce", false),
        label0 = menu.add_text("Solace | Anti-brute", ""),
        ABTime = menu.add_slider("Solace | Anti-brute", "["..pstates[i].."] anti-bruteforce time", 1, 10),
        ABType = menu.add_selection("Solace | Anti-brute","["..pstates[i].."] anti-bruteforce type", {"Generated", "Static", "Side-Detection"}),
    }
end

exportaa = menu.add_button("Solace | Configs", "Export Config", function() exportaa() end)
importaa = menu.add_button("Solace | Configs", "Import Config", function() importaa() end)
importdefaultaa = menu.add_button("Solace | Configs", "Import default Config", function() importdefaultaa() end)

AntiaimStates = function()

    local local_player = entity_list.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end

    props = {
        velx = local_player:get_prop("m_vecVelocity").x,
        vely = local_player:get_prop("m_vecVelocity").y,
        velz = local_player:get_prop("m_vecVelocity").z,
        ground_entity = local_player:get_prop("m_hGroundEntity"),
        duck_amount = local_player:get_prop("m_flDuckAmount"),
    }
    local velocity = math.sqrt(props.velx*props.velx + props.vely*props.vely)
    local land_delay = 0

    local playerstate = 1

    if exploits.get_charge() == 0 or refs.fakeduck:get() then
        playerstate = 1
    elseif props.duck_amount > 0.7 and exploits.get_charge() > 0.01 then
        if props.ground_entity == -1 then
            land_delay = global_vars.real_time() + 0.05
            playerstate = 6
        elseif props.ground_entity > 0 and land_delay < global_vars.real_time() then
            playerstate = 7
        end
    elseif exploits.get_charge() > 0.01 then
        if refs.slowwalk:get() then
            playerstate = 4
        elseif props.ground_entity > 0 then
            if velocity > 10 and land_delay < global_vars.real_time() then
                playerstate = 3
            elseif velocity < 5 then
                playerstate = 2
            end
        else
            land_delay = global_vars.real_time() + 0.05
            playerstate = 5
        end
    end
    return playerstate
end

callbacks.add(e_callbacks.RUN_COMMAND, AntiaimStates)

local curphase = 1

ApplyAntiaim = function()

    local local_player = entity_list.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end

    local state = AntiaimStates()

    if not Antiaim[state].EnableAA:get() then
      return
    end

    refs.moveoverride:set(false)

    local threeway = {Antiaim[state].TWYaw1:get(), Antiaim[state].TWYaw2:get(), Antiaim[state].TWYaw3:get()}

    if global_vars.tick_count() % 4 > 1 and exploits.get_charge() > 0.01 then
        curphase = curphase + 1
    end

    if curphase > 3 then
        curphase = 1
    end
    
    if Antiaim[state].Yawmode:get() == 1 then
      refs.yawadd:set(Antiaim[state].Yawadd:get())
    elseif Antiaim[state].Yawmode:get() == 2 then
      refs.yawadd:set(antiaim.get_desync_side() == 1 and Antiaim[state].Yawleft:get() or -Antiaim[state].Yawright:get())
    elseif Antiaim[state].Yawmode:get() == 3 then
      refs.yawadd:set(antiaim.get_desync_side() == 1 and math.random(Antiaim[state].YawleftR:get(), Antiaim[state].YawleftR:get() + Antiaim[state].YRandomization:get() / 2) or math.random(-Antiaim[state].YawrightR:get() - Antiaim[state].YRandomization:get() / 2, -Antiaim[state].YawrightR:get()))
    elseif Antiaim[state].Yawmode:get() == 4 then
      refs.yawadd:set(math.sin(global_vars.real_time() * Antiaim[state].SwaySpeed:get()) * Antiaim[state].YawAddSway:get())
    elseif Antiaim[state].Yawmode:get() == 5 then
      refs.yawadd:set(-math.fmod(global_vars.cur_time() / 0.1 * Antiaim[state].SpinSpeed:get() * 5 / 3 * Antiaim[state].SpinSpeed:get() * 5, Antiaim[state].SpinAmount:get() * 2) + Antiaim[state].SpinAmount:get())
    elseif Antiaim[state].Yawmode:get() == 6 then
        refs.yawadd:set(threeway[curphase])
    end

    refs.jittermode:set(Antiaim[state].Jittermode:get())
    refs.jittertype:set(Antiaim[state].Jittertype:get())
    
    if Antiaim[state].Jittertype:get() == 1 or Antiaim[state].Jittertype:get() == 2 then
      refs.jitteradd:set(Antiaim[state].Jitteramount:get())
    elseif Antiaim[state].Jittertype:get() == 3 then
      refs.jitteradd:set(antiaim.get_desync_side() == 1 and Antiaim[state].JitterL:get() or Antiaim[state].JitterR:get())
    elseif Antiaim[state].Jittertype:get() == 4 then
      refs.jitteradd:set(antiaim.get_desync_side() == 1 and math.random(Antiaim[state].JitterLR:get(), Antiaim[state].JitterLR:get() + Antiaim[state].JRandomization:get() / 2) or math.random(Antiaim[state].JitterRR:get(), Antiaim[state].JitterRR:get() + Antiaim[state].JRandomization:get() / 2))
    end
    
    refs.D_side:set(Antiaim[state].DesyncSide:get())
    
    refs.leftdesyncamount:set(Antiaim[state].Desyncleft:get())
    refs.rightdesyncamount:set(Antiaim[state].Desyncright:get())

end

callbacks.add(e_callbacks.ANTIAIM, ApplyAntiaim)

detect_bullet_impact = function(event)

    local local_player = entity_list.get_local_player()

    local shooter = entity_list.get_player_from_userid(event.userid)
    local state = AntiaimStates()

    if shooter == local_player then
        return
    end

    if not shooter or not shooter:is_enemy() or not local_player:is_alive() then
        return
    end
    
    local eye = abfunc:dist(local_player:get_eye_position(), shooter:get_eye_position(), vec3_t(event.x, event.y, event.z))
    local body = abfunc:dist(local_player:get_hitbox_pos(e_hitboxes.CHEST), shooter:get_eye_position(), vec3_t(event.x, event.y, event.z))
    local left_arm_dist = abfunc:dist(local_player:get_hitbox_pos(e_hitboxes.LEFT_FOREARM), shooter:get_eye_position(), vec3_t(event.x, event.y, event.z))
    local right_arm_dist = abfunc:dist(local_player:get_hitbox_pos(e_hitboxes.RIGHT_FOREARM), shooter:get_eye_position(), vec3_t(event.x, event.y, event.z))
    local closest_arm = nil

    Distance = math.min(eye, body)

    if math.abs(Distance) < 85 then
        
        if left_arm_dist < right_arm_dist then
            closest_arm = "right"
        else
            closest_arm = "left"
        end

        if global_vars.real_time() - globals.time_since_shot >= 0 then
            globals.miss = globals.miss + 1
            globals.time_since_shot = global_vars.real_time()
            if Antibrute[state].ABType:get() == 1 then
                
                globals.Yawadd = math.random(Antiaim[state].Yawadd:get() * 0.65, Antiaim[state].Yawadd:get() * 1.35)
                globals.Yawleft = math.random(Antiaim[state].Yawleft:get() * 0.65, Antiaim[state].Yawleft:get() * 1.35)
                globals.Yawright = math.random(-Antiaim[state].Yawright:get() * 0.65, -Antiaim[state].Yawright:get() * 1.35)
                globals.YawleftR = math.random(Antiaim[state].YawleftR:get() * 0.65, Antiaim[state].YawleftR:get() * 1.35)
                globals.YawrightR = math.random(Antiaim[state].YawrightR:get() * 0.65, Antiaim[state].YawrightR:get() * 1.35)
                globals.YRandomization = math.random(Antiaim[state].YRandomization:get() * 0.65, Antiaim[state].YRandomization:get() * 1.35)
                globals.YawAddSway = math.random(Antiaim[state].YawAddSway:get() * 0.65, Antiaim[state].YawAddSway:get() * 1.35)
                globals.SpinAmount = math.random(Antiaim[state].SpinAmount:get() * 0.65, Antiaim[state].SpinAmount:get() * 1.35)
                globals.TWYaw1 = math.random(Antiaim[state].TWYaw1:get() * 0.65, Antiaim[state].TWYaw1:get() * 1.35)
                globals.TWYaw2 = math.random(Antiaim[state].TWYaw2:get() * 0.65, Antiaim[state].TWYaw2:get() * 1.35)
                globals.TWYaw3 = math.random(Antiaim[state].TWYaw3:get() * 0.65, Antiaim[state].TWYaw3:get() * 1.35)
                globals.Jitteramount = math.random(Antiaim[state].Jitteramount:get() * 0.8, Antiaim[state].Jitteramount:get() * 1.35)
                globals.JitterL = math.random(Antiaim[state].JitterL:get() * 0.65, Antiaim[state].JitterL:get() * 1.35)
                globals.JitterR = math.random(Antiaim[state].JitterR:get() * 0.65, Antiaim[state].JitterR:get() * 1.35)
                globals.JitterLR = math.random(Antiaim[state].JitterLR:get() * 0.65, Antiaim[state].JitterLR:get() * 1.35)
                globals.JitterRR = math.random(Antiaim[state].JitterRR:get() * 0.65, Antiaim[state].JitterRR:get() * 1.35)
                globals.JRandomization = math.random(Antiaim[state].JRandomization:get() * 0.65, Antiaim[state].JRandomization:get() * 1.35)
                globals.desyncside = Antiaim[state].DesyncSide:get()
                globals.desyncleftamount = math.random(Antiaim[state].Desyncleft:get() * 0.65, Antiaim[state].Desyncleft:get())
                globals.desyncrightamount = math.random(Antiaim[state].Desyncright:get() * 0.65, Antiaim[state].Desyncright:get())
            elseif Antibrute[state].ABType:get() == 2 then
                globals.Yawadd = 0.1
                globals.Yawleft = 0.1
                globals.Yawright = 0.1
                globals.YawleftR = 0.1
                globals.YawrightR = 0.1
                globals.YRandomization = 0.1
                globals.YawAddSway = 0.1
                globals.SpinAmount = 0.1
                globals.TWYaw1 = 0.1
                globals.TWYaw2 = 0.1
                globals.TWYaw3 = 0.1
                globals.Jitteramount = 0.1
                globals.JitterL = 0.1
                globals.JitterR = 0.1
                globals.JitterLR = 0.1
                globals.JitterRR = 0.1
                globals.JRandomization = 0.1
                globals.desyncside = 2
                globals.desyncleftamount = 100
                globals.desyncrightamount = 100
            elseif Antibrute[state].ABType:get() == 3 then
                if closest_arm == "right" then
                    --right
                    globals.Yawright = math.random(Antiaim[state].Yawright:get() * 0.65, Antiaim[state].Yawright:get() * 1.35)
                    globals.YawrightR = math.random(Antiaim[state].YawrightR:get() * 0.65, Antiaim[state].YawrightR:get() * 1.35)
                    globals.YRandomization = math.random(Antiaim[state].YRandomization:get() * 0.65, Antiaim[state].YRandomization:get() * 1.35)
                    globals.YawAddSway = math.random(Antiaim[state].YawAddSway:get() * 0.65, Antiaim[state].YawAddSway:get() * 1.35)
                    globals.SpinAmount = math.random(Antiaim[state].SpinAmount:get() * 0.65, Antiaim[state].SpinAmount:get() * 1.35)
                    globals.Jitteramount = math.random(Antiaim[state].Jitteramount:get() * 0.65, Antiaim[state].Jitteramount:get() * 1.35)
                    globals.JitterR = math.random(Antiaim[state].JitterR:get() * 0.65, Antiaim[state].JitterR:get() * 1.35)
                    globals.JitterRR = math.random(Antiaim[state].JitterRR:get() * 0.65, Antiaim[state].JitterRR:get() * 1.35)
                    globals.JRandomization = math.random(Antiaim[state].JRandomization:get() * 0.65, Antiaim[state].JRandomization:get() * 1.35)
                    globals.desyncrightamount = math.random(Antiaim[state].Desyncright:get() * 0.48, Antiaim[state].Desyncright:get())
                    --left
                    globals.Yawadd = Antiaim[state].Yawadd:get()
                    globals.Yawleft = Antiaim[state].Yawleft:get()
                    globals.YawleftR = Antiaim[state].YawleftR:get()
                    globals.JitterL = Antiaim[state].JitterL:get()
                    globals.JitterLR = Antiaim[state].JitterLR:get()
                    globals.desyncside = Antiaim[state].DesyncSide:get()
                    globals.desyncleftamount = Antiaim[state].Desyncleft:get()
                elseif closest_arm == "left" then
                    --left
                    globals.Yawadd = math.random(Antiaim[state].Yawadd:get() * 0.65, Antiaim[state].Yawadd:get() * 1.35)
                    globals.Yawleft = math.random(Antiaim[state].Yawleft:get() * 0.65, Antiaim[state].Yawleft:get() * 1.35)
                    globals.YawleftR = math.random(Antiaim[state].YawleftR:get() * 0.65, Antiaim[state].YawleftR:get() * 1.35)
                    globals.YRandomization = math.random(Antiaim[state].YRandomization:get() * 0.65, Antiaim[state].YRandomization:get() * 1.35)
                    globals.YawAddSway = math.random(Antiaim[state].YawAddSway:get() * 0.65, Antiaim[state].YawAddSway:get() * 1.35)
                    globals.SpinAmount = math.random(Antiaim[state].SpinAmount:get() * 0.65, Antiaim[state].SpinAmount:get() * 1.35)
                    globals.Jitteramount = math.random(Antiaim[state].Jitteramount:get() * 0.65, Antiaim[state].Jitteramount:get() * 1.35)
                    globals.JitterL = math.random(Antiaim[state].JitterL:get() * 0.65, Antiaim[state].JitterL:get() * 1.35)
                    globals.JitterLR = math.random(Antiaim[state].JitterLR:get() * 0.65, Antiaim[state].JitterLR:get() * 1.35)
                    globals.JRandomization = math.random(Antiaim[state].JRandomization:get() * 0.65, Antiaim[state].JRandomization:get() * 1.35)
                    globals.desyncleftamount = math.random(Antiaim[state].Desyncleft:get() * 0.48, Antiaim[state].Desyncleft:get())
                    --right
                    globals.Yawright = Antiaim[state].Yawright:get()
                    globals.YawrightR = Antiaim[state].YawrightR:get()
                    globals.JitterR = Antiaim[state].JitterR:get()
                    globals.JitterRR = Antiaim[state].JitterRR:get()
                    globals.desyncside = Antiaim[state].DesyncSide:get()
                    globals.desyncrightamount = Antiaim[state].Desyncright:get()
                end
            end
        end
    end
end
-- antiaimbot
Antibruteforce = function()
    
    local local_player = entity_list.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end

    local state = AntiaimStates()
        -- Brute Set's
    if globals.time_since_shot + Antibrute[state].ABTime:get()/2 > global_vars.real_time() then
        if Antibrute[state].EnableAB:get() then
        globals.brute = true
        if not Antiaim[state].EnableAA:get() then
            return
        end

        if Antiaim[state].Yawmode:get() == 1 then
            refs.yawadd:set(globals.Yawadd)
        end
    
        if Antiaim[state].Yawmode:get() == 2 then
            if antiaim.get_desync_side() == 1 then
                refs.yawadd:set(globals.Yawleft)
            else
                refs.yawadd:set(-globals.Yawright)
            end
        end
    
        if Antiaim[state].Yawmode:get() == 3 then
            if antiaim.get_desync_side() == 1 then
                refs.yawadd:set(math.random(globals.YawleftR, globals.YawleftR+globals.YRandomization/2))
            else
                refs.yawadd:set(math.random(-globals.YawrightR, -globals.YawrightR-globals.YRandomization/2))
            end
        end
    
        if Antiaim[state].Yawmode:get() == 4 then
            refs.yawadd:set(math.sin((global_vars.real_time() * Antiaim[state].SwaySpeed:get())) * globals.YawAddSway)
        end
    
        if Antiaim[state].Yawmode:get() == 5 then
            refs.yawadd:set((-math.fmod(global_vars.cur_time() / 0.1 * (Antiaim[state].SpinSpeed:get() * 5) / 3 * (Antiaim[state].SpinSpeed:get() * 5), globals.SpinAmount * 2) + globals.SpinAmount) * -1)
        end

        if Antiaim[state].Jittertype:get() == 1 or Antiaim[state].Jittertype:get() == 2 then
            refs.jitteradd:set(globals.Jitteramount)
        end
    
        if Antiaim[state].Jittertype:get() == 3 then
            if antiaim.get_desync_side() == 1 then
                refs.jitteradd:set(globals.JitterL)
            else
                refs.jitteradd:set(globals.JitterR)
            end
        end
    
        if Antiaim[state].Jittertype:get() == 4 then
            if antiaim.get_desync_side() == 1 then
                refs.jitteradd:set(math.random(globals.JitterLR, globals.JitterLR+globals.JRandomization/2))
            else
                refs.jitteradd:set(math.random(globals.JitterRR, globals.JitterRR+globals.JRandomization/2))
            end
        end

        if Antibrute[state].ABType:get() == 2 then
            refs.D_side:set(globals.desyncside)
        end

        refs.leftdesyncamount:set(globals.desyncleftamount)
        refs.rightdesyncamount:set(globals.desyncrightamount)
    end
    end
end

callbacks.add(e_callbacks.ANTIAIM, Antibruteforce)
callbacks.add(e_callbacks.EVENT, detect_bullet_impact, "bullet_impact")

local clientside_animations = {}

clientside_animations.ground_tick = 1
clientside_animations.end_time = 0
clientside_animations.handle = function (poseparam)
    local localPlayer = entity_list.get_local_player()

    if not localPlayer then
        return
    end

    local velo = localPlayer:get_prop("m_vecVelocity[1]") ~= 0 
    local flags = localPlayer:get_prop("m_fFlags")
    local on_land = bit.band(flags, bit.lshift(1, 0)) ~= 0
    local is_in_air = bit.band(flags, bit.lshift(1, 0)) == 0

    local curtime = global_vars.cur_time()

    if on_land == true then
        clientside_animations.ground_tick = clientside_animations.ground_tick + 1
    else
        clientside_animations.ground_tick = 0
        clientside_animations.end_time = curtime + 1
    end

    local byamount = nil

    if ui.Animslist:get(1) then
        poseparam:set_render_pose(e_poses.RUN, 1)
    end

    if ui.Animslist:get(2) and is_in_air then
        poseparam:set_render_pose(e_poses.JUMP_FALL, 1)
    end

    if ui.Animslist:get(3) and is_in_air and velo then
        poseparam:set_render_animlayer(e_animlayers.LEAN, 1)
    end

    if ui.Animslist:get(4) and clientside_animations.ground_tick > 1 and clientside_animations.end_time > curtime then
        poseparam:set_render_pose(e_poses.BODY_PITCH, 0.425)
    end
end

callbacks.add(e_callbacks.ANTIAIM, clientside_animations.handle)

clampfunc = function(cur, min, max)
    if cur == nil or min == nil or max == nil then
        return nil
    end
    if min > max then
        return nil
    end
    if cur < min then
        return min
    end
    if cur > max then
        return max
    end

    return cur
end

animation = function(check, name, value, speed) 
    if check then 
        return name + (value - name) * global_vars.interval_per_tick() * speed
    else 
        return name - (value + name) * global_vars.interval_per_tick() * speed
    end
end

local function inQuint(t, b, c, d)
	t = t / d
	return c * math.pow(t, 5) + b
end

local pixel = render.create_font("Small Fonts", 10, 100, e_font_flags.OUTLINE, e_font_flags.BOLD)

easedalphas = {
    dtalpha = 0,
    dtalpha1 = 0,
    hasalpha = 0,
    hasalpha1 = 0,
    fabalpha = 0,
    fabalpha1 = 0,
    osalpha = 0,
    osalpha1 = 0,
    scalpha = 0,
    scalpha1 = 0,
};

local land_delay = 0

local function on_paint()

    if ui.Indicators:get() == 2 then
    
    local local_player = entity_list.get_local_player()
    
    if not local_player or not local_player:is_alive() then
        return
    end
    
    local x, y = render.get_screen_size().x, render.get_screen_size().y
    
    local color_shift = clampfunc(exploits.get_charge() * 255, 0, 255)

    props = {
        velx = local_player:get_prop("m_vecVelocity").x,
        vely = local_player:get_prop("m_vecVelocity").y,
        velz = local_player:get_prop("m_vecVelocity").z,
        ground_entity = local_player:get_prop("m_hGroundEntity"),
        duck_amount = local_player:get_prop("m_flDuckAmount"),
    }
    local velocity = math.sqrt(props.velx*props.velx + props.vely*props.vely)

    if exploits.get_charge() == 0 or refs.fakeduck:get() then
        statetotext = "Fakelag"
    elseif props.duck_amount > 0.7 and exploits.get_charge() > 0.01 then
        if props.ground_entity == -1 then
            land_delay = global_vars.real_time() + 0.05
            statetotext = "Air+Duck"
        elseif props.ground_entity > 0 and land_delay < global_vars.real_time() then
            statetotext = "Ducking"
        end
    elseif exploits.get_charge() > 0.01 then
        if refs.slowwalk:get() then
            statetotext = "Walking"
        elseif props.ground_entity > 0 then
            if velocity > 10 and land_delay < global_vars.real_time() then
                statetotext = "Running"
            elseif velocity < 5 then
                statetotext = "Standing"
            end
        else
            land_delay = global_vars.real_time() + 0.05
            statetotext = "In-Air"
        end
    end

    easedalphas.dtalpha1 = refs.DT:get() and 255 or 0;
    easedalphas.dtalpha = inQuint(1, easedalphas.dtalpha, easedalphas.dtalpha1 - easedalphas.dtalpha, 2);
    easedalphas.osalpha1 = refs.HS:get() and 255 or 0;
    easedalphas.osalpha = inQuint(1, easedalphas.osalpha, easedalphas.osalpha1 - easedalphas.osalpha, 2);
    easedalphas.fabalpha1 = refs.FS:get() and 255 or 0;
    easedalphas.fabalpha = inQuint(1, easedalphas.fabalpha, easedalphas.fabalpha1 - easedalphas.fabalpha, 2);
    easedalphas.hasalpha1 = refs.pingspikeenable:get() and refs.pingspike:get() > 0 and 255 or 0;
    easedalphas.hasalpha = inQuint(1, easedalphas.hasalpha, easedalphas.hasalpha1 - easedalphas.hasalpha, 2);
    easedalphas.scalpha1 = local_player:get_prop("m_bIsScoped", 1) and 27 or 0;
    easedalphas.scalpha = inQuint(1, easedalphas.scalpha, easedalphas.scalpha1 - easedalphas.scalpha, 2);

    dtalpha1 = animation(refs.DT:get(), 0, 255, 5)
    osalpha = animation(refs.HS:get(), 0, 255, 5)
    fsalpha = animation(refs.FS:get(), 0, 255, 5)
    pingspikealpha = animation(refs.pingspikeenable:get() and refs.pingspike:get() > 0, 0, 255, 5)
    scopedanim = animation(local_player:get_prop("m_bIsScoped", 1), 0, 27, 5)

    added = 0
    added = added + (scopedanim);


    render.text(pixel, "Solace", vec2_t(x/2+10+added/0.7, y/2+15), color_t(255,255,255, 255))
    render.text(pixel, statetotext, vec2_t(x/2+10+added/0.7, y/2+22), color_t(255,255,255, 255))
    render.text(pixel, "DT", vec2_t(x/2+10+added/0.7, y/2+21+easedalphas.dtalpha/31), color_t(165, color_shift, 0, (refs.DT:get() and 255 or 0)))
    render.text(pixel, "OS", vec2_t(x/2+10+added/0.7, y/2+21+easedalphas.dtalpha/31+easedalphas.osalpha/31), color_t(255, 255, 255, (refs.HS:get() and 255 or 0)))
    render.text(pixel, "FS", vec2_t(x/2+10+added/0.7, y/2+21+easedalphas.dtalpha/31+easedalphas.osalpha/31+easedalphas.fabalpha/31), color_t(255, 255, 255, (refs.FS:get() and 255 or 0)))
    render.text(pixel, "PING", vec2_t(x/2+10+added/0.7, y/2+21+easedalphas.dtalpha/31+easedalphas.osalpha/31+easedalphas.fabalpha/31+easedalphas.hasalpha/31),color_t(155, 196, 20, (refs.pingspikeenable:get() and refs.pingspike:get() > 0 and 255 or 0)))

    end 
end
   
callbacks.add(e_callbacks.PAINT, on_paint)

callbacks.add(e_callbacks.PAINT, function()

local tab = ui.tabs:get()
local selection = ui.antiaimstate:get()

for i = 1, 7 do

    local JT = Antiaim[i].Jittertype:get() == 1 or Antiaim[i].Jittertype:get() == 2

    Antiaim[i].EnableAA:set_visible(tab == 2 and selection == i)
    Antiaim[i].Yawmode:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get())
    Antiaim[i].Yawadd:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and Antiaim[i].Yawmode:get() == 1)
    Antiaim[i].Yawleft:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and Antiaim[i].Yawmode:get() == 2)
    Antiaim[i].Yawright:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and Antiaim[i].Yawmode:get() == 2)
    Antiaim[i].YawleftR:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and Antiaim[i].Yawmode:get() == 3)
    Antiaim[i].YawrightR:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and Antiaim[i].Yawmode:get() == 3)
    Antiaim[i].YRandomization:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and Antiaim[i].Yawmode:get() == 3)
    Antiaim[i].YawAddSway:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and Antiaim[i].Yawmode:get() == 4)
    Antiaim[i].SwaySpeed:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and Antiaim[i].Yawmode:get() == 4)
    Antiaim[i].SpinAmount:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and Antiaim[i].Yawmode:get() == 5)
    Antiaim[i].SpinSpeed:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and Antiaim[i].Yawmode:get() == 5)
    Antiaim[i].TWYaw1:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and Antiaim[i].Yawmode:get() == 6)
    Antiaim[i].TWYaw2:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and Antiaim[i].Yawmode:get() == 6)
    Antiaim[i].TWYaw3:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and Antiaim[i].Yawmode:get() == 6)
    Antiaim[i].Jittermode:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get())
    Antiaim[i].Jittertype:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get())
    Antiaim[i].Jitteramount:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and JT)
    Antiaim[i].JitterL:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and Antiaim[i].Jittertype:get() == 3)
    Antiaim[i].JitterR:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and Antiaim[i].Jittertype:get() == 3)
    Antiaim[i].JitterLR:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and Antiaim[i].Jittertype:get() == 4)
    Antiaim[i].JitterRR:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and Antiaim[i].Jittertype:get() == 4)
    Antiaim[i].JRandomization:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get() and Antiaim[i].Jittertype:get() == 4)
    Antiaim[i].DesyncSide:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get())
    Antiaim[i].Desyncleft:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get())
    Antiaim[i].Desyncright:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get())
    Antiaim[i].label0:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get())
    Antiaim[i].label1:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get())
    Antiaim[i].label3:set_visible(tab == 2 and selection == i and Antiaim[i].EnableAA:get())
    Antibrute[i].EnableAB:set_visible(tab == 2 and selection == i)
    Antibrute[i].ABTime:set_visible(tab == 2 and selection == i and Antibrute[i].EnableAB:get())
    Antibrute[i].ABType:set_visible(tab == 2 and selection == i and Antibrute[i].EnableAB:get())
    Antibrute[i].label0:set_visible(tab == 2 and selection == i and Antibrute[i].EnableAB:get())
end

menu.set_group_visibility("Solace | Information", tab == 1)
menu.set_group_visibility("Solace | Links", tab == 1)
menu.set_group_visibility("Solace | Anti-aim", tab == 2)
menu.set_group_visibility("Solace | Anti-brute", tab == 2)
menu.set_group_visibility("Solace | Configs", tab == 2)
menu.set_group_visibility("Solace | Misc", tab == 3)
menu.set_group_visibility("Solace | Visuals", tab == 3)
menu.set_group_column("Solace | Tabs", 1)
menu.set_group_column("Solace | Information", 2)
menu.set_group_column("Solace | Links", 3)
menu.set_group_column("Solace | Anti-aim", 2)
menu.set_group_column("Solace | Configs", 3)
menu.set_group_column("Solace | Anti-brute", 3)
menu.set_group_column("Solace | Misc", 2)
menu.set_group_column("Solace | Visuals", 3)

end)

local a ='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

function base64enc(data)
    return ((data:gsub('.', function(x) 
        local r,a='',x:byte()
        for i=8,1,-1 do r=r..(a%2^i-a%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return a:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

function base64dec(data)
    data = string.gsub(data, '[^'..a..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(a:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
    end))
end

do
local Key53 = 1237189273981787
local Key14 = 8375

local inv256

function encode(str)
  if not inv256 then
    inv256 = {}
    for M = 0, 127 do
      local inv = -1
      repeat inv = inv + 2
      until inv * (2*M + 1) % 256 == 1
      inv256[M] = inv
    end
  end
  local K, F = Key53, 74321 + Key14
  return (str:gsub('.',
    function(m)
      local L = K % 274877906944  -- 2^38
      local H = (K - L) / 274877906944
      local M = H % 128
      m = m:byte()
      local c = (m * inv256[M] - (H - M) / 128) % 256
      K = L * F + H + c + m
      return ('%02x'):format(c)
    end
  ))
end

function decode(str)
  local K, F = Key53, 74321 + Key14
  return (str:gsub('%x%x',
    function(c)
      local L = K % 274877906944  -- 2^38
      local H = (K - L) / 274877906944
      local M = H % 128
      c = tonumber(c, 16)
      local m = (c + (H - M) / 128) * (2 * M + 1) % 256
      K = L * F + H + c + m
      return string.char(m)
    end
  ))
end
end

authtoken = function()

    engine.execute_cmd("clear")
        
    http:request('get', "http://192.95.19.216:8156", {headers = {api_key = encode(base64enc("123")), username = encode(base64enc(user.name))}}, function(data)
        if data:success() then
            print("[Solace] Your token: "..base64dec(decode(data.body)))
            print("[Solace] You can verify with the token you just generated in our discord server, using a slash command! (/verify)")
        else
            print("[Solace] error, open a ticket in our discord.")
        end
    end) 
end

str_to_sub = function(text, sep)

    local t = {}
    for str in string.gmatch(text, "([^"..sep.."]+)") do
        t[#t + 1] = string.gsub(str, "\n", " ")
    end
    return t
end



to_boolean = function(str)

    if str == "true" or str == "false" then
        return (str == "true")
    else
        return str
    end

end

exportaa = function()

    local str = ""

    for state = 1, 7 do
        str = str..tostring(Antiaim[state].EnableAA:get()).."|"
        ..tostring(Antiaim[state].Yawmode:get()).."|"
        ..tostring(Antiaim[state].Yawadd:get()).."|"
        ..tostring(Antiaim[state].Yawleft:get()).."|"
        ..tostring(Antiaim[state].Yawright:get()).."|"
        ..tostring(Antiaim[state].YawleftR:get()).."|"
        ..tostring(Antiaim[state].YawrightR:get()).."|"
        ..tostring(Antiaim[state].YRandomization:get()).."|"
        ..tostring(Antiaim[state].YawAddSway:get()).."|"
        ..tostring(Antiaim[state].SwaySpeed:get()).."|"
        ..tostring(Antiaim[state].SpinAmount:get()).."|"
        ..tostring(Antiaim[state].SpinSpeed:get()).."|"
        ..tostring(Antiaim[state].TWYaw1:get()).."|"
        ..tostring(Antiaim[state].TWYaw2:get()).."|"
        ..tostring(Antiaim[state].TWYaw3:get()).."|"
        ..tostring(Antiaim[state].Jittermode:get()).."|"
        ..tostring(Antiaim[state].Jittertype:get()).."|"
        ..tostring(Antiaim[state].Jitteramount:get()).."|"
        ..tostring(Antiaim[state].JitterL:get()).."|"
        ..tostring(Antiaim[state].JitterR:get()).."|"
        ..tostring(Antiaim[state].JitterLR:get()).."|"
        ..tostring(Antiaim[state].JitterRR:get()).."|"
        ..tostring(Antiaim[state].JRandomization:get()).."|"
        ..tostring(Antiaim[state].DesyncSide:get()).."|"
        ..tostring(Antiaim[state].Desyncleft:get()).."|"
        ..tostring(Antiaim[state].Desyncright:get()).."|"
        ..tostring(Antibrute[state].EnableAB:get()).."|"
        ..tostring(Antibrute[state].ABTime:get()).."|"
        ..tostring(Antibrute[state].ABType:get()).."|"
    end

    

    Clipboard_Set(enc(str))
    print("Config copied successfully")
end

importaa = function(input)

    local protected = function()

        local clipboardP = input == nil and Clipboard_Get() or input

        local tbl = str_to_sub(dec(clipboardP), "|")

        for state = 1, 7 do
            Antiaim[state].EnableAA:set(to_boolean(tbl[1 + (29 * (state-1))]))
            Antiaim[state].Yawmode:set(tonumber(tbl[2 + (29 * (state-1))]))
            Antiaim[state].Yawadd:set(tonumber(tbl[3 + (29 * (state-1))]))
            Antiaim[state].Yawleft:set(tonumber(tbl[4 + (29 * (state-1))]))
            Antiaim[state].Yawright:set(tonumber(tbl[5 + (29 * (state-1))]))
            Antiaim[state].YawleftR:set(tonumber(tbl[6 + (29 * (state-1))]))
            Antiaim[state].YawrightR:set(tonumber(tbl[7 + (29 * (state-1))]))
            Antiaim[state].YRandomization:set(tonumber(tbl[8 + (29 * (state-1))]))
            Antiaim[state].YawAddSway:set(tonumber(tbl[9 + (29 * (state-1))]))
            Antiaim[state].SwaySpeed:set(tonumber(tbl[10 + (29 * (state-1))]))
            Antiaim[state].SpinAmount:set(tonumber(tbl[11 + (29 * (state-1))]))
            Antiaim[state].SpinSpeed:set(tonumber(tbl[12 + (29 * (state-1))]))
            Antiaim[state].TWYaw1:set(tonumber(tbl[13 + (29 * (state-1))]))
            Antiaim[state].TWYaw2:set(tonumber(tbl[14 + (29 * (state-1))]))
            Antiaim[state].TWYaw3:set(tonumber(tbl[15 + (29 * (state-1))]))
            Antiaim[state].Jittermode:set(tonumber(tbl[16 + (29 * (state-1))]))
            Antiaim[state].Jittertype:set(tonumber(tbl[17 + (29 * (state-1))]))
            Antiaim[state].Jitteramount:set(tonumber(tbl[18 + (29 * (state-1))]))
            Antiaim[state].JitterL:set(tonumber(tbl[19 + (29 * (state-1))]))
            Antiaim[state].JitterR:set(tonumber(tbl[20 + (29 * (state-1))]))
            Antiaim[state].JitterLR:set(tonumber(tbl[21 + (29 * (state-1))]))
            Antiaim[state].JitterRR:set(tonumber(tbl[22 + (29 * (state-1))]))
            Antiaim[state].JRandomization:set(tonumber(tbl[23 + (29 * (state-1))]))
            Antiaim[state].DesyncSide:set(tonumber(tbl[24 + (29 * (state-1))]))
            Antiaim[state].Desyncleft:set(tonumber(tbl[25 + (29 * (state-1))]))
            Antiaim[state].Desyncright:set(tonumber(tbl[26 + (29 * (state-1))]))
            Antibrute[state].EnableAB:set(to_boolean(tbl[27 + (29 * (state-1))]))
            Antibrute[state].ABTime:set(tonumber(tbl[28 + (29 * (state-1))]))
            Antibrute[state].ABType:set(tonumber(tbl[29 + (29 * (state-1))]))
        end
        print("Config imported successfully")
    end

    local status, message = pcall(protected)
    if not status then
        print("Failed to load config")
        return
    end
end

importdefaultaa = function(input)

    local protected = function()

        local input = "gBhXcSTjzAYizWK4IWKsoNfsoNfs1eRi1Wk31LTTbZKToNfsoNfsoNRD1ZP6IZcGIA6TIWfsoNfsoNfD1eJYoWOizWK4IWKsoNfsoNfs1eRi1Wk31LTTbZpTIWKTIWKTINPsIWp3zWmGISTTbZpTIWKTIWKTINPsIWp3zWuGIBTTzWmGILT3zWIezWK4INKTIWKTIWKj1WfTINhGIA6jIWKTIWKTIWpYoNKjILTTbZpTIWKTIWKTINPsIWp3zWK4INKTIWKTIWKj1WfTINhGIA6jIWKTIWKTIWpYoNKjILTYzWpTIBTjIWmGgBhXcSTjzWhGgBhXcSTYzWmGIA6TIWfsoNfsoNfD1eJYoWOizWK4IWKsoNfsoNfs1eRi1Wk31LTTbZKToNfsoNfsoNRD1ZP6IZcGIA6TIWfsoNfsoNfD1eJYoWOizWK4INKTIWKTIWKj1WfTINhGINgGILTTbZpTIWKTIWKTINPsIWp3zWuGbNIYzW9GIeuGILTjzWpezWK4INKTIWKTIWKj1WfTINhGIA6jIWKTIWKTIWpYoNKjILTTbZpTIWKTIWKTINPsIWp3zWK4INKTIWKTIWKj1WfTINhGIA6jIWKTIWKTIWpYoNKjILTezWpTIBTjIWmGgBhXcSTjzWhGgBhXcSTjzWmGIA6TIWfsoNfsoNfD1eJYoWOizWK4IWKsoNfsoNfs1eRi1Wk31LTTbZKToNfsoNfsoNRD1ZP6IZcGIA6TIWfsoNfsoNfD1eJYoWOizWIizWmGISTTbZpTIWKTIWKTINPsIWp3zWuGbNIYzWhGIecGILTYzWmGIZgGIZgGIZgGIZgGIecG1BTjIWmGINKTzB23gnvGILTjzB23gnvG1BTTzWK4IWKsoNfsoNfs1eRi1Wk31LTTbZKToNfsoNfsoNRD1ZP6IZcGIA6TIWfsoNfsoNfD1eJYoWOizWK4IWKsoNfsoNfs1eRi1Wk31LT6zWpjzW9GoBTjzWmGIBTTzWhG1BTTzWOszWIYzWIDzWPjzW9G1BTDoSTjIWmGgBhXcSTjzWhGgBhXcSTizWmGIA6TIWfsoNfsoNfD1eJYoWOizWK4IWKsoNfsoNfs1eRi1Wk31LTTbZKToNfsoNfsoNRD1ZP6IZcGIA6TIWfsoNfsoNfD1eJYoWOizWIezWpYzW9GIA6jIWKTIWKTIWpYoNKjILTjzAY31STTzWOszWhG1BTTzWpDzWpszWgG1DTeIDTYzWRYzWpTIBjYRLvQzWuGILjYRLvQzWcGIBTTbZKToNfsoNfsoNRD1ZP6IZcGIA6TIWfsoNfsoNfD1eJYoWOizWK4IWKsoNfsoNfs1eRi1Wk31LTTbZKToNfsoNfsoNRD1ZP6IZcGIZ1GIBTjzW9GIST8IZvGIBT31DT3zW2GIBT3oBT3oBT3IBT3IDT3IDTYzWpTIBTjIWmGgBhXcST3zWuGgBhXcSTjzWpXzWK4IWKsoNfsoNfs1eRi1Wk31LTTbZKToNfsoNfsoNRD1ZP6IZcGIA6TIWfsoNfsoNfD1eJYoWOizWK4IWKsoNfsoNfs1eRi1Wk31LTTbZpTIWKTIWKTINPsIWp3zWmGISTTbZpTIWKTIWKTINPsIWp3zWuGIBTTzWmGILTjzWpTzWK4INKTIWKTIWKj1WfTINhGIA6jIWKTIWKTIWpYoNKjILTTbZpTIWKTIWKTINPsIWp3zWK4INKTIWKTIWKj1WfTINhGIA6jIWKTIWKTIWpYoNKjILTezWpTIBTjIWmGgBhXcSTjzWuG"

        local clipboardP = input

        local tbl = str_to_sub(dec(clipboardP), "|")

        for state = 1, 7 do
            Antiaim[state].EnableAA:set(to_boolean(tbl[1 + (29 * (state-1))]))
            Antiaim[state].Yawmode:set(tonumber(tbl[2 + (29 * (state-1))]))
            Antiaim[state].Yawadd:set(tonumber(tbl[3 + (29 * (state-1))]))
            Antiaim[state].Yawleft:set(tonumber(tbl[4 + (29 * (state-1))]))
            Antiaim[state].Yawright:set(tonumber(tbl[5 + (29 * (state-1))]))
            Antiaim[state].YawleftR:set(tonumber(tbl[6 + (29 * (state-1))]))
            Antiaim[state].YawrightR:set(tonumber(tbl[7 + (29 * (state-1))]))
            Antiaim[state].YRandomization:set(tonumber(tbl[8 + (29 * (state-1))]))
            Antiaim[state].YawAddSway:set(tonumber(tbl[9 + (29 * (state-1))]))
            Antiaim[state].SwaySpeed:set(tonumber(tbl[10 + (29 * (state-1))]))
            Antiaim[state].SpinAmount:set(tonumber(tbl[11 + (29 * (state-1))]))
            Antiaim[state].SpinSpeed:set(tonumber(tbl[12 + (29 * (state-1))]))
            Antiaim[state].TWYaw1:set(tonumber(tbl[13 + (29 * (state-1))]))
            Antiaim[state].TWYaw2:set(tonumber(tbl[14 + (29 * (state-1))]))
            Antiaim[state].TWYaw3:set(tonumber(tbl[15 + (29 * (state-1))]))
            Antiaim[state].Jittermode:set(tonumber(tbl[16 + (29 * (state-1))]))
            Antiaim[state].Jittertype:set(tonumber(tbl[17 + (29 * (state-1))]))
            Antiaim[state].Jitteramount:set(tonumber(tbl[18 + (29 * (state-1))]))
            Antiaim[state].JitterL:set(tonumber(tbl[19 + (29 * (state-1))]))
            Antiaim[state].JitterR:set(tonumber(tbl[20 + (29 * (state-1))]))
            Antiaim[state].JitterLR:set(tonumber(tbl[21 + (29 * (state-1))]))
            Antiaim[state].JitterRR:set(tonumber(tbl[22 + (29 * (state-1))]))
            Antiaim[state].JRandomization:set(tonumber(tbl[23 + (29 * (state-1))]))
            Antiaim[state].DesyncSide:set(tonumber(tbl[24 + (29 * (state-1))]))
            Antiaim[state].Desyncleft:set(tonumber(tbl[25 + (29 * (state-1))]))
            Antiaim[state].Desyncright:set(tonumber(tbl[26 + (29 * (state-1))]))
            Antibrute[state].EnableAB:set(to_boolean(tbl[27 + (29 * (state-1))]))
            Antibrute[state].ABTime:set(tonumber(tbl[28 + (29 * (state-1))]))
            Antibrute[state].ABType:set(tonumber(tbl[29 + (29 * (state-1))]))
        end
        print("Default config loaded successfully.")
    end

    local status, message = pcall(protected)
    if not status then
        print("Failed to load config")
        return
    end
end