-- antiaim builder



-- base 64 (credits to ergou)
local base64 = {}
base64.extract = function(value, from, width)
    return bit.band(bit.rshift(value, from), bit.lshift(1, width) - 1)
end

base64.create_encoder = function(input_alphabet)
    local encoder = {}
    local alphabet = {}

    for i = 1, #input_alphabet do
        alphabet[i - 1] = input_alphabet:sub(i, i)
    end

    for b64code, char in pairs(alphabet) do
        encoder[b64code] = char:byte()
    end

    return encoder
end

base64.create_decoder = function(alphabet)
    local decoder = {}
    for b64code, charcode in pairs(base64.create_encoder(alphabet)) do
        decoder[charcode] = b64code
    end

    return decoder
end

base64.default_encode_alphabet = base64.create_encoder("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")
base64.default_decode_alphabet = base64.create_decoder("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")

base64.custom_encode_alphabet = base64.create_encoder("a8tsQE4FdNKZ1WlzRP6UH9fmkiAyjxw2OXcgVvL5IG0eYDnTB3CMJqhpbSo7ru+/=")
base64.custom_decode_alphabet = base64.create_decoder("a8tsQE4FdNKZ1WlzRP6UH9fmkiAyjxw2OXcgVvL5IG0eYDnTB3CMJqhpbSo7ru+/=")

base64.encode = function(string, encoder)
    string = tostring(string)
    encoder = encoder or base64.default_encode_alphabet

    local t, k, n = {}, 1, #string
    local lastn = n % 3
    local cache = {}

    for i = 1, n - lastn, 3 do
        local a, b, c = string:byte(i, i + 2)
        local v = a * 0x10000 + b * 0x100 + c
        local s = string.char(encoder[base64.extract(v, 18, 6)], encoder[base64.extract(v, 12, 6)], encoder[base64.extract(v, 6, 6)], encoder[base64.extract(v, 0, 6)])

        t[k] = s
        k = k + 1
    end

    if lastn == 2 then
        local a, b = string:byte(n - 1, n)
        local v = a * 0x10000 + b * 0x100

        t[k] = string.char(encoder[base64.extract(v, 18, 6)], encoder[base64.extract(v, 12, 6)], encoder[base64.extract(v, 6, 6)], encoder[64])
    elseif lastn == 1 then
        local v = string:byte(n) * 0x10000
        t[k] = string.char(encoder[base64.extract(v, 18, 6)], encoder[base64.extract(v, 12, 6)], encoder[64], encoder[64])
    end

    return table.concat(t)
end

function base64.decode(b64, decoder)
    decoder = decoder or base64.default_decode_alphabet
    local pattern = "[^%w%+%/%=]"
    
    if decoder then
        local s62 = nil
        local s63 = nil

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
    local n = #b64

    local t, k = {}, 1
    local padding = b64:sub(-2) == "==" and 2 or b64:sub(-1) == "=" and 1 or 0

    for i = 1, padding > 0 and n - 4 or n, 4 do
        local a, b, c, d = b64:byte(i, i + 3)
        local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40 + decoder[d]
        local s = string.char(base64.extract(v, 16, 8), base64.extract(v, 8, 8), base64.extract(v, 0, 8))

        t[k] = s
        k = k + 1
    end

    if padding == 1 then
        local a, b, c = b64:byte(n - 3, n - 1)
        local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40

        t[k] = string.char(base64.extract(v, 16, 8), base64.extract(v, 8, 8))
    elseif padding == 2 then
        local a, b = b64:byte(n - 3, n - 2)
        local v = decoder[a] * 0x40000 + decoder[b] * 0x1000

        t[k] = string.char(base64.extract(v, 16, 8))
    end

    return table.concat(t)
end







