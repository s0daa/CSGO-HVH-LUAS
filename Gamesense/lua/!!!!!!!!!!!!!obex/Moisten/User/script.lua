-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
	if not pcall(client.create_interface) then
	error("[MOISTEN.WIN]: error: please make sure Allow unsafe scripts is enabled and try again")
	return
end
print("welcome to moisten, the number 1 anti aim lua.")
local bit_band, bit_lshift, client_color_log, client_create_interface, client_delay_call, client_find_signature, client_key_state, client_reload_active_scripts, client_screen_size, client_set_event_callback, client_system_time, client_timestamp, client_unset_event_callback, database_read, database_write, entity_get_classname, entity_get_local_player, entity_get_origin, entity_get_player_name, entity_get_prop, entity_get_steam64, entity_is_alive, globals_framecount, globals_realtime, math_ceil, math_floor, math_max, math_min, panorama_loadstring, renderer_gradient, renderer_line, renderer_rectangle, table_concat, table_insert, table_remove, table_sort, ui_get, ui_is_menu_open, ui_mouse_position, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_slider, ui_set, ui_set_visible, setmetatable, pairs, error, globals_absoluteframetime, globals_curtime, globals_frametime, globals_maxplayers, globals_tickcount, globals_tickinterval, math_abs, type, pcall, renderer_circle_outline, renderer_load_rgba, renderer_measure_text, renderer_text, renderer_texture, tostring, ui_name, ui_new_button, ui_new_hotkey, ui_new_label, ui_new_listbox, ui_new_textbox, ui_reference, ui_set_callback, ui_update, unpack, tonumber = bit.band, bit.lshift, client.color_log, client.create_interface, client.delay_call, client.find_signature, client.key_state, client.reload_active_scripts, client.screen_size, client.set_event_callback, client.system_time, client.timestamp, client.unset_event_callback, database.read, database.write, entity.get_classname, entity.get_local_player, entity.get_origin, entity.get_player_name, entity.get_prop, entity.get_steam64, entity.is_alive, globals.framecount, globals.realtime, math.ceil, math.floor, math.max, math.min, panorama.loadstring, renderer.gradient, renderer.line, renderer.rectangle, table.concat, table.insert, table.remove, table.sort, ui.get, ui.is_menu_open, ui.mouse_position, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_slider, ui.set, ui.set_visible, setmetatable, pairs, error, globals.absoluteframetime, globals.curtime, globals.frametime, globals.maxplayers, globals.tickcount, globals.tickinterval, math.abs, type, pcall, renderer.circle_outline, renderer.load_rgba, renderer.measure_text, renderer.text, renderer.texture, tostring, ui.name, ui.new_button, ui.new_hotkey, ui.new_label, ui.new_listbox, ui.new_textbox, ui.reference, ui.set_callback, ui.update, unpack, tonumber

local dragging_fn = function(name, base_x, base_y) return (function()local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client_screen_size()ui_set(self.x_reference,q/j*self.res)ui_set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client_screen_size()return ui_get(self.x_reference)/self.res*j,ui_get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client_screen_size()local y=ui_new_slider('LUA','A',u..' window position',0,x,v/j*x)local z=ui_new_slider('LUA','A','\n'..u..' window position y',0,x,w/k*x)ui_set_visible(y,false)ui_set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;function a.drag(q,r,A,B,C,D,E)if globals_framecount()~=b then c=ui_is_menu_open()f,g=d,e;d,e=ui_mouse_position()i=h;h=client_key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client_screen_size()end;if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math_max(0,math_min(j-A,q))r=math_max(0,math_min(k-B,r))end end end;table_insert(l,{q,r,A,B})return q,r,A,B end;return a end)().new(name, base_x, base_y) end
jit.on()
local ffi = require("ffi")
if not pcall(ffi.sizeof, "ConvarInfo") then
	ffi.cdef([[
		typedef struct {
			char pad[0x14];
			int flags;
			char pad1[0x2c];
		} ConvarFlag;

		typedef struct {
			void** virtual_function_table;
			unsigned char pad[20];
			void* changeCallback;
			void* parent;
			const char* defaultValue;
			char* string;
			int m_StringLength;
			float m_fValue;
			int m_nValue;
			int m_bHasMin;
			float m_fMinVal;
			int m_bHasMax;
			float m_fMaxVal;
			void* onChangeCallbacks_memory;
			int onChangeCallbacks_allocationCount;
			int onChangeCallbacks_growSize;
			int onChangeCallbacks_size;
			void* onChangeCallbacks_elements;
		} ConvarInfo;
	]])
end
local aa_functions = {
    aa_number = "standing",
    jitter_way_number = 1,
    old_weapon = 0,
    actual_weapon = 0,
    actual_tick = 0,
    to_start = false,
    to_jitter = false,  
    bomb_was_bombed = false,
    bomb_was_defused = false,
    can_defensive = false,
    def_ticks = 0,
}
local Color = {185, 181, 241, 255}
local screen_x, screen_y = client_screen_size()
local dragging_panel = dragging_fn('Panel', screen_x / 2, screen_y / 2)
local MOISTEN = {}
MOISTEN.__index = setmetatable(MOISTEN, {})
MOISTEN.data = {
	Flip = false,
	BodyYaw = 0,
	SelfHeight = 0,
	Simulation = {},
	Version = "2.9",
	CallBackList = {},
	SelfVelocity = 0,
	CachedLerp = {},
	PeekOrigin = nil,
	CvarCached = {},
	ThisCallBack = {},
	BindState = true,
	GroundTicks = 0,
	ManualState = 0,
	Initialized = false,
	CycleCached = {},
	CachedIcons = {},
	PrevTickbase = 0,
	HitlogCached = {},
	NotifyCached = {},
	WeaponIndex = 0,
	YawSpinOffset = 0,
	FakeYawAsync = 0,
	UpdateCached = {},
	LastInGame = false,
	ConfigPackage = {},
	NotifyLogIndex = 0,
	Author = "Przunxible",
	CurrentTickbase = 0,
	ClientLanguege = "",
	TickbaseShifting = 0,
	PrevPeekOrigin = nil,
	HelperManager = nil,
	ResetBaseYaw = true,
	LastCanAttack = false,
	LastBaseFakeYaw = 0,
	LastUpdateAttack = 0,
	PlayerStateName = "",
	PlayerStateName2 = "",
	WaysAnglesStage = {},
	UpdateTimerState = {},
	SimulationShifting = 0,
	Token = "Gzq106591.",
	NextTickDesync = false,
	ReleaseTickBase = false,
	ScopeLineElement = nil,
	CachedSurfaceFont = {},
	Developer = "me",
	needcharge = true,
	isDefon = false,
	ConditionTimerState = {},
	StoredModelScale = false,
	StoredConsileFilter = false,
	UpdateTickcountState = {},
	Vector = require("vector"),
	CachedPositionHistory = {},
	WeaponReActiveTimer = 0,
	ReleaseDTHitchance = false,
	OverrideProcessticks = true,
	CrosshairName = "MOISTEN",
	CrosshairName2 = "MOISTEN.WIN",
	LastUpdateDate = "2023.6.7",
	StaticAnimationTextSwitch = {},
	LagCompensationReset = false,
	ResetLagCompensation = false,
	ReleaseClockCorrection = false,
	ScriptName = "MOISTEN.WIN",
	RestoredMaxProcessTicks = false,
	RelativeAnimationTextSwitch = {},
	IsTickbaseDefensiveActive = false,
	ScreenSize = {client.screen_size()},
	SideBarName = "MOISTEN.WIN",
	CachedStaticSingleAnimation = {},
	PanoramaApi = panorama.open(),
	ErrorNotifyColor = {255, 0, 0, 255},
	DefaultColor = {255, 255, 255, 255},
	ReleaseDoubleTapDischarged = false,
	CachedStaticConditionAnimation = {},
	AutoSaveConfigName = "Auto Save",
	MasterSwitchHandleReference = true,
	LightPinkedColor = {185, 181, 241, 255},
	Color1 = {185, 181, 241, 255},
	OtherWatermarkColor = {150, 150, 150, 255},
	NotifyBackgroundColor = {11, 18, 30, 215},
	DefaultElementColor = {255, 255, 255, 200},
	ElementFeaturesColor = {181, 183, 255, 255},
	ElementFeaturesColor2 = {220, 220, 220, 220},
	Teammate = {"Terrorist", "Counter-Terrorist"},
	AccentWatermarkColor = {185, 183, 241, 255},
	LastUpdateTimer = "2023.5.30 -> (Time: 20.55)",
	ElementIdentificationColor = {225, 225, 225, 225},
	NotifyPercentageLineColor = {148, 151, 205, 255},
	ConfigLoadSuccessedColor = {181, 183, 255, 255},
	NotifyWarningAnimationColor = {255, 165, 90, 255},
	Configs = database.read("[MOISTEN.WIN]Configs") or {},
	SelfName = panorama.open().MyPersonaAPI.GetName(),
	ConfigsList = database.read("[MOISTEN.WIN]Configs Data") or {},
	BaseConfig = database.read("[MOISTEN.WIN]Base Config") or false,
	IdealGradientColors = {{1, 59, 175, 255}, {202, 70, 205, 255}, {201, 227, 58, 255}},
	LocaltionLastUpdateTimer = database.read("[MOISTEN.WIN]Fired Last Update Timer"),
	PlayerState = {"Global", "Stand", "Run", "Slow", "Air", "Air+", "Crouch", "Crouch+", "Onshot", "FL"},
	Trace = require("gamesense/trace") or error("[MOISTEN.WIN]error: failed load library: gamesense/trace, please go to lua workshop and subscribe this library"),
	Icons = require("gamesense/icons") or error("[MOISTEN.WIN]error: failed load library: gamesense/icons, please go to lua workshop and subscribe this library"),
	Entity = require("gamesense/entity") or error("[MOISTEN.WIN]error: failed load library: gamesense/entity, please go to lua workshop and subscribe this library"),
	Base64 = require("gamesense/base64") or error("[MOISTEN.WIN]error: failed load library: gamesense/base64, please go to lua workshop and subscribe this library"),
	Surface = require("gamesense/surface") or error("[MOISTEN.WIN]error: failed load library: gamesense/surface, please go to lua workshop and subscribe this library"),
	Clipboard = require("gamesense/clipboard") or error("[MOISTEN.WIN]error: failed load library: gamesense/clipboard, please go to lua workshop and subscribe this library"),
	CsgoWeapons = require("gamesense/csgo_weapons") or error("[MOISTEN.WIN]error: failed load library: gamesense/csgo_weapons, please go to lua workshop and subscribe this library"),
	TechSvg = renderer.load_svg([[<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg" xml:space="preserve" version="1.1" fill="#000000"><g><title>background</title><rect fill="none" id="canvas_background" height="674" width="1278" y="-1" x="-1"/></g><g><title>Layer 1</title><g id="svg_1"><g id="svg_2"><path fill="#7f85ff" id="svg_3" d="m433.136,277.264c-23.416,-26.6 -55.576,-53.948 -92.964,-79.372c-1.556,-20.912 -4.028,-41.152 -7.388,-60.188c12.848,-4.056 25.256,-7.316 37.012,-9.676c40.056,-8.044 68.608,-4.788 76.396,8.704c8.172,14.14 -5.28,43.048 -35.1,75.444c-4.388,4.764 -4.084,12.18 0.684,16.568c4.756,4.388 12.184,4.084 16.572,-0.684c38.708,-42.044 52.26,-78.648 38.164,-103.056c-13.644,-23.632 -48.676,-30.54 -101.328,-19.968c-34.744,6.98 -74.5,21.152 -115.216,40.824c-18.824,-9.084 -37.528,-17.036 -55.632,-23.632c13.448,-60.548 35.312,-98.772 55.664,-98.772c16.012,0 34.072,25.312 47.128,66.06c1.98,6.164 8.576,9.568 14.748,7.588c6.168,-1.972 9.568,-8.58 7.588,-14.748c-17.264,-53.876 -41.284,-82.356 -69.464,-82.356c-38.92,0 -66.172,54.52 -80.472,125.98c0,0.004 -0.008,0.012 -0.008,0.02c-0.316,0.916 -0.472,1.844 -0.552,2.772c-4.248,21.876 -7.28,45.272 -9.088,69.136c-17.368,11.82 -33.688,24.1 -48.52,36.552c-9.932,-9.1 -18.96,-18.212 -26.888,-27.22c-26.992,-30.656 -38.452,-57.016 -30.664,-70.508c8.152,-14.116 39.812,-16.94 82.632,-7.376c6.316,1.42 12.588,-2.564 14,-8.888c1.412,-6.324 -2.568,-12.588 -8.888,-14c-55.616,-12.42 -93.992,-5.844 -108.06,18.536c-13.648,23.632 -2.108,57.428 33.368,97.736c23.416,26.6 55.572,53.944 92.964,79.368c1.552,20.916 4.028,41.156 7.384,60.192c-12.848,4.056 -25.248,7.316 -37.012,9.676c-40.044,8.04 -68.604,4.788 -76.392,-8.704c-8.248,-14.28 5.476,-43.48 35.812,-76.208c4.404,-4.748 4.12,-12.168 -0.628,-16.572c-4.752,-4.404 -12.168,-4.128 -16.576,0.624c-39.292,42.396 -53.116,79.292 -38.916,103.884c9.492,16.44 29.332,24.788 58.248,24.788c12.656,0 27.052,-1.6 43.076,-4.82c34.744,-6.98 74.504,-21.152 115.22,-40.824c18.82,9.084 37.52,17.036 55.632,23.636c-13.448,60.544 -35.316,98.768 -55.668,98.768c-15.968,0 -33.992,-25.2 -47.036,-65.768c-1.984,-6.168 -8.584,-9.56 -14.752,-7.576c-6.168,1.98 -9.556,8.584 -7.576,14.752c17.256,53.672 41.244,82.044 69.36,82.044c38.872,0 66.108,-54.408 80.424,-125.752c0.032,-0.08 0.076,-0.148 0.096,-0.224c0.344,-1.016 0.496,-2.044 0.56,-3.068c4.224,-21.796 7.24,-45.1 9.04,-68.868c17.372,-11.816 33.704,-24.104 48.528,-36.548c9.932,9.1 18.956,18.212 26.884,27.22c26.988,30.656 38.448,57.016 30.66,70.508c-8.12,14.072 -39.668,16.924 -82.32,7.448c-6.312,-1.392 -12.584,2.58 -13.992,8.904c-1.408,6.328 2.584,12.588 8.904,13.996c18.228,4.052 34.592,6.056 48.856,6.052c29.112,0 49.444,-8.344 58.872,-24.668c13.64,-23.636 2.104,-57.432 -33.376,-97.736zm-303.868,-27.252c9.112,-7.532 18.84,-14.984 28.98,-22.316c-0.24,7.444 -0.364,14.888 -0.364,22.304c0,7.508 0.16,14.98 0.396,22.424c-10.212,-7.372 -19.888,-14.868 -29.012,-22.412zm181.092,-104.576c1.964,11.652 3.552,23.8 4.836,36.244c-6.276,-3.884 -12.652,-7.712 -19.132,-11.456c-6.508,-3.752 -13.06,-7.348 -19.616,-10.868c11.48,-5.16 22.812,-9.788 33.912,-13.92zm-120.572,0.072c11.016,4.104 22.28,8.784 33.64,13.872c-6.5,3.496 -13,7.096 -19.484,10.84c-6.468,3.74 -12.828,7.588 -19.12,11.492c1.324,-12.64 3.004,-24.72 4.964,-36.204zm-0.144,209.056c-1.964,-11.652 -3.556,-23.8 -4.832,-36.244c6.272,3.884 12.648,7.708 19.136,11.456c6.5,3.752 13.052,7.348 19.612,10.868c-11.488,5.16 -22.82,9.788 -33.916,13.92zm120.568,-0.064c-11.02,-4.112 -22.28,-8.792 -33.636,-13.88c6.5,-3.496 12.996,-7.096 19.488,-10.84c6.456,-3.736 12.816,-7.584 19.116,-11.488c-1.324,12.64 -3.004,24.72 -4.968,36.208zm7.32,-65.516c-10.756,7.056 -21.844,13.92 -33.196,20.48c-11.432,6.596 -22.892,12.764 -34.292,18.52c-11.492,-5.792 -22.992,-11.952 -34.372,-18.52c-11.432,-6.6 -22.504,-13.44 -33.188,-20.436c-0.728,-12.844 -1.144,-25.888 -1.144,-39.028c0,-13.372 0.404,-26.372 1.132,-38.976c10.752,-7.052 21.828,-13.92 33.2,-20.488c11.432,-6.6 22.888,-12.768 34.284,-18.52c11.492,5.792 22.992,11.952 34.38,18.52c11.424,6.6 22.5,13.436 33.18,20.432c0.732,12.848 1.144,25.888 1.144,39.032c0,13.376 -0.408,26.376 -1.128,38.984zm24.22,-16.672c0.244,-7.444 0.364,-14.892 0.364,-22.312c0,-7.508 -0.16,-14.98 -0.388,-22.424c10.2,7.368 19.872,14.856 28.988,22.396c-9.12,7.536 -18.812,15.004 -28.964,22.34z"/></g></g><g id="svg_4"><g id="svg_5"><path fill="#7f85ff" id="svg_6" d="m251,210.916c-21.552,0 -39.088,17.532 -39.088,39.084s17.536,39.084 39.088,39.084s39.088,-17.532 39.088,-39.084c0,-21.552 -17.532,-39.084 -39.088,-39.084z"/></g></g></g></svg>]], 15, 15),
	HelperSvg = renderer.load_svg([[<svg id="Capa_1" enable-background="new 0 0 512 512" height="512" viewBox="0 0 512 512" width="512" xmlns="http://www.w3.org/2000/svg"><g><g><path d="m216.188 82.318h48.768v37.149h-48.768z" fill="#ffcbbe"/></g><g><path d="m250.992 82.318h13.964v37.149h-13.964z" fill="#fdad9d"/></g><g><ellipse cx="240.572" cy="47.717" fill="#ffcbbe" rx="41.682" ry="49.166" transform="matrix(.89 -.456 .456 .89 4.732 115.032)"/></g><g><path d="m277.661 28.697c-10.828-21.115-32.546-32.231-51.522-27.689 10.933 4.421 20.864 13.29 27.138 25.524 12.39 24.162 5.829 52.265-14.654 62.769-2.583 1.325-5.264 2.304-8.003 2.96 10.661 4.31 22.274 4.391 32.387-.795 20.483-10.504 27.044-38.607 14.654-62.769z" fill="#fdad9d"/></g><g><path d="m296.072 296.122h-111.001v-144.174c0-22.184 17.984-40.168 40.168-40.168h30.666c22.184 0 40.168 17.984 40.168 40.168v144.174z" fill="#95d6a4"/></g><g><path d="m256.097 111.78h-24.384c22.077 0 39.975 17.897 39.975 39.975v144.367h24.384v-144.367c0-22.077-17.897-39.975-39.975-39.975z" fill="#78c2a4"/></g><g><path d="m225.476 41.375c0-8.811 7.143-15.954 15.954-15.954h34.401c-13.036-21.859-38.163-31.469-57.694-21.453-19.846 10.177-26.623 36.875-15.756 60.503 12.755-.001 23.095-10.341 23.095-23.096z" fill="#756e78"/></g><g><path d="m252.677 25.421h23.155c-11.31-18.964-31.718-28.699-49.679-24.408 10.591 4.287 20.23 12.757 26.524 24.408z" fill="#665e66"/></g><g><path d="m444.759 453.15-28.194-9.144c-3.04-.986-5.099-3.818-5.099-7.014v-4.69l-2.986-8.22h-61.669l-2.986 8.22v34.22c0 8.628 6.994 15.622 15.622 15.622h81.993c5.94 0 10.755-4.815 10.755-10.755v-8.008c.001-4.662-3.002-8.793-7.436-10.231z" fill="#aa7a63"/></g><g><path d="m444.759 453.15-28.194-9.144c-3.04-.986-5.099-3.818-5.099-7.014v-4.69l-2.986-8.22h-25.91v12.911c0 3.196 2.059 6.028 5.099 7.014l28.194 9.144c4.434 1.438 7.437 5.569 7.437 10.23v8.008c0 5.94-4.815 10.755-10.755 10.755h28.896c5.94 0 10.755-4.815 10.755-10.755v-8.008c0-4.662-3.003-8.793-7.437-10.231z" fill="#986b54"/></g><g><path d="m343.827 344.798v87.505h67.64v-123.053c0-20.65-16.74-37.39-37.39-37.39h-189.006v33.212c0 19.014 15.414 34.428 34.428 34.428h119.03c2.926 0 5.298 2.372 5.298 5.298z" fill="#5766cb"/></g><g><path d="m382.571 309.25v123.052h28.896v-123.052c0-20.65-16.74-37.39-37.39-37.39h-28.896c20.65 0 37.39 16.74 37.39 37.39z" fill="#3d4fc3"/></g><g><g><path d="m437.268 512h-108.548c-8.244 0-14.928-6.684-14.928-14.928v-107.221c0-11.247-9.15-20.399-20.398-20.399h-123.543c-8.244 0-14.928-6.684-14.928-14.928v-150.17h-22.748c-8.244 0-14.928-6.684-14.928-14.928s6.684-14.928 14.928-14.928h37.676c8.244 0 14.928 6.684 14.928 14.928v150.17h108.616c27.71 0 50.254 22.545 50.254 50.255v92.293h93.619c8.244 0 14.928 6.684 14.928 14.928s-6.684 14.928-14.928 14.928z" fill="#756e78"/></g></g><g><g><path d="m437.268 482.144h-15.115c8.244 0 14.928 6.684 14.928 14.928s-6.683 14.928-14.928 14.928h15.115c8.244 0 14.928-6.684 14.928-14.928s-6.684-14.928-14.928-14.928z" fill="#665e66"/></g><g><path d="m328.534 389.851v83.296c0 4.969 4.028 8.997 8.997 8.997h6.118v-92.293c0-27.755-22.5-50.255-50.255-50.255h-15.114c27.71 0 50.254 22.545 50.254 50.255z" fill="#665e66"/></g><g><path d="m169.664 189.426v150.17h15.115v-150.17c0-8.244-6.684-14.928-14.928-14.928h-15.115c8.245 0 14.928 6.684 14.928 14.928z" fill="#665e66"/></g></g><g><g><path d="m171.702 511.498c-61.701 0-111.898-50.197-111.898-111.898s50.197-111.898 111.898-111.898 111.898 50.197 111.898 111.898-50.197 111.898-111.898 111.898zm0-193.94c-45.238 0-82.042 36.804-82.042 82.042s36.804 82.042 82.042 82.042 82.042-36.804 82.042-82.042-36.804-82.042-82.042-82.042z" fill="#756e78"/></g></g><g><g><path d="m243.485 313.833c16.3 19.444 26.131 44.485 26.131 71.783 0 61.701-50.197 111.898-111.898 111.898-27.298 0-52.339-9.831-71.783-26.131 20.543 24.504 51.364 40.115 85.767 40.115 61.701 0 111.898-50.197 111.898-111.898 0-34.403-15.61-65.225-40.115-85.767z" fill="#665e66"/></g></g><g><path d="m384.583 259.81 13.927 12.767c8.319 7.626 13.447 18.117 14.353 29.366l.509 6.316c.283 3.513-3.591 5.82-6.545 3.898l-45.845-29.834z" fill="#ffcbbe"/></g><g><path d="m413.372 308.259-.509-6.316c-.906-11.249-6.034-21.74-14.353-29.366l-13.927-12.767-7.744 7.387 5.869 5.38c8.319 7.626 13.447 18.117 14.353 29.366l.328 4.072 9.438 6.142c2.954 1.921 6.828-.386 6.545-3.898z" fill="#fdad9d"/></g><g><g><path d="m366.869 290.965c-1.448 1.448-3.783 1.589-5.341.26-8.038-6.857-18.146-10.594-28.827-10.594h-69.416c-31.072 0-56.26-25.188-56.26-56.26v-63.312c0-12.367 10.025-22.392 22.392-22.392 12.367 0 22.392 10.025 22.392 22.392v63.312c0 6.338 5.138 11.476 11.476 11.476h69.415c22.462 0 43.657 8.238 60.136 23.284 1.672 1.526 1.716 4.151.115 5.752z" fill="#95d6a4"/></g></g><g><path d="m392.836 259.13c-16.479-15.047-37.674-23.284-60.136-23.284h-69.416c-6.338 0-11.476-5.138-11.476-11.476v-63.312c0-12.367-10.025-22.392-22.392-22.392-3.429 0-6.676.773-9.581 2.151 5.315 4.094 8.743 10.518 8.743 17.746v74.508c0 6.338 5.138 11.476 11.476 11.476h69.416c22.462 0 43.657 8.238 60.136 23.284 1.672 1.526 1.716 4.151.115 5.752l-13.663 13.663c1.907 1.181 3.739 2.503 5.469 3.979 1.558 1.329 3.893 1.188 5.341-.26l26.082-26.082c1.602-1.602 1.558-4.226-.114-5.753z" fill="#78c2a4"/></g></g></svg>]], 20, 20),
	SettingsSvg = renderer.load_svg([[<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M13.0242 9.24999C13.4944 9.24999 13.8513 8.81719 13.6614 8.38695C13.0412 6.9812 11.6352 6 10 6C9.85376 6 9.70936 6.00785 9.56719 6.02314C9.09929 6.07349 8.90249 6.59904 9.13779 7.00659L10.2165 8.87499C10.3505 9.10704 10.5981 9.24999 10.866 9.24999L13.0242 9.24999Z" fill="#FFF"/>
<path d="M7.83948 7.75785C7.60411 7.35018 7.05027 7.25778 6.77194 7.63742C6.28661 8.29942 6 9.11624 6 10C6 10.8838 6.28662 11.7006 6.77198 12.3626C7.05031 12.7423 7.60415 12.6499 7.83952 12.2422L8.91751 10.3751C9.05149 10.143 9.05149 9.85711 8.91751 9.62506L7.83948 7.75785Z" fill="#FFF"/>
<path d="M9.13785 12.9934C8.90255 13.401 9.09936 13.9265 9.56726 13.9769C9.70941 13.9922 9.85379 14 10 14C11.6352 14 13.0412 13.0188 13.6614 11.613C13.8513 11.1828 13.4944 10.75 13.0242 10.75H10.8661C10.5982 10.75 10.3506 10.8929 10.2166 11.125L9.13785 12.9934Z" fill="#FFF"/>
<path fill-rule="evenodd" clip-rule="evenodd" d="M14.1295 4.34724L14.7744 3.23028C14.9815 2.87156 14.8586 2.41286 14.4999 2.20576C14.1412 1.99865 13.6825 2.12156 13.4754 2.48028L12.8311 3.59615C12.1832 3.30927 11.4835 3.11784 10.75 3.03971V1.75C10.75 1.33579 10.4142 1 10 1C9.58579 1 9.25 1.33579 9.25 1.75V3.03971C8.51649 3.11784 7.81683 3.30927 7.16886 3.59616L6.52462 2.4803C6.31752 2.12158 5.85882 1.99867 5.5001 2.20578C5.14139 2.41289 5.01848 2.87158 5.22559 3.2303L5.87046 4.34725C5.28784 4.7736 4.77359 5.28784 4.34725 5.87046L3.23009 5.22547C2.87137 5.01836 2.41267 5.14127 2.20557 5.49999C1.99846 5.85871 2.12137 6.3174 2.48009 6.52451L3.59615 7.16887C3.30927 7.81683 3.11784 8.51649 3.03971 9.25H1.75C1.33579 9.25 1 9.58579 1 10C1 10.4142 1.33579 10.75 1.75 10.75H3.03971C3.11784 11.4835 3.30926 12.1832 3.59614 12.8311L2.48009 13.4755C2.12137 13.6826 1.99846 14.1413 2.20557 14.5C2.41267 14.8587 2.87137 14.9816 3.23009 14.7745L4.34723 14.1295C4.77355 14.7121 5.28775 15.2263 5.87031 15.6526L5.22538 16.7697C5.01827 17.1284 5.14118 17.5871 5.4999 17.7942C5.85861 18.0013 6.31731 17.8784 6.52441 17.5197L7.1687 16.4038C7.81671 16.6907 8.51643 16.8822 9.25 16.9603V18.25C9.25 18.6642 9.58579 19 10 19C10.4142 19 10.75 18.6642 10.75 18.25V16.9603C11.4836 16.8822 12.1833 16.6907 12.8313 16.4038L13.4756 17.5197C13.6827 17.8784 14.1414 18.0013 14.5001 17.7942C14.8588 17.5871 14.9817 17.1284 14.7746 16.7697L14.1297 15.6526C14.7122 15.2263 15.2264 14.7121 15.6527 14.1296L16.7698 14.7745C17.1285 14.9816 17.5872 14.8587 17.7943 14.5C18.0014 14.1413 17.8785 13.6826 17.5198 13.4755L16.4038 12.8312C16.6907 12.1832 16.8822 11.4835 16.9603 10.75H18.25C18.6642 10.75 19 10.4142 19 10C19 9.58579 18.6642 9.25 18.25 9.25H16.9603C16.8822 8.51646 16.6907 7.81678 16.4038 7.16879L17.5198 6.52451C17.8785 6.3174 18.0014 5.85871 17.7943 5.49999C17.5872 5.14127 17.1285 5.01836 16.7698 5.22547L15.6527 5.8704C15.2264 5.2878 14.7121 4.77358 14.1295 4.34724ZM10 4.5C9.0112 4.5 8.08334 4.76094 7.28153 5.2177C7.27126 5.22431 7.26079 5.2307 7.2501 5.23687C7.23978 5.24283 7.22937 5.24852 7.21889 5.25393C6.40668 5.7309 5.72776 6.4104 5.25148 7.22307C5.24674 7.2321 5.2418 7.24107 5.23666 7.24999C5.2313 7.25926 5.22578 7.26837 5.2201 7.27733C4.76185 8.0801 4.5 9.00947 4.5 10C4.5 10.9904 4.76179 11.9197 5.21995 12.7224C5.22569 12.7314 5.23126 12.7406 5.23666 12.75C5.24185 12.759 5.24683 12.768 5.25161 12.7772C5.72819 13.5903 6.40765 14.27 7.2205 14.747C7.23036 14.7521 7.24017 14.7575 7.2499 14.7631C7.26 14.769 7.26992 14.775 7.27965 14.7812C8.08189 15.2387 9.01042 15.5 10 15.5C10.9897 15.5 11.9184 15.2386 12.7207 14.781C12.7303 14.7749 12.7401 14.7689 12.7501 14.7632C12.7597 14.7576 12.7694 14.7523 12.7792 14.7472C13.5913 14.2707 14.2704 13.5918 14.7469 12.7797C14.7521 12.7697 14.7575 12.7598 14.7632 12.75C14.7691 12.7398 14.7751 12.7298 14.7814 12.72C15.2387 11.9179 15.5 10.9894 15.5 10C15.5 9.01046 15.2387 8.08196 14.7813 7.27974C14.7751 7.27001 14.769 7.26009 14.7632 7.24999C14.7576 7.24025 14.7522 7.23044 14.7471 7.22057C14.2708 6.40891 13.5923 5.73024 12.7808 5.25375C12.7704 5.24838 12.7601 5.24275 12.7499 5.23685C12.7393 5.23074 12.7289 5.22441 12.7188 5.21788C11.9169 4.761 10.9889 4.5 10 4.5Z" fill="#FFF"/></svg>]], 48, 48),
	ManualHiddenData = {
		Base = 0,
		Ticks = 0
	},

	ExtraAntiAimSettings = {
		Switch = false,
		Tickcount = false,
		DefensiveAntiAim = false
	},

	ManualSide = {
		Left = false,
		Back = false,
		Right = false,
		Forward = false
	},

	MovementState = {
		Left = false,
		Back = false,
		Right = false,
		Forward = false
	},

	ZoomMaterials = {
		materialsystem.find_material("dev/clearalpha"),
		materialsystem.find_material("overlays/scope_lens"),
		materialsystem.find_material("dev/blurfilterx_nohdr"),
		materialsystem.find_material("dev/blurfiltery_nohdr"),
		materialsystem.find_material("dev/scope_bluroverlay")
	},

	NotAllowedSignature = {
		"\xFF\xE1",
		"\x51\xC3",
		"\x55\x8B\xEC\x8B\x55\x08\x8B\x4A\x08",
		"\xC6\x06\x00\xFF\x15\xCC\xCC\xCC\xCC\x50",
		"\xFF\x15\xCC\xCC\xCC\xCC\x85\xC0\x74\x0B",
		"\xFF\x15\xCC\xCC\xCC\xCC\xA3\xCC\xCC\xCC\xCC\xEB\x05",
		"\xA1\xCC\xCC\xCC\xCC\x33\xD2\x6A\x00\x6A\x00\x33\xC9\x89\xB0",
		"\x50\xFF\x15\xCC\xCC\xCC\xCC\x85\xC0\x0F\x84\xCC\xCC\xCC\xCC\x6A\x00"
	}
}

MOISTEN.__index.ContainText = function(self, list, match)
	for _, text in pairs(list) do
		if text:find(match) or match:find(text) then
			return true
		end
	end

	return false
end

MOISTEN.__index.ToInteger = function(self, var)
	return math.floor(var + 0.5)
end

MOISTEN.__index.GetTimeScale = function(self)
	return client.timestamp() / 1000
end

MOISTEN.__index.BindArg = function(self, handler, address)
	return function(...)
		return handler(address, ...)
	end
end

MOISTEN.__index.ToGradientColor = function(self, text)
	return self:RgbaToHexGradientText(self.data.IdealGradientColors[1], self.data.IdealGradientColors[2], text)
end

MOISTEN.__index.RgbToHexText = function(self, colors, text)
	return ("\a%02x%02x%02x%s"):format(self:ToInteger(self:Clamp(colors[1], 0, 255)), self:ToInteger(self:Clamp(colors[2], 0, 255)), self:ToInteger(self:Clamp(colors[3], 0, 255)), text)
end

MOISTEN.__index.RgbaToHex = function(self, colors)
	return ("\a%02x%02x%02x%02x"):format(self:ToInteger(self:Clamp(colors[1], 0, 255)), self:ToInteger(self:Clamp(colors[2], 0, 255)), self:ToInteger(self:Clamp(colors[3], 0, 255)), self:ToInteger(self:Clamp(colors[4], 0, 255)))
end

MOISTEN.__index.RgbaToHexText = function(self, colors, text)
	return ("\a%02x%02x%02x%02x%s"):format(self:ToInteger(self:Clamp(colors[1], 0, 255)), self:ToInteger(self:Clamp(colors[2], 0, 255)), self:ToInteger(self:Clamp(colors[3], 0, 255)), self:ToInteger(self:Clamp(colors[4], 0, 255)), text)
end

MOISTEN.__index.Clamp = function(self, var, min, max)
	local math_vars = self:GetMathVars(min, max)
	return math.max(math.min(var, math_vars.max), min)
end

MOISTEN.__index.GetMathVars = function(self, ...)
	local numbers = type(...) == "table" and ... or {...}
	return {
		min = math.min(unpack(numbers)),
		max = math.max(unpack(numbers))
	}
end

MOISTEN.__index.Contains = function(self, tab, this)
	for _, data in pairs(tab) do
		if data == this then
			return true
		end
	end

	return false
end 

MOISTEN.__index.Lerp = function(self, current, target, percentage)
	if type(current) == "table" and type(target) == "table" then
		return {
			self:Lerp(current[1] or current.x or 0, target[1] or target.x or 0, percentage),
			self:Lerp(current[2] or current.y or 0, target[2] or target.y or 0, percentage),
			self:Lerp(current[3] or current.z or 0, target[3] or target.z or 0, percentage),
			self:Lerp(current[4] or current.w or 0, target[4] or target.w or 0, percentage)
		}
	end

	return current + ((target - current) * percentage)
end

MOISTEN.__index.HexTextToOriginal = function(self, text)
	local OriginalText = tostring(text)
	local HexText = OriginalText:gmatch("\a%x%x%x%x%x%x%x%x")()
	while (HexText ~= nil) do
		OriginalText = OriginalText:gsub(HexText, "")
		HexText = OriginalText:gmatch("\a%x%x%x%x%x%x%x%x")()
	end

	return OriginalText
end

MOISTEN.__index.GetStringBytes = function(self, string, index)
	local count_byte = 1
	local this_byte = string:byte(index)
	if this_byte == nil then
		count_byte = 0
	elseif this_byte > 0 and this_byte <= 127 then
		count_byte = 1
	elseif this_byte >= 192 and this_byte <= 223 then
		count_byte = 2
	elseif this_byte >= 224 and this_byte <= 239 then
		count_byte = 3
	elseif this_byte >= 240 and this_byte <= 247 then
		count_byte = 4
	end

	return count_byte
end

MOISTEN.__index.UTF8DecodeSupport = function(self, string)
	local string_list = {}
	local last_index = 0
	local last_count = 1
	local start_count = 0
	local count_length = 0
	for idx = 1, string:len() do
		local count = self:GetStringBytes(string, last_count)
		local text = string:sub(last_count, start_count + count)
		last_count = last_count + count
		start_count = start_count + count
		if last_index ~= last_count then
			table.insert(string_list, text)
			count_length = count_length + 1
			last_index = last_count
		end
	end

	return {
		list = string_list,
		length = count_length
	}
end

MOISTEN.__index.RgbaToHexGradientText = function(self, color_1, color_2, text)
	local gradient_text = ""
	local text_data = self:UTF8DecodeSupport(text)
	for index = 1, text_data.length do
		local current_text = text_data.list[index]
		local current_color = self:Lerp(color_1, color_2, index / text_data.length)
		gradient_text = ("%s%s"):format(gradient_text, self:RgbaToHexText(current_color, current_text))
	end

	return gradient_text
end

MOISTEN.__index.IsElement = function(self, element)
	return type(element) == "table" and element.metatype and element.metatype == "Element"
end

MOISTEN.__index.FirstUpper = function(self, text, length)
	return text:sub(1, length or 1):upper()
end

MOISTEN.__index.FirstUpperColor = function(self, text, color)
	if color then
		return ("%s%s"):format(self:RgbaToHexText(color, self:FirstUpper(text)), self:RgbaToHex({255, 255, 255, 190}))
	end

	return self:FirstUpper(text)
end

MOISTEN.__index.NewSliderIdentification = function(self, list)
	for index, data in pairs(list) do
		list[index - 1] = list[index]
	end

	return list
end

MOISTEN.__index.ContainsUI = function(self, ui, list)
	for _, data in pairs(list) do
		if ui:get(data) then
			return true
		end
	end

	return false
end

MOISTEN.__index.MultiColorText = function(self, data)
	local CurrentText = ""
	for index, arg in pairs(data) do
		CurrentText = ("%s%s"):format(CurrentText, self:RgbaToHexText(arg[2], arg[1]))
	end

	return CurrentText
end

MOISTEN.__index.NewElement = function(self, ref, list)
	local this_label = nil
	if ui.type(ref) == "multiselect" then
		ui.update(ref, list)
	elseif list then
		pcall(ui.set, ref, list)
	end

	return setmetatable({
		ref = ref,
		visible = true,
		callbacks = {},
		type = ui.type(ref),
		metatype = "Element",
		contains = self:BindArg(self.Contains, self),
		var = ui.type(ref) == "button" and "" or ui.get(ref),
		list = ui.type(ref) == "multiselect" and (list or {}) or {}
	}, {
		__tostring = function(self)
			return ("userdata: %s"):format(self.type)
		end,

		__index = {
			name = function(self)
				return ui.name(self.ref)
			end,

			update = function(self, var)
				return ui.update(self.ref, var)
			end,

			set_enabled = function(self, enabled)
				ui.set_visible(self.ref, not enabled)
				return ui.set_enabled(self.ref, enabled)
			end,

			set_visible = function(self, state)
				if self.visible ~= state then
					self.visible = state
					return ui.set_visible(self.ref, state)
				end
			end,

			set = function(self, ...)
				local data = {...}
				if data[1] and data[2] and data[3] and data[4] then
					self.var = data
				else
					self.var = data[1]
				end

				return ui.set(self.ref, ...)
			end,

			get = function(self, index_or_name)
				if not index_or_name then
					return ui.get(self.ref)
				elseif type(index_or_name) == "number" and self.list[index_or_name] then
					return self.contains(ui.get(self.ref), self.list[index_or_name])
				elseif type(index_or_name) == "string" and self.contains(self.list, index_or_name) then
					return self.contains(ui.get(self.ref), index_or_name)
				end

				return false
			end,

			set_callback = function(self, handle, call_init)
				if call_init then
					handle()
				end

				local CachedKey = ("%s%s"):format(self.ref, self.type)
				if not self.callbacks[CachedKey] then
					self.callbacks[CachedKey] = {
						CallBacks = {},
						Successed = false
					}
				end

				table.insert(self.callbacks[CachedKey].CallBacks, handle)
				if not self.callbacks[CachedKey].Successed then
					ui.set_callback(self.ref, function(ref)
						for _, Handler in pairs(self.callbacks[CachedKey].CallBacks) do
							pcall(Handler, ref)
						end
					end)

					self.callbacks[CachedKey].Successe = true
				end
			end
		}
	})
end

MOISTEN.__index.WritePackage = function(self, group, key)
	local current_pre_key = key or ""
	if current_pre_key == "" then
		self.data.ConfigPackage = {}
	end

	for key, data in pairs(group) do
		local current_key = ("%s%s"):format(current_pre_key, key)
		if type(data) == "table" and not self:IsElement(data) then
			self:WritePackage(data, current_key)
		elseif type(data) == "table" and self:IsElement(data) and data.type ~= "button" and data.type ~= "label" then
			self.data.ConfigPackage[current_key] = data
		end
	end
end

MOISTEN.__index.GetPackages = function(self, elements)
	local Configs = {}
	self.data.ConfigPackage = {}
	self:WritePackage(elements)
	for Key, Data in pairs(self.data.ConfigPackage) do
		if Data.type == "color_picker" then
			Configs[Key] = {"Color", {Data:get()}}
		elseif Data.type ~= "color_picker" and Data.type ~= "button" and Data.type ~= "label" then
			Configs[Key] = Data:get()
		end
	end

	return Configs
end

MOISTEN.__index.FiredUpdateLog = function(self)
	if self.data.LocaltionLastUpdateTimer ~= self.data.LastUpdateTimer then
		self.data.NotifyLogIndex = self.data.NotifyLogIndex + 1
		table.insert(self.data.NotifyCached, {
			Switch = false,
			ReleaseTimer = 10,
			CurrentIndex = false,
			Timer = self:GetTimeScale(),
			Index = self.data.NotifyLogIndex,
			AnimationColor = self.data.LightPinkedColor,
			Title = ("MOISTEN%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN updated !")),
			Text = ([[! Updated: %s, Version: %s, Update Contents: 
				-------------------------------------------------------------------]]
			):format(self.data.LastUpdateTimer, self.data.Version),
			ConfigsName = ([[
				[*]Nobody cares what gets update
			]]),

			Svg = {
				Size = self.data.Vector(48, 48),
				Texture = self.data.SettingsSvg
			}
		})

		self.data.LocaltionLastUpdateTimer = self.data.LastUpdateTimer
	end
end

MOISTEN.__index.CopyCurrentConfigs = function(self, elements)
	local ConfigPackage = self:GetPackages(elements)
	self.data.NotifyLogIndex = self.data.NotifyLogIndex + 1
	self.data.Clipboard.set(self.data.Base64.encode(json.stringify(ConfigPackage)))
	client.color_log(self.data.ConfigLoadSuccessedColor[1], self.data.ConfigLoadSuccessedColor[2], self.data.ConfigLoadSuccessedColor[3], ("[%s]Config Copy Successfully !"):format(self.data.ScriptName))
	table.insert(self.data.NotifyCached, {
		Switch = false,
		CurrentIndex = false,
		Text = "Copy Successfully",
		Timer = self:GetTimeScale(),
		Index = self.data.NotifyLogIndex,
		AnimationColor = self.data.LightPinkedColor,
		UserName = ("User: %s"):format(self.data.SelfName),
		Title = ("MOISTEN%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN")),
		ConfigsName = ("Config: %s"):format(("AntiAim: [%s - %s]"):format(elements.Team, elements.Pointer)),
		Svg = {
			Size = self.data.Vector(48, 48),
			Texture = self.data.SettingsSvg
		}
	})
end

MOISTEN.__index.PasteCurrentConfigs = function(self, elements)
	self.data.ConfigPackage = {}
	self:WritePackage(elements)
	local Configs = self.data.Clipboard.get()
	self.data.NotifyLogIndex = self.data.NotifyLogIndex + 1
	if not Configs then
		client.error_log(("[%s] Config Failed Paste: The Clipboard Data Is MOISTEN Data"):format(self.data.ScriptName))
		table.insert(self.data.NotifyCached, {
			Switch = false,
			CurrentIndex = false,
			Timer = self:GetTimeScale(),
			Text = "Config Paste Falied",
			Index = self.data.NotifyLogIndex,
			UserName = ("User: %s"):format(self.data.SelfName),
			AnimationColor = self.data.NotifyWarningAnimationColor,
			ConfigsName = ("Reason: %s"):format(self:RgbaToHexText(self.data.ErrorNotifyColor, "The Clipboard Data Is MOISTEN Data")),
			Title = ("MOISTEN%s%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN -> "), self:RgbaToHexText(self.data.ErrorNotifyColor, "error")),
			Svg = {
				Size = self.data.Vector(48, 48),
				Texture = self.data.SettingsSvg
			}
		})

		return
	end

	if Configs:len() <= 0 then
		client.error_log(("[%s] Config Failed Paste: The Clipboard Is Empty"):format(self.data.ScriptName))
		table.insert(self.data.NotifyCached, {
			Switch = false,
			CurrentIndex = false,
			Timer = self:GetTimeScale(),
			Text = "Config Paste Falied",
			Index = self.data.NotifyLogIndex,
			UserName = ("User: %s"):format(self.data.SelfName),
			AnimationColor = self.data.NotifyWarningAnimationColor,
			ConfigsName = ("Reason: %s"):format(self:RgbaToHexText(self.data.ErrorNotifyColor, "The Clipboard Is Empty")),
			Title = ("MOISTEN.%s%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN -> "), self:RgbaToHexText(self.data.ErrorNotifyColor, "error")),
			Svg = {
				Size = self.data.Vector(48, 48),
				Texture = self.data.SettingsSvg
			}
		})

		return
	end

	local Successed, JsonData = pcall(self.data.Base64.decode, Configs)
	if not Successed or not JsonData then
		client.error_log(("[%s] Config Failed Paste: The Config Is MOISTEN Config, Please Check Your Clipboard"):format(self.data.ScriptName))
		table.insert(self.data.NotifyCached, {
			Switch = false,
			CurrentIndex = false,
			Timer = self:GetTimeScale(),
			Text = "Config Paste Falied",
			Index = self.data.NotifyLogIndex,
			UserName = ("User: %s"):format(self.data.SelfName),
			AnimationColor = self.data.NotifyWarningAnimationColor,
			ConfigsName = ("Reason: %s"):format(self:RgbaToHexText(self.data.ErrorNotifyColor, "This Config Is MOISTEN Config")),
			Title = ("MOISTEN%s%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN -> "), self:RgbaToHexText(self.data.ErrorNotifyColor, "error")),
			Svg = {
				Size = self.data.Vector(48, 48),
				Texture = self.data.SettingsSvg
			}
		})

		return
	end

	local Successed, Data = pcall(json.parse, JsonData)
	if not Successed or not Data then
		client.error_log(("[%s] Config Failed Paste: The Config Is MOISTEN Config, Please Check Your Clipboard"):format(self.data.ScriptName))
		table.insert(self.data.NotifyCached, {
			Switch = false,
			CurrentIndex = false,
			Timer = self:GetTimeScale(),
			Text = "Config Paste Falied",
			Index = self.data.NotifyLogIndex,
			UserName = ("User: %s"):format(self.data.SelfName),
			AnimationColor = self.data.NotifyWarningAnimationColor,
			ConfigsName = ("Reason: %s"):format(self:RgbaToHexText(self.data.ErrorNotifyColor, "This Config Is MOISTEN Config")),
			Title = ("MOISTEN%s%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN -> "), self:RgbaToHexText(self.data.ErrorNotifyColor, "error")),
			Svg = {
				Size = self.data.Vector(48, 48),
				Texture = self.data.SettingsSvg
			}
		})

		return
	end

	for Key, Elements in pairs(self.data.ConfigPackage) do
		local Value = Data[Key]
		if Value and type(Value) == "table" and Value[1] and Value[1] == "Color" then
			Elements:set(unpack(Value[2]), true)
		elseif Value then
			Elements:set(Value)
		end
	end

	client.color_log(self.data.ConfigLoadSuccessedColor[1], self.data.ConfigLoadSuccessedColor[2], self.data.ConfigLoadSuccessedColor[3], ("[%s]Config Paste Successfully !"):format(self.data.ScriptName))
	table.insert(self.data.NotifyCached, {
		Switch = false,
		CurrentIndex = false,
		Text = "Paste Successfully",
		Timer = self:GetTimeScale(),
		Index = self.data.NotifyLogIndex,
		AnimationColor = self.data.LightPinkedColor,
		UserName = ("User: %s"):format(self.data.SelfName),
		Title = ("MOISTEN%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN")),
		ConfigsName = ("Config: %s"):format(("AntiAim: [%s - %s]"):format(elements.Team, elements.Pointer)),
		Svg = {
			Size = self.data.Vector(48, 48),
			Texture = self.data.SettingsSvg
		}
	})
