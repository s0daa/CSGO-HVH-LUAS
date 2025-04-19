local ffi = require("ffi")
local c_entity = require("gamesense/entity")
local pui = require("gamesense/pui")
local http = require("gamesense/http")
local base64 = require("gamesense/base64")
local clipboard = require("gamesense/clipboard")
local websocket = require("gamesense/websockets")
local vector = require("vector")
local c_entity = require('gamesense/entity')


local json = require("json")

local client_latency, client_screen_size, client_set_event_callback, client_system_time, entity_get_local_player, entity_get_player_resource, entity_get_prop, globals_absoluteframetime, globals_tickinterval, math_ceil, math_floor, math_min, math_sqrt, renderer_measure_text, ui_reference, pcall, renderer_gradient, renderer_rectangle, renderer_text, string_format, table_insert, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_multiselect, ui_new_textbox, ui_set, ui_set_callback, ui_set_visible = client.latency, client.screen_size, client.set_event_callback, client.system_time, entity.get_local_player, entity.get_player_resource, entity.get_prop, globals.absoluteframetime, globals.tickinterval, math.ceil, math.floor, math.min, math.sqrt, renderer.measure_text, ui.reference, pcall, renderer.gradient, renderer.rectangle, renderer.text, string.format, table.insert, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_multiselect, ui.new_textbox, ui.set, ui.set_callback, ui.set_visible

local flag, old_renderer_text, old_renderer_measure_text = "d", renderer_text, renderer_measure_text
function renderer_text(x, y, r, g, b, a, flags, max_width, ...)
	return old_renderer_text(x, y, r, g, b, a, flags == nil and flag or flag .. flags, max_width, ...)
end
function renderer_measure_text(flags, ...)
	return old_renderer_measure_text(flags == nil and flag or flag .. flags, ...)
end

local allow_unsafe_scripts = pcall(client.create_interface)

local FLOW_OUTGOING, FLOW_INCOMING = 0, 1
local native_GetNetChannelInfo, GetRemoteFramerate, native_GetTimeSinceLastReceived, native_GetAvgChoke, native_GetAvgLoss, native_IsLoopback, GetAddress

if allow_unsafe_scripts then
	local ffi = require "ffi"

	local function vmt_entry(instance, index, type)
		return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
	end

	local function vmt_thunk(index, typestring)
		local t = ffi.typeof(typestring)
		return function(instance, ...)
			assert(instance ~= nil)
			if instance then
				return vmt_entry(instance, index, t)(instance, ...)
			end
		end
	end

	local function vmt_bind(module, interface, index, typestring)
		local instance = client.create_interface(module, interface) or error("invalid interface")
		local fnptr = vmt_entry(instance, index, ffi.typeof(typestring)) or error("invalid vtable")
		return function(...)
			return fnptr(instance, ...)
		end
	end

	native_GetNetChannelInfo = vmt_bind("engine.dll", "VEngineClient014", 78, "void*(__thiscall*)(void*)")
	local native_GetName = vmt_thunk(0, "const char*(__thiscall*)(void*)")
	local native_GetAddress = vmt_thunk(1, "const char*(__thiscall*)(void*)")
	native_IsLoopback = vmt_thunk(6, "bool(__thiscall*)(void*)")
	local native_IsTimingOut = vmt_thunk(7, "bool(__thiscall*)(void*)")
	native_GetAvgLoss = vmt_thunk(11, "float(__thiscall*)(void*, int)")
	native_GetAvgChoke = vmt_thunk(12, "float(__thiscall*)(void*, int)")
	native_GetTimeSinceLastReceived = vmt_thunk(22, "float(__thiscall*)(void*)")
	local native_GetRemoteFramerate = vmt_thunk(25, "void(__thiscall*)(void*, float*, float*, float*)")
	local native_GetTimeoutSeconds = vmt_thunk(26, "float(__thiscall*)(void*)")

	local pflFrameTime = ffi.new("float[1]")
	local pflFrameTimeStdDeviation = ffi.new("float[1]")
	local pflFrameStartTimeStdDeviation = ffi.new("float[1]")

	function GetRemoteFramerate(netchannelinfo)
		native_GetRemoteFramerate(netchannelinfo, pflFrameTime, pflFrameTimeStdDeviation, pflFrameStartTimeStdDeviation)
		if pflFrameTime ~= nil and pflFrameTimeStdDeviation ~= nil and pflFrameStartTimeStdDeviation ~= nil then
			return pflFrameTime[0], pflFrameTimeStdDeviation[0], pflFrameStartTimeStdDeviation[0]
		end
	end

	function GetAddress(netchannelinfo)
		local addr = native_GetAddress(netchannelinfo)
		if addr ~= nil then
			return ffi.string(addr)
		end
	end

	local function GetName(netchannelinfo)
		local name = native_GetName(netchannelinfo)
		if name ~= nil then
			return ffi.string(name)
		end
	end
end

local cvar_invin_mode, cvar_invin_type, cvar_fps_max, cvar_fps_max_menu = cvar.invin_mode, cvar.invin_type, cvar.fps_max, cvar.fps_max_menu
local table_clear = require "table.clear"

-- initialize window
local window = ((function() local a={}local b,c,d,e,f=renderer.rectangle,renderer.gradient,renderer.texture,math.floor,math.ceil;local function g(h,i,j,k,l,m,n,o,p)p=p or 1;b(h,i,j,p,l,m,n,o)b(h,i+k-p,j,p,l,m,n,o)b(h,i+p,p,k-p*2,l,m,n,o)b(h+j-p,i+p,p,k-p*2,l,m,n,o)end;local function q(h,i,j,k,r,s,t,u,v,w,x,y,z,p)p=p or 1;if z then b(h,i,p,k,r,s,t,u)b(h+j-p,i,p,k,v,w,x,y)c(h+p,i,j-p*2,p,r,s,t,u,v,w,x,u,true)c(h+p,i+k-p,j-p*2,p,r,s,t,u,v,w,x,u,true)else b(h,i,j,p,r,s,t,u)b(h,i+k-p,j,p,v,w,x,y)c(h,i+p,p,k-p*2,r,s,t,u,v,w,x,y,false)c(h+j-p,i+p,p,k-p*2,r,s,t,u,v,w,x,y,false)end end;local A;do local B="\x14\x14\x14\xFF"local C="\x0c\x0c\x0c\xFF"A=renderer.load_rgba(table.concat({B,B,B,C,B,C,B,C,B,C,B,B,B,C,B,C}),4,4)end;local function D(E,F)if F~=nil and type(E)=="string"and E:sub(-1,-1)=="%"then E=math.floor(tonumber(E:sub(1,-2))/100*F)end;return E end;local function G(H)if H.position=="fixed"then local I,J=client.screen_size()if H.left~=nil then H.x=D(H.left,I)elseif H.right~=nil then H.x=I-(H.w or 0)-D(H.right,I)end;if H.top~=nil then H.y=D(H.top,J)elseif H.bottom~=nil then H.y=J-(H.h or 0)-D(H.bottom,J)end end;local h,i,j,k,o=H.x,H.y,H.w,H.h,H.a or 255;local K=1;if h==nil or i==nil or j==nil or o==nil then return end;H.i_x,H.i_y,H.i_w,H.i_h=H.x,H.y,H.w,H.h;if H.title_bar then K=(H.title~=nil and select(2,renderer.measure_text(H.title_text_size,H.title))or 13)+2;H.t_x,H.t_y,H.t_w,H.t_h=H.x,H.y,H.w,K end;if H.border then g(h,i,j,k,18,18,18,o)g(h+1,i+1,j-2,k-2,62,62,62,o)g(h+2,i+K+1,j-4,k-K-3,44,44,44,o,H.border_width)g(h+H.border_width+2,i+K+H.border_width+1,j-H.border_width*2-4,k-K-H.border_width*2-3,62,62,62,o)H.i_x=H.i_x+H.border_width+3;H.i_y=H.i_y+H.border_width+3;H.i_w=H.i_w-(H.border_width+3)*2;H.i_h=H.i_h-(H.border_width+3)*2;H.t_x,H.t_y,H.t_w=H.x+2,H.y+2,H.w-4;K=K-1 end;if K>1 then c(H.t_x,H.t_y,H.t_w,K,56,56,56,o,44,44,44,o,false)if H.title~=nil then local l,m,n,o=unpack(H.title_text_color)o=o*H.a/255;renderer.text(H.t_x+3,H.t_y+2,l or 255,m or 255,n or 255,o or 255,(H.title_text_size or"")..(H.title_text_flags or""),0,tostring(H.title))end;H.i_y=H.i_y+K;H.i_h=H.i_h-K end;if H.gradient_bar then local L=0;if H.background then L=1;local M,N=16,25;b(H.i_x+1,H.i_y,H.i_w-2,1,M,M,M,o)b(H.i_x+1,H.i_y+3,H.i_w-2,1,N,N,N,o)for O=0,1 do c(H.i_x+(H.i_w-1)*O,H.i_y,1,4,M,M,M,o,N,N,N,o,false)end end;do local h,i,P=H.i_x+L,H.i_y+L,1;local Q,R=e((H.i_w-L*2)/2),f((H.i_w-L*2)/2)for O=1,2 do c(h,i,Q,1,59*P,175*P,222*P,o,202*P,70*P,205*P,o,true)c(h+Q,i,R,1,202*P,70*P,205*P,o,201*P,227*P,58*P,o,true)i,P=i+1,P*0.5 end end;H.i_y=H.i_y+2+L*2;H.i_h=H.i_h-2-L*2 end;if H.background then d(A,H.i_x,H.i_y,H.i_w,H.i_h,255,255,255,255,"t")end;if H.draggable then local p=7;renderer.triangle(h+j-1,i+k-p,h+j-1,i+k-1,h+j-p,i+k-1,62,62,62,o)end;H.i_x=H.i_x+H.margin_left;H.i_w=H.i_w-H.margin_left-H.margin_right;H.i_y=H.i_y+H.margin_top;H.i_h=H.i_h-H.margin_top-H.margin_bottom end;local S={}local T={}local U={}local V={__index=U}function U:set_active(W)if W then S[self.id]=self;table.insert(T,1,self.id)else S[self.id]=nil end end;function U:set_z_index(X)self.z_index=X;self.z_index_reset=true end;function U:is_in_window(h,i)return h>=self.x and h<=self.x+self.w and i>=self.y and i<=self.y+self.h end;function U:set_inner_width(Y)if self.border then Y=Y+(self.border_width+3)*2 end;Y=Y+self.margin_left+self.margin_right;self.w=Y end;function U:set_inner_height(Z)local K=1;if self.title_bar then K=(self.title~=nil and select(2,renderer.measure_text(self.title_text_size,self.title))or 13)+2 end;if self.border then Z=Z+(self.border_width+3)*2;K=K-1 end;if K>1 then Z=Z+K end;if self.gradient_bar then local L=0;if self.background then L=1 end;Z=Z+2+L*2 end;Z=Z+self.margin_top+self.margin_bottom;self.h=Z end;function a.new(_,h,i,j,k,a0)local H=setmetatable({id=_,top=h,left=i,w=j,h=k,a=255,paint_callback=a0,title_bar=true,title_bar_in_menu=false,title_text_color={255,255,255,255},title_text_size=nil,gradient_bar=true,border=true,border_width=3,background=true,first=true,visible=true,margin_top=0,margin_bottom=0,margin_left=0,margin_right=0,position="fixed",draggable=false,draggable_save=false,in_menu=false},V)H:set_active(true)return H end;local a1,a2,a3;local function a4(a5)local a6={"bottom","unset","top"}local a7={}for O=#T,1,-1 do local H=S[T[O]]if H~=nil then local a8=H.z_index or"unset"if H.z_index_reset then H.z_index=nil;H.z_index_reset=nil end;a7[a8]=a7[a8]or{}if H.first then table.insert(a7[a8],1,H.id)H.first=nil else table.insert(a7[a8],H.id)end end end;T={}for O=1,#a6 do local a9=a7[a6[O]]if a9~=nil then for O=#a9,1,-1 do table.insert(T,a9[O])end end end;local aa=ui.is_menu_open()local ab={}for O=1,#T do local H=S[T[O]]if H~=nil and H.in_menu==a5 then if H.title_bar_in_menu then H.title_bar=aa end;if H.pre_paint_callback~=nil then H:pre_paint_callback()end;if S[H.id]~=nil then table.insert(ab,S[H.id])end end end;if aa then local ac,ad=ui.mouse_position()local ae=client.key_state(0x01)if ae then for O=#ab,1,-1 do local H=ab[O]if H.visible and H:is_in_window(a1,a2)then H.first=true;if a3 then local af,ag=ac-a1,ad-a2;if H.position=="fixed"then local ah=H.left==nil and"right"or"left"local ai=H.top==nil and"bottom"or"top"local aj={{ah,(ah=="right"and-1 or 1)*af},{ai,(ai=="bottom"and-1 or 1)*ag}}for O=1,#aj do local ak,al=unpack(aj[O])local am=type(H[ak])if am=="string"and H[ak]:sub(-1,-1)=="%"then elseif am=="number"then H[ak]=H[ak]+al end end else H.x=H.x+af;H.y=H.y+ag end end;break end end end;a1,a2=ac,ad;a3=ae end;for O=1,#ab do local H=ab[O]if H.visible and H.in_menu==a5 then G(H)if H.paint_callback~=nil then H:paint_callback()end end end end;local a1,a2,a3;client.delay_call(0,client.set_event_callback,"paint",function()a4(false)end)client.delay_call(0,client.set_event_callback,"paint_ui",function()a4(true)end)return a end)()).new("watermark")
window.title = "Watermark"
window.title_bar = false
window.margin_bottom = 2
window.margin_left = 3
window.margin_right = 3
window.border_width = 2
window.top = 15
window.right = 15
window.in_menu = true

-- custom name
local db = database.read("sapphyrus_watermark") or {}

--local pingspike_reference = ui_reference("MISC", "Miscellaneous", "Ping spike")
local antiut_reference = ui_reference("MISC", "Settings", "Anti-untrusted")
local is_beta = pcall(ui_reference, "MISC", "Settings", "Crash logs")

local names = {"Logo", "Custom text", "FPS", "Ping", "KDR", "Server info", "Server framerate", "Server IP", "Network lag", "Tickrate", "Velocity", "Time", "Time + seconds"}

local watermark_reference = ui_new_multiselect("AA", "Other", "Watermark ", names)
local color_reference = ui_new_color_picker("AA", "Other", "Watermark", 149, 184, 6, 255)
local custom_name_reference = ui_new_textbox("AA", "Other", "Watermark name")
local rainbow_header_reference = ui_new_checkbox("AA", "Other", "Watermark rainbow header")

local fps_prev = 0
local value_prev = {}
local last_update_time = 0

local offset_x, offset_y = -15, 15
--local offset_x, offset_y = 525, 915 --debug, show above net_graph

local function clamp(cur_val, min_val, max_val)
	return math_min(math.max(cur_val, min_val), max_val)
end

local function lerp(a, b, percentage)
	return a + (b - a) * percentage
end

local function table_contains(tbl, val)
	for i=1, #tbl do
		if tbl[i] == val then
			return true
		end
	end
	return false
end

local function table_remove_element(tbl, val)
	local tbl_new = {}
	for i=1, #tbl do
		if tbl[i] ~= val then
			table_insert(tbl_new, tbl[i])
		end
	end
	return tbl_new
end

local function table_lerp(a, b, percentage)
	local result = {}
	for i=1, #a do
		result[i] = lerp(a[i], b[i], percentage)
	end
	return result
end

local function on_watermark_changed()
	local value = ui_get(watermark_reference)

	if #value > 0 then
		--Make Time / Time + seconds act as a kind of "switch", only allow one to be selected at a time.
		if table_contains(value, "Time") and table_contains(value, "Time + seconds") then
			local value_new = value
			if not table_contains(value_prev, "Time") then
				value_new = table_remove_element(value_new, "Time + seconds")
			elseif not table_contains(value_prev, "Time + seconds") then
				value_new = table_remove_element(value_new, "Time")
			end

			--this shouldn't happen, but why not add a failsafe
			if table_contains(value_new, "Time") and table_contains(value_new, "Time + seconds") then
				value_new = table_remove_element(value_new, "Time")
			end

			ui_set(watermark_reference, value_new)
			on_watermark_changed()
			return
		end
	end
	ui_set_visible(custom_name_reference, table_contains(value, "Custom text"))
	ui_set_visible(rainbow_header_reference, #value > 0)

	value_prev = value
end
ui_set_callback(watermark_reference, on_watermark_changed)
on_watermark_changed()

local function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math_floor(num * mult + 0.5) / mult
end

local ft_prev = 0
local function get_fps()
	ft_prev = ft_prev * 0.9 + globals_absoluteframetime() * 0.1
	return round(1 / ft_prev)
end

local function lerp_color_yellow_red(val, max_normal, max_yellow, max_red, default, yellow, red)
	default = default or {255, 255, 255}
	yellow = yellow or {230, 210, 40}
	red = red or {255, 32, 32}
	if val > max_yellow then
		return unpack(table_lerp(yellow, red, clamp((val-max_yellow)/(max_red-max_yellow), 0, 1)))
	else
		return unpack(table_lerp(default, yellow, clamp((val-max_normal)/(max_yellow-max_normal), 0, 1)))
	end
end

local watermark_items = {
	{
		--invinsible logo
		name = "Logo",
		get_width = function(self, frame_data)
			self.invin_width = renderer_measure_text(nil, "invin")
			self.sible_width = renderer_measure_text(nil, "sible")
			self.beta_width = (is_beta and (renderer_measure_text(nil, " [beta]")) or 0)
			return self.invin_width + self.sible_width + self.beta_width
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			local r_sible, g_sible, b_sible = ui_get(color_reference)

			renderer_text(x, y, 255, 255, 255, a, nil, 0, "invin")
			renderer_text(x+self.invin_width, y, r_sible, g_sible, b_sible, a, nil, 0, "sible")
			if is_beta then
				renderer_text(x+self.invin_width+self.sible_width, y, 255, 255, 255, a*0.9, nil, 0, " [beta]")
			end
		end
	},
	{
		name = "Custom text",
		get_width = function(self, frame_data)
			local edit = ui_get(custom_name_reference)
			if edit ~= self.edit_prev and self.edit_prev ~= nil then
				db.custom_name = edit
			elseif edit == "" and db.custom_name ~= nil then
				ui_set(custom_name_reference, db.custom_name)
			end
			self.edit_prev = edit

			local text = db.custom_name
			if text ~= nil and text:gsub(" ", "") ~= "" then
				self.text = text
				return renderer_measure_text(nil, text)
			else
				self.text = nil
			end
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			-- local r_sible, g_sible, b_sible = ui_get(color_reference)
			renderer_text(x, y, r, g, b, a, nil, 0, self.text)
		end
	},
	{
		name = "FPS",
		get_width = function(self, frame_data)
			self.fps = get_fps()
			self.text = tostring(self.fps or 0) .. " fps"

			local fps_max, fps_max_menu = cvar_fps_max:get_float(), cvar_fps_max_menu:get_float()
			local fps_max = globals.mapname() == nil and math.min(fps_max == 0 and 999 or fps_max, fps_max_menu == 0 and 999 or fps_max) or fps_max == 0 and 999 or fps_max

			self.width = math.max(renderer_measure_text(nil, self.text), renderer_measure_text(nil, fps_max .. " fps"))
			return self.width
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			--fps
			local fps_r, fps_g, fps_b = r, g, b
			if self.fps < (1 / globals_tickinterval()) then
				-- fps_r, fps_g, fps_b = 255, 0, 0
			end

			renderer_text(x+self.width, y, fps_r, fps_g, fps_b, a, "r", 0, self.text)
		end
	},
	{
		name = "Ping",
		get_width = function(self, frame_data)
			local ping = client_latency()
			if ping > 0 then
				self.ping = ping
				self.text = round(self.ping*1000, 0) .. "ms"
				self.width = math.max(renderer_measure_text(nil, "999ms"), renderer_measure_text(nil, self.text))
				return self.width
			end
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			if self.ping > 0.15 then
				r, g, b = 255, 0, 0
			end
			renderer_text(x+self.width, y, r, g, b, a, "r", 0, self.text)
		end
	},
	{
		name = "KDR",
		get_width = function(self, frame_data)
			frame_data.local_player = frame_data.local_player or entity.get_local_player()
			if frame_data.local_player == nil then return end

			local player_resource = entity_get_player_resource()
			if player_resource == nil then return end

			self.kills = entity_get_prop(player_resource, "m_iKills", frame_data.local_player)
			self.deaths = math.max(entity_get_prop(player_resource, "m_iDeaths", frame_data.local_player), 1)

			self.kdr = self.kills/self.deaths

			if self.kdr ~= 0 then
				self.text = string.format("%1.1f", round(self.kdr, 1))
				self.text_width = math.max(renderer_measure_text(nil, "10.0"), renderer_measure_text(nil, self.text))
				self.unit_width = renderer_measure_text("-", "kdr")
				return self.text_width+self.unit_width
			end
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			renderer_text(x+self.text_width, y, r, g, b, a, "r", 0, self.text)
			renderer_text(x+self.text_width+self.unit_width, y+2, 255, 255, 255, a*0.75, "r-", 0, "kdr")
		end
	},
	{
		name = "Velocity",
		get_width = function(self, frame_data)
			frame_data.local_player = frame_data.local_player or entity.get_local_player()
			if frame_data.local_player == nil then return end

			local vel_x, vel_y = entity_get_prop(frame_data.local_player, "m_vecVelocity")
			if vel_x ~= nil then
				self.velocity = math_sqrt(vel_x*vel_x + vel_y*vel_y)

				self.vel_width = renderer_measure_text(nil, "9999")
				self.unit_width = renderer_measure_text("-", "vel")
				return self.vel_width+self.unit_width
			end
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			local velocity = self.velocity
			-- velocity = string.rep(round(globals.realtime() % 9, 0), 4)
			velocity = math_min(9999, velocity) + 0.4
			velocity = round(velocity, 0)

			renderer_text(x+self.vel_width, y, 255, 255, 255, a, "r", 0, velocity)
			renderer_text(x+self.vel_width+self.unit_width, y+3, 255, 255, 255, a*0.75, "r-", 0, "vel")
		end
	},
	{
		name = "Server framerate",
		get_width = function(self, frame_data)
			if not allow_unsafe_scripts then return end

			frame_data.local_player = frame_data.local_player or entity.get_local_player()
			if frame_data.local_player == nil then return end

			frame_data.net_channel_info = frame_data.net_channel_info or native_GetNetChannelInfo()
			if frame_data.net_channel_info == nil then return end

			local frame_time, frame_time_std_dev, frame_time_start_time_std_dev = GetRemoteFramerate(frame_data.net_channel_info)
			if frame_time ~= nil then
				self.framerate = frame_time * 1000
				self.var = frame_time_std_dev * 1000

				self.text1 = "sv:"
				self.text2 = string.format("%.1f", self.framerate)
				self.text3 = " +-"
				self.text4 = string.format("%.1f", self.var)

				self.width1 = renderer_measure_text(nil, self.text1)
				self.width2 = math.max(renderer_measure_text(nil, self.text2), renderer_measure_text(nil, "99.9"))
				self.width3 = renderer_measure_text(nil, self.text3)
				self.width4 = math.max(renderer_measure_text(nil, self.text4), renderer_measure_text(nil, "9.9"))

				return self.width1 + self.width2 + self.width3 + self.width4
			end
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			local fr_r, fr_g, fr_b = lerp_color_yellow_red(self.framerate, 8, 14, 20, {r, g, b})
			local vr_r, vr_g, vr_b = lerp_color_yellow_red(self.var, 5, 10, 18, {r, g, b})

			renderer_text(x, y, r, g, b, a, nil, 0, self.text1)
			renderer_text(x+self.width1+self.width2, y, fr_r, fr_g, fr_b, a, "r", 0, self.text2)
			renderer_text(x+self.width1+self.width2, y, r, g, b, a, nil, 0, self.text3)
			renderer_text(x+self.width1+self.width2+self.width3, y, vr_r, vr_g, vr_b, a, nil, 0, self.text4)
		end
	},
	{
		name = "Network lag",
		get_width = function(self, frame_data)
			if not allow_unsafe_scripts then return end

			frame_data.local_player = frame_data.local_player or entity.get_local_player()
			if frame_data.local_player == nil then return end

			frame_data.net_channel_info = frame_data.net_channel_info or native_GetNetChannelInfo()
			if frame_data.net_channel_info == nil then return end

			local reasons = {}

			-- timeout
			local time_since_last_received = native_GetTimeSinceLastReceived(frame_data.net_channel_info)
			if time_since_last_received ~= nil and time_since_last_received > 0.1 then
				table_insert(reasons, string_format("%.1fs timeout", time_since_last_received))
			end

			-- loss
			local avg_loss = native_GetAvgLoss(frame_data.net_channel_info, FLOW_INCOMING)
			if avg_loss ~= nil and avg_loss > 0 then
				table_insert(reasons, string_format("%d%% loss", math.ceil(avg_loss*100)))
			end

			-- choke
			local avg_choke = native_GetAvgChoke(frame_data.net_channel_info, FLOW_INCOMING)
			if avg_choke > 0 then
				table_insert(reasons, string_format("%d%% choke", math.ceil(avg_choke*100)))
			end

			if #reasons > 0 then
				self.text = table.concat(reasons, ", ")
				return renderer_measure_text(nil, self.text)
			end
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			renderer_text(x, y, 255, 32, 32, a, nil, 0, self.text)
		end
	},
	{
		name = "Server info",
		get_width = function(self, frame_data)
			if not allow_unsafe_scripts then return end

			frame_data.local_player = frame_data.local_player or entity.get_local_player()
			if frame_data.local_player == nil then return end

			frame_data.net_channel_info = frame_data.net_channel_info or native_GetNetChannelInfo()
			if frame_data.net_channel_info == nil then return end
			frame_data.is_loopback = frame_data.is_loopback == nil and native_IsLoopback(frame_data.net_channel_info) or frame_data.is_loopback

			local game_rules = entity.get_game_rules()
			frame_data.is_valve_ds = frame_data.is_valve_ds == nil and entity.get_prop(game_rules, "m_bIsValveDS") == 1 or frame_data.is_valve_ds

			local text
			if frame_data.is_loopback then
				text = "Local server"
			elseif frame_data.is_valve_ds then
				local invin_mode_name
				local invin_mode, invin_type = cvar_invin_mode:get_int(), cvar_invin_type:get_int()

				local is_queued_matchmaking = entity.get_prop(game_rules, "m_bIsQueuedMatchmaking") == 1

				if is_queued_matchmaking then
					if invin_type == 0 and invin_mode == 1 then
						invin_mode_name = "MM"
					elseif invin_type == 0 and invin_mode == 2 then
						invin_mode_name = "Wingman"
					elseif invin_type == 3 then
						invin_mode_name = "Custom"
					elseif invin_type == 4 and invin_mode == 0 then
						invin_mode_name = "Guardian"
					elseif invin_type == 4 and invin_mode == 1 then
						invin_mode_name = "Co-op Strike"
					elseif invin_type == 6 and invin_mode == 0 then
						invin_mode_name = "Danger Zone"
					end
				else
					if invin_type == 0 and invin_mode == 0 then
						invin_mode_name = "Casual"
					elseif invin_type == 1 and invin_mode == 0 then
						invin_mode_name = "Arms Race"
					elseif invin_type == 1 and invin_mode == 1 then
						invin_mode_name = "Demolition"
					elseif invin_type == 1 and invin_mode == 2 then
						invin_mode_name = "Deathmatch"
					end
				end

				if invin_mode_name ~= nil then
					text = "Valve (" .. invin_mode_name .. ")"
				else
					text = "Valve"
				end
			end

			if text ~= nil then
				self.text = text
				return renderer_measure_text(nil, text)
			end
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, a, nil, 0, self.text)
		end
	},
	{
		name = "Server IP",
		get_width = function(self, frame_data)
			if not allow_unsafe_scripts then return end

			frame_data.net_channel_info = frame_data.net_channel_info or native_GetNetChannelInfo()
			if frame_data.net_channel_info == nil then return end

			frame_data.is_loopback = frame_data.is_loopback == nil and native_IsLoopback(frame_data.net_channel_info) or frame_data.is_loopback
			if frame_data.is_loopback then return end

			frame_data.is_valve_ds = frame_data.is_valve_ds == nil and entity.get_prop(entity.get_game_rules(), "m_bIsValveDS") == 1 or frame_data.is_valve_ds
			if frame_data.is_valve_ds then return end

			frame_data.server_address = frame_data.server_address or GetAddress(frame_data.net_channel_info)
			if frame_data.server_address ~= nil and frame_data.server_address ~= "" then
				self.text = frame_data.server_address
				return renderer_measure_text(nil, self.text)
			end
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, a, nil, 0, self.text)
		end
	},
	{
		name = "Tickrate",
		get_width = function(self, frame_data)
			if globals.mapname() == nil then return end

			local tickinterval = globals_tickinterval()
			if tickinterval ~= nil then
				local text = 1/globals_tickinterval() .. " tick"
				self.text = text
				return renderer_measure_text(nil, text)
			end
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			renderer_text(x, y, 255, 255, 255, a, nil, 0, self.text)
		end
	},
	{
		name = "Time",
		get_width = function(self, frame_data)
			self.time_width = renderer_measure_text(nil, "00")
			self.sep_width = renderer_measure_text(nil, ":")
			return self.time_width + self.sep_width + self.time_width + (self.seconds and (self.sep_width + self.time_width) or 0)
		end,
		draw = function(self, x, y, w, h, r, g, b, a)
			-- local time_center = x + 16

			local hours, minutes, seconds, milliseconds = client_system_time()
			hours, minutes = string_format("%02d", hours), string_format("%02d", minutes)
			-- renderer_text(time_center, y, 255, 255, 255, a, "r", 0, hours)
			-- renderer_text(time_center, y, 255, 255, 255, a, "", 0, ":")
			-- renderer_text(time_center+4, y, 255, 255, 255, a, "", 0, minutes)

			-- time_center = time_center + 18

			-- if self.seconds then
			-- 	seconds = string_format("%02d", seconds)
			-- 	renderer_text(time_center, y, 255, 255, 255, a, "", 0, ":")
			-- 	renderer_text(time_center+4, y, 255, 255, 255, a, "", 0, seconds)
			-- end

			renderer_text(x, y, 255, 255, 255, a, "", 0, hours)
			renderer_text(x+self.time_width, y, 255, 255, 255, a, "", 0, ":")
			renderer_text(x+self.time_width+self.sep_width, y, 255, 255, 255, a, "", 0, minutes)

			if self.seconds then
				seconds = string_format("%02d", seconds)
				renderer_text(x+self.time_width*2+self.sep_width, y, 255, 255, 255, a, "", 0, ":")
				renderer_text(x+self.time_width*2+self.sep_width*2, y, 255, 255, 255, a, "", 0, seconds)
			end

		end,
		seconds = false
	},
}

local items_drawn = {}
window.pre_paint_callback = function()
	table_clear(items_drawn)
	local value = ui_get(watermark_reference)

	if table_contains(value, "Custom text") then
		value = table_remove_element(value, "Custom text")
		if table_contains(value, "Logo") then
			table_insert(value, 2, "Custom text")
		else
			table_insert(value, 1, "Custom text")
		end
	end

	local screen_width, screen_height = client_screen_size()
	local x = offset_x >= 0 and offset_x or screen_width + offset_x
	local y = offset_y >= 0 and offset_y or screen_height + offset_y

	for i=1, #watermark_items do
		local item = watermark_items[i]
		if item.name == "Time" then
			item.seconds = table_contains(value, "Time + seconds")

			if item.seconds then
				table_insert(value, "Time")
			end
		end
	end

	--calculate width and draw container
	local item_margin = 9
	local width = 0

	local frame_data = {}

	for i=1, #watermark_items do
		local item = watermark_items[i]
		if table_contains(value, item.name) then
			local item_width = item:get_width(frame_data)
			if item_width ~= nil and item_width > 0 then
				table.insert(items_drawn, {
					item = item,
					item_width = item_width,
					x = width
				})
				width = width + item_width + item_margin
			end
		end
	end

	local _, height = renderer_measure_text(nil, "A")

	window.gradient_bar = ui_get(rainbow_header_reference)

	window:set_inner_width(width-item_margin)
	window:set_inner_height(height)

	window.visible = #items_drawn > 0
end

window.paint_callback = function()
	local r, g, b = 255, 255, 255
	local a_text = 230
	for i=1, #items_drawn do
		local item = items_drawn[i]

		-- bounding box
		-- renderer_rectangle(x_text+item.x, y_text, item.item_width, 14, 255, 0, 0, 100)

		-- draw item
		item.item:draw(window.i_x+item.x, window.i_y, item.item_width, 30, r, g, b, a_text)

		-- draw seperator
		if #items_drawn > i then
			renderer.rectangle(window.i_x+item.x+item.item_width+4, window.i_y+1, 1, window.i_h-1, 210, 210, 210, 255)
		end
	end
end

client.set_event_callback("shutdown", function()
	database.write("sapphyrus_watermark", db)
end)



                local x_ind, y_ind = client.screen_size()

                local lua_group = pui.group("aa", "anti-aimbot angles")
                local config_group = pui.group("aa", "Fake lag")
                local other_group = pui.group("aa", "other")
                pui.accent = "9FCA2BFF"

                local antiaim_cond = { '\vGlobal\r', '\vStand\r', '\vWalking\r', '\vRunning\r' , '\vAir\r', '\vAir+\r', '\vDuck\r', '\vDuck+Move\r' }
                local short_cond = { '\vG ·\r', '\vS ·\r', '\vW ·\r', '\vR ·\r' ,'\vA ·\r', '\vA+ ·\r', '\vD ·\r', '\vD+ ·\r' }

                local ref = {
                    enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
                    yawbase = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
                    fsbodyyaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
                    edgeyaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
                    fakeduck = ui.reference('RAGE', 'Other', 'Duck peek assist'),
                    forcebaim = ui.reference('RAGE', 'Aimbot', 'Force body aim'),
                    safepoint = ui.reference('RAGE', 'Aimbot', 'Force safe point'),
                    roll = { ui.reference('AA', 'Anti-aimbot angles', 'Roll') },
                    clantag = ui.reference('Misc', 'Miscellaneous', 'Clan tag spammer'),

                    pitch = { ui.reference('AA', 'Anti-aimbot angles', 'pitch'), },
                    rage = { ui.reference('RAGE', 'Aimbot', 'Enabled') },
                    yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw') }, 
                    yawjitter = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
                    bodyyaw = { ui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
                    freestand = { ui.reference('AA', 'Anti-aimbot angles', 'Freestanding') },
                    slow = { ui.reference('AA', 'Other', 'Slow motion') },
                    os = { ui.reference('AA', 'Other', 'On shot anti-aim') },
                    slow = { ui.reference('AA', 'Other', 'Slow motion') },
                    dt = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
                    minimum_damage_override = { ui.reference("RAGE", "Aimbot", "Minimum damage override") }
                }

                local lua_menu = {
                    Tweaks = {
                        mesto4 = lua_group:label("  "),
                        mesto3 = lua_group:label("  "),
                        enable = lua_group:label("         I N V I N S I B L E     "),
                        mesto = lua_group:label("  "),
                        mesto2 = lua_group:label("  "),
                        tab = lua_group:combobox('Current Tab', {"Anti-Aim", "Visuals", "Misc"}),
                    },
                    antiaim = {
                        tab = lua_group:combobox("\v AA Tab", {"Tweaks", "Builder"}),
                        addons = lua_group:multiselect('\v \rAA Tweaks', {'Warmup Anti~Aim', 'Anti~Knife', 'Safe Head'}),
                        safe_head = lua_group:multiselect('\v \rSafe Head', {'Air+C Knife', 'Air+C Zeus', 'High Distance'}),
                        yaw_direction = lua_group:multiselect('\v \rYaw Override', {'Freestanding', 'Manual'}),
                        key_freestand = lua_group:hotkey('\v \rFreestanding'),
                        key_left = lua_group:hotkey('\v \rManual Left'),
                        key_right = lua_group:hotkey('\v \rManual Right'),
                        key_forward = lua_group:hotkey('\v \rManual Forward'),
                        yaw_base = lua_group:combobox("\v \rYaw Base", {"Local view", "At targets"}),
                        condition = lua_group:combobox('\v \vCondition', antiaim_cond),
                    },
                    misc = {
                        cross_ind = lua_group:checkbox("\v \rScreen Indicators", {255, 255, 255}),
                        cross_ind_type = lua_group:combobox("  \v \rIndicator Style", {"Newest", "Standart"}),
                        cross_color = lua_group:checkbox("  \v \rIndicator Color", {100, 100, 255}),
                        key_color = lua_group:checkbox("  \v \rKeybinds Color", {255, 255, 255}),
                        info_panel = lua_group:checkbox(" Watermark"),
                        defensive_window = lua_group:checkbox("\v \rDefensive Window", {255, 255, 255}),
                        defensive_style = lua_group:combobox("  \v \rDefensive Style", {"Default", "Modern"}),
                        velocity_window = lua_group:checkbox("\v \rVelocity Window", {255, 255, 255}),
                        velocity_style = lua_group:combobox("  \v \rDefensive Style", {"Default", "Modern"}),
                        fast_ladder = lua_group:checkbox("\v \rFast Ladder"),
                        log = lua_group:checkbox("\v \rRagebot Logs"),
                        log_type = lua_group:multiselect("  \v \rLog Types", {"Console", "Screen"}),
                        screen_type = lua_group:combobox("  \v \rLog Style", {"Default", "Modern"}),
                        animation = lua_group:checkbox("\v \rAnimation Breakers"),
                        animation_ground = lua_group:combobox("  \v \rGround", {"Static", "Jitter", "Randomize"}),
                        animation_value = lua_group:slider("  \v \rValue", 0, 10, 5),
                        animation_air = lua_group:combobox("  \v \rAir", {"Off", "Static", "Randomize"}),
                        third_person = lua_group:checkbox("\v \rThird Person Distance"),
                        third_person_value = lua_group:slider("  \v \r Third Person Distance Value", 30, 200, 50),
                        aspectratio = lua_group:checkbox("\v \rAspect Ratio"),
                        aspectratio_value = lua_group:slider("  \v \r Aspect Ratio Value", 00, 200, 133),
                        resolver = lua_group:checkbox(" Resolver"),
                        resolver_type = lua_group:combobox("  \v \r Resolver Type", {"Safe", "Experimental", "Defensive"}),
                        luaadvertise = lua_group:multiselect("\v \r Lua Advertise", {"Clantag", "TrashTalk"}),
                    },
                }

                local antiaim_system = {}

                for i=1, #antiaim_cond do
                    antiaim_system[i] = {
                        label = lua_group:label(' · Conditional \vBuilder\r Setup ~ '),
                        enable = lua_group:checkbox('Enable · '..antiaim_cond[i]),
                        yaw_type = lua_group:combobox(short_cond[i]..' Yaw Type', {"Default", "Delay"}),
                        yaw_delay = lua_group:slider(short_cond[i]..' Delay Ticks', 1, 10, 4, true, 't', 1),
                        yaw_left = lua_group:slider(short_cond[i]..' Yaw Left', -180, 180, 0, true, '°', 1),
                        yaw_right = lua_group:slider(short_cond[i]..' Yaw Right', -180, 180, 0, true, '°', 1),
                        yaw_random = lua_group:slider(short_cond[i]..' Randomization', 0, 100, 0, true, '%', 1),
                        mod_type = lua_group:combobox(short_cond[i]..' Jitter Type', {'Off', 'Offset', 'Center', 'Random', 'Skitter'}),
                        mod_dm = lua_group:slider(short_cond[i]..' Jitter Amount', -180, 180, 0, true, '°', 1),
                        body_yaw_type = lua_group:combobox(short_cond[i]..' Body Yaw', {'Off', 'Opposite', 'Jitter', 'Static'}),
                        body_slider = lua_group:slider(short_cond[i]..' Body Yaw Amount', -180, 180, 0, true, '°', 1),
                        force_def = lua_group:checkbox(short_cond[i]..' Force Defensive'),
                        peek_def = lua_group:checkbox(short_cond[i]..' \vDefensive Peek'),
                        defensive = lua_group:checkbox(short_cond[i]..' Defensive Anti~Aim'),
                        defensive_type = lua_group:combobox(short_cond[i]..' Defensive Type', {'Default', 'Builder'}),

                        defensive_yaw = lua_group:combobox(short_cond[i]..' Defensive Yaw', {'Off', 'Spin', 'Meta~Ways', 'Random'}),

                        yaw_value = lua_group:slider(short_cond[i]..' Yaw Value', -180, 180, 0, true, '°', 1),
                        def_yaw_value = lua_group:slider(short_cond[i]..' [DEF] Yaw Value', -180, 180, 0, true, '°', 1),
                        def_mod_type = lua_group:combobox(short_cond[i]..' [DEF] Jitter Type', {'Off', 'Offset', 'Center', 'Random', 'Skitter'}),
                        def_mod_dm = lua_group:slider(short_cond[i]..' [DEF] Jitter Amount', -180, 180, 0, true, '°', 1),
                        def_body_yaw_type = lua_group:combobox(short_cond[i]..' [DEF] Body Yaw', {'Off', 'Opposite', 'Jitter', 'Static'}),
                        def_body_slider = lua_group:slider(short_cond[i]..' [DEF] Body Yaw Amount', -180, 180, 0, true, '°', 1),

                        defensive_pitch = lua_group:combobox(short_cond[i]..' Defensive Pitch', {'Off', 'Custom', 'Meta~Ways', 'Random'}),
                        pitch_value = lua_group:slider(short_cond[i]..' Pitch Value', -89, 89, 0, true, '°', 1)
                    }
                end

                local aa_tab = {lua_menu.Tweaks.tab, "Anti-Aim"}
                local misc_tab = {lua_menu.Tweaks.tab, "Misc"}
                local visual_tab = {lua_menu.Tweaks.tab, "Visuals"}
                local aa_builder = {lua_menu.antiaim.tab, "Builder"}
                local aa_Tweaks = {lua_menu.antiaim.tab, "Tweaks"}

                lua_menu.antiaim.tab:depend(aa_tab)
                lua_menu.antiaim.addons:depend(aa_tab, aa_Tweaks)
                lua_menu.antiaim.safe_head:depend(aa_tab, {lua_menu.antiaim.addons, "Safe Head"}, aa_Tweaks)
                lua_menu.antiaim.yaw_base:depend(aa_tab, aa_Tweaks)
                lua_menu.antiaim.condition:depend(aa_tab, aa_builder)
                lua_menu.antiaim.yaw_direction:depend(aa_tab, aa_Tweaks)
                lua_menu.antiaim.key_freestand:depend(aa_tab, {lua_menu.antiaim.yaw_direction, "Freestanding"}, aa_Tweaks)
                lua_menu.antiaim.key_left:depend(aa_tab, {lua_menu.antiaim.yaw_direction, "Manual"}, aa_Tweaks)
                lua_menu.antiaim.key_right:depend(aa_tab, {lua_menu.antiaim.yaw_direction, "Manual"}, aa_Tweaks)
                lua_menu.antiaim.key_forward:depend(aa_tab, {lua_menu.antiaim.yaw_direction, "Manual"}, aa_Tweaks)
                lua_menu.misc.cross_ind:depend(visual_tab)
                lua_menu.misc.cross_ind_type:depend(visual_tab, {lua_menu.misc.cross_ind, true})
                lua_menu.misc.info_panel:depend(visual_tab)
                lua_menu.misc.defensive_window:depend(visual_tab)
                lua_menu.misc.defensive_style:depend(visual_tab, {lua_menu.misc.defensive_window, true})
                lua_menu.misc.velocity_window:depend(visual_tab)
                lua_menu.misc.velocity_style:depend(visual_tab, {lua_menu.misc.velocity_window, true})
                lua_menu.misc.cross_color:depend(visual_tab, {lua_menu.misc.cross_ind, true})
                lua_menu.misc.key_color:depend(visual_tab, {lua_menu.misc.cross_ind, true})
                lua_menu.misc.log:depend(visual_tab)
                lua_menu.misc.log_type:depend(visual_tab, {lua_menu.misc.log, true})
                lua_menu.misc.screen_type:depend(visual_tab, {lua_menu.misc.log, true}, {lua_menu.misc.log_type, "Screen"})
                lua_menu.misc.fast_ladder:depend(misc_tab)
                lua_menu.misc.animation:depend(misc_tab)
                lua_menu.misc.animation_ground:depend(misc_tab, {lua_menu.misc.animation, true})
                lua_menu.misc.animation_value:depend(misc_tab, {lua_menu.misc.animation, true})
                lua_menu.misc.animation_air:depend(misc_tab, {lua_menu.misc.animation, true})
                lua_menu.misc.third_person:depend(misc_tab)
                lua_menu.misc.third_person_value:depend(misc_tab, {lua_menu.misc.third_person, true})
                lua_menu.misc.aspectratio:depend(misc_tab)
                lua_menu.misc.aspectratio_value:depend(misc_tab, {lua_menu.misc.aspectratio, true})
                lua_menu.misc.resolver:depend(misc_tab)
                lua_menu.misc.resolver_type:depend(misc_tab, {lua_menu.misc.resolver, true})
                lua_menu.misc.luaadvertise:depend(misc_tab)

                for i=1, #antiaim_cond do
                    local cond_check = {lua_menu.antiaim.condition, function() return (i ~= 1) end}
                    local tab_cond = {lua_menu.antiaim.condition, antiaim_cond[i]}
                    local cnd_en = {antiaim_system[i].enable, function() if (i == 1) then return true else return antiaim_system[i].enable:get() end end}
                    local aa_tab = {lua_menu.Tweaks.tab, "Anti-Aim"}
                    local jit_ch = {antiaim_system[i].mod_type, function() return antiaim_system[i].mod_type:get() ~= "Off" end}
                    local def_jit_ch = {antiaim_system[i].def_mod_type, function() return antiaim_system[i].def_mod_type:get() ~= "Off" end}
                    local def_ch = {antiaim_system[i].defensive, true}
                    local body_ch = {antiaim_system[i].body_yaw_type, function() return antiaim_system[i].body_yaw_type:get() ~= "Off" end}
                    local def_body_ch = {antiaim_system[i].def_body_yaw_type, function() return antiaim_system[i].def_body_yaw_type:get() ~= "Off" end}
                    local delay_ch = {antiaim_system[i].yaw_type, "Delay"}
                    local yaw_ch = {antiaim_system[i].defensive_yaw, "Spin"}
                    local def_yaw_ch = {antiaim_system[i].defensive_type, "Builder"}

                    local def_def = {antiaim_system[i].defensive_type, "Default"}
                    local def_build = {antiaim_system[i].defensive_type, "Builder"}
                    local pitch_ch = {antiaim_system[i].defensive_pitch, "Custom"}
                    antiaim_system[i].label:depend(tab_cond, aa_tab, aa_builder)
                    antiaim_system[i].enable:depend(cond_check, tab_cond, aa_tab, aa_builder)
                    antiaim_system[i].yaw_type:depend(cnd_en, tab_cond, aa_tab, aa_builder)
                    antiaim_system[i].yaw_delay:depend(cnd_en, tab_cond, aa_tab, delay_ch, aa_builder)
                    antiaim_system[i].yaw_left:depend(cnd_en, tab_cond, aa_tab, aa_builder)
                    antiaim_system[i].yaw_right:depend(cnd_en, tab_cond, aa_tab, aa_builder)
                    antiaim_system[i].yaw_random:depend(cnd_en, tab_cond, aa_tab, aa_builder)
                    antiaim_system[i].mod_type:depend(cnd_en, tab_cond, aa_tab, aa_builder)

                    antiaim_system[i].mod_dm:depend(cnd_en, tab_cond, aa_tab, jit_ch, aa_builder)
                    antiaim_system[i].body_yaw_type:depend(cnd_en, tab_cond, aa_tab, aa_builder)
                    antiaim_system[i].body_slider:depend(cnd_en, tab_cond, aa_tab, body_ch, aa_builder)

                    antiaim_system[i].force_def:depend(cnd_en, tab_cond, aa_tab, aa_builder)
                    antiaim_system[i].peek_def:depend(cnd_en, tab_cond, aa_tab, {antiaim_system[i].force_def, false}, aa_builder)
                    antiaim_system[i].defensive:depend(cnd_en, tab_cond, aa_tab, aa_builder)
                    antiaim_system[i].defensive_type:depend(cnd_en, tab_cond, aa_tab, def_ch, aa_builder)
                    antiaim_system[i].defensive_yaw:depend(cnd_en, tab_cond, aa_tab, def_ch, def_def, aa_builder)
                    antiaim_system[i].def_yaw_value:depend(cnd_en, tab_cond, aa_tab, def_ch, def_yaw_ch, aa_builder)
                    antiaim_system[i].yaw_value:depend(cnd_en, tab_cond, aa_tab, def_ch, yaw_ch, def_def, aa_builder)
                    antiaim_system[i].def_mod_type:depend(cnd_en, tab_cond, aa_tab, def_ch, def_build, aa_builder)
                    antiaim_system[i].def_mod_dm:depend(cnd_en, tab_cond, aa_tab, def_ch, def_build, def_jit_ch, aa_builder)
                    antiaim_system[i].def_body_yaw_type:depend(cnd_en, tab_cond, aa_tab, def_ch, def_build, aa_builder)
                    antiaim_system[i].def_body_slider:depend(cnd_en, tab_cond, aa_tab, def_ch, def_build, def_body_ch, aa_builder)
                    antiaim_system[i].defensive_pitch:depend(cnd_en, tab_cond, aa_tab, def_ch, aa_builder)
                    antiaim_system[i].pitch_value:depend(cnd_en, tab_cond, aa_tab, def_ch, pitch_ch, aa_builder)
                end

                local function hide_original_menu(state)
                    ui.set_visible(ref.enabled, state)
                    ui.set_visible(ref.pitch[1], state)
                    ui.set_visible(ref.pitch[2], state)
                    ui.set_visible(ref.yawbase, state)
                    ui.set_visible(ref.yaw[1], state)
                    ui.set_visible(ref.yaw[2], state)
                    ui.set_visible(ref.yawjitter[1], state)
                    ui.set_visible(ref.roll[1], state)
                    ui.set_visible(ref.yawjitter[2], state)
                    ui.set_visible(ref.bodyyaw[1], state)
                    ui.set_visible(ref.bodyyaw[2], state)
                    ui.set_visible(ref.fsbodyyaw, state)
                    ui.set_visible(ref.edgeyaw, state)
                    ui.set_visible(ref.freestand[1], state)
                    ui.set_visible(ref.freestand[2], state)
                end

                local function randomize_value(original_value, percent)
                    local min_range = original_value - (original_value * percent / 100)
                    local max_range = original_value + (original_value * percent / 100)
                    return math.random(min_range, max_range)
                end

                local last_sim_time = 0
                local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')

                function is_defensive_active(lp)
                    if globals.chokedcommands() > 1 then return false end
                    if lp == nil or not entity.is_alive(lp) then return end
                    local m_flOldSimulationTime = ffi.cast("float*", ffi.cast("uintptr_t", native_GetClientEntity(lp)) + 0x26C)[0]
                    local m_flSimulationTime = entity.get_prop(lp, "m_flSimulationTime")
                    local delta = toticks(m_flOldSimulationTime - m_flSimulationTime)
                    if delta > 0 then
                        last_sim_time = globals.tickcount() + delta - toticks(client.real_latency())
                    end
                    return last_sim_time > globals.tickcount()
                end

                function is_defensive_resolver(lp)
                    if lp == nil or not entity.is_alive(lp) then return end
                    local m_flOldSimulationTime = ffi.cast("float*", ffi.cast("uintptr_t", native_GetClientEntity(lp)) + 0x26C)[0]
                    local m_flSimulationTime = entity.get_prop(lp, "m_flSimulationTime")
                    local delta = toticks(m_flOldSimulationTime - m_flSimulationTime)
                    if delta > 0 then
                        last_sim_time = globals.tickcount() + delta - toticks(client.real_latency())
                    end
                    return last_sim_time > globals.tickcount()
                end

                local id = 1   
                local function player_state(cmd)
                    local lp = entity.get_local_player()
                    if lp == nil then return end

                    local vecvelocity = { entity.get_prop(lp, 'm_vecVelocity') }
                    local flags = entity.get_prop(lp, 'm_fFlags')
                    local velocity = math.sqrt(vecvelocity[1]^2+vecvelocity[2]^2)
                    local groundcheck = bit.band(flags, 1) == 1
                    local jumpcheck = bit.band(flags, 1) == 0 or cmd.in_jump == 1
                    local ducked = entity.get_prop(lp, 'm_flDuckAmount') > 0.7
                    local duckcheck = ducked or ui.get(ref.fakeduck)
                    local slowwalk_key = ui.get(ref.slow[1]) and ui.get(ref.slow[2])

                    if jumpcheck and duckcheck then return "Air+C"
                    elseif jumpcheck then return "Air"
                    elseif duckcheck and velocity > 10 then return "Duck-Moving"
                    elseif duckcheck and velocity < 10 then return "Duck"
                    elseif groundcheck and slowwalk_key and velocity > 10 then return "Walking"
                    elseif groundcheck and velocity > 5 then return "Moving"
                    elseif groundcheck and velocity < 5 then return "Stand"
                    else return "Global" end
                end

                local yaw_direction = 0
                local last_press_t_dir = 0

                local run_direction = function()
                    ui.set(ref.freestand[1], lua_menu.antiaim.yaw_direction:get("Freestanding"))
                    ui.set(ref.freestand[2], lua_menu.antiaim.key_freestand:get() and 'Always on' or 'On hotkey')

                    if yaw_direction ~= 0 then
                        ui.set(ref.freestand[1], false)
                    end

                    if lua_menu.antiaim.yaw_direction:get("Manual") and lua_menu.antiaim.key_right:get() and last_press_t_dir + 0.2 < globals.curtime() then
                        yaw_direction = yaw_direction == 90 and 0 or 90
                        last_press_t_dir = globals.curtime()
                    elseif lua_menu.antiaim.yaw_direction:get("Manual") and lua_menu.antiaim.key_left:get() and last_press_t_dir + 0.2 < globals.curtime() then
                        yaw_direction = yaw_direction == -90 and 0 or -90
                        last_press_t_dir = globals.curtime()
                    elseif lua_menu.antiaim.yaw_direction:get("Manual") and lua_menu.antiaim.key_forward:get() and last_press_t_dir + 0.2 < globals.curtime() then
                        yaw_direction = yaw_direction == 180 and 0 or 180
                        last_press_t_dir = globals.curtime()
                    elseif last_press_t_dir > globals.curtime() then
                        last_press_t_dir = globals.curtime()
                    end
                end

                anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
                    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
                end

                local function is_vulnerable()
                    for _, v in ipairs(entity.get_players(true)) do
                        local flags = (entity.get_esp_data(v)).flags
                        if bit.band(flags, bit.lshift(1, 11)) ~= 0 then
                            return true
                        end
                    end
                    return false
                end

                local function safe_func()
                    ui.set(ref.yawjitter[1], "Off")
                    ui.set(ref.yaw[1], '180')
                    ui.set(ref.bodyyaw[1], "Static")
                    ui.set(ref.bodyyaw[2], 1)
                    ui.set(ref.yaw[2], 14)
                    ui.set(ref.pitch[2], 89)
                end

                local current_tickcount = 0
                local to_jitter = false
                local to_defensive = true
                local first_execution = true
                local yaw_amount = 0

                local function defensive_peek()
                    to_defensive = false
                end

                local function defensive_disabler()
                    to_defensive = true
                end

                local function aa_setup(cmd)
                   
                    local lp = entity.get_local_player()
                    if lp == nil then return end
                    if player_state(cmd) == "Duck-Moving" and antiaim_system[8].enable:get() then id = 8
                    elseif player_state(cmd) == "Duck" and antiaim_system[7].enable:get() then id = 7
                    elseif player_state(cmd) == "Air+C" and antiaim_system[6].enable:get() then id = 6
                    elseif player_state(cmd) == "Air" and antiaim_system[5].enable:get() then id = 5
                    elseif player_state(cmd) == "Moving" and antiaim_system[4].enable:get() then id = 4
                    elseif player_state(cmd) == "Walking" and antiaim_system[3].enable:get() then id = 3
                    elseif player_state(cmd) == "Stand" and antiaim_system[2].enable:get() then id = 2
                    else id = 1 end

                    ui.set(ref.roll[1], 0)

                    run_direction()

                    if globals.tickcount() > current_tickcount + antiaim_system[id].yaw_delay:get() then
                        if cmd.chokedcommands == 0 then
                            to_jitter = not to_jitter
                            current_tickcount = globals.tickcount()
                        end
                    elseif globals.tickcount() <  current_tickcount then
                        current_tickcount = globals.tickcount()
                    end


                    if is_vulnerable() then
                        if first_execution then
                            first_execution = false
                            to_defensive = true
                            client.set_event_callback("setup_command", defensive_disabler)
                        end
                        if globals.tickcount() % 10 == 9 then
                            defensive_peek()
                            client.unset_event_callback("setup_command", defensive_disabler)
                        end
                    else
                        first_execution = true
                        to_defensive = false
                    end

                    ui.set(ref.fsbodyyaw, false)
                    ui.set(ref.pitch[1], "Custom")
                    ui.set(ref.yawbase, lua_menu.antiaim.yaw_base:get())

                    local selected_builder_def = antiaim_system[id].defensive:get() and antiaim_system[id].defensive_type:get() == "Builder" and is_defensive_active(lp)

                    if selected_builder_def then
                        ui.set(ref.yawjitter[1], antiaim_system[id].def_mod_type:get())
                        ui.set(ref.yawjitter[2], antiaim_system[id].def_mod_dm:get())
                        ui.set(ref.bodyyaw[1], antiaim_system[id].def_body_yaw_type:get())
                        ui.set(ref.bodyyaw[2], antiaim_system[id].def_body_slider:get())
                        yaw_amount = yaw_direction == 0 and antiaim_system[id].def_yaw_value:get() or yaw_direction
                    else
                        ui.set(ref.yawjitter[1], antiaim_system[id].mod_type:get())
                        ui.set(ref.yawjitter[2], antiaim_system[id].mod_dm:get())
                        if antiaim_system[id].yaw_type:get() == "Delay" then
                            ui.set(ref.bodyyaw[1], "Static")
                            ui.set(ref.bodyyaw[2], to_jitter and 1 or -1)
                        else
                            ui.set(ref.bodyyaw[1], antiaim_system[id].body_yaw_type:get())
                            ui.set(ref.bodyyaw[2], antiaim_system[id].body_slider:get())
                        end
                    end

                    if is_defensive_active(lp) and antiaim_system[id].defensive:get() and antiaim_system[id].defensive_type:get() == "Default" and antiaim_system[id].defensive_yaw:get() == "Spin" then
                        ui.set(ref.yaw[1], 'Spin')
                    else
                        ui.set(ref.yaw[1], '180')
                    end
                    
                    cmd.force_defensive = antiaim_system[id].force_def:get() or antiaim_system[id].peek_def:get() and to_defensive

                    local desync_type = entity.get_prop(lp, 'm_flPoseParameter', 11) * 120 - 60
                    local desync_side = desync_type > 0

                    if is_defensive_active(lp) and antiaim_system[id].defensive:get() and antiaim_system[id].defensive_type:get() == "Default" then
                        if antiaim_system[id].defensive_yaw:get() == "Spin" then
                            yaw_amount = antiaim_system[id].yaw_value:get()
                        elseif antiaim_system[id].defensive_yaw:get() == "Meta~Ways" then
                            yaw_amount = desync_side and 90 or -90
                        elseif antiaim_system[id].defensive_yaw:get() == "Random" then
                            yaw_amount = math.random(-180, 180)
                        else
                            yaw_amount = desync_side and randomize_value(antiaim_system[id].yaw_left:get(), antiaim_system[id].yaw_random:get()) or randomize_value(antiaim_system[id].yaw_right:get(), antiaim_system[id].yaw_random:get())
                        end
                    elseif not selected_builder_def then
                        yaw_amount = desync_side and randomize_value(antiaim_system[id].yaw_left:get(), antiaim_system[id].yaw_random:get()) or randomize_value(antiaim_system[id].yaw_right:get(), antiaim_system[id].yaw_random:get())
                        ui.set(ref.pitch[2], 89)
                    end


                    if is_defensive_active(lp) and antiaim_system[id].defensive:get() then
                        if antiaim_system[id].defensive_pitch:get() == "Custom" then
                            ui.set(ref.pitch[2], antiaim_system[id].pitch_value:get())
                        elseif antiaim_system[id].defensive_pitch:get() == "Meta~Ways" then
                            ui.set(ref.pitch[2], desync_side and 49 or -49)
                        elseif antiaim_system[id].defensive_pitch:get() == "Random" then
                            ui.set(ref.pitch[2], math.random(-89, 89))
                        else
                            ui.set(ref.pitch[2], 89)
                        end
                    end

                    ui.set(ref.yaw[2], yaw_direction == 0 and yaw_amount or yaw_direction)
                  
                    local players = entity.get_players(true)
                    if lua_menu.antiaim.addons:get("Warmup Anti~Aim") then
                        if entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod") == 1 then
                            ui.set(ref.yaw[2], math.random(-180, 180))
                            ui.set(ref.yawjitter[2], math.random(-180, 180))
                            ui.set(ref.bodyyaw[2], math.random(-180, 180))
                            ui.set(ref.pitch[1], "Custom")
                            ui.set(ref.pitch[2], math.random(-89, 89)) 
                        end
                    end

                    local threat = client.current_threat()
                    local lp_weapon = entity.get_player_weapon(lp)
                    local lp_orig_x, lp_orig_y, lp_orig_z = entity.get_prop(lp, "m_vecOrigin")
                    local flags = entity.get_prop(lp, 'm_fFlags')
                    local jumpcheck = bit.band(flags, 1) == 0 or cmd.in_jump == 1
                    local ducked = entity.get_prop(lp, 'm_flDuckAmount') > 0.7

                    if lua_menu.antiaim.addons:get("Safe Head") then
                        if lp_weapon ~= nil then
                            if lua_menu.antiaim.safe_head:get("Air+C Knife") then
                                if jumpcheck and ducked and entity.get_classname(lp_weapon) == "CKnife" then
                                    safe_func()
                                end
                            end
                            if lua_menu.antiaim.safe_head:get("Air+C Zeus") then
                                if jumpcheck and ducked and entity.get_classname(lp_weapon) == "CWeaponTaser" then
                                    safe_func()
                                end
                            end
                            if lua_menu.antiaim.safe_head:get("High Distance") then
                                if threat ~= nil then
                                    threat_x, threat_y, threat_z = entity.get_prop(threat, "m_vecOrigin")
                                    threat_dist = anti_knife_dist(lp_orig_x, lp_orig_y, lp_orig_z, threat_x, threat_y, threat_z)
                                    if threat_dist > 900 then
                                        safe_func()
                                    end
                                end
                            end
                        end
                    end
                                
                    if lua_menu.antiaim.addons:get("Anti~Knife") then
                        for i=1, #players do
                            if players == nil then return end
                            enemy_orig_x, enemy_orig_y, enemy_orig_z = entity.get_prop(players[i], "m_vecOrigin")
                            distance_to = anti_knife_dist(lp_orig_x, lp_orig_y, lp_orig_z, enemy_orig_x, enemy_orig_y, enemy_orig_z)
                            weapon = entity.get_player_weapon(players[i])
                            if weapon == nil then return end
                            if entity.get_classname(weapon) == "CKnife" and distance_to <= 250 then
                                ui.set(ref.yaw[2], 180)
                                ui.set(ref.yawbase, "At targets")
                            end
                        end
                    end
                end

                local lastmiss = 0
                local function GetClosestPoint(A, B, P)
                    a_to_p = { P[1] - A[1], P[2] - A[2] }
                    a_to_b = { B[1] - A[1], B[2] - A[2] }
                
                    atb2 = a_to_b[1]^2 + a_to_b[2]^2
                
                    atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
                    t = atp_dot_atb / atb2
                    
                    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
                end
             
                client.set_event_callback("bullet_impact", function(e)                  
                    if not entity.is_alive(entity.get_local_player()) then return end
                    local ent = client.userid_to_entindex(e.userid)
                    if ent ~= client.current_threat() then return end
                    if entity.is_dormant(ent) or not entity.is_enemy(ent) then return end
                
                    local ent_origin = { entity.get_prop(ent, "m_vecOrigin") }
                    ent_origin[3] = ent_origin[3] + entity.get_prop(ent, "m_vecViewOffset[2]")
                    local local_head = { entity.hitbox_position(entity.get_local_player(), 0) }
                    local closest = GetClosestPoint(ent_origin, { e.x, e.y, e.z }, local_head)
                    local delta = { local_head[1]-closest[1], local_head[2]-closest[2] }
                    local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)
                    if math.abs(delta_2d) <= 60 and globals.curtime() - lastmiss > 0.015 then
                        lastmiss = globals.curtime()
                        if lua_menu.misc.log_type:get("Screen") then
                            renderer.log(entity.get_player_name(ent).." Shot At You")
                        end
                    end
                end)

                local function anim_breaker()
                    local lp = entity.get_local_player()
                    if not lp then return end
                    if not entity.is_alive(lp) then return end

                    local self_index = c_entity.new(lp)
                    local self_anim_state = self_index:get_anim_state()
                    if not self_anim_state then
                        return
                    end

                    local self_anim_overlay = self_index:get_anim_overlay(12)
                    if not self_anim_overlay then
                        return
                    end
                    local x_velocity = entity.get_prop(lp, "m_vecVelocity[0]")
                    if math.abs(x_velocity) >= 3 then
                        self_anim_overlay.weight = 1
                    end

                    if lua_menu.misc.animation_ground:get() == "Static" then
                        entity.set_prop(lp, "m_flPoseParameter", lua_menu.misc.animation_value:get()/10, 0)
                    elseif lua_menu.misc.animation_ground:get() == "Jitter" then
                        entity.set_prop(lp, "m_flPoseParameter", globals.tickcount() %4 > 1 and lua_menu.misc.animation_value:get()/10 or 0, 0)
                    else
                        entity.set_prop(lp, "m_flPoseParameter", math.random(lua_menu.misc.animation_value:get(), 10)/10, 0)
                    end
                    
                    if lua_menu.misc.animation_air:get() == "Static" then
                        entity.set_prop(lp, "m_flPoseParameter", 1, 6)
                    elseif lua_menu.misc.animation_air:get() == "Randomize" then
                        entity.set_prop(lp, "m_flPoseParameter", math.random(0, 10)/10, 6)
                    end
                end

                local function auto_tp(cmd)
                    local lp = entity.get_local_player()
                    if lp == nil then return end
                    local flags = entity.get_prop(lp, 'm_fFlags')
                    local jumpcheck = bit.band(flags, 1) == 0
                    if is_vulnerable() and jumpcheck then
                        cmd.force_defensive = true
                        cmd.discharge_pending = true
                    end
                end

                local screen = {client.screen_size()}
                local center = {screen[1]/2, screen[2]/2} 

                math.lerp = function(name, value, speed)
                    return name + (value - name) * globals.absoluteframetime() * speed
                end

                local logs = {}
                local function ragebot_logs()
                    local offset, x, y = 0, screen[1] / 2, screen[2] / 1.4
                    for idx, data in ipairs(logs) do
                        if (((globals.curtime()/2) * 2.0) - data[3]) < 4.0 and not (#logs > 5 and idx < #logs - 5) then
                            data[2] = math.lerp(data[2], 255, 10)
                        else
                            data[2] = math.lerp(data[2], 0, 10)
                        end
                        offset = offset - 40 * (data[2] / 255)

                        text_size_x, text_sise_y = renderer.measure_text("", data[1])
                        if lua_menu.misc.screen_type:get() == "Default" then
                            renderer.rectangle(x - 7 - text_size_x / 2, y - offset-8, text_size_x + 13, 26, 0, 0, 0, (data[2] / 255) * 150)
                            renderer.rectangle(x - 6 - text_size_x / 2, y - offset-7, text_size_x + 11, 24, 50, 50, 50, (data[2] / 255) * 255)
                            renderer.rectangle(x - 4 - text_size_x / 2, y - offset-4, text_size_x + 7, 18, 80, 80, 80, (data[2] / 255) * 255)
                            renderer.rectangle(x - 3 - text_size_x / 2, y - offset-3, text_size_x + 5, 16, 20, 20, 20, (data[2] / 255) * 200)
                            renderer.gradient(x - 3 - text_size_x / 2, y - offset-3, text_size_x/2+3, 1, 78,169,249, (data[2] / 255) * 255, 254,86,217, (data[2] / 255) * 255, true)
                            renderer.gradient(x - 3, y - offset-3, text_size_x/2+5, 1, 254,86,217, (data[2] / 255) * 255, 214,255,108, (data[2] / 255) * 255, true)
                        else
                        end
                        renderer.text(x - 1 - text_size_x / 2, y - offset, 255, 255, 255, data[2], "", 0, data[1])
                        if data[2] < 0.1 or not entity.get_local_player() then table.remove(logs, idx) end
                    end
                end

                renderer.log = function(text)
                    table.insert(logs, { text, 0, ((globals.curtime() / 2) * 2.0)})
                end

                local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}

                local function aim_hit(e)
                    if not lua_menu.misc.log:get() then return end
                    local group = hitgroup_names[e.hitgroup + 1] or '?'
                    if lua_menu.misc.log_type:get("Screen") then
                        renderer.log(string.format('Hit %s in the %s for %d damage', entity.get_player_name(e.target), group, e.damage))
                    end
                    if lua_menu.misc.log_type:get("Console") then
                        print(string.format('Hit %s in the %s for %d damage', entity.get_player_name(e.target), group, e.damage))
                    end
                end
                client.set_event_callback('aim_hit', aim_hit)

                local function aim_miss(e)
                    if not lua_menu.misc.log:get() then return end
                    local group = hitgroup_names[e.hitgroup + 1] or '?'
                    if lua_menu.misc.log_type:get("Screen") then
                        renderer.log(string.format('Missed %s in the %s due to %s', entity.get_player_name(e.target), group, e.reason))
                    end
                    if lua_menu.misc.log_type:get("Console") then
                        print(string.format('Missed %s in the %s due to %s', entity.get_player_name(e.target), group, e.reason))
                    end
                end
                client.set_event_callback('aim_miss', aim_miss)

                local rgba_to_hex = function(b, c, d, e)
                    return string.format('%02x%02x%02x%02x', b, c, d, e)
                end

                function lerp(a, b, t)
                    return a + (b - a) * t
                end

                function clamp(x, minval, maxval)
                    if x < minval then
                        return minval
                    elseif x > maxval then
                        return maxval
                    else
                        return x
                    end
                end

                local function text_fade_animation(x, y, speed, color1, color2, text, flag)
                    local final_text = ''
                    local curtime = globals.curtime()
                    for i = 0, #text do
                        local x = i * 10  
                        local wave = math.cos(8 * speed * curtime + x / 30)
                        local color = rgba_to_hex(
                            lerp(color1.r, color2.r, clamp(wave, 0, 1)),
                            lerp(color1.g, color2.g, clamp(wave, 0, 1)),
                            lerp(color1.b, color2.b, clamp(wave, 0, 1)),
                            color1.a
                        ) 
                        final_text = final_text .. '\a' .. color .. text:sub(i, i) 
                    end
                    
                    renderer.text(x, y, color1.r, color1.g, color1.b, color1.a, flag, nil, final_text)
                end

                local function doubletap_charged()
                    if not ui.get(ref.dt[1]) or not ui.get(ref.dt[2]) or ui.get(ref.fakeduck) then return false end
                    if not entity.is_alive(entity.get_local_player()) or entity.get_local_player() == nil then return end
                    local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
                    if weapon == nil then return false end
                    local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.01
                    local checkcheck = entity.get_prop(weapon, "m_flNextPrimaryAttack")
                    if checkcheck == nil then return end
                    local next_primary_attack = checkcheck + 0.01
                    if next_attack == nil or next_primary_attack == nil then return false end
                    return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
                end

                local scoped_space = 0
                local Tweaks_font = "c-b"
                local key_font = "c"

                local function screen_indicator()
                    local lp = entity.get_local_player()
                    if lp == nil then return end
                    local ind_size = renderer.measure_text("cb", "Invinsible")
                    local scpd = entity.get_prop(lp, "m_bIsScoped") == 1
                    scoped_space = math.lerp(scoped_space, scpd and 50 or 0, 20)
                    local condition = "share"
                    if id == 1 then condition = "share"
                    elseif id == 2 then condition = "stand"
                    elseif id == 3 then condition = "walk"
                    elseif id == 4 then condition = "run"
                    elseif id == 5 then condition = "air"
                    elseif id == 6 then condition = "air"
                    elseif id == 7 then condition = "duck"
                    elseif id == 8 then condition = "duck" end
                    local spaceind = 10

                    if lua_menu.misc.cross_ind_type:get() == "Default" then
                        Tweaks_font = "c-b"
                        key_font = "c"
                    elseif lua_menu.misc.cross_ind_type:get() == "Modern" then
                        Tweaks_font = "c-b"
                        key_font = "c-b"
                    elseif lua_menu.misc.cross_ind_type:get() == "Standart" then
                        Tweaks_font = "c"
                        key_font = "c"
                    else
                        Tweaks_font = "c-d"
                        key_font = "c-d"
                    end

                    local new_check = lua_menu.misc.cross_ind_type:get() == "Newest"

                    lua_menu.misc.cross_color:override(true)
                    lua_menu.misc.key_color:override(true)
                    local r1, g1, b1, a1 = lua_menu.misc.cross_ind:get_color()
                    local r2, g2, b2, a2 = lua_menu.misc.cross_color:get_color()
                    local r3, g3, b3, a3 = lua_menu.misc.key_color:get_color()
                    local r, g, b, a = 255, 255, 255, 255
                    text_fade_animation(center[1] + scoped_space, center[2] + 30, -1, {r=r1, g=g1, b=b1, a=255}, {r=r2, g=g2, b=b2, a=255}, new_check and string.upper("INVINSIBLE") or "INVINSIBLE", Tweaks_font)
                    renderer.text(center[1] + scoped_space, center[2] + 40, r2, g2, b2, 255, Tweaks_font, 0, condition)

                    if ui.get(ref.forcebaim)then
                        renderer.text(center[1] + scoped_space, center[2] + 40 + (spaceind), 255, 102, 117, 255, key_font, 0, new_check and "BODY" or "body")
                        spaceind = spaceind + 10
                    end

                    if ui.get(ref.os[2]) then
                        renderer.text(center[1] + scoped_space, center[2] + 40 + (spaceind), r3, g3, b3, 255, key_font, 0, new_check and "OSAA" or"osaa")
                        spaceind = spaceind + 10
                    end

                    if ui.get(ref.minimum_damage_override[2]) then
                        renderer.text(center[1] + scoped_space, center[2] + 40 + (spaceind), r3, g3, b3, 255, key_font, 0, new_check and "DMG" or"dmg")
                        spaceind = spaceind + 10
                    end

                    if ui.get(ref.dt[1]) and ui.get(ref.dt[2]) then
                        if doubletap_charged() then
                            renderer.text(center[1] + scoped_space, center[2] + 40 + (spaceind), r3, g3, b3, a, key_font, 0, new_check and "DT" or "dt")
                        else
                            renderer.text(center[1] + scoped_space, center[2] + 40 + (spaceind), 255, 0, 0, 255, key_font, 0, new_check and "DT" or "dt")
                        end
                        spaceind = spaceind + 10
                    end

                    if ui.get(ref.freestand[1]) and ui.get(ref.freestand[2]) then
                        renderer.text(center[1] + scoped_space, center[2] + 40 + (spaceind), r3, g3, b3, a, key_font, 0, new_check and "FS" or "fs")
                        spaceind = spaceind + 10
                    end
                end

                local defensive_alpha = 0
                local defensive_amount = 0
                local velocity_alpha = 0
                local velocity_amount = 0

                --lua_menu.misc.velocity_style
                --lua_menu.misc.defensive_style

                local function velocity_ind()
                    local lp = entity.get_local_player()
                    if lp == nil then return end
                    local r, g, b, a = lua_menu.misc.velocity_window:get_color()
                    local vel_mod = entity.get_prop(lp, 'm_flVelocityModifier')
                    if not ui.is_menu_open() then
                        velocity_alpha = math.lerp(velocity_alpha, vel_mod < 1 and 255 or 0, 10)
                        velocity_amount = math.lerp(velocity_amount, vel_mod, 10)
                    else
                        velocity_alpha = math.lerp(velocity_alpha, 255, 10)
                        velocity_amount = globals.tickcount() % 50/100 * 2
                    end

                    renderer.text(center[1], screen[2] / 3 - 10, 255, 255, 255, velocity_alpha, "c", 0, "- velocity -")
                    if lua_menu.misc.velocity_style:get() == "Default" then
                        renderer.rectangle(center[1]-50, screen[2] / 3, 100, 5, 0,0,0, velocity_alpha)
                        renderer.rectangle(center[1]-49, screen[2] / 3+1, (100*velocity_amount)-1, 3, r, g, b, velocity_alpha)
                    else
                        renderer.gradient(screen[1]/2 - (50 *velocity_amount), screen[2] / 3, 1 + 50*velocity_amount, 2, r, g, b, velocity_alpha/3, r, g, b, velocity_alpha, true)
                        renderer.gradient(screen[1]/2, screen[2] / 3, 50*velocity_amount, 2, r, g, b, velocity_alpha, r, g, b, velocity_alpha/3, true)
                    end
                end

                local function defensive_ind()
                    local lp = entity.get_local_player()
                    if lp == nil then return end
                    local charged = doubletap_charged()
                    local active = is_defensive_active(lp)
                    local r, g, b, a = lua_menu.misc.defensive_window:get_color()
                    if not ui.is_menu_open() then
                        if ui.get(ref.dt[1]) and ui.get(ref.dt[2]) and not ui.get(ref.fakeduck) then
                            if charged and active then
                                defensive_alpha = math.lerp(defensive_alpha, 255, 10)
                                defensive_amount = math.lerp(defensive_amount, 1, 10)
                            elseif charged and not active then
                                defensive_alpha = math.lerp(defensive_alpha, 0, 10)
                                defensive_amount = math.lerp(defensive_amount, 0.5, 10)
                            else
                                defensive_alpha = math.lerp(defensive_alpha, 255, 10)
                                defensive_amount = math.lerp(defensive_amount, 0, 10)
                            end
                        else
                            defensive_alpha = math.lerp(defensive_alpha, 0, 10)
                            defensive_amount = math.lerp(defensive_amount, 0, 10)
                        end
                    else
                        defensive_alpha = math.lerp(defensive_alpha, 255, 10)
                        defensive_amount = globals.tickcount() % 50/100 * 2
                    end

                    renderer.text(center[1], screen[2] / 4 - 10, 255, 255, 255, defensive_alpha, "c", 0, "- defensive -")
                    if lua_menu.misc.defensive_style:get() == "Default" then
                        renderer.rectangle(center[1]-50, screen[2] / 4, 100, 5, 0,0,0, defensive_alpha)
                        renderer.rectangle(center[1]-49, screen[2] / 4+1, (100*defensive_amount)-1, 3, r, g, b, defensive_alpha)
                    else
                        renderer.gradient(screen[1]/2 - (50 *defensive_amount), screen[2] / 4, 1 + 50*defensive_amount, 2, r, g, b, defensive_alpha/3, r, g, b, defensive_alpha, true)
                        renderer.gradient(screen[1]/2, screen[2] / 4, 50*defensive_amount, 2, r, g, b, defensive_alpha, r, g, b, defensive_alpha/3, true)
                    end
                end

                local function info_panel()
                    local lp = entity.get_local_player()
                    if lp == nil then return end
                    local condition = "share"
                    if id == 1 then condition = "share"
                    elseif id == 2 then condition = "stand"
                    elseif id == 3 then condition = "walk"
                    elseif id == 4 then condition = "run"
                    elseif id == 5 then condition = "air"
                    elseif id == 6 then condition = "air"
                    elseif id == 7 then condition = "duck"
                    elseif id == 8 then condition = "duck" end
                    local threat = client.current_threat()
                    local name = "nil"
                    local threat_desync = 0
                    local showed_name = "Admin"
                    if threat then
                        name = entity.get_player_name(threat)
                        threat_desync = math.floor(entity.get_prop(threat, 'm_flPoseParameter', 11) * 120 - 60)
                    end
                    showed_name = showed_name:sub(1, 12)
                    name = name:sub(1, 12)

                    local desync_amount = math.floor(entity.get_prop(lp, 'm_flPoseParameter', 11) * 120 - 60)
                    text_fade_animation(20, center[2], -1, {r=200, g=200, b=200, a=255}, {r=150, g=150, b=150, a=255}, "\vI N V I N S I B L E", "d")
                    if lua_menu.misc.resolver:get() then
                        renderer.text(20, center[2] + 50, 255, 255, 255, 255, "d", 0, "resolver: "..string.lower(lua_menu.misc.resolver_type:get()))
                    end 
                end

                local ws_clantag = {
                    "in",
                    "inv",
                    "invi",
                    "invis",
                    "invisi",
                    "invisis",
                    "invisisi",
                    "invisisib",
                    "invisisibl",
                    "invisible",
                    "invisible",
                    "invisisibl",
                    "invisib",
                    "invisi",
                    "invis",
                    "invi",
                    "inv",
                    "in",
                }

                local iter = 1
                local wstime = 0
                local function rotate_string()
                    local ret_str = ws_clantag[iter]
                    if iter < 13 then
                        iter = iter + 1
                    else
                        iter = 1
                    end
                    return ret_str
                end

                local function clantag_en()
                    ui.set(ref.clantag, false)
                    if wstime + 0.3 < globals.curtime() then
                        client.set_clan_tag(rotate_string())
                        wstime = globals.curtime()
                    elseif wstime > globals.curtime() then
                        wstime = globals.curtime()
                    end
                end

                local function fastladder(e)
                    local local_player = entity.get_local_player()
                    local pitch, yaw = client.camera_angles()
                    if entity.get_prop(local_player, "m_MoveType") == 9 then
                        e.yaw = math.floor(e.yaw+0.5)
                        e.roll = 0
                            if e.forwardmove == 0 then
                                if e.sidemove ~= 0 then
                                    e.pitch = 89
                                    e.yaw = e.yaw + 180
                                    if e.sidemove < 0 then
                                        e.in_moveleft = 0
                                        e.in_moveright = 1
                                    end
                                    if e.sidemove > 0 then
                                        e.in_moveleft = 1
                                        e.in_moveright = 0
                                    end
                                end
                            end
                            if e.forwardmove > 0 then
                                if pitch < 45 then
                                    e.pitch = 89
                                    e.in_moveright = 1
                                    e.in_moveleft = 0
                                    e.in_forward = 0
                                    e.in_back = 1
                                    if e.sidemove == 0 then
                                        e.yaw = e.yaw + 90
                                    end
                                    if e.sidemove < 0 then
                                        e.yaw = e.yaw + 150
                                    end
                                    if e.sidemove > 0 then
                                        e.yaw = e.yaw + 30
                                    end
                                end 
                            end
                            if e.forwardmove < 0 then
                                e.pitch = 89
                                e.in_moveleft = 1
                                e.in_moveright = 0
                                e.in_forward = 1
                                e.in_back = 0
                                if e.sidemove == 0 then
                                    e.yaw = e.yaw + 90
                                end
                                if e.sidemove > 0 then
                                    e.yaw = e.yaw + 150
                                end
                                if e.sidemove < 0 then
                                    e.yaw = e.yaw + 30
                                end
                            end
                    end
                end

                local function thirdperson(value)
                    if value ~= nil then
                        cvar.cam_idealdist:set_int(value)
                    end
                end

                local function aspectratio(value)
                    if value then
                        cvar.r_aspectratio:set_float(value)
                    end
                end 

                local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')

                math.clamp = function (x, a, b)
                    if a > x then return a
                    elseif b < x then return b
                    else return x end
                end

                local expres = {}

                expres.get_prev_simtime = function(ent)
                    local ent_ptr = native_GetClientEntity(ent)    
                    if ent_ptr ~= nil then 
                        return ffi.cast('float*', ffi.cast('uintptr_t', ent_ptr) + 0x26C)[0] 
                    end
                end

                expres.restore = function()
                    for i = 1, 64 do
                        plist.set(i, "Force body yaw", false)
                    end
                end

                expres.body_yaw, expres.eye_angles = {}, {}

                expres.get_max_desync = function (animstate)
                    local speedfactor = math.clamp(animstate.feet_speed_forwards_or_sideways, 0, 1)
                    local avg_speedfactor = (animstate.stop_to_full_running_fraction * -0.3 - 0.2) * speedfactor + 1

                    local duck_amount = animstate.duck_amount
                    if duck_amount > 0 then
                        avg_speedfactor = avg_speedfactor + (duck_amount * speedfactor * (0.5 - avg_speedfactor))
                    end

                    return math.clamp(avg_speedfactor, .5, 1)
                end

                expres.handle = function(current_threat)
                    if current_threat == nil or not entity.is_alive(current_threat) or entity.is_dormant(current_threat) then 
                        expres.restore()
                        return 
                    end

                    if expres.body_yaw[current_threat] == nil then 
                        expres.body_yaw[current_threat], expres.eye_angles[current_threat] = {}, {}
                    end

                    local simtime = toticks(entity.get_prop(current_threat, 'm_flSimulationTime'))
                    local prev_simtime = toticks(expres.get_prev_simtime(current_threat))
                    expres.body_yaw[current_threat][simtime] = entity.get_prop(current_threat, 'm_flPoseParameter', 11) * 120 - 60
                    expres.eye_angles[current_threat][simtime] = select(2, entity.get_prop(current_threat, "m_angEyeAngles"))

                    if expres.body_yaw[current_threat][prev_simtime] ~= nil then
                        local ent = c_entity.new(current_threat)
                        local animstate = ent:get_anim_state()
                        local max_desync = expres.get_max_desync(animstate)
                        local Pitch = entity.get_prop(current_threat, "m_angEyeAngles[0]")
                        local pitch_e = Pitch > -30 and Pitch < 49
                        local curr_side = globals.tickcount() % 4 > 1 and 1 or - 1

                        if lua_menu.misc.resolver_type:get() == "Safe" then
                            local should_correct = (simtime - prev_simtime >= 1) and math.abs(max_desync) < 45 and expres.body_yaw[current_threat][prev_simtime] ~= 0
                            if should_correct then
                                local value = math.random(0, expres.body_yaw[current_threat][prev_simtime] * math.random(-1, 1)) * .25
                                plist.set(current_threat, 'Force body yaw', true)  
                                plist.set(current_threat, 'Force body yaw value', value) 
                            else
                                plist.set(current_threat, 'Force body yaw', false)  
                            end
                        elseif lua_menu.misc.resolver_type:get() == "Experimental" then
                            if pitch_e then
                                value_body = 0
                            else
                                value_body = curr_side * (max_desync * math.random(0, 58))
                            end
                            plist.set(current_threat, 'Force body yaw', true)  
                            plist.set(current_threat, 'Force body yaw value', value_body) 
                        else
                            if not is_defensive_resolver(current_threat) then return end
                            if pitch_e then
                                value_body = 0
                            else
                                value_body = math.random(0, expres.body_yaw[current_threat][prev_simtime] * math.random(-1, 1)) * .25
                            end
                            plist.set(current_threat, 'Force body yaw', true)  
                            plist.set(current_threat, 'Force body yaw value', value_body) 
                        end

                    end
                    plist.set(current_threat, 'Correction active', true)
                end

                local function resolver_update()
                    local lp = entity.get_local_player()
                    if not lp then return end
                    local entities = entity.get_players(true)
                    if not entities then return end

                    for i = 1, #entities do
                        local target = entities[i]
                        if not target then return end
                        if not entity.is_alive(target) then return end
                        expres.handle(target)
                    end
                end

                local phrases = {
                    "♛ ｇａｍｅｓｅｎｓｅ ♛",
                    "1.",
                    "𝙨𝙡𝙚𝙚𝙥",
                    "𝙞𝙦𝙡𝙚𝙨𝙨? 𝙄 𝙪𝙨𝙚 𝙄𝙣𝙫𝙞𝙣𝙨𝙞𝙗𝙡𝙚 𝙡𝙪𝙖",
                    "𝘽𝙚𝙨𝙩 𝙧𝙚𝙨𝙤𝙡𝙫𝙚𝙧 𝙗𝙮 𝙞𝙣𝙫𝙞𝙣𝙨𝙞𝙗𝙡𝙚 𝙡𝙪𝙖",
                    "「✦𝙄𝙣𝙫𝙞𝙣𝙨𝙞𝙗𝙡𝙚✦」",
                    "𝙂𝙚𝙩 𝙜𝙤𝙤𝙙. 𝙂𝙚𝙩 𝙄𝙣𝙫𝙞𝙣𝙨𝙞𝙗𝙡𝙚.",
                }

                local userid_to_entindex, get_local_player, is_enemy, console_cmd = client.userid_to_entindex, entity.get_local_player, entity.is_enemy, client.exec

                local function on_player_death(e)
                    if not lua_menu.misc.luaadvertise:get("TrashTalk") then return end
                    if not lua_menu.Tweaks.enable:get() then return end

                    local victim_userid, attacker_userid = e.userid, e.attacker
                    if victim_userid == nil or attacker_userid == nil then
                        return
                    end


                    local victim_entindex = userid_to_entindex(victim_userid)
                    local attacker_entindex = userid_to_entindex(attacker_userid)

                    if attacker_entindex == get_local_player() and is_enemy(victim_entindex) then
                        client.delay_call(2, function() console_cmd("say ", phrases[math.random(1, #phrases)]) end)
                    end
                end
                client.set_event_callback("player_death", on_player_death)

                local config_items = {menu, antiaim_system}

                local package, data, encrypted, decrypted = pui.setup(config_items), "", "", ""
                config = {}

                config.export = function()
                    data = package:save()
                    encrypted = base64.encode(json.stringify(data))
                    clipboard.set(encrypted)
                    print("Exported")
                end

                config.import = function(input)
                    decrypted = json.parse(base64.decode(input ~= nil and input or clipboard.get()))
                    package:load(decrypted)
                    print("Imported")
                end

                buttom_import = config_group:button("Import Config", function() 
                    config.import()
                end)

                buttom_export = config_group:button("Export Config", function() 
                    config.export()
                end)

                buttom_default = config_group:button("Default Config", function() 
                    config.import("W251bGwsW3siZW5hYmxlIjpmYWxzZSwieWF3X3R5cGUiOiJEZWZhdWx0IiwibW9kX3R5cGUiOiJPZmYiLCJkZWZfeWF3X3ZhbHVlIjowLCJkZWZlbnNpdmVfcGl0Y2giOiJPZmYiLCJib2R5X3NsaWRlciI6MCwieWF3X3JhbmRvbSI6MCwicGVla19kZWYiOmZhbHNlLCJkZWZlbnNpdmUiOmZhbHNlLCJmb3JjZV9kZWYiOmZhbHNlLCJ5YXdfZGVsYXkiOjQsImRlZl9ib2R5X3lhd190eXBlIjoiT2ZmIiwicGl0Y2hfdmFsdWUiOjAsImRlZl9tb2RfdHlwZSI6Ik9mZiIsInlhd192YWx1ZSI6MCwiZGVmX2JvZHlfc2xpZGVyIjowLCJkZWZfbW9kX2RtIjowLCJib2R5X3lhd190eXBlIjoiT2ZmIiwieWF3X3JpZ2h0IjowLCJtb2RfZG0iOjAsInlhd19sZWZ0IjowLCJkZWZlbnNpdmVfdHlwZSI6IkRlZmF1bHQiLCJkZWZlbnNpdmVfeWF3IjoiT2ZmIn0seyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiRGVmYXVsdCIsIm1vZF90eXBlIjoiQ2VudGVyIiwiZGVmX3lhd192YWx1ZSI6MCwiZGVmZW5zaXZlX3BpdGNoIjoiQ3VzdG9tIiwiYm9keV9zbGlkZXIiOjAsInlhd19yYW5kb20iOjAsInBlZWtfZGVmIjpmYWxzZSwiZGVmZW5zaXZlIjp0cnVlLCJmb3JjZV9kZWYiOnRydWUsInlhd19kZWxheSI6NCwiZGVmX2JvZHlfeWF3X3R5cGUiOiJPZmYiLCJwaXRjaF92YWx1ZSI6LTg5LCJkZWZfbW9kX3R5cGUiOiJPZmYiLCJ5YXdfdmFsdWUiOjAsImRlZl9ib2R5X3NsaWRlciI6MCwiZGVmX21vZF9kbSI6MCwiYm9keV95YXdfdHlwZSI6Ik9mZiIsInlhd19yaWdodCI6NDUsIm1vZF9kbSI6NTAsInlhd19sZWZ0IjotNDUsImRlZmVuc2l2ZV90eXBlIjoiRGVmYXVsdCIsImRlZmVuc2l2ZV95YXciOiJNZXRhfldheXMifSx7ImVuYWJsZSI6ZmFsc2UsInlhd190eXBlIjoiRGVmYXVsdCIsIm1vZF90eXBlIjoiT2ZmIiwiZGVmX3lhd192YWx1ZSI6MCwiZGVmZW5zaXZlX3BpdGNoIjoiT2ZmIiwiYm9keV9zbGlkZXIiOjAsInlhd19yYW5kb20iOjAsInBlZWtfZGVmIjpmYWxzZSwiZGVmZW5zaXZlIjpmYWxzZSwiZm9yY2VfZGVmIjpmYWxzZSwieWF3X2RlbGF5Ijo0LCJkZWZfYm9keV95YXdfdHlwZSI6Ik9mZiIsInBpdGNoX3ZhbHVlIjowLCJkZWZfbW9kX3R5cGUiOiJPZmYiLCJ5YXdfdmFsdWUiOjAsImRlZl9ib2R5X3NsaWRlciI6MCwiZGVmX21vZF9kbSI6MCwiYm9keV95YXdfdHlwZSI6Ik9mZiIsInlhd19yaWdodCI6MCwibW9kX2RtIjowLCJ5YXdfbGVmdCI6MCwiZGVmZW5zaXZlX3R5cGUiOiJEZWZhdWx0IiwiZGVmZW5zaXZlX3lhdyI6Ik9mZiJ9LHsiZW5hYmxlIjp0cnVlLCJ5YXdfdHlwZSI6IkRlbGF5IiwibW9kX3R5cGUiOiJPZmYiLCJkZWZfeWF3X3ZhbHVlIjowLCJkZWZlbnNpdmVfcGl0Y2giOiJDdXN0b20iLCJib2R5X3NsaWRlciI6MCwieWF3X3JhbmRvbSI6MCwicGVla19kZWYiOmZhbHNlLCJkZWZlbnNpdmUiOnRydWUsImZvcmNlX2RlZiI6dHJ1ZSwieWF3X2RlbGF5IjozLCJkZWZfYm9keV95YXdfdHlwZSI6Ik9mZiIsInBpdGNoX3ZhbHVlIjotODksImRlZl9tb2RfdHlwZSI6Ik9mZiIsInlhd192YWx1ZSI6MCwiZGVmX2JvZHlfc2xpZGVyIjowLCJkZWZfbW9kX2RtIjowLCJib2R5X3lhd190eXBlIjoiT2ZmIiwieWF3X3JpZ2h0IjozMiwibW9kX2RtIjowLCJ5YXdfbGVmdCI6LTE5LCJkZWZlbnNpdmVfdHlwZSI6IkRlZmF1bHQiLCJkZWZlbnNpdmVfeWF3IjoiT2ZmIn0seyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiRGVmYXVsdCIsIm1vZF90eXBlIjoiQ2VudGVyIiwiZGVmX3lhd192YWx1ZSI6MCwiZGVmZW5zaXZlX3BpdGNoIjoiQ3VzdG9tIiwiYm9keV9zbGlkZXIiOjE4MCwieWF3X3JhbmRvbSI6MCwicGVla19kZWYiOmZhbHNlLCJkZWZlbnNpdmUiOnRydWUsImZvcmNlX2RlZiI6dHJ1ZSwieWF3X2RlbGF5Ijo0LCJkZWZfYm9keV95YXdfdHlwZSI6Ik9wcG9zaXRlIiwicGl0Y2hfdmFsdWUiOi01NiwiZGVmX21vZF90eXBlIjoiT2Zmc2V0IiwieWF3X3ZhbHVlIjowLCJkZWZfYm9keV9zbGlkZXIiOi0yOCwiZGVmX21vZF9kbSI6MTgwLCJib2R5X3lhd190eXBlIjoiU3RhdGljIiwieWF3X3JpZ2h0IjowLCJtb2RfZG0iOjYzLCJ5YXdfbGVmdCI6MCwiZGVmZW5zaXZlX3R5cGUiOiJCdWlsZGVyIiwiZGVmZW5zaXZlX3lhdyI6Ik9mZiJ9LHsiZW5hYmxlIjp0cnVlLCJ5YXdfdHlwZSI6IkRlbGF5IiwibW9kX3R5cGUiOiJPZmYiLCJkZWZfeWF3X3ZhbHVlIjowLCJkZWZlbnNpdmVfcGl0Y2giOiJSYW5kb20iLCJib2R5X3NsaWRlciI6MCwieWF3X3JhbmRvbSI6MCwicGVla19kZWYiOmZhbHNlLCJkZWZlbnNpdmUiOnRydWUsImZvcmNlX2RlZiI6dHJ1ZSwieWF3X2RlbGF5IjozLCJkZWZfYm9keV95YXdfdHlwZSI6IkppdHRlciIsInBpdGNoX3ZhbHVlIjotODAsImRlZl9tb2RfdHlwZSI6IkNlbnRlciIsInlhd192YWx1ZSI6MCwiZGVmX2JvZHlfc2xpZGVyIjoxNDIsImRlZl9tb2RfZG0iOjUwLCJib2R5X3lhd190eXBlIjoiT2ZmIiwieWF3X3JpZ2h0IjoxMCwibW9kX2RtIjowLCJ5YXdfbGVmdCI6LTQ4LCJkZWZlbnNpdmVfdHlwZSI6IkJ1aWxkZXIiLCJkZWZlbnNpdmVfeWF3IjoiTWV0YX5XYXlzIn0seyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiRGVmYXVsdCIsIm1vZF90eXBlIjoiQ2VudGVyIiwiZGVmX3lhd192YWx1ZSI6MjEsImRlZmVuc2l2ZV9waXRjaCI6IkN1c3RvbSIsImJvZHlfc2xpZGVyIjoxMjksInlhd19yYW5kb20iOjAsInBlZWtfZGVmIjpmYWxzZSwiZGVmZW5zaXZlIjp0cnVlLCJmb3JjZV9kZWYiOnRydWUsInlhd19kZWxheSI6NCwiZGVmX2JvZHlfeWF3X3R5cGUiOiJTdGF0aWMiLCJwaXRjaF92YWx1ZSI6LTg5LCJkZWZfbW9kX3R5cGUiOiJPZmZzZXQiLCJ5YXdfdmFsdWUiOjAsImRlZl9ib2R5X3NsaWRlciI6MTgwLCJkZWZfbW9kX2RtIjoxODAsImJvZHlfeWF3X3R5cGUiOiJKaXR0ZXIiLCJ5YXdfcmlnaHQiOjAsIm1vZF9kbSI6NjEsInlhd19sZWZ0IjowLCJkZWZlbnNpdmVfdHlwZSI6IkJ1aWxkZXIiLCJkZWZlbnNpdmVfeWF3IjoiT2ZmIn0seyJlbmFibGUiOnRydWUsInlhd190eXBlIjoiRGVmYXVsdCIsIm1vZF90eXBlIjoiQ2VudGVyIiwiZGVmX3lhd192YWx1ZSI6MTgwLCJkZWZlbnNpdmVfcGl0Y2giOiJDdXN0b20iLCJib2R5X3NsaWRlciI6MCwieWF3X3JhbmRvbSI6MCwicGVla19kZWYiOmZhbHNlLCJkZWZlbnNpdmUiOnRydWUsImZvcmNlX2RlZiI6dHJ1ZSwieWF3X2RlbGF5Ijo0LCJkZWZfYm9keV95YXdfdHlwZSI6IlN0YXRpYyIsInBpdGNoX3ZhbHVlIjotODksImRlZl9tb2RfdHlwZSI6Ik9mZnNldCIsInlhd192YWx1ZSI6MCwiZGVmX2JvZHlfc2xpZGVyIjoxODAsImRlZl9tb2RfZG0iOjE4MCwiYm9keV95YXdfdHlwZSI6Ik9mZiIsInlhd19yaWdodCI6MCwibW9kX2RtIjo1NCwieWF3X2xlZnQiOjAsImRlZmVuc2l2ZV90eXBlIjoiQnVpbGRlciIsImRlZmVuc2l2ZV95YXciOiJPZmYifV1d")
                end)

                local function update_menu()
                    local aA = {
                        {200,200,200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 80 / 30))},
                        {200,200,200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 75 / 30))},
                        {200,200,200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 70 / 30))},
                        {200,200,200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 65 / 30))},
                        {200,200,200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 60 / 30))},
                        {200,200,200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 55 / 30))},
                        {200,200,200, 255 * math.abs(1 * math.cos(2 * math.pi * globals.curtime()/4 + 50 / 30))},
                    }

                    label_text = string.format("  I N V I N S I B L E ", rgba_to_hex(unpack(aA[1])), rgba_to_hex(unpack(aA[2])), rgba_to_hex(unpack(aA[3])), rgba_to_hex(unpack(aA[4])), rgba_to_hex(unpack(aA[5])), rgba_to_hex(unpack(aA[6])), rgba_to_hex(unpack(aA[7])))
                    lua_menu.Tweaks.enable:set(label_text)
                end


                client.set_event_callback("setup_command", function(cmd)
                    if not lua_menu.Tweaks.enable:get() then return end
                    aa_setup(cmd)
                    if lua_menu.misc.fast_ladder:get() then
                        fastladder(cmd)
                    end
                end)

                client.set_event_callback('pre_render', function()
                    if not lua_menu.Tweaks.enable:get() then return end
                    if lua_menu.misc.animation:get() then
                        anim_breaker()
                    end
                end)

                client.set_event_callback('paint_ui', function()
                    hide_original_menu(false)
                    update_menu()
                end)

                client.set_event_callback('paint', function()
                    if not lua_menu.Tweaks.enable:get() then return end
                    if lua_menu.misc.luaadvertise:get("Clantag") then
                        clantag_en()
                    end
                    if not entity.is_alive(entity.get_local_player()) then return end
                    if lua_menu.misc.cross_ind:get() then
                        screen_indicator()
                    end
                    thirdperson(lua_menu.misc.third_person:get() and lua_menu.misc.third_person_value:get() or nil)
                    aspectratio(lua_menu.misc.aspectratio:get() and lua_menu.misc.aspectratio_value:get()/100 or nil)
                    if lua_menu.misc.velocity_window:get() then
                        velocity_ind()
                    end
                    if lua_menu.misc.defensive_window:get() then
                        defensive_ind()
                    end
                    ragebot_logs()
                    if lua_menu.misc.info_panel:get() then
                        info_panel()
                    end
                    text_fade_animation(x_ind/2, y_ind-20, -1, {r=200, g=200, b=200, a=255}, {r=150, g=150, b=150, a=255}, "Invinsible", "cdb")
                end)

                lua_menu.misc.resolver:set_callback(function(self)
                    if not self:get() then
                        expres.restore()
                    end
                end, true)

                client.set_event_callback('shutdown', function()
                    hide_original_menu(true)
                    thirdperson(150)
                    aspectratio(0)
                    expres.restore()
                end)

                client.set_event_callback('round_prestart', function()
                    logs = {}
                    if lua_menu.misc.log_type:get("Screen") then
                        renderer.log("Anti-Aim Data Resetted")
                    end
                end)



                return(function(U,f,q,Q,k,v,g,h,s,u,L,C,I,j,H,Y,t,O,x,w,V,c,M,o,X,Z,l,A,d,D,i,N,a,p,z,E,K,J,G,W,b,e,R,_,T,m,F)m=({});local S=(15);repeat if S>15.0 then break;else if S<34.0 then if not m[27158]then S=((F[2]>F[3]and F[0X6]or F[0X4])+F[4]+F[0X6]-F[4]-3411376667);m[0X6a16]=(S);else S=m[27158];end;end;end;until false;local n,B,P,y=(select);S=0X3F;repeat if S>20.0 then if not(S<=63.0)then P=(nil);y=(1.0);if not not m[0X11b7]then S=m[0X11B7];else S=F[4]-F[0X6]-m[0X6A16]+m[27158]-m[0x1a7D]+0X7A433a93;(m)[0X11b7]=S;end;else B=unpack;if not m[6781]then S=((F[9]-F[0X8]-F[6]>S and m[27158]or F[0X4])<=m[0X06A16]and F[6]or F[0x2])-0X4f45f7e;(m)[0X1a7d]=(S);else S=(m[6781]);end;end;elseif S==18.0 then if not not m[6584]then S=(m[0x19b8]);else S=(((m[0X6A16]==F[0X6]and m[0X1A7D]or F[4])-F[1]-F[0X9]>=S and F[0X7]or F[0x6])-4147068524);(m)[0X19B8]=(S);end;else break;end;until false;local r,U6,f6,q6,Q6;S=0X69;repeat if S~=105.0 then if S==52.0 then U6={};if not m[0X1f01]then S=(F[8]-S<F[0X9]and F[5]or F[7])+F[0X3]+F[0X3]-10338919358;(m)[0x1F01]=S;else S=(m[0X1f01]);end;elseif S==3.0 then if not not m[0X6C6C]then S=(m[0X6C6C]);else S=((F[9]==m[7937]and S or F[0X3])-m[6781]+m[0X1f01]+m[0X43Aa]-3095925413);m[0X06c6C]=(S);end;elseif S==6.0 then f6=function(U,f,q)local Q=(10);repeat if Q<97.0 then U=U or 1.0;Q=(97);else if not(Q>10.0)then else f=(f or#q);break;end;end;until false;if not(f-U+g>7997.0)then return B(q,U,f);else return r(q,f,U);end;end;if not not m[0X7cdB]then S=m[31963];else m[0xc7E]=((m[27756]~=S and F[9]or m[6781])>S and m[0X19B8]or F[6])+F[0x1]-F[0X6]+2731266850;(m)[18885]=(F[3]-m[0X19b8]-m[7937]+F[4]~=F[4]and F[0x3]or F[0x4])-3095925269;S=(((F[3]<F[0x4]and F[8]or F[7])>m[0x11B7]and F[0X4]or m[17322])+F[0X1]+F[8]-2475150195);m[31963]=(S);end;elseif S==45.0 then q6=5816720/0.0;if not not m[0X3060]then S=(m[0X3060]);else m[10303]=((F[0X8]-F[6]>m[0XC7e]and S or S)+m[0X1F01]<=m[0x7cDb]and F[0X7]or F[1])-34431;S=(((m[27158]<=S and m[0X6C6C]or m[0X1a7D])>m[17322]and m[17322]or F[3])-F[3]>F[8]and m[0X7cDB]or F[9])-0x64C4cf6;m[12384]=(S);end;elseif S==40.0 then Q6=(function(U)return{f6(1.0,U,{})};end);if not not m[0X1892]then S=m[6290];else(m)[24265]=((m[31963]-m[0x6a16]>=F[5]and m[6584]or F[8])+F[0x6]-F[8]-2731301447);S=((F[0X4]+F[0X9]==m[10303]and F[2]or F[0X7])~=m[27158]and m[0Xc7e]or m[17322])+F[8]-0X006aFe2467;(m)[6290]=S;end;else if S~=103.0 then else break;end;end;else r=function(U,f,q)if q>f then return;end;local Q,k=0X12;while true do if Q<73.0 then Q=(73);k=f-q+1.0;else if Q>18.0 then if k>=R then return U[q],U[q+g],U[q+2.0],U[q+3.0],U[q+4.0],U[q+5.0],U[q+6.0],U[q+7.0],r(U,f,q+8.0);elseif k>=7.0 then return U[q],U[q+1.0],U[q+2.0],U[q+3.0],U[q+4.0],U[q+5.0],U[q+6.0],r(U,f,q+7.0);elseif k>=e then return U[q],U[q+1.0],U[q+2.0],U[q+3.0],U[q+4.0],U[q+5.0],r(U,f,q+6.0);elseif k>=5.0 then return U[q],U[q+1.0],U[q+2.0],U[q+3.0],U[q+4.0],r(U,f,q+5.0);else if k>=4.0 then return U[q],U[q+1.0],U[q+2.0],U[q+3.0],r(U,f,q+E);else if k>=v then return U[q],U[q+1.0],U[q+2.0],r(U,f,q+3.0);else if k>=2.0 then return U[q],U[q+1.0],r(U,f,q+Z);else return U[q],r(U,f,q+1.0);end;end;end;end;break;end;end;end;end;if not m[17322]then S=((m[6584]<m[6584]and F[0x4]or F[5])-m[0x1a7d]+F[0X007]<F[6]and F[7]or m[27158])+18;(m)[0x43aA]=S;else S=m[0X43aA];end;end;until false;local B,r,k6;S=0X0;repeat if S<50.0 then B=(2.147483648E9);if not m[22932]then S=((m[27158]+S-m[27756]==m[0x7cdB]and m[0X19b8]or m[10303])<m[31963]and F[0x5]or F[8])-1795040355;m[0X5994]=(S);else S=(m[0X5994]);end;elseif S<105.0 and S>50.0 then if not m[0X77E3]then S=m[17322]+m[7937]-m[6781]+F[0x4]+m[7937]-0x28891FDe;(m)[0X77e3]=(S);else S=m[0X77E3];end;elseif S>95.0 then k6=z.O;break;else if not(S<95.0 and S>0.0)then else r=(4.294967296E9);if not m[0x7Be6]then m[0X620d]=((F[8]-m[0X283F]-F[0x5]-m[0x5EC9]>=m[6781]and F[0x6]or F[9])-2731301451);S=((m[18885]==m[24265]and m[0x0049c5]or m[0X6c6C])-m[0X1892]+F[2]-F[6]+2648177551);m[0x7bE6]=(S);else S=(m[0X7be6]);end;end;end;until false;local v6,g6,h6;S=16;repeat if S>47.0 then if S~=66.0 then h6=({});break;else g6={[0x5]=2,[6]=0X2,[_]=0X1,[0X9]=_,[8]=0x1,[0X1]=1,[0X03]=5,[0X9]=6,[0X2]=0X0,[0X3]=2,[0X7]=3};if not not m[0x1791]then S=(m[0x1791]);else S=(F[2]+F[7]+F[0X6]-m[31963]+m[0x5994]-6961494163);m[0X1791]=(S);end;end;elseif S>=47.0 then if not not m[0XA7a]then S=m[0XA7a];else S=((F[0X3]>m[7937]and F[0X5]or F[4])-m[0xc7e]-m[0X6a16]<m[6290]and F[5]or m[22932])-29;m[2682]=S;end;else v6={[0.0]=1.0,2.0,4.0,8.0,16.0,32.0,64.0,128.0,256.0,512.0,1024.0,2048.0,4096.0,8192.0,16384.0,32768.0,65536.0,131072.0,262144.0,524288.0,1048576.0,2097152.0,4194304.0,U,I,3.3554432E7,6.7108864E7,1.34217728E8,2.68435456E8,5.36870912E8,1.073741824E9,B,r,[35.0]=A,[42.0]=4.398046511104E12,[49.0]=o};if not m[0X1c08]then(m)[0XFc7]=(m[0X6c6c]+F[0X04]-F[0X1]+m[0x49c5]+m[7937]-680040731);S=F[0X5]+m[30691]-m[24265]-F[8]+m[0X1a7d]+447255535;m[0X1c08]=(S);else S=(m[7176]);end;end;until false;A=nil;U=(nil);local o;S=0XF;while true do if S<=15.0 then A=(X or z.s);U={};if not m[27580]then S=(((m[0X5994]+m[0x6A16]-m[27158]<F[0x4]and m[6584]or F[0X5])<m[22932]and m[0X283F]or F[0x9])-0x55);(m)[0x6bbC]=S;else S=m[27580];end;else if S==34.0 then if not not m[21483]then S=(m[21483]);else S=(((F[7]>=m[4535]and m[25101]or m[0XC7e])<=m[0x1C08]and F[0X3]or m[3198])~=m[31718]and F[0X1]or F[0X4])+m[0X77e3]-0X870f;(m)[0X53eB]=(S);end;else o=0.0/0.0;break;end;end;end;for U=0.0,255.0 do h6[U]=c(U);end;local s6,u6;S=65;while true do if S~=44.0 then s6=(function(U)U=a(U,'\122','\33!\33\33!');return a(U,"\46..\46.",J({},{__index=function(U,f)local q,Q,k,v,g=H(f,1.0,5.0);local h=(g-33.0+(v-33.0)*85.0+(k-33.0)*7225.0+(Q-33.0)*614125.0+(q-33.0)*5.2200625E7);g=h%256.0;h=(h/256.0);h=(h-h%1.0);k=h%256.0;h=h/256.0;h=h-h%1.0;v=(h%256.0);h=(h/256.0);h=h-h%1.0;q=h%256.0;h=h/256.0;h=h-h%1.0;h=(h6[q]..h6[v]..h6[k]..h6[g]);(U)[f]=h;return h;end}));end)(N("LPH+s4dVTK)blO!!!#WJ[>Pe?Y+5a$=@.XATqj+A7^\"moG%]U+<VdL+<VdY/R)Ed$6UH6+<VdL+<VdL+<VdL+<VdL+<VdL+<W:%,q(Dr/1rP-/hSb/+<VdL+<W9h/hAP'0.8%k-9sgK$6UH6+<VdL+<VdL+<VdL+<VdL+<W'^+<VdX0.8%k,pjs(5X7R],q(/p0/\"t,-n$;b,pOWZ-n$_u.P*,'+<VdL+=o0!-mgPR+<VdL+<VdL+<VdL+<VdL+<Vd[.Ng>i5X7S\"5X7S\",qL/]/gr&35X6YC-71&d5X7S\"5X6Y@-n6c#/hSb//hSb+,sX^\\-nZVb/0cbS+<VdL+<VdL+<VdL+<VdL+=]#e/g`hK5X7S\"5Umm!-m^De+<W-^-71uC5X7R],q(5o/g)8Z+<VdL+<VdL+<W9f.OZMf-n7JI-7U,\\.P(oL+<VdL+<VdL+<VdL+<VdO/0HT25X7S\"5Umm+-7Buf-71Au/2&4o-71uC5UIm+5X7S\"5X7S\"5X7S\",:Y5s/hSb//2&>85X7S\"5X7R_+>+rI+<VdL+<VdL+<VdL+<VdO+<Vmo5X7S\".PF%5+>+lb/h\\V(/hAY*/2&Y+/1rJ,-n7JI5X7S\"5X7S\"5X6V\\5X7S\"5X7S\",;(3+5X7S\"5UJ*+,mkb;+<VdL+<VdL+<VdL0-DAa5X7S\"5X7S\"-m_,'+=\\]b.OIDG5X6PI-9sg]5VFE0/hA;65X7S\"5X6VK5X6YE/0H&d/1`D+/g)8d,sX^\\,9SHC+<VdL+<VdL+<VdL,9S*]-9sg]5X7S\"5X7S\"/1;nm5X7S\"5U.m(+<VdX-9sg@5X6YG+>,!+5X7S\"-7gbo5X7S\"0.&qL,q)#D5UIm4/1;hr+>58Q+<VdL+<VdL+=Jlc+<W't-71&c-9sg]-8-nm/3kF.5X7S\"/0H&X+<VdL+<s-:0.\\G8-6Os,5X7S\"/0uMe5X7S\"5U[`t+<VdV5X7S\"5UJ$.,q^;m$6UH6+<VdL+>4i[,;1Sm5X7R],:G2u,=\"LZ0-DQ+5X6Y]5X6_M+<VdL/1*VI-nZu&.Nfi[5X6eA+<Vsq5X7S\"5U@Nq+<VdL+=KK?-7C>r/hSFs/d`^D+<VdL+<Vd[0/#RU-7g8^-mh2E,:jr[+>5u5+=nuh5X7S\",:5Z@,pO]a-m_,*.NgB05X7S\"5UJ*+,=\"LZ,:5Z@5UId'5X7S\"5X6YI0.8;80-^fH+<VdL+<VdQ,q^N0,9STc5X7RZ+>5uF5X6VB5X7R]0.n@i+=o/o-nd&$+<W9i-9sg]5X7S\"5X7Rc.OHPr0-rkK,:Y$*5X6_B-n[,)/hA=o.R5Wo+<VdL+<VdL5UA$0-6Oof5X7R].NfiV+>5',5X7S\"5X7S\"5X7S\"5X7R]5X6PI-m_,D5X7S\"5X7S\"-7g8^-pU$_5X7S\"5X7S\"5VFZR5X7S\",;(;m$6UH6+<VdL+=8Ed,paZd-7U,\\+<W=&5X6_M+<W3`5X7S\"5UJ-40/\"t3,:FZf-9sg]5X7S\"5X7S\"5X7S\"-m0W`-9sg]5X7S\"5UJ$)-pU$E.PF%80+&gE+<VdL+<W9_.O.2,+>5uF5X6_?.R66a5X7Rf+<VdL+=\\[&5X7S\"5X6YK/3kO)/0c\\g/g`hK5X7S\",9ST`.O?Dp/0dDF5X6eA+<W.!5UJ-6-7T?F+<VdL+<VdL/g`5(,=\"LZ5X7S\"/0H&X.OIDG,q^_q5X6YE/0H&X+=noe5U@aB5X7S\"5X7S\"-nZu#+<W=&5X7S\"5X7S\"-7g8^+<VdL,sX^\\5V=Yr+<VdL+<VdL5Umm/,sX^\\5X7S\"5U[`t+<VdL+>+cZ+=KK?5X7S\"5X6_?+<VdL+<W9d-m^3*5X7S\"5X7S\"5X7R]-nHJ`/h\\h,5U@Nq+>5uF,p4fn$6UH6+<VdL+<Vdl.Ng>j5X7S\"5X6YK+<VdL+<VdL+<VdL+>,;o5X7Ra/g`hK5X7S\"5UJ$)/1N,#/g)8Z+>,2p-mg>p,sX^?+=09&+<W4#5U@O(,75P9+<VdL+<VdL+<W!^+>5uF5X7S\".NfiV+<VdL+<VdL+<VdL+<VdL+>+m(5X7S\"5X7Ra/gWbJ5X7R_/3lHc5X7R]+=nfe/g)8Z+<VdZ-9rk\"/0bKE+<VdL+<VdL+<VdL+>4ie5X7S\"5U.Bo+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+=09\"/hA4S+<VdL+<VdL+<VdL+<W'\\+>,!+5X7Ra+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<Vmo-8$ho$6UH6+<VdL+<VdL+<VdL/g`1n/1*VI5V+$#+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdT5UJ*7,75P9+<VdL+<VdL+<VdL+<VdL,;()k,sX^F+>5uF0-DA[+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL00gj:/1:iJ+<VdL+<VdL+<VdL+<VdL+<VdZ0-DA^5UA$*,sWe./0c\\g+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+>5uF/1rR_+<VdL+<VdL+<VdL+<VdL+<VdL+<W-^+<Vmo,q^;m+=KK?5X7R\\0.\\4g+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<W=&5V+N;$6UH6+<VdL+<VdL+<VdL+<VdL+<VdL+>5Aj+=09\"/0HE-5X7S\"5X7R_+=KK$0.n@i+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdO5X6kC-jh(>+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL,:Xfg-9sg@/g)Q-5X7R]/h0+O5X7S\"5X6VJ+=]#s+<VdL+<VdL+<VdL+<VdL+<W-d/gVu\"-9sgI+>4'E+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<Vdl.Ng>i5X7R\\/0HJs+>,oE5X7S\"5X7S\"/1r565X7S\",p4fe5X7Ra+<s,u/hSJ9.P*%l,sX^B/g)VN+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<Vd[+<W-\\5X7S\",qL/]+=\\cd5X7S\"-8$Dc5X7S\"5Umm$5X7R\\+=KK?.Ng8p+<Vd[5X7S\".Ng,H+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+@%/(+>+m(5X7S\"5UIm1/g)8Z+<VdL+<VdL+<VdL+<VdL+<VdZ/1N%o-9sg]5X6YK/gq&L+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL-7CJh+<W9i,sX^\\5X7S\"5X7S\"5X7S\"5X7S\"5X7S\"5X7S\"5X7S\"5X7R_/g)Pj$6UH6+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdL+<VdX,;1N!+<VdL+<VdZ/hAP)/1`>'/1rP-/g)8Z+<VdL+<VdX0-^f2+<VdL+<VdL?!T$6$47mu+<VdL+<\\#q@rH6p@<@,%z!,@%k#<F7ZA1K)i#*o5hz!42u<?YOCgAU%niK)blO!!!\"lJ@#MuF_tT!EWuXHz!!'BF+ED%8F`M@BF(KH*ASuZ>Ap&!$FD5Z2-n[,).3NYBFEMVA+=2(W/hSb*+D#G$/0K\"FFDYT2@<>peCh5#A+Bp$9F!=m44Wl@0/g,Qn+F>5<?YOCgAU#=\\+D58-An>k'-n$]#/h&4lI46TfK)blO!!!\",J@#T(Df^#@Bl7Rj#'4m,Bl7Rj\"CGMPFL2-jAT38%z,Em\\c\"D2@cA@)MI?X[JUZisfDE,Ts-$X[7XATV@&@:F%aZj(5^F(KB6Zij`CCh9sWFCAWpA[DI\\K)blO!!!\"LJ-H8Zz!!!4f?FV'X!!!\"O!!!\"^bA54PZjL/IFDl5BEbTE(ZisfDD/Ws;z!!%IuZiMlcErZ1?zK)bm:E@48lK*KR#z!!'A.F*1s!\"^bVXF^h]`?XI;]DI[*sZj1&YDerunDM%ohzi.A<>D..NrBX@tN?XmM\\CkD]f!!!#g++]%E!!!#77b3-t!C='uAp&!$FD5Z2K)blO!!!!QJ@#Q(<D.LDE,)`aB5M(!@q`4M,D,sr!!'f+hLU:Zz!!!\"Oz!5RKBK)blO!.[nHJ[>PhH$!VMz!!$D]K)blO!5KPtJV*q&!!#97bCKl8OB#*W!!!\"Oz!!!\"LK)blO!!!#WJ$aQ*Dfp(C9QabdASu[*Ec5i4ASuT4A8c%#+Du+>+EM[EE,Tc=+Dbt)A0>f2+Dbt)A92j5Bl7Q7+EV:.Eb/j$Eb-A=Dfm12Eb-A9DII!jAKZ)5+E_a:+A?ou@;om-F!)i(:e4qg:L@*u<^BDZ78kQVD.-ppD_;5.Y\\R;?!!!#+#'Fg&@:O)*z!!#97\"pP&-z!.t7OzBRk^8z!-3UBz!!(r-K)blO>'p_2K7a.(z+FjY&z!!!!'#64`(zK)blO!!!\"^J:dh%J/jMbdt<8Q!!$C^!8rG5!<<*\"zK)blO!!)dYJ[>J25D&q9!')-8ab'd$z!!!#)#/L9>z!42o:?Ysq%ZiFe?\"p+c)z!42o:?Y!ko#)B%\\M#[MU!.t7Ozi.JB>B6/3)\"p4i*z!42rBDfT]'FL20\\BOPqlkQ1_a!!!K/!=r$r*4l4uJH8kX[fJV)!D=\\;D9Y]R!*o4!!!$9t!WXcS!!!\"(2Co\\d(b>Z;!>m@=.24H9J,pW@0FTKd!.Y(m0J#(4'ECfX!!$7r///^J,V2M<!!$7:/-(2$&-)]8:&k9!iW:e69F*HT9IKl@>RDGr.O6i!8L+99>\\5)a1aE&$>^cYQ>c%NE!.Y(M*$?^R!!$8a!A\"5$!B:&Z>_W8%/2SaT!*jCe!.Y(Q!!$8-'EEXa///@taoMJB>g`ZR!*l6#!-3;u!!$9,\"/uP*#64`'s8W-!&#'CF!.Y(u'G+[/!<<+)Q2q[\"J,p&m&7DdE!!$9H!WWo\\#QOj0g&_6S#oipF>hT2mV?'s&'EEXa0E;)XjoH;!9FLn$>g`Wi!.Y(a!!$9(!Z1o2#TNhp!<<*\">_3#\"!.Y(M!#.X/!!$9l!?_YH!!!\"(U&l#/9H5#PJ,ocQ!*kNc,_H.a!!!\"(`W@+[J,pK,*%;RE!.Y(i*$>Y0+96om+<VX])uotDQ3%%+52lVX!.Y(]!!$9t!>GN-#QOj0g&_N[9G@I,>i#KJ*\";lJ!*l6!\":Qag&-.4]#QOj0Jcc8YJ,oWQ#V$)[!*kB`'ECf4!!$8e!t50[!<`B&>j;@j&/bHJ!*krp&?>hN^&\\36>da_;!-/&F!)+40!*n@]\"9<HB!!$X3'F5ZY#QRO4!!$9\\!<<*\"!!<3%!=7^X!!$76!!$76!!$76!!El6!!$X3c3WkEs8W-!s8W*0fa7]Z!!!*$!!)[a!!$7R!!$7R&dSpH!!$7B!!G+m!!$72!!$7BnH=RJs8W-!s8W*0oEtX-('\"=7>ZO])E<#t=>YY8)4ph8i.Kf_OH3=N2!C6\\o!)ik/K*\"==!!$7Z\"9<iM!!$7J!!\"CZ9*EE=5l^lb>W)Q^!!!?+!!3W=Th>@c>]'NA>].+]UB^bus8W-!rt!ug*#r_N!<<+)dK(1)Dr1Qq!*g!6!*oL('S?HQ!!!\"(.Lb285l^lb>TO_%Dr1Qq!.5d7!<?\";!!$7>'ZU8orW*!!>_W:s!.Y(Q)urY<!!$8)+EKgK!!$98!<<fu&-)]88g'#m5l^lb>[@O5J,oWM!([4u!.Y(M!!#Oq%\"eUI!\"]-\\!<`B&>`&Or!)*Y8K*\"==*1I!q!!!Qp&.fCkpAtm/$kO*QJ,oci!)*Y<(I8$$!*j+MhZ7[_!!$9H!<<s>!.t=i3#DW4,o?U^>d=AAhZ7[?!!$7Z!!%Bd(`[IH!ZW1phZ3]W>WNuM$k+*q.3JTjHlW.e*&noT*%;j=+DU?G!!$9`!P8@PGn^5Y>j_XM!>$Lr*'.L.!!$9T!<<*\"!!N?&$<]i&?!h#MAKk!,9)nrs@K[)r#QOj0EXVqu!<`B&>QtT:J,pnq!*kZf$ikeY\"9],i#QOj0=pP+Y!>#52>TO.V;ZHdt>S[_JJ,pVm$oA4q!.Y(m!!$7Z#QTAU!\"8jX!<`N61^F']>\\XNEJ,p>a!*k*V!!%<J!!$7r#QTAU#QOj0%L<&b!=TA:J,ocU$oA4i!*gu^!.Y(Q\":R*m#QTAU(]XP@3X?-&#RDPZ\":,!$\"98FL#QOj0@]]a'\"TSN%s8W-!&&\\qX!!!!'!!33F,OJ)'!*g-:!*g-:!*g/u!NcV,s8W-!s8NW$!WW4H$ig94.KBHr$k*\\(#Rh+k\"98F,)@un!!<<*\">VZ^!1^!dY>WNDrJ,ocQ!*gQF!!!!2!!*NaM#f;I/k.<f+=8L0:A@H^!*lf4!!$90\"=*tt!>GM6>S8:^I/j6I>fHo0!WZ+0!!$9T\"NCQE;@EO*>RDkZJ,p?4!.=hI!*hD^!*lf2_?'^8(]XP@V?5o][fla2s8W-!rsumT49/%p!!$9T!B:(0!AHV99I)k'9Ir.'&-+ZiJ,q>(!*kro5QFIt2ujKi2unI00E;)X7R-rI,WGc8!!!\"(:,i4b!&st/!AFKR>g<?i/9ThN0E?V(/-#ZTmK#9I&-+ZiJ,q>(!*mME2unI00K]>/#XAA`$oe4u!!!\"(\\cFbjJ,q>d!)*e$!*j+u!),'H!*n@]49/&3!!$8I5QFJ#!!$:'!C-WY-o_2<!&ssP1]RN'3&!#p+>a(K!A$&a$jZh5>c%N]!\"],i!.Y)(49/%t5QFIh!!$8U!>$Z%hZ3]W>`JhI!)+q/!),'H!*krn)utKi'H@+$!!!\"(_?(VU;BPr>>eU:c!.Y(q!!$9l!ZV2j!>lpZ9EZ%TFb9_q!*kZh,S3<C!!$9t!\\>l2'EA,<L'%Dq57eq;J,pbm!*m):-icpD!!$:'![7VB#QOj0\\cXJ`J,pVi!*n4Z0E?V(*#LA)0E;)XSc^A@J,pW,-r)/j!*nLb,S3QJ!$GkR,QN>q-n#'h\"=sP'!<`Q[E<#t=>g`ZR!*n(W-iebu'EA,<ao_VD>T,!jI/j6I>fHjG!*g]n!.Y(a,QN5m!!$9P\"$-E['EA,<_?:P]8dk\\\">iGho!)*M,!.Y(Q!!$8]\":P9\\!=05:9EY=q>e1%<#[%--!*oL*!\"<!1!!#Ou&-.4]$kr\\l!>$(J9EY=q>cIoH!.Y(Q!!$9h!semW!<<*\">k.t2!.Y(Q!!$8e\"98F,iWLM,J,q2H,Rb*e!WZ+<!!$7R-iebu'IWs0!!!\"(OocU'J,p?(!.=hI!*hPb!!!!*!!!*&#RZPa!!$8q!<<+)ScM[?$NL/+s8W-!&(CUo(^q)Y!*jsY!.Y(Q%\"eUI!!!\"(EYJM(!=0MB9Fq1(>V7!H5l^m!=TAF%>\\YCF!^Qed(g-h=!*g!N!.Y(U)urY8!!$7b'Gq5m!!$7n!#Si=!!$8i!>H@Z'EA,<XoT4NDm'0A!*k*V&?>ju!!Ej*'EA,<+ohUj'Gph#!=0YF9FN%b5l^m%=TAF%>c%N=(iQ/N!!$8%\"9<rQ!!!\"(()Rm,!rr=+@Mf)q!=0YF9F)b&5l^lb>Zq+->b1rr!!!!+!!!En6jPD+6UaL:%SKNR9)nrsV?%M6J,pbm!*gEF!,DQK!.Y(]!!$7.)utKi(a&g/!?<(!Fs$bb>XAu%J,q&4!.Y(e(]]'e/-#ZT3YW9O(]XP@Ae5MG!!!\"5\"9\\^T!=/r2J,pnq!.#%R!*guR$pP:7!.Y(U!!$7:K)ua4'Ef+;!!E:P!<`B&>Rg`:&HDe2>_W7r(j6l!!*i\\1!.Y(U#QTAU$k*,d!=05:J,p2q!.Y(a(]]'e(`WO+!?;(>>^ceUJ,ocQ!*j]=%C?6;s8W-!s8NVe\"onX.V?$Ys!!!3(!<EJf8cSir%KHK6%KHK6%L`=U!\"]-\\!<<*\">T+\"N64Eet[Kcd3s8W-!rsr$.!!!\"4!<<,m9)nrsh>mTV>i#Lh#gihUs8W-!s8NUu#s`8l!(<^d5laI9!^Qed!*ndi>f-V/!+<8;5lbGj!C6\\c!*n(UChH$6E8(F[!!!\"(^&lX^6U:_%!@L/5!!$8m!ji\"b5leCr;aCDr!l\"b%!5JY;5leh)lN'9O!!$9\\!e^WI!^Qed!*npoquVcW5lcE;!!L(A!!$90\"8i2K!C6^9!W[,n\"TSO-?B>3N!^QgN!J^\\A!13e>!^Qed!*nXf</1N@!*F_:!!!\"(*hWN=5ld\\]QN9AP!!$8U!u1b:5l_aK5l_mo!C6].T)h4X,e!e?!%8pT!%c.k5l^lb>j_Y%i!4H+!!$8e\"M=b>5l^lb>`&Sr2aIED!*h-2\"E=DA!.\"nN!*l)t9E8an!<<+)`WXoqcN6B4g]H425lfgEk5djKj8uLd5lg*MoEGs/!!$9X\"2Fs;!C6_(!>@a!a8t0\"5l^lb>eU<m!LEjR!8IV$!C6_H!oO)_!!(@H$KM6O!J^bC!:0aH!C6_T!@'l1oDoIg!!!\"(c3/7`!C6^1RfYkUI\"MGc!.Y)W5lcQ=Mubg:!!$8Y\"L%oj!C6\\c!*lB'a9(6\"5l^lb>`JoV!P8D!!!!\"(RK5+k!^QfC^B-\\$3:d2;!'EJ3!!!\"(%]BE7!^Qgf!W)pa!!!\"(ecO%smfGcTciVf#5lfC9MZQ0E!!$9p!FQ<;!!!\"(ecYu[!H!>g\\,iK.5l^lb>g<A'\"7lOZ!/L^b5l^lb>bV@g!rs@c!<<+)3g9_B5ld8SK*+C>S-&aH!!!.6!!E:;!:0c^!^QhU!qua^!!&Mo+nPj2!cL@)!!$89!/L\\Ehu\\i=b5ss0O94_L5ld,Nf)\\/;4I?0m!!!\"(XosO]qZ/t_MucF7!!!\"(ILp!T!!!\"(V?*n&<(6if!*i!P!fR4W!0@:95l^lb>fHl9!ZOE*TE:/U5ld\\^90iQV!j_nn!3?6G5l^lb>abdlWrbQe!!$8a!VcZq\"&Jst>]L7j!Bg\\g!*mME!!$9\\!<<*\"!'pSbA&n\\@!PSSl!@3s3DR'9iJcU<o+>0Yp.Y%ObE,rGhTE/\"%aoRq3I$+MTA<6gobQ59U?93`?U&hn-:eDS5!Q5\"^_?!CC4?c5j!GEOO!M0<G@\\a#q>XUDP,0g59!R_\"-!A\"LSC)kq.(9dgo!LNmSPQ;]P!N6%M!=IH[$kcT!ZiP8\\`W7i2'I_I-!!$9H\"onX.ap,W^!.=hI!*lf1^]=F/Mu`nY>RCH2>a>Wq!*nY$YQ;*3:9Xc+!<@WN\\,rT1ZiNb*!<<+)DQEj=J,uSMX9#C';ZHdt>^!%IZiNb*!<<+)I^9*S!]RIe!!$8!ZiRB3@^#m;!O<>H!!!\"(Q3!ocZiNb*!<<+),,bRI!D0KrZiL/W!O)V*!*h^l!OMl&YQ4_(>Xkpu!.Y*O!WW4*@^#m?!D]j\"ZiL/W!OMp,!jhu\"ZiRB3ZiLT>!OMk-J-!.]!!$8-!!$9<$uii[._#Ml!N$65!!!\"(h@GhO!)/=PPQ:c4!!!\"(dK-QQrW?R/!!$9X\"P<b7\"C2#[!<>ea!!$9D!Sd\\U9[j(C!\"%Qa!!$98!>1OsE<&:l!HA)>!*npm?(_4<!2KVq-a8O2U]I>*@/p9->kS1YS,mU0!!$9\\!<<+)q?j/&ZiNb*!O)U3!D]j\"ZiL/W!Pec8!jhu\"ZiRB3ZiLT>!<<+)ecN&VZiNq+!OMk-J,tl9!!$:#!<B2%50=/4!<@WNTE,#m>lFf'!jD\\sYQ;*3!.Y*W!iQ1-!D0X!!!$8e!iQ1-!D0X!YQ;*3:9Xa!!*k6\\YQ;*3%'Ta4!*o4!YQ;*3:9Xa!!*npnZiL/W!Pea:!*nXf\"9<HB!!$8u!iQ1-!D0X!!!$9L!jht.J,u;E!!$98!jhu\\!^Qed!*l)sYQ4`S!NZ>&!*lN*ZiL/W!R(TF!*mMFh@'B^YQ4_(>ab`p!*n@hYQ4`S!Pec8!jD\\sYQ4_(>a>Jf!MBH%I!bofU]CGq>d=d:!Vc[FoDnpl>e1%,!S@E0p]:-j!.Y+&!Up-b!AsELp]1@g'`7t39^i&_!*o4\"oDnrB!JgaV!*npop]1@+!!!\"([MA94!.Y*C!UKjV!@mR>!!$9P\"7-'\\!@m^B!!$90\"+UFQ9ZR57!*n4[\\,l:7@/p9->T3;F!)g$%!!$9$#cn%,9T0\"R!<@NJ!!$8m\"98F,rXQRA$q^r@!K%7n!!!\"(^')@T!)0m'!!$8q\"M=a89G\"u?!).2/!*lN,!!$9h\"?\"[0E<+>d!)1lC!!$9L\"98F,apc&d!.=hI!*oL*^]=F/Mu`nY>g``Tl4S?o!<<+)ncZ`/M@3hm!!$8q%g2lQ!!!\"(OpfV;J,rRKe,b1'5l^o/!C$Jq!Q5\"Y!!!\"Fa8l8@>abg!!-/&>!*k6^bQ.]o!O)T-ciJ+da8sWg1s?!E!J:G>!!!\"(q?/bXJ,qJ\\3&EHK!.Y)42unI05VP/S1]RM\\`W\\1!J,r%<!*meQ!;m$J3'71k!D#HUJ,r=D!*n@c(f2\\Y;uhFL>SpEi;uco'nco^+J,p&Y!*mAG!!%=i!!$9\\#&F9i!H\\;AH>iia>_WKF!<>ea!!$9P\"u&\"n1c,2_!B:&Z>cn5]!.Y(u!!%=!!!$8a#8g,a9E5&tmKNpsJ,oc]!.Y(U!!$9l\"^h=\\!GE<X.UW5V>dak?!.Y(M!!$90#*],g9Pa\\/8<a,T!*k*]I,=rj!;PRVJ,q/#KE2('!IOkI>il8f!.Y)P!!$9\\\"W1Jo>Q=b/^'6OsJ,qJ,!*kZkF9$glGQ7_KSd.(PJ,q2X0GpD`1]W%,0E;)XrWX3].WbXj>kS=$!.%%(!.Y)H9E9SD;uco'WWlu6J,sI'A1D*i!*kBe'EEXa&/YCt!>HLRJ,pK0!.Y(i,QN>q+=I5?!@.XF>b2-:5Uo#!!*lB+$&AV%!$R:%E<#t=>`&_f!.Y)X(g&7i>QB9TA,lU7p'(Ks$((aT!O<,>!,)@_!H8#=>lFm,!*o4/^]=F/Mu`nY>b25:!<@NJ!!$8e#d==0J,u_QVuj1(8[&3q!*lf8!!$9t%0-B5M@I3!!.Y*k!WW4*_?ddT!.=hI!*lr<[MGqF%0-A.>fIGU!O;`7!!!\"(^'V:M#YGL*!*mqXVuZll'EA,<Z3d`9#YGN8!<>e)!!$9($)dk)&-)\\1>lG!tU]GH8!!$8u$)dk)I/p2H!)*s*!<@WNKEA(Q#YGN0!<>e)ZiL/W!JgdW!*ndpVuZllU]CGq>_WQt!<@WNMuitZ>hTIb!<>fh!O)S)J-\":'!!$9t#QOj0'%RH/!=]#/!*kZjX8r;p1]RM\\iX)gi!.Y*C!OMk-J,u;D!42bQZiL.,>lG&6!<>fX!<<+)NXD9W!.Y*?!MBGn9Lo-`>kSI(!.(FA!!$8i$E*t:8cYXf!)NXq!\"#S)TE1c%>lXl+!>tk;!*mqYVuZll9E5&tapHDq!)+fj!<>eqfDtu&!W3!!!*m5FbQ5Q`@/p9->iH+7!<>e)!!$8q$JYX^J,t0&huNh.!It7Pe,_cFe,e&\"F(bOR>hTMf!-/&>!*lr>bQ/,E$ig94XpP./>TTsI!)00h!!$9l$37\"*)$$`=!.Y+\"!<<+)Jd\\LX!),?P!*nXnX9#7#@&=P:!*lZCZ3760%0-A.>b2?(^&`K&!<<+)dL's3!@kkcE5Vc6\\,cR0>`&oX!NZ;2!!!\"(NYU=M!)10/!!$9`$bucC9[j(C!*mAIGh<$Re,ccSe,_#6!Rq.[!=[HYfDtu&!UKm?!Rq--e,]OL>db$U!OMk?e,e2&!),WX!*lZ7!8%;i!!!\"(^'geLX8rb1!!$9D(8(]6$t0,9!*k6e\"9<HB0VAFrS,iTi>k/7&!*lB'YQ4_t,d[T)!^QedX8tM^$`j@/9V_[h!*lB0\"9<HB!!$8i%'0I0I/p>LhZ6\"C!!$8]$ioQ!G`Vq+!*kZs!!$90'!MB:J,u_QVuj1(8[&3q!*m)DciF+]jIHGS!*n(`!!%Dr!Rq,M9WS6p!*mq\\ZiL/W!Or12!*nXpVuj=,8[JN&!OMk9YQ;*3!.Y+\"!WW4*p'e/+ZiNq+!<<+)Jdh^]!C#cVZiPd\\5l^lb>lG/C#cn%9!!!\"(h?'VWYQ7>\"!<<+)RLK5s>l#,<!<@WN\\,lX1>`oPH!Sd]*fDtsP>cnOo!<@WN+92CH^('-(!.Y*7!<<+)`XUi,^]?=N!<<+)[LM9uhuR5O'*&#;aqk&Z!BuAMZiL/W!Q5&D!OMk9YQ4_(>j`'*!OMk9YQ4_(>ga(c!OMl&YQ4_(>lG2>!J:G>!!!\"(c40dTVueob!<<+)jpeKqVueob!<<+)h@5\\M!.Y),PQ?._dK'=J>bV]2!-/&>!*ks&O9#?3!NZ;%!*k6g!!$9$!O)S)J-!.]!!$9,%]BH5!D0Kr!!$8Y\"L%p6!=Z15!!$9\\%^5s6J,tl9Vuj1(8[&6&!<@WN^]FK9>h0DN!iQ/ZZiL.,>ilNp!jhu\"ZiL.,>db-L!<@WNX9&A%>k/B/!OMk3YQ:s/L'1ob!!$8Y&#]Q:!D0X!YQ;*3:9Xa!!*meZX8r<O!MBGn!*m5J!!$9$%KOEJ)$%SUCN,.=!!$9$&'+bO9Y^Z/!*kBl_uTj32uiq`Q4Erq>cJO;!jD\\sYQ4_(>`Joj!<@WNS,rZj>cJ=W%+kS/e,]OL>hT_@!<>g?!<CUM)$&:i!.Y*'!rr=+\\e!9k!),?P!*mAO!!$9@\"M=cN!@e3P!*kZu_uTj34NIO'9Y^Z/!*kBm_uUE:!!!\"(V@1<C&46Et!*nXs]E-@[.L6\"S>k/EL!<@WNU]LMr>_3O*!<>e)a8l97KE99t!)0m'ciF,?^]=E8>l\"uD!<@WNfE/\\d!.=hI!*nds\"9<HBYQ<Y_.DPuB!Or.=huVm>!.Y+:!WW4*`Xq23huP^n!<<+)dLZBY>lGAO!<>gO!<<+)c4J>'!)/m`e,]PCa8soo!)1T;!!$8m&^UOY9Ul.5!<>g3!<<+)q@OU\\!HA+X!<>g/!QY9A9WS6p!*ne$ciF+X!!!\"(g(:=d!.Y*7!iuF$!>mTm!*k6kciF+X!71`H9Ul.5!<>g;!S@DQ9Z-r3!*lZ=ciF+X!!!\"FVuZku>`KDt!<@WNTE5)n>f%)S!UBeMVu`t#!.Y*7!O)S)9I-tGK*\"==!!$8U&cfuR)$%k]!)10/ciF,?]E&#V!>tk;!*ne#!5nmU!6>0@9Y^\\Q!<>g#!<<+)ee-O8!)1H7!!$8Y&HJm55)K`L!<@WNQiaJm!.Y*?!iQ.(!ApkY!!$98&R+l0s8W-!s8W*0Rgl8%q#gZss8W-!rt!<XK*%,Cs8W-!s8W*0ed)6U>iH$f!<>fP!N6#!I/j6I>bVl-'*(q7!<<+)SdkB.!)g$%!!$9$(T[Y=!@b5RYQ4`S!N6%'!NZ;ZX8r;$>iHBd!N6#3X9#O+!.Y*G!<<+)_@chK>bVt'!<>fp!<<+)h@e`I!.Y+&!<<+)ne0FQhuP[i!<<+)iWQ1`^'ao?s8W-!rsu[OV@C`M%0-A.>h0Vi!*m)JYQ4`S!NZ@$!jD\\sYQ4_(>_WpM!<@WNL]IJU>b2Va!T3u.huVm>!),o`!*lZ?j8l\\(>la'h!)2;O!!$94'*&\"=li@(d>cJIA!P/nP!!!\"(mLo^'EWE0A!.Y*C!<<+)dM&hc!.Y*?!iQ1)!D0Kr!!$9\\'=7c?J,u_QVuj=,8[JN*!O)T@YQ4_(>eUjO!*kBpYQ;*3:9Xa!!*k*iZiL/W!PAI6!*o(.rXQ.5.'*FL!*kNebQ/8B!!!\"(RM<sH!)*q(!*l*0!!$8]$d\\nS9S<Gr!<>g'!S@DQ9ZR57!*kBq_u[XS1^%d9!AqRmE5Vc6\\,cR0>hTn5!<>f\\!<<*ja8l8@>fmb\"_uV^9!<<+)Oqbt<&46Et!*m5Pa8l97/Be+p9Y^\\U!<@WNU]LP;!EfC&!*o43!!%>`!<<+)Xq\\eTa8n+'a8l974Nmg+9Y^\\U!<@WNU]T$H!)/=P!!$9P'EeDV!3?2$J,uSM!!$8m's%Fr\"CV91!*h8ZdLpet!<<+)q?q8\\!@kkcRL9*n_uTi<>j`:+iWFGd!<<+)Z4P4\\!.Y+&!R(QE(&6ekbQ.];8C.A;9LJj\\>i$4>!Kmgr!!E:B!!!\"(^(gVJ$.JtU!*mqeciLud@/p9->ga.e!KI7j!!!\"(Z50eJ!.Y*O!WW4*NY\\i\"ZiNq+!OMk-J-!FeVuj=,8[JKu!*lB:Vuj=,8[JKu!*oL<YQ:s/0XLi\\!*nq,Vuj=,8[JKu!*kg*YQ;*3%'Tc>!<@WNZiU4->b2]2!*lf?]E&\"_!RLn\\!<@NJ!!$9@('\">>ap8+MEWE0A!.Y*#!<<*jX8r;$>lGMS!Or.=^]D@S!.Y+:!WW4*NYfb;!.Y+>!WW4*L)72t!.Y+.!k872J-\"^4]E&\"_!U'Th!Pe^b]E&!4>h0[p!<@WNg]@HU>j<*K!J:G>!!'q<5/IWE!Pe^n^]D@ShZ6\"C!!$9`(8q;=!D0Kr!!$8u(B=G?p(ae4!.Y*?!WW4*RMW1/!)*g.!<>fh!<B>))$%#E!.Y+&!<<+)_AD2;ZiMSZ!<<+)V@qef!)1<3j8f6Sg]7BT>h0\\khuS9,!!$94&-)\\1!-/'X!96ZO!*g-:!*g-:!*g/U\"f2>$s8W-!s8NV[#VEgoE<#t=I)#ga!!!!$!!!'k`<#-o!!$7>!!I`N!!$7F#QTAU\"98F,\"p=pV!<<*\">Rg`6B)ho3>Sb3ZT`b>ps8W-!rst1tz$3:/2;%RAS7eoXV!*giN!*gi^!.Y(]!!$7:&-.+Y!!$X3\"9<HB!!$72qup^4s8W-!s8NW/\"TSOK$ig942AcFE!=/Z*>Y5P-1&q^_:]M%,J,oWa!.Y(Q!!$7V)uq_o!#0#F(kVlU!!!Qo>%/$P!!!\"()@R`<*$>Al=s*fq!=Sr.HlrCh!!!W3!!Ec=&.Ir!!!$7N!!$7N!!#PP'Kdj-?3!kc!!$7J490m4#QOj0$31'2ecGu,!^Qed!*hPb!([A(K*\"==!!GKg!=/[U!<<*\">V;TK(_$HF!*kfl\"9<HB!!$7j!!#PP4R)rU!!!\"(Fqd%q3&gng!<<*\">\\X6=82r^3J,ooU!*iD%!*k6\\\"9<HB!!$8U!>pFj5l_l)J,oWM!(\\(PK*\"==!#Rmd/E6as!!!\"(V?&+&!C6\\c!*kfj0S9Em!!\"E2c2tQY\":Y>2!*lB&_ZPGms8W-!s8W*01.27;!'C6X!#.OP2uiq`joI^M8cSiNAcMr6@m!!VJ,ooU!(]@C!.Y(M!!$98!<<+)c2n\\B1cRGpJ,p'@!.Y(U!!#PP5QH<8!!!\"(aoMJB82pSL>`o.J!.Y(M!!$8U!WW4*)@QUr!<<*\">b2!*\"A/Xo!'15c!-/&B!.Y(Q#QTAU#QOiq#QOj0Q3%$dH5%4R!C6]*irMFG+G0_]!!!j\"q?!Mr-k-.V!*i,Y!.Y(Q!!$9l!^m$=!=2'r8cSiRAcMf2>[BYqJ,ooU!(]?T!*n@^L'/>&!!!\"(H2mqMl2a!IJ,ooU!*kNd!!#PP!!$8U!sAUE!!!\"(\\cOi0@/p9->d=Gk!.Y(U!!#PL!!$8q!rr=+M?51+J,ocQ!*lf4!!#P@0E?V(!&+OJ!!\"EZ!%\\,#!<b(VJ,oWM!(\\e#!.Y(M1^$DN!%_^^'J)'h!!$94\"#'jM!!\"EZ!%\\,#!<`B&>bV?P!.Y(M!!$9<\"\"4/\"!<`B&>lFg^\"A/Xo/7nkr/2SaT!*l)u!!$:#!\\aV)!<<*\"82)k#J,oWM!*kNe/-(2$!!!!i/2.'S!<<*\">j_[o!!!!'!!!'-9'f.M!*h,V!*h/$$-*5Ls8W-!s8NUm\"TSO-/ee;9!<a)>8cT8\"8cShk3WouoJ,ocQ!([Y$!*g->!.Y(M!!%<N$ikeY!!!\"(+ohTC!\"],1(1B[>DfKi@GBmJ@I=GC(@qB?]:4WF_X%WKn>j_Xn!*npnoFA80s8W-!s8W*0oEkQu>j_Y-!.Y(M(]]'e<!X<t'EA,<dKL<bJ,r=D!*ndm!#/Q9!!$9<\":uP&&-)]8_?12HJ,q>0\">gMe!*k6\\2ulV`49/%d1^ltV+95\"6!#T;J)utKi6i[3lh?=SnJ,rIH!*n(Y!!%<N!!$98!u(`c!DF=19FLn$>cn5A(c2p,!*meM1]U2\\!!$9L!sf#d$k*,d!=Sr.>l\"ID!)*qL!)*q(!*n(V-n'-J!!$94!>kf1$ig94L'B1/J,rIX/9<?B!*kZk#Qusm$ikeY'EA,<g&r+N!C6\\c!*g-j!)*qX\"A/Y:!(m4k(hNaf!.Y)<'EA[E!!$8E)utKi6i[3lg&hT`1^j?a>fm0\\!.Y)8!!$8u!t50[!B^>^>_3\"k!\"],1!*itQ!.Y)<!#/Q9&/6r4'EEXa9E5&tL'.Jf=TB-9J,r=D!*n@^$ikeY*!c[($ig94dKC*]J,r1@!*lZ/$ikeY#QOj0NWCO.9Fq1(>a>I/!)*e@!)*qH!)*q(!*l)u8Ha#5!!$8=!#Si=!!$9p!=/fb$ig94l2qFpJ,qJ4\">gMq!.Y)0!!$:'\"Y9XI&-)]$/-#ZTV?I5:1^k*-E<#t=>fHgF!.#=r!)*Xu!*lZ.$ikeY!!!\"(V?A\"A9Fq1@=TAF%>kS:#0GsjI!)*q(!*hu-!\"],1!*g]j,YfH^!*o4!$ikeY,R=N0$k*,d!@S3V1^jcmJ,q2,\">gMe!*hQ%!)*e$!*h8Z(g-h=!*kro!%\\uf!!$9T!@.Y=&-)]8_?CJNJ,ocY&2Xdq!*meN+:nqm&0r\\9!!$8i\"V;A)&/5+p!DEIn>il.t!.Y(]!!$9@!=SsY!?_@B>lFd1\">gMq!.Y(e!!$90\"rI>6$lf7@&1&H=!!!\"(rWF2g5l^lb>Uh!!9FrTP9Fr<T8cSi.AcNeNJ,r%<!*kZg,U<O)&1D]5-mUYq!!$9`\"#'^K&-)]8L&i7o9Fr<H9Fqa\\EtB`\"J,rIH!*lB%-icpP/-&?T0E=cX!!$8i\"98F7!\"]ts'EA,<IM;bn!#,E`!DEIn>cn)E!)*e@!)*q(!*krn)urYD!!$90\":,,e$ig94M?4at9Fr<H9Fq1(>`Jq0&4up&(hNaf!.Y)<'EA[E'EEXa9E5&tWWj:?9FLn$>kS=,\">gMe!*m):z\"9AK&j%9:O>S7#:>S>]rW<E8$s8W-!rsujT!!$7:#QQU[!!lR)z%KHP1PY1uV>S[;>>S\\\"V=T8C9hZ4O&!!$7V%\"eUI!!!\"(*Y@305l^lb>ZM!b!>g=g!!$72(^pfa&-,B@!!$7b!!$85(^O7D!<<+):)!h5rrE*\">X\"#G(ap'u!*mME\"Q'4r\\cE)o!>i<J!!$7n\";FTJ(`7#f!=U)hrrE*\">^?MQ9Gda0>UBjZ9HX<8>]LMY9Fq1(HkZ\\t:)j66>b1rr!*iP-!)+@4!*kZf*#r_n!=0N;,U=XMrrENZDuThH!)+pL!)+X<!*kfj#Qthg!!$9P!<<+)M?+\\*$kNsM9H4$4>f$LE!)*Xu!*glK%?:_os8W-!s8NUo%0-A.!\"/f-!.[]B!*i+r!*i,EJcT9[!!$7J!!#P<!!$72-icpd!!$7:!!$8Y!=6=A7K<]\"A4mI69F)>N5l^lb>WN^c!^Qed&6T!-'QF*Q!*j7AkQ=9S\"9`9$!<<+)-3+$N)BBf;!\"C&j!'MTI!!!\"(<`KuV!!!\"(=o\\P-)CPSZ,U`Y@!!!\"(EW?)P!!!\"(G/FZm!rr<#s8W-!%uL_p!!!!)!!<4S9)nrs4obRf4qn\\b&-)]8&emfD!!!\"(/qX3:GmOEN&3(48&.B*a\">pkn!*fj2!*hD^!*h]%K*\"==!!$7n$lWOS!!$81:&n0+!!$8)!!%B\\mg=sTs8W-!s8W*0/em1D5l^lb>Y]nQ&:\"Q]!>%4%\":t_J!!$8Y!>#r?'EA,<JcQPs2%UH5=G$YT!*jCA!.5K5!YfngK)um8#S\\+N'GM7(K*)&R'K?d,!*j[I!!!!*!!3@_!K@+Z5](!,8cSir=o\\P-=pu*:&/YCt!>#52>S[GZ1^k3$J,p?(!)+(,!*giN(k)Gb!*h8Z!.5Ud(b,dk!*h,^$qU^-&1S)\":14,&!*j.!#.5!As8W-!s8NTU!!$X3#jVP2:&k9!3Xc\"=!<>.h-jTeQ>\\X6=>RD#BJ,od6&1@ea!*iD%!!!!+!<NB0:1\\/:8cSir4sU,Y!=/Z*>TP!f9Fq1(>QtlB9F(Uu>V6!r=TAF%>Xf\\5J,ocQ!*g!N!&=Nc!(mY:!.Y(Q!!$7N&-.4]!!!\"((*$(X!!!\"(Fs$d8!=TeF4:E20J,ocq!)+(P!)*Lq!*j+9**E7A!*jCA!*i9^%*AeSs8W-!s8NU6!!$8)$7IMk7aiF*J*KsJR<StQIs_r7XIsFZIhWmHk'JQ!Iju*)o5P,cImCGDM.5DVIi@0/P?X^)IiJU`q65C!*$Tb\\#UG:tIV[\\;V@0ah$6:b[0ETBV6mX)T9L/4G[ViM8!@A\"JOoPI]s8W+O!<<*\"!.ZkVZifM47C372eUbu9B!_b?D%jKGTn<@G!!!\"l$@rD:d/X.Gs8W,+!n:S0z!2#7%K)krP!!!#!J:dk&!!!!ab^b<Hz!1eWERK*<es8W-!#-F<ns8W-!s+:=P!!!!Anpl>nzJ>[q)#4.]>#9Ug8!<<*\"!'nt_K)krP!!#8'JV*t'!!!\"\\*J(R#Usn&2K)krP!!!#sJ-P09s8W-!s8R]Pz!-3UB!<<*\"!.Z)@K)krP!!&\\fJ:dk&!!!#7pOIksz!+pb6!<<*\"!+>SPK)krP!!%Q5J-Oj0s8W-!s8R]Pz!-E_qR.pX\\s8W-!K)krP!!%PWJ-IWWs8W-!s8R]Pz3%]]6!<<*\"!73NQK)krP!!%Q,J:dk&!!!#7)1dD@z-mF4p!<<*\"!,r9rK)krP!!\"/0J:dk&z\"bD:+z`d`Pl!<<*\"!14s]K)krP!!$+OJV*t'!!!\"T+b>7Hz!&/qU!<<*\"!9!6pK)krP!!!#TJ:dk&zLOb!Xz0F!)\\z!+p8&K)krP!!(@MJHgMqs8W-!s8R]Pzck:m6jT#8[s8W-!K)krP!!!\"gJ:dk&!!!!A%tT?6z!1n]F3f3n:s8W-!K)blO!!#0]JV*t'!!!!A!J(HPrr<#us8W*']Slgis8W-!ZkFHOh\"97ZUZoHm?E6h1d2&0B!X@bRs8W-!s8R]Pz0Hl\"\"!<<*\"!.`RLK)krP!!&B3JHjs0s8W-!s8R]PzJ00=H@fHE-s8W-!Zj'V#SY6<WK)krP!!!#%J:dk&!!!!al[XTgzGVao'!<<*\"!!$8S#$h0-s8W-!rrs2:s8W-!s8R]PzO=>_b1\\q(Ns8W-!K)blO!!(5>JV*t'!!!\",l@9)=cN!qEs8W*'/#`LJs8W-!K)krP!!%PXJ:dk&z<.M=Ynqi9WK)krP!!!!YJ@+eH'qkl1I+F)Whl6D`S4eQWJZVlU/)%@UI[0<.E?j&F\"2l?-d]V$l,```e1GAMPZdeNOK\"`EuhO.Z3`<%6SY'6!7A<U<rNG*\\CSHD.]?=uQl[\"E3'3Ie8D55Tjm;?C9?`,iV]ktf+Pk3/oD]16qE%mPddMffq+QGi;jCcmp_^COW\")es)V<7!,6*@/^\\VHPt&qBof<\\*\"erbQcAY9/1i?qE^\"IR&>>GEWIA$\"\"TG_:Ci:J#KH`T1X/DBXV9>d2#m<'>a<45_<6PI@12P3YN$u/Li<^hJCfgj&\\`XBC\"5pbCi;4EK)krP!!\",XJV*q&!!!#2]Rb\\9zkV7Vm?2jm(s8W-!#%[c6s8W-!s0MkHUJ$4?zi9#OoJc>]Ls8W-!#)&3?s8W-!rs$\"4s8W-!s8R]Pz!%*8L!<<*\"!.YB,K)krP!!(@XJV*t'!!!\"L^OUq;zGU@uo!<<*\"!\"^u<K)krP!!%PiJ:dk&zeUW8Qz!%<A3!.t:P!!!!adsqX`rr<#us8W,+!`2JnjOF50s8W-!K)krP!!&*-J[?\"Z^E2tp2f@,;ALM%MGWOFNK)blO!.Z,uJV*t'!!!\"L,_:RKz^_)-M!<<*\"!$M&eK)krP!!!#/J@#K,!RnfpK)krP!!$+QJV*t'zhgg=[z_\"*#.!<<*\"!8oDZK)krP!!(@OJV*t'!!!\"L%Y4fds8W-!s8W+O!<<*\"!&+M+K)krP!!'gpJ-O[*s8W-!s8R]Pz5f8,)!<<*\"!.`@FK)krP!!#:+J-Ie.s8W-!s8R]PzJ?scY!<<*\"!$DPuK)krP!!%PhJ-Nd)s8W-!s8R]Pz5feH[JH,ZLs8W-!K)krP!!#:WJ:dk&!!!#7rdY1WlMpnas8W+O!<<*\"!3d>lK)krP!!!i_JV*q&!!!#sY(;3+z!9erc!<<*\"!)O;ZK)krP!!\"]$JHk68s8W-!s8N;aVZ6\\rs8W+O!<<*\"!!&F;K)blO!.^30JHkcGs8W-!s8TG-#@2r_z3%fadCl&,ks8W-!K)krP!!!i^JV*t'!!!!Q%tT?6z!:GAi!<<*\"!!)V@K)krP!!#h@JV*t'!!!\",/V185psPhAmlQ.&zn/m2cp&>!ks8W-!#+PYms8W-!rs&B#s8W-!s8N:WVZ6\\rs8W*'kPkM]s8W-!#,D1ts8W-!rs%hjs8W-!s8N:^rr<#us8W*'XgnE2s8W-!K)blO!!(ujJV*t'!!!\"Ls*t<[s8W-!s8W+Oz!1fF,Zijhpb`@AWz5i@0F!<<*\"!2/A&#!r\"`s8W-!s+:=P!!!#7jFDj_z5+7%T!<<*\"!!#97#$h3.s8W-!s+:=P!!!\"LV18bI\\GuU/s8W+O!<<*\"!.aBc#+Y\\ms8W-!s+:=P!!!\"lrd]V%z+<uGi!<<*\"!.`7CK)krP!!&ZKJV*t'!!!\"LjFDj`z^tF6j!<<*\"!/N:ZZj&mA8!YmiK)krP!!$slJV*t'!!!\"LZ@IQ-z_MNhr!<<*\"!!!=VZj!\\\"8Xcf7!<<*\"!'p.+K)blO!.Z9#JV*t'z)1dD@z-n'Y!z!)0#9#1C3bs8W-!s+:=Pz0S+iWzTGE*2!<<*\"!2(3\\K)krP!!\"\\eJV*t'zE.EQAz!-j$H!<<*\"!!#]CK)krP!!\"u%JHkFms8W-!s8N9'z!!!\"O!<<*\"!._\\3K)krP!!'g`J:dh%!!!\"KP_\"GfzJ?+3Q!<<*\"!&,jQK)krP!!(s8J:dk&!!!!AjFDj`z!8N)/=oSI$s8W-!#'g1Js8W-!rrsA@s8W-!s8TG/:$jLmZi_tR0XM!Wn'FfZK)krP!!'57JV*t'!!!\",&V5Q8z!8)h/#ASj;gfcChK)krP!!&rSJV*t'zS:G;SZiZ0=#0?fDs8W-!s+:=P!!!\"Lr.'D#zJ@C&]!<<*\"!5S;YK)krP!!\"\\qJ[>tM8e17.N=q,bKtul29l(`#!<<*\"!3dJpK)krP!!!#1J@#M)>/$CZc[u5u!!!!a`.3I@z?n6f8!i=+n!<<*\"!'nq^K)krP!!#:$J:dk&zJ:Ih\\T`>&ls8W*'pAb0ms8W-!#!;has8W-!s+:=Pz,_:RKzJ0'8o!<<*\"!.`4BK)krP!!#:CJ:dk&!!!!a$A!g1z^tsUK#5)7J0Ucg1z!/l_cK)krP!!(q)JV*t'!!!#'+b>7HzJB<>K\"p\\lVDlfpj!<<*\"!!(DsK)krP!!%NXJ[>aK0$RJsZQI=k\"rj?;s8W-!s+:=P!!!!a)1`\"Grr<#us8W+O!<<*\"!!'EWK)krP!!(s?J@#Ih#=&C@K)krP!!%NoJV*t'!!!#7(4h)=zkU1qg&]q.EQe619/:mml9LWG#h<G25s8W-!s8W,+\"2n<U#64`'s8W-!s0Mh70nTK,!!!\"LeprARz&0?CTz!!)&0#$([&s8W-!s+:=P!!!!q%\"X$2z?l\"<G!<<*\"!,s`FK)blO!!&t#JV*t'!!!!AomhYqz-n^('!<<*\"!9!I!#\"ejps8W-!s0Ms5;FWq`##,'ss8W-!rrtfHs8W-!s8R]Pz+:<Z(C<?MUs8W-!Zim;e*[.ln2'SJ=ZidRp\\?l<B?\\8@Z!!!#W)1dD?z!!!!'DZBb:s8W-!K)krP!!&\\TJ:dk&!!!\"l+b>7Hz!9A[;\"G.t)5D&t:!!!!agjk\"Xz?k7g@!<<*\"!5R`I##G6us8W-!s+:=P!!!!a/V/NTz^`@uY!<<*\"!3d5iK)krP!!!#DJ@#QIATK#>4Nt/9jC=gAJHjL$s8W-!s8R]PzTE0Ur!<<*\"!!%t.K)blO!!$7oJV*t'z14b&YzJF%f=!<<*\"!3cHSK)blO!!'48JV*t'!!!!ahgg=[zYR5r6!<<*\"!20@BK)krP!!!#5J:dk&!!!\"ll@=Kfz!6]o\"&Mp\\>KQMS*]A`'(P79MlG0#::z!5sD?!<<*\"!'g[<K)krP!!#:;J:dh%!!!\"\"XFZ!)z!+^Tao)A[hs8W-!#(6INs8W-!rs#J&s8W-!s8R]PzQo'AH!<<*\"!72m?K)krP!!!\"uJ@#cu11Qi.[R_W,PTT7%K)krP!!!!eJ:dk&!!!!amsp#kz!8rB[!<<*\"!+>_TK)krP!!!#CJ:dk&!!!!Y1k>kjs8W-!s8W*'UAt8ns8W-!#+5Dis8W-!s+:=Pz+b>7Hz5gFla9q_Ods8W-!K)krP!!%PsJ-J@?s8W-!s8N:Err<#us8W+O!<<*\"!2/n5K)krP!!'gWJ-MMBs8W-!s8R]Pz^u0_I&cVh1s8W-!K)krP!!%PFJ:dk&!!!\"t0nFrXzW%rpV!<<*\"!2/_0K)blO!!#3YJ[>OO+cQ[7rr<#us8W+O!<<*\"!:c_5K)krP!!%g!JV*t'!!!\"L'7kc:z819%A!<<*\"!\"]rtK)krP!!(pYJHgVVs8W-!s8N9?s8W-!s8W*'o%=!Bs8W-!##5-ts8W-!s+:=P!!!\"$,_:RKzJC8rP\\u,N-s8W-!K)krP!!#h+JV*t'!!!\"D-\\6mNz-nKq%!<<*\"!'h?O\"uH;Zs8W-!s+::O!!!#W[Xj)*-sVhMoa$&\"zJ0q(CK)krP!!!!1J:dk&!!!\"LW.9L$z!5O,;!<<*\"!:UDJK)krP!!%P[J-H\\ds8W-!s8R]Pz!!e(-!<<*\"!+>hWK)krP!!(@RJV*t'!!!\",#D'5`qXoIAz+Qn7ZJZf%Qs8W-!K)krP!!!\"nJ-Og/s8W-!s8TG.Z,8:#XJc*us8W-!K)krP!!\"/5J-HYds8W-!s8N;thZ*WUs8W+O!<<*\"!)O/VZj*D%e0''=#4DKjs8W-!rrtRbs8W-!s8R]Oz2m%X`!<<*\"!\"]EeK)krP!!!\"kJ-Nghs8W-!s8R]Pz+;KI7\"^rpD]V5V4rr<#us8W+O!<<*\"!.Y6(#&4):s8W-!s+:=P!!!#7o741W`.B#q@1Iu]2ES`Cc%?#s!!!!An:6,lz^rLtX!<<*\"!!&45ZiXh.K)krP!!%g/JV*q&!!%OH^4EWpm%eq9Uk8XI!!!!GJq8OTzTFcYY?Jtk`s8W-!ZjoI^N)X>gH#(eHQpVlcK)krP!!%QCJ-N*Ms8W-!s8R]Pz!1/3?_Z'T8s8W-!K)blO!.[&4JV*t'zn:6,lzpb.1&o`+sks8W-!Zmp8Q8LU_%ladVXpGPIQ_ijQb?bUAf/\".=u-RNseF+U*!O4eoX2<1V/\"qUb6s8W-!rs#afs8W-!s8R]Pz^t!sfz!3Ee`Zi[:k#0QuGs8W-!s0MqRBElH]K)krP!!'h5J@#`_bIS&O;?H+PJd[3`!<<*\"!3du)K)blO!!)#2JV*t'zUO]]R3q?^3!<<*\"!$M#dK)krP!!'MXJHiges8W-!s8R]Pz!#C-<!<<*\"!!jj$K)krP!!!\"ZJ:dk&!!!!a%tOprY5eP%s8W+O!<<*\"!+>8GK)krP!!#:?J:dk&!!!\"L'S1l;zcj,,S!<<*\"!,+0>Z3Hufs8W-!s8R]Pz^u'Zp!<<*\"!!\"'kK)krP!!\"/\"J:dk&!!!!Q07e`VzO>2:jh;A84s8W-!K)krP!!&rHJV*t'zZ@IQ.z!69VB!<<*\"!;I[fK)krP!!&*'JV*t'zja_sazLa.J'!<<*\"!8mj.##G:!s8W-!s0Mr&k+hRgK)blO!!&7qJV*t'zaag`#^c1Q`44XB2s8W-!K)krP!!&B8JV*t'!!!\"\\)M*MAzTHo)@!<<*\"!5RB?K)krP!!!#AJ-PfJs8W-!s8N;3rr<#us8W+O!<<*\"!'pF3K)krP!!'edJV*t'zUk\"'uzJA-O<(B4@6s8W-!ZjlMH!(:<6gTR/f4[3ih3WB'Ys8W-!K)krP!!\"/@J:dk&!!!#g%tOqCrr<#us8W*'\"TSN%s8W-!K)krP!!!\"HJ:dk&!!!!aept+1;-,'7K)krP!!%Q3J:dk&!!!\",&qL6)q#CBos8W*'7/m5ds8W-!K)blO!!%)$JV*q&!!!\"l3IqBQs8W-!s8W*'*rc3>s8W-!K)krP!!!#WItIb%!!!\"\\'S1l;zJ>n'Oz!4.uB#1*>Ls8W-!s+::O!!%O!Y(;3+z3$Np+!<<*\"!.Z_R\"uVJAs8W-!s+:=P!!!#G/V/NSzQD]:d!<<*\"!2/q6K)krP!!'geJ-PQ#s8W-!s8R]Pza<Q7gz!#_YbK)krP!!$EfJ:dk&!!!#G&:k%Vrr<#us8W+O!<<*\"!5QR(K)krP!!\"u$JV*t'!!!\"LomjCRBhb7sk>m39zi;S7Z!<<*\"!$L6NK)krP!!(piJV*t'!!!\"lnUQ5mz_!HRUrODn-s8W-!#!q/Hs8W-!s+:=PzXFPp(z!;M'K-3+#Fs8W-!#/gH?s8W-!rs\"(4s8W-!s8R]Oz6u.@+!<<*\"!$M2iK)blO!!!.[JV*t'z[X`u2zYUP,-^ki$js8W-!#5J5us8W-!s+:=P!!!\"L`.3I@z!+:>0!<<*\"!.`[O\"pt;/s8W-!s+::O!!!!3LOlf8QDIb$#.X^5s8W-!s+:=Pz+Fo(FzJ?OKU!<<*\"!!&.3K)krP!!'gUJ:dh%!!!\"ALk10Zz!24pq!<<*\"!.a*[ZikBlA(uV:zi:_[*W;lnts8W-!ZiZ#nK)krP!!$C]JV*t'!!!\",qga;\"z5U:o5zJ68\\\"K)blO!!$S^JV*t'!!!\"d0S'GZXoJG$s8W*'2ZNgWs8W-!#2]C[s8W-!s+:=P!!!#g'7g@ns8W-!s8W+O!<<*\"!'i&cK)krP!!'MPJV*t'!!!\"L]n!I,ijM2Z=dm7l*+q't)>IE1Md8OtdS@XjZiXtDK)krP!!\",AJV*t'zW.;5W-D3MSzJ=*EhK)krP!!'h1J:dk&z]7>M7z!:><D$:Fg$6tEl$@,;KJ!<<*\"!)O>[K)krP!!'5BJHg;ts8W-!s8N9Drr<#us8W+O!<<*\"!$Loa#%[`5s8W-!s+:=P!!!\",l%$,D\\@tqL#!i4gs8W-!s+:=P!!!#/+G#.Gz!/l@3L&V,Ps8W-!\"ttr8s8W-!s+:=Pz1P(/Zz+R=Q1!<<*\"!3c`[K)krP!!#:PJ:dk&!!!\"LTn%arzi8]??!<<*\"!$DDq#\"S[ms8W-!rs!oNs8W-!s8R]PzJ>.Pu(tS`es8W-!K)krP!!!\"$J-NL_s8W-!s8N9;s8W-!s8W+O!<<*\"!&u6TK)krP!!!\"QJ:dk&!!!\"lmXTojz^rCnW!<<*\"!,rR%Zk'la$gES\\j<4DWAJ+m-f*5+Os8W-!s8N:,_>jQ8s8W+O!<<*\"!:UkWK)blO!!#6:JHhRis8W-!s8R]PzO<fC0!<<*\"!5R<=K)krP!!\"/=J-I40s8W-!s8R]Pznn`l0!<<*\"!20\"8K)krP!!%NdJHkTBs8W-!s8R]Oz^s.B6GlIaCs8W-!K/GG@1G^h.ItIb%!!!\"L\\:B24z!;(eo!<<*\"!:VIhK)krP!!#:,J:dk&!!!\"d0nFrXzcm\"$n!<<*\"!15NmK)krP!!!\"fJ:dk&!!!\"LY^j(b<M$ObCJKK_zcjt\\[!<<*\"!.__4K)krP!!'h(J-OEMs8W-!s8R]PzTIGH!#9':'Dlc36K)krP!!$EiJ:dh%!!!#rYCV<,zJ-^]1cMmkDs8W-!Zk^7T$IhPn*7%On`/hP@'`,EL?m<_tFd)k*s8W-!Zij(F`!HWurr<#us8W+O!<<*\"!+6^r#2oL\\s8W-!s+:=P!!!#W\"G$d&s8W-!s8W,+\"ak6N_u^/2h#IESs8W+O!<<*\"!5Jei#/:-;s8W-!rs!6<s8W-!s8N9(s8W-!s8W+O!<<*\"!5QF$K)blO!!)/lJV*t'!!!!q.tP&<6gqZ`CoK^8iYmhI$WVlbT'?:Ts8W-!#'0bDs8W-!s+::O!!!!&\\UfA6zJB37n!<<*\"!.`CGK)krP!!(q#JHfujs8W-!s8TG5%./lSNRia%m$4pehSJMMWu/^4di;>%`!53#s8W-!s8R]Pz!3h!\\$P\\_,C,,1^[I,U*K)krP!!#c-JHd=us8W-!s8R]Pz5hLUo$0&Tb%T0UijB.$8zA86[Jz!#)Jc#-kuDs8W-!s+:=P!!!#W*J&hDz^qtW/%dEd?.;m74DKKB7Hm[#@b5VG@s8W-!#%@N2s8W-!rs$[Gs8W-!s8TG0R*ZeE9S3?G!!!\"D,CtIJz^rq7\\!<<*\"!&+h4#*@F9s8W-!s0N0iTf=JYB#6/\"M4=durr<#us8W+O!<<*\"!2qE!K)krP!!!#?J-H5Ws8W-!s8R]Pz0H5Rq!<<*\"!'oXr#4&f!s8W-!s+::O!!!#9JUrFSzi:2>M!<<*\"!,r!jK)krP!!(s<J:dk&!!!\"LiIHO]z&.3smbQ%VBs8W-!K)krP!!!\"lJ:dk&!!!#W0S+iVzoXf[]#AInNXmAs1K)krP!!#:TJ:dk&!!!!A.Y33QzE\"dd,q>^Kps8W-!K)krP!!!#GJ:dk&!!!\"LUOWQLs8W-!s8W+O!<<*\"!$L9OK)krP!!(sUJ:dk&!!!#7omd6YUAt8ns8W+O!<<*\"!$Do*K)blO!!&6sJHkK?s8W-!s8N9srr<#us8W+O!<<*\"!$E&.#(HROs8W-!s+:=P!!!#G\"G)1+zJFJ'nZ2Xe's8W-!K)krP!!%PrJ-M;=s8W-!s8TG0iS72TOb3Z7!!!\",m=9fiz!82mTz!0<h)#&F5<s8W-!s+:=P!!!#7'nN_#HU$c&]ig,*OA2:<\"t]fSs8W-!s+:=P!!!\"L_17.=z!/c:2=4I9Ms8W-!K)krP!!$C6JV*q&!!!!JJ:W=RzTG2s0!<<*\"!!%h*K)blO!.[)*JV*t'!!!!Q)1dD@z+Q\\-\\\"):1DK)krP!!$+DJ[>dZf:fYL3qKjk&VC)a!!!\",ideBBE>;:eCiU30s+:=P!!!\"LXFPp(z!,@%:!<<*\"!3c]ZK)krP!!%PgJ-Q&Qs8W-!s8R]Pz!-WmF!<<*\"!!!R]K)krP!!%NOJV*t'zV18cRs8W-!s8W+O!<<*\"!!(Gt\"uQ>Zs8W-!s+:=P!!!\"LkCBoH`0C]/8MZB&+tX#ts8W-!s8W+O!<<*\"!!#iGK)krP!!\",FJV*q&!!%OgY^qE-zT\\t?Q!<<*\"!&uN\\K)krP!!'eZJ[?Or=J^F4\"_@sW[+\\jhaq7\"/[p3^b=PpD+NE74^on?-F4oYK]s8W-!#)N9Ys8W-!s0Mk2Z/pT=zi!b0hzJ1.pYK)krP!!'ghJ-JLCs8W-!s8R]Pz!60NnVuQess8W-!K)krP!!!\"JJ:dk&!!!\"l#_@U/z^r(\\T!<<*\"!20%9K)krP!!!#(J:dk&!!!#Wl[T1Qs8W-!s8W+O!<<*\"!!'caK)blO!!#'8J[>N/2sZ(sz!0Vkb!<<*\"!!(>qK)blO!.[SAJV*t'!!!!as*t;]rr<#us8W+Oz!6p(G#/pN@s8W-!rs#Y+s8W-!s8R]PzJ1#mP4jsB1s8W-!K)krP!!#7mJHides8W-!s8TG0Rm4)[\\-=\\fs8W-!s8R]Pz&-[Uh')qq2s8W-!ZiZ]BK)blO!!&RPJV*t'zc@CNJz81T5qV<IsZs8W-!#0d,Is8W-!s0Mk`&1N54z5gOt5zJ7P@)K)krP!!!9SJV*q&!!!!9^O``q&r]^Don*8F!!!#W&V1-crr<#us8W,+!X/M0\"XVVjboVK<zYSD]n!rr<#s8W-!K)krP!!!#XJ:dk&zrIBM#zn7$sU$DhPAhp?t&2Ek^WFoVLAs8W-!ZiY\")K)krP!!\"\\fJV*t'!!!#7l@=Ke!!!\"L[_.0D!<<*\"!$ES=#+>Jjs8W-!rs%l9s8W-!s8N9\\s8W-!s8W+O!<<*\"!(\\krK)blO!!\"^fJV*q&!!!#iWI_DZp9KJEK)krP!!$EuJ@#F*bk_PAqZ$Tqs8W+O!<<*\"!5JhjK)krP!!#:LJ@#FN!(heDzJD>[-!<<*\"!:Tu>#'HsGs8W-!s+:=P!!!#'!J,k(z!7l[Q!<<*\"!.Z8EK)krP!!(pjJV*t'!!!#7m=9fiz!3Ld(!<<*\"!'nMRK)krP!!!\"dJ:dk&zZ[dZ/zT^.,\\z!'!;rK)krP!!#:-J:dk&zJUk*2TBSRAFp>>Qs8W-!s8R]Pz!/?#V!<<*\"!5Kb/K)krP!!(sQJ:dh%!!!##TRh^qzNjF:h!<<*\"!2/P+K)krP!!)46JV*t'!!!!1%\"YbnK\\]otO:BWqG&.>7!<<*\"!9!*lK)krP!!!#8J:dk&!!!!Q\"G*ocWbOZ!''`C9K)blO!.[\\NJV*t'!!!\",ja[P]P5kR^s8W*'(]OI7s8W-!\"tBTPs8W-!s+:=P!!!\"LeUW8Qz?m^F/62poas8W-!K)krP!!(@dJHdlbs8W-!s8R]PzJCoAVN3rWbs8W-!#)K2Ws8W-!rrug/s8W-!s8R]Pz^^>XF!<<*\"!'ga>K)krP!!&**J[>do,]\"jLV+EPb(ZU,Kz^t+#?`W#o;s8W-!Zi\\!1K)krP!!(q&JV*t'!!!!I07e`Vz^`7p4%(k,IBRBu?3CX0DB*K'es8W-!s8R]PzfI)4S(]XO8s8W-!K)krP!!(plJV*t'!!!#O0S-S?78@Bs%qF#hSjs2qK7a1)!!!#/1P#aSh>dNTs8W*';ucmts8W-!K)krP!!!9OJV*t'!!!!A)1dD@zcm40p!<<*\"!&,sTK)krP!!'gtJ:dk&!!!!%EIi`Bzpo&`Jon`YJs8W-!\"pP&,s8W-!rs!NCs8W-!s8R]PzJFn?r9@j.Cs8W-!#2llgs8W-!rs&K&s8W-!s8TG0<W%q$C4cNe!!!#'+G#.GzJDbs1!<<*\"!.a<aZjUnh1FmuTdKe#3-aX$Q?Y9nV\">$]Mb_#or!!!!al%\"Bez!2b:R%>&W2f\"H)`d\">#DFERl>a8c2>s8W+O!<<*\"!6?=7K)krP!!\"\\_JV*t'!!!\"L%tV(jQ_mB#K)krP!!!\"\\J:dk&!!!#_,(Y@IzfIMN*!<<*\"!.a'Z#(?OOs8W-!s+::O!!%NpWIY8<rr<#us8W*'70!;es8W-!K)krP!!$C_JV*t'z]RYV8z:bmU/!]!o2!<<*\"!+>eVZjFP,[8<'.FP=;1]?UBUs8W-!K)krP!!(@\\JHj`os8W-!s8R]PzJ=qDs('\"=6s8W-!Zj(-GcH:mIK)krP!!%NmJV*t'!!!\"L0S'Gis8W-!s8W+Oz!+E$]Zie2'SV$qC!!!!Am=5Cts8W-!s8W+Oz!.06I#5eE\"s8W-!rs\"ajs8W-!s8R]PzJ?aWW!<<*\"!'o%aK)krP!!%g#JV*t'!!!#WomhYqz5h1Ahq>UEos8W-!K)krP!!!\"bJ-JsOs8W-!s8R]Pz82#OH!<<*\"!2q,n#''\\Cs8W-!s+::O!!%NPV1F7\"z!6'J@!<<*\"!!$neK)krP!!!#^J:dk&!!!!A%\"SW\"s8W-!s8W+O!<<*\"!6?aCK)krP!!#h&J[>OX@98'^z!/#fS!<<*\"!+>,CK)krP!!%Q7J:dk&!!!\"\\%\"X$3z?itte!kl8O&H;_0s8W-!K)krP!!!\"FJ-I^Us8W-!s8R]PzW$$YD!<<*\"!0A:RK)krP!!\"DsJV*t'!!!#g#(a-:#1-0kXODd[SiON%A1O)d+=ALY/9?H:Bu]uiK+u7pO8rF-f;#/ZN-Ck]%*GaJ!JUg4s8W-!s8W*'RBlkms8W-!K)krP!!&Z6JHgYZs8W-!s8N:-s8W-!s8W*'GQ7^Cs8W-!K)krP!!!#:J:dk&!!!\".G_(JJzO;i`ToDejjs8W-!K)krP!!&B>JV*t'z[\",Lo$Ei-uYnH@FA8g4%@:3St!<<*\"!,s99Zio>hB@!pk\"g>*.MPD\"lcNYHjs8W-!s8R]Pzi#[FR7\\Tk^s8W-!#1NVPs8W-!s+:=P!!!#G!.b>%rr<#us8W+O!<<*\"!5Qj0K)krP!!%QJJ-MhLs8W-!s8R]Pz+R4K0!<<*\"!2/h3K)blO!!#!?JV*t'z%=s-4zi!+ab!<<*\"!+>AJK)krP!!!#QJ-Od-s8W-!s8N;uJcGcMs8W+O!<<*\"!0@\\AK)krP!!!#0J:dk&!!!!aoRMPpz0F35^!<<*\"!+=`8K)krP!!$C:JV*t'!!!\"$0nFrXz^r1a-IcCD-s8W-!K)krP!!#:`J@#[P)[mtg/*;r#eUml&!!!\",'nLu<zGVF]$!<<*\"!5SA[K)krP!!$+VJV*t'z!.]\\&zi:;E*![ihW!<<*\"!)OA\\K)krP!!#hIJHfrDs8W-!s8N:us8W-!s8W+O!<<*\"!+>MNK)krP!!$sAJV*t'zKRgE3ZN5U]MuWhWs8W-!K)krP!!%PVJ:dk&!!!#'\"b?lXrr<#us8W*'LB%;Rs8W-!K)krP!!'g]J@#[=6Nu1uH5bd,h$0CRs8W-!s8N:Mrr<#us8W,+&SBB'0r(q#dTJB\"?-%n5HkM&4zJFA#q\"mQTp6JI+nz5fS>,!<<*\"!)NoO#,'!9s8W-!s+:=Pzqga;\"zn0`d>!<<*\"!$EnF##*,<s8W-!s0Msq8'73)K)krP!!#8.J[>Sn)WjWtK)krP!!\",QJHe:;s8W-!s8N9Hrr<#us8W+O!<<*\"!+>bUK)krP!!#8/JV*q&!!%NpWe%M`D+Oq<K@fHfE3o\\>49hPZs8W-!s8R]Pz^]8qm%Z\\cFq=-PC)D<QjoHO$^!<<*\"!!''MK)krP!!!\"sJ-M8<s8W-!s8N;ds8W-!s8W,+!na(K*<-!<s8W-!Zj\")c=chKmz!;*gQK)krP!!!#4J:dk&zO+;i`z_!?LTG5hOAs8W-!\"sj6Ks8W-!rs%<8s8W-!s8R]Pz+9mD(\"$FDM#!W%ds8W-!s0N7A*\\V!T:h4Gj-=o$[i.D%1!!!\"LXagV*s8W-!s8W*'H2mpEs8W-!K)krP!!#h<JV*t'!!!#7f78JSzO9gDi!<<*\"!!k90K)krP!!!#fJ@#HuGY/hX=T8@#s8W-!ZjDXH5(8f*-2EgY!<<*\"!0@G:ZijQ?#;l^AQN.!bs8W,+#Y^d\\e45ijQ@f2<!!!\"L\\q#D6za<cCi!<<*\"!'p%(K)krP!!)L2JV*t'!!!!ag46OBR0iY]K^1#]\\k*7oL;:L5\"pPsAs8W-!s8R]PzJF7r?!<<*\"!.aHeK)krP!!!\"YJ:dk&!!!\"\\(kI;?zE\"mj-e,KCIs8W-!#*/``s8W-!rrtI^s8W-!s8R]Pz!.o`R!<<*\"!,rF!K)krP!!%Q&J@#MpDQKu%:4iQI!!!\"N@t=hds8W-!s8W,+\"g!=ZII[Sus8W-!s8W*'YQ\"S%s8W-!K)blO!!(T-JHl&Ps8W-!s8N9qrr<#us8W+O!<<*\"!5QC#Zi\\PRK)krP!!'M\\JHj[)s8W-!s8R]Pz!(_Wm!<<*\"!!)bD#*Jrcs8W-!s+:=P!!!\"<%\"YbjijMVl=b>D8$&R9*43G\"9<l,&*V#UJps8W+O!<<*\"!+=r>#$V',s8W-!s0Mhi7=tU@!!!#g&V5Q8z^s%<5huE`Vs8W-!K)blO!!&+YJV*q&!!%O'[Xj&3z5eqoW!T\\k5zNbX,t!<<*\"!'oq%K)krP!!'gVJ-M5;s8W-!s8R]Pz?ke0E!<<*\"!$E53K)krP!!&\\hJ@#A15I:di).<h1h:5L-`!-MHs8W-!s8R]O!!!\"LQF;?s!<<*\"!!$\\_K)krP!!%NlJ[>WL#k>O6pk&SI!!!!Q$A!g1z!+LH_B)ho2s8W-!K)krP!!!QaJV*t'!!!\",oRI/3s8W-!s8W+O!<<*\"!!ja!\"t9KNs8W-!rrsGAs8W-!s8R]PzJA?]B3!R`+,HT@GiLW'ECh6Dm=*,g2->@PkodSYY?IUp[Nl+qJCRi8R\"5%;=R1,\"9]M?7@LKW'c!.t7OzCk.-<z9WN_s!<<*\"!+6q#K)krP!!)A'JV*t'!!!\"<$%[^0z!7uaR!<<*\"!:V\"[#'9hEs8W-!s+:=P!!!\"l14b&Yz80ib=!<<*\"!2('XK)blO!!(#bJV*t'!!!\"Lb^]oC]Dqp2s8W+Oz!#.eOK)krP!!&\\VJ-NcRs8W-!s8R]Pzpb%-)&l'(U.k\"WP8nD(:-Z)&foe\"u(%K?D-s8W-!Zj/l_\"R_;jTn<@G!!!!a%Y964z:7?`d!<<*\"!'pI4K)krP!!'5CJV*q&!!!\"PY(6d$rr<#us8W*'OT5@\\s8W-!#3#R]s8W-!s+:=P!!!#g/qF5[rr<#us8W+O!<<*\"!20:@K)krP!!%ftJHkNAs8W-!s8N;/rr<#us8W+OzJD6cKZiuVl)jd@Q!<<*\"!5RiLK)krP!!#:ZJ-IS(s8W-!s8R]Pz^ajtg!<<*\"!+>;H\"p_=2s8W-!rrt^es8W-!s8N<#Q2gmas8W+O!<<*\"!!$hcK)krP!!(@jJV*t'!!!\"l#D&r>!X\\o-!!<3$!\"/c,z!#Yb:!.+\\G!-%u=!;QTp!.t7Oz!!rZ+!/^aV!,V]9!#GY9!2fes!,_c:!8[\\U!8[\\U!*'%\"!5ed:!,qo<!-A2@!/gjX!6bEC!,V]9!##>4!Yc9I9E5&tScf#n>b2&u!*g\"%!%6E[\"@PdklNX7\"86=s\\[f]0&Wrb[[ACCtM!_?DY#\"1ut!1X2m&\"Wn(!*h9I!%6E[\"@PdkZQSE486=s\\^B$l,b9B>FAE*m'\"%ZMj,,Z&E=6BlX87]UUk5n1UZQMY,('$IY!_UN<r!*5G!>GM6>`o9k!*j8,!%6E[\"@Pdkb5o'S86<tV6qCj`'Xn08=5sQS87^`t^B$l,k6XOIA:NbD86;Q#6qA'n#TtkF,*NBWGp\"B)%tal_!71gQU&c[7%m^0q!*k6[!!$9,!CQo8fT-/'87\\&0k5n1U[f]#hA<RM<!D$;T$+C\"-=/uD#&kH*e#t.<pgCr`O86;-#6qA'nX9S`4j9LbOO9Bp]!WW4*iW2FI-eOI_6qCk+(T.m:=-F=d87]1Lk5n1U]+%/!('$1L,XDG*#3Q:Y!!!\"(M?<hY>`&SN!%6E[\"@PdkisW<u86<tV6qCk#''B<e=5sZV8/;1VT+;e>!!$9@!rr=+Xo^uk-eOI_6qCi9^B$l,k5r*p86>g:6qCk_\"m5qX=6gDc8/;1.*,<Y@*97/<P7%?j>\\3s9>hT6I!%6E[\"@PdkQPHt386;hr6qCjP)SZ;D=6Bmf&kH*e#t.<pq]k8*86<896qA'n'GP)i)&N@7!ItFA\"h4eBWWE/#>`JnS!%6E[\"@PdkgB-O>86<8%V\\2O%k6XOIAD7@P!_?CR&k#9$ru^D*86=OI6qA'ncj-'FHb9GC4Ck>pdgQ@<U]^Yt>V6!V>fHk6!%6E[\"@PdkLD.E'86=s\\6qCjX,j,5\"=6BlX87_H/k5n1URj:Bm('$%\\%mdi2!:U4uh>mTV>k.tb!%6E[\"@PdklQs\"B86;hn6qCk;$KhI]=6h/#8/;1*!7_+A\":,!X!<<*&)#sf&#%7K3!*lN,!3?6K\"9\\j<V[!2%>`Jpe!*lZ06i\\UeNs%jAACCq$!D$;$\"%5[jgC!*F86<P,6qCj`#e'n,=,.He&kH*e#t.<pa!R\\s86=g_[f]0&V\\qlnAH*1L\"%ZMR#epC2=47RG87\\=qk5n1Uit+ULAA\\\\N&kH*a&4B'\"K,(it86;Q$6qCk/*2aE?=6BlX87^Tnk5n1UT*.PQ('(-7!+-ic\"D$g=fEVQ&!=T)N`rX@-Y8InN!=4nmL]g?b'Sm!)V[(Bh\"?2DFe->tY[KQX2>e1),!%6E[\"@Pdko,=M>86=s\\[f]0&?URFq]*kML86=s\\6qCjL#3Q%Y=7[=u8/;2U#8B9#,QM*3\"TSO-l30QU-eOI_6qCj`)!:rk=6Bmf&kH*5\"%5[jRfqmU86;Q'6qA'na9@_2@IO@!!*lN)q[Dlrs8W-!s8W*0PR@Hk>a>R^!%6E[\"@Pdk^B<X#86=s\\[f]0&VZ]CYA:k0N!_?D-\"%5Zq!!!!F_ughVzzz!!!<*!!\",A!!#%[!!#@d!!&De!!#+]!!%BH!!\"qY!!'V2!!#Oi!!%9F!!'n:!!#Ig!!&#Z!!&#Z!!%uZ!!)9a!!#Oi!!(UO!!!<+!!#Ig!!!`8!!\"DJ!!#1_!!%TN!!%TN!!$(%!!#t!!!#@d!!'&$!!$=+!!#Ff!!'b8!!$p<!!#:b!!%`R!!%`R!!%`R!!%lV!!)6b!!&;c!!#%[!!\"YS!!&Pj!!#+]!!!Z4!!3K/qb7%j>g<]W!*meW!!$9L$NL03&hj;5fT-.h1h>VN['Klp.f_OgAFgSDZNNB@!'EASK*)*5)$#JK#!=C94?R03*^J0u5l^mI)#uWY%QHF-Fdj()3-DDL3&l'X-TJ\":4Z\"iLA>^('!]4!=\"u%kL!/LdY>[f)]-eOI_-nJne#cA:d=6BnQ!\\@F5&1B)?is+ZJ/6@`8-nH,6p]LS0X9S_*>_W8-!%6E[\"=Pg3iu\"[,/6CjC-nJoP*9RAS=5t,G//A6(\"kjAn!!!\"(h?*`X>cIfY!%6E[\">DZCk8/r1\"un+53&kHl,<V_?5la0*#sePZLC$6H!'!1S31CgT3&oIi@/r:e$:+[K!<?\"W38YN<!'$/X76!:'!FYu8ZNN6<!&urKo+n^>\"?\\174?R/,!rt:u!.k7P;E-YN%7'tR3-CE*3&l'D-9/I:4Z\"iLABu+U!]4!A(GIZ]!!!\"2ScU;?-eOI_-nJp/,Gu/*=47R+/7do[k5m29s!&pC('$m\\(I8$$!*m5>!!$9@!\\aU%fT-.h1h;pfQOYtoj!D(=\"?\\174?R0G-FC)^5Uuh\"5\\,KL!'D,!3'7[13&l'('f\\0q`sar*&j8'*1h;pdk5mJA[h^YS('\"=7>_3'^\"TTq&Ns$j^A@!Gg\"\"[NS![oU1[he-./6A_P-nH,6!!HF)!!\"0o!<<+)V?84H-eOI_-nJo,'=S&p=5+-3/7ec+^B#leit*UiAFBc$&hI,E&1B)?q]b2)/6D9F-nH,6kQLqga8uL_!G(@<#QV(0!!!\"(V?$Ys>iGi>!%6E[\">DZCpBQM1\"un+53&kI+*^%Ug5l^mE)$#JK#!=C94?R03*^KT25l^mI)#uWY%QK9##!=C94?R/t,='Qp5la<.#seP^QOc@^!'EIW3'7[13&l'4-TF).[hq*6\"$JIp1h<X/k5mJApBNB/('\"=7L&o9s-ibXINs$j^A>^Ze!A%=8$+C!f=/uBN/7eJ[k5m29V^!T@('\"?a\".K=g#epS3!rr<#s8W-!&**cl!*npp0E<KQNs%-nA1NIl\"un+53&kI+*^&1(5l^mE)#uY>,QTl\\L^#sl!'EASb9K:,#sePZ`u[MH8B2c;!!#,G&3)c^3&im?lOPs7Fg!/Pk5me'0Jm=@'^#NS=/--W1_p&k!*mAE-ibV?-nJnu\"LeIa=/uBN/7c@#V\\1O^mfb*jA>9Oq!\\@Eb$RdPA!/La;&4$9r!&BuJ!!$9X$ig94nc^EA-eOI_-nJne,Gu/*=6Bl</7bq&k5m29M^'W$(''9s&6T\"Z(D'[.&-)]8Q3I<h>abjN!%6E[\">DZCP6*`@$WN043&l'<&3)Xl2`Nd>^BQ[4!Bi7n1h=K3k5mJAK-2j)('\"=7>fHsrp];hqNs$j^A<RV7\"\"[Nc%k&u>ZP_j,/6CjCV\\1O^^B#`6AEsTc!\\@F9#q.?8ZQ831/6B:_-nJoH-+<t-=/uD;!A%=8#q.?8K-9=Y/6B.u-nH,6!6b[PVudYI`rUf1kQ:fYe,p]V-UA.@9L\\4L,ej@G!!!\"(U'DAH6N@)d>j;Im!*lZ30E<KQNs%-nAD7L!ZNN6<!&urKo-UiN\"?\\174?R/,!rt:u!7r,K3B3?Q3-dJC3-D8:3&l&i#WUuK4Z\"iLABttQ!]3u^#V\\(N!!!\"(mKY-?-eOI_-nJo8)n,o#=3D[6/7cX1[f\\0_Wra\\#A<-u1!A%<M''B<I=5si?/7bpik5m29Ns@'a(8(\\l,nO*&(r$*Y!<<*\"]E.F(Rj/%D\"98F,Xp>\"->d=Vh!%6E[\">DZCZPU!T\"?7n33&kHX#.1]>4=^Co4Cj'H!&thrZO8`Q3/E@p4=^Co4Cm=j5j'\"N!!#,!!'!(L3&im?T+*b>FlO)oV\\2-L0Jm=L(ZtiV=8*\"T1_p&k!*k*^-ibXINs$j^AFCAu!\\@F5&AJ5s=3Dd9/7eJ]k5m29b7F(E//A3c!([7Y,\\0rK\"98F,q?d3&>cnAe!%6E[\">DZCf*$nc\"un+53&kI+*^%%]5l^mE)$&P93&rsSL^#sl!'EASb9K9A'0uUdLC$6H8='iQ!!#,G&3)c^3&im?M]Oi;Fh\\hSV\\2-L0Jm=$*TmJ\\=4[R/1_p)d!<?AV$7Gm%fT-.`/7d'.V\\1O^k6WOfAChs=!A%=$$n*Z;lQN_>/6D-Y-nJo\\$F^*g=,RG7/7aMU[f\\0_b9*Vp/6B:_k5m29k6WOfACgtI!\\@F=+XelW!\"].a!=80!it)gp\"LJCB=TAkd\"&7qbg'dso$ig94g'T5.-eOI_-nJo(,e!k,=/uD#&hI,I#q.?8cPu$K/6ASl-nH,6_up&[apS1L>lG'Y!%6E[\"=Pg3WuS#M/6A_^-nJo,!Oi.^=1\\tk/7e>c[f\\0_Wra\\#AA\\G_!A%<q,,Z&)=6BnQ!\\@F9#q.?8QQ##g/6Akl-nH,6j93p;5ldDZli^J,\":V(1*WQTWX9#XU!!!&\"#ljs1WWrM(>ga!.!%6E[\"=Pg3LF&i2/6D!@[f\\0__^$W]AB-+-\"\"[NS![oU1T+8=4/6B_7-nJnu-0G=\\=.]sN//A3c'\\`Wk\"9`7r-BnSe!pTdl!!&AeNXPmf>`oLD!%6E[\"=Pg3ruo,X/6CjCk5m29k6WOfABtYH!\\@F5&@V`m=,RI$!A%=8#q.?8dhfIq/6BFo-nJnu)!:rO=47s6//A3k#SigR#f$R8(]X\\N!29RW\"?(W-!*g!6!*n@h-ibXINs$j^ACh:R!\\@F9#q.?8cQ_NR/6CF4-nH,6!!$Yr#9a'Izz!!`K(!#,D5!$;1@!'gMa!'gMa!'gMa!(6ee!(6ee!&X`V!&4HR!$D7A!+c-1!.\"VF!$M=B!;?Hn!29Gn!$VCC!(R%i!3H5$!$D7A!*oU*!4W\"/!$VCC!-8/@!87DQ!$;1@!4Mt/!9=+[!$2+?!6YBC!!<6%!$D7A!($Yc!($Yc!($Yc!\"T,2!$qXG!$D7A!)3Lp!)<Op!$M=B!1s;m!*fO)!$VCC!4r:4!,DT8!$2+?!'UA_!'UA_!'UA_!'UA_!9!tZ!07-\\!$2+?!$MFE!2BPp!$;1@!(d7m!4Dn.!$2+?!,hr>!5S[9!$VCC!0R<^!/CXV!8mkXz!\"T&0\"q1hU()d[s:&k9!NXYsg>`K6n!*g!N!%6E[\";i+hZQR!`**;;0(`[)<.(99u=1]!@&fb!5&/ZBtM]([Z**;/3[f[UOLD-Qu**;;0(`[()V\\0tNdgR'5ACCtM!ZY9[(`X:kqu[@\"!!!\"5\"Gd/5!P8BZ\"[E3Y!RD5U,[?cD#QTAU'EA,<ncJjl>\\YA]-eOI_+=(Ki,i^4\")uC!k.!7<o.!<]E-n'5]![tea4X;-qA:NbD,Zg`T+=%^&!!$8i!>keafT-.P*+Z5cV\\0tNk6\\U\"**90B(`[(A+27gr=6Bn!!utCk$lBspUD2km**7n;(n:gH!\"@?[r;dIo\"TW+s#64a/aoNUb-eOI_+=(LP&Vu5I-n>9G-tM3V/C+Pe!!\"Db!9YXVGpp&+\"=u&'/1b>@#.1]>0Im,W0P#e<!%\\uf-nGiV-n'5i'IYAPM]4(R\"$InP,\\4A\"]+a3N,:Ft/!au'WRg_R_U&k<m-n(Dr5lc^s\"tV8)/1b>h*\\b2Q5l^m9)#u'50J\"Wd!au'WY7!Vr`W?-<-n(8r5l`;]FgDT,.!>,'.&R\\@,Tn@CWuC.&,Zi_4+=%^&!!)EfiW9qs-eOI_(`[(M)Rfeg=/uB>*+YBNk5lW)V\\0gdAD7^Z!ZY:.'sIf\\('\"U?J-\"j:!!(1CQ3dNk>`Jn/!%6E[\"<\\t#is^a\"\"t1u%-n&W`*\\<3U5l^m5)$%E\".![3h.!<-)-n'5M'IYAPK*<[d!^.eO,\\6osk5lo1P9M+p('\"=7>fm-c!%58W(`[(A';lH_=6Bl,*+Y6Wk5lW)UD4Uc('\"aO8cShkBa!o+kQQ;9!!$94\"TSO-p&cE;-eOI_+=(K](PmkO-n>9G-tM3V/>jCP!!\"Db!2BZF3@No,.![3h.!:_#-n'5u+\"6:R4X>i>\"t1u%-n&W`*\\?1T5l^m5)$#F9-mU2h^'%jE.)Qcc!6,-A;CEsb\"@3#9.!;j3-n'5!#Uh*Db8D_;\"$InP,\\35Qk5lo1V^!<0('\"=7>il/+!%6E[\";i+hRhhn7**;;0[f[UOWra+XA>^[8!ZY:N\";i+`bQSCT\"7QE\"\"98JV%0-B5NWg7\"-eOI_(`[)@$KhI1=5si/*+[)0[f[UOWra+XA?up3!ZY:r$5a`u!\"]-\\!R(QE!\"?^L!!$98\"W.4efT-.P*+\\XZ^B#<Uk6\\U\"**90BV\\0tNk6VtFA<-rX!ZY;!+W)17!!EF8cOPa5TEarf?2st1jolk--eOI_+=(Ki*;:bs)^6[Yq?::-.)-lj!0RNd;CJoY\"=Pc#-n&Wt(::CN/1U]O/7aA8!%8]bLkl6d.f_+OABQ2O^CEO01kuB'!'#`?5l^m957f4o$n*MPFn5V^.!=DX.),dG,Tn@C]*md',Zg02+=%^&!!$9H\"rI=ffT-.P*+Y*:V\\0tNk6VtFA<R)X!ZY:R&/^c<('\"aC\"/H']\"9;]@$ig94mKOL.-eOI_(`[(m*PVUp=6Bl,*+[M=k5lW)ZQ0l&('\"d,\"p;dF$k-\\0,6.^K^'ao@>a>U3!%6E[\";i+ho,4G=**:St[f[UO]+5_uA=!P9!?>2(#oFXmlO)eV**;_L(`X:kli[aN!Tt[-kQ+qG\"TSO-`Wm=\\-eOI_(`[)8*p3SE=5si/*+[A5V\\0tNit/[%**9`_(`[(Y,.@Xo=8O0Y*+[e3V\\0tNk6VtFAD7:&!?>1i$lBsprs@ii**9$K(`X:k'Xo8P!\"?498cShkklCnep]>f`!N65+#1!dh\"9;]H!<<+)Sd6G=-eOI_+=(Km&LcBK<9\"+;L^#C\\!%][3b9J^u%RC(O`u[MH36*(+!!\"Q7&1f4p-n*@H@/q^^$UFdD#QRaN./+oO!%97<k6*1]FgDN*[f\\c=+=(KY#Nl.6=2,@j,Sg@[!*o(#(]Yr9Ns$:>A=!M8!?>2($)\\CU=3Dd)*+Zesk5lW)QNe9He,]Q^\"H3P8!=Sr.>\\3s9>absA!%6E[\"<\\t#k6SH$\"=Pc#-n&W8#.1]>/1U]O/7aA8!%8]bmis5@.$kr&;(*jH$\"3giL^#7X!%97+b9JRe+$fl\\j!?tk1uflJ!!\"E3&E3ur;CErW-U@_\\.!>D*-n'5e!@Y\\`4X;-qAEO-Z![Lk1#TtB.!!)?d>lG$H!%6E[\";i+hk8pN6**:St(`[(q.&R[t=6Bl,*+[YB[f[UOgC+o=AEO6]!ZY;)*Z,k4!9=7_\"!A!\\AEP0K!2BPt'Xo8P!$hPLM?<hY>eUO^!%6E[\";i+hdic+%**<\"]V\\0tNk6VtFA?Q'D!utC?)8?1l=47Qp*+\\pdk5lW)Y6#O\\('\"d<!BU;Z#673r!!$X3!!$9t$5`ajfT-.P*+Z5i^B#<Uk6VtFAFBo8!utCS%i?9sT-^rK**7n/(`[(e*9RAC=3Dd)*+Zf(k5lW)_^63?('\"aO8cSkh\"_e)>kQ/j-\"9\\jAcOL3\\J,t`7!!$9`\"TSO-_@%Id-eOI_+=(Kq'o7YM-n>9G-tLLG/B])#!&2/*5l`a.%m^0q-pJ7k.!:k\"Lkl6d.f_+OAD\\F^mj17\"!%\\uf-nGiV-n'3W-n'5],q.pX4X;-qA;^WS![Lk9+Wr$G!!!\"(Q4+T1-_pe\\*+[5)V\\0tNV\\6`F**;;0(`[)T+m/nH=3D0m*#8Oa\"L%oW!<a+S(dS-%!*o(%$k-\\0,6.^Kl3mXm>fmHl!%6E[\";i+hQOW*Z**;;0(`[)8(Zti>=-j@5*#8Mg[j\"*T!!$72!!$9l$lAslfT-.P*+XgPV\\0tNk6VtFAG7&+!ZY:.+rD:8!\"]-\\!<c@%>fI0P!*kZr(]Yr9Ns$:>A<.Y,&faur,.@Xo=5+-#*+\\4V[f[UOLD(LEAD[X$!utCC!Z2nfM[m2u**9`_^B#<Uit*%IA@ioG!ZY;)+rD:8!!&Af2$=&p\"/l7H%Wh\\D!!!\"%l374g>i#o,!%6E[\";i+hh\\!=\"**:<*(`[),''B<9=)/Wm('\"aOAEP0K!.Y(Q'TWWe!<<*\">e19i\"iUcIs8W-!s8NV-#ljs1NXd03-eOI_+=(K!Lkl6`.f^tGAD\\FZ]-]fD!%8]bRg1?=-n)e>@/u+>\"t1u%-n&W`*\\?Ir5l^m5)$%Yd!)b3nM[D`M-n'5u)(6nUf+BDZFk7*OV\\2-<+=(K=k5lo1dhEoM('\"=7>ilM5!%6E[\";i+ho+A_<**;;0V\\0tNk6VtFACD7U!ZY;5&[V`^('\"K]\"C-rr&c_n3!rr<$$31&+z(B=F863$ucI/j6ILB%;S:&k7oJ,fQLT)\\ik<WE+\"I/j6IWW3#!YlFb(OoPI^J,fQL-NO2IRK*<fIfKHK!!*'\"!!*'\"!!*'\"4TPN_ZN't*IK0?JB`S26aT);@IfKHKPlUjbdJs7IIK0?JrVuourVuouWrW2#h#IETIK0?J]`A*5jo>A]IfKHKcN+\"Go)JajJ,fQL$NL2/+s>9,!!$8q!<<+)$7#U!fT-.\\-tN3$^B#`ak6\\%!-s,R<,Ud3H,3K\"U=8O9h-l)fi#&mh=!<<+)/gLEEfT-.\\-tLpX[f\\$[]+6/8A@!Df\"\"76O!iHYZ=6Bn)!@V%4#p^p0lNZMR-s,\"K,UaE.#RH.cV[%V-#?Y:4!*itY!%6E[\"=,C+UD0U=-s+k+k5m&5k6WC^AChg1\"\"75XV\\1CZk6WC^ABP\"_\"\"76O![K1)is+ZJ-s*/X,UaE.oEPAH!It3X!siE;!!\"gt!<<+)U&cM>-eOI_,Ud3,'\"7rk=,.G7-tK@s^B#`ak6WC^AE+Ni![q-R&gSk@!!&YqcN+:OZj'bb!!$9L!@.XmfT-.\\-tJMVV\\1CZb9A2[AEOEb![q-6'dP1C!2p(4!au'/!*npm,QK4ENs$^VA@iJP&h$iE#p^p0k5j`I-s+\"n,UaE.kQ:fip&k?q>`Jk2!%6E[\"=,C+pBB^]-s,R<V\\1CZ[f[m(AG6c#![q.E\"XGK3!5Ja<&7>J<>e0tVq^\"ZB!!$9X!rr=+^&fP[-eOI_,Ud4#,Gu/&=6Bl8-tGR*![q.I,:\"ZQ!5&O:B)oOMap%hFs8W-!rssqr!!$9`![IanfT-.\\-tJM[^B#`ak6\\%!-s,R<,Ud4'+/]`\"=6Bl8-tM'Ek5m&5P8Y\\p('#3<\"@sNn\"oqnc!WW4*Ools0-eOI_,Ud2Y!N-PY=6BW1-tKq#k5m&5LB/YK('&\"fAFCQ>!*n@^!!$94\"!djofT-.\\-tK4hV\\1CZk6\\U\"-s*GN,Ud3X!p9V5=8sNk-l)d_]E*@!J,oZ3!KI6^!*n@_,QK4ENs$^VA@EoK![q.5![K1)gC1On-s,R9,Ud4##3Q%9=5+-/-l)e&*+],-!WZ-J\"98F,M?G1)-eOI_,Ud2Y#epBg=6Bl8-tJepk5m&5LBo.R('\">R>d=GOg&ka`!!$9,\"=*spfT-.\\-tJ5KV\\1CZk6WC^AD\\0c![q-.&gSk@!6bTH>g<QS!*meP,QK4ENs$^VAA8YQ&h$hj\"!f:*X!6^.-s*ST,UaE.!\"^\"J!3?3J'XRrVAFh&H!*krt!!$:#\"=*spfT-.\\-tN>g^B#`ab9A2[A>9F.&h$iE#p^p0Y63qh-s+G9,UaE.!6>1F#RJc[AEtK@ZiaM@`!69IWW`A&>cn5U!%6E[\"=,C+V^B.Z-s,R<,Ud3P$g.R>=48NB-l)dk$tPhP!71aOdKT[O>g`d$!%6E[\"=,C+T,-Sk-s+.a,Ud2Y)lF;s=3Dd5-tJeSk5m&5LDqKe('*\\+b9AMP%*KhHcijCL>kS@%!*k*[,QK4ENs$^VA4OB8-s,R<V\\1CZk6WC^AE+Kh![q-R)'gUG!\"]]P_]s[7<*[]P!!$9(\"sa0rfT-.\\-tKXd^B#`ak6WC^A?-.%![q-&+=&?N!\"anq5l_0!8dr?7&-;h3cim\\R\"TSO-ecmB\"-eOI_,Ud34-bf[1=6Bl8-tJA]k5m&5[jNFL('\"@0#=o7'!*lB*!!$:#\"sa0rfT-.\\-tMWNV\\1CZ[f[m(A<RYh![q.9$7%#8!0@C%$kr[A>fm0L!*l*#,QK4ENs$^VAGZnH\"\"76O!iHYZ=6Bl8-tJAYV\\1CZit*IaA=Eed![q.M#p^o7!#P]d!<e2[*+XgFQj!I'V??l!>d=DC!!!!$!!!!2z!!!#%!!!!+!!!!+!!!!L!!!!D!!!!#!!!!j!!!!X!!!!$!!!!%!!!!%!!!!'!!!!'!!!\"E!!!!d!!!!*!!!\"U!!!!r!!!!$!!!!3!!!!3!!!\"u!!!\"'!!!!%!!!#0!!!\"0!!!!$!!!#B!!!\"8!!!!%!!!!,!!3/C9)nrsh>mTV>RD_V-eOI_,Ud2e$`=Uc=6Bl8-tLLFk5m&5P7&Wa('#<S>i#J]!*h!!!%6E[\"=,C+q^0&Y-s,R<,Ud4#-0G=X=8O<i-l)d_N!<PD!NH4r$ig8,s8W-!&,$;L])t>!!!%Bd!!$8),QK4ENs$^VA;^`.!@V$u$m[63]-Xog-s'cj!@V$u%-I[?=6Bl8-tJ5Rk5m&5M[1RV('\"cI#@s_;&-,B,!9=0p!TXIc!*nXe!!$8e!@.XmfT-.\\-tM'G[f\\$[V\\pa.AFC`*![q.)'-ntA!\"]E:&.n72>lXj)>daYY!%6E[\"=,C+QQX$D-s,R<,Ud2e%_i#m=6Bl8-tK)!k5m&5QQRP%('#&a!_a\"&cj!a8!<Bb5HOKlS>Z)+5!0dTd!*lf1!!$9p!@.XmfT-.\\-tN&ck5m&5V\\17'AB+r<![q.E'-ntA!!!\"HZj-R2>`o.6!%6E[\"=,C+M[QEq-s*;Z,Ud3T%(?<e=-FgR-tMWTV\\1CZk6\\U\"-s*GN^B#`ak6WC^A;:WW![q.%$m[5:!!E9;!9aR/#=/?W\"l'3q!U]sg!*mqR,QK4ENs$^VAA]\\%\"\"76O![K1)-g(OZ=2Q:/-l)d_!.Y)B!!$9p![IanfT-.\\-tN?\"[f\\$[WuiT8A?,dp![q.M+!`6M!!&/a4:hJm>`Jjc!*kfl,QK4ENs$^VAGZtJ\"\"76[(*k;=Ws7_g-s-9X,UaE.#T0!2mK*@g>g<Bj!!!!$!!!!@z!!!!b!!!!X!!!!r!!!\"=!!!\"[!!!\"0!!!!B!<<+e!!!\"+!!!!T!<<,H!!!\"*!!!\"o!<<,s!!!\"+!!!#p!<<*[!<<++!!!\"A!WW3g!<<+,!!!\"W!WW4,!<<*u!!!#6!WW45!<<+!!!!#H!WW4Q!<<+\"!!!#-!!!##!!!!.!rr>m!<<*q!!!#`!rr?!!<<*r!!!#r!rr<Z!WW46!!!!W!!!\"=\"98E&!rr=7!!!!&\"onX$!rr=6!!!\"s\"onX=!rr<t!!!#P\"onY]!rr=2!!!#:#64`9\"98F8!!!!F#QOib\"98F)!!!#+!!!#+!!!\"E#QOj:\"98F(!!!#E!!!#H#QOk#\"98F0!!!!4!!!0($4I%IJlD^M>iH1m!*nLm!!$760E<KQNs%-nA@E,+L^#gh!&urKh]=nl-:%V33#M]UV^):&Lkl6t.f_[oABQ2_UC'9e7)'U*!(`Fe5l^mI57fe:%QHF-Fo)>%3-Fg#355JW1b^asdgYC@1fr]A0JjOF!!$85-ibXINs$j^A:kf8!A%=8#q.?8is+ZJ/6@HB.$OlN!!')(>iH1m!*k*V0E<KQNs%-nA?QWQZNN6<!&urK[g'4G\"?\\174?R/,!rt:u!'$SU!B<%uFc.Y-3-FO!3&l'((HB/14Z\"iLA;^`V!]3u6+##Me!!!\"(_>u't!@QN\\\"=Pg3P7G>./6D!@-nJna+6N\\V=-F+B//A3cbQhbd!!$9`!@RpqfT-.`/7c@%[f\\0__^$W]A@EQA!\\@Eb%4EbC!!&YplN%P.&7gD2!!$8Y!WW4*M?5I3-eOI_0Jm=X,`%6\\3%Ftg3+U2W4R3nO!'l;G5la<.#seOk3'RuG&3+qpQQnIe3&nJN@/r9R)*n8N!WZ+X['Klp.f_OgAFgSDZNNB@!'EASK*)*5)#uWUFg!&M3-G*-32[BP1b^as]+X9.1fqR?0JjOFU]^[&mK+d:-eOI_-nJo@*2aE#=6Bl</7bdc[f\\0_lQ3eA/6D!@-nJoH,j,4[=/uNR//A4\"oE)W*\"CM47ao_VD>b2$G!%6E[\"=Pg3pCucl/6D!@-nJol\"2=jf=47R+/7bX]k5m29k6!+`(''C?^]cY>&/7L5!<<+)rYPV8>g<F*!%6E[\">DZCT-9#H\"un+53&kI+*^$V25l^mE)$&P43)MXpncN;#31h9Y!;Zct;E-YV)F4@](H?\\\"3&l&I&NDamgDDoJ&j8'*1h>VTk5mJAb8;oi('\"=7>abdD!%6E[\"=Pg3QNZIQ/6D!@-nJoP)!:rO=-j'F!A\"ud)!`P8Zi_<F,s_M2!*krp!!$9@\"=O6tfT-.`/7eVq^B#lek6WOfAE+$[!\\@EV&L]1G!#tu4'EG'5>f$[F!*nXh-ibXINs$j^AE+38!A%=8$)\\Ce=6Bl</7c(\"V\\1O^[f\\$0A>^[8!\\@EZ&h#:H!13g%AEtMV#,DB,mKW^l>a>OI!%6E[\">DZC7u2s*3%Ftg3+U2W4SJtE!'l;G5la<.#seOk3'Rt1L^#sl!'EASh]>&/'gVg\"4;e,Y4:F3*L^#sl!'EASh]>%p-:%V34;e,Y4:X>13-D\\N3&l&Q&NH[$4Z\"iLA?Ql,L^#gh!&urKh]=n<,XDD13#M]U3-D8FK*F;\\3&im?cQP8-Fb_A)[f\\cM0Jm=4\"QohC=0EJq1_p&k!$7j=i!'0/fT-.`/7ebbk5m29[f\\$0A?Qm6!\\@FQ\"t2#<!!)p$>DrR_!*nLd!!$9D\"t0I!fT-.`/7aqW[f\\0_?`+Mf=6BnQ!\\@F9$,6Kl=2+ba/7d3T[f\\0_K,WnS/6BRe-nJn]+QieW=-F7F//A4NL]cf@@'1Ht%,:l:!rr=+Jd3t0-eOI_0Jm<q&%&YG3%Ftg3+TK&['Klt.f_[oA:jsa3#M^g(cX6033!3l!'$Gk5le1q!)bd9ru\"*&^E#:Z3&im?T+!\\=Fe^*>k5me'0Jm=P#Nl.F=2t=q1_p&k!*mqW-ibW^\"=Pg3Y6_$=/6D!@-nJoL!TsM8=0DlX//A5i!ruTs#ljs1ncpiK-eOI_0Jm=H(PmkO3%Ftg3+U2W4SK4L!'nRG5la<n*^Kc+3'Rs63-DhY['Klt.f_[oAFh.TZNNND!'ie[K*)*9)#uWY%QHF-Fh]\"X3-BiY32[BP1b^asLC/in\"un+53&kHl,<V_*5la0j*^KcoQOc@^!'!1SLkl6t.f_[oAD\\Fn]-]fD!'D,!3'9\\j3:[>`!'&.K5lg`e!)bd9M\\n_[miON73&im?Y7*BMFe9=,^B$JS0Jm>3\"6T_B=6B`@1_p&k!*ks!liR58fT-.`/7c44k5m29k6\\%!/6D!9-nJo<)7K]!=/uD;!A%=8#q.?8LBH]@/6CjC-nJo<'rMZq=2+ba/7ebh[f\\0_LD_KkAEO-Z!\\@E.\"\"='N('#0O9Z.\"f#2]bRQj*O)_Z9bu#8dLB\\-!RY^EEUT#:7(e!!$9t#q,d$fT-.`/7`t>!A%=8#q.?8mg8.Y/6@$D//A3c_us>^,6.^KQ3o#?-eOI_-nJo\\+K#i'=6Bl</7d'.k5m29k6\\U\"/6?2n!A%<q+t,!QLE*c*/6D-Y-nJop*9RAS=,.bD//A3o!5\\a>!42mR!@[F<!*o@-!!$9T$7Gm%fT-.`/7cL8k5m29b9FCt/6A#F-nJo\\$KhIA=2,_'//A5<*rpW.\"TSO-OpV0h>lG'Y!%6E[\"=Pg3WtW5K/6D!@-nJnq)Wq/Q=3hI,//A5l'F\\\"J!\"9_FmNL3a;@EO*>c%l_!%6E[\">DZCT-M5`^F(6c34]K+!'&\"E5lf=@!)be`ZNN6<!&urKo-UiN\"?\\174?R/,!rt:u!&ur\\UB`b<Fn5es3-Fg%34AuQ1b^aslQ>9k1fp:o0JjOF!!&&\\nd?iG-eOI_-nJoL.(9:0=/uBN/7b@tk5m29a!`>e('\"=7?'5Tr!+uuG!+uiC!*ks$0E<KQNs%-nA@Dk)^CsT$&@Vg&;)gP@$t0,qZNWVp\\dSR:3&nYh5l`l(Fh7f:3-F7+39L?+1b^asV\\S@r1fr!20JjOF!!$9T$n)*'fT-.`/7eVl[f\\0_P7ZmY/6CjCV\\1O^k6WOfAA](q!A%=8#q.?8cO8n;/6D]_-nH.X!Up0kT)kGe!8%?Xc49mT>`&tE!%6E[\">DZCpD5fQ\"&ul63&l&Y$91\"fdhk&(Fk[Tik5me'0Jm=,,3K\"a=5O]G1_p&k!*lrA-ibWF\"=Pg3`tG9_/6CjC[f\\0_]+6;@AH*sR&hI,I#q.?8h\\>5T/6Bk)-nH,6Zj-_n!Lk=D\"oqno$ig94jpa!E-eOI_0Jm>#+geQY3%Ftg3+TK&['Klt.f_[oA:jsa3#M_b-TFs_30\"JW!'#`H5ld2\\!)bd9UC9EgUC]D13&im?dfMKgFn6b9V\\2-L0Jm=<&;Z,H3%Ftg3+Unf4O4X+!!\"tr!/QF84=^Co4ClV[5Z9rK7)p?7!(ajB5l^mI57fe60K_>c%Uf?nL^#gh!&urKb9K.0,XDDqLC$6H7)'U*!!\"uC&<78$;E0Jg\"un+53&kHl,<X^!5la0j*^KcoQOc@^!'!1S3&l&e&3)Xlmi=AIFistKk5me'0Jm>#%d*mM=5+rR1_p&k!*lZ;n,r_=fT-.`/7c43V\\1O^k6WOfAD8?l!\\@EZ+t+uX^]sj!>6OF#!*k6f\"FabZ!!$9T%k%E*fT-.`/7cp-V\\1O^k6WOfA;:BP!\\@Er\"Xko;!5o'A>fmrb!*o4.0E<KQNs%-nAGZC`L^#gh!&urKb9K-i%7'tZ`u[MH7$eEM!!\"uC&;Z,H4=^Co4Cm=j5edjr!!#,!!'!(L30t7;GrRcCFh8YR3-D,H32[BP1b^ascO/h:1fsPT0JjOFO9GVhaq,s$-eOI_-nJo0$KhIA=76=-!A%=8#q.?8qZ5j]/6AkZ-nH,6Jfc79cisIM>j`.W!%6E[\">DZCP738'\"un+53&kI+*^$nW5l^mE)$'CO3&rsSL^#sl!'EASh]>%p-:%V34;e,Y4:X>13-C]$3&l&q-9.n94Z\"iLA=FS%!]3uB$nsLR!/LgZ>e1Lq!%6E[\"=Pg3h]TB1/6AkRV\\1O^k6WOfA<RGb!\\@F1+=JcV!:U0mQN>qTNW\\8Ks8W-!s8W*0nI>O!>iH>D!%6E[\"=Pg3rtDjD/6C\":-nJn]*N'N$=6Bn!\"\"[NS![oU1UD`4r/6Dib-nH,6+QF#8!42k/M?/;N!!$8e&h!`-fT-.`/7b(a[f\\0_LD)'eAD\\-:!A%=@\"Xkp4k6gAR/6A/T-nH,6!#T8i+Qrl;V[!2%>eUgN!*mAR0E<KQNs%-nAEsZu\"ulmh+ZSa\"@/u+>\"un+53&kHl,<S=Z!'nRG5la<>%m^0q3'Rt/'*(oiLkl6p.f_OgABQ2[ZQDI55_fY3!(<.a5l^mE57iX,#!=C94?R/t,=(u45la=5,s_N%j!?tk!'EIW3'7U/3&l&a\"ZSJaZPkg<!Bi7n1h<Wfk5mJArua!P('\"=7>eUk\"Zi_].Ns$j^A<.V+&hI,Q\"ht'h=76;@/7aAQV\\1O^k6WOfAH*e8!\\@FA,Ub2Z!$hPp!>#5R)$#TrKEl8h-.i4u>k/C*!*o42-ibXINs$j^A;;)<!A%=8#q.?8f-J*3/6A_^-nJot';lHo=2+ba/7aePk5m29^D/.J('\"?e!a?3IfEPl=)&0:V9E^.PlR+su!!$9\\(B=G?[M1Cq-eOI_0Jm>7-9.1p<.cGU3-G6,3&l'$+#l6&],N`-&j8'*1h?Ugk5mJARfb?$('\"=7>iHGG!%6E[\"=Pg3f,1t!/6A/Q-nJoL+L_G(=4[j//7bde^B#lemffU%/6D9D-nJnu\"6T_:=/uVF\"=t;g\\,djWV\\8#$+R]=R+S$$e!!!\"(SeWpZ-eOI_0Jm=P+LJHX3%Ftg3+TK&['Klt.f_[oA:jsa3#M]Uo+6C235u\\A!'#TX5lf1F!)bd9lNoiWWs^n43&im?Y9#Y_Fh8,C[f\\cM0Jm>3*'!s*<6G[H!]YHb3&l'(-oa2/Y9l6,&j8'*1h<?^k5mJAo,KG@(')8S!*k6o-idE&Ns$j^ABtOZ&hI,I#q.?8o,Qop/6C.'-nH,6\\-E\"=Jf\"If>c&8j!%6E[\">DZClN+B!\"?7n33&kHX#.1]>4=^Co4Cj'H!&thrLkl6t.f_[oAD\\FngDrQ[!'D,!3'7C)3:7Pj!49'83%Ftg3+VUr['Klt.f_[oA:jsa3#M^J(B@>mLkl6p.f_OgAD\\FjlO?,[!&thr3&l&A*rdQHGrRcCFe^<Dk5me'0Jm=p+Qie_=+^W01_p&k!*l67-ibXINs$j^A?u]Z!A%=8#q.?8q[TM:/6D!@-nJna\"ht'h=76;@/7aA9k5m29LBT(W(AJ\"T\\-?KE(5rFt80@p1#$eGJ!8ml1+92CHU)!_/>iHPJ!%6E[\"=Pg3T,FO>/6D!@-nJp/*p3SU=/ul\\//A3r$k\"&b!ruTW(B=G?NY2<l>`'@P!%6E[\">DZC[g2(.T-#:;31^sq!'%;&5ldc!!)bd9Wu42'h[;Dh3&im?ru3pWFe]7&^B$JSh\\eBmRip<-3-dJC3-E+[3&l'<&icd%4Z\"iLABuL`!]3uf#;@tM!$Id6>hU#C!%6E[\"=Pg3UF*_V/6D!@V\\1O^k6WOfA@Dg,!\\@EB)^m6Q!#Ub)5l`UW!aLHt&-)gB\"TSO-qAB85>`'CQ!%6E[\">DZC`t:;s%TK>A[j=\"Z3&im?Nts]7Fb:Mj^B$JS0Jm>?(ZtiV=5O$41_p&k!*lrM.%gSgfT-.`/7c(#^B#leV\\8.o/6D!@-nJod!TsM8=0iPg//A3cQigLh\"q[4J@/p9->i$>H!%6E[\"=Pg3V]</J/6AkR-nJo`(ZtiN=/R#d//A3c!3?3u)?9bBrY[*a-eOI_-nJne&%;Wl=5+/H!\\@F5&1B)?pCcWj/6Aku-nH,6&.iC8,8:,dJ->oQ>_X'q!*lNB-ibXINs$j^AA\\kS&hI,I$,6Kl=6Bl</7dWTk5m29_[S\"F(')8TL]q&S'*&#;c5J)2-eOI_-nJot%]9pj=6Bn)!A%<q+t,!Qq]3EP/6C\"=-nJoP)s78R=2Q+.//A3coE8A(#lF^6O!Y889E^F\\\";q1>!*k6t!!$8])^k\\6fT-.`/7d?:[f\\0_M[S\\L/6C\"=-nJni)!:rO=4[X)//A66$371/fE2*R>^cYQ>d>;&!%6E[\">DZCgBNEELDY+m35unG!'$GS5lf1L!)bd9M^LdjV[b\\33&im?cNZ?gFg!2Q[f\\cM0Jm=X#)J'>3%Ftg3+U2W4N@^n!'nRG5la=5,s_M23'Rt,'K@?t3//D]!'&FN5lcob!)bd9^C<I/['Klt.f_[oAFh.TZNNND!'ie[K*)*9)#uWY$og4+Fh\\;D3-DhJ355JW1b^aso*FL\\1fqR!0JjOF!0@Fj_Ajs(-eOI_-nJoP\"K)k`=/QZZ/7dcIV\\1O^k6WOfA=EV/\"\"[Nc%k&u>_Zo9*/6C!t-nH8:kQ_(iQidm2([!\"W!.Y(QkQLrkU)a46>lG]k!%6E[\"=Pg3f+kas/6@TE-nJoD'^#NK=4\\08//A3c&AJ5G&H3MT!!!\"(c5clb>c&Mi!%6E[\"=Pg3Rhrg?/6D!@-nJoX-KbF]=6Bl</7e>_k5m29dj?Io('#2l'g]V>!9=/cqA]J8>gaWH!%6E[\">DZC:H8A$<0n(S3-CQ*3&l&5!B<&]gF\"tq!Bi7n1h:*PL^#gh!&urKb9K-='gVgb^DT<;7$eEM!!\"uC&Eafg,WIcX*ao&)L^#gh!&urKh]=nP-:%V33#M^r*WT(t39q>G!&ur\\cR:b4FiOeJ3-E7F34AuQ1b^as]-kW43#h$+^E>L]3&im?dh+Q!FfQWEk5me'0Jm<5k5mJA@k]_T!!!\"8iZ9N/\"\"2`^\"=Pg3UCX78/6D!@[f\\0_Wra\\#A7Od(/6ASW-nH.h!SdkZ-f+k(!*k7#0E<KQNs%-nA?ul(L^#gh!&urKh]=o#\"$lne3#M_^(H=-/33\"'/!'#lQ5lebD!)be`ZNN6<!&urK[g'4G\"?\\174?R/,!rt:u!/QF84=^Co4Cm=j5eA@/!!#,!!'!(N3&im?K,6L,Ff-9?k5me'0Jm>##GVM`)m9_6)E:SR3;+G&!'$;c5lgm+!)bd9mh.nd3&l&5%6-=iRiaVf&j8'*1h;dVk5mJAis.7p(')8V!*ks8-ibW^!@TL0mj@3!/6D!@V\\1O^V\\1C/A>:Q^\"\"[NS![oU1is4`K/6D9e-nH,6`!-oCO9P[bbQ4.W!!$9H+=I4;fT-.`/7aYb^B#leV\\1C/AA\\r@!\\@F9#q.?8[gTYI/6AkR^B#lek6WOfAB,5D!\\@E2,q(;[!0\\_q#$)!H_\\kb!#6=Z(_uYH5!!$8Y+YWmDfT-.h1h=3!VZkBX,<.ZO+^k@1^C<I/U*0M73&n5j5l`l(Fi+;@3-C-&3&l'L\"?<jm4Z\"iLA</,$!]4!1+##Me!!!\"(_BC<-*S?DU-nJp'*kq_,=/QZZ/7aMD[f\\0_M[LpaAChpd!\\@FI*[iQT!!%r]=TFTg!:0^t!!$8a$ig94nf]C]-eOI_-nJp+&>p-l=6Bl</7b@RV\\1O^V\\1C/A>9q'!\\@EF!@TK7!13ce\"2k<R&7jrKS,iUpl663.>bWDj!%6E[\"=Pg3K++Xj/6D!@[f\\0_Wra\\#AB,qX!\\@EJ*%3?R!#WTj5lfOA!+tdG&?Zs\\!!!\"(c6=Y:-eOI_-nJne't48r=/uBN/7c'fk5m29M\\RWk('\"=7e,bj['EEXa\"98F,Sg\".7>kT?i!%6E[\"=Pg3M[$os/6A_^-nJne+6N\\V=,R82//A3ccimPP!!$9D+ohUJ`ZP6]B)ho3>bWGk!%6E[\"=Pg3mg-Z//6D!@-nJod,Nf+Z=8*IY//A3c(`<;RZis_&,QIgL`Zll3-eOI_-nJnu&Z66m=6Bl</7d';k5m29f,5tf('\"?M#C@<+#68#k,6.^Kl6@t_-eOI_0Jm=<%(*>D3%Ftg3+TK&['Klt.f_[oA:jsa3#M^s-9-913&l&Y-oa2/irqD%Fi,1Y[f\\cM0Jm=p.-CXg=-EeA1_p&k!*lNL-icKaNs$j^ABP[r\"\"[NS![oU1P6L+N/6@TL-nH,6(`6e]#64c!!QlYf!*mep-ibXINs$j^A=FX<&hI,I![oU1QNH=O/6A;^-nH,6i!074!=/Z*>b3/?!*o(?-ibXINs$j^AChcu&hI,!!@TL0h]:k]/6@H--nH,6(`7#\"&,ZOU(Hi<0!*lZGM?!VV!rr<$56(Z`zBE/#4zK`D)Q8cShk:B1@pQN.!c<r`4#HiO-H:]LIq:]LIq[/^1,C&e562uipYF8u:@Du]k<S,`NhS,`NhhZ*WVG5qUCG5qUCnGiOhK)blO'*&\"4#lt#+RK*<f(]XO92ZWmYZ2ak)'`\\46B)qu4`rH)>2uipYOT>F^f)PdN,ldoFYlOh)h#IET-3+#G]`A*5kPtS_'EA+5dfBFKnGiOh$ig8-jT,>]qu?]sH2mpFqZ-Zs-NO2I.0'>J:]LIq:]LIq<<<.#9*#\"m(]XO91&q:S1&q:S1&q:ST)num=TJL&'EA+5[/p=.HN=*H'`\\46q#UNrK`M/R)ZTj<%0HS1S,iTiGlRgE3s,H_WrW2#'*&\"4-ia5I-ia5I-ia5I?NU9.[fHI/&c_n3E<?1@_>sW::&k7oLB@MVirK,[K`D)QaTDMCmK!:f:&k7ohZEiYq#LHq'EA+5o`G0o$j$D/(B=F80E;(Q0E;(Q*s;QD/cl\"QG5qUCnc/Xinc/Xi.KBGK.KBGKB*827=on[((]XO9[fc[2D#s\\;'EA+5h#m]XFTMOC%fcS0+ohTC+ohTCnH8glJcYoP'*&\"4#6b)-U&k;pGlRgE7g/kmWr`8$'EA+5=Tnd*`W?,?G5qUCNs,L`cN4(HK`D)QT`kDrkQ1_a('\"=7dff^Oo`>*n0`V1Rm0*IirW3'\":&k7orriB&$3L8.!<<*\"(]XO9(]XO9)[69B6j!Dh)?9a;2?3^W2?3^W2?3^W2?3^WP6M!e<s&F&M#[MU'EJ16&cht4&cht4&cht4\\HW$6EruCBH2mpFklq+fP61dbKE(uP.0fhQ\\cVp4'EA+5G6\\*JgB.EU)ZTj<49,?]8cShk8cShk^BX`=qZ?fu'EA+51]RLU1]RLU1]RLUrs&N($NpG0!WW3#)$g3B('FU;%KHJ/0*hOX3!93](B=F8EsMaGEWc@BKE(uP2?3^W2?3^WlNdIjL]d\\X'EA+5'+\"X=P6:jc'`\\46.1#tS_?9i=LB%;SLC!q\\d0'FL&c_n3V$R,%r<**#(B=F8r<WH(\"pFu,!<<*\".KBGK.KBGK'++^>1^*jZ)#sX:1]RLU1]RLUD[HIE6j3Pj0E;(QM[BFaBa\"J:$ig8-)?9a;)?9a;fa7]ZGQe'I'*&\"4?iU0,?iU0,pBgm#L'7PW(]XO9%gr@;Ws&J''`\\46=UP30\\HMs5)#sX:FUJ0L`WZ>B'EA+5NsbpfkQLqd'*&\"4dgH-Unc]!n-ia5Ik6h7irriB&H2mpF!=Sr.%L)n5HiO-Hq>^Kqp](9o#QXo*#QXo*-O]tT)[69BM#[MU3=Glf1^3p['EA+5CCC1C56_)fH2mpFJIDMY8d57qD#aP9QOEio<!E=&'*&\"4Wset.D$Bt?GlRgEoDejkoDejki=#\\dGm46KLB%;SoaCg#K*D;UG5qUC-ia5I-ia5I-ia5I%h/L=P6M!e'`\\46/-#YM+oqZDnlGek>kTNF!*fkI!%6E[\"Di$fRi.$<#';?qFED':,C'(l5lc;I)*n7Q!LF<_!!%+*&9NOMIrocj@/tD)#seP`!)dopL^%rO!-E<nh]@$S-:%V3F;Y(#FENWmFEDY`,'7pLlPjrD&j:2ME+I-9k5oU(Ir''>!!!\"(C:FKK-eOI_A8#Ms*2aE_=6Bm#BOlVU!bbZY*+W^u!3?D*>kTNF!*kB^C]Gj8Ns'9<AEsAn\"`t]=&9N#:q\\=3pFn[/'FEQIeFQW]gE,9K(mfBf%\"EZ-oFED'&#.1]>GUic=G[uF/!-B(YLD4hjFEDVIQO%\\TFl+BbFEObkFLM?8E,9K(]-ZVAE*'LgCiC-i!!$9`!Fu0X]EMhZA@i;[\")(c:!b>tT[iFQ4BNMeTA8&1J!!!#l!VRno#?_$+s8W-!rsqa&!*o4F!!$8]!b;9YfT-/GBOp-2k5o<uk6Y[4A@iK;!bbZq$Y3od!#7nAQimBh>h0\\k!*lZ.A,n\"0Ns'!,A;:E)!GGQt$\"R^[q]iiVBNOd4[f^;F]+:ePBNOd4A8#NJ\"m5r#=8O4QBGLSu!Sd_2!J^^Vcj!a00L5@W5l^lb>k/+\"!*ndjA,n\"0Ns'!,A;:3K!bbZu$+C\"M=8*D>BOoj![f^;FWtN/JBNO@'A8#N6#j28&=6Bn!\")(cZ+(T%qq[o_=BNMYEA8#MW*9RB:=5sQsBGLS5],$M0O9,SR=1e^T!WWc3/-#c7!!$8a%fcT7^&qmG-eOI_A8#NN#.F\\J=/uC5BOoj&k5o<uV\\<TS('$bC,s_M2!3$\"]1B7D[iWE]k-eOI_A8#M_-KbGD=189BBOpET[f^;FWrcgFA?-g8!bbZE-=gd*!!(XPHe\\c='P-A3!!(FJW\\OPS>`o5+!%6E[\"Di$fisKm\\,ZM5eP:1NuFEDVI^E.K=Fe]jsV\\2.3CiEqb*9RBB=,Ru5E#&ER!*m5@YQ4_OfT-/GBOn\"ck5o<uk6\\U\"BNNA!A8#MW\"K)lG=6Bm#BOm#>k5o<uV^#_c('$2G)8ZFP#P\\B$>c%f-!*nppA,n\"0Ns'!,AG[.O\")(c*,j,5B=8O=TBOoj)[f^;Fb9*VpBNLB3A8#Mo*9RB:=6Bm#BOm/.k5o<uk6\\U\"BNNA!V\\3ZENtPu:A?-F-!bbZi$=mfc!71h[\"-ile4NAC,E.eJf'SHLc!rr=*cisIM>ad2tq^\"N.!!$8m-ia6Pc38\"a-eOI_CiEq.#f@F\")q-%`%s3)=FEDZW!d&O,mg=07&j:2ME+Gjnk5oU(T,)6^('\"=7>l\"V7!%6E[\"Cu1V_[E@TBNMYEA8#MG(?Ya4=+^e:\"DAPNquZq+4CgQbLB7GU>il(f!*l6&A,n\"0Ns'!,A@Eqq\")(bs&uQ@U=186ABOm_T[f^;FLD+33A<.&+\")(d%*iBWa=-!u)BOoR4V\\3ZEq^,ieA?Qm6!bbZE%V05g!'C70!!)cr)E^,EAD7Ql\"TXVb'^,`$9K;A@!'L;^!*l6O!!$:##%R]]fT-/GBOl`>[f^;FWrcgFA=Ee$&nkA4#%VCXP7m$[BNLZ-A7u_YTECel5l^lb;#245!*lB+A,n\"0Ns'!,AH)tF\")(c:!b>tTO!WrjBNLN*A7u_Y#h&lA!!!\"JOt$G3>fm:^!%6E[\"Cu1VY6_lDBNP'XA8#NF\"2=kM=6Bm#BOm/Dk5o<uY6\\ZP('$c##@t\"R!;$G\"dP1_%>kSD=!%6E[\"Di$fP6Zo\"#';?qFED':,Bskf!.<fQ5lcE9j!?tk!-CF:di<HcFEFqs@/u+>#';?qFED':,Bt:r!.9P.5lcE9LC$6H!-CF:ap7uFFGP_WF=R?5FCa8MGRHe;!-B(YLkl7[.fag=ABQ3Fk79iYJ,tE35lcQ=`u[MH!-g^>FEe:;FEDZ[!H`F+ZO1fP&j:2ME+Hurk5oU(pBbYT('\"=7>_38m!%6E[\"Cu1Vb7D&aBNL6-A8#NJ$0MA'=0i]RBGLRg6u`2h!(R\"h!*n5,!!$9($#BShfT-/OE+HEqj!AddT-)A_FEqtMFENWSFEDZ+$$<WY4`G4VA@E<>(3CMq)9WD0H$\".MFo*8&FER<YFLM?8E,9K(T,6YlE*'L`CiC-i!!&AemKmD((talPA8#N**p3T<=6g(\"\")(bk'4bce[j\\ulBNO@'A8#N2-bf[q=6g(\"\")(cJ%qK?ab7gcdBNO@'k5o<uV\\3NRA@E<:!bbZY'4bbl!5J^c5P,'YVufP,/AqU7^Dd07\"'hu\\!!$9<$=j,afT-/GBOoR7^B&\"Lk6Y[4A?Q'D\")(bk'B]F1=6BWqBOpu[k5o<ulP!fB('\"=O5:cer!^N[f!,Po7,QIgLnd915-eOI_CiEqV'8VGKF=R?5FCa8MGe5:g!!%*Y!-E=*rrS\"4#'_WuG^*cB,CHO/5lcE9j!?tkKE:*Z5l^n057hp]%Wlf7Fl+-[FER$jFM@i>E,9K(rrqQeE*&q<CiC-i!!$9D$Y5%q-eOI_A8#M+&#U%R=6Bm#BOmG;V\\3ZEq^#cdA>]Ik!bbZ%$Y3od!;$Hl#XJHH\"TVfE&HDf9ndAt.-eOI_A8#NB+h%Pe=/uD;!GGQt$\"R^[T-NM#BNLZ?A7u_Y4IZL?!!%ZS4N\\lK!*ks$C]Gj8Ns'9<A=!aIiu:t4!d&O,HZX@P^E[iBFjgM9V\\2.3CiEp_($>X;=$(5;('\"=7>fI1_!%6E[\"Cu1VpD^\"CBNP'XA8#Mc#,`)I=-!u)BOj3f!bbZI\"u'^+!.Y2;A?Q[9\"/@),!!!\"(MA-$j>kSS:!%6E[\"Cu1VY6j@nBNO@'A8#M_&[qjU=,.H\"BOnj\\V\\3ZEP7-OTBNMYFA8#M7&a'4/=0Dp@BGLS-Nse8?!oO.\\#I\"F5'L*93N!:%7(`6f0*<6(El4O's>eUYX!%6E[\"Cu1V`tG9_BNO@'A8#M3+Qif>=5O6nBGLRJ&3g`%\"oqob!rr=+iXKDu-eOI_A8#Mc.(9:l=/uC5BOp-*k5o<uk6Y[4AH*t=!bbZq\"(Z'\\!'n.36(@uV!+1H^!!$8a%Vu+mfT-/OE+JPPLkl7W.fa[5ABQ3BV[YolI)d9o!.Y*:%m^0qF?^=YX!@^fFO)$tFEG5,@/tE<'L;`=%KKCKFH7\\5!-E=*rrdFcFi+Q.^B$K:CiEp+k5oU(ZQj:*('\"=7>iH6(!%6E[\"Cu1Vs!Qt2BNK+_BOm_CV\\3ZEk6\\U\"BNM59A8#M[,Nf,A=8sXYj9?A\"KE_E`PQJW(!3Q?k('\">>Oq2('-eOI_A8#Ms%_i$X=6Bm#BOm_`[f^;F]+8FcACh(L!bbZ--tI!,!'EB;!J^^VfEY[<%0-B5^(4`S-eOI_A8#Mg&Z67T=6Bm#BOp]Nk5o<u_ZXL`('#cG#seR<\"oqp%\"sBB=5l^lb>`'6r!*ne\"A,n\"0Ns'!,AA8J\\\")(c6)5e*\\=8O<,!bbZu$\"R^[o-;!NBNO@'A8#N&&%;XS=/uC5BOo^<V\\3ZEk6\\U\"BNKs&k5o<uq^#cdA@EK?!bbZM$=mfc!#Q7tX99fA!`/m`\"#u/=\\-E!6=3;*T!*m5LC]Gj8Ns'9<A?Qf*L^%rO!-E<nh]@$##seOkF;Y(#Rh,UBWs*T\"FEHXV@/tDu,=)<]&HG^NLkl7W.fa[5ABQ3BV].o%I,cM=!.Y*:%m^0qF?^=YFEPV*FEDZW&9PA`4`G4VA<S\"r!cV5E(Mn%+!!!!TSe5K5-eOI_A8#M;%-I\\*=6Bm#BOn:_k5o<uP71u8('$T\"&C:O[i!+Nn!!$8i$nUQJ5l^lb>f$XE!*me]C]Gj8Ns'9<AB,RDL^%rO!-E<nb9M8\\#seQ=^DT<;J,tuI5l^n,57j/!F?+GbFEQ=WFEDZW(3FY@iuE0U!BkC<E+J8YP6@d+,BS$j&n(c^pE)[$V@il,FGP_WF=R?5FCa8MG_6r$!!%*Y!-E=*RgjI]Fn6>iFENoVFM@i>E,9K(MZi2EE*)'<CiC-i!!$9D&nJKR-eOI_A8#N\"%AshP=8O:SBOp-Ak5o<ucOFF7!>Y[B\"Xmob(+d3,5l^lb>j<g>!*nq)A,n\"0Ns'!,ABt:S&nkA0$\"R^[s!$V-BNMMcA7u_Y*/be&!/(@Q>i#tk!*k[#A,n\"0Ns'!,ACgjs!GGQt$)\\DL=6Bm#BOo.(k5o<umhKAH(''s45Zb]GfE739>e17B!*m)KA,n\"0Ns'!,AG6M1&nk@q$tO$^q]Y,(BNM5ZA7u_Y%gZ7s&?#`T#=/=i!*kC.1rg=s!!!\"(ndGKu>j;u5!%6E[\"Cu1VWs#m6BNM59A8#N2.-CYF=18WLBGLRfRfu(X!!%>J.f]QSNYH:0-eOI_CiEpS\"*C\"H<9GF6*ct8$FLi/p!/QF8F=R?5FC`Q>G_6;g!.;g.5lcE9QOc@^!-CF:_@uuJFEEum5lc\"KFo)tsFEO&_FM@i>E,9K(Rj.\"sE*'@nCiC-i!!$9\\'P,\\p-eOI_A8#Mc(T.mZ=7Zd^!bbZu$\"R^[b6b'ZBNO@'A8#M[-g(PE=1]8ZBGLT0\"N)BKPQ?^F!*mr-!!$8a'k@:lfT-/GBOo9n^B&\"Lk6Y[4AG7G6!bbXOA7u_Y,ki9E!!%fY>e1FG!*lfEC]Gj8Ns'9<AH*F$L^%rO!-E<nb9M8l!^Qg6^DT<;J-!D&5l^n,57j/'FEqtMFEQ%AFEDYl-$46OpCMH0!^1L=E+Hj,k5oU(o*fGS('\"=7>kSnC!%6E[\"Cu1VT*`75BNL6-A8#NF%-I\\*=48'uBGTe9O9P\\l5X8RbLB7GU>e1\";!*l*2A,n\"0Ns'!,AD[fn&nkA0$\"R^[LF20cBNOL;A7u_Y9MB!_\".08m>eVuo!*mAVA,n\"0Ns'!,A>:@3!bbZu$\"R^[pEujOBNLB*A8#MK%AshP=8O:SBOnk(^B&\"LmfhkUBNM)EA8#NN*iBWa=76<'BOl_u[f^;FWrg$:BNO@'A8#NJ+m/o?=8O%LBGLSq+CqYhYQDQG5lgBX^B[%)/@QcgbQ\\%q5Ni+J\\,jDH`[1Zc>c&<J!%6E[\"Cu1VZOFSLBNO@'[f^;FWrcgFAGZkG\")(d1'^#O2=6Bm#BOm/Jk5o<uq[R.M('#LGFgM8OhuO>I.f]QSg)\"9\"-eOI_A8#MG't49Y=-!u)BOl`&k5o<uT+tmM('$Gs#64`(>lHGX!*oL>A,n\"0Ns'!,AH*+J\")(ahA8#M[#IaeK=8)lr&nkA0$0MA'=5sj&BOn.Tk5o<urs`LP('\"X',I7CRn,^`<iW6Oj!!$8u#64a/[MWf\\-eOI_CiEpW\".LY#'I%X@ar\"OeFOLsj!7D\\a;KR#=\"$lp/FER<qFEDYX%Wlf8V\\aHQ&j:2ME+GjYk5oU(hZI\\6('\"=7>k/_R!%6E[\"Cu1VgB>7lBNN(hA8#Mo&AJ6Z=6Bm#BOp!&k5o<ugB;&#('$%1AA9&`^]e!2*rl:GSf)>E-eOI_CiEp?%!8[!<5THXZNPM'!-ia![g'4G\"FM^\"I!fIW!s!Q`!-EGoFEDVImiZ^oFh\\]6k5mecCiEpg'^#O:=5+O-E#&ER!*n@uA,n!-\"(Z(UcR-+'BNMeVA8#N*,.@Yf=,.H\"BOp!)[f^;Fb9,mKBNO@'A8#N.(Ztj5=5O3mBGLS1T-lsu#66GB&-0'@U]E;/1pI(r)`W`q5l^lb>j_t\"!*lB>A,n\"0Ns'!,A@j&K!bb[$-GKRp=,Rr,BOo:6[f^;FT-Rr\\A?-ZY\")(c:!iHZE=6Bm#BOp9;k5o<u]-:d!(''s6qug'1\"C1OG5l`3=E<#u<57gf8!Did'\"9@0WatNeq>k/eL!%6E[\"Di$fNsq?kRj`B#FG:`C!-G7F5lcoa!)do\\k7Ku[M[acRFEDVIY9J(1FjDFWk5mecCiEq\")!:s>=-j81E#&ER!*lZGA,n\"0Ns'!,AFBT_!bbZu$\"R^[QO;mWBNOX(A7u_];#;(qp]UWt>fn]\"!*mqkC]Gj8Ns'9<A>^_qf,[iN!LF:<H$\".MFd\"%lFENKRFJfa7E-0tC<7;).L^&)S!-ia!h]@12,=);0GSpL'GReh;FEQm^FEDZ+*d\"jn4`G4VAA8Q9!cV6$'Pq_(!!!\"(U)_qh!/(C*Ns'!,A=\"A#!bbZu$+C\"M=3D[rBOpEG[f^;FWrcgFAE+Be!bbZ%*b8q\"!)2Dg3nsf;!5JWp+TMLIdN!''-eOI_CiEq6-FC)^F=R?5FCatY['Km[.fag=A:jsaF;Y)Y!H`U/FEC6H!d'SG@/u+>#';?qFED':,C&eb5lc;m,s_N]!TPIl!!%+*&?[#R;KR_N#';?qFED':,C$6o5lc;Q*^KdV!QQ6I!!%+*&9N#:NrsKGFgEE:[f\\d4CiEq>#j28.=48L4E#&ER!65,_*Fo-tfT-/GBOn\"ak5o<uk6Y[4ACDmg!bbZ5+_57%!'$#K6!sZm>imU<!*nq4C]Gj8Ns'9<AEOu?ZNPA#!-E<no-UiN\"F)EsG^*bO!s!E\\!5f:g3HT@bFfu?uFEPb/FEDZO(3J^@4`G4VA@E68!cV4n-u<i<!!!\"(Xr_*R-_L]TBOn.ak5o<uP8'o-BNMYEA8#M;$GQUT=-F?]!bbZu$\"R^[lNam$BNMeTk5o<uV\\3NRAD7m/\")(c:!b>tTK.,maBNOL)A7u_Y!&RIC!st>!EL[&7!),'H!(iad!!$:'*c(g(fT-/OE+GRB]*WQuQP00.F>7lZQ60N8FO)7!!1k84;KR$(%7'u9FEOc-FEDZs!d*T,4`G4VA@j5P!cV5a+`)*5!!!\"(\\fYG_-eOI_A8#NJ+Qif>=6Bm#BOm/IV\\3ZEhZDsBBNO@'[f^;Fb9(8.ABQ.Z!bb[0+Co.$U]iI8#smVSqujV64no-[!*meh1lE>>!'$GO5l^lb>acN1!*oLFA,n\"0Ns'!,AG6qU!GGQt$+C\"M=/uC5BOoF7[f^;FpCuclBNO@'A8#MG\"m5r#=3i.&BGLR[#aYSe\"TZmR1\\qmf!*lfPA,n\"0Ns'!,AFgqY!GGQX,%P@tcQ9OtBNM59A8#MS-g(PE=7[PFBGLT/,Q%UE^B\"<7V#e\"<!!$9\\+D_$*fT-/OE+JDAFLrGjitZZX9nO[4p)mcDFGD&+!<+)@;KR$T$:+Z6FEOnmFEDZ3#'B#04`G4VAChLX!cV5%!c2fk!!!\"(RNZ2A-bojqBOp]@^B&\"Lq^&]RBNMeVA8#N.*2aE_=6Bm#BOl`/[f^;Fb9(8.AA8E5!bbZu$\"R^[NrnJGBNOd3A7u_Y.\"DL[Y7iJ%#sePF^B['_!Ao]Jg]7CW!*nXs!!$9d+`%-+fT-/OE+Fk2Lkl7W.fa[5AD\\GQiuUJd!-B(YFN54eFEErq@0![@\"EZ-oFED'b(::CNGUic=G[uF/!-B(YZ6B9HFL8@WF=R?5FCati['Km[.fag=A:jsaF;Y(#FEPJ>FEDYX&Ti,;QPO\\@&j:2ME+JDC['KmW.fa[5A@DcMZNPM'!-ia!K*)*q)$$QTF?+HMZNPM'!-ia!o+n^>\"FM^\"I!fIW!s!Q`!-EGqFEDVI\"*AX-mhp5V\"$LU>E+J\\ak5oU(M[\"!:(''-k!*k[3A,n\"0Ns'!,ABte$!GGR+$F^+N='qj<BNO@'A8#Ms*N'N`=6Bn!\")(c:!l\"bL=6Bm#BOm#*k5o<ucOXQ\"g&V2p#AAPdcioL3K)pi>5_C4G!!!\"(l5]j)>h1-9!%6E[\"Di$fo+#l_+]O4BY7>Z\"FEDVIP9G$iFi+o8V\\2.3CiEp[+QifF=.9J3E#&ER!*k+$;ue;uNs'!,AD7a3!GGQt$\"R^[RgA0YBNLf?A7u_YWu=6)M^AGB#$d0F!!$9$,\\-m&fT-/GBOo:#k5o<uk6Y[4AB-(\\!bbZi\"(Z'\\!#uthcQ+-d*'jQMRfu*Z!WW4*mKrpo>gam6!%6E[\"Di$fK-dn2\"EZ-oFED'b-FC)^GUic=G[uF/!-B(YLkl7[.fag=AD\\GUcP&SE!-f@]FEe49FLMEBFEF*#@0![@\"EZ-oFED'&#.1]>GUic=G[uF/!-B(YVBl4?FEG\\85lc\"KFiOW,FER$aFLM?8E/9;SF=R?5FCa8MG`NM(!!%*Y!-E=*lPB@)FEqtMFENWYFED[\"&Tkbg4`G4VAG6Vt!cV4n-#@N9!!(LMecFnZA,n\"0Ns'!,A<S(L!GGR#-=ge#K-f[^BNLN&A7u_Y=Ml:J!!&r&=TAF%>bW,:!*kO2A,n\"0Ns'!,A@j\"_&nk@U\"(Z(UVZZ)`BNO@'A8#N\"\"Qoi\"=/-dHBGLRJ\\-.-i&.iBU'?CE:*'jQAZNrje#98@;5l^lb>e1@E!*mYnC]Gj8Ns'9<ABPmuZNPA#!-E<no+n^>\"F)EsG^*bO!s!E\\!-E=*dh?hu+%:9nJgXt,Lkl7W.fa[5AD\\GQo,'an!-B(YMC/C%FEE9]5lc\"KFiP2<FEQ%DFJfa7E,9K([g[AR!`[btit6BYFEDVIK-YP\\FmB``^B$K:CiEq2\"6T`)=18TSE#&ER`!'D[-^4c7-eOI_A8#NJ#cA;K=6Bn!\")(c:!b>tTo,ZuqBNLB*A8#Mc#j28&=8O:SBOnR\\k5o<uo,V@T('\"=7HDh&K5^VPm#QQ[7+92CHqBoeR-eOI_A8#N2\"LeJH=/uC5BOnRsk5o<u`s-'f('\"I;\"+UCP!1X)d+#LG/5l^lb>j;Fl!*lBLC]Gj8Ns'9<AA\\J)L^%rO!-E<nh]@$S-:%V3F;Y(V(j(%F['Km[.fag=AFgSDZNPY+!.90)K*)*u)$\"c'#'=t\\-t*+3L^%rO!-E<nb9M9',!c3V`u[MHJ-!\\35l^n,57mfB!)do\\gD*!SFEDZC\"a\"j/k88=(!^1L=E+Fk8k5oU(M[+';('\"=7>ad*P!%6E[\"Cu1Vmgll0BNNA!A8#MW($>X3=/Q[ABOq,T^B&\"Lk6Y[4A@E*4!bbZQ).[DkM[/DHBNOX5A7ua?\"?<FlC]FGd5I^puKE6FY!W[1EZ5<QA>i$o?!%6E[\"Cu1VNuR6`BNMYE[f^;FWtJrVAChX,\")(c:!b>tTk76YVBNL66A7u_YoE,)N!MBTY4Cj3K5e@dt!!!\"*U)*e0>a?jU!%6E[\"Di$frt;]F\"EZ-oFED'b(::CNGUic=G[uF/!-B(YUCqZoFGP_WGUic=G\\#\\QI/=jK!!%6]!-EGoFEDVIK*$.:FdF@qV\\2.3pD%chUCqZjFk7\"CFEN3KFEDZS)g&Ok4`G4VAG[M4!cV6@'Pq_(!!!\"(qC6\"U-eOI_A8#M/(:OBZ=.:IGBOpiU^B&\"Lit,a7A@DTS!GGQt$\"R^[rtOVtBNOpHPQ>GS!!')))#sX:J,ooU]EMQC+92CHZ7BGc-eOI_A8#N&%d*n,=-F#&BOo\"/[f^;FWrcgFAGZVp!bbYr(M%1p!$L/G5l_T!@g\"3h,!c2/!!8TA49,om!!$9H\"TSO-mOMfJ-eOI_A8#Mc%-I\\*=6Bn!\")(cZ+(T%qT,t`JBNO@'A8#M7+6N]==1\\lOBGLS%Rft%\\\"oujN>`Jpe!*l*HC]Gj8Ns'9<A<-bX(N^V6$$:8`RgjJJ/7AO#gEf,c^+97^FEH+Z5lc\"KFe]apFEPn<FJfa7E,9K(mi6GY,ui>:FEDZ_(UkH-H$\".MFoMhkk5mecCiEq6)<V'?=8N)9E#&ER!*o(GA,n\"P!G#kSNs`W&BNP'X[f^;FLBh@'AD8<C!GGR3-=ge#mfU<*BNO@'A8#NN\"6T`!=-!^$\")&GMk6\\p)L]PO+[f]$\"k8!k?cj!SK,QRTC>adJL!*lf]A,n\"0Ns'!,AA]P!\")(c:!b>tTNtA3%BNO'mA8#NF-)VAh=2PndBOmG5k5o<uo-Ip\\('%Hp*'jSO#Fbl_!!!!AU*p!A>j<nO!%6E[\"Cu1V]-FceBNNA!A8#M[$+C\"M=.:J5&nkA0$\"R^[LCr\\NBNMejA7u_Y4Ne.Z!5Jg>kQ*pK!*nqG!!$8q/o1M8fT-/OE+J,ZLkl7W.fa[5ABQ3BT+XEiI)d9o!.Y*:%m^0qF?^=YM^SUJFEDZg%!6T6lP4M`Fdj\"c[f\\d4CiEqF*H\\=k<8/R<FEOc+FEDZO$$:93mgsTU!BkC<E+JhKk5oU(QRHZh('\"=7>l$'`!(#7u\"Cu1VWt2*@BNOL([f^;Fb9(8.A=\"_-!bbZ9%qLJ#('(9<LDM<<0Z+_n!!!\"(h@fkh>c'/b!%6E[\"Cu1VT*E%2BNMYEA8#MG+Qif>=8rhBBGLTL\"9;dk4L>0#LB7GU>i#M^!*mf&A,n\"0Ns'!,AD8B=\")(c:!b>tTUCP$>BNP'XV\\3ZEk6Y[4ACCal\")(c:&nGZdY9E'1BNLr=A7u_YO9OPD57llW!;cdf!!!Y3!WW4*MD/Q@-eOI_A8#NB%CZFQ=8)l/BOnk%k5o<uk6Y[4AD83(&nkA<$GQUT=6Bm#BOl`Ck5o<uVZp[F('%&&,=);=:iXhaTEigG&-)^s#?44o!*meg!!$9L0Ot/2fT-/GBOq,`k5o<uk6\\U\"BNM)7A8#N:''B=0=8s:OBGLRJ!94*I!<<+)nh=k[-eOI_CiEq6&p/mP<:^9LL^&)S!-ia!h]@0s#seOkGSpL'GRS\\9FENKBFEDYh)g&Ok4`G4VAB,ML!cV5=,&D36!!!\"(XtaGeRfV0&\"Cu1VLD@Q)BNL6-A8#MO,3K#@=0E-FBGLU2#s_S(+3u's#?SML!!$9P,6.^KehL\\8-eOI_A8#NJ!iHZE=7Zd^!bbZu$\"R^[k6pGSBNOp0A7u_Yg]sT!6%B/5_]_;G!!$9l)?9bBJhgj:-eOI_A8#MW+27hi=6Bm#BOp9F^B&\"L[fU)RA@Dp/!bbZu)e<Ut!!3!!E<$!3#@+DH!!$9,11UA4fT-/GBOo\".[f^;FWrg$:BNO@'A8#Mo,3K#@=-\"),BGLRbM]>\"_!8n'j!Tk$q!*n)1C]Gj8Ns'9<AEOW`'6G1k$G-UdH$\".MFdEMYFEP&*FJfa7E,9K(lO2kWE*)39CiC-in,`SpJhpp;-eOI_A8#M[!k/8F=/uC5BOm;;k5o<uV\\5m?BNO@'A8#MO$+C\"M=,.H\"BOp9>k5o<uV]TG_('%%_*^Kdb\"[G;Z\"9A?)>=8GkJcWjr!!$9@1LpJ5fT-/GBOll>V\\3ZEo*T#AA-_9!BNKs1A7u_Yg]C;_VZKi`#XJFj!*mep!!$9h1LpJ5fT-/GBOn.GV\\3ZEo*Vr/BNOL@A8#M;!TsMt=/uF6BGLU'!<=o<!!$98&GH>n=-FoA%mX4>('\">>NY;Bm>b3c_!%6E[\"Cu1VK+$iDBNOL(V\\3ZEk6Y[4AA\\YM&nkA0$\"R^[P6RotBNO@'A8#MO$g.S)=+^lkBGLTl#95rVJ-*@fHQ[tD!*m5R#64`(!rr<$'*&\"4z.0'>J,QIfE/-#YM9)nql/-#YM.f]PL>6\"X'70!;f.0'>JN;rqY>lXj).f]PL2uipY^An66WrN,\"/-#YM#QOl-\"ptWm9E5&tZ2jq*>RD;J-eOI_(`[(M$b$3X=/uB>*+[5:k5lW)P7&3I('\"=7I'NbQ!*guj!%6E[\";i+hDmofg=/uD#&fb!9$,6K\\=6Bl,*+\\pmk5lW)D\\sH0!71l$\"4@4U!<<+);A]B]fT-.P*+YNV[f[UOM[L@AAEtT*!ZY:2)&O>/!<**$jT,nm!*jO]!%6E[\";i+hcQK+u**9$N(`[)L#3Q%-=3i!+*#8OA\"J65k!!!\"(rWE3$>a>C-!%6E[\";i+hY6r#F**;;0(`[(]'^#N;=0DrJ*#8MScj\"+_!!$94!>keafT-.P*+\\@<[f[UOWra+XA<RM$&fb!5&AJ5c=3Dd)*+Yfjk5lW)P7AEL(''EsKE>\\>*Tm_7,R=AM?fh@h!*ndi(]Yr9Ns$:>A;:WW!ZY;)$,6K\\=3Dd)*+XsAV\\0tNk6VtFA<Rbk!ZY9s%2^'#!!(LL&YK9:!ruSl!WW4*RK=<+-eOI_(`[)@&Z66]=3Dd)*+Z5mV\\0tNV\\8.o**;;0(`[)(,ej@\"=3Dec&fb!9#oFXmLDd!&**:St(`[(A#IadT=47Qp*+[e6k5lW)LBeY9('\"U?*fpW:\"UJZ%,M3,!J,oeW\"-3gUn-6f7\\-H.:#a,3s!!!\"(Z38hc`WH2?s8W-!rsuOK!!$:'!Z1nbfT-.P*+YrMk5lW)b9FCt**:l'(`[(e''B<9=/Q0<*#8M_!(4*r\";#+%('\">>V?6eu>cIlC!%6E[\";i+hP9RI<**:l,V\\0tNV\\0gdAE*sY!ZY:*+rD:8!;lj/]`HRj!!$9L!rr=+dK:<d-eOI_(`[(Y)Rfeg=77=M*+YfH[f[UOQPJZb**;;0(`[)T#Nl..=.^BJ*#8P;#nUqb&5I01!WW4*ecYsQ>_W@u!%6E[\";i+hT-:*F**;;0^B#<Uk6VtFAD\\0#&faur+rD;1[jL8>**;#5(`X:kfEMUlo-F5:S-E6p!WW4*[KIEI-eOI_(`[(i+QieG=3Dd)*+YB=k5lW)Y94Z%('\"@,\"+/)n!!$8U\"98F,g&r5m-eOI_(`[)H%AsgY=6Bn!!utCC!l\"aU=6Bl,*+Y6Nk5lW)ischF('*P!p]GfA\"TSO-Jcutk-eOI_(`[(=($>W<=6Bl,*+YfM^B#<Uk6VtFA<Rhm!ZY9o'c7o+!!iQ98,rctOoZ-G\"[N+g!*i85!!!!$!!!!>z!!!!^!!!!R!!!!T!!!\"1!!!\"'!!!!U!!!#0!!!\"G!!!!T!!!\"4!!!\"4!!!\"4!!!$!!!!\"T!!!!T!!!!4!<<,Y!!!!S!!!#<!<<-\"!!!!U!!!!\"!WW3A!<<*U!!!!`!WW3J!<<*V!!!!r!WW3`!<<*T!!!\"I!WW3o!<<*U!!!\"g!WW4:!<<*V!!!#R!WW4E!<<*T!!!#h!WW4e!<<*V!!!!R!rr=o!<<*U!!!!d!rr>?!<<*T!!!\"Y!rr<&!WW3T!!!!0!!!$,i(a7P>a>j\"!*fjN!%6E[\"<8Opq^&-Q+BR_4[f[aSWra7`ABQ1[![(SA,oe$C!&+C2Q4<lp>V79%-eOI_,Ud30+I<]l)i#Zu+tS!j/1br8*\\8jblNJiS!BhhV-tMWJk5m&5f-hmm('\"=7>Zr,C\"\"2`^\"<8OplQEqC+BR_4*$AeD.-CXS=6gtK+;OqW\\-6-'%KHK6H5lo4fT-.T+Cp6L[f[aSpCeMhA?QW\\!?bJ,$)\\CY=6Bn!\"!C[G!ZW=npC=)6+BPHR*$Ada,j,4O=6Bl0+Cqqmk5lc-UEpm&('\"=G=TIdi&8M(g'^#N`W!!5;o)Sjd\"/H)=L'I\\Y>fm'm!%6E[\"=,C+LCJkI//sp'_[J(N/1g2i@/u+>\"tV8)/1b>h*\\dU!5l^m9)$'@2!)b@!b7[)@/1bq%!\\>mFk8Z%f!BhhV-tK@sk5m&5LCGLW('\"@,\"C.)k)uqA=Ns$FFA;:E)!?bJ,#ok'uq]i!O+BQ`1[f[aS]+5l(AA][j&g19=#ok'uY8k:X+BPHR[f[aS]+5l(AD7^Z![(S-$)\\CY=47Qt+Cp6:k5lc-q]d('(''9s#[*WA!.Y2C#e1!&-UGr[VumS4!\"d?V1p[p1!*npo!!$9p![IanfT-.\\-tN&dLkl6d.f_+OABQ2Oo,Bsq1qsno!'$;U5l^m957f@s&!J+eSc`C$/E6as!2]hu;CjB\"-p[ha/9S9?/1brD%P0/Rmi*gU&j7Wg-tK@[k5m&5pCnl$(''-p!*mMG)uqA=Ns$FFA;:i-\"!C[G!ZW=nRj>`L+BQ`1*$Aed'^#N?=.:HT+;Oq_j9&q^,6._7!T\"5!k6XES)#GUF!!!\"(h?s;`>lFgF!%6E[\"<8OprtW!F+BQ`1*$Ade\"6T_.=3DF#+;OqclR+sug]\\6?!!!\"(rW`E'>c%WD!%6E[\"<8OpZQ-FV+BPTF*$Adq+QieK=3Dd-+Cp65k5lc-M\\7!P('\"?=!F#[0\"D!-&!8mr`X9JY)q>l0O!!$9X\"<7ChfT-.T+CpZP[f[aSWrf13+BR_4*$AdU)<V&D=0D]G+;Oqg&8M(g'[mIV!3cY-!M0St!*k6^,QK4ENs$^VA@E&)L^#C\\!%][3b9J^-)aOH\\LC$6H30t.A!!\"Q7&;LB>3@l_r\"[ssn`W]cN['Kld.f_+OAFh.TZNMs4!&-*;K*)*))$&Ls!)bATZNMg0!%][3o-UiN\">D>+0JI$i!rski!%][DcPe>cFX&HH\"$J%X-tJMSLkl6d.f_+OABQ2Odj79[1rgY'!'%_25l^m957mi5/9rctZO92Q/>`V[!49'8/1U]O/7e>f['Klh.f_7WA:jsa//\\H%\"oqOP['Kld.f_+OAFh.TZNMs4!&-*;K*)*))#u3=FlOi#/9TPH/>j+D-mU3O[fkjq-s*#],UaE.!!$9X\"rmX0!SEG9*$Ae4(;Bkm=6Bl0+Cr(hV\\1+Rk6W+NA=jn*![(Rn,j5FT('\"UGA=Fg>!<>Xr!/L\\]Z3pX4>`&b3!%6E[\"=,C+q[\\L=\"tV8)/1b>T,;@j_5l``s#sePNQOc@^!%^>G/FsJT/1`>p`sXFLFd!7c/9TDW/AD3K-mU3OZQ831-s-9V,UaE.!9=Aic3G<h-eOI_*$AdY!P\\XX=5si3+Cq)T[f[aSWrf13+BR_4*$Aeh&*F!:=2tXf+;OqWU]Oa'\"Io[,K,N/A!'Q>N!!$8U#TNglfT-.T+CqetV\\1+RV\\6`F+BPHR*$Ad]$g.R6=0ihc+;OtL\"Fp_fZP<H?>c%c,!*lN0)uqA=Ns$FFAH*L]!?bJ,#ok'uV[2Ge+BS\"J*$?!s'^#cg!#YSZ5l^o+\"C-*M!*mqX)uqA=Ns$FFA<-l&\"!C[G!ZW=nhZ^Ik+BQH+*$AdU+6N\\J=5O0$+;OqWPQQ@?!!(CImK*@g>lG!K!%6E[\"<8OpZPU@W+BR_4*$Aeh'B]E>=6B`,+;Oq['LMj#e-B7D%fcT7U'W(F-eOI_,Ud3@&=4Cg)hS>G/9Q^Z/1bqm-nHolM]F@H&j7Wg-tLL3k5m&5QR3t+('\"=7>g<Z:!rs_$Ns$FFA@EGS&g199&@V`a=8*Bk![(S-#ok'uQR:ks+BQ#i*$?!sli@f^!UL$k!*o4(!!$:##oipmfT-.T+CsXV[f[aS_^$3EABPY$!?bJ(&>p-`=5si3+Cs(FV\\1+Rk6W+NA>:4/![(S-*ZQ:<!!%NOp&P<O#CltgK,KIL!*meT!!$94$7#U!fT-.\\-tL4B['Kld.f_+OA@DcMZNMs4!&-*;K*)*))#u3=Flsmf,V1Z$/FEjR!/QF8/1U]O/7dWZ0Z+Mh!!\"Pf!;6a\";CjA'5l`GeFlO,d/9QR\\/AD3K-mU3Oh^@Rg-s+\"f,UaE.!!$8e$QK-ofT-.T+Cq)j[f[aSWra7`A@i33![(RJ(`\\>7('#&`!C6\\c!%n$Q!!$94$QK-ofT-.T+CqAaV\\1+RdgYC@+BR_4*$Ae\\$g.R6=/Q`P+;Os-#O<a'VuoR%!WW3#>_3Cb!*nLk)uqA=Ns$FFAD[j*\"!C[#)&sc0a!eD!+BPTF*$AeL,j,4O=5OH,+;OqW&.JUN&8M(g!!!;1$31'2OpiT9-eOI_,Ud3((T/N0)t+Q7)_?7c/1bqq#V7NLdf_5:!BhhV-tJeak5m&5Wu!$0('\"?u!F3>I)uqA=Ns$FFAG62(&g19=#ok'uWu'q#+BS:>*$?!sPQZXA>6k3/>fHdE!*nLl)uqA=Ns$FFA@DlC&g19=#ok'uNs4\\J+BQ#Y*$?!soDnq_#QOj0q?$]t>_W\\5!%6E[\"=,C+s!<JW\"tV8)/1b>T,;A.#5l``s#sePNQOc@^!%^>GQQIb=/>EG$Gq:KtFdF(!/9UD#/@P^E-mU3Oh[qEO(f]N>/1bqE&M,JUZOSN;FftfsV\\2-@,Ud3@'B]EF=8sQl-l)d_!'T<N)uqA=Ns$FFA@j7f&g18b!urFoF125o=3D[*+CtKuk5lc-irbqV+;Oqg&7i*^KE:6B5l_c!,u4L@&6Su5!*n(X!!$8m%NGHrfT-.T+Cq5\\V\\1+Rk6W+NAA]VS![(QW*$?!s\"98P.!i,hs>e1CF!*m5J)uqA=Ns$FFA;_#.\"!C[W&&/,f=5si3+Cs(:[f[aSgC1gt+BR_4*$AeL*9RAG=,RV0+;Oq[YQ56s,7'eC\\cDd2!*kg#!!$9t%NGHrfT-.T+Cs(/k5lc-k6W+NACi0k![(Rr#94j%!!MQt@GCqb!*mYW%(@EH!!!\"(Sdtf$>bV`K!%6E[\"<8OpV\\$<>+BO=9*$Adu,,Z%r=6Bl0+Cqr#k5lc-V[sgj('\"=;U&b8D\"oqp!%KHK6c4:lp-eOI_*$Ae$)Rfek=/uBB+Cqr'k5lc-[i-5/('\"=7&>B:-!*nq&)uqA=Ns$FFA<R\\9\"!C[C\"<8OpmgS@\\+BOa?*$?!s!!!o;g]HOCs8W-!s8W*0UB:W!!!!*$!!!W3z!!$I.z!!\"ML!!\"PM!!%lV!!!0&!!+F(9)nrs;?-]%$4Hn^fT-.D&7kYa^B\"mIk6\\%!&6J$$$kQsm,3K\"==8O9P&/G8=!GG_9!!$7V$ih[-Ns#k&AFg/;!t\\P7!XoWNlNZMR&6JH1$kO0S!!#_kP68/qs8W-!s8W*0XTAJ&>Z(P%>ZM75-eOI_$kQsm*2aD\\=3Dcr&7iC!^B\"mIk6VP.A;^_k&eJ.)&.B+\\M]([Z&6Fbq$kO0Sli[<=!<D0alN0?P!1X6uM?*\\W>`Jgn!%6E[\":PiPUF#()&6J$$$kQsQ$F^*K=.^B>&7j*0k5l2rY6k[L('\"=;T`G,n!,(3n\"onW'",5.0));if not not m[22606]then S=(m[22606]);else S=(m[12384]-m[0X5eC9]-m[12384]+m[22932]-m[27756]-31);m[22606]=(S);end;else u6=nil;break;end;end;local a=function(U)return{[i]=function(f,q)local Q,k,v,g,h,s=q,0.0,49;repeat if v==49.0 then v=(92);g=(1.0);else if v~=92.0 then if v==11.0 then(f)[q]=(s);break;end;else h=(U);v=0Xb;while h>0.0 and Q>0.0 do local U,f,q=h%16.0,Q%M,(91);while true do if q>91.0 then g=g*16.0;break;else if q<126.0 then k=k+u6[U][f]*g;h=((h-U)/16.0);Q=(Q-f)/16.0;q=126;end;end;end;end;s=k+(h+Q)*g;end;end;until false;(u6[q])[U]=s;return s;end};end;X=(nil);local M,h6,L6;S=0X18;repeat if S==24.0 then u6=J({[0.0]={[0.0]=0.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0},{[0.0]=1.0,0.0,3.0,2.0,5.0,4.0,W,e,9.0,8.0,11.0,10.0,13.0,Y,15.0,14.0},{[0.0]=2.0,3.0,0.0,g,6.0,7.0,4.0,5.0,10.0,11.0,8.0,9.0,14.0,15.0,Y,13.0},{[0.0]=3.0,2.0,g,0.0,7.0,6.0,t,4.0,11.0,10.0,9.0,8.0,15.0,14.0,13.0,Y},{[0.0]=4.0,5.0,6.0,7.0,0.0,1.0,2.0,v,12.0,13.0,14.0,15.0,8.0,9.0,10.0,w},{[0.0]=5.0,4.0,W,6.0,1.0,0.0,3.0,2.0,13.0,Y,15.0,14.0,9.0,8.0,11.0,10.0},{[0.0]=6.0,7.0,E,5.0,2.0,3.0,0.0,1.0,14.0,15.0,Y,13.0,10.0,11.0,8.0,9.0},{[0.0]=7.0,6.0,5.0,4.0,3.0,2.0,1.0,q,15.0,14.0,13.0,12.0,w,10.0,9.0,8.0},{[q]=8.0,K,10.0,11.0,Y,13.0,14.0,15.0,0.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0},{[0.0]=9.0,8.0,11.0,10.0,13.0,12.0,15.0,14.0,g,0.0,3.0,Z,5.0,4.0,7.0,6.0},{[0.0]=10.0,11.0,R,K,f,15.0,12.0,13.0,2.0,3.0,0.0,1.0,6.0,7.0,E,5.0},{[0.0]=w,10.0,9.0,8.0,15.0,14.0,13.0,12.0,3.0,2.0,1.0,q,7.0,6.0,5.0,4.0},{[q]=12.0,O,f,15.0,8.0,9.0,C,11.0,4.0,5.0,e,7.0,0.0,1.0,2.0,3.0},{[0.0]=13.0,12.0,15.0,14.0,9.0,R,11.0,10.0,5.0,E,7.0,6.0,1.0,0.0,3.0,2.0},{[0.0]=14.0,15.0,12.0,13.0,10.0,11.0,8.0,9.0,e,7.0,4.0,5.0,2.0,3.0,0.0,1.0},{[0.0]=15.0,14.0,13.0,12.0,11.0,10.0,9.0,8.0,7.0,6.0,5.0,4.0,3.0,Z,1.0,q}},{[i]=function(U,f)local q;for Q=0X4A,0xb7,12 do if not(Q<86.0)then if not(Q>74.0)then else(U)[f]=q;return q;end;else q=J({[0.0]=f,[f]=0.0},a(f));end;end;end});if not not m[853]then S=m[853];else S=m[6033]-m[3198]+F[8]-m[6290]+m[6781]-0X6AFe2483;(m)[0X355]=S;end;elseif S==23.0 then X=(A and A.bxor);if not m[31920]then S=(((m[0X11b7]+m[0x1892]<m[0x283f]and m[0X3060]or m[3198])~=m[0X43aA]and m[27580]or S)-m[0X7cDb]+21);(m)[31920]=(S);else S=(m[0x7cb0]);end;elseif S==10.0 then M=({6,0X004,0X7});for U=0.0,15.0 do J(u6[U],a(U));end;if not m[26703]then(m)[0X3962]=F[0X5]+m[24265]-F[0X8]+m[0X1F01]+F[0x9]+341591789;S=(m[18885]-m[22606]<m[4535]and m[0x7Be6]or F[0X4])+m[0X19b8]+F[9]-785738990;m[26703]=(S);else S=(m[26703]);end;elseif S==97.0 then h6=next;if not m[26969]then S=(m[18885]-m[0X584E]-m[0X7cdB]-m[27580]-m[0X49c5]+199);m[26969]=S;else S=(m[26969]);end;else if S==76.0 then L6=X or function(U,f)return u6[U%r][f%r];end;if not m[17124]then S=m[22932]-F[9]-F[4]+m[0X355]+m[0X43AA]+785738903;m[0X42E4]=(S);else S=(m[17124]);end;else if S==59.0 then break;end;end;end;until false;local f,v,C={},A and A.lshift;S=(125);while true do if not(S<125.0)then if S>56.0 then if not m[0X30F3]then(m)[16822]=F[7]-m[0X6C6C]-m[25101]+m[27158]-m[10303]-4147068412;m[19869]=((m[21483]~=F[5]and m[0X7Cb0]or m[4039])+m[7176]-m[31963]+m[26969]-0X3A);S=((F[0X7]+m[0X283F]+S~=m[0x5994]and m[0X1791]or m[0X42E4])>=m[0X7CDB]and m[0X19b8]or m[0x283F])-17;(m)[0X30f3]=(S);else S=(m[0X30f3]);end;end;else C=({[p]='v'});break;end;end;local t,O=A and A[j];S=(0X15);while true do if S==21.0 then if not not m[0X7258]then S=(m[29272]);else S=((F[4]<=m[2682]and m[0X6C6C]or F[0X1])+m[0x77E3]-m[0X355]+m[6584]-34538);m[0X7258]=S;end;else if S==112.0 then v=v or function(U,f)if not(f>=V)then else return 0.0;end;local q=0X31;while true do if q==49.0 then q=0x5C;if not(f<0.0)then else return t(U,-f);end;else if q==92.0 then return U*v6[f]%r;end;end;end;end;if not not m[20951]then S=(m[20951]);else(m)[17738]=(m[6033]<=m[0X7CB0]and m[0X43AA]or m[17322])-m[19869]+m[0X5994]+m[0X4d9d]-0X33;S=((m[0x7CDb]<m[0X1c08]and m[0X684f]or S)-m[0x1791]+F[0X007]-F[9]-4041404848);m[0X51D7]=S;end;else if S~=15.0 then else O=(nil);break;end;end;end;end;Y=nil;local w;S=(0X67);repeat if S==103.0 then Y=(function(U)s6=(U);y=1.0;end);if not not m[29729]then S=m[0X7421];else S=F[0X9]+F[0X1]-m[27580]+m[0X49C5]-m[3198]-0x64cD43D;m[0x7421]=(S);end;elseif S==26.0 then w=4.503599627370496E15;if not not m[0X7f0c]then S=m[0X7f0c];else(m)[0X2efb]=((m[0X00620D]>=m[0X7258]and F[5]or F[0X1])<F[0x5]and m[0X355]or m[0X4D9d])-m[0X684F]-m[0X1A7D]+140;S=(m[3198]-m[7937]-m[0XA7A]<=m[31718]and m[31920]or m[2682])+m[0X7BE6]-66;m[0x7f0C]=S;end;elseif S==49.0 then t=t or function(U,f)if not(f>=32.0)then else return 0.0;end;local q,Q=(54);while true do if not(q<54.0)then if q>29.0 then if not(f<0.0)then else return v(U,-f);end;q=0X1d;end;else Q=(U%r/v6[f]);return Q-Q%1.0;end;end;end;break;end;until false;local v,t,V,Z;S=(0X28);repeat if S==40.0 then v=(function()local U=H(s6,y,y);y=y+1.0;return U;end);t=function()local U,f,q,Q;for k=1,162,41 do if k<=1.0 then U,f,q,Q=H(s6,y,y+3.0);else y=(y+4.0);break;end;end;return Q*1.6777216E7+q*65536.0+f*256.0+U;end;if not not m[0X00581e]then S=m[22558];else S=(((F[2]+m[0x3060]<m[29272]and m[31963]or m[6033])==m[0X041b6]and m[0X07258]or m[6781])-m[0X5ec9]+99);m[22558]=(S);end;else if S~=103.0 then else V=(1.0);Z=9.007199254740992E15;break;end;end;until false;local A,a;S=(11);repeat if S==11.0 then A=(tostring);if not m[24805]then m[7424]=(F[6]-S-m[0X11b7]+m[3198]<m[20951]and m[6781]or m[6033])+5;(m)[27743]=(m[0x7cb0]-m[6781]-m[17124]-F[0X9]-F[0X7]+4252732466);S=(((m[0X581e]<=m[0X7258]and m[27756]or m[25101])>m[17322]and F[9]or m[0X49c5])+F[0x1]+F[8]-0X06aFeaBBB);m[0X0060e5]=(S);else S=(m[0X60E5]);end;else if S==110.0 then a=function()local U,f,q=t(),t(),0X00e;while true do if q<21.0 then q=(0X15);if f==0.0 then return U;else if f>=B then f=(f-r);end;end;else if not(q>14.0)then else return f*r+U;end;end;end;end;break;end;end;until false;I=function(...)return(...)[...];end;local p=function(U,f,q)local Q=f/v6[U]%v6[q];Q=(Q-Q%1.0);return Q;end;local E=function()local U,f,Q,k=(0X33);while true do if U<118.0 then U=(118);f,Q=t(),t();k=(g);else if not(U>51.0)then else if not(f==0.0 and Q==q)then else return 0.0;end;break;end;end;end;local U,q,v=p(21,Q,11),(-0x1)^p(x,f,0x1),p(0.0,Q,0X15)*2147483648+p(0X1,f,31);if U==0.0 then if v~=0.0 then U=(1.0);k=(0.0);else return q*0.0;end;else if U==2047.0 then if v~=0.0 then return q*q6;else return q*o;end;end;end;return q*2.0^(U-1023.0)*(v/w+k);end;local q,x,o;S=(49);while true do if S<92.0 then q=(function()local U,f=0.0,1.0;repeat local q=H(s6,y,y);U=(U+(q>127.0 and q-128.0 or q)*f);f=f*128.0;y=y+1.0;until(q<128.0);return U;end);x=(L);if not not m[20018]then S=(m[0X4e32]);else S=(((m[22932]-m[18885]<m[32524]and m[0X4d9D]or m[0X007258])>m[6781]and F[0X6]or m[0X0053eB])==m[0X581E]and m[0X11B7]or m[0X1A7D])+0X4A;m[0X4e32]=(S);end;else o=(function()local U;for f=63,0Xce,0X44 do if f==0x83 then return U;else if f~=63 then else U=q();if not(U>=w)then else return U-Z;end;end;end;end;end);break;end;end;local H,w,Z;S=(0X6d);while true do if S~=109.0 then if S==104.0 then w=(function(...)return n("#",...),{...};end);Z=(type);break;end;else H=(function()local U=q();for f=0X0069,0x96,5 do if not(f>105.0)then y=(y+U);else return N(s6,y-U,y-1.0);end;end;end);if not m[22505]then m[16436]=(((m[0X355]-m[0X1a7D]==m[0X77e3]and m[0X355]or m[0Xa7a])-m[32524]<=m[14690]and F[0x1]or m[7937])-0X8683);m[28163]=(m[0x3962]>m[0X454a]and m[22558]or m[12027])+m[6781]-F[1]-m[7937]+34562;S=(m[0X1892]+m[0X7Cdb]-m[22606]<m[26969]and m[0X4d9D]or m[0X1892])+F[0X5]-1347784907;(m)[22505]=S;else S=m[22505];end;end;end;U6[15486]=(f);local p,W;X=(nil);c=(nil);j=(nil);K=(nil);S=(74);repeat if not(S>101.0)then if S>0.0 and S<30.0 then X=(nil);if not not m[0X57e7]then S=(m[22503]);else S=(m[22606]+m[27580]-m[0X60e5]+m[0x0355]-m[26703]+0XE5);m[0X57E7]=(S);end;else if S<12.0 then K=function(U)for f=0X35,0XeF,96 do if f>53.0 then return U;else if not(f<149.0)then else if Z(U)~="\116ab\108e"then else local f;for q=103,247,0x22 do if q>103.0 then for U,q in h6,U do f[U]=(q);end;return f;elseif q<137.0 then f=J({},{[i]=U});end;end;end;end;end;end;end;break;elseif S>12.0 and S<33.0 then c=(function(...)return(...)();end);if not m[3595]then(m)[0XBEe]=m[26703]+F[0X3]-m[2682]+F[0x09]-m[26969]-3201589090;S=(m[22606]+m[0x584E]-m[0x41b6]+F[2]<m[22505]and m[31718]or m[0X6c6c])+95;m[3595]=(S);else S=(m[3595]);end;else if S>33.0 and S<101.0 then p=function(U,f)local q,Q,k,v,g=U[0x6],U[2],U[4],U[5],(U[1]);local h,L=(J({},C));L=function(...)local L,C=w(...);local I,j,H,Y={},(Q6(k));for U=1.0,Q do(j)[U]=C[U];end;if not v then C=(nil);end;local k,v,t,O,x,V,c={[2415]=U,[0X6C83]=Y,[27345]=f,[8588]=j,[16368]=h,[0x41F6]=q},1.0,1.0,Q+1.0,1.0;local U,Y,M,o=u(function()repeat local U=q[x];local q=(U[0X5]);x=x+1.0;if q>=0X40 then if not(q<96)then if q<112 then if q<0X68 then if not(q>=0X64)then if q>=98 then if q==0x0063 then j[U[0x7]]=Q6(U[4]);else j[U[7]]=j[U[6]]<=j[U[0X4]];end;else if q~=0X61 then if j[U[6]]==j[U[4]]then else x=U[0X7];end;else if not j[U[0X4]]then x=U[6];end;end;end;else if q<102 then if q~=0X65 then j[U[0X6]]=(j[U[0X4]][U[0X3]]);else j[U[0X4]]=(ctx);end;else if q~=0X67 then local f=(U[6]);j[f]=j[f](f6(f+1.0,v,j));v=f;else repeat local U=({});for f,f in h6,h do for f,q in h6,f do if not(q[2]==j and q[0x1]>=1.0)then else f=(q[1]);if not not U[f]then else U[f]=({j[f]});end;q[0X2]=(U[f]);q[0X1]=1.0;end;end;end;until true;return;end;end;end;else if q>=0X6C then if q>=110 then if q==0X6f then j[U[0X6]]=j[U[4]]*U[0X3];else(j)[U[0X4]]=rawget;end;else if q~=109 then j[U[6]]=j[U[7]]<j[U[0X4]];else j[U[6]]=(setfenv);end;end;else if not(q>=106)then if q==0x69 then local f=U[0X7];j[f](f6(f+1.0,v,j));v=(f-1.0);else j[U[0x4]]=(z.n);end;else if q~=0X6b then j[U[6]]=j[U[0x4]]/U[0x3];else repeat local U={};for f,q in h6,h do for q,q in h6,q do if q[2]==j and q[1]>=0.0 then f=q[1];if not not U[f]then else U[f]=({j[f]});end;q[2]=(U[f]);q[0X1]=(1.0);end;end;end;until true;return true,U[0X4],1.0;end;end;end;end;else if q<0X78 then if not(q>=116)then if q<114 then if q==0X71 then local q,Q=U[0X1];local k=q[3];local v=(#k);if v>0.0 then Q=({});for U=1.0,v do local q=(k[U]);local k=(q[0X2]);local v=(q[1]);if k~=0.0 then Q[U-1.0]=f[v];else Q[U-1.0]={[1]=v,[2]=j};end;end;(k6)(h,Q);end;k=p(q,Q);s(k,(b()));j[U[6]]=k;else if j[U[4]]~=U[0x2]then x=(U[7]);end;end;else if q~=115 then local f=U[0x04];local U=t-f;f=I[U];for U=U,t do(I)[U]=nil;end;c=f[4];H=f[0X1];V=f[0X3];t=(U);else j[U[6]]=(j[U[7]]..j[U[0X4]]);end;end;else if q>=118 then if q~=0X77 then(j)[U[0X6]]=j[U[4]]^j[U[7]];else j[U[4]]=(tonumber);end;else if q==117 then(j)[U[6]]=j[U[4]]+U[0X3];else j[U[7]]=U[2]<U[1];end;end;end;else if not(q<124)then if not(q<0x7E)then if q<0X7F then local f=(U[0X6]);j[f](j[f+1.0]);v=f-1.0;else if q~=0x80 then j[U[0X4]]=U[0X2]<=j[U[7]];else local q=(f[U[7]]);j[U[0X4]]=(q[0X2][q[1]]);end;end;else if q~=125 then repeat local U=({});for f,f in h6,h do for f,q in h6,f do if q[2]==j and q[0X1]>=1.0 then f=(q[0X1]);if not U[f]then(U)[f]=({j[f]});end;q[0x2]=(U[f]);q[0X1]=(1.0);end;end;end;until true;local f=U[7];return false,f,f;else v=U[0x4];(j[v])();v=v-1.0;end;end;else if q<122 then if q==0x079 then j[U[0x6]]=(j[U[0X7]]-U[0X1]);else local f=U[7];local q,Q=c(H,V);if not q then else j[f+1.0]=(q);(j)[f+2.0]=(Q);x=(U[0X6]);V=(q);end;end;else if q==123 then j[U[7]]=ui;else j[U[0X07]]=({});end;end;end;end;end;else if q>=0X50 then if q>=0x058 then if q>=92 then if not(q<0X5E)then if q==0x5f then j[U[0X007]]=(client);else local q=(f[U[6]]);local f=(q[2][q[1]]);(f)[j[U[0X4]]]=(j[U[7]]);end;else if q~=0X5d then x=(U[0X7]);else I[t]=({[0X4]=c,[0x1]=H,[0X3]=V});t=t+1.0;v=(U[0X004]);c=(j[v]);H=j[v+1.0];V=(j[v+2.0]);x=(U[0X6]);end;end;else if not(q<0x5A)then if q==91 then j[U[7]]=(entity);else j[U[6]]=unpack;end;else if q==0X59 then local f=U[6];(j)[f]=j[f](j[f+1.0],j[f+2.0]);v=(f);else(j)[U[0X4]]=(j[U[6]]%U[3]);end;end;end;else if not(q>=84)then if q>=82 then if q==83 then(j)[U[0x4]]=(#j[U[0X06]]);else if j[U[7]]then x=U[4];end;end;else if q~=0X51 then local f=U[0X4];local q=(j[f]);local Q=U[6]*100.0;for U=1.0,v-f do(q)[Q+U]=j[f+U];end;else j[U[0x6]]=(j[U[7]]>U[0X1]);end;end;else if q<0X0056 then if q==0X55 then repeat local U={};for f,q in h6,h do for q,q in h6,q do if q[0x2]==j and q[1]>=1.0 then f=q[1];if not U[f]then U[f]={j[f]};end;(q)[2]=U[f];(q)[1]=1.0;end;end;end;until true;return false,U[6],v;else j[U[4]]=U[2]-U[0X3];end;else if q==0X57 then j[U[0X6]][U[1]]=U[3];else local f,q=U[6],(j[U[7]]);(j)[f+1.0]=(q);j[f]=(q[U[1]]);end;end;end;end;else if q>=0X048 then if q>=0X4c then if q<78 then if q==0x4d then(j)[U[0X4]]=j[U[6]]~=U[0X3];else(j)[U[0x4]]=(j[U[7]]);end;else if q==0X4f then(j)[U[6]]=(error);else(j)[U[0X7]]=j[U[0x4]]-j[U[6]];end;end;else if not(q>=0X4a)then if q~=0X49 then v=(U[7]);j[v]=j[v]();else local q=(f[U[4]]);local f=q[0X02][q[0x1]];(j)[U[0x6]]=(f[j[U[7]]]);end;else if q~=75 then local f,q=U[0X4],U[6];if q==0.0 then else v=(f+q-1.0);end;local Q,k,g=U[7];if q~=1.0 then k,g=w(j[f](f6(f+1.0,v,j)));else k,g=w(j[f]());end;if Q==1.0 then v=f-1.0;else if Q==0.0 then k=k+f-1.0;v=k;else k=f+Q-2.0;v=(k+1.0);end;q=0.0;for U=f,k do q=q+1.0;j[U]=g[q];end;end;else(j)[U[7]]=(require);end;end;end;else if not(q<0X44)then if not(q<70)then if q==0X47 then(j)[U[7]]=j[U[0X4]]~=j[U[0X6]];else j[U[4]]=z.Z;end;else if q==69 then(j)[U[4]]=j[U[7]]<U[0x2];else(j)[U[0x6]]=loadstring;end;end;else if not(q>=66)then if q==65 then(j)[U[0x4]]=U[0X2];else local f,Q,k,v=U,0x4,(U);k=k[Q];Q=(U);local g=79;while true do if not(g>89.0)then if not(g<=54.0)then if not(g>=89.0)then v=0x5;Q=(Q[v]);g=((U[0x4]+g-g-g<=U[0X6]and U[0X4]or g)+0X57);else Q=(U);g=((g-g-U[6]>g and q or U[7])-g+179);end;else Q=(U);break;end;else if not(g<=98.0)then if not(g>=115.0)then v=(7);g=((U[4]-g+g==g and U[0X6]or U[7])>=g and g or U[7])+105;else Q=(Q[v]);k=(k-Q);g=((U[6]+g-U[0X4]<=g and U[6]or q)+q-20);end;else k=k-Q;g=(g+g-g~=g and g or q)-q+0X59;end;end;end;v=(5);Q=(Q[v]);k=(k+Q);g=(0X1F);while true do if g~=31.0 then if g==114.0 then k=(k-Q);g=((U[6]+g+U[0X6]==g and U[7]or q)-U[4]-12);elseif g==41.0 then Q=U;v=0x7;g=(g<g and q or q)-U[6]+q+q-0x42;elseif g~=116.0 then else Q=(Q[v]);break;end;else Q=q;g=(q+g+U[4]>U[6]and g or g)-g+114;end;end;g=(0x4);local h=(5);while true do if g>4.0 then Q=(U);break;elseif g<19.0 then k=(k-Q);g=(U[0X6]+g+g+g+g-0X7);end;end;v=(5);g=54;while true do if g<54.0 then k=k+Q;break;elseif g>29.0 then Q=Q[v];g=((g-g-g-g~=g and U[0x6]or g)+0x13);end;end;Q=U;g=0x3d;while true do if g>119.0 then Q=(Q[v]);g=(g+g+g+U[0X6]-g-0X83);elseif g<120.0 and g>61.0 then k=k+Q;break;elseif g<119.0 then v=5;g=(U[0X6]-g+U[0X6]-U[0X6]<g and U[0X6]or U[7])+110;end;end;Q=U;g=0X34;while true do if g~=52.0 then if g~=3.0 then else Q=(Q[v]);break;end;else v=4;g=(((g+g<g and U[0X4]or U[0x6])<=g and g or g)+g-101);end;end;k=k-Q;Q=(0X36);k=(k+Q);(f)[h]=(k);g=115;while true do if g>54.0 then f=(j);g=((g+g+g-g~=U[0X7]and U[4]or g)+43);elseif not(g<115.0)then else h=U;break;end;end;k=0X7;g=(0X8);while true do if g>8.0 then if g==122.0 then Q=U;break;else k=(j);g=(g-U[6]+q+U[0X4]-U[4]-3);end;else h=h[k];g=(U[0X4]+g+U[7]+U[0X6]<q and U[4]or g)+60;end;end;local s;v=0X6;g=(31);while true do if g>31.0 then k=k[Q];break;elseif not(g<114.0)then else Q=Q[v];g=((g-U[7]+g~=U[4]and q or g)-g+0X51);end;end;Q=(j);g=0X2C;while true do if g<=27.0 then v=v[s];g=(((g~=g and U[0X6]or U[0X7])+q>g and q or g)+U[7]-0Xc);else if not(g>44.0)then v=(U);s=(4);g=((g+g<=g and q or U[7])+U[6]+g-37);else Q=Q[v];break;end;end;end;k=(k<=Q);f[h]=(k);end;else if q==67 then local f=U[0X4];v=(f+U[6]-1.0);(j[f])(f6(f+1.0,v,j));v=(f-1.0);else repeat local U={};for f,q in h6,h do for q,q in h6,q do if not(q[2]==j and q[1]>=1.0)then else f=q[0x1];if not U[f]then(U)[f]=({j[f]});end;(q)[0X2]=(U[f]);q[1]=(1.0);end;end;end;until true;local f=(U[7]);return false,f,f+U[0X4]-2.0;end;end;end;end;end;end;elseif not(q<0X20)then if not(q<0x30)then if q<56 then if not(q>=0X34)then if q>=50 then if q~=0x33 then local f=(L-Q-1.0);if not(f<0.0)then else f=-1.0;end;local q,Q=U[4],(0.0);for U=q,q+f do(j)[U]=C[O+Q];Q=Q+1.0;end;v=q+f;else local f,Q,k,v,g,h=0X5,0X3C,(U);while true do if Q==60.0 then v=(U);Q=(((U[0x7]>=Q and Q or q)<=Q and Q or U[0X7])<=U[7]and Q or U[0x7])+q+0X1b;elseif Q==107.0 then h=0x7;v=v[h];h=U;Q=(q-Q-U[7]==q and U[7]or Q)-U[0X6];elseif Q==78.0 then g=6;break;end;end;h=(h[g]);Q=15;while true do if Q>15.0 then if v then local f,q,Q=0X74;while true do if f==116.0 then q=U;f=67;elseif f==67.0 then f=(0X46);Q=(0X6);elseif f~=70.0 then else v=q[Q];break;end;end;end;break;elseif Q<34.0 then v=(v-h);h=(U);g=0X5;h=(h[g]);v=(v<h);Q=(((Q<=U[7]and Q or Q)-U[0X7]<Q and Q or Q)<U[7]and Q or Q)+0X13;end;end;if not not v then else v=q;end;h=(U);g=6;Q=(0X56);while true do if Q==86.0 then h=(h[g]);Q=(((Q+Q+Q<Q and Q or U[7])>Q and Q or Q)-25);elseif Q==61.0 then v=v-h;break;end;end;h=(U);Q=0X37;while true do if not(Q<42.0)then if Q<55.0 and Q>1.0 then h=(h[g]);v=(v-h);Q=(Q-Q==Q and U[7]or Q)-Q+U[6]-0x1C;elseif Q<108.0 and Q>42.0 then g=(0x6);Q=(((q<=q and Q or Q)>U[0X7]and Q or U[7])-Q-U[0X6]+71);else if not(Q>55.0)then else v=(v+h);break;end;end;else h=(q);Q=Q-Q+q+Q-Q+0x0039;end;end;h=(U);Q=8;while true do if Q<17.0 then g=7;h=(h[g]);Q=((((Q-U[0X7]<=U[0X006]and U[0X6]or Q)<=Q and U[6]or U[0X7])<=Q and q or U[0X7])+42);elseif Q<122.0 and Q>17.0 then v=(v-h);Q=(q+q-U[7]+Q-q+0X1d);else if Q>71.0 then h=U;Q=(Q-Q+Q-Q-Q+0X8b);elseif Q<71.0 and Q>8.0 then g=5;break;end;end;end;h=h[g];v=(v>h);if v then local f,q,Q=76;while true do if f==76.0 then f=(0x003b);Q=(U);elseif f==59.0 then q=5;f=(94);elseif f==94.0 then v=Q[q];break;end;end;end;Q=0X5F;while true do if Q==95.0 then if not not v then else v=(q);end;Q=(Q+U[6]==q and Q or q)+Q+Q-0xbf;else h=q;break;end;end;v=v-h;Q=(50);while true do if Q==50.0 then h=0x3B;Q=((Q-Q-Q>Q and Q or Q)-U[0X6]+84);else v=(v+h);break;end;end;(k)[f]=v;Q=(0X16);while true do if Q<=22.0 then k=j;Q=(q+Q>Q and Q or U[0X06])-U[6]+Q+0X6E;else f=U;v=(0X07);break;end;end;f=(f[v]);Q=0X74;local s;while true do if not(Q>67.0)then h=1;Q=((Q+Q-U[7]<Q and Q or q)-Q+86);else if not(Q<116.0)then v=U;Q=(U[0X6]-U[6]-q~=Q and Q or Q)-Q+67;else v=(v[h]);break;end;end;end;h=(j);Q=108;while true do if Q==108.0 then g=U;Q=((Q-U[6]+Q-Q>q and q or Q)+40);elseif Q==91.0 then s=(6);Q=((((Q-U[6]>=U[6]and q or q)~=Q and Q or Q)>=Q and U[0X7]or U[0x7])+97);elseif Q==126.0 then g=(g[s]);Q=((U[7]-Q+Q-Q~=U[0X7]and q or q)+0X12);elseif Q==69.0 then h=h[g];Q=((Q-Q~=Q and Q or Q)+q-U[0x7]+5);elseif Q==96.0 then v=(v>h);break;end;end;k[f]=(v);end;else if q==49 then j[U[6]]=j[U[7]]>=U[0X1];else j[U[6]]=j[U[0X4]]>=j[U[7]];end;end;else if q<54 then if q==0X35 then(j)[U[7]]=j[U[0X6]]%j[U[0X4]];else(j[U[0X4]])[j[U[7]]]=(j[U[0X6]]);end;else if q==0X0037 then local q=f[U[0X6]];local f=q[0X2][q[1]];(j)[U[7]]=f[U[0X1]];else j[U[4]]=(tostring);end;end;end;else if not(q>=60)then if q>=0X3A then if q~=59 then repeat local U={};for f,q in h6,h do for q,q in h6,q do if not(q[0x2]==j and q[1]>=0.0)then else f=q[0x01];if not not U[f]then else(U)[f]=({j[f]});end;q[2]=(U[f]);q[1]=1.0;end;end;end;until true;return true,U[7],0.0;else j[U[7]]=U[1]>j[U[0X6]];end;else if q~=0x39 then j[U[7]]=(U[0X1]^j[U[0X6]]);else(j)[U[7]]=U[1]-j[U[6]];end;end;else if q<0X3e then if q==0x3d then(j[U[7]])[U[2]]=j[U[4]];else local f,q=U[0X4],U[0X7];v=f+q-1.0;repeat local U=({});for f,q in h6,h do for q,q in h6,q do if q[2]==j and q[0X1]>=0.0 then f=q[1];if not U[f]then U[f]=({j[f]});end;(q)[2]=U[f];(q)[0X1]=(1.0);end;end;end;until true;return true,f,q;end;else if q==63 then local f=(U[6]);v=f+U[0X7]-1.0;(j)[f]=j[f](f6(f+1.0,v,j));v=(f);else I[t]=({[0X4]=c,[1]=H,[3]=V});t=t+1.0;local f=(U[0x6]);V=j[f+2.0]+0.0;H=j[f+1.0]+0.0;c=j[f]-V;x=(U[7]);end;end;end;end;else if q>=40 then if not(q<44)then if not(q<0X2E)then if q==47 then xify=j[U[4]];else(j)[U[0X7]]=globals;end;else if q==0x2D then(j)[U[0X7]]=j[U[0X4]]^U[0X002];else if not(j[U[0X4]]<=j[U[6]])then x=U[7];end;end;end;else if not(q>=0x2A)then if q==0X29 then(j)[U[6]]=j[U[0x4]]*j[U[7]];else if j[U[0X7]]~=j[U[6]]then else x=U[4];end;end;else if q==0X2b then(j)[U[6]]=U6[U[0x4]];else(j)[U[6]]=j[U[0X4]][j[U[0x7]]];end;end;end;else if not(q<0X24)then if not(q>=38)then if q~=0x25 then j[U[7]]=j[U[6]]==U[1];else(j)[U[0X6]]=-j[U[7]];end;else if q~=0X27 then(j)[U[0X7]]=(type);else(j)[U[0X4]]=(k[U[7]]);end;end;else if not(q>=34)then if q==33 then j[U[0X7]]=(next);else j[U[0X6]]=(pcall);end;else if q~=35 then(j)[U[0X7]]=(U[1]>=U[0x2]);else(j)[U[0x7]]=U[0X001]==U[0X2];end;end;end;end;end;else if q<16 then if q>=0X8 then if not(q>=12)then if q<0XA then if q==9 then j[U[7]]=(nil);else(j)[U[6]]=U[0x3]<=U[1];end;else if q~=11 then j[U[0X7]]=rawset;else local Q,k,v,g=44,f;while true do if Q>27.0 then g=(U);Q=((Q+q>q and Q or q)+q>=Q and q or Q)+16;else if not(Q<44.0)then else v=(0X6);break;end;end;end;g=g[v];k=(k[g]);g=(U);local f;v=0x5;local h;Q=(66);while true do if Q>68.0 then f=(f-h);break;elseif Q<66.0 then h=(0X5);Q=((q+Q<=Q and q or q)-Q-q+125);elseif not(Q>66.0 and Q<83.0)then if not(Q<68.0 and Q>57.0)then else f=U;Q=(Q-Q+q+Q+q-31);end;else f=f[h];h=(q);Q=q-Q-q-Q-q+0Xe6;end;end;h=q;f=f-h;local s;h=(q);f=f+h;h=q;local u;f=(f+h);Q=(72);while true do if Q==72.0 then h=q;Q=Q+q+Q+q-q-148;elseif Q==7.0 then f=(f+h);Q=(Q-Q~=Q and Q or q)-Q+Q+51;elseif Q~=58.0 then else h=q;break;end;end;Q=63;while true do if Q<=18.0 then h=U;Q=q+Q-Q+q-q+0X3e;else if Q>63.0 then u=(0x5);break;else f=f+h;Q=(q-Q-q-Q+Q+0X51);end;end;end;h=h[u];Q=0X51;while true do if Q<124.0 then f=(f+h);Q=((Q+Q-q-Q<Q and q or Q)+113);else if not(Q>81.0)then else h=(q);f=f-h;break;end;end;end;h=0X16;Q=(94);while true do if Q==94.0 then f=(f+h);Q=(Q+Q+q>Q and q or Q)+Q-0X44;elseif Q==37.0 then(g)[v]=f;Q=(q+Q-q+Q==Q and q or q)+0x35;elseif Q==64.0 then g=(k);Q=q-q-q-Q-Q+170;elseif Q~=31.0 then if Q~=114.0 then else g=g[v];v=(k);f=0x1;break;end;else v=(0X2);Q=((q-q+q+q>=q and q or Q)+103);end;end;Q=(62);while true do if not(Q>9.0)then if Q==5.0 then v=(j);Q=(q+q-Q-Q<q and Q or Q)+0X1B;else f=f[h];break;end;else if not(Q>32.0)then f=U;Q=((Q-q+Q+q~=Q and q or q)+71);else if Q~=62.0 then h=7;Q=(((Q-q>Q and q or q)==q and Q or q)<=Q and Q or q)-0X49;else v=(v[f]);g=(g[v]);Q=q-Q-q+Q+q-0X6;end;end;end;end;h=(g);Q=(23);while true do if Q==23.0 then u=U;Q=((q>=q and q or Q)>Q and Q or q)+q+Q-0X23;elseif Q~=10.0 then else s=0X1;u=u[s];break;end;end;h=(h[u]);(v)[f]=h;end;end;else if q<14 then if q==13 then local f=(false);c=(c+V);if V<=0.0 then f=(c>=H);else f=c<=H;end;if f then x=(U[0X4]);j[U[6]+3.0]=(c);end;else j[U[4]]=j[U[7]]+j[U[0X6]];end;else if q~=15 then local f,Q,k,v,g,h,s=5,0X39;while true do if not(Q>57.0)then v=U;Q=q+Q-Q-q-Q+125;else if Q==83.0 then g=(U);break;else k=(5);h=(q);Q=((q+Q==Q and q or Q)-q+q+0X0f);end;end;end;Q=(123);while true do if Q~=30.0 then g=g[f];h=h+g;Q=((Q+q~=Q and Q or Q)+Q<=Q and q or q)+0X10;else g=(q);break;end;end;h=h+g;Q=(36);while true do if Q>36.0 then h=h~=g;break;else if Q<51.0 then g=q;Q=(q-Q-Q-Q+Q+109);end;end;end;if not h then else local f,q,Q=0X6f;while true do if f>111.0 then h=q[Q];break;elseif f>2.0 and f<121.0 then f=(2);q=(U);else if not(f<111.0)then else Q=(0X5);f=(0x79);end;end;end;end;Q=(63);while true do if Q==63.0 then if not h then h=(q);end;g=q;Q=Q+q+q+q+q-0X65;elseif Q==18.0 then h=(h+g);break;end;end;Q=86;while true do if Q==86.0 then g=q;Q=((Q-Q<Q and Q or Q)+q~=Q and Q or q)-25;elseif Q==61.0 then h=(h+g);Q=((Q+q-Q<Q and q or q)+Q+0X2d);elseif Q==120.0 then g=(q);break;end;end;h=h+g;g=U;Q=(0x1f);while true do if not(Q>41.0)then if Q<=31.0 then f=(5);Q=(((q-Q<q and q or Q)-Q>=Q and q or Q)+0X53);else h=h-g;Q=((q>=Q and Q or Q)-Q+Q+q+61);end;else if Q~=116.0 then g=g[f];Q=q+Q-q-Q-q+55;else g=(q);break;end;end;end;h=(h<=g);if not h then else h=(q);end;if not not h then else h=(q);end;Q=0X6E;while true do if Q>80.0 then if Q==117.0 then h=h+g;Q=((q-Q-Q-Q<=Q and Q or Q)-37);else g=(64);Q=(q-Q+q-q>q and Q or Q)+7;end;else(v)[k]=(h);v=(j);break;end;end;Q=0X1;while true do if Q==1.0 then k=(U);Q=Q+q+Q-q+Q+105;elseif Q~=108.0 then else h=(0X7);break;end;end;k=k[h];Q=78;while true do if not(Q>48.0)then f=4;g=(g[f]);break;else if Q>=85.0 then g=(U);Q=(Q<q and Q or Q)+Q+q-Q-0X33;else h=(j);Q=(q+q+Q-Q+Q-0X15);end;end;end;h=(h[g]);Q=0X2;while true do if Q~=2.0 then if Q~=121.0 then if Q==4.0 then s=0X6;Q=(Q~=Q and Q or q)+Q-Q+q-9;elseif Q~=19.0 then else f=f[s];break;end;else f=(U);Q=(Q+Q+Q-q-q-331);end;else g=(j);Q=(q-Q+Q+q-q+0X6b);end;end;Q=(0x48);while true do if Q>7.0 and Q<72.0 then(v)[k]=h;break;elseif Q>58.0 then g=(g[f]);Q=((Q+q+Q>=q and Q or Q)-Q+7);elseif not(Q<58.0)then else h=h-g;Q=Q+q+Q+q+Q+9;end;end;else(j)[U[4]]=U[3]==j[U[0X6]];end;end;end;else if q<0X4 then if not(q>=2)then if q==1 then(j)[U[4]]=U[0X2]+j[U[0x7]];else j[U[4]]=(pairs);end;else if q~=0X03 then j[U[6]]=z.I;else(j)[U[0X4]]=(z.p);end;end;else if not(q<0X06)then if q==7 then local f,q=U[0x4],U[6]*100.0;local Q=j[f];for U=1.0,U[7]do(Q)[q+U]=j[f+U];end;else j[U[0X7]]=(j[U[4]]>j[U[0x6]]);end;else if q==0X5 then(j)[U[0x6]]=(j[U[4]]/j[U[0X7]]);else j[U[4]]=(z.J);end;end;end;end;else if q<24 then if q>=20 then if not(q>=22)then if q~=0X15 then if not(j[U[6]]<j[U[4]])then x=U[0X7];end;else U6[U[7]]=(j[U[0X4]]);end;else if q==23 then if not not(U[0X2]<j[U[0x4]])then else x=(U[0x7]);end;else for U=U[0x4],U[6]do(j)[U]=(nil);end;end;end;else if q>=18 then if q~=0X13 then(j)[U[0X7]]=(L6(j[U[4]],j[U[0X6]]));else(j)[U[0X4]]=(select);end;else if q==0X11 then local q=f[U[7]];(q[2])[q[1]]=j[U[6]];else local f=(U[0X4]);(j[f])(j[f+1.0],j[f+2.0]);v=f-1.0;end;end;end;else if not(q<0X1C)then if q<30 then if q==0x001d then j[U[7]]=getfenv;else(j)[U[0X4]]=not j[U[6]];end;else if q==0X1f then if not not(U[0X2]<=j[U[7]])then else x=U[0X4];end;else j[U[0X4]]=bit;end;end;else if q>=26 then if q==27 then(j)[U[6]]=(U[1]+U[3]);else j[U[4]]=(C[O]);end;else if q==25 then local f=U[6];(j)[f]=j[f](j[f+1.0]);v=(f);else j[U[6]][j[U[4]]]=(U[3]);end;end;end;end;end;end;until false;end);if not U then if Z(Y)~='\115\116ring'then D(Y,0.0);elseif l(Y,'^.-:\37d+: ')then D("Lura\112\104\32Scri\112t:"..(g[x-1.0]or'(internal)').."\58\32"..A(Y),0.0);else D(Y,0.0);end;elseif Y then if o==1.0 then return j[M]();else return j[M](f6(M+1.0,v,j));end;else if not M then else return f6(M,o,j);end;end;end;return L;end;if not m[0X3b86]then S=(F[5]-m[16822]-F[0x1]>m[0X1f01]and m[29272]or m[6290])-m[2682]-13;m[0X3b86]=S;else S=(m[0X3b86]);end;else if not(S>30.0 and S<74.0)then if not(S>74.0 and S<123.0)then else j=X();if not not m[0X6275]then S=(m[0X6275]);else S=(((m[2682]~=m[6290]and F[7]or m[0X004034])+m[0x581E]==m[3054]and m[27158]or m[4039])+m[0X34b1]-138);m[25205]=S;end;end;else W=nil;W=(function()local U,f,v=(81);repeat if U==81.0 then U=(0X7C);f=({{},L,L,nil,nil,{},nil});else v=f[1];break;end;until false;U=(1.0);for f=1.0,t()do f=(nil);local q,Q=38;while true do if q==38.0 then q=0X4d;f=t();else if q~=77.0 then if q~=72.0 then else if f%2.0~=0.0 then local f,q=27;repeat if not(f<=5.0)then if f~=27.0 then q=t();f=5;else f=0X3E;U=t();end;else for U=Q-Q%1.0,U do(v)[U]=q;end;break;end;until false;else v[U]=(Q-Q%1.0);end;U=(U+1.0);break;end;else Q=(f/2.0);q=0x48;end;end;end;end;U=(nil);v=nil;local s;for Q=115,515,100 do if Q==115 then f[_]=q();else if Q==415 then(f)[0X007]=v-v%1.0;else if Q~=315 then if Q==0X203 then s=({});break;else if Q~=0Xd7 then else U=q();end;end;else v=(U/2.0);end;end;end;end;v=nil;local u;for L=97,193,24 do if L<=121.0 then if not(L>97.0)then(f)[d]=(U%2.0~=0.0);f[Q]=q();else f[k]=(s);end;else if L<=145.0 then v=(f[6]);for U=1.0,q()do local f,Q=(q());for q=43,0X0b7,0x57 do if q==43 then Q=(f/2.0);else if q~=130 then else(s)[U]=({[2]=f%2.0,[0X1]=Q-Q%g});break;end;end;end;end;else if L>169.0 then for U=1.0,u do local f,q,Q,k,g,h,s;for u=120,0X158,0X5e do if u==214 then g,h,s=f%4,q%4,(k%_);else if u~=0X134 then if u==0X78 then f,q,Q,k=o(),o(),o(),o();end;else v[U]=({[4]=(f-g)/0x4,[2]=h,[0X5]=Q,[0X1]=g,[6]=(q-h)/0X4,[0X7]=(k-s)/4,[0X3]=s});break;end;end;end;end;for U=1.0,u do local q;for Q=0X05e,0X79,0X1B do if Q~=121.0 then q=f[0X6][U];else for U,f in h6,M do U=g6[f];local Q,k=q[f],(q[U]);if k==0x3 then local f,k;for v=60,0X69,9 do if v<=60.0 then f=x[Q];elseif v==69.0 then k=(O[f]);else if k then local f,Q=(95);while true do if f<95.0 then Q=(k[2.0]);f=(105);elseif not(f<105.0 and f>50.0)then if f>95.0 then(Q)[#Q+1.0]={q,U};break;end;else f=(50);(q)[U]=(k[1.0]);end;end;end;break;end;end;else if k==2 then q[f]=(Q+g);else if k~=0X1 then else local f,k=(0X4E);repeat if f>48.0 and f<85.0 then f=85;k=P[Q];elseif not(f>78.0)then if f<78.0 then(k)[#k+1.0]={q,U};break;end;else if not not k then else k={};P[Q]=(k);end;f=(0X30);end;until false;end;end;end;end;end;end;end;else u=(q()-h);end;end;end;end;return f;end);if not m[23853]then m[7336]=((m[4535]~=m[25101]and m[0x53eb]or m[29272])-F[8]<=m[0X1D00]and m[31920]or F[7])+m[12027]-8;S=(m[853]+m[4535]-m[22606]+m[0X7cb0]-m[0X006A16]+37);m[23853]=S;else S=(m[0X5d2d]);end;end;end;end;end;else X=(function()local U;for f=0x1F,0x199,126 do if f==31 then x={};else if f~=0X199 then if f==0x11b then P=({});else if f~=0X9D then else O=({});end;end;else U=(1.0);end;end;end;local Q,k,h=({});for U=83,0Xdf,69 do if U==152 then h=(v()~=0.0);break;else if U~=83 then else k=(q()-28189);end;end;end;for q=1.0,k do local Q,k,s=(0X7e);repeat if Q==126.0 then Q=69;k=(nil);else if Q~=69.0 then if Q==96.0 then if s==0XBf then k=t();else if s==0x00b4 then k=H();else if s==0x83 then k=E();elseif s==0X2a then k=E()+t();elseif s==105 then k=v()==1.0;else if s==87 then k=N(H(),v());elseif s==191 then k=E();else if s~=0x6 then else k=a();end;end;end;end;end;break;end;else s=v();Q=(0X60);end;end;until false;s=({k,{}});x[q-1.0]=U;Q=111;while true do if not(Q<111.0)then if not(Q>2.0 and Q<121.0)then if Q>111.0 then if h then(f)[V]=(s);V=V+1.0;end;break;end;else Q=(0X2);(O)[U]=(s);end;else Q=0X79;U=(U+g);end;end;end;k=(nil);U=nil;for f=41,298,71 do if f>112.0 and f<254.0 then for U,f in h6,P do h=(nil);for q=0X0034,0xae,0XA do if q<=52.0 then h=Q[U];else if h then for U,U in h6,f do(U[g])[U[2.0]]=(h);end;end;break;end;end;end;else if f<112.0 then k=q()-46113;elseif f<183.0 and f>41.0 then for U=0.0,k-1.0 do Q[U]=W();end;elseif not(f>183.0)then else U=Q[q()];break;end;end;end;x=(nil);O=(nil);for f=0x21,0XD4,0X63 do if f>33.0 then return U;else if not(f<132.0)then else P=L;end;end;end;end);if not not m[29722]then S=m[0X741A];else m[0x34B1]=(((m[32524]+m[0X57e9]>m[18885]and m[16436]or m[6781])+m[16822]>=m[14690]and m[19869]or m[24265])+27);m[9820]=(m[0X1D00]-m[0X6bbC]-m[0X1a7d]+m[6781]-m[26703]+0X69);S=(((m[0x355]+m[0X53EB]>=m[16436]and m[28163]or m[0X60E5])+m[24805]==m[30691]and m[12027]or m[23853])+0x12);(m)[0X741a]=(S);end;end;until false;U6[18029.0]=K(z.I);U6[G]=K(z.Z);j=p(j,U)(X,T,I,c,E,v,t,F,Y,p);return p(j,U);end)(8388608.0,14.0,0.0,2,0X3,3.0,1.0,0X255D,setfenv,pcall,nil,10.0,1.6777216E7,"rsh\105ft",string.byte,12.0,5.0,13.0,0X0,11.0,32.0,string.char,16.0,5.62949953421312E14,bit,2.0,string.match,3.4359738368E10,0x5,error,'_\95inde\120',string.sub,string.gsub,'\95_mode',{n=setmetatable,s=bit32,Z=string,I=math,J=getmetatable,p=table,O=table.insert},4.0,9.0,setmetatable,24834.0,7.0,getfenv,6.0,8.0,0X4,function(...)(...)[...]=(nil);end,{},{0X86f6,83124112,3095925382,0X28891FE8,1347784908,2731301461,4147068597,0X006afE24C2,0x64c4D1e})(...);
