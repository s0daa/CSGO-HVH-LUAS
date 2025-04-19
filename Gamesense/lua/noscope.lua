--VECTOR LIBRARY
local type=type;local setmetatable=setmetatable;local tostring=tostring;local a=math.pi;local b=math.min;local c=math.max;local d=math.deg;local e=math.rad;local f=math.sqrt;local g=math.sin;local h=math.cos;local i=math.atan;local j=math.acos;local k=math.fmod;local l={}l.__index=l;function Vector3(m,n,o)if type(m)~="number"then m=0.0 end;if type(n)~="number"then n=0.0 end;if type(o)~="number"then o=0.0 end;m=m or 0.0;n=n or 0.0;o=o or 0.0;return setmetatable({x=m,y=n,z=o},l)end;function l.__eq(p,q)return p.x==q.x and p.y==q.y and p.z==q.z end;function l.__unm(p)return Vector3(-p.x,-p.y,-p.z)end;function l.__add(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x+q.x,p.y+q.y,p.z+q.z)elseif r=="table"and s=="number"then return Vector3(p.x+q,p.y+q,p.z+q)elseif r=="number"and s=="table"then return Vector3(p+q.x,p+q.y,p+q.z)end end;function l.__sub(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x-q.x,p.y-q.y,p.z-q.z)elseif r=="table"and s=="number"then return Vector3(p.x-q,p.y-q,p.z-q)elseif r=="number"and s=="table"then return Vector3(p-q.x,p-q.y,p-q.z)end end;function l.__mul(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x*q.x,p.y*q.y,p.z*q.z)elseif r=="table"and s=="number"then return Vector3(p.x*q,p.y*q,p.z*q)elseif r=="number"and s=="table"then return Vector3(p*q.x,p*q.y,p*q.z)end end;function l.__div(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x/q.x,p.y/q.y,p.z/q.z)elseif r=="table"and s=="number"then return Vector3(p.x/q,p.y/q,p.z/q)elseif r=="number"and s=="table"then return Vector3(p/q.x,p/q.y,p/q.z)end end;function l.__tostring(p)return"( "..p.x..", "..p.y..", "..p.z.." )"end;function l:clear()self.x=0.0;self.y=0.0;self.z=0.0 end;function l:unpack()return self.x,self.y,self.z end;function l:length_2d_sqr()return self.x*self.x+self.y*self.y end;function l:length_sqr()return self.x*self.x+self.y*self.y+self.z*self.z end;function l:length_2d()return f(self:length_2d_sqr())end;function l:length()return f(self:length_sqr())end;function l:dot(t)return self.x*t.x+self.y*t.y+self.z*t.z end;function l:cross(t)return Vector3(self.y*t.z-self.z*t.y,self.z*t.x-self.x*t.z,self.x*t.y-self.y*t.x)end;function l:dist_to(t)return(t-self):length()end;function l:is_zero(u)u=u or 0.001;if self.x<u and self.x>-u and self.y<u and self.y>-u and self.z<u and self.z>-u then return true end;return false end;function l:normalize()local v=self:length()if v<=0.0 then return 0.0 end;self.x=self.x/v;self.y=self.y/v;self.z=self.z/v;return v end;function l:normalize_no_len()local v=self:length()if v<=0.0 then return end;self.x=self.x/v;self.y=self.y/v;self.z=self.z/v end;function l:normalized()local v=self:length()if v<=0.0 then return Vector3()end;return Vector3(self.x/v,self.y/v,self.z/v)end;function clamp(w,x,y)if w<x then return x elseif w>y then return y end;return w end;function normalize_angle(z)local A;local B;B=tostring(z)if B=="nan"or B=="inf"then return 0.0 end;if z>=-180.0 and z<=180.0 then return z end;A=k(k(z+360.0,360.0),360.0)if A>180.0 then A=A-360.0 end;return A end;function vector_to_angle(C)local v;local D;local E;v=C:length()if v>0.0 then D=d(i(-C.z,v))E=d(i(C.y,C.x))else if C.x>0.0 then D=270.0 else D=90.0 end;E=0.0 end;return Vector3(D,E,0.0)end;function angle_forward(z)local F=g(e(z.x))local G=h(e(z.x))local H=g(e(z.y))local I=h(e(z.y))return Vector3(G*I,G*H,-F)end;function angle_right(z)local F=g(e(z.x))local G=h(e(z.x))local H=g(e(z.y))local I=h(e(z.y))local J=g(e(z.z))local K=h(e(z.z))return Vector3(-1.0*J*F*I+-1.0*K*-H,-1.0*J*F*H+-1.0*K*I,-1.0*J*G)end;function angle_up(z)local F=g(e(z.x))local G=h(e(z.x))local H=g(e(z.y))local I=h(e(z.y))local J=g(e(z.z))local K=h(e(z.z))return Vector3(K*F*I+-J*-H,K*F*H+-J*I,K*G)end;function get_FOV(L,M,N)local O;local P;local Q;local R;P=angle_forward(L)Q=(N-M):normalized()R=j(P:dot(Q)/Q:length())return c(0.0,d(R))end

