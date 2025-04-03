local hboxes = {} -- in lua api
hboxes["head"]            = 0
hboxes["neck"]            = 1
hboxes["pelvis"]          = 2
hboxes["stomach"]         = 3
hboxes["lower_chest"]     = 4
hboxes["chest"]           = 5
hboxes["upper_chest"]     = 6
hboxes["left_thigh"]      = 7
hboxes["right_thigh"]     = 8
hboxes["left_calf"]       = 9
hboxes["right_calf"]      = 10
hboxes["left_foot"]       = 11
hboxes["right_foot"]      = 12
hboxes["left_hand"]       = 13
hboxes["right_hand"]      = 14
hboxes["left_upper_arm"]  = 15
hboxes["left_forearm"]    = 16
hboxes["right_upper_arm"] = 17
hboxes["right_forearm"]   = 18

-- ui
local ui_dormant             = ui.create("Dormant Aimbot")
local ui_dormant_switch      = ui_dormant:switch("Dormant Aimbot", false)
local ui_dormant_logs        = ui_dormant:switch("Logs", false)

local ui_settings            = ui.create("Settings")
local ui_settings_hitboxes   = ui_settings:selectable("Hitboxes", "Head", "Chest", "Stomach", "Arms", "Legs", "Feet")

local ui_settings_mindmg     = ui_settings:slider("Minimum Damage", 1, 100, 1)
local ui_settings_hitchance  = ui_settings:slider("Hitchance", 1, 100, 70)
local ui_settings_alpha      = ui_settings:slider("Alpha Modulator", 1, 1000, 300, 0.001)

local ui_accuracy            = ui.create("Accuracy")
local ui_accuracy_autoscope  = ui_accuracy:switch("Auto Scope", false)
local ui_accuracy_autostop   = ui_accuracy:switch("Auto Stop", false)