end
local tab, cont = "AA", "Anti-aimbot angles"
local tab1, cont1 = "AA", "Other"
MOISTEN.__index.CreateElements = function(self)
	self.Elements = {
		MasterSwitch = self:NewElement(ui.new_checkbox(tab, cont, "\nMaster-Switch")),
		MasterSwitchLabel = self:NewElement(ui.new_label(tab, cont, "♮ Master-Switch")),
		JoinDiscord = self:NewElement(ui.new_button(tab1, cont1, self:RgbaToHexGradientText({255, 255, 255, 220}, {185, 181, 255, 255}, "Join Servers"), function()
			self.data.PanoramaApi.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/mrZhVCN8Gk")
		end)),

		Group = self:NewElement(ui.new_combobox(tab, cont, ("%s %s"):format(self:RgbaToHexText({185, 181, 255, 255}, "£"), self:RgbaToHexText({255, 255, 255, 206}, "Groups")), {"Anti-aim", "Visuals", "Misc", "Configs"})),
		AntiAim = {
			AAGroup = self:NewElement(ui.new_combobox(tab, cont, "\ns", {"Builder", "Keybinds"})),
			OwnerLabel = self:NewElement(ui.new_label(tab, cont, "                     Owner: Przunxible")),
			enabled_manual = self:NewElement(ui.new_checkbox(tab, cont, ("%s %s"):format(self:RgbaToHexText({185, 181, 255, 255}, "♮"), self:RgbaToHexText({255, 255, 255, 206}, "Manual AA"))), true),
			ManualLeft = self:NewElement(ui.new_hotkey(tab, cont, "   Left")),
			ManualBack = self:NewElement(ui.new_hotkey(tab, cont, "   Back")),
			ManualRight = self:NewElement(ui.new_hotkey(tab, cont, "   Right")),
			ManualForward = self:NewElement(ui.new_hotkey(tab, cont, "   Forward")),
			LegitOnKey = self:NewElement(ui.new_hotkey(tab, cont, ("%s Legit Key"):format(("%s%s"):format(self:RgbaToHexText(Color, "♮"), self:RgbaToHex(self.data.DefaultElementColor))))),
			EdgeYaw = self:NewElement(ui.new_hotkey(tab, cont, ("%s Edge Yaw"):format(("%s%s"):format(self:RgbaToHexText(Color, "♮"), self:RgbaToHex(self.data.DefaultElementColor))))),
			Freestanding = self:NewElement(ui.new_hotkey(tab, cont, ("%s Freestanding"):format(("%s%s"):format(self:RgbaToHexText(Color, "♮"), self:RgbaToHex(self.data.DefaultElementColor))))),
			TeamGroup = self:NewElement(ui.new_combobox(tab, cont, "\n player team", self.data.Teammate)),
			PlayerState = self:NewElement(ui.new_combobox(tab, cont, "\n player state", self.data.PlayerState)),
			Custom = (function()
				local Elements = {}
				for i, team in pairs(self.data.Teammate) do
					Elements[i] = {}
					local ThisTeam = team == "Terrorist" and "T" or "CT"
					for index, data in pairs(self.data.PlayerState) do
						local PrefixName = self:RgbaToHexText(self.data.ElementIdentificationColor, ("[%s - %s]"):format(ThisTeam, data))
						Elements[i][index] = {
							Team = team,
							Pointer = data,
							Enabled = self:NewElement(ui.new_checkbox(tab, cont, ("Enabled %s \aFFFFFFCEState\n%s%s"):format(self:RgbaToHexText(self.data.Color1, data), data, team), data == "Global")),
							Pitch = self:NewElement(ui.new_combobox(tab, cont, ("\aFFFFFFCEPitch\n%s - %s"):format(ThisTeam, data), {"Off", "Default", "Up", "Down", "Minimal", "Random", "Custom", "Jitter", "Tickcount"})),
							PitchAngles = self:NewElement(ui.new_slider(tab, cont, ("\n[%s - %s] - Pitch Angles"):format(ThisTeam, data), - 90, 90, 0)),
							PitchExtraAngles = self:NewElement(ui.new_slider(tab, cont, ("\n[%s - %s] - Pitch Extra"):format(ThisTeam, data), - 90, 90, 0)),
							PitchTickcount = self:NewElement(ui.new_slider(tab, cont, ("\n[%s - %s] - Pitch Tickcount"):format(ThisTeam, data), 0, 3, 0, true, "", 1, self:NewSliderIdentification({"Slow", "Medium", "High", "Fast"}))),
							YawBase = self:NewElement(ui.new_combobox(tab, cont, ("\n[%s - %s] - Yaw Base"):format(ThisTeam, data), {"Local view", "At targets"})),
							Yaw = self:NewElement(ui.new_combobox(tab, cont, ("\aFFFFFFCEYaw\n[%s - %s]"):format(ThisTeam, data), {"Off", "180", "Spin", "Static", "180 Z", "Crosshair", "180 Left/Right"})),
							YawOffset = self:NewElement(ui.new_slider(tab, cont, ("\n[%s - %s] - Yaw Offset"):format(ThisTeam, data), - 180, 180, 0)),
							YawExtraOffset = self:NewElement(ui.new_slider(tab, cont, ("\n[%s - %s] - Extra Yaw Offset"):format(ThisTeam, data), - 180, 180, 0)),
							YawJitter = self:NewElement(ui.new_combobox(tab, cont, ("\aFFFFFFCEYaw Jitter\n[%s - %s]"):format(ThisTeam, data), {"Off", "Offset", "Center", "Random", "Skitter", "X-Ways"})),
							YawJitterTickcount = self:NewElement(ui.new_slider(tab, cont, ("\n[%s - %s] - Yaw Jitter Tickcount"):format(ThisTeam, data), 0, 2, 0, true, "", 1, self:NewSliderIdentification({"Default", "Slow", "Auto"}))),
							YawJitterOffsetLeft = self:NewElement(ui.new_slider(tab, cont, ("\n[%s - %s] - Yaw Jitter Offset Left Slr"):format(ThisTeam, data), - 180, 180, 0)),
							YawJitterWays = self:NewElement(ui.new_slider(tab, cont, ("\n[%s - %s] - Yaw Jitter Ways"):format(ThisTeam, data), 2, 10, 2)),
							BodyYaw = self:NewElement(ui.new_combobox(tab, cont, ("\aFFFFFFCEBody Yaw\n[%s - %s]"):format(ThisTeam, data), {"Off", "Static", "Jitter", "Jitter #Limitate", "Jitter #Advanced", "Opposite"})),
							BodyYawExtra = self:NewElement(ui.new_combobox(tab, cont, ("\n[%s - %s] - Body Yaw extra"):format(ThisTeam, data), {"Single", "Switch", "Timer", "Tickcount" ,"Random"})),
							BodyYawOffset = self:NewElement(ui.new_slider(tab, cont, ("\n[%s - %s] - Body Yaw Offset"):format(ThisTeam, data), - 180, 180, 0)),
							BodyYawExtraTickcount = self:NewElement(ui.new_slider(tab, cont, ("\n[%s - %s] - Body Yaw Tickcount"):format(ThisTeam, data), 0, 3, 0, true, "", 1, self:NewSliderIdentification({"Slow", "Medium", "High", "Fast"}))),
							BodyYawExtraTimer = self:NewElement(ui.new_slider(tab, cont, ("\n[%s - %s] - Body Yaw Timer"):format(ThisTeam, data), 0, 500, 0, true, "s", 0.01)),
							BodyYawExtraOffset = self:NewElement(ui.new_slider(tab, cont, ("\n[%s - %s] - Body Yaw Extra Offset"):format(ThisTeam, data), - 180, 180, 0)),
							Freestandingbodyyaw = self:NewElement(ui.new_checkbox(tab, cont, ("\aFFFFFFCEFreestanding Body Yaw\n[%s - %s]"):format(ThisTeam, data))),
							FakeYawLimitStyle = self:NewElement(ui.new_combobox(tab, cont, ("Fake Limit\n[%s - %s]"):format(ThisTeam, data), {"Default", "Left/Right", "Jitter", "Tickcount", "Update", "Rotation", "Random"})),
							FakeYawLimitUpdate = self:NewElement(ui.new_slider(tab, cont, ("\n[%s - %s] -  Fake Yaw Update"):format(ThisTeam, data), 1, 10, 2)),
							FakeYawLimitTickcount = self:NewElement(ui.new_slider(tab, cont, ("\n[%s - %s] -  Fake Yaw Tickcount"):format(ThisTeam, data), 0, 3, 0, true, "", 1, self:NewSliderIdentification({"Slow", "Medium", "High", "Fast"}))),
							FakeYawLimit = self:NewElement(ui.new_slider(tab, cont, ("\n[%s - %s] - Fake Yaw Limit"):format(ThisTeam, data), 0, 60, 60)),
							ExtraFakeYawLimit = self:NewElement(ui.new_slider(tab, cont, ("\n[%s - %s] - Extra Fake Yaw Limit"):format(ThisTeam, data), 0, 60, 60)),
							DefensiveTriggers = self:NewElement(ui.new_combobox(tab1, cont1, ("%s%s"):format(PrefixName, self:RgbaToHexText(self.data.ElementFeaturesColor, (" - trigger defensive\n%s%s"))), {"Always On", "Tickcount", "Simulate", "Shifting", "Random" })),
							DefensiveConditionTickcount = self:NewElement(ui.new_slider(tab1, cont1, ("\n[%s - %s] - Condition Tickcount"):format(ThisTeam, data), 2, 64, 6)),
							DefensiveDifferentTickcount = self:NewElement(ui.new_slider(tab1, cont1, ("\n[%s - %s] - Different Tickcount"):format(ThisTeam, data), 2, 64, 4)),
							DefensiveOverrideTriggers = self:NewElement(ui.new_combobox(tab1, cont1, ("%s%s"):format(PrefixName, self:RgbaToHexText(self.data.ElementFeaturesColor, (" - Addon Triggers\n%s%s"):format(ThisTeam, data))), {"Always On", "Tickcount", "Simulate", "Shifting"})),
							DefensiveOverrideConditionTickcount = self:NewElement(ui.new_slider(tab1, cont1, ("[%s - %s] - Command Tickcount"):format(ThisTeam, data), 2, 64, 6)),
							DefensiveOverrideDifferentTickcount = self:NewElement(ui.new_slider(tab1, cont1, ("[%s - %s] - Step Tickcount"):format(ThisTeam, data), 2, 64, 4)),
							enabled_exploit = self:NewElement(ui.new_checkbox(tab1, cont1, ("%s%s"):format(PrefixName, self:RgbaToHexText(self.data.ElementFeaturesColor, (" - pitch defensive\n%s%s"):format(ThisTeam, data))))),
							DefensivePitch = self:NewElement(ui.new_combobox(tab1, cont1, ("\n[%s - %s] - Defensvie Pitch Ways"):format(ThisTeam, data), {"Sync", "Flick", "Flick Random", "X-Ways", "Flick Mode"})),
							DefensivePitchWays = self:NewElement(ui.new_slider(tab1, cont1, ("\n[%s - %s] - Defensvie Pitch Ways"):format(ThisTeam, data), 2, 10, 2)),
							DefensivePitchMode = self:NewElement(ui.new_combobox(tab1, cont1, ("\n[%s - %s] - Defensvie Pitch Mode"):format(ThisTeam, data), {"Off", "Default", "Up", "Down", "Minimal", "Random"})),
							DefensivePitchFlickMode = self:NewElement(ui.new_combobox(tab1, cont1, ("\n[%s - %s] - Defensvie Pitch Flick Mode"):format(ThisTeam, data), {"Off", "Default", "Up", "Down", "Minimal", "Random"})),
							enabled_exploit1 = self:NewElement(ui.new_checkbox(tab1, cont1, ("%s%s"):format(PrefixName, self:RgbaToHexText(self.data.ElementFeaturesColor, (" - yaw defensive\n%s%s"):format(ThisTeam, data))))),
							DefensiveYaw = self:NewElement(ui.new_combobox(tab1, cont1, ("\n[%s - %s] - brute conditions"):format(ThisTeam, data), {"Sync", "Flick", "Flick Random", "X-Ways"})),
							DefensiveYawWays = self:NewElement(ui.new_slider(tab1, cont1, ("\n[%s - %s] - Defensvie Yaw Ways"):format(ThisTeam, data), 2, 10, 2)),
							DefensiveYawAngles = self:NewElement(ui.new_slider(tab1, cont1, ("\n[%s - %s] - Defensvie Yaw Angles"):format(ThisTeam, data), - 180, 180, 0)),
							CopyCurrentTeamValue = self:NewElement(ui.new_button(tab, cont, (self:RgbaToHexText(self.data.ElementFeaturesColor2, ("copy state"):format(ThisTeam, data))), function()
								self:CopyCurrentConfigs(Elements[i][index])
							end)),

							PasteCurrentTeamValue = self:NewElement(ui.new_button(tab, cont, (self:RgbaToHexText(self.data.ElementFeaturesColor2, ("paste state"):format(ThisTeam, data))), function()
								self:PasteCurrentConfigs(Elements[i][index])
							end))
						}

						if data == "Global" then
							Elements[i][index].Enabled:set(true)
						end
					end
				end
 
				return Elements
			end)()
		},

		Fakelag = {
			FakelagOptions = self:NewElement(ui.new_multiselect("AA", "Fake Lag", "\aA8A5F1FF£\aFFFFFFCE Options", {"Force Choked", "Break LC In Air", "Reset OS", "Optimize Modifier", "Force Discharge Scan"}), {"Force Choked", "Break LC In Air", "Reset OS", "Optimize Modifier", "Force Discharge Scan"}),
			FakelagAmount = self:NewElement(ui.new_combobox("AA", "Fake Lag", "Fakelag Amount", {"Dynamic", "Maximum", "Fluctuate"})),
			FakelagVariance = self:NewElement(ui.new_slider("AA", "Fake Lag", "Fakelag Variance", 0, 100, 0, true, "%")),
			FakelagLimit = self:NewElement(ui.new_slider("AA", "Fake Lag", "Fakelag Limit", 1, 17, 14)),
			FakelagResetonshotStyle = self:NewElement(ui.new_combobox("AA", "Fake Lag", ("\n[%s - %s] - reset on shot "):format(ThisTeam, data), {"Default", "Safest", "Extended"})),
		},

		Visuals = {
			WatermarkIndication = self:NewElement(ui.new_checkbox(tab, cont, ("%s %s"):format(self:RgbaToHexText({185, 181, 255, 255}, "♮"), self:RgbaToHexText({255, 255, 255, 206}, "Watermarker"))), true),
			WatermarkBarColor = self:NewElement(ui.new_color_picker(tab, cont, "Watermark Color", unpack(self.data.AccentWatermarkColor))),
			WatermarkList = self:NewElement(ui.new_multiselect(tab, cont, "\nWatermark List", {"Version", "Time", "Latency"}), {"Version", "Time", "Latency"}),
			ManualIndication = self:NewElement(ui.new_checkbox(tab, cont, ("%s %s"):format(self:RgbaToHexText({185, 181, 255, 255}, "♮"), self:RgbaToHexText({255, 255, 255, 206}, "Manual Arrows")))),
			ManualColor = self:NewElement(ui.new_color_picker(tab, cont, "Manual Color", 255, 255, 255, 255)),
			ManualArrowStyle = self:NewElement(ui.new_combobox(tab, cont, "\nManual style", {"Mini", "<>", "⯇⯈"})),
			CrosshairIndication = self:NewElement(ui.new_checkbox(tab, cont, ("%s %s"):format(self:RgbaToHexText({185, 181, 255, 255}, "♮"), self:RgbaToHexText({255, 255, 255, 206}, "Crosshair ind")))),
			CrosshairStyle = self:NewElement(ui.new_combobox(tab, cont, "Pattern", {"Concen", "Manifold"})),
			CrosshairNameStyle = self:NewElement(ui.new_combobox(tab, cont, "Style", {"Desync", "Color Side", "Animation"})),
			CrosshairBarLabel = self:NewElement(ui.new_label(tab, cont, "| Bar Color")),
			CrosshairBarColor = self:NewElement(ui.new_color_picker(tab, cont, "| Bar Color", unpack(self.data.LightPinkedColor))),
			CrosshairRealSideLabel = self:NewElement(ui.new_label(tab, cont, "| Main Color")),
			CrosshairRealSideColor = self:NewElement(ui.new_color_picker(tab, cont, "| Main Color\n Color", self.data.LightPinkedColor[1], self.data.LightPinkedColor[2], self.data.LightPinkedColor[3], 0)),
			CrosshairFakeSideLabel = self:NewElement(ui.new_label(tab, cont, "| Minor Color")),
			CrosshairFakeSideColor = self:NewElement(ui.new_color_picker(tab, cont, "| Minor Color\n Color", unpack(self.data.LightPinkedColor))),
			CrosshairAnimationStyle = self:NewElement(ui.new_combobox(tab, cont, "Animation Style", {"Stationary", "Opposite", "Directory"})),
			CrosshairAnimationSide = self:NewElement(ui.new_combobox(tab, cont, "Animation Side", {"Default", "Reversed", "Repeatedly"})),
			CrosshairHotkeyStyle = self:NewElement(ui.new_multiselect(tab, cont, "Hotkeys Style", {"Simplicity", "Complete"}), {"Simplicity", "Complete"}),
			CrosshairHotkeysDoubleTapLabel = self:NewElement(ui.new_label(tab, cont, "| DT Color")),
			CrosshairHotkeysDoubleTapColor = self:NewElement(ui.new_color_picker(tab, cont, "| DT Color\n Color", unpack(self.data.ElementFeaturesColor))),
			CrosshairHotkeysonshotLabel = self:NewElement(ui.new_label(tab, cont, "| Hide Color")),
			CrosshairHotkeysonshotColor = self:NewElement(ui.new_color_picker(tab, cont, "| Hide Color\n Color", unpack(self.data.ElementFeaturesColor))),
			CrosshairHotkeysOtherLabel = self:NewElement(ui.new_label(tab, cont, "| Other Color")),
			CrosshairHotkeysOtherColor = self:NewElement(ui.new_color_picker(tab, cont, "| Other Color\n Color", unpack(self.data.LightPinkedColor))),
			CrosshairHotkeysExtraLabel = self:NewElement(ui.new_label(tab, cont, "| Complete Color")),
			CrosshairHotkeysExtraColor = self:NewElement(ui.new_color_picker(tab, cont, "| Complete Color\n Color", unpack(self.data.ElementFeaturesColor))),
			CrosshairHotkeySettings = self:NewElement(ui.new_multiselect(tab, cont, "Hotkey Settings", {"Fraction", "Thickness", "Animation Speed"}), {"Fraction", "Thickness", "Animation Speed"}),
			DebugPanel = self:NewElement(ui.new_checkbox(tab, cont, ("%s %s"):format(self:RgbaToHexText({185, 181, 255, 255}, "♮"), self:RgbaToHexText({255, 255, 255, 206}, "Debug Panel"))), true),
			HitlogIndication = self:NewElement(ui.new_checkbox(tab, cont, ("%s %s"):format(self:RgbaToHexText({185, 181, 255, 255}, "♮"), self:RgbaToHexText({255, 255, 255, 206}, "Hitlog")))),
			HitlogColor = self:NewElement(ui.new_color_picker(tab, cont, "Hitlog Color", 255, 255, 255, 255)),
			HitlogStyle = self:NewElement(ui.new_combobox(tab, cont, "Style", {"Novel","-"})),
			HitlogBackgroundStyle = self:NewElement(ui.new_combobox(tab, cont, "\nBackground", {"Blur", "Rect"})),
			AutoPeekIndication = self:NewElement(ui.new_checkbox(tab, cont, ("%s %s"):format(self:RgbaToHexText({185, 181, 255, 255}, "♮"), self:RgbaToHexText({255, 255, 255, 206}, "Auto Peek")))),
			AutoPeekColor = self:NewElement(ui.new_color_picker(tab, cont, "Peek Circle Color\n Color", unpack(self.data.LightPinkedColor))),
			AutoPeekStyle = self:NewElement(ui.new_combobox(tab, cont, "\nStyle", {"Default", "Overlay"})),
			AutoPeekAnimation = self:NewElement(ui.new_multiselect(tab, cont, "\nAnimation", {"Radius", "Modifier"}), {"Radius", "Modifier"}),
			enable_min_dmg_ovrrd = self:NewElement(ui.new_checkbox(tab, cont, ("%s %s"):format(self:RgbaToHexText({185, 181, 255, 255}, "♮"), self:RgbaToHexText({255, 255, 255, 206}, "Min Dmg Override")))),
		},

		Misc = {
			FastLadder = self:NewElement(ui.new_checkbox(tab, cont, ("%s Fast Ladder"):format(("%s%s"):format(self:RgbaToHexText(Color, "♮"), self:RgbaToHex(self.data.DefaultElementColor))))),
			ConsoleFilter = self:NewElement(ui.new_checkbox(tab, cont, ("%s %s"):format(self:RgbaToHexText({185, 181, 255, 255}, "♮"), self:RgbaToHexText({255, 255, 255, 206}, "Console Filter")))),
			AntiBackStab = self:NewElement(ui.new_checkbox(tab, cont, ("%s Anti Backstab"):format(("%s%s"):format(self:RgbaToHexText(Color, "♮"), self:RgbaToHex(self.data.DefaultElementColor))))),
			ForceDormant = self:NewElement(ui.new_checkbox(tab, cont, ("%s %s"):format(self:RgbaToHexText({185, 181, 255, 255}, "♮"), self:RgbaToHexText({255, 255, 255, 206}, "Dormant Static")))),
			Cmdyaw1 = self:NewElement(ui.new_checkbox(tab, cont, ("%s %s"):format(self:RgbaToHexText({185, 181, 255, 255}, "♮"), self:RgbaToHexText({255, 255, 255, 206}, "Fake - \aB9B7F1FFlimit")))),
			UnDistinctionFakelag = self:NewElement(ui.new_checkbox(tab, cont, ("%s Un Distinction DT/Fakelag"):format(("%s%s"):format(self:RgbaToHexText(Color, "♮"), self:RgbaToHex(self.data.DefaultElementColor))))),
			DefensiveOverride1 = self:NewElement(ui.new_multiselect(tab, cont, "                              \aB9B7F1FF+\aFFFFFFFF/-", {"Force", "Custom"}), {"Force", "Custom"}),
			DoubleTapBoost = self:NewElement(ui.new_combobox(tab, cont, "DT Boost - \aF65858FFunsafe", {"Off", "Boost", "Fast", "Top Speed"})),
			DoubleTapSettings = self:NewElement(ui.new_multiselect(tab, cont,("\n[%s - %s] - DT set"):format(ThisTeam, data), {"Dynamic Speed", "Dynamic Hitchance", "Force Discharged", "Disablers Clock Correction", "Anti-Defensive"}), {"Dynamic Speed", "Dynamic Hitchance", "Force Discharged", "Disablers Clock Correction", "Anti-Defensive"}),
			AntiDefensiveKey = self:NewElement(ui.new_hotkey(tab, cont, "Anti-Defensive\n Tickbase")),
			DisChargeBackTrackScan = self:NewElement(ui.new_checkbox(tab, cont, "Discharged Backtrack Scan")),
			AnimationBreaker = self:NewElement(ui.new_multiselect(tab, cont, "Animation", {"Moon Walk: Move", "Moon Walk: Air", "Static Slow Walk", "Pitch 0 On Land"}), {"Moon Walk: Move", "Moon Walk: Air", "Static Slow Walk", "Pitch 0 On Land"}),
		},

		Configs = {
			ConfigsList = self:NewElement(ui.new_listbox(tab, cont, "♮ Configs", self.data.Configs)),
			ConfigName = self:NewElement(ui.new_textbox(tab, cont, "\n Config Name")),
			ConfigsControls = function(CallBacks)
				return {
					CreateConfig = self:NewElement(ui.new_button(tab, cont, self:MultiColorText({{"Create", self.data.ElementIdentificationColor}}), CallBacks.Create)),
					LoadConfig = self:NewElement(ui.new_button(tab, cont, self:MultiColorText({{"Load", self.data.ElementIdentificationColor}}), CallBacks.Load)),
					SaveConfig = self:NewElement(ui.new_button(tab, cont, self:MultiColorText({{"Save", self.data.ElementIdentificationColor}}), CallBacks.Save)),
					DeleteConfig = self:NewElement(ui.new_button(tab, cont, self:MultiColorText({{"Delete", self.data.ElementIdentificationColor}}), CallBacks.Delete)),
					ImportConfig = self:NewElement(ui.new_button(tab, cont, self:MultiColorText({{"Import", self.data.ElementIdentificationColor}}), CallBacks.Import)),
					ExportConfig = self:NewElement(ui.new_button(tab, cont, self:MultiColorText({{"Export", self.data.ElementIdentificationColor}}), CallBacks.Export))
				}
			end,

			AutomaticSaveConfig = self:NewElement(ui.new_checkbox(tab, cont, "Auto Save(\aA8A5F1FFtest\aFFFFFFCE)"))
		}
	}

	self.References = {
		fakelag_limit = ui.reference("AA", "Fake lag", "Limit"),
		roll = ui.reference(tab, cont, "Roll"),
		yaw = {ui.reference(tab, cont, "Yaw")},
		slow_walk = {ui.reference(tab1, cont1, "Slow motion")},
		pitch = {ui.reference(tab, cont, "Pitch")},
		onshot = {ui.reference(tab1, cont1, "On shot anti-aim")},
		fakelag_amount = ui.reference("AA", "Fake lag", "Amount"),
		doubletap = {ui.reference("RAGE", "Aimbot", "Double tap")},
		fakelag_variance = ui.reference("AA", "Fake lag", "Variance"),
		maxunlag = ui.reference("Misc", "Settings", "sv_maxunlag2"),
		untrusted = ui.reference("Misc", "Settings", "Anti-untrusted"),
		fakelag_reference = ui.reference("AA", "Fake lag", "Enabled"),
		fake_duck = ui.reference("RAGE", "Other", "Duck peek assist"),
		enabled = ui.reference(tab, cont, "Enabled"),
		leg_movement = ui.reference(tab1, cont1, "Leg movement"),
		force_safe = ui.reference("Rage", "Aimbot", "Force safe point"),
		auto_peek = {ui.reference("Rage", "Other", "Quick peek assist")},
		force_body = ui.reference("Rage", "Aimbot", "Force body aim"),
		ping_spike = {ui.reference("Misc", "Miscellaneous", "Ping spike")},
		yaw_base = ui.reference(tab, cont, "Yaw base"),
		edge_yaw = ui.reference(tab, cont, "Edge yaw"),
		yaw_jitter = {ui.reference(tab, cont, "Yaw jitter")},
		body_yaw = {ui.reference(tab, cont, "Body yaw")},
		min_damage = ui.reference("Rage", "Aimbot", "Minimum damage"),
		freestanding = {ui.reference(tab, cont, "Freestanding")},
		double_tap_hitchance = ui.reference("Rage", "Aimbot", "Double tap hit chance"),
		double_tap_fakelag = ui.reference("Rage", "Aimbot", "Double tap fake lag limit"),
		removed_scope_overlay = ui.reference("Visuals", "Effects", "Remove scope overlay"),
		usrcmdprocessticks =  ui.reference("Misc", "Settings", "sv_maxusrcmdprocessticks2"),
		clockcorrection_msecs = ui.reference("Misc", "Settings", "sv_clockcorrection_msecs2"),
		min_damage_override = {ui.reference("Rage", "Aimbot", "Minimum damage override")},
		freestanding_body_yaw = ui.reference(tab, cont, "Freestanding body yaw"),
		usrcmdprocessticks_holdaim = ui.reference("Misc", "Settings", "sv_maxusrcmdprocessticks_holdaim")
	}
