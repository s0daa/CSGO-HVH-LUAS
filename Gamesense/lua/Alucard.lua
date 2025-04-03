local obex_data = {username = 'scriptleaks', build = 'User'}
local a = require "gamesense/antiaim_funcs"
local function b(c)
    if type(c) ~= "table" then
        return c
    end
    local d = {}
    for e, f in pairs(c) do
        d[b(e)] = b(f)
    end
    return d
end
local table, math, string = b(table), b(math), b(string)
local render, client = b(render), b(client)
math.clamp = function(g, h, j)
    return math.min(j, math.max(g, h))
end
math.lerp = function(g, k, l)
    return g + (k - g) * l
end
math.anim_lerp = function(g, k, m)
    local n = g + (k - g) * globals.frametime() * (m or 8)
    return math.abs(k - n) < 0.001 and k or n
end
math.in_bounds = function(o, p, q, r, s, t)
    return o >= q and p >= r and (o <= s and p <= t)
end
local u = {ease_out = function(v)
        return 1 - (1 - v) ^ 3
    end, ease_in = function(v)
        return v * v * v
    end, linear = function(w, x, m)
        return math.clamp(w + globals.frametime() * (m or 8) * (x and 1 or -1), 0, 1)
    end}
local y = function(z, g, k)
    if z then
        return g
    else
        return k
    end
end
local A = function(B)
    return math.floor(B / globals.tickinterval() + 0.5)
end
local C, D = client.screen_size()
renderer.rounded_rectangle = function(v, E, l, F, G, H, k, g, I)
    E = E + I
    local J = {{v + I, E, 180}, {v + l - I, E, 90}, {v + I, E + F - I * 2, 270}, {v + l - I, E + F - I * 2, 0}}
    local K = {
        {v + I, E, l - I * 2, F - I * 2},
        {v + I, E - I, l - I * 2, I},
        {v + I, E + F - I * 2, l - I * 2, I},
        {v, E, I, F - I * 2},
        {v + l - I, E, I, F - I * 2}
    }
    for L, K in next, J do
        renderer.circle(K[1], K[2], G, H, k, g, I, K[3], 0.25)
    end
    for L, K in next, K do
        renderer.rectangle(K[1], K[2], K[3], K[4], G, H, k, g)
    end
end
renderer.outlined_rounded_rectangle = function(v, E, l, F, G, H, k, g, I, M)
    E = E + I
    local J = {{v + I, E, 180}, {v + l - I, E, 270}, {v + I, E + F - I * 2, 90}, {v + l - I, E + F - I * 2, 0}}
    local K = {
        {v + I, E - I, l - I * 2, M},
        {v + I, E + F - I - M, l - I * 2, M},
        {v, E, M, F - I * 2},
        {v + l - M, E, M, F - I * 2}
    }
    for L, K in next, J do
        renderer.circle_outline(K[1], K[2], G, H, k, g, I, K[3], 0.25, M)
    end
    for L, K in next, K do
        renderer.rectangle(K[1], K[2], K[3], K[4], G, H, k, g)
    end
