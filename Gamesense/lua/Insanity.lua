-- v1.0
--[[


    INSANITY.LUA OUT NOW, ENJOY :D
    Разработчик: mq.class
    Дата: April 2, 2025
    моя локалка - https://discord.gg/UysyqdWhV5
    


Сhangelog -> Inasnity.lua

[+] Добавлено:

+ Interface (за время отсутствия, разобрался в настройке и отображении UI, Сам проект стал серьезнее и теперь он не просто опирается на пресеты, а на нормальный билдер!)
+ In-game Changelog (mini)
+ CFG System (сколько же я с ней ебался по началу, благо сейчас понял, что к чему)
+ AA Builder (желаю удачи в ознакомлении и настройке)
+ AA Presets (default, better defensive, jitter, unpredictale, random)
+ Resolver Builder (думал сделать его *beta*, но свою функцию он выполняет на ура, так что удачи в настройке)
+ Resolver Presets (default, bruteforce, logic, smart, extra)
+ Visuals/watermark(с визуалами у меня туго, только учусь, в дальнейшем будет больше визуалов)
+ Fs/manuals (на этот раз, я позаботился, что бы они работали)


[-] Убрано:
- Nakiev.lua


[?] Переделано:
? что я должен был перелать в v1 версии?



Supports:

♥ @lolkekmlg - 5☆

---------------------------------------------- 
THANK U SO MUCH FOR SUPPORTING Insanity.lua <3
---------------------------------------------- 


P.S. не юзайти пресет рандом, я там проебался немного :D
]]





local user = "Insanity User <3"

local menu = {
    ["home"] = {},
    ["anti-aim"] = {},
    ["resolver"] = {},
    ["visuals"] = {},
    ["misc"] = {}    
}

local ffi = require("ffi")
local CS_UM_SendPlayerItemFound = 63
local DispatchUserMessage_t = ffi.typeof([[
    bool(__thiscall*)(void*, int msg_type, int nFlags, int size, const void* msg)
]])
local VClient018 = client.create_interface("client.dll", "VClient018")
local pointer = ffi.cast("uintptr_t**", VClient018)
local vtable = ffi.cast("uintptr_t*", pointer[0])
local size = 0
local last_message_time = 0
local is_sending = false

while vtable[size] ~= 0x0 do
    size = size + 1
end

local hooked_vtable = ffi.new("uintptr_t[?]", size)
for i = 0, size - 1 do
    hooked_vtable[i] = vtable[i]
end

pointer[0] = hooked_vtable
local oDispatch = ffi.cast(DispatchUserMessage_t, vtable[38])

local function hkDispatch(thisptr, msg_type, nFlags, size, msg)
    if msg_type == CS_UM_SendPlayerItemFound then return false end
    return oDispatch(thisptr, msg_type, nFlags, size, msg)
end

hooked_vtable[38] = ffi.cast("uintptr_t", ffi.cast(DispatchUserMessage_t, hkDispatch))


