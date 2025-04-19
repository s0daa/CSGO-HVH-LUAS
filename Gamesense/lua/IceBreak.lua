-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
local k = require('clipboard') -- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
local j = { anim_list = {} }-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
j.math_clamp = function(k, j, s) return math.min(s, math.max(j, k)) end-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
j.math_lerp = function(k, s, c)-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
    local N = j.math_clamp(.02, 0, 1)-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
 -- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
    if type(k) == 'userdata' then-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
        r, g, b, k = k.r, k.g, k.b, k.a-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
        e_r, e_g, e_b, e_a = s.r, s.g, s.b, s.a-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
        r = j.math_lerp(r, e_r, N)-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
        g = j.math_lerp(g, e_g, N)-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
        b = j.math_lerp(b, e_b, N)-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
        k = j.math_lerp(k, e_a, N)-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
        return color(r, g, b, k)-- бля я хочу пиццы и aegis ставь + если у тебя есть aegis пон
    end
    local m = s - k
    m = m * N
    m = m + k
    if s == 0 and (m < .01 and m > -0.01) then
        -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        m = 0
        -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    elseif s == 1 and (m < 1.01 and m > .99) then
        -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        m = 1
        -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    end
    -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    return m
    -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
end
-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
j.vector_lerp = function(k, j, s) return k + (j - k) * s end
-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
j.anim_new = function(k, s, c, N)
    -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    if not j.anim_list[k] then
        -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        j.anim_list[k] = {}
        -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        j.anim_list[k].color = render.color(0, 0, 0, 0)
        -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        j.anim_list[k].number = 0
        -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        j.anim_list[k].call_frame = true
        -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    end
    -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    if c == nil then j.anim_list[k].call_frame = true end
    -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    if N == nil then N = .1 end
    -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    if type(s) == 'userdata' then
        -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        lerp = j.math_lerp(j.anim_list[k].color, s, N)
        -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        j.anim_list[k].color = lerp
        -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        return lerp
        -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    end
    -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    lerp = j.math_lerp(j.anim_list[k].number, s, N)
    -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    j.anim_list[k].number = lerp
    -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    return lerp
    -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
