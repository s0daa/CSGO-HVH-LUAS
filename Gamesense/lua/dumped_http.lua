-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = require("ffi")
local var_0_1 = require("gamesense/base64")
local var_0_2 = assert
local var_0_3 = pcall
local var_0_4 = xpcall
local var_0_5 = error
local var_0_6 = setmetatable
local var_0_7 = tostring
local var_0_8 = tonumber
local var_0_9 = type
local var_0_10 = pairs
local var_0_11 = ipairs
local var_0_12 = client.log
local var_0_13 = client.delay_call
local var_0_14 = ui.get
local var_0_15 = string.format
local var_0_16 = var_0_0.typeof
local var_0_17 = var_0_0.sizeof
local var_0_18 = var_0_0.cast
local var_0_19 = var_0_0.cdef
local var_0_20 = var_0_0.string
local var_0_21 = var_0_0.gc
local var_0_22 = string.lower
local var_0_23 = string.len
local var_0_24
local var_0_25
local var_0_26

if not var_0_3(var_0_0.sizeof, "SteamAPICall_t") then
	var_0_19("\t\t\ttypedef uint64_t SteamAPICall_t;\n\n\t\t\tstruct SteamAPI_callback_base_vtbl {\n\t\t\t\tvoid(__thiscall *run1)(struct SteamAPI_callback_base *, void *, bool, uint64_t);\n\t\t\t\tvoid(__thiscall *run2)(struct SteamAPI_callback_base *, void *);\n\t\t\t\tint(__thiscall *get_size)(struct SteamAPI_callback_base *);\n\t\t\t};\n\n\t\t\tstruct SteamAPI_callback_base {\n\t\t\t\tstruct SteamAPI_callback_base_vtbl *vtbl;\n\t\t\t\tuint8_t flags;\n\t\t\t\tint id;\n\t\t\t\tuint64_t api_call_handle;\n\t\t\t\tstruct SteamAPI_callback_base_vtbl vtbl_storage[1];\n\t\t\t};\n\t\t")
end

local var_0_27 = {
	[0] = "Steam gone",
	"Network failure",
	"Invalid handle",
	[-1] = "No failure",
	[3] = "Mismatched callback"
}
local var_0_28
local var_0_29
local var_0_30
local var_0_31
local var_0_32
local var_0_33 = var_0_16("struct SteamAPI_callback_base")
local var_0_34 = var_0_17(var_0_33)
local var_0_35 = var_0_16("struct SteamAPI_callback_base[1]")
local var_0_36 = var_0_16("struct SteamAPI_callback_base*")
local var_0_37 = var_0_16("uintptr_t")
local var_0_38 = {}
local var_0_39 = {}
local var_0_40 = {}

local function var_0_41(arg_1_0)
	return var_0_7(var_0_8(var_0_18(var_0_37, arg_1_0)))
end

local function var_0_42(arg_2_0, arg_2_1, arg_2_2)
	arg_2_2 = arg_2_2 and (var_0_27[var_0_32(arg_2_0.api_call_handle)] or "Unknown error")
	arg_2_0.api_call_handle = 0

	var_0_4(function()
		local var_3_0 = var_0_41(arg_2_0)
		local var_3_1 = var_0_38[var_3_0]

		if var_3_1 ~= nil then
			var_0_4(var_3_1, client.error_log, arg_2_1, arg_2_2)
		end

		if var_0_39[var_3_0] ~= nil then
			var_0_38[var_3_0] = nil
			var_0_39[var_3_0] = nil
		end
	end, client.error_log)
end

