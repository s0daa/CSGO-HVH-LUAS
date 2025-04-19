--[[

█▀▀ █░░█ █▀▀█ █▀▀█ █░█ ░ █░░ █░░█ █▀▀█ 
▀▀█ █▀▀█ █▄▄█ █▄▄▀ █▀▄ ▄ █░░ █░░█ █▄▄█ 
▀▀▀ ▀░░▀ ▀░░▀ ▀░▀▀ ▀░▀   ▀▀▀ ░▀▀▀ ▀░░▀ 

█▀▀▄ █▀▀ ▀▀█▀▀ █▀▀█ 
█▀▀▄ █▀▀ ░░█░░ █▄▄█ 
▀▀▀░ ▀▀▀ ░░▀░░ ▀░░▀

 Thank you for buying my lua! - bUmmy

]]--

local k = require('clipboard')
local j = { anim_list = {} }
j.math_clamp = function(k, j, s) return math.min(s, math.max(j, k)) end
j.math_lerp = function(k, s, c)
    local N = j.math_clamp(.02, 0, 1)
    if type(k) == 'userdata' then
        r, g, b, k = k.r, k.g, k.b, k.a
        e_r, e_g, e_b, e_a = s.r, s.g, s.b, s.a
        r = j.math_lerp(r, e_r, N)
        g = j.math_lerp(g, e_g, N)
        b = j.math_lerp(b, e_b, N)
        k = j.math_lerp(k, e_a, N)
        return color(r, g, b, k)
    end
    local m = s - k
    m = m * N
    m = m + k
    if s == 0 and (m < .01 and m > -0.01) then
        m = 0
    elseif s == 1 and (m < 1.01 and m > .99) then
        m = 1
    end
    return m
end
j.vector_lerp = function(k, j, s) return k + (j - k) * s end
j.anim_new = function(k, s, c, N)
    if not j.anim_list[k] then
        j.anim_list[k] = {}
        j.anim_list[k].color = render.color(0, 0, 0, 0)
        j.anim_list[k].number = 0
        j.anim_list[k].call_frame = true
    end
    if c == nil then j.anim_list[k].call_frame = true end
    if N == nil then N = .1 end
    if type(s) == 'userdata' then
        lerp = j.math_lerp(j.anim_list[k].color, s, N)
        j.anim_list[k].color = lerp
        return lerp
    end
    lerp = j.math_lerp(j.anim_list[k].number, s, N)
    j.anim_list[k].number = lerp
    return lerp
end
local s = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function c(k)
    return (k:gsub('.', function(k)
        local j, s = '', k:byte()
        for k = 8, 1, -1 do j = j .. (s % 2 ^ k - s % 2 ^ (k - 1) > 0 and '1' or '0') end
        return j
    end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(k)
        if #k < 6 then return '' end
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
        return j
    end)):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(k)
        if #k ~= 8 then return '' end
        local j = 0
        for s = 1, 8, 1 do j = j + (k:sub(s, s) == '1' and 2 ^ (8 - s) or 0) end
        return string.char(j)
    end)
