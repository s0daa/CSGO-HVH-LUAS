-- Android Notify.lua by Salvatore
local android_notify=(function()local a={callback_registered=false,maximum_count=7,data={}}function a:register_callback()if self.callback_registered then return end;client.set_event_callback('paint_ui',function()local b={client.screen_size()}local c={56,56,57}local d=5;local e=self.data;for f=#e,1,-1 do self.data[f].time=self.data[f].time-globals.frametime()local g,h=255,0;local i=e[f]if i.time<0 then table.remove(self.data,f)else local j=i.def_time-i.time;local j=j>1 and 1 or j;if i.time<0.5 or j<0.5 then h=(j<1 and j or i.time)/0.5;g=h*255;if h<0.2 then d=d+15*(1.0-h/0.2)end end;local k={renderer.measure_text(nil,i.draw)}local l={b[1]/2-k[1]/2+3,b[2]-b[2]/100*17.4+d}renderer.circle(l[1],l[2],c[1],c[2],c[3],g,20,180,0.5)renderer.circle(l[1]+k[1],l[2],c[1],c[2],c[3],g,20,0,0.5)renderer.rectangle(l[1],l[2]-20,k[1],40,c[1],c[2],c[3],g)renderer.text(l[1]+k[1]/2,l[2],255,255,255,g,'c',nil,i.draw)d=d-50 end end;self.callback_registered=true end)end;function a:paint(m,n)local o=tonumber(m)+1;for f=self.maximum_count,2,-1 do self.data[f]=self.data[f-1]end;self.data[1]={time=o,def_time=o,draw=n}self:register_callback()end;return a end)()

local ffi = require 'ffi'

ffi.cdef[[
    typedef void*(__thiscall* get_net_channel_info_t)(void*);

    typedef float(__thiscall* get_avg_latency_t)(void*, int);
    typedef float(__thiscall* get_avg_loss_t)(void*, int);
    typedef float(__thiscall* get_avg_choke_t)(void*, int);
]]

local interface_ptr = ffi.typeof('void***')
local rawivengineclient = client.create_interface('engine.dll', 'VEngineClient014') or error('VEngineClient014 wasnt found', 2)
local ivengineclient = ffi.cast(interface_ptr, rawivengineclient) or error('rawivengineclient is nil', 2)
local get_net_channel_info = ffi.cast('get_net_channel_info_t', ivengineclient[0][78]) or error('ivengineclient is nil')

local timers = (function()local b={}b.timers={}function b:update(c,d)local e=false;if self.timers[c]==nil or self.timers[c]-globals.realtime()<=0 then self.timers[c]=globals.realtime()+d;e=true end;return e end;return b end)()
local gram_create = function(value, count) local gram = { }; for i=1, count do gram[i] = value; end return gram; end
local gram_update = function(tab, value, forced) local new_tab = tab; if forced or new_tab[#new_tab] ~= value then table.insert(new_tab, value); table.remove(new_tab, 1); end; tab = new_tab; end

local get_average = function(tab) local elements, sum = 0, 0; for k, v in pairs(tab) do sum = sum + v; elements = elements + 1; end return sum / elements; end

local loss_data = gram_create(0, 16)
local ffi_loss = {
    tr = 0,
    tr_ex = 0,
    maximum = 0.00,
}

-- Death reason
local shoot_time = { }
local handle_aimbot = function(c)
    if c.reason == nil then
        shoot_time[c.target] = globals.curtime()
        return
    end

    local delay = ((globals.curtime()-shoot_time[c.target])-client.latency())*1000

    if c.reason == 'death' and delay > 0 and entity.is_alive(c.target) then
        android_notify:paint(7, string.format('Shot missed due to death despite the server having %.2fms to process our shot.', delay))
    end
end

client.set_event_callback('aim_fire', handle_aimbot)
client.set_event_callback('aim_miss', handle_aimbot)
client.set_event_callback('run_command', function()
    local netchaninfo = ffi.cast('void***', get_net_channel_info(ivengineclient)) or error('netchaninfo is nil')
    local data = ffi.cast('get_avg_loss_t', netchaninfo[0][11])(netchaninfo, 1)

    gram_update(loss_data, data, timers:update('loss', 0.5))

    local average = get_average(loss_data)

    if ffi_loss.maximum < data then
        ffi_loss.maximum = data
    end

    if average >= 0.005 and ffi_loss.tr == 0 then 
        ffi_loss.tr = 1
        android_notify:paint(7, string.format('Currently experiencing an elevated level of connectivity errors (%d%%+)', data*100))
    end

    if average > 0.08 and ffi_loss.tr_ex == 0 then
        ffi_loss.tr_ex = 1
        android_notify:paint(7, string.format('An unexpected node failure may cause degradation in cheat performance. (%d%%+)', data*100))
    end

    if math.max(unpack(loss_data)) == 0 then
        if ffi_loss.tr == 1 then
            android_notify:paint(5, 'The connectivity error level returning back to normal')
        end

        ffi_loss.tr = 0
        ffi_loss.tr_ex = 0
        ffi_loss.maximum = data
    end
end)