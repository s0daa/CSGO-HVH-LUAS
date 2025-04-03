local third_p_dis = 0
local ref = {
        trd_p_key = menu.find("visuals", "other", "thirdperson", "enable"),
        trd_p = menu.find("visuals", "other", "thirdperson", "distance"),
}

local cus_trd_p = menu.add_slider("thirdperson", "thirdperson distance", 0, 200, 1.0, 0, "u")
local trd_p_out = menu.add_slider("thirdperson", "thirdperson fade time", 0, 100, 1.0, 0, "u")
cus_trd_p:set(40)
trd_p_out:set(10)

local function trd_person() 
        local fade_time = (10/(trd_p_out:get()*0.1))*global_vars.frame_time()

        if ref.trd_p_key[2]:get() then
            if third_p_dis < 1.0 then
                third_p_dis = (third_p_dis + (fade_time * (1 - third_p_dis)))
            end
        else
                third_p_dis = 0
        end

        if third_p_dis >= 1.0 then third_p_dis = 1 end

        ref.trd_p:set(cus_trd_p:get()*third_p_dis)
end

callbacks.add(e_callbacks.PAINT, trd_person)