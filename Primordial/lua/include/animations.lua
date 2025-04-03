-- sertion.gg
local library = {}
library.__index = library

library.list = {}
library.new = function(name, start_value)
    if not library.list[name] then
        library.list[name] = start_value or 0 --- @note: by that you can create your animation variable in render function.
    end

    return setmetatable({name = name}, library)
end

--- @region: prepare animation functions
library.types = {
    LERP = 1,
    SINE3 = 2,

    IN_SINE = 3,
    OUT_SINE = 4,
    IN_OUT_SINE = 5,

    IN_CUBIC = 6,
    OUT_CUBIC = 7,
    IN_OUT_CUBIC = 8,

    IN_QUINT = 9,
    OUT_QUINT = 10,
    IN_OUT_QUINT = 11,
    
    IN_CIRC = 12,
    OUT_CIRC = 13,
    IN_OUT_CIRC = 14
}


function math.clamp(x, min, max)
    if x < min then return min end
    if x > max then return max end
    return x
end


library.animations = {
    --- @note: default
    [library.types.LERP] = function(start_value, final_value, time, minimum_delta)
        time = time or 0.095
        minimum_delta = minimum_delta or 1

        if math.abs(start_value - final_value) < minimum_delta then
            return final_value
        end
    
        time = math.clamp(global_vars.frame_time() * time * 175, 0.01, 1)
        return (final_value - start_value) * time + start_value
    end,

    [library.types.SINE3] = function(start_value, final_value, time, minimum_delta)
        time = time or 0.065
        minimum_delta = minimum_delta or 2

        if math.abs(start_value - final_value) < minimum_delta then
            return final_value
        end

        local delta = final_value - start_value
        return delta > 0 and (start_value + (math.sin(delta) ^ 3 + delta) * time) or (start_value - (math.sin(delta) ^ 3 - delta) * time)
    end,

    --- @note: from easings.net
    [library.types.IN_SINE] = function(start_value, final_value, time, minimum_delta)
        time = time or 0.2
        minimum_delta = minimum_delta or 1

        if math.abs(start_value - final_value) < minimum_delta then
            return final_value
        end

        time = math.clamp(global_vars.frame_time() * time * 175, 0.01, 1)
        return -(final_value - start_value) * math.cos(time * (math.pi / 2)) + (final_value - start_value) + start_value
    end,

    [library.types.OUT_SINE] = function(start_value, final_value, time, minimum_delta)
        time = time or 0.065
        minimum_delta = minimum_delta or 1

        if math.abs(start_value - final_value) < minimum_delta then
            return final_value
        end

        time = math.clamp(global_vars.frame_time() * time * 175, 0.01, 1)
        return (final_value - start_value) * math.sin(time * (math.pi / 2)) + start_value
    end,

    [library.types.IN_OUT_SINE] = function(start_value, final_value, time, minimum_delta)
        time = time or 0.095
        minimum_delta = minimum_delta or 0.1

        if math.abs(start_value - final_value) < minimum_delta then
            return final_value
        end

        time = math.clamp(global_vars.frame_time() * time * 175, 0.01, 1)
        return -(final_value - start_value) / 2 * (math.cos(math.pi * time) - 1) + start_value
    end,

    [library.types.IN_CUBIC] = function(start_value, final_value, time, minimum_delta)
        time = time or 0.5
        minimum_delta = minimum_delta or 0.1

        if math.abs(start_value - final_value) < minimum_delta then
            return final_value
        end

        time = math.clamp(global_vars.frame_time() * time * 175, 0.01, 1)
        return (final_value - start_value) * (time ^ 3) + start_value
    end,

    [library.types.OUT_CUBIC] = function(start_value, final_value, time, minimum_delta)
        time = time or 0.1
        minimum_delta = minimum_delta or 0.1

        if math.abs(start_value - final_value) < minimum_delta then
            return final_value
        end

        time = math.clamp(global_vars.frame_time() * time * 175, 0.01, 1)
        return (final_value - start_value) * ((time - 1) ^ 3 + 1) + start_value
    end,

    [library.types.IN_OUT_CUBIC] = function(start_value, final_value, time, minimum_delta)
        time = time or 0.3
        minimum_delta = minimum_delta or 0.1

        if math.abs(start_value - final_value) < minimum_delta then
            return final_value
        end

        time = math.clamp(global_vars.frame_time() * time * 175, 0.01, 1)
        time = time * 2

        if time < 1 then
            return (final_value - start_value) / 2 * (time ^ 3) + start_value
        else
            return (final_value - start_value) / 2 * ((time - 2) ^ 3 + 2) + start_value
        end
    end,

    [library.types.IN_QUINT] = function(start_value, final_value, time, minimum_delta)
        time = time or 0.75
        minimum_delta = minimum_delta or 1

        if math.abs(start_value - final_value) < minimum_delta then
            return final_value
        end

        time = math.clamp(global_vars.frame_time() * time * 175, 0.01, 1)
        return (final_value - start_value) * (time ^ 5) + start_value
    end,

    [library.types.OUT_QUINT] = function(start_value, final_value, time, minimum_delta)
        time = time or 0.01
        minimum_delta = minimum_delta or 1

        if math.abs(start_value - final_value) < minimum_delta then
            return final_value
        end

        time = math.clamp(global_vars.frame_time() * time * 175, 0.01, 1)
        return (final_value - start_value) * ((time - 1) ^ 5 + 1) + start_value
    end,

    [library.types.IN_OUT_QUINT] = function(start_value, final_value, time, minimum_delta)
        time = time or 0.35
        minimum_delta = minimum_delta or 0.5

        if math.abs(start_value - final_value) < minimum_delta then
            return final_value
        end

        time = math.clamp(global_vars.frame_time() * time * 175, 0.01, 1)
        time = time * 2

        if time < 1 then
            return (final_value - start_value) / 2 * (time ^ 5) + start_value
        else
            return (final_value - start_value) / 2 * ((time - 2) ^ 5 + 2) + start_value
        end
    end,

    [library.types.IN_CIRC] = function(start_value, final_value, time, minimum_delta)
        time = time or 0.5
        minimum_delta = minimum_delta or 1

        if math.abs(start_value - final_value) < minimum_delta then
            return final_value
        end

        time = math.clamp(global_vars.frame_time() * time * 175, 0.01, 1)
        return -(final_value - start_value) * (math.sqrt(1 - time ^ 2) - 1) + start_value
    end,

    [library.types.OUT_CIRC] = function(start_value, final_value, time, minimum_delta)
        time = time or 0.7
        minimum_delta = minimum_delta or 1

        if math.abs(start_value - final_value) < minimum_delta then
            return final_value
        end

        time = math.clamp(global_vars.frame_time() * time * 175, 0.01, 1)
        return (final_value - start_value) * (1 - math.sqrt(1 - time ^ 2)) + start_value
    end,

    [library.types.IN_OUT_CIRC] = function(start_value, final_value, time, minimum_delta)
        time = time or 0.3
        minimum_delta = minimum_delta or 1.2

        if math.abs(start_value - final_value) < minimum_delta then
            return final_value
        end

        time = math.clamp(global_vars.frame_time() * time * 175, 0.01, 1)
        time = time * 2

        if time < 1 then
            return -(final_value - start_value) / 2 * (math.sqrt(1 - time ^ 2) - 1) + start_value
        else
            return (final_value - start_value) / 2 * (math.sqrt(1 - (time - 2) ^ 2) + 1) + start_value
        end
    end
}
--- @endregion

function library:update(type, final_value, time, minimum_delta)
    self.list[self.name] = library.animations[type](self.list[self.name], final_value, time, minimum_delta)
    return math.floor(self.list[self.name])
end

function library:get()
    return self.list[self.name]
end
--- @endregion

return library