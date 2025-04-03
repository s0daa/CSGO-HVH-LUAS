local alphabet_string = ' !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~'

local int_to_alphabet_table, alphabet_to_int_table = {}, {}

for i = 1, #alphabet_string do
    int_to_alphabet_table[i] = alphabet_string:sub(i, i)
    alphabet_to_int_table[alphabet_string:sub(i, i)] = i
end

local paint_callbacks = {}

callbacks.add(e_callbacks.PAINT, function()
    for _, v in ipairs(paint_callbacks) do
        v()
    end
end)

local saved_textbox = {}

saved_textbox.new = function(group, name, max_length, use_button, button_name)
    
    if max_length == nil then max_length = 64 end
    if use_button == nil then use_button = false end
    local _name = button_name == nil and "Save!" or button_name
    
    local slider_table = {}
    for i = 1, max_length do
        slider_table[i] = menu.add_slider(group, "saved_textbox_slider_" .. name .. "_" .. i, -1, #alphabet_string)
        slider_table[i]:set_visible(false)
    end
    local the_saved_value = ""
    local real_value = ""

    local function update_value()
        the_saved_value = ""
        for i = 1, max_length do
            local index_int = slider_table[i]:get()
            if index_int == -1 then
                break
            end
            if int_to_alphabet_table[index_int] ~= nil then
                the_saved_value = the_saved_value .. int_to_alphabet_table[index_int]
            end
        end
        if the_saved_value == "~" then the_saved_value = "" end
    end

    local inited_yet = false
    local textbox = menu.add_text_input(group, name)
    
    local function save_value(value_to_save)
        if value_to_save == nil then
            value_to_save = textbox:get()
        end
        if value_to_save:len() > max_length then
            value_to_save = value_to_save:sub(1, max_length)
        end
        for i = 1, max_length do
            slider_table[i]:set(0)
        end
        for i = 1, #value_to_save do
            slider_table[i]:set(alphabet_to_int_table[value_to_save:sub(i, i)])
        end
    end
    
    table.insert(paint_callbacks, function()
        if not inited_yet then
            inited_yet = true
            update_value()
            real_value = textbox:get()
            return
        end
        if not use_button then
            -- not the first tick, user has typed something in.
            local _text = textbox:get()
            if real_value ~= _text then
                save_value(_text)
                update_value()
                real_value = _text
            end
        end
    end)
    local button = nil
    if use_button then
        button = menu.add_button(group, _name, function()
            save_value()
            update_value()
        end)
    end
    
    local to_return = {
        raw_textbox = textbox,
        get = function()
            return the_saved_value
        end,
        set = function(y, x)
            if x ~= nil then
                save_value(x)
            else
                save_value(y)
            end
            update_value()
        end
    }
    
    if use_button then
        to_return["raw_button"] = button
        to_return["set_visible"] = function(y, x)
            if x ~= nil then
                textbox:set_visible(x)
                button:set_visible(x)
            else
                textbox:set_visible(y)
                button:set_visible(y)
            end
        end
    else
        to_return["set_visible"] = function(y, x)
            if x ~= nil then
                textbox:set_visible(x)
            else
                textbox:set_visible(y)
            end
        end
    end
    
    return to_return
end

return saved_textbox