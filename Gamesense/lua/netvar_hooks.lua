slot0 = require("ffi")

slot0.cdef([[
	typedef struct _ntv_RecvProp ntv_RecvProp;
	typedef struct _ntv_RecvTable ntv_RecvTable;
	typedef struct _ntv_DVariant ntv_DVariant;
	typedef struct _ntv_CRecvProxyData ntv_CRecvProxyData;
	typedef struct _ntv_ClientClass ntv_ClientClass;

	typedef void(*ntv_RecvVarProxyFn)(const ntv_CRecvProxyData*, void*, void*);
	typedef void(*ntv_ArrayLengthFn)(void*, int, int);
	typedef void(*ntv_DataTableFn)(const ntv_RecvProp*, void**, void*, int);

	typedef enum _ntv_SendPropType
	{
		DPT_Int = 0,
		DPT_Float,
		DPT_Vector,
		DPT_VectorXY,
		DPT_String,
		DPT_Array,
		DPT_DataTable,
		DPT_Int64,
		DPT_NUMSendPropTypes
	} ntv_SendPropType;

	typedef struct _ntv_DVariant
	{
		union
		{
			float		m_Float;
			long		m_Int;
			const char* m_pString;
			void*	   m_pData;
			float	   m_Vector[3];
			__int64	 m_Int64;
		};
	
		ntv_SendPropType m_Type;
	} ntv_DVariant;

	typedef struct _ntv_CRecvProxyData
	{
		const ntv_RecvProp* m_pRecvProp;
		ntv_DVariant		m_Value;
		int				m_iElement;
		int				m_ObjectID;
	} ntv_CRecvProxyData;

	typedef struct _ntv_ClientClass
	{
		void* m_pCreateFn;
		void* m_pCreateEventFn;
		const char* m_pNetworkname;
		ntv_RecvTable* m_pRecvTable;
		ntv_ClientClass* m_pNext;
		int m_ClassID;
	} ntv_ClientClass;

	typedef struct _ntv_RecvProp
	{
		const char*	 m_pVarName;
		int		 	m_RecvType;
		int				m_Flags;
		int				m_StringBufferSize;
		bool			m_bInsideArray;
		const void*		m_pExtraData;
		ntv_RecvProp*		m_pArrayProp;
		ntv_ArrayLengthFn   m_ArrayLengthProxy;
		ntv_RecvVarProxyFn	m_ProxyFn;
		ntv_DataTableFn	 m_DataTableProxyFn;
		ntv_RecvTable*	  m_pDataTable;
		int				m_Offset;
		int			 m_ElementStride;
		int				m_nElements;
		const char*		m_pParentArrayPropName;
	} ntv_RecvProp;

	typedef struct _ntv_RecvTable
	{
		ntv_RecvProp*   m_pProps;
		int			m_nPropCount;
		void*		m_pDecoder;
		const char* m_pNetTableName;
		bool		m_bInitialized;
		bool		m_bInMainList;
	} ntv_RecvTable;

	typedef struct _ntv_PackedInt
	{
		int val;
	} ntv_PackedInt;
]])

slot3 = slot1(slot0.typeof("ntv_ClientClass*(__thiscall*)(void*)"), (slot0.cast("void***", client.create_interface("client_panorama.dll", "VClient018")) or error("ChlClient is nil."))[0][8])
slot4 = {}

function slot5(slot0, slot1)
	if slot0.m_nPropCount ~= 0 then
		for slot5 = 0, slot0.m_nPropCount - 1 do
			if uv0("ntv_RecvProp&", slot0.m_pProps[slot5]).m_RecvType == 6 and slot6.m_pDataTable ~= uv0("ntv_RecvTable*", 0) and slot6.m_pDataTable.m_nPropCount > 0 then
				uv1(slot6.m_pDataTable, uv2.string(slot0.m_pNetTableName))
			end

			slot8 = uv2.string(slot6.m_pVarName)

			if uv3[slot1 or uv2.string(slot0.m_pNetTableName)] == nil then
				uv3[slot7] = {}
			end

			uv3[slot7][slot8] = slot6
		end
	end
end

function slot7(slot0)
	return uv0("ntv_PackedInt*", uv0("char*", slot0) + 100)
end

slot8 = {}
slot9 = {
	new = function (slot0, slot1)
		slot0.__index = slot0

		return setmetatable({
			_prop = slot1 or error("No prop supplied in netvar_hook:new()"),
			_original_func = slot1.m_ProxyFn,
			_functions = {}
		}, slot0)
	end,
	bind = function (slot0, slot1)
		slot2 = {
			[0] = function (slot0)
				return slot0.m_Value.m_Int
			end,
			function (slot0)
				return slot0.m_Value.m_Float
			end,
			function (slot0)
				return slot0.m_Value.m_Vector
			end,
			function (slot0)
				return slot0.m_Value.m_Vector
			end,
			function (slot0)
				return slot0.m_Value.m_pString
			end,
			function (slot0)
				return slot0.m_Value.m_Int
			end,
			[7] = function (slot0)
				return slot0.m_Value.m_Int64
			end
		}
		slot0._functions[#slot0._functions + 1] = slot1 or error("No function supplied in netvar_hook:bind()")
		slot0._callback = uv0("ntv_RecvVarProxyFn", function (slot0, slot1, slot2)
			for slot6 = 1, #uv0._functions do
				uv0._functions[slot6](uv1[uv0._prop.m_RecvType](slot0), uv2(slot1).val)
			end

			uv0._original_func(slot0, slot1, slot2)
		end)
		slot0._prop.m_ProxyFn = slot0._callback
	end,
	unbind = function (slot0)
		slot0._prop.m_ProxyFn = uv0("ntv_RecvVarProxyFn", slot0._original_func)
		slot0._functions = {}

		slot0._callback:free()
	end
}

function ()
	slot0 = uv0(uv1)

	while slot0 ~= uv2("ntv_ClientClass*", 0) do
		if slot0.m_pRecvTable.m_nPropCount ~= 0 then
			uv3(slot0.m_pRecvTable, nil)
		end

		slot0 = slot0.m_pNext
	end
end()
client.set_event_callback("shutdown", function ()
	for slot3, slot4 in pairs(uv0) do
		slot4:unbind()
	end
end)

return {
	hook_prop = function (slot0, slot1, slot2)
		if uv1[uv0[slot0][slot1] or error("NetVar supplied was not found.")] == nil then
			uv1[slot3] = uv2:new(slot3)
		end

		uv1[slot3]:bind(slot2)
	end
}
