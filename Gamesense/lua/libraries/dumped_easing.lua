slot0 = math.pow
slot1 = math.sin
slot2 = math.cos
slot3 = math.pi
slot4 = math.sqrt
slot5 = math.abs
slot6 = math.asin

return {
	linear = function (slot0, slot1, slot2, slot3)
		return slot2 * slot0 / slot3 + slot1
	end,
	quad_in = function (slot0, slot1, slot2, slot3)
		return slot2 * uv0(slot0 / slot3, 2) + slot1
	end,
	quad_out = function (slot0, slot1, slot2, slot3)
		slot0 = slot0 / slot3

		return -slot2 * slot0 * (slot0 - 2) + slot1
	end,
	quad_in_out = function (slot0, slot1, slot2, slot3)
		if slot0 / slot3 * 2 < 1 then
			return slot2 / 2 * uv0(slot0, 2) + slot1
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
		return slot2 * uv0(slot0 / slot3, 3) + slot1
	end,
	cubic_out = function (slot0, slot1, slot2, slot3)
		return slot2 * (uv0(slot0 / slot3 - 1, 3) + 1) + slot1
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
		return slot2 * uv0(slot0 / slot3, 4) + slot1
	end,
	quart_out = function (slot0, slot1, slot2, slot3)
		return -slot2 * (uv0(slot0 / slot3 - 1, 4) - 1) + slot1
	end,
	quart_in_out = function (slot0, slot1, slot2, slot3)
		if slot0 / slot3 * 2 < 1 then
			return slot2 / 2 * uv0(slot0, 4) + slot1
		else
			return -slot2 / 2 * (uv0(slot0 - 2, 4) - 2) + slot1
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
		return slot2 * uv0(slot0 / slot3, 5) + slot1
	end,
	quint_out = function (slot0, slot1, slot2, slot3)
		return slot2 * (uv0(slot0 / slot3 - 1, 5) + 1) + slot1
	end,
	quint_in_out = function (slot0, slot1, slot2, slot3)
		if slot0 / slot3 * 2 < 1 then
			return slot2 / 2 * uv0(slot0, 5) + slot1
		else
			return slot2 / 2 * (uv0(slot0 - 2, 5) + 2) + slot1
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
		return -slot2 * uv0(slot0 / slot3 * uv1 / 2) + slot2 + slot1
	end,
	sine_out = function (slot0, slot1, slot2, slot3)
		return slot2 * uv0(slot0 / slot3 * uv1 / 2) + slot1
	end,
	sine_in_out = function (slot0, slot1, slot2, slot3)
		return -slot2 / 2 * (uv0(uv1 * slot0 / slot3) - 1) + slot1
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
			return slot2 * uv0(2, 10 * (slot0 / slot3 - 1)) + slot1 - slot2 * 0.001
		end
	end,
	expo_out = function (slot0, slot1, slot2, slot3)
		if slot0 == slot3 then
			return slot1 + slot2
		else
			return slot2 * 1.001 * (-uv0(2, -10 * slot0 / slot3) + 1) + slot1
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
			return slot2 / 2 * uv0(2, 10 * (slot0 - 1)) + slot1 - slot2 * 0.0005
		else
			return slot2 / 2 * 1.0005 * (-uv0(2, -10 * (slot0 - 1)) + 2) + slot1
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
		return -slot2 * (uv0(1 - uv1(slot0 / slot3, 2)) - 1) + slot1
	end,
	circ_out = function (slot0, slot1, slot2, slot3)
		return slot2 * uv0(1 - uv1(slot0 / slot3 - 1, 2)) + slot1
	end,
	circ_in_out = function (slot0, slot1, slot2, slot3)
		if slot0 / slot3 * 2 < 1 then
			return -slot2 / 2 * (uv0(1 - slot0 * slot0) - 1) + slot1
		else
			slot0 = slot0 - 2

			return slot2 / 2 * (uv0(1 - slot0 * slot0) + 1) + slot1
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

		if not slot4 or slot4 < uv0(slot2) then
			slot4 = slot2
			slot6 = (slot5 or slot3 * 0.3) / 4
		else
			slot6 = slot5 / (2 * uv1) * uv2(slot2 / slot4)
		end

		slot0 = slot0 - 1

		return -(slot4 * uv3(2, 10 * slot0) * uv4((slot0 * slot3 - slot6) * 2 * uv1 / slot5)) + slot1
	end,
	elastic_out = function (slot0, slot1, slot2, slot3, slot4, slot5)
		if slot0 == 0 then
			return slot1
		end

		if slot0 / slot3 == 1 then
			return slot1 + slot2
		end

		slot6 = nil

		if not slot4 or slot4 < uv0(slot2) then
			slot4 = slot2
			slot6 = (slot5 or slot3 * 0.3) / 4
		else
			slot6 = slot5 / (2 * uv1) * uv2(slot2 / slot4)
		end

		return slot4 * uv3(2, -10 * slot0) * uv4((slot0 * slot3 - slot6) * 2 * uv1 / slot5) + slot2 + slot1
	end,
	elastic_in_out = function (slot0, slot1, slot2, slot3, slot4, slot5)
		if slot0 == 0 then
			return slot1
		end

		if slot0 / slot3 * 2 == 2 then
			return slot1 + slot2
		end

		slot6 = nil

		if not slot4 and not 0 or slot4 < uv0(slot2) then
			slot4 = slot2
			slot6 = (slot5 or slot3 * 0.44999999999999996) / 4
		else
			slot6 = slot5 / (2 * uv1) * uv2(slot2 / slot4)
		end

		if slot0 < 1 then
			slot0 = slot0 - 1

			return -0.5 * slot4 * uv3(2, 10 * slot0) * uv4((slot0 * slot3 - slot6) * 2 * uv1 / slot5) + slot1
		else
			slot0 = slot0 - 1

			return slot4 * uv3(2, -10 * slot0) * uv4((slot0 * slot3 - slot6) * 2 * uv1 / slot5) * 0.5 + slot2 + slot1
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
