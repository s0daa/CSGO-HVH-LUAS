local ffi = require('ffi')

local VMT = {
    setup = function(self)
        self.bind = function(vmt_table, func, index)
            local result = ffi.cast(ffi.typeof(func), vmt_table[0][index])
            return function(...)
                return result(vmt_table, ...)
            end
        end
    end
} VMT:setup()

local FFI = {
    ffi.cdef[[
        // Render region
        typedef struct {
            uint8_t r;
            uint8_t g;
            uint8_t b;
            uint8_t a;
        } color_struct_t;


        // end
    ]],
    render = {
        setup = function(self)
            self.interfaces = {
                new_intptr = ffi.typeof('int[1]'),
                charbuffer = ffi.typeof('char[?]'),
                new_widebuffer = ffi.typeof('wchar_t[?]'),
            }

            self.RawLocalize = memory.create_interface('localize.dll', 'Localize_001')
            self.Localize    = ffi.cast(ffi.typeof('void***'), self.RawLocalize)

            self.FindSafe =             VMT.bind(self.Localize, 'wchar_t*(__thiscall*)(void*, const char*)', 12)
            self.ConvertAnsiToUnicode = VMT.bind(self.Localize, 'int(__thiscall*)(void*, const char*, wchar_t*, int)', 15)
            self.ConvertUnicodeToAnsi = VMT.bind(self.Localize, 'int(__thiscall*)(void*, wchar_t*, char*, int)', 16)

            -- GUI Surface
            self.VGUI_Surface031 = memory.create_interface('vguimatsurface.dll', 'VGUI_Surface031')
            self.g_VGuiSurface = ffi.cast(ffi.typeof('void***'), self.VGUI_Surface031)

            self.native_Surface = {}
            self.native_Surface.FontCreate =           VMT.bind(self.g_VGuiSurface, 'unsigned long(__thiscall*)(void*)', 71)
            self.native_Surface.SetFontGlyphSet =      VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, unsigned long, const char*, int, int, int, int, unsigned long, int, int)', 72)
            self.native_Surface.GetTextSize =          VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, unsigned long, const wchar_t*, int&, int&)', 79)
            self.native_Surface.DrawSetTextColor =     VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int, int, int, int)', 25)
            self.native_Surface.DrawSetTextFont =      VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, unsigned long)', 23)
            self.native_Surface.DrawSetTextPos =       VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int, int)', 26)
            self.native_Surface.DrawPrintText =        VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, const wchar_t*, int, int)', 28)

            self.EFontFlags = ffi.typeof([[
                enum {
                    NONE,
                    ITALIC		 = 0x001,
                    UNDERLINE	 = 0x002,
                    STRIKEOUT	 = 0x004,
                    SYMBOL		 = 0x008,
                    ANTIALIAS	 = 0x010,
                    GAUSSIANBLUR = 0x020,
                    ROTARY		 = 0x040,
                    DROPSHADOW	 = 0x080,
                    ADDITIVE	 = 0x100,
                    OUTLINE		 = 0x200,
                    CUSTOM		 = 0x400,
                }
            ]])

            self.PrintText = function(text, localized)
                local size = 1024.0
                if localized then
                    local char_buffer = self.interfaces.charbuffer(size)
                    self.ConvertUnicodeToAnsi(text, char_buffer, size)

                    return self.native_Surface.DrawPrintText(text, #ffi.string(char_buffer), 0)
                else
                    local wide_buffer = self.interfaces.new_widebuffer(size)

                    self.ConvertAnsiToUnicode(text, wide_buffer, size)
                    return self.native_Surface.DrawPrintText(wide_buffer, #text, 0)
                end
            end

            self.font_cache = {}
        end
    },
    setup = function(self)
        self.render:setup()
    end
} FFI:setup()