local dormant_aimbot = new_class()
    :struct 'consts' {
        WEAPONTYPE_UNKNOWN          = -1,
        WEAPONTYPE_KNIFE            = 0,
        WEAPONTYPE_PISTOL        = 1,
        WEAPONTYPE_SUBMACHINEGUN = 2,
        WEAPONTYPE_RIFLE         = 3,
        WEAPONTYPE_SHOTGUN       = 4,
        WEAPONTYPE_SNIPER_RIFLE  = 5,
        WEAPONTYPE_MACHINEGUN    = 6,
        WEAPONTYPE_C4            = 7,
        WEAPONTYPE_TASER         = 8,
        WEAPONTYPE_GRENADE       = 9,
        WEAPONTYPE_HEALTHSHOT      = 11,

        hbox_radius              = { 4.2, 3.5, 6.0, 6.0, 6.5, 6.2, 5.0, 5.0, 5.0, 4.0, 4.0, 3.6, 3.7, 4.0, 4.0, 3.3, 3.0, 3.3, 3.0 },
        hbox_factor              = { 0.5, 0.1, 0.8, 0.8, 0.7, 0.7, 0.7, 0.5, 0.5, 0.5, 0.5, 0.4, 0.4, 0.4, 0.4, 0.5, 0.5, 0.5, 0.5 },
        hitgroup_str             = { [0] = "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "generic", "gear" }
    }
    :struct 'aimbot_shot' {
        tickcount = nil,
        victim    = nil,
        hitchance = nil,
        hitgroup  = nil,
        damage    = nil,
        handled   = nil
    }
    :struct 'variables' {
        hbox_state       = { false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false },
        is_reachable     = {},

        cmd              = nil,
        lp               = nil,
        eyepos           = nil,

        weapon           = nil,
        weapon_info      = nil,
        weapon_type      = nil,
        range_modifier   = nil,
        armor_resist     = nil,

        camera_position  = nil,
        camera_direction = nil,

        mindmg           = nil,
        minhc            = nil,

        dmg              = nil,
        dmg_is_wrong     = nil,

        initialize       = function(self, cmd)
            self.cmd              = cmd
            self.lp               = entity.get_local_player()
            self.eyepos           = self.lp:get_eye_position()

            self.weapon           = self.lp:get_player_weapon()
            self.weapon_info      = self.weapon:get_weapon_info()
            self.weapon_type      = self.weapon_info["weapon_type"]
            self.range_modifier   = self.weapon_info["range_modifier"]
            self.armor_resist     = 1.0 - self.weapon_info["armor_ratio"] * 0.5

            self.camera_position  = render.camera_position()
            self.camera_direction = vector():angles(render.camera_angles())

            self.mindmg           = ui_settings_mindmg:get()
            self.minhc            = ui_settings_hitchance:get()

            self.dmg_is_wrong = false
        end,
    }
    :struct 'aimbot' {
        get_hitgroup_index = function(self, hbox)
            if hbox == 1 then
                return 1
            end
            if hbox == 2 then
                return 8
            end
            if 3 <= hbox and hbox <= 4 then
                return 3
            end
            if 5 <= hbox and hbox <= 7 then
                return 2
            end
            if 8 <= hbox and hbox <= 13 then
                if hbox % 2 == 0 then
                    return 6
                else
                    return 7
                end
            end
            if 14 <= hbox and hbox <= 19 then
                if hbox % 2 == 1 then
                    return 4
                else
                    return 5
                end
            end

            return 0 -- a little bit incorrect but who cares?
        end,

        get_hitgroup_name = function(self, hbox)
            return self.consts.hitgroup_str[self:get_hitgroup_index(hbox)]
        end,

        get_damage_multiplier = function(self, hbox)
            local hgroup = self:get_hitgroup_name(hbox)
            if hgroup == "head" then
                return 4.0
            end
            if hgroup == "stomach" then
                return 1.25
            end
            if hgroup == "left leg" or hgroup == "right leg" then
                return 0.75
            end

            return 1.0
        end,

        get_weighted_damage = function(self, hbox, dmg) -- safety order: stomach, chest, limbs, head (head is so fucking unsafe)
            local hgroup = self:get_hitgroup_name(hbox)

            if hgroup == "head" or hgroup == "neck" then
                return dmg * 0.125
            end
            if hgroup == "legs" then
                return dmg * 0.25
            end
            if hgroup == "chest" then
                return dmg * 0.67
            end
            if hgroup == "stomach" then
                return dmg
            end

            return 0
        end,

        get_hbox_radius = function(self, hbox)
            if hbox == nil then
                return 0.0
            end
    
            return self.consts.hbox_radius[hbox] * self.consts.hbox_factor[hbox]
        end,

        calculate_hc = function(self, inaccuracy, point, radius) -- [0, 1]
            -- if x -> 0 then tan(x) ~ x therefore R ~ distance * inaccuracy
            -- max distance is 8192 so R <= 8192 * inaccuracy
            -- hc = (radius / R) ^ 2 >= (radius / (8192 * inaccuracy)) ^ 2
            -- so if (radius / (8192 * inaccuracy)) ^ 2 >= 100 then hc >= 100
            -- assume that radius >= 0.1
            -- then inaccuracy <= 1 / 819200 < 1e-6
            -- so if inaccuracy < 1e-6 then hc > 100
            if inaccuracy < 1e-6 then
                return 1.0
            end

            local distance = self.variables.eyepos:dist(point)
            local R = distance * math.tan(inaccuracy * 0.5) -- / 2 cuz of geometry

            return math.min(radius * radius / (R * R), 1.0)
        end,

        max_hc = function(self, point, radius) -- [0, 1]
            if self.variables.weapon_type == self.consts.WEAPONTYPE_SNIPER_RIFLE and (ui_accuracy_autoscope:get() or self.variables.lp["m_bIsScoped"]) then
                if self.variables.cmd.in_duck == 1 then
                    return self:calculate_hc(self.variables.weapon_info["inaccuracy_crouch_alt"], point, radius)
                else
                    return self:calculate_hc(self.variables.weapon_info["inaccuracy_stand_alt"], point, radius)
                end
            else
                if self.variables.cmd.in_duck == 1 then
                    return self:calculate_hc(self.variables.weapon_info["inaccuracy_crouch"], point, radius)
                else
                    return self:calculate_hc(self.variables.weapon_info["inaccuracy_stand"], point, radius)
                end
            end
        end,

        sign = function(self, value)
            return value >= 0.0 and 1 or -1
        end,

        vector_ratio = function(self, vec1, vec2) -- returns nil if vectors arent collinear
            local are_opposite

            if self:sign(vec1.x) == self:sign(vec2.x) and self:sign(vec1.y) == self:sign(vec2.y) and self:sign(vec1.z) == self:sign(vec2.z) then
                are_opposite = false
            elseif self:sign(vec1.x) ~= self:sign(vec2.x) and self:sign(vec1.y) ~= self:sign(vec2.y) and self:sign(vec1.z) ~= self:sign(vec2.z) then
                are_opposite = true
            else
                return nil
            end

            vec1 = vector(math.abs(vec1.x), math.abs(vec1.y), math.abs(vec1.z))
            vec2 = vector(math.abs(vec2.x), math.abs(vec2.y), math.abs(vec2.z))

            local lx = (vec1.x - 0.05) / (vec2.x + 0.05)
            local rx = (vec1.x + 0.05) / (vec2.x - 0.05)
            local ly = (vec1.y - 0.05) / (vec2.y + 0.05)
            local ry = (vec1.y + 0.05) / (vec2.y - 0.05)
            local lz = (vec1.z - 0.05) / (vec2.z + 0.05)
            local rz = (vec1.z + 0.05) / (vec2.z - 0.05)

            local l = math.max(lx, ly, lz)
            local r = math.min(rx, ry, rz)

            if l <= r then
                local ratio = l + (r - l) * 0.5
                return -ratio and are_opposite or ratio
            end
            
            return nil
        end,

        calc_true_damage = function(self, hbox, target_hbox_pos, armor, has_helmet)
            local dmg, trace = utils.trace_bullet(self.variables.lp, self.variables.eyepos, target_hbox_pos)
        
            if dmg == 0 then
                local vec_target = target_hbox_pos - self.variables.eyepos
                local vec_trace  = trace.end_pos - self.variables.eyepos
                local ratio = self:vector_ratio(vec_target, vec_trace) -- vec_target(trace).x(y)(z) > 0.05 (its achieveable only if you stand right next to enemy, but then it's not dormant)

                if ratio ~= nil and ratio < 1.0 then -- if bullet stopped after "hitting" enemy we can shoot and deal some dmg, but cant calculate dmg because API doesnt allow | revolver+nuke fix
                    return -1
                end
            end

            if trace.hitgroup == 0 and dmg > 0.0 then -- if target is dormant then bullet wouldn't hit it therefore will hit CWorld and then hitgroup == generic (0). So we need some adjustments to calculated damage...
                local dist = target_hbox_pos:dist(trace.end_pos)

                dmg = dmg * self:get_damage_multiplier(hbox)                                -- hitgroup fix
                dmg = dmg / math.pow(self.variables.range_modifier, dist / 500.0)           -- distance fix

                if has_helmet and hbox == 1 or armor > 0 and (hbox <= 7 or hbox >= 14) then -- armor fix
                    local absorbed = dmg * self.variables.armor_resist
                    dmg = dmg - math.min(absorbed, 2.0 * armor) -- armor gets damaged by absorbed/2
                end
            end

            return dmg
        end,

        choose_hbox = function(self, target) -- tries to prefer safety over dmg
            local idx = target:get_index()

            self.variables.is_reachable[idx] = false

            local best_hbox
            local highest_w_dmg = 0.0
            
            for hbox = 1, #self.variables.hbox_state do
                if self.variables.hbox_state[hbox] then
                    local target_hbox_pos = target:get_hitbox_position(hbox - 1) -- lua starts array indexes with 1
                    
                    dmg = self:calc_true_damage(hbox, target_hbox_pos, target["m_ArmorValue"], target["m_bHasHelmet"])
                    local is_wrong = dmg == -1
                    if is_wrong then
                        dmg = self.variables.weapon_info["damage"]
                    end
                    
                    if dmg > 0.0 then
                        self.variables.is_reachable[idx] = true
                    end

                    local hc = self:max_hc(target_hbox_pos, self:get_hbox_radius(hbox))

                    if dmg >= self.variables.mindmg and 100 * hc >= self.variables.minhc then
                        local w_dmg = self:get_weighted_damage(hbox, dmg)
                        if w_dmg > highest_w_dmg then
                            best_hbox                   = hbox
                            highest_w_dmg               = w_dmg
                            self.variables.dmg          = dmg
                            self.variables.dmg_is_wrong = is_wrong
                        end
                    end
                end
            end

            return best_hbox
        end,

        lp_check = function(self)
            if not globals.is_connected then
                return false
            end
            if not globals.is_in_game then
                return false
            end

            return true
        end,

        target_check = function(self, target)
            if target == nil then
                return false
            end
    
            if not target["m_bConnected"] == 1 then
                return false
            end
    
            if not target:is_alive() then
                return false
            end
    
            if target:get_network_state() == 0 then -- not dormant
                return false
            end

            if target:get_bbox().alpha < ui_settings_alpha:get() * 0.001 then -- dormant is outdated
                return false
            end

            if self:choose_hbox(target) == nil then -- dmg == 0
                return false
            end
    
            return true
        end,
    
        weapon_check = function(self, target)
            if self.variables.weapon == nil then
                return false
            end
    
            if self.variables.weapon_type == nil or self.variables.weapon_type == self.consts.WEAPONTYPE_KNIFE or self.variables.weapon_type >= self.consts.WEAPONTYPE_C4 then
                return false
            end

            if self.variables.weapon:get_weapon_reload() ~= -1 then -- is reloading
                return false
            end
    
            if self.variables.lp:get_origin():dist(target:get_origin()) > self.variables.weapon_info["range"] then -- out of range
                return false
            end
    
            if self.variables.weapon["m_flNextPrimaryAttack"] > globals.curtime then
                return false
            end

            return true
        end,
    
        choose_target = function(self) -- closest to camera | WARNING!!! FULLY PASTED CODE HERE
            local players = entity.get_players(true)

            local best_player
            local best_distance = math.huge
            for _, player in ipairs(players) do
                if self:lp_check() and self:weapon_check(player) and self:target_check(player) then
                    local origin = player:get_origin()
                    local ray_distance = origin:dist_to_ray(self.variables.camera_position, self.variables.camera_direction)
                    if ray_distance < best_distance then
                        best_distance = ray_distance
                        best_player = player
                    end
                end
            end

            return best_player
        end,
    
        autostop = function(self)
            local min_speed = math.sqrt((self.variables.cmd.forwardmove * self.variables.cmd.forwardmove) + (self.variables.cmd.sidemove * self.variables.cmd.sidemove))
            local goal_speed = self.variables.lp["m_bIsScoped"] and self.variables.weapon_info["max_player_speed_alt"] or self.variables.weapon_info["max_player_speed"]

            if goal_speed > 0 and min_speed > 0 then
                if not self.variables.cmd.in_duck then
                    goal_speed = goal_speed * 0.33 -- if ure standing and ur speed is a third of max_player_speed(_alt) then moving doesnt affect accuracy at all
                end
        
                if min_speed > goal_speed then
                    local factor = goal_speed / min_speed
                    self.variables.cmd.forwardmove = self.variables.cmd.forwardmove * factor
                    self.variables.cmd.sidemove = self.variables.cmd.sidemove * factor
                end
            end
        end,
    
        autoscope = function(self)
            if not self.variables.lp["m_bIsScoped"] then
                self.variables.cmd.in_attack2 = true
            end
        end,

        run = function(self, cmd)
            if not ui_dormant_switch:get() then
                return
            end

            if not self:lp_check() then
                return
            end

            if self.aimbot_shot.tickcount ~= nil and globals.tickcount - self.aimbot_shot.tickcount > 1 and not self.aimbot_shot.handled then
                if ui_dormant_logs:get() then
                    print_raw(("\a00FF00[Dormant Aimbot] \aFFFFFFMissed %s(%d%s) in %s for %d damage"):format(
                    self.aimbot_shot.victim:get_name(),
                    self.aimbot_shot.hitchance,
                    "%",
                    self.aimbot_shot.hitgroup,
                    self.aimbot_shot.damage
                ))
                end
                self.aimbot_shot.handled = true
            end

            self.variables:initialize(cmd)

            local target = self:choose_target()
            if target == nil then
                return
            end

            local hbox       = self:choose_hbox(target)
            local aim_point  = target:get_hitbox_position(hbox - 1)
            local aim_angles = self.variables.eyepos:to(aim_point):angles()

            if ui_accuracy_autostop:get() then
                self:autostop()
            end
            if ui_accuracy_autoscope:get() then
                self:autoscope()
            end

            local hc
            if self.variables.weapon_info["is_revolver"] then
                if self.variables.cmd.in_duck == 1 then
                    hc = self:calculate_hc(self.variables.weapon:get_inaccuracy() * 0.2, aim_point, self:get_hbox_radius(hbox))
                else
                    hc = self:calculate_hc(self.variables.weapon:get_inaccuracy() * 0.166, aim_point, self:get_hbox_radius(hbox))
                end
            else
                hc = self:calculate_hc(self.variables.weapon:get_inaccuracy(), aim_point, self:get_hbox_radius(hbox))
            end

            if 100 * hc >= self.variables.minhc then
                self.variables.cmd.view_angles = aim_angles
                self.variables.cmd.in_attack   = true

                self.aimbot_shot.tickcount     = globals.tickcount
                self.aimbot_shot.victim        = target
                self.aimbot_shot.hitchance     = 100 * hc
                self.aimbot_shot.hitgroup      = self:get_hitgroup_name(hbox)
                self.aimbot_shot.damage        = self.variables.dmg_is_wrong and -1 or self.variables.dmg
                self.aimbot_shot.handled       = false
            end
        end,
        
        update_hboxes = function(self)
            local hbox_list = ui_settings_hitboxes:get()

            local state = {}
            state["Head"]    = false
            state["Chest"]   = false
            state["Stomach"] = false
            state["Arms"]    = false
            state["Legs"]    = false
            state["Feet"]    = false

            for _, value in ipairs(hbox_list) do
                state[value] = true
            end

            for i = 1, 1 do
                self.variables.hbox_state[1] = state["Head"]
            end
            for i = 5, 7 do
                self.variables.hbox_state[i] = state["Chest"]
            end
            for i = 3, 4 do
                self.variables.hbox_state[i] = state["Stomach"]
            end
            for i = 14, 19 do
                self.variables.hbox_state[i] = state["Arms"]
            end
            for i = 8, 11 do
                self.variables.hbox_state[i] = state["Legs"]
            end
            for i = 12, 13 do
                self.variables.hbox_state[i] = state["Feet"]
            end
        end
    }
    
dormant_aimbot.aimbot:update_hboxes()

-- callbacks
events.createmove:set(function(cmd)
    dormant_aimbot.aimbot:run(cmd)
end)

ui_settings_hitboxes:set_callback(function()
    dormant_aimbot.aimbot:update_hboxes()
end)

local esp_dormant_flag = esp.enemy:new_text("Dormant Aimbot", "DA", function(player)
    if ui_dormant_switch:get() and dormant_aimbot.variables.is_reachable[player:get_index()] and player:get_network_state() ~= 0 and player:get_network_state() ~= 5 then
        return "DA"
    end
end)

events.player_hurt:set(function(e)
    local shot_time = dormant_aimbot.aimbot_shot.tickcount
    if shot_time == nil then
        return
    end

    if globals.tickcount - shot_time == 1 then
        local attacker = entity.get(e.attacker, true)

        if dormant_aimbot.variables.lp == attacker then
            local victim = entity.get(e.userid, true)
            local hgroup = dormant_aimbot.consts.hitgroup_str[e.hitgroup]

            if ui_dormant_logs:get() then
                print_raw(("\a00FF00[Dormant Aimbot] \aFFFFFFHit %s(%d%s) in %s(%s) for %d(%d) damage (%d health remaining)"):format(
                    victim:get_name(),
                    dormant_aimbot.aimbot_shot.hitchance,
                    "%",
                    hgroup,
                    dormant_aimbot.aimbot_shot.hitgroup,
                    e.dmg_health,
                    dormant_aimbot.aimbot_shot.damage,
                    e.health
                ))
            end
            dormant_aimbot.aimbot_shot.handled = true
        end
    end
end)