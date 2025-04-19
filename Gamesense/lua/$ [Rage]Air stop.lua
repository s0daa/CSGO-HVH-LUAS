-- #includes
local vector = require 'vector';
local ent = require 'gamesense/entity';
local csgo_weapons = require 'gamesense/csgo_weapons';

-- declares
local f = string.format;
local math_sin, math_cos, math_rad, math_abs = math.sin, math.cos, math.rad, math.abs;
local client_set_event_callback, client_camera_angles, client_current_threat, client_trace_bullet = client.set_event_callback, client.camera_angles, client.current_threat, client.trace_bullet;
local globals_curtime = globals.curtime;
local entity_get_prop, entity_get_local_player, entity_get_prop, entity_get_classname, entity_get_player_weapon, entity_get_origin = entity.get_prop, entity.get_local_player, entity.get_prop, entity.get_classname, entity.get_player_weapon, entity.get_origin;
local ui_reference, ui_set_callback, ui_get, ui_set, ui_set_visible, ui_new_checkbox, ui_new_slider = ui.reference, ui.set_callback, ui.get, ui.set, ui.set_visible, ui.new_checkbox, ui.new_slider;

-- <headers>
local function angle_to_forward(angle_x, angle_y)
    local sy = math_sin(math_rad(angle_y));
    local cy = math_cos(math_rad(angle_y));
    local sp = math_sin(math_rad(angle_x));
    local cp = math_cos(math_rad(angle_x));
    return cp * cy, cp * sy, -sp
end

local function entity_is_ready(ent)
    return globals_curtime() >= entity_get_prop(ent, 'm_flNextAttack')
end

local function entity_can_fire(ent)
    return globals_curtime() >= entity_get_prop(ent, 'm_flNextPrimaryAttack')
end

local function ux_set_callback(ref, callback, force_call)
    ui_set_callback(ref, callback);

    if force_call then
        callback(ref);
    end
end

-- namespace
local reference = {};
local main = {};

-- main code
reference.minimum_damage = ui_reference('RAGE', 'Aimbot', 'Minimum damage');
reference.minimum_damage_override = {ui_reference('RAGE', 'Aimbot', 'Minimum damage override')};
reference.air_strafe = ui_reference('Misc', 'Movement', 'Air strafe');

function main:create_data(flags, velocity)
    return {
        flags = flags or 0,
        velocity = velocity or vector()
    }
end

main.tab = 'RAGE';
main.container = 'Aimbot';

main.master = ui_new_checkbox (main.tab, main.container, 'Enable air-autostop');
main.on_peak_of_height = ui_new_checkbox (main.tab, main.container, 'Only on peak of height');
main.autoscope = ui_new_checkbox (main.tab, main.container, 'Auto-scope');
main.distance = ui_new_slider(main.tab, main.container, 'Distance', 0, 1000, 350, true, 'u', 1, {[0] = '∞'});
main.delay = ui_new_slider(main.tab, main.container, 'Delay', 0, 16, 0, true, 't', 1, {[0] = 'Off'});
main.minimum_damage = ui_new_slider(main.tab, main.container, 'Minimum damage', -1, 130, -1, true, 'hp', 1, (function()
    local hint = {
        [ -1 ] = 'Inherited'
    };

    for i = 1, 30 do
        hint[ 100 + i ] = f('HP + %d', i)
    end

    return hint
end)());

ux_set_callback(main.master, function(self)
    local val = ui_get(self);

    ui_set_visible(main.on_peak_of_height, val);
    ui_set_visible(main.autoscope, val);
    ui_set_visible(main.distance, val);
    ui_set_visible(main.delay, val);
    ui_set_visible(main.minimum_damage, val);
end, true);

main.cl_sidespeed = cvar.cl_sidespeed;

main.prediction_data = main:create_data();
main.setup_data = main:create_data();

main.tick = -1;
main.height = 18;

main.prev_strafe = nil;