end
-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local function c(k)
    -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    return (k:gsub('.', function(k)
        -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        local j, s = '', k:byte()
        -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        for k = 8, 1, -1 do j = j .. (s % 2 ^ k - s % 2 ^ (k - 1) > 0 and '1' or '0') end
        return j
    end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(k)
        if #k < 6 then return '' end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        local j = 0
        for s = 1, 6, 1 do j = j + (k:sub(s, s) == '1' and 2 ^ (6 - s) or 0) end
        return s:sub(j + 1, j + 1)
    end) .. ({ '', '==', '=' })[#k % 3 + 1]
end
local function N(k)
    k = string.gsub(k, '[^' .. (s .. '=]'), '')
    return (k:gsub('.', function(k)
        if k == '=' then return '' end
        local j, c = '', s:find(k) - 1
        for k = 6, 1, -1 do j = j .. (c % 2 ^ k - c % 2 ^ (k - 1) > 0 and '1' or '0') end
        return j-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    end)):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(k)
        if #k ~= 8 then return '' end
        local j = 0
        for s = 1, 8, 1 do j = j + (k:sub(s, s) == '1' and 2 ^ (8 - s) or 0) end
        return string.char(j)
    end)
end
local function m(k, j)
    local s = {}
    for k in string.gmatch(k, '([^' .. (j .. ']+)')) do s[#s + 1] = string.gsub(k, '\n', ' ') end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    return s
end
local function D(k)
    if k == 'true' or k == 'false' then
        return k == 'true'-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    else
        return k
    end
end

local H = 'lua>tab a>'
local v = 'lua>tab b>'-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local l = gui.add_listbox('Select', H, 5, true, { 'User info', 'Ragebot', 'Hanz AA', 'Solus', 'Settings' })
local inverter_spam = gui.add_checkbox("Hanz#9003", "lua>tab a")
local U = gui.add_textbox('Fatality UID', v)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local Y = gui.add_checkbox('solus color', v)
local M = gui.add_colorpicker(v .. 'solus color', false)

--local O = gui.add_button('https://discord.gg/icebreakers Coder', v, function()-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
--    utils.print_console('\n[icebreak.lua] ', M:get_color())
--    utils.print_console('Hanz#9003', render.color('#ffffff'))                   
--end)
-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  


function checkinghome()-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    local k = l:get_int()
    gui.set_visible(v .. 'Fatality UID', k == 0)
    gui.set_visible(v .. 'solus Color', k == 0)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
--    gui.set_visible(v .. 'https://discord.gg/icebreakers Coder', k == 0)
end
function checkingconfigs()-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    local k = l:get_int()
    gui.set_visible(v .. 'Import Config', k == 5)
    gui.set_visible(v .. 'Export Config', k == 5)
end
local T = gui.add_checkbox('DA', v)
gui.add_keybind(v .. 'DA')
local R = gui.get_config_item('Rage>Anti-Aim>Desync>Leg Slide')
local h = gui.add_checkbox('breaker leg anim', v)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local y = gui.add_checkbox('hit logs', v)
function dormantaimbot()
    local k = gui.get_config_item('rage>aimbot>aimbot>target dormant')-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    if not engine.is_in_game() then return end
    if T:get_bool() then
        k:set_bool(true)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    else
        k:set_bool(false)
    end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
end

local u = utils.new_timer(31, function() if h:get_bool() then R:set_int(1) end end)
u:start()
local E = utils.new_timer(50, function() if h:get_bool() then R:set_int(2) end end)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
E:start()
function on_shot_registered(k)
    if not y:get_bool() then return end
    if k.manual then return end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    utils.print_console('\n[icebreak.lua] ', M:get_color())
    local j = entities.get_entity(k.target)
    local s = j:get_player_info()
    utils.print_console(string.format('Fired at: %s | HC: %i | ED: %i | AD: %i | Result: %s | BT: %i | SP: %s | Roll SP: %s | Mismatched: %s\n', s.name, k.hitchance, k.client_damage, k.server_damage,
        k.result, k.backtrack, k.secure, k.very_secure, k.client_hitgroup ~= k.server_hitgroup), render.color('#ffffff'))
end
function checkingrage()
    local k = l:get_int()-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    gui.set_visible(v .. 'DA', k == 1)
    gui.set_visible(v .. 'hit logs', k == 1)
end
local x = gui.add_checkbox('flicker', v)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
gui.add_keybind(v .. 'flicker')
local C = gui.add_checkbox('Anti-Aim', v)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local o = gui.add_combo('Choose AntiAim', v, { 'AntiAim Presets', 'AntiAim Builder' })
local a = gui.add_combo('Choose Presets', v, { 'Default', 'Normal', 'Agressive', 'Tank', 'Hanz AA' })
local w = gui.add_combo('Choose AntiAim Condition:', v, { 'None', 'Standing', 'Moving', 'Slow Walking', 'Crouching', 'In Air' })
local S = gui.add_checkbox('[S] Jitter', v)
local q = gui.add_slider('[S] Jitter Range', v, 0, 360, 0)
local I = gui.add_checkbox('[S] Yaw Toggle', v)
local L = gui.add_slider('[S] Yaw Range', v, -180, 180, 0)
local K = gui.add_checkbox('[S] Fake Toggle', v)
local X = gui.add_slider('[S] Fake Amount', v, -100, 100, 0)
local Z = gui.add_slider('[S] Compensate Angle', v, 0, 100, 0)
local Q = gui.add_checkbox('[S] Flip Fake With Jitter', v)
local W = gui.add_checkbox('[M] Jitter', v)
local f = gui.add_slider('[M] Jitter Range', v, 0, 360, 0)
local B = gui.add_checkbox('[M] Yaw Toggle', v)
local A = gui.add_slider('[M] Yaw Range', v, -180, 180, 0)
local P = gui.add_checkbox('[M] Fake Toggle', v)
local d = gui.add_slider('[M] Fake Amount', v, -100, 100, 0)
local t = gui.add_slider('[M] Compensate Angle', v, 0, 100, 0)
local V = gui.add_checkbox('[M] Flip Fake With Jitter', v)
local e = gui.add_checkbox('[SW] Jitter', v)
local p = gui.add_slider('[SW] Jitter Range', v, 0, 360, 0)
local J = gui.add_checkbox('[SW] Yaw Toggle', v)
local G = gui.add_slider('[SW] Yaw Range', v, -180, 180, 0)
local i = gui.add_checkbox('[SW] Fake Toggle', v)
local kU = gui.add_slider('[SW] Fake Amount', v, -100, 100, 0)
local jU = gui.add_slider('[SW] Compensate Angle', v, 0, 100, 0)
local sU = gui.add_checkbox('[SW] Flip Fake With Jitter', v)
local cU = gui.add_checkbox('[C] Jitter', v)
local NU = gui.add_slider('[C] Jitter Range', v, 0, 360, 0)
local mU = gui.add_checkbox('[C] Yaw Toggle', v)
local DU = gui.add_slider('[C] Yaw Range', v, -180, 180, 0)
local HU = gui.add_checkbox('[C] Fake Toggle', v)
local vU = gui.add_slider('[C] Fake Amount', v, -100, 100, 0)
local lU = gui.add_slider('[C] Compensate Angle', v, 0, 100, 0)
local UU = gui.add_checkbox('[C] Flip Fake With Jitter', v)
local YU = gui.add_checkbox('[A] Jitter', v)
local MU = gui.add_slider('[A] Jitter Range', v, 0, 360, 0)
local FU = gui.add_checkbox('[A] Yaw Toggle', v)
local OU = gui.add_slider('[A] Yaw Range', v, -180, 180, 0)
local TU = gui.add_checkbox('[A] Fake Toggle', v)
local zU = gui.add_slider('[A] Fake Amount', v, -100, 100, 0)
local RU = gui.add_slider('[A] Compensate Angle', v, 0, 100, 0)
local hU = gui.add_checkbox('[A] Flip Fake With Jitter', v)
local yU = false-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local bU = gui.get_config_item('Rage>Anti-Aim>Desync>Fake Amount')
local uU = gui.get_config_item('Rage>Anti-Aim>Angles>Add')
local EU = gui.get_config_item('Rage>Anti-Aim>Desync>Fake Amount')
local nU = EU:get_int() >= 0-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
function fl()
    if x:get_bool() then-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        if global_vars.tickcount % 19 == 13 and EU:get_int() >= 0 then-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            uU:set_int(95)
        else-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            if global_vars.tickcount % 19 == 13 and 0 >= EU:get_int() then uU:set_int(-95) end
        end
    end
end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local xU = gui.get_config_item('rage>anti-aim>angles>jitter')
local CU = gui.get_config_item('rage>anti-aim>angles>jitter range')-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local gU = gui.get_config_item('rage>anti-aim>desync>fake')
local oU = gui.get_config_item('rage>anti-aim>desync>fake amount')-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local aU = gui.get_config_item('rage>anti-aim>desync>compensate angle')
local wU = gui.get_config_item('rage>anti-aim>desync>freestand fake')
local SU = gui.get_config_item('rage>anti-aim>desync>flip fake with jitter')
local qU = gui.get_config_item('rage>anti-aim>angles>yaw add')-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local IU = gui.get_config_item('rage>anti-aim>angles>add')
local rU = gui.get_config_item('misc>movement>slide')
function aa_presets()
    local k = C:get_bool()-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    if k == true then
        if o:get_int() == 0 then
            local k = entities.get_entity(engine.get_local_player())
            local j = k:get_prop('m_fFlags')-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            local s = k:get_prop('m_hGroundEntity') == -1
            local c = math.floor(k:get_prop('m_vecVelocity[0]'))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            local N = math.floor(k:get_prop('m_vecVelocity[1]'))
            local m = math.sqrt(c ^ 2 + N ^ 2)
            local D = input.is_key_down(17)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            if a:get_int() == 1 then
                if m > 2 and (not s and not D) then
                    xU:set_bool(true)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                    CU:set_int(13)
                    gU:set_bool(true)
                    oU:set_int(65)
                    aU:set_int(83)
                    wU:set_int(1)
                    qU:set_bool(true)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                    IU:set_int(-5)
                elseif m <= 2 and j == 257 then
                    xU:set_bool(true)
                    CU:set_int(6)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                    gU:set_bool(true)
                    oU:set_int(100)
                    aU:set_int(65)
                    wU:set_int(1)
                    qU:set_bool(true)
                    IU:set_int(0)
                elseif D then
                    xU:set_bool(true)
                    CU:set_int(8)
                    gU:set_bool(true)
                    oU:set_int(53)
                    aU:set_int(78)
                    wU:set_int(1)
                    qU:set_bool(true)
                    IU:set_int(3)
                elseif s and j ~= 262 then
                    xU:set_bool(true)
                    CU:set_int(20)
                    gU:set_bool(true)
                    oU:set_int(85)
                    aU:set_int(34)
                    wU:set_int(1)
                    qU:set_bool(true)
                    IU:set_int(0)
                end
            else
                if a:get_int() == 2 then
                    if m > 2 and (not s and not D) then
                        xU:set_bool(true)
                        CU:set_int(20)
                        gU:set_bool(true)
                        oU:set_int(77)
                        aU:set_int(54)
                        wU:set_int(1)
                        qU:set_bool(true)
                        IU:set_int(0)
                    elseif m <= 2 and j == 257 then
                        xU:set_bool(true)
                        CU:set_int(5)
                        gU:set_bool(true)
                        oU:set_int(50)
                        aU:set_int(31)
                        wU:set_int(1)
                        qU:set_bool(true)
                        IU:set_int(15)
                    elseif D then
                        xU:set_bool(true)
                        CU:set_int(3)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                        gU:set_bool(true)
                        oU:set_int(53)
                        aU:set_int(78)
                        wU:set_int(1)
                        qU:set_bool(true)
                        IU:set_int(3)
                    elseif s and j ~= 262 then
                        xU:set_bool(true)
                        CU:set_int(23)
                        gU:set_bool(true)
                        oU:set_int(45)
                        aU:set_int(67)
                        wU:set_int(1)
                        qU:set_bool(true)
                        IU:set_int(2)
                    end
                elseif a:get_int() == 3 then
                    xU:set_bool(true)
                    CU:set_int(8)
                    gU:set_bool(true)
                    oU:set_int(83)
                    aU:set_int(74)
                    wU:set_int(1)
                    qU:set_bool(true)
                    IU:set_int(8)
                end
            end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        end
    end
end
function aa_presetstwo()
    local k = C:get_bool()
    if k == true then
        if o:get_int() == 0 then
            local k = entities.get_entity(engine.get_local_player())
            local j = k:get_prop('m_fFlags')
            local s = k:get_prop('m_hGroundEntity') == -1
            local c = math.floor(k:get_prop('m_vecVelocity[0]'))
            local N = math.floor(k:get_prop('m_vecVelocity[1]'))
            local m = math.sqrt(c ^ 2 + N ^ 2)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            local D = input.is_key_down(17)
            if a:get_int() == 4 then
                if m > 2 and (not s and not D) then
                    xU:set_bool(true)
                    CU:set_int(36)
                    gU:set_bool(true)
                    oU:set_int(80)
                    aU:set_int(100)
                    wU:set_int(1)
                    qU:set_bool(true)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                    IU:set_int(-23)
                elseif m <= 2 and j == 257 then
                    xU:set_bool(true)
                    CU:set_int(15)
                    gU:set_bool(true)
                    oU:set_int(75)
                    aU:set_int(100)
                    wU:set_int(1)
                    qU:set_bool(true)
                    IU:set_int(-5)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                elseif D then
                    xU:set_bool(true)
                    CU:set_int(24)
                    gU:set_bool(true)
                    oU:set_int(100)
                    aU:set_int(72)
                    wU:set_int(1)
                    qU:set_bool(true)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                    IU:set_int(-8)
                elseif s and j ~= 262 then
                    xU:set_bool(true)
                    CU:set_int(15)
                    gU:set_bool(true)
                    oU:set_int(41)
                    aU:set_int(64)
                    wU:set_int(1)
                    qU:set_bool(true)
                    IU:set_int(16)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                end
            end
        end
    end
end
function get_cond()
    local k = entities.get_entity(engine.get_local_player())
    local j = k:get_prop('m_fFlags')-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    local s = k:get_prop('m_hGroundEntity') == -1
    local c = math.floor(k:get_prop('m_vecVelocity[0]'))
    local N = math.floor(k:get_prop('m_vecVelocity[1]'))
    local m = math.sqrt(c ^ 2 + N ^ 2)
    local D = input.is_key_down(17)
    if m > 2 and not s then
        return '  Ice MOVE'
    elseif m <= 2 and j == 257 then-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        return '  Ice STAND'
    elseif s and j ~= 262 then
        return '  Ice AIR'
    else
        return '  Ice CROUCH'
    end
end
function antiaimbuilder()-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    local k = C:get_bool()
    if k == true then
        if o:get_int() == 1 then
            local k = entities.get_entity(engine.get_local_player())
            local j = k:get_prop('m_fFlags')
            local s = k:get_prop('m_hGroundEntity') == -1
            local c = math.floor(k:get_prop('m_vecVelocity[0]'))
            local N = math.floor(k:get_prop('m_vecVelocity[1]'))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            local m = math.sqrt(c ^ 2 + N ^ 2)
            local D = input.is_key_down(17)
            if m > 2 and (not s and not D) then
                xU:set_bool(W:get_bool())
                CU:set_int(f:get_int())
                gU:set_bool(P:get_bool())
                oU:set_int(d:get_int())
                aU:set_int(t:get_int())-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                qU:set_bool(B:get_bool())
                IU:set_int(A:get_int())
                SU:set_bool(V:get_bool())
            elseif m <= 2 and j == 257 then
                xU:set_bool(S:get_bool())-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                CU:set_int(q:get_int())
                gU:set_bool(K:get_bool())
                oU:set_int(X:get_int())
                aU:set_int(Z:get_int())
                qU:set_bool(I:get_bool())
                IU:set_int(L:get_int())
                SU:set_bool(Q:get_bool())
            elseif D then-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                xU:set_bool(cU:get_bool())
                CU:set_int(NU:get_int())
                gU:set_bool(HU:get_bool())
                oU:set_int(vU:get_int())
                aU:set_int(lU:get_int())
                qU:set_bool(mU:get_bool())
                IU:set_int(DU:get_int())
                SU:set_bool(UU:get_bool())-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            elseif s then
                xU:set_bool(YU:get_bool())
                CU:set_int(MU:get_int())
                gU:set_bool(TU:get_bool())
                oU:set_int(zU:get_int())
                aU:set_int(RU:get_int())
                qU:set_bool(FU:get_bool())
                IU:set_int(OU:get_int())-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                SU:set_bool(hU:get_bool())
            end
        end
    end
end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
function checkingantiaim()
    local k = l:get_int()
    local j = C:get_bool()
    local s = o:get_int()
    local c = w:get_int()
    gui.set_visible(v .. 'flicker', k == 2)
    gui.set_visible(v .. 'breaker leg anim', k == 2)
    gui.set_visible(v .. 'Anti-Aim', k == 2)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    gui.set_visible(v .. 'Choose AntiAim', k == 2 and j == true)
    gui.set_visible(v .. 'Choose Presets', k == 2 and (j == true and s == 0))
    gui.set_visible(v .. 'Choose AntiAim Condition:', k == 2 and (j == true and s == 1))
    gui.set_visible(v .. '[S] Jitter', k == 2 and (j == true and (s == 1 and c == 1)))
    gui.set_visible(v .. '[S] Jitter Range', k == 2 and (j == true and (s == 1 and c == 1)))
    gui.set_visible(v .. '[S] Yaw Toggle', k == 2 and (j == true and (s == 1 and c == 1)))
    gui.set_visible(v .. '[S] Yaw Range', k == 2 and (j == true and (s == 1 and c == 1)))
    gui.set_visible(v .. '[S] Fake Toggle', k == 2 and (j == true and (s == 1 and c == 1)))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    gui.set_visible(v .. '[S] Fake Amount', k == 2 and (j == true and (s == 1 and c == 1)))
    gui.set_visible(v .. '[S] Compensate Angle', k == 2 and (j == true and (s == 1 and c == 1)))
    gui.set_visible(v .. '[S] Flip Fake With Jitter', k == 2 and (j == true and (s == 1 and c == 1)))
    gui.set_visible(v .. '[M] Jitter', k == 2 and (j == true and (s == 1 and c == 2)))
    gui.set_visible(v .. '[M] Jitter Range', k == 2 and (j == true and (s == 1 and c == 2)))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    gui.set_visible(v .. '[M] Yaw Toggle', k == 2 and (j == true and (s == 1 and c == 2)))
    gui.set_visible(v .. '[M] Yaw Range', k == 2 and (j == true and (s == 1 and c == 2)))
    gui.set_visible(v .. '[M] Fake Toggle', k == 2 and (j == true and (s == 1 and c == 2)))
    gui.set_visible(v .. '[M] Fake Amount', k == 2 and (j == true and (s == 1 and c == 2)))
    gui.set_visible(v .. '[M] Compensate Angle', k == 2 and (j == true and (s == 1 and c == 2)))
    gui.set_visible(v .. '[M] Flip Fake With Jitter', k == 2 and (j == true and (s == 1 and c == 2)))
    gui.set_visible(v .. '[SW] Jitter', k == 2 and (j == true and (s == 1 and c == 3)))
    gui.set_visible(v .. '[SW] Jitter Range', k == 2 and (j == true and (s == 1 and c == 3)))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    gui.set_visible(v .. '[SW] Yaw Toggle', k == 2 and (j == true and (s == 1 and c == 3)))
    gui.set_visible(v .. '[SW] Yaw Range', k == 2 and (j == true and (s == 1 and c == 3)))
    gui.set_visible(v .. '[SW] Fake Toggle', k == 2 and (j == true and (s == 1 and c == 3)))
    gui.set_visible(v .. '[SW] Fake Amount', k == 2 and (j == true and (s == 1 and c == 3)))
    gui.set_visible(v .. '[SW] Compensate Angle', k == 2 and (j == true and (s == 1 and c == 3)))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    gui.set_visible(v .. '[SW] Flip Fake With Jitter', k == 2 and (j == true and (s == 1 and c == 3)))
    gui.set_visible(v .. '[C] Jitter', k == 2 and (j == true and (s == 1 and c == 4)))
    gui.set_visible(v .. '[C] Jitter Range', k == 2 and (j == true and (s == 1 and c == 4)))
    gui.set_visible(v .. '[C] Yaw Toggle', k == 2 and (j == true and (s == 1 and c == 4)))
    gui.set_visible(v .. '[C] Yaw Range', k == 2 and (j == true and (s == 1 and c == 4)))
    gui.set_visible(v .. '[C] Fake Toggle', k == 2 and (j == true and (s == 1 and c == 4)))
    gui.set_visible(v .. '[C] Fake Amount', k == 2 and (j == true and (s == 1 and c == 4)))
    gui.set_visible(v .. '[C] Compensate Angle', k == 2 and (j == true and (s == 1 and c == 4)))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    gui.set_visible(v .. '[C] Flip Fake With Jitter', k == 2 and (j == true and (s == 1 and c == 4)))
    gui.set_visible(v .. '[A] Jitter', k == 2 and (j == true and (s == 1 and c == 5)))
    gui.set_visible(v .. '[A] Jitter Range', k == 2 and (j == true and (s == 1 and c == 5)))
    gui.set_visible(v .. '[A] Yaw Toggle', k == 2 and (j == true and (s == 1 and c == 5)))
    gui.set_visible(v .. '[A] Yaw Range', k == 2 and (j == true and (s == 1 and c == 5)))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    gui.set_visible(v .. '[A] Fake Toggle', k == 2 and (j == true and (s == 1 and c == 5)))
    gui.set_visible(v .. '[A] Fake Amount', k == 2 and (j == true and (s == 1 and c == 5)))
    gui.set_visible(v .. '[A] Compensate Angle', k == 2 and (j == true and (s == 1 and c == 5)))
    gui.set_visible(v .. '[A] Flip Fake With Jitter', k == 2 and (j == true and (s == 1 and c == 5)))
end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local LU, KU, XU = gui.add_multi_combo('visual Items', v, { 'superior watermark', 'Show Geybinds', 'Flag list' })
local ZU = gui.add_combo('version of UI', v, { '2022', '2023' })
local QU = gui.add_checkbox('Indicators Under Crosshair', v)
local WU = gui.add_combo('Style of indicators', v, {' ','Main' })
local fU = gui.add_checkbox('Like skeet Indicators', v)
local BU = gui.add_combo('Flag', v, { 'Reichsflagge' })-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local AU = render.font_esp
function render.window(k, j, s, c, N, m, D, H)
    if ZU:get_int() == 0 then
        render.rect_filled(k, j, s, c, render.color(39, 39, 39, 255 * H))
        render.rect_filled(k + 1, j + 1, s - 1, c - 1, render.color(25, 25, 25, 255 * H))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    end
    if ZU:get_int() == 1 then-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        render.rect_filled_rounded(k, j, s, c, render.color(0, 0, 0, 105 * H), 2, render.all)
        render.rect_filled(k, j, s, j + 1, render.color(N, m, D, 255 * H))
        render.rect_filled_multicolor(k - 1, j + 1, k, c, render.color(N, m, D, 255 * H), render.color(N, m, D, 255 * H), render.color(0, 0, 0, 0), render.color(0, 0, 0, 0))
        render.rect_filled_multicolor(s + 1, j + 1, s, c, render.color(N, m, D, 255 * H), render.color(N, m, D, 255 * H), render.color(0, 0, 0, 0), render.color(0, 0, 0, 0))
    end
end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
function accumulate_fps() return math.ceil(1 / global_vars.frametime) end
function get_tick()
    if not engine.is_in_game() then return end
    return math.floor(1 / global_vars.interval_per_tick)
end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local PU, dU = render.get_screen_size()
function watermark()
    if LU:get_bool() then
        local k, j = render.get_text_size(AU, 'icebreak')
        local s, c = render.get_text_size(AU, ' | ' .. (U:get_string() .. ' | BETA build'))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        local N, m = render.get_text_size(AU, 'icebreak | ' .. (U:get_string() .. ' | Hanz#9003/soypik#6969 '))
        local D = 255
        render.window((PU / 2 - N / 2) - 4, dU - 21, (PU / 2 + N / 2) + 4, dU - 1, (M:get_color()).r, (M:get_color()).g, (M:get_color()).b, 1)
        for s = 1, 10, 1 do
            render.rect_filled_rounded((PU / 2 - N / 2) - s, (dU - 14) - s, ((PU / 2 - N / 2) + k) + s, ((dU - 14) + j / 2) + s,-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, (20 - 2 * s) * .35), 10)
        end
        render.text(AU, PU / 2 - N / 2, dU - 14, 'icebreak', render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, 255))
        render.text(AU, (PU / 2 - N / 2) + k, dU - 14, ' | ' .. (U:get_string() .. ' | Hanz#9003 AIM'), render.color(98, 98, 98, 255))
    end
