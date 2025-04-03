local config = {} config.__index = {}

config.setting_table = {}
config.menu_func = {
    add_checkbox = menu.add_checkbox,
    add_selection = menu.add_selection,
    add_slider = menu.add_slider,
    add_list = menu.add_list,
    add_multi_selection = menu.add_multi_selection,
}

config.seperator = "|"

config.control_function = function(control, group, name, multi_select)
    table.insert(config.setting_table, { control = control, group = group, name = name, special = multi_select })

    return control
end

function menu.add_checkbox(group, name, ...)
    local control = config.menu_func.add_checkbox(group, name, ...)
    return config.control_function(control, group, name, false)
end

function menu.add_selection(group, name, ...)
    local control = config.menu_func.add_selection(group, name, ...)
    return config.control_function(control, group, name, false)
end

function menu.add_slider(group, name, ...)
    local control = config.menu_func.add_slider(group, name, ...)
    return config.control_function(control, group, name, false)
end

function menu.add_list(group, name, ...)
    local control = config.menu_func.add_list(group, name, ...)
    return config.control_function(control, group, name, false)
end

function menu.add_multi_selection(group, name, ...)
    local control = config.menu_func.add_multi_selection(group, name, ...)
    return config.control_function(control, group, name, true)
end

string.find_all = function(text, word)
    local i, tbl = 0, {}

    while true do
        i = string.find(text, word, i + 1)
        if (i) then table.insert(tbl, i) else break end
    end

    return tbl
end

string.split_on_str = function(text, str)
    local str_table, split_table = string.find_all(text, str), {}

    if (str_table and #str_table > 0) then
        for i = 1, #str_table + 1 do
            if (i == 1) then table.insert(split_table, string.sub(text, 1, str_table[i] - 1))
            elseif (i == #str_table + 1) then table.insert(split_table, string.sub(text, str_table[i - 1] + 1, #text))
            else table.insert(split_table, string.sub(text, str_table[i - 1] + 1, str_table[i] - 1)) end
        end
    end

    return split_table
end

config.import_settings = function(text)
    local line_table = string.split_on_str(text, "\n")

    for i = 1, #line_table do
        local arg_table = string.split_on_str(line_table[i], config.seperator)

        local group, name, value_type, multi_select, value = arg_table[1], arg_table[2], arg_table[3], arg_table[4] == "true", nil

        if (value_type == "number") then
            value = tonumber(arg_table[5])
        elseif (value_type == "boolean") then
            if (string.find(arg_table[5], "true")) then
                value = true
            else
                value = false
            end
        end

        for f = 1, #config.setting_table do
            if (config.setting_table[f].group == group and config.setting_table[f].name == name) then
                if (not multi_select) then
                    config.setting_table[f].control:set(value)
                else
                    for j = 5, #arg_table do
                        if (j % 2 ~= 0) then
                            config.setting_table[f].control:set(tonumber(arg_table[j]), arg_table[j + 1] == "true")
                        end
                    end
                end
            end
        end
    end
end

config.export_settings = function()
    local export_text = ""

    for i = 1, #config.setting_table do
        if (not config.setting_table[i].special) then
            export_text = export_text .. ((export_text == "") and "" or "\n") .. (config.setting_table[i].group .. config.seperator .. config.setting_table[i].name .. config.seperator .. type(config.setting_table[i].control:get()) .. config.seperator .. tostring(config.setting_table[i].special) .. config.seperator .. tostring(config.setting_table[i].control:get()))
        else
            export_text = export_text .. ((export_text == "") and "" or "\n") .. (config.setting_table[i].group .. config.seperator .. config.setting_table[i].name .. config.seperator .. "table" .. config.seperator .. tostring(config.setting_table[i].special))

            local items = config.setting_table[i].control:get_items()

            for f = 1, #items do
                export_text = export_text .. config.seperator .. f .. config.seperator .. tostring(config.setting_table[i].control:get(f))
            end
        end
    end

    return export_text
end