function main:get_minimum_damage()
    local val = ui_get(main.minimum_damage);

    if val == -1 then
        if ui_get(reference.minimum_damage_override[1]) and ui_get(reference.minimum_damage_override[2]) then
            return ui_get(reference.minimum_damage_override[3]);
        end

        return ui_get(reference.minimum_damage)
    end

    return val
end

function main:restore()
    if self.prev_strafe == nil then
        return;
    end

    ui_set(reference.air_strafe, self.prev_strafe);
    self.prev_strafe = nil;
end

function main:autostop(cmd, minimum)
    local lp = entity_get_local_player();

    if lp == nil then
        return self:restore();
    end

    local velocity = main.prediction_data.velocity;
    local speed = velocity:length2d();

    if minimum ~= nil and speed < minimum then
        return self:restore();
    end

    local direction = vector(velocity:angles());
    local real_view = vector(client_camera_angles());

    direction.y = real_view.y - direction.y;
    local forward = vector(angle_to_forward(direction.x, direction.y));

    local negative_side_move = -main.cl_sidespeed:get_float();
    local negative_direction = negative_side_move * forward;

    if self.prev_strafe == nil then
        self.prev_strafe = ui_get(reference.air_strafe);
    end

    ui_set(reference.air_strafe, false);

    cmd.in_speed = 1;

    cmd.forwardmove = negative_direction.x;
    cmd.sidemove = negative_direction.y;
end

function main:predict_command(cmd)
    local lp = entity_get_local_player();

    if lp == nil then
        return
    end

    local flags = entity_get_prop(lp, 'm_fFlags');
    local velocity = vector(entity_get_prop(lp, 'm_vecVelocity'));

    self.prediction_data = self:create_data(flags, velocity);
end

function main:setup_command(cmd)
    if not ui_get(main.master) then
        return self:restore();
    end

    local lp = entity_get_local_player();
    local threat = client_current_threat();

    if lp == nil or threat == nil then
        return self:restore();
    end

    local wpn = entity_get_player_weapon(lp);

    if wpn == nil or not entity_is_ready(lp) or not entity_can_fire(wpn) then
        return self:restore();
    end

    local origin = vector(entity_get_origin(lp));
    local pos = vector(entity_get_origin(threat));

    local distance = pos:dist(origin);
    local max_distance = ui_get(self.distance);

    if max_distance ~= 0 and distance > max_distance then
        return self:restore();
    end

    local velocity = vector(entity_get_prop(lp, 'm_vecVelocity'));
    local animstate = ent(lp):get_anim_state();

    if animstate == nil or animstate.on_ground then
        return self:restore();
    end

    local tick = cmd.command_number;
    local delay = ui_get(self.delay);

    local is_delaying = delay ~= 0;
    local is_peaking = ui_get(self.on_peak_of_height);

    local is_scoped = entity_get_prop(lp, 'm_bIsScoped') ~= 0;
    local is_force = is_delaying and (self.tick > tick) or true;

    local is_peak = is_peaking and (math_abs(velocity.z) < self.height) or true;
    local is_downgoing = origin.z < animstate.last_origin_z;

    if not is_force then
        if is_downgoing or not is_peak then
            return self:restore();
        end

        if is_delaying then
            self.tick = tick + self.delay;
        end
    end

    local max_damage = self:get_minimum_damage();
    local _, damage = client_trace_bullet(lp, origin.x, origin.y, origin.z, pos.x, pos.y, pos.z);

    local health = entity_get_prop(threat, 'm_iHealth');

    if max_damage > 100 then
        max_damage = health + (max_damage - 100);
    end

    if damage < max_damage then
        return self:restore();
    end

    local data = csgo_weapons(wpn);

    local max_speed = is_scoped and data.max_player_speed_alt or data.max_player_speed;
    max_speed = max_speed * 0.34;

    if ui_get(self.autoscope) and not is_scoped then
        cmd.in_attack2 = 1;
    end

    self:autostop(cmd, max_speed);
end

client_set_event_callback('predict_command', function(cmd)
    main:predict_command(cmd);
end);

client_set_event_callback('setup_command', function(cmd)
    main:setup_command(cmd);
end);