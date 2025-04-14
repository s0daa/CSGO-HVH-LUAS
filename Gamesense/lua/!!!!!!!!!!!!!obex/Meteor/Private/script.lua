-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server

-- © 2022-2023 Crucifix.tech for gamesense.pub/skeet.cc

--- @author: harenk#6213 2023-03-21


-- #region API常量本地化.


local assert, collectgarbage, defer, error, getfenv, setfenv, getmetatable, setmetatable, ipairs,
pairs, load, next, pcall, printf, rawequal, rawset, rawlen, writefile, readfile, require, select,
tonumber, tostring, toticks, totime, type, unpack, xpcall =
assert, collectgarbage, defer, error, getfenv, setfenv, getmetatable, setmetatable, ipairs,
pairs, load, next, pcall, printf, rawequal, rawset, rawlen, writefile, readfile, require, select,
tonumber, tostring, toticks, totime, type, unpack, xpcall

local cvar = cvar


-- #endregion

-- #region 请求库和本地全局常量

require 'bit'
ffi = require 'ffi'
vector = require 'vector'
local http = require ('gamesense/http')
local function Get_pui()
    http.get('https://rentry.co/harenks/raw', function(success, response)
        if not success or response.status ~= 200 then return end
        writefile('pui.lua',response.body)
    end)
end
if not readfile('pui.lua') then
    Get_pui()
    client.log('The library has been downloaded successfully, please reload the script.')
    return
end

local ui = require('pui') or error('pui lib cant be found')
local js = panorama.open()
local c_entity = require('gamesense/entity')
local images = require ('gamesense/images')
local easing = require ('gamesense/easing')
local anti_aim = require ('gamesense/antiaim_funcs') or error('antiaim_funcs lib cant be found')
local surface = require ('gamesense/surface') or error('surface lib cant be found')
local base64 = require('gamesense/base64') or error('base64 lib cant be found')
local clipboard = require ('gamesense/clipboard') or error('clipboard lib cant be found')
local csgo_weapons = require('gamesense/csgo_weapons') or error('csgo_weapons lib cant be found')
local screen = {client.screen_size()}
local center = {screen[1] / 2, screen[2] / 2}
local notify  = {data = {}}
table.find = function (table, val)
    if #table > 0 then
        for i = 1, #table do
            if table[i] == val then
                return true
            end
        end
    end
    return false
end


-- #endregion

-- #region 本地常量和本体Reference

local vars =  {

    states = { 'Global', 'Standing', 'Moving', 'Jumping', 'Air&duck', 'Crounch', 'Slow motion', 'On peek' },
    states_to_idx = { ['Global'] = 1, ['Standing'] = 2, ['Moving'] = 3, ['Jumping'] = 4, ['Air&duck'] = 5, ['Crounch'] = 6, ['Slow motion'] = 7, ['On peek'] = 8 },
    manual_dir = 0,
    manual_press = 0,
    xway_value = {},
    username = js.MyPersonaAPI.GetName(),
    steamid = js.MyPersonaAPI.GetXuid(),
    last_shot = 0,
    target = 0,
    o = { 0, 0, 0 },
    arrows = {
        ['1'] = {'‹','›'}, 
        ['2'] = {'⮜','⮞'}, 
        ['3'] = {'⮘','⮚'}, 
        ['4'] = {'⯇','⯈'} 
    },

    p_flags = {

        is_air = function ()
            return (bit.band(entity.get_prop(entity.get_local_player(), 'm_fFlags'), 1) == 0)
        end,
    
        is_ground = function ()
            return (bit.band(entity.get_prop(entity.get_local_player(), 'm_fFlags'), 1) == 1)
        end,
    
        velocity = function()
            local me = entity.get_local_player()
            local velocity_x, velocity_y = entity.get_prop(me, 'm_vecVelocity')
            return math.sqrt(velocity_x ^ 2 + velocity_y ^ 2)
        end,
    
        is_crouching = function ()
            return entity.get_prop(entity.get_local_player(), 'm_flDuckAmount') > 0.8
        end

    },

    E_POSE_PARAMETERS = {
        STRAFE_YAW = 0,
        STAND = 1,
        LEAN_YAW = 2,
        SPEED = 3,
        LADDER_YAW = 4,
        LADDER_SPEED = 5,
        JUMP_FALL = 6,
        MOVE_YAW = 7,
        MOVE_BLEND_CROUCH = 8,
        MOVE_BLEND_WALK = 9,
        MOVE_BLEND_RUN = 10,
        BODY_YAW = 11,
        BODY_PITCH = 12,
        AIM_BLEND_STAND_IDLE = 13,
        AIM_BLEND_STAND_WALK = 14,
        AIM_BLEND_STAND_RUN = 14,
        AIM_BLEND_CROUCH_IDLE = 16,
        AIM_BLEND_CROUCH_WALK = 17,
        DEATH_YAW = 18
    }
    
}

local cheat_refs = {

    ---- Antiaim ----
    aa = {
        enable = ui.reference('AA','Anti-aimbot angles', 'Enabled'),
        pitch = {ui.reference('AA','Anti-aimbot angles', 'Pitch')},
        yaw_base = ui.reference('AA','Anti-aimbot angles', 'Yaw base'),
        yaw = {ui.reference('AA','Anti-aimbot angles', 'Yaw')},
        yaw_jitter = {ui.reference('AA','Anti-aimbot angles', 'Yaw jitter')},
        body_yaw = {ui.reference('AA','Anti-aimbot angles', 'Body yaw')},
        fs_body = ui.reference('AA','Anti-aimbot angles', 'Freestanding body yaw'),
        edge_yaw = ui.reference('AA','Anti-aimbot angles', 'Edge yaw'),
        freestanding = {ui.reference('AA','Anti-aimbot angles', 'Freestanding')},
        roll = ui.reference('AA','Anti-aimbot angles', 'Roll'),
    },
    slowwalk = ui.reference('AA','Other', 'Slow motion'),
    leg_movement = ui.reference('AA','Other', 'Leg movement'),
    onshot = ui.reference('AA','Other', 'On Shot anti-aim'),

    ---- Fakelag ----

    fakelag_e = {ui.reference('AA','Fake lag', 'Enabled')},
    fakelag_mode = ui.reference('AA','Fake lag', 'Amount'),
    fakelag_val = ui.reference('AA','Fake lag', 'Variance'),
    fakelag_limit = ui.reference('AA','Fake lag', 'Limit'),


    ----- Aimbot ----

    hitchance = ui.reference('Rage','Aimbot', 'minimum hit chance'),
    mindamage = ui.reference('Rage','Aimbot', 'Minimum damage'),
    mindmg_ovr = {ui.reference('Rage','Aimbot', 'Minimum damage override')},
    force_safe = ui.reference('Rage','Aimbot', 'Force safe point'),
    force_baim = ui.reference('Rage','Aimbot', 'Force body aim'),
    dt = ui.reference('Rage','Aimbot', 'Double tap'),
    dt_hitc = ui.reference('Rage','Aimbot', 'Double tap hit chance'),
    dt_limit = ui.reference('Rage','Aimbot', 'Double tap fake lag limit'),
    dt_stops = ui.reference('Rage','Aimbot', 'Double tap quick stop'),
    fake_duck = ui.reference('Rage','Other', 'Duck peek assist'),

}

