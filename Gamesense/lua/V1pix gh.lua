_DEBUG = true

function slot0()
	slot0 = nil
	slot0 = setmetatable({}, {
		__index = function (slot0, slot1)
			return {
				set = function (slot0, slot1)
					_G.events[uv0]:set(function (...)
						slot0, slot1 = pcall(uv0, ...)

						if not slot0 then
							print_raw(("%s: %s"):format(uv1, slot1))
						end
					end)
				end,
				unset = function (slot0, slot1)
					_G.events[uv0]:unset(function (...)
						slot0, slot1 = pcall(uv0, ...)

						if not slot0 then
							print_raw(("%s: %s"):format(uv1, slot1))
						end
					end)
				end,
				call = function (...)
					_G.events[uv0]:call(...)
				end
			}
		end
	})
	slot1 = nil
	slot1 = {
		refs = {},
		update = function ()
			for slot3, slot4 in pairs(uv0.refs) do
				if slot4.condition then
					slot4.ref:visibility(slot4.condition())
				end
			end
		end,
		new = function (slot0, slot1, slot2)
			if type(slot0) ~= "string" or type(slot1) ~= "userdata" then
				error(slot0 .. " args error")

				return
			end

			if slot2 ~= nil and type(slot2) ~= "function" then
				error(slot0 .. " condition arg error")

				return
			end

			if uv0.refs[slot0] ~= nil then
				error(slot0 .. " already exists")

				return
			end

			uv0.refs[slot0] = {
				ref = slot1,
				name = slot0,
				condition = slot2
			}

			uv0.update()
			slot1:set_callback(uv0.update)

			return slot1
		end
	}
	slot2 = nil
	slot2 = {
		get = function ()
			if uv0() > 0 then
				slot1 = uv1(slot0)

				uv2(0, slot1, slot0)

				return ffi.string(slot1, slot0 - 1)
			end
		end,
		set = function (slot0)
			uv0(slot0, slot0:len())
		end
	}
	slot3 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
	slot4 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)")
	slot5 = utils.get_vfunc("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")
	slot6 = ffi.typeof("char[?]")
	slot3 = nil
	slot8 = (ffi.cast("void***", ffi.cast("void*", (ffi.cast("struct { void* __pad[12]; void* steam_http; } **", ffi.cast("char*", utils.opcode_scan("client.dll", "FF 15 ? ? ? ? B9 ? ? ? ? E8 ? ? ? ? 6A") or error("steam_ctx")) + 7)[0] or error("steam_ctx not found")).steam_http) or error("steam_http error")) or error("steam_http_ptr error"))[0] or error("steam_http_ptr was null")
	slot9 = ffi.cast("uint32_t(__thiscall*)(void*, uint32_t, const char*)", slot8[0])
	slot10 = ffi.cast("bool(__thiscall*)(void* _this, uint32_t handle, uint64_t call_handle)", slot8[5])
	slot11 = ffi.cast("bool(__thiscall*)(void* _this, uint32_t hRequest, const char *pchHeaderName, uint32_t *unResponseHeaderSize)", slot8[9])
	slot12 = ffi.cast("bool(__thiscall*)(void* _this, uint32_t hRequest, const char *pchHeaderName, char *pHeaderValueBuffer, uint32_t unBufferSize)", slot8[10])
	slot13 = ffi.cast("bool(__thiscall*)(void* _this, uint32_t hRequest, uint32_t *unBodySize)", slot8[11])
	slot14 = ffi.cast("bool(__thiscall*)(void* _this, uint32_t hRequest, char *pBodyDataBuf, uint32_t unBufferSize)", slot8[12])
	slot15 = ffi.cast("bool(__thiscall*)(void* _this, uint32_t hRequest, const char* pchParamName, const char* pchParamValue)", slot8[4])
	slot16 = ffi.cast("bool(__thiscall*)(void* _this, uint32_t hRequest)", slot8[14])
	slot17 = {}
	slot18 = {
		__index = slot17
	}

	function slot17.new(slot0, slot1, slot2)
		return setmetatable({
			ticks = 0,
			handle = slot0,
			url = slot1,
			callback = slot2
		}, uv0)
	end

	slot19 = {}
	slot20 = {
		__index = slot19
	}

	function slot19.new(slot0, slot1, slot2)
		return setmetatable({
			state = slot0,
			body = slot1,
			header = {
				content_type = slot2.content_type
			}
		}, uv0)
	end

	slot21 = {
		state = {
			no_response = 1,
			timed_out = 2,
			unknown = 3,
			ok = 0
		}
	}
	slot22 = {
		__index = slot21
	}

	function slot21.new(slot0)
		slot1 = slot0 or {}
		slot3 = setmetatable({
			requests = {},
			task_interval = slot1.task_interval or 0.5,
			timeout = slot1.timeout or 10
		}, uv0)

		slot3:_process_tasks()

		return slot3
	end

	function slot21.get(slot0, slot1, slot2)
		if uv2(uv1, uv0(uv1, 1, slot1), 0) == false then
			return
		end

		slot0.requests[#slot0.requests + 1] = uv3.new(slot3, slot1, slot2)
	end

	function slot21.post(slot0, slot1, slot2, slot3)
		slot4 = uv0(uv1, 3, slot1)

		for slot8, slot9 in pairs(slot2) do
			uv2(uv1, slot4, slot8, slot9)
		end

		if uv3(uv1, slot4, 0) == false then
			return
		end

		slot0.requests[#slot0.requests + 1] = uv4.new(slot4, slot1, slot3)
	end

	function slot21._process_tasks(slot0)
		for slot4, slot5 in ipairs(slot0.requests) do
			if uv0(uv1, slot5.handle, ffi.new("uint32_t[1]")) == true then
				if slot6[0] > 0 then
					if uv2(uv1, slot5.handle, ffi.new("char[?]", slot7), slot7) == true then
						table.remove(slot0.requests, slot4)
						uv3(uv1, slot5.handle)
						slot5.callback(uv4.new(uv5.state.ok, ffi.string(slot8, slot7), {
							content_type = uv5._get_header(slot5, "Content-Type")
						}))
					end
				else
					table.remove(slot0.requests, slot4)
					uv3(uv1, slot5.handle)
					slot5.callback(uv4.new(uv5.state.no_response, nil, {}))
				end
			end

			if slot0.timeout <= slot5.ticks + 1 then
				table.remove(slot0.requests, slot4)
				uv3(uv1, slot5.handle)
				slot5.callback(uv4.new(uv5.state.timed_out, nil, {}))
			else
				slot5.ticks = slot7
			end
		end

		utils.execute_after(slot0.task_interval, uv5._bind(slot0, "_process_tasks"))
	end

	function slot21._get_header(slot0, slot1)
		if uv0(uv1, slot0.handle, slot1, ffi.new("uint32_t[1]")) then
			slot3 = slot2[0]

			if uv2(uv1, slot0.handle, slot1, ffi.new("char[?]", slot3), slot3) then
				return ffi.string(slot4, slot3)
			end
		end

		return nil
	end

	function slot21._bind(slot0, slot1)
		return function (...)
			return uv0[uv1](uv0, ...)
		end
	end

	slot3 = slot21.new({
		task_interval = 0.1,
		timeout = 250
	})
	slot4 = nil
	slot4 = {
		linear = function (slot0, slot1, slot2, slot3)
			return slot2 * slot0 / slot3 + slot1
		end,
		quad_in = function (slot0, slot1, slot2, slot3)
			return slot2 * math.pow(slot0 / slot3, 2) + slot1
		end,
		quad_out = function (slot0, slot1, slot2, slot3)
			slot0 = slot0 / slot3

			return -slot2 * slot0 * (slot0 - 2) + slot1
		end,
		quad_in_out = function (slot0, slot1, slot2, slot3)
			if slot0 / slot3 * 2 < 1 then
				return slot2 / 2 * math.pow(slot0, 2) + slot1
			else
				return -slot2 / 2 * ((slot0 - 1) * (slot0 - 3) - 1) + slot1
			end
		end,
		quad_out_in = function (slot0, slot1, slot2, slot3)
			if slot0 < slot3 / 2 then
				return uv0(slot0 * 2, slot1, slot2 / 2, slot3)
			else
				return uv1(slot0 * 2 - slot3, slot1 + slot2 / 2, slot2 / 2, slot3)
			end
		end,
		cubic_in = function (slot0, slot1, slot2, slot3)
			return slot2 * math.pow(slot0 / slot3, 3) + slot1
		end,
		cubic_out = function (slot0, slot1, slot2, slot3)
			return slot2 * (math.pow(slot0 / slot3 - 1, 3) + 1) + slot1
		end,
		cubic_in_out = function (slot0, slot1, slot2, slot3)
			if slot0 / slot3 * 2 < 1 then
				return slot2 / 2 * slot0 * slot0 * slot0 + slot1
			else
				slot0 = slot0 - 2

				return slot2 / 2 * (slot0 * slot0 * slot0 + 2) + slot1
			end
		end,
		cubic_out_in = function (slot0, slot1, slot2, slot3)
			if slot0 < slot3 / 2 then
				return uv0(slot0 * 2, slot1, slot2 / 2, slot3)
			else
				return uv1(slot0 * 2 - slot3, slot1 + slot2 / 2, slot2 / 2, slot3)
			end
		end,
		quart_in = function (slot0, slot1, slot2, slot3)
			return slot2 * math.pow(slot0 / slot3, 4) + slot1
		end,
		quart_out = function (slot0, slot1, slot2, slot3)
			return -slot2 * (math.pow(slot0 / slot3 - 1, 4) - 1) + slot1
		end,
		quart_in_out = function (slot0, slot1, slot2, slot3)
			if slot0 / slot3 * 2 < 1 then
				return slot2 / 2 * math.pow(slot0, 4) + slot1
			else
				return -slot2 / 2 * (math.pow(slot0 - 2, 4) - 2) + slot1
			end
		end,
		quart_out_in = function (slot0, slot1, slot2, slot3)
			if slot0 < slot3 / 2 then
				return uv0(slot0 * 2, slot1, slot2 / 2, slot3)
			else
				return uv1(slot0 * 2 - slot3, slot1 + slot2 / 2, slot2 / 2, slot3)
			end
		end,
		quint_in = function (slot0, slot1, slot2, slot3)
			return slot2 * math.pow(slot0 / slot3, 5) + slot1
		end,
		quint_out = function (slot0, slot1, slot2, slot3)
			return slot2 * (math.pow(slot0 / slot3 - 1, 5) + 1) + slot1
		end,
		quint_in_out = function (slot0, slot1, slot2, slot3)
			if slot0 / slot3 * 2 < 1 then
				return slot2 / 2 * math.pow(slot0, 5) + slot1
			else
				return slot2 / 2 * (math.pow(slot0 - 2, 5) + 2) + slot1
			end
		end,
		quint_out_in = function (slot0, slot1, slot2, slot3)
			if slot0 < slot3 / 2 then
				return uv0(slot0 * 2, slot1, slot2 / 2, slot3)
			else
				return uv1(slot0 * 2 - slot3, slot1 + slot2 / 2, slot2 / 2, slot3)
			end
		end,
		sine_in = function (slot0, slot1, slot2, slot3)
			return -slot2 * math.cos(slot0 / slot3 * math.pi / 2) + slot2 + slot1
		end,
		sine_out = function (slot0, slot1, slot2, slot3)
			return slot2 * math.sin(slot0 / slot3 * math.pi / 2) + slot1
		end,
		sine_in_out = function (slot0, slot1, slot2, slot3)
			return -slot2 / 2 * (math.cos(math.pi * slot0 / slot3) - 1) + slot1
		end,
		sine_out_in = function (slot0, slot1, slot2, slot3)
			if slot0 < slot3 / 2 then
				return uv0(slot0 * 2, slot1, slot2 / 2, slot3)
			else
				return uv1(slot0 * 2 - slot3, slot1 + slot2 / 2, slot2 / 2, slot3)
			end
		end,
		expo_in = function (slot0, slot1, slot2, slot3)
			if slot0 == 0 then
				return slot1
			else
				return slot2 * math.pow(2, 10 * (slot0 / slot3 - 1)) + slot1 - slot2 * 0.001
			end
		end,
		expo_out = function (slot0, slot1, slot2, slot3)
			if slot0 == slot3 then
				return slot1 + slot2
			else
				return slot2 * 1.001 * (-math.pow(2, -10 * slot0 / slot3) + 1) + slot1
			end
		end,
		expo_in_out = function (slot0, slot1, slot2, slot3)
			if slot0 == 0 then
				return slot1
			end

			if slot0 == slot3 then
				return slot1 + slot2
			end

			if slot0 / slot3 * 2 < 1 then
				return slot2 / 2 * math.pow(2, 10 * (slot0 - 1)) + slot1 - slot2 * 0.0005
			else
				return slot2 / 2 * 1.0005 * (-math.pow(2, -10 * (slot0 - 1)) + 2) + slot1
			end
		end,
		expo_out_in = function (slot0, slot1, slot2, slot3)
			if slot0 < slot3 / 2 then
				return uv0(slot0 * 2, slot1, slot2 / 2, slot3)
			else
				return uv1(slot0 * 2 - slot3, slot1 + slot2 / 2, slot2 / 2, slot3)
			end
		end,
		circ_in = function (slot0, slot1, slot2, slot3)
			return -slot2 * (math.sqrt(1 - math.pow(slot0 / slot3, 2)) - 1) + slot1
		end,
		circ_out = function (slot0, slot1, slot2, slot3)
			return slot2 * math.sqrt(1 - math.pow(slot0 / slot3 - 1, 2)) + slot1
		end,
		circ_in_out = function (slot0, slot1, slot2, slot3)
			if slot0 / slot3 * 2 < 1 then
				return -slot2 / 2 * (math.sqrt(1 - slot0 * slot0) - 1) + slot1
			else
				slot0 = slot0 - 2

				return slot2 / 2 * (math.sqrt(1 - slot0 * slot0) + 1) + slot1
			end
		end,
		circ_out_in = function (slot0, slot1, slot2, slot3)
			if slot0 < slot3 / 2 then
				return uv0(slot0 * 2, slot1, slot2 / 2, slot3)
			else
				return uv1(slot0 * 2 - slot3, slot1 + slot2 / 2, slot2 / 2, slot3)
			end
		end,
		elastic_in = function (slot0, slot1, slot2, slot3, slot4, slot5)
			if slot0 == 0 then
				return slot1
			end

			if slot0 / slot3 == 1 then
				return slot1 + slot2
			end

			slot6 = nil

			if not slot4 or slot4 < math.abs(slot2) then
				slot4 = slot2
				slot6 = (slot5 or slot3 * 0.3) / 4
			else
				slot6 = slot5 / (2 * math.pi) * math.asin(slot2 / slot4)
			end

			slot0 = slot0 - 1

			return -(slot4 * math.pow(2, 10 * slot0) * math.sin((slot0 * slot3 - slot6) * 2 * math.pi / slot5)) + slot1
		end,
		elastic_out = function (slot0, slot1, slot2, slot3, slot4, slot5)
			if slot0 == 0 then
				return slot1
			end

			if slot0 / slot3 == 1 then
				return slot1 + slot2
			end

			slot6 = nil

			if not slot4 or slot4 < math.abs(slot2) then
				slot4 = slot2
				slot6 = (slot5 or slot3 * 0.3) / 4
			else
				slot6 = slot5 / (2 * math.pi) * math.asin(slot2 / slot4)
			end

			return slot4 * math.pow(2, -10 * slot0) * math.sin((slot0 * slot3 - slot6) * 2 * math.pi / slot5) + slot2 + slot1
		end,
		elastic_in_out = function (slot0, slot1, slot2, slot3, slot4, slot5)
			if slot0 == 0 then
				return slot1
			end

			if slot0 / slot3 * 2 == 2 then
				return slot1 + slot2
			end

			slot6 = nil

			if not slot4 and not 0 or slot4 < math.abs(slot2) then
				slot4 = slot2
				slot6 = (slot5 or slot3 * 0.44999999999999996) / 4
			else
				slot6 = slot5 / (2 * math.pi) * math.asin(slot2 / slot4)
			end

			if slot0 < 1 then
				slot0 = slot0 - 1

				return -0.5 * slot4 * math.pow(2, 10 * slot0) * math.sin((slot0 * slot3 - slot6) * 2 * math.pi / slot5) + slot1
			else
				slot0 = slot0 - 1

				return slot4 * math.pow(2, -10 * slot0) * math.sin((slot0 * slot3 - slot6) * 2 * math.pi / slot5) * 0.5 + slot2 + slot1
			end
		end,
		elastic_out_in = function (slot0, slot1, slot2, slot3, slot4, slot5)
			if slot0 < slot3 / 2 then
				return uv0(slot0 * 2, slot1, slot2 / 2, slot3, slot4, slot5)
			else
				return uv1(slot0 * 2 - slot3, slot1 + slot2 / 2, slot2 / 2, slot3, slot4, slot5)
			end
		end,
		back_in = function (slot0, slot1, slot2, slot3, slot4)
			slot4 = slot4 or 1.70158
			slot0 = slot0 / slot3

			return slot2 * slot0 * slot0 * ((slot4 + 1) * slot0 - slot4) + slot1
		end,
		back_out = function (slot0, slot1, slot2, slot3, slot4)
			slot4 = slot4 or 1.70158
			slot0 = slot0 / slot3 - 1

			return slot2 * (slot0 * slot0 * ((slot4 + 1) * slot0 + slot4) + 1) + slot1
		end,
		back_in_out = function (slot0, slot1, slot2, slot3, slot4)
			slot4 = (slot4 or 1.70158) * 1.525

			if slot0 / slot3 * 2 < 1 then
				return slot2 / 2 * slot0 * slot0 * ((slot4 + 1) * slot0 - slot4) + slot1
			else
				slot0 = slot0 - 2

				return slot2 / 2 * (slot0 * slot0 * ((slot4 + 1) * slot0 + slot4) + 2) + slot1
			end
		end,
		back_out_in = function (slot0, slot1, slot2, slot3, slot4)
			if slot0 < slot3 / 2 then
				return uv0(slot0 * 2, slot1, slot2 / 2, slot3, slot4)
			else
				return uv1(slot0 * 2 - slot3, slot1 + slot2 / 2, slot2 / 2, slot3, slot4)
			end
		end,
		bounce_in = function (slot0, slot1, slot2, slot3)
			return slot2 - uv0(slot3 - slot0, 0, slot2, slot3) + slot1
		end,
		bounce_out = function (slot0, slot1, slot2, slot3)
			if slot0 / slot3 < 0.36363636363636365 then
				return slot2 * 7.5625 * slot0 * slot0 + slot1
			elseif slot0 < 0.7272727272727273 then
				slot0 = slot0 - 0.5454545454545454

				return slot2 * (7.5625 * slot0 * slot0 + 0.75) + slot1
			elseif slot0 < 0.9090909090909091 then
				slot0 = slot0 - 0.8181818181818182

				return slot2 * (7.5625 * slot0 * slot0 + 0.9375) + slot1
			else
				slot0 = slot0 - 0.9545454545454546

				return slot2 * (7.5625 * slot0 * slot0 + 0.984375) + slot1
			end
		end,
		bounce_in_out = function (slot0, slot1, slot2, slot3)
			if slot0 < slot3 / 2 then
				return uv0(slot0 * 2, 0, slot2, slot3) * 0.5 + slot1
			else
				return uv1(slot0 * 2 - slot3, 0, slot2, slot3) * 0.5 + slot2 * 0.5 + slot1
			end
		end,
		bounce_out_in = function (slot0, slot1, slot2, slot3)
			if slot0 < slot3 / 2 then
				return uv0(slot0 * 2, slot1, slot2 / 2, slot3)
			else
				return uv1(slot0 * 2 - slot3, slot1 + slot2 / 2, slot2 / 2, slot3)
			end
		end
	}
	slot5 = nil
	slot5 = {
		format = function (slot0, slot1, slot2, slot3)
			slot6 = slot2 or "\t"
			slot6 = tostring
			slot7 = slot3 or " "
			slot1 = tostring(slot1 or "\n")
			slot4 = 1
			slot5 = 0
			slot6 = 0
			slot11 = string.sub(slot6(slot7), -1) == "\n"

			for slot15 = 1, string.len(tostring(slot0)) do
				slot16 = string.sub(slot0, slot15, slot15)

				if not nil and (slot16 == "{" or slot16 == "[") then
					slot5 = slot5 + 1
				elseif not slot10 and (slot16 == "}" or slot16 == "]") then
					if slot9 == "{" or slot9 == "[" then
						slot8[slot4 - 1] = string.rep(slot2, slot5 - 1) .. slot9 .. slot16
					else
						slot8[slot4] = slot1 .. string.rep(slot2, slot5) .. slot16
					end
				elseif not slot10 and slot16 == "," then
					slot8[slot4] = slot16 .. slot1
					slot6 = -1
				elseif not slot10 and slot16 == ":" then
					slot8[slot4] = slot16 .. slot3

					if slot11 then
						slot8[slot4 + 1] = string.rep(slot2, slot5)
					end
				else
					if slot16 == "\"" and slot9 ~= "\\" then
						slot10 = not slot10 and true or nil
					end

					if slot5 ~= slot6 then
						slot8[slot4] = string.rep(slot2, slot5)
						slot6 = slot5
						slot4 = slot4 + 1
					end

					slot8[slot4] = slot16
				end

				slot4 = slot4 + 1
				slot9 = slot16
			end

			return table.concat({
				[slot4] = nil == ":" and slot16 .. slot1 or string.rep(tostring(slot6), slot5) .. slot16 .. slot1
			})
		end,
		highlight = function (slot0, slot1, slot2, slot3, slot4)
			slot5 = slot1 or uv0
			slot2 = slot2 or uv3
			slot4 = slot4 or uv2
			slot3 = slot3 or uv1
			slot5 = 1
			slot7 = {}
			slot10 = slot5

			for slot15 = 1, string.len(tostring(slot0)) do
				slot16 = string.sub(slot0, slot15, slot15)
				slot17 = nil

				if not nil and (slot16 == "{" or slot16 == "[") then
					slot17 = slot1

					table.insert({}, slot16)
				elseif not slot9 and (slot16 == "}" or slot16 == "]") then
					slot17 = slot1

					if slot8 == "{" or slot8 == "[" then
						table.insert(slot11, slot16)
					else
						table.insert(slot11, slot16)
					end
				elseif not slot9 and (slot16 == "," or slot16 == ":") then
					slot17 = slot1

					table.insert(slot11, slot16)
				else
					if slot16 == "\"" and slot8 ~= "\\" then
						slot9 = not slot9 and true or nil
						slot17 = slot2
					elseif slot10 == slot2 then
						slot17 = slot9 and slot3 or slot4
					elseif slot10 == slot1 and slot16 ~= " " and slot16 ~= "\n" and slot16 ~= "\t" then
						slot17 = slot9 and slot3 or slot4
					end

					table.insert(slot11, slot16)
				end

				if slot17 ~= nil and slot17 ~= slot10 then
					table.insert(slot7, {
						slot10[1],
						slot10[2],
						slot10[3],
						table.concat(slot11)
					})

					slot11 = {
						table.remove(slot11, #slot11)
					}
					slot10 = slot17
				end

				slot8 = slot16
			end

			if #slot11 > 0 then
				table.insert(slot7, {
					slot10[1],
					slot10[2],
					slot10[3],
					table.concat(slot11)
				})
			end

			return slot7
		end,
		print_highlighted = function (slot0, slot1, slot2, slot3, slot4)
			slot10 = slot2

			for slot10 = 1, #uv0.highlight(slot0, slot1, slot3, slot4, slot10) do
				slot11, slot12, slot13, slot16 = unpack(slot5[slot10])

				uv1(slot16 .. (slot10 ~= slot6 and "" or "\n"), slot11, slot12, slot13, 255)
			end

			return slot5
		end,
		stringify = function (slot0, slot1, slot2, slot3)
			slot4, slot5 = pcall(json.stringify, slot0)

			if not slot4 then
				error(slot5, 2)

				return
			end

			return uv0.format(slot5, slot1, slot2, slot3)
		end
	}
	slot7 = utils.get_vfunc("vstdlib.dll", "VEngineCvar007", 25, ffi.typeof("void (__cdecl*)(void* pInterface, $&, const char* szText, ...)", ffi.typeof([[
            struct {
                uint8_t r;
                uint8_t g;
                uint8_t b;
                uint8_t a;
            }
        ]])))

	function slot8(slot0, slot1, slot2, slot3, slot4)
		uv0(uv1(slot1, slot2, slot3, slot4), slot0)
	end

	slot9 = {
		221,
		221,
		221
	}
	slot10 = {
		180,
		230,
		30
	}
	slot11 = {
		96,
		160,
		220
	}
	slot12 = {
		218,
		230,
		30
	}
	slot6 = nil

	function slot6(slot0, slot1)
		slot2, slot3, slot4 = nil

		if not (slot1 or {})[1] then
			for slot8 = 1, 256 do
				slot3 = slot8 - 1

				for slot12 = 1, 8 do
					slot3 = bit.bxor(bit.rshift(slot3, 1), bit.band(3988292384.0, -bit.band(slot3, 1)))
				end

				slot1[slot8] = slot3
			end
		end

		slot3 = 4294967295.0

		for slot8 = 1, #slot0 do
			slot3 = bit.bxor(bit.rshift(slot3, 8), slot1[bit.band(bit.bxor(slot3, string.byte(slot0, slot8)), 255) + 1])
		end

		return bit.band(bit.bnot(slot3), 4294967295.0)
	end

	slot7 = nil
	slot7 = {
		makeencoder = function (slot0)
			slot1 = {}

			for slot6 = 1, #slot0 do
			end

			for slot6, slot7 in pairs({
				[slot6 - 1] = slot0:sub(slot6, slot6)
			}) do
				slot1[slot6] = slot7:byte()
			end

			return slot1
		end,
		makedecoder = function (slot0)
			for slot5, slot6 in pairs(uv0.makeencoder(slot0)) do
				-- Nothing
			end

			return {
				[slot6] = slot5
			}
		end
	}

	function slot8(slot0, slot1, slot2)
		return bit.band(bit.rshift(slot0, slot1), bit.lshift(1, slot2) - 1)
	end

	slot9 = slot7.makeencoder("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")
	slot10 = slot7.makedecoder("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")

	function slot7.encode(slot0, slot1, slot2)
		slot1 = slot1 or uv0
		slot3 = {}
		slot4 = 1
		slot5 = #slot0
		slot7 = {}

		for slot11 = 1, slot5 - slot5 % 3, 3 do
			slot12, slot13, slot14 = string.byte(slot0, slot11, slot11 + 2)
			slot15 = slot12 * 65536 + slot13 * 256 + slot14
			slot16 = nil

			if slot2 then
				if not slot7[slot15] then
					slot7[slot15] = string.char(slot1[uv1(slot15, 18, 6)], slot1[uv1(slot15, 12, 6)], slot1[uv1(slot15, 6, 6)], slot1[uv1(slot15, 0, 6)])
				end
			else
				slot16 = string.char(slot1[uv1(slot15, 18, 6)], slot1[uv1(slot15, 12, 6)], slot1[uv1(slot15, 6, 6)], slot1[uv1(slot15, 0, 6)])
			end

			slot3[slot4] = slot16
			slot4 = slot4 + 1
		end

		if slot6 == 2 then
			slot8, slot9 = string.byte(slot0, slot5 - 1, slot5)
			slot10 = slot8 * 65536 + slot9 * 256
			slot3[slot4] = string.char(slot1[uv1(slot10, 18, 6)], slot1[uv1(slot10, 12, 6)], slot1[uv1(slot10, 6, 6)], slot1[64])
		elseif slot6 == 1 then
			slot8 = string.byte(slot0, slot5) * 65536
			slot3[slot4] = string.char(slot1[uv1(slot8, 18, 6)], slot1[uv1(slot8, 12, 6)], slot1[64], slot1[64])
		end

		return table.concat(slot3)
	end

	function slot7.decode(slot0, slot1, slot2)
		slot3 = "[^%w%+%/%=]"

		if slot1 or uv0 then
			slot4, slot5 = nil

			for slot9, slot10 in pairs(slot1) do
				if slot10 == 62 then
					slot4 = slot9
				elseif slot10 == 63 then
					slot5 = slot9
				end
			end

			slot3 = ("[^%%w%%%s%%%s%%=]"):format(string.char(slot4), string.char(slot5))
		end

		slot0 = slot0:gsub(slot3, "")
		slot4 = slot2 and {}
		slot5 = {}
		slot6 = 1
		slot7 = #slot0

		for slot12 = 1, (slot0:sub(-2) == "==" and 2 or slot0:sub(-1) == "=" and 1 or 0) > 0 and slot7 - 4 or slot7, 4 do
			slot13, slot14, slot15, slot16 = string.byte(slot0, slot12, slot12 + 3)
			slot17 = nil

			if slot2 then
				if not slot4[slot13 * 16777216 + slot14 * 65536 + slot15 * 256 + slot16] then
					slot19 = slot1[slot13] * 262144 + slot1[slot14] * 4096 + slot1[slot15] * 64 + slot1[slot16]
					slot4[slot18] = string.char(uv1(slot19, 16, 8), uv1(slot19, 8, 8), uv1(slot19, 0, 8))
				end
			else
				slot18 = slot1[slot13] * 262144 + slot1[slot14] * 4096 + slot1[slot15] * 64 + slot1[slot16]
				slot17 = string.char(uv1(slot18, 16, 8), uv1(slot18, 8, 8), uv1(slot18, 0, 8))
			end

			slot5[slot6] = slot17
			slot6 = slot6 + 1
		end

		if slot8 == 1 then
			slot9, slot10, slot11 = string.byte(slot0, slot7 - 3, slot7 - 1)
			slot12 = slot1[slot9] * 262144 + slot1[slot10] * 4096 + slot1[slot11] * 64
			slot5[slot6] = string.char(uv1(slot12, 16, 8), uv1(slot12, 8, 8))
		elseif slot8 == 2 then
			slot9, slot10 = string.byte(slot0, slot7 - 3, slot7 - 2)
			slot5[slot6] = string.char(uv1(slot1[slot9] * 262144 + slot1[slot10] * 4096, 16, 8))
		end

		return table.concat(slot5)
	end

	slot8 = nil
	slot8 = _G.table

	function slot8.copy(slot0)
		slot2 = nil

		if type(slot0) == "table" then
			for slot6, slot7 in next, slot0, nil do
				-- Nothing
			end

			setmetatable({
				[uv0.copy(slot6)] = uv0.copy(slot7)
			}, uv0.copy(getmetatable(slot0)))
		else
			slot2 = slot0
		end

		return slot2
	end

	function slot8.rebuild(slot0, slot1)
		slot2 = {}

		for slot6, slot7 in pairs(slot0) do
			slot8, slot2[slot8] = slot1(slot6, slot7)
		end

		return slot2
	end

	function slot8.get_keys(slot0, slot1, slot2)
		if not slot1 then
			slot1 = {}
			slot2 = ""
		end

		for slot6, slot7 in pairs(slot0) do
			if type(slot7) == "table" and #slot7 == 0 then
				uv0.get_keys(slot7, slot1, slot2 .. slot6 .. ".")
			else
				slot1[slot2 .. slot6] = slot7
			end
		end

		return slot1
	end

	function slot8.comparison(slot0, slot1)
		if uv0.copy(slot0) == uv0.copy(slot1) then
			return true
		elseif type(slot2) == "table" and type(slot3) == "table" then
			for slot7, slot8 in pairs(slot2) do
				if not slot3[slot7] then
					return false
				elseif slot8 ~= slot9 then
					if type(slot8) == "table" and type(slot9) == "table" then
						if not uv0.comparison(slot8, slot9) then
							return false
						end
					else
						return false
					end
				end
			end

			for slot7, slot8 in pairs(slot3) do
				if not slot2[slot7] then
					return false
				end
			end

			return true
		end

		return false
	end

	slot9 = slot7.makeencoder("0ucHJINGekQRUwZWVbPXyYlshz65DfLnpxTtKiFvor4ad9A7M3mSBCE21gjO8q+/=")
	slot10 = slot7.makedecoder("0ucHJINGekQRUwZWVbPXyYlshz65DfLnpxTtKiFvor4ad9A7M3mSBCE21gjO8q+/=")
	slot11 = {}
	slot12 = {}

	files.create_folder("nl\\scripts\\grenade helper")

	slot15 = {}
	slot16, slot17 = pcall(json.parse, files.read("nl\\scripts\\grenade helper\\database.json"))

	if slot16 and type(slot17) == "table" then
		slot15 = slot17
	end

	slot15.locations = slot15.locations or {}
	slot15.active_locations = slot15.active_locations or {
		true,
		true,
		true
	}
	slot15.map_patterns = slot15.map_patterns or {}

	function slot18()
		slot1, slot2 = pcall(json.parse, files.read(uv0))

		if slot1 and type(slot2) == "table" then
			uv1 = slot2
		end

		uv1.locations = uv1.locations or {}
		uv1.active_locations = uv1.active_locations or {
			true,
			true,
			true
		}
		uv1.map_patterns = uv1.map_patterns or {}
	end

	function slot19()
		uv0.locations = uv0.locations or {}
		uv0.active_locations = uv0.active_locations or {
			true,
			true,
			true
		}
		uv0.map_patterns = uv0.map_patterns or {}
		slot0 = {}

		for slot4, slot5 in pairs(uv0.active_locations) do
			slot0[#slot0 + 1] = slot5
		end

		uv0.active_locations = slot0

		for slot5, slot6 in pairs(uv0.locations) do
			-- Nothing
		end

		uv0.locations = {
			[slot5] = uv1.locations:clear_location_garbage(slot6)
		}

		files.write(uv2, json.stringify(uv0))
	end

	slot20 = common.get_username()
	slot22 = render.screen_size() / 2

	while slot21.x == 0 or slot21.y == 0 do
		slot22 = render.screen_size() / 2
	end

	slot23 = panorama.SteamOverlayAPI.OpenExternalBrowserURL

	function slot24(slot0, ...)
		slot1 = {
			...
		}

		if type(slot0) == "boolean" and slot0 then
			utils.console_exec("playvol buttons/button11.wav 65")
		else
			slot1 = {
				slot0
			}
		end

		slot2 = uv0.concat(slot1)

		print_raw("B4E61E[Helper] DEFAULT" .. slot2)
		print_dev("[Helper] " .. slot2)
	end

	slot11.refs = {
		doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
		hideshots = {}
	}
	slot11.refs.hideshots.enabled = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots")
	slot11.refs.hideshots.lag_options = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options")
	slot11.refs.extended_angles = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles")
	slot11.refs.slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk")
	slot11.refs.fake_duck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck")
	slot11.refs.air_duck = ui.find("Miscellaneous", "Main", "Movement", "Air Duck")
	slot11.refs.air_strafe = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe")
	slot11.refs.quick_stop = ui.find("Miscellaneous", "Main", "Movement", "Quick Stop")
	slot11.refs.strafer_wasd = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe", "WASD Strafe")
	slot11.refs.strafer_smoothing = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe", "Smoothing")
	slot11.refs.strafe_assist = ui.find("Miscellaneous", "Main", "Movement", "Strafe Assist")
	slot11.tabs = {
		info = {
			main = ui.create(ui.get_icon("book") .. " Info", "Main"),
			faq = ui.create(ui.get_icon("book") .. " Info", "FAQ"),
			recomendations = ui.create(ui.get_icon("book") .. " Info", "Recomendations")
		},
		settings = {
			settings = ui.create(ui.get_icon("gear") .. " Settings", "Settings"),
			customization = ui.create(ui.get_icon("gear") .. " Settings", "Customization")
		},
		locations = {
			manage_sources = ui.create(ui.get_icon("file-invoice") .. " Locations", "Manage Sources"),
			editing_location = ui.create(ui.get_icon("file-invoice") .. " Locations", "Editing Location"),
			manage_map_patterns = ui.create(ui.get_icon("file-invoice") .. " Locations", "Manage Map Patterns")
		}
	}
	slot11.info = {
		welcome = slot11.tabs.info.main:label("Welcome back, " .. slot20 .. "!"),
		join_the_discord_server = slot11.tabs.info.main:button(ui.get_icon("user-plus") .. " Join The Discord Server", function ()
			uv0("https://discord.gg/uM2uSEJzQJ")
		end, true),
		get_discord_verification_code = slot11.tabs.info.main:button(ui.get_icon("user-check") .. " Get Discord Verification Code", function ()
			slot0 = uv0

			uv4:get("https://northon.dev/neverlose/discord/get_code.php?data=" .. uv2.encode(slot0 .. ":" .. "grenade-helper" .. ":" .. tostring(math.floor(math.abs(uv1(slot0) + common.get_timestamp()))), uv3), function (slot0)
				if slot0.body ~= nil and slot1:len() ~= 0 then
					uv0.set(slot1)
					print_raw("B4E61E[helper] FFFFFFYour verification code: B0C5FF" .. slot1 .. "FFFFFF (Copied to clipboard)")
				end
			end)
		end, true)
	}

	slot11.tabs.info.main:label("If you find a bug or have a problem with the script, create a ticket and describe your problem")

	slot11.faq = {
		selection = slot1.new("faq selection", slot11.tabs.info.faq:list("\nfaq selection", {
			"How to Create Locations?",
			"How to Import Locations?",
			"How to Use “Manage Map Patterns”?",
			"Another Question?"
		})),
		how_to_create_locations = slot1.new("How to Create Locations?", slot11.tabs.info.faq:label("How to Create Locations?"), function ()
			return uv0.faq.selection:get() == 1
		end),
		how_to_create_locations_video = slot1.new("Create Locations Tutorial", slot11.tabs.info.faq:button("Create Locations Tutorial", function ()
			uv0("https://youtu.be/vNYeEH59Vn4")
		end), function ()
			return uv0.faq.selection:get() == 1
		end),
		how_to_import_locations = slot1.new("How to Import Locations?", slot11.tabs.info.faq:label("How to Import Locations?"), function ()
			return uv0.faq.selection:get() == 2
		end),
		how_to_import_locations_video = slot1.new("Import Locations Tutorial", slot11.tabs.info.faq:button("Import Locations Tutorial", function ()
			uv0("https://youtu.be/bBaUiGnKzXU")
		end), function ()
			return uv0.faq.selection:get() == 2
		end),
		how_to_use_manage_map_locations = slot1.new("How to Use “Manage Map Patterns”", slot11.tabs.info.faq:label("How to Use “Manage Map Patterns”"), function ()
			return uv0.faq.selection:get() == 3
		end),
		how_to_import_locations_video = slot1.new("Usage \"Manage Map Patterns\" Tutorial", slot11.tabs.info.faq:button("Usage \"Manage Map Patterns\" Tutorial", function ()
			uv0("https://youtu.be/U0icsbZdpkc")
		end), function ()
			return uv0.faq.selection:get() == 3
		end),
		another_question = slot1.new("Another Question?", slot11.tabs.info.faq:label(""), function ()
			return uv0.faq.selection:get() == 4
		end)
	}
	slot11.recomendations = {
		cheat_config = slot11.tabs.info.recomendations:button(" Cheat Config ", function ()
			uv0("https://en.neverlose.cc/market/item?id=OvW8Kn")
		end),
		northon_lua = slot11.tabs.info.recomendations:button(" Northon Lua ", function ()
			uv0("https://en.neverlose.cc/market/item?id=foPxEt")
		end),
		youtube = slot11.tabs.info.recomendations:button(" YouTube ", function ()
			uv0("https://youtube.com/c/v1pix")
		end)
	}
	slot11.settings = {
		hotkey = slot11.tabs.settings.settings:hotkey("Hotkey"),
		aimbot_mode = slot1.new("aimbot_mode", slot11.tabs.settings.settings:combo("Mode", {
			"Off",
			"Legit",
			"Rage"
		}))
	}
	slot11.settings.aimbot_mode_group = slot11.settings.aimbot_mode:create()
	slot11.settings.smooth = slot1.new("smooth", slot11.settings.aimbot_mode_group:slider("Smooth", 1, 100, 50, 1, "%"), function ()
		return uv0.settings.aimbot_mode:get() == "Legit"
	end)
	slot11.settings.fov = slot1.new("fov", slot11.settings.aimbot_mode_group:slider("Fov", 40, 360, 100, 1, "°"), function ()
		return uv0.settings.aimbot_mode:get() ~= "Off"
	end)
	slot11.settings.automatic_thow = slot1.new("options", slot11.tabs.settings.settings:switch("Automatic Throw"))

	slot11.settings.automatic_thow:tooltip("Throw without attack (mouse1 or mouse2)")

	slot11.customization = {
		color = slot11.tabs.settings.customization:color_picker("Color", color(120, 120, 255, 255)),
		show_locations_behind_walls = slot11.tabs.settings.customization:switch("Show Behind Walls"),
		types = slot11.tabs.settings.customization:selectable("Types", {
			"Smoke",
			"Flashbang",
			"Decoy Grenade",
			"High Explosive",
			"Molotov",
			"Wallbang",
			"Movement"
		})
	}
	slot11.locations = {
		edit_mode = false,
		delete_state = {
			false,
			false,
			false
		},
		editing_label = slot1.new("editing_label", slot11.tabs.locations.manage_sources:label("Editing local source"), function ()
			return uv0.locations.edit_mode
		end),
		locations_on = slot1.new("locations_on", slot11.tabs.locations.manage_sources:label("Locations on"), function ()
			return uv0.locations.edit_mode
		end),
		selection = slot1.new("selection", slot11.tabs.locations.manage_sources:list("\nselection", {
			"+ Create New"
		}), function ()
			return not uv0.locations.edit_mode
		end),
		enabled = slot1.new("enabled", slot11.tabs.locations.manage_sources:switch("Enabled"), function ()
			return not uv0.locations.edit_mode and #uv0.locations.selection:list() ~= uv0.locations.selection:get()
		end),
		new_source_name = slot1.new("new_source_name", slot11.tabs.locations.manage_sources:input("New Source Name", ""), function ()
			return not uv0.locations.edit_mode and #uv0.locations.selection:list() == uv0.locations.selection:get()
		end),
		create = slot1.new("create", slot11.tabs.locations.manage_sources:button(" Create "), function ()
			return not uv0.locations.edit_mode and #uv0.locations.selection:list() == uv0.locations.selection:get()
		end),
		edit = slot1.new("edit", slot11.tabs.locations.manage_sources:button(" Edit ", function ()
			uv0.locations.delete_state = {
				false,
				false
			}
		end), function ()
			slot0 = false

			if uv0.locations[uv1.locations.selection:get()] then
				slot0 = slot1.builtin
			end

			return not uv1.locations.edit_mode and #uv1.locations.selection:list() ~= uv1.locations.selection:get() and slot0
		end),
		delete = slot1.new("delete", slot11.tabs.locations.manage_sources:button(" Delete ", function ()
			uv0.locations.delete_state[1] = true
		end), function ()
			slot0 = false

			if uv0.locations[uv1.locations.selection:get()] then
				slot0 = slot1.builtin
			end

			return not uv1.locations.edit_mode and #uv1.locations.selection:list() ~= uv1.locations.selection:get() and slot0 and not uv1.locations.delete_state[1]
		end),
		delete_confirm = slot1.new("delete_confirm", slot11.tabs.locations.manage_sources:button(" Delete (CONFIRM) ", function ()
			uv0.locations.delete_state[1] = false
		end), function ()
			slot0 = false

			if uv0.locations[uv1.locations.selection:get()] then
				slot0 = slot1.builtin
			end

			return not uv1.locations.edit_mode and #uv1.locations.selection:list() ~= uv1.locations.selection:get() and slot0 and uv1.locations.delete_state[1]
		end),
		delete_cancel = slot1.new("delete_cancel", slot11.tabs.locations.manage_sources:button(" Delete (CANCEL) ", function ()
			uv0.locations.delete_state[1] = false
		end), function ()
			slot0 = false

			if uv0.locations[uv1.locations.selection:get()] then
				slot0 = slot1.builtin
			end

			return not uv1.locations.edit_mode and #uv1.locations.selection:list() ~= uv1.locations.selection:get() and slot0 and uv1.locations.delete_state[1]
		end),
		search = slot1.new("search", slot11.tabs.locations.manage_sources:input("\n search", " "), function ()
			return uv0.locations.edit_mode
		end),
		locations_selection = slot1.new("locations_selection", slot11.tabs.locations.manage_sources:list("\n locations_selection", {
			"+ Create new"
		}), function ()
			return uv0.locations.edit_mode
		end),
		all_maps = slot1.new("all_maps", slot11.tabs.locations.manage_sources:switch("All maps"), function ()
			return uv0.locations.edit_mode
		end),
		import_from_clipboard = slot1.new("import_from_clipboard", slot11.tabs.locations.manage_sources:button(" Import from clipboard "), function ()
			return uv0.locations.edit_mode
		end),
		export_all_to_clipboard = slot1.new("export_all_to_clipboard", slot11.tabs.locations.manage_sources:button(" Export all to clipboard "), function ()
			return uv0.locations.edit_mode
		end),
		delete_location = slot1.new("delete_location", slot11.tabs.locations.manage_sources:button(" Delete ", function ()
			uv0.locations.delete_state[2] = true
		end), function ()
			return uv0.locations.edit_mode and uv0.locations.locations_selection:get() ~= 1 and not uv0.locations.delete_state[2]
		end),
		delete_location_confirm = slot1.new("delete_location_confirm", slot11.tabs.locations.manage_sources:button(" Delete (CONFIRM) ", function ()
			uv0.locations.delete_state[2] = false
		end), function ()
			return uv0.locations.edit_mode and uv0.locations.locations_selection:get() ~= 1 and uv0.locations.delete_state[2]
		end),
		delete_location_cancel = slot1.new("delete_location_cancel", slot11.tabs.locations.manage_sources:button(" Delete (CANCEL) ", function ()
			uv0.locations.delete_state[2] = false
		end), function ()
			return uv0.locations.edit_mode and uv0.locations.locations_selection:get() ~= 1 and uv0.locations.delete_state[2]
		end),
		back = slot1.new("back", slot11.tabs.locations.manage_sources:button(" Back ", function ()
			uv0.locations.delete_state = {
				false,
				false
			}
		end), function ()
			return uv0.locations.edit_mode
		end),
		builder = {},
		failed_to_edit = slot1.new("failed_to_edit", slot11.tabs.locations.editing_location:label("Failed to edit: You need to be in-game"), function ()
			return uv0.locations.edit_mode and not globals.is_in_game
		end)
	}
	slot11.locations.builder.type = slot1.new("type", slot11.tabs.locations.editing_location:combo("\ntype", {
		"Grenade",
		"Movement"
	}), function ()
		return uv0.locations.edit_mode and globals.is_in_game
	end)
	slot11.locations.builder.from = slot1.new("from", slot11.tabs.locations.editing_location:input("From", ""), function ()
		return uv0.locations.edit_mode and globals.is_in_game
	end)
	slot11.locations.builder.to = slot1.new("to", slot11.tabs.locations.editing_location:input("To", ""), function ()
		return uv0.locations.edit_mode and globals.is_in_game
	end)
	slot11.locations.builder.description = slot1.new("description", slot11.tabs.locations.editing_location:input("Description (Optional)", ""), function ()
		return uv0.locations.edit_mode and globals.is_in_game
	end)
	slot11.locations.builder.grenade_properties = slot1.new("grenade_properties", slot11.tabs.locations.editing_location:selectable("Grenade Properties", {
		"Jump",
		"Run",
		"Walk (Shift)",
		"Throw strength",
		"Force-enable recovery",
		"Delayed throw"
	}), function ()
		return uv0.locations.edit_mode and globals.is_in_game and uv0.locations.builder.type:get() == "Grenade"
	end)
	slot11.locations.builder.throw_strength = slot1.new("throw_strength", slot11.tabs.locations.editing_location:combo("Throw strength", {
		"Left Click",
		"Left / Right Click",
		"Right Click"
	}), function ()
		return uv0.locations.edit_mode and globals.is_in_game and uv0.locations.builder.grenade_properties:get(4) and uv0.locations.builder.type:get() == "Grenade"
	end)
	slot11.locations.builder.run_direction = slot1.new("run_direction", slot11.tabs.locations.editing_location:combo("Run direction", {
		"Forward",
		"Left",
		"Right",
		"Back",
		"Custom"
	}), function ()
		return uv0.locations.edit_mode and globals.is_in_game and uv0.locations.builder.grenade_properties:get(2) and uv0.locations.builder.type:get() == "Grenade"
	end)
	slot11.locations.builder.run_direction_custom = slot1.new("run_direction_custom", slot11.tabs.locations.editing_location:slider("Run direction ", -180, 180, 0), function ()
		return uv0.locations.edit_mode and globals.is_in_game and uv0.locations.builder.grenade_properties:get(2) and uv0.locations.builder.run_direction:get() == "Custom" and uv0.locations.builder.type:get() == "Grenade"
	end)
	slot11.locations.builder.run_duration = slot1.new("run_duration", slot11.tabs.locations.editing_location:slider("Run duration", 0, 256, 20), function ()
		return uv0.locations.edit_mode and globals.is_in_game and uv0.locations.builder.grenade_properties:get(2) and uv0.locations.builder.type:get() == "Grenade"
	end)
	slot11.locations.builder.delay = slot1.new("delay", slot11.tabs.locations.editing_location:slider("Throw delay", 1, 64, 1), function ()
		return uv0.locations.edit_mode and globals.is_in_game and uv0.locations.builder.grenade_properties:get(6) and uv0.locations.builder.type:get() == "Grenade"
	end)
	slot11.locations.builder.recovery_direction = slot1.new("recovery_direction", slot11.tabs.locations.editing_location:combo("Recovery direction", {
		"Forward",
		"Left",
		"Right",
		"Back",
		"Custom"
	}), function ()
		return uv0.locations.edit_mode and globals.is_in_game and uv0.locations.builder.grenade_properties:get(5) and uv0.locations.builder.type:get() == "Grenade"
	end)
	slot11.locations.builder.recovery_direction_custom = slot1.new("recovery_direction_custom", slot11.tabs.locations.editing_location:slider("Recovery direction ", -180, 180, 0), function ()
		return uv0.locations.edit_mode and globals.is_in_game and uv0.locations.builder.grenade_properties:get(5) and uv0.locations.builder.recovery_direction:get() == "Custom" and uv0.locations.builder.type:get() == "Grenade"
	end)
	slot11.locations.builder.recovery_bannyhop = slot1.new("recovery_bannyhop", slot11.tabs.locations.editing_location:switch("Recovery bunny-hop"), function ()
		return uv0.locations.edit_mode and globals.is_in_game and uv0.locations.builder.grenade_properties:get(5) and uv0.locations.builder.type:get() == "Grenade"
	end)
	slot11.locations.record_bind = slot1.new("record_bind", slot11.tabs.locations.editing_location:switch("Recorder Bind"), function ()
		return uv0.locations.edit_mode and globals.is_in_game and uv0.locations.builder.type:get() == "Movement"
	end)
	slot11.locations.set_location = slot1.new("set_location", slot11.tabs.locations.editing_location:button(" Set location "), function ()
		return uv0.locations.edit_mode and globals.is_in_game and uv0.locations.builder.type:get() == "Grenade"
	end)
	slot11.locations.set_location_hotkey = slot1.new("set_location_hotkey", slot11.tabs.locations.editing_location:hotkey("Set location"), function ()
		return uv0.locations.edit_mode and globals.is_in_game and uv0.locations.builder.type:get() == "Grenade"
	end)
	slot11.locations.teleport = slot1.new("teleport", slot11.tabs.locations.editing_location:button(" Teleport "), function ()
		return uv0.locations.edit_mode and globals.is_in_game
	end)
	slot11.locations.teleport_hotkey = slot1.new("teleport_hotkey", slot11.tabs.locations.editing_location:hotkey("Teleport"), function ()
		return uv0.locations.edit_mode and globals.is_in_game
	end)
	slot11.locations.export_to_clipboard = slot1.new("export_to_clipboard", slot11.tabs.locations.editing_location:button(" Export to clipboard "), function ()
		return uv0.locations.edit_mode
	end)
	slot11.locations.save = slot1.new("save", slot11.tabs.locations.editing_location:button(" Save "), function ()
		return uv0.locations.edit_mode and globals.is_in_game
	end)

	function slot11.locations.on_load_reset(slot0)
		slot0.new_source_name:set("")
		slot0.search:set("")
		slot0.builder.type:set("Grenade")
		slot0.builder.from:set("")
		slot0.builder.to:set("")
		slot0.builder.description:set("")
		slot0.builder.run_duration:set(0)
		slot0.builder.run_direction:set("Forward")
		slot0.builder.run_direction_custom:set(0)
		slot0.builder.throw_strength:set("Left Click")
		slot0.builder.recovery_direction:set("Forward")
		slot0.builder.recovery_direction_custom:set(0)
		slot0.builder.recovery_bannyhop:set(false)
		slot0.builder.delay:set(0)
		slot0.builder.grenade_properties:set({})
	end

	utils.execute_after(0.01, function ()
		uv0.locations:on_load_reset()
	end)

	slot11.manage_map_patterns = {
		selection = slot1.new("selection map pattern", slot11.tabs.locations.manage_map_patterns:list("\nselection map pattern", {
			"Edit Current Map Pattern"
		}), function ()
			return globals.is_in_game and not uv0.locations.edit_mode
		end),
		current_map_pattern = slot1.new("current_map_pattern", slot11.tabs.locations.manage_map_patterns:label("Current Map Pattern"), function ()
			return globals.is_in_game and not uv0.locations.edit_mode and uv0.manage_map_patterns.selection:get() == #uv0.manage_map_patterns.selection:list()
		end),
		new_map_name = slot1.new("new_map_name", slot11.tabs.locations.manage_map_patterns:input("New Map Name", ""), function ()
			return globals.is_in_game and not uv0.locations.edit_mode and uv0.manage_map_patterns.selection:get() == #uv0.manage_map_patterns.selection:list()
		end),
		create_pattern = slot1.new("create pattern", slot11.tabs.locations.manage_map_patterns:button(" Save "), function ()
			return globals.is_in_game and not uv0.locations.edit_mode and uv0.manage_map_patterns.selection:get() == #uv0.manage_map_patterns.selection:list()
		end)
	}
	slot29 = slot11.tabs.locations.manage_map_patterns
	slot11.manage_map_patterns.delete_pattern = slot1.new("delete pattern", slot29:button(" Delete "), function ()
		return globals.is_in_game and not uv0.locations.edit_mode and uv0.manage_map_patterns.selection:get() ~= #uv0.manage_map_patterns.selection:list()
	end)

	function slot11.update_colored_names(slot0)
		link_active = "" .. ui.get_style()["Link Active"]:to_hex()

		slot0.info.welcome:name("Welcome back, " .. link_active .. uv0 .. "DEFAULT!")
		slot0.info.join_the_discord_server:name(link_active .. ui.get_icon("user-plus") .. "DEFAULT Join The Discord Server")
		slot0.info.get_discord_verification_code:name(link_active .. ui.get_icon("user-check") .. "DEFAULT Get Discord Verification Code")
		slot0.faq.how_to_create_locations:name(([[
link_active[1] defaultGo to 'Locations' tab
link_active[2] defaultSelect '+ Create New'
link_active[3] defaultType any name
link_active[4] defaultClick on 'Create'
link_active[5] defaultSelect the recently created locations
link_active[6] defaultClick on 'Edit'
link_active[7] defaultSelect '+ Create New'
link_active[8] defaultAfter you have configured the location in 'Editing Location', click on 'Save'
]]):gsub("link_active", link_active):gsub("default", "DEFAULT"))
		slot0.faq.how_to_import_locations:name(([[
link_active[1] defaultGo to 'Locations' tab
link_active[2] defaultSelect '+ Create New'
link_active[3] defaultType any name
link_active[4] defaultClick on 'Create'
link_active[5] defaultSelect the recently created locations
link_active[6] defaultClick on 'Edit'
link_active[7] defaultCopy location text
link_active[8] defaultClick on 'Import from clipboard'
]]):gsub("link_active", link_active):gsub("default", "DEFAULT"))
		slot0.faq.how_to_use_manage_map_locations:name(([[
link_active[1] defaultGo to 'Locations' tab
link_active[2] defaultSelect 'Edit Current Map Pattern'
link_active[3] defaultType the desired map name
link_active[3] defaultClick on 'Save'
]]):gsub("link_active", link_active):gsub("default", "DEFAULT"))
		slot0.faq.another_question:name(([[
link_active[1] defaultJoin the discord server
link_active[2] defaultOpen 'Support' сhannel
link_active[3] defaultClick on 'Create ticket'
link_active[4] defaultDescribe your problem or ask a question
]]):gsub("link_active", link_active):gsub("default", "DEFAULT"))
		ui.sidebar(link_active .. "Helper Renewed", link_active .. ui.get_icon("bomb"))
	end

	utils.execute_after(0.01, function ()
		uv0:update_colored_names()
	end)

	slot12.map_patterns = {
		default = {
			[1507960924.0] = "cs_agency",
			[1014664118.0] = "cs_office",
			[-923663825.0] = "dz_frostbite",
			[1463756432.0] = "cs_assault",
			[-1621571143.0] = "de_dust",
			[371013699.0] = "de_stmarc",
			[-1890957714.0] = "ar_shoots",
			[-2011174878.0] = "de_train",
			[-222265935.0] = "ar_baggage",
			[405708653.0] = "de_overpass",
			[790893427.0] = "dz_sirocco",
			[-542128589.0] = "ar_monastery",
			[878725495.0] = "de_bank",
			[-1218081885.0] = "de_guard",
			[1900771637.0] = "de_cache",
			[2056138930.0] = "gd_rialto",
			[2041417734.0] = "de_cbble",
			[1445192006.0] = "de_engage",
			[1476824995.0] = "de_vertigo",
			[-768791216.0] = "de_dust2",
			[899765791.0] = "de_safehouse",
			[1364328969.0] = "cs_militia",
			[-182586077.0] = "de_aztec",
			[-1411074561.0] = "de_tulip",
			[-1752602089.0] = "de_inferno",
			[1722587796.0] = "de_dust2_old",
			[792319475.0] = "de_ancient",
			[1563115098.0] = "de_nuke",
			[-1768287648.0] = "dz_blacksite",
			[-1541779215.0] = "de_sugarcane",
			[1238495690.0] = "ar_dizzy",
			[1850283081.0] = "de_anubis",
			[-1348292803.0] = "cs_apollo",
			[549370830.0] = "de_lake",
			[-1439577949.0] = "de_canals",
			[1964982021.0] = "de_elysion",
			[-1639993233.0] = "de_mirage",
			[-692592072.0] = "cs_italy"
		},
		selection = function (slot0)
			slot1 = {}
			slot2 = {
				[slot6] = slot7
			}

			for slot6, slot7 in pairs(slot0.default) do
				-- Nothing
			end

			for slot6, slot7 in pairs(uv0.map_patterns) do
				if not slot7.map then
					uv1.remove(uv0.map_patterns, slot6)
				else
					slot1[#slot1 + 1] = ("%s: %s"):format(slot7.map, slot7.pattern)
					slot2[slot7.pattern] = slot7.map
				end
			end

			slot1[#slot1 + 1] = "Edit Current Map Pattern"

			uv2.manage_map_patterns.selection:update(slot1)
			uv3.update()

			slot0.patterns = slot2

			if uv4.locations then
				uv4.locations:get_map_locatons()
			end
		end
	}

	slot12.map_patterns:selection()

	function slot12.map_patterns.on_create_map_pattern(slot0)
		slot1 = uv0.manage_map_patterns.new_map_name:get()

		if slot0.get() then
			if slot0.default[slot2] then
				uv1(true, ("Failed to create pattern: Pattern already added (%s: %s)"):format(slot0.default[slot2], slot2))

				return
			end

			if slot1:find(" ") or tonumber(slot1) ~= nil then
				uv1(true, ("Failed to create pattern: Invalid map name (%s)"):format(slot1))

				return
			end

			uv3.map_patterns[uv2.rebuild(uv3.map_patterns, function (slot0, slot1)
				return slot1.pattern, slot0
			end)[slot2] or #uv3.map_patterns + 1] = {
				map = slot1,
				pattern = slot2
			}

			uv4()
		end

		slot0:selection()
	end

	slot11.manage_map_patterns.create_pattern:set_callback(function ()
		uv0.map_patterns:on_create_map_pattern()
	end)

	function slot12.map_patterns.on_delete_map_pattern(slot0)
		if uv1.map_patterns[uv0.manage_map_patterns.selection:get()] then
			uv2.remove(uv1.map_patterns, slot1)
			uv3()
		end

		uv4.map_patterns:selection()
	end

	slot11.manage_map_patterns.delete_pattern:set_callback(function ()
		uv0.map_patterns:on_delete_map_pattern()
	end)

	function slot12.map_patterns.get()
		if entity.get(0) and slot0:get_classname() == "CWorld" then
			slot1 = slot0.m_WorldMins
			slot2 = slot0.m_WorldMaxs

			return uv0(string.format("bomb_%.2f_%.2f_%.2f %.2f_%.2f_%.2f", slot1.x, slot1.y, slot1.z, slot2.x, slot2.y, slot2.z))
		end
	end

	if globals.is_in_game then
		slot11.manage_map_patterns.current_map_pattern:set("Current Map Pattern: " .. slot12.map_patterns.get())
	end

	function slot12.get_map(slot0)
		if globals.is_in_game then
			if (slot0.map_patterns.patterns[slot0.map_patterns.get()] or string.lower(common.get_map_data().shortname)) == "de_shortnuke" then
				slot4 = "de_nuke"
			end

			return slot4
		end
	end

	slot12.yaw_directions_offsets = {
		[0] = "Forward",
		[-90.0] = "Right",
		Back = 180,
		Right = -90,
		Left = 90,
		Forward = 0,
		[180.0] = "Back",
		[90.0] = "Left"
	}
	slot12.strength_offsets = {
		[0] = "Right Click",
		"Left Click",
		["Left / Right Click"] = 0.5,
		["Left Click"] = 1,
		[0.5] = "Left / Right Click",
		["Right Click"] = 0
	}
	slot12.locations = {
		on_have_changes = false,
		garbage = {
			"red_color",
			"distance",
			"distance_alpha",
			"distance_width_mp",
			"in_fov_select_mp",
			"offscreen_offset",
			"in_range",
			"in_range_draw_mp",
			"in_range_text",
			"is_visible",
			"on_fov",
			"on_fov_color",
			"original_distance",
			"visible_alpha",
			"vector",
			"render_vector",
			"text_offset",
			"icon_offset",
			"bestname",
			"show_icon"
		},
		clear_location_garbage = function (slot0, slot1)
			slot2 = false

			if slot1.name or slot1.grenade or slot1.weapon then
				slot2 = true
			end

			if slot2 then
				for slot6, slot7 in pairs(slot0.garbage) do
					slot1[slot7] = nil
				end
			elseif #slot1 == 0 then
				for slot6, slot7 in pairs(slot1) do
					for slot11, slot12 in pairs(slot7) do
						for slot16, slot17 in pairs(slot0.garbage) do
							slot12[slot17] = nil
						end
					end
				end
			else
				for slot6, slot7 in pairs(slot1) do
					for slot11, slot12 in pairs(slot0.garbage) do
						slot7[slot12] = nil
					end
				end
			end

			return slot1
		end,
		default = {
			{
				0.1,
				"grenades",
				"Default: Grenade"
			},
			{
				0.2,
				"movements",
				"Default: Movement"
			},
			{
				0.3,
				"wallbangs",
				"Default: Wallbang"
			}
		},
		download = function (slot0)
			for slot4, slot5 in pairs(slot0.default) do
				slot6, slot7, slot8 = unpack(slot5)

				utils.execute_after(slot6, function ()
					uv1:get(("https://northon.dev/neverlose/grenade_helper_beta/%s.json"):format(uv0), function (slot0)
						if slot0.body ~= nil and slot1:len() ~= 0 then
							slot2, slot3 = pcall(json.parse, slot1)

							if slot2 and type(slot3) == "table" then
								uv0.locations[uv1] = {
									name = uv2,
									locations = slot3,
									builtin = uv3 == "v1pix"
								}

								uv4:selection()
								uv5.update()
							end
						end
					end)
				end)
			end
		end
	}

	slot12.locations:download()

	slot12.locations.map_locations = {}

	function slot12.locations.get_map_locatons(slot0)
		slot0.map_locations = {}

		for slot5, slot6 in pairs(uv1.locations) do
			if uv1.active_locations[slot5] and slot6.locations[uv0:get_map()] then
				for slot11, slot12 in pairs(slot7) do
					slot0:clear_location_garbage(slot12)

					slot0.map_locations[#slot0.map_locations + 1] = slot12
				end
			end
		end

		uv0.weapon_locations = nil
	end

	function slot12.locations.selection(slot0)
		slot0.list_data = {}
		slot1 = slot0.list_data

		for slot5, slot6 in pairs(uv0.locations) do
			slot1[#slot1 + 1] = (uv0.active_locations[slot5] and "[+] " or "[-] ") .. slot6.name
		end

		slot1[#slot1 + 1] = "+ Create New"

		uv1.locations.selection:update(slot1)
		uv2.locations:get_map_locatons()
	end

	slot12.locations:selection()

	function slot12.locations.on_selection(slot0)
		uv0.locations.delete_state = {
			false,
			false
		}

		if uv0.locations.enabled:get() ~= (uv1.active_locations[uv0.locations.selection:get()] or false) then
			uv0.locations.enabled:set(slot2)
			uv2()
		end

		uv3.locations.on_have_changes = true
	end

	slot11.locations.selection:set_callback(slot12.locations.on_selection, true)

	function slot12.locations.on_enabled(slot0)
		uv0.active_locations[uv1.locations.selection:get()] = slot0:get()

		uv2.locations:selection()

		uv2.locations.on_have_changes = true
	end

	slot11.locations.enabled:set_callback(slot12.locations.on_enabled)

	function slot12.locations.on_create(slot0)
		if uv0.locations.new_source_name:get():gsub(" ", "") == "" then
			slot1 = "Unnamed"
		end

		slot4 = 2

		while uv1.rebuild(uv2.locations, function (slot0, slot1)
			return slot1.name, true
		end)[slot1] do
			slot3 = string.format("%s (%d)", slot1, slot4)
			slot4 = slot4 + 1
		end

		uv2.locations[#uv2.locations + 1] = {
			builtin = true,
			name = slot3,
			locations = {}
		}

		slot0:selection()
		uv3.update()
		uv4()
	end

	slot11.locations.create:set_callback(function ()
		uv0.locations:on_create()
	end)

	function slot12.locations.on_delete(slot0)
		uv1.remove(uv2.locations, uv0.locations.selection:get())
		slot0:selection()
		uv3.update()
		uv4()
	end

	slot11.locations.delete_confirm:set_callback(function ()
		uv0.locations:on_delete()
	end)

	function slot12.locations.on_edit_list(slot0)
		if slot0.edit_locations then
			slot0.edit_locations.list = {
				ui = {
					"+ Create new"
				},
				data = {}
			}
			slot1 = uv0.locations.search:get():gsub(" ", ""):gsub("\t", ""):lower()

			if uv1:get_map() and uv0.locations.all_maps:get() or not globals.is_in_game then
				for slot8, slot9 in pairs(slot0.edit_locations.data.locations) do
					for slot13, slot14 in pairs(slot9) do
						slot15 = #slot14.name == 2 and slot14.name[2] or slot14.name

						if uv1.weapons.menu_names[slot14.weapon] and string.find(slot15:gsub(" ", ""):gsub("\t", ""):lower(), slot1, 1, true) then
							slot0.edit_locations.list.data[#slot0.edit_locations.list.data + 1] = {
								map = slot8,
								index = slot13,
								location = slot14
							}
							slot0.edit_locations.list.ui[#slot0.edit_locations.list.ui + 1] = ("[%s] %s: %s"):format(slot8, slot16, slot15)
						end
					end
				end
			elseif slot0.edit_locations.data.locations[slot3] then
				for slot9, slot10 in pairs(slot5) do
					slot11 = #slot10.name == 2 and slot10.name[2] or slot10.name

					if uv1.weapons.menu_names[slot10.weapon] and string.find(slot11:gsub(" ", ""):gsub("\t", ""):lower(), slot1, 1, true) then
						slot0.edit_locations.list.data[#slot0.edit_locations.list.data + 1] = {
							map = slot3,
							index = slot9,
							location = slot10
						}
						slot0.edit_locations.list.ui[#slot0.edit_locations.list.ui + 1] = ("%s: %s"):format(slot12, slot11)
					end
				end
			end

			uv0.locations.editing_label:name("Editing local source: " .. slot0.edit_locations.data.name .. "                                                             ")
			uv0.locations.locations_on:name("Locations on " .. (slot4 and "all maps" or slot3) .. "                                                             ")
			uv0.locations.locations_selection:update(slot0.edit_locations.list.ui)
		end
	end

	slot11.locations.search:set_callback(function ()
		uv0.locations:on_edit_list()
	end)
	slot11.locations.all_maps:set_callback(function ()
		uv0.locations:on_edit_list()
	end)
	slot11.locations.locations_selection:set_callback(function ()
		uv0.locations:on_edit_list()
	end)

	function slot12.locations.on_edit(slot0)
		if uv0.locations.selection:get() ~= #uv0.locations.selection:list() then
			slot0.edit_locations = {
				list = {},
				source_id = slot1,
				data = uv1.locations[slot1]
			}
			uv0.locations.edit_mode = true

			uv2.update()
			slot0:on_edit_list()
		end
	end

	slot11.locations.edit:set_callback(function ()
		uv0.locations:on_edit()
	end)

	slot25 = {}

	for slot29 = 128, 255 do
		slot25[#slot25 + 1] = string.char(slot29)
	end

	slot25 = ("[%s]"):format(slot8.concat(slot25))

	function slot12.locations.on_import(slot0)
		if not uv0.get() then
			uv1(true, "Failed to import: Clipboard is empty")

			return
		end

		slot2, slot3 = pcall(json.parse, slot1:gsub(uv2, ""))

		if not slot2 or type(slot3) ~= "table" then
			print_raw(slot3)
			uv1(true, "Failed to import: Invalid JSON")

			return
		end

		if not (slot1:sub(1, 1) == "[") and (slot3.name or slot3.grenade or slot3.weapon) then
			slot3 = {
				slot3
			}
			slot4 = true
		end

		if slot4 then
			if not uv3:get_map() then
				uv1(true, "Failed to import: You need to be in-game")

				return
			end

			if not slot0.edit_locations.data.locations[slot5] then
				slot0.edit_locations.data.locations[slot5] = {}
			end

			for slot9, slot10 in pairs(slot3) do
				slot0.edit_locations.data.locations[slot5][#slot0.edit_locations.data.locations[slot5] + 1] = slot10
			end
		else
			for slot8, slot9 in pairs(slot3) do
				if type(slot8) ~= "string" or slot8:find(" ") then
					uv1(true, ("Failed to import: Invalid map name (%s)"):format(slot8))
				end

				if not slot0.edit_locations.data.locations[slot8] then
					slot0.edit_locations.data.locations[slot8] = {}
				end

				for slot13, slot14 in pairs(slot9) do
					slot0.edit_locations.data.locations[slot8][#slot0.edit_locations.data.locations[slot8] + 1] = slot14
				end
			end
		end

		slot0:get_map_locatons()
		slot0:on_edit_list()

		slot0.edit_location = {
			edited = {
				index = 0,
				location = {}
			},
			original = {
				index = 0,
				location = {}
			}
		}

		uv4()
	end

	slot11.locations.import_from_clipboard:set_callback(function ()
		uv0.locations:on_import()
	end)

	function slot12.locations.on_export(slot0, slot1)
		slot2 = uv0.locations.locations_selection:get() - 1
		slot5 = {}

		if slot1 then
			if uv1:get_map() and uv0.locations.all_maps:get() or not globals.is_in_game then
				slot5 = slot0.edit_locations.data.locations
			elseif slot0.edit_locations.data.locations[slot4] then
				slot5 = slot0.edit_locations.data.locations[slot4]
			end
		else
			slot5 = slot2 == 0 and slot0.edit_location.edited.location or slot0.edit_locations.list.data[slot2].location
		end

		slot6 = uv2.copy(slot5)

		slot0:clear_location_garbage(slot6)

		slot7 = uv3.format(json.stringify(slot6), "\n", "  ")

		uv3.print_highlighted(slot7)
		uv4.set(slot7)
	end

	slot11.locations.export_all_to_clipboard:set_callback(function ()
		uv0.locations:on_export(true)
	end)
	slot11.locations.export_to_clipboard:set_callback(function ()
		uv0.locations:on_export(false)
	end)

	function slot12.locations.on_back(slot0)
		slot0.edit_locations = nil
		uv0.locations.edit_mode = false

		uv1.update()

		if slot0.on_have_changes then
			uv2()

			slot0.on_have_changes = false
		end

		uv3()
		slot0:get_map_locatons()
	end

	slot11.locations.back:set_callback(function ()
		uv0.locations:on_back()
	end)

	function slot12.locations.on_delete_location(slot0)
		slot2 = slot0.edit_locations.list.data[uv0.locations.locations_selection:get() - 1]

		uv1.remove(slot0.edit_locations.data.locations[slot2.map], slot2.index)
		uv2()
		slot0:get_map_locatons()
		slot0:on_edit_list()
		slot0:on_locations_selection()
		uv3.update()
	end

	slot11.locations.delete_location_confirm:set_callback(function ()
		uv0.locations:on_delete_location()
	end)

	slot12.locations.movement_recorder = {}

	function slot12.locations.record(slot0, slot1)
		slot2 = slot0.edit_location.edited
		slot3 = slot2.index
		slot4 = slot2.location

		if not entity.get_local_player() then
			return
		end

		slot6 = slot5:get_origin()
		slot7, slot8, slot9 = uv0:get_weapon(slot5)
		slot10 = render.camera_angles()

		if not slot0.movement_recorder.start_at then
			slot0.movement_recorder.start_at = slot1.command_number

			if slot0.edit_location.strafer == nil then
				slot0.edit_location.strafer = {
					quick_stop = uv1.refs.quick_stop:get(),
					air_strafe = uv1.refs.air_strafe:get(),
					wasd_strafer = uv1.refs.strafer_wasd:get(),
					strafer_smoothing = uv1.refs.strafer_smoothing:get()
				}
			end

			slot0.movement_recorder.movement = {
				steps = {}
			}
			slot4.position = {
				slot6:unpack()
			}
			slot4.viewangles = {
				slot10.x,
				slot10.y
			}
			slot4.weapon = slot8
		end

		uv1.refs.air_duck:override(false)
		uv1.refs.air_strafe:override()
		uv1.refs.strafe_assist:override(true)

		slot11 = slot1.command_number - slot0.movement_recorder.start_at

		if slot1.in_forward then
			(nil or {}).in_forward = true
		end

		if slot1.in_moveleft then
			(slot12 or {}).in_moveleft = true
		end

		if slot1.in_moveright then
			(slot12 or {}).in_moveright = true
		end

		if slot1.in_back then
			(slot12 or {}).in_back = true
		end

		if slot1.in_duck then
			(slot12 or {}).in_duck = true
		end

		if slot1.in_attack then
			(slot12 or {}).in_attack = true
		end

		if slot1.in_attack2 then
			(slot12 or {}).in_attack2 = true
		end

		if slot1.in_jump then
			(slot12 or {}).in_jump = true
		end

		if slot1.in_use then
			(slot12 or {}).in_use = true
		end

		if slot1.in_speed then
			(slot12 or {}).in_speed = true
		end

		slot15 = slot1.sidemove
		slot16 = slot1.weaponselect
		slot17 = render.camera_angles()
		slot0.movement_recorder.movement.steps[#slot0.movement_recorder.movement.steps + 1] = {
			move_yaw = slot1.move_yaw,
			forwardmove = slot1.forwardmove ~= 0 and slot14 or nil,
			sidemove = slot15 ~= 0 and slot15 or nil,
			buttons = slot12,
			weaponselect = slot16 ~= 0 and slot16 or nil,
			viewangles = {
				slot17.x,
				slot17.y
			}
		}
	end

	slot29 = {
		index = 0,
		location = {}
	}
	slot30 = "original"
	slot12.locations.edit_location = {
		edited = {
			index = 0,
			location = {}
		},
		[slot30] = slot29
	}

	function slot12.locations.on_edit_location(slot0)
		slot1 = slot0.edit_location.edited
		slot2 = slot1.index
		slot3 = slot1.location

		if uv0.locations.builder.from:get():gsub(" ", "") == "" then
			slot4 = "Unnamed"
		end

		if uv0.locations.builder.to:get():gsub(" ", "") == "" then
			slot5 = "Unnamed"
		end

		slot3.name = {
			slot4,
			slot5
		}
		slot3.description = uv0.locations.builder.description:get():gsub(" ", "") ~= "" and slot6:gsub("^%s+", ""):gsub("%s+$", "") or nil
		slot7, slot8 = nil

		if uv0.locations.builder.type:get() == "Grenade" then
			if #uv0.locations.builder.grenade_properties:get() ~= 0 then
				if uv0.locations.builder.grenade_properties:get() ~= 0 then
					-- Nothing
				end

				if uv0.locations.builder.grenade_properties:get(2) then
					slot7.run = uv0.locations.builder.run_duration:get()
					slot10 = uv1.yaw_directions_offsets[uv0.locations.builder.run_direction:get()] or uv0.locations.builder.run_direction_custom:get()
					slot7.run_yaw = slot10 ~= 0 and slot10 or nil
					slot7.run_speed = uv0.locations.builder.grenade_properties:get(3) or nil
				end

				if uv0.locations.builder.grenade_properties:get(4) then
					slot7.strength = uv1.strength_offsets[uv0.locations.builder.throw_strength:get()] ~= 1 and slot10 or nil
				end

				if uv0.locations.builder.grenade_properties:get(5) then
					slot7.recovery_yaw = uv1.yaw_directions_offsets[uv0.locations.builder.recovery_direction:get()] or uv0.locations.builder.recovery_direction_custom:get()
					slot7.recovery_jump = uv0.locations.builder.recovery_bannyhop:get() or nil
				end

				if uv0.locations.builder.grenade_properties:get(6) then
					slot7.delay = uv0.locations.builder.delay:get()
				end
			end
		else
			slot8 = slot0.movement_recorder.movement or nil
		end

		slot3.grenade = {
			jump = uv0.locations.builder.grenade_properties:get(1) or nil
		}
		slot3.movement = slot8 or slot3.movement

		if slot3.position and slot3.viewangles and slot3.weapon then
			slot0:get_map_locatons()
			slot0:clear_location_garbage(slot3)

			slot3.red_color = true

			if slot2 == 0 then
				slot0.map_locations[#slot0.map_locations + 1] = slot3
			end
		end
	end

	for slot29, slot30 in pairs(slot11.locations.builder) do
		slot30:set_callback(function ()
			uv0.locations:on_edit_location()
		end)
	end

	function slot12.locations.on_set_location(slot0)
		if not entity.get_local_player() then
			return
		end

		slot4, slot8.weapon, slot6 = uv0:get_weapon(slot1)
		slot7 = render.camera_angles()
		slot8 = slot0.edit_location.edited.location
		slot8.position = {
			slot1:get_origin():unpack()
		}
		slot8.viewangles = {
			slot7.x,
			slot7.y
		}
		slot8.duck = slot1.m_flDuckAmount == 1 or nil

		slot0:on_edit_location()
		slot0:on_edit_list()
	end

	slot11.locations.set_location:set_callback(function ()
		uv0.locations:on_set_location()
	end)

	function slot12.locations.on_teleport(slot0)
		if slot0.edit_location and slot0.edit_location.edited.location.position and slot1.viewangles and slot1.weapon then
			utils.console_exec(("noclip off; setpos_exact %s %s %s; setang %s %s; use %s"):format(slot1.position[1], slot1.position[2], slot1.position[3], slot1.viewangles[1], slot1.viewangles[2], slot1.weapon))
		end
	end

	slot11.locations.teleport:set_callback(function ()
		uv0.locations:on_teleport()
	end)

	function slot12.locations.on_save(slot0)
		if slot0.edit_location then
			slot1 = slot0.edit_location.edited
			slot4 = uv0:get_map()

			if slot1.location.position and slot3.viewangles and slot3.weapon then
				if slot1.index == 0 then
					if not slot0.edit_locations.data.locations[slot4] then
						slot0.edit_locations.data.locations[slot4] = {}
					end

					slot0.edit_locations.data.locations[slot4][#slot0.edit_locations.data.locations[slot4] + 1] = slot3
				end

				slot0.edit_location.original.location = slot0.edit_location.edited.location

				uv1()
				slot0:get_map_locatons()
				slot0:on_edit_list()
				slot0:on_locations_selection()
			end
		end
	end

	slot11.locations.save:set_callback(function ()
		uv0.locations:on_save()
	end)

	function slot12.locations.on_locations_selection(slot0)
		if slot0.on_have_changes then
			uv0()

			slot0.on_have_changes = false
		end

		uv1()
		slot0:on_edit()
		slot0:get_map_locatons()

		if slot1 == 0 or not (slot0.edit_locations.list.data[uv2.locations.locations_selection:get() - 1] or slot0.edit_locations.list.data[slot1 - 1]) then
			uv2.locations.builder.type:set("Grenade")
			uv2.locations.builder.from:set("")
			uv2.locations.builder.to:set("")
			uv2.locations.builder.description:set("")
			uv2.locations.builder.run_duration:set(0)
			uv2.locations.builder.run_direction:set("Forward")
			uv2.locations.builder.run_direction_custom:set(0)
			uv2.locations.builder.throw_strength:set("Left Click")
			uv2.locations.builder.recovery_direction:set("Forward")
			uv2.locations.builder.recovery_direction_custom:set(0)
			uv2.locations.builder.recovery_bannyhop:set(false)
			uv2.locations.builder.delay:set(0)
			uv2.locations.builder.grenade_properties:set({})

			slot0.edit_location = {
				edited = {
					index = 0,
					location = {}
				},
				original = {
					index = 0,
					location = {}
				}
			}
		else
			slot0.edit_location = {
				edited = slot2,
				original = uv3.copy(slot2)
			}

			uv2.locations.builder.type:set(slot0.edit_locations.data.locations[slot2.map][slot2.index].movement_data and "Movement" or "Grenade")
			uv2.locations.builder.from:set(#slot3.name == 2 and slot3.name[1] or "")
			uv2.locations.builder.to:set(#slot3.name == 2 and slot3.name[2] or slot3.name)
			uv2.locations.builder.description:set(slot3.description and slot3.description or "")

			slot4 = {}

			if slot3.grenade then
				if slot3.grenade.jump then
					slot4[#slot4 + 1] = "Jump"
				end

				if slot3.grenade.run then
					slot4[#slot4 + 1] = "Run"
				end

				if slot3.grenade.run_speed then
					slot4[#slot4 + 1] = "Walk (Shift)"
				end

				if slot3.grenade.strength then
					slot4[#slot4 + 1] = "Throw strength"
				end

				if slot3.grenade.recovery_yaw then
					slot4[#slot4 + 1] = "Force-enable recovery"
				end

				if slot3.grenade.delay then
					slot4[#slot4 + 1] = "Delayed throw"
				end

				uv2.locations.builder.run_duration:set(slot3.grenade.run or 0)
				uv2.locations.builder.run_direction:set(slot3.grenade.run_yaw and (uv4.yaw_directions_offsets[slot3.grenade.run_yaw] or "Custom") or "Forward")
				uv2.locations.builder.run_direction_custom:set(slot3.grenade.run_yaw or 0)
				uv2.locations.builder.throw_strength:set(uv4.strength_offsets[slot3.grenade.strength] or "Left Click")
				uv2.locations.builder.recovery_direction:set(slot3.grenade.recovery_yaw and (uv4.yaw_directions_offsets[slot3.grenade.recovery_yaw] or "Custom") or "Forward")
				uv2.locations.builder.recovery_direction_custom:set(slot3.grenade.recovery_yaw or 0)
				uv2.locations.builder.recovery_bannyhop:set(slot3.grenade.recovery_jump and true or false)
				uv2.locations.builder.delay:set(slot3.grenade.delay or 0)
				uv2.locations.builder.grenade_properties:set(slot4)
			end

			uv2.locations.builder.grenade_properties:set(slot4)
		end

		slot0.delete_state = {
			false,
			false
		}
	end

	slot11.locations.locations_selection:set_callback(function ()
		uv0.locations:on_locations_selection()
	end)

	slot12.weapons = {
		wallbangs = {
			weapon_deagle = true,
			weapon_scar20 = true,
			weapon_g3sg1 = true,
			weapon_awp = true,
			weapon_ssg08 = true
		},
		menu_names = {
			weapon_flashbang = "Flashbang",
			weapon_smokegrenade = "Smoke",
			weapon_wallbang = "Wallbang",
			weapon_knife_movement = "Movement",
			weapon_knife = "Movement",
			weapon_molotov = "Molotov",
			weapon_hegrenade = "High Explosive",
			weapon_decoy = "Decoy Grenade"
		}
	}

	function slot12.get_weapon(slot0, slot1)
		if not slot1:get_player_weapon(false) then
			return
		end

		if slot2:get_weapon_index() == 48 then
			slot3 = 46
		end

		slot4 = slot2:get_weapon_info()

		if slot4.is_revolver or slot0.weapons.wallbangs[slot4.weapon_name] then
			slot5 = "weapon_wallbang"
		end

		if slot5 == "weapon_incgrenade" then
			slot5 = "weapon_molotov"
		end

		return slot2, slot5, slot3, slot4
	end

	function slot12.rebuild_locations(slot0, slot1, slot2)
		for slot7, slot8 in pairs(slot1) do
			if 0 < slot7 then
				slot3 = slot7
			end
		end

		for slot7 = 1, slot3 do
			slot8 = slot1[slot7]
			slot9 = {
				[#slot9 + 1] = slot8
			}

			if slot8 and not slot8.text_offset and slot8.render_vector then
				for slot14 = slot7 + 1, slot3 do
					if slot1[slot14] and not slot15.text_offset and slot10:dist(slot15.render_vector) <= 20 then
						slot9[#slot9 + 1] = slot15
					end
				end

				slot11, slot12 = vector()

				for slot16, slot17 in pairs(slot9) do
					slot11 = slot11 + slot17.render_vector
					slot18 = #slot17.name == 2 and slot17.name[2] or slot17.name

					if not slot12 or render.measure_text(1, nil, slot12).x <= render.measure_text(1, nil, slot18).x then
						slot12 = slot18
					end
				end

				slot13 = #slot9

				for slot17, slot18 in pairs(slot9) do
					slot18.render_vector = slot11 / slot13
					slot18.text_offset = slot17 - 1
					slot18.icon_offset = slot13 - 1
					slot18.bestname = slot12

					if slot17 == 1 then
						slot18.show_icon = true
					end
				end
			end
		end
	end

	function slot12.normalize_angles()
		error("Decompilation failed")
		-- Exception in function building!
	end

	slot12.circle_colors = {
		COLOR_GREEN = color(20, 236, 0, 255),
		COLOR_ORANGE = color(255, 245, 5, 255),
		COLOR_RED = color(255, 10, 10, 255),
		COLOR_WHITE = color(140, 140, 140, 255)
	}
	slot12.bhop_png = [[
<?xml version='1.0' encoding='UTF-8' standalone='no'?>
<svg xmlns:svg='http://www.w3.org/2000/svg' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 158 200' height='200mm' width='158mm'>
    <g style='mix-blend-mode:normal'>
        <path d='m 27.692726,195.58287 c -2.00307,-2.00307 -2.362731,-5.63696 -1.252001,-12.64982 .51631,-3.25985 .938744,-6.15692 .938744,-6.43794 0,-.28102 -1.054647,-.68912 -2.343659,-.9069 -1.289012,-.21778 -2.343659,-.46749 -2.343659,-.55491 0,-.0874 .894568,-2.10761 1.987932,-4.48934 4.178194,-9.10153 7.386702,-22.1671 7.386702,-3.07983 v -3.57114 l -3.439063,-.65356 c -7.509422,-1.42712 -14.810239,-6.3854 -17.132592,-11.63547 -.617114,-1.39509 -1.6652612,-5.2594 -2.3292172,-8.58736 -.894299,-4.48252 -1.742757,-6.93351 -3.273486,-9.45625 -2.296839,-3.78538 -2.316583,-5.11371 -.151099,-1.165583 .632785,-1.47622 2.428356,-7.85932 3.990157,-14.18467 2.3650332,-9.578444 3.4874882,-12.902312 6.7157522,-19.887083 5.153317,-11.149867 5.357987,-11.987895 3.936721,-16.118875 -1.318135,-3.831228 -1.056436,-5.345174 1.69769,-9.821193 .98924,-1.607722 2.121218,-4.129295 2.515508,-5.6035 C 25.28429,28.210324 25.23258,27.949807 23.35135,24.502898 21.710552,21.496527 21.306782,19.993816 2.889474,15.340532 2.614927,12.279129 2.380889,8.4556505 2.369393,6.8439185 l -.02091,-2.930428 9.333915,.83216 9.333914,.832161 .415652,4.4356115 c .228605,2.439587 .232248,9.481725 .0081,15.649196 l -.407561,11.213581 3.401641,.387936 c 1.8709,.213363 4.456285,.528941 5.745297,.701283 l 2.343658,.31335 .01922,-4.58462 c .01523,-3.630049 .300834,-5.120017 1.371678,-7.156027 3.087768,-5.870826 9.893488,-1.61208 17.039741,-11.87087 2.720173,-.479148 4.160963,-.409507 7.136663,.344951 8.66897,2.197927 13.98192,9.621168 13.98192,19.535491 0,3.495649 -.1404,3.901096 -1.99211,5.752805 -1.24394,1.243942 -2.56423,1.992111 -3.51549,1.992111 -1.49731,0 -1.52337,.07107 -1.52337,4.153986 v 4.15399 l 8.9352,-.237138 c 5.2858,-.140285 11.170779,-.674802 14.408789,-1.308719 l 5.4736,-1.071577 -.38275,-2.552314 c -.37145,-2.476984 -.33603,-2.552315 1.19984,-2.552315 .87041,0 1.91062,-.448636 2.31157,-.996969 .68332,-.93449 1.27483,-.910186 9.43922,.387872 4.86768,.773912 12.32893,1.486871 16.91304,1.616118 4.51154,.127203 8.93123,.513358 9.82152,.858128 2.24255,.86843 2.71036,3.071333 1.03169,4.858196 -2.36272,2.515004 -4.22494,2.914196 -9.65444,2.069567 -6.49602,-1.010535 -9.48434,-.608226 -12.89073,1.735433 -1.51944,1.045409 -3.78166,2.037422 -5.02716,2.204478 -2.12756,.285364 -2.24441,.404325 -1.93193,1.966706 .54423,2.721143 -.2472,4.489222 -3.68173,8.225132 -3.77119,4.102112 -4.63155,5.89093 -5.49449,11.423793 -.94965,6.08886 -1.57396,7.52473 -5.32281,12.24226 -5.48499,6.90229 -11.865029,11.373083 -16.271159,11.401983 -2.96514,.0195 -5.44164,-1.427403 -1.64598,-6.219683 -6.09285,-5.61044 -11.509723,-9.58715 -13.059111,-9.58715 -.74413,0 -2.728788,1.56375 -5.069514,3.99435 -2.115662,2.19689 -4.279795,4.24027 -4.809188,4.54084 -.873942,.49619 -.888303,.97152 -.156034,5.16456 .443574,2.539953 1.213393,5.239093 1.710714,5.998093 1.234397,1.88393 4.464204,3.43033 1.249847,4.90755 11.894956,3.03704 24.227356,12.17082 28.700056,21.25618 3.277059,6.65665 3.756559,14.90456 1.06537,18.32585 -2.00495,2.54888 -4.71703,3.29933 -13.73034,3.79931 -12.02449,.66702 -11.43259,.30042 -25.191149,15.60203 -3.539415,3.93635 -4.947788,5.02545 -9.098134,7.03552 -6.030466,2.92066 -8.127669,5.18229 -9.759102,1.52427 -1.407053,4.60727 -3.889283,7.93618 -7.163048,9.60633 -3.066476,1.56439 -5.550268,1.48363 -7.270304,-.2364 z M 99.119321,71.201503 c 3.729129,-4.724307 6.662059,-8.707839 6.517599,-8.852305 -.14446,-.144451 -2.7777,1.571678 -5.851649,3.813635 -4.38891,3.20102 -6.56642,4.363275 -1.1411,5.412849 -2.50365,.73511 -4.68393,1.459682 -4.84506,1.610152 -.31664,.295703 6.47662,6.567603 7.13899,6.591103 .22054,.008 3.4521,-3.85113 7.18122,-8.575434 z' style='fill:#ffffff;fill-opacity:1;stroke:none;stroke-width:.585916;stroke-opacity:1' />
    </g>
</svg>
]]
	slot12.icons = {
		edit = render.load_image_from_file("materials\\panorama\\images\\icons\\ui\\edit.svg"),
		warning = render.load_image_from_file("materials\\panorama\\images\\icons\\ui\\warning.svg"),
		weapon_smokegrenade = render.load_image_from_file("materials\\panorama\\images\\icons\\equipment\\smokegrenade.svg"),
		weapon_flashbang = render.load_image_from_file("materials\\panorama\\images\\icons\\equipment\\flashbang.svg"),
		weapon_decoy = render.load_image_from_file("materials\\panorama\\images\\icons\\equipment\\decoy.svg"),
		weapon_hegrenade = render.load_image_from_file("materials\\panorama\\images\\icons\\equipment\\hegrenade.svg"),
		weapon_molotov = render.load_image_from_file("materials\\panorama\\images\\icons\\equipment\\molotov.svg"),
		weapon_knife_movement = render.load_image(slot12.bhop_png, vector(26, 26)),
		weapon_knife = render.load_image(slot12.bhop_png, vector(26, 26)),
		weapon_wallbang = render.load_image_from_file("materials\\panorama\\images\\icons\\ui\\bullet.svg")
	}

	function slot12.on_render_editing(slot0)
		slot2 = uv0.active_locations[slot0.locations.edit_locations.source_id]
		slot3 = slot0.locations:clear_location_garbage(uv1.copy(slot0.locations.edit_location.original.location))
		slot4 = slot0.locations:clear_location_garbage(uv1.copy(slot0.locations.edit_location.edited.location))
		slot3.movement = nil
		slot4.movement = nil
		slot3.movement_data = nil
		slot4.movement_data = nil
		slot8 = {}

		for slot12, slot13 in pairs(uv1.get_keys(slot4)) do
			slot14 = false
			slot15 = type(slot13) ~= "table" and tostring(slot13) or json.stringify(slot13)

			if not uv1.comparison(slot4, slot3) then
				slot14 = slot15 ~= (type(uv1.get_keys(slot3)[slot12]) ~= "table" and tostring(slot16) or json.stringify(slot16))
			end

			slot16 = uv2.highlight
			slot17 = slot15
			slot21 = slot14 and {
				209,
				42,
				62
			} or {
				96,
				160,
				220
			}

			for slot21 = 1, #slot16(slot17, slot14 and {
				244,
				147,
				134
			} or {
				221,
				221,
				221
			}, slot14 and {
				223,
				57,
				35
			} or {
				218,
				230,
				30
			}, slot14 and {
				209,
				42,
				62
			} or {
				180,
				230,
				30
			}, slot21) do
				slot22, slot23, slot24, slot25 = unpack(slot16[slot21])
				slot17 = "" .. string.format("%02X%02X%02XFF%s", slot22, slot23, slot24, slot25)
			end

			slot8[#slot8 + 1] = {
				slot12,
				slot17,
				slot14
			}
		end

		slot9 = {
			viewangles = "",
			name = "",
			weapon = "",
			position = ""
		}

		uv1.sort(slot8, function (slot0, slot1)
			return (uv0[slot0[1]] or slot0[1]) < (uv0[slot1[1]] or slot1[1])
		end)

		slot10 = {
			{
				"edit",
				255,
				255,
				255,
				220,
				" Editing Location:"
			}
		}

		for slot14, slot15 in pairs(slot8) do
			slot16, slot17, slot18 = unpack(slot15)
			slot10[#slot10 + 1] = {
				255,
				255,
				255,
				220,
				slot16 .. ": " .. slot17
			}
		end

		slot11 = false

		if slot0.weapons.menu_names[slot4.weapon or ""] then
			slot11 = uv3.customization.types:get(slot12)
		end

		if slot7 or not slot11 and slot12 or not slot2 then
			slot10[#slot10 + 1] = {
				255,
				255,
				255,
				255,
				" "
			}
		end

		if slot7 then
			slot10[#slot10 + 1] = {
				"warning",
				234,
				64,
				18,
				220,
				"You have unsaved changes! Make sure to click Save."
			}
		end

		if slot13 then
			slot10[#slot10 + 1] = {
				"warning",
				234,
				64,
				18,
				220,
				"Location not shown because type \"" .. slot12 .. "\" is not enabled."
			}
		end

		if not slot2 then
			slot10[#slot10 + 1] = {
				"warning",
				234,
				64,
				18,
				220,
				"Location not shown because source \"" .. uv0.locations[slot1].name .. "\" is not enabled."
			}
		end

		slot14 = 0
		slot15 = 0
		slot16 = {}

		for slot20, slot21 in pairs(slot10) do
			slot22 = type(slot21[1]) == "string"
			slot23 = render.measure_text(1, nil, select(slot22 and 6 or 5, unpack(slot21)))
			slot25 = slot23.y

			if slot22 then
				slot24 = slot23.x + 13
			end

			if slot14 < slot24 then
				slot14 = slot24
			end

			slot16[slot20] = slot15

			if slot20 == 1 then
				slot15 = slot15 + slot25 + 2
			end
		end

		slot17 = uv4.x / 2 - math.floor(slot14 / 2)
		slot18 = 140

		render.rect(vector(slot17 - 4, slot18 - 3), vector(slot17 - 4, slot18 - 3) + vector(slot14 + 8, slot15 + 6), color(16, 16, 16, 105))
		render.rect_outline(vector(slot17 - 5, slot18 - 4), vector(slot17 - 5, slot18 - 4) + vector(slot14 + 10, slot15 + 8), color(16, 16, 16, 120))
		render.rect_outline(vector(slot17 - 6, slot18 - 5), vector(slot17 - 6, slot18 - 5) + vector(slot14 + 12, slot15 + 10), color(16, 16, 16, 135))
		render.rect_outline(vector(slot17 - 7, slot18 - 6), vector(slot17 - 7, slot18 - 6) + vector(slot14 + 14, slot15 + 12), color(16, 16, 16, 28))

		slot22 = color
		slot23 = 255

		render.rect(vector(slot17 + 13, slot18), vector(slot17 + 13, slot18) + vector(1, 12), slot22(slot23, 255, 255, 255))

		for slot22, slot23 in pairs(slot10) do
			if type(slot23[1]) == "string" then
				slot25, slot26, slot27, slot28, slot29, slot30 = unpack(slot23)

				render.texture(slot0.icons[slot25], vector(slot17 - 2, slot18 + slot16[slot22]), vector(12, 12), color(slot26, slot27, slot28, 255))
				render.text(1, vector(slot17 + 13, slot18 + slot16[slot22]), color(slot26, slot27, slot28, slot29), nil, slot30)
			else
				slot25, slot26, slot27, slot28, slot29 = unpack(slot10[slot22])

				render.text(1, vector(slot17 - 2, slot18 + slot16[slot22]), color(slot25, slot26, slot27, slot28), nil, slot29)
			end
		end
	end

	function slot12.vector2_rotate(slot0, slot1, slot2)
		slot3 = math.sin(slot0)
		slot4 = math.cos(slot0)

		return slot1 * slot4 - slot2 * slot3, slot1 * slot3 + slot2 * slot4
	end

	function slot12.render_triangle(slot0, slot1, slot2, slot3, slot4, slot5, slot6)
		slot7, slot8 = slot0.vector2_rotate(slot5, slot3 / 2, 0)
		slot9, slot10 = slot0.vector2_rotate(slot5, 0, slot4)
		slot11, slot12 = slot0.vector2_rotate(slot5, slot3, slot4)
		slot13, slot14 = slot0.vector2_rotate(slot5, -slot3 / 2, -slot4 / 2)
		slot2 = slot2 + slot14
		slot1 = slot1 + slot13

		render.poly(slot6, vector(slot1 + slot7, slot2 + slot8), vector(slot1 + slot9, slot2 + slot10), vector(slot1 + slot11, slot2 + slot12))
	end

	slot12.native_GetWorldToScreenMatrix = utils.get_vfunc("engine.dll", "VEngineClient014", 37, "struct { float m[4][4]; } & (__thiscall*)(void*)")

	function slot12.world_to_screen_offscreen(slot0, slot1, slot2, slot3, slot4, slot5, slot6)
		slot4 = slot4 or slot0.native_GetWorldToScreenMatrix()
		slot10 = nil

		if slot4.m[3][0] * slot1 + slot4.m[3][1] * slot2 + slot4.m[3][2] * slot3 + slot4.m[3][3] < 0.001 then
			slot11 = -1 / slot9
			slot10 = false
			slot7 = (slot4.m[0][0] * slot1 + slot4.m[0][1] * slot2 + slot4.m[0][2] * slot3 + slot4.m[0][3]) * slot11
			slot8 = (slot4.m[1][0] * slot1 + slot4.m[1][1] * slot2 + slot4.m[1][2] * slot3 + slot4.m[1][3]) * slot11
		else
			slot11 = 1 / slot9
			slot10 = true
			slot7 = slot7 * slot11
			slot8 = slot8 * slot11
		end

		if type(slot7) ~= "number" or type(slot8) ~= "number" then
			return
		end

		return slot5 / 2 + 0.5 * slot7 * slot5 + 0.5, slot6 / 2 - (0.5 * slot8 * slot6 + 0.5), slot10, slot9
	end

	function slot12.line_intersection(slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
		slot8 = (slot0 - slot2) * (slot5 - slot7) - (slot1 - slot3) * (slot4 - slot6)
		slot9 = slot0 * slot3 - slot1 * slot2
		slot10 = slot4 * slot7 - slot5 * slot6

		return (slot9 * (slot4 - slot6) - (slot0 - slot2) * slot10) / slot8, (slot9 * (slot5 - slot7) - (slot1 - slot3) * slot10) / slot8
	end

	function slot12.world_to_screen(slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
		slot8, slot9, slot10 = slot0:world_to_screen_offscreen(slot1, slot2, slot3, slot4, slot5, slot6)

		if slot8 == nil then
			return
		end

		if not slot10 or slot8 < slot7 or slot8 > slot5 - slot7 or slot9 < slot7 or slot9 > slot6 - slot7 then
			slot11 = slot5 / 2
			slot12 = slot6 / 2

			if not slot10 then
				slot13 = math.atan2(slot9 - slot12, slot8 - slot11)
				slot14 = math.max(slot5, slot6)
				slot8 = slot11 + slot14 * math.cos(slot13)
				slot9 = slot12 + slot14 * math.sin(slot13)
			end

			for slot17 = 1, #{
				slot7,
				slot7,
				slot5 - slot7,
				slot7,
				slot5 - slot7,
				slot7,
				slot5 - slot7,
				slot6 - slot7,
				slot7,
				slot7,
				slot7,
				slot6 - slot7,
				slot7,
				slot6 - slot7,
				slot5 - slot7,
				slot6 - slot7
			}, 4 do
				slot22, slot23 = slot0.line_intersection(slot13[slot17], slot13[slot17 + 1], slot13[slot17 + 2], slot13[slot17 + 3], slot11, slot12, slot8, slot9)

				if slot17 == 1 and slot9 < slot7 and slot7 <= slot22 and slot22 <= slot5 - slot7 or slot17 == 5 and slot8 > slot5 - slot7 and slot7 <= slot23 and slot23 <= slot6 - slot7 or slot17 == 9 and slot8 < slot7 and slot7 <= slot23 and slot23 <= slot6 - slot7 or slot17 == 13 and slot9 > slot6 - slot7 and slot7 <= slot22 and slot22 <= slot5 - slot7 then
					return vector(slot22, slot23), false
				end
			end

			return vector(slot8, slot9), false
		end

		return vector(slot8, slot9), true
	end

	slot12.angles_locations = {}
	slot12.weapon_locations_in_range = {}

	function slot12.on_render(slot0)
		if not entity.get_local_player() then
			slot0.weapon_locations = nil

			return
		end

		if uv0.locations.edit_mode then
			slot0:on_render_editing()
		end

		slot3 = math.max(40, uv0.customization.color:get().a) / 255
		slot4 = uv0.customization.show_locations_behind_walls:get()
		slot5 = uv0.customization.types:get()
		slot6 = uv0.settings.fov:get() * 0.5
		slot7 = uv0.settings.aimbot_mode:get()
		slot8 = render.get_scale(2)
		slot9 = slot1:get_origin()
		slot10, slot11, slot12 = slot0:get_weapon(slot1)
		slot14 = render.camera_position()
		slot16 = vector():angles(render.camera_angles()) * 20
		slot0.target_location = nil
		slot17 = false

		if slot0.weapons.menu_names[slot11] then
			slot17 = uv0.customization.types:get(slot18)
		end

		if not slot17 then
			slot0.weapon_locations = nil

			return
		end

		if slot0.weapon_prev ~= slot11 then
			slot0.weapon_locations = nil
			slot0.weapon_prev = slot11
		end

		slot20 = globals.realtime
		slot21 = globals.frametime
		slot22 = globals.curtime

		if not slot0.weapon_locations then
			slot0.weapon_locations = {}
			slot0.weapon_locations_in_range = {}
			slot0.last_vischeck = 0

			for slot26, slot27 in pairs(slot0.locations.map_locations) do
				slot27.visible_alpha = 0
				slot27.distance_alpha = 0
				slot27.distance_width_mp = 0
				slot27.in_range_draw_mp = 0

				if not slot27.vector then
					slot27.vector = vector(slot27.position[1], slot27.position[2], slot27.position[3])
					slot27.render_vector = vector(slot27.position[1], slot27.position[2], slot27.position[3])
				end

				if slot27.weapon == "weapon_knife_movement" then
					slot27.weapon = "weapon_knife"
				end

				if slot28 == slot11 then
					slot0.weapon_locations[#slot0.weapon_locations + 1] = slot27
				end
			end

			slot0:rebuild_locations(slot0.weapon_locations, slot11)
		else
			if slot20 > slot0.last_vischeck + 0.25 then
				slot0.angles_locations = {}
				slot0.weapon_locations_in_range = {}
				slot0.last_vischeck = slot20

				for slot26, slot27 in pairs(slot0.weapon_locations) do
					if not slot27.vector then
						slot27.vector = vector(slot27.position[1], slot27.position[2], slot27.position[3])
						slot27.render_vector = vector(slot27.position[1], slot27.position[2], slot27.position[3])
					end

					slot27.distance = slot9:dist(slot27.render_vector)
					slot27.original_distance = slot9:dist(vector(slot27.position[1], slot27.position[2], slot27.position[3]))
					slot27.in_range = slot27.distance <= 1500

					if slot27.in_range then
						slot27.is_visible = utils.trace_line(slot14, slot27.render_vector, slot1, 33570827).fraction > 0.97
						slot27.in_range_text = slot27.distance <= 650
						slot0.weapon_locations_in_range[#slot0.weapon_locations_in_range + 1] = slot27

						if slot27.distance <= 30 then
							slot0.angles_locations[#slot0.angles_locations + 1] = slot27
						else
							slot27.in_range_draw_mp = 0
						end
					else
						slot27.distance_alpha = 0
						slot27.in_range_text = false
						slot27.distance_width_mp = 0
					end
				end
			end

			if #slot0.weapon_locations_in_range == 0 then
				return
			end

			uv1.sort(slot0.angles_locations, function (slot0, slot1)
				slot2, slot3 = uv0.normalize_angles(uv1.x - slot0.viewangles[1], uv1.y - slot0.viewangles[2])
				slot4, slot5 = uv0.normalize_angles(uv1.x - slot1.viewangles[1], uv1.y - slot1.viewangles[2])

				return math.sqrt(slot2 * slot2 + slot3 * slot3) < math.sqrt(slot4 * slot4 + slot5 * slot5)
			end)

			slot0.location_closest = nil
			slot0.target_location = slot0.angles_locations[1]

			for slot26, slot27 in pairs(slot0.weapon_locations_in_range) do
				if not slot0.location_closest or slot27.distance < slot0.location_closest.distance then
					slot0.location_closest = slot27
				end
			end

			slot24 = 1

			if slot0.playback.location then
				slot0.location_closest = slot23
				slot24 = 1
			elseif slot0.location_closest.distance <= 30 then
				slot24 = 0.4 + uv2.quad_in_out(slot0.location_closest.distance, 0, 0.6, 30)
			else
				slot0.location_closest = nil
			end

			for slot28, slot29 in pairs(slot0.weapon_locations_in_range) do
				slot30 = math.clamp(slot8 - 0.1, 1, 1.65)
				slot29.distance_alpha = slot23 == slot29 and 1 or uv2.quart_out(1 - slot29.distance / 1500, 0, 1, 1)

				if slot29.in_range_text and (slot24 > 0.5 or slot29.render_vector == (slot0.location_closest and slot0.location_closest.render_vector or 0)) and slot29.distance_width_mp < 1 then
					slot29.distance_width_mp = math.min(1, slot29.distance_width_mp + slot21 * 7.5)
				elseif not slot32 and slot29.distance_width_mp > 0 then
					slot29.distance_width_mp = math.max(0, slot29.distance_width_mp - slot21 * 7.5)
				end

				slot33 = uv2.quad_in_out(slot29.distance_width_mp, 0, 1, 1)

				if slot29.is_visible and slot29.visible_alpha < 1 or slot29.visible_alpha < (slot4 and slot29.distance_width_mp > 0 and 0.45 or 0) then
					slot29.visible_alpha = math.min(1, slot29.visible_alpha + slot21 * 5.5 * (slot4 and slot29.distance_width_mp > 0 and not slot29.is_visible and 0.33 or 1))
				elseif not slot29.is_visible and slot34 < slot29.visible_alpha then
					slot29.visible_alpha = math.max(slot34, slot29.visible_alpha - slot21 * 7.5 * slot35)
				end

				if uv2.sine_in_out(slot29.visible_alpha, 0, 1, 1) * (slot31 and 1 or slot24) * slot29.distance_alpha > 0 then
					slot38 = slot2:alpha_modulate(slot36 * 255 * slot3)

					if slot29.red_color then
						slot38 = color(255, 16, 16, slot37)
					end

					if (slot29.render_vector + vector(0, 0, 12)):to_screen() and (slot39 + slot16):to_screen() then
						slot42 = #slot29.name == 2 and slot29.name[2] or slot29.name
						slot43 = slot29.weapon
						slot45 = render.measure_text(1, "s", slot29.bestname)
						slot48 = slot45.x

						if slot29.distance_width_mp < 1 then
							slot53 = 1
							slot47 = math.max(slot45.y - 1, slot47 * math.min(slot53, slot29.distance_width_mp * 1))

							for slot53 = slot42:len(), 0, -1 do
								if render.measure_text(1, "s", slot42:sub(1, slot53)).x <= slot46 * slot29.distance_width_mp then
									slot42 = slot54
									slot48 = slot55

									break
								end
							end
						end

						slot50 = slot46 / slot45.x * 11 * slot30
						slot51 = (slot29.text_offset or 0) * slot50
						slot52 = (slot29.icon_offset or 0) * slot50
						slot54 = nil

						if slot0.icons[slot43] then
							slot54 = vector(slot53.width, slot53.height) / 2.35 + (slot52 == 0 and math.floor(math.min(22, math.max(17, slot47 + 2, math.abs(slot41.y - slot40.y)))) - 17 or 5)
						end

						slot56 = slot49
						slot57 = math.floor(slot41.x - slot46 / 2)
						slot58 = math.floor(slot40.y - ((not slot53 or math.max(slot52 == 0 and slot54.y or slot47, slot47)) and math.max(10, slot47)))

						if slot29.show_icon then
							render.rect(vector(slot57 - 2, slot58 - slot52 - 2), vector(slot57 - 2 + slot55 + 4, slot58 - 2 + slot56 + 4), color(16, 16, 16, 180 * slot36 * slot3))
							render.rect_outline(vector(slot57 - 3, slot58 - slot52 - 3), vector(slot57 - 3 + slot55 + 6, slot58 - 3 + slot56 + 6), color(16, 16, 16, 170 * slot36 * slot3))
							render.rect_outline(vector(slot57 - 4, slot58 - slot52 - 4), vector(slot57 - 4 + slot55 + 8, slot58 - 4 + slot56 + 8), color(16, 16, 16, 195 * slot36 * slot3))
							render.rect_outline(vector(slot57 - 5, slot58 - slot52 - 5), vector(slot57 - 5 + slot55 + 10, slot58 - 5 + slot56 + 10), color(16, 16, 16, 40 * slot36 * slot3))

							if slot53 then
								render.texture(slot53, vector(slot57 - (slot43 == "weapon_knife" and -1 or 0), slot58 - slot52 / 2 - ((slot43 == "weapon_knife" or slot43 == "weapon_wallbang") and 0 or 1) - (slot52 == 0 and 0 or 4 * (2.1 - math.clamp(slot30 + 0.1, 1, 2)))), slot54, slot38)

								if slot29.distance_width_mp > 0 then
									render.rect(vector(slot57 + slot54.x + 4, slot58 - slot52 + 1), vector(slot57 + slot54.x + 5, slot58 + 2 + slot56 - 3), slot38)
								end
							end
						end

						if slot29.distance_width_mp > 0 then
							if slot47 < slot56 then
								slot58 = slot58 + math.floor((slot56 - slot47) / 2)
							end

							render.text(1, vector(slot57 + (not slot53 and 0 or slot54.x + 8), slot58 - slot51 - 1), slot38, "s", slot42)
						end
					end
				end
			end

			slot25 = slot0.native_GetWorldToScreenMatrix()
			slot26 = slot7 == "Rage" and slot0.circle_colors.COLOR_ORANGE or slot0.circle_colors.COLOR_RED

			for slot30, slot31 in pairs(slot0.angles_locations) do
				if not slot31.on_fov_color or not slot31.in_fov_select_mp or not slot31.offscreen_offset then
					slot31.on_fov_color = 0
					slot31.in_fov_select_mp = 0
					slot31.offscreen_offset = 0
				end

				slot32 = slot0.target_location.viewangles == slot31.viewangles
				slot34 = vector(slot31.position[1], slot31.position[2], slot31.position[3] + 64) + vector():angles(slot31.viewangles[1], slot31.viewangles[2]) * 700
				slot35, slot36 = slot0:world_to_screen(slot34.x, slot34.y, slot34.z, slot25, uv3.x, uv3.y, 40)

				if slot35 then
					slot39 = render.measure_text(1, "s", "»" .. (#slot31.name == 2 and slot31.name[2] or slot31.name))
					slot40 = vector()

					if slot31.description then
						slot40 = render.measure_text(2, "s", slot38:upper():gsub(" ", "  "))
					end

					slot41 = slot40.y / 2
					slot45 = 0
					slot47 = slot35.y - (slot39.y + slot40.y) / 2

					if slot35.x - slot39.y / 2 / 2 - (slot41 - slot41 % 2) / 2 > uv3.x - math.max(slot39.x, slot40.x) - 20 then
						slot46 = uv3.x - slot42 - 20
						slot36 = false
					end

					slot31.offscreen_offset = slot36 and math.max(0, slot31.offscreen_offset - slot21 * 6) or math.min(1, slot31.offscreen_offset + slot21 * 6)
					slot51 = slot2:alpha_modulate(math.max(0.5, 1 - slot31.offscreen_offset) * 255 * slot3)

					if slot31.red_color then
						slot51 = color(255, 16, 16, slot50)
					end

					if slot48 > 0 then
						slot42 = slot42 + math.floor((slot44 + 8 * slot8) * slot48) + slot41
					end

					render.rect(vector(slot46 - 3, slot47 - 2), vector(slot46 - 2 + slot42 + 5, slot47 - 2 + slot43 + 4), color(16, 16, 16, 150 * slot49 * slot3))
					render.rect_outline(vector(slot46 - 4, slot47 - 3), vector(slot46 - 3 + slot42 + 7, slot47 - 3 + slot43 + 6), color(16, 16, 16, 170 * slot49 * slot3))
					render.rect_outline(vector(slot46 - 5, slot47 - 4), vector(slot46 - 4 + slot42 + 9, slot47 - 4 + slot43 + 8), color(16, 16, 16, 195 * slot49 * slot3))
					render.rect_outline(vector(slot46 - 6, slot47 - 5), vector(slot46 - 5 + slot42 + 10, slot47 - 4 + slot43 + 9), color(16, 16, 16, 40 * slot49 * slot3))

					if slot45 > 1 then
						render.rect(vector(slot46 + slot45 - 4 * slot8, slot47 + 1), vector(slot46 + slot45 - 4 * slot8 + 1, slot47 + slot43 - 1), slot51:alpha_modulate(255 * (1 - slot31.offscreen_offset) * slot3))
					end

					render.text(1, vector(slot46 + slot45, slot47), slot51, "s", slot37)
					render.text(1, vector(slot46 + slot45 + 1, slot47), slot51:alpha_modulate(slot51.a * 0.6), "s", slot37)

					if slot38 then
						render.text(2, vector(slot46 + slot45, slot47 + slot39.y - 1), slot51, "s", slot38)
					end

					slot53, slot54 = slot0.normalize_angles(slot13.x - slot0.target_location.viewangles[1], slot13.y - slot0.target_location.viewangles[2])
					slot31.on_fov = math.sqrt(slot53 * slot53 + slot54 * slot54) <= (slot7 == "Rage" and slot6 or 0.3)
					slot56 = slot31.original_distance <= 2 and slot32 and slot31.on_fov and 3 or slot32 and 2 or 1
					slot31.on_fov_color = slot56 == 2 and slot56 ~= 1 and math.max(0, slot31.on_fov_color - slot21 * 4) or math.min(1, slot31.on_fov_color + slot21 * 4)
					slot31.in_fov_select_mp = slot56 == 1 and math.max(0, slot31.in_fov_select_mp - slot21 * 4) or math.min(1, slot31.in_fov_select_mp + slot21 * 4)
					slot44 = slot44 * 0.8

					render.circle_outline(slot35, color(16, 16, 16, 150 * slot52), slot44 + 1, 0, 1, 2)
					render.circle(slot35, slot0.circle_colors.COLOR_WHITE:lerp(slot26:lerp(slot0.circle_colors.COLOR_GREEN, slot31.on_fov_color), slot31.in_fov_select_mp):alpha_modulate(255 * slot52), slot44, 0, 1)
					render.circle_outline(slot35, color(16, 16, 16, 75 * slot52), slot44 + 1, 0, 1, 2)
					render.circle_outline(slot35, color(16, 16, 16, 50 * slot52), slot44, 0, 1, 2)
					render.circle_outline(slot35, color(16, 16, 16, 25 * slot52), slot44 - 1, 0, 1, 2)

					if slot31 == slot23 then
						render.circle(slot35, color(math.min(255, slot51.r * 1.2), math.min(255, slot51.g * 1.2), math.min(255, slot51.b * 1.2), slot51.a), slot44, 0, 1)
					end

					if not slot36 then
						slot59 = math.atan2(slot35.y - uv4.y, slot35.x - uv4.x) + math.rad(90)
						slot60, slot61 = slot0.vector2_rotate(slot59, 0, -uv4.y + 100)
						slot62 = 18

						slot0:render_triangle(uv4.x + slot60, uv4.y + slot61, slot62 * 1.66, slot62, slot59, slot51:alpha_modulate(math.sin(math.abs(-math.pi + slot22 * 1.5 % 6)) * 255))
					end
				end
			end
		end
	end

	slot12.playback = {
		sensitivity = {}
	}
	slot12.playback.sensitivity.cvar = cvar.sensitivity
	slot12.playback.sensitivity.value = slot12.playback.sensitivity.cvar:float()
	slot12.playback.sensitivity.get = true

	function slot12.playback.sensitivity.override_sensitivity(slot0)
		if slot0.override then
			if slot0.get then
				slot0.value = slot0.cvar:float()
				slot0.get = false
			end

			if not slot0.get and slot0.cvar:int() ~= 0 then
				slot0.cvar:float(0)
			end
		else
			if not slot0.get then
				slot0.get = true
			end

			if slot0.get and slot1 ~= slot0.value then
				slot0.cvar:float(slot0.value)
			end
		end
	end

	function slot12.playback.remove_user_input(slot0)
		slot0.in_forward = 0
		slot0.in_back = 0
		slot0.in_moveleft = 0
		slot0.in_moveright = 0
		slot0.forwardmove = 0
		slot0.sidemove = 0
		slot0.in_jump = 0
		slot0.in_speed = 0
	end

	function slot12.playback.is_grenade_being_thrown(slot0)
		if slot0 and not slot0.m_bPinPulled then
			return slot0.m_fThrowTime > 0
		end

		return false
	end

	slot12.playback.buttons = {
		in_jump = "J",
		in_attack2 = "Z",
		U = "in_use",
		S = "in_speed",
		in_speed = "S",
		in_use = "U",
		in_attack = "A",
		in_duck = "D",
		in_back = "B",
		in_moveright = "R",
		in_moveleft = "L",
		in_forward = "F",
		D = "in_duck",
		J = "in_jump",
		Z = "in_attack2",
		A = "in_attack",
		B = "in_back",
		R = "in_moveright",
		L = "in_moveleft",
		F = "in_forward"
	}

	function slot12.playback.parse_buttons(slot0, slot1)
		slot2 = {}
		slot3 = {}

		for slot7 in slot1:gmatch(".") do
			if slot7:lower() == slot7 then
				slot3[#slot3 + 1] = slot0.buttons[slot7:upper()] or false
			else
				slot2[#slot2 + 1] = slot0.buttons[slot7] or false
			end
		end

		return slot2, slot3
	end

	function slot12.playback.grenade(slot0, slot1, slot2, slot3, slot4)
		slot5 = slot0.location

		if not slot0.data then
			slot0.data = {}
		end

		if not slot0.data.state then
			slot0.data.state = 1
		end

		slot6 = render.camera_angles()
		slot8 = slot5.viewangles

		if uv0.settings.aimbot_mode:get() == "Rage" then
			slot1.view_angles.x = slot8[1]
			slot1.view_angles.y = slot8[2]
			slot1.view_angles.z = 0
		elseif slot0.data.state ~= 5 then
			slot0.sensitivity.override = true

			render.camera_angles(vector(slot8[1], slot8[2], 0))
		end

		if slot0.data.state == 1 or slot0.data.state == 2 or slot0.data.state == 4 then
			if (slot5.grenade and slot5.grenade.strength or 1) == 0 then
				slot1.in_attack = false
				slot1.in_attack2 = true
			elseif slot9 == 0.5 then
				slot1.in_attack = true
				slot1.in_attack2 = true
			else
				slot1.in_attack = true
				slot1.in_attack2 = false
			end
		end

		slot10 = slot5.duck or false

		if slot0.data.state ~= 5 then
			if slot4 ~= slot5.weapon then
				slot0.location = nil
				slot0.data = {}
			end

			slot0.remove_user_input(slot1)

			slot1.in_duck = slot10
		end

		slot11 = slot2.m_flDuckAmount

		if slot10 and slot11 ~= 1 or not slot10 and slot11 ~= 0 then
			return
		end

		if slot0.data.state == 1 and slot3.m_flThrowStrength == slot9 and slot3.m_bPinPulled then
			slot0.data.state = 2
			slot0.data.start_at = slot1.command_number
		end

		if slot0.data.state == 5 then
			if slot0.data.recovery_yaw then
				if not slot0.data.recovery_start_at then
					slot0.data.recovery_start_at = slot1.command_number
				end

				if not slot1.in_forward and not slot1.in_back and not slot1.in_moveleft then
					slot12 = slot1.in_moveright
				end

				slot13 = math.min(32, slot0.data.run or 16) + 13 + (slot5.grenade and slot5.grenade.recovery_jump and 10 or 0)

				if slot1.command_number - slot0.data.recovery_start_at >= 1e-10 or slot12 then
					uv0.refs.air_strafe:override(true)
				end

				if slot12 then
					slot0.location = nil
					slot0.data = {}
				elseif slot1.command_number <= slot0.data.recovery_start_at + slot13 then
					slot0.remove_user_input(slot1)

					slot1.move_yaw = slot1.view_angles.y + slot0.data.recovery_yaw + slot0.data.run_yaw
					slot1.forwardmove = 450

					if slot5.grenade and slot5.grenade.recovery_jump then
						slot1.in_jump = true
					end
				else
					slot0.location = nil
					slot0.data = {}
				end
			else
				slot0.location = nil
				slot0.data = {}
			end
		end

		slot12 = slot2.m_MoveType == 9

		if slot0.data.state == 2 or slot0.data.state == 3 or slot0.data.state == 4 then
			slot0.data.run = slot5.grenade and slot5.grenade.run

			if slot0.data.run and slot1.command_number - slot0.data.start_at < slot0.data.run then
				-- Nothing
			elseif slot0.data.state == 2 then
				slot0.data.state = 3
			end

			slot0.data.run_yaw = slot5.grenade and slot5.grenade.run_yaw or 0

			if slot0.data.run then
				if slot12 then
					if slot0.data.run_yaw == -90 then
						slot1.in_moveright = 1
					elseif slot0.data.run_yaw == 90 then
						slot1.in_moveleft = 1
					elseif slot0.data.run_yaw == 180 or slot0.data.run_yaw == -180 then
						slot1.in_back = 1
					else
						slot1.in_forward = 1
					end
				else
					slot1.move_yaw = slot1.view_angles.y + slot0.data.run_yaw
					slot1.forwardmove = 450
					slot1.in_forward = 1
				end

				slot1.in_speed = slot5.grenade and slot5.grenade.run_speed and 1 or 0
			end
		end

		if slot0.data.state == 3 then
			if slot5.grenade and slot5.grenade.jump then
				slot1.in_jump = true
			end

			slot0.data.state = 4
			slot0.data.throw_at = slot1.command_number
		end

		if slot0.data.state == 4 then
			slot13 = rage.exploit:get() == 1

			if slot13 and uv0.refs.doubletap:get() or slot13 and uv0.refs.hideshots.enabled:get() and uv0.refs.hideshots.lag_options:get() == "Break LC" then
				slot16 = (slot5.grenade and slot5.grenade.delay or 0) + 6
			end

			if slot16 <= slot1.command_number - slot0.data.throw_at then
				slot1.in_attack = false
				slot1.in_attack2 = false
				slot0.data.recovery_yaw = slot5.grenade and slot5.grenade.recovery_yaw and slot5.grenade.recovery_yaw or slot5.grenade and (slot5.grenade.recovery_jump or slot5.grenade.jump) and 180
			end
		end

		if slot0.data.state == 4 then
			if slot0.is_grenade_being_thrown(slot3) then
				slot0.data.thrown_at = slot1.command_number
			end

			if slot3.m_fThrowTime == 0 and slot0.data.thrown_at and slot0.data.throw_at < slot0.data.thrown_at then
				slot0.data.state = 5
			end
		end
	end

	function slot12.playback.g_movement(slot0, slot1, slot2)
		slot3 = slot0.location

		if not slot0.data then
			slot0.data = {}
		end

		if not slot0.data.frames then
			slot0.data.frames = {}

			for slot7, slot8 in ipairs(slot3.movement.frames) do
				if type(slot8) == "number" then
					if slot3.movement.frames[slot7] > 0 then
						for slot12 = 1, slot8 do
							slot0.data.frames[#slot0.data.frames + 1] = {}
						end
					end
				elseif type(slot8) == "table" then
					slot0.data.frames[#slot0.data.frames + 1] = slot8
				end
			end

			for slot8, slot9 in pairs(slot0.buttons) do
				({
					viewangles = {
						pitch = slot3.viewangles[1],
						yaw = slot3.viewangles[2]
					},
					buttons = {}
				}).buttons[slot8] = false
			end

			for slot8, slot9 in ipairs(slot0.data.frames) do
				slot10, slot11, slot12, slot13, slot14 = unpack(slot9)
				slot4.viewangles.pitch = slot4.viewangles.pitch + (slot10 or 0)
				slot4.viewangles.yaw = slot4.viewangles.yaw + (slot11 or 0)

				if type(slot12) == "string" then
					slot15, slot16 = slot0:parse_buttons(slot12)

					for slot20, slot21 in ipairs(slot15) do
						slot4.buttons[slot21] = true
					end

					for slot20, slot21 in ipairs(slot16) do
						slot4.buttons[slot21] = false
					end
				end

				slot4.forwardmove = type(slot13) == "number" and slot13 >= -450 and slot13 <= 450 and slot13 or slot4.buttons.in_forward and 450 or slot4.buttons.in_back and -450 or 0
				slot4.sidemove = type(slot14) == "number" and slot14 >= -450 and slot14 <= 450 and slot14 or slot4.buttons.in_moveright and 450 or slot4.buttons.in_moveleft and -450 or 0
				slot0.data.frames[slot8] = {
					pitch = slot4.viewangles.pitch,
					yaw = slot4.viewangles.yaw,
					move_yaw = slot4.viewangles.yaw,
					forwardmove = slot4.forwardmove,
					sidemove = slot4.sidemove
				}

				for slot18, slot19 in pairs(slot4.buttons) do
					slot0.data.frames[slot8][slot18] = slot19
				end
			end
		end

		if not slot0.data.start_at then
			slot0.data.start_at = slot1.command_number
		end

		if not slot0.data.frames[slot1.command_number - slot0.data.start_at + 1] then
			slot0.location = nil
			slot0.data = {}

			return
		end

		if uv0.settings.aimbot_mode:get() == "Rage" then
			slot1.view_angles.x = slot5.pitch
			slot1.view_angles.y = slot5.yaw
			slot1.view_angles.z = 0
		else
			slot0.sensitivity.override = true

			render.camera_angles(vector(slot5.pitch, slot5.yaw, 0))
		end

		slot1.in_attack = slot5.in_attack
		slot1.in_attack2 = slot5.in_attack2
		slot1.move_yaw = slot5.move_yaw
		slot1.forwardmove = slot5.forwardmove
		slot1.sidemove = slot5.sidemove
		slot1.in_speed = slot5.in_speed
		slot1.in_duck = slot5.in_duck
		slot1.in_use = slot5.in_use
		slot1.in_jump = slot5.in_jump
	end

	function slot12.playback.movement(slot0, slot1)
		slot2 = slot0.location

		if not slot0.data then
			slot0.data = {}
		end

		if not slot0.data.start_at then
			slot0.data.start_at = slot1.command_number
		end

		if not slot2.movement.steps[slot1.command_number - slot0.data.start_at + 1] then
			slot0.location = nil
			slot0.data = {}

			return
		end

		uv0.refs.air_duck:override(false)
		uv0.refs.air_strafe:override()
		uv0.refs.strafe_assist:override(true)

		if slot2.strafer then
			uv0.refs.quick_stop:override(slot2.strafer.quick_stop)
			uv0.refs.air_strafe:override(slot2.strafer.air_strafe)
			uv0.refs.strafer_wasd:override(slot2.strafer.wasd_strafer)
			uv0.refs.strafer_smoothing:override(slot2.strafer.strafer_smoothing)
		end

		if uv0.settings.aimbot_mode:get() == "Rage" then
			slot1.view_angles.x = slot3.viewangles[1]
			slot1.view_angles.y = slot3.viewangles[2]
			slot1.view_angles.z = 0
		else
			slot0.sensitivity.override = true

			render.camera_angles(vector(slot3.viewangles[1], slot3.viewangles[2], 0))
		end

		slot1.move_yaw = slot3.move_yaw

		if slot3.forwardmove then
			slot1.forwardmove = slot5
		end

		if slot3.sidemove then
			slot1.sidemove = slot6
		end

		if slot3.buttons then
			slot1.in_attack = slot7.in_attack or false
			slot1.in_attack2 = slot7.in_attack2 or false
			slot1.in_forward = slot7.in_forward or false
			slot1.in_moveleft = slot7.in_moveleft or false
			slot1.in_moveright = slot7.in_moveright or false
			slot1.in_back = slot7.in_back or false
			slot1.in_speed = slot7.in_speed or false
			slot1.in_duck = slot7.in_duck or false
			slot1.in_use = slot7.in_use or false
			slot1.in_jump = slot7.in_jump or false
		end

		slot1.weaponselect = slot3.weaponselect or 0
	end

	function slot12.on_createmove(slot0, slot1)
		if not entity.get_local_player() then
			slot0.playback.location = nil
			slot0.playback.data = {}

			return
		end

		slot3 = uv0.settings.aimbot_mode:get()
		slot4 = uv0.settings.fov:get()
		slot5 = uv0.settings.smooth:get() / 10

		rage.exploit:allow_charge(true)
		uv0.refs.extended_angles:override()
		uv0.refs.slow_walk:override()
		uv0.refs.fake_duck:override()
		uv0.refs.air_duck:override()
		uv0.refs.air_strafe:override()
		uv0.refs.quick_stop:override()
		uv0.refs.strafer_wasd:override()
		uv0.refs.strafer_smoothing:override()
		uv0.refs.strafe_assist:override()
		slot0.playback.sensitivity:override_sensitivity()

		slot0.playback.sensitivity.override = false

		if uv0.refs.fake_duck:get() then
			slot0.playback.location = nil
			slot0.playback.data = {}

			return
		end

		slot6, slot7, slot8, slot9 = slot0:get_weapon(slot2)
		slot10 = slot2:get_origin()
		slot11 = render.camera_angles()
		slot12 = slot2.m_vecAbsVelocity:length2d()
		slot13 = slot2.m_flDuckAmount
		slot16 = slot1.in_forward or slot1.in_back or slot1.in_moveleft or slot1.in_moveright or slot1.in_jump or not (slot2.m_MoveType == 9) and not (bit.band(slot2.m_fFlags, 1) == 1)

		if not uv0.settings.hotkey:get() then
			slot0.playback.location = nil
			slot0.playback.data = {}

			return
		end

		if slot0.target_location and not slot0.playback.location then
			if not (vector(slot18.position[1], slot18.position[2], slot18.position[3]):dist2d(slot10) < (slot15 and 0.45 or 0.05)) and not slot16 then
				slot1.jitter_move = false

				uv0.refs.extended_angles:override(false)
				uv0.refs.slow_walk:override(false)

				slot23 = (slot19 - slot10):angles()
				slot1.in_moveright = 0
				slot1.in_moveleft = 0
				slot1.sidemove = 0

				if slot15 then
					slot25 = slot19.y - slot10.y
					slot27 = slot25 > 0.5 or slot25 < -0.5

					if slot19.z - slot10.z > 0.5 or slot24 < -0.5 then
						slot1.buttons = slot24 > 0 and bit.bor(slot1.buttons, 8) or bit.bor(slot1.buttons, 16)
					end

					if slot27 then
						slot1.buttons = slot25 > 0 and bit.bor(slot1.buttons, 512) or bit.bor(slot1.buttons, 1024)
					end

					if slot26 or slot27 then
						slot1.in_speed = 1
						slot1.in_duck = 1
					end
				else
					slot1.move_yaw = slot23.y
					slot1.in_speed = 0

					if slot20 > 10 then
						slot1.forwardmove = 450
					elseif slot12 >= math.min(250, math.min(450, math.max(3, slot20 * 9))) + 15 then
						slot1.forwardmove = 0
						slot1.in_forward = 0
					else
						slot1.forwardmove = slot24
						slot1.in_forward = 1
					end

					if slot13 > 0 then
						slot1.forwardmove = slot1.forwardmove * 2.93 * slot13
					end
				end
			end

			if slot18.weapon ~= "weapon_wallbang" then
				if slot1.in_attack or slot1.in_attack2 then
					if (slot18.grenade and slot18.grenade.strength) == 0 then
						slot1.in_attack = false
						slot1.in_attack2 = true
					elseif slot22 == 0.5 then
						slot1.in_attack = true
						slot1.in_attack2 = true
					else
						slot1.in_attack = true
						slot1.in_attack2 = false
					end
				end

				if slot21 and (uv0.settings.automatic_thow:get() and slot2.m_flNextAttack < globals.curtime or slot18.movement and slot1.in_attack or slot1.in_attack2 or slot6.m_bPinPulled) and slot12 < 2 then
					if slot3 == "Legit" then
						slot23, slot24 = slot0.normalize_angles(slot11.x - slot18.viewangles[1], slot11.y - slot18.viewangles[2])

						if math.sqrt(slot23 * slot23 + slot24 * slot24) <= slot4 then
							slot26 = math.min(1, slot25 / 3) * 0.5
							slot27 = (slot26 + math.abs(slot25 * (1 - slot26))) * globals.frametime * slot5

							render.camera_angles(vector(slot11.x - slot23 / slot25 * slot27, slot11.y - slot24 / slot25 * slot27, 0))
						end
					end

					if slot18.on_fov then
						slot0.playback.location = slot18
					end
				end
			end
		end

		if slot0.playback.location then
			slot1.jitter_move = false

			uv0.refs.extended_angles:override(false)
			uv0.refs.slow_walk:override(false)
			uv0.refs.air_duck:override(false)
			uv0.refs.air_strafe:override(false)
			uv0.refs.strafe_assist:override(false)

			if slot19.movement and slot19.movement.frames then
				slot0.playback:g_movement(slot1, slot9)
			elseif slot19.movement and slot19.movement.steps then
				slot0.playback:movement(slot1)
			else
				slot0.playback:grenade(slot1, slot2, slot6, slot7)
			end
		end
	end

	slot0.render:set(function ()
		if link_active ~= "" .. ui.get_style()["Link Active"]:to_hex() then
			link_active = slot1

			uv0:update_colored_names()
			uv1.update()
		end

		if uv0.locations.set_location_hotkey:get() then
			uv2.locations:on_set_location()
		end

		if uv0.locations.teleport_hotkey:get() then
			uv2.locations:on_teleport()
		end

		uv2:on_render()
	end)
	utils.execute_after(0, slot0.createmove.set, slot0.createmove, function (slot0)
		uv0:on_createmove(slot0)

		if uv1.locations.edit_mode then
			if uv1.locations.record_bind:get() and not uv0.locations.movement_recorder.is_recording then
				uv0.locations.movement_recorder.is_recording = true
			end

			if uv0.locations.movement_recorder.is_recording then
				uv0.locations:record(slot0)
			else
				uv0.locations.movement_recorder.start_at = nil
			end

			if not slot1 and uv0.locations.movement_recorder.is_recording then
				utils.execute_after(0.5, function ()
					uv0.locations:on_edit_location()

					uv0.locations.movement_recorder.is_recording = false
				end)
			end
		end
	end)
	slot0.shutdown:set(function ()
		uv0()
	end)

	slot29 = {
		["helper:help"] = function ()
			uv0("helper commands:\nhelper:clear - clear helper database\nhelper:get_map_info - show map information")
		end,
		["helper:clear"] = function ()
			uv0 = {}

			files.write(uv1, "{}")
			uv2("Database has been cleaned")
			common.reload_script()
		end,
		["helper:get_map_info"] = function ()
			uv0(([[
Map info: 
Map data: %s 
Resolved map name: %s 
Map pattern: %s]]):format(json.stringify(common.get_map_data()), uv1:get_map(), uv1.map_patterns.get()))
		end
	}

	slot0.console_input:set(function (slot0)
		if uv0[slot0:lower():gsub(" ", "")] then
			slot2()

			return false
		end
	end)
	slot0.level_init:set(function ()
		uv0.map_patterns:selection()
		uv0.locations:get_map_locatons()
		uv1.manage_map_patterns.current_map_pattern:set("Current Map Pattern: " .. uv0.map_patterns.get())
		uv2.update()
	end)
	slot0.cs_game_disconnected:set(function (slot0)
		utils.execute_after(0.01, uv0.update)
	end)
	slot1.update()
end

utils.execute_after(0.05, function ()
	slot0, slot1 = pcall(uv0)

	if not slot0 then
		print_raw(slot1)
	end
end)
