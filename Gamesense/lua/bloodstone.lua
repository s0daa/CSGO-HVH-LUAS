local ui_reference = ui.reference
local refs = {
ragebot = {
   enabled = { ui_reference("RAGE", "Aimbot", "Enabled") },
   target_selection = ui_reference("RAGE", "Aimbot", "Target selection"),
   target_hitbox = ui_reference("RAGE", "Aimbot", "Target hitbox"),
   multipoint = { ui_reference("RAGE", "Aimbot", "Multi-point") },
   multipoint_scale = ui_reference("RAGE", "Aimbot", "Multi-point scale"),
   prefer_safepoint = ui_reference("RAGE", "Aimbot", "Prefer safe point"),
   force_safepoint = ui_reference("RAGE", "Aimbot", "Force safe point"),
   avoid_unsafe_hitboxes = ui_reference("RAGE", "Aimbot", "Avoid unsafe hitboxes"),
   automatic_fire = ui_reference("RAGE", "Other", "Automatic fire"),
   automatic_penetration = ui_reference("RAGE", "Other", "Automatic penetration"),
   silent_aim = ui_reference("RAGE", "Other", "Silent aim"),
   hitchance = ui_reference("RAGE", "Aimbot", "Minimum hit chance"),
   auto_scope = ui_reference("RAGE", "Aimbot", "Automatic scope"),
   reduce_aim_step = ui_reference("RAGE", "Other", "Reduce aim step"),
   maximum_fov = ui_reference("RAGE", "Other", "Maximum FOV"),
   log_misses_due_to_spread = ui_reference("RAGE", "Other", "Log misses due to spread"),
   low_fps_mitigations = ui_reference("RAGE", "Other", "Low FPS mitigations"),
   remove_recoil = ui_reference("RAGE", "Other", "Remove recoil"),
   accuracy_boost = ui_reference("RAGE", "Other", "Accuracy boost"),
   delay_shot = ui_reference("RAGE", "Other", "Delay shot"),
   quick_stop = { ui_reference("RAGE", "Aimbot", "Quick stop") },
   quick_stop_options = {ui_reference("RAGE", "Aimbot", "Quick stop")},
   quick_peek_assist = { ui_reference("RAGE", "Other", "Quick peek assist") },
   quick_peek_assist_mode = { ui_reference("RAGE", "Other", "Quick peek assist mode") },
   quick_peek_assist_distance = ui_reference("RAGE", "Other", "Quick peek assist distance"),
   resolver = ui_reference("RAGE", "Other", "Anti-aim correction"),
   --resolver_override = ui_reference("RAGE", "Other", "Anti-aim correction override"),
   prefer_body_aim = ui_reference("RAGE", "Aimbot", "Prefer body aim"),
   prefer_body_aim_disablers = ui_reference("RAGE", "Aimbot", "Prefer body aim disablers"),
   force_body_aim = ui_reference("RAGE", "Aimbot", "Force body aim"),
   force_body_aim_on_peek = ui_reference("RAGE", "Aimbot", "Force body aim on peek"),
   duck_peek_assist = ui_reference("RAGE", "Other", "Duck peek assist"),
   double_tap = { ui_reference("RAGE", "Aimbot", "Double tap") },
   --double_tap_mode = ui_reference("RAGE", "Aimbot", "Double tap mode"),
   double_tap_hitchance = ui_reference("RAGE", "Aimbot", "Double tap hit chance"),
   double_tap_fake_lag_limit = ui_reference("RAGE", "Aimbot", "Double tap fake lag limit"),
   double_tap_quick_stop = ui_reference("RAGE", "Aimbot", "Double tap quick stop")
   
},


antiaim = {
   enabled = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
   pitch = ui_reference("AA", "Anti-aimbot angles", "Pitch"),
   pitch_val = select(2, ui_reference("AA", "Anti-aimbot angles", "Pitch")),
   yaw_base = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
   yaw = { ui_reference("AA", "Anti-aimbot angles", "Yaw") },
   yaw_jitter = { ui_reference("AA", "Anti-aimbot angles", "Yaw jitter") } ,
   body_yaw = { ui_reference("AA", "Anti-aimbot angles", "Body yaw") },
   freestanding_body_yaw = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
   --fake_yaw_limit = ui_reference("AA", "Anti-aimbot angles", "Fake yaw limit"),
   edge_yaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
   freestanding = { ui_reference("AA", "Anti-aimbot angles", "Freestanding") },
   roll = ui_reference("AA", "Anti-aimbot angles", "Roll"),
   slow_motion = { ui_reference("AA", "Other", "Slow motion") },
   --slow_motion_type = ui_reference("AA", "Other", "Slow motion type"),
   leg_movement = ui_reference("AA", "Other", "Leg movement"),
   hide_shots = { ui_reference("AA", "Other", "On shot anti-aim") },
   fake_peek = { ui_reference("AA", "Other", "Fake peek") }

},

fakelag = {
   enabled = { ui_reference("AA", "Fake lag", "Enabled") },
   amount = ui_reference("AA", "Fake lag", "Amount"),
   variance = ui_reference("AA", "Fake lag", "Variance"),
   limit = ui_reference("AA", "Fake lag", "Limit")
},


visuals = {
   activation_type = ui_reference("VISUALS", "Player ESP", "Activation type"),
   teammates = ui_reference("VISUALS", "Player ESP", "Teammates"),
   dormant = ui_reference("VISUALS", "Player ESP", "Dormant"),
   box = { ui_reference("VISUALS", "Player ESP", "Bounding box") },
   health = ui_reference("VISUALS", "Player ESP", "Health bar"),
   name = ui_reference("VISUALS", "Player ESP", "Name"),
   flags = ui_reference("VISUALS", "Player ESP", "Flags"),
   weapon_text = ui_reference("VISUALS", "Player ESP", "Weapon text"),
   weapon_icon = { ui_reference("VISUALS", "Player ESP", "Weapon icon") },
   ammo = { ui_reference("VISUALS", "Player ESP", "Ammo") },
   distance = ui_reference("VISUALS", "Player ESP", "Distance"),
   glow = { ui_reference("VISUALS", "Player ESP", "Glow") },
   hit_marker = ui_reference("VISUALS", "Player ESP", "Hit marker"),
   hit_marker_sound = ui_reference("VISUALS", "Player ESP", "Hit marker sound"),
   visualize_aimbot = { ui_reference("VISUALS", "Player ESP", "Visualize aimbot") },
   visualize_aimbot_sp = { ui_reference("VISUALS", "Player ESP", "Visualize aimbot (safe point)") },
   visualize_sounds = { ui_reference("VISUALS", "Player ESP", "Visualize sounds") },
   line_of_sight = { ui_reference("VISUALS", "Player ESP", "Line of sight") },
   money = ui_reference("VISUALS", "Player ESP", "Money"),
   skeleton = { ui_reference("VISUALS", "Player ESP", "Skeleton") },
   out_of_fov_arrow = { ui_reference("VISUALS", "Player ESP", "Out of FOV arrow") },
   radar = ui_reference("VISUALS", "Other ESP", "Radar"),
   dropped_weapons = { ui_reference("VISUALS", "Other ESP", "Dropped weapons") },
   grenades = { ui_reference("VISUALS", "Other ESP", "Grenades") },
   inaccuracy_overlay = { ui_reference("VISUALS", "Other ESP", "Inaccuracy overlay") },
   recoil_overlay = ui_reference("VISUALS", "Other ESP", "Recoil overlay"),
   crosshair = ui_reference("VISUALS", "Other ESP", "Crosshair"),
   bomb = { ui_reference("VISUALS", "Other ESP", "Bomb") },
   grenade_trajectory = { ui_reference("VISUALS", "Other ESP", "Grenade trajectory") },
   grenade_trajectory_hit = ui_reference("VISUALS", "Other ESP", "Grenade trajectory (hit)"),
   grenade_proximity_warning = ui_reference("VISUALS", "Other ESP", "Grenade proximity warning"),
   spectators = ui_reference("VISUALS", "Other ESP", "Spectators"),
   penetration_reticle = ui_reference("VISUALS", "Other ESP", "Penetration reticle"),
   hostages = { ui_reference("VISUALS", "Other ESP", "Hostages") },
   shared_esp = { ui_reference("VISUALS", "Other ESP", "Shared ESP") },
   shared_esp_with_other_team = ui_reference("VISUALS", "Other ESP", "Shared ESP with other team"),
   restrict_shared_esp_updates = ui_reference("VISUALS", "Other ESP", "Restrict shared ESP updates"),
   upgrade_tablet = ui_reference("VISUALS", "Other ESP", "Upgrade tablet"),
   danger_zone_items = ui_reference("VISUALS", "Other ESP", "Danger Zone items"),
   drone_gun = { ui_reference("VISUALS", "Other ESP", "Drone gun") },
   blackhawk = { ui_reference("VISUALS", "Other ESP", "Blackhawk") },
   drone = { ui_reference("VISUALS", "Other ESP", "Drone") },
   random_case = { ui_reference("VISUALS", "Other ESP", "Random case") },
   tool_case = { ui_reference("VISUALS", "Other ESP", "Tool case") },
   pistol_case = { ui_reference("VISUALS", "Other ESP", "Pistol case") },
   explosive_case = { ui_reference("VISUALS", "Other ESP", "Explosive case") },
   heavy_weapon_case = { ui_reference("VISUALS", "Other ESP", "Heavy weapon case") },
   light_weapon_case = { ui_reference("VISUALS", "Other ESP", "Light weapon case") },
   dufflebag = { ui_reference("VISUALS", "Other ESP", "Dufflebag") },
   jammer = { ui_reference("VISUALS", "Other ESP", "Jammer") },
   ammobox = { ui_reference("VISUALS", "Other ESP", "Ammobox") },
   armor = { ui_reference("VISUALS", "Other ESP", "Armor") },
   parachute_pack = { ui_reference("VISUALS", "Other ESP", "Parachute pack") },
   briefcase = { ui_reference("VISUALS", "Other ESP", "Briefcase") },
   tablet_upgrade_zone = { ui_reference("VISUALS", "Other ESP", "Tablet upgrade zone") },
   tablet_upgrade_drone = { ui_reference("VISUALS", "Other ESP", "Tablet upgrade drone") },
   cash_stack = { ui_reference("VISUALS", "Other ESP", "Cash stack") },
   remove_flashbang_effects = ui_reference("VISUALS", "Effects", "Remove flashbang effects"),
   remove_smoke_grenades = ui_reference("VISUALS", "Effects", "Remove smoke grenades"),
   remove_fog = ui_reference("VISUALS", "Effects", "Remove fog"),
   remove_skybox = ui_reference("VISUALS", "Effects", "Remove skybox"),
   visual_recoil_adjustment = ui_reference("VISUALS", "Effects", "Visual recoil adjustment"),
   transparent_walls = ui_reference("VISUALS", "Effects", "Transparent walls"),
   transparent_props = ui_reference("VISUALS", "Effects", "Transparent props"),
   brightness_adjustment = { ui_reference("VISUALS", "Effects", "Brightness adjustment") },
   remove_scope_overlay = ui_reference("VISUALS", "Effects", "Remove scope overlay"),
   instant_scope = ui_reference("VISUALS", "Effects", "Instant scope"),
   disable_post_processing = ui_reference("VISUALS", "Effects", "Disable post processing"),
   force_third_person_alive = { ui_reference("VISUALS", "Effects", "Force third person (alive)") },
   force_third_person_dead = ui_reference("VISUALS", "Effects", "Force third person (dead)"),
   disable_rendering_of_teammates = ui_reference("VISUALS", "Effects", "Disable rendering of teammates"),
   disable_rendering_of_ragdolls = ui_reference("VISUALS", "Effects", "Disable rendering of ragdolls"),
   bullet_tracers = { ui_reference("VISUALS", "Effects", "Bullet tracers") },
   bullet_impacts = { ui_reference("VISUALS", "Effects", "Bullet impacts") }
},


misc = {
   override_fov = ui_reference("MISC", "Miscellaneous", "Override FOV"),
   override_zoom_fov = ui_reference("MISC", "Miscellaneous", "Override zoom FOV"),
   knifebot = { ui_reference("MISC", "Miscellaneous", "Knifebot") },
   zeusbot = ui_reference("MISC", "Miscellaneous", "Zeusbot"),
   automatic_weapons = { ui_reference("MISC", "Miscellaneous", "Automatic weapons") },
   reveal_competitive_ranks = ui_reference("MISC", "Miscellaneous", "Reveal competitive ranks"),
   reveal_overwatch_players = ui_reference("MISC", "Miscellaneous", "Reveal Overwatch players"),
   auto_accept_matchmaking = ui_reference("MISC", "Miscellaneous", "Auto-accept matchmaking"),
   clantag_spammer = ui_reference("MISC", "Miscellaneous", "Clan tag spammer"),
   log_weapon_purchases = ui_reference("MISC", "Miscellaneous", "Log weapon purchases"),
   log_damage_dealt = ui_reference("MISC", "Miscellaneous", "Log damage dealt"),
   automatic_grenade_release = { ui_reference("MISC", "Miscellaneous", "Automatic grenade release") },
   ping_spike = { ui_reference("MISC", "Miscellaneous", "Ping spike") } ,
   free_look = ui_reference("MISC", "Miscellaneous", "Free look"),
   persistent_killfeed = ui_reference("MISC", "Miscellaneous", "Persistent kill feed"),
   last_second_defuse = ui_reference("MISC", "Miscellaneous", "Last second defuse"),
   disable_sv_pure = ui_reference("MISC", "Miscellaneous", "Disable sv_pure"),
   --unlock_hidden_cvars = ui_reference("MISC", "Miscellaneous", "Unlock hidden cvars"),
   standalone_quick_stop = ui_reference("MISC", "Movement", "Standalone quick stop"),
   infinite_duck = ui_reference("MISC", "Movement", "Infinite duck"),
   easy_strafe = ui_reference("MISC", "Movement", "Easy strafe"),
   bunny_hop = ui_reference("MISC", "Movement", "Bunny hop"),
   air_strafe = ui_reference("MISC", "Movement", "Air strafe"),
   air_strafe_direction = ui_reference("MISC", "Movement", "Air strafe direction"),
   air_strafe_smoothing = ui_reference("MISC", "Movement", "Air strafe smoothing"),
   avoid_collisions = ui_reference("MISC", "Movement", "Avoid collisions"),
   zhop = { ui_reference("MISC", "Movement", "Z-Hop") },
   pre_speed = { ui_reference("MISC", "Movement", "Pre-speed") },
   no_fall_damage = { ui_reference("MISC", "Movement", "No fall damage") },
   air_duck = ui_reference("MISC", "Movement", "Air duck"),
   blockbot = { ui_reference("MISC", "Movement", "Blockbot") },
   jump_at_edge = { ui_reference("MISC", "Movement", "Jump at edge") },
   fast_walk = ui_reference("MISC", "Movement", "Fast walk"),
   menu_key = ui_reference("MISC", "Settings", "Menu key"),
   menu_color = ui_reference("MISC", "Settings", "Menu color"),
   dpi_scale = ui_reference("MISC", "Settings", "DPI scale"),
   anti_untrusted = ui_reference("MISC", "Settings", "Anti-untrusted"),
   hide_from_obs = ui_reference("MISC", "Settings", "Hide from OBS"),
   low_fps_warning = ui_reference("MISC", "Settings", "Low FPS warning"),
   lock_menu_layout = ui_reference("MISC", "Settings", "Lock menu layout"),
   sv_maxusrcmdprocessticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks2"),
   sv_clockcorrection_msecs =  ui.reference("MISC", "Settings", "sv_clockcorrection_msecs2") ,
   sv_maxusrcmdprocessticks_holdaim = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks_holdaim"),
   sv_maxunlag = ui_reference("MISC", "Settings", "sv_maxunlag2"),
   fix_viewmodel_lag = ui.reference("MISC", "Settings", "Fix viewmodel lag"),
   load_cfg = ui_reference("Config", "Presets", "Load"),
},

plist = {
   add_to_whitelist = ui_reference("Players", "Adjustments", "Add to whitelist"),
   player_list = ui_reference("Players", "Players", "Player list"),
   allow_shared_esp_updates = ui_reference("Players", "Adjustments", "Allow shared ESP updates"),
   disable_visuals = ui_reference("Players", "Adjustments", "Disable visuals"),
   high_priority = ui_reference("Players", "Adjustments", "High priority"),
   force_pitch = ui_reference("Players", "Adjustments", "Force pitch"),
   force_pitch_value = ui_reference("Players", "Adjustments", "Force pitch value"),
   force_body_yaw = ui_reference("Players", "Adjustments", "Force body yaw"),
   force_body_yaw_value = ui_reference("Players", "Adjustments", "Force body yaw value"),
   correction_active = ui_reference("Players", "Adjustments", "Correction active"),
   override_prefer_body_aim = ui_reference("Players", "Adjustments", "Override prefer body aim"),
   override_safe_point = ui_reference("Players", "Adjustments", "Override safe point"),
   reset_all = ui_reference("PLAYERS", "Players", "Reset all"),
   apply_to_all = ui_reference("Players", "Adjustments", "Apply to all"),
} -- references in one local


}
refs.ragebot.minimum_damage = ui.reference("RAGE", "Aimbot", "Minimum damage")
refs.ragebot.minimum_damage_override = { ui.reference("RAGE", "Aimbot", "Minimum damage override") }
local cfg_data = {
   ints = {},
   text = {},
   array = {},
   colors = {},
   keys = {}
}

local ffi = require("ffi")
local ffi_new, ffi_cast, ffi_cdef, ffi_typeof = ffi.new, ffi.cast, ffi.cdef, ffi.typeof

local render = {}

local bit = require 'bit'
local vector = require "vector"
local csgo_weapons = require "gamesense/csgo_weapons"
local antiaim_funcs  = require "gamesense/antiaim_funcs"
local base64 = require "gamesense/base64"
local surface = require 'gamesense/surface'
local clipboard = require 'gamesense/clipboard'
local entity_lib = require 'gamesense/entity'

local table = {sort = table.sort, remove = table.remove, concat = table.concat, insert = table.insert, unpack  = table.unpack}

local jmp_ecx = client.find_signature("engine.dll", "\xFF\xE1")
local GetModuleHandle_sig = client.find_signature("engine.dll", "\xFF\x15\xCC\xCC\xCC\xCC\x85\xC0\x74\x0B")
local GetModuleHandle_casted = ffi_cast("uint32_t**", ffi_cast("uint32_t", GetModuleHandle_sig) + 2)[0][0]
local GetModuleHandle = ffi_cast("uint32_t(__fastcall*)(unsigned int, unsigned int, const char*)", jmp_ecx)
local client_dll = GetModuleHandle(GetModuleHandle_casted, 0, "client.dll")
local cinput_offset = ffi_cast("uintptr_t", client_dll) + 0x1f51ee
local gamerules_offset = ffi_cast("uintptr_t", client_dll) + 0x192273
local gamerules = ffi_cast("intptr_t**", ffi.cast("intptr_t", client.find_signature("client.dll", "\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1")) + 2)[0]

label = ui.new_label("AA", "Anti-aimbot angles", "BLOODSTONE.LUA ~ DOMINATE YOUR OPPONENTS")
label = ui.new_label("AA", "Anti-aimbot angles", " ")
label = ui.new_label("AA", "Anti-aimbot angles", "\aA8BDFFFFLast update: \aFFFFFFFF06.07.23")
label = ui.new_label("AA", "Anti-aimbot angles", "Сurrent build: \aA8BDFFFFDebug")
--label = ui.new_label("AA", "Anti-aimbot angles", "User: " .. credentials.username)
label = ui.new_label("AA", "Anti-aimbot angles", " ")

local lua_tabs = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFF Section", {"Anti-aim", "Visual", "Misc","Config & Support"})

table.insert(cfg_data.text,lua_tabs)
local var = {
player_pos = { --anti-aim state names
   "Global",
   "Stand",
   "Walking",
   "Slow walk",
   "Air",
   "Crouch",
   "Freestand",
   "Breaking LC",
   "Manuals",
   "Air-c",
   "On peek",
   "Vulnerable",
   "Height advantage",
   "Height disadvantage",
   "Defensive",
   "Dormant",
   "Round end",
   "Knife",
  --Warm up,
  --Pre-round,
  -- "Anti-Knife",
  -- "Anti-Zeus",
   "On-key"
},
timetoswich = 0,

state_to_idx = { --anti-aim states
   ["Global"] = 1,
   ["Stand"] = 2,
   ["Walking"] = 3,
   ["Slow walk"] = 4,
   ["Air"] = 5,
   ["Crouch"] = 6,
   ["Freestand"] = 7,
   ["Breaking LC"] = 8,
   ["Manuals"] = 9,
   ["Air-c"] = 10,
   ["On peek"] = 11,
   ["Vulnerable"] = 12,
   ["Height advantage"] = 13,
   ["Height disadvantage"] = 14,
   ["Defensive"] = 15,
   ["Dormant"] = 16,
   ["Round end"] = 17,
   ["Knife"] = 18,
   --["Anti-Knife"] = 19,
   --["Anti-Zeus"] = 20,
   ["On-key"] = 19
},
aa_dir = 0,
aa_dir_last = 0,
active_i = 1,
p_state = 1,
p_state_before_defensive = 1,
manual_dir = "back",
classnames = {"CWorld","CCSPlayer","CFuncBrush"},
was_quick_peek = false,
fakelag_old = 15,
left_ready = true,
forward_ready = true,
right_ready = true,
last_press_t = 9,
way5= {1, 0, 0.5, -0.5, -1},
way3 =  {1, 0, -1 } ,
way3_rev =  {0, 1, 0, -1} ,

tick_now = 0,
is_mm_state = 0,
tickbase = 0,
defensive = 0,
drop_nades_once = true,
drop_n_tick = 0,
drop_n_tick_next = 0,

cache = {
   data = {
       last_sim_time = sim_time,
       defensive_active_until = 0,
       defensive_active = false,
       defensive_active_before = false,
       defensive_work_now = 0

   }
}

}