end
local N = {
    top_l = renderer.load_png(
        "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x06\x00\x00\x00\x04\x08\x06\x00\x00\x00\xAD\x04\x4E\x43\x00\x00\x00\x04\x73\x42\x49\x54\x08\x08\x08\x08\x7C\x08\x64\x88\x00\x00\x00\x42\x49\x44\x41\x54\x08\x5B\x63\x64\x00\x82\xFF\xFF\xFF\x2B\x00\xA9\x7E\x20\x56\x04\xE2\x06\x20\x3E\xC0\x08\x15\x3C\x0F\xE4\x7C\x04\x62\x03\x46\x46\xC6\x0F\x20\xC5\x20\x89\x0D\x40\xDA\x1F\x88\x03\x81\x82\x20\x36\x18\x80\x24\x40\x2A\xF8\x81\x58\x10\xA6\x1A\x24\x01\x00\x99\x78\x15\x12\x93\xA7\xD2\x03\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82",
        6,
        4
    ),
    bottom_l = renderer.load_png(
        "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x06\x00\x00\x00\x04\x08\x06\x00\x00\x00\xAD\x04\x4E\x43\x00\x00\x00\x04\x73\x42\x49\x54\x08\x08\x08\x08\x7C\x08\x64\x88\x00\x00\x00\x43\x49\x44\x41\x54\x08\x5B\x63\xFC\xFF\xFF\xFF\x07\x06\x06\x06\x7E\x20\x16\x64\x64\x64\x04\xB1\xC1\x80\x11\x28\xB1\x01\x48\xFB\x03\x71\x20\x50\x02\xC4\x86\x4B\x28\x00\x59\x17\x80\xF8\x3D\x10\x1B\xC2\x74\x31\x82\xA4\x81\xBA\x40\x92\x13\x80\x58\x00\x88\xFB\x81\xF8\x20\x00\x7C\x69\x15\x12\xF6\xFB\x63\xCC\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82",
        6,
        4
    ),
    top_r = renderer.load_png(
        "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x06\x00\x00\x00\x04\x08\x06\x00\x00\x00\xAD\x04\x4E\x43\x00\x00\x00\x04\x73\x42\x49\x54\x08\x08\x08\x08\x7C\x08\x64\x88\x00\x00\x00\x3B\x49\x44\x41\x54\x08\x5B\x63\xFC\xFF\xFF\xBF\x02\x03\x03\x83\x03\x10\x17\x00\xF1\x79\x20\x2E\x64\x64\x64\xFC\xC0\x08\x64\x80\x01\x54\xC1\x05\x20\xF3\x3E\x10\x3B\xC2\x25\xA0\x92\x0D\x40\xBA\x1E\x88\x1B\xD1\x25\x40\x46\xEE\x07\xE2\x83\x00\x16\x6E\x14\x4C\xF7\xA9\xE8\x60\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82",
        6,
        4
    ),
    bottom_r = renderer.load_png(
        "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x06\x00\x00\x00\x04\x08\x06\x00\x00\x00\xAD\x04\x4E\x43\x00\x00\x00\x04\x73\x42\x49\x54\x08\x08\x08\x08\x7C\x08\x64\x88\x00\x00\x00\x3B\x49\x44\x41\x54\x08\x5B\x63\x64\x40\x02\xFF\xFF\xFF\x77\x00\x72\xF7\x03\xF1\x41\x46\x34\x89\x06\x20\xBF\x1E\x88\x1B\xE1\x12\x40\xD5\x06\x50\xD5\x0F\x81\xB4\x03\x23\x50\x40\x01\xC8\xB0\x07\xE2\x42\x20\x3E\x00\xC4\x0D\x8C\x8C\x8C\x1F\x00\xA9\xAE\x14\x4C\xAD\x34\x16\xC8\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82",
        6,
        4
    ),
    star = renderer.load_svg(
        '<svg width="13" height="12" viewBox="0 0 13 12"><g data-name="Polygon 1" fill="none"><path d="M6.5,0,8.125,4.463,13,4.584,9.129,7.463,10.517,12,6.5,9.317,2.483,12,3.871,7.463,0,4.584l4.875-.121Z"/><path d="M 6.5 2.922625541687012 L 5.581369876861572 5.445400238037109 L 2.922904968261719 5.511365413665771 L 5.033160209655762 7.080979824066162 L 4.259331703186035 9.610799789428711 L 6.5 8.114160537719727 L 8.74066162109375 9.610794067382812 L 7.966819763183594 7.080979824066162 L 10.07708930969238 5.511365413665771 L 7.418630123138428 5.445400238037109 L 6.5 2.922625541687012 M 6.5 0 L 8.125 4.462619781494141 L 13 4.583590030670166 L 9.129300117492676 7.462619781494141 L 10.51721954345703 12 L 6.5 9.316712808850098 L 2.482780456542969 12 L 3.87069034576416 7.462619781494141 L 0 4.583590030670166 L 4.875 4.462619781494141 L 6.5 0 Z" fill="#fff"/></g></svg>',
        13,
        12
    ),
    logo = renderer.load_png(
        "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x28\x00\x00\x00\x0C\x08\x06\x00\x00\x00\x10\xC3\xFF\x4D\x00\x00\x00\x04\x73\x42\x49\x54\x08\x08\x08\x08\x7C\x08\x64\x88\x00\x00\x01\x48\x49\x44\x41\x54\x38\x4F\xD5\x54\xC1\x6D\xC2\x40\x10\xF4\x95\x40\x42\x03\xB6\x88\x22\x51\x41\xF8\xF3\x8D\x79\xF2\xCC\xC7\x0F\x52\x41\x28\x81\x54\x80\xDB\x00\x8A\x20\x3D\x24\xB2\x29\x20\x4A\x4A\x30\x33\xAB\x5D\x73\x3E\xD9\x42\x7C\xC0\x20\x9D\x38\xDD\x8D\x77\x67\x67\xC6\x76\x51\xCF\x7F\xAE\xE7\xFC\xA2\x4E\x82\x65\x59\xFE\x81\xFC\x00\x6B\x19\xC7\xF1\xE7\xB5\x06\x41\xDF\x4A\x7B\x49\xDF\x4E\x82\x45\x51\xBC\x3A\xE7\xB6\x37\x20\xF8\x81\x9E\x2B\xEB\xDB\x7F\x82\x90\x74\x03\xB6\xA9\x67\x61\x0E\x69\xDF\x7D\x05\xF5\x8E\x53\xFD\x63\xD1\x6E\xD9\x03\xF7\xC0\x3B\xD4\x58\xE3\x6F\xA1\x38\x39\xF7\xAC\xE2\xB1\x9C\x79\x35\x79\x96\x63\xCD\xAD\x06\xEE\xBE\xE1\xD8\xC8\xE3\x71\xB2\x98\x24\x01\x9C\x11\x44\x40\x92\x24\x4F\xA1\xC5\xC0\xEC\xAB\xAA\x1A\xF2\x8E\x7B\xC0\x9E\x95\x88\x59\xC2\x86\x07\x60\x32\xC5\x48\x4D\x60\x1B\x96\x05\xC3\x44\xC0\xA7\x20\x96\x51\x24\xDD\x8F\x1B\x16\x07\x53\x91\xDF\x17\x0A\x4F\x2E\x20\x68\xEA\x35\x5E\x26\x1D\xE2\xC5\x14\x61\x73\x10\xDF\x19\x41\xF4\xA8\xE3\x65\x58\x9E\x85\x03\xB9\x40\x35\xCA\xFC\xDB\x46\x50\x2D\x78\x54\xAB\x88\x93\xBD\x57\x70\x4B\xC5\xD4\xF2\x5A\x35\x8B\xC7\x19\x82\x12\xB3\x56\x05\x5B\x32\x28\xF9\x00\x78\x6A\x99\xD0\xC9\xEA\x9C\xE1\xEE\x47\xEF\x84\x54\x50\xA3\x2D\x83\x92\x43\x3C\xF7\xA6\x5F\x86\x3A\x97\xA6\xB0\x97\x59\xE6\x9C\x9F\x37\xA9\x73\xBF\x1F\x6A\xEF\x6D\xBA\xE9\xF6\x08\xDC\xDD\xFC\x0D\x72\x3F\xB7\xAC\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82",
        40,
        12
    ),
    beta = renderer.load_png(
        "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x06\x00\x00\x00\x0D\x08\x03\x00\x00\x00\xBD\xD5\xEF\xB9\x00\x00\x00\x09\x50\x4C\x54\x45\x00\x00\x00\xFF\xFF\xFF\xFF\xFF\xFF\x73\x78\xA5\x63\x00\x00\x00\x03\x74\x52\x4E\x53\xFF\xFF\x00\xD7\xCA\x0D\x41\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0B\x13\x00\x00\x0B\x13\x01\x00\x9A\x9C\x18\x00\x00\x00\x2E\x49\x44\x41\x54\x08\x99\x4D\xCB\x31\x0A\xC0\x30\x10\xC4\xC0\xD1\xE1\xFF\x7F\xF9\x52\x18\x82\xAB\x45\x12\xDB\x80\x63\xC9\x6C\xE1\x3A\xC3\xDE\xC9\x1A\xF4\xB7\x42\x8E\x3C\x87\x3C\xF4\x01\x14\x1A\x04\x24\x00\x02\x2A\x49\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82",
        6,
        13
    ),
    avatar = nil
}
local O = 0
local P = {
    back = {{r = 19, g = 20, b = 23}, {r = 0x08, g = 0x09, b = 0x0A}},
    accent = {r = 0x6E, g = 0x30, b = 0x30, a = 0}
}
local Q = {
    dt = {ui.reference("RAGE", "Aimbot", "Double tap")},
    os = {ui.reference("AA", "Other", "On shot anti-aim")},
    fs = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")}
}
local R = {
    ui.new_label("LUA", "A", "\aFF0000FFalucard \aCDCDCDFF| ui"),
    color = ui.new_color_picker("LUA", "A", "alucard | ui", 0x6E, 0x30, 0x30, 0)
}
ui.set_callback(
    R.color,
    function()
        local G, H, k, g = ui.get(R.color)
        P.accent = {r = G, g = H, b = k, a = g}
    end
)
local S = {}
S.logo = function(v, E, g, w)
    g = g or 1
    renderer.texture(N.star, v, E + 1, 13, 12, P.accent.r, P.accent.g, P.accent.b, 200 * g)
    if w then
        renderer.texture(N.logo, v + 2, E + 3, 40, 12, 0, 0, 0, 255 * g)
    end
    renderer.texture(N.logo, v + 2, E + 2, 40, 12, 240, 240, 240, 255 * g)
