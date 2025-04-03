local input1 = menu.add_text_input("calculator", "First number")
local input2 = menu.add_text_input("calculator", "Operator")
local inputnegative = menu.add_text_input("calculator", "Operator negative")
local input3 = menu.add_text_input("calculator", "Second number")
local text = menu.add_text("calculator", 'Result will appear here')

local function handle_vis()
    return input2:get() == 'negative first' or input2:get() == 'negative second' or input2:get() == 'negative both' and true or false
end

local function callback_fn()
    local result
    if not tonumber(input1:get()) or not tonumber(input3:get()) then text:set('ERROR : FIRST OR SECOND WAS NOT NUMBER') return end
    if input2:get() == "plus" then
        result = tonumber(input1:get() + input3:get())
    elseif input2:get() == "minus" or input2:get() == "subtract" then
        result = tonumber(input1:get() - input3:get())
    elseif input2:get() == "divide" then
        result = tonumber(input1:get() / input3:get())
    elseif input2:get() == "multiply" then
        result = tonumber(input1:get() * input3:get())
    elseif input2:get() == "negative first" then
        if inputnegative:get() == "plus" then
            result = tonumber(-input1:get()) + tonumber(input3:get())
        elseif inputnegative:get() == "minus" or inputnegative:get() == "subtract" then
            result = tonumber(-input1:get()) - tonumber(input3:get())
        elseif inputnegative:get() == "divide" then
            result = tonumber(-input1:get()) / tonumber(input3:get())
        elseif inputnegative:get() == "multiply" then
            result = tonumber(-input1:get()) * tonumber(input3:get())
        end
    elseif input2:get() == "negative second" then
        if inputnegative:get() == "plus" then
            result = tonumber(input1:get()) + tonumber(-input3:get())
        elseif inputnegative:get() == "minus" or inputnegative:get() == "subtract" then
            result = tonumber(input1:get()) - tonumber(-input3:get())
        elseif inputnegative:get() == "divide" then
            result = tonumber(input1:get()) / tonumber(-input3:get())
        elseif inputnegative:get() == "multiply" then
            result = tonumber(input1:get()) * tonumber(-input3:get())
        else
            text:set('ERROR : WRONG OPERATOR')
            return
        end
    elseif input2:get() == "negative both" then
        if inputnegative:get() == "plus" then
            result = tonumber(-input1:get()) + tonumber(-input3:get())
        elseif inputnegative:get() == "minus" or inputnegative:get() == "subtract" then
            result = tonumber(-input1:get()) - tonumber(-input3:get())
        elseif inputnegative:get() == "divide" then
            result = tonumber(-input1:get()) / tonumber(-input3:get())
        elseif inputnegative:get() == "multiply" then
            result = tonumber(-input1:get()) * tonumber(-input3:get())
        else
            text:set('ERROR : WRONG OPERATOR')
        return
        end
    else
        text:set('ERROR : WRONG OPERATOR')
        return
    end
    text:set("Result : " .. tostring(result))
    print("Result : " .. tostring(result))
    if result == tonumber('inf') or result == tonumber('-inf') then text:set('are you serious righ neow brah ?') return end
    -- NO WORKY >:(((   if result == tonumber('-nan') or result == tonumber('nan') then text:set('are you serious righ neow brah ?') return end
end

local button = menu.add_button("calculator", "Calculate", callback_fn)

local function eeeee()  
    inputnegative:set_visible(handle_vis())
end

callbacks.add(e_callbacks.PAINT, eeeee)