end
local function m(k, j)
    local s = {}
    for k in string.gmatch(k, '([^' .. (j .. ']+)')) do s[#s + 1] = string.gsub(k, '\n', ' ') end
    return s
end
local function D(k)
    if k == 'true' or k == 'false' then
        return k == 'true'
    else
        return k
    end
end
local H = 'lua>tab a>'
local v = 'lua>tab b>'
local l = gui.add_listbox('shark.gg', H, 7, true, { '                  ~~  Home  ~~         ', '                ~~  Rage Bot  ~~         ',  '                 ~~ Anti Aim ~~          ', '                     ~~  UI  ~~         ', '                    ~~  Misc  ~~         ', '                ~~ Lua Config ~~          ', '                                          ','             ~~ Made by bUmmy. ~~          '})
local U = gui.add_textbox('Username text', v)
local Y = gui.add_checkbox('Main Theme', v)
local M = gui.add_colorpicker(v .. 'Main Theme', false)
local F = gui.add_button('Hub Discord', v, function()
    utils.print_console('\n[shark.gg] ', M:get_color())
    utils.print_console('https://discord.gg/FkUmMsxMeg. Copied link to clipboard.', render.color('#ffffff'))
    k.set('https://discord.gg/FkUmMsxMeg')
end)
--local O = gui.add_button('shark.gg Coder', v, function()
--    utils.print_console('\n[shark.gg] ', M:get_color())
--    utils.print_console('xLéo.#4449', render.color('#ffffff'))                   
--end)


local AA = gui.add_slider("Roll AA", "lua>Tab B", -200, 199, 0)
cfg = gui.get_config_item("rage>Anti-Aim>Desync>Lean Amount")
function on_paint_traverse()
local lean = AA:get_int()
cfg:set_int(lean)
end


function checkinghome()
    local k = l:get_int()
    gui.set_visible(v .. 'Username text', k == 0)
    gui.set_visible(v .. 'Main Theme', k == 0)
    gui.set_visible(v .. 'Hub Discord', k == 0)
--    gui.set_visible(v .. 'shark.gg Coder', k == 0)
end
function checkingconfigs()
    local k = l:get_int()
    gui.set_visible(v .. 'Import Config', k == 5)
    gui.set_visible(v .. 'Export Config', k == 5)
end
local T = gui.add_checkbox('Dormant Aimbot', v)
gui.add_keybind(v .. 'Dormant Aimbot')
local z = gui.add_checkbox('Roll Resolver', v)
gui.add_keybind(v .. 'Roll Resolver')
local R = gui.get_config_item('Rage>Anti-Aim>Desync>Leg Slide')
local h = gui.add_checkbox('Legbreaker', v)
local y = gui.add_checkbox('In console logs', v)
function dormantaimbot()
    local k = gui.get_config_item('rage>aimbot>aimbot>target dormant')
    if not engine.is_in_game() then return end
    if T:get_bool() then
        k:set_bool(true)
    else
        k:set_bool(false)
    end
end
function rollresolve()
    local k = gui.get_config_item('rage>aimbot>aimbot>resolver mode')
    if not engine.is_in_game() then return end
    if z:get_bool() then
        k:set_int(0)
    else
        k:set_int(1)
    end
end
local u = utils.new_timer(31, function() if h:get_bool() then R:set_int(1) end end)
u:start()
local E = utils.new_timer(50, function() if h:get_bool() then R:set_int(2) end end)
E:start()
function on_shot_registered(k)
    if not y:get_bool() then return end
    if k.manual then return end
    utils.print_console('\n[shark.gg] ', M:get_color())
    local j = entities.get_entity(k.target)
    local s = j:get_player_info()
    utils.print_console(string.format('Shot at: %s (hc: %i) (ed: %i) (ad: %i) | shot result: %s | (BT: %i  SP: %s  Roll SP: %s) | Mismatched: %s\n', s.name, k.hitchance, k.client_damage, k.server_damage,
        k.result, k.backtrack, k.secure, k.very_secure, k.client_hitgroup ~= k.server_hitgroup), render.color('#ffffff'))
end
function checkingrage()
    local k = l:get_int()
    gui.set_visible(v .. 'Dormant Aimbot', k == 1)
    gui.set_visible(v .. 'Roll Resolver', k == 1)
    gui.set_visible(v .. 'In console logs', k == 1)
end
local n = gui.add_checkbox('Anti-Aim Inverter', v)
gui.add_keybind(v .. 'Anti-Aim Inverter')
local x = gui.add_checkbox('Fake Flick', v)
gui.add_keybind(v .. 'Fake Flick')
local C = gui.add_checkbox('Enabled AA', v)
local o = gui.add_combo('Choose AntiAim', v, { 'AntiAim Presets', 'AntiAim Builder' })
local a = gui.add_combo('Choose Presets', v, { 'Default', 'Community, 5x5', 'Hybrid-AA', '2x2, 1x1', 'Developer' })
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
local yU = false
local bU = gui.get_config_item('Rage>Anti-Aim>Desync>Fake Amount')
function Inverting()
    if n:get_bool() then
        yU = true
        if yU == true then
            bU:set_int(bU:get_int() * -1)
            n:set_bool(false)
            yU = false
        end
    end
    if not n:get_bool() then yU = false end
end
local uU = gui.get_config_item('Rage>Anti-Aim>Angles>Add')
local EU = gui.get_config_item('Rage>Anti-Aim>Desync>Fake Amount')
local nU = EU:get_int() >= 0
function fl()
    if x:get_bool() then
        if global_vars.tickcount % 19 == 13 and EU:get_int() >= 0 then
            uU:set_int(95)
        else
            if global_vars.tickcount % 19 == 13 and 0 >= EU:get_int() then uU:set_int(-95) end
        end
    end
end
local xU = gui.get_config_item('rage>anti-aim>angles>jitter')
local CU = gui.get_config_item('rage>anti-aim>angles>jitter range')
local gU = gui.get_config_item('rage>anti-aim>desync>fake')
local oU = gui.get_config_item('rage>anti-aim>desync>fake amount')
local aU = gui.get_config_item('rage>anti-aim>desync>compensate angle')
local wU = gui.get_config_item('rage>anti-aim>desync>freestand fake')
local SU = gui.get_config_item('rage>anti-aim>desync>flip fake with jitter')
local qU = gui.get_config_item('rage>anti-aim>angles>yaw add')
local IU = gui.get_config_item('rage>anti-aim>angles>add')
local rU = gui.get_config_item('misc>movement>slide')
function aa_presets()
    local k = C:get_bool()
    if k == true then
        if o:get_int() == 0 then
            local k = entities.get_entity(engine.get_local_player())
            local j = k:get_prop('m_fFlags')
            local s = k:get_prop('m_hGroundEntity') == -1
            local c = math.floor(k:get_prop('m_vecVelocity[0]'))
            local N = math.floor(k:get_prop('m_vecVelocity[1]'))
            local m = math.sqrt(c ^ 2 + N ^ 2)
            local D = input.is_key_down(17)
            if a:get_int() == 1 then
                if m > 2 and (not s and not D) then
                    xU:set_bool(true)
                    CU:set_int(13)
                    gU:set_bool(true)
                    oU:set_int(65)
                    aU:set_int(83)
                    wU:set_int(1)
                    qU:set_bool(true)
                    IU:set_int(-5)
                elseif m <= 2 and j == 257 then
                    xU:set_bool(true)
                    CU:set_int(6)
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
                        CU:set_int(3)
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
            end
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
            local m = math.sqrt(c ^ 2 + N ^ 2)
            local D = input.is_key_down(17)
            if a:get_int() == 4 then
                if m > 2 and (not s and not D) then
                    xU:set_bool(true)
                    CU:set_int(36)
                    gU:set_bool(true)
                    oU:set_int(80)
                    aU:set_int(100)
                    wU:set_int(1)
                    qU:set_bool(true)
                    IU:set_int(-23)
                elseif m <= 2 and j == 257 then
                    xU:set_bool(true)
                    CU:set_int(15)
                    gU:set_bool(true)
                    oU:set_int(75)
                    aU:set_int(100)
                    wU:set_int(1)
                    qU:set_bool(true)
                    IU:set_int(-5)
                elseif D then
                    xU:set_bool(true)
                    CU:set_int(24)
                    gU:set_bool(true)
                    oU:set_int(100)
                    aU:set_int(72)
                    wU:set_int(1)
                    qU:set_bool(true)
                    IU:set_int(-8)
                elseif s and j ~= 262 then
                    xU:set_bool(true)
                    CU:set_int(15)
                    gU:set_bool(true)
                    oU:set_int(41)
                    aU:set_int(64)
                    wU:set_int(1)
                    qU:set_bool(true)
                    IU:set_int(16)
                end
            end
        end
    end
end
function get_cond()
    local k = entities.get_entity(engine.get_local_player())
    local j = k:get_prop('m_fFlags')
    local s = k:get_prop('m_hGroundEntity') == -1
    local c = math.floor(k:get_prop('m_vecVelocity[0]'))
    local N = math.floor(k:get_prop('m_vecVelocity[1]'))
    local m = math.sqrt(c ^ 2 + N ^ 2)
    local D = input.is_key_down(17)
    if m > 2 and not s then
        return 'MOVE'
    elseif m <= 2 and j == 257 then
        return 'STAND'
    elseif s and j ~= 262 then
        return 'AIR'
    else
        return 'CROUCH'
    end
end
function antiaimbuilder()
    local k = C:get_bool()
    if k == true then
        if o:get_int() == 1 then
            local k = entities.get_entity(engine.get_local_player())
            local j = k:get_prop('m_fFlags')
            local s = k:get_prop('m_hGroundEntity') == -1
            local c = math.floor(k:get_prop('m_vecVelocity[0]'))
            local N = math.floor(k:get_prop('m_vecVelocity[1]'))
            local m = math.sqrt(c ^ 2 + N ^ 2)
            local D = input.is_key_down(17)
            if m > 2 and (not s and not D) then
                xU:set_bool(W:get_bool())
                CU:set_int(f:get_int())
                gU:set_bool(P:get_bool())
                oU:set_int(d:get_int())
                aU:set_int(t:get_int())
                qU:set_bool(B:get_bool())
                IU:set_int(A:get_int())
                SU:set_bool(V:get_bool())
            elseif m <= 2 and j == 257 then
                xU:set_bool(S:get_bool())
                CU:set_int(q:get_int())
                gU:set_bool(K:get_bool())
                oU:set_int(X:get_int())
                aU:set_int(Z:get_int())
                qU:set_bool(I:get_bool())
                IU:set_int(L:get_int())
                SU:set_bool(Q:get_bool())
            elseif D then
                xU:set_bool(cU:get_bool())
                CU:set_int(NU:get_int())
                gU:set_bool(HU:get_bool())
                oU:set_int(vU:get_int())
                aU:set_int(lU:get_int())
                qU:set_bool(mU:get_bool())
                IU:set_int(DU:get_int())
                SU:set_bool(UU:get_bool())
            elseif s then
                xU:set_bool(YU:get_bool())
                CU:set_int(MU:get_int())
                gU:set_bool(TU:get_bool())
                oU:set_int(zU:get_int())
                aU:set_int(RU:get_int())
                qU:set_bool(FU:get_bool())
                IU:set_int(OU:get_int())
                SU:set_bool(hU:get_bool())
            end
        end
    end
end
function checkingantiaim()
    local k = l:get_int()
    local j = C:get_bool()
    local s = o:get_int()
    local c = w:get_int()
    gui.set_visible(v .. 'Anti-Aim Inverter', k == 2)
    gui.set_visible(v .. 'Fake Flick', k == 2)
    gui.set_visible(v .. 'Legbreaker', k == 2)
    gui.set_visible(v .. 'Enabled AA', k == 2)
    gui.set_visible(v .. 'Choose AntiAim', k == 2 and j == true)
    gui.set_visible(v .. 'Choose Presets', k == 2 and (j == true and s == 0))
    gui.set_visible(v .. 'Choose AntiAim Condition:', k == 2 and (j == true and s == 1))
    gui.set_visible(v .. '[S] Jitter', k == 2 and (j == true and (s == 1 and c == 1)))
    gui.set_visible(v .. '[S] Jitter Range', k == 2 and (j == true and (s == 1 and c == 1)))
    gui.set_visible(v .. '[S] Yaw Toggle', k == 2 and (j == true and (s == 1 and c == 1)))
    gui.set_visible(v .. '[S] Yaw Range', k == 2 and (j == true and (s == 1 and c == 1)))
    gui.set_visible(v .. '[S] Fake Toggle', k == 2 and (j == true and (s == 1 and c == 1)))
    gui.set_visible(v .. '[S] Fake Amount', k == 2 and (j == true and (s == 1 and c == 1)))
    gui.set_visible(v .. '[S] Compensate Angle', k == 2 and (j == true and (s == 1 and c == 1)))
    gui.set_visible(v .. '[S] Flip Fake With Jitter', k == 2 and (j == true and (s == 1 and c == 1)))
    gui.set_visible(v .. '[M] Jitter', k == 2 and (j == true and (s == 1 and c == 2)))
    gui.set_visible(v .. '[M] Jitter Range', k == 2 and (j == true and (s == 1 and c == 2)))
    gui.set_visible(v .. '[M] Yaw Toggle', k == 2 and (j == true and (s == 1 and c == 2)))
    gui.set_visible(v .. '[M] Yaw Range', k == 2 and (j == true and (s == 1 and c == 2)))
    gui.set_visible(v .. '[M] Fake Toggle', k == 2 and (j == true and (s == 1 and c == 2)))
    gui.set_visible(v .. '[M] Fake Amount', k == 2 and (j == true and (s == 1 and c == 2)))
    gui.set_visible(v .. '[M] Compensate Angle', k == 2 and (j == true and (s == 1 and c == 2)))
    gui.set_visible(v .. '[M] Flip Fake With Jitter', k == 2 and (j == true and (s == 1 and c == 2)))
    gui.set_visible(v .. '[SW] Jitter', k == 2 and (j == true and (s == 1 and c == 3)))
    gui.set_visible(v .. '[SW] Jitter Range', k == 2 and (j == true and (s == 1 and c == 3)))
    gui.set_visible(v .. '[SW] Yaw Toggle', k == 2 and (j == true and (s == 1 and c == 3)))
    gui.set_visible(v .. '[SW] Yaw Range', k == 2 and (j == true and (s == 1 and c == 3)))
    gui.set_visible(v .. '[SW] Fake Toggle', k == 2 and (j == true and (s == 1 and c == 3)))
    gui.set_visible(v .. '[SW] Fake Amount', k == 2 and (j == true and (s == 1 and c == 3)))
    gui.set_visible(v .. '[SW] Compensate Angle', k == 2 and (j == true and (s == 1 and c == 3)))
    gui.set_visible(v .. '[SW] Flip Fake With Jitter', k == 2 and (j == true and (s == 1 and c == 3)))
    gui.set_visible(v .. '[C] Jitter', k == 2 and (j == true and (s == 1 and c == 4)))
    gui.set_visible(v .. '[C] Jitter Range', k == 2 and (j == true and (s == 1 and c == 4)))
    gui.set_visible(v .. '[C] Yaw Toggle', k == 2 and (j == true and (s == 1 and c == 4)))
    gui.set_visible(v .. '[C] Yaw Range', k == 2 and (j == true and (s == 1 and c == 4)))
    gui.set_visible(v .. '[C] Fake Toggle', k == 2 and (j == true and (s == 1 and c == 4)))
    gui.set_visible(v .. '[C] Fake Amount', k == 2 and (j == true and (s == 1 and c == 4)))
    gui.set_visible(v .. '[C] Compensate Angle', k == 2 and (j == true and (s == 1 and c == 4)))
    gui.set_visible(v .. '[C] Flip Fake With Jitter', k == 2 and (j == true and (s == 1 and c == 4)))
    gui.set_visible(v .. '[A] Jitter', k == 2 and (j == true and (s == 1 and c == 5)))
    gui.set_visible(v .. '[A] Jitter Range', k == 2 and (j == true and (s == 1 and c == 5)))
    gui.set_visible(v .. '[A] Yaw Toggle', k == 2 and (j == true and (s == 1 and c == 5)))
    gui.set_visible(v .. '[A] Yaw Range', k == 2 and (j == true and (s == 1 and c == 5)))
    gui.set_visible(v .. '[A] Fake Toggle', k == 2 and (j == true and (s == 1 and c == 5)))
    gui.set_visible(v .. '[A] Fake Amount', k == 2 and (j == true and (s == 1 and c == 5)))
    gui.set_visible(v .. '[A] Compensate Angle', k == 2 and (j == true and (s == 1 and c == 5)))
    gui.set_visible(v .. '[A] Flip Fake With Jitter', k == 2 and (j == true and (s == 1 and c == 5)))
end
local LU, KU, XU = gui.add_multi_combo('Visual Items', v, { 'Watermark', 'Keybinds', 'Info Tab', 'Slow Indicator' })
local ZU = gui.add_combo('UI | Type', v, { 'OLD', 'NEW' })
local QU = gui.add_checkbox('Indicators Under Crosshair', v)
local WU = gui.add_combo('Indicators Style', v, { 'shark.gg (Old)', 'shark.gg (New)' })
local fU = gui.add_checkbox('Skeet Indicators', v)
local BU = gui.add_combo('Info Panel | Flag', v, { 'Russia', 'Germany', 'Estonia', 'Romania', 'Reichsflagge' })
local AU = render.font_esp
function render.window(k, j, s, c, N, m, D, H)
    if ZU:get_int() == 0 then
        render.rect_filled(k, j, s, c, render.color(39, 39, 39, 255 * H))
        render.rect_filled(k + 1, j + 1, s - 1, c - 1, render.color(25, 25, 25, 255 * H))
    end
    if ZU:get_int() == 1 then
        render.rect_filled_rounded(k, j, s, c, render.color(0, 0, 0, 105 * H), 2, render.all)
        render.rect_filled(k, j, s, j + 1, render.color(N, m, D, 255 * H))
        render.rect_filled_multicolor(k - 1, j + 1, k, c, render.color(N, m, D, 255 * H), render.color(N, m, D, 255 * H), render.color(0, 0, 0, 0), render.color(0, 0, 0, 0))
        render.rect_filled_multicolor(s + 1, j + 1, s, c, render.color(N, m, D, 255 * H), render.color(N, m, D, 255 * H), render.color(0, 0, 0, 0), render.color(0, 0, 0, 0))
    end
end
function accumulate_fps() return math.ceil(1 / global_vars.frametime) end
function get_tick()
    if not engine.is_in_game() then return end
    return math.floor(1 / global_vars.interval_per_tick)
end
local PU, dU = render.get_screen_size()
function watermark()
    if LU:get_bool() then
        local k, j = render.get_text_size(AU, 'shark.gg')
        local s, c = render.get_text_size(AU, ' | ' .. (U:get_string() .. ' | beta build'))
        local N, m = render.get_text_size(AU, 'shark.gg | ' .. (U:get_string() .. ' | CLOSED BETA'))
        local D = 255
        render.window((PU / 2 - N / 2) - 4, dU - 21, (PU / 2 + N / 2) + 4, dU - 1, (M:get_color()).r, (M:get_color()).g, (M:get_color()).b, 1)
        for s = 1, 10, 1 do
            render.rect_filled_rounded((PU / 2 - N / 2) - s, (dU - 14) - s, ((PU / 2 - N / 2) + k) + s, ((dU - 14) + j / 2) + s,
                render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, (20 - 2 * s) * .35), 10)
        end
        render.text(AU, PU / 2 - N / 2, dU - 14, 'shark.gg', render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, 255))
        render.text(AU, (PU / 2 - N / 2) + k, dU - 14, ' | ' .. (U:get_string() .. ' | CLOSED BETA'), render.color(98, 98, 98, 255))
    end
