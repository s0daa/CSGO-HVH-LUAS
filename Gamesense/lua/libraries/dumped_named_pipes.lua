slot0 = require("ffi")
slot1 = string.match
slot2 = string.len
slot3 = string.gsub
slot4 = string.gmatch
slot5 = string.byte
slot6 = slot0.cast
slot7 = slot0.typeof
slot8 = slot0.string
slot11 = client.find_signature("engine.dll", "\\xff\\xe1")
slot12 = slot6("uint32_t**", slot6("uint32_t", client.find_signature("engine.dll", "\\xff\\xcc\\xcc\\xcc̣\\xcc\\xcc\\xcc\\xcc\\xeb") or error("Couldn't find signature #2")) + 2)[0][0]
slot13 = slot6("uint32_t(__fastcall*)(unsigned int, unsigned int, uint32_t, const char*)", slot11)
slot14 = slot6("uint32_t**", slot6("uint32_t", client.find_signature("engine.dll", "\\xff\\xcc\\xcc\\xcc̅\\xc0t") or error("Couldn't find signature #1")) + 2)[0][0]
slot15 = slot6("uint32_t(__fastcall*)(unsigned int, unsigned int, const char*)", slot11)

function slot16(slot0, slot1, slot2)
	slot5 = uv3(uv4, 0, uv1(uv2, 0, slot0), slot1)
	slot6 = uv5(uv0(slot2), uv6)

	return function (...)
		return uv0(uv1, 0, ...)
	end
end

slot17 = slot7("unsigned long[?]")
slot18 = slot7("const char*")
slot19 = slot7("const char[?]")
slot20 = slot7("unsigned short*")
slot21 = slot7("unsigned short[?]")

function slot22(slot0)
	slot2 = uv1(uv0(slot0) + 1)
	slot3 = 0

	for slot7 in uv2(slot0, ".") do
		slot2[slot3] = uv3(slot7)
		slot3 = slot3 + 1
	end

	return uv4(uv5, slot2)
end

slot23 = slot16("kernel32.dll", "CreateFileW", "void*(__fastcall*)(unsigned int, unsigned int, const wchar_t*, unsigned long, unsigned long, void*, unsigned long, unsigned long, void*)")
slot24 = slot16("kernel32.dll", "CloseHandle", "bool(__fastcall*)(unsigned int, unsigned int, void*)")
slot25 = slot16("kernel32.dll", "WriteFile", "bool(__fastcall*)(unsigned int, unsigned int, void*, const char*, unsigned long, unsigned long*, unsigned long*)")
slot26 = slot16("kernel32.dll", "ReadFile", "bool(__fastcall*)(unsigned int, unsigned int, void*, const char*, unsigned long, unsigned long*, unsigned long*)")
slot27 = slot16("kernel32.dll", "PeekNamedPipe", "bool(__fastcall*)(unsigned int, unsigned int, void*, void*, unsigned long, unsigned long*, unsigned long*, unsigned long*)")
slot28 = slot16("kernel32.dll", "GetLastError", "unsigned long(__fastcall*)(unsigned int, unsigned int)")
slot29 = slot16("kernel32.dll", "GetFileType", "unsigned long(__fastcall*)(unsigned int, unsigned int, void*)")
slot32 = bit.bor(2147483648.0, 1073741824)
slot33 = 1
slot34 = 3
slot35 = 67108992
slot36 = 128
slot37 = 3
slot38 = slot0.cast("void*", -1)
slot39 = {
	__index = {
		close = function (slot0)
			if uv0[slot0] == nil then
				return error("Invalid pipe")
			end

			uv0[slot0] = nil

			if not uv1(slot1.handle) then
				return error("Failed to close pipe: " .. uv2())
			end
		end,
		read = function (slot0, slot1)
			if slot1 ~= nil then
				if type(slot1) ~= "number" then
					return error("Invalid size, expected number or nil", 2)
				elseif slot1 < 0 then
					return error("Invalid size", 2)
				end
			end

			if uv0[slot0] == nil then
				return error("Invalid pipe")
			end

			if uv2(slot2.handle, nil, 0, nil, uv1(1), nil) then
				slot4 = slot3[0]

				if slot1 == nil and slot4 > 0 then
					slot1 = slot4
				elseif slot1 ~= nil and slot4 < slot1 then
					slot1 = nil
				end

				if slot1 ~= nil then
					if uv4(slot2.handle, uv3(slot1), slot1, uv1(1), nil) and slot6[0] == slot1 then
						return uv5(slot5, slot1)
					else
						return error("Failed to read: " .. uv6())
					end
				end
			else
				return error("Failed to peek: " .. uv6())
			end
		end,
		write = function (slot0, slot1)
			if uv0[slot0] == nil then
				return error("Invalid pipe")
			end

			slot1 = tostring(slot1) or ""

			if uv3(slot2.handle, slot1, uv2(slot1), uv1(1), nil) then
				return tonumber(slot3[0])
			else
				return error("Failed to write: " .. uv4())
			end
		end
	}
}
slot40 = {}
slot41 = {
	nil,
	"File not found",
	"Path not found",
	nil,
	"Access denied",
	[230.0] = "Bad pipe",
	[80.0] = "File exists",
	[109.0] = "Broken pipe",
	[231.0] = "Pipe busy"
}

function slot42()
	return uv1[uv0()] or tostring(slot0)
end

client.set_event_callback("shutdown", function ()
	for slot3, slot4 in pairs(uv0) do
		pcall(uv1, slot3)
	end
end)

return {
	open_pipe = function (slot0)
		if type(slot0) ~= "string" then
			return error("Invalid path, expected string", 2)
		elseif not uv0(slot0, "^\\\\%?\\pipe\\") then
			return error("Invalid path, expected \\\\?\\pipe\\", 2)
		end

		if uv2(uv1(slot0), uv3, 0, nil, uv4, 0, nil) == uv5 then
			return error("Failed to open pipe: " .. uv6())
		elseif uv7(slot2) ~= uv8 then
			uv9(slot2)

			return error("Failed to open pipe: Invalid file type")
		end

		slot3 = setmetatable({
			path = slot0
		}, uv10)
		uv11[slot3] = {
			open = true,
			handle = slot2
		}

		return slot3
	end
}
