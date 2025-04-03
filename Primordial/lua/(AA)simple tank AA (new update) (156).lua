-- credits: 
-- @Logan  jit func
-- @anymore main code        

local lyaw_offset = menu.add_slider("better jitter", "lyaw offset", -180, 180)    
local ryaw_offset = menu.add_slider("better jitter", "ryaw offset", -180, 180)         
local jitter_offset = menu.add_slider("better jitter", "jitter offset", -180, 180)
local disabler = menu.add_multi_selection("on disable","tank disabler",{"on peek","on manual sideways","on manual backward","on hideshots", "on Freestanding"})
local yaw_add = menu.find("antiaim", "main", "angles", "yaw add")
local key_name, key_bind = unpack(menu.find("antiaim","main","manual","invert desync"))
local ref_hide_shot, ref_onshot_key = unpack(menu.find("aimbot", "general", "exploits", "hideshots", "enable"))
local ref_auto_peek, ref_peek_key = unpack(menu.find("aimbot","general","misc","autopeek"))
local ref_freestand, ref_frees_key = unpack(menu.find("antiaim","main","auto direction","enable"))

local invert = false
local yaw = 0

local function disable_check()
    if disabler:get(1) then 
        if ref_peek_key:get() == true then 
            return true
        end
    end
    if disabler:get(2) then
        if antiaim.get_manual_override() == 1 or antiaim.get_manual_override() == 3 then 
            return true
        end
    end
    if disabler:get(3) then 
        if antiaim.get_manual_override() == 2 then 
            return true
        end
    end
    if disabler:get(4) then
        if ref_onshot_key:get() then 
            return true
        end
    end
    if disabler:get(5) then
        if ref_frees_key:get() then
            return true
        end
    end

    return false
end

local function on_setup_command()
    yaw_add:set(key_bind:get() and ryaw_offset:get() or lyaw_offset:get())
    --  The envisioned yaw add method
    --  but it does not work when static...
end

local function on_finish_command(cmd)
    yaw = cmd.viewangles.y
end

local function on_antiaim(ctx)
    local choked = engine.get_choked_commands()
    local offset = jitter_offset:get()
    local side = key_bind:get() and (invert and -1 or 1) or (invert and 1 or -1)
    local jitter = offset/2 * side

    if choked == 0 then
        yaw = engine.get_view_angles().y
        return
    end
    if disable_check() then     --  todo , static yaw add will got bug when lag comp break
        ctx:set_yaw(yaw)        --  i havent found a good solution
        ctx:set_invert_desync(not key_bind:get())
        ctx:set_desync(key_bind:get() and -60 or 60)
    else
        ctx:set_yaw(yaw + jitter)
        ctx:set_invert_desync((key_bind:get() and invert or invert))
        ctx:set_desync(jitter > 1 and -60 and jitter < -1 and 60 or 0)
        invert = not invert
    end
end

callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)
callbacks.add(e_callbacks.FINISH_COMMAND, on_finish_command)
callbacks.add(e_callbacks.ANTIAIM, on_antiaim)