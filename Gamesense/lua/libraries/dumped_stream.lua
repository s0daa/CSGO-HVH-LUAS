return function (slot0)
	function slot2(slot0)
		return slot0()
	end

	function slot3(slot0)
		slot1 = #slot0
		slot3 = slot0[1]

		return function ()
			if uv1 < uv0 then
				return nil
			else
				while true do
					if uv2() ~= nil then
						return slot0
					else
						uv0 = uv0 + 1

						if uv1 < uv0 then
							return nil
						else
							uv2 = uv3[uv0]
						end
					end
				end
			end
		end
	end

	function slot4(slot0, slot1)
		if slot1 == nil then
			error("c must be of type function, but was nil")
		end

		if type(slot1) ~= "function" then
			error("c must be of type function, but was a " .. type(slot1))
		end

		return function ()
			if uv0() ~= nil then
				uv1(slot0)
			end

			return slot0
		end
	end

	function slot5(slot0, slot1)
		if slot1 == nil then
			error("p must be of type function, but was nil")
		end

		if type(slot1) ~= "function" then
			error("p must be of type function, but was a " .. type(slot1))
		end

		return function ()
			slot0 = uv0()

			while slot0 ~= nil do
				if uv1(slot0) then
					return slot0
				else
					slot0 = uv0()
				end
			end

			return nil
		end
	end

	function slot6(slot0, slot1)
		return function ()
			slot0 = nil

			for slot4 = 1, uv0 do
				if uv1() == nil then
					return slot0
				else
					if slot0 == nil then
						slot0 = {}
					end

					table.insert(slot0, slot5)
				end
			end

			return slot0
		end
	end

	function slot7(slot0, slot1)
		if slot1 == nil then
			error("f must be of type function, but was nil")
		end

		if type(slot1) ~= "function" then
			error("f must be of type function, but was a " .. type(slot1))
		end

		return function ()
			if uv0() ~= nil then
				return uv1(slot0)
			else
				return nil
			end
		end
	end

	function slot8(slot0, slot1)
		if slot1 == nil then
			error("f must be of type function, but was nil")
		end

		if type(slot1) ~= "function" then
			error("f must be of type function, but was a " .. type(slot1))
		end

		slot2 = nil

		return function ()
			while true do
				if uv0 == nil then
					if uv1() == nil then
						return nil
					else
						uv0 = uv2(uv3(slot0))
					end
				elseif uv0() ~= nil then
					return slot0
				else
					uv0 = nil
				end
			end
		end
	end

	function slot9(slot0)
		return uv0(slot0, function (slot0)
			return slot0
		end)
	end

	function slot10(slot0)
		slot1 = {}

		return function ()
			slot0 = uv0()

			while slot0 ~= nil do
				if uv1[slot0] == nil then
					uv1[slot0] = true

					return slot0
				else
					slot0 = uv0()
				end
			end

			return nil
		end
	end

	function slot11(slot0, slot1)
		slot2 = 0

		return function ()
			uv0 = uv0 + 1

			if uv1 < uv0 then
				return nil
			else
				return uv2()
			end
		end
	end

	function slot12(slot0, slot1)
		slot2 = 0

		while slot1 > slot2 do
			slot2 = slot2 + 1

			if slot0() == nil then
				break
			end
		end

		return slot0
	end

	function slot13(slot0)
		slot1 = nil

		for slot5 in slot0, nil,  do
			slot1 = slot5
		end

		return slot1
	end

	function slot14(slot0, slot1)
		if slot1 == nil then
			error("c must be of type function, but was nil")
		end

		if type(slot1) ~= "function" then
			error("c must be of type function, but was a " .. type(slot1))
		end

		for slot5 in slot0, nil,  do
			slot1(slot5)
		end
	end

	function slot15(slot0)
		for slot6 in slot0, nil,  do
			-- Nothing
		end

		return {
			[0 + 1] = slot6
		}
	end

	function slot16(slot0)
		slot4 = nil

		for slot8 = #uv0(slot0), 2, -1 do
			slot4 = math.random(slot8)
			slot1[slot4] = slot1[slot8]
			slot1[slot8] = slot1[slot4]
		end

		return uv1(slot1)
	end

	function slot17(slot0, slot1)
		if slot1 == nil then
			error("f must be of type function, but was nil")
		end

		if type(slot1) ~= "function" then
			error("f must be of type function, but was a " .. type(slot1))
		end

		slot2 = {}

		for slot6 in slot0, nil,  do
			if slot2[slot1(slot6)] == nil then
				slot2[slot7] = {}
			end

			slot8[#slot8 + 1] = slot6
		end

		return slot2
	end

	function slot18(slot0, slot1)
		if slot1 == nil then
			error("f must be of type function, but was nil")
		end

		if type(slot1) ~= "function" then
			error("f must be of type function, but was a " .. type(slot1))
		end

		slot2 = {}
		slot3 = {}

		function slot4(slot0, slot1, slot2)
			return function ()
				if uv0[1] ~= nil then
					return table.remove(uv0, 1)
				else
					slot0 = uv1()

					while slot0 ~= nil do
						if uv2(slot0) == uv3 then
							return slot0
						else
							table.insert(uv4, slot0)

							slot0 = uv1()
						end
					end

					return nil
				end
			end
		end

		return uv0(slot4(true, slot2, slot3)), uv0(slot4(false, slot3, slot2))
	end

	function slot19(slot0)
		slot1 = 1

		return function ()
			if #uv0 == 0 then
				return nil
			end

			for slot4 = 1, slot0 do
				if slot0 < uv1 then
					uv1 = 1
				end

				if uv0[uv1]() ~= nil then
					uv1 = uv1 + 1

					return slot6
				else
					table.remove(uv0, uv1)

					slot0 = #uv0
				end
			end

			slot2 = {}

			for slot6, slot7 in ipairs(uv0) do
				if slot7() == nil then
					slot1 = 0 + 1
				else
					slot2[slot6 - slot1] = slot8
				end
			end

			if slot1 >= #uv0 then
				return nil
			else
				return slot2
			end
		end
	end

	function slot20(slot0, slot1, slot2)
		if slot2 == nil then
			error("op must be of type function, but was nil")
		end

		if type(slot2) ~= "function" then
			error("op must be of type function, but was a " .. type(slot2))
		end

		for slot7 in slot0, nil,  do
			slot3 = slot2(slot1, slot7)
		end

		return slot3
	end

	function slot21(slot0)
		for slot6 = 1, #uv0(slot0) / 2 do
			slot1[slot2 - slot6 + 1] = slot1[slot6]
			slot1[slot6] = slot1[slot2 - slot6 + 1]
		end

		return uv1(slot1)
	end

	function slot22(slot0, slot1)
		slot2 = uv0(slot0)

		table.sort(slot2, slot1)

		return uv1(slot2)
	end

	function slot23(slot0)
		for slot5 in slot0, nil,  do
			slot1 = 0 + 1
		end

		return slot1
	end

	function slot24(slot0, slot1)
		slot2 = nil

		for slot6 in slot0, nil,  do
			if slot2 == nil or slot1 ~= nil and slot1(slot2, slot6) or slot2 < slot6 then
				slot2 = slot6
			end
		end

		return slot2
	end

	function slot25(slot0, slot1)
		slot2 = nil

		for slot6 in slot0, nil,  do
			if slot2 == nil or slot1 ~= nil and slot1(slot6, slot2) or slot6 < slot2 then
				slot2 = slot6
			end
		end

		return slot2
	end

	function slot26(slot0)
		for slot5 in slot0, nil,  do
			slot1 = 0 + slot5
		end

		return slot1
	end

	function slot27(slot0)
		for slot6 in slot0, nil,  do
			slot2 = 0 + 1
			slot1 = 0 + slot6
		end

		if slot2 == 0 then
			return nil
		else
			return slot1 / slot2
		end
	end

	function slot28(slot0, slot1)
		if slot1 == nil then
			error("p must be of type function, but was nil")
		end

		if type(slot1) ~= "function" then
			error("p must be of type function, but was a " .. type(slot1))
		end

		for slot5 in slot0, nil,  do
			if not slot1(slot5) then
				return false
			end
		end

		return true
	end

	function slot29(slot0, slot1)
		if slot1 == nil then
			error("p must be of type function, but was nil")
		end

		if type(slot1) ~= "function" then
			error("p must be of type function, but was a " .. type(slot1))
		end

		for slot5 in slot0, nil,  do
			if slot1(slot5) then
				return true
			end
		end

		return false
	end

	function slot30(slot0, slot1)
		return not uv0(slot0, slot1)
	end

	if slot0 == nil then
		return function (slot0)
			return {
				iter = function ()
					return uv0
				end,
				next = function ()
					return uv0(uv1)
				end,
				concat = function (...)
					for slot4, slot5 in ipairs({
						...
					}) do
						-- Nothing
					end

					return uv1(uv2({
						uv0,
						[slot4 + 1] = slot5.iter()
					}))
				end,
				peek = function (slot0)
					return uv0(uv1(uv2, slot0))
				end,
				filter = function (slot0)
					return uv0(uv1(uv2, slot0))
				end,
				pack = function (slot0)
					return uv0(uv1(uv2, slot0))
				end,
				map = function (slot0)
					return uv0(uv1(uv2, slot0))
				end,
				flatmap = function (slot0)
					return uv0(uv1(uv2, slot0))
				end,
				flatten = function ()
					return uv0(uv1(uv2))
				end,
				limit = function (slot0)
					return uv0(uv1(uv2, slot0))
				end,
				skip = function (slot0)
					return uv0(uv1(uv2, slot0))
				end,
				last = function ()
					return uv0(uv1)
				end,
				foreach = function (slot0)
					uv0(uv1, slot0)
				end,
				toarray = function ()
					return uv0(uv1)
				end,
				shuffle = function ()
					return uv0(uv1(uv2))
				end,
				group = function (slot0)
					return uv0(uv1, slot0)
				end,
				split = function (slot0)
					return uv0(uv1, slot0)
				end,
				merge = function (...)
					for slot4, slot5 in ipairs({
						...
					}) do
						-- Nothing
					end

					return uv1(uv2({
						uv0,
						[slot4 + 1] = slot5.iter()
					}))
				end,
				collect = function (slot0)
					return slot0(uv0)
				end,
				reduce = function (slot0, slot1)
					return uv0(uv1, slot0, slot1)
				end,
				reverse = function ()
					return uv0(uv1(uv2))
				end,
				sort = function (slot0)
					return uv0(uv1(uv2, slot0))
				end,
				distinct = function ()
					return uv0(uv1(uv2))
				end,
				count = function ()
					return uv0(uv1)
				end,
				max = function (slot0)
					return uv0(uv1, slot0)
				end,
				min = function (slot0)
					return uv0(uv1, slot0)
				end,
				sum = function ()
					return uv0(uv1)
				end,
				avg = function ()
					return uv0(uv1)
				end,
				allmatch = function (slot0)
					return uv0(uv1, slot0)
				end,
				anymatch = function (slot0)
					return uv0(uv1, slot0)
				end,
				nonematch = function (slot0)
					return uv0(uv1, slot0)
				end
			}
		end(function (slot0)
			if slot0 == nil then
				error("input must be of type table, but was nil")
			elseif type(slot0) ~= "table" then
				error("input must be of type table, but was a " .. type(slot0) .. ": " .. slot0)
			end

			slot1 = #slot0
			slot2 = 0

			return function ()
				uv0 = uv0 + 1

				if uv1 < uv0 then
					return nil
				else
					return uv2[uv0]
				end
			end
		end({}))
	elseif type(slot0) == "table" then
		return slot31(slot1(slot0))
	elseif type(slot0) == "boolean" or type(slot0) == "number" or type(slot0) == "string" then
		return slot31(slot1({
			slot0
		}))
	elseif type(slot0) == "function" then
		return slot31(slot0)
	else
		error("input must be nil or of type table, boolean, number, string, or function, but was a " .. type(slot0))
	end
end