--#region API
local ui_set, ui_get, ui_ref, ui_callback, ui_visibile = ui.set, ui.get, ui.reference, ui.set_callback
local ui_new_checkbox, ui_new_color_picker, ui_new_slider =  ui.new_checkbox, ui.new_color_picker, ui.new_slider
local entity_get_player_name, entity_get_bounding_box, entity_is_alive, entity_get_prop, entity_get_local_player, entity_get_player_weapon, entity_get_players = entity.get_player_name, entity.get_bounding_box, entity.is_alive, entity.get_prop, entity.get_local_player, entity.get_player_weapon, entity.get_players
local client_set_event_callback, client_unset_event_callback, client_log, client_color_log = client.set_event_callback, client.unset_event_callback, client.log, client.color_log
local string_format, math_floor, bit_band = string.format, math.floor, bit.band
local renderer_text, renderer_measure_text = renderer.text, renderer.measure_text

--#endregion

--SCRIPT
local script = {
    active,

    menu = { "rage", "Other" --[["Aimbot"]] }
}

function script:call(func, name, ...)
    if func == nil then
        return
    end

    local end_name = name[2] or ""

    if name[1] ~= nil then
        end_name = end_name ~= "" and (string_format("%s ", end_name)) or end_name
        end_name = string_format("%s\n%s", end_name, name[1])
    end

    return func(self.menu[1], self.menu[2], end_name, ...)
end

--#region HELPERS
local multi_exec = function(func, list)
    if func == nil then
        return false                            
    end
    
    for ref, val in pairs(list) do
        func(ref, val)
    end
end

local contains = function(tbl, val)
    for i = 1, #tbl do
        if tbl[i] == val then
            return true
        end
    end
    
    return false
end

local units_to_meters = function(units)
    return math_floor((units * 0.0254) + 0.5)
end

local units_to_feet = function(units)
    return math_floor((units_to_meters(units) * 3.281) + 0.5)
end

--#endregion

--VARS
local lbl_hit_chance = { [ 0 ] = "Off" }
local data

--CONTROLS
local enabled = script:call(ui_new_checkbox, { "enabled ", "Enable adaptive autoscope" })
local distance = script:call(ui_new_slider, { "distance", "Max target distance" }, 0, 120, 40, true, "ft")

local custom_hit_chance = script:call(ui_new_checkbox, { "hit_chance ", "Custom unscoped hit chance" })
local restore_hit_chance = script:call(ui_new_slider, { "restore_hit_chance", "Restore hit chance" }, 0, 100, 65, true, "%", 1, lbl_hit_chance)
local unscoped_hit_chance = script:call(ui_new_slider, { "unscoped_hit_chance", "Unscoped hit chance" }, 0, 100, 65, true, "%", 1, lbl_hit_chance)

local self_indicator = script:call(ui_new_checkbox, { "self_indicator", "Indicator on crosshair" })
local self_indicator_color = script:call(ui_new_color_picker, { "self_indicator_color", nil }, 255, 255, 255, 255)
local self_indicator_offset = script:call(ui_new_slider, { "self_indicator_offset", "Crosshair y-offset" }, -120, 120, 60, true, "px")

local box_indicator = script:call(ui_new_checkbox, { "box_indicator", "Indicator on target bounding box" })
local box_indicator_color = script:call(ui_new_color_picker, { "box_indicator_color", nil }, 255, 255, 255, 255)

local allow_all_guns = script:call(ui_new_checkbox, { "enabled ", "Allow for all weapons" })
local debug = script:call(ui_new_checkbox, { "debug ", "Debug distance" })

--REFRERENCE
local automatic_scope = ui_ref("rage", "Aimbot", "Automatic scope")
local hit_chance = ui_ref("rage", "Aimbot", "Minimum hit chance")

--#region FUNCTIONS

