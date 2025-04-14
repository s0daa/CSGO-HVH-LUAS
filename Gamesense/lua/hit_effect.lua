local ffi = require("ffi")

ffi.cdef[[
    typedef struct {
        float x,y,z;
    } vec3_t_aojnsfdghuinfasiugnhiusfnghsfghsfgh;

    struct tesla_info_t_ioajdngfhijafgidjnhuangfdhargh {
        vec3_t_aojnsfdghuinfasiugnhiusfnghsfghsfgh  m_pos;
        vec3_t_aojnsfdghuinfasiugnhiusfnghsfghsfgh  m_ang;
        int m_entindex;
        const char *m_spritename;
        float m_flbeamwidth;
        int m_nbeams;
        vec3_t_aojnsfdghuinfasiugnhiusfnghsfghsfgh m_color;
        float m_fltimevis;
        float m_flradius;
    };

    typedef void(__thiscall* FX_TeslaFn_iosjfdnghjusfgiuhisfgihsfgjshfgshfj)(struct tesla_info_t_ioajdngfhijafgidjnhuangfdhargh&);
]]

local match = client.find_signature("client_panorama.dll", "\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x56\x57\x8B\xF9\x8B\x47\x18")
local fs_tesla = ffi.cast("FX_TeslaFn_iosjfdnghjusfgiuhisfgihsfgjshfgshfj", match)

local hitbox_pos = entity.hitbox_position
local uidtoentindex = client.userid_to_entindex
local get_local_player = entity.get_local_player


local tesla = ui.new_checkbox("visuals", "effects", "Tesla on hit")
local color = ui.new_color_picker("visuals", "effects", "color", 255,255,255,255)
local beam_width = ui.new_slider("visuals", "effects", "Tesla width", 0, 30, 10)
local beam_radius = ui.new_slider("visuals", "effects", "Tesla radius", 0, 1000, 500)
local beams = ui.new_slider("visuals", "effects", "Beams", 0, 100, 12)

client.set_event_callback("player_hurt", function(event)
    if ui.get(tesla) then 
        local me = get_local_player()
        local attacker = uidtoentindex(event.attacker)
        if attacker == me then 
            local hurt = uidtoentindex(event.userid)
            local r,g,b,a = ui.get(color)
            local x = client.random_float(-1000, 1000)
            local y = client.random_float(-x, x)
            local z = client.random_float(-y, y)

            local tesla_info = ffi.new("struct tesla_info_t_ioajdngfhijafgidjnhuangfdhargh")
            tesla_info.m_flbeamwidth = ui.get(beam_width)
            tesla_info.m_flradius = ui.get(beam_radius)
            tesla_info.m_entindex = attacker
            tesla_info.m_color = {r/255, g/255, b/255}
            tesla_info.m_pos = { hitbox_pos(hurt, 6) }
            tesla_info.m_ang = {x,y,z}
            tesla_info.m_fltimevis = 0.75
            tesla_info.m_nbeams = ui.get(beams)
            tesla_info.m_spritename = "sprites/physbeam.vmt"
            fs_tesla(tesla_info)
        end
    end
end) 