end
local tU = { { text = 'AA', path = 'lua>tab b>skeet indicators' }, { text = 'FD', path = 'misc>movement>fake duck' }, { text = 'DT', path = 'rage>aimbot>aimbot>double tap' },
{ text = 'O-shot', path = 'rage>aimbot>aimbot>hide shot' }, { text = 'FS', path = 'rage>anti-aim>angles>freestand' }, { text = 'HS', path = 'rage>aimbot>aimbot>headshot only' },
{ text = 'Roll', path = 'rage>anti-aim>desync>ensure lean' }, { text = 'DA', path = 'rage>aimbot>aimbot>Target dormant' }, { text = 'AX', path = 'rage>aimbot>aimbot>Anti-exploit' }, { text = 'SHARK', path = 'lua>tab b>enabled aa' } }
local VU = function()
    local k = entities.get_entity(engine.get_local_player())
    local j = k:get_prop('m_vecVelocity[0]')
    local s = k:get_prop('m_vecVelocity[1]')
    return math.sqrt(j * j + s * s)
end
local eU = function()
    local k = {}
    for j, s in pairs(tU) do if (gui.get_config_item(s.path)):get_bool() then table.insert(k, s.text) end end
    return k
end
local pU = math.vec3(render.get_screen_size())
local JU = function(k, j, s) return math.floor(k + (j - k) * s) end
local GU = { 0, 0, 0, 0, 0 }
local iU = render.create_font('calibri.ttf', 23, render.font_flag_shadow)
function skeetind()
    if fU:get_bool() then
        local k = entities.get_entity(engine.get_local_player())
        if not k then return end
        add_y = 0
        if info.fatality.can_fastfire then
            GU[1] = JU(GU[1], 255, global_vars.frametime * 11)
            add_y = add_y + 7
        else
            if GU[1] > 0 then add_y = add_y + 7 end
            GU[1] = JU(GU[1], 0, global_vars.frametime * 11)
        end
        local s = j.anim_new('m_bIsScoped add dbbx2', info.fatality.can_fastfire and 1 or .01)
        local c = gui.get_config_item('rage>anti-aim>desync>lean amount')
        local N = (c:get_int() / 100) * 2
        local m = info.fatality.can_fastfire and render.color(255, 255, 255, GU[1]) or render.color(226, 54, 55, 255)
        for k, c in pairs(eU()) do
            local D = { x = 10, y = (pU.y / 2 + 98) + 35 * (k - 1) }
            local H = utils.random_int(15, 100) / 100
            local v = j.anim_new('aainverted1xq34', fU:get_bool() and utils.random_int(15, 100) / 100 or 0)
            local l = render.color(150, 200, 30)
            if c == 'AA' then
                l = render.color(85, 91, 194)
                render.circle(D.x + 50, D.y + 10, 5, render.color(0, 0, 0, 255), 3, 22, 1, 1)
                render.circle(D.x + 50, D.y + 10, 5, render.color(85, 91, 194, 255), 3, 12, H, 1)
            end
            if c == 'DT' then
                l = m
                render.circle(D.x + 44, D.y + 10, 5, render.color(0, 0, 0, 255), 3, 22, 1, 1)
                render.circle(D.x + 44, D.y + 10, 5, m, 3, 12, s, 1)
            end
            if c == 'O-shot' then if not info.fatality.can_onshot then l = render.color(125, 130, 209) end end
            if c == 'O-shot' then if not info.fatality.can_onshot then l = render.color(125, 130, 209) end end
            if c == 'Roll' then
                l = render.color(232, 113, 111)
                render.circle(D.x + 68, D.y + 10, 5, render.color(0, 0, 0, 255), 3, 22, 1, 1)
                render.circle(D.x + 68, D.y + 10, 5, render.color(232, 113, 111, 255), 3, 12, N, 1)
            end
            local U = math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255)
            if c == 'FW' then l = render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, U) end
            local Y = math.vec3(render.get_text_size(iU, c))
            for k = 1, 10, 1 do render.rect_filled_rounded((D.x + 4) - k, D.y - k, ((D.x + Y.x) + 8) + k, ((D.y + Y.y) - 3) + k, render.color(l.r, l.g, l.b, (20 - 2 * k) * .35), 10) end
            render.text(iU, D.x + 8, D.y, c, l)
        end
    end