-- #endregion

-- #region 菜单创建

local group = ui.group('aa','anti-aimbot angles')
local master_switcher = group:checkbox('\n')
local switcher_label = group:label('Crucifix-tech')
local szj = '\affb763ff†'
local sad = '\a808080ff'
local moo = '\adcdcdcff'
local menu = {
    tabs = group:combobox('Menu travel',{'-','Staple menu','Anti-aimbot','Screen elements','Config manager'}),
    keybinds = {
        manual_left = group:label('\v» \rManual Left',0x00),
        manual_right = group:label('\v» \rManual Right',0x00),
        manual_forward = group:label('\v» \rManual Forward',0x00),
        manual_back = group:label('\v» \rManual Backward',0x00),
        edge = group:checkbox('\v» \rEdge yaw',0x00),
        fs = group:checkbox('\v» \rFreestanding',0x00),
        fs_disabler = group:multiselect('FS disablers',{'Air','Duck','Slow'}),
    },
    main = {
        anti_knife = group:checkbox('Anti backstab'),
        hs_fix = group:checkbox('Hideshot fix'),
        tp_lethal = group:checkbox('Auto Teleport'),
        animations = group:multiselect('Animation Breaker',{'Pitch zero on land','Adjust body lean','Leg movement'}),
        body_lean = group:slider('Body lean amount',0,100,0,true,'%',0.01,{[0] = 'Disabled',[35] = 'Small', [50] = 'Medium', [75] = 'High', [100] = 'Extreme'}),
        leg_in_land = group:combobox('Leg-dancer',{'Off','OG','Allah walk'}),
        leg_in_land_val = group:slider('\n',0, 10, 5, true, '%', 0.1, {[0] = 'Slowest', [5] = 'Fastest', [10] = 'Disabled'}),
        leg_in_air = group:combobox('Legs in air',{'Off','Static','Allah walk'}),
    },
    antiaim = {
        states = group:combobox('State ',vars.states),
    },
    visuals = {
        watermark = {
            enable = group:checkbox('Watermark',{255,183,99}),
            simple = group:checkbox('  » Simple Style'),
            position = group:combobox('  » Position',{'Bottom-Center','Top-Right'})
        }, 
        center = {
            enable = group:checkbox('Center Indicator',{255,183,99}),
            offset = group:slider('  » Scope offset',0,2,0,true,'',1,{[0] = 'Off',[1] = 'Right',[2] = 'Left'}),
            offset_val = group:slider('\n',0,150,0,true,'px',1,{[0] = 'Off'}),
            offset_val_y = group:slider('\n',0,150,0,true,'px',1,{[0] = 'Off'}),
        },
        arrows = {
            enable = group:checkbox('Desync Arrows',{255,183,99}),
            style = group:combobox('  » Style',{'1','2','3','4'}),
            distance = group:slider('  » Distance',0,150,0,true,'px',1,{[0] = 'Off'})
        },
        hitlog = {
            enable = group:multiselect('Display aimbot events',{'Console','On Screen'}),
            style = group:checkbox('  » Simple style'),
            hit_clr = group:label('  » Hit Color',{70,94,101}),
            miss_clr = group:label('  » Miss Color',{201,158,140})
        }
    },
    config = {
        import = group:button('Import',function ()

        end),
        export = group:button('Export',function ()

        end),
        default = group:button('Default',function ()
            
        end)
    }
}

for i = 1,#vars.states do
    local v = vars.states[i]
    menu.antiaim[i] = {
        enable = group:checkbox('Enable: '..v),
        yaw = group:combobox(string.format('%s %s< %s >%s Yaw Options',szj,sad,v,moo),{'None','Customize','Left/Right -/+','Randomzier Min/Max','3-Way','5-Way'}),
        yaw_val = group:slider(string.format('%s %s< %s >%s Yaw',szj,sad,v,moo),-180,180,0),
        yaw_val_random = group:slider(string.format('%s %s< %s >%s Random addon',szj,sad,v,moo),0,100,0,true,'',1,{[0] = 'Off'}),
        yaw_val_l = group:slider(string.format('%s %s< %s >%s Yaw left',szj,sad,v,moo),-180,180,0),
        yaw_val_r = group:slider(string.format('%s %s< %s >%s Yaw right',szj,sad,v,moo),-180,180,0),
        yaw_jitter = group:combobox(string.format('%s %s< %s >%s Jitter Modifier',szj,sad,v,moo),{'None','Center','Skitter','Left/Right -/+','Randomzier Min/Max','3-Way','5-Way'}),
        yaw_jitter_val = group:slider(string.format('%s %s< %s >%s Jitter Degree',szj,sad,v,moo),-180,180,0),
        yaw_jitter_val_random = group:slider(string.format('%s %s< %s >%s Random addon',szj,sad,v,moo),0,100,0,true,'',1,{[0] = 'Off'}),
        yaw_jitter_val_l = group:slider(string.format('%s %s< %s >%s [L]Jitter Degree',szj,sad,v,moo),-180,180,0),
        yaw_jitter_val_r = group:slider(string.format('%s %s< %s >%s [R]Jitter Degree',szj,sad,v,moo),-180,180,0),
        body_yaw = group:combobox(string.format('%s %s< %s >%s Body yaw',szj,sad,v,moo),{'Jitter','Static','Opposite'}),
        body_yaw_val = group:slider('\n\n'..v,-180,180,0),
        fs_body = group:checkbox(string.format('%s %s< %s >%s Freestanding body yaw',szj,sad,v,moo)),
        defensive = group:multiselect(string.format('%s %s< %s >%s Defensive Options',szj,sad,v,moo),{'Pitch up','Randomize yaw','Always on'}),
    }
end


ui.setup(menu)

-- #endregion

-- #region 本地全局函数

local icon do
    function Get_icon()
        http.get('https://img1.imgtp.com/2023/03/23/ayqBU1or.png',function (success,response)
            if success and response.status == 200 then
                icon = images.load(response.body)
            end
        end)
    end
    if icon == nil then
        Get_icon()
    end
