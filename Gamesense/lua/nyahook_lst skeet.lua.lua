local ffi = require("ffi")
local vector = require("vector")
local base64 = require("gamesense/base64")
local clipboard = require("gamesense/clipboard")
local c_entity = require("gamesense/entity")
local pui = require("gamesense/pui")

ffi.cdef [[
    struct c_animstate {
        char pad[3];
        char m_bForceWeaponUpdate; // 0x4
        char pad1[91];
        void* m_pBaseEntity; // 0x60
        void* m_pActiveWeapon; // 0x64
        void* m_pLastActiveWeapon; // 0x68
        float m_flLastClientSideAnimationUpdateTime; // 0x6C
        int m_iLastClientSideAnimationUpdateFramecount; // 0x70
        float m_flAnimUpdateDelta; // 0x74
        float m_flEyeYaw; // 0x78
        float m_flGoalFeetYaw; // 0x80
        float m_flCurrentFeetYaw; // 0x84   
        float m_flCurrentTorsoYaw; // 0x88
        float m_flSpeedNormalized; // 0xF4
        bool m_bOnGround; // 0x108
    };
]]

local classptr = ffi.typeof('void***')
local rawientitylist = client.create_interface('client.dll', 'VClientEntityList003') or
                           error('VClientEntityList003 not found', 2)

local ientitylist = ffi.cast(classptr, rawientitylist) or error('ientitylist is nil', 2)
local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or
                              error('get_client_entity is nil', 2)

local events do
	local event_mt = { } do
        event_mt.__call = function(self, fn, bool)
			local action = bool and client.set_event_callback or client.unset_event_callback
			action(self[1], fn)
		end

		event_mt.set = function(self, fn)
			client.set_event_callback(self[1], fn)
		end

		event_mt.unset = function(self, fn)
			client.unset_event_callback(self[1], fn)
		end

	    event_mt.__index = event_mt
    end


	events = setmetatable({}, {
		__index = function (self, index)
			self[index] = setmetatable({index}, event_mt)
			return self[index]
		end,
	})
end

local ffi_helpers do
    ffi_helpers = {} do
        ffi_helpers.get_client_entity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void***, int)')

        ffi_helpers.animstate = {} do
            if not pcall(ffi.typeof, 'bt_animstate_t') then
                ffi.cdef[[
                    typedef struct {
                        char __0x108[0x108];
                        bool on_ground;
                        bool hit_in_ground_animation;
                    } bt_animstate_t, *pbt_animstate_t
                ]]
            end

            ffi_helpers.animstate.offset = 0x9960

            ffi_helpers.animstate.get = function (self, ent)
                local client_entity = ffi_helpers.get_client_entity(ent)

                if not client_entity then
                    return
                end

                return ffi.cast('pbt_animstate_t*', ffi.cast('uintptr_t', client_entity) + self.offset)[0]
            end
        end

        ffi_helpers.animlayers = {} do
            if not pcall(ffi.typeof, 'bt_animlayer_t') then
                ffi.cdef[[
                    typedef struct {
                        float   anim_time;
                        float   fade_out_time;
                        int     nil;
                        int     activty;
                        int     priority;
                        int     order;
                        int     sequence;
                        float   prev_cycle;
                        float   weight;
                        float   weight_delta_rate;
                        float   playback_rate;
                        float   cycle;
                        int     owner;
                        int     bits;
                    } bt_animlayer_t, *pbt_animlayer_t
                ]]
            end

            ffi_helpers.animlayers.offset = ffi.cast('int*', ffi.cast('uintptr_t', client.find_signature('client.dll', '\x8B\x89\xCC\xCC\xCC\xCC\x8D\x0C\xD1')) + 2)[0]

            ffi_helpers.animlayers.get = function (self, ent)
                local client_entity = ffi_helpers.get_client_entity(ent)

                if not client_entity then
                    return
                end

                return ffi.cast('pbt_animlayer_t*', ffi.cast('uintptr_t', client_entity) + self.offset)[0]
            end
        end

        ffi_helpers.activity = {} do
            if not pcall(ffi.typeof, 'bt_get_sequence') then
                ffi.cdef[[
                    typedef int(__fastcall* bt_get_sequence)(void* entity, void* studio_hdr, int sequence);
                ]]
            end

            ffi_helpers.activity.offset = 0x2950 --- @offset https://github.com/frk1/hazedumper/blob/master/csgo.json#L55
            ffi_helpers.activity.location = ffi.cast('bt_get_sequence', client.find_signature('client.dll', '\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x8B\xF1\x83'))

            ffi_helpers.activity.get = function (self, sequence, ent)
                local client_entity = ffi_helpers.get_client_entity(ent)

                if not client_entity then
                    return
                end

                local studio_hdr = ffi.cast('void**', ffi.cast('uintptr_t', client_entity) + self.offset)[0]

                if not studio_hdr then
                    return;
                end

                return self.location(client_entity, studio_hdr, sequence);
            end
        end

        ffi_helpers.user_input = {} do
            if not pcall(ffi.typeof, 'bt_cusercmd_t') then
                ffi.cdef[[
                    typedef struct {
                        struct bt_cusercmd_t (*cusercmd)();
                        int     command_number;
                        int     tick_count;
                        float   view[3];
                        float   aim[3];
                        float   move[3];
                        int     buttons;
                    } bt_cusercmd_t;
                ]]
            end

            if not pcall(ffi.typeof, 'bt_get_usercmd') then
                ffi.cdef[[
                    typedef bt_cusercmd_t*(__thiscall* bt_get_usercmd)(void* input, int, int command_number);
                ]]
            end

            ffi_helpers.user_input.vtbl = ffi.cast('void***', ffi.cast('void**', ffi.cast('uintptr_t', client.find_signature('client.dll', '\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85') or error('fipp')) + 1)[0])
            ffi_helpers.user_input.location = ffi.cast('bt_get_usercmd', ffi_helpers.user_input.vtbl[0][8])

            ffi_helpers.user_input.get_command = function (self, command_number)
                return self.location(self.vtbl, 0, command_number)
            end
        end
    end
end

math.clamp = function(x) 
    if x == nil then return 0 end 
    x = (x % 360 + 360) % 360 
    return x > 180 and x - 360 or x 
end