end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local tU = { { text = '^ icebreak.lua activated ^', path = 'lua>tab b>Like skeet Indicators' }, { text = '" Ice Duck "', path = 'misc>movement>fake duck' }, { text = 'ICEBREAK DT', path = 'rage>aimbot>aimbot>double tap' },
{ text = '% ONSHOT KING %', path = 'rage>aimbot>aimbot>hide shot' }, { text = '# AUTOPEEK #', path = 'rage>anti-aim>angles>freestand' }, { text = '# HS ONLY KING #', path = 'rage>aimbot>aimbot>headshot only' },
{ text = '$ DEFENSIVE PEEK ENABLED $', path = 'lua>tab b>fps up' }, { text = '$ DORMANT AIMBOT $', path = 'rage>aimbot>aimbot>Target dormant' }, { text = 'AX', path = 'rage>aimbot>aimbot>Anti-exploit' }, { text = ' * Black ANTI-AIM SYSTEM * ', path = 'lua>tab b>Anti-Aim' }, }
local VU = function()
    local k = entities.get_entity(engine.get_local_player())-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    local j = k:get_prop('m_vecVelocity[0]')-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    local s = k:get_prop('m_vecVelocity[1]')
    return math.sqrt(j * j + s * s)
end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local eU = function()
    local k = {}-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    for j, s in pairs(tU) do if (gui.get_config_item(s.path)):get_bool() then table.insert(k, s.text) end end
    return k
