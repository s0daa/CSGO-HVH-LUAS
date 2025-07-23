-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = require("ffi")
local var_0_1 = var_0_0.typeof
local var_0_2 = var_0_0.sizeof
local var_0_3 = var_0_0.cast
local var_0_4 = var_0_0.string
local var_0_5 = var_0_0.gc
local var_0_6 = string.format

local function var_0_7(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = client.find_signature(arg_1_0, arg_1_1) or error("signature not found", 2)
	local var_1_1 = var_0_3("uintptr_t", var_1_0)

	if arg_1_3 ~= nil and arg_1_3 ~= 0 then
		var_1_1 = var_1_1 + arg_1_3
	end

	if arg_1_4 ~= nil then
		for iter_1_0 = 1, arg_1_4 do
			var_1_1 = var_0_3("uintptr_t*", var_1_1)[0]

			if var_1_1 == nil then
				return error("signature not found")
			end
		end
	end

	return var_0_3(arg_1_2, var_1_1)
end

local var_0_8
local var_0_9

if not pcall(var_0_0.sizeof, "SteamAPICall_t") then
	var_0_0.cdef("\t\t\ttypedef uint64_t SteamAPICall_t;\n\n\t\t\tstruct SteamAPI_callback_base_vtbl {\n\t\t\t\tvoid(__thiscall *run1)(struct SteamAPI_callback_base *, void *, bool, uint64_t);\n\t\t\t\tvoid(__thiscall *run2)(struct SteamAPI_callback_base *, void *);\n\t\t\t\tint(__thiscall *get_size)(struct SteamAPI_callback_base *);\n\t\t\t};\n\n\t\t\tstruct SteamAPI_callback_base {\n\t\t\t\tstruct SteamAPI_callback_base_vtbl *vtbl;\n\t\t\t\tuint8_t flags;\n\t\t\t\tint id;\n\t\t\t\tuint64_t api_call_handle;\n\t\t\t\tstruct SteamAPI_callback_base_vtbl vtbl_storage[1];\n\t\t\t};\n\t\t")
end

local var_0_10 = {
	[0] = "Steam gone",
	"Network failure",
	"Invalid handle",
	[-1] = "No failure",
	[3] = "Mismatched callback"
}
local var_0_11
local var_0_12
local var_0_13
local var_0_14
local var_0_15 = var_0_1("struct SteamAPI_callback_base")
local var_0_16 = var_0_2(var_0_15)
local var_0_17 = var_0_1("struct SteamAPI_callback_base[1]")
local var_0_18 = var_0_1("struct SteamAPI_callback_base*")
local var_0_19 = var_0_1("uintptr_t")
local var_0_20 = {}
local var_0_21 = {}
local var_0_22 = {}

local function var_0_23(arg_2_0)
	return tostring(tonumber(var_0_3(var_0_19, arg_2_0)))
end

local function var_0_24(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.api_call_handle = 0

	local var_3_0 = var_0_23(arg_3_0)
	local var_3_1 = var_0_20[var_3_0]

	if var_3_1 ~= nil then
		xpcall(var_3_1, client.error_log, arg_3_1, arg_3_2)
	end

	if var_0_21[var_3_0] ~= nil then
		var_0_20[var_3_0] = nil
		var_0_21[var_3_0] = nil
	end
end

local function var_0_25(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if arg_4_3 == arg_4_0.api_call_handle then
		var_0_24(arg_4_0, arg_4_1, arg_4_2)
	end
end

local function var_0_26(arg_5_0, arg_5_1)
	var_0_24(arg_5_0, arg_5_1, false)
end

local function var_0_27(arg_6_0)
	return var_0_16
end

local function var_0_28(arg_7_0)
	if arg_7_0.api_call_handle ~= 0 then
		var_0_12(arg_7_0, arg_7_0.api_call_handle)

		arg_7_0.api_call_handle = 0

		local var_7_0 = var_0_23(arg_7_0)

		var_0_20[var_7_0] = nil
		var_0_21[var_7_0] = nil
	end
end

pcall(var_0_0.metatype, var_0_15, {
	__gc = var_0_28,
	__index = {
		cancel = var_0_28
	}
})

local var_0_29 = var_0_3("void(__thiscall *)(struct SteamAPI_callback_base *, void *, bool, uint64_t)", var_0_25)
local var_0_30 = var_0_3("void(__thiscall *)(struct SteamAPI_callback_base *, void *)", var_0_26)
local var_0_31 = var_0_3("int(__thiscall *)(struct SteamAPI_callback_base *)", var_0_27)

local function var_0_32(arg_8_0, arg_8_1, arg_8_2)
	assert(arg_8_0 ~= 0)

	local var_8_0 = var_0_17()
	local var_8_1 = var_0_3(var_0_18, var_8_0)

	var_8_1.vtbl_storage[0].run1 = var_0_29
	var_8_1.vtbl_storage[0].run2 = var_0_30
	var_8_1.vtbl_storage[0].get_size = var_0_31
	var_8_1.vtbl = var_8_1.vtbl_storage
	var_8_1.api_call_handle = arg_8_0
	var_8_1.id = arg_8_2

	local var_8_2 = var_0_23(var_8_1)

	var_0_20[var_8_2] = arg_8_1
	var_0_21[var_8_2] = var_8_0

	var_0_11(var_8_1, arg_8_0)

	return var_8_1
end

local function var_0_33(arg_9_0, arg_9_1)
	assert(var_0_22[arg_9_0] == nil)

	local var_9_0 = var_0_17()
	local var_9_1 = var_0_3(var_0_18, var_9_0)

	var_9_1.vtbl_storage[0].run1 = var_0_29
	var_9_1.vtbl_storage[0].run2 = var_0_30
	var_9_1.vtbl_storage[0].get_size = var_0_31
	var_9_1.vtbl = var_9_1.vtbl_storage
	var_9_1.api_call_handle = 0
	var_9_1.id = arg_9_0

	local var_9_2 = var_0_23(var_9_1)

	var_0_20[var_9_2] = arg_9_1
	var_0_22[arg_9_0] = var_9_0

	var_0_13(var_9_1, arg_9_0)
end

local function var_0_34(arg_10_0, arg_10_1, arg_10_2)
	return var_0_3(arg_10_2, var_0_3("void***", arg_10_0)[0][arg_10_1])
end

var_0_11 = var_0_7("steam_api.dll", "U\x8B\xEC\x83=\xCC\xCC\xCC\xCC\xCC~\rh\xCC\xCC\xCC\xCC\xFF\x15\xCC\xCC\xCC\xCC]\xC3\xFFu\x10", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")
var_0_12 = var_0_7("steam_api.dll", "U\x8B\xEC\xFFu\x10\xFFu\f", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")
var_0_13 = var_0_7("steam_api.dll", "U\x8B\xEC\x83=\xCC\xCC\xCC\xCC\xCC~\rh\xCC\xCC\xCC\xCC\xFF\x15\xCC\xCC\xCC\xCC]\xC3\xC7\x05", "void(__cdecl*)(struct SteamAPI_callback_base *, int)")

local var_0_35 = var_0_7("steam_api.dll", "U\x8B\xEC\x83\xEC\f\x80=\xCC\xCC\xCC\xCC\xCC\x0F\x84", "void(__cdecl*)(struct SteamAPI_callback_base *)")

client.set_event_callback("shutdown", function()
	for iter_11_0, iter_11_1 in pairs(var_0_21) do
		local var_11_0 = var_0_3(var_0_18, iter_11_1)

		var_0_28(var_11_0)
	end

	for iter_11_2, iter_11_3 in pairs(var_0_22) do
		local var_11_1 = var_0_3(var_0_18, iter_11_3)

		var_0_35(var_11_1)
	end
end)

if not pcall(var_0_2, "http_HHTMLBrowser") then
	var_0_0.cdef("\t\ttypedef uint32_t http_HHTMLBrowser;\n\n\t\tstruct http_ISteamHTMLSurfaceVtbl {\n\t\t\tbool(__thiscall *ISteamHTMLSurface)(uintptr_t);\n\t\t\tbool(__thiscall *Init)(uintptr_t);\n\t\t\tbool(__thiscall *Shutdown)(uintptr_t);\n\t\t\tSteamAPICall_t(__thiscall *CreateBrowser)(uintptr_t, const char*, const char*);\n\t\t\tvoid(__thiscall *RemoveBrowser)(uintptr_t, http_HHTMLBrowser);\n\t\t\tvoid(__thiscall *LoadURL)(uintptr_t, http_HHTMLBrowser, const char*, const char*);\n\t\t\tvoid(__thiscall *SetSize)(uintptr_t, http_HHTMLBrowser, uint32_t, uint32_t);\n\t\t\tvoid(__thiscall *StopLoad)(uintptr_t, http_HHTMLBrowser);\n\t\t\tvoid(__thiscall *Reload)(uintptr_t, http_HHTMLBrowser);\n\t\t\tvoid(__thiscall *GoBack)(uintptr_t, http_HHTMLBrowser);\n\t\t\tvoid(__thiscall *GoForward)(uintptr_t, http_HHTMLBrowser);\n\t\t\tvoid(__thiscall *AddHeader)(uintptr_t, http_HHTMLBrowser, const char*, const char*);\n\t\t\tvoid(__thiscall *ExecuteJavascript)(uintptr_t, http_HHTMLBrowser, const char*);\n\t\t\tvoid(__thiscall *MouseUp)(uintptr_t, http_HHTMLBrowser, int);\n\t\t\tvoid(__thiscall *MouseDown)(uintptr_t, http_HHTMLBrowser, int);\n\t\t\tvoid(__thiscall *MouseDoubleClick)(uintptr_t, http_HHTMLBrowser, int);\n\t\t\tvoid(__thiscall *MouseMove)(uintptr_t, http_HHTMLBrowser, int, int);\n\t\t\tvoid(__thiscall *MouseWheel)(uintptr_t, http_HHTMLBrowser, int32_t);\n\t\t\tvoid(__thiscall *KeyDown)(uintptr_t, http_HHTMLBrowser, uint32_t, int, bool);\n\t\t\tvoid(__thiscall *KeyUp)(uintptr_t, http_HHTMLBrowser, uint32_t, int);\n\t\t\tvoid(__thiscall *KeyChar)(uintptr_t, http_HHTMLBrowser, uint32_t, int);\n\t\t\tvoid(__thiscall *SetHorizontalScroll)(uintptr_t, http_HHTMLBrowser, uint32_t);\n\t\t\tvoid(__thiscall *SetVerticalScroll)(uintptr_t, http_HHTMLBrowser, uint32_t);\n\t\t\tvoid(__thiscall *SetKeyFocus)(uintptr_t, http_HHTMLBrowser, bool);\n\t\t\tvoid(__thiscall *ViewSource)(uintptr_t, http_HHTMLBrowser);\n\t\t\tvoid(__thiscall *CopyToClipboard)(uintptr_t, http_HHTMLBrowser);\n\t\t\tvoid(__thiscall *PasteFromClipboard)(uintptr_t, http_HHTMLBrowser);\n\t\t\tvoid(__thiscall *Find)(uintptr_t, http_HHTMLBrowser, const char*, bool, bool);\n\t\t\tvoid(__thiscall *StopFind)(uintptr_t, http_HHTMLBrowser);\n\t\t\tvoid(__thiscall *GetLinkAtPosition)(uintptr_t, http_HHTMLBrowser, int, int);\n\t\t\tvoid(__thiscall *SetCookie)(uintptr_t, const char*, const char*, const char*, const char*, uint32_t, bool, bool);\n\t\t\tvoid(__thiscall *SetPageScaleFactor)(uintptr_t, http_HHTMLBrowser, float, int, int);\n\t\t\tvoid(__thiscall *SetBackgroundMode)(uintptr_t, http_HHTMLBrowser, bool);\n\t\t\tvoid(__thiscall *SetDPIScalingFactor)(uintptr_t, http_HHTMLBrowser, float);\n\t\t\tvoid(__thiscall *OpenDeveloperTools)(uintptr_t, http_HHTMLBrowser);\n\t\t\tvoid(__thiscall *AllowStartRequest)(uintptr_t, http_HHTMLBrowser, bool);\n\t\t\tvoid(__thiscall *JSDialogResponse)(uintptr_t, http_HHTMLBrowser, bool);\n\t\t\tvoid(__thiscall *FileLoadDialogResponse)(uintptr_t, http_HHTMLBrowser, const char**);\n\t\t};\n\t")
end

local var_0_36 = 4501
local var_0_37 = 4502
local var_0_38 = 4503
local var_0_39 = 4504
local var_0_40 = 4505
local var_0_41 = 4506
local var_0_42 = 4507
local var_0_43 = 4508
local var_0_44 = 4509
local var_0_45 = 4510
local var_0_46 = 4511
local var_0_47 = 4512
local var_0_48 = 4513
local var_0_49 = 4514
local var_0_50 = 4515
local var_0_51 = 4516
local var_0_52 = 4521
local var_0_53 = 4522
local var_0_54 = 4523
local var_0_55 = 4524
local var_0_56 = 4525
local var_0_57 = 4526
local var_0_58 = 4527

local function var_0_59()
	local var_12_0 = var_0_7("client_panorama.dll", "\xB9\xCC\xCC\xCC\xCC\xE8\xCC\xCC\xCC̃=\xCC\xCC\xCC\xCC\xCC\x0F\x84", "uintptr_t", 1, 1)
	local var_12_1 = var_0_3("uintptr_t*", var_12_0)[18]

	if var_12_1 == 0 then
		return error("find_isteamhtmlsurface failed")
	end

	local var_12_2 = var_0_3("struct http_ISteamHTMLSurfaceVtbl**", var_12_1)[0]

	if var_12_2 == nil then
		return error("find_isteamhtmlsurface failed")
	end

	return var_12_1, var_12_2
end

local function var_0_60(arg_13_0, arg_13_1)
	return function(...)
		return arg_13_0(arg_13_1, ...)
	end
end

local var_0_61 = var_0_1("struct {\n\thttp_HHTMLBrowser unBrowserHandle;\n} *\n")
local var_0_62 = var_0_1("struct {\n\thttp_HHTMLBrowser unBrowserHandle;\n\tconst char* pchURL;\n\tconst char* pchTarget;\n\tconst char* pchPostData;\n\tbool bIsRedirect;\n} *\n")
local var_0_63 = var_0_1("struct {\n\thttp_HHTMLBrowser unBrowserHandle;\n\tconst char* pchURL;\n\tconst char* pchPageTitle;\n} *\n")
local var_0_64 = var_0_1("struct {\n\thttp_HHTMLBrowser unBrowserHandle;\n\tconst char* pchMessage;\n} *\n")
local var_0_65 = var_0_1("struct {\n\thttp_HHTMLBrowser unBrowserHandle;\n\tconst char* pchMessage;\n} *\n")
local var_0_66 = var_0_1("struct {\n\thttp_HHTMLBrowser unBrowserHandle;\n\tconst char* pchTitle;\n} *\n")
local var_0_67 = var_0_1("struct {\n\thttp_HHTMLBrowser unBrowserHandle;\n\tconst char* pchURL;\n\tconst char* pchPostData;\n\tbool bIsRedirect;\n\tconst char* pchPageTitle;\n\tbool bNewNavigation;\n} *\n")
local var_0_68, var_0_69 = var_0_59()
local var_0_70 = var_0_60(var_0_69.Init, var_0_68)
local var_0_71 = var_0_60(var_0_69.Shutdown, var_0_68)
local var_0_72 = var_0_60(var_0_69.CreateBrowser, var_0_68)
local var_0_73 = var_0_60(var_0_69.RemoveBrowser, var_0_68)
local var_0_74 = var_0_60(var_0_69.LoadURL, var_0_68)
local var_0_75 = var_0_60(var_0_69.SetSize, var_0_68)
local var_0_76 = var_0_60(var_0_69.StopLoad, var_0_68)
local var_0_77 = var_0_60(var_0_69.Reload, var_0_68)
local var_0_78 = var_0_60(var_0_69.GoBack, var_0_68)
local var_0_79 = var_0_60(var_0_69.GoForward, var_0_68)
local var_0_80 = var_0_60(var_0_69.AddHeader, var_0_68)
local var_0_81 = var_0_60(var_0_69.ExecuteJavascript, var_0_68)
local var_0_82 = var_0_60(var_0_69.MouseUp, var_0_68)
local var_0_83 = var_0_60(var_0_69.MouseDown, var_0_68)
local var_0_84 = var_0_60(var_0_69.MouseDoubleClick, var_0_68)
local var_0_85 = var_0_60(var_0_69.MouseMove, var_0_68)
local var_0_86 = var_0_60(var_0_69.MouseWheel, var_0_68)
local var_0_87 = var_0_60(var_0_69.KeyDown, var_0_68)
local var_0_88 = var_0_60(var_0_69.KeyUp, var_0_68)
local var_0_89 = var_0_60(var_0_69.KeyChar, var_0_68)
local var_0_90 = var_0_60(var_0_69.SetHorizontalScroll, var_0_68)
local var_0_91 = var_0_60(var_0_69.SetVerticalScroll, var_0_68)
local var_0_92 = var_0_60(var_0_69.SetKeyFocus, var_0_68)
local var_0_93 = var_0_60(var_0_69.ViewSource, var_0_68)
local var_0_94 = var_0_60(var_0_69.CopyToClipboard, var_0_68)
local var_0_95 = var_0_60(var_0_69.PasteFromClipboard, var_0_68)
local var_0_96 = var_0_60(var_0_69.Find, var_0_68)
local var_0_97 = var_0_60(var_0_69.StopFind, var_0_68)
local var_0_98 = var_0_60(var_0_69.GetLinkAtPosition, var_0_68)
local var_0_99 = var_0_60(var_0_69.SetCookie, var_0_68)
local var_0_100 = var_0_60(var_0_69.SetPageScaleFactor, var_0_68)
local var_0_101 = var_0_60(var_0_69.SetBackgroundMode, var_0_68)
local var_0_102 = var_0_60(var_0_69.SetDPIScalingFactor, var_0_68)
local var_0_103 = var_0_60(var_0_69.OpenDeveloperTools, var_0_68)
local var_0_104 = var_0_60(var_0_69.AllowStartRequest, var_0_68)
local var_0_105 = var_0_60(var_0_69.JSDialogResponse, var_0_68)
local var_0_106 = var_0_60(var_0_69.FileLoadDialogResponse, var_0_68)
local var_0_107
local var_0_108 = {}
local var_0_109 = {
	send = function(arg_15_0)
		if var_0_107 ~= nil then
			var_0_81(var_0_107, string.format("Client.receive(%s)", json.stringify(arg_15_0)))
		end
	end,
	receive = function(arg_16_0, arg_16_1)
		arg_16_0 = json.parse(arg_16_0)

		if var_0_108[arg_16_0.type] ~= nil then
			var_0_108[arg_16_0.type](arg_16_0)
		end
	end,
	register_handler = function(arg_17_0, arg_17_1)
		var_0_108[arg_17_0] = arg_17_1
	end
}
local var_0_110 = {}
local var_0_111 = {
	register = function(arg_18_0, arg_18_1)
		var_0_110[arg_18_0] = arg_18_1
	end
}

var_0_109.register_handler("rpc", function(arg_19_0)
	if var_0_110[arg_19_0.method] then
		local var_19_0 = {
			type = "rpc_resp",
			id = arg_19_0.id
		}
		local var_19_1, var_19_2 = pcall(var_0_110[arg_19_0.method], unpack(arg_19_0.params or {}))

		if var_19_1 then
			var_19_0.result = var_19_2
		else
			var_19_0.error = var_19_2
		end

		var_0_109.send(var_19_0)
	end
end)

local var_0_112 = {}
local var_0_113 = 0
local var_0_114 = {
	call = function(arg_20_0, arg_20_1, ...)
		var_0_113 = var_0_113 + 1

		local var_20_0 = {
			type = "rpc",
			method = arg_20_0,
			id = var_0_113
		}
		local var_20_1 = {
			...
		}

		if #var_20_1 > 0 then
			var_20_0.params = var_20_1
		end

		var_0_112[var_0_113] = arg_20_1

		var_0_109.send(var_20_0)
	end
}

var_0_109.register_handler("rpc_resp", function(arg_21_0)
	if var_0_112[arg_21_0.id] ~= nil then
		if arg_21_0.error ~= nil then
			xpcall(var_0_112[arg_21_0.id], client.error_log, arg_21_0.error)
		else
			xpcall(var_0_112[arg_21_0.id], client.error_log, nil, arg_21_0.result)
		end
	end
end)

local function var_0_115(arg_22_0)
	local var_22_0 = "\t\t// communication with lua\n\t\tvar Client = (function(){\n\t\t\tvar handlers = {}\n\t\t\tvar _SendMessage = function(message) {\n\t\t\t\tvar json = JSON.stringify(message)\n\n\t\t\t\tif(json.length > 10200) {\n\t\t\t\t\t// alert has a size limit, so we need to use document.location.hash - should be rare since it has its own rate limiting too\n\t\t\t\t\tvar ensureChangeChar = document.location.hash[1] == \"h\" ? \"H\" : \"h\"\n\n\t\t\t\t\t// setting location causes a HTML_ChangedTitle_t event (even if the title didnt actually change) so we set it to an empty string here and avoid that\n\t\t\t\t\tdocument.title = \"\"\n\t\t\t\t\tdocument.location.hash = ensureChangeChar + json\n\t\t\t\t} else if(json.length > 4090) {\n\t\t\t\t\t// alert has no rate limit but is rather slow (and limited to 10240 chars), so only use it if its required\n\t\t\t\t\talert(json)\n\t\t\t\t} else {\n\t\t\t\t\t// title has an even smaller size limit (4096), but its the fastest\n\t\t\t\t\tvar ensureChangeChar = document.title[0] == \"t\" ? \"T\" : \"t\"\n\t\t\t\t\tdocument.title = ensureChangeChar + json\n\t\t\t\t}\n\t\t\t}\n\n\t\t\tvar _RegisterHandler = function(type, callback) {\n\t\t\t\thandlers[type] = callback\n\t\t\t}\n\n\t\t\tvar _ReceiveMessage = function(message) {\n\t\t\t\tif(handlers[message.type]) {\n\t\t\t\t\thandlers[message.type](message)\n\t\t\t\t}\n\t\t\t}\n\n\t\t\treturn {\n\t\t\t\tsend: _SendMessage,\n\t\t\t\tregister_handler: _RegisterHandler,\n\t\t\t\treceive: _ReceiveMessage\n\t\t\t}\n\t\t})()\n\n\t\tvar RPCServer = (function(){\n\t\t\tvar rpc_functions = {}\n\n\t\t\t// internal func to handle incoming RPC messages\n\t\t\tvar _RPCHandler = function(message) {\n\t\t\t\tif(rpc_functions[message.method]) {\n\t\t\t\t\tvar resp = {\n\t\t\t\t\t\ttype: \"rpc_resp\",\n\t\t\t\t\t\tid: message.id\n\t\t\t\t\t}\n\n\t\t\t\t\ttry {\n\t\t\t\t\t\tvar params = message.params || []\n\n\t\t\t\t\t\tresp.result = rpc_functions[message.method](...params)\n\t\t\t\t\t} catch (e) {\n\t\t\t\t\t\tresp.error = e.toString()\n\t\t\t\t\t}\n\n\t\t\t\t\tClient.send(resp)\n\t\t\t\t}\n\t\t\t}\n\t\t\tClient.register_handler(\"rpc\", _RPCHandler)\n\n\t\t\tvar _RegisterRPCFunction = function(name, callback) {\n\t\t\t\trpc_functions[name] = callback\n\t\t\t}\n\n\t\t\treturn {\n\t\t\t\tregister: _RegisterRPCFunction\n\t\t\t}\n\t\t})()\n\n\t\tRPCServer.register(\"add\", function(a, b){\n\t\t\treturn a + b\n\t\t})\n\n\t\tvar RPCClient = (function(){\n\t\t\tvar index = 0\n\t\t\tvar pending_requests = {}\n\n\t\t\tvar _RPCRespHandler = function(message) {\n\t\t\t\tif(pending_requests[message.id]) {\n\t\t\t\t\tif(message.error) {\n\t\t\t\t\t\tpending_requests[message.id].reject(message.error)\n\t\t\t\t\t} else {\n\t\t\t\t\t\tpending_requests[message.id].resolve(message.result)\n\t\t\t\t\t}\n\t\t\t\t\tpending_requests[message.id] = null\n\t\t\t\t}\n\t\t\t}\n\t\t\tClient.register_handler(\"rpc_resp\", _RPCRespHandler)\n\n\t\t\tvar _Call = async function(method, params) {\n\t\t\t\tindex += 1\n\t\t\t\tvar req = {\n\t\t\t\t\ttype: \"rpc\",\n\t\t\t\t\tmethod: method,\n\t\t\t\t\tid: index\n\t\t\t\t}\n\n\t\t\t\tif(params) {\n\t\t\t\t\treq.params = params\n\t\t\t\t}\n\n\t\t\t\tvar result = new Promise((resolve, reject) => {\n\t\t\t\t\tpending_requests[index] = {resolve: resolve, reject: reject}\n\t\t\t\t})\n\n\t\t\t\tClient.send(req)\n\n\t\t\t\treturn result\n\t\t\t}\n\n\t\t\treturn {\n\t\t\t\tcall: _Call\n\t\t\t}\n\t\t})()\n\n\t\t// websocket implementation\n\t\tvar ws_api = (function(){\n\t\t\tvar open_websockets = []\n\t\t\tvar socket_index = 0\n\n\t\t\tvar _OnOpen = function(index, e) {\n\t\t\t\tRPCClient.call(\"ws_open\", [index, {extensions: e.target.extensions, protocol: e.target.protocol}])\n\t\t\t}\n\n\t\t\tvar _OnMessage = function(index, e) {\n\t\t\t\tif (e.data instanceof Blob) {\n\t\t\t\t\te.data.arrayBuffer().then(buf => {\n\t\t\t\t\t\tvar data = [...new Uint8Array(buf)]\n\t\t\t\t\t\tRPCClient.call(\"ws_message\", [index, data])\n\t\t\t\t\t})\n\t\t\t\t} else if (e.data instanceof ArrayBuffer) {\n\t\t\t\t\tvar data = [...new Uint8Array(e.data)]\n\t\t\t\t\tRPCClient.call(\"ws_message\", [index, data])\n\t\t\t\t} else {\n\t\t\t\t\tRPCClient.call(\"ws_message\", [index, e.data])\n\t\t\t\t}\n\t\t\t}\n\n\t\t\tvar _OnClose = function(index, e) {\n\t\t\t\tRPCClient.call(\"ws_closed\", [index, e.code, e.reason, e.wasClean])\n\t\t\t\topen_websockets[index] = null\n\t\t\t}\n\n\t\t\tvar _OnError = function(index, error) {\n\t\t\t\tRPCClient.call(\"ws_error\", [index])\n\t\t\t}\n\n\t\t\tRPCServer.register(\"ws_create\", function(url, protocols){\n\t\t\t\tvar index = socket_index++\n\t\t\t\tconsole.log(`creating websocket with index ${index}`)\n\n\t\t\t\tvar socket = null\n\t\t\t\ttry {\n\t\t\t\t\tsocket = (typeof protocols != \"undefined\") ? (new WebSocket(url, protocols)) : (new WebSocket(url))\n\n\t\t\t\t\tsocket.onopen = _OnOpen.bind(null, index)\n\t\t\t\t\tsocket.onmessage = _OnMessage.bind(null, index)\n\t\t\t\t\tsocket.onclose = _OnClose.bind(null, index)\n\t\t\t\t\tsocket.onerror = _OnError.bind(null, index)\n\t\t\t\t} catch(e) {\n\t\t\t\t\tsetTimeout(function() {\n\t\t\t\t\t\tRPCClient.call(\"ws_error\", [index])\n\t\t\t\t\t\tRPCClient.call(\"ws_closed\", [index, 1006, e.message.replace(\"Failed to construct 'WebSocket': \", \"\"), false])\n\t\t\t\t\t}, 10)\n\t\t\t\t}\n\n\t\t\t\topen_websockets[index] = socket\n\n\t\t\t\treturn index\n\t\t\t})\n\n\t\t\tRPCServer.register(\"ws_send\", function(index, data){\n\t\t\t\tif(open_websockets[index]) {\n\t\t\t\t\t// console.log(\"sending \", data)\n\t\t\t\t\tvar ws = open_websockets[index]\n\t\t\t\t\tif (Array.isArray(data)) {\n\t\t\t\t\t\t// isBinary\n\t\t\t\t\t\tvar u8 = new Uint8Array(data)\n\t\t\t\t\t\tws.send(u8.buffer)\n\t\t\t\t\t} else {\n\t\t\t\t\t\t// isText\n\t\t\t\t\t\tws.send(data)\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t})\n\n\t\t\tRPCServer.register(\"ws_close\", function(index, code, reason){\n\t\t\t\tif(open_websockets[index]) {\n\t\t\t\t\topen_websockets[index].close(code, reason)\n\t\t\t\t}\n\t\t\t})\n\t\t})()\n\n\t\tRPCClient.call(\"browser_ready\")\n\t"
	local var_22_1 = false

	local function var_22_2(arg_23_0, arg_23_1)
		if arg_23_0 == nil then
			return
		end

		local var_23_0 = var_0_3(var_0_61, arg_23_0)

		if var_23_0.unBrowserHandle == nil then
			return
		end

		var_0_107 = var_23_0.unBrowserHandle

		var_0_74(var_0_107, "about:blank", "")
	end

	var_0_33(var_0_38, function(arg_24_0, arg_24_1)
		if arg_24_0 == nil then
			return
		end

		if var_0_3(var_0_62, arg_24_0).unBrowserHandle == var_0_107 then
			var_0_104(var_0_107, true)
		end
	end)
	var_0_33(var_0_49, function(arg_25_0, arg_25_1)
		if arg_25_0 == nil then
			return
		end

		local var_25_0 = var_0_3(var_0_64, arg_25_0)

		if var_25_0.unBrowserHandle == var_0_107 and var_25_0.pchMessage ~= nil then
			local var_25_1 = var_0_0.string(var_25_0.pchMessage)

			var_0_109.receive(var_25_1, "alert")
			var_0_105(var_0_107, false)
		end
	end)
	var_0_33(var_0_43, function(arg_26_0, arg_26_1)
		if arg_26_0 == nil then
			return
		end

		local var_26_0 = var_0_3(var_0_66, arg_26_0)

		if var_26_0.unBrowserHandle == var_0_107 and var_26_0.pchTitle ~= nil then
			local var_26_1 = var_0_0.string(var_26_0.pchTitle)

			if var_22_1 then
				var_26_1 = var_26_1:gsub("^about:blank#", "")

				local var_26_2 = var_26_1:sub(1, 1)

				if var_26_2 == "t" or var_26_2 == "T" then
					var_0_109.receive(var_26_1:sub(2, -1), "changedtitle")
				end
			elseif var_26_1 == "about:blank" then
				var_0_81(var_0_107, var_22_0)

				var_22_1 = true

				if arg_22_0 ~= nil then
					xpcall(arg_22_0, client.error_log)
				end
			end
		end
	end)
	var_0_33(var_0_40, function(arg_27_0, arg_27_1)
		if arg_27_0 == nil then
			return
		end

		local var_27_0 = var_0_3(var_0_67, arg_27_0)

		if var_27_0.unBrowserHandle == var_0_107 and var_27_0.bNewNavigation == false and var_27_0.bIsRedirect == false and var_27_0.pchURL ~= nil then
			local var_27_1 = var_0_0.string(var_27_0.pchURL)

			if var_22_1 then
				local var_27_2 = var_27_1:sub(1, 13)

				if var_27_2 == "about:blank#h" or var_27_2 == "about:blank#H" then
					var_0_109.receive(var_27_1:sub(14, -1), "hash")
				end
			end
		end
	end)

	local var_22_3 = var_0_72(nil, nil)

	var_0_32(var_22_3, var_22_2, var_0_36)
	client.set_event_callback("shutdown", function()
		if var_0_107 ~= nil then
			var_0_73(var_0_107)

			var_0_107 = nil
		end
	end)
end

local var_0_116 = {}
local var_0_117 = setmetatable({}, {
	__mode = "k"
})

local function var_0_118(arg_29_0, arg_29_1, arg_29_2)
	if arg_29_1 ~= nil then
		local var_29_0 = var_0_117[arg_29_0]

		if var_29_0 ~= nil and var_29_0.callback_error ~= nil then
			xpcall(var_29_0.callback_error, client.error_log, arg_29_0, arg_29_1)
		end
	end
end

local var_0_119 = {
	__metatable = false,
	__index = {
		close = function(arg_30_0, arg_30_1, arg_30_2)
			local var_30_0 = var_0_117[arg_30_0]

			if var_30_0 == nil then
				return error("invalid websocket")
			end

			if not var_30_0.open then
				return error("websocket not open")
			end

			var_0_114.call("ws_close", var_0_60(var_0_118, arg_30_0), var_30_0.index, arg_30_1, arg_30_2)
		end,
		send = function(arg_31_0, arg_31_1)
			local var_31_0 = var_0_117[arg_31_0]

			if var_31_0 == nil then
				return error("invalid websocket")
			end

			if not var_31_0.open then
				return error("websocket not open")
			end

			var_0_114.call("ws_send", var_0_60(var_0_118, arg_31_0), var_31_0.index, type(arg_31_1) == "table" and arg_31_1 or tostring(arg_31_1))
		end
	}
}

var_0_111.register("ws_open", function(arg_32_0, arg_32_1)
	local var_32_0 = var_0_116[arg_32_0]
	local var_32_1 = var_0_117[var_32_0]

	if var_32_1 ~= nil then
		var_32_0.open = true
		var_32_1.open = true
		var_32_0.protocol = arg_32_1.protocol
		var_32_0.extensions = arg_32_1.extensions

		if var_32_1.callback_open ~= nil then
			xpcall(var_32_1.callback_open, client.error_log, var_32_0)
		end
	end
end)
var_0_111.register("ws_message", function(arg_33_0, arg_33_1)
	local var_33_0 = var_0_116[arg_33_0]
	local var_33_1 = var_0_117[var_33_0]

	if var_33_1 ~= nil and var_33_1.callback_message ~= nil then
		xpcall(var_33_1.callback_message, client.error_log, var_33_0, arg_33_1)
	end
end)
var_0_111.register("ws_closed", function(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	local var_34_0 = var_0_116[arg_34_0]
	local var_34_1 = var_0_117[var_34_0]

	if var_34_1 ~= nil then
		var_34_0.open = false
		var_34_1.open = false

		if var_34_1.callback_close ~= nil then
			xpcall(var_34_1.callback_close, client.error_log, var_34_0, arg_34_1, arg_34_2, arg_34_3)
		end

		var_0_116[arg_34_0] = nil
		var_0_117[var_34_0] = nil
	end
end)
var_0_111.register("ws_error", function(arg_35_0, arg_35_1)
	local var_35_0 = var_0_116[arg_35_0]
	local var_35_1 = var_0_117[var_35_0]

	if var_35_1 ~= nil and var_35_1.callback_error ~= nil then
		xpcall(var_35_1.callback_error, client.error_log, var_35_0)
	end
end)

local var_0_120 = 0
local var_0_121 = {}

local function var_0_122(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	local var_36_0 = arg_36_3.error

	var_0_117[arg_36_0] = {
		open = false,
		callback_open = arg_36_3.open,
		callback_error = var_36_0,
		callback_message = arg_36_3.message,
		callback_close = arg_36_3.close
	}

	var_0_114.call("ws_create", function(arg_37_0, arg_37_1)
		if arg_37_0 then
			if var_36_0 ~= nil then
				xpcall(var_36_0, client.error_log, arg_36_0, arg_37_0)
			end

			var_0_117[arg_36_0] = nil

			return
		end

		var_0_116[arg_37_1] = arg_36_0
		var_0_117[arg_36_0].index = arg_37_1
	end, arg_36_1, arg_36_2)
end

local function var_0_123(arg_38_0, arg_38_1, arg_38_2)
	if arg_38_2 == nil then
		arg_38_2 = arg_38_1
		arg_38_1 = nil
	end

	if type(arg_38_0) ~= "string" then
		return error("Invalid url, has to be a string")
	end

	if type(arg_38_2) ~= "table" then
		return error("Invalid callbacks, has to be a table")
	elseif arg_38_2.open == nil or type(arg_38_2.open) ~= "function" then
		return error("Invalid callbacks, open callback has to be registered")
	elseif arg_38_2.open == nil and arg_38_2.error == nil and arg_38_2.message == nil and arg_38_2.close == nil then
		return error("Invalid callbacks, at least one callback has to be registered")
	elseif arg_38_2.error ~= nil and type(arg_38_2.error) ~= "function" or arg_38_2.message ~= nil and type(arg_38_2.message) ~= "function" or arg_38_2.close ~= nil and type(arg_38_2.close) ~= "function" then
		return error("Invalid callbacks, all callbacks have to be functions")
	end

	local var_38_0

	if type(arg_38_1) == "table" then
		if type(arg_38_1.protocols) == "string" then
			var_38_0 = arg_38_1.protocols
		elseif type(arg_38_1.protocols) == "table" and #arg_38_1.protocols > 0 then
			for iter_38_0 = 1, #arg_38_1.protocols do
				if type(arg_38_1.protocols[iter_38_0]) ~= "string" then
					return error("Invalid options.protocols, has to be an array of strings")
				end
			end

			var_38_0 = arg_38_1.protocols
		elseif arg_38_1.protocols ~= nil then
			return error("Invalid options.protocols, has to be a string or array")
		end
	elseif arg_38_1 ~= nil then
		return error("Invalid options, has to be a table")
	end

	if var_0_120 == 0 then
		var_0_120 = 1

		var_0_115(function()
			var_0_120 = 2

			for iter_39_0 = 1, #var_0_121 do
				local var_39_0 = var_0_121[iter_39_0]

				xpcall(var_0_122, client.error_log, var_39_0.websocket, var_39_0.url, var_39_0.protocols, var_39_0.callbacks)
			end

			var_0_121 = nil
		end)
	end

	local var_38_1 = setmetatable({
		open = false,
		url = arg_38_0
	}, var_0_119)

	if var_0_120 ~= 2 then
		table.insert(var_0_121, {
			websocket = var_38_1,
			url = arg_38_0,
			protocols = var_38_0,
			callbacks = arg_38_2
		})
	else
		var_0_122(var_38_1, arg_38_0, var_38_0, arg_38_2)
	end

	return var_38_1
end

return {
	connect = var_0_123
}