end
function gui_controller()
    local k = 'shark.gg'
    local j = render.font_esp
    local s = U:get_string()
    local c, N = render.get_text_size(j, k)
    local m = 'user: ' .. (s .. '')
    local D, H = render.get_text_size(j, m)
    local v, l = render.get_text_size(j, ' [beta]')
    local Y = BU:get_int()
    local F = math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255)
    local O, T = render.get_screen_size()
    if XU:get_bool() then
        render.window(7, (T / 2 + 35) + 2, (65 + D) + v, (T / 2 + 37) + 34, (M:get_color()).r, (M:get_color()).g, (M:get_color()).b, 1)
        render.text(j, 52, T / 2 + 43, 'shark.gg', render.color(255, 255, 255, 255))
        render.text(j, 52, T / 2 + 56, 'user: ' .. (s .. ''), render.color(255, 255, 255, 255))
        render.text(j, 52 + D, T / 2 + 56, ' [beta]', render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, F))
        if Y == 0 then
            render.rect_filled(12, T / 2 + 42, 45, T / 2 + 49, render.color(255, 255, 255, 255))
            render.rect_filled(12, T / 2 + 49, 45, T / 2 + 56, render.color(28, 53, 120, 255))
            render.rect_filled(12, T / 2 + 56, 45, T / 2 + 65, render.color(2228, 24, 28, 255))
        end
        if Y == 1 then
            render.rect_filled(12, T / 2 + 42, 45, T / 2 + 49, render.color(0, 0, 0, 255))
            render.rect_filled(12, T / 2 + 49, 45, T / 2 + 56, render.color(221, 0, 0, 255))
            render.rect_filled(12, T / 2 + 56, 45, T / 2 + 65, render.color(255, 204, 0, 255))
        end
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
    end