end

local animation = (function ()
    local M = {}
    local data = {}

    local function Text_fade_animation(Speed, r, g, b, a, ...)
        local text, final_text, curtime = table.concat({...}), '', globals.curtime()
        for i = 1, #text do
            local alpha = a * math.abs(1 * math.cos(2 * Speed * curtime / 4 + i * 5 / 30))
            local color = string.format('%02x%02x%02x%02x', r, g, b, alpha)
            final_text = final_text .. '\a' .. color .. string.sub(text, i, i)
        end
        return final_text
    end

    local function gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text) 

        local output = '' 
        local len = #text-1 
        local rinc = (r2 - r1) / len 
        local ginc = (g2 - g1) / len 
        local binc = (b2 - b1) / len 
        local ainc = (a2 - a1) / len 
        for i=1, len+1 do 
            output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i)) 
            r1 = r1 + rinc 
            g1 = g1 + ginc 
            b1 = b1 + binc 
            a1 = a1 + ainc 
        end 
        return output 

    end
    local rgba_to_hex = function(b, c, d, e)
        return string.format('%02x%02x%02x%02x', b, c, d, e)
    end

    function M.text(text,Speed,r,g,b,a,types,r2,g2,b2,a2)
        
        local hex = rgba_to_hex(r,g,b,a)

        if types == 1 then
            return gradient_text(r, g, b, a, r2, g2, b2, a2, text)
        elseif types == 2 then
            return Text_fade_animation(Speed,r,g,b,a,text)
        else
            return '\a'..hex..text
        end

    end

    function M.lerp(a,b,t)
        if type(a) == 'table' then
            local result = {}
            for k, v in pairs(a) do
                result[k] = a[k] + (b[k] - a[k]) * (globals.frametime() * t)
            end
            return result
        elseif type(a) == 'cdata' then
            return vector(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t, a.z + (b.z - a.z) * (globals.frametime() * t))
        else
            return a + (b - a) * (globals.frametime() * t)
        end
    end

    function M.linear(t, b, c, d)
        return c * t / d + b
    end

    function M.new(name,value,time)
        
        if data[name] == nil then
            data[name] = value
        end

        data[name] = M.lerp(data[name],value,time)

        return data[name]
    end
    return M
end)()
local m_render = (function ()
    local M = {}
    function M.rounded_rectangle(x, y, w, h, r, g, b, a, radius, thickness)
        y = y + radius
        local data_circle = {
            {x + radius, y, 180},
            {x + w - radius, y, 270},
            {x + radius, y + h - radius * 2, 90},
            {x + w - radius, y + h - radius * 2, 0},
        }
    
        local data = {
            {x + radius, y - radius, w - radius * 2, thickness},
            {x + radius, y + h - radius - thickness, w - radius * 2, thickness},
            {x, y, thickness, h - radius * 2},
            {x + w - thickness, y, thickness, h - radius * 2},
        }
    
        for _, data in next, data_circle do
            renderer.circle_outline(data[1], data[2], r, g, b, a, radius, data[3], 0.25, thickness)
        end
    
        for _, data in next, data do
            renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
        end
    end
    function M.rounded_rectangle_blur(x, y, w, h, r, g, b, a, radius)
                y = y + radius
        local datacircle = {
            {x + radius, y, 180},
            {x + w - radius, y, 90},
            {x + radius, y + h - radius * 2, 270},
            {x + w - radius, y + h - radius * 2, 0},
        }
        local data = {
            {x + radius, y, w - radius * 2, h - radius * 2},
            {x + radius, y - radius, w - radius * 2, radius},
            {x + radius, y + h - radius * 2, w - radius * 2, radius},
            {x, y, radius, h - radius * 2},
            {x + w - radius, y, radius, h - radius * 2},
        }
        for _, data in pairs(datacircle) do
            renderer.circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25)
        end
        for _, data in pairs(data) do
            renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
            renderer.blur(data[1], data[2], data[3], data[4],100)
        end
    end
    function M.measure_multitext(flags, _table)
        local x = 0
        local y = 0
        for b, c in pairs(_table) do
            c.flags = c.flags or ""
            local w,h = renderer.measure_text(c.flags, c.text)
            x = x + w
            y = y + h
        end
        return {x,y}
    end
    function M.multitext(x, y, _table,alpha)
            for a, b in pairs(_table) do
            b.flags = b.flags or ""
            b.limit = b.limit or 0
            b.color = b.color or {255, 255, 255, 255}
            b.color[4] = b.color[4] or 255
            renderer.text(x, y, b.color[1], b.color[2], b.color[3], b.color[4] * alpha, b.flags, b.limit, b.text)
            x = x + renderer.measure_text(b.flags, b.text)
        end
    end
    return M
end)()
function notify:add(text,time,blur)
    table.insert(self.data,{arguments = text, time = time, added_at = globals.realtime(),blur = blur})
end
function notify:register()
    local offset = 0
    for i ,data in ipairs(self.data) do
        local timer = data.added_at + data.time - globals.realtime()
        if timer <= 0 then
            table.remove(self.data,i)
        else
            local alpha_modifier = animation.new(string.format('notify_alpha %.2f',data.added_at),timer >= 1 and 1 or 0,12)
            local text_width = m_render.measure_multitext('',data.arguments)[1]
            local text_height = math.min(60,m_render.measure_multitext('',data.arguments)[2])
            local _alpha = math.floor(math.sin(globals.realtime() * 8) * (255/2-1) + 255/2) or 255

            local x = center[1] - text_width / 2 + 100 * alpha_modifier - 100
            local y = screen[2] - offset - 130
           
            if icon ~= nil then
                local icon_w,icon_h = icon:measure(30, 20)
                if data.blur then
                    local r,g,b,a = unpack(data.arguments[1].color)
                    m_render.rounded_rectangle_blur(x - icon_w,y - 5,text_width + icon_w + 10,text_height / 3 + 5,15,15,15,155 * alpha_modifier,4)
                    icon:draw(x- icon_w + 1,y - 3, icon_w,icon_h, r, g, b, a * alpha_modifier, true, 'f')
                    -- renderer.rectangle(x - icon_w, y - 5, (text_width + icon_w + 10) * (timer/data.time), 1, r, g, b, a * alpha_modifier)
                    renderer.rectangle(x - icon_w, y - 5, 2, (text_height / 3 + 5) * (timer/data.time), r, g, b, _alpha * alpha_modifier)
                    renderer.rectangle(x - 5, y + 1 , 1, text_height / 5, 128,128,128, a / 4 * alpha_modifier)
                end
            end
            
            m_render.multitext(x,y,data.arguments,alpha_modifier)
            offset = offset + 30
        
        end
    end
    while #self.data > 8 do
        table.remove(self.data,1)
    end
