--sewowo
--sewowo

local vector = require "vector"
local function rgba(r, g, b, a, ...) return ("\a%x%x%x%x"):format(r, g, b, a) .. ... end
local notify=(function()local b=vector;local c=function(d,b,c)return d+(b-d)*c end;local e=function()return b(client.screen_size())end;local f=function(d,...)local c={...}local c=table.concat(c,"")return b(renderer.measure_text(d,c))end;local g={notifications={bottom={}},max={bottom=6}}g.__index=g;g.new_bottom=function(h,i,j,...)table.insert(g.notifications.bottom,{started=false,instance=setmetatable({active=false,timeout=5,color={["r"]=h,["g"]=i,["b"]=j,a=0},x=e().x/2,y=e().y,text=...},g)})end;function g:handler()local d=0;local b=0;for d,b in pairs(g.notifications.bottom)do if not b.instance.active and b.started then table.remove(g.notifications.bottom,d)end end;for d=1,#g.notifications.bottom do if g.notifications.bottom[d].instance.active then b=b+1 end end;for c,e in pairs(g.notifications.bottom)do if c>g.max.bottom then return end;if e.instance.active then e.instance:render_bottom(d,b)d=d+1 end;if not e.started then e.instance:start()e.started=true end end end;function g:start()self.active=true;self.delay=globals.realtime()+self.timeout end;function g:get_text()local d=""for b,b in pairs(self.text)do local c=f("",b[1])local c,e,f=255,255,255;if b[2]then c,e,f=255, 170, 220 end;d=d..("\a%02x%02x%02x%02x%s"):format(c,e,f,self.color.a,b[1])end;return d end;local k=(function()local d={}d.rec=function(d,b,c,e,f,g,k,l,m)m=math.min(d/2,b/2,m)renderer.rectangle(d,b+m,c,e-m*2,f,g,k,l)renderer.rectangle(d+m,b,c-m*2,m,f,g,k,l)renderer.rectangle(d+m,b+e-m,c-m*2,m,f,g,k,l)renderer.circle(d+m,b+m,f,g,k,l,m,180,0.25)renderer.circle(d-m+c,b+m,f,g,k,l,m,90,0.25)renderer.circle(d-m+c,b-m+e,f,g,k,l,m,0,0.25)renderer.circle(d+m,b-m+e,f,g,k,l,m,-90,0.25)end;d.rec_outline=function(d,b,c,e,f,g,k,l,m,n)m=math.min(c/2,e/2,m)if m==1 then renderer.rectangle(d,b,c,n,f,g,k,l)renderer.rectangle(d,b+e-n,c,n,f,g,k,l)else renderer.rectangle(d+m,b,c-m*2,n,f,g,k,l)renderer.rectangle(d+m,b+e-n,c-m*2,n,f,g,k,l)renderer.rectangle(d,b+m,n,e-m*2,f,g,k,l)renderer.rectangle(d+c-n,b+m,n,e-m*2,f,g,k,l)renderer.circle_outline(d+m,b+m,f,g,k,l,m,180,0.25,n)renderer.circle_outline(d+m,b+e-m,f,g,k,l,m,90,0.25,n)renderer.circle_outline(d+c-m,b+m,f,g,k,l,m,-90,0.25,n)renderer.circle_outline(d+c-m,b+e-m,f,g,k,l,m,0,0.25,n)end end;d.glow_module_notify=function(b,c,e,f,g,k,l,m,n,o,p,q,r,s,s)local t=1;local u=1;if s then d.rec(b,c,e,f,l,m,n,o,k)end;for l=0,g do local m=o/2*(l/g)^3;d.rec_outline(b+(l-g-u)*t,c+(l-g-u)*t,e-(l-g-u)*t*2,f-(l-g-u)*t*2,p,q,r,m/1.5,k+t*(g-l+u),t)end end;return d end)()function g:render_bottom(g,l)local e=e()local m=6;local n="     "..self:get_text()local f=f("",n)local o=8;local p=5;local q=0+m+f.x;local q,r=q+p*2,12+10+1;local s,t=self.x-q/2,math.ceil(self.y-40+0.4)local u=globals.frametime()if globals.realtime()<self.delay then self.y=c(self.y,e.y-45-(l-g)*r*1.4,u*7)self.color.a=c(self.color.a,255,u*2)else self.y=c(self.y,self.y-10,u*15)self.color.a=c(self.color.a,0,u*20)if self.color.a<=1 then self.active=false end end;local c,e,g,l=self.color.r,self.color.g,self.color.b,self.color.a;k.glow_module_notify(s,t,q,r,1,o,25,25,25,l,255, 226, 255,l,true)local k=p+2;k=k+0+m;renderer.text(s+k,t+r/2-f.y/2,255,199,255,l,"b",nil,"✨")renderer.text(s+k,t+r/2-f.y/2   ,c,e,g,l,"",nil,n)end;client.set_event_callback("paint_ui",function()g:handler()end)return g end)()
local w, h = client.screen_size()
client.set_event_callback("paint_ui", function()
end)
-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_camera_angles, client_create_interface, client_eye_position, client_set_event_callback, client_userid_to_entindex, entity_get_local_player, entity_get_player_name, entity_get_prop, entity_is_alive, globals_chokedcommands, globals_realtime, globals_tickcount, globals_tickinterval, math_abs, math_ceil, math_floor, string_format, string_lower, table_concat, table_insert, ui_new_checkbox, ui_reference, error, pairs, plist_get, ui_get, print, ui_set_callback = client.camera_angles, client.create_interface, client.eye_position, client.set_event_callback, client.userid_to_entindex, entity.get_local_player, entity.get_player_name, entity.get_prop, entity.is_alive, globals.chokedcommands, globals.realtime, globals.tickcount, globals.tickinterval, math.abs, math.ceil, math.floor, string.format, string.lower, table.concat, table.insert, ui.new_checkbox, ui.reference, error, pairs, plist.get, ui.get, print, ui.set_callback

local ffi = require 'ffi'
local vector = require 'vector'
local inspect = require 'gamesense/inspect'

local ffi_typeof, ffi_cast = ffi.typeof, ffi.cast

local num_format = function(b) local c=b%10;if c==1 and b~=11 then return b..'st'elseif c==2 and b~=12 then return b..'nd'elseif c==3 and b~=13 then return b..'rd'else return b..'th'end end

local ffi = require("ffi")
client.exec("clear")

function Clamp(value, min, max) return math.min(math.max(value, min), max) end

local function NormalizeAngle(angle)
    if angle == nil then return 0 end
    while angle > 180 do angle = angle - 360 end
    while angle < -180 do angle = angle + 360 end
    return angle
end
local function AngleDifference(dest_angle, src_angle)
    local delta = math.fmod(dest_angle - src_angle, 360)
    if dest_angle > src_angle then
        if delta >= 180 then delta = delta - 360 end
    else
        if delta <= -180 then delta = delta + 360 end
    end
    return delta
end

local function DegToRad(Deg) return Deg * (math.pi / 180) end
local function RadToDeg(Rad) return Rad * (180 / math.pi) end

local VTable = {
    Entry = function(instance, index, type) return ffi.cast(type, (ffi.cast("void***", instance)[0])[index]) end,
    Bind = function(self, module, interface, index, typestring)
        local instance = client.create_interface(module, interface)
        local fnptr = self.Entry(instance, index, ffi.typeof(typestring))
        return function(...) return fnptr(instance, ...) end
    end
}


local menu_color = ui.reference("MISC", "Settings", "Menu color")

client.set_event_callback("paint", function()
    local r, g, b, a = ui.get(menu_color)
end)

local animstate_t = ffi.typeof 'struct { char pad0[0x18]; float anim_update_timer; char pad1[0xC]; float started_moving_time; float last_move_time; char pad2[0x10]; float last_lby_time; char pad3[0x8]; float run_amount; char pad4[0x10]; void* entity; void* active_weapon; void* last_active_weapon; float last_client_side_animation_update_time; int  last_client_side_animation_update_framecount; float eye_timer; float eye_angles_y; float eye_angles_x; float goal_feet_yaw; float current_feet_yaw; float torso_yaw; float last_move_yaw; float lean_amount; char pad5[0x4]; float feet_cycle; float feet_yaw_rate; char pad6[0x4]; float duck_amount; float landing_duck_amount; char pad7[0x4]; float current_origin[3]; float last_origin[3]; float velocity_x; float velocity_y; char pad8[0x4]; float unknown_float1; char pad9[0x8]; float unknown_float2; float unknown_float3; float unknown; float m_velocity; float jump_fall_velocity; float clamped_velocity; float feet_speed_forwards_or_sideways; float feet_speed_unknown_forwards_or_sideways; float last_time_started_moving; float last_time_stopped_moving; bool on_ground; bool hit_in_ground_animation; char pad10[0x4]; float time_since_in_air; float last_origin_z; float head_from_ground_distance_standing; float stop_to_full_running_fraction; char pad11[0x4]; float magic_fraction; char pad12[0x3C]; float world_force; char pad13[0x1CA]; float min_yaw; float max_yaw; } **'
local NativeGetClientEntity = VTable:Bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
-- ui.new_label("Rage", "Other", "                     \a870946FFRage Features")
-- ui.new_label("Rage", "Other", "--------------------------------------------------")
local resolver_enabled = ui.new_checkbox("LUA", "B", string.format("\a%02X%02X%02XFFEnable ~ Synapse Logic Resolver", ui.get(menu_color)))
local color = ui.new_color_picker("LUA", "B", "debug color", 255,255,255)
local multibox = ui.new_multiselect("LUA", "B", "Auto force body aim if", {"hp lower than x value"})
local health = ui.new_slider("LUA", "B", "hp", 0, 100, 92, true)
local multibox2 = ui.new_multiselect("LUA", "B", "Auto force safepoint if", {"hp lower than x value", "after x misses"})
local health2 = ui.new_slider("LUA", "B", "hp", 0, 100, 92, true)
local missed = ui.new_slider("LUA", "B", "missed", 0, 10, 2, true)
local dormant_beta = ui.new_checkbox("LUA", "B", "Dormant Aimbot [DEBUG ONLY]")
local predict_command = ui.new_checkbox("LUA", "B", "predict_command")
local defensive_check_slider1 = ui.new_slider("LUA", "B", "defensive min", 1, 13, 4)
local defensive_check_slider2 = ui.new_slider("LUA", "B", "defensive max", 1, 13, 12)
local master_switch = ui_new_checkbox('LUA', 'B', 'Rage logging')
local prefer_safe_point = ui_reference('RAGE', 'Aimbot', 'Prefer safe point')
local force_safe_point = ui_reference('RAGE', 'Aimbot', 'Force safe point')
local reset = ui.new_button("LUA", "B", "Reset Reso-Data", function() end)

-- ui.new_label("Rage", "Other", "--------------------------------------------------")
rgba_to_hex = function(b,c,d,e)
        return string.format('%02x%02x%02x%02x',b,c,d,e)
    end
ui.set_visible(missed, false)
ui.set_visible(health, false)
ui.set_visible(health2, false)
local function updateMultiboxVisibility()
    if ui.get(resolver_enabled) == true then
        ui.set_visible(multibox, true)
        ui.set_visible(reset, true)
        ui.set_visible(multibox2, true)
        ui.set_visible(dormant_beta, true)
        ui.set_visible(master_switch, true)
        ui.set_visible(predict_command, true)
        ui.set_visible(color, true)
    else
        ui.set_visible(multibox, false)
        ui.set_visible(reset, false)
        ui.set_visible(multibox2, false)
        ui.set_visible(dormant_beta, false)
        ui.set_visible(master_switch, false)
        ui.set_visible(predict_command, false)
        ui.set_visible(color, false)
    end 
end

local function updateMultiboxVisibility1()
    if ui.get(predict_command) == true then
        ui.set_visible(defensive_check_slider1, true)
        ui.set_visible(defensive_check_slider2, true)
    else
        ui.set_visible(defensive_check_slider1, false)
        ui.set_visible(defensive_check_slider2, false)
    end
end

--ui disabled = 
ui.set_enabled(dormant_beta, true)
ui.set_enabled(predict_command, true)
--ui disabled end

local function defensive_check_predict(cmd)
    local defensive_system = {
    ticks_count = 0,
    max_tick_base = 0,
    current_command = 0,
    is_defensive = 0
   }
    if ui.get(predict_command) then
        return
    end
    local player = entity.get_local_player()

    if not player or not entity.is_alive(player) then
        return
    end

    local current_tick = globals.tickcount()
    local tick_base = entity.get_prop(player, "m_nTickBase") or 0
    local can_exploit = current_tick > tick_base

    if math.abs(tick_base - defensive_system.max_tick_base) > 64 and can_exploit then
        defensive_system.max_tick_base = 0
    end

    if tick_base > defensive_system.max_tick_base then
        defensive_system.max_tick_base = tick_base
    elseif defensive_system.max_tick_base > tick_base then
        defensive_system.ticks_count = can_exploit and math.min(14, math.max(0, defensive_system.max_tick_base - tick_base - 1)) or 0
    end
    defensive_system.is_defensive = defensive_system.ticks_count > ui.get(defensive_check_slider2) and defensive_system.ticks_count < ui.get(defensive_check_slider2) and 1 or 0
end

client.set_event_callback("predict_command", defensive_check_predict)

ui.set_callback(reset, function()
    ui.set(health, 50)
    ui.set(health2, 50)
    ui.set(missed, 0)
    client.color_log(152,54,135, "[debug] ~ reset successfully !")
    notify.new_bottom(255, 226, 243, { { "[synapse] ", true }, { 'reset successfully' }, { " !", true }, })
end)

local function updateSliderVisibility()
    local selected_items = ui.get(multibox)
    local show_health = false
    local enabled = ui.get(resolver_enabled) == true

    if selected_items then
        for _, item in ipairs(selected_items) do
            if item == "hp lower than x value" and enabled then
                show_health = true
                break
            end
        end
    end
    ui.set_visible(health, show_health)
end
local function updateSliderVisibility2()
    local selected_items2 = ui.get(multibox2)
    local show_missed = false
    local enabled = ui.get(resolver_enabled) == true

    if selected_items2 then
        for _, item in ipairs(selected_items2) do
            if item == "after x misses" and enabled then
                show_missed = true
                break
            end
        end
    end
    ui.set_visible(missed, show_missed)
end

local function updateSliderVisibility3()
    local selected_items3 = ui.get(multibox2)
    local enabled = ui.get(resolver_enabled) == true
    local show_health2 = false
    if selected_items3 then
        for _, item in ipairs(selected_items3) do
            if item == "hp lower than x value" and enabled then
                show_health2 = true
                break
            end
        end
    end
    ui.set_visible(health2, show_health2)
end

local GetAnimState = function(ent)
    if not ent then return false end
    local Address = type(ent) == "cdata" and ent or NativeGetClientEntity(ent)
    if not Address or Address == ffi.NULL then return false end
    local AddressVtable = ffi.cast("void***", Address)
    return ffi.cast(animstate_t, ffi.cast("char*", AddressVtable) + 0x9960)[0]
end

local GetSimulationTime = function(ent)
    local pointer = NativeGetClientEntity(ent)
    if pointer then return entity.get_prop(ent, "m_flSimulationTime"), ffi.cast("float*", ffi.cast("uintptr_t", pointer) + 0x26C)[0] else return 0 end
end

local GetMaxDesync = function(player)
    local Animstate = GetAnimState(player)
    if not Animstate then return 0 end
    local speedfactor = Clamp(Animstate.feet_speed_forwards_or_sideways, 0, 1)
    local avg_speedfactor = (Animstate.stop_to_full_running_fraction * -0.3 - 0.2) * speedfactor + 1
    local duck_amount = Animstate.duck_amount
    if duck_amount > 0 then avg_speedfactor = avg_speedfactor + ((duck_amount * speedfactor) * (0.5 - avg_speedfactor)) end
    return Clamp(avg_speedfactor, .5, 1)
end

local IsPlayerAnimating = function(player)
    local CurrentSimulationTime, RecordSimulationTime = GetSimulationTime(player)
    CurrentSimulationTime, RecordSimulationTime = toticks(CurrentSimulationTime), toticks(RecordSimulationTime)
    return toticks(CurrentSimulationTime) ~= nil and toticks(RecordSimulationTime) ~= nil
end

local GetChokedPackets = function(player)
    if not IsPlayerAnimating(player) then return 0 end
    local CurrentSimulationTime, PreviousSimulationTime = GetSimulationTime(player)
    local SimulationTimeDifference = globals.curtime() - CurrentSimulationTime
    local ChokedCommands = Clamp(toticks(math.max(0.0, SimulationTimeDifference - client.latency())), 0, cvar.sv_maxusrcmdprocessticks:get_string() - 2)
    return ChokedCommands
end

function RebuildServerYaw(player)
    local Animstate = GetAnimState(player)
    if not Animstate then return 0 end
    
    local m_flGoalFeetYaw = Animstate.goal_feet_yaw
    local eye_feet_delta = AngleDifference(Animstate.eye_angles_y, Animstate.goal_feet_yaw)
    local flRunningSpeed = Clamp(Animstate.feet_speed_forwards_or_sideways, 0.0, 1.0)
    
    local flYawModifier = (((Animstate.stop_to_full_running_fraction * -0.3) - 0.2) * flRunningSpeed) + 1.0
    if Animstate.duck_amount > 0.0 then
        local flDuckingSpeed = Clamp(Animstate.feet_speed_forwards_or_sideways, 0.0, 1.0)
        flYawModifier = flYawModifier + ((Animstate.duck_amount * flDuckingSpeed) * (0.5 - flYawModifier))
    end
   
    local flMaxYawModifier = flYawModifier * Animstate.max_yaw
    local flMinYawModifier = flYawModifier * Animstate.min_yaw
   
    if eye_feet_delta <= flMaxYawModifier then
        if flMinYawModifier > eye_feet_delta then
            m_flGoalFeetYaw = math.abs(flMinYawModifier) + Animstate.eye_angles_y
        end
    else
        m_flGoalFeetYaw = Animstate.eye_angles_y - math.abs(flMaxYawModifier)
    end

    return NormalizeAngle(m_flGoalFeetYaw)
end

local JitterBuffer = 6
local Resolver = { 
    Jitter = { Jittering = false, JitterTicks = 0, StaticTicks = 0, YawCache = {}, JitterCache = 0, Difference = 0 },
    Main = { Mode = 0, Side = 0, Angles = 0 }
}

local Cache = {}

local CDetectJitter = function(player)
    local Data = Resolver.Jitter
    local EyeAnglesY = entity.get_prop(player, "m_angEyeAngles")
    Data.YawCache[Data.JitterCache % JitterBuffer] = EyeAnglesY
    if Data.JitterCache >= JitterBuffer + 1 then
        Data.JitterCache = 0
    else
        Data.JitterCache = Data.JitterCache + 1
    end
    for i = 0, JitterBuffer, 1 do
        if i < JitterBuffer then
            local Difference = (Data.YawCache[i - Data.JitterCache % JitterBuffer] ~= nil and Data.YawCache[Data.JitterCache % JitterBuffer] ~= nil) and math.abs(Data.YawCache[i - Data.JitterCache % JitterBuffer] - Data.YawCache[Data.JitterCache % JitterBuffer]) or 0
            if Difference ~= nil and Difference ~= 0.0 then
                NormalizeAngle(Difference)
                Data.Jittering = Difference >= (45.0 * GetMaxDesync(player)) and true or false
                Data.Difference = Difference
            end
        end
    end
end

local CProcessImpact = function(player) return Resolver.Jitter.Jittering and 1 or 0 end


local CDetectDesyncSide = function(player)
    local Animstate = GetAnimState(player)
    if not Animstate then return 0 end

    if Resolver.Jitter.Jittering and GetChokedPackets(player) < 3 then
        Cache.FirstNormalizedAngle = NormalizeAngle(Resolver.Jitter.YawCache[JitterBuffer - 1])
        Cache.SecondNormalizedAngle = NormalizeAngle(Resolver.Jitter.YawCache[JitterBuffer - 2])

        Cache.FirstSinAngle = math.sin(DegToRad(Cache.FirstNormalizedAngle))
        Cache.SecondSinAngle = math.sin(DegToRad(Cache.SecondNormalizedAngle))

        Cache.FirstCosAngle = math.cos(DegToRad(Cache.FirstNormalizedAngle))
        Cache.SecondCosAngle = math.cos(DegToRad(Cache.SecondNormalizedAngle))

        Cache.AVGYaw = NormalizeAngle(RadToDeg(math.atan2((Cache.FirstSinAngle + Cache.SecondSinAngle) / 2.0, (Cache.FirstCosAngle + Cache.SecondCosAngle) / 2.0)))
        Cache.Difference = NormalizeAngle(Animstate.eye_angles_y - Cache.AVGYaw)
        if Cache.Difference ~= 0.0 then Resolver.Main.Side = Cache.Difference > 0.0 and 1 or -1 else Resolver.Main.Side = 0 end
    end

    return Resolver.Main.Side
end




local miss_count = 0

local function resetResolverData()
    Resolver.Jitter.Jittering = false
    Resolver.Jitter.JitterTicks = 0
    Resolver.Jitter.StaticTicks = 0
    Resolver.Jitter.YawCache = {}
    Resolver.Jitter.JitterCache = 0
    Resolver.Jitter.Difference = 0
    Resolver.Main.Mode = 0
    Resolver.Main.Angles = 0
    miss_count = 0
end

local function aim_miss(player)
    miss_count = miss_count + 1 
end

client.set_event_callback("aim_miss", aim_miss)


local function is_baimable(player)
    local lethal = entity.get_prop(player, "m_iHealth")
    local number_lethal = ui.get(health)  
    local selected_items = ui.get(multibox)
    local selected_items2 = ui.get(multibox2)

    if selected_items then
        for _, item in ipairs(selected_items) do
            if item == "hp lower than x value" then
                if lethal > 0 then
                    if lethal <= number_lethal then 
                        plist.set(player, "Override prefer body aim", "Force")
                    else
                        plist.set(player, "Override prefer body aim", "-")
                    end
                end
            end
        end
    end

    local missed_number = ui.get(missed)
    local number_lethal2 = ui.get(health2)
    if selected_items2 then
        for _, item2 in ipairs(selected_items2) do 
            if item2 == "hp lower than x value" then 
                if lethal > 0 then
                    if lethal <= number_lethal2 then
                        plist.set(player, "Override safe point", "On")
                    else
                        plist.set(player, "Override safe point", "-")
                    end
                end
            end          
        end    
    end
    if selected_items2 then
        for _, item2 in ipairs(selected_items2) do 
            if item2 == "after x misses" then 
                if miss_count >= missed_number and lethal > 0 then
                    plist.set(player, "Override safe point", "On")
                else
                    plist.set(player, "Override safe point", "-")
                end          
            end    
        end
    end
end

client.set_event_callback("player_death", function (player)
    miss_count = 0
end)



local CResolverInstance = function(player)
    local Animstate = GetAnimState(player)
    if not Animstate then return end

    CProcessImpact(player)
    CDetectJitter(player)
    CDetectDesyncSide(player)

    local ChokedPackets = GetChokedPackets(player)
    local Desync = math.abs(NormalizeAngle(Animstate.eye_angles_y - Animstate.torso_yaw))
    local Velocity = entity.get_prop(player, "m_vecVelocity[0]")
    local IsDucking = Animstate.duck_amount > 0.1
    local IsFakeWalking = math.abs(AngleDifference(Animstate.eye_angles_y, Animstate.last_move_yaw)) < 5 and Velocity > 10

    if ChokedPackets > 2 then
        Resolver.Main.Angles = 0
        Resolver.Main.Mode = 0
    elseif Desync >= 40 and Velocity > 150 then
        Resolver.Main.Angles = NormalizeAngle(Animstate.torso_yaw - Animstate.eye_angles_y)
        Resolver.Main.Mode = 1
    elseif Desync > 20 and IsDucking then
        Resolver.Main.Angles = NormalizeAngle(Animstate.torso_yaw - Animstate.eye_angles_y)
        Resolver.Main.Mode = 1
    elseif IsFakeWalking then
        Resolver.Main.Angles = 0
        Resolver.Main.Mode = 1
    else
        if Resolver.Jitter.Jittering then

            Resolver.Main.Angles = Cache.Difference ~= nil and (Cache.Difference * GetMaxDesync(player)) * Resolver.Main.Side or (45.0 * GetMaxDesync(player)) * Resolver.Main.Side
            Resolver.Main.Mode = 1
        else
            Resolver.Main.Angles = 0
            Resolver.Main.Mode = 0
        end
    end
end




client.set_event_callback("net_update_end", function()
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then 
        Resolver.Main.Mode = 0 
        return 
    end
    local Players = entity.get_players()
    client.update_player_list()
    for _, idx in ipairs(Players) do
        if entity.is_enemy(idx) and IsPlayerAnimating(idx) and ui.get(resolver_enabled) then
            CResolverInstance(idx)       
            plist.set(idx, "Force body yaw value", Resolver.Main.Mode ~= 0 and Resolver.Main.Angles or 0 )
            plist.set(idx, "Force body yaw", Resolver.Main.Mode ~= 0)
        else
            plist.set(idx, "Force body yaw", false)
        end
            is_baimable(idx)    
        plist.set(idx, "Correction active", true)
    end
end)

client.set_event_callback("round_start", function()
    resetResolverData()
end)


client.register_esp_flag("BD", 200, 200, 200, function(e) return (entity.is_enemy(e) and ui.get(resolver_enabled) and Resolver.Main.Mode == 1) and true or false end)
client.register_esp_flag("BAIM", 161, 73, 47, function(player) return plist.get(player, "Override prefer body aim") == "Force" end)
client.register_esp_flag("SAFE", 131, 153, 50, function(player) return plist.get(player, "Override safe point") == "On" end)

updateMultiboxVisibility()
updateMultiboxVisibility1()

ui.set_callback(resolver_enabled, function ()
    updateMultiboxVisibility()
    updateSliderVisibility3()
    updateSliderVisibility2()
    updateSliderVisibility()
end)
ui.set_callback(predict_command, function ()
    updateMultiboxVisibility1()
end)
ui.set_callback(multibox, function ()
    updateSliderVisibility()
end)
ui.set_callback(multibox2, function ()
    updateSliderVisibility2()
    updateSliderVisibility3() 
end)

client.set_event_callback("paint", function()
    rgba_to_hex = function(c,d,e,f)
        return string.format('%02x%02x%02x%02x',c,d,e,f)
    end
if ui.get(resolver_enabled) == true then
    local r,g,b,a = ui.get(color)
    renderer.indicator(143, 194, 21, 255, "\a"..rgba_to_hex(r,g,b,a * math.abs(math.cos(globals.curtime()*1))).."AIMBRUTE")
end


end)

local hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' }
local weapon_to_verb = { knife = 'Knifed', hegrenade = 'Naded', inferno = 'Burned' }

local classes = {
    net_channel = function()
        local this = { }

        local class_ptr = ffi_typeof('void***')
        local engine_client = ffi_cast(class_ptr, client_create_interface("engine.dll", "VEngineClient014"))
        local get_channel = ffi_cast("void*(__thiscall*)(void*)", engine_client[0][78])

        local netc_bool = ffi_typeof("bool(__thiscall*)(void*)")
        local netc_bool2 = ffi_typeof("bool(__thiscall*)(void*, int, int)")
        local netc_float = ffi_typeof("float(__thiscall*)(void*, int)")
        local netc_int = ffi_typeof("int(__thiscall*)(void*, int)")
        local net_fr_to = ffi_typeof("void(__thiscall*)(void*, float*, float*, float*)")

        client_set_event_callback('net_update_start', function()
            local ncu_info = ffi_cast(class_ptr, get_channel(engine_client)) or error("net_channel:update:info is nil")
            local seqNr_out = ffi_cast(netc_int, ncu_info[0][17])(ncu_info, 1)
        
            for name, value in pairs({
                seqNr_out = seqNr_out,
        
                is_loopback = ffi_cast(netc_bool, ncu_info[0][6])(ncu_info),
                is_timing_out = ffi_cast(netc_bool, ncu_info[0][7])(ncu_info),
        
                latency = {
                    crn = function(flow) return ffi_cast(netc_float, ncu_info[0][9])(ncu_info, flow) end,
                    average = function(flow) return ffi_cast(netc_float, ncu_info[0][10])(ncu_info, flow) end,
                },
        
                loss = ffi_cast(netc_float, ncu_info[0][11])(ncu_info, 1),
                choke = ffi_cast(netc_float, ncu_info[0][12])(ncu_info, 1),
                got_bytes = ffi_cast(netc_float, ncu_info[0][13])(ncu_info, 1),
                sent_bytes = ffi_cast(netc_float, ncu_info[0][13])(ncu_info, 0),
        
                is_valid_packet = ffi_cast(netc_bool2, ncu_info[0][18])(ncu_info, 1, seqNr_out-1),
            }) do
                this[name] = value
            end
        end)

        function this:get()
            return (this.seqNr_out ~= nil and this or nil)
        end

        return this
    end,

    aimbot = function(net_channel)
        local this = { }
        local aim_data = { }
        local bullet_impacts = { }

        local generate_flags = function(pre_data)
            return {
                pre_data.self_choke > 1 and 1 or 0,
                pre_data.velocity_modifier < 1.00 and 1 or 0,
                pre_data.flags.boosted and 1 or 0
            }
        end

        local get_safety = function(aim_data, target)
            local has_been_boosted = aim_data.boosted
            local plist_safety = plist_get(target, 'Override safe point')
            local ui_safety = { ui_get(prefer_safe_point), ui_get(force_safe_point) or plist_safety == 'On' }
    
            if not has_been_boosted then
                return -1
            end
    
            if plist_safety == 'Off' or not (ui_safety[1] or ui_safety[2]) then
                return 0
            end
    
            return ui_safety[2] and 2 or (ui_safety[1] and 1 or 0)
        end

        local get_inaccuracy_tick = function(pre_data, tick)
            local spread_angle = -1
            for k, impact in pairs(bullet_impacts) do
                if impact.tick == tick then
                    local aim, shot = 
                        (pre_data.eye-pre_data.shot_pos):angles(),
                        (pre_data.eye-impact.shot):angles()
        
                        spread_angle = vector(aim-shot):length2d()
                    break
                end
            end

            return spread_angle
        end

        this.fired = function(e)
            local this = { }
            local p_ent = e.target
            local me = entity_get_local_player()
        
            aim_data[e.id] = {
                original = e,
                dropped_packets = { },
        
                handle_time = globals_realtime(),
                self_choke = globals_chokedcommands(),
        
                flags = {
                    boosted = e.boosted
                },

                safety = get_safety(e, p_ent),
                correction = plist_get(p_ent, 'Correction active'),
        
                shot_pos = vector(e.x, e.y, e.z),
                eye = vector(client_eye_position()),
                view = vector(client_camera_angles()),
        
                velocity_modifier = entity_get_prop(me, 'm_flVelocityModifier'),
                total_hits = entity_get_prop(me, 'm_totalHitsOnServer'),

                history = globals.tickcount() - e.tick
            }
        end
        
        this.missed = function(e)
            if aim_data[e.id] == nil then
                return
            end
        
            local pre_data = aim_data[e.id]
            local shot_id = num_format((e.id % 15) + 1)
            
            local net_data = net_channel:get()
        
            local ping, avg_ping = 
                net_data.latency.crn(0)*1000, 
                net_data.latency.average(0)*1000
        
            local net_state = string_format(
                'delay: %d:%.2f | dropped: %d', 
                avg_ping, math_abs(avg_ping-ping), #pre_data.dropped_packets
            )
        
            local uflags = {
                math_abs(avg_ping-ping) < 1 and 0 or 1,
                cvar.cl_clock_correction:get_int() == 1 and 0 or 1,
                cvar.cl_clock_correction_force_server_tick:get_int() == 999 and 0 or 1
            }
        
            local spread_angle = get_inaccuracy_tick( pre_data, globals_tickcount() )
            
            -- smol stuff
            local me = entity_get_local_player()
            local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
            local target_name = string_lower(entity_get_player_name(e.target))
            local hit_chance = math_floor(pre_data.original.hit_chance + 0.5)
            local pflags = generate_flags(pre_data)
        
            local reasons = {
                ['event_timeout'] = function()
                    print(string_format(
                        'Missed %s shot due to event timeout [%s] [%s]', 
                        shot_id, target_name, net_state
                    ))
                end,

                ['death'] = function()
                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to death [dropped: %d | flags: %s | error: %s]', 
                        shot_id, target_name, hgroup, hit_chance, #pre_data.dropped_packets, table_concat(pflags), table_concat(uflags)
                    ))
                end,
        
                ['prediction_error'] = function(type)
                    local type = type == 'unregistered shot' and (' [' .. type .. ']') or ''
                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to prediction error%s [%s] [vel_modifier: %.1f | history(Δ): %d | error: %s]', 
                        shot_id, target_name, hgroup, hit_chance, type, net_state, entity_get_prop(me, 'm_flVelocityModifier'), pre_data.history, table_concat(uflags)
                    ))
                end,
        
                ['spread'] = function()
                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to spread ( dmg: %d | safety: %d | history(Δ): %d | flags: %s )',
                        shot_id, target_name, hgroup, hit_chance, spread_angle, 
                        pre_data.original.damage, pre_data.safety, pre_data.history, table_concat(pflags)
                    ))
                end,
        
                ['unknown'] = function(type)
                    local _type = {
                        ['damage_rejected'] = 'damage rejection',
                        ['unknown'] = string_format('unknown [angle: ?° | ?°]')
                    }

                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to %s ( dmg: %d | safety: %d | history(Δ): %d | flags: %s )',
                        shot_id, target_name, hgroup, hit_chance, _type[type or 'unknown'],
                        pre_data.original.damage, pre_data.safety, pre_data.history, table_concat(pflags)
                    ))
                end
            }
        
            local post_data = {
                event_timeout = (globals_realtime() - pre_data.handle_time) >= 0.5,
                damage_rejected = e.reason == '?' and pre_data.total_hits ~= entity_get_prop(me, 'm_totalHitsOnServer'),
                prediction_error = e.reason == 'prediction error' or e.reason == 'unregistered shot'
            }
        
            if post_data.event_timeout then 
                reasons.event_timeout()
            elseif post_data.prediction_error then 
                reasons.prediction_error(e.reason)
            elseif e.reason == 'spread' then
                reasons.spread()
            elseif e.reason == '?' then
                reasons.unknown(post_data.damage_rejected and 'damage_rejected' or 'unknown')
            elseif e.reason == 'death' then
                reasons.death()
            end
        
            aim_data[e.id] = nil
        end
        
        this.hit = function(e)
            if aim_data[e.id] == nil then
                return
            end
        
            local p_ent = e.target

            local pre_data = aim_data[e.id]
            local shot_id = num_format((e.id % 15) + 1)

            local me = entity_get_local_player()
            local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
            local aimed_hgroup = hitgroup_names[pre_data.original.hitgroup + 1] or '?'

            local target_name = string_lower(entity_get_player_name(e.target))
            local hit_chance = math_floor(pre_data.original.hit_chance + 0.5)
            local pflags = generate_flags(pre_data)

            local spread_angle = get_inaccuracy_tick( pre_data, globals_tickcount() )
            
            local _verification = function()
                local text = ''

                local hg_diff = hgroup ~= aimed_hgroup
                local dmg_diff = e.damage ~= pre_data.original.damage

                if hg_diff or dmg_diff then
                    text = string_format(
                        ' | mismatch: [ %s ]', (function()
                            local addr = ''

                            if dmg_diff then addr = 'dmg: ' .. pre_data.original.damage .. (hg_diff and ' | ' or '') end
                            if hg_diff then addr = addr .. (hg_diff and 'hitgroup: ' .. aimed_hgroup or '') end

                            return addr
                        end)()
                    )
                end

                return text
            end

            notify.new_bottom(255, 226, 243, { { "[synapse] ", true }, { 'registered ' }, { shot_id }, { ' shot in ' }, { target_name }, {"'s "} , { hgroup }, { " for "}, { e.damage }, { " ( hitchance: "}, { hit_chance}, { " | safety: " }, { pre_data.safety }, { " | history(Δ): "}, {  pre_data.history }, { " | flags: " }, { table_concat(pflags), _verification() }, { " )" }, })
            print(string_format(
                'Registered %s shot in %s\'s %s for %d damage ( hitchance: %d%% | safety: %s | history(Δ): %d | flags: %s%s )',
                shot_id, target_name, hgroup, e.damage,
                hit_chance, pre_data.safety, pre_data.history, table_concat(pflags), _verification()
            ))
        end
        
        this.bullet_impact = function(e)
            local tick = globals_tickcount()
            local me = entity_get_local_player()
            local user = client_userid_to_entindex(e.userid)
            
            if user ~= me then
                return
            end
        
            if #bullet_impacts > 150 then
                bullet_impacts = { }
            end
        
            bullet_impacts[#bullet_impacts+1] = {
                tick = tick,
                eye = vector(client_eye_position()),
                shot = vector(e.x, e.y, e.z)
            }
        end
        
        this.net_listener = function()
            local net_data = net_channel:get()
        
            if net_data == nil then
                return
            end

            if not net_channel.is_valid_packet then
                for id in pairs(aim_data) do
                    table_insert(aim_data[id].dropped_packets, net_channel.seqNr_out)
                end
            end
        end

        return this
    end
}

local net_channel = classes.net_channel()
local aimbot = classes.aimbot(net_channel)

local g_player_hurt = function(e)
    local attacker_id = client_userid_to_entindex(e.attacker)
    
    if attacker_id == nil or attacker_id ~= entity_get_local_player() then
        return
    end

    local group = hitgroup_names[e.hitgroup + 1] or "?"
    
    if group == "generic" and weapon_to_verb[e.weapon] ~= nil then
        local target_id = client_userid_to_entindex(e.userid)
        local target_name = entity_get_player_name(target_id)

        print(string_format("%s %s for %i damage (%i remaining)", weapon_to_verb[e.weapon], string_lower(target_name), e.dmg_health, e.health))
    end
end

local interface_callback = function(c)
    local addr = not ui_get(c) and 'un' or ''
    local _func = client[addr .. 'set_event_callback']

    _func('aim_fire', aimbot.fired)
    _func('aim_miss', aimbot.missed)
    _func('aim_hit', aimbot.hit)
    _func('bullet_impact', aimbot.bullet_impact)
    _func('net_update_start', aimbot.net_listener)
    _func('player_hurt', g_player_hurt)
end

ui_set_callback(master_switch, interface_callback)
interface_callback(master_switch)