local return_fl = return_fl
local anti_aim = {}
   anti_aim[0] = {
       anti_aim_mode = ui.new_combobox("AA","Anti-aimbot angles","\aFFFFFFFF Anti-Aim mode",{"Jitter","Custom",}),
       aa_ditionals = ui.new_multiselect("AA", "Anti-aimbot angles","Anti-Aim additionals",{"Freestand","Edge Yaw","Manual"}),
       freestand = {ui.new_checkbox("AA", "Anti-aimbot angles", "Freestanding\n"),ui.new_hotkey("AA", "Anti-aimbot angles", "Freestanding key", true),},
       edge = {ui.new_checkbox("AA", "Anti-aimbot angles", "Edge yaw\n"), ui.new_hotkey("AA", "Anti-aimbot angles", "Edge yaw key", true),},
       manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual left"),
       manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual right"),
       manual_forward = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual forward"),
       player_state = ui.new_combobox("AA", "Anti-aimbot angles", "Custom mode", var.player_pos),
   }

   table.insert(cfg_data.text,anti_aim[0].anti_aim_mode)
   table.insert(cfg_data.text,anti_aim[0].player_state)

       
   local misc_expoloit = ui.new_combobox('AA', 'Anti-aimbot angles', '\n', {'Main Misc', 'Exploit Misc'})    

   local v_left, v_right = vector(0, 0, 0), vector(0, 0, 0)
    var.l_dmg, var.r_dmg, var.c_dmg = 0, 0, 0




    local vulnerable_ticks = 0
    local function is_vulnerable()
        for _, v in ipairs(entity.get_players(true)) do
            local flags = (entity.get_esp_data(v)).flags
    
            if bit.band(flags, bit.lshift(1, 11)) ~= 0 then
                
                vulnerable_ticks = vulnerable_ticks + 1
                return true
            end
        end
    
        vulnerable_ticks = 0
        return false
    end

local function vector_angles(start_x, start_y, start_z, dest_x, dest_y, dest_z)
  local origin_x, origin_y, origin_z
   local target_x, target_y, target_z
   if dest_x == nil then
       target_x, target_y, target_z = start_x, start_y, start_z
       origin_x, origin_y, origin_z = client.eye_position()
       if origin_x == nil then
           return
       end
   else
       origin_x, origin_y, origin_z = start_x, start_y, start_z
       target_x, target_y, target_z = dest_x, dest_y, dest_z
   end

   local delta_x, delta_y, delta_z = target_x-origin_x, target_y-origin_y, target_z-origin_z

   if delta_x == 0 and delta_y == 0 then
       return 0, (delta_z > 0 and 270 or 90)
   else
       local yaw = math.deg(math.atan2(delta_y, delta_x))

       local hyp = math.sqrt(delta_x*delta_x + delta_y*delta_y)
       local pitch = math.deg(math.atan2(-delta_z, hyp))

       return pitch, yaw
   end
end

function angle_right( angle ) -- angle -> direction vector (right)
   local sin_pitch = math.sin( math.rad( angle.x ) );
   local cos_pitch = math.cos( math.rad( angle.x ) );
   local sin_yaw   = math.sin( math.rad( angle.y ) );
   local cos_yaw   = math.cos( math.rad( angle.y ) );
   local sin_roll  = math.sin( math.rad( angle.z ) );
   local cos_roll  = math.cos( math.rad( angle.z ) );

   return vector(
       -1.0 * sin_roll * sin_pitch * cos_yaw + -1.0 * cos_roll * -sin_yaw,
       -1.0 * sin_roll * sin_pitch * sin_yaw + -1.0 * cos_roll * cos_yaw,
       -1.0 * sin_roll * cos_pitch)
   
end

