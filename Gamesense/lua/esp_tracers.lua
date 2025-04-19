local ffi = require 'ffi'

local dir = { "Visuals", "Effects" }
local blist = { "blueglow1", "bubble", "glow01", "physbeam", "purpleglow1", "light_glow02", "purplelaser1", "radio", }

local tracers = ui.new_checkbox(dir[1], dir[2], "Bullet beams")
local tracers_style = ui.new_combobox(dir[1], dir[2], "\n style", blist)
local tracers_thickness = ui.new_slider(dir[1], dir[2], "\n thickness", 10, 100, 25, true, nil, .1)
local tracers_time = ui.new_slider(dir[1], dir[2], "\n time", 2, 50, 12, true, nil, 0.1)

ui.new_label(dir[1], dir[2], "Tracers default")
local tracers_color = ui.new_color_picker(dir[1], dir[2], "Bullet beams color", 10, 250, 85, 145)

local tracers_hit = ui.new_checkbox(dir[1], dir[2], "Tracers hit color")
local tracers_color_hit = ui.new_color_picker(dir[1], dir[2], "Bullet beams color 2", 150, 130, 255, 255)

local tracers_enemy = ui.new_checkbox(dir[1], dir[2], "Tracers enemy color")
local tracers_color_enemy = ui.new_color_picker(dir[1], dir[2], "Bullet beams color 3", 255, 0, 0, 255)

ui.set(tracers_style, "physbeam")

ffi.cdef[[
    typedef struct {
		float x;
		float y;
		float z;	
    } vec3_t;
    
    struct beam_info_t {
        int m_type;
        void* m_start_ent;
        int m_start_attachment;
        void* m_end_ent;
        int m_end_attachment;
        vec3_t m_start;
        vec3_t m_end;
        int m_model_index;
        const char *m_model_name;
        int m_halo_index;
        const char *m_halo_name;
        float m_halo_scale;
        float m_life;
        float m_width;
        float m_end_width;
        float m_fade_length;
        float m_amplitude;
        float m_brightness;
        float m_speed;
        int m_start_frame;
        float m_frame_rate;
        float m_red;
        float m_green;
        float m_blue;
        bool m_renderable;
        int m_num_segments;
        int m_flags;
        vec3_t m_center;
        float m_start_radius;
        float m_end_radius;
    };

    typedef void (__thiscall* draw_beams_t)(void*, void*);
    typedef void*(__thiscall* create_beam_points_t)(void*, struct beam_info_t&);
]]

local render_beams_signature = "\xB9\xCC\xCC\xCC\xCC\xA1\xCC\xCC\xCC\xCC\xFF\x10\xA1\xCC\xCC\xCC\xCC\xB9"
local match = client.find_signature("client_panorama.dll", render_beams_signature) or error("render_beams_signature not found")
local render_beams = ffi.cast('void**', ffi.cast("char*", match) + 1)[0] or error("render_beams is nil") 
local render_beams_class = ffi.cast("void***", render_beams)
local render_beams_vtbl = render_beams_class[0]

local draw_beams = ffi.cast("draw_beams_t", render_beams_vtbl[6]) or error("couldn't cast draw_beams_t", 2)
local create_beam_points = ffi.cast("create_beam_points_t", render_beams_vtbl[12]) or error("couldn't cast create_beam_points_t", 2)

local create_beams = function(startpos, endpos, red, green, blue, alpha)
    local beam_info = ffi.new("struct beam_info_t")

    beam_info.m_type = 0x00
    beam_info.m_model_index = -1
    beam_info.m_halo_scale = 0

    beam_info.m_life = ui.get(tracers_time)*0.1
    beam_info.m_fade_length = 1

    beam_info.m_width = ui.get(tracers_thickness) * .1 -- multiplication is faster than division
    beam_info.m_end_width = ui.get(tracers_thickness) * .1 -- multiplication is faster than division

    beam_info.m_model_name = "sprites/" .. ui.get(tracers_style) .. ".vmt"

    beam_info.m_amplitude = 2.3
    beam_info.m_speed = 0.2

    beam_info.m_start_frame = 0
    beam_info.m_frame_rate = 0

    beam_info.m_red = red 
    beam_info.m_green = green
    beam_info.m_blue = blue
    beam_info.m_brightness = alpha

    beam_info.m_num_segments = 2
    beam_info.m_renderable = true

    beam_info.m_flags = bit.bor(0x00000100 + 0x00000200 + 0x00008000)

    beam_info.m_start = startpos
    beam_info.m_end = endpos

    local beam = create_beam_points(render_beams_class, beam_info) 

    if beam ~= nil then 
        draw_beams(render_beams, beam)
    end