end
S.line_l = function(v, E, T, g)
    g, i = g or 1, i and 1 or 1
    renderer.texture(N.top_l, v, E, 6, 4, P.accent.r, P.accent.g, P.accent.b, math.lerp(255, P.accent.a, O) * g)
    renderer.gradient(
        v,
        E + 4,
        2,
        T - 8,
        P.accent.r,
        P.accent.g,
        P.accent.b,
        math.lerp(255, P.accent.a, O) * g,
        P.accent.r,
        P.accent.g,
        P.accent.b,
        math.lerp(P.accent.a, 255, O) * g,
        false
    )
    renderer.texture(
        N.bottom_l,
        v,
        E + T - 4,
        6,
        4,
        P.accent.r,
        P.accent.g,
        P.accent.b,
        math.lerp(P.accent.a, 255, O) * g
    )
end
S.line_r = function(v, E, T, g)
    g, i = g or 1, i and 1 or 1
    renderer.texture(N.top_r, v - 6, E, 6, 4, P.accent.r, P.accent.g, P.accent.b, math.lerp(P.accent.a, 255, O) * g)
    renderer.gradient(
        v - 2,
        E + 4,
        2,
        T - 8,
        P.accent.r,
        P.accent.g,
        P.accent.b,
        math.lerp(P.accent.a, 255, O) * g,
        P.accent.r,
        P.accent.g,
        P.accent.b,
        math.lerp(255, P.accent.a, O) * g,
        false
    )
    renderer.texture(
        N.bottom_r,
        v - 6,
        E + T - 4,
        6,
        4,
        P.accent.r,
        P.accent.g,
        P.accent.b,
        math.lerp(255, P.accent.a, O) * g
    )
end
S.container = function(v, E, l, F, g)
    g = g or 1
    renderer.rounded_rectangle(v - 1, E - 1, l + 2, F + 2, 0, 0, 0, 255 * g, 5)
    renderer.gradient(
        v,
        E,
        l,
        F,
        P.back[1].r,
        P.back[1].g,
        P.back[1].b,
        255 * g,
        P.back[2].r,
        P.back[2].g,
        P.back[2].b,
        255 * g,
        false
    )
    renderer.outlined_rounded_rectangle(v, E, l, F, 255, 255, 255, 16 * g, 4, 1)
    S.line_l(v, E, F, g)
    S.line_r(v + l, E, F, g)
end
S.progress_container = function(v, E, l, F, U, g)
    g = g or 1
    renderer.rounded_rectangle(v - 1, E - 1, l + 2, F + 2, 0, 0, 0, 255 * g, 5)
    renderer.gradient(
        v,
        E,
        l,
        F,
        P.back[1].r,
        P.back[1].g,
        P.back[1].b,
        255 * g,
        P.back[2].r,
        P.back[2].g,
        P.back[2].b,
        255 * g,
        false
    )
    renderer.outlined_rounded_rectangle(v, E, l, F, 255, 255, 255, 16 * g, 4, 1)
    renderer.gradient(
        v + 2,
        E + F - 1,
        math.max(l * (U or 1) - 2, 0),
        1,
        P.accent.r,
        P.accent.g,
        P.accent.b,
        P.accent.a * g,
        P.accent.r,
        P.accent.g,
        P.accent.b,
        255 * g,
        true
    )
end
local V = {}
do
    local W = {}
    local X = {lock = false, lmb = false, rmb = false, pos = {ui.mouse_position()}}
    local Y = function(self, l, F)
        local j, Z = X.pos[1], X.pos[2]
        self.is.hovered = math.in_bounds(j, Z, self.x, self.y, self.x + l, self.y + F) and ui.is_menu_open()
        W[self.id] = self.is.hovered
        if self.is.hovered and X.lmb then
            if not self.is.held then
                self.drag_x, self.drag_y = self.x - j, self.y - Z
            end
            self.is.held = true
        end
        if not X.lmb then
            self.is.held = false
        end
        if self.is.held then
            self.x, self.y = self.drag_x + j, self.drag_y + Z
            ui.set(self.config.x, math.max(self.x, 0))
            ui.set(self.config.y, math.max(self.y, 0))
        end
    end
    local _ = {draw = function(self)
            Y(self, self.object(self.x, self.y))
        end}
    _.__index = _
    V.new = function(a0, a1, v, E)
        local self = {
            id = a0,
            x = v or 0,
            y = v or 0,
            w = 0,
            h = 0,
            object = a1,
            drag_x = v or 0,
            drag_y = E or 0,
            is = {hovered = false, held = false}
        }
        W[a0] = false
        self.config = {
            x = ui.new_slider("MISC", "Settings", a0 .. "_x", 0, C, self.x, false, 1, 1),
            y = ui.new_slider("MISC", "Settings", a0 .. "_y", 0, D, self.x, false, 1, 1)
        }
        return setmetatable(self, _)
    end
    client.set_event_callback(
        "post_render",
        function()
            X.lmb = client.key_state(0x01)
            X.pos = {ui.mouse_position()}
        end
    )
    client.set_event_callback(
        "setup_command",
        function(a2)
            for e, f in pairs(W) do
                if f then
                    a2.in_attack = 0
                    break
                end
            end
        end
    )
end
local a3 = {}
a3.watermark = {length = 0, is_beta = true, items = {function(self, v, E)
            S.logo(v + 8, E + 3)
            if self.is_beta then
                renderer.texture(N.beta, v + 52, E + 5, 6, 13, P.accent.r, P.accent.g, P.accent.b, 255)
            end
            return 56 + (self.is_beta and 8 or 0)
        end, function(self, v, E)
            renderer.line(v, E + 6, v, E + 16, 255, 255, 255, 16)
            return 8
        end, function(self, v, E)
            local a4 = obex_data.username
            renderer.text(v + 20, E + 4, 222, 222, 222, 255, nil, 0, a4)
            return 32 + renderer.measure_text(nil, a4)
        end, function(self, v, E)
            local B = {client.system_time()}
            local a4 = ("%02d:%02d \aDEDEDE40"):format(B[1], B[2])
            renderer.text(v, E + 4, 222, 222, 222, 255, nil, 0, a4)
            return renderer.measure_text(nil, a4)
        end}, enumerate = function(self)
        local a5 = 0
        for i = 1, #self.items do
            local a6 = self.items[i](self, C - self.length + a5 - 16, 16) or 0
            a5 = a5 + a6
        end
        self.length = math.clamp(math.anim_lerp(self.length, a5 + 8), 0, math.huge)
    end, render = function(self)
        S.container(C - self.length - 16, 16, self.length, 22, 1)
        self:enumerate()
    end}