end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local pU = math.vec3(render.get_screen_size())
local JU = function(k, j, s) return math.floor(k + (j - k) * s) end
local GU = { 0, 0, 0, 0, 0 }
local iU = render.create_font('calibrib.ttf', 23, render.font_flag_shadow)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
function skeetind()
    if fU:get_bool() then
        local k = entities.get_entity(engine.get_local_player())
        if not k then return end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        add_y = 0
        if info.fatality.can_fastfire then-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            GU[1] = JU(GU[1], 255, global_vars.frametime * 11)
            add_y = add_y + 7
        else
            if GU[1] > 0 then add_y = add_y + 7 end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            GU[1] = JU(GU[1], 0, global_vars.frametime * 11)
        end
        local s = j.anim_new('m_bIsScoped add dbbx2', info.fatality.can_fastfire and 1 or .01)
        local c = gui.get_config_item('lua>tab b>fps up')-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        local N = (c:get_int() / 100) * 2
        local m = info.fatality.can_fastfire and render.color(255, 255, 255, GU[1]) or render.color(226, 54, 55, 255)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        for k, c in pairs(eU()) do
            local D = { x = 10, y = (pU.y / 2 + 98) + 35 * (k - 1) }
            local H = utils.random_int(15, 100) / 100
            local v = j.anim_new('aainverted1xq34', fU:get_bool() and utils.random_int(15, 100) / 100 or 0)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            local l = render.color(150, 200, 30)
            if c == 'AA' then
                l = render.color(85, 91, 194)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                render.circle(D.x + 50, D.y + 10, 5, render.color(0, 0, 0, 255), 3, 22, 1, 1)
                render.circle(D.x + 50, D.y + 10, 5, render.color(85, 91, 194, 255), 3, 12, H, 1)
            end
            if c == 'DT' then-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                l = m
                render.circle(D.x + 44, D.y + 10, 5, render.color(0, 0, 0, 255), 3, 22, 1, 1)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                render.circle(D.x + 44, D.y + 10, 5, m, 3, 12, s, 1)
            end
            if c == 'O-shot' then if not info.fatality.can_onshot then l = render.color(125, 130, 209) end end
            if c == 'O-shot' then if not info.fatality.can_onshot then l = render.color(125, 130, 209) end end
            if c == 'Roll' then-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                l = render.color(232, 113, 111)
                render.circle(D.x + 68, D.y + 10, 5, render.color(0, 0, 0, 255), 3, 22, 1, 1)
                render.circle(D.x + 68, D.y + 10, 5, render.color(232, 113, 111, 255), 3, 12, N, 1)
            end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            local U = math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255)
            if c == 'DG' then l = render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, U) end
            local Y = math.vec3(render.get_text_size(iU, c))
            for k = 1, 10, 1 do render.rect_filled_rounded((D.x + 4) - k, D.y - k, ((D.x + Y.x) + 8) + k, ((D.y + Y.y) - 3) + k, render.color(l.r, l.g, l.b, (20 - 2 * k) * .35), 10) end
            render.text(iU, D.x + 8, D.y, c, l)
        end
    end
end
-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
function gui_controller()
    local k = 'icebreak'
    local j = render.font_esp-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    local s = U:get_string()
    local c, N = render.get_text_size(j, k)
    local m = 'user: ' .. (s .. '')
    local D, H = render.get_text_size(j, m)
    local v, l = render.get_text_size(j, ' [icebreak]')
    local Y = BU:get_int()
    local F = math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255)
    local O, T = render.get_screen_size()-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    if XU:get_bool() then
        render.window(7, (T / 2 + 35) + 2, (65 + D) + v, (T / 2 + 37) + 34, (M:get_color()).r, (M:get_color()).g, (M:get_color()).b, 1)
        render.text(j, 52, T / 2 + 43, 'icebreak', render.color(255, 255, 255, 255))
        render.text(j, 52, T / 2 + 56, 'user: ' .. (s .. ''), render.color(255, 255, 255, 255))
        render.text(j, 52 + D, T / 2 + 56, ' [icebreak]', render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, F))
        if Y == 0 then
            render.rect_filled(12, T / 2 + 42, 45, T / 2 + 49, render.color(255, 255, 255, 255))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            render.rect_filled(12, T / 2 + 49, 45, T / 2 + 56, render.color(28, 53, 120, 255))
            render.rect_filled(12, T / 2 + 56, 45, T / 2 + 65, render.color(2228, 24, 28, 255))
        end
        if Y == 1 then
            render.rect_filled(12, T / 2 + 42, 45, T / 2 + 49, render.color(0, 0, 0, 255))
            render.rect_filled(12, T / 2 + 49, 45, T / 2 + 56, render.color(221, 0, 0, 255))
            render.rect_filled(12, T / 2 + 56, 45, T / 2 + 65, render.color(255, 204, 0, 255))
        end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        if Y == 2 then
            render.rect_filled(12, T / 2 + 42, 45, T / 2 + 49, render.color(0, 114, 206, 255))
            render.rect_filled(12, T / 2 + 49, 45, T / 2 + 56, render.color(0, 0, 0, 255))
            render.rect_filled(12, T / 2 + 56, 45, T / 2 + 65, render.color(255, 255, 255, 255))
        end
        if Y == 3 then
            render.rect_filled(12, T / 2 + 42, 45, T / 2 + 49,render.color(0, 43, 127, 255))
            render.rect_filled(12, T / 2 + 49, 45, T / 2 + 56,render.color(252, 209, 22, 255))
            render.rect_filled(12, T / 2 + 56, 45, T / 2 + 65,render.color(206, 17, 38, 255))
        end
        if Y == 4 then
            render.rect_filled(12, T / 2 + 42, 45, T / 2 + 49, render.color(0, 0, 0, 255))
            render.rect_filled(12, T / 2 + 49, 45, T / 2 + 56, render.color(255, 255, 255, 255))
            render.rect_filled(12, T / 2 + 56, 45, T / 2 + 65, render.color(255, 17, 0, 255))
        end
    end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
