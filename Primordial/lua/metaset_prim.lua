local info = {
    user = "user"
}

local ffi = require "ffi"
local bit = require "bit"

local vector = function(one, two, three)
    if not three then
        return vec2_t(one, two)
    elseif three then
        return vec3_t(one, two, three)
    end
end

local color = function(...)
    return color_t(...)
end

local json = (function()
    local json = {
        _version = "0.1.2"
    }
    local encode
    local escape_char_map = {
        ["\\"] = "\\",
        ["\""] = "\"",
        ["\b"] = "b",
        ["\f"] = "f",
        ["\n"] = "n",
        ["\r"] = "r",
        ["\t"] = "t"
    }
    local escape_char_map_inv = {
        ["/"] = "/"
    }
    for k, v in pairs(escape_char_map) do
        escape_char_map_inv[v] = k
    end
    local function escape_char(c)
        return "\\" .. (escape_char_map[c] or string.format("u%04x", c:byte()))
    end
    local function encode_nil(val)
        return "null"
    end
    local function encode_table(val, stack)
        local res = {}
        stack = stack or {}
        if stack[val] then
            error("circular reference")
        end
        stack[val] = true
        if rawget(val, 1) ~= nil or next(val) == nil then
            local n = 0
            for k in pairs(val) do
                if type(k) ~= "number" then
                    error("invalid table: mixed or invalid key types")
                end
                n = n + 1
            end
            if n ~= #val then
                error("invalid table: sparse array")
            end
            for i, v in ipairs(val) do
                table.insert(res, encode(v, stack))
            end
            stack[val] = nil
            return "[" .. table.concat(res, ",") .. "]"
        else
            for k, v in pairs(val) do
                if type(k) ~= "string" then
                    error("invalid table: mixed or invalid key types")
                end
                table.insert(res, encode(k, stack) .. ":" .. encode(v, stack))
            end
            stack[val] = nil
            return "{" .. table.concat(res, ",") .. "}"
        end
    end
    local function encode_string(val)
        return '"' .. val:gsub('[%z\1-\31\\"]', escape_char) .. '"'
    end
    local function encode_number(val)
        if val ~= val or val <= -math.huge or val >= math.huge then
            error("unexpected number value '" .. tostring(val) .. "'")
        end
        return string.format("%.14g", val)
    end
    local type_func_map = {
        ["nil"] = encode_nil,
        ["table"] = encode_table,
        ["string"] = encode_string,
        ["number"] = encode_number,
        ["boolean"] = tostring
    }
    encode = function(val, stack)
        local t = type(val)
        local f = type_func_map[t]
        if f then
            return f(val, stack)
        end
        error("unexpected type '" .. t .. "'")
    end
    function json.encode(val)
        return (encode(val))
    end
    local parse
    local function create_set(...)
        local res = {}
        for i = 1, select("#", ...) do
            res[select(i, ...)] = true
        end
        return res
    end
    local space_chars = create_set(" ", "\t", "\r", "\n")
    local delim_chars = create_set(" ", "\t", "\r", "\n", "]", "}", ",")
    local escape_chars = create_set("\\", "/", '"', "b", "f", "n", "r", "t", "u")
    local literals = create_set("true", "false", "null")
    local literal_map = {
        ["true"] = true,
        ["false"] = false,
        ["null"] = nil
    }
    local function next_char(str, idx, set, negate)
        for i = idx, #str do
            if set[str:sub(i, i)] ~= negate then
                return i
            end
        end
        return #str + 1
    end
    local function decode_error(str, idx, msg)
        local line_count = 1
        local col_count = 1
        for i = 1, idx - 1 do
            col_count = col_count + 1
            if str:sub(i, i) == "\n" then
                line_count = line_count + 1
                col_count = 1
            end
        end
        error(string.format("%s at line %d col %d", msg, line_count, col_count))
    end
    local function codepoint_to_utf8(n)
        local f = math.floor
        if n <= 0x7f then
            return string.char(n)
        elseif n <= 0x7ff then
            return string.char(f(n / 64) + 192, n % 64 + 128)
        elseif n <= 0xffff then
            return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
        elseif n <= 0x10ffff then
            return string.char(f(n / 262144) + 240, f(n % 262144 / 4096) + 128, f(n % 4096 / 64) + 128, n % 64 + 128)
        end
        error(string.format("invalid unicode codepoint '%x'", n))
    end
    local function parse_unicode_escape(s)
        local n1 = tonumber(s:sub(1, 4), 16)
        local n2 = tonumber(s:sub(7, 10), 16)
        if n2 then
            return codepoint_to_utf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
        else
            return codepoint_to_utf8(n1)
        end
    end
    local function parse_string(str, i)
        local res = ""
        local j = i + 1
        local k = j
        while j <= #str do
            local x = str:byte(j)
            if x < 32 then
                decode_error(str, j, "control character in string")
            elseif x == 92 then
                res = res .. str:sub(k, j - 1)
                j = j + 1
                local c = str:sub(j, j)
                if c == "u" then
                    local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j + 1) or str:match("^%x%x%x%x", j + 1) or decode_error(str, j - 1, "invalid unicode escape in string")
                    res = res .. parse_unicode_escape(hex)
                    j = j + #hex
                else
                    if not escape_chars[c] then
                        decode_error(str, j - 1, "invalid escape char '" .. c .. "' in string")
                    end
                    res = res .. escape_char_map_inv[c]
                end
                k = j + 1
            elseif x == 34 then
                res = res .. str:sub(k, j - 1)
                return res, j + 1
            end
            j = j + 1
        end
        decode_error(str, i, "expected closing quote for string")
    end
    local function parse_number(str, i)
        local x = next_char(str, i, delim_chars)
        local s = str:sub(i, x - 1)
        local n = tonumber(s)
        if not n then
            decode_error(str, i, "invalid number '" .. s .. "'")
        end
        return n, x
    end
    local function parse_literal(str, i)
        local x = next_char(str, i, delim_chars)
        local word = str:sub(i, x - 1)
        if not literals[word] then
            decode_error(str, i, "invalid literal '" .. word .. "'")
        end
        return literal_map[word], x
    end
    local function parse_array(str, i)
        local res = {}
        local n = 1
        i = i + 1
        while 1 do
            local x
            i = next_char(str, i, space_chars, true)
            if str:sub(i, i) == "]" then
                i = i + 1
                break
            end
            x, i = parse(str, i)
            res[n] = x
            n = n + 1
            i = next_char(str, i, space_chars, true)
            local chr = str:sub(i, i)
            i = i + 1
            if chr == "]" then
                break
            end
            if chr ~= "," then
                decode_error(str, i, "expected ']' or ','")
            end
        end
        return res, i
    end
    local function parse_object(str, i)
        local res = {}
        i = i + 1
        while 1 do
            local key, val
            i = next_char(str, i, space_chars, true)
            if str:sub(i, i) == "}" then
                i = i + 1
                break
            end
            if str:sub(i, i) ~= '"' then
                decode_error(str, i, "expected string for key")
            end
            key, i = parse(str, i)
            i = next_char(str, i, space_chars, true)
            if str:sub(i, i) ~= ":" then
                decode_error(str, i, "expected ':' after key")
            end
            i = next_char(str, i + 1, space_chars, true)
            val, i = parse(str, i)
            res[key] = val
            i = next_char(str, i, space_chars, true)
            local chr = str:sub(i, i)
            i = i + 1
            if chr == "}" then
                break
            end
            if chr ~= "," then
                decode_error(str, i, "expected '}' or ','")
            end
        end
        return res, i
    end
    local char_func_map = {
        ['"'] = parse_string,
        ["0"] = parse_number,
        ["1"] = parse_number,
        ["2"] = parse_number,
        ["3"] = parse_number,
        ["4"] = parse_number,
        ["5"] = parse_number,
        ["6"] = parse_number,
        ["7"] = parse_number,
        ["8"] = parse_number,
        ["9"] = parse_number,
        ["-"] = parse_number,
        ["t"] = parse_literal,
        ["f"] = parse_literal,
        ["n"] = parse_literal,
        ["["] = parse_array,
        ["{"] = parse_object
    }
    parse = function(str, idx)
        local chr = str:sub(idx, idx)
        local f = char_func_map[chr]
        if f then
            return f(str, idx)
        end
        decode_error(str, idx, "unexpected character '" .. chr .. "'")
    end
    function json.parse(str)
        if type(str) ~= "string" then
            error("expected argument of type string, got " .. type(str))
        end
        local res, idx = parse(str, next_char(str, 1, space_chars, true))
        idx = next_char(str, idx, space_chars, true)
        if idx <= #str then
            decode_error(str, idx, "trailing garbage")
        end
        return res
    end
    return json
end)()

local eui = (function()
    local ui = {}
    ui.__type = {
        group = -1,
        button = 0,
        keybind = 1,
        text_input = 2,
        text = 3,
        separator = 4,
        list = 5,
        checkbox = 6,
        color_picker = 7,
        multi_selection = 8,
        selection = 9,
        slider = 10
    }
    ui.__metasave = true
    ui.__data = {}
    ui.create = function(_group, _column)
        local data = {
            group = _group,
            column = _column,
            id = ui.__type.group
        }
        menu.set_group_column(_group, _column)
        ui.__index = ui
        return setmetatable(data, ui)
    end
    function ui:create_element(_id, _name, _options)
        local ref = nil
        if _id == ui.__type.button then
            ref = menu.add_button(self.group, _name, _options.fn)
        elseif _id == ui.__type.checkbox then
            ref = menu.add_checkbox(self.group, _name, _options.default_value)
        elseif _id == ui.__type.color_picker then
            ref = _options.parent.ref:add_color_picker(_name, _options.default_value, _options.alpha)
        elseif _id == ui.__type.keybind then
            ref = _options.parent.ref:add_keybind(_name, _options.default_value)
        elseif _id == ui.__type.list then
            ref = menu.add_list(self.group, _name, _options.items, _options.visible_count)
        elseif _id == ui.__type.multi_selection then
            ref = menu.add_multi_selection(self.group, _name, _options.items, _options.visible_count)
        elseif _id == ui.__type.selection then
            ref = menu.add_selection(self.group, _name, _options.items, _options.visible_count)
        elseif _id == ui.__type.slider then
            ref = menu.add_slider(self.group, _name, _options.min, _options.max, _options.step, _options.precision, _options.suffix)
        elseif _id == ui.__type.text_input then
            ref = menu.add_text_input(self.group, _name)
        elseif _id == ui.__type.text then
            ref = menu.add_text(self.group, _name)
        elseif _id == ui.__type.separator then
            ref = menu.add_separator(self.group)
        end
        local data = {
            name = _name,
            id = _id,
            ref = ref,
            group = self.group,
            get = function(self, _item)
                if self.id == ui.__type.multi_selection then
                    return self.ref:get(_item)
                else
                    return self.ref:get()
                end
            end
        }
        if not ui.__data[self.group] then
            ui.__data[self.group] = {}
        end
        ui.__data[self.group][_name] = data
        if ui.__metasave then
            if not ui[self.group] then
                ui[self.group] = {}
            end
            ui[self.group][_name] = data
            self[_name] = data
        end
        return setmetatable(data, ui)
    end
    function ui:button(_name, _fn)
        _fn = _fn or function()
        end
        return self:create_element(ui.__type.button, _name, {
            fn = _fn
        })
    end
    function ui:checkbox(_name, _default_value)
        return self:create_element(ui.__type.checkbox, _name, {
            default_value = _default_value
        })
    end
    function ui:color_picker(_parent, _name, _default_value, _alpha)
        return self:create_element(ui.__type.color_picker, _name, {
            parent = _parent,
            default_value = _default_value,
            alpha = _alpha
        })
    end
    function ui:keybind(_parent, _name, _default_value)
        return self:create_element(ui.__type.keybind, _name, {
            parent = _parent,
            default_value = _default_value
        })
    end
    function ui:list(_name, _items, _visible_count)
        return self:create_element(ui.__type.list, _name, {
            items = _items,
            visible_count = _visible_count
        })
    end
    function ui:multi_selection(_name, _items, _visible_count)
        return self:create_element(ui.__type.multi_selection, _name, {
            items = _items,
            visible_count = _visible_count
        })
    end
    function ui:selection(_name, _items, _visible_count)
        return self:create_element(ui.__type.selection, _name, {
            items = _items,
            visible_count = _visible_count
        })
    end
    function ui:slider(_name, _min, _max, _step, _precision, _suffix)
        return self:create_element(ui.__type.slider, _name, {
            min = _min,
            max = _max,
            step = _step,
            precision = _precision,
            suffix = _suffix
        })
    end
    function ui:text_input(_name)
        return self:create_element(ui.__type.text_input, _name)
    end
    function ui:text(_name, _options)
        return self:create_element(ui.__type.text, _name, _options)
    end
    function ui:separator()
        return self:create_element(ui.__type.separator, "separator")
    end
    ui.export = function()
        local d = {}
        for i, v in pairs(ui.__data) do
            d[i] = {}
            for i0, v0 in pairs(v) do
                if not (v0.id < ui.__type.checkbox) then
                    if v0.id == ui.__type.multi_selection then
                        local s = {}
                        for i1, v1 in pairs(v0.ref:get_items()) do
                            table.insert(s, {v1, v0.ref:get(v1)})
                        end
                        table.insert(d[i], {v0.name, s})
                    elseif v0.id == ui.__type.color_picker then
                        local clr = v0.ref:get()
                        table.insert(d[i], {v0.name, clr.r, clr.g, clr.b, clr.a})
                    else
                        table.insert(d[i], {v0.name, v0.ref:get()})
                    end
                end
            end
        end
        return json.encode(d)
    end
    ui.import = function(data)
        local db = json.parse(data)
        for i, v in pairs(db) do
            for i0, v0 in pairs(v) do
                if not (ui.__data[i] == nil or ui.__data[i][v0[1]] == nil) then
                    if ui.__data[i][v0[1]].id == ui.__type.multi_selection then
                        for i1, v1 in pairs(v0[2]) do
                            ui.__data[i][v0[1]].ref:set(v1[1], v1[2])
                        end
                    elseif ui.__data[i][v0[1]].id == ui.__type.color_picker then
                        ui.__data[i][v0[1]].ref:set(color_t(v0[2], v0[3], v0[4], v0[5]))
                    else
                        ui.__data[i][v0[1]].ref:set(v0[2])
                    end
                end
            end
        end
    end
    function ui:depend(...)
        local args = {...}
        local result = nil
        for i, v in pairs(args) do
            local con = nil
            if type(v[1]) == "boolean" then
                con = v[1]
            else
                con = v[1].ref:get() == v[2]
            end
            if result ~= nil then
                result = (result and con)
            else
                result = con
            end
        end
        if self.id == -1 then
            menu.set_group_visibility(self.group, result)
        else
            self.ref:set_visible(result)
        end
    end
    return ui
end)()


local base64 = (function()
    local base64 = {}
    local b, c, d = bit.lshift, bit.rshift, bit.band;
    local e, f, g, h, i, j, tostring, error, pairs = string.char, string.byte, string.gsub, string.sub, string.format, table.concat, tostring, error, pairs;
    local k = function(l, m, n)
        return d(c(l, m), b(1, n) - 1)
    end;
    local function o(p)
        local q, r = {}, {}
        for s = 1, 65 do
            local t = f(h(p, s, s)) or 32;
            if r[t] ~= nil then
                error("invalid alphabet: duplicate character " .. tostring(t), 3)
            end
            q[s - 1] = t;
            r[t] = s - 1
        end
        return q, r
    end
    local u, v = {}, {}
    u["base64"], v["base64"] = o("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")
    u["base64url"], v["base64url"] = o("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_")
    local w = {
        __index = function(x, y)
            if type(y) == "string" and y:len() == 64 or y:len() == 65 then
                u[y], v[y] = o(y)
                return x[y]
            end
        end
    }
    setmetatable(u, w)
    setmetatable(v, w)
    function base64.encode(z, q)
        q = u[q or "base64"] or error("invalid alphabet specified", 2)
        z = tostring(z)
        local A, B, C = {}, 1, #z;
        local D = C % 3;
        local E = {}
        for s = 1, C - D, 3 do
            local F, G, H = f(z, s, s + 2)
            local l = F * 0x10000 + G * 0x100 + H;
            local I = E[l]
            if not I then
                I = e(q[k(l, 18, 6)], q[k(l, 12, 6)], q[k(l, 6, 6)], q[k(l, 0, 6)])
                E[l] = I
            end
            A[B] = I;
            B = B + 1
        end
        if D == 2 then
            local F, G = f(z, C - 1, C)
            local l = F * 0x10000 + G * 0x100;
            A[B] = e(q[k(l, 18, 6)], q[k(l, 12, 6)], q[k(l, 6, 6)], q[64])
        elseif D == 1 then
            local l = f(z, C) * 0x10000;
            A[B] = e(q[k(l, 18, 6)], q[k(l, 12, 6)], q[64], q[64])
        end
        return j(A)
    end
    function base64.decode(J, r)
        r = v[r or "base64"] or error("invalid alphabet specified", 2)
        local K = "[^%w%+%/%=]"
        if r then
            local L, M;
            for N, O in pairs(r) do
                if O == 62 then
                    L = N
                elseif O == 63 then
                    M = N
                end
            end
            K = i("[^%%w%%%s%%%s%%=]", e(L), e(M))
        end
        J = g(tostring(J), K, '')
        local E = {}
        local A, B = {}, 1;
        local C = #J;
        local P = h(J, -2) == "==" and 2 or h(J, -1) == "=" and 1 or 0;
        for s = 1, P > 0 and C - 4 or C, 4 do
            local F, G, H, Q = f(J, s, s + 3)
            local R = F * 0x1000000 + G * 0x10000 + H * 0x100 + Q;
            local I = E[R]
            if not I then
                local l = r[F] * 0x40000 + r[G] * 0x1000 + r[H] * 0x40 + r[Q]
                I = e(k(l, 16, 8), k(l, 8, 8), k(l, 0, 8))
                E[R] = I
            end
            A[B] = I;
            B = B + 1
        end
        if P == 1 then
            local F, G, H = f(J, C - 3, C - 1)
            local l = r[F] * 0x40000 + r[G] * 0x1000 + r[H] * 0x40;
            A[B] = e(k(l, 16, 8), k(l, 8, 8))
        elseif P == 2 then
            local F, G = f(J, C - 3, C - 2)
            local l = r[F] * 0x40000 + r[G] * 0x1000;
            A[B] = e(k(l, 16, 8))
        end
        return j(A)
    end
    return base64;
end)()