a3.logger = {list = {}, draw = function(self, a7, E, a8)
        local a9 = renderer.measure_text(nil, a7.text) + 64
        local aa = {x = C * 0.5 - a9 * 0.5, y = D * 0.5 + E, w = a9, h = 22}
        local ab = math.clamp((4 - (globals.realtime() - a7.time)) / 4, 0, 1)
        S.progress_container(aa.x, aa.y, aa.w, aa.h, ab, a8)
        S.logo(aa.x + 6, aa.y + 3, a8)
        renderer.line(aa.x + 52, aa.y + 6, aa.x + 52, aa.y + 16, 255, 255, 255, 16 * a8)
        renderer.text(aa.x + 58, aa.y + 4, 222, 222, 222, 255 * a8, nil, "", a7.text)
    end, render = function(self)
        local E, next = 100, nil
        for i = 1, #self.list do
            local f = self.list[i]
            local ac = globals.realtime() - f.time < 4
            f.progress = u.linear(f.progress, ac, 3)
            local a8 = u[ac and "ease_out" or "ease_in"](f.progress)
            if a8 == 0 then
                next = i
            end
            self:draw(f, E, a8)
            E = E + 28 * (ac and a8 or 1)
        end
        if next then
            table.remove(self.list, next)
        end
    end}
a3.panel = {pos = {x = 190, y = 700}, height = 100, items = {function(self, v, E)
            renderer.text(v + 8, E, 222, 222, 222, 64, nil, "", "user")
            renderer.circle(v + 16, E + 22, 180, 180, 180, 255, 7, 0, 1)
            renderer.text(v + 28, E + 16, 222, 222, 222, 255, nil, "", obex_data.username)
            return 36
        end, function(self, v, E)
            renderer.text(v + 8, E, 222, 222, 222, 64, nil, "", "version")
            renderer.text(v + 8, E + 16, 222, 222, 222, 255, nil, "", "1.0 » Alucard")
            return 36
        end, function(self, v, E)
            renderer.text(v + 8, E, 222, 222, 222, 64, nil, "", "anti-aim state")
            renderer.text(v + 8, E + 16, 222, 222, 222, 255, nil, "", "Standing")
            return 36
        end}, enumerate = function(self)
        local a5 = 0
        for i = 1, #self.items do
            local ad = self.items[i](self, self.pos.x, self.pos.y + a5 + 24) or 0
            a5 = a5 + ad
        end
        self.height = math.clamp(math.anim_lerp(self.height, a5 + 8), 0, math.huge)
    end, render = function(self, v, E)
        self.pos.x, self.pos.y = v, E
        S.container(self.pos.x, self.pos.y, 96, self.height + 16, 1)
        S.logo(self.pos.x + 8, self.pos.y + 4, 1)
        self:enumerate()
        return 96, self.height
    end}
a3.crosshair = {
    x = C * 0.5,
    y = D * 0.5,
    height = 0,
    off_x = 0,
    off_y = 24,
    items = {
        {[0] = 0, draw = function(self, v, E)
                S.logo(v - 20, E, 1, true)
                return 40, 20
            end},
        {
            [0] = 0,
            check = function(self)
                return ui.get(Q.dt[2]) and ui.get(Q.dt[1])
            end,
            draw = function(self, v, E)
                renderer.rectangle(v - 7, E - 1, 16, 4, 0, 0, 0, 255 * self[0])
                renderer.gradient(
                    v - 6,
                    E - 0,
                    math.clamp(a.get_tickbase_shifting() / 12 * 16, 0, 14),
                    2,
                    P.accent.r,
                    P.accent.g,
                    P.accent.b,
                    255 * self[0],
                    P.accent.r,
                    P.accent.g,
                    P.accent.b,
                    128 * self[0],
                    false
                )
                renderer.text(v - 1, E, 222, 222, 222, 255 * self[0], "-c", nil, "DT")
                return 16, 10
            end
        },
        {[0] = 0, [1] = 0, check = function(self)
                self[1] = u.linear(self[1], not (ui.get(Q.dt[2]) and ui.get(Q.dt[1])), 8)
                return ui.get(Q.os[2])
            end, draw = function(self, v, E)
                renderer.text(v - 1, E, 222, 222, 222, 255 * self[0] * math.clamp(self[1], 0.5, 1), "-c", nil, "OSAA")
                return 16, 10
            end},
        {[0] = 0, check = function(self)
                return ui.get(Q.fs[2]) and ui.get(Q.fs[1])
            end, draw = function(self, v, E)
                renderer.text(v - 1, E, 222, 222, 222, 255 * self[0], "-c", nil, "FS")
                return 16, 10
            end}
    },
    enumerate = function(self)
        local ae, af = 0, 0
        for i, f in ipairs(self.items) do
            f[0] = f.check and u.linear(f[0], f:check(), 8) or 1
            local l, F = f:draw(self.x, self.y + af)
            ae, af = ae + l, af + F * f[0]
        end
        self.height = af
    end,
    render = function(self)
        local ag = entity.get_local_player()
        if not ag or not entity.is_alive(ag) then
            return
        end
        local ah = entity.get_prop(ag, "m_bIsScoped")
        self.off_x = u.linear(self.off_x, ah == 1, 3)
        self.x = C * 0.5 + u[ah == 1 and "ease_out" or "ease_in"](self.off_x) * 32
        self.y = D * 0.5 + self.off_y
        self:enumerate()
    end
}
local ai =
    V.new(
    "panel",
    function(v, E)
        return a3.panel:render(v, E)
    end
)
client.set_event_callback(
    "paint_ui",
    function()
        O = 0.5 * (1 + math.sin(0.75 * 3.14 * globals.realtime()))
        a3.watermark:render()
        a3.logger:render()
        ai:draw()
        if globals.mapname() then
            a3.crosshair:render()
        end
    end
)
local aj = {
    [0] = "generic",
    "head",
    "chest",
    "stomach",
    "left arm",
    "right arm",
    "left leg",
    "right leg",
    "neck",
    "generic",
    "gear"
}
client.set_event_callback(
    "aim_miss",
    function(ak)
        local a7 = {text = nil, progress = 0, time = globals.realtime()}
        local al = entity.get_player_name(ak.target)
        local am = aj[ak.hitgroup] or "?"
        a7.text = ("missed %s's %s due to %s"):format(al, am, ak.reason)
        table.insert(a3.logger.list, 1, a7)
    end
)
client.set_event_callback(
    "aim_hit",
    function(ak)
        local a7 = {text = nil, progress = 0, time = globals.realtime()}
        local al = entity.get_player_name(ak.target)
        local am = aj[ak.hitgroup] or "?"
        a7.text = ("hit %s's %s for %d"):format(al, am, ak.damage)
        table.insert(a3.logger.list, 1, a7)
    end
)
local an = function(a, b, c)
    return {ui.reference(a, b, c)}