end
local kC = { render.get_screen_size() }
local jC = gui.add_slider('keybinds_x', v, 0, kC[1], 1)
local sC = gui.add_slider('keybinds_y', v, 0, kC[2], 1)
gui.set_visible(v .. 'keybinds_x', false)
gui.set_visible(v .. 'keybinds_y', false)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
function animate(k, j, s, c, N, m)
    c = (c * global_vars.frametime) * 20
    if N == false then
        if j then
            k = k + c
        else
            k = k - c
        end
    else
        if j then
            k = k + (s - k) * (c / 100)
        else
            k = k - (0 + k) * (c / 100)
        end
    end
    if m then-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        if k > s then
            k = s
        elseif k < 0 then
            k = 0
        end
    end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    return k
end
function drag(k, j, s, c)
    local N, m = input.get_cursor_pos()
    local D = false-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    if input.is_key_down(1) then
        if N > k:get_int() and (m > j:get_int() and (N < k:get_int() + s and m < j:get_int() + c)) then D = true end
    else
        D = false
    end
    if D then
        k:set_int(N - s / 2)
        j:set_int(m - c / 2)
    end
end
function on_keybinds()
    if not KU:get_bool() then return end
    local k = { jC:get_int(), sC:get_int() }
    local j = 0
    local s = { (gui.get_config_item('rage>aimbot>aimbot>double tap')):get_bool(), (gui.get_config_item('rage>aimbot>aimbot>hide shot')):get_bool(),-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    (gui.get_config_item('rage>aimbot>ssg08>scout>override')):get_bool(), (gui.get_config_item('rage>aimbot>aimbot>headshot only')):get_bool(),
    (gui.get_config_item('misc>movement>fake duck')):get_bool() }
    local c = { 'Doubletap', 'On-shot ', 'Override Damage', 'Head', 'Duck-peek ', 'Head' }
    if not s[4] then
        if not s[5] then
            if not s[3] then
                if not s[1] then
                    if not s[6] then-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                        if not s[2] then
                            j = 0
                        else
                            j = 38
                        end
                    else-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                        j = 40
                    end
                else-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
                    j = 41
                end
            else
                j = 54
            end
        else
            j = 63
        end
    else
        j = 70
    end
    animated_size_offset = animate(animated_size_offset or 0, true, j, 60, true, false)
    local N = { 80 + animated_size_offset, 21 }
    local m = 'enabled'-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    local D = render.get_text_size(AU, m) + 7
    local H = s[3] or s[4] or s[5] or s[6] or s[7] or s[8]
    local v = s[1] or s[2] or s[9] or s[10] or s[11]
    drag(jC, sC, N[1], N[2])
    local l = math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255)
    alpha = animate(alpha or 0, gui.is_menu_open() or H or v, 1, .5, false, true)
    local U, Y = render.get_text_size(AU, 'keybinds')-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    render.window(k[1], k[2], k[1] + N[1], k[2] + N[2], (M:get_color()).r, (M:get_color()).g, (M:get_color()).b, alpha)
    for j = 1, 10, 1 do
        render.rect_filled_rounded((((k[1] + N[1] / 2) - render.get_text_size(AU, 'keybinds') / 2) - 1) - j, (k[2] + 7) - j, (((k[1] + N[1] / 2) + render.get_text_size(AU, 'keybinds') / 2) - 1) + j,
            ((k[2] + 4) + Y) + j, render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, (20 - 2 * j) * (alpha - .65)), 10)
    end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    render.text(AU, ((k[1] + N[1] / 2) - render.get_text_size(AU, 'keybinds') / 2) - 1, k[2] + 7, 'keybinds', render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, 255 * alpha))
    local F = 0
    dt_alpha = animate(dt_alpha or 0, s[1], 1, .5, false, true)
    render.text(AU, k[1] + 6, (k[2] + N[2]) + 2, c[1], render.color(255, 255, 255, 255 * dt_alpha))
    render.text(AU, (k[1] + N[1]) - D, (k[2] + N[2]) + 2, m, render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, (M:get_color()).a * dt_alpha))
    if s[1] then F = F + 11 end
    hs_alpha = animate(hs_alpha or 0, s[2], 1, .5, false, true)
    render.text(AU, k[1] + 6, ((k[2] + N[2]) + 2) + F, c[2], render.color(255, 255, 255, 255 * hs_alpha))
    render.text(AU, (k[1] + N[1]) - D, ((k[2] + N[2]) + 2) + F, m, render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, (M:get_color()).a * hs_alpha))
    if s[2] then F = F + 11 end
    dmg_alpha = animate(dmg_alpha or 0, s[3], 1, .5, false, true)
    render.text(AU, k[1] + 6, ((k[2] + N[2]) + 2) + F, c[3], render.color(255, 255, 255, 255 * dmg_alpha))
    render.text(AU, (k[1] + N[1]) - D, ((k[2] + N[2]) + 2) + F, m, render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, (M:get_color()).a * dmg_alpha))
    if s[3] then F = F + 11 end
    fs_alpha = animate(fs_alpha or 0, s[4], 1, .5, false, true)
    render.text(AU, k[1] + 6, ((k[2] + N[2]) + 2) + F, c[4], render.color(255, 255, 255, 255 * fs_alpha))
    render.text(AU, (k[1] + N[1]) - D, ((k[2] + N[2]) + 2) + F, m, render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, (M:get_color()).a * fs_alpha))
    if s[4] then F = F + 11 end
    ho_alpha = animate(ho_alpha or 0, s[5], 1, .5, false, true)
    render.text(AU, k[1] + 6, ((k[2] + N[2]) + 2) + F, c[5], render.color(255, 255, 255, 255 * ho_alpha))
    render.text(AU, (k[1] + N[1]) - D, ((k[2] + N[2]) + 2) + F, m, render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, (M:get_color()).a * ho_alpha))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    if s[5] then F = F + 11 end
    fd_alpha = animate(fd_alpha or 0, s[6], 1, .5, false, true)
    render.text(AU, k[1] + 6, ((k[2] + N[2]) + 2) + F, c[6], render.color(255, 255, 255, 255 * fd_alpha))
    render.text(AU, (k[1] + N[1]) - D, ((k[2] + N[2]) + 2) + F, m, render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, (M:get_color()).a * fd_alpha))
end
function checkingwidgets()
    local k = l:get_int()-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    local j = XU:get_bool()
    gui.set_visible(v .. 'Visual Items', k == 3)
    gui.set_visible(v .. 'Indicators Under Crosshair', k == 3)
    gui.set_visible(v .. 'Like skeet Indicators', k == 3)
    gui.set_visible(v .. 'Style of indicators', k == 1 and QU:get_bool())
    gui.set_visible(v .. 'version of UI', k == 3 and (LU:get_bool() or KU:get_bool() or XU:get_bool()))
    gui.set_visible(v .. 'Flag', k == 3 and j)
end
local cC = gui.add_checkbox('fps up', v)
local NC = gui.add_checkbox('killsay', v)
local mC = gui.add_checkbox('clantag', v)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local DC = gui.add_combo('clantag Type', v, { 'icebreak', 'luckycharms' })
local HC = gui.add_checkbox('aspect Ratio', v)
local vC = gui.add_slider('aspect Value', v, 1, 200, 1)
local function lC(k, j, s, c)
    if k then-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        return j + (((s - j) * global_vars.frametime) * c) / 1.5
    else
        return j - (((s + j) * global_vars.frametime) * c) / 1.5
    end
