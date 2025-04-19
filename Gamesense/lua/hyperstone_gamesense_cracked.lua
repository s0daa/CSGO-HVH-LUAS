-- cracked by russian mafia team
-- dsc.gg/z0v

local ffi = require 'ffi'
local vector = require 'vector'
local c_entity = require 'gamesense/entity'
local anti_aim = require 'gamesense/antiaim_funcs'
local easing = require "gamesense/easing"
local steamworks = require 'gamesense/steamworks'
local clipboard = require 'gamesense/clipboard'
local base64 = require 'gamesense/base64'
local bit = require('bit')

ffi.cdef[[
    typedef struct 
    {
    	void*   fnHandle;        
    	char    szName[260];     
    	int     nLoadFlags;      
    	int     nServerCount;    
    	int     type;            
    	int     flags;           
    	float  vecMins[3];       
    	float  vecMaxs[3];       
    	float   radius;          
    	char    pad[0x1C];       
    }model_t;
    
    typedef int(__thiscall* get_model_index_t)(void*, const char*);
    typedef const model_t(__thiscall* find_or_load_model_t)(void*, const char*);
    typedef int(__thiscall* add_string_t)(void*, bool, const char*, int, const void*);
    typedef void*(__thiscall* find_table_t)(void*, const char*);
    typedef void(__thiscall* set_model_index_t)(void*, int);
    typedef int(__thiscall* precache_model_t)(void*, const char*, bool);
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
]]
local class_ptr = ffi.typeof("void***")
local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')
local nullptr = ffi.new 'void*'
local char_ptr = ffi.typeof 'char*'
local animation_layer = 0x2990
local animation_layer_t = ffi.typeof([[
    struct {
        char pad0[0x18];
        uint32_t sequence;
        float prev_cycle;
        float weight;
        float weight_delta_rate;
        float playback_rate;
        float cycle;
        void *entity;
        char pad1[0x4];
    } **
]])

local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("VClientEntityList003 wasnt found", 2)
local ientitylist = ffi.cast(class_ptr, rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)

local rawivmodelinfo = client.create_interface("engine.dll", "VModelInfoClient004") or error("VModelInfoClient004 wasnt found", 2)
local ivmodelinfo = ffi.cast(class_ptr, rawivmodelinfo) or error("rawivmodelinfo is nil", 2)
local get_model_index = ffi.cast("get_model_index_t", ivmodelinfo[0][2]) or error("get_model_info is nil", 2)
local find_or_load_model = ffi.cast("find_or_load_model_t", ivmodelinfo[0][39]) or error("find_or_load_model is nil", 2)

local rawnetworkstringtablecontainer = client.create_interface("engine.dll", "VEngineClientStringTable001") or error("VEngineClientStringTable001 wasnt found", 2)
local networkstringtablecontainer = ffi.cast(class_ptr, rawnetworkstringtablecontainer) or error("rawnetworkstringtablecontainer is nil", 2)
local find_table = ffi.cast("find_table_t", networkstringtablecontainer[0][3]) or error("find_table is nil", 2)
local clamp = function(b,c,d)return math.min(d,math.max(c,b))end
local var_table = {};
local prev_simulation_time = 0
local function time_to_ticks(t)
    return math.floor(0.5 + (t / globals.tickinterval()))
end
local diff_sim = 0
function var_table:sim_diff() 
    local current_simulation_time = time_to_ticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local diff = current_simulation_time - prev_simulation_time
    prev_simulation_time = current_simulation_time
    diff_sim = diff
    return diff_sim
end

local function MODELCHANGERNIGGERS(tab, val)
	for i = 1, #tab do
		if tab[i] == val then
			return true
		end
	end
	return false
end