end
local ao = {
    toggle = an("aa", "anti-aimbot angles", "enabled"),
    yaw = an("aa", "anti-aimbot angles", "yaw"),
    pitch = an("aa", "anti-aimbot angles", "pitch"),
    base = an("aa", "anti-aimbot angles", "yaw base"),
    jitter = an("aa", "anti-aimbot angles", "yaw jitter"),
    body = an("aa", "anti-aimbot angles", "body yaw"),
    fsbody = an("aa", "anti-aimbot angles", "freestanding body yaw"),
    fsyaw = an("aa", "anti-aimbot angles", "freestanding"),
    edge = an("aa", "anti-aimbot angles", "edge yaw"),
    roll = an("aa", "anti-aimbot angles", "roll")
}
local ap, aq, ar, as = 0, 0, 0, 0
local at, au = false, false
client.set_event_callback(
    "run_command",
    function(av)
        ap = av.command_number
    end
)
client.set_event_callback(
    "predict_command",
    function(av)
        if av.command_number == ap then
            local aw = entity.get_prop(entity.get_local_player(), "m_nTickBase")
            ar = math.abs(aw - aq)
            aq = math.max(aw, aq or 0)
            ap = 0
        end
    end
)
advfunc = function(av, ax, ay, az)
    at = as ~= 1 or ar ~= 1
    as = ar
    local aA = ar > 2 and ar < 14
    local aw = entity.get_prop(entity.get_local_player(), "m_nTickBase")
    if aw % (au and 6 or 7) == 0 then
        au = not au
        ui.set(ao.body[1], "off")
        ui.set(ao.yaw[2], az * 2)
    else
        if not aA then
            ui.set(ao.body[1], at and "jitter" or "static")
            ui.set(ao.yaw[2], at and -ay or -(ay / 2))
        end
    end
    av.force_defensive = at and aw % 3 ~= 1
    ui.set(ao.body[2], at and 0 or (au and -169 or 169))
    ui.set(ao.jitter[1], "off")
    ui.set(ao.base[1], "local view")
    ui.set(ao.pitch[1], ar > 1 and ar < 14 and ax and "up" or "default")
    ui.set(ao.yaw[1], "180")
    ui.set(ao.edge[1], false)
    ui.set(ao.fsbody[1], false)
end
local aB = function(av)
    local aC = "\a"
    for aD, aE in next, av do
        local aF = ""
        while aE > 0 do
            local aG = math.fmod(aE, 16) + 1
            aE = math.floor(aE / 16)
            aF = string.sub("0123456789ABCDEF", aG, aG) .. aF
        end
        if #aF == 0 then
            aF = "00"
        elseif #aF == 1 then
            aF = "0" .. aF
        end
        aC = aC .. aF
    end
    return aC .. "FF"