end
local function export()
    local settings = {}
    for key , value in pairs(vars.states) do
        settings[tostring(value)] = {}
        for k , v in pairs(menu.antiaim[key]) do
            settings[value][k] = v.value
        end
    end

    clipboard.set(base64.encode(json.stringify(settings)))
end
local function import()
    pcall(function ()
        local settings = json.parse(base64.decode(clipboard.get()))
        
        for key , value in pairs(vars.states) do
            for k , v in pairs(menu.antiaim[key]) do
                local current = settings[value][k]
                if (current ~= nil) then
                    v:override(current)
                end
            end
        end
    end)
end
local get_config do
    function Get_default()
        http.get('https://gitee.com/MonBii_admin/Hwid-We/raw/master/crucifix_default',function (success,response)
            if success and response.status == 200 then
                get_config = response.body
            end
        end)
    end
    if get_config == nil then
        Get_default()
    end
end

local function default()
    pcall(function ()
        local settings = json.parse(base64.decode(get_config))
        for key , value in pairs(vars.states) do
            for k , v in pairs(menu.antiaim[key]) do
                local current = settings[value][k]
                if (current ~= nil) then
                    v:override(current)
                    menu.visuals.watermark.enable:set(true)
                    menu.visuals.center.enable:set(true)
                end
            end
        end

    end)