end
local kC = { render.get_screen_size() }
local jC = gui.add_slider('keybinds_x', v, 0, kC[1], 1)
local sC = gui.add_slider('keybinds_y', v, 0, kC[2], 1)
gui.set_visible(v .. 'keybinds_x', false)
gui.set_visible(v .. 'keybinds_y', false)
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
    if m then
        if k > s then
            k = s
        elseif k < 0 then
            k = 0
        end
    end
    return k
end
function drag(k, j, s, c)
    local N, m = input.get_cursor_pos()
    local D = false
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
    local s = { (gui.get_config_item('rage>aimbot>aimbot>double tap')):get_bool(), (gui.get_config_item('rage>aimbot>aimbot>hide shot')):get_bool(),
    (gui.get_config_item('rage>aimbot>ssg08>scout>override')):get_bool(), (gui.get_config_item('rage>aimbot>aimbot>headshot only')):get_bool(),
    (gui.get_config_item('misc>movement>fake duck')):get_bool() }
    local c = { 'Doubletap', 'On-shot ', 'Override Damage', 'Head', 'Duck-peek ', 'Head' }
    if not s[4] then
        if not s[5] then
            if not s[3] then
                if not s[1] then
                    if not s[6] then
                        if not s[2] then
                            j = 0
                        else
                            j = 38
                        end
                    else
                        j = 40
                    end
                else
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
    local m = 'enabled'
    local D = render.get_text_size(AU, m) + 7
    local H = s[3] or s[4] or s[5] or s[6] or s[7] or s[8]
    local v = s[1] or s[2] or s[9] or s[10] or s[11]
    drag(jC, sC, N[1], N[2])
    local l = math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255)
    alpha = animate(alpha or 0, gui.is_menu_open() or H or v, 1, .5, false, true)
    local U, Y = render.get_text_size(AU, 'keybinds')
    render.window(k[1], k[2], k[1] + N[1], k[2] + N[2], (M:get_color()).r, (M:get_color()).g, (M:get_color()).b, alpha)
    for j = 1, 10, 1 do
        render.rect_filled_rounded((((k[1] + N[1] / 2) - render.get_text_size(AU, 'keybinds') / 2) - 1) - j, (k[2] + 7) - j, (((k[1] + N[1] / 2) + render.get_text_size(AU, 'keybinds') / 2) - 1) + j,
            ((k[2] + 4) + Y) + j, render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, (20 - 2 * j) * (alpha - .65)), 10)
    end
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
    render.text(AU, (k[1] + N[1]) - D, ((k[2] + N[2]) + 2) + F, m, render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, (M:get_color()).a * ho_alpha))
    if s[5] then F = F + 11 end
    fd_alpha = animate(fd_alpha or 0, s[6], 1, .5, false, true)
    render.text(AU, k[1] + 6, ((k[2] + N[2]) + 2) + F, c[6], render.color(255, 255, 255, 255 * fd_alpha))
    render.text(AU, (k[1] + N[1]) - D, ((k[2] + N[2]) + 2) + F, m, render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, (M:get_color()).a * fd_alpha))
end
function checkingwidgets()
    local k = l:get_int()
    local j = XU:get_bool()
    gui.set_visible(v .. 'Visual Items', k == 3)
    gui.set_visible(v .. 'Indicators Under Crosshair', k == 3)
    gui.set_visible(v .. 'Skeet Indicators', k == 3)
    gui.set_visible(v .. 'Indicators Style', k == 3 and QU:get_bool())
    gui.set_visible(v .. 'UI | Type', k == 3 and (LU:get_bool() or KU:get_bool() or XU:get_bool()))
    gui.set_visible(v .. 'Info Panel | Flag', k == 3 and j)
