-- desync side spam
local fake_spam = menu.add_checkbox("spammer", "random desync side spammer")
fake_spam:set_visible(true)


local function on_antiaim(ctx)

    random = math.random(0, 1)
        
        if fake_spam:get() then

            if random == 0 then

            ctx:set_desync(1.0)

            elseif random == 1 then
            
            ctx:set_desync(-1.0)

        end
    end
end

callbacks.add(e_callbacks.ANTIAIM, on_antiaim)