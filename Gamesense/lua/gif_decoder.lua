--[===================================================================[--
	 Copyright © 2016, 2018 Pedro Gimeno Fortea. All rights reserved.

	 Permission is hereby granted to everyone to copy and use this file,
	 for any purpose, in whole or in part, free of charge, provided this
	 single condition is met: The above copyright notice, together with
	 this permission grant and the disclaimer below, should be included
	 in all copies of this software or of a substantial portion of it.

	 THIS SOFTWARE COMES WITHOUT ANY WARRANTY, EXPRESS OR IMPLIED.
--]===================================================================]--

-- GIF(sm) image decoder for the love2d framework, using LuaJIT + FFI.
-- ported to gamesense lua api by sapphyrus
-- Includes LZW decompression.

local ffi = require 'ffi'
local bit = require 'bit'
local table_new = require 'table.new'
local table_clear = require 'table.clear'

local renderer_load_rgba, string_format, table_insert, bit_band, bit_rshift, bit_lshift, string_char, coroutine_yield, ffi_new, ffi_copy, ffi_fill, ffi_string = renderer.load_rgba, string.format, table.insert, bit.band, bit.rshift, bit.lshift, string.char, coroutine.yield, ffi.new, ffi.copy, ffi.fill, ffi.string

-- We have a "double buffer" coroutine-based consumer-producer system
-- requiring the consumer to not request large chunks at a time
-- otherwise the buffer would overflow (this is detected but it will
-- cause an assertion error).

local bytearray = ffi.typeof('uint8_t[?]')
local intarray = ffi.typeof('int[?]')

if not pcall(ffi.sizeof, "gif_rgba") then
	ffi.cdef("typedef union { uint32_t all; struct { uint8_t r, g, b, a; }; } gif_rgba;")
	ffi.cdef("typedef struct { uint8_t r,g,b; } gif_rgb;")
end

local gif_rgba = ffi.typeof("gif_rgba")
local gif_rgba_array = ffi.typeof("gif_rgba[?]")
local gif_rgb_ptr = ffi.typeof("const gif_rgb *")

-- Interlaced mode table. Format:
-- {initial value for pass 1, increment for pass 1,
--  initial value for pass 2, increment for pass 2, ...}
local intertable = {0, 8, 4, 8, 2, 4, 1, 2, false}

-- constants
local GIF_MAGIC1 = 'GIF87a'
local GIF_MAGIC2 = 'GIF89a'
local GIF_INVALID_BLOCK = 0x3B
local GIF_IMG_BLOCK = 0x2C
local GIF_EXT_BLOCK = 0x21
local GIF_APP_BLOCK = 0xFF
local GIF_GFX_CTL_BLOCK = 0xF9
local GIF_GFX_TEXT_BLOCK = 0x01
local GIF_GFX_COMMENT_BLOCK = 0xFE

local transparent_rgba = ffi_new(gif_rgba)

-- Consumer
local function gifread(self, length)
	local curptr = self.baseva + self.seekpos
	local size_remaining = self.endva - curptr
	if length > size_remaining then
		return error('tried to read past end')
	end
	local tmp = self.seekpos
	self.seekpos = tmp + length
	return tmp
end

local function gifread_u8(self)
	return self.baseva[gifread(self, 1)]
end

local function gifdone(self)
	-- clean up non-public vars
	self.baseva = nil
	self.endva = nil
	self.contents = nil
	self.ncomplete = nil

	-- calculate gif duration
	self.duration = 0
	for i=1, #self.frames do
		self.duration = self.duration + self.frames[i][2]
	end
end

-- Gif decoding aux functions
local function gifpalette(palette, source, psize)
	-- Read a palette, inserting alpha

	local src = ffi.cast(gif_rgb_ptr, source)

	for i = 0, psize - 1 do
		palette[i].r = src[i].r
		palette[i].g = src[i].g
		palette[i].b = src[i].b
		palette[i].a = 255
	end