local filesystem = (function()
    local tbl = {}
    tbl.__index = {}
    tbl.class = ffi.cast(ffi.typeof("void***"), memory.create_interface("filesystem_stdio.dll", "VBaseFileSystem011"))
    tbl.v_table = tbl.class[0]
    tbl.full_class = ffi.cast("void***", memory.create_interface("filesystem_stdio.dll", "VFileSystem017"))
    tbl.v_fltable = tbl.full_class[0]
    tbl.casts = {
        read_file = ffi.cast("int (__thiscall*)(void*, void*, int, void*)", tbl.v_table[0]),
        write_file = ffi.cast("int (__thiscall*)(void*, void const*, int, void*)", tbl.v_table[1]),
        open_file = ffi.cast("void* (__thiscall*)(void*, const char*, const char*, const char*)", tbl.v_table[2]),
        close_file = ffi.cast("void (__thiscall*)(void*, void*)", tbl.v_table[3]),
        file_size = ffi.cast("unsigned int (__thiscall*)(void*, void*)", tbl.v_table[7]),
        file_exists = ffi.cast("bool (__thiscall*)(void*, const char*, const char*)", tbl.v_table[10]),
        delete_file = ffi.cast("void (__thiscall*)(void*, const char*, const char*)", tbl.v_fltable[20]),
        rename_file = ffi.cast("bool (__thiscall*)(void*, const char*, const char*, const char*)", tbl.v_fltable[21]),
        create_dir = ffi.cast("void (__thiscall*)(void*, const char*, const char*)", tbl.v_fltable[22]),
        is_dir = ffi.cast("bool (__thiscall*)(void*, const char*, const char*)", tbl.v_fltable[23])
    }
    local filesystem = memory.create_interface("filesystem_stdio.dll", "VFileSystem017")
    local call = ffi.cast(ffi.typeof("void***"), filesystem)
    ffi.cdef(
        [[ typedef void (__thiscall* AddSearchPath)(void*, const char*, const char*); typedef void (__thiscall* RemoveSearchPaths)(void*, const char*); typedef const char* (__thiscall* FindNext)(void*, int); typedef bool (__thiscall* FindIsDirectory)(void*, int); typedef void (__thiscall* FindClose)(void*, int); typedef const char* (__thiscall* FindFirstEx)(void*, const char*, const char*, int*); typedef long (__thiscall* GetFileTime)(void*, const char*, const char*); ]])
    local add_search_path = ffi.cast("AddSearchPath", call[0][11])
    local remove_search_paths = ffi.cast("RemoveSearchPaths", call[0][14])
    local find_next = ffi.cast("FindNext", call[0][33])
    local find_is_dir = ffi.cast("FindIsDirectory", call[0][34])
    local find_close = ffi.cast("FindClose", call[0][35])
    local find_first_ex = ffi.cast("FindFirstEx", call[0][36])
    tbl.modes = {
        ["r"] = "r",
        ["w"] = "w",
        ["a"] = "a",
        ["r+"] = "r+",
        ["w+"] = "w+",
        ["a+"] = "a+",
        ["rb"] = "rb",
        ["wb"] = "wb",
        ["ab"] = "ab",
        ["rb+"] = "rb+",
        ["wb+"] = "wb+",
        ["ab+"] = "ab+"
    }
    tbl.open = function(file, mode, id)
        if (not tbl.modes[mode]) then
            error("File mode error!")
        end
        local self = setmetatable({
            file = file,
            mode = mode,
            path_id = id,
            handle = tbl.casts.open_file(tbl.class, file, mode, id)
        }, tbl)
        return self
    end
    tbl.close = function(fs)
        tbl.casts.close_file(tbl.class, fs.handle)
    end
    tbl.exists = function(file, id)
        return tbl.casts.file_exists(tbl.class, file, id)
    end
    tbl.get_size = function(fs)
        return tbl.casts.file_size(tbl.class, fs.handle)
    end
    tbl.write = function(path, buffer)
        local fs = tbl.open(path, "w", "MOD")
        tbl.casts.write_file(tbl.class, buffer, #buffer, fs.handle)
        tbl.close(fs)
    end
    tbl.append = function(path, buffer)
        local fs = tbl.open(path, "a", "MOD")
        tbl.casts.write_file(tbl.class, buffer, #buffer, fs.handle)
        tbl.close(fs)
    end
    tbl.read = function(path)
        local fs = tbl.open(path, "r", "MOD")
        local size = tbl.get_size(fs)
        local output = ffi.new("char[?]", size + 1)
        tbl.casts.read_file(tbl.class, output, size, fs.handle)
        tbl.close(fs)
        return ffi.string(output)
    end
    tbl.rename = function(old_path, new_path, id)
        return tbl.casts.rename_file(tbl.full_class, old_path, new_path, id)
    end
    tbl.delete = function(file, id)
        tbl.casts.delete_file(tbl.full_class, file, id)
    end
    tbl.create_directory = function(path, id)
        tbl.casts.create_dir(tbl.full_class, path, id)
    end
    tbl.is_directory = function(path, id)
        return tbl.casts.is_dir(tbl.full_class, path, id)
    end
    tbl.find_next = function(handle)
        local file = tbl.casts.find_next(tbl.full_class, handle)
        if (file == 0) then
            return nil
        end
        return ffi.string(file)
    end
    tbl.find_is_directory = function(handle)
        return tbl.casts.find_is_dir(tbl.full_class, handle)
    end
    tbl.get_files = function()
        local file_handle = ffi.new("int[1]")
        remove_search_paths(call, "metaset_configs")
        add_search_path(call, "./csgo/metaset/", "metaset_configs")
        local file_names = {}
        local file = find_first_ex(call, "*", "metaset_configs", file_handle)
        while file ~= nil do
            local file_name = ffi.string(file)
            if find_is_dir(call, file_handle[0]) == false and file_name:find("[.]cfg") then
                table.insert(file_names, file_name)
            end
            file = find_next(call, file_handle[0])
        end
        find_close(call, file_handle[0])
        return file_names
    end
    return tbl
end)()

local clipboard = (function()
    local vgui_sys = 'VGUI_System010'
    local vgui2 = 'vgui2.dll'
    local function VTableBind(mod, face, n, type)
        local iface = memory.create_interface(mod, face) or error(face .. ": invalid interface")
        local instance = memory.get_vfunc(iface, n) or error(index .. ": invalid index")
        local success, typeof = pcall(ffi.typeof, type)
        if not success then
            error(typeof, 2)
        end
        local fnptr = ffi.cast(typeof, instance) or error(type .. ": invalid typecast")
        return function(...)
            return fnptr(tonumber(ffi.cast("void***", iface)), ...)
        end
    end
    local native_GetClipboardTextCount = VTableBind(vgui2, vgui_sys, 7, "int(__thiscall*)(void*)")
    local native_SetClipboardText = VTableBind(vgui2, vgui_sys, 9, "void(__thiscall*)(void*, const char*, int)")
    local native_GetClipboardText = VTableBind(vgui2, vgui_sys, 11, "int(__thiscall*)(void*, int, const char*, int)")
    return {
        get = function()
            local len = native_GetClipboardTextCount()
            if (len > 0) then
                local char_arr = ffi.typeof("char[?]")(len)
                native_GetClipboardText(0, char_arr, len)
                return ffi.string(char_arr, len - 1)
            end
        end,
        set = function(text)
            text = tostring(text)
            native_SetClipboardText(text, string.len(text))
        end
    }
end)()


local dragsystem = (function()
    local is_menu_visible = false
    local check_menu_events = function()
        is_menu_visible = menu.is_open()
    end
    callbacks.add(e_callbacks.PAINT, check_menu_events)
    local system = {}
    local screen_size = render.get_screen_size()
    system.list = {}
    system.windows = {}
    system.__index = system
    system.register = function(position, size, global_name, ins_function)
        local data = {
            size = size,
            position = vector(position[1]:get(), position[2]:get()),
            is_dragging = false,
            drag_position = {
                x = 0,
                y = 0
            },
            global_name = global_name,
            ins_function = ins_function,
            ui_callbacks = {
                x = position[1],
                y = position[2]
            }
        }
        table.insert(system.windows, data)
        return setmetatable(data, system)
    end
    function system:limit_positions()
        if self.position.x <= 0 then
            self.position.x = 0
        end
        if self.position.x + self.size.x >= screen_size.x - 1 then
            self.position.x = screen_size.x - self.size.x - 1
        end
        if self.position.y <= 0 then
            self.position.y = 0
        end
        if self.position.y + self.size.y >= screen_size.y - 1 then
            self.position.y = screen_size.y - self.size.y - 1
        end
    end
    function system:is_in_area(mouse_position)
        return mouse_position.x >= self.position.x and mouse_position.x <= self.position.x + self.size.x and mouse_position.y >= self.position.y and mouse_position.y <= self.position.y + self.size.y
    end
    function system:update(...)
        if is_menu_visible then
            local mouse_position = input.get_mouse_pos()
            local is_in_area = self:is_in_area(mouse_position)
            local list = system.list
            local is_key_pressed = input.is_key_held(e_keys.MOUSE_LEFT)
            if (is_in_area or self.is_dragging) and is_key_pressed and (list.target == "" or list.target == self.global_name) then
                list.target = self.global_name
                if not self.is_dragging then
                    self.is_dragging = true
                    self.drag_position = mouse_position - self.position
                else
                    self.position = mouse_position - self.drag_position
                    self:limit_positions()
                    self.ui_callbacks.x.ref:set(math.floor(self.position.x))
                    self.ui_callbacks.y.ref:set(math.floor(self.position.y))
                end
            elseif not is_key_pressed then
                list.target = ""
                self.is_dragging = false
                self.drag_position = {
                    x = 0,
                    y = 0
                }
            end
        end
        self.ins_function(self, ...)
    end
    system.on_config_load = function()
        for _, point in pairs(system.windows) do
            point.position = vector(point.ui_callbacks.x:get(), point.ui_callbacks.y:get())
        end
    end
    return system
end)()

local refs = {
    hide_shots = menu.find("aimbot", "general", "exploits", "hideshots", "enable")[2],
    double_tap = menu.find("aimbot", "general", "exploits", "doubletap", "enable")[2],
    dontusecharge = menu.find('aimbot', 'general', 'exploits', 'doubletap', 'dont use charge')[2],
    dormant = menu.find("aimbot", "general", "dormant aimbot", "enable")[2],
    ping = menu.find("aimbot", "general", "fake ping", "enable")[2],
    res = menu.find("aimbot", "general", "aimbot", "resolve antiaim"),
    ap = menu.find("aimbot", "general", "misc", "autopeek")[2],
    ax = menu.find("aimbot", "general", "exploits", "force prediction"),
    force_hitchance = menu.find("aimbot", "scout", "target overrides", "hitchance")[2],
    force_damage = menu.find("aimbot", "scout", "target overrides", "min. damage")[2],
    force_safe = menu.find("aimbot", "scout", "target overrides", "safepoint")[2],
    force_hitbox = menu.find("aimbot", "scout", "target overrides", "hitbox")[2],
    damage = menu.find("aimbot", "scout", "target overrides", "min. damage")[1],
    autostop = menu.find("aimbot", "scout", "accuracy", "autostop options"),
    rollres = menu.find("aimbot", "general", "aimbot", "body lean resolver", "enable")[2],

    slow_motion = menu.find("misc", "main", "movement", "slow walk", "enable")[2],
    fake_duck = menu.find("antiaim", "main", "general", "fakeduck")[2],

    airdef = menu.find("aimbot", "general", "exploits", "doubletap", "Anti-Prediction In Air"),

    pitch = menu.find("antiaim", "main", "angles", "pitch"),
    yawbase = menu.find("antiaim", "main", "angles", "yaw base"),
    yawadd = menu.find("antiaim", "main", "angles", "yaw add"),
    rotate = menu.find("antiaim", "main", "angles", "rotate"),
    rotaterange = menu.find("antiaim", "main", "angles", "rotate range"),
    rotatespeed = menu.find("antiaim", "main", "angles", "rotate speed"),
    jittermode = menu.find("antiaim", "main", "angles", "jitter mode"),
    jittertype = menu.find("antiaim", "main", "angles", "jitter type"),
    jitterrange = menu.find("antiaim", "main", "angles", "jitter add"),

    ladderaa = menu.find("antiaim", "main", "general", "ladder antiaim"),
    fastladder = menu.find("antiaim", "main", "general", "fast ladder move"),
    antibackstab = menu.find("antiaim", "main", "general", "anti knife"),
    legslide = menu.find("antiaim", "main", "general", "leg slide"),

    overridemove = menu.find("antiaim", "main", "desync", "override stand#move"),
    overridemovesw = menu.find("antiaim", "main", "desync", "override stand#slow walk"),
    desyncside = menu.find("antiaim", "main", "desync", "stand", "side"),
    desyncdefside = menu.find("antiaim", "main", "desync", "stand", "default side"),
    leftamount = menu.find("antiaim", "main", "desync", "left amount"),
    rightamount = menu.find("antiaim", "main", "desync", "right amount"),
    antibruteforce = menu.find("antiaim", "main", "desync", "anti bruteforce"),
    desynconshot = menu.find("antiaim", "main", "desync", "on shot"),
    fake_lag_value = menu.find("antiaim", "main", "fakelag", "amount"),

    bodylean = menu.find("antiaim", "main", "angles", "body lean"),
    bodyleanval = menu.find("antiaim", "main", "angles", "body lean value"),
    movebodylean = menu.find("antiaim", "main", "angles", "moving body lean"),

    enableroll = menu.find("antiaim", "main", "extended angles", "enable")[2],
    moveroll = menu.find("antiaim", "main", "extended angles", "enable while moving"),
    rollpitch = menu.find("antiaim", "main", "extended angles", "pitch"),
    rolltype = menu.find("antiaim", "main", "extended angles", "type"),
    rolloffset = menu.find("antiaim", "main", "extended angles", "offset"),

    left = menu.find("antiaim", "main", "manual", "left")[2],
    right = menu.find("antiaim", "main", "manual", "right")[2],
    back = menu.find("antiaim", "main", "manual", "back")[2],
    freestand = menu.find("antiaim", "main", "auto direction", "enable")[2],
    fsstate = menu.find("antiaim", "main", "auto direction", "states"),

    nadehelper = menu.find("misc", "nade helper", "general", "autothrow")[2],

    transparency = menu.find("visuals", "view", "thirdperson", "transparency when scoped"),
    health = menu.find("visuals", "esp", "players", "health#enemy")[1],
    localchams = menu.find("visuals", "esp", "models", "enable#local"),
    localstyle = menu.find("visuals", "esp", "models", "style#local"),
    localcolor = menu.find("visuals", "esp", "models", "color#local")[2],

    accentcol = menu.find("misc", "main", "personalization", "accent color")[2],

    keybinds = menu.find("misc", "main", "indicators", "keybinds#keybinds"),
    always = menu.find("misc", "main", "indicators", "show always-on keybinds#keybinds")
}

ffi.cdef [[
    // 3d vector struct
    typedef struct
    {
        float x;
        float y;
        float z;
    } Vector_3;

    // animstate structs; used to override animations
    typedef struct
    {
        char    pad0[0x60]; // 0x00
        void* pEntity; // 0x60
        void* pActiveWeapon; // 0x64
        void* pLastActiveWeapon; // 0x68
        float        flLastUpdateTime; // 0x6C
        int            iLastUpdateFrame; // 0x70
        float        flLastUpdateIncrement; // 0x74
        float        flEyeYaw; // 0x78
        float        flEyePitch; // 0x7C
        float        flGoalFeetYaw; // 0x80
        float        flLastFeetYaw; // 0x84
        float        flMoveYaw; // 0x88
        float        flLastMoveYaw; // 0x8C // changes when moving/jumping/hitting ground
        float        flLeanAmount; // 0x90
        char    pad1[0x4]; // 0x94
        float        flFeetCycle; // 0x98 0 to 1
        float        flMoveWeight; // 0x9C 0 to 1
        float        flMoveWeightSmoothed; // 0xA0
        float        flDuckAmount; // 0xA4
        float        flHitGroundCycle; // 0xA8
        float        flRecrouchWeight; // 0xAC
        Vector_3        vecOrigin; // 0xB0
        Vector_3        vecLastOrigin;// 0xBC
        Vector_3        vecVelocity; // 0xC8
        Vector_3        vecVelocityNormalized; // 0xD4
        Vector_3        vecVelocityNormalizedNonZero; // 0xE0
        float        flVelocityLenght2D; // 0xEC
        float        flJumpFallVelocity; // 0xF0
        float        flSpeedNormalized; // 0xF4 // clamped velocity from 0 to 1
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float        flRunningSpeed; // 0xF8
        float        flDuckingSpeed; // 0xFC
        float        flDurationMoving; // 0x100
        float        flDurationStill; // 0x104
        bool        bOnGround; // 0x108
        bool        bHitGroundAnimation; // 0x109
        char    pad2[0x2]; // 0x10A
        float        flNextLowerBodyYawUpdateTime; // 0x10C
        float        flDurationInAir; // 0x110
        float        flLeftGroundHeight; // 0x114
        float m_flStopToFullRunningFraction; //0x116
        float        flHitGroundWeight; // 0x118 // from 0 to 1, is 1 when standing
        float        flWalkToRunTransition; // 0x11C // from 0 to 1, doesnt change when walking or crouching, only running
        char    pad3[0x4]; // 0x120
        float        flAffectedFraction; // 0x124 // affected while jumping and running, or when just jumping, 0 to 1
        char    pad4[0x208]; // 0x128
        float        flMinBodyYaw; // 0x330
        float        flMaxBodyYaw; // 0x334
        float        flMinPitch; //0x338
        float        flMaxPitch; // 0x33C
        int            iAnimsetVersion; // 0x340
    } CPlayer_Animation_State;


    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef uintptr_t (__thiscall* GetClientEntityHandle_4242425_t)(void*, uintptr_t);
]]

local originalprint = function(...)
    print(...)
end

local vector = function(one, two, three)
    if not three then
        return vec2_t(one, two)
    elseif three then
        return vec3_t(one, two, three)
    end
end

local color = function(...)
    return color_t(...)
end

local screen = {
    size = render.get_screen_size(),
    scale = {
        x = render.get_screen_size().x / 1920,
        x = render.get_screen_size().y / 1080
    }
}

-- empty table definitions
local log = {
    hurttick = 0,
    aim = {}
}
local resolver = {
    memory = {}
}
local builder = {
    misses = 0
}
local handles = {}
local aimbot_loggies = {}
local lastResolved = {}
local login = {}
local entity = {}
local events = {}
local toss = {}
local correctiondb = {}
local hitrate = {
    shot = 0,
    hit = 0,
    miss = 0
}
local avoid_collisions = {}
local knife = {}
local binds = {}
local backup = {}
local clantag = {
    tag = {"", "m", "me", "met", "meta", "metas", "metase", "metaset", "metaset.", "metaset.c", "metaset.cc", "metaset.cc", "metaset.cc", "metaset.c", "metaset.", "metaset", "metase", "metas", "meta", "met", "me", "m", ""}
}

local screen = {
    size = render.get_screen_size()
}

local fonts = {
    default = render.get_default_font(),
    pixel = render.create_font('Smallest Pixel-7', 10, 300, e_font_flags.OUTLINE),
    log = render.create_font("Tahoma Bold", 11, 500, e_font_flags.DROPSHADOW),
    tahoma = render.create_font('Verdana', 12, 0),
    tahomabold = render.create_font("Tahoma Bold", 12, 500, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW),
    tahoma = render.create_font("Tahoma", 11, 500, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW),
    verdana = render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW),
    verdana_b = render.create_font("Verdana", 11, 600, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW),
    dollars = render.create_font("Calibri Bold", 24, 670, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW),
    verdanabold = render.create_font("Verdana Bold", 12, 600, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW),
    lucida = render.create_font("lucida console", 10, 400, e_font_flags.DROPSHADOW)
}

local loadfonts = function()
end

local origtext = render.text
render.text = function(font, string, position, color, center)
    if not font then
        font = fonts.default
    end
    origtext(font, string, position, color, center)
end

local tools = {
    animation = {
        database = {},
        speed = 0.07,
        lerp = function(start, end_pos, time)
            local val = start + (end_pos - start) * (globals.frame_time() * time)
            return val
        end,
        new = function(self, name, new_value, speed, init)
            speed = speed or self.speed

            if self.database[name] == nil then
                self.database[name] = (init and init) or 0
            end

            self.database[name] = self.lerp(self.database[name], new_value, speed)
            return self.database[name]
        end
    },
    lerp = function(start, end_pos, time)
        if start == end_pos then
            return end_pos
        end

        local frametime = globals.frame_time() * 170
        time = time * frametime

        local val = start + (end_pos - start) * time

        if (math.abs(val - end_pos) < 0.01) then
            return end_pos
        end

        return val
    end,
    randomFloat = function(lower, greater)
        return lower + math.random() * (greater - lower);
    end,
    randomString = function(length)
        math.randomseed(globals.real_time())
        local res = ""
        for i = 1, length do
            res = res .. string.char(math.random(97, 122))
        end
        return res
    end,
    hitgroup_str = {
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
    },
    key_modes = {
        [0] = "toggled",
        "holding",
        "holding off",
        "always",
        "always off"
    },
    active_weapon = function()
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
    end,
    get_dmg = function(self)
        local dmg_ovr = menu.find("aimbot", self.active_weapon(), "target overrides", "min. damage")[1]
        local dmg_ovr_key = menu.find("aimbot", self.active_weapon(), "target overrides", "min. damage")[2]
        local norm_dmg = menu.find("aimbot", self.active_weapon(), "targeting", "min. damage")

        return dmg_ovr_key:get() and dmg_ovr:get() or norm_dmg:get()
    end,
    screensize = render.get_screen_size(),
    closest_point_on_ray = function(ray_from, ray_to, desired_point)
        local to = desired_point - ray_from
        local direction = ray_to - ray_from
        local ray_length = #direction
        direction.x = direction.x / ray_length
        direction.y = direction.y / ray_length
        direction.z = direction.z / ray_length
        local direction_along = direction.x * to.x + direction.y * to.y + direction.z * to.z
        if direction_along < 0 then
            return ray_from
        end
        if direction_along > ray_length then
            return ray_to
        end
        return vec3_t(ray_from.x + direction.x * direction_along, ray_from.y + direction.y * direction_along, ray_from.z + direction.z * direction_along)
    end,
    render_glow = function(pos, size, round, color, glow_size)
        for radius = 4, math.floor(glow_size) do
            local radius_glow = radius / 2
            render.rect(vec2_t(pos.x - radius_glow, pos.y - radius_glow), vec2_t(size.x + radius_glow * 2, size.y + radius_glow * 2), color_t(color.r, color.g, color.b, math.floor(color.a / glow_size * (glow_size - radius))), round)
        end
    end,
    dump = function(self, o)
        if type(o) == 'table' then
            local s = '{ '
            for k, v in pairs(o) do
                if type(k) ~= 'number' then
                    k = '"' .. k .. '"'
                end
                s = s .. '[' .. k .. '] = ' .. self:dump(v) .. ','
            end
            return s .. '} '
        else
            return tostring(o)
        end
    end,
    animated_text = function(font, text, color2, position, speed)
        -- if speed == 0 then speed = 1 else speed = speed end
        font = font and font or fonts.default
        local data, totalWidth = {}, 0
        local len, two_pi = #text, math.pi * 1.5
        local textOffset = position
        local clr1 = speed == 0 and color_t(255, 255, 255, 255) or color_t(0, 0, 0, 155)

        for idx = 1, len do
            local modifier = two_pi / len * idx
            local char = text:sub(idx, idx)
            local charWidth = render.get_text_size(font, char).x
            data[idx] = {totalWidth, char, modifier}
            totalWidth = totalWidth + charWidth
        end

        totalWidth = totalWidth * 0.5

        return function()
            local time = -globals.cur_time() * math.pi * speed
            local headerOffset = textOffset - vec2_t(totalWidth, 0)

            for _, char in pairs(data) do
                local charPosition = headerOffset + vec2_t(char[1], 0)
                local fadeValue = math.sin(time + char[3]) * 0.5 + 0.5
                local color = clr1:fade(color2, fadeValue)
                render.text(font, char[2], charPosition, color)
            end
        end
    end
}

local defensive = {
    db = {},
    is_active = function(self, player, safe, mode)
        if not mode then
            mode = false
        end

        local idx = player:get_index()
        local tickcount = globals.tick_count()
        local sim_time = client.time_to_ticks(player:get_prop("m_flSimulationTime"))

        self.db[idx] = self.db[idx] and self.db[idx] or {
            last_sim_time = 0,
            defensive_until = 0
        }

        if self.db[idx].last_sim_time == 0 then
            self.db[idx].last_sim_time = sim_time
            return false
        end

        local sim_diff = sim_time - self.db[idx].last_sim_time

        if sim_diff < 0 then
            self.db[idx].defensive_until = tickcount + math.abs(sim_diff)

            if safe then
                self.db[idx].defensive_until = self.db[idx].defensive_until - client.time_to_ticks(engine.get_latency())
            end
        end

        self.db[idx].last_sim_time = sim_time

        local ret = {
            tick = self.db[idx].defensive_until,
            active = self.db[idx].defensive_until > tickcount
        }

        return mode and ret or self.db[idx].defensive_until > tickcount
    end,
    trigger = function()
        if refs.double_tap:get() and (exploits.get_charge() == exploits.get_max_charge()) then
            exploits.force_anti_exploit_shift()
        end
    end
}

local damage = {
    scale = {
        stomach = 1.25,
        chest = 1,
        head = 4
    },
    calculate = function(self, player, hitbox)
        local lplr = entity_list.get_local_player()
        if not lplr then
            return 0
        end
        local weaponidk = lplr:get_active_weapon()
        if not weaponidk then
            return 0
        end
        local weapon = lplr:get_active_weapon():get_weapon_data()
        if not weapon then
            return 0
        end
        local local_origin = lplr:get_prop("m_vecAbsOrigin")
        local distance = local_origin:dist(player:get_prop("m_vecAbsOrigin"))
        local weapon_adjust = weapon.damage
        local dmg_after_range = (weapon_adjust * math.pow(weapon.range_modifier, (distance * 0.002)))
        local armor = player:get_prop("m_ArmorValue")
        local newdmg = dmg_after_range * (weapon.armor_ratio * 0.5)
        if dmg_after_range - (dmg_after_range * (weapon.armor_ratio * 0.5)) * 0.5 > armor then
            newdmg = dmg_after_range - (armor / 0.5)
        end
        local enemy_health = player:get_prop("m_iHealth")
        -- local newdmg_indi = newdmg * 1.25

        return newdmg * self.scale[hitbox]
    end
}

local espfonts = {"default", "pixel", "verdana", "tahoma", "tahoma bold", "skeet"}

local groups = {
    nav = eui.create("Home", 1),
    -- login = eui.create("Login", 2),
    configs = eui.create("Configs", 2),
    res = eui.create("Resolver", 2),
    rage = eui.create("Rage", 3),
    tick = eui.create("Tickbase", 3),
    antiaim = eui.create("Global", 2),
    yaw = eui.create("Yaw", 2),
    jitter = eui.create("Jitter", 2),
    desync = eui.create("Desync", 2),
    features = eui.create("Features", 3),
    breakers = eui.create("Animation", 3),
    defensive = eui.create("Defensive", 1),
    visuals = eui.create("Visuals", 2),
    indicators = eui.create("Indicators", 3),
    misc = eui.create("Misc", 3),
    settings = eui.create("Settings", 3),
    loader = eui.create("Loader", 3),
    helpers = eui.create("Helpers", 2),
    movement = eui.create("Movement", 2)
}

local states = {"global", "stand", "move", "slow motion", "duck", "duck move", "air", "air duck", "fakelag", "manual", "freestand"}
local shortstates = {"g.", "s.", "m.", "sm.", "d.", "dm.", "a.", "ad.", "f.", "mn.", "fr."}

local configs = {
    dir = "metaset/",
    default_dir = "metaset/default.cfg",
    default_config = "eyJDb25maWdzIjpbXSwiTG9hZGVyIjpbXSwiSml0dGVyIjpbWyJzLiBNb2RpZmllciBNb2RlIiwxXSxbIm0uIE1vZGlmaWVyIFJhbmRvbWl6YXRpb24iLDEwXSxbImZyLiBNb2RpZmllciBEZWdyZWUiLDBdLFsiZy4gTW9kaWZpZXIgTW9kZSIsM10sWyJzbS4gTW9kaWZpZXIgUmFuZG9taXphdGlvbiIsMTVdLFsiYWQuIE1vZGlmaWVyIFJhbmRvbWl6YXRpb24iLDBdLFsiZi4gTW9kaWZpZXIgTW9kZSIsMV0sWyJhLiBNb2RpZmllciBEZWdyZWUiLC00XSxbImQuIE1vZGlmaWVyIERlZ3JlZSIsLTE4XSxbImcuIE1vZGlmaWVyIERlZ3JlZSIsLTI5XSxbIm0uIE1vZGlmaWVyIE1vZGUiLDFdLFsiZnIuIE1vZGlmaWVyIE1vZGUiLDFdLFsibS4gTW9kaWZpZXIgRGVncmVlIiwtMTldLFsiZi4gTW9kaWZpZXIgUmFuZG9taXphdGlvbiIsMF0sWyJkLiBNb2RpZmllciBSYW5kb21pemF0aW9uIiwwXSxbImZyLiBNb2RpZmllciBSYW5kb21pemF0aW9uIiwwXSxbIm1uLiBNb2RpZmllciBSYW5kb21pemF0aW9uIiwwXSxbInNtLiBNb2RpZmllciBEZWdyZWUiLC0yOV0sWyJtbi4gTW9kaWZpZXIgRGVncmVlIiwwXSxbImRtLiBNb2RpZmllciBEZWdyZWUiLDBdLFsiZG0uIE1vZGlmaWVyIE1vZGUiLDFdLFsiYS4gTW9kaWZpZXIgUmFuZG9taXphdGlvbiIsMF0sWyJnLiBNb2RpZmllciBSYW5kb21pemF0aW9uIiwzXSxbImFkLiBNb2RpZmllciBNb2RlIiwxXSxbImQuIE1vZGlmaWVyIE1vZGUiLDNdLFsiZG0uIE1vZGlmaWVyIFJhbmRvbWl6YXRpb24iLDBdLFsicy4gTW9kaWZpZXIgRGVncmVlIiwwXSxbImFkLiBNb2RpZmllciBEZWdyZWUiLC0xN10sWyJhLiBNb2RpZmllciBNb2RlIiwzXSxbInMuIE1vZGlmaWVyIFJhbmRvbWl6YXRpb24iLDBdLFsic20uIE1vZGlmaWVyIE1vZGUiLDNdLFsiZi4gTW9kaWZpZXIgRGVncmVlIiwwXSxbIm1uLiBNb2RpZmllciBNb2RlIiwxXV0sIlRpY2tiYXNlIjpbWyJDdXN0b20gSWRlYWwgVGljayIsdHJ1ZV0sWyJLbmlmZWJvdCBIZWxwZXIiLHRydWVdLFsiRmFzdCBXZWFwb24gU3dpdGNoIix0cnVlXV0sIlJlc29sdmVyIjpbWyJFbmFibGUgQ3VzdG9tIFJlc29sdmVyIix0cnVlXSxbIkN1c3RvbSBEZXN5bmMiLDYwXSxbIk1ldGhvZCIsMV0sWyJEZWJ1ZyIsZmFsc2VdXSwiQW5pbWF0aW9uIjpbWyJMZWFuIEFtb3VudCIsMTAwXSxbIkV4dHJhIixbWyJsYW5kIHBpdGNoIixmYWxzZV0sWyJsZWFuIix0cnVlXV1dLFsiQWlyIiwxXSxbIkdyb3VuZCBCcmVha2VyIiw0XV0sIkluZGljYXRvcnMiOltbIkRlZmVuc2l2ZSBJbmRpY2F0b3IiLGZhbHNlXSxbIlZlbG9jaXR5IEluZGljYXRvciIsdHJ1ZV0sWyJBbmltYXRlZCIsdHJ1ZV0sWyJFbGVtZW50cyIsW1siaW5mbyIsdHJ1ZV0sWyJrZXliaW5kcyIsdHJ1ZV1dXSxbIkRlc3luYyBCYXIiLDFdLFsiQ3Jvc3NoYWlyIEluZGljYXRvcnMiLDFdLFsiSG90a2V5cyIsW1siZG91YmxldGFwIix0cnVlXSxbImhpZGVzaG90cyIsdHJ1ZV0sWyJkYW1hZ2UiLHRydWVdLFsiaGl0Y2hhbmNlIix0cnVlXSxbImZyZWVzdGFuZCIsdHJ1ZV0sWyJmb3JjZSBib2R5Iix0cnVlXSxbImZvcmNlIHNhZmUiLHRydWVdLFsicGluZyIsZmFsc2VdXV0sWyJDcm9zc2hhaXIgRGFtYWdlIix0cnVlXSxbIk1pbmRhbWFnZSBPbmx5IixmYWxzZV1dLCJHbG9iYWwiOltbIlBpdGNoIiwyXSxbIkJhc2UiLDJdXSwiRGVmZW5zaXZlIjpbWyJzbS4gWWF3IFZhbHVlIiwtODhdLFsiZC4gRGVmZW5zaXZlIFlhdyIsNV0sWyJmLiBEZWZlbnNpdmUgWWF3IiwxXSxbIm0uIERlZmVuc2l2ZSBZYXciLDZdLFsic20uIFBpdGNoIFZhbHVlIDIiLDBdLFsiYS4gRGVmZW5zaXZlIiw0XSxbImFkLiBEZWZlbnNpdmUiLDNdLFsiZG0uIFBpdGNoIFZhbHVlIiwwXSxbImZyLiBEZWZlbnNpdmUgWWF3IiwxXSxbImQuIERlZmVuc2l2ZSIsNF0sWyJnLiBEZWZlbnNpdmUiLDNdLFsiZG0uIERlZmVuc2l2ZSBZYXciLDNdLFsibW4uIFBpdGNoIFZhbHVlIiwwXSxbIm0uIERlZmVuc2l2ZSIsM10sWyJhZC4gWWF3IFZhbHVlIiw1Ml0sWyJmci4gRGVmZW5zaXZlIiwyXSxbImEuIFBpdGNoIFZhbHVlIiwwXSxbIm1uLiBEZWZlbnNpdmUgWWF3IiwxXSxbIm0uIERlZmVuc2l2ZSBQaXRjaCIsM10sWyJmci4gUGl0Y2ggVmFsdWUiLDBdLFsiZG0uIFlhdyBWYWx1ZSIsOTBdLFsibW4uIFlhdyBWYWx1ZSIsMF0sWyJzbS4gRGVmZW5zaXZlIiw0XSxbImQuIFlhdyBWYWx1ZSIsNDhdLFsiYS4gWWF3IFZhbHVlIiwxODBdLFsiZC4gRGVmZW5zaXZlIFBpdGNoIiw0XSxbImEuIERlZmVuc2l2ZSBQaXRjaCIsNF0sWyJzbS4gUGl0Y2ggVmFsdWUiLDBdLFsiZy4gWWF3IFZhbHVlIiwwXSxbInMuIFBpdGNoIFZhbHVlIiwwXSxbImFkLiBQaXRjaCBWYWx1ZSIsMF0sWyJtLiBZYXcgVmFsdWUiLDYxXSxbImcuIERlZmVuc2l2ZSBQaXRjaCIsMV0sWyJzLiBEZWZlbnNpdmUgWWF3Iiw1XSxbInMuIFlhdyBWYWx1ZSIsMjldLFsiZy4gUGl0Y2ggVmFsdWUiLDBdLFsiZnIuIFBpdGNoIFZhbHVlIDIiLDBdLFsiZC4gUGl0Y2ggVmFsdWUiLC02MF0sWyJtLiBQaXRjaCBWYWx1ZSIsMF0sWyJzLiBQaXRjaCBWYWx1ZSAyIiwwXSxbImRtLiBEZWZlbnNpdmUgUGl0Y2giLDVdLFsiZG0uIERlZmVuc2l2ZSIsNF0sWyJkbS4gUGl0Y2ggVmFsdWUgMiIsMF0sWyJmLiBZYXcgVmFsdWUiLDBdLFsiYWQuIERlZmVuc2l2ZSBQaXRjaCIsNV0sWyJzbS4gRGVmZW5zaXZlIFBpdGNoIiwzXSxbImYuIERlZmVuc2l2ZSIsMV0sWyJhZC4gRGVmZW5zaXZlIFlhdyIsNV0sWyJzbS4gRGVmZW5zaXZlIFlhdyIsM10sWyJtbi4gRGVmZW5zaXZlIiwxXSxbImcuIFBpdGNoIFZhbHVlIDIiLDBdLFsiZnIuIERlZmVuc2l2ZSBQaXRjaCIsMV0sWyJhLiBQaXRjaCBWYWx1ZSAyIiwwXSxbIm1uLiBEZWZlbnNpdmUgUGl0Y2giLDFdLFsiZi4gUGl0Y2ggVmFsdWUgMiIsMF0sWyJtLiBQaXRjaCBWYWx1ZSAyIiwwXSxbImQuIFBpdGNoIFZhbHVlIDIiLDBdLFsiYWQuIFBpdGNoIFZhbHVlIDIiLDBdLFsiYS4gRGVmZW5zaXZlIFlhdyIsMV0sWyJtbi4gUGl0Y2ggVmFsdWUgMiIsMF0sWyJmLiBEZWZlbnNpdmUgUGl0Y2giLDFdLFsiZi4gUGl0Y2ggVmFsdWUiLDBdLFsicy4gRGVmZW5zaXZlIFBpdGNoIiwzXSxbInMuIERlZmVuc2l2ZSIsM10sWyJnLiBEZWZlbnNpdmUgWWF3IiwxXSxbImZyLiBZYXcgVmFsdWUiLDU0XV0sIkhvbWUiOltbImZ1bm55IGhpZGRlbiBzbGlkZXIgdGVlIGhlZSA6MyIsMV0sWyIybmQgQ29sb3IiLDE5MSwxOTEsMTkxLDI1NV0sWyJPdmVycmlkZSBnbG9iYWwiLHRydWVdLFsiQWNjZW50IENvbG9yIiwyMjAsMTg2LDE1MSwyNTVdLFsiT3ZlcnJpZGUgc2xvdyBtb3Rpb24iLHRydWVdLFsiT3ZlcnJpZGUgYWlyIGR1Y2siLHRydWVdLFsiT3ZlcnJpZGUgZHVjayIsdHJ1ZV0sWyJPdmVycmlkZSBmYWtlbGFnIixmYWxzZV0sWyJPdmVycmlkZSBkdWNrIG1vdmUiLHRydWVdLFsiT3ZlcnJpZGUgZnJlZXN0YW5kIix0cnVlXSxbIk92ZXJyaWRlIGFpciIsdHJ1ZV0sWyJPdmVycmlkZSBtYW51YWwiLGZhbHNlXSxbIkVuYWJsZSBCdWlsZGVyIix0cnVlXSxbIk92ZXJyaWRlIG1vdmUiLHRydWVdLFsiT3ZlcnJpZGUgc3RhbmQiLHRydWVdLFsiMXN0IENvbG9yIiwxOTEsMTkxLDE5MSwyNTVdLFsiQ29uZGl0aW9uIiw4XV0sIlZpc3VhbHMiOltbIkhpdG1hcmtlciBDb2xvciIsODgsMjU1LDIwOSwyNTVdLFsiQ3VzdG9tIEVTUCBGb250IiwzXSxbIkJ1bGxldCBUcmFjZXJzIixmYWxzZV0sWyJIaXRtYXJrZXJzIiwzXSxbIkN1c3RvbSBIZWFsdGgiLDJdLFsiQWNjZW50IENvbG9yIiwxMjAsMTIwLDEyMCwyNTVdLFsiNDAwJCBpbmRpY2F0b3JzIixbWyJkb3VibGV0YXAiLHRydWVdLFsiaGlkZXNob3RzIix0cnVlXSxbImRhbWFnZSIsdHJ1ZV0sWyJoaXRjaGFuY2UiLHRydWVdLFsiZnJlZXN0YW5kIix0cnVlXSxbImZvcmNlIHNhZmUiLHRydWVdLFsicGluZyIsZmFsc2VdLFsiZmFrZSBkdWNrIix0cnVlXSxbImhpdHJhdGUiLGZhbHNlXV1dLFsiUmVzZXQgaGl0cmF0ZSIsW1sibmV3IHNlcnZlciIsZmFsc2VdLFsibmV3IGdhbWUiLGZhbHNlXV1dLFsiU29sdXMgVUkiLHRydWVdXSwiRmVhdHVyZXMiOltbIkFudGkgYmFja3N0YWIiLHRydWVdLFsiUmFuZG9taXphdGlvbiIsW1sibm8gZW5lbWllcyBhbGl2ZSIsZmFsc2VdLFsid2FybXVwIixmYWxzZV1dXSxbIlNhZmUgS25pZmUiLHRydWVdLFsiRmFrZWxhZyBBdm9pZCBPbnNob3QiLHRydWVdLFsiQ3JvdWNoIENvcnJlY3Rpb24iLFtbInlhdyIsdHJ1ZV1dXV0sIllhdyI6W1siZy4gWWF3IG1vZGUiLDFdLFsiZG0uIFlhdyBtb2RlIiwzXSxbImQuIFlhdyBtb2RlIiwzXSxbImRtLiBSaWdodCIsMzRdLFsiYWQuIERlbGF5IEZsdWN0dWF0aW9uIiwwXSxbImEuIFJpZ2h0Iiw2XSxbInNtLiBEZWxheSBGbHVjdHVhdGlvbiIsMF0sWyJtLiBSaWdodCIsMzBdLFsic20uIExlZnQiLDddLFsiZnIuIFlhdyBtb2RlIiwxXSxbInMuIFlhdyIsMF0sWyJmLiBMZWZ0IFJhbmRvbWl6YXRpb24iLDBdLFsiZG0uIERlbGF5IEZsdWN0dWF0aW9uIiwwXSxbImFkLiBSaWdodCIsNDBdLFsic20uIFlhdyIsMF0sWyJmci4gUmlnaHQgUmFuZG9taXphdGlvbiIsMF0sWyJzbS4gWWF3IG1vZGUiLDJdLFsiYWQuIFJpZ2h0IFJhbmRvbWl6YXRpb24iLDBdLFsic20uIFJpZ2h0IFJhbmRvbWl6YXRpb24iLDBdLFsiZnIuIFlhdyIsMF0sWyJkLiBEZWxheSIsMl0sWyJnLiBEZWxheSIsMl0sWyJmLiBEZWxheSIsMl0sWyJzLiBEZWxheSBGbHVjdHVhdGlvbiIsMF0sWyJhZC4gTGVmdCBSYW5kb21pemF0aW9uIiwwXSxbImEuIFlhdyIsMF0sWyJnLiBSaWdodCIsMF0sWyJzLiBMZWZ0IiwtMjNdLFsiZG0uIExlZnQiLC0yN10sWyJmLiBSaWdodCIsMF0sWyJhZC4gTGVmdCIsLTI0XSxbImQuIExlZnQiLC05XSxbInMuIExlZnQgUmFuZG9taXphdGlvbiIsMF0sWyJkbS4gRGVsYXkiLDJdLFsiYWQuIFlhdyBtb2RlIiwzXSxbImEuIERlbGF5IiwyXSxbIm0uIExlZnQgUmFuZG9taXphdGlvbiIsMF0sWyJhZC4gRGVsYXkiLDhdLFsibS4gRGVsYXkiLDJdLFsicy4gWWF3IG1vZGUiLDNdLFsic20uIERlbGF5IiwyXSxbIm0uIExlZnQiLC0yNV0sWyJnLiBEZWxheSBGbHVjdHVhdGlvbiIsMF0sWyJtLiBZYXcgbW9kZSIsM10sWyJzLiBEZWxheSIsMl0sWyJkbS4gUmlnaHQgUmFuZG9taXphdGlvbiIsMl0sWyJmLiBEZWxheSBGbHVjdHVhdGlvbiIsMF0sWyJhLiBEZWxheSBGbHVjdHVhdGlvbiIsMF0sWyJmci4gTGVmdCIsMF0sWyJtLiBEZWxheSBGbHVjdHVhdGlvbiIsMF0sWyJmci4gRGVsYXkgRmx1Y3R1YXRpb24iLDBdLFsibW4uIFlhdyIsMF0sWyJkLiBSaWdodCBSYW5kb21pemF0aW9uIiwwXSxbImRtLiBZYXciLDBdLFsibW4uIExlZnQgUmFuZG9taXphdGlvbiIsMF0sWyJhLiBSaWdodCBSYW5kb21pemF0aW9uIiwzXSxbImZyLiBEZWxheSIsMl0sWyJhZC4gWWF3IiwwXSxbImYuIFJpZ2h0IFJhbmRvbWl6YXRpb24iLDBdLFsiZy4gWWF3IiwwXSxbImZyLiBSaWdodCIsMF0sWyJtbi4gRGVsYXkgRmx1Y3R1YXRpb24iLDBdLFsibW4uIERlbGF5IiwyXSxbInMuIFJpZ2h0Iiw0MV0sWyJtbi4gUmlnaHQgUmFuZG9taXphdGlvbiIsMF0sWyJtbi4gUmlnaHQiLDBdLFsibW4uIExlZnQiLDBdLFsibS4gUmlnaHQgUmFuZG9taXphdGlvbiIsMF0sWyJtbi4gWWF3IG1vZGUiLDFdLFsic20uIFJpZ2h0IiwxMV0sWyJmLiBMZWZ0IiwwXSxbImYuIFlhdyIsMF0sWyJzbS4gTGVmdCBSYW5kb21pemF0aW9uIiwwXSxbImYuIFlhdyBtb2RlIiwxXSxbImEuIExlZnQgUmFuZG9taXphdGlvbiIsLTNdLFsiZC4gRGVsYXkgRmx1Y3R1YXRpb24iLDBdLFsiZy4gTGVmdCIsMF0sWyJnLiBMZWZ0IFJhbmRvbWl6YXRpb24iLDBdLFsiYS4gWWF3IG1vZGUiLDNdLFsiZC4gWWF3IiwwXSxbImRtLiBMZWZ0IFJhbmRvbWl6YXRpb24iLC0xXSxbImcuIFJpZ2h0IFJhbmRvbWl6YXRpb24iLDBdLFsiZC4gTGVmdCBSYW5kb21pemF0aW9uIiwwXSxbInMuIFJpZ2h0IFJhbmRvbWl6YXRpb24iLDBdLFsibS4gWWF3IiwwXSxbImQuIFJpZ2h0IiwxNl0sWyJhLiBMZWZ0Iiw0XSxbImZyLiBMZWZ0IFJhbmRvbWl6YXRpb24iLDBdXSwiU2V0dGluZ3MiOltbInNvbHVzIHkiLDQ0OV0sWyJzb2x1cyB4Iiw0NDhdXSwiTWlzYyI6W1siRXh0cmEgaW5mbyIsW1sic2FmZSIsdHJ1ZV0sWyJvbnNob3QiLHRydWVdLFsiYW5nbGUiLHRydWVdLFsiY29ycmVjdGlvbiIsdHJ1ZV1dXSxbIkNsYW50YWciLHRydWVdLFsiRXZlbnRzIixbWyJoaXQiLHRydWVdLFsibWlzcyIsdHJ1ZV0sWyJkZWZlbnNpdmUiLHRydWVdXV0sWyJMb2dzIixbWyJjb25zb2xlIix0cnVlXSxbImNyb3NzaGFpciIsZmFsc2VdLFsic2NyZWVuIix0cnVlXV1dXSwiTW92ZW1lbnQiOltbIkZhc3QgTGFkZGVyIixbWyJ1cCIsdHJ1ZV0sWyJkb3duIix0cnVlXV1dLFsibWluLiBWZWxvY2l0eSIsMzldLFsibWF4LiBEaXN0YW5jZSIsNV0sWyJBdm9pZCBDb2xsaXNpb25zIixmYWxzZV0sWyJTdXBlciBUb3NzIiwxXSxbIk5vIEZhbGwgRGFtYWdlIix0cnVlXV0sIlJhZ2UiOltbIkFjY3VyYWN5IEJvb3N0IixmYWxzZV0sWyJDdXN0b20gQWlyc3RvcCIsM10sWyJTYWZlcG9pbnQgRGVmZW5zaXZlIixmYWxzZV0sWyJIaXRjaGFuY2UiLDc1XSxbIk11bHRpLXBvaW50IENvcnJlY3Rpb24iLGZhbHNlXSxbIkJvb3N0IEFtb3VudCIsNTRdXSwiRGVzeW5jIjpbWyJzLiBEZXN5bmMiLDNdLFsibS4gRmFrZSByaWdodCIsNDNdLFsiZG0uIEZha2UgbGVmdCIsNjBdLFsibS4gRGVzeW5jIiwzXSxbImEuIEZha2UgbGVmdCIsMjRdLFsiZC4gRmFrZSBsZWZ0Iiw2MF0sWyJmLiBGYWtlIGxlZnQiLDBdLFsic20uIEZha2UgbGVmdCIsNjBdLFsiYWQuIERlc3luYyIsM10sWyJtLiBGYWtlIGxlZnQiLDUzXSxbImRtLiBGYWtlIHJpZ2h0Iiw2MF0sWyJmLiBGYWtlIHJpZ2h0IiwwXSxbInMuIEZha2UgbGVmdCIsNjBdLFsiZy4gRmFrZSBsZWZ0Iiw1OF0sWyJkLiBGYWtlIHJpZ2h0Iiw2MF0sWyJzLiBGYWtlIHJpZ2h0Iiw2MF0sWyJtbi4gRmFrZSBsZWZ0IiwwXSxbImZyLiBGYWtlIGxlZnQiLDYwXSxbIm1uLiBGYWtlIHJpZ2h0IiwwXSxbImcuIERlc3luYyIsM10sWyJmLiBEZXN5bmMiLDFdLFsiZC4gRGVzeW5jIiwzXSxbImEuIERlc3luYyIsM10sWyJkbS4gRGVzeW5jIiwzXSxbImFkLiBGYWtlIHJpZ2h0Iiw2MF0sWyJzbS4gRmFrZSByaWdodCIsNjBdLFsic20uIERlc3luYyIsM10sWyJnLiBGYWtlIHJpZ2h0Iiw2MF0sWyJhLiBGYWtlIHJpZ2h0IiwyN10sWyJhZC4gRmFrZSBsZWZ0Iiw2MF0sWyJmci4gRmFrZSByaWdodCIsNjBdLFsibW4uIERlc3luYyIsMV0sWyJmci4gRGVzeW5jIiw0XV19"
}

-- 157, 168, 214

local print_dev = function(text)
    log.aim[#log.aim + 1] = {text, globals.cur_time() + 5}
end

-- used for overriding animations
local utilitize = {
    this_call = function(call_function, parameters)
        return function(...)
            return call_function(parameters, ...)
        end
    end,

    entity_list_003 = ffi.cast(ffi.typeof("uintptr_t**"), memory.create_interface("client.dll", "VClientEntityList003"))
}
local get_entity_address = utilitize.this_call(ffi.cast("get_client_entity_t", utilitize.entity_list_003[0][3]), utilitize.entity_list_003);

-- math functions
math.clamp = function(v, min, max)
    if min > max then
        min, max = max, min
    end
    if v > max then
        return max
    end
    if v < min then
        return v
    end
    return v
end

math.vec_length2d = function(vec)
    root = 0.0
    sqst = vec.x * vec.x + vec.y * vec.y
    root = math.sqrt(sqst)
    return root
end

math.angle_diff = function(dest, src)
    local delta = 0.0

    delta = math.fmod(dest - src, 360.0)

    if dest > src then
        if delta >= 180 then
            delta = delta - 360
        end
    else
        if delta <= -180 then
            delta = delta + 360
        end
    end

    return delta
end

math.angle_normalize = function(angle)
    local ang = 0.0
    ang = math.fmod(angle, 360.0)

    if ang < 0.0 then
        ang = ang + 360
    end

    return ang
end

math.anglemod = function(a)
    local num = (360 / 65536) * bit.band(math.floor(a * (65536 / 360.0), 65535))
    return num
end

math.approach_angle = function(target, value, speed)
    target = math.anglemod(target)
    value = math.anglemod(value)

    local delta = target - value

    if speed < 0 then
        speed = -speed
    end

    if delta < -180 then
        delta = delta + 360
    elseif delta > 180 then
        delta = delta - 360
    end

    if delta > speed then
        value = value + speed
    elseif delta < -speed then
        value = value - speed
    else
        value = target
    end

    return value
end

math.yaw_to_player = function(player, forward)
    local LocalPlayer = entity_list.get_local_player()
    if not LocalPlayer or not player then
        return 0
    end

    local lOrigin = LocalPlayer:get_render_origin()
    local ViewAngles = engine.get_view_angles()
    local pOrigin = player:get_render_origin()
    local Yaw = (-math.atan2(pOrigin.x - lOrigin.x, pOrigin.y - lOrigin.y) / 3.14 * 180 + 180) - (forward and 90 or -90) -- - ViewAngles.y +(forward and 0 or -180)
    if Yaw >= 180 then
        Yaw = 360 - Yaw
        Yaw = -Yaw
    end
    return Yaw
end

-- utility entity functions
local entity_list_ptr = ffi.cast("void***", memory.create_interface("client.dll", "VClientEntityList003"))
local get_client_entity_fn = ffi.cast("GetClientEntityHandle_4242425_t", entity_list_ptr[0][3])
entity.get_vector_prop = function(idx, prop, array)
    local v1, v2, v3 = entity.get_prop(idx, prop, array)
    return {
        x = v1,
        y = v2,
        z = v3
    }
end

entity.get_address = function(idx)
    return get_client_entity_fn(entity_list_ptr, idx)
end

entity.get_animstate = function(idx)
    -- local addr = entity.get_address(idx)
    -- if not addr then return end
    return ffi.cast("CPlayer_Animation_State**", ffi.cast("uintptr_t", idx) + 0x9960)[0]
end

entity.get_animlayer = function(idx)
    local addr = entity.get_address(idx)
    if not addr then
        return
    end
    return ffi.cast("C_AnimationLayer**", ffi.cast('uintptr_t', addr) + 0x9960)[0]
end

local ui = {
    nav = {
        slider = groups.nav:slider("funny hidden slider tee hee :3", 0, 6),
        text = groups.nav:text("Welcome to metaset: " .. info.user),
        sep = menu.add_separator("Home")
    },
    config = {
        list = groups.configs:list("Config List", {}, 7)
    },
    rage = {
        resolve = groups.res:checkbox("Enable Custom Resolver"),
        method = groups.res:selection("Method", {"default", "safer", "one-line", "random", "custom"}),
        dump = groups.res:button("Dump Memory", function()
            print(tools:dump(resolver.memory))
            engine.execute_cmd("showconsole")
        end),
        clear = groups.res:button("Clear Memory", function()
            resolver.memory = {}
        end),
        resinstructions = groups.res:text("!! Disable cheat's resolver !!"),
        debug = groups.res:checkbox("Debug"),
        custom = groups.res:slider("Custom Desync", -60, 60, 1, 0, "°"),
        knifehelp = groups.tick:checkbox("Knifebot Helper"),
        switchhelp = groups.tick:checkbox("Fast Weapon Switch"),
        tplag = groups.tick:checkbox("Skeet DT Behaviour"),
        teleport = groups.tick:checkbox("Lagpeek"),
        instructions = groups.tick:button("Instructions", function()
            engine.execute_cmd("showconsole")
            print("Turn on 'aim>general>dt>dont use charge' or bind it to your autopeek for the ideal tick to work.")
            print("Best used with defensive on freestanding / on peek.")
        end),
        idealinstructions = groups.tick:text("!! Key not bound !!"),
        airstop = groups.rage:selection("Custom Airstop", {"off", "safe", "unsafe"}),
        hitchance = groups.rage:slider("Hitchance", 1, 100, 1, 0, "%"),
        sep = menu.add_separator("Rage"),
        accuracy = groups.rage:checkbox("Accuracy Boost"),
        boostamount = groups.rage:slider("Boost Amount", 1, 100, 1, 0, "%"),
        baimboost = groups.rage:checkbox("Full boost on baim"),
        sep2 = menu.add_separator("Rage"),
        safedefensive = groups.rage:checkbox("Safepoint Defensive"),
        correction = groups.rage:checkbox("Multi-point Correction")
    },
    antiaim = {
        features = {
            safehead = groups.features:multi_selection("Safe Head", {"knife air c", "allow defensive"}),
            warmup = groups.features:multi_selection("Randomization", {"no enemies alive", "warmup"}),
            correction = groups.features:multi_selection("Crouch Correction", {"yaw"}),
            antibackstab = groups.features:checkbox("Anti backstab"),
            fakelag = groups.features:checkbox("Fakelag Avoid Onshot"),
            sep = menu.add_separator("Features"),
            airstucktext = groups.features:text("Airstuck")
        },
        breakers = {
            ground = groups.breakers:selection("Ground Breaker", {"none", "skeet", "moonwalk", "break", "jitter"}),
            air = groups.breakers:selection("Air", {"none", "static", "moonwalk", "break"}),
            extra = groups.breakers:multi_selection("Extra", {"land pitch", "lean"}),
            lean = groups.breakers:slider("Lean Amount", 0, 100, 1, 0, "%")
        }
    },
    visuals = {
        esp = groups.visuals:selection("Custom ESP Font", espfonts, #espfonts),
        health = groups.visuals:selection("Custom Health", {"off", "solid", "fade", "duo"}),
        sep3 = menu.add_separator("Visuals"),
        hitmarker = groups.visuals:selection("Hitmarkers", {"off", "+", "x"}),
        bullets = groups.visuals:checkbox("Bullet Tracers"),
        sep4 = menu.add_separator("Visuals"),
        indicators = groups.indicators:selection("Crosshair Indicators", {"none", "pixel", "clean", "zay"}),
        elements = groups.indicators:multi_selection("Elements", {"info", "keybinds"}),
        desync = groups.indicators:selection("Desync Bar", {"static", "jitter"}),
        binds = groups.indicators:multi_selection("Hotkeys", {"doubletap", "hideshots", "damage", "hitchance", "freestand", "force body", "force safe", "ping"}, 8),
        sep = menu.add_separator("Indicators"),
        velocity = groups.indicators:checkbox("Velocity Indicator"),
        defensive = groups.indicators:checkbox("Defensive Indicator"),
        sep5 = menu.add_separator("Indicators"),
        mindmg = groups.indicators:checkbox("Crosshair Damage"),
        transparent = groups.indicators:checkbox("Mindamage Only"),
        lerp = groups.indicators:checkbox("Animated"),

        gamesense_indicators = groups.visuals:multi_selection("400$ indicators", {"doubletap", "hideshots", "damage", "hitchance", "freestand", "force safe", "ping", "fake duck", "hitrate"}),
        reset_hitrate = groups.visuals:multi_selection("Reset hitrate", {"new server", "new game"}),
        sep6 = menu.add_separator("Visuals"),
        solus = groups.visuals:checkbox("Solus UI")
    },
    misc = {
        logs = groups.misc:multi_selection("Logs", {"console", "crosshair", "screen"}),
        logoptions = groups.misc:multi_selection("Events", {"hit", "miss", "defensive"}),
        detailedlogs = groups.misc:multi_selection("Detailed logs", {"console", "screen"}),
        extralogs = groups.misc:multi_selection("Detailed info", {"safe", "onshot", "angle", "correction"}),
        tag = groups.misc:checkbox("Clantag"),
        supertoss = groups.movement:selection("Super Toss", {"off", "smart", "semi", "full"}),
        fastladder = groups.movement:multi_selection("Fast Ladder", {"up", "down"}),
        nofall = groups.movement:checkbox("No Fall Damage"),
        sep = menu.add_separator("Movement"),
        avoid_collisions = groups.movement:checkbox("Avoid Collisions"),
        avoid_collisions_dist = groups.movement:slider("max. Distance", 5, 20, 1, 1, "u"),
        avoid_collisions_vel = groups.movement:slider("min. Velocity", 0, 200),
        sep2 = menu.add_separator("Movement"),
        antiafk = groups.movement:checkbox("Anti afk")
    },
    hidden = {
        solus_x = groups.settings:slider("solus x", 0, screen.size.x),
        solus_y = groups.settings:slider("solus y", 0, screen.size.y)
    },
    loader = {
        logout = groups.loader:button("Logout", function()
            filesystem.write("scripts\\bugreporter_defaults.txt", " ")
            client.delay_call(function()
                menu.reload_scripts()
            end, 0.2)
        end)
    }
}

ui.visuals.healthcolor1 = groups.nav:color_picker(ui.visuals.health, "1st Color", color_t(40, 200, 64, 255))
ui.visuals.healthcolor2 = groups.nav:color_picker(ui.visuals.health, "2nd Color", color_t(40, 200, 64, 255))
ui.accent = groups.nav:color_picker(ui.nav.text, "Accent Color", color_t(157, 168, 214))
ui.visuals.bulletcol = groups.visuals:color_picker(ui.visuals.bullets, "Accent Color", color_t(120, 120, 120))
ui.visuals.hitcolor = groups.visuals:color_picker(ui.visuals.hitmarker, "Hitmarker Color", color_t(88, 255, 209))
ui.antiaim.features.airstuck = groups.features:keybind(ui.antiaim.features.airstucktext, "airstuck key")

ui.nav.backbtn = groups.nav:button("Back", function()
    ui.nav.slider.ref:set(0)
end)
ui.nav.configbtn = groups.nav:button("Configs", function()
    ui.nav.slider.ref:set(1)
end)
ui.nav.ragebtn = groups.nav:button("Rage", function()
    ui.nav.slider.ref:set(2)
end)
ui.nav.aabtn = groups.nav:button("Anti aim", function()
    ui.nav.slider.ref:set(3)
end)
ui.nav.helpers = groups.nav:button("Helpers", function()
    ui.nav.slider.ref:set(4)
end)
ui.nav.visbtn = groups.nav:button("Visuals", function()
    ui.nav.slider.ref:set(5)
end)
ui.nav.miscbtn = groups.nav:button("Misc", function()
    ui.nav.slider.ref:set(6)
end)

ui.antiaim.builder = {
    enable = groups.nav:checkbox("Enable Builder"),
    condition = groups.nav:selection("Condition", states, #states),
    pitch = groups.antiaim:selection("Pitch", {"off", "down", "up", "zero", "jitter"}),
    yaw = groups.antiaim:selection("Base", {"local view", "at targets", "distance"}),
    sep = menu.add_separator("Global"),
    defensive_ping = groups.antiaim:selection("Defensive mode", {"ping safe", "unsafe"})
}

for i = 1, #states do
    ui.antiaim.builder[i] = {
        override = groups.nav:checkbox("Override " .. states[i]),
        yaw_mode = groups.yaw:selection(shortstates[i] .. " Yaw mode", {"static", "classic", "meta"}),
        yaw_value = groups.yaw:slider(shortstates[i] .. " Yaw", -90, 90, 1, 0, "°"),
        yaw_left = groups.yaw:slider(shortstates[i] .. " Left", -90, 90, 1, 0, "°"),
        yaw_right = groups.yaw:slider(shortstates[i] .. " Right", -90, 90, 1, 0, "°"),
        meta_left = groups.yaw:slider(shortstates[i] .. " Left Randomization", -90, 90, 1, 0, "°"),
        meta_right = groups.yaw:slider(shortstates[i] .. " Right Randomization", -90, 90, 1, 0, "°"),
        yaw_delay = groups.yaw:slider(shortstates[i] .. " Delay", 2, 32, 1, 0, "t"),
        meta_delay = groups.yaw:slider(shortstates[i] .. " Delay Fluctuation", 0, 16, 1, 0, "t"),
        yaw_modifier = groups.jitter:selection(shortstates[i] .. " Modifier Mode", {"none", "offset", "center", "3-way", "5-way"}),
        modifier_degree = groups.jitter:slider(shortstates[i] .. " Modifier Degree", -180, 180, 1, 0, "°"),
        modifier_random = groups.jitter:slider(shortstates[i] .. " Modifier Randomization", -180, 180, 1, 0, "°"),
        desync = groups.desync:selection(shortstates[i] .. " Desync", {"left", "right", "jitter", "peek fake"}),
        fake_left = groups.desync:slider(shortstates[i] .. " Fake left", 0, 60, 1, 0, "°"),
        fake_right = groups.desync:slider(shortstates[i] .. " Fake right", 0, 60, 1, 0, "°"),
        trigger_defensive = groups.defensive:selection(shortstates[i] .. " Defensive", {"off", "on peek", "force", "anti-aim", "dynamic"}),
        defensive_pitch = groups.defensive:selection(shortstates[i] .. " Defensive Pitch", {"inherit", "off", "down", "up", "zero", "jitter", "random", "custom", "switch", "clock"}),
        defensive_pitch_val = groups.defensive:slider(shortstates[i] .. " Pitch Value", -90, 90, 1, 0, "°"),
        defensive_pitch_val2 = groups.defensive:slider(shortstates[i] .. " Pitch Value 2", -90, 90, 1, 0, "°"),
        defensive_yaw = groups.defensive:selection(shortstates[i] .. " Defensive Yaw", {"inherit", "static", "sideways", "switch", "spin", "random", "5-way", "clock"}),
        defensive_yaw_val = groups.defensive:slider(shortstates[i] .. " Yaw Value", -180, 180, 1, 0, "°")
    }
end

ui.rage.hitchance.ref:set(75)

print("Metaset Loaded!")

resolver.states = {"stand", "lowvel", "move", "duck", "duckM", "air", "airC"}

resolver.clearmemory = function(e)
    if e.name == "round_prestart" then
        if game_rules.get_prop("m_totalRoundsPlayed") == 0 then
            if ui.rage.debug:get() then
                print("wiping resolver memory")
            end
            resolver.memory = {}
        end
    end
end

resolver.detectState = function(ent)
    local m_vecVelocity = ent:get_prop('m_vecVelocity')
    local velocity = math.vec_length2d(m_vecVelocity)
    local flags = ent:get_prop('m_fFlags')
    local ducking = bit.lshift(1, 1)
    local ground = bit.lshift(1, 0)
    local state = ""
    local statenum = 0

    if bit.band(flags, ground) == 1 and velocity > 80 and bit.band(flags, ducking) == 0 then
        state = "move"
        statenum = 4
    end
    if bit.band(flags, ground) == 0 and bit.band(flags, ducking) == 0 then
        state = "air"
        statenum = 7
    end
    if bit.band(flags, ground) == 0 and bit.band(flags, ducking) > 0.9 then
        state = "air duck"
        statenum = 8
    end
    if bit.band(flags, ground) == 1 and velocity < 3 and bit.band(flags, ducking) == 0 then
        state = "stand"
        statenum = 2
    else
        if bit.band(flags, ground) == 1 and velocity <= 80 and bit.band(flags, ducking) == 0 then
            state = "slow motion"
            statenum = 3
        end
    end
    if bit.band(flags, ground) == 1 and bit.band(flags, ducking) > 0.9 and velocity > 10 then
        state = "duck move"
        statenum = 6
    elseif bit.band(flags, ground) == 1 and bit.band(flags, ducking) > 0.9 then
        state = "duck"
        statenum = 5
    end

    return state, statenum - 1
end

resolver.m_flMaxDelta = function(ent)
    local player_index = ent:get_index()
    local player_ptr = get_entity_address(player_index)

    local speedfactor = math.clamp(ffi.cast("CPlayer_Animation_State**", ffi.cast("uintptr_t", player_ptr) + 0x9960)[0].m_flFeetSpeedForwardsOrSideWays, 0, 1)
    local avg_speedfactor = (ffi.cast("CPlayer_Animation_State**", ffi.cast("uintptr_t", player_ptr) + 0x9960)[0].m_flStopToFullRunningFraction * -0.3 - 0.2) * speedfactor + 1
    local duck_amount = ffi.cast("CPlayer_Animation_State**", ffi.cast("uintptr_t", player_ptr) + 0x9960)[0].flDuckAmount

    if duck_amount > 0 then
        local max_velocity = math.clamp(ffi.cast("CPlayer_Animation_State**", ffi.cast("uintptr_t", player_ptr) + 0x9960)[0].m_flFeetSpeedForwardsOrSideWays, 0, 1)
        local duck_speed = duck_amount * max_velocity

        avg_speedfactor = avg_speedfactor + (duck_speed * (0.5 - avg_speedfactor))
    end

    return math.clamp(avg_speedfactor, 0, 1)
end

resolver.walk_to_run_transition = function(m_flWalkToRunTransition, m_bWalkToRunTransitionState, m_flLastUpdateIncrement, m_flVelocityLengthXY)
    local ANIM_TRANSITION_WALK_TO_RUN = false
    local ANIM_TRANSITION_RUN_TO_WALK = true
    local CSGO_ANIM_WALK_TO_RUN_TRANSITION_SPEED = 2.0
    local CS_PLAYER_SPEED_RUN = 260.0
    local CS_PLAYER_SPEED_DUCK_MODIFIER = 0.34
    local CS_PLAYER_SPEED_WALK_MODIFIER = 0.52

    if m_flWalkToRunTransition > 0 and m_flWalkToRunTransition < 1 then
        if m_bWalkToRunTransitionState == ANIM_TRANSITION_WALK_TO_RUN then
            m_flWalkToRunTransition = m_flWalkToRunTransition + m_flLastUpdateIncrement * CSGO_ANIM_WALK_TO_RUN_TRANSITION_SPEED
        else
            m_flWalkToRunTransition = m_flWalkToRunTransition - m_flLastUpdateIncrement * CSGO_ANIM_WALK_TO_RUN_TRANSITION_SPEED
        end

        m_flWalkToRunTransition = math.clamp(m_flWalkToRunTransition, 0, 1)
    end

    if m_flVelocityLengthXY > (CS_PLAYER_SPEED_RUN * CS_PLAYER_SPEED_WALK_MODIFIER) and m_bWalkToRunTransitionState == ANIM_TRANSITION_RUN_TO_WALK then
        m_bWalkToRunTransitionState = ANIM_TRANSITION_WALK_TO_RUN
        m_flWalkToRunTransition = math.max(0.01, m_flWalkToRunTransition)
    elseif m_flVelocityLengthXY < (CS_PLAYER_SPEED_RUN * CS_PLAYER_SPEED_WALK_MODIFIER) and m_bWalkToRunTransitionState == ANIM_TRANSITION_WALK_TO_RUN then
        m_bWalkToRunTransitionState = ANIM_TRANSITION_RUN_TO_WALK
        m_flWalkToRunTransition = math.min(0.99, m_flWalkToRunTransition)
    end

    return m_flWalkToRunTransition, m_bWalkToRunTransitionState
end

resolver.calculate_predicted_foot_yaw = function(m_flFootYawLast, m_flEyeYaw, m_flLowerBodyYawTarget, m_flWalkToRunTransition, m_vecVelocity, m_flMinBodyYaw, m_flMaxBodyYaw)
    local m_flVelocityLengthXY = math.min(math.vec_length2d(m_vecVelocity), 260.0)

    local m_flFootYaw = math.clamp(m_flFootYawLast, -360, 360)
    local flEyeFootDelta = math.angle_diff(m_flEyeYaw, m_flFootYaw)

    if flEyeFootDelta > m_flMaxBodyYaw then
        m_flFootYaw = m_flEyeYaw - math.abs(m_flMaxBodyYaw)
    elseif flEyeFootDelta < m_flMinBodyYaw then
        m_flFootYaw = m_flEyeYaw + math.abs(m_flMinBodyYaw)
    end

    m_flFootYaw = math.angle_normalize(m_flFootYaw)

    local m_flLastUpdateIncrement = globals.interval_per_tick()

    if m_flVelocityLengthXY > 0.1 or m_vecVelocity.z > 100 then
        m_flFootYaw = math.approach_angle(m_flEyeYaw, m_flFootYaw, m_flLastUpdateIncrement * (30.0 + 20.0 * m_flWalkToRunTransition))
    else
        m_flFootYaw = math.approach_angle(m_flLowerBodyYawTarget, m_flFootYaw, m_flLastUpdateIncrement * 100)
    end

    return m_flFootYaw
end

resolver.resolve = function(ctx)
    if not ui.rage.resolve:get() then
        return
    end
    local idx = ctx.player:get_index()
    local ent = ctx.player
    local lplr = entity_list.get_local_player()
    if not lplr or not lplr:is_valid() or not lplr:is_player() or not lplr:is_alive() then
        return
    end

    if not lastResolved[idx] then
        lastResolved[idx] = {}
    end

    local max = 57.295779513082
    if not ent:is_valid() or not ent:is_alive() or not idx then
        return
    end
    local targetname = ent:get_name()
    local player_ptr = get_entity_address(idx)

    local m_bIsValidIdx = ent:get_address()
    if not m_bIsValidIdx then
        return
    end

    local m_vecVelocity = ent:get_prop('m_vecVelocity')
    local m_flVelocityLengthXY = math.vec_length2d(m_vecVelocity) -- We don't need to check for jump
    local animstate = ffi.cast("CPlayer_Animation_State**", ffi.cast("uintptr_t", player_ptr) + 0x9960)[0]
    if not animstate then
        return
    end
    local m_flEyeYaw = animstate.flEyeYaw -- Current Entity Eye Yaw
    local m_flGoalFeetYaw = animstate.flGoalFeetYaw -- Current Entity Eye Yaw
    local m_flAngleDiff = math.angle_diff(m_flEyeYaw, m_flGoalFeetYaw)
    local m_flLowerBodyYawTarget = ent:get_prop('m_flLowerBodyYawTarget') -- Current Lower Body Yaw

    local m_flMaxDesyncDelta = resolver.m_flMaxDelta(ent) -- return float
    local m_flDesync = m_flMaxDesyncDelta * max -- 57 (Max Desync Value)
    local m_flAbsAngleDiff = math.abs(m_flAngleDiff) -- Current Angle Diffrence, Only positive value
    local m_flAbsPreviousDiff = math.abs(m_flAbsAngleDiff)

    local side = 0 -- It can be centered? Oh yeah bots and legit players
    if m_flAngleDiff < 0 then
        side = 1
    elseif m_flAngleDiff > 0 then
        side = -1
    end

    local m_flCurrentAngle = m_flAbsAngleDiff

    if m_flAbsAngleDiff < m_flAbsPreviousDiff then
        if m_flVelocityLengthXY > (lastResolved.m_flVelocityLengthXY or 0) then
            if m_flAbsAngleDiff <= 10.0 and m_flAbsAngleDiff <= 10.0 then
                m_flDesync = m_flCurrentAngle
            elseif m_flAbsAngleDiff <= 35.0 and m_flAbsAngleDiff <= 35.0 then
                m_flDesync = math.max(29.0, m_flCurrentAngle)
            else
                m_flDesync = math.clamp(m_flCurrentAngle, 29.0, max)
            end
        end
    end
    lastResolved[idx].m_flDesync = math.clamp(m_flDesync * side, -60, 60)
    lastResolved[idx].m_flSide = side
    lastResolved[idx].forced = false
    lastResolved[idx].m_flState, lastResolved[idx].m_flStateNum = resolver.detectState(ent)
    lastResolved[idx].Desync = -math.min(max, math.max(ent:get_prop("m_flPoseParameter", 11) * 120 - max))

    lastResolved[idx].m_flDesync = math.clamp(m_flDesync * side, -60, 60)

    lastResolved[idx].m_flWalkToRunTransition, lastResolved[idx].m_bWalkToRunTransitionState = resolver.walk_to_run_transition(lastResolved[idx].m_flWalkToRunTransition or 0, lastResolved[idx].m_bWalkToRunTransitionState or false,
        globals.interval_per_tick(), m_flVelocityLengthXY) -- We need this only for m_flWalkToRunTransition

    if resolver.memory[idx] then
        -- if ui.rage.debug:get() then print("found memory instance, scanning for state") end
        for k, v in pairs(resolver.memory[idx]) do
            if k == resolver.detectState(ent) then
                -- if ui.rage.debug:get() then print("found state instance, scanning for side") end
                for o, p in pairs(resolver.memory[idx][k]) do
                    if o == side then
                        -- if ui.rage.debug:get() then print("found side instance, overriding desync to memory instance: " ..p) end
                        lastResolved[idx].m_flDesync = p
                        lastResolved[idx].forced = true
                        if idx == lastResolved.target then
                            lastResolved.Desync = lastResolved[idx].Desync
                            lastResolved.forced = lastResolved[idx].forced
                        end
                    end
                end
            end
        end
    end
    -- client.log_screen('yes')
    if ui.rage.resolve:get() then
        local player_weapon = ent:get_active_weapon()
        if not player_weapon then
            return
        end
        if ui.rage.method:get() == 1 then
            animstate.flGoalFeetYaw = resolver.calculate_predicted_foot_yaw(m_flGoalFeetYaw, m_flEyeYaw + lastResolved[idx].m_flDesync, m_flLowerBodyYawTarget, lastResolved[idx].m_flWalkToRunTransition, m_vecVelocity, -57, 57) -- Calculate new foot yaw

        elseif ui.rage.method:get() == 2 then
            animstate.flGoalFeetYaw = animstate.flEyeYaw + lastResolved[idx].m_flDesync / 3
        elseif ui.rage.method:get() == 3 then
            animstate.flGoalFeetYaw = animstate.flEyeYaw - lastResolved[idx].Desync
        elseif ui.rage.method:get() == 4 then
            lastResolved[idx].Desync = client.random_float(-60, 60)
            if idx == lastResolved.target then
                lastResolved[idx].Desync = lastResolved[idx].Desync
            end

            animstate.flGoalFeetYaw = animstate.flEyeYaw - lastResolved[idx].Desync
        elseif ui.rage.method:get() == 5 then
            lastResolved[idx].Desync = ui.rage.custom:get()
            if idx == lastResolved.target then
                lastResolved[idx].Desync = lastResolved[idx].Desync
            end

            animstate.flGoalFeetYaw = animstate.flEyeYaw - lastResolved[idx].Desync
        end
    end
end

resolver.updatetarget = function(ctx)
    lastResolved.target = ctx.player:get_index()
end

resolver.pre_resolve = function()
    if not ui.rage.resolve:get() then
        return
    end
    local players = entity_list.get_players(true)
    if not players then
        return
    end
    for _, enemy in ipairs(players) do
        if not enemy:is_dormant() then
            if enemy:is_alive() then
                local ctx = {
                    player = enemy
                }
                resolver.resolve(ctx)
            end
        end
    end
end

local global = {
    current_state = "",
    current_state_number = 0,
    velocity = 0,
    update = function(self, cmd)
        local local_player = entity_list.get_local_player()
        if not local_player then
            return
        end

        local m_vecVelocity = local_player:get_prop('m_vecVelocity')
        local velocity = math.vec_length2d(m_vecVelocity)
        local flags = local_player:get_prop('m_fFlags')
        local ducking = bit.lshift(1, 1)
        local ground = bit.lshift(1, 0)
        self.velocity = velocity

        local state = function()
            if bit.band(flags, ground) == 1 and velocity > 3 and bit.band(flags, ducking) == 0 and not refs.slow_motion:get() and not cmd:has_button(e_cmd_buttons.JUMP) then
                self.current_state = "move"
                self.current_state_number = 3
            end
            if bit.band(flags, ground) == 0 and bit.band(flags, ducking) == 0 then
                self.current_state = "air"
                self.current_state_number = 7
            end
            if bit.band(flags, ground) == 0 and bit.band(flags, ducking) > 0.9 then
                self.current_state = "air duck"
                self.current_state_number = 8
            end
            if bit.band(flags, ground) == 1 and velocity < 3 and bit.band(flags, ducking) == 0 then
                self.current_state = "stand"
                self.current_state_number = 2
            else
                if bit.band(flags, ground) == 1 and velocity > 3 and bit.band(flags, ducking) == 0 and refs.slow_motion:get() then
                    self.current_state = "slow motion"
                    self.current_state_number = 4
                end
            end
            if bit.band(flags, ground) == 1 and bit.band(flags, ducking) > 0.9 and ui.antiaim.builder[6].override:get() and velocity > 10 and not cmd:has_button(e_cmd_buttons.JUMP) then
                self.current_state = "duck move"
                self.current_state_number = 6
            elseif bit.band(flags, ground) == 1 and bit.band(flags, ducking) > 0.9 and not cmd:has_button(e_cmd_buttons.JUMP) then
                self.current_state = "duck"
                self.current_state_number = 5
            end
            if (not (refs.double_tap:get() or refs.hide_shots:get()) and ui.antiaim.builder[9].override:get()) then
                self.current_state = "fakelag"
                self.current_state_number = 9
            end
            if refs.freestand:get() and ui.antiaim.builder[11].override:get() then
                self.current_state = "freestand"
                self.current_state_number = 11
            end
            if manual then
                self.current_state = "manual"
                self.current_state_number = 10
            end
        end
        state()
    end
}

log.add = function(mode, text)
    if type(mode) == "string" then
        text = mode
        mode = 0
    end

    if ui.misc.logs:get("console") and (mode == 1 or mode == 0) then
        print(text)
    end

    if ui.misc.logs:get("screen") and (mode == 2 or mode == 0) then
        print_dev(text)
    end

    if ui.misc.logs:get("crosshair") and (mode == 3) then
        aimbot_loggies[#aimbot_loggies + 1] = {text, globals.tick_count() + 250, 0}
    end
end

handles.logs = function()
    local startval = nil
    for k, v in pairs(log.aim) do
        if #log.aim - k < 5 then
            if not startval then
                startval = k
            end
            if v[2] > globals.cur_time() then
                render.text(fonts.lucida, v[1], vector(5, 5 + (10 * (k - startval))), color(255, 255, 255, math.floor(v[2] > globals.cur_time() + 1 and 255 or ((v[2] - globals.cur_time()) * 255))))
            else
                log.aim[k] = nil
            end
        end
    end
end

log.shot = function(self, shot)
    local lplr = entity_list.get_local_player()
    if not lplr then
        return
    end
    local idx = shot.player:get_index()
    local targetwep = shot.player:get_active_weapon()

    self.desync = (lastResolved[idx] and lastResolved[idx].m_flDesync) and (ui.rage.method:get() == 1 and math.floor(lastResolved[idx].m_flDesync) or lastResolved[idx].Desync)
    self.side = lastResolved[idx] and lastResolved[idx].m_flSide or "?"
    self.state = lastResolved[idx] and lastResolved[idx].m_flState or "?"
    self.statenum = lastResolved[idx] and lastResolved[idx].m_flStateNum or "?"
    if lastResolved[idx] then
        self.forced = lastResolved[idx].forced
    else
        self.forced = false
    end
    self.team = shot.player:get_prop("m_iTeamNum") ~= lplr:get_prop("m_iTeamNum") and "enemy" or "teammate"
    self.tick = globals.tick_count()
    self.predicted = shot.extrapolated_ticks
    self.aimpos = shot.player:get_hitbox_pos(1)
    self.nextchoke = ui.antiaim.features.fakelag:get()
    self.fakeduck = refs.fake_duck:get()
    if not targetwep then
        self.onshot = false
    else
        self.onshot = targetwep:get_prop('m_fLastShotTime') and globals.cur_time() - targetwep:get_prop('m_fLastShotTime') < 0.5 or false
    end
end

log.hit = function(self, hit)
    -- fix shit logs
    local hitgroup = tools.hitgroup_str[hit.aim_hitgroup]
    if hitgroup == "left leg" then
        hitgroup = "right leg"
    elseif hitgroup == "right leg" then
        hitgroup = "left leg"
    elseif hitgroup == "right arm" then
        hitgroup = "left arm"
    elseif hitgroup == "right arm" then
        hitgroup = "left arm"
    end

    if (ui.rage.resolve:get() and ui.rage.method:get() == 1) and (lastResolved.target == hit.player:get_index()) then
        if not resolver.memory[hit.player:get_index()] then
            resolver.memory[hit.player:get_index()] = {}
        end
        if self.state ~= nil then
            if not resolver.memory[hit.player:get_index()][self.state] then
                resolver.memory[hit.player:get_index()][self.state] = {}
            end
            if hit.aim_hitgroup == hit.hitgroup then
                resolver.memory[hit.player:get_index()][self.state][self.side] = self.desync
                if ui.rage.debug:get() then
                    if self.forced then
                        print("resolved past instance for " .. hit.player:get_name() .. " as " .. hit.player:get_index() .. "." .. self.state .. " | " .. self.desync)
                    else
                        print("logged shot for " .. hit.player:get_name() .. " as " .. hit.player:get_index() .. "." .. self.state .. " | " .. self.desync)
                    end
                end
            end
        end
    end
    local health = hit.player:get_prop("m_iHealth")

    if ui.misc.logoptions:get("hit") then
        if ui.misc.detailedlogs:get("console") then
            log.add(1, string.format("Hit %s(%s%%%%) in %s(%s) for %i(%i) damage | history(Δ): %i%s%s%s%s", string.lower(hit.player:get_name()), hit.aim_hitchance, tools.hitgroup_str[hit.hitgroup], hitgroup, hit.damage, hit.aim_damage,
                self.predicted > 0 and -self.predicted or hit.backtrack_ticks, (ui.misc.extralogs:get("safe") and hit.safepoint) and " | safe" or "", (ui.misc.extralogs:get("onshot") and self.onshot) and " | onshot" or "",
                (ui.misc.extralogs:get("correction") and correctiondb[hit.player:get_index()]) and " | corrected" or "", (ui.misc.extralogs:get("angle") and ui.rage.resolve:get()) and
                    string.format(" | angle: %s° (%s|%s:%s)", self.desync and math.floor(self.desync) or "?", self.forced and 1 or 0, hit.player:get_index(), self.statenum) or ""))
        else
            log.add(1, string.format("Hit %s(%s%%%%) in %s(%s) for %i(%i) damage | history(Δ): %i", string.lower(hit.player:get_name()), hit.aim_hitchance, tools.hitgroup_str[hit.hitgroup], hitgroup, hit.damage, hit.aim_damage,
                self.predicted > 0 and -self.predicted or hit.backtrack_ticks, (ui.misc.extralogs:get("safe") and hit.safepoint) and " | safe" or "", (ui.misc.extralogs:get("onshot") and self.onshot) and " | onshot" or "",
                (ui.misc.extralogs:get("correction") and correctiondb[hit.player:get_index()]) and " | corrected" or "", (ui.misc.extralogs:get("angle") and ui.rage.resolve:get()) and
                    string.format(" | angle: %s° (%s|%s:%s)", self.desync and math.floor(self.desync) or "?", self.forced and 1 or 0, hit.player:get_index(), self.statenum) or ""))
        end
        if ui.misc.detailedlogs:get("screen") then
            log.add(2, string.format("Hit %s(%s%%) in %s(%s) for %i(%i) damage | history(Δ): %i%s%s%s%s", string.lower(hit.player:get_name()), hit.aim_hitchance, tools.hitgroup_str[hit.hitgroup], hitgroup, hit.damage, hit.aim_damage,
                self.predicted > 0 and -self.predicted or hit.backtrack_ticks, (ui.misc.extralogs:get("safe") and hit.safepoint) and " | safe" or "", (ui.misc.extralogs:get("onshot") and self.onshot) and " | onshot" or "",
                (ui.misc.extralogs:get("correction") and correctiondb[hit.player:get_index()]) and " | corrected" or "", (ui.misc.extralogs:get("angle") and ui.rage.resolve:get()) and
                    string.format(" | angle: %s° (%s|%s:%s)", self.desync and math.floor(self.desync) or "?", self.forced and 1 or 0, hit.player:get_index(), self.statenum) or ""))
        else
            log.add(2, string.format("Hit %s(%s%%) in %s(%s) for %i(%i) damage | history(Δ): %i", string.lower(hit.player:get_name()), hit.aim_hitchance, tools.hitgroup_str[hit.hitgroup], hitgroup, hit.damage, hit.aim_damage,
                self.predicted > 0 and -self.predicted or hit.backtrack_ticks, (ui.misc.extralogs:get("safe") and hit.safepoint) and " | safe" or "", (ui.misc.extralogs:get("onshot") and self.onshot) and " | onshot" or "",
                (ui.misc.extralogs:get("correction") and correctiondb[hit.player:get_index()]) and " | corrected" or "", (ui.misc.extralogs:get("angle") and ui.rage.resolve:get()) and
                    string.format(" | angle: %s° (%s|%s:%s)", self.desync and math.floor(self.desync) or "?", self.forced and 1 or 0, hit.player:get_index(), self.statenum) or ""))
        end
        log.add(3, ("Hit %s in %s for %s damage | %s"):format(string.lower(hit.player:get_name()), tools.hitgroup_str[hit.hitgroup], hit.damage, health > 0 and "health remaining " .. health or "history " .. hit.backtrack_ticks))
    end

    if game_rules.get_prop("m_gamePhase") == 4 or game_rules.get_prop("m_gamePhase") == 5 then
        refs.pitch:set(1)
        refs.yawbase:set(1)
        refs.jittermode:set(1)
        refs.desyncside:set(0)
    end
end

log.miss = function(self, miss)
    local reason = miss.reason_string
    if reason == "jitter" then
        reason = "correction"
    elseif reason == "resolver" then
        reason = "unknown"
    elseif reason == "extrapolation" then
        reason = "prediction error"
    elseif reason == "spread (missed safe)" then
        reason = "spread"
    elseif string.sub(reason, 1, 7) == "ping (l" then
        reason = "death"
    elseif string.sub(reason, 1, 4) == "ping" then
        reason = "enemy death"
    end

    -- fix shit logs
    local hitgroup = tools.hitgroup_str[miss.aim_hitgroup]
    if hitgroup == "left leg" then
        hitgroup = "right leg"
    elseif hitgroup == "right leg" then
        hitgroup = "left leg"
    elseif hitgroup == "right arm" then
        hitgroup = "left arm"
    elseif hitgroup == "right arm" then
        hitgroup = "left arm"
    end

    if reason == "spread" then
        if globals.tick_count() - self.hurttick < 2 then
            reason = "aimpunch"
        end
    end
    if reason == "resolver" or reason == "unknown" and (not self.fakeduck) then
        local actualpos = miss.player:get_hitbox_pos(1)
        local distance = self.aimpos:dist(actualpos)
        if distance > 38 then
            reason = "lagcomp failure"
        end
    end
    if not miss.player then
        return
    end

    if ui.misc.logoptions:get("miss") then
        if ui.misc.detailedlogs:get("console") then
            log.add(1, string.format("Missed %s(%s%%%%) in %s for %i damage due to %s | history(Δ): %i%s%s%s%s", string.lower(miss.player:get_name()), miss.aim_hitchance, hitgroup, miss.aim_damage, reason,
                (self.predicted and self.predicted > 0) and -self.predicted or miss.backtrack_ticks, (ui.misc.extralogs:get("safe") and miss.aim_safepoint) and " | safe" or "", (ui.misc.extralogs:get("onshot") and self.onshot) and " | onshot" or "",
                (ui.misc.extralogs:get("safe") and correctiondb[miss.player:get_index()]) and " | corrected" or "", (ui.misc.extralogs:get("angle") and ui.rage.resolve:get()) and
                    string.format(" | angle: %i° (%s|%s:%s)", self.desync and math.floor(self.desync) or 0, self.forced and 1 or 0, miss.player:get_index(), self.statenum) or ""))
        else
            log.add(1, string.format("Missed %s(%s%%%%) in %s for %i damage due to %s | history(Δ): %i", string.lower(miss.player:get_name()), miss.aim_hitchance, hitgroup, miss.aim_damage, reason,
                (self.predicted and self.predicted > 0) and -self.predicted or miss.backtrack_ticks))
        end
        if ui.misc.detailedlogs:get("screen") then
            log.add(2, string.format("Missed %s(%s%%) in %s for %i damage due to %s | history(Δ): %i%s%s%s%s", string.lower(miss.player:get_name()), miss.aim_hitchance, hitgroup, miss.aim_damage, reason,
                (self.predicted and self.predicted > 0) and -self.predicted or miss.backtrack_ticks, (ui.misc.extralogs:get("safe") and miss.aim_safepoint) and " | safe" or "", (ui.misc.extralogs:get("onshot") and self.onshot) and " | onshot" or "",
                (ui.misc.extralogs:get("safe") and correctiondb[miss.player:get_index()]) and " | corrected" or "", (ui.misc.extralogs:get("angle") and ui.rage.resolve:get()) and
                    string.format(" | angle: %i° (%s|%s:%s)", self.desync and math.floor(self.desync) or 0, self.forced and 1 or 0, miss.player:get_index(), self.statenum) or ""))
        else
            log.add(2, string.format("Missed %s(%s%%) in %s for %i damage due to %s | history(Δ): %i", string.lower(miss.player:get_name()), miss.aim_hitchance, hitgroup, miss.aim_damage, reason,
                (self.predicted and self.predicted > 0) and -self.predicted or miss.backtrack_ticks))
        end
        log.add(3, ("Missed %s in %s due to %s | history %s"):format(string.lower(miss.player:get_name()), hitgroup, reason, self.predicted > 0 and -self.predicted or miss.backtrack_ticks), globals.tick_count() + 250, 0)
    end

    -- if ui.misc.logoptions:get("miss") then
    --     log.add(1, string.format("Missed %s(%s%s) in %s for %i damage due to %s | history(Δ): %i%s%s%s%s", string.lower(miss.player:get_name()), miss.aim_hitchance, "%%", hitgroup, miss.aim_damage, reason, (self.predicted and self.predicted > 0) and - self.predicted or miss.backtrack_ticks, (ui.misc.extralogs:get("safe") and miss.aim_safepoint) and " | safe" or "", (ui.misc.extralogs:get("onshot") and self.onshot) and " | onshot" or "", (ui.misc.extralogs:get("safe") and correctiondb[miss.player:get_index()]) and " | corrected" or "", (ui.misc.extralogs:get("angle") and ui.rage.resolve:get()) and string.format(" | angle: %i° (%s|%s:%s)", self.desync and math.floor(self.desync) or 0, self.forced and 1 or 0, miss.player:get_index(), self.statenum) or ""))
    --     log.add(2, string.format("Missed %s(%s%s) in %s for %i damage due to %s | history(Δ): %i%s%s", string.lower(miss.player:get_name()), miss.aim_hitchance, "%", hitgroup, miss.aim_damage, reason, (self.predicted and self.predicted > 0) and - self.predicted or miss.backtrack_ticks, miss.aim_safepoint and " | safe" or "", self.onshot and " | onshot" or ""))
    --     log.add(3, ("Missed %s in %s due to %s | backtrack %s"):format(string.lower(miss.player:get_name()), hitgroup, reason, self.predicted > 0 and - self.predicted or miss.backtrack_ticks), globals.tick_count() + 250, 0)
    -- end

    if not (reason == "resolver") then
        return
    end
    if (ui.rage.resolve:get() and ui.rage.method:get() == 1) and (lastResolved.target == miss.player:get_index()) then
        if not resolver.memory[miss.player:get_index()] then
            return
        end
        if self.state ~= nil then
            if not resolver.memory[miss.player:get_index()][self.state] then
                return
            end
            if not resolver.memory[miss.player:get_index()][self.state][self.side] then
                return
            end
            resolver.memory[miss.player:get_index()][self.state][self.side] = nil
            if ui.rage.debug:get() then
                print("removing memory instance due to miss: " .. self.state .. " | " .. self.side)
            end
        end
    end
end

log.extra = function(self, e)
    if e.name == "player_hurt" then
        local me = entity_list.get_local_player()
        local attacker = entity_list.get_player_from_userid(e.attacker)
        local weapon = e.weapon
        local type_hit = 'Hit'

        if weapon == 'hegrenade' then
            type_hit = 'Naded'
        end

        if weapon == 'inferno' then
            type_hit = 'Burned'
        end

        if weapon == 'knife' then
            type_hit = 'Knifed'
        end

        -- print_raw(('\a'..hit_color12..'[Notyaw.lua] \aD5D5D5'..type_hit..' %s for %d damage (%d health remaining)'):format(user:get_name(), e.dmg_health, e.health)) 
        if weapon == 'hegrenade' or weapon == 'inferno' or weapon == 'knife' then
            if me == attacker then
                local player = entity_list.get_player_from_userid(e.userid)
                if ui.misc.logoptions:get("hit") then
                    log.add(1, string.format("%s %s for %i damage | %i remaining", type_hit, string.lower(player:get_name()), e.dmg_health, e.health))
                    log.add(2, string.format("%s %s for %i damage | %i remaining", type_hit, string.lower(player:get_name()), e.dmg_health, e.health))
                    log.add(3, string.format("%s %s for %i damage | %i remaining", type_hit, string.lower(player:get_name()), e.dmg_health, e.health))
                end
            end
        end
    end
end

screen.damage = function(self)
    if not engine.is_connected() or not engine.is_in_game() then
        return
    end
    local lplr = entity_list.get_local_player()
    if not lplr or not lplr:is_player() or not lplr:is_alive() then
        return
    end
    if not ui.visuals.mindmg:get() then
        return
    end
    local dmg_ovr = menu.find("aimbot", tools.active_weapon(), "target overrides", "min. damage")[1]
    local dmg_ovr_key = menu.find("aimbot", tools.active_weapon(), "target overrides", "min. damage")[2]
    local norm_dmg = menu.find("aimbot", tools.active_weapon(), "targeting", "min. damage")

    local value = (not ui.visuals.transparent:get() and dmg_ovr_key:get()) and dmg_ovr:get() or dmg_ovr_key:get() and dmg_ovr:get() or norm_dmg:get()
    local lerp = ui.visuals.lerp:get() and math.floor(tools.animation:new("dmg", value, 15) + 0.5) or value

    if dmg_ovr_key:get() then
        render.text(fonts.pixel, ui.visuals.transparent:get() and tostring(value) or tostring(lerp), vec2_t(screen.size.x / 2 + 5, screen.size.y / 2 - 15), color_t(255, 255, 255, 255))
    else
        if ui.visuals.transparent:get() then
            return
        end
        render.text(fonts.pixel, tostring(lerp), vec2_t(screen.size.x / 2 + 5, screen.size.y / 2 - 15), color_t(255, 255, 255, 100))
    end
end

screen.positions = {
    [2] = {
        [1] = 10,
        [2] = 18,
        [3] = 24,
        [4] = 35
    },
    [3] = {
        [1] = 10,
        [2] = 20,
        [3] = 28,
        [4] = 45
    },
    [4] = {
        [1] = 10,
        [2] = 22,
        [3] = 24,
        [4] = 35
    }
}

screen.watermark = function(self)
    local watermark = tools.animated_text(fonts.verdana, "M E T A S E T . C C", ui.accent:get(), vec2_t(screen.size.x / 2, screen.size.y - 15), 1)
    watermark()
end

screen.jitteryaw = 0
screen.bodyyaw = 0
screen.indicators = function(self)
    if ui.visuals.indicators:get() == 1 then
        return
    end
    local lplr = entity_list.get_local_player()
    if not lplr or not lplr:is_player() or not lplr:is_alive() then
        return
    end

    if engine.get_choked_commands() == 0 then
        self.bodyyaw = lplr:get_prop("m_flPoseParameter", 11) * 120 - 60
        self.jitteryaw = self.bodyyaw / 60 * (ui.visuals.desync:get() == 1 and 33 or 16)
    end

    local lerpyaw = tools.animation:new("bodyyaw", math.abs(self.bodyyaw), 15)
    local is_scoped = lplr:get_prop("m_bIsScoped") > 0
    local round = function(nr)
        return math.floor(nr)
    end

    local safepoints = menu.find("aimbot", tools.active_weapon(), "target overrides", "safepoint")[2]
    local hitchance = menu.find("aimbot", tools.active_weapon(), "target overrides", "hitchance")[2]
    local hitbox = menu.find("aimbot", tools.active_weapon(), "target overrides", "hitbox")[2]

    binds.movetext = round(tools.animation:new("offset_ind", is_scoped and 25 or 1, 10))
    binds.movetext2 = round(tools.animation:new("offset_ind", is_scoped and 40 or 1, 10))
    binds.movezay = tools.animation:new("offset_ind", is_scoped and 25 or 0, 10)
    binds.movebinds = round(tools.animation:new("offset_ind_binds", is_scoped and 14 or 1, 10))
    binds.movebinds_alt = round(tools.animation:new("offset_ind_binds_alt", is_scoped and 5 or 0, 10))
    binds.offset = 2
    binds.height = 0
    binds.amt = 0
    binds.style = ui.visuals.indicators:get()
    binds.anim = {}
    binds.anim.db = {}
    binds.list = {{"dt", refs.double_tap:get() and ui.visuals.binds:get(1), (exploits.get_max_charge() < 3 or exploits.get_charge() ~= exploits.get_max_charge()) and color_t(255, 0, 0, 250) or color_t(0, 255, 30, 200)},
                  {"hide", refs.hide_shots:get() and ui.visuals.binds:get(2), (exploits.get_max_charge() < 3 or exploits.get_charge() ~= exploits.get_max_charge()) and color_t(255, 0, 0, 250) or color_t(255, 255, 255, 200)},
                  {"dmg", refs.force_damage:get() and ui.visuals.binds:get(3), color_t(255, 255, 255, 200)}, {"hc", hitchance:get() and ui.visuals.binds:get(4), color_t(255, 255, 255, 200)},
                  {"hb", hitbox:get() and ui.visuals.binds:get(5), color_t(191, 250, 255, 255)}, {"safe", safepoints:get() and ui.visuals.binds:get(6), color_t(191, 250, 255, 255)},
                  {"fs", refs.freestand:get() and ui.visuals.binds:get(7), color_t(255, 255, 255, 200)}, {"ping", refs.ping:get() and ui.visuals.binds:get(8), color_t(132, 195, 16, 200)}}

    if ui.visuals.indicators:get() == 2 then
        if ui.visuals.elements:get(1) then
            tools.render_glow(vec2_t(screen.size.x / 2 + binds.movetext - 15, screen.size.y / 2 + self.positions[ui.visuals.indicators:get()][binds.offset] + 5), vec2_t(30, 0), 0, color_t(ui.accent:get().r, ui.accent:get().g, ui.accent:get().b, 100),
                13)
            render.rect_filled(vec2_t(screen.size.x / 2 + binds.movetext - 17, screen.size.y / 2 + self.positions[binds.style][binds.offset] + 2), vec2_t(34, 5), color_t(0, 0, 0))
            if ui.visuals.desync:get() == 1 then
                render.rect_filled(vec2_t(screen.size.x / 2 + binds.movetext - 16, screen.size.y / 2 + self.positions[binds.style][binds.offset] + 3), vec2_t(lerpyaw / 57 * 32, 3), ui.accent:get())
            else
                render.rect_filled(vec2_t(screen.size.x / 2 - 1 + binds.movetext, screen.size.y / 2 + self.positions[binds.style][binds.offset] + 3), vec2_t(self.jitteryaw, 3), ui.accent:get())
            end
            binds.offset = binds.offset + 1
        end

        if ui.visuals.elements:get(2) then
            for k, v in pairs(binds.list) do
                binds.anim.db[v[1]] = {}
                binds.anim.db[v[1]].alpha = tools.animation:new('binds_alpha_' .. v[1], v[2] and 255 or 0, 15)
                if binds.anim.db[v[1]].alpha > 1 then
                    render.text(fonts.pixel, v[1], vec2_t(screen.size.x / 2 + binds.movebinds - (is_scoped and 0 or render.get_text_size(fonts.pixel, v[1]).x / 2), screen.size.y / 2 + self.positions[binds.style][binds.offset] + binds.height),
                        color_t(v[3].r, v[3].g, v[3].b, math.floor(binds.anim.db[v[1]].alpha > 50 and binds.anim.db[v[1]].alpha / 255 * v[3].a or 0)))
                    binds.height = binds.height + math.floor(binds.anim.db[v[1]].alpha / 255 * 8 + 0.5)
                end
            end
        end

        local gradient = tools.animated_text(fonts.pixel, "STARLIGHT", ui.accent:get(), vec2_t(screen.size.x / 2 + binds.movetext + 1, screen.size.y / 2 + self.positions[binds.style][1]), 1)
        gradient()
    elseif ui.visuals.indicators:get() == 3 then
        if ui.visuals.elements:get(1) then
            local maybelerp = tools.animation:new("idkyet", render.get_text_size(fonts.pixel, "-" .. global.current_state .. "-").x / 2, 30)
            render.text(fonts.pixel, "-" .. global.current_state .. "-",
                vec2_t(screen.size.x / 2 + 1 + binds.movebinds_alt - (is_scoped and 0 or math.floor(maybelerp + 0.5)), screen.size.y / 2 + self.positions[binds.style][binds.offset] + binds.height), color_t(200, 200, 200, 200))
            binds.offset = binds.offset + 1
        end
        if ui.visuals.elements:get(2) then
            for k, v in pairs(binds.list) do
                binds.anim.db[v[1]] = {}
                binds.anim.db[v[1]].alpha = tools.animation:new('binds_alpha_' .. v[1], v[2] and 255 or 0, 15)
                if binds.anim.db[v[1]].alpha > 1 then
                    render.text(fonts.pixel, v[1], vec2_t(screen.size.x / 2 + 1 + binds.movebinds_alt - (is_scoped and 0 or render.get_text_size(fonts.pixel, v[1]).x / 2), screen.size.y / 2 + self.positions[binds.style][binds.offset] + binds.height),
                        color_t(v[3].r, v[3].g, v[3].b, math.floor(binds.anim.db[v[1]].alpha / 255 * v[3].a)))
                    binds.height = binds.height + math.floor(binds.anim.db[v[1]].alpha / 255 * 8 + 0.5)
                end
            end
        end

        local gradient = tools.animated_text(fonts.verdanabold, 'metaset', ui.accent:get(), vec2_t(screen.size.x / 2 + binds.movetext, screen.size.y / 2 + self.positions[binds.style][1]), 1)
        gradient()
    elseif ui.visuals.indicators:get() == 4 then
        if ui.visuals.elements:get(1) then
            render.rect_filled(vec2_t(screen.size.x / 2 - 24, screen.size.y / 2 + self.positions[binds.style][binds.offset]), vec2_t(46, 2), color_t(0, 0, 0, 200))
            render.rect_fade(vec2_t(screen.size.x / 2 - 24, screen.size.y / 2 + self.positions[binds.style][binds.offset]), vec2_t(lerpyaw / 57 * 46, 2), ui.accent:get(), ui.accent:get():fade(color_t(255, 255, 255), math.clamp(lerpyaw / 57, 0, 1)),
                true)
        end

        if ui.visuals.elements:get(2) then
            render.rect_filled(vec2_t(screen.size.x / 2 + 57, screen.size.y / 2 - 15), vec2_t(1, 54), color_t(0, 0, 0, 150))
            for k, v in pairs(binds.list) do
                binds.anim.db[v[1]] = {}
                binds.anim.db[v[1]].alpha = tools.animation:new('binds_alpha_' .. v[1], v[2] and 255 or 0, 15)
                if binds.anim.db[v[1]].alpha > 1 then
                    -- binds.amt = binds.amt + 1
                    render.rect_filled(vec2_t(screen.size.x / 2 + 57, screen.size.y / 2 - 15 + binds.amt), vec2_t(1, 8), color_t(255, 255, 255, math.floor(binds.anim.db[v[1]].alpha > 50 and binds.anim.db[v[1]].alpha or 0)))
                    render.text(fonts.pixel, v[1], vec2_t(screen.size.x / 2 + 60, screen.size.y / 2 - 17 + binds.height), color_t(v[3].r, v[3].g, v[3].b, math.floor(binds.anim.db[v[1]].alpha > 50 and binds.anim.db[v[1]].alpha / 255 * v[3].a or 0)))
                    binds.height = binds.height + binds.anim.db[v[1]].alpha / 255 * 8
                    binds.amt = binds.amt + binds.anim.db[v[1]].alpha / 255 * 8
                end
            end
        end

        local gradient = tools.animated_text(fonts.tahomabold, "Starlight*", ui.accent:get(), vec2_t(screen.size.x / 2 + 3, screen.size.y / 2 + self.positions[binds.style][1]), 0)
        gradient()
    end
end

configs.reload_configs = function()
    local files = filesystem.get_files()
    ui.config.list.ref:set_items(files)
end

configs.setup_configs = function()
    local exits = filesystem.is_directory(configs.dir)
    if not exits then
        filesystem.create_directory(configs.dir, "")
    end

    filesystem.write(configs.default_dir, configs.default_config)
    configs.reload_configs()
end
configs.setup_configs()

ui.config.reload = groups.configs:button("Refresh", function()
    configs.reload_configs()
end)

ui.config.input = groups.configs:text_input("Name")

ui.config.create = groups.configs:button("Create", function()
    local name = ui.config.input.ref:get()
    local dir = configs.dir .. "" .. name .. ".cfg"

    local len = string.len(name)
    if len <= 0 then
        log.add("Invalid file name")
        return
    end

    local exists = filesystem.exists(dir)
    if exists then
        log.add("Config already exists")
        return
    end

    filesystem.write(dir, "")
    ui.config.list.ref:add_item(name .. ".cfg")
    log.add("Successfully created config")
end)

ui.config.delete = groups.configs:button("Delete", function()
    local active = ui.config.list.ref:get_active_item_name()
    local dir = configs.dir .. "" .. active

    if active == "default.cfg" then
        log.add("You can't delete default config")
        return
    end

    local exists = filesystem.exists(dir)
    if not exists then
        log.add("Config file doesn't exist")
        return
    end

    filesystem.delete(dir, "game")
    ui.config.list.ref:remove_item(active)
    log.add("Successfully deleted config")
end)

ui.config.save = groups.configs:button("Save", function()
    local cur = ui.config.list.ref:get_active_item_name()
    if cur == "default.cfg" then
        log.add("Can't save to default config")
        return
    end

    local dir = configs.dir .. "" .. cur
    local exists = filesystem.exists(dir)
    if not exists then
        log.add("Config file doesn't exist")
        return
    end

    local config = eui.export()
    config = base64.encode(config)
    filesystem.write(dir, config)
    log.add("Successfully saved config")
end)

ui.config.load = groups.configs:button("Load", function()
    local cur = ui.config.list.ref:get_active_item_name()
    local dir = configs.dir .. "" .. cur

    local exists = filesystem.exists(dir)
    if not exists then
        log.add("Invalid file path")
        return
    end

    local config = filesystem.read(dir)
    config = base64.decode(config)
    -- print(config)
    local tmp = ui.nav.slider:get()
    local success, err = pcall(eui.import, config)
    ui.nav.slider.ref:set(tmp)

    if success then
        log.add("Config successfully loaded")
        dragsystem.on_config_load()
    else
        log.add("Config failed to load: " .. err)
    end
end)

ui.config.import = groups.configs:button("Import", function()
    local data = clipboard.get()
    local success, result = pcall(base64.decode, data)
    if not success then
        log.add("Invalid config (did u copy it correctly?)")
    else
        data = base64.decode(data)
    end
    local tmp = ui.nav.slider:get()
    local success, result = pcall(eui.import, data)
    if not success then
        log.add("Invalid config: " .. result)
    else
        log.add("Loaded config!")
    end
    ui.nav.slider.ref:set(tmp)
end)

ui.config.export = groups.configs:button("Export", function()
    local data = eui.export()
    -- print(data)
    data = base64.encode(data)
    -- print(data)

    clipboard.set(data)
end)

builder.defensiveinvert = false
builder.defensiveold = false
builder.delayinvert = true
builder.delaytarget = 0
builder.legbreak = 0
builder.currentpitch = -89
builder.currentyaw = -60
builder.goalpitch = 0
builder.goalyaw = 0
builder.speen = 0
builder.save_yaw = 0
builder.misses = 0
builder.warmup = game_rules.get_prop("m_bWarmupPeriod")
builder.onpeek = false
builder.afk_valid = false
builder.afk = 0

builder.speeen = function(speed)
    builder.speen = builder.speen + speed / 2
    if builder.speen < -180 then
        builder.speen = builder.speen + 360
    elseif builder.speen > 180 then
        builder.speen = builder.speen - 360
    end
    return builder.speen
end

builder.clockpitch = function()
    if builder.currentpitch <= -88 then
        builder.goalpitch = 89
    elseif builder.currentpitch >= 88 then
        builder.goalpitch = -89
    end
    builder.currentpitch = tools.lerp(builder.currentpitch, builder.goalpitch, 0.10)
end

builder.clockyaw = function()
    if builder.currentyaw <= -59 then
        builder.goalyaw = 60
    elseif builder.currentyaw >= 59 then
        builder.goalyaw = -60
    end
    builder.currentyaw = tools.lerp(builder.currentyaw, builder.goalyaw, 0.10)
end

handles.builder = function(ctx, cmd)
    refs.overridemove:set(false)
    refs.overridemovesw:set(false)
    local currentstate = ui.antiaim.builder[global.current_state_number].override:get() and global.current_state_number or 1
    local anti_aim = ui.antiaim.builder[currentstate]

    local lplr = entity_list.get_local_player()
    if not lplr or not lplr:is_player() or not lplr:is_alive() then
        return
    end
    local abs_origin = lplr:get_prop('m_vecAbsOrigin')
    local local_vel = lplr:get_prop("m_vecVelocity")
    local local_wep = lplr:get_active_weapon()
    local int_vel = local_vel:length()
    local localmod = vec3_t(local_vel.x / 2, local_vel.y / 2, local_vel.z / 2)
    local bodyyaw = lplr:get_prop("m_flPoseParameter", 11) * 120 - 60
    local side = bodyyaw > 0 and 1 or -1
    local defensive_safe = ui.antiaim.builder.defensive_ping:get() == 1
    local primside = antiaim.get_desync_side() > 1 and 1 or -1
    if builder.defensiveold ~= defensive:is_active(lplr, defensive_safe) and defensive:is_active(lplr, defensive_safe) == false then
        builder.defensiveinvert = not builder.defensiveinvert
    end

    builder.warmup = game_rules.get_prop("m_bWarmupPeriod")
    local players = entity_list.get_players(true)
    local enemies = 0
    local visible = false
    local knifed = false
    local defensiveaa = (anti_aim.trigger_defensive:get() == 2 or anti_aim.trigger_defensive:get() == 4)
    local canbedefensive = refs.double_tap:get() and (exploits.get_charge() == exploits.get_max_charge()) and not refs.fake_duck:get()

    if game_rules.get_prop("m_gamePhase") == 4 or game_rules.get_prop("m_gamePhase") == 5 then
        refs.pitch:set(1)
        refs.yawbase:set(1)
        refs.jittermode:set(1)
        refs.desyncside:set(0)
        refs.fsstate:set(1, false)
        refs.fsstate:set(2, false)
        refs.fsstate:set(3, false)
        return
    end

    refs.fsstate:set(1, true)
    refs.fsstate:set(2, true)
    refs.fsstate:set(3, true)

    local should_safe = 0

    builder.anti_bruteforce = {
        [0] = {
            sides = {-120, 120},
            pitch = {-90, -90},
            mode = 1
        },
        [1] = {
            sides = {80, 80},
            pitch = {0, 0},
            mode = 2
        },
        [2] = {
            sides = {-90, -90},
            pitch = {math.random(-45, 60), math.random(-45, 60)},
            mode = 0
        },
        [3] = {
            sides = {90, 90},
            pitch = {math.random(-45, 60), math.random(-45, 60)},
            mode = 0
        }
    }

    builder.onpeek = anti_aim.trigger_defensive:get() == 2

    for _, player in pairs(players) do
        if player:is_alive() and player:is_player() then
            enemies = enemies + 1

            if anti_aim.trigger_defensive:get() == 2 then
                if not player:is_dormant() then
                    local vel = player:get_prop("m_vecVelocity")
                    -- local origin = player:get_render_origin()
                    local origin = player:get_eye_position()
                    local tickinterval = globals.interval_per_tick()
                    if not vel or not origin then
                        return
                    end
                    local ticks_to_predict = 3

                    local mod = vec3_t(vel.x * tickinterval * ticks_to_predict, vel.y * tickinterval * ticks_to_predict, vel.z * tickinterval * ticks_to_predict)
                    -- debug_overlay.add_line(origin, origin + mod, color_t(255, 255, 255), true, 0.05)

                    local traced = trace.bullet(origin + mod, abs_origin, lplr, player)
                    local tracent = trace.bullet(abs_origin + localmod, player:get_hitbox_pos(e_hitboxes.BODY), lplr, player)

                    -- wtf was i doing at 3:29 am???
                    --[[ or (lplr:is_point_visible(player:get_hitbox_pos(e_hitboxes.CHEST)) or lplr:is_point_visible(player:get_hitbox_pos(e_hitboxes.NECK)) or lplr:is_point_visible(origin))]]
                    if (traced.valid and traced.damage > 3) or (tracent.valid and tracent.damage > 3) then
                        visible = true
                    end
                end
            end
            if ui.antiaim.features.antibackstab:get() then
                if not player:is_dormant() then
                    local enemyweapon = player:get_active_weapon()
                    if enemyweapon ~= nil then
                        if enemyweapon:get_class_name() == "CKnife" then
                            if lplr:get_render_origin():dist(player:get_render_origin()) < 250 then
                                knifed = player
                            end
                        end
                    end
                end
            end
        end
    end
    if not ui.antiaim.builder.enable:get() then
        return
    end
    if (ui.antiaim.features.warmup:get(1) and enemies == 0) or (builder.warmup and ui.antiaim.features.warmup:get(2) and builder.warmup > 0) then
        if (lplr:get_prop("m_bInBombZone") == 1) and cmd:has_button(e_cmd_buttons.USE) then
            return
        end
        exploits.force_anti_exploit_shift(true)
        refs.yawadd:set(0)
        refs.pitch:set(4)
        refs.jittermode:set(2)
        refs.rotate:set(true)
        refs.rotaterange:set(360)
        refs.rotatespeed:set(75)
        refs.desyncside:set(5)
        return
    end

    refs.jittertype:set(2)
    refs.rotate:set(false)
    refs.pitch:set(ui.antiaim.builder.pitch:get())
    refs.yawbase:set(ui.antiaim.builder.yaw:get() + 1)
    refs.leftamount:set(anti_aim.fake_left:get() / 60 * 100)
    refs.rightamount:set(anti_aim.fake_right:get() / 60 * 100)

    if anti_aim.yaw_modifier:get() ~= 1 then
        refs.jittermode:set(2)
        refs.jittertype:set(anti_aim.yaw_modifier:get() - 1)
        refs.jitterrange:set(anti_aim.modifier_degree:get() * -1 + anti_aim.modifier_random:get())
    else
        refs.jittermode:set(1)
    end

    if ui.antiaim.features.safehead:get("knife air c") then
        local weapon = entity_list.get_entity(lplr:get_prop("m_hActiveWeapon"))
        if weapon ~= nil then
            local weapon_name = weapon:get_name()
            if weapon_name == "knife" then
                if global.current_state == "air duck" then
                    ctx:set_pitch(90)
                    refs.yawadd:set(0)
                    refs.desyncside:set(2)
                    refs.leftamount:set(0)
                    refs.jittermode:set(1)
                    refs.rotate:set(false)

                    should_safe = ui.antiaim.features.safehead:get("allow defensive") and 2 or 1
                end
            end
        end
    end

    if should_safe == 0 then
        if anti_aim.yaw_mode:get() == 1 then
            refs.yawadd:set(anti_aim.yaw_value:get())
            refs.desyncside:set(anti_aim.desync:get() + 1)
        elseif anti_aim.yaw_mode:get() == 2 then
            if anti_aim.yaw_delay:get() == 2 then
                refs.yawadd:set(antiaim.get_desync_side() > 1 and anti_aim.yaw_left:get() or anti_aim.yaw_right:get())
                refs.desyncside:set(anti_aim.desync:get() + 1)
            else
                if engine.get_choked_commands() == 0 then
                    if globals.tick_count() > builder.delaytarget then
                        builder.delaytarget = globals.tick_count() + anti_aim.yaw_delay:get()
                        builder.delayinvert = not builder.delayinvert
                    end

                    refs.desyncside:set(builder.delayinvert and 2 or 3)
                    refs.yawadd:set(builder.delayinvert and anti_aim.yaw_left:get() or anti_aim.yaw_right:get())
                end
            end
        elseif anti_aim.yaw_mode:get() == 3 then
            local left = anti_aim.yaw_left:get() + math.random(0, anti_aim.meta_left:get())
            local right = anti_aim.yaw_right:get() + math.random(0, anti_aim.meta_right:get())
            if anti_aim.yaw_delay:get() == 2 and anti_aim.meta_delay:get() == 0 then
                refs.yawadd:set(antiaim.get_desync_side() > 1 and left or right)
                refs.desyncside:set(anti_aim.desync:get() + 1)
            else
                if engine.get_choked_commands() == 0 then
                    if globals.tick_count() > builder.delaytarget then
                        builder.delaytarget = globals.tick_count() + anti_aim.yaw_delay:get() + math.random(0, anti_aim.meta_delay:get())
                        builder.delayinvert = not builder.delayinvert
                    end

                    refs.desyncside:set(builder.delayinvert and 2 or 3)
                    refs.yawadd:set(builder.delayinvert and left or right)
                end
            end
        end
    end

    if anti_aim.trigger_defensive:get() == 2 and visible then
        defensive:trigger()
    elseif anti_aim.trigger_defensive:get() > 2 then
        defensive:trigger()
    end

    if not (should_safe == 1) then
        if defensive:is_active(lplr, defensive_safe) and canbedefensive and defensiveaa then
            if anti_aim.defensive_pitch:get() == 10 then
                ctx:set_pitch(builder.currentpitch)
            elseif anti_aim.defensive_pitch:get() == 7 then
                ctx:set_pitch(math.random(anti_aim.defensive_pitch_val:get(), anti_aim.defensive_pitch_val2:get()))
            elseif anti_aim.defensive_pitch:get() == 8 then
                ctx:set_pitch(anti_aim.defensive_pitch_val:get())
            elseif anti_aim.defensive_pitch:get() == 9 then
                ctx:set_pitch(builder.defensiveinvert and anti_aim.defensive_pitch_val:get() or anti_aim.defensive_pitch_val2:get())
            elseif anti_aim.defensive_pitch:get() > 1 then
                refs.pitch:set(anti_aim.defensive_pitch:get() - 1)
            end

            if anti_aim.defensive_yaw:get() == 2 then
                if currentstate == 11 then
                    ctx:set_yaw(builder.save_yaw + (60 * primside) - anti_aim.defensive_yaw_val:get())
                else
                    refs.yawadd:set(anti_aim.defensive_yaw_val:get())
                end
            elseif anti_aim.defensive_yaw:get() == 3 then
                refs.desyncside:set(4)
                refs.yawadd:set(anti_aim.defensive_yaw_val:get() * primside)
            elseif anti_aim.defensive_yaw:get() == 4 then
                refs.yawadd:set(globals.server_tick() % 24 > 11 and -anti_aim.defensive_yaw_val:get() or anti_aim.defensive_yaw_val:get())
                refs.desyncside:set(globals.server_tick() % 24 > 11 and 2 or 3)
            elseif anti_aim.defensive_yaw:get() == 5 then
                ctx:set_yaw(builder.speeen(ui.antiaim.builder[currentstate].defensive_yaw_val:get()))
                refs.desyncside:set(5)
            elseif anti_aim.defensive_yaw:get() == 5 then
                ctx:set_yaw(builder.speeen(ui.antiaim.builder[currentstate].defensive_yaw_val:get()))
                refs.desyncside:set(5)
            elseif anti_aim.defensive_yaw:get() == 6 then
                ctx:set_yaw(math.random(0, 360))
            elseif ui.antiaim.builder[currentstate].defensive_yaw:get() == 7 then
                refs.jittermode:set(2)
                refs.jittertype:set(4)
                refs.jitterrange:set(180)
                refs.desyncside:set(4)
            elseif ui.antiaim.builder[currentstate].defensive_yaw:get() == 8 then
                refs.yawadd:set(builder.currentyaw)
                refs.desyncside:set(builder.goalyaw < 0 and 3 or 2)
            end
        end

        if not (defensive:is_active(lplr, true, true).tick > globals.tick_count()) then
            builder.save_yaw = antiaim.get_real_angle()
        end

        if anti_aim.trigger_defensive:get() == 5 then
            if canbedefensive then
                if defensive:is_active(lplr, defensive_safe) then
                    local side = antiaim.get_desync_side() > 1 and 1 or 2

                    ctx:set_pitch(builder.anti_bruteforce[builder.misses].pitch[side])
                    if builder.anti_bruteforce[builder.misses].mode == 1 then
                        refs.jittermode:set(2)
                        refs.jittertype:set(2)
                        refs.yawadd:set(0)
                        refs.jitterrange:set(builder.anti_bruteforce[builder.misses].sides[1])
                    elseif builder.anti_bruteforce[builder.misses].mode == 0 then
                        refs.yawadd:set(builder.anti_bruteforce[builder.misses].sides[side])
                    elseif builder.anti_bruteforce[builder.misses].mode == 2 then
                        ctx:set_yaw(builder.speeen(builder.anti_bruteforce[builder.misses].sides[side]))
                    end
                end
            end
        end
    end

    local forward = cmd:has_button(e_cmd_buttons.FORWARD)
    local right = cmd:has_button(e_cmd_buttons.MOVERIGHT)
    local left = cmd:has_button(e_cmd_buttons.MOVELEFT)
    local use = cmd:has_button(e_cmd_buttons.USE)
    local inbombzone = lplr:get_prop("m_bInBombZone")
    local speed = math.vec_length2d(local_vel)
    local ivgleft = speed / 80 * 2
    local ivgright = speed / 80 * 10

    -- del ~= 2 and (side == 1 and (menu.antiaim.builder[currentstate].advanced1:get() + side_offset * 0.8) or (menu.antiaim.builder[currentstate].advanced2:get() + side_offset * 0.1)) or (side == 1 and menu.antiaim.builder[currentstate].advanced1:get() +  -side_offset or menu.antiaim.builder[currentstate].advanced2:get() + side_offset))

    if knifed ~= false then
        ctx:set_yaw(math.yaw_to_player(knifed, true))
        refs.rotate:set(false)
        refs.desyncside:set(2)
        refs.leftamount:set(0)
    end

    if ui.antiaim.features.correction:get("yaw") and (global.current_state_number == 5 or global.current_state_number == 6) then
        if not defensive:is_active(lplr, defensive_safe) then
            if right and forward then
                refs.yawadd:set(refs.yawadd:get() + ivgright * (ui.antiaim.builder[currentstate].yaw_mode:get() == 3 and 1 or 1.3))
            end
            if left and forward then
                refs.yawadd:set(refs.yawadd:get() - ivgleft)
            end
        end
    end
    builder.defensiveold = defensive:is_active(lplr, defensive_safe)
end

local misstable = {}

events.detectmiss = function(event)
    if event.name == "bullet_impact" then
        if not event.userid then
            return
        end
        local lplr = entity_list.get_local_player()
        if not lplr or not lplr:is_player() or not lplr:is_alive() then
            return
        end
        local entity = entity_list.get_player_from_userid(event.userid)
        if not entity or not entity:is_player() or not entity:is_enemy() then
            return
        end

        local bullet_impact = vec3_t(event.x, event.y, event.z)
        local eye_pos = entity:get_eye_position()
        if not eye_pos then
            return
        end

        misstable[#misstable + 1] = eye_pos:dist(bullet_impact)
        local localrecord = eye_pos:dist(bullet_impact)
        local localorigin = eye_pos
        client.delay_call(function()
            if localrecord == misstable[#misstable] then
                if not lplr or not lplr:is_valid() or not lplr:is_player() or not lplr:is_alive() then
                    return
                end
                local local_eye_pos = lplr:get_eye_position()
                if not local_eye_pos then
                    return
                end

                local distance_between = tools.closest_point_on_ray(eye_pos, bullet_impact, local_eye_pos):dist(local_eye_pos)

                if distance_between < 50 then
                    builder.misses = builder.misses < #builder.anti_bruteforce and builder.misses + 1 or 0
                    log.add(3, "Defensive updated: phase " .. builder.misses)
                end
                misstable = {}
            end
        end, 0.01)
    end
end

handles.legs = function(ctx)
    if ui.antiaim.breakers.ground:get() == 1 then
        return
    end
    -- print(ctx.command_number % 3 == 0)
    if ui.antiaim.breakers.ground:get() == 5 then
        refs.legslide:set(ctx.command_number % 6 == 0 and 2 or 3)
    elseif ui.antiaim.breakers.ground:get() == 2 then
        refs.legslide:set(3)
    elseif ui.antiaim.breakers.ground:get() == 3 then
        refs.legslide:set(2)
    elseif ui.antiaim.breakers.ground:get() == 4 then
        refs.legslide:set(ctx.command_number % 3 == 0 and 1 or 3)
    end
end

local pitchtime = 0
handles.breaker = function(ctx, cmd)
    if not engine.is_connected() or not engine.is_in_game() then
        return
    end
    local lplr = entity_list.get_local_player()
    if not lplr then
        return
    end
    local flags = lplr:get_prop("m_fFlags")
    local airborne = bit.band(flags, bit.lshift(1, 0)) == 0
    if not airborne then
        if ui.antiaim.breakers.ground:get() == 5 then
            ctx:set_render_pose(e_poses.STAND, cmd.command_number % 4 > 1 and 0.7 or 1)
            ctx:set_render_pose(e_poses.RUN, cmd.command_number % 4 > 1 and 0.7 or 1)
        elseif ui.antiaim.breakers.ground:get() == 2 then
            if global.velocity > 10 then
                ctx:set_render_pose(e_poses.RUN, 0)
            end
        elseif ui.antiaim.breakers.ground:get() == 3 then
            if global.velocity > 10 then
                ctx:set_render_pose(e_poses.MOVE_YAW, 0)
                ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 1)
            end
        elseif ui.antiaim.breakers.ground:get() == 4 then
            ctx:set_render_pose(e_poses.RUN, client.random_float(0.8, 1))
        end
    else
        if ui.antiaim.breakers.air:get() == 2 then
            ctx:set_render_pose(e_poses.JUMP_FALL, 1)
        elseif ui.antiaim.breakers.air:get() == 3 then
            if global.velocity > 10 then
                refs.legslide:set(2)
                ctx:set_render_pose(e_poses.MOVE_YAW, 0)
                ctx:set_render_pose(e_poses.JUMP_FALL, 1)
                ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 1)
            end
        elseif ui.antiaim.breakers.air:get() == 4 then
            ctx:set_render_pose(e_poses.JUMP_FALL, client.random_float(0, 1))
            ctx:set_render_pose(e_poses.MOVE_YAW, client.random_float(0, 1))
            ctx:set_render_pose(e_poses.SPEED, client.random_float(0, 1))
        end
    end

    if ui.antiaim.breakers.extra:get(2) then
        if global.velocity > 10 then
            ctx:set_render_animlayer(e_animlayers.LEAN, ui.antiaim.breakers.lean:get() / 100)
        end
    end
    if airborne then
        pitchtime = globals.cur_time() + 0.5
    end
    if not airborne then
        if ui.antiaim.breakers.extra:get(1) and (pitchtime > globals.cur_time()) then
            ctx:set_render_pose(e_poses.BODY_PITCH, 0.5)
        end
    end
end

handles.ladder = function(cmd)
    if not (ui.misc.fastladder:get(1) or ui.misc.fastladder:get(2)) then
        return
    end
    if refs.nadehelper:get() then
        return
    end
    local lplr = entity_list.get_local_player()
    if not lplr or not lplr:is_player() or not lplr:is_alive() then
        return
    end
    if not (lplr:get_prop("m_MoveType") == 9) then
        return
    end

    local weapon = lplr:get_active_weapon()
    if not weapon then
        return
    end

    local data = weapon:get_weapon_data()
    if not data then
        return
    end

    if data.type == 9 or cmd:has_button(e_cmd_buttons.ATTACK) then
        return
    end

    local pitch = engine.get_view_angles()
    local niggaslifer_value = 0
    local abs_value = math.abs(niggaslifer_value)

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
    elseif cmd.move.x > 0 and ui.misc.fastladder:get(1) then
        if pitch.x < 45 then
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
    elseif cmd.move.x < 0 and ui.misc.fastladder:get(2) then
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

events.calculatefall = function(length)
    local lplr = entity_list.get_local_player()
    local x, y, z = lplr:get_render_origin().x, lplr:get_render_origin().y, lplr:get_render_origin().z
    local max_radias = math.pi * 2
    local step = max_radias / 8

    for a = 0, max_radias, step do
        local ptX, ptY = ((10 * math.cos(a)) + x), ((10 * math.sin(a)) + y)
        local traced = trace.line(vec3_t(ptX, ptY, z), vec3_t(ptX, ptY, z - length), lplr)
        local fraction, entity = traced.fraction, traced.entity

        if fraction ~= 1 then
            return true
        end
    end
    return false
end

handles.nofall = function(cmd)
    if not ui.misc.nofall:get() then
        return
    end

    local lplr = entity_list.get_local_player()
    local no_fall_damage = nil

    if lplr == nil then
        return
    end

    if lplr:get_prop("m_vecVelocity").z >= -500 then
        no_fall_damage = false
    else
        if events.calculatefall(15) then
            no_fall_damage = false
        elseif events.calculatefall(75) then
            no_fall_damage = true
        end
    end

    if lplr:get_prop("m_vecVelocity").z < -500 then
        if no_fall_damage then
            cmd:add_button(e_cmd_buttons.DUCK)
        else
            cmd:remove_button(e_cmd_buttons.DUCK)
        end
    end
end

toss.ang_vec = function(ang)
    return vec3_t(math.cos(ang.x * math.pi / 180) * math.cos(ang.y * math.pi / 180), math.cos(ang.x * math.pi / 180) * math.sin(ang.y * math.pi / 180), -math.sin(ang.x * math.pi / 180))
end

toss.target_angles = vec3_t(0, 0, 0)

handles.toss = function(cmd)
    if ui.misc.supertoss:get() == 1 then
        return
    end
    if refs.nadehelper:get() then
        return
    end
    local lplr = entity_list.get_local_player()
    if not lplr or not lplr:is_player() or not lplr:is_alive() then
        return
    end
    if (lplr:get_prop("m_MoveType") == 9) then
        return
    end
    local weapon = lplr:get_active_weapon()
    if not weapon then
        return
    end

    local data = weapon:get_weapon_data()
    if not data then
        return
    end
    toss.lastangles = engine.get_view_angles()

    if not weapon:get_prop("m_flThrowStrength") then
        return
    end

    local ang_throw = vec3_t(cmd.viewangles.x, toss.lastangles.y, 0)
    ang_throw.x = ang_throw.x - (90 - math.abs(ang_throw.x)) * 10 / 90
    ang_throw = toss.ang_vec(ang_throw)

    local throw_strength = math.clamp(weapon:get_prop("m_flThrowStrength"), 0, 1)
    local fl_velocity = math.clamp(data.throw_velocity * 0.9, 15, 750)
    fl_velocity = fl_velocity * (throw_strength * 0.7 + 0.3)
    fl_velocity = vec3_t(fl_velocity, fl_velocity, fl_velocity)

    -- client.log_screen(fl_velocity)

    local localplayer_velocity = lplr:get_prop('m_vecVelocity')
    local vec_throw = (ang_throw * fl_velocity + localplayer_velocity * vec3_t(1.45, 1.45, 1.45))
    vec_throw = vec_throw:to_angle()
    local yaw_difference = toss.lastangles.y - vec_throw.y
    while yaw_difference > 180 do
        yaw_difference = yaw_difference - 360
    end
    while yaw_difference < -180 do
        yaw_difference = yaw_difference + 360
    end
    local pitch_difference = toss.lastangles.x - vec_throw.x - 10
    while pitch_difference > 90 do
        pitch_difference = pitch_difference - 45
    end
    while pitch_difference < -90 do
        pitch_difference = pitch_difference + 45
    end

    toss.target_angles.y = toss.lastangles.y + yaw_difference
    toss.target_angles.x = math.clamp(toss.lastangles.x + pitch_difference, -89, 89)

    cmd.viewangles.y = toss.target_angles.y
    if ui.misc.supertoss:get() == 2 then
        local flags = lplr:get_prop("m_fFlags")
        local airborne = bit.band(flags, bit.lshift(1, 0)) == 0
        if airborne then
            cmd.viewangles.x = toss.target_angles.x
        end
    elseif ui.misc.supertoss:get() == 4 then
        cmd.viewangles.x = toss.target_angles.x
    end
end

avoid_collisions.vector = function(angle_x, angle_y)
    local sp, sy, cp, cy = nil
    sp = math.sin(math.rad(angle_x));
    sy = math.sin(math.rad(angle_y));
    cp = math.cos(math.rad(angle_x));
    cy = math.cos(math.rad(angle_y));
    return vector(cp * cy, cp * sy, -sp);
end

avoid_collisions.velocity = function(player)
    if (player == nil) then
        return
    end
    local vec = player:get_prop("m_vecVelocity")
    local velocity = vec:length()
    return velocity
end

handles.avoid_collisions = function(cmd)
    local lp = entity_list.get_local_player()
    if not lp then
        return
    end
    local m_vecVelocity = lp:get_prop('m_vecVelocity')
    local velocity = math.vec_length2d(m_vecVelocity)
    if velocity < ui.misc.avoid_collisions_vel:get() then
        return
    end
    if not ui.misc.avoid_collisions:get() then
        return
    end

    local dm = ui.misc.avoid_collisions_dist:get()
    local camera_angles = engine.get_view_angles()
    local yaw = camera_angles.y
    local l = lp:get_render_origin()
    local min = math.huge
    local val = math.huge
    for i = 1, 45 do
        local dir_x = avoid_collisions.vector(0, (yaw + i * 4 - 90)).x
        local dir_y = avoid_collisions.vector(0, (yaw + i * 4 - 90)).y
        local dir_z = avoid_collisions.vector(0, (yaw)).z
        local end_x = l.x + dir_x * 70
        local end_y = l.y + dir_y * 70
        local end_z = l.z + 60
        local tracer = trace.line(l, vector(end_x, end_y, end_z), lp, nil, 1)
        local totaldist = l:dist(vector(end_x, end_y, end_z)) * tracer.fraction
        local difference = vector(end_x, end_y, end_z) - vector(l.x, l.y, l.z)
        local fraction = vector(tracer.fraction, tracer.fraction, tracer.fraction)
        local traveled = (vector(end_x, end_y, end_z) - l) * fraction
        -- print(traveled:length())
        -- debug_overlay.add_line((vector(end_x, end_y, end_z) - l) * fraction + l, l, color(255, 255, 255), true, 0.02)
        if (traveled:length() < min) and not (tracer.entity and tracer.entity:is_player()) then
            -- print(1)
            min = traveled:length()
            val = i * 4
        end
    end
    local flags = lp:get_prop('m_fFlags')
    local ducking = bit.lshift(1, 1)
    local ground = bit.lshift(1, 0)
    local jump = bit.band(flags, ground) == 0
    local moveleft = cmd:has_button(e_cmd_buttons.MOVELEFT)
    local moveright = cmd:has_button(e_cmd_buttons.MOVERIGHT)
    local back = cmd:has_button(e_cmd_buttons.BACK)
    if (min < 25 + dm and jump and not (moveright or moveleft or back)) then
        -- print(min)
        forward_velo = math.abs(avoid_collisions.velocity(lp) * math.cos(math.rad(val)))
        if (math.abs(val - 90) < 40) then
            side_velo = avoid_collisions.velocity(lp) * math.sin(math.rad(val)) * (25 + dm - min) / 15
        else
            side_velo = avoid_collisions.velocity(lp) * math.sin(math.rad(val))
        end
        cmd.move.x = forward_velo
        -- print(forward_velo)
        if (val >= 90) then
            cmd.move.y = side_velo
        else
            cmd.move.y = side_velo * -1
        end
    end
end

local localdists = {}
local origin = vec3_t(0, 0, 0)

handles.bulletlog = function()
    local lplr = entity_list.get_local_player()
    if not lplr then
        return
    end
    if not ui.visuals.bullets:get() then
        return
    end
    origin = lplr:get_eye_position()
end

events.bullets = function(e)
    if not ui.visuals.bullets:get() then
        return
    end
    if e.name == "bullet_impact" then
        local lplr = entity_list.get_local_player()
        if not lplr then
            return
        end
        local bulletent = entity_list.get_player_from_userid(e.userid)
        if not bulletent then
            return
        end
        if bulletent ~= lplr then
            return
        end

        local endpoint = vec3_t(e.x, e.y, e.z)
        if not endpoint or not origin then
            return
        end
        localdists[#localdists + 1] = origin:dist(endpoint)
        local localrecord = origin:dist(endpoint)
        local localorigin = origin
        client.delay_call(function()
            if localrecord == localdists[#localdists] then
                -- print("is prost")
                debug_overlay.add_line(localorigin, endpoint, ui.visuals.bulletcol:get(), true, 3)
                localdists = {}
            end
        end, 0.01)
    end
end

backup.fakelag = 15

handles.onshot = function(ctx)
    local lplr = entity_list.get_local_player()
    if not lplr or not lplr:is_player() or not lplr:is_alive() then
        return
    end
    local tk = global_vars.interval_per_tick() * 4
    local wp = lplr:get_active_weapon()
    if not wp then
        return
    end
    local aw = wp ~= nil and global_vars.cur_time() < wp:get_prop("m_fLastShotTime") + tk
    if refs.hide_shots:get() then
        refs.fake_lag_value:set(15)
        return
    end
    if refs.double_tap:get() and not refs.ap:get() then
        if ((exploits.get_charge() < exploits.get_max_charge()) or (exploits.get_max_charge() == 0)) and (ui.rage.tplag:get()) and (not refs.fake_duck:get()) and (global.velocity > 3) then
            refs.fake_lag_value:set(0)
        else
            refs.fake_lag_value:set(15)
        end
        -- if ui.antiaim.features.fakelag:get() then
        --     refs.fake_lag_value:set(aw and 0 or backup.fakelag)
        -- end
    elseif not refs.double_tap:get() then
        refs.fake_lag_value:set(15)
    end
    if not aw then
        backup.realangle = antiaim.get_real_angle()
    end
    if (aw and ui.antiaim.features.fakelag:get()) then
        refs.desyncside:set(1)
        if wp:get_name() == "ssg08" or wp:get_name() == "awp" or wp:get_name() == "revolver" then
            ctx:set_yaw(backup.realangle)
        end
    end
    if global.velocity < 3 then
        return
    end
    if not (engine.get_choked_commands() <= refs.fake_lag_value:get()) then
        return
    end

    if log.nextchoke == true then
        ctx:set_fakelag(false)
        log.nextchoke = false
    else
        ctx:set_fakelag(not (aw and ui.antiaim.features.fakelag:get()))
    end
end

handles.esp = function(ctx)
    if ui.visuals.esp:get() == 2 then
        ctx:set_font(fonts.pixel)
    elseif ui.visuals.esp:get() == 3 then
        ctx:set_font(fonts.verdana_b)
    elseif ui.visuals.esp:get() == 4 then
        ctx:set_font(fonts.tahoma)
    elseif ui.visuals.esp:get() == 5 then
        ctx:set_font(fonts.tahomabold)
    elseif ui.visuals.esp:get() == 6 then
        ctx:set_font(fonts.tahoma)
    end

    if menu.is_open() then
        refs.health:set(2, ui.visuals.health:get() == 1)
        refs.health:set(1, ui.visuals.health:get() == 1)
    end

    local lplr = entity_list.get_local_player()
    if not lplr or not lplr:is_valid() or not lplr:is_player() then
        return
    end

    if ui.visuals.health:get() == 1 then
        return
    end
    local color1 = ui.visuals.healthcolor1:get()
    local color2 = ui.visuals.healthcolor2:get()
    if not ctx.render_origin or not render.world_to_screen(ctx.render_origin) then
        return
    end
    local x1, y1 = ctx.bbox_start.x, ctx.bbox_start.y
    if not ctx.bbox_start or not x1 or not y1 then
        return
    end
    if (x1 > render.get_screen_size().x - 5) or (x1 < 3) then
        return
    end
    local x2, y2 = ctx.bbox_size.x + x1, ctx.bbox_size.y + y1
    if not ctx.bbox_size or not x2 or not y2 then
        return
    end
    if (x2 > render.get_screen_size().x - 5) or (x2 < 3) then
        return
    end
    local a = ctx.alpha_modifier
    local height = y2 - y1
    local width = x2 - x1
    local leftside = x1 - (width / 12)
    local hp = ctx.player:get_prop("m_iHealth")
    if hp == nil then
        return
    end

    local r, g, b = color1.r, color1.g, color1.b
    local r2, g2, b2 = color2.r, color2.g, color2.b

    if ui.visuals.health:get() ~= 1 then
        render.rect_filled(vector(leftside - 1, y1 - 1), vector(4, height + 1), color(20, 20, 20, math.floor(220 * ctx.alpha_modifier)))
        if ui.visuals.health:get() == 2 then
            render.rect_filled(vector(leftside, y2 - (height * hp / 100)), vector(2, height * hp / 100 - 1), color(r, g, b, math.floor(255 * ctx.alpha_modifier)))
        elseif ui.visuals.health:get() == 3 then
            render.rect_fade(vector(leftside, y2 - (height * hp / 100)), vector(2, height * hp / 100 - 1), color(r, g, b, math.floor(40 * ctx.alpha_modifier)), color(r, g, b, math.floor(255 * ctx.alpha_modifier)), false)
        elseif ui.visuals.health:get() == 4 then
            render.rect_fade(vector(leftside, y2 - (height * hp / 100)), vector(2, height * hp / 100 - 1), color(r, g, b, math.floor(255 * ctx.alpha_modifier)), color(r2, g2, b2, math.floor(255 * ctx.alpha_modifier)), false)
        end
        if hp < 94 and hp > 0 then
            render.text(fonts.pixel, tostring(hp), vector(leftside, y2 - (height * hp / 100)), color(255, 255, 255, math.floor(255 * ctx.alpha_modifier)), true)
        end
    end
end

screen.gradient = function(x, y, w, h, col1, col2)
    render.rect_fade(vec2_t(x, y - 4), vec2_t(w / 4, h), col2, col1, true)
    render.rect_fade(vec2_t(x + (w / 4), y - 4), vec2_t(w / 4, h), col1, col2, true)
end

screen.gamesense_indicators = function()
    local lplr = entity_list.get_local_player()
    if not lplr or not lplr:is_valid() or not lplr:is_player() or not lplr:is_alive() then
        return
    end

    local pos = vec2_t(screen.size.x * 0.00741666666 + 16, screen.size.y * 0.67777777777)
    local addpos = vec2_t(0, 40)
    local function add_indicator(str, color)
        local text_size = render.get_text_size(fonts.dollars, str)
        screen.gradient(15, pos.y - 2, (text_size.x * 2.3) + 30, 33, color_t(0, 0, 0, 40), color_t(0, 0, 0, 0))
        render.text(fonts.dollars, str, pos, color)
        pos = pos - addpos
    end

    local gray = color(200, 199, 197, 255)
    local red = color(255, 0, 50)
    local green = color(163, 194, 43)

    local options = ui.visuals.gamesense_indicators
    local dmg_ovr = menu.find("aimbot", tools.active_weapon(), "target overrides", "min. damage")[2]:get()
    local hc_ovr = menu.find("aimbot", tools.active_weapon(), "target overrides", "hitchance")[2]:get()
    local safe_ovr = menu.find("aimbot", tools.active_weapon(), "target overrides", "safepoint")[2]:get()

    local antizero = hitrate.shot == 0 and 1 or hitrate.shot
    local hits = hitrate.shot - hitrate.miss
    local shitmath = ((hitrate.shot - hitrate.miss) / hitrate.shot) * 100

    local info = {{hits .. "/" .. hitrate.shot .. " (" .. tostring(math.floor(shitmath + 0.5)) .. "%)", options:get("hitrate"), gray}, {"PING", options:get("ping") and refs.ping:get(), green},
                  {"FS", options:get("freestand") and refs.freestand:get(), gray}, {"DUCK", options:get("fake duck") and refs.fake_duck:get(), gray}, {"H1TCHANCE", options:get("hitchance") and hc_ovr, gray},
                  {"SAFE", options:get("force safe") and safe_ovr, green}, {"MD", options:get("damage") and dmg_ovr, gray}, {"OSAA", options:get("hideshots") and refs.hide_shots:get(), gray},
                  {"DT", options:get("doubletap") and refs.double_tap:get(), (exploits.get_max_charge() < 3 or exploits.get_charge() ~= exploits.get_max_charge()) and red or gray}}

    for k, v in pairs(info) do
        if v[2] then
            add_indicator(v[1], v[3])
        end
    end
end

screen.vw_anim = {
    appearing = 0,
    appearing_alpha = 0
}
screen.velocity = function()
    if not ui.visuals.velocity:get() then
        return
    end
    local lplr = entity_list.get_local_player()
    if not lplr or not lplr:is_player() or not lplr:is_alive() then
        return
    end

    local modifier = lplr:get_prop("m_flVelocityModifier")
    local frametime = globals.frame_time()
    screen.vw_anim.appearing = tools.lerp(screen.vw_anim.appearing, (modifier < 1 or menu.is_open()) and 230 or 180, 0.06 + math.min(frametime / 10.1, 0.25))
    screen.vw_anim.appearing_alpha = tools.lerp(screen.vw_anim.appearing_alpha, (modifier < 1 or menu.is_open()) and 255 or 0, 0.06 + math.min(frametime / 10.1, 0.25))

    render.rect_filled(vec2_t(screen.size.x / 2 - 60, math.floor(screen.vw_anim.appearing)), vec2_t(120, 6), color_t(0, 0, 0, math.min(math.floor(screen.vw_anim.appearing_alpha), 200)))
    render.rect_filled(vec2_t(screen.size.x / 2 - 58, math.floor(screen.vw_anim.appearing + 2)), vec2_t(116 * modifier, 2), color_t(255, 255, 255, math.floor(screen.vw_anim.appearing_alpha)))

    render.text(fonts.verdana, string.format("- slow: %i%s -", math.abs(modifier * 100 + 100 * -1), "%"), vec2_t(screen.size.x / 2, math.floor(screen.vw_anim.appearing) - 7), color_t(255, 255, 255, math.floor(screen.vw_anim.appearing_alpha)), true)
end

screen.def_anim = {
    appearing_alpha = 0
}
screen.defensive = function()
    if not ui.visuals.defensive:get() then
        return
    end
    local lplr = entity_list.get_local_player()
    if not lplr or not lplr:is_player() or not lplr:is_alive() then
        return
    end

    local defensivetable = defensive:is_active(lplr, true, true)
    if not defensivetable then
        return
    end
    local frametime = globals.frame_time()
    screen.def_anim.appearing_alpha = tools.lerp(screen.def_anim.appearing_alpha, (defensive:is_active(lplr) or menu.is_open()) and 255 or 0, 0.05 + math.min(frametime / 10.1, 0.25))

    render.rect_filled(vec2_t(screen.size.x / 2 - 60, 249), vec2_t(120, 6), color_t(0, 0, 0, math.min(math.floor(screen.def_anim.appearing_alpha), 200)))
    render.rect_filled(vec2_t(screen.size.x / 2 - 58, 251), vec2_t(116 - math.clamp(116 * math.abs((defensivetable.tick - globals.tick_count() > 0 and defensivetable.tick - globals.tick_count() or 0) / 12), 0, 116), 2),
        color_t(255, 255, 255, math.floor(screen.def_anim.appearing_alpha)))

    render.text(fonts.verdana, "- defensive -", vec2_t(screen.size.x / 2, 249 - 7), color_t(255, 255, 255, math.floor(screen.def_anim.appearing_alpha)), true)
end

knife.countdown = 0
handles.knife = function(cmd)
    if not engine.is_connected() or not engine.is_in_game() then
        knife.countdown = 0
    end

    if not ui.rage.knifehelp:get() then
        return
    end
    local lplr = entity_list.get_local_player()
    if not lplr or lplr == nil then
        return
    end
    local weapon = entity_list.get_entity(lplr:get_prop("m_hActiveWeapon"))
    if weapon == nil or not weapon then
        return
    end
    local weapon_name = weapon:get_name()

    if knife.countdown > globals.tick_count() and weapon_name == "knife" then
        exploits.force_uncharge()
        exploits.block_recharge()
    else
        exploits.allow_recharge()
    end
end

events.knife = function(event)
    if event.name == "player_hurt" then
        local weap = event.weapon
        local is_knife = string.match(weap, "knife") or weap == "bayonet"
        local entity = entity_list.get_player_from_userid(event.userid)
        local local_player = entity_list.get_local_player()
        if entity == nil then
            return
        end
        if not entity then
            return
        end
        local attacker = entity_list.get_player_from_userid(event.attacker)
        if attacker == nil then
            return
        end
        if not is_knife then
            return
        end
        if not attacker == local_player then
            return
        end
        if ui.rage.knifehelp:get() and attacker == local_player then
            knife.countdown = globals.tick_count() + 96
            exploits.force_uncharge()
            exploits.block_recharge()
        end
    end
end

events.zeus = function(shot)
    local local_player = entity_list:get_local_player()
    local weapon = entity_list.get_entity(local_player:get_prop("m_hActiveWeapon"))
    local weapon_name = weapon:get_name()
    if not ui.rage.switchhelp:get() then
        return
    end
    if weapon_name ~= "taser" then
        return
    end
    exploits.force_anti_exploit_shift()
    engine.execute_cmd("slot2")
    engine.execute_cmd("slot1")
end

events.nade = function(event)
    if event.name == "grenade_thrown" then
        if not ui.rage.switchhelp:get() then
            return
        end
        if entity_list.get_player_from_userid(event.userid) == entity_list.get_local_player() then
            exploits.force_anti_exploit_shift()
            engine.execute_cmd("slot2")
            engine.execute_cmd("slot1")
        end
    end
end

handles.airstop = function(ctx)
    local lplr = entity_list.get_local_player()
    if ui.rage.airstop:get() == 1 then
        return
    end
    local enemyorigin = ctx.player:get_hitbox_pos(e_hitboxes.HEAD)
    if not enemyorigin then
        return
    end
    local lpos = lplr:get_hitbox_pos(e_hitboxes.HEAD)
    local distance = vec3_t(lpos.x - enemyorigin.x, lpos.y - enemyorigin.y, lpos.z - enemyorigin.z):length()
    local verticalvel = lplr:get_prop("m_vecVelocity[2]")
    local my_weapon = lplr:get_active_weapon()
    if not my_weapon then
        return
    end
    local inaccuracy = my_weapon:get_weapon_inaccuracy()

    if (100 - (distance / 100) * 5) > 0 then
        distance = math.floor(100 - ((distance / 100) * 5))
    else
        distance = 40
    end
    local condition2 = inaccuracy + (ui.rage.hitchance:get() / 1.5) / 1000 < 0.1
    -- client.log_screen(distance, distance > ui.rage.hitchance:get())
    if ((verticalvel > 0 and verticalvel < 100 and distance > ui.rage.hitchance:get()) or (ui.rage.airstop:get() == 3 and condition2)) and client.can_fire() then
        refs.autostop[3]:set(7, true)
    else
        refs.autostop[3]:set(7, false)
    end

    if (global.current_state_number == 6 or global.current_state_number == 7) or not ctx.player:has_player_flag(e_player_flags.ON_GROUND) then
        -- client.log_screen("overriding: " ..distance)
        -- ctx:set_damage_accuracy(distance, e_hitscan_groups.HEAD)
        -- ctx:set_damage_accuracy(distance, e_hitscan_groups.STOMACH)
        -- ctx:set_hitchance(distance, e_hitscan_groups.HEAD)
        -- ctx:set_hitchance(distance, e_hitscan_groups.STOMACH)
        -- ctx:set_safepoint_state(false)
        -- ctx:set_safepoint_state(true, e_hitscan_groups.HEAD)
    else
    end
end

handles.correction = function(ctx)
    if not ui.rage.correction:get() then
        return
    end

    local lplr = entity_list.get_local_player()
    local enemy = ctx.player
    if not lplr then
        return
    end
    correctiondb[enemy:get_index()] = false
    if defensive:is_active(ctx.player) --[[or ctx.player:get_prop("m_angEyeAngles[1]") ]] then
        return
    end

    local localorigin = lplr:get_eye_position()
    local enemypos = {
        head = enemy:get_hitbox_pos(e_hitboxes.HEAD),
        chest = enemy:get_hitbox_pos(e_hitboxes.CHEST),
        stomach = enemy:get_hitbox_pos(e_hitboxes.PELVIS)
    }
    local enemydamage = {
        head = damage:calculate(enemy, "head"),
        chest = damage:calculate(enemy, "chest"),
        stomach = damage:calculate(enemy, "stomach")
    }

    for k, v in pairs(enemydamage) do
        -- correctiondb[enemy:get_index()] = false
        if v > enemy:get_prop("m_iHealth") or v > tools:get_dmg() then
            local bullet = trace.bullet(localorigin, enemypos[k], lplr, enemy)
            if bullet.valid and (client.get_hitgroup_name(bullet.hitgroup) == k) then
                local hitgroup = e_hitscan_groups[string.upper(k)]
                -- client.log_screen(1)
                correctiondb[enemy:get_index()] = true
                ctx:set_hitchance(70, hitgroup)
                ctx:set_hitscan_group_state(hitgroup, true, false)
                break
            end
        end
    end
end

handles.accuracy = function(ctx)
    if not ui.rage.accuracy:get() then
        return
    end
    ctx:set_damage_accuracy(ui.rage.boostamount:get())

    if not ui.rage.baimboost:get() then
        return
    end

    local lplr = entity_list.get_local_player()
    local enemy = ctx.player
    if not lplr then
        return
    end

    local localorigin = lplr:get_eye_position()
    local enemypos = {
        chest = enemy:get_hitbox_pos(e_hitboxes.CHEST),
        stomach = enemy:get_hitbox_pos(e_hitboxes.PELVIS)
    }
    local enemydamage = {
        chest = damage:calculate(enemy, "chest"),
        stomach = damage:calculate(enemy, "stomach")
    }

    for k, v in pairs(enemydamage) do
        -- correctiondb[enemy:get_index()] = false
        if v > enemy:get_prop("m_iHealth") or v > tools:get_dmg() then
            -- local bullet = trace.bullet(localorigin, enemypos[k], lplr, enemy)
            -- if bullet.valid then
            -- client.log_screen(1)
            ctx:set_damage_accuracy(100)
            break
            -- end
        end
    end
end

handles.defensive = function(ctx)
    if not ui.rage.safedefensive:get() then
        return
    end
    if defensive:is_active(ctx.player) then
        ctx:set_safepoint_state(true, e_hitscan_groups.HEAD)
    end
end

resolver.teleport = false
resolver.delay = 0

events.teleport = function()
    if not ui.rage.teleport:get() then
        return
    end
    if not refs.double_tap:get() then
        return
    end
    local lplr = entity_list.get_local_player()
    if not lplr then
        return
    end
    if ragebot.get_autopeek_pos() then
        local defensivebool = defensive:is_active(lplr, ui.antiaim.builder.defensive_ping:get() == 1)
        -- if not defensivebool then
        --     exploits.force_uncharge()
        -- else
        resolver.teleport = true
        -- end
        -- elseif refs.double_tap:get() then
        --     exploits.force_uncharge()
        --     if (not (ragebot.get_active_cfg() == 1) or (ragebot.get_active_cfg() == 2)) then return end
        --     client.delay_call(function()
        --         exploits.force_recharge()
        --     end, 0.2)
    end
end

handles.teleport = function()
    if not ui.rage.teleport:get() then
        return
    end
    local lplr = entity_list.get_local_player()
    if not lplr then
        return
    end

    local defensivebool = defensive:is_active(lplr, ui.antiaim.builder.defensive_ping:get() == 1)
    if defensivebool then
        if resolver.teleport then
            resolver.delay = resolver.delay + 1
        end
    else
        if resolver.teleport then
            exploits.force_uncharge()

            resolver.teleport = false
            -- if not ui.rage.tpdebug:get() then return end
            -- print(string.format("Delayed %i ticks before teleporting", resolver.delay))
            -- resolver.delay = 0
        end
    end
end

handles.screenlogs = function()
    if not engine.is_connected() or not engine.is_in_game() then
        return
    end
    if #aimbot_loggies > 0 then
        if globals.tick_count() >= aimbot_loggies[1][2] then
            if aimbot_loggies[1][3] > 0 then
                aimbot_loggies[1][3] = aimbot_loggies[1][3] - 20
            elseif aimbot_loggies[1][3] <= 0 then
                table.remove(aimbot_loggies, 1)
            end
        end
        if globals.is_connected == false then
            table.remove(aimbot_loggies, #aimbot_loggies)
        end
        for i = 1, #aimbot_loggies do
            local text_size = render.get_text_size(fonts.pixel, aimbot_loggies[i][1]).x
            if aimbot_loggies[i][3] < 255 then
                aimbot_loggies[i][3] = aimbot_loggies[i][3] + 5
            end
            if ui.misc.logs:get("crosshair") then
                render.text(fonts.pixel, aimbot_loggies[i][1], vec2_t(screen.size.x / 2 - text_size / 2 + (aimbot_loggies[i][3] / 35), screen.size.y / 1.4 + 20 * i), color_t(255, 255, 255, aimbot_loggies[i][3]))
            end
        end
    end
end

events.reset = function(e)
    if e.name == "player_death" then
        builder.delayinvert = false
        builder.delaytarget = 0
        local lplr = entity_list.get_local_player()
        if not lplr then
            return
        end
        if lplr == entity_list.get_player_from_userid(e.attacker) then
            knife.countdown = 0
        end
    end
    if e.name == "player_connect_full" then
        if entity_list.get_player_from_userid(e.userid) == entity_list.get_local_player() then
            aimbot_loggies = {}
            resolver.memory = {}
            log.aim = {}
            if ui.visuals.reset_hitrate:get("new server") then
                hitrate = {
                    shot = 0,
                    hit = 0,
                    miss = 0
                }
            end
        end
    end
    if e.name == "round_start" then
        builder.misses = 0
        aimbot_loggies = {}
    end
    if e.name == "round_prestart" then
        local roundsplayed = game_rules.get_prop("m_totalRoundsPlayed")
        if roundsplayed == 0 and ui.visuals.reset_hitrate:get("new game") then
            hitrate = {
                shot = 0,
                hit = 0,
                miss = 0
            }
        end
    end
end

clantag.get = function()
    local local_player = entity_list.get_local_player()
    if not local_player then
        return
    end
    local latency = engine.get_latency(e_latency_flows.OUTGOING) / globals.interval_per_tick()
    local tickcount_pred = globals.tick_count() + latency
    local iter = math.floor(math.fmod(tickcount_pred / 35, #clantag.tag + 1) + 1)
    return clantag.tag[iter]
end

clantag.last = nil
clantag.reset = 0
clantag.set = function(tag)
    if not engine.is_connected() or not engine.is_in_game() then
        return
    end
    if tag == clantag.last then
        return
    end
    if tag == nil then
        return
    end
    client.set_clantag(tag)
    clantag.last = tag
end

handles.clantag = function()
    if not engine.is_connected() or not engine.is_in_game() then
        return
    end
    local lplr = entity_list.get_local_player()
    if not lplr then
        return
    end
    if ui.misc.tag:get() then
        clantag.set(clantag.get())
        clantag.reset = 0
    else
        if clantag.reset < 1 then
            clantag.set(" ")
            clantag.reset = clantag.reset + 1
        end
    end
end

events.loghurt = function(e)
    if e.name == "player_hurt" then
        local lplr = entity_list.get_local_player()
        if not lplr then
            return
        end
        if (lplr == entity_list.get_player_from_userid(e.userid)) and not (lplr == entity_list.get_player_from_userid(e.attacker)) then
            log.hurttick = globals.tick_count()
        end
    end
end

handles.hitmarker = function(screen_pos, world_pos, alpha_factor, damage, is_lethal, is_headshot)
    if ui.visuals.hitmarker:get() == 1 then
        return
    end

    render.push_alpha_modifier(alpha_factor)
    if ui.visuals.hitmarker:get() == 2 then
        render.rect_filled(vector(screen_pos.x - 5, screen_pos.y - 1), vector(10, 2), ui.visuals.hitcolor:get())
        render.rect_filled(vector(screen_pos.x - 1, screen_pos.y - 5), vector(2, 10), ui.visuals.hitcolor:get())
    elseif ui.visuals.hitmarker:get() == 3 then
        render.line(vector(screen_pos.x - 4, screen_pos.y - 4), vector(screen_pos.x + 4, screen_pos.y + 4), ui.visuals.hitcolor:get())
        render.line(vector(screen_pos.x - 4, screen_pos.y + 4), vector(screen_pos.x + 4, screen_pos.y - 4), ui.visuals.hitcolor:get())
    else
    end
    render.pop_alpha_modifier()

    return true
end

local solusbinds = dragsystem.register({ui.hidden.solus_x, ui.hidden.solus_y}, vector(150, 70), "keybinds", function(self)
    -- if not engine.is_app_active() then return end

    local bindinfo = {{
        name = "Ping Spike",
        enable = refs.keybinds:get("Fake Ping"),
        condition = refs.ping
    }, {
        name = "Slow motion",
        enable = refs.keybinds:get("Slow Walk"),
        condition = refs.slow_motion
    }, {
        name = "Quick peek assist",
        enable = refs.keybinds:get("Autopeek"),
        condition = refs.ap
    }, {
        name = "Duck peek assist",
        enable = refs.keybinds:get("Fakeduck"),
        condition = refs.fake_duck
    }, {
        name = "Force Safepoint",
        enable = refs.keybinds:get("Force Safepoint"),
        condition = menu.find("aimbot", tools.active_weapon(), "target overrides", "safepoint")[2]
    }, {
        name = "Force Lethal",
        enable = refs.keybinds:get("Force Lethal"),
        condition = menu.find("aimbot", tools.active_weapon(), "target overrides", "lethal shot")[2]
    }, {
        name = "Force Hitbox",
        enable = refs.keybinds:get("Hitbox Override"),
        condition = menu.find("aimbot", tools.active_weapon(), "target overrides", "hitbox")[2]
    }, {
        name = "Force Hitchance",
        enable = refs.keybinds:get("Hitchance Override"),
        condition = menu.find("aimbot", tools.active_weapon(), "target overrides", "hitchance")[2]
    }, {
        name = "Minimum damage",
        enable = refs.keybinds:get("Min. Damage Override"),
        condition = menu.find("aimbot", tools.active_weapon(), "target overrides", "min. damage")[2]
    }, {
        name = "Onshot anti-aim",
        enable = refs.keybinds:get("Hideshots"),
        condition = refs.hide_shots
    }, {
        name = "Doubletap",
        enable = refs.keybinds:get("Doubletap"),
        condition = refs.double_tap
    }, {
        name = "Menu toggled",
        enable = menu.is_open(),
        condition = true
    }}

    local is_connected = engine.is_connected() and engine.is_in_game()

    local bindamounts = 0
    local finalbinds = {}
    local maximum_offset = 0
    local height_offset = 20
    local height = 0
    local font = fonts.verdana_b
    for k, v in pairs(bindinfo) do
        local condition = type(v.condition) == "boolean" and v.condition or v.condition:get()
        v.alpha = tools.animation:new("kb_" .. v.name .. "_alpha", v.enable and condition and 1 or 0, 15)
        if (v.enable and condition) or (v.alpha > 0.05) then
            local text_width = render.get_text_size(font, v.name).x
            local shitmode = type(v.condition) == "boolean" and "~" or tools.key_modes[v.condition:get_mode()]
            if shitmode ~= "always" or (shitmode == "always" and refs.always:get()) then
                local tmptable = {
                    name = v.name,
                    mode = shitmode,
                    alpha = v.alpha
                }
                table.insert(finalbinds, tmptable)
                if v.alpha > 0.5 then
                    maximum_offset = maximum_offset < text_width and text_width or maximum_offset
                end
            end
        end
    end

    local alpha = tools.animation:new("kb_alpha", (menu.is_open() or is_connected and (#finalbinds > 0)) and 1 or 0, 15)

    alpha = alpha < 0.01 and 0 or alpha
    alpha = alpha > 0.99 and 1 or alpha

    local width = 75 + maximum_offset
    if m_width == nil then
        m_width = w;
    end

    m_width = tools.animation:new("kb_width", width, 15)
    w = math.floor(m_width + 0.5)

    height = height + #finalbinds * 18
    if not engine.is_app_active() then
        return
    end

    render.rect_filled(vector(self.position.x, self.position.y + 2), vector(w, 18), color(17, 17, 17, math.floor(alpha * 40)))
    render.rect_filled(vector(self.position.x, self.position.y), vector(w, 2), color(ui.accent:get().r, ui.accent:get().g, ui.accent:get().b, math.floor(alpha * 255)))
    render.text(font, "keybinds", vector(self.position.x - render.get_text_size(font, "keybinds").x / 2 + w / 2, self.position.y + 4), color(255, 255, 255, math.floor(alpha * 255)))

    for i = 1, #finalbinds do
        render.text(font, finalbinds[i].name, vector(self.position.x, self.position.y + height_offset), color(255, 255, 255, math.clamp(math.abs(math.floor(finalbinds[i].alpha * 255)), 0, 255)))
        render.text(font, "[" .. finalbinds[i].mode .. "]", vector(self.position.x + w - render.get_text_size(font, finalbinds[i].mode).x - 8, self.position.y + height_offset),
            color(255, 255, 255, math.clamp(math.abs(math.floor(finalbinds[i].alpha * 255)), 0, 255)))
        height_offset = height_offset + math.floor(13 * finalbinds[i].alpha + 0.5)
    end
end)

handles.airstuck = function(cmd)
    if ui.antiaim.features.airstuck:get() then
        cmd.tick_count = 0x7FFFFFFF
        cmd.command_number = 0x7FFFFFFF
    end
end

local afkdirection = 1

handles.antiafk = function(cmd)
    if not ui.misc.antiafk:get() then
        return
    end

    if builder.afk_valid == true then
        builder.afk = builder.afk + 1
        if builder.afk > 128 then
            builder.afk = 0
            afkdirection = not afkdirection
        end
        -- client.log_screen(builder.afk)
    end

    if cmd:has_button(e_cmd_buttons.MOVELEFT) then
        builder.afk_valid = false
    end
    if cmd:has_button(e_cmd_buttons.MOVERIGHT) then
        builder.afk_valid = false
    end
    if cmd:has_button(e_cmd_buttons.FORWARD) then
        builder.afk_valid = false
    end
    if cmd:has_button(e_cmd_buttons.BACK) then
        builder.afk_valid = false
    end

    if builder.afk < 8 and builder.afk_valid then
        -- client.log_screen("moving")
        cmd.move.x = 450 * (afkdirection and 1 or -1)
    end
end

events.antiafk = function(event)
    if event.name == "round_start" then
        builder.afk_valid = true
    end
end

handles.warnings = function()
    if not menu.is_open() then
        return
    end

    local chargekey = refs.dontusecharge:get_key()
    local chargemode = refs.dontusecharge:get_mode()

    -- print(chargemode)
    -- print(chargekey)

    if (chargekey == 0 or chargemode == 4 or chargemode == 3) and ui.rage.teleport:get() then
        ui.rage.idealinstructions:depend({(true)})
        ui.rage.idealinstructions.ref:set(globals.cur_time() % 0.5 < 0.25 and ("                  !! Key not bound !!") or " ")
    else
        ui.rage.idealinstructions:depend({(false)})
    end
    if refs.res:get() and ui.rage.resolve:get() then
        ui.rage.resinstructions:depend({(true)})
        ui.rage.resinstructions.ref:set(globals.cur_time() % 0.5 < 0.25 and ("        !! Disable cheat's resolver! !!") or " ")
    else
        ui.rage.resinstructions:depend({(false)})
    end
end

handles.menu = function()
    if not menu.is_open() then
        return
    end
    groups.settings:depend({(false)})
    ui.nav.slider:depend({(false)})
    ui.nav.backbtn:depend({(ui.nav.slider:get() ~= 0)})
    ui.nav.ragebtn:depend({ui.nav.slider, 0})
    ui.nav.configbtn:depend({ui.nav.slider, 0})
    ui.nav.aabtn:depend({ui.nav.slider, 0})
    ui.nav.helpers:depend({ui.nav.slider, 0})
    ui.nav.visbtn:depend({ui.nav.slider, 0})
    ui.nav.miscbtn:depend({ui.nav.slider, 0})

    ui.rage.method:depend({ui.rage.resolve, true})
    ui.rage.custom:depend({ui.rage.resolve, true}, {ui.rage.method, 5})
    ui.rage.dump:depend({ui.rage.resolve, true}, {ui.rage.method, 1})
    ui.rage.debug:depend({ui.rage.resolve, true}, {ui.rage.method, 1})
    ui.rage.clear:depend({ui.rage.resolve, true}, {ui.rage.method, 1})
    ui.rage.hitchance:depend({(ui.rage.airstop:get() == 2 or ui.rage.airstop:get() == 3)})
    ui.rage.boostamount:depend({ui.rage.accuracy, true})
    ui.rage.baimboost:depend({ui.rage.accuracy, true})

    ui.rage.instructions:depend({ui.rage.teleport, true})

    ui.antiaim.builder.enable:depend({ui.nav.slider, 3})
    ui.antiaim.builder.condition:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true})
    ui.antiaim.breakers.lean:depend({(ui.antiaim.breakers.extra:get(2))})

    ui.visuals.transparent:depend({ui.visuals.mindmg, true})
    ui.visuals.lerp:depend({ui.visuals.mindmg, true})

    ui.visuals.elements:depend({(ui.visuals.indicators:get() ~= 1)})
    ui.visuals.desync:depend({(ui.visuals.indicators:get() == 2)}, {(ui.visuals.elements:get(1, true))})
    ui.visuals.binds:depend({(ui.visuals.indicators:get() ~= 1)}, {(ui.visuals.elements:get(2, true))})

    ui.misc.avoid_collisions_dist:depend({ui.misc.avoid_collisions, true})
    ui.misc.avoid_collisions_vel:depend({ui.misc.avoid_collisions, true})

    ui.visuals.reset_hitrate:depend({(ui.visuals.gamesense_indicators:get("hitrate"))})

    -- refs.res:set(not ui.rage.resolve:get())

    for i = 1, #states do
        local state = ui.antiaim.builder[i]
        if i == 1 then
            state.override:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {ui.antiaim.builder.condition, -1})
            state.override.ref:set(true)
        else
            state.override:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {ui.antiaim.builder.condition, i})
        end
        state.yaw_mode:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i})
        state.yaw_value:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i}, {(state.yaw_mode:get() == 1)})
        state.yaw_left:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i}, {(state.yaw_mode:get() ~= 1)})
        state.yaw_right:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i}, {(state.yaw_mode:get() ~= 1)})
        state.yaw_delay:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i}, {(state.yaw_mode:get() ~= 1)})
        state.meta_left:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i}, {(state.yaw_mode:get() == 3)})
        state.meta_right:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i}, {(state.yaw_mode:get() == 3)})
        state.meta_delay:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i}, {(state.yaw_mode:get() == 3)})
        state.yaw_modifier:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i})
        state.modifier_degree:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i}, {(state.yaw_modifier:get() ~= 1)})
        state.modifier_random:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i}, {(state.yaw_modifier:get() ~= 1)})
        state.desync:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i})
        state.fake_left:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i})
        state.fake_right:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i})
        state.trigger_defensive:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i})
        state.defensive_pitch:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i}, {(state.trigger_defensive:get() == 2 or state.trigger_defensive:get() == 4)})
        state.defensive_pitch_val:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i}, {(state.defensive_pitch:get() == 8 or state.defensive_pitch:get() == 9)},
            {(state.trigger_defensive:get() == 2 or state.trigger_defensive:get() == 4)})
        state.defensive_pitch_val2:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i}, {state.defensive_pitch, 9}, {not (state.trigger_defensive:get() == 3)},
            {(state.trigger_defensive:get() == 2 or state.trigger_defensive:get() == 4)})
        state.defensive_yaw:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i}, {(state.trigger_defensive:get() == 2 or state.trigger_defensive:get() == 4)})
        state.defensive_yaw_val:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true}, {state.override, true}, {ui.antiaim.builder.condition, i},
            {(state.defensive_yaw:get() == 2 or state.defensive_yaw:get() == 3 or state.defensive_yaw:get() == 4 or state.defensive_yaw:get() == 5)}, {(state.trigger_defensive:get() == 2 or state.trigger_defensive:get() == 4)})
    end

    groups.configs:depend({ui.nav.slider, 1})
    groups.res:depend({ui.nav.slider, 2})
    groups.rage:depend({ui.nav.slider, 2})
    groups.tick:depend({ui.nav.slider, 2})
    groups.antiaim:depend({ui.nav.slider, 3}, {ui.antiaim.builder.enable, true})
    groups.yaw:depend({ui.nav.slider, 3})
    groups.desync:depend({ui.nav.slider, 3})
    groups.jitter:depend({ui.nav.slider, 3})
    groups.defensive:depend({ui.nav.slider, 3})
    groups.breakers:depend({ui.nav.slider, 4})
    groups.features:depend({ui.nav.slider, 4})
    groups.visuals:depend({ui.nav.slider, 5})
    groups.indicators:depend({ui.nav.slider, 5})
    groups.misc:depend({ui.nav.slider, 6})
    groups.movement:depend({ui.nav.slider, 6})
    groups.loader:depend({ui.nav.slider, 6})
    groups.nav:depend({(true)})

    menu.set_group_column("Rage", 3)
    menu.set_group_column("Features", 2)
    menu.set_group_column("Animation", 3)
    menu.set_group_column("Defensive", 3)
    menu.set_group_column("Global", 1)
    menu.set_group_column("Jitter", 2)
    menu.set_group_column("Desync", 3)
    menu.set_group_column("Indicators", 3)
    menu.set_group_column("Misc", 3)
    menu.set_group_column("Loader", 3)
end

callbacks.add(e_callbacks.ANTIAIM, function(ctx, cmd)
    handles.builder(ctx, cmd)
    handles.breaker(ctx, cmd)
    handles.onshot(ctx)
end)
callbacks.add(e_callbacks.HITSCAN, function(ctx)
    resolver.updatetarget(ctx)
    handles.airstop(ctx)
    handles.accuracy(ctx)
    handles.correction(ctx)
    handles.defensive(ctx)

    if builder.onpeek then
        exploits.force_anti_exploit_shift()
    end
end)
callbacks.add(e_callbacks.NET_UPDATE, function(ctx)
    resolver.pre_resolve(ctx)
end)
callbacks.add(e_callbacks.EVENT, function(ctx)
    events.knife(ctx)
    events.nade(ctx)
    events.reset(ctx)
    events.loghurt(ctx)
    events.bullets(ctx)
    events.antiafk(ctx)
    if not engine.is_connected() or not engine.is_in_game() then
        return
    end
    log:extra(ctx)
    events.detectmiss(ctx)
    resolver.clearmemory(ctx)
end)
callbacks.add(e_callbacks.AIMBOT_SHOOT, function(shoot)
    events.zeus(shoot)
    events.teleport(shoot)
    log:shot(shoot)
    hitrate.shot = hitrate.shot + 1
end)
callbacks.add(e_callbacks.AIMBOT_HIT, function(hit)
    log:hit(hit)
    events.teleport(hit)
    hitrate.hit = hitrate.hit + 1
end)
callbacks.add(e_callbacks.AIMBOT_MISS, function(miss)
    log:miss(miss)
    events.teleport(miss)
    hitrate.miss = hitrate.miss + 1
end)
callbacks.add(e_callbacks.PLAYER_ESP, function(ctx)
    handles.esp(ctx)
end)
callbacks.add(e_callbacks.WORLD_HITMARKER, function(...)
    handles.hitmarker(...)
end)
callbacks.add(e_callbacks.SETUP_COMMAND, function(ctx)
    global:update(ctx)
    handles.teleport(ctx)
    handles.legs(ctx)
    handles.knife(ctx)
    handles.nofall(ctx)
    handles.ladder(ctx)
    handles.toss(ctx)
    handles.avoid_collisions(ctx)
    handles.airstuck(ctx)
    handles.antiafk(ctx)
    if not client.can_fire() then
        return
    end
    handles.bulletlog(ctx)
end)
callbacks.add(e_callbacks.PAINT, function()
    handles.menu()
    handles.logs()
    handles.screenlogs()
    handles.clantag()
    screen.velocity()
    screen.defensive()
    screen.gamesense_indicators()
    screen:indicators()
    screen:damage()
    screen:watermark()
    builder.clockpitch()
    builder.clockyaw()
    handles.warnings()
    if not ui.visuals.solus:get() then
        return
    end
    solusbinds:update()
end)
