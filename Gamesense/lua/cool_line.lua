local _ui = require('gamesense/uilib')

--#region function cache
local render_rect, render_gradient =
    renderer.rectangle, renderer.gradient

local screen_size, set_event_callback, unset_event_callback =
    client.screen_size, client.set_event_callback, client.unset_event_callback

local realtime = globals.realtime

local floor, max, min = math.floor, math.max, math.min
--#endregion

--#region vars
local w, h = screen_size()
--#endregion

--#region ui
local ui_white = '\adcdcdcff'
local ui_space = '\a808080c8»'..ui_white
local ref = {
    enabled = _ui.new_checkbox('visuals', 'effects', 'Epic overlay line B)'),
    clr = _ui.new_color_picker('visuals', 'effects', 'line_clr', 165, 220, 15, 220),
    type = _ui.new_combobox('visuals', 'effects', 'Epic line '..ui_space..' Type', { 'Static', 'Gradient', 'Rainbow' }),
    thicc = _ui.new_slider('visuals', 'effects', 'Epic line '..ui_space..' Thiccness', 1, 15, 1, true, 'px'),
    speed = _ui.new_slider('visuals', 'effects', 'Epic line '..ui_space..' Speed', 1, 100, 15, true, '%')
}
--#endregion

--#region functions
local hsva_to_rgba = function(h, s, v, a)
    local i = floor(h*6)
    local f = h*6-i
    local p, q, t = v*(1-s), v*(1-f*s), v*(1-(1-f)*s)

    local selection = { { v, t, p }, { q, v, p }, { p, v, t }, { p, q, v }, { t, p, v }, { v, p, q } }

    i=i%6

    local r, g, b = unpack(selection[i+1])
    return r*255, g*255, b*255, a*255
end

local rgba_to_hsva = function(r, g, b, a)
    r, g, b, a = r/255, g/255, b/255, a/255
    local mx, mn = max(r, g, b), min(r, g, b)
    local h, s, v = 0, 0, mx

    local d = mx-mn
    s = mx == 0 and 0 or d/mx

    if mx == mn then
        h = 0
    else
        if mx == r then h=(g-b)/d if g<b then h=h+6 end
        elseif mx==g then h=(b-r)/d+2
        elseif mx==b then h=(r-g)/d+4
        end
        h=h/6
    end
    return h, s, v, a
end

local function rainbowize(f, s, v, a)
    return hsva_to_rgba(realtime()*f, s, v, a)
end
--#endregion

--#region callbacks
local callbacks = {}

callbacks.paint = function()
    local r, g, b, a = ref.clr()
    local _, s, v, a2 = rgba_to_hsva(r, g, b, a)
    local r2, g2, b2 = rainbowize(ref.speed()*.01, s, v, a2)
    local type, thicc = ref.type(), ref.thicc()

    if type == 'Static' then
        render_rect(0, 0, w, thicc, r, g, b, a)
    elseif type == 'Gradient' then
        render_gradient(0, 0, w/2, thicc, 5, 221, 255, a, 186, 12, 230, a, true)
        render_gradient(w/2, 0, w/2, thicc, 186, 12, 230, a, 219, 226, 60, a, true)
    elseif type == 'Rainbow' then
        render_gradient(0, 0, w/2, thicc, g2, b2, r2, a, r2, g2, b2, a, true)
        render_gradient(w/2, 0, w/2, thicc, r2, g2, b2, a, b2, r2, g2, a, true)
    end
end
--#endregion

--#region ui setup
local function visibility()
    local check = ref.enabled()
    for i, n in pairs(ref) do
        if i == 'enabled' or i == 'clr' or i == 'speed' then goto skip end n.visible = check::skip::
    end
    ref.speed['visible'] = check and (ref.type() == 'Overflow' or ref.type() == 'Rainbow')
end

ref.enabled:add_callback(visibility)
ref.type:add_callback(visibility)

ref.enabled:add_event_callback('paint_ui', callbacks.paint)

ref.enabled:invoke()
--#endregion
