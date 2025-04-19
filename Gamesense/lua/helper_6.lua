-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_camera_angles, client_color_log, client_delay_call, client_error_log, client_exec, client_eye_position, client_log, client_screen_size, client_set_event_callback, client_userid_to_entindex, entity_get_classname, entity_get_local_player, entity_get_player_weapon, entity_get_prop, globals_curtime, globals_realtime, globals_mapname, globals_tickinterval, math_abs, math_ceil, math_floor, math_max, math_min, math_sqrt, renderer_circle, renderer_circle_outline, renderer_line, renderer_measure_text, renderer_rectangle, renderer_text, renderer_triangle, string_format, table_concat, table_insert, table_remove, table_sort, ui_get, ui_new_button, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_hotkey, ui_new_multiselect, ui_new_slider, ui_new_textbox, ui_reference, ui_set, ui_set_callback, loadstring, tostring, assert, require, ui_set_visible, setmetatable, type, pairs, ipairs, pcall, error, tonumber, select, unpack = client.camera_angles, client.color_log, client.delay_call, client.error_log, client.exec, client.eye_position, client.log, client.screen_size, client.set_event_callback, client.userid_to_entindex, entity.get_classname, entity.get_local_player, entity.get_player_weapon, entity.get_prop, globals.curtime, globals.realtime, globals.mapname, globals.tickinterval, math.abs, math.ceil, math.floor, math.max, math.min, math.sqrt, renderer.circle, renderer.circle_outline, renderer.line, renderer.measure_text, renderer.rectangle, renderer.text, renderer.triangle, string.format, table.concat, table.insert, table.remove, table.sort, ui.get, ui.new_button, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_hotkey, ui.new_multiselect, ui.new_slider, ui.new_textbox, ui.reference, ui.set, ui.set_callback, loadstring, tostring, assert, require, ui.set_visible, setmetatable, type, pairs, ipairs, pcall, error, tonumber, select, unpack

-- super small json pretty print
-- based on https://github.com/bungle/lua-resty-prettycjson/blob/master/lib/resty/prettycjson.lua and https://github.com/bungle/lua-resty-prettycjson/blob/master/lib/resty/prettycjson.lua
local json_encode_pretty
do local a,b,c,d,e=string.byte,string.find,string.format,string.gsub,string.match;local f,g,h=table.concat,string.sub,string.rep;local i,j=1/0,-1/0;local k='[^ -!#-[%]^-\255]'local l;do local n,o;local p,q;local function r(n)q[p]=tostring(n)p=p+1 end;local s=e(tostring(0.5),'[^0-9]')local t=e(tostring(12345.12345),'[^0-9'..s..']')if s=='.'then s=nil end;local u;if s or t then u=true;if s and b(s,'%W')then s='%'..s end;if t and b(t,'%W')then t='%'..t end end;local v=function(w)if j<w and w<i then local x=tostring(w)if u then if t then x=d(x,t,'')end;if s then x=d(x,s,'.')end end;q[p]=x;p=p+1;return end;error('invalid number')end;local y;local z={['"']='\\"',['\\']='\\\\',['\b']='\\b',['\f']='\\f',['\n']='\\n',['\r']='\\r',['\t']='\\t',__index=function(_,B)return c('\\u00%02X',a(B))end}setmetatable(z,z)local function C(x)q[p]='"'if b(x,k)then x=d(x,k,z)end;q[p+1]=x;q[p+2]='"'p=p+3 end;local function D(E)local F=E[0]if type(F)=='number'then q[p]='['p=p+1;for G=1,F do y(E[G])q[p]=','p=p+1 end;if F>0 then p=p-1 end;q[p]=']'else F=E[1]if F~=nil then q[p]='['p=p+1;local G=2;repeat y(F)F=E[G]if F==nil then break end;G=G+1;q[p]=','p=p+1 until false;q[p]=']'else q[p]='{'p=p+1;local F=p;for H,n in pairs(E)do C(H)q[p]=':'p=p+1;y(n)q[p]=','p=p+1 end;if p>F then p=p-1 end;q[p]='}'end end;p=p+1 end;local I={boolean=r,number=v,string=C,table=D}setmetatable(I,I)function y(n)if n==o then q[p]='null'p=p+1;return end;return I[type(n)](n)end;function l(J,K)n,o=J,K;p,q=1,{}y(n)return f(q)end;function json_encode_pretty(n,L,M,N)local x,O=l(n)if not x then return x,O end;L,M,N=L or"\n",M or"\t",N or" "local p,G,H,w,P,Q,R=1,0,0,#x,{},nil,nil;local S=g(N,-1)=="\n"for T=1,w do local B=g(x,T,T)if not R and(B=="{"or B=="[")then P[p]=Q==":"and f{B,L}or f{h(M,G),B,L}G=G+1 elseif not R and(B=="}"or B=="]")then G=G-1;if Q=="{"or Q=="["then p=p-1;P[p]=f{h(M,G),Q,B}else P[p]=f{L,h(M,G),B}end elseif not R and B==","then P[p]=f{B,L}H=-1 elseif not R and B==":"then P[p]=f{B,N}if S then p=p+1;P[p]=h(M,G)end else if B=='"'and Q~="\\"then R=not R and true or nil end;if G~=H then P[p]=h(M,G)p,H=p+1,G end;P[p]=B end;Q,p=B,p+1 end;return f(P)end end end

