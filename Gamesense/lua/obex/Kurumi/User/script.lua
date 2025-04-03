-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
--| kurumi
local tab, container = "aa", "anti-aimbot angles";
local easing = require("gamesense/easing")
client.exec("playvol \"survival/buy_item_01.wav\" 1");

local refs = {
    antiaim = {
        anti_aim = { ui.reference("AA", "Anti-aimbot angles", "Enabled") },
        pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch"),
        yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
        yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw Base"),
        jitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
        body_yaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
        fs = { ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
        fs_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
        fake_limit = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit"),
        edge = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
        roll = ui.reference("AA", "Anti-aimbot angles", "Roll"),
    },
    legs = ui.reference("AA", "Other", "Leg movement"),
    fl = ui.reference("AA", "Fake lag", "Enabled"),
    fl_amt = ui.reference("AA", "Fake lag", "Amount"),
    fl_var = ui.reference("AA", "Fake lag", "Variance"),
    fl_limit = ui.reference("AA", "Fake lag", "Limit"),
    menu = ui.reference("MISC", "Settings", "Menu color"),
    ps = ui.reference("Misc", "Miscellaneous", "Ping spike"),
    rage = { ui.reference("RAGE", "Aimbot", "Enabled") },
    damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    dt = { ui.reference("RAGE", "Other", "Double tap") },
    dt_hc = ui.reference("RAGE", "Other", "Double tap hit chance"),
    fd = ui.reference("RAGE", "Other", "Duck peek assist"),
    mupc = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
    slow = { ui.reference("AA", "other", "slow motion") },
    third_person = { ui.reference("VISUALS", "Effects", "Force third person (alive)") },
    wall = ui.reference("VISUALS", "Effects", "Transparent walls"),
    prop = ui.reference("VISUALS", "Effects", "Transparent props"),
    skybox = ui.reference("VISUALS", "Effects", "Remove Skybox"),
    hs = { ui.reference("AA", "Other", "On shot anti-aim") },
};

ui.set(refs.mupc, 18)

local vars = {
    status = "default",
    players = { },
    target = nil,
    angle = { },
    side = { },
    miss = { },
    hscount = { },
    yaw = nil,
    leaning = false,

    x = 360,
    y = 360,

    antibrute = {
        bruteforce = false,
        timer = { },
    },

    angles = {
        right = 45,
        left = -27,
        desync = 0,
    },

    classnames = {
        "CWorld",
        "CCSPlayer",
        "CFuncBrush"
    },

    phases = { -- will add state based soon
        moving = {
            { 59,-4 },
            { 74,1 },
            { 77,7 },
        },
    },

    etimer = 0,
    shottimer = 0,
};

local menu = {
    d = ui.new_label(tab, container, "\aADD8E6  kurumi.tech \aC0C0C0  recode"),
    tab = ui.new_combobox(tab, container, "\aC0C0C0  tabs", "\aC0C0C0  main", "\aADD8E6  visuals", "\aC0C0C0  misc"),

    main = {
        abf = ui.new_checkbox(tab, container, "\aADD8E6  antibrute"),
        dmnt = ui.new_checkbox(tab, container, "\aC0C0C0  switch on dormant"),
        lgt = ui.new_checkbox(tab, container, "\aADD8E6  legit aa on use"),
        ekey = ui.new_hotkey(tab, container, "\aC0C0C0  key", true),
        hsf = ui.new_checkbox(tab, container, "\aADD8E6  hideshots fix {WIP}"),
        fsk = ui.new_hotkey(tab, container, "\aC0C0C0  freestanding", false),
        rll = ui.new_multiselect(tab, container, "\aADD8E6  Roll", "\aC0C0C0  standing", "\aADD8E6  slowwalk", "\aC0C0C0  air"),
    },

    visuals = {
        crshr = ui.new_checkbox(tab, container, "\aADD8E6  crosshair"),
        style = ui.new_combobox(tab, container, "\aC0C0C0  crosshair style", "old", "new", "other"),
        logs = ui.new_checkbox(tab, container, "\aC0C0C0  logs"),
        d = ui.new_label(tab, container, "\aADD8E6  color"),
        clr = ui.new_color_picker(tab, container, "indicator colors", 135, 150, 215, 255),
        clr2 = ui.new_color_picker(tab, container, "indicator colors 2", 135, 150, 215, 255),
        dbg = ui.new_checkbox(tab, container, "\aADD8E6  debug panel"),
    },

    other = {
        flk = ui.new_hotkey(tab, container, "\aC0C0C0  exploit anti-aim (in beta)", false),
        inv = ui.new_hotkey(tab, container, "\aC0C0C0  invert exploit anti-aim", false),
        legtype = ui.new_combobox(tab, container, "\aADD8E6  leg breaker", "\aC0C0C0  Off", "\aC0C0C0  Jitter", "\aC0C0C0  Random", "\aC0C0C0  Static"),
        staticlegs = ui.new_checkbox(tab, container, "static legs"),
        reset_b = ui.new_button(tab, container, "\aADD8E6  refresh anti-aim data", function()
            vars.status = "default";
            vars.target = nil;
            vars.angle = { };
            vars.side = { };
            vars.miss = { };
            vars.hscount = { };
            vars.antibrute.bruteforce = false;
            vars.antibrute.timer = { };
            vars.angles.right = 0;
            vars.angles.left = 0;
            print("successfully reset logged data");
        end),
    },
};

local easedalphas = {
    dtalpha = 0,
    dtalpha1 = 0,
    fsalpha = 0,
    fsalpha1 = 0,
    osalpha = 0,
    osalpha1 = 0,
    leanalpha = 0,
    leanalpha1 = 0,
};

local hk_switches = {
	[true] = {'Default', 'Always On'},
    [false] = {'-', 'On hotkey'}
};

-- BIG PASTEZ // Credit to whoever made this shit
local client_color_log, type = client.color_log, type;
local colorful_text = {};
colorful_text.lerp = function(self, from, to, duration)
    if type(from) == 'table' and type(to) == 'table' then
        return { 
            self:lerp(from[1], to[1], duration), 
            self:lerp(from[2], to[2], duration), 
            self:lerp(from[3], to[3], duration) 
        };
    end

    return from + (to - from) * duration;
end
colorful_text.text = function(self, ...)
    local menu = false;
    local alpha = 255
    local f = '';
    
    for i, v in ipairs({ ... }) do
        if type(v) == 'boolean' then
            menu = v;
        elseif type(v) == 'number' then
            alpha = v;
        elseif type(v) == 'string' then
            f = f .. v;
        elseif type(v) == 'table' then
            if type(v[1]) == 'table' and type(v[2]) == 'string' then
                f = f .. ('\a%02x%02x%02x%02x'):format(v[1][1], v[1][2], v[1][3], alpha) .. v[2];
            elseif type(v[1]) == 'table' and type(v[2]) == 'table' and type(v[3]) == 'string' then
                for k = 1, #v[3] do
                    local g = self:lerp(v[1], v[2], k / #v[3])
                    f = f .. ('\a%02x%02x%02x%02x'):format(g[1], g[2], g[3], alpha) .. v[3]:sub(k, k)
                end
            end
        end
    end

    return ('%s\a%s%02x'):format(f, (menu) and 'cdcdcd' or 'ffffff', alpha);
end
------------------------------------------------------ END OF DA PASTE

-- SUCK UR MUM IT DOESNT WORK WHEN CALLED IT IN ITS OWN TABLE
local function vec3_normalise(x, y, z)
    local len = math.sqrt(x * x + y * y + z * z);
    if len == 0 then
        return 0, 0, 0;
    end

    local r = 1 / len;
    return x * r, y * r, z * r;
end

local function vec3(ax, ay, az, bx, by, bz)
    return ax * bx + ay * by + az * bz;
end

local utilities = { };
local utilities = {
    contains = function(table, val)
        for i = 1, #table do
            if table[i] == val then
                return true;
            end
        end
        return false;
    end,

    get_velocity = function(ent)
        local x, y, z = entity.get_prop(ent, "m_vecVelocity")
        if x == nil then return end
        return math.sqrt(x * x + y * y + z * z);
    end,

    normalise = function(yaw)
        while yaw > 180 do yaw = yaw - 360 end
        while yaw < -180 do yaw = yaw + 360 end
        return yaw
    end,

    round = function(num, amt)
        local mult = 10 ^ (amt or 0);
        return math.floor(num * mult + 0.5) / mult;
    end,

    angle_to_vec = function(pitch, yaw)
        local p, y = math.rad(pitch), math.rad(yaw);
        local sp, cp, sy, cy = math.sin(p), math.cos(p), math.sin(y), math.cos(y);
        return cp * cy, cp * sy, -sp;
    end,

    get_fov = function(ent, vx, vy, vz, lx, ly, lz)
        local ox, oy, oz = entity.get_prop(ent, "m_vecOrigin");
        if ox == nil then
            return -1;
        end
    
        local dx, dy, dz = vec3_normalise(ox - lx, oy - ly, oz - lz);
        return vec3(dx, dy, dz, vx, vy, vz);
    end,

    ang_on_screen = function(x, y)
        if x == 0 and y == 0 then return 0 end
    
        return math.deg(math.atan2(y, x));
    end,

    dist = function(target, ent)
        local x, y, z = entity.hitbox_position(target, 0);
        local x1, y1, z1 = client.eye_position();
        
        local p = { x1, y1, z1 };
        
        local a = { x, y, z };
        local b = { ent.x, ent.y, ent.z };
        
        local ab = { b[1] - a[1], b[2] - a[2], b[3] - a[3] };
        local len = math.sqrt(ab[1] ^ 2 + ab[2] ^ 2 + ab[3] ^ 2);
        local d = { ab[1] / len, ab[2] / len, ab[3] / len };
        local ap = { p[1] - a[1], p[2] - a[2], p[3] - a[3] };
        local d2 = d[1] * ap[1] + d[2] * ap[2] + d[3] * ap[3];
        
        bp = { a[1] + d2 * d[1], a[2] + d2 * d[2], a[3] + d2 * d[3] };
        
        return (bp[1] - x1) + (bp[2] - y1) + (bp[3] - z1);
    end,

    air_state = function(ent)
        local flags = entity.get_prop(ent, "m_fFlags");
        if bit.band(flags, 1) == 0 then
            return true;
        else
            return false;
        end
    end,

    duck_state = function(ent)
        local flags = entity.get_prop(ent, "m_fFlags");
        if bit.band(flags, 4) == 4 then
            return true;
        else
            return false;
        end
    end,

    visible = function(reference, state)
        if type(reference) == "table" then
            for i,v in pairs(reference) do
                if type(v) == "table" then
                    for j = 1, #v do
                        ui.set_visible(v[j], state);
                    end
                else
                    ui.set_visible(v, state);
                end
            end
        else
            ui.set_visible(reference, state);
        end
    end,

    clamp = function(num, min, max)
        if num > max then
            return max;
        elseif min > num then
            return min;
        end
        return num;
    end,

    cursor = function(x, y, w, h, debug)
        local mousex, mousey = ui.mouse_position();
        debug = debug or false;
        if debug then
            renderer.rectangle(x, y, w, h, 255, 0, 0, 50);
        end
        return mousex >= x and mousex <= x + w and mousey >= y and mousey <= y + h;
    end,

    distance3d = function(x1, y1, z1, x2, y2, z2)
        return math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1));
    end,
    
    entity_has_c4 = function(ent)
        local bomb = entity.get_all("CC4")[1];
        return bomb ~= nil and entity.get_prop(bomb, "m_hOwnerEntity") == ent;
    end,
};