local function var_0_43(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if arg_4_3 == arg_4_0.api_call_handle then
		var_0_42(arg_4_0, arg_4_1, arg_4_2)
	end
end

local function var_0_44(arg_5_0, arg_5_1)
	var_0_42(arg_5_0, arg_5_1, false)
end

local function var_0_45(arg_6_0)
	return var_0_34
end

local function var_0_46(arg_7_0)
	if arg_7_0.api_call_handle ~= 0 then
		var_0_29(arg_7_0, arg_7_0.api_call_handle)

		arg_7_0.api_call_handle = 0

		local var_7_0 = var_0_41(arg_7_0)

		var_0_38[var_7_0] = nil
		var_0_39[var_7_0] = nil
	end
end

var_0_3(var_0_0.metatype, var_0_33, {
	__gc = var_0_46,
	__index = {
		cancel = var_0_46
	}
})

local var_0_47 = var_0_18("void(__thiscall *)(struct SteamAPI_callback_base *, void *, bool, uint64_t)", var_0_43)
local var_0_48 = var_0_18("void(__thiscall *)(struct SteamAPI_callback_base *, void *)", var_0_44)
local var_0_49 = var_0_18("int(__thiscall *)(struct SteamAPI_callback_base *)", var_0_45)

local function var_0_50(arg_8_0, arg_8_1, arg_8_2)
	var_0_2(arg_8_0 ~= 0)

	local var_8_0 = var_0_35()
	local var_8_1 = var_0_18(var_0_36, var_8_0)

	var_8_1.vtbl_storage[0].run1 = var_0_47
	var_8_1.vtbl_storage[0].run2 = var_0_48
	var_8_1.vtbl_storage[0].get_size = var_0_49
	var_8_1.vtbl = var_8_1.vtbl_storage
	var_8_1.api_call_handle = arg_8_0
	var_8_1.id = arg_8_2

	local var_8_2 = var_0_41(var_8_1)

	var_0_38[var_8_2] = arg_8_1
	var_0_39[var_8_2] = var_8_0

	var_0_28(var_8_1, arg_8_0)

	return var_8_1
end

local function var_0_51(arg_9_0, arg_9_1)
	var_0_2(var_0_40[arg_9_0] == nil)

	local var_9_0 = var_0_35()
	local var_9_1 = var_0_18(var_0_36, var_9_0)

	var_9_1.vtbl_storage[0].run1 = var_0_47
	var_9_1.vtbl_storage[0].run2 = var_0_48
	var_9_1.vtbl_storage[0].get_size = var_0_49
	var_9_1.vtbl = var_9_1.vtbl_storage
	var_9_1.api_call_handle = 0
	var_9_1.id = arg_9_0

	local var_9_2 = var_0_41(var_9_1)

	var_0_38[var_9_2] = arg_9_1
	var_0_40[arg_9_0] = var_9_0

	var_0_30(var_9_1, arg_9_0)
end

local function var_0_52(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = client.find_signature(arg_10_0, arg_10_1) or var_0_5("signature not found", 2)
	local var_10_1 = var_0_18("uintptr_t", var_10_0)

	if arg_10_3 ~= nil and arg_10_3 ~= 0 then
		var_10_1 = var_10_1 + arg_10_3
	end

	if arg_10_4 ~= nil then
		for iter_10_0 = 1, arg_10_4 do
			var_10_1 = var_0_18("uintptr_t*", var_10_1)[0]

			if var_10_1 == nil then
				return var_0_5("signature not found")
			end
		end
	end

	return var_0_18(arg_10_2, var_10_1)
end

local function var_0_53(arg_11_0, arg_11_1, arg_11_2)
	return var_0_18(arg_11_2, var_0_18("void***", arg_11_0)[0][arg_11_1])
end

var_0_28 = var_0_52("steam_api.dll", "U\x8B\xEC\x83=\xCC\xCC\xCC\xCC\xCC~\rh\xCC\xCC\xCC\xCC\xFF\x15\xCC\xCC\xCC\xCC]\xC3\xFFu\x10", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")
var_0_29 = var_0_52("steam_api.dll", "U\x8B\xEC\xFFu\x10\xFFu\f", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")
var_0_30 = var_0_52("steam_api.dll", "U\x8B\xEC\x83=\xCC\xCC\xCC\xCC\xCC~\rh\xCC\xCC\xCC\xCC\xFF\x15\xCC\xCC\xCC\xCC]\xC3\xC7\x05", "void(__cdecl*)(struct SteamAPI_callback_base *, int)")

local var_0_54 = var_0_52("steam_api.dll", "U\x8B\xEC\x83\xEC\f\x80=\xCC\xCC\xCC\xCC\xCC\x0F\x84", "void(__cdecl*)(struct SteamAPI_callback_base *)")
local var_0_55 = var_0_52("client_panorama.dll", "\xB9\xCC\xCC\xCC\xCC\xE8\xCC\xCC\xCC̃=\xCC\xCC\xCC\xCC\xCC\x0F\x84", "uintptr_t", 1, 1)
local var_0_56 = var_0_18("uintptr_t*", var_0_55)[3]
local var_0_57 = var_0_53(var_0_56, 12, "int(__thiscall*)(void*, SteamAPICall_t)")

function var_0_32(arg_12_0)
	return var_0_57(var_0_56, arg_12_0)
end

client.set_event_callback("shutdown", function()
	for iter_13_0, iter_13_1 in var_0_10(var_0_39) do
		local var_13_0 = var_0_18(var_0_36, iter_13_1)

		var_0_46(var_13_0)
	end

	for iter_13_2, iter_13_3 in var_0_10(var_0_40) do
		local var_13_1 = var_0_18(var_0_36, iter_13_3)

		var_0_54(var_13_1)
	end
end)

if not var_0_3(var_0_17, "http_HTTPRequestHandle") then
	var_0_19("\t\ttypedef uint32_t http_HTTPRequestHandle;\n\t\ttypedef uint32_t http_HTTPCookieContainerHandle;\n\n\t\tenum http_EHTTPMethod {\n\t\t\tk_EHTTPMethodInvalid,\n\t\t\tk_EHTTPMethodGET,\n\t\t\tk_EHTTPMethodHEAD,\n\t\t\tk_EHTTPMethodPOST,\n\t\t\tk_EHTTPMethodPUT,\n\t\t\tk_EHTTPMethodDELETE,\n\t\t\tk_EHTTPMethodOPTIONS,\n\t\t\tk_EHTTPMethodPATCH,\n\t\t};\n\n\t\tstruct http_ISteamHTTPVtbl {\n\t\t\thttp_HTTPRequestHandle(__thiscall *CreateHTTPRequest)(uintptr_t, enum http_EHTTPMethod, const char *);\n\t\t\tbool(__thiscall *SetHTTPRequestContextValue)(uintptr_t, http_HTTPRequestHandle, uint64_t);\n\t\t\tbool(__thiscall *SetHTTPRequestNetworkActivityTimeout)(uintptr_t, http_HTTPRequestHandle, uint32_t);\n\t\t\tbool(__thiscall *SetHTTPRequestHeaderValue)(uintptr_t, http_HTTPRequestHandle, const char *, const char *);\n\t\t\tbool(__thiscall *SetHTTPRequestGetOrPostParameter)(uintptr_t, http_HTTPRequestHandle, const char *, const char *);\n\t\t\tbool(__thiscall *SendHTTPRequest)(uintptr_t, http_HTTPRequestHandle, SteamAPICall_t *);\n\t\t\tbool(__thiscall *SendHTTPRequestAndStreamResponse)(uintptr_t, http_HTTPRequestHandle, SteamAPICall_t *);\n\t\t\tbool(__thiscall *DeferHTTPRequest)(uintptr_t, http_HTTPRequestHandle);\n\t\t\tbool(__thiscall *PrioritizeHTTPRequest)(uintptr_t, http_HTTPRequestHandle);\n\t\t\tbool(__thiscall *GetHTTPResponseHeaderSize)(uintptr_t, http_HTTPRequestHandle, const char *, uint32_t *);\n\t\t\tbool(__thiscall *GetHTTPResponseHeaderValue)(uintptr_t, http_HTTPRequestHandle, const char *, uint8_t *, uint32_t);\n\t\t\tbool(__thiscall *GetHTTPResponseBodySize)(uintptr_t, http_HTTPRequestHandle, uint32_t *);\n\t\t\tbool(__thiscall *GetHTTPResponseBodyData)(uintptr_t, http_HTTPRequestHandle, uint8_t *, uint32_t);\n\t\t\tbool(__thiscall *GetHTTPStreamingResponseBodyData)(uintptr_t, http_HTTPRequestHandle, uint32_t, uint8_t *, uint32_t);\n\t\t\tbool(__thiscall *ReleaseHTTPRequest)(uintptr_t, http_HTTPRequestHandle);\n\t\t\tbool(__thiscall *GetHTTPDownloadProgressPct)(uintptr_t, http_HTTPRequestHandle, float *);\n\t\t\tbool(__thiscall *SetHTTPRequestRawPostBody)(uintptr_t, http_HTTPRequestHandle, const char *, uint8_t *, uint32_t);\n\t\t\thttp_HTTPCookieContainerHandle(__thiscall *CreateCookieContainer)(uintptr_t, bool);\n\t\t\tbool(__thiscall *ReleaseCookieContainer)(uintptr_t, http_HTTPCookieContainerHandle);\n\t\t\tbool(__thiscall *SetCookie)(uintptr_t, http_HTTPCookieContainerHandle, const char *, const char *, const char *);\n\t\t\tbool(__thiscall *SetHTTPRequestCookieContainer)(uintptr_t, http_HTTPRequestHandle, http_HTTPCookieContainerHandle);\n\t\t\tbool(__thiscall *SetHTTPRequestUserAgentInfo)(uintptr_t, http_HTTPRequestHandle, const char *);\n\t\t\tbool(__thiscall *SetHTTPRequestRequiresVerifiedCertificate)(uintptr_t, http_HTTPRequestHandle, bool);\n\t\t\tbool(__thiscall *SetHTTPRequestAbsoluteTimeoutMS)(uintptr_t, http_HTTPRequestHandle, uint32_t);\n\t\t\tbool(__thiscall *GetHTTPRequestWasTimedOut)(uintptr_t, http_HTTPRequestHandle, bool *pbWasTimedOut);\n\t\t};\n\t")
end

local var_0_58 = {
	get = var_0_0.C.k_EHTTPMethodGET,
	head = var_0_0.C.k_EHTTPMethodHEAD,
	post = var_0_0.C.k_EHTTPMethodPOST,
	put = var_0_0.C.k_EHTTPMethodPUT,
	delete = var_0_0.C.k_EHTTPMethodDELETE,
	options = var_0_0.C.k_EHTTPMethodOPTIONS,
	patch = var_0_0.C.k_EHTTPMethodPATCH
}
local var_0_59 = {
	[424] = "Method Failure",
	[417] = "Expectation Failed",
	[425] = "Unordered Collection",
	[444] = "No Response",
	[431] = "Request Header Fields Too Large",
	[428] = "Precondition Required",
	[449] = "Retry With",
	[410] = "Gone",
	[102] = "Processing",
	[206] = "Partial Content",
	[402] = "Payment Required",
	[598] = "Network read timeout error",
	[226] = "IM Used",
	[205] = "Reset Content",
	[408] = "Request Timeout",
	[461] = "Unsupported Transport",
	[460] = "Only Aggregate Operation Allowed",
	[551] = "Option not supported",
	[462] = "Destination Unreachable",
	[457] = "Invalid Range",
	[456] = "Header Field Not Valid for Resource",
	[459] = "Aggregate Operation Not Allowed",
	[458] = "Parameter Is Read-Only",
	[453] = "Not Enough Bandwidth",
	[452] = "Conference Not Found",
	[455] = "Method Not Valid in This State",
	[454] = "Session Not Found",
	[204] = "No Content",
	[599] = "Network connect timeout error",
	[451] = "Redirect",
	[450] = "Blocked by Windows Parental Controls",
	[304] = "Not Modified",
	[305] = "Use Proxy",
	[306] = "Switch Proxy",
	[307] = "Temporary Redirect",
	[308] = "Permanent Redirect",
	[208] = "Already Reported",
	[429] = "Too Many Requests",
	[300] = "Multiple Choices",
	[301] = "Moved Permanently",
	[302] = "Found",
	[303] = "See Other",
	[426] = "Upgrade Required",
	[420] = "Enhance Your Calm",
	[422] = "Unprocessable Entity",
	[423] = "Locked",
	[416] = "Requested Range Not Satisfiable",
	[201] = "Created",
	[418] = "I'm a teapot",
	[200] = "OK",
	[411] = "Length Required",
	[203] = "Non-Authoritative Information",
	[409] = "Conflict",
	[202] = "Accepted",
	[415] = "Unsupported Media Type",
	[414] = "Request-URI Too Long",
	[413] = "Request Entity Too Large",
	[412] = "Precondition Failed",
	[403] = "Forbidden",
	[207] = "Multi-Status",
	[401] = "Unauthorized",
	[400] = "Bad Request",
	[407] = "Proxy Authentication Required",
	[406] = "Not Acceptable",
	[405] = "Method Not Allowed",
	[404] = "Not Found",
	[100] = "Continue",
	[101] = "Switching Protocols",
	[250] = "Low on Storage Space",
	[510] = "Not Extended",
	[511] = "Network Authentication Required",
	[508] = "Loop Detected",
	[509] = "Bandwidth Limit Exceeded",
	[506] = "Variant Also Negotiates",
	[507] = "Insufficient Storage",
	[504] = "Gateway Timeout",
	[505] = "HTTP Version Not Supported",
	[502] = "Bad Gateway",
	[503] = "Service Unavailable",
	[500] = "Internal Server Error",
	[501] = "Not Implemented",
	[499] = "Client Closed Request",
	[496] = "No Cert",
	[497] = "HTTP to HTTPS",
	[494] = "Request Header Too Large",
	[495] = "Cert Error"
}
local var_0_60 = {
	"params",
	"body",
	"json"
}
local var_0_61 = 2101
local var_0_62 = 2102
local var_0_63 = 2103

local function var_0_64()
	local var_14_0 = var_0_18("uintptr_t*", var_0_55)[12]

	if var_14_0 == 0 or var_14_0 == nil then
		return var_0_5("find_isteamhttp failed")
	end

	local var_14_1 = var_0_18("struct http_ISteamHTTPVtbl**", var_14_0)[0]

	if var_14_1 == 0 or var_14_1 == nil then
		return var_0_5("find_isteamhttp failed")
	end

	return var_14_0, var_14_1
end

local function var_0_65(arg_15_0, arg_15_1)
	return function(...)
		return arg_15_0(arg_15_1, ...)
	end
end

local var_0_66 = var_0_16("struct {\n\thttp_HTTPRequestHandle m_hRequest;\n\tuint64_t m_ulContextValue;\n\tbool m_bRequestSuccessful;\n\tint m_eStatusCode;\n\tuint32_t m_unBodySize;\n} *\n")
local var_0_67 = var_0_16("struct {\n\thttp_HTTPRequestHandle m_hRequest;\n\tuint64_t m_ulContextValue;\n} *\n")
local var_0_68 = var_0_16("struct {\n\thttp_HTTPRequestHandle m_hRequest;\n\tuint64_t m_ulContextValue;\n\tuint32_t m_cOffset;\n\tuint32_t m_cBytesReceived;\n} *\n")
local var_0_69 = var_0_16("struct {\n\thttp_HTTPCookieContainerHandle m_hCookieContainer;\n}\n")
local var_0_70 = var_0_16("SteamAPICall_t[1]")
local var_0_71 = var_0_16("const char[?]")
local var_0_72 = var_0_16("uint8_t[?]")
local var_0_73 = var_0_16("unsigned int[?]")
local var_0_74 = var_0_16("bool[1]")
local var_0_75 = var_0_16("float[1]")
local var_0_76, var_0_77 = var_0_64()
local var_0_78 = var_0_65(var_0_77.CreateHTTPRequest, var_0_76)
local var_0_79 = var_0_65(var_0_77.SetHTTPRequestContextValue, var_0_76)
local var_0_80 = var_0_65(var_0_77.SetHTTPRequestNetworkActivityTimeout, var_0_76)
local var_0_81 = var_0_65(var_0_77.SetHTTPRequestHeaderValue, var_0_76)
local var_0_82 = var_0_65(var_0_77.SetHTTPRequestGetOrPostParameter, var_0_76)
local var_0_83 = var_0_65(var_0_77.SendHTTPRequest, var_0_76)
local var_0_84 = var_0_65(var_0_77.SendHTTPRequestAndStreamResponse, var_0_76)
local var_0_85 = var_0_65(var_0_77.DeferHTTPRequest, var_0_76)
local var_0_86 = var_0_65(var_0_77.PrioritizeHTTPRequest, var_0_76)
local var_0_87 = var_0_65(var_0_77.GetHTTPResponseHeaderSize, var_0_76)
local var_0_88 = var_0_65(var_0_77.GetHTTPResponseHeaderValue, var_0_76)
local var_0_89 = var_0_65(var_0_77.GetHTTPResponseBodySize, var_0_76)
local var_0_90 = var_0_65(var_0_77.GetHTTPResponseBodyData, var_0_76)
local var_0_91 = var_0_65(var_0_77.GetHTTPStreamingResponseBodyData, var_0_76)
local var_0_92 = var_0_65(var_0_77.ReleaseHTTPRequest, var_0_76)
local var_0_93 = var_0_65(var_0_77.GetHTTPDownloadProgressPct, var_0_76)
local var_0_94 = var_0_65(var_0_77.SetHTTPRequestRawPostBody, var_0_76)
local var_0_95 = var_0_65(var_0_77.CreateCookieContainer, var_0_76)
local var_0_96 = var_0_65(var_0_77.ReleaseCookieContainer, var_0_76)
local var_0_97 = var_0_65(var_0_77.SetCookie, var_0_76)
local var_0_98 = var_0_65(var_0_77.SetHTTPRequestCookieContainer, var_0_76)
local var_0_99 = var_0_65(var_0_77.SetHTTPRequestUserAgentInfo, var_0_76)
local var_0_100 = var_0_65(var_0_77.SetHTTPRequestRequiresVerifiedCertificate, var_0_76)
local var_0_101 = var_0_65(var_0_77.SetHTTPRequestAbsoluteTimeoutMS, var_0_76)
local var_0_102 = var_0_65(var_0_77.GetHTTPRequestWasTimedOut, var_0_76)
local var_0_103 = {}
local var_0_104 = false
local var_0_105 = false
local var_0_106 = {}
local var_0_107 = false
local var_0_108 = {}
local var_0_109 = var_0_6({}, {
	__mode = "k"
})
local var_0_110 = var_0_6({}, {
	__mode = "k"
})
local var_0_111 = var_0_6({}, {
	__mode = "v"
})
local var_0_112 = {}
local var_0_113 = {
	__metatable = false,
	__index = function(arg_17_0, arg_17_1)
		local var_17_0 = var_0_110[arg_17_0]

		if var_17_0 == nil then
			return
		end

		arg_17_1 = var_0_7(arg_17_1)

		if var_17_0.m_hRequest ~= 0 then
			local var_17_1 = var_0_73(1)

			if var_0_87(var_17_0.m_hRequest, arg_17_1, var_17_1) and var_17_1 ~= nil then
				local var_17_2 = var_17_1[0]

				if var_17_2 < 0 then
					return
				end

				local var_17_3 = var_0_72(var_17_2)

				if var_0_88(var_17_0.m_hRequest, arg_17_1, var_17_3, var_17_2) then
					arg_17_0[arg_17_1] = var_0_20(var_17_3, var_17_2 - 1)

					return arg_17_0[arg_17_1]
				end
			end
		end
	end
}
local var_0_114 = {
	__metatable = false,
	__index = {
		set_cookie = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
			local var_18_0 = var_0_109[arg_18_0]

			if var_18_0 == nil or var_18_0.m_hCookieContainer == 0 then
				return
			end

			var_0_97(var_18_0.m_hCookieContainer, arg_18_1, arg_18_2, var_0_7(arg_18_3) .. "=" .. var_0_7(arg_18_4))
		end
	}
}

local function var_0_115(arg_19_0)
	if arg_19_0.m_hCookieContainer ~= 0 then
		var_0_96(arg_19_0.m_hCookieContainer)

		arg_19_0.m_hCookieContainer = 0
	end
end

local function var_0_116(arg_20_0)
	if arg_20_0.m_hRequest ~= 0 then
		var_0_92(arg_20_0.m_hRequest)

		arg_20_0.m_hRequest = 0
	end
end

local function var_0_117(arg_21_0, ...)
	var_0_92(arg_21_0)

	return var_0_5(...)
end

local function var_0_118(arg_22_0, arg_22_1, arg_22_2, arg_22_3, ...)
	local var_22_0 = var_0_111[arg_22_0.m_hRequest]

	if var_22_0 == nil then
		var_22_0 = var_0_6({}, var_0_113)
		var_0_111[arg_22_0.m_hRequest] = var_22_0
	end

	var_0_110[var_22_0] = arg_22_0
	arg_22_3.headers = var_22_0
	var_0_104 = true

	var_0_4(arg_22_1, client.error_log, arg_22_2, arg_22_3, ...)

	var_0_104 = false
end

local function var_0_119(arg_23_0, arg_23_1)
	if arg_23_0 == nil then
		return
	end

	local var_23_0 = var_0_18(var_0_66, arg_23_0)

	if var_23_0.m_hRequest ~= 0 then
		local var_23_1 = var_0_103[var_23_0.m_hRequest]

		if var_23_1 ~= nil then
			var_0_103[var_23_0.m_hRequest] = nil
			var_0_108[var_23_0.m_hRequest] = nil
			var_0_106[var_23_0.m_hRequest] = nil

			if var_23_1 then
				local var_23_2 = arg_23_1 == false and var_23_0.m_bRequestSuccessful
				local var_23_3 = var_23_0.m_eStatusCode
				local var_23_4 = {
					status = var_23_3
				}
				local var_23_5 = var_23_0.m_unBodySize

				if var_23_2 and var_23_5 > 0 then
					local var_23_6 = var_0_72(var_23_5)

					if var_0_90(var_23_0.m_hRequest, var_23_6, var_23_5) then
						var_23_4.body = var_0_20(var_23_6, var_23_5)
					end
				elseif not var_23_0.m_bRequestSuccessful then
					local var_23_7 = var_0_74()

					var_0_102(var_23_0.m_hRequest, var_23_7)

					var_23_4.timed_out = var_23_7 ~= nil and var_23_7[0] == true
				end

				if var_23_3 > 0 then
					var_23_4.status_message = var_0_59[var_23_3] or "Unknown status"
				elseif arg_23_1 then
					var_23_4.status_message = var_0_15("IO Failure: %s", arg_23_1)
				else
					var_23_4.status_message = var_23_4.timed_out and "Timed out" or "Unknown error"
				end

				var_0_118(var_23_0, var_23_1, var_23_2, var_23_4)
			end

			var_0_116(var_23_0)
		end
	end
end

local function var_0_120(arg_24_0, arg_24_1)
	if arg_24_0 == nil then
		return
	end

	local var_24_0 = var_0_18(var_0_67, arg_24_0)

	if var_24_0.m_hRequest ~= 0 then
		local var_24_1 = var_0_106[var_24_0.m_hRequest]

		if var_24_1 then
			var_0_118(var_24_0, var_24_1, arg_24_1 == false, {})
		end
	end
end

local function var_0_121(arg_25_0, arg_25_1)
	if arg_25_0 == nil then
		return
	end

	local var_25_0 = var_0_18(var_0_68, arg_25_0)

	if var_25_0.m_hRequest ~= 0 then
		local var_25_1 = var_0_108[var_25_0.m_hRequest]

		if var_0_108[var_25_0.m_hRequest] then
			local var_25_2 = {}
			local var_25_3 = var_0_75()

			if var_0_93(var_25_0.m_hRequest, var_25_3) then
				var_25_2.download_progress = var_0_8(var_25_3[0])
			end

			local var_25_4 = var_0_72(var_25_0.m_cBytesReceived)

			if var_0_91(var_25_0.m_hRequest, var_25_0.m_cOffset, var_25_4, var_25_0.m_cBytesReceived) then
				var_25_2.body = var_0_20(var_25_4, var_25_0.m_cBytesReceived)
			end

			var_0_118(var_25_0, var_25_1, arg_25_1 == false, var_25_2)
		end
	end
end

local function var_0_122(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if var_0_9(arg_26_2) == "function" and arg_26_3 == nil then
		arg_26_3 = arg_26_2
		arg_26_2 = {}
	end

	arg_26_2 = arg_26_2 or {}

	local var_26_0 = var_0_58[var_0_22(var_0_7(arg_26_0))]

	if var_26_0 == nil then
		return var_0_5("invalid HTTP method")
	end

	if var_0_9(arg_26_1) ~= "string" then
		return var_0_5("URL has to be a string")
	end

	local var_26_1
	local var_26_2
	local var_26_3

	if var_0_9(arg_26_3) == "function" then
		var_26_1 = arg_26_3
	elseif var_0_9(arg_26_3) == "table" then
		var_26_1 = arg_26_3.completed or arg_26_3.complete
		var_26_2 = arg_26_3.headers_received or arg_26_3.headers
		var_26_3 = arg_26_3.data_received or arg_26_3.data

		if var_26_1 ~= nil and var_0_9(var_26_1) ~= "function" then
			return var_0_5("callbacks.completed callback has to be a function")
		elseif var_26_2 ~= nil and var_0_9(var_26_2) ~= "function" then
			return var_0_5("callbacks.headers_received callback has to be a function")
		elseif var_26_3 ~= nil and var_0_9(var_26_3) ~= "function" then
			return var_0_5("callbacks.data_received callback has to be a function")
		end
	else
		return var_0_5("callbacks has to be a function or table")
	end

	local var_26_4 = var_0_78(var_26_0, arg_26_1)

	if var_26_4 == 0 then
		return var_0_5("Failed to create HTTP request")
	end

	local var_26_5 = false

	for iter_26_0, iter_26_1 in var_0_11(var_0_60) do
		if arg_26_2[iter_26_1] ~= nil then
			if var_26_5 then
				return var_0_5("can only set options.params, options.body or options.json")
			else
				var_26_5 = true
			end
		end
	end

	local var_26_6

	if arg_26_2.json ~= nil then
		local var_26_7
		local var_26_8, var_26_9 = var_0_3(json.stringify, arg_26_2.json)

		var_26_6 = var_26_9

		if not var_26_8 then
			return var_0_5("options.json is invalid: " .. var_26_6)
		end
	end

	local var_26_10 = arg_26_2.network_timeout

	if var_26_10 == nil then
		var_26_10 = 10
	end

	if var_0_9(var_26_10) == "number" and var_26_10 > 0 then
		if not var_0_80(var_26_4, var_26_10) then
			return var_0_117(var_26_4, "failed to set network_timeout")
		end
	elseif var_26_10 ~= nil then
		return var_0_117(var_26_4, "options.network_timeout has to be of type number and greater than 0")
	end

	local var_26_11 = arg_26_2.absolute_timeout

	if var_26_11 == nil then
		var_26_11 = 30
	end

	if var_0_9(var_26_11) == "number" and var_26_11 > 0 then
		if not var_0_101(var_26_4, var_26_11 * 1000) then
			return var_0_117(var_26_4, "failed to set absolute_timeout")
		end
	elseif var_26_11 ~= nil then
		return var_0_117(var_26_4, "options.absolute_timeout has to be of type number and greater than 0")
	end

	local var_26_12 = var_26_6 ~= nil and "application/json" or "text/plain"
	local var_26_13
	local var_26_14 = arg_26_2.headers

	if var_0_9(var_26_14) == "table" then
		for iter_26_2, iter_26_3 in var_0_10(var_26_14) do
			iter_26_2 = var_0_7(iter_26_2)
			iter_26_3 = var_0_7(iter_26_3)

			local var_26_15 = var_0_22(iter_26_2)

			if var_26_15 == "content-type" then
				var_26_12 = iter_26_3
			elseif var_26_15 == "authorization" then
				var_26_13 = true
			end

			if not var_0_81(var_26_4, iter_26_2, iter_26_3) then
				return var_0_117(var_26_4, "failed to set header " .. iter_26_2)
			end
		end
	elseif var_26_14 ~= nil then
		return var_0_117(var_26_4, "options.headers has to be of type table")
	end

	local var_26_16 = arg_26_2.authorization

	if var_0_9(var_26_16) == "table" then
		if var_26_13 then
			return var_0_117(var_26_4, "Cannot set both options.authorization and the 'Authorization' header.")
		end

		local var_26_17 = var_26_16[1]
		local var_26_18 = var_26_16[2]
		local var_26_19 = var_0_15("Basic %s", var_0_1.encode(var_0_15("%s:%s", var_0_7(var_26_17), var_0_7(var_26_18)), "base64"))

		if not var_0_81(var_26_4, "Authorization", var_26_19) then
			return var_0_117(var_26_4, "failed to apply options.authorization")
		end
	elseif var_26_16 ~= nil then
		return var_0_117(var_26_4, "options.authorization has to be of type table")
	end

	local var_26_20 = var_26_6 or arg_26_2.body

	if var_0_9(var_26_20) == "string" then
		local var_26_21 = var_0_23(var_26_20)

		if not var_0_94(var_26_4, var_26_12, var_0_18("unsigned char*", var_26_20), var_26_21) then
			return var_0_117(var_26_4, "failed to set post body")
		end
	elseif var_26_20 ~= nil then
		return var_0_117(var_26_4, "options.body has to be of type string")
	end

	local var_26_22 = arg_26_2.params

	if var_0_9(var_26_22) == "table" then
		for iter_26_4, iter_26_5 in var_0_10(var_26_22) do
			iter_26_4 = var_0_7(iter_26_4 or nil)

			if not var_0_82(var_26_4, iter_26_4, var_0_7(iter_26_5)) then
				return var_0_117(var_26_4, "failed to set parameter " .. iter_26_4)
			end
		end
	elseif var_26_22 ~= nil then
		return var_0_117(var_26_4, "options.params has to be of type table")
	end

	local var_26_23 = arg_26_2.require_ssl

	if var_0_9(var_26_23) == "boolean" then
		if not var_0_100(var_26_4, var_26_23 == true) then
			return var_0_117(var_26_4, "failed to set require_ssl")
		end
	elseif var_26_23 ~= nil then
		return var_0_117(var_26_4, "options.require_ssl has to be of type boolean")
	end

	local var_26_24 = arg_26_2.user_agent_info

	if var_0_9(var_26_24) == "string" then
		if not var_0_99(var_26_4, var_0_7(var_26_24)) then
			return var_0_117(var_26_4, "failed to set user_agent_info")
		end
	elseif var_26_24 ~= nil then
		return var_0_117(var_26_4, "options.user_agent_info has to be of type string")
	end

	local var_26_25 = arg_26_2.cookie_container

	if var_0_9(var_26_25) == "table" then
		local var_26_26 = var_0_109[var_26_25]

		if var_26_26 ~= nil and var_26_26.m_hCookieContainer ~= 0 then
			if not var_0_98(var_26_4, var_26_26.m_hCookieContainer) then
				return var_0_117(var_26_4, "failed to set user_agent_info")
			end
		else
			return var_0_117(var_26_4, "options.cookie_container has to a valid cookie container")
		end
	elseif var_26_25 ~= nil then
		return var_0_117(var_26_4, "options.cookie_container has to a valid cookie container")
	end

	local var_26_27 = var_0_83
	local var_26_28 = arg_26_2.stream_response

	if var_0_9(var_26_28) == "boolean" then
		if var_26_28 then
			var_26_27 = var_0_84

			if var_26_1 == nil and var_26_2 == nil and var_26_3 == nil then
				return var_0_117(var_26_4, "a 'completed', 'headers_received' or 'data_received' callback is required")
			end
		elseif var_26_1 == nil then
			return var_0_117(var_26_4, "'completed' callback has to be set for non-streamed requests")
		elseif var_26_2 ~= nil or var_26_3 ~= nil then
			return var_0_117(var_26_4, "non-streamed requests only support 'completed' callbacks")
		end
	elseif var_26_28 ~= nil then
		return var_0_117(var_26_4, "options.stream_response has to be of type boolean")
	end

	if var_26_2 ~= nil or var_26_3 ~= nil then
		var_0_106[var_26_4] = var_26_2 or false

		if var_26_2 ~= nil and not var_0_105 then
			var_0_51(var_0_62, var_0_120)

			var_0_105 = true
		end

		var_0_108[var_26_4] = var_26_3 or false

		if var_26_3 ~= nil and not var_0_107 then
			var_0_51(var_0_63, var_0_121)

			var_0_107 = true
		end
	end

	local var_26_29 = var_0_70()

	if not var_26_27(var_26_4, var_26_29) then
		var_0_92(var_26_4)

		if var_26_1 ~= nil then
			var_26_1(false, {
				status_message = "Failed to send request",
				status = 0
			})
		end

		return
	end

	if arg_26_2.priority == "defer" or arg_26_2.priority == "prioritize" then
		if not (arg_26_2.priority == "prioritize" and var_0_86 or var_0_85)(var_26_4) then
			return var_0_117(var_26_4, "failed to set priority")
		end
	elseif arg_26_2.priority ~= nil then
		return var_0_117(var_26_4, "options.priority has to be 'defer' of 'prioritize'")
	end

	var_0_103[var_26_4] = var_26_1 or false

	if var_26_1 ~= nil then
		var_0_50(var_26_29[0], var_0_119, var_0_61)
	end
end

local function var_0_123(arg_27_0)
	if arg_27_0 ~= nil and var_0_9(arg_27_0) ~= "boolean" then
		return var_0_5("allow_modification has to be of type boolean")
	end

	local var_27_0 = var_0_95(arg_27_0 == true)

	if var_27_0 ~= nil then
		local var_27_1 = var_0_69(var_27_0)

		var_0_21(var_27_1, var_0_115)

		local var_27_2 = var_0_6({}, var_0_114)

		var_0_109[var_27_2] = var_27_1

		return var_27_2
	end
end

local var_0_124 = {
	request = var_0_122,
	create_cookie_container = var_0_123
}

for iter_0_0 in var_0_10(var_0_58) do
	var_0_124[iter_0_0] = function(...)
		return var_0_122(iter_0_0, ...)
	end
end

return var_0_124