local ordered_table = {}
do local b={}local c={}function ordered_table.insert(d,e,f)if f==nil then ordered_table.remove(d,e)else if d[b][e]==nil then d[c][#d[c]+1]=e end;d[b][e]=f end end;local function g(d,f)for h,i in ipairs(d)do if f==i then return h end end end;function ordered_table.remove(d,e)local j=d[b]local f=j[e]if f~=nil then local k=d[c]table.remove(k,assert(g(k,e)))j[e]=nil end;return f end;function ordered_table.pairs(d)local h=0;return function()h=h+1;local l=d[c][h]if l~=nil then return l,d[b][l]end end end;ordered_table.__newindex=ordered_table.insert;ordered_table.__len=function(d)return#d[c]end;ordered_table.__pairs=ordered_table.pairs;ordered_table.__index=function(d,e)return d[b][e]end;function ordered_table:new(m)m=m or{}local n={}local o={}local d={[c]=n,[b]=o}local p=#m;if p%2~=0 then error("key: "..tostring(m[#m]).." is missing value",2)end;for h=1,p/2 do local e=m[h*2-1]local f=m[h*2]if o[e]~=nil then error("duplicated key:"..tostring(e),2)end;n[#n+1]=e;o[e]=f end;return setmetatable(d,self)end;setmetatable(ordered_table,{__call=ordered_table.new}) end

local package_loaded = package.loaded

local vector3, vector2
do local vector = (function() local a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,pcall,t,u,v,w,error,type,tonumber,setmetatable=client.camera_angles,client.draw_debug_text,client.eye_position,client.trace_bullet,client.trace_line,entity.get_local_player,math.abs,math.acos,math.atan,math.atan2,math.cos,math.deg,math.fmod,math.max,math.min,math.rad,math.random,math.sin,math.sqrt,pcall,renderer.line,renderer.text,renderer.world_to_screen,string.char,error,type,tonumber,setmetatable;local x=require"ffi"local y,z=x.sizeof,x.istype;local A,B="vector3","vector2"while pcall(y,A)or pcall(y,B)do A,B=A..w(q(97,122)),B..w(q(97,122))end;x.cdef("typedef struct { double x, y, z; } "..A.."; typedef struct { double x, y; } "..B..";")local C=1/0;local function D(E,F)if not E then error(F,3)end end;local function G(H,I,J)return o(n(H,I),J)end;local function K(L)if L~=L or L==C then return 0 elseif L>=-180 and L<=180 then return L end;local M=m(m(L+360,360),360)return M>180 and M-360 or M end;local N={}local O={__index=N}local P={}local Q;local function R(E)return E~=nil and z(A,E)end;local function S(T)if R(T)then return T:unpack()elseif type(T)=="number"then return T,T,T else error("Invalid arguments",3)end end;local U={}local V={__index=U}local W;local function X(E)return E~=nil and z(B,E)end;local function Y(T)if X(T)then return T:unpack()elseif type(T)=="number"then return T,T else error("Invalid arguments")end end;function O:__eq(T)return R(T)and self.x==T.x and self.y==T.y and self.z==T.z end;function O:__unm()D(R(self),"Self has to be vector3")return Q(-self.x,-self.y,-self.z)end;function O:__add(T)D(R(self),"Self has to be vector3")local Z,_,a0=S(T)return Q(self.x+Z,self.y+_,self.z+a0)end;function O:__sub(T)D(R(self),"Self has to be vector3")local Z,_,a0=S(T)return Q(self.x-Z,self.y-_,self.z-a0)end;function O:__mul(T)D(R(self),"Self has to be vector3")local Z,_,a0=S(T)return Q(self.x*Z,self.y*_,self.z*a0)end;function O:__div(T)D(R(self),"Self has to be vector3")local Z,_,a0=S(T)return Q(self.x/Z,self.y/_,self.z/a0)end;function O:__tostring()D(R(self),"Self has to be vector3")return"("..self.x..", "..self.y..", "..self.z..")"end;function O.__call(a1,Z,_,a0)return Q(Z,_,a0)end;function O.__index(a2,a3)if N[a3]~=nil then return N[a3]elseif P[a2]~=nil then return P[a2][a3]end end;function O.__newindex(a2,a3,a4)if N[a3]==nil then P[a2]=P[a2]or{}P[a2][a3]=a4 end end;function N:clear()self.x,self.y,self.z=0,0,0 end;function N:unpack()return self.x,self.y,self.z end;function N:dup()return Q(self:unpack())end;N.clone=N.dup;function N:set(Z,_,a0)if R(Z)then Z,_,a0=Z:unpack()end;self.x=Z;self.y=_;self.z=a0 end;function N:scale(a5)self:set(self.x*a5,self.y*a5,self.z*a5)return self end;function N:length_sqr()return self.x*self.x+self.y*self.y+self.z*self.z end;function N:length_2d_sqr()return self.x*self.x+self.y*self.y end;function N:length()return s(self:length_sqr())end;function N:length_2d()return s(self:length_2d_sqr())end;function N:dot(T)return self.x*T.x+self.y*T.y+self.z*T.z end;function N:cross(T)return Q(self.y*T.z-self.z*T.y,self.z*T.x-self.x*T.z,self.x*T.y-self.y*T.x)end;function N:dist_to(T)return(T-self):length()end;function N:dist_to_2d(T)return(T-self):length_2d()end;function N:normalize()local a6=self:length()if a6==0 then return 0 else self:scale(1/a6)return a6 end end;function N:normalize_2d()local a6=self:length_2d()if a6==0 then return 0 else self:scale(1/a6)return a6 end end;function N:normalized()local a6=self:length()if a6==0 then return Q()end;return self/a6 end;function N:lerp(T,a7)return self+(T-self)*a7 end;function N:vector_angles(T)local a8,a9,aa;local ab,ac,ad;if T==nil then ab,ac,ad=self.x,self.y,self.z;a8,a9,aa=c()if a8==nil then return end else ab,ac,ad=T.x,T.y,T.z;a8,a9,aa=self.x,self.y,self.z end;local ae,af,ag=ab-a8,ac-a9,ad-aa;if ae==0 and af==0 then return W(ag>0 and 270 or 90,0)else local ah=l(j(af,ae))local ai=s(ae*ae+af*af)local aj=l(j(-ag,ai))return W(aj,ah)end end;function N:trace_line(T,ak)ak=ak or-1;local al,am,an=self:unpack()local ao,ap=e(ak,al,am,an,T:unpack())local aq=self:lerp(T,ao)return ao,ap,aq end;function N:trace_line_skip(T,ar,as)as=as or 10;local ao,ap=0,-1;local aq=self;local at=0;while as>=at and ao<1 and(ap>-1 and ar(ap)or aq==self)do ao,ap,aq=aq:trace_line(T,ap)at=at+1 end;local ao=self:dist_to(aq)/self:dist_to(T)return ao,ap,aq end;function N:trace_bullet(T,au)au=au or f()local al,am,an=self:unpack()return d(au,al,am,an,T:unpack())end;function N:get_fov(av,aw)if av==nil then av=N(c())end;if aw==nil then aw=U(a())end;local ax=av:vector_angles(self)return(aw-ax):length_2d()end;function N:in_fov(ay,av,aw)if ay==nil then error("Invalid arguments: FOV is required")end;return ay>self:get_fov(av,aw)end;function N:normalize_angles()self.x=n(-89,o(89,self.x))self.y=K(self.y)self.z=0 end;function N:to_screen()return v(self:unpack())end;function N:draw_text(az,aA,aB,aC,aD,...)local aE,aF=self:to_screen()if aE~=nil then u(aE,aF,az,aA,aB,aC,"c"..(aD or""),0,...)return true end;return false end;function N:draw_debug_text(aG,aH,az,aA,aB,aC,...)b(self.x,self.y,self.z,aG,aH,az,aA,aB,aC,...)end;function N:draw_line(T,az,aA,aB,aC,aI)aI=aI or 1;az,aA,aB,aC=az or 255,aA or 255,aB or 255,aC or 255;local aJ,aK=self:to_screen()local aL,aM=T:to_screen()if aJ~=nil and aL~=nil then for at=1,aI do local aN=at-1;t(aJ,aK-aN,aL,aM-aN,az,aA,aB,aC)t(aJ-aN,aK,aL-aN,aM,az,aA,aB,aC)end end;return aJ~=nil and aL~=nil end;function N:is_zero(aO)aO=aO or 0.001;return g(self.x)<aO and g(self.y)<aO and g(self.z)<aO end;function N.vector_to_angle(aP)local aj,ah;local a6=aP:length()if a6>0 then aj=l(i(-aP.z,a6))ah=l(i(aP.y,aP.x))else W(aP.x>0 and 270 or 90,0)end end;function N.angle_forward(L)if L==nil then error("angle cannot be nil",2)end;local aj,ah=p(L.x),p(L.y)local aQ,aR=r(aj),k(aj)local aS,aT=r(ah),k(ah)return Q(aR*aT,aR*aS,-aQ)end;function N.angle_right(L)local aj,ah,aU=p(L.x),p(L.y),R(L)and p(L.z)or 0;local aQ,aR=r(aj),k(aj)local aS,aT=r(ah),k(ah)local aV,aW=r(aU),k(aU)return Q(-1.0*aV*aQ*aT+-1.0*aW*-aS,-1.0*aV*aQ*aS+-1.0*aW*aT,-1.0*aV*aR)end;function N.angle_up(L)local aj,ah,aU=p(L.x),p(L.y),R(L)and p(L.z)or 0;local aQ,aR=r(aj),k(aj)local aS,aT=r(ah),k(ah)local aV,aW=r(aU),k(aU)return Q(aW*aQ*aT+-aV*-aS,aW*aQ*aS+-aV*aT,aW*aR)end;function N.angle_to_vectors(L)return N.angle_forward(L),N.angle_right(L),N.angle_up(L)end;function N.angle_diff(aX,aY)local aZ=m(aX-aY,360)if aX>aY then if aZ>=180 then aZ=aZ-360 end else if aZ<=-180 then aZ=aZ+360 end end;return aZ end;function N.angle_approach(a_,E,b0)a_=K(a_)E=K(E)local aZ=a_-E;if b0<0 then b0=-b0 end;if aZ<-180 then aZ=aZ+360 elseif aZ>180 then aZ=aZ-360 end;if aZ>b0 then E=E+b0 elseif aZ<-b0 then E=E-b0 else E=a_ end;return E end;function N.get_FOV(b1,av,b2)local b3=N.angle_forward(b1)local aZ=(b2-av):normalized()local ay=h(b3:dot(aZ)/aZ:length())return n(0,l(ay))end;Q=x.metatype(A,O)function V:__eq(T)return X(T)and self.x==T.x and self.y==T.y end;function V:__unm(T)return W(-self.x,-self.y)end;function V:__add(T)local Z,_=Y(T)return W(self.x+Z,self.y+_)end;function V:__sub(T)local Z,_=Y(T)return W(self.x-Z,self.y-_)end;function V:__mul(T)local Z,_=Y(T)return W(self.x*Z,self.y*_)end;function V:__div(T)local Z,_=Y(T)return W(self.x/Z,self.y/_)end;function V:__tostring()return"("..self.x..", "..self.y..")"end;function V.__call(a1,Z,_)return W(Z,_)end;function U:clear()self.x,self.y=0,0 end;function U:unpack()return self.x,self.y end;function U:dup()return W(self:unpack())end;U.clone=U.dup;function U:set(Z,_,a0)if X(Z)then Z,_=Z:unpack()end;self.x=Z;self.y=_ end;function U:scale(a5)self:set(self.x*a5,self.y*a5)return self end;function U:length_sqr()return self.x*self.x+self.y*self.y end;function U:rad()return W(p(self.x),p(self.y))end;function U:deg()return W(l(self.x),l(self.y))end;U.length_2d_sqr=U.length_sqr;function U:length()return s(self:length_sqr())end;U.length_2d=U.length;function U:dist_to(T)return(T-self):length()end;U.dist_to_2d=U.dist_to;function U:normalize()local a6=self:length()if a6==0 then return 0 else self:scale(1/a6)return a6 end end;function U:dot(T)return self.x*T.x+self.y*T.y end;function U:perp()return W(-self.y,self.x)end;function U:normalize_angles()self.x=n(-89,o(89,self.x))self.y=K(self.y)end;W=x.metatype(B,V)setmetatable(N,{__call=function(a1,Z,_,a0)if R(Z)or X(Z)then Z,_,a0=Z:unpack()a0=a0 or 0 end;Z,_,a0=tonumber(Z),tonumber(_),tonumber(a0)if Z==nil or _==nil or a0==nil then return end;return Q(Z,_,a0)end})setmetatable(U,{__call=function(a1,Z,_)if R(Z)or X(Z)then Z,_=Z:unpack()end;Z,_=tonumber(Z),tonumber(_)if Z==nil or _==nil then return end;return W(Z,_)end})return setmetatable({vector3=N,vector2=U,normalize_angle=K,clamp=G},{__call=function()return N,U end,__index=function(a2,a3)if type(a3)=="string"then return a2[a3:lower()]end end}) end)() vector3, vector2 = vector.vector3, vector.vector2 end

local json = { _version = "0.1.2" }

-------------------------------------------------------------------------------
-- Encode
-------------------------------------------------------------------------------

local encode

local escape_char_map = {
  [ "\\" ] = "\\",
  [ "\"" ] = "\"",
  [ "\b" ] = "b",
  [ "\f" ] = "f",
  [ "\n" ] = "n",
  [ "\r" ] = "r",
  [ "\t" ] = "t",
}

local escape_char_map_inv = { [ "/" ] = "/" }
for k, v in pairs(escape_char_map) do
  escape_char_map_inv[v] = k
end


local function escape_char(c)
  return "\\" .. (escape_char_map[c] or string.format("u%04x", c:byte()))
end


local function encode_nil(val)
  return "null"
end


local function encode_table(val, stack)
  local res = {}
  stack = stack or {}

  -- Circular reference?
  if stack[val] then error("circular reference") end

  stack[val] = true

  if rawget(val, 1) ~= nil or next(val) == nil then
    -- Treat as array -- check keys are valid and it is not sparse
    local n = 0
    for k in pairs(val) do
      if type(k) ~= "number" then
        error("invalid table: mixed or invalid key types")
      end
      n = n + 1
    end
    if n ~= #val then
      error("invalid table: sparse array")
    end
    -- Encode
    for i, v in ipairs(val) do
      table.insert(res, encode(v, stack))
    end
    stack[val] = nil
    return "[" .. table.concat(res, ",") .. "]"

  else
    -- Treat as an object
    for k, v in pairs(val) do
      if type(k) ~= "string" then
        error("invalid table: mixed or invalid key types")
      end
      table.insert(res, encode(k, stack) .. ":" .. encode(v, stack))
    end
    stack[val] = nil
    return "{" .. table.concat(res, ",") .. "}"
  end
end


local function encode_string(val)
  return '"' .. val:gsub('[%z\1-\31\\"]', escape_char) .. '"'
end


local function encode_number(val)
  -- Check for NaN, -inf and inf
  if val ~= val or val <= -math.huge or val >= math.huge then
    error("unexpected number value '" .. tostring(val) .. "'")
  end
  return string.format("%.14g", val)
end


local type_func_map = {
  [ "nil"     ] = encode_nil,
  [ "table"   ] = encode_table,
  [ "string"  ] = encode_string,
  [ "number"  ] = encode_number,
  [ "boolean" ] = tostring,
}


encode = function(val, stack)
  local t = type(val)
  local f = type_func_map[t]
  if f then
    return f(val, stack)
  end
  error("unexpected type '" .. t .. "'")
end


function json.encode(val)
  return ( encode(val) )
end


-------------------------------------------------------------------------------
-- Decode
-------------------------------------------------------------------------------

local parse

local function create_set(...)
  local res = {}
  for i = 1, select("#", ...) do
    res[ select(i, ...) ] = true
  end
  return res
end

local space_chars   = create_set(" ", "\t", "\r", "\n")
local delim_chars   = create_set(" ", "\t", "\r", "\n", "]", "}", ",")
local escape_chars  = create_set("\\", "/", '"', "b", "f", "n", "r", "t", "u")
local literals      = create_set("true", "false", "null")

local literal_map = {
  [ "true"  ] = true,
  [ "false" ] = false,
  [ "null"  ] = nil,
}


local function next_char(str, idx, set, negate)
  for i = idx, #str do
    if set[str:sub(i, i)] ~= negate then
      return i
    end
  end
  return #str + 1
end


local function decode_error(str, idx, msg)
  local line_count = 1
  local col_count = 1
  for i = 1, idx - 1 do
    col_count = col_count + 1
    if str:sub(i, i) == "\n" then
      line_count = line_count + 1
      col_count = 1
    end
  end
  error( string.format("%s at line %d col %d", msg, line_count, col_count) )
end


local function codepoint_to_utf8(n)
  -- http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=iws-appendixa
  local f = math.floor
  if n <= 0x7f then
    return string.char(n)
  elseif n <= 0x7ff then
    return string.char(f(n / 64) + 192, n % 64 + 128)
  elseif n <= 0xffff then
    return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
  elseif n <= 0x10ffff then
    return string.char(f(n / 262144) + 240, f(n % 262144 / 4096) + 128,
                       f(n % 4096 / 64) + 128, n % 64 + 128)
  end
  error( string.format("invalid unicode codepoint '%x'", n) )
end


local function parse_unicode_escape(s)
  local n1 = tonumber( s:sub(1, 4),  16 )
  local n2 = tonumber( s:sub(7, 10), 16 )
   -- Surrogate pair?
  if n2 then
    return codepoint_to_utf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
  else
    return codepoint_to_utf8(n1)
  end
end


local function parse_string(str, i)
  local res = ""
  local j = i + 1
  local k = j

  while j <= #str do
    local x = str:byte(j)

    if x < 32 then
      decode_error(str, j, "control character in string")

    elseif x == 92 then -- `\`: Escape
      res = res .. str:sub(k, j - 1)
      j = j + 1
      local c = str:sub(j, j)
      if c == "u" then
        local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j + 1)
                 or str:match("^%x%x%x%x", j + 1)
                 or decode_error(str, j - 1, "invalid unicode escape in string")
        res = res .. parse_unicode_escape(hex)
        j = j + #hex
      else
        if not escape_chars[c] then
          decode_error(str, j - 1, "invalid escape char '" .. c .. "' in string")
        end
        res = res .. escape_char_map_inv[c]
      end
      k = j + 1

    elseif x == 34 then -- `"`: End of string
      res = res .. str:sub(k, j - 1)
      return res, j + 1
    end

    j = j + 1
  end

  decode_error(str, i, "expected closing quote for string")
end


local function parse_number(str, i)
  local x = next_char(str, i, delim_chars)
  local s = str:sub(i, x - 1)
  local n = tonumber(s)
  if not n then
    decode_error(str, i, "invalid number '" .. s .. "'")
  end
  return n, x
end


local function parse_literal(str, i)
  local x = next_char(str, i, delim_chars)
  local word = str:sub(i, x - 1)
  if not literals[word] then
    decode_error(str, i, "invalid literal '" .. word .. "'")
  end
  return literal_map[word], x
end


local function parse_array(str, i)
  local res = {}
  local n = 1
  i = i + 1
  while 1 do
    local x
    i = next_char(str, i, space_chars, true)
    -- Empty / end of array?
    if str:sub(i, i) == "]" then
      i = i + 1
      break
    end
    -- Read token
    x, i = parse(str, i)
    res[n] = x
    n = n + 1
    -- Next token
    i = next_char(str, i, space_chars, true)
    local chr = str:sub(i, i)
    i = i + 1
    if chr == "]" then break end
    if chr ~= "," then decode_error(str, i, "expected ']' or ','") end
  end
  return res, i
end


local function parse_object(str, i)
  local res = {}
  i = i + 1
  while 1 do
    local key, val
    i = next_char(str, i, space_chars, true)
    -- Empty / end of object?
    if str:sub(i, i) == "}" then
      i = i + 1
      break
    end
    -- Read key
    if str:sub(i, i) ~= '"' then
      decode_error(str, i, "expected string for key")
    end
    key, i = parse(str, i)
    -- Read ':' delimiter
    i = next_char(str, i, space_chars, true)
    if str:sub(i, i) ~= ":" then
      decode_error(str, i, "expected ':' after key")
    end
    i = next_char(str, i + 1, space_chars, true)
    -- Read value
    val, i = parse(str, i)
    -- Set
    res[key] = val
    -- Next token
    i = next_char(str, i, space_chars, true)
    local chr = str:sub(i, i)
    i = i + 1
    if chr == "}" then break end
    if chr ~= "," then decode_error(str, i, "expected '}' or ','") end
  end
  return res, i
end


local char_func_map = {
  [ '"' ] = parse_string,
  [ "0" ] = parse_number,
  [ "1" ] = parse_number,
  [ "2" ] = parse_number,
  [ "3" ] = parse_number,
  [ "4" ] = parse_number,
  [ "5" ] = parse_number,
  [ "6" ] = parse_number,
  [ "7" ] = parse_number,
  [ "8" ] = parse_number,
  [ "9" ] = parse_number,
  [ "-" ] = parse_number,
  [ "t" ] = parse_literal,
  [ "f" ] = parse_literal,
  [ "n" ] = parse_literal,
  [ "[" ] = parse_array,
  [ "{" ] = parse_object,
}


parse = function(str, idx)
  local chr = str:sub(idx, idx)
  local f = char_func_map[chr]
  if f then
    return f(str, idx)
  end
  decode_error(str, idx, "unexpected character '" .. chr .. "'")
end


function json.decode(str)
  if type(str) ~= "string" then
    error("expected argument of type string, got " .. type(str))
  end
  local res, idx = parse(str, next_char(str, 1, space_chars, true))
  idx = next_char(str, idx, space_chars, true)
  if idx <= #str then
    decode_error(str, idx, "trailing garbage")
  end
  return res
end

local function get(data)
	local creation_time = data.created_at()
	local retn_value = data.get(creation_time)
	
	local addition_content = readfile("mydata.json")
	if addition_content ~= nil then
		addition_content = json.decode(addition_content)
		for key, value in pairs(addition_content) do
			if retn_value[key] == nil then
				retn_value[key] = {}
			end
			for key1, value1 in pairs(value) do
				table.insert(retn_value[key], value1)
			end
		end
	end
	
	return retn_value, creation_time
end

local data_weapon, weapon_prev, reload_data, last_weapon_switch, data_map = {}

local function reset_cvar(cvar)
	local val = tonumber(cvar:get_string())
	cvar:set_raw_int(val)
	cvar:set_raw_float(val)
end
local function lerp(a, b, percentage)
	return a + (b - a) * percentage
end
local function table_contains(tbl, val)
	for i = 1, #tbl do
		if tbl[i] == val then
			return true
		end
	end
	return false
end

local MOVETYPE_NOCLIP = 8
local dist_max = 1100
local dist_max_sqr = dist_max^2
local wx_offset_vec = vector3(0, 0, 20)
local land_offsets_vec = {
	vector3(0, 0, 12),
	vector3(0, 12, 0),
	vector3(12, 0, 0)
}

local helper_recreate_dynamic = {
	active=false
}
local helper_debug = false
local cvar_sensitivity = cvar.sensitivity
local MOVE_PREPARE, MOVE_THROW, MOVE_DONE = 1, 2, 3
local airstrafe_reference = ui.reference("MISC", "Movement", "Air strafe")
local quick_peek_assist_reference = ui.reference("MISC", "Movement", "Easy strafe")
local brightness_adjustment_reference = ui.reference("VISUALS", "Effects", "Brightness adjustment")

local enabled_reference = ui.new_checkbox("VISUALS", "Other ESP", "Helper")
local hotkey_reference = ui.new_hotkey("VISUALS", "Other ESP", "Helper hotkey", true)
local types_reference = ui.new_multiselect("VISUALS", "Other ESP", "\nHelper types", {
	"Grenade: Smoke",
	"Grenade: Flashbang",
	"Grenade: High Explosive",
	"Grenade: Molotov",
	"Wallbang: Legit",
	"Wallbang: HvH",
	"Movement"
})
local color_reference = ui.new_color_picker("VISUALS", "Other ESP", "Helper color ", 120, 120, 255, 255)
local ignore_visibility_reference = ui.new_checkbox("VISUALS", "Other ESP", "Show locations behind walls")
local silent_enabled_reference = ui.new_checkbox("VISUALS", "Other ESP", "Silent aim")
local saving_enabled_reference = ui.new_checkbox("LUA", "B", "Helper saving")
local saving_hotkey_reference = ui.new_hotkey("LUA", "B", "Helper saving hotkey", true)
local saving_from_reference = ui.new_textbox("LUA", "B", "From")
local saving_to_reference = ui.new_textbox("LUA", "B", "To")
local saving_type_reference = ui.new_combobox("LUA", "B", "Type", {
	"Grenade",
	"Wallbang: Legit",
	"Wallbang: HvH",
	"Movement"
})
local saving_properties_reference = ui.new_multiselect("LUA", "B", "Properties", {
	"Jump",
	"Run",
	"Tickrate"
})
local saving_run_direction_reference = ui.new_combobox("LUA", "B", "Run duration / direction", {"Forward", "Left", "Right", "Back"})
local saving_run_duration_reference = ui.new_slider("LUA", "B", "\nRun duration", 1, 256, 20, true, "t")

local data_all, data_loaded_at
do
	local success, result = pcall(require, "helper_data")
	if not success then
		print(result)
		local line1 = "Helper data file not found!"
		local line2 = "Make sure to copy 'helper.lua' and 'helper_data.ljbc' into the CS:GO folder"
		client_delay_call(0, function()
			client_error_log(line1, " ", line2)
		end)
		client_set_event_callback("paint", function()
			if ui_get(enabled_reference) then
				local screen_width, screen_height = client_screen_size()
				local width = 375
				renderer_rectangle(screen_width/2 - width/2, 56, width+2, 26, 16, 16, 16, 150)
				renderer_text(screen_width/2, 64, 255, 16, 16, 255, "bc", 0, line1)
				renderer_text(screen_width/2, 64+10, 215, 215, 215, 255, "c", 0, line2)
			end
		end)
		return
	end
	package_loaded["helper_data"] = nil
	data_all, data_loaded_at = get((result))
end

local console_names = {
	["CSmokeGrenade"] = "weapon_smokegrenade",
	["CSensorGrenade"] = "weapon_smokegrenade",
	["CFlashbang"] = "weapon_flashbang",
	["CDecoyGrenade"] = "weapon_flashbang",
	["CIncendiaryGrenade"] = "weapon_molotov",
	["CMolotovGrenade"] = "weapon_molotov",
	["CHEGrenade"] = "weapon_hegrenade",
	["CWeaponAWP"] = "weapon_wallbang",
	["CWeaponSCAR20"] = "weapon_wallbang",
	["CWeaponG3SG1"] = "weapon_wallbang",
	["CWeaponSSG08"] = "weapon_wallbang",
	["CDEagle"] = "weapon_wallbang",
	["CAK47"] = "weapon_wallbang_light",
	["CWeaponSG556"] = "weapon_wallbang_light",
	["CWeaponGalilAR"] = "weapon_wallbang_light",
	["CWeaponM4A1"] = "weapon_wallbang_light",
	["CWeaponM4A4"] = "weapon_wallbang_light",
	["CWeaponAug"] = "weapon_wallbang_light",
	["CWeaponFamas"] = "weapon_wallbang_light",
	["CWeaponTec9"] = "weapon_wallbang_light",
	["CKnife"] = "weapon_knife",
}
local movement_buttons_chars = {
	["in_attack"] = "A",
	["in_jump"] = "J",
	["in_duck"] = "D",
	["in_forward"] = "F",
	["in_back"] = "B",
	["in_use"] = "U",
	["in_moveleft"] = "L",
	["in_moveright"] = "R",
	["in_attack2"] = "Z",
	["in_speed"] = "S"
}
local names_to_type = {
	["Grenade: Smoke"] = "grenade",
	["Grenade: Flashbang"] = "grenade",
	["Grenade: High Explosive"] = "grenade",
	["Grenade: Molotov"] = "grenade",
	["Grenade"] = "grenade",
	["Wallbang: Legit"] = "wallbang",
	["Wallbang: HvH"] = "wallbang_hvh",
	["Movement"] = "movement"
}
local console_names_to_name = {
	["weapon_smokegrenade"] = "Grenade: Smoke",
	["weapon_flashbang"] = "Grenade: Flashbang",
	["weapon_hegrenade"] = "Grenade: High Explosive",
	["weapon_molotov"] = "Grenade: Molotov",
}
local throwtype_description = {
	["RUN"] = "Runthrow",
	["JUMP"] = "Jumpthrow",
	["RUNJUMP"] = "Run + Jumpthrow"
}
local run_direction_yaw = {
	["Forward"] = 0,
	["Back"] = 180,
	["Left"] = 90,
	["Right"] = -90,
}
local map_aliases = {
	["workshop/141243798/aim_ag_texture2"] = "aim_ag_texture2",
	["workshop/1855851320/de_cache_new"] = "de_cache"
}
local map_patterns = {
	["_scrimmagemap$"] = ""
}

local on_saving_enabled_changed
local function on_enabled_changed()
	reload_data = true
	local enabled = ui_get(enabled_reference)
	ui_set_visible(types_reference, enabled)
	ui_set_visible(color_reference, enabled)
	ui_set_visible(ignore_visibility_reference, enabled)
	ui_set_visible(saving_enabled_reference, enabled)
	ui_set_visible(silent_enabled_reference, enabled)
	if not enabled and ui_get(saving_enabled_reference) then
		ui_set(saving_enabled_reference, false)
		if on_saving_enabled_changed ~= nil then
			on_saving_enabled_changed()
		end
	end
end
ui.set_callback(enabled_reference, on_enabled_changed)
ui.set_callback(types_reference, on_enabled_changed)
on_enabled_changed()

local function setup_debug()
	local table_gen = require "lib/table_gen"
	ui.new_button("LUA", "B", "Grenade helper generate statistics", function()
		local maps = {}
		for map, map_spots in pairs(data_all) do
			table_insert(maps, map)
		end
		table_sort(maps)
		local rows = {}
		local headings = {"MAP", "Smokes", "Flashes", "Molotovs", "Grenades", "Wallbangs", "One-ways", "Other"}
		local total_row = {"TOTAL", 0, 0, 0, 0, 0, 0, 0}

		for i=1, #maps do
			local row = {maps[i], 0, 0, 0, 0, 0, 0, 0}
			local map_locations = data_all[maps[i]]
			for i=1, #map_locations do
				local index = 8
				if map_locations[i].type == "grenade" then
					if map_locations[i].weapon == "weapon_smokegrenade" then
						index = 2
					elseif map_locations[i].weapon == "weapon_flashbang" then
						index = 3
					elseif map_locations[i].weapon == "weapon_molotov" then
						index = 4
					elseif map_locations[i].weapon == "weapon_hegrenade" then
						index = 5
					end
				elseif map_locations[i].type == "wallbang" then
					index = 6
				elseif map_locations[i].type == "wallbang_hvh" then
					index = 7
				end

				if not map_locations[i].temporary then
					row[index] = row[index] + 1
					total_row[index] = total_row[index] + 1
				end
			end

			table_insert(rows, row)
		end

		table_insert(rows, {"", "", "", "", "", "", "", ""})
		table_insert(rows, total_row)

		local tbl_result = table_gen(rows, headings, {style="Unicode (Single Line)"})
		client_log("Locations loaded:")
		for s in tbl_result:gmatch("[^\r\n]+") do
			client_color_log(210, 210, 210, s)
		end
	end)

	ui.new_button("LUA", "B", "Clear dynamic data", function()
		if data_map ~= nil then
			for i=1, #data_map do
				data_map[i].landX = nil
				data_map[i].landY = nil
				data_map[i].landZ = nil
				data_map[i].flyDuration = nil
			end
		end
	end)

	ui.new_button("LUA", "B", "Create missing dynamic data", function()
		if data_map ~= nil then
			helper_recreate_dynamic.active = true
		end
	end)
end

local function get_mapname()
	local mapname = globals_mapname()
	if map_aliases[mapname] ~= nil then
		mapname = map_aliases[mapname]
	end

	if data_all ~= nil and data_all[mapname] == nil then
		for pattern, replacement in pairs(map_patterns) do
			local mapname_temp = mapname:gsub(pattern, replacement)
			if data_all[mapname_temp] ~= nil then
				mapname = mapname_temp
				break
			end
		end
	end

	return mapname
end

local movement_saving_hotkey_prev, movement_play_location, movement_play_prev, movement_play_index, movement_play_frame_progress
local saving_location, grenade_thrown_at, grenade_entindex
local function on_saving_teleport()
	if saving_location ~= nil then
		client_exec("setpos_exact ", saving_location.x, " ", saving_location.y, " ", saving_location.z, "; setang ", saving_location.pitch, " ", saving_location.yaw, " 0")
	end
end
local saving_teleport_reference = ui.new_button("LUA", "B", "  Teleport to current location  ", on_saving_teleport)

local function on_saving_export()
	local props_saved = {"map", "from", "to", "type", "weapon", "tickrate", "x", "y", "z", "pitch", "yaw", "throwType", "throwStrength", "viewAnglesDistanceMax", "runDuration", "runYaw", "duck", "flyDuration", "landX", "landY", "landZ", "data"}
	local location_export = ordered_table({})
	if saving_location ~= nil then
		for i=1, #props_saved do
			if saving_location[props_saved[i]] ~= nil then
				location_export[props_saved[i]] = saving_location[props_saved[i]]
			end
		end
		if location_export.tickrate == "" then
			location_export.tickrate = nil
		end
		if not location_export.duck then
			location_export.duck = nil
		end
		if location_export.throwStrength == 1 then
			location_export.throwStrength = nil
		end
		if location_export.viewAnglesDistanceMax == 0.22 then
			location_export.viewAnglesDistanceMax = nil
		end
		if location_export.runDuration == 20 then
			location_export.runDuration = nil
		end
		if location_export.runYaw == 0 then
			location_export.runYaw = nil
		end

		local json_str = json_encode_pretty(location_export, "\n", "  ")
		if location_export.data ~= nil then
			local data_escaped = json_encode_pretty({location_export.data}, "", "", ""):sub(2, -2)
			local quotepattern = '(['..("%^$().[]*+-?"):gsub("(.)", "%%%1")..'])'

			json_str = json_str:gsub((data_escaped:gsub(quotepattern, "%%%1")), location_export.data)
		end
		client_log("Copy this to clipboard and submit it:\n", json_str)
	end
end
local saving_export_reference = ui.new_button("LUA", "B", "  Export  ", on_saving_export)

local function on_saving_properties_changed(reference)
	local saving_properties = ui_get(saving_properties_reference)
	if reference ~= nil then
		local saving_enabled = ui_get(saving_enabled_reference)
		ui_set_visible(saving_run_duration_reference, saving_enabled and table_contains(saving_properties, "Run"))
		ui_set_visible(saving_run_direction_reference, saving_enabled and table_contains(saving_properties, "Run"))
	end
end
ui.set_callback(saving_properties_reference, on_saving_properties_changed)
ui.set_callback(saving_run_duration_reference, on_saving_properties_changed)

local console_input_registered = false
local function on_saving_console_input(text)
	if not ui_get(saving_enabled_reference) then
		return
	end

	if text == "helper_debug" or text == "helper_debug " then
		helper_debug = true
		client_log("Helper debug: on")
		setup_debug()
		return true
	elseif text:sub(1, 14) == "helper_search " then
		local search_str = text:sub(15, -1):lower()
		local eyepos = vector3(client.eye_position())
		print("Locations matching \"", search_str, "\":")
		for i=1, #data_weapon do
			local location = data_weapon[i]
			if location.name:lower():match(search_str) then
				print("- ", location.from, " to ", location.to, " (", location.id, ", ", string_format("dist: %.1d", location.pos:dist_to(eyepos)), ")")
			end
		end
		return true
	elseif text:sub(1, 16) == "helper_teleport " then
		local search_str = text:sub(17, -1):lower():gsub(" ", "")
		for i=1, #data_weapon do
			local location = data_weapon[i]
			if location.id:lower() == search_str then
				print("Teleported to ", location.name, " (", location.id, ")")
				client.exec("setpos ", location.x, " ", location.y, " ", location.z, "; setang ", location.pitch, " ", location.yaw)
				return true
			end
		end
		print("Location \"", search_str, "\" not found.")
		return true
	end
end

function on_saving_enabled_changed()
	reload_data = true
	local saving_enabled = ui_get(enabled_reference) and ui_get(saving_enabled_reference)
	ui_set_visible(saving_hotkey_reference, saving_enabled)
	ui_set_visible(saving_from_reference, saving_enabled)
	ui_set_visible(saving_to_reference, saving_enabled)
	ui_set_visible(saving_type_reference, saving_enabled)
	ui_set_visible(saving_properties_reference, saving_enabled)
	ui_set_visible(saving_teleport_reference, saving_enabled)
	ui_set_visible(saving_export_reference, saving_enabled)
	if not saving_enabled then
		saving_location = nil
	end
	ui_set(saving_properties_reference, {})
	ui_set(saving_run_duration_reference, 20)
	ui_set(saving_run_direction_reference, "Forward")
	on_saving_properties_changed(saving_properties_reference)

	if saving_enabled and not console_input_registered then
		client_set_event_callback("console_input", on_saving_console_input)
		console_input_registered = true
	end
end
ui.set_callback(saving_enabled_reference, on_saving_enabled_changed)
on_saving_enabled_changed()

local function on_run_command(e)
	local local_player = entity_get_local_player()
	local weapon = console_names[entity_get_classname(entity_get_player_weapon(local_player))]

	if ui_get(saving_enabled_reference) then
		if e.command_number % 32 == 0 then
			package_loaded["helper_data"] = nil
			local new_data_all, new_data_loaded_at = get((require("helper_data")))
			if new_data_loaded_at ~= data_loaded_at then
				data_all, data_loaded_at = new_data_all, new_data_loaded_at
				reload_data = true
				client_log("Helper spots were reloaded")
			end
			package_loaded["helper_data"] = nil
		end
	end

	if weapon ~= weapon_prev or reload_data then
		if weapon ~= weapon_prev then
			last_weapon_switch = globals_realtime()
		end
		weapon_prev = weapon
		reload_data = nil
		data_weapon = {}

		local offset_z = 20
		local player_radius = 16
		local accurate_move_offset_table_start = {
			vector3(player_radius*0.7, 0, offset_z),
			vector3(-player_radius*0.7, 0, offset_z),
			vector3(0, player_radius*0.7, offset_z),
			vector3(0, -player_radius*0.7, offset_z),
		}
		local accurate_move_offset_table_end = {
			vector3(player_radius*2, 0, 0),
			vector3(0, player_radius*2, 0),
			vector3(-player_radius*2, 0, 0),
			vector3(0, -player_radius*2, 0),
		}
		local inaccurate_check_offset_table = {
			vector3(0, 0, 0),
			vector3(8, 0, 0),
			vector3(-8, 0, 0),
			vector3(0, 8, 0),
			vector3(0, -8, 0),
		}
		local inaccurate_check_top, inaccurate_check_bottom = vector3(0, 0, 6), -vector3(0, 0, 6)

		if weapon ~= nil and ui_get(enabled_reference) then
			local types = ui_get(types_reference)

			if #types > 0 then
				local mapname = get_mapname()
				data_map = data_all[mapname]

				if data_map ~= nil then
					local saving_enabled = ui_get(saving_enabled_reference)
					local types_enabled = {}
					local position_cache = {}
					for i=1, #types do
						local type_enabled = names_to_type[types[i]]
						if type_enabled ~= "grenade" or table_contains(types, console_names_to_name[weapon]) then
							table_insert(types_enabled, type_enabled)
						end
					end

					local tickrate = 1/globals_tickinterval()
					for i=1, #data_map do
						local location = data_map[i]
						if (weapon == location.weapon or (weapon == "weapon_wallbang" and location.weapon == "weapon_wallbang_light")) and table_contains(types_enabled, location.type) and (location.tickrate == nil or location.tickrate == tickrate or true) and (not location.temporary or saving_enabled) then
							if location.name == nil then
								local shorten_name, show_source = true, false
								location.name = shorten_name and location.to or (location.from .. " to " .. location.to)
							end

							if location.runDuration == nil then
								location.runDuration = 20
							end
							if location.duck == nil then
								location.duck = false
							end
							if location.throwStrength == nil then
								location.throwStrength = 1
							end
							if location.viewAnglesDistanceMax == nil then
								location.viewAnglesDistanceMax = 0.22
							end
							if location.runYaw == nil then
								location.runYaw = 0
							end
							if location.flyDuration ~= nil and location.runDuration ~= nil and (location.type == "RUN" or location.type == "RUNJUMP") then
								-- location.flyDuration = location.flyDuration + location.runDuration
							end

							if location.pos_inaccurate == 1 then
								location.pos = nil
							end

							if location.pos == nil then
								local id = table_concat({location.x, location.y, location.z}, " ")
								if position_cache[id] == nil then
									local pos = vector3(location.x, location.y, location.z)
									for id2, pos2 in pairs(position_cache) do
										if pos2:dist_to(pos) < 1 then
											id = id2
										end
									end

									if position_cache[id] == nil then
										-- bad position
										if location.pos_inaccurate == nil then
											local min = 1
											for i=1, #inaccurate_check_offset_table do
												local frac = (pos+inaccurate_check_offset_table[i]+inaccurate_check_top):trace_line(pos+inaccurate_check_offset_table[i]+inaccurate_check_bottom, local_player)
												min = math_min(min, frac)
											end

											if min == 1 then
												-- client.log("position of ", location.id, " inaccurate, waiting for pos with same x y")

												-- pos:draw_debug_text(0, 25, 255, 255, 255, 255, min)
												location.pos_inaccurate = 1
												local pos_new = pos - vector3(0, 0, 16)
												local frac = (pos_new-vector3(0, 0, -1)):trace_line(pos_new+vector3(0, 0, -1), local_player)
												if frac > 0.4 and frac < 0.6 then
													pos = pos_new
												end
												location.pos = pos
												reload_data = true
											else
												-- good position, cache it
												position_cache[id] = pos
											end
										elseif location.pos_inaccurate == 1 then
											-- client.log("checking for accurate position of ", location.id)
											location.pos = vector3(location.x, location.y, location.z)
											location.pos_inaccurate = 2

											for i=1, #data_weapon do
												local pos2 = data_weapon[i].pos
												if pos2 ~= location.pos and pos2:dist_to_2d(location.pos) < 1 and pos2:dist_to(location.pos) < 50 then
													-- client.log(pos2:dist_to(location.pos))
													location.pos = pos2
													location.pos_inaccurate = nil
													-- client.log("found accurate position for", location.id, ".")
													break
												end
											end

											if location.pos_inaccurate == 2 then
												local frac, entindex_hit, pos_hit = (pos+vector3(0, 0, 32)):trace_line(pos-vector3(0, 0, 32), local_player)
												if frac ~= 1 then
													-- client.log("found no accurate position for ", location.id, ", guessing")
													location.pos = pos_hit
													location.pos.inaccurate = true
													location.pos.accurate_move = false

												end
												location.pos_inaccurate = nil
											end
										end
									end
								end
								location.pos = position_cache[id] or location.pos
							end
							if location.fwd == nil then
								if location.pitch == nil or location.yaw == nil and helper_debug then
									client.error_log("Invalid location, pitch or yaw missing: ", location.id)
								end
								location.fwd = vector3.angle_forward(vector3(location.pitch or 0, location.yaw or 0, 0))
								location.view_offset = location.duck and 46 or 64

								-- determine target in world
								local eye_pos = location.pos + vector3(0, 0, location.view_offset)
								location.eye_pos = eye_pos
								local target = eye_pos+(location.fwd*2048)
								local fraction, entindex_hit, target_hit = eye_pos:trace_line(target, local_player)
								location.target = target_hit
							end
							if location.viewangles == nil then
								location.viewangles = vector2(location.pitch, location.yaw)
							end
							if location.data_parsed == nil and location.data ~= nil then
								local recording_compressed = location.data
								local frames = {}

								-- set up stuff
								local real = {
									pitch = location.pitch,
									yaw = location.yaw
								}
								for key, char in pairs(movement_buttons_chars) do
									real[key] = 0
								end

								local recording_compressed_new = {}
								for i=1, #recording_compressed do
									if type(recording_compressed[i]) == "number" then
										for i=1, recording_compressed[i] do
											table.insert(recording_compressed_new, {})
										end
									else
										table.insert(recording_compressed_new, recording_compressed[i])
									end
								end

								for i=1, #recording_compressed_new do
									local frame_compressed = recording_compressed_new[i]
									real.pitch = real.pitch + (frame_compressed[1] or 0)
									real.yaw = real.yaw + (frame_compressed[2] or 0)

									if frame_compressed[3] ~= nil then
										local keys_down = {}
										for char in frame_compressed[3]:gmatch(".") do
											keys_down[char] = true
										end

										for key, char in pairs(movement_buttons_chars) do
											if keys_down[char] then
												real[key] = 1
											end
										end

										if frame_compressed[4] ~= nil then
											local keys_up = {}
											for char in frame_compressed[4]:gmatch(".") do
												keys_up[char] = true
											end

											for key, char in pairs(movement_buttons_chars) do
												if keys_up[char] then
													real[key] = 0
												end
											end
										end
									end

									real.forwardmove = real["in_forward"] == 1 and 450 or (real["in_back"] == 1 and -450 or 0)
									if frame_compressed[5] ~= nil then
										real.forwardmove = frame_compressed[5]
									end

									real.sidemove = real["in_moveright"] == 1 and 450 or (real["in_moveleft"] == 1 and -450 or 0)
									if frame_compressed[6] ~= nil then
										real.sidemove = frame_compressed[6]
									end

									local frame = {}
									for key, value in pairs(real) do
										frame[key] = value
									end

									table.insert(frames, frame)
								end
								location.data_parsed = frames
							end

							if location.destroyX ~= nil and location.destroyY ~= nil and location.destroyZ ~= nil then
								if location.destroyText == nil then
									location.destroyText = "Break the Glass"
								end
								local destroy = vector3(location.destroyX, location.destroyY, location.destroyZ)

								if location.destroyStartX ~= nil and location.destroyStartY ~= nil and location.destroyStartZ ~= nil then
									location.destroy_start = vector3(location.destroyStartX, location.destroyStartY, location.destroyStartZ)
								else
									location.destroy_start = location.eye_pos
								end

								local delta = destroy - location.destroy_start
								local destroy_new = location.destroy_start + delta*1.2

								location.destroy = destroy_new
							end
							if location.land == nil and location.landX ~= nil then
								location.land = vector3(location.landX, location.landY, location.landZ)
							end

							if location.pos.accurate_move == nil and location.accurateMove ~= nil then
								location.pos.accurate_move = location.accurateMove
							end
							if location.pos.visibility_location == nil then
								location.pos.visibility_location = location.pos+vector3(location.visX or 0, location.visY or 0, location.visZ or 40)
								-- location.pos.visibility_location:draw_debug_text(0, 5, 255, 255, 255, 100, "HI")
							end
							if location.pos.accurate_move == nil then
								local count_accurate_move = 0

								-- go through all directions
								for i=1, #accurate_move_offset_table_end do
									if count_accurate_move > 1 then
										break
									end

									-- set offset added to start for this direction
									local end_offset = accurate_move_offset_table_end[i]

									-- loop through all start points
									for i=1, #accurate_move_offset_table_start do
										local start = location.pos + accurate_move_offset_table_start[i]
										-- client.draw_debug_text(start.x, start.y, start.z, 0, 5, 255, 255, 255, 255, "S", i)

										local fraction, entindex_hit = start:trace_line(start + end_offset, entity_get_local_player())
										local end_pos = start + end_offset
										-- client.draw_debug_text(end_pos.x, end_pos.y, end_pos.z, 0, 5, 255, 255, 255, 255, "E", i)

										if entindex_hit == 0 and fraction > 0.45 and fraction < 0.7 then
											count_accurate_move = count_accurate_move + 1
											-- client.draw_debug_text(end_pos.x, end_pos.y, end_pos.z, 1, 5, 0, 255, 0, 100, "HIT ", fraction)
											break
										end
									end
								end

								-- client.draw_debug_text(location.pos.x, location.pos.y, location.pos.z, 0, 5, 255, 255, 255, 255, "hit ", count_accurate_move, " times")
								location.pos.accurate_move = count_accurate_move > 1
							end
							table_insert(data_weapon, location)
						end
					end
				end
			end
		end
	end

	if not e.from_paint and movement_saving_hotkey_prev and saving_location ~= nil and saving_location.data_parsed ~= nil then
		local buttons_indices = {
			["in_attack"] = 1,
			["in_jump"] = 2,
			["in_duck"] = 4,
			["in_forward"] = 8,
			["in_back"] = 16,
			["in_use"] = 32,
			["in_moveleft"] = 512,
			["in_moveright"] = 1024,
			["in_attack2"] = 2048,
			["in_speed"] = 131072
		}

		for i=1, #saving_location.data_parsed-1 do
			local frame = saving_location.data_parsed[i]
			if not frame.did_run then
				frame.did_run = true

				local local_player = entity.get_local_player()
				local buttons = entity.get_prop(local_player, "m_nButtons")

				for key, value in pairs(frame) do
					if buttons_indices[key] ~= nil then
						local value_btns = bit.band(buttons, buttons_indices[key]) == buttons_indices[key]
						local value_sc = value ~= 0
						if value_btns ~= value_sc then
							-- client.log(key, " differs: ", value_sc, " -> ", value_btns)
							frame[key] = value_btns and 1 or 0
						end
					end
				end

				break
			end
		end
	end
end
client.set_event_callback("run_command", on_run_command)

local function is_grenade_being_thrown(weapon, cmd)
	local pin_pulled = entity_get_prop(weapon, "m_bPinPulled")
	if pin_pulled ~= nil then
		if pin_pulled == 0 or cmd.in_attack == 1 or cmd.in_attack2 == 1 then
			local throw_time = entity_get_prop(weapon, "m_fThrowTime")
			if throw_time ~= nil and throw_time > 0 and throw_time < globals_curtime() then
				return true
			end
		end
	end
	return false
end

local function grenade_apply_movement(cmd, active_move_location)
	if active_move_location.type == "grenade" then
		cmd["in_forward"] = 0
		cmd["in_back"] = 0
		cmd["in_moveleft"] = 0
		cmd["in_moveright"] = 0

		cmd["forwardmove"] = 0
		cmd["sidemove"] = 0

		cmd["in_jump"] = 0
		cmd["in_speed"] = 0

		if (active_move_location.throwType == "RUN" or active_move_location.throwType == "RUNJUMP") then
			cmd["in_forward"] = 1
			cmd["forwardmove"] = 450
		end

		cmd.move_yaw = active_move_location.yaw + (active_move_location.runYaw or 0)
	end
	cmd.in_duck = active_move_location.duck and 1 or 0
end

local locations_on, location_targeted, position_closest
local active_move, active_move_start, active_move_location, airstrafe_disabled, quick_peek_assist_disabled, active_move_weapon
local saving_hotkey_prev = false
local has_to_release_hotkey = false

local function on_setup_command(cmd)
	if not ui_get(enabled_reference) then
		return
	end

	local types = ui_get(types_reference)
	if #types == 0 then
		return
	end

	local local_player = entity_get_local_player()
	local weapon = entity_get_player_weapon(local_player)
	if weapon == nil then
		return
	end

	local tickrate = 1/globals_tickinterval()
	local tickrate_mp = tickrate/64

	local movement_setup_command_values = {"pitch", "yaw", "forwardmove", "sidemove", "in_forward", "in_back", "in_moveleft", "in_moveright", "in_jump", "in_duck", "in_speed", "in_attack", "in_attack2", "in_use"}

	local set_forwardmove = false
	local hotkey, hotkey_mode = ui_get(hotkey_reference)
	if hotkey or helper_recreate_dynamic.active then
		local silent_enabled = ui_get(silent_enabled_reference) or helper_recreate_dynamic.active

		if helper_recreate_dynamic.active and helper_recreate_dynamic.location == nil then
			if active_move == nil then
				for i=1, #data_map do
					local location = data_map[i]
					if location.landX == nil and not location.dynamic_skip and location.type == "grenade" then
						client_log("[", i, "/", #data_map, "] Creating dynamic data for ", location.id, " / ", location.name)
						helper_recreate_dynamic.location = location
						local command = "setpos_exact " .. location.x .. " " .. location.y .. " " .. location.z .. "; setang " .. location.pitch .. " " .. location.yaw .. " " .. 0
						client_exec("use ", location.weapon)
						client_exec(command)
						client_delay_call(0.1, function()
							client_exec(command)
							client_exec("use ", location.weapon)
							client_delay_call(0.15, function()
								client_exec("noclip off")
								client_exec("use ", location.weapon)
								location_targeted = location
								helper_recreate_dynamic.thrown = false

								client_delay_call(2, function()
									if helper_recreate_dynamic.location == location and helper_recreate_dynamic.thrown == false and active_move == nil then
										client_log("[", i, "/", #data_map, "] Timed out. Skipping")
										client_exec("use weapon_knife")
										location.dynamic_skip = true
										helper_recreate_dynamic.location = nil
									end
								end)
							end)
						end)
						break
					end
				end
				if helper_recreate_dynamic.location == nil then
					client_log("Done creating dynamic data")
					local out = ordered_table({
						"format", 2,
						"helper_spots", {}
					})
					for i=1, #data_weapon do
						local location = data_weapon[i]
						location.dynamic_skip = false
						if location.id ~= nil and location.landX ~= nil then
							table_insert(out, ordered_table({
								"id", location.id,
								"landX", location.landX,
								"landY", location.landY,
								"landZ", location.landZ,
								"flyDuration", location.flyDuration,
							}))
						end
					end

					local out_json = json_encode_pretty(out, "\n", "  ")
					for s in out_json:gmatch("[^\r\n]+") do
						client_color_log(210, 210, 210, s)
					end

					helper_recreate_dynamic = {
						active=false
					}
				end
			end
		end

		if helper_recreate_dynamic.active and helper_recreate_dynamic.location ~= nil and helper_recreate_dynamic.thrown == false and active_move == nil then
			cmd.in_attack = 1
			if helper_recreate_dynamic.location.duck then
				cmd.in_duck = 1
			end
		end

		if (location_targeted ~= nil and location_targeted.type == "grenade") or (active_move ~= nil and active_move_location ~= nil) then
			if silent_enabled or (active_move ~= nil and active_move_location ~= nil) or vector2(client_camera_angles()):dist_to(vector2(location_targeted.pitch, location_targeted.yaw)) <= location_targeted.viewAnglesDistanceMax then
				-- aiming at the location and pin pulled
				if active_move == nil then
					local speed = vector3(entity_get_prop(local_player, "m_vecVelocity")):length()
					if (cmd.in_attack == 1 or cmd.in_attack2 == 1) and entity_get_prop(weapon, "m_bPinPulled") == 1 and speed < 2 then
						if entity_get_prop(local_player, "m_flDuckAmount") == (location_targeted.duck and 1 or 0) then
							if location_targeted.targeted then
								local throw_strength = entity_get_prop(weapon, "m_flThrowStrength")
								if throw_strength == location_targeted.throwStrength then
									active_move = MOVE_PREPARE
									active_move_weapon = weapon
									active_move_start = cmd.command_number
									active_move_location = location_targeted
								else
									if location_targeted.throwStrength == 1 then
										cmd.in_attack = 1
										cmd.in_attack2 = 0
									elseif location_targeted.throwStrength == 0.5 then
										cmd.in_attack = 1
										cmd.in_attack2 = 1
									elseif location_targeted.throwStrength == 0 then
										cmd.in_attack = 0
										cmd.in_attack2 = 1
									end
								end
							end
						end
					end
				end
				if active_move ~= nil and active_move_weapon ~= weapon then
					active_move = nil
				end
				if active_move == MOVE_PREPARE or active_move == MOVE_THROW then
					if not silent_enabled then
						cvar_sensitivity:set_raw_float(0)
					end
					if active_move_location.throwType == "RUN" or active_move_location.throwType == "RUNJUMP" then
						local step = math.floor((cmd.command_number-active_move_start) / tickrate_mp)

						if active_move_location.runDuration > step or active_move == MOVE_THROW then
							grenade_apply_movement(cmd, active_move_location)
						elseif active_move == MOVE_PREPARE then
							active_move = MOVE_THROW
						end
					else
						active_move = MOVE_THROW
					end
				end

				if active_move == MOVE_PREPARE then
					if active_move_location.throwStrength == 1 then
						cmd.in_attack = 1
						cmd.in_attack2 = 0
					elseif active_move_location.throwStrength == 0.5 then
						cmd.in_attack = 1
						cmd.in_attack2 = 1
					elseif active_move_location.throwStrength == 0 then
						cmd.in_attack = 0
						cmd.in_attack2 = 1
					end
				end

				if active_move == MOVE_THROW then
					local throw_type = active_move_location.throwType
					cmd.in_attack = 0
					cmd.in_attack2 = 0

					grenade_apply_movement(cmd, active_move_location)
					if throw_type == "JUMP" or throw_type == "RUNJUMP" then
						cmd.in_jump = 1
					end
					active_move = MOVE_DONE

					if not silent_enabled then
						client_delay_call(0.2, function()
							reset_cvar(cvar_sensitivity)
						end)
					end
					if ui_get(airstrafe_reference) then
						airstrafe_disabled = true
						ui_set(airstrafe_reference, false)
					end

					if helper_recreate_dynamic.active then
						helper_recreate_dynamic.thrown = true
					end

					client_delay_call(0.8, function()
						active_move = nil
						active_move_location = nil
						has_to_release_hotkey = false

						if airstrafe_disabled then
							airstrafe_disabled = nil
							ui_set(airstrafe_reference, true)
						end
					end)
					has_to_release_hotkey = true
				elseif active_move == MOVE_DONE then
					cmd.in_attack = 0
					cmd.in_attack2 = 0
					if ui_get(airstrafe_reference) then
						airstrafe_disabled = true
						ui_set(airstrafe_reference, false)
					end

					grenade_apply_movement(cmd, active_move_location)

					if is_grenade_being_thrown(weapon, cmd) then
						if silent_enabled then
							cmd.pitch = active_move_location.pitch
							cmd.yaw = active_move_location.yaw
							cmd.allow_send_packet = false
						end
						active_move = nil
					end
				end
			end
			if (cmd.in_attack == 1 or cmd.in_attack2 == 1) and location_targeted ~= nil and location_targeted.type == "grenade" then
				cmd.in_duck = location_targeted.duck and 1 or 0
			end
		elseif movement_play_location ~= nil and (cmd.in_forward == 1 or cmd.in_back == 1 or cmd.in_moveleft == 1 or cmd.in_moveright == 1 or true) then
			if ui_get(airstrafe_reference) then
				airstrafe_disabled = true
				ui_set(airstrafe_reference, false)
			end

			movement_play_frame_progress = 0
			if movement_play_location.data_parsed[math.floor(movement_play_index)] ~= nil then
				local frame = movement_play_location.data_parsed[math.floor(movement_play_index)]
				client_camera_angles(frame.pitch, frame.yaw)

				for i=1, #movement_setup_command_values do
					local name = movement_setup_command_values[i]
					local value = frame[name]
					if value == 1 or (name ~= "in_attack" and name ~= "in_attack2") then
						cmd[name] = value
					end
				end
				cmd.move_yaw = cmd.yaw

				movement_play_index = movement_play_index + 1/tickrate_mp
			elseif movement_play_index ~= nil then
				-- client.log("playback finished after ", #movement_play_location.data_parsed, " frames")
				movement_play_index = nil
				movement_play_location = nil
			end
			movement_play_prev = true
		elseif location_targeted ~= nil then
			if location_targeted.type == "movement" and location_targeted.data_parsed ~= nil and vector2(client_camera_angles()):dist_to(vector2(location_targeted.pitch, location_targeted.yaw)) <= location_targeted.viewAnglesDistanceMax then
				movement_play_location = location_targeted
				movement_play_prev = false
				movement_play_index = 1

				client_delay_call((#location_targeted.data_parsed)*(1/64)+0.2, function()
					if airstrafe_disabled then
						airstrafe_disabled = false
						ui_set(airstrafe_reference, true)
					end
				end)
			end
		elseif not has_to_release_hotkey then
			-- move to closest location
			if cmd.forwardmove == 0 and cmd.sidemove == 0 and cmd.in_forward == 0 and cmd.in_back == 0 and cmd.in_moveleft == 0 and cmd.in_moveright == 0 then
				if position_closest ~= nil then
					local origin = vector3(entity_get_prop(local_player, "m_vecAbsOrigin"))
					local distance, distance_2d = origin:dist_to(position_closest), origin:dist_to_2d(position_closest)
					if (distance_2d < 0.08 and distance > 0.08 and distance < 4) or (position_closest.inaccurate and distance < 40) then
						distance = distance_2d
					end
					if distance < 32 and distance > 0.08 then
						local yaw = origin:vector_angles(position_closest).y
						cmd.move_yaw = yaw
						if position_closest.accurate_move then
							cmd.forwardmove = 450
						else
							if distance > 10 then
								cmd.forwardmove = 450
							else
								cmd.forwardmove = math_min(450, math_max(1.01, distance * 6))
							end
							set_forwardmove = true
						end

						cmd.in_forward = 1
						-- cmd.in_speed = 1
					end
				end
			end
		end
	else
		active_move = nil
		active_move_location = nil
		has_to_release_hotkey = false
		movement_play_location = nil


		if airstrafe_disabled then
			airstrafe_disabled = false
			ui_set(airstrafe_reference, true)
		end
	end
	if set_forwardmove then
		if ui_get(quick_peek_assist_reference) then
			quick_peek_assist_disabled = true
			ui_set(quick_peek_assist_reference, false)
		end
	elseif quick_peek_assist_disabled then
		ui_set(quick_peek_assist_reference, true)
		quick_peek_assist_disabled = false
	end
	location_targeted = nil

	if ui_get(saving_enabled_reference) and ui_get(saving_hotkey_reference) and names_to_type[ui_get(saving_type_reference)] == "movement" and saving_location ~= nil then
		-- initialize data if first frame
		if not movement_saving_hotkey_prev then
			saving_location.data_parsed = {}
		end

		local frame = {}
		for i=1, #movement_setup_command_values do
			frame[movement_setup_command_values[i]] = cmd[movement_setup_command_values[i]]
		end
		table_insert(saving_location.data_parsed, frame)

		-- only start recording if something changes
		movement_saving_hotkey_prev = movement_saving_hotkey_prev or (cmd.forwardmove ~= 0 or cmd.sidemove ~= 0 or cmd.in_duck ~= 0 or cmd.in_jump ~= 0 or cmd.in_attack ~= 0 or cmd.in_attack2 ~= 0)
	elseif movement_saving_hotkey_prev then
		movement_saving_hotkey_prev = false
		-- recording finished

		local recording = saving_location.data_parsed
		local recording_compressed = {}

		local real = {}
		for key, char in pairs(movement_buttons_chars) do
			real[key] = 0
		end
		real.pitch = recording[1].pitch
		real.yaw = recording[1].yaw

		for i=1, #recording do
			local frame = recording[i]

			-- determine key flags
			local keys_down, keys_up = "", ""
			for key, char in pairs(movement_buttons_chars) do
				if frame[key] == 1 and real[key] == 0 then
					keys_down = keys_down .. char
				elseif frame[key] == 0 and real[key] == 1 then
					keys_up = keys_up .. char
				end
				real[key] = frame[key]
			end

			local frame_compressed = {frame.pitch-real.pitch, frame.yaw-real.yaw, keys_down, keys_up, frame.forwardmove, frame.sidemove}

			-- check if sidemove is what we expect it to be
			if (frame.sidemove == 0 and frame.in_moveright == 0 and frame.in_moveleft == 0)
			or (frame.sidemove == 450 and frame.in_moveright == 1 and frame.in_moveleft == 0)
			or (frame.sidemove == -450 and frame.in_moveright == 0 and frame.in_moveleft == 1) then
				frame_compressed[6] = nil

				-- check if forwardmove is what we expect it to be
				if (frame.forwardmove == 0 and frame.in_forward == 0 and frame.in_back == 0)
				or (frame.forwardmove == 450 and frame.in_forward == 1 and frame.in_back == 0)
				or (frame.forwardmove == -450 and frame.in_forward == 0 and frame.in_back == 1) then
					frame_compressed[5] = nil

					-- check if no key is lifted
					if keys_up == "" then
						frame_compressed[4] = nil

						-- check if no key is pressed
						if keys_down == "" then
							frame_compressed[3] = nil

							-- check if yaw is unchanged
							if frame_compressed[2] == 0 then
								frame_compressed[2] = nil

								-- check if pitch is unchanged
								if frame_compressed[1] == 0 then
									frame_compressed[1] = nil
								end
							end
						end
					end
				end
			end

			table_insert(recording_compressed, frame_compressed)

			-- update real pitch and yaw
			real.pitch = frame.pitch
			real.yaw = frame.yaw
		end

		local recording_compressed_new = {}

		local amt = 0
		for i=1, #recording_compressed do
			if #recording_compressed[i] == 0 then
				amt = amt + 1
			else
				if amt > 0 then
					table.insert(recording_compressed_new, amt)
					amt = 0
				end
				table.insert(recording_compressed_new, recording_compressed[i])
			end
		end
		if amt > 0 then
			table.insert(recording_compressed_new, amt)
			amt = 0
		end

		saving_location.pitch = recording[1].pitch
		saving_location.yaw = recording[1].yaw

		-- json_encode_pretty(dt, [lf = "\n", [id = "\t", [ac = " ", [ec = function]]]])
		saving_location.data = json_encode_pretty(recording_compressed_new, "", "", "")
	end
end
client.set_event_callback("setup_command", on_setup_command)

local function on_paint_saving(local_player, weapon, screen_width, screen_height, locations_on, on_correct)
	local location_type = names_to_type[ui_get(saving_type_reference)]
	local create_location = false

	local saving_hotkey = ui_get(saving_hotkey_reference)

	if saving_hotkey and not saving_hotkey_prev then
		if location_type == "grenade" then
			if entity_get_prop(weapon, "m_bPinPulled") == 1 or true then
				create_location = true
			end
		elseif location_type ~= "movement" or not movement_saving_hotkey_prev then
			create_location = true
		end
	end

	if create_location then
		for map, map_spots in pairs(data_all) do
			for i=1, #map_spots do
				if map_spots[i].temporary then
					table_remove(map_spots, i)
					break
				end
			end
		end

		local weapon_name = console_names[entity_get_classname(entity_get_player_weapon(entity_get_local_player()))]
		if weapon_name ~= nil then
			local mapname = get_mapname()
			saving_location = ordered_table({
				"temporary", true,
				"map", mapname,
				"from", "",
				"to", "",
				"type", location_type,
				"weapon", weapon_name,
				"x", "",
				"y", "",
				"z", "",
				"pitch", "",
				"yaw", ""
			})

			saving_location.x, saving_location.y, saving_location.z = entity_get_prop(local_player, "m_vecAbsOrigin")
			saving_location.pitch, saving_location.yaw = client_camera_angles()
			saving_location.duck = entity_get_prop(local_player, "m_flDuckAmount") > 0 and true or nil

			if location_type == "grenade" then
				local throw_strength = entity_get_prop(weapon, "m_flThrowStrength")
				if throw_strength ~= nil and throw_strength ~= 1 then
					saving_location.throwStrength = throw_strength
				end
			end

			if data_all[mapname] == nil then
				data_all[mapname] = {}
			end

			table_insert(data_all[mapname], saving_location)
			reload_data = true
		end
	end


	if saving_location ~= nil then
		if saving_location.type == "grenade" then
			local saving_properties = ui_get(saving_properties_reference)
			if table_contains(saving_properties, "Jump") and table_contains(saving_properties, "Run") then
				saving_location.throwType = "RUNJUMP"
			elseif table_contains(saving_properties, "Jump") then
				saving_location.throwType = "JUMP"
			elseif table_contains(saving_properties, "Run") then
				saving_location.throwType = "RUN"
			else
				saving_location.throwType = "NORMAL"
			end

			if table_contains(saving_properties, "Run") then
				local run_duration = ui_get(saving_run_duration_reference)
				saving_location.runDuration = run_duration
				local run_direction = ui_get(saving_run_direction_reference)
				saving_location.runYaw = run_direction_yaw[run_direction]
			else
				saving_location.runDuration = nil
				saving_location.runYaw = nil
			end

			saving_location.tickrate = table_contains(saving_properties, "Tickrate") and 1/globals_tickinterval() or nil
		end

		local from = ui_get(saving_from_reference)

		saving_location.to = ui_get(saving_to_reference)
		if saving_location.to == "" then
			saving_location.to = "Unnamed"
		end
		if create_location and on_correct and not locations_on[1].temporary then
			saving_location.from = locations_on[1].from
			saving_location.pos = locations_on[1].pos
			saving_location.x, saving_location.y, saving_location.z = saving_location.pos:unpack()
		else
			saving_location.from = from
		end
		if saving_location.from == "" then
			saving_location.from = "Unnamed"
		end
		saving_location.name = saving_location.to
	end

	saving_hotkey_prev = saving_hotkey

	local lines = {}
	local from, to = ui_get(saving_from_reference), ui_get(saving_to_reference)
	if from == "" or to == "" then
		table_insert(lines, {255, 255, 255, 255, "b", "Saving new location"})
		if from == "" then
			table_insert(lines, {255, 16, 16, 255, "", "Warning: from not set"})
		end
		if to == "" then
			table_insert(lines, {255, 16, 16, 255, "", "Warning: to not set"})
		end
	else
		table_insert(lines, {255, 255, 255, 255, "b", "Saving '", from, "' to '", to, "'"})
	end

	if grenade_thrown_at ~= nil and saving_location ~= nil and saving_location.type == "grenade" then
		table_insert(lines, {27, 162, 248, 255, "", "Grenade flying for ", string_format("%.2fs", globals_curtime()-grenade_thrown_at)})
	elseif saving_location ~= nil and saving_location.flyDuration ~= nil then
		table_insert(lines, {27, 162, 248, 255, "", "Grenade took ", string_format("%.2fs", saving_location.flyDuration)})
	elseif location_type == "movement" then
		local saving_cvars = {
			{"sv_airaccelerate", "float", 12},
			{"sv_enablebunnyhopping", "int", 0},
			{"sv_autobunnyhopping", "int", 0},
		}

		if ui_get(airstrafe_reference) then
			table_insert(lines, {255, 16, 16, 255, "", "Warning: Air strafe is enabled"})
		end

		for i=1, #saving_cvars do
			local cvar_name, cvar_type, value_correct = unpack(saving_cvars[i])
			local cvar_obj = cvar[cvar_name]

			local value
			if cvar_type == "float" then
				value = cvar_obj:get_float()
			elseif cvar_type == "int" then
				value = cvar_obj:get_int()
			elseif cvar_type == "string" then
				value = cvar_obj:get_string()
			end

			if value ~= nil and value ~= value_correct then
				table_insert(lines, {255, 16, 16, 255, "", "Warning: cvar " .. cvar_name .. " is wrong (correct=" .. value_correct .. ")"})
			end
		end

		table_insert(lines, {})

		if saving_location ~= nil and saving_location.data_parsed ~= nil then
			local tickinterval = globals_tickinterval()
			if saving_hotkey then
				table_insert(lines, {230, 84, 84, 255, "", "Recording for ", string_format("%.2fs", tickinterval*(#saving_location.data_parsed-1))})
			elseif saving_location.data ~= nil then
				table_insert(lines, {84, 230, 94, 255, "", "Recorded for ", string_format("%.2fs", tickinterval*(#saving_location.data_parsed))})
			end
		end
	end

	if location_type == "grenade" then
		local saving_properties = ui_get(saving_properties_reference)
		if #saving_properties > 0 then
			table_insert(lines, {230, 230, 230, 255, "", "Properties: ", table_concat(saving_properties, ", ")})
		end

		if table_contains(saving_properties, "Run") then
			local run_direction = ui_get(saving_run_direction_reference)
			table_insert(lines, {230, 230, 230, 255, "", "Run duration: ", run_direction == "Forward" and "" or " ", ui_get(saving_run_duration_reference), " ticks"})
			if run_direction ~= "Forward" then
				table_insert(lines, {230, 230, 230, 255, "", "Run direction: ", run_direction})
			end
		end
	end

	if #lines[#lines] == 0 then
		lines[#lines] = nil
	end

	local line_width, line_height = {}, {}
	for i=1, #lines do
		line_width[i], line_height[i] = renderer_measure_text(select(5, unpack(lines[i])))
	end
	local width = math_max(0, unpack(line_width))

	local x = screen_width/2-width/2
	local y = 60

	--draw background
	renderer_rectangle(x-5, y-4, width+10, #lines*10+10, 16, 16, 16, 150)

	for i=1, #lines do
		table_insert(lines[i], 6, 0)
		local flag_offset = i == -1 and (width/2 - line_width[i]/2) or 0

		if lines[i][5] == "b" then flag_offset = flag_offset + 1 end
		renderer_text(x + flag_offset, y+i*10-10, unpack(lines[i]))
	end
end

local function on_paint()
	location_targeted = nil
	position_closest = nil
	if not ui_get(enabled_reference) then
		return
	end
	local types = ui_get(types_reference)
	if #types == 0 then
		return
	end

	local local_player = entity_get_local_player()
	local weapon = entity_get_player_weapon(local_player)
	if weapon == nil then
		return
	end

	local is_running_commands = not (entity_get_prop(local_player, "m_MoveType") == MOVETYPE_NOCLIP)

	if not is_running_commands then
		on_run_command({command_number=globals.tickcount(), from_paint=true})
	end

	if is_running_commands and ui_get(hotkey_reference) and movement_play_index ~= nil and movement_play_location ~= nil and movement_play_index % 1 == 0 then
		local recording = movement_play_location.data_parsed
		if recording ~= nil and recording[movement_play_index] ~= nil and recording[movement_play_index-1] ~= nil then
			local progress = movement_play_frame_progress / globals_tickinterval()
			movement_play_frame_progress = movement_play_frame_progress + globals.frametime()

			if progress >= 0 and progress <= 1 then
				local pitch = lerp(recording[movement_play_index-1].pitch, recording[movement_play_index].pitch, progress)
				local yaw = lerp(recording[movement_play_index-1].yaw, recording[movement_play_index].yaw, progress)

				client_camera_angles(pitch, yaw)
			end
		end
	end

	local dist_max_targets = 20
	local full_world_alpha_distance = 200
	local flags_world = "c"
	local flags_target = ""
	local flags_target_sub = "-"
	local background_r, background_g, background_b, background_a = 19, 19, 19, 130
	local locations_world_visible_only = not ui_get(ignore_visibility_reference)
	local r, g, b, a = ui_get(color_reference)
	local a_mp = a/255
	local realtime = globals_realtime()

	if last_weapon_switch ~= nil then
		local delta = realtime - last_weapon_switch
		if 0.45 > delta then
			a_mp = a_mp * delta / 0.45
		end
	end

	local origin = vector3(entity_get_prop(local_player, "m_vecAbsOrigin"))
	local eye_pos = vector3(client_eye_position())
	local camera_pos = vector3(client.camera_position())
	local screen_width, screen_height = client_screen_size()

	-- find locations close that we need to draw (close and on)
	local locations_close, locations_close_unchecked = {}, {}
	locations_on = {}

	local dist_closest = 1/0

	for i=1, #data_weapon do
		local location = data_weapon[i]
		local location_pos = location.pos
		if location_pos.distance_sqr == nil then
			location_pos.distance_sqr = (origin-location_pos):length_sqr()
		end

		if dist_max_sqr > location_pos.distance_sqr then
			if location_pos.distance == nil then
				location_pos.distance = math_sqrt(location_pos.distance_sqr)
				location_pos.wx, location_pos.wy = (location_pos+wx_offset_vec):to_screen()
				if location_pos.wx ~= nil and (location_pos.wx > screen_width or location_pos.wx < 0 or location_pos.wy > screen_height or location_pos.wy < 0) then
					location_pos.wx = nil
				end
				if location_pos.wx ~= nil then
					location_pos.wx_bottom, location_pos.wy_bottom = location_pos:to_screen()
				end

				location_pos.distance_2d = origin:dist_to_2d(location_pos)
				if (location_pos.distance_2d < 0.08 and location_pos.distance > 0.08 and location_pos.distance < 4) or (location_pos.inaccurate and location_pos.distance < 32) then
					location_pos.distance = location_pos.distance_2d
				end
			end

			table_insert(locations_close_unchecked, location)

			if location_pos.wx ~= nil then
				if location_pos.distance_2d < 80 or location.temporary then
					location_pos.visible = true
				end
				if locations_world_visible_only and location_pos.visible == nil then
					local fraction = camera_pos:trace_line(location_pos.visibility_location, local_player)
					location_pos.visible = fraction > 0.97
				end
				if not locations_world_visible_only or location_pos.visible or helper_debug or (location_pos.last_visible ~= nil and realtime - location_pos.last_visible < 0.15) then
					table_insert(locations_close, location)
				end
			end

			if location_pos.visible == nil then
				location_pos.visible = false
			end

			if location_pos.visible ~= (location_pos.visible_prev or false) then
				if location_pos.visible then
					location_pos.last_invisible = realtime
				else
					location_pos.last_visible = realtime
				end
			end

			if dist_closest > location_pos.distance then
				position_closest = location_pos
				dist_closest = location_pos.distance
			end
		end
	end

	for i=1, #locations_close_unchecked do
		if locations_close_unchecked[i].pos == position_closest and locations_close_unchecked[i].pos.distance < dist_max_targets then
			table_insert(locations_on, locations_close_unchecked[i])
		end
	end

	local on_correct = locations_on[1] ~= nil and locations_on[1].pos.distance < 0.08
	local a_mp_target = on_correct and 1 or (locations_on[1] == nil and 0 or (1-locations_on[1].pos.distance/dist_max_targets))

	if ui_get(saving_enabled_reference) then
		on_paint_saving(local_player, weapon, screen_width, screen_height, locations_on, on_correct)
	end

	-- determine position offset for all locations based on locations with the same position
	local pos_offsets = {}
	for i=1, #locations_close do
		local pos = locations_close[i].pos
		if pos_offsets[pos] == nil then
			pos_offsets[pos] = -1
			pos.world_alpha_multiplier = math_min(1, 1 - (pos.distance-full_world_alpha_distance) / (dist_max-full_world_alpha_distance))
			if pos.visible and pos.last_invisible ~= nil and realtime - pos.last_invisible < 0.35 then
				pos.world_alpha_multiplier = pos.world_alpha_multiplier * (realtime - pos.last_invisible) / 0.35
			elseif not pos.visible and pos.last_visible ~= nil and realtime - pos.last_visible < 0.15 then
				pos.world_alpha_multiplier = pos.world_alpha_multiplier * (1 - (realtime - pos.last_visible) / 0.15)
			end
			if #locations_on > 0 then
				pos.world_alpha_multiplier = table_contains(locations_on, locations_close[i]) and 1 or pos.world_alpha_multiplier*0.15
			elseif active_move_location ~= nil then
				pos.world_alpha_multiplier = active_move_location == pos and 1 or 0
			end
		end
		pos_offsets[pos] = pos_offsets[pos] + 1
		locations_close[i].offset = pos_offsets[pos]
	end

	-- determine text for all positions that are on screen
	for i=1, #locations_close do
		local location = locations_close[i]
		location.text_world = location.name -- .. " (" .. tostring(location.pos.accurate_move) .. ")"
		if helper_debug then
			location.text_world = location.name .. " (" .. string_format("%.1f", location.pos.distance) .. ", " .. (location.id or "no id") .. ", " .. string_format("%.2f", location.pos.world_alpha_multiplier) .. ")"
		end
	end

	-- determine text width for a position by first finding the longest string, then doing measure_text
	local pos_width = {}
	for i=1, #locations_close do
		local location = locations_close[i]
		if location.text_world ~= nil then
			if pos_width[locations_close[i].pos] == nil or pos_width[locations_close[i].pos]:len() < location.text_world:len() then
				pos_width[locations_close[i].pos] = location.text_world
			end
		end
	end
	for pos, text in pairs(pos_width) do
		pos_width[pos] = renderer_measure_text(flags_world, text)

		local width = math_ceil(pos_width[pos]/2)*2+6
		local height = (pos_offsets[pos]+1)*10+4
		renderer_rectangle(pos.wx-width/2, pos.wy-height+7, width, height, background_r, background_g, background_b, background_a*pos.world_alpha_multiplier*a_mp)

		if pos.wx_bottom ~= nil then
			renderer_line(pos.wx-1, pos.wy+7, pos.wx_bottom-1, pos.wy_bottom, background_r, background_g, background_b, background_a*0.3*pos.world_alpha_multiplier*a_mp)
			renderer_line(pos.wx, pos.wy+7, pos.wx_bottom, pos.wy_bottom, background_r, background_g, background_b, background_a*pos.world_alpha_multiplier*a_mp)
			renderer_line(pos.wx+1, pos.wy+7, pos.wx_bottom+1, pos.wy_bottom, background_r, background_g, background_b, background_a*0.3*pos.world_alpha_multiplier*a_mp)
		end
	end

	-- draw world text
	for i=1, #locations_close do
		local location = locations_close[i]
		if location.text_world ~= nil then
			local r, g, b, a = r, g, b, a
			if location.temporary then
				r, g, b = 255, 0, 0
			end
			renderer_text(location.pos.wx, location.pos.wy-10*location.offset, r, g, b, a*location.pos.world_alpha_multiplier*a_mp, flags_world, 0, location.text_world)
		end
	end

	local screen_center = vector2(screen_width, screen_height)/2

	local dist_closest, location_closest = 1/0
	for i=1, #locations_on do
		local location = locations_on[i]
		-- renderer_text(15, 5+i*10, 255, 255, 255, 255, nil, 0, "", location.name, " ", location.offset, " ", location.id, " ", location.description)
		local target = location.target
		target.wx, target.wy = location.target:to_screen()
		if target.wx ~= nil then
			local dist = screen_center:dist_to_2d(vector2(target.wx, target.wy))
			if dist < dist_closest then
				location_closest, dist_closest = location, dist
			end
		end
	end
	location_targeted = location_closest

	if location_closest ~= nil and location_closest.target.wx ~= nil then
		-- location_targeted.crosshair_dist = vector2(client_camera_angles()):dist_to_2d(vector2(location_closest.pitch, location_closest.yaw))
		local delta = vector2(client_camera_angles()) - location_targeted.viewangles
		delta:normalize_angles()
		location_targeted.crosshair_dist = delta:length_2d()
		location_targeted.viewangles_correct = (location_targeted.crosshair_dist <= location_closest.viewAnglesDistanceMax)
		location_targeted.center_dist = dist_closest
		local closest_targeted = ((ui_get(silent_enabled_reference) and location_closest.type == "grenade") and (location_targeted.crosshair_dist < 15) or location_targeted.viewangles_correct) and entity_get_prop(local_player, "m_flDuckAmount") == (location_closest.duck and 1 or 0)
		local line_drawn = location_targeted.center_dist < 230

		local can_target = true
		if location_targeted.destroy ~= nil then
			local fraction, entindex_hit = location_targeted.destroy_start:trace_line(location_targeted.destroy, local_player)
			can_target = fraction > 0.84
			-- location_targeted.destroy_start:draw_line(location_targeted.destroy, 255, can_target and 0 or 255, can_target and 0 or 255, 255)
		end

		location_closest.targeted = closest_targeted and can_target

		-- determine all texts + subtexts
		for i=1, #locations_on do
			local location = locations_on[i]
			location.target_text = location.name
			location.target_text_2 = nil
			location.target_subtext = nil
			if location == location_closest then
				local info = {}
				if location.duck then
					table_insert(info, "DUCK")
				end
				if location.throwStrength ~= 1 then
					local strength_text = tostring(location.throwStrength) .. " STRENGTH"
					if location.throwStrength == 0 then
						strength_text = "RIGHTCLICK"
					elseif location.throwStrength == 0.5 then
						strength_text = "RIGHT+LEFTCLICK"
					end
					table_insert(info, strength_text)
				end

				-- if location.flyDuration ~= nil then
				-- 	table_insert(info, round(location.flyDuration, 1) .. " S")
				-- end
				if can_target then
					local subtext = table_concat(info, ", ")
					if subtext ~= "" then
						location.target_subtext = subtext
					end
				else
					location.target_subtext = location.destroyText:upper()
				end

				local target_text_2_elements = {}

				if throwtype_description[location.throwType] ~= nil then
					table_insert(target_text_2_elements, throwtype_description[location.throwType])
				end
				if location.temporary then
					table_insert(target_text_2_elements, "temporary")
				end

				if #target_text_2_elements > 0 then
					location.target_text_2 = " - " .. table_concat(target_text_2_elements, ", ")
				end
			end
		end

		-- draw all backgrounds
		for i=1, #locations_on do
			local location = locations_on[i]
			if location.target.wx ~= nil then
				local text_width_2 = 0
				if location.target_text_2 ~= nil then
					text_width_2 = renderer_measure_text(flags_target, location.target_text_2)
				end
				local text_width = renderer_measure_text(flags_target, location.target_text)
				local subtext_width = location.target_subtext ~= nil and renderer_measure_text(flags_target_sub, location.target_subtext) or 0
				local width = math_max(text_width+text_width_2, subtext_width)
				local height = 10
				if location.target_subtext ~= nil then
					height = height + 6
				end
				location.target_text_width = text_width

				renderer_rectangle(location.target.wx-7, location.target.wy-6, width+16, height+3, background_r, background_g, background_b, background_a*a_mp*a_mp_target)

				if location ~= location_closest then
					renderer_circle(location.target.wx, location.target.wy, 8, 8, 8, 120*a_mp*a_mp_target, 4, 0, 1)
				end
			end
		end

		if location_closest.type ~= "wallbang_hvh" then
			if closest_targeted and on_correct then
				if can_target then
					local r, g, b = 0, 255, 0
					if location_closest.type == "wallbang" then
						local max_distance = 8192

						local pitch, yaw = client_camera_angles()

						local fwd = vector3.angle_forward(vector2(pitch, yaw, 0))
						local end_pos = eye_pos + (fwd * max_distance)
						local damage, entindex_hit = eye_pos:trace_bullet(end_pos, local_player)

						if entindex_hit > 0 then
							r, g, b = 10, 96, 255
						end
					end
					renderer_circle(location_closest.target.wx, location_closest.target.wy, r, g, b, 150*a_mp*a_mp_target, 3, 0, 1)
				else
					renderer_circle(location_closest.target.wx, location_closest.target.wy, 255, 150, 0, 150*a_mp*a_mp_target, 3, 0, 1)
				end
			else
				local a_mp_circles = a_mp_target
				if not on_correct then
					a_mp_circles = a_mp_target / 4
				end
				if line_drawn then
					renderer_circle(location_closest.target.wx, location_closest.target.wy, 255, 32, 32, 80*a_mp*a_mp_circles, 3, 0, 1)
				else
					renderer_circle(location_closest.target.wx, location_closest.target.wy, 255, 32, 32, 20*a_mp*a_mp_circles, 3, 0, 1)
				end
			end
		end

		if location_targeted.center_dist > 4 then
			local mp = ui_get(brightness_adjustment_reference) == "Night mode" and 0.4 or 0.8
			renderer_line(location_closest.target.wx, location_closest.target.wy, screen_width/2, screen_height/2, r, g, b, a*mp*a_mp*a_mp_target)
		end
		if location_targeted.land ~= nil then
			local wx, wy = location_targeted.land:to_screen()

			if wx ~= nil then
				if not true then
					local wx_top, wy_top = (location_targeted.land+land_offsets_vec[1]):to_screen()
					if wx_top ~= nil then
						renderer_line(wx, wy, wx_top, wy_top, 255, 0, 0, a*a_mp*a_mp_target)
					end

					local wx_fwd, wy_fwd = (location_targeted.land+land_offsets_vec[2]):to_screen()
					if wx_fwd ~= nil then
						renderer_line(wx, wy, wx_fwd, wy_fwd, 255, 0, 0, a*a_mp*a_mp_target)
					end

					local wx_back, wy_back = (location_targeted.land-land_offsets_vec[2]):to_screen()
					if wx_back ~= nil then
						renderer_line(wx, wy, wx_back, wy_back, 255, 0, 0, a*a_mp*a_mp_target)
					end

					local wx_left, wy_left = (location_targeted.land+land_offsets_vec[3]):to_screen()
					if wx_left ~= nil then
						renderer_line(wx, wy, wx_left, wy_left, 255, 0, 0, a*a_mp*a_mp_target)
					end

					local wx_right, wy_right = (location_targeted.land-land_offsets_vec[3]):to_screen()
					if wx_right ~= nil then
						renderer_line(wx, wy, wx_right, wy_right, 255, 0, 0, a*a_mp*a_mp_target)
					end
				else
					if wx ~= nil then
						local wx_top, wy_top = (location_targeted.land+land_offsets_vec[1]):to_screen()
						if wx_top ~= nil then
							local size = math_max(5, math_min(22, math.abs(wy_top-wy)*0.8))

							renderer_triangle(wx-size-2, wy-size-1, wx+size+2, wy-size-1, wx, wy+2, background_r, background_g, background_b, background_a*a_mp*a_mp_target*0.6)
							renderer_triangle(wx-size, wy-size, wx+size, wy-size, wx, wy, r, g, b, a*a_mp*a_mp_target*0.6)
						end
					end
				end
			end
		end

		for i=1, #locations_on do
			local location = locations_on[i]
			if location.target.wx ~= nil then
				local a_multiplier = 0.35
				if location == location_closest then
					a_multiplier = line_drawn and 1 or 0.65
				end

				renderer_circle_outline(location.target.wx, location.target.wy, 255, 255, 255, 255*a_multiplier*a_mp*a_mp_target, 4, 0, 1, 1)

				local r, g, b, a = r, g, b, a
				if location.temporary then
					r, g, b = 255, 0, 0
				end
				renderer_text(location.target.wx+6, location.target.wy-6, r, g, b, a*a_multiplier*a_mp*a_mp_target, flags_target, 0, location.target_text)

				if location.target_text_2 ~= nil then
					renderer_text(location.target.wx+6+location.target_text_width, location.target.wy-6, 200, 200, 200, 255*a_multiplier*0.8*a_mp*a_mp_target, flags_target, 0, location.target_text_2)
				end

				if location.target_subtext ~= nil then
					if can_target then
						renderer_text(location.target.wx+6, location.target.wy-6+10, 255, 255, 255, 160*a_multiplier*a_mp*a_mp_target, flags_target_sub, 0, location.target_subtext)
					else
						renderer_text(location.target.wx+6, location.target.wy-6+10, 255, 150, 32, 160*a_multiplier*a_mp*a_mp_target, flags_target_sub, 0, location.target_subtext)
					end
				end
			end
		end
	end

	-- reset
	for i=1, #data_weapon do
		data_weapon[i].pos.distance = nil
		data_weapon[i].pos.distance_sqr = nil
		data_weapon[i].pos.wx = nil
		data_weapon[i].pos.wx_bottom = nil

		if data_weapon[i].pos.visible ~= nil then
			data_weapon[i].pos.visible_prev = data_weapon[i].pos.visible
			data_weapon[i].pos.visible = nil
		end
	end
	if not on_correct then
		location_targeted = nil
		locations_on = {}
	end
end
client.set_event_callback("paint", on_paint)

local function on_grenade_detonate(e, grenade_type)
	if grenade_type ~= "molotov" and client_userid_to_entindex(e.userid) ~= entity_get_local_player() then
		return
	end

	if ui_get(saving_enabled_reference) then
		if helper_recreate_dynamic.active then
			helper_recreate_dynamic.location.flyDuration = globals_curtime()-grenade_thrown_at
			helper_recreate_dynamic.location.landX = e.x
			helper_recreate_dynamic.location.landY = e.y
			helper_recreate_dynamic.location.landZ = e.z
			client_log("Landed after ", globals_curtime()-grenade_thrown_at)
			client_delay_call(0.4, function()
				helper_recreate_dynamic.location = nil
			end)
			client_exec("host_timescale 1")
		else
			if saving_location ~= nil and grenade_thrown_at ~= nil then
				-- saving_location.flyDuration = globals_curtime()-grenade_thrown_at
				saving_location.landX = e.x
				saving_location.landY = e.y
				saving_location.landZ = e.z
				reload_data = true
			end
		end
	end
	grenade_thrown_at = nil
end
client.set_event_callback("smokegrenade_detonate", function(e) on_grenade_detonate(e, "smokegrenade") end)
client.set_event_callback("hegrenade_detonate", function(e) on_grenade_detonate(e, "hegrenade") end)
client.set_event_callback("inferno_startburn", function(e) on_grenade_detonate(e, "molotov") end)
client.set_event_callback("flashbang_detonate", function(e) on_grenade_detonate(e, "flashbang") end)
client.set_event_callback("decoy_started", function(e) on_grenade_detonate(e, "decoy") end)

client.set_event_callback("molotov_detonate", function()
	if helper_recreate_dynamic.active then
		local location = helper_recreate_dynamic.location
		client_delay_call(0.5, function()
			if helper_recreate_dynamic.location == location then
				client_log("Exploded in air. Skipping")
				helper_recreate_dynamic.location.dynamic_skip = true
				helper_recreate_dynamic.location = nil
				client_exec("host_timescale 1")
			end
		end)
	end
end)

local function on_grenade_thrown(e)
	if client_userid_to_entindex(e.userid) ~= entity_get_local_player() then
		return
	end

	if saving_location ~= nil then
		saving_location.flyDuration = nil
		saving_location.landX = nil
		saving_location.landY = nil
		saving_location.landZ = nil
	end

	if helper_recreate_dynamic.active then
		client_exec("host_timescale 6")
	end

	grenade_thrown_at = globals_curtime()
	grenade_entindex = entity_get_player_weapon(entity_get_local_player())
end
client.set_event_callback("grenade_thrown", on_grenade_thrown)

local function on_shutdown()
	if airstrafe_disabled then
		ui_set(airstrafe_reference, true)
	end
	if quick_peek_assist_disabled then
		ui_set(quick_peek_assist_reference, true)
	end
	reset_cvar(cvar_sensitivity)
end
client.set_event_callback("shutdown", on_shutdown)

local function on_player_connect_full(e)
	if ui_get(saving_enabled_reference) and client_userid_to_entindex(e.userid) == entity_get_local_player() and not helper_recreate_dynamic.active then
		ui_set(saving_enabled_reference, false)
		on_saving_enabled_changed()
	end
end
client.set_event_callback("player_connect_full", on_player_connect_full)