local anti_aim = { };
local anti_aim = {
    bruteforce = function(c) -- recoded dis because it was inaccurate
        if not ui.get(menu.main.abf) then return end
        local ent = client.userid_to_entindex(c.userid);
        if not entity.is_dormant(ent) and entity.is_enemy(ent) and entity.is_alive(entity.get_local_player()) then
            local ent_pos = { entity.get_prop(ent, "m_vecOrigin") };
            local loc_pos = { entity.get_prop(ent, "m_vecOrigin") };
            local delta = utilities.dist(ent, c);
            local ent_pos = { entity.get_prop(ent, "m_vecOrigin") };
            local loc_pos = { entity.hitbox_position(entity.get_local_player(), 0) };
            local end_pos = { loc_pos[1] - ent_pos[1], loc_pos[2] - ent_pos[2], loc_pos[3] + 60 - ent_pos[3] };
    
            if math.abs(delta) < 50 and math.abs(delta) > 9 then
                vars.side[ent] = 1 -- WHY WAS I DOING ALL THIS DUMBASS SIDE DETECT SHIT ITS USELESS
                -- seems better this way... cheats seem to bruteforce high degree jitter in a weird way compared to static

                if ui.get(menu.visuals.logs) then
                    print("miss detected at ", vars.angle[vars.target],"; ", vars.side[vars.target], " player: ", entity.get_player_name(vars.target));
                end
                
                if vars.miss[ent] == nil then vars.miss[ent] = 0 end
                if vars.antibrute.timer[ent] == nil then vars.antibrute.timer[ent] = 0 end
                if vars.miss[ent] > 3 then vars.miss[ent] = 1 end

                vars.miss[ent] = vars.miss[ent] + 1;
                vars.angle[ent] = delta * vars.side[ent] * 3; -- values were coming out too small // i think this makes aa a bit better
                vars.antibrute.timer[ent] = globals.curtime() + 5;
                if math.abs(vars.angle[ent]) > 49 then
                    vars.angle[ent] = vars.side[ent] > 0 and 49 or -30
                end
            end
        end
    end,

    target = function()
        local ent = entity.get_local_player();
        if ent == nil then return end
        local lx, ly, lz = entity.get_prop(ent, "m_vecOrigin");

        if lx == nil then return end
        
        local players = entity.get_players(true);
        local pitch, yaw = client.camera_angles();
        local vx, vy, vz = utilities.angle_to_vec(pitch, yaw);
        
        local closest_fov_cos = -1;
        vars.target = nil;
        for i = 1, #players do
            local idx = players[i];
            if entity.is_alive(idx) then
                local fov_cos = utilities.get_fov(idx, vx, vy, vz, lx, ly, lz);
                if fov_cos > closest_fov_cos then
                    closest_fov_cos = fov_cos;
                    vars.target = idx;
                end
            end
        end
    end,

    run = function(cmd)
        if vars.target ~= nil and vars.antibrute.timer[vars.target] == nil then vars.antibrute.timer[vars.target] = 0 end
        vars.angles.desync = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 116 - 58;
        local amt = ui.get(menu.other.inv) and 90 or -90;
        ui.set(refs.antiaim.roll, 0);
        vars.antibrute.bruteforce = vars.target == nil or vars.antibrute.timer[vars.target] > globals.curtime();
        vars.leaning = false;
        local state = ui.get(menu.main.fsk)
		for k, v in pairs(refs.antiaim.fs) do
			ui.set(v, hk_switches[state][k])
		end
        if ui.get(refs.hs[2]) and ui.get(menu.main.hsf) and not ui.get(refs.fd) then
            ui.set(refs.fl_limit, math.random(1,3));
        else
            ui.set(refs.fl_limit, 14);
        end
        if ui.get(menu.main.dmnt) and entity.is_dormant(vars.target) then
            vars.status = "Dormant";
            ui.set(refs.antiaim.jitter[1], "center");
            ui.set(refs.antiaim.body_yaw[1], "jitter");
            ui.set(refs.antiaim.yaw[2], 1);
            ui.set(refs.antiaim.body_yaw[2], 0);
            ui.set(refs.antiaim.fake_limit, 60);
            ui.set(refs.antiaim.jitter[2], -15);
        else
            if vars.angle[vars.target] ~= nil then
                if vars.angle[vars.target] > 0 then
                    vars.angles.right = vars.angle[vars.target];
                    vars.angles.left = -36;
                elseif vars.angle[vars.target] < 0 then
                    vars.angles.left = vars.angle[vars.target];
                    vars.angles.right = 38;
                end
            else
                vars.angles.left = -36;
                vars.angles.right = 38;
            end

            if ui.get(menu.main.ekey) and ui.get(menu.main.lgt) then
                vars.status = "Usage"
                ui.set(refs.antiaim.yaw_base, "local view")
                ui.set(refs.antiaim.pitch, "off")
                ui.set(refs.antiaim.jitter[1], "off");
                ui.set(refs.antiaim.body_yaw[1], "static");
                ui.set(refs.antiaim.fake_limit, 60);
                ui.set(refs.antiaim.jitter[2], 0);
                ui.set(refs.antiaim.body_yaw[2], -180); -- just doing this so its freestanding (why tf would u left e peek (unless ur a boss ofc))
                ui.set(refs.antiaim.yaw[2], 180);
                vars.etimer = globals.curtime() + 0.1 -- for some reason when changing pitch the desync stuff messes upz (idk). this fixes.
            else
                ui.set(refs.antiaim.pitch, "minimal")
                ui.set(refs.antiaim.yaw_base, "at targets")
                if vars.etimer > globals.curtime() then
                    ui.set(refs.antiaim.jitter[1], "center");
                    ui.set(refs.antiaim.body_yaw[1], "opposite");
                    ui.set(refs.antiaim.fake_limit, 39);
                    ui.set(refs.antiaim.jitter[2], 8);
                    ui.set(refs.antiaim.body_yaw[2], 0); -- just doing this so its freestanding (why tf would u left e peek (unless ur a boss ofc))
                    ui.set(refs.antiaim.yaw[2], 0);
                elseif ui.get(menu.other.flk) then
                    vars.status = string.format("fake %s", amt > 0 and "right" or "left");
                    local angles = { client.camera_angles() };
                    cmd.allow_send_packet = false;
                    ui.set(refs.fl_limit, 17);
    
                    if cmd.chokedcommands % 2 == 0 then
                        cmd.yaw = angles[2] + 180 + amt;
                        cmd.pitch = 89;
                    else
                        cmd.yaw = angles[2] + 180;
                        cmd.pitch = 89;
                    end
                elseif utilities.contains(ui.get(menu.main.rll),"standing") and utilities.get_velocity(entity.get_local_player()) < 5 or utilities.contains(ui.get(menu.main.rll),"slowwalk") and ui.get(refs.slow[2]) or utilities.contains(ui.get(menu.main.rll),"air") and utilities.air_state(entity.get_local_player()) then
                    vars.leaning = true;
                    if vars.angle[vars.target] == nil then
                        cmd.roll = 50;
                        ui.set(refs.antiaim.jitter[1], "off");
                        ui.set(refs.antiaim.body_yaw[1], "static");
                        ui.set(refs.antiaim.fake_limit, 60);
                        ui.set(refs.antiaim.jitter[2], 0);
                        ui.set(refs.antiaim.body_yaw[2], 90);
                        ui.set(refs.antiaim.yaw[2], 13);
                    else
                        if vars.angle[vars.target] < 0 then
                            cmd.roll = 50;
                            ui.set(refs.antiaim.jitter[1], "off");
                            ui.set(refs.antiaim.body_yaw[1], "static");
                            ui.set(refs.antiaim.fake_limit, 60);
                            ui.set(refs.antiaim.jitter[2], 0);
                            ui.set(refs.antiaim.body_yaw[2], 90);
                            ui.set(refs.antiaim.yaw[2], 23);
                        else
                            cmd.roll = -50;
                            ui.set(refs.antiaim.jitter[1], "off");
                            ui.set(refs.antiaim.body_yaw[1], "static");
                            ui.set(refs.antiaim.fake_limit, 60);
                            ui.set(refs.antiaim.jitter[2], 0);
                            ui.set(refs.antiaim.body_yaw[2], -90);
                            ui.set(refs.antiaim.yaw[2], -23);
                        end
                    end
                else
                    --[[if vars.antibrute.bruteforce == true then
                        vars.status = vars.target == nil and "Dormancy" or "Miss-Detected", globals.curtime() - vars.antibrute.timer[vars.target];
                    else--]]if utilities.air_state(entity.get_local_player()) then
                        vars.status = "Air";
                    elseif utilities.duck_state(entity.get_local_player()) then
                        vars.status = "Duck";
                    elseif utilities.get_velocity(entity.get_local_player()) > 5 then
                        vars.status = "Moving";
                    else
                        vars.status = "Standing";
                    end
    
                    ui.set(refs.antiaim.jitter[1], "center");
                    ui.set(refs.antiaim.body_yaw[1], "jitter");
                    ui.set(refs.antiaim.fake_limit, 60);
                    ui.set(refs.antiaim.body_yaw[2], vars.hscount[vars.target] == 1 and 5 or 0);

                    if vars.antibrute.bruteforce == true then
                        ui.set(refs.antiaim.jitter[2], 0);
                        ui.set(refs.antiaim.yaw[2], vars.angles.desync > 0 and vars.angles.left or vars.angles.right);
                    else           
                        if vars.hscount[vars.target] == nil then vars.hscount[vars.target] = 1 end
                        ui.set(refs.antiaim.jitter[2], vars.phases.moving[vars.hscount[vars.target]][1]);
                        ui.set(refs.antiaim.yaw[2], vars.phases.moving[vars.hscount[vars.target]][2]);
                    end
                end
            end
        end
    end,

    animstuffz = function() -- shit pasted mess lolz
        local randome = math.random(0,100);
        local timer = globals.tickcount() % 3;
        if ui.get(menu.other.staticlegs) then
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6);
        end
        if ui.get(menu.other.legtype) == "Static" then
            ui.set(refs.legs,"Always slide")
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0);
        elseif ui.get(menu.other.legtype) == "Random" then;
            entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0);
			if randome > 50 then
                ui.set(refs.legs,"Always slide");
            else
                ui.set(refs.legs,"Never slide");
            end
        elseif ui.get(menu.other.legtype) == "Jitter" then;
            if timer > 1 then
                entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0);
                ui.set(refs.legs,"Always slide");
            else
                ui.set(refs.legs,"Never slide");
            end
        end
    end,

    on_use_antiaim = function(cmd) -- big pastez from teamskeet.. code messy for this reason
        if not ui.get(menu.main.lgt) then return end
		local distance = 100
		local bomb = entity.get_all("CPlantedC4")[1]
		local bomb_x, bomb_y, bomb_z = entity.get_prop(bomb, "m_vecOrigin")
		if bomb_x ~= nil then
			local player_x, player_y, player_z = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
			distance = utilities.distance3d(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
		end	
		local team_num = entity.get_prop(entity.get_local_player(), "m_iTeamNum")
		local defusing = team_num == 3 and distance < 62
		local on_bombsite = entity.get_prop(entity.get_local_player(), "m_bInBombZone")
		local has_bomb = utilities.entity_has_c4(entity.get_local_player())
		local trynna_plant = on_bombsite ~= 0 and team_num == 2 and has_bomb
		local px, py, pz = client.eye_position()
		local pitch, yaw = client.camera_angles()
		local sin_pitch = math.sin(math.rad(pitch))
		local cos_pitch = math.cos(math.rad(pitch))
		local sin_yaw = math.sin(math.rad(yaw))
		local cos_yaw = math.cos(math.rad(yaw))
		local dir_vec = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }
		local fraction, entindex = client.trace_line(entity.get_local_player(), px, py, pz, px + (dir_vec[1] * 8192), py + (dir_vec[2] * 8192), pz + (dir_vec[3] * 8192))
		local using = true
		if entindex ~= nil then
			for i=0, #vars.classnames do
				if entity.get_classname(entindex) == vars.classnames[i] then
					using = false
				end
			end
		end
		if not using and not trynna_plant and not defusing then
			cmd.in_use = 0
		end
    end,
};