end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local UC = 0
local YC = 0
local MC = 0
local FC = 0
local OC = { player_states = { 'Standing', 'Moving', 'Slow motion', 'Air', 'Air Duck', 'Crouch' } }
local TC = function(k, j, s) return math.floor(k + (j - k) * s) end
local zC = { 0, 0, 0, 0, 0 }
local RC = render.create_font('Verdana.ttf', 16, render.font_flag_outline)
function indicatorsfunc()
    local k = entities.get_entity(engine.get_local_player())
    if not k then return end
    if not k:is_alive() then return end
    if WU:get_int() == 1 then return end
    local s = k:get_prop('m_bIsScoped')
    UC = lC(s, UC, 15, 10)
    add_y = 17
    local c = math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255)
    local N = entities.get_entity(engine.get_local_player())-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    if not N then return end
    if not N:is_alive() then return end
    local m, D = render.get_screen_size()
    local H = m / 2
    local v = D / 2
    local l = 0
    local U = info.fatality.in_slowwalk-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    local Y = entities.get_entity(engine.get_local_player())
    local F = Y:get_prop('m_hGroundEntity') == -1
    local O = math.floor(Y:get_prop('m_vecVelocity[0]'))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    local T = math.floor(Y:get_prop('m_vecVelocity[1]'))
    local z = math.sqrt(O ^ 2 + T ^ 2) < 5
    local R = bit.band(Y:get_prop('m_fFlags'), bit.lshift(2, 0)) ~= 0
    local h = Y:get_prop('m_fFlags')-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    if QU:get_bool() then
        local k = render.font_esp
        local s = math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        local c = entities.get_entity(engine.get_local_player())
        if not c then return end
        if not c:is_alive() then return end
        local N = info.fatality.can_fastfire and render.color(126, 214, 136, zC[1]) or render.color(226, 54, 55, zC[1])
        c1 = j.anim_new('aainverted1', info.fatality.can_fastfire and (M:get_color()).r or 255)
        c2 = j.anim_new('aainverted2', info.fatality.can_fastfire and (M:get_color()).g or 255)
        c3 = j.anim_new('aainverted3', info.fatality.can_fastfire and (M:get_color()).b or 255)
        c11 = j.anim_new('aainverted11', info.fatality.can_fastfire and 255 or (M:get_color()).r)
        c22 = j.anim_new('aainverted22', info.fatality.can_fastfire and 255 or (M:get_color()).g)
        c33 = j.anim_new('aainverted33', info.fatality.can_fastfire and 255 or (M:get_color()).b)
        local m = entities.get_entity(engine.get_local_player())
        local D = 0
        local H, v = 35, 3
        local l = j.anim_new('m_bIsScoped add 1', c:get_prop('m_bIsScoped') and 15 or 0)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        local U = j.anim_new('m_bIsScoped add 12', c:get_prop('m_bIsScoped') and 24 or 0)
        local Y, F = render.get_screen_size()
        local O = Y / 2
        local T = F / 2
        local z = render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, 255)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        local R = render.color((M:get_color()).r - 70, (M:get_color()).g - 90, (M:get_color()).b - 70, 185)
        local h = 'Ice'
        local y, b = render.get_text_size(RC, h)
        local u, E = render.get_text_size(RC, 'icebreak')-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        local n, x = render.get_text_size(RC, 'icebreak')
        render.text(RC, ((O - (y - 4)) + l) - 4, T + 21, h, render.color(c1, c2, c3, 255))
        render.text(RC, ((O + (y - 4)) + l) - 4, T + 21, 'OUS', render.color(c11, c22, c33, 255))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        if info.fatality.can_fastfire then
            zC[1] = TC(zC[1], 255, global_vars.frametime * 11)
            add_y = add_y + 7
        else
            if zC[1] > 0 then add_y = add_y + 7 end
            zC[1] = TC(zC[1], 0, global_vars.frametime * 11)
        end
        local C = j.anim_new('m_bIsScoped add doulbetap', c:get_prop('m_bIsScoped') and 26 or 0)
        render.text(k, (O - 19) + C, (T + 12) + add_y, 'doubletap', N)
        if info.fatality.in_fakeduck then
            zC[2] = TC(zC[2], 255, global_vars.frametime * 11)
            add_y = add_y + 6
        else
            if zC[2] > 0 then add_y = add_y + 6 end
            zC[2] = TC(zC[2], 0, global_vars.frametime * 11)
        end
        local g = j.anim_new('m_bIsScoped add fd', c:get_prop('m_bIsScoped') and 27 or 0)
        render.text(k, (O - 20) + g, (T + 12) + add_y, 'fake-duck', render.color(137, 174, 255, zC[2]))
        local o = gui.get_config_item('rage>aimbot>aimbot>hide shot')
        if info.fatality.in_slowwalk then
            zC[3] = TC(zC[3], 255, global_vars.frametime * 11)
            add_y = add_y + 6
        else
            if zC[3] > 0 then add_y = add_y + 6 end
            zC[3] = TC(zC[3], 0, global_vars.frametime * 11)
        end
        local a = j.anim_new('m_bIsScoped add sw', c:get_prop('m_bIsScoped') and 227 or 227)
        render.text(k, (O - 20) + a, (T + 12) + add_y, 'slow-walk', render.color(154, 156, 151, zC[3]))
        if o:get_bool() then
            zC[4] = TC(zC[4], 255, global_vars.frametime * 11)
            add_y = add_y + 6
        else
            if zC[4] > 0 then add_y = add_y + 6 end
            zC[4] = TC(zC[4], 0, global_vars.frametime * 11)
        end
        local w = j.anim_new('m_bIsScoped add swxxxx', c:get_prop('m_bIsScoped') and 159 or 50)
        render.text(k, (O - 12) + w, (T + 12) + add_y, 'os-aa', render.color(176, 114, 196, zC[4]))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    end
end
local hC = { 0, 0, 0, 0, 0 }
local yC = function(k, j, s) return math.floor(k + (j - k) * s) end
function indicators2func()
    local k = entities.get_entity(engine.get_local_player())
    if not k then return end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    add_y = 0
    if not k:is_alive() then return end
    if WU:get_int() == 0 then return end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    if QU:get_bool() then
        local s = render.font_esp
        local c, N = render.get_screen_size()
        local m = c / 2
        local D = N / 2
        local H = info.fatality.can_fastfire and render.color(255, 255, 255, hC[1]) or render.color(226, 54, 55, hC[1])-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        local v = j.anim_new('m_bIsScoped add 12', k:get_prop('m_bIsScoped') and 30 or 0)
        local l = j.anim_new('m_bIsScoped add dbb', info.fatality.can_fastfire and 1 or .01)
        local U, Y = render.get_text_size(s, 'DANGS ACTIVE ')
        for k = 1, 10, 1 do
            render.rect_filled_rounded(((m - U / 2) + v) - k, (D + 15) - k, ((m + U / 2) + v) + k, ((D + 15) + Y) + k,
                render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, (20 - 2 * k) * 1), 10)
        end
        local F, O = render.get_text_size(s, 'FA')
        local T, z = render.get_text_size(s, get_cond())
        local R, h = render.get_text_size(s, '11 tick dt')
        render.text(s, (m - U / 2) + v, D + 33, 'MAXIMUM TELEPORT', render.color(154,205,50))
        render.text(s, (m - U / 2) + v, D + 15, 'icebreak ACTIVE', render.color(176,196,222))
        if info.fatality.can_fastfire then
            hC[1] = yC(hC[1], 255, global_vars.frametime * 11)
            add_y = add_y + 711
            render.text(s, (m - T / 2) + v, (D + z) + 12, get_cond(), M:get_color())
            render.circle_filled(((m - T / 2) - 4) + v, (D + z) + 16, 2, render.color(0, 0, 0, 255))
            render.circle_filled(((m - T / 2) - 4) + v, (D + z) + 16, 1, M:get_color())
            render.circle_filled(((m + T / 2) + 4) + v, (D + z) + 16, 2, render.color(0, 0, 0, 255))
            render.circle_filled(((m + T / 2) + 4) + v, (D + z) + 16, 1, M:get_color())
        else
            render.text(s, (m - F / 2) + v, (D + O) + 12, 'FAKE LAG', M:get_color())
            render.circle_filled(((m - F / 2) - 4) + v, (D + O) + 16, 2, render.color(0, 0, 0, 255))
            render.circle_filled(((m - F / 2) - 4) + v, (D + O) + 16, 1, M:get_color())-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            render.circle_filled(((m + F / 2) + 4) + v, (D + O) + 16, 2, render.color(0, 0, 0, 255))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            render.circle_filled(((m + F / 2) + 4) + v, (D + O) + 16, 1, M:get_color())
            if hC[1] > 0 then add_y = add_y + 7 end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            hC[1] = yC(hC[1], 0, global_vars.frametime * 11)
        end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        render.text(s, (m - R / 2) + v, (D + h) + 31, 'dt defensive', H)
        render.circle((((m - R / 2) + v) + R) + 5, (D + h) + -4443131, 17, H, 2, 1, l)
    end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
