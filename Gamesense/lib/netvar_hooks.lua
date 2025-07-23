-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = require("ffi")

var_0_0.cdef("\ttypedef struct _ntv_RecvProp ntv_RecvProp;\n\ttypedef struct _ntv_RecvTable ntv_RecvTable;\n\ttypedef struct _ntv_DVariant ntv_DVariant;\n\ttypedef struct _ntv_CRecvProxyData ntv_CRecvProxyData;\n\ttypedef struct _ntv_ClientClass ntv_ClientClass;\n\n\ttypedef void(*ntv_RecvVarProxyFn)(const ntv_CRecvProxyData*, void*, void*);\n\ttypedef void(*ntv_ArrayLengthFn)(void*, int, int);\n\ttypedef void(*ntv_DataTableFn)(const ntv_RecvProp*, void**, void*, int);\n\n\ttypedef enum _ntv_SendPropType\n\t{\n\t\tDPT_Int = 0,\n\t\tDPT_Float,\n\t\tDPT_Vector,\n\t\tDPT_VectorXY,\n\t\tDPT_String,\n\t\tDPT_Array,\n\t\tDPT_DataTable,\n\t\tDPT_Int64,\n\t\tDPT_NUMSendPropTypes\n\t} ntv_SendPropType;\n\n\ttypedef struct _ntv_DVariant\n\t{\n\t\tunion\n\t\t{\n\t\t\tfloat\t\tm_Float;\n\t\t\tlong\t\tm_Int;\n\t\t\tconst char* m_pString;\n\t\t\tvoid*\t   m_pData;\n\t\t\tfloat\t   m_Vector[3];\n\t\t\t__int64\t m_Int64;\n\t\t};\n\t\n\t\tntv_SendPropType m_Type;\n\t} ntv_DVariant;\n\n\ttypedef struct _ntv_CRecvProxyData\n\t{\n\t\tconst ntv_RecvProp* m_pRecvProp;\n\t\tntv_DVariant\t\tm_Value;\n\t\tint\t\t\t\tm_iElement;\n\t\tint\t\t\t\tm_ObjectID;\n\t} ntv_CRecvProxyData;\n\n\ttypedef struct _ntv_ClientClass\n\t{\n\t\tvoid* m_pCreateFn;\n\t\tvoid* m_pCreateEventFn;\n\t\tconst char* m_pNetworkname;\n\t\tntv_RecvTable* m_pRecvTable;\n\t\tntv_ClientClass* m_pNext;\n\t\tint m_ClassID;\n\t} ntv_ClientClass;\n\n\ttypedef struct _ntv_RecvProp\n\t{\n\t\tconst char*\t m_pVarName;\n\t\tint\t\t \tm_RecvType;\n\t\tint\t\t\t\tm_Flags;\n\t\tint\t\t\t\tm_StringBufferSize;\n\t\tbool\t\t\tm_bInsideArray;\n\t\tconst void*\t\tm_pExtraData;\n\t\tntv_RecvProp*\t\tm_pArrayProp;\n\t\tntv_ArrayLengthFn   m_ArrayLengthProxy;\n\t\tntv_RecvVarProxyFn\tm_ProxyFn;\n\t\tntv_DataTableFn\t m_DataTableProxyFn;\n\t\tntv_RecvTable*\t  m_pDataTable;\n\t\tint\t\t\t\tm_Offset;\n\t\tint\t\t\t m_ElementStride;\n\t\tint\t\t\t\tm_nElements;\n\t\tconst char*\t\tm_pParentArrayPropName;\n\t} ntv_RecvProp;\n\n\ttypedef struct _ntv_RecvTable\n\t{\n\t\tntv_RecvProp*   m_pProps;\n\t\tint\t\t\tm_nPropCount;\n\t\tvoid*\t\tm_pDecoder;\n\t\tconst char* m_pNetTableName;\n\t\tbool\t\tm_bInitialized;\n\t\tbool\t\tm_bInMainList;\n\t} ntv_RecvTable;\n\n\ttypedef struct _ntv_PackedInt\n\t{\n\t\tint val;\n\t} ntv_PackedInt;\n")