end

-- Gif decoder proper
local function gifdecode(self)
	if #self.contents < 13 then
		return 'Invalid GIF file format'
	end

	local magic = self.contents:sub(1, 6)

	-- Read file ID and header
	gifread(self, 13)
	if magic ~= GIF_MAGIC1 and magic ~= GIF_MAGIC2 then
		return 'Invalid GIF file format'
	end

	local buffer = self.baseva

	local iw, ih = buffer[6] + 256*buffer[7], buffer[8] + 256*buffer[9]
	local npixels = iw*ih
	local image_data = gif_rgba_array(npixels)
	self.width, self.height = iw, ih

	local gpalettesize = buffer[10] >= 128 and bit_lshift(1, bit_band(buffer[10], 7) + 1) or 0
	local background = buffer[11]
	self.aspect = ((buffer[12] == 0 and 49 or 0) + 15) / 64

	local gpalette = gif_rgba_array(256)
	local lpalette = gif_rgba_array(256)

	local lpalettesize, c_background
	-- Read palette and set background
	if gpalettesize > 0 then
		gifread(self, gpalettesize * 3)
		gifpalette(gpalette, buffer + 13, gpalettesize)

		if background < gpalettesize then
			c_background = gif_rgba()
			c_background.r = gpalette[background].r
			c_background.g = gpalette[background].g
			c_background.b = gpalette[background].b
		end
	end

	local p
	local GCE_trans = false
	local GCE_dispose = 0
	local GCE_delay = 0

	-- Allocate the buffers in advance, to reuse them for every frame
	local dict = bytearray(4096)
	local dictptrs = intarray(4096)
	local reversebuf = bytearray(4096)

	if c_background ~= nil and c_background.a > 0 then
		for i=0, npixels-1 do
			image_data[i].all = c_background.all
		end
	end

	while true do
		-- Get block type
		local blocktype = gifread_u8(self)
		local blocklen
		-- for simplicity (?), we fuse the block type and the extension type into
		-- 'blocktype'
		if blocktype == GIF_IMG_BLOCK then
			-- Image block
			blocktype = GIF_IMG_BLOCK
		elseif blocktype == GIF_EXT_BLOCK then
			-- Extension block
			blocktype = gifread_u8(self)
			if blocktype == GIF_IMG_BLOCK then
				-- there's no extension 2C - terminate
				-- (avoids ambiguity with block type 2C)
				break
			end
		elseif blocktype ~= GIF_INVALID_BLOCK then
			return string_format("Unknown block type: 0x%02X", blocktype)
		end

		if blocktype == GIF_INVALID_BLOCK then
			-- Trailer block or invalid block - terminate
			break
		elseif blocktype == GIF_APP_BLOCK then
			-- Application extension - may be loop, otherwise skip
			blocklen = gifread_u8(self)
			p = gifread(self, blocklen + 1)
			if blocklen >= 11 and ffi.string(buffer + p, 11) == 'NETSCAPE2.0' then
				-- these *are* the androids we're looking for
				p = p + blocklen
				while buffer[p] ~= 0 do
					local sblen = buffer[p]
					p = gifread(self, sblen + 1) -- read also the next block length
					if buffer[p] == 1 and sblen >= 3 then
						-- looping subblock - that's for us
						self.loop = buffer[p + 1] + 256 * buffer[p + 2]
					end
					p = p + sblen -- advance to next block
				end
			else
				-- skip entire block
				p = p + blocklen
				while buffer[p] ~= 0 do
					gifread(self, buffer[p])
					p = gifread(self, 1)
				end
			end

		elseif blocktype == GIF_GFX_TEXT_BLOCK or blocktype == GIF_GFX_COMMENT_BLOCK then
			-- Text or Comment Extension - not processed by us, skip
			p = gifread(self, 1) -- read length
			if blocktype < GIF_GFX_TEXT_BLOCK then
				-- skip the block header (contains a length field)
				p = gifread(self, buffer[p] + 1) + buffer[p]

				-- the text extension "consumes" the GCE, so we clear it
				GCE_trans = false
				GCE_dispose = 0
				GCE_delay = 0
			end
			while buffer[p] ~= 0 do
				p = gifread(self, buffer[p] + 1) + buffer[p]
			end

		elseif blocktype == GIF_GFX_CTL_BLOCK then
			-- Graphic Control Extension
			p = gifread(self, 1)
			blocklen = buffer[p]
			p = gifread(self, blocklen + 1)
			if blocklen >= 4 then
				GCE_delay = (buffer[p+1] + 256 * buffer[p+2]) / 100
				GCE_trans = bit_band(buffer[p], 1) ~= 0 and buffer[p + 3]
				GCE_dispose = bit_rshift(bit_band(buffer[p], 0x1C), 2)

				if GCE_delay == 0 then
					GCE_delay = 0.1
				end
			end
			p = p + blocklen
			while buffer[p] ~= 0 do
				p = gifread(self, buffer[p] + 1) + buffer[p]
			end
		elseif blocktype == GIF_IMG_BLOCK then
			-- Here be dragons
			p = gifread(self, 9)

			local x, y = buffer[p] + 256*buffer[p+1], buffer[p+2] + 256*buffer[p+3]
			local w, h = buffer[p+4] + 256*buffer[p+5], buffer[p+6] + 256*buffer[p+7]

			if w == 0 or h == 0 then
				return 'Zero size image'
			end

			table_insert(self.frames, {GCE_dispose, GCE_delay, x, y, w, h})
			local fx, fy, fw, fh = x, y, w, h
			local frame_compressed = fx ~= 0 or fy ~= 0 or fw ~= iw or fh ~= ih

			local flags = buffer[p+8]
			if flags >= 128 then
				-- Has local palette
				lpalettesize = bit_lshift(1, bit_band(flags, 7) + 1)
				p = gifread(self, lpalettesize*3)
				gifpalette(lpalette, buffer + p, lpalettesize)
			else
				-- No local palette - copy the global palette to the local one
				-- lpalette = gpalette
				ffi_copy(lpalette, gpalette, gpalettesize*4)
				lpalettesize = gpalettesize
			end
			if GCE_trans and GCE_trans < lpalettesize then
				-- Clear alpha
				lpalette[GCE_trans].all = 0
			end
			local interlace = bit_band(flags, 64) ~= 0 and 1

			-- LZW decoder.

			-- This could really use another coroutine for
			-- simplicity, as there's another producer/consumer,
			-- but we won't go there.

			p = gifread(self, 2)
			local LZWsize = buffer[p]
			p = p + 1
			if LZWsize == 0 or LZWsize > 11 then
				return "Invalid code size"
			end
			local codebits = LZWsize + 1
			local clearcode = bit_lshift(1, LZWsize) -- End-of-stream is always clearcode+1
			local dictlen = clearcode + 2

			local bitstream, bitlen = 0, 0
			x, y = 0, 0
			local nextlenptr = p
			local oldcode
			local walkcode

			local nrows = 0 -- counts vertical rows, used because interlacing makes the last y invalid
			local frame_offset = iw*fy + fx

			while true do
				-- Are there enough bits in curcode? Do we need to read more data?
				if bitlen >= codebits and y then
					-- Extract next code
					local code = bit_band(bitstream, bit_lshift(1, codebits) - 1)
					bitstream = bit_rshift(bitstream, codebits)
					bitlen = bitlen - codebits

					if code == clearcode then
						codebits = LZWsize + 1
						dictlen = clearcode + 2
						oldcode = false
					elseif code == clearcode + 1 then
						if x ~= 0 or nrows ~= h then
							return "Soft EOD before all rows were output"
						end
						-- signal end of processing
						-- (further data won't be read, but we need to follow the blocks)
						y = false
					else
						-- The dictionary is stored as a list of back pointers.
						-- We need to reverse the order to output the entries.
						-- We use a reverse buffer for that.
						local reverseptr = 4095
						-- Is this code already in the table?
						if code < dictlen then
							-- Already in the table - get the string from the table
							walkcode = code
							while walkcode >= clearcode do
								reversebuf[reverseptr] = dict[walkcode]
								reverseptr = reverseptr - 1
								walkcode = dictptrs[walkcode]
							end
							reversebuf[reverseptr] = walkcode
							-- Add to the table
							if oldcode then
								if dictlen < 4096 then
									dictptrs[dictlen] = oldcode
									dict[dictlen] = walkcode
									dictlen = dictlen + 1
									if dictlen ~= 4096 and bit_band(dictlen, dictlen - 1) == 0 then
										-- perfect power of two - increase code size
										codebits = codebits + 1
									end
								end
							end
							oldcode = code
						else
							-- Not in the table - deal with the special case
							-- The compressor has created a new code, which must be the next
							-- in sequence. We know what it must contain.
							-- It must contain oldcode + first character of oldcode.
							if code > dictlen or not oldcode or not walkcode then
								return "Broken LZW"
							end

							-- Add to the table
							if oldcode then
								if dictlen < 4096 then
									dictptrs[dictlen] = oldcode
									dict[dictlen] = walkcode
									dictlen = dictlen + 1
									if dictlen ~= 4096 and bit_band(dictlen, dictlen - 1) == 0 then
										-- perfect power of two - increase code size
										codebits = codebits + 1
									end
								end
							end
							oldcode = code
							walkcode = oldcode

							while walkcode >= clearcode do
								reversebuf[reverseptr] = dict[walkcode]
								reverseptr = reverseptr - 1
								walkcode = dictptrs[walkcode]
							end
							reversebuf[reverseptr] = walkcode
						end

						if y then
							for i = reverseptr, 4095 do
								local c = reversebuf[i]
								if c >= lpalettesize then c = 0 end

								local lpi = lpalette[c]
								if GCE_dispose ~= 1 or lpi.all > 0 then
									c = lpi

									image_data[frame_offset + x] = c

									if (fx > 0 or fy > 0) and interlace then
										return "Interlaced + frame compressed gifs not supported"
									end
								end

								if interlace then
									-- The passes 1, 2, 3, 4 correspond to the
									-- values 1, 3, 5, 7 of 'interlace'.
									if c and self.progressive and interlace < 7 and y + 1 < h then
										-- In any pass but the last, there are at least 2 lines.
										image_data[frame_offset + x + w] = c
										if interlace < 5 and y + 2 < h then
											-- In the first two passes, there are at least 4 lines.
											image_data[frame_offset + x + w*2] = c
											if y + 3 < h then
												image_data[frame_offset + x + w*3] = c
												if interlace < 3 and y + 4 < h then
													-- In the first pass there are 8 lines.
													image_data[frame_offset + x + w*4] = c
													if y + 5 < h then
														image_data[frame_offset + x + w*5] = c
														if y + 6 < h then
															image_data[frame_offset + x + w*6] = c
															if y + 7 < h then
																image_data[frame_offset + x + w*7] = c
															end
														end
													end
												end
											end
										end
									end
									-- Advance pixel
									x = x + 1
									if x >= w then
										-- Skip to next interlaced row
										x = 0
										nrows = nrows + 1
										y = y + intertable[interlace + 1]
										if y >= h then
											interlace = interlace + 2
											if interlace > 7 then
												y = false
											else
												y = intertable[interlace]
											end
										end
										if y then
											frame_offset = y * w + (frame_compressed and (iw*fy + y*(iw-fw) + fx) or 0)
										end
									end
								else
									-- No interlace, just increment y
									x = x + 1
									if x >= w then
										x = 0
										y = y + 1
										nrows = y
										if y >= h then
											y = false
										else
											frame_offset = y * w + (frame_compressed and (iw*fy + y*(iw-fw) + fx) or 0)
										end
									end
								end
							end

						else
							-- This should not happen.
							return 'Data past the end of the image'
						end
					end
				else
					-- Not enough bits, grab 8 more
					if p >= nextlenptr then
						-- End of this subblock - read next subblock
						-- assert(p == nextlenptr)
						local sblen = buffer[nextlenptr]

						if sblen == 0 then
							-- no more data
							if y then
								return "Hard EOD before the end of the image"
							end
							break
						end
						p = gifread(self, sblen + 1)
						nextlenptr = p + sblen
					end
					if y then
						bitstream = bitstream + bit_lshift(buffer[p], bitlen)
						bitlen = bitlen + 8
						p = p + 1
					else
						-- end of data - fast forward to end of block
						p = nextlenptr
					end
				end
			end

			local data_str = ffi_string(image_data, npixels*4)
			local texture = renderer_load_rgba(data_str, iw, ih)

			if texture == nil then
				return string_format("Failed to load frame %d", #self.frames)
			end

			table_insert(self.frames[#self.frames], texture)

			if GCE_dispose == 0 then
				-- clear, expects next frame to be full width or it'll crash
				ffi_fill(image_data, npixels*4, 0)
			elseif GCE_dispose == 1 then
				-- do nothing
			elseif GCE_dispose == 2 then
				-- -- fill with background
				if c_background ~= nil then
					if c_background.all == 0 then
						ffi_fill(image_data, npixels*4, 0)
					else
						for i=0, npixels-1 do
							image_data[i].all = c_background.all
						end
					end
				else
					return "Dispose mode 2, but no background given"
				end
			else
				return string_format("Unsupported dispose mode: %d", GCE_dispose)
			end

			GCE_trans = false
			GCE_dispose = 0
			GCE_delay = 0
			self.ncomplete = #self.frames
		else
			break
		end
	end
end

local function gifframe(self, frame)
	if self.frames[frame] == nil then
		error("Frame not found", 2)
	end

	local dispose, delay, x, y, w, h, texture = unpack(self.frames[frame])
	return texture, x, y, w, h, dispose, delay
end

local function gifdrawframe(self, frame, x, y, w, h, r, g, b, a, flags, ...)
	if self.frames[frame] == nil then
		error("Frame not found", 2)
	end

	local texture = gifframe(self, frame)
	renderer.texture(texture, x, y, w or self.width, h or self.height, r or 255, g or 255, b or 255, a or 255, flags or "f", ...)
end

local function gifdraw(self, time, ...)
	if self.duration == 0 then
		time = 0
	else
		time = time % self.duration
	end

	local tmpdur, frame = 0
	for i=1, #self.frames do
		tmpdur = tmpdur + self.frames[i][2]
		if tmpdur >= time then
			frame = i
			break
		end
	end

	if frame == nil then
		error("Frame not found", 2)
	end

	return gifdrawframe(self, frame, ...)
end

-- high level interface
local M = {}
local gif_mt = {
	__index = {
		frame = gifframe;
		drawframe = gifdrawframe,
		draw = gifdraw,
	}
}

-- load a gif from raw byte buffer (string)
function M.load_gif(contents)
	local gif = {
		width = false,
		height = false,
		frames = {},
		ncomplete = 0,
		progressive = false,
		loop = false,
		aspect = false,

		baseva = ffi.cast("const uint8_t *", ffi.cast("const char *", contents)),
		endva = false,
		contents = contents,
		seekpos = 0
	}

	gif.endva = gif.baseva + #contents

	-- load contents
	local err = gifdecode(gif)
	gifdone(gif)

	if err ~= nil then
		return error(err, 2)
	end

	return setmetatable(gif, gif_mt)
end

return M