end
local cC = gui.add_checkbox('Fps Boost', v)
local NC = gui.add_checkbox('Trash Talk', v)
local mC = gui.add_checkbox('Clantag', v)
local DC = gui.add_combo('Clantag Type', v, { 'shark.gg', 'botlucky.com', 'primordial.dev', 'rawetrip', 'onetap.cc', 'gamesense.pub', 'EZfrags.co', 'neverlose.cc', 'ev0lve.xyz', 'pandora.gg' })
local HC = gui.add_checkbox('Aspect Ratio', v)
local vC = gui.add_slider('Aspect Value', v, 1, 200, 1)
local function lC(k, j, s, c)
    if k then
        return j + (((s - j) * global_vars.frametime) * c) / 1.5
    else
        return j - (((s + j) * global_vars.frametime) * c) / 1.5
    end
end
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
    local N = entities.get_entity(engine.get_local_player())
    if not N then return end
    if not N:is_alive() then return end
    local m, D = render.get_screen_size()
    local H = m / 2
    local v = D / 2
    local l = 0
    local U = info.fatality.in_slowwalk
    local Y = entities.get_entity(engine.get_local_player())
    local F = Y:get_prop('m_hGroundEntity') == -1
    local O = math.floor(Y:get_prop('m_vecVelocity[0]'))
    local T = math.floor(Y:get_prop('m_vecVelocity[1]'))
    local z = math.sqrt(O ^ 2 + T ^ 2) < 5
    local R = bit.band(Y:get_prop('m_fFlags'), bit.lshift(2, 0)) ~= 0
    local h = Y:get_prop('m_fFlags')
    if QU:get_bool() then
        local k = render.font_esp
        local s = math.floor(math.abs(math.sin(global_vars.realtime) * 2) * 255)
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
        local l = j.anim_new('m_bIsScoped add 1', c:get_prop('m_bIsScoped') and 15 or 0)
        local U = j.anim_new('m_bIsScoped add 12', c:get_prop('m_bIsScoped') and 24 or 0)
        local Y, F = render.get_screen_size()
        local O = Y / 2
        local T = F / 2
        local z = render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, 255)
        local R = render.color((M:get_color()).r - 70, (M:get_color()).g - 90, (M:get_color()).b - 70, 185)
        local h = 'D'
        local y, b = render.get_text_size(RC, h)
        local u, E = render.get_text_size(RC, 'E')
        local n, x = render.get_text_size(RC, 'DE')
        render.text(RC, ((O - (y - 4)) + l) - 4, T + 21, h, render.color(c1, c2, c3, 255))
        render.text(RC, ((O + (y - 4)) + l) - 4, T + 21, 'E', render.color(c11, c22, c33, 255))
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
        local a = j.anim_new('m_bIsScoped add sw', c:get_prop('m_bIsScoped') and 27 or 0)
        render.text(k, (O - 20) + a, (T + 12) + add_y, 'slow-walk', render.color(154, 156, 151, zC[3]))
        if o:get_bool() then
            zC[4] = TC(zC[4], 255, global_vars.frametime * 11)
            add_y = add_y + 6
        else
            if zC[4] > 0 then add_y = add_y + 6 end
            zC[4] = TC(zC[4], 0, global_vars.frametime * 11)
        end
        local w = j.anim_new('m_bIsScoped add swxxxx', c:get_prop('m_bIsScoped') and 19 or 0)
        render.text(k, (O - 12) + w, (T + 12) + add_y, 'os-aa', render.color(176, 114, 196, zC[4]))
    end
end
local hC = { 0, 0, 0, 0, 0 }
local yC = function(k, j, s) return math.floor(k + (j - k) * s) end
function indicators2func()
    local k = entities.get_entity(engine.get_local_player())
    if not k then return end
    add_y = 0
    if not k:is_alive() then return end
    if WU:get_int() == 0 then return end
    if QU:get_bool() then
        local s = render.font_esp
        local c, N = render.get_screen_size()
        local m = c / 2
        local D = N / 2
        local H = info.fatality.can_fastfire and render.color(255, 255, 255, hC[1]) or render.color(226, 54, 55, hC[1])
        local v = j.anim_new('m_bIsScoped add 12', k:get_prop('m_bIsScoped') and 30 or 0)
        local l = j.anim_new('m_bIsScoped add dbb', info.fatality.can_fastfire and 1 or .01)
        local U, Y = render.get_text_size(s, 'shark.gg')
        for k = 1, 10, 1 do
            render.rect_filled_rounded(((m - U / 2) + v) - k, (D + 15) - k, ((m + U / 2) + v) + k, ((D + 15) + Y) + k,
                render.color((M:get_color()).r, (M:get_color()).g, (M:get_color()).b, (20 - 2 * k) * 1), 10)
        end
        local F, O = render.get_text_size(s, 'FAKELAG')
        local T, z = render.get_text_size(s, get_cond())
        local R, h = render.get_text_size(s, 'DT')
        render.text(s, (m - U / 2) + v, D + 15, 'shark.gg', render.color(255, 255, 255, 255))
        if info.fatality.can_fastfire then
            hC[1] = yC(hC[1], 255, global_vars.frametime * 11)
            add_y = add_y + 7
            render.text(s, (m - T / 2) + v, (D + z) + 12, get_cond(), M:get_color())
            render.circle_filled(((m - T / 2) - 4) + v, (D + z) + 16, 2, render.color(0, 0, 0, 255))
            render.circle_filled(((m - T / 2) - 4) + v, (D + z) + 16, 1, M:get_color())
            render.circle_filled(((m + T / 2) + 4) + v, (D + z) + 16, 2, render.color(0, 0, 0, 255))
            render.circle_filled(((m + T / 2) + 4) + v, (D + z) + 16, 1, M:get_color())
        else
            render.text(s, (m - F / 2) + v, (D + O) + 12, 'FAKELAG', M:get_color())
            render.circle_filled(((m - F / 2) - 4) + v, (D + O) + 16, 2, render.color(0, 0, 0, 255))
            render.circle_filled(((m - F / 2) - 4) + v, (D + O) + 16, 1, M:get_color())
            render.circle_filled(((m + F / 2) + 4) + v, (D + O) + 16, 2, render.color(0, 0, 0, 255))
            render.circle_filled(((m + F / 2) + 4) + v, (D + O) + 16, 1, M:get_color())
            if hC[1] > 0 then add_y = add_y + 7 end
            hC[1] = yC(hC[1], 0, global_vars.frametime * 11)
        end
        render.text(s, (m - R / 2) + v, (D + h) + 22, 'DT', H)
        render.circle((((m - R / 2) + v) + R) + 5, (D + h) + 26, 3, H, 2, 50, l)
    end