math.normalize_yaw = function(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end
    return yaw
end

math.normalize_angle = function(angle)
    while angle > 180 do
        angle = angle - 360
    end
    while angle < -180 do
        angle = angle + 360
    end
    return angle
end

lerp = function(a, b, t)
    return a + t * (b - a)
end

local animations = { } do
    animations.max_lerp_low_fps = (1 / 45) * 100
    animations.color_lerp = function(start, end_pos, time)
        local frametime = globals.frametime() * 100
        time = time * math.min(frametime, animations.max_lerp_low_fps)
        return lerp(start, end_pos, time)
    end
    
    animations.lerp = function(start, end_pos, time)
        if start == end_pos then
            return end_pos
        end
    
        local frametime = globals.frametime() * 170
        time = time * math.min(frametime, animations.max_lerp_low_fps)
    
        local val = start + (end_pos - start) * math.clamp(time, 0.01, 1)
    
        if(math.abs(val - end_pos) < 0.01) then
            return end_pos
        end
    
        return val
    end

    animations.base_speed = 0.095
    animations._list = {}

    animations.new = function(name, new_value, speed, init)
        speed = speed or animations.base_speed
        
        local is_color = type(new_value) == "userdata"

        if animations._list[name] == nil then
            animations._list[name] = (init and init) or (is_color and color(255) or 0)
        end

        local interp_func

        if is_color then
            interp_func = animations.color_lerp
        else
            interp_func = animations.lerp
        end

        animations._list[name] = interp_func(animations._list[name], new_value, speed)
        
        return animations._list[name]
    end
end

local tween=(function()local a={}local b,c,d,e,f,g,h=math.pow,math.sin,math.cos,math.pi,math.sqrt,math.abs,math.asin;local function i(j,k,l,m)return l*j/m+k end;local function n(j,k,l,m)return l*b(j/m,2)+k end;local function o(j,k,l,m)j=j/m;return-l*j*(j-2)+k end;local function p(j,k,l,m)j=j/m*2;if j<1 then return l/2*b(j,2)+k end;return-l/2*((j-1)*(j-3)-1)+k end;local function q(j,k,l,m)if j<m/2 then return o(j*2,k,l/2,m)end;return n(j*2-m,k+l/2,l/2,m)end;local function r(j,k,l,m)return l*b(j/m,3)+k end;local function s(j,k,l,m)return l*(b(j/m-1,3)+1)+k end;local function t(j,k,l,m)j=j/m*2;if j<1 then return l/2*j*j*j+k end;j=j-2;return l/2*(j*j*j+2)+k end;local function u(j,k,l,m)if j<m/2 then return s(j*2,k,l/2,m)end;return r(j*2-m,k+l/2,l/2,m)end;local function v(j,k,l,m)return l*b(j/m,4)+k end;local function w(j,k,l,m)return-l*(b(j/m-1,4)-1)+k end;local function x(j,k,l,m)j=j/m*2;if j<1 then return l/2*b(j,4)+k end;return-l/2*(b(j-2,4)-2)+k end;local function y(j,k,l,m)if j<m/2 then return w(j*2,k,l/2,m)end;return v(j*2-m,k+l/2,l/2,m)end;local function z(j,k,l,m)return l*b(j/m,5)+k end;local function A(j,k,l,m)return l*(b(j/m-1,5)+1)+k end;local function B(j,k,l,m)j=j/m*2;if j<1 then return l/2*b(j,5)+k end;return l/2*(b(j-2,5)+2)+k end;local function C(j,k,l,m)if j<m/2 then return A(j*2,k,l/2,m)end;return z(j*2-m,k+l/2,l/2,m)end;local function D(j,k,l,m)return-l*d(j/m*e/2)+l+k end;local function E(j,k,l,m)return l*c(j/m*e/2)+k end;local function F(j,k,l,m)return-l/2*(d(e*j/m)-1)+k end;local function G(j,k,l,m)if j<m/2 then return E(j*2,k,l/2,m)end;return D(j*2-m,k+l/2,l/2,m)end;local function H(j,k,l,m)if j==0 then return k end;return l*b(2,10*(j/m-1))+k-l*0.001 end;local function I(j,k,l,m)if j==m then return k+l end;return l*1.001*(-b(2,-10*j/m)+1)+k end;local function J(j,k,l,m)if j==0 then return k end;if j==m then return k+l end;j=j/m*2;if j<1 then return l/2*b(2,10*(j-1))+k-l*0.0005 end;return l/2*1.0005*(-b(2,-10*(j-1))+2)+k end;local function K(j,k,l,m)if j<m/2 then return I(j*2,k,l/2,m)end;return H(j*2-m,k+l/2,l/2,m)end;local function L(j,k,l,m)return-l*(f(1-b(j/m,2))-1)+k end;local function M(j,k,l,m)return l*f(1-b(j/m-1,2))+k end;local function N(j,k,l,m)j=j/m*2;if j<1 then return-l/2*(f(1-j*j)-1)+k end;j=j-2;return l/2*(f(1-j*j)+1)+k end;local function O(j,k,l,m)if j<m/2 then return M(j*2,k,l/2,m)end;return L(j*2-m,k+l/2,l/2,m)end;local function P(Q,R,l,m)Q,R=Q or m*0.3,R or 0;if R<g(l)then return Q,l,Q/4 end;return Q,R,Q/(2*e)*h(l/R)end;local function S(j,k,l,m,R,Q)local T;if j==0 then return k end;j=j/m;if j==1 then return k+l end;Q,R,T=P(Q,R,l,m)j=j-1;return-(R*b(2,10*j)*c((j*m-T)*2*e/Q))+k end;local function U(j,k,l,m,R,Q)local T;if j==0 then return k end;j=j/m;if j==1 then return k+l end;Q,R,T=P(Q,R,l,m)return R*b(2,-10*j)*c((j*m-T)*2*e/Q)+l+k end;local function V(j,k,l,m,R,Q)local T;if j==0 then return k end;j=j/m*2;if j==2 then return k+l end;Q,R,T=P(Q,R,l,m)j=j-1;if j<0 then return-0.5*R*b(2,10*j)*c((j*m-T)*2*e/Q)+k end;return R*b(2,-10*j)*c((j*m-T)*2*e/Q)*0.5+l+k end;local function W(j,k,l,m,R,Q)if j<m/2 then return U(j*2,k,l/2,m,R,Q)end;return S(j*2-m,k+l/2,l/2,m,R,Q)end;local function X(j,k,l,m,T)T=T or 1.70158;j=j/m;return l*j*j*((T+1)*j-T)+k end;local function Y(j,k,l,m,T)T=T or 1.70158;j=j/m-1;return l*(j*j*((T+1)*j+T)+1)+k end;local function Z(j,k,l,m,T)T=(T or 1.70158)*1.525;j=j/m*2;if j<1 then return l/2*j*j*((T+1)*j-T)+k end;j=j-2;return l/2*(j*j*((T+1)*j+T)+2)+k end;local function _(j,k,l,m,T)if j<m/2 then return Y(j*2,k,l/2,m,T)end;return X(j*2-m,k+l/2,l/2,m,T)end;local function a0(j,k,l,m)j=j/m;if j<1/2.75 then return l*7.5625*j*j+k end;if j<2/2.75 then j=j-1.5/2.75;return l*(7.5625*j*j+0.75)+k elseif j<2.5/2.75 then j=j-2.25/2.75;return l*(7.5625*j*j+0.9375)+k end;j=j-2.625/2.75;return l*(7.5625*j*j+0.984375)+k end;local function a1(j,k,l,m)return l-a0(m-j,0,l,m)+k end;local function a2(j,k,l,m)if j<m/2 then return a1(j*2,0,l,m)*0.5+k end;return a0(j*2-m,0,l,m)*0.5+l*.5+k end;local function a3(j,k,l,m)if j<m/2 then return a0(j*2,k,l/2,m)end;return a1(j*2-m,k+l/2,l/2,m)end;a.easing={linear=i,inQuad=n,outQuad=o,inOutQuad=p,outInQuad=q,inCubic=r,outCubic=s,inOutCubic=t,outInCubic=u,inQuart=v,outQuart=w,inOutQuart=x,outInQuart=y,inQuint=z,outQuint=A,inOutQuint=B,outInQuint=C,inSine=D,outSine=E,inOutSine=F,outInSine=G,inExpo=H,outExpo=I,inOutExpo=J,outInExpo=K,inCirc=L,outCirc=M,inOutCirc=N,outInCirc=O,inElastic=S,outElastic=U,inOutElastic=V,outInElastic=W,inBack=X,outBack=Y,inOutBack=Z,outInBack=_,inBounce=a1,outBounce=a0,inOutBounce=a2,outInBounce=a3}local function a4(a5,a6,a7)a7=a7 or a6;local a8=getmetatable(a6)if a8 and getmetatable(a5)==nil then setmetatable(a5,a8)end;for a9,aa in pairs(a6)do if type(aa)=="table"then a5[a9]=a4({},aa,a7[a9])else a5[a9]=a7[a9]end end;return a5 end;local function ab(ac,ad,ae)ae=ae or{}local af,ag;for a9,ah in pairs(ad)do af,ag=type(ah),a4({},ae)table.insert(ag,tostring(a9))if af=="number"then assert(type(ac[a9])=="number","Parameter '"..table.concat(ag,"/").."' is missing from subject or isn't a number")elseif af=="table"then ab(ac[a9],ah,ag)else assert(af=="number","Parameter '"..table.concat(ag,"/").."' must be a number or table of numbers")end end end;local function ai(aj,ac,ad,ak)assert(type(aj)=="number"and aj>0,"duration must be a positive number. Was "..tostring(aj))local al=type(ac)assert(al=="table"or al=="userdata","subject must be a table or userdata. Was "..tostring(ac))assert(type(ad)=="table","target must be a table. Was "..tostring(ad))assert(type(ak)=="function","easing must be a function. Was "..tostring(ak))ab(ac,ad)end;local function am(ak)ak=ak or"linear"if type(ak)=="string"then local an=ak;ak=a.easing[an]if type(ak)~="function"then error("The easing function name '"..an.."' is invalid")end end;return ak end;local function ao(ac,ad,ap,aq,aj,ak)local j,k,l,m;for a9,aa in pairs(ad)do if type(aa)=="table"then ao(ac[a9],aa,ap[a9],aq,aj,ak)else j,k,l,m=aq,ap[a9],aa-ap[a9],aj;ac[a9]=ak(j,k,l,m)end end end;local ar={}local as={__index=ar}function ar:set(aq)assert(type(aq)=="number","clock must be a positive number or 0")self.initial=self.initial or a4({},self.target,self.subject)self.clock=aq;if self.clock<=0 then self.clock=0;a4(self.subject,self.initial)elseif self.clock>=self.duration then self.clock=self.duration;a4(self.subject,self.target)else ao(self.subject,self.target,self.initial,self.clock,self.duration,self.easing)end;return self.clock>=self.duration end;function ar:reset()return self:set(0)end;function ar:update(at)assert(type(at)=="number","dt must be a number")return self:set(self.clock+at)end;function a.new(aj,ac,ad,ak)ak=am(ak)ai(aj,ac,ad,ak)return setmetatable({duration=aj,subject=ac,target=ad,easing=ak,clock=0},as)end;return a end)()

local tween_tbl = { }
local tween_data = { 
    scoped = 0,
    indicator_alpha = 0,
}

local screen_x, screen_y = client.screen_size()

local vars = { } do
    vars.anti_aim = { }

    vars.anti_aim.states = {"Shared", "Standing", "Moving", "Air", "Air+", "Crouching", "Crouching+", "Slow-Walking", "Freestand", "Manual Yaw"}
    vars.anti_aim.references = {
        pitch = {'Off', 'Default', 'Up', 'Down', 'Minimal', 'Random'},
        yaw = {'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'},
        yaw_base = {"Local view", "At targets"},
        elements = {
            anti_aim = {pui.reference("AA", "Anti-aimbot angles", "Enabled")},
            pitch = {pui.reference("AA", "Anti-aimbot angles", "Pitch")},
            yaw = {pui.reference("AA", "Anti-aimbot angles", "Yaw")},
            yawbase = pui.reference("AA", "Anti-aimbot angles", "Yaw Base"),
            yawjitter = { pui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
            bodyyaw = { pui.reference("AA", "Anti-aimbot angles", "Body yaw") },
            fs_body_yaw = pui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
            roll = pui.reference("AA", "Anti-aimbot angles", "Roll"),
            freeStand = pui.reference("AA", "Anti-aimbot angles", "Freestanding"),
            edgeyaw = pui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
            fake_duck = pui.reference("RAGE", "Other", "Duck peek assist"),
            slow_motion = pui.reference("AA", "Other", "Slow motion"),
            fake_lag = {
                enabled = pui.reference("AA", "Fake lag", "Enabled"),
                amount = pui.reference("AA", "Fake lag", "Amount"),
                variance = pui.reference("AA", "Fake lag", "Variance"),
                limit = pui.reference("AA", "Fake lag", "Limit"),
            },
            other = {
                leg_movement = pui.reference("AA", "Other", "Leg movement"),
                os_aa = pui.reference("AA", "Other", "On shot anti-aim"),
                fake_peek = pui.reference("AA", "Other", "Fake peek"),
            },
        },
    }

    vars.rage_bot = { }
    vars.rage_bot.references = {
        double_tap = {pui.reference('RAGE', 'Aimbot', 'Double tap')},
        hide_shots = pui.reference('AA', 'Other', 'On shot anti-aim'),
        minimum_damage = {pui.reference('RAGE', 'Aimbot', 'Minimum damage')},
        minimum_damage_override = {pui.reference('RAGE', 'Aimbot', 'Minimum damage override')}
    }

    vars.visuals = { }
    vars.visuals.references = {
        scope_overlay = pui.reference('VISUALS', 'Effects', 'Remove scope overlay'),
    }
end

local menu = { } do
    menu.tabs_path = {
        anti_aim = {
            general = pui.group("AA", "Anti-aimbot angles"),
            fake_lag = pui.group("AA", "Fake lag"),
            other = pui.group("AA", "Other"),
        }
    }

    menu.nyahook_label = menu.tabs_path.anti_aim.fake_lag:label("Welcome to \vNyaHook!")
    menu.user = menu.tabs_path.anti_aim.fake_lag:label("User: \vdsajh2")
    menu.branch = menu.tabs_path.anti_aim.fake_lag:label("Branch: \vDebug")
    menu.tab_switcher = menu.tabs_path.anti_aim.fake_lag:combobox("▪ Select \vtab", {"Home", "Anti-aim", "Other"})

    menu.watermark_color_label = menu.tabs_path.anti_aim.fake_lag:label("\vWatermark\r ~ color"):depend({ menu.tab_switcher, "Other" })
    menu.watermark_color = menu.tabs_path.anti_aim.fake_lag:color_picker("\vWatermark\r ~ color", 255, 255, 255, 255):depend({ menu.tab_switcher, "Other" })

    menu.line_1 = menu.tabs_path.anti_aim.fake_lag:label("\v───────────────────────────────"):depend({ menu.tab_switcher, "Anti-aim" })

    menu.line_2 = menu.tabs_path.anti_aim.fake_lag:label("\v───────────────────────────────"):depend({ menu.tab_switcher, "Other" })

    menu.configs = { } do
        menu.configs.list = menu.tabs_path.anti_aim.general:listbox("\n", {})
        menu.configs.name = menu.tabs_path.anti_aim.general:textbox("\n")
        menu.configs.create = menu.tabs_path.anti_aim.general:button("Create", function() end)
        menu.configs.load = menu.tabs_path.anti_aim.general:button("Load", function() end)
        menu.configs.save = menu.tabs_path.anti_aim.general:button("Save", function() end)
        menu.configs.delete = menu.tabs_path.anti_aim.general:button("Delete", function() end)
        menu.configs.import = menu.tabs_path.anti_aim.general:button("Import", function() end)
        menu.configs.export = menu.tabs_path.anti_aim.general:button("Export", function() end)
    end

    menu.anti_aim = { } do
        menu.anti_aim.current_state = menu.tabs_path.anti_aim.general:combobox("State", vars.anti_aim.states)

        menu.anti_aim.manual_yaw_left = menu.tabs_path.anti_aim.other:hotkey("Left")
        menu.anti_aim.manual_yaw_right = menu.tabs_path.anti_aim.other:hotkey("Right")
        menu.anti_aim.manual_yaw_forward = menu.tabs_path.anti_aim.other:hotkey("Forward")
        menu.anti_aim.freestand_hotkey = menu.tabs_path.anti_aim.other:hotkey("Freestand")
    
        menu.anti_aim.tweaks = menu.tabs_path.anti_aim.other:multiselect("Tweaks", {"Avoid backstab", "Fast ladder", "Safe head"})
    
        menu.anti_aim.avoid_backstab_distance = menu.tabs_path.anti_aim.other:slider("\vAvoid backstab\r ~ Distance", 150, 400, 250, true, "ft", 1)
    
        menu.anti_aim.safe_head_states = menu.tabs_path.anti_aim.other:multiselect("\vSafe head\r ~ States", {"Knife", "Taser", "Above enemy"})
        menu.anti_aim.e_spam = menu.tabs_path.anti_aim.other:checkbox("\vSafe head\r ~ E-Spam")
        menu.anti_aim.height_difference = menu.tabs_path.anti_aim.other:slider("\vSafe head\r ~ Height difference", 50, 150, 70, true, "ft", 1)
    end

    menu.anti_aim.builder = { }

    for k, v in ipairs(vars.anti_aim.states) do
        menu.anti_aim.builder[k] = {
            enable_state = menu.tabs_path.anti_aim.general:checkbox("Enable \v" .. vars.anti_aim.states[k]),
            pitch = menu.tabs_path.anti_aim.general:combobox("Pitch\n" .. vars.anti_aim.states[k], vars.anti_aim.references.pitch),
            yaw_amount = menu.tabs_path.anti_aim.general:slider("Yaw Amount\n" .. vars.anti_aim.states[k], -180, 180, 0, true, "°", 1),
            flick_yaw = menu.tabs_path.anti_aim.general:checkbox("\vYaw\r ~ Flick\n" .. vars.anti_aim.states[k]),
            flick_yaw_amount = menu.tabs_path.anti_aim.general:slider("\vFlick\r ~ Amount\n" .. vars.anti_aim.states[k], -180, 180, 0, true, "°", 1),
            crooked_yaw = menu.tabs_path.anti_aim.general:checkbox("\vCrooked\r yaw\n" .. vars.anti_aim.states[k]),
            crooked_yaw_amount = menu.tabs_path.anti_aim.general:slider("\vCrooked\r ~ Amount\n" .. vars.anti_aim.states[k], -180, 180, 0, true, "°", 1),
            add_left_right = menu.tabs_path.anti_aim.general:checkbox("Add \vleft/right\n" .. vars.anti_aim.states[k]),
            left_right_type = menu.tabs_path.anti_aim.general:combobox("\vLeft/right\r ~ Type\n" .. vars.anti_aim.states[k], {"Default", "Phases"}),

            yaw_left_phase_1 = menu.tabs_path.anti_aim.general:slider("\vPhase 1\r ~ Add Left\n" .. vars.anti_aim.states[k], -180, 180, 0, true, "°", 1),
            yaw_right_phase_1 = menu.tabs_path.anti_aim.general:slider("\vPhase 1\r ~ Add Right\n" .. vars.anti_aim.states[k], -180, 180, 0, true, "°", 1),

            yaw_left_phase_2 = menu.tabs_path.anti_aim.general:slider("\vPhase 2\r ~ Add Left\n" .. vars.anti_aim.states[k], -180, 180, 0, true, "°", 1),
            yaw_right_phase_2 = menu.tabs_path.anti_aim.general:slider("\vPhase 2\r ~ Add Right\n" .. vars.anti_aim.states[k], -180, 180, 0, true, "°", 1),

            yaw_left_phase_3 = menu.tabs_path.anti_aim.general:slider("\vPhase 3\r ~ Add Left\n" .. vars.anti_aim.states[k], -180, 180, 0, true, "°", 1),
            yaw_right_phase_3 = menu.tabs_path.anti_aim.general:slider("\vPhase 3\r ~ Add Right\n" .. vars.anti_aim.states[k], -180, 180, 0, true, "°", 1),

            phase_speed = menu.tabs_path.anti_aim.general:slider("\vPhase\r ~ Switch Speed\n" .. vars.anti_aim.states[k], 1, 10, 1, true, "", 1, {[1] = "Default"}),

            yaw_left = menu.tabs_path.anti_aim.general:slider("Add Left\n" .. vars.anti_aim.states[k], -180, 180, 0, true, "°", 1),
            yaw_right = menu.tabs_path.anti_aim.general:slider("Add Right\n" .. vars.anti_aim.states[k], -180, 180, 0, true, "°", 1),

            yaw_randomize = menu.tabs_path.anti_aim.general:slider("Randomize\n" .. vars.anti_aim.states[k], 0, 100, 0, true, "%", 1),
            yaw_jitter = menu.tabs_path.anti_aim.general:combobox("Yaw jitter\n" .. vars.anti_aim.states[k], {"Off", "Center", "Random"}),
            yaw_jitter_amount = menu.tabs_path.anti_aim.general:slider("\n \n" .. vars.anti_aim.states[k], -180, 180, 0, true, "°", 1),
            body_yaw = menu.tabs_path.anti_aim.general:combobox("Body yaw\n" .. vars.anti_aim.states[k], {"Off", "Opposite", "Jitter", "Static"}),
            jitter_delay = menu.tabs_path.anti_aim.general:slider("Jitter Delay\n" .. vars.anti_aim.states[k], 1, 15, 0, true, "t", 1, {[1] = "Gamesense"}),
            hold_ticks = menu.tabs_path.anti_aim.general:slider("Hold ticks\n" .. vars.anti_aim.states[k], 1, 50, 0, true, "t", 1, {[1] = "Disabled"}),
            jitter_delay_randomize = menu.tabs_path.anti_aim.general:slider("Randomize Delay\n" .. vars.anti_aim.states[k], 1, 15, 0, true, "t", 1, {[1] = "Disabled"}),
            force_defensive = menu.tabs_path.anti_aim.general:checkbox("Force defensive\n" .. vars.anti_aim.states[k]),

            defensive_aa = menu.tabs_path.anti_aim.fake_lag:checkbox("\vDefensive\r AA\n" .. vars.anti_aim.states[k]),

            defensive_pitch = menu.tabs_path.anti_aim.fake_lag:combobox("\vDefensive\r ~ Pitch\n" .. vars.anti_aim.states[k], {"Disabled", "Down", "Up", "Random"}),
            defensive_pitch_random_1 = menu.tabs_path.anti_aim.fake_lag:slider("\vRandom\r ~ Min\n" .. vars.anti_aim.states[k], -89, 89, 0, true, "°"),
            defensive_pitch_random_2 = menu.tabs_path.anti_aim.fake_lag:slider("\vRandom\r ~ Max\n" .. vars.anti_aim.states[k], -89, 89, 0, true, "°"),

            defensive_yaw = menu.tabs_path.anti_aim.fake_lag:combobox("\vDefensive\r ~ Yaw\n" .. vars.anti_aim.states[k], {"Sideways", "Side-based", "Spin", "Random"}),
            defensive_yaw_left_yaw = menu.tabs_path.anti_aim.fake_lag:slider("\vSide-based\r ~ Left Yaw\n" .. vars.anti_aim.states[k], -180, 180, 0, true, "°", 1),
            defensive_yaw_right_yaw = menu.tabs_path.anti_aim.fake_lag:slider("\vSide-based\r ~ Right Yaw\n" .. vars.anti_aim.states[k], -180, 180, 0, true, "°", 1),
            defensive_yaw_spin_speed = menu.tabs_path.anti_aim.fake_lag:slider("\vSpin\r ~ Speed\n" .. vars.anti_aim.states[k], 1, 15, 1, true, "", 1),
            defensive_yaw_random_1 = menu.tabs_path.anti_aim.fake_lag:slider("\vRandom\r ~ Min\n" .. vars.anti_aim.states[k] .. "_yaw", -180, 180, 0, true, "°", 1),
            defensive_yaw_random_2 = menu.tabs_path.anti_aim.fake_lag:slider("\vRandom\r ~ Max\n" .. vars.anti_aim.states[k] .. "_yaw", -180, 180, 0, true, "°", 1)
        }
    end

    menu.other = { } do 
        menu.other.visuals = { } do
            menu.other.visuals.crosshair_indicators = menu.tabs_path.anti_aim.general:checkbox("Crosshair indicators")
            menu.other.visuals.crosshair_indicators_color = menu.tabs_path.anti_aim.general:color_picker("\nCrosshair indicators", 255, 255, 255, 255)
            menu.other.visuals.crosshair_indicators_offset = menu.tabs_path.anti_aim.general:slider("\vCrosshair indicators\r ~ Offset", 15, 100, 0)
        
            menu.other.visuals.damage_indicator = menu.tabs_path.anti_aim.general:checkbox("Damage indicator")
        
            menu.other.visuals.manual_arrows = menu.tabs_path.anti_aim.general:checkbox("Manual Arrows")
            menu.other.visuals.manual_arrows_style = menu.tabs_path.anti_aim.general:combobox("\vManual Arrows\r ~ Style", {"Classic", "Modern"})
            menu.other.visuals.manual_arrows_color = menu.tabs_path.anti_aim.general:color_picker("\vManual Arrows\r ~ Color", 255, 255, 255, 255)
        
            menu.other.visuals.cross_marker = menu.tabs_path.anti_aim.general:checkbox("Cross marker")
        
            menu.other.visuals.custom_scope_overlay = menu.tabs_path.anti_aim.general:checkbox("Custom scope overlay")
            menu.other.visuals.custom_scope_overlay_color = menu.tabs_path.anti_aim.general:color_picker("\vCustom scope overlay\r ~ Color", 255, 255, 255, 255)
            menu.other.visuals.custom_scope_overlay_gap = menu.tabs_path.anti_aim.general:slider("\vCustom scope overlay\r ~ Gap", 0, 50, 5)
            menu.other.visuals.custom_scope_overlay_size = menu.tabs_path.anti_aim.general:slider("\vCustom scope overlay\r ~ Size", 15, 300, 100)
        end
    
        menu.other.misc = { } do
            menu.other.misc.aimbot_logs = menu.tabs_path.anti_aim.other:checkbox("Aimbot logs")
            menu.other.misc.notify_output = menu.tabs_path.anti_aim.other:checkbox("\vAimbot logs\r ~ notify output")
            menu.other.misc.hit_color_label = menu.tabs_path.anti_aim.other:label("\vNotify\r ~ Hit color")
            menu.other.misc.hit_color = menu.tabs_path.anti_aim.other:color_picker("\vNotify\r ~ Hit color", 255, 255, 255, 255)
            menu.other.misc.miss_color_label = menu.tabs_path.anti_aim.other:label("\vNotify\r ~ Miss color")
            menu.other.misc.miss_color = menu.tabs_path.anti_aim.other:color_picker("\vNotify\r ~ Miss color", 255, 255, 255, 255)

            menu.other.misc.animations = menu.tabs_path.anti_aim.other:checkbox("Animations")
            menu.other.misc.ground_legs = menu.tabs_path.anti_aim.other:combobox("\vAnimations\r ~ Ground legs", {"Walking", "Jitter", "Moonwalk"})
            menu.other.misc.ground_legs_type = menu.tabs_path.anti_aim.other:combobox("\vGround legs\r ~ Type", {"Full", "Randomized", "Flex"})
            menu.other.misc.air_legs = menu.tabs_path.anti_aim.other:combobox("\vAnimations\r ~ Air legs", {"Disabled", "Static", "Jitter", "Moonwalk"})
            menu.other.misc.addons = menu.tabs_path.anti_aim.other:multiselect("\vAnimations\r ~ Addons", {"Body Lean", "Earthquake", "Pitch 0 on land"})

            menu.other.misc.console_filter = menu.tabs_path.anti_aim.other:checkbox("Console filter")

            menu.other.misc.jitter_correction = menu.tabs_path.anti_aim.fake_lag:checkbox("Jitter \vcorrection\r")
            menu.other.misc.jitter_correction_debug = menu.tabs_path.anti_aim.fake_lag:checkbox("\vJitter correction\r ~ Debug")
            menu.other.misc.jitter_correction_mode = menu.tabs_path.anti_aim.fake_lag:combobox("\vJitter correction\r ~ Mode", {"Default", "Experiemental"})
        end
    end

    local menu_depends do
        for k, v in ipairs(vars.anti_aim.states) do
            local is_state = { menu.anti_aim.current_state, vars.anti_aim.states[k] }
            local is_state_enabled = { menu.anti_aim.builder[k].enable_state, function() if k == 1 then return true else return menu.anti_aim.builder[k].enable_state.value end end }
            local can_enable_state = { menu.anti_aim.builder[k].enable_state, function() return k ~= 1 end }

            local is_flicking = { menu.anti_aim.builder[k].flick_yaw, true }

            local is_crooked = { menu.anti_aim.builder[k].crooked_yaw, true }
    
            local is_left_right = { menu.anti_aim.builder[k].add_left_right, true }

            local is_left_right_default = { menu.anti_aim.builder[k].left_right_type, "Default" }
            local is_left_right_phase = { menu.anti_aim.builder[k].left_right_type, "Phases" }
    
            local is_jitter = { menu.anti_aim.builder[k].yaw_jitter, function() return menu.anti_aim.builder[k].yaw_jitter.value ~= "Off" end }
    
            local is_body_yaw = { menu.anti_aim.builder[k].body_yaw, function() return menu.anti_aim.builder[k].body_yaw.value ~= "Off" end }
            local is_jitter_body = { menu.anti_aim.builder[k].body_yaw, function() return menu.anti_aim.builder[k].body_yaw.value == "Jitter" end }

            local is_defensive_aa = { menu.anti_aim.builder[k].defensive_aa, true }
            local is_defensive_random_pitch = { menu.anti_aim.builder[k].defensive_pitch, "Random" }
            local is_defensive_random_yaw = { menu.anti_aim.builder[k].defensive_yaw, "Random" }
            local is_defensive_side_based = { menu.anti_aim.builder[k].defensive_yaw, "Side-based" }
            local is_defensive_spin = { menu.anti_aim.builder[k].defensive_yaw, "Spin" }
    
            menu.anti_aim.builder[k].enable_state:depend( is_state, can_enable_state )
            menu.anti_aim.builder[k].pitch:depend( is_state, is_state_enabled )
            menu.anti_aim.builder[k].yaw_amount:depend( is_state, is_state_enabled )
            menu.anti_aim.builder[k].flick_yaw:depend( is_state, is_state_enabled )
            menu.anti_aim.builder[k].flick_yaw_amount:depend( is_state, is_state_enabled, is_flicking )
            menu.anti_aim.builder[k].crooked_yaw:depend( is_state, is_state_enabled )
            menu.anti_aim.builder[k].crooked_yaw_amount:depend( is_state, is_state_enabled, is_crooked )
            menu.anti_aim.builder[k].add_left_right:depend( is_state, is_state_enabled )
            menu.anti_aim.builder[k].left_right_type:depend( is_state, is_state_enabled ) do
                menu.anti_aim.builder[k].yaw_left_phase_1:depend( is_state, is_state_enabled, is_left_right, is_left_right_phase )
                menu.anti_aim.builder[k].yaw_right_phase_1:depend( is_state, is_state_enabled, is_left_right, is_left_right_phase )

                menu.anti_aim.builder[k].yaw_left_phase_2:depend( is_state, is_state_enabled, is_left_right, is_left_right_phase )
                menu.anti_aim.builder[k].yaw_right_phase_2:depend( is_state, is_state_enabled, is_left_right, is_left_right_phase )

                menu.anti_aim.builder[k].yaw_left_phase_3:depend( is_state, is_state_enabled, is_left_right, is_left_right_phase )
                menu.anti_aim.builder[k].yaw_right_phase_3:depend( is_state, is_state_enabled, is_left_right, is_left_right_phase )

                menu.anti_aim.builder[k].phase_speed:depend( is_state, is_state_enabled, is_left_right, is_left_right_phase )

                menu.anti_aim.builder[k].yaw_left:depend( is_state, is_state_enabled, is_left_right, is_left_right_default )
                menu.anti_aim.builder[k].yaw_right:depend( is_state, is_state_enabled, is_left_right, is_left_right_default )
            end
            menu.anti_aim.builder[k].yaw_randomize:depend( is_state, is_state_enabled, is_left_right )
            menu.anti_aim.builder[k].yaw_jitter:depend( is_state, is_state_enabled )
            menu.anti_aim.builder[k].yaw_jitter_amount:depend( is_state, is_state_enabled, is_jitter )
            menu.anti_aim.builder[k].body_yaw:depend( is_state, is_state_enabled )
            menu.anti_aim.builder[k].jitter_delay:depend( is_state, is_state_enabled, is_body_yaw, is_jitter_body )
            menu.anti_aim.builder[k].hold_ticks:depend( is_state, is_state_enabled, is_body_yaw, is_jitter_body )
            menu.anti_aim.builder[k].jitter_delay_randomize:depend( is_state, is_state_enabled, is_body_yaw, is_jitter_body )
            menu.anti_aim.builder[k].force_defensive:depend( is_state, is_state_enabled )

            menu.anti_aim.builder[k].defensive_aa:depend( is_state, is_state_enabled ) do
                menu.anti_aim.builder[k].defensive_pitch:depend( is_state, is_state_enabled, is_defensive_aa )
                menu.anti_aim.builder[k].defensive_pitch_random_1:depend( is_state, is_state_enabled, is_defensive_aa, is_defensive_random_pitch )
                menu.anti_aim.builder[k].defensive_pitch_random_2:depend( is_state, is_state_enabled, is_defensive_aa, is_defensive_random_pitch )
                menu.anti_aim.builder[k].defensive_yaw:depend( is_state, is_state_enabled, is_defensive_aa )
                menu.anti_aim.builder[k].defensive_yaw_left_yaw:depend( is_state, is_state_enabled, is_defensive_aa, is_defensive_side_based )
                menu.anti_aim.builder[k].defensive_yaw_right_yaw:depend( is_state, is_state_enabled, is_defensive_aa, is_defensive_side_based )
                menu.anti_aim.builder[k].defensive_yaw_spin_speed:depend( is_state, is_state_enabled, is_defensive_aa, is_defensive_spin )
                menu.anti_aim.builder[k].defensive_yaw_random_1:depend( is_state, is_state_enabled, is_defensive_aa, is_defensive_random_yaw )
                menu.anti_aim.builder[k].defensive_yaw_random_2:depend( is_state, is_state_enabled, is_defensive_aa, is_defensive_random_yaw )
            end
        end

        menu.anti_aim.avoid_backstab_distance:depend({ menu.anti_aim.tweaks, "Avoid backstab" })

        menu.anti_aim.safe_head_states:depend({ menu.anti_aim.tweaks, "Safe head" })
        menu.anti_aim.e_spam:depend({ menu.anti_aim.tweaks, "Safe head" })
        menu.anti_aim.height_difference:depend({ menu.anti_aim.tweaks, "Safe head" }, { menu.anti_aim.safe_head_states, "Above enemy" })
    
        menu.other.visuals.crosshair_indicators_color:depend({ menu.other.visuals.crosshair_indicators, true })
        menu.other.visuals.crosshair_indicators_offset:depend({ menu.other.visuals.crosshair_indicators, true })
    
        menu.other.visuals.manual_arrows_style:depend({ menu.other.visuals.manual_arrows, true })
        menu.other.visuals.manual_arrows_color:depend({ menu.other.visuals.manual_arrows, true })
    
        menu.other.visuals.custom_scope_overlay_gap:depend({ menu.other.visuals.custom_scope_overlay, true })
        menu.other.visuals.custom_scope_overlay_size:depend({ menu.other.visuals.custom_scope_overlay, true })
        menu.other.visuals.custom_scope_overlay_color:depend({ menu.other.visuals.custom_scope_overlay, true })
    
        menu.other.misc.notify_output:depend({ menu.other.misc.aimbot_logs, true })
        menu.other.misc.hit_color_label:depend({ menu.other.misc.aimbot_logs, true }, { menu.other.misc.notify_output, true })
        menu.other.misc.miss_color_label:depend({ menu.other.misc.aimbot_logs, true }, { menu.other.misc.notify_output, true })
        menu.other.misc.hit_color:depend({ menu.other.misc.aimbot_logs, true }, { menu.other.misc.notify_output, true })
        menu.other.misc.miss_color:depend({ menu.other.misc.aimbot_logs, true }, { menu.other.misc.notify_output, true })

        menu.other.misc.ground_legs:depend({ menu.other.misc.animations, true })
        menu.other.misc.ground_legs_type:depend({ menu.other.misc.animations, true }, { menu.other.misc.ground_legs, "Jitter" })
        menu.other.misc.air_legs:depend({ menu.other.misc.animations, true })
        menu.other.misc.addons:depend({ menu.other.misc.animations, true })

        menu.other.misc.jitter_correction_debug:depend({ menu.other.misc.jitter_correction, true })
        menu.other.misc.jitter_correction_mode:depend({ menu.other.misc.jitter_correction, true })
    end
end

local anti_aim = { } do
    anti_aim.data = {
        state_id = 0,
        inverter = false,
        ticks = 0,
        switch = false,
        crooked_adapter = 0,
        default_yaw_amount = 0,
        add_left_yaw = 0,
        add_right_yaw = 0,
        delay_value = 0,
        hold_ticks_value = 0,
        yaw_spin_speed = 0,
        manual_yaw_direction = 0,
        last_pushed_button = 0,
        pitch = {
            types = "Off",
            custom_amount = 0
        },
        yaw = {
            base = "At targets",
            type = "Off",
            degree = 0,
            jitter = {
                type = "Off",
                amount = 0
            }
        },
        body_yaw = {
            type = "Off",
            amount = 0
        },
        freestanding = false
    }

    anti_aim.condition_func = 
    { 
        onground_ticks = 0,
        in_air = function (indx)
            flags = entity.get_prop(indx, "m_fFlags")

            return bit.band(flags, 1) == 0
        end,
        is_onground = function(indx)
            local animstate = ffi_helpers.animstate:get(indx)
            if not animstate then return true end

            local ptr_addr = ffi.cast('uintptr_t', ffi.cast('void*', animstate))
            local landed_on_ground_this_frame = ffi.cast('bool*', ptr_addr + 0x120)[0] --- @offset

            return animstate.on_ground and not landed_on_ground_this_frame
        end,
        velocity = function(indx)
            vel_x, vel_y = entity.get_prop(indx, "m_vecVelocity")
            local velocity = math.sqrt(vel_x * vel_x + vel_y * vel_y)
            
            return velocity
        end,
        is_crouching = function (indx)
            return entity.get_prop(indx, "m_flDuckAmount") > 0.8
        end
    }

    anti_aim.get_desync_side = function(cmd)
        local lp = entity.get_local_player()
        if lp == nil then return end
    
        local body_yaw = entity.get_prop(lp, "m_flPoseParameter", 11) * 120 - 60
    
        return body_yaw > 0
    end

    anti_aim.get_state = function()
        local lp = entity.get_local_player()
        if lp == nil then return end

        if anti_aim.data.manual_yaw_direction ~= 0 then
            return 10
        end

        local freestand_hotkey = menu.anti_aim.freestand_hotkey:get()

        if freestand_hotkey then
            return 9
        end

        if not anti_aim.condition_func.is_onground(lp) then
            if anti_aim.condition_func.is_crouching(lp) then
                return 5
            else
                return 4
            end
        end

        local fake_duck_state = vars.anti_aim.references.elements.fake_duck:get()

        if anti_aim.condition_func.is_crouching(lp) or fake_duck_state then
            if anti_aim.condition_func.velocity(lp) > 4 then
                return 7
            else
                return 6
            end
        end

        local slow_motion_state = vars.anti_aim.references.elements.slow_motion.hotkey:get()

        if slow_motion_state then
            return 8
        end

        if anti_aim.condition_func.is_onground(lp) and anti_aim.condition_func.velocity(lp) > 4 then
            return 3
        end

        return 2
    end

    anti_aim.exploit = { } do
        anti_aim.exploit.breaker = { }

        anti_aim.exploit.breaker.tick = 0
        anti_aim.exploit.breaker.cmd = 0
        anti_aim.exploit.breaker.check = 0

        anti_aim.exploit.get = function()
            local lp = entity.get_local_player()
            if not lp or not entity.is_alive(lp) then return end

            local doubletap_ref = vars.rage_bot.references.double_tap[1].value and vars.rage_bot.references.double_tap[1].hotkey:get()
            local osaa_ref = vars.rage_bot.references.hide_shots.value and vars.rage_bot.references.hide_shots.hotkey:get()

            local tickbase = globals.tickcount() - entity.get_prop(lp, "m_nTickBase")
            local is_exploiting = osaa_ref or (doubletap_ref and tickbase > 0)
            
            return is_exploiting
        end

        anti_aim.exploit.get_defensive = function()
            if false then
                if true then
                    if anti_aim.exploit.get() then
                        return anti_aim.exploit.breaker.tick
                    else
                        return 1
                    end
                else
                    return anti_aim.exploit.breaker.tick
                end
            else
                if true then
                    if anti_aim.exploit.get() then
                        return (anti_aim.exploit.breaker.tick > 1)
                    else
                        return false
                    end
                else
                    return (anti_aim.exploit.breaker.tick > 1)
                end
            end
        end
    end

    anti_aim.run = function(cmd)
        local lp = entity.get_local_player()
        if lp == nil or not entity.is_alive(lp) then return end

        local is_defensive = anti_aim.exploit.get_defensive() and menu.anti_aim.builder[state_id].defensive_aa.value

        state_id = anti_aim.get_state()

        if menu.anti_aim.builder[state_id].enable_state.value == false and state_id ~= 1 then
            state_id = 1
        end

        anti_aim.data.inverter = anti_aim.get_desync_side(cmd)

        anti_aim.data.delay_value = menu.anti_aim.builder[state_id].jitter_delay.value
            
        if menu.anti_aim.builder[state_id].hold_ticks.value > 1 then
            anti_aim.data.delay_value = globals.tickcount() % 50 > menu.anti_aim.builder[state_id].hold_ticks.value and 1 or menu.anti_aim.builder[state_id].jitter_delay.value
        end

        if menu.anti_aim.builder[state_id].jitter_delay.value > 1 then
            if globals.chokedcommands() == 0 then
                anti_aim.data.ticks = anti_aim.data.ticks + 1

                if anti_aim.data.ticks % (menu.anti_aim.builder[state_id].jitter_delay_randomize.value > 1 and (client.random_int(anti_aim.data.delay_value, menu.anti_aim.builder[state_id].jitter_delay_randomize.value)) or anti_aim.data.delay_value) == 0 then
                    anti_aim.data.switch = not anti_aim.data.switch
                end
            end

            anti_aim.data.inverter = anti_aim.data.switch
        end

        if not is_defensive then 
            if cmd.chokedcommands == 0 then
                anti_aim.data.pitch.types = menu.anti_aim.builder[state_id].pitch.value
                anti_aim.data.yaw.type = "180"
        
                local phase_time = math.floor(globals.realtime() * menu.anti_aim.builder[state_id].phase_speed.value) % 3
        
                if menu.anti_aim.builder[state_id].left_right_type.value == "Phases" then
                    if phase_time == 0 then
                        anti_aim.data.add_left_yaw = menu.anti_aim.builder[state_id].yaw_left_phase_1.value
                        anti_aim.data.add_right_yaw = menu.anti_aim.builder[state_id].yaw_right_phase_1.value
                    elseif phase_time == 1 then
                        anti_aim.data.add_left_yaw = menu.anti_aim.builder[state_id].yaw_left_phase_2.value
                        anti_aim.data.add_right_yaw = menu.anti_aim.builder[state_id].yaw_right_phase_2.value
                    elseif phase_time == 2 then
                        anti_aim.data.add_left_yaw = menu.anti_aim.builder[state_id].yaw_left_phase_3.value
                        anti_aim.data.add_right_yaw = menu.anti_aim.builder[state_id].yaw_right_phase_3.value
                    end
                else
                    anti_aim.data.add_left_yaw = menu.anti_aim.builder[state_id].yaw_left.value
                    anti_aim.data.add_right_yaw = menu.anti_aim.builder[state_id].yaw_right.value
                end
        
                local flick_time = globals.curtime() % 1
                
                anti_aim.data.default_yaw_amount = menu.anti_aim.builder[state_id].flick_yaw.value == true and (flick_time < 0.1 and menu.anti_aim.builder[state_id].flick_yaw_amount.value or menu.anti_aim.builder[state_id].yaw_amount.value) or menu.anti_aim.builder[state_id].yaw_amount.value
        
                if globals.chokedcommands() == 0 then
                    anti_aim.data.crooked_adapter = menu.anti_aim.builder[state_id].crooked_yaw.value == true and ((globals.tickcount() % 10 == 0 and (((-anti_aim.data.yaw.degree) / 2)) - 5 or client.random_float(0, menu.anti_aim.builder[state_id].crooked_yaw_amount.value)) / 2) or 0
        
                    if menu.anti_aim.builder[state_id].add_left_right:get() then
                        anti_aim.data.yaw.degree = (((anti_aim.data.inverter and anti_aim.data.add_left_yaw or anti_aim.data.add_right_yaw) + anti_aim.data.default_yaw_amount) + math.random(0, menu.anti_aim.builder[state_id].yaw_randomize.value / 2)) + anti_aim.data.crooked_adapter 
                    else
                        anti_aim.data.yaw.degree = anti_aim.data.default_yaw_amount + anti_aim.data.crooked_adapter
                    end
                
                    if menu.anti_aim.builder[state_id].yaw_jitter.value ~= "Off" then
                        if menu.anti_aim.builder[state_id].yaw_jitter.value == "Center" then
                            anti_aim.data.yaw.degree = (anti_aim.data.inverter and -menu.anti_aim.builder[state_id].yaw_jitter_amount.value / 2 or menu.anti_aim.builder[state_id].yaw_jitter_amount.value / 2) + anti_aim.data.yaw.degree
                        else
                            anti_aim.data.yaw.degree = (anti_aim.data.inverter and (-menu.anti_aim.builder[state_id].yaw_jitter_amount.value / 2 + math.random(0, 15)) or (menu.anti_aim.builder[state_id].yaw_jitter_amount.value / 2 - math.random(0, 15))) + anti_aim.data.yaw.degree
                        end
                    end 
                end
        
                if menu.anti_aim.builder[state_id].jitter_delay.value > 1 and menu.anti_aim.builder[state_id].body_yaw:get() == "Jitter" then
                    anti_aim.data.body_yaw.type = "Static"
                                    
                    if globals.chokedcommands() == 0 then
                        anti_aim.data.body_yaw.amount = anti_aim.data.inverter and -1 or 1
                    end
                else
                    anti_aim.data.body_yaw.type = menu.anti_aim.builder[state_id].body_yaw.value
                    anti_aim.data.body_yaw.amount = -1
                end
            end
        else
            if menu.anti_aim.builder[state_id].defensive_pitch.value == "Disabled" then
                anti_aim.data.pitch.types = "Off"
            elseif menu.anti_aim.builder[state_id].defensive_pitch.value == "Down" then
                anti_aim.data.pitch.types = "Down"
            elseif menu.anti_aim.builder[state_id].defensive_pitch.value == "Up" then
                anti_aim.data.pitch.types = "Up"
            elseif menu.anti_aim.builder[state_id].defensive_pitch.value == "Random" then
                anti_aim.data.pitch.types = "Custom"
                anti_aim.data.pitch.custom_amount = client.random_int(menu.anti_aim.builder[state_id].defensive_pitch_random_1.value, menu.anti_aim.builder[state_id].defensive_pitch_random_2.value)
            end

            if menu.anti_aim.builder[state_id].defensive_yaw.value == "Sideways" then
                anti_aim.data.yaw.degree = anti_aim.data.inverter and -90 or 90
            elseif menu.anti_aim.builder[state_id].defensive_yaw.value == "Side-based" then
                anti_aim.data.yaw.degree = anti_aim.data.inverter and menu.anti_aim.builder[state_id].defensive_yaw_left_yaw.value or menu.anti_aim.builder[state_id].defensive_yaw_right_yaw.value
            elseif menu.anti_aim.builder[state_id].defensive_yaw.value == "Spin" then
                anti_aim.data.yaw.type = "Spin"
                anti_aim.data.yaw.degree = menu.anti_aim.builder[state_id].defensive_yaw_spin_speed.value * 5
            elseif menu.anti_aim.builder[state_id].defensive_yaw.value == "Random" then
                anti_aim.data.yaw.degree = client.random_int(menu.anti_aim.builder[state_id].defensive_yaw_random_1.value, menu.anti_aim.builder[state_id].defensive_yaw_random_2.value)
            end
        end

        cmd.force_defensive = menu.anti_aim.builder[state_id].force_defensive.value

        anti_aim.data.freestanding = menu.anti_aim.freestand_hotkey:get() and true or false
        vars.anti_aim.references.elements.freeStand:set(anti_aim.data.freestanding)

        if anti_aim.data.freestanding then
            vars.anti_aim.references.elements.freeStand:set_hotkey("Always on")
        else
            vars.anti_aim.references.elements.freeStand:set_hotkey("On hotkey")
        end

        if anti_aim.data.manual_yaw_direction ~= 0 then
            vars.anti_aim.references.elements.freeStand:set(false)
        end

        if menu.anti_aim.manual_yaw_right:get() and anti_aim.data.last_pushed_button + 0.1 < globals.curtime() then
            anti_aim.data.manual_yaw_direction = anti_aim.data.manual_yaw_direction == 2 and 0 or 2
            anti_aim.data.last_pushed_button = globals.curtime()
        elseif menu.anti_aim.manual_yaw_left:get() and anti_aim.data.last_pushed_button + 0.1 < globals.curtime() then
            anti_aim.data.manual_yaw_direction = anti_aim.data.manual_yaw_direction == 1 and 0 or 1
            anti_aim.data.last_pushed_button = globals.curtime()
        elseif menu.anti_aim.manual_yaw_forward:get() and anti_aim.data.last_pushed_button + 0.1 < globals.curtime() then
            anti_aim.data.manual_yaw_direction = anti_aim.data.manual_yaw_direction == 3 and 0 or 3
            anti_aim.data.last_pushed_button = globals.curtime()
        elseif anti_aim.data.last_pushed_button > globals.curtime() then
            anti_aim.data.last_pushed_button = globals.curtime()
        end

        if anti_aim.data.manual_yaw_direction == 1 then
            anti_aim.data.yaw.degree = -90
        elseif anti_aim.data.manual_yaw_direction == 2 then
            anti_aim.data.yaw.degree = 90
        elseif anti_aim.data.manual_yaw_direction == 3 then
            anti_aim.data.yaw.degree = -180
        end

        --  @start ~ avoid-backstab stuff #_#
        anti_aim.avoid_backstab = { }

        anti_aim.avoid_backstab.run = function(cmd)
            if not menu.anti_aim.tweaks:get("Avoid backstab") then return end

            local lp = entity.get_local_player()
            if lp == nil or not entity.is_alive(lp) then return end

            local lp_threat = client.current_threat()
            if lp_threat == nil then return end

            local threat_weapon = entity.get_player_weapon(lp_threat)
            if threat_weapon == nil then return end

            local threat_origin = vector(entity.get_prop(lp_threat, "m_vecOrigin"))

            local lp_origin = vector(entity.get_prop(lp, "m_vecOrigin"))

            local dist = lp_origin:dist(threat_origin)

            local avoid_distance = menu.anti_aim.avoid_backstab_distance:get()

            if dist < avoid_distance and entity.get_classname(threat_weapon) == "CKnife" then
                anti_aim.data.yaw.base = "At targets"
                anti_aim.data.yaw.degree = -180
                anti_aim.data.freestanding = false

                cmd.force_defensive = false
            end
        end

        anti_aim.avoid_backstab.run(cmd)
        --  @end ~ avoid-backstab stuff #_#



        --  @start ~ safe head @_@
        anti_aim.safe_head = { }

        anti_aim.safe_head.run = function(cmd)
            if not menu.anti_aim.tweaks:get("Safe head") then return end

            local lp = entity.get_local_player()
            if lp == nil or not entity.is_alive(lp) then return end

            local weapon = entity.get_player_weapon(lp)
            if weapon == nil then return end

            local lp_threat = client.current_threat()

            local threat_origin = vector(entity.get_prop(lp_threat, "m_vecOrigin"))
            local lp_origin = vector(entity.get_prop(lp, "m_vecOrigin"))

            local is_knife = entity.get_classname(weapon) == "CKnife"
            local is_taser = entity.get_classname(weapon) == "CWeaponTaser"

            local state_id = anti_aim.get_state()

            local height_difference = lp_origin.z - threat_origin.z > menu.anti_aim.height_difference:get()
            local can_use_above_enemy = (menu.anti_aim.height_difference:get() ~= 0 and not height_difference) and false or true

            local knife_state = menu.anti_aim.safe_head_states:get("Knife") and state_id == 5 and is_knife
            local taser_state = menu.anti_aim.safe_head_states:get("Taser") and state_id == 5 and is_taser
            local above_enemy_state = can_use_above_enemy and menu.anti_aim.safe_head_states:get("Above enemy") and height_difference

            local is_defensive = anti_aim.exploit.get_defensive()

            if knife_state or taser_state or above_enemy_state then
                if menu.anti_aim.e_spam:get() then
                    anti_aim.data.pitch.types = is_defensive and "Up" or "Down"
                    anti_aim.data.pitch.custom_amount = 0
                    anti_aim.data.yaw.base = "At targets"
                    anti_aim.data.yaw.type = "180"
                    anti_aim.data.yaw.degree = is_defensive and 180 or 0
                    anti_aim.data.yaw.jitter.amount = 0
                    anti_aim.data.body_yaw.type = "Static"
                    anti_aim.data.body_yaw.amount = 0
                    anti_aim.data.freestanding = false

                    cmd.force_defensive = true
                else
                    anti_aim.data.pitch.types = "Down"
                    anti_aim.data.pitch.custom_amount = 0
                    anti_aim.data.yaw.base = "At targets"
                    anti_aim.data.yaw.type = "180"
                    anti_aim.data.yaw.degree = 0
                    anti_aim.data.yaw.jitter.amount = 0
                    anti_aim.data.body_yaw.type = "Static"
                    anti_aim.data.body_yaw.amount = 0
                    anti_aim.data.freestanding = false

                    cmd.force_defensive = false
                end
            end
        end

        anti_aim.safe_head.run(cmd)
        --  @end ~ safe head @_@



        --  @start ~ fast ladder X_X
        anti_aim.fast_ladder = { }

        anti_aim.fast_ladder.run = function(cmd)
            if not menu.anti_aim.tweaks:get("Fast ladder") then return end
    
            local lp = entity.get_local_player()
            if lp == nil or not entity.is_alive(lp) then return end
    
            local pitch, yaw = client.camera_angles()

            local move_type = entity.get_prop(lp, "m_MoveType")
            if move_type ~= 9 then return end

            cmd.yaw = math.floor(cmd.yaw + 0.5)
            cmd.roll = 0

            if cmd.forwardmove == 0 then
                if cmd.sidemove ~= 0 then
                    cmd.pitch = 89
                    cmd.yaw = cmd.yaw + 180
                    if cmd.sidemove < 0 then
                        cmd.in_moveleft = 0
                        cmd.in_moveright = 1
                    end
                    if cmd.sidemove > 0 then
                        cmd.in_moveleft = 1
                        cmd.in_moveright = 0
                    end
                end
            end
    
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