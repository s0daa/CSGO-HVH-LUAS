slot0 = require("ffi")
slot1 = require("gamesense/base64")
slot2 = assert
slot4 = xpcall
slot5 = error
slot6 = setmetatable
slot7 = tostring
slot8 = tonumber
slot9 = type
slot10 = pairs
slot11 = ipairs
slot12 = client.log
slot13 = client.delay_call
slot14 = ui.get
slot15 = string.format
slot16 = slot0.typeof
slot17 = slot0.sizeof
slot18 = slot0.cast
slot20 = slot0.string
slot21 = slot0.gc
slot22 = string.lower
slot23 = string.len
slot24, slot25, slot26 = nil

if not pcall(slot0.sizeof, "SteamAPICall_t") then
	slot0.cdef([[
			typedef uint64_t SteamAPICall_t;

			struct SteamAPI_callback_base_vtbl {
				void(__thiscall *run1)(struct SteamAPI_callback_base *, void *, bool, uint64_t);
				void(__thiscall *run2)(struct SteamAPI_callback_base *, void *);
				int(__thiscall *get_size)(struct SteamAPI_callback_base *);
			};

			struct SteamAPI_callback_base {
				struct SteamAPI_callback_base_vtbl *vtbl;
				uint8_t flags;
				int id;
				uint64_t api_call_handle;
				struct SteamAPI_callback_base_vtbl vtbl_storage[1];
			};
		]])
end

slot27 = {
	[0] = "Steam gone",
	"Network failure",
	"Invalid handle",
	[-1.0] = "No failure",
	[3.0] = "Mismatched callback"
}
slot28, slot29, slot30, slot31, slot32 = nil
slot33 = slot16("struct SteamAPI_callback_base")
slot34 = slot17(slot33)
slot35 = slot16("struct SteamAPI_callback_base[1]")
slot36 = slot16("struct SteamAPI_callback_base*")
slot37 = slot16("uintptr_t")
slot38 = {}
slot39 = {}
slot40 = {}

function slot41(slot0)
	return uv0(uv1(uv2(uv3, slot0)))
end

function slot42(slot0, slot1, slot2)
	slot2 = slot2 and (uv0[uv1(slot0.api_call_handle)] or "Unknown error")
	slot0.api_call_handle = 0

	uv2(function ()
		if uv2[uv0(uv1)] ~= nil then
			uv3(slot1, client.error_log, uv4, uv5)
		end

		if uv6[slot0] ~= nil then
			uv2[slot0] = nil
			uv6[slot0] = nil
		end
	end, client.error_log)
end

function slot46(slot0)
	if slot0.api_call_handle ~= 0 then
		uv0(slot0, slot0.api_call_handle)

		slot0.api_call_handle = 0
		slot1 = uv1(slot0)
		uv2[slot1] = nil
		uv3[slot1] = nil
	end
end

slot3(slot0.metatype, slot33, {
	__gc = slot46,
	__index = {
		cancel = slot46
	}
})

slot47 = slot18("void(__thiscall *)(struct SteamAPI_callback_base *, void *, bool, uint64_t)", function (slot0, slot1, slot2, slot3)
	if slot3 == slot0.api_call_handle then
		uv0(slot0, slot1, slot2)
	end
end)
slot48 = slot18("void(__thiscall *)(struct SteamAPI_callback_base *, void *)", function (slot0, slot1)
	uv0(slot0, slot1, false)
end)
slot49 = slot18("int(__thiscall *)(struct SteamAPI_callback_base *)", function (slot0)
	return uv0
end)

function slot24(slot0, slot1, slot2)
	uv0(slot0 ~= 0)

	slot3 = uv1()
	slot4 = uv2(uv3, slot3)
	slot4.vtbl_storage[0].run1 = uv4
	slot4.vtbl_storage[0].run2 = uv5
	slot4.vtbl_storage[0].get_size = uv6
	slot4.vtbl = slot4.vtbl_storage
	slot4.api_call_handle = slot0
	slot4.id = slot2
	slot5 = uv7(slot4)
	uv8[slot5] = slot1
	uv9[slot5] = slot3

	uv10(slot4, slot0)

	return slot4
