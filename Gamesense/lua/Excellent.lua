local ffi = require("ffi") or error("Toggle unsafe scripts")
local base64 = require("gamesense/base64") or error("Failed to load base64 library");
local vector = require("vector")

local menu_c = ui.reference("misc", "settings", "menu color")
local menu_r, menu_g, menu_b, menu_a = ui.get(menu_c)

local typeof, sizeof, cast, cdef, ffi_string, ffi_gc = ffi.typeof, ffi.sizeof, ffi.cast, ffi.cdef, ffi.string, ffi.gc
local string_lower, string_len, string_find = string.lower, string.len, string.find
local a = {}
function a.http_req()local a,b,c;do if not pcall(ffi.sizeof,"SteamAPICall_t")then cdef([[
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
]])end;local d={[-1]="No failure",[0]="Steam gone",[1]="Network failure",[2]="Invalid handle",[3]="Mismatched callback"}local e,f;local g,h;local i;local j=typeof("struct SteamAPI_callback_base")local k=sizeof(j)local l=typeof("struct SteamAPI_callback_base[1]")local m=typeof("struct SteamAPI_callback_base*")local n=typeof("uintptr_t")local o={}local p={}local q={}local function r(s)return tostring(tonumber(cast(n,s)))end;local function t(self,u,v)if v then v=d[i(self.api_call_handle)]or"Unknown error"end;self.api_call_handle=0;xpcall(function()local w=r(self)local x=o[w]if x~=nil then xpcall(x,client.error_log,u,v)end;if p[w]~=nil then o[w]=nil;p[w]=nil end end,client.error_log)end;local function y(self,u,v,z)if z==self.api_call_handle then t(self,u,v)end end;local function A(self,u)t(self,u,false)end;local function B(self)return k end;local function C(self)if self.api_call_handle~=0 then f(self,self.api_call_handle)self.api_call_handle=0;local w=r(self)o[w]=nil;p[w]=nil end end;pcall(ffi.metatype,j,{__gc=C,__index={cancel=C}})local D=cast("void(__thiscall *)(struct SteamAPI_callback_base *, void *, bool, uint64_t)",y)local E=cast("void(__thiscall *)(struct SteamAPI_callback_base *, void *)",A)local F=cast("int(__thiscall *)(struct SteamAPI_callback_base *)",B)function a(z,x,G)assert(z~=0)local H=l()local I=cast(m,H)I.vtbl_storage[0].run1=D;I.vtbl_storage[0].run2=E;I.vtbl_storage[0].get_size=F;I.vtbl=I.vtbl_storage;I.api_call_handle=z;I.id=G;local w=r(I)o[w]=x;p[w]=H;e(I,z)return I end;function b(G,x)assert(q[G]==nil)local H=l()local I=cast(m,H)I.vtbl_storage[0].run1=D;I.vtbl_storage[0].run2=E;I.vtbl_storage[0].get_size=F;I.vtbl=I.vtbl_storage;I.api_call_handle=0;I.id=G;local w=r(I)o[w]=x;q[G]=H;g(I,G)end;local function J(K,L,M,N,O)local P=client.find_signature(K,L)or error("signature not found",2)local Q=cast("uintptr_t",P)if N~=nil and N~=0 then Q=Q+N end;if O~=nil then for R=1,O do Q=cast("uintptr_t*",Q)[0]if Q==nil then return error("signature not found")end end end;return cast(M,Q)end;local function S(I,T,type)return cast(type,cast("void***",I)[0][T])end;e=J("steam_api.dll","\x55\x8B\xEC\x83\x3D\xCC\xCC\xCC\xCC\xCC\x7E\x0D\x68\xCC\xCC\xCC\xCC\xFF\x15\xCC\xCC\xCC\xCC\x5D\xC3\xFF\x75\x10","void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")f=J("steam_api.dll","\x55\x8B\xEC\xFF\x75\x10\xFF\x75\x0C","void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")g=J("steam_api.dll","\x55\x8B\xEC\x83\x3D\xCC\xCC\xCC\xCC\xCC\x7E\x0D\x68\xCC\xCC\xCC\xCC\xFF\x15\xCC\xCC\xCC\xCC\x5D\xC3\xC7\x05","void(__cdecl*)(struct SteamAPI_callback_base *, int)")c=J("client_panorama.dll","\xB9\xCC\xCC\xCC\xCC\xE8\xCC\xCC\xCC\xCC\x83\x3D\xCC\xCC\xCC\xCC\xCC\x0F\x84","uintptr_t",1,1)local U=cast("uintptr_t*",c)[3]local V=S(U,12,"int(__thiscall*)(void*, SteamAPICall_t)")function i(W)return V(U,W)end;client.set_event_callback("shutdown",function()for w,X in pairs(p)do local I=cast(m,X)C(I)end;for w,X in pairs(q)do local I=cast(m,X)end end)end;if not pcall(sizeof,"http_HTTPRequestHandle")then cdef([[
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
]])end;local Y={get=ffi.C.k_EHTTPMethodGET,head=ffi.C.k_EHTTPMethodHEAD,post=ffi.C.k_EHTTPMethodPOST,put=ffi.C.k_EHTTPMethodPUT,delete=ffi.C.k_EHTTPMethodDELETE,options=ffi.C.k_EHTTPMethodOPTIONS,patch=ffi.C.k_EHTTPMethodPATCH}local Z={[100]="Continue",[101]="Switching Protocols",[102]="Processing",[200]="OK",[201]="Created",[202]="Accepted",[203]="Non-Authoritative Information",[204]="No Content",[205]="Reset Content",[206]="Partial Content",[207]="Multi-Status",[208]="Already Reported",[250]="Low on Storage Space",[226]="IM Used",[300]="Multiple Choices",[301]="Moved Permanently",[302]="Found",[303]="See Other",[304]="Not Modified",[305]="Use Proxy",[306]="Switch Proxy",[307]="Temporary Redirect",[308]="Permanent Redirect",[400]="Bad Request",[401]="Unauthorized",[402]="Payment Required",[403]="Forbidden",[404]="Not Found",[405]="Method Not Allowed",[406]="Not Acceptable",[407]="Proxy Authentication Required",[408]="Request Timeout",[409]="Conflict",[410]="Gone",[411]="Length Required",[412]="Precondition Failed",[413]="Request Entity Too Large",[414]="Request-URI Too Long",[415]="Unsupported Media Type",[416]="Requested Range Not Satisfiable",[417]="Expectation Failed",[418]="I'm a teapot",[420]="Enhance Your Calm",[422]="Unprocessable Entity",[423]="Locked",[424]="Failed Dependency",[424]="Method Failure",[425]="Unordered Collection",[426]="Upgrade Required",[428]="Precondition Required",[429]="Too Many Requests",[431]="Request Header Fields Too Large",[444]="No Response",[449]="Retry With",[450]="Blocked by Windows Parental Controls",[451]="Parameter Not Understood",[451]="Unavailable For Legal Reasons",[451]="Redirect",[452]="Conference Not Found",[453]="Not Enough Bandwidth",[454]="Session Not Found",[455]="Method Not Valid in This State",[456]="Header Field Not Valid for Resource",[457]="Invalid Range",[458]="Parameter Is Read-Only",[459]="Aggregate Operation Not Allowed",[460]="Only Aggregate Operation Allowed",[461]="Unsupported Transport",[462]="Destination Unreachable",[494]="Request Header Too Large",[495]="Cert Error",[496]="No Cert",[497]="HTTP to HTTPS",[499]="Client Closed Request",[500]="Internal Server Error",[501]="Not Implemented",[502]="Bad Gateway",[503]="Service Unavailable",[504]="Gateway Timeout",[505]="HTTP Version Not Supported",[506]="Variant Also Negotiates",[507]="Insufficient Storage",[508]="Loop Detected",[509]="Bandwidth Limit Exceeded",[510]="Not Extended",[511]="Network Authentication Required",[551]="Option not supported",[598]="Network read timeout error",[599]="Network connect timeout error"}local _={"params","body","json"}local a0=2101;local a1=2102;local a2=2103;local function a3()local a4=cast("uintptr_t*",c)[12]if a4==0 or a4==nil then return error("find_isteamhttp failed")end;local a5=cast("struct http_ISteamHTTPVtbl**",a4)[0]if a5==0 or a5==nil then return error("find_isteamhttp failed")end;return a4,a5 end;local function a6(a7,a8)return function(...)return a7(a8,...)end end;local a9=typeof([[
struct {
http_HTTPRequestHandle m_hRequest;
uint64_t m_ulContextValue;
bool m_bRequestSuccessful;
int m_eStatusCode;
uint32_t m_unBodySize;
} *
]])local aa=typeof([[
struct {
http_HTTPRequestHandle m_hRequest;
uint64_t m_ulContextValue;
} *
]])local ab=typeof([[
struct {
http_HTTPRequestHandle m_hRequest;
uint64_t m_ulContextValue;
uint32_t m_cOffset;
uint32_t m_cBytesReceived;
} *
]])local ac=typeof([[
struct {
http_HTTPCookieContainerHandle m_hCookieContainer;
}
]])local ad=typeof("SteamAPICall_t[1]")local ae=typeof("const char[?]")local af=typeof("uint8_t[?]")local ag=typeof("unsigned int[?]")local ah=typeof("bool[1]")local ai=typeof("float[1]")local aj,ak=a3()local al=a6(ak.CreateHTTPRequest,aj)local am=a6(ak.SetHTTPRequestContextValue,aj)local an=a6(ak.SetHTTPRequestNetworkActivityTimeout,aj)local ao=a6(ak.SetHTTPRequestHeaderValue,aj)local ap=a6(ak.SetHTTPRequestGetOrPostParameter,aj)local aq=a6(ak.SendHTTPRequest,aj)local ar=a6(ak.SendHTTPRequestAndStreamResponse,aj)local as=a6(ak.DeferHTTPRequest,aj)local at=a6(ak.PrioritizeHTTPRequest,aj)local au=a6(ak.GetHTTPResponseHeaderSize,aj)local av=a6(ak.GetHTTPResponseHeaderValue,aj)local aw=a6(ak.GetHTTPResponseBodySize,aj)local ax=a6(ak.GetHTTPResponseBodyData,aj)local ay=a6(ak.GetHTTPStreamingResponseBodyData,aj)local az=a6(ak.ReleaseHTTPRequest,aj)local aA=a6(ak.GetHTTPDownloadProgressPct,aj)local aB=a6(ak.SetHTTPRequestRawPostBody,aj)local aC=a6(ak.CreateCookieContainer,aj)local aD=a6(ak.ReleaseCookieContainer,aj)local aE=a6(ak.SetCookie,aj)local aF=a6(ak.SetHTTPRequestCookieContainer,aj)local aG=a6(ak.SetHTTPRequestUserAgentInfo,aj)local aH=a6(ak.SetHTTPRequestRequiresVerifiedCertificate,aj)local aI=a6(ak.SetHTTPRequestAbsoluteTimeoutMS,aj)local aJ=a6(ak.GetHTTPRequestWasTimedOut,aj)local aK,aL={},false;local aM,aN=false,{}local aO,aP=false,{}local aQ=setmetatable({},{__mode="k"})local aR,aS=setmetatable({},{__mode="k"}),setmetatable({},{__mode="v"})local aT={}local aU={__index=function(aV,aW)local aX=aR[aV]if aX==nil then return end;aW=tostring(aW)if aX.m_hRequest~=0 then local aY=ag(1)if au(aX.m_hRequest,aW,aY)then if aY~=nil then aY=aY[0]if aY<0 then return end;local aZ=af(aY)if av(aX.m_hRequest,aW,aZ,aY)then aV[aW]=ffi_string(aZ,aY-1)return aV[aW]end end end end end,__metatable=false}local a_={__index={set_cookie=function(b0,b1,b2,aW,X)local W=aQ[b0]if W==nil or W.m_hCookieContainer==0 then return end;aE(W.m_hCookieContainer,b1,b2,tostring(aW).."="..tostring(X))end},__metatable=false}local function b3(W)if W.m_hCookieContainer~=0 then aD(W.m_hCookieContainer)W.m_hCookieContainer=0 end end;local function b4(aX)if aX.m_hRequest~=0 then az(aX.m_hRequest)aX.m_hRequest=0 end end;local function b5(b6,...)az(b6)return error(...)end;local function b7(aX,b8,b9,ba,...)local bb=aS[aX.m_hRequest]if bb==nil then bb=setmetatable({},aU)aS[aX.m_hRequest]=bb end;aR[bb]=aX;ba.headers=bb;aL=true;xpcall(b8,client.error_log,b9,ba,...)aL=false end;local function bc(u,v)if u==nil then return end;local aX=cast(a9,u)if aX.m_hRequest~=0 then local b8=aK[aX.m_hRequest]if b8~=nil then aK[aX.m_hRequest]=nil;aP[aX.m_hRequest]=nil;aN[aX.m_hRequest]=nil;if b8 then local b9=v==false and aX.m_bRequestSuccessful;local bd=aX.m_eStatusCode;local be={status=bd}local bf=aX.m_unBodySize;if b9 and bf>0 then local aZ=af(bf)if ax(aX.m_hRequest,aZ,bf)then be.body=ffi_string(aZ,bf)end elseif not aX.m_bRequestSuccessful then local bg=ah()aJ(aX.m_hRequest,bg)be.timed_out=bg~=nil and bg[0]==true end;if bd>0 then be.status_message=Z[bd]or"Unknown status"elseif v then be.status_message=string_format("IO Failure: %s",v)else be.status_message=be.timed_out and"Timed out"or"Unknown error"end;b7(aX,b8,b9,be)end;b4(aX)end end end;local function bh(u,v)if u==nil then return end;local aX=cast(aa,u)if aX.m_hRequest~=0 then local b8=aN[aX.m_hRequest]if b8 then b7(aX,b8,v==false,{})end end end;local function bi(u,v)if u==nil then return end;local aX=cast(ab,u)if aX.m_hRequest~=0 then local b8=aP[aX.m_hRequest]if aP[aX.m_hRequest]then local ba={}local bj=ai()if aA(aX.m_hRequest,bj)then ba.download_progress=tonumber(bj[0])end;local aZ=af(aX.m_cBytesReceived)if ay(aX.m_hRequest,aX.m_cOffset,aZ,aX.m_cBytesReceived)then ba.body=ffi_string(aZ,aX.m_cBytesReceived)end;b7(aX,b8,v==false,ba)end end end;local function bk(bl,b2,bm,bn)if type(bm)=="function"and bn==nil then bn=bm;bm={}end;bm=bm or{}local bl=Y[string_lower(tostring(bl))]if bl==nil then return error("invalid HTTP method")end;if type(b2)~="string"then return error("URL has to be a string")end;local bo,bp,bq;if type(bn)=="function"then bo=bn elseif type(bn)=="table"then bo=bn.completed or bn.complete;bp=bn.headers_received or bn.headers;bq=bn.data_received or bn.data;if bo~=nil and type(bo)~="function"then return error("callbacks.completed callback has to be a function")elseif bp~=nil and type(bp)~="function"then return error("callbacks.headers_received callback has to be a function")elseif bq~=nil and type(bq)~="function"then return error("callbacks.data_received callback has to be a function")end else return error("callbacks has to be a function or table")end;local b6=al(bl,b2)if b6==0 then return error("Failed to create HTTP request")end;local br=false;for R,w in ipairs(_)do if bm[w]~=nil then if br then return error("can only set options.params, options.body or options.json")else br=true end end end;local bs;if bm.json~=nil then local bt;bt,bs=pcall(json.stringify,bm.json)if not bt then return error("options.json is invalid: "..bs)end end;local bu=bm.network_timeout;if bu==nil then bu=10 end;if type(bu)=="number"and bu>0 then if not an(b6,bu)then return b5(b6,"failed to set network_timeout")end elseif bu~=nil then return b5(b6,"options.network_timeout has to be of type number and greater than 0")end;local bv=bm.absolute_timeout;if bv==nil then bv=30 end;if type(bv)=="number"and bv>0 then if not aI(b6,bv*1000)then return b5(b6,"failed to set absolute_timeout")end elseif bv~=nil then return b5(b6,"options.absolute_timeout has to be of type number and greater than 0")end;local bw=bs~=nil and"application/json"or"text/plain"local bx;local bb=bm.headers;if type(bb)=="table"then for aW,X in pairs(bb)do aW=tostring(aW)X=tostring(X)local by=string_lower(aW)if by=="content-type"then bw=X elseif by=="authorization"then bx=true end;if not ao(b6,aW,X)then return b5(b6,"failed to set header "..aW)end end elseif bb~=nil then return b5(b6,"options.headers has to be of type table")end;local bz=bm.authorization;if type(bz)=="table"then if bx then return b5(b6,"Cannot set both options.authorization and the 'Authorization' header.")end;local bA,bB=bz[1],bz[2]local bC=string_format("Basic %s",base64.encode(string_format("%s:%s",tostring(bA),tostring(bB)),"base64"))if not ao(b6,"Authorization",bC)then return b5(b6,"failed to apply options.authorization")end elseif bz~=nil then return b5(b6,"options.authorization has to be of type table")end;local bD=bs or bm.body;if type(bD)=="string"then local bE=string_len(bD)if not aB(b6,bw,cast("unsigned char*",bD),bE)then return b5(b6,"failed to set post body")end elseif bD~=nil then return b5(b6,"options.body has to be of type string")end;local bF=bm.params;if type(bF)=="table"then for aW,X in pairs(bF)do aW=tostring(aW)if not ap(b6,aW,tostring(X))then return b5(b6,"failed to set parameter "..aW)end end elseif bF~=nil then return b5(b6,"options.params has to be of type table")end;local bG=bm.require_ssl;if type(bG)=="boolean"then if not aH(b6,bG==true)then return b5(b6,"failed to set require_ssl")end elseif bG~=nil then return b5(b6,"options.require_ssl has to be of type boolean")end;local bH=bm.user_agent_info;if type(bH)=="string"then if not aG(b6,tostring(bH))then return b5(b6,"failed to set user_agent_info")end elseif bH~=nil then return b5(b6,"options.user_agent_info has to be of type string")end;local bI=bm.cookie_container;if type(bI)=="table"then local W=aQ[bI]if W~=nil and W.m_hCookieContainer~=0 then if not aF(b6,W.m_hCookieContainer)then return b5(b6,"failed to set user_agent_info")end else return b5(b6,"options.cookie_container has to a valid cookie container")end elseif bI~=nil then return b5(b6,"options.cookie_container has to a valid cookie container")end;local bJ=aq;local bK=bm.stream_response;if type(bK)=="boolean"then if bK then bJ=ar;if bo==nil and bp==nil and bq==nil then return b5(b6,"a 'completed', 'headers_received' or 'data_received' callback is required")end else if bo==nil then return b5(b6,"'completed' callback has to be set for non-streamed requests")elseif bp~=nil or bq~=nil then return b5(b6,"non-streamed requests only support 'completed' callbacks")end end elseif bK~=nil then return b5(b6,"options.stream_response has to be of type boolean")end;if bp~=nil or bq~=nil then aN[b6]=bp or false;if bp~=nil then if not aM then b(a1,bh)aM=true end end;aP[b6]=bq or false;if bq~=nil then if not aO then b(a2,bi)aO=true end end end;local bL=ad()if not bJ(b6,bL)then az(b6)if bo~=nil then bo(false,{status=0,status_message="Failed to send request"})end;return end;if bm.priority=="defer"or bm.priority=="prioritize"then local a7=bm.priority=="prioritize"and at or as;if not a7(b6)then return b5(b6,"failed to set priority")end elseif bm.priority~=nil then return b5(b6,"options.priority has to be 'defer' of 'prioritize'")end;aK[b6]=bo or false;if bo~=nil then a(bL[0],bc,a0)end end;local function bM(bN)if bN~=nil and type(bN)~="boolean"then return error("allow_modification has to be of type boolean")end;local bO=aC(bN==true)if bO~=nil then local W=ac(bO)ffi_gc(W,b3)local w=setmetatable({},a_)aQ[w]=W;return w end end;local bP={request=bk,create_cookie_container=bM}for bl in pairs(Y)do bP[bl]=function(...)return bk(bl,...)end end;return bP end

