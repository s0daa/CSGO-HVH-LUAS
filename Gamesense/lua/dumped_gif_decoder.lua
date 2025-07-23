-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = require("ffi")
local var_0_1 = require("bit")
local var_0_2 = require("table.new")
local var_0_3 = require("table.clear")
local var_0_4 = renderer.load_rgba
local var_0_5 = string.format
local var_0_6 = table.insert
local var_0_7 = var_0_1.band
local var_0_8 = var_0_1.rshift
local var_0_9 = var_0_1.lshift
local var_0_10 = string.char
local var_0_11 = coroutine.yield
local var_0_12 = var_0_0.new
local var_0_13 = var_0_0.copy
local var_0_14 = var_0_0.fill
local var_0_15 = var_0_0.string
local var_0_16 = var_0_0.typeof("uint8_t[?]")
local var_0_17 = var_0_0.typeof("int[?]")

if not pcall(var_0_0.sizeof, "gif_rgba") then
	var_0_0.cdef("typedef union { uint32_t all; struct { uint8_t r, g, b, a; }; } gif_rgba;")
	var_0_0.cdef("typedef struct { uint8_t r,g,b; } gif_rgb;")
end

local var_0_18 = var_0_0.typeof("gif_rgba")
local var_0_19 = var_0_0.typeof("gif_rgba[?]")
local var_0_20 = var_0_0.typeof("const gif_rgb *")
local var_0_21 = {
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
local var_0_22 = "GIF87a"
local var_0_23 = "GIF89a"
local var_0_24 = 59
local var_0_25 = 44
local var_0_26 = 33
local var_0_27 = 255
local var_0_28 = 249
local var_0_29 = 1
local var_0_30 = 254
local var_0_31 = var_0_12(var_0_18)

local function var_0_32(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0.baseva + arg_1_0.seekpos

	if arg_1_1 > arg_1_0.endva - var_1_0 then
		return error("tried to read past end")
	end

	local var_1_1 = arg_1_0.seekpos

	arg_1_0.seekpos = var_1_1 + arg_1_1

	return var_1_1
end

local function var_0_33(arg_2_0)
	return arg_2_0.baseva[var_0_32(arg_2_0, 1)]
end

local function var_0_34(arg_3_0)
	arg_3_0.baseva = nil
	arg_3_0.endva = nil
	arg_3_0.contents = nil
	arg_3_0.ncomplete = nil
	arg_3_0.duration = 0

	for iter_3_0 = 1, #arg_3_0.frames do
		arg_3_0.duration = arg_3_0.duration + arg_3_0.frames[iter_3_0][2]
	end
end

local function var_0_35(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = var_0_0.cast(var_0_20, arg_4_1)

	for iter_4_0 = 0, arg_4_2 - 1 do
		arg_4_0[iter_4_0].r = var_4_0[iter_4_0].r
		arg_4_0[iter_4_0].g = var_4_0[iter_4_0].g
		arg_4_0[iter_4_0].b = var_4_0[iter_4_0].b
		arg_4_0[iter_4_0].a = 255
	end
end

local function var_0_36(arg_5_0)
	if #arg_5_0.contents < 13 then
		return "Invalid GIF file format"
	end

	local var_5_0 = arg_5_0.contents:sub(1, 6)

	var_0_32(arg_5_0, 13)

	if var_5_0 ~= var_0_22 and var_5_0 ~= var_0_23 then
		return "Invalid GIF file format"
	end

	local var_5_1 = arg_5_0.baseva
	local var_5_2 = var_5_1[6] + 256 * var_5_1[7]
	local var_5_3 = var_5_1[8] + 256 * var_5_1[9]
	local var_5_4 = var_5_2 * var_5_3
	local var_5_5 = var_0_19(var_5_4)

	arg_5_0.width, arg_5_0.height = var_5_2, var_5_3

	local var_5_6 = var_5_1[10] >= 128 and var_0_9(1, var_0_7(var_5_1[10], 7) + 1) or 0
	local var_5_7 = var_5_1[11]

	arg_5_0.aspect = ((var_5_1[12] == 0 and 49 or 0) + 15) / 64

	local var_5_8 = var_0_19(256)
	local var_5_9 = var_0_19(256)
	local var_5_10
	local var_5_11

	if var_5_6 > 0 then
		var_0_32(arg_5_0, var_5_6 * 3)
		var_0_35(var_5_8, var_5_1 + 13, var_5_6)

		if var_5_7 < var_5_6 then
			var_5_11 = var_0_18()
			var_5_11.r = var_5_8[var_5_7].r
			var_5_11.g = var_5_8[var_5_7].g
			var_5_11.b = var_5_8[var_5_7].b
		end
	end

	local var_5_12
	local var_5_13 = false
	local var_5_14 = 0
	local var_5_15 = 0
	local var_5_16 = var_0_16(4096)
	local var_5_17 = var_0_17(4096)
	local var_5_18 = var_0_16(4096)

	if var_5_11 ~= nil and var_5_11.a > 0 then
		for iter_5_0 = 0, var_5_4 - 1 do
			var_5_5[iter_5_0].all = var_5_11.all
		end
	end

	while true do
		local var_5_19 = var_0_33(arg_5_0)
		local var_5_20

		if var_5_19 == var_0_25 then
			var_5_19 = var_0_25
		elseif var_5_19 == var_0_26 then
			var_5_19 = var_0_33(arg_5_0)

			if var_5_19 == var_0_25 then
				break
			end
		elseif var_5_19 ~= var_0_24 then
			return var_0_5("Unknown block type: 0x%02X", var_5_19)
		end

		if var_5_19 == var_0_24 then
			break
		elseif var_5_19 == var_0_27 then
			local var_5_21 = var_0_33(arg_5_0)
			local var_5_22 = var_0_32(arg_5_0, var_5_21 + 1)

			if var_5_21 >= 11 and var_0_0.string(var_5_1 + var_5_22, 11) == "NETSCAPE2.0" then
				var_5_22 = var_5_22 + var_5_21

				while var_5_1[var_5_22] ~= 0 do
					local var_5_23 = var_5_1[var_5_22]

					var_5_22 = var_0_32(arg_5_0, var_5_23 + 1)

					if var_5_1[var_5_22] == 1 and var_5_23 >= 3 then
						arg_5_0.loop = var_5_1[var_5_22 + 1] + 256 * var_5_1[var_5_22 + 2]
					end

					var_5_22 = var_5_22 + var_5_23
				end
			else
				local var_5_24 = var_5_22 + var_5_21

				while var_5_1[var_5_24] ~= 0 do
					var_0_32(arg_5_0, var_5_1[var_5_24])

					var_5_24 = var_0_32(arg_5_0, 1)
				end
			end
		elseif var_5_19 == var_0_29 or var_5_19 == var_0_30 then
			local var_5_25 = var_0_32(arg_5_0, 1)

			if var_5_19 < var_0_29 then
				var_5_25 = var_0_32(arg_5_0, var_5_1[var_5_25] + 1) + var_5_1[var_5_25]
				var_5_13 = false
				var_5_14 = 0
				var_5_15 = 0
			end

			while var_5_1[var_5_25] ~= 0 do
				var_5_25 = var_0_32(arg_5_0, var_5_1[var_5_25] + 1) + var_5_1[var_5_25]
			end
		elseif var_5_19 == var_0_28 then
			local var_5_26 = var_5_1[var_0_32(arg_5_0, 1)]
			local var_5_27 = var_0_32(arg_5_0, var_5_26 + 1)

			if var_5_26 >= 4 then
				var_5_15 = (var_5_1[var_5_27 + 1] + 256 * var_5_1[var_5_27 + 2]) / 100
				var_5_13 = var_0_7(var_5_1[var_5_27], 1) ~= 0 and var_5_1[var_5_27 + 3]
				var_5_14 = var_0_8(var_0_7(var_5_1[var_5_27], 28), 2)

				if var_5_15 == 0 then
					var_5_15 = 0.1
				end
			end

			local var_5_28 = var_5_27 + var_5_26

			while var_5_1[var_5_28] ~= 0 do
				var_5_28 = var_0_32(arg_5_0, var_5_1[var_5_28] + 1) + var_5_1[var_5_28]
			end
		elseif var_5_19 == var_0_25 then
			local var_5_29 = var_0_32(arg_5_0, 9)
			local var_5_30 = var_5_1[var_5_29] + 256 * var_5_1[var_5_29 + 1]
			local var_5_31 = var_5_1[var_5_29 + 2] + 256 * var_5_1[var_5_29 + 3]
			local var_5_32 = var_5_1[var_5_29 + 4] + 256 * var_5_1[var_5_29 + 5]
			local var_5_33 = var_5_1[var_5_29 + 6] + 256 * var_5_1[var_5_29 + 7]

			if var_5_32 == 0 or var_5_33 == 0 then
				return "Zero size image"
			end

			var_0_6(arg_5_0.frames, {
				var_5_14,
				var_5_15,
				var_5_30,
				var_5_31,
				var_5_32,
				var_5_33
			})

			local var_5_34 = var_5_30
			local var_5_35 = var_5_31
			local var_5_36 = var_5_32
			local var_5_37 = var_5_33
			local var_5_38 = var_5_34 ~= 0 or var_5_35 ~= 0 or var_5_36 ~= var_5_2 or var_5_37 ~= var_5_3
			local var_5_39 = var_5_1[var_5_29 + 8]

			if var_5_39 >= 128 then
				var_5_10 = var_0_9(1, var_0_7(var_5_39, 7) + 1)

				local var_5_40 = var_0_32(arg_5_0, var_5_10 * 3)

				var_0_35(var_5_9, var_5_1 + var_5_40, var_5_10)
			else
				var_0_13(var_5_9, var_5_8, var_5_6 * 4)

				var_5_10 = var_5_6
			end

			if var_5_13 and var_5_13 < var_5_10 then
				var_5_9[var_5_13].all = 0
			end

			local var_5_41 = var_0_7(var_5_39, 64) ~= 0 and 1
			local var_5_42 = var_0_32(arg_5_0, 2)
			local var_5_43 = var_5_1[var_5_42]
			local var_5_44 = var_5_42 + 1

			if var_5_43 == 0 or var_5_43 > 11 then
				return "Invalid code size"
			end

			local var_5_45 = var_5_43 + 1
			local var_5_46 = var_0_9(1, var_5_43)
			local var_5_47 = var_5_46 + 2
			local var_5_48 = 0
			local var_5_49 = 0
			local var_5_50, var_5_51 = 0, 0
			local var_5_52 = var_5_44
			local var_5_53
			local var_5_54
			local var_5_55 = 0
			local var_5_56 = var_5_2 * var_5_35 + var_5_34

			while true do
				if var_5_45 <= var_5_49 and var_5_51 then
					local var_5_57 = var_0_7(var_5_48, var_0_9(1, var_5_45) - 1)

					var_5_48 = var_0_8(var_5_48, var_5_45)
					var_5_49 = var_5_49 - var_5_45

					if var_5_57 == var_5_46 then
						var_5_45 = var_5_43 + 1
						var_5_47 = var_5_46 + 2
						var_5_53 = false
					elseif var_5_57 == var_5_46 + 1 then
						if var_5_50 ~= 0 or var_5_55 ~= var_5_33 then
							return "Soft EOD before all rows were output"
						end

						var_5_51 = false
					else
						local var_5_58 = 4095

						if var_5_57 < var_5_47 then
							var_5_54 = var_5_57

							while var_5_46 <= var_5_54 do
								var_5_18[var_5_58] = var_5_16[var_5_54]
								var_5_58 = var_5_58 - 1
								var_5_54 = var_5_17[var_5_54]
							end

							var_5_18[var_5_58] = var_5_54

							if var_5_53 and var_5_47 < 4096 then
								var_5_17[var_5_47] = var_5_53
								var_5_16[var_5_47] = var_5_54
								var_5_47 = var_5_47 + 1

								if var_5_47 ~= 4096 and var_0_7(var_5_47, var_5_47 - 1) == 0 then
									var_5_45 = var_5_45 + 1
								end
							end

							var_5_53 = var_5_57
						else
							if var_5_47 < var_5_57 or not var_5_53 or not var_5_54 then
								return "Broken LZW"
							end

							if var_5_53 and var_5_47 < 4096 then
								var_5_17[var_5_47] = var_5_53
								var_5_16[var_5_47] = var_5_54
								var_5_47 = var_5_47 + 1

								if var_5_47 ~= 4096 and var_0_7(var_5_47, var_5_47 - 1) == 0 then
									var_5_45 = var_5_45 + 1
								end
							end

							var_5_53 = var_5_57
							var_5_54 = var_5_53

							while var_5_46 <= var_5_54 do
								var_5_18[var_5_58] = var_5_16[var_5_54]
								var_5_58 = var_5_58 - 1
								var_5_54 = var_5_17[var_5_54]
							end

							var_5_18[var_5_58] = var_5_54
						end

						if var_5_51 then
							for iter_5_1 = var_5_58, 4095 do
								local var_5_59 = var_5_18[iter_5_1]

								if var_5_10 <= var_5_59 then
									var_5_59 = 0
								end

								local var_5_60 = var_5_9[var_5_59]

								if var_5_14 ~= 1 or var_5_60.all > 0 then
									var_5_59 = var_5_60
									var_5_5[var_5_56 + var_5_50] = var_5_59

									if (var_5_34 > 0 or var_5_35 > 0) and var_5_41 then
										return "Interlaced + frame compressed gifs not supported"
									end
								end

								if var_5_41 then
									if var_5_59 and arg_5_0.progressive and var_5_41 < 7 and var_5_33 > var_5_51 + 1 then
										var_5_5[var_5_56 + var_5_50 + var_5_32] = var_5_59

										if var_5_41 < 5 and var_5_33 > var_5_51 + 2 then
											var_5_5[var_5_56 + var_5_50 + var_5_32 * 2] = var_5_59

											if var_5_33 > var_5_51 + 3 then
												var_5_5[var_5_56 + var_5_50 + var_5_32 * 3] = var_5_59

												if var_5_41 < 3 and var_5_33 > var_5_51 + 4 then
													var_5_5[var_5_56 + var_5_50 + var_5_32 * 4] = var_5_59

													if var_5_33 > var_5_51 + 5 then
														var_5_5[var_5_56 + var_5_50 + var_5_32 * 5] = var_5_59

														if var_5_33 > var_5_51 + 6 then
															var_5_5[var_5_56 + var_5_50 + var_5_32 * 6] = var_5_59

															if var_5_33 > var_5_51 + 7 then
																var_5_5[var_5_56 + var_5_50 + var_5_32 * 7] = var_5_59
															end
														end
													end
												end
											end
										end
									end

									var_5_50 = var_5_50 + 1

									if var_5_32 <= var_5_50 then
										var_5_50 = 0
										var_5_55 = var_5_55 + 1
										var_5_51 = var_5_51 + var_0_21[var_5_41 + 1]

										if var_5_33 <= var_5_51 then
											var_5_41 = var_5_41 + 2
											var_5_51 = (not (var_5_41 > 7) or false) and var_0_21[var_5_41]
										end

										if var_5_51 then
											var_5_56 = var_5_51 * var_5_32 + (var_5_38 and var_5_2 * var_5_35 + var_5_51 * (var_5_2 - var_5_36) + var_5_34 or 0)
										end
									end
								else
									var_5_50 = var_5_50 + 1

									if var_5_32 <= var_5_50 then
										var_5_50 = 0
										var_5_51 = var_5_51 + 1
										var_5_55 = var_5_51

										if var_5_33 <= var_5_51 then
											var_5_51 = false
										else
											var_5_56 = var_5_51 * var_5_32 + (var_5_38 and var_5_2 * var_5_35 + var_5_51 * (var_5_2 - var_5_36) + var_5_34 or 0)
										end
									end
								end
							end
						else
							return "Data past the end of the image"
						end
					end
				else
					if var_5_52 <= var_5_44 then
						local var_5_61 = var_5_1[var_5_52]

						if var_5_61 == 0 then
							if var_5_51 then
								return "Hard EOD before the end of the image"
							end

							break
						end

						var_5_44 = var_0_32(arg_5_0, var_5_61 + 1)
						var_5_52 = var_5_44 + var_5_61
					end

					if var_5_51 then
						var_5_48 = var_5_48 + var_0_9(var_5_1[var_5_44], var_5_49)
						var_5_49 = var_5_49 + 8
						var_5_44 = var_5_44 + 1
					else
						var_5_44 = var_5_52
					end
				end
			end

			local var_5_62 = var_0_15(var_5_5, var_5_4 * 4)
			local var_5_63 = var_0_4(var_5_62, var_5_2, var_5_3)

			if var_5_63 == nil then
				return var_0_5("Failed to load frame %d", #arg_5_0.frames)
			end

			var_0_6(arg_5_0.frames[#arg_5_0.frames], var_5_63)

			if var_5_14 == 0 then
				var_0_14(var_5_5, var_5_4 * 4, 0)
			elseif var_5_14 == 1 then
				-- block empty
			elseif var_5_14 == 2 then
				if var_5_11 ~= nil then
					if var_5_11.all == 0 then
						var_0_14(var_5_5, var_5_4 * 4, 0)
					else
						for iter_5_2 = 0, var_5_4 - 1 do
							var_5_5[iter_5_2].all = var_5_11.all
						end
					end
				else
					return "Dispose mode 2, but no background given"
				end
			else
				return var_0_5("Unsupported dispose mode: %d", var_5_14)
			end

			var_5_13 = false
			var_5_14 = 0
			var_5_15 = 0
			arg_5_0.ncomplete = #arg_5_0.frames
		else
			break
		end
	end
end

local function var_0_37(arg_6_0, arg_6_1)
	if arg_6_0.frames[arg_6_1] == nil then
		error("Frame not found", 2)
	end

	local var_6_0, var_6_1, var_6_2, var_6_3, var_6_4, var_6_5, var_6_6 = unpack(arg_6_0.frames[arg_6_1])

	return var_6_6, var_6_2, var_6_3, var_6_4, var_6_5, var_6_0, var_6_1
end

local function var_0_38(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8, arg_7_9, arg_7_10, ...)
	if arg_7_0.frames[arg_7_1] == nil then
		error("Frame not found", 2)
	end

	local var_7_0 = var_0_37(arg_7_0, arg_7_1)

	renderer.texture(var_7_0, arg_7_2, arg_7_3, arg_7_4 or arg_7_0.width, arg_7_5 or arg_7_0.height, arg_7_6 or 255, arg_7_7 or 255, arg_7_8 or 255, arg_7_9 or 255, arg_7_10 or "f", ...)
end

local function var_0_39(arg_8_0, arg_8_1, ...)
	arg_8_1 = arg_8_0.duration == 0 and 0 or arg_8_1 % arg_8_0.duration

	local var_8_0 = 0
	local var_8_1

	for iter_8_0 = 1, #arg_8_0.frames do
		var_8_0 = var_8_0 + arg_8_0.frames[iter_8_0][2]

		if arg_8_1 <= var_8_0 then
			var_8_1 = iter_8_0

			break
		end
	end

	if var_8_1 == nil then
		error("Frame not found", 2)
	end

	return var_0_38(arg_8_0, var_8_1, ...)
end

local var_0_40 = {}
local var_0_41 = {
	__index = {
		frame = var_0_37,
		drawframe = var_0_38,
		draw = var_0_39
	}
}

function var_0_40.load_gif(arg_9_0)
	local var_9_0 = {
		height = false,
		aspect = false,
		loop = false,
		seekpos = 0,
		width = false,
		endva = false,
		ncomplete = 0,
		progressive = false,
		frames = {},
		baseva = var_0_0.cast("const uint8_t *", var_0_0.cast("const char *", arg_9_0)),
		contents = arg_9_0
	}

	var_9_0.endva = var_9_0.baseva + #arg_9_0

	local var_9_1 = var_0_36(var_9_0)

	var_0_34(var_9_0)

	if var_9_1 ~= nil then
		return error(var_9_1, 2)
	end

	return setmetatable(var_9_0, var_0_41)
end

return var_0_40