local c_render = {}
local color = {}
local assistant = {
    global = function()
        math.clamp = function(num, min, max)
            return math.min(math.max(num, min), max)
        end
        math.round = function(value, decimals)
            local multiplier = 10 ^ (decimals or 0)
            return math.floor(value * multiplier + 0.5) / multiplier
        end
        math.lerp = function(start, _end, time, do_extraanim)
            if (not do_extraanim and math.floor(start) == _end) then
                return
                _end
            end
            time = globals.frame_time() * (time * 175)
            if time < 0 then
                time = 0.01
            elseif time > 1 then
                time = 1
            end
            return (_end - start) * time + start
        end
        color.new = function(r, g, b, a)
            return color_t(math.round(r), math.round(g), math.round(b), math.round(a or 255))
        end
    end,
    render = function()
        c_render.create_font = function(name, size, flags, glow, weight)
            local flags_t = {}
            for _, Flag in pairs(flags or {'NONE'}) do
                table.insert(flags_t, FFI.render.EFontFlags(Flag))
            end

            local flags_i = 0
            local t = type(flags_t)
            if t == 'number' then
                flags_i = flags_t
            elseif t == 'table' then
                for i = 1, #flags_t do
                    flags_i = flags_i + flags_t[i]
                end
            else
                flags_i = 0x0
            end

            -- local cache_key = string.format('%s\0%d\0%d\0%d', name, size, weight or 0, flags_i)
            local cache_key = string.format('%s\0%d\0%d\0%d', name, size, weight or 0, glow or 0)
            if FFI.render.font_cache[cache_key] == nil then
                FFI.render.font_cache[cache_key] = FFI.render.native_Surface.FontCreate()
                FFI.render.native_Surface.SetFontGlyphSet(FFI.render.font_cache[cache_key], name, size, weight or 0, glow or 0, 0, flags_i, 0, 0)
            end

            return FFI.render.font_cache[cache_key]
        end
        c_render.get_text_size = function(font, text)
            local wide_buffer = FFI.render.interfaces.new_widebuffer(1024)
            local w_ptr = FFI.render.interfaces.new_intptr()
            local h_ptr = FFI.render.interfaces.new_intptr()

            FFI.render.ConvertAnsiToUnicode(text, wide_buffer, 1024)
            FFI.render.native_Surface.GetTextSize(font, wide_buffer, w_ptr, h_ptr)

            return vec2_t(tonumber(w_ptr[0]), tonumber(h_ptr[0]))
        end
        c_render.draw_text = function(font, x, y, clr, text, center)
            local x, y = x, y
            if center then
                local text_size = render.get_text_size(font, text)
                if center[1] then
                    x = x - text_size.x / 2
                end
                if center[2] then
                    y = y - text_size.y / 2
                end
            end
            FFI.render.native_Surface.DrawSetTextPos(x, y)
            FFI.render.native_Surface.DrawSetTextFont(font)
            FFI.render.native_Surface.DrawSetTextColor(clr.r, clr.g, clr.b, clr.a)
            return FFI.render.PrintText(text, false)
        end
        c_render.draw_multi_text = function(font, x, y, text_t, alpha, center)
            local centered = { x = 0, y = 0 }
            if center then
                for _, Table in pairs(text_t) do
                    local text_size = c_render.get_text_size(font, Table[1])
                    if center[1] then
                        centered.x = centered.x + text_size.x
                    end
                    if center[2] then
                        centered.y = text_size.y
                    end
                end
            end
            for _, Table in pairs(text_t) do
                Table[2] = Table[2] or color.new(255, 255, 255, alpha)
                c_render.draw_text(font, x - centered.x / 2, y - centered.y / 2, color.new(Table[2].r, Table[2].g, Table[2].b, alpha), Table[1])
                x = x + c_render.get_text_size(font, Table[1]).x
            end
        end
    end,
    setup = function(self)
        self:global()
        self:render()

    end
} assistant:setup()

local logs = {
    data = {},
    font = {
        def = c_render.create_font('Verdana', 12, {'DROPSHADOW'}),
        glow = c_render.create_font('Verdana', 12, {'NONE'}, 2)
    },
    screen = render.get_screen_size(),
    hitboxes = {
        [1] = 'head',
        [2] = 'chest',
        [3] = 'stomach',
        [5] = 'arm',
        [6] = 'leg',
        [7] = 'feet',
    },
    input = function(self, data, duration)
        duration = duration or 4
        table.insert(self.data, {
            text = data.text,
            stamp = globals.cur_time() + duration,
            speed = data.speed or 0.05,
            anim = 0
        })
    end,
    setup = function(self)
        callbacks.add(e_callbacks.PAINT, function()
            if not entity_list.get_local_player():is_valid() then
                return
            end

            local y_offset = 0
            for i, v in pairs(self.data) do
                v.anim = math.lerp(v.anim, globals.cur_time() < v.stamp and 1 or 0, v.speed, true)
                if v.anim < 0.01 then
                    table.remove(self.data, i)
                    goto next
                end

                local pos = {
                    x = self.screen.x / 2,
                    y = (self.screen.y / 2 + 80),
                }

                c_render.draw_multi_text(self.font.glow, pos.x, math.round(pos.y + y_offset * v.anim), v.text, 80 * v.anim, {true})
                c_render.draw_multi_text(self.font.def, pos.x, math.round(pos.y + y_offset * v.anim), v.text, 255 * v.anim, {true})

                y_offset = (y_offset + 15) * v.anim
                ::next::
            end
        end)
        callbacks.add(e_callbacks.AIMBOT_HIT, function(log)
            local name = log.player:get_name()
            local hitbox = tostring(self.hitboxes[log.hitgroup])
            local damage = tostring(log.aim_damage)
            self:input({
                text = {
                    {'Hit '},
                    {name, color.new(0, 150, 255)},
                    {' in '},
                    {hitbox, color.new(0, 150, 255)},
                    {' for '},
                    {damage, color.new(0, 150, 255)},
                    {' hp'},
                }
            })
            client.log(color.new(0, 150, 255), '>>', color.new(255, 255, 255), 'Hit', color.new(0, 150, 255), name, color.new(255, 255, 255), 'in', color.new(0, 150, 255), hitbox, color.new(255, 255, 255), 'for', damage, color.new(255, 255, 255), 'hp')
        end)
        callbacks.add(e_callbacks.AIMBOT_MISS, function(log)
            local reason = tostring(log.reason_string)
            self:input({
                text = {
                    {'Missed shot due to '},
                    {reason, color.new(255, 100, 100)}
                }
            })
            client.log(color.new(255, 100, 100), '>>', color.new(255, 255, 255), 'Missed shot due to', color.new(255, 100, 100), reason)
        end)
    end,
} logs:setup()