for i = 1, 19 do
anti_aim[i] = {
   enable = i == 19 and
   ui.new_hotkey("AA","Anti-aimbot angles","Enable " .. string.lower(var.player_pos[i]) .. " anti-aim ",false,"0x45") or	ui.new_checkbox("AA", "Anti-aimbot angles", "Enable " .. string.lower(var.player_pos[i]) .. " anti-aim"),
   pitch = ui.new_combobox("AA","Anti-aimbot angles","Pitch\n" .. var.player_pos[i],{"Off", "Default", "Up", "Down", "Minimal", "Random", "Custom"}),
   pitch_val = ui.new_slider("AA","Anti-aimbot angles","\nPitch" .. var.player_pos[i],-89,89,0,true, "°"),
   yawbase = ui.new_combobox("AA","Anti-aimbot angles","Yaw base\n" .. var.player_pos[i],{"Local view", "At targets"}),
   yaw = ui.new_combobox("AA","Anti-aimbot angles","Yaw\n" .. var.player_pos[i],{"Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
   yawadd_l = ui.new_slider("AA", "Anti-aimbot angles", " " .. var.player_pos[i].. " [L]", -180, 180, 0),
   yawadd_r = ui.new_slider("AA", "Anti-aimbot angles", " " .. var.player_pos[i] ..  " [R]", -180, 180, 0),
   yaw_xway = ui.new_combobox("AA","Anti-aimbot angles","Yaw X-Way\n" .. var.player_pos[i],{"None","3 Way (offset)","4 Way (offset)","5 Way (offset)","Custom 3 Way","Custom 4 Way","Custom 5 Way", "Delayed Switch Yaw"}),
   yaw_xway_desync = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw Switch Desync Modifier\n" .. var.player_pos[i] ,{"None","Default","Invert","Agressive (Positive)","Agressive (Negative)","VDEF","VINV" }),

  
   yaw_xway_delay = ui.new_slider("AA", "Anti-aimbot angles", "Yaw Switch Delay\n " .. var.player_pos[i] , 1, 64, 1),


   yaw_sliderways = {
   w1=ui.new_slider("AA", "Anti-aimbot angles", " " .. var.player_pos[i].. " Way [1]", -180, 180, 0),
   w2=ui.new_slider("AA", "Anti-aimbot angles", " " .. var.player_pos[i].. " Way [2]", -180, 180, 0),
   w3=ui.new_slider("AA", "Anti-aimbot angles", " " .. var.player_pos[i].. " Way [3]", -180, 180, 0),
   w4=ui.new_slider("AA", "Anti-aimbot angles", " " .. var.player_pos[i].. " Way [4]", -180, 180, 0),
   w5=ui.new_slider("AA", "Anti-aimbot angles", " " .. var.player_pos[i].. " Way [5]", -180, 180, 0)},
   yaw_tickbase_def = ui.new_checkbox("AA", "Anti-aimbot angles", var.player_pos[i] .. " Priority Defensive AA\n"),
   yaw_tickbase_def_method = ui.new_combobox("AA","Anti-aimbot angles","Defensive Method\n" .. var.player_pos[i],{"Default", "Always on", "Airtick switcher", "Switch cycle", "Random yaw","Random yaw + force" ,"Second Pitch"}),
   yaw_tickbase_def_mode = ui.new_combobox("AA","Anti-aimbot angles","Defensive Mode\n" .. var.player_pos[i],{"Default", "Sensitive", "Delimiter"}),
   yaw_tickbase_def_ping_related = ui.new_checkbox("AA","Anti-aimbot angles","Ping related\n" .. var.player_pos[i]),
   

  -- yaw_tickbase_def_mode_sen_start = ui.new_combobox("AA","Anti-aimbot angles","Start - Sensitive \n" .. var.player_pos[i],0,14,0,true, nil, 1, {[0] = "First Tick"}),
   yaw_tickbase_def_mode_sen_end = ui.new_slider("AA","Anti-aimbot angles","End - Sensitive \n" .. var.player_pos[i],0,16,4,true, nil, 1, {[0] = "Last Tick"}),
   yaw_tickbase_def_mode_del_slider = ui.new_slider("AA","Anti-aimbot angles","Delimiter \n" .. var.player_pos[i],2,10,2),
   yaw_tickbase_def_mode_pitch1 = ui.new_slider("AA","Anti-aimbot angles","Pitch 1 \n" .. var.player_pos[i],-89,89,0),
   yaw_tickbase_def_mode_pitch2 = ui.new_slider("AA","Anti-aimbot angles","Pitch 2 \n" .. var.player_pos[i],-89,89,0),
   

   yawjitter = ui.new_combobox("AA","Anti-aimbot angles","Yaw jitter\n" .. var.player_pos[i],{"Off", "Offset", "Center", "Random", "Skitter"}),
   yawjitteradd = ui.new_slider("AA","Anti-aimbot angles","\nYaw jitter add" .. var.player_pos[i],-180,180,0),
   gs_bodyyaw = ui.new_combobox("AA","Anti-aimbot angles","Body yaw\n GS" .. var.player_pos[i],{"Off", "Opposite", "Jitter", "Static"}),
   gs_bodyyawadd = ui.new_slider("AA","Anti-aimbot angles","\nBody yaw add" .. var.player_pos[i],-180,180,0),
   gs_freestanding_body = ui.new_checkbox("AA","Anti-aimbot angles","Freestanding body yaw\n GS" .. var.player_pos[i]),

   roll_sk = ui.new_slider("AA","Anti-aimbot angles","Roll Skeet\n" .. var.player_pos[i],-45,45,0,true,"%"),
   roll_enabled = ui.new_checkbox("AA", "Anti-aimbot angles", var.player_pos[i] .. " Roll AA\n"),
   roll_enabled_hk = ui.new_hotkey("AA", "Anti-aimbot angles", var.player_pos[i] .. "Roll Hotkey", true),
   roll_inverter = ui.new_hotkey("AA", "Anti-aimbot angles", var.player_pos[i] .. " Roll inverter"),


}
end

anti_aim[20] = {
   custom_resolver = ui.new_checkbox("AA", "Anti-aimbot angles",  "AnimBreak Resolver [beta]"),
   anti_knifebot = ui.new_checkbox("AA", "Anti-aimbot angles",  "Anti-Knifebot"),
   dt_teleport = ui.new_hotkey("AA", "Anti-aimbot angles",  "DT Teleport"),
   dt_teleport_opts = ui.new_multiselect("AA", "Anti-aimbot angles",  "DT Teleport options", {"Velocity","Damage","Once","Delay"}),
   dt_teleport_damage_opts = ui.new_combobox("AA", "Anti-aimbot angles",  "DT Teleport options", {"local","enemy"}),
   dt_teleport_damage_slider = ui.new_slider("AA", "Anti-aimbot angles",  " TP damage", 0, 101, 15, true, 'hp', 1, {[101] = "Lethal"}),
   dt_teleport_delay_opts = ui.new_multiselect("AA", "Anti-aimbot angles",  "DT Delay options", {"Delay ticks","Local Ping","Enemy ping"}),
   dt_teleport_delay_slider = ui.new_slider("AA", "Anti-aimbot angles",  " TP delay", 1, 64, 6, true, 't'),
   dt_teleport_velocity_slider = ui.new_slider("AA", "Anti-aimbot angles",  " TP velocity", 0, 300, 150, true, 'u/s'),
   anti_knifebot_slider = ui.new_slider("AA", "Anti-aimbot angles","Minimum distance", 0, 1500, 600, true, nil, 1, { }),
   anti_knifebot_pistal = ui.new_checkbox("AA", "Anti-aimbot angles",  "Anti-Knifebot Pistol"),
   anti_knifebot_pistal_slider = ui.new_slider("AA", "Anti-aimbot angles","Health", 0, 100,75, true, nil, 1, { }),
   visual_dmg = ui.new_checkbox("AA", "Anti-aimbot angles",  "Predict Damage"),
   visual_dmg_safe = ui.new_checkbox("AA", "Anti-aimbot angles",  "Predict Damage Safepoint"),


}
   table.insert(cfg_data.ints,anti_aim[20].custom_resolver          )
   table.insert(cfg_data.ints,anti_aim[20].anti_knifebot          )
   table.insert(cfg_data.text,anti_aim[20].dt_teleport_opts          )
   table.insert(cfg_data.text,anti_aim[20].dt_teleport_damage_opts          )
   table.insert(cfg_data.text,anti_aim[20].dt_teleport_delay_opts          )
   table.insert(cfg_data.ints,anti_aim[20].dt_teleport_damage_slider          )
   table.insert(cfg_data.ints,anti_aim[20].dt_teleport_delay_slider          )
   table.insert(cfg_data.ints,anti_aim[20].dt_teleport_velocity_slider          )
   
   table.insert(cfg_data.ints,anti_aim[20].anti_knifebot_pistal          )
   table.insert(cfg_data.ints,anti_aim[20].anti_knifebot_slider   )
   table.insert(cfg_data.ints,anti_aim[20].anti_knifebot_pistal_slider   )
   table.insert(cfg_data.ints,anti_aim[20].visual_dmg   )
   table.insert(cfg_data.ints,anti_aim[20].visual_dmg_safe   )



for i = 1, 19 do
if i == 19 then 
   table.insert(cfg_data.keys,anti_aim[i].enable)
   else 
   table.insert(cfg_data.ints,anti_aim[i].enable)
   end
 table.insert(cfg_data.text,  anti_aim[i].pitch )
 table.insert(cfg_data.text,  anti_aim[i].pitch_val )
 table.insert(cfg_data.text,  anti_aim[i].yawbase )
 table.insert(cfg_data.text,  anti_aim[i].yaw )
 table.insert(cfg_data.ints,  anti_aim[i].yawadd_l )
 table.insert(cfg_data.ints,  anti_aim[i].yawadd_r )
 table.insert(cfg_data.text,  anti_aim[i].yaw_xway )
 table.insert(cfg_data.text,  anti_aim[i].yaw_xway_desync )
   table.insert(cfg_data.text,  anti_aim[i].yaw_xway_delay )

 
 

 
 table.insert(cfg_data.ints,  anti_aim[i].yaw_sliderways.w1 )
 table.insert(cfg_data.ints,  anti_aim[i].yaw_sliderways.w2 )
 table.insert(cfg_data.ints,  anti_aim[i].yaw_sliderways.w3 )
 table.insert(cfg_data.ints,  anti_aim[i].yaw_sliderways.w4 )
 table.insert(cfg_data.ints,  anti_aim[i].yaw_sliderways.w5 )

 table.insert(cfg_data.text,  anti_aim[i].yawjitter )
 table.insert(cfg_data.ints,  anti_aim[i].yawjitteradd )
 table.insert(cfg_data.text,  anti_aim[i].gs_bodyyaw )
 table.insert(cfg_data.ints,  anti_aim[i].gs_bodyyawadd )
 table.insert(cfg_data.ints,  anti_aim[i].gs_freestanding_body )

 table.insert(cfg_data.ints,  anti_aim[i].roll_sk )
 table.insert(cfg_data.ints,  anti_aim[i].roll_enabled )
 table.insert(cfg_data.keys,  anti_aim[i].roll_enabled_hk )
 table.insert(cfg_data.keys,  anti_aim[i].roll_inverter  )

end
local function clamp360 (x) 
   if x == nil then return 0 end
   x = (x % 360 + 360) % 360 return x > 180 and x - 360 or x 
   end
local function clamp(min, max, value)
   if value > max then
       return max
   elseif value < min then
       return min
   else
       return value
   end
end




local vars = {
   ref = {
       aimbot = ui.reference("RAGE", "Aimbot", "Enabled"),

       dt = ui.reference("RAGE", "Aimbot", "Double tap"),
       dt_key = select(2, ui.reference("RAGE", "Aimbot", "Double tap")),

       flags = ui.reference("VISUALS", "Player ESP", "Flags"),
   },
   globals = {
       local_vulnerable = nil,
       tickbase = nil,
       
       charged = false,

       data = {},
       index = 1,
   },
}

local func = {
   update_vulnerable_state = function(local_player)
       local th = client.current_threat()

       if th == nil then 
           vars.globals.local_vulnerable = false 
           return 
       end

       if ui.get(vars.ref.flags) then 
           vars.globals.local_vulnerable = (bit.band(entity.get_esp_data(th).flags, bit.lshift(1, 11)) == 2048) 
           return
       else
           if entity.is_dormant(th) then 
               vars.globals.local_vulnerable = false 
               return 
           end

           local start_pos = {entity.hitbox_position(th, 0)}
           local end_pos = {entity.get_prop(local_player, "m_vecOrigin")}
           end_pos[3] = end_pos[3] + 32

           local _, dmg = client.trace_bullet(th, start_pos[1], start_pos[2], start_pos[3], end_pos[1], end_pos[2], end_pos[3], false)

           vars.globals.local_vulnerable = dmg > 1
       end
   end,
   weapon_can_fire = function(ent)
       local active_weapon = entity.get_prop(ent, "m_hActiveWeapon")
       local nextAttack = entity.get_prop(active_weapon, "m_flNextPrimaryAttack")
       return globals.curtime() >= nextAttack
   end,
}

client.set_event_callback('net_update_end', function()
   local local_player = entity.get_local_player()
   if local_player == nil then return end 

   if vars.globals.tickbase == nil then
       vars.globals.tickbase = entity.get_prop(local_player, 'm_nTickBase')
       return
   end

   local current_tickbase = entity.get_prop(local_player, 'm_nTickBase')

   vars.globals.data[vars.globals.index] = current_tickbase - vars.globals.tickbase
   vars.globals.index = vars.globals.index + 1
   vars.globals.index = vars.globals.index % 16

   vars.globals.charged = false 

   for i=1, 15 do 
      if vars.globals.data[i] ~= nil and vars.globals.data[i] < 0 then
           vars.globals.charged = true
           return
      end
   end

   if vars.globals.charged == false and antiaim_funcs.get_tickbase_shifting() > 0 then
       vars.globals.charged = true
   end

   vars.globals.tickbase = current_tickbase
end)

client.set_event_callback("setup_command", function(e)
   local local_player = entity.get_local_player()
   if local_player == nil then return end 

   if bit.band(entity.get_prop(local_player, "m_fFlags"), 1) == 1 then 
       ui.set(vars.ref.aimbot, true) 
       return 
   end

   func.update_vulnerable_state(local_player)
       
   if not ui.get(vars.ref.dt) or not ui.get(vars.ref.dt_key) or vars.globals.local_vulnerable == false then
       ui.set(vars.ref.aimbot, true) 
       return 
   end
   
   local weapon = entity.get_player_weapon(local_player)

   if weapon == nil then 
       ui.set(vars.ref.aimbot, true) 
       return 
   end

   if func.weapon_can_fire(local_player) and entity.get_classname(weapon) == 'CKnife' then 
       ui.set(vars.ref.aimbot, true)
   end
   
   ui.set(vars.ref.aimbot, vars.globals.charged) 
end)

client.set_event_callback("shutdown", function()
   ui.set(vars.ref.aimbot, true) 
end)



local ents = {

}

local function contains(table, value)
   if table == nil then
       return false
   end
   table = ui.get(table)
   for i = 0, #table do
       if table[i] == value then
           return true
       end
   end
   return false
end

local tp_text = ''
local tp_key_toggled = false
local tp_key_charged = false

local last_teleport_state = globals.tickcount()
local get_ping = function(player_resource, ent) return entity.get_prop(player_resource, string.format('%03d', ent)) end
local function on_paint2(cmd)
   --print(ui.get(refs.ragebot.delay_shot))
   if ui.get(anti_aim[20].dt_teleport) then
       tp_key_toggled = true
       tp_key_charged = false
       local velocity = vector(entity.get_prop(entity.get_local_player(), "m_vecVelocity"))
       local speed = velocity:length2d()
       local origin = vector(entity.get_origin(entity.get_local_player()));
       local animstate = entity_lib(entity.get_local_player()):get_anim_state();
       local need_dmg = ui.get(anti_aim[20].dt_teleport_damage_slider)

       
         

       local enemy = client.current_threat()
       if enemy ~= nil  then  
           local enemy_health = entity.get_prop(enemy, "m_iHealth")
           local local_health = entity.get_prop(entity.get_local_player(), "m_iHealth")
           local ping_enemy = toticks((get_ping(entity.get_all('CCSPlayerResource')[1], enemy))/1000)
         
           local ping_local = toticks(client.latency())
           local prd_dmg = 0
         
           local raw_value = false
           if contains(anti_aim[20].dt_teleport_opts,"damage") then
                   -- Damage check 
                   if need_dmg == 101 then
                       -- lethal check
                           if  ui.get(anti_aim[20].dt_teleport_damage_opts)   == 'local' then
                           prd_dmg = local_health
                           else
                           -- if enemy 
                           prd_dmg = enemy_health
                           end
                       tp_text = 'Teleport: '..prd_dmg
                   else
                       -- when damage > value
                       prd_dmg = need_dmg
                       tp_text = 'Teleport: '..prd_dmg
                   end
                   -- damage calc
                   if contains(anti_aim[20].dt_teleport_opts,"Once") then
                       raw_value = (var.l_dmg > prd_dmg or var.r_dmg  > prd_dmg)
                   else
                       raw_value = (var.l_dmg > prd_dmg or var.r_dmg > prd_dmg or var.c_dmg > prd_dmg)
                   end
           else
               tp_text = 'Teleport: HIT'
               raw_value = is_vulnerable()
           end
           can_teleport = false
           if contains(anti_aim[20].dt_teleport_opts,"delay") then
               if raw_value then
                   -- Delay teleport (ticks diff)
                   
               d_l =   contains(anti_aim[20].dt_teleport_delay_opts,"Local Ping") and ping_local or 0
               d_e = contains(anti_aim[20].dt_teleport_delay_opts,"Enemy ping")  and ping_enemy or 0
               d_t = contains(anti_aim[20].dt_teleport_delay_opts,"Delay ticks")  
               -- time - ticks - local ping + enemy ping > last time
               -- 100 > 120 - 30 - 3 + 5 = > 
               and (globals.tickcount() - ui.get(anti_aim[20].dt_teleport_delay_slider) - d_l + d_e) > last_teleport_state   or 
               (globals.tickcount()  - d_l + d_e) > last_teleport_state  
               if d_t then
                   can_teleport = true
               end
               else
                   -- Delay teleport (update)
                   last_teleport_state = globals.tickcount()
               end
           else
               can_teleport = true
           end
   


           -- Velocity checker ( local)
           if contains(anti_aim[20].dt_teleport_opts,"Velocity") then   
           vel_state = speed > ui.get(anti_aim[20].dt_teleport_velocity_slider) 
           else
           vel_state = true
           end

          if can_teleport and vel_state then
                   tp_key_charged = true
                   if raw_value then
                   cmd.force_defensive = true
                   --cmd.allow_shift_tickbase = true
                  if vars.globals.charged then
                       cmd.allow_send_packet = true
                       --cmd.no_choke = true
                      cmd.discharge_pending = true
                     -- last_teleport_state = globals.tickcount()
                  end
               end
           end


       
       
       end
   
   else
       tp_key_toggled = false
   end
end
local function on_paint(context)
   local local_player = entity.get_local_player()
       

   if local_player == nil or not entity.is_alive(local_player) then
       return
   end

   if  tp_key_toggled then
      
       renderer.indicator(255, 255, 255, 255, tp_text) 
       elseif  tp_key_toggled and tp_key_charged then
       renderer.indicator(100, 100, 100, 100, tp_text) 
       end

       
   if not ui.get(anti_aim[20].visual_dmg) then return end
  
      local show_safe  = ui.get(anti_aim[20].visual_dmg_safe)	

     
  
      local v_origin_local = vector(entity.get_prop(local_player, "m_vecAbsOrigin"))
      if v_origin_local.x == nil then
          return
      end
  
      local v_eye_local = vector(client.eye_position())
      if v_eye_local.x == nil then
          return
      end
  
      if v_left == nil or v_right == nil then
          return
      end
  

      if var.c_dmg > 0 then
       local xc, yc = renderer.world_to_screen(v_eye_local.x, v_eye_local.y, v_eye_local.z)
           if xc ~= nil then
               renderer.text(xc, yc - 35, 255, 0, 0, 255, "bc", 0, "HIT")
           end
       return
   end


      
      local xl, yl = renderer.world_to_screen(v_left.x, v_left.y, v_left.z)
      local xr, yr = renderer.world_to_screen(v_right.x, v_right.y, v_right.z)
      
      if xl ~= nil and yl ~= nil then
          if var.l_dmg > 0 then
              renderer.text(xl, yl - 25, 255, 165, 0, 255, "bc", 0, "L " .. var.l_dmg)
          elseif show_safe == true then
              renderer.text(xl, yl - 25, 0, 255, 0, 255, "bc", 0, "L")
          end
      end
  

      if xr ~= nil and xl ~= nil then
          if var.r_dmg > 0 then
              renderer.text(xr, yr - 25, 255, 165, 0, 255, "bc", 0, "R " .. var.r_dmg)
          elseif show_safe == true then
              renderer.text(xr, yr - 25, 0, 255, 0, 255, "bc", 0, "R")
          end
      end


      
  end
  
  local function run_command(context)
  
      var.l_dmg, var.r_dmg, var.c_dmg = 0, 0, 0
  
      local local_player = entity.get_local_player()
      if local_player == nil or not entity.is_alive(local_player) then
          return
      end
  
      local v_origin_local = vector(entity.get_prop(local_player, "m_vecAbsOrigin"))
      if v_origin_local.x == nil then
          return
      end
  
      local v_eye_local = vector(client.eye_position())
      if v_eye_local.x == nil then
          return
      end
  
  
      local closestplayer = client.current_threat()
      local pitch, yaw, roll = client.camera_angles()
      local cam_angle = vector(0, yaw, 0)
  
   
  
      local v_origin_enemy = vector(entity.get_prop(closestplayer, "m_vecOrigin"))
  
      local at_pitch, at_yaw = vector_angles(v_origin_local.x, v_origin_local.y, v_origin_local.z, v_origin_enemy.x, v_origin_enemy.y, v_origin_enemy.z)
  
      cam_angle = vector(at_pitch, at_yaw, 0)
  
      if closestplayer ~= nil then
          local v_viewoffset_enemy = vector(entity.get_prop(closestplayer, "m_vecViewOffset"))
  
          local v_eye_enemy = v_origin_enemy + v_viewoffset_enemy
  
          local l_id, r_id, c_id = 0, 0		
          o_scan_fineness = 6+toticks(client.latency())*5
         -- print('o_scan_fineness:'..o_scan_fineness)
          local l_add, r_add = o_scan_fineness, o_scan_fineness
          local a_left = -angle_right(cam_angle)
          local a_right = angle_right(cam_angle)
  
          v_left = v_eye_local + a_left * l_add
          v_right = v_eye_local + a_right * r_add
          
          local v_head_local_x, v_head_local_y, v_head_local_z = entity.hitbox_position(local_player, 0)
  
          c_id, var.c_dmg = client.trace_bullet(closestplayer, v_eye_enemy.x, v_eye_enemy.y, v_eye_enemy.z, v_head_local_x, v_head_local_y, v_head_local_z)
  
          if var.c_dmg > 0 then
              return
          end
          o_scan_length = 20+toticks(client.latency())*13
         -- print('o_scan_length:'..o_scan_length)
          while var.l_dmg < 1 and l_add < o_scan_length do
              v_left = v_eye_local + a_left * l_add
              l_id, var.l_dmg = client.trace_bullet(closestplayer, v_eye_enemy.x, v_eye_enemy.y, v_eye_enemy.z, v_left.x , v_left.y, v_left.z)
              l_add = l_add + o_scan_fineness
          end
  
          while var.r_dmg < 1 and r_add < o_scan_length do
              v_right = v_eye_local + a_right * r_add
              r_id, var.r_dmg = client.trace_bullet(closestplayer, v_eye_enemy.x, v_eye_enemy.y, v_eye_enemy.z, v_right.x , v_right.y, v_right.z)
              r_add = r_add + o_scan_fineness
          end		
      end
  end
  
  client.set_event_callback("run_command", run_command)
  client.set_event_callback("paint", on_paint)
  client.set_event_callback("setup_command", on_paint2)
  
  

local menu = {
   indicators = 'Indicators',
   c_indicators = 'Indicators (centered)',
   getstyle = {},
   gettype = {},    
   }
   menu.type = ui.new_combobox('AA', 'Anti-aimbot angles', 'Indicator Type', {'Default skeet', 'Centered', 'Both'})
   menu.style = ui.new_combobox('AA', 'Anti-aimbot angles', 'Indicator Style', {'Modern','Minimalistic'})
   local bs_ind_fist_color = ui.new_color_picker("AA", "Anti-aimbot angles", "Bs colorpicker", 255, 255, 255,255)
   local bs_ind_second_color = ui.new_color_picker("AA", "Anti-aimbot angles", "Lua color colorpicker", 130, 165, 255, 255)
   menu.chosez = ui.new_multiselect('AA', 'Anti-aimbot angles', 'Indicator Selection', {'Doubletap','Onshot','Dormant','Baim','Freestand','Safe','Damage','Ping','Fake Duck','Ideal Tick'})


   table.insert(cfg_data.colors,bs_ind_fist_color)
   table.insert(cfg_data.colors,bs_ind_second_color)
   
   table.insert(cfg_data.text,menu.style)
   table.insert(cfg_data.text,menu.type)
   table.insert(cfg_data.text,menu.chosez)

   table.insert(cfg_data.ints,bs_ind_debug_lines)
   table.insert(cfg_data.ints,blur_menu)
   table.insert(cfg_data.colors,blur_color)

   local disable_fl_onshot = ui.new_checkbox("AA", "Anti-aimbot angles", "Fix onshot")
   local disable_fl_onshot_disablers = ui.new_multiselect("aa","Anti-aimbot angles","Fix onshot disablers", 
   {
       "Throwing grenade",
       "Double tap",
       "In air",
       "Walking",
       "Standing",
       "High speed",
       "In use",
       "Legit AA key",
       "Jump at edge",
       "Edge yaw",
       "Quick peek assist",
       "Duck peek assist",
       "On Ladder",
       "Low Stamina",
       "On Hit",
       "Exploits disabled"
   })
local enabler = ui.new_checkbox('aa','Anti-aimbot angles','\aD4D7E5FFTrashtalk')
local clantag = ui.new_checkbox("AA", "Anti-aimbot angles", "Clantag")

local fast_ladder_on = ui.new_checkbox("AA", "Anti-aimbot angles", "Fast Ladder")
local drop_nades_to_fit = ui.new_hotkey("AA", "Anti-aimbot angles", "Drop nades to feet",false)

-- local break_lagcomp = ui.new_checkbox("AA", "Anti-aimbot angles", "Break LC [Only in Air]", true, "Pro")
-- local break_lagcomp_jitter = ui.new_checkbox("AA", "Anti-aimbot angles", "Break LC Jitter", true, "Pro")
-- local break_lagcomp_jitter_slider = ui.new_slider("AA", "Anti-aimbot angles", "Break LC tickcount", 1, 64)
local Debug_panel = ui.new_combobox("AA", "Anti-aimbot angles", "Debug panel",{"Disable","v1","v2"})
local ms_color =  ui.new_color_picker('AA', 'Anti-aimbot angles', 'bs Global color', 142, 165, 229, 85 )
local Debug_panel_selector = ui.new_multiselect("AA", "Anti-aimbot angles", "Debug Selection",{"Logo","Name","Build","Anti-aim state","Fake Lag"})

local old_anims = ui.new_multiselect("AA", "Anti-aimbot angles","Anims",{"Static legs","Pitch 0","Leg movement"})

local custom_logs = ui.new_multiselect("AA", "Anti-aimbot angles", "Custom Log",{"Logs to console","Notify logs"})
local color_label = ui.new_label("AA", "Anti-aimbot angles", "Miss log")
local color = ui.new_color_picker("AA", "Anti-aimbot angles", "accent",255,255,255,175)
local color_label2 = ui.new_label("AA", "Anti-aimbot angles", "Hit log")
local color2 = ui.new_color_picker("AA", "Anti-aimbot angles", "accent2",255,255,255,175)
local color_label1 = ui.new_label("AA", "Anti-aimbot angles", "Panorama")
local color1 = ui.new_color_picker("AA", "Anti-aimbot angles", "pan",1, 1, 1,50)

local anim_ind = ui.new_checkbox("AA", "Anti-aimbot angles", 'Animation indicators')
local bs_ind_debug_lines = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Desync Lines')

local blur_menu = ui.new_checkbox("AA", "Anti-aimbot angles", "Blur on menu open")
local blur_color = ui.new_color_picker("AA", "Anti-aimbot angles", "Blur tint", 0, 0, 0, 0)





table.insert(cfg_data.ints,custom_logs)
table.insert(cfg_data.colors,color)
table.insert(cfg_data.colors,color2)
table.insert(cfg_data.colors,color1)

table.insert(cfg_data.ints,disable_fl_onshot)
table.insert(cfg_data.ints,disable_fl_onshot_disablers)
table.insert(cfg_data.ints,enabler)
table.insert(cfg_data.ints,clantag)


table.insert(cfg_data.array,misc_expoloit)
table.insert(cfg_data.ints,anim_ind)
--table.insert(cfg_data.ints,break_lagcomp)
--table.insert(cfg_data.ints,break_lagcomp_jitter)
--table.insert(cfg_data.ints,break_lagcomp_jitter_slider)


table.insert(cfg_data.ints,Debug_panel)
table.insert(cfg_data.ints,old_anims)
table.insert(cfg_data.colors,ms_color)



table.insert(cfg_data.ints,fast_ladder_on)



local ent_state = {
   speed = function(ent) local speed = math.sqrt(math.pow(entity.get_prop(ent, "m_vecVelocity[0]"), 2) + math.pow(entity.get_prop(ent, "m_vecVelocity[1]"), 2)) return speed end,
   is_peeking = function() return (ui.get(refs.ragebot.quick_peek_assist[1]) and ui.get(refs.ragebot.quick_peek_assist[2])) end,
   is_ladder = function(ent) return (entity.get_prop(ent, "m_MoveType") or 0) == 9 end
}

local micro_move = function(cmd)
   local local_player = entity.get_local_player()
   if cmd.chokedcommands == 0 or ent_state.speed(local_player) > 2 or ent_state.is_peeking() or cmd.in_attack == 1 then return end
   --micro move to break LBY
   cmd.forwardmove = 0.1
   cmd.in_forward = 1
end


   local js = panorama.open()
   local _ = js['$']
   local SteamOverlayAPI = js.SteamOverlayAPI
   


   local INFO = ui.new_button("AA","Anti-aimbot angles", "Support", function()
       SteamOverlayAPI.OpenExternalBrowserURL('https://bs-lua.xyz/help/');
   end)

   local DISCORD = ui.new_button("AA","Anti-aimbot angles", "Discord", function()
       SteamOverlayAPI.OpenExternalBrowserURL('https://discord.gg/JBtTGxzuef');
   end)

   local label_config = ui.new_label("AA","Anti-aimbot angles","\aC08A8AFF>  Config System")

   local export_cfg = ui.new_button("AA","Anti-aimbot angles", "\aFFFFFFFFExport Config", function()
       local Code = {{}, {}, {}}
   
       for _, int in pairs(cfg_data.ints) do
           table.insert(Code[1], ui.get(int))
       end
   
       for _, strings in pairs(cfg_data.text) do
           table.insert(Code[2], ui.get(strings))
       end
   
       for _, colors in pairs(cfg_data.colors) do
           local clr = ui.get(colors)
           table.insert(Code[3], clr)
       end
       print("Copied")
       clipboard.set(base64.encode(json.stringify(Code)))
   end)
   
   function import_cfg_func(cfg)
       decode_cfg = json.parse(base64.decode(cfg))
       if decode_cfg == nil then
           client.error('Failed to load config!')
       else
               for k, v in pairs(decode_cfg) do
                   k = ({[1] = 'ints', [2] = 'text', [3] = 'colors'})[k]
       
                   for k2, v2 in pairs(v) do
                       if (k == 'ints') then
                           ui.set(cfg_data[k][k2],(v2))
                       end
   
                       if (k == 'text') then
                           ui.set(cfg_data[k][k2],(v2))
                       end
   
                       if (k == 'colors') then
                           ui.set(cfg_data[k][k2],(v2))
                       end
                   end
               end
               client.log('Config loaded!')
       end
   end
   local import_cfg = ui.new_button("AA","Anti-aimbot angles", "\aFFFFFFFFImport Config", function()
       cfg = clipboard.get()
       import_cfg_func(cfg)
   end)

   local DEFAULT = ui.new_button("AA","Anti-aimbot angles", "\aFFFFFFFFDefault Config", function()
       import_cfg_func("W1tmYWxzZSx0cnVlLDE1LDYsMTUwLHRydWUsMzUwLDc1LHRydWUsZmFsc2UsZmFsc2UsMCwwLDAsMCwwLDAsMCwwLDAsZmFsc2UsMCxmYWxzZSx0cnVlLC0xOCwyNSwzNiwtMjUsMzcsMCwwLDAsMCx0cnVlLDAsZmFsc2UsdHJ1ZSwtMTIsMTQsLTIzLDI1LDMsMCwwLDAsMCxmYWxzZSwwLGZhbHNlLHRydWUsMCwwLC05LDM5LDEsMjgsLTE0LDQzLC0xODAsdHJ1ZSw0NSxmYWxzZSx0cnVlLC0xOSwyMSwtMzAsMzYsLTUsMCwwLDAsMCxmYWxzZSwwLGZhbHNlLHRydWUsLTI1LDI1LC0yMywyNSwtMywxMzMsMCwyNSwwLHRydWUsMCxmYWxzZSxmYWxzZSwwLDAsMCwwLDAsMCwwLDAsMCxmYWxzZSwwLGZhbHNlLHRydWUsMCwwLDAsMCwwLDAsMCwtNTIsMCx0cnVlLDAsZmFsc2UsdHJ1ZSwwLDAsMCwwLDAsMCwwLDAsMCxmYWxzZSwwLGZhbHNlLHRydWUsLTE4LDE5LC0xMiw1LDIxLDM0LC0xODAsMCwwLGZhbHNlLDAsZmFsc2UsZmFsc2UsMCwwLDAsMCwwLDAsMCwwLDAsdHJ1ZSwwLGZhbHNlLGZhbHNlLDAsMCwwLDAsMCwwLDAsMCwwLGZhbHNlLDAsZmFsc2UsZmFsc2UsMCwwLDAsMCwwLDAsMCwwLDAsZmFsc2UsMCxmYWxzZSxmYWxzZSwwLDAsMCwwLDAsMCwwLDAsMCxmYWxzZSwwLGZhbHNlLHRydWUsLTE4LDE5LC0yNSwyNSw1LDAsMCwzMCwwLGZhbHNlLDAsZmFsc2UsZmFsc2UsMSwxLDAsMCwwLDAsMCwxMjAsMCxmYWxzZSwwLGZhbHNlLGZhbHNlLDAsMCwwLDAsMCwwLDAsMCwwLGZhbHNlLDAsZmFsc2UsZmFsc2UsMCwwLDAsMCwwLDAsMCwwLDAsZmFsc2UsMCxmYWxzZSwwLDAsMCwwLDAsMCwwLDAsMCxmYWxzZSwwLGZhbHNlLFsiTG9ncyB0byBjb25zb2xlIiwiTm90aWZ5IGxvZ3MiXSxmYWxzZSxbIkRvdWJsZSB0YXAiLCJJbiBhaXIiLCJRdWljayBwZWVrIGFzc2lzdCIsIkR1Y2sgcGVlayBhc3Npc3QiLCJPbiBMYWRkZXIiLCJFeHBsb2l0cyBkaXNhYmxlZCJdLGZhbHNlLGZhbHNlLHRydWUsIkRpc2FibGUiLFsiU3RhdGljIGxlZ3MiLCJQaXRjaCAwIiwiTGVnIG1vdmVtZW50Il0sdHJ1ZV0sWyJDb25maWcgJiBTdXBwb3J0IiwiQ3VzdG9tIiwiQ3JvdWNoIix7fSwibG9jYWwiLHt9LCJPZmYiLDAsIkxvY2FsIHZpZXciLCJPZmYiLCJOb25lIiwiTm9uZSIsMSwiT2ZmIiwiT2ZmIiwiRG93biIsMCwiQXQgdGFyZ2V0cyIsIjE4MCIsIkN1c3RvbSAzIFdheSIsIk5vbmUiLDEsIk9mZiIsIkppdHRlciIsIk1pbmltYWwiLDAsIkF0IHRhcmdldHMiLCIxODAiLCJDdXN0b20gMyBXYXkiLCJOb25lIiwxLCJPZmYiLCJKaXR0ZXIiLCJEZWZhdWx0IiwwLCJBdCB0YXJnZXRzIiwiMTgwIiwiTm9uZSIsIk5vbmUiLDEsIk9mZiIsIlN0YXRpYyIsIkRvd24iLDAsIkF0IHRhcmdldHMiLCIxODAiLCJOb25lIiwiTm9uZSIsMSwiT2ZmIiwiSml0dGVyIiwiTWluaW1hbCIsMCwiQXQgdGFyZ2V0cyIsIjE4MCIsIkN1c3RvbSAzIFdheSIsIk5vbmUiLDEsIk9mZiIsIkppdHRlciIsIk9mZiIsMCwiTG9jYWwgdmlldyIsIk9mZiIsIk5vbmUiLCJOb25lIiwxLCJPZmYiLCJPZmYiLCJEZWZhdWx0IiwwLCJBdCB0YXJnZXRzIiwiMTgwIiwiTm9uZSIsIk5vbmUiLDEsIkNlbnRlciIsIlN0YXRpYyIsIkRvd24iLDAsIkF0IHRhcmdldHMiLCIxODAiLCJOb25lIiwiTm9uZSIsMSwiT2ZmIiwiT3Bwb3NpdGUiLCJEb3duIiwwLCJBdCB0YXJnZXRzIiwiMTgwIiwiTm9uZSIsIk5vbmUiLDEsIk9mZiIsIkppdHRlciIsIk1pbmltYWwiLDAsIkF0IHRhcmdldHMiLCIxODAiLCJOb25lIiwiTm9uZSIsMSwiT2ZmIiwiU3RhdGljIiwiT2ZmIiwwLCJMb2NhbCB2aWV3IiwiT2ZmIiwiTm9uZSIsIk5vbmUiLDEsIk9mZiIsIk9mZiIsIk9mZiIsMCwiTG9jYWwgdmlldyIsIk9mZiIsIk5vbmUiLCJOb25lIiwxLCJPZmYiLCJPZmYiLCJPZmYiLDAsIkxvY2FsIHZpZXciLCJPZmYiLCJOb25lIiwiTm9uZSIsMSwiT2ZmIiwiT2ZmIiwiQ3VzdG9tIiwtODksIkF0IHRhcmdldHMiLCJTcGluIiwiRGVsYXllZCBTd2l0Y2ggWWF3IiwiVkRFRiIsOCwiT2ZmIiwiSml0dGVyIiwiRGVmYXVsdCIsMCwiTG9jYWwgdmlldyIsIjE4MCIsIk5vbmUiLCJOb25lIiwxLCJTa2l0dGVyIiwiT3Bwb3NpdGUiLCJPZmYiLDAsIkxvY2FsIHZpZXciLCJPZmYiLCJOb25lIiwiTm9uZSIsMSwiT2ZmIiwiT2ZmIiwiT2ZmIiwwLCJMb2NhbCB2aWV3IiwiT2ZmIiwiTm9uZSIsIk5vbmUiLDEsIk9mZiIsIk9mZiIsIk9mZiIsMCwiTG9jYWwgdmlldyIsIjE4MCIsIk5vbmUiLCJOb25lIiwxLCJDZW50ZXIiLCJPcHBvc2l0ZSIsIk1pbmltYWxpc3RpYyIsIkJvdGgiLFsiRG91YmxldGFwIiwiT25zaG90IiwiRG9ybWFudCIsIkJhaW0iLCJGcmVlc3RhbmQiLCJTYWZlIiwiRGFtYWdlIiwiUGluZyIsIkZha2UgRHVjayIsIklkZWFsIFRpY2siXV0sWzEyNCwxMzAsMjI3LDc2LDEsMTQyXV0=")
   end)


local aa_script = function()
local data = 
           {
           side = 1,
           last_side = 0,
           body_yaw_modifier = 1,
           data_jitter_side = true
           }


local function set_og_menu(state)
   --ui.set_visible(refs.antiaim.enabled, state)
   ui.set_visible(refs.antiaim.pitch, state)
   ui.set_visible(refs.antiaim.pitch_val, state)
   ui.set_visible(refs.antiaim.yaw_base, state)
   ui.set_visible(refs.antiaim.yaw[1], state)
   ui.set_visible(refs.antiaim.yaw[2], state)
   ui.set_visible(refs.antiaim.yaw_jitter[1], state)
   ui.set_visible(refs.antiaim.yaw_jitter[2], state)
   ui.set_visible(refs.antiaim.body_yaw[1], state)
   ui.set_visible(refs.antiaim.body_yaw[2], state)
--ui.set_visible(refs.antiaim.fake_yaw_limit, state)
   ui.set_visible(refs.antiaim.freestanding_body_yaw, state)
   ui.set_visible(refs.antiaim.edge_yaw, state)
   ui.set_visible(refs.antiaim.freestanding[1], state)
   ui.set_visible(refs.antiaim.freestanding[2], state)
   ui.set_visible(refs.antiaim.roll, state)
end


local function handle_menu()
   var.active_i = var.state_to_idx[ui.get(anti_aim[0].player_state)]

   set_og_menu(false)
   show_menu = ui.get(lua_tabs) == "Anti-aim"
   ui.set_visible(anti_aim[0].anti_aim_mode, show_menu)
   local rage = ui.get(anti_aim[0].anti_aim_mode) == "Custom"
   for i = 1, 19 do
      -- ui.set_visible(default_custom,rage and show_menu)
       ui.set_visible(anti_aim[i].enable, rage and show_menu and var.active_i == i and i > 1)
       ui.set_visible(anti_aim[i].pitch, rage and show_menu and var.active_i == i)
       ui.set_visible(anti_aim[i].pitch_val, rage and show_menu and var.active_i == i and ui.get(anti_aim[i].pitch) == "Custom")
       ui.set_visible(anti_aim[i].yawbase, rage and show_menu and var.active_i == i)
       ui.set_visible(anti_aim[i].yaw, rage and show_menu and var.active_i == i)
       
       xway_type = ui.get(anti_aim[i].yaw_xway)
       ui.set_visible(anti_aim[i].yawadd_r,rage and show_menu and var.active_i == i and ui.get(anti_aim[i].yaw) ~= "Off" and not (xway_type == "Custom 3 Way" or xway_type == "Custom 4 Way" or xway_type == "Custom 5 Way")  )
       ui.set_visible(anti_aim[i].yawadd_l,rage and show_menu and var.active_i == i and ui.get(anti_aim[i].yaw) ~= "Off" and not (xway_type == "Custom 3 Way" or xway_type == "Custom 4 Way" or xway_type == "Custom 5 Way") )
       ui.set_visible(anti_aim[i].yaw_xway_desync,rage and show_menu and var.active_i == i and ui.get(anti_aim[i].yaw) ~= "Off" and  (xway_type == "Delayed Switch Yaw" ) )
       ui.set_visible(anti_aim[i].yaw_xway_delay,rage and show_menu and var.active_i == i and ui.get(anti_aim[i].yaw) ~= "Off" and  (xway_type == "Delayed Switch Yaw" ) )




       ui.set_visible(anti_aim[i].yaw_tickbase_def,rage and show_menu and var.active_i == i and ui.get(anti_aim[i].yaw) ~= "Off" )
       yaw_tickbase_def_state = ui.get(anti_aim[i].yaw_tickbase_def)

       ui.set_visible(anti_aim[i].yaw_tickbase_def_method,rage and show_menu and var.active_i == i and ui.get(anti_aim[i].yaw) ~= "Off" and yaw_tickbase_def_state)
       ui.set_visible(anti_aim[i].yaw_tickbase_def_mode,rage and show_menu and var.active_i == i and ui.get(anti_aim[i].yaw) ~= "Off" and yaw_tickbase_def_state)
       ui.set_visible(anti_aim[i].yaw_tickbase_def_ping_related,rage and show_menu and var.active_i == i and ui.get(anti_aim[i].yaw) ~= "Off" and yaw_tickbase_def_state)


       ui.set_visible(anti_aim[i].yaw_tickbase_def_mode_sen_end, rage and show_menu and var.active_i == i  and yaw_tickbase_def_state and ui.get(anti_aim[i].yaw_tickbase_def_mode) == "Sensitive") 
       ui.set_visible(anti_aim[i].yaw_tickbase_def_mode_del_slider, rage and show_menu and var.active_i == i  and yaw_tickbase_def_state and ui.get(anti_aim[i].yaw_tickbase_def_mode) == "Delimiter" )
       
       ui.set_visible(anti_aim[i].yaw_tickbase_def_mode_pitch1, rage and show_menu and var.active_i == i  and yaw_tickbase_def_state and ui.get(anti_aim[i].yaw_tickbase_def_method) == "Second Pitch" )
       ui.set_visible(anti_aim[i].yaw_tickbase_def_mode_pitch2, rage and show_menu and var.active_i == i  and yaw_tickbase_def_state and ui.get(anti_aim[i].yaw_tickbase_def_method) == "Second Pitch")
   
       
       ui.set_visible(anti_aim[i].yaw_xway,rage and show_menu and var.active_i == i and ui.get(anti_aim[i].yaw) ~= "Off"   )

       ui.set_visible(anti_aim[i].yaw_sliderways.w1, rage and show_menu and var.active_i == i and ui.get(anti_aim[i].yaw) ~= "Off" and (xway_type == "Custom 3 Way" or xway_type == "Custom 4 Way" or xway_type == "Custom 5 Way")  )
       ui.set_visible(anti_aim[i].yaw_sliderways.w2, rage and show_menu and var.active_i == i and ui.get(anti_aim[i].yaw) ~= "Off" and (xway_type == "Custom 3 Way" or xway_type == "Custom 4 Way" or xway_type == "Custom 5 Way")  )
       ui.set_visible(anti_aim[i].yaw_sliderways.w3, rage and show_menu and var.active_i == i and ui.get(anti_aim[i].yaw) ~= "Off" and (xway_type == "Custom 3 Way" or xway_type == "Custom 4 Way" or xway_type == "Custom 5 Way")  )
       ui.set_visible(anti_aim[i].yaw_sliderways.w4, rage and show_menu and var.active_i == i and ui.get(anti_aim[i].yaw) ~= "Off" and (xway_type == "Custom 4 Way" or xway_type == "Custom 5 Way") )
       ui.set_visible(anti_aim[i].yaw_sliderways.w5, rage and show_menu and var.active_i == i and ui.get(anti_aim[i].yaw) ~= "Off" and (xway_type == "Custom 5 Way") )


       ui.set_visible(anti_aim[i].yawjitter, rage and show_menu and var.active_i == i)
       ui.set_visible(anti_aim[i].yawjitteradd,rage and show_menu and var.active_i == i and ui.get(anti_aim[i].yawjitter) ~= "Off")
       ui.set_visible(anti_aim[i].gs_bodyyaw, rage and show_menu and var.active_i == i)
       bdyaw = ui.get(anti_aim[i].gs_bodyyaw)
       ui.set_visible(anti_aim[i].gs_bodyyawadd,rage and show_menu and var.active_i == i and (bdyaw ~= "Off" and bdyaw ~= "Opposite"))
       ui.set_visible(anti_aim[i].gs_freestanding_body,rage and show_menu and var.active_i == i and bdyaw ~= "Off")

       ui.set_visible(anti_aim[i].roll_sk,rage and show_menu and var.active_i == i and ui.get(anti_aim[i].roll_enabled))
       ui.set_visible(anti_aim[i].roll_enabled, rage and show_menu and var.active_i == i)
       ui.set_visible(anti_aim[i].roll_enabled_hk, rage and show_menu and var.active_i == i and ui.get(anti_aim[i].roll_enabled))
       ui.set_visible(anti_aim[i].roll_inverter , rage and show_menu and var.active_i == i and ui.get(anti_aim[i].roll_enabled))

   end

   ui.set_visible(anti_aim[0].player_state, rage and show_menu)
   ui.set_visible(anti_aim[0].aa_ditionals, show_menu)

   ui.set_visible(anti_aim[0].freestand[1], show_menu and contains(anti_aim[0].aa_ditionals,"Freestand"))
   ui.set_visible(anti_aim[0].freestand[2], show_menu and contains(anti_aim[0].aa_ditionals,"Freestand"))

   ui.set_visible(anti_aim[0].edge[1], show_menu and contains(anti_aim[0].aa_ditionals,"Edge Yaw"))
   ui.set_visible(anti_aim[0].edge[2], show_menu and contains(anti_aim[0].aa_ditionals,"Edge Yaw"))

   ui.set_visible(anti_aim[0].manual_left, show_menu and contains(anti_aim[0].aa_ditionals,"Manual"))
   ui.set_visible(anti_aim[0].manual_right, show_menu and contains(anti_aim[0].aa_ditionals,"Manual"))
   ui.set_visible(anti_aim[0].manual_forward, show_menu and contains(anti_aim[0].aa_ditionals,"Manual"))


  

   local show_misc = ui.get(lua_tabs) == 'Misc'
       ui.set_visible(anti_aim[20].custom_resolver, show_misc and ui.get(misc_expoloit) == "Main Misc")
       ui.set_visible(anti_aim[20].anti_knifebot, show_misc and ui.get(misc_expoloit) == "Main Misc")
       ui.set_visible(anti_aim[20].dt_teleport, show_misc and ui.get(misc_expoloit) == "Exploit Misc")
       
       ui.set_visible(anti_aim[20].dt_teleport_opts, show_misc and ui.get(misc_expoloit) == "Exploit Misc")
       ui.set_visible(anti_aim[20].dt_teleport_damage_opts    , show_misc and ui.get(misc_expoloit) == "Exploit Misc"  and contains(anti_aim[20].dt_teleport_opts,"Damage") and ui.get(anti_aim[20].dt_teleport_damage_slider) == 101 )
       ui.set_visible(anti_aim[20].dt_teleport_damage_slider   , show_misc and ui.get(misc_expoloit) == "Exploit Misc" and contains(anti_aim[20].dt_teleport_opts,"Damage"))
       ui.set_visible(anti_aim[20].dt_teleport_delay_opts    , show_misc and ui.get(misc_expoloit) == "Exploit Misc"  and contains(anti_aim[20].dt_teleport_opts,"Delay"))
       ui.set_visible(anti_aim[20].dt_teleport_delay_slider    , show_misc and ui.get(misc_expoloit) == "Exploit Misc" and contains(anti_aim[20].dt_teleport_delay_opts,"Delay ticks"))
       ui.set_visible(anti_aim[20].dt_teleport_velocity_slider , show_misc and ui.get(misc_expoloit) == "Exploit Misc" and contains(anti_aim[20].dt_teleport_opts,"Velocity"))
       ui.set_visible(anti_aim[20].anti_knifebot_pistal, show_misc and ui.get(anti_aim[20].anti_knifebot) and ui.get(misc_expoloit) == "Main Misc")
       ui.set_visible(anti_aim[20].anti_knifebot_pistal_slider, show_misc and ui.get(anti_aim[20].anti_knifebot_pistal) and ui.get(misc_expoloit) == "Main Misc")
       ui.set_visible(anti_aim[20].anti_knifebot_slider, ui.get(anti_aim[20].anti_knifebot) and show_misc and ui.get(misc_expoloit) == "Main Misc" )
       ui.set_visible(disable_fl_onshot,show_misc and ui.get(misc_expoloit) == "Main Misc")
       ui.set_visible(disable_fl_onshot_disablers,show_misc and  ui.get(disable_fl_onshot) and ui.get(misc_expoloit) == "Main Misc" )
       ui.set_visible(enabler,show_misc and ui.get(misc_expoloit) == "Main Misc")
       ui.set_visible(clantag,show_misc and ui.get(misc_expoloit) == "Main Misc")


       ui.set_visible(misc_expoloit,show_misc)
      --ui.set_visible(break_lagcomp,show_misc and ui.get(misc_expoloit) == "Exploit Misc")
      --ui.set_visible(break_lagcomp_jitter,show_misc and ui.get(misc_expoloit) == "Exploit Misc"  and ui.get(break_lagcomp))
      --ui.set_visible(break_lagcomp_jitter_slider,show_misc and ui.get(misc_expoloit) == "Exploit Misc"  and ui.get(break_lagcomp_jitter))
      
       ui.set_visible(fast_ladder_on,show_misc and ui.get(misc_expoloit) == "Exploit Misc")
       ui.set_visible(drop_nades_to_fit,show_misc and ui.get(misc_expoloit) == "Exploit Misc")
  
       
   
   local show_vis = ui.get(lua_tabs) == 'Visual'
       ui.set_visible(menu.style,show_vis and (ui.get(menu.type) == "Centered" or  ui.get(menu.type) == "Both"))
       ui.set_visible(menu.chosez,show_vis and (ui.get(menu.type) == "Centered"))
       ui.set_visible(menu.type,show_vis )
       ui.set_visible(bs_ind_fist_color, show_vis and not (ui.get(menu.type) == "Default skeet"))
       ui.set_visible(bs_ind_second_color,show_vis and not (ui.get(menu.type) == "Default skeet"))
       ui.set_visible(bs_ind_debug_lines,show_vis)
       ui.set_visible(blur_menu,show_vis)
       ui.set_visible(blur_color,show_vis)

       ui.set_visible(old_anims,show_vis)

       ui.set_visible(Debug_panel,show_vis)
       ui.set_visible(ms_color,show_vis and (ui.get(Debug_panel) == "v1" or ui.get(Debug_panel) == "v2"))
       ui.set_visible(Debug_panel_selector,show_vis and ui.get(Debug_panel) == "v2")
       ui.set_visible(anim_ind,show_vis and not (ui.get(menu.type) == "Default skeet"))

       ui.set_visible(custom_logs,show_vis)
       ui.set_visible(color_label1,show_vis and contains(custom_logs,"Notify logs"))
       ui.set_visible(color1,show_vis and contains(custom_logs,"Notify logs"))
       ui.set_visible(color_label,show_vis and contains(custom_logs,"Logs to console")) 
       ui.set_visible(color,show_vis and contains(custom_logs,"Logs to console"))
       ui.set_visible(color_label2,show_vis and contains(custom_logs,"Logs to console"))
       ui.set_visible(color2,show_vis and contains(custom_logs,"Logs to console"))
       ui.set_visible(anti_aim[20].visual_dmg, show_vis )
       ui.set_visible(anti_aim[20].visual_dmg_safe, show_vis and ui.get(anti_aim[20].visual_dmg))

      
   local show_config = ui.get(lua_tabs) == 'Config & Support'
       ui.set_visible(INFO,show_config)
       ui.set_visible(DISCORD,show_config)

       ui.set_visible(label_config,show_config)
       ui.set_visible(DEFAULT,show_config)
       ui.set_visible(export_cfg,show_config)
       ui.set_visible(import_cfg,show_config)
end

handle_menu()
local function fl_induck(ent)
   local flags = entity.get_prop(ent, "m_fFlags")
   local flags_induck = bit.band(flags, 2)
   if flags_induck == 2 then
       return true
   end
   return false
end
local function get_wpn_class(ent)
   return entity.get_classname(entity.get_player_weapon(ent))
   end
   local function is_visible(ent)
   local me = entity.get_local_player()
   local l_x, l_y, l_z = entity.hitbox_position(me, 0)
   local e_x, e_y, e_z = entity.hitbox_position(ent, 0)
   local frac, ent = client.trace_line(me, l_x, l_y, l_z, e_x, e_y, e_z)
   return frac > 0.6
end
local function get_ent_dist(ent_1, ent_2)
   local ent1_pos = vector(entity.get_prop(ent_1, "m_vecOrigin"))
   local ent2_pos = vector(entity.get_prop(ent_2, "m_vecOrigin"))
   local dist = ent1_pos:dist(ent2_pos)
   return dist
end
local function is_long_weapon(ent)
   local ent_wpn = get_wpn_class(ent)
   return ent_wpn ~= "CKnife" and ent_wpn ~= "CC4" and ent_wpn ~= "CMolotovGrenade" and ent_wpn ~= "CSmokeGrenade" and ent_wpn ~= "CHEGrenade" and ent_wpn ~= "CIncendiaryGrenade" and ent_wpn ~= "CFlashbang" and ent_wpn ~= "CDecoyGrenade"
end
local function is_damageable()
   local enemies = entity.get_players(true)
   for i,v in ipairs(enemies) do
   if is_visible(v) and is_long_weapon(v) then return true end
   end
   return false
end

client.set_event_callback("player_connect_full", function(e)
   var.tick_now = 0
   delay_ticks = 0
end)
client.set_event_callback("cs_win_panel_round", function(e)
   var.tick_now = 0
   
   delay_ticks = 0
end)


local function get_total_enemies()
   local count = 0
   for e = 1, globals.maxplayers() do
       if entity.get_prop(entity.get_player_resource(), "m_bConnected", e) and entity.is_enemy(e) and entity.is_alive(e) then
           count = count + 1
       end
   end
   return count
end

local function run_fakelag(cmd)
        dt = ui.get(refs.ragebot.double_tap[1]) and  ui.get(refs.ragebot.double_tap[2])
        os =  ui.get(refs.antiaim.hide_shots[1]) and ui.get(refs.antiaim.hide_shots[2])
        fd = (refs.ragebot.duck_peek_assist)
        limit = 13
       if fd then
           limit = 13
       elseif dt then
           limit = 1
       elseif os then
           limit = 1
       end
        send_packet = true
       if cmd.chokedcommands < limit then
           send_packet = false
       end
        command_dif = cmd.command_number - cmd.chokedcommands - globals.lastoutgoingcommand()
       send_packet = send_packet or cmd.no_choke or not cmd.allow_send_packet or command_dif ~= 1
       cmd.allow_send_packet = send_packet
       return send_packet
   end

local function is_defensive_active()
   local player = entity.get_local_player()
   if not entity.is_alive(player) then
       return
   end


   local simtime = entity.get_prop(player, "m_flSimulationTime")
   local sim_time = toticks(simtime)
   local player_data = var.cache.data

   if player_data == nil then
       var.cache.data = {
           last_sim_time = sim_time,
           defensive_active_until = 0,
           defensive_active = false,
           defensive_active_before = false,
           defensive_work_now = 0
       }
   else
       if player_data.last_sim_time == nil then 
           player_data.last_sim_time = sim_time
       end
       local delta = sim_time - player_data.last_sim_time
       if delta < 0 then
           defensive_mode = ui.get(anti_aim[var.p_state].yaw_tickbase_def_mode)
           ping_related = ui.get(anti_aim[var.p_state].yaw_tickbase_def_ping_related)
           if defensive_mode == "Default" then
           player_data.defensive_active_until = ping_related and math.abs(delta) - toticks(client.latency()) or  math.abs(delta) 
           elseif defensive_mode == "Sensitive" then
           sensitive_end  = ui.get(anti_aim[var.p_state].yaw_tickbase_def_mode_sen_end)
           player_data.defensive_active_until =  ping_related and math.abs(delta) - toticks(client.latency()) - sensitive_end or  math.abs(delta) - sensitive_end 
           elseif defensive_mode == "Delimiter" then
               delimiter = ui.get(anti_aim[var.p_state].yaw_tickbase_def_mode_del_slider)
               player_data.defensive_active_until =  ping_related and (math.abs(delta) - toticks(client.latency())) / delimiter or math.abs(delta)/delimiter 
           end
           player_data.defensive_active_until = globals.tickcount() +  player_data.defensive_active_until 
       end
       player_data.last_sim_time = sim_time    
   end
   if player_data ~= nil then
       player_data.defensive_active_before = player_data.defensive_active
       player_data.defensive_active = player_data.defensive_active_until - globals.tickcount() > 0
       if player_data.defensive_active and not player_data.defensive_active_before then
           player_data.defensive_work_now = globals.tickcount()
       end
   else
       if player_data ~= nil then
       player_data.defensive_active = false
       player_data.defensive_work_now = -1
       end
   end
   
end


client.set_event_callback ( 'net_update_end', function ( )
   is_defensive_active()
end )

client.set_event_callback("level_init", function()
   var.cache.data.last_sim_time ,var.cache.data.defensive_active_until, var.cache.data.defensive_active = 0, 0, false
end)







local last_origin = vector(0,0,0)
local function run_aa(c, plocal)
   local vx, vy, vz = entity.get_prop(plocal, "m_vecVelocity")
   local p_still = math.sqrt(vx ^ 2 + vy ^ 2) < 2
   local on_ground = bit.band(entity.get_prop(plocal, "m_fFlags"), 1) == 1 and c.in_jump == 0
   local p_slow = ui.get(refs.antiaim.slow_motion[1]) and ui.get(refs.antiaim.slow_motion[2])
   local p_key = ui.get(anti_aim[19].enable)
   local man_en = var.manual_dir ~= "back" --мануалы+роллынамануалы+актив
   local vuln = is_vulnerable()
   local threat = client.current_threat()
   local pitch_to_threat = 0
   local height_to_threat = 0
   
   local origin = vector(entity.get_origin(plocal))
   local breaking_lc = (last_origin - origin):length2dsqr() > 4096
   
   if c.chokedcommands == 0 then
       last_origin = origin
   end
   if threat then
       local threat_origin = vector(entity.get_origin(threat))
       pitch_to_threat = origin:to(threat_origin):angles()
       height_to_threat = origin.z-threat_origin.z
   end
--













-- ["Global"] = 1,
var.p_state = 1

   if  ui.get(anti_aim[9].enable) and man_en  and  not p_key   then
       --["Manuals"] = 9,
       var.p_state = 9
   else
       if p_key then
           -- ["On-key"] = 19
           var.p_state = 19
       elseif ui.get(anti_aim[17].enable) and entity.get_prop(entity.get_game_rules(), "m_iRoundWinStatus") ~= 0 and get_total_enemies() == 0 then
       -- ["Round end"] = 17,
       var.p_state = 17
       elseif ui.get(anti_aim[11].enable) and vulnerable_ticks > 0 and vulnerable_ticks <= 14 then
       -- ["On peek"] = 11,
      -- c.force_defensive = 1
       var.p_state = 11
       elseif breaking_lc and ui.get(anti_aim[8].enable) then
           -- ["Breaking LC",] = 8,
           var.p_state = 8
       elseif   ui.get(anti_aim[16].enable) and (#entity.get_players(true) == 0) then
       -- ["Dormant"] = 16,
       var.p_state = 16
       elseif  ui.get(anti_aim[13].enable) and threat and height_to_threat > 25 then 
           -- ["Height advantage"] = 13,
           var.p_state = 13
       elseif  ui.get(anti_aim[14].enable) and threat and height_to_threat < -25 then 
           -- ["Height disadvantage"] = 14,
           var.p_state = 14
       elseif ui.get(anti_aim[18].enable) and entity.get_classname(entity.get_player_weapon(plocal)) == "CKnife" then
           --["Holding Knife"] = 18,
           var.p_state = 18
       else
           if not on_ground then
               if ui.get(anti_aim[10].enable) and fl_induck(plocal) then
                   var.p_state = 10
               elseif ui.get(anti_aim[5].enable) then
                                           -- ["Air"] = 5,
                                           var.p_state = 5
               end
           elseif vuln and ui.get(anti_aim[12].enable)  then
                                           -- ["Vulnerable"] = 12,
                                       --  c.force_defensive = 1
                                           var.p_state = 12
           else
               if p_slow and ui.get(anti_aim[4].enable) then
                                                   -- ["Slow walk"] = 4,
                                                   var.p_state = 4
               else
               -- ["Crouch"] = 6,
                   if fl_induck(plocal) and ui.get(anti_aim[6].enable) and on_ground then
                                                           var.p_state = 6
                   else
                       if p_still and ui.get(anti_aim[2].enable) then
                                                                   -- ["Stand"] = 2,
                                                                   var.p_state = 2
                       elseif not p_still and ui.get(anti_aim[3].enable) then
                               if ui.get(anti_aim[7].enable) and ui.get(anti_aim[0].freestand[2]) and ui.get(anti_aim[0].freestand[1]) and contains(anti_aim[0].aa_ditionals,"Freestand") then
                                   -- ["Freestand"] = 7,
                                   var.p_state = 7
                               else
                                   -- ["Walking"] = 3,
                                   var.p_state = 3
                               end
                       end
                   end
               end
           end
       end
   end        
end

local delay_ticks = 0
local delay_side = true
local flick_handler = function(left,right, delay,ticks)
   

   if delay_ticks < ticks then
       delay_ticks = ticks + delay
       delay_side = not delay_side
   end
   if delay_side then
       return left
   else 
       return right
   end

end

client.set_event_callback ( 'init', function ( )
   delay_ticks = 0
end )

local bodyyaw = 0
local yaw_handler = function(left, right)
if bodyyaw > 0 then
return left
elseif bodyyaw < 0 then
return right
else
return 0
end
end
local aa_knife = false
local function run_direction(c, LocalPlayer) 
ui.set(anti_aim[0].manual_left, "On hotkey")
ui.set(anti_aim[0].manual_right, "On hotkey")
ui.set(anti_aim[0].manual_forward, "On hotkey")
local k = {ui.get(anti_aim[19].enable)}
   if (k[1] and k[3] == 69) then
   ui.set(refs.antiaim.freestanding[1], false)
   ui.set(refs.antiaim.edge_yaw, false)
   return
   end
local fs_e = ui.get(anti_aim[0].freestand[2]) and ui.get(anti_aim[0].freestand[1]) and contains(anti_aim[0].aa_ditionals,"Freestand") and var.manual_dir == "back"
local edge_e = ui.get(anti_aim[0].edge[2]) and ui.get(anti_aim[0].edge[1]) and contains(anti_aim[0].aa_ditionals,"Edge Yaw")
local me = LocalPlayer
aa_knife = false



if ui.get(anti_aim[20].anti_knifebot) then
local enemies = entity.get_players(true)
       for i,v in ipairs(enemies) do
               if not is_damageable() and get_wpn_class(v) == "CKnife" and is_visible(v) then
                   local dist = get_ent_dist(me, v)
                       if dist < ui.get(anti_aim[20].anti_knifebot_slider) then
                       aa_knife = true
                       c.allow_shift_tickbase = true
                       if ui.get(anti_aim[20].anti_knifebot_pistal) and  entity.get_prop(v, "m_iHealth") > ui.get(anti_aim[20].anti_knifebot_pistal_slider) then
                        client.exec("slot2;")
                        c.allow_shift_tickbase = true
                       end
                       break;
                       end
               end
       end
   end

ui.set(refs.antiaim.freestanding[1], fs_e  and true or false)
ui.set(refs.antiaim.freestanding[2], "Always on")
ui.set(refs.antiaim.edge_yaw, edge_e)
   if not contains(anti_aim[0].aa_ditionals,"Manual") then
       if aa_knife then
           var.aa_dir = 180
       else
           var.aa_dir = 0
       end
       
   var.manual_dir = "back"
   else
       if aa_knife then
           var.aa_dir = 180
       else
           if ui.get(anti_aim[0].manual_right) and contains(anti_aim[0].aa_ditionals,"Manual") and var.right_ready then
               var.manual_dir = var.manual_dir == "right" and "back" or "right"
               var.right_ready = false
           elseif ui.get(anti_aim[0].manual_left) and contains(anti_aim[0].aa_ditionals,"Manual") and var.left_ready then
               var.manual_dir = var.manual_dir == "left" and "back" or "left"
               var.left_ready = false
           elseif ui.get(anti_aim[0].manual_forward) and contains(anti_aim[0].aa_ditionals,"Manual") and var.forward_ready then
               var.manual_dir = var.manual_dir == "forward" and "back" or "forward"
               var.forward_ready = false
           end

           if not ui.get(anti_aim[0].manual_right)  then
               var.right_ready = true
           end
           if not ui.get(anti_aim[0].manual_left)  then
               var.left_ready = true
           end
           if not ui.get(anti_aim[0].manual_forward)  then
               var.forward_ready = true
           end

           if var.manual_dir == "left" then var.aa_dir = -90 
           elseif var.manual_dir == "right" then var.aa_dir = 90 
           elseif var.manual_dir == "forward" then var.aa_dir = -180 
           elseif var.manual_dir == "back" then var.aa_dir = 0 end
           end
   end

end

local function distance3d(x1, y1, z1, x2, y2, z2)
return math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) + (z2 - z1) * (z2 - z1))
end
local function aa_on_use(c, plocal)
local distance = 100
local bomb = entity.get_all("CPlantedC4")[1]
local bomb_x, bomb_y, bomb_z = entity.get_prop(bomb, "m_vecOrigin")
if bomb_x ~= nil then
local player_x, player_y, player_z = entity.get_prop(plocal, "m_vecOrigin")
distance = distance3d(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
end

local team_num = entity.get_prop(plocal, "m_iTeamNum")
local defusing = team_num == 3 and distance < 62

local px, py, pz = client.eye_position()
local pitch, yaw = client.camera_angles()

local sin_pitch = math.sin(math.rad(pitch))
local cos_pitch = math.cos(math.rad(pitch))
local sin_yaw = math.sin(math.rad(yaw))
local cos_yaw = math.cos(math.rad(yaw))
local dir_vec = {cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch}
local fraction, entindex =
client.trace_line(plocal,px,py,pz,px + (dir_vec[1] * 8192),py + (dir_vec[2] * 8192),pz + (dir_vec[3] * 8192))
local using = true
if entindex ~= nil then
for i = 0, #var.classnames do
   if entity.get_classname(entindex) == var.classnames[i] then
       using = false
   end
end
end
if not using and not defusing then
c.in_use = 0
end
end
local function normalize_yaw(yaw)
while yaw > 180 do
yaw = yaw - 360
end
while yaw < -180 do
yaw = yaw + 360
end
return yaw
end



local prev_simulation_time = 0
local to_up = "no"
local to_draw_ticks = 0

local function drop_wpn(name,c)

   client.exec("use "..name)
   client.exec("drop")

end
local function time_to_ticks(t)
   return math.floor(0.5 + (t / globals.tickinterval()))
end
local diff_sim = 0
function sim_diff() 
   local current_simulation_time = time_to_ticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
   local diff = current_simulation_time - prev_simulation_time
   prev_simulation_time = current_simulation_time
   diff_sim = diff
   return diff_sim
end

local yaw_cached = false
local yaw_val = false
local endtick = globals.tickcount()

--Break LC
local exploit_workaet = false
local ground_time = 0
local function on_setup_command(c)
   local LocalPlayer = entity.get_local_player()
       if LocalPlayer == nil or entity.is_alive(LocalPlayer) == false then         return        end
local vec_velocity = {entity.get_prop(LocalPlayer, "m_vecVelocity")}
local flags = entity.get_prop(LocalPlayer, "m_fFlags")
if vec_velocity[1] == nil or flags == nil then
   return
end

local air = bit.band(flags, 1) == 0
   if air == false then
       ground_time = ground_time + 1
   else
   ground_time = 0
end

-- if ui.get(break_lagcomp) and (ui.get(refs.ragebot.double_tap[1]) and ui.get(refs.ragebot.double_tap[2])) then
-- 	curtime = globals.tickcount()
--     if ground_time < 8 then
--             if ui.get(break_lagcomp_jitter) and var.last_press_t >= curtime then
--             c.force_defensive = true
--             exploit_workaet = true
--             elseif var.last_press_t < curtime and ui.get(break_lagcomp_jitter) then
--             var.last_press_t = curtime + ui.get(break_lagcomp_jitter_slider)
--             exploit_workaet = false
--             elseif not ui.get(break_lagcomp_jitter) then
--             c.force_defensive = true
--             exploit_workaet = true
--             end
--     else 
--     exploit_workaet = false
-- 	end
-- end


run_aa(c, LocalPlayer)
run_direction(c, LocalPlayer)
aa_on_use(c, LocalPlayer)

--c.force_defensive = true
local weapon_t = csgo_weapons[entity.get_prop(entity.get_player_weapon(LocalPlayer), "m_iItemDefinitionIndex")]
if weapon_t == nil then 
return end
data:handle_setup_command(c, LocalPlayer,weapon_t)


bodyyaw = math.min(57, entity.get_prop(LocalPlayer, "m_flPoseParameter", 11) * 120 - 60) or 0

local holding_e = ui.get(anti_aim[19].enable)
local yaw_to_add = holding_e and 0 or var.aa_dir


local pitch, yaw = client.camera_angles()

local yawvalue = normalize_yaw(yaw_handler(ui.get(anti_aim[var.p_state].yawadd_l), ui.get(anti_aim[var.p_state].yawadd_r)) + yaw_to_add)-180
------ Laddermove
local weapon_tp = entity.get_prop(entity.get_player_weapon(LocalPlayer), "m_bPinPulled")
   if ui.get(fast_ladder_on) and not (weapon_t.type == "grenade" or weapon_tp == 1)  then 
       if  entity.get_prop(LocalPlayer, "m_MoveType") == 9 then
           c.yaw = math.floor(c.yaw+0.5)
           if c.forwardmove == 0 then
               c.pitch = 89
               c.yaw = c.yaw + yawvalue
               if math.abs(yawvalue) > 0 and math.abs(yawvalue) < 180 and c.sidemove ~= 0 then
                   c.yaw = c.yaw - yawvalue
               end
               if math.abs(yawvalue) == 180 then
                   if c.sidemove < 0 then
                       c.in_moveleft = 0
                       c.in_moveright = 1
                   end
                   if c.sidemove > 0 then
                       c.in_moveleft = 1
                       c.in_moveright = 0
                   end
               end
           end

               if c.forwardmove > 0 then
                   if pitch < 45 then
                       c.pitch = 89
                       c.in_moveright = 1
                       c.in_moveleft = 0
                       c.in_forward = 0
                       c.in_back = 1
                       if c.sidemove == 0 then
                           c.yaw = c.yaw + 90
                       end
                       if c.sidemove < 0 then
                           c.yaw = c.yaw + 150
                       end
                       if c.sidemove > 0 then
                           c.yaw = c.yaw + 30
                       end
                   end 
               end
           
               if c.forwardmove < 0 then
                   c.pitch = 89
                   c.in_moveleft = 1
                   c.in_moveright = 0
                   c.in_forward = 1
                   c.in_back = 0
                   if c.sidemove == 0 then
                       c.yaw = c.yaw + 90
                   end
                   if c.sidemove > 0 then
                       c.yaw = c.yaw + 150
                   end
                   if c.sidemove < 0 then
                       c.yaw = c.yaw + 30
                   end
               end
       end
   end
   var.drop_n_tick = globals.curtime()
   if ui.get(drop_nades_to_fit)  then
           if var.drop_nades_once  then
               var.drop_nades_once = false
               local wpns = {}
               for slot = 0, 63 do
                   local weapon_ent = entity.get_prop(LocalPlayer, "m_hMyWeapons", slot)
                       if weapon_ent ~= nil then
                       local weapon = csgo_weapons[entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")]
                           if weapon ~= nil and weapon.type == "grenade" then
                               table.insert(wpns, weapon.item_class)
                           end
                       end
               end

               for i, wpn in ipairs(wpns) do
                   client.delay_call(0.02*i, drop_wpn,wpn,c)
               end
               ui.set(refs.antiaim.pitch, "Off")
               ui.set(refs.antiaim.yaw_base, "Local view")
               ui.set(refs.antiaim.yaw[1], "Off")
               ui.set(refs.antiaim.yaw[2], 180)
               c.allow_send_packet = true
               c.no_choke = true
               var.drop_n_tick_next = globals.curtime()+(0.02*#wpns)
           end
           if  var.drop_n_tick <  var.drop_n_tick_next then
               ui.set(refs.antiaim.pitch, "Off")
               ui.set(refs.antiaim.yaw_base, "Local view")
               ui.set(refs.antiaim.yaw[1], "Off")
               ui.set(refs.antiaim.yaw[2], 180)
               c.allow_send_packet = true
               c.no_choke = true
               return
           end
   elseif not ui.get(drop_nades_to_fit) and not var.drop_nades_once  then
           var.drop_nades_once = true
   end


local fs_e = ui.get(anti_aim[0].freestand[2]) and ui.get(anti_aim[0].freestand[1])  and contains(anti_aim[0].aa_ditionals,"Freestand")  and var.manual_dir == "back"



if ui.get(anti_aim[var.p_state].yaw_tickbase_def) and ui.get(anti_aim[15].enable)  then
   if  ui.get(anti_aim[var.p_state].yaw_tickbase_def_method) ==     "Always on"   then 
       c.force_defensive = true
   elseif  ui.get(anti_aim[var.p_state].yaw_tickbase_def_method) ==     "Airtick switcher" then 
       local send_packet = run_fakelag(c)
       if  send_packet and  air then
           c.force_defensive = true
           c.allow_shift_tickbase = globals.tickcount() % math.random(6, 7.5) == 0 and false or true
       end
   elseif  ui.get(anti_aim[var.p_state].yaw_tickbase_def_method) ==     "Switch cycle" then 
       ticks = globals.tickcount()
       if ticks % 3 == 1 then
           c.force_defensive = false
           c.allow_shift_tickbase =  false
       end
       c.force_defensive = ticks % 3 ~= 1
   elseif  ui.get(anti_aim[var.p_state].yaw_tickbase_def_method) ==     "Second Pitch" then  
       if  c.chokedcommands < 1 then
           c.force_defensive = true
           if globals.tickcount() - var.cache.data.defensive_work_now >= 0 and globals.tickcount() - var.cache.data.defensive_work_now < 3 then
               ui.set(refs.antiaim.pitch, "Custom")
               ui.set(refs.antiaim.pitch_val,ui.get(anti_aim[var.p_state].yaw_tickbase_def_mode_pitch1))
               
           else
               ui.set(refs.antiaim.pitch, "Custom")
               ui.set(refs.antiaim.pitch_val, ui.get(anti_aim[var.p_state].yaw_tickbase_def_mode_pitch2))
           end
       end
   end
   var.p_state_before_defensive = var.p_state
   if var.cache.data ~= nil then
   if var.cache.data.defensive_active then
       var.p_state = 15
   end
   end
end
if ui.get(anti_aim[var.p_state_before_defensive].yaw_tickbase_def_method) ==     "Second Pitch" then
   ui.set(refs.antiaim.pitch, "Minimal")
else
ui.set(refs.antiaim.pitch, ui.get(anti_aim[var.p_state].pitch))
ui.set(refs.antiaim.pitch_val, ui.get(anti_aim[var.p_state].pitch_val))
end
ui.set(refs.antiaim.yaw_jitter[1], ui.get(anti_aim[var.p_state].yawjitter))
ui.set(refs.antiaim.yaw_jitter[2], ui.get(anti_aim[var.p_state].yawjitteradd))
if ui.get(anti_aim[var.p_state_before_defensive].yaw_tickbase_def_method) == "Second Pitch" then
   ui.set(refs.antiaim.body_yaw[1], "Off")
   ui.set(refs.antiaim.yaw[2], 0+yaw_to_add)
else
   ui.set(refs.antiaim.body_yaw[1], ui.get(anti_aim[var.p_state].gs_bodyyaw))
end

ui.set(refs.antiaim.freestanding_body_yaw, ui.get(anti_aim[var.p_state].gs_freestanding_body))
ui.set(refs.antiaim.yaw_base, var.aa_dir == 0 and ui.get(anti_aim[var.p_state].yawbase) or var.aa_dir == 180 and ui.get(anti_aim[var.p_state].yawbase) or "Local view")
ui.set(refs.antiaim.yaw[1], ui.get(anti_aim[var.p_state].yaw))
if ui.get(anti_aim[var.p_state_before_defensive].yaw_tickbase_def_method) == "Random yaw + force" then
c.force_defensive = true
end


   if ui.get(anti_aim[var.p_state].yaw_xway)  == "Delayed Switch Yaw" then

              local sided = flick_handler(
               ui.get(anti_aim[var.p_state].yawadd_l),
                ui.get(anti_aim[var.p_state].yawadd_r),
                ui.get(anti_aim[var.p_state].yaw_xway_delay),
                 globals.tickcount()
                )
                val_yaw = normalize_yaw(sided+yaw_to_add)
               
               if (ui.get(anti_aim[var.p_state_before_defensive].yaw_tickbase_def_method) == "Random yaw" or ui.get(anti_aim[var.p_state_before_defensive].yaw_tickbase_def_method) == "Random yaw + force") and var.p_state == 15 then
               local randomyaw = client.random_int(69,169)
               c.yaw = clamp360((globals.tickcount() % 6 < 3 and randomyaw or -randomyaw) + yaw_to_add)
               elseif  ui.get(anti_aim[var.p_state_before_defensive].yaw_tickbase_def_method) == "Second Pitch" then
               ui.set(refs.antiaim.yaw[2], normalize_yaw(0+yaw_to_add))
               else
                   ui.set(refs.antiaim.yaw[2], val_yaw)
               end

               if ui.get(anti_aim[var.p_state].yaw_xway_desync) == "Default" then
                   ui.set(refs.antiaim.body_yaw[2], val_yaw)
               elseif ui.get(anti_aim[var.p_state].yaw_xway_desync) == "Invert" then
                   ui.set(refs.antiaim.body_yaw[2], val_yaw*-1)
               elseif ui.get(anti_aim[var.p_state].yaw_xway_desync) == "Agressive (Positive)" then
                   ui.set(refs.antiaim.body_yaw[2], clamp(-180,180,val_yaw*2))
               elseif ui.get(anti_aim[var.p_state].yaw_xway_desync) == "Agressive (Negative)" then
                   ui.set(refs.antiaim.body_yaw[2], clamp(-180,180,val_yaw/2))
               elseif ui.get(anti_aim[var.p_state].yaw_xway_desync) == "VINV" then
                   if val_yaw >= 0 then
                   ui.set(refs.antiaim.body_yaw[2], -58)
                   else
                   ui.set(refs.antiaim.body_yaw[2], 58)
                   end
               elseif ui.get(anti_aim[var.p_state].yaw_xway_desync) == "VDEF" then
                   if val_yaw <= 0 then
                       ui.set(refs.antiaim.body_yaw[2], -58)
                       else
                       ui.set(refs.antiaim.body_yaw[2], 58)
                       end
               end
             
   elseif  not ( ui.get(anti_aim[var.p_state].yaw_xway)  == "Delayed Switch Yaw" ) then
            yaw_val = yaw_handler(ui.get(anti_aim[var.p_state].yawadd_l), ui.get(anti_aim[var.p_state].yawadd_r)) -- new
            ui.set(refs.antiaim.body_yaw[2], ui.get(anti_aim[var.p_state].gs_bodyyawadd))
   end

       if  ui.get(anti_aim[var.p_state].yaw_xway) == "5 Way (offset)"    then
               yaw_val = yaw_val*var.way5[globals.tickcount()%#var.way5+1]
       elseif ui.get(anti_aim[var.p_state].yaw_xway)  == "3 Way (offset)" then
               yaw_val = yaw_val*var.way3[globals.tickcount()%#var.way3+1]
       elseif contains(anti_aim[var.p_state].yaw_xway, "4 Way (offset)") then
               yaw_val = yaw_val*var.way3_rev[globals.tickcount()%#var.way3_rev+1]
       elseif ui.get(anti_aim[var.p_state].yaw_xway)  == "Custom 3 Way" then
                   ticks =  globals.tickcount()%3
                   if ticks == 0 then
                   yaw_val = ui.get(anti_aim[var.p_state].yaw_sliderways.w1)
                   elseif ticks == 1 then
                   yaw_val = ui.get(anti_aim[var.p_state].yaw_sliderways.w2)
                   elseif ticks == 2 then
                   yaw_val = ui.get(anti_aim[var.p_state].yaw_sliderways.w3)
                   end
       elseif ui.get(anti_aim[var.p_state].yaw_xway)  =="Custom 4 Way" then
                       ticks =  globals.tickcount()%4
                           if ticks == 0 then
                           yaw_val = ui.get(anti_aim[var.p_state].yaw_sliderways.w1)
                           elseif ticks == 1 then
                           yaw_val = ui.get(anti_aim[var.p_state].yaw_sliderways.w2)
                           elseif ticks == 2 then
                           yaw_val = ui.get(anti_aim[var.p_state].yaw_sliderways.w3)
                           elseif ticks == 3 then
                           yaw_val = ui.get(anti_aim[var.p_state].yaw_sliderways.w4)
                           end
       elseif ui.get(anti_aim[var.p_state].yaw_xway)  == "Custom 5 Way" then
               ticks =  globals.tickcount()%5
                   if ticks == 0 then
                   yaw_val = ui.get(anti_aim[var.p_state].yaw_sliderways.w1)
                   elseif ticks == 1 then
                   yaw_val = ui.get(anti_aim[var.p_state].yaw_sliderways.w2)
                   elseif ticks == 2 then
                   yaw_val = ui.get(anti_aim[var.p_state].yaw_sliderways.w3)
                   elseif ticks == 3 then
                   yaw_val = ui.get(anti_aim[var.p_state].yaw_sliderways.w4)
                   elseif ticks == 4 then
                   yaw_val = ui.get(anti_aim[var.p_state].yaw_sliderways.w5)
                   end
       end

       if not (  ui.get(anti_aim[var.p_state].yaw_xway)  == "Delayed Switch Yaw" ) then
           if (ui.get(anti_aim[var.p_state_before_defensive].yaw_tickbase_def_method) == "Random yaw" or ui.get(anti_aim[var.p_state_before_defensive].yaw_tickbase_def_method) == "Random yaw + force") and var.p_state == 15 then
               local randomyaw = client.random_int(69,169)
               c.yaw = clamp360((globals.tickcount() % 6 < 3 and randomyaw or -randomyaw) + yaw_to_add)
           elseif  ui.get(anti_aim[var.p_state_before_defensive].yaw_tickbase_def_method) == "Second Pitch" then
               ui.set(refs.antiaim.yaw[2], normalize_yaw(0+yaw_to_add))
           else
            ui.set(refs.antiaim.yaw[2], normalize_yaw(yaw_val+yaw_to_add))
           end
       end 
       
   

set_og_menu(false)    
end

local function ist()
if ui.get(refs.antiaim.roll)~=0 then
renderer.indicator(123, 194, 21, 255, "ROLL")
end

if ui.get(anti_aim[0].edge[2]) and ui.get(anti_aim[0].edge[1]) then
renderer.indicator(255, 255, 255, 255,  "EDGE") 
end


if to_draw == "yes" and ui.get(refs.ragebot.double_tap[2]) and ui.get(refs.ragebot.double_tap[1]) then
to_draw_ticks = to_draw_ticks + 1
   if to_draw_ticks == 27 then
       to_draw_ticks = 0
       to_up = "no"
   end
end

end

client.set_event_callback("paint", ist)



function data:handle_setup_command(e, LocalPlayer, weapon)

if var.is_mm_state == 1 then
   if ui.get(refs.misc.sv_maxusrcmdprocessticks) ~= 7 then
       if ui.get(refs.fakelag.limit) > 6 then
           return_fl = ui.get(refs.fakelag.limit)
           ui.set(refs.fakelag.limit, 6)
       end
       ui.set(refs.misc.sv_maxusrcmdprocessticks, 7)
   end
else
   if return_fl ~= nil then
       if ui.get(refs.fakelag.limit) ~= return_fl then
           ui.set(refs.fakelag.limit, return_fl)
           return_fl = nil
       end
   end
   if ui.get(refs.misc.sv_maxusrcmdprocessticks) < 16 then
       ui.set(refs.misc.sv_maxusrcmdprocessticks, 16)
   end
end
local roll_enabled_now =   
ui.get(anti_aim[var.p_state].roll_enabled) and
ui.get(anti_aim[var.p_state].roll_enabled_hk) 


if weapon == nil then goto skip end
   if roll_enabled_now then
       ui.set(refs.antiaim.roll, ui.get(anti_aim[var.p_state].roll_inverter) and -ui.get(anti_aim[var.p_state].roll_sk) or ui.get(anti_aim[var.p_state].roll_sk))
   else
       ui.set(refs.antiaim.roll,0)
   end
   e.roll = ui.get(refs.antiaim.roll)
   if ent_state.is_ladder(LocalPlayer) or weapon.type == "grenade"   or not ui.get(refs.antiaim.enabled) then 
       e.roll = 0
   end
::skip::
--Spoofs Client to use Roll in MM
local is_mm_value = ffi_cast("bool*", gamerules[0] + 124)
       if is_mm_value ~= nil then
           if roll_enabled_now  then
                if is_mm_value[0] == true then
                   is_mm_value[0] = 0
                   var.is_mm_state = 1
               end
           else
               if is_mm_value[0] == false and var.is_mm_state == 1 then
                   -- not valve but spoofed
                   e.roll = 0
               end
           end
       end
end


local post_config_load = false
local jiiter_have = false
local function wait_load_end(e)
   post_config_load = true
   jiiter_have = true
end
local function wait_load_start(e)
   post_config_load = false
   jiiter_have = false
end

client.set_event_callback('pre_config_load', wait_load_start)
client.set_event_callback('post_config_load', wait_load_end)


client.set_event_callback("paint_ui", function()

   if globals.mapname() == nil and entity.get_local_player() == nil then
       var.is_mm_state = 0
       if ui.get(refs.misc.sv_maxusrcmdprocessticks) < 16 then
           ui.set(refs.misc.sv_maxusrcmdprocessticks, 16)
       end
       if return_fl ~= nil then
           if ui.get(refs.fakelag.limit) ~= return_fl then
               ui.set(refs.fakelag.limit, return_fl)
               return_fl = nil
           end
       end
   end
   if ui.is_menu_open() then
       if ui.get(refs.misc.sv_maxusrcmdprocessticks) < 16 then
           ui.set(refs.misc.sv_maxusrcmdprocessticks, 16)
       end
   end
end)


local function handle_callbacks()
ui.set_callback(anti_aim[0].anti_aim_mode, handle_menu)
ui.set_callback(anti_aim[0].player_state, handle_menu)

for i = 1, 19 do
ui.set_callback(anti_aim[i].enable, handle_menu)
ui.set_callback(anti_aim[i].pitch, handle_menu)
ui.set_callback(anti_aim[i].pitch_val, handle_menu)
ui.set_callback(anti_aim[i].yawbase, handle_menu)
ui.set_callback(anti_aim[i].yaw, handle_menu)
ui.set_callback(anti_aim[i].yawadd_r, handle_menu)
ui.set_callback(anti_aim[i].yawadd_l, handle_menu)
ui.set_callback(anti_aim[i].yawjitter, handle_menu)
ui.set_callback(anti_aim[i].yawjitteradd, handle_menu)
ui.set_callback(anti_aim[i].gs_bodyyaw, handle_menu)
ui.set_callback(anti_aim[i].gs_bodyyawadd, handle_menu)
ui.set_callback(anti_aim[i].gs_freestanding_body, handle_menu)
ui.set_callback(anti_aim[i].roll_sk, handle_menu)
ui.set_callback(anti_aim[i].yaw_xway, handle_menu)


ui.set_callback(anti_aim[i].yaw_tickbase_def, handle_menu)
ui.set_callback(anti_aim[i].yaw_tickbase_def_method,handle_menu)
ui.set_callback(anti_aim[i].yaw_tickbase_def_mode,handle_menu)
ui.set_callback(anti_aim[i].yaw_tickbase_def_ping_related,handle_menu)


ui.set_callback(anti_aim[i].yaw_tickbase_def_mode_sen_end, handle_menu )
ui.set_callback(anti_aim[i].yaw_tickbase_def_mode_del_slider, handle_menu )
ui.set_callback(anti_aim[i].yaw_tickbase_def_mode_pitch1, handle_menu) 
ui.set_callback(anti_aim[i].yaw_tickbase_def_mode_pitch2, handle_menu )



ui.set_callback(anti_aim[i].yaw_sliderways.w1, handle_menu)
ui.set_callback(anti_aim[i].yaw_sliderways.w2, handle_menu)
ui.set_callback(anti_aim[i].yaw_sliderways.w3, handle_menu)
ui.set_callback(anti_aim[i].yaw_sliderways.w4, handle_menu)
ui.set_callback(anti_aim[i].yaw_sliderways.w5, handle_menu)

ui.set_callback(anti_aim[i].roll_enabled, handle_menu)
ui.set_callback(anti_aim[i].roll_enabled_hk, handle_menu)
ui.set_callback(anti_aim[i].roll_inverter , handle_menu)

end

ui.set_callback(anti_aim[0].aa_ditionals, handle_menu)
ui.set_callback(anti_aim[0].freestand[1], handle_menu)
ui.set_callback(anti_aim[0].edge[1], handle_menu)
ui.set_callback(anti_aim[0].freestand[2], handle_menu)
ui.set_callback(anti_aim[0].edge[2], handle_menu)
ui.set_callback(anti_aim[0].manual_left, handle_menu)
ui.set_callback(anti_aim[0].manual_right, handle_menu)
ui.set_callback(anti_aim[0].manual_forward, handle_menu)



ui.set_callback(anti_aim[20].anti_knifebot, handle_menu)
ui.set_callback(anti_aim[20].dt_teleport, handle_menu)


ui.set_callback(anti_aim[20].dt_teleport_opts, handle_menu)

ui.set_callback(anti_aim[20].dt_teleport_damage_opts     , handle_menu)
ui.set_callback(anti_aim[20].dt_teleport_delay_opts      , handle_menu)
ui.set_callback(anti_aim[20].dt_teleport_damage_slider   , handle_menu)
ui.set_callback(anti_aim[20].dt_teleport_delay_slider    , handle_menu)
ui.set_callback(anti_aim[20].dt_teleport_velocity_slider , handle_menu)
ui.set_callback(anti_aim[20].custom_resolver, handle_menu)

ui.set_callback(anti_aim[20].anti_knifebot_pistal, handle_menu)
ui.set_callback(anti_aim[20].anti_knifebot_pistal_slider, handle_menu)
ui.set_callback(anti_aim[20].anti_knifebot_slider, handle_menu)
ui.set_callback(anti_aim[20].visual_dmg, handle_menu)
ui.set_callback(anti_aim[20].visual_dmg_safe, handle_menu)


ui.set_callback(bs_ind_fist_color, 	handle_menu)
ui.set_callback(bs_ind_second_color,handle_menu)

ui.set_callback(bs_ind_debug_lines,handle_menu)
ui.set_callback(blur_menu,handle_menu)
ui.set_callback(blur_color,handle_menu)


ui.set_callback(menu.style,handle_menu)
ui.set_callback(menu.type,handle_menu)
ui.set_callback(menu.chosez,handle_menu)


ui.set_callback(disable_fl_onshot,handle_menu)
ui.set_callback(disable_fl_onshot_disablers,handle_menu )



ui.set_callback(fast_ladder_on,handle_menu)
ui.set_callback(drop_nades_to_fit,handle_menu)


ui.set_callback(enabler,handle_menu)
ui.set_callback(clantag,handle_menu)
ui.set_callback(old_anims,handle_menu)
ui.set_callback(Debug_panel,handle_menu)
ui.set_callback(ms_color,handle_menu)
ui.set_callback(Debug_panel_selector,handle_menu)

ui.set_callback(misc_expoloit,handle_menu)
--ui.set_callback(break_lagcomp,handle_menu)
--ui.set_callback(break_lagcomp_jitter,handle_menu)
--ui.set_callback(break_lagcomp_jitter_slider,handle_menu)



ui.set_callback(anim_ind,handle_menu)
ui.set_callback(custom_logs,handle_menu)
ui.set_callback(color_label,handle_menu)
ui.set_callback(color,handle_menu)
ui.set_callback(color_label2,handle_menu)
ui.set_callback(color2,handle_menu)
ui.set_callback(color_label1,handle_menu)
ui.set_callback(color1,handle_menu)

ui.set_callback(anti_aim[0].anti_aim_mode,function()

handle_menu()
end)

ui.set_callback(lua_tabs, handle_menu)
client.set_event_callback("shutdown",function()
set_og_menu(true)

if ui.get(refs.misc.sv_maxusrcmdprocessticks) < 16 then
   ui.set(refs.misc.sv_maxusrcmdprocessticks, 16)
end
if return_fl ~= nil then
   if ui.get(refs.fakelag.limit) ~= return_fl then
       ui.set(refs.fakelag.limit, return_fl)
   end
end
if globals.mapname() == nil then 
   var.is_mm_state = 0
   return
end

local is_mm_value = ffi_cast("bool*", gamerules[0] + 124)
   if is_mm_value ~= nil then
       if is_mm_value[0] == false and var.is_mm_state == 1 then
           is_mm_value[0] = 1
           var.is_mm_state = 0
       end
   end
end)

client.set_event_callback("setup_command", on_setup_command)

end

handle_callbacks()
end

--if menu then blur
local x, y = client.screen_size()
local function paint()
   local r,g,b,a = ui.get(blur_color)
   if ui.is_menu_open() and ui.get(blur_menu) then
       renderer.blur(0,0,x,y)
       renderer.rectangle(0,0,x,y,r,g,b,a)
   end
end
client.set_event_callback("paint", paint)



local indicator_script = function () --indicator

   local custom_refs = {}
   local mindmg = pcall(ui.reference, 'Rage', 'Other', 'Override damage')
   local minhc = pcall(ui.reference, 'Rage', 'Other', 'Minimum hit chance override')
   local dorm_a =  pcall(ui.reference ,"RAGE", "Aimbot", "Dormant aimbot")

   local scope =  pcall(ui.reference, 'Rage', 'Other', 'Noscope key')
   local timecheckind = false
   local function check_pcall(text)
   mindmg = pcall(ui.reference, 'Rage', 'Other', 'Override damage')
   minhc = pcall(ui.reference, 'Rage', 'Other', 'Minimum hit chance override')
   
   scope =  pcall(ui.reference, 'Rage', 'Other', 'Noscope key')
   utils =  pcall(ui.reference, 'AA', 'Anti-aimbot angles', 'Utilities')
   timecheckind = true
       if mindmg then
       custom_refs.mindmgdmg = {ui.reference('Rage', 'Other', 'Override damage')}
       end
       if minhc then
       custom_refs.minhcact = {ui.reference('Rage', 'Other', 'Minimum hit chance override')}
       end

       if scope then
       custom_refs.scope = {ui.reference('Rage', 'Other', 'Noscope key')}
       custom_refs.utils = ui.reference('AA', 'Anti-aimbot angles', 'Utilities')
       end

   end
   client.delay_call(1, check_pcall)
   client.delay_call(5, check_pcall)
   client.delay_call(20, check_pcall)
   client.delay_call(60, check_pcall)
   local bottom_indicators = {}

   local function indicators_override(indicator)
       bottom_indicators[indicator.text] = {
           indicator.r, indicator.g, indicator.b, indicator.a,
           }
   end
   local f = {ipairs = ipairs, assert = assert, pairs = pairs, pcall = pcall, error = error, next = next, tostring = tostring, unpack = unpack}

   local function contains(tab, val)
       for key, value in f.ipairs(tab) do
           if value == val then
               return true
           end
       end
       return false
       end
       

--old anim

function legfucker( )
   local z = math.random( 1, 3 )
   if z == 1 then
       ui.set( refs.antiaim.leg_movement, "Always slide" )
   elseif z == 2 then
       ui.set( refs.antiaim.leg_movement, "Never slide" )
   elseif z == 3 then
       ui.set( refs.antiaim.leg_movement, "Always slide" )
   end
end

local ground_ticks, end_time = 1, 0
client.set_event_callback("pre_render", function()
   local localplayer = entity.get_local_player( )
   if localplayer == nil then return end
   if contains(ui.get(old_anims),"Static legs") then
       entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
   end
   if contains(ui.get(old_anims),"Pitch 0") then
       local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)

       if on_ground == 1 then
           ground_ticks = ground_ticks + 1
       else
           ground_ticks = 0
           end_time = globals.curtime() + 1
       end
  
       if ground_ticks > ui.get(refs.fakelag.limit)+1 and end_time > globals.curtime() then
           entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
       end
   end
   if contains(ui.get(old_anims),"Leg movement") then
       legfucker()
       entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
   end
end)
--debug
local fakelag_maximum, choked_ticks, choked_ticks_max, choked_ticks_prev = 14, 0, 0, 0
client.set_event_callback('run_command', function(e)
choked_ticks = e.chokedcommands
   if choked_ticks_prev >= choked_ticks or choked_ticks == 0 then
   choked_ticks_max = choked_ticks_prev
   end
choked_ticks_prev = choked_ticks
end)


local bit_band, bit_lshift, client_color_log, client_create_interface, client_delay_call, client_find_signature, client_key_state, client_reload_active_scripts, client_screen_size, client_set_event_callback, client_system_time, client_timestamp, client_unset_event_callback, database_read, database_write, entity_get_classname, entity_get_local_player, entity_get_origin, entity_get_player_name, entity_get_prop, entity_get_steam64, entity_is_alive, globals_framecount, globals_realtime, math_ceil, math_floor, math_max, math_min, panorama_loadstring, renderer_gradient, renderer_line, renderer_rectangle, table_concat, table_insert, table_remove, table_sort, ui_get, ui_is_menu_open, ui_mouse_position, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_slider, ui_set, ui_set_visible, setmetatable, pairs, error, globals_absoluteframetime, globals_curtime, globals_frametime, globals_maxplayers, globals_tickcount, globals_tickinterval, math_abs, type, pcall, renderer_circle_outline, renderer_load_rgba, renderer_measure_text, renderer_text, renderer_texture, tostring, ui_name, ui_new_button, ui_new_hotkey, ui_new_label, ui_new_listbox, ui_new_textbox, ui_reference, ui_set_callback, ui_update, unpack, tonumber = bit.band, bit.lshift, client.color_log, client.create_interface, client.delay_call, client.find_signature, client.key_state, client.reload_active_scripts, client.screen_size, client.set_event_callback, client.system_time, client.timestamp, client.unset_event_callback, database.read, database.write, entity.get_classname, entity.get_local_player, entity.get_origin, entity.get_player_name, entity.get_prop, entity.get_steam64, entity.is_alive, globals.framecount, globals.realtime, math.ceil, math.floor, math.max, math.min, panorama.loadstring, renderer.gradient, renderer.line, renderer.rectangle, table.concat, table.insert, table.remove, table.sort, ui.get, ui.is_menu_open, ui.mouse_position, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_slider, ui.set, ui.set_visible, setmetatable, pairs, error, globals.absoluteframetime, globals.curtime, globals.frametime, globals.maxplayers, globals.tickcount, globals.tickinterval, math.abs, type, pcall, renderer.circle_outline, renderer.load_rgba, renderer.measure_text, renderer.text, renderer.texture, tostring, ui.name, ui.new_button, ui.new_hotkey, ui.new_label, ui.new_listbox, ui.new_textbox, ui.reference, ui.set_callback, ui.update, unpack, tonumber
local client_set_event_callback, client_unset_event_callback, client_log, client_color_log, client_screensize, client_draw_indicator, client_draw_text = client.set_event_callback, client.unset_event_callback, client.log, client.color_log, client.screen_size, client.draw_indicator, client.draw_text
local scrsize_x, scrsize_y = client_screensize( )
local center_x, center_y = scrsize_x - 100, scrsize_y/2 + 900
local scrleft_x, scrleft_y = (( scrsize_x-scrsize_x ) +1 ), (( scrsize_y-scrsize_y ) +1)


local function draw_gradient( ctx, x, y, w, h, r3,g3,b3,a3, r2, g2, b2, a2, ltr )
   client.draw_gradient( ctx, x, y, w, h, r3,g3,b3,a3, r2, g2, b2, a2, ltr )
end

local images = require "gamesense/images"
local js = panorama.open()

local logo = string.upper("bs.tech")
local build = string.upper("\aFFFFFFFF[Debug]")

local x, x2 = 18, 1
local function Debug_panelx()
   local steamid64 = js.MyPersonaAPI.GetXuid()
   local avatar = images.get_steam_avatar(steamid64)

   local get_name = panorama_loadstring([[ return MyPersonaAPI.GetName() ]])
   local nickname = string.upper(get_name())
   local aa_state = string.upper(var.player_pos[var.p_state])
   local fl = string.upper(ui.get(refs.fakelag.limit))
   local r, g, b, a = ui.get(ms_color)

   
   if ui.get(Debug_panel) == "v1" then
       draw_gradient( c, center_x, scrsize_y - 555, -120, x, r, g, b, a,  r, g, b , 0, true) --сам градиент
       draw_gradient( c, center_x, scrsize_y - 555, 120, x, r, g, b, a,  r, g, b, 0, true)

       draw_gradient( c, center_x, scrsize_y - 555, -120, x2, r, g, b, 120,  r, g, b , 0, true)
       draw_gradient( c, center_x, scrsize_y - 555, 120, x2, r, g, b, 120,  r, g, b , 0, true) --полоски
       
       avatar:draw(center_x - 98, scrsize_y - 554, 16)

       renderer.text(center_x + 5, scrsize_y - 546, r, g, b, 235 , "-c", 0, logo .. "   " .. build .. "    " .. nickname .. "    /" .. aa_state.."/")
   end 

   if ui.get(Debug_panel) == "v2" then
       local a = 255 + (0 - 255) * 0.04 * (globals.absoluteframetime() * 100)
       local realtime = globals.realtime() % 2
       local alpha = math.floor(math.sin(realtime * 2) * (a/2-1) + a/2)	
       local offset = 0
       local spacing = 10
       local multiplier = 0
       
       if contains(ui.get(Debug_panel_selector),"Logo") then 
           offset = spacing * multiplier
           multiplier = multiplier + 1
           renderer.text( 10 , scrsize_y/2 + offset, r, g, b, a , "-l", 0, "BS  ANTI-AIM  \aFFFFFFFFSYSTEM ")
       end 
       if contains(ui.get(Debug_panel_selector),"Name") then 
           offset = spacing * multiplier
           multiplier = multiplier + 1
           renderer.text( 10 , scrsize_y/2 + offset, r, g, b, a , "-l", 0, "NAME:  \aFFFFFFFF" .. string.upper(nickname))
       end 
       if contains(ui.get(Debug_panel_selector),"Build") then 
           offset = spacing * multiplier
           multiplier = multiplier + 1
           renderer.text( 10 , scrsize_y/2 + offset, r, g, b, a, "-l", 0, "BUILD:")
           renderer.text( 35 , scrsize_y/2 + offset, 255, 255, 255, alpha, "-l", 0, "Debug")
       end
       if contains(ui.get(Debug_panel_selector),"Anti-aim state") then 
           offset = spacing * multiplier
           multiplier = multiplier + 1
           renderer.text( 10 , scrsize_y/2 + offset, r, g, b, a , "-l", 0, "ANTI-AIM   STATE:   \aFFFFFFFF" .. string.upper(aa_state))
       end
       if contains(ui.get(Debug_panel_selector),"Fake Lag") then 
           offset = spacing * multiplier
           multiplier = multiplier + 1
           renderer.text( 10 , scrsize_y/2 + offset, r, g, b, a , "-l", 0, "FAKE   LAG:   \aFFFFFFFF" .. choked_ticks_max)
       end
   end 
end
client.set_event_callback("paint", Debug_panelx)   
   local render_line = function(ent, yaw, dst, clr)
   local origin = vector(ent:get_origin())
   local x1, y1 = renderer.world_to_screen(origin:unpack()) 
   local angle = origin + vector():init_from_angles(0, yaw) * dst
   local x2, y2 = renderer.world_to_screen(angle:unpack())
   local angle2 = origin + vector():init_from_angles(0, yaw) * dst
   renderer.line(x1, y1, x2, y2, clr[1], clr[2], clr[3], clr[4])
end


local function gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
   local output = ''

   local len = #text-1

   local rinc = (r2 - r1) / len
   local ginc = (g2 - g1) / len
   local binc = (b2 - b1) / len
   local ainc = (a2 - a1) / len

   for i=1, len+1 do

       output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))

       r1 = r1 + rinc

       g1 = g1 + ginc
       b1 = b1 + binc
       a1 = a1 + ainc
   end

   return output
end


function render:lerp(start, vend, time)
   return start + (vend - start) * time
end
local add_x = 0
local alpha = 0

client.set_event_callback('paint', function(e)
   menu.getstyle = ui.get(menu.style)
   menu.gettype = ui.get(menu.type)
   menu.getchosez = ui.get(menu.chosez)

   if not timecheckind then return end
   local body_yaw2 = ' '..string.format('%.1f',math.max(-57, math.min(60, (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) or 0)*120-60+0.5)))..""
   local body2 = {} body2.x, body2.y =  renderer.measure_text('cb', body_yaw2)

   local me = entity_lib.get_local_player()
   if not entity_lib.is_alive(me) then
       return
   end
   local alpha = math.floor(math.sin(math.abs(-math.pi + (globals_curtime() * (1.25 / .75)) % (math.pi * 2))) * 8)
   if alpha <= 1 then
       alpha = 1
   end
   local wpn_id = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_iItemDefinitionIndex")
   local weapons = wpn_id ~= nil and bit.band(wpn_id, 0xFFFF) or 0
   if weapons == nil or wpn_id == nil then
       return
   end
   local is_scoped = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_zoomLevel" )
   local is_knife =wpn_id >= 500 and wpn_id <= 525 or wpn_id == 41 or wpn_id == 42 or wpn_id == 59

if menu.gettype == "Centered" then
   client.set_event_callback('indicator', indicators_override)

   local sc = {client_screen_size()}
   local cx,cy = sc[1]/2,sc[2]/2
   local rr, gg, bb, aa = ui.get(bs_ind_fist_color)
   local r1, g1, b1, a1 = ui.get(bs_ind_second_color)
   local offset = 0
   local spacing = 10
   local multiplier = 0

   if menu.getstyle == "Minimalistic" then
       if  ui.get(anim_ind) and is_scoped ~= 0 and not is_knife then   
           add_x = render:lerp(add_x,30,globals.frametime() * 6)
       else
           add_x = render:lerp(add_x,0,globals.frametime() * 8)
       end
       
       if var.manual_dir == "left" then
           renderer.text(cx  - 35, cy + 0 + offset, rr, gg, bb, aa, "cb", 0, "<" )
       elseif var.manual_dir == "right" then
           renderer.text(cx  + 35, cy + 0 + offset, rr, gg, bb, aa, "cb", 0, ">" )
       end

       renderer.text(cx + math.floor(add_x) , cy + 30 + offset, 255, 255, 255, 255, "-c", 0, body_yaw2.."")
       offset = spacing * multiplier
       multiplier = multiplier + 1


       offset = spacing * multiplier
       multiplier = multiplier + 1        
       if  not ui.get (refs.ragebot.duck_peek_assist) and not ui.get(refs.antiaim.slow_motion[2])  and not ui.get(refs.antiaim.edge_yaw) then
           renderer.text(cx  + math.floor(add_x), cy + 10 + offset,  rr, gg, bb, aa, "-c", 0,"", tostring(var.player_pos[var.p_state]):upper())
       end 

       if ui.get(refs.ragebot.duck_peek_assist)  then
           renderer.text(cx  + math.floor(add_x), cy + 20 + offset,  255, 255, 255, 255, '-c', 0, "FD")
           offset = spacing * multiplier
           multiplier = multiplier + 1
       end 

       if contains(ui.get(menu.chosez),"Doubletap") and ui.get(refs.ragebot.double_tap[2])  and not ui.get(refs.ragebot.duck_peek_assist) then
           if bottom_indicators["DT"] == nil then return end
           renderer.text(cx + math.floor(add_x), cy + 30 + offset, bottom_indicators['DT'][1],bottom_indicators['DT'][2],bottom_indicators['DT'][3],235, "-c", 0, "DT")
           offset = spacing * multiplier
           multiplier = multiplier + 1    
       end

       if ui.get(refs.antiaim.hide_shots[1]) and ui.get(refs.antiaim.hide_shots[2]) and not ui.get(refs.ragebot.duck_peek_assist) then
           renderer.text(cx  + math.floor(add_x), cy + 30 + offset,  255, 255, 255, 255, '-c', 0, "OS")
           offset = spacing * multiplier
           multiplier = multiplier + 1
       end

       if (ui.get(refs.antiaim.freestanding[1]) and ui.get(refs.antiaim.freestanding[2]))  and not ui.get (refs.ragebot.duck_peek_assist) and not ui.get (refs.antiaim.slow_motion[2]) then
           renderer.text(cx  + math.floor(add_x), cy + 30 + offset,  255, 255, 255, 255, '-c', 0, "FS")
           offset = spacing * multiplier
           multiplier = multiplier + 1
       end

       if ui.get(refs.antiaim.slow_motion[2]) and not ui.get (refs.ragebot.duck_peek_assist)  then
           renderer.text(cx + math.floor(add_x), cy + 30 + offset,  255, 255, 255, alpha, '-c', 0, "SLOW")
           offset = spacing * multiplier
           multiplier = multiplier + 1
       end

       if ui.get(refs.antiaim.edge_yaw) and not (ui.get(refs.antiaim.freestanding[1]) and ui.get(refs.antiaim.freestanding[2])) and not ui.get (refs.ragebot.duck_peek_assist) then
           renderer.text(cx + math.floor(add_x) , cy + 30 + offset, 255,255,255, alpha, '-c', 0, "EDGE")
           offset = spacing * multiplier
           multiplier = multiplier + 1
       end

       if ui.get(refs.antiaim.roll)~=0 and not ui.get (refs.ragebot.duck_peek_assist) then
           renderer.text(cx + math.floor(add_x) , cy + 30 + offset,  255, 255, 255, alpha, '-c', 0, "ROLL")
           offset = spacing * multiplier
           multiplier = multiplier + 1
       end

       if ui.get(refs.ragebot.force_body_aim)  then
           renderer.text(cx  + math.floor(add_x), cy + 30 + offset,  255, 0, 0, 255, '-c', 0, "BAIM")
           offset = spacing * multiplier
           multiplier = multiplier + 1
       end

       if ui.get(refs.ragebot.minimum_damage_override[1]) and ui.get(refs.ragebot.minimum_damage_override[2]) then
           renderer.text(cx  + math.floor(add_x), cy + 30 + offset , 255,255,155,210 ,'-c', 0, 'DMG: '.. ui.get(refs.ragebot.minimum_damage_override[3]))
           offset = spacing * multiplier
           multiplier = multiplier + 1
       end
       if dorm_a then
           custom_refs.dormant = {ui.reference("RAGE", "Aimbot", "Dormant aimbot")}
           if ui.get(custom_refs.dormant[1]) and ui.get(custom_refs.dormant[2])  then
               renderer.text(cx  + math.floor(add_x), cy + 30 + offset , 255,255,155,210 ,'-c', 0, 'DA')
               offset = spacing * multiplier
               multiplier = multiplier + 1
           end
       end



       elseif menu.getstyle  == "Modern" then
           local rr, gg, bb, aa = ui.get(bs_ind_fist_color)
           local r1, g1, b1, a1 = ui.get(bs_ind_second_color)
       
           if ui.get(anim_ind) and is_scoped ~= 0 and not is_knife then   
               add_x = render:lerp(add_x,30,globals_frametime() * 6)
           else
               add_x = render:lerp(add_x,0,globals_frametime() * 8)
           end

           local logotip = gradient_text(rr, gg, bb, 255, r1, g1, b1, 255, ("bloodstone"))
           renderer.text(cx + math.floor(add_x), cy + 25 + offset, 255, 255, 255, 255, "c-", 0, string.upper(logotip))
           offset = spacing * multiplier

           if var.manual_dir == "left" then
               renderer.text(cx-45, cy, rr, gg, bb, aa, "cb", 0, "<")
           elseif var.manual_dir == "right" then
               renderer.text(cx+45, cy, rr, gg, bb, aa, "cb", 0, ">")
           end

           if contains(ui.get(menu.chosez),"Doubletap") and ui.get(refs.ragebot.double_tap[1]) and  ui.get(refs.ragebot.double_tap[2])  and not ui.get(refs.ragebot.duck_peek_assist) then
               offset = spacing * multiplier
               multiplier = multiplier + 1
               if bottom_indicators["DT"] == nil then return end
               renderer.text(cx + math.floor(add_x), cy + 35 + offset, bottom_indicators['DT'][1],bottom_indicators['DT'][2],bottom_indicators['DT'][3],230, "-c", 0, "DOUBLETAP")
           end

           if contains(ui.get(menu.chosez),"Onshot") and ui.get(refs.antiaim.hide_shots[2]) and not ui.get(refs.ragebot.duck_peek_assist) then
               offset = spacing * multiplier
               multiplier = multiplier + 1
               renderer.text(cx + math.floor(add_x), cy + 35 + offset, 144, 145, 178, 255, "-c", 0, "ONSHOT")
           end

           if contains(ui.get(menu.chosez),"Damage") and ui.get(refs.ragebot.minimum_damage_override[1]) and ui.get(refs.ragebot.minimum_damage_override[2]) then
               offset = spacing * multiplier
               multiplier = multiplier + 1
               renderer.text(cx + math.floor(add_x), cy + 35 + offset , 255,255,155,210,'-c', 0, 'DMG: '.. ui.get(refs.ragebot.minimum_damage_override[3]))
           end

           if contains(ui.get(menu.chosez),"Ping") and ui.get(refs.misc.ping_spike[2])  then
               offset = spacing * multiplier
               multiplier = multiplier + 1
               if bottom_indicators["PING"] == nil then return end
               renderer.text(cx + math.floor(add_x), cy + 35 + offset, bottom_indicators['PING'][1],bottom_indicators['PING'][2],bottom_indicators['PING'][3], 255, "-c", 0, "PING")
           end
       
           if contains(ui.get(menu.chosez),"Fake Duck") and ui.get(refs.ragebot.duck_peek_assist)  then
               offset = spacing * multiplier
               multiplier = multiplier + 1
               renderer.text(cx + math.floor(add_x), cy + 35 + offset,  255,255,255,230, "-c", 0, "DUCK")
           end
       
           if contains(ui.get(menu.chosez),"Freestand") and (ui.get(refs.antiaim.freestanding[1]) and ui.get(refs.antiaim.freestanding[2])) and not ui.get (refs.ragebot.duck_peek_assist) and not ui.get (refs.antiaim.slow_motion[2]) then
               offset = spacing * multiplier
               multiplier = multiplier + 1
               renderer.text(cx + math.floor(add_x), cy + 35 + offset, 255, 255, 255, 200, "-c", 0, "FS")
           end
       

           if contains(ui.get(menu.chosez),"Dormant") then
               if dorm_a then
                   custom_refs.dormant = {ui.reference("RAGE", "Aimbot", "Dormant aimbot")}
                   if ui.get(custom_refs.dormant[1]) and ui.get(custom_refs.dormant[2])  then
                       offset = spacing * multiplier
                       multiplier = multiplier + 1
                       renderer.text(cx + math.floor(add_x), cy + 35 + offset, 162,227,55, 255, "-c", 0, "DA")
                   end
               end
           end

           if contains(ui.get(menu.chosez),"Safe") and ui.get(refs.ragebot.force_safepoint)  then
               offset = spacing * multiplier
               multiplier = multiplier + 1
               renderer.text(cx + math.floor(add_x), cy + 35 + offset , 255, 255, 255, 200, "-c", 0, "SP")
           end
       
           if contains(ui.get(menu.chosez),"Baim") and ui.get(refs.ragebot.force_body_aim)  then
               offset = spacing * multiplier
               multiplier = multiplier + 1
               renderer.text(cx + math.floor(add_x), cy + 35 + offset, 255, 255, 255, 200, "-c", 0, "BA")
           end
         
           spacing = 10
           for n = 1, #bottom_indicators do
                   offset = spacing * multiplier
                   multiplier = multiplier + 1
                   renderer.text(cx -1  + math.floor(add_x), cy + 35 + offset, bottom_indicators[n].color[1], bottom_indicators[n].color[2], bottom_indicators[n].color[3], bottom_indicators[n].color[4], "-c", 0, bottom_indicators[n].text)
           end 
   end  

   
elseif menu.gettype == "Both" then
       client.unset_event_callback('indicator', indicators_override)
       local a = 255 + (0 - 255) * 0.04 * (globals.absoluteframetime() * 100)
       local realtime = globals.realtime() % 2
       local alpha = math.floor(math.sin(realtime * 2) * (a/2-1) + a/2)	
       local rr, gg, bb, aa = ui.get(bs_ind_fist_color)

       local sc = {client_screen_size()}
       local cx,cy = sc[1]/2,sc[2]/2
       

       local doubletap_charged = function()
           return antiaim_funcs.get_double_tap()
       end
       local charged = doubletap_charged() 
       local color_dt = {
           {   text = "DOUBLETAP",
               color = charged and  {255, 255, 255, 255} or {225, 51, 51, 255},
               bool = ui.get(refs.ragebot.double_tap[2])
           }
       }

       local offset = 0
       local spacing = 10
       local multiplier = 0

       if menu.getstyle == "Minimalistic" then

           if ui.get(anim_ind) and is_scoped ~= 0 and not is_knife then   
               add_x = render:lerp(add_x,30,globals_frametime() * 6)
           else
               add_x = render:lerp(add_x,0,globals_frametime() * 8)
           end

           if var.manual_dir == "left" then
               renderer.text(cx  - 35, cy + 0 + offset, rr, gg, bb, aa, "cb", 0, "<" )
           elseif var.manual_dir == "right" then
               renderer.text(cx  + 35, cy + 0 + offset, rr, gg, bb, aa, "cb", 0, ">" )
           end
   
           renderer.text(cx + math.floor(add_x) , cy + 30 + offset, 255, 255, 255, 255, "-c", 0, body_yaw2.."")
           offset = spacing * multiplier

           if ui.get(refs.ragebot.duck_peek_assist)  then
               renderer.text(cx  + math.floor(add_x), cy + 20 + offset,  255, 255, 255, alpha, '-c', 0, "FD")
               offset = spacing * multiplier
               multiplier = multiplier + 1
           end 
   
           if  not (ui.get(refs.antiaim.freestanding[1]) and ui.get(refs.antiaim.freestanding[2])) and not ui.get (refs.ragebot.duck_peek_assist) and not ui.get(refs.antiaim.slow_motion[2])  and not ui.get(refs.antiaim.edge_yaw) then
               renderer.text(cx  + math.floor(add_x), cy + 20 + offset,  rr, gg, bb, aa, "-c", 0,"", tostring(var.player_pos[var.p_state]):upper())
               offset = spacing * multiplier
               multiplier = multiplier + 1
           end 
   
           if (ui.get(refs.antiaim.freestanding[1]) and ui.get(refs.antiaim.freestanding[2]))  and not ui.get (refs.ragebot.duck_peek_assist) and not ui.get (refs.antiaim.slow_motion[2]) then
               renderer.text(cx  + math.floor(add_x), cy + 20 + offset,  255, 255, 255, 255, '-c', 0, "FS")
               offset = spacing * multiplier
               multiplier = multiplier + 1
           end
   
           if ui.get(refs.antiaim.slow_motion[2]) and not ui.get (refs.ragebot.duck_peek_assist)  then
               renderer.text(cx + math.floor(add_x), cy + 20 + offset,  255, 255, 255, alpha, '-c', 0, "SLOW")
               offset = spacing * multiplier
               multiplier = multiplier + 1
           end
   
           if ui.get(refs.antiaim.edge_yaw) and not (ui.get(refs.antiaim.freestanding[1]) and ui.get(refs.antiaim.freestanding[2])) and not ui.get (refs.ragebot.duck_peek_assist)  then
               renderer.text(cx + math.floor(add_x) , cy + 20 + offset, 255,255,255, alpha, '-c', 0, "EDGE")
               offset = spacing * multiplier
               multiplier = multiplier + 1
           end
   
           if ui.get(refs.antiaim.roll)~=0  and not ui.get (refs.ragebot.duck_peek_assist) then
               renderer.text(cx + math.floor(add_x) , cy + 20 + offset,  255, 255, 255, alpha, '-c', 0, "ROLL")
               offset = spacing * multiplier
               multiplier = multiplier + 1
           end

           for n = 1, #color_dt do
               if color_dt[n].bool then
                   renderer.text(cx  + math.floor(add_x), cy + 40 + offset, color_dt[n].color[1], color_dt[n].color[2], color_dt[n].color[3], color_dt[n].color[4], "-c", 0, "DT")
                   offset = spacing * multiplier
                   multiplier = multiplier + 1
               end
           end
   
           if ui.get(refs.antiaim.hide_shots[2]) and not ui.get(refs.ragebot.duck_peek_assist) then
               renderer.text(cx  + math.floor(add_x), cy + 40 + offset,  255, 255, 255, 255, '-c', 0, "OS")
               offset = spacing * multiplier
               multiplier = multiplier + 1
           end
   
           if ui.get(refs.ragebot.force_body_aim)  then
               renderer.text(cx  + math.floor(add_x), cy + 40 + offset,  255, 0, 0, 255, '-c', 0, "BAIM")
               offset = spacing * multiplier
               multiplier = multiplier + 1
           end
   
           if ui.get(refs.ragebot.minimum_damage_override[1]) and ui.get(refs.ragebot.minimum_damage_override[2]) then
               renderer.text(cx  + math.floor(add_x), cy + 40 + offset , 255,255,155,210 ,'-c', 0, 'DMG: '.. ui.get(refs.ragebot.minimum_damage_override[3]))
               offset = spacing * multiplier
               multiplier = multiplier + 1
           end

         
               if dorm_a then
                   custom_refs.dormant = {ui.reference("RAGE", "Aimbot", "Dormant aimbot")}
                   if ui.get(custom_refs.dormant[1]) and ui.get(custom_refs.dormant[2])  then
                       renderer.text(cx  + math.floor(add_x), cy + 40 + offset,  255, 0, 0, 255, '-c', 0, "DA")
                       offset = spacing * multiplier
                       multiplier = multiplier + 1
                   end
               end
           

       elseif menu.getstyle  == "Modern" then
           
           if ui.get(anim_ind) and is_scoped ~= 0 and not is_knife then   
               add_x = render:lerp(add_x,30,globals_frametime() * 6)
           else
               add_x = render:lerp(add_x,0,globals_frametime() * 8)
           end
           
           local text_size = { renderer.measure_text("-", "BLOODSTONE") };
           local body_yaw = (math.min(57, (entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11)*120-60)));
           local rr, gg, bb, aa = ui.get(bs_ind_fist_color)
           local r1, g1, b1, a1 = ui.get(bs_ind_second_color)
   
           local function draw_gradient( ctx, x, y, w, h, r3,g3,b3,a3, r2, g2, b2, a2, ltr )
               client.draw_gradient( ctx, x, y, w, h, r3,g3,b3,a3, r2, g2, b2, a2, ltr )
           end
           local x2 = 2

           offset = spacing * multiplier
           multiplier = multiplier + 1
           renderer.text(cx + math.floor(add_x), cy + 45, rr, gg, bb, aa, "-c", 0, "BLOODSTONE")
           renderer.text(cx + math.floor(add_x), cy + 25,  r1, g1, b1, alpha, "-c", 0, "DEBUG")

           renderer.rectangle(cx - 23  + math.floor(add_x), cy + 35, text_size[1] + 2 ,4, 0, 0, 0, 200);
           draw_gradient( c, cx - 22  + math.floor(add_x),  cy + 36,(text_size[1]) * (math.abs(body_yaw) / 57), x2, r1, g1, b1, a1,  r1, g1, b1 , 20, true) --полоски
  

           if var.manual_dir == "left" then
               offset = spacing * multiplier
               multiplier = multiplier + 1
               renderer.text(cx + math.floor(add_x), cy + 45 + offset, rr, gg, bb, aa, "-c", 0, "M: " .. string.upper(var.manual_dir))
           elseif var.manual_dir == "right" then
               offset = spacing * multiplier
               multiplier = multiplier + 1
               renderer.text(cx + math.floor(add_x), cy + 45 + offset, rr, gg, bb, aa, "-c", 0, "M : " .. string.upper(var.manual_dir))
           end
           
           for n = 1, #color_dt do
               if color_dt[n].bool then
                   offset = spacing * multiplier
                   multiplier = multiplier + 1
                   renderer.text(cx + math.floor(add_x), cy + 45 + offset, color_dt[n].color[1], color_dt[n].color[2], color_dt[n].color[3], color_dt[n].color[4], "-c", 0, color_dt[n].text)
               end
           end

           if ui.get(refs.ragebot.duck_peek_assist)  then
               offset = spacing * multiplier
               multiplier = multiplier + 1
               renderer.text(cx + math.floor(add_x), cy + 45 + offset,  255,255,255,255, "-c", 0, "FAKE DUCK")
           end

           if ui.get(refs.antiaim.hide_shots[2]) and not ui.get(refs.ragebot.duck_peek_assist) then
               offset = spacing * multiplier
               multiplier = multiplier + 1
               renderer.text(cx + math.floor(add_x), cy + 45 + offset, 255, 255, 255, 255, "-c", 0, "ONSHOT-AA")
           end

           if (ui.get(refs.antiaim.freestanding[1]) and ui.get(refs.antiaim.freestanding[2])) and not ui.get (refs.ragebot.duck_peek_assist) and not ui.get (refs.antiaim.slow_motion[2]) then
               offset = spacing * multiplier
               multiplier = multiplier + 1
               renderer.text(cx + math.floor(add_x), cy + 45 + offset, 255, 255, 255, 200, "-c", 0, "FREESTAND")
           end

           if ui.get(refs.ragebot.force_safepoint)  then
               offset = spacing * multiplier
               multiplier = multiplier + 1
               renderer.text(cx + math.floor(add_x), cy + 45 + offset , 255, 255, 255, 200, "-c", 0, "SAFE POINT")
           end

           if ui.get(refs.ragebot.force_body_aim)  then
               offset = spacing * multiplier
               multiplier = multiplier + 1
               renderer.text(cx + math.floor(add_x), cy + 45 + offset, 255, 0, 0, 200, "-c", 0, "BAIM")
           end

           
           if contains(ui.get(menu.chosez),"Dormant") then
               if dorm_a then
                   custom_refs.dormant = {ui.reference("RAGE", "Aimbot", "Dormant aimbot")}
                   if ui.get(custom_refs.dormant[1]) and ui.get(custom_refs.dormant[2])  then
                       offset = spacing * multiplier
                       multiplier = multiplier + 1
                       renderer.text(cx + math.floor(add_x), cy + 45 + offset, 162,227,55, 255, "-c", 0, "DA")
                   end
               end
           end

           if ui.get(refs.ragebot.minimum_damage_override[1]) and ui.get(refs.ragebot.minimum_damage_override[2]) then
               offset = spacing * multiplier
               multiplier = multiplier + 1
               renderer.text(cx + math.floor(add_x), cy + 45 + offset, 255,255,255,210 ,'-c', 0, 'DMG: '.. ui.get(refs.ragebot.minimum_damage_override[3]))
           end


           
   end

   else
       client.unset_event_callback('indicator', indicators_override) 
   end
   end)

client.set_event_callback('paint', function()
           local me = entity_lib.get_local_player()
       
           if not entity_lib.is_alive(me) then
               return
           end
           if not ui.get(bs_ind_debug_lines) then return end
       
           local client, server = antiaim_funcs.get_body_yaw()
       
           render_line(me, client, 10, { 255, 255, 255, 175 })
           render_line(me, server, 10, { 220, 125, 40, 255 })
       end)
end

local  misc_script  = function() 
local disablers_on = {
   ["Throwing grenade"] = function(e)
   local me = entity.get_local_player()
   local my_weapon = entity.get_player_weapon(me)
   local is_grenade =
   ({[43] = true,[44] = true,[45] = true,[46] = true,[47] = true,[48] = true,[68] = true})[bit.band(0xffff, entity.get_prop(my_weapon, "m_iItemDefinitionIndex"))] or false
   if not is_grenade then return false end
   local throw_time = entity.get_prop(my_weapon, "m_fThrowTime") if e.in_attack == 0 or e.in_attack2 == 0 and throw_time > 0 then return true end
   return false
   end,
   ["Double tap"] = function()
   return antiaim_funcs.get_double_tap()
   end,
   ["In air"] = function(e)
   return entity.get_prop(entity.get_local_player(), "m_bOnGround") == 0 or e.in_jump == 1
   end,
   ["Walking"] = function(e)
   return math.max(e.in_forward, e.in_back, e.in_moveleft, e.in_moveright) > 0
   end,
   ["Standing"] = function(e)
       return math.max(e.in_forward, e.in_back, e.in_moveleft, e.in_moveright) == 0
    end,
   ["High speed"] = function(e)
   speed = vector(entity.get_prop(entity.get_local_player(), "m_vecVelocity")):length2d()
   return speed > 100
   end,
   ["Quick peek assist"] = function(e)
       return ui.get(refs.ragebot.quick_peek_assist[1]) and ui.get(refs.ragebot.quick_peek_assist[2])  
   end,
   ["Duck peek assist"] = function(e)
   return ui.get(refs.ragebot.duck_peek_assist) 
   end,
   ["Edge yaw"] = function(e)
   return ui.get(refs.antiaim.edge_yaw) 
   end,
   ["Jump at edge"] = function(e)
   return ui.get(refs.misc.jump_at_edge[1] ) and  ui.get(refs.misc.jump_at_edge[2] )  
   end,
   ["On Ladder"] = function(e)
       return entity.get_prop(entity.get_local_player(), "m_MoveType") == 9
   end,
   ["Low Stamina"] = function(e)
           return (80 - entity.get_prop(entity.get_local_player(), "m_flStamina")) <= 70
   end,
   ["On Hit"] = function(e)
       return entity.get_prop(entity.get_local_player(), "m_flVelocityModifier") <= 0.9
   end,
   ["In use"] = function (e)
   return e.in_use == 1
   end,
   ["Legit AA key"] = function (e)
   if var.p_state == 9 then return true else return false end
   end,
   ["On shot AA"] = function (e)
   if (ui.get(refs.antiaim.hide_shots[1]) and ui.get(refs.antiaim.hide_shots[2])) then return true else return false end
   end,
   ["Exploits disabled"] = function(e)
       if not (ui.get(refs.antiaim.hide_shots[1]) and ui.get(refs.antiaim.hide_shots[2]))
       and not antiaim_funcs.get_double_tap() then return true else return false end
   end
}
ui.set(refs.fakelag.enabled[1],true)
local flon = true
client.set_event_callback('setup_command', function(c)
   if not  ui.get(disable_fl_onshot)  then
       if flon then
       ui.set(refs.fakelag.enabled[1],true)
       flon = false
       end
   return end
   for iter, disabler in ipairs(ui.get(disable_fl_onshot_disablers)) do
       if disablers_on[disabler](c) then
       ui.set(refs.fakelag.enabled[1], true)
       return
       end
   end
   local flon = true
   ui.set(refs.fakelag.enabled[1],false)
end)
client.set_event_callback("setup_command", function(cmd)
       local m_bIsDefusing = entity.get_prop(entity.get_local_player(), "m_bIsDefusing")
       
       if m_bIsDefusing > 0 then
           local weapon = csgo_weapons[entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_iItemDefinitionIndex")]
           local m_bPinPulled = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_bPinPulled")
           if cmd.in_attack == 1 and weapon.type == "grenade" and m_bPinPulled == 0 then
               cmd.in_attack = 0
               cmd.in_attack2 = 1
           end
       end
   end)

   --trashtalk
   local trashphrase = {
        hstable = {
           '0J7Qs9C+INC60LDQuiDRjyDRgtC10LHRjyDQv9C10YDQtdC40LPRgNCw0Ls=',
           'c28gZXo=',
           '0YLRiyDRgSDRjdC60YHQvtGA0LTQvtC8Pw==',
           '0YfRgtC+INCyINGF0YPQuT8=',
           'bmljZSBhYSBnbyBidXkgYnMubHVh',
           'MSDRhdGD0LXQstGL0Lk=',
           'ZXhjb3JkIG9yIHhvLXlhdz8=',
           'ZVtmZmUg0LXQsdCw0YLRjCDRjyDRgtC10LHRjyDQv9C+0LTQsdC40Ls=',
           '0YHRgNCw0LfRgyDQstC40LTQvdC+INGH0YLQviDQuNCz0YDQsNC10YjRjCDQsdC10LcgYnMubHVh',
           '0LjQt9C4INGH0LjQv9GD0YjQuNC70LA=',
           '0JvRi9GB0LDRjyDQsdCw0YjQutCw',
       },
        baimtable = {
        'Pw==',
        '0YLRgNGL0L3QtNC10YY=',
        '0L3QtSDQv9C70LDRhyDRgNGR0LLQsCDQutC+0YDRkdCy0LA=',
        'MS4=',
        'bmljZSBhYQ==',
        'aXE/',
        '0J4g0LPQvtGB0L/QvtC00LgsINGPINCy0LXQtNGMINGA0LXQsNC70YzQvdC+INCy0LvQsNC00YvQutCwINGF0LLRhQ==',
        '0YHQu9Cw0LHQvtCy0LDRgtGL0Lkg0YLRiyDQutCw0LrQvtC5INGC0L4=',
        'YmFpdGVk',
        '0LrQsNC60LjQtSDQttC1INGF0YPQtdCy0YvQtSDQsNCwLNC60YPQv9C4IGJzLmx1YQ==',
        '0LjQt9C4INGI0LrQvtC70YzQvdC40LopKCkp',
        '0LXQu9C60Lgt0L/QsNC70LrQuCDQv9GA0LjQutGD0L/QuCDQsNCw0YjQutC4ICwg0L3QsNC/0YDQuNC80LXRgCBicy5sdWE=',
        '0LAg0LIgYnMubHVhINCx0Ysg0LzQuNGB0L3Rg9C70Lg=',
   },
}
       local function on_player_death(e)
           if not ui.get(enabler) then
               return
           end
       
           local victim_userid, attacker_userid = e.userid, e.attacker
           local victim_entindex = client.userid_to_entindex(victim_userid)
       
            if victim_userid == nil or attacker_userid == nil then
                return
           end
       
           local attacker_entindex = client.userid_to_entindex(attacker_userid)
       
           client.delay_call(math.random(0.00001,2), function()
           
           if attacker_entindex == entity.get_local_player() and entity.is_enemy(victim_entindex) then
               if e.headshot then
                   local commandhs = 'say ' .. base64.decode(trashphrase.hstable[math.random(#trashphrase.hstable)])
                   client.exec(commandhs)
               elseif not e.headshot then
                   local commandbaim = 'say ' .. base64.decode(trashphrase.baimtable[math.random(#trashphrase.baimtable)])
                   client.exec(commandbaim)
               end
           end
       end)
end
client.set_event_callback("player_death", on_player_death)




--клнтегич
local duration = 25
local clantags = {
   "",
   "b",
   "b",
   "b$|-",
   "bs.l",
   "bs.lu|",
   "b$.lu4",
   "bs.lua",
   "bs.lu|",
   "bs.l",
   "bs.|-",
   "bs|",
   "bs",
   "b$",
   "b$",
   "b<",
   "bs",
   "b|-",
   "b|",
   "b",
   "",
   "",
   ""
}


local bs_clantag
local res_clantag = false
local function ClanTag()
   if ui.get(clantag)then
       local cur = math.floor(globals.tickcount() / duration) % #clantags
       local clantag = clantags[cur+1]

       if clantag ~= bs_clantag then
           bs_clantag = clantag
         client.set_clan_tag(clantag)
       end
       res_clantag = true
   end
   if res_clantag and not ui.get(clantag) then
       res_clantag = false
       client.set_clan_tag(" ")
   end
end

client.set_event_callback("paint", ClanTag)

local pi, max = math.pi, math.max

local dynamic = {}
dynamic.__index = dynamic

function dynamic.new(f, z, r, xi)
  f = max(f, 0.001)
  z = max(z, 0)

  local pif = pi * f
  local twopif = 2 * pif

  local a = z / pif
  local b = 1 / ( twopif * twopif )
  local c = r * z / twopif

  return setmetatable({
     a = a,
     b = b,
     c = c,

     px = xi,
     y = xi,
     dy = 0
  }, dynamic)
end

function dynamic:update(dt, x, dx)
  if dx == nil then
     dx = ( x - self.px ) / dt
     self.px = x
  end

  self.y  = self.y + dt * self.dy
  self.dy = self.dy + dt * ( x + self.c * dx - self.y - self.a * self.dy ) / self.b
  return self
end

function dynamic:get()
  return self.y
end

local f = {ipairs = ipairs, assert = assert, pairs = pairs, pcall = pcall, error = error, next = next, tostring = tostring, unpack = unpack}
local function contains(tab, val)
   for key, value in f.ipairs(tab) do
       if value == val then
           return true
       end
   end
   return false
end

local function roundedRectangle(b, c, d, e, f, g, h, i, j, k)
   if contains(ui.get(custom_logs),"Notify logs") then
       r1,g1,b1,a1 = ui.get(color1)
       renderer.rectangle(b, c, d, e, f, g, h, i)
       renderer.circle(b, c, r1, g1, b1, a1, k, -180, 0.25)
       renderer.circle(b + d, c, r1, g1, b1, a1, k, 90, 0.25)
       renderer.rectangle(b, c - k, d, k, f, g, h, i)
       renderer.circle(b + d, c + e, r1, g1, b1, a1, k, 0, 0.25)
       renderer.circle(b, c + e, r1, g1, b1, a1, k, -90, 0.25)
       renderer.rectangle(b, c + e, d, k, f, g, h, i)
       renderer.rectangle(b - k, c, k, e, f, g, h, i)
       renderer.rectangle(b + d, c, k, e, f, g, h, i)
   end
end

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', 'resolver', 'gear'}
local logs = {}

function fired(e)
   stored_shot = {
       damage = e.damage,
       hitbox = hitgroup_names[e.hitgroup + 1],
       lagcomp = e.teleported,
       backtrack = globals.tickcount() - e.tick
   }
end

function hit(e)
   local string = string.format("hit %s for %s [%s] in the %s [%s] [hc: %s, bt: %s, lc: %s]", string.upper(entity.get_player_name(e.target)), e.damage, stored_shot.damage, hitgroup_names[e.hitgroup + 1] or '?', stored_shot.hitbox, math.floor(e.hit_chance).."%", stored_shot.backtrack, stored_shot.lagcomp)
   table.insert(logs, {
       text = string
   }) 
   if contains(ui.get(custom_logs),"Logs to console") then
       r2,g2,b2 = ui.get(color2);
       client.color_log(r2,g2,b2, "[gamesense] \0")
       client.color_log(255, 255, 255, string)
   end
end

function missed(e)
   local string = string.format("missed %s's %s due to %s [dmg: %s, bt: %s, lc: %s]", string.upper(entity.get_player_name(e.target)), stored_shot.hitbox, e.reason, stored_shot.damage, stored_shot.lagcomp, stored_shot.backtrack)
   table.insert(logs, {
       text = string
   })
   if contains(ui.get(custom_logs),"Logs to console") then
       r,g,b = ui.get(color)
       client.color_log(r, g, b, "[gamesense] \0")
       client.color_log(255, 255, 255, string)
   end
end

function logging()
   if contains(ui.get(custom_logs),"Notify logs") then
       local screen = {client.screen_size()}
       for i = 1, #logs do
           if not logs[i] then return end

           if not logs[i].init then
               logs[i].y = dynamic.new(2, 1, 1, -555)
               logs[i].time = globals.tickcount() + 256
               logs[i].init = true
           end

           r,g,b,a = ui.get(color);
           r2,g2,b2,a2 = ui.get(color2);
           r1,g1,b1,a1 = ui.get(color1);

           local string_size = renderer.measure_text("c", logs[i].text)
           roundedRectangle(screen[1]/2-string_size/2-25, screen[2]-logs[i].y:get(), string_size+30, 16, r1,g1,b1,a1,"", 4)
           renderer.text(screen[1]/2-20, screen[2]-logs[i].y:get()+8, 255,255,255,255,"c",0,logs[i].text)

           if logs[i].text:find("hit") then
               renderer.circle_outline(screen[1]/2+string_size/2-3, screen[2]-logs[i].y:get()+8, 13, 13, 13, 255, 7.5, 0, 1, 4)
               renderer.circle_outline(screen[1]/2+string_size/2-3, screen[2]-logs[i].y:get()+8, r2,g2,b2,a2, 6.5, 0, (logs[i].time-globals.tickcount())/256, 2)
           else
               renderer.circle_outline(screen[1]/2+string_size/2-3, screen[2]-logs[i].y:get()+8, 13, 13, 13, 255, 7.5, 0, 1, 4)
               renderer.circle_outline(screen[1]/2+string_size/2-3, screen[2]-logs[i].y:get()+8, r,g,b,a, 6.5, 0, (logs[i].time-globals.tickcount())/256, 2)
           end
           if tonumber(logs[i].time) < globals.tickcount() then
               if logs[i].y:get() < -10 then
                   table.remove(logs, i)
               else
                   logs[i].y:update(globals.frametime(), -50, nil)
               end
           else
               logs[i].y:update(globals.frametime(), 20+(i*28), nil)
           end
       end
   end 
end

client.set_event_callback('paint', logging)
client.set_event_callback("aim_fire", fired)
client.set_event_callback("aim_hit", hit)
client.set_event_callback("aim_miss", missed)


ui.set_visible(disable_fl_onshot,false)
ui.set_visible(disable_fl_onshot_disablers,false )



ui.set_visible(fast_ladder_on,false)
ui.set_visible(drop_nades_to_fit,false)

ui.set_visible(clantag,false)
ui.set_visible(enabler,false)
ui.set_visible(Debug_panel,false)
ui.set_visible(old_anims,false)
ui.set_visible(misc_expoloit,false)
--ui.set_visible(break_lagcomp,false)
ui.set_visible(anim_ind,false)
ui.set_visible(ms_color,false)
ui.set_visible(Debug_panel_selector,false)
ui.set_visible(custom_logs,false)
ui.set_visible(color_label,false)
ui.set_visible(color,false)
ui.set_visible(color_label2,false)
ui.set_visible(color2,false)
ui.set_visible(color_label1,false)
ui.set_visible(color1,false)
end


local  roll_script  = function() 
   local g_player_list =
   {
       reference = ui.reference ( 'Players', 'Players', 'Player List' ),
       reset_reference = ui.reference ( 'Players', 'Players', 'Reset all' ),
       controls = { },

       init = function ( self )
           ui.set_callback ( self.reference, function ( )
               local target = ui.get ( self.reference )

               if ( #self.controls > 0 ) then
                   for i = 1, #self.controls do
                       if ( #self.controls [ i ].cache > 0) then
                           for f = 1, #self.controls [ i ].cache do
                               if ( self.controls [ i ].cache [ f ].entity == target ) then
                                   ui.set ( self.controls [ i ].reference, self.controls [ i ].cache [ f ].value)
                                   goto skip
                               end
                           end
                       end
                       
                       ui.set ( self.controls [ i ].reference, self.controls [ i ].default )

                       ::skip::
                   end
               end
           end )

           ui.set_callback ( self.reset_reference, function ( )
               if ( #self.controls > 0 ) then
                   for i = 1, #self.controls do
                       self.controls [ i ].cache = { }
                       ui.set ( self.controls [ i ].reference, self.controls [ i ].default )
                   end
               end
           end )
       end,

       add_control = function ( self, field_name, control, default )
           local control_tbl =
           {
               field_name = field_name,
               reference = control,
               cache = { },
               default = default
           }

           table.insert ( self.controls, control_tbl )

           ui.set_callback ( control, function ( )
               local value = ui.get ( control )
               local target = ui.get ( self.reference )

               for i = 1, #control_tbl.cache do
                   if control_tbl.cache [ i ].entity == target then
                       control_tbl.cache [ i ].value = value
                       return
                   end
               end
       
               table.insert ( control_tbl.cache, { entity = target, value = value } )
           end )
       end,

       get_value = function ( self, target, field_name )
           for _, c in pairs ( self.controls ) do
               if c.field_name == field_name then
                   for __, v in pairs ( c.cache ) do
                       if v.entity == target then
                           return v.value
                       end
                   end

                   return c.default
               end
           end

           return nil
       end
   }

   local g_roll_resolver =
   {
       sides = { },
       unload = false,

       init = function ( self )
           g_player_list:add_control ( 'Roll override', ui.new_checkbox ( 'Players', 'Adjustments', '> Roll override' ), false )
           g_player_list:add_control ( 'Roll override flag', ui.new_checkbox ( 'Players', 'Adjustments', '> Roll override flag' ), false )
           g_player_list:add_control ( 'Roll degree', ui.new_slider ( 'Players', 'Adjustments', '> Roll degree', -90, 90, 45, true, '°' ), 45 )
           g_player_list:add_control ( 'Roll bruteforce', ui.new_checkbox ( 'Players', 'Adjustments', '> Roll bruteforce' ), false )
       end,

       override = function ( self, idx, deg )
           local _ , yaw = entity.get_prop ( idx, 'm_angRotation' )
           local pitch = 89 * ( ( 2 * entity.get_prop ( idx, 'm_flPoseParameter', 12 ) ) - 1 )
           entity.set_prop ( idx, 'm_angEyeAngles', pitch, yaw, deg )
       end,

       on_net_update_start = function ( self )
           if self.unload then
               return
           end

           local e = entity.get_local_player ( )
           if e then
               for _, idx in pairs ( entity.get_players ( true ) ) do
                   if idx ~= e then
                       if g_player_list:get_value ( idx, 'Roll override' ) then
                           local side = ( g_player_list:get_value ( idx, 'Roll bruteforce' ) and ( self.sides [ idx ] or false ) or false )
                           self:override ( idx, ( side and g_player_list:get_value ( idx, 'Roll degree' ) or -g_player_list:get_value ( idx, 'Roll degree' ) ) )
                       else
                           self:override ( idx, 0 )
                       end
                   end
               end
           end
       end,

       on_flag_renderer = function ( self, idx )
           if self.unload then
               return
           end

           return g_player_list:get_value ( idx, 'Roll override' ) and g_player_list:get_value ( idx, 'Roll override flag' )
       end,

       on_aim_miss = function ( self, shot )
           if self.unload then
               return
           end

           if not g_player_list:get_value ( shot.target, 'Roll bruteforce' ) or shot.reason ~= '?' then
               return
           end

           self.sides [ shot.target ] = not ( self.sides [ shot.target ] or false )
       end,

       on_shutdown = function ( self )
           self.unload = true
           self.sides = { }

           local e = entity.get_local_player ( )
           if e then
               for _, idx in pairs ( entity.get_players ( true ) ) do
                   if idx ~= e and entity.is_alive ( idx )  then
                       self:override ( idx, 0 )
                   end
               end
           end
       end
   }

   g_player_list:init ( )
   g_roll_resolver:init ( )

   client.set_event_callback ( 'net_update_start', function ( )
       g_roll_resolver:on_net_update_start ( )
   end )

   client.set_event_callback ( 'aim_miss', function ( shot )
       g_roll_resolver:on_aim_miss ( shot )
   end )

   client.set_event_callback ( 'shutdown', function ( )
       g_roll_resolver:on_shutdown ( )
   end )



   client.register_esp_flag ( 'ROLL', 255, 255, 255, function ( idx )
       return g_roll_resolver:on_flag_renderer ( idx )
   end )




   local ffi = require ('ffi')
   local voice_data_t = ffi.typeof[[
       struct {
           char     pad_0000[8];
           int32_t  client;
           int32_t  audible_mask;
           uint32_t xuid_low;
           uint32_t xuid_high;
           void*    voice_data;
           bool     proximity;
           bool     caster;
           char     pad_001E[2];
           int32_t  format;
           int32_t  sequence_bytes;
           uint32_t section_number;
           uint32_t uncompressed_sample_offset;
           char     pad_0030[4];
           uint32_t has_bits;
       } *
   ]]
   
   local players = { --cope
   index = {},
   primo = {},
}

local function includes(table, key)
   for i=1, #table do
       if table[i] == key then
           return true, i
       end
   end
   return false, nil
end
   local valid_ent = function (e)
       local res, n =  pcall(entity.get_classname, e);
   
       if not res then
           return false;
       end
   
       return n ~= nil;
   end
   
   client.set_event_callback("voice", function(e)
       local data = e.data
       local voice_data = ffi.cast(voice_data_t, data)
       if voice_data.client == nil then return end
       if client.userid_to_entindex(voice_data.client)  == nil then return end 
       local neverlose = bit.lshift(voice_data.sequence_bytes + voice_data.section_number + voice_data.uncompressed_sample_offset, 4) % 4294967296.0
       local ent_idx_prim = bit.band(bit.bxor(bit.rshift(voice_data.sequence_bytes, 16), bit.rshift(voice_data.sequence_bytes, 8)), 255)
       local primordial =  bit.band(bit.bxor(bit.band(voice_data.sequence_bytes, 255),     bit.band(bit.rshift(voice_data.uncompressed_sample_offset, 16), 255))    - bit.rshift(voice_data.sequence_bytes, 16), 255) == 77
        and ent_idx_prim >= 1
        and ent_idx_prim <= 64
        and valid_ent(ent_idx_prim)
       if primordial then
           table.insert(players.index, enemy)
           table.insert(players.primo, enemy)
       end
   end)


 
       
   client.register_esp_flag("PRIMO", 50, 255, 50, function(index)
       local contains, i = includes(players.index, index)
       if contains then
               return true
       end
       return false
   end)





end
local init_scripts = function()
aa_script()
indicator_script()
misc_script()
roll_script()
end

init_scripts()


local cheats = {
   'primordial',
   'neverlose',
   'fatality',
   'monolith',
   'pandora',
   'nemesis',
   'gamesense',
'nixware',
'plaguecheat',
'ev0lve',
'rifk7',
'onetap',
'airflow',
'aimware',
'legions'
}
   
   local http = require "gamesense/http"
   local pretty_json = require "gamesense/pretty_json"
   ui.new_label("LUA","B", "Cheat finder username")
   local username_text = ui.new_textbox("LUA","B", "Cheat finder username")
   local function parse_cheats()
       client.exec('clear')
       for key, value in pairs(cheats) do
           http.get("https://uidpolice.xyz/api/"..value.."/"..ui.get(username_text), function(success, response)
               if not success or response.status ~= 200 then
                return
               end
               local data = json.parse(response.body)
               if (data.status ~= 'success') then return end
               client.log("Cheat: "..value)
               local json_text = pretty_json.stringify(data)
               pretty_json.print_highlighted(json_text)
             end)
       end
      ui.set(username_text, '')
   end
   local sumbit_button = ui.new_button("LUA", "B", "Find cheat!", parse_cheats)