local reference = {
	aimbot = ui.reference('RAGE', 'Aimbot', 'Enabled'),
	enableaa = {ui.reference('AA', 'Anti-aimbot angles', 'Enabled')},
	pitch = {ui.reference('AA', 'Anti-aimbot angles', 'Pitch')},
    yaw_base = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw')},
    yaw_jitter = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter')},
    body_yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')},
    freestanding_body_yaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
	edge_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
	freestanding = {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')},
    roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll'),
    on_shot_anti_aim = {ui.reference('AA', 'Other', 'On shot anti-aim')},
    slow_motion = {ui.reference('AA', 'Other', 'Slow motion')},
	third_person = { ui.reference('VISUALS', 'Effects', 'Force third person (alive)') }, -- this could mean a lot honestly
    on_shot = { ui.reference('AA', 'Other', 'On shot anti-aim') },
	dt = {ui.reference("RAGE", "Aimbot", "Double tap")},
	fakeDuck = ui.reference("RAGE", "Other", "Duck peek assist"),
	fakeLag = {ui.reference("AA", "Fake lag", "Limit")},
	quickpeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
	doubletap = {
        main = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
        fakelag_limit = ui.reference('RAGE', 'Aimbot', 'Double tap fake lag limit')
    },
	RAGE = {
        aimbot = {
            min_damage = ui.reference('RAGE', 'Aimbot', 'Minimum damage'),
            min_damage_override = {ui.reference('RAGE', 'Aimbot', 'Minimum damage override')},
            force_safe_point = ui.reference('RAGE', 'Aimbot', 'Force safe point'),
            force_body_aim = ui.reference('RAGE', 'Aimbot', 'Force body aim'),
            double_tap = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
			on_shot_anti_aim = {ui.reference('AA', 'Other', 'On shot anti-aim')},
        },
    }
}

local t_player_models = {
    ["gta_crip"] = "models/player/custom_player/z-piks.ru/gta_crip.mdl",
	["T Agent"] = "models/player/custom_player/legacy/tm_phoenix.mdl",
	["CT Agent"] = "models/player/custom_player/legacy/ctm_sas.mdl",
	["Street Soldier"] = "models/player/custom_player/legacy/tm_phoenix_varianti.mdl",
	["Enforcer"] = "models/player/custom_player/legacy/tm_phoenix_variantf.mdl",
	["Leet D"] = "models/player/custom_player/legacy/tm_leet_variantd.mdl",
	["Leet E"] = "models/player/custom_player/legacy/tm_leet_variante.mdl",
	["Jump Suit A"] = "models/player/custom_player/legacy/tm_jumpsuit_varianta.mdl",
	["Jump Suit B"] = "models/player/custom_player/legacy/tm_jumpsuit_variantb.mdl",
	["Jump Suit C "] = "models/player/custom_player/legacy/tm_jumpsuit_variantc.mdl"
}

local ct_player_models = {
    ["gta_crip"] = "models/player/custom_player/z-piks.ru/gta_crip.mdl",
	["T Agent"] = "models/player/custom_player/legacy/tm_phoenix.mdl",
	["CT Agent"] = "models/player/custom_player/legacy/ctm_sas.mdl",
	["Street Soldier"] = "models/player/custom_player/legacy/tm_phoenix_varianti.mdl",
	["Enforcer"] = "models/player/custom_player/legacy/tm_phoenix_variantf.mdl",
	["Leet D"] = "models/player/custom_player/legacy/tm_leet_variantd.mdl",
	["Leet E"] = "models/player/custom_player/legacy/tm_leet_variante.mdl",
	["Jump Suit A"] = "models/player/custom_player/legacy/tm_jumpsuit_varianta.mdl",
	["Jump Suit B"] = "models/player/custom_player/legacy/tm_jumpsuit_variantb.mdl",
	["Jump Suit C "] = "models/player/custom_player/legacy/tm_jumpsuit_variantc.mdl"
}

local cl_fullupdate = cvar.cl_fullupdate

local model_names = {}
local model_names_ct = {}

for k,v in pairs(t_player_models) do
    table.insert(model_names, k)
end

for k,v in pairs(ct_player_models) do
    table.insert(model_names_ct, k)
end

local func = {
    includes = function(tbl, value)
        for i = 1, #tbl do
            if tbl[i] == value then
                return true
            end
        end
        return false
    end,
    vec_angles = function(angle_x, angle_y)
        local sy = math.sin(math.rad(angle_y))
        local cy = math.cos(math.rad(angle_y))
        local sp = math.sin(math.rad(angle_x))
        local cp = math.cos(math.rad(angle_x))
        return cp * cy, cp * sy, -sp
    end,  
    time_to_ticks = function(t)
        return math.floor(0.5 + (t / globals.tickinterval()))
    end,
    headVisible = function(enemy)
        local local_player = entity.get_local_player()
        if local_player == nil then return end
        local ex, ey, ez = entity.hitbox_position(enemy, 1)
    
        local hx, hy, hz = entity.hitbox_position(local_player, 1)
        local head_fraction, head_entindex_hit = client.trace_line(enemy, ex, ey, ez, hx, hy, hz)
        if head_entindex_hit == local_player or head_fraction == 1 then return true else return false end
    end,
    defensive = {
        cmd = 0,
        check = 0,
        defensive = 0,
    },
    aa_clamp = function(x) if x == nil then return 0 end x = (x % 360 + 360) % 360 return x > 180 and x - 360 or x end,
}

local vars = {
    localPlayer = 0,
    hitgroup_names = { 'Generic', 'Head', 'Chest', 'Stomach', 'Left arm', 'Right arm', 'Left leg', 'Right leg', 'Neck', '?', 'Gear' },
    aaStates = {"Global", "Standing", "Moving", "Slowwalking", "Crouching", "Air", "Air-Crouching", "Legit-AA"},
    pStates = {"G", "S", "M", "SW", "C", "A", "AC", "LA"},
	sToInt = {["Global"] = 1, ["Standing"] = 2, ["Moving"] = 3, ["Slowwalking"] = 4, ["Crouching"] = 5, ["Air"] = 6, ["Air-Crouching"] = 7,["Legit-AA"] = 8},
    intToS = {[1] = "Global", [2] = "Stand", [3] = "Move", [4] = "Slowwalk", [5] = "Crouch", [6] = "Air", [7] = "Air+C", [8] = "Legit"},
    currentTab = 1,
    activeState = 1,
    pState = 1,
    should_disable = false,
    defensive_until = 0,
    defensive_prev_sim = 0,
    fs = false,
    choke1 = 0,
    choke2 = 0,
    choke3 = 0,
    choke4 = 0,
    switch = false,
}

client.set_event_callback("run_command", function(e)
    func.defensive.cmd = e.command_number
end)
client.set_event_callback("predict_command", function(e)
    if e.command_number == func.defensive.cmd then
        local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase")
        func.defensive.defensive = math.abs(tickbase - func.defensive.check)
        func.defensive.check = math.max(tickbase, func.defensive.check or 0)
        func.defensive.cmd = 0
    end
end)
client.set_event_callback("level_init", function() func.defensive.check, func.defensive.defensive = 0, 0 end)



local bluadota2 = {'Rage', 'Anti-Aim', 'Visual', 'Misc', 'CFG & SERVERS'}
local mamytraxal = ui.new_combobox('AA', 'Anti-aimbot angles', '\aB2ACDDFFSelect Tabs\aFFFFFFB6', bluadota2)

--Rage
local CustomResolver = ui.new_checkbox("AA", "Anti-aimbot angles", "Custom Resolver")
local dtunsafe = ui.new_checkbox("AA", "Anti-aimbot angles", "DT BREAK FIX")
local sgghithance = ui.new_checkbox("AA", "Anti-aimbot angles", "SSG HITCHANCE AIR")
local def_hc = ui.new_slider('AA', 'Anti-aimbot angles', 'scout hit chance', 0, 100, 50, true, '%')
local hit_chance_ovr = ui.new_slider('AA', 'Anti-aimbot angles', 'Hit chance override', 0, 100, 50, true, '%')


local bigbreeak1 = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Air Lag Bind')
local bigbreeak2 = ui.new_slider('AA', 'Anti-aimbot angles', 'Air Lag Tick', 1, 30, 10, true, 't')

local slideranimbreak = ui.new_slider("AA", "Anti-aimbot angles", "AnimBreak", 0, 6, 0)
-- Ð°Ð½Ñ‚Ð¸Ð¿Ð°Ð¿Ð°Ð´Ð°Ð¹ÐºÐ¸

local force_defensivebind = ui.new_checkbox("AA", "Anti-aimbot angles", "Force defensive")
local pitchexploit = ui.new_checkbox("AA", "Anti-aimbot angles", "Pitch Exploit")


local antiaimsstate = ui.new_combobox("AA", "Anti-aimbot angles", "Anti-aim state", vars.aaStates)


local aaBuilder = {}
local aaContainer = {}
for i=1, #vars.aaStates do
    aaContainer[i] = "(" .. vars.pStates[i] .. "" .. ")"
    aaBuilder[i] = {
        enableState = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable " .. vars.aaStates[i] .. " state"),
        pitch = ui.new_combobox("AA", "Anti-aimbot angles", "Pitch\n" .. aaContainer[i], "Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"),
        pitchSlider = ui.new_slider("AA", "Anti-aimbot angles", "\nPitch add" .. aaContainer[i], -89, 89, 0, true, "Â°", 1),
        yawBase = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw base\n" .. aaContainer[i], "Local view", "At targets"),
        yaw = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw\n" .. aaContainer[i], "Off", "180", "Spin", "180 Z"),
        yawCondition = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw condition\n" .. aaContainer[i], "Static", "L & R", "Slow", "Hold"),
        yawStatic = ui.new_slider("AA", "Anti-aimbot angles", "\nyaw limit" .. aaContainer[i], -180, 180, 0, true, "Â°", 1),
        yawLeft = ui.new_slider("AA", "Anti-aimbot angles", "Left\nyaw" .. aaContainer[i], -180, 180, 0, true, "Â°", 1),
        yawRight = ui.new_slider("AA", "Anti-aimbot angles", "Right\nyaw" .. aaContainer[i], -180, 180, 0, true, "Â°", 1),
        yawSpeed = ui.new_slider("AA", "Anti-aimbot angles", "Speed\nyaw" .. aaContainer[i], 1, 14, 6, 0),
        yawJitter = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw jitter\n" .. aaContainer[i], "Off", "Offset", "Center", "3-Way", "Random"),
        yawJitterCondition = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw jitter condition\n" .. aaContainer[i], "Static", "L & R"),
        yawJitterStatic = ui.new_slider("AA", "Anti-aimbot angles", "\nyaw jitter limit" .. aaContainer[i], -180, 180, 0, true, "Â°", 1),
        yawJitterLeft = ui.new_slider("AA", "Anti-aimbot angles", "Left\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "Â°", 1),
        yawJitterRight = ui.new_slider("AA", "Anti-aimbot angles", "Right\nyaw jitter" .. aaContainer[i], -180, 180, 0, true, "Â°", 1),
        yawJitterDisablers = ui.new_multiselect("AA", "Anti-aimbot angles", "Jitter disablers\n" .. aaContainer[i], "Head safety", "Height advantage"),
        bodyYaw = ui.new_combobox("AA", "Anti-aimbot angles", "Body yaw\n" .. aaContainer[i], "Off", "Opposite", "Jitter", "Static"),
        bodyYawSlider = ui.new_slider("AA", "Anti-aimbot angles", "\nbody yaw limit" .. aaContainer[i], -180, 180, 0, true, "Â°", 1),
        defensiveOpt = ui.new_multiselect("AA", "Anti-aimbot angles", "Defensive options\n" .. aaContainer[i], "Elusive mode", "Always on"),
        defensiveYaw = ui.new_combobox("AA", "Anti-aimbot angles", "Defensive yaw\n" .. aaContainer[i], "-", "Random", "Jitter", "Custom"),
        defensiveYawSlider = ui.new_slider("AA", "Anti-aimbot angles", "\nDefensiveYawSlider" .. aaContainer[i], -180, 180, 0, true, "", 1),
        defensivePitch = ui.new_combobox("AA", "Anti-aimbot angles", "Defensive pitch\n" .. aaContainer[i], "-", "Custom"),
        defensivePitchSlider = ui.new_slider("AA", "Anti-aimbot angles", "\nDefensivePitchSlider" .. aaContainer[i], -89, 89, 0, true, "Â°", 1),
    }
end

local freestandHotkey = ui.new_hotkey("AA", "Anti-aimbot angles", "Freestand")
local freestandDisablers = ui.new_multiselect("AA", "Anti-aimbot angles", "â€º Disablers", {"Air", "Slowmo", "Duck", "Manual"})
local edgeYawHotkey = ui.new_hotkey("AA", "Anti-aimbot angles", "Edge Yaw")
local avoidBackstab = ui.new_slider("AA", "Anti-aimbot angles", "Avoid Backstab", 0, 300, 0, true, "u", 1, {[0] = "Off"})
local staticManuals = ui.new_checkbox("AA", "Anti-aimbot angles", "Static on manuals")
local manualLeft = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual left")
local manualRight = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual right")
local manualReset = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual reset")
local manualForward = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual forward")

--visual
local arrowindicator = ui.new_checkbox("AA", "Anti-aimbot angles", "Arrow Indicator")                          
local color_pickerstrelki = ui.new_color_picker("AA", "Anti-aimbot angles", '\n arrow_lines_color_picker', 16, 123, 251)
local arrowdesynccolorlable = ui.new_label("AA", "Anti-aimbot angles", 'Arrow Desync color', 'string')
local color_pickerstrelki2 = ui.new_color_picker("AA", "Anti-aimbot angles", '\n arrow_lines_color_picker', 16, 123, 251)
local blurmenu = ui.new_checkbox("AA", "Anti-aimbot angles", "Blur Background")
local crosshairind = ui.new_combobox("AA", "Anti-aimbot angles", "Crosshair Indicator", {'Off','Old', 'New'})

local weaponeblan = ui.new_combobox("AA", "Anti-aimbot angles", 'Weapon position', {'Right', 'Left'})
local knifeeblan = ui.new_combobox("AA", "Anti-aimbot angles", 'Knife position', {'Right', 'Left'})

local fovin_scope = 	ui.new_checkbox("AA", "Anti-aimbot angles", "Viewmodel In scope")
local master_switch1 = ui.new_checkbox("AA", "Anti-aimbot angles", 'Custom scope lines')
local color_picker = ui.new_color_picker("AA", "Anti-aimbot angles", '\n scope_lines_color_picker', 255, 255, 255, 255)
local overlay_position = ui.new_slider("AA", "Anti-aimbot angles", '\n scope_lines_initial_pos', 0, 500, 50)
local overlay_offset = ui.new_slider("AA", "Anti-aimbot angles", '\n scope_lines_offset', 0, 500, 0)
local aspect_ratio_reference = ui.new_slider("AA", "Anti-aimbot angles", "Force aspect ratio", 1, 199, 100, true, "%", 0.01, aspect_ratio_table)
--misc
local clantagchanger = ui.new_checkbox("AA", "Anti-aimbot angles", 'Clan Tag')
local model_check = ui.new_multiselect("AA", "Anti-aimbot angles", 'Agent changer', {"CT", "T"})
local localplayer_model_ct = ui.new_combobox("AA", "Anti-aimbot angles", "CT Model", model_names_ct)
local localplayer_model_t = ui.new_combobox("AA", "Anti-aimbot angles", "T Model", model_names)




--cfg and SERVERS
local text1con = ui.new_label("AA", "Anti-aimbot angles", "-------------------Server List------------------", 'string')
local Server1 = ui.new_button("AA", "Anti-aimbot angles", "eXpidors.Ru | ONLY SCOUT", function()  client.exec("connect 62.122.215.105:6666") end)
local Server2 = ui.new_button("AA", "Anti-aimbot angles", "eXpidors.Ru | PUBLIC ", function()  client.exec("connect 46.174.51.137:7777") end)
local Server3 = ui.new_button("AA", "Anti-aimbot angles", "DarkProject | PUBLIC ", function()  client.exec("connect 37.230.228.178:1337") end)
local Server4 = ui.new_button("AA", "Anti-aimbot angles", "SharkProject | PUBLIC ", function()  client.exec("connect 37.230.228.148:27015") end)
local Server5 = ui.new_button("AA", "Anti-aimbot angles", "SharkProject | DM HVH ", function()  client.exec("connect 46.174.51.108:27015") end)
local text2con = ui.new_label("AA", "Anti-aimbot angles", "------------------Configuration----------------", 'string')


local data = {
    integers = { CustomResolver, dtunsafe, sgghithance, def_hc, hit_chance_ovr, bigbreeak2, pitchexploit, force_defensivebind,
	arrowindicator, blurmenu, crosshairind, weaponeblan, knifeeblan, fovin_scope, master_switch1, overlay_position, staticManuals, 
	overlay_offset, aspect_ratio_reference, clantagchanger, model_check, localplayer_model_ct, localplayer_model_t, freestandDisablers, avoidBackstab,
	aaBuilder[1].enableState, aaBuilder[2].enableState, aaBuilder[3].enableState, aaBuilder[4].enableState, aaBuilder[5].enableState, aaBuilder[6].enableState, aaBuilder[7].enableState, aaBuilder[8].enableState,
	aaBuilder[1].pitch, aaBuilder[2].pitch, aaBuilder[3].pitch, aaBuilder[4].pitch, aaBuilder[5].pitch, aaBuilder[6].pitch, aaBuilder[7].pitch, aaBuilder[8].pitch,
	aaBuilder[1].pitchSlider, aaBuilder[2].pitchSlider, aaBuilder[3].pitchSlider, aaBuilder[4].pitchSlider, aaBuilder[5].pitchSlider, aaBuilder[6].pitchSlider, aaBuilder[7].pitchSlider, aaBuilder[8].pitchSlider,
	aaBuilder[1].yawBase, aaBuilder[2].yawBase, aaBuilder[3].yawBase, aaBuilder[4].yawBase, aaBuilder[5].yawBase, aaBuilder[6].yawBase, aaBuilder[7].yawBase, aaBuilder[8].yawBase,
	aaBuilder[1].yaw, aaBuilder[2].yaw, aaBuilder[3].yaw, aaBuilder[4].yaw, aaBuilder[5].yaw, aaBuilder[6].yaw, aaBuilder[7].yaw, aaBuilder[8].yaw,
	aaBuilder[1].yawCondition, aaBuilder[2].yawCondition, aaBuilder[3].yawCondition, aaBuilder[4].yawCondition, aaBuilder[5].yawCondition, aaBuilder[6].yawCondition, aaBuilder[7].yawCondition, aaBuilder[8].yawCondition,
	aaBuilder[1].yawStatic, aaBuilder[2].yawStatic, aaBuilder[3].yawStatic, aaBuilder[4].yawStatic, aaBuilder[5].yawStatic, aaBuilder[6].yawStatic, aaBuilder[7].yawStatic, aaBuilder[8].yawStatic,
	aaBuilder[1].yawLeft, aaBuilder[2].yawLeft, aaBuilder[3].yawLeft, aaBuilder[4].yawLeft, aaBuilder[5].yawLeft, aaBuilder[6].yawLeft, aaBuilder[7].yawLeft, aaBuilder[8].yawLeft,
	aaBuilder[1].yawRight, aaBuilder[2].yawRight, aaBuilder[3].yawRight, aaBuilder[4].yawRight, aaBuilder[5].yawRight, aaBuilder[6].yawRight, aaBuilder[7].yawRight, aaBuilder[8].yawRight,
	aaBuilder[1].yawSpeed, aaBuilder[2].yawSpeed, aaBuilder[3].yawSpeed, aaBuilder[4].yawSpeed, aaBuilder[5].yawSpeed, aaBuilder[6].yawSpeed, aaBuilder[7].yawSpeed, aaBuilder[8].yawSpeed,
	aaBuilder[1].yawJitter, aaBuilder[2].yawJitter, aaBuilder[3].yawJitter, aaBuilder[4].yawJitter, aaBuilder[5].yawJitter, aaBuilder[6].yawJitter, aaBuilder[7].yawJitter, aaBuilder[8].yawJitter,
	aaBuilder[1].yawJitterCondition, aaBuilder[2].yawJitterCondition, aaBuilder[3].yawJitterCondition, aaBuilder[4].yawJitterCondition, aaBuilder[5].yawJitterCondition, aaBuilder[6].yawJitterCondition, aaBuilder[7].yawJitterCondition, aaBuilder[8].yawJitterCondition,
	aaBuilder[1].yawJitterStatic, aaBuilder[2].yawJitterStatic, aaBuilder[3].yawJitterStatic, aaBuilder[4].yawJitterStatic, aaBuilder[5].yawJitterStatic, aaBuilder[6].yawJitterStatic, aaBuilder[7].yawJitterStatic, aaBuilder[8].yawJitterStatic,
	aaBuilder[1].yawJitterLeft, aaBuilder[2].yawJitterLeft, aaBuilder[3].yawJitterLeft, aaBuilder[4].yawJitterLeft, aaBuilder[5].yawJitterLeft, aaBuilder[6].yawJitterLeft, aaBuilder[7].yawJitterLeft, aaBuilder[8].yawJitterLeft,
	aaBuilder[1].yawJitterRight, aaBuilder[2].yawJitterRight, aaBuilder[3].yawJitterRight, aaBuilder[4].yawJitterRight, aaBuilder[5].yawJitterRight, aaBuilder[6].yawJitterRight, aaBuilder[7].yawJitterRight, aaBuilder[8].yawJitterRight,
	aaBuilder[1].yawJitterDisablers, aaBuilder[2].yawJitterDisablers, aaBuilder[3].yawJitterDisablers, aaBuilder[4].yawJitterDisablers, aaBuilder[5].yawJitterDisablers, aaBuilder[6].yawJitterDisablers, aaBuilder[7].yawJitterDisablers, aaBuilder[8].yawJitterDisablers,
	aaBuilder[1].bodyYaw, aaBuilder[2].bodyYaw, aaBuilder[3].bodyYaw, aaBuilder[4].bodyYaw, aaBuilder[5].bodyYaw, aaBuilder[6].bodyYaw, aaBuilder[7].bodyYaw, aaBuilder[8].bodyYaw,
	aaBuilder[1].bodyYawSlider, aaBuilder[2].bodyYawSlider, aaBuilder[3].bodyYawSlider, aaBuilder[4].bodyYawSlider, aaBuilder[5].bodyYawSlider, aaBuilder[6].bodyYawSlider, aaBuilder[7].bodyYawSlider, aaBuilder[8].bodyYawSlider,
	aaBuilder[1].defensiveOpt, aaBuilder[2].defensiveOpt, aaBuilder[3].defensiveOpt, aaBuilder[4].defensiveOpt, aaBuilder[5].defensiveOpt, aaBuilder[6].defensiveOpt, aaBuilder[7].defensiveOpt, aaBuilder[8].defensiveOpt,
	aaBuilder[1].defensiveYaw, aaBuilder[2].defensiveYaw, aaBuilder[3].defensiveYaw, aaBuilder[4].defensiveYaw, aaBuilder[5].defensiveYaw, aaBuilder[6].defensiveYaw, aaBuilder[7].defensiveYaw, aaBuilder[8].defensiveYaw,
	aaBuilder[1].defensiveYawSlider, aaBuilder[2].defensiveYawSlider, aaBuilder[3].defensiveYawSlider, aaBuilder[4].defensiveYawSlider, aaBuilder[5].defensiveYawSlider, aaBuilder[6].defensiveYawSlider, aaBuilder[7].defensiveYawSlider, aaBuilder[8].defensiveYawSlider,
	aaBuilder[1].defensivePitch, aaBuilder[2].defensivePitch, aaBuilder[3].defensivePitch, aaBuilder[4].defensivePitch, aaBuilder[5].defensivePitch, aaBuilder[6].defensivePitch, aaBuilder[7].defensivePitch, aaBuilder[8].defensivePitch,
	aaBuilder[1].defensivePitchSlider, aaBuilder[2].defensivePitchSlider, aaBuilder[3].defensivePitchSlider, aaBuilder[4].defensivePitchSlider, aaBuilder[5].defensivePitchSlider, aaBuilder[6].defensivePitchSlider, aaBuilder[7].defensivePitchSlider, aaBuilder[8].defensivePitchSlider}
}


local function import(text)
    local status, config =
        pcall(
        function()
            return json.parse(base64.decode(text))
        end
    )
    if not status or status == nil then
	    client.color_log(200, 200, 200, " error while importing!")
        return
    end
    if config ~= nil then
        for k, v in pairs(config) do
            k = ({[1] = 'integers'})[k]

            for k2, v2 in pairs(v) do
                if k == 'integers' then
                    ui.set(data[k][k2], v2)
                end
            end
        end
    end
end

local function precache_model(modelname)
    local rawprecache_table = find_table(networkstringtablecontainer, "modelprecache") or error("couldnt find modelprecache", 2)
    if rawprecache_table then 
        local precache_table = ffi.cast(class_ptr, rawprecache_table) or error("couldnt cast precache_table", 2)
        if precache_table then 
            local add_string = ffi.cast("add_string_t", precache_table[0][8]) or error("add_string is nil", 2)

            find_or_load_model(ivmodelinfo, modelname)
            local idx = add_string(precache_table, false, modelname, -1, nil)
            if idx == -1 then 
                return false
            end
        end
    end
    return true
end

local function set_model_index(entity, idx)
    local raw_entity = get_client_entity(ientitylist, entity)
    if raw_entity then 
        local gce_entity = ffi.cast(class_ptr, raw_entity)
        local a_set_model_index = ffi.cast("set_model_index_t", gce_entity[0][75])
        if a_set_model_index == nil then 
            error("set_model_index is nil")
        end
        a_set_model_index(gce_entity, idx)
    end
end

local function change_model(ent, model)
    if model:len() > 5 then 
        if precache_model(model) == false then 
            error("invalid model", 2)
        end
        local idx = get_model_index(ivmodelinfo, model)
        if idx == -1 then 
            return
        end
        set_model_index(ent, idx)
    end
end

sim_time_dt = 0
to_draw = "no"
to_up = "no"
to_draw_ticks = 0
go_ = "no"


function defensive_indicator()

    X,Y = client.screen_size()
   
    local diff_mmeme = var_table.sim_diff()

    if diff_mmeme <= -1 then
        to_draw = "yes"
        to_up = "yes"
        go_ = "yes"
     
    end
end 

function defensive_indicator_paint()
    if to_draw == "yes" and ui.get(reference.dt[2]) then

        draw_art = to_draw_ticks * 100 / 52

        -- renderer.text(X / 2,Y / 2 - 40,255,255,255,255,"c",0,"[defensive]")
        -- renderer.rectangle(X / 2 - 27,Y / 2 - 31,54,4,50,50,50,255)
        -- renderer.rectangle(X / 2 - 25,Y / 2 - 30,draw_art,2,255,255,255,255)
        to_draw_ticks = to_draw_ticks + 1

        if to_draw_ticks == 27 then
            to_draw_ticks = 0
            to_draw = "no"
            to_up = "no"
        end
    end
end


up_abuse = function()
	if not ui.get(pitchexploit) then return end
	    ui.set(reference.pitch[1],"Default")
		ui.set(reference.yaw[1],"180")
		if to_up == "yes" then
			ui.set(reference.pitch[1],"Up")
			ui.set(reference.yaw[1],"Spin")

			if not ui.get(reference.dt[1]) or not ui.get(reference.dt[2]) then
				to_up = "no"
			end
		end
	end
	
update_dt = 0
force_defensive = function(cmd)
    if ui.get(force_defensivebind) and update_dt + 0.2 < globals.curtime() then
        cmd.force_defensive = true
        update_dt = globals.curtime()
    end
end

local hc_ref = ui.reference('rage', 'aimbot', 'minimum hit chance')
ui.set_visible(hc_ref, false)
local local_player, callback_reg, dt_charged = nil, false, false

local function check_charge()
    local m_nTickBase = entity.get_prop(local_player, 'm_nTickBase')
    local client_latency = client.latency()
    local shift = math.floor(m_nTickBase - globals.tickcount() - 3 - toticks(client_latency) * .5 + .5 * (client_latency * 10))

    local wanted = -14 + (ui.get(reference.doubletap.fakelag_limit) - 1) + 3 --error margin

    dt_charged = shift <= wanted
end

local fakeduckbreak, bindfdda = ui.reference('RAGE', 'Other', 'Duck peek assist')

function set_custom_settings(c)



up_abuse()
end

local ccsweaponinfo_t = [[
    struct {
        char         __pad_0x0000[0x1cd];                   // 0x0000
        bool         hide_vm_scope;                // 0x01d1
    }
]]

local weaponsystem_raw = ffi.cast("void****", ffi.cast("char*", client.find_signature("client_panorama.dll", "\x8B\x35\xCC\xCC\xCC\xCC\xFF\x10\x0F\xB7\xC0")) + 2)[0]
local get_weapon_info = vtable_thunk(2, ccsweaponinfo_t .. "*(__thiscall*)(void*, unsigned int)")
client.set_event_callback("run_command", function()
    local w_id = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_iItemDefinitionIndex")
    if not weaponsystem_raw or not w_id then return end
    local res = get_weapon_info(weaponsystem_raw, w_id)
    res.hide_vm_scope = not ui.get(fovin_scope)
end)



local aa = {
	ignore = false,
	manualAA= 0,
	input = 0,
}
client.set_event_callback("player_connect_full", function() 
	aa.ignore = false
	aa.manualAA= 0
	aa.input = globals.curtime()
end)


local clantag = {
    steam = steamworks.ISteamFriends,
    prev_ct = "",
    orig_ct = "",
    enb = false,
}

local function get_original_clantag()
    local clan_id = cvar.cl_clanid.get_int()
    if clan_id == 0 then return "\0" end

    local clan_count = clantag.steam.GetClanCount()
    for i = 0, clan_count do 
        local group_id = clantag.steam.GetClanByIndex(i)
        if group_id == clan_id then
            return clantag.steam.GetClanTag(group_id)
        end
    end
end

local clantag_anim = function(text, indices)

    time_to_ticks = function(t)
        return math.floor(0.5 + (t / globals.tickinterval()))
    end

    local text_anim = "               " .. text ..                       "" 
    local tickinterval = globals.tickinterval()
    local tickcount = globals.tickcount() + time_to_ticks(client.latency())
    local i = tickcount / time_to_ticks(0.3)
    i = math.floor(i % #indices)
    i = indices[i+1]+1
    return string.sub(text_anim, i, i+15)
end

local function clantag_set()
    local lua_name = "hyperstonelua.ru "
    if ui.get(clantagchanger) then
        if ui.get(ui.reference("Misc", "Miscellaneous", "Clan tag spammer")) then ui.set(ui.reference("Misc", "Miscellaneous", "Clan tag spammer"), false) end

		local clan_tag = clantag_anim(lua_name, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25})

        if entity.get_prop(entity.get_game_rules(), "m_gamePhase") == 5 then
            clan_tag = clantag_anim('hyperstonelua.ru ', {15})
            client.set_clan_tag(clan_tag)
        elseif entity.get_prop(entity.get_game_rules(), "m_timeUntilNextPhaseStarts") ~= 0 then
            clan_tag = clantag_anim('hyperstonelua.ru ', {15})
            client.set_clan_tag(clan_tag)
        elseif clan_tag ~= clantag.prev_ct  then
            client.set_clan_tag(clan_tag)
        end

        clantag.prev_ct = clan_tag
        clantag.enb = true
    elseif clantag.enb == true then
        client.set_clan_tag(get_original_clantag())
        clantag.enb = false
    end
end

clantag.run_command = function(e)
    if entity.get_local_player() ~= nil then 
        if e.chokedcommands == 0 then
            clantag_set()
        end
    end
end

clantag.player_connect_full = function(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then 
        clantag.orig_ct = get_original_clantag()
    end
end

client.set_event_callback("setup_command", function(cmd)
    vars.localPlayer = entity.get_local_player()

    if not vars.localPlayer or not entity.is_alive(vars.localPlayer) then return end
	local flags = entity.get_prop(vars.localPlayer, "m_fFlags")
    local onground = bit.band(flags, 1) ~= 0 and cmd.in_jump == 0
	local valve = entity.get_prop(entity.get_game_rules(), "m_bIsValveDS")
	local origin = vector(entity.get_prop(vars.localPlayer, "m_vecOrigin"))
	local velocity = vector(entity.get_prop(vars.localPlayer, "m_vecVelocity"))
	local camera = vector(client.camera_angles())
	local eye = vector(client.eye_position())
	local speed = math.sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y) + (velocity.z * velocity.z))
    local weapon = entity.get_player_weapon()
	local pStill = math.sqrt(velocity.x ^ 2 + velocity.y ^ 2) < 5
    local bodyYaw = entity.get_prop(vars.localPlayer, "m_flPoseParameter", 11) * 120 - 60

    local weapon = entity.get_player_weapon(vars.localPlayer)

    local isSlow = ui.get(reference.slow_motion[1]) and ui.get(reference.slow_motion[2])
	local isOs = ui.get(reference.on_shot[1]) and ui.get(reference.on_shot[2])
	local isFd = ui.get(reference.fakeDuck)
	local isDt = ui.get(reference.doubletap.main[1]) and ui.get(reference.doubletap.main[2])
    local isLegitAA = ui.get(aaBuilder[8].enableState) and client.key_state(0x45)
    local isDefensive = (func.defensive.defensive > 1 and func.defensive.defensive < 14)
	
    -- search for states
    vars.pState = 1
    if pStill then vars.pState = 2 end
    if not pStill then vars.pState = 3 end
    if isSlow then vars.pState = 4 end
    if entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 5 end
    if not onground then vars.pState = 6 end
    if not onground and entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1 then vars.pState = 7 end

    if ui.get(aaBuilder[vars.pState].enableState) == false and vars.pState ~= 1 then
        vars.pState = 1
    end

    if isLegitAA and not vars.should_disable then
        vars.pState = 8
    end

    local nextAttack = entity.get_prop(vars.localPlayer, "m_flNextAttack")
    local nextPrimaryAttack = entity.get_prop(entity.get_player_weapon(vars.localPlayer), "m_flNextPrimaryAttack")
    local dtActive = false
    local isFl = ui.get(ui.reference("AA", "Fake lag", "Enabled"))
    if nextPrimaryAttack ~= nil then
        dtActive = not (math.max(nextPrimaryAttack, nextAttack) > globals.curtime())
    end

    local side_yaw = 2
    if cmd.chokedcommands == 0 then
        vars.choke1 = vars.choke1 + 1
        vars.choke2 = vars.choke2 + 1
        vars.choke3 = vars.choke3 + 1
        vars.choke4 = vars.choke4 + 1
    end
    if vars.choke1 >= 5 then
        vars.choke1 = 0
    end
    if vars.choke2 >= 8 then
        vars.choke2 = 0
    end
    if vars.choke3 >= 8 then
        vars.choke3 = 5
    end

    if globals.tickcount() % ui.get(aaBuilder[vars.pState].yawSpeed) == 1 then
        vars.switch = not vars.switch
    end

    local tickcount = globals.tickcount()

    local side = bodyYaw > 0 and 1 or -1

        -- manual aa
        local isStatic = ui.get(staticManuals)

        ui.set(manualLeft, "On hotkey")
        ui.set(manualRight, "On hotkey")
        ui.set(manualReset, "On hotkey")
        ui.set(manualForward, "On hotkey")

        if aa.input + 0.182 < globals.curtime() then
            if aa.manualAA == 0 then
                if ui.get(manualLeft) then
                    aa.manualAA = 1
                    aa.input = globals.curtime()    
                    ui.set(reference.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(reference.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))
                elseif ui.get(manualRight) then
                    aa.manualAA = 2
                    aa.input = globals.curtime()
                    ui.set(reference.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(reference.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))
                elseif ui.get(manualForward) then
                    aa.manualAA = 3
                    aa.input = globals.curtime()
                    ui.set(reference.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(reference.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(manualReset) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()
                    ui.set(reference.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(reference.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                end
            elseif aa.manualAA == 1 then
                if ui.get(manualRight) then
                    aa.manualAA = 2
                    aa.input = globals.curtime()
                    ui.set(reference.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(reference.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(manualForward) then
                    aa.manualAA = 3
                    aa.input = globals.curtime()
                    ui.set(reference.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(reference.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(manualLeft) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()
                    ui.set(reference.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(reference.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(manualReset) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()    
                    ui.set(reference.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(reference.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                end
            elseif aa.manualAA == 2 then
                if ui.get(manualLeft) then
                    aa.manualAA = 1
                    aa.input = globals.curtime()
                    ui.set(reference.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(reference.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(manualForward) then
                    aa.manualAA = 3
                    aa.input = globals.curtime()
                    ui.set(reference.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(reference.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(manualRight) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()
                    ui.set(reference.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(reference.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(manualReset) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()    
                    ui.set(reference.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(reference.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                end
            elseif aa.manualAA == 3 then
                if ui.get(manualForward) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()
                    ui.set(reference.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(reference.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(manualLeft) then
                    aa.manualAA = 1
                    aa.input = globals.curtime()
                    ui.set(reference.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(reference.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(manualRight) then
                    aa.manualAA = 2
                    aa.input = globals.curtime()
                    ui.set(reference.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(reference.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                elseif ui.get(manualReset) then
                    aa.manualAA = 0
                    aa.input = globals.curtime()    
                    ui.set(reference.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
                    ui.set(reference.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))  
                end
            end

            if aa.manualAA == 1 or aa.manualAA == 2 or aa.manualAA == 3 then
                aa.ignore = true

                if isStatic then
                    ui.set(reference.yaw_jitter[1], "Off")
                    ui.set(reference.yaw_jitter[2], 0)
                    ui.set(reference.body_yaw[1], "Static")
                    ui.set(reference.body_yaw[2], 180)

                    if aa.manualAA == 1 then
                        ui.set(reference.yaw_base, "local view")
                        ui.set(reference.yaw[1], "180")
                        ui.set(reference.yaw[2], -90)
                    elseif aa.manualAA == 2 then
                        ui.set(reference.yaw_base, "local view")
                        ui.set(reference.yaw[1], "180")
                        ui.set(reference.yaw[2], 90)
                    elseif aa.manualAA == 3 then
                        ui.set(reference.yaw_base, "local view")
                        ui.set(reference.yaw[1], "180")
                        ui.set(reference.yaw[2], 180)
                    end
                elseif not isStatic and ui.get(aaBuilder[vars.pState].enableState) then
                    if ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                        ui.set(reference.yaw_jitter[1], "Center")
                        ui.set(reference.yaw_jitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft)*math.random(-1, 1)  or ui.get(aaBuilder[vars.pState].yawJitterRight)*math.random(-1, 1) ))
                    elseif ui.get(aaBuilder[vars.pState].yawJitter) == "L & R" then
                        ui.set(reference.yaw_jitter[1], "Center")
                        ui.set(reference.yaw_jitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft) or ui.get(aaBuilder[vars.pState].yawJitterRight)))
                    else
                        ui.set(reference.yaw_jitter[1], ui.get(aaBuilder[vars.pState].yawJitter))
                        ui.set(reference.yaw_jitter[2], ui.get(aaBuilder[vars.pState].yawJitterStatic))
                    end

                    if ui.get(aaBuilder[vars.pState].yawCondition) == "L & R" then
                        ui.set(reference.body_yaw[1], "Jitter")
                        ui.set(reference.body_yaw[2], -1)
                    else
                        ui.set(reference.body_yaw[1], "Static")
                        ui.set(reference.body_yaw[2], -180)
                    end

                    if aa.manualAA == 1 then
                        ui.set(reference.yaw_base, "local view")
                        ui.set(reference.yaw[1], "180")
                        ui.set(reference.yaw[2], -90)
                    elseif aa.manualAA == 2 then
                        ui.set(reference.yaw_base, "local view")
                        ui.set(reference.yaw[1], "180")     
                        ui.set(reference.yaw[2], 90)
                    elseif aa.manualAA == 3 then
                        ui.set(reference.yaw_base, "local view")
                        ui.set(reference.yaw[1], "180")
                        ui.set(reference.yaw[2], 180)
                    end
                end
            else
                aa.ignore = false
            end
        elseif aa.input > globals.curtime() then
        --    aa.ignore = false
        --    aa.manualAA = 0
            aa.input = globals.curtime()
        end

    -- check height advantage and head safety
    local heightAdvantage = false
    local safetyAlert = false
    local enemies = entity.get_players(true)
	for i=1, #enemies do
        if entity.is_dormant(enemies[i]) then heightAlert = false sidewaysAlert = false return end
		local playerX, playerY, playerZ  = entity.get_prop(enemies[i], "m_vecOrigin")
		local playerFlags = entity.get_prop(enemies[i], "m_fFlags")
		local playerOnGround = bit.band(playerFlags, 1) ~= 0
		local lengthDistance = math.sqrt((playerX - origin.x)^2 + (playerY - origin.y)^2 + (playerZ - origin.z)^2)
		if ((playerZ + 100 < origin.z) and lengthDistance <= 300) then
			heightAdvantage = true
		else
			heightAdvantage = false
		end

        if ((bodyYaw >= 40 or bodyYaw <= -40) and func.headVisible(enemies[i])) then
			safetyAlert = true
		else
			safetyAlert = false
		end
	end

    if ui.get(aaBuilder[vars.pState].enableState) then

        if func.includes(ui.get(aaBuilder[vars.pState].defensiveOpt), "Always on") then
            cmd.force_defensive = true
        end

        if cmd.chokedcommands > 1 then
            cmd.allow_send_packet = false
        else
            cmd.allow_send_packet = true
        end

        if func.includes(ui.get(aaBuilder[vars.pState].defensiveOpt), "Elusive mode") then
            ui.set(reference.doubletap.main[3], "Defensive")

            if tickcount % 3 == 1 then
                ui.set(reference.doubletap.main[3], "Offensive")
            end
            cmd.force_defensive = tickcount % 3 ~= 1
        end
        

        if aa.ignore then return end

        if ui.get(aaBuilder[vars.pState].defensivePitch) == "Custom" and isDefensive then
            ui.set(reference.pitch[1], "Custom")
            ui.set(reference.pitch[2], ui.get(aaBuilder[vars.pState].defensivePitchSlider))
        else
            ui.set(reference.pitch[1], ui.get(aaBuilder[vars.pState].pitch))
            ui.set(reference.pitch[2], ui.get(aaBuilder[vars.pState].pitchSlider))
        end                

        ui.set(reference.yaw_base, ui.get(aaBuilder[vars.pState].yawBase))

        ui.set(reference.yaw[1], ui.get(aaBuilder[vars.pState].yaw))

        if ui.get(aaBuilder[vars.pState].defensiveYaw) == "Random" and isDefensive then
            local randomyaw = client.random_int(61, 180)
            ui.set(reference.yaw[2], func.aa_clamp((tickcount % 6 < 3 and randomyaw or -randomyaw)))
        elseif ui.get(aaBuilder[vars.pState].defensiveYaw) == "Jitter" and isDefensive then
            ui.set(reference.yaw[2], tickcount % 3 == 0 and client.random_int(90, -90) or tickcount % 3 == 1 and 180 or tickcount % 3 == 2 and client.random_int(-90, 90) or 0)
        elseif ui.get(aaBuilder[vars.pState].defensiveYaw) == "Custom" and isDefensive then
--            ui.set(reference.yaw[2], "Custom")
            ui.set(reference.yaw[2], ui.get(aaBuilder[vars.pState].defensiveYawSlider))
        elseif ui.get(aaBuilder[vars.pState].yawCondition) == "L & R" then

            ui.set(reference.yaw[2],(side == 1 and ui.get(aaBuilder[vars.pState].yawLeft) or ui.get(aaBuilder[vars.pState].yawRight)))

        elseif ui.get(aaBuilder[vars.pState].yawCondition) == "Hold" then

            if vars.choke2 == 0 then
                ui.set(reference.yaw[2], ui.get(aaBuilder[vars.pState].yawRight))
            elseif vars.choke2 == 1 then
                ui.set(reference.yaw[2], ui.get(aaBuilder[vars.pState].yawLeft))
            elseif vars.choke2 == 2 then
                ui.set(reference.yaw[2], ui.get(aaBuilder[vars.pState].yawLeft))
            elseif vars.choke2 == 3 then
                ui.set(reference.yaw[2], ui.get(aaBuilder[vars.pState].yawLeft))
            elseif vars.choke2 == 4 then
                ui.set(reference.yaw[2], ui.get(aaBuilder[vars.pState].yawRight))
            elseif vars.choke2 == 5 then
                ui.set(reference.yaw[2], ui.get(aaBuilder[vars.pState].yawLeft))
            elseif vars.choke2 == 6 then
                ui.set(reference.yaw[2], ui.get(aaBuilder[vars.pState].yawRight))
            elseif vars.choke2 == 7 then
                ui.set(reference.yaw[2], ui.get(aaBuilder[vars.pState].yawRight))
            end

        elseif ui.get(aaBuilder[vars.pState].yawCondition) == "Slow" then
            ui.set(reference.yaw[2], vars.switch and ui.get(aaBuilder[vars.pState].yawLeft) or ui.get(aaBuilder[vars.pState].yawRight))
            side_yaw = 0
        else
            ui.set(reference.yaw[2], ui.get(aaBuilder[vars.pState].yawStatic))
            side_yaw = 2
        end

        local switch = false
        if ((func.includes(ui.get(aaBuilder[vars.pState].yawJitterDisablers), "Height advantage" ) and heightAdvantage) or (func.includes(ui.get(aaBuilder[vars.pState].yawJitterDisablers), "Head safety") and safetyAlert)) then
            ui.set(reference.yaw_jitter[1], "Off") 
        elseif ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
            ui.set(reference.yaw_jitter[1], "Center")
        else
            ui.set(reference.yaw_jitter[1], ui.get(aaBuilder[vars.pState].yawJitter))
        end
        if ui.get(aaBuilder[vars.pState].yawJitterCondition) == "L & R" then
            if ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                ui.set(reference.yaw_jitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft)*math.random(-1, 1)  or ui.get(aaBuilder[vars.pState].yawJitterRight)*math.random(-1, 1) ))
            elseif ui.get(aaBuilder[vars.pState].yawJitter) == "Slow Jitter" then
                ui.set(reference.yaw[2], switch and ui.get(aaBuilder[vars.pState].yawJitterRight) or ui.get(aaBuilder[vars.pState].yawJitterLeft))
            else
                ui.set(reference.yaw_jitter[2], (side == 1 and ui.get(aaBuilder[vars.pState].yawJitterLeft) or ui.get(aaBuilder[vars.pState].yawJitterRight)))
            end
            
        else
            if  ui.get(aaBuilder[vars.pState].yawJitter) == "3-Way" then
                ui.set(reference.yaw_jitter[2], ui.get(aaBuilder[vars.pState].yawJitterStatic)*math.random(-1, 1) )
            elseif ui.get(aaBuilder[vars.pState].yawJitter) == "Slow Jitter" then
                ui.set(reference.yaw[2], switch and ui.get(aaBuilder[vars.pState].yawJitterStatic) or -ui.get(aaBuilder[vars.pState].yawJitterStatic))
            else
                ui.set(reference.yaw_jitter[2], ui.get(aaBuilder[vars.pState].yawJitterStatic) )
            end
        end

        if ui.get(aaBuilder[vars.pState].yawCondition) == "Slow" then
            ui.set(reference.body_yaw[1], "Static")
            ui.set(reference.body_yaw[2], 0)
        elseif ui.get(aaBuilder[vars.pState].yawCondition) == "Hold" then
            ui.set(reference.body_yaw[1], "Static")
            ui.set(reference.body_yaw[2], 0)
        else
            ui.set(reference.body_yaw[1], ui.get(aaBuilder[vars.pState].bodyYaw))
            ui.set(reference.body_yaw[2], ui.get(aaBuilder[vars.pState].bodyYawSlider))
        end

        if reversed and ui.get(aaBuilder[vars.pState].antiBruteSet) then
            ui.set(reference.yaw[2], angle)
        end

        ui.set(reference.freestanding_body_yaw, false)
    elseif not ui.get(aaBuilder[vars.pState].enableState) then
        ui.set(reference.pitch[1], "Off")
        ui.set(reference.yaw_base, "Local view")
        ui.set(reference.yaw[1], "Off")
        ui.set(reference.yaw[2], 0)
        ui.set(reference.yaw_jitter[1], "Off")
        ui.set(reference.yaw_jitter[2], 0)
        ui.set(reference.body_yaw[1], "Off")
        ui.set(reference.body_yaw[2], 0)
        ui.set(reference.freestanding_body_yaw, false)
        ui.set(reference.edge_yaw, false)
        ui.set(reference.roll, 0)
    end

    -- fix hideshots
	if isOs and not isDt and not isFd then
        if not hsSaved then
            hsValue = ui.get(reference.fakeLag[1])
            hsSaved = true
        end
		ui.set(reference.fakeLag[1], 1)
	elseif hsSaved then
		ui.set(reference.fakeLag[1], hsValue)
        hsSaved = false
	else
		ui.set(reference.fakeLag[1], 12)	
	end
		
    distance_knife = {}
    distance_knife.anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
        return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
    end


    -- Avoid backstab
    if ui.get(avoidBackstab) ~= 0 then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        if players == nil then return end
        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = distance_knife.anti_knife_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= ui.get(avoidBackstab) then
                ui.set(reference.yaw[2], 180)
                ui.set(reference.yaw_base, "At targets")
            end
        end
    end
    -- edgeyaw
    ui.set(reference.edge_yaw, ui.get(edgeYawHotkey))
end)

client.set_event_callback("setup_command", function(e)
    if not vars.localPlayer or not entity.is_alive(vars.localPlayer) then return end
	local flags = entity.get_prop(vars.localPlayer, "m_fFlags")
    local onground = bit.band(flags, 1) ~= 0 and e.in_jump == 0
    local isSlow = ui.get(reference.slow_motion[1]) and ui.get(reference.slow_motion[2])

    local air = func.includes(ui.get(freestandDisablers), "Air") and not onground
    local duck = func.includes(ui.get(freestandDisablers), "Duck") and entity.get_prop(vars.localPlayer, "m_flDuckAmount") > 0.1
    local slow = func.includes(ui.get(freestandDisablers), "Slowmo") and isSlow
    local manul = func.includes(ui.get(freestandDisablers), "Manual") and (aa.manualAA == 2 or aa.manualAA == 1) and aa.ignore
    local fs_disabler = air or duck or slow or manul

    if ui.get(freestandHotkey) and not fs_disabler then
        vars.fs = true
        ui.set(reference.freestanding[2], "Always on")
        ui.set(reference.freestanding[1], true)
    else
        vars.fs = false
        ui.set(reference.freestanding[1], false)
        ui.set(reference.freestanding[2], "On hotkey")
    end    
end)

client.set_event_callback("setup_command", function(cmd)
    local using = true
    local defusing = false
    vars.should_disable = false

    if entity.get_classname(entity.get_player_weapon(vars.localPlayer)) == "CC4" then
        vars.should_disable = true
        return
    end

    local planted_bomb = entity.get_all("CPlantedC4")[1]
    local classnames = {"CWorld","CCSPlayer","CFuncBrush","CPropDoorRotating","CHostage"}

    if planted_bomb ~= nil then
        local bomb_distance = vector(entity.get_origin(vars.localPlayer)):dist(vector(entity.get_origin(planted_bomb)))
        
        if bomb_distance <= 64 and entity.get_prop(vars.localPlayer, "m_iTeamNum") == 3 then
            vars.should_disable = true
            defusing = true
        end
    end

    local pitch, yaw = client.camera_angles()
    local direct_vec = vector(func.vec_angles(pitch, yaw))

    local eye_pos = vector(client.eye_position())
    local fraction, ent = client.trace_line(vars.localPlayer, eye_pos.x, eye_pos.y, eye_pos.z, eye_pos.x + (direct_vec.x * 8192), eye_pos.y + (direct_vec.y * 8192), eye_pos.z + (direct_vec.z * 8192))

    local using = true

    if ent ~= nil and ent ~= -1 then
        for i=0, #classnames do
            if entity.get_classname(ent) == classnames[i] then
                using = false
            end
        end
    end

    if not vars.should_disable and client.key_state(0x45) and not using and not defusing and ui.get(aaBuilder[8].enableState) then
        cmd.in_use = 0
    end
end)

client.set_event_callback('setup_command', function(cmd)
	set_custom_settings(cmd)
	-- hithance ssg
	if  ui.get(sgghithance) and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) == "CWeaponSSG08" then
		ui.set(hc_ref, ui.get(def_hc))
	end
	if ui.get(sgghithance) and bit.band(entity.get_prop(entity.get_local_player(), 'm_fFlags'), 1) ~= 1 and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) == "CWeaponSSG08" then
		ui.set(hc_ref, ui.get(hit_chance_ovr))
	end
	--dt unsafe
	if ui.get(dtunsafe) then
	if not ui.get(reference.doubletap.main[2]) or not ui.get(reference.doubletap.main[1]) then
        ui.set(reference.aimbot, true)

        if callback_reg then
            client.unset_event_callback('run_command', check_charge)
            callback_reg = false
        end
        return
    end

    local_player = entity.get_local_player()

    if not callback_reg then
        client.set_event_callback('run_command', check_charge)
        callback_reg = true
    end

    local threat = client.current_threat()

    if not dt_charged
    and threat
    and bit.band(entity.get_prop(local_player, 'm_fFlags'), 1) == 0
    and bit.band(entity.get_esp_data(threat).flags, bit.lshift(1, 11)) == 2048 then
        ui.set(reference.aimbot, false)
    else
        ui.set(reference.aimbot, true)
    end
	
	else 
	
	ui.set(reference.aimbot, true)
	
	end
	
	-- air lag
	if ui.get(bigbreeak1) and globals.tickcount() % ui.get(bigbreeak2) == 0 then
		ui.set(fakeduckbreak, 'Always On')
	else
		ui.set(fakeduckbreak, 'On hotkey')
	end
	defensive_indicator()
end)

local function DrawGlowPizda(x,y,r,g,b,a,text1,temp1,text2)

renderer.text(x + 1, y, r, g, b, 65, text1, temp1, text2)
renderer.text(x - 1, y, r, g, b, 65, text1, temp1, text2)
renderer.text(x, y + 1, r, g, b, 65, text1, temp1, text2)
renderer.text(x, y - 1, r, g, b, 65, text1, temp1, text2)

renderer.text(x, y, r, g, b, a, text1, temp1, text2)


end


local clamp = function(v, min, max) local num = v; num = num < min and min or num; num = num > max and max or num; return num end
local m_alpha = 0

local g_paint_ui = function()
	ui.set(ui.reference('VISUALS', 'Effects', 'Remove scope overlay'), true)
end

local g_paint = function()
	ui.set(ui.reference('VISUALS', 'Effects', 'Remove scope overlay'), false)

	local width, height = client.screen_size()
	local offset, initial_position, speed, color =
		ui.get(overlay_offset) * height / 1080, 
		ui.get(overlay_position) * height / 1080, 
		10, { ui.get(color_picker) }

	local me = entity.get_local_player()
	local wpn = entity.get_player_weapon(me)

	local scope_level = entity.get_prop(wpn, 'm_zoomLevel')
	local scoped = entity.get_prop(me, 'm_bIsScoped') == 1
	local resume_zoom = entity.get_prop(me, 'm_bResumeZoom') == 1

	local is_valid = entity.is_alive(me) and wpn ~= nil and scope_level ~= nil
	local act = is_valid and scope_level > 0 and scoped and not resume_zoom

	local FT = speed > 3 and globals.frametime() * speed or 1
	local alpha = easing.linear(m_alpha, 0, 1, 1)

	renderer.gradient(width/2 - initial_position + 2, height / 2, initial_position - offset, 1, color[1], color[2], color[3], 0, color[1], color[2], color[3], alpha*color[4], true)
	renderer.gradient(width/2 + offset, height / 2, initial_position - offset, 1, color[1], color[2], color[3], alpha*color[4], color[1], color[2], color[3], 0, true)

	renderer.gradient(width / 2, height/2 - initial_position + 2, 1, initial_position - offset, color[1], color[2], color[3], 0, color[1], color[2], color[3], alpha*color[4], false)
	renderer.gradient(width / 2, height/2 + offset, 1, initial_position - offset, color[1], color[2], color[3], alpha*color[4], color[1], color[2], color[3], 0, false)
	
	m_alpha = clamp(m_alpha + (act and FT or -FT), 0, 1)
end

local function ebaniba(c)

	local master_switch1, addr = ui.get(c), ''

	if not master_switch1 then
		m_alpha, addr = 0, 'un'
	end
	
	local _func = client[addr .. 'set_event_callback']

	ui.set_visible(ui.reference('VISUALS', 'Effects', 'Remove scope overlay'), not master_switch1)
	ui.set_visible(overlay_position, master_switch1)
	ui.set_visible(overlay_offset, master_switch1)
	_func('paint_ui', g_paint_ui)
	_func('paint', g_paint)


end

local function indicatorscope()

local screen = vector(client.screen_size())
local start = screen / 2 + vector(0, 15)
local scoped = entity.get_prop(entity.get_local_player(), "m_bIsScoped")
local add_x = 34 * scoped
local body_yaw = entity.get_prop(entity.get_local_player(), 'm_flPoseParameter', 11) * 120 - 60






local eblansosi, eblansosi2 = 0
if ui.get(crosshairind) == 'Old' then

			
            DrawGlowPizda(start.x - 32 + add_x, start.y + 1, 200, 255, 200, 255, '-', nil, 'HYPERSTONE.LUA')
			if ui.get(reference.RAGE.aimbot.min_damage_override[1]) and ui.get(reference.RAGE.aimbot.min_damage_override[2]) then
            DrawGlowPizda(start.x - 23 + add_x, start.y + 10, 150, 255, 200, 255, '-', nil, 'DAMAGE OVR')
			eblansosi = 10
			else
			eblansosi = 0
			end
			
			if ui.get(reference.RAGE.aimbot.on_shot_anti_aim[1]) and ui.get(reference.RAGE.aimbot.on_shot_anti_aim[2]) then
			DrawGlowPizda(start.x - 21 + add_x, start.y + 10 + eblansosi, 255, 255, 255, 255, '-', nil, 'HIDESHOTS')
			eblansosi2 = 10
			else
			eblansosi2 = 0
			end			
			if  ui.get(sgghithance) and bit.band(entity.get_prop(entity.get_local_player(), 'm_fFlags'), 1) ~= 1 and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) == "CWeaponSSG08" then
			DrawGlowPizda(start.x - 21 + add_x, start.y + 10 + eblansosi + eblansosi2, 255, 255, 255, 255, '-', nil, 'HITCHANCE')
			eblansosi23 = 10
			else
			eblansosi23 = 0
			end
			
			if  ui.get(bigbreeak1) then
			DrawGlowPizda(start.x - 19 + add_x, start.y + 10 + eblansosi + eblansosi2 + eblansosi23, 255, 255, 255, 255, '-', nil, 'BREAKING')
			eblansosi233 = 10
			else
			eblansosi233 = 0
			end
			
			if ui.get(reference.RAGE.aimbot.double_tap[1]) and ui.get(reference.RAGE.aimbot.double_tap[2]) then
			DrawGlowPizda(start.x - 5 + add_x, start.y + 10 + eblansosi + eblansosi2 + eblansosi23 + eblansosi233, 255, 255, 255, 255, '-', nil, 'DT')
			eblansosi2 = 10
			else
			eblansosi2 = 0
			end
elseif ui.get(crosshairind) == 'New' then


  
end

local xyitadada = 0

if ui.get(arrowindicator) then
		local screen = vector(client.screen_size())
		local start = screen / 2 + vector(0, 0)
		if entity.get_prop(entity.get_local_player(), 'm_bIsScoped') == 1 then
		xyitadada = ui.get(overlay_position)
		else
		xyitadada = 0
		end
        ts_arrowsanim = 50 + xyitadada
        local ts_colleft = aa.manualAA == 1 and { ui.get(color_pickerstrelki) } or { 23, 23, 23, 200}
        local ts_colright = aa.manualAA == 2 and { ui.get(color_pickerstrelki) } or { 23, 23, 23, 200}

        renderer.triangle(start.x + (ts_arrowsanim+13), start.y, start.x + ts_arrowsanim, start.y - 9, start.x + ts_arrowsanim, start.y + 9, ts_colright[1], ts_colright[2], ts_colright[3], ts_colright[4])
        renderer.triangle(start.x - (ts_arrowsanim+13), start.y, start.x - ts_arrowsanim, start.y - 9, start.x - ts_arrowsanim, start.y + 9, ts_colleft[1], ts_colleft[2], ts_colleft[3], ts_colleft[4])
		
		ts_lineanim = ts_arrowsanim
        local ts_collefteblan = (body_yaw > 0) and { ui.get(color_pickerstrelki2) } or { 23, 23, 23, 200}
        local ts_colrighteblan = (body_yaw < 0) and { ui.get(color_pickerstrelki2) } or { 23, 23, 23, 200}
        renderer.rectangle(start.x + (ts_lineanim-4), start.y - 9, 2, 18, ts_collefteblan[1], ts_collefteblan[2], ts_collefteblan[3], ts_collefteblan[4])
        renderer.rectangle(start.x - (ts_lineanim-2), start.y - 9, 2, 18, ts_colrighteblan[1], ts_colrighteblan[2], ts_colrighteblan[3], ts_colrighteblan[4])


end

end

local aspect_ratio_table = {}
local screen_width, screen_height = client.screen_size()
local function set_aspect_ratio(aspect_ratio_multiplier)
	local screen_width, screen_height = client.screen_size()
	local aspectratio_value = (screen_width*aspect_ratio_multiplier)/screen_height

	if aspect_ratio_multiplier == 1 then
		aspectratio_value = 0
	end
	client.set_cvar("r_aspectratio", tonumber(aspectratio_value))
end

local function gcd(m, n)
	-- greatest common divisor
	while m ~= 0 do
		m, n = math.fmod(n, m), m;
	end

	return n
end

for i=1, 200 do
	local i2=i*0.01
	i2 = 2 - i2
	local divisor = gcd(screen_width*i2, screen_height)
	if screen_width*i2/divisor < 100 or i2 == 1 then
		aspect_ratio_table[i] = screen_width*i2/divisor .. ":" .. screen_height/divisor
	end
end

local function on_aspect_ratio_changed()
	local aspect_ratio = ui.get(aspect_ratio_reference)*0.01
	aspect_ratio = 2 - aspect_ratio
	set_aspect_ratio(aspect_ratio)
end

local function clantagstart()

if entity.get_local_player() ~= nil then
    if globals.tickcount() % 2 == 0 then
        clantag_set()
    end
end


end


client.set_event_callback('paint', function()
clantagstart()
defensive_indicator_paint()
indicatorscope()
on_aspect_ratio_changed()
if entity.get_classname(entity.get_player_weapon(entity.get_local_player())) == "CKnife" then client.set_cvar("cl_righthand", ui.get(knifeeblan) == "Left" and 0 or 1) else client.set_cvar("cl_righthand", ui.get(weaponeblan) == "Left" and 0 or 1) end
end)

local ebalai2, ebalai3 = client.screen_size()

local update_skins = true
client.set_event_callback("pre_render", function()
    local me = entity.get_local_player()
    if me == nil then return end

    local team = entity.get_prop(me, 'm_iTeamNum') 

    if (team == 2 and MODELCHANGERNIGGERS(ui.get(model_check), 'T') ) or (team == 3 and MODELCHANGERNIGGERS(ui.get(model_check), 'CT') ) then
		change_model(me, team == 2 and t_player_models[ui.get(localplayer_model_t)] or ct_player_models[ui.get(localplayer_model_ct)] )
    end
end)



local import_btn = ui.new_button("AA", "Anti-aimbot angles", "Import settings", function() import(clipboard.get()) end)
local export_btn = ui.new_button("AA", "Anti-aimbot angles", "Export settings", function() 
    local code = {{}}

    for i, integers in pairs(data.integers) do
        table.insert(code[1], ui.get(integers))
    end

    clipboard.set(base64.encode(json.stringify(code)))
end)
local default_btn = ui.new_button("AA", "Anti-aimbot angles", "Default settings", function() 
import('') 
end)




client.set_event_callback('paint_ui', function()
    if ui.is_menu_open() then
		if ui.get(blurmenu) then renderer.blur(0, 0, ebalai2, ebalai3) end
		--Rage
		ui.set_visible(sgghithance, ui.get(mamytraxal) == 'Rage')
		ui.set_visible(def_hc, ui.get(mamytraxal) == 'Rage' and ui.get(sgghithance))
		ui.set_visible(hit_chance_ovr, ui.get(mamytraxal) == 'Rage' and ui.get(sgghithance))
		
		ui.set_visible(CustomResolver, ui.get(mamytraxal) == 'Rage')
		ui.set_visible(dtunsafe, ui.get(mamytraxal) == 'Rage')
		ui.set_visible(bigbreeak1, ui.get(mamytraxal) == 'Rage')
		ui.set_visible(bigbreeak2, ui.get(mamytraxal) == 'Rage')
		ui.set_visible(slideranimbreak, ui.get(mamytraxal) == 'Rage')
		
		--Anti aim
		ui.set_visible(pitchexploit, ui.get(mamytraxal) == 'Anti-Aim')
		ui.set_visible(force_defensivebind, ui.get(mamytraxal) == 'Anti-Aim')
		ui.set_visible(antiaimsstate, ui.get(mamytraxal) == 'Anti-Aim')
		ui.set_visible(antiaimsstate, ui.get(mamytraxal) == 'Anti-Aim')
		vars.activeState = vars.sToInt[ui.get(antiaimsstate)]
		ui.set(aaBuilder[1].enableState, true)
		for i = 1, #vars.aaStates do
			local stateEnabled = ui.get(aaBuilder[i].enableState)
			ui.set_visible(aaBuilder[i].enableState, vars.activeState == i and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].pitch, vars.activeState == i  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].pitchSlider , vars.activeState == i  and stateEnabled and ui.get(aaBuilder[i].pitch) == "Custom" and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].yawBase, vars.activeState == i  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].yaw, vars.activeState == i  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].yawCondition, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off"  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].yawStatic, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) == "Static"  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].yawLeft, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) ~= "Static"  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].yawRight, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) ~= "Static"  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].yawSpeed, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off" and ui.get(aaBuilder[i].yawCondition) == "Slow"  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].yawJitter, vars.activeState == i and ui.get(aaBuilder[i].yaw) ~= "Off"  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].yawJitterCondition, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off"  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].yawJitterStatic, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitterCondition) == "Static"  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].yawJitterLeft, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitterCondition) == "L & R"  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].yawJitterRight, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off" and ui.get(aaBuilder[i].yawJitterCondition) == "L & R"  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].yawJitterDisablers, vars.activeState == i and ui.get(aaBuilder[i].yawJitter) ~= "Off"  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].bodyYaw, vars.activeState == i  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].bodyYawSlider, vars.activeState == i and ui.get(aaBuilder[i].bodyYaw) ~= "Off"  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].defensiveOpt, vars.activeState == i  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].defensiveYaw, vars.activeState == i  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].defensiveYawSlider, vars.activeState == i  and stateEnabled  and ui.get(aaBuilder[i].defensiveYaw) == "Custom" and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].defensivePitch, vars.activeState == i  and stateEnabled and ui.get(mamytraxal) == 'Anti-Aim')
			ui.set_visible(aaBuilder[i].defensivePitchSlider, vars.activeState == i  and stateEnabled  and ui.get(aaBuilder[i].defensivePitch) == "Custom" and ui.get(mamytraxal) == 'Anti-Aim')
		end
		ui.set_visible(freestandHotkey, ui.get(mamytraxal) 			== 'Anti-Aim')
		ui.set_visible(freestandDisablers, ui.get(mamytraxal) 		== 'Anti-Aim')
		ui.set_visible(edgeYawHotkey, ui.get(mamytraxal) 			== 'Anti-Aim')
		ui.set_visible(avoidBackstab, ui.get(mamytraxal) 			== 'Anti-Aim')
		ui.set_visible(staticManuals, ui.get(mamytraxal) 			== 'Anti-Aim')
		ui.set_visible(antiaimsstate, ui.get(mamytraxal) 			== 'Anti-Aim')
		ui.set_visible(manualLeft, ui.get(mamytraxal) 				== 'Anti-Aim')
		ui.set_visible(manualRight, ui.get(mamytraxal) 				== 'Anti-Aim')
		ui.set_visible(manualReset, ui.get(mamytraxal) 				== 'Anti-Aim')
		ui.set_visible(manualForward, ui.get(mamytraxal) 			== 'Anti-Aim')
		
		--Visual
		ui.set_visible(arrowindicator, ui.get(mamytraxal) 			== 'Visual')
		ui.set_visible(color_pickerstrelki, ui.get(mamytraxal) 		== 'Visual')
		ui.set_visible(arrowdesynccolorlable, ui.get(mamytraxal) 	== 'Visual')
		ui.set_visible(color_pickerstrelki2, ui.get(mamytraxal) 	== 'Visual')
		ui.set_visible(blurmenu, ui.get(mamytraxal) 				== 'Visual')
		ui.set_visible(crosshairind, ui.get(mamytraxal) 			== 'Visual')
		ui.set_visible(weaponeblan, ui.get(mamytraxal) 				== 'Visual')
		ui.set_visible(knifeeblan, ui.get(mamytraxal) 				== 'Visual')
		ui.set_visible(fovin_scope, ui.get(mamytraxal) 				== 'Visual')
		ui.set_visible(master_switch1, ui.get(mamytraxal) 			== 'Visual')
		ui.set_visible(color_picker, ui.get(mamytraxal) 			== 'Visual')
		ui.set_visible(overlay_position, ui.get(mamytraxal) 		== 'Visual')
		ui.set_visible(overlay_offset, ui.get(mamytraxal) 			== 'Visual')
		ui.set_visible(aspect_ratio_reference, ui.get(mamytraxal)   == 'Visual')
		--misc
		ui.set_visible(clantagchanger, ui.get(mamytraxal)   		== 'Misc')
		ui.set_visible(model_check, ui.get(mamytraxal) 	 			== 'Misc')  
		ui.set_visible(localplayer_model_t, ui.get(mamytraxal) 	 	== 'Misc')  
		ui.set_visible(localplayer_model_ct, ui.get(mamytraxal) 	== 'Misc')
		
		--cfg SERVERS
		
		ui.set_visible(default_btn, ui.get(mamytraxal) 				== 'CFG & SERVERS')
		ui.set_visible(export_btn, ui.get(mamytraxal) 				== 'CFG & SERVERS')
		ui.set_visible(import_btn, ui.get(mamytraxal) 				== 'CFG & SERVERS')
		
		ui.set_visible(text1con, ui.get(mamytraxal) 				== 'CFG & SERVERS')
        ui.set_visible(Server1, ui.get(mamytraxal) 					== 'CFG & SERVERS')
        ui.set_visible(Server2, ui.get(mamytraxal) 					== 'CFG & SERVERS')
        ui.set_visible(Server3, ui.get(mamytraxal) 					== 'CFG & SERVERS')
        ui.set_visible(Server4, ui.get(mamytraxal) 					== 'CFG & SERVERS')
        ui.set_visible(Server5, ui.get(mamytraxal) 					== 'CFG & SERVERS')
		ui.set_visible(text2con, ui.get(mamytraxal) 				== 'CFG & SERVERS')
		ui.set_visible(reference.enableaa[1], false)
		ui.set_visible(reference.pitch[1], false)
        ui.set_visible(reference.pitch[2], false)
        ui.set_visible(reference.yaw_base, false)
        ui.set_visible(reference.yaw[1], false)
        ui.set_visible(reference.yaw[2], false)
        ui.set_visible(reference.yaw_jitter[1], false)
        ui.set_visible(reference.yaw_jitter[2], false)
        ui.set_visible(reference.body_yaw[1], false)
        ui.set_visible(reference.body_yaw[2], false)
        ui.set_visible(reference.freestanding_body_yaw, false)
        ui.set_visible(reference.edge_yaw, false)
        ui.set_visible(reference.freestanding[1], false)
        ui.set_visible(reference.freestanding[2], false)
        ui.set_visible(reference.roll, false)
	end
end)

local function eblantest()
		get_original_clantag()
		ui.set_visible(reference.enableaa[1], true)
		ui.set_visible(reference.pitch[1], true)
        ui.set_visible(reference.pitch[2], true)
        ui.set_visible(reference.yaw_base, true)
        ui.set_visible(reference.yaw[1], true)
        ui.set_visible(reference.yaw[2], true)
        ui.set_visible(reference.yaw_jitter[1], true)
        ui.set_visible(reference.yaw_jitter[2], true)
        ui.set_visible(reference.body_yaw[1], true)
        ui.set_visible(reference.body_yaw[2], true)
        ui.set_visible(reference.freestanding_body_yaw, true)
        ui.set_visible(reference.edge_yaw, true)
        ui.set_visible(reference.freestanding[1], true)
        ui.set_visible(reference.freestanding[2], true)
        ui.set_visible(reference.roll, true)
		
		ui.set_visible(hc_ref, true)
end

client.set_event_callback("shutdown", eblantest)

ui.set_callback(master_switch1, ebaniba)
ebaniba(master_switch1)


local weightsd = {}
local on_pre_render = function()
    local localplayer = entity.get_local_player()
    if not localplayer then return end
    if ui.get(slideranimbreak) == 0 then return end
    local localplayer_ptr = ffi.cast(class_ptr, native_GetClientEntity(localplayer))
    if localplayer_ptr == nullptr then return end

    local localplayer_adr = ffi.cast(char_ptr, localplayer_ptr)
    local animation_layers = ffi.cast(animation_layer_t, localplayer_adr + animation_layer)[0]
    if vector(entity.get_prop(localplayer, 'm_vecVelocity')):length() <= 4 then
        return
    end

    animation_layers[ui.get(slideranimbreak)].weight = client.random_float(0.1, 1)

    
    for i = 0, 24 do
        local animation_layer = animation_layers[i]
        weightsd[i] = animation_layer.weight
    end
end

client.set_event_callback('pre_render', on_pre_render)
print("cracked by dsc.gg/z0v")