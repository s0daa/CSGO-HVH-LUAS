slot0 = {
	_URL = "http://github.com/kikito/inspect.lua",
	_VERSION = "inspect.lua 3.1.0",
	_DESCRIPTION = "human-readable representations of tables",
	_LICENSE = [[
		MIT LICENSE

		Copyright (c) 2013 Enrique García Cota

		Permission is hereby granted, free of charge, to any person obtaining a
		copy of this software and associated documentation files (the
		"Software"), to deal in the Software without restriction, including
		without limitation the rights to use, copy, modify, merge, publish,
		distribute, sublicense, and/or sell copies of the Software, and to
		permit persons to whom the Software is furnished to do so, subject to
		the following conditions:

		The above copyright notice and this permission notice shall be included
		in all copies or substantial portions of the Software.

		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
		OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
		MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
		IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
		CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
		TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
		SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	]],
	KEY = setmetatable({}, {
		__tostring = function ()
			return "inspect.KEY"
		end
	}),
	METATABLE = setmetatable({}, {
		__tostring = function ()
			return "inspect.METATABLE"
		end
	})
}
slot1 = tostring

function slot2(slot0)
	return next, slot0, nil
end

function slot3(slot0)
	if slot0:match("\"") and not slot0:match("'") then
		return "'" .. slot0 .. "'"
	end

	return "\"" .. slot0:gsub("\"", "\\\"") .. "\""
end

slot4 = {
	[""] = "\\b",
	["\r"] = "\\r",
	[""] = "\\a",
	["\t"] = "\\t",
	["\n"] = "\\n",
	[""] = "\\v",
	[""] = "\\f"
}
slot5 = {
	[slot10] = string.format("\\%03d", slot9)
}

for slot9 = 0, 31 do
	if not slot4[string.char(slot9)] then
		slot4[slot10] = "\\" .. slot9
	end
end

function slot6(slot0)
	return slot0:gsub("\\", "\\\\"):gsub("(%c)%f[0-9]", uv0):gsub("%c", uv1)
end

function slot7(slot0)
	return type(slot0) == "string" and slot0:match("^[_%a][_%a%d]*$")
end

function slot8(slot0, slot1)
	return type(slot0) == "number" and slot0 >= 1 and slot0 <= slot1 and math.floor(slot0) == slot0
end

slot9 = {
	number = 1,
	table = 4,
	boolean = 2,
	userdata = 6,
	thread = 7,
	["function"] = 5,
	string = 3
}

function slot10(slot0, slot1)
	if type(slot0) == type(slot1) and (slot2 == "string" or slot2 == "number") then
		return slot0 < slot1
	end

	if uv0[slot2] and uv0[slot3] then
		return uv0[slot2] < uv0[slot3]
	elseif slot4 then
		return true
	elseif slot5 then
		return false
	end

	return slot2 < slot3
end

function slot11(slot0)
	while rawget(slot0, 1) ~= nil do
		slot2 = rawget(slot0, slot1 + 1)
	end

	return slot1 - 1
end

function slot12(slot0)
	slot1 = {
		[slot2 + 1] = slot7
	}
	slot2 = 0
	slot3 = uv0(slot0)

	for slot7, slot8 in uv1(slot0) do
		if not uv2(slot7, slot3) then
			-- Nothing
		end
	end

	table.sort(slot1, uv3)

	return slot1, slot2, slot3
end

function slot13(slot0, slot1)
	slot1 = slot1 or {}

	if type(slot0) == "table" then
		if not slot1[slot0] then
			slot1[slot0] = 1

			for slot5, slot6 in uv0(slot0) do
				uv1(slot5, slot1)
				uv1(slot6, slot1)
			end

			uv1(getmetatable(slot0), slot1)
		else
			slot1[slot0] = slot1[slot0] + 1
		end
	end

	return slot1
end

function slot14(slot0)
	for slot6 = 1, #slot0 do
	end

	return {
		[slot6] = slot0[slot6]
	}, slot2
end

function slot15(slot0, ...)
	slot2, slot3 = uv0(slot0)

	for slot7 = 1, #{
		...
	} do
		slot2[slot3 + slot7] = slot1[slot7]
	end

	return slot2
end