end
local bC = { 'neverlose pov: ', 'lol bro', 'Got raped dog', 'ez head 1', 'nice iq', '1', 'ez owned by esoterik kid', 'refund ur rupaste',
'get good with gamesense', ' ♛ 1', 'I understand you have neverlose but resolver when?' , 'gamesense after update is god mode',  'You have neverlose and you did not take why you do not buy gamesense?', 
'ez, resolver issue',}
function on_player_death(k)
    if NC:get_bool() then
        local j = engine.get_local_player()
        local s = engine.get_player_for_user_id(k:get_int('attacker'))
        local c = engine.get_player_for_user_id(k:get_int('userid'))
        local N = engine.get_player_info(c)
        if s == j and c ~= j then engine.exec('say ' .. (bC[utils.random_int(1, #bC)] .. '')) end
    else
    end
end
local uC = 0
local EC = { 's➚➙➙➙ ', 'sh➘➙➙ ', 'sha➚➙', 'shar➘', 'shark ', 'shark.➙', 'shark.t➙➙', 'shark.te➙➙➙', 'shark.tec➙', 'shark.tech➙', 'shark.techs', 'shark.techs', 'shark.techs|', 'shark.tech|',
'shark.|', 'shar|', 'sha|', 'sh|', 's|', ' ', '➚', '➙➙➙ ', '➙➙➙➙' }
local nC = { '☘', '☘ L', '☘ Lu', '☘ Luc', '☘ Luck', '☘ Lucky', '☘ LuckyC', '☘ LuckyCh', '☘ LuckyChar', '☘ LuckyCharm', '☘ LuckyCharms', '☘ LuckyCharm', '☘ LuckyChar', '☘ LuckyCha', '☘ LuckyCh ', '☘ LuckyC',
'☘ Lucky', '☘ Luck', '☘ Luc', '☘ Lu ', '☘ L ', '☘' }
local iC = { '⌛ p', '⌛ pr', '⌛ pri', '⌛ prim', '⌛ primo', '⌛ primor', '⌛ primord', '⌛ primordi', '⌛ primordia', '⌛ primordia', '⌛ primordial', '⌛ primordial.', '⌛ primordial.', '⌛ rimordial.d', '⌛ imordial.de',
'⌛ mordial.dev', '⌛ ordial.dev', '⌛ rdial.dev', '⌛ dial.dev', '⌛ ial.dev', '⌛ al.dev', '⌛ l.dev', '⌛ .dev', '⌛ dev', '⌛ ev', '⌛ v',  '⌛'}
local zC = { '〄', 'R>|〄', 'RA>|〄', 'R4W>|〄', 'RAWЭ>|〄', 'R4W3T>|〄', 'RAWΣTR>|〄', 'Я4WETRI>|〄', 'RAWETRIP>|〄', 'RAWETRIP<|〄', 'R4WETRI<|〄', 'RAWΣTR<|〄', 'R4W3T<|〄', 'RAWЭ<|〄', 'R4W<|〄', 'RA<|〄', 'R<|〄', '〄'}
local tC = { 'onetap' }
local oC = { 'g', 'ga', 'gam', 'game', 'games', 'games', 'gamese', ' gamesen', 'gamesens', 'gamesense', 'amesense', 'mesense', 'esense', 'sense', 'ense', 'nse', 'se', 'e', ''}
local bC = { 'E', 'EZ', 'EZf', 'EZfr', 'EZfra', 'EZfrag', 'EZfrags', 'EZfrag', 'EZfra', 'EZfr', 'EZf', 'EZ', 'E', '' }
local kC = { ' ', ' | ', ' |\\ ', ' |\\| ', ' N ', ' N3 ', ' Ne ', ' Ne\\ ', ' Ne\\/ ', ' Nev ', ' Nev3 ', ' Neve ', ' Neve| ', ' Neve|2 ', ' Never|_ ', ' Neverl ', ' Neverl0 ', ' Neverlo ', ' Neverlo5 ',
 ' Neverlos ', ' Neverlos3 ', ' Neverlose ', ' Neverlose. ', ' Neverlose.< ', ' Neverlose.c< ', ' Neverlose.cc ', ' Neverlose.cc ', ' Neverlose.cc ', ' Neverlose.c< ', ' Neverlose.< ', ' Neverlose. ', ' Neverlose '
 , ' Neverlos3 ', ' Neverlos ', ' Neverlo5 ', ' Neverlo ', ' Neverl0 ', ' Neverl ', ' Never|_ ', ' Never|2 ', ' Neve|2 ', ' Neve| ', ' Neve ', ' Nev3 ', ' Ne\\/ ', ' Ne\\ ', ' Ne ', ' N3 ', ' |\\| ', ' |\\ ', ' | ', ' ', '' }
local rC = { 'e', 'ev', 'ev', 'ev0', 'ev0l', 'ev0lv', 'ev0lve', 'ev0lve.', 'ev0lve.x', 'ev0lve.xy', 'ev0lve.xyz', 'v0lve.xyz', '0lve.xyz', 'lve.xyz', 've.xyz', 'e.xyz', '.xyz', 'xyz', 'yz', 'z', '' }
local lC = { 'pandora',}
function clantagfc()
    local k = DC:get_int()
    if mC:get_bool() then
        local j = gui.get_config_item('misc>various>clan tag')
        local s = math.floor(global_vars.realtime * 1.8)
        if uC ~= s then
            if k == 0 then utils.set_clan_tag(EC[s % #EC + 1]) end
            if k == 1 then utils.set_clan_tag(nC[s % #nC + 1]) end
            if k == 2 then utils.set_clan_tag(iC[s % #iC + 1]) end
            if k == 3 then utils.set_clan_tag(zC[s % #zC + 1]) end
            if k == 4 then utils.set_clan_tag(tC[s % #tC + 1]) end
            if k == 5 then utils.set_clan_tag(oC[s % #oC + 1]) end
            if k == 6 then utils.set_clan_tag(bC[s % #bC + 1]) end
            if k == 7 then utils.set_clan_tag(kC[s % #kC + 1]) end
            if k == 8 then utils.set_clan_tag(rC[s % #rC + 1]) end
            if k == 9 then utils.set_clan_tag(lC[s % #lC + 1]) end
            uC = s
            j:set_bool(false)
        end
    end
end
local xC = cvar.r_aspectratio
local CC = xC:get_float()
local function gC(k)
    local j, s = render.get_screen_size()
    local c = (j * k) / s
    if k == 1 then c = 0 end
    xC:set_float(c)
end
function aspect_ratio2()
    if HC:get_bool() then
        local k = vC:get_int() * .01
        k = 2 - k
        gC(k)
    end
end
function checkingmisc()
    local k = l:get_int()
    gui.set_visible(v .. 'Fps Boost', k == 4)
    gui.set_visible(v .. 'Trash Talk', k == 4)
    gui.set_visible(v .. 'Clantag', k == 4)
    gui.set_visible(v .. 'Clantag Type', k == 4 and mC:get_bool() == true)
    gui.set_visible(v .. 'Aspect Ratio', k == 4)
    gui.set_visible(v .. 'Aspect Value', k == 4 and HC:get_bool() == true)
end
function fps_boost()
    if cC:get_bool() then
        cvar.cl_disablefreezecam:set_float(1)
        cvar.cl_disablehtmlmotd:set_float(1)
        cvar.r_dynamic:set_float(0)
        cvar.r_3dsky:set_float(0)
        cvar.r_shadows:set_float(0)
        cvar.cl_csm_static_prop_shadows:set_float(0)
        cvar.cl_csm_world_shadows:set_float(0)
        cvar.cl_foot_contact_shadows:set_float(0)
        cvar.cl_csm_viewmodel_shadows:set_float(0)
        cvar.cl_csm_rope_shadows:set_float(0)
        cvar.cl_csm_sprite_shadows:set_float(0)
        cvar.cl_freezecampanel_position_dynamic:set_float(0)
        cvar.cl_freezecameffects_showholiday:set_float(0)
        cvar.cl_showhelp:set_float(0)
        cvar.cl_autohelp:set_float(0)
        cvar.mat_postprocess_enable:set_float(0)
        cvar.fog_enable_water_fog:set_float(0)
        cvar.gameinstructor_enable:set_float(0)
        cvar.cl_csm_world_shadows_in_viewmodelcascade:set_float(0)
        cvar.cl_disable_ragdolls:set_float(0)
    end
end
local oC = {}
oC.import = function(j)
    local s = function()
        local s = j == nil and N(k.get()) or j
        local c = m(s, '|')
        HC:set_bool(D(c[1]))
        QU:set_bool(D(c[2]))
        S:set_bool(D(c[3]))
        q:set_int(tonumber(c[4]))
        L:set_int(tonumber(c[5]))
        I:set_bool(D(c[6]))
        K:set_bool(D(c[7]))
        X:set_int(tonumber(c[8]))
        Z:set_int(tonumber(c[9]))
        Q:set_bool(D(c[10]))
        W:set_bool(D(c[11]))
        f:set_int(tonumber(c[12]))
        A:set_int(tonumber(c[13]))
        B:set_bool(D(c[14]))
        P:set_bool(D(c[15]))
        d:set_int(tonumber(c[16]))
        t:set_int(tonumber(c[17]))
        V:set_bool(D(c[18]))
        e:set_bool(D(c[19]))
        p:set_int(tonumber(c[20]))
        G:set_int(tonumber(c[21]))
        J:set_bool(D(c[22]))
        i:set_bool(D(c[23]))
        kU:set_int(tonumber(c[24]))
        jU:set_int(tonumber(c[25]))
        sU:set_bool(D(c[26]))
        cU:set_bool(D(c[27]))
        NU:set_int(tonumber(c[28]))
        DU:set_int(tonumber(c[29]))
        mU:set_bool(D(c[30]))
        HU:set_bool(D(c[31]))
        vU:set_int(tonumber(c[32]))
        lU:set_int(tonumber(c[33]))
        UU:set_bool(D(c[34]))
        YU:set_bool(D(c[35]))
        MU:set_int(tonumber(c[36]))
        OU:set_int(tonumber(c[37]))
        FU:set_bool(D(c[38]))
        TU:set_bool(D(c[39]))
        zU:set_int(tonumber(c[40]))
        RU:set_int(tonumber(c[41]))
        hU:set_bool(D(c[42]))
        C:set_bool(D(c[43]))
        o:set_int(tonumber(c[44]))
        a:set_int(tonumber(c[45]))
        w:set_int(tonumber(c[46]))
        n:set_bool(D(c[47]))
        x:set_bool(D(c[48]))
        h:set_bool(D(c[49]))
        z:set_bool(D(c[51]))
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
    rollresolve()
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
    Inverting()
    fl()
    aa_presets()
    antiaimbuilder()
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Made by bummy. Thx you for buying my lua and if you crack it your gay as fuck! --

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[[

]]
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

gui.add_slider("-ElectricSpark-", "LUA>TAB A", 0, 0, 1)
local checkbox1 = gui.add_checkbox("only localplayer", "LUA>TAB A")
local slider1 = gui.add_slider("Radius", "LUA>TAB A", 3, 10, 1)
local slider2 = gui.add_slider("Length", "LUA>TAB A", 1, 10, 1)

ffi.cdef[[
    typedef struct{
        float x;
        float y;
        float z;
    }Vector;

    typedef void(__fastcall*FX_ElectricSparkFn)(const Vector*,int,int,const Vector*);
]]

local FX_ElectricSpark = ffi.cast("FX_ElectricSparkFn",utils.find_pattern("client.dll","55 8B EC 83 EC 3C 53 8B D9 89 55 FC 8B 0D ?? ?? ?? ?? 56 57"))

local vec3 = ffi.new("Vector")
local QAngle = ffi.new("Vector")

QAngle.x = 0
QAngle.y = 0
QAngle.z = 0

function on_bullet_impact(event)
    local a = slider1:get_int()
    local b = slider2:get_int()
    if not vec3.x or not vec3.y or not vec3.z then return end
    local lp = entities.get_entity(engine.get_local_player())
    if not lp then return end
    local userid = lp:get_player_info().user_id
    if checkbox1:get_bool() then
        if userid ~= event:get_int("userid") then return end
    end
    vec3.x = event:get_float("x")
    vec3.y = event:get_float("y")
    vec3.z = event:get_float("z")
    FX_ElectricSpark(vec3,a,b,QAngle)
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
    "models/player/custom_player/kolka/ballas/ballas.mdl",
    "models/player/custom_player/frnchise9812/ballas1.mdl",
    "models/player/custom_player/z-piks.ru/gta_blood.mdl",
    "models/player/custom_player/z-piks.ru/gta_crip.mdl",
    "models/player/custom_player/heist/player_heist/tm_heist.mdl",
    "models/player/custom_player/kaesar/ghostface/ghostface.mdl",
}

local menu = {}
menu.add = {
    en = gui.add_checkbox("Enabled", "lua>tab a"),
    path = gui.add_combo("Player Model Changer (shark.gg)", "lua>tab a", path),
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
