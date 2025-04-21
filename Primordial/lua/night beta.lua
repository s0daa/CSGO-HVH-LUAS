local ffi = require('ffi')
if not LPH_OBFUSCATED or LPH_OBFUSCATED == nil then
    LPH_ENCSTR = function (...) return ... end
    LPH_NO_VIRTUALIZE = function (...) return ... end
    LPH_JIT_MAX = function (...) return ... end
    LPH_CRASH = function (...) print('Triggered self-descruction and crash of VM') end
end
local events = {};
events.add = function (callback, fn, other)
    return callbacks.add(callback, LPH_JIT_MAX(function (...)
        fn(...)
    end), other)
end
LPH_NO_VIRTUALIZE(function()
local info = {
    script = 'night',
    build = 'dev',
    name = 'admin',
}
local redifine = function(t)
    local c = {}; for k, v in next, t do c[k] = v end
    return c
end;
local math, table, string, render, ffi, menu, antiaim, entity_list = redifine(math), redifine(table), redifine(string),
    redifine(render), redifine(ffi), redifine(menu), redifine(antiaim), redifine(entity_list);
math.round = function(value, decimals)
    value = value or 255
    local multiplier = 10.0 ^ (decimals or 0.0)
    return math.floor(value * multiplier + 0.5) / multiplier
end
local vector = function(x, y, z) if z then return vec3_t(x, y, z) else return vec2_t(x, y) end end;
local color = function(...)
    local args = { ... }
    if type(args[1]) == 'number' then
        return color_t(math.round(args[1]), math.round(args[2]), math.round(args[3]),
            math.round(args[4]) ~= nil and math.round(args[4]) or 255)
    end
    if type(args[1]) == 'string' then
        args[1] = args[1]:gsub('#', '')
        local r, g, b, a = tonumber('0x' .. args[1]:sub(1, 2)), tonumber('0x' .. args[1]:sub(3, 4)),
            tonumber('0x' .. args[1]:sub(5, 6)),
            tonumber('0x' .. args[1]:sub(7, 8))
        return color_t(r, g, b, a)
    end
end
local logger = {}; do
    logger.accent = color(200, 225, 255);
    ffi.cdef [[ struct c_color { unsigned char clr[4]; }; ]];
    logger.print = function(text, clr)
        local console_color = ffi.new("struct c_color")
        local engine_cvar = ffi.cast("void***", memory.create_interface("vstdlib.dll", "VEngineCvar007"))
        local console_print = ffi.cast("void(__cdecl*)(void*, const struct c_color&, const char*, ...)",
            engine_cvar[0][25])
        clr = clr or color(255, 255, 255, 255)
        console_color.clr[0] = clr.r or 255
        console_color.clr[1] = clr.g or 255
        console_color.clr[2] = clr.b or 255
        console_color.clr[3] = clr.a or 255
        return console_print(engine_cvar, console_color, text)
    end
    logger.log = function(color, ...)
        logger.print('night • ', logger.accent)
        logger.print(string.format('%02d:%02d:%02d • ', client.get_local_time()))
        logger.print(tostring(...), color)
        logger.print('\n')
        return
    end
end
local ui, c_ui, c_path, helper, clipboard = {}, {}, {}, {}, {};
local include
do
    antiaim.state = 1;
    antiaim.side = -1;
    antiaim.is_inverted = false;
    antiaim.tickbase_max = 0;
    antiaim.is_defensive = false;
    antiaim.defensive_ticks = 0;
    local function vtable_thunk(index, ...)
        local ctype = ffi.typeof(...); return function(instance, ...)
            assert(instance ~= nil, 'invalid instance'); local vtable = ffi.cast('void***', instance); local vfunc = ffi
                .cast(ctype, vtable[0][index]); return vfunc(instance, ...);
        end
    end
    local function vtable_bind(module_name, interface_name, index, ...)
        local addr = memory.create_interface(module_name, interface_name); assert(addr, 'invalid interface'); local ctype =
            ffi.typeof(...); local vtable = ffi.cast('void***', addr); local vfunc = ffi.cast(ctype, vtable[0][index]); return function(...)
            return
                vfunc(vtable, ...);
        end
    end
    local GetClipboardTextCount = vtable_bind('vgui2.dll', 'VGUI_System010', 7, 'int(__thiscall*)(void*)')
    local SetClipboardText = vtable_bind('vgui2.dll', 'VGUI_System010', 9, 'void(__thiscall*)(void*, const char*, int)')
    local GetClipboardText = vtable_bind('vgui2.dll', 'VGUI_System010', 11,
        'int(__thiscall*)(void*, int, const char*, int)')
    function clipboard.set(...)
        local text = tostring(table.concat({ ... }))
        SetClipboardText(text, string.len(text))
    end

    function clipboard.get()
        local len = GetClipboardTextCount()
        if len > 0 then
            local char_arr = ffi.typeof('char[?]')(len)
            GetClipboardText(0, char_arr, len)
            local text = ffi.string(char_arr, len - 1)
            return text
        end
    end

    math.lerp = function(a, b, t) return a + t * (b - a) end
    math.lerp_color = function(clr1, clr2, t)
        return color(math.round(math.flerp(clr1.r, clr2.r, t)),
            math.round(math.flerp(clr1.g, clr2.g, t)), math.round(math.flerp(clr1.b, clr2.b, t)),
            math.round(math.flerp(clr1.a, clr2.a, t)))
    end;
    math.clamp = function(x, min, max)
        if x < min then return min end
        if x > max then return max end
        if x == nil then return min end
        return x
    end
    helper.get_threat = function()
        local me = entity_list.get_local_player();
        if not me or not me:is_alive() or me == nil then return end

        local my_origin = me:get_render_origin();
        local threat, distance = nil, math.huge

        for _, player in pairs(entity_list.get_players(true)) do
            local player_origin = player:get_render_origin();
            if player_origin ~= vector(0, 0, 0) and player:is_alive() and player ~= nil then
                local dist = my_origin:dist(player_origin)
                if dist < distance then
                    distance = dist
                    threat = player
                end
            end
        end
        return threat
    end
    helper.original_render_text = render.text;
    helper.original_text_size = render.get_text_size;
    helper.color_to_hex = function(c) return string.format('%02x%02x%02x%02x', c.r, c.g, c.b, c.a) end;
    helper.color_to_rgba = function(c)
        c = c:gsub('#', '')
        return tonumber('0x' .. c:sub(1, 2)), tonumber('0x' .. c:sub(3, 4)), tonumber('0x' .. c:sub(5, 6)),
            tonumber('0x' .. c:sub(7, 8))
    end
    helper.alpha_modulate = function(c, a) return color(c.r, c.g, c.b, a) end;
    helper.breath = function(x)
        x = x % 2.0

        if x > 1.0 then
            x = 2.0 - x
        end

        return x
    end
    helper.u8 = function(s)
        return string.gsub(s, '[\128-\191]', '')
    end
    helper.gradient = function(s, clock, clr1, clr2)
        local buffer = {}

        local len = #helper.u8(s)
        local div = 1 / (len - 1)

        local add_r = clr2.r - clr1.r
        local add_g = clr2.g - clr1.g
        local add_b = clr2.b - clr1.b
        local add_a = clr2.a - clr1.a

        for char in string.gmatch(s, '.[\128-\191]*') do
            local t = helper.breath(clock)

            local r = clr1.r + add_r * t
            local g = clr1.g + add_g * t
            local b = clr1.b + add_b * t
            local a = clr1.a + add_a * t
            buffer[#buffer + 1] = '\a'
            buffer[#buffer + 1] = helper.color_to_hex(color(math.round(r), math.round(g), math.round(b), math.round(a)))
            buffer[#buffer + 1] = char

            clock = clock - div
        end

        return table.concat(buffer)
    end
    render.get_text_size = function(id, text)
        local s = text:gsub('\a(%x%x%x%x%x%x%x%x)', '')
        local size = helper.original_text_size(id, s)
        return size
    end;
    render.text = function(font, str, pos, clr, align_h)
        local x = pos.x;
        local y = pos.y;
        if string.len(str) == 0 then return end
        if align_h then
            local txt_w = render.get_text_size(font, str)
            x = x - txt_w.x / 2
        end
        local start, _end = string.find(str, '\a(%x%x%x%x%x%x%x%x)')
        if start then
            if start ~= 1 then
                local renderString = str:sub(0, start - 1)
                helper.original_render_text(font, renderString, vector(x, y), clr)
                local textSize = helper.original_text_size(font, renderString)
                str = str:sub(start, str:len())
                render.text(font, str, vector(x + textSize.x, y), clr)
            else
                local stringEnd = str:len()
                local renderString = str:sub(_end + 1, stringEnd)
                local secondSearch, secondEnd = str.find(renderString, '\a(%x%x%x%x%x%x%x%x)')
                if secondSearch then
                    renderString = str:sub(_end + 1, secondEnd)
                    stringEnd = secondEnd
                end
                local hexCode = str:sub(start + 1, stringEnd)
                clr = color(helper.color_to_rgba('#' .. hexCode))
                helper.original_render_text(font, renderString, vector(x, y), clr)
                local textSize = helper.original_text_size(font, renderString)
                str = str:sub(stringEnd + 1, str:len())
                render.text(font, str, vector(x + textSize.x, y), clr)
            end
        else
            helper.original_render_text(font, str, vector(x, y), clr)
        end;
    end;
end

local lib = {}; do
    clipboard = {}; do
        ffi.cdef [[ typedef int(__thiscall* get_clipboard_text_count)(void*); typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int); typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);]]
        clipboard.VGUI_System_dll = memory.create_interface('vgui2.dll', 'VGUI_System010')
        clipboard.VGUI_System = ffi.cast(ffi.typeof('void***'), clipboard.VGUI_System_dll)
        clipboard.get_clipboard_text_count = ffi.cast('get_clipboard_text_count',
            clipboard.VGUI_System[0][7])
        clipboard.get_clipboard_text = ffi.cast('get_clipboard_text', clipboard.VGUI_System[0][11])
        clipboard.set_clipboard_text = ffi.cast('set_clipboard_text', clipboard.VGUI_System[0][9])

        function clipboard:set(...)
            return clipboard.set_clipboard_text(clipboard.VGUI_System, ..., (...):len());
        end;

        function clipboard:get()
            local clipboard_text_length = clipboard.get_clipboard_text_count(clipboard.VGUI_System);
            if clipboard_text_length > 0 then
                local buffer = ffi.new('char[?]', clipboard_text_length);
                local size = clipboard_text_length * ffi.sizeof('char[?]', clipboard_text_length);
                clipboard.get_clipboard_text(clipboard.VGUI_System, 0, buffer, size);
                return tostring(ffi.string(buffer, clipboard_text_length - 1));
            else
                return '';
            end;
        end;
    end;

    base64 = {}; do
        base64.makeencoder     = function(alphabet)
            local encoder = {}
            local t_alphabet = {}
            for i = 1, #alphabet do
                t_alphabet[i - 1] = alphabet:sub(i, i)
            end
            for b64code, char in pairs(t_alphabet) do
                encoder[b64code] = char:byte()
            end
            return encoder
        end
        base64.makedecoder     = function(alphabet)
            local decoder = {}
            for b64code, charcode in pairs(base64.makeencoder(alphabet)) do
                decoder[charcode] = b64code
            end
            return decoder
        end

        base64.DEFAULT_ENCODER = base64.makeencoder(
            'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=')
        base64.DEFAULT_DECODER = base64.makedecoder(
            'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=')
        base64.CUSTOM_ENCODER  = base64.makeencoder(
            'KmAWpuFBOhdbI1orP2UN5vnSJcxVRgazk97ZfQqL0yHCl84wTj3eYXiD6stEGM+/=')
        base64.CUSTOM_DECODER  = base64.makedecoder(
            'KmAWpuFBOhdbI1orP2UN5vnSJcxVRgazk97ZfQqL0yHCl84wTj3eYXiD6stEGM+/=')
        local extract          = function(v, from, width)
            return bit.band(bit.rshift(v, from), bit.lshift(1, width) - 1)
        end
        base64.encode          = function(str, encoder, usecaching)
            str = tostring(str)
            encoder = encoder or base64.CUSTOM_ENCODER
            local t, k, n = {}, 1, #str
            local lastn = n % 3
            local cache = {}
            for i = 1, n - lastn, 3 do
                local a, b, c = str:byte(i, i + 2)
                local v = a * 0x10000 + b * 0x100 + c
                local s
                if usecaching then
                    s = cache[v]
                    if not s then
                        s = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder
                            [extract(v, 6, 6)], encoder[extract(v, 0, 6)])
                        cache[v] = s
                    end
                else
                    s = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[extract(v, 6, 6)],
                        encoder[extract(v, 0, 6)])
                end
                t[k] = s
                k = k + 1
            end
            if lastn == 2 then
                local a, b = str:byte(n - 1, n)
                local v = a * 0x10000 + b * 0x100
                t[k] = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[extract(v, 6, 6)],
                    encoder[64])
            elseif lastn == 1 then
                local v = str:byte(n) * 0x10000
                t[k] = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[64], encoder[64])
            end
            return table.concat(t)
        end
        base64.decode          = function(b64, decoder, usecaching)
            decoder = decoder or base64.CUSTOM_DECODER
            local pattern = "[^%w%+%/%=]"
            if decoder then
                local s62, s63
                for charcode, b64code in pairs(decoder) do
                    if b64code == 62 then
                        s62 = charcode
                    elseif b64code == 63 then
                        s63 = charcode
                    end
                end
                pattern = ("[^%%w%%%s%%%s%%=]"):format(string.char(s62), string.char(s63))
            end
            b64 = b64:gsub(pattern, "")
            local cache = usecaching and {}
            local t, k = {}, 1
            local n = #b64
            local padding = b64:sub(-2) == "==" and 2 or b64:sub(-1) == "=" and 1 or 0
            for i = 1, padding > 0 and n - 4 or n, 4 do
                local a, b, c, d = b64:byte(i, i + 3)
                local s
                if usecaching then
                    local v0 = a * 0x1000000 + b * 0x10000 + c * 0x100 + d
                    s = cache[v0]
                    if not s then
                        local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40 + decoder[d]
                        s = string.char(extract(v, 16, 8), extract(v, 8, 8), extract(v, 0, 8))
                        cache[v0] = s
                    end
                else
                    if decoder[a] == nil or decoder[b] == nil or decoder[c] == nil or decoder[d] == nil then
                        return nil
                    end
                    local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40 + decoder[d]
                    s = string.char(extract(v, 16, 8), extract(v, 8, 8), extract(v, 0, 8))
                end
                t[k] = s
                k = k + 1
            end
            if padding == 1 then
                local a, b, c = b64:byte(n - 3, n - 1)
                local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40
                t[k] = string.char(extract(v, 16, 8), extract(v, 8, 8))
            elseif padding == 2 then
                local a, b = b64:byte(n - 3, n - 2)
                local v = decoder[a] * 0x40000 + decoder[b] * 0x1000
                t[k] = string.char(extract(v, 16, 8))
            end
            return table.concat(t)
        end
    end
