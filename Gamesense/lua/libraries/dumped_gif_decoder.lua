slot0 = require("ffi")
slot1 = require("bit")
slot2 = require("table.new")
slot3 = require("table.clear")
slot4 = renderer.load_rgba
slot5 = string.format
slot6 = table.insert
slot7 = slot1.band
slot8 = slot1.rshift
slot9 = slot1.lshift
slot10 = string.char
slot11 = coroutine.yield
slot12 = slot0.new
slot13 = slot0.copy
slot14 = slot0.fill
slot15 = slot0.string
slot16 = slot0.typeof("uint8_t[?]")
slot17 = slot0.typeof("int[?]")

if not pcall(slot0.sizeof, "gif_rgba") then
	slot0.cdef("typedef union { uint32_t all; struct { uint8_t r, g, b, a; }; } gif_rgba;")
	slot0.cdef("typedef struct { uint8_t r,g,b; } gif_rgb;")
end

slot19 = slot0.typeof("gif_rgba[?]")
slot20 = slot0.typeof("const gif_rgb *")
slot21 = {
	0,
	8,
	4,
	8,
	2,
	4,
	1,
	2,
	false
}
slot22 = "GIF87a"
slot23 = "GIF89a"
slot24 = 59
slot25 = 44
slot26 = 33
slot27 = 255
slot28 = 249
slot29 = 1
slot30 = 254
slot31 = slot12(slot0.typeof("gif_rgba"))

function slot32(slot0, slot1)
	if slot1 > slot0.endva - (slot0.baseva + slot0.seekpos) then
		return error("tried to read past end")
	end

	slot4 = slot0.seekpos
	slot0.seekpos = slot4 + slot1

	return slot4
end

function slot33(slot0)
	return slot0.baseva[uv0(slot0, 1)]
end

function slot34(slot0)
	slot0.baseva = nil
	slot0.endva = nil
	slot0.contents = nil
	slot0.ncomplete = nil
	slot0.duration = 0

	for slot4 = 1, #slot0.frames do
		slot0.duration = slot0.duration + slot0.frames[slot4][2]
	end
end

function slot35(slot0, slot1, slot2)
	slot3 = uv0.cast(uv1, slot1)

	for slot7 = 0, slot2 - 1 do
		slot0[slot7].r = slot3[slot7].r
		slot0[slot7].g = slot3[slot7].g
		slot0[slot7].b = slot3[slot7].b
		slot0[slot7].a = 255
	end
end