local var_0_1 = var_0_0.cast
local var_0_2 = var_0_1("void***", client.create_interface("client_panorama.dll", "VClient018")) or error("ChlClient is nil.")
local var_0_3 = var_0_1(var_0_0.typeof("ntv_ClientClass*(__thiscall*)(void*)"), var_0_2[0][8])
local var_0_4 = {}

local function var_0_5(arg_1_0, arg_1_1)
	if arg_1_0.m_nPropCount ~= 0 then
		for iter_1_0 = 0, arg_1_0.m_nPropCount - 1 do
			local var_1_0 = var_0_1("ntv_RecvProp&", arg_1_0.m_pProps[iter_1_0])

			if var_1_0.m_RecvType == 6 and var_1_0.m_pDataTable ~= var_0_1("ntv_RecvTable*", 0) and var_1_0.m_pDataTable.m_nPropCount > 0 then
				var_0_5(var_1_0.m_pDataTable, var_0_0.string(arg_1_0.m_pNetTableName))
			end

			local var_1_1 = arg_1_1 or var_0_0.string(arg_1_0.m_pNetTableName)
			local var_1_2 = var_0_0.string(var_1_0.m_pVarName)

			if var_0_4[var_1_1] == nil then
				var_0_4[var_1_1] = {}
			end

			var_0_4[var_1_1][var_1_2] = var_1_0
		end
	end
end

local function var_0_6()
	local var_2_0 = var_0_3(var_0_2)

	while var_2_0 ~= var_0_1("ntv_ClientClass*", 0) do
		if var_2_0.m_pRecvTable.m_nPropCount ~= 0 then
			var_0_5(var_2_0.m_pRecvTable, nil)
		end

		var_2_0 = var_2_0.m_pNext
	end
end

local function var_0_7(arg_3_0)
	return var_0_1("ntv_PackedInt*", var_0_1("char*", arg_3_0) + 100)
end

local var_0_8 = {}
local var_0_9 = {
	new = function(arg_4_0, arg_4_1)
		arg_4_0.__index = arg_4_0

		return setmetatable({
			_prop = arg_4_1 or error("No prop supplied in netvar_hook:new()"),
			_original_func = arg_4_1.m_ProxyFn,
			_functions = {}
		}, arg_4_0)
	end,
	bind = function(arg_5_0, arg_5_1)
		local var_5_0 = {
			[0] = function(arg_6_0)
				return arg_6_0.m_Value.m_Int
			end,
			function(arg_7_0)
				return arg_7_0.m_Value.m_Float
			end,
			function(arg_8_0)
				return arg_8_0.m_Value.m_Vector
			end,
			function(arg_9_0)
				return arg_9_0.m_Value.m_Vector
			end,
			function(arg_10_0)
				return arg_10_0.m_Value.m_pString
			end,
			function(arg_11_0)
				return arg_11_0.m_Value.m_Int
			end,
			[7] = function(arg_12_0)
				return arg_12_0.m_Value.m_Int64
			end
		}

		arg_5_0._functions[#arg_5_0._functions + 1] = arg_5_1 or error("No function supplied in netvar_hook:bind()")
		arg_5_0._callback = var_0_1("ntv_RecvVarProxyFn", function(arg_13_0, arg_13_1, arg_13_2)
			for iter_13_0 = 1, #arg_5_0._functions do
				arg_5_0._functions[iter_13_0](var_5_0[arg_5_0._prop.m_RecvType](arg_13_0), var_0_7(arg_13_1).val)
			end

			arg_5_0._original_func(arg_13_0, arg_13_1, arg_13_2)
		end)
		arg_5_0._prop.m_ProxyFn = arg_5_0._callback
	end,
	unbind = function(arg_14_0)
		arg_14_0._prop.m_ProxyFn = var_0_1("ntv_RecvVarProxyFn", arg_14_0._original_func)
		arg_14_0._functions = {}

		arg_14_0._callback:free()
	end
}

local function var_0_10(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = var_0_4[arg_15_0][arg_15_1] or error("NetVar supplied was not found.")

	if var_0_8[var_15_0] == nil then
		var_0_8[var_15_0] = var_0_9:new(var_15_0)
	end

	var_0_8[var_15_0]:bind(arg_15_2)
end

var_0_6()
client.set_event_callback("shutdown", function()
	for iter_16_0, iter_16_1 in pairs(var_0_8) do
		iter_16_1:unbind()
	end
end)

return {
	hook_prop = var_0_10
}
