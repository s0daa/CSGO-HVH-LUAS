local bit = require "bit"
local M = {}

local shl, shr, band = bit.lshift, bit.rshift, bit.band
local char, byte, gsub, sub, format, concat, tostring, error, pairs = string.char, string.byte, string.gsub, string.sub, string.format, table.concat, tostring, error, pairs

local extract = function(v, from, width)
	return band(shr(v, from), shl(1, width) - 1)
end

local function makeencoder(alphabet)
	local encoder, decoder = {}, {}

	for i=1, 65 do
		local chr = byte(sub(alphabet, i, i)) or 32 -- or " "
		if decoder[chr] ~= nil then
			error("invalid alphabet: duplicate character " .. tostring(chr), 3)
		end
		encoder[i-1] = chr
		decoder[chr] = i-1
	end

	return encoder, decoder
end

local encoders, decoders = {}, {}

encoders["base64"], decoders["base64"] = makeencoder("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")
encoders["base64url"], decoders["base64url"] = makeencoder("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_")

local alphabet_mt = {
	__index = function(tbl, key)
		if type(key) == "string" and key:len() == 64 or key:len() == 65 then
			-- if key is a valid looking base64 alphabet, try to make an encoder/decoder pair from it
			encoders[key], decoders[key] = makeencoder(key)

			return tbl[key]
		end
	end
}

setmetatable(encoders, alphabet_mt)
setmetatable(decoders, alphabet_mt)

function M.encode(str, encoder)
	encoder = encoders[encoder or "base64"] or error("invalid alphabet specified", 2)

	str = tostring(str)

	local t, k, n = {}, 1, #str
	local lastn = n % 3
	local cache = {}

	for i = 1, n-lastn, 3 do
		local a, b, c = byte(str, i, i+2)
		local v = a*0x10000 + b*0x100 + c
		local s = cache[v]

		if not s then
			s = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[extract(v,0,6)])
			cache[v] = s
		end

		t[k] = s
		k = k + 1
	end

	if lastn == 2 then
		local a, b = byte(str, n-1, n)
		local v = a*0x10000 + b*0x100
		t[k] = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[64])
	elseif lastn == 1 then
		local v = byte(str, n)*0x10000
		t[k] = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[64], encoder[64])
	end

	return concat(t)
end

function M.decode(b64, decoder)
	decoder = decoders[decoder or "base64"] or error("invalid alphabet specified", 2)

	local pattern = "[^%w%+%/%=]"

	if decoder then
		local s62, s63

		for charcode, b64code in pairs(decoder) do
			if b64code == 62 then s62 = charcode
			elseif b64code == 63 then s63 = charcode
			end
		end

		pattern = format("[^%%w%%%s%%%s%%=]", char(s62), char(s63))
	end

	b64 = gsub(tostring(b64), pattern, '')

	local cache = {}
	local t, k = {}, 1
	local n = #b64
	local padding = sub(b64, -2) == "==" and 2 or sub(b64, -1) == "=" and 1 or 0

	for i = 1, padding > 0 and n-4 or n, 4 do
		local a, b, c, d = byte(b64, i, i+3)

		local v0 = a*0x1000000 + b*0x10000 + c*0x100 + d
		local s = cache[v0]

		if not s then
			local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40 + decoder[d]
			s = char(extract(v,16,8), extract(v,8,8), extract(v,0,8))
			cache[v0] = s
		end

		t[k] = s
		k = k + 1
	end

	if padding == 1 then
		local a, b, c = byte(b64, n-3, n-1)
		local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40
		t[k] = char(extract(v,16,8), extract(v,8,8))
	elseif padding == 2 then
		local a, b = byte(b64, n-3, n-2)
		local v = decoder[a]*0x40000 + decoder[b]*0x1000
		t[k] = char(extract(v,16,8))
	end

	return concat(t)
end

return M