local get_nearest = function()
    local me = Vector3(entity_get_prop(entity_get_local_player(), "m_vecOrigin"))
    
    local nearest_distance
    local nearest_entity

    for _, player in ipairs(entity_get_players(true)) do
        local target = Vector3(entity_get_prop(player, "m_vecOrigin"))
        local _distance = me:dist_to(target)

        if (nearest_distance == nil or _distance < nearest_distance) then
            nearest_entity = player
            nearest_distance = _distance
        end  
    end

    if (nearest_distance ~= nil and nearest_entity ~= nil) then
        return ({ target = nearest_entity, distance = units_to_feet(nearest_distance) })
    end
end 

local get_weapon_index = function(ent)
    local wpn = entity_get_player_weapon(ent)
    return (bit_band(65535, entity_get_prop(wpn, "m_iItemDefinitionIndex")))
end

--#endregion

--#region EVENTS

local on_run_command = function(c)
    local me = entity_get_local_player()

    if (not entity_is_alive(me)) then
        return
    end

    data = get_nearest()

    if (data == nil) then
        return
    end

    local debug = ui.get(debug)
    local dist = ui.get(distance)

    if (debug and data ~= nil) then
        local r, g, b

        if (data.distance <= dist) then
            r, g, b = 30, 220, 30
        else
            r, g, b = 220, 30, 30
        end

        client_color_log(r, g, b, string_format("%s is the nearest entity, approx. %sft away", entity_get_player_name(data.target), data.distance))
    end

    local wpn_idx = get_weapon_index(me)
    local is_allowed_gun

    if (not ui_get(allow_all_guns)) then
        if (wpn_idx ~= 11 and wpn_idx ~= 38) then
            is_allowed_gun = false
        else
            is_allowed_gun = true
        end
    else
        is_allowed_gun = true
    end

    local scoped = entity_get_prop(me, "m_bIsScoped")
    local is_in_range = false

    if (data.distance < ui_get(distance)) then
        is_in_range = true
    end

    if (is_in_range and is_allowed_gun and scoped == 0) then
        script.active = true
    else
        script.active = false
    end

    if (ui_get(custom_hit_chance) and script.active) then
        ui_set(hit_chance, ui_get(unscoped_hit_chance))
    elseif (ui_get(custom_hit_chance) and not script.active) then
        ui_set(hit_chance, ui_get(restore_hit_chance))
    end

    ui_set(automatic_scope, not script.active)
end

local on_paint = function()
    if (not script.active) or (data == nil) then
        return
    end

    local sx, sy = client.screen_size()
    local cx, cy = sx/2, sy/2

    if (ui_get(self_indicator)) then
        local r, g, b, a = ui_get(self_indicator_color)
        renderer_text(cx, cy + ui_get(self_indicator_offset), r, g, b, a, "cb", 0, "noscopeable")
    end

    if (ui_get(box_indicator)) then
        local r, g, b, a = ui_get(box_indicator_color)
        local x1, y1, x2, y2, alpha = entity_get_bounding_box(data.target)

        if (alpha ~= 0) then
            local x_size, y_size = renderer_measure_text("cb", "NOSCOPEABLE")

            renderer_text(x2 - (x2 - x1) * 0.5, y1 - y_size * 1.5, r, g, b, alpha * a, "cb", 400, string.format("NOSCOPEABLE (%sft)", data.distance))
        end
    end
end

--#endregion

--#region VISBILITY

local update_visibility = function()
    local script_state = ui_get(enabled)
    local hit_chance_state = ui_get(custom_hit_chance)
    local indicator_state = ui_get(self_indicator)

    multi_exec(ui.set_visible, {
        [distance] = script_state,
       
        [custom_hit_chance] = script_state,
        [restore_hit_chance] = script_state and hit_chance_state,
        [unscoped_hit_chance] = script_state and hit_chance_state,
 
        [self_indicator] = script_state,
        [self_indicator_color] = script_state,
        [self_indicator_offset] = script_state and indicator_state,

        [box_indicator] = script_state,
        [box_indicator_color] = script_state,

        [allow_all_guns] = script_state,

        [debug] = script_state
    })
end

--#endregion

--INITIALIZATION
local script_toggled = function()
    local state = ui_get(enabled)

    update_visibility()

    local update_callback = state and client_set_event_callback or client_unset_event_callback
    update_callback("run_command", on_run_command)
    update_callback("paint", on_paint)
end

script_toggled()
ui_callback(enabled, script_toggled)
ui_callback(custom_hit_chance, update_visibility)
ui_callback(self_indicator, update_visibility)