local visuals = { };
local visuals = {
    debug = function()
        if ui.get(menu.visuals.dbg) then
            local dsync = math.abs(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 116 - 58);
            local ent = entity.get_players(true);
            local clr = { ui.get(menu.visuals.clr) };
            local ddd = "";
            local aaa = "";
            ddd = vars.angle[vars.target] ~= nil and utilities.round(vars.angle[vars.target]) or "NIL";
            aaa = vars.status ~= "Miss-Detected" and vars.status or "miss";

            if utilities.cursor(vars.x, vars.y, 200, 100, false) and client.key_state(0x01) then;
                local your_mum = { ui.mouse_position() };
                vars.x = your_mum[1] - 10;
                vars.y = your_mum[2] - 10;
            end;

            renderer.gradient(vars.x, vars.y, 100, 85, clr[1], clr[2], clr[3], clr[4], clr[1], clr[2], clr[3], 0, false);
            renderer.gradient(vars.x, vars.y + 18, 100, 4, clr[1], clr[2], clr[3], 115, clr[1], clr[2], clr[3], clr[4], true);

            renderer.text(vars.x + 2, vars.y + 5, 255, 255, 255, 255, "l-", nil, "KURUMI.TECH DEBUG PANEL");
            renderer.text(vars.x + 2, vars.y + 24, 255, 255, 255, 255, "l-", nil, string.format("TARGET YAW OFFSET: %s", ui.get(refs.antiaim.yaw[2])));
            renderer.text(vars.x + 2, vars.y + 34, 255, 255, 255, 255, "l-", nil, string.format("REAL DESYNC DELTA: %s", utilities.round(dsync)));
            renderer.text(vars.x + 2, vars.y + 44, 255, 255, 255, 255, "l-", nil, string.format("PLAYER STATE: %s", string.upper(aaa)));
            renderer.text(vars.x + 2, vars.y + 54, 255, 255, 255, 255, "l-", nil, string.format("TARGET: %s", string.upper(entity.get_player_name(vars.target))));
            renderer.text(vars.x + 2, vars.y + 64, 255, 255, 255, 255, "l-", nil, string.format("LOGGED ANGLE:  %s", ddd));

        end
    end,

    crosshair = function()
        if not ui.get(menu.visuals.crshr) or not entity.is_alive(entity.get_local_player()) then return end;
        local w,h = client.screen_size();
        local spacing = renderer.measure_text("c-", "JESUS");
        local yo = math.sin(math.abs((math.pi * -1) + (globals.curtime() * (1 / 0.35)) % (math.pi * 2))) * 255;
        local dsync = math.abs(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 116 - 58);
        local added = 0;
        dsync = dsync ~= nil and dsync or 1;
        local color1 = { ui.get(menu.visuals.clr) };
        local color2 = { ui.get(menu.visuals.clr2) };

        -- EASING THIS IS DOGSHIT NOT OPTIMIZED PLZ HOW DO I DO THIS PROPERLY
        easedalphas.dtalpha1 = ui.get(refs.dt[2]) and 255 or 0;
        easedalphas.dtalpha = easing.quint_in(1, easedalphas.dtalpha, easedalphas.dtalpha1 - easedalphas.dtalpha, 1.6);
        easedalphas.dtalpha = easedalphas.dtalpha > 245 and 255 or easedalphas.dtalpha;
        easedalphas.fsalpha1 = ui.get(refs.antiaim.fs[2]) and 255 or 0;
        easedalphas.fsalpha = easing.quint_in(1, easedalphas.fsalpha, easedalphas.fsalpha1 - easedalphas.fsalpha, 1.6);
        easedalphas.fsalpha = easedalphas.fsalpha > 245 and 255 or easedalphas.fsalpha;
        easedalphas.osalpha1 = ui.get(refs.hs[2]) and 255 or 0;
        easedalphas.osalpha = easing.quint_in(1, easedalphas.osalpha, easedalphas.osalpha1 - easedalphas.osalpha, 1.6);
        easedalphas.osalpha = easedalphas.osalpha > 245 and 255 or easedalphas.osalpha;
        easedalphas.leanalpha1 = vars.leaning and 255 or 0;
        easedalphas.leanalpha = easing.quint_in(1, easedalphas.leanalpha, easedalphas.leanalpha1 - easedalphas.leanalpha, 1.6);
        easedalphas.leanalpha = easedalphas.leanalpha > 245 and 255 or easedalphas.leanalpha;
        --////////////////////////////////////////////////////////////////////////////////////////

        if ui.get(menu.visuals.style) == "new" then
            renderer.text(w/2 - 11, h/2 + 20, color1[1], color1[2], color1[3], color1[4], "c-", nil, "                            KURUMI.TECH       ");
            renderer.text(w/2, h/2 + 28, 185, 185, 185, 255, "c-", nil, string.upper(vars.status));
            added = added + (easedalphas.leanalpha / 31.875);
            renderer.text(w/2, h/2 + 28 + added, 185, 185, 185, easedalphas.leanalpha, "c-", easedalphas.leanalpha / 13, "LEAN");
            added = added + (easedalphas.osalpha / 31.875);
            renderer.text(w/2, h/2 + 28 + added, 185, 185, 185, easedalphas.osalpha, "c-", easedalphas.osalpha / 23, "OS");
            added = added + (easedalphas.dtalpha / 31.875);
            renderer.text(w/2, h/2 + 28 + added, 185, 185, 185, easedalphas.dtalpha, "c-", easedalphas.dtalpha / 25, "DT");
            added = added + (easedalphas.fsalpha / 31.875);
            renderer.text(w/2, h/2 + 28 + added, 185, 185, 185, easedalphas.fsalpha, "c-", easedalphas.fsalpha / 6, "FREESTAND");
        elseif ui.get(menu.visuals.style) == "old" then
            renderer.text(w / 2, h / 2 + 25, 255, 255, 255, 255, "c-", 0, "KURUMI.TECH")
            renderer.text(w / 2, h / 2 + 38 , color1[1], color1[2], color1[3], 155, "c-", 0, string.upper(vars.status))
            renderer.rectangle(w / 2 - 20, h / 2 + 30, 42, 4, 18, 18, 18, 155)
            renderer.gradient(w / 2 - 19, h / 2 + 31, vars.antibrute.bruteforce and anim or utilities.clamp(dsync + 1 / 1.4, 0, 40), 2, color1[1], color1[2], color1[3], color1[4], color1[1], color1[2], color1[3], 155, true)
        elseif ui.get(menu.visuals.style) == "other" then
            renderer.text(w / 2, h / 2 + 25, 0,0,0,0, "c-", 0, colorful_text:text(
                { { color1[1], color1[2], color1[3] }, "K" },
                { { color1[1], color1[2], color1[3] }, { color2[1], color2[2], color2[3] }, "URUMI.TECH" } 
            ));
            renderer.rectangle(w / 2 - 20, h / 2 + 31, 42, 4, 18, 18, 18, 155);
            renderer.gradient(w / 2 - 19, h / 2 + 32, vars.antibrute.bruteforce and anim or utilities.clamp(dsync + 1 / 1.4, 0, 40), 2, color1[1], color1[2], color1[3], color1[4], color2[1], color2[2], color2[3], 155, true);
            added = added + (easedalphas.osalpha / 25.5);
            renderer.text(w/2, h/2 + 31 + added, color1[1], color1[2], color1[3], easedalphas.osalpha / 1.3, "c-", easedalphas.osalpha / 6, "HIDESHOTS");
            added = added + (easedalphas.dtalpha / 25.5);
            renderer.text(w/2, h/2 + 31 + added, color1[1], color1[2], color1[3], easedalphas.dtalpha / 1.3, "c-", easedalphas.dtalpha / 5, "DOUBLETAP");
            added = added + (easedalphas.fsalpha / 25.5);
            renderer.text(w/2, h/2 + 31 + added, color1[1], color1[2], color1[3], easedalphas.fsalpha / 1.3, "c-", easedalphas.fsalpha / 6, "FREESTAND");
            added = added + (easedalphas.leanalpha / 25.5);
            renderer.text(w/2, h/2 + 31 + added, color1[1], color1[2], color1[3], easedalphas.leanalpha / 1.3, "c-", easedalphas.leanalpha / 13, "LEAN");
        end
    end,
};