end
local bC = { 'Need to buy icebreak.lua ', 'buy icebreak.lua for destroy', 'Got raped dog', '˜”°• sit poor nc by icebreak.lua best AA World. •°”', 'nice iq', '1', 'ez owned by icebreak.lua', 'refund spirtware',
'get fatal with icebreak.lua', 'icebreak.lua ♛ Never Lose Again', 'I understand you have neverlose but resolver when?' , 'icebreak.lua after update is god mode',  'You have fatality and you did not take why you do not buy icebreak.lua?', 
'ez, resolver issue',}-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
function on_player_death(k)
    if NC:get_bool() then-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        local j = engine.get_local_player()
        local s = engine.get_player_for_user_id(k:get_int('attacker'))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        local c = engine.get_player_for_user_id(k:get_int('userid'))
        local N = engine.get_player_info(c)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        if s == j and c ~= j then engine.exec('say ' .. (bC[utils.random_int(1, #bC)] .. '')) end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    else-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local uC = 0
local EC = { 'b', 'bl', 'bla', 'blac', 'black ', 'black', 'black', 'icebreak', 'icebreak.lu', 'icebreak.lua', 'icebreak.lua', 'icebreak.lua', 'icebreak.lua|', 'icebreak.lua|',
'icebreak.|', 'b', '|', 'bl', 'bla', 'blac', 'black', 'black', 'black' }-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local nC = { '☘', '☘ L', '☘ Lu', '☘ Luc', '☘ Luck', '☘ Lucky', '☘ LuckyC', '☘ LuckyCh', '☘ LuckyChar', '☘ LuckyCharm', '☘ LuckyCharms', '☘ LuckyCharm', '☘ LuckyChar', '☘ LuckyCha', '☘ LuckyCh ', '☘ LuckyC',
'Lucky ☘', 'Luck ☘', ' Luc ☘', 'Lu ☘', 'L ☘', '☘' }-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local iC = { '⌛ p', '⌛ pr', '⌛ pri', '⌛ prim', '⌛ primo', '⌛ primor', '⌛ primord', '⌛ primordi', '⌛ primordia', '⌛ primordia', '⌛ primordial', '⌛ primordial.', '⌛ primordial.', '⌛ rimordial.d', '⌛ imordial.de',
'⌛ mordial.dev', '⌛ ordial.dev', '⌛ rdial.dev', '⌛ dial.dev', '⌛ ial.dev', '⌛ al.dev', '⌛ l.dev', '⌛ .dev', '⌛ dev', '⌛ ev', '⌛ v',  '⌛'}-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local zC = { '〄', 'R>|〄', 'RA>|〄', 'R4W>|〄', 'RAWЭ>|〄', 'R4W3T>|〄', 'RAWΣTR>|〄', 'Я4WETRI>|〄', 'RAWETRIP>|〄', 'RAWETRIP<|〄', 'R4WETRI<|〄', 'RAWΣTR<|〄', 'R4W3T<|〄', 'RAWЭ<|〄', 'R4W<|〄', 'RA<|〄', 'R<|〄', '〄'}
local tC = { 'onetap' }-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local oC = { 'g', 'ga', 'gam', 'game', 'games', 'games', 'gamese', ' gamesen', 'gamesens', 'gamesense', 'amesense', 'mesense', 'esense', 'sense', 'ense', 'nse', 'se', 'e', ''}
local bC = { 'E', 'EZ', 'EZf', 'EZfr', 'EZfra', 'EZfrag', 'EZfrags', 'EZfrag', 'EZfra', 'EZfr', 'EZf', 'EZ', 'E', '' }-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local kC = { ' ', ' | ', ' |\\ ', ' |\\| ', ' N ', ' N3 ', ' Ne ', ' Ne\\ ', ' Ne\\/ ', ' Nev ', ' Nev3 ', ' Neve ', ' Neve| ', ' Neve|2 ', ' Never|_ ', ' Neverl ', ' Neverl0 ', ' Neverlo ', ' Neverlo5 ',
 ' Neverlos ', ' Neverlos3 ', ' Neverlose ', ' Neverlose. ', ' Neverlose.< ', ' Neverlose.c< ', ' Neverlose.cc ', ' Neverlose.cc ', ' Neverlose.cc ', ' Neverlose.c< ', ' Neverlose.< ', ' Neverlose. ', ' Neverlose '-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
 , ' Neverlos3 ', ' Neverlos ', ' Neverlo5 ', ' Neverlo ', ' Neverl0 ', ' Neverl ', ' Never|_ ', ' Never|2 ', ' Neve|2 ', ' Neve| ', ' Neve ', ' Nev3 ', ' Ne\\/ ', ' Ne\\ ', ' Ne ', ' N3 ', ' |\\| ', ' |\\ ', ' | ', ' ', '' }-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local rC = { 'e', 'ev', 'ev', 'ev0', 'ev0l', 'ev0lv', 'ev0lve', 'ev0lve.', 'ev0lve.x', 'ev0lve.xy', 'ev0lve.xyz', 'v0lve.xyz', '0lve.xyz', 'lve.xyz', 've.xyz', 'e.xyz', '.xyz', 'xyz', 'yz', 'z', '' }-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local lC = { 'pandora',}
function clantagfc()-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    local k = DC:get_int()-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    if mC:get_bool() then
        local j = gui.get_config_item('misc>various>clan tag')-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        local s = math.floor(global_vars.realtime * 1.8)
        if uC ~= s then-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            if k == 0 then utils.set_clan_tag(EC[s % #EC + 1]) end
            if k == 1 then utils.set_clan_tag(nC[s % #nC + 1]) end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            if k == 2 then utils.set_clan_tag(iC[s % #iC + 1]) end
            if k == 3 then utils.set_clan_tag(zC[s % #zC + 1]) end
            if k == 4 then utils.set_clan_tag(tC[s % #tC + 1]) end
            if k == 5 then utils.set_clan_tag(oC[s % #oC + 1]) end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            if k == 6 then utils.set_clan_tag(bC[s % #bC + 1]) end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            if k == 7 then utils.set_clan_tag(kC[s % #kC + 1]) end
            if k == 8 then utils.set_clan_tag(rC[s % #rC + 1]) end
            if k == 9 then utils.set_clan_tag(lC[s % #lC + 1]) end
            uC = s-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
            j:set_bool(false)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        end
    end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
end
local xC = cvar.r_aspectratio
local CC = xC:get_float()-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
local function gC(k)
    local j, s = render.get_screen_size()-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    local c = (j * k) / s
    if k == 1 then c = 0 end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    xC:set_float(c)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
end-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
function aspect_ratio2()
    if HC:get_bool() then
        local k = vC:get_int() * .01-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        k = 2 - k
        gC(k)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    end
end
function checkingmisc()-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    local k = l:get_int()
    gui.set_visible(v .. 'fps up', k == 4)
    gui.set_visible(v .. 'killsay', k == 4)
    gui.set_visible(v .. 'clantag', k == 4)
    gui.set_visible(v .. 'clantag Type', k == 4 and mC:get_bool() == true)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    gui.set_visible(v .. 'aspect Ratio', k == 4)
    gui.set_visible(v .. 'aspect Value', k == 4 and HC:get_bool() == true)
end
function fps_boost()-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    if cC:get_bool() then
        cvar.cl_disablefreezecam:set_float(1)
        cvar.cl_disablehtmlmotd:set_float(1)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        cvar.r_dynamic:set_float(0)
        cvar.r_3dsky:set_float(0)
        cvar.r_shadows:set_float(0)
        cvar.cl_csm_static_prop_shadows:set_float(0)
        cvar.cl_csm_world_shadows:set_float(0)
        cvar.cl_foot_contact_shadows:set_float(0)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        cvar.cl_csm_viewmodel_shadows:set_float(0)
        cvar.cl_csm_rope_shadows:set_float(0)
        cvar.cl_csm_sprite_shadows:set_float(0)
        cvar.cl_freezecampanel_position_dynamic:set_float(0)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        cvar.cl_freezecameffects_showholiday:set_float(0)
        cvar.cl_showhelp:set_float(0)
        cvar.cl_autohelp:set_float(0)
        cvar.mat_postprocess_enable:set_float(0)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        cvar.fog_enable_water_fog:set_float(0)
        cvar.gameinstructor_enable:set_float(0)
        cvar.cl_csm_world_shadows_in_viewmodelcascade:set_float(0)
        cvar.cl_disable_ragdolls:set_float(0)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    end
end
local oC = {}
oC.import = function(j)-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
    local s = function()
        local s = j == nil and N(k.get()) or j
        local c = m(s, '|')
        HC:set_bool(D(c[1]))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        QU:set_bool(D(c[2]))
        S:set_bool(D(c[3]))
        q:set_int(tonumber(c[4]))
        L:set_int(tonumber(c[5]))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        I:set_bool(D(c[6]))
        K:set_bool(D(c[7]))
        X:set_int(tonumber(c[8]))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        Z:set_int(tonumber(c[9]))
        Q:set_bool(D(c[10]))
        W:set_bool(D(c[11]))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        f:set_int(tonumber(c[12]))
        A:set_int(tonumber(c[13]))
        B:set_bool(D(c[14]))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        P:set_bool(D(c[15]))
        d:set_int(tonumber(c[16]))
        t:set_int(tonumber(c[17]))
        V:set_bool(D(c[18]))
        e:set_bool(D(c[19]))
        p:set_int(tonumber(c[20]))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        G:set_int(tonumber(c[21]))
        J:set_bool(D(c[22]))
        i:set_bool(D(c[23]))
        kU:set_int(tonumber(c[24]))
        jU:set_int(tonumber(c[25]))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        sU:set_bool(D(c[26]))
        cU:set_bool(D(c[27]))
        NU:set_int(tonumber(c[28]))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        DU:set_int(tonumber(c[29]))
        mU:set_bool(D(c[30]))
        HU:set_bool(D(c[31]))
        vU:set_int(tonumber(c[32]))
        lU:set_int(tonumber(c[33]))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        UU:set_bool(D(c[34]))
        YU:set_bool(D(c[35]))
        MU:set_int(tonumber(c[36]))
        OU:set_int(tonumber(c[37]))
        FU:set_bool(D(c[38]))
        TU:set_bool(D(c[39]))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        zU:set_int(tonumber(c[40]))
        RU:set_int(tonumber(c[41]))
        hU:set_bool(D(c[42]))
        C:set_bool(D(c[43]))
        o:set_int(tonumber(c[44]))
        a:set_int(tonumber(c[45]))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        w:set_int(tonumber(c[46]))
        n:set_bool(D(c[47]))
        x:set_bool(D(c[48]))-- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        h:set_bool(D(c[49]))
        z:set_bool(D(c[51])) -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  -- Hanz#9003/soypik#6969  
        y:set_bool(D(c[52]))
        T:set_bool(D(c[54]))
        print('-- loaded config')
    end
    local c, H = pcall(s)
    if not c then
        print('-- config expired or not working')
        return
    end
end
oC.export = function()
    local j = { tostring(HC:get_bool()) .. '|', tostring(QU:get_bool()) .. '|', tostring(S:get_bool()) .. '|', tostring(q:get_int()) .. '|', tostring(L:get_int()) .. '|',
    tostring(I:get_bool()) .. '|', tostring(K:get_bool()) .. '|', tostring(X:get_int()) .. '|', tostring(Z:get_int()) .. '|', tostring(Q:get_bool()) .. '|', tostring(W:get_bool()) .. '|',
    tostring(f:get_int()) .. '|', tostring(A:get_int()) .. '|', tostring(B:get_bool()) .. '|', tostring(P:get_bool()) .. '|', tostring(d:get_int()) .. '|', tostring(t:get_int()) .. '|',
    tostring(V:get_bool()) .. '|', tostring(e:get_bool()) .. '|', tostring(p:get_int()) .. '|', tostring(G:get_int()) .. '|', tostring(J:get_bool()) .. '|', tostring(i:get_bool()) .. '|',
    tostring(kU:get_int()) .. '|', tostring(jU:get_int()) .. '|', tostring(sU:get_bool()) .. '|', tostring(cU:get_bool()) .. '|', tostring(NU:get_int()) .. '|', tostring(DU:get_int()) .. '|',
    tostring(mU:get_bool()) .. '|', tostring(HU:get_bool()) .. '|', tostring(vU:get_int()) .. '|', tostring(lU:get_int()) .. '|', tostring(UU:get_bool()) .. '|', tostring(YU:get_bool()) .. '|',
    tostring(MU:get_int()) .. '|', tostring(OU:get_int()) .. '|', tostring(FU:get_bool()) .. '|', tostring(TU:get_bool()) .. '|', tostring(zU:get_int()) .. '|', tostring(RU:get_int()) .. '|',
    tostring(hU:get_bool()) .. '|', tostring(C:get_bool()) .. '|', tostring(o:get_int()) .. '|', tostring(a:get_int()) .. '|', tostring(w:get_int()) .. '|', tostring(n:get_bool()) .. '|',
    tostring(x:get_bool()) .. '|', tostring(h:get_bool()) .. '|', tostring(z:get_bool()) .. '|', tostring(y:get_bool()) .. '|', tostring(T:get_bool()) .. '|' }
    k.set(c(table.concat(j)))
    print('-- copied in the clipboard')
end

local aC = gui.add_button('Import Config', v, function() oC.import() end)
local wC = gui.add_button('Export Config', v, function() oC.export() end)
function on_paint()
    checkinghome()
    checkingconfigs()
    checkingrage()
    checkingantiaim()
    checkingwidgets()
    checkingmisc()
    dormantaimbot()
    if not engine.is_in_game() then return end
    watermark()
    skeetind()
    gui_controller()
    on_keybinds()
    clantagfc()
    aspect_ratio2()
    fps_boost()
    indicatorsfunc()
    indicators2func()
    aa_presetstwo()
end
function on_create_move()
    fl()
    aa_presets()
    antiaimbuilder()
end
ffi.cdef [[ 
    typedef struct{
     void*   handle;
     char    name[260];
     int     load_flags;
     int     server_count;
     int     type;
     int     flags;
     float   mins[3];
     float   maxs[3];
     float   radius;
     char    pad[0x1C];
 } model_t;
 typedef struct {void** this;}aclass;
 typedef void*(__thiscall* get_client_entity_t)(void*, int);
 typedef void(__thiscall* find_or_load_model_fn_t)(void*, const char*);
 typedef const int(__thiscall* get_model_index_fn_t)(void*, const char*);
 typedef const int(__thiscall* add_string_fn_t)(void*, bool, const char*, int, const void*);
 typedef void*(__thiscall* find_table_t)(void*, const char*);
 typedef void(__thiscall* full_update_t)();
 typedef int(__thiscall* get_player_idx_t)();
 typedef void*(__thiscall* get_client_networkable_t)(void*, int);
 typedef void(__thiscall* pre_data_update_t)(void*, int);
 typedef int(__thiscall* get_model_index_t)(void*, const char*);
 typedef const model_t(__thiscall* find_or_load_model_t)(void*, const char*);
 typedef int(__thiscall* add_string_t)(void*, bool, const char*, int, const void*);
 typedef void(__thiscall* set_model_index_t)(void*, int);
 typedef int(__thiscall* precache_model_t)(void*, const char*, bool);
]]
local a = ffi.cast(ffi.typeof("void***"), utils.find_interface("client.dll", "VClientEntityList003")) or
    error("rawientitylist is nil", 2)
local b = ffi.cast("get_client_entity_t", a[0][3]) or error("get_client_entity is nil", 2)
local c = ffi.cast(ffi.typeof("void***"), utils.find_interface("engine.dll", "VModelInfoClient004")) or
    error("model info is nil", 2)
local d = ffi.cast("get_model_index_fn_t", c[0][2]) or error("Getmodelindex is nil", 2)
local e = ffi.cast("find_or_load_model_fn_t", c[0][43]) or error("findmodel is nil", 2)
local f = ffi.cast(ffi.typeof("void***"), utils.find_interface("engine.dll", "VEngineClientStringTable001")) or
    error("clientstring is nil", 2)
local g = ffi.cast("find_table_t", f[0][3]) or error("find table is nil", 2)
function p(pa)
    local a_p = ffi.cast(ffi.typeof("void***"), g(f, "modelprecache"))
    if a_p ~= nil then
        e(c, pa)
        local ac = ffi.cast("add_string_fn_t", a_p[0][8]) or error("ac nil", 2)
        local acs = ac(a_p, false, pa, -1, nil)
        if acs == -1 then print("failed")
            return false
        end
    end
    return true
end

function smi(en, i)
    local rw = b(a, en)
    if rw then
        local gc = ffi.cast(ffi.typeof("void***"), rw)
        local se = ffi.cast("set_model_index_t", gc[0][75])
        if se == nil then
            error("smi is nil")
        end
        se(gc, i)
    end
end

function cm(ent, md)
    if md:len() > 5 then
        if p(md) == false then
            error("invalid model", 2)
        end
        local i = d(c, md)
        if i == -1 then
            return
        end
        smi(ent, i)
    end
end


-------------------------------------EDIT THAT ONLY------------------------------------------

local path = {
    --path
    "models/player/custom_player/eminem/gta_sa/swmotr5.mdl",
    "models/player/custom_player/eminem/gta_sa/ballas1.mdl",
    "models/player/custom_player/eminem/gta_sa/bmybar.mdl",
    "models/player/custom_player/eminem/gta_sa/fam1.mdl",
    "models/player/custom_player/eminem/gta_sa/somyst.mdl",
    "models/player/custom_player/eminem/gta_sa/vwfypro.mdl",
    "models/player/custom_player/eminem/gta_sa/wuzimu.mdl",
}

local menu = {}
menu.add = {
    en = gui.add_checkbox("Enabled", "lua>tab a"),
    path = gui.add_combo("Player Model Changer", "lua>tab a", path),
}

-------------------------------------EDIT THAT ONLY------------------------------------------

function on_frame_stage_notify(stage, pre_original)
    if stage == csgo.frame_render_start then
        local player = entities.get_entity(engine.get_local_player())
        if player == nil then return end
        if player:is_alive() then
            if menu.add.en:get_bool() then
                cm(player:get_index(), path[menu.add.path:get_int() + 1])
            end
        end
    end
end