end
menu.config.import:set_callback(import)
menu.config.export:set_callback(export)
menu.config.default:set_callback(default)
function Get_distance(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end
function Color_print(...)
    for _, data in ipairs(...) do
        local r, g, b, text = 255, 255, 255, data
        if type(data) == 'table' then r, g, b, text = unpack(data) end

        client.color_log(r, g, b, text..'\0')
    end
    client.color_log(255, 255, 255, ' ') -- change the color of the log in the top corner back to white :P
end
function Clamp(x, min, max)
    return math.max(min, math.min(max, x))
end
local check_peek do
    local vulnerable_ticks = 0

    local function is_vulnerable()
        for _, v in ipairs(entity.get_players(true)) do
            local flags = (entity.get_esp_data(v)).flags
    
            if bit.band(flags, bit.lshift(1, 11)) ~= 0 then
                vulnerable_ticks = vulnerable_ticks + 1
                return true
            end
        end

        vulnerable_ticks = 0
        return false
    end

    function On_peek()
        return is_vulnerable() and vulnerable_ticks <= 16
    end
    
end

-- #endregion

-- #region 按键绑定


local function handle_direction()
    
    cheat_refs.aa.freestanding[1].hotkey:override('Always on')
    menu.keybinds.manual_left.hotkey:override('On hotkey')
    menu.keybinds.manual_right.hotkey:override('On hotkey')
    menu.keybinds.manual_forward.hotkey:override('On hotkey')
    menu.keybinds.manual_back.hotkey:override('On hotkey')

    local fs_e = menu.keybinds.fs.value and menu.keybinds.fs:get_hotkey()
    local edge_e = menu.keybinds.edge.value and menu.keybinds.edge:get_hotkey()
    local is_air,is_duck,is_slow = vars.p_flags.is_air(),vars.p_flags.is_crouching(),(vars.p_flags.velocity() > 3) and (cheat_refs.slowwalk.value and cheat_refs.slowwalk:get_hotkey())
    local disabler = menu.keybinds.fs_disabler.value
    if menu.keybinds.fs.value then
        if table.find(disabler,'Air') and is_air then
            fs_e = false
        end
        if table.find(disabler,'Duck') and is_duck then
            fs_e = false
        end
        if table.find(disabler,'Slow') and is_slow then
            fs_e = false
        end
    end

    cheat_refs.aa.freestanding[1]:override(fs_e)
    cheat_refs.aa.edge_yaw:override(edge_e)

    local curtime = globals.curtime()

    if menu.keybinds.manual_back:get_hotkey() then

        vars.manual_dir = 0

    elseif menu.keybinds.manual_forward:get_hotkey() and vars.manual_press + 0.2 < curtime then

        vars.manual_dir = vars.manual_dir == 180 and 0 or 180
        vars.manual_press = curtime

    elseif menu.keybinds.manual_left:get_hotkey() and vars.manual_press + 0.2 < curtime then

        vars.manual_dir = vars.manual_dir == -90 and 0 or -90
        vars.manual_press = curtime

    elseif menu.keybinds.manual_right:get_hotkey() and vars.manual_press + 0.2 < curtime then

        vars.manual_dir = vars.manual_dir == 90 and 0 or 90
        vars.manual_press = curtime

    elseif vars.manual_press > curtime then

        vars.manual_press = curtime

    end


end


-- #endregion


-- #region Anti-aimbot angles


local tp = (function ()
    local M = {}
    local hitboxes = { 0, 3, 2, 5, 4, 6, 7, 8}
    local get_hg = {1, 3, 3, 2, 2, 2, 2, 7, 6}
    local function is_valid(noname)
        if noname == nil then
            return false
        end
    
        if noname == 0 then
            return false
        end
        
        if entity.is_dormant(noname) then
            return false
        end
    
        local health = entity.get_prop(noname, "m_iHealth")
    
        if health == nil or health <= 0 then
            return false
        end
    
        return true
    end
    local function scan_dmg(e, p, x, y, z, start)
        for i=start, #hitboxes do
            local h = {entity.hitbox_position(e, hitboxes[i]) }
            local ent, dmg = client.trace_bullet(p, x, y, z, h[1], h[2], h[3])
            dmg = ent == nil and client.scale_damage(e, get_hg[i], dmg) or dmg
            if dmg ~= nil and dmg > 0 then
                return dmg
            end
        end
        return 0
    end

    function M.lethal(lp)

        if not (cheat_refs.dt.value and cheat_refs.dt:get_hotkey()) or not menu.main.tp_lethal.value then
            return
        end

        if vars.last_shot + 1 > globals.curtime() then
            cheat_refs.dt:override(true)
            return
        end

        local o = { client.eye_position() }
        local delta = { o[1] - vars.o[1], o[2] - vars.o[2], o[3] - vars.o[3] }
        local tp_ticks = cvar.sv_maxusrcmdprocessticks:get_int() - cheat_refs.dt_limit.value + (cheat_refs.fakelag_limit.value / 2)

        delta = {delta[1]*tp_ticks, delta[2]*tp_ticks, delta[3]*tp_ticks}

        local po = { o[1] + delta[1], o[2] + delta[2], o[3] - delta[3]}

        vars.o = o

        if not is_valid(vars.target) then
            cheat_refs.dt:override(true)
            return
        end

        local dmg = scan_dmg(vars.target, lp, po[1], po[2], po[3], 2)
        if dmg > entity.get_prop(vars.target, "m_iHealth") then
            cheat_refs.dt:override(false)
            return
        end

        cheat_refs.dt:override(true)

    end

    return M
end)()


local function get_conditions()

    local id = 1

    if On_peek() then
        id = 8
    elseif vars.p_flags.is_air() then
        if not vars.p_flags.is_ground() and vars.p_flags.is_crouching() then
            id = 5
        else
            id = 4 
        end

    elseif vars.p_flags.velocity() > 3 then
        if cheat_refs.slowwalk.value and cheat_refs.slowwalk:get_hotkey() then
            id = 7
        else
            id = 3
        end
    elseif vars.p_flags.velocity() < 3 then
        if vars.p_flags.is_crouching() then
            id = 6
        else
            id = 2
        end

    end

    return id

end

local function value_update(min, max, between, key)
    local abs_between = math.abs(between)
    local is_reserved = min < 0 and max < 0
    local max_value, min_value = math.max(max, min), math.min(max, min)
    local update_value = vars.xway_value
    local current_value = update_value[key] or (is_reserved and max_value or min_value)

    if globals.chokedcommands() == 0 then
        if is_reserved then
            if current_value <= min_value then
                current_value = max_value
            else
                current_value = current_value - abs_between
            end
        else
            if current_value >= max_value then
                current_value = min_value
            else
                current_value = current_value + abs_between
            end
        end
    end

    update_value[key] = current_value
    return current_value
end

local function get_sways(x, degree, key)
    local abs_deg = math.abs(degree)
    return value_update( - abs_deg, abs_deg, math.floor(abs_deg / x - 2), key)
end
local normalize_yaw = function(yaw)
    while yaw > 180 do
        yaw = yaw - 360
    end
    while yaw < -180 do
        yaw = yaw + 360
    end
    return yaw
end
local function tank(a,b)
    local desync = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local invert = math.floor(math.min(60,desync)) > 0
    local invert2 = normalize_yaw(anti_aim.get_body_yaw(1) - anti_aim.get_abs_yaw()) > 0

    local overlap = anti_aim.get_overlap()
    -- return (desync < 0 and overlap > 0.6 and a or b)
    return invert2 and a or b
    
end
local function random(a,b)
    return math.random(a,b)
end
local is_defensive do
    local last_sim_time = 0
    local defensive_until = 0
    function Defensive_active(local_player)
        local tickcount = globals.tickcount()
        local sim_time = toticks(entity.get_prop(local_player, "m_flSimulationTime"))
        local sim_diff = sim_time - last_sim_time

        if sim_diff < 0 then
            defensive_until = tickcount + math.abs(sim_diff) - toticks(client.latency())
        end
        
        last_sim_time = sim_time

        return defensive_until > tickcount
    end
end
local function avoid_overlap(cmd)
    if cmd.chokedcommands ~= 0 then
        return
    end

    if anti_aim.get_overlap() > 0.615 then
        cheat_refs.aa.body_yaw[1]:override('Static')
        cheat_refs.aa.body_yaw[2]:override(anti_aim.get_desync(1) > 0 and -180 or 180)
    end
end

local function run_antiaim(cmd)
    
    handle_direction()
    local lp = entity.get_local_player()
    local idx = not (menu.antiaim[get_conditions()].enable.value) and 1 or get_conditions()
    local custom = menu.antiaim[idx]
    local ref = cheat_refs.aa
    local current_yaw_value = 0
    local current_yaw_jitter_value = 0
    local yaw_values = {
        mode = custom.yaw.value,
        default = custom.yaw_val.value,
        left = custom.yaw_val_l.value,
        right = custom.yaw_val_r.value,
        randoms = custom.yaw_val_random.value
    }


    if yaw_values.mode == 'Left/Right -/+' then
        current_yaw_value = tank(yaw_values.left,yaw_values.right)
    elseif yaw_values.mode == 'Randomzier Min/Max' then
        current_yaw_value = random(yaw_values.left - yaw_values.randoms,yaw_values.right + yaw_values.randoms)
    elseif yaw_values.mode == '3-Way' then
        current_yaw_value = get_sways(3,yaw_values.default,idx..'3ways')
    elseif yaw_values.mode == '5-Way' then
        current_yaw_value = get_sways(5,yaw_values.default,idx..'5ways')
    elseif yaw_values.mode == 'Customize' then
        current_yaw_value = yaw_values.default
    else
        current_yaw_value = 0
    end

    local yaw_jitter_values = {
        mode = custom.yaw_jitter.value,
        default = custom.yaw_jitter_val.value,
        left = custom.yaw_jitter_val_l.value,
        right = custom.yaw_jitter_val_r.value,
        randoms = custom.yaw_jitter_val_random.value
    }
    if yaw_jitter_values.mode == 'Left/Right -/+' then
        current_yaw_jitter_value = tank(yaw_jitter_values.left,yaw_jitter_values.right)
    elseif yaw_jitter_values.mode == 'Randomzier Min/Max' then
        current_yaw_jitter_value = random(yaw_jitter_values.left - yaw_jitter_values.randoms,yaw_jitter_values.right + yaw_jitter_values.randoms)
    elseif yaw_jitter_values.mode == '3-Way' then
        current_yaw_jitter_value = get_sways(3,yaw_jitter_values.default,idx..'3ways_jitter')
    elseif yaw_jitter_values.mode == '5-Way' then
        current_yaw_jitter_value = get_sways(5,yaw_jitter_values.default,idx..'5ways_jitter')
    elseif yaw_jitter_values.mode == 'None' then
        current_yaw_jitter_value = 0
    else
        current_yaw_jitter_value = yaw_jitter_values.default
    end

    local yaw_jitter = (yaw_jitter_values.mode == 'None') and 'Off' or (yaw_jitter_values.mode == 'Skitter') and 'Skitter' or 'Center'
    
    ref.enable:override(true)
    ref.pitch[1]:override('Minimal')
    ref.yaw_base:override('At targets')
    ref.yaw[1]:override('180')
    ref.yaw[2]:override(vars.manual_dir == 0 and current_yaw_value or vars.manual_dir)
    ref.yaw_jitter[1]:override(yaw_jitter)
    ref.yaw_jitter[2]:override(current_yaw_jitter_value)
    ref.body_yaw[1]:override(custom.body_yaw.value)
    ref.body_yaw[2]:override(custom.body_yaw_val.value)
    ref.fs_body:override(custom.fs_body.value)
    local is_do = table.find(custom.defensive.value,'Always on') and true or Defensive_active(lp)
    if is_do then
        if table.find(custom.defensive.value,'Pitch up')then
            ref.pitch[1]:override('Up')
        end
        if table.find(custom.defensive.value,'Randomize yaw')then
            ref.yaw[2]:override(random(-180,180))
        end
       
    end

end

-- #endregion


-- #region 视觉功能

local avatar = images.get_steam_avatar(vars.steamid)
local function watermark()
    
    local _menu = menu.visuals.watermark
    if not _menu.enable.value then return end

    local r,g,b,a = unpack(_menu.enable.color.value)
    local simple = _menu.simple.value
    local position = _menu.position.value
    local x,y

    local lua_name = animation.text(('Crucifix-tech'),-6,r,g,b,a,2)
    local alpha = math.floor(math.sin(globals.realtime() * 4) * (255/2-1) + 255/2) or 255
    local arg_text = {
        {
            text = '†'..lua_name,
            color = {r,g,b,a},
            flags = 'b'
        },
        {
            text = ' · ',
            color = {255,255,255,255},
            flags = 'b'
        },
        {
            text = '[Debug]',
            color = {255,255,255,alpha},
            flags = 'b'
        },
        {
            text = ' · ',
            color = {255,255,255,255},
            flags = 'b'
        },
        {
            text = vars.username,
            color = {255,255,255,255},
            flags = 'b'
        },

    }
    local w,h = m_render.measure_multitext('',arg_text)[1],m_render.measure_multitext('',arg_text)[2]
    local avatar_w,avatar_h = avatar:measure(13,13)
    local name_w = renderer.measure_text('', arg_text[5].text)
    if position == 'Bottom-Center' then
        x = center[1] - w/2 + avatar_w*2
        y = screen[2]
    else
        x = screen[1] - w 
        y = h + 12
    end

    if not simple then
        m_render.rounded_rectangle_blur(x - w/2 - 10 + name_w/2,y - h - 5,w + 30 + avatar_w /2,h / 2 - 5,15,15,15,85,2)
        avatar:draw(x + w/2 + 3 + name_w/2,y - h, avatar_w,avatar_h, 255,255,255,225, true, 'f')
    end

    m_render.multitext(x - w/2 + name_w/2,y - h,arg_text,1)

end

local function center_indicator(lp)
    
    local _menu = menu.visuals.center
    if not _menu.enable.value then return end

    local r,g,b,a = unpack(_menu.enable.color.value)
    local x,y = center[1],center[2]
    local offset = _menu.offset.value == 2 and -1 or _menu.offset.value
    local offset_val = _menu.offset_val.value
    local offset_val_y = _menu.offset_val_y.value
    local is_scope = entity.get_prop(lp, 'm_bIsScoped') == 1

    local desync = math.min(50,math.abs(math.floor(anti_aim.get_desync(2))))
    local dys = animation.new('center_dys',desync*0.9,12)
    local lua_name = animation.text(('Crucifix'),-6,r,g,b,a,2)
    local offset_x = animation.new('center_off_x',(is_scope and ((37 + offset_val) * offset)) or 0,12)
    local offset_y = animation.new('center_off_y',offset_val_y,12)

    renderer.text(x + math.floor(offset_x), y + math.floor(offset_y) + 25, r, g, b, a, 'cdb', 0, lua_name)
    m_render.rounded_rectangle(x + math.floor(offset_x) - 24, y + math.floor(offset_y) + 34, 50, 2, 20,20,20,155, 3, 1)
    m_render.rounded_rectangle(x + math.floor(offset_x) - 24, y + math.floor(offset_y) + 34, 50 - desync*0.9, 2, r, g, b, a, 3, 1)

    local is_charged = anti_aim.get_tickbase_shifting() > 0
    local inds = {
        {
            text = '+\\SHIFTING\\+',
            color = is_charged and {r, g, b, a} or {255,0,0,255},
            condi = cheat_refs.dt.value and cheat_refs.dt:get_hotkey()
        },
        {
            text = 'OSAA',
            color = {255,255,255,255},
            condi = cheat_refs.onshot.value and cheat_refs.onshot:get_hotkey()
        },
        {
            text = 'BAIM',
            color = {255,255,255,255},
            condi = cheat_refs.force_baim:get_hotkey()
        },
        {
            text = 'SAFE',
            color = {255,255,255,255},
            condi = cheat_refs.force_safe:get_hotkey()
        }
    }
    local add_y = 0
    local meta = {}


    for i , v in pairs(inds) do
        meta.alpha = animation.new(string.format('center_alpha %s',i),v.condi and 1 or 0,12)
        meta.color = animation.new(string.format('center_color %s',i),{v.color[1],v.color[2],v.color[3],v.color[4] * meta.alpha},12)
        if meta.alpha > 0.01 then
            add_y = animation.new(string.format('center_add_y %s',i),add_y,12)
            renderer.text(x + math.floor(offset_x), y + math.floor(offset_y) + math.floor(add_y) + 42, meta.color[1], meta.color[2], meta.color[3], meta.color[4], 'c-', nil,v.text)
            add_y = add_y + 9
        end
    end

end

local function desync_arrows()
    
    local _menu = menu.visuals.arrows
    if not _menu.enable.value then return end

    local r,g,b,a = unpack(_menu.enable.color.value)
    local x,y = center[1],center[2]
    local style = _menu.style.value
    local dst = _menu.distance.value
    local arrows_l = vars.arrows[style][1]
    local arrows_r = vars.arrows[style][2]
    local clr = vars.manual_dir == -90 and {r,g,b,a} or {25,25,25,255}
    local clr2 = vars.manual_dir == 90 and {r,g,b,a} or {25,25,25,255}
    local fflags = (style == '1' or style == '4') and 'c+' or 'c'
    
    renderer.text(x - math.floor(dst) - 60, y, clr[1],clr[2],clr[3],clr[4], fflags, 0, arrows_l)
    renderer.text(x + math.floor(dst) + 60, y, clr2[1],clr2[2],clr2[3],clr2[4], fflags, 0, arrows_r)
    local inverter = math.floor(anti_aim.get_desync(2)) <= 0
    if style == '4' then
        local clr_4 = inverter and {r,g,b,a} or {25,25,25,255}
        local clr2_4 = not inverter and {r,g,b,a} or {25,25,25,255}
        renderer.rectangle(x - math.floor(dst) - 50,y - 4, 2,15, clr_4[1],clr_4[2],clr_4[3],clr_4[4])
        renderer.rectangle(x + math.floor(dst) + 50,y - 4, 2,15, clr2_4[1],clr2_4[2],clr2_4[3],clr2_4[4])
    end
    
end

local hitlogs = (function ()
    local M = {}
    local _menu = menu.visuals.hitlog
    local default = {255,255,255,255}

    local x,y = center[1],center[2]
    local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
    function M.aim_hit(e)
        local hit_clr = _menu.hit_clr.color.value
        local simple = _menu.style.value
        local _events = _menu.enable.value
        local hit_group = hitgroup_names[e.hitgroup + 1] or '?'
        local damage = e.damage
        local name = entity.get_player_name(e.target)
        local health = entity.get_prop(e.target, 'm_iHealth')

        local hit_args = {
            {
                text = 'Hit ',
                color = hit_clr
            },
            {
                text = name..'\'s ',
                color = default
            },
            {
                text = hit_group,
                color = hit_clr
            },
            {
                text = ' for ',
                color = default
            },
            {
                text = damage,
                color = hit_clr
            },
            {
                text = ' damage (',
                color = default
            },
            {
                text = health,
                color = hit_clr
            },
            {
                text = ' hp remaining)',
                color = default
            },
        }
        local console_log = {
            {hit_clr[1],hit_clr[2],hit_clr[3],'Hit '},
            {255,255,225,name..'\'s '},
            {hit_clr[1],hit_clr[2],hit_clr[3],hit_group},
            {255,255,225,' for '},
            {hit_clr[1],hit_clr[2],hit_clr[3],damage},
            {255,255,225,' damage ( '},
            {hit_clr[1],hit_clr[2],hit_clr[3],health},
            {255,255,225,' hp remaining )'},
        }

        if table.find(_events,'Console') then
            Color_print(console_log)
        end
        if table.find(_events,'On Screen') then
            notify:add(hit_args,4,not simple)
        end

    end
    function M.aim_miss(e)
        local miss_clr = _menu.miss_clr.color.value
        local simple = _menu.style.value
        local _events = _menu.enable.value
        local name = entity.get_player_name(e.target)
        local hit_group = hitgroup_names[e.hitgroup + 1] or '?'
        local reason = e.reason

        local miss_args = {
            {
                text = 'Miss ',
                color = miss_clr
            },
            {
                text = name..'\'s ',
                color = default,
            },
            {
                text = hit_group,
                color = miss_clr
            },
            {
                text = ' due to ',
                color = default,
            },
            {
                text = reason,
                color = miss_clr
            },
        }
        local console_log = {
            {miss_clr[1],miss_clr[2],miss_clr[3],'Miss '},
            {255,255,255,name..'\'s '},
            {miss_clr[1],miss_clr[2],miss_clr[3],hit_group},
            {255,255,255,' due to '},
            {miss_clr[1],miss_clr[2],miss_clr[3],reason},
        }

        if table.find(_events,'Console') then
            Color_print(console_log)
        end
        if table.find(_events,'On Screen') then
            notify:add(miss_args,4,not simple)
        end
        
    end
    return M
end)()


-- #endregion


-- #region 杂项功能


local animation_hook = (function ()
    local M = {}

    function M.land(cmd)
        
        if table.find(menu.main.animations.value,'Leg movement') then
            if menu.main.leg_in_land.value == 'OG' then
                cheat_refs.leg_movement:override(cmd.command_number % 3 == 0 and 'Off' or 'Always slide')
            end
        end

    end

    function M.Setup()

        local lp = entity.get_local_player()
        if not lp or not entity.is_alive(lp) then
            return
        end

        local lp_index = c_entity.new(lp)

        local lp_anim_state = lp_index:get_anim_state()

        if not lp_anim_state then
            return
        end


        if table.find(menu.main.animations.value,'Leg movement') then
            if menu.main.leg_in_air.value == 'Static' then
                entity.set_prop(lp, "m_flPoseParameter", 1, vars.E_POSE_PARAMETERS.JUMP_FALL)
            elseif menu.main.leg_in_air.value == 'Allah walk' then
                if vars.p_flags.is_air() then
                    local anim_overlay = lp_index:get_anim_overlay(6)
                    if not anim_overlay then
                        return
                    end
                    if vars.p_flags.velocity() >=3 then
                        anim_overlay.weight = 1
                    end
    
                end
                cheat_refs.leg_movement:override(vars.p_flags.is_air() and 'Never slide' or 'Off')
            end
            if menu.main.leg_in_land.value == 'OG' then
                entity.set_prop(lp, "m_flPoseParameter", vars.E_POSE_PARAMETERS.STAND, globals.tickcount() % 4 > 1 and menu.main.leg_in_land_val.value / 10 or 1)
            elseif menu.main.leg_in_land.value == 'Allah walk' then
                if vars.p_flags.velocity() >=3 then
                    entity.set_prop(lp, "m_flPoseParameter", 0, 7)
                end
                cheat_refs.leg_movement:override('Never slide')
            else
                cheat_refs.leg_movement:override('Off')
            end
        end

        if table.find(menu.main.animations.value,'Adjust body lean') then
            local anim_overlay = lp_index:get_anim_overlay(12)
            if not anim_overlay then
                return
            end

            if vars.p_flags.velocity() >=3  then
                anim_overlay.weight = menu.main.body_lean.value / 100
            end
        end

        if table.find(menu.main.animations.value,'Pitch zero on land') then
            if not lp_anim_state.hit_in_ground_animation or not vars.p_flags.is_ground() then
                return
            end

            entity.set_prop(lp, "m_flPoseParameter", 0.5, vars.E_POSE_PARAMETERS.BODY_PITCH)
        end

    end

    return M
end)()


local function anti_backstab()

    if menu.main.anti_knife.value then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), 'm_vecOrigin')
        local yaw_slider = cheat_refs.aa.yaw[2]
        local default_yaw = yaw_slider.value
        local should_reset_yaw = true
        for i=1, #players do
    
            local x, y, z = entity.get_prop(players[i], 'm_vecOrigin')
            local distance = Get_distance(lx, ly, lz, x, y, z)
            
            local weapon = entity.get_player_weapon(players[i])
    
            if entity.get_classname(weapon) == 'CKnife' and distance <= 180 then
                yaw_slider:override(180)
            end
        end
    end

