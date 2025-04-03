-- add those GOD DAMN ELEMENTS
local yaw_offset = menu.add_slider("better jitter", "yaw offset", -180, 180)
local jitter_offset = menu.add_slider("better jitter", "jitter offset", -180, 180)

-- autistic GLOBAL VARIABLES
local invert = false

local function on_finish_command(cmd)
    -- get the GOD DAMN YAW
    yaw = cmd.viewangles.y
end

local function on_antiaim(ctx)
    local choked = engine.get_choked_commands()
    -- wtf primordial
    if choked == 0 then
        return
    end
    
    -- get those GOD DAMN OFFSETS
    local side = invert and -1 or 1
    local jitter = jitter_offset:get() / 2 * side

    -- set that GOD DAMN YAW
    ctx:set_yaw(yaw + yaw_offset:get() + jitter)

    -- invert that GOD DAMN JITTER OFFSET
    invert = not invert
end

-- add those GOD DAMN CALLBACKS
callbacks.add(e_callbacks.FINISH_COMMAND, on_finish_command)
callbacks.add(e_callbacks.ANTIAIM, on_antiaim)