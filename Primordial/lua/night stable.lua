local ffi = require('ffi')
local info = {
    script = 'night',
    build = 'dev',
    name = 'admin',
}
local redifine = function(t)
    local c = {}; for k, v in next, t do c[k] = v end
    return c
end;
local math, table, string, render, ffi, menu, antiaim = redifine(math), redifine(table), redifine(string),
    redifine(render), redifine(ffi), redifine(menu), redifine(antiaim);
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

lib = {}; do
    lib.clipboard = {}; do
        ffi.cdef [[ typedef int(__thiscall* get_clipboard_text_count)(void*); typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int); typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);]]
        lib.clipboard.VGUI_System_dll = memory.create_interface('vgui2.dll', 'VGUI_System010')
        lib.clipboard.VGUI_System = ffi.cast(ffi.typeof('void***'), lib.clipboard.VGUI_System_dll)
        lib.clipboard.get_clipboard_text_count = ffi.cast('get_clipboard_text_count',
            lib.clipboard.VGUI_System[0][7])
        lib.clipboard.get_clipboard_text = ffi.cast('get_clipboard_text', lib.clipboard.VGUI_System[0][11])
        lib.clipboard.set_clipboard_text = ffi.cast('set_clipboard_text', lib.clipboard.VGUI_System[0][9])

        function lib.clipboard:set(...)
            return lib.clipboard.set_clipboard_text(lib.clipboard.VGUI_System, ..., (...):len());
        end;

        function lib.clipboard:get()
            local clipboard_text_length = lib.clipboard.get_clipboard_text_count(lib.clipboard.VGUI_System);
            if clipboard_text_length > 0 then
                local buffer = ffi.new('char[?]', clipboard_text_length);
                local size = clipboard_text_length * ffi.sizeof('char[?]', clipboard_text_length);
                lib.clipboard.get_clipboard_text(lib.clipboard.VGUI_System, 0, buffer, size);
                return tostring(ffi.string(buffer, clipboard_text_length - 1));
            else
                return '';
            end;
        end;
    end;

    lib.base64 = {}; do
        lib.base64.makeencoder     = function(alphabet)
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
        lib.base64.makedecoder     = function(alphabet)
            local decoder = {}
            for b64code, charcode in pairs(lib.base64.makeencoder(alphabet)) do
                decoder[charcode] = b64code
            end
            return decoder
        end

        lib.base64.DEFAULT_ENCODER = lib.base64.makeencoder(
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=')
        lib.base64.DEFAULT_DECODER = lib.base64.makedecoder(
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=')
        lib.base64.CUSTOM_ENCODER  = lib.base64.makeencoder(
        'KmAWpuFBOhdbI1orP2UN5vnSJcxVRgazk97ZfQqL0yHCl84wTj3eYXiD6stEGM+/=')
        lib.base64.CUSTOM_DECODER  = lib.base64.makedecoder(
        'KmAWpuFBOhdbI1orP2UN5vnSJcxVRgazk97ZfQqL0yHCl84wTj3eYXiD6stEGM+/=')
        local extract                  = function(v, from, width)
            return bit.band(bit.rshift(v, from), bit.lshift(1, width) - 1)
        end
        lib.base64.encode          = function(str, encoder, usecaching)
            str = tostring(str)
            encoder = encoder or lib.base64.CUSTOM_ENCODER
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
        lib.base64.decode          = function(b64, decoder, usecaching)
            decoder = decoder or lib.base64.CUSTOM_DECODER
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

        function ui.elements:visible(value)
            return self.item:set_visible(value)
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
                item = menu.add_text(self.group, name)
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

        ui.group.save = function(type, class)
            type = type or nil

            local data = {}; for _, v in pairs(ui.elements.data) do
                if v.type == 'button' then
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
            return lib.base64.encode(string.format('CFG:%s', table.to_string(ui.group.save(type, class))))
        end

        ui.group.load_string = function(string, type, class, rewrite_class)
            local str = string
            if not str then
                return print('Clipboard is nil.')
            end; str = lib.base64.decode(str)

            if not string.find(str, 'CFG:') then
                return print('Invalid clipboard.')
            end

            str = string.gsub(str, 'CFG:', '')
            ui.group.load(loadstring('return ' .. str:gsub('(\'.-\'):(.-),', '[%1]=%2,\n'))(), type, class,
                rewrite_class)
        end

        ui.export = function(type, class)
            lib.clipboard:set(ui.group.save_as_string(type, class))
        end

        ui.import = function(string, type, class, rewrite_class)
            ui.group.load_string(string, type, class, rewrite_class)
        end
    end
end



local animation = {}
do
    animation.data = {}
    animation.spinn = {}
    function animation:spin(key, from, to, speed, iterations, initial_value)
        self.spinn[key] = self.spinn[key] or {
            active = 0,
            method = 'spin',
            start = math.min(from, to),
            target = math.max(from, to),
            speed = speed or 4,
            iterations = iterations or 1,
            value = initial_value or from
        }

        local this = self.spinn[key]

        this.start, this.target = math.min(from, to), math.max(from, to)
        this.speed, this.iterations = speed, iterations

        return this
    end

    function animation:tick(tick)
        for key, state in pairs(self.spinn) do
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
    };
    menu.init = function()
        menu.tab = {
            global = ui.create('night - welcome'),
            misc = ui.create('night - misc'),
            visual = ui.create('night - visual'),
            antiaim = ui.create('night - antiaim'),
            state = ui.create('night - state'),
        };
        menu.global = {};
        menu.global.navigation = menu.tab.global:list('navigation', { 'global', 'anti-aim' }, 2);
        menu.global.info = menu.tab.global:label(string.format('welcome back, %s', user.name));
        menu.global.info2 = menu.tab.global:label('made by l3v1y with love//');
        menu.tab.global:separator();
        menu.global.accent = menu.tab.global:label('accent color');
        menu.global.color = menu.global.accent:color('accent');
        --//xx global
        menu.global.fakelag = menu.tab.misc:switch('fakelag improver');
        menu.global.no_fall_damage = menu.tab.misc:switch('no fall damage');
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
        menu.visual.indicators_type = menu.tab.visual:combo('indicator font', { 'verdana', 'pixel' })
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


        --//xx antiaim
        menu.antiaim = {};
        menu.antiaim.mode = menu.tab.antiaim:list('builder mode', { 'default', 'defensive' }, 2);
        menu.antiaim.def = menu.tab.antiaim:combo('defensive mode', { 'gamesense', 'neverlose' })
        menu.tab.antiaim:separator();
        menu.antiaim.fast_ladder = menu.tab.antiaim:switch('fast ladder');
        menu.antiaim.safehead = menu.tab.antiaim:switch('safe head');
        menu.antiaim.ebait = menu.tab.antiaim:switch('e-bait while safehead');
        menu.builder = {};
        menu.builder.tab = {};
        menu.defensive = {};
        menu.builder.state = menu.tab.state:list('state', states.global, #states.global)
        for i = 1, #states.global do
            menu.builder.tab[i] = {
                tab = ui.create(states.global[i])
            }
            menu.builder[i] = {
                
                enable = menu.builder.tab[i].tab:switch('enable' .. states.builder[i]),
                pitch = menu.builder.tab[i].tab:combo('pitch' .. states.builder[i],
                    { 'none', 'down', 'up', 'zero', 'jitter', 'custom', 'random', 'spin' }),
                pitchspeed = menu.builder.tab[i].tab:slider('spin speed' .. states.builder[i], 0, 480, 10),
                custom = menu.builder.tab[i].tab:slider('\n' .. states.builder[i], -89, 89, 1, nil, '°'),
                base = menu.builder.tab[i].tab:combo('yaw base' .. states.builder[i], { 'local view', 'at target' }),
                yaw = menu.builder.tab[i].tab:combo('yaw' .. states.builder[i], { 'static', 'l/r', 'tick', 'x-way' }),
                static = menu.builder.tab[i].tab:slider('static' .. states.builder[i], -180, 180, 1, nil, '°'),
                leftyaw = menu.builder.tab[i].tab:slider('left' .. states.builder[i], -180, 180, 1, nil, '°'),
                rightyaw = menu.builder.tab[i].tab:slider('right' .. states.builder[i], -180, 180, 1, nil, '°'),
                slowed = menu.builder.tab[i].tab:slider('slowed tick' .. states.builder[i], 2, 12, 1, nil, 't'),
                yaw_tick_start = menu.builder.tab[i].tab:slider('yaw tick start' .. states.builder[i], 2, 14, 1),
                yaw_tick_end = menu.builder.tab[i].tab:slider('yaw tick end' .. states.builder[i], 2, 14, 1),
                xway = menu.builder.tab[i].tab:slider('way' .. states.builder[i], 2, 5, 1, nil, 'w'),
                way1 = menu.builder.tab[i].tab:slider('way 1' .. states.builder[i], -180, 180, 1, nil, '°'),
                way2 = menu.builder.tab[i].tab:slider('way 2' .. states.builder[i], -180, 180, 1, nil, '°'),
                way3 = menu.builder.tab[i].tab:slider('way 3' .. states.builder[i], -180, 180, 1, nil, '°'),
                way4 = menu.builder.tab[i].tab:slider('way 4' .. states.builder[i], -180, 180, 1, nil, '°'),
                way5 = menu.builder.tab[i].tab:slider('way 5' .. states.builder[i], -180, 180, 1, nil, '°'),

                jitter = menu.builder.tab[i].tab:combo('jitter' .. states.builder[i], { 'off', 'offset', 'center' }),
                range = menu.builder.tab[i].tab:slider('range' .. states.builder[i], -180, 180, 1),
                randomize = menu.builder.tab[i].tab:slider('randomize' .. states.builder[i], -180, 180, 1),

                spin = menu.builder.tab[i].tab:switch('spin' .. states.builder[i]),
                spinrange = menu.builder.tab[i].tab:slider('spin range' .. states.builder[i], 0, 360, 10),
                spinspeed = menu.builder.tab[i].tab:slider('speed' .. states.builder[i], 0, 480, 10),
                spininvert = menu.builder.tab[i].tab:switch('invert spin' .. states.builder[i]),

                fake = menu.builder.tab[i].tab:combo('fake' .. states.builder[i], { 'off', 'static', 'jitter' }),
                fakel = menu.builder.tab[i].tab:slider('left fake' .. states.builder[i], 0, 100, 1),
                faker = menu.builder.tab[i].tab:slider('right fake' .. states.builder[i], 0, 100, 1),
                invert = menu.builder.tab[i].tab:switch('invert fake' .. states.builder[i])
            }
            menu.defensive[i] = {
                force = menu.builder.tab[i].tab:combo('! force mode' .. states.defensive[i], { 'off', 'always on', 'flick' }), --menu.builder.tab[i].tab:switch('! force defensive' .. states.defensive[i]),
                fakelag = menu.builder.tab[i].tab:switch('! disable fakelag on defensive' .. states.defensive[i]),
                enable = menu.builder.tab[i].tab:switch('! enable' .. states.defensive[i]),
                tick_start = menu.builder.tab[i].tab:slider('! tick start' .. states.defensive[i], 1, 13, 1, nil, 't'),
                tick_end = menu.builder.tab[i].tab:slider('! tick end' .. states.defensive[i], 1, 13, 1, nil, 't'),
                pitch = menu.builder.tab[i].tab:combo('! pitch' .. states.defensive[i],
                    { 'none', 'down', 'up', 'zero', 'jitter', 'custom', 'random', 'spin' }),
                pitchspeed = menu.builder.tab[i].tab:slider('! spin speed' .. states.defensive[i], 0, 480, 10),
                custom = menu.builder.tab[i].tab:slider('! \n' .. states.defensive[i], -89, 89, 1, nil, '°'),
                base = menu.builder.tab[i].tab:combo('! yaw base' .. states.defensive[i], { 'local view', 'at target' }),
                yaw = menu.builder.tab[i].tab:combo('! yaw' .. states.defensive[i], { 'static', 'l/r', 'tick', 'x-way' }),
                yaw_tick_start = menu.builder.tab[i].tab:slider('! yaw tick start' .. states.defensive[i], 2, 14, 1),
                yaw_tick_end = menu.builder.tab[i].tab:slider('! yaw tick end' .. states.defensive[i], 2, 14, 1),
                static = menu.builder.tab[i].tab:slider('! static' .. states.defensive[i], -180, 180, 1, nil, '°'),
                leftyaw = menu.builder.tab[i].tab:slider('! left' .. states.defensive[i], -180, 180, 1, nil, '°'),
                rightyaw = menu.builder.tab[i].tab:slider('! right' .. states.defensive[i], -180, 180, 1, nil, '°'),
                slowed = menu.builder.tab[i].tab:slider('! slowed ticks' .. states.defensive[i], 2, 12, 1, nil, 't'),
                xway = menu.builder.tab[i].tab:slider('! way' .. states.defensive[i], 2, 5, 1, nil, 'w'),
                way1 = menu.builder.tab[i].tab:slider('! way 1' .. states.defensive[i], -180, 180, 1, nil, '°'),
                way2 = menu.builder.tab[i].tab:slider('! way 2' .. states.defensive[i], -180, 180, 1, nil, '°'),
                way3 = menu.builder.tab[i].tab:slider('! way 3' .. states.defensive[i], -180, 180, 1, nil, '°'),
                way4 = menu.builder.tab[i].tab:slider('! way 4' .. states.defensive[i], -180, 180, 1, nil, '°'),
                way5 = menu.builder.tab[i].tab:slider('! way 5' .. states.defensive[i], -180, 180, 1, nil, '°'),
            
                jitter = menu.builder.tab[i].tab:combo('! jitter' .. states.defensive[i], { 'off', 'offset', 'center' }),
                range = menu.builder.tab[i].tab:slider('! range' .. states.defensive[i], -360, 360, 1),
                randomize = menu.builder.tab[i].tab:slider('! randomize' .. states.defensive[i], -360, 360, 1),
            
                spin = menu.builder.tab[i].tab:switch('! spin' .. states.defensive[i]),
                spinrange = menu.builder.tab[i].tab:slider('! spin range' .. states.defensive[i], 0, 360, 10),
                spinspeed = menu.builder.tab[i].tab:slider('! speed' .. states.defensive[i], 0, 480, 10),
                spininvert = menu.builder.tab[i].tab:switch('! invert spin' .. states.defensive[i]),
            
                fake = menu.builder.tab[i].tab:combo('! fake' .. states.defensive[i], { 'off', 'static', 'jitter' }),
                fakel = menu.builder.tab[i].tab:slider('! left fake' .. states.defensive[i], 0, 100, 1),
                faker = menu.builder.tab[i].tab:slider('! right fake' .. states.defensive[i], 0, 100, 1),
                invert = menu.builder.tab[i].tab:switch('! invert fake' .. states.defensive[i])
            }
        end
        callbacks.add(e_callbacks.PAINT, function()
            local tab = menu.global.navigation:get();
            menu.tab.misc:visible(tab == 1);
            menu.global.ground:visible(menu.global.breakers:get() == 1);
            menu.global.air:visible(menu.global.breakers:get() == 2);
            menu.global.lean:visible(menu.global.breakers:get() == 3);
            menu.global.pitch:visible(menu.global.breakers:get() == 3);

            menu.tab.visual:tab(3);
            menu.tab.visual:visible(tab == 1);
            menu.visual.indicators_type:visible(menu.visual.indicators:get())
            menu.visual.damage_type:visible(menu.visual.damage:get())
            menu.visual.side:visible(menu.visual.manual:get() ~= 1);
            menu.visual.desync:visible(menu.visual.manual:get() == 4);
            menu.tab.state:tab(2)
            menu.tab.state:visible(tab == 2);
            menu.tab.antiaim:visible(tab == 2);
            menu.tab.antiaim:tab(1);

            for i = 1, #states.global do
                menu.builder.tab[i].tab:visible(tab == 2 and menu.builder.state:get() == i);
                menu.builder.tab[i].tab:tab(3)
                local aa = menu.antiaim.mode:get() == 1 and menu.builder[i] or menu.defensive[i]
                local global = true
                if i ~= 1 then
                    global = aa.enable:get()
                else
                    global = true
                end
                menu.builder[i].enable:visible(menu.builder.state:get() == i and i ~= 1 and menu.antiaim.mode:get() == 1);
                menu.builder[i].pitch:visible(global and menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].custom:visible(global and menu.builder.state:get() == i and
                    menu.builder[i].pitch:get() == 6 and menu.antiaim.mode:get() == 1);
                menu.builder[i].pitchspeed:visible(global and menu.builder.state:get() == i and
                    menu.builder[i].pitch:get() == 8 and menu.antiaim.mode:get() == 1);
                menu.builder[i].base:visible(global and menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].yaw:visible(global and menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].static:visible(global and menu.builder[i].yaw:get() == 1 and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].leftyaw:visible(global and
                    (menu.builder[i].yaw:get() == 2 or menu.builder[i].yaw:get() == 3) and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].rightyaw:visible(global and
                    (menu.builder[i].yaw:get() == 2 or menu.builder[i].yaw:get() == 3) and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].yaw_tick_start:visible(global and menu.builder[i].yaw:get() == 3 and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].yaw_tick_end:visible(global and menu.builder[i].yaw:get() == 3 and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].slowed:visible(global and menu.builder[i].yaw:get() == 2 and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].xway:visible(global and menu.builder[i].yaw:get() == 4 and menu.builder.state:get() == i and
                    menu.antiaim.mode:get() == 1);
                menu.builder[i].way1:visible(global and menu.builder[i].yaw:get() == 4 and
                    menu.builder[i].xway:get() >= 2 and menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].way2:visible(global and menu.builder[i].yaw:get() == 4 and
                    menu.builder[i].xway:get() >= 2 and menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].way3:visible(global and menu.builder[i].yaw:get() == 4 and
                    menu.builder[i].xway:get() >= 3 and menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].way4:visible(global and menu.builder[i].yaw:get() == 4 and
                    menu.builder[i].xway:get() >= 4 and menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].way5:visible(global and menu.builder[i].yaw:get() == 4 and
                    menu.builder[i].xway:get() >= 5 and menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].jitter:visible(global and menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].range:visible(global and menu.builder[i].jitter:get() ~= 1 and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].randomize:visible(global and menu.builder[i].jitter:get() ~= 1 and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);

                menu.builder[i].spin:visible(global and menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].spinrange:visible(global and menu.builder[i].spin:get() and menu.builder.state:get() == i and
                    menu.antiaim.mode:get() == 1);
                menu.builder[i].spinspeed:visible(global and menu.builder[i].spin:get() and menu.builder.state:get() == i and
                    menu.antiaim.mode:get() == 1);
                menu.builder[i].spininvert:visible(global and menu.builder[i].spin:get() and
                    menu.builder.state:get() == i and
                    menu.antiaim.mode:get() == 1);

                menu.builder[i].fake:visible(global and menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].invert:visible(global and menu.builder.state:get() == i and menu.antiaim.mode:get() == 1 and
                    menu.builder[i].fake:get() ~= 1);
                menu.builder[i].fakel:visible(global and menu.builder[i].fake:get() ~= 1 and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);
                menu.builder[i].faker:visible(global and menu.builder[i].fake:get() ~= 1 and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 1);

                global = menu.defensive[i].enable:get()
                menu.defensive[i].force:visible(menu.builder.state:get() == i and menu.antiaim.mode:get() == 2)
                menu.defensive[i].fakelag:visible(menu.builder.state:get() == i and menu.antiaim.mode:get() == 2)
                menu.defensive[i].enable:visible(menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].tick_start:visible(global and menu.builder.state:get() == i and
                    menu.antiaim.mode:get() == 2);
                menu.defensive[i].tick_end:visible(global and menu.builder.state:get() == i and
                    menu.antiaim.mode:get() == 2);
                menu.defensive[i].pitch:visible(global and menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].custom:visible(global and menu.builder.state:get() == i and
                    menu.defensive[i].pitch:get() == 6 and menu.antiaim.mode:get() == 2);
                menu.defensive[i].pitchspeed:visible(global and menu.builder.state:get() == i and
                    menu.defensive[i].pitch:get() == 8 and menu.antiaim.mode:get() == 2);

                menu.defensive[i].base:visible(global and menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].yaw:visible(global and menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].static:visible(global and menu.defensive[i].yaw:get() == 1 and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].leftyaw:visible(global and
                    (menu.defensive[i].yaw:get() == 2 or menu.defensive[i].yaw:get() == 3) and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].rightyaw:visible(global and
                    (menu.defensive[i].yaw:get() == 2 or menu.defensive[i].yaw:get() == 3) and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);

                menu.defensive[i].yaw_tick_start:visible(global and menu.defensive[i].yaw:get() == 3 and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].yaw_tick_end:visible(global and menu.defensive[i].yaw:get() == 3 and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);

                menu.defensive[i].slowed:visible(global and menu.defensive[i].yaw:get() == 2 and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].xway:visible(global and menu.defensive[i].yaw:get() == 4 and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].way1:visible(global and menu.defensive[i].yaw:get() == 4 and
                    menu.defensive[i].xway:get() >= 2 and menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].way2:visible(global and menu.defensive[i].yaw:get() == 4 and
                    menu.defensive[i].xway:get() >= 2 and menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].way3:visible(global and menu.defensive[i].yaw:get() == 4 and
                    menu.defensive[i].xway:get() >= 3 and menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].way4:visible(global and menu.defensive[i].yaw:get() == 4 and
                    menu.defensive[i].xway:get() >= 4 and menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].way5:visible(global and menu.defensive[i].yaw:get() == 4 and
                    menu.defensive[i].xway:get() >= 5 and menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].jitter:visible(global and menu.builder.state:get() == i and
                    menu.antiaim.mode:get() == 2);
                menu.defensive[i].range:visible(global and menu.defensive[i].jitter:get() ~= 1 and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].randomize:visible(global and menu.defensive[i].jitter:get() ~= 1 and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);

                menu.defensive[i].spin:visible(global and menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].spinrange:visible(global and menu.defensive[i].spin:get() and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].spinspeed:visible(global and menu.defensive[i].spin:get() and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].spininvert:visible(global and menu.defensive[i].spin:get() and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].fake:visible(global and menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].invert:visible(global and menu.builder.state:get() == i and
                    menu.antiaim.mode:get() == 2 and menu.defensive[i].fake:get() ~= 1);
                menu.defensive[i].fakel:visible(global and menu.defensive[i].fake:get() ~= 1 and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
                menu.defensive[i].faker:visible(global and menu.defensive[i].fake:get() ~= 1 and
                    menu.builder.state:get() == i and menu.antiaim.mode:get() == 2);
            end
        end)
    end
end
antiaim.init = function()
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

    callbacks.add(e_callbacks.PAINT, function()
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
    callbacks.add(e_callbacks.PAINT, function()
        if not menu.visual.velocity:get() then return end;
        local lp = entity_list.get_local_player();
        if not lp then return end;
        if lp == nil then return end
        if not lp:is_alive() then return end;
        local slowed = lp:get_prop('m_flVelocityModifier');
        local stat = 1 - slowed
        local r, g, b = menu.global.color:get().r, menu.global.color:get().g, menu.global.color:get().b
        if stat > 0 then
            render.texture(render.icon.velocity.id, vector(render.screen.x / 2 - 10, 130), vector(21, 21),
                color(255, 255, 255, math.round(200 * stat)))
            render.rect_filled(vector(render.screen.x / 2 - 74, 155), vector(74 * 2, 6),
                color(0, 0, 0, math.round(200 * stat)), 4)
            render.rect_filled(vector(render.screen.x / 2 - (72 * stat), 157), vector((72 * 2) * stat, 2),
                color(r, g, b, math.round(200 * stat)), 4)
        end
    end)
    callbacks.add(e_callbacks.PAINT, function()
        if not menu.visual.defensive:get() then return end;
        local lp = entity_list.get_local_player();
        if not lp then return end;
        if lp == nil then return end
        if not lp:is_alive() then return end;
        local anim = animation:process('Defensive Warning', antiaim.is_defensive, 7);
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
    callbacks.add(e_callbacks.PAINT, function()
        local lp = entity_list.get_local_player();
        if not lp then return end
        if lp == nil then return end
        if not lp:is_alive() then return end
        menu.refs.damage = menu.find('aimbot', helper.get_weapon_group(), 'target overrides', 'min. damage')[2];
        menu.refs.lethal = menu.find('aimbot', helper.get_weapon_group(), 'target overrides', 'lethal shot')[2];
        menu.refs.hitbox = menu.find('aimbot', helper.get_weapon_group(), 'target overrides', 'hitbox')[2];
        menu.refs.safepoint = menu.find('aimbot', helper.get_weapon_group(), 'target overrides', 'safepoint')[2];
        menu.refs.hitchance = menu.find('aimbot', helper.get_weapon_group(), 'target overrides', 'hitchance')[2];
        local to_parse = {
            {
                text = 'doubletap',
                key = menu.refs.doubletap,
                color = color(255, 255, 255, 200),
            },
            {
                text = 'hideshot',
                key = menu.refs.hideshots,
                color = color(255, 255, 255, 200),
            },
            {
                text = 'minimum',
                key = menu.refs.damage,
                color = color(255, 255, 255, 200),
            },
            {
                text = 'lethal',
                key = menu.refs.lethal,
                color = color(255, 255, 255, 200),
            },
            {
                text = 'hitbox',
                key = menu.refs.hitbox,
                color = color(255, 255, 255, 200),
            },
        }
        local on_enable = animation:process('On Enable Indicators', menu.visual.indicators:get(), 9)
        if on_enable < 0.1 then return end
        local ay = 0;
        local scoped = lp:get_prop('m_bIsScoped');
        local anim = animation:process('Scoped Indicators', scoped == 1, 12) * on_enable
        local add = 35 * anim
        local font = menu.visual.indicators_type:get() == 1 and render.fonts.verdana or render.fonts.pixel
        local additive = menu.visual.indicators_type:get() == 1 and 12 or 10
        local r, g, b = menu.global.color:get().r, menu.global.color:get().g, menu.global.color:get().b
        local txt = helper.gradient('night.project', globals.real_time(), color(r, g, b, math.round(255 * on_enable)),
            color(55, 55, 55, math.round(255 * on_enable)))
        render.text(font, txt, vector(render.screen.x / 2 + add, render.screen.y / 2 + 25),
            color(r, g, b, math.round(255 * on_enable)), true);
        for k, v in ipairs(to_parse) do
            v.anim = animation:process(v.text .. 'Animate Indicators', v.key:get(), 12) * on_enable;
            if v.anim > 0 then
                render.text(font, v.text, vector(render.screen.x / 2 + add, render.screen.y / 2 + 25 + ay + additive),
                    color(r, g, b, math.round((255 * on_enable) * v.anim)), true);
                ay = ay + additive * v.anim
            end
        end
    end)
    callbacks.add(e_callbacks.WORLD_HITMARKER,
        function(screen_pos, world_pos, alpha_factor, damage, is_lethal, is_headshot)
            render.push_alpha_modifier(alpha_factor)
            render.rect_fade(vector(screen_pos.x, screen_pos.y - 10 / 5 * 2), vector(2, 10), menu.visual.hitcolor:get(),
                menu.visual.hitcolor:get(), true)
            render.rect_fade(vector(screen_pos.x - 10 / 5 * 2, screen_pos.y), vector(10, 2), menu.visual.hitcolor:get(),
                menu.visual.hitcolor:get(), true)
            render.pop_alpha_modifier()
            return true
        end)
    callbacks.add(e_callbacks.PAINT, function()
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
    callbacks.add(e_callbacks.PAINT, function()
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
    callbacks.add(e_callbacks.DRAW_MODEL, function(ctx)
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
    callbacks.add(e_callbacks.PAINT, function()
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
    local aa; do
        antiaim.get_state = function(ent)
            local vel = vector(entity_list.get_local_player():get_prop('m_vecVelocity[0]'),
                entity_list.get_local_player():get_prop('m_vecVelocity[1]'),
                entity_list.get_local_player():get_prop('m_vecVelocity[2]')):length2d()
            if not ent:has_player_flag(e_player_flags.ON_GROUND) or input.is_key_held(input.find_key_bound_to_binding('jump')) then
                if ent:has_player_flag(e_player_flags.DUCKING) then
                    return 8
                else
                    return 7
                end
            end
            if ent:has_player_flag(e_player_flags.DUCKING) or antiaim.is_fakeducking() then
                if menu.builder[6].enable:get() then
                    if vel > 5 then
                        return 6
                    end
                end
                return 5
            end
            if menu.refs.slowwalk:get() then
                return 4
            end
            if vel > 5 and ent:has_player_flag(e_player_flags.ON_GROUND) then
                return 3
            else
                return 2
            end
        end
        antiaim.tickbase = 0;
        antiaim.tick_defensive = 0
        antiaim.type = 1
        antiaim.start = 0;
        antiaim._end = 14;
        antiaim.sim = 0;
        callbacks.add(e_callbacks.NET_UPDATE, function()
            antiaim.type = menu.antiaim.def:get()
            if menu.antiaim.ebait:get() and antiaim.safehead then
                antiaim.type = 2
            end
            local me = entity_list.get_local_player()
            if not me then return end
            antiaim.tickbase = me:get_prop('m_nTickBase') or 0
        end)
        callbacks.add(e_callbacks.NET_UPDATE, function()
            if antiaim.type == 2 then return end
            if not entity_list.get_local_player() then return end
            if math.abs(antiaim.tickbase - antiaim.tickbase_max) > 64 then
                antiaim.tickbase_max = 0
            end

            local defensive_ticks_left = 0;

            if antiaim.tickbase > antiaim.tickbase_max then
                antiaim.tickbase_max = antiaim.tickbase
            elseif antiaim.tickbase_max > antiaim.tickbase then
                defensive_ticks_left = math.min(14, math.max(0, antiaim.tickbase_max - antiaim.tickbase - 1))
            end
            antiaim.tick_defensive = defensive_ticks_left
            antiaim.is_defensive = defensive_ticks_left >= antiaim.start and defensive_ticks_left <= antiaim._end and
                antiaim.get_manual_override() == 0 and
                exploits.get_charge() == exploits.get_max_charge() and menu.refs.doubletap:get()
            return
        end)
        local entity_list_ = memory.create_interface("client.dll", "VClientEntityList003")
        local engine_client = memory.create_interface("engine.dll", "VEngineClient014")

        local entity_list_vftable = ffi.cast("void***", entity_list_)
        local engine_client_vftable = ffi.cast("void***", engine_client)

        local get_local_player_fn = ffi.typeof("int( __thiscall* )( void* )")
        local get_local_player = ffi.cast(get_local_player_fn, memory.get_vfunc(engine_client, 12))

        local get_client_entity_fn = ffi.typeof("void*( __thiscall* )( void*, int )")
        local get_client_entity = ffi.cast(get_client_entity_fn, memory.get_vfunc(entity_list_, 3))

        callbacks.add(e_callbacks.NET_UPDATE, function()
            if antiaim.type == 1 then return end
            if not entity_list.get_local_player() or entity_list.get_local_player() == nil or not entity_list.get_local_player():is_alive() then return end
            local local_player = get_client_entity(entity_list_vftable, get_local_player(engine_client_vftable))
            if not local_player or local_player == nil then return end
            local tickcount = globals.tick_count()
            local m_flOldSimulationTime = ffi.cast("float*", ffi.cast("uintptr_t", local_player) + 0x26C)[0]
            local m_flSimulationTime = entity_list.get_local_player():get_prop('m_flSimulationTime')

            local delta = m_flOldSimulationTime - m_flSimulationTime

            if delta > 0 then
                antiaim.tick_defensive = tickcount +
                client.time_to_ticks(delta - engine.get_latency(e_latency_flows.INCOMING))
            end


            antiaim.is_defensive = tickcount <= antiaim.tick_defensive - 2 and
                antiaim.get_manual_override() == 0 and
                exploits.get_charge() == exploits.get_max_charge() and menu.refs.doubletap:get()
            --[[            local sim_time = client.time_to_ticks(entity_list.get_local_player():get_prop('m_flSimulationTime'))
            local sim_diff = sim_time - antiaim.sim

            if sim_diff < 0 then
                antiaim.tick_defensive = tickcount + math.abs(sim_diff) -
                client.time_to_ticks(engine.get_latency(e_latency_flows.INCOMING))
            end

            antiaim.sim = sim_time

            antiaim.is_defensive = antiaim.tick_defensive > tickcount and
                antiaim.get_manual_override() == 0 and
                exploits.get_charge() == exploits.get_max_charge() and menu.refs.doubletap:get()]]
        end)
        callbacks.add(e_callbacks.ANTIAIM, function()
            if not menu.global.fakelag:get() then return end
            local lp = entity_list.get_local_player();
            local state = antiaim.get_state(lp)
            if state == 8 or state == 7 then
                local fl2 = client.random_int(1, 14)
                menu.refs.amount:set(fl2 >= 6 and 1 or 15)
                menu.refs.breaklc:set(fl2 >= 8)
            else
                local fl2 = client.random_int(10, 15)
                menu.refs.amount:set(fl2)
                menu.refs.breaklc:set(true)
            end
        end)
        local ground_tick = 1
        local end_time = 0
        local jitter = false
        antiaim.inverted = false;
        antiaim.yaw = 0;
        antiaim.jitter = 0;
        antiaim.safehead = false;
        antiaim.way = 1;
        antiaim.side = false;
        antiaim.spin = 0
        callbacks.add(e_callbacks.SETUP_COMMAND, function()
            if engine.get_choked_commands() == 0 then
                jitter = not jitter
            end
        end)
        callbacks.add(e_callbacks.ANTIAIM, function(fx)
            local lp = entity_list.get_local_player()
            local on_land = bit.band(lp:get_prop('m_fFlags'), bit.lshift(1, 0)) ~= 0
            local curtime = global_vars.cur_time()

            if on_land == true then
                ground_tick = ground_tick + 1
            else
                ground_tick = 0
                end_time = curtime + 1
            end

            if menu.global.ground:get() == 2 then
                fx:set_render_pose(e_poses.RUN, 0)
            end
            if menu.global.ground:get() == 3 then
                --fix after right choke ged
                if jitter then
                    fx:set_render_pose(e_poses.RUN, 1)
                end
            end
            if menu.global.ground:get() == 4 then
                fx:set_render_pose(e_poses.MOVE_YAW, 0)
            end
            if menu.global.ground:get() == 5 then
                fx:set_render_pose(e_poses.MOVE_BLEND_WALK, client.random_int(0, 10) / 10, client.random_int(0, 9) / 10)
                fx:set_render_pose(e_poses.MOVE_BLEND_RUN, client.random_int(0, 10) / 10, client.random_int(0, 9) / 10)
            end

            if menu.global.air:get() == 2 then
                fx:set_render_pose(e_poses.JUMP_FALL, 1)
            end
            if menu.global.air:get() == 3 then
                --fix after right choke ged
                if jitter then
                    fx:set_render_pose(e_poses.JUMP_FALL, 1)
                end
            end
            if menu.global.air:get() == 4 then
                if antiaim.get_state(entity_list.get_local_player()) == 8 or antiaim.get_state(entity_list.get_local_player()) == 7 then
                    fx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 6.0)
                end
            end
            if menu.global.air:get() == 5 then
                fx:set_render_pose(e_poses.JUMP_FALL, client.random_int(0, 10) / 10)
            end
            local x_velocity = entity_list.get_local_player():get_prop('m_vecVelocity[0]')
            if math.abs(x_velocity) >= 3 then
                fx:set_render_animlayer(e_animlayers.LEAN, menu.global.lean:get() / 100)
            end
            if menu.global.pitch:get() then
                if ground_tick > 1 and end_time > curtime then
                    fx:set_render_pose(e_poses.BODY_PITCH, 0.5)
                end
            end
        end)
        antiaim.pitch_spin = 0
        antiaim.get_pitch = function(ctx, int, custom)
            if int == 1 then
                menu.refs.pitch:set(1)
            end
            if int == 2 then
                ctx:set_pitch(89)
            end
            if int == 3 then
                ctx:set_pitch(-89)
            end
            if int == 4 then
                ctx:set_pitch(0)
            end
            if int == 5 then
                ctx:set_pitch(antiaim.inverted and -89 or 89)
            end
            if int == 6 then
                ctx:set_pitch(custom)
            end
            if int == 7 then
                ctx:set_pitch(client.random_int(-89, 89))
            end
            if int == 8 then
                ctx:set_pitch(antiaim.pitch_spin)
            end
        end
        callbacks.add(e_callbacks.ANTIAIM, function(ctx, cmd)
            antiaim.all = 0;
            antiaim.start = menu.defensive[antiaim.get_state(entity_list.get_local_player())].tick_start:get()
            antiaim._end = menu.defensive[antiaim.get_state(entity_list.get_local_player())].tick_end:get()
            local wep = entity_list.get_local_player():get_prop('m_hActiveWeapon')
            local wep2 = entity_list.get_entity(wep)
            if not wep2 then return end
            local weapon = wep2:get_weapon_data().console_name
            if string.find(weapon, 'weapon_knife_') or string.find(weapon, 'bayonet') then
                if antiaim.get_state(entity_list.get_local_player()) == 8 or antiaim.get_state(entity_list.get_local_player()) == 7 then
                    antiaim.safehead = true
                else
                    antiaim.safehead = false
                end
            else
                antiaim.safehead = false
            end
            local state = menu.builder[antiaim.get_state(entity_list.get_local_player())].enable:get() and
                antiaim.get_state(entity_list.get_local_player()) or 1
            if menu.defensive[antiaim.get_state(entity_list.get_local_player())].force:get() == 2 then
                exploits.force_anti_exploit_shift()
            end
            if menu.defensive[antiaim.get_state(entity_list.get_local_player())].force:get() == 3 then
                if cmd.command_number % 8 == 0 then
                    exploits.force_anti_exploit_shift()
                end
            end
            if menu.defensive[antiaim.get_state(entity_list.get_local_player())].fakelag:get() and antiaim.is_defensive then
                ctx:set_fakelag(false)
            end
            local aa = (antiaim.is_defensive and menu.defensive[antiaim.get_state(entity_list.get_local_player())].enable:get()) and
                menu.defensive[antiaim.get_state(entity_list.get_local_player())] or
                menu.builder[state]
            if engine.get_choked_commands() == 0 then
                antiaim.way = antiaim.way + 1
            end
            if antiaim.way > aa.xway:get() then
                antiaim.way = 1
            end
            antiaim.inverted = (cmd.command_number % (aa.slowed:get() * 2)) >= aa.slowed:get()
            if aa.yaw:get() == 1 then
                antiaim.yaw = aa.static:get()
            end
            if aa.yaw:get() == 2 then
                antiaim.yaw = antiaim.inverted and aa.rightyaw:get() or aa.leftyaw:get()
            end
            if aa.yaw:get() == 3 then
                antiaim.inverted = cmd.command_number % aa.yaw_tick_start:get() * 2 >= aa.yaw_tick_end:get()
                antiaim.yaw = antiaim.inverted and aa.rightyaw:get() or aa.leftyaw:get()
            end
            if aa.yaw:get() == 4 then
                if antiaim.way == 1 then
                    antiaim.yaw = aa.way1:get()
                end
                if antiaim.way == 2 then
                    antiaim.yaw = aa.way2:get()
                end
                if antiaim.way == 3 then
                    antiaim.yaw = aa.way3:get()
                end
                if antiaim.way == 4 then
                    antiaim.yaw = aa.way4:get()
                end
                if antiaim.way == 5 then
                    antiaim.yaw = aa.way5:get()
                end
                if antiaim.yaw > 0 then
                    antiaim.inverted = true
                end
                if antiaim.yaw < 0 then
                    antiaim.inverted = false
                end
                if antiaim.yaw == 0 then
                    antiaim.inverted = false
                end
            end
            if aa.jitter:get() ~= 1 then
                if aa.jitter:get() == 3 then
                    antiaim.jitter = (antiaim.inverted and aa.range:get() / 2 or -aa.range:get() / 2) +
                        client.random_int(-aa.randomize:get(), aa.randomize:get())
                end
                if aa.jitter:get() == 2 then
                    antiaim.jitter = (antiaim.inverted and aa.range:get() / 2 or 0) +
                        client.random_int(-aa.randomize:get(), aa.randomize:get())
                end
            else
                antiaim.jitter = 0
            end
            if aa.spin:get() then
                antiaim.spin = aa.spininvert:get() and
                    -animation:spin('spin' .. state, -aa.spinrange:get() / 2, aa.spinrange:get() / 2, 0.01,
                        aa.spinspeed:get() / 10).value or
                    animation:spin('spin' .. state, -aa.spinrange:get() / 2, aa.spinrange:get() / 2, 0.01,
                        aa.spinspeed:get() / 10).value
            else
                antiaim.spin = 0
            end
            if aa.pitch:get() == 8 then
                antiaim.pitch_spin = -animation:spin('pitch spin' .. state, -89, 89, 0.01,
                    aa.pitchspeed:get() / 10).value
            else
                antiaim.pitch_spin = 0
            end
            antiaim.all = antiaim.yaw + antiaim.jitter + antiaim.spin
            antiaim.get_pitch(ctx, aa.pitch:get(), aa.custom:get())
            menu.refs.yaw_base:set(aa.base:get() == 1 and 2 or 3)
            menu.refs.yaw_add:set(antiaim.all)
            menu.refs.desync_side:set(aa.fake:get() ~= 1 and (aa.invert:get() and 3 or 2) or 1)
            menu.refs.desync_left:set(aa.fakel:get())
            menu.refs.desync_right:set(aa.faker:get())
            if aa.fake:get() == 3 then
                ctx:set_invert_desync(antiaim.inverted)
            end
            menu.refs.desync_override_move:set(false)
            menu.refs.desync_override_slowwalk:set(false)
            menu.refs.jitter_mode:set(1)
            menu.refs.jitter_type:set(1)
            menu.refs.rotate:set(false)
            if menu.antiaim.safehead:get() then
                if antiaim.safehead then
                    ctx:set_pitch(89)
                    menu.refs.yaw_base:set(3)
                    menu.refs.yaw_add:set(25)
                    menu.refs.desync_side:set(3)
                    menu.refs.desync_left:set(100)
                    menu.refs.desync_right:set(100)
                    ctx:set_invert_desync(false)
                    menu.refs.desync_override_move:set(false)
                    menu.refs.desync_override_slowwalk:set(false)
                    menu.refs.jitter_mode:set(1)
                    menu.refs.jitter_type:set(1)
                    menu.refs.rotate:set(false)
                    if menu.antiaim.ebait:get() then
                        antiaim.start = 1
                        antiaim._end = 14
                        exploits.force_anti_exploit_shift()
                        if antiaim.is_defensive then
                            ctx:set_pitch(0)
                            menu.refs.yaw_base:set(3)
                            menu.refs.yaw_add:set(180)
                            menu.refs.desync_side:set(2)
                            ctx:set_invert_desync(false)
                            menu.refs.desync_override_move:set(false)
                            menu.refs.desync_override_slowwalk:set(false)
                            menu.refs.jitter_mode:set(1)
                            menu.refs.jitter_type:set(1)
                            menu.refs.rotate:set(false)
                        end
                    end
                end
            end
        end)
    end
    local data = {}
    data.garbage_timer = 0;
    data.garbage = function()
        collectgarbage('collect');
        data.garbage_timer = 0;
    end;
    callbacks.add(e_callbacks.PAINT, function()
        data.garbage_timer = data.garbage_timer + 1;
        if data.garbage_timer > 150 then data.garbage() end
    end)
    callbacks.add(e_callbacks.ANTIAIM, function()
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

    callbacks.add(e_callbacks.AIMBOT_HIT, function(e)
        if not menu.visual.hitlog:get() then return end
        local damage = e.player:get_prop('m_iHealth') > 0 and e.player:get_prop('m_iHealth') or 0
        log.add(
            string.format('hit %s %s%s for %s damage (%s remaining)', e.player:get_name(), hitgroup_names
                [e.hitgroup + 1],
                hitgroup_names[e.hitgroup + 1] ~= hitgroup_names[e.aim_hitgroup + 1] and
                string.format('(%s)', hitgroup_names[e.aim_hitgroup + 1]) or '', e.damage, damage),
            color(255, 255, 255, 200))
    end)
    callbacks.add(e_callbacks.AIMBOT_MISS, function(e)
        if not menu.visual.hitlog:get() then return end
        local damage = e.player:get_prop('m_iHealth') > 0 and e.player:get_prop('m_iHealth') or 0
        log.add(
            string.format('missed %s %s for %s damage due to %s', e.player:get_name(), hitgroup_names
                [e.aim_hitgroup + 1],
                e.aim_damage, e.reason_string), color(255, 98, 98, 200))
    end)
    callbacks.add(e_callbacks.PAINT, function()
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
            if v.alpha < 0.01 then
                table.remove(log.logs, i)
            end
            local w, h = render.get_text_size(render.fonts.verdana, v.text)
            if v.alpha > 0.01 then
                render.text(render.fonts.verdana, tostring(v.text),
                    vector(render.screen.x / 2, render.screen.y / 2 + 115 + offset),
                    color(v.color.r, v.color.g, v.color.b, 255 * v.alpha), true)
            end
            offset = offset + (15 * (v.alpha))
        end
    end)
    callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
        if not menu.global.no_fall_damage:get() then return end
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

    callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
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
    callbacks.add(e_callbacks.PAINT, function()
        local lp = entity_list.get_local_player();
        if not lp then return end
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
    callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
        local ang_vec = function(ang)
            return vector(math.cos(ang.x * math.pi / 180) * math.cos(ang.y * math.pi / 180),
                math.cos(ang.x * math.pi / 180) * math.sin(ang.y * math.pi / 180), -math.sin(ang.x * math.pi / 180))
        end
        if not menu.global.toss:get() then return end
        local lplr = entity_list.get_local_player()
        if not lplr or not lplr:is_player() or not lplr:is_alive() then return end
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

    callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
        if not menu.antiaim.fast_ladder:get() then return end
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
    callbacks.add(e_callbacks.ANTIAIM, function()
        if not menu.global.jump_scout:get() then return end
        local vel = vector(entity_list.get_local_player():get_prop('m_vecVelocity[0]'),
            entity_list.get_local_player():get_prop('m_vecVelocity[1]'),
            entity_list.get_local_player():get_prop('m_vecVelocity[2]')):length2d()
        if vel < 30 then
            stop:set(7, true)
        else
            stop:set(7, false)
        end
    end)

    local killsay = { '♛ Y u k i １ ３ ３ ７ ♛', '1', 'изи by night lua', 'хочешь играть так же? купи night.lua',
        'не можешь убить меня:( купи night.lua', 'ez', 'фу,жирный выблядок', 'аллах бабах чурки', 'изи выблядок',
        'iq?',
        '1 шлюха мать твою ебал', 'классно играешь', 'даже твоя мать с night.lua играет', 'ты старался',
        'бро почему сосал? потому что нет night.lua', 'спасибо за килл' }


    callbacks.add(e_callbacks.EVENT, function(event)
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
    callbacks.add(e_callbacks.PAINT, function()
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