client.set_event_callback("bullet_impact", function(e)
	client.set_event_callback("player_death", function(e)
		local local_player = entity.get_local_player();
		if victim_entindex == local_player then
			if -vars.angles.left + vars.angles.right < 35 or vars.angles.left + vars.angles.right > 30 or vars.angles.left + vars.angles.right < -16 then
				vars.angle = { };
			end
		end
	end)
end)
client.set_event_callback("cs_game_disconnected", function()
    vars.angle = { };
	vars.miss = { };
	vars.side = { };
end)
client.set_event_callback("game_newmap", function()
    vars.angle = { };
	vars.miss = { };
	vars.side = { };
end)
client.set_event_callback("paint", function(c)
    visuals.crosshair();
    visuals.debug();
end)
client.set_event_callback("setup_command", function(cmd)
    anti_aim.target(e);
    anti_aim.run(cmd);
    anti_aim.on_use_antiaim(cmd)
end)
client.set_event_callback("bullet_impact", function(c)
    anti_aim.bruteforce(c);
end)
client.set_event_callback('player_hurt', function(e)
    if vars.antibrute.bruteforce then return end
    local attacker, target = client.userid_to_entindex(e.attacker), client.userid_to_entindex(e.userid);
    if target == entity.get_local_player() and e.hitgroup == 1 then
        vars.hscount[attacker] = vars.hscount[attacker] + 1
        if vars.hscount[attacker] > 3 then
            vars.hscount[attacker] = 1
        end
    end
    if attacker ~= entity.get_local_player() and target == entity.get_local_player() and vars.angle[attacker] ~= nil then
        if vars.angle[attacker] < 8 then
            vars.angle[attacker] = nil;
        else
            if vars.angles.desync > 0 then
                vars.angle[attacker] = 28;
            else
                vars.angle[attacker] = -26;
            end
        end
    end
end)
client.set_event_callback("shutdown", function()
    utilities.visible(refs.antiaim, true);
end)
client.set_event_callback("paint_ui", function()
    utilities.visible(refs.antiaim, false);
    if ui.get(menu.tab) == "\aC0C0C0  main" then
        utilities.visible(menu.main, true);
        utilities.visible(menu.visuals, false);
        utilities.visible(menu.other, false);
    elseif ui.get(menu.tab) == "\aADD8E6  visuals" then
        if ui.get(menu.visuals.style) == "\aC0C0C0  misc " then
            utilities.visible(menu.visuals.clr2, true);
        else
            utilities.visible(menu.visuals.clr2, false);
        end
        utilities.visible(menu.main, false);
        utilities.visible(menu.visuals, true);
        utilities.visible(menu.other, false);
    else
        utilities.visible(menu.main, false);
        utilities.visible(menu.visuals, false);
        utilities.visible(menu.other, true);
    end
end)
client.set_event_callback("pre_render", function(c)
    anti_aim.animstuffz()
end)