local clipboard do
    clipboard = { }

    local GetClipboardTextCount = vtable_bind('vgui2.dll', 'VGUI_System010', 7, 'int(__thiscall*)(void*)')
    local SetClipboardText = vtable_bind('vgui2.dll', 'VGUI_System010', 9, 'void(__thiscall*)(void*, const char*, int)')
    local GetClipboardText = vtable_bind('vgui2.dll', 'VGUI_System010', 11, 'int(__thiscall*)(void*, int, const char*, int)')

    local function set(...)
        local text = tostring(table.concat({ ... }))

        SetClipboardText(text, string.len(text))
    end

    clipboard.set = set
end

rgba_to_hex = function( r, g, b, a )
    return string.format( '%02x%02x%02x%02x', r, g, b, a )
end

local menu_c_hex = rgba_to_hex(menu_r, menu_g, menu_b, menu_a)

local tittle = ui.new_label("lua", "b", "\a".. menu_c_hex .."Excellent Leaks ~\abfbdbdFF Loader")
local list_menu = ui.new_listbox("lua", "b", "Script List", {"No scripts found."})
local tittle = ui.new_label("lua", "b", "\af5f125FF⚠\abfbdbdFF Double click on script to load / unload it")

local notify_lol = {}

function new_notify(string)
    local screen = {client.screen_size()}
    screen.x = screen[1]
    screen.y = screen[2]
    local x,y = screen.x, screen.y
    local notification = {
        text = string,
        timer = globals.realtime(),
        alpha = 0
    }

    if #notify_lol == 0 then
        notification.y = y + 20
    else
        local lastNotification = notify_lol[#notify_lol]
        notification.y = lastNotification.y + 20 
    end

    table.insert(notify_lol, notification)
end

local script_statuses = {}
local formatted_scripts = {}
local function list_scripts()
    a.http_req().get("http://1ghx.ct8.pl/loader.php?action=list",
        function(success, response)
            if not success or response.status ~= 200 then
                new_notify("Something went wrong")
                client.color_log(menu_r, menu_g, menu_b, "Fast Leaks ~\0")
                client.color_log(255, 0, 0, " Something went wrong")
                return
            end

            local json_data = response.body
            local decoded_data = json.parse(json_data)

            if decoded_data.lua_files then
                local lua_files = decoded_data.lua_files
                script_names = lua_files

                for _, script_name in ipairs(lua_files) do
                    script_statuses[script_name] = false
                    table.insert(formatted_scripts,  "\a".. menu_c_hex .."○\abfbdbdFF " .. script_name)
                end
                ui.update(list_menu, formatted_scripts)
                new_notify("Loaded list successfully!")
                client.color_log(menu_r, menu_g, menu_b, "Fast Leaks ~\0")
                client.color_log(210, 210, 210, " Loaded list successfully!")
            else
                new_notify("Something went wrong")
                client.color_log(menu_r, menu_g, menu_b, "Fast Leaks ~\0")
                client.color_log(255, 0, 0, " Something went wrong")
            end
        end
    )
end

list_scripts()


local function load_selected_script(selected_item)
    a.http_req().get("http://1ghx.ct8.pl/loader.php?action=load&lua=" .. selected_item,
        function(success, response)
            if not success or response.status ~= 200 then
                new_notify("Something went wrong")
                client.color_log(menu_r, menu_g, menu_b, "Fast Leaks ~\0")
                client.color_log(255, 0, 0, " Something went wrong")
                return
            end

            local json_data = response.body
            local decoded_data = json.parse(json_data)

            if decoded_data.content then
                local lua_src = load(base64.decode(decoded_data.content))
                local loaded_scripts = database.read("sl_loader") or {}
                loaded_scripts[selected_item] = true
                script_statuses[selected_item] = true
                database.write("sl_loader", loaded_scripts)
                for i, script_text in ipairs(formatted_scripts) do
                    if script_text:match(selected_item) then
                        formatted_scripts[i] = script_text:gsub("\a".. menu_c_hex .."○\abfbdbdFF%s*(.-)%s*", "\a".. menu_c_hex .."◉ \abfbdbdFF")
                        ui.update(list_menu, formatted_scripts)
                        break
                    end
                end
                client.color_log(menu_r, menu_g, menu_b, "Fast Leaks ~ \0")
                client.color_log(210, 210, 210, selected_item .. " has been loaded, hf")
                new_notify(selected_item .. " has been loaded, hf")
                a.http_req().get("" .. selected_item,
                    function(success, response)
                        if not success or response.status ~= 200 then
                            return
                        end

                        local json_data = response.body
                        local decoded_data = json.parse(json_data)

                        if decoded_data.configs then
                            local configs_tittle = ui.new_label("lua", "b", "Configs for " .. "\a".. menu_c_hex .. selected_item)
                            local combobox_items = decoded_data.configs
                            local combobox = ui.new_combobox("lua", "b", "Author:", unpack(combobox_items))
                            local button_export = ui.new_button("lua", "b", "Export to clipboard", function()
                                local selected_config = ui.get(combobox)
                                if selected_config then
                                    a.http_req().get("" .. selected_item .. "&config=" .. selected_config,
                                        function(success, response)
                                            if not success or response.status ~= 200 then
                                                new_notify("Something went wrong")
                                                client.color_log(menu_r, menu_g, menu_b, "Fast Leaks ~\0")
                                                client.color_log(255, 0, 0, " Something went wrong")
                                                return
                                            end
                                            local config_content = response.body
                                            local decoded_content = json.parse(config_content)
                                            new_notify(selected_config .. " config has been exported to clipboard")
                                            client.color_log(menu_r, menu_g, menu_b, "Fast Leaks ~ \0")
                                            client.color_log(210, 210, 210, selected_config .. " config has been exported to clipboard")
                                            clipboard.set(decoded_content.content)
                                        end
                                    )
                                end
                            end)
                        end
                    end
                )
                lua_src()
            else
                new_notify("Something went wrong")
                client.color_log(menu_r, menu_g, menu_b, "Fast Leaks ~\0")
                client.color_log(255, 0, 0, " Something went wrong")
            end
        end
    )
end


local function unload_selected_script(selected_item)
    local loaded_scripts = database.read("sl_loader") or {}
    loaded_scripts[selected_item] = nil
    database.write("sl_loader", loaded_scripts)
    script_statuses[selected_item] = false
    client.reload_active_scripts()
end


local last_click_time = 0
local last_click_index = -1

local function list_clicks()
    local listitem = (ui.get(list_menu) + 1)
    if listitem == nil then return end

    local cur_time = globals.curtime()
    if last_click_index == listitem and last_click_time + 0.5 > cur_time then

        local selected_item_val = ui.get(list_menu, listitem)
        local selected_item = script_names[selected_item_val + 1]
        script_statuses[selected_item] = not (script_statuses[selected_item] or false)

        if (script_statuses[selected_item] == true) then
            print(script_statuses)
            load_selected_script(selected_item)
        else
            unload_selected_script(selected_item)
        end

        last_click_index = -1
    else
        last_click_index = listitem
        last_click_time = cur_time
    end
end

local function load_and_execute_scripts_from_database()
    local loaded_scripts = database.read("sl_loader") or {} 
    for script_name, is_loaded in pairs(loaded_scripts) do
        if is_loaded then
            load_selected_script(script_name) 
        end
    end
end

load_and_execute_scripts_from_database()


local visuals = {}
local helpers = {}
helpers.lerp = function(a,b,p) 
    return a + (b - a) * p
end

visuals.rec = function(x, y, w, h, radius, color)
    radius = math.min(x/2, y/2, radius)
    local r, g, b, a = unpack(color)
    renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
    renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
    renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
    renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
    renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
    renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
    renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
end

visuals.rec_outline = function(x, y, w, h, radius, thickness, color)
    radius = math.min(w/2, h/2, radius)
    local r, g, b, a = unpack(color)
    if radius == 1 then
        renderer.rectangle(x, y, w, thickness, r, g, b, a)
        renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
    else
        renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
        renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
        renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
        renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
        renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
        renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
        renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
        renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
    end
end

visuals.glow_module = function(x, y, w, h, width, rounding, accent, accent_inner)
    local thickness = 1
    local offset = 1
    local r, g, b, a = unpack(accent)
    if accent_inner then
        visuals.rec(x , y, w, h + 1, rounding, accent_inner)
    end
    for k = 0, width do
        if a * (k/width)^(1) > 5 then
            local accent = {r, g, b, a * (k/width)^(2)}
            visuals.rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
        end
    end
end

visuals.notify = function()
    local screen = {client.screen_size()}
    screen.x = screen[1]
    screen.y = screen[2]
    local x,y = screen.x, screen.y
    local icon = renderer.load_svg([[<svg width="800px" height="800px" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M6.5 11.25C6.08579 11.25 5.75 10.9142 5.75 10.5C5.75 10.0858 6.08579 9.75 6.5 9.75H13.5C13.9142 9.75 14.25 10.0858 14.25 10.5C14.25 10.9142 13.9142 11.25 13.5 11.25H6.5Z" fill="white"/>
    <path d="M6.5 14.25C6.08579 14.25 5.75 13.9142 5.75 13.5C5.75 13.0858 6.08579 12.75 6.5 12.75H13.5C13.9142 12.75 14.25 13.0858 14.25 13.5C14.25 13.9142 13.9142 14.25 13.5 14.25H6.5Z" fill="white"/>
    <path fill-rule="evenodd" clip-rule="evenodd" d="M11.1854 0.5H4.5C3.39543 0.5 2.5 1.39543 2.5 2.5V17.5C2.5 18.6046 3.39543 19.5 4.5 19.5H15.5C16.6046 19.5 17.5 18.6046 17.5 17.5V7.20179C17.5 6.70104 17.3122 6.21851 16.9736 5.84956L12.659 1.14777C12.2802 0.734983 11.7457 0.5 11.1854 0.5ZM4.5 17.5V2.5H11.1854L15.5 7.20179V17.5H4.5Z" fill="white"/>
    <path d="M11.5 6.5H16.5C17.0523 6.5 17.5 6.94772 17.5 7.5C17.5 8.05228 17.0523 8.5 16.5 8.5H10.5C9.94772 8.5 9.5 8.05228 9.5 7.5V1.5C9.5 0.947715 9.94772 0.5 10.5 0.5C11.0523 0.5 11.5 0.947715 11.5 1.5V6.5Z" fill="white"/>
    </svg> ]],1080,1080)
    for i, info_noti in ipairs(notify_lol) do
        if i > 7 then
            table.remove(notify_lol, i)
        end
        if info_noti.text ~= nil and info_noti.text ~= "" then
            if info_noti.timer + 3.7 < globals.realtime() then
                info_noti.y = helpers.lerp(info_noti.y, y + 150, globals.frametime() * 1.5)
                info_noti.alpha = helpers.lerp(info_noti.alpha, 0, globals.frametime() * 4.5)
            else
                info_noti.y = helpers.lerp(info_noti.y, y - 100, globals.frametime() * 1.5)
                info_noti.alpha = helpers.lerp(info_noti.alpha, 255, globals.frametime() * 4.5)
            end
        end

        local width = vector(renderer.measure_text("c", info_noti.text))
        local r,g,b,a = unpack({menu_r, menu_g, menu_b, menu_a})

        visuals.glow_module(x /2 - width.x /2 - 20, info_noti.y - i*35 - 48 ,width.x + 30, width.y + 8, 14, 6, {r,g,b,info_noti.alpha - 165}, {13,13,13,(info_noti.alpha/255)*200})
        renderer.texture(icon, x /2 - width.x /2 - 15, info_noti.y - i*35 - 46, 16, 16, r,g,b, info_noti.alpha, "f")
        renderer.text(x / 2 - width.x /2 + 4, info_noti.y - i*35 - 45, 255,255,255,info_noti.alpha, "", nil, info_noti.text)

        if info_noti.timer + 4.3 < globals.realtime() then
            table.remove(notify_lol,i)
        end
    end
end

client.set_event_callback('paint_ui', visuals.notify)
ui.set_callback(list_menu, list_clicks)