end

MOISTEN.__index.HandleReference = function(self, state)
	local MasterSwitch = self.Elements.MasterSwitch:get()
	if MasterSwitch or (self.data.MasterSwitchHandleReference ~= MasterSwitch and not MasterSwitch) then 
		ui.set_visible(self.References.roll, state)
		ui.set_visible(self.References.yaw[1], state)
		ui.set_visible(self.References.yaw[2], state)
		ui.set_visible(self.References.pitch[1], state)
		ui.set_visible(self.References.pitch[2], state)
		ui.set_visible(self.References.enabled, state)
		ui.set_visible(self.References.yaw_base, state)
		ui.set_visible(self.References.edge_yaw, state)
		ui.set_visible(self.References.yaw_jitter[1], state)
		ui.set_visible(self.References.yaw_jitter[2], state)
		ui.set_visible(self.References.fakelag_limit, state)
		ui.set_visible(self.References.fakelag_amount, state)
		ui.set_visible(self.References.fakelag_variance, state)
		ui.set_visible(self.References.body_yaw[1], state)
		ui.set_visible(self.References.body_yaw[2], state)
		ui.set_visible(self.References.freestanding[1], state)
		ui.set_visible(self.References.freestanding[2], state)
		self.data.MasterSwitchHandleReference = MasterSwitch
		ui.set_visible(self.References.freestanding_body_yaw, state)
	end
		ui.set_visible(self.References.fakelag_limit, state)
		ui.set_visible(self.References.fakelag_amount, state)
		ui.set_visible(self.References.fakelag_variance, state)
		ui.set_visible(self.References.fakelag_reference, state)
end

MOISTEN.__index.HandleMain = function(self)
	local isAAEnable = self.Elements.MasterSwitch:get()
	local isAATab = self.Elements.Group:get() == "Anti-aim"
	local isBuilder = isAATab and self.Elements.AntiAim.AAGroup:get() == "Builder"
	local isKeybinds = isAATab and self.Elements.AntiAim.AAGroup:get() == "Keybinds"
	local isMisc = self.Elements.Group:get() == "Misc"
	local isVisual = self.Elements.Group:get() == "Visuals"
	local isConfig = self.Elements.Group:get() == "Configs"
	self:AutomaticSaveConfig()
	self:HandleReference(not isAAEnable)
	self.Elements.Group:set_visible(isAAEnable)
	self.Elements.JoinDiscord:set_visible(isAAEnable)
	self.Elements.AntiAim.OwnerLabel:set_visible(isAAEnable and isBuilder)
	self.Elements.AntiAim.AAGroup:set_visible(isAAEnable and isAATab)
	self.Elements.Misc.Cmdyaw1:set_visible(isAAEnable and isMisc)
	self.Elements.Misc.FastLadder:set_visible(isAAEnable and isMisc)
	self.Elements.AntiAim.TeamGroup:set_visible(isAAEnable and isBuilder)
	self.Elements.Misc.AntiBackStab:set_visible(isAAEnable and isMisc)
	self.Elements.Misc.ForceDormant:set_visible(isAAEnable and isMisc)
	self.Elements.Misc.ConsoleFilter:set_visible(isAAEnable and isMisc)
	self.Elements.Misc.DoubleTapBoost:set_visible(isAAEnable and isMisc)
	self.Elements.AntiAim.enabled_manual:set_visible(isAAEnable and isAATab and isKeybinds)
	self.Elements.AntiAim.PlayerState:set_visible(isAAEnable and isBuilder)
	self.Elements.Visuals.DebugPanel:set_visible(isAAEnable and isVisual)
	self.Elements.Misc.AnimationBreaker:set_visible(isAAEnable and isMisc)
	self.Elements.Configs.ConfigName:set_visible(isAAEnable and isConfig)
	self.Elements.Configs.ConfigsList:set_visible(isAAEnable and isConfig)
	self.Elements.Misc.DefensiveOverride1:set_visible(isAAEnable and isBuilder)
	self.Elements.Misc.UnDistinctionFakelag:set_visible(isAAEnable and isMisc)
	self.Elements.Fakelag.FakelagLimit:set_visible(isAAEnable and not self.Elements.Fakelag.FakelagOptions:get(4))
	self.Elements.Visuals.HitlogIndication:set_visible(isAAEnable and isVisual)
	self.Elements.Visuals.ManualIndication:set_visible(isAAEnable and isVisual)
	self.Elements.Fakelag.FakelagAmount:set_visible(isAAEnable and not self.Elements.Fakelag.FakelagOptions:get(4))
	self.Elements.Fakelag.FakelagOptions:set_visible(isAAEnable)
	self.Elements.Configs.AutomaticSaveConfig:set_visible(isAAEnable and isConfig)
	self.Elements.Fakelag.FakelagVariance:set_visible(isAAEnable and not self.Elements.Fakelag.FakelagOptions:get(4))
	self.Elements.Visuals.CrosshairIndication:set_visible(isAAEnable and isVisual)
	self.Elements.Visuals.AutoPeekIndication:set_visible(isAAEnable and isVisual)
	self.Elements.Visuals.enable_min_dmg_ovrrd:set_visible(isAAEnable and isVisual)
	self.Elements.Visuals.WatermarkIndication:set_visible(isAAEnable and isVisual)
	self.Elements.AntiAim.EdgeYaw:set_visible(isAAEnable and isAATab and isKeybinds)
	self.Elements.AntiAim.ManualLeft:set_visible(isAAEnable and self.Elements.AntiAim.enabled_manual:get() and isAATab and isKeybinds)
	self.Elements.AntiAim.ManualBack:set_visible(isAAEnable and self.Elements.AntiAim.enabled_manual:get() and isAATab and isKeybinds)
	self.Elements.AntiAim.LegitOnKey:set_visible(isAAEnable and isKeybinds and isAATab)
	self.Elements.AntiAim.ManualRight:set_visible(isAAEnable and self.Elements.AntiAim.enabled_manual:get() and isAATab and isKeybinds)
	self.Elements.AntiAim.ManualForward:set_visible(isAAEnable and self.Elements.AntiAim.enabled_manual:get() and isAATab and isKeybinds)
	self.Elements.AntiAim.Freestanding:set_visible(isAAEnable and isAATab and isKeybinds)
	self.Elements.Visuals.HitlogStyle:set_visible(isAAEnable and isVisual and self.Elements.Visuals.HitlogIndication:get())
	self.Elements.Visuals.HitlogColor:set_visible(isAAEnable and isVisual and self.Elements.Visuals.HitlogIndication:get())
	self.Elements.Visuals.ManualColor:set_visible(isAAEnable and isVisual and self.Elements.Visuals.ManualIndication:get())
	self.Elements.Visuals.AutoPeekStyle:set_visible(isAAEnable and isVisual and self.Elements.Visuals.AutoPeekIndication:get())
	self.Elements.Visuals.AutoPeekColor:set_visible(isAAEnable and isVisual and self.Elements.Visuals.AutoPeekIndication:get())
	self.Elements.Misc.DoubleTapSettings:set_visible(isAAEnable and isMisc and self.Elements.Misc.DoubleTapBoost:get() ~= "Off")
	self.Elements.Visuals.WatermarkList:set_visible(isAAEnable and isVisual and self.Elements.Visuals.WatermarkIndication:get())
	self.Elements.Visuals.ManualArrowStyle:set_visible(isAAEnable and isVisual and self.Elements.Visuals.ManualIndication:get())
	self.Elements.Visuals.CrosshairStyle:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get())
	self.Elements.Visuals.AutoPeekAnimation:set_visible(isAAEnable and isVisual and self.Elements.Visuals.AutoPeekIndication:get())
	self.Elements.Visuals.CrosshairHotkeyStyle:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get())
	self.Elements.Visuals.WatermarkBarColor:set_visible(isAAEnable and isVisual and self.Elements.Visuals.WatermarkIndication:get())
	self.Elements.Visuals.CrosshairRealSideLabel:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get())
	self.Elements.Visuals.CrosshairRealSideColor:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get())
	self.Elements.Visuals.CrosshairFakeSideLabel:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get())
	self.Elements.Visuals.CrosshairFakeSideColor:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get())
	self.Elements.Fakelag.FakelagResetonshotStyle:set_visible(isAAEnable and self.Elements.Fakelag.FakelagOptions:get(3))
	self.Elements.Misc.AntiDefensiveKey:set_visible(isAAEnable and isMisc and self.Elements.Misc.DoubleTapBoost:get() ~= "Off" and self.Elements.Misc.DoubleTapSettings:get(5))
	self.Elements.Misc.DisChargeBackTrackScan:set_visible(isAAEnable and isMisc and self.Elements.Misc.DoubleTapBoost:get() ~= "Off" and self.Elements.Misc.DoubleTapSettings:get(3))
	self.Elements.Visuals.CrosshairHotkeySettings:set_visible(self.Elements.MasterSwitch:get() and isVisual and self.Elements.Visuals.CrosshairIndication:get())
	self.Elements.Visuals.CrosshairNameStyle:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get() and self.Elements.Visuals.CrosshairStyle:get() == "Concen")
	self.Elements.Visuals.CrosshairHotkeysExtraLabel:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get() and self.Elements.Visuals.CrosshairHotkeyStyle:get(2))
	self.Elements.Visuals.CrosshairHotkeysExtraColor:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get() and self.Elements.Visuals.CrosshairHotkeyStyle:get(2))
	self.Elements.Visuals.CrosshairHotkeysOtherLabel:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get() and self.Elements.Visuals.CrosshairHotkeyStyle:get(1))
	self.Elements.Visuals.CrosshairHotkeysOtherColor:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get() and self.Elements.Visuals.CrosshairHotkeyStyle:get(1))
	self.Elements.Visuals.CrosshairHotkeysonshotLabel:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get() and self.Elements.Visuals.CrosshairHotkeyStyle:get(1))
	self.Elements.Visuals.CrosshairHotkeysonshotColor:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get() and self.Elements.Visuals.CrosshairHotkeyStyle:get(1))
	self.Elements.Visuals.CrosshairHotkeysDoubleTapLabel:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get() and self.Elements.Visuals.CrosshairHotkeyStyle:get(1))
	self.Elements.Visuals.CrosshairHotkeysDoubleTapColor:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get() and self.Elements.Visuals.CrosshairHotkeyStyle:get(1))
	self.Elements.Visuals.HitlogBackgroundStyle:set_visible(isAAEnable and isVisual and self.Elements.Visuals.HitlogIndication:get() and self.Elements.Visuals.HitlogStyle:get() == "Novel")
	self.Elements.Visuals.CrosshairBarLabel:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get() and (self.Elements.Visuals.CrosshairNameStyle:get() == "Desync" or self.Elements.Visuals.CrosshairStyle:get() == "Manifold"))
	self.Elements.Visuals.CrosshairBarColor:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get() and (self.Elements.Visuals.CrosshairNameStyle:get() == "Desync" or self.Elements.Visuals.CrosshairStyle:get() == "Manifold"))
	self.Elements.Visuals.CrosshairAnimationStyle:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get() and self.Elements.Visuals.CrosshairNameStyle:get() ~= "Color Side" and self.Elements.Visuals.CrosshairNameStyle:get() ~= "Off")
	self.Elements.Visuals.CrosshairAnimationSide:set_visible(isAAEnable and isVisual and self.Elements.Visuals.CrosshairIndication:get() and self.Elements.Visuals.CrosshairNameStyle:get() ~= "Color Side" and self.Elements.Visuals.CrosshairAnimationStyle:get() ~= "Off")



	if self.data.Initialized and type(self.Elements.Configs.ConfigsControls) == "table" then
		self.Elements.Configs.ConfigsControls.SaveConfig:set_visible(isAAEnable and isConfig)
		self.Elements.Configs.ConfigsControls.LoadConfig:set_visible(isAAEnable and isConfig)
		self.Elements.Configs.ConfigsControls.DeleteConfig:set_visible(isAAEnable and isConfig)
		self.Elements.Configs.ConfigsControls.CreateConfig:set_visible(isAAEnable and isConfig)
		self.Elements.Configs.ConfigsControls.ExportConfig:set_visible(isAAEnable and isConfig)
		self.Elements.Configs.ConfigsControls.ImportConfig:set_visible(isAAEnable and isConfig)
	end

	for i, list in pairs(self.Elements.AntiAim.Custom) do
		for index, data in pairs(list) do
				local isAATab = self.Elements.Group:get() == "Anti-aim"
			local isBuilder = isAATab and self.Elements.AntiAim.AAGroup:get() == "Builder"
			local isKeybinds = isAATab and self.Elements.AntiAim.AAGroup:get() == "Keybinds"
			local isAAEnable = self.Elements.MasterSwitch:get()
			local isdataTeam = self.Elements.AntiAim.TeamGroup:get() == data.Team
			local isdataState = self.Elements.AntiAim.PlayerState:get() == data.Pointer
			local isdataEnable = data.Enabled:get()
			data.CopyCurrentTeamValue:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable)
			data.PasteCurrentTeamValue:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable)
			data.Yaw:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable)
			data.Pitch:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable)
			data.YawBase:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable)
			data.BodyYaw:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable)
			data.Enabled:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and data.Pointer ~= "Global")
			data.Freestandingbodyyaw:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable)
			data.YawJitter:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.Yaw:get() ~= "Off")
			data.BodyYawExtra:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off")
			data.PitchTickcount:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.Pitch:get() == "Tickcount")
			data.YawExtraOffset:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.Yaw:get() == "180 Left/Right")
			data.PitchExtraAngles:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and self:Contains({"Jitter", "Tickcount"}, data.Pitch:get()))
			data.DefensiveOverrideTriggers:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.DefensiveOverride1:get(2) == "Custom")
			data.YawJitterWays:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.Yaw:get() ~= "Off" and data.YawJitter:get() == "X-Ways")
			data.YawJitterOffsetLeft:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.Yaw:get() ~= "Off" and data.YawJitter:get() ~= "Off")
			data.FakeYawLimit:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.Cmdyaw1:get() and data.FakeYawLimitStyle:get() ~= "Random")
			data.PitchAngles:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and self:Contains({"Custom", "Jitter", "Tickcount"}, data.Pitch:get()))
			data.DefensiveYaw:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.DefensiveOverride1:get(2) and data.enabled_exploit1:get())
			data.DefensivePitch:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.DefensiveOverride1:get(2) and data.enabled_exploit:get())
			data.FakeYawLimitStyle:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.Cmdyaw1:get())
			data.BodyYawExtraTimer:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and data.BodyYawExtra:get() == "Timer")
			data.enabled_exploit:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.DefensiveOverride1:get(2))
			data.enabled_exploit1:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.DefensiveOverride1:get(2))
			data.FakeYawLimitTickcount:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.Cmdyaw1:get() and data.FakeYawLimitStyle:get() == "Tickcount")
			data.DefensiveTriggers:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.DefensiveOverride1:get(1))
			data.BodyYawExtraTickcount:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and not data.BodyYaw:get() ~= "Off" and data.BodyYawExtra:get() == "Tickcount")
			data.BodyYawOffset:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYawExtra:get() ~= "Random" and not self:Contains({"Off", "Opposite"}, data.BodyYaw:get()))
			data.YawJitterTickcount:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.Yaw:get() ~= "Off" and self:Contains({"Offset", "Center", "Random"}, data.YawJitter:get()))
			data.DefensiveYawAngles:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.DefensiveOverride1:get(2) and data.DefensiveYaw:get() ~= "Off" and data.enabled_exploit1:get())
			data.DefensiveYawWays:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.DefensiveOverride1:get(2) and data.DefensiveYaw:get() == "X-Ways" and data.enabled_exploit1:get())
			data.BodyYawExtraOffset:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and data.BodyYawExtra:get() ~= "Single" and data.BodyYawExtra:get() ~= "Random")
			data.DefensivePitchWays:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.DefensiveOverride1:get(2) and data.DefensivePitch:get() == "X-Ways" and data.enabled_exploit:get())
			data.ExtraFakeYawLimit:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.Cmdyaw1:get() and data.FakeYawLimitStyle:get() ~= "Default" and data.FakeYawLimitStyle:get() ~= "Random")
			data.DefensiveOverrideDifferentTickcount:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.DefensiveOverride1:get(2) and data.DefensiveOverrideTriggers:get() == "Tickcount")
			data.DefensiveOverrideConditionTickcount:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.DefensiveOverride1:get(2) and data.DefensiveOverrideTriggers:get() == "Tickcount")
			data.YawOffset:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.Yaw:get() ~= "Off" and (not self.Elements.Misc.Cmdyaw1:get() or (self.Elements.Misc.Cmdyaw1:get() and data.Yaw:get() ~= "Crosshair")))
			data.DefensiveDifferentTickcount:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.DefensiveOverride1:get(1) and data.DefensiveTriggers:get() == "Tickcount")
			data.DefensiveConditionTickcount:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.DefensiveOverride1:get(1) and data.DefensiveTriggers:get() == "Tickcount")
			data.FakeYawLimitUpdate:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.Cmdyaw1:get() and self:Contains({"Update", "Rotation"}, data.FakeYawLimitStyle:get()))
			data.DefensivePitchMode:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.DefensiveOverride1:get(2) and data.DefensivePitch:get() ~= "Off" and data.DefensivePitch:get() == "Flick Mode" and data.enabled_exploit:get())
			data.DefensivePitchFlickMode:set_visible(isAAEnable and isBuilder and isdataTeam and isdataState and isdataEnable and data.BodyYaw:get() ~= "Off" and self.Elements.Misc.DefensiveOverride1:get(2) and data.DefensivePitch:get() ~= "Off" and data.DefensivePitch:get() == "Flick Mode" and data.enabled_exploit:get())
		end
	end
end

MOISTEN.__index.NormalizedYaw = function(self, yaw)
	if not yaw then
		return 0
	end

	while yaw > 180 do
		yaw = yaw - 360
	end

	while yaw < - 180 do
		yaw = yaw + 360
	end

	return yaw
end

MOISTEN.__index.NormalizedAngles = function(self, angles)
	while (angles.x > 89.0) do
		angles.x = angles.x - 180.0
	end

	while (angles.x < - 89.0) do
		angles.x = angles.x + 180.0
	end

	while (angles.y < - 180.0) do
		angles.y = angles.y + 360.0
	end

	while (angles.y > 180.0) do
		angles.y = angles.y - 360.0
	end

	angles.z = 0
	return angles
end

MOISTEN.__index.CreateSurfaceFont = function(self, name, size, width, flags)
	local CachedKey = ("%s%s%s%s"):format(name, size, width, table.concat(flags or {}))
	if not self.data.CachedSurfaceFont[CachedKey] then
		self.data.CachedSurfaceFont[CachedKey] = self.data.Surface.create_font(name, size, width, flags)
	end

	return self.data.CachedSurfaceFont[CachedKey]
end

MOISTEN.__index.RegisteredCallBack = function(self, key, handle)
	if not self.data.CallBackList[key] then
		self.data.CallBackList[key] = {
			List = {},
			Handle = nil,
			Successed = false
		}
	end

	table.insert(self.data.CallBackList[key].List, handle)
	if not self.data.CallBackList[key].Successed then
		local ThisInstance = function(...)
			for _, Handle in pairs(self.data.CallBackList[key].List) do
				if type(Handle) == "function" then
					Handle(...)
				end
			end
		end

		if key == "shutdown" then
			client.delay_call(0.1, client.set_event_callback, key, ThisInstance)
		else
			client.set_event_callback(key, ThisInstance)
		end

		self.data.CallBackList[key].Successed = true
		self.data.CallBackList[key].Handle = ThisInstance
	end
end

MOISTEN.__index.MultiCallBack = function(self, tab, fn, call_init)
	if call_init then
		fn()
	end

	for _, data in pairs(tab) do
		if type(data) == "table" and not self:IsElement(data) then
			self:MultiCallBack(data, fn, false)
		elseif self:IsElement(data) and data.type ~= "button" then
			if not self.data.ThisCallBack[data] then
				self.data.ThisCallBack[data] = {
					CallBacks = {},
					Success = false
				}
			end

			if not self.data.ThisCallBack[data].Success then
				data:set_callback(function()
					for _, Handle in pairs(self.data.ThisCallBack[data].CallBacks) do
						if type(Handle) == "function" then
							Handle()
						end
					end
				end)
			end

			self.data.ThisCallBack[data].Success = true
			table.insert(self.data.ThisCallBack[data].CallBacks, fn)
		end
	end
end

MOISTEN.__index.GetIcon = function(self, name, type, color)
	local CachedKey = ("%s%s%s"):format(name, type, table.concat(color))
	if not self.data.CachedIcons[CachedKey] or not self.data.CachedIcons[CachedKey].PreCache then
		self.data.CachedIcons[CachedKey] = {
			Buffer = nil,
			PreCache = false
		}

		self.data.Icons.hero.get_icon(name, type, color, function(texture)
			self.data.CachedIcons[CachedKey].Buffer = texture
			if texture then
				self.data.CachedIcons[CachedKey].PreCache = true
			end
		end)
	end

	return self.data.CachedIcons[CachedKey].Buffer
end

MOISTEN.__index.CreateAnimationText = function(self, text, colors_1, colors_2, speed, is_reserved, automatic_reversed)
	local fraction_list = {}
	local current_text = ""
	local decode = self:UTF8DecodeSupport(text)
	if decode.length <= 0 then
		return ""
	end

	local text_length = decode.length
	local animation_reversed = is_reserved
	local maximized_different = text_length * 5
	local animation_smooth = globals.curtime() / (11 - (speed / 10))
	if automatic_reversed then
		animation_reversed = self.data.StaticAnimationTextSwitch[text]
	end

	for index = 1, decode.length do
		local between = math.abs((index * 5) / maximized_different)
		fraction_list[index] = math.abs(1 * math.cos(2 * math.pi * animation_smooth + (animation_reversed and between or - between)))
	end

	for index, fraction in pairs(fraction_list) do
		local this_color = self:Lerp(colors_1, colors_2, fraction)
		current_text = ("%s%s"):format(current_text, self:RgbaToHexText(this_color, decode.list[index]))
	end

	if automatic_reversed then
		if not self.data.StaticAnimationTextSwitch[text] then
			self.data.StaticAnimationTextSwitch[text] = false
		end

		if not self.data.StaticAnimationTextSwitch[text] and fraction_list[1] >= 0.99 then
			self.data.StaticAnimationTextSwitch[text] = true
		elseif self.data.StaticAnimationTextSwitch[text] and fraction_list[1] <= 0.01 then
			self.data.StaticAnimationTextSwitch[text] = false
		end
	end

	return current_text
end

MOISTEN.__index.ProxyBind = (function()
	local ProxyAddr = client.find_signature("client.dll", "\x51\xC3")
	local ProxyGetModuleAddr = ffi.cast("uintptr_t(__thiscall*)(void*, const char*)", ProxyAddr)
	local ProxyGetInterfaceAddr = ffi.cast("uintptr_t(__thiscall*)(void*, uintptr_t, const char*)", ProxyAddr)
	local GetModuleAddr = ffi.cast("void***", ffi.cast("char*", client.find_signature("client.dll", "\xC6\x06\x00\xFF\x15\xCC\xCC\xCC\xCC\x50")) + 5)[0][0]
	local GetProcAddr = ffi.cast("void***", ffi.cast("char*", client.find_signature("client.dll", "\x50\xFF\x15\xCC\xCC\xCC\xCC\x85\xC0\x0F\x84\xCC\xCC\xCC\xCC\x6A\x00")) + 3)[0][0]
	return function(self, module, interface, typedef)
		local ModuleAddr = ProxyGetModuleAddr(GetModuleAddr, module)
		local InterfaceAddr = ProxyGetInterfaceAddr(GetProcAddr, ModuleAddr, interface)
		if type(typedef) == "boolean" and typedef then
			return InterfaceAddr
		end

		return function(...)
			return ffi.cast(typedef, ProxyAddr)(InterfaceAddr, ...)
		end
	end
end)()

MOISTEN.__index.CreateCHelpers = function(self)
	local VirtualProtect = self:ProxyBind("Kernel32.dll", "VirtualProtect", "uintptr_t(__thiscall*)(uintptr_t, void*, uintptr_t, uintptr_t, uintptr_t*)")
	self.CHelpers = {
		IsInGame = vtable_bind("engine.dll", "VEngineClient014", 26, "bool(__thiscall*)(void*)"),
		GetClientEntity = vtable_bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)"),
		GetClientLanguege = vtable_bind("vgui2.dll", "VGUI_Scheme010", 18, "const char*(__thiscall*)(void*)"),
		GetCvar = vtable_bind("vstdlib.dll", "VEngineCvar007", 16, "ConvarInfo*(__thiscall*)(void*, const char*)"),
		SetClientLanguege = vtable_bind("vgui2.dll", "VGUI_Scheme010", 17, "void(__thiscall*)(void*, const char*)"),
		GetEyePosition = ffi.cast("Vector(__thiscall*)(void*)", client.find_signature("client.dll", "\x55\x8B\xEC\x56\x8B\xF1\x8B\x06\xFF\x50\x28")),
		GameRulePointer = ffi.cast("intptr_t**", ffi.cast("intptr_t", client.find_signature("client.dll", "\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1")) + 2)[0]
	}
end

MOISTEN.__index.GetCvar = function(self)
	local BaseCvarRate = self.CHelpers.GetCvar("rate")
	local SetInt = ffi.cast("void(__thiscall*)(ConvarInfo*, float)", BaseCvarRate.virtual_function_table[16])
	local SetFloat = ffi.cast("void(__thiscall*)(ConvarInfo*, float)", BaseCvarRate.virtual_function_table[15])
	return function(self, cvar_name)
		local BaseCvar = self.CHelpers.GetCvar(cvar_name)
		if not self.data.CvarCached[cvar_name] then
			local ConvarFlags = ffi.cast("ConvarFlag*", BaseCvar)
			self.data.CvarCached[cvar_name] = {
				Reset = true,
				Cvar = BaseCvar,
				CvarFlags = ConvarFlags,
				Flags = ConvarFlags.flags,
				OriginalCvar = cvar[cvar_name],
				CurrentFlags = ConvarFlags.flags,
				Original = tonumber(ffi.string(BaseCvar.defaultValue)),
				CurrentVar = tonumber(ffi.string(BaseCvar.defaultValue))
			}
		end

		return setmetatable(self.data.CvarCached[cvar_name], {
			__tostring = function(self)
				return ("userdata: %s"):format(cvar_name)
			end,

			__index = {
				flag = function(self, var)
					if self.CurrentFlags ~= var then
						self.Reset = false
						self.CurrentFlags = var
						self.CvarFlags.flags = var
					end
				end,

				set = function(self, var)
					if self.CurrentVar ~= var then
						self.Reset = false
						self.CurrentVar = var
						local AbsVar = math.abs(var)
						local IsFloat = AbsVar < math.ceil(AbsVar)
						local SetConvar = (IsFloat and SetFloat or SetInt)
						if not IsFloat then
							self.OriginalCvar:set_int(var)
						elseif IsFloat then
							self.OriginalCvar:set_float(var)
						end

						pcall(SetConvar, self.Cvar, tonumber(var))
					end
				end,

				reset = function(self)
					if not self.Reset then
						self.Reset = true
						self.CurrentFlags = self.Flags
						self.CurrentVar = self.Original
						self.CvarFlags.flags = self.CurrentFlags
						local AbsOriginal = math.abs(self.Original)
						local IsFloat = AbsOriginal < math.ceil(AbsOriginal)
						local SetOriginalCvar = IsFloat and SetFloat or SetInt
						pcall(SetOriginalCvar, self.Cvar, tonumber(self.Original))
						if not IsFloat then
							self.OriginalCvar:set_int(self.Original)
						elseif not IsFloat then
							self.OriginalCvar:set_float(self.Original)
						end
					end
				end
			}
		})
	end
end

MOISTEN.__index.CreateRelativeAnimationText = function(self, text, colors_1, colors_2, speed, is_reserved, automatic_reversed)
	local fraction_list = {}
	local current_text = ""
	local decode = self:UTF8DecodeSupport(text)
	if decode.length <= 0 then
		return ""
	end

	local text_length = decode.length
	local animation_reversed = is_reserved
	local maximized_different = text_length * 5
	local length_between = self:ToInteger((decode.length / 2) + 1)
	local animation_smooth = globals.curtime() / (11 - (speed / 10))
	if automatic_reversed then
		animation_reversed = self.data.RelativeAnimationTextSwitch[text]
	end

	for index = 1, length_between do
		local between = math.abs((index * 5) / maximized_different)
		fraction_list[index] = math.abs(1 * math.cos(2 * math.pi * animation_smooth + (animation_reversed and - between or between)))
	end

	for index, fraction in pairs(fraction_list) do
		fraction_list[length_between + index] = fraction_list[length_between - index]
	end

	if automatic_reversed then
		if not self.data.RelativeAnimationTextSwitch[text] then
			self.data.RelativeAnimationTextSwitch[text] = false
		end

		if not self.data.RelativeAnimationTextSwitch[text] and fraction_list[1] <= 0.01 then
			self.data.RelativeAnimationTextSwitch[text] = true
		elseif self.data.RelativeAnimationTextSwitch[text] and fraction_list[1] >= 0.99 then
			self.data.RelativeAnimationTextSwitch[text] = false
		end
	end

	for index, fraction in pairs(fraction_list) do
		if decode.list[index] then
			local this_color = self:Lerp(colors_1, colors_2, fraction)
			current_text = ("%s%s"):format(current_text, self:RgbaToHexText(this_color, decode.list[index]))
		end
	end

	return current_text
end

local randomSeedState = true 
local randomSeed = 0
local function iRandomValue(value_1, value_2, tick_delay)
    if not tick_delay then 
        tick_delay = 1
    end 

    randomSeed = randomSeed + 1
    if randomSeed == tick_delay then 
        randomSeedState = not randomSeedState
        randomSeed = 0
    end

    return randomSeedState and value_1 or value_2
end


MOISTEN.__index.NewEntity = function(self, ent)
	return setmetatable({
		ent = ent,
		vector = self.data.Vector,
		entity_library = self.data.Entity,
		bind_arg = self:BindArg(self.BindArg, self),
		new_entity = self:BindArg(self.NewEntity, self),
		c_get_client_entity = self.CHelpers.GetClientEntity,
		c_get_eye_position = self.CHelpers.GetEyePosition,
		normalized = self:BindArg(self.NormalizedYaw, self)
	}, {
		__boolean = function(self)
			return self.ent ~= nil
		end,

		__tostring = function(self)
			return ("userdata: %s"):format(self.ent)
		end,

		__index = {
			get_index = function(self)
				return self.ent
			end,

			is_valid = function(self)
				return self.ent ~= nil
			end,

			get_team = function(self)
				return self:get_prop("m_iTeamNum")
			end,

			is_enemy = function(self)
				return entity.is_enemy(self:get_index())
			end,

			get_helpers = function(self)
				return self.entity_library(self:get_index())
			end,

			is_dormant = function(self)
				return entity.is_dormant(self:get_index())
			end,

			set_prop = function(self, ...)
				return entity.set_prop(self:get_index(), ...)
			end,

			get_classname = function(self)
				return entity.get_classname(self:get_index())
			end,

			get_client_entity = function(self)
				return self.c_get_client_entity(self:get_index())
			end,

			get_name = function(self)
				return entity.get_player_name(self:get_index())
			end,

			is_alive = function(self)
				return self.ent and entity.is_alive(self:get_index())
			end,

			get_origin = function(self)
				return self.vector(entity.get_origin(self:get_index()))
			end,

			get_resource = function(self, ...)
				local resource = entity.get_player_resource()
				return entity.get_prop(resource, ..., self:get_index())
			end,

			get_velocity = function(self)
				return self:get_prop("m_vecVelocity"):length2d()
			end,

			get_jumping = function(self)
				return bit.band(self:get_prop("m_fFlags"), 1) == 0
			end,

			get_ducking = function(self)
				return bit.band(self:get_prop("m_fFlags"), 2) == 2
			end,

			is_player = function(self)
				return entity.get_classname(self:get_index()) == "CBasePlayer"
			end,

			get_hitbox_position = function(self, index)
				return self.vector(entity.hitbox_position(self:get_index(), index))
			end,

			get_player_weapon = function(self)
				return self.new_entity(entity.get_player_weapon(self:get_index()))
			end,

			get_prop = function(self, ...)
				local this_name = table.concat({...})
				if this_name:find("vec") or this_name:find("ang") then
					return self.vector(entity.get_prop(self:get_index(), ...))
				end

				return entity.get_prop(self:get_index(), ...)
			end,

			get_weapon_index = function(self)
				if not self.ent then
					return
				end

				return entity.get_prop(self:get_index(), "m_iItemDefinitionIndex")
			end,

			get_body_yaw = function(self)
				local c_entity = self.entity_library(self.ent)
				local anim_state = c_entity:get_anim_state()
				if not anim_state or not anim_state.goal_feet_yaw or not anim_state.eye_angles_y then
					return 0
				end

				return self.normalized(anim_state.goal_feet_yaw - anim_state.eye_angles_y)
			end,

			get_eye_position = function(self)
				local SelfPointer = self.c_get_client_entity(self:get_index())
				if SelfPointer ~= ffi.NULL then
					local Successed, EyePosition = pcall(self.c_get_eye_position, SelfPointer)
					if Successed and EyePosition and EyePosition ~= ffi.NULL then
						return self.vector(EyePosition.x, EyePosition.y, EyePosition.z)
					end
				end

				return false
			end
		}
	})
end

MOISTEN.__index.GetTickcountSwitch = function(self, ticks)
	return self.data.UpdateTickcountState[ticks]
end

MOISTEN.__index.Vector2DValid = function(self, vector, radius)
	return vector and vector.x ~= 0 and vector.y ~= 0 and not self:OffScreen(vector, radius)
end

MOISTEN.__index.OffScreen = function(self, position, radius)
	local vecMax = self.data.Vector(unpack(self.data.ScreenSize)) + self.data.Vector(radius or 0, radius or 0)
	return (position.x < 0 or position.x > vecMax.x) or (position.y < 0 or position.y > vecMax.y)
end

MOISTEN.__index.UpdateUseKey = function(self, state)
	if self.data.BindState ~= state then
		self.data.BindState = state
		if not state then
			client.exec("-use")
		end

		client.exec(state and "bind e +use" or "unbind e")
	end
end

MOISTEN.__index.MicroMove = function(self, cmd)
	local local_player = self:NewEntity(entity.get_local_player())
	if not local_player:is_valid() or not local_player:is_alive() then
		return
	end

	local Weapon = local_player:get_player_weapon()
	if Weapon and Weapon:is_valid() then
		local ActivateIsThrowWeapon = self:Contains({
			"CSnowball",
			"CFlashbang",
			"CHEGrenade",
			"CDecoyGrenade",
			"CSensorGrenade",
			"CSmokeGrenade",
			"CMolotovGrenade",
			"CIncendiaryGrenade"
		}, Weapon:get_classname())
		if ActivateIsThrowWeapon then
			return
		end
	end

	if (math.abs(cmd.forwardmove) > 1) or (math.abs(cmd.sidemove) > 1) or cmd.in_jump == 1 then
		return
	end

	cmd.forwardmove = 0.000000000000000000000000000000001
	cmd.in_forward = 1