end
local aH = require("gamesense/clipboard")
local aI
local aJ =
    (function()
    aI = {}
    local a = {callback_registered = false, maximum_count = 4}
    function a:register_callback()
        if self.callback_registered then
            return
        end
        client.set_event_callback(
            "paint_ui",
            function()
                local c = {client.screen_size()}
                local d = {0, 0, 0}
                local e = 1
                local f = aI
                for g = #f, 1, -1 do
                    aI[g].time = aI[g].time - globals.frametime()
                    local h, i = 255, 0
                    local aK = 0
                    local aL = 150
                    local aM = 0.5
                    local j = f[g]
                    if j.time < 0 then
                        table.remove(aI, g)
                    else
                        local k = j.def_time - j.time
                        local k = k > 1 and 1 or k
                        if j.time < 1 or k < 1 then
                            i = (k < 1 and k or j.time) / 1
                            aK = (k < 1 and k or j.time) / 1
                            h = i * 255
                            aL = i * 150
                            aM = i * 0.5
                            if i < 0.2 then
                                e = e + 8 * (1.0 - i / 0.2)
                            end
                        end
                        local m = {math.floor(renderer.measure_text(nil, "[alucard]  " .. j.draw) * 1.03)}
                        local n = {renderer.measure_text(nil, "[alucard]  ")}
                        local o = {renderer.measure_text(nil, j.draw)}
                        local p = {c[1] / 2 - m[1] / 2 + 3, c[2] - c[2] / 100 * 13.4 + e}
                        local aN, aO, aP, aQ = 255, 0, 0, 255
                        local x, y = client.screen_size()
                        renderer.rectangle(p[1] - 1, p[2] - 20, m[1] + 2, 22, 18, 7, 8, h > 255 and 255 or h)
                        renderer.circle(p[1] - 1, p[2] - 8, 18, 7, 8, h > 255 and 255 or h, 12, 180, 0.5)
                        renderer.circle(p[1] + m[1] + 1, p[2] - 8, 18, 7, 8, h > 255 and 255 or h, 12, 0, 0.5)
                        renderer.circle_outline(p[1] - 1, p[2] - 9, aN, aO, aP, h > 200 and 200 or h, 13, 90, aM, 2)
                        renderer.circle_outline(
                            p[1] + m[1] + 1,
                            p[2] - 9,
                            aN,
                            aO,
                            aP,
                            h > 200 and 200 or h,
                            13,
                            -90,
                            aM,
                            2
                        )
                        renderer.line(
                            p[1] + m[1] + 1,
                            p[2] + 3,
                            p[1] + 149 - aL,
                            p[2] + 3,
                            aN,
                            aO,
                            aP,
                            h > 255 and 255 or h
                        )
                        renderer.line(
                            p[1] + m[1] + 1,
                            p[2] + 3,
                            p[1] + 149 - aL,
                            p[2] + 3,
                            aN,
                            aO,
                            aP,
                            h > 255 and 255 or h
                        )
                        renderer.line(
                            p[1] - 1,
                            p[2] - 21,
                            p[1] - 149 + m[1] + aL,
                            p[2] - 21,
                            aN,
                            aO,
                            aP,
                            h > 255 and 255 or h
                        )
                        renderer.line(
                            p[1] - 1,
                            p[2] - 21,
                            p[1] - 149 + m[1] + aL,
                            p[2] - 21,
                            aN,
                            aO,
                            aP,
                            h > 255 and 255 or h
                        )
                        renderer.text(p[1] + m[1] / 2 - o[1] / 2, p[2] - 9, aN, aO, aP, h, "c", nil, "[alucard]  ")
                        renderer.text(p[1] + m[1] / 2 + n[1] / 2, p[2] - 9, 255, 255, 255, h, "c", nil, j.draw)
                        e = e - 33
                    end
                end
                self.callback_registered = true
            end
        )
    end
    function a:paint(q, r)
        local s = tonumber(q) + 1
        for g = self.maximum_count, 2, -1 do
            aI[g] = aI[g - 1]
        end
        aI[1] = {time = s, def_time = s, draw = r}
        self:register_callback()
    end
    return a
end)()
local aR, aS = ui.reference("rage", "aimbot", "double tap")
local aT, aU = ui.reference("aa", "other", "on shot anti-aim")
local aV, aW = ui.reference("aa", "other", "slow motion")
local aX = database.read("cfglist") or {}
return (function(aY)
    aY.items = {
        toggle = aY.refui("aa", "anti-aimbot angles", "enabled"),
        yaw = aY.refui("aa", "anti-aimbot angles", "yaw"),
        pitch = aY.refui("aa", "anti-aimbot angles", "pitch"),
        base = aY.refui("aa", "anti-aimbot angles", "yaw base"),
        jitter = aY.refui("aa", "anti-aimbot angles", "yaw jitter"),
        body = aY.refui("aa", "anti-aimbot angles", "body yaw"),
        fsbody = aY.refui("aa", "anti-aimbot angles", "freestanding body yaw"),
        fsyaw = aY.refui("aa", "anti-aimbot angles", "freestanding"),
        edge = aY.refui("aa", "anti-aimbot angles", "edge yaw"),
        roll = aY.refui("aa", "anti-aimbot angles", "roll")
    }
    aY.prefix = aB({255, 0, 0}) .. "alucard " .. aB({55, 55, 55}) .. "- " .. aB({255, 255, 255})
    aY.menu = {
        select = ui.new_combobox("aa", "anti-aimbot angles", aY.prefix .. "anti aim system", "anti aim", "config"),
        ["anti aim"] = {
            toggle = ui.new_checkbox("aa", "anti-aimbot angles", aY.prefix .. "toggle"),
            menu = ui.new_multiselect("aa", "anti-aimbot angles", aY.prefix .. "menu options", "keybinds"),
            left = ui.new_hotkey("aa", "anti-aimbot angles", aY.prefix .. "left"),
            right = ui.new_hotkey("aa", "anti-aimbot angles", aY.prefix .. "right"),
            forward = ui.new_hotkey("aa", "anti-aimbot angles", aY.prefix .. "forward"),
            edge = ui.new_hotkey("aa", "anti-aimbot angles", aY.prefix .. "edge"),
            fs = ui.new_hotkey("aa", "anti-aimbot angles", aY.prefix .. "freestand"),
            disabler = ui.new_multiselect(
                "aa",
                "anti-aimbot angles",
                aY.prefix .. "fs disablers",
                {"air", "slow", "duck"}
            ),
            state = ui.new_combobox("aa", "anti-aimbot angles", aY.prefix .. "state", aY.states),
            team = ui.new_combobox("aa", "anti-aimbot angles", aY.prefix .. "team", "ct", "t"),
            builder = {}
        },
        ["config"] = {
            export = ui.new_button(
                "aa",
                "anti-aimbot angles",
                "export",
                function()
                    local aC = {}
                    for aG, aE in next, aY.menu["anti aim"].builder do
                        aC[aG] = {}
                        for i, v in next, aE do
                            if i ~= "button" then
                                aC[aG][i] = ui.get(v)
                            end
                        end
                    end
                    aH.set(json.stringify(aC))
                    aJ:paint(5, "exported ur cfg to clipboard")
                end
            ),
            import = ui.new_button(
                "aa",
                "anti-aimbot angles",
                "import",
                function()
                    aJ:paint(5, "loading...")
                    local aC = json.parse(aH.get())
                    pcall(
                        function()
                            for aG, aE in next, aY.menu["anti aim"].builder do
                                for i, v in next, aE do
                                    if i ~= "button" then
                                        ui.set(v, aC[aG][i])
                                    end
                                end
                            end
                            aJ:paint(5, "loaded!")
                        end
                    )
                end
            ),
            list = ui.new_combobox(
                "aa",
                "anti-aimbot angles",
                aY.prefix .. "config",
                {
                    "alpha",
                    "bravo",
                    "charlie",
                    "delta",
                    "echo",
                    "foxtrot",
                    "golf",
                    "hotel",
                    "india",
                    "juliet",
                    "kilo",
                    "lima",
                    "mike",
                    "november",
                    "oscar",
                    "papa",
                    "quebec",
                    "romeo",
                    "sierra",
                    "tango",
                    "uniform",
                    "victor",
                    "whiskey",
                    "xray",
                    "yankee",
                    "zulu"
                }
            ),
            save = ui.new_button(
                "aa",
                "anti-aimbot angles",
                "save",
                function()
                    local aC = {}
                    for aG, aE in next, aY.menu["anti aim"].builder do
                        aC[aG] = {}
                        for i, v in next, aE do
                            if i ~= "button" then
                                aC[aG][i] = ui.get(v)
                            end
                        end
                    end
                    aJ:paint(5, "saved " .. ui.get(aY.menu["config"].list))
                    aX[ui.get(aY.menu["config"].list)] = json.stringify(aC)
                    database.write("cfglist", aX)
                end
            ),
            load = ui.new_button(
                "aa",
                "anti-aimbot angles",
                "load",
                function()
                    pcall(
                        function()
                            aJ:paint(5, "loading " .. ui.get(aY.menu["config"].list))
                            local aC = json.parse(aX[ui.get(aY.menu["config"].list)])
                            for aG, aE in next, aY.menu["anti aim"].builder do
                                for i, v in next, aE do
                                    if i ~= "button" then
                                        ui.set(v, aC[aG][i])
                                    end
                                end
                            end
                            aJ:paint(5, "loaded " .. ui.get(aY.menu["config"].list))
                        end
                    )
                end
            )
        },
        handler = function()
            if not ui.is_menu_open() then
                return nil
            end
            for aG, aE in next, aY.items do
                for i, v in next, aE do
                    ui["set_visible"](v, false)
                end
            end
            local aZ = ui.get(aY.menu.select)
            for aG, aE in next, aY.menu do
                if type(aE) == "table" then
                    if aG == "anti aim" then
                        local a_ = ui.get(aE["state"])
                        for i, v in next, aE do
                            if i == "builder" then
                                for b0, b1 in next, v do
                                    for b2, b3 in next, b1 do
                                        local b4 = true
                                        if b2 == "bodyyawslider" then
                                            b4 = ui.get(b1["bodyyaw"]) == "jitter" or ui.get(b1["bodyyaw"]) == "static"
                                        end
                                        if b2 == "yawjitterslider" then
                                            b4 = ui.get(b1["yawjitter"]) ~= "off"
                                        end
                                        if b2 == "left" or b2 == "right" then
                                            b4 = aY.contains(ui.get(b1["options"]), "l&r yaw")
                                        end
                                        if b2 == "dtleft" or b2 == "dtright" then
                                            b4 = aY.contains(ui.get(b1["options"]), "advanced dt")
                                        end
                                        if b2 == "slideryawjitter" then
                                            b4 = string.find(ui.get(b1["yawjitter"]), "l&r")
                                        end
                                        if b2 == "enable" then
                                            b4 = not string.find(b0, "global")
                                        else
                                            if not ui.get(b1["enable"]) and not string.find(b0, "global") then
                                                b4 = false
                                            end
                                        end
                                        if b2 == "button" then
                                            b4 = true
                                        end
                                        ui["set_visible"](
                                            b3,
                                            aZ == aG and b0 == "[" .. ui.get(aY.menu["anti aim"]["team"]) .. "] " .. a_ and
                                                b4
                                        )
                                    end
                                end
                            else
                                local a_ = true
                                if
                                    i == "forward" or i == "edge" or i == "fs" or i == "disabler" or i == "left" or
                                        i == "right"
                                 then
                                    a_ = aY.contains(ui.get(aY.menu["anti aim"]["menu"]), "keybinds")
                                end
                                ui["set_visible"](v, aZ == aG and a_)
                            end
                        end
                    else
                        if type(aE) == "table" then
                            for i, v in next, aE do
                                ui["set_visible"](v, aZ == aG)
                            end
                        else
                            ui["set_visible"](aE, aZ == aG)
                        end
                    end
                end
            end
        end
    }
    ui.set(aY.menu["anti aim"].toggle, true)
    local b5 = function(av)
        local x = string.find(ui.name(av), "ct") and "ct" or "t"
        local z = string.find(ui.name(av), "ct") and "t" or "ct"
        local ao = aY.menu["anti aim"].builder["[" .. z .. "] " .. ui.get(aY.menu["anti aim"].state)]
        for aG, aE in next, aY.menu["anti aim"].builder["[" .. x .. "] " .. ui.get(aY.menu["anti aim"].state)] do
            if aG ~= "button" then
                ui.set(aE, ui.get(ao[aG]))
            end
        end
        aJ:paint(5, "sent to " .. z)
    end
    aY.cache = {}
    for i, v in next, aY.states do
        aY.cache[#aY.cache + 1] = "[ct] " .. v
        aY.cache[#aY.cache + 1] = "[t] " .. v
    end
    for aG, aE in next, aY.cache do
        aY.menu["anti aim"].builder[aE] = {
            enable = ui.new_checkbox("aa", "anti-aimbot angles", aY.prefix .. aE .. ": enable"),
            pitch = ui.new_combobox(
                "aa",
                "anti-aimbot angles",
                aY.prefix .. aE .. ": pitch",
                "down",
                "up",
                "minimal",
                "random"
            ),
            yawjitter = ui.new_combobox(
                "aa",
                "anti-aimbot angles",
                aY.prefix .. aE .. ": yaw jitter",
                "off",
                "skitter",
                "offset",
                "center",
                "l&r offset",
                "l&r center",
                "random"
            ),
            yawjitterslider = ui.new_slider(
                "aa",
                "anti-aimbot angles",
                aY.prefix .. aE .. ": yaw jitter slider",
                -180,
                180,
                0,
                true,
                "°",
                1
            ),
            slideryawjitter = ui.new_slider(
                "aa",
                "anti-aimbot angles",
                aY.prefix .. aE .. ": l&r jitter slider",
                -180,
                180,
                0,
                true,
                "°",
                1
            ),
            bodyyaw = ui.new_combobox(
                "aa",
                "anti-aimbot angles",
                aY.prefix .. aE .. ": body yaw",
                "off",
                "opposite",
                "jitter",
                "static"
            ),
            bodyyawslider = ui.new_slider(
                "aa",
                "anti-aimbot angles",
                aY.prefix .. aE .. ": body yaw slider",
                -180,
                180,
                0,
                true,
                "°",
                1
            ),
            options = ui.new_multiselect(
                "aa",
                "anti-aimbot angles",
                aY.prefix .. aE .. ": options",
                "l&r yaw",
                "invalid dt ticks",
                "pitch breaker",
                "advanced dt"
            ),
            left = ui.new_slider("aa", "anti-aimbot angles", aY.prefix .. aE .. ": yaw left", -50, 50, -10),
            right = ui.new_slider("aa", "anti-aimbot angles", aY.prefix .. aE .. ": yaw right", -50, 50, 10),
            dtleft = ui.new_slider("aa", "anti-aimbot angles", aY.prefix .. aE .. ": adv left", 10, 50, 30),
            dtright = ui.new_slider("aa", "anti-aimbot angles", aY.prefix .. aE .. ": adv right", 10, 50, 30),
            button = ui.new_button(
                "aa",
                "anti-aimbot angles",
                "send to " .. (string.find(aE, "ct") and "t" or "ct"),
                b5
            )
        }
    end
    aY.antiaim = {builder = function(av)
            local b6 = entity.get_local_player()
            local b7 = bit.band(entity.get_prop(b6, "m_fFlags"), 1) == 0
            local x, y, z = entity.get_prop(b6, "m_vecVelocity")
            local b8 = entity.get_prop(b6, "m_flDuckAmount") > 0.1
            local b9 = aY.getstate(b6, av.in_jump == 1 or b7, b8, math.sqrt(x * x + y * y + z * z))
            local ba = entity.get_prop(b6, "m_iTeamNum")
            if ba == 2 then
                b9 = "[t] " .. b9
            else
                b9 = "[ct] " .. b9
            end
            local ao = aY.menu["anti aim"].builder[b9]
            local bb = not (ui.get(aR) and ui.get(aS) or ui.get(aT) and ui.get(aU))
            if bb and ui.get(aY.menu["anti aim"].builder[ba == 2 and "[t] fake lag" or "[ct] fake lag"].enable) then
                ao = aY.menu["anti aim"].builder[ba == 2 and "[t] fake lag" or "[ct] fake lag"]
            end
            if not ui.get(ao.enable) then
                ao = aY.menu["anti aim"].builder[ba == 2 and "[t] global" or "[ct] global"]
            end
            if aY.contains(ui.get(ao.options), "advanced dt") then
                return advfunc(
                    av,
                    aY.contains(ui.get(ao.options), "pitch breaker"),
                    ui.get(ao.dtleft),
                    ui.get(ao.dtright)
                )
            end
            ui.set(aY.items.roll[1], 0)
            ui.set(aY.items.toggle[1], ui.get(aY.menu["anti aim"].toggle))
            ui.set(aY.items.edge[1], ui.get(aY.menu["anti aim"].edge))
            ui.set(aY.items.yaw[1], "180")
            ui.set(aY.items.base[1], aY.data["aa"] == 0 and "local view" or "local view")
            ui.set(aY.items.fsyaw[2], "always on")
            local bc = ui.get(aY.menu["anti aim"].fs)
            ui.set(aY.items.fsyaw[1], bc)
            if aY.contains(ui.get(aY.menu["anti aim"].disabler), "air") and (av.in_jump == 1 or b7) then
                ui.set(aY.items.fsyaw[1], false)
                bc = false
            end
            if aY.contains(ui.get(aY.menu["anti aim"].disabler), "slow") and (ui.get(aV) and ui.get(aW)) then
                ui.set(aY.items.fsyaw[1], false)
                bc = false
            end
            if aY.contains(ui.get(aY.menu["anti aim"].disabler), "duck") and b8 then
                ui.set(aY.items.fsyaw[1], false)
                bc = false
            end
            ui.set(aY.items.pitch[1], ui.get(ao.pitch))
            ui.set(aY.items.jitter[1], ui.get(ao.yawjitter):gsub("l&r ", ""))
            ui.set(aY.items.jitter[2], ui.get(ao.yawjitterslider))
            ui.set(aY.items.body[1], ui.get(ao.bodyyaw))
            ui.set(aY.items.body[2], ui.get(ao.bodyyawslider))
            if entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60 > 0 then
                if aY.contains(ui.get(ao.options), "l&r yaw") then
                    ui.set(aY.items.yaw[2], aY.clamp(ui.get(ao.left) + aY.data["aa"]))
                end
            else
                if aY.contains(ui.get(ao.options), "l&r yaw") then
                    ui.set(aY.items.yaw[2], aY.clamp(ui.get(ao.right) + aY.data["aa"]))
                end
                if string.find(ui.get(ao.yawjitter), "l&r") then
                    ui.set(aY.items.jitter[2], ui.get(ao.slideryawjitter))
                end
            end
            if not aY.contains(ui.get(ao.options), "l&r yaw") then
                ui.set(aY.items.yaw[2], aY.data["aa"])
            end
            ui.set(aY.items.fsbody[1], false)
            if bc then
                ui.set(aY.items.yaw[2], 0)
                ui.set(aY.items.jitter[2], 0)
                ui.set(aY.items.body[1], "opposite")
                ui.set(aY.items.fsbody[1], true)
            end
            av.force_defensive = av.quick_stop or av.weaponselect ~= 0
            if aY.contains(ui.get(ao.options), "pitch breaker") then
                av.force_defensive = true
                if aY.defensive > 2 and aY.defensive < 14 then
                    ui.set(aY.items.pitch[1], "up")
                else
                    ui.set(aY.items.pitch[1], "minimal")
                end
            end
            if aY.contains(ui.get(ao.options), "invalid dt ticks") then
                av.force_defensive = av.chokedcommands % 2 == 1 and not av.no_choke
            end
            if aY.contains(ui.get(ao.options), "advanced dt") then
                advfunc(av)
            end
        end, predict = function()
            local aw = entity.get_prop(entity.get_local_player(), "m_nTickBase")
            aY.defensive = math.abs(aw - aY.checker)
            aY.checker = math.max(aw, aY.checker or 0)
        end}
    aY.data = {aa = 0, tick = 0, alpha = 255, switch = true}
    aY.manual = function()
        local ao = aY.menu["anti aim"]
        local bd = globals.tickcount()
        ui.set(ao.left, "on hotkey")
        ui.set(ao.right, "on hotkey")
        ui.set(ao.forward, "on hotkey")
        if entity.get_local_player() == nil then
            return
        end
        if not entity.is_alive(entity.get_local_player()) then
            return
        end
        if ui.get(ao.left) and aY.data["tick"] < bd - 11 then
            aY.data["aa"] = aY.data["aa"] == -90 and 0 or -90
            aY.data["tick"] = bd
        end
        if ui.get(ao.right) and aY.data["tick"] < bd - 11 then
            aY.data["aa"] = aY.data["aa"] == 90 and 0 or 90
            aY.data["tick"] = bd
        end
        if ui.get(ao.forward) and aY.data["tick"] < bd - 11 then
            aY.data["aa"] = aY.data["aa"] == 180 and 0 or 180
            aY.data["tick"] = bd
        end
        local r, g, b, a = 255, 255, 255, aY.data["alpha"]
        local be, bf = client.screen_size()
        be, bf = be / 2, bf / 2
        if aY.data["aa"] == 90 then
            renderer.text(be + 50, bf - 2.5, r, g, b, a, "c+", 0, "⯈")
        end
        if aY.data["aa"] == -90 then
            renderer.text(be + -50, bf - 2.5, r, g, b, a, "c+", 0, "⯇")
        end
        if aY.data["alpha"] <= 255 and aY.data["switch"] then
            aY.data["alpha"] = aY.data["alpha"] - 1
            if aY.data["alpha"] < 55 then
                aY.data["switch"] = false
            end
        end
        if not aY.data["switch"] then
            aY.data["alpha"] = aY.data["alpha"] + 1
            if aY.data["alpha"] >= 255 then
                aY.data["switch"] = true
            end
        end
    end
    aY.reset = function()
        aY.data = {aa = 0, tick = 0, alpha = 255, switch = true}
    end
    aY.shutdown = function()
        for aG, aE in next, aY.items do
            for i, v in next, aE do
                ui["set_visible"](v, true)
            end
        end
    end
    aY.hitgroup = {"GENERIC", "HEAD", "CHEST", "STOMACH", "ARMS", "ARMS", "LEGS", "LEGS", "HEAD", "?", "GENERIC"}
    aY.hit = function(bg)
    end
    aY.miss = function(bg)
    end
    aY.events = {
        setup_command = {aY.antiaim.builder},
        predict_command = {aY.antiaim.predict},
        paint_ui = {aY.menu.handler, aY.manual},
        round_prestart = {aY.reset},
        aim_hit = {aY.hit},
        aim_miss = {aY.miss},
        shutdown = {aY.shutdown}
    }
    for aG, aE in next, aY.events do
        for i, v in next, aE do
            client.set_event_callback(aG, v)
        end
    end
end)(
    {
        states = {"global", "air duck", "air", "duck", "duck move", "stand", "running", "fake lag"},
        getstate = function(bh, b7, b8, bi)
            local b9 = "global"
            if b7 and b8 then
                b9 = "air duck"
            end
            if b7 and not b8 then
                b9 = "air"
            end
            if b8 and not b7 and bi < 1.1 then
                b9 = "duck"
            end
            if b8 and not b7 and bi > 1.1 then
                b9 = "duck move"
            end
            if bi < 1.1 and not b7 and not b8 then
                b9 = "stand"
            end
            if bi > 1.1 and not b7 and not b8 then
                b9 = "running"
            end
            return b9
        end,
        checker = 0,
        defensive = 0,
        clamp = function(bj)
            bj = (bj % 360 + 360) % 360
            return bj > 180 and bj - 360 or bj
        end,
        contains = function(aY, bk)
            for aG, aE in next, aY do
                if aE == bk then
                    return true
                end
            end
            return false
        end,
        refui = function(a, b, c)
            return {ui.reference(a, b, c)}
        end
    }
)