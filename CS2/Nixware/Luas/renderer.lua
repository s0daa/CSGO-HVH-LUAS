-- ported by: Minarut // original author: difj
do
    local script_path = debug.getinfo(1, "S").source:sub(2)
    local script_dir = script_path:match("(.*[/\\])")
    package.path = package.path .. ";" .. script_dir .. "?.lua"
end

local input = require("input")

local function DrawRect(x, y, w, h, color, filled)
    local from = vec2_t(x, y)
    local to = vec2_t(x + w, y + h)
    if filled then
        render.rect_filled(from, to, color)
    else
        render.rect(from, to, color)
    end
end

local function MouseInRect(x, y, w, h)
    local mouse = input.get_mouse_pos()
    return mouse.x >= x and mouse.x <= x + w and mouse.y >= y and mouse.y <= y + h
end

return {
    DrawRect = DrawRect,
    MouseInRect = MouseInRect,
}