end

MOISTEN.__index.ExtrapolatePosition = function(self, player, origin, ticks)
	if not player:is_alive() then
		return
	end

	local Velocity = player:get_prop("m_vecVelocity")
	return origin + ((Velocity * globals.tickinterval()) * ticks)
end

MOISTEN.__index.UpdateTickcount = function(self, tickcount)
	for index = 2, 128 do
		if self.data.UpdateTickcountState[index] == nil then
			self.data.UpdateTickcountState[index] = false
		end

		if tickcount % index == 0 then
			self.data.UpdateTickcountState[index] = not self.data.UpdateTickcountState[index]
		end
	end
end

MOISTEN.__index.CalculateYaw = function(self, local_angle, enemy_angle)
	if not local_angle or not enemy_angle then
		return 0
	end

	local xdelta = local_angle.x - enemy_angle.x
	local ydelta = local_angle.y - enemy_angle.y
	local relativeyaw = self:NormalizedYaw(math.atan(ydelta / xdelta) * 180 / math.pi)
	if xdelta >= 0 then
		relativeyaw = self:NormalizedYaw(relativeyaw + 180)
	end

	return relativeyaw
end

MOISTEN.__index.GetLerpAnimation = function(self, key, set_var)
	if not self.data.CachedLerp[key] then
		self.data.CachedLerp[key] = 0
	end

	if set_var then
		self.data.CachedLerp[key] = set_var
	end

	return self.data.CachedLerp[key]
end

MOISTEN.__index.GetStaticTargetAnimation = function(self, key, set_var)
	if not self.data.CachedStaticSingleAnimation[key] then
		self.data.CachedStaticSingleAnimation[key] = 0
	end

	if set_var then
		self.data.CachedStaticSingleAnimation[key] = set_var
	end

	return self.data.CachedStaticSingleAnimation[key]
end

MOISTEN.__index.GetTimerSwitch = function(self, timer)
	if not self.data.UpdateTimerState[timer] then
		self.data.UpdateTimerState[timer] = {
			switch = false,
			timer = globals.curtime()
		}
	end

	if math.abs(globals.curtime() - self.data.UpdateTimerState[timer].timer) >= timer then
		self.data.UpdateTimerState[timer].timer = globals.curtime()
		self.data.UpdateTimerState[timer].switch = not self.data.UpdateTimerState[timer].switch
	end

	return self.data.UpdateTimerState[timer].switch
end

MOISTEN.__index.NewLerp = function(self, current, target, animation, key)
	if not self.data.CachedLerp[key] then
		self.data.CachedLerp[key] = current
	end

	local frametime = globals.frametime() * (animation / 10)
	if math.abs(target - self.data.CachedLerp[key]) < 0.001 then
		self.data.CachedLerp[key] = target
		return target
	end

	self.data.CachedLerp[key] = self:Lerp(self.data.CachedLerp[key], target, frametime)
	return target > self.data.CachedLerp[key] and math.min(self.data.CachedLerp[key], target) or math.max(self.data.CachedLerp[key], target)
end

MOISTEN.__index.GetTimerSwitchWays = function(self, timers, data)
	local CachedKey = ""
	for index, this in pairs(timers) do
		CachedKey = ("%s %s %s"):format(CachedKey, this, data[index])
	end

	if not self.data.ConditionTimerState[CachedKey] then
		self.data.ConditionTimerState[CachedKey] = {
			stage = 1,
			timer = globals.curtime()
		}
	end

	if math.abs(globals.curtime() - self.data.ConditionTimerState[CachedKey].timer) >= timers[self.data.ConditionTimerState[CachedKey].stage] then
		self.data.ConditionTimerState[CachedKey].timer = globals.curtime()
		self.data.ConditionTimerState[CachedKey].stage = self.data.ConditionTimerState[CachedKey].stage + 1
		if self.data.ConditionTimerState[CachedKey].stage > #data then
			self.data.ConditionTimerState[CachedKey].stage = 1
		end
	end

	return data[self.data.ConditionTimerState[CachedKey].stage]
end

MOISTEN.__index.CreateStaticResetAnimation = function(self, min, max, condition, animation, key)
	local math_vars = self:GetMathVars(min, max)
	if not self.data.CachedStaticConditionAnimation[key] then
		self.data.CachedStaticConditionAnimation[key] = {
			Condition = nil,
			Var = math_vars.min
		}
	end

	local frametime = globals.frametime() * (animation / 10)
	if self.data.CachedStaticConditionAnimation[key].Condition ~= condition then
		self.data.CachedStaticConditionAnimation[key].Var = math_vars.min
		self.data.CachedStaticConditionAnimation[key].Condition = condition
	end

	local delta = math_vars.max > self.data.CachedStaticConditionAnimation[key].Var and frametime or - frametime
	if math.abs(math_vars.max - self.data.CachedStaticConditionAnimation[key].Var) < frametime then
		return math_vars.max
	end

	self.data.CachedStaticConditionAnimation[key].Var = self.data.CachedStaticConditionAnimation[key].Var + delta
	return self:Clamp(self.data.CachedStaticConditionAnimation[key].Var, math_vars.min, math_vars.max)
end

MOISTEN.__index.CreateStaticTargetAnimation = function(self, current, target, animation, key)
	if not self.data.CachedStaticSingleAnimation[key] then
		self.data.CachedStaticSingleAnimation[key] = current
	end

	local frametime = globals.frametime() * (animation / 10)
	local delta = target > self.data.CachedStaticSingleAnimation[key] and frametime or - frametime
	if math.abs(target - self.data.CachedStaticSingleAnimation[key]) < frametime then
		return target
	end

	self.data.CachedStaticSingleAnimation[key] = self.data.CachedStaticSingleAnimation[key] + delta
	return target > self.data.CachedStaticSingleAnimation[key] and math.min(self.data.CachedStaticSingleAnimation[key], target) or math.max(self.data.CachedStaticSingleAnimation[key], target)
end

MOISTEN.__index.Update = function(self, min, max, between, key)
	local between = math.abs(between)
	local is_reserved = min < 0 and max < 0
	local math_vars = self:GetMathVars(min, max)
	if not self.data.UpdateCached[key] then
		self.data.UpdateCached[key] = is_reserved and math_vars.max or math_vars.min
	end

	if globals.chokedcommands() == 0 then
		if is_reserved then
			self.data.UpdateCached[key] = self.data.UpdateCached[key] <= math_vars.min and math_vars.max or (self.data.UpdateCached[key] - between)
		elseif not is_reserved then
			self.data.UpdateCached[key] = self.data.UpdateCached[key] >= math_vars.max and math_vars.min or (self.data.UpdateCached[key] + between)
		end
	end

	return self:Clamp(self.data.UpdateCached[key], math_vars.min, math_vars.max)
end

MOISTEN.__index.Cycle = function(self, min, max, between, key)
	local between = math.abs(between)
	local is_reserved = min < 0 and max < 0
	local math_vars = self:GetMathVars(min, max)
	if not self.data.CycleCached[key] then
		self.data.CycleCached[key] = {
			reserved = false,
			var = is_reserved and math_vars.max or math_vars.min
		}
	end

	if globals.chokedcommands() == 0 then
		self.data.CycleCached[key].var = self.data.CycleCached[key].var + (self.data.CycleCached[key].reserved and between or - between)
		if self.data.CycleCached[key].var > math_vars.max then
			self.data.CycleCached[key].reserved = false
			self.data.CycleCached[key].var = math_vars.max
		elseif self.data.CycleCached[key].var < math_vars.min then
			self.data.CycleCached[key].reserved = true
			self.data.CycleCached[key].var = math_vars.min
		end
	end

	return self.data.CycleCached[key].var
end

MOISTEN.__index.CreateWays = function(self, ways, angles)
	local angles_history = {}
	local stage = self:ToInteger(ways / 2)
	local angle = (math.abs(angles) / ways) / 2
	local cached_key = ("%s%s"):format(ways, angles)
	if not self.data.WaysAnglesStage[cached_key] then
		self.data.WaysAnglesStage[cached_key]  = - stage
	end

	for index = - stage, stage do
		if index == 0 then
			angles_history[index] = 0
		elseif index < 0 then
			angles_history[index] = (index * angle) - (angle * 2)
		elseif index > 0 then
			angles_history[index] = (index * angle) + (angle * 2)
		end
	end

	if globals.chokedcommands() == 0 then
		self.data.WaysAnglesStage[cached_key] = self.data.WaysAnglesStage[cached_key] >= stage and - stage or (self.data.WaysAnglesStage[cached_key] + 1)
	end

	return angles_history[self.data.WaysAnglesStage[cached_key]]
end

MOISTEN.__index.AutomaticSaveConfig = function(self)
	if not self.Elements.MasterSwitch:get() or not self.Elements.Configs.AutomaticSaveConfig:get() then
		return
	end

	local ConfigPackage = self:GetPackages(self.Elements)
	if not self:Contains(self.data.Configs, self.data.AutoSaveConfigName) then
		table.insert(self.data.Configs, self.data.AutoSaveConfigName)
		self.Elements.Configs.ConfigsList:update(self.data.Configs)
	end

	self.data.ConfigsList[self.data.AutoSaveConfigName] = self.data.Base64.encode(json.stringify(ConfigPackage))
end

MOISTEN.__index.ExportConfig = function(self)
	local ConfigPackage = self:GetPackages(self.Elements)
	self.data.NotifyLogIndex = self.data.NotifyLogIndex + 1
	self.data.Clipboard.set(self.data.Base64.encode(json.stringify(ConfigPackage)))
	client.color_log(self.data.ConfigLoadSuccessedColor[1], self.data.ConfigLoadSuccessedColor[2], self.data.ConfigLoadSuccessedColor[3], ("[%s]Config Export Successfully !"):format(self.data.ScriptName))
	table.insert(self.data.NotifyCached, {
		Switch = false,
		CurrentIndex = false,
		Timer = self:GetTimeScale(),
		Index = self.data.NotifyLogIndex,
		ConfigsName = "Config: Clipboard",
		AnimationColor = self.data.LightPinkedColor,
		UserName = ("User: %s"):format(self.data.SelfName),
		Text = "Save Successfully, Data Export To Clipboard",
		Title = ("MOISTEN%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN")),
		Svg = {
			Size = self.data.Vector(48, 48),
			Texture = self.data.SettingsSvg
		}
	})
end

MOISTEN.__index.ImportConfig = function(self)
	self.data.ConfigPackage = {}
	self:WritePackage(self.Elements)
	local Configs = self.data.Clipboard.get()
	self.data.NotifyLogIndex = self.data.NotifyLogIndex + 1
	if not Configs then
		client.error_log(("[%s] Config Failed Import: The Clipboard Data Is MOISTEN Data"):format(self.data.ScriptName))
		table.insert(self.data.NotifyCached, {
			Switch = false,
			CurrentIndex = false,
			Timer = self:GetTimeScale(),
			Text = "Config Import Falied",
			Index = self.data.NotifyLogIndex,
			UserName = ("User: %s"):format(self.data.SelfName),
			AnimationColor = self.data.NotifyWarningAnimationColor,
			ConfigsName = ("Reason: %s"):format(self:RgbaToHexText(self.data.ErrorNotifyColor, "The Clipboard Data Is MOISTEN Data")),
			Title = ("MOISTEN%s%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN -> "), self:RgbaToHexText(self.data.ErrorNotifyColor, "error")),
			Svg = {
				Size = self.data.Vector(48, 48),
				Texture = self.data.SettingsSvg
			}
		})

		return
	end

	if Configs:len() <= 0 then
		client.error_log(("[%s] Config Failed Import: The Clipboard Is Empty"):format(self.data.ScriptName))
		table.insert(self.data.NotifyCached, {
			Switch = false,
			CurrentIndex = false,
			Timer = self:GetTimeScale(),
			Text = "Config Import Falied",
			Index = self.data.NotifyLogIndex,
			UserName = ("User: %s"):format(self.data.SelfName),
			AnimationColor = self.data.NotifyWarningAnimationColor,
			ConfigsName = ("Reason: %s"):format(self:RgbaToHexText(self.data.ErrorNotifyColor, "The Clipboard Is Empty")),
			Title = ("MOISTEN%s%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN -> "), self:RgbaToHexText(self.data.ErrorNotifyColor, "error")),
			Svg = {
				Size = self.data.Vector(48, 48),
				Texture = self.data.SettingsSvg
			}
		})

		return
	end

	local Successed, JsonData = pcall(self.data.Base64.decode, Configs)
	if not Successed or not JsonData then
		client.error_log(("[%s] Config Failed Import: The Config Is MOISTEN Config, Please Check Your Clipboard"):format(self.data.ScriptName))
		table.insert(self.data.NotifyCached, {
			Switch = false,
			CurrentIndex = false,
			Timer = self:GetTimeScale(),
			Text = "Config Import Falied",
			Index = self.data.NotifyLogIndex,
			UserName = ("User: %s"):format(self.data.SelfName),
			AnimationColor = self.data.NotifyWarningAnimationColor,
			ConfigsName = ("Reason: %s"):format(self:RgbaToHexText(self.data.ErrorNotifyColor, "This Config Is MOISTEN Config")),
			Title = ("MOISTEN%s%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN -> "), self:RgbaToHexText(self.data.ErrorNotifyColor, "error")),
			Svg = {
				Size = self.data.Vector(48, 48),
				Texture = self.data.SettingsSvg
			}
		})

		return
	end

	local Successed, Data = pcall(json.parse, JsonData)
	if not Successed or not Data then
		client.error_log(("[%s] Config Failed Import: The Config Is MOISTEN Config, Please Check Your Clipboard"):format(self.data.ScriptName))
		table.insert(self.data.NotifyCached, {
			Switch = false,
			CurrentIndex = false,
			Timer = self:GetTimeScale(),
			Text = "Config Import Falied",
			Index = self.data.NotifyLogIndex,
			UserName = ("User: %s"):format(self.data.SelfName),
			AnimationColor = self.data.NotifyWarningAnimationColor,
			ConfigsName = ("Reason: %s"):format(self:RgbaToHexText(self.data.ErrorNotifyColor, "This Config Is MOISTEN Config")),
			Title = ("MOISTEN%s%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN -> "), self:RgbaToHexText(self.data.ErrorNotifyColor, "error")),
			Svg = {
				Size = self.data.Vector(48, 48),
				Texture = self.data.SettingsSvg
			}
		})

		return
	end

	for Key, Elements in pairs(self.data.ConfigPackage) do
		local Value = Data[Key]
		if Value and type(Value) == "table" and Value[1] and Value[1] == "Color" then
			Elements:set(unpack(Value[2]))
		elseif Value then
			Elements:set(Value)
		end
	end

	self:HandleMain()
	client.color_log(self.data.ConfigLoadSuccessedColor[1], self.data.ConfigLoadSuccessedColor[2], self.data.ConfigLoadSuccessedColor[3], ("[%s]Config Import Successfully !"):format(self.data.ScriptName))
	table.insert(self.data.NotifyCached, {
		Switch = false,
		CurrentIndex = false,
		Timer = self:GetTimeScale(),
		Index = self.data.NotifyLogIndex,
		ConfigsName = "Config: Clipboard",
		AnimationColor = self.data.LightPinkedColor,
		UserName = ("User: %s"):format(self.data.SelfName),
		Text = "Load Successfully, Data Import From Clipboard",
		Title = ("MOISTEN%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN")),
		Svg = {
			Size = self.data.Vector(48, 48),
			Texture = self.data.SettingsSvg
		}
	})
end

MOISTEN.__index.DeleteConfig = function(self)
	self.data.NotifyLogIndex = self.data.NotifyLogIndex + 1
	local ConfigIndex = self.Elements.Configs.ConfigsList:get()
	if not ConfigIndex then
		return
	end

	local ConfigName = self.data.Configs[math.max(1, ConfigIndex + 1)]
	if not self.data.ConfigsList[ConfigName] then
		client.error_log(("[%s] Config Failed Delete: This Config Is MOISTEN"):format(self.data.ScriptName))
		table.insert(self.data.NotifyCached, {
			Switch = false,
			CurrentIndex = false,
			Timer = self:GetTimeScale(),
			Text = "Config Delete Falied",
			Index = self.data.NotifyLogIndex,
			UserName = ("User: %s"):format(self.data.SelfName),
			AnimationColor = self.data.NotifyWarningAnimationColor,
			ConfigsName = ("Reason: %s"):format(self:RgbaToHexText(self.data.ErrorNotifyColor, "This Config Is MOISTEN Config")),
			Title = ("MOISTEN%s%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN -> "), self:RgbaToHexText(self.data.ErrorNotifyColor, "error")),
			Svg = {
				Size = self.data.Vector(48, 48),
				Texture = self.data.SettingsSvg
			}
		})

		return
	end

	self.data.ConfigsList[ConfigName] = nil
	for index, name in pairs(self.data.Configs) do
		if name == ConfigName then
			table.remove(self.data.Configs, index)
		end
	end

	self:HandleMain()
	self.Elements.Configs.ConfigsList:update(self.data.Configs)
	client.color_log(self.data.ConfigLoadSuccessedColor[1], self.data.ConfigLoadSuccessedColor[2], self.data.ConfigLoadSuccessedColor[3], ("[%s]Config Delete Successfully !"):format(self.data.ScriptName))
	table.insert(self.data.NotifyCached, {
		Switch = false,
		CurrentIndex = false,
		Timer = self:GetTimeScale(),
		Index = self.data.NotifyLogIndex,
		AnimationColor = self.data.LightPinkedColor,
		ConfigsName = ("Config: %s"):format(ConfigName),
		UserName = ("User: %s"):format(self.data.SelfName),
		Text = "Config Delete Successfully, Data Save To Localtion",
		Title = ("MOISTEN%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN")),
		Svg = {
			Size = self.data.Vector(48, 48),
			Texture = self.data.SettingsSvg
		}
	})
end

MOISTEN.__index.CreateConfig = function(self)
	self.data.NotifyLogIndex = self.data.NotifyLogIndex + 1
	local ConfigName = self.Elements.Configs.ConfigName:get()
	if ConfigName:len() <= 0 then
		client.error_log(("[%s] Config Failed Create: You Cant Create a Empty Name Config"):format(self.data.ScriptName))
		table.insert(self.data.NotifyCached, {
			Switch = false,
			CurrentIndex = false,
			Timer = self:GetTimeScale(),
			Text = "Config Create Falied",
			Index = self.data.NotifyLogIndex,
			UserName = ("User: %s"):format(self.data.SelfName),
			AnimationColor = self.data.NotifyWarningAnimationColor,
			ConfigsName = ("Reason: %s"):format(self:RgbaToHexText(self.data.ErrorNotifyColor, "You Cant Create a Empty Name Config")),
			Title = ("MOISTEN%s%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN -> "), self:RgbaToHexText(self.data.ErrorNotifyColor, "error")),
			Svg = {
				Size = self.data.Vector(48, 48),
				Texture = self.data.SettingsSvg
			}
		})

		return
	end

	if self:Contains(self.data.Configs, ConfigName) then
		client.error_log(("[%s] Config Failed Create: You Cant Create a Already Exists Config"):format(self.data.ScriptName))
		table.insert(self.data.NotifyCached, {
			Switch = false,
			CurrentIndex = false,
			Timer = self:GetTimeScale(),
			Text = "Config Create Falied",
			Index = self.data.NotifyLogIndex,
			UserName = ("User: %s"):format(self.data.SelfName),
			AnimationColor = self.data.NotifyWarningAnimationColor,
			ConfigsName = ("Reason: %s"):format(self:RgbaToHexText(self.data.ErrorNotifyColor, "You Cant Create a Already Exists Config")),
			Title = ("MOISTEN%s%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN -> "), self:RgbaToHexText(self.data.ErrorNotifyColor, "error")),
			Svg = {
				Size = self.data.Vector(48, 48),
				Texture = self.data.SettingsSvg
			}
		})

		return
	end

	self:HandleMain()
	table.insert(self.data.Configs, ConfigName)
	local ConfigPackage = self:GetPackages(self.Elements)
	self.Elements.Configs.ConfigsList:update(self.data.Configs)
	self.data.ConfigsList[ConfigName] = self.data.Base64.encode(json.stringify(ConfigPackage))
	client.color_log(self.data.ConfigLoadSuccessedColor[1], self.data.ConfigLoadSuccessedColor[2], self.data.ConfigLoadSuccessedColor[3], ("[%s]Config Create Successfully !"):format(self.data.ScriptName))
	table.insert(self.data.NotifyCached, {
		Switch = false,
		CurrentIndex = false,
		Timer = self:GetTimeScale(),
		Index = self.data.NotifyLogIndex,
		AnimationColor = self.data.LightPinkedColor,
		ConfigsName = ("Config: %s"):format(ConfigName),
		UserName = ("User: %s"):format(self.data.SelfName),
		Text = "Config Create Successfully, Data Save To Localtion",
		Title = ("MOISTEN%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN")),
		Svg = {
			Size = self.data.Vector(48, 48),
			Texture = self.data.SettingsSvg
		}
	})
end

MOISTEN.__index.SaveConfig = function(self)
	local ConfigPackage = self:GetPackages(self.Elements)
	self.data.NotifyLogIndex = self.data.NotifyLogIndex + 1
	local ConfigIndex = self.Elements.Configs.ConfigsList:get()
	if not ConfigIndex then
		return
	end

	local ConfigName = self.data.Configs[math.max(1, ConfigIndex + 1)]
	if not ConfigName then
		client.error_log(("[%s] Config Failed Save: You Cant Save a MOISTEN Config"):format(self.data.ScriptName))
		table.insert(self.data.NotifyCached, {
			Switch = false,
			CurrentIndex = false,
			Timer = self:GetTimeScale(),
			Text = "Config Save Falied",
			Index = self.data.NotifyLogIndex,
			UserName = ("User: %s"):format(self.data.SelfName),
			AnimationColor = self.data.NotifyWarningAnimationColor,
			ConfigsName = ("Reason: %s"):format(self:RgbaToHexText(self.data.ErrorNotifyColor, "You Cant Save a MOISTEN Config")),
			Title = ("MOISTEN%s%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN -> "), self:RgbaToHexText(self.data.ErrorNotifyColor, "error")),
			Svg = {
				Size = self.data.Vector(48, 48),
				Texture = self.data.SettingsSvg
			}
		})

		return
	end

	self.data.ConfigsList[ConfigName] = self.data.Base64.encode(json.stringify(ConfigPackage))
	client.color_log(self.data.ConfigLoadSuccessedColor[1], self.data.ConfigLoadSuccessedColor[2], self.data.ConfigLoadSuccessedColor[3], ("[%s]Config Save Successfully !"):format(self.data.ScriptName))
	table.insert(self.data.NotifyCached, {
		Switch = false,
		CurrentIndex = false,
		Timer = self:GetTimeScale(),
		Index = self.data.NotifyLogIndex,
		AnimationColor = self.data.LightPinkedColor,
		Text = "Save Successfully, Data Save To Localtion",
		ConfigsName = ("Config: %s"):format(ConfigName),
		UserName = ("User: %s"):format(self.data.SelfName),
		Title = ("MOISTEN%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN")),
		Svg = {
			Size = self.data.Vector(48, 48),
			Texture = self.data.SettingsSvg
		}
	})
end

MOISTEN.__index.LoadConfig = function(self, base_config)
	local Configs = {}
	self.data.ConfigPackage = {}
	self:WritePackage(self.Elements)
	local BaseConfigs = base_config
	self.data.NotifyLogIndex = self.data.NotifyLogIndex + 1
	local ConfigIndex = self.Elements.Configs.ConfigsList:get()
	if not ConfigIndex then
		return
	end

	local ConfigName = self.data.Configs[math.max(1, ConfigIndex + 1)]
	if not BaseConfigs or type(BaseConfigs) ~= "string" then
		if not self.data.ConfigsList[ConfigName] then
			client.error_log(("[%s] Config Failed Load: You Cant Load a MOISTEN Config"):format(self.data.ScriptName))
			table.insert(self.data.NotifyCached, {
				Switch = false,
				CurrentIndex = false,
				Timer = self:GetTimeScale(),
				Text = "Config Load Falied",
				Index = self.data.NotifyLogIndex,
				UserName = ("User: %s"):format(self.data.SelfName),
				AnimationColor = self.data.NotifyWarningAnimationColor,
				ConfigsName = ("Reason: %s"):format(self:RgbaToHexText(self.data.ErrorNotifyColor, "You Cant Load a MOISTEN Config")),
				Title = ("MOISTEN%s%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN -> "), self:RgbaToHexText(self.data.ErrorNotifyColor, "error")),
				Svg = {
					Size = self.data.Vector(48, 48),
					Texture = self.data.SettingsSvg
				}
			})

			return
		end

		BaseConfigs = self.data.ConfigsList[ConfigName]
	end

	if BaseConfigs:len() <= 0 then
		if type(base_config) ~= "string" then
			client.error_log(("[%s] Config Failed Load: You Cant Load a Empty Config"):format(self.data.ScriptName))
			table.insert(self.data.NotifyCached, {
				Switch = false,
				CurrentIndex = false,
				Timer = self:GetTimeScale(),
				Text = "Config Load Falied",
				Index = self.data.NotifyLogIndex,
				UserName = ("User: %s"):format(self.data.SelfName),
				AnimationColor = self.data.NotifyWarningAnimationColor,
				ConfigsName = ("Reason: %s"):format(self:RgbaToHexText(self.data.ErrorNotifyColor, "You Cant Load a Empty Config")),
				Title = ("MOISTEN%s%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN -> "), self:RgbaToHexText(self.data.ErrorNotifyColor, "error")),
				Svg = {
					Size = self.data.Vector(48, 48),
					Texture = self.data.SettingsSvg
				}
			})
		end

		return
	end

	local Successed, JsonData = pcall(self.data.Base64.decode, BaseConfigs)
	if not Successed or not JsonData then
		if type(base_config) ~= "string" then
			client.error_log(("[%s] Config Failed Load: Please Check or Override This Current Config"):format(self.data.ScriptName))
			table.insert(self.data.NotifyCached, {
				Switch = false,
				CurrentIndex = false,
				Timer = self:GetTimeScale(),
				Text = "Config Load Falied",
				Index = self.data.NotifyLogIndex,
				UserName = ("User: %s"):format(self.data.SelfName),
				AnimationColor = self.data.NotifyWarningAnimationColor,
				ConfigsName = ("Reason: %s"):format(self:RgbaToHexText(self.data.ErrorNotifyColor, "You Cant Load a MOISTEN Data Config")),
				Title = ("MOISTEN%s%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN -> "), self:RgbaToHexText(self.data.ErrorNotifyColor, "error")),
				Svg = {
					Size = self.data.Vector(48, 48),
					Texture = self.data.SettingsSvg
				}
			})
		end

		return
	end

	local Successed, Data = pcall(json.parse, JsonData)
	if not Successed or not Data then
		if type(base_config) ~= "string" then
			client.error_log(("[%s] Config Failed Load: Please Check or Override This Current Config"):format(self.data.ScriptName))
			table.insert(self.data.NotifyCached, {
				Switch = false,
				CurrentIndex = false,
				Timer = self:GetTimeScale(),
				Text = "Config Load Falied",
				Index = self.data.NotifyLogIndex,
				UserName = ("User: %s"):format(self.data.SelfName),
				AnimationColor = self.data.NotifyWarningAnimationColor,
				ConfigsName = ("Reason: %s"):format(self:RgbaToHexText(self.data.ErrorNotifyColor, "You Cant Load a MOISTEN Data Config")),
				Title = ("MOISTEN%s%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN -> "), self:RgbaToHexText(self.data.ErrorNotifyColor, "error")),
				Svg = {
					Size = self.data.Vector(48, 48),
					Texture = self.data.SettingsSvg
				}
			})
		end

		return
	end

	for Key, Elements in pairs(self.data.ConfigPackage) do
		local Value = Data[Key]
		if self:IsElement(Elements) then
			if Value and type(Value) == "table" and Value[1] and Value[1] == "Color" then
				Elements:set(unpack(Value[2]))
			end
		end
	end

	self:HandleMain()
	if type(base_config) ~= "string" then
		client.color_log(self.data.ConfigLoadSuccessedColor[1], self.data.ConfigLoadSuccessedColor[2], self.data.ConfigLoadSuccessedColor[3], ("[%s]Config Load Successfully !"):format(self.data.ScriptName))
		table.insert(self.data.NotifyCached, {
			Switch = false,
			CurrentIndex = false,
			Timer = self:GetTimeScale(),
			Index = self.data.NotifyLogIndex,
			AnimationColor = self.data.LightPinkedColor,
			ConfigsName = ("Config: %s"):format(ConfigName),
			UserName = ("User: %s"):format(self.data.SelfName),
			Text = "Load Successfully, Data Load From Localtion",
			Title = ("MOISTEN%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN")),
			Svg = {
				Size = self.data.Vector(48, 48),
				Texture = self.data.SettingsSvg
			}
		})
	end
end

local ent = require "gamesense/entity" or error("Failed to load entity | https://gamesense.pub/forums/viewtopic.php?id=27529"),
client.register_esp_flag("AT", 255, 255, 255, function(ent)
    if ent == client.current_threat() then
        return true
    end
end)

MOISTEN.__index.GetPlayerState = function(self)
	local local_player = self:NewEntity(entity.get_local_player())
	if not local_player:is_valid() or not local_player:is_alive() then
		return
	end

	local PlayerState = 1
	local Velocity = local_player:get_velocity()
	local Ducking = local_player:get_ducking()
	local Jumping = local_player:get_jumping()
	local undistinction = self.Elements.Misc.UnDistinctionFakelag:get()
	local onshot = ui.get(self.References.onshot[1]) and ui.get(self.References.onshot[2])
	local Elements = self.Elements.AntiAim.Custom[local_player:get_team() == 2 and 1 or 2]
	local SlowWalk = ui.get(self.References.slow_walk[1]) and ui.get(self.References.slow_walk[2])
	local DoubleTap = (ui.get(self.References.doubletap[1]) and ui.get(self.References.doubletap[2])) or undistinction
	if Elements[2].Enabled:get() and not Jumping and not Ducking and Velocity < 1.1 and DoubleTap then
		PlayerState = 2
	end

	if Elements[3].Enabled:get() and not SlowWalk and not Jumping and not Ducking and Velocity > 1.1 and DoubleTap then
		PlayerState = 3
	end

	if Elements[4].Enabled:get() and Velocity > 1.1 and SlowWalk and not Jumping and not Ducking and DoubleTap then
		PlayerState = 4
	end

	if Elements[5].Enabled:get() and Jumping and not Ducking and DoubleTap then
		PlayerState = 5
	end

	if Elements[6].Enabled:get() and Jumping and Ducking and DoubleTap then
		PlayerState = 6
	end

	if Elements[7].Enabled:get() and Ducking and not Jumping and Velocity < 1.1 and DoubleTap then
		PlayerState = 7
	end

	if Elements[8].Enabled:get() and Ducking and not Jumping and Velocity > 1.1 and DoubleTap then
		PlayerState = 8
	end

	if Elements[9].Enabled:get() and onshot and not DoubleTap then
		PlayerState = 9
	end

	if Elements[10].Enabled:get() and not onshot and not DoubleTap then
		PlayerState = 10
	end

	return PlayerState
end

MOISTEN.__index.ManualAntiAim = function(self)
	local PrevManualState = self.data.ManualState
	self.Elements.AntiAim.ManualLeft:set("On hotkey")
	self.Elements.AntiAim.ManualRight:set("On hotkey")
	self.Elements.AntiAim.ManualForward:set("On hotkey")
	local LeftState, BackwardState, RightState, ForwardState = self.Elements.AntiAim.ManualLeft:get(), self.Elements.AntiAim.ManualBack:get(), self.Elements.AntiAim.ManualRight:get(), self.Elements.AntiAim.ManualForward:get()
	if LeftState == self.data.ManualSide.Left and RightState == self.data.ManualSide.Right and BackwardState == self.data.ManualSide.Back and ForwardState == self.data.ManualSide.Forward then
		return
	end

	self.data.ManualSide.Left, self.data.ManualSide.Right, self.data.ManualSide.Back, self.data.ManualSide.Forward = LeftState, RightState, BackwardState, ForwardState
	if (LeftState and PrevManualState == 1) or (RightState and PrevManualState == 2) or (ForwardState and PrevManualState == 3) or (BackwardState and PrevManualState == 4) then
		self.data.ManualState = 0
		return
	end

	if LeftState and PrevManualState ~= 1 then
		self.data.ManualState = 1
	end

	if RightState and PrevManualState ~= 2 then
		self.data.ManualState = 2
	end

	if ForwardState and PrevManualState ~= 3 then
		self.data.ManualState = 3
	end

	if BackwardState and PrevManualState ~= 4 then
		self.data.ManualState = 4
	end
end

MOISTEN.__index.CanAttack = function(self, player, only_fire, adder)
	if not player or not player:is_alive() then
		return false
	end

	local ActiveWeapon = player:get_player_weapon()
	if not ActiveWeapon or not ActiveWeapon:is_valid() then
		return false
	end

	local NextAttack = player:get_prop("m_flNextAttack")
	local WeaponIndex = ActiveWeapon:get_weapon_index()
	local SimulationTme = player:get_prop("m_flSimulationTime")
	local PrimaryAttack = ActiveWeapon:get_prop("m_flNextPrimaryAttack")
	local SecondaryAttack = ActiveWeapon:get_prop("m_flNextSecondaryAttack")
	if not WeaponIndex or not NextAttack or not PrimaryAttack or not SecondaryAttack then
		return false
	end

	if WeaponIndex == 64 then
		return SimulationTme > PrimaryAttack
	end

	return SimulationTme > (only_fire and (PrimaryAttack + (adder or 0)) or math.max(NextAttack, PrimaryAttack, SecondaryAttack))
end

MOISTEN.__index.RectangleOutline = function(self, x, y, w, h, round, thickness, color, settings, round_percentage)
	if color[4] <= 0 or thickness <= 0 then
		return
	end

	local Radius = math.min(w / 2, h / 2, round)
	local Condition = settings or {true, true, true, true, true, true}
	if Radius == 0 then
		renderer.rectangle(x, y, w, thickness, color[1], color[2], color[3], color[4])
		renderer.rectangle(x, y + h - thickness, w, thickness, color[1], color[2], color[3], color[4])
	else
		local RoundPercentage = round_percentage or 0.25
		local RoundRadiusPercentage = RoundPercentage / 0.25
		if Condition[1] then
			renderer.rectangle(x + Radius, y, w - Radius * 2, thickness, color[1], color[2], color[3], color[4])
		end

		if Condition[2] then
			renderer.rectangle(x + Radius, y + h - thickness, w - Radius * 2, thickness, color[1], color[2], color[3], color[4])
		end

		if Condition[3] or Condition[1] then
			renderer.circle_outline(x + Radius, y + Radius, color[1], color[2], color[3], color[4], Radius, 180, RoundPercentage, thickness)
		end

		if Condition[4] or Condition[2] then
			renderer.circle_outline(x + Radius, y + h - Radius, color[1], color[2], color[3], color[4], Radius, 90 + ((1 - RoundRadiusPercentage) * 90), RoundPercentage, thickness)
		end

		if Condition[5] or Condition[1] then
			renderer.circle_outline(x + w - Radius, y + Radius, color[1], color[2], color[3], color[4], Radius, - 90 + ((1 - RoundRadiusPercentage) * 90), RoundPercentage, thickness)
		end

		if Condition[6] or Condition[2] then
			renderer.circle_outline(x + w - Radius, y + h - Radius, color[1], color[2], color[3], color[4], Radius, 0, RoundPercentage, thickness)
		end

		if Condition[3] or Condition[4] then
			renderer.rectangle(x, y + Radius, thickness, h - Radius * 2, color[1], color[2], color[3], color[4])
		end

		if Condition[5] or Condition[6] then
			renderer.rectangle(x + w - thickness, y + Radius, thickness, h - Radius * 2, color[1], color[2], color[3], color[4])
		end
	end
end

MOISTEN.__index.RenderRoundRectangle = function(self, x, y, w, h, radius, color)
	if color[4] <= 0 then
		return
	end

	renderer.rectangle(x, y + radius, radius, h - radius * 2, color[1], color[2], color[3], color[4])
	renderer.rectangle(x + radius, y, w - radius * 2, radius, color[1], color[2], color[3], color[4])
	renderer.circle(x + radius, y + radius, color[1], color[2], color[3], color[4], radius, 180, 0.25)
	renderer.circle(x + radius, y + h - radius, color[1], color[2], color[3], color[4], radius, 270, 0.25)
	renderer.rectangle(x + radius, y + h - radius, w - radius * 2, radius, color[1], color[2], color[3], color[4])
	renderer.rectangle(x + radius, y + radius, w - radius * 2, h - radius * 2, color[1], color[2], color[3], color[4])
	renderer.circle(x + w - radius, y + radius, color[1], color[2], color[3], color[4], radius, 90, 0.25)
	renderer.circle(x + w - radius, y + h - radius, color[1], color[2], color[3], color[4], radius, 0, 0.25)
	renderer.rectangle(x + w - radius, y + radius, radius, h - radius * 2, color[1], color[2], color[3], color[4])