end

local function onshot_fix()

    local is_dt = cheat_refs.dt.value and cheat_refs.dt:get_hotkey()
    if menu.main.hs_fix.value then
        if cheat_refs.onshot.value and cheat_refs.onshot:get_hotkey() and not is_dt then
            cheat_refs.fakelag_limit:override(1)
        else
            cheat_refs.fakelag_limit:override()
        end
    else
        cheat_refs.fakelag_limit:override()
    end

end

local function disable_blur()
    cvar['@panorama_disable_blur']:set_raw_int(master_switcher.value and 1 or 0)
end
master_switcher:set_callback(disable_blur)


-- #endregion

-- #region 菜单处理

local function og_menu(state)

    local lua_text = animation.text('--> o Crucifix-tech o <--',-6,255,183,99,255,2)
    ui.set(switcher_label.ref,lua_text)

    ui.traverse(cheat_refs.aa, function (element)
        if element.hotkey ~= nil then
            ui.set_visible(element.hotkey.ref,state)
        end
        ui.set_visible(element.ref,state)
    end)
end


local function handle_ui()

    local master = {master_switcher,true}
    menu.tabs:depend(master)
    -- ui.traverse(cheat_refs.aa, function (element)
    --     element:depend({menu.tabs,'--'})
    -- end)
    ui.traverse(menu.keybinds, function (element)
        element:depend({menu.tabs,'-'},master)
    end)
    ui.traverse(menu.main, function (element)
        element:depend({menu.tabs,'Staple menu'},master)
    end)
    ui.traverse(menu.antiaim, function (element)
        element:depend({menu.tabs,'Anti-aimbot'},master)
    end)
    ui.traverse(menu.visuals, function (element)
        element:depend({menu.tabs,'Screen elements'},master)
    end)
    ui.traverse(menu.config, function (element)
        element:depend({menu.tabs,'Config manager'},master)
    end)

    menu.keybinds.fs_disabler:depend({menu.keybinds.fs,true})
    menu.main.body_lean:depend({menu.main.animations,'Adjust body lean'})
    menu.main.leg_in_land:depend({menu.main.animations,'Leg movement'})
    menu.main.leg_in_land_val:depend({menu.main.animations,'Leg movement'},{menu.main.leg_in_land,'OG'})
    menu.main.leg_in_air:depend({menu.main.animations,'Leg movement'})

    menu.main.tp_lethal:depend({master_switcher,false})

    menu.visuals.watermark.simple:depend({menu.visuals.watermark.enable,true})
    menu.visuals.watermark.position:depend({menu.visuals.watermark.enable,true})
    menu.visuals.center.offset:depend({menu.visuals.center.enable,true})
    menu.visuals.center.offset_val:depend({menu.visuals.center.enable,true},{menu.visuals.center.offset,1,2})
    menu.visuals.center.offset_val_y:depend({menu.visuals.center.enable,true})
    menu.visuals.arrows.style:depend({menu.visuals.arrows.enable,true})
    menu.visuals.arrows.distance:depend({menu.visuals.arrows.enable,true})
    menu.visuals.hitlog.style:depend({menu.visuals.hitlog.enable,'On Screen'})
    menu.visuals.hitlog.hit_clr:depend({menu.visuals.hitlog.enable,function () return #menu.visuals.hitlog.enable.value > 0 end})
    menu.visuals.hitlog.miss_clr:depend({menu.visuals.hitlog.enable,function () return #menu.visuals.hitlog.enable.value > 0 end})

    for i ,n in pairs(vars.states) do
        local _menu = menu.antiaim

        local show = {{master_switcher,true},{menu.tabs,'Anti-aimbot'},{menu.antiaim.states,n},{_menu[i].enable,true}}
        for k , v in pairs(_menu[i]) do
            if k ~= 'enable' then
                v:depend(unpack(show))
            end
            _menu[i].enable:depend(unpack(show,3),{menu.antiaim.states,function () return menu.antiaim.states.value ~= 'Global' end})
            ui.set(_menu[1].enable.ref,true)
            _menu[i].yaw_val:depend({_menu[i].yaw,'Customize','3-Way','5-Way'})
            _menu[i].yaw_val_random:depend({_menu[i].yaw,'Randomzier Min/Max'})
            _menu[i].yaw_val_l:depend({_menu[i].yaw,'Left/Right -/+','Randomzier Min/Max'})
            _menu[i].yaw_val_r:depend({_menu[i].yaw,'Left/Right -/+','Randomzier Min/Max'})
            _menu[i].yaw_jitter_val:depend({_menu[i].yaw_jitter,'Center','Skitter','3-Way','5-Way'})
            _menu[i].yaw_jitter_val_random:depend({_menu[i].yaw_jitter,'Randomzier Min/Max'})
            _menu[i].yaw_jitter_val_l:depend({_menu[i].yaw_jitter,'Left/Right -/+','Randomzier Min/Max'})
            _menu[i].yaw_jitter_val_r:depend({_menu[i].yaw_jitter,'Left/Right -/+','Randomzier Min/Max'})
            _menu[i].body_yaw_val:depend({_menu[i].body_yaw,'Jitter','Static'})
            
        end
    end

end
handle_ui()

-- #endregion

-- #region 事件回调处理


local events_callback = {
    paint = function ()
        local lp = entity.get_local_player()
        if lp == nil then return end
        watermark()
        if entity.is_alive(lp) then
            center_indicator(lp)
            desync_arrows()
        end

        notify:register()
    end,
    setup_command = function (cmd)
        local lp = entity.get_local_player()
        if lp == nil then return end
        onshot_fix()
        tp.lethal(lp)
        run_antiaim(cmd)
        animation_hook.land(cmd)
    end,
    run_command = function ()
        anti_backstab()
    end,
    pre_render = function ()
        animation_hook.Setup()
    end,
    aim_fire = function ()
        vars.last_shot = globals.curtime()
        if cheat_refs.dt.value and cheat_refs.dt:get_hotkey() and menu.main.tp_lethal.value then
            cheat_refs.dt.hotkey:override('On hotkey')
            cheat_refs.dt:override(false)
        end
    end,
    aim_hit = function (e)
        hitlogs.aim_hit(e)
    end,
    aim_miss = function (e)
        hitlogs.aim_miss(e)
    end,
    paint_ui = function ()
        og_menu(false)
    end,
    shutdown = function ()
        og_menu(true)
    end

}

local function init()
    client.exec("clear")
    client.set_event_callback('paint',events_callback.paint)
    client.set_event_callback('setup_command',events_callback.setup_command)
    client.set_event_callback('paint_ui',events_callback.paint_ui)
    client.set_event_callback('shutdown',events_callback.shutdown)
    client.set_event_callback('pre_render', events_callback.pre_render)
    client.set_event_callback('aim_hit', events_callback.aim_hit)
    client.set_event_callback('aim_miss', events_callback.aim_miss)
    client.set_event_callback('run_command', events_callback.run_command)
end
init()

-- #endregion