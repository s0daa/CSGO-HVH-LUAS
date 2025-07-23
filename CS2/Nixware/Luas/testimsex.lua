-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

-- я не писал на луа больше года, может быть говнокод

local CoordX = 100 -- координаты по x
local CoordY = 300 -- координаты по y
-- цвет менять тут, т.е r - 136, g - 125, b - 230
local ColorOutline = color_t(136 / 255, 125 / 255, 230 / 255, 255)


local ffi = require("ffi")

ffi.cdef[[
    unsigned short GetKeyState(int nVirtKey);
]]

local Input = {}
Input.GetCursorPos = function()
    local pointer = ffi.new("POINT[1]")
    ffi.C.GetCursorPos(pointer)
    return pointer[0]
end
-- спижено из либы https://forum.uokit.com/index.php?showtopic=68111
Input.IsKey = function(virtualKey)
	local state = ffi.C.GetKeyState(virtualKey)
	return bit.band(state, 0x8000) ~= 0, bit.band(state, 1) ~= 0
end
Input.GetKeyState = function(virtualKey)
    local hold, toggle = Input.IsKey(virtualKey)
    return hold, toggle
end


-- коды клавиш можно взять отсюда https://snipp.ru/handbk/vk-code
-- я юзаю hex, но можете юзать dec
local yaemgovno = {
    {name = "Thirdperson",     key = 0x06, type = "toggle"},
    {name = "Auto Peek",       key = 0xA4, type = "hold"},
    {name = "Remove Spread",   key = 0x04, type = "toggle"},
    {name = "Damage Override", key = 0x05, type = "hold"},
    -- также можно свои бинды добавить
}

local Verdana = render.setup_font("C:/Windows/Fonts/verdana.ttf", 12, 400)

register_callback("paint", function()
    local x, y = CoordX, CoordY
    local Add = 0
    local RenderOther = false

    for _, bind in ipairs(yaemgovno) do
        local hold, toggle = Input.GetKeyState(bind.key)
        if bind["type"] == "hold" then
            if hold then
                RenderOther = true
                render.text(bind["name"], Verdana, vec2_t(x + 3, y + 24 + Add), color_t(255, 255, 255, 255))
                render.text("[on]", Verdana, vec2_t(x + 154, y + 24 + Add), color_t(255, 255, 255, 255)) 
                -- print(bind.name .. "held")
                Add = Add + 15
            end
        elseif bind["type"] == "toggle" then
            if toggle then
                RenderOther = true
                render.text(bind["name"], Verdana, vec2_t(x + 3, y + 24 + Add), color_t(255, 255, 255, 255)) 
                render.text("[on]", Verdana, vec2_t(x + 154, y + 24 + Add), color_t(255, 255, 255, 255)) 
                Add = Add + 15
                -- print(bind.name .. " toggled")
            end
        end
    end

    if RenderOther == true then
        -- render.rect_filled(vec2_t(x, y), vec2_t(x + 180, y + 20), color_t(0, 0, 0, 255), 5)
        render.rect_filled(vec2_t(x - 1, y - 1), vec2_t(x + 181, y + 18), color_t(136 / 255, 125 / 255, 230 / 255, 255), 5)
        render.rect_filled(vec2_t(x, y), vec2_t(x + 180, y + 20), color_t(0, 0, 0, 255), 5)
        render.text("keybinds", Verdana, vec2_t(x + 68, y + 3), color_t(255, 255, 255, 255))
    end
end)