end

function slot25(slot0, slot1)
	uv0(uv1[slot0] == nil)

	slot2 = uv2()
	slot3 = uv3(uv4, slot2)
	slot3.vtbl_storage[0].run1 = uv5
	slot3.vtbl_storage[0].run2 = uv6
	slot3.vtbl_storage[0].get_size = uv7
	slot3.vtbl = slot3.vtbl_storage
	slot3.api_call_handle = 0
	slot3.id = slot0
	uv9[uv8(slot3)] = slot1
	uv1[slot0] = slot2

	uv10(slot3, slot0)
end

function slot50(slot0, slot1, slot2, slot3, slot4)
	if slot3 ~= nil and slot3 ~= 0 then
		slot6 = uv1("uintptr_t", client.find_signature(slot0, slot1) or uv0("signature not found", 2)) + slot3
	end

	if slot4 ~= nil then
		for slot10 = 1, slot4 do
			if uv1("uintptr_t*", slot6)[0] == nil then
				return uv0("signature not found")
			end
		end
	end

	return uv1(slot2, slot6)
end

slot28 = slot50("steam_api.dll", "U\\x8b\\xec\\x83=\\xcc\\xcc\\xcc\\xcc\\xcc~\rh\\xcc\\xcc\\xcc\\xcc\\xff\\xcc\\xcc\\xcc\\xcc]\\xc3\\xffu", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")
slot29 = slot50("steam_api.dll", "U\\x8b\\xec\\xffu\\xffu", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")
slot30 = slot50("steam_api.dll", "U\\x8b\\xec\\x83=\\xcc\\xcc\\xcc\\xcc\\xcc~\rh\\xcc\\xcc\\xcc\\xcc\\xff\\xcc\\xcc\\xcc\\xcc]\\xc3\\xc7", "void(__cdecl*)(struct SteamAPI_callback_base *, int)")
slot31 = slot50("steam_api.dll", "U\\x8b\\xec\\x83\\xec\\x80=\\xcc\\xcc\\xcc\\xcc\\xcc\\x84", "void(__cdecl*)(struct SteamAPI_callback_base *)")
slot53 = function (slot0, slot1, slot2)
	return uv0(slot2, uv0("void***", slot0)[0][slot1])
end(slot18("uintptr_t*", slot50("client_panorama.dll", "\\xb9\\xcc\\xcc\\xcc\\xcc\\xe8\\xcc\\xcc\\xcc̃=\\xcc\\xcc\\xcc\\xcc\\xcc\\x84", "uintptr_t", 1, 1))[3], 12, "int(__thiscall*)(void*, SteamAPICall_t)")

function slot32(slot0)
	return uv0(uv1, slot0)
end

client.set_event_callback("shutdown", function ()
	for slot3, slot4 in uv0(uv1) do
		uv4(uv2(uv3, slot4))
	end

	for slot3, slot4 in uv0(uv5) do
		uv6(uv2(uv3, slot4))
	end
end)

if not slot3(slot17, "http_HTTPRequestHandle") then
	slot19([[
		typedef uint32_t http_HTTPRequestHandle;
		typedef uint32_t http_HTTPCookieContainerHandle;

		enum http_EHTTPMethod {
			k_EHTTPMethodInvalid,
			k_EHTTPMethodGET,
			k_EHTTPMethodHEAD,
			k_EHTTPMethodPOST,
			k_EHTTPMethodPUT,
			k_EHTTPMethodDELETE,
			k_EHTTPMethodOPTIONS,
			k_EHTTPMethodPATCH,
		};

		struct http_ISteamHTTPVtbl {
			http_HTTPRequestHandle(__thiscall *CreateHTTPRequest)(uintptr_t, enum http_EHTTPMethod, const char *);
			bool(__thiscall *SetHTTPRequestContextValue)(uintptr_t, http_HTTPRequestHandle, uint64_t);
			bool(__thiscall *SetHTTPRequestNetworkActivityTimeout)(uintptr_t, http_HTTPRequestHandle, uint32_t);
			bool(__thiscall *SetHTTPRequestHeaderValue)(uintptr_t, http_HTTPRequestHandle, const char *, const char *);
			bool(__thiscall *SetHTTPRequestGetOrPostParameter)(uintptr_t, http_HTTPRequestHandle, const char *, const char *);
			bool(__thiscall *SendHTTPRequest)(uintptr_t, http_HTTPRequestHandle, SteamAPICall_t *);
			bool(__thiscall *SendHTTPRequestAndStreamResponse)(uintptr_t, http_HTTPRequestHandle, SteamAPICall_t *);
			bool(__thiscall *DeferHTTPRequest)(uintptr_t, http_HTTPRequestHandle);
			bool(__thiscall *PrioritizeHTTPRequest)(uintptr_t, http_HTTPRequestHandle);
			bool(__thiscall *GetHTTPResponseHeaderSize)(uintptr_t, http_HTTPRequestHandle, const char *, uint32_t *);
			bool(__thiscall *GetHTTPResponseHeaderValue)(uintptr_t, http_HTTPRequestHandle, const char *, uint8_t *, uint32_t);
			bool(__thiscall *GetHTTPResponseBodySize)(uintptr_t, http_HTTPRequestHandle, uint32_t *);
			bool(__thiscall *GetHTTPResponseBodyData)(uintptr_t, http_HTTPRequestHandle, uint8_t *, uint32_t);
			bool(__thiscall *GetHTTPStreamingResponseBodyData)(uintptr_t, http_HTTPRequestHandle, uint32_t, uint8_t *, uint32_t);
			bool(__thiscall *ReleaseHTTPRequest)(uintptr_t, http_HTTPRequestHandle);
			bool(__thiscall *GetHTTPDownloadProgressPct)(uintptr_t, http_HTTPRequestHandle, float *);
			bool(__thiscall *SetHTTPRequestRawPostBody)(uintptr_t, http_HTTPRequestHandle, const char *, uint8_t *, uint32_t);
			http_HTTPCookieContainerHandle(__thiscall *CreateCookieContainer)(uintptr_t, bool);
			bool(__thiscall *ReleaseCookieContainer)(uintptr_t, http_HTTPCookieContainerHandle);
			bool(__thiscall *SetCookie)(uintptr_t, http_HTTPCookieContainerHandle, const char *, const char *, const char *);
			bool(__thiscall *SetHTTPRequestCookieContainer)(uintptr_t, http_HTTPRequestHandle, http_HTTPCookieContainerHandle);
			bool(__thiscall *SetHTTPRequestUserAgentInfo)(uintptr_t, http_HTTPRequestHandle, const char *);
			bool(__thiscall *SetHTTPRequestRequiresVerifiedCertificate)(uintptr_t, http_HTTPRequestHandle, bool);
			bool(__thiscall *SetHTTPRequestAbsoluteTimeoutMS)(uintptr_t, http_HTTPRequestHandle, uint32_t);
			bool(__thiscall *GetHTTPRequestWasTimedOut)(uintptr_t, http_HTTPRequestHandle, bool *pbWasTimedOut);
		};
	]])
end

slot28 = {
	[424.0] = "Method Failure",
	[417.0] = "Expectation Failed",
	[425.0] = "Unordered Collection",
	[444.0] = "No Response",
	[431.0] = "Request Header Fields Too Large",
	[428.0] = "Precondition Required",
	[449.0] = "Retry With",
	[410.0] = "Gone",
	[102.0] = "Processing",
	[206.0] = "Partial Content",
	[402.0] = "Payment Required",
	[598.0] = "Network read timeout error",
	[226.0] = "IM Used",
	[205.0] = "Reset Content",
	[408.0] = "Request Timeout",
	[461.0] = "Unsupported Transport",
	[460.0] = "Only Aggregate Operation Allowed",
	[551.0] = "Option not supported",
	[462.0] = "Destination Unreachable",
	[457.0] = "Invalid Range",
	[456.0] = "Header Field Not Valid for Resource",
	[459.0] = "Aggregate Operation Not Allowed",
	[458.0] = "Parameter Is Read-Only",
	[453.0] = "Not Enough Bandwidth",
	[452.0] = "Conference Not Found",
	[455.0] = "Method Not Valid in This State",
	[454.0] = "Session Not Found",
	[204.0] = "No Content",
	[599.0] = "Network connect timeout error",
	[451.0] = "Redirect",
	[450.0] = "Blocked by Windows Parental Controls",
	[304.0] = "Not Modified",
	[305.0] = "Use Proxy",
	[306.0] = "Switch Proxy",
	[307.0] = "Temporary Redirect",
	[308.0] = "Permanent Redirect",
	[208.0] = "Already Reported",
	[429.0] = "Too Many Requests",
	[300.0] = "Multiple Choices",
	[301.0] = "Moved Permanently",
	[302.0] = "Found",
	[303.0] = "See Other",
	[426.0] = "Upgrade Required",
	[420.0] = "Enhance Your Calm",
	[422.0] = "Unprocessable Entity",
	[423.0] = "Locked",
	[416.0] = "Requested Range Not Satisfiable",
	[201.0] = "Created",
	[418.0] = "I'm a teapot",
	[200.0] = "OK",
	[411.0] = "Length Required",
	[203.0] = "Non-Authoritative Information",
	[409.0] = "Conflict",
	[202.0] = "Accepted",
	[415.0] = "Unsupported Media Type",
	[414.0] = "Request-URI Too Long",
	[413.0] = "Request Entity Too Large",
	[412.0] = "Precondition Failed",
	[403.0] = "Forbidden",
	[207.0] = "Multi-Status",
	[401.0] = "Unauthorized",
	[400.0] = "Bad Request",
	[407.0] = "Proxy Authentication Required",
	[406.0] = "Not Acceptable",
	[405.0] = "Method Not Allowed",
	[404.0] = "Not Found",
	[100.0] = "Continue",
	[101.0] = "Switching Protocols",
	[250.0] = "Low on Storage Space",
	[510.0] = "Not Extended",
	[511.0] = "Network Authentication Required",
	[508.0] = "Loop Detected",
	[509.0] = "Bandwidth Limit Exceeded",
	[506.0] = "Variant Also Negotiates",
	[507.0] = "Insufficient Storage",
	[504.0] = "Gateway Timeout",
	[505.0] = "HTTP Version Not Supported",
	[502.0] = "Bad Gateway",
	[503.0] = "Service Unavailable",
	[500.0] = "Internal Server Error",
	[501.0] = "Not Implemented",
	[499.0] = "Client Closed Request",
	[496.0] = "No Cert",
	[497.0] = "HTTP to HTTPS",
	[494.0] = "Request Header Too Large",
	[495.0] = "Cert Error"
}
slot29 = {
	"params",
	"body",
	"json"
}
slot30 = 2101
slot31 = 2102
slot32 = 2103

function slot34(slot0, slot1)
	return function (...)
		return uv0(uv1, ...)
	end
end

slot35 = slot16([[
struct {
	http_HTTPRequestHandle m_hRequest;
	uint64_t m_ulContextValue;
	bool m_bRequestSuccessful;
	int m_eStatusCode;
	uint32_t m_unBodySize;
} *
]])
slot36 = slot16([[
struct {
	http_HTTPRequestHandle m_hRequest;
	uint64_t m_ulContextValue;
} *
]])
slot37 = slot16([[
struct {
	http_HTTPRequestHandle m_hRequest;
	uint64_t m_ulContextValue;
	uint32_t m_cOffset;
	uint32_t m_cBytesReceived;
} *
]])
slot38 = slot16([[
struct {
	http_HTTPCookieContainerHandle m_hCookieContainer;
}
]])
slot39 = slot16("SteamAPICall_t[1]")
slot40 = slot16("const char[?]")
slot41 = slot16("uint8_t[?]")
slot42 = slot16("unsigned int[?]")
slot43 = slot16("bool[1]")
slot44 = slot16("float[1]")
slot45, slot46 = function ()
	if uv0("uintptr_t*", uv1)[12] == 0 or slot0 == nil then
		return uv2("find_isteamhttp failed")
	end

	if uv0("struct http_ISteamHTTPVtbl**", slot0)[0] == 0 or slot1 == nil then
		return uv2("find_isteamhttp failed")
	end

	return slot0, slot1
end()
slot47 = slot34(slot46.CreateHTTPRequest, slot45)
slot48 = slot34(slot46.SetHTTPRequestContextValue, slot45)
slot49 = slot34(slot46.SetHTTPRequestNetworkActivityTimeout, slot45)
slot50 = slot34(slot46.SetHTTPRequestHeaderValue, slot45)
slot51 = slot34(slot46.SetHTTPRequestGetOrPostParameter, slot45)
slot52 = slot34(slot46.SendHTTPRequest, slot45)
slot53 = slot34(slot46.SendHTTPRequestAndStreamResponse, slot45)
slot54 = slot34(slot46.DeferHTTPRequest, slot45)
slot55 = slot34(slot46.PrioritizeHTTPRequest, slot45)
slot56 = slot34(slot46.GetHTTPResponseHeaderSize, slot45)
slot57 = slot34(slot46.GetHTTPResponseHeaderValue, slot45)
slot58 = slot34(slot46.GetHTTPResponseBodySize, slot45)
slot59 = slot34(slot46.GetHTTPResponseBodyData, slot45)
slot60 = slot34(slot46.GetHTTPStreamingResponseBodyData, slot45)
slot61 = slot34(slot46.ReleaseHTTPRequest, slot45)
slot62 = slot34(slot46.GetHTTPDownloadProgressPct, slot45)
slot63 = slot34(slot46.SetHTTPRequestRawPostBody, slot45)
slot64 = slot34(slot46.CreateCookieContainer, slot45)
slot65 = slot34(slot46.ReleaseCookieContainer, slot45)
slot66 = slot34(slot46.SetCookie, slot45)
slot67 = slot34(slot46.SetHTTPRequestCookieContainer, slot45)
slot68 = slot34(slot46.SetHTTPRequestUserAgentInfo, slot45)
slot69 = slot34(slot46.SetHTTPRequestRequiresVerifiedCertificate, slot45)
slot70 = slot34(slot46.SetHTTPRequestAbsoluteTimeoutMS, slot45)
slot71 = slot34(slot46.GetHTTPRequestWasTimedOut, slot45)
slot72 = {}
slot73 = false
slot74 = false
slot75 = {}
slot76 = false
slot77 = {}
slot78 = slot6({}, {
	__mode = "k"
})
slot79 = slot6({}, {
	__mode = "k"
})
slot80 = slot6({}, {
	__mode = "v"
})
slot81 = {}
slot82 = {
	__metatable = false,
	__index = function (slot0, slot1)
		if uv0[slot0] == nil then
			return
		end

		slot1 = uv1(slot1)

		if slot2.m_hRequest ~= 0 and uv3(slot2.m_hRequest, slot1, uv2(1)) and slot3 ~= nil then
			if slot3[0] < 0 then
				return
			end

			if uv5(slot2.m_hRequest, slot1, uv4(slot3), slot3) then
				slot0[slot1] = uv6(slot4, slot3 - 1)

				return slot0[slot1]
			end
		end
	end
}
slot83 = {
	__metatable = false,
	__index = {
		set_cookie = function (slot0, slot1, slot2, slot3, slot4)
			if uv0[slot0] == nil or slot5.m_hCookieContainer == 0 then
				return
			end

			uv1(slot5.m_hCookieContainer, slot1, slot2, uv2(slot3) .. "=" .. uv2(slot4))
		end
	}
}

function slot84(slot0)
	if slot0.m_hCookieContainer ~= 0 then
		uv0(slot0.m_hCookieContainer)

		slot0.m_hCookieContainer = 0
	end
end

function slot85(slot0)
	if slot0.m_hRequest ~= 0 then
		uv0(slot0.m_hRequest)

		slot0.m_hRequest = 0
	end
end

function slot86(slot0, ...)
	uv0(slot0)

	return uv1(...)
end

function slot87(slot0, slot1, slot2, slot3, ...)
	if uv0[slot0.m_hRequest] == nil then
		uv0[slot0.m_hRequest] = uv1({}, uv2)
	end

	uv3[slot4] = slot0
	slot3.headers = slot4
	uv4 = true

	uv5(slot1, client.error_log, slot2, slot3, ...)

	uv4 = false
end

function slot88(slot0, slot1)
	if slot0 == nil then
		return
	end

	if uv0(uv1, slot0).m_hRequest ~= 0 and uv2[slot2.m_hRequest] ~= nil then
		uv2[slot2.m_hRequest] = nil
		uv3[slot2.m_hRequest] = nil
		uv4[slot2.m_hRequest] = nil

		if slot3 then
			slot7 = slot2.m_unBodySize

			if slot1 == false and slot2.m_bRequestSuccessful and slot7 > 0 then
				if uv6(slot2.m_hRequest, uv5(slot7), slot7) then
					-- Nothing
				end
			elseif not slot2.m_bRequestSuccessful then
				slot8 = uv8()

				uv9(slot2.m_hRequest, slot8)

				slot6.timed_out = slot8 ~= nil and slot8[0] == true
			end

			if slot5 > 0 then
				slot6.status_message = uv10[slot5] or "Unknown status"
			elseif slot1 then
				slot6.status_message = uv11("IO Failure: %s", slot1)
			else
				slot6.status_message = slot6.timed_out and "Timed out" or "Unknown error"
			end

			uv12(slot2, slot3, slot4, {
				status = slot2.m_eStatusCode,
				body = uv7(slot8, slot7)
			})
		end

		uv13(slot2)
	end
end

function slot89(slot0, slot1)
	if slot0 == nil then
		return
	end

	if uv0(uv1, slot0).m_hRequest ~= 0 and uv2[slot2.m_hRequest] then
		uv3(slot2, slot3, slot1 == false, {})
	end
end

function slot90(slot0, slot1)
	if slot0 == nil then
		return
	end

	if uv0(uv1, slot0).m_hRequest ~= 0 then
		slot3 = uv2[slot2.m_hRequest]

		if uv2[slot2.m_hRequest] then
			if uv4(slot2.m_hRequest, uv3()) then
				-- Nothing
			end

			if uv7(slot2.m_hRequest, slot2.m_cOffset, uv6(slot2.m_cBytesReceived), slot2.m_cBytesReceived) then
				slot4.body = uv8(slot6, slot2.m_cBytesReceived)
			end

			uv9(slot2, slot3, slot1 == false, {
				download_progress = uv5(slot5[0])
			})
		end
	end
end

for slot97 in slot10({
	get = slot0.C.k_EHTTPMethodGET,
	head = slot0.C.k_EHTTPMethodHEAD,
	post = slot0.C.k_EHTTPMethodPOST,
	put = slot0.C.k_EHTTPMethodPUT,
	delete = slot0.C.k_EHTTPMethodDELETE,
	options = slot0.C.k_EHTTPMethodOPTIONS,
	patch = slot0.C.k_EHTTPMethodPATCH
}) do
	-- Nothing
end

return {
	request = function (slot0, slot1, slot2, slot3)
		if uv0(slot2) == "function" and slot3 == nil then
			slot3 = slot2
			slot2 = {}
		end

		slot2 = slot2 or {}

		if uv1[uv2(uv3(slot0))] == nil then
			return uv4("invalid HTTP method")
		end

		if uv0(slot1) ~= "string" then
			return uv4("URL has to be a string")
		end

		slot5, slot6, slot7 = nil

		if uv0(slot3) == "function" then
			slot5 = slot3
		elseif uv0(slot3) == "table" then
			slot6 = slot3.headers_received or slot3.headers
			slot7 = slot3.data_received or slot3.data

			if (slot3.completed or slot3.complete) ~= nil and uv0(slot5) ~= "function" then
				return uv4("callbacks.completed callback has to be a function")
			elseif slot6 ~= nil and uv0(slot6) ~= "function" then
				return uv4("callbacks.headers_received callback has to be a function")
			elseif slot7 ~= nil and uv0(slot7) ~= "function" then
				return uv4("callbacks.data_received callback has to be a function")
			end
		else
			return uv4("callbacks has to be a function or table")
		end

		if uv5(slot4, slot1) == 0 then
			return uv4("Failed to create HTTP request")
		end

		for slot13, slot14 in uv6(uv7) do
			if slot2[slot14] ~= nil then
				if false then
					return uv4("can only set options.params, options.body or options.json")
				else
					slot9 = true
				end
			end
		end

		slot10 = nil

		if slot2.json ~= nil then
			slot11 = nil
			slot12, slot10 = uv8(json.stringify, slot2.json)

			if not slot12 then
				return uv4("options.json is invalid: " .. slot10)
			end
		end

		if slot2.network_timeout == nil then
			slot11 = 10
		end

		if uv0(slot11) == "number" and slot11 > 0 then
			if not uv9(slot8, slot11) then
				return uv10(slot8, "failed to set network_timeout")
			end
		elseif slot11 ~= nil then
			return uv10(slot8, "options.network_timeout has to be of type number and greater than 0")
		end

		if slot2.absolute_timeout == nil then
			slot12 = 30
		end

		if uv0(slot12) == "number" and slot12 > 0 then
			if not uv11(slot8, slot12 * 1000) then
				return uv10(slot8, "failed to set absolute_timeout")
			end
		elseif slot12 ~= nil then
			return uv10(slot8, "options.absolute_timeout has to be of type number and greater than 0")
		end

		slot13 = slot10 ~= nil and "application/json" or "text/plain"
		slot14 = nil

		if uv0(slot2.headers) == "table" then
			for slot19, slot20 in uv12(slot15) do
				if uv2(uv3(slot19)) == "content-type" then
					slot13 = uv3(slot20)
				elseif slot21 == "authorization" then
					slot14 = true
				end

				if not uv13(slot8, slot19, slot20) then
					return uv10(slot8, "failed to set header " .. slot19)
				end
			end
		elseif slot15 ~= nil then
			return uv10(slot8, "options.headers has to be of type table")
		end

		if uv0(slot2.authorization) == "table" then
			if slot14 then
				return uv10(slot8, "Cannot set both options.authorization and the 'Authorization' header.")
			end

			if not uv13(slot8, "Authorization", uv14("Basic %s", uv15.encode(uv14("%s:%s", uv3(slot16[1]), uv3(slot16[2])), "base64"))) then
				return uv10(slot8, "failed to apply options.authorization")
			end
		elseif slot16 ~= nil then
			return uv10(slot8, "options.authorization has to be of type table")
		end

		if uv0(slot10 or slot2.body) == "string" then
			if not uv17(slot8, slot13, uv18("unsigned char*", slot17), uv16(slot17)) then
				return uv10(slot8, "failed to set post body")
			end
		elseif slot17 ~= nil then
			return uv10(slot8, "options.body has to be of type string")
		end

		if uv0(slot2.params) == "table" then
			for slot22, slot23 in uv12(slot18) do
				if not uv19(slot8, uv3(slot22 or nil), uv3(slot23)) then
					return uv10(slot8, "failed to set parameter " .. slot22)
				end
			end
		elseif slot18 ~= nil then
			return uv10(slot8, "options.params has to be of type table")
		end

		if uv0(slot2.require_ssl) == "boolean" then
			if not uv20(slot8, slot19 == true) then
				return uv10(slot8, "failed to set require_ssl")
			end
		elseif slot19 ~= nil then
			return uv10(slot8, "options.require_ssl has to be of type boolean")
		end

		if uv0(slot2.user_agent_info) == "string" then
			if not uv21(slot8, uv3(slot20)) then
				return uv10(slot8, "failed to set user_agent_info")
			end
		elseif slot20 ~= nil then
			return uv10(slot8, "options.user_agent_info has to be of type string")
		end

		if uv0(slot2.cookie_container) == "table" then
			if uv22[slot21] ~= nil and slot22.m_hCookieContainer ~= 0 then
				if not uv23(slot8, slot22.m_hCookieContainer) then
					return uv10(slot8, "failed to set user_agent_info")
				end
			else
				return uv10(slot8, "options.cookie_container has to a valid cookie container")
			end
		elseif slot21 ~= nil then
			return uv10(slot8, "options.cookie_container has to a valid cookie container")
		end

		slot22 = uv24

		if uv0(slot2.stream_response) == "boolean" then
			if slot23 then
				slot22 = uv25

				if slot5 == nil and slot6 == nil and slot7 == nil then
					return uv10(slot8, "a 'completed', 'headers_received' or 'data_received' callback is required")
				end
			elseif slot5 == nil then
				return uv10(slot8, "'completed' callback has to be set for non-streamed requests")
			elseif slot6 ~= nil or slot7 ~= nil then
				return uv10(slot8, "non-streamed requests only support 'completed' callbacks")
			end
		elseif slot23 ~= nil then
			return uv10(slot8, "options.stream_response has to be of type boolean")
		end

		if slot6 ~= nil or slot7 ~= nil then
			uv26[slot8] = slot6 or false

			if slot6 ~= nil and not uv27 then
				uv28(uv29, uv30)

				uv27 = true
			end

			uv31[slot8] = slot7 or false

			if slot7 ~= nil and not uv32 then
				uv28(uv33, uv34)

				uv32 = true
			end
		end

		if not slot22(slot8, uv35()) then
			uv36(slot8)

			if slot5 ~= nil then
				slot5(false, {
					status_message = "Failed to send request",
					status = 0
				})
			end

			return
		end

		if slot2.priority == "defer" or slot2.priority == "prioritize" then
			if not slot2.priority == "prioritize" and uv37 or uv38(slot8) then
				return uv10(slot8, "failed to set priority")
			end
		elseif slot2.priority ~= nil then
			return uv10(slot8, "options.priority has to be 'defer' of 'prioritize'")
		end

		uv39[slot8] = slot5 or false

		if slot5 ~= nil then
			uv40(slot24[0], uv41, uv42)
		end
	end,
	create_cookie_container = function (slot0)
		if slot0 ~= nil and uv0(slot0) ~= "boolean" then
			return uv1("allow_modification has to be of type boolean")
		end

		if uv2(slot0 == true) ~= nil then
			slot2 = uv3(slot1)

			uv4(slot2, uv5)

			slot3 = uv6({}, uv7)
			uv8[slot3] = slot2

			return slot3
		end
	end,
	[slot97] = function (...)
		return uv0(uv1, ...)
	end
}
