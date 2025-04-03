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

return base64