function slot36(slot0)
	if #slot0.contents < 13 then
		return "Invalid GIF file format"
	end

	uv0(slot0, 13)

	if slot0.contents:sub(1, 6) ~= uv1 and slot1 ~= uv2 then
		return "Invalid GIF file format"
	end

	slot2 = slot0.baseva
	slot3 = slot2[6] + 256 * slot2[7]
	slot4 = slot2[8] + 256 * slot2[9]
	slot6 = uv3(slot3 * slot4)
	slot0.height = slot4
	slot0.width = slot3
	slot8 = slot2[11]
	slot0.aspect = ((slot2[12] == 0 and 49 or 0) + 15) / 64
	slot9 = uv3(256)
	slot10 = uv3(256)
	slot11, slot12 = nil

	if (slot2[10] >= 128 and uv4(1, uv5(slot2[10], 7) + 1) or 0) > 0 then
		uv0(slot0, slot7 * 3)
		uv6(slot9, slot2 + 13, slot7)

		if slot8 < slot7 then
			slot12 = uv7()
			slot12.r = slot9[slot8].r
			slot12.g = slot9[slot8].g
			slot12.b = slot9[slot8].b
		end
	end

	slot13 = nil
	slot14 = false
	slot15 = 0
	slot16 = 0
	slot17 = uv8(4096)
	slot18 = uv9(4096)
	slot19 = uv8(4096)

	if slot12 ~= nil and slot12.a > 0 then
		for slot23 = 0, slot5 - 1 do
			slot6[slot23].all = slot12.all
		end
	end

	while true do
		slot21 = nil

		if uv10(slot0) == uv11 then
			slot20 = uv11
		elseif slot20 == uv12 then
			if uv10(slot0) == uv11 then
				break
			end
		elseif slot20 ~= uv13 then
			return uv14("Unknown block type: 0x%02X", slot20)
		end

		if slot20 == uv13 then
			break
		elseif slot20 == uv15 then
			slot21 = uv10(slot0)
			slot13 = uv0(slot0, slot21 + 1)

			if slot21 >= 11 and uv16.string(slot2 + slot13, 11) == "NETSCAPE2.0" then
				slot13 = slot13 + slot21

				while slot2[slot13] ~= 0 do
					if slot2[uv0(slot0, slot2[slot13] + 1)] == 1 and slot22 >= 3 then
						slot0.loop = slot2[slot13 + 1] + 256 * slot2[slot13 + 2]
					end

					slot13 = slot13 + slot22
				end
			else
				slot13 = slot13 + slot21

				while slot2[slot13] ~= 0 do
					uv0(slot0, slot2[slot13])

					slot13 = uv0(slot0, 1)
				end
			end
		elseif slot20 == uv17 or slot20 == uv18 then
			slot13 = uv0(slot0, 1)

			if slot20 < uv17 then
				slot13 = uv0(slot0, slot2[slot13] + 1) + slot2[slot13]
				slot14 = false
				slot15 = 0
				slot16 = 0
			end

			while slot2[slot13] ~= 0 do
				slot13 = uv0(slot0, slot2[slot13] + 1) + slot2[slot13]
			end
		elseif slot20 == uv19 then
			slot21 = slot2[uv0(slot0, 1)]
			slot13 = uv0(slot0, slot21 + 1)

			if slot21 >= 4 then
				slot14 = uv5(slot2[slot13], 1) ~= 0 and slot2[slot13 + 3]
				slot15 = uv20(uv5(slot2[slot13], 28), 2)

				if (slot2[slot13 + 1] + 256 * slot2[slot13 + 2]) / 100 == 0 then
					slot16 = 0.1
				end
			end

			slot13 = slot13 + slot21

			while slot2[slot13] ~= 0 do
				slot13 = uv0(slot0, slot2[slot13] + 1) + slot2[slot13]
			end
		elseif slot20 == uv11 then
			slot13 = uv0(slot0, 9)
			slot22 = slot2[slot13] + 256 * slot2[slot13 + 1]
			slot23 = slot2[slot13 + 2] + 256 * slot2[slot13 + 3]
			slot25 = slot2[slot13 + 6] + 256 * slot2[slot13 + 7]

			if slot2[slot13 + 4] + 256 * slot2[slot13 + 5] == 0 or slot25 == 0 then
				return "Zero size image"
			end

			uv21(slot0.frames, {
				slot15,
				slot16,
				slot22,
				slot23,
				slot24,
				slot25
			})

			slot30 = slot22 ~= 0 or slot23 ~= 0 or slot24 ~= slot3 or slot25 ~= slot4

			if slot2[slot13 + 8] >= 128 then
				slot11 = uv4(1, uv5(slot31, 7) + 1)

				uv6(slot10, slot2 + uv0(slot0, slot11 * 3), slot11)
			else
				uv22(slot10, slot9, slot7 * 4)

				slot11 = slot7
			end

			if slot14 and slot14 < slot11 then
				slot10[slot14].all = 0
			end

			slot32 = uv5(slot31, 64) ~= 0 and 1
			slot13 = uv0(slot0, 2)
			slot13 = slot13 + 1

			if slot2[slot13] == 0 or slot33 > 11 then
				return "Invalid code size"
			end

			slot34 = slot33 + 1
			slot36 = uv4(1, slot33) + 2
			slot38 = 0
			slot22 = 0
			slot39 = slot13
			slot40, slot41 = nil
			slot42 = 0
			slot43 = slot3 * slot27 + slot26

			while true do
				if slot34 <= slot38 and 0 then
					slot37 = uv20(0, slot34)
					slot38 = slot38 - slot34

					if uv5(slot37, uv4(1, slot34) - 1) == slot35 then
						slot34 = slot33 + 1
						slot36 = slot35 + 2
						slot40 = false
					elseif slot44 == slot35 + 1 then
						if slot22 ~= 0 or slot42 ~= slot25 then
							return "Soft EOD before all rows were output"
						end

						slot23 = false
					else
						slot45 = 4095

						if slot44 < slot36 then
							slot41 = slot44

							while slot35 <= slot41 do
								slot19[slot45] = slot17[slot41]
								slot45 = slot45 - 1
								slot41 = slot18[slot41]
							end

							slot19[slot45] = slot41

							if slot40 and slot36 < 4096 then
								slot18[slot36] = slot40
								slot17[slot36] = slot41

								if slot36 + 1 ~= 4096 and uv5(slot36, slot36 - 1) == 0 then
									slot34 = slot34 + 1
								end
							end

							slot40 = slot44
						else
							if slot36 < slot44 or not slot40 or not slot41 then
								return "Broken LZW"
							end

							if slot40 and slot36 < 4096 then
								slot18[slot36] = slot40
								slot17[slot36] = slot41

								if slot36 + 1 ~= 4096 and uv5(slot36, slot36 - 1) == 0 then
									slot34 = slot34 + 1
								end
							end

							slot41 = slot44

							while slot35 <= slot41 do
								slot19[slot45] = slot17[slot41]
								slot45 = slot45 - 1
								slot41 = slot18[slot41]
							end

							slot19[slot45] = slot41
						end

						if slot23 then
							for slot49 = slot45, 4095 do
								if slot11 <= slot19[slot49] then
									slot50 = 0
								end

								slot51 = slot10[slot50]

								if slot15 ~= 1 or slot51.all > 0 then
									slot6[slot43 + slot22] = slot51

									if (slot26 > 0 or slot27 > 0) and slot32 then
										return "Interlaced + frame compressed gifs not supported"
									end
								end

								if slot32 then
									if slot50 and slot0.progressive and slot32 < 7 and slot25 > slot23 + 1 then
										slot6[slot43 + slot22 + slot24] = slot50

										if slot32 < 5 and slot25 > slot23 + 2 then
											slot6[slot43 + slot22 + slot24 * 2] = slot50

											if slot25 > slot23 + 3 then
												slot6[slot43 + slot22 + slot24 * 3] = slot50

												if slot32 < 3 and slot25 > slot23 + 4 then
													slot6[slot43 + slot22 + slot24 * 4] = slot50

													if slot25 > slot23 + 5 then
														slot6[slot43 + slot22 + slot24 * 5] = slot50

														if slot25 > slot23 + 6 then
															slot6[slot43 + slot22 + slot24 * 6] = slot50

															if slot25 > slot23 + 7 then
																slot6[slot43 + slot22 + slot24 * 7] = slot50
															end
														end
													end
												end
											end
										end
									end

									if slot24 <= slot22 + 1 then
										slot22 = 0
										slot42 = slot42 + 1

										if slot25 <= slot23 + uv23[slot32 + 1] then
											slot23 = (slot32 + 2 <= 7 or false) and uv23[slot32]
										end

										if slot23 then
											slot43 = slot23 * slot24 + (slot30 and slot3 * slot27 + slot23 * (slot3 - slot28) + slot26 or 0)
										end
									end
								elseif slot24 <= slot22 + 1 then
									slot22 = 0
									slot23 = slot23 + 1
									slot42 = slot23

									if slot25 <= slot23 then
										slot23 = false
									else
										slot43 = slot23 * slot24 + (slot30 and slot3 * slot27 + slot23 * (slot3 - slot28) + slot26 or 0)
									end
								end
							end
						else
							return "Data past the end of the image"
						end
					end
				else
					if slot39 <= slot13 then
						if slot2[slot39] == 0 then
							if slot23 then
								return "Hard EOD before the end of the image"
							end

							break
						end

						slot39 = uv0(slot0, slot44 + 1) + slot44
					end

					if slot23 then
						slot37 = slot37 + uv4(slot2[slot13], slot38)
						slot38 = slot38 + 8
						slot13 = slot13 + 1
					else
						slot13 = slot39
					end
				end
			end

			if uv25(uv24(slot6, slot5 * 4), slot3, slot4) == nil then
				return uv14("Failed to load frame %d", #slot0.frames)
			end

			uv21(slot0.frames[#slot0.frames], slot45)

			if slot15 == 0 then
				uv26(slot6, slot5 * 4, 0)
			elseif slot15 == 1 then
				-- Nothing
			elseif slot15 == 2 then
				if slot12 ~= nil then
					if slot12.all == 0 then
						uv26(slot6, slot5 * 4, 0)
					else
						for slot49 = 0, slot5 - 1 do
							slot6[slot49].all = slot12.all
						end
					end
				else
					return "Dispose mode 2, but no background given"
				end
			else
				return uv14("Unsupported dispose mode: %d", slot15)
			end

			slot14 = false
			slot15 = 0
			slot16 = 0
			slot0.ncomplete = #slot0.frames
		else
			break
		end
	end
end

slot41 = {
	__index = {
		frame = function (slot0, slot1)
			if slot0.frames[slot1] == nil then
				error("Frame not found", 2)
			end

			slot2, slot3, slot4, slot5, slot6, slot7, slot8 = unpack(slot0.frames[slot1])

			return slot8, slot4, slot5, slot6, slot7, slot2, slot3
		end,
		drawframe = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10, ...)
			if slot0.frames[slot1] == nil then
				error("Frame not found", 2)
			end

			renderer.texture(uv0(slot0, slot1), slot2, slot3, slot4 or slot0.width, slot5 or slot0.height, slot6 or 255, slot7 or 255, slot8 or 255, slot9 or 255, slot10 or "f", ...)
		end,
		draw = function (slot0, slot1, ...)
			slot3 = nil

			for slot7 = 1, #slot0.frames do
				if (slot0.duration == 0 and 0 or 0 % slot0.duration) <= 0 + slot0.frames[slot7][2] then
					slot3 = slot7

					break
				end
			end

			if slot3 == nil then
				error("Frame not found", 2)
			end

			return uv0(slot0, slot3, ...)
		end
	}
}

return {
	load_gif = function (slot0)
		slot1 = {
			loop = false,
			progressive = false,
			aspect = false,
			endva = false,
			height = false,
			width = false,
			ncomplete = 0,
			seekpos = 0,
			frames = {},
			baseva = uv0.cast("const uint8_t *", uv0.cast("const char *", slot0)),
			contents = slot0
		}
		slot1.endva = slot1.baseva + #slot0

		uv2(slot1)

		if uv1(slot1) ~= nil then
			return error(slot2, 2)
		end

		return setmetatable(slot1, uv3)
	end
}
