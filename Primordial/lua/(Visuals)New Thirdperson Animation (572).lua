local thirdperson = menu.find("visuals", "view", "thirdperson", "enable")
local dist = menu.find("visuals", "view", "thirdperson", "distance")

--@ menu elements
local end_distance = menu.add_slider("Animation", "Thirdperson Distance", 15, 250) end_distance:set(dist:get())
local anim_speed = menu.add_slider("Animation", "Speed", 10, 200) anim_speed:set(30)
--@ end region

--@ anim region
function lerp(a, b, t) return a + (b - a) * t end
function get_speed()
    fps = client.get_fps()
    global_speed = anim_speed:get()/100
    return global_speed * 1 / (fps / 20)
end
--@ end region

--@ render region
local start_val = 0
local animation = true
local anim_distance = start_val
function Main()
    local lp = entity_list.get_local_player()
    if lp ~= nil and lp:get_prop("m_iHealth") == 0 then
        dist:set(end_distance:get())
    else
        if thirdperson[2]:get() then
            if animation then
                anim_distance = lerp(anim_distance, end_distance:get()+1, get_speed())
                dist:set(math.floor(anim_distance))
                if dist:get() > end_distance:get() then
                    dist:set(end_distance:get())
                    animation = false
                    anim_distance = start_val
                end
            else 
                dist:set(end_distance:get())
            end
        else
            dist:set(start_val)
            anim_distance = start_val
            animation = true
        end
    end
end
--@ end region

callbacks.add(e_callbacks.PAINT, Main)