local clipboard = {
    export = function(text)
        local ffi = require("ffi")
        ffi.cdef([[ typedef void(__thiscall* set_clipboard_text)(void*, const char*, int); ]])
        local pointer = ffi.cast("void***", client.create_interface("vgui2.dll", "VGUI_System010"))
        local func = ffi.cast("set_clipboard_text", pointer[0][9])
        func(pointer, text, #text)
    end,
    import = function()
        local ffi = require("ffi")
        ffi.cdef([[
            typedef int(__thiscall* get_clipboard_text_count)(void*);
            typedef void(__thiscall* get_clipboard_text)(void*, int, char*, int);
        ]])
        local pointer = ffi.cast("void***", client.create_interface("vgui2.dll", "VGUI_System010"))
        local count_func = ffi.cast("get_clipboard_text_count", pointer[0][7])
        local sizelen = count_func(pointer)
        if sizelen > 0 then
            local buffer = ffi.new("char[?]", sizelen)
            local text_func = ffi.cast("get_clipboard_text", pointer[0][11])
            text_func(pointer, 0, buffer, sizelen)
            return ffi.string(buffer, sizelen-1)
        end
        return ""
    end
}


local function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

local function normalize_angle(angle)
    while angle > 180 do angle = angle - 360 end
    while angle < -180 do angle = angle + 360 end
    return angle
end


local function can_penetrate_wall(local_player, enemy, yaw)
    if not local_player or not entity.is_alive(local_player) or not enemy or not entity.is_alive(enemy) then return false end

    local eye_pos = { client.eye_position() }
    if not eye_pos[1] then return false end

  
    local head_pos = { entity.hitbox_position(enemy, 0) } 
    if not head_pos[1] then return false end

    
    local fraction, hit_entity = client.trace_bullet(local_player, eye_pos[1], eye_pos[2], eye_pos[3], head_pos[1], head_pos[2], head_pos[3])
    if fraction == nil then fraction = 0 end

    
    return fraction > 0.9 or (hit_entity and hit_entity == enemy)
end


local b64 = {
    encode = function(data)
        local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
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
    end,
    decode = function(data)
        local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
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
}


local trashtalk_phrases = {
    OnKill = {
        single = { 
            "Ебать ты биомусор. Я на тя даже пресеты не грузил, хватило дефолта)",
            "Опять чудище ебаное со своим отцом мне хуй сосут бля)",
            "Соси хуй падаль. Ты даже не понял, как я тебя выебал.",
            "Я твоей мамке на ротан дал, пока ты пытался понять, откуда тебя убили, пробирочный нахуй)",
            "Best free open ss lua - Insanity(а ну и я тя выебал все)"
        },
        double = { 
            {"Ты так старался, аж жалко стало... на секунду", "Потом я вспомнил, что ты дно ебаное"},
            {"опять умер", "блять какой же ты бездарь ебаный)"},
            {"бля мы не в доте", "но я бы кинул те реп за фид)"},
            {"Бро,тебе надо тренироваться","может через год сможешь хотя бы респавн свой защитить, бич нищий"},
            {"скачать фри луа = ✗","Сидеть с пасто = ✔"}

        },
        triple = { 
            {"1", "упал", "<3"},
            {"оправдывай свою сметана луа", "собачка", "без Insanity"},
            {"эахъахъпхъхпъ", "сколько можно", "ливни с кона если не умеешь играть"},
            {"про почти попал", "в мой", "PPHUD PREMUIM"},
            {"Сьебался", "таракан", "усатый"},
            {"На мыло", "и веревку", "бабки дать?"},
            {"ау лоу кд чурка", "а ты знал?", "Insanity бесплатный"}
        }
    },
    OnDeath = {
        single = { 
            "ну как так, лох",
            "ебать я сгорел",
            "да ты читак"
        },
        double = { 
            {"скажи", "ряльна"},
            {"анлак", "хай пинг че"},
            {"блять", "анлак"}
        },
        triple = { 
            {"1х1 2х2 3х3 5х5", "2000$", "прям ща"},
            {"опять", "читеры на паблике", "F1"},
            {"я не мисаю", "я дал тебе шанс выйти в кд", "скажи спасибо"}
        }
    }
}


local trashtalk_queue = {}
local last_message_time = 0 
local is_sending = false 


local function send_trashtalk(phrases)
    local variant = math.random(1, 3) 
    local messages = {}

    
    if variant == 1 then
        local single = phrases.single[math.random(#phrases.single)]
        messages = {single} 
    elseif variant == 2 then
        messages = phrases.double[math.random(#phrases.double)] 
    else
        messages = phrases.triple[math.random(#phrases.triple)] 
    end

    
    for _, message in ipairs(messages) do
        table.insert(trashtalk_queue, message)
    end

    
    local function send_next_message()
        if #trashtalk_queue == 0 then
            is_sending = false 
            return
        end

        local current_time = globals.realtime()
        if current_time < last_message_time + 1.0 then
            
            client.delay_call(last_message_time + 1.0 - current_time, send_next_message)
            return
        end

        
        local message = table.remove(trashtalk_queue, 1)
        client.exec("say " .. message)
        last_message_time = globals.realtime()
        is_sending = true

        
        client.delay_call(1.0, send_next_message)
    end

    
    if not is_sending then
        send_next_message()
    end
end


local player_cache = {}

local function update_player_cache(player)
    if not entity.is_alive(player) then return end
    local velocity_x, velocity_y = entity.get_prop(player, "m_vecVelocity") or 0, entity.get_prop(player, "m_vecVelocity") or 0
    local velocity = math.sqrt((velocity_x or 0)^2 + (velocity_y or 0)^2)
    local animstate = entity.get_prop(player, "m_flPoseParameter", 11) or 0
    local simtime = entity.get_prop(player, "m_flSimulationTime") or 0
    local old_simtime = entity.get_prop(player, "m_flOldSimulationTime") or simtime
    local choked_ticks = math.max(0, math.floor((simtime - old_simtime) / globals.tickinterval() + 0.5))
    local eye_angles = {entity.get_prop(player, "m_angEyeAngles") or 0, entity.get_prop(player, "m_angEyeAngles", 1) or 0}
    local lby = entity.get_prop(player, "m_flLowerBodyYawTarget") or 0
    local on_ground = bit.band(entity.get_prop(player, "m_fFlags") or 0, 1) == 1

    
    player_cache[player] = player_cache[player] or {}
    local cache = player_cache[player]

    
    cache.velocity = velocity
    cache.animstate = animstate
    cache.simtime = simtime
    cache.choked_ticks = choked_ticks
    cache.eye_yaw = eye_angles[2] or 0
    cache.lby = lby
    cache.on_ground = on_ground
    cache.last_yaw = cache.last_yaw or 0
    cache.misses = cache.misses or 0
    cache.aa_history = cache.aa_history or {}

    
    table.insert(cache.aa_history, {yaw = cache.eye_yaw, time = simtime, lby = lby})
    if #cache.aa_history > 20 then
        table.remove(cache.aa_history, 1)
    end
end


local tbl = {
    items = {
        enabled = { ui.reference("aa", "anti-aimbot angles", "enabled") },
        dt = { ui.reference("rage", "aimbot", "double tap") },
        pitch = { ui.reference("aa", "anti-aimbot angles", "pitch") },
        base = { ui.reference("aa", "anti-aimbot angles", "yaw base") },
        jitter = { ui.reference("aa", "anti-aimbot angles", "yaw jitter") },
        yaw = { ui.reference("aa", "anti-aimbot angles", "yaw") },
        body = { ui.reference("aa", "anti-aimbot angles", "body yaw") },
        fsbody = { ui.reference("aa", "anti-aimbot angles", "freestanding body yaw") },
        edge = { ui.reference("aa", "anti-aimbot angles", "edge yaw") },
        roll = { ui.reference("aa", "anti-aimbot angles", "roll") },
        fs = { ui.reference("aa", "anti-aimbot angles", "freestanding") },
        hideshot = { ui.reference("aa", "other", "on shot anti-aim") },
        legs = { ui.reference("aa", "other", "leg movement") },      
        limitfl = { ui.reference("aa", "fake lag", "limit") },
        fl_enabled = { ui.reference("aa", "fake lag", "enabled") },
        fl_amount = { ui.reference("aa", "fake lag", "amount") },
        fl_variance = { ui.reference("aa", "fake lag", "variance") },
        slow_motion = { ui.reference("aa", "other", "slow motion") },
        fake_peek = { ui.reference("aa", "other", "fake peek") }
    }
}


local function is_in_air()
    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then return false end
    local flags = entity.get_prop(lp, "m_fFlags") or 0
    return bit.band(flags, 1) == 0
end


local function can_see_enemy()
    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then return false end

    local eye_pos = { entity.get_prop(lp, "m_vecOrigin") }
    eye_pos[3] = eye_pos[3] + (entity.get_prop(lp, "m_vecViewOffset[2]") or 64)
    local enemies = entity.get_players(true)

    for i, enemy in ipairs(enemies) do
        local enemy_pos = { entity.get_prop(enemy, "m_vecOrigin") }
        enemy_pos[3] = enemy_pos[3] + 64 
        local fraction = client.trace_line(lp, eye_pos[1], eye_pos[2], eye_pos[3], enemy_pos[1], enemy_pos[2], enemy_pos[3])
        if fraction > 0.98 then 
            return true
        end
    end
    return false
end

local function execute_autobuy() -- Довели, больше не буду пастить опен сурсный АБ с гитхаба🗿
    if not ui.get(menu["misc"].other.Autobuy) then return end 

    local weapon = ui.get(menu["misc"].other.AutobuyWeapon)
    local command = ""

    if weapon == "SSG 08" then
        command = "buy ssg08;"
    elseif weapon == "AWP" then
        command = "buy awp;"
    elseif weapon == "Auto-Sniper" then
        command = "buy scar20; buy g3sg1;" 
    end

    client.delay_call(0.1, function()
        client.exec(command)
    end)
end

client.set_event_callback("round_prestart", execute_autobuy)

local aa_configs = {
    ["default"] = {
        pitch = "Down",
        yaw_base = "Local view",
        yaw = 180,
        jitter = function() return is_in_air() and "Center" or "Off" end,
        jitter_offset = function() return is_in_air() and 30 or 0 end,
        body_yaw = "Static"
    },
    ["better defensive"] = {
        pitch = "Minimal",
        yaw_base = "At targets",
        yaw = function() return normalize_angle(180 + math.sin(globals.realtime() * 8) * 45) end,
        jitter = "Random",
        jitter_offset = 60,
        body_yaw = "Jitter"
    },
    ["jitter"] = {
        pitch = "Down",
        yaw_base = "Local view",
        yaw = 180,
        jitter = "Random",
        jitter_offset = 90,
        body_yaw = "Opposite"
    },
    ["unpredictable"] = {
        pitch = "Down",
        yaw_base = "At targets",
        yaw = function() 
            local timer = globals.realtime() % 1.5
            if timer < 0.5 then last_yaw = last_yaw or math.random(-180, 180) end
            return normalize_angle(last_yaw or 0)
        end,
        jitter = "Random",
        jitter_offset = function() return math.random(30, 90) end,
        body_yaw = "Opposite"
    },
    ["random"] = {
        pitch = function() return can_see_enemy() and "Down" or "Minimal" end,
        yaw_base = "Local view",
        yaw = function() 
            if can_see_enemy() then
                return 180
            else
                return normalize_angle(math.sin(globals.realtime() * 15) * 180 + math.cos(globals.realtime() * 10) * 90)
            end
        end,
        jitter = function() 
            if can_see_enemy() then
                return "Off"
            else
                return "Random"
            end
        end,
        jitter_offset = function() 
            if can_see_enemy() then
                return 0
            else
                return math.random(45, 90)
            end
        end,
        body_yaw = function() 
            if can_see_enemy() then
                return "Static"
            else
                return "Jitter"
            end
        end
    },
    ["aa builder"] = {
        pitch = function() return ui.get(menu["anti-aim"].builder.pitch.mode) end,
        yaw_base = function() return ui.get(menu["anti-aim"].builder.yaw.base) end,
        yaw = function() return ui.get(menu["anti-aim"].builder.yaw.static_value) end,
        jitter = function() return ui.get(menu["anti-aim"].builder.jitter.type) end,
        jitter_offset = function() return ui.get(menu["anti-aim"].builder.jitter.amplitude) end,
        body_yaw = function() return ui.get(menu["anti-aim"].builder.body_yaw.mode) end,
        roll = function() return ui.get(menu["anti-aim"].builder.roll.enabled) and ui.get(menu["anti-aim"].builder.roll.amount) or 0 end
    }
}

local clantag_steps_nakiev = {"$","n","n$","na","na$","nak","nak$","naki","naki$","nakie","nakie$","nakiev","nakiev.$","nakiev.l","nakiev.l$","nakiev.lu","nakiev.lu$","nakiev.lua","nakiev.lua","nakiev.lu$","nakiev.lu","nakiev.l$","nakiev.l","nakiev.$","nakiev","nakie$","nakie","naki$","naki","nak$","nak","na$","na","n$","n","$"}

local clantag_steps_insanity = {"1","I","I#","In","In01010101","Ins","Ins@","Insan","Insan1","Insani","Insani!","Insanity","Insanity.","Insanity.l","Insanity.l<3","Insanity.lua","Insanity.lua","Insanity.lua","Insanity.l<3","Insanity.l","Insanity.","Insanity","Insani!","Insani","Insan1","Insan","Ins@","In","I#","I","1","1"}

local last_clantag_index = 0
local last_clantag_time = 0

local function update_clantag()
    if not ui.get(menu["misc"].other.ClanTags) then 
        client.set_clan_tag("")
        return 
    end

    local current_time = globals.realtime()
    if current_time < last_clantag_time + 0.3 then return end

    local selected_animation = ui.get(menu["misc"].other.ClanTagAnimation)
    local steps = selected_animation == "Insanity" and clantag_steps_insanity or clantag_steps_nakiev
    last_clantag_index = (last_clantag_index % #steps) + 1
    client.set_clan_tag(steps[last_clantag_index])
    last_clantag_time = current_time
end

local last_yaw = nil

local function get_player_state()
    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then return nil end

    local flags = entity.get_prop(lp, "m_fFlags") or 0
    local velocity_x, velocity_y = entity.get_prop(lp, "m_vecVelocity")
    local velocity = math.sqrt(velocity_x^2 + velocity_y^2)
    local ducked = entity.get_prop(lp, "m_bDucked") == 1
    local on_ground = bit.band(flags, 1) == 1

    if on_ground then
        if ducked then
            if velocity > 5 then
                return "Crouch Moving"
            else
                return "Crouch"
            end
        elseif velocity < 5 then
            return "Standing"
        else
            return "Walking"
        end
    else
        if ducked then
            return "Air Crouch"
        else
            return "Air"
        end
    end
end


local choked_commands = 0


client.set_event_callback("setup_command", function(cmd)
    if cmd.chokedcommands ~= nil then
        choked_commands = cmd.chokedcommands
    end
end)

local function apply_anti_aim(cmd)
    if not menu["anti-aim"].mode then return end
    local preset = ui.get(menu["anti-aim"].mode)
    if preset ~= "aa builder" then
        local config = aa_configs[preset]
        if not config then return end
        ui.set(tbl.items.enabled[1], true)
        ui.set(tbl.items.pitch[1], type(config.pitch) == "function" and config.pitch() or config.pitch)
        ui.set(tbl.items.base[1], config.yaw_base)
        ui.set(tbl.items.yaw[1], "180")
        ui.set(tbl.items.yaw[2], type(config.yaw) == "function" and config.yaw() or config.yaw)
        ui.set(tbl.items.jitter[1], type(config.jitter) == "function" and config.jitter() or config.jitter)
        ui.set(tbl.items.jitter[2], type(config.jitter_offset) == "function" and config.jitter_offset() or config.jitter_offset)
        ui.set(tbl.items.body[1], type(config.body_yaw) == "function" and config.body_yaw() or config.body_yaw)
        ui.set(tbl.items.roll[1], type(config.roll) == "function" and config.roll() or 0)
        ui.set(tbl.items.fsbody[1], false)
        return
    end

    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then return end

    local state = get_player_state()
    if not state then return end
    local state_config = menu["anti-aim"].builder.states[state]

    ui.set(tbl.items.enabled[1], true)

    local tick = globals.tickcount()
    local velocity_x, velocity_y = entity.get_prop(lp, "m_vecVelocity")
    local velocity = math.sqrt(velocity_x^2 + velocity_y^2)
    local in_air = bit.band(entity.get_prop(lp, "m_fFlags") or 0, 1) ~= 1
    
    local dt_enabled = tbl.items.dt[1] and ui.get(tbl.items.dt[1])
    local dt_timer = tbl.items.dt[2] and ui.get(tbl.items.dt[2]) or 0
    local dt_active = dt_enabled and type(dt_timer) == "number" and dt_timer > globals.tickcount()
    
    local can_see = can_see_enemy()
    local choked = choked_commands  

    
    if ui.get(state_config.pitch.enabled) then
        local pitch_mode = ui.get(state_config.pitch.mode)
        local pitch_value = 0
        local use_custom = false
        if pitch_mode == "Custom" then
            pitch_value = ui.get(state_config.pitch.custom_value)
            use_custom = true
        elseif pitch_mode == "Dynamic" then
            pitch_value = in_air and -30 or (velocity > 50 and -89 or 0)
        elseif pitch_mode == "Down" then
            pitch_value = -89
        elseif pitch_mode == "Up" then
            pitch_value = 89
        elseif pitch_mode == "Minimal" then
            pitch_value = -30
        elseif pitch_mode == "Default" then
            pitch_value = 0
        end
        if ui.get(state_config.pitch.randomize) then
            pitch_value = pitch_value + (math.random() - 0.5) * ui.get(state_config.pitch.random_range) * 2
            use_custom = true
        end
        if ui.get(state_config.pitch.velocity_influence) > 0 then
            pitch_value = pitch_value + (velocity / 260) * ui.get(state_config.pitch.velocity_influence)
            use_custom = true
        end
        ui.set(tbl.items.pitch[1], use_custom and "Custom" or pitch_mode)
        if use_custom then
            ui.set(tbl.items.pitch[2], clamp(pitch_value, -89, 89))
        end
    end

    
    if ui.get(state_config.yaw.enabled) then
        local yaw_base = ui.get(state_config.yaw.base)
        if ui.get(state_config.yaw.velocity_aware) and velocity > ui.get(state_config.yaw.velocity_threshold) then
            yaw_base = "At targets"
        end
        ui.set(tbl.items.base[1], yaw_base)

        local yaw_mode = ui.get(state_config.yaw.mode)
        local yaw_value = ui.get(state_config.yaw.static_value)
        if yaw_mode == "Cycle" then
            local cycle_values = {180, 90, 0, -90, -180}
            yaw_value = cycle_values[(tick % #cycle_values) + 1]
        elseif yaw_mode == "Dynamic" then
            yaw_value = normalize_angle(math.sin(globals.realtime() * ui.get(state_config.yaw.frequency) / 100) * ui.get(state_config.yaw.amplitude))
        end
        if ui.get(state_config.yaw.jitter_influence) > 0 then
            yaw_value = yaw_value + math.sin(tick * 0.5) * (ui.get(state_config.yaw.jitter_influence) / 100) * 60
        end
        if ui.get(state_config.yaw.dt_shift) and dt_active then
            yaw_value = yaw_value + ui.get(state_config.yaw.dt_shift_amount)
        end
        ui.set(tbl.items.yaw[1], "180")
        ui.set(tbl.items.yaw[2], clamp(yaw_value, -180, 180))
    end

    
    if ui.get(state_config.jitter.enabled) then
        local jitter_type = ui.get(state_config.jitter.type)
        local jitter_amplitude = ui.get(state_config.jitter.amplitude)
        local jitter_value = 0
        if (not ui.get(state_config.jitter.air_only) or in_air) then
            if jitter_type == "Offset" then
                jitter_value = jitter_amplitude
            elseif jitter_type == "Center" then
                jitter_value = tick % 2 == 0 and jitter_amplitude or -jitter_amplitude
            elseif jitter_type == "Random" then
                jitter_value = (math.random() - 0.5) * jitter_amplitude * 2
            end
            if ui.get(state_config.jitter.chaos_factor) > 0 then
                jitter_value = jitter_value + (math.random() - 0.5) * jitter_amplitude * (ui.get(state_config.jitter.chaos_factor) / 100)
            end
            if ui.get(state_config.jitter.sync_with_tick) then
                jitter_value = jitter_value * math.sin(tick * (ui.get(state_config.jitter.frequency) / 100))
            end
        end
        ui.set(tbl.items.jitter[1], jitter_type)
        ui.set(tbl.items.jitter[2], clamp(jitter_value, -90, 90))
    end

    
    if ui.get(state_config.body_yaw.enabled) then
        local body_yaw_mode = ui.get(state_config.body_yaw.mode)
        local body_yaw_value = ui.get(state_config.body_yaw.static_value)
        if body_yaw_mode == "Jitter" then
            body_yaw_mode = "Jitter"
        elseif body_yaw_mode == "Dynamic" then
            body_yaw_value = ui.get(state_config.body_yaw.enemy_aware) and (can_see and 0 or 45) or (velocity > 50 and 45 or -45)
            body_yaw_mode = "Static"
        elseif body_yaw_mode == "Opposite" then
            body_yaw_mode = "Opposite"
        end
        if ui.get(state_config.body_yaw.velocity_factor) > 0 and body_yaw_mode == "Static" then
            body_yaw_value = body_yaw_value + (velocity / 260) * 60 * (ui.get(state_config.body_yaw.velocity_factor) / 100)
        end
        if ui.get(state_config.body_yaw.invert) and body_yaw_mode == "Static" then
            body_yaw_value = -body_yaw_value
        end
        ui.set(tbl.items.body[1], body_yaw_mode)
        if body_yaw_mode == "Static" then
            ui.set(tbl.items.body[2], clamp(body_yaw_value, -180, 180))
        end
    end

    
    if ui.get(state_config.roll.enabled) then
        local roll_value = ui.get(state_config.roll.amount)
        if ui.get(state_config.roll.dynamic) then
            roll_value = math.sin(globals.realtime() * (ui.get(state_config.roll.dynamic_frequency) / 100)) * roll_value
        end
        ui.set(tbl.items.roll[1], clamp(roll_value, -50, 50))
    end

    
    if ui.get(state_config.conditions.enabled) then
        if ui.get(state_config.conditions.air_adjust) and in_air then
            ui.set(tbl.items.pitch[1], ui.get(state_config.conditions.air_pitch))
            ui.set(tbl.items.yaw[2], clamp(ui.get(tbl.items.yaw[2]) + ui.get(state_config.conditions.air_yaw_offset), -180, 180))
        end
        if ui.get(state_config.conditions.velocity_adjust) and velocity > ui.get(state_config.conditions.velocity_threshold) then
            ui.set(tbl.items.yaw[2], clamp(ui.get(tbl.items.yaw[2]) + ui.get(state_config.conditions.velocity_yaw_shift), -180, 180))
        end
    end

    
    if ui.get(state_config.defensive.enabled) then
        if ui.get(state_config.defensive.edge_aware) then
            ui.set(tbl.items.yaw[2], clamp(ui.get(tbl.items.yaw[2]) + ui.get(state_config.defensive.edge_yaw_shift), -180, 180))
        end
        if ui.get(state_config.defensive.fs_body) then
            ui.set(tbl.items.fsbody[1], true)
        end
        if ui.get(state_config.defensive.random_shift) then
            ui.set(tbl.items.yaw[2], clamp(ui.get(tbl.items.yaw[2]) + (math.random() - 0.5) * ui.get(state_config.defensive.random_shift_max) * 2, -180, 180))
        end
        if ui.get(state_config.defensive.dt_defense) and dt_active then
            ui.set(tbl.items.jitter[2], clamp(ui.get(tbl.items.jitter[2]) + ui.get(state_config.defensive.dt_jitter), -90, 90))
        end
    end

    
    if ui.get(state_config.flick.enabled) then
        local flick_condition = ui.get(state_config.flick.condition)
        local flick_amplitude = ui.get(state_config.flick.amplitude)
        local flick_interval = ui.get(state_config.flick.interval)
        local flick_offset = ui.get(state_config.flick.random_offset)
        if (flick_condition == "Always" or (flick_condition == "On Shot" and cmd.in_attack) or (flick_condition == "On Miss" and not can_see)) and (tick % flick_interval == 0) then
            local flick_value = flick_amplitude + (math.random() - 0.5) * flick_offset * 2
            ui.set(tbl.items.yaw[2], clamp(ui.get(tbl.items.yaw[2]) + flick_value, -180, 180))
        end
    end

    
    if ui.get(state_config.sway.enabled) then
        local sway_amplitude = ui.get(state_config.sway.amplitude)
        local sway_speed = ui.get(state_config.sway.speed) / 100
        local sway_phase = ui.get(state_config.sway.phase_shift) / 100
        local sway_value = math.sin(globals.realtime() * sway_speed + sway_phase) * sway_amplitude
        if ui.get(state_config.sway.invert_on_edge) and ui.get(state_config.defensive.edge_aware) then
            sway_value = -sway_value
        end
        ui.set(tbl.items.yaw[2], clamp(ui.get(tbl.items.yaw[2]) + sway_value, -180, 180))
    end

    
    if ui.get(state_config.adaptive.enabled) then
        local miss_count = globals.miss_count or 0  
        if miss_count >= ui.get(state_config.adaptive.miss_threshold) then
            ui.set(tbl.items.yaw[2], clamp(ui.get(tbl.items.yaw[2]) + ui.get(state_config.adaptive.miss_shift), -180, 180))
        end
        if choked >= ui.get(state_config.adaptive.choke_threshold) then
            ui.set(tbl.items.yaw[2], clamp(ui.get(tbl.items.yaw[2]) + ui.get(state_config.adaptive.choke_shift), -180, 180))
        end
        if ui.get(state_config.adaptive.velocity_factor) > 0 then
            local adaptive_shift = (velocity / 260) * ui.get(state_config.adaptive.velocity_factor)
            ui.set(tbl.items.yaw[2], clamp(ui.get(tbl.items.yaw[2]) + adaptive_shift, -180, 180))
        end
    end

    
    if ui.get(state_config.freestand.enabled) then
        local freestand_offset = ui.get(state_config.freestand.yaw_offset)
        if ui.get(state_config.freestand.invert_on_wall) and ui.get(state_config.defensive.edge_aware) then
            freestand_offset = -freestand_offset
        end
        if ui.get(state_config.freestand.dynamic_adjust) then
            freestand_offset = freestand_offset * (velocity > 50 and 1.5 or 1)
        end
        ui.set(tbl.items.yaw[2], clamp(ui.get(tbl.items.yaw[2]) + freestand_offset, -180, 180))
        ui.set(tbl.items.fsbody[1], true)
    end

    
    if ui.get(state_config.edge.enabled) then
        local edge_yaw = ui.get(state_config.edge.edge_yaw)
        if ui.get(state_config.edge.jitter_on_edge) then
            edge_yaw = edge_yaw + (math.random() - 0.5) * ui.get(state_config.edge.edge_jitter_amplitude) * 2
        end
        ui.set(tbl.items.yaw[2], clamp(edge_yaw, -180, 180))
    end

    
    if ui.get(state_config.fakelagsync.enabled) then
        local lag_mode = ui.get(state_config.fakelagsync.lag_mode)
        local choke_threshold = ui.get(state_config.fakelagsync.choke_threshold)
        local choke_shift = ui.get(state_config.fakelagsync.choke_shift)
        local lag_factor = ui.get(state_config.fakelagsync.lag_factor) / 100
        if choked >= choke_threshold then
            ui.set(tbl.items.yaw[2], clamp(ui.get(tbl.items.yaw[2]) + choke_shift, -180, 180))
            if lag_mode == "Dynamic" then
                choke_shift = choke_shift * (velocity / 260) * lag_factor
            elseif lag_mode == "Random" then
                choke_shift = choke_shift * (math.random() * lag_factor)
            end
            cmd.chokedcommands = math.min(choke_threshold, cmd.chokedcommands + 1)
        end
    end

    
    if ui.get(state_config.velocitywarp.enabled) then
        if velocity > ui.get(state_config.velocitywarp.velocity_threshold) then
            local warp_factor = ui.get(state_config.velocitywarp.warp_factor) / 100
            local warp_shift = (velocity / 260) * warp_factor * 60
            if ui.get(state_config.velocitywarp.invert_on_stop) and velocity < 10 then
                warp_shift = -warp_shift
            end
            if ui.get(state_config.velocitywarp.wall_aware) and ui.get(state_config.defensive.edge_aware) then
                warp_shift = warp_shift * 0.5
            end
            ui.set(tbl.items.yaw[2], clamp(ui.get(tbl.items.yaw[2]) + warp_shift, -180, 180))
        end
    end

    
    if ui.get(state_config.peekreaction.enabled) then
        local peek_shift = ui.get(state_config.peekreaction.peek_shift)
        local reaction_delay = ui.get(state_config.peekreaction.reaction_delay)
        local random_factor = ui.get(state_config.peekreaction.random_factor) / 100
        if can_see and (tick % reaction_delay == 0) then
            peek_shift = peek_shift + (math.random() - 0.5) * peek_shift * random_factor
            ui.set(tbl.items.yaw[2], clamp(ui.get(tbl.items.yaw[2]) + peek_shift, -180, 180))
        end
    end
end

client.set_event_callback("paint", function()
    local current_preset = ui.get(menu["anti-aim"].mode)
    if current_preset ~= last_preset then
        if last_preset == "aa builder" and current_preset ~= "aa builder" then
            ui.set(tbl.items.roll[1], 0)
            ui.set(tbl.items.fsbody[1], false)
            ui.set(tbl.items.edge[1], false)
        end
        last_preset = current_preset
    end
    update_clantag()  
end)

local function has_zeus(player)
    local weapon = entity.get_player_weapon(player)
    if weapon then
        local weapon_class = entity.get_classname(weapon)
        return weapon_class == "CWeaponTaser"
    end
    return false
end

local function extrapolate_position(player, ticks)
    local x, y, z = entity.get_origin(player)
    local vx, vy, vz = entity.get_prop(player, "m_vecVelocity")
    local tick_interval = globals.tickinterval()
    return 
        x + (vx or 0) * tick_interval * ticks,
        y + (vy or 0) * tick_interval * ticks,
        z + (vz or 0) * tick_interval * ticks
end


local function apply_zeus_fix(player)
    if not ui.get(menu["misc"].other.Zeus_Fix) then return end
    if not has_zeus(player) then return end

    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then return end
    local extrapolated_x, extrapolated_y, extrapolated_z = extrapolate_position(player, 6) 
    local eye_x, eye_y, eye_z = client.eye_position()
    local delta_x, delta_y = extrapolated_x - eye_x, extrapolated_y - eye_y
    local predicted_yaw = math.deg(math.atan2(delta_y, delta_x)) - 90
    predicted_yaw = normalize_angle(predicted_yaw)
    if can_penetrate_wall(local_player, player, predicted_yaw) then
        plist.set(player, "Force body yaw", true)
        plist.set(player, "Force body yaw value", clamp(predicted_yaw, -60, 60))
        plist.set(player, "Override hitbox", true)
        plist.set(player, "Override hitbox value", 0) 
        client.delay_call(0.015, function()
            plist.set(player, "Override hitbox", false)
        end)
    else
        plist.set(player, "Force body yaw", false)
    end
end



local function is_on_ladder()
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then return false end
    local move_type = entity.get_prop(local_player, "m_MoveType")
    return move_type == 9 
end


local function fast_ladder(cmd)
    
    if not ui.get(menu["misc"].other.FastLadder) then return end

    
    if not is_on_ladder() then return end

    
    local pitch, yaw = client.camera_angles()
    if not pitch or not yaw then return end

    
    cmd.pitch = -35 
    cmd.yaw = yaw   

    
    cmd.forwardmove = 500 
    cmd.sidemove = 0      

    
    cmd.buttons = bit.band(cmd.buttons, bit.bnot(1)) 
    cmd.buttons = bit.band(cmd.buttons, bit.bnot(2)) 

    
    if cmd.chokedcommands < 2 then
        cmd.chokedcommands = 1 
    end
end


client.set_event_callback("setup_command", fast_ladder)

local player_cache = {}

client.set_event_callback("player_death", function(e)
    local local_player = entity.get_local_player()
    if not local_player then return end

    
    if not ui.get(menu["misc"].other.trashtalk) then return end

    local attacker = client.userid_to_entindex(e.attacker)
    local victim = client.userid_to_entindex(e.userid)

    
    if attacker == local_player and entity.is_enemy(victim) then
        send_trashtalk(trashtalk_phrases.OnKill)
    
    elseif victim == local_player and entity.is_enemy(attacker) then
        send_trashtalk(trashtalk_phrases.OnDeath)
    end
end)

client.set_event_callback("aim_miss", function(e)
    local player = e.target
    if not entity.is_enemy(player) then return end

    update_player_cache(player)
    local cache = player_cache[player]
    if not cache then return end

    cache.misses = (cache.misses or 0) + 1
end)

local manual_state = "none"

local function handle_manual_and_freestand(cmd)
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then return end

    if ui.get(menu["misc"].binds.manual_left) then
        manual_state = "left"
    elseif ui.get(menu["misc"].binds.manual_right) then
        manual_state = "right"
    elseif ui.get(menu["misc"].binds.manual_reset) then
        manual_state = "none"
    end

    if manual_state ~= "none" then
        ui.set(tbl.items.enabled[1], false)
        local pitch, yaw = client.camera_angles()
        if manual_state == "left" then
            cmd.yaw = yaw + 90
        elseif manual_state == "right" then
            cmd.yaw = yaw - 90
        end
        return
    else
        ui.set(tbl.items.enabled[1], true)
    end

    if ui.get(menu["misc"].binds.freestanding) then
        local enemies = entity.get_players(true)
        if #enemies == 0 then return end

        local eye_pos = { client.eye_position() }
        local best_yaw = 0
        local max_fov = 180

        for i, enemy in ipairs(enemies) do
            local enemy_pos = { entity.hitbox_position(enemy, 0) }
            local dx = enemy_pos[1] - eye_pos[1]
            local dy = enemy_pos[2] - eye_pos[2]
            local enemy_yaw = math.deg(math.atan2(dy, dx)) - 90
            local yaw_diff = normalize_angle(enemy_yaw - cmd.yaw)

            if math.abs(yaw_diff) < max_fov then
                max_fov = math.abs(yaw_diff)
                best_yaw = normalize_angle(enemy_yaw + 180)
            end
        end

        ui.set(tbl.items.yaw[1], "180")
        ui.set(tbl.items.yaw[2], best_yaw)
        ui.set(tbl.items.jitter[1], "Off")
        ui.set(tbl.items.body[1], "Opposite")
        ui.set(tbl.items.fsbody[1], true)
    end
end

local resolver = {}

resolver.default = function(player)
    update_player_cache(player)
    local cache = player_cache[player]
    if not cache then return end

    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then return end

    local tick = globals.tickcount()
    local yaw = cache.eye_yaw
    local lby_delta = normalize_angle(cache.eye_yaw - cache.lby)
    local velocity_factor = clamp(cache.velocity / 260, 0, 1) * 40
    local anim_factor = cache.animstate * 120 - 60
    local leg_anim = entity.get_prop(player, "m_flPoseParameter", 6) or 0 
    local ping = client.latency() * 1000
    local eye_pos = { client.eye_position() }
    local enemy_pos = { entity.get_origin(player) }
    local dist = math.sqrt((eye_pos[1] - enemy_pos[1])^2 + (eye_pos[2] - enemy_pos[2])^2)
    local misses = cache.misses or 0

    
    local stability = 0
    local avg_yaw_delta = 0
    if #cache.aa_history >= 5 then
        local delta_sum = 0
        for i = 2, #cache.aa_history do
            delta_sum = delta_sum + math.abs(normalize_angle(cache.aa_history[i].yaw - cache.aa_history[i-1].yaw))
        end
        stability = delta_sum / (#cache.aa_history - 1)
        avg_yaw_delta = delta_sum / #cache.aa_history
    end

    
    if math.abs(lby_delta) > 25 then
        yaw = cache.lby + (lby_delta > 0 and 65 or -65)
    else
        yaw = yaw + velocity_factor + (anim_factor > 0 and 35 or -35) + (leg_anim > 0.5 and 20 or -20)
        if misses > 2 then
            yaw = yaw + (misses % 2 == 0 and 50 or -50)
        end
    end

    
    local velocity_x, velocity_y = entity.get_prop(player, "m_vecVelocity")
    local inertia_factor = clamp((velocity_x^2 + velocity_y^2)^0.5 / 260, 0, 1) * 30
    yaw = yaw + (velocity_x > 0 and inertia_factor or -inertia_factor)

    
    local choked_ticks = cache.choked_ticks or 0
    if choked_ticks > 3 then
        yaw = yaw + (choked_ticks * 12) * (velocity_factor > 0.5 and 1 or -1)
    end

    
    if stability < 10 then
        yaw = yaw + (tick % 4 == 0 and 60 or -60)
    elseif stability > 30 then
        yaw = yaw + math.sin(tick * 0.3) * 70
    end
    if dist < 200 then
        yaw = yaw + (math.random() - 0.5) * 80
    elseif dist > 1500 then
        yaw = yaw + velocity_factor * 1.5
    end

    yaw = normalize_angle(yaw)
    if can_penetrate_wall(local_player, player, yaw) then
        plist.set(player, "Force body yaw", true)
        plist.set(player, "Force body yaw value", clamp(yaw, -60, 60))
    else
        plist.set(player, "Force body yaw", false)
    end

    cache.last_yaw = yaw
end

resolver.bruteforce = function(player)
    update_player_cache(player)
    local cache = player_cache[player]
    if not cache then return end

    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then return end

    local tick = globals.tickcount()
    local misses = cache.misses or 0
    local history = cache.aa_history
    local choked_ticks = cache.choked_ticks or 0
    local angles = {-120, -90, -60, -45, -30, -15, 0, 15, 30, 45, 60, 90, 120} 
    local yaw = angles[(tick + misses) % #angles + 1]

    
    if #history >= 5 then
        local avg_yaw = 0
        local trend = 0
        local accel = 0
        for i = 2, #history do
            local delta = normalize_angle(history[i].yaw - history[i-1].yaw)
            avg_yaw = avg_yaw + history[i].yaw
            trend = trend + delta
            if i > 2 then
                accel = accel + (delta - normalize_angle(history[i-1].yaw - history[i-2].yaw))
            end
        end
        avg_yaw = normalize_angle(avg_yaw / #history)
        trend = trend / (#history - 1)
        accel = accel / (#history - 2)
        yaw = normalize_angle(avg_yaw + (misses % 2 == 0 and 60 or -60) + trend * 2 + accel * 5)
    end

    
    local weapon = entity.get_player_weapon(player)
    local weapon_type = weapon and entity.get_classname(weapon) or ""
    if weapon_type == "CWeaponAWP" or weapon_type == "CWeaponSSG08" then
        yaw = yaw + (misses % 2 == 0 and 45 or -45) 
    end

    
    if cache.velocity > 100 then
        yaw = yaw + clamp(cache.velocity / 260, 0, 1) * 50
    end
    if choked_ticks > 2 then
        yaw = yaw + (choked_ticks * 15) * (tick % 2 == 0 and 1 or -1)
    end

    
    if misses > 4 then
        yaw = yaw + (misses % 2 == 0 and -90 or 90)
    elseif misses > 2 then
        yaw = yaw + (tick % 3 == 0 and -60 or 60)
    end

    yaw = normalize_angle(yaw)
    if can_penetrate_wall(local_player, player, yaw) then
        plist.set(player, "Force body yaw", true)
        plist.set(player, "Force body yaw value", clamp(yaw, -60, 60))
    else
        plist.set(player, "Force body yaw", false)
    end
end

resolver.logic = function(player)
    update_player_cache(player)
    local cache = player_cache[player]
    if not cache then return end

    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then return end

    local delta = normalize_angle(cache.eye_yaw - cache.last_yaw)
    local lby_delta = normalize_angle(cache.eye_yaw - cache.lby)
    local velocity_factor = clamp(cache.velocity / 260, 0, 1) * 40
    local anim_factor = cache.animstate * 120 - 60
    local choked_ticks = cache.choked_ticks or 0
    local yaw = cache.eye_yaw
    local tick_interval = globals.tickinterval()
    local simtime_delta = globals.curtime() - (cache.last_update or 0)

    
    local velocity_x, velocity_y = entity.get_prop(player, "m_vecVelocity")
    local direction_change = #cache.aa_history >= 3 and normalize_angle(cache.aa_history[#cache.aa_history].yaw - cache.aa_history[#cache.aa_history-2].yaw) > 30

    
    if math.abs(lby_delta) > 30 then
        yaw = cache.lby + (lby_delta > 0 and 70 or -70)
    elseif direction_change then
        yaw = yaw + (velocity_x > 0 and 60 or -60)
    elseif math.abs(delta) > 25 then
        yaw = yaw - delta * 2.5
    else
        yaw = yaw + (anim_factor > 0 and 45 or -45)
    end

    
    if simtime_delta > tick_interval * 3 then
        yaw = yaw + (velocity_factor * 50) * (anim_factor > 0 and 1 or -1)
    end
    if choked_ticks > 3 then
        yaw = yaw + (choked_ticks * 18) * (lby_delta > 0 and -1 or 1)
    end

    yaw = normalize_angle(yaw)
    if can_penetrate_wall(local_player, player, yaw) then
        plist.set(player, "Force body yaw", true)
        plist.set(player, "Force body yaw value", clamp(yaw, -60, 60))
    else
        plist.set(player, "Force body yaw", false)
    end

    cache.last_yaw = yaw
end

resolver.smart = function(player)
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) or not entity.is_alive(player) then return end

    update_player_cache(player)
    local cache = player_cache[player]
    if not cache then return end

    local tick = globals.tickcount()
    local yaw = cache.eye_yaw or 0
    local lby_delta = normalize_angle(cache.eye_yaw - (cache.lby or 0))
    local velocity = cache.velocity or 0
    local anim_factor = (cache.animstate or 0) * 120 - 60
    local history = cache.aa_history or {}
    local choked_ticks = cache.choked_ticks or 0
    local misses = cache.misses or 0
    local eye_pos = { client.eye_position() }
    local enemy_pos = { entity.get_origin(player) }
    local dist = math.sqrt((eye_pos[1] - enemy_pos[1])^2 + (eye_pos[2] - enemy_pos[2])^2)
    local ping = client.latency() * 1000

    local stability, avg_yaw, yaw_trend = 0, 0, 0
    if #history >= 5 then
        local delta_sum, trend_sum = 0, 0
        for i = 1, #history do
            avg_yaw = avg_yaw + history[i].yaw
            if i > 1 then
                local delta = normalize_angle(history[i].yaw - history[i-1].yaw)
                delta_sum = delta_sum + math.abs(delta)
                trend_sum = trend_sum + delta
            end
        end
        avg_yaw = normalize_angle(avg_yaw / #history)
        stability = delta_sum / (#history - 1)
        yaw_trend = trend_sum / (#history - 1)
    else
        avg_yaw = cache.lby or yaw 
    end

    local velocity_factor = clamp(velocity / 260, 0, 1)
    local aa_type = "static"
    if stability > (ping > 100 and 50 or 40) then 
        aa_type = "jitter"
    elseif stability > 20 and choked_ticks > (dist < 500 and 2 or 3) then
        aa_type = "desync"
    elseif velocity > 150 and math.abs(anim_factor) > 30 then
        aa_type = "dynamic"
    elseif math.abs(yaw_trend) > 15 then
        aa_type = "spin"
    end

    if aa_type == "static" then
        yaw = avg_yaw
        if misses > 2 then
            yaw = yaw + (misses % 2 == 0 and 60 or -60) * (1 - velocity_factor) 
        end
    elseif aa_type == "jitter" then
        yaw = yaw + math.sin(tick * 0.6 + ping / 1000) * clamp(90 - stability, 30, 90)
        if choked_ticks > 2 then
            yaw = yaw + choked_ticks * 25 * (dist > 1000 and 0.5 or 1)
        end
    elseif aa_type == "desync" then
        yaw = cache.lby + (lby_delta > 0 and -70 or 70)
        if misses > 1 then
            yaw = yaw + (misses % 2 == 0 and 50 or -50)
        end
    elseif aa_type == "dynamic" then
        yaw = yaw + (anim_factor > 0 and velocity_factor * 70 or -velocity_factor * 70)
        if #history >= 3 then
            yaw = yaw + yaw_trend * clamp(3 - misses * 0.5, 1, 3) 
        end
    elseif aa_type == "spin" then
        yaw = yaw + yaw_trend * 5 + (tick % 2 == 0 and 45 or -45)
    end

    local simtime_delta = globals.curtime() - (cache.last_update or 0)
    if simtime_delta > 0.1 then
        yaw = yaw + (velocity > 100 and 60 or -60) * clamp(ping / 200, 0.5, 1)
    end
    if dist < 200 then
        yaw = yaw + (math.random() - 0.5) * 40
    elseif dist > 1500 then
        yaw = yaw + velocity_factor * 20
    end

    yaw = normalize_angle(yaw)
    if can_penetrate_wall(local_player, player, yaw) then
        plist.set(player, "Force body yaw", true)
        plist.set(player, "Force body yaw value", clamp(yaw, -60, 60))
    else
        plist.set(player, "Force body yaw", false)
    end

    cache.last_yaw = yaw
    cache.last_update = globals.curtime()
end

resolver.extra = function(player)
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) or not entity.is_alive(player) then return end

    update_player_cache(player)
    local cache = player_cache[player]
    if not cache then return end

    local tick = globals.tickcount()
    local current_x, current_y, current_z = entity.get_origin(player)
    local eye_x, eye_y, eye_z = client.eye_position()
    local tick_interval = globals.tickinterval()
    local history = cache.aa_history or {}
    local velocity_x, velocity_y = entity.get_prop(player, "m_vecVelocity") or 0, 0
    local velocity = cache.velocity or 0
    local choked_ticks = cache.choked_ticks or 0
    local anim_factor = (cache.animstate or 0) * 120 - 60
    local pitch = entity.get_prop(player, "m_angEyeAngles", 0) or 0
    local ping = client.latency() * 1000
    local dist = math.sqrt((eye_x - current_x)^2 + (eye_y - current_y)^2)
    local misses = cache.misses or 0
    local lby_delta = normalize_angle(cache.eye_yaw - (cache.lby or 0))

    local pred_x, pred_y, pred_z = extrapolate_position(player, 6)
    local pred_dx, pred_dy = pred_x - eye_x, pred_y - eye_y
    local pred_yaw = math.deg(math.atan2(pred_dy, pred_dx)) - 90

    local stability, yaw_trend, avg_yaw = 0, 0, 0
    if #history >= 5 then
        local delta_sum, trend_sum = 0, 0
        for i = 1, #history do
            avg_yaw = avg_yaw + history[i].yaw
            if i > 1 then
                local delta = normalize_angle(history[i].yaw - history[i-1].yaw)
                delta_sum = delta_sum + math.abs(delta)
                trend_sum = trend_sum + delta
            end
        end
        avg_yaw = normalize_angle(avg_yaw / #history)
        stability = delta_sum / (#history - 1)
        yaw_trend = trend_sum / (#history - 1)
    else
        avg_yaw = cache.eye_yaw or 0
    end

    local yaw = pred_yaw

    if stability < 15 then
        yaw = avg_yaw + (lby_delta > 0 and 60 or -60)
    elseif stability > 30 then
        yaw = yaw + math.cos(tick * 0.8 + ping / 1000) * clamp(80 - velocity / 4, 20, 80)
    end

    local height_diff = current_z - eye_z
    if math.abs(height_diff) > 50 then
        yaw = yaw + (height_diff > 0 and 45 or -45) * clamp(velocity_factor, 0.5, 1)
    end

    local weapon = entity.get_player_weapon(player)
    local weapon_type = weapon and entity.get_classname(weapon) or ""
    if weapon_type == "CWeaponAWP" or weapon_type == "CWeaponSSG08" then
        yaw = yaw + (misses % 2 == 0 and 50 or -50)
    elseif weapon_type == "CWeaponPistol" then
        yaw = yaw + math.random(-30, 30)
    end

    if can_penetrate_wall(local_player, player, yaw) then
        yaw = yaw + (velocity_x > 0 and 30 or -30) * clamp(choked_ticks / 5, 0, 1)
    else
        yaw = yaw + yaw_trend * 4 
    end

    if misses > 3 then
        yaw = yaw + (tick % 2 == 0 and 90 or -90) * (1 - velocity_factor)
    end
    if choked_ticks > 4 then
        yaw = yaw + choked_ticks * 15 * (dist < 500 and 1 or 0.5)
    end

    if ping > 100 then
        yaw = yaw + (math.random() - 0.5) * clamp(ping / 50, 10, 60)
    end

    yaw = normalize_angle(yaw)
    if can_penetrate_wall(local_player, player, yaw) then
        plist.set(player, "Force body yaw", true)
        plist.set(player, "Force body yaw value", clamp(yaw, -60, 60))
    else
        plist.set(player, "Force body yaw", false)
    end

    cache.last_yaw = yaw
    cache.last_update = globals.curtime()
end

resolver["resolver builder"] = function(player)
    update_player_cache(player)
    local cache = player_cache[player]
    if not cache then return end

    local tick = globals.tickcount()
    local yaw = cache.eye_yaw or 0
    local delta_yaw = normalize_angle((cache.eye_yaw or 0) - (cache.last_yaw or 0))
    local lby_delta = normalize_angle((cache.eye_yaw or 0) - (cache.lby or 0))
    local velocity = cache.velocity or 0
    local anim_factor = (cache.animstate or 0) * 120 - 60 
    local history = cache.aa_history or {} 
    local dt_active = ui.get(tbl.items.dt[1]) or false
    local ping = client.latency() * 1000 
    local local_player = entity.get_local_player()

    if not local_player or not entity.is_alive(local_player) then return end

    local eye_pos = {client.eye_position()}
    if not eye_pos[1] or not eye_pos[2] or not eye_pos[3] then return end

    local player_pos = {entity.get_origin(player)}
    if not player_pos[1] or not player_pos[2] or not player_pos[3] then return end

    local fraction, hit_entity = client.trace_line(local_player, eye_pos[1], eye_pos[2], eye_pos[3], player_pos[1], player_pos[2], player_pos[3])
    if fraction == nil then fraction = 1 end

    
    if ui.get(menu.resolver.builder.velocity.enabled) then
        local velocity_factor = ui.get(menu.resolver.builder.velocity.factor) / 100
        local velocity_threshold = ui.get(menu.resolver.builder.velocity.threshold)
        local velocity_invert = ui.get(menu.resolver.builder.velocity.invert)
        local velocity_wall = ui.get(menu.resolver.builder.velocity.wall_aware)
        local velocity_clamp = ui.get(menu.resolver.builder.velocity.max_adjustment)
        local velocity_spike = ui.get(menu.resolver.builder.velocity.spike_factor) / 100
        if velocity > velocity_threshold then
            local velocity_adjust = clamp((velocity / 260) * 50 * velocity_factor, -velocity_clamp, velocity_clamp)
            if velocity_wall and fraction < 1 then
                velocity_adjust = velocity_adjust * 0.5
            end
            if velocity_spike > 0 and velocity > 150 then
                velocity_adjust = velocity_adjust + (velocity - 150) * velocity_spike
            end
            yaw = yaw + (velocity_invert and (tick % 2 == 0 and -velocity_adjust or velocity_adjust) or (tick % 2 == 0 and velocity_adjust or -velocity_adjust))
        end
    end

    
    if ui.get(menu.resolver.builder.animations.enabled) then
        local anim_mode = ui.get(menu.resolver.builder.animations.mode)
        local anim_influence = ui.get(menu.resolver.builder.animations.influence) / 100
        local anim_threshold = ui.get(menu.resolver.builder.animations.threshold)
        local lby_influence = ui.get(menu.resolver.builder.animations.lby_influence) / 100
        local choke_influence = ui.get(menu.resolver.builder.animations.choke_influence) / 100
        local anim_smoothing = ui.get(menu.resolver.builder.animations.smoothing) / 100
        local anim_boost = ui.get(menu.resolver.builder.animations.boost_factor) / 100
        if math.abs(anim_factor) > anim_threshold then
            local anim_adjust = 0
            if anim_mode == "Static" then
                anim_adjust = (anim_factor > 0 and 45 or -45) * anim_influence
            elseif anim_mode == "Dynamic" then
                anim_adjust = anim_factor * anim_influence
            elseif anim_mode == "Mixed" then
                anim_adjust = (anim_factor > 0 and math.sin(tick * 0.5) * 60 or math.cos(tick * 0.5) * -60) * anim_influence
            end
            if lby_influence > 0 and math.abs(lby_delta) > 25 then
                anim_adjust = anim_adjust + (lby_delta > 0 and 30 or -30) * lby_influence
            end
            if choke_influence > 0 and cache.choked_ticks > 2 then
                anim_adjust = anim_adjust + (cache.choked_ticks * 10) * choke_influence
            end
            yaw = yaw + anim_adjust * (1 - anim_smoothing) + (yaw * anim_smoothing)
            if anim_boost > 0 then
                yaw = yaw + (math.random() - 0.5) * 20 * anim_boost
            end
        end
    end

    
    if ui.get(menu.resolver.builder.history.enabled) then
        local history_mode = ui.get(menu.resolver.builder.history.mode)
        local history_depth = ui.get(menu.resolver.builder.history.depth)
        local stability_threshold = ui.get(menu.resolver.builder.history.stability_threshold)
        local invert = ui.get(menu.resolver.builder.history.invert)
        local weight_factor = ui.get(menu.resolver.builder.history.weight_factor) / 100
        local jitter_influence = ui.get(menu.resolver.builder.history.jitter_influence) / 100
        if #history >= history_depth then
            local avg_yaw = 0
            local delta_sum = 0
            for i = 1, history_depth do
                avg_yaw = avg_yaw + history[#history - i + 1].yaw
                if i > 1 then
                    delta_sum = delta_sum + math.abs(normalize_angle(history[#history - i + 1].yaw - history[#history - i].yaw))
                end
            end
            avg_yaw = avg_yaw / history_depth
            local stability = delta_sum / (history_depth - 1)
            local history_adjust = 0
            if history_mode == "Average" then
                history_adjust = normalize_angle(avg_yaw - yaw) * weight_factor
            elseif history_mode == "Delta" then
                history_adjust = delta_sum * weight_factor * (invert and -1 or 1)
            elseif history_mode == "Pattern" and stability < stability_threshold then
                history_adjust = (tick % 2 == 0 and 60 or -60) * weight_factor
            end
            if jitter_influence > 0 and stability > stability_threshold then
                history_adjust = history_adjust + math.sin(tick * 0.3) * 70 * jitter_influence
            end
            yaw = yaw + history_adjust
        end
    end

    
    if ui.get(menu.resolver.builder.miss.enabled) then
        local miss_mode = ui.get(menu.resolver.builder.miss.mode)
        local miss_amplitude = ui.get(menu.resolver.builder.miss.amplitude)
        local after_misses = ui.get(menu.resolver.builder.miss.after_misses)
        local invert = ui.get(menu.resolver.builder.miss.invert)
        local reset_threshold = ui.get(menu.resolver.builder.miss.reset_threshold)
        local scale_factor = ui.get(menu.resolver.builder.miss.scale_factor) / 100
        if cache.misses >= after_misses then
            local miss_adjust = 0
            if miss_mode == "Shift" then
                miss_adjust = miss_amplitude * (invert and -1 or 1)
            elseif miss_mode == "Random" then
                miss_adjust = (math.random() - 0.5) * miss_amplitude * 2
            elseif miss_mode == "Cycle" then
                miss_adjust = miss_amplitude * ((cache.misses % 2 == 0) and 1 or -1)
            end
            yaw = yaw + miss_adjust * (1 + scale_factor * cache.misses)
            if reset_threshold > 0 and cache.misses >= reset_threshold then
                cache.misses = 0
            end
        end
    end

    
    if ui.get(menu.resolver.builder.jitter.enabled) then
        local jitter_type = ui.get(menu.resolver.builder.jitter.type)
        local jitter_frequency = ui.get(menu.resolver.builder.jitter.frequency) / 100
        local jitter_amplitude = ui.get(menu.resolver.builder.jitter.amplitude)
        local chaos_factor = ui.get(menu.resolver.builder.jitter.chaos_factor) / 100
        local sync_with_tick = ui.get(menu.resolver.builder.jitter.sync_with_tick)
        local phase_shift = ui.get(menu.resolver.builder.jitter.phase_shift) / 100
        local jitter_adjust = 0
        if jitter_type == "Sine" then
            jitter_adjust = math.sin(tick * jitter_frequency + phase_shift) * jitter_amplitude
        elseif jitter_type == "Cosine" then
            jitter_adjust = math.cos(tick * jitter_frequency + phase_shift) * jitter_amplitude
        elseif jitter_type == "Random" then
            jitter_adjust = (math.random() - 0.5) * jitter_amplitude * 2
        end
        if chaos_factor > 0 then
            jitter_adjust = jitter_adjust + (math.random() - 0.5) * jitter_amplitude * chaos_factor
        end
        if sync_with_tick then
            jitter_adjust = jitter_adjust * math.sin(tick * 0.1)
        end
        yaw = yaw + jitter_adjust
    end

    
    if ui.get(menu.resolver.builder.defensive.enabled) then
        local anti_bruteforce = ui.get(menu.resolver.builder.defensive.anti_bruteforce)
        local anti_bruteforce_misses = ui.get(menu.resolver.builder.defensive.anti_bruteforce_misses)
        local random_shift = ui.get(menu.resolver.builder.defensive.random_shift)
        local random_shift_max = ui.get(menu.resolver.builder.defensive.random_shift_max)
        local jitter_amplitude = ui.get(menu.resolver.builder.defensive.jitter_amplitude)
        local adaptive_defense = ui.get(menu.resolver.builder.defensive.adaptive_defense)
        local adaptive_threshold = ui.get(menu.resolver.builder.defensive.adaptive_threshold)
        local ping_mode = ui.get(menu.resolver.builder.defensive.ping_mode)
        local edge_detection = ui.get(menu.resolver.builder.defensive.edge_detection)
        local choke_factor = ui.get(menu.resolver.builder.defensive.choke_factor) / 100
        local defensive_adjust = 0
        if anti_bruteforce and cache.misses >= anti_bruteforce_misses then
            defensive_adjust = defensive_adjust + (tick % 2 == 0 and 60 or -60)
        end
        if random_shift then
            defensive_adjust = defensive_adjust + (math.random() - 0.5) * random_shift_max * 2
        end
        if jitter_amplitude > 0 then
            defensive_adjust = defensive_adjust + math.sin(tick * 0.5) * jitter_amplitude
        end
        if adaptive_defense and #history >= 5 then
            local stability = 0
            for i = 2, #history do
                stability = stability + math.abs(normalize_angle(history[i].yaw - history[i-1].yaw))
            end
            stability = stability / (#history - 1)
            if stability < adaptive_threshold then
                defensive_adjust = defensive_adjust + (tick % 2 == 0 and 45 or -45)
            end
        end
        if ping_mode ~= "Off" and ping > (ping_mode == "Low" and 50 or 100) then
            defensive_adjust = defensive_adjust + (ping / 200) * 30
        end
        if edge_detection and fraction < 0.9 then
            defensive_adjust = defensive_adjust + 45
        end
        if choke_factor > 0 and cache.choked_ticks > 3 then
            defensive_adjust = defensive_adjust + (cache.choked_ticks * 15) * choke_factor
        end
        yaw = yaw + defensive_adjust
    end

    
    if ui.get(menu.resolver.builder.hitbox.enabled) then
        local hitbox_mode = ui.get(menu.resolver.builder.hitbox.mode)
        local static_hitbox = ui.get(menu.resolver.builder.hitbox.static_hitbox)
        local switch_speed = ui.get(menu.resolver.builder.hitbox.switch_speed)
        local on_miss = ui.get(menu.resolver.builder.hitbox.on_miss)
        local miss_count = ui.get(menu.resolver.builder.hitbox.miss_count)
        local randomize = ui.get(menu.resolver.builder.hitbox.randomize)
        local priority_factor = ui.get(menu.resolver.builder.hitbox.priority_factor) / 100
        local hitbox_value = 0
        if hitbox_mode == "Static" then
            hitbox_value = static_hitbox == "Head" and 0 or (static_hitbox == "Chest" and 4 or 6)
        elseif hitbox_mode == "Cycle" then
            hitbox_value = math.floor((tick / switch_speed) % 3) * 2
        elseif hitbox_mode == "Adaptive" and on_miss and cache.misses >= miss_count then
            hitbox_value = (cache.misses % 3) * 2
        end
        if randomize then
            hitbox_value = math.random(0, 2) * 2
        end
        plist.set(player, "Override hitbox", true)
        plist.set(player, "Override hitbox value", hitbox_value)
    else
        plist.set(player, "Override hitbox", false)
    end

    
    if ui.get(menu.resolver.builder.double_tap.enabled) then
        local dt_mode = ui.get(menu.resolver.builder.double_tap.mode)
        local shift_amount = ui.get(menu.resolver.builder.double_tap.shift_amount)
        local velocity_boost = ui.get(menu.resolver.builder.double_tap.velocity_boost) / 100
        local choke_adjust = ui.get(menu.resolver.builder.double_tap.choke_adjust) / 100
        if dt_active then
            local dt_adjust = 0
            if dt_mode == "Static" then
                dt_adjust = shift_amount
            elseif dt_mode == "Dynamic" then
                dt_adjust = shift_amount * math.sin(tick * 0.5)
            elseif dt_mode == "Random" then
                dt_adjust = (math.random() - 0.5) * shift_amount * 2
            end
            if velocity_boost > 0 then
                dt_adjust = dt_adjust + (velocity / 260) * 50 * velocity_boost
            end
            if choke_adjust > 0 and cache.choked_ticks > 2 then
                dt_adjust = dt_adjust + (cache.choked_ticks * 10) * choke_adjust
            end
            yaw = yaw + dt_adjust
        end
    end

    
    if ui.get(menu.resolver.builder.distance.enabled) then
        local min_dist = ui.get(menu.resolver.builder.distance.min_dist)
        local max_dist = ui.get(menu.resolver.builder.distance.max_dist)
        local dist_factor = ui.get(menu.resolver.builder.distance.dist_factor) / 100
        local close_shift = ui.get(menu.resolver.builder.distance.close_shift)
        local far_shift = ui.get(menu.resolver.builder.distance.far_shift)
        local dist = math.sqrt((eye_pos[1] - player_pos[1])^2 + (eye_pos[2] - player_pos[2])^2)
        if dist < min_dist then
            yaw = yaw + close_shift * dist_factor
        elseif dist > max_dist then
            yaw = yaw + far_shift * dist_factor
        else
            local dist_range = max_dist - min_dist
            local dist_progress = (dist - min_dist) / dist_range
            yaw = yaw + (close_shift + (far_shift - close_shift) * dist_progress) * dist_factor
        end
    end

    
    if ui.get(menu.resolver.builder["weapon⠀awareness"].enabled) then
        local sniper_adjust = ui.get(menu.resolver.builder["weapon⠀awareness"].sniper_adjust)
        local pistol_adjust = ui.get(menu.resolver.builder["weapon⠀awareness"].pistol_adjust)
        local rifle_adjust = ui.get(menu.resolver.builder["weapon⠀awareness"].rifle_adjust)
        local dynamic_switch = ui.get(menu.resolver.builder["weapon⠀awareness"].dynamic_switch)
        local switch_speed = ui.get(menu.resolver.builder["weapon⠀awareness"].switch_speed)
        local weapon = entity.get_player_weapon(player)
        local weapon_type = weapon and entity.get_classname(weapon) or ""
        local weapon_adjust = 0
        if weapon_type == "CWeaponAWP" or weapon_type == "CWeaponSSG08" then
            weapon_adjust = sniper_adjust
        elseif weapon_type == "CWeaponPistol" then
            weapon_adjust = pistol_adjust
        else
            weapon_adjust = rifle_adjust
        end
        if dynamic_switch then
            weapon_adjust = weapon_adjust * math.sin(tick / switch_speed)
        end
        yaw = yaw + weapon_adjust
    end

    
    if ui.get(menu.resolver.builder.prediction.enabled) then
        local ticks = ui.get(menu.resolver.builder.prediction.ticks)
        local accel_factor = ui.get(menu.resolver.builder.prediction.accel_factor) / 100
        local yaw_boost = ui.get(menu.resolver.builder.prediction.yaw_boost)
        local velocity_scale = ui.get(menu.resolver.builder.prediction.velocity_scale) / 100
        local wall_aware = ui.get(menu.resolver.builder.prediction.wall_aware)
        local vx, vy = entity.get_prop(player, "m_vecVelocity")
        local pred_x, pred_y = extrapolate_position(player, ticks)
        local delta_x, delta_y = pred_x - eye_pos[1], pred_y - eye_pos[2]
        local pred_yaw = math.deg(math.atan2(delta_y, delta_x)) - 90
        local pred_adjust = normalize_angle(pred_yaw - yaw) * velocity_scale
        if accel_factor > 0 and #history >= 3 then
            local accel = ((history[#history].x - history[#history-1].x) - (history[#history-1].x - history[#history-2].x)) / globals.tickinterval()
            pred_adjust = pred_adjust + accel * accel_factor
        end
        if wall_aware and fraction < 0.9 then
            pred_adjust = pred_adjust * 0.5
        end
        yaw = yaw + pred_adjust + yaw_boost
    end

    
    if ui.get(menu.resolver.builder["latency⠀compensation"].enabled) then
        local ping_threshold = ui.get(menu.resolver.builder["latency⠀compensation"].ping_threshold)
        local high_ping_shift = ui.get(menu.resolver.builder["latency⠀compensation"].high_ping_shift)
        local choke_factor = ui.get(menu.resolver.builder["latency⠀compensation"].choke_factor) / 100
        local smooth_transition = ui.get(menu.resolver.builder["latency⠀compensation"].smooth_transition)
        if ping > ping_threshold then
            local latency_adjust = high_ping_shift * (ping / 200)
            if choke_factor > 0 and cache.choked_ticks > 3 then
                latency_adjust = latency_adjust + (cache.choked_ticks * 15) * choke_factor
            end
            if smooth_transition then
                latency_adjust = latency_adjust * math.sin(tick * 0.1)
            end
            yaw = yaw + latency_adjust
        end
    end

    
    if ui.get(menu.resolver.builder.override.enabled) then
        local condition = ui.get(menu.resolver.builder.override.condition)
        local yaw_value = ui.get(menu.resolver.builder.override.yaw_value)
        local miss_threshold = ui.get(menu.resolver.builder.override.miss_threshold)
        local choke_threshold = ui.get(menu.resolver.builder.override.choke_threshold)
        local stability_threshold = ui.get(menu.resolver.builder.override.stability_threshold)
        local override = false
        if condition == "Always" then
            override = true
        elseif condition == "On Miss" and cache.misses >= miss_threshold then
            override = true
        elseif condition == "On High Choke" and cache.choked_ticks >= choke_threshold then
            override = true
        elseif condition == "On Low Stability" and #history >= 5 then
            local stability = 0
            for i = 2, #history do
                stability = stability + math.abs(normalize_angle(history[i].yaw - history[i-1].yaw))
            end
            stability = stability / (#history - 1)
            if stability < stability_threshold then
                override = true
            end
        end
        if override then
            yaw = normalize_angle(yaw_value)
        end
    end

    
    yaw = normalize_angle(yaw)
    if can_penetrate_wall(local_player, player, yaw) then
        plist.set(player, "Force body yaw", true)
        plist.set(player, "Force body yaw value", clamp(yaw, -60, 60))
    else
        plist.set(player, "Force body yaw", false)
    end

    cache.last_yaw = yaw
end

client.set_event_callback("net_update_start", function()
    local enemies = entity.get_players(true)
    local preset = ui.get(menu.resolver.preset)
    if resolver[preset] then
        for i, player in ipairs(enemies) do
            resolver[preset](player)
            apply_zeus_fix(player)  
        end
    end
end)

local smart_backtrack_active = false

local function smart_backtrack()
    if not ui.get(menu["misc"].other.smart_backtrack) then return end

    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then return end

    local tick_interval = globals.tickinterval()
    local latency = client.latency() or 0
    local max_backtrack_time = 0.2
    local max_ticks = math.floor(max_backtrack_time / tick_interval)
    local enemies = entity.get_players(true)
    local gravity = 800

    for _, enemy in ipairs(enemies) do
        if entity.is_alive(enemy) then
            update_player_cache(enemy)
            local cache = player_cache[enemy]
            if not cache then goto skip end

            local sim_time = cache.simtime or 0
            local choked_ticks = math.min(cache.choked_ticks or 0, 14)
            local velocity = {entity.get_prop(enemy, "m_vecVelocity") or 0, 0, 0}
            local speed = math.sqrt(velocity[1]^2 + velocity[2]^2)
            local on_ground = cache.on_ground or true
            local eye_yaw = cache.eye_yaw or 0
            local misses = cache.misses or 0  

            
            local latency_ticks = math.floor(latency / tick_interval + 0.5)
            local backtrack_ticks = latency_ticks + choked_ticks

            
            if speed > 10 then
                local speed_factor = math.min(speed / 260, 1)
                backtrack_ticks = backtrack_ticks + math.floor(speed_factor * 6)
            end
            if misses > 0 then
                backtrack_ticks = backtrack_ticks + math.min(misses * 2, 6)  
            end

            backtrack_ticks = math.max(1, math.min(backtrack_ticks, max_ticks))
            local target_time = sim_time - (backtrack_ticks * tick_interval)

            
            local predicted_time = target_time
            local pred_x, pred_y, pred_z = entity.get_origin(enemy)
            if pred_x and speed > 50 and choked_ticks > 2 then
                local extra_ticks = math.min(choked_ticks, 10)
                predicted_time = target_time - (extra_ticks * tick_interval)
                pred_x = pred_x + velocity[1] * tick_interval * extra_ticks
                pred_y = pred_y + velocity[2] * tick_interval * extra_ticks
                pred_z = pred_z + velocity[3] * tick_interval * extra_ticks
                if not on_ground then
                    pred_z = pred_z - (0.5 * gravity * (tick_interval * extra_ticks)^2)
                end
                plist.set(enemy, "Override hitbox", true)
                plist.set(enemy, "Override hitbox value", 0)
            else
                plist.set(enemy, "Override hitbox", false)
            end

            
            plist.set(enemy, "Correction active", true)
            plist.set(enemy, "Override simulation time", true)
            plist.set(enemy, "Simulation time override", target_time)

            
            local resolver_yaw = eye_yaw
            if speed > 80 then
                resolver_yaw = resolver_yaw + (velocity[1] > 0 and 30 or -30)
            elseif choked_ticks > 5 then
                resolver_yaw = resolver_yaw + (globals.tickcount() % 2 == 0 and 45 or -45)
            end
            if misses > 2 then
                resolver_yaw = resolver_yaw + (misses % 2 == 0 and 60 or -60)  
            end
            resolver_yaw = normalize_angle(resolver_yaw)
            plist.set(enemy, "Force body yaw", true)
            plist.set(enemy, "Force body yaw value", clamp(resolver_yaw, -60, 60))

            
            if not smart_backtrack_active then
                client.color_log(0, 255, 0, string.format(
                    "[Smart Backtrack] Enabled | Max Ticks: %d | Latency: %.1f ms",
                    max_ticks, latency * 1000
                ))
                smart_backtrack_active = true
            end
        end
        ::skip::
    end
end


local function reset_smart_backtrack()
    local enemies = entity.get_players(true)
    for _, enemy in ipairs(enemies) do
        plist.set(enemy, "Correction active", false)
        plist.set(enemy, "Override simulation time", false)
        plist.set(enemy, "Override hitbox", false)
        plist.set(enemy, "Force body yaw", false)
    end
    smart_backtrack_active = false
end

local function watermark()
    if not entity.is_alive(entity.get_local_player()) then return end
    if not ui.get(menu["visuals"].watermark) then return end

    local lp = entity.get_local_player()
    local screen_w, screen_h = client.screen_size()
    local center = {screen_w / 2, screen_h / 2}
    local alpha = 255
    local col = {indicators = {200, 150, 255}} 

    local yaw_body = math.max(-60, math.min(60, math.floor((entity.get_prop(lp, "m_flPoseParameter", 11) or 0) * 120 - 60 + 0.5)))
    renderer.text(center[1], center[2] + 15, col.indicators[1], col.indicators[2], col.indicators[3], alpha, "cd", 0, "Insanity")
    renderer.rectangle(center[1] - 30, center[2] + 25, 60, 3, 20, 20, 20, alpha)
    renderer.gradient(center[1] - 29, center[2] + 26, math.abs(yaw_body), 1, col.indicators[1], col.indicators[2], col.indicators[3], alpha, 20, 20, 20, alpha, true)
end


local function misc_logic()
    smart_backtrack() 
end


client.set_event_callback("paint", function()
    misc_logic()
    if ui.get(menu["visuals"].watermark) then
        watermark()
    end
end)


local function other_logic(cmd)
    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then return end

    local tick = globals.tickcount()

    
    if ui.get(menu["misc"].other.leg_spammer) then
    ui.set(tbl.items.legs[1], tick % ui.get(menu["misc"].other.spammer) == 0 and "Never slide" or "Always slide")
    end
end


local function main(tbl_ref)
    local category = ui.new_combobox("aa", "anti-aimbot angles", "\aBA55D3FFcategory", {"home", "anti-aim", "resolver", "visuals", "misc"})
    
    menu["home"] = {
        export = ui.new_button("aa", "anti-aimbot angles", "\aBA55D3FFexport", function()
            local config = { anti_aim = {}, resolver = {}, visuals = {}, misc = {} }
            
            
            for k, v in pairs(menu["anti-aim"]) do
                if type(v) == "number" then 
                    local value = ui.get(v)
                    if value ~= nil then
                        config.anti_aim[k] = value
                    end
                elseif k == "builder" and type(v) == "table" then
                    config.anti_aim.builder = {}
                    for sub_k, sub_v in pairs(v) do
                        if type(sub_v) == "number" then 
                            local value = ui.get(sub_v)
                            if value ~= nil then
                                config.anti_aim.builder[sub_k] = value
                            end
                        elseif type(sub_v) == "table" then 
                            config.anti_aim.builder[sub_k] = {}
                            for sub_sub_k, sub_sub_v in pairs(sub_v) do
                                if type(sub_sub_v) == "number" then 
                                    local value = ui.get(sub_sub_v)
                                    if value ~= nil then
                                        config.anti_aim.builder[sub_k][sub_sub_k] = value
                                    end
                                elseif type(sub_sub_v) == "table" then
                                    config.anti_aim.builder[sub_k][sub_sub_k] = {}
                                    for sub_sub_sub_k, sub_sub_sub_v in pairs(sub_sub_v) do
                                        if type(sub_sub_sub_v) == "number" then
                                            local value = ui.get(sub_sub_sub_v)
                                            if value ~= nil then
                                                config.anti_aim.builder[sub_k][sub_sub_k][sub_sub_sub_k] = value
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            
            for k, v in pairs(menu["resolver"]) do
                if type(v) == "number" then 
                    local value = ui.get(v)
                    if value ~= nil then
                        config.resolver[k] = value
                    end
                elseif k == "builder" and type(v) == "table" then
                    config.resolver.builder = {}
                    for sub_k, sub_v in pairs(v) do
                        if type(sub_v) == "number" then 
                            local value = ui.get(sub_v)
                            if value ~= nil then
                                config.resolver.builder[sub_k] = value
                            end
                        elseif type(sub_v) == "table" then 
                            config.resolver.builder[sub_k] = {}
                            for sub_sub_k, sub_sub_v in pairs(sub_v) do
                                if type(sub_sub_v) == "number" then 
                                    local value = ui.get(sub_sub_v)
                                    if value ~= nil then
                                        config.resolver.builder[sub_k][sub_sub_k] = value
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            
            for k, v in pairs(menu["visuals"]) do
                if type(v) == "number" then 
                    local value = ui.get(v)
                    if value ~= nil then
                        config.visuals[k] = value
                    end
                end
            end
            
            
            for k, v in pairs(menu["misc"]) do
                if type(v) == "number" then 
                    local value = ui.get(v)
                    if value ~= nil then
                        config.misc[k] = value
                    end
                elseif type(v) == "table" then 
                    config.misc[k] = {}
                    for sub_k, sub_v in pairs(v) do
                        if type(sub_v) == "number" then
                            local value = ui.get(sub_v)
                            if value ~= nil then
                                config.misc[k][sub_k] = value
                            end
                        end
                    end
                end
            end
            
            local json_str = json.stringify(config)
            local b64_str = b64.encode(json_str)
            local export_str = "INSANITY " .. b64_str
            clipboard.export(export_str)
            client.color_log(221, 160, 221, "[Insanity] Configuration exported to clipboard successfully")
        end),
        import = ui.new_button("aa", "anti-aimbot angles", "\aDDA0DDFFimport", function()
            local config_str = clipboard.import()
            if config_str ~= "" and config_str:find("^INSANITY ") then
                local b64_str = config_str:sub(10)
                local json_str = b64.decode(b64_str)
                local success, config = pcall(json.parse, json_str)
                if success then
                    
                    for k, v in pairs(config.anti_aim or {}) do
                        if menu["anti-aim"][k] and type(menu["anti-aim"][k]) == "number" then
                            ui.set(menu["anti-aim"][k], v)
                        elseif k == "builder" and type(v) == "table" then
                            for sub_k, sub_v in pairs(v) do
                                if menu["anti-aim"].builder[sub_k] then
                                    if type(sub_v) == "table" then
                                        for sub_sub_k, sub_sub_v in pairs(sub_v) do
                                            if type(sub_sub_v) == "table" then
                                                for sub_sub_sub_k, sub_sub_sub_v in pairs(sub_sub_v) do
                                                    if menu["anti-aim"].builder[sub_k][sub_sub_k][sub_sub_sub_k] and type(menu["anti-aim"].builder[sub_k][sub_sub_k][sub_sub_sub_k]) == "number" then
                                                        ui.set(menu["anti-aim"].builder[sub_k][sub_sub_k][sub_sub_sub_k], sub_sub_sub_v)
                                                    end
                                                end
                                            elseif menu["anti-aim"].builder[sub_k][sub_sub_k] and type(menu["anti-aim"].builder[sub_k][sub_sub_k]) == "number" then
                                                ui.set(menu["anti-aim"].builder[sub_k][sub_sub_k], sub_sub_v)
                                            end
                                        end
                                    elseif type(menu["anti-aim"].builder[sub_k]) == "number" then
                                        ui.set(menu["anti-aim"].builder[sub_k], sub_v)
                                    end
                                end
                            end
                        end
                    end
                    
                    
                    for k, v in pairs(config.resolver or {}) do
                        if menu["resolver"][k] and type(menu["resolver"][k]) == "number" then
                            ui.set(menu["resolver"][k], v)
                        elseif k == "builder" and type(v) == "table" then
                            for sub_k, sub_v in pairs(v) do
                                if menu["resolver"].builder[sub_k] then
                                    if type(sub_v) == "table" then
                                        for sub_sub_k, sub_sub_v in pairs(sub_v) do
                                            if menu["resolver"].builder[sub_k][sub_sub_k] and type(menu["resolver"].builder[sub_k][sub_sub_k]) == "number" then
                                                ui.set(menu["resolver"].builder[sub_k][sub_sub_k], sub_sub_v)
                                            end
                                        end
                                    elseif type(menu["resolver"].builder[sub_k]) == "number" then
                                        ui.set(menu["resolver"].builder[sub_k], sub_v)
                                    end
                                end
                            end
                        end
                    end
                    
                    
                    for k, v in pairs(config.visuals or {}) do
                        if menu["visuals"][k] and type(menu["visuals"][k]) == "number" then
                            ui.set(menu["visuals"][k], v)
                        end
                    end
                    
                    
                    for k, v in pairs(config.misc or {}) do
                        if menu["misc"][k] and type(menu["misc"][k]) == "number" then
                            ui.set(menu["misc"][k], v)
                        elseif type(v) == "table" then
                            for sub_k, sub_v in pairs(v) do
                                if menu["misc"][k] and menu["misc"][k][sub_k] and type(menu["misc"][k][sub_k]) == "number" then
                                    ui.set(menu["misc"][k][sub_k], sub_v)
                                end
                            end
                        end
                    end
                    
                    client.color_log(186, 85, 211, "[Insanity] Configuration imported from clipboard successfully")
                else
                    client.color_log(186, 85, 211, "[Insanity] Failed to decode Base64 configuration: " .. tostring(config))
                end
            else
                client.color_log(186, 85, 211, "[Insanity] No valid configuration found in clipboard successfully")
            end
        end)
    }
    
    menu["anti-aim"] = {
        mode = ui.new_combobox("aa", "anti-aimbot angles", "\aBA55D3FFmode", {"default", "better defensive", "jitter", "unpredictable", "random", "aa builder"}),
        builder = {
            state = ui.new_combobox("aa", "anti-aimbot angles", "\aBA55D3FFState", {"Standing", "Walking", "Crouch", "Air", "Crouch Moving", "Air Crouch"}),
            subgroup = ui.new_combobox("aa", "anti-aimbot angles", "\aBA55D3FFAA Builder Settings", {
                "Pitch", "Yaw", "Jitter", "Body Yaw", "Roll", "Conditions", "Defensive",
                "Flick", "Sway", "Adaptive", "Freestand", "Edge", "FakeLagSync", "VelocityWarp", "PeekReaction"
            }),
            spacer = ui.new_label("aa", "anti-aimbot angles", "⠀"),
            states = {
                ["Standing"] = {
                    pitch = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Enable Pitch"),
                        mode = ui.new_combobox("aa", "anti-aimbot angles", "[Standing] Pitch Mode", {"Off", "Default", "Down", "Up", "Minimal", "Custom", "Dynamic"}),
                        custom_value = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Custom Pitch", -89, 89, 0, true, "°"),
                        randomize = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Randomize Pitch"),
                        random_range = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Random Range", 0, 45, 10, true, "°"),
                        velocity_influence = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Velocity Influence", 0, 100, 20, true, "%")
                    },
                    yaw = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Enable Yaw"),
                        base = ui.new_combobox("aa", "anti-aimbot angles", "[Standing] Yaw Base", {"Local view", "At targets"}),
                        mode = ui.new_combobox("aa", "anti-aimbot angles", "[Standing] Yaw Mode", {"Static", "Cycle", "Dynamic"}),
                        static_value = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Static Yaw", -180, 180, 180, true, "°"),
                        frequency = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Dynamic Frequency", 10, 200, 50, true, "%"),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Dynamic Amplitude", 0, 180, 90, true, "°"),
                        jitter_influence = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Jitter Influence", 0, 100, 10, true, "%"),
                        velocity_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Velocity-Aware Base"),
                        velocity_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Velocity Threshold", 10, 300, 50, true, "u/s"),
                        dt_shift = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Double Tap Shift"),
                        dt_shift_amount = ui.new_slider("aa", "anti-aimbot angles", "[Standing] DT Shift Amount", -90, 90, 30, true, "°")
                    },
                    jitter = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Enable Jitter"),
                        type = ui.new_combobox("aa", "anti-aimbot angles", "[Standing] Jitter Type", {"Off", "Offset", "Center", "Random"}),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Jitter Amplitude", 0, 90, 30, true, "°"),
                        frequency = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Jitter Frequency", 10, 200, 50, true, "%"),
                        chaos_factor = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Chaos Factor", 0, 100, 15, true, "%"),
                        air_only = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Air Only"),
                        sync_with_tick = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Sync with Tick")
                    },
                    body_yaw = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Enable Body Yaw"),
                        mode = ui.new_combobox("aa", "anti-aimbot angles", "[Standing] Body Yaw Mode", {"Off", "Static", "Opposite", "Jitter", "Dynamic"}),
                        static_value = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Static Body Yaw", -180, 180, 0, true, "°"),
                        invert = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Invert Body Yaw"),
                        velocity_factor = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Velocity Factor", 0, 100, 25, true, "%"),
                        enemy_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Enemy-Aware Adjustment")
                    },
                    roll = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Enable Roll"),
                        amount = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Roll Amount", -50, 50, 0, true, "°"),
                        dynamic = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Dynamic Roll"),
                        dynamic_frequency = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Dynamic Frequency", 10, 200, 30, true, "%")
                    },
                    conditions = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Enable Conditions"),
                        air_adjust = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Adjust in Air"),
                        air_pitch = ui.new_combobox("aa", "anti-aimbot angles", "[Standing] Air Pitch", {"Off", "Default", "Down", "Minimal"}),
                        air_yaw_offset = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Air Yaw Offset", -180, 180, 0, true, "°"),
                        velocity_adjust = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Adjust on Velocity"),
                        velocity_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Velocity Threshold", 10, 300, 50, true, "u/s"),
                        velocity_yaw_shift = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Velocity Yaw Shift", -90, 90, 30, true, "°")
                    },
                    defensive = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing with Defensive"),
                        edge_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Edge Detection"),
                        edge_yaw_shift = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Edge Yaw Shift", -90, 90, 45, true, "°"),
                        fs_body = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Freestanding Body Yaw"),
                        random_shift = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Random Shift"),
                        random_shift_max = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Random Shift Max", 0, 90, 30, true, "°"),
                        dt_defense = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Double Tap Defense"),
                        dt_jitter = ui.new_slider("aa", "anti-aimbot angles", "[Standing] DT Jitter", 0, 60, 20, true, "°")
                    },
                    flick = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Enable Flick"),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Flick Amplitude", 10, 180, 60, true, "°"),
                        interval = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Flick Interval", 1, 20, 5, true, "ticks"),
                        random_offset = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Random Offset", 0, 90, 20, true, "°"),
                        condition = ui.new_combobox("aa", "anti-aimbot angles", "[Standing] Flick Condition", {"Always", "On Shot", "On Miss"})
                    },
                    sway = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Enable Sway"),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Sway Amplitude", 0, 60, 25, true, "°"),
                        speed = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Sway Speed", 1, 50, 10, true, "%"),
                        phase_shift = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Phase Shift", 0, 100, 0, true, "%"),
                        invert_on_edge = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Invert on Edge")
                    },
                    adaptive = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Enable Adaptive"),
                        miss_shift = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Shift on Miss", 0, 90, 30, true, "°"),
                        miss_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Miss Threshold", 1, 5, 2, true),
                        choke_shift = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Shift on Choke", 0, 90, 20, true, "°"),
                        choke_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Choke Threshold", 2, 14, 5, true),
                        velocity_factor = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Velocity Factor", 0, 100, 25, true, "%")
                    },
                    freestand = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Enable Freestand"),
                        yaw_offset = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Freestand Offset", -90, 90, 45, true, "°"),
                        detection_range = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Detection Range", 100, 2000, 1000, true, "u"),
                        invert_on_wall = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Invert on Wall"),
                        dynamic_adjust = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Dynamic Adjust")
                    },
                    edge = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Enable Edge"),
                        edge_yaw = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Edge Yaw", -180, 180, 90, true, "°"),
                        detection_dist = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Detection Distance", 50, 500, 200, true, "u"),
                        jitter_on_edge = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Jitter on Edge"),
                        edge_jitter_amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Edge Jitter Amplitude", 0, 60, 20, true, "°")
                    },
                    fakelagsync = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Enable Fake Lag Sync"),
                        choke_shift = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Choke Shift", 0, 90, 30, true, "°"),
                        choke_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Choke Threshold", 1, 14, 3, true),
                        lag_mode = ui.new_combobox("aa", "anti-aimbot angles", "[Standing] Lag Mode", {"Static", "Dynamic", "Random"}),
                        lag_factor = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Lag Factor", 0, 100, 50, true, "%")
                    },
                    velocitywarp = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Enable Velocity Warp"),
                        velocity_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Velocity Threshold", 10, 300, 50, true, "u/s"),
                        warp_factor = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Warp Factor", 0, 200, 50, true, "%"),
                        invert_on_stop = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Invert on Stop"),
                        wall_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Wall Aware")
                    },
                    peekreaction = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Standing] Enable Peek Reaction"),
                        peek_shift = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Peek Shift", 0, 180, 60, true, "°"),
                        detection_range = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Detection Range", 100, 2000, 500, true, "u"),
                        reaction_delay = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Reaction Delay", 0, 20, 2, true, "ticks"),
                        random_factor = ui.new_slider("aa", "anti-aimbot angles", "[Standing] Random Factor", 0, 100, 20, true, "%")
                    }
                },
                ["Walking"] = {
                    pitch = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Enable Pitch"),
                        mode = ui.new_combobox("aa", "anti-aimbot angles", "[Walking] Pitch Mode", {"Off", "Default", "Down", "Up", "Minimal", "Custom", "Dynamic"}),
                        custom_value = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Custom Pitch", -89, 89, 0, true, "°"),
                        randomize = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Randomize Pitch"),
                        random_range = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Random Range", 0, 45, 10, true, "°"),
                        velocity_influence = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Velocity Influence", 0, 100, 20, true, "%")
                    },
                    yaw = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Enable Yaw"),
                        base = ui.new_combobox("aa", "anti-aimbot angles", "[Walking] Yaw Base", {"Local view", "At targets"}),
                        mode = ui.new_combobox("aa", "anti-aimbot angles", "[Walking] Yaw Mode", {"Static", "Cycle", "Dynamic"}),
                        static_value = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Static Yaw", -180, 180, 180, true, "°"),
                        frequency = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Dynamic Frequency", 10, 200, 50, true, "%"),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Dynamic Amplitude", 0, 180, 90, true, "°"),
                        jitter_influence = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Jitter Influence", 0, 100, 10, true, "%"),
                        velocity_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Velocity-Aware Base"),
                        velocity_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Velocity Threshold", 10, 300, 50, true, "u/s"),
                        dt_shift = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Double Tap Shift"),
                        dt_shift_amount = ui.new_slider("aa", "anti-aimbot angles", "[Walking] DT Shift Amount", -90, 90, 30, true, "°")
                    },
                    jitter = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Enable Jitter"),
                        type = ui.new_combobox("aa", "anti-aimbot angles", "[Walking] Jitter Type", {"Off", "Offset", "Center", "Random"}),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Jitter Amplitude", 0, 90, 30, true, "°"),
                        frequency = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Jitter Frequency", 10, 200, 50, true, "%"),
                        chaos_factor = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Chaos Factor", 0, 100, 15, true, "%"),
                        air_only = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Air Only"),
                        sync_with_tick = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Sync with Tick")
                    },
                    body_yaw = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Enable Body Yaw"),
                        mode = ui.new_combobox("aa", "anti-aimbot angles", "[Walking] Body Yaw Mode", {"Off", "Static", "Opposite", "Jitter", "Dynamic"}),
                        static_value = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Static Body Yaw", -180, 180, 0, true, "°"),
                        invert = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Invert Body Yaw"),
                        velocity_factor = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Velocity Factor", 0, 100, 25, true, "%"),
                        enemy_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Enemy-Aware Adjustment")
                    },
                    roll = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Enable Roll"),
                        amount = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Roll Amount", -50, 50, 0, true, "°"),
                        dynamic = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Dynamic Roll"),
                        dynamic_frequency = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Dynamic Frequency", 10, 200, 30, true, "%")
                    },
                    conditions = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Enable Conditions"),
                        air_adjust = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Adjust in Air"),
                        air_pitch = ui.new_combobox("aa", "anti-aimbot angles", "[Walking] Air Pitch", {"Off", "Default", "Down", "Minimal"}),
                        air_yaw_offset = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Air Yaw Offset", -180, 180, 0, true, "°"),
                        velocity_adjust = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Adjust on Velocity"),
                        velocity_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Velocity Threshold", 10, 300, 50, true, "u/s"),
                        velocity_yaw_shift = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Velocity Yaw Shift", -90, 90, 30, true, "°")
                    },
                    defensive = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Enable Defensive"),
                        edge_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Edge Detection"),
                        edge_yaw_shift = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Edge Yaw Shift", -90, 90, 45, true, "°"),
                        fs_body = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Freestanding Body Yaw"),
                        random_shift = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Random Shift"),
                        random_shift_max = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Random Shift Max", 0, 90, 30, true, "°"),
                        dt_defense = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Double Tap Defense"),
                        dt_jitter = ui.new_slider("aa", "anti-aimbot angles", "[Walking] DT Jitter", 0, 60, 20, true, "°")
                    },
                    flick = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Enable Flick"),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Flick Amplitude", 10, 180, 60, true, "°"),
                        interval = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Flick Interval", 1, 20, 5, true, "ticks"),
                        random_offset = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Random Offset", 0, 90, 20, true, "°"),
                        condition = ui.new_combobox("aa", "anti-aimbot angles", "[Walking] Flick Condition", {"Always", "On Shot", "On Miss"})
                    },
                    sway = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Enable Sway"),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Sway Amplitude", 0, 60, 25, true, "°"),
                        speed = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Sway Speed", 1, 50, 10, true, "%"),
                        phase_shift = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Phase Shift", 0, 100, 0, true, "%"),
                        invert_on_edge = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Invert on Edge")
                    },
                    adaptive = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Enable Adaptive"),
                        miss_shift = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Shift on Miss", 0, 90, 30, true, "°"),
                        miss_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Miss Threshold", 1, 5, 2, true),
                        choke_shift = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Shift on Choke", 0, 90, 20, true, "°"),
                        choke_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Choke Threshold", 2, 14, 5, true),
                        velocity_factor = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Velocity Factor", 0, 100, 25, true, "%")
                    },
                    freestand = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Enable Freestand"),
                        yaw_offset = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Freestand Offset", -90, 90, 45, true, "°"),
                        detection_range = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Detection Range", 100, 2000, 1000, true, "u"),
                        invert_on_wall = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Invert on Wall"),
                        dynamic_adjust = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Dynamic Adjust")
                    },
                    edge = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Enable Edge"),
                        edge_yaw = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Edge Yaw", -180, 180, 90, true, "°"),
                        detection_dist = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Detection Distance", 50, 500, 200, true, "u"),
                        jitter_on_edge = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Jitter on Edge"),
                        edge_jitter_amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Edge Jitter Amplitude", 0, 60, 20, true, "°")
                    },
                    fakelagsync = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Enable Fake Lag Sync"),
                        choke_shift = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Choke Shift", 0, 90, 30, true, "°"),
                        choke_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Choke Threshold", 1, 14, 3, true),
                        lag_mode = ui.new_combobox("aa", "anti-aimbot angles", "[Walking] Lag Mode", {"Static", "Dynamic", "Random"}),
                        lag_factor = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Lag Factor", 0, 100, 50, true, "%")
                    },
                    velocitywarp = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Enable Velocity Warp"),
                        velocity_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Velocity Threshold", 10, 300, 50, true, "u/s"),
                        warp_factor = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Warp Factor", 0, 200, 50, true, "%"),
                        invert_on_stop = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Invert on Stop"),
                        wall_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Wall Aware")
                    },
                    peekreaction = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Walking] Enable Peek Reaction"),
                        peek_shift = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Peek Shift", 0, 180, 60, true, "°"),
                        detection_range = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Detection Range", 100, 2000, 500, true, "u"),
                        reaction_delay = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Reaction Delay", 0, 20, 2, true, "ticks"),
                        random_factor = ui.new_slider("aa", "anti-aimbot angles", "[Walking] Random Factor", 0, 100, 20, true, "%")
                    }
                },
                ["Crouch"] = {
                    pitch = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Enable Pitch"),
                        mode = ui.new_combobox("aa", "anti-aimbot angles", "[Crouch] Pitch Mode", {"Off", "Default", "Down", "Up", "Minimal", "Custom", "Dynamic"}),
                        custom_value = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Custom Pitch", -89, 89, 0, true, "°"),
                        randomize = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Randomize Pitch"),
                        random_range = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Random Range", 0, 45, 10, true, "°"),
                        velocity_influence = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Velocity Influence", 0, 100, 20, true, "%")
                    },
                    yaw = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Enable Yaw"),
                        base = ui.new_combobox("aa", "anti-aimbot angles", "[Crouch] Yaw Base", {"Local view", "At targets"}),
                        mode = ui.new_combobox("aa", "anti-aimbot angles", "[Crouch] Yaw Mode", {"Static", "Cycle", "Dynamic"}),
                        static_value = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Static Yaw", -180, 180, 180, true, "°"),
                        frequency = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Dynamic Frequency", 10, 200, 50, true, "%"),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Dynamic Amplitude", 0, 180, 90, true, "°"),
                        jitter_influence = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Jitter Influence", 0, 100, 10, true, "%"),
                        velocity_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Velocity-Aware Base"),
                        velocity_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Velocity Threshold", 10, 300, 50, true, "u/s"),
                        dt_shift = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Double Tap Shift"),
                        dt_shift_amount = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] DT Shift Amount", -90, 90, 30, true, "°")
                    },
                    jitter = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Enable Jitter"),
                        type = ui.new_combobox("aa", "anti-aimbot angles", "[Crouch] Jitter Type", {"Off", "Offset", "Center", "Random"}),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Jitter Amplitude", 0, 90, 30, true, "°"),
                        frequency = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Jitter Frequency", 10, 200, 50, true, "%"),
                        chaos_factor = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Chaos Factor", 0, 100, 15, true, "%"),
                        air_only = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Air Only"),
                        sync_with_tick = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Sync with Tick")
                    },
                    body_yaw = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Enable Body Yaw"),
                        mode = ui.new_combobox("aa", "anti-aimbot angles", "[Crouch] Body Yaw Mode", {"Off", "Static", "Opposite", "Jitter", "Dynamic"}),
                        static_value = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Static Body Yaw", -180, 180, 0, true, "°"),
                        invert = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Invert Body Yaw"),
                        velocity_factor = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Velocity Factor", 0, 100, 25, true, "%"),
                        enemy_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Enemy-Aware Adjustment")
                    },
                    roll = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Enable Roll"),
                        amount = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Roll Amount", -50, 50, 0, true, "°"),
                        dynamic = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Dynamic Roll"),
                        dynamic_frequency = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Dynamic Frequency", 10, 200, 30, true, "%")
                    },
                    conditions = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Enable Conditions"),
                        air_adjust = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Adjust in Air"),
                        air_pitch = ui.new_combobox("aa", "anti-aimbot angles", "[Crouch] Air Pitch", {"Off", "Default", "Down", "Minimal"}),
                        air_yaw_offset = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Air Yaw Offset", -180, 180, 0, true, "°"),
                        velocity_adjust = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Adjust on Velocity"),
                        velocity_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Velocity Threshold", 10, 300, 50, true, "u/s"),
                        velocity_yaw_shift = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Velocity Yaw Shift", -90, 90, 30, true, "°")
                    },
                    defensive = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Enable Defensive"),
                        edge_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Edge Detection"),
                        edge_yaw_shift = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Edge Yaw Shift", -90, 90, 45, true, "°"),
                        fs_body = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Freestanding Body Yaw"),
                        random_shift = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Random Shift"),
                        random_shift_max = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Random Shift Max", 0, 90, 30, true, "°"),
                        dt_defense = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Double Tap Defense"),
                        dt_jitter = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] DT Jitter", 0, 60, 20, true, "°")
                    },
                    flick = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Enable Flick"),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Flick Amplitude", 10, 180, 60, true, "°"),
                        interval = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Flick Interval", 1, 20, 5, true, "ticks"),
                        random_offset = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Random Offset", 0, 90, 20, true, "°"),
                        condition = ui.new_combobox("aa", "anti-aimbot angles", "[Crouch] Flick Condition", {"Always", "On Shot", "On Miss"})
                    },
                    sway = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Enable Sway"),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Sway Amplitude", 0, 60, 25, true, "°"),
                        speed = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Sway Speed", 1, 50, 10, true, "%"),
                        phase_shift = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Phase Shift", 0, 100, 0, true, "%"),
                        invert_on_edge = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Invert on Edge")
                    },
                    adaptive = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Enable Adaptive"),
                        miss_shift = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Shift on Miss", 0, 90, 30, true, "°"),
                        miss_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Miss Threshold", 1, 5, 2, true),
                        choke_shift = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Shift on Choke", 0, 90, 20, true, "°"),
                        choke_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Choke Threshold", 2, 14, 5, true),
                        velocity_factor = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Velocity Factor", 0, 100, 25, true, "%")
                    },
                    freestand = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Enable Freestand"),
                        yaw_offset = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Freestand Offset", -90, 90, 45, true, "°"),
                        detection_range = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Detection Range", 100, 2000, 1000, true, "u"),
                        invert_on_wall = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Invert on Wall"),
                        dynamic_adjust = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Dynamic Adjust")
                    },
                    edge = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Enable Edge"),
                        edge_yaw = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Edge Yaw", -180, 180, 90, true, "°"),
                        detection_dist = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Detection Distance", 50, 500, 200, true, "u"),
                        jitter_on_edge = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Jitter on Edge"),
                        edge_jitter_amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Edge Jitter Amplitude", 0, 60, 20, true, "°")
                    },
                    fakelagsync = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Enable Fake Lag Sync"),
                        choke_shift = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Choke Shift", 0, 90, 30, true, "°"),
                        choke_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Choke Threshold", 1, 14, 3, true),
                        lag_mode = ui.new_combobox("aa", "anti-aimbot angles", "[Crouch] Lag Mode", {"Static", "Dynamic", "Random"}),
                        lag_factor = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Lag Factor", 0, 100, 50, true, "%")
                    },
                    velocitywarp = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Enable Velocity Warp"),
                        velocity_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Velocity Threshold", 10, 300, 50, true, "u/s"),
                        warp_factor = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Warp Factor", 0, 200, 50, true, "%"),
                        invert_on_stop = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Invert on Stop"),
                        wall_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Wall Aware")
                    },
                    peekreaction = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch] Enable Peek Reaction"),
                        peek_shift = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Peek Shift", 0, 180, 60, true, "°"),
                        detection_range = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Detection Range", 100, 2000, 500, true, "u"),
                        reaction_delay = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Reaction Delay", 0, 20, 2, true, "ticks"),
                        random_factor = ui.new_slider("aa", "anti-aimbot angles", "[Crouch] Random Factor", 0, 100, 20, true, "%")
                    }
                },
                ["Air"] = {
                    pitch = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Enable Pitch"),
                        mode = ui.new_combobox("aa", "anti-aimbot angles", "[Air] Pitch Mode", {"Off", "Default", "Down", "Up", "Minimal", "Custom", "Dynamic"}),
                        custom_value = ui.new_slider("aa", "anti-aimbot angles", "[Air] Custom Pitch", -89, 89, 0, true, "°"),
                        randomize = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Randomize Pitch"),
                        random_range = ui.new_slider("aa", "anti-aimbot angles", "[Air] Random Range", 0, 45, 10, true, "°"),
                        velocity_influence = ui.new_slider("aa", "anti-aimbot angles", "[Air] Velocity Influence", 0, 100, 20, true, "%")
                    },
                    yaw = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Enable Yaw"),
                        base = ui.new_combobox("aa", "anti-aimbot angles", "[Air] Yaw Base", {"Local view", "At targets"}),
                        mode = ui.new_combobox("aa", "anti-aimbot angles", "[Air] Yaw Mode", {"Static", "Cycle", "Dynamic"}),
                        static_value = ui.new_slider("aa", "anti-aimbot angles", "[Air] Static Yaw", -180, 180, 180, true, "°"),
                        frequency = ui.new_slider("aa", "anti-aimbot angles", "[Air] Dynamic Frequency", 10, 200, 50, true, "%"),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Air] Dynamic Amplitude", 0, 180, 90, true, "°"),
                        jitter_influence = ui.new_slider("aa", "anti-aimbot angles", "[Air] Jitter Influence", 0, 100, 10, true, "%"),
                        velocity_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Velocity-Aware Base"),
                        velocity_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Air] Velocity Threshold", 10, 300, 50, true, "u/s"),
                        dt_shift = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Double Tap Shift"),
                        dt_shift_amount = ui.new_slider("aa", "anti-aimbot angles", "[Air] DT Shift Amount", -90, 90, 30, true, "°")
                    },
                    jitter = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Enable Jitter"),
                        type = ui.new_combobox("aa", "anti-aimbot angles", "[Air] Jitter Type", {"Off", "Offset", "Center", "Random"}),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Air] Jitter Amplitude", 0, 90, 30, true, "°"),
                        frequency = ui.new_slider("aa", "anti-aimbot angles", "[Air] Jitter Frequency", 10, 200, 50, true, "%"),
                        chaos_factor = ui.new_slider("aa", "anti-aimbot angles", "[Air] Chaos Factor", 0, 100, 15, true, "%"),
                        air_only = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Air Only"),
                        sync_with_tick = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Sync with Tick")
                    },
                    body_yaw = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Enable Body Yaw"),
                        mode = ui.new_combobox("aa", "anti-aimbot angles", "[Air] Body Yaw Mode", {"Off", "Static", "Opposite", "Jitter", "Dynamic"}),
                        static_value = ui.new_slider("aa", "anti-aimbot angles", "[Air] Static Body Yaw", -180, 180, 0, true, "°"),
                        invert = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Invert Body Yaw"),
                        velocity_factor = ui.new_slider("aa", "anti-aimbot angles", "[Air] Velocity Factor", 0, 100, 25, true, "%"),
                        enemy_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Enemy-Aware Adjustment")
                    },
                    roll = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Enable Roll"),
                        amount = ui.new_slider("aa", "anti-aimbot angles", "[Air] Roll Amount", -50, 50, 0, true, "°"),
                        dynamic = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Dynamic Roll"),
                        dynamic_frequency = ui.new_slider("aa", "anti-aimbot angles", "[Air] Dynamic Frequency", 10, 200, 30, true, "%")
                    },
                    conditions = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Enable Conditions"),
                        air_adjust = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Adjust in Air"),
                        air_pitch = ui.new_combobox("aa", "anti-aimbot angles", "[Air] Air Pitch", {"Off", "Default", "Down", "Minimal"}),
                        air_yaw_offset = ui.new_slider("aa", "anti-aimbot angles", "[Air] Air Yaw Offset", -180, 180, 0, true, "°"),
                        velocity_adjust = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Adjust on Velocity"),
                        velocity_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Air] Velocity Threshold", 10, 300, 50, true, "u/s"),
                        velocity_yaw_shift = ui.new_slider("aa", "anti-aimbot angles", "[Air] Velocity Yaw Shift", -90, 90, 30, true, "°")
                    },
                    defensive = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Enable Defensive"),
                        edge_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Edge Detection"),
                        edge_yaw_shift = ui.new_slider("aa", "anti-aimbot angles", "[Air] Edge Yaw Shift", -90, 90, 45, true, "°"),
                        fs_body = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Freestanding Body Yaw"),
                        random_shift = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Random Shift"),
                        random_shift_max = ui.new_slider("aa", "anti-aimbot angles", "[Air] Random Shift Max", 0, 90, 30, true, "°"),
                        dt_defense = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Double Tap Defense"),
                        dt_jitter = ui.new_slider("aa", "anti-aimbot angles", "[Air] DT Jitter", 0, 60, 20, true, "°")
                    },
                    flick = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Enable Flick"),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Air] Flick Amplitude", 10, 180, 60, true, "°"),
                        interval = ui.new_slider("aa", "anti-aimbot angles", "[Air] Flick Interval", 1, 20, 5, true, "ticks"),
                        random_offset = ui.new_slider("aa", "anti-aimbot angles", "[Air] Random Offset", 0, 90, 20, true, "°"),
                        condition = ui.new_combobox("aa", "anti-aimbot angles", "[Air] Flick Condition", {"Always", "On Shot", "On Miss"})
                    },
                    sway = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Enable Sway"),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Air] Sway Amplitude", 0, 60, 25, true, "°"),
                        speed = ui.new_slider("aa", "anti-aimbot angles", "[Air] Sway Speed", 1, 50, 10, true, "%"),
                        phase_shift = ui.new_slider("aa", "anti-aimbot angles", "[Air] Phase Shift", 0, 100, 0, true, "%"),
                        invert_on_edge = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Invert on Edge")
                    },
                    adaptive = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Enable Adaptive"),
                        miss_shift = ui.new_slider("aa", "anti-aimbot angles", "[Air] Shift on Miss", 0, 90, 30, true, "°"),
                        miss_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Air] Miss Threshold", 1, 5, 2, true),
                        choke_shift = ui.new_slider("aa", "anti-aimbot angles", "[Air] Shift on Choke", 0, 90, 20, true, "°"),
                        choke_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Air] Choke Threshold", 2, 14, 5, true),
                        velocity_factor = ui.new_slider("aa", "anti-aimbot angles", "[Air] Velocity Factor", 0, 100, 25, true, "%")
                    },
                    freestand = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Enable Freestand"),
                        yaw_offset = ui.new_slider("aa", "anti-aimbot angles", "[Air] Freestand Offset", -90, 90, 45, true, "°"),
                        detection_range = ui.new_slider("aa", "anti-aimbot angles", "[Air] Detection Range", 100, 2000, 1000, true, "u"),
                        invert_on_wall = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Invert on Wall"),
                        dynamic_adjust = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Dynamic Adjust")
                    },
                    edge = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Enable Edge"),
                        edge_yaw = ui.new_slider("aa", "anti-aimbot angles", "[Air] Edge Yaw", -180, 180, 90, true, "°"),
                        detection_dist = ui.new_slider("aa", "anti-aimbot angles", "[Air] Detection Distance", 50, 500, 200, true, "u"),
                        jitter_on_edge = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Jitter on Edge"),
                        edge_jitter_amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Air] Edge Jitter Amplitude", 0, 60, 20, true, "°")
                    },
                    fakelagsync = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Enable Fake Lag Sync"),
                        choke_shift = ui.new_slider("aa", "anti-aimbot angles", "[Air] Choke Shift", 0, 90, 30, true, "°"),
                        choke_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Air] Choke Threshold", 1, 14, 3, true),
                        lag_mode = ui.new_combobox("aa", "anti-aimbot angles", "[Air] Lag Mode", {"Static", "Dynamic", "Random"}),
                        lag_factor = ui.new_slider("aa", "anti-aimbot angles", "[Air] Lag Factor", 0, 100, 50, true, "%")
                    },
                    velocitywarp = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Enable Velocity Warp"),
                        velocity_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Air] Velocity Threshold", 10, 300, 50, true, "u/s"),
                        warp_factor = ui.new_slider("aa", "anti-aimbot angles", "[Air] Warp Factor", 0, 200, 50, true, "%"),
                        invert_on_stop = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Invert on Stop"),
                        wall_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Wall Aware")
                    },
                    peekreaction = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air] Enable Peek Reaction"),
                        peek_shift = ui.new_slider("aa", "anti-aimbot angles", "[Air] Peek Shift", 0, 180, 60, true, "°"),
                        detection_range = ui.new_slider("aa", "anti-aimbot angles", "[Air] Detection Range", 100, 2000, 500, true, "u"),
                        reaction_delay = ui.new_slider("aa", "anti-aimbot angles", "[Air] Reaction Delay", 0, 20, 2, true, "ticks"),
                        random_factor = ui.new_slider("aa", "anti-aimbot angles", "[Air] Random Factor", 0, 100, 20, true, "%")
                    }
                },
                ["Crouch Moving"] = {
                    pitch = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Enable Pitch"),
                        mode = ui.new_combobox("aa", "anti-aimbot angles", "[Crouch Moving] Pitch Mode", {"Off", "Default", "Down", "Up", "Minimal", "Custom", "Dynamic"}),
                        custom_value = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Custom Pitch", -89, 89, 0, true, "°"),
                        randomize = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Randomize Pitch"),
                        random_range = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Random Range", 0, 45, 10, true, "°"),
                        velocity_influence = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Velocity Influence", 0, 100, 20, true, "%")
                    },
                    yaw = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Enable Yaw"),
                        base = ui.new_combobox("aa", "anti-aimbot angles", "[Crouch Moving] Yaw Base", {"Local view", "At targets"}),
                        mode = ui.new_combobox("aa", "anti-aimbot angles", "[Crouch Moving] Yaw Mode", {"Static", "Cycle", "Dynamic"}),
                        static_value = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Static Yaw", -180, 180, 180, true, "°"),
                        frequency = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Dynamic Frequency", 10, 200, 50, true, "%"),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Dynamic Amplitude", 0, 180, 90, true, "°"),
                        jitter_influence = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Jitter Influence", 0, 100, 10, true, "%"),
                        velocity_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Velocity-Aware Base"),
                        velocity_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Velocity Threshold", 10, 300, 50, true, "u/s"),
                        dt_shift = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Double Tap Shift"),
                        dt_shift_amount = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] DT Shift Amount", -90, 90, 30, true, "°")
                    },
                    jitter = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Enable Jitter"),
                        type = ui.new_combobox("aa", "anti-aimbot angles", "[Crouch Moving] Jitter Type", {"Off", "Offset", "Center", "Random"}),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Jitter Amplitude", 0, 90, 30, true, "°"),
                        frequency = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Jitter Frequency", 10, 200, 50, true, "%"),
                        chaos_factor = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Chaos Factor", 0, 100, 15, true, "%"),
                        air_only = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Air Only"),
                        sync_with_tick = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Sync with Tick")
                    },
                    body_yaw = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Enable Body Yaw"),
                        mode = ui.new_combobox("aa", "anti-aimbot angles", "[Crouch Moving] Body Yaw Mode", {"Off", "Static", "Opposite", "Jitter", "Dynamic"}),
                        static_value = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Static Body Yaw", -180, 180, 0, true, "°"),
                        invert = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Invert Body Yaw"),
                        velocity_factor = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Velocity Factor", 0, 100, 25, true, "%"),
                        enemy_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Enemy-Aware Adjustment")
                    },
                    roll = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Enable Roll"),
                        amount = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Roll Amount", -50, 50, 0, true, "°"),
                        dynamic = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Dynamic Roll"),
                        dynamic_frequency = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Dynamic Frequency", 10, 200, 30, true, "%")
                    },
                    conditions = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Enable Conditions"),
                        air_adjust = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Adjust in Air"),
                        air_pitch = ui.new_combobox("aa", "anti-aimbot angles", "[Crouch Moving] Air Pitch", {"Off", "Default", "Down", "Minimal"}),
                        air_yaw_offset = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Air Yaw Offset", -180, 180, 0, true, "°"),
                        velocity_adjust = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Adjust on Velocity"),
                        velocity_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Velocity Threshold", 10, 300, 50, true, "u/s"),
                        velocity_yaw_shift = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Velocity Yaw Shift", -90, 90, 30, true, "°")
                    },
                    defensive = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Enable Defensive"),
                        edge_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Edge Detection"),
                        edge_yaw_shift = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Edge Yaw Shift", -90, 90, 45, true, "°"),
                        fs_body = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Freestanding Body Yaw"),
                        random_shift = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Random Shift"),
                        random_shift_max = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Random Shift Max", 0, 90, 30, true, "°"),
                        dt_defense = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Double Tap Defense"),
                        dt_jitter = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] DT Jitter", 0, 60, 20, true, "°")
                    },
                    flick = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Enable Flick"),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Flick Amplitude", 10, 180, 60, true, "°"),
                        interval = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Flick Interval", 1, 20, 5, true, "ticks"),
                        random_offset = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Random Offset", 0, 90, 20, true, "°"),
                        condition = ui.new_combobox("aa", "anti-aimbot angles", "[Crouch Moving] Flick Condition", {"Always", "On Shot", "On Miss"})
                    },
                    sway = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Enable Sway"),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Sway Amplitude", 0, 60, 25, true, "°"),
                        speed = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Sway Speed", 1, 50, 10, true, "%"),
                        phase_shift = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Phase Shift", 0, 100, 0, true, "%"),
                        invert_on_edge = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Invert on Edge")
                    },
                    adaptive = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Enable Adaptive"),
                        miss_shift = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Shift on Miss", 0, 90, 30, true, "°"),
                        miss_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Miss Threshold", 1, 5, 2, true),
                        choke_shift = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Shift on Choke", 0, 90, 20, true, "°"),
                        choke_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Choke Threshold", 2, 14, 5, true),
                        velocity_factor = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Velocity Factor", 0, 100, 25, true, "%")
                    },
                    freestand = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Enable Freestand"),
                        yaw_offset = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Freestand Offset", -90, 90, 45, true, "°"),
                        detection_range = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Detection Range", 100, 2000, 1000, true, "u"),
                        invert_on_wall = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Invert on Wall"),
                        dynamic_adjust = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Dynamic Adjust")
                    },
                    edge = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Enable Edge"),
                        edge_yaw = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Edge Yaw", -180, 180, 90, true, "°"),
                        detection_dist = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Detection Distance", 50, 500, 200, true, "u"),
                        jitter_on_edge = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Jitter on Edge"),
                        edge_jitter_amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Edge Jitter Amplitude", 0, 60, 20, true, "°")
                    },
                    fakelagsync = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Enable Fake Lag Sync"),
                        choke_shift = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Choke Shift", 0, 90, 30, true, "°"),
                        choke_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Choke Threshold", 1, 14, 3, true),
                        lag_mode = ui.new_combobox("aa", "anti-aimbot angles", "[Crouch Moving] Lag Mode", {"Static", "Dynamic", "Random"}),
                        lag_factor = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Lag Factor", 0, 100, 50, true, "%")
                    },
                    velocitywarp = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Enable Velocity Warp"),
                        velocity_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Velocity Threshold", 10, 300, 50, true, "u/s"),
                        warp_factor = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Warp Factor", 0, 200, 50, true, "%"),
                        invert_on_stop = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Invert on Stop"),
                        wall_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Wall Aware")
                    },
                    peekreaction = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Crouch Moving] Enable Peek Reaction"),
                        peek_shift = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Peek Shift", 0, 180, 60, true, "°"),
                        detection_range = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Detection Range", 100, 2000, 500, true, "u"),
                        reaction_delay = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Reaction Delay", 0, 20, 2, true, "ticks"),
                        random_factor = ui.new_slider("aa", "anti-aimbot angles", "[Crouch Moving] Random Factor", 0, 100, 20, true, "%")
                    }
                },
                ["Air Crouch"] = {
                    pitch = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Enable Pitch"),
                        mode = ui.new_combobox("aa", "anti-aimbot angles", "[Air Crouch] Pitch Mode", {"Off", "Default", "Down", "Up", "Minimal", "Custom", "Dynamic"}),
                        custom_value = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Custom Pitch", -89, 89, 0, true, "°"),
                        randomize = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Randomize Pitch"),
                        random_range = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Random Range", 0, 45, 10, true, "°"),
                        velocity_influence = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Velocity Influence", 0, 100, 20, true, "%")
                    },
                    yaw = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Enable Yaw"),
                        base = ui.new_combobox("aa", "anti-aimbot angles", "[Air Crouch] Yaw Base", {"Local view", "At targets"}),
                        mode = ui.new_combobox("aa", "anti-aimbot angles", "[Air Crouch] Yaw Mode", {"Static", "Cycle", "Dynamic"}),
                        static_value = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Static Yaw", -180, 180, 180, true, "°"),
                        frequency = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Dynamic Frequency", 10, 200, 50, true, "%"),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Dynamic Amplitude", 0, 180, 90, true, "°"),
                        jitter_influence = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Jitter Influence", 0, 100, 10, true, "%"),
                        velocity_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Velocity-Aware Base"),
                        velocity_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Velocity Threshold", 10, 300, 50, true, "u/s"),
                        dt_shift = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Double Tap Shift"),
                        dt_shift_amount = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] DT Shift Amount", -90, 90, 30, true, "°")
                    },
                    jitter = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Enable Jitter"),
                        type = ui.new_combobox("aa", "anti-aimbot angles", "[Air Crouch] Jitter Type", {"Off", "Offset", "Center", "Random"}),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Jitter Amplitude", 0, 90, 30, true, "°"),
                        frequency = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Jitter Frequency", 10, 200, 50, true, "%"),
                        chaos_factor = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Chaos Factor", 0, 100, 15, true, "%"),
                        air_only = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Air Only"),
                        sync_with_tick = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Sync with Tick")
                    },
                    body_yaw = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Enable Body Yaw"),
                        mode = ui.new_combobox("aa", "anti-aimbot angles", "[Air Crouch] Body Yaw Mode", {"Off", "Static", "Opposite", "Jitter", "Dynamic"}),
                        static_value = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Static Body Yaw", -180, 180, 0, true, "°"),
                        invert = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Invert Body Yaw"),
                        velocity_factor = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Velocity Factor", 0, 100, 25, true, "%"),
                        enemy_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Enemy-Aware Adjustment")
                    },
                    roll = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Enable Roll"),
                        amount = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Roll Amount", -50, 50, 0, true, "°"),
                        dynamic = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Dynamic Roll"),
                        dynamic_frequency = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Dynamic Frequency", 10, 200, 30, true, "%")
                    },
                    conditions = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Enable Conditions"),
                        air_adjust = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Adjust in Air"),
                        air_pitch = ui.new_combobox("aa", "anti-aimbot angles", "[Air Crouch] Air Pitch", {"Off", "Default", "Down", "Minimal"}),
                        air_yaw_offset = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Air Yaw Offset", -180, 180, 0, true, "°"),
                        velocity_adjust = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Adjust on Velocity"),
                        velocity_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Velocity Threshold", 10, 300, 50, true, "u/s"),
                        velocity_yaw_shift = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Velocity Yaw Shift", -90, 90, 30, true, "°")
                    },
                    defensive = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Enable Defensive"),
                        edge_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Edge Detection"),
                        edge_yaw_shift = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Edge Yaw Shift", -90, 90, 45, true, "°"),
                        fs_body = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Freestanding Body Yaw"),
                        random_shift = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Random Shift"),
                        random_shift_max = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Random Shift Max", 0, 90, 30, true, "°"),
                        dt_defense = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Double Tap Defense"),
                        dt_jitter = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] DT Jitter", 0, 60, 20, true, "°")
                    },
                    flick = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Enable Flick"),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Flick Amplitude", 10, 180, 60, true, "°"),
                        interval = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Flick Interval", 1, 20, 5, true, "ticks"),
                        random_offset = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Random Offset", 0, 90, 20, true, "°"),
                        condition = ui.new_combobox("aa", "anti-aimbot angles", "[Air Crouch] Flick Condition", {"Always", "On Shot", "On Miss"})
                    },
                    sway = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Enable Sway"),
                        amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Sway Amplitude", 0, 60, 25, true, "°"),
                        speed = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Sway Speed", 1, 50, 10, true, "%"),
                        phase_shift = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Phase Shift", 0, 100, 0, true, "%"),
                        invert_on_edge = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Invert on Edge")
                    },
                    adaptive = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Enable Adaptive"),
                        miss_shift = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Shift on Miss", 0, 90, 30, true, "°"),
                        miss_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Miss Threshold", 1, 5, 2, true),
                        choke_shift = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Shift on Choke", 0, 90, 20, true, "°"),
                        choke_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Choke Threshold", 2, 14, 5, true),
                        velocity_factor = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Velocity Factor", 0, 100, 25, true, "%")
                    },
                    freestand = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Enable Freestand"),
                        yaw_offset = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Freestand Offset", -90, 90, 45, true, "°"),
                        detection_range = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Detection Range", 100, 2000, 1000, true, "u"),
                        invert_on_wall = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Invert on Wall"),
                        dynamic_adjust = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Dynamic Adjust")
                    },
                    edge = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Enable Edge"),
                        edge_yaw = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Edge Yaw", -180, 180, 90, true, "°"),
                        detection_dist = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Detection Distance", 50, 500, 200, true, "u"),
                        jitter_on_edge = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Jitter on Edge"),
                        edge_jitter_amplitude = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Edge Jitter Amplitude", 0, 60, 20, true, "°")
                    },
                    fakelagsync = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Enable Fake Lag Sync"),
                        choke_shift = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Choke Shift", 0, 90, 30, true, "°"),
                        choke_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Choke Threshold", 1, 14, 3, true),
                        lag_mode = ui.new_combobox("aa", "anti-aimbot angles", "[Air Crouch] Lag Mode", {"Static", "Dynamic", "Random"}),
                        lag_factor = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Lag Factor", 0, 100, 50, true, "%")
                    },
                    velocitywarp = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Enable Velocity Warp"),
                        velocity_threshold = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Velocity Threshold", 10, 300, 50, true, "u/s"),
                        warp_factor = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Warp Factor", 0, 200, 50, true, "%"),
                        invert_on_stop = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Invert on Stop"),
                        wall_aware = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Wall Aware")
                    },
                    peekreaction = {
                        enabled = ui.new_checkbox("aa", "anti-aimbot angles", "[Air Crouch] Enable Peek Reaction"),
                        peek_shift = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Peek Shift", 0, 180, 60, true, "°"),
                        detection_range = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Detection Range", 100, 2000, 500, true, "u"),
                        reaction_delay = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Reaction Delay", 0, 20, 2, true, "ticks"),
                        random_factor = ui.new_slider("aa", "anti-aimbot angles", "[Air Crouch] Random Factor", 0, 100, 20, true, "%")
                    }
                }
            }
        }
    }
    
    menu["resolver"] = {
        preset = ui.new_combobox("aa", "anti-aimbot angles", "\aBA55D3FFpreset", {"default", "bruteforce", "logic", "smart", "extra", "resolver builder"}),
        builder = {
            subgroup = ui.new_combobox("aa", "anti-aimbot angles", "\aBA55D3FFBuilder Settings", {
                "Velocity", "Animations", "History", "Miss", "Jitter", "Defensive", "Hitbox", "DT", 
                "Distance", "Weapon⠀Awareness", "Prediction", "Latency⠀Compensation", "Override"
            }),
            spacer = ui.new_label("aa", "anti-aimbot angles", "⠀"),
            
            
            velocity = {
                enabled = ui.new_checkbox("aa", "anti-aimbot angles", "Enable Velocity Adjustment"),
                factor = ui.new_slider("aa", "anti-aimbot angles", "Velocity Factor", 0, 100, 50, true, "%"),
                threshold = ui.new_slider("aa", "anti-aimbot angles", "Velocity Threshold", 10, 300, 30, true, "u/s"),
                invert = ui.new_checkbox("aa", "anti-aimbot angles", "Invert Direction"),
                wall_aware = ui.new_checkbox("aa", "anti-aimbot angles", "Wall-Aware Adjustment"),
                max_adjustment = ui.new_slider("aa", "anti-aimbot angles", "Max Adjustment", 10, 90, 60, true, "°"),
                spike_factor = ui.new_slider("aa", "anti-aimbot angles", "Spike Factor", 0, 100, 20, true, "%")
            },
    
            
            animations = {
                enabled = ui.new_checkbox("aa", "anti-aimbot angles", "Enable Animation Adjustment"),
                mode = ui.new_combobox("aa", "anti-aimbot angles", "Animation Mode", {"Static", "Dynamic", "Mixed"}),
                influence = ui.new_slider("aa", "anti-aimbot angles", "Animation Influence", 0, 100, 40, true, "%"),
                threshold = ui.new_slider("aa", "anti-aimbot angles", "Animation Threshold", 5, 60, 15, true, "°"),
                lby_influence = ui.new_slider("aa", "anti-aimbot angles", "LBY Influence", 0, 100, 30, true, "%"),
                choke_influence = ui.new_slider("aa", "anti-aimbot angles", "Choked Ticks Influence", 0, 100, 20, true, "%"),
                smoothing = ui.new_slider("aa", "anti-aimbot angles", "Smoothing Factor", 0, 100, 30, true, "%"),
                boost_factor = ui.new_slider("aa", "anti-aimbot angles", "Boost Factor", 0, 100, 15, true, "%")
            },
    
            
            history = {
                enabled = ui.new_checkbox("aa", "anti-aimbot angles", "Enable History Adjustment"),
                mode = ui.new_combobox("aa", "anti-aimbot angles", "History Mode", {"Average", "Delta", "Pattern"}),
                depth = ui.new_slider("aa", "anti-aimbot angles", "History Depth", 3, 20, 10, true, "ticks"),
                stability_threshold = ui.new_slider("aa", "anti-aimbot angles", "Stability Threshold", 5, 60, 15, true, "°"),
                invert = ui.new_checkbox("aa", "anti-aimbot angles", "Invert Adjustment"),
                weight_factor = ui.new_slider("aa", "anti-aimbot angles", "Weight Factor", 0, 100, 80, true, "%"),
                jitter_influence = ui.new_slider("aa", "anti-aimbot angles", "Jitter Influence", 0, 100, 10, true, "%")
            },
    
            
            miss = {
                enabled = ui.new_checkbox("aa", "anti-aimbot angles", "Enable Miss Adjustment"),
                mode = ui.new_combobox("aa", "anti-aimbot angles", "Miss Mode", {"Shift", "Random", "Cycle"}),
                amplitude = ui.new_slider("aa", "anti-aimbot angles", "Miss Amplitude", 10, 90, 50, true, "°"),
                after_misses = ui.new_slider("aa", "anti-aimbot angles", "After Misses", 1, 5, 1, true),
                invert = ui.new_checkbox("aa", "anti-aimbot angles", "Invert Miss Adjustment"),
                reset_threshold = ui.new_slider("aa", "anti-aimbot angles", "Reset Threshold", 0, 10, 0, true, "misses"),
                scale_factor = ui.new_slider("aa", "anti-aimbot angles", "Scale Factor", 0, 100, 20, true, "%")
            },
    
            
            jitter = {
                enabled = ui.new_checkbox("aa", "anti-aimbot angles", "Enable Jitter Adjustment"),
                type = ui.new_combobox("aa", "anti-aimbot angles", "Jitter Type", {"Sine", "Cosine", "Random"}),
                frequency = ui.new_slider("aa", "anti-aimbot angles", "Jitter Frequency", 10, 200, 50, true, "%"),
                amplitude = ui.new_slider("aa", "anti-aimbot angles", "Jitter Amplitude", 0, 60, 25, true, "°"),
                chaos_factor = ui.new_slider("aa", "anti-aimbot angles", "Jitter Chaos", 0, 100, 15, true, "%"),
                sync_with_tick = ui.new_checkbox("aa", "anti-aimbot angles", "Sync with Tick"),
                phase_shift = ui.new_slider("aa", "anti-aimbot angles", "Phase Shift", 0, 100, 0, true, "%")
            },
    
            
            defensive = {
                enabled = ui.new_checkbox("aa", "anti-aimbot angles", "Enable Defensive Adjustment"),
                anti_bruteforce = ui.new_checkbox("aa", "anti-aimbot angles", "Anti-Bruteforce"),
                anti_bruteforce_misses = ui.new_slider("aa", "anti-aimbot angles", "Anti-Bruteforce Misses", 1, 5, 2, true),
                random_shift = ui.new_checkbox("aa", "anti-aimbot angles", "Random Shift"),
                random_shift_max = ui.new_slider("aa", "anti-aimbot angles", "Random Shift Max", 10, 90, 50, true, "°"),
                jitter_amplitude = ui.new_slider("aa", "anti-aimbot angles", "Defensive Jitter", 0, 60, 0, true, "°"),
                adaptive_defense = ui.new_checkbox("aa", "anti-aimbot angles", "Adaptive Defense"),
                adaptive_threshold = ui.new_slider("aa", "anti-aimbot angles", "Adaptive Stability Threshold", 5, 60, 20, true, "°"),
                ping_mode = ui.new_combobox("aa", "anti-aimbot angles", "Ping Defense", {"Off", "Low", "High"}),
                edge_detection = ui.new_checkbox("aa", "anti-aimbot angles", "Edge Detection"),
                choke_factor = ui.new_slider("aa", "anti-aimbot angles", "Choke Defense Factor", 0, 100, 25, true, "%")
            },
    
            
            hitbox = {
                enabled = ui.new_checkbox("aa", "anti-aimbot angles", "Enable Hitbox Adjustment"),
                mode = ui.new_combobox("aa", "anti-aimbot angles", "Hitbox Mode", {"Static", "Cycle", "Adaptive"}),
                static_hitbox = ui.new_combobox("aa", "anti-aimbot angles", "Static Hitbox", {"Head", "Chest", "Pelvis"}),
                switch_speed = ui.new_slider("aa", "anti-aimbot angles", "Switch Speed", 5, 50, 20, true, "ticks"),
                on_miss = ui.new_checkbox("aa", "anti-aimbot angles", "Switch on Miss (Adaptive)"),
                miss_count = ui.new_slider("aa", "anti-aimbot angles", "Miss Count for Switch", 1, 5, 2, true),
                randomize = ui.new_checkbox("aa", "anti-aimbot angles", "Randomize Hitbox"),
                priority_factor = ui.new_slider("aa", "anti-aimbot angles", "Priority Factor", 0, 100, 50, true, "%")
            },
    
            
            ["dt"] = {
                enabled = ui.new_checkbox("aa", "anti-aimbot angles", "Enable Double Tap Adjustments"),
                mode = ui.new_combobox("aa", "anti-aimbot angles", "DT Mode", {"Static", "Dynamic", "Random"}),
                shift_amount = ui.new_slider("aa", "anti-aimbot angles", "Shift Amount", 0, 90, 30, true, "°"),
                velocity_boost = ui.new_slider("aa", "anti-aimbot angles", "Velocity Boost", 0, 100, 20, true, "%"),
                choke_adjust = ui.new_slider("aa", "anti-aimbot angles", "Choke Adjustment", 0, 100, 15, true, "%")
            },
    
            
            distance = {
                enabled = ui.new_checkbox("aa", "anti-aimbot angles", "Enable Distance Adjustment"),
                min_dist = ui.new_slider("aa", "anti-aimbot angles", "Min Distance", 50, 1000, 200, true, "u", 1),
                max_dist = ui.new_slider("aa", "anti-aimbot angles", "Max Distance", 50, 2000, 1500, true, "u", 1),
                dist_factor = ui.new_slider("aa", "anti-aimbot angles", "Distance Factor", 0, 100, 30, true, "%"),
                close_shift = ui.new_slider("aa", "anti-aimbot angles", "Close Range Shift", -90, 90, 45, true, "°"),
                far_shift = ui.new_slider("aa", "anti-aimbot angles", "Far Range Shift", -90, 90, 15, true, "°")
            },
    
            
            ["weapon⠀awareness"] = {
                enabled = ui.new_checkbox("aa", "anti-aimbot angles", "Enable Weapon Awareness"),
                sniper_adjust = ui.new_slider("aa", "anti-aimbot angles", "Sniper Adjustment", -60, 60, 30, true, "°"),
                pistol_adjust = ui.new_slider("aa", "anti-aimbot angles", "Pistol Adjustment", -60, 60, 15, true, "°"),
                rifle_adjust = ui.new_slider("aa", "anti-aimbot angles", "Rifle Adjustment", -60, 60, 20, true, "°"),
                dynamic_switch = ui.new_checkbox("aa", "anti-aimbot angles", "Dynamic Weapon Switch"),
                switch_speed = ui.new_slider("aa", "anti-aimbot angles", "Switch Speed", 1, 20, 5, true, "ticks")
            },
    
            
            prediction = {
                enabled = ui.new_checkbox("aa", "anti-aimbot angles", "Enable Prediction"),
                ticks = ui.new_slider("aa", "anti-aimbot angles", "Prediction Ticks", 1, 12, 6, true, "ticks"),
                accel_factor = ui.new_slider("aa", "anti-aimbot angles", "Acceleration Factor", 0, 100, 25, true, "%"),
                yaw_boost = ui.new_slider("aa", "anti-aimbot angles", "Yaw Boost", -60, 60, 0, true, "°"),
                velocity_scale = ui.new_slider("aa", "anti-aimbot angles", "Velocity Scale", 0, 200, 50, true, "%"),
                wall_aware = ui.new_checkbox("aa", "anti-aimbot angles", "Wall-Aware Prediction")
            },
    
            
            ["latency⠀compensation"] = {
                enabled = ui.new_checkbox("aa", "anti-aimbot angles", "Enable Latency Compensation"),
                ping_threshold = ui.new_slider("aa", "anti-aimbot angles", "Ping Threshold", 20, 200, 50, true, "ms"),
                high_ping_shift = ui.new_slider("aa", "anti-aimbot angles", "High Ping Shift", -90, 90, 30, true, "°"),
                choke_factor = ui.new_slider("aa", "anti-aimbot angles", "Choke Latency Factor", 0, 100, 20, true, "%"),
                smooth_transition = ui.new_checkbox("aa", "anti-aimbot angles", "Smooth Latency Transition")
            },
    
            
            override = {
                enabled = ui.new_checkbox("aa", "anti-aimbot angles", "Enable Manual Override"),
                condition = ui.new_combobox("aa", "anti-aimbot angles", "Override Condition", {"Always", "On Miss", "On High Choke", "On Low Stability"}),
                yaw_value = ui.new_slider("aa", "anti-aimbot angles", "Override Yaw", -180, 180, 0, true, "°"),
                miss_threshold = ui.new_slider("aa", "anti-aimbot angles", "Miss Threshold", 1, 5, 2, true),
                choke_threshold = ui.new_slider("aa", "anti-aimbot angles", "Choke Threshold", 3, 14, 5, true),
                stability_threshold = ui.new_slider("aa", "anti-aimbot angles", "Stability Threshold", 5, 60, 20, true, "°")
            }
        }
    }

    menu["visuals"] = {
        watermark = ui.new_checkbox("aa", "anti-aimbot angles", "\aBA55D3FFWatermark")
    }
    
    menu["misc"] = {
        other = {
            justspace = ui.new_label("aa", "anti-aimbot angles", "⠀"),
            Other1 = ui.new_label("aa", "anti-aimbot angles", "Others"),
            StrochkaBlyatO = ui.new_label("aa", "anti-aimbot angles", "\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
            Zeus_Fix = ui.new_checkbox("aa", "anti-aimbot angles", "\aBA55D3FFZeus Fix"),
            smart_backtrack = ui.new_checkbox("aa", "anti-aimbot angles", "\aBA55D3FFSmart Backtrack"),
            trashtalk = ui.new_checkbox("aa", "anti-aimbot angles", "\aBA55D3FFtrashtalk"),
            leg_spammer = ui.new_checkbox("aa", "anti-aimbot angles", "\aBA55D3FFLeg Spammer"),
            spammer = ui.new_slider("aa", "anti-aimbot angles", "\aBA55D3FFLeg Spammer Speed", 1, 9, 1),
            ClanTags = ui.new_checkbox("aa", "anti-aimbot angles", "\aBA55D3FFCustom Clan Tags"),
            ClanTagAnimation = ui.new_combobox("aa", "anti-aimbot angles", "\aBA55D3FFClan Tag Animation", {"Insanity", "Nakiev"}),
            FastLadder = ui.new_checkbox("aa", "anti-aimbot angles", "\aBA55D3FFFast Ladder"),
            Autobuy = ui.new_checkbox("aa", "anti-aimbot angles", "\aBA55D3FFAutobuy"),
            AutobuyWeapon = ui.new_combobox("aa", "anti-aimbot angles", "\aBA55D3FFAutobuy Weapon", {"SSG 08", "AWP", "Auto-Sniper"})
    },
        binds = {
            justspace2 = ui.new_label("aa", "anti-aimbot angles", "⠀"),
            binds = ui.new_label("aa", "anti-aimbot angles", "Binds"),
            StrochkaBlyatO1 = ui.new_label("aa", "anti-aimbot angles", "\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),   
            freestanding = ui.new_hotkey("aa", "anti-aimbot angles", "\aBA55D3FFFreestanding", false),
            manual_left = ui.new_hotkey("aa", "anti-aimbot angles", "\aBA55D3FFManual Left", false),
            manual_right = ui.new_hotkey("aa", "anti-aimbot angles", "\aBA55D3FFManual Right", false),
            manual_reset = ui.new_hotkey("aa", "anti-aimbot angles", "\aBA55D3FFManual Reset", false)
        }
        
    }

    menu["other"] = {
        socials_label = ui.new_label("aa", "other", "\aBA55D3FFSocials"),
        youtube_button = ui.new_button("aa", "other", "\aBA55D3FFYouTube", function()
            panorama.open("CSGOHud").SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@thischanneIdoesnotexist")
        end),
        discord_button = ui.new_button("aa", "other", "\aBA55D3FFDiscord", function()
            panorama.open("CSGOHud").SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/UysyqdWhV5")
        end),
        telegram_button = ui.new_button("aa", "other", "\aBA55D3FFTelegram", function()
            panorama.open("CSGOHud").SteamOverlayAPI.OpenExternalBrowserURL("https://t.me/insanitylua")
        end),
    }

    menu["fake lag"] = {
        NameVer = ui.new_label("aa", "fake lag", "⠀⠀⠀⠀⠀⠀\aBA55D3FFInsanity | v1.0"),
        Stroka = ui.new_label("aa", "fake lag", "\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
        Changelog = ui.new_label("aa", "fake lag", "⠀⠀⠀⠀⠀⠀Changelog"),
        Realnyoprobel = ui.new_label("aa", "fake lag", "⠀"),
        Clpage1 = ui.new_label("aa", "fake lag", "[+] New Interface"),
        Clpage2 = ui.new_label("aa", "fake lag", "[+] CFG system"),
        Clpage3 = ui.new_label("aa", "fake lag", "[+] AA Builder"),
        Clpage4 = ui.new_label("aa", "fake lag", "[+] Resolver Builder"),
        Clpage5 = ui.new_label("aa", "fake lag", "[?] Nakiev.lua >> Insanity.lua"),
        Clpage6 = ui.new_label("aa", "fake lag", "[-] Enemy"),
        Clpage7 = ui.new_label("aa", "fake lag", "[-] Nakiev.lua(press F)")

    }

    client.set_event_callback("paint_ui", function()
        if not ui.is_menu_open() then return end
    
        
        for _, v in pairs(tbl.items) do 
            for _, ref in pairs(v) do 
                if type(ref) == "number" then
                    ui.set_visible(ref, false)
                end
            end 
        end
    
        
        local function hide_elements(tbl)
            for _, item in pairs(tbl) do
                if type(item) == "number" then
                    ui.set_visible(item, false)
                elseif type(item) == "table" then
                    hide_elements(item)
                end
            end
        end
    
        hide_elements(menu)
    
        local selected_cat = ui.get(category)
    
        
        if selected_cat == "anti-aim" then
            ui.set_visible(menu["anti-aim"].mode, true)
            local is_aa_builder = ui.get(menu["anti-aim"].mode) == "aa builder"
            ui.set_visible(menu["anti-aim"].builder.state, is_aa_builder)
            ui.set_visible(menu["anti-aim"].builder.subgroup, is_aa_builder)
            ui.set_visible(menu["anti-aim"].builder.spacer, is_aa_builder)
            
            if is_aa_builder then
                local selected_state = ui.get(menu["anti-aim"].builder.state)
                local selected_subgroup = ui.get(menu["anti-aim"].builder.subgroup):lower()
                local state_config = menu["anti-aim"].builder.states[selected_state]
    
                
                if selected_subgroup == "pitch" then
                    ui.set_visible(state_config.pitch.enabled, true)
                    local pitch_enabled = ui.get(state_config.pitch.enabled)
                    ui.set_visible(state_config.pitch.mode, pitch_enabled)
                    local pitch_mode = ui.get(state_config.pitch.mode)
                    ui.set_visible(state_config.pitch.custom_value, pitch_enabled and pitch_mode == "Custom")
                    ui.set_visible(state_config.pitch.randomize, pitch_enabled)
                    ui.set_visible(state_config.pitch.random_range, pitch_enabled and ui.get(state_config.pitch.randomize))
                    ui.set_visible(state_config.pitch.velocity_influence, pitch_enabled)
    
                
                elseif selected_subgroup == "yaw" then
                    ui.set_visible(state_config.yaw.enabled, true)
                    local yaw_enabled = ui.get(state_config.yaw.enabled)
                    ui.set_visible(state_config.yaw.base, yaw_enabled)
                    ui.set_visible(state_config.yaw.mode, yaw_enabled)
                    local yaw_mode = ui.get(state_config.yaw.mode)
                    ui.set_visible(state_config.yaw.static_value, yaw_enabled and yaw_mode == "Static")
                    ui.set_visible(state_config.yaw.frequency, yaw_enabled and yaw_mode == "Dynamic")
                    ui.set_visible(state_config.yaw.amplitude, yaw_enabled and yaw_mode == "Dynamic")
                    ui.set_visible(state_config.yaw.jitter_influence, yaw_enabled)
                    ui.set_visible(state_config.yaw.velocity_aware, yaw_enabled)
                    ui.set_visible(state_config.yaw.velocity_threshold, yaw_enabled and ui.get(state_config.yaw.velocity_aware))
                    ui.set_visible(state_config.yaw.dt_shift, yaw_enabled)
                    ui.set_visible(state_config.yaw.dt_shift_amount, yaw_enabled and ui.get(state_config.yaw.dt_shift))
    
                
                elseif selected_subgroup == "jitter" then
                    ui.set_visible(state_config.jitter.enabled, true)
                    local jitter_enabled = ui.get(state_config.jitter.enabled)
                    ui.set_visible(state_config.jitter.type, jitter_enabled)
                    local jitter_type = jitter_enabled and ui.get(state_config.jitter.type) ~= "Off"
                    ui.set_visible(state_config.jitter.amplitude, jitter_type)
                    ui.set_visible(state_config.jitter.frequency, jitter_type)
                    ui.set_visible(state_config.jitter.chaos_factor, jitter_type)
                    ui.set_visible(state_config.jitter.air_only, jitter_type)
                    ui.set_visible(state_config.jitter.sync_with_tick, jitter_type)
    
                
                elseif selected_subgroup == "body yaw" then
                    ui.set_visible(state_config.body_yaw.enabled, true)
                    local body_yaw_enabled = ui.get(state_config.body_yaw.enabled)
                    ui.set_visible(state_config.body_yaw.mode, body_yaw_enabled)
                    local body_yaw_mode = ui.get(state_config.body_yaw.mode)
                    ui.set_visible(state_config.body_yaw.static_value, body_yaw_enabled and body_yaw_mode == "Static")
                    ui.set_visible(state_config.body_yaw.invert, body_yaw_enabled and body_yaw_mode ~= "Off")
                    ui.set_visible(state_config.body_yaw.velocity_factor, body_yaw_enabled and body_yaw_mode ~= "Off")
                    ui.set_visible(state_config.body_yaw.enemy_aware, body_yaw_enabled and body_yaw_mode == "Dynamic")
    
                
                elseif selected_subgroup == "roll" then
                    ui.set_visible(state_config.roll.enabled, true)
                    local roll_enabled = ui.get(state_config.roll.enabled)
                    ui.set_visible(state_config.roll.amount, roll_enabled)
                    ui.set_visible(state_config.roll.dynamic, roll_enabled)
                    ui.set_visible(state_config.roll.dynamic_frequency, roll_enabled and ui.get(state_config.roll.dynamic))
    
                
                elseif selected_subgroup == "conditions" then
                    ui.set_visible(state_config.conditions.enabled, true)
                    local conditions_enabled = ui.get(state_config.conditions.enabled)
                    ui.set_visible(state_config.conditions.air_adjust, conditions_enabled)
                    local air_adjust = conditions_enabled and ui.get(state_config.conditions.air_adjust)
                    ui.set_visible(state_config.conditions.air_pitch, air_adjust)
                    ui.set_visible(state_config.conditions.air_yaw_offset, air_adjust)
                    ui.set_visible(state_config.conditions.velocity_adjust, conditions_enabled)
                    local velocity_adjust = conditions_enabled and ui.get(state_config.conditions.velocity_adjust)
                    ui.set_visible(state_config.conditions.velocity_threshold, velocity_adjust)
                    ui.set_visible(state_config.conditions.velocity_yaw_shift, velocity_adjust)
    
                
                elseif selected_subgroup == "defensive" then
                    ui.set_visible(state_config.defensive.enabled, true)
                    local defensive_enabled = ui.get(state_config.defensive.enabled)
                    ui.set_visible(state_config.defensive.edge_aware, defensive_enabled)
                    ui.set_visible(state_config.defensive.edge_yaw_shift, defensive_enabled and ui.get(state_config.defensive.edge_aware))
                    ui.set_visible(state_config.defensive.fs_body, defensive_enabled)
                    ui.set_visible(state_config.defensive.random_shift, defensive_enabled)
                    ui.set_visible(state_config.defensive.random_shift_max, defensive_enabled and ui.get(state_config.defensive.random_shift))
                    ui.set_visible(state_config.defensive.dt_defense, defensive_enabled)
                    ui.set_visible(state_config.defensive.dt_jitter, defensive_enabled and ui.get(state_config.defensive.dt_defense))
    
                
                elseif selected_subgroup == "flick" then
                    ui.set_visible(state_config.flick.enabled, true)
                    local flick_enabled = ui.get(state_config.flick.enabled)
                    ui.set_visible(state_config.flick.amplitude, flick_enabled)
                    ui.set_visible(state_config.flick.interval, flick_enabled)
                    ui.set_visible(state_config.flick.random_offset, flick_enabled)
                    ui.set_visible(state_config.flick.condition, flick_enabled)
    
                
                elseif selected_subgroup == "sway" then
                    ui.set_visible(state_config.sway.enabled, true)
                    local sway_enabled = ui.get(state_config.sway.enabled)
                    ui.set_visible(state_config.sway.amplitude, sway_enabled)
                    ui.set_visible(state_config.sway.speed, sway_enabled)
                    ui.set_visible(state_config.sway.phase_shift, sway_enabled)
                    ui.set_visible(state_config.sway.invert_on_edge, sway_enabled)
    
                
                elseif selected_subgroup == "adaptive" then
                    ui.set_visible(state_config.adaptive.enabled, true)
                    local adaptive_enabled = ui.get(state_config.adaptive.enabled)
                    ui.set_visible(state_config.adaptive.miss_shift, adaptive_enabled)
                    ui.set_visible(state_config.adaptive.miss_threshold, adaptive_enabled)
                    ui.set_visible(state_config.adaptive.choke_shift, adaptive_enabled)
                    ui.set_visible(state_config.adaptive.choke_threshold, adaptive_enabled)
                    ui.set_visible(state_config.adaptive.velocity_factor, adaptive_enabled)
    
                
                elseif selected_subgroup == "freestand" then
                    ui.set_visible(state_config.freestand.enabled, true)
                    local freestand_enabled = ui.get(state_config.freestand.enabled)
                    ui.set_visible(state_config.freestand.yaw_offset, freestand_enabled)
                    ui.set_visible(state_config.freestand.detection_range, freestand_enabled)
                    ui.set_visible(state_config.freestand.invert_on_wall, freestand_enabled)
                    ui.set_visible(state_config.freestand.dynamic_adjust, freestand_enabled)
    
                
                elseif selected_subgroup == "edge" then
                    ui.set_visible(state_config.edge.enabled, true)
                    local edge_enabled = ui.get(state_config.edge.enabled)
                    ui.set_visible(state_config.edge.edge_yaw, edge_enabled)
                    ui.set_visible(state_config.edge.detection_dist, edge_enabled)
                    ui.set_visible(state_config.edge.jitter_on_edge, edge_enabled)
                    ui.set_visible(state_config.edge.edge_jitter_amplitude, edge_enabled and ui.get(state_config.edge.jitter_on_edge))
    
                
                elseif selected_subgroup == "fakelagsync" then
                    ui.set_visible(state_config.fakelagsync.enabled, true)
                    local fakelagsync_enabled = ui.get(state_config.fakelagsync.enabled)
                    ui.set_visible(state_config.fakelagsync.choke_shift, fakelagsync_enabled)
                    ui.set_visible(state_config.fakelagsync.choke_threshold, fakelagsync_enabled)
                    ui.set_visible(state_config.fakelagsync.lag_mode, fakelagsync_enabled)
                    ui.set_visible(state_config.fakelagsync.lag_factor, fakelagsync_enabled)
    
                
                elseif selected_subgroup == "velocitywarp" then
                    ui.set_visible(state_config.velocitywarp.enabled, true)
                    local velocitywarp_enabled = ui.get(state_config.velocitywarp.enabled)
                    ui.set_visible(state_config.velocitywarp.velocity_threshold, velocitywarp_enabled)
                    ui.set_visible(state_config.velocitywarp.warp_factor, velocitywarp_enabled)
                    ui.set_visible(state_config.velocitywarp.invert_on_stop, velocitywarp_enabled)
                    ui.set_visible(state_config.velocitywarp.wall_aware, velocitywarp_enabled)
    
                
                elseif selected_subgroup == "peekreaction" then
                    ui.set_visible(state_config.peekreaction.enabled, true)
                    local peekreaction_enabled = ui.get(state_config.peekreaction.enabled)
                    ui.set_visible(state_config.peekreaction.peek_shift, peekreaction_enabled)
                    ui.set_visible(state_config.peekreaction.detection_range, peekreaction_enabled)
                    ui.set_visible(state_config.peekreaction.reaction_delay, peekreaction_enabled)
                    ui.set_visible(state_config.peekreaction.random_factor, peekreaction_enabled)
                end
            end
        end
    
        
        if selected_cat == "resolver" then
            ui.set_visible(menu["resolver"].preset, true)
            local is_builder_active = ui.get(menu["resolver"].preset) == "resolver builder"
            ui.set_visible(menu["resolver"].builder.subgroup, is_builder_active)
            ui.set_visible(menu["resolver"].builder.spacer, is_builder_active)
            
            if is_builder_active then
                local selected_subgroup = ui.get(menu["resolver"].builder.subgroup):lower()
                local subgroup_config = menu["resolver"].builder[selected_subgroup]
                if subgroup_config and type(subgroup_config) == "table" then
                    ui.set_visible(subgroup_config.enabled, true)
                    local enabled = ui.get(subgroup_config.enabled)
        
                    if selected_subgroup == "velocity" then
                        ui.set_visible(subgroup_config.factor, enabled)
                        ui.set_visible(subgroup_config.threshold, enabled)
                        ui.set_visible(subgroup_config.invert, enabled)
                        ui.set_visible(subgroup_config.wall_aware, enabled)
                        ui.set_visible(subgroup_config.max_adjustment, enabled)
                        ui.set_visible(subgroup_config.spike_factor, enabled)
                    elseif selected_subgroup == "animations" then
                        ui.set_visible(subgroup_config.mode, enabled)
                        ui.set_visible(subgroup_config.influence, enabled)
                        ui.set_visible(subgroup_config.threshold, enabled)
                        ui.set_visible(subgroup_config.lby_influence, enabled)
                        ui.set_visible(subgroup_config.choke_influence, enabled)
                        ui.set_visible(subgroup_config.smoothing, enabled)
                        ui.set_visible(subgroup_config.boost_factor, enabled)
                    elseif selected_subgroup == "history" then
                        ui.set_visible(subgroup_config.mode, enabled)
                        ui.set_visible(subgroup_config.depth, enabled)
                        ui.set_visible(subgroup_config.stability_threshold, enabled)
                        ui.set_visible(subgroup_config.invert, enabled)
                        ui.set_visible(subgroup_config.weight_factor, enabled)
                        ui.set_visible(subgroup_config.jitter_influence, enabled)
                    elseif selected_subgroup == "miss" then
                        ui.set_visible(subgroup_config.mode, enabled)
                        ui.set_visible(subgroup_config.amplitude, enabled)
                        ui.set_visible(subgroup_config.after_misses, enabled)
                        ui.set_visible(subgroup_config.invert, enabled)
                        ui.set_visible(subgroup_config.reset_threshold, enabled)
                        ui.set_visible(subgroup_config.scale_factor, enabled)
                    elseif selected_subgroup == "jitter" then
                        ui.set_visible(subgroup_config.type, enabled)
                        ui.set_visible(subgroup_config.frequency, enabled)
                        ui.set_visible(subgroup_config.amplitude, enabled)
                        ui.set_visible(subgroup_config.chaos_factor, enabled)
                        ui.set_visible(subgroup_config.sync_with_tick, enabled)
                        ui.set_visible(subgroup_config.phase_shift, enabled)
                    elseif selected_subgroup == "defensive" then
                        ui.set_visible(subgroup_config.anti_bruteforce, enabled)
                        ui.set_visible(subgroup_config.anti_bruteforce_misses, enabled and ui.get(subgroup_config.anti_bruteforce))
                        ui.set_visible(subgroup_config.random_shift, enabled)
                        ui.set_visible(subgroup_config.random_shift_max, enabled and ui.get(subgroup_config.random_shift))
                        ui.set_visible(subgroup_config.jitter_amplitude, enabled)
                        ui.set_visible(subgroup_config.adaptive_defense, enabled)
                        ui.set_visible(subgroup_config.adaptive_threshold, enabled and ui.get(subgroup_config.adaptive_defense))
                        ui.set_visible(subgroup_config.ping_mode, enabled)
                        ui.set_visible(subgroup_config.edge_detection, enabled)
                        ui.set_visible(subgroup_config.choke_factor, enabled)
                    elseif selected_subgroup == "hitbox" then
                        ui.set_visible(subgroup_config.mode, enabled)
                        local mode = ui.get(subgroup_config.mode)
                        ui.set_visible(subgroup_config.static_hitbox, enabled and mode == "Static")
                        ui.set_visible(subgroup_config.switch_speed, enabled and (mode == "Cycle" or mode == "Adaptive"))
                        ui.set_visible(subgroup_config.on_miss, enabled and mode == "Adaptive")
                        ui.set_visible(subgroup_config.miss_count, enabled and mode == "Adaptive" and ui.get(subgroup_config.on_miss))
                        ui.set_visible(subgroup_config.randomize, enabled)
                        ui.set_visible(subgroup_config.priority_factor, enabled)
                    elseif selected_subgroup == "dt" then
                        ui.set_visible(subgroup_config.mode, enabled)
                        ui.set_visible(subgroup_config.shift_amount, enabled)
                        ui.set_visible(subgroup_config.velocity_boost, enabled)
                        ui.set_visible(subgroup_config.choke_adjust, enabled)
                    elseif selected_subgroup == "distance" then
                        ui.set_visible(subgroup_config.min_dist, enabled)
                        ui.set_visible(subgroup_config.max_dist, enabled)
                        ui.set_visible(subgroup_config.dist_factor, enabled)
                        ui.set_visible(subgroup_config.close_shift, enabled)
                        ui.set_visible(subgroup_config.far_shift, enabled)
                    elseif selected_subgroup == "weapon_awareness" then
                        ui.set_visible(subgroup_config.sniper_adjust, enabled)
                        ui.set_visible(subgroup_config.pistol_adjust, enabled)
                        ui.set_visible(subgroup_config.rifle_adjust, enabled)
                        ui.set_visible(subgroup_config.dynamic_switch, enabled)
                        ui.set_visible(subgroup_config.switch_speed, enabled and ui.get(subgroup_config.dynamic_switch))
                    elseif selected_subgroup == "prediction" then
                        ui.set_visible(subgroup_config.ticks, enabled)
                        ui.set_visible(subgroup_config.accel_factor, enabled)
                        ui.set_visible(subgroup_config.yaw_boost, enabled)
                        ui.set_visible(subgroup_config.velocity_scale, enabled)
                        ui.set_visible(subgroup_config.wall_aware, enabled)
                    elseif selected_subgroup == "latency_compensation" then
                        ui.set_visible(subgroup_config.ping_threshold, enabled)
                        ui.set_visible(subgroup_config.high_ping_shift, enabled)
                        ui.set_visible(subgroup_config.choke_factor, enabled)
                        ui.set_visible(subgroup_config.smooth_transition, enabled)
                    elseif selected_subgroup == "override" then
                        ui.set_visible(subgroup_config.condition, enabled)
                        ui.set_visible(subgroup_config.yaw_value, enabled)
                        local condition = ui.get(subgroup_config.condition)
                        ui.set_visible(subgroup_config.miss_threshold, enabled and condition == "On Miss")
                        ui.set_visible(subgroup_config.choke_threshold, enabled and condition == "On High Choke")
                        ui.set_visible(subgroup_config.stability_threshold, enabled and condition == "On Low Stability")
                    end
                end
            end
        end
    
        
        if selected_cat == "visuals" then
            for k, v in pairs(menu["visuals"]) do
                if type(v) == "table" then
                    for sub_k, sub_v in pairs(v) do
                        ui.set_visible(sub_v, true)
                    end
                else
                    ui.set_visible(v, true)
                end
            end
        end
    
        
        if selected_cat == "misc" then
            for sub_k, sub_v in pairs(menu["misc"]) do
                if type(sub_v) == "table" then
                    for sub_sub_k, sub_sub_v in pairs(sub_v) do
                        if sub_k == "exploits" and sub_sub_k == "smart_backtrack" then
                            ui.set_visible(sub_sub_v, true)
                        elseif sub_k == "other" and sub_sub_k == "spammer" then
                            ui.set_visible(sub_sub_v, ui.get(menu["misc"].other.leg_spammer))
                        elseif sub_k == "other" and sub_sub_k == "ClanTagAnimation" then
                            ui.set_visible(sub_sub_v, ui.get(menu["misc"].other.ClanTags)) 
                        elseif sub_k == "other" and sub_sub_k == "AutobuyWeapon" then
                            ui.set_visible(sub_sub_v, ui.get(menu["misc"].other.Autobuy))
                        else
                            ui.set_visible(sub_sub_v, true)
                        end
                    end
                end
            end
        end
    
        
        if selected_cat == "home" then
            for k, v in pairs(menu["home"]) do
                ui.set_visible(v, true)
            end
        end
    
        
        ui.set_visible(menu["other"].socials_label, true)
        ui.set_visible(menu["other"].youtube_button, true)
        ui.set_visible(menu["other"].discord_button, true)
        ui.set_visible(menu["other"].telegram_button, true)
    
        ui.set_visible(menu["fake lag"].NameVer, true)
        ui.set_visible(menu["fake lag"].Stroka, true)
        ui.set_visible(menu["fake lag"].Changelog, true)
        ui.set_visible(menu["fake lag"].Realnyoprobel, true)
        ui.set_visible(menu["fake lag"].Clpage1, true)
        ui.set_visible(menu["fake lag"].Clpage2, true)
        ui.set_visible(menu["fake lag"].Clpage3, true)
        ui.set_visible(menu["fake lag"].Clpage4, true)
        ui.set_visible(menu["fake lag"].Clpage5, true)
        ui.set_visible(menu["fake lag"].Clpage6, true)
        ui.set_visible(menu["fake lag"].Clpage7, true)  
    
        last_cat = selected_cat
        ui.set_visible(tbl.items.roll[1], false)
    end)
end


main({
    ref = function(a, b, c) return { ui.reference(a, b, c) } end,
    extrapolate = function(player, ticks, x, y, z)
        local v = entity.get_prop(player, "m_vecVelocity")
        local vx, vy, vz = v[1], v[2], v[3]
        return x + (vx or 0) * globals.tickinterval() * ticks, y + (vy or 0) * globals.tickinterval() * ticks, z + (vz or 0) * globals.tickinterval() * ticks
    end
})

client.set_event_callback("setup_command", function(cmd)
    handle_manual_and_freestand(cmd)
    apply_anti_aim(cmd)
    other_logic(cmd)
    fast_ladder(cmd)
end)


client.set_event_callback("paint", smart_backtrack)

client.set_event_callback("shutdown", function()
    hooked_vtable[38] = vtable[38]
    pointer[0] = vtable
    for _, v in pairs(tbl.items) do 
        for _, ref in pairs(v) do 
            ui.set_visible(ref, true) 
        end 
    end
    ui.set(tbl.items.enabled[1], true)
    ui.set(tbl.items.pitch[1], "default")
    ui.set(tbl.items.jitter[1], "off")
    ui.set(tbl.items.body[1], "opposite")
    ui.set(tbl.items.roll[1], 0)
    reset_smart_backtrack()
end)

client.color_log(221, 160, 221, "[Insanity] Loading Successfully, Enjoy")