end

MOISTEN.__index.RenderLeftOutline = function(self, x, y, w, h, radius, color)
	if color[4] <= 0 then
		return
	end

	renderer.rectangle(x + 3, y + radius + 6, 1, h - 6 * 2 - radius * 2, color[1], color[2], color[3], color[4])
	renderer.circle_outline(x + radius + 6, y + radius + 6, color[1], color[2], color[3], color[4], radius + 4, 180, 0.25, 1)
	renderer.circle_outline(x + radius + 6, y + h - radius - 6, color[1], color[2], color[3], color[4], radius + 4, 90, 0.25, 1)
end

MOISTEN.__index.RenderRightOutline = function(self, x, y, w, h, radius, color)
	if color[4] <= 0 then
		return
	end

	renderer.rectangle(x + w - 3, y + radius + 6, 1, h - 6 * 2 - radius * 2, color[1], color[2], color[3], color[4])
	renderer.circle_outline(x + w - radius - 6, y + radius + 6, color[1], color[2], color[3], color[4], radius + 4, 270, 0.25, 1)
	renderer.circle_outline(x + w - radius - 6, y + h - radius - 6, color[1], color[2], color[3], color[4], radius + 4, 0, 0.25, 1)
end

MOISTEN.__index.RenderBackground = function(self, x, y, w, h, color)
	if color[4] <= 0 then
		return
	end

	local GlowCenter = self.data.Vector(20, (h / 2))
	local GlowDifferentModifier = (color[4] / 255) * 22
	for radius = 1, GlowDifferentModifier do
		local radius = radius / 2
		self:RenderLeftOutline(x - radius - 3, y - radius + (h / 4), GlowCenter.x + radius * 2, GlowCenter.y + radius * 2, radius, {color[1], color[2], color[3], (GlowDifferentModifier - radius * 2)})
	end

	for radius = 1, GlowDifferentModifier do
		local radius = radius / 2
		self:RenderRightOutline(x - radius + w - 17, y - radius + (h / 4), GlowCenter.x + radius * 2, GlowCenter.y + radius * 2, radius, {color[1], color[2], color[3], (GlowDifferentModifier - radius * 2)})
	end

	self:RenderRoundRectangle(x, y, w, h, 5, {35, 35, 35, 255 * (color[4] / 255)})
	renderer.rectangle(x + w - 1, y + (h / 4) + 1, 2, (h / 2) - 3, color[1], color[2], color[3], color[4])
	renderer.rectangle(x - 1, y + (h / 4) + 1, 2, (h / 2) - 3, color[1], color[2], color[3], color[4])
end

MOISTEN.__index.RenderGlowText = function(self, x, y, color, flags, max_width, text, glow_radius, ref_text)
	if color[4] <= 0 then
		return
	end

	for index = 1, 8 do
		local text = ref_text or text
		local position = self.data.Vector(x, y)
		local this_color = {color[1], color[2], color[3], color[4] * (self:Clamp(index * glow_radius, 0, 255) / 255)}
		if this_color[4] > 0 then
			renderer.text(position.x - index / 3, position.y, this_color[1], this_color[2], this_color[3], this_color[4], flags, max_width, text)
			renderer.text(position.x, position.y - index / 3, this_color[1], this_color[2], this_color[3], this_color[4], flags, max_width, text)
			renderer.text(position.x, position.y + index / 3, this_color[1], this_color[2], this_color[3], this_color[4], flags, max_width, text)
			renderer.text(position.x + index / 3, position.y, this_color[1], this_color[2], this_color[3], this_color[4], flags, max_width, text)
			renderer.text(position.x - index / 3, position.y - index / 3, this_color[1], this_color[2], this_color[3], this_color[4], flags, max_width, text)
			renderer.text(position.x - index / 3, position.y + index / 3, this_color[1], this_color[2], this_color[3], this_color[4], flags, max_width, text)
			renderer.text(position.x + index / 3, position.y - index / 3, this_color[1], this_color[2], this_color[3], this_color[4], flags, max_width, text)
			renderer.text(position.x + index / 3, position.y  + index / 3, this_color[1], this_color[2], this_color[3], this_color[4], flags, max_width, text)
		end
	end

	renderer.text(x, y, color[1], color[2], color[3], color[4], flags, max_width, text)
end

MOISTEN.__index.RenderGlowOutline = function(self, x, y, w, h, width, rounding, color, settings, round_percentage)
	if color[4] <= 0 then
		return
	end

	for index = 0, width do
		if color[4] * (index / width) > 5 then
			local GlowAccentColor = {color[1], color[2], color[3], color[4] * (index / width) ^ 2}
			if GlowAccentColor[4] > 0 then
				self:RectangleOutline(x + (index - width), y + (index - width), w - (index - width - 1) * 2, h + 2 - (index - width) * 2, rounding + 1 * (width - index + 1), 1, GlowAccentColor, settings, round_percentage)
			end
		end
	end
end

MOISTEN.__index.RenderGlowOutlineRectangle = function(self, x, y, w, h, rounding, glow_thickness, colors, settings, round_percentage)
	if settings then
		local BackgroundAlpha = colors.Background[4] or 255
		if settings[7] and settings[7] == "Blur" then
			renderer.blur(x, y, w, h, BackgroundAlpha / 255, BackgroundAlpha / 255)
		elseif settings[7] and settings[7] == "Rect" then
			self:RenderRoundRectangle(x, y, w, h, rounding, colors.Background)
		end

	elseif not settings then
		self:RenderRoundRectangle(x, y, w, h, rounding, colors.Background)
	end

	self:RectangleOutline(x - 1, y - 1, w + 2, h + 2, rounding, 1, colors.Outline, settings, round_percentage)
	if glow_thickness > 0 then
		self:RenderGlowOutline(x - 2, y - 1, w + 2, h, glow_thickness, rounding, colors.Glow or {colors.Outline[1], colors.Outline[2], colors.Outline[3], 100 * (colors.Outline[4] / 255)}, settings, round_percentage)
	end
end

MOISTEN.__index.TraceClosestPointRay = function(self, ray_from, ray_to, desired_point)
	local direction = ray_to - ray_from
	local ray_length = direction:length()
	local end_point = desired_point - ray_from
	local direction_vector = direction / ray_length
	local direction_between = direction_vector.x * end_point.x + direction_vector.y * end_point.y + direction_vector.z * end_point.z
	if direction_between < 0 then
		return ray_from
	end

	if direction_between > ray_length then
		return ray_to
	end

	return self.data.Vector(
		ray_from.x + direction_vector.x * direction_between,
		ray_from.y + direction_vector.y * direction_between,
		ray_from.z + direction_vector.z * direction_between
	)
end

MOISTEN.__index.UpdateHistory = function(self, position, ticks, key)
	local Tickcount = globals.tickcount()
	if not self.data.CachedPositionHistory[key] then
		self.data.CachedPositionHistory[key] = {
			Positions = {},
			Ticks = Tickcount
		}

		for index = 0, ticks do
			self.data.CachedPositionHistory[key].Positions[index] = position
		end
	end

	if math.abs(Tickcount - self.data.CachedPositionHistory[key].Ticks) > 0 then
		for index = 1, ticks do
			local CurrentIndex = ticks - index
			self.data.CachedPositionHistory[key].Positions[self:Clamp(CurrentIndex + 1, 1, ticks)] = self.data.CachedPositionHistory[key].Positions[self:Clamp(CurrentIndex, 0, ticks)]
		end

		self.data.CachedPositionHistory[key].Ticks = Tickcount
		self.data.CachedPositionHistory[key].Positions[0] = position
	end

	return self.data.CachedPositionHistory[key].Positions
end

MOISTEN.__index.CalculateFreestanding = function(self)
	local local_player = self:NewEntity(entity.get_local_player())
	if not local_player:is_valid() or not local_player:is_alive() or not self.Elements.MasterSwitch:get() then
		return
	end

	local EyePosition = self.data.Vector(client.eye_position())
	local CameraAngles = self.data.Vector(client.camera_angles())
	local TraceFraction = {
		Left = 0,
		Right = 0
	}

	for i = CameraAngles.y - 90, CameraAngles.y + 90, 30 do
		if i ~= CameraAngles.y then
			local Radius = math.rad(i)
			local Side = i < CameraAngles.y and "Left" or "Right"
			local RotationPoint = EyePosition + self.data.Vector(256 * math.cos(Radius), 256 * math.sin(Radius), 0)
			local Fraction, Entindex = client.trace_line(local_player:get_index(), EyePosition.x, EyePosition.y, EyePosition.z, RotationPoint.x, RotationPoint.y, RotationPoint.z)
			TraceFraction[Side] = TraceFraction[Side] + Fraction
		end
	end

	return TraceFraction.Right > TraceFraction.Left
end

MOISTEN.__index.Render3DCircle = function(self, x, y, z, radius, colors, accuracy, width, outline, start_degrees, percentage, removed_radius, style)
	local Width = width or 1
	local CenterPosition = nil
	local PrevScreenLine = nil
	local Between = accuracy or 3
	local Percentage = percentage or 1
	local StartDegrees = start_degrees or 0
	local RenderOutline = outline ~= nil and outline or false
	if colors.Fill then
		CenterPosition = self.data.Vector(renderer.world_to_screen(x, y, z))
	end

	for Angle = StartDegrees, Percentage * 360, Between do
		local RotationRadius = math.rad(Angle)
		local RotationPosition = self.data.Vector(radius * math.cos(RotationRadius) + x, radius * math.sin(RotationRadius) + y, z)
		local ScreenPosition = self.data.Vector(renderer.world_to_screen(RotationPosition.x, RotationPosition.y, RotationPosition.z))
		if style == "Default" then
			if ScreenPosition and (type(removed_radius) ~= "number" or (type(removed_radius) == "number" and not self:OffScreen(ScreenPosition, removed_radius))) and PrevScreenLine and ScreenPosition.x and ScreenPosition.y and PrevScreenLine.x and PrevScreenLine.y then
				if colors.Fill and colors.Fill[4] > 0 and self:Vector2DValid(ScreenPosition, removed_radius or 150) and self:Vector2DValid(PrevScreenLine, removed_radius or 150) and self:Vector2DValid(CenterPosition, removed_radius or 150) then
					renderer.triangle(ScreenPosition.x, ScreenPosition.y, PrevScreenLine.x, PrevScreenLine.y, CenterPosition.x, CenterPosition.y, colors.Fill[1], colors.Fill[2], colors.Fill[3], colors.Fill[4])
				end

				if colors.Circle and colors.Circle[4] > 0 and self:Vector2DValid(ScreenPosition, removed_radius or 150) and self:Vector2DValid(PrevScreenLine, removed_radius or 150) then
					for index = 1, Width do
						local RoundDegree = index - 1
						renderer.line(ScreenPosition.x, ScreenPosition.y - RoundDegree, PrevScreenLine.x, PrevScreenLine.y - RoundDegree, colors.Circle[1], colors.Circle[2], colors.Circle[3], colors.Circle[4])
						renderer.line(ScreenPosition.x - 1, ScreenPosition.y, PrevScreenLine.x - RoundDegree, PrevScreenLine.y, colors.Circle[1], colors.Circle[2], colors.Circle[3], colors.Circle[4])
					end
				end

				if RenderOutline and colors.Outline and colors.Outline[4] > 0 and self:Vector2DValid(ScreenPosition, removed_radius or 150) and self:Vector2DValid(PrevScreenLine, removed_radius or 150) then
					renderer.line(ScreenPosition.x, ScreenPosition.y - Width, PrevScreenLine.x, PrevScreenLine.y - Width, colors.Outline[1], colors.Outline[2], colors.Outline[3], colors.Outline[4])
					renderer.line(ScreenPosition.x, ScreenPosition.y + 1, PrevScreenLine.x, PrevScreenLine.y + 1, colors.Outline[1], colors.Outline[2], colors.Outline[3], colors.Outline[4])
				end
			end

		elseif style == "Overlay" then
			if PrevScreenLine then
				if colors.Fill and colors.Fill[4] > 0 and PrevScreenLine.x then
					renderer.triangle(ScreenPosition.x, ScreenPosition.y, PrevScreenLine.x, PrevScreenLine.y, CenterPosition.x, CenterPosition.y, colors.Fill[1], colors.Fill[2], colors.Fill[3], colors.Fill[4])
				end

				for index = 1, Width do
					local RoundDegree = index - 1
					renderer.line(ScreenPosition.x, ScreenPosition.y - RoundDegree, PrevScreenLine.x, PrevScreenLine.y - RoundDegree, colors.Circle[1], colors.Circle[2], colors.Circle[3], colors.Circle[4])
					renderer.line(ScreenPosition.x - 1, ScreenPosition.y, PrevScreenLine.x - RoundDegree, PrevScreenLine.y, colors.Circle[1], colors.Circle[2], colors.Circle[3], colors.Circle[4])
				end

				if RenderOutline and colors.Outline and colors.Outline[4] > 0 then
					renderer.line(ScreenPosition.x, ScreenPosition.y - Width, PrevScreenLine.x, PrevScreenLine.y - Width, colors.Outline[1], colors.Outline[2], colors.Outline[3], colors.Outline[4])
					renderer.line(ScreenPosition.x, ScreenPosition.y + 1, PrevScreenLine.x, PrevScreenLine.y + 1, colors.Outline[1], colors.Outline[2], colors.Outline[3], colors.Outline[4])
				end
			end
		end

		PrevScreenLine = ScreenPosition
	end
end

MOISTEN.__index.ShouldAntiAim = function(self, e)
	local local_player = self:NewEntity(entity.get_local_player())
	if not local_player:is_valid() or not local_player:is_alive() or not self.Elements.MasterSwitch:get() then
		return false
	end

	local Curtime = globals.curtime()
	local m_iTeam = local_player:get_team()
	local GameRules = entity.get_game_rules()
	local Weapon = local_player:get_player_weapon()
	local m_bIsDefusing = local_player:get_prop("m_bIsDefusing")
	local m_bIsGrabbingHostage = local_player:get_prop("m_bIsGrabbingHostage")
	if not self.data.HelperManager then
		local Datas = {pcall(ui.reference, "Visuals", "Other ESP", "Helper")}
		if Datas[1] then
			self.data.HelperManager = {Datas[2], Datas[3]}
		end

	elseif self.data.HelperManager and Weapon and Weapon:is_valid() then
		local ActivateIsThrowWeapon = self:Contains({
			"CSnowball",
			"CFlashbang",
			"CHEGrenade",
			"CDecoyGrenade",
			"CSensorGrenade",
			"CSmokeGrenade",
			"CMolotovGrenade",
			"CIncendiaryGrenade"
		}, Weapon:get_classname())
		local Successed, MasterSwitch = pcall(ui.get, self.data.HelperManager[1])
		local SuccessedHotkey, Hotkey = pcall(ui.get, self.data.HelperManager[2])
		local IsHelper = Successed and SuccessedHotkey and MasterSwitch and Hotkey
		if IsHelper and ActivateIsThrowWeapon then
			return false
		end
	end

	if local_player:get_prop("m_MoveType") == 9 then
		return false
	end

	if m_iTeam == 3 and m_bIsDefusing and m_bIsDefusing == 1 then
		return false
	end

	if m_iTeam == 3 and m_bIsGrabbingHostage and m_bIsGrabbingHostage == 1 then
		return false
	end

	if GameRules then
		local m_bFreezePeriod = entity.get_prop(GameRules, "m_bFreezePeriod")
		if m_bFreezePeriod and m_bFreezePeriod == 1 then
			return false
		end
	end

	if Weapon and Weapon:is_valid() then
		local m_bPinPulled = Weapon:get_prop("m_bPinPulled")
		local m_fThrowTime = Weapon:get_prop("m_fThrowTime")
		local m_flNextAttack = local_player:get_prop("m_flNextAttack")
		local ActivateIsThrowWeapon = self:Contains({
			"CSnowball",
			"CFlashbang",
			"CHEGrenade",
			"CDecoyGrenade",
			"CSensorGrenade",
			"CSmokeGrenade",
			"CMolotovGrenade",
			"CIncendiaryGrenade"
		}, Weapon:get_classname())
		if ActivateIsThrowWeapon and ((m_bPinPulled and m_bPinPulled == 1) or (m_fThrowTime and m_fThrowTime > 0)) then
			return false
		end

		if m_bPinPulled and m_fThrowTime and (m_bPinPulled == 1 and m_fThrowTime > 0) then
			return false
		end

		if m_flNextAttack > Curtime then
			return true
		else
			local m_iClip1 = Weapon:get_prop("m_iClip1")
			if m_iClip1 and m_iClip1 == 0 then
				return true
			end

			local m_flNextPrimaryAttack = Weapon:get_prop("m_flNextPrimaryAttack")
			local m_iItemDefinitionIndex = bit.band(Weapon:get_weapon_index(), 65535)
			if m_flNextPrimaryAttack <= Curtime and (m_iItemDefinitionIndex and m_iItemDefinitionIndex == 64 and (e.in_attack == 1 or e.in_attack2 == 1) or (not ActivateIsThrowWeapon and e.in_attack == 1)) then
				if m_iItemDefinitionIndex == 64 then
					local m_flPostponeFireReadyTime = Weapon:get_prop("m_flPostponeFireReadyTime")
					if m_flPostponeFireReadyTime then
						local delta = m_flPostponeFireReadyTime - Curtime
						if e.in_attack == 1 and delta < 0.01 then
							return false
						elseif e.in_attack == 0 and e.in_attack2 == 1 and delta >= 3.4028234663853 then
							return false
						end
					else
						return false
					end
				else
					return false 
				end
			else
				local m_iBurstShotsRemaining = Weapon:get_prop("m_iBurstShotsRemaining")
				if m_iBurstShotsRemaining and m_iBurstShotsRemaining > 0 then
					return false
				end
			end 
		end
	end

	return true
end


MOISTEN.__index.LevelInit = function(self)
	self.data.LagCompensationReset = true
	local LagCompensation = self:GetCvar("cl_lagcompensation")
	LagCompensation:reset()
end

MOISTEN.__index.InGameLevelChanged = function(self, state)
	if not state then
		self.data.LagCompensationReset = true
		local LagCompensation = self:GetCvar("cl_lagcompensation")
		LagCompensation:reset()
	end

	if not self.Elements.MasterSwitch:get() then
		return
	end

end

MOISTEN.__index.UpdateDefensive = function(self)
	local local_player = self:NewEntity(entity.get_local_player())
	if not local_player:is_valid() or not local_player:is_alive() then
		self.data.isDefon = false
		return
	end

	local Tickcount = globals.tickcount()
	local DelayTicks = toticks(client.latency() * 1000)
	local Simulation = self.data.Simulation[local_player:get_index()]
	if Simulation and Simulation.Different < 0 then
		self.data.SimulationShifting = Tickcount + math.abs(toticks(Simulation.Different)) - DelayTicks
	end

	self.data.isDefon = self.data.SimulationShifting > Tickcount
end

MOISTEN.__index.UpdateTickbaseDefensive = function(self)
	local local_player = self:NewEntity(entity.get_local_player())
	if not local_player:is_valid() or not local_player:is_alive() then
		self.data.IsTickbaseDefensiveActive = false
		return
	end

	local Tickcount = globals.tickcount()
	local DelayTicks = toticks(client.latency() * 1000)
	self.data.CurrentTickbase = local_player:get_prop("m_nTickBase")
	local TickbaseDifferent = self.data.CurrentTickbase - self.data.PrevTickbase
	if TickbaseDifferent < 0 then
		self.data.TickbaseShifting = Tickcount + math.abs(TickbaseDifferent) - DelayTicks
	end

	self.data.PrevTickbase = self.data.CurrentTickbase
	self.data.IsTickbaseDefensiveActive = self.data.TickbaseShifting > Tickcount
end

MOISTEN.__index.NetUpdateStart = function(self)
	if not self.Elements.MasterSwitch:get() then
		return
	end

	self:UpdateDefensive()
	self:UpdateTickbaseDefensive()
end

MOISTEN.__index.NetUpdateEnd = function(self)
	if not self.Elements.MasterSwitch:get() then
		return
	end

	for _, ptr in pairs(entity.get_players()) do
		local Entity = self:NewEntity(ptr)
		if Entity:is_valid() then
			local Index = Entity:get_index()
			local SimulationTimer = Entity:get_prop("m_flSimulationTime")
			if not self.data.Simulation[Index] then
				self.data.Simulation[Index] = {
					Different = 0,
					Prev = SimulationTimer,
					Current = SimulationTimer
				}
			end

			self.data.Simulation[Index].Prev = SimulationTimer
			self.data.Simulation[Index].Different = self.data.Simulation[Index].Prev - self.data.Simulation[Index].Current
			self.data.Simulation[Index].Current = SimulationTimer
		end
	end
end

MOISTEN.__index.FastLadder = function(self, e)
	local local_player = self:NewEntity(entity.get_local_player())
	if not local_player:is_valid() or not local_player:is_alive() or not self.Elements.MasterSwitch:get() or not self.Elements.Misc.FastLadder:get() then
		return
	end

	if local_player:get_prop("m_MoveType") ~= 9 then
		return
	end

	local pitch, yaw = client.camera_angles()
	if e.forwardmove < 0 then
		e.pitch = 89
		e.in_back = 0
		e.in_forward = 1
		e.in_moveleft = 1
		e.in_moveright = 0
		if e.sidemove == 0 then
			e.yaw = e.yaw + 90
		elseif e.sidemove > 0 then
			e.yaw = e.yaw + 150
		elseif e.sidemove < 0 then
			e.yaw = e.yaw + 30
		end

	elseif e.forwardmove > 0 and pitch < 45 then
		e.pitch = 89
		e.in_back = 1
		e.in_forward = 0
		e.in_moveleft = 0
		e.in_moveright = 1
		if e.sidemove == 0 then
			e.yaw = e.yaw + 90
		elseif e.sidemove < 0 then
			e.yaw = e.yaw + 150
		elseif e.sidemove > 0 then
			e.yaw = e.yaw + 30
		end
	end
end

MOISTEN.__index.PlayerHurt = function(self, e)
	if not e.userid or not e.attacker or not self.Elements.MasterSwitch:get() or not false then
		return
	end

	local local_player = self:NewEntity(entity.get_local_player())
	local Victimer = self:NewEntity(client.userid_to_entindex(e.userid))
	local Attacker = self:NewEntity(client.userid_to_entindex(e.attacker))
	if not Attacker:is_valid() or not Attacker:is_enemy() or not local_player:is_valid() or Attacker == local_player then
		return
	end

	local Timer = globals.curtime()
	local SelfIndex = local_player:get_index()
	local VictimerIndex = Victimer:get_index()
	local TargetEntIndex = Attacker:get_index()
	
end

MOISTEN.__index.BulletImpact = function(self, e)
	if not e.userid or not self.Elements.MasterSwitch:get() then
		return
	end

	local local_player = self:NewEntity(entity.get_local_player())
	local Attacker = self:NewEntity(client.userid_to_entindex(e.userid))
	if not Attacker:is_valid() or not Attacker:is_enemy() or not local_player:is_valid() or Attacker == local_player then
		return
	end

	local Timer = globals.curtime()
	local TargetEntIndex = Attacker:get_index()
	local BulletPosition = self.data.Vector(e.x, e.y, e.z)
	local EyePosition = local_player:get_eye_position()
	local AttackerEyePosition = Attacker:get_eye_position()
	local BulletFraction = 1 - self:Clamp(BulletPosition:dist(EyePosition) / AttackerEyePosition:dist(EyePosition), 0, 1)
	local BulletBetweenDistance = self:TraceClosestPointRay(AttackerEyePosition, BulletPosition, EyePosition):dist(EyePosition)
	local Fraction, Entindex = client.trace_line(local_player:get_index(), EyePosition.x, EyePosition.y, EyePosition.z, BulletPosition.x, BulletPosition.y, BulletPosition.z)
end