end

-- HANDLER
local data = {
    origin = { },
    impacts = { },
    last_attack = 0
}

local reset = function()
    data = { origin = { }, impacts = { }, last_attack = 0 }
end

local command = function(e)
    local me = entity.get_local_player()
    local wpn = entity.get_player_weapon(me)

    local next_attack = entity.get_prop(wpn, "m_flNextPrimaryAttack")

    if me == nil or wpn == nil or next_attack == nil then
        return
    end

    if data.last_attack ~= next_attack or data.last_attack == 0 then
        if data.last_attack ~= 0 then
            for i = 10, 2, -1 do 
                data.origin[i] = data.origin[i-1]
            end

            data.origin[1] = { client.eye_position() }
        end

        data.last_attack = next_attack
    end
end

local bullet_handler = function(e)
    if not ui.get(tracers) or #data.origin == 0 then
        return
    end

    local tick = globals.tickcount()

    local target = client.userid_to_entindex(e.userid)
    local me = entity.get_local_player()

    if data.impacts[tick] == nil then data.impacts[tick] = { } end
    if data.impacts[tick][target] == nil then 
        data.impacts[tick][target] = {
            impacts = { }
        }
    end

    local imp_data = data.impacts[tick][target]

    imp_data.should_draw = true
    imp_data.did_hit = false
    imp_data.is_enemy = target ~= me and entity.is_enemy(target)
    imp_data.eye_pos = target ~= me and { entity.hitbox_position(target, 0) } or nil

    imp_data.impacts[#imp_data.impacts + 1] = {
        x = e.x,
        y = e.y,
        z = e.z
    }
end

local hurt_handler = function(e)
    if not ui.get(tracers) or not ui.get(tracers_hit) then
        return
    end

    local hitgroups = {
        [1] = {0, 1},
        [2] = {4, 5, 6},
        [3] = {2, 3},
        [4] = {13, 15, 16},
        [5] = {14, 17, 18},
        [6] = {7, 9, 11},
        [7] = {8, 10, 12}
    }

    local tick = globals.tickcount()

    local me = entity.get_local_player()
    local victim_entindex = client.userid_to_entindex(e.userid)
    local attacker_entindex = client.userid_to_entindex(e.attacker)

    if attacker_entindex ~= entity.get_local_player() then
        return
    end

    if data.impacts[tick] == nil or data.impacts[tick][me] == nil or data.impacts[tick][me].impacts == nil then
        return
    end

    local data = data.impacts[tick][me]

    local simpacts = data.impacts
    local hitboxes = hitgroups[e.hitgroup]

    -- calculations
    local hit = nil
    local closest = math.huge

    for i=1, #simpacts do
        local impact = simpacts[i]

        if hitboxes ~= nil then
            for j=1, #hitboxes do
                local x, y, z = entity.hitbox_position(victim_entindex, hitboxes[j])
                local distance = math.sqrt((impact.x - x) ^ 2 + (impact.y - y) ^ 2 + (impact.z - z) ^ 2)

                if distance < closest then
                    hit = impact
                    closest = distance
                end
            end
        end
    end

    data.did_hit = hit ~= nil
end

local paint_handler = function()
    if not ui.get(tracers) then
        return reset()
    end

    local me = entity.get_local_player()

    for tick, entities in pairs(data.impacts) do
        for key, target in pairs(entities) do
            local target_checks = me == key or (ui.get(tracers_enemy) and entity.is_enemy(key))

            if target.should_draw and not target_checks then
                target.should_draw = false
            end

            if target.should_draw then
                target.should_draw = false

                local impacts = target.impacts
                local last_impact = impacts[#impacts]

                local r, g, b, a = ui.get(target.is_enemy and tracers_color_enemy or tracers_color)

                if ui.get(tracers_hit) and not target.is_enemy and target.did_hit then
                    r, g, b, a = ui.get(tracers_color_hit) 
                end

                create_beams({ last_impact.x, last_impact.y, last_impact.z }, (target.eye_pos ~= nil and target.eye_pos or data.origin[1]), r, g, b, a)
            end
        end
    end
end

client.set_event_callback("predict_command", command)
client.set_event_callback("bullet_impact", bullet_handler)
client.set_event_callback("player_hurt", hurt_handler)
client.set_event_callback("paint", paint_handler)
client.set_event_callback("round_start", reset)