function slot16(slot0, slot1, slot2, slot3)
	if slot1 == nil then
		return nil
	end

	if slot3[slot1] then
		return slot3[slot1]
	end

	if type(slot0(slot1, slot2)) == "table" then
		slot3[slot1] = {}
		slot6 = nil

		for slot10, slot11 in uv0(slot4) do
			if uv1(slot0, slot10, uv2(slot2, slot10, uv3.KEY), slot3) ~= nil then
				slot5[slot6] = uv1(slot0, slot11, uv2(slot2, slot6), slot3)
			end
		end

		if type(uv1(slot0, getmetatable(slot4), uv2(slot2, uv3.METATABLE), slot3)) ~= "table" then
			slot7 = nil
		end

		setmetatable(slot5, slot7)

		slot4 = slot5
	end

	return slot4
end

slot17 = {}
slot18 = {
	__index = slot17
}

function slot17.puts(slot0, ...)
	for slot7 = 1, #{
		...
	} do
		slot2[#slot0.buffer + 1] = slot1[slot7]
	end
end

function slot17.down(slot0, slot1)
	slot0.level = slot0.level + 1

	slot1()

	slot0.level = slot0.level - 1
end

function slot17.tabify(slot0)
	slot0:puts(slot0.newline, string.rep(slot0.indent, slot0.level))
end

function slot17.alreadyVisited(slot0, slot1)
	return slot0.ids[slot1] ~= nil
end

function slot17.getId(slot0, slot1)
	if not slot0.ids[slot1] then
		slot2 = (slot0.maxIds[type(slot1)] or 0) + 1
		slot0.maxIds[slot3] = slot2
		slot0.ids[slot1] = slot2
	end

	return uv0(slot2)
end

function slot17.putKey(slot0, slot1)
	if uv0(slot1) then
		return slot0:puts(slot1)
	end

	slot0:puts("[")
	slot0:putValue(slot1)
	slot0:puts("]")
end

function slot17.putTable(slot0, slot1)
	if slot1 == uv0.KEY or slot1 == uv0.METATABLE then
		slot0:puts(uv1(slot1))
	elseif slot0:alreadyVisited(slot1) then
		slot0:puts("<table ", slot0:getId(slot1), ">")
	elseif slot0.depth <= slot0.level then
		slot0:puts("{...}")
	else
		if slot0.tableAppearances[slot1] > 1 then
			slot0:puts("<", slot0:getId(slot1), ">")
		end

		slot2, slot3, slot4 = uv2(slot1)

		slot0:puts("{")
		slot0:down(function ()
			slot0 = 0

			for slot4 = 1, uv0 do
				if slot0 > 0 then
					uv1:puts(",")
				end

				uv1:puts(" ")
				uv1:putValue(uv2[slot4])

				slot0 = slot0 + 1
			end

			for slot4 = 1, uv3 do
				slot5 = uv4[slot4]

				if slot0 > 0 then
					uv1:puts(",")
				end

				uv1:tabify()
				uv1:putKey(slot5)
				uv1:puts(" = ")
				uv1:putValue(uv2[slot5])

				slot0 = slot0 + 1
			end

			if type(uv5) == "table" then
				if slot0 > 0 then
					uv1:puts(",")
				end

				uv1:tabify()
				uv1:puts("<metatable> = ")
				uv1:putValue(uv5)
			end
		end)

		if slot3 > 0 or type(getmetatable(slot1)) == "table" then
			slot0:tabify()
		elseif slot4 > 0 then
			slot0:puts(" ")
		end

		slot0:puts("}")
	end
end

function slot17.putValue(slot0, slot1)
	if type(slot1) == "string" then
		slot0:puts(uv0(uv1(slot1)))
	elseif slot2 == "number" or slot2 == "boolean" or slot2 == "nil" or slot2 == "cdata" or slot2 == "ctype" then
		slot0:puts(uv2(slot1))
	elseif slot2 == "table" then
		slot0:putTable(slot1)
	else
		slot0:puts("<", slot2, " ", slot0:getId(slot1), ">")
	end
end

function slot0.inspect(slot0, slot1)
	slot1 = slot1 or {}
	slot2 = slot1.depth or math.huge
	slot3 = slot1.newline or "\n"
	slot4 = slot1.indent or "\t"

	if slot1.process then
		slot0 = uv0(slot5, slot0, {}, {})
	end

	slot6 = setmetatable({
		level = 0,
		depth = slot2,
		buffer = {},
		ids = {},
		maxIds = {},
		newline = slot3,
		indent = slot4,
		tableAppearances = uv1(slot0)
	}, uv2)

	slot6:putValue(slot0)

	return table.concat(slot6.buffer)
end

setmetatable(slot0, {
	__call = function (slot0, ...)
		return uv0.inspect(...)
	end
})

return slot0