MOISTEN.__index.AimHit = function(self, e)
	if not e.target or not self.Elements.Visuals.HitlogIndication:get() or not self.Elements.MasterSwitch:get() then
		return
	end

	local Timer = globals.curtime()
	local Damage = self:ToInteger(e.damage)
	local TargetEntity = self:NewEntity(e.target)
	local TargetName = TargetEntity:get_name()
	local Hitchance = self:ToInteger(e.hit_chance)
	local HitlogStyle = self.Elements.Visuals.HitlogStyle:get()
	local Backtrack = self.data.Simulation[TargetEntity:get_index()] and (toticks(self.data.Simulation[TargetEntity:get_index()].Different) - 1) or 0
	local Hitboxes = ({"Body", "Head", "Chest", "Stomach", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Neck", "?", "Gear"})[e.hitgroup + 1] or "Gear"
	local Text = ("hit %s 's %s for %i damage"):format(
		TargetName, Hitboxes, Damage
	)

	if HitlogStyle == "Novel" then
		Text = function(modified)
			local modifier = type(modified) == "number" and modified or 1
			return ("Hit %s 's %s %s %s %s: %s  %s: %s%s}"):format(
				TargetName,
				self:RgbaToHexText({185, 183, 241, modifier * 255}, Hitboxes),
				self:RgbaToHexText({255, 255, 255, modifier * 255}, "for"),
				self:RgbaToHexText({185, 183, 241, modifier * 255}, Damage),
				self:RgbaToHexText({255, 255, 255, modifier * 255}, "damage,  hitchance"),
				self:RgbaToHexText({185, 183, 241, modifier * 255}, Hitchance),
				self:RgbaToHexText({255, 255, 255, modifier * 255}, "{bt"),
				self:RgbaToHexText({246, 88, 88, modifier * 255}, Backtrack),
				self:RgbaToHexText({255, 255, 255, modifier * 255}, "ticks")
			)
		end
	end

	table.insert(self.data.HitlogCached, {
		Text = Text,
		Index = e.id,
		Timer = Timer,
		Release = false
	})
end

MOISTEN.__index.AimMiss = function(self, e)
	if not e.target or not self.Elements.Visuals.HitlogIndication:get() or not self.Elements.MasterSwitch:get() then
		return
	end

	local Timer = globals.curtime()
	local TargetEntity = self:NewEntity(e.target)
	local TargetName = TargetEntity:get_name()
	local Hitchance = self:ToInteger(e.hit_chance)
	local HitlogStyle = self.Elements.Visuals.HitlogStyle:get()
	local CurrentReason = e.reason == "?" and "resolver" or e.reason
	local Backtrack = self.data.Simulation[TargetEntity:get_index()] and (toticks(self.data.Simulation[TargetEntity:get_index()].Different) - 1) or 0
	local Hitboxes = ({"Body", "Head", "Chest", "Stomach", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Neck", "?", "Gear"})[e.hitgroup + 1] or "Gear"
	local Text = ("miss shot %s 's due to %s"):format(
		TargetName, CurrentReason
	)

	if HitlogStyle == "Novel" then
		Text = function(modified)
			local modifier = type(modified) == "number" and modified or 1
			return ("%s %s 's for %s  %s%s"):format(
				self:RgbaToHexText({246, 88, 88, modifier * 255}, "Missed "),
				self:RgbaToHexText({255, 255, 255, modifier * 255}, TargetName),
				self:RgbaToHexText({185, 183, 241, modifier * 255}, Hitboxes),
				self:RgbaToHexText({255, 255, 255, modifier * 255}, "due to "),
				self:RgbaToHexText({246, 88, 88, modifier * 255}, CurrentReason),
				self:RgbaToHexText({255, 255, 255, modifier * 255}, ", hitchance: "),
				self:RgbaToHexText({185, 183, 241, modifier * 255}, Hitchance),
				self:RgbaToHexText({255, 255, 255, modifier * 255}, ", {bt:  "),
				self:RgbaToHexText({246, 88, 88, modifier * 255}, Backtrack),
				self:RgbaToHexText({255, 255, 255, modifier * 255}, "ticks")
			)
		end
	end

	table.insert(self.data.HitlogCached, {
		Text = Text,
		Index = e.id,
		Timer = Timer,
		Release = false
	})
end

MOISTEN.__index.PreRender = function(self)
	local local_player = self:NewEntity(entity.get_local_player())
	if not local_player:is_valid() or not local_player:is_alive() or not self.Elements.MasterSwitch:get() then
		if local_player:is_valid() and self.data.StoredModelScale then
			self.data.StoredModelScale = false
			local_player:set_prop("m_flModelScale", 1)
		end

		return
	end

	local Velocity = local_player:get_velocity()
	local Jumping = local_player:get_jumping()
	local SelfHelpers = local_player:get_helpers()
	local AnimState = SelfHelpers:get_anim_state()
	local MovementAnimLayer = SelfHelpers:get_anim_overlay(6)
	local SlowWalk = ui.get(self.References.slow_walk[1]) and ui.get(self.References.slow_walk[2])
	local AutoPeek = ui.get(self.References.auto_peek[1]) and ui.get(self.References.auto_peek[2])
	if self.Elements.Misc.AnimationBreaker:get(1) and Velocity > 30 and not Jumping and not AutoPeek then
		MovementAnimLayer.weight = 1
		local_player:set_prop("m_flPoseParameter", 0, 7)
		ui.set(self.References.leg_movement, "Never slide")
	end

	if self.Elements.Misc.AnimationBreaker:get(2) and Jumping then
		local AnimLayer = SelfHelpers:get_anim_overlay(AnimLayerIndex)
		AnimLayer.cycle = 40 / 100
		AnimLayer.sequence = 148
		MovementAnimLayer.weight = 1
		local_player:set_prop("m_flPoseParameter", 0, 7)
		ui.set(self.References.leg_movement, "Never slide")
	end

	if self.Elements.Misc.AnimationBreaker:get(3) and SlowWalk then
		local_player:set_prop("m_flPoseParameter", 0, 9)
		ui.set(self.References.leg_movement, "Never slide")
	end

	if AutoPeek then
		local_player:set_prop("m_flPoseParameter", 0.75, 8)
		ui.set(self.References.leg_movement, "Always slide")
	else
		ui.set(self.References.leg_movement, "Never slide")
	end

	if self.Elements.Misc.AnimationBreaker:get(4) then
		if not AnimState.hit_in_ground_animation and Jumping then
			self.data.GroundTicks = globals.tickcount()
		end

		local TickDifferent = math.abs(globals.tickcount() - self.data.GroundTicks)
		if not Jumping and TickDifferent > 2 and AnimState.hit_in_ground_animation then
			local_player:set_prop("m_flPoseParameter", 0.5, 12)
		end
	end


end

MOISTEN.__index.Render = function(self)
	local tickcount = globals.tickcount()
	local IsInGame = self.CHelpers.IsInGame()
	local MasterSwitch = self.Elements.MasterSwitch:get()
	local ConsoleFilter = self.Elements.Misc.ConsoleFilter:get()
	local local_player = self:NewEntity(entity.get_local_player())
	if self.data.LastInGame ~= IsInGame then
		self.data.LastInGame = IsInGame
		self:InGameLevelChanged(IsInGame)
	end

	self.Elements.AntiAim.OwnerLabel:set(("                 %s"):format(
		self:CreateRelativeAnimationText(
			"Author: Przunxible",
			self.data.LightPinkedColor,
			{self.data.LightPinkedColor[1], self.data.LightPinkedColor[2], self.data.LightPinkedColor[3], 0},
			85, true, false
		)
	))

	self.Elements.MasterSwitchLabel:set(
		self:CreateRelativeAnimationText(
			self.data.SideBarName,
			self.data.LightPinkedColor,
			{self.data.LightPinkedColor[1], self.data.LightPinkedColor[2], self.data.LightPinkedColor[3], 0},
			80, false, false
		)
	)

	local NotifyUpdaterIndex = 0
	local Curtime = globals.curtime()
	local TimeScale = self:GetTimeScale()
	self:HandleReference(not MasterSwitch)
	local PrevScoped = local_player:get_prop("m_bIsScoped")
	local ScreenSize = self.data.Vector(unpack(self.data.ScreenSize))
	local WatermarkIndication = self.Elements.Visuals.WatermarkIndication:get()
	local CenterSize = self.data.Vector(self.data.ScreenSize[1], self.data.ScreenSize[2]) / 2
	if ConsoleFilter and not self.data.StoredConsileFilter then
		cvar["developer"]:set_int(0)
		cvar["con_filter_enable"]:set_int(1)
		self.data.StoredConsileFilter = true
		cvar["con_filter_text"]:set_string("IrWL5106TZZKNFPz4P4Gl3pSN?J370f5hi373ZjPg%VOVh6lN")
	elseif not ConsoleFilter and self.data.StoredConsileFilter then
		cvar["con_filter_enable"]:set_int(0)
		cvar["con_filter_text"]:set_string("")
		self.data.StoredConsileFilter = false
	end

	for index, data in pairs(self.data.NotifyCached) do
		local HeightBetween = 125
		local CurrentUpdateIndex = NotifyUpdaterIndex
		local TimePercentage = data.Switch and 0.025 or 1
		local NotifyAnimationColor = data.AnimationColor or self.data.LightPinkedColor
		local NotifyAnimation = self:NewLerp(0, data.Switch and 0 or 1, 100, ("[%s]Notify Logs"):format(data.Index))
		local NotifyHeight = self:NewLerp(CurrentUpdateIndex * HeightBetween, self:ToInteger(CurrentUpdateIndex * HeightBetween), 100, ("[%s]Notify Between Logs"):format(data.Index))
		if not data.CurrentIndex then
			data.CurrentIndex = index
		end

		local NotifyReleaseTimer = (data.ReleaseTimer or 2.5) + (data.CurrentIndex * 0.55)
		if data.Switch and NotifyAnimation <= 0 then
			self:GetLerpAnimation(("[%s]Notify Logs"):format(data.Index), 0)
			self:GetLerpAnimation(("[%s]Notify Between Logs"):format(data.Index), 0)
			table.remove(self.data.NotifyCached, index)
		elseif NotifyAnimation < 1 and not data.Switch then
			data.Timer = TimeScale
		elseif NotifyAnimation >= 1 then
			local DifferentTimer = math.abs(TimeScale - data.Timer)
			TimePercentage = self:Clamp(1 - (DifferentTimer / NotifyReleaseTimer), 0.025, 1)
			if DifferentTimer > NotifyReleaseTimer then
				data.Switch = true
			end
		end

		local NotifyText = self:CreateRelativeAnimationText(
			data.Text,
			{NotifyAnimationColor[1], NotifyAnimationColor[2], NotifyAnimationColor[3], NotifyAnimation * NotifyAnimationColor[4]},
			{255, 255, 255, NotifyAnimation * 255},
			85, true, false
		)

		local SvgRectAddSize = self.data.Vector(27, 27)
		local OriginalText = self:HexTextToOriginal(NotifyText)
		local TextSize = self.data.Vector(renderer.measure_text("b", OriginalText))
		local NotifySvgSize = (data.Svg and data.Svg.Size or self.data.Vector(0, 0))
		local TitleTextSize = self.data.Vector(renderer.measure_text("b+", data.Title))
		local AddonMaximizedSize = self.data.Vector(math.max(TextSize.x, TitleTextSize.x), math.max(TextSize.y, TitleTextSize.y))
		if data.UserName then
			local OriginalUserText = self:HexTextToOriginal(data.UserName)
			local UserTextSize = self.data.Vector(renderer.measure_text("b", OriginalText))
			AddonMaximizedSize = self.data.Vector(math.max(UserTextSize.x, AddonMaximizedSize.x), AddonMaximizedSize.y + UserTextSize.y)
		end

		if data.ConfigsName then
			local OriginalConfigText = self:HexTextToOriginal(data.ConfigsName)
			local ConfigTextSize = self.data.Vector(renderer.measure_text("b", OriginalConfigText))
			AddonMaximizedSize = self.data.Vector(math.max(ConfigTextSize.x, AddonMaximizedSize.x), AddonMaximizedSize.y + ConfigTextSize.y)
		end

		local SvgRectSize = data.Svg.Size + SvgRectAddSize
		local UpperTextAddonSize = 33 + TitleTextSize.y + TextSize.y
		local NotifySize = self.data.Vector(70, 50) + self.data.Vector(AddonMaximizedSize.x + NotifySvgSize.x, math.max(AddonMaximizedSize.y, NotifySvgSize.y))
		self:RenderRoundRectangle(ScreenSize.x - ((NotifySize.x + 20) * NotifyAnimation), 20 + NotifyHeight, NotifySize.x, NotifySize.y, 8, {self.data.NotifyBackgroundColor[1], self.data.NotifyBackgroundColor[2], self.data.NotifyBackgroundColor[3], NotifyAnimation * self.data.NotifyBackgroundColor[4]})
		renderer.blur(ScreenSize.x - ((NotifySize.x + 20) * NotifyAnimation), 20 + NotifyHeight, NotifySize.x, NotifySize.y, NotifyAnimation, NotifyAnimation)
		local NotifyPercentageRectWidth = (NotifySize.x - 3) * TimePercentage
		if NotifyPercentageRectWidth >= 5 then
			self:RenderRoundRectangle(ScreenSize.x - ((NotifySize.x + 19) * NotifyAnimation), NotifySize.y + 14 + NotifyHeight, (NotifySize.x - 3) * TimePercentage, 5, 4, {self.data.NotifyPercentageLineColor[1], self.data.NotifyPercentageLineColor[2], self.data.NotifyPercentageLineColor[3], NotifyAnimation * self.data.NotifyPercentageLineColor[4]})
		end

		renderer.text(
			ScreenSize.x - (NotifySize.x * NotifyAnimation) + NotifySvgSize.x + 30,
			30 + NotifyHeight,
			255, 255, 255, NotifyAnimation * 255, "b+", 0, data.Title
		)

		renderer.text(
			ScreenSize.x - (NotifySize.x * NotifyAnimation) + NotifySvgSize.x + 30,
			33 + TitleTextSize.y + NotifyHeight,
			255, 255, 255, 0, "b", 0, NotifyText
		)

		if data.ConfigsName then
			renderer.text(
				ScreenSize.x - (NotifySize.x * NotifyAnimation) + NotifySvgSize.x + 30,
				UpperTextAddonSize + 1 + NotifyHeight,
				255, 255, 255, NotifyAnimation * 255, "b", 0, data.ConfigsName
			)

			local OriginalText = self:HexTextToOriginal(data.ConfigsName)
			local TextSize = self.data.Vector(renderer.measure_text("b", OriginalText))
			UpperTextAddonSize = UpperTextAddonSize + TextSize.y + 1
		end

		if data.UserName then
			renderer.text(
				ScreenSize.x - (NotifySize.x * NotifyAnimation) + NotifySvgSize.x + 30,
				UpperTextAddonSize + 1 + NotifyHeight,
				255, 255, 255, NotifyAnimation * 255, "b", 0, data.UserName
			)

			local OriginalText = self:HexTextToOriginal(data.UserName)
			local TextSize = self.data.Vector(renderer.measure_text("b", OriginalText))
			UpperTextAddonSize = UpperTextAddonSize + TextSize.y + 1
		end

		if data.Svg then
			self:RenderRoundRectangle(
				ScreenSize.x - (NotifySize.x * NotifyAnimation) + 5 - (SvgRectAddSize.x / 2),
				45 - (SvgRectAddSize.y / 2) + NotifyHeight,
			SvgRectSize.x, SvgRectSize.y, 8, {0, 0, 0, NotifyAnimation * 255})
			renderer.texture(data.Svg.Texture,
				ScreenSize.x - (NotifySize.x * NotifyAnimation) + 5,
				45 + NotifyHeight,
				data.Svg.Size.x, data.Svg.Size.y, 255, 255, 255, NotifyAnimation * 255
			)
		end

		NotifyUpdaterIndex = NotifyUpdaterIndex + NotifyAnimation
	end

	local WatermarkFraction = self:NewLerp(0, WatermarkIndication and 1 or 0, 70, "Watermark Fraction")
	if WatermarkFraction > 0 then
		local SystemTimes = {client.system_time()}
		local Latency = self:ToInteger(client.latency() * 1000)
		local TimeIdentification = SystemTimes[1] > 12 and " pm" or " am"
		local whitecolor = {255,255,255,WatermarkFraction*255}
		local WatermarkColor = {self.Elements.Visuals.WatermarkBarColor:get()}
		local NormalizedHour = SystemTimes[1] > 12 and (SystemTimes[1] - 12) or SystemTimes[1]
		local PrevWatermarkText = ("%s%s%s%s%s%s%s%s"):format(
			self:RgbaToHexGradientText(WatermarkColor, WatermarkColor, "") or "",
			self:RgbaToHexText(whitecolor, ("%s  "):format("Arc")) or "",
			self:RgbaToHexText(self.data.OtherWatermarkColor, ("    %s "):format(self.data.SelfName)) or "",
			self.Elements.Visuals.WatermarkList:get(1) and self:RgbaToHexText(whitecolor, ("%s "):format("[private]")) or "",
			self.Elements.Visuals.WatermarkList:get(2) and self:RgbaToHexText(WatermarkColor, ("| %s:%s"):format(NormalizedHour, SystemTimes[2])) or "",
			self.Elements.Visuals.WatermarkList:get(2) and self:RgbaToHexText(self.data.OtherWatermarkColor, ("%s "):format(TimeIdentification)) or "",
			self.Elements.Visuals.WatermarkList:get(3) and self:RgbaToHexText(WatermarkColor, ("- %i"):format(Latency)) or "",
			self.Elements.Visuals.WatermarkList:get(3) and self:RgbaToHexText(self.data.OtherWatermarkColor, "  ms ") or ""
		)

		local x, y = dragging_panel:get()
		local BasePosition = self.data.Vector(x * WatermarkFraction, self.data.ScreenSize[2] * WatermarkFraction)
		local WatermarkTextSize = self.data.Vector(renderer.measure_text("b", PrevWatermarkText))
		--self:RectangleOutline(CenterSize.x - (WatermarkTextSize.x / 2) - 7, BasePosition.y - 221, WatermarkTextSize.x + 14, 26, 1, 1, {self.data.AccentWatermarkColor[1], self.data.AccentWatermarkColor[2], self.data.AccentWatermarkColor[3], 100})
		--self:RenderGlowOutline(CenterSize.x - (WatermarkTextSize.x / 2) - 7, self.data.ScreenSize[2] - 221, WatermarkTextSize.x + 11, 26, 10, 1, {self.data.AccentWatermarkColor[1], self.data.AccentWatermarkColor[2], self.data.AccentWatermarkColor[3], 50*WatermarkFraction})
		self:RenderRoundRectangle(BasePosition.x - WatermarkTextSize.x - 5 + 1345, BasePosition.y - 1430, WatermarkTextSize.x - 26, 22, 1, {10, 10, 10, 255*WatermarkFraction})
		self:RenderRoundRectangle(BasePosition.x - WatermarkTextSize.x - 6 + 1315, BasePosition.y - 1430, 24, 22, 1, {10, 10, 10, 255*WatermarkFraction})
		self:RenderGlowOutline(BasePosition.x - WatermarkTextSize.x - 5 + 1320, BasePosition.y - 1420, 10, 0, 15, 1, {185, 183, 241, 100*WatermarkFraction})
		--self:RenderGlowOutline(CenterSize.x - (WatermarkTextSize.x / 2) - 5 + 1103, self.data.ScreenSize[2] - 700, 14, 0, 1, 1, {185, 183, 241, 100*WatermarkFraction})
		self:RenderGlowOutline(BasePosition.x - WatermarkTextSize.x - 5 + 1346, BasePosition.y - 1427, 0, 13, 7, 0, {185, 183, 241, 100*WatermarkFraction})
		self:RenderRoundRectangle(BasePosition.x - WatermarkTextSize.x - 5 + 1347, BasePosition.y - 1427, 1, 16, 0, {185, 183, 241, 255*WatermarkFraction})
		local GlowThickness = (100 / 10) or 10
		local GlowFraction = 100 or 70
--last part
		local WatermarkText = ("%s%s%s%s%s%s%s%s"):format(
			self:RgbaToHexGradientText(WatermarkColor, WatermarkColor, "") or "",
			self:RgbaToHexText(whitecolor, ("%s  "):format("Arc")) or "",
			self:RgbaToHexText(self.data.OtherWatermarkColor, ("    %s "):format(self.data.SelfName)) or "",
			self.Elements.Visuals.WatermarkList:get(1) and self:RgbaToHexText(whitecolor, ("%s "):format("[private]")) or "",
			self.Elements.Visuals.WatermarkList:get(2) and self:RgbaToHexText(WatermarkColor, ("| %s:%s"):format(NormalizedHour, SystemTimes[2])) or "",
			self.Elements.Visuals.WatermarkList:get(2) and self:RgbaToHexText(self.data.OtherWatermarkColor, ("%s "):format(TimeIdentification)) or "",
			self.Elements.Visuals.WatermarkList:get(3) and self:RgbaToHexText(WatermarkColor, ("- %i"):format(Latency)) or "",
			self.Elements.Visuals.WatermarkList:get(3) and self:RgbaToHexText(self.data.OtherWatermarkColor, "  ms ") or ""
		)

		renderer.text(BasePosition.x + 1311 - (WatermarkTextSize.x / 2), BasePosition.y - 1420, 255, 255, 255, 255*WatermarkFraction, "cb-", 0, WatermarkText)
	end

	if self.Elements.Visuals.HitlogIndication:get() then
		local UpdaterIndex = 0
		local Smooth = globals.frametime() * 5
		local HitlogStyle = self.Elements.Visuals.HitlogStyle:get()
		local HitlogColor = {self.Elements.Visuals.HitlogColor:get()}
		local HitlogLimitation = self.Elements.Visuals.HitlogIndication:get()
		local HitlogAnimation = self.Elements.Visuals.HitlogIndication:get()
		local HitlogSmoothed = 85
		local HitlogAnimationText = self.Elements.Visuals.HitlogIndication:get()
		local HitlogBackground = self.Elements.Visuals.HitlogBackgroundStyle:get()
		local HitlogOverrideBackground = self.Elements.Visuals.HitlogIndication:get()
		local HitlogAnimationStyle = self.Elements.Visuals.HitlogIndication:get()
		local HitlogLimitationMaximized = 6
		local HitlogTextSmoothed = 90
		local HitlogHeight = 250
		local HitlogBetween = 35
		local HitlogReleaseTimer = 3.5
		for index, data in pairs(self.data.HitlogCached) do
			local CurrentText = data.Text
			local TimeBetween = math.abs(Curtime - data.Timer)
			local AnimationModifier = HitlogAnimation and (HitlogAnimationStyle == "Static" and self:CreateStaticTargetAnimation(0, data.Release and 0 or 1, HitlogSmoothed, ("[%s]Hitlogs"):format(data.Index)) or self:NewLerp(0, data.Release and 0 or 1, HitlogSmoothed, ("[%s]Hitlogs"):format(data.Index))) or (data.Release and 0 or 1)
			local AnimationTextModifier = HitlogAnimation and (HitlogAnimationStyle == "Static" and self:CreateStaticTargetAnimation(0, data.Release and 0 or 1, HitlogTextSmoothed, ("[%s]Hitlogs Text"):format(data.Index)) or self:NewLerp(0, data.Release and 0 or 1, HitlogTextSmoothed, ("[%s]Hitlogs Text"):format(data.Index))) or (data.Release and 0 or 1)
			if type(CurrentText) == "function" then
				CurrentText = HitlogStyle == "Novel" and CurrentText(AnimationModifier)
			end
			if HitlogLimitation and index > HitlogLimitationMaximized then
				local Remote = self.data.HitlogCached[1]
				self:GetLerpAnimation(("[%s]Hitlogs"):format(Remote.Index), 0)
				self:GetLerpAnimation(("[%s]Hitlogs Text"):format(Remote.Index), 0)
				self:GetStaticTargetAnimation(("[%s]Hitlogs"):format(Remote.Index), 0)
				self:GetStaticTargetAnimation(("[%s]Hitlogs Text"):format(Remote.Index), 0)
				table.remove(self.data.HitlogCached, 1)
			elseif AnimationModifier >= 1 and TimeBetween > HitlogReleaseTimer and not data.Release then
				data.Release = true
			elseif data.Release and AnimationModifier <= 0 then
				self:GetLerpAnimation(("[%s]Hitlogs"):format(data.Index), 0)
				self:GetLerpAnimation(("[%s]Hitlogs Text"):format(data.Index), 0)
				self:GetStaticTargetAnimation(("[%s]Hitlogs"):format(data.Index), 0)
				self:GetStaticTargetAnimation(("[%s]Hitlogs Text"):format(data.Index), 0)
				table.remove(self.data.HitlogCached, index)
			end

			local Weight = HitlogHeight * AnimationModifier
			local DifferentBetween = HitlogBetween * AnimationModifier
			if HitlogStyle == "Novel" then
				local TextSize = self.data.Vector(renderer.measure_text(HitlogStyle == "Style #1" and "-" or "", CurrentText))
				local TextAnimationSize = HitlogAnimationText and TextSize * AnimationTextModifier or TextSize
				local HitlogTextSize = TextAnimationSize + self.data.Vector(20)
				local GlowOutlinePosition = self.data.Vector(CenterSize.x - (HitlogTextSize.x / 2) - 5, self.data.ScreenSize[2] - Weight - 10 - (UpdaterIndex * DifferentBetween))
				self:RenderGlowOutlineRectangle(GlowOutlinePosition.x + (HitlogTextSize.x / 300), GlowOutlinePosition.y + HitlogTextSize.y, HitlogTextSize.x + self:ToInteger(HitlogTextSize.x / 18), 24, 4, 15, {
					Background = {25, 25, 25, AnimationModifier * 155},
					Glow = {HitlogColor[1], HitlogColor[2], HitlogColor[3], AnimationModifier * 40},
					Outline = {HitlogColor[1], HitlogColor[2], HitlogColor[3], AnimationModifier * HitlogColor[4]}
				}, {false, false, true, true, true, true, HitlogOverrideBackground and HitlogBackground or ""}, 0.2)
				local HitlogTextSize = self.data.Vector(renderer.measure_text(HitlogStyle == "Style #1" and "-" or "", CurrentText)) + self.data.Vector(10)
				renderer.text(CenterSize.x - (HitlogTextSize.x / 2.14) + ((TextSize.x - TextAnimationSize.x) / 2) + 10, self.data.ScreenSize[2] + (HitlogTextSize.y / 1) - Weight - 5 - (UpdaterIndex * DifferentBetween), 255, 255, 255, 255 * AnimationModifier, "", self:ToInteger(TextAnimationSize.x + 2), CurrentText)
				renderer.texture(self.data.TechSvg,
					CenterSize.x - (TextAnimationSize.x / 2.14) - 15,
					self.data.ScreenSize[2] + (HitlogTextSize.y / 1) - Weight - 6 - (UpdaterIndex * DifferentBetween),
					15, 15, 255, 255, 255, AnimationModifier * 255
				)
			end

			UpdaterIndex = UpdaterIndex + AnimationModifier
		end
	end

	if not IsInGame or not MasterSwitch or not local_player:is_valid() or not local_player:is_alive() then
		return
	end

	local BodyYaw = local_player:get_body_yaw()
	if globals.chokedcommands() == 0 then
		self.data.BodyYaw = - BodyYaw
	end

	if PrevScoped == 1 then
		local IsScopeOverlay = ui.get(self.References.removed_scope_overlay)
		if not IsScopeOverlay then
			if not self.data.ScopeLineElement then
				local Successed, Hanlder = pcall(ui.reference, "Visuals", "Effects", "Custom scope lines")
				if Successed then
					self.data.ScopeLineElement = Hanlder
				end

			elseif self.data.ScopeLineElement then
				local Successed, IsScopeLine = pcall(ui.get, self.data.ScopeLineElement)
				if Successed and IsScopeLine then
					IsScopeOverlay = true
				end
			end
		end

		if IsScopeOverlay then
			self.data.ZoomMaterialReload = true
			local_player:set_prop("m_bIsScoped", 0)
		end

	elseif self.data.ZoomMaterialReload then
		for index, material in pairs(self.data.ZoomMaterials) do
			if material ~= nil then
				material:set_material_var_flag(2, false)
			end
		end
	end

	if self.Elements.Visuals.AutoPeekIndication:get() then
		local Origin = local_player:get_origin()
		local AutoPeekStyle = self.Elements.Visuals.AutoPeekStyle:get()
		local AutoPeekColor = {self.Elements.Visuals.AutoPeekColor:get()}
		local AutoPeekRadiusAnimation = self.Elements.Visuals.AutoPeekAnimation:get(1)
		local AutoPeekModifierAnimation = self.Elements.Visuals.AutoPeekAnimation:get(2)
		local AutoPeekSmoothed = 50
		local AutoPeek = ui.get(self.References.auto_peek[1]) and ui.get(self.References.auto_peek[2])
		local AutoPeekShouldOffScreenRadius = 300
		local AutoPeekModifier = self:CreateStaticTargetAnimation(0, AutoPeek and 1 or 0, AutoPeekSmoothed, "Auto Peek Circle")
		if not AutoPeek then
			self.data.PrevPeekOrigin = Origin
			if not self.data.PeekOrigin then
				self.data.PeekOrigin = Origin
			end

		elseif AutoPeek then
			self.data.PeekOrigin = self.data.PrevPeekOrigin
		end

		if AutoPeekModifier > 0 and self.data.PeekOrigin then
			local CircleRadius = AutoPeekRadiusAnimation and self:ToInteger(AutoPeekModifier * 15) or 15
			local CircleModifier = AutoPeekModifierAnimation and AutoPeekModifier or AutoPeekRadiusAnimation and (CircleRadius > 0 and 1 or 0) or (AutoPeek and 1 or 0)
			self:Render3DCircle(self.data.PeekOrigin.x, self.data.PeekOrigin.y, self.data.PeekOrigin.z, CircleRadius, {
				Circle = {AutoPeekColor[1], AutoPeekColor[2], AutoPeekColor[3], AutoPeekColor[4] * CircleModifier},
				Outline = {AutoPeekColor[1], AutoPeekColor[2], AutoPeekColor[3], AutoPeekColor[4] * CircleModifier},
				Fill = {AutoPeekColor[1], AutoPeekColor[2], AutoPeekColor[3], self:Clamp(AutoPeekColor[4] * 0.35, 0, 155) * CircleModifier}
			}, 3, 2, true, 0, 1, AutoPeekShouldOffScreenRadius, AutoPeekStyle)
		end
	end

	local DebugFraction = self:NewLerp(0, self.Elements.Visuals.DebugPanel:get() and 1 or 0, 70, "Debug Fraction")
	if DebugFraction > 0 then
		-- drag paste
		local w,h = client.screen_size()
		local m_active, references = { }, { }
		local ui_get, ui_set = ui.get, ui.set
		local ui_is_menu_open = ui.is_menu_open
		local globals_frametime = globals.frametime
		local renderer_rectangle = renderer.rectangle
		local measure_text = renderer.measure_text
		local renderer_text = renderer.text
		local ui_is_menu_open = ui.is_menu_open
		local m_alpha, m_active, m_contents, unsorted = 0, {}, {}, {}
		local drag_x, drag_y = dragging_panel:get()
		local base_position = self.data.Vector(drag_x * DebugFraction, drag_y * DebugFraction)
		local x, y = base_position.x, base_position.y
		local function item_count(tab)
			if tab == nil then return 0 end
			if #tab == 0 then
				local val = 0
				for k in pairs(tab) do
					val = val + 1
				end
		
				return val
			end
		
			return #tab
		end
		
		--end
		self:RenderRoundRectangle(x , y, 92, 2, 1, {220, 220, 220, 160 * DebugFraction})
		self:RenderRoundRectangle(x, y + 52, 92, 2, 1, {220, 220, 220, 160 * DebugFraction})
		self:RenderRoundRectangle(x, y + 1, 91, 52, 4, {10, 10, 10, 205 * DebugFraction})
		local DebugPulse = (math.sin(math.abs(- math.pi + (globals.curtime() * (5/ 6 - 2.2)) % (math.pi * 2))) * 255)
		local DebugPanelColor = {185, 183, 241, 255 * DebugFraction}
		local round = function(value, multiplier) local multiplier = 10 ^ (multiplier or 0); return math.floor(value * multiplier + 0.5) / multiplier end
    	local realtime = globals.realtime() % 3
    	local alpha = math.floor(math.sin(realtime * 4) * (255/3-1) + 255/2) or 255

    	--------wide height
		local NameTextSize = self.data.Vector(renderer.measure_text("MOISTEN.\aA8A5F1FFWIN"))
		local GlowThickness = (100 / 10) or 10
		local GlowFraction = 100 or 70
		self:RenderGlowOutline(x + 16, y - 5, 58, 0, GlowThickness, 0, {185, 183, 241, GlowFraction * DebugFraction})
		self:RenderGlowOutline(x, y + 1, 90, 52, GlowThickness, 1, {185, 183, 241, 50 * DebugFraction})
		self:RgbaToHexGradientText(DebugPanelColor, DebugPanelColor, "MOISTEN.\aA8A5F1FFWIN")
		renderer.text(x + 45, y - 5, 220, 220, 220, 255 * DebugFraction, "c-", 0, "MOISTEN.\aA8A5F1FFWIN        R")
		renderer.text(x + 68, y - 5, 220, 220, 220, 255 * DebugFraction, "c-", 0, ("%s"):format(math.random(0, 60)))
		renderer.text(x + 45, y + 7, 220, 220, 220, 255 * DebugFraction, "c-", 0, "-  \aA8A5F1FFDEBUG  \aFFFFFFCE|  PANEL  -")
		renderer.text(x + 45, y + 17, 220, 220, 220, 255 * DebugFraction, "c-", 0, "USER: \aA8A5F1FF"..self.data.SelfName:upper())
		renderer.text(x + 45, y + 27, 220, 220, 220, 255 * DebugFraction, "c-", 0, "STATES  -\aA8A5F1FF"..self.data.PlayerStateName2:upper())
		if entity.get_player_name(client.current_threat()):upper() == "UNKNOWN"
		then
			renderer.text(x + 45, y + 37, 220, 220, 220, 255 * DebugFraction,"c-", 0, "TARGET  \aA8A5F1FF-  \aFFFFFFCENONE")
		else
			renderer.text(x + 45, y + 37, 220, 220, 220, 255 * DebugFraction,"c-", 0, "TARGET  \aA8A5F1FF-  \aFFFFFFCE"..entity.get_player_name(client.current_threat()):upper())
		end
		local HeadPosition = local_player:get_hitbox_position(0)
		local IsHitable = false
		local ThreatTarget = self:NewEntity(client.current_threat())
		local StomachPosition = local_player:get_hitbox_position(2)
		local SelfHealth = local_player:get_prop("m_iHealth")
		if ThreatTarget:is_valid() and ThreatTarget:is_alive() and not ThreatTarget:is_dormant() then
			renderer.text(x + 45, y + 47, 220, 220, 220, 255 * DebugFraction,"c-", 0, "SECURE  :  \aF65858FFUNSAFE")
			local TargetEyePosition = self:ExtrapolatePosition(ThreatTarget, ThreatTarget:get_eye_position(), 14)
			local _, HeadDamage = client.trace_bullet(ThreatTarget:get_index(), TargetEyePosition.x, TargetEyePosition.y, TargetEyePosition.z, HeadPosition.x, HeadPosition.y, HeadPosition.z)
			local _, StomachDamage = client.trace_bullet(ThreatTarget:get_index(), TargetEyePosition.x, TargetEyePosition.y, TargetEyePosition.z, StomachPosition.x, StomachPosition.y, StomachPosition.z)
			if HeadDamage > 0 or StomachDamage > 50 or math.max(HeadDamage, StomachDamage) > SelfHealth then
				IsHitable = true
			end
		else
			renderer.text(x + 45, y + 47, 220, 220, 220, 255 * DebugFraction,"c-", 0, "SECURE  :  SAFETY")
		end

		dragging_panel:drag(90, 52)
	end
	if self.Elements.Visuals.enable_min_dmg_ovrrd:get() then
		local damage_indi = "0"
        if ui.get(self.References.min_damage_override[1]) and ui.get(self.References.min_damage_override[2]) then
            if ui.get(self.References.min_damage_override[3]) == 0 then
                damage_indi = "auto"
            elseif ui.get(self.References.min_damage_override[3]) > 100 then
                damage_indi = "HP+" .. ui.get(self.References.min_damage_override[3]) - 100
            elseif ui.get(self.References.min_damage_override[3]) <= 100 then
                damage_indi = ui.get(self.References.min_damage_override[3])
            end
           
        elseif  not ui.get(self.References.min_damage_override[1]) or not ui.get(self.References.min_damage_override[2]) then 
    
            if ui.get(self.References.min_damage) == 0 then
                damage_indi = "auto"
            elseif ui.get(self.References.min_damage) > 100 then
                damage_indi = "HP+" .. ui.get(self.References.min_damage) - 100
            elseif ui.get(self.References.min_damage) <= 100 then
                damage_indi = ui.get(self.References.min_damage)
            end
        end
    
        renderer.text(CenterSize.x + 13, CenterSize.y - 15 , 255, 255, 255, 255,"c-",0,tostring(damage_indi):upper())
	end

	if self.Elements.Visuals.ManualIndication:get() then
		local IsScoped = PrevScoped == 1
		local ManualColor = {self.Elements.Visuals.ManualColor:get()}
		local ManualArrowsPulse = self.Elements.Visuals.ManualIndication:get()
		local ManualArrowStyle = self.Elements.Visuals.ManualArrowStyle:get()
		local ManualPulseSmoothed = 50 / 20
		local ManualDistance =  80
		local ManualHeightAnimation = 0
		local ManualModifier = ManualArrowsPulse and (math.sin(math.abs(- math.pi + (globals.curtime() * (5/ 6 - ManualPulseSmoothed)) % (math.pi * 2))) * ManualColor[4]) or ManualColor[4]
		local ManualArrows = ({
			["Mini"] = {"❮ ", "❯"},
			["<>"] = {"< ", ">"},
			["⯇⯈"] = {"⯇ ", "⯈"}
		})[ManualArrowStyle]
		if ManualArrowStyle == "<>" then
			renderer.text(CenterSize.x + 2 - 80 , CenterSize.y - 2 , 100, 100, 100, ManualModifier, "c+", 0, "< ")
			renderer.text(CenterSize.x + 2 + 80 , CenterSize.y - 2 , 100, 100, 100, ManualModifier, "c+", 0, ">")
		end
		if self.data.ManualState >= 1 and self.data.ManualState <= 2 then
			if ManualArrowStyle == "Mini" then
				local CurrentFont = self:CreateSurfaceFont("Verdana", 23, 650, {0x010, 0x080})
				self.data.Surface.draw_text(CenterSize.x - 4 + (self.data.ManualState == 1 and - ManualDistance or ManualDistance), CenterSize.y - 14 + ManualHeightAnimation, ManualColor[1], ManualColor[2], ManualColor[3], ManualModifier, CurrentFont, ManualArrows[self.data.ManualState])
			elseif ManualArrowStyle == "<>" then
				renderer.text(CenterSize.x + 2 + (self.data.ManualState == 1 and - ManualDistance or ManualDistance), CenterSize.y - 2 + ManualHeightAnimation, ManualColor[1], ManualColor[2], ManualColor[3], ManualModifier, "c+", 0, ManualArrows[self.data.ManualState])
			else
				renderer.text(CenterSize.x + 2 + (self.data.ManualState == 1 and - ManualDistance or ManualDistance), CenterSize.y - 2 + ManualHeightAnimation, ManualColor[1], ManualColor[2], ManualColor[3], ManualModifier, "c+", 0, ManualArrows[self.data.ManualState])
			end
		end
	end


	local CrosshairFraction = self:NewLerp(0, self.Elements.Visuals.CrosshairIndication:get() and 1 or 0, 70, "Crosshair Fraction")
	if CrosshairFraction > 0 then
		local Hotkeys = {}
		local IsHitable = false
		local DifferentOffset = 0
		local NameAnimationSpeed = 80
		local IsScoped = PrevScoped == 1
		local EmptySize = self.data.Vector(0, 0)
		local CrosshairScopeAnimationSmoothed = 85
		local FakeDuck = ui.get(self.References.fake_duck)
		local ForceBaim = ui.get(self.References.force_body)
		local CanAttack = self:CanAttack(local_player, true)
		local SelfHealth = local_player:get_prop("m_iHealth")
		local LegitAA = self.Elements.AntiAim.LegitOnKey:get()
		local HeadPosition = local_player:get_hitbox_position(0)
		local ThreatTarget = self:NewEntity(client.current_threat())
		local StomachPosition = local_player:get_hitbox_position(2)
		local Freestanding = self.Elements.AntiAim.Freestanding:get()
		local GlowText = self.Elements.Visuals.CrosshairIndication:get()
		local CrosshairStyle = self.Elements.Visuals.CrosshairStyle:get()
		local BarColor = {self.Elements.Visuals.CrosshairBarColor:get()}
		local HotkeyAnimation = self.Elements.Visuals.CrosshairIndication:get()
		local VelocityModifier = local_player:get_prop("m_flVelocityModifier")
		local CrosshairNameStyle = self.Elements.Visuals.CrosshairNameStyle:get()
		local NameRealSideColor = {self.Elements.Visuals.CrosshairRealSideColor:get()}
		local NameFakeSideColor = {self.Elements.Visuals.CrosshairFakeSideColor:get()}
		local CrosshairScopeAnimation = self.Elements.Visuals.CrosshairIndication:get()
		local CrosshairAnimationSide = self.Elements.Visuals.CrosshairAnimationSide:get()
		local ExtraHotkeysColor = {self.Elements.Visuals.CrosshairHotkeysExtraColor:get()}
		local OtherHotkeysColor = {self.Elements.Visuals.CrosshairHotkeysOtherColor:get()}
		local CrosshairAnimationStyle = self.Elements.Visuals.CrosshairAnimationStyle:get()
		local onshotHotkeyColor = {self.Elements.Visuals.CrosshairHotkeysonshotColor:get()}
		local CrosshairScopeAnimationStyle = self.Elements.Visuals.CrosshairIndication:get()
		local onshot = ui.get(self.References.onshot[1]) and ui.get(self.References.onshot[2])
		local GlowFraction = self.Elements.Visuals.CrosshairHotkeySettings:get(1) and 100 or 70
		local DoubleTapHotkeyColor = {self.Elements.Visuals.CrosshairHotkeysDoubleTapColor:get()}
		local GlowThickness = self.Elements.Visuals.CrosshairHotkeySettings:get(2) and (100 / 10) or 10
		local DoubleTap = ui.get(self.References.doubletap[1]) and ui.get(self.References.doubletap[2])
		local HotkeyAnimationSmoothed = self.Elements.Visuals.CrosshairHotkeySettings:get(3) and 80 or 80
		local BasePosition = self.data.Vector(CrosshairFraction * CenterSize.x, CrosshairFraction * CenterSize.y)
		local DamageOverride = ui.get(self.References.min_damage_override[1]) and ui.get(self.References.min_damage_override[2])
		local NameTextSize = self.data.Vector(renderer.measure_text(CrosshairStyle == "Manifold" and "c-" or "cbr", CrosshairStyle == "Manifold" and "PRI-VATE" or self.data.CrosshairName))
		local CrosshairScopeAnimationPercentage = self:CreateStaticTargetAnimation(0, IsScoped and 1 or 0, CrosshairScopeAnimationSmoothed, "Crosshair Scope Animation") or self:NewLerp(0, IsScoped and 1 or 0, CrosshairScopeAnimationSmoothed, "Crosshair Scope Animation")
		if ThreatTarget:is_valid() and ThreatTarget:is_alive() and not ThreatTarget:is_dormant() then
			local TargetEyePosition = self:ExtrapolatePosition(ThreatTarget, ThreatTarget:get_eye_position(), 14)
			local _, HeadDamage = client.trace_bullet(ThreatTarget:get_index(), TargetEyePosition.x, TargetEyePosition.y, TargetEyePosition.z, HeadPosition.x, HeadPosition.y, HeadPosition.z)
			local _, StomachDamage = client.trace_bullet(ThreatTarget:get_index(), TargetEyePosition.x, TargetEyePosition.y, TargetEyePosition.z, StomachPosition.x, StomachPosition.y, StomachPosition.z)
			if HeadDamage > 0 or StomachDamage > 50 or math.max(HeadDamage, StomachDamage) > SelfHealth then
				IsHitable = true
			end
		end

		local PlayerStateTextSize = self.data.Vector(renderer.measure_text(CrosshairStyle == "Manifold" and "c-" or "c-", CrosshairStyle == "Manifold" and ("MOISTEN / %s"):format(("%i"):format(VelocityModifier * 100), "%") or self.data.PlayerStateName:upper()))
		local ScopedTextSize = {
			Name = (CrosshairScopeAnimation and NameTextSize or EmptySize) * CrosshairScopeAnimationPercentage,
			Bar = (CrosshairScopeAnimation and self.data.Vector(50, 5) or EmptySize) * CrosshairScopeAnimationPercentage,
			PlayerState = (CrosshairScopeAnimation and PlayerStateTextSize or EmptySize) * CrosshairScopeAnimationPercentage
		}

		if GlowText and CrosshairStyle == "Concen" then
			self:RenderGlowOutline(BasePosition.x - (NameTextSize.x / 2) + (ScopedTextSize.Name.x / 2), BasePosition.y + 25, NameTextSize.x, 0, GlowThickness, 0, {NameRealSideColor[1], NameRealSideColor[2], NameRealSideColor[3], GlowFraction * CrosshairFraction})
		end

		if CrosshairNameStyle == "Desync" and CrosshairStyle == "Concen" then
			local NameRealSideColor = {NameRealSideColor[1], NameRealSideColor[2], NameRealSideColor[3], NameRealSideColor[4] * CrosshairFraction}
			local NameFakeSideColor = {NameFakeSideColor[1], NameFakeSideColor[2], NameFakeSideColor[3], NameFakeSideColor[4] * CrosshairFraction}
			renderer.text(BasePosition.x + (ScopedTextSize.Name.x / 2), BasePosition.y + 25, 255, 255, 255 * CrosshairFraction, 0, "cbr", 0, (CrosshairAnimationStyle == "Stationary" and 
				self:RgbaToHexGradientText(NameRealSideColor, NameFakeSideColor, self.data.CrosshairName) or CrosshairAnimationStyle == "Opposite" and 
				self:CreateRelativeAnimationText(
					self.data.CrosshairName,
					NameRealSideColor,
					NameFakeSideColor,
					NameAnimationSpeed, CrosshairAnimationSide == "Reversed", CrosshairAnimationSide == "Repeatedly"
				) or self:CreateAnimationText(self.data.CrosshairName, NameRealSideColor, NameFakeSideColor, NameAnimationSpeed, CrosshairAnimationSide == "Reversed", CrosshairAnimationSide == "Repeatedly"))
			)

			self:RenderRoundRectangle(BasePosition.x - 23 + (ScopedTextSize.Bar.x / 2), BasePosition.y + 31, 46, 3, 2, {0, 0, 0, CrosshairFraction * 60})
			if self.data.ManualState == 1 then
				renderer.rectangle(BasePosition.x + (ScopedTextSize.Bar.x / 2), BasePosition.y + 32, - (23 * (math.abs(self.data.BodyYaw) / 60)), 1.5, BarColor[1], BarColor[2], BarColor[3], CrosshairFraction * BarColor[4])
			elseif self.data.ManualState == 2 then
				renderer.rectangle(BasePosition.x + (ScopedTextSize.Bar.x / 2), BasePosition.y + 32, (23 * (math.abs(self.data.BodyYaw) / 60)), 1.5, BarColor[1], BarColor[2], BarColor[3], CrosshairFraction * BarColor[4])
			else
				renderer.rectangle(BasePosition.x + (ScopedTextSize.Bar.x / 2), BasePosition.y + 32, 23 * (self.data.BodyYaw / 60), 1.5, BarColor[1], BarColor[2], BarColor[3], CrosshairFraction * BarColor[4])
			end

			renderer.text(BasePosition.x + (ScopedTextSize.PlayerState.x / 2), BasePosition.y + 38, 255, 255, 255, CrosshairFraction * 255, "c-", 0, self.data.PlayerStateName:upper())
			DifferentOffset = DifferentOffset + 27
		elseif CrosshairNameStyle ~= "Desync" or CrosshairStyle == "Manifold" then
			local NameRealSideColor = {NameRealSideColor[1], NameRealSideColor[2], NameRealSideColor[3], NameRealSideColor[4] * CrosshairFraction}
			local NameFakeSideColor = {NameFakeSideColor[1], NameFakeSideColor[2], NameFakeSideColor[3], NameFakeSideColor[4] * CrosshairFraction}
			renderer.text(BasePosition.x + ((CrosshairScopeAnimation and IsScoped) and 15 or 0) + (ScopedTextSize.Name.x / 2), BasePosition.y + 35, 255, 255, 255 * CrosshairFraction, 0, "c-", 0, (CrosshairAnimationStyle == "Stationary" and 
				self:RgbaToHexGradientText(NameRealSideColor, NameFakeSideColor, self.data.CrosshairName2) or CrosshairAnimationStyle == "Opposite" and 
				self:CreateRelativeAnimationText(
					self.data.CrosshairName2,
					NameRealSideColor,
					NameFakeSideColor,
					NameAnimationSpeed, CrosshairAnimationSide == "Reversed", CrosshairAnimationSide == "Repeatedly"
				) or self:CreateAnimationText(self.data.CrosshairName2, NameRealSideColor, NameFakeSideColor, NameAnimationSpeed, CrosshairAnimationSide == "Reversed", CrosshairAnimationSide == "Repeatedly"))
			)

			self:RenderRoundRectangle(BasePosition.x - 23 + 1 + (ScopedTextSize.Bar.x / 2), BasePosition.y + 29, 46, 3, 2, {0, 0, 0, CrosshairFraction * 60})
			if self.data.ManualState == 1 then
				renderer.rectangle(BasePosition.x + 2 + (ScopedTextSize.Bar.x / 2), BasePosition.y + 30, - (23 * (math.abs(self.data.BodyYaw) / 60)), 1.5, BarColor[1], BarColor[2], BarColor[3], CrosshairFraction * BarColor[4])
			elseif self.data.ManualState == 2 then
				renderer.rectangle(BasePosition.x + 2 + (ScopedTextSize.Bar.x / 2), BasePosition.y + 30, (23 * (math.abs(self.data.BodyYaw) / 60)), 1.5, BarColor[1], BarColor[2], BarColor[3], CrosshairFraction * BarColor[4])
			else
				renderer.rectangle(BasePosition.x + 2 + (ScopedTextSize.Bar.x / 2), BasePosition.y + 30, 23 * (self.data.BodyYaw / 60), 1.5, BarColor[1], BarColor[2], BarColor[3], CrosshairFraction * BarColor[4])
			end
			local NameRadius = self:ToInteger(self.data.CrosshairName:len() / 2)
			local DebugPulse = (math.sin(math.abs(- math.pi + (globals.curtime() * (5/ 6 - 2.2)) % (math.pi * 2))) * 255)
			local NameRealSideColor = {NameRealSideColor[1], NameRealSideColor[2], NameRealSideColor[3], NameRealSideColor[4] * CrosshairFraction}
			local NameFakeSideColor = {NameFakeSideColor[1], NameFakeSideColor[2], NameFakeSideColor[3], NameFakeSideColor[4] * CrosshairFraction}
			local NameSideText = {self.data.CrosshairName:sub(1, NameRadius), self.data.CrosshairName:sub(NameRadius + 1, self.data.CrosshairName:len())}

			renderer.text(BasePosition.x + (ScopedTextSize.Name.x / 2), BasePosition.y + (CrosshairStyle == "Manifold" and 23 or 25), 255, 255, 255 * CrosshairFraction, 0, CrosshairStyle == "Manifold" and "c-" or "c-", 0, NameText)
			if CrosshairStyle == "Concen" then
				renderer.text(BasePosition.x + (ScopedTextSize.PlayerState.x / 2), BasePosition.y + 36, 255, 255, 255, 255 * CrosshairFraction, "c-", 0, self.data.PlayerStateName:upper())
			elseif CrosshairStyle == "Manifold" then
				local PlayerStatePowCrosshairSize = (CrosshairScopeAnimation and EmptySize) * CrosshairScopeAnimationPercentage
				if GlowText then
					self:RenderGlowOutline(BasePosition.x - ((CrosshairScopeAnimation and IsScoped) and 23 or 28) + (ScopedTextSize.PlayerState.x / 2), BasePosition.y + 34, 57, 0, GlowThickness, 0, {self.data.LightPinkedColor[1], self.data.LightPinkedColor[2], self.data.LightPinkedColor[3], GlowFraction * CrosshairFraction})
				end

				renderer.text(BasePosition.x+ ((CrosshairScopeAnimation and IsScoped) and -2 or 0) + (ScopedTextSize.PlayerState.x / 2), BasePosition.y + 25, 255, 255, 255, 0, "c-", 0, ("%s %s %s"):format(
					self:RgbaToHexText(NameRealSideColor, "ALPHA"),
					self:RgbaToHexText({255, 255, 255, 255 * CrosshairFraction}, "/"),
					self:RgbaToHexText(NameFakeSideColor, ("%s%s"):format(("%i"):format(VelocityModifier * 100), "%"))
				))
			end

			DifferentOffset = DifferentOffset + 24
		end

		if self.Elements.Visuals.CrosshairHotkeyStyle:get(1) then
			table.insert(Hotkeys, {
				Type = "DT",
				Color = DoubleTapHotkeyColor,
				Toggle = DoubleTap and not FakeDuck,
				Text = CanAttack and "Rapid" or "ReCharge"
			})

			table.insert(Hotkeys, {
				Type = "OS",
				Text = "OS",
				Color = onshotHotkeyColor,
				Toggle = onshot
			})

			table.insert(Hotkeys, {
				Text = "Dmg",
				Type = "DMG",
				Toggle = DamageOverride,
				Color = OtherHotkeysColor
			})

			table.insert(Hotkeys, {
				Text = "Baim",
				Type = "BAIM",
				Toggle = ForceBaim,
				Color = OtherHotkeysColor
			})

			table.insert(Hotkeys, {
				Text = "Duck",
				Type = "DUCK",
				Toggle = FakeDuck,
				Color = OtherHotkeysColor
			})

			table.insert(Hotkeys, {
				Text = "Fs",
				Type = "FS",
				Toggle = Freestanding,
				Color = OtherHotkeysColor
			})
		end

		if self.Elements.Visuals.CrosshairHotkeyStyle:get(2) then
			table.insert(Hotkeys, {
				Type = "SWITCH",
				Text = "Extra-Switch",
				Color = ExtraHotkeysColor,
				Toggle = self.data.ExtraAntiAimSettings.Switch
			})

			table.insert(Hotkeys, {
				Type = "TICKCOUNT",
				Text = "Extra-Tickcount",
				Color = ExtraHotkeysColor,
				Toggle = self.data.ExtraAntiAimSettings.Tickcount
			})

			table.insert(Hotkeys, {
				Type = "DEFENSIVE",
				Text = "Extra-Defensive",
				Color = ExtraHotkeysColor,
				Toggle = self.data.ExtraAntiAimSettings.DefensiveAntiAim
			})
		end

		for index, data in pairs(Hotkeys) do
			local IsDoubleTap = data.Type == "DT"
			local TargetPercentage = (data.Toggle and 1 or 0)
			local HotkeySize = self.data.Vector(renderer.measure_text("cbr", data.Text:upper()))
			local ScopedHotkeysTextSize = (CrosshairScopeAnimation and self.data.Vector(renderer.measure_text("c-", data.Text:upper())) or EmptySize) * CrosshairScopeAnimationPercentage
			local HotkeysModifier = (HotkeyAnimation and self:CreateStaticTargetAnimation(0, TargetPercentage, HotkeyAnimationSmoothed, ("[%s]Hotkey"):format(data.Type)) or TargetPercentage) * CrosshairFraction
			DifferentOffset = DifferentOffset + (HotkeysModifier * 11)
			local TextPercentage = HotkeysModifier
			if IsDoubleTap and HotkeyAnimation then
				TextPercentage = TextPercentage * self:CreateStaticResetAnimation(0, 1, data.Toggle and CanAttack, 25, ("[%s]Hotkey"):format(data.Type))
			end

			if GlowText then
				local CurrentHotkeySize = (TextPercentage * HotkeySize.x)
				self:RenderGlowOutline(BasePosition.x - (CurrentHotkeySize / 3) + 1 + self:ToInteger(ScopedHotkeysTextSize.x / 2), BasePosition.y + 9 + DifferentOffset, self:ToInteger(CurrentHotkeySize / 1.5), 0, GlowThickness, 0, {data.Color[1], data.Color[2], data.Color[3], GlowFraction * HotkeysModifier})
			end

			if HotkeysModifier > 0 and TextPercentage > 0 then
				renderer.text(BasePosition.x + (ScopedHotkeysTextSize.x / 2), BasePosition.y + 10 + DifferentOffset, data.Color[1], data.Color[2], data.Color[3], HotkeysModifier * data.Color[4], "c-", TextPercentage * HotkeySize.x, data.Text:upper())
			end
		end
	end
end

MOISTEN.__index.TickBase = function(self, e)
	local FakeDuck = ui.get(self.References.fake_duck)
	local local_player = self:NewEntity(entity.get_local_player())
	local LagCompensation = self:GetCvar("cl_lagcompensation")
	local DoubleTapBoost = self.Elements.Misc.DoubleTapBoost:get()
	local ForceDisCharged = self.Elements.Misc.DoubleTapSettings:get(3)
	local ExtendedTickBaseAmount = DoubleTapBoost == "Boost" and 1 or DoubleTapBoost == "Fast" and 2 or 3
	local DoubleTap = ui.get(self.References.doubletap[1]) and ui.get(self.References.doubletap[2]) and not FakeDuck
	if DoubleTapBoost ~= "Off" and ForceDisCharged then
		DoubleTap = ui.get(self.References.doubletap[2]) and not FakeDuck
	end

	if not local_player:is_valid() or not local_player:is_alive() or not self.Elements.MasterSwitch:get() or DoubleTapBoost == "Off" then
		if self.data.ResetLagCompensation then
			LagCompensation:reset()
			self.data.ResetLagCompensation = false
		end

		if not DoubleTap and self.data.ReleaseTickBase then
			self.data.ReleaseTickBase = false
			ui.set(self.References.usrcmdprocessticks, 16)
		end

		if not DoubleTap and self.data.ReleaseDTHitchance then
			self.data.ReleaseDTHitchance = false
			ui.set(self.References.double_tap_hitchance, 0)
		end

		if not DoubleTap and self.data.ReleaseClockCorrection then
			self.data.ReleaseClockCorrection = false
			ui.set(self.References.clockcorrection_msecs, 30)
		end

		return
	end

	if DoubleTap then
		self.data.ReleaseTickBase = true
		local ClockCorrectionMsecs = 20
		local Weapon = local_player:get_player_weapon()
		if self.Elements.Misc.DoubleTapSettings:get(1) then
			local Latency = math.min(1000, client.latency() * 1000)
			if Latency >= 75 then
				ClockCorrectionMsecs = 65
				ExtendedTickBaseAmount = 0
			elseif Latency >= 45 then
				ClockCorrectionMsecs = 55
				ExtendedTickBaseAmount = 1
			elseif Latency >= 25 then
				ClockCorrectionMsecs = 45
				ExtendedTickBaseAmount = 2
			elseif Latency >= 5 then
				ClockCorrectionMsecs = 30
				ExtendedTickBaseAmount = 3
			elseif Latency < 5 then
				ClockCorrectionMsecs = 25
				ExtendedTickBaseAmount = 4
			end

			if Weapon and Weapon:is_valid() then
				local WeaponIndex = Weapon:get_weapon_index()
				local IsPrimaryWeapon = self:Contains({64, 35, 25, 27, 40, 9, 29}, WeaponIndex)
				if IsPrimaryWeapon then
					ClockCorrectionMsecs = 30
					ExtendedTickBaseAmount = 0
				end
			end
		end

		ui.set(self.References.double_tap_fakelag, 1)
		ui.set(self.References.usrcmdprocessticks, 16 + ExtendedTickBaseAmount)
		if self.data.LagCompensationReset then
			LagCompensation:reset()
		elseif not self.data.LagCompensationReset then
			local IsPrimaryWeapon = false
			local AntiDefensive = self.Elements.Misc.DoubleTapSettings:get(5) and self.Elements.Misc.AntiDefensiveKey:get()
			if Weapon and Weapon:is_valid() then
				local WeaponIndex = Weapon:get_weapon_index()
				if self:Contains({64, 35, 25, 27, 40, 9, 29}, WeaponIndex) then
					IsPrimaryWeapon = true
				end
			end

			if IsPrimaryWeapon then
				LagCompensation:reset()
			elseif AntiDefensive then
				LagCompensation:flag(0)
				LagCompensation:set(0)
				self.data.ResetLagCompensation = true
			elseif not AntiDefensive then
				if self.data.ResetLagCompensation then
					LagCompensation:reset()
					self.data.ResetLagCompensation = false
				end
			end
		end

		if self.Elements.Misc.DoubleTapSettings:get(4) then
			self.data.ReleaseClockCorrection = true
			ui.set(self.References.clockcorrection_msecs, ClockCorrectionMsecs)
		elseif self.data.ReleaseClockCorrection then
			self.data.ReleaseClockCorrection = false
			ui.set(self.References.clockcorrection_msecs, 30)
		end

		if self.Elements.Misc.DoubleTapSettings:get(2) then
			self.data.ReleaseDTHitchance = true
			local ThreatTarget = self:NewEntity(client.current_threat())
			if ThreatTarget:is_valid() and ThreatTarget:is_alive() then
				local SelfOrigin = local_player:get_origin()
				local TargetOrigin = ThreatTarget:get_origin()
				local TargetDistance = SelfOrigin:dist(TargetOrigin)
				if TargetDistance then
					local BetweenRatio = (TargetDistance * 0.0254) * 3.281
					if BetweenRatio <= 40 then
						ui.set(self.References.double_tap_hitchance, 1)
					elseif BetweenRatio >= 200 then
						ui.set(self.References.double_tap_hitchance, 62)
					elseif BetweenRatio >= 41 and BetweenRatio <= 199 then
						ui.set(self.References.double_tap_hitchance, self:Clamp(1 + (BetweenRatio - 1) / 150 * 64, 0, 100))
					end
				end
			end
		end

	elseif not DoubleTap then
		if self.data.ResetLagCompensation then
			LagCompensation:reset()
			self.data.ResetLagCompensation = false
		end
	end

	if ForceDisCharged then
		local Weapon = local_player:get_player_weapon()
		if Weapon and Weapon:is_valid() then
			local ShouldCharged = true
			local CurTime = globals.curtime()
			local BacktrackTicks = self:ToInteger(toticks(0.2))
			local CanAttack = self:CanAttack(local_player, true)
			local WeaponIndex = Weapon:get_weapon_index()
			local WeaponClassName = Weapon:get_classname()
			local HeadPosition = local_player:get_hitbox_position(0)
			local WeaponData = self.data.CsgoWeapons[WeaponIndex]
			local BacktrackScan = self.Elements.Misc.DisChargeBackTrackScan:get()
			local IsDischargeWeapon = self:Contains({64, 35, 25, 27, 40, 9, 29}, WeaponIndex)
			local HistoryHeadPositions = self:UpdateHistory(HeadPosition, BacktrackTicks, "Self HeadPosition")
			local ActivateIsThrowWeapon = self:Contains({
				"CSnowball",
				"CFlashbang",
				"CHEGrenade",
				"CDecoyGrenade",
				"CSensorGrenade",
				"CSmokeGrenade",
				"CMolotovGrenade",
				"CIncendiaryGrenade"
			}, WeaponClassName)
			if math.abs(CurTime - self.data.WeaponReActiveTimer) > 0.5 then
				self.data.WeaponReActiveTimer = CurTime
			end

			if not CanAttack then
				if math.abs(CurTime - self.data.LastUpdateAttack) >= totime(14 + ExtendedTickBaseAmount) then
					self.data.LastCanAttack = false
				end

			elseif CanAttack then
				self.data.LastCanAttack = true
				self.data.LastUpdateAttack = CurTime
			end

			if self.data.WeaponIndex ~= WeaponIndex then
				self.data.WeaponIndex = WeaponIndex
				local NextAttackTimer = self.data.LastCanAttack and WeaponData.cycletime or WeaponData.cycletime_alt
				self.data.WeaponReActiveTimer = (CurTime + NextAttackTimer) + 0.05
			end

			for _, ptr in pairs(entity.get_players(true)) do
				local Target = self:NewEntity(ptr)
				if Target:is_valid() and Target:is_alive() and not Target:is_dormant() then
					local TargetEyePosition = Target:get_eye_position()
					local _, AttackDamage = client.trace_bullet(Target:get_index(), TargetEyePosition.x, TargetEyePosition.y, TargetEyePosition.z, HeadPosition.x, HeadPosition.y, HeadPosition.z)
					if AttackDamage > 0 then
						ShouldCharged = false
						IsDischargeWeapon = false
						break
					elseif BacktrackScan and AttackDamage <= 0 then
						local BacktrackHeadPosition = HistoryHeadPositions[BacktrackTicks]
						local _, AttackHistoryDamage = client.trace_bullet(Target:get_index(), TargetEyePosition.x, TargetEyePosition.y, TargetEyePosition.z, BacktrackHeadPosition.x, BacktrackHeadPosition.y, BacktrackHeadPosition.z)
						if AttackHistoryDamage > 0 then
							ShouldCharged = false
							IsDischargeWeapon = false
							break
						end
					end	
				end
			end

			if not (self.data.LastCanAttack or self.data.WeaponReActiveTimer > CurTime) then
				self.data.needcharge = false
			elseif self.data.LastCanAttack and ShouldCharged and not self.data.needcharge then
				self.data.needcharge = true
			end

			self.data.ReleaseDoubleTapDischarged = true
			ui.set(self.References.doubletap[1], (self.data.needcharge and (self.data.LastCanAttack or self.data.WeaponReActiveTimer > CurTime)) or ActivateIsThrowWeapon or IsDischargeWeapon)
		elseif self.data.ReleaseDoubleTapDischarged then
			ui.set(self.References.doubletap[1], true)
			self.data.ReleaseDoubleTapDischarged = false
		end

	elseif self.data.ReleaseDoubleTapDischarged then
		ui.set(self.References.doubletap[1], true)
		self.data.ReleaseDoubleTapDischarged = false
	end
end

MOISTEN.__index.FakeLag = function(self, e)
	local local_player = self:NewEntity(entity.get_local_player())
	if not local_player:is_valid() or not local_player:is_alive() or not self.Elements.MasterSwitch:get() then
		if self.data.RestoredMaxProcessTicks then
			self.data.RestoredMaxProcessTicks = false
			ui.set(self.References.usrcmdprocessticks, 16)
			ui.set(self.References.usrcmdprocessticks_holdaim, true)
		end

		if self.data.ShotFakelagReset then
			self.data.ShotFakelagReset = false
			ui.set(self.References.body_yaw[1], "Static")
		end

		return
	end

	local OnPeekTrigger = false
	local Velocity = local_player:get_velocity()
	local Jumping = local_player:get_jumping()
	local Weapon = local_player:get_player_weapon()
	local FakeDuck = ui.get(self.References.fake_duck)
	local FakelagLimit = self.Elements.Fakelag.FakelagLimit:get()
	local DoubleTapBoost = self.Elements.Misc.DoubleTapBoost:get()
	local FakelagAmount = self.Elements.Fakelag.FakelagAmount:get()
	local FakelagVariance = self.Elements.Fakelag.FakelagVariance:get()
	local FakelagonshotStyle = self.Elements.Fakelag.FakelagResetonshotStyle:get()
	local onshot = ui.get(self.References.onshot[1]) and ui.get(self.References.onshot[2]) and not FakeDuck
	local DoubleTap = ui.get(self.References.doubletap[1]) and ui.get(self.References.doubletap[2]) and not FakeDuck
	if self.Elements.Fakelag.FakelagOptions:get(5) then
		DoubleTap = ui.get(self.References.doubletap[2]) and self.Elements.Misc.DoubleTapBoost:get() ~= "Off" and self.Elements.Misc.DoubleTapSettings:get(3)
	end

	if self.Elements.Fakelag.FakelagOptions:get(4) and not onshot and not DoubleTap then
		local EyePosition = self:ExtrapolatePosition(local_player, local_player:get_eye_position(), 14)
		for _, ptr in pairs(entity.get_players(true)) do
			local TargetEntity = self:NewEntity(ptr)
			if TargetEntity:is_valid() and TargetEntity:is_alive() and TargetEntity:is_enemy() then
				local TargetEyePosition = TargetEntity:get_eye_position()
				local Fraction, _ = client.trace_line(local_player:get_index(), EyePosition.x, EyePosition.y, EyePosition.z, TargetEyePosition.x, TargetEyePosition.y, TargetEyePosition.z)
				local _, Damage = client.trace_bullet(TargetEntity:get_index(), EyePosition.x, EyePosition.y, EyePosition.z, TargetEyePosition.x, TargetEyePosition.y, TargetEyePosition.z)
				if Damage > 0 and Fraction < 0.8 then
					OnPeekTrigger = true
					break
				end
			end
		end

		if OnPeekTrigger then
			FakelagLimit = math.random(14,16)
			FakelagVariance = 27
			FakelagAmount = "Maximum"
		elseif Velocity > 20 and not Jumping then
			FakelagLimit = math.random(14,16)
			FakelagVariance = 24
			FakelagAmount = "Maximum"
		elseif Jumping then
			FakelagLimit = math.random(14,16)
			FakelagVariance = 39
			FakelagAmount = "Maximum"
		end
	end

	if self.Elements.Fakelag.FakelagOptions:get(2) and Jumping and not onshot and not DoubleTap then
		FakelagVariance = math.random(21,28)
		FakelagAmount = "Fluctuate"
	end

	if self.Elements.Fakelag.FakelagOptions:get(3) and Weapon and Weapon:is_valid() and not FakeDuck and not onshot and not DoubleTap then
		local LastShotTimer = Weapon:get_prop("m_fLastShotTime")
		local EyePosition = self:ExtrapolatePosition(local_player, local_player:get_eye_position(), 14)
		if math.abs(toticks(globals.curtime() - LastShotTimer)) < 6 then
			local BreakLC = false
			for _, ptr in pairs(entity.get_players(true)) do
				local TargetEntity = self:NewEntity(ptr)
				if TargetEntity:is_valid() and TargetEntity:is_alive() and TargetEntity:is_enemy() then
					local TargetEyePosition = TargetEntity:get_eye_position()
					local _, Damage = client.trace_bullet(TargetEntity:get_index(), EyePosition.x, EyePosition.y, EyePosition.z, TargetEyePosition.x, TargetEyePosition.y, TargetEyePosition.z)
					if Damage > 0 then
						BreakLC = true
						break	
					end
				end
			end

			if BreakLC then
				FakelagVariance = 26
				FakelagAmount = "Fluctuate"
			end
		end

		if math.abs(toticks(globals.curtime() - LastShotTimer)) < (FakelagonshotStyle == "Default" and 3 or FakelagonshotStyle == "Safest" and 4 or 5) then
			FakelagLimit = 1
			e.no_choke = true
			self.data.ShotFakelagReset = true
			ui.set(self.References.body_yaw[1], "Off")
			ui.set(self.References.usrcmdprocessticks_holdaim, false)
		elseif self.data.ShotFakelagReset then
			self.data.ShotFakelagReset = false
			ui.set(self.References.body_yaw[1], "Static")
			ui.set(self.References.usrcmdprocessticks_holdaim, true)
		end

	elseif self.data.ShotFakelagReset then
		self.data.ShotFakelagReset = false
		ui.set(self.References.body_yaw[1], "Static")
		ui.set(self.References.usrcmdprocessticks_holdaim, true)
	end

	if FakeDuck or onshot or (DoubleTap and DoubleTapBoost == "Off") then
		FakelagLimit = 15
		FakelagVariance = 0
		self.data.OverrideProcessticks = true
		ui.set(self.References.usrcmdprocessticks, 16)
	elseif not FakeDuck and not onshot and not DoubleTap and self.data.OverrideProcessticks then
		self.data.OverrideProcessticks = false
		if FakelagLimit > (ui.get(self.References.usrcmdprocessticks) - 1) then
			ui.set(self.References.usrcmdprocessticks, FakelagLimit + 1)
		end
	end

	if self.Elements.Fakelag.FakelagOptions:get(1) and not Jumping and not onshot and not DoubleTap then
		e.allow_send_packet = e.chokedcommands >= FakelagLimit
	end

	self.data.RestoredMaxProcessTicks = true
	ui.set(self.References.fakelag_reference, true)
	ui.set(self.References.fakelag_amount, FakelagAmount)
	ui.set(self.References.fakelag_variance, FakelagVariance)
	ui.set(self.References.fakelag_limit, self:Clamp(FakelagLimit, 1, ui.get(self.References.usrcmdprocessticks) - 1))
end

MOISTEN.__index.AntiAim = function(self, e)
	self.data.MovementState.Back = e.in_back == 1
	self.data.MovementState.Left = e.in_moveleft == 1
	self.data.MovementState.Right = e.in_moveright == 1
	self.data.MovementState.Forward = e.in_forward == 1
	local local_player = self:NewEntity(entity.get_local_player())
	if not local_player:is_valid() or not local_player:is_alive() or not self.Elements.MasterSwitch:get() then
		self.data.ManualState = 0
		self.data.PlayerStateName = "Default"
		self.data.ExtraAntiAimSettings.Switch = false
		self.data.ExtraAntiAimSettings.Tickcount = false
		self.data.ExtraAntiAimSettings.DefensiveAntiAim = false
		if self.data.UnlocketExtendedAngles then
			ui.set(self.References.untrusted, true)
			self.data.UnlocketExtendedAngles = false
		end

		return
	end

	self:ManualAntiAim()
	local ForceDefensive = false
	local TeamID = local_player:get_team()
	local PlayerState = self:GetPlayerState()
	local Velocity = local_player:get_velocity()
	local Jumping = local_player:get_jumping()
	self:UpdateTickcount(e.command_number)
	self.data.ExtraAntiAimSettings.Switch = false
	local ShouldAntiAim = self:ShouldAntiAim(e)
	local BodyYaw = local_player:get_body_yaw()
	local SendPacket = e.chokedcommands <= 0
	self.data.ExtraAntiAimSettings.Tickcount = false
	local FakeDuck = ui.get(self.References.fake_duck)
	local LegitKey = self.Elements.AntiAim.LegitOnKey:get()
	self.data.ExtraAntiAimSettings.DefensiveAntiAim = false
	local EyePosition = self.data.Vector(client.eye_position())
	local ThreatTarget = self:NewEntity(client.current_threat())
	local CameraAngles = self.data.Vector(client.camera_angles())
	local AntiBackStab = self.Elements.Misc.AntiBackStab:get()
	local ForceStaticDormant = self.Elements.Misc.ForceDormant:get()
	local OverrideAntiAim = true
	local DefensiveAntiAim = self.Elements.Misc.DefensiveOverride1:get(2)
	self.data.PlayerStateName = ("·  %s  ·"):format(self.data.PlayerState[PlayerState])
	self.data.PlayerStateName2 = ("  %s  "):format(self.data.PlayerState[PlayerState])
	local Data = self.Elements.AntiAim.Custom[TeamID == 2 and 1 or 2][PlayerState]
	local onshot = ui.get(self.References.onshot[1]) and ui.get(self.References.onshot[2])
	local DoubleTap = ui.get(self.References.doubletap[1]) and ui.get(self.References.doubletap[2])
	local ForceStaticManual = self.data.ManualState > 0 and self.data.ManualState < 4
	if SendPacket then
		self.data.Flip = not self.data.Flip
	end

	local AntiAimContext = {
		ForceStatic = false,
		BaseOverride = false,
		Yaw = Data.Yaw:get(),
		Pitch = Data.Pitch:get(),
		DefensivePitchAngles = 90,
		YawBase = Data.YawBase:get(),
		BodyYaw = Data.BodyYaw:get(),
		YawOffset = Data.YawOffset:get(),
		YawJitter = Data.YawJitter:get(),
		DefensivePitchExtraAngles = - 90,
		PitchAngles = Data.PitchAngles:get(),
		FakeYawLimit = Data.FakeYawLimit:get(),
		DefensiveYaw = Data.DefensiveYaw:get(),
		BodyYawExtra = Data.BodyYawExtra:get(),
		YawJitterWays = Data.YawJitterWays:get(),
		BodyYawOffset = Data.BodyYawOffset:get(),
		PitchTickcount = Data.PitchTickcount:get(),
		DefensivePitch = Data.DefensivePitch:get(),
		YawExtraOffset = Data.YawExtraOffset:get(),
		EdgeYaw = self.Elements.AntiAim.EdgeYaw:get(),
		PitchExtraAngles = Data.PitchExtraAngles:get(),
		DefensiveYawWays = Data.DefensiveYawWays:get(),
		YawJitterOffset = Data.YawJitterOffsetLeft:get(),
		DefensiveTriggers = Data.DefensiveTriggers:get(),
		FakeYawLimitStyle = Data.FakeYawLimitStyle:get(),
		ExtraFakeYawLimit = Data.ExtraFakeYawLimit:get(),
		BodyYawExtraTimer = Data.BodyYawExtraTimer:get(),
		YawJitterTickcount = Data.YawJitterTickcount:get(),
		DefensivePitchWays = Data.DefensivePitchWays:get(),
		BodyYawExtraOffset = Data.BodyYawExtraOffset:get(),
		DefensivePitchMode = Data.DefensivePitchMode:get(),
		DefensiveYawAngles = Data.DefensiveYawAngles:get(),
		FakeYawLimitUpdate = Data.FakeYawLimitUpdate:get(),
		FreestandingBodyYaw = Data.Freestandingbodyyaw:get(),
		Freestanding = self.Elements.AntiAim.Freestanding:get(),
		FakeYawLimitTickcount = Data.FakeYawLimitTickcount:get(),
		BodyYawExtraTickcount = Data.BodyYawExtraTickcount:get(),
		DefensivePitchFlickMode = Data.DefensivePitchFlickMode:get(),
		ForceDefensive = self.Elements.Misc.DefensiveOverride1:get(1),
		DefensiveOverride = self.Elements.Misc.DefensiveOverride1:get(),
		DefensiveTriggerTickcount = Data.DefensiveConditionTickcount:get(),
		DefensiveDifferentTickcount = Data.DefensiveDifferentTickcount:get(),
		DefensiveStepTickcount = Data.DefensiveOverrideConditionTickcount:get(),

	}



	if AntiAimContext.BodyYaw == "Static" then
		BodyYaw = self:Clamp(AntiAimContext.BodyYawOffset, - 60, 60)
		AntiAimContext.YawJitterOffset =  Data.YawJitterOffsetLeft:get()
	elseif AntiAimContext.BodyYaw == "Jitter #Advanced" and AntiAimContext.BaseOverride then
		AntiAimContext.BodyYawOffset = self:NormalizedYaw(AntiAimContext.BodyYawOffset + 90)
	end

	if AntiAimContext.Yaw == "180 Left/Right" then
		AntiAimContext.Yaw = "180"
		AntiAimContext.YawOffset = BodyYaw > 0 and AntiAimContext.YawExtraOffset or AntiAimContext.YawOffset
	end

		local Ducking = local_player:get_ducking()
		if Velocity > 260 or Ducking or Jumping then
			AntiAimContext.EdgeYaw = false
			AntiAimContext.Freestanding = false
		end

	if AntiAimContext.Pitch == "Jitter" then
		AntiAimContext.Pitch = "Custom"
		AntiAimContext.PitchAngles = self.data.Flip and AntiAimContext.PitchExtraAngles or AntiAimContext.PitchAngles
	elseif AntiAimContext.Pitch == "Tickcount" then
		AntiAimContext.Pitch = "Custom"
		self.data.ExtraAntiAimSettings.Tickcount = true
		AntiAimContext.PitchAngles = self:GetTickcountSwitch(({
			[3] = 4,
			[2] = 8,
			[0] = 32,
			[1] = 16
		})[AntiAimContext.PitchTickcount]) and AntiAimContext.PitchExtraAngles or AntiAimContext.PitchAngles
	end


		

	if AntiAimContext.ForceDefensive and AntiAimContext.DefensiveOverride and DefensiveAntiAim then
		local ForceDefensiveCondition = false
		if Data.enabled_exploit:get() and (ui.get(self.References.doubletap[1]) and ui.get(self.References.doubletap[2]) or ui.get(self.References.onshot[1]) and ui.get(self.References.onshot[2])) and not ui.get(self.References.fake_duck) then
			if AntiAimContext.DefensiveOverrideTriggers == "Always On" then
				ForceDefensiveCondition = true
			elseif AntiAimContext.DefensiveOverrideTriggers == "Simulate" and self.data.isDefon then
				ForceDefensiveCondition = true
			elseif AntiAimContext.DefensiveOverrideTriggers == "Shifting" and self.data.IsTickbaseDefensiveActive then
				ForceDefensiveCondition = true
			elseif AntiAimContext.DefensiveOverrideTriggers == "Tickcount" and globals.tickcount() % AntiAimContext.DefensiveStepTickcount >= AntiAimContext.DefensiveCommandTickcount then
				ForceDefensiveCondition = true
			elseif AntiAimContext.DefensiveOverrideTriggers == "Random" and globals.tickcount() % iRandomValue(6, 7, 64) >= iRandomValue(4, 2, 32) then
				e.force_defensive = true
			end
		else
			if Data.enabled_exploit:get() and (ui.get(self.References.doubletap[1]) and ui.get(self.References.doubletap[2]) or ui.get(self.References.onshot[1]) and ui.get(self.References.onshot[2])) and not ui.get(self.References.fake_duck) then
				local Origin = local_player:get_origin()
				if Jumping then
					if self.data.SelfHeight == 0 then
						self.data.SelfHeight = Origin.z
					end

					if self.data.SelfHeight > Origin.z then
						self.data.SelfHeight = Origin.z
						ForceDefensiveCondition = true
					end

				elseif not Jumping then
					self.data.SelfHeight = 0
				end
			end


				if Velocity < 1.1 then
					self.data.SelfVelocity = 0
				elseif self.data.SelfVelocity < Velocity then
					self.data.SelfVelocity = Velocity
					ForceDefensiveCondition = true
				end
		end

		if Data.enabled_exploit:get() and (ui.get(self.References.doubletap[1]) and ui.get(self.References.doubletap[2]) or ui.get(self.References.onshot[1]) and ui.get(self.References.onshot[2])) and not ui.get(self.References.fake_duck) then
			local ExtrapolatePosition = self:ExtrapolatePosition(local_player, EyePosition, 14)
			for _, ptr in pairs(entity.get_players(true)) do
				local Target = self:NewEntity(ptr)
				if Target:is_valid() and Target:is_alive() and Target:is_enemy() and not Target:is_dormant() then
					local TargetHeadPosition = self:ExtrapolatePosition(Target, Target:get_hitbox_position(0), 14)
					local Fraction, EntIndex = client.trace_line(local_player:get_index(), ExtrapolatePosition.x, ExtrapolatePosition.y, ExtrapolatePosition.z, TargetHeadPosition.x, TargetHeadPosition.y, TargetHeadPosition.z)
					if Fraction > 0.8 then
						ForceDefensiveCondition = false
						break
					end
				end
			end
		end

		if Data.enabled_exploit1:get() then
			if AntiAimContext.DefensiveYaw == "Sync" and self:GetTimerSwitch(18 / 100) then
				AntiAimContext.YawOffset = AntiAimContext.DefensiveYawAngles
			elseif AntiAimContext.DefensiveYaw == "Flick" then
				AntiAimContext.YawOffset = self:GetTimerSwitchWays({6 / 100, 37 / 100}, {false, true}) and AntiAimContext.DefensiveYawAngles or AntiAimContext.YawOffset
			elseif AntiAimContext.DefensiveYaw == "Flick Random" then
				AntiAimContext.YawOffset = self:GetTimerSwitchWays({41 / 100, 13 / 100}, {false, true}) and iRandomValue(0, AntiAimContext.DefensiveYawAngles, 64) or AntiAimContext.YawOffset
			elseif AntiAimContext.DefensiveYaw == "X-Ways" then
				AntiAimContext.YawOffset = self:GetTimerSwitchWays({38 / 100, 23 / 100}, {false, true}) and self:CreateWays(AntiAimContext.DefensiveYawWays, AntiAimContext.DefensiveYawAngles) or AntiAimContext.YawOffset
			end
		end
		if Data.enabled_exploit:get() then
			if AntiAimContext.DefensivePitch == "Sync" then
				AntiAimContext.Pitch = "Custom"
				AntiAimContext.PitchAngles = self:GetTimerSwitch(18 / 100) and AntiAimContext.DefensivePitchExtraAngles or AntiAimContext.DefensivePitchAngles
			elseif AntiAimContext.DefensivePitch == "Flick" then
				AntiAimContext.Pitch = "Custom"
				AntiAimContext.PitchAngles = self:GetTimerSwitchWays({6 / 100, 37 / 100}, {AntiAimContext.DefensivePitchExtraAngles, AntiAimContext.DefensivePitchAngles})
			elseif AntiAimContext.DefensivePitch == "Flick Random" then
				AntiAimContext.Pitch = "Custom"
				AntiAimContext.PitchAngles = ({AntiAimContext.DefensivePitchAngles, iRandomValue(0, - 90, 32)})[self:GetTimerSwitchWays({41 / 100, 13 / 100}, {1, 2})]
			elseif AntiAimContext.DefensivePitch == "X-Ways" then
				AntiAimContext.Pitch = "Custom"
				AntiAimContext.PitchAngles = ({AntiAimContext.DefensivePitchAngles, self:CreateWays(AntiAimContext.DefensivePitchWays, - 90)})[self:GetTimerSwitchWays({38 / 100, 23 / 100}, {1, 2})]
			elseif AntiAimContext.DefensivePitch == "Flick Mode" then
				AntiAimContext.Pitch = self:GetTimerSwitchWays({33 / 100, iRandomValue(4 / 100, 8 / 100, 32)}, {AntiAimContext.DefensivePitchMode, AntiAimContext.DefensivePitchFlickMode})
			end
		end
	end

	if ForceStaticDormant then
		local IsDormant = true
		for _, ptr in pairs(entity.get_players(true)) do
			local Target = self:NewEntity(ptr)
			if Target:is_valid() and Target:is_alive() and Target:is_enemy() and not Target:is_dormant() then
				IsDormant = false
			end
		end

		if IsDormant then
			AntiAimContext.YawOffset = 7
			AntiAimContext.YawJitter = "Off"
			AntiAimContext.ForceStatic = true
			AntiAimContext.FakeYawLimit = 25
			AntiAimContext.BodyYaw = "Static"
			AntiAimContext.BodyYawOffset = 90
			AntiAimContext.FakeYawLimitStyle = "Default"
			AntiAimContext.Freestandingbodyyaw = false
		end
	end

	if self.data.ManualState > 0 and self.data.ManualState < 4 and not LegitKey then
		if ForceStaticManual then
			AntiAimContext.EdgeYaw = false
			AntiAimContext.YawJitter = "Off"
			AntiAimContext.ForceStatic = true
			AntiAimContext.FakeYawLimit = 60
			AntiAimContext.BodyYaw = "Static"
			AntiAimContext.Freestanding = false
			AntiAimContext.YawBase = "Local view"
			AntiAimContext.FreestandingBodyYaw = false
			AntiAimContext.FakeYawLimitStyle = "Default"
		end

		if not Jumping then
			AntiAimContext.BodyYaw = "Static"
			AntiAimContext.BodyYawOffset = 90
		elseif Jumping then
			AntiAimContext.BaseOverride = false
			local HoldingTicks = self.data.ManualHiddenData.Base == 0 and 10 or 3
			local BodyYaw = self.data.ManualHiddenData.Base == 0 and "Opposite" or "Jitter"
			if math.abs(globals.tickcount() - self.data.ManualHiddenData.Ticks) > HoldingTicks then
				self.data.ManualHiddenData.Ticks = globals.tickcount()
				self.data.ManualHiddenData.Base = self.data.ManualHiddenData.Base == 0 and 1 or 0
			end

			if AntiAimContext.BodyYaw ~= "Static" and BodyYaw == "Static" then
				AntiAimContext.BodyYawOffset = 90
			end

			AntiAimContext.BodyYaw = BodyYaw
		end

		self.data.PlayerStateName = ({
			[1] = "L-90°",
			[2] = "R-90°",
			[3] = "F-180°"
		})[self.data.ManualState]
		AntiAimContext.YawOffset = ({
			[2] = 90,
			[3] = 180,
			[1] = - 90
		})[self.data.ManualState] or (AntiAimContext.YawOffset + ({
			[2] = 90,
			[3] = 180,
			[1] = - 90
		})[self.data.ManualState])
	end

	if AntiBackStab then
		for _, ptr in pairs(entity.get_players(true)) do
			local Target = self:NewEntity(ptr)
			if Target:is_valid() and Target:is_alive() and Target:is_enemy() and not Target:is_dormant() then
				local Weapon = Target:get_player_weapon()
				if Weapon and Weapon:is_valid() then
					local WeaponClassName = Weapon:get_classname()
					if WeaponClassName == "CKnife" then
						local TargetHeadPosition = Target:get_hitbox_position(0)
						local Fraction, EntIndex = client.trace_line(local_player:get_index(), EyePosition.x, EyePosition.y, EyePosition.z, TargetHeadPosition.x, TargetHeadPosition.y, TargetHeadPosition.z)
						if Fraction > 0.8 and EyePosition:dist(TargetHeadPosition) < 150 then
							AntiAimContext.Yaw = "180"
							AntiAimContext.YawJitter = "Off"
							AntiAimContext.YawOffset = 180
							AntiAimContext.YawBase = "At targets"
							self.data.PlayerStateName = "Anti-Backstab"
							break
						end
					end
				end
			end
		end
	end

	if AntiAimContext.YawJitter == "X-Ways" and not AntiAimContext.ForceStatic then
		AntiAimContext.YawJitter = "Off"
		AntiAimContext.YawOffset = AntiAimContext.YawOffset + self:CreateWays(AntiAimContext.YawJitterWays, AntiAimContext.YawJitterOffset)
	elseif AntiAimContext.YawJitter ~= "Skitter" and AntiAimContext.YawJitterTickcount > 0 and not AntiAimContext.ForceStatic then
		local YawJitterOffset = (AntiAimContext.BodyYawOffset > 0 and math.abs(AntiAimContext.YawJitterOffset) or - math.abs(AntiAimContext.YawJitterOffset)) or AntiAimContext.YawJitterOffset
		local YawJitterTickcountState = self:GetTickcountSwitch(({
			[1] = 6,
			[2] = iRandomValue(8, 10, iRandomValue(16, 64, 32)),
		})[AntiAimContext.YawJitterTickcount])
		if AntiAimContext.YawJitter == "Offset" then
			AntiAimContext.YawOffset = AntiAimContext.YawOffset + (YawJitterTickcountState and YawJitterOffset or 0)
		elseif AntiAimContext.YawJitter == "Center" then
			local CenterOffset = YawJitterOffset / 2
			AntiAimContext.YawOffset = AntiAimContext.YawOffset + (YawJitterTickcountState and CenterOffset or - CenterOffset)
		elseif AntiAimContext.YawJitter == "Random" then
			AntiAimContext.YawOffset = AntiAimContext.YawOffset + (YawJitterTickcountState and math.random(0, YawJitterOffset) or 0)
		end

		AntiAimContext.YawJitter = "Off"
	end

	if ForceDefensive then
		e.force_defensive = true
		AntiAimContext.BaseOverride = OverrideAntiAim
	elseif ShouldAntiAim and OverrideAntiAim and not AntiAimContext.Freestanding and not AntiAimContext.EdgeYaw then
		AntiAimContext.BaseOverride = true
		if AntiAimContext.ForceDefensive and DefensiveAntiAim then
			self.data.ExtraAntiAimSettings.DefensiveAntiAim = true
			if AntiAimContext.DefensiveTriggers == "Always On" then
				e.force_defensive = true
			elseif AntiAimContext.DefensiveTriggers == "Simulate" and self.data.isDefon then
				e.force_defensive = true
			elseif AntiAimContext.DefensiveTriggers == "Shifting" and self.data.IsTickbaseDefensiveActive then
				e.force_defensive = true
			elseif AntiAimContext.DefensiveTriggers == "Tickcount" and globals.tickcount() % AntiAimContext.DefensiveTriggerTickcount >= AntiAimContext.DefensiveDifferentTickcount then
				e.force_defensive = true
			elseif AntiAimContext.DefensiveTriggers == "Random" and globals.tickcount() % math.random(6, 7) >= math.random(2, 5) then
				e.force_defensive = true
			end
		end
	else
		if AntiAimContext.ForceDefensive and DefensiveAntiAim then
			self.data.ExtraAntiAimSettings.DefensiveAntiAim = true
			if AntiAimContext.DefensiveTriggers == "Always On" then
				e.force_defensive = true
			elseif AntiAimContext.DefensiveTriggers == "Simulate" and self.data.isDefon then
				e.force_defensive = true
			elseif AntiAimContext.DefensiveTriggers == "Shifting" and self.data.IsTickbaseDefensiveActive then
				e.force_defensive = true
			elseif AntiAimContext.DefensiveTriggers == "Tickcount" and globals.tickcount() % AntiAimContext.DefensiveTriggerTickcount >= AntiAimContext.DefensiveDifferentTickcount then
				e.force_defensive = true
			elseif AntiAimContext.DefensiveTriggers == "Random" and globals.tickcount() % math.random(6, 7) >= math.random(2, 5) then
				e.force_defensive = true
			end
		end
	end

	if not AntiAimContext.BaseOverride and not AntiAimContext.ForceStatic then
		if AntiAimContext.BodyYawExtra == "Switch" then
			self.data.ExtraAntiAimSettings.Switch = true
			AntiAimContext.BodyYawOffset = self.data.Flip and AntiAimContext.BodyYawExtraOffset or AntiAimContext.BodyYawOffset
		elseif AntiAimContext.BodyYawExtra == "Timer" then
			AntiAimContext.BodyYawOffset = self:GetTimerSwitch(AntiAimContext.BodyYawExtraTimer / 100) and AntiAimContext.BodyYawExtraOffset or AntiAimContext.BodyYawOffset
		elseif AntiAimContext.BodyYawExtra == "Tickcount" then
			AntiAimContext.BodyYawOffset = self:GetTickcountSwitch(({
				[3] = 4,
				[2] = 8,
				[0] = 32,
				[1] = 16
			})[AntiAimContext.BodyYawExtraTickcount]) and AntiAimContext.BodyYawExtraOffset or AntiAimContext.BodyYawOffset
		elseif AntiAimContext.BodyYawExtra == "Random" then
			AntiAimContext.BodyYawOffset = iRandomValue(42, - 37, 16)
		end
	end

	if LegitKey then
		local UseKeyState = false
		AntiAimContext.Yaw = "Off"
		AntiAimContext.Pitch = "Off"
		AntiAimContext.YawOffset = 0
		AntiAimContext.PitchAngles = 0
		AntiAimContext.EdgeYaw = false
		AntiAimContext.YawJitter = "Off"
		AntiAimContext.FakeYawLimit = 60
		self.data.PlayerStateName = "·  180° ·"
		AntiAimContext.Freestanding = false
		AntiAimContext.BaseOverride = false
		AntiAimContext.BodyYawOffset = math.random(90, - 90)
		AntiAimContext.YawBase = "Local view"
		AntiAimContext.FreestandingBodyYaw = true
		AntiAimContext.FakeYawLimitStyle = "Default"
		for _, ptr in pairs(entity.get_all("CBaseDoor")) do
			local DoorOrigin = self.data.Vector(entity.get_origin(ptr))
			if DoorOrigin and EyePosition:dist(DoorOrigin) < 75 then
				UseKeyState = true
				break
			end
		end

		for _, ptr in pairs(entity.get_all("CPropDoorRotating")) do
			local DoorOrigin = self.data.Vector(entity.get_origin(ptr))
			if DoorOrigin and EyePosition:dist(DoorOrigin) < 75 then
				UseKeyState = true
				break
			end
		end

		if TeamID == 3 and not UseKeyState then
			for _, ptr in pairs(entity.get_all("CHostage")) do
				local HostageOrigin = self.data.Vector(entity.get_origin(ptr))
				if HostageOrigin and EyePosition:dist(HostageOrigin) < 100 then
					UseKeyState = true
					break
				end
			end
		end

		if TeamID == 3 and not UseKeyState then
			for _, ptr in pairs(entity.get_all("CPlantedC4")) do
				local BombOrigin = self.data.Vector(entity.get_origin(ptr))
				if BombOrigin and EyePosition:dist(BombOrigin) < 150 then
					UseKeyState = true
					break
				end
			end
		end

		self:UpdateUseKey(UseKeyState)
	elseif not LegitKey then
		self:UpdateUseKey(true)
	end

	ui.set(self.References.enabled, true)
	ui.set(self.References.freestanding[1], true)
	ui.set(self.References.yaw[1], AntiAimContext.Yaw)
	ui.set(self.References.yaw_base, AntiAimContext.YawBase)
	ui.set(self.References.edge_yaw, AntiAimContext.EdgeYaw)
	ui.set(self.References.yaw_jitter[1], AntiAimContext.YawJitter)
	ui.set(self.References.yaw_jitter[2], AntiAimContext.YawJitterOffset)
	ui.set(self.References.freestanding_body_yaw, AntiAimContext.FreestandingBodyYaw)
	ui.set(self.References.pitch[2], 0 or AntiAimContext.PitchAngles)
	ui.set(self.References.freestanding[2], AntiAimContext.Freestanding and "Always on" or "On hotkey")
	ui.set(self.References.body_yaw[2], AntiAimContext.BaseOverride and 0 or AntiAimContext.BodyYawOffset)
	local ExtendedAnglesPitchAmount = AntiAimContext.ExtendedAnglesPitchRecoil and ((89 - Velocity) / 89) or 1
	ui.set(self.References.yaw[2], AntiAimContext.BaseOverride and 0 or self:NormalizedYaw(AntiAimContext.YawOffset))
	ui.set(self.References.pitch[1], LegitKey and "Off" or AntiAimContext.BaseOverride and "Down" or AntiAimContext.Pitch)
	ui.set(self.References.body_yaw[1], (AntiAimContext.BodyYaw == "Off" and "Off" or AntiAimContext.BaseOverride and "Static" or AntiAimContext.BodyYaw == "Jitter #Advanced" and "Jitter" or AntiAimContext.BodyYaw == "Jitter #Limitate" and "Jitter" or AntiAimContext.BodyYaw))
	if not AntiAimContext.BaseOverride and AntiAimContext.ExtendedAngles then
		ui.set(self.References.roll, 0)
		e.roll = AntiAimContext.ExtendedRoll
		local ThreatTarget = self:NewEntity(client.current_threat())
		if Velocity <= 89 and AntiAimContext.ExtendedPitch ~= 0 and self.data.UnlocketExtendedAngles and (not AntiAimContext.ExtendedAnglesFixed or (AntiAimContext.ExtendedAnglesFixed and ShouldAntiAim)) and not SendPacket then
			local ExtendedPitchAngles = math.abs(AntiAimContext.ExtendedPitch) * ExtendedAnglesPitchAmount
			e.pitch = AntiAimContext.ExtendedPitch > 0 and (89 + ExtendedPitchAngles) or - (89 + ExtendedPitchAngles)
		elseif (Velocity > 89 or AntiAimContext.ExtendedPitch == 0 or not self.data.UnlocketExtendedAngles or SendPacket) and (not AntiAimContext.ExtendedAnglesFixed or (AntiAimContext.ExtendedAnglesFixed and ShouldAntiAim)) and AntiAimContext.Pitch ~= "Off" then
			if AntiAimContext.Pitch == "Default" then
				OverrideBasePitch = 89
			elseif AntiAimContext.Pitch == "Up" then
				OverrideBasePitch = - 89
			elseif AntiAimContext.Pitch == "Down" then
				OverrideBasePitch = 89.9
			elseif AntiAimContext.Pitch == "Minimal" then
				OverrideBasePitch = 88.9
			elseif AntiAimContext.Pitch == "Random" then
				OverrideBasePitch = ({- 90, 90, 0})[math.random(1, 3)]
			else
				OverrideBasePitch = AntiAimContext.PitchAngles
			end

			e.pitch = OverrideBasePitch
		end

		if AntiAimContext.Yaw == "180" then
			AntiAimContext.YawOffset = AntiAimContext.YawOffset + 180
		elseif AntiAimContext.Yaw == "Spin" then
			if e.chokedcommands == 0 then
				self.data.YawSpinOffset = self:NormalizedYaw(self.data.YawSpinOffset + AntiAimContext.YawOffset)
			end

			AntiAimContext.YawOffset = AntiAimContext.YawOffset + self.data.YawSpinOffset + 180
		elseif AntiAimContext.Yaw == "Static" then
			OverrideBaseYaw = 0
			AntiAimContext.YawBase = "Local view"
		elseif AntiAimContext.Yaw == "180 Z" then
			AntiAimContext.YawOffset = AntiAimContext.YawOffset + 180
			if Jumping then
				if e.chokedcommands == 0 then
					self.data.YawSpinOffset = self.data.YawSpinOffset + 7
				end

				AntiAimContext.YawOffset = AntiAimContext.YawOffset + self.data.YawSpinOffset - 50
			elseif not Jumping then
				self.data.YawSpinOffset = 0
			end

		elseif AntiAimContext.Yaw == "Crosshair"  then
			AntiAimContext.YawOffset = AntiAimContext.YawOffset + 180
			if ThreatTarget:is_alive() then
				local TargetHeadPosition = ThreatTarget:get_hitbox_position(0)
				local DifferentHeadPosition = TargetHeadPosition - EyePosition
				local CrosshairTargetYaw = ((math.atan2(DifferentHeadPosition.y, DifferentHeadPosition.x) * 180 / math.pi))
				local CrosshairYawDifferent = self:NormalizedYaw((CameraAngles.y % 360 - CrosshairTargetYaw % 360) % 360)
				if math.abs(CrosshairYawDifferent) > 10 then
					AntiAimContext.YawOffset = AntiAimContext.YawOffset + (CrosshairYawDifferent > 0 and - 90 or 90)
				elseif math.abs(CrosshairYawDifferent) <= 10 then
					AntiAimContext.YawOffset = AntiAimContext.YawOffset - (CrosshairYawDifferent * 5)
				end
			end
		end

		local OverrideBaseYaw = AntiAimContext.YawOffset + AntiAimContext.YawOffset
		if AntiAimContext.YawBase == "At targets" and ThreatTarget:is_alive() then
			local TargetPosition = ThreatTarget:get_origin()
			local LineTargetBaseYaw = self:CalculateYaw(EyePosition, TargetPosition)
			OverrideBaseYaw = LineTargetBaseYaw + AntiAimContext.YawOffset
		end

		if ShouldAntiAim then
			e.yaw = self:NormalizedYaw(OverrideBaseYaw)
		end

	elseif AntiAimContext.BaseOverride and ShouldAntiAim then
		local OverrideBasePitch = 0
		local OverrideBaseFakeYaw = 0
		local OverrideBaseYaw = CameraAngles.y
		local ThreatTarget = self:NewEntity(client.current_threat())
		if AntiAimContext.FakeYawLimitStyle == "Left/Right" then
			AntiAimContext.FakeYawLimit = BodyYaw > 0 and AntiAimContext.ExtraFakeYawLimit or AntiAimContext.FakeYawLimit
		elseif AntiAimContext.FakeYawLimitStyle == "Jitter" then
			AntiAimContext.FakeYawLimit = self.data.Flip and AntiAimContext.ExtraFakeYawLimit or AntiAimContext.FakeYawLimit
		elseif AntiAimContext.FakeYawLimitStyle == "Tickcount" then
			AntiAimContext.FakeYawLimit = self:GetTickcountSwitch(({
				[3] = 4,
				[2] = 8,
				[0] = 32,
				[1] = 16
			})[AntiAimContext.FakeYawLimitTickcount]) and AntiAimContext.ExtraFakeYawLimit or AntiAimContext.FakeYawLimit
		elseif AntiAimContext.FakeYawLimitStyle == "Update" then
			AntiAimContext.FakeYawLimit = self:Update(AntiAimContext.FakeYawLimit, AntiAimContext.ExtraFakeYawLimit, AntiAimContext.FakeYawLimitUpdate, "Fake Yaw Limit Update")
		elseif AntiAimContext.FakeYawLimitStyle == "Rotation" then
			AntiAimContext.FakeYawLimit = self:Cycle(AntiAimContext.FakeYawLimit, AntiAimContext.ExtraFakeYawLimit, AntiAimContext.FakeYawLimitUpdate, "Fake Yaw Limit Rotation")
		elseif AntiAimContext.FakeYawLimitStyle == "Random" then
			AntiAimContext.FakeYawLimit =  math.random(45, 60)
		end

		if not AntiAimContext.ForceStatic then
			if AntiAimContext.Yaw == "180" then
				AntiAimContext.YawOffset = AntiAimContext.YawOffset + 180
			elseif AntiAimContext.Yaw == "Spin" then
				if e.chokedcommands == 0 then
					self.data.YawSpinOffset = self:NormalizedYaw(self.data.YawSpinOffset + AntiAimContext.YawOffset)
				end

				AntiAimContext.YawOffset = AntiAimContext.YawOffset + self.data.YawSpinOffset + 180
			elseif AntiAimContext.Yaw == "Static" then
				OverrideBaseYaw = 0
				AntiAimContext.YawBase = "Local view"
			elseif AntiAimContext.Yaw == "180 Z" then
				AntiAimContext.YawOffset = AntiAimContext.YawOffset + 180
				if Jumping then
					if e.chokedcommands == 0 then
						self.data.YawSpinOffset = self.data.YawSpinOffset + 7
					end

					AntiAimContext.YawOffset = AntiAimContext.YawOffset + self.data.YawSpinOffset - 50
				elseif not Jumping then
					self.data.YawSpinOffset = 0
				end

			elseif AntiAimContext.Yaw == "Crosshair"  then
				AntiAimContext.YawOffset = AntiAimContext.YawOffset + 180
				if ThreatTarget:is_alive() then
					local TargetHeadPosition = ThreatTarget:get_hitbox_position(0)
					local DifferentHeadPosition = TargetHeadPosition - EyePosition
					local CrosshairTargetYaw = ((math.atan2(DifferentHeadPosition.y, DifferentHeadPosition.x) * 180 / math.pi))
					local CrosshairYawDifferent = self:NormalizedYaw((CameraAngles.y % 360 - CrosshairTargetYaw % 360) % 360)
					if math.abs(CrosshairYawDifferent) > 10 then
						AntiAimContext.YawOffset = AntiAimContext.YawOffset + (CrosshairYawDifferent > 0 and - 90 or 90)
					elseif math.abs(CrosshairYawDifferent) <= 10 then
						AntiAimContext.YawOffset = AntiAimContext.YawOffset - (CrosshairYawDifferent * 5)
					end
				end
			end

		elseif AntiAimContext.ForceStatic then
			AntiAimContext.YawOffset = AntiAimContext.YawOffset + 180
		end

		local OverrideBaseYaw = OverrideBaseYaw + AntiAimContext.YawOffset
		if AntiAimContext.YawBase == "At targets" and ThreatTarget:is_alive() then
			local TargetPosition = ThreatTarget:get_origin()
			local LineTargetBaseYaw = self:CalculateYaw(EyePosition, TargetPosition)
			OverrideBaseYaw = LineTargetBaseYaw + AntiAimContext.YawOffset
		end

		if AntiAimContext.BodyYaw == "Static" then
			if AntiAimContext.BodyYawExtra == "Switch" then
				self.data.ExtraAntiAimSettings.Switch = true
				AntiAimContext.BodyYawOffset = self.data.Flip and AntiAimContext.BodyYawExtraOffset or AntiAimContext.BodyYawOffset
			elseif AntiAimContext.BodyYawExtra == "Timer" then
				AntiAimContext.BodyYawOffset = self:GetTimerSwitch(AntiAimContext.BodyYawExtraTimer / 100) and AntiAimContext.BodyYawExtraOffset or AntiAimContext.BodyYawOffset
			elseif AntiAimContext.BodyYawExtra == "Tickcount" then
				AntiAimContext.BodyYawOffset = self:GetTickcountSwitch(({
					[3] = 4,
					[2] = 8,
					[0] = 32,
					[1] = 16
				})[AntiAimContext.BodyYawExtraTickcount]) and AntiAimContext.BodyYawExtraOffset or AntiAimContext.BodyYawOffset
			elseif AntiAimContext.BodyYawExtra == "Random" then
				AntiAimContext.BodyYawOffset = math.random(180,- 180)
			end

			local Limitate = ((not DoubleTap and not onshot) or FakeDuck)
			local BodyYawOffset = self:Clamp(AntiAimContext.BodyYawOffset, - 35, 35)
		elseif AntiAimContext.BodyYaw == "Jitter #Limitate" then
			AntiAimContext.BodyYawOffset = self.data.Flip and - AntiAimContext.BodyYawOffset or AntiAimContext.BodyYawOffset
			local FakeYawLimit = self:Clamp(AntiAimContext.FakeYawLimit / 2, - 30, 30)
			local BodyYawOffset = self:Clamp(AntiAimContext.BodyYawOffset, - 30, 30)
			OverrideBaseFakeYaw = BodyYawOffset + (BodyYawOffset > 0 and FakeYawLimit or - FakeYawLimit)
		elseif AntiAimContext.BodyYaw == "Jitter #Advanced" then
			AntiAimContext.BodyYawOffset = self.data.Flip and - AntiAimContext.BodyYawOffset or AntiAimContext.BodyYawOffset
			local BodyYawOffset = self:Clamp(AntiAimContext.BodyYawOffset, - 60, 60)
			OverrideBaseFakeYaw = BodyYawOffset + (BodyYawOffset > 0 and AntiAimContext.FakeYawLimit or - AntiAimContext.FakeYawLimit)
		elseif AntiAimContext.BodyYaw == "Jitter" then
			if AntiAimContext.BodyYawExtra == "Off" then
				AntiAimContext.BodyYawOffset = self.data.Flip and AntiAimContext.BodyYawOffset or - AntiAimContext.BodyYawOffset
			elseif AntiAimContext.BodyYawExtra == "Switch" then
				self.data.ExtraAntiAimSettings.Switch = true
				AntiAimContext.BodyYawOffset = self:Clamp(self.data.Flip and - AntiAimContext.BodyYawOffset or AntiAimContext.BodyYawOffset, - 60, 60)
			elseif AntiAimContext.BodyYawExtra == "Timer" then
				AntiAimContext.BodyYawOffset = self:GetTimerSwitch(AntiAimContext.BodyYawExtraTimer / 100) and AntiAimContext.BodyYawExtraOffset or AntiAimContext.BodyYawOffset
			elseif AntiAimContext.BodyYawExtra == "Tickcount" then
				AntiAimContext.BodyYawOffset = self:GetTickcountSwitch(({
					[3] = 4,
					[2] = 8,
					[0] = 32,
					[1] = 16
				})[AntiAimContext.BodyYawExtraTickcount]) and AntiAimContext.BodyYawExtraOffset or AntiAimContext.BodyYawOffset
			end

			local BaseFakeLimit = (AntiAimContext.BodyYawOffset > 0 and AntiAimContext.FakeYawLimit or - AntiAimContext.FakeYawLimit)
			OverrideBaseFakeYaw = self:Clamp(AntiAimContext.BodyYawOffset, - 60, 60) + (BaseFakeLimit / 2)
			if math.abs(OverrideBaseFakeYaw) > 60 then
				OverrideBaseFakeYaw = AntiAimContext.BodyYawOffset + BaseFakeLimit
			elseif math.abs(OverrideBaseFakeYaw) <= 60 then
				AntiAimContext.BodyYawOffset = AntiAimContext.BodyYawOffset > 0 and self:Clamp(AntiAimContext.BodyYawOffset, 30, 60) or self:Clamp(AntiAimContext.BodyYawOffset, - 60, - 30)
				OverrideBaseFakeYaw = AntiAimContext.BodyYawOffset + (AntiAimContext.BodyYawOffset > 0 and self:Clamp(math.abs(BaseFakeLimit), 0, 30) or - self:Clamp(math.abs(BaseFakeLimit), 0, 30))
			end

		elseif AntiAimContext.BodyYaw == "Opposite" then
			local HideRealInverter = self:CalculateFreestanding()
			local BodyYawOffset = HideRealInverter and - 30 or 30
			local FakeYawLimit = self:Clamp(AntiAimContext.FakeYawLimit / 2, - 30, 30)
			if AntiAimContext.BodyYawExtra == "Switch" then
				self.data.ExtraAntiAimSettings.Switch = true
				BodyYawOffset = self.data.Flip and - BodyYawOffset or BodyYawOffset
			elseif AntiAimContext.BodyYawExtra == "Timer" then
				BodyYawOffset = self:GetTimerSwitch(AntiAimContext.BodyYawExtraTimer / 100) and - BodyYawOffset or BodyYawOffset
			elseif AntiAimContext.BodyYawExtra == "Tickcount" then
				AntiAimContext.BodyYawOffset = self:GetTickcountSwitch(({
					[3] = 4,
					[2] = 8,
					[0] = 32,
					[1] = 16
				})[AntiAimContext.BodyYawExtraTickcount]) and - BodyYawOffset or BodyYawOffset
			end

			OverrideBaseFakeYaw = BodyYawOffset + (BodyYawOffset > 0 and FakeYawLimit or - FakeYawLimit)
		end

		if AntiAimContext.YawJitter ~= "Off" and AntiAimContext.YawJitterTickcount <= 0 and not ForceStaticManual then
			if AntiAimContext.YawJitter == "Offset" then
				OverrideBaseYaw = OverrideBaseYaw + (self.data.Flip and AntiAimContext.YawJitterOffset or 0)
			elseif AntiAimContext.YawJitter == "Center" then
				local CenterOffset = AntiAimContext.YawJitterOffset / 2
				OverrideBaseYaw = OverrideBaseYaw + (self.data.Flip and CenterOffset or - CenterOffset)
			elseif AntiAimContext.YawJitter == "Random" then
				OverrideBaseYaw = OverrideBaseYaw + (self.data.Flip and math.random(0, AntiAimContext.YawJitterOffset) or 0)
			elseif AntiAimContext.YawJitter == "Skitter" then
				OverrideBaseYaw = OverrideBaseYaw + self:CreateWays(3, AntiAimContext.YawJitterOffset)
			end
		end

		if AntiAimContext.Pitch == "Default" then
			OverrideBasePitch = 89
		elseif AntiAimContext.Pitch == "Up" then
			OverrideBasePitch = - 89
		elseif AntiAimContext.Pitch == "Down" then
			OverrideBasePitch = 89.9
		elseif AntiAimContext.Pitch == "Minimal" then
			OverrideBasePitch = 90
		elseif AntiAimContext.Pitch == "Random" then
			OverrideBasePitch = ({- 90, 90, 0})[math.random(1, 3)]
		else
			OverrideBasePitch = AntiAimContext.PitchAngles
		end

		local ShouldDesync = AntiAimContext.BodyYaw ~= "Static" or (AntiAimContext.BodyYaw == "Static" and AntiAimContext.BodyYawOffset ~= 0)
		if e.chokedcommands <= 0 and ShouldDesync then
			if self.data.FakeYawAsync ~= OverrideBaseFakeYaw then
				self.data.ResetBaseYaw = true
				self.data.FakeYawAsync = OverrideBaseFakeYaw
			end

			if self.data.ResetBaseYaw then
				self.data.ResetBaseYaw = false
				local ExtraAngles = (OverrideBaseFakeYaw > 0 and - 58 or 58)
				local BaseExtraAngles = self.data.LastBaseFakeYaw > math.abs(OverrideBaseFakeYaw) and ExtraAngles or - ExtraAngles
				local BaseDesyncAngles = AntiAimContext.BodyYaw == "Jitter #Advanced" and (OverrideBaseFakeYaw > 0 and 120 or - 120) or (OverrideBaseFakeYaw + BaseExtraAngles)
				OverrideBaseYaw = OverrideBaseYaw - BaseDesyncAngles
			elseif not self.data.ResetBaseYaw then
				self.data.LastBaseFakeYaw = math.abs(OverrideBaseFakeYaw)
				OverrideBaseYaw = OverrideBaseYaw - OverrideBaseFakeYaw
			end

			e.allow_send_packet = false
		elseif e.chokedcommands > 0 and ((not DoubleTap and not onshot) or FakeDuck) then
			if Velocity <= 1.1 then
				e.no_choke = true
				if self.data.NextTickDesync then
					self.data.ResetBaseYaw = true
					self.data.NextTickDesync = false
				end

			elseif Velocity > 1.1 then
				self.data.NextTickDesync = true
			end
		end

		if AntiAimContext.ExtendedAngles then
			ui.set(self.References.roll, 0)
			local ExtendedPitchAngles = math.abs(AntiAimContext.ExtendedPitch) * ExtendedAnglesPitchAmount
			local BasePitchAngles = OverrideBasePitch == "Off" and (ExtendedPitchAngles > 0 and 89 or - 89) or OverrideBasePitch
			if ShouldAntiAim then
				e.roll = AntiAimContext.ExtendedRoll
			end

			if Velocity <= 89 and AntiAimContext.ExtendedPitch ~= 0 and ShouldAntiAim and self.data.UnlocketExtendedAngles and not SendPacket then
				e.pitch = AntiAimContext.ExtendedPitch > 0 and (89 + ExtendedPitchAngles) or - (89 + ExtendedPitchAngles)
			elseif Velocity > 89 or not self.data.UnlocketExtendedAngles or SendPacket then
				e.pitch = OverrideBasePitch
			end

		elseif AntiAimContext.Pitch ~= "Off" then
			e.pitch = OverrideBasePitch
		end

		e.yaw = self:NormalizedYaw(OverrideBaseYaw)
	end
end

MOISTEN.__index.PaintUI = function(self)
	self:Render()
end

MOISTEN.__index.SetupCommand = function(self, e)
	self:AntiAim(e)
	self:FakeLag(e)
	self:TickBase(e)
	self:FastLadder(e)
end

MOISTEN.__index.PostConfigLoad = function(self)
	if not self.Elements.MasterSwitch:get() then
		return
	end

	self.data.NotifyLogIndex = self.data.NotifyLogIndex + 1
	table.insert(self.data.NotifyCached, {
		Switch = false,
		CurrentIndex = false,
		Timer = self:GetTimeScale(),
		Index = self.data.NotifyLogIndex,
		AnimationColor = self.data.LightPinkedColor,
		ConfigsName = ("Config: %s"):format("Gamesense"),
		UserName = ("User: %s"):format(self.data.SelfName),
		Text = "Load Successfully, Data Load From Gamesense Database",
		Title = ("MOISTEN%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN")),
		Svg = {
			Size = self.data.Vector(48, 48),
			Texture = self.data.SettingsSvg
		}
	})
end

MOISTEN.__index.PostConfigSave = function(self)
	if not self.Elements.MasterSwitch:get() then
		return
	end

	self.data.NotifyLogIndex = self.data.NotifyLogIndex + 1
	local AutomaticSaveConfig = self.Elements.Configs.AutomaticSaveConfig:get()
	if AutomaticSaveConfig then
		local ConfigPackage = self:GetPackages(self.Elements)
		database.write("[MOISTEN.WIN]Configs", self.data.Configs)
		database.write("[MOISTEN.WIN]Configs Data", self.data.ConfigsList)
		self.data.ConfigsList[self.data.AutoSaveConfigName] = self.data.Base64.encode(json.stringify(ConfigPackage))
	end

	table.insert(self.data.NotifyCached, {
		Switch = false,
		CurrentIndex = false,
		Timer = self:GetTimeScale(),
		Index = self.data.NotifyLogIndex,
		AnimationColor = self.data.LightPinkedColor,
		ConfigsName = ("Config: %s"):format("Gamesense"),
		UserName = ("User: %s"):format(self.data.SelfName),
		Text = "Save Successfully, Data Save To Gamesense Database",
		Title = ("MOISTEN%s"):format(self:RgbaToHexText(self.data.LightPinkedColor, ".WIN")),
		Svg = {
			Size = self.data.Vector(48, 48),
			Texture = self.data.SettingsSvg
		}
	})
end

MOISTEN.__index.ShutDown = function(self)
	self:UpdateUseKey(true)
	self:HandleReference(true)
	cvar["sv_maxunlag"]:set_int(0.2)
	ui.set(self.References.untrusted, true)
	ui.set(self.References.maxunlag, 200)
	ui.set(self.References.usrcmdprocessticks, 16)
	ui.set(self.References.double_tap_hitchance, 0)
	ui.set(self.References.clockcorrection_msecs, 30)
	ui.set_visible(self.References.leg_movement, true)
	local ConfigPackage = self:GetPackages(self.Elements)
	database.write("[MOISTEN.WIN]Configs", self.data.Configs)
	local local_player = self:NewEntity(entity.get_local_player())
	database.write("[MOISTEN.WIN]Configs Data", self.data.ConfigsList)
	database.write("[MOISTEN.WIN]Fired Last Update Timer", self.data.LastUpdateTimer)
	database.write("[MOISTEN.WIN]Base Config", self.data.Base64.encode(json.stringify(ConfigPackage)))
	for index, material in pairs(self.data.ZoomMaterials) do
		if material ~= nil then
			material:reload()
		end
	end

	for _, Cvar in pairs(self.data.CvarCached) do
		Cvar:reset()
	end

	if local_player:is_valid() then
		local_player:set_prop("m_flModelScale", 1)
	end

	if self.data.ClientLanguege ~= "" then
		self.CHelpers.SetClientLanguege(self.data.ClientLanguege)
	end

	if self.data.ReleaseDoubleTapDischarged then
		ui.set(self.References.doubletap[1], true)
		self.data.ReleaseDoubleTapDischarged = false
	end

	if self.data.ShotFakelagReset then
		self.data.ShotFakelagReset = false
		ui.set(self.References.enabled, true)
		ui.set(self.References.body_yaw[1], "Static")
		ui.set(self.References.usrcmdprocessticks_holdaim, true)
	end

end

MOISTEN.__index.CallBacks = function(self)
	return {
		["aim_hit"] = function(e)
			self:AimHit(e)
		end,

		["paint_ui"] = function(e)
			self:PaintUI(e)
		end,

		["level_init"] = function(e)
			self:LevelInit(e)
		end,

		["aim_miss"] = function(e)
			self:AimMiss(e)
		end,

		["shutdown"] = function(e)
			self:ShutDown(e)
		end,


		["pre_render"] = function(e)
			self:PreRender(e)
		end,

		["player_hurt"] = function(e)
			self:PlayerHurt(e)
		end,

		["bullet_impact"] = function(e)
			self:BulletImpact(e)
		end,

		["game_newmap"] = function(e)
			self:GameNewMap(e)
		end,

		["net_update_end"] = function(e)
			self:NetUpdateEnd(e)
		end,

		["net_update_start"] = function(e)
			self:NetUpdateStart(e)
		end,

		["post_config_save"] = function(e)
			self:PostConfigSave(e)
		end,

		["post_config_load"] = function(e)
			self:PostConfigLoad(e)
		end,

		["setup_command"] = function(e)
			self:SetupCommand(e)
		end
	}
end

MOISTEN.__index.Work = function(self)
	jit.on()
	self:CreateCHelpers()
	self:CreateElements()
	self:FiredUpdateLog()
	self.data.Initialized = true
	self.GetCvar = self:GetCvar()
	cvar["sv_maxunlag"]:set_int(1)
	ui.set(self.References.maxunlag, 1000)
	ui.set_visible(self.References.leg_movement, true)
	client.delay_call(0.1, function()
		self:HandleMain()
	end)

	if self.data.BaseConfig then
		self:LoadConfig(self.data.BaseConfig)
	end

	self:MultiCallBack(self.Elements, function()
		self:HandleMain()
	end, true)

	for Name, Handler in pairs(self:CallBacks()) do
		self:RegisteredCallBack(Name, Handler)
	end

	if self.data.ClientLanguege == "" then
		self.data.ClientLanguege = ffi.string(self.CHelpers.GetClientLanguege())
		client.exec("cl_bobamt_lat 0")
		client.exec("cl_bobamt_vert 0")
		client.exec("cl_bob_lower_amt 0")
		self.CHelpers.SetClientLanguege("schinese")
	end

	self.Elements.Configs.ConfigsControls = self.Elements.Configs.ConfigsControls({
		Save = self:BindArg(self.SaveConfig, self),
		Load = self:BindArg(self.LoadConfig, self),
		Delete = self:BindArg(self.DeleteConfig, self),
		Create = self:BindArg(self.CreateConfig, self),
		Export = self:BindArg(self.ExportConfig, self),
		Import = self:BindArg(self.ImportConfig, self)
	})
end

MOISTEN:Work()