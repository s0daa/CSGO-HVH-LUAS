local callback = {}

function menu.add_callback(control, fn)
    for i = 1, #callback do
        if (callback[i].control == control) then
            callback[i].fn = fn
            return
        end
    end

    local value, type = 0, 0
    local status = pcall(function() value = control:get() end)
    if (not status) then 
        type = 1 status = pcall(function() value = control:get_items() end)
    end
    if (not status) then type = 2 end

    if (type == 1) then
        local val = { items = control:get_items(), table = {} }

        for i = 1, #val.items do
            table.insert(val.table, control:get(i))
        end

        value = val.table
    end

    table.insert(callback, { control = control, fn = fn, value = value, type = type })
end

callbacks.add(e_callbacks.PAINT, function()
    for i = 1, #callback do
        if (callback[i].type ~= 1 and callback[i].type ~= 2 and callback[i].control:get() ~= callback[i].value) then
            callback[i].value = callback[i].control:get()
            callback[i].fn()
        elseif (callback[i].type == 1) then
            local val = { items = callback[i].control:get_items(), table = {} }

            for f = 1, #val.items do
                table.insert(val.table, callback[i].control:get(f))
            end

            for f = 1, #val.table do
                if (val.table[f] ~= callback[i].value[f]) then
                    callback[i].value = val.table
                    callback[i].fn()
                end
            end
        end
    end
end)