end


table.get_new_index = function(t, type)
    local new_i = #t; if t[new_i + 1] == nil then
        t = type or 0
        return new_i + 1
    end
end
table.to_string = function(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        if type(k) == "string" then
            result = result .. '[\'' .. k .. '\']' .. '='
        end

        if type(v) == "table" then
            result = result .. table.to_string(v)
        elseif type(v) == "boolean" then
            result = result .. tostring(v)
        elseif type(v) == "number" then
            result = result .. tostring(v)
        else
            result = result .. '\'' .. v .. '\''
        end
        result = result .. ','
    end

    if result ~= "" then
        result = result:sub(1, result:len() - 1)
    end
    return result .. "}"
end
ui = {}; do
    ui.group = {}; ui.group.__index = ui.group; do
        function ui.create(...)
            local group = {
                group = tostring(...):upper(),
                saveable = false,
                type = 'group_t'
            }
            return setmetatable(group, ui.group)
        end

        function ui.group:visible(...)
            return menu.set_group_visibility(self.group, ...)
        end

        function ui.group:tab(...)
            return menu.set_group_column(self.group, ...)
        end
    end
    ui.elements = { data = {} }; ui.elements.__index = ui.elements; do
        ui.elements.new = function(data)
            local i = table.get_new_index(ui.elements.data)
            ui.elements.data[i] = data
            return setmetatable(ui.elements.data[i], ui.elements)
        end

        function ui.group:switch(name, value)
            value = value or false
            return ui.elements.new({
                type = 'checkbox',
                class = 'all',
                item = menu.add_checkbox(self.group, name, value),
                uniq = string.format('%s:%s:%s:%s', 'checkbox', 'cLssall', self.group, name)
            })
        end

        function ui.group:combo(name, items, visible)
            visible = visible or #items
            return ui.elements.new({
                type = 'selection',
                class = 'all',
                item = menu.add_selection(self.group, name, items, visible),
                uniq = string.format('%s:%s:%s:%s', 'selection', 'cLssall', self.group, name)
            })
        end

        function ui.group:multicombo(name, items, visible)
            visible = visible or #items
            return ui.elements.new({
                type = 'multi_selection',
                class = 'all',
                item = menu.add_multi_selection(self.group, name, items, visible),
                uniq = string.format('%s:%s:%s:%s', 'multi_selection', 'cLssall', self.group, name)
            })
        end

        function ui.group:slider(name, min, max, step, precision, suffix, value)
            min, max, step, precision, suffix = min or 0, max or 100, step or 1, precision or 0, suffix or ''
            local data = ui.elements.new({
                type = 'slider',
                class = 'all',
                item = menu.add_slider(self.group, name, min, max, step, precision, suffix),
                uniq = string.format('%s:%s:%s:%s', 'slider', 'cLssall', self.group, name)
            }); data:set(value or 0)
            return data
        end

        function ui.group:button(name, fn)
            return ui.elements.new({
                type = 'button',
                class = 'all',
                item = menu.add_button(self.group, name, fn or function() end),
                uniq = string.format('%s:%s:%s:%s', 'button', 'cLssall', self.group, name)
            })
        end

        function ui.group:list(name, items, visible)
            visible = visible or #items
            return ui.elements.new({
                type = 'list',
                class = 'all',
                item = menu.add_list(self.group, name, items, visible),
                uniq = string.format('%s:%s:%s:%s', 'list', 'cLssall', self.group, name)
            })
        end

        function ui.group:separator()
            return menu.add_separator(self.group)
        end

        function ui.group:label(name)
            return setmetatable({
                item = menu.add_text(self.group, name),
                type = 'label'
            }, ui.elements)
        end

        function ui.elements:keybind(name)
            return self.item:add_keybind(name or '')
        end

        function ui.elements:color(name)
            return setmetatable({
                type = 'color_picker',
                class = 'all',
                item = self.item:add_color_picker(''),
                uniq = string.format('%s:%s:%s:%s', 'color_picker', 'cLssall', name, 'CFG')
            }, ui.elements)
        end

        function ui.elements:get(...)
            return self.item:get(...)
        end

        function ui.elements:get_item_name()
            return self.item:get_item_name()
        end

        function ui.elements:get_items()
            return self.item:get_items()
        end

        function ui.elements:get_items_value()
            local new_v = {}; for _, v in pairs(self.item:get_items()) do
                new_v[v] = self.item:get(v)
            end
            return new_v
        end

        function ui.elements:get_clr_t()
            local v = self.item:get()
            return {
                r = v.r,
                g = v.g,
                b = v.b,
                a = v.a
            }
        end

        function ui.elements:get_type()
            return self.type
        end

        function ui.elements:get_class()
            return self.class
        end

        function ui.elements:get_active_item_name()
            return self.item:get_active_item_name()
        end

        function ui.elements:set(value)
            return self.item:set(value)
        end

        function ui.elements:visible(...)
            return self.item:set_visible(...)
        end

        function ui.elements:set_items(value)
            return self.item:set_items(value)
        end

        function ui.elements:add_item(value)
            return self.item:add_item(value)
        end

        function ui.elements:set_items_value(value_t)
            for k, v in pairs(value_t) do
                self.item:set(k, v)
            end
        end

        function ui.elements:set_class(class)
            class = class or 'all'
            if not self.class then
                return
            end
            self.uniq = string.gsub(self.uniq, 'cLss' .. self.class, 'cLss' .. class)
            self.class = class
        end

        function ui.elements:set_clr_t(value_t)
            self.item:set(value_t)
        end

        function ui.elements:alpha_modulate(value)
            local v = self.item:get()
            self.item:set(color(v.r, v.g, v.b, value or v.a))
        end

        ui.group.save = function(type, class)
            type = type or nil

            local data = {}; for _, v in pairs(ui.elements.data) do
                if v.type == 'button' or v.type == 'list' or v.type == 'label' then
                    goto proceed
                end

                if ((type == nil) and true or (v.type == type)) and ((class == nil) and true or (v.class == class)) then
                    local value
                    if v.type == 'multi_selection' then
                        value = v:get_items_value()
                    elseif v.type == 'color_picker' then
                        value = v:get_clr_t()
                    else
                        value = v.item:get()
                    end
                    table.insert(data, {
                        type = v.type,
                        class = v.class,
                        value = value,
                        uniq = v.uniq
                    })
                end

                ::proceed::
            end

            print('SAVE size -', #data)

            return data
        end

        ui.group.load = function(data, type, class, rewrite_class)
            type = type or nil

            local count = 0
            for _, ui_v in pairs(ui.elements.data) do
                if ui_v.type == 'button' then
                    goto proceed
                end
                for _, s_v in pairs(data) do
                    if rewrite_class ~= nil then
                        local item_name = s_v.uniq:sub(s_v.uniq:find(':', s_v.uniq:find(':') + 1) + 1,
                            s_v.uniq:len(s_v.uniq))
                        s_v.uniq = string.format('%s:cLss%s:%s', s_v.type, rewrite_class, item_name)

                        s_v.class = rewrite_class
                        class = rewrite_class
                    end

                    if ((ui_v.uniq == s_v.uniq) and ((type == nil) and true or (s_v.type == type)) and ((class == nil) and true or (s_v.class == class))) then
                        if ui_v.type == 'multi_selection' then
                            ui_v:set_items_value(s_v.value)
                        elseif ui_v.type == 'color_picker' then
                            local v = s_v.value
                            ui_v.item:set(color(v.r, v.g, v.b, v.a))
                        else
                            ui_v.item:set(s_v.value)
                        end
                        count = count + 1
                    end
                end

                ::proceed::
            end
        end
        ui.font = render.create_font('Arial', 12, 400)
        ui.group.text_alignment = function(text, alignment)
            alignment = alignment or 'center'
            if alignment == 'center' then
                local space = '                                '
                local size = render.get_text_size(ui.font, text)
                return string.format('%s%s', space:sub(1, space:len() - math.round(size.x / 5.5)), text)
            elseif alignment == 'left' then
                return ''
            elseif alignment == 'right' then
                local space = '                                                           '
                return string.format('%s%s', space:sub(1, space:len() - text:len()), text)
            end
        end

        ui.group.save_as_string = function(type, class)
            return base64.encode(string.format('CFG:%s', table.to_string(ui.group.save(type, class))))
        end

        ui.group.load_string = function(string, type, class, rewrite_class)
            local str = string
            if not str then
                return print('Clipboard is nil.')
            end; str = base64.decode(str)

            if not string.find(str, 'CFG:') then
                return print('Invalid clipboard.')
            end

            str = string.gsub(str, 'CFG:', '')
            ui.group.load(loadstring('return ' .. str:gsub('(\'.-\'):(.-),', '[%1]=%2,\n'))(), type, class,
                rewrite_class)
        end

        ui.export = function(type, class)
            clipboard:set(ui.group.save_as_string(type, class))
        end

        ui.import = function(string, type, class, rewrite_class)
            ui.group.load_string(string, type, class, rewrite_class)
        end
    end
end



local animation = {}
do
    animation.data = {}
    animation.antiaim = {}
    function animation:spin(key, from, to, speed, iterations, initial_value)
        self.antiaim[key] = self.antiaim[key] or {
            active = 0,
            method = 'spin',
            start = math.min(from, to),
            target = math.max(from, to),
            speed = speed or 4,
            iterations = iterations or 1,
            value = initial_value or from
        }

        local this = self.antiaim[key]

        this.start, this.target = math.min(from, to), math.max(from, to)
        this.speed, this.iterations = speed, iterations

        return this
    end

    function animation:flick(key, from, to, speed, initial_value)
        self.antiaim[key] = self.antiaim[key] or {
            active = 0,
            method = 'flick',
            start = math.min(from, to),
            target = math.max(from, to),
            speed = speed or 4,
            value = initial_value or from
        }

        local this = self.antiaim[key]

        this.start, this.target = math.min(from, to), math.max(from, to)
        this.speed = speed

        return this
    end

    function animation:tick(tick)
        for key, state in pairs(self.antiaim) do
            if state.method == 'spin' then
                local difference = tick - state.active

                if difference > state.speed or math.abs(difference) > 64 then
                    for i = 1, state.iterations do
                        if state.value < state.target then
                            state.value = state.value + 1
                        else
                            state.value = state.start
                        end
                    end

                    state.active = tick
                end
            end
            if state.method == 'flick' then
                local difference = tick - state.active

                if difference > state.speed or math.abs(difference) > 64 then
                    state.increasing = not state.increasing
                    state.value = state.increasing and state.start or state.target
                    state.active = tick
                end
            end
        end
    end

    animation.process = function(self, name, bool, time)
        if not self.data[name] then
            self.data[name] = 0
        end

        local animation = globals.frame_time() * (bool and 1 or -1) * (time or 4)
        self.data[name] = math.clamp(self.data[name] + animation, 0, 1)
        return self.data[name]
    end
    function animation.lerp(x, v, t)
        if type(x) == 'table' then
            return animation.lerp(x[1], v[1], t), animation.lerp(x[2], v[2], t), animation.lerp(x[3], v[3], t),
                animation.lerp(x[4], v[4], t)
        end

        local delta = v - x

        if type(delta) == 'number' then
            if math.abs(delta) < 0.005 then
                return v
            end
        end

        return delta * t + x
    end

    helper.get_weapon_group = function()
        if ragebot.get_active_cfg() == 0 then
            return 'auto'
        elseif ragebot.get_active_cfg() == 1 then
            return 'scout'
        elseif ragebot.get_active_cfg() == 2 then
            return 'awp'
        elseif ragebot.get_active_cfg() == 3 then
            return 'deagle'
        elseif ragebot.get_active_cfg() == 4 then
            return 'revolver'
        elseif ragebot.get_active_cfg() == 5 then
            return 'pistols'
        else
            return 'other'
        end
    end
end
local states = {}; do
    states.global = { 'global', 'standing', 'running', 'walking', 'crouching', 'crouching-move', 'air', 'air-crouching' };
    states.builder = { ' ', '  ', '   ', '    ', '     ', '      ', '       ', '        ' };
    states.defensive = { '         ', '          ', '           ', '            ', '             ', '              ',
        '               ', '                ' };
end
local gui
do
    menu.refs = {
        amount = menu.find('antiaim', 'main', 'fakelag', 'amount'),
        breaklc = menu.find('antiaim', 'main', 'fakelag', 'break lag compensation'),
        pitch = menu.find('antiaim', 'main', 'angles', 'Pitch'),
        yaw_base = menu.find('antiaim', 'main', 'angles', 'yaw base'),
        yaw_add = menu.find('antiaim', 'main', 'angles', 'yaw add'),
        rotate = menu.find('antiaim', 'main', 'angles', 'rotate'),
        rotate_range = menu.find('antiaim', 'main', 'angles', 'rotate range'),
        rotate_speed = menu.find('antiaim', 'main', 'angles', 'rotate speed'),
        jitter_mode = menu.find('antiaim', 'main', 'angles', 'jitter mode'),
        jitter_type = menu.find('antiaim', 'main', 'angles', 'jitter type'),
        jitter_add = menu.find('antiaim', 'main', 'angles', 'jitter add'),
        desync_side = menu.find('antiaim', 'main', 'desync', 'side'),
        desync_left = menu.find('antiaim', 'main', 'desync', 'left amount'),
        desync_right = menu.find('antiaim', 'main', 'desync', 'right amount'),
        default_side = menu.find('antiaim', 'main', 'desync', 'default side'),
        anti_brute = menu.find('antiaim', 'main', 'desync', 'anti bruteforce'),
        on_shot = menu.find('antiaim', 'main', 'desync', 'On shot')[2],
        desync_override_move = menu.find('antiaim', 'main', 'desync', 'override stand#move'),
        desync_override_slowwalk = menu.find('antiaim', 'main', 'desync', 'override stand#slow walk'),
        leg_slide = menu.find('antiaim', 'main', 'general', 'leg slide'),
        left = menu.find('antiaim', 'main', 'manual', 'left')[2],
        right = menu.find('antiaim', 'main', 'manual', 'right')[2],
        fs = menu.find('antiaim', 'main', 'auto direction', 'enable')[2],
        slowwalk = menu.find('misc', 'main', 'movement', 'slow walk')[2],
        fd = menu.find('antiaim', 'main', 'general', 'fakeduck')[2],
        doubletap = menu.find('aimbot', 'general', 'exploits', 'doubletap', 'enable')[2],
        hideshots = menu.find('aimbot', 'general', 'exploits', 'hideshots', 'enable')[2],
        damage = menu.find('aimbot', 'scout', 'target overrides', 'min. damage')[2],
        auto_direction = menu.find('antiaim', 'main', 'auto direction', 'enable')[2],
        autopeek = menu.find('aimbot', 'general', 'misc', 'autopeek')[2],
        helpers = menu.find('misc', 'nade helper', 'general', 'autothrow')[2],
        dormant = menu.find('aimbot', 'general', 'dormant aimbot', 'enable')[2],
        ladder_aa = menu.find('antiaim', 'main', 'general', 'ladder antiaim'),
        ladder_move = menu.find('antiaim', 'main', 'general', 'fast ladder move'),
        backstab = menu.find('antiaim', 'main', 'general', 'anti knife'),
    };
    menu.init = function()
        menu.tab = {
            global = ui.create('welcome'),
            config = ui.create('config'),
            misc = ui.create('misc'),
            visual = ui.create('visual'),
            antiaim = ui.create('other'),
            settings = ui.create('antiaim settings'),
        };
        menu.global = {};
        menu.global.navigation = menu.tab.global:list('navigation', { 'global', 'anti-aim' }, 2);
        menu.global.info = menu.tab.global:label(string.format('welcome back, %s', user.name));
        menu.global.info2 = menu.tab.global:label('made by l3v1y with love//');
        menu.tab.global:separator();
        menu.global.accent = menu.tab.global:label('accent color');
        menu.global.color = menu.global.accent:color('accent');
        --//xx global
        menu.global.jump_scout = menu.tab.misc:switch('better jump scout')
        menu.tab.misc:separator();
        menu.global.strafer = menu.tab.misc:switch('strafer improver');
        menu.global.toss = menu.tab.misc:switch('super toss');
        menu.tab.misc:separator();
        menu.global.breakers = menu.tab.misc:combo('animation breaker', { 'ground', 'air', 'other' });
        menu.global.ground = menu.tab.misc:combo('ground breaker', { 'off', 'static', 'jitter', 'moonwalk', 'kangaroo' });
        menu.global.air = menu.tab.misc:combo('air breaker', { 'off', 'static', 'jitter', 'walking', 'kangaroo' });
        menu.global.lean = menu.tab.misc:slider('movelean', 0, 100, 1, nil, '%');
        menu.global.pitch = menu.tab.misc:switch('pitch zero on land');
        menu.tab.misc:separator();
        menu.global.killsay = menu.tab.misc:switch('killsay');
        menu.global.clantag = menu.tab.misc:switch('tag')

        --//xx visual
        menu.visual = {};
        menu.visual.watermark = menu.tab.visual:combo('watermark', { 'branded', 'angelwings', 'luasense' })
        menu.visual.indicators = menu.tab.visual:switch('crosshair indicator');
        menu.visual.indicators_type = menu.tab.visual:combo('indicator font', { 'verdana', 'pixel' });
        menu.visual.y_add = menu.tab.visual:slider('y add', -150, 150, 1, nil, nil, 25)
        menu.visual.damage = menu.tab.visual:switch('damage indicator')
        menu.visual.damage_type = menu.tab.visual:combo('damage font', { 'verdana', 'pixel' })
        menu.visual.manual = menu.tab.visual:combo('manual indicator', { 'none', 'legacy', 'minimalist', 'teamskeet' });
        menu.visual.side = menu.tab.visual:label('manual color');
        menu.visual.desync = menu.tab.visual:label('desync color');
        menu.visual.hitmarker = menu.tab.visual:switch('hit marker');
        menu.visual.hitcolor = menu.visual.hitmarker:color('hitmarker')
        menu.visual.hitlog = menu.tab.visual:switch('aimbot logging');
        menu.visual.gamesense = menu.tab.visual:switch('gamesense indicators');
        menu.visual.gamesense_list = menu.tab.visual:multicombo('gamesense list',
            { 'Double tap', 'On shot anti-aim', 'Dormant aimbot', 'Fake duck', 'Force safepoint',
                'Damage override', 'Peek assist', 'Hitchance override' })
        menu.tab.visual:separator();
        menu.visual.velocity = menu.tab.visual:switch('velocity warning');
        menu.visual.defensive = menu.tab.visual:switch('defensive warning');
        menu.tab.visual:separator();
        menu.visual.keep = menu.tab.visual:switch('keep model transparency');
        menu.visual.manuals_color = menu.visual.side:color('side');
        menu.visual.desync_color = menu.visual.desync:color('desync');

        menu.antiaim = {}; do
            menu.antiaim.states = menu.tab.settings:list('current state', states.global);
            menu.antiaim.mode = menu.tab.settings:list('current mode', { 'basic', 'defensive' });
            menu.antiaim.avoid = menu.tab.antiaim:switch('avoid backstab');
            menu.antiaim.safehead = menu.tab.antiaim:multicombo('safe head',
                { 'air-knife', 'air-taser', 'height difference', 'on manual', 'on freestand' });
            menu.antiaim.fakelag = menu.tab.antiaim:multicombo('fakelag', { 'auto', 'disable on state' });
            menu.antiaim.fakelag_states = menu.tab.antiaim:multicombo('disable fakelag',
                { 'standing', 'r8 exploit', 'exploit recharge', 'reduce on shot' });
            menu.antiaim.leg_breaker = menu.tab.antiaim:combo('leg breaker', { 'off', 'default', 'fastest' });
            menu.antiaim.no_fall_damage = menu.tab.antiaim:switch('no fall damage');
            menu.antiaim.fast_ladder = menu.tab.antiaim:switch('fast ladder');
        end

        menu.builder = { tab = {}, defensive = {}, state = {} };
        for i, name in ipairs(states.global) do
            menu.builder.state[name], menu.builder.tab[name], menu.builder.defensive[name] = {}, {}, {}
            local ctx, tab, defensive = menu.builder.state[name], menu.builder.tab[name], menu.builder.defensive[name]
            tab.name = ui.create(name);
            if i > 1 then
                ctx.enable = menu.tab.settings:switch('override ' .. name);
            end
            ctx.pitch = tab.name:combo('pitch', { 'custom', 'jitter', 'randomized', 'spinable' });
            ctx.pitch_custom = tab.name:slider('custom', -89, 89)
            ctx.pitch_from = tab.name:slider('from', -89, 89);
            ctx.pitch_to = tab.name:slider('to', -89, 89);
            ctx.pitch_speed = tab.name:slider('speed', 0, 360);
            ctx.base = tab.name:combo('yaw base', { 'local view', 'at target' });
            ctx.yaw = tab.name:combo('yaw', { 'static', 'l/r', 'x-way' });
            ctx.static = tab.name:slider('static', -180, 180);
            ctx.left = tab.name:slider('left', -180, 180);
            ctx.right = tab.name:slider('right', -180, 180);
            ctx.way = tab.name:slider('way amount', 3, 7)
            ctx.ways = {}; do
                for w = 1, 7 do
                    ctx.ways[w] = tab.name:slider('way ' .. w, -180, 180)
                end
            end
            ctx.jitter = tab.name:combo('jitter', { 'off', 'center', 'offset' });
            ctx.range = tab.name:slider('range', -180, 180);
            ctx.randomize = tab.name:slider('randomize', -180, 180);
            ctx.spin = tab.name:switch('spin');
            ctx.spin_range = tab.name:slider('spin range', -180, 180);
            ctx.spin_speed = tab.name:slider('spin speed', -480, 480)
            ctx.fake = tab.name:switch('fake');
            ctx.flip = tab.name:switch('flip');
            ctx.left_fake = tab.name:slider('left limit', 0, 100);
            ctx.right_fake = tab.name:slider('right limit', 0, 100);
            ctx.jitter_fake = tab.name:switch('jitter fake');
            ctx.delay = tab.name:slider('delay', 1, 12);

            defensive.force = menu.tab.settings:combo('! force defensive ' .. name, { 'off', 'always', 'flick' });
            if i > 1 then
                defensive.enable = menu.tab.settings:switch('! override ' .. name);
            end
            defensive.tick_start = tab.name:slider('! start', 0, 14);
            defensive.tick_end = tab.name:slider('! end', 0, 14)
            defensive.pitch = tab.name:combo('! pitch', { 'custom', 'jitter', 'randomized', 'spinable' });
            defensive.pitch_custom = tab.name:slider('! custom', -89, 89)
            defensive.pitch_from = tab.name:slider('! from', -89, 89);
            defensive.pitch_to = tab.name:slider('! to', -89, 89);
            defensive.pitch_speed = tab.name:slider('! speed', 0, 360);
            defensive.base = tab.name:combo('! yaw base', { 'local view', 'at target' });
            defensive.yaw = tab.name:combo('! yaw', { 'static', 'l/r', 'x-way' });
            defensive.static = tab.name:slider('! static', -180, 180);
            defensive.left = tab.name:slider('! left', -180, 180);
            defensive.right = tab.name:slider('! right', -180, 180);
            defensive.way = tab.name:slider('! way amount', 3, 7)
            defensive.ways = {}; do
                for w = 1, 7 do
                    defensive.ways[w] = tab.name:slider('! way ' .. w, -180, 180)
                end
            end
            defensive.jitter = tab.name:combo('! jitter', { 'off', 'center', 'offset' });
            defensive.range = tab.name:slider('! range', -180, 180);
            defensive.randomize = tab.name:slider('! randomize', -180, 180);
            defensive.spin = tab.name:switch('! spin');
            defensive.spin_range = tab.name:slider('! spin range', -180, 180);
            defensive.spin_speed = tab.name:slider('! spin speed', 0, 480)
            defensive.fake = tab.name:switch('! fake');
            defensive.flip = tab.name:switch('! flip');
            defensive.left_fake = tab.name:slider('! left limit', 0, 100);
            defensive.right_fake = tab.name:slider('! right limit', 0, 100);
            defensive.jitter_fake = tab.name:switch('! jitter fake');
            defensive.delay = tab.name:slider('! delay', 1, 12);
        end
        events.add(e_callbacks.PAINT, function()
            if not menu.is_open() then return end
            local tab = menu.global.navigation:get();
            menu.tab.misc:visible(tab == 1);
            menu.global.ground:visible(menu.global.breakers:get() == 1);
            menu.global.air:visible(menu.global.breakers:get() == 2);
            menu.global.lean:visible(menu.global.breakers:get() == 3);
            menu.global.pitch:visible(menu.global.breakers:get() == 3);
            menu.tab.visual:tab(3);
            menu.tab.visual:visible(tab == 1);
            menu.visual.indicators_type:visible(menu.visual.indicators:get())
            menu.visual.y_add:visible(menu.visual.indicators:get())
            menu.visual.damage_type:visible(menu.visual.damage:get())
            menu.visual.gamesense_list:visible(menu.visual.gamesense:get())
            menu.visual.side:visible(menu.visual.manual:get() ~= 1);
            menu.visual.desync:visible(menu.visual.manual:get() == 4);
            menu.tab.settings:visible(tab == 2)
            menu.tab.antiaim:visible(tab == 2)
            menu.antiaim.fakelag_states:visible(menu.antiaim.fakelag:get(2))
            for i, name in ipairs(states.global) do
                local ctx, tab, defensive = menu.builder.state[name], menu.builder.tab[name],
                    menu.builder.defensive[name];
                tab.name:visible(menu.antiaim.states:get() == i and menu.global.navigation:get() == 2)
                tab.name:tab(3)
                local check = (i > 1 and ctx.enable:get() or i == 1 and true) and
                    menu.antiaim.states:get() == i and menu.global.navigation:get() == 2
                local state = menu.antiaim.states:get() == i and menu.global.navigation:get() == 2
                if i > 1 then
                    ctx.enable:visible(state and menu.antiaim.mode:get() == 1)
                end
                ctx.pitch:visible(check and menu.antiaim.mode:get() == 1)
                ctx.pitch_custom:visible(check and ctx.pitch:get() == 1 and menu.antiaim.mode:get() == 1)
                ctx.pitch_from:visible(check and ctx.pitch:get() >= 2 and menu.antiaim.mode:get() == 1)
                ctx.pitch_to:visible(check and ctx.pitch:get() >= 2 and menu.antiaim.mode:get() == 1)
                ctx.pitch_speed:visible(check and ctx.pitch:get() == 4 and menu.antiaim.mode:get() == 1)
                ctx.base:visible(check and menu.antiaim.mode:get() == 1)
                ctx.yaw:visible(check and menu.antiaim.mode:get() == 1)
                ctx.static:visible(check and ctx.yaw:get() == 1 and menu.antiaim.mode:get() == 1)
                ctx.left:visible(check and ctx.yaw:get() == 2 and menu.antiaim.mode:get() == 1)
                ctx.right:visible(check and ctx.yaw:get() == 2 and menu.antiaim.mode:get() == 1)
                ctx.way:visible(check and ctx.yaw:get() == 3 and menu.antiaim.mode:get() == 1)
                for w = 1, 7 do
                    ctx.ways[w]:visible(check and ctx.yaw:get() == 3 and ctx.way:get() >= w and
                        menu.antiaim.mode:get() == 1)
                end
                ctx.jitter:visible(check and menu.antiaim.mode:get() == 1)
                ctx.range:visible(check and ctx.jitter:get() ~= 1 and menu.antiaim.mode:get() == 1)
                ctx.randomize:visible(check and ctx.jitter:get() ~= 1 and menu.antiaim.mode:get() == 1)
                ctx.spin:visible(check and menu.antiaim.mode:get() == 1)
                ctx.spin_range:visible(check and ctx.spin:get() and menu.antiaim.mode:get() == 1)
                ctx.spin_speed:visible(check and ctx.spin:get() and menu.antiaim.mode:get() == 1)
                ctx.fake:visible(check and menu.antiaim.mode:get() == 1)
                ctx.flip:visible(state and check and ctx.fake:get() and
                    menu.antiaim.mode:get() == 1)
                ctx.left_fake:visible(check and ctx.fake:get() and menu.antiaim.mode:get() == 1)
                ctx.right_fake:visible(check and ctx.fake:get() and menu.antiaim.mode:get() == 1)
                ctx.jitter_fake:visible(check and ctx.fake:get() and menu.antiaim.mode:get() == 1)
                ctx.delay:visible(check and menu.antiaim.mode:get() == 1)

                defensive.force:visible(state and menu.antiaim.mode:get() == 2)
                if i > 1 then
                    defensive.enable:visible(state and menu.antiaim.mode:get() == 2)
                end
                check = (i > 1 and defensive.enable:get() or i == 1)
                defensive.tick_start:visible(state and check and menu.antiaim.mode:get() == 2)
                defensive.tick_end:visible(state and check and menu.antiaim.mode:get() == 2)
                defensive.pitch:visible(state and check and menu.antiaim.mode:get() == 2)
                defensive.pitch_custom:visible(state and check and defensive.pitch:get() == 1 and
                    menu.antiaim.mode:get() == 2)
                defensive.pitch_from:visible(state and check and defensive.pitch:get() >= 2 and
                    menu.antiaim.mode:get() == 2)
                defensive.pitch_to:visible(state and check and defensive.pitch:get() >= 2 and
                    menu.antiaim.mode:get() == 2)
                defensive.pitch_speed:visible(state and check and defensive.pitch:get() == 4 and
                    menu.antiaim.mode:get() == 2)
                defensive.base:visible(state and check and menu.antiaim.mode:get() == 2)
                defensive.yaw:visible(state and check and menu.antiaim.mode:get() == 2)
                defensive.static:visible(state and check and defensive.yaw:get() == 1 and
                    menu.antiaim.mode:get() == 2)
                defensive.left:visible(state and check and defensive.yaw:get() == 2 and
                    menu.antiaim.mode:get() == 2)
                defensive.right:visible(state and check and defensive.yaw:get() == 2 and
                    menu.antiaim.mode:get() == 2)
                defensive.way:visible(state and check and defensive.yaw:get() == 3 and
                    menu.antiaim.mode:get() == 2)
                for w = 1, 7 do
                    defensive.ways[w]:visible(state and check and defensive.yaw:get() == 3 and
                        defensive.way:get() >= w and menu.antiaim.mode:get() == 2)
                end
                defensive.jitter:visible(state and check and menu.antiaim.mode:get() == 2)
                defensive.range:visible(state and check and defensive.jitter:get() ~= 1 and
                    menu.antiaim.mode:get() == 2)
                defensive.randomize:visible(state and check and defensive.jitter:get() ~= 1 and
                    menu.antiaim.mode:get() == 2)
                defensive.spin:visible(state and check and menu.antiaim.mode:get() == 2)
                defensive.spin_range:visible(state and check and defensive.spin:get() and
                    menu.antiaim.mode:get() == 2)
                defensive.spin_speed:visible(state and check and defensive.spin:get() and
                    menu.antiaim.mode:get() == 2)
                defensive.fake:visible(state and check and menu.antiaim.mode:get() == 2)
                defensive.flip:visible(state and check and defensive.fake:get() and
                    menu.antiaim.mode:get() == 2)
                defensive.left_fake:visible(state and check and defensive.fake:get() and
                    menu.antiaim.mode:get() == 2)
                defensive.right_fake:visible(state and check and defensive.fake:get() and
                    menu.antiaim.mode:get() == 2)
                defensive.jitter_fake:visible(state and check and defensive.fake:get() and
                    menu.antiaim.mode:get() == 2)
                defensive.delay:visible(state and check and menu.antiaim.mode:get() == 2)
            end
        end)
    end
end
antiaim.init = function()
    local aa = {}; do
        aa.way = 1;
        aa.side = -1;
        aa.inverted = false;
        aa.tickbase_max = 0;
        aa.chocking = false;
        aa.pitch_spin = -89;
        aa.yaw_spin = -180;
        aa.last_flick = 0;
        aa.vel = 0
        aa.fake = 1
        aa.state = 'global'
        aa.ticking = 0
    end
    local normalize = function(a)
        while a > 180 do
            a = a - 360
        end

        while a < -180 do
            a = a + 360
        end

        return a
    end
    aa.get_state = function()
        local ent = entity_list.get_local_player()
        if ent == nil then return 'global' end
        local vel = vector(ent:get_prop('m_vecVelocity[0]'),
            ent:get_prop('m_vecVelocity[1]'),
            ent:get_prop('m_vecVelocity[2]')):length2d() or 0
        if not ent:has_player_flag(e_player_flags.ON_GROUND) or input.is_key_held(input.find_key_bound_to_binding('jump')) then
            if ent:has_player_flag(e_player_flags.DUCKING) then
                return 'air-crouching'
            else
                return 'air'
            end
        end
        if ent:has_player_flag(e_player_flags.DUCKING) or antiaim.is_fakeducking() then
            if menu.builder.state['crouching-move'].enable:get() then
                if vel > 5 then
                    return 'crouching-move'
                end
            end
            return 'crouching'
        end
        if menu.refs.slowwalk:get() then
            return 'walking'
        end
        if vel > 5 and ent:has_player_flag(e_player_flags.ON_GROUND) then
            return 'running'
        else
            return 'standing'
        end
        return 'global'
    end
    aa.exploit = false 
    events.add(e_callbacks.ANTIAIM, function ()
        local ent = entity_list.get_local_player()
        if ent == nil or not ent or not ent:is_alive() then return end
        local tickbase = ent:get_prop('m_nTickBase') or 0
        aa.exploit = globals.tick_count() > tickbase
    end)
    events.add(e_callbacks.NET_UPDATE, function()
        local ent = entity_list.get_local_player()
        if ent == nil or not ent or not ent:is_alive() then return end
        local tickbase = ent:get_prop('m_nTickBase') or 0
        if math.abs(tickbase - aa.tickbase_max) > 64 then
            aa.tickbase_max = 0
        end

        local defensive_ticks_left = 0;
        local state = menu.builder.defensive[aa.get_state()].enable:get() and aa.get_state() or 'global'

        if tickbase > aa.tickbase_max then
            aa.tickbase_max = tickbase
        elseif aa.tickbase_max > tickbase then
            defensive_ticks_left = math.min(14, math.max(0, aa.tickbase_max - tickbase - 1))
        end
        aa.tick_defensive = defensive_ticks_left
        aa.is_defensive = defensive_ticks_left > menu.builder.defensive[state].tick_start:get() and
            defensive_ticks_left < menu.builder.defensive[state].tick_end:get() and
            antiaim.get_manual_override() == 0 and aa.exploit and
            menu.builder.defensive[state].enable:get() and engine.get_choked_commands() <= 1 and menu.refs.doubletap:get()
    end)
    aa.get_yaw = function()
        local state = menu.builder.state[aa.get_state()].enable:get() and aa.get_state() or 'global'
        local state_defensive = menu.builder.defensive[aa.get_state()].enable:get() and aa.get_state() or 'global'
        local ctx = aa.is_defensive and menu.builder.defensive[state_defensive] or menu.builder.state[state]
        if ctx.yaw:get() == 1 then
            return ctx.static:get()
        end
        if ctx.yaw:get() == 2 then
            return aa.inverted and ctx.left:get() or ctx.right:get()
        end
        if ctx.yaw:get() == 3 then
            return ctx.ways[aa.way]:get()
        end
    end
    aa.get_pitch = function()
        local state = menu.builder.state[aa.get_state()].enable:get() and aa.get_state() or 'global'
        local state_defensive = menu.builder.defensive[aa.get_state()].enable:get() and aa.get_state() or 'global'
        local ctx = aa.is_defensive and menu.builder.defensive[state_defensive] or menu.builder.state[state]

        if ctx.pitch:get() == 1 then
            return ctx.pitch_custom:get()
        end
        if ctx.pitch:get() == 2 then
            return aa.inverted and ctx.pitch_from:get() or ctx.pitch_to:get()
        end
        if ctx.pitch:get() == 3 then
            return client.random_int(ctx.pitch_from:get(), ctx.pitch_to:get())
        end
        if ctx.pitch:get() == 4 then
            aa.pitch_spin = -animation:spin('pitch spin ' .. state, ctx.pitch_from:get(), ctx.pitch_to:get(), 0.01,
                ctx.pitch_speed:get() / 10).value * (ctx.pitch_from:get() <= 0 and -1 or 1)
            if aa.pitch_spin >= -89 then
                aa.pitch_spin = animation:spin('pitch spin ' .. state, ctx.pitch_from:get(), ctx.pitch_to:get(), 0.01,
                ctx.pitch_speed:get() / 10).value* (ctx.pitch_from:get() <= 0 and 1 or -1)
            end
            return aa.pitch_spin
        end
    end
    aa.get_jitter = function()
        local state = menu.builder.state[aa.get_state()].enable:get() and aa.get_state() or 'global'
        local state_defensive = menu.builder.defensive[aa.get_state()].enable:get() and aa.get_state() or 'global'
        local ctx = aa.is_defensive and menu.builder.defensive[state_defensive] or menu.builder.state[state]
        local add = 0;
        add = client.random_int(-ctx.randomize:get(), ctx.randomize:get())
        if ctx.jitter:get() == 2 then
            return (aa.inverted and -ctx.range:get() / 2 or ctx.range:get() / 2) + add
        end
        if ctx.jitter:get() == 3 then
            return (aa.inverted and 0 or ctx.range:get() / 2) + add
        end
        return 0
    end
    aa.hande = function(ctx, cmd)
        aa.get_state()
        local state = menu.builder.state[aa.get_state()].enable:get() and aa.get_state() or 'global'
        local state_defensive = menu.builder.defensive[aa.get_state()].enable:get() and aa.get_state() or 'global'
        local builder = aa.is_defensive and menu.builder.defensive[state_defensive] or menu.builder.state[state]
        if builder.spin:get() then
            aa.yaw_spin = -animation:spin('yaw spin ' .. state, -builder.spin_range:get(),
                builder.spin_range:get(), 0.01,
                builder.spin_speed:get() / 10).value * (builder.spin_range:get() <= 0 and 1 or -1)
            if aa.yaw_spin >= 180 then
                aa.yaw_spin = -180
            end
        else
            aa.yaw_spin = 0
        end
        local yaw_delay = builder.delay:get() or 2
        if engine.get_choked_commands() == 0 then
            aa.way = aa.way + 1
            aa.chocking = not aa.chocking
            aa.ticking = aa.ticking + 1
            animation:tick(globals.tick_count())
        end
        if aa.way > builder.way:get() then aa.way = 1 end
        if aa.ticking  - aa.last_flick >= yaw_delay then
            aa.inverted = not aa.inverted
            aa.side = aa.side * -1

            aa.last_flick = aa.ticking 
        end
        menu.refs.jitter_mode:set(1);
        menu.refs.desync_override_move:set(false)
        menu.refs.desync_override_slowwalk:set(false)
    end
    local reduce = 0; do
        events.add(e_callbacks.AIMBOT_SHOOT, function()
            reduce = globals.tick_count() + 4
        end)
    end
    local angles = function(angle)
        local yaw = math.deg(math.atan2(angle.y, angle.x))
        local pitch = math.deg(math.atan2(-angle.z, math.sqrt(angle.x ^ 2 + angle.y ^ 2)))
        return pitch, yaw
    end
    events.add(e_callbacks.ANTIAIM, function(ctx, cmd)
        local wep = entity_list.get_local_player():get_prop("m_hActiveWeapon")
        local wep2 = entity_list.get_entity(wep)
        if not wep2 then return end
        local weapon = wep2:get_weapon_data().console_name
        local lp_origin = entity_list.get_local_player():get_render_origin();
        local enemy_origin = helper.get_threat() == nil and vector(0, 0, 0) or helper.get_threat():get_render_origin()
        local diff = lp_origin.z - enemy_origin.z
        local safehead = {
            [1] = (string.find(weapon, "weapon_knife_") or string.find(weapon, "bayonet")) and
                aa.get_state() == 'air-crouching',
            [2] = (string.find(weapon, "taser")) and aa.get_state() == 'air-crouching',
            [3] = aa.get_state() ~= 'running' and diff >= 65,
            [4] = antiaim.get_manual_override() > 0,
            [5] = menu.refs.fs:get(),
        }
        local fakelag = {
            [1] = aa.get_state() == 'standing' and menu.antiaim.fakelag_states:get(1),
            [2] = (menu.refs.doubletap:get() and weapon:find('revolver')) and menu.antiaim.fakelag_states:get(2),
            [3] = (menu.refs.doubletap:get() and exploits.get_charge() < exploits.get_max_charge()) and menu.antiaim.fakelag_states:get(3),
            [4] = reduce > globals.tick_count() and menu.antiaim.fakelag_states:get(4),
        }
        local state = menu.builder.state[aa.get_state()].enable:get() and aa.get_state() or 'global'
        local state_defensive = menu.builder.defensive[aa.get_state()].enable:get() and aa.get_state() or 'global'
        local builder = aa.is_defensive and menu.builder.defensive[state_defensive] or menu.builder.state[state]
        aa.hande(ctx, cmd)
        if menu.builder.defensive[state].force:get() == 2 then
            exploits.force_anti_exploit_shift()
        end
        if menu.builder.defensive[state].force:get() == 3 then
            if cmd.command_number % 8 == 0 then
                exploits.force_anti_exploit_shift()
            end
        end
        aa.yaw, aa.jitter = aa.get_yaw(), aa.get_jitter()
        local all = normalize(aa.yaw + aa.jitter + aa.yaw_spin);
        aa.fake = builder.fake:get() and
            (builder.jitter_fake:get() and (aa.inverted and 2 or 3) or builder.flip:get() and 3 or 2) or 1
        ctx:set_pitch(aa.get_pitch());
        menu.refs.yaw_base:set(builder.base:get() == 1 and 2 or 3)
        menu.refs.yaw_add:set(all);
        menu.refs.desync_side:set(aa.fake);
        menu.refs.desync_left:set(builder.left_fake:get())
        menu.refs.desync_right:set(builder.right_fake:get())

        for i, fn in pairs(safehead) do
            if menu.antiaim.safehead:get(i) then
                if fn then
                    ctx:set_pitch(89);
                    menu.refs.yaw_add:set(25);
                    menu.refs.desync_side:set(3);
                    menu.refs.desync_left:set(100)
                    menu.refs.desync_right:set(100)
                end
            end
        end
            if menu.antiaim.fakelag:get(2) then
                    if fakelag[1] or fakelag[2] or fakelag[3] or fakelag[4] then
                        menu.refs.amount:set(1)
                    else
                        menu.refs.amount:set(menu.antiaim.fakelag:get(1) and client.random_int(6, 15) or 15)
                    end
        end
        if menu.antiaim.avoid:get() then
            menu.refs.backstab:set(false)
            local my_origin = entity_list.get_local_player():get_render_origin()

            local player_list = entity_list.get_players(true)
            local player_cnt = #player_list

            local closest_dist, closest_yaw = math.huge, nil

            for i = 1, player_cnt do
                local ent = player_list[i]
                local weapon = entity_list.get_entity(ent:get_prop("m_hActiveWeapon"))
                local player_origin = ent:get_hitbox_pos(2)
                local distance = my_origin:dist(player_origin)
                if distance < 350 and weapon ~= nil then
                    local weapon_info = weapon:get_weapon_data().console_name

                    if weapon_info:find('knife') or weapon_info:find('bayo') then
                        if distance < closest_dist then
                            local _, yaw_to_target = angles(player_origin - my_origin)

                            closest_yaw = yaw_to_target
                            closest_dist = distance
                        end
                    end
                end
            end

            if closest_yaw then
                ctx:set_pitch(89);
                menu.refs.yaw_base:set(3)
                menu.refs.yaw_add:set(180);
                menu.refs.desync_side:set(3);
            end
        end
    end)
    events.add(e_callbacks.EVENT, function(event)
        aa.last_flick = 0
    end, 'round_prestart')
    events.add(e_callbacks.EVENT, function(event)
        aa.last_flick = 0
    end, 'round_start')
    local ground_tick, end_time = 0, 0
    events.add(e_callbacks.ANTIAIM, function(fx, cmd)
        local lp = entity_list.get_local_player()
        if not lp or lp == nil then return end
        local on_land = bit.band(lp:get_prop("m_fFlags"), bit.lshift(1, 0)) ~= 0
        local curtime = globals.cur_time()
        
        if on_land == true then
            ground_tick = ground_tick + 1
        else
            ground_tick = 0
            end_time = curtime + 1
        end

        if menu.global.ground:get() == 2 then
            fx:set_render_pose(e_poses.RUN, 0)
            menu.refs.leg_slide:set(3)
        end
        if menu.global.ground:get() == 3 then
            menu.refs.leg_slide:set(3)
            if aa.chocking then
                fx:set_render_pose(e_poses.RUN, 1)
            end
        end
        if menu.global.ground:get() == 4 then
            menu.refs.leg_slide:set(2)
            fx:set_render_pose(e_poses.MOVE_YAW, 0)
        end
        if menu.global.ground:get() == 5 then
            menu.refs.leg_slide:set(2)
            fx:set_render_pose(e_poses.MOVE_YAW, client.random_int(0, 10) / 10)
            fx:set_render_pose(e_poses.LADDER_YAW, client.random_int(0, 10) / 10)
        end

        if menu.global.air:get() == 2 then
            fx:set_render_pose(e_poses.JUMP_FALL, 1)
        end
        if menu.global.air:get() == 3 then
            if aa.chocking then
                fx:set_render_pose(e_poses.JUMP_FALL, 1)
            end
        end
        if menu.global.air:get() == 4 then
            if aa.get_state():find('air') then
                fx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 6.0)
            end
        end
        if menu.global.air:get() == 5 then
            fx:set_render_pose(e_poses.JUMP_FALL, client.random_int(0, 10) / 10)
        end
        local x_velocity = entity_list.get_local_player():get_prop("m_vecVelocity[0]")
        if math.abs(x_velocity) >= 3 then
            fx:set_render_animlayer(e_animlayers.LEAN, menu.global.lean:get() / 100)
        end
        if menu.global.pitch:get() then
            if ground_tick > 1 and end_time > curtime then
                fx:set_render_pose(e_poses.BODY_PITCH, 0.5)
            end
        end
        if menu.antiaim.leg_breaker:get() == 3 then 
            menu.refs.leg_slide:set(aa.chocking and 3 or 2)
        end 
        if menu.antiaim.leg_breaker:get() == 2 then 
            menu.refs.leg_slide:set(aa.inverted and 3 or 2)
        end 
    end)

    local visual; do
        render.fonts = {
            verdana = render.create_font('Verdana', 11, 400, e_font_flags.DROPSHADOW, e_font_flags.ANTIALIAS),
            verdana2 = render.create_font('Verdana', 11, 400, e_font_flags.DROPSHADOW),
            pixel = render.create_font('Small Fonts', 10, 400, e_font_flags.OUTLINE),
            bold = render.create_font('Verdana Bold', 11, 600, e_font_flags.DROPSHADOW),
            cb = render.create_font('Calibri Bold', 24, 400, e_font_flags.DROPSHADOW, e_font_flags.ANTIALIAS),
            cb2 = render.create_font('Calibri Bold', 11, 400, e_font_flags.DROPSHADOW, e_font_flags.ANTIALIAS),
            c = render.create_font('Calibri', 11, 400, e_font_flags.DROPSHADOW, e_font_flags.ANTIALIAS),
            default = render.get_default_font(),
        };
        render.icon = {
            night = render.load_image('primordial/night/moon.png'),
            velocity = render.load_image('primordial/night/man.png'),
            defensive = render.load_image('primordial/night/shield.png'),
        }
        render.screen = render.get_screen_size();
        render.add_indicator = function(text, clr, dist)
            local x, y = 28, render.screen.y - 350
            local ts = render.get_text_size(render.fonts.cb, text)
            render.rect_fade(vector(5, y + 3 - dist), vector(x + ts.x / 2 - 3, 34), color(0, 0, 0, 0), color(0, 0, 0, 50),
                true)
            render.rect_fade(vector(x + ts.x / 2 + 2, y + 3 - dist), vector(ts.x + 8, 34), color(0, 0, 0, 50),
                color(0, 0, 0, 0), true)
            render.text(render.fonts.cb, text, vector(x, y + 9 - dist), clr)
        end
    end;

    events.add(e_callbacks.PAINT, function()
        if menu.visual.watermark:get() == 1 then
            render.texture(render.icon.night.id, vector(15, render.screen.y / 2 - 15), vector(20, 20),
                menu.global.color:get())
            render.text(render.fonts.pixel, 'night.project', vector(40, render.screen.y / 2 - 13), color(255, 255, 255));
            render.text(render.fonts.pixel,
                string.format('user:%s\a%s%s', user.name, helper.color_to_hex(menu.global.color:get()),
                    info.build ~= 'stable' and '[' .. info.build .. ']' or ''),
                vector(40, render.screen.y / 2 - 4), color(255, 255, 255));
        end
        if menu.visual.watermark:get() == 2 then
            render.text(render.fonts.cb2, 'night.project', vector(render.screen.x / 2, render.screen.y - 25),
                color(255, 255, 255, 200), true)
        end
        if menu.visual.watermark:get() == 3 then
            local text = helper.gradient('N I G H T', globals.cur_time(), color(200, 200, 200, 200),
                color(55, 55, 55, 200));
            render.text(render.fonts.verdana2,
                string.format('%s\a%s %s', text, helper.color_to_hex(menu.global.color:get()),
                    info.build ~= 'stable' and '[' .. info.build:upper() .. ']' or ''),
                vector(19, render.screen.y / 2 + 10),
                color(255, 255, 255, 200))
        end
    end);
    events.add(e_callbacks.PAINT, function()
        if not menu.visual.velocity:get() then return end;
        local lp = entity_list.get_local_player();
        if not lp then return end;
        if lp == nil then return end
        if not lp:is_alive() then return end;
        local slowed = lp:get_prop('m_flVelocityModifier');
        local stat = 1 - slowed
        local r, g, b = menu.global.color:get().r, menu.global.color:get().g, menu.global.color:get().b
        if slowed ~= 0 then
            render.texture(render.icon.velocity.id, vector(render.screen.x / 2 - 10, 130), vector(21, 21),
                color(255, 255, 255, math.round(200 * stat)))
            render.rect_filled(vector(render.screen.x / 2 - 74, 155), vector(74 * 2, 6),
                color(0, 0, 0, math.round(200 * stat)), 4)
            render.rect_filled(vector(render.screen.x / 2 - (72 * stat), 157), vector((72 * 2) * stat, 2),
                color(r, g, b, math.round(200 * stat)), 4)
        end
    end)
    events.add(e_callbacks.PAINT, function()
        if not menu.visual.defensive:get() then return end;
        local lp = entity_list.get_local_player();
        if not lp then return end;
        if lp == nil then return end
        if not lp:is_alive() then return end;
        local anim = animation:process('Defensive Warning', aa.tick_defensive > 0, 7);
        local r, g, b = menu.global.color:get().r, menu.global.color:get().g, menu.global.color:get().b
        if anim > 0.01 then
            render.texture(render.icon.defensive.id, vector(render.screen.x / 2 - 10, 90), vector(21, 21),
                color(255, 255, 255, math.round(200 * anim)))
            render.rect_filled(vector(render.screen.x / 2 - 74, 115), vector(74 * 2, 6),
                color(0, 0, 0, math.round(200 * anim)), 4)
            render.rect_filled(vector(render.screen.x / 2 - (72 * anim), 117), vector((72 * 2) * anim, 2),
                color(r, g, b, math.round(200 * anim)), 4)
        end
    end)
    events.add(e_callbacks.PAINT, function ()
        local lp = entity_list.get_local_player();
        if not lp then return end
        if lp == nil then return end
        if not lp:is_alive() then return end
        menu.refs.damage = menu.find('aimbot', helper.get_weapon_group(), 'target overrides', 'min. damage')[2];
        menu.refs.lethal = menu.find('aimbot', helper.get_weapon_group(), 'target overrides', 'lethal shot')[2];
        menu.refs.hitbox = menu.find('aimbot', helper.get_weapon_group(), 'target overrides', 'hitbox')[2];
        menu.refs.safepoint = menu.find('aimbot', helper.get_weapon_group(), 'target overrides', 'safepoint')[2];
        menu.refs.hitchance = menu.find('aimbot', helper.get_weapon_group(), 'target overrides', 'hitchance')[2]; 
    end)
    events.add(e_callbacks.PAINT, function()
        local lp = entity_list.get_local_player();
        if not lp then return end;
        if lp == nil then return end
        if not lp:is_alive() then return end;
        local on_enable = animation:process('On Enable Indicators', menu.visual.indicators:get(), 9)
        if on_enable < 0.1 then return end
        local ay = 0;
        local y_add = menu.visual.y_add:get()
        local scoped = lp:get_prop('m_bIsScoped');
        local anim = animation:process('Scoped Indicators', scoped == 1, 12) * on_enable
        local add = 35 * anim
        local font = menu.visual.indicators_type:get() == 1 and render.fonts.verdana or render.fonts.pixel
        local additive = menu.visual.indicators_type:get() == 1 and 10 or 9
        local r, g, b = menu.global.color:get().r, menu.global.color:get().g, menu.global.color:get().b
        local txt = helper.gradient('night.project', globals.real_time(), color(r, g, b, math.round(255 * on_enable)),
            color(55, 55, 55, math.round(255 * on_enable)))
        render.text(font, txt, vector(render.screen.x / 2 + add, render.screen.y / 2 + y_add),
            color(r, g, b, math.round(255 * on_enable)), true);
        local to_parse = {
            {
                text = 'doubletap',
                key = menu.refs.doubletap,
                color = color(255, 255, 255, 200),
                scope = 0,
            },
            {
                text = 'hideshot',
                key = menu.refs.hideshots,
                color = color(255, 255, 255, 200),
                scope = 0,
            },
            {
                text = 'minimum',
                key = menu.refs.damage,
                color = color(255, 255, 255, 200),
                scope = 0,
            },
            {
                text = 'lethal',
                key = menu.refs.lethal,
                color = color(255, 255, 255, 200),
                scope = 0,
            },
            {
                text = 'hitbox',
                key = menu.refs.hitbox,
                color = color(255, 255, 255, 200),
                scope = 0,
            },
        }
        for k, v in ipairs(to_parse) do
            v.anim = animation:process(v.text .. 'Animate Indicators', v.key:get(), 12) * on_enable;
            v.sub = string.sub(v.text, 1, (#v.text * v.anim * on_enable))
            v.scope = (render.get_text_size(font, tostring(v.sub)).x / 2 + 6 - (menu.visual.indicators_type:get() == 1 and 3 or 1)) *
                anim
            if v.anim > 0 then
                render.text(font, v.sub,
                    vector(render.screen.x / 2 + v.scope,
                        render.screen.y / 2 + y_add + ay + (y_add > 0 and additive or -additive) +
                        ((menu.visual.indicators_type:get() == 1 and y_add > 0) and 1 or -1)),
                    color(r, g, b, math.round((255 * on_enable) * v.anim)), true);
                ay = ay + (y_add > 0 and additive or -additive) * v.anim
            end
        end
    end)
    events.add(e_callbacks.WORLD_HITMARKER,
        function(screen_pos, world_pos, alpha_factor, damage, is_lethal, is_headshot)
            render.push_alpha_modifier(alpha_factor)
            render.rect_fade(vector(screen_pos.x, screen_pos.y - 10 / 5 * 2), vector(2, 10), menu.visual.hitcolor:get(),
                menu.visual.hitcolor:get(), true)
            render.rect_fade(vector(screen_pos.x - 10 / 5 * 2, screen_pos.y), vector(10, 2), menu.visual.hitcolor:get(),
                menu.visual.hitcolor:get(), true)
            render.pop_alpha_modifier()
            return true
        end)
        events.add(e_callbacks.PAINT, function()
        if not menu.visual.gamesense:get() then return end;
        local lp = entity_list.get_local_player();
        if not lp then return end;
        if lp == nil then return end
        if not lp:is_alive() then return end;

        local dst = 0;

        if menu.visual.gamesense_list:get(1) and menu.refs.doubletap:get() then
            render.add_indicator('DT',
                exploits.get_charge() == exploits.get_max_charge() and color(200, 200, 200, 255) or
                color(255, 0, 50, 255), dst)
            dst = dst + 41
        end
        if menu.visual.gamesense_list:get(2) and menu.refs.hideshots:get() and not menu.refs.doubletap:get() then
            render.add_indicator('OSAA', color(200, 200, 200, 255), dst)
            dst = dst + 41
        end
        if menu.visual.gamesense_list:get(3) and menu.refs.dormant:get() and lp:is_dormant() then
            render.add_indicator('DA', lp:is_dormant() and
                color(200, 200, 200, 255) or
                color(255, 0, 50, 255), dst)
            dst = dst + 41
        end
        if menu.visual.gamesense_list:get(4) and antiaim.is_fakeducking() then
            render.add_indicator('DUCK', color(200, 200, 200, 255), dst)
            dst = dst + 41
        end
        if menu.visual.gamesense_list:get(5) and menu.refs.safepoint:get() then
            render.add_indicator('SAFE', color(200, 200, 200, 255), dst)
            dst = dst + 41
        end
        if menu.visual.gamesense_list:get(6) and menu.refs.damage:get() then
            render.add_indicator('MD', color(200, 200, 200, 255), dst)
            dst = dst + 41
        end
        if menu.visual.gamesense_list:get(7) and menu.find('aimbot', 'general', 'misc', 'autopeek')[2]:get() then
            render.add_indicator('FS', color(200, 200, 200, 255), dst)
            dst = dst + 41
        end
        if menu.visual.gamesense_list:get(8) and menu.refs.hitchance:get() then
            render.add_indicator('HC', color(200, 200, 200, 255), dst)
            dst = dst + 41
        end
    end)
    events.add(e_callbacks.PAINT, function()
        local lp = entity_list.get_local_player();
        if not lp then return end
        if lp == nil then return end
        if not lp:is_alive() then return end
        local on_enable = animation:process('On Enable Damage Indicator', menu.visual.damage:get(), 9);
        if on_enable < 0.01 then return end
        local font = menu.visual.damage_type:get() == 1 and render.fonts.c or render.fonts.pixel
        local anim = animation:process('Damage indicator', menu.refs.damage:get(), 9);
        local dmg = animation.lerp(menu.find('aimbot', helper.get_weapon_group(), 'targeting', 'min. damage'):get(),
            menu.find('aimbot', helper.get_weapon_group(), 'target overrides', 'min. damage')[1]:get(), anim)
        render.text(font, tostring(math.round(dmg)), vector(render.screen.x / 2 + 5, render.screen.y / 2 - 20),
            color(255, 255, 255, math.round(200 * on_enable)))
    end)
    local clr1 = menu.find('Visuals', 'ESP', 'Models', 'model#local', 'color')[2]
    local alpha = clr1:get().a
    local typeclr = menu.find('Visuals', 'ESP', 'Models', 'model#local', 'style')
    local enbl = menu.find('Visuals', 'ESP', 'Models', 'model#local', 'enable')
    events.add(e_callbacks.DRAW_MODEL, function(ctx)
        local transparency = menu.find('Visuals', 'View', 'Thirdperson', 'transparency when scoped'):get()
        if not menu.visual.keep:get() then return end
        if not ctx.entity:is_valid() then return end
        local local_player = entity_list.get_local_player()
        if local_player == nil then return end
        if ctx.entity:get_index() ~= local_player:get_index() then return end
        if typeclr:get() ~= 1 then return end
        local weapon = local_player:get_active_weapon()
        if weapon == nil then return end
        local class_name = weapon:get_class_name()
        if class_name:find('Grenade') or entity_list.get_local_player():get_prop('m_bResumeZoom') == 1 then
            ctx.override_original = true
            ctx:draw_original(color(255, 255, 255, math.floor(255 * (1 - (transparency / 100)))))
            return
        end
    end)
    events.add(e_callbacks.PAINT, function()
        local transparency = menu.find('Visuals', 'View', 'Thirdperson', 'transparency when scoped'):get()
        if not menu.visual.keep:get() then return end
        local local_player = entity_list.get_local_player()
        if local_player == nil then return end
        local clr2 = clr1:get()
        if not enbl:get() then return end
        if typeclr:get() == 1 then return end
        local weapon = local_player:get_active_weapon()
        if weapon == nil then return end
        local should = false
        local class_name = weapon:get_class_name()
        if class_name:find('Grenade') or entity_list.get_local_player():get_prop('m_bResumeZoom') == 1 then
            clr1:set(color(clr2.r, clr2.g, clr2.b, 35))
            return
        end
        clr1:set(color(clr2.r, clr2.g, clr2.b, alpha))
    end)

    local data = {}
    data.garbage_timer = 0;
    data.garbage = function()
        collectgarbage('collect');
        data.garbage_timer = 0;
    end;
    events.add(e_callbacks.PAINT, function()
        data.garbage_timer = data.garbage_timer + 1;
        if data.garbage_timer > 150 then data.garbage() end
    end)
    events.add(e_callbacks.ANTIAIM, function()
        if engine.get_choked_commands() == 0 then
            animation:tick(globals.tick_count())
        end
    end)
    local log = { logs = {} }; do
        log.add = function(text, color)
            table.insert(log.logs, 1, { text = text, color = color, alpha = 0, time = globals.cur_time() + 3 })
        end
    end
    local hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg',
        'neck', '?', 'gear' }
        events.add(e_callbacks.AIMBOT_HIT, function(e)
        if not menu.visual.hitlog:get() then return end
        local damage = e.player:get_prop('m_iHealth') > 0 and e.player:get_prop('m_iHealth') or 0
        log.add(
            string.format('hit %s %s%s for %s damage (%s remaining)', e.player:get_name(), hitgroup_names
                [e.hitgroup + 1],
                hitgroup_names[e.hitgroup + 1] ~= hitgroup_names[e.aim_hitgroup + 1] and
                string.format('(%s)', hitgroup_names[e.aim_hitgroup + 1]) or '', e.damage, damage),
            color(255, 255, 255, 200))
        logger.log(color(115,255,115,255), string.format('hit %s %s%s for %s damage (%s remaining)', e.player:get_name(), hitgroup_names
        [e.hitgroup + 1],
        hitgroup_names[e.hitgroup + 1] ~= hitgroup_names[e.aim_hitgroup + 1] and
        string.format('(%s)', hitgroup_names[e.aim_hitgroup + 1]) or '', e.damage, damage))
    end)
    events.add(e_callbacks.AIMBOT_MISS, function(e)
        if not menu.visual.hitlog:get() then return end
        local damage = e.player:get_prop('m_iHealth') > 0 and e.player:get_prop('m_iHealth') or 0
        log.add(
            string.format('missed %s %s for %s damage due to %s', e.player:get_name(), hitgroup_names
                [e.aim_hitgroup + 1],
                e.aim_damage, e.reason_string), color(255, 98, 98, 200))
        logger.log(color(255, 115, 115, 255),
            string.format('missed %s %s for %s damage due to %s', e.player:get_name(), hitgroup_names
                [e.aim_hitgroup + 1],
                e.aim_damage, e.reason_string))
    end)
    events.add(e_callbacks.PAINT, function()
        if not menu.visual.hitlog:get() then return end
        local lp = entity_list.get_local_player();
        if not lp then
            log.logs = {}
            return
        end
        if lp == nil then return end
        if not lp:is_alive() then return end
        local offset = 0
        for i, v in pairs(log.logs) do
            v.alpha = animation:process(i .. 'log', v.time > globals.cur_time() and i <= 6, 4)
            v.sub_alpha = animation:process(i .. 'log', v.time > globals.cur_time() and i <= 6, 8)
            v.sub = string.sub(v.text, 1, (#v.text * v.sub_alpha))
            if v.alpha < 0.01 then
                table.remove(log.logs, i)
            end
            local w, h = render.get_text_size(render.fonts.verdana, v.text)
            if v.alpha > 0.01 then
                render.text(render.fonts.verdana, tostring(v.sub),
                    vector(render.screen.x / 2, render.screen.y / 2 + 145 + offset),
                    color(v.color.r, v.color.g, v.color.b, 255 * v.sub_alpha), true)
            end
            offset = offset + 15 * (v.sub_alpha)
        end
    end)
    events.add(e_callbacks.SETUP_COMMAND, function(cmd)
        if not menu.antiaim.no_fall_damage:get() then return end
        local calculatefall = function(length)
            local lplr = entity_list.get_local_player()
            local x, y, z = lplr:get_render_origin().x, lplr:get_render_origin().y, lplr:get_render_origin().z
            local max_radias = math.pi * 2
            local step = max_radias / 8

            for a = 0, max_radias, step do
                local ptX, ptY = ((10 * math.cos(a)) + x), ((10 * math.sin(a)) + y)
                local traced = trace.line(vector(ptX, ptY, z), vector(ptX, ptY, z - length), lplr)
                local fraction, entity = traced.fraction, traced.entity

                if fraction ~= 1 then
                    return true
                end
            end
            return false
        end
        local lplr = entity_list.get_local_player()
        local no_fall_damage = nil

        if lplr == nil then return end

        if lplr:get_prop('m_vecVelocity').z >= -500 then
            no_fall_damage = false
        else
            if calculatefall(15) then
                no_fall_damage = false
            elseif calculatefall(75) then
                no_fall_damage = true
            end
        end

        if lplr:get_prop('m_vecVelocity').z < -500 then
            if no_fall_damage then
                cmd:add_button(e_cmd_buttons.DUCK)
            else
                cmd:remove_button(e_cmd_buttons.DUCK)
            end
        end
    end)

    events.add(e_callbacks.SETUP_COMMAND, function(cmd)
        if not menu.global.strafer:get() then
            return
        end

        local lp = entity_list.get_local_player()
        if not lp then
            return
        end

        local flag = lp:get_prop('m_fFlags')
        if flag == 256 or flag == 262 then -- in air
            local speed = vector(entity_list.get_local_player():get_prop('m_vecVelocity[0]'),
                    entity_list.get_local_player():get_prop('m_vecVelocity[1]'),
                    entity_list.get_local_player():get_prop('m_vecVelocity[2]')):length2d() /
                cvars.sv_airaccelerate:get_int()

            if input.is_key_held(e_keys.KEY_W) then
                cmd.move.x = cmd.move.x + speed
            end
            if input.is_key_held(e_keys.KEY_A) then
                cmd.move.y = cmd.move.y - speed
            end
            if input.is_key_held(e_keys.KEY_D) then
                cmd.move.y = cmd.move.y + speed
            end
            if input.is_key_held(e_keys.KEY_S) then
                cmd.move.x = cmd.move.x - speed
            end
        end
    end)
    events.add(e_callbacks.PAINT, function()
        local lp = entity_list.get_local_player();
        if not lp then return end
        if lp == nil then return end
        if not lp:is_alive() then return end
        local on_enable = animation:process('On Enable Manual', menu.visual.manual:get() ~= 1, 9);
        if on_enable < 0.01 then return end
        local r, g, b, a = menu.visual.manuals_color:get().r, menu.visual.manuals_color:get().g,
            menu.visual.manuals_color:get().b, menu.visual.manuals_color:get().a
        local r1, g1, b1, a1 = menu.visual.desync_color:get().r, menu.visual.desync_color:get().g,
            menu.visual.desync_color:get().b, menu.visual.desync_color:get().a
        if menu.visual.manual:get() == 2 then
            if antiaim.get_manual_override() == 1 then
                render.text(render.fonts.cb, '<', vector(render.screen.x / 2 - 50 * on_enable, render.screen.y / 2 - 11),
                    color(r, g, b, math.round(200 * on_enable)))
            end
            if antiaim.get_manual_override() == 3 then
                render.text(render.fonts.cb, '>', vector(render.screen.x / 2 + 35 * on_enable, render.screen.y / 2 - 11),
                    color(r, g, b, math.round(200 * on_enable)))
            end
        end
        if menu.visual.manual:get() == 3 then
            render.triangle_filled(vector(render.screen.x / 2 - 30 * on_enable, render.screen.y / 2), 8,
                antiaim.get_manual_override() == 1 and color(r, g, b, math.round(200 * on_enable)) or color(0, 0, 0, 55),
                -90)
            render.triangle_filled(vector(render.screen.x / 2 + 30 * on_enable, render.screen.y / 2), 8,
                antiaim.get_manual_override() == 3 and color(r, g, b, math.round(200 * on_enable)) or color(0, 0, 0, 55),
                90)
        end
        if menu.visual.manual:get() == 4 then
            local add = 35
            render.rect_filled(vector(render.screen.x / 2 - add * on_enable, render.screen.y / 2 - 8), vector(-2, 16),
                not antiaim.inverted and color(0, 0, 0, math.round(55 * on_enable)) or
                color(r1, g1, b1, math.round(200 * on_enable)))
            render.triangle_filled(vector(render.screen.x / 2 - add - 3 * on_enable, render.screen.y / 2), 14,
                antiaim.get_manual_override() == 1 and color(r, g, b, math.round(200 * on_enable)) or color(0, 0, 0, 55),
                -90)

            render.rect_filled(vector(render.screen.x / 2 + add * on_enable, render.screen.y / 2 - 8), vector(2, 16),
                antiaim.inverted and color(0, 0, 0, math.round(55 * on_enable)) or
                color(r1, g1, b1, math.round(200 * on_enable)))
            render.triangle_filled(vector(render.screen.x / 2 + add + 3 * on_enable, render.screen.y / 2), 14,
                antiaim.get_manual_override() == 3 and color(r, g, b, math.round(200 * on_enable)) or color(0, 0, 0, 55),
                90)
        end
    end)
    local target_ang = vector(0, 0, 0)
    events.add(e_callbacks.SETUP_COMMAND, function(cmd)
        local ang_vec = function(ang)
            return vector(math.cos(ang.x * math.pi / 180) * math.cos(ang.y * math.pi / 180),
                math.cos(ang.x * math.pi / 180) * math.sin(ang.y * math.pi / 180), -math.sin(ang.x * math.pi / 180))
        end
        if not menu.global.toss:get() then return end
        local lplr = entity_list.get_local_player()
        if not lplr or not lplr:is_player() or not lplr:is_alive() or lplr == nil then return end
        if (lplr:get_prop('m_MoveType') == 9) then return end
        local weapon = lplr:get_active_weapon()
        if not weapon then return end

        local data = weapon:get_weapon_data()
        if not data then return end
        local lastangles = engine.get_view_angles()

        if not weapon:get_prop('m_flThrowStrength') then return end

        local ang_throw = vector(cmd.viewangles.x, cmd.viewangles.y, 0)
        ang_throw.x = ang_throw.x - (90 - math.abs(ang_throw.x)) * 10 / 90
        ang_throw = ang_vec(ang_throw)

        local throw_strength = math.clamp(weapon:get_prop('m_flThrowStrength'), 0, 1)
        local fl_velocity = math.clamp(data.throw_velocity * 0.9, 15, 750)
        fl_velocity = fl_velocity * (throw_strength * 0.7 + 0.3)
        fl_velocity = vector(fl_velocity, fl_velocity, fl_velocity)

        local localplayer_velocity = lplr:get_prop('m_vecVelocity')
        local vec_throw = (ang_throw * fl_velocity + localplayer_velocity * vector(1.45, 1.45, 1.45))
        vec_throw = vec_throw:to_angle()
        local yaw_difference = lastangles.y - vec_throw.y
        while yaw_difference > 180 do
            yaw_difference = yaw_difference - 360
        end
        while yaw_difference < -180 do
            yaw_difference = yaw_difference + 360
        end
        local pitch_difference = lastangles.x - vec_throw.x - 10
        while pitch_difference > 90 do
            pitch_difference = pitch_difference - 45
        end
        while pitch_difference < -90 do
            pitch_difference = pitch_difference + 45
        end

        target_ang.y = lastangles.y + yaw_difference
        target_ang.x = math.clamp(lastangles.x + pitch_difference, -89, 89)
        cmd.viewangles.y = target_ang.y
        cmd.viewangles.x = target_ang.x
    end)

    events.add(e_callbacks.SETUP_COMMAND, function(cmd)
        if not menu.antiaim.fast_ladder:get() then return end
        menu.refs.ladder_move:set(false)
        if not entity_list.get_local_player() then return end
        if not entity_list.get_local_player():get_prop('m_MoveType') == 9 then return end
        local view = engine.get_view_angles()
        local niggaslifer_value = 0
        local abs_value = math.abs(niggaslifer_value)
        if entity_list.get_local_player():get_prop('m_MoveType') == 9 then
            if cmd.move.x == 0 then
                cmd.viewangles.x = 89
                cmd.viewangles.y = cmd.viewangles.y + niggaslifer_value

                if abs_value > 0 and abs_value < 180 and cmd.move.y ~= 0 then
                    cmd.viewangles.y = cmd.viewangles.y - niggaslifer_value
                end
                if abs_value == 180 then
                    if cmd.move.y < 0 then
                        cmd:remove_button(e_cmd_buttons.MOVELEFT)
                        cmd:add_button(e_cmd_buttons.MOVERIGHT)
                    elseif cmd.move.y > 0 then
                        cmd:add_button(e_cmd_buttons.MOVELEFT)
                        cmd:remove_button(e_cmd_buttons.MOVERIGHT)
                    end
                end
            end
            if cmd.move.x > 0 then
                if view.x < 0 then
                    cmd.viewangles.x = 89
                    cmd:remove_button(e_cmd_buttons.MOVELEFT)
                    cmd:add_button(e_cmd_buttons.MOVERIGHT)
                    cmd:remove_button(e_cmd_buttons.FORWARD)
                    cmd:add_button(e_cmd_buttons.BACK)

                    if cmd.move.y == 0 then
                        cmd.viewangles.y = cmd.viewangles.y + 90
                    elseif cmd.move.y < 0 then
                        cmd.viewangles.y = cmd.viewangles.y + 150
                    elseif cmd.move.y > 0 then
                        cmd.viewangles.y = cmd.viewangles.y + 30
                    end
                end
            end
            if cmd.move.x < 0 then
                cmd.viewangles.x = 89
                cmd:add_button(e_cmd_buttons.MOVELEFT)
                cmd:remove_button(e_cmd_buttons.MOVERIGHT)
                cmd:add_button(e_cmd_buttons.FORWARD)
                cmd:remove_button(e_cmd_buttons.BACK)

                if cmd.move.y == 0 then
                    cmd.viewangles.y = cmd.viewangles.y + 90
                elseif cmd.move.y > 0 then
                    cmd.viewangles.y = cmd.viewangles.y + 150
                elseif cmd.move.y < 0 then
                    cmd.viewangles.y = cmd.viewangles.y + 30
                end
            end
        end
    end)
    local stop = menu.find('aimbot', 'scout', 'accuracy', 'options')
    events.add(e_callbacks.ANTIAIM, function()
        if not menu.global.jump_scout:get() then return end
        local vel = vector(entity_list.get_local_player():get_prop('m_vecVelocity[0]'),
            entity_list.get_local_player():get_prop('m_vecVelocity[1]'),
            entity_list.get_local_player():get_prop('m_vecVelocity[2]')):length2d()
        if vel < 30 or menu.refs.slowwalk:get() then
            stop:set(7, true)
        else
            stop:set(7, false)
        end
    end)

    local killsay = { '♛ Y u k i １ ３ ３ ７ ♛', '1', 'изи by night lua', 'хочешь играть так же? купи night.lua',
        'не можешь убить меня:( купи night.lua', 'ez', 'фу,жирный выблядок', 'аллах бабах чурки', 'изи выблядок',
        'iq?',
        '1 шлюха мать твою ебал', 'классно играешь', 'даже твоя мать с night.lua играет', 'ты старался',
        'бро почему сосал? потому что нет night.lua', 'спасибо за килл', 'ебать я тебя тапнул ущерб', 'l2p долбаеб',
        'ахахаха найс аа додик' }


        events.add(e_callbacks.EVENT, function(event)
        if not menu.global.killsay:get() then return end
        local lp = entity_list.get_local_player()
        local kill_cmd = 'say ' .. killsay[math.random(#killsay)]
        if entity_list.get_player_from_userid(event.attacker) ~= entity_list.get_local_player() then return end
        engine.execute_cmd(kill_cmd)
    end, 'player_death')
    local clantag = {
        'night.lua',
        'night.lu',
        'night.l',
        'night.',
        'night',
        'nigh',
        'nig',
        'ni',
        'n',
        '',
        'n',
        'ni',
        'nig',
        'nigh',
        'night',
        'night.',
        'night.l',
        'night.lu',
        'night.lua',
    }
    events.add(e_callbacks.PAINT, function()
        local defaultct = menu.find('misc', 'utility', 'general', 'clantag')
        local can_reset = false
        local local_player = entity_list.get_local_player()
        if not local_player then return end
        if not local_player:is_valid() then return end
        if menu.global.clantag:get() then
            local realtime = math.floor((globals.cur_time()) * 2.5)
            if old_time ~= realtime then
                client.set_clantag(clantag[realtime % #clantag + 1]);
                old_time = realtime;
                defaultct:set(false);
            end
        else
            local realtime = math.floor((globals.cur_time()) * 0)
            if old_time ~= realtime then
                old_time = realtime;
                defaultct:set(false);
                client.set_clantag('');
            end
        end
    end)
end
local patterns = {}; do
    patterns.firstsignature = memory.find_pattern('engine.dll', ' FF 15 ? ? ? ? 85 C0 74 0B') or
        error('Couldnt find signature #1')
    patterns.secondsignature = memory.find_pattern('engine.dll', ' FF 15 ? ? ? ? A3 ? ? ? ? EB 05') or
        error('Couldnt find signature #2')
    patterns.getaddress = ffi.cast('uint32_t**', ffi.cast('uint32_t', patterns.secondsignature) + 2)[0][0]
    patterns.getprocaddress = ffi.cast('uint32_t(__stdcall*)(uint32_t, const char*)', patterns.getaddress)
    patterns.getmodule = ffi.cast('uint32_t**', ffi.cast('uint32_t', patterns.firstsignature) + 2)[0][0]
    patterns.getprocmodule = ffi.cast('uint32_t(__stdcall*)(const char*)', patterns.getmodule)

    function patterns.process(module_name, function_name, typedef)
        local ctype = ffi.typeof(typedef)
        local module_handle = patterns.getprocmodule(module_name)
        local proc_address = patterns.getprocaddress(module_handle, function_name)
        local call_fn = ffi.cast(ctype, proc_address)
        return call_fn
    end
end

ffi.cdef [[
  typedef int BOOL;
  typedef unsigned long DWORD;
  typedef unsigned int UINT;
  typedef const char* LPCSTR;
  typedef char* LPSTR;
  typedef void* HINTERNET;

  HINTERNET InternetOpenA(LPCSTR, DWORD, LPCSTR, LPCSTR, DWORD);
  HINTERNET InternetOpenUrlA(HINTERNET, LPCSTR, LPCSTR, DWORD, DWORD, DWORD);
  UINT InternetReadFile(HINTERNET, LPSTR, UINT, UINT*);
  BOOL InternetCloseHandle(HINTERNET);
  HINTERNET InternetOpenA(LPCSTR, DWORD, LPCSTR, LPCSTR, DWORD);
  HINTERNET InternetOpenUrlA(HINTERNET, LPCSTR, LPCSTR, DWORD, DWORD, DWORD);
  UINT InternetReadFile(HINTERNET, LPSTR, UINT, UINT*);
  BOOL InternetCloseHandle(HINTERNET);
     // typedefs
     typedef void VOID;
     typedef VOID* LPVOID;
     typedef uintptr_t ULONG_PTR;
     typedef uint16_t WORD;
     typedef ULONG_PTR SIZE_T;
     typedef unsigned long DWORD;
     typedef int BOOL;
     typedef ULONG_PTR DWORD_PTR;
     typedef unsigned __int64 ULONGLONG;
     typedef DWORD * LPDWORD;
     typedef ULONGLONG DWORDLONG, *PDWORDLONG;

   // structures
   typedef struct _MEMORYSTATUSEX {
     DWORD     dwLength;
     DWORD     dwMemoryLoad;
     DWORDLONG ullTotalPhys;
     DWORDLONG ullAvailPhys;
     DWORDLONG ullTotalPageFile;
     DWORDLONG ullAvailPageFile;
     DWORDLONG ullTotalVirtual;
     DWORDLONG ullAvailVirtual;
     DWORDLONG ullAvailExtendedVirtual;
   } MEMORYSTATUSEX, *LPMEMORYSTATUSEX;

   typedef struct _SYSTEM_INFO {
         union {
        DWORD dwOemId;
       struct {
             WORD wProcessorArchitecture;
             WORD wReserved;
       } DUMMYSTRUCTNAME;
     } DUMMYUNIONNAME;
         DWORD     dwPageSize;
         LPVOID    lpMinimumApplicationAddress;
         LPVOID    lpMaximumApplicationAddress;
         DWORD_PTR dwActiveProcessorMask;
         DWORD     dwNumberOfProcessors;
         DWORD     dwProcessorType;
         DWORD     dwAllocationGranularity;
         WORD      wProcessorLevel;
         WORD      wProcessorRevision;
   } SYSTEM_INFO, *LPSYSTEM_INFO;

   // fn (winapi)
   BOOL GlobalMemoryStatusEx(LPMEMORYSTATUSEX  lpBuffer);
   void GetSystemInfo(LPSYSTEM_INFO lpSystemInfo);
]]

local wininet = {
    InternetOpenA = patterns.process('Wininet.dll', 'InternetOpenA',
        'HINTERNET(__stdcall*)(LPCSTR, DWORD, LPCSTR, LPCSTR, DWORD)'),
    InternetOpenUrlA = patterns.process('Wininet.dll', 'InternetOpenUrlA',
        'HINTERNET(__stdcall*)(HINTERNET, LPCSTR, LPCSTR, DWORD, DWORD, DWORD)'),
    InternetReadFile = patterns.process('Wininet.dll', 'InternetReadFile',
        'UINT(__stdcall*)(HINTERNET, LPSTR, UINT, UINT*)'),
    InternetCloseHandle = patterns.process('Wininet.dll', 'InternetCloseHandle', 'BOOL(__stdcall*)(HINTERNET)'),
}

local bit32   = {
    GlobalMemoryStatusEx = patterns.process('Kernel32.dll', 'GlobalMemoryStatusEx',
        'BOOL(__stdcall*)(LPMEMORYSTATUSEX  lpBuffer)'),
    GetSystemInfo = patterns.process('Kernel32.dll', 'GetSystemInfo', 'void(__stdcall*)(LPSYSTEM_INFO lpSystemInf)'),
    bxor = function(a, b)
        local result = 0
        local bitval = 1
        while a > 0 or b > 0 do
            local bit_a, bit_b = a % 2, b % 2
            if bit_a ~= bit_b then
                result = result + bitval
            end
            a = math.floor(a / 2)
            b = math.floor(b / 2)
            bitval = bitval * 2
        end
        return result
    end
}
local hwid    = function()
    local function GetTotalMemory()
        local m_struct = ffi.new('MEMORYSTATUSEX')
        m_struct.dwLength = ffi.sizeof(m_struct)
        bit32.GlobalMemoryStatusEx(ffi.cast('MEMORYSTATUSEX&', m_struct))
        local memorysize = tonumber(m_struct.ullTotalPhys / (1024 * 1024))
        return memorysize
    end

    local function GetProcessorInfo()
        local systeminfo = ffi.new('SYSTEM_INFO')
        bit32.GetSystemInfo(ffi.cast('SYSTEM_INFO&', systeminfo))
        local processorInfo = {
            ['NumberOfProcessors'] = systeminfo.dwNumberOfProcessors,
            ['ProcessorLevel'] = systeminfo.wProcessorLevel,
            ['ProcessorRevision'] = systeminfo.wProcessorRevision,
            ['ProcessorType'] = systeminfo.dwProcessorType
        }
        return processorInfo
    end

    local PhysicalMemory = GetTotalMemory()
    local processor_table = GetProcessorInfo()
    local numberOfProcessors = processor_table['NumberOfProcessors']
    local processorLevel = processor_table['ProcessorLevel']
    local processorRevision = processor_table['ProcessorRevision']
    local processorType = processor_table['ProcessorType']

    local t, modOfPhysMemoryAndProcRevision = math.modf(PhysicalMemory / processorRevision)
    local modOfPhysMemoryAndProcRevisionToInt = math.round(modOfPhysMemoryAndProcRevision, 3) * 1000
    local calculateHardWareInfo = math.round(
        (processorLevel * (processorRevision * PhysicalMemory)) / numberOfProcessors, 0)

    local xoredHardwareInfo = bit32.bxor(calculateHardWareInfo, modOfPhysMemoryAndProcRevisionToInt) * processorType
    local totalResultXorInfo = xoredHardwareInfo * 3
    return totalResultXorInfo
end
local function http_get(url)
    local h_internet = wininet.InternetOpenA('LuaJIT', 0, nil, nil, 0)
    local h_url = wininet.InternetOpenUrlA(h_internet, url, nil, 0, 0x04000000, 0)
    local buffer = ffi.new('char[?]', 4096)
    local bytes_read = ffi.new('UINT[1]')
    bytes_read[0] = 0
    local response = ''
    while wininet.InternetReadFile(h_url, buffer, ffi.sizeof(buffer), bytes_read) ~= 0 and bytes_read[0] ~= 0 do
        response = response .. ffi.string(buffer, bytes_read[0])
        bytes_read[0] = 0
    end
    wininet.InternetCloseHandle(h_url)
    wininet.InternetCloseHandle(h_internet)
    return response
end

local s = {}; do
    s.l = 'https://raw.githubusercontent.com/L3V1Y/night/refs/heads/main/primo_beta'
    local InternetGetConnectedState = patterns.process('Wininet.dll', 'InternetGetConnectedState',
        'int(__stdcall*)(int* lpdwFlags, int dwReserved)')
    local function isInternetConnected()
        local flags = ffi.new('int[1]')
        local connected = InternetGetConnectedState(flags, 0)

        return connected == 1
    end
    s.process = function(self)
        local a = http_get(self.l)
        if isInternetConnected() then
            if string.find(a, hwid()) then
                events.add(e_callbacks.DRAW_WATERMARK, function (watermark_text)
                    return "night - beta"
                end)
                menu.init()
                antiaim.init()
            elseif not string.find(a, hwid()) then
                print(
                    '\n\n\nHello, your hwid not in database. Create ticket at night discord server and send this: ' ..
                    hwid() .. '\n\n\n')
            end
        end
    end
    s:process()
end
end)()