-- import & export config (credits to onion)
ffi.cdef [[
    typedef int(__thiscall* get_clipboard_text_count)(void*);
    typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
    typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]
-- clipboard
VGUI_System010 =  memory.create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
VGUI_System = ffi.cast(ffi.typeof('void***'), VGUI_System010 )
get_clipboard_text_count = ffi.cast("get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
set_clipboard_text = ffi.cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
get_clipboard_text = ffi.cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")

clipboard_import = function()
    local clipboard_text_length = get_clipboard_text_count(VGUI_System)
   
    if clipboard_text_length > 0 then
        local buffer = ffi.new("char[?]", clipboard_text_length)
        local size = clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length)
   
        get_clipboard_text(VGUI_System, 0, buffer, size )
   
        return ffi.string( buffer, clipboard_text_length-1)
    end

    return ""
end

local function clipboard_export(string)
    if string then
        set_clipboard_text(VGUI_System, string, string:len())
    end
end

local function str_to_sub(text, sep)
    local t = {}
    for str in string.gmatch(text, "([^"..sep.."]+)") do
        t[#t + 1] = string.gsub(str, "\n", " ")
    end
    return t
end

local function to_boolean(str)
    if str == "true" or str == "false" then
        return (str == "true")
    else
        return str
    end
end

local config = {}
config.__index = {}

config.setting_table = {}
config.menu_func = {
    add_checkbox = menu.add_checkbox,
    add_selection = menu.add_selection,
    add_slider = menu.add_slider,
    add_list = menu.add_list,
    add_multi_selection = menu.add_multi_selection,
}

config.seperator = "|"

config.control_function = function(control, group, name, multi_select)
    table.insert(config.setting_table, { control = control, group = group, name = name, special = multi_select })

    return control
end

function menu.add_checkbox(group, name, ...)
    local control = config.menu_func.add_checkbox(group, name, ...)
    return config.control_function(control, group, name, false)
end

function menu.add_selection(group, name, ...)
    local control = config.menu_func.add_selection(group, name, ...)
    return config.control_function(control, group, name, false)
end

function menu.add_slider(group, name, ...)
    local control = config.menu_func.add_slider(group, name, ...)
    return config.control_function(control, group, name, false)
end

function menu.add_list(group, name, ...)
    local control = config.menu_func.add_list(group, name, ...)
    return config.control_function(control, group, name, false)
end

function menu.add_multi_selection(group, name, ...)
    local control = config.menu_func.add_multi_selection(group, name, ...)
    return config.control_function(control, group, name, true)
end

function menu.add_color_picker(group, name, ...)
    local control = config.menu_func.add_color_picker(group, name, ...)
    return config.control_function(control, group, name, true)
end
string.find_all = function(text, word)
    local i, tbl = 0, {}

    while true do
        i = string.find(text, word, i + 1)
        if (i) then table.insert(tbl, i) else break end
    end

    return tbl
end

string.split_on_str = function(text, str)
    local str_table, split_table = string.find_all(text, str), {}

    if (str_table and #str_table > 0) then
        for i = 1, #str_table + 1 do
            if (i == 1) then table.insert(split_table, string.sub(text, 1, str_table[i] - 1))
            elseif (i == #str_table + 1) then table.insert(split_table, string.sub(text, str_table[i - 1] + 1, #text))
            else table.insert(split_table, string.sub(text, str_table[i - 1] + 1, str_table[i] - 1)) end
        end
    end

    return split_table
end

config.import_settings = function(text)
    local line_table = string.split_on_str(text, "\n")

    for i = 1, #line_table do
        local arg_table = string.split_on_str(line_table[i], config.seperator)

        local group, name, value_type, multi_select, value = arg_table[1], arg_table[2], arg_table[3], arg_table[4] == "true", nil

        if (value_type == "number") then
            value = tonumber(arg_table[5])
        elseif (value_type == "boolean") then
            if (string.find(arg_table[5], "true")) then
                value = true
            else
                value = false
            end
        end

        for f = 1, #config.setting_table do
            if (config.setting_table[f].group == group and config.setting_table[f].name == name) then
                if (not multi_select) then
                    config.setting_table[f].control:set(value)
                else
                    for j = 5, #arg_table do
                        if (j % 2 ~= 0) then
                            config.setting_table[f].control:set(tonumber(arg_table[j]), arg_table[j + 1] == "true")
                        end
                    end
                end
            end
        end
    end
end

config.export_settings = function()
    local export_text = ""

    for i = 1, #config.setting_table do
        if (not config.setting_table[i].special) then
            export_text = export_text .. ((export_text == "") and "" or "\n") .. (config.setting_table[i].group .. config.seperator .. config.setting_table[i].name .. config.seperator .. type(config.setting_table[i].control:get()) .. config.seperator .. tostring(config.setting_table[i].special) .. config.seperator .. tostring(config.setting_table[i].control:get()))
        else
            export_text = export_text .. ((export_text == "") and "" or "\n") .. (config.setting_table[i].group .. config.seperator .. config.setting_table[i].name .. config.seperator .. "table" .. config.seperator .. tostring(config.setting_table[i].special))

            local items = config.setting_table[i].control:get_items()

            for f = 1, #items do
                export_text = export_text .. config.seperator .. f .. config.seperator .. tostring(config.setting_table[i].control:get(f))
            end
        end
    end

    return export_text
end







-- beginning of antiaim builder

    local configstring = 'YW50aWFpbSBidWlsZGVyfHNlbGVjdCBjb25kaXRpb258bnVtYmVyfGZhbHNlfDEKYW50aWFpbSBidWlsZGVyfGVuYWJsZWQgY29uZGl0aW9uc3x0YWJsZXx0cnVlfDF8ZmFsc2V8Mnx0cnVlfDN8dHJ1ZXw0fGZhbHNlfDV8ZmFsc2V8NnxmYWxzZXw3fHRydWV8OHxmYWxzZXw5fHRydWUKW2dsb2JhbF0gLSBhbmdsZXN8eWF3IG1vZGV8bnVtYmVyfGZhbHNlfDIKW2dsb2JhbF0gLSBhbmdsZXN8eWF3IGFkZHxudW1iZXJ8ZmFsc2V8MApbZ2xvYmFsXSAtIGFuZ2xlc3x5YXcgYWRkIGxlZnR8bnVtYmVyfGZhbHNlfDEwCltnbG9iYWxdIC0gYW5nbGVzfHlhdyBhZGQgcmlnaHR8bnVtYmVyfGZhbHNlfC0xMApbZ2xvYmFsXSAtIGFuZ2xlc3xyb3RhdGV8Ym9vbGVhbnxmYWxzZXxmYWxzZQpbZ2xvYmFsXSAtIGFuZ2xlc3xyb3RhdGUgcmFuZ2V8bnVtYmVyfGZhbHNlfDAKW2dsb2JhbF0gLSBhbmdsZXN8cm90YXRlIHNwZWVkfG51bWJlcnxmYWxzZXwwCltnbG9iYWxdIC0gYW5nbGVzfGppdHRlciBtb2RlfG51bWJlcnxmYWxzZXwyCltnbG9iYWxdIC0gYW5nbGVzfGppdHRlciB0eXBlfG51bWJlcnxmYWxzZXwyCltnbG9iYWxdIC0gYW5nbGVzfGppdHRlciBhZGR8bnVtYmVyfGZhbHNlfDIwCltnbG9iYWxdIC0gYW5nbGVzfGJvZHkgbGVhbnxudW1iZXJ8ZmFsc2V8MQpbZ2xvYmFsXSAtIGFuZ2xlc3xib2R5IGxlYW4gdmFsdWV8bnVtYmVyfGZhbHNlfDAKW2dsb2JhbF0gLSBhbmdsZXN8Ym9keSBsZWFuIGppdHRlcnxudW1iZXJ8ZmFsc2V8MApbZ2xvYmFsXSAtIGFuZ2xlc3xtb3ZpbmcgYm9keSBsZWFufGJvb2xlYW58ZmFsc2V8ZmFsc2UKW2dsb2JhbF0gLSBkZXN5bmN8c2lkZXxudW1iZXJ8ZmFsc2V8NQpbZ2xvYmFsXSAtIGRlc3luY3xkZWZhdWx0IHNpZGV8bnVtYmVyfGZhbHNlfDMKW2dsb2JhbF0gLSBkZXN5bmN8bGVmdCBhbW91bnR8bnVtYmVyfGZhbHNlfDUwCltnbG9iYWxdIC0gZGVzeW5jfHJpZ2h0IGFtb3VudHxudW1iZXJ8ZmFsc2V8NTAKW2dsb2JhbF0gLSBkZXN5bmN8YW50aSBicnV0ZWZvcmNlfGJvb2xlYW58ZmFsc2V8ZmFsc2UKW3N0YW5kXSAtIGFuZ2xlc3x5YXcgbW9kZXxudW1iZXJ8ZmFsc2V8MQpbc3RhbmRdIC0gYW5nbGVzfHlhdyBhZGR8bnVtYmVyfGZhbHNlfDAKW3N0YW5kXSAtIGFuZ2xlc3x5YXcgYWRkIGxlZnR8bnVtYmVyfGZhbHNlfDAKW3N0YW5kXSAtIGFuZ2xlc3x5YXcgYWRkIHJpZ2h0fG51bWJlcnxmYWxzZXwwCltzdGFuZF0gLSBhbmdsZXN8cm90YXRlfGJvb2xlYW58ZmFsc2V8ZmFsc2UKW3N0YW5kXSAtIGFuZ2xlc3xyb3RhdGUgcmFuZ2V8bnVtYmVyfGZhbHNlfDAKW3N0YW5kXSAtIGFuZ2xlc3xyb3RhdGUgc3BlZWR8bnVtYmVyfGZhbHNlfDAKW3N0YW5kXSAtIGFuZ2xlc3xqaXR0ZXIgbW9kZXxudW1iZXJ8ZmFsc2V8MQpbc3RhbmRdIC0gYW5nbGVzfGppdHRlciB0eXBlfG51bWJlcnxmYWxzZXwxCltzdGFuZF0gLSBhbmdsZXN8aml0dGVyIGFkZHxudW1iZXJ8ZmFsc2V8MApbc3RhbmRdIC0gYW5nbGVzfGJvZHkgbGVhbnxudW1iZXJ8ZmFsc2V8MQpbc3RhbmRdIC0gYW5nbGVzfGJvZHkgbGVhbiB2YWx1ZXxudW1iZXJ8ZmFsc2V8MApbc3RhbmRdIC0gYW5nbGVzfGJvZHkgbGVhbiBqaXR0ZXJ8bnVtYmVyfGZhbHNlfDAKW3N0YW5kXSAtIGFuZ2xlc3xtb3ZpbmcgYm9keSBsZWFufGJvb2xlYW58ZmFsc2V8ZmFsc2UKW3N0YW5kXSAtIGRlc3luY3xzaWRlfG51bWJlcnxmYWxzZXwxCltzdGFuZF0gLSBkZXN5bmN8ZGVmYXVsdCBzaWRlfG51bWJlcnxmYWxzZXwxCltzdGFuZF0gLSBkZXN5bmN8bGVmdCBhbW91bnR8bnVtYmVyfGZhbHNlfDAKW3N0YW5kXSAtIGRlc3luY3xyaWdodCBhbW91bnR8bnVtYmVyfGZhbHNlfDAKW3N0YW5kXSAtIGRlc3luY3xhbnRpIGJydXRlZm9yY2V8Ym9vbGVhbnxmYWxzZXxmYWxzZQpbc2xvd3dhbGtdIC0gYW5nbGVzfHlhdyBtb2RlfG51bWJlcnxmYWxzZXwyCltzbG93d2Fsa10gLSBhbmdsZXN8eWF3IGFkZHxudW1iZXJ8ZmFsc2V8MApbc2xvd3dhbGtdIC0gYW5nbGVzfHlhdyBhZGQgbGVmdHxudW1iZXJ8ZmFsc2V8MTAKW3Nsb3d3YWxrXSAtIGFuZ2xlc3x5YXcgYWRkIHJpZ2h0fG51bWJlcnxmYWxzZXwtMTAKW3Nsb3d3YWxrXSAtIGFuZ2xlc3xyb3RhdGV8Ym9vbGVhbnxmYWxzZXxmYWxzZQpbc2xvd3dhbGtdIC0gYW5nbGVzfHJvdGF0ZSByYW5nZXxudW1iZXJ8ZmFsc2V8MApbc2xvd3dhbGtdIC0gYW5nbGVzfHJvdGF0ZSBzcGVlZHxudW1iZXJ8ZmFsc2V8MApbc2xvd3dhbGtdIC0gYW5nbGVzfGppdHRlciBtb2RlfG51bWJlcnxmYWxzZXwyCltzbG93d2Fsa10gLSBhbmdsZXN8aml0dGVyIHR5cGV8bnVtYmVyfGZhbHNlfDIKW3Nsb3d3YWxrXSAtIGFuZ2xlc3xqaXR0ZXIgYWRkfG51bWJlcnxmYWxzZXwzMApbc2xvd3dhbGtdIC0gYW5nbGVzfGJvZHkgbGVhbnxudW1iZXJ8ZmFsc2V8MQpbc2xvd3dhbGtdIC0gYW5nbGVzfGJvZHkgbGVhbiB2YWx1ZXxudW1iZXJ8ZmFsc2V8MApbc2xvd3dhbGtdIC0gYW5nbGVzfGJvZHkgbGVhbiBqaXR0ZXJ8bnVtYmVyfGZhbHNlfDAKW3Nsb3d3YWxrXSAtIGFuZ2xlc3xtb3ZpbmcgYm9keSBsZWFufGJvb2xlYW58ZmFsc2V8ZmFsc2UKW3Nsb3d3YWxrXSAtIGRlc3luY3xzaWRlfG51bWJlcnxmYWxzZXw1CltzbG93d2Fsa10gLSBkZXN5bmN8ZGVmYXVsdCBzaWRlfG51bWJlcnxmYWxzZXwxCltzbG93d2Fsa10gLSBkZXN5bmN8bGVmdCBhbW91bnR8bnVtYmVyfGZhbHNlfDMwCltzbG93d2Fsa10gLSBkZXN5bmN8cmlnaHQgYW1vdW50fG51bWJlcnxmYWxzZXwzMApbc2xvd3dhbGtdIC0gZGVzeW5jfGFudGkgYnJ1dGVmb3JjZXxib29sZWFufGZhbHNlfGZhbHNlClttb3ZlXSAtIGFuZ2xlc3x5YXcgbW9kZXxudW1iZXJ8ZmFsc2V8MgpbbW92ZV0gLSBhbmdsZXN8eWF3IGFkZHxudW1iZXJ8ZmFsc2V8MApbbW92ZV0gLSBhbmdsZXN8eWF3IGFkZCBsZWZ0fG51bWJlcnxmYWxzZXwxMgpbbW92ZV0gLSBhbmdsZXN8eWF3IGFkZCByaWdodHxudW1iZXJ8ZmFsc2V8LTEyClttb3ZlXSAtIGFuZ2xlc3xyb3RhdGV8Ym9vbGVhbnxmYWxzZXxmYWxzZQpbbW92ZV0gLSBhbmdsZXN8cm90YXRlIHJhbmdlfG51bWJlcnxmYWxzZXwwClttb3ZlXSAtIGFuZ2xlc3xyb3RhdGUgc3BlZWR8bnVtYmVyfGZhbHNlfDAKW21vdmVdIC0gYW5nbGVzfGppdHRlciBtb2RlfG51bWJlcnxmYWxzZXwyClttb3ZlXSAtIGFuZ2xlc3xqaXR0ZXIgdHlwZXxudW1iZXJ8ZmFsc2V8MgpbbW92ZV0gLSBhbmdsZXN8aml0dGVyIGFkZHxudW1iZXJ8ZmFsc2V8MzAKW21vdmVdIC0gYW5nbGVzfGJvZHkgbGVhbnxudW1iZXJ8ZmFsc2V8MQpbbW92ZV0gLSBhbmdsZXN8Ym9keSBsZWFuIHZhbHVlfG51bWJlcnxmYWxzZXwwClttb3ZlXSAtIGFuZ2xlc3xib2R5IGxlYW4gaml0dGVyfG51bWJlcnxmYWxzZXwwClttb3ZlXSAtIGFuZ2xlc3xtb3ZpbmcgYm9keSBsZWFufGJvb2xlYW58ZmFsc2V8ZmFsc2UKW21vdmVdIC0gZGVzeW5jfHNpZGV8bnVtYmVyfGZhbHNlfDUKW21vdmVdIC0gZGVzeW5jfGRlZmF1bHQgc2lkZXxudW1iZXJ8ZmFsc2V8MwpbbW92ZV0gLSBkZXN5bmN8bGVmdCBhbW91bnR8bnVtYmVyfGZhbHNlfDEwMApbbW92ZV0gLSBkZXN5bmN8cmlnaHQgYW1vdW50fG51bWJlcnxmYWxzZXwxMDAKW21vdmVdIC0gZGVzeW5jfGFudGkgYnJ1dGVmb3JjZXxib29sZWFufGZhbHNlfGZhbHNlCltkdWNrXSAtIGFuZ2xlc3x5YXcgbW9kZXxudW1iZXJ8ZmFsc2V8MQpbZHVja10gLSBhbmdsZXN8eWF3IGFkZHxudW1iZXJ8ZmFsc2V8MApbZHVja10gLSBhbmdsZXN8eWF3IGFkZCBsZWZ0fG51bWJlcnxmYWxzZXwwCltkdWNrXSAtIGFuZ2xlc3x5YXcgYWRkIHJpZ2h0fG51bWJlcnxmYWxzZXwwCltkdWNrXSAtIGFuZ2xlc3xyb3RhdGV8Ym9vbGVhbnxmYWxzZXxmYWxzZQpbZHVja10gLSBhbmdsZXN8cm90YXRlIHJhbmdlfG51bWJlcnxmYWxzZXwwCltkdWNrXSAtIGFuZ2xlc3xyb3RhdGUgc3BlZWR8bnVtYmVyfGZhbHNlfDAKW2R1Y2tdIC0gYW5nbGVzfGppdHRlciBtb2RlfG51bWJlcnxmYWxzZXwxCltkdWNrXSAtIGFuZ2xlc3xqaXR0ZXIgdHlwZXxudW1iZXJ8ZmFsc2V8MQpbZHVja10gLSBhbmdsZXN8aml0dGVyIGFkZHxudW1iZXJ8ZmFsc2V8MApbZHVja10gLSBhbmdsZXN8Ym9keSBsZWFufG51bWJlcnxmYWxzZXwxCltkdWNrXSAtIGFuZ2xlc3xib2R5IGxlYW4gdmFsdWV8bnVtYmVyfGZhbHNlfDAKW2R1Y2tdIC0gYW5nbGVzfGJvZHkgbGVhbiBqaXR0ZXJ8bnVtYmVyfGZhbHNlfDAKW2R1Y2tdIC0gYW5nbGVzfG1vdmluZyBib2R5IGxlYW58Ym9vbGVhbnxmYWxzZXxmYWxzZQpbZHVja10gLSBkZXN5bmN8c2lkZXxudW1iZXJ8ZmFsc2V8MQpbZHVja10gLSBkZXN5bmN8ZGVmYXVsdCBzaWRlfG51bWJlcnxmYWxzZXwxCltkdWNrXSAtIGRlc3luY3xsZWZ0IGFtb3VudHxudW1iZXJ8ZmFsc2V8MApbZHVja10gLSBkZXN5bmN8cmlnaHQgYW1vdW50fG51bWJlcnxmYWxzZXwwCltkdWNrXSAtIGRlc3luY3xhbnRpIGJydXRlZm9yY2V8Ym9vbGVhbnxmYWxzZXxmYWxzZQpbYWlyXSAtIGFuZ2xlc3x5YXcgbW9kZXxudW1iZXJ8ZmFsc2V8MQpbYWlyXSAtIGFuZ2xlc3x5YXcgYWRkfG51bWJlcnxmYWxzZXwwClthaXJdIC0gYW5nbGVzfHlhdyBhZGQgbGVmdHxudW1iZXJ8ZmFsc2V8MApbYWlyXSAtIGFuZ2xlc3x5YXcgYWRkIHJpZ2h0fG51bWJlcnxmYWxzZXwwClthaXJdIC0gYW5nbGVzfHJvdGF0ZXxib29sZWFufGZhbHNlfGZhbHNlClthaXJdIC0gYW5nbGVzfHJvdGF0ZSByYW5nZXxudW1iZXJ8ZmFsc2V8MApbYWlyXSAtIGFuZ2xlc3xyb3RhdGUgc3BlZWR8bnVtYmVyfGZhbHNlfDAKW2Fpcl0gLSBhbmdsZXN8aml0dGVyIG1vZGV8bnVtYmVyfGZhbHNlfDEKW2Fpcl0gLSBhbmdsZXN8aml0dGVyIHR5cGV8bnVtYmVyfGZhbHNlfDEKW2Fpcl0gLSBhbmdsZXN8aml0dGVyIGFkZHxudW1iZXJ8ZmFsc2V8MApbYWlyXSAtIGFuZ2xlc3xib2R5IGxlYW58bnVtYmVyfGZhbHNlfDEKW2Fpcl0gLSBhbmdsZXN8Ym9keSBsZWFuIHZhbHVlfG51bWJlcnxmYWxzZXwwClthaXJdIC0gYW5nbGVzfGJvZHkgbGVhbiBqaXR0ZXJ8bnVtYmVyfGZhbHNlfDAKW2Fpcl0gLSBhbmdsZXN8bW92aW5nIGJvZHkgbGVhbnxib29sZWFufGZhbHNlfGZhbHNlClthaXJdIC0gZGVzeW5jfHNpZGV8bnVtYmVyfGZhbHNlfDEKW2Fpcl0gLSBkZXN5bmN8ZGVmYXVsdCBzaWRlfG51bWJlcnxmYWxzZXwxClthaXJdIC0gZGVzeW5jfGxlZnQgYW1vdW50fG51bWJlcnxmYWxzZXwwClthaXJdIC0gZGVzeW5jfHJpZ2h0IGFtb3VudHxudW1iZXJ8ZmFsc2V8MApbYWlyXSAtIGRlc3luY3xhbnRpIGJydXRlZm9yY2V8Ym9vbGVhbnxmYWxzZXxmYWxzZQpbYWlyIGR1Y2tdIC0gYW5nbGVzfHlhdyBtb2RlfG51bWJlcnxmYWxzZXwxClthaXIgZHVja10gLSBhbmdsZXN8eWF3IGFkZHxudW1iZXJ8ZmFsc2V8MApbYWlyIGR1Y2tdIC0gYW5nbGVzfHlhdyBhZGQgbGVmdHxudW1iZXJ8ZmFsc2V8MApbYWlyIGR1Y2tdIC0gYW5nbGVzfHlhdyBhZGQgcmlnaHR8bnVtYmVyfGZhbHNlfDAKW2FpciBkdWNrXSAtIGFuZ2xlc3xyb3RhdGV8Ym9vbGVhbnxmYWxzZXxmYWxzZQpbYWlyIGR1Y2tdIC0gYW5nbGVzfHJvdGF0ZSByYW5nZXxudW1iZXJ8ZmFsc2V8MApbYWlyIGR1Y2tdIC0gYW5nbGVzfHJvdGF0ZSBzcGVlZHxudW1iZXJ8ZmFsc2V8MApbYWlyIGR1Y2tdIC0gYW5nbGVzfGppdHRlciBtb2RlfG51bWJlcnxmYWxzZXwxClthaXIgZHVja10gLSBhbmdsZXN8aml0dGVyIHR5cGV8bnVtYmVyfGZhbHNlfDEKW2FpciBkdWNrXSAtIGFuZ2xlc3xqaXR0ZXIgYWRkfG51bWJlcnxmYWxzZXwwClthaXIgZHVja10gLSBhbmdsZXN8Ym9keSBsZWFufG51bWJlcnxmYWxzZXwxClthaXIgZHVja10gLSBhbmdsZXN8Ym9keSBsZWFuIHZhbHVlfG51bWJlcnxmYWxzZXwwClthaXIgZHVja10gLSBhbmdsZXN8Ym9keSBsZWFuIGppdHRlcnxudW1iZXJ8ZmFsc2V8MApbYWlyIGR1Y2tdIC0gYW5nbGVzfG1vdmluZyBib2R5IGxlYW58Ym9vbGVhbnxmYWxzZXxmYWxzZQpbYWlyIGR1Y2tdIC0gZGVzeW5jfHNpZGV8bnVtYmVyfGZhbHNlfDEKW2FpciBkdWNrXSAtIGRlc3luY3xkZWZhdWx0IHNpZGV8bnVtYmVyfGZhbHNlfDEKW2FpciBkdWNrXSAtIGRlc3luY3xsZWZ0IGFtb3VudHxudW1iZXJ8ZmFsc2V8MApbYWlyIGR1Y2tdIC0gZGVzeW5jfHJpZ2h0IGFtb3VudHxudW1iZXJ8ZmFsc2V8MApbYWlyIGR1Y2tdIC0gZGVzeW5jfGFudGkgYnJ1dGVmb3JjZXxib29sZWFufGZhbHNlfGZhbHNlCltlbmVteSB2aXNpYmxlXSAtIGFuZ2xlc3x5YXcgbW9kZXxudW1iZXJ8ZmFsc2V8MgpbZW5lbXkgdmlzaWJsZV0gLSBhbmdsZXN8eWF3IGFkZHxudW1iZXJ8ZmFsc2V8MApbZW5lbXkgdmlzaWJsZV0gLSBhbmdsZXN8eWF3IGFkZCBsZWZ0fG51bWJlcnxmYWxzZXwzMApbZW5lbXkgdmlzaWJsZV0gLSBhbmdsZXN8eWF3IGFkZCByaWdodHxudW1iZXJ8ZmFsc2V8LTMwCltlbmVteSB2aXNpYmxlXSAtIGFuZ2xlc3xyb3RhdGV8Ym9vbGVhbnxmYWxzZXxmYWxzZQpbZW5lbXkgdmlzaWJsZV0gLSBhbmdsZXN8cm90YXRlIHJhbmdlfG51bWJlcnxmYWxzZXwwCltlbmVteSB2aXNpYmxlXSAtIGFuZ2xlc3xyb3RhdGUgc3BlZWR8bnVtYmVyfGZhbHNlfDAKW2VuZW15IHZpc2libGVdIC0gYW5nbGVzfGppdHRlciBtb2RlfG51bWJlcnxmYWxzZXwzCltlbmVteSB2aXNpYmxlXSAtIGFuZ2xlc3xqaXR0ZXIgdHlwZXxudW1iZXJ8ZmFsc2V8MgpbZW5lbXkgdmlzaWJsZV0gLSBhbmdsZXN8aml0dGVyIGFkZHxudW1iZXJ8ZmFsc2V8MTUKW2VuZW15IHZpc2libGVdIC0gYW5nbGVzfGJvZHkgbGVhbnxudW1iZXJ8ZmFsc2V8MQpbZW5lbXkgdmlzaWJsZV0gLSBhbmdsZXN8Ym9keSBsZWFuIHZhbHVlfG51bWJlcnxmYWxzZXwwCltlbmVteSB2aXNpYmxlXSAtIGFuZ2xlc3xib2R5IGxlYW4gaml0dGVyfG51bWJlcnxmYWxzZXwwCltlbmVteSB2aXNpYmxlXSAtIGFuZ2xlc3xtb3ZpbmcgYm9keSBsZWFufGJvb2xlYW58ZmFsc2V8ZmFsc2UKW2VuZW15IHZpc2libGVdIC0gZGVzeW5jfHNpZGV8bnVtYmVyfGZhbHNlfDUKW2VuZW15IHZpc2libGVdIC0gZGVzeW5jfGRlZmF1bHQgc2lkZXxudW1iZXJ8ZmFsc2V8MwpbZW5lbXkgdmlzaWJsZV0gLSBkZXN5bmN8bGVmdCBhbW91bnR8bnVtYmVyfGZhbHNlfDEwMApbZW5lbXkgdmlzaWJsZV0gLSBkZXN5bmN8cmlnaHQgYW1vdW50fG51bWJlcnxmYWxzZXwxMDAKW2VuZW15IHZpc2libGVdIC0gZGVzeW5jfGFudGkgYnJ1dGVmb3JjZXxib29sZWFufGZhbHNlfGZhbHNlCltrZXliaW5kXSAtIGFuZ2xlc3x5YXcgbW9kZXxudW1iZXJ8ZmFsc2V8MQpba2V5YmluZF0gLSBhbmdsZXN8eWF3IGFkZHxudW1iZXJ8ZmFsc2V8MApba2V5YmluZF0gLSBhbmdsZXN8eWF3IGFkZCBsZWZ0fG51bWJlcnxmYWxzZXwwCltrZXliaW5kXSAtIGFuZ2xlc3x5YXcgYWRkIHJpZ2h0fG51bWJlcnxmYWxzZXwwCltrZXliaW5kXSAtIGFuZ2xlc3xyb3RhdGV8Ym9vbGVhbnxmYWxzZXxmYWxzZQpba2V5YmluZF0gLSBhbmdsZXN8cm90YXRlIHJhbmdlfG51bWJlcnxmYWxzZXwwCltrZXliaW5kXSAtIGFuZ2xlc3xyb3RhdGUgc3BlZWR8bnVtYmVyfGZhbHNlfDAKW2tleWJpbmRdIC0gYW5nbGVzfGppdHRlciBtb2RlfG51bWJlcnxmYWxzZXwxCltrZXliaW5kXSAtIGFuZ2xlc3xqaXR0ZXIgdHlwZXxudW1iZXJ8ZmFsc2V8MQpba2V5YmluZF0gLSBhbmdsZXN8aml0dGVyIGFkZHxudW1iZXJ8ZmFsc2V8MApba2V5YmluZF0gLSBhbmdsZXN8Ym9keSBsZWFufG51bWJlcnxmYWxzZXwxCltrZXliaW5kXSAtIGFuZ2xlc3xib2R5IGxlYW4gdmFsdWV8bnVtYmVyfGZhbHNlfDAKW2tleWJpbmRdIC0gYW5nbGVzfGJvZHkgbGVhbiBqaXR0ZXJ8bnVtYmVyfGZhbHNlfDAKW2tleWJpbmRdIC0gYW5nbGVzfG1vdmluZyBib2R5IGxlYW58Ym9vbGVhbnxmYWxzZXxmYWxzZQpba2V5YmluZF0gLSBkZXN5bmN8c2lkZXxudW1iZXJ8ZmFsc2V8MQpba2V5YmluZF0gLSBkZXN5bmN8ZGVmYXVsdCBzaWRlfG51bWJlcnxmYWxzZXwxCltrZXliaW5kXSAtIGRlc3luY3xsZWZ0IGFtb3VudHxudW1iZXJ8ZmFsc2V8MApba2V5YmluZF0gLSBkZXN5bmN8cmlnaHQgYW1vdW50fG51bWJlcnxmYWxzZXwwCltrZXliaW5kXSAtIGRlc3luY3xhbnRpIGJydXRlZm9yY2V8Ym9vbGVhbnxmYWxzZXxmYWxzZQpbdW5jaGFyZ2VkXSAtIGFuZ2xlc3x5YXcgbW9kZXxudW1iZXJ8ZmFsc2V8MgpbdW5jaGFyZ2VkXSAtIGFuZ2xlc3x5YXcgYWRkfG51bWJlcnxmYWxzZXwwClt1bmNoYXJnZWRdIC0gYW5nbGVzfHlhdyBhZGQgbGVmdHxudW1iZXJ8ZmFsc2V8MTcKW3VuY2hhcmdlZF0gLSBhbmdsZXN8eWF3IGFkZCByaWdodHxudW1iZXJ8ZmFsc2V8LTE3Clt1bmNoYXJnZWRdIC0gYW5nbGVzfHJvdGF0ZXxib29sZWFufGZhbHNlfGZhbHNlClt1bmNoYXJnZWRdIC0gYW5nbGVzfHJvdGF0ZSByYW5nZXxudW1iZXJ8ZmFsc2V8MApbdW5jaGFyZ2VkXSAtIGFuZ2xlc3xyb3RhdGUgc3BlZWR8bnVtYmVyfGZhbHNlfDAKW3VuY2hhcmdlZF0gLSBhbmdsZXN8aml0dGVyIG1vZGV8bnVtYmVyfGZhbHNlfDEKW3VuY2hhcmdlZF0gLSBhbmdsZXN8aml0dGVyIHR5cGV8bnVtYmVyfGZhbHNlfDEKW3VuY2hhcmdlZF0gLSBhbmdsZXN8aml0dGVyIGFkZHxudW1iZXJ8ZmFsc2V8MApbdW5jaGFyZ2VkXSAtIGFuZ2xlc3xib2R5IGxlYW58bnVtYmVyfGZhbHNlfDYKW3VuY2hhcmdlZF0gLSBhbmdsZXN8Ym9keSBsZWFuIHZhbHVlfG51bWJlcnxmYWxzZXwtNTAKW3VuY2hhcmdlZF0gLSBhbmdsZXN8Ym9keSBsZWFuIGppdHRlcnxudW1iZXJ8ZmFsc2V8MApbdW5jaGFyZ2VkXSAtIGFuZ2xlc3xtb3ZpbmcgYm9keSBsZWFufGJvb2xlYW58ZmFsc2V8dHJ1ZQpbdW5jaGFyZ2VkXSAtIGRlc3luY3xzaWRlfG51bWJlcnxmYWxzZXw0Clt1bmNoYXJnZWRdIC0gZGVzeW5jfGRlZmF1bHQgc2lkZXxudW1iZXJ8ZmFsc2V8MQpbdW5jaGFyZ2VkXSAtIGRlc3luY3xsZWZ0IGFtb3VudHxudW1iZXJ8ZmFsc2V8MTAwClt1bmNoYXJnZWRdIC0gZGVzeW5jfHJpZ2h0IGFtb3VudHxudW1iZXJ8ZmFsc2V8MTAwClt1bmNoYXJnZWRdIC0gZGVzeW5jfGFudGkgYnJ1dGVmb3JjZXxib29sZWFufGZhbHNlfHRydWU='

    local conditions = {
        "global",
        "stand",
        "slowwalk", 
        "move",
        "duck",
        "air",
        "air duck",
        "enemy visible",
        "keybind",
        "uncharged",
    }

    local references = {
        menu = {
            group1              = menu.set_group_column("antiaim builder", 1),
            group2              = menu.set_group_column("config", 1),
            conditionselection  = menu.add_list("antiaim builder", "select condition", conditions),
            conditionenable     = menu.add_multi_selection("antiaim builder", "enabled conditions", {"stand","slowwalk", "move","duck","air","air duck","enemy visible","keybind", "uncharged"}),
            keybindbox          = menu.add_text("antiaim builder", "set keybind for condition"),
            exportconfig        = menu.add_button("config", "export settings to clipboard", function() clipboard_export(base64.encode(config.export_settings(), base64.default_encode_alphabet)) end),
            importconfig        = menu.add_button("config", "import settings from clipboard", function()config.import_settings(base64.decode(clipboard_import(), base64.default_decode_alphabet))end),
            defaultconfig       = menu.add_button("config", "load default settings",    function()config.import_settings(base64.decode(configstring, base64.default_decode_alphabet))end),

        },
        antiaimfinds = {
            -- angles
            menu.find("antiaim", "main", "angles", "yaw add"),
            menu.find("antiaim", "main", "angles", "rotate"),
            menu.find("antiaim", "main", "angles", "rotate range"),
            menu.find("antiaim", "main", "angles", "rotate speed"),
            menu.find("antiaim", "main", "angles", "jitter mode"),
            menu.find("antiaim", "main", "angles", "jitter type"),
            menu.find("antiaim", "main", "angles", "jitter add"),

            -- body lean
            menu.find("antiaim", "main", "angles", "body lean"),
            menu.find("antiaim", "main", "angles", "body lean value"),
            menu.find("antiaim", "main", "angles", "body lean jitter"),
            menu.find("antiaim", "main", "angles", "moving body lean"),

            -- desync
            menu.find("antiaim", "main", "desync", "side"),
            menu.find("antiaim", "main", "desync", "default side"),
            menu.find("antiaim", "main", "desync", "left amount"),
            menu.find("antiaim", "main", "desync", "right amount"),
            menu.find("antiaim", "main", "desync", "anti bruteforce"),
        },
        miscfinds = {
            slowwalk = menu.find("misc", "main", "movement", "slow walk"),
        },
    }
    local keybind = references.menu.keybindbox:add_keybind("condition keybind")

    -- creates menu
    local active_elements = {}
    local hidden_elements = {}

for i = 1, #conditions do
        active_elements[i] = {
            -- angles
            menu.add_selection("[".. conditions[i] .. "] - angles", "yaw mode",{"static", "sync to desync side", "jitter"}),
            menu.add_slider("[".. conditions[i] .. "] - angles", "yaw add", -180, 180, 1.0, 0, "°"),
            menu.add_slider("[".. conditions[i] .. "] - angles", "yaw add left", -180, 180, 1.0, 0, "°"),
            menu.add_slider("[".. conditions[i] .. "] - angles", "yaw add right", -180, 180, 1.0, 0, "°"),
            menu.add_checkbox("[".. conditions[i] .. "] - angles", "rotate", false),
            menu.add_slider("[".. conditions[i] .. "] - angles", "rotate range", 0, 360, 1.0, 0, "°"),
            menu.add_slider("[".. conditions[i] .. "] - angles", "rotate speed", 0, 100, 1.0, 0, "%"),
            menu.add_selection("[".. conditions[i] .. "] - angles", "jitter mode", {"none", "static", "random"}),
            menu.add_selection("[".. conditions[i] .. "] - angles", "jitter type", {"offset", "center"}),
            menu.add_slider("[".. conditions[i] .. "] - angles", "jitter add", -180, 180, 1.0, 0, "°"),

            -- body lean
            menu.add_selection("[".. conditions[i] .. "] - angles", "body lean", {"none", "static", "static jitter", "random jitter", "sway", "sync to desync side"}),
            menu.add_slider("[".. conditions[i] .. "] - angles", "body lean value", -50, 50, 1.0, 0, "°"),
            menu.add_slider("[".. conditions[i] .. "] - angles", "body lean jitter", -50, 50, 1.0, 0, "%"),
            menu.add_checkbox("[".. conditions[i] .. "] - angles", "moving body lean", false),
            
            -- desync
            menu.add_selection("[".. conditions[i] .. "] - desync", "side", {"none", "left", "right", "jitter", "peek fake", "peek real", "body sway"}),
            menu.add_selection("[".. conditions[i] .. "] - desync", "default side", {"left", "right", "jitter"}),
            menu.add_slider("[".. conditions[i] .. "] - desync", "left amount", 0, 100, 1.0, 0, "%"),
            menu.add_slider("[".. conditions[i] .. "] - desync", "right amount", 0, 100, 1.0, 0, "%"),
            menu.add_checkbox("[".. conditions[i] .. "] - desync", "anti bruteforce", false),

            menu.set_group_column("[".. conditions[i] .. "] - angles", 2),
            menu.set_group_column("[".. conditions[i] .. "] - desync", 2),


        }
        hidden_elements[i] = menu.add_text("", "")
        hidden_elements[i]:set_visible(false)
end

-- returns player speed
local function handle_speed(player)

        if not engine.is_connected() or not engine.is_in_game() then
            return
        else

        x = player:get_prop("m_vecVelocity[0]")
        y = player:get_prop("m_vecVelocity[1]")
        z = player:get_prop("m_vecVelocity[2]")
        if x == nil then return end
            return math.sqrt(x*x + y*y + z*z)
        end
end

    -- returns true or false if enemy is visible
local function handle_enemyvisible()
        if not engine.is_connected() or not engine.is_in_game() then
            return        
        else
        local is_point_visible = function(ent)
            local e_pos = ent:get_hitbox_pos(e_hitgroups.GENERIC)
            if entity_list.get_local_player():is_point_visible(e_pos) then
                return true
            else
                return false
            end
        end
            local enemies= entity_list.get_players(true)
            local local_player = entity_list.get_local_player()   
            local can_see = false
        
        
            for _, enemy in pairs(enemies) do
                if is_point_visible(enemy) then
                    can_see = true
                end
            end
    
                return can_see
        end
end

-- returns condition (1 to 6)
local function handle_condition()

        if not engine.is_connected() or not engine.is_in_game() then
            return
        else

        local condition = {}
        condition.localplayer   = entity_list.get_local_player()
        condition.speed         = math.floor(handle_speed(condition.localplayer))
        condition.ducked        = condition.localplayer:get_prop("m_bDucked") == 1
        condition.air           = condition.localplayer:get_prop("m_vecVelocity[2]") ~= 0
        condition.choked        = engine.get_choked_commands()
        condition.charge        = exploits.get_charge()

        condition.enemyvisible  = handle_enemyvisible()

            -- global
        condition.value         = 1

            -- stand
        if condition.speed < 10 and not condition.air and not condition.ducked and references.menu.conditionenable:get(1) then
            condition.value = 2

            -- slowwalk
        elseif references.miscfinds.slowwalk[2]:get( ) == true and references.menu.conditionenable:get(2) then
            condition.value = 3

            -- move
        elseif condition.speed > 10 and not condition.air and not condition.ducked and references.menu.conditionenable:get(3) then
            condition.value = 4

            -- duck
        elseif condition.ducked and not condition.air and references.menu.conditionenable:get(4) then
            condition.value = 5

            -- air
        elseif condition.air and not condition.ducked and references.menu.conditionenable:get(5) then
            condition.value = 6

            -- air and duck
        elseif condition.ducked and condition.air and references.menu.conditionenable:get(6) then
            condition.value = 7
        end

        -- uncharged
        if condition.choked >= 0 and condition.charge < 1 and references.menu.conditionenable:get(9) then
            condition.value = 10
        end

            -- enemy visible
        if condition.enemyvisible and references.menu.conditionenable:get(7) then
            condition.value = 8
        end

            -- keybind
        if keybind:get() and references.menu.conditionenable:get(8) then
            condition.value = 9
        end



        return condition.value
    end
end

local var1, var2 = 0
local function handle_jitter()
    if math.abs(global_vars.tick_count() - var1) > 1 then
        var2 = var2 == 1 and 0 or 1
        var1 = global_vars.tick_count()
    end
    return var2
end


local function handle_antiaim(condition)

    if not engine.is_connected() or not engine.is_in_game() then
        return        
    else

    local elements =  active_elements[condition]
    local antiaimside = antiaim.get_desync_side()
    local jitter = handle_jitter()
    local yawvalue = 1
    local defaultside = 1
    local bodyleanvalue = 1

    if elements[1]:get() == 1 then
        yawvalue = elements[2]:get()
    elseif elements[1]:get() == 2 then
        if antiaimside == 1 then
            yawvalue = elements[3]:get()
        elseif antiaimside == 2 then
            yawvalue = elements[4]:get()
        elseif antiaimside == 0 then
            yawvalue = 0
        end
    elseif elements[1]:get() == 3 then
        if jitter == 1 then
            yawvalue = elements[3]:get()
        else
            yawvalue = elements[4]:get()
        end
    else
        print("invalid yaw mode")
    end

    if elements[11]:get() == 2 then
        bodyleanvalue = elements[12]:get()
    elseif elements[11]:get() == 6 then
        bodyleanmode = 2
        if antiaimside == 1 then
            bodyleanvalue = elements[12]:get()
        elseif antiaimside == 2 then
            bodyleanvalue = -elements[12]:get()
        else
            bodyleanvalue = 0
        end
    else
        bodyleanmode = elements[12]:get()
    end

    if elements[16]:get() == 1 then
        defaultside = 1
    elseif elements[16]:get() == 2 then
        defaultside = 2
    elseif elements[16]:get() == 3 then
        if jitter == 1 then 
            defaultside = 1 
        else 
            defaultside = 2 
        end
    end

    local returns = {
        yawvalue,
        elements[5]:get(),
        elements[6]:get(),
        elements[7]:get(),
        elements[8]:get(),
        elements[9]:get(),
        elements[10]:get(),
        bodyleanmode,
        bodyleanvalue,
        elements[13]:get(),
        elements[14]:get(),
        elements[15]:get(),
        defaultside,
        elements[17]:get(),
        elements[18]:get(),
        elements[19]:get(),
    }

    return returns

    end
end

local function on_antiaim()

    if not engine.is_connected() or not engine.is_in_game() then
        return        
    else

        condition = handle_condition()
        local antiaim = handle_antiaim(condition)
        for i = 1, #references.antiaimfinds do
            references.antiaimfinds[i]:set(antiaim[i])
        end

    end
end

local function on_paint()

        -- hides not selected menu items
        for i = 1, #conditions  do
            local main = references.menu.conditionselection:get() == i

            for n = 1, 19 do
                active_elements[i][n]:set_visible(main)
            end

            active_elements[i][2]:set_visible(main and active_elements[i][1]:get() == 1)
            active_elements[i][3]:set_visible(main and active_elements[i][1]:get() ~= 1)
            active_elements[i][4]:set_visible(main and active_elements[i][1]:get() ~= 1)
            active_elements[i][6]:set_visible(main and active_elements[i][5]:get())
            active_elements[i][7]:set_visible(main and active_elements[i][5]:get())
            active_elements[i][9]:set_visible(main and active_elements[i][8]:get() ~= 1)
            active_elements[i][10]:set_visible(main and active_elements[i][8]:get() ~= 1)
            active_elements[i][12]:set_visible(main and active_elements[i][11]:get() == 2 or main and active_elements[i][11]:get() == 6)
            active_elements[i][13]:set_visible(main and active_elements[i][11]:get() == 3 or main and active_elements[i][11]:get() == 4)
            active_elements[i][14]:set_visible(main and active_elements[i][11]:get() ~= 1)
            active_elements[i][16]:set_visible(main and active_elements[i][15]:get() == 5 or main and active_elements[i][15]:get() == 6)
            active_elements[i][17]:set_visible(main and active_elements[i][15]:get() ~= 1)
            active_elements[i][18]:set_visible(main and active_elements[i][15]:get() ~= 1)
            active_elements[i][19]:set_visible(main and active_elements[i][15]:get() ~= 1)

        end
end

    callbacks.add(e_callbacks.ANTIAIM, on_antiaim)
    callbacks.add(e_callbacks.PAINT, on_paint)