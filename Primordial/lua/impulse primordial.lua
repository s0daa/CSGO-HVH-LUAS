---@region: start
local script = {
    build = "LIVE",
    name = "IMPULSE"
}
local ffi = require('ffi')
local redifine = function(t)
    local c = {}
    for k, v in next, t do c[k] = v end
    return c
end
local color, vector = color_t, vec2_t
local math, table, string, render, ffi, menu = redifine(math), redifine(table), redifine(string),
    redifine(render), redifine(ffi), redifine(menu)
local function __thiscall(func, this)
    return function(...)
        return func(this, ...)
    end
end
local vtable_bind = function(module, interface, index, typedef)
    local addr = ffi.cast("void***", memory.create_interface(module, interface)) or safe_error(interface .. " is nil.")
    return __thiscall(ffi.cast(typedef, addr[0][index]), addr)
end

local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')
local log = { logs = {} }; do
    log.add = function(text, color)
        table.insert(log.logs, 1, { text = text, color = color, alpha = 0, time = globals.cur_time() + 3 })
    end
end
do
    math.lerp              = function(a, b, t)
        return a + t * (b - a)
    end
    math.round             = function(value, decimals)
        local multiplier = 10.0 ^ (decimals or 0.0)
        return math.floor(value * multiplier + 0.5) / multiplier
    end
    math.lerp_color        = function(clr1, clr2, t)
        return render.color(
            math.round(math.flerp(clr1.r, clr2.r, t)),
            math.round(math.flerp(clr1.g, clr2.g, t)),
            math.round(math.flerp(clr1.b, clr2.b, t)),
            math.round(math.flerp(clr1.a, clr2.a, t))
        )
    end
    math.nway              = function(start, final, way)
        local val_t = {}; for i = 0, 1, 1 / (way) do
            table.insert(val_t, math.flerp(start, final, i))
        end
        return val_t
    end
    math.is_float          = function(num)
        return num % 1 ~= 0
    end
    math.to_normal         = function(n)
        if n < 0 then
            return 0
        end
        return n
    end
    math.clamp             = function(x, min, max)
        if x < min then return min end
        if x > max then return max end
        if x == nil then return min end
        return x
    end
    math.flerp             = function(a, b, t)
        return a + t * (b - a)
    end
    math.flerp_color       = function(clr1, clr2, t)
        return color(
            math.round(math.flerp(clr1.r, clr2.r, t)),
            math.round(math.flerp(clr1.g, clr2.g, t)),
            math.round(math.flerp(clr1.b, clr2.b, t)),
            math.round(math.flerp(clr1.a, clr2.a, t))
        )
    end
    math.normalize_yaw     = function(angle)
        if angle < -180 then
            angle = angle + 360
        end
        if angle > 180 then
            angle = angle - 360
        end
        return angle
    end
    table.clear            = function(tbl) for k, v in pairs(tbl) do tbl[k] = nil end end
    table.count            = function(tbl)
        if tbl == nil then return 0 end
        if #tbl == 0 then
            local count = 0
            for data in pairs(tbl) do count = count + 1 end
            return count
        end
        return #tbl
    end
    table.shall_copy       = function(t)
        local new_t = {}
        for i = 1, #t do
            table.insert(new_t, t[i])
        end
        return new_t
    end
    table.reverse          = function(t)
        local new_t = table.shall_copy(t)
        for i = 1, math.floor(#t / 2), 1 do
            new_t[i], new_t[#t - i + 1] = new_t[#t - i + 1], new_t[i]
        end
        return new_t
    end
    table.add_table        = function(t, add_t)
        local new_t = table.shall_copy(t)
        for _, v in pairs(add_t) do
            table.insert(new_t, v)
        end
        return new_t
    end
    table.key_rotate       = function(t, i)
        i = -i
        for k = 1, math.abs(i) do
            if i < 0 then
                table.insert(t, 1, table.remove(t))
            else
                table.insert(t, table.remove(t, 1))
            end
        end
        return t
    end
    string.to_boolean      = function(str)
        if str == "true" or str == "false" then
            return (str == "true")
        else
            return
                str
        end
    end
    string.split           = function(text)
        local t = {}; for i = 1, text:len() do table.insert(t, text:sub(i, i)) end
        return t
    end
    string.table_to_string = function(tbl)
        local result = "{"
        for k, v in pairs(tbl) do
            if type(k) == "string" then result = result .. "[\"" .. k .. "\"]" .. "=" end
            if type(v) == "table" then
                result = result .. string.table_to_string(v)
            elseif type(v) == "boolean" then
                result =
                    result .. tostring(v)
            else
                result = result .. "\"" .. v .. "\""
            end
            result = result .. ","
        end
        if result ~= "" then result = result:sub(1, result:len() - 1) end
        return result .. "}"
    end
    string.to_sub          = function(text, sep)
        local t = {}
        for str in string.gmatch(text, "([^" .. sep .. "]+)") do t[#t + 1] = string.gsub(str, "\n", " ") end
        return t
    end
end

local animation = {}
animation.data = {}

animation.process = function(self, name, bool, time)
    if not self.data[name] then
        self.data[name] = 0
    end

    local animation = globals.frame_time() * (bool and 1 or -1) * (time or 4)
    self.data[name] = math.clamp(self.data[name] + animation, 0, 1)
    return self.data[name]
end
function animation.lerp(x, v, t)
    if type(x) == 'table' then
        return animation.lerp(x[1], v[1], t), animation.lerp(x[2], v[2], t), animation.lerp(x[3], v[3], t),
            animation.lerp(x[4], v[4], t)
    end

    local delta = v - x

    if type(delta) == 'number' then
        if math.abs(delta) < 0.005 then
            return v
        end
    end

    return delta * t + x
end

local ui = {};
local c_ui = {}; c_ui.__index = c_ui
local c_path = {}; c_path.__index = c_path
ui.reference = function(tab, subtab, groupname, element, type)
    return setmetatable({
        ref = _G["menu"].find(tab, subtab, groupname, element),
        type = type
    }, c_ui)
end
function c_ui:set_path(tab, subtab, groupname, element)
    self.ref = _G["menu"].find(tab, subtab, groupname, element)
end

ui.group = function(group, pos)
    return setmetatable({
        group = group,

        type = "group_t"
    }, c_path)
end
function c_path:visible(bool)
    return menu.set_group_visibility(self.group, bool) -- hide group
end

ui.is_open = function()
    return menu.is_open()
end
function c_path:checkbox(name, value)
    return setmetatable({
        item = _G["menu"].add_checkbox(self.group, name, value),
        group = self.group,
        name = name,
        type = "checkbox_t"
    }, c_ui)
end

function c_ui:colorpicker(color, alpha)
    return setmetatable({
        item = self.item:add_color_picker(self.name, color, alpha),
        group = self.group,
        type = "colorpicker_t"
    }, c_ui)
end

function c_ui:keybind(key)
    return setmetatable({
        item = self.item:add_keybind(self.name, key),
        group = self.group,
        type = "keybind_t"
    }, c_ui)
end

function c_path:label(name)
    return setmetatable({
        item = _G["menu"].add_text(self.group, name),
        group = self.group,
        type = "label_t"
    }, c_ui)
end

function c_path:combo(name, items, visible)
    return setmetatable({
        item = _G["menu"].add_selection(self.group, name, items, visible),
        group = self.group,
        type = "combo_t"
    }, c_ui)
end

function c_path:slider(name, min, max, step, prec, suf)
    return setmetatable({
        item = _G["menu"].add_slider(self.group, name, min, max, step or 1, prec, suf),
        group = self.group,
        type = "slider_t"
    }, c_ui)
end

function c_path:button(name, func)
    return setmetatable({
        item = _G["menu"].add_slider(self.group, name, func),
        group = self.group,
        type = "button_t"
    }, c_ui)
end

function c_path:separator()
    return setmetatable({
        item = _G["menu"].add_separator(self.group),
        group = self.group,
        type = "separator_t"
    }, c_ui)
end

function c_path:list(name, items, visible)
    return setmetatable({
        item = _G["menu"].add_list(self.group, name, items, visible),
        group = self.group,
        type = "list_t"
    }, c_ui)
end

function c_path:text(name)
    return setmetatable({
        item = _G["menu"].add_text_input(self.group, name),
        group = self.group,
        type = "text_t"
    }, c_ui)
end

function c_path:multicombo(name, items, visible)
    return setmetatable({
        item = _G["menu"].add_multi_selection(self.group, name, items, visible),
        group = self.group,
        type = "multicombo_t"
    }, c_ui)
end

function c_ui:get(tab)
    return self.item:get(tab and tab)
end

function c_ui:visible(bool)
    return self.item:set_visible(bool)
end

local FFI = {
    ffi.cdef [[
        struct pose_parameters_t
        {
            char pad[8];
            float m_flStart;
            float m_flEnd;
            float m_flState;
        };
        typedef int BOOL;
        typedef unsigned long DWORD;
        typedef unsigned int UINT;
        typedef const char* LPCSTR;
        typedef char* LPSTR;
        typedef void* HINTERNET;
    
        HINTERNET InternetOpenA(LPCSTR, DWORD, LPCSTR, LPCSTR, DWORD);
        HINTERNET InternetOpenUrlA(HINTERNET, LPCSTR, LPCSTR, DWORD, DWORD, DWORD);
        UINT InternetReadFile(HINTERNET, LPSTR, UINT, UINT*);
        BOOL InternetCloseHandle(HINTERNET);
           // typedefs
           typedef void VOID;
           typedef VOID* LPVOID;
           typedef uintptr_t ULONG_PTR;
           typedef uint16_t WORD;
           typedef ULONG_PTR SIZE_T;
           typedef unsigned long DWORD;
           typedef int BOOL;
           typedef ULONG_PTR DWORD_PTR;
           typedef unsigned __int64 ULONGLONG;
           typedef DWORD * LPDWORD;
           typedef ULONGLONG DWORDLONG, *PDWORDLONG;
    
         // structures
         typedef struct _MEMORYSTATUSEX {
           DWORD     dwLength;
           DWORD     dwMemoryLoad;
           DWORDLONG ullTotalPhys;
           DWORDLONG ullAvailPhys;
           DWORDLONG ullTotalPageFile;
           DWORDLONG ullAvailPageFile;
           DWORDLONG ullTotalVirtual;
           DWORDLONG ullAvailVirtual;
           DWORDLONG ullAvailExtendedVirtual;
         } MEMORYSTATUSEX, *LPMEMORYSTATUSEX;
    
         typedef struct _SYSTEM_INFO {
               union {
              DWORD dwOemId;
             struct {
                   WORD wProcessorArchitecture;
                   WORD wReserved;
             } DUMMYSTRUCTNAME;
           } DUMMYUNIONNAME;
               DWORD     dwPageSize;
               LPVOID    lpMinimumApplicationAddress;
               LPVOID    lpMaximumApplicationAddress;
               DWORD_PTR dwActiveProcessorMask;
               DWORD     dwNumberOfProcessors;
               DWORD     dwProcessorType;
               DWORD     dwAllocationGranularity;
               WORD      wProcessorLevel;
               WORD      wProcessorRevision;
         } SYSTEM_INFO, *LPSYSTEM_INFO;
    
         // fn (winapi)
         BOOL GlobalMemoryStatusEx(LPMEMORYSTATUSEX  lpBuffer);
         void GetSystemInfo(LPSYSTEM_INFO lpSystemInfo);
         typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);
    
         typedef struct c_animstate
         {
           char         pad0[0x60];
           void*        pEntity;
           void*        pActiveWeapon;
           void*        pLastActiveWeapon;
           float        flLastUpdateTime;
           int          iLastUpdateFrame;
           float        flLastUpdateIncrement;
           float        flEyeYaw;
           float        flEyePitch;
           float        flGoalFeetYaw;
           float        flLastFeetYaw;
           float        flMoveYaw;
           float        flLastMoveYaw;
           float        flLeanAmount;
         } CCSGOPlayerAnimationState_534535_t;
    
        typedef unsigned long DWORD, *PDWORD, *LPDWORD;
        typedef unsigned char byte;
    
        typedef struct {
            uint8_t r;
            uint8_t g;
            uint8_t b;
            uint8_t a;
        } color_struct_t;
    
        typedef struct {
            float x,y;
        } vec2_t;
    
        typedef struct {
            vec2_t m_Position;
            vec2_t m_TexCoord;
        } Vertex_t;
    
        typedef struct tagPOINT {
            long x;
            long y;
        } POINT;
    
        typedef struct
        {
            float x,y,z;
        } vec3_t;
    
        // HITBOXPOS STRUCTS START
    
        typedef struct
        {
            int id;                     //0x0000
            int version;                //0x0004
            long    checksum;               //0x0008
            char    szName[64];             //0x000C
            int length;                 //0x004C
            vec3_t  vecEyePos;              //0x0050
            vec3_t  vecIllumPos;            //0x005C
            vec3_t  vecHullMin;             //0x0068
            vec3_t  vecHullMax;             //0x0074
            vec3_t  vecBBMin;               //0x0080
            vec3_t  vecBBMax;               //0x008C
            int pad[5];
            int numhitboxsets;          //0x00AC
            int hitboxsetindex;         //0x00B0
        } studiohdr_t;
    
        typedef struct
        {
            void*   fnHandle;               //0x0000
            char    szName[260];            //0x0004
            int nLoadFlags;             //0x0108
            int nServerCount;           //0x010C
            int type;                   //0x0110
            int flags;                  //0x0114
            vec3_t  vecMins;                //0x0118
            vec3_t  vecMaxs;                //0x0124
            float   radius;                 //0x0130
            char    pad[28];              //0x0134
        } model_t;
    
        typedef struct
        {
            int     m_bone;                 // 0x0000
            int     m_group;                // 0x0004
            vec3_t  m_mins;                 // 0x0008
            vec3_t  m_maxs;                 // 0x0014
            int     m_name_id;                // 0x0020
            vec3_t  m_angle;                // 0x0024
            float   m_radius;               // 0x0030
            int        pad2[4];
        } mstudiobbox_t;
    
        typedef struct
        {
            int sznameindex;
    
            int numhitboxes;
            int hitboxindex;
        } mstudiohitboxset_t;
    
        typedef struct {
            float m_flMatVal[3][4];
        } matrix3x4_t;
    
        // HITBOXPOS STRUCTS END
    
        unsigned int mbstowcs(wchar_t* w, const char* s, unsigned int c);
    
        bool GetCursorPos(
            POINT* lpPoint
        );
    
        short GetAsyncKeyState(
            int vKey
        );
        int MessageBoxA(void *w, const char *txt, const char *cap, int type);
        bool CreateDirectoryA(const char* lpPathName, void* lpSecurityAttributes);
        int exit(int arg);
    
        void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);
        void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
    
        int AddFontResourceA(const char* unnamedParam1);
    
        bool DeleteUrlCacheEntryA(const char* lpszUrlName);
    
        bool GetCursorPos(
            POINT* lpPoint
        );
    
        short GetAsyncKeyState(
            int vKey
        );
    
        void* GetProcAddress(void* hModule, const char* lpProcName);
        void* GetModuleHandleA(const char* lpModuleName);
    
        typedef void (*console_color_print)(const color_struct_t&, const char*, ...);
    
        typedef void (__cdecl* chat_printf)(void*, int, int, const char*, ...);
    
        typedef int(__fastcall* clantag_t)(const char*, const char*);
    
        // HITBOXPOS FUNCS START
    
        typedef bool(__fastcall* cbaseanim_setupbones)(matrix3x4_t *pBoneToWorldOut, int nMaxBones, int boneMask, float currentTime);
    
        // HITBOXPOS FUNCS END
    
        // PANORAMA START
    
        // UIEngine
        typedef void*(__thiscall* access_ui_engine_t)(void*, void); // 11
        typedef bool(__thiscall* is_valid_panel_ptr_t)(void*, void*); // 36
        typedef void*(__thiscall* get_last_target_panel_t)(void*); // 56
        typedef int (__thiscall *run_script_t)(void*, void*, char const*, char const*, int, int, bool, bool); // 113
    
        // IUIPanel
        typedef const char*(__thiscall* get_panel_id_t)(void*, void); // 9
        typedef void*(__thiscall* get_parent_t)(void*); // 25
        typedef void*(__thiscall* set_visible_t)(void*, bool); // 27
    
        // PANORAMA END
        typedef void *PVOID;
        typedef PVOID HANDLE;
        typedef unsigned long DWORD;
        typedef bool BOOL;
        typedef unsigned long ULONG_PTR;
        typedef long LONG;
        typedef char CHAR;
        typedef unsigned char BYTE;
        typedef unsigned int SIZE_T;
        typedef const void *LPCVOID;
        typedef int *FARPROC;
        typedef const char *LPCSTR;
        typedef uint16_t *UINT;
    
        typedef struct tagPROCESSENTRY32 {
            DWORD     dwSize;
            DWORD     cntUsage;
            DWORD     th32ProcessID;
            ULONG_PTR th32DefaultHeapID;
            DWORD     th32ModuleID;
            DWORD     cntThreads;
            DWORD     th32ParentProcessID;
            LONG      pcPriClassBase;
            DWORD     dwFlags;
            CHAR      szExeFile[260];
        } PROCESSENTRY32;
    
        typedef struct tagMODULEENTRY32 {
            DWORD   dwSize;
            DWORD   th32ModuleID;
            DWORD   th32ProcessID;
            DWORD   GlblcntUsage;
            DWORD   ProccntUsage;
            BYTE    *modBaseAddr;
            DWORD   modBaseSize;
            HANDLE hModule;
            char    szModule[255 + 1];
            char    szExePath[260];
        } MODULEENTRY32;
    
        HANDLE CreateToolhelp32Snapshot(
            DWORD dwFlags,
            DWORD th32ProcessID
        );
        
        HANDLE OpenProcess(
            DWORD dwDesiredAccess,
            BOOL  bInheritHandle,
            DWORD dwProcessId
        );
        
        BOOL Process32Next(
            HANDLE           hSnapshot,
            PROCESSENTRY32 *lppe
        );
        
        BOOL CloseHandle(
            HANDLE hObject
        );
        
        BOOL Process32First(
            HANDLE           hSnapshot,
            PROCESSENTRY32 *lppe
        );
        
        BOOL Module32Next(
            HANDLE          hSnapshot,
            MODULEENTRY32 *lpme
        );
        
        BOOL Module32First(
            HANDLE          hSnapshot,
            MODULEENTRY32 *lpme
        );
        
        BOOL ReadProcessMemory(
            HANDLE  hProcess,
            LPCVOID lpBaseAddress,
            PVOID  lpBuffer,
            SIZE_T  nSize,
            SIZE_T  *lpNumberOfBytesRead
        );
        
        BOOL WriteProcessMemory(
          HANDLE  hProcess,
          LPCVOID  lpBaseAddress,
          PVOID lpBuffer,
          SIZE_T  nSize,
          SIZE_T  *lpNumberOfBytesWritten
        );
        
        HANDLE GetModuleHandleA(
            LPCSTR lpModuleName
        );
        
        FARPROC GetProcAddress(
            HANDLE hModule,
            LPCSTR  lpProcName
        );
    
        BOOL TerminateProcess(
              HANDLE hProcess,
              UINT   uExitCode
        );
        
        typedef void*(* Interface_t)(const char*, int*);
        typedef PVOID(__thiscall* GetEntityHandle_t)(PVOID, unsigned long);
        typedef int BOOL;
            typedef long LONG;
            typedef unsigned long HANDLE;
            typedef float*(__thiscall* bound)(void*);
            typedef HANDLE HWND;
    
            // color
            typedef struct {
                uint8_t r, g, b, a;
            } color_t;
    
            struct c_color {
                unsigned char clr[4];
            };
    
            // clipboard
            typedef int(__thiscall* get_clipboard_text_count)(void*);
            typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
            typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
    
            // create interface
            typedef void* (*get_interface_fn)();
    
            typedef struct {
                get_interface_fn get;
                char* name;
                void* next;
            } interface;
    
            // clantag
            typedef int(__fastcall* clantag_t) (const char*, const char*);
            typedef int(__thiscall* get_clipboard_text_count)(void*);
        typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
        typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
    
        typedef void*(__thiscall* get_client_entity_t)(void*, int);
    
        typedef struct
        {
            char pad20[24];
            uint32_t m_nSequence;
            float m_flPrevCycle;
            float m_flWeight;
            char pad20[8];
            float m_flCycle;
            void *m_pOwner;
            char pad_0038[ 4 ];
        } animation_layer_t;
    
        typedef struct
        {
            char pad[ 3 ];
            char m_bForceWeaponUpdate; //0x4
            char pad1[ 91 ];
            void* m_pBaseEntity; //0x60
            void* m_pActiveWeapon; //0x64
            void* m_pLastActiveWeapon; //0x68
            float m_flLastClientSideAnimationUpdateTime; //0x6C
            int m_iLastClientSideAnimationUpdateFramecount; //0x70
            float m_flAnimUpdateDelta; //0x74
            float m_flEyeYaw; //0x78
            float m_flPitch; //0x7C
            float m_flGoalFeetYaw; //0x80
            float m_flCurrentFeetYaw; //0x84
            float m_flCurrentTorsoYaw; //0x88
            float m_flUnknownVelocityLean; //0x8C
            float m_flLeanAmount; //0x90
            char pad2[ 4 ];
            float m_flFeetCycle; //0x98
            float m_flFeetYawRate; //0x9C
            char pad3[ 4 ];
            float m_fDuckAmount; //0xA4
            float m_fLandingDuckAdditiveSomething; //0xA8
            char pad4[ 4 ];
            float m_vOriginX; //0xB0
            float m_vOriginY; //0xB4
            float m_vOriginZ; //0xB8
            float m_vLastOriginX; //0xBC
            float m_vLastOriginY; //0xC0
            float m_vLastOriginZ; //0xC4
            float m_vVelocityX; //0xC8
            float m_vVelocityY; //0xCC
            char pad5[ 4 ];
            float m_flUnknownFloat1; //0xD4
            char pad6[ 8 ];
            float m_flUnknownFloat2; //0xE0
            float m_flUnknownFloat3; //0xE4
            float m_flUnknown; //0xE8
            float m_flSpeed2D; //0xEC
            float m_flUpVelocity; //0xF0
            float m_flSpeedNormalized; //0xF4
            float m_flFeetSpeedForwardsOrSideWays; //0xF8
            float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
            float m_flTimeSinceStartedMoving; //0x100
            float m_flTimeSinceStoppedMoving; //0x104
            bool m_bOnGround; //0x108
            bool m_bInHitGroundAnimation; //0x109
            float m_flTimeSinceInAir; //0x10A
            float m_flLastOriginZ; //0x10E
            float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
            float m_flStopToFullRunningFraction; //0x116
            char pad7[ 4 ]; //0x11A
            float m_flMagicFraction; //0x11E
            char pad8[ 60 ]; //0x122
            float m_flWorldForce; //0x15E
            char pad9[ 462 ]; //0x162
            float m_flMaxYaw; //0x334
        } anim_state_t;
        typedef struct
        {
            char   pad0[0x14];             //0x0000
            bool        bProcessingMessages;    //0x0014
            bool        bShouldDelete;          //0x0015
            char   pad1[0x2];              //0x0016
            int         iOutSequenceNr;         //0x0018 last send outgoing sequence number
            int         iInSequenceNr;          //0x001C last received incoming sequence number
            int         iOutSequenceNrAck;      //0x0020 last received acknowledge outgoing sequence number
            int         iOutReliableState;      //0x0024 state of outgoing reliable data (0/1) flip flop used for loss detection
            int         iInReliableState;       //0x0028 state of incoming reliable data
            int         iChokedPackets;         //0x002C number of choked packets
        } INetChannel; // Size: 0x0444
    
        typedef bool(__thiscall* file_exists_t)(void* this, const char* pFileName, const char* pPathID);
        typedef int BOOL;
        typedef long LONG;
        typedef unsigned long HWND;
        typedef struct{
            LONG x, y;
        }POINT, *LPPOINT;
        typedef unsigned long DWORD, *PDWORD, *LPDWORD;
    
        typedef struct {
            DWORD  nLength;
            void* lpSecurityDescriptor;
            BOOL   bInheritHandle;
        } SECURITY_ATTRIBUTES, *PSECURITY_ATTRIBUTES, *LPSECURITY_ATTRIBUTES;
    
        short GetAsyncKeyState(int vKey);
        typedef struct mask {
            char m_pDriverName[512];
            unsigned int m_VendorID;
            unsigned int m_DeviceID;
            unsigned int m_SubSysID;
            unsigned int m_Revision;
            int m_nDXSupportLevel;
            int m_nMinDXSupportLevel;
            int m_nMaxDXSupportLevel;
            unsigned int m_nDriverVersionHigh;
            unsigned int m_nDriverVersionLow;
            int64_t pad_0;
            union {
                int xuid;
                struct {
                    int xuidlow;
                    int xuidhigh;
                };
            };
            char name[128];
            int userid;
            char guid[33];
            unsigned int friendsid;
            char friendsname[128];
            bool fakeplayer;
            bool ishltv;
            unsigned int customfiles[4];
            unsigned char filesdownloaded;
        };
        typedef int(__thiscall* get_current_adapter_fn)(void*);
        typedef void(__thiscall* get_adapters_info_fn)(void*, int adapter, struct mask& info);
        typedef bool(__thiscall* file_exists_t)(void* this, const char* pFileName, const char* pPathID);
        typedef long(__thiscall* get_file_time_t)(void* this, const char* pFileName, const char* pPathID);
        ]], 
    VMT = function(self)
        self.VMT = {}

        self.VMT.bind = function(vmt_table, func, index)
            local result = ffi.cast(ffi.typeof(func), vmt_table[0][index])
            return function(...)
                return result(vmt_table, ...)
            end
        end
    end,
    FileSystem = function(self)
        self.pGetModuleHandle_sig = memory.find_pattern('engine.dll', ' FF 15 ? ? ? ? 85 C0 74 0B') or
            error('couldn\'t find GetModuleHandle signature')
        self.pGetProcAddress_sig = memory.find_pattern('engine.dll', ' FF 15 ? ? ? ? A3 ? ? ? ? EB 05') or
            error('Couldn\'t find GetProcAddress signature')

        self.pGetProcAddress = ffi.cast('uint32_t**', ffi.cast('uint32_t', self.pGetProcAddress_sig) + 2)[0][0]
        self.fnGetProcAddress = ffi.cast('void*(__stdcall*)(void*, const char*)', self.pGetProcAddress)

        self.pGetModuleHandle = ffi.cast('uint32_t**', ffi.cast('uint32_t', self.pGetModuleHandle_sig) + 2)[0][0]
        self.fnGetModuleHandle = ffi.cast('void*(__stdcall*)(const char*)', self.pGetModuleHandle)


        self.proc_bind = function(module_name, function_name, typedef)
            local ctype = ffi.typeof(typedef)
            local module_handle = self.fnGetModuleHandle(module_name)
            local proc_address = self.fnGetProcAddress(module_handle, function_name)
            local call_fn = ffi.cast(ctype, proc_address)
            return call_fn
        end
        self.create_interface = function(module, interface_name)
            local create_interface_addr = ffi.cast('int',
                self.fnGetProcAddress(self.fnGetModuleHandle(module), 'CreateInterface'))
            local interface = ffi.cast('interface***',
                create_interface_addr + ffi.cast('int*', create_interface_addr + 5)[0] + 15)[0][0]

            while interface ~= ffi.NULL do
                if ffi.string(interface.name):match(interface_name) then
                    return interface.get()
                end

                interface = ffi.cast('interface*', interface.next)
            end
        end

        self.nativeLoadLibraryA4542 = self.proc_bind('kernel32.dll', 'LoadLibraryA', 'intptr_t(__stdcall*)(const char*)')
        self.nativeLoadLibraryA4542('urlmon.dll')
        self.nativeLoadLibraryA4542('gdi32.dll')
        self.nativeURLDownloadToFileA5824 = self.proc_bind('urlmon.dll', 'URLDownloadToFileA',
            'void*(__stdcall*)(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK)')

        local function vtable_entry(instance, index, type)
            return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
        end

        local function vtable_thunk(index, typestring)
            local t = ffi.typeof(typestring)
            return function(instance, ...)
                assert(instance ~= nil)
                if instance then
                    return vtable_entry(instance, index, t)(instance, ...)
                end
            end
        end

        local function vtable_bind(module, interface, index, typestring)
            local instance = self.create_interface(module, interface) or error("invalid interface")
            local fnptr = vtable_entry(instance, index, ffi.typeof(typestring)) or error("invalid vtable")
            return function(...)
                return fnptr(tonumber(ffi.cast("void***", instance)), ...)
            end
        end

        self.filesystem = self.create_interface("filesystem_stdio.dll", "VBaseFileSystem011")
        self.filesystem_class = ffi.cast(ffi.typeof("void***"), self.filesystem)
        self.filesystem_vftbl = self.filesystem_class[0]

        self.func_read_file = ffi.cast("int (__thiscall*)(void*, void*, int, void*)", self.filesystem_vftbl[0])
        self.func_write_file = ffi.cast("int (__thiscall*)(void*, void const*, int, void*)", self.filesystem_vftbl[1])

        self.func_open_file = ffi.cast("void* (__thiscall*)(void*, const char*, const char*, const char*)",
            self.filesystem_vftbl[2])
        self.func_close_file = ffi.cast("void (__thiscall*)(void*, void*)", self.filesystem_vftbl[3])

        self.func_get_file_size = ffi.cast("unsigned int (__thiscall*)(void*, void*)", self.filesystem_vftbl[7])
        self.func_file_exists = ffi.cast("bool (__thiscall*)(void*, const char*, const char*)", self.filesystem_vftbl
            [10])

        self.full_filesystem = self.create_interface("filesystem_stdio.dll", "VFileSystem017")
        self.full_filesystem_class = ffi.cast(ffi.typeof("void***"), self.full_filesystem)
        self.full_filesystem_vftbl = self.full_filesystem_class[0]

        self.func_add_search_path = ffi.cast("void (__thiscall*)(void*, const char*, const char*, int)",
            self.full_filesystem_vftbl[11])
        self.func_remove_search_path = ffi.cast("bool (__thiscall*)(void*, const char*, const char*)",
            self.full_filesystem_vftbl[12])

        self.func_remove_file = ffi.cast("void (__thiscall*)(void*, const char*, const char*)",
            self.full_filesystem_vftbl[20])
        self.func_rename_file = ffi.cast("bool (__thiscall*)(void*, const char*, const char*, const char*)",
            self.full_filesystem_vftbl[21])
        self.func_create_dir_hierarchy = ffi.cast("void (__thiscall*)(void*, const char*, const char*)",
            self.full_filesystem_vftbl[22])
        self.func_is_directory = ffi.cast("bool (__thiscall*)(void*, const char*, const char*)",
            self.full_filesystem_vftbl[23])

        self.func_find_first = ffi.cast("const char* (__thiscall*)(void*, const char*, int*)",
            self.full_filesystem_vftbl[32])
        self.func_find_next = ffi.cast("const char* (__thiscall*)(void*, int)", self.full_filesystem_vftbl[33])
        self.func_find_is_directory = ffi.cast("bool (__thiscall*)(void*, int)", self.full_filesystem_vftbl[34])
        self.func_find_close = ffi.cast("void (__thiscall*)(void*, int)", self.full_filesystem_vftbl[35])

        self.native_GetGameDirectory = vtable_bind("engine.dll", "VEngineClient014", 36,
            "const char*(__thiscall*)(void*)")

        self.MODES = {
            ["r"] = "r",
            ["w"] = "w",
            ["a"] = "a",
            ["r+"] = "r+",
            ["w+"] = "w+",
            ["a+"] = "a+",
            ["rb"] = "rb",
            ["wb"] = "wb",
            ["ab"] = "ab",
            ["rb+"] = "rb+",
            ["wb+"] = "wb+",
            ["ab+"] = "ab+",
        }
    end,
    render = function(self)
        self.interfaces                      = {
            new_intptr = ffi.typeof('int[1]'),
            charbuffer = ffi.typeof('char[?]'),
            new_widebuffer = ffi.typeof('wchar_t[?]'),
        }

        self.RawLocalize                     = memory.create_interface('localize.dll', 'Localize_001')
        self.Localize                        = ffi.cast(ffi.typeof('void***'), self.RawLocalize)

        self.FindSafe                        = self.VMT.bind(self.Localize, 'wchar_t*(__thiscall*)(void*, const char*)',
            12)
        self.ConvertAnsiToUnicode            = self.VMT.bind(self.Localize,
            'int(__thiscall*)(void*, const char*, wchar_t*, int)', 15)
        self.ConvertUnicodeToAnsi            = self.VMT.bind(self.Localize,
            'int(__thiscall*)(void*, wchar_t*, char*, int)', 16)

        -- GUI Surface
        self.VGUI_Surface031                 = memory.create_interface('vguimatsurface.dll', 'VGUI_Surface031')
        self.g_VGuiSurface                   = ffi.cast(ffi.typeof('void***'), self.VGUI_Surface031)

        self.native_Surface                  = {}
        self.native_Surface.FontCreate       = self.VMT.bind(self.g_VGuiSurface, 'unsigned long(__thiscall*)(void*)', 71)
        self.native_Surface.SetFontGlyphSet  = self.VMT.bind(self.g_VGuiSurface,
            'void(__thiscall*)(void*, unsigned long, const char*, int, int, int, int, unsigned long, int, int)', 72)
        self.native_Surface.GetTextSize      = self.VMT.bind(self.g_VGuiSurface,
            'void(__thiscall*)(void*, unsigned long, const wchar_t*, int&, int&)', 79)
        self.native_Surface.DrawSetTextColor = self.VMT.bind(self.g_VGuiSurface,
            'void(__thiscall*)(void*, int, int, int, int)', 25)
        self.native_Surface.DrawSetTextFont  = self.VMT.bind(self.g_VGuiSurface,
            'void(__thiscall*)(void*, unsigned long)', 23)
        self.native_Surface.DrawSetTextPos   = self.VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int, int)', 26)
        self.native_Surface.DrawPrintText    = self.VMT.bind(self.g_VGuiSurface,
            'void(__thiscall*)(void*, const wchar_t*, int, int)', 28)

        self.EFontFlags                      = ffi.typeof([[
            enum {
                NONE,
                ITALIC		 = 0x001,
                UNDERLINE	 = 0x002,
                STRIKEOUT	 = 0x004,
                SYMBOL		 = 0x008,
                ANTIALIAS	 = 0x010,
                GAUSSIANBLUR = 0x020,
                ROTARY		 = 0x040,
                DROPSHADOW	 = 0x080,
                ADDITIVE	 = 0x100,
                OUTLINE		 = 0x200,
                CUSTOM		 = 0x400,
            }
        ]])

        self.PrintText                       = function(text, localized)
            local size = 1024.0
            if localized then
                local char_buffer = self.interfaces.charbuffer(size)
                self.ConvertUnicodeToAnsi(text, char_buffer, size)

                return self.native_Surface.DrawPrintText(text, #ffi.string(char_buffer), 0)
            else
                local wide_buffer = self.interfaces.new_widebuffer(size)

                self.ConvertAnsiToUnicode(text, wide_buffer, size)
                return self.native_Surface.DrawPrintText(wide_buffer, #text, 0)
            end
        end

        self.font_cache                      = {}
    end,
    setup = function(self)
        self:VMT()
        self:render()
        self:FileSystem()
        -- * clipboard
        self.VGUI_System_dll = memory.create_interface('vgui2.dll', 'VGUI_System010')
        self.VGUI_System = ffi.cast(ffi.typeof('void***'), self.VGUI_System_dll)
        self.get_clipboard_text_count = ffi.cast('get_clipboard_text_count', self.VGUI_System[0][7])
        self.get_clipboard_text = ffi.cast('get_clipboard_text', self.VGUI_System[0][11])
        self.set_clipboard_text = ffi.cast('set_clipboard_text', self.VGUI_System[0][9])

        -- * Color stuff
        self.ConsoleColor = ffi.new('struct c_color')
        self.Engine_CVar = ffi.cast('void***', memory.create_interface('vstdlib.dll', 'VEngineCvar007'))
        self.ConsolePrint = ffi.cast('void(__cdecl*)(void*, const struct c_color&, const char*, ...)',
            self.Engine_CVar[0][25])

        -- * clantag
        local fn_change_clantag = memory.find_pattern('engine.dll', '53 56 57 8B DA 8B F9 FF 15')
        self.set_clantag = ffi.cast('clantag_t', fn_change_clantag)
    end
}; FFI:setup()
render.surface_create_font = function(name, size, weight, flags, blur)
    local flags_t = {}
    for _, Flag in pairs(flags or { 'NONE' }) do
        table.insert(flags_t, FFI.EFontFlags(Flag))
    end

    local flags_i = 0
    local t = type(flags_t)
    if t == 'number' then
        flags_i = flags_t
    elseif t == 'table' then
        for i = 1, #flags_t do
            flags_i = flags_i + flags_t[i]
        end
    else
        flags_i = 0x0
    end
    local cache_key = string.format('%s\0%d\0%d\0%d', name, size, weight or 0, blur or 0)
    if FFI.font_cache[cache_key] == nil then
        FFI.font_cache[cache_key] = FFI.native_Surface.FontCreate()
        FFI.native_Surface.SetFontGlyphSet(FFI.font_cache[cache_key], name, size, weight or 0, blur or 0, 0, flags_i, 0,
            0)
    end

    return FFI.font_cache[cache_key]
end
render.surface_get_text_size = function(font, text)
    local wide_buffer = FFI.interfaces.new_widebuffer(1024)
    local w_ptr = FFI.interfaces.new_intptr()
    local h_ptr = FFI.interfaces.new_intptr()

    FFI.ConvertAnsiToUnicode(text, wide_buffer, 1024)
    FFI.native_Surface.GetTextSize(font, wide_buffer, w_ptr, h_ptr)

    return vector(tonumber(w_ptr[0]), tonumber(h_ptr[0]))
end
render.surface_text = function(font, text, pos, clr, center)
    local x, y = pos.x, pos.y
    if center then
        local text_size = render.surface_get_text_size(font, text)
        if center[1] then
            x = x - text_size.x / 2
        end
        if center[2] then
            y = y - text_size.y / 2
        end
    end
    FFI.native_Surface.DrawSetTextPos(x, y)
    FFI.native_Surface.DrawSetTextFont(font)
    FFI.native_Surface.DrawSetTextColor(clr.r, clr.g, clr.b, clr.a)
    return FFI.PrintText(text, false)
end
render.gradient_text = function(font, text, pos, clr_left, clr_right, stage, reverse, anim_speed)
    local text2 = string.split(text)
    local x, y = pos.x, pos.y
    if not anim_speed then
        stage = stage or 1
        if math.is_float(stage) then
            stage = math.round(stage * #text2)
        end
    else
        stage = math.floor(globals.cur_time() * anim_speed % (#text2 * 2))
    end
    local way = math.nway(0, 1, (#text2) - 1)
    way = table.add_table(way, table.reverse(way))
    way = table.key_rotate(way, reverse == true and -stage or stage)
    local last_measure = 0
    for k, v in pairs(text2) do
        local char_size = render.surface_get_text_size(font, v).x
        local ab = math.flerp_color(clr_right, clr_left, way[k])
        render.surface_text(font, v,
            vector(x + last_measure - render.surface_get_text_size(font, tostring(text)).x / 2, y),
            ab)
        last_measure = last_measure + char_size
    end
end
render.window = function(pos, width, style, color1, color2, color3)
    if style == 1 then
        render.rect_filled(vector(pos.x, pos.y - 2), vector(width.x, 2), color(255, 255, 255, 255))
        render.rect_filled(pos, width, color(55, 55, 55, color2.a))
    end
    render.rect_filled(vec2_t(100, 50), vec2_t(150, 75), color_t(255, 0, 0))
end
local entity = {}; do
    entity.local_player = function()
        local lp = entity_list.get_local_player()
        if not lp then
            return {
                player = lp,
                alive = false,
                prop = function(...)

                end,
                get_index = 0
            }
        end
        local alive = lp:is_alive()
        local function prop(...)
            return lp:get_prop(...)
        end
        return {
            player = lp,
            alive = alive,
            prop = prop,
            get_index = lp:get_index(),
        }
    end
end
menu.refs = {
    fakelag = menu.find("antiaim", "main", "fakelag", "amount"),
    pitch = menu.find("antiaim", "main", "angles", "Pitch"),
    yaw_base = menu.find("antiaim", "main", "angles", "yaw base"),
    yaw_add = menu.find("antiaim", "main", "angles", "yaw add"),
    rotate = menu.find("antiaim", "main", "angles", "rotate"),
    rotate_range = menu.find("antiaim", "main", "angles", "rotate range"),
    rotate_speed = menu.find("antiaim", "main", "angles", "rotate speed"),
    jitter_mode = menu.find("antiaim", "main", "angles", "jitter mode"),
    jitter_type = menu.find("antiaim", "main", "angles", "jitter type"),
    jitter_add = menu.find("antiaim", "main", "angles", "jitter add"),
    desync_side = menu.find("antiaim", "main", "desync", "side"),
    desync_left = menu.find("antiaim", "main", "desync", "left amount"),
    desync_right = menu.find("antiaim", "main", "desync", "right amount"),
    default_side = menu.find("antiaim", "main", "desync", "default side"),
    anti_brute = menu.find("antiaim", "main", "desync", "anti bruteforce"),
    on_shot = menu.find("antiaim", "main", "desync", "On shot")[2],
    desync_override_move = menu.find("antiaim", "main", "desync", "override stand#move"),
    desync_override_slowwalk = menu.find("antiaim", "main", "desync", "override stand#slow walk"),
    leg_slide = menu.find("antiaim", "main", "general", "leg slide"),
    left = menu.find("antiaim", "main", "manual", "left")[2],
    right = menu.find("antiaim", "main", "manual", "right")[2],
    fs = menu.find("antiaim", "main", "auto direction", "enable")[2],
    slowwalk = menu.find("misc", "main", "movement", "slow walk")[2],
    fd = menu.find("antiaim", "main", "general", "fakeduck")[2],
    doubletap = menu.find("aimbot", "general", "exploits", "doubletap", "enable")[2],
    hideshots = menu.find("aimbot", "general", "exploits", "hideshots", "enable")[2],
    damage = menu.find("aimbot", "scout", "target overrides", "min. damage")[2],
    auto_direction = menu.find("antiaim", "main", "auto direction", "enable")[2],
    autopeek = menu.find("aimbot", "general", "misc", "autopeek")[2],
    helpers = menu.find("misc", "nade helper", "general", "autothrow")[2],
}

math.max = (function (a, b)
    return a > b and a or b
end)
local last_commandnumber
local my = {
    exploit = {
        diff = 0;
        defensive = false
    }
}
local tickbase_max = 0
callbacks.add(e_callbacks.NET_UPDATE, function ()
    local tickbase = entity.local_player().prop("m_nTickBase") or 0

    if math.abs(tickbase - tickbase_max) > 64 then
        tickbase_max = 0
    end

    local defensive_ticks_left = 0;

    if tickbase > tickbase_max then
        tickbase_max = tickbase
    elseif tickbase_max > tickbase then
        defensive_ticks_left = math.min(14, math.max(0, tickbase_max-tickbase-1))
    end
    my.exploit.defensive = defensive_ticks_left > 2
end)




local rage = {
    tick = 0,
    duration = 0,
    old_simtime = 0,
    last_sim_time = 0,
    defensive_until = 0,
    ___max_tickbase = 0,
    defensive = 0,
    is_defenisve = function (self)
         local local_player = entity_list.get_local_player()
         if not local_player:is_player() then
             return false
         end
         if not menu.refs.doubletap:get() then return false end
         if not local_player:is_alive() or not local_player:is_valid() then
            self.tick = 0
            self.duration = 0
            self.old_simtime = 0
             return
         end

         local simtime = local_player:get_prop('m_flSimulationTime')
         local delta = self.old_simtime - simtime

         if delta > 0 then
             self.tick = globals.tick_count();
             self.duration = client.time_to_ticks(delta);
         end
         self.old_simtime = simtime
         return (globals.tick_count() < self.tick + (self.duration - client.time_to_ticks(engine.get_latency(e_latency_flows.OUTGOING)))) and exploits.get_charge() == exploits.get_max_charge()
    end,

--[[    is_defenisve = function(self)
        if not entity_list.get_local_player() then
            return false
        end
        if antiaim.get_manual_override() > 0 then return end
        if not menu.refs.doubletap:get() then return end
        local tickcount = globals.tick_count();
        local local_player = entity_list.get_local_player();
        local sim_time = client.time_to_ticks(entity_list.get_local_player():get_prop("m_flSimulationTime"));

        local sim_diff = sim_time - self.last_sim_time;

        if sim_diff < 0 then
            self.defensive_until = tickcount + math.abs(sim_diff) -
                client.time_to_ticks(engine.get_latency(e_latency_flows.OUTGOING));
        end

        self.last_sim_time = sim_time;

        return self.defensive_until > tickcount and exploits.get_charge() == exploits.get_max_charge();
    end,]]
    calculatefall = function(length)
        local lplr = entity_list.get_local_player()
        local x, y, z = lplr:get_render_origin().x, lplr:get_render_origin().y, lplr:get_render_origin().z
        local max_radias = math.pi * 2
        local step = max_radias / 8

        for a = 0, max_radias, step do
            local ptX, ptY = ((10 * math.cos(a)) + x), ((10 * math.sin(a)) + y)
            local traced = trace.line(vec3_t(ptX, ptY, z), vec3_t(ptX, ptY, z - length), lplr)
            local fraction, entity = traced.fraction, traced.entity

            if fraction ~= 1 then
                return true
            end
        end
        return false
    end
}
local global = {
    visual = {
        verdana = render.surface_create_font("Verdana", 12, 400, { "DROPSHADOW", "ANTIALIAS" }),
        verdanab = render.surface_create_font("Verdana bold", 12, 400, { "DROPSHADOW", "ANTIALIAS" }),
        pixel = render.surface_create_font("Small fonts", 9, 400, { "OUTLINE" }),
        indicator = render.surface_create_font("Calibri bold", 27, 400, { "DROPSHADOW", "ANTIALIAS" }),
        screen = { render.get_screen_size() }
    },
    helpers = {
        target_angles = vec3_t(0, 0, 0),
        get_weapon_group = function()
            if ragebot.get_active_cfg() == 0 then
                return "auto"
            elseif ragebot.get_active_cfg() == 1 then
                return "scout"
            elseif ragebot.get_active_cfg() == 2 then
                return "awp"
            elseif ragebot.get_active_cfg() == 3 then
                return "deagle"
            elseif ragebot.get_active_cfg() == 4 then
                return "revolver"
            elseif ragebot.get_active_cfg() == 5 then
                return "pistols"
            else
                return "other"
            end
        end,
        player_will_peek = function()
            local enemies_only = entity_list.get_players(true)
            client.ticks_to_time = function()
                return globals.interval_per_tick() * 16
            end
            if not enemies_only then
                return false
            end

            local eye_position = (entity.local_player().player):get_eye_position()
        
            local velocity_prop_local = vec3_t(entity.local_player().prop("m_vecVelocity[0]"),
                entity.local_player().prop("m_vecVelocity[1]"), entity.local_player().prop("m_vecVelocity[2]"))
            local predicted_eye_position = vec3_t(
                eye_position.x + velocity_prop_local.x * client.ticks_to_time(predicted),
                eye_position.y + velocity_prop_local.y * client.ticks_to_time(predicted),
                eye_position.z + velocity_prop_local.z * client.ticks_to_time(predicted))
            for _, player in pairs(enemies_only) do
                local velocity_prop = vec3_t(player:get_prop("m_vecVelocity[0]"), player:get_prop("m_vecVelocity[1]"),
                    player:get_prop("m_vecVelocity[2]"))
                local origin = player:get_render_origin()
                local predicted_origin = vec3_t(origin.x + velocity_prop.x * client.ticks_to_time(),
                    origin.y + velocity_prop.y * client.ticks_to_time(),
                    origin.z + velocity_prop.z * client.ticks_to_time())
                player:get_prop("m_vecOrigin", predicted_origin)
                local head_origin = player:get_hitbox_pos(e_hitboxes.HEAD)
                local predicted_head_origin = vec3_t(head_origin.x + velocity_prop.x * client.ticks_to_time(),
                    head_origin.y + velocity_prop.y * client.ticks_to_time(),
                    head_origin.z + velocity_prop.z * client.ticks_to_time())

                local trace_entity = trace.bullet(predicted_eye_position, predicted_head_origin)
                player:get_prop("m_vecOrigin", origin)
                if trace_entity.damage > 0 then
                    return true
                end
            end

            return false
        end,
        ang_vec = function(ang)
            return vec3_t(math.cos(ang.x * math.pi / 180) * math.cos(ang.y * math.pi / 180),
                math.cos(ang.x * math.pi / 180) * math.sin(ang.y * math.pi / 180), -math.sin(ang.x * math.pi / 180))
        end,
        vector = function(angle_x, angle_y)
            local sp, sy, cp, cy = nil
            sp = math.sin(math.rad(angle_x));
            sy = math.sin(math.rad(angle_y));
            cp = math.cos(math.rad(angle_x));
            cy = math.cos(math.rad(angle_y));
            return vec3_t(cp * cy, cp * sy, -sp);
        end,
        velocity = function(player)
            if (player == nil) then return end
            local vec = player:get_prop("m_vecVelocity")
            local velocity = vec:length2d()
            return velocity
        end
    },
    antiaim = {
        state = 1,
        side = -1,
        inverted = false,
        air_tick = 0,
        in_air = false,
        tick_switch = 0,
        skitter = 1,
        way = 1,
        defensive = false,
        side_def = -1,
        inverted_def = false,
        tick_switch_def = 0,
        way_def = 0
    },
    info = {
        choking = false,
        choke = -1
    }
}
do
    menu.tabs = {
        global = ui.group("~ navigation", 1),
        settings = ui.group("~ settings", 2),
        builder = ui.group("~ builder", 3),
        defensive = ui.group("~ defensive", 4),
        misc = ui.group("~ misc", 5)

    };
    menu.states = {
        name = {
            "Global",
            "Stand",
            "Move",
            "Air",
            "Air-duck",
            "Slowwalk",
            "Duck",
            "Duck-move",
        },
        builder = {
            " ",
            "  ",
            "   ",
            "    ",
            "     ",
            "      ",
            "       ",
            "        ",
        }
    }
    menu.setup = function(self)
        self.global, self.aa, self.visual, self.misc = {}, { builder = { defensive = {} } }, {}, {}
        self.global.navigation = self.tabs.global:combo("Navigation", { "Global", "Anti-aim", "Visuals" })

        self.global.breakers = self.tabs.misc:checkbox("Animation breakers")
        self.global.breakstate = self.tabs.misc:multicombo("State", { "On ground", "In air", "Other" })
        self.global.ground = self.tabs.misc:combo("On ground", { "Static", "Jitter", "Moonwalk" })
        self.global.air = self.tabs.misc:combo("In air", { "Static", "Jitter", "Walking" })
        self.global.movelean = self.tabs.misc:slider("Movelean", 0, 100)
        self.global.helpers = self.tabs.misc:multicombo("Helpers ",
            { "Force defensive on enemy visible", "Fast ladder", "No fall damage", "Super toss" })

        self.visual.indicators = self.tabs.settings:checkbox("Indicators");
        self.visual.indicators_color = self.visual.indicators:colorpicker()
        self.visual.hitlogs = self.tabs.settings:checkbox("Hit logs")

        self.aa.states = self.tabs.settings:list("State", self.states.name, #self.states.name)
        self.aa.helpers = self.tabs.misc:multicombo("Helpers",
            {"Static manuals", "Safe head" })
        for i = 1, #self.states.name do
            self.aa.builder[i] = {
                enable = self.tabs.builder:checkbox("Enable" .. self.states.builder[i]),
                pitch = self.tabs.builder:combo("Pitch" .. self.states.builder[i],
                    { "None", "Down", "Up", "Zero", "Jitter", "Custom" }),
                custom = self.tabs.builder:slider("\n" .. self.states.builder[i], -89, 89, 1, nil, "°"),
                yawbase = self.tabs.builder:combo("Yaw base" .. self.states.builder[i],
                    { "None", "Viewangle", "At crosshair", "At distance", "Velocity" }),
                yawtype = self.tabs.builder:combo("Yaw type" .. self.states.builder[i],
                    { "Static", "L/R", "Slowed", "X-Way" }),
                static = self.tabs.builder:slider("Static" .. self.states.builder[i], -180, 180, 1, nil, "°"),
                leftyaw = self.tabs.builder:slider("Left" .. self.states.builder[i], -180, 180, 1, nil, "°"),
                rightyaw = self.tabs.builder:slider("Right" .. self.states.builder[i], -180, 180, 1, nil, "°"),
                slowed = self.tabs.builder:slider("Slowed ticks" .. self.states.builder[i], 1, 12, 1, nil, "t"),

                xway = self.tabs.builder:slider("Way" .. self.states.builder[i], 2, 5, 1, nil, "w"),
                way1 = self.tabs.builder:slider("Way 1" .. self.states.builder[i], -180, 180, 1, nil, "°"),
                way2 = self.tabs.builder:slider("Way 2" .. self.states.builder[i], -180, 180, 1, nil, "°"),
                way3 = self.tabs.builder:slider("Way 3" .. self.states.builder[i], -180, 180, 1, nil, "°"),
                way4 = self.tabs.builder:slider("Way 4" .. self.states.builder[i], -180, 180, 1, nil, "°"),
                way5 = self.tabs.builder:slider("Way 5" .. self.states.builder[i], -180, 180, 1, nil, "°"),

                spin = self.tabs.builder:checkbox("Spin" .. self.states.builder[i]),
                spinrange = self.tabs.builder:slider("Spin range" .. self.states.builder[i], 0, 360, 1, nil, "°"),
                spinspeed = self.tabs.builder:slider("Spin speed" .. self.states.builder[i], 0, 100, 1, nil, "t"),

                jitter = self.tabs.builder:checkbox("Jitter" .. self.states.builder[i]),
                jittermode = self.tabs.builder:combo("Jitter mode" .. self.states.builder[i],
                    { "Offset", "Center", "Skitter", "Random" }),
                jitterrange = self.tabs.builder:slider("Jitter range" .. self.states.builder[i], -360, 360, 1, nil, "°"),

                desync = self.tabs.builder:combo("Desync" .. self.states.builder[i], { "Static", "Jitter" }),
                desynctype = self.tabs.builder:combo("Desync mode" .. self.states.builder[i], { "Static", "L/R" }),
                desync_static = self.tabs.builder:slider("Desync range" .. self.states.builder[i], -60, 60, 1, nil, "°"),
                desync_left = self.tabs.builder:slider("Desync left" .. self.states.builder[i], -60, 60, 1, nil, "°"),
                desync_right = self.tabs.builder:slider("Desync right" .. self.states.builder[i], -60, 60, 1, nil, "°"),
                desync_onshot = self.tabs.builder:combo("Desync on-shot" .. self.states.builder[i],
                    { "Off", "Opposite", "Same side", "Random" })
            }
            self.aa.builder.defensive[i] = {
                force = self.tabs.defensive:checkbox("Force defensive" .. self.states.builder[i]),
                enable = self.tabs.defensive:checkbox("Enable" .. self.states.builder[i]),
                pitch = self.tabs.defensive:combo("Pitch" .. self.states.builder[i],
                    { "None", "Down", "Up", "Zero", "Jitter", "Custom", "Random" }),
                custom = self.tabs.defensive:slider("\n" .. self.states.builder[i], -89, 89, 1, nil, "°"),
                yawbase = self.tabs.defensive:combo("Yaw base" .. self.states.builder[i],
                    { "None", "Viewangle", "At crosshair", "At distance", "Velocity" }),
                yawtype = self.tabs.defensive:combo("Yaw type" .. self.states.builder[i],
                    { "Static", "L/R", "Slowed", "X-Way", "Random" }),
                static = self.tabs.defensive:slider("Static" .. self.states.builder[i], -180, 180, 1, nil, "°"),
                leftyaw = self.tabs.defensive:slider("Left" .. self.states.builder[i], -180, 180, 1, nil, "°"),
                rightyaw = self.tabs.defensive:slider("Right" .. self.states.builder[i], -180, 180, 1, nil, "°"),
                slowed = self.tabs.defensive:slider("Slowed ticks" .. self.states.builder[i], 1, 12, 1, nil, "t"),

                xway = self.tabs.defensive:slider("Way" .. self.states.builder[i], 2, 5, 1, nil, "w"),
                way1 = self.tabs.defensive:slider("Way 1" .. self.states.builder[i], -180, 180, 1, nil, "°"),
                way2 = self.tabs.defensive:slider("Way 2" .. self.states.builder[i], -180, 180, 1, nil, "°"),
                way3 = self.tabs.defensive:slider("Way 3" .. self.states.builder[i], -180, 180, 1, nil, "°"),
                way4 = self.tabs.defensive:slider("Way 4" .. self.states.builder[i], -180, 180, 1, nil, "°"),
                way5 = self.tabs.defensive:slider("Way 5" .. self.states.builder[i], -180, 180, 1, nil, "°"),

                spin = self.tabs.defensive:checkbox("Spin" .. self.states.builder[i]),
                spinrange = self.tabs.defensive:slider("Spin range" .. self.states.builder[i], 0, 360, 1, nil, "°"),
                spinspeed = self.tabs.defensive:slider("Spin speed" .. self.states.builder[i], 0, 100, 1, nil, "t"),

                jitter = self.tabs.defensive:checkbox("Jitter" .. self.states.builder[i]),
                jittermode = self.tabs.defensive:combo("Jitter mode" .. self.states.builder[i],
                    { "Offset", "Center", "Skitter", "Random" }),
                jitterrange = self.tabs.defensive:slider("Jitter range" .. self.states.builder[i], -360, 360, 1, nil, "°"),

                desync = self.tabs.defensive:combo("Desync" .. self.states.builder[i], { "Static", "Jitter" }),
                desynctype = self.tabs.defensive:combo("Desync mode" .. self.states.builder[i], { "Static", "L/R" }),
                desync_static = self.tabs.defensive:slider("Desync range" .. self.states.builder[i], -60, 60, 1, nil, "°"),
                desync_left = self.tabs.defensive:slider("Desync left" .. self.states.builder[i], -60, 60, 1, nil, "°"),
                desync_right = self.tabs.defensive:slider("Desync right" .. self.states.builder[i], -60, 60, 1, nil, "°"),
                desync_onshot = self.tabs.defensive:combo("Desync on-shot" .. self.states.builder[i],
                    { "Off", "Opposite", "Same side", "Random" })
            }
        end
    end
end
menu:setup()
local x, y = render.get_screen_size().x / 2, render.get_screen_size().y / 2
local callback = {
    paint = {
        visibility = function()
            if not ui.is_open() then return end
            local tab = menu.global.navigation:get()
            menu.set_group_column("~ navigation", 1)
            menu.set_group_column("~ settings", 2)
            menu.set_group_column("~ builder", 3)
            menu.set_group_column("~ defensive", 4)
            menu.set_group_column("~ misc", 1)
            menu.global.breakers:visible(tab == 1)
            menu.global.breakstate:visible(tab == 1 and menu.global.breakers:get())
            menu.global.helpers:visible(tab == 1)
            menu.global.ground:visible(tab == 1 and menu.global.breakers:get() and
                menu.global.breakstate:get("On ground"))
            menu.global.air:visible(tab == 1 and menu.global.breakers:get() and menu.global.breakstate:get("In air"))
            menu.global.movelean:visible(tab == 1 and menu.global.breakers:get() and menu.global.breakstate:get("Other"))


            menu.tabs.builder:visible(tab == 2)
            menu.tabs.defensive:visible(tab == 2)

            menu.aa.states:visible(tab == 2)
            menu.aa.helpers:visible(tab == 2)
            local condition = menu.aa.states:get()
            for i = 1, #menu.states.builder do
                local ctx = menu.aa.builder
                local check = ctx[i].enable:get() and condition == i
                ctx[i].enable:visible(condition == i)
                ctx[i].pitch:visible(check)
                ctx[i].custom:visible(check and ctx[i].pitch:get() == 6)
                ctx[i].yawbase:visible(check)
                ctx[i].yawtype:visible(check and ctx[i].yawbase:get() ~= 1)
                ctx[i].static:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].yawtype:get() == 1)

                ctx[i].leftyaw:visible(check and ctx[i].yawbase:get() ~= 1 and
                    (ctx[i].yawtype:get() == 2 or ctx[i].yawtype:get() == 3))
                ctx[i].rightyaw:visible(check and ctx[i].yawbase:get() ~= 1 and
                    (ctx[i].yawtype:get() == 2 or ctx[i].yawtype:get() == 3))

                ctx[i].slowed:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].yawtype:get() == 3)

                ctx[i].xway:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].yawtype:get() == 4)
                ctx[i].way1:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].yawtype:get() == 4 and
                    ctx[i].xway:get() >= 2)
                ctx[i].way2:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].yawtype:get() == 4 and
                    ctx[i].xway:get() >= 2)
                ctx[i].way3:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].yawtype:get() == 4 and
                    ctx[i].xway:get() >= 3)
                ctx[i].way4:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].yawtype:get() == 4 and
                    ctx[i].xway:get() >= 4)
                ctx[i].way5:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].yawtype:get() == 4 and
                    ctx[i].xway:get() >= 5)
                ctx[i].spin:visible(check and ctx[i].yawbase:get() ~= 1)
                ctx[i].spinrange:visible(check and ctx[i].spin:get() and ctx[i].yawbase:get() ~= 1)
                ctx[i].spinspeed:visible(check and ctx[i].spin:get() and ctx[i].yawbase:get() ~= 1)

                ctx[i].jitter:visible(check and ctx[i].yawbase:get() ~= 1)
                ctx[i].jittermode:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].jitter:get())
                ctx[i].jitterrange:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].jitter:get())
                ctx[i].desync:visible(check)
                ctx[i].desynctype:visible(check)
                ctx[i].desync_static:visible(check and ctx[i].desynctype:get() == 1)
                ctx[i].desync_left:visible(check and ctx[i].desynctype:get() == 2)
                ctx[i].desync_right:visible(check and ctx[i].desynctype:get() == 2)
                ctx[i].desync_onshot:visible(check)

                ctx = menu.aa.builder.defensive
                check = ctx[i].enable:get() and condition == i
                ctx[i].enable:visible(condition == i)
                ctx[i].force:visible(condition == i)
                ctx[i].pitch:visible(check)
                ctx[i].custom:visible(check and ctx[i].pitch:get() == 6)
                ctx[i].yawbase:visible(check)
                ctx[i].yawtype:visible(check and ctx[i].yawbase:get() ~= 1)
                ctx[i].static:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].yawtype:get() == 1)

                ctx[i].leftyaw:visible(check and ctx[i].yawbase:get() ~= 1 and
                    (ctx[i].yawtype:get() == 2 or ctx[i].yawtype:get() == 3))
                ctx[i].rightyaw:visible(check and ctx[i].yawbase:get() ~= 1 and
                    (ctx[i].yawtype:get() == 2 or ctx[i].yawtype:get() == 3))

                ctx[i].slowed:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].yawtype:get() == 3)

                ctx[i].xway:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].yawtype:get() == 4)
                ctx[i].way1:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].yawtype:get() == 4 and
                    ctx[i].xway:get() >= 2)
                ctx[i].way2:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].yawtype:get() == 4 and
                    ctx[i].xway:get() >= 2)
                ctx[i].way3:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].yawtype:get() == 4 and
                    ctx[i].xway:get() >= 3)
                ctx[i].way4:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].yawtype:get() == 4 and
                    ctx[i].xway:get() >= 4)
                ctx[i].way5:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].yawtype:get() == 4 and
                    ctx[i].xway:get() >= 5)
                ctx[i].spin:visible(check and ctx[i].yawbase:get() ~= 1)
                ctx[i].spinrange:visible(check and ctx[i].spin:get() and ctx[i].yawbase:get() ~= 1)
                ctx[i].spinspeed:visible(check and ctx[i].spin:get() and ctx[i].yawbase:get() ~= 1)

                ctx[i].jitter:visible(check and ctx[i].yawbase:get() ~= 1)
                ctx[i].jittermode:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].jitter:get())
                ctx[i].jitterrange:visible(check and ctx[i].yawbase:get() ~= 1 and ctx[i].jitter:get())
                ctx[i].desync:visible(check)
                ctx[i].desynctype:visible(check)
                ctx[i].desync_static:visible(check and ctx[i].desynctype:get() == 1)
                ctx[i].desync_left:visible(check and ctx[i].desynctype:get() == 2)
                ctx[i].desync_right:visible(check and ctx[i].desynctype:get() == 2)
                ctx[i].desync_onshot:visible(check)
            end
            menu.visual.indicators:visible(tab == 3)
            menu.visual.indicators_color:visible(menu.visual.indicators:get())
            menu.visual.hitlogs:visible(tab == 3)
        end,
        indicators = function()
            local r, g, b, a = menu.visual.indicators_color:get().r, menu.visual.indicators_color:get().g,
                menu.visual.indicators_color:get().b, menu.visual.indicators_color:get().a
            render.gradient_text(global.visual.verdanab, "i m p u l s e", vector(x, render.get_screen_size().y - 15),
                color(r, g, b),
                color(55, 55, 55), nil, false, 20)
            if not menu.visual.indicators:get() then return end
            if not entity.local_player().alive then return end
            local scoped = entity.local_player().prop("m_bIsScoped")
            local anim = animation:process("Indicators scoped", scoped == 1, 10)
            local add = 24 * anim
            local is_charged = exploits.get_charge() == exploits.get_max_charge() and menu.refs.doubletap:get()
            local dt_anim = animation:process("Doubletap charged", is_charged, 10)
            local dt_color_r, dt_color_g, dt_color_b, dt_color_a = animation.lerp({ 255, 255, 255, 55 }, { r, g, b, 255 },
                dt_anim)
            local keybinds = {
                {
                    name = "doubletap",
                    path = menu.refs.doubletap,
                    color = color(math.round(dt_color_r), math.round(dt_color_g), math.round(dt_color_b),
                        math.round(dt_color_a)),
                    anim = 0,
                    scope = 0,
                },
                {
                    name = "hideshots",
                    path = menu.refs.hideshots,
                    color = color(r, g, b, 255),
                    anim = 0,
                    scope = 0,
                },
                {
                    name = "damage",
                    path = menu.find("aimbot", string.format("%s", global.helpers.get_weapon_group()), "target overrides",
                        "min. damage")[2],
                    color = color(r, g, b, 255),
                    anim = 0,
                    scope = 0,
                },
                {
                    name = "hitchance",
                    path = menu.find("aimbot", string.format("%s", global.helpers.get_weapon_group()), "target overrides",
                        "hitchance")[2],
                    color = color(r, g, b, 100),
                    anim = 0,
                    scope = 0,
                },
                {
                    name = "hitbox",
                    path = menu.find("aimbot", string.format("%s", global.helpers.get_weapon_group()), "target overrides",
                        "hitbox")[2],
                    color = color(r, g, b, 100),
                    anim = 0,
                    scope = 0,
                },
            }
            render.gradient_text(global.visual.pixel, ("impulse"):upper(),
                vector(x + add - render.surface_get_text_size(global.visual.pixel, "DEV").x / 2, y + 25), color(r, g, b),
                color(55, 55, 55), nil, false, 20)

            render.surface_text(global.visual.pixel, ("dev"):upper(),
                vector(x + add + render.surface_get_text_size(global.visual.pixel, ("impulse"):upper()).x / 2, y + 25),
                color(r, g, b), { true })
            --render.window(vector(x, y), vector(75, 25), 1, color(255,255,255,255), color(0,0,0,55))
            local add = 0
            for k, v in pairs(keybinds) do
                v.anim = animation:process(k .. " animation", v.path:get(), 10)
                v.lenght = #v.name
                v.index = v.lenght * v.anim
                v.sub = string.sub(v.name, 1, v.index)
                v.scope = (render.surface_get_text_size(global.visual.pixel, ("impulse"):upper()).x / 2 + render.surface_get_text_size(global.visual.pixel, v.sub:upper()).x / 2 - 13) *
                    anim
                if v.anim > 0.02 then
                    render.surface_text(global.visual.pixel, tostring(v.sub):upper(), vector(x + v.scope, y + 35 + add),
                        color_t(math.round(v.color.r), math.round(v.color.g), math.round(v.color.b),
                            math.round(v.color.a)), { true })
                    add = add + 10 * v.anim
                end
            end
        end,
        log = function()
            local lp = entity.local_player()
            if not entity.local_player().alive then
                log.logs = {}
                return
            end
            local offset = 0

            for i, v in pairs(log.logs) do
                if v.time > globals.cur_time() and i <= 6 then
                    v.alpha = animation.lerp(v.alpha, 255, 0.2)
                else
                    v.alpha = animation.lerp(v.alpha, 0, 0.2)
                    if v.alpha < 1 then
                        table.remove(log.logs, i)
                    end
                end
                local w, h = render.surface_get_text_size(global.visual.verdana, v.text)
                if v.alpha > 1 then
                    render.surface_text(global.visual.pixel, v.text:upper(), vector(x, y + 75 + offset),
                        color(v.color.r, v.color.g, v.color.b, math.round(v.alpha)), { true })
                end
                offset = offset + (15 * (v.alpha / 255))
            end
        end
    },
    antiaim = {
        get_state = function()
            local lp = entity.local_player()
            if not entity.local_player().alive then return end
            local vel = vec3_t(entity.local_player().prop('m_vecVelocity[0]'),
                entity.local_player().prop('m_vecVelocity[1]'), entity.local_player().prop('m_vecVelocity[2]'))
            local flags = entity.local_player().prop("m_fFlags")
            local info = {
                slow_walk = menu.find('misc', 'main', 'movement', 'slow walk')[2]:get(),
                ducked    = entity.local_player().prop('m_bDucked') == 1,
                speed     = vel:length2d(),
            };

            if flags == 256 or flags == 262 then
                global.antiaim.in_air = true
                global.antiaim.air_tick = globals.tick_count() + 3
            else
                global.antiaim.in_air = (global.antiaim.air_tick > globals.tick_count()) and true or false
            end
            for i = 1, #menu.states.builder do
                if not menu.aa.builder[i].enable:get() then
                    global.antiaim.state = 1
                end
            end
            if global.antiaim.in_air and info.ducked then
                if menu.aa.builder[5].enable:get() then
                    global.antiaim.state = 5
                end
            else
                if global.antiaim.in_air then
                    if menu.aa.builder[4].enable:get() then
                        global.antiaim.state = 4
                    end
                else
                    if info.ducked then
                        if menu.aa.builder[7].enable:get() then
                            global.antiaim.state = 7
                            if info.speed > 15 then
                                if menu.aa.builder[8].enable:get() then
                                    global.antiaim.state = 8
                                end
                            end
                        end
                    else
                        if info.slow_walk then
                            if menu.aa.builder[6].enable:get() then
                                global.antiaim.state = 6
                            end
                        else
                            if info.speed < 5 then
                                if menu.aa.builder[2].enable:get() then
                                    global.antiaim.state = 2
                                end
                            else
                                if menu.aa.builder[3].enable:get() then
                                    global.antiaim.state = 3
                                end
                            end
                        end
                    end
                end
            end
        end,
        builder = function(fx)
            local wep = entity.local_player().prop("m_hActiveWeapon")
            local wep2 = entity_list.get_entity(wep)
            if not wep2 then return end
            local shold_safe_head = false
            local weapon = wep2:get_weapon_data().console_name
            if string.find(weapon, "weapon_knife_") or string.find(weapon, "bayonet") then
                shold_safe_head = true
            end
            if string.find(weapon, "weapon_taser") then
                shold_safe_head = true
            end
            local ctx = menu.aa.builder

            local dsy_add = 1.66666666667
            if engine.get_choked_commands() == 0 then
                global.antiaim.tick_switch = global.antiaim.tick_switch + 1
                global.antiaim.skitter = global.antiaim.skitter + 1
                global.antiaim.way = global.antiaim.way + 1
                if global.antiaim.skitter > 3 then
                    global.antiaim.skitter = 1
                end
                if global.antiaim.way > ctx[global.antiaim.state].xway:get() then
                    global.antiaim.way = 1
                end
            end
            if ctx[global.antiaim.state].yawtype:get() == 3 then
                local speed_tick = ctx[global.antiaim.state].slowed:get()
                if global.antiaim.tick_switch == speed_tick then
                    global.antiaim.inverted = false
                end
                if global.antiaim.tick_switch >= speed_tick * 2 then
                    global.antiaim.inverted = true
                    global.antiaim.tick_switch = 0
                end
            else
                global.antiaim.inverted = global.info.choking and true or false
                if global.info.choking then
                    global.antiaim.side = global.antiaim.side * -1
                end
            end
            local yaw = 0; do
                if ctx[global.antiaim.state].yawtype:get() == 1 then
                    yaw = ctx[global.antiaim.state].static:get()
                end
                if ctx[global.antiaim.state].yawtype:get() == 2 or ctx[global.antiaim.state].yawtype:get() == 3 then
                    yaw = global.antiaim.inverted and ctx[global.antiaim.state].rightyaw:get() or
                        ctx[global.antiaim.state].leftyaw:get()
                end
                if ctx[global.antiaim.state].yawtype:get() == 4 then
                    if global.antiaim.way == 1 then
                        yaw = ctx[global.antiaim.state].way1:get()
                    end
                    if global.antiaim.way == 2 then
                        yaw = ctx[global.antiaim.state].way2:get()
                    end
                    if global.antiaim.way == 3 then
                        yaw = ctx[global.antiaim.state].way3:get()
                    end
                    if global.antiaim.way == 4 then
                        yaw = ctx[global.antiaim.state].way4:get()
                    end
                    if global.antiaim.way == 5 then
                        yaw = ctx[global.antiaim.state].way5:get()
                    end
                end
            end


            local dsy_r = 0; local dsy_l = 0; local dsy = 0; do
                dsy = math.abs(ctx[global.antiaim.state].desync_static:get()) * dsy_add
                dsy_r = math.abs(ctx[global.antiaim.state].desync_right:get()) * dsy_add
                dsy_l = math.abs(ctx[global.antiaim.state].desync_left:get()) * dsy_add
            end
            local dsy_side = 0; do
                if ctx[global.antiaim.state].desync:get() ~= 2 then
                    dsy_side = ctx[global.antiaim.state].desync_static:get() < 0 and 3 or 2
                else
                    dsy_side = global.antiaim.inverted and 3 or 2
                end
            end
            local jitter = 0; do
                if ctx[global.antiaim.state].jitter:get() then
                    if ctx[global.antiaim.state].jittermode:get() == 1 then
                        jitter = global.info.choking and ctx[global.antiaim.state].jitterrange:get() / 2 or 0
                    end
                    if ctx[global.antiaim.state].jittermode:get() == 2 then
                        jitter = global.info.choking and ctx[global.antiaim.state].jitterrange:get() / 2 or
                            -ctx[global.antiaim.state].jitterrange:get() / 2
                    end
                    if ctx[global.antiaim.state].jittermode:get() == 3 then
                        if global.antiaim.skitter == 1 then
                            jitter = -ctx[global.antiaim.state].jitterrange:get() / 2
                            dsy_side = 2
                        end
                        if global.antiaim.skitter == 2 then
                            jitter = 0
                            dsy_side = 1
                        end
                        if global.antiaim.skitter == 3 then
                            jitter = ctx[global.antiaim.state].jitterrange:get() / 2
                            dsy_side = 3
                        end
                    end
                    if ctx[global.antiaim.state].jittermode:get() == 4 then
                        jitter = math.random(-ctx[global.antiaim.state].jitterrange:get() / 2,
                            ctx[global.antiaim.state].jitterrange:get() / 2)
                    end
                end
            end
            local add = yaw + jitter


            if ctx[global.antiaim.state].pitch:get() == 6 then
                fx:set_pitch(ctx[global.antiaim.state].custom:get())
            else
                menu.refs.pitch:set(ctx[global.antiaim.state].pitch:get())
            end


            menu.refs.yaw_base:set(ctx[global.antiaim.state].yawbase:get())
            menu.refs.jitter_mode:set(1)
            menu.refs.jitter_type:set(1)
            menu.refs.yaw_add:set(add)
            menu.refs.desync_override_move:set(false)
            menu.refs.desync_override_slowwalk:set(false)
            menu.refs.desync_side:set(dsy_side)
            menu.refs.desync_left:set(ctx[global.antiaim.state].desynctype:get() == 1 and dsy or dsy_l)
            menu.refs.desync_right:set(ctx[global.antiaim.state].desynctype:get() == 1 and dsy or dsy_r)
            menu.refs.rotate:set(ctx[global.antiaim.state].spin:get())
            menu.refs.rotate_speed:set(ctx[global.antiaim.state].spinspeed:get())
            menu.refs.rotate_range:set(ctx[global.antiaim.state].spinrange:get())
            ctx = menu.aa.builder.defensive
            if my.exploit.defensive and ctx[global.antiaim.state].enable:get() then
                local dsy_add = 1.66666666667
                if engine.get_choked_commands() == 0 then
                    global.antiaim.tick_switch_def = global.antiaim.tick_switch_def + 1
                    global.antiaim.skitter = global.antiaim.skitter + 1
                    global.antiaim.way_def = global.antiaim.way_def + 1
                    if global.antiaim.skitter > 3 then
                        global.antiaim.skitter = 1
                    end
                    if global.antiaim.way_def > ctx[global.antiaim.state].xway:get() then
                        global.antiaim.way_def = 1
                    end
                end
                if ctx[global.antiaim.state].yawtype:get() == 3 then
                    local speed_tick2 = ctx[global.antiaim.state].slowed:get()
                    if global.antiaim.tick_switch_def == speed_tick2 then
                        global.antiaim.inverted_def = false
                    end
                    if global.antiaim.tick_switch_def >= speed_tick2 * 2 then
                        global.antiaim.inverted_def = true
                        global.antiaim.tick_switch_def = 0
                    end
                else
                    global.antiaim.inverted_def = global.info.choking and true or false
                    if global.info.choking then
                        global.antiaim.side_def = global.antiaim.side_def * -1
                    end
                end
                local yaw_def = 0
                if ctx[global.antiaim.state].yawtype:get() == 1 then
                    yaw_def = ctx[global.antiaim.state].static:get()
                end
                if ctx[global.antiaim.state].yawtype:get() == 2 or ctx[global.antiaim.state].yawtype:get() == 3 then
                    yaw_def = global.antiaim.inverted_def and ctx[global.antiaim.state].rightyaw:get() or
                        ctx[global.antiaim.state].leftyaw:get()
                end
                if ctx[global.antiaim.state].yawtype:get() == 4 then
                    if global.antiaim.way_def == 1 then
                        yaw_def = ctx[global.antiaim.state].way1:get()
                    end
                    if global.antiaim.way_def == 2 then
                        yaw_def = ctx[global.antiaim.state].way2:get()
                    end
                    if global.antiaim.way_def == 3 then
                        yaw_def = ctx[global.antiaim.state].way3:get()
                    end
                    if global.antiaim.way_def == 4 then
                        yaw_def = ctx[global.antiaim.state].way4:get()
                    end
                    if global.antiaim.way_def == 5 then
                        yaw_def = ctx[global.antiaim.state].way5:get()
                    end
                end




                dsy = math.abs(ctx[global.antiaim.state].desync_static:get()) * dsy_add
                dsy_r = math.abs(ctx[global.antiaim.state].desync_right:get()) * dsy_add
                dsy_l = math.abs(ctx[global.antiaim.state].desync_left:get()) * dsy_add

                local dsy_side_def = 1
                if ctx[global.antiaim.state].desync:get() ~= 2 then
                    dsy_side_def = ctx[global.antiaim.state].desync_static:get() < 0 and 3 or 2
                else
                    dsy_side_def = global.antiaim.inverted_def and 3 or 2
                end
                local jitter_def = 0
                if ctx[global.antiaim.state].jitter:get() then
                    if ctx[global.antiaim.state].jittermode:get() == 1 then
                        jitter_def = global.info.choking and ctx[global.antiaim.state].jitterrange:get() / 2 or 0
                    end
                    if ctx[global.antiaim.state].jittermode:get() == 2 then
                        jitter_def = global.info.choking and ctx[global.antiaim.state].jitterrange:get() / 2 or
                            -ctx[global.antiaim.state].jitterrange:get() / 2
                    end
                    if ctx[global.antiaim.state].jittermode:get() == 3 then
                        if global.antiaim.skitter == 1 then
                            jitter_def = -ctx[global.antiaim.state].jitterrange:get() / 2
                            dsy_side_def = 2
                        end
                        if global.antiaim.skitter == 2 then
                            jitter_def = 0
                            dsy_side_def = 1
                        end
                        if global.antiaim.skitter == 3 then
                            jitter_def = ctx[global.antiaim.state].jitterrange:get() / 2
                            dsy_side_def = 3
                        end
                    end
                    if ctx[global.antiaim.state].jittermode:get() == 4 then
                        jitter_def = math.random(-ctx[global.antiaim.state].jitterrange:get() / 2,
                            ctx[global.antiaim.state].jitterrange:get() / 2)
                    end
                end

                local add_def = yaw_def + jitter_def

                if ctx[global.antiaim.state].pitch:get() == 6 then

                end

                if ctx[global.antiaim.state].yawtype:get() == 5 then
                    add_def = math.random(-180, 180)
                end

                if ctx[global.antiaim.state].pitch:get() == 7 then
                    fx:set_pitch(math.random(-89, 89))
                else
                    if ctx[global.antiaim.state].pitch:get() == 6 then
                        fx:set_pitch(ctx[global.antiaim.state].custom:get())
                    else
                        menu.refs.pitch:set(ctx[global.antiaim.state].pitch:get())
                    end
                end



                menu.refs.yaw_base:set(ctx[global.antiaim.state].yawbase:get())
                menu.refs.jitter_mode:set(1)
                menu.refs.jitter_type:set(1)
                menu.refs.yaw_add:set(add_def)
                menu.refs.desync_override_move:set(false)
                menu.refs.desync_override_slowwalk:set(false)
                menu.refs.desync_side:set(dsy_side_def)
                menu.refs.desync_left:set(ctx[global.antiaim.state].desynctype:get() == 1 and dsy or dsy_l)
                menu.refs.desync_right:set(ctx[global.antiaim.state].desynctype:get() == 1 and dsy or dsy_r)
                menu.refs.rotate:set(ctx[global.antiaim.state].spin:get())
                menu.refs.rotate_speed:set(ctx[global.antiaim.state].spinspeed:get())
                menu.refs.rotate_range:set(ctx[global.antiaim.state].spinrange:get())
            end
            if menu.aa.helpers:get("Static manuals") then
                if antiaim.get_manual_override() > 0 or menu.refs.fs:get() then
                    fx:set_pitch(89)
                    menu.refs.jitter_mode:set(1)
                    menu.refs.jitter_type:set(1)
                    menu.refs.yaw_add:set(0)
                    menu.refs.desync_override_move:set(false)
                    menu.refs.desync_override_slowwalk:set(false)
                    menu.refs.desync_side:set(5)
                    menu.refs.desync_left:set(100)
                    menu.refs.desync_right:set(100)
                    menu.refs.default_side:set(1)
                    menu.refs.rotate:set(false)
                end
            end
            if menu.aa.helpers:get("Safe head") then
                if shold_safe_head then
                    fx:set_pitch(89)
                    menu.refs.jitter_mode:set(1)
                    menu.refs.jitter_type:set(1)
                    menu.refs.yaw_add:set(0)
                    menu.refs.desync_override_move:set(false)
                    menu.refs.desync_override_slowwalk:set(false)
                    menu.refs.desync_side:set(2)
                    menu.refs.desync_left:set(0)
                    menu.refs.desync_right:set(0)
                    menu.refs.rotate:set(false)
                end
            end
            if ctx[global.antiaim.state].force:get() then
                exploits.force_anti_exploit_shift()
            end
            if menu.global.helpers:get("Force defensive on enemy visible") then
                if global.helpers.player_will_peek() then
                    exploits.force_anti_exploit_shift()
                end
            end
        end,
        breakers = function(fx, cmd)
            if not menu.global.breakers:get() then return end
            if not entity.local_player().alive then return end

            if menu.global.breakstate:get("On ground") then
                if menu.global.ground:get() == 1 then
                    fx:set_render_pose(e_poses.RUN, 0)
                    menu.refs.leg_slide:set(3)
                end
                if menu.global.ground:get() == 2 then
                    if global.info.choking then
                        fx:set_render_pose(e_poses.RUN, 0)
                    end
                    menu.refs.leg_slide:set(3)
                end
                if menu.global.ground:get() == 3 then
                    fx:set_render_pose(e_poses.MOVE_YAW, 0)
                    menu.refs.leg_slide:set(2)
                end
            end
            if menu.global.breakstate:get("In air") then
                if global.antiaim.in_air then
                    if menu.global.air:get() == 1 then
                        fx:set_render_pose(e_poses.JUMP_FALL, 1)
                    end
                    if menu.global.air:get() == 2 then
                        if global.info.choking then
                            fx:set_render_pose(e_poses.JUMP_FALL, 1)
                        end
                    end
                    if menu.global.air:get() == 3 then
                        if global.antiaim.in_air then
                            fx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 6.0)
                        end
                    end
                end
            end
            if menu.global.breakstate:get("Other") then
                local x_velocity = entity.local_player().prop("m_vecVelocity[0]")
                if math.abs(x_velocity) >= 3 then
                    fx:set_render_animlayer(e_animlayers.LEAN, menu.global.movelean:get() / 100)
                end
            end
        end
    },
    createmove = {
        update = function(cmd)
            if engine.get_choked_commands() == 0 then
                global.info.choke = global.info.choke * -1
                global.info.choking = not global.info.choking
            end
            --global.antiaim.defensive = rage:is_defenisve()
        end,
        fast_ladder = function(cmd)
            -- client.log_screen(entity.local_player().prop("m_MoveType") == 9)
            if not menu.global.helpers:get("Fast ladder") then return end
            if not entity.local_player().player then return end
            if not entity.local_player().prop("m_MoveType") == 9 then return end
            local view = engine.get_view_angles()
            local niggaslifer_value = 0
            local abs_value = math.abs(niggaslifer_value)
            if entity.local_player().prop("m_MoveType") == 9 then
                if cmd.move.x == 0 then
                    cmd.viewangles.x = 89
                    cmd.viewangles.y = cmd.viewangles.y + niggaslifer_value

                    if abs_value > 0 and abs_value < 180 and cmd.move.y ~= 0 then
                        cmd.viewangles.y = cmd.viewangles.y - niggaslifer_value
                    end
                    if abs_value == 180 then
                        if cmd.move.y < 0 then
                            cmd:remove_button(e_cmd_buttons.MOVELEFT)
                            cmd:add_button(e_cmd_buttons.MOVERIGHT)
                        elseif cmd.move.y > 0 then
                            cmd:add_button(e_cmd_buttons.MOVELEFT)
                            cmd:remove_button(e_cmd_buttons.MOVERIGHT)
                        end
                    end
                end
                if cmd.move.x > 0 then
                    if view.x < 0 then
                        cmd.viewangles.x = 89
                        cmd:remove_button(e_cmd_buttons.MOVELEFT)
                        cmd:add_button(e_cmd_buttons.MOVERIGHT)
                        cmd:remove_button(e_cmd_buttons.FORWARD)
                        cmd:add_button(e_cmd_buttons.BACK)

                        if cmd.move.y == 0 then
                            cmd.viewangles.y = cmd.viewangles.y + 90
                        elseif cmd.move.y < 0 then
                            cmd.viewangles.y = cmd.viewangles.y + 150
                        elseif cmd.move.y > 0 then
                            cmd.viewangles.y = cmd.viewangles.y + 30
                        end
                    end
                end
                if cmd.move.x < 0 then
                    cmd.viewangles.x = 89
                    cmd:add_button(e_cmd_buttons.MOVELEFT)
                    cmd:remove_button(e_cmd_buttons.MOVERIGHT)
                    cmd:add_button(e_cmd_buttons.FORWARD)
                    cmd:remove_button(e_cmd_buttons.BACK)

                    if cmd.move.y == 0 then
                        cmd.viewangles.y = cmd.viewangles.y + 90
                    elseif cmd.move.y > 0 then
                        cmd.viewangles.y = cmd.viewangles.y + 150
                    elseif cmd.move.y < 0 then
                        cmd.viewangles.y = cmd.viewangles.y + 30
                    end
                end
            end
        end,
        nofall = function(cmd)
            if not menu.global.helpers:get("No fall damage") then return end

            local lplr = entity_list.get_local_player()
            local no_fall_damage = nil

            if lplr == nil then return end

            if lplr:get_prop("m_vecVelocity").z >= -500 then
                no_fall_damage = false
            else
                if rage.calculatefall(15) then
                    no_fall_damage = false
                elseif rage.calculatefall(75) then
                    no_fall_damage = true
                end
            end

            if lplr:get_prop("m_vecVelocity").z < -500 then
                if no_fall_damage then
                    cmd:add_button(e_cmd_buttons.DUCK)
                else
                    cmd:remove_button(e_cmd_buttons.DUCK)
                end
            end
        end,
        super_toss = function(cmd)
            if not menu.global.helpers:get("Super toss") then return end
            if menu.refs.helpers:get() then return end
            local lplr = entity_list.get_local_player()
            if not lplr or not lplr:is_player() or not lplr:is_alive() then return end
            if (lplr:get_prop("m_MoveType") == 9) then return end
            local weapon = lplr:get_active_weapon()
            if not weapon then return end

            local data = weapon:get_weapon_data()
            if not data then return end
            local lastangles = engine.get_view_angles()

            if not weapon:get_prop("m_flThrowStrength") then return end

            local ang_throw = vec3_t(cmd.viewangles.x, cmd.viewangles.y, 0)
            ang_throw.x = ang_throw.x - (90 - math.abs(ang_throw.x)) * 10 / 90
            ang_throw = global.helpers.ang_vec(ang_throw)

            local throw_strength = math.clamp(weapon:get_prop("m_flThrowStrength"), 0, 1)
            local fl_velocity = math.clamp(data.throw_velocity * 0.9, 15, 750)
            fl_velocity = fl_velocity * (throw_strength * 0.7 + 0.3)
            fl_velocity = vec3_t(fl_velocity, fl_velocity, fl_velocity)

            local localplayer_velocity = lplr:get_prop('m_vecVelocity')
            local vec_throw = (ang_throw * fl_velocity + localplayer_velocity * vec3_t(1.45, 1.45, 1.45))
            vec_throw = vec_throw:to_angle()
            local yaw_difference = lastangles.y - vec_throw.y
            while yaw_difference > 180 do
                yaw_difference = yaw_difference - 360
            end
            while yaw_difference < -180 do
                yaw_difference = yaw_difference + 360
            end
            local pitch_difference = lastangles.x - vec_throw.x - 10
            while pitch_difference > 90 do
                pitch_difference = pitch_difference - 45
            end
            while pitch_difference < -90 do
                pitch_difference = pitch_difference + 45
            end

            global.helpers.target_angles.y = lastangles.y + yaw_difference
            global.helpers.target_angles.x = math.clamp(lastangles.x + pitch_difference, -89, 89)
            cmd.viewangles.y = global.helpers.target_angles.y
            cmd.viewangles.x = global.helpers.target_angles.x
        end,
    },
    on_shot = {
        hit = {
            f = function(e)
                log.add(
                "hit " ..
                e.player:get_name() ..
                "'s " .. e.hitgroup .. " for " .. e.damage .. " damage (hitchance: " .. e.aim_hitchance .. ")",
                    color_t(200, 200, 200))
            end
        },
        miss = {
            f = function(e)
                log.add(
                "missed " ..
                e.player:get_name() ..
                "'s " .. e.aim_hitbox .. " due to " .. e.reason_string .. " (hitchance: " .. e.aim_hitchance .. ")",
                    color_t(200, 200, 200))
            end
        }
    }
}
local steam_http_raw = ffi.cast("uint32_t**",
        ffi.cast("char**",
            ffi.cast("char*", memory.find_pattern("client.dll", "B9 ? ? ? ? E8 ? ? ? ? 83 3D ? ? ? ? ? 0F 84")) + 1)[0] +
        48)
    [0] or error("steam_http error")
local steam_http_ptr = ffi.cast("void***", steam_http_raw) or error("steam_http_ptr error")
local steam_http = steam_http_ptr[0] or error("steam_http_ptr was null")
-- #endregion

--#region helper functions
local function __thiscall(func, this) -- bind wrapper for __thiscall functions
    return function(...)
        return func(this, ...)
    end
end
--#endregion

-- #region native casts
local createHTTPRequest_native = __thiscall(
    ffi.cast(ffi.typeof("uint32_t(__thiscall*)(void*, uint32_t, const char*)"), steam_http[0]), steam_http_raw)
local sendHTTPRequest_native = __thiscall(
    ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, uint64_t)"), steam_http[5]), steam_http_raw)
local getHTTPResponseHeaderSize_native = __thiscall(
    ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, uint32_t*)"), steam_http[9]), steam_http_raw)
local getHTTPResponseHeaderValue_native = __thiscall(
    ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, char*, uint32_t)"), steam_http[10]),
    steam_http_raw)
local getHTTPResponseBodySize_native = __thiscall(
    ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, uint32_t*)"), steam_http[11]), steam_http_raw)
local getHTTPBodyData_native = __thiscall(
    ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, char*, uint32_t)"), steam_http[12]), steam_http_raw)
local setHTTPHeaderValue_native = __thiscall(
    ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, const char*)"), steam_http[3]), steam_http_raw)
local setHTTPRequestParam_native = __thiscall(
    ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, const char*)"), steam_http[4]), steam_http_raw)
local setHTTPUserAgent_native = __thiscall(
    ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*)"), steam_http[21]), steam_http_raw)
local setHTTPRequestRaw_native = __thiscall(
    ffi.cast("bool(__thiscall*)(void*, uint32_t, const char*, const char*, uint32_t)", steam_http[16]), steam_http_raw)
local releaseHTTPRequest_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t)"), steam_http[14]),
    steam_http_raw)
-- #endregion

local requests = {}
callbacks.add(e_callbacks.PAINT, function()
    for _, instance in ipairs(requests) do
        if global_vars.cur_time() - instance.ls > instance.task_interval then
            instance:_process_tasks()
            instance.ls = global_vars.cur_time()
        end
    end
end)

-- #region Models
local request = {}
local request_mt = { __index = request }
function request.new(requestHandle, requestAddress, callbackFunction)
    return setmetatable({ handle = requestHandle, url = requestAddress, callback = callbackFunction, ticks = 0 },
        request_mt)
end

local data = {}
local data_mt = { __index = data }
function data.new(state, body, headers)
    return setmetatable({ status = state, body = body, headers = headers }, data_mt)
end

function data:success()
    return self.status == 200
end

-- #endregion

-- #region Main
local http = { state = { ok = 200, no_response = 204, timed_out = 408, unknown = 0 } }
local http_mt = { __index = http }
function http.new(task)
    task = task or {}
    local instance = setmetatable(
        {
            requests = {},
            task_interval = task.task_interval or 0.3,
            enable_debug = task.debug or false,
            timeout = task
                .timeout or 10,
            ls = global_vars.cur_time()
        }, http_mt)
    table.insert(requests, instance)
    return instance
end

local method_t = { ['get'] = 1, ['head'] = 2, ['post'] = 3, ['put'] = 4, ['delete'] = 5, ['options'] = 6, ['patch'] = 7 }
function http:request(method, url, options, callback)
    -- prepare
    if type(options) == "function" and callback == nil then
        callback = options
        options = {}
    end
    options = options or {}
    local method_num = method_t[tostring(method):lower()]
    local reqHandle = createHTTPRequest_native(method_num, url)
    -- header
    local content_type = "application/text"
    if type(options.headers) == "table" then
        for name, value in pairs(options.headers) do
            name = tostring(name)
            value = tostring(value)
            if name:lower() == "content-type" then
                content_type = value
            end
            setHTTPHeaderValue_native(reqHandle, name, value)
        end
    end
    -- raw
    if type(options.body) == "string" then
        local len = options.body:len()
        setHTTPRequestRaw_native(reqHandle, content_type, ffi.cast("unsigned char*", options.body), len)
    end
    -- params
    if type(options.params) == "table" then
        for k, v in pairs(options.params) do
            setHTTPRequestParam_native(reqHandle, k, v)
        end
    end
    -- useragent
    if type(options.user_agent_info) == "string" then
        setHTTPUserAgent_native(reqHandle, options.user_agent_info)
    end
    -- send
    if not sendHTTPRequest_native(reqHandle, 0) then
        return
    end
    local reqInstance = request.new(reqHandle, url, callback)
    self:_debug("[HTTP] New %s request to: %s", method:upper(), url)
    table.insert(self.requests, reqInstance)
end

function http:parse(url, callback)
    local reqHandle = createHTTPRequest_native(1, url)
    if not sendHTTPRequest_native(reqHandle, 0) then
        return
    end
    local reqInstance = request.new(reqHandle, url, callback)
    self:_debug("[HTTP] New GET request to: %s", url)
    table.insert(self.requests, reqInstance)
end

function http:post(url, params, callback)
    local reqHandle = createHTTPRequest_native(3, url)
    for k, v in pairs(params) do
        setHTTPRequestParam_native(reqHandle, k, v)
    end
    if not sendHTTPRequest_native(reqHandle, 0) then
        return
    end
    local reqInstance = request.new(reqHandle, url, callback)
    self:_debug("[HTTP] New POST request to: %s", url)
    table.insert(self.requests, reqInstance)
end

function http:_process_tasks()
    for k, v in ipairs(self.requests) do
        local data_ptr = ffi.new("uint32_t[1]")
        self:_debug("[HTTP] Processing request #%s", k)
        if getHTTPResponseBodySize_native(v.handle, data_ptr) then
            local reqData = data_ptr[0]
            if reqData > 0 then
                local strBuffer = ffi.new("char[?]", reqData)
                if getHTTPBodyData_native(v.handle, strBuffer, reqData) then
                    self:_debug("[HTTP] Request #%s finished. Invoking callback.", k)
                    v.callback(data.new(http.state.ok, ffi.string(strBuffer, reqData),
                        setmetatable({}, { __index = function(tbl, val) return http._get_header(v, val) end })))
                    table.remove(self.requests, k)
                    releaseHTTPRequest_native(v.handle)
                end
            else
                v.callback(data.new(http.state.no_response, nil, {}))
                table.remove(self.requests, k)
                releaseHTTPRequest_native(v.handle)
            end
        end
        local timeoutCheck = v.ticks + 1;
        if timeoutCheck >= self.timeout then
            v.callback(data.new(http.state.timed_out, nil, {}))
            table.remove(self.requests, k)
            releaseHTTPRequest_native(v.handle)
        else
            v.ticks = timeoutCheck
        end
    end
end

function http:_debug(...)
    if self.enable_debug then
        client.log(string.format(...))
    end
end

function http._get_header(reqInstance, query)
    local data_ptr = ffi.new("uint32_t[1]")
    if getHTTPResponseHeaderSize_native(reqInstance.handle, query, data_ptr) then
        local reqData = data_ptr[0]
        local strBuffer = ffi.new("char[?]", reqData)
        if getHTTPResponseHeaderValue_native(reqInstance.handle, query, strBuffer, reqData) then
            return ffi.string(strBuffer, reqData)
        end
    end
    return nil
end

function http._bind(class, funcName)
    return function(...)
        return class[funcName](class, ...)
    end
end


local patterns = {}; do
    patterns.firstsignature = memory.find_pattern("engine.dll", " FF 15 ? ? ? ? 85 C0 74 0B") or
        error("Couldn't find signature #1")
    patterns.secondsignature = memory.find_pattern("engine.dll", " FF 15 ? ? ? ? A3 ? ? ? ? EB 05") or
        error("Couldn't find signature #2")
    patterns.getaddress = ffi.cast("uint32_t**", ffi.cast("uint32_t", patterns.secondsignature) + 2)[0][0]
    patterns.getprocaddress = ffi.cast("uint32_t(__stdcall*)(uint32_t, const char*)", patterns.getaddress)
    patterns.getmodule = ffi.cast("uint32_t**", ffi.cast("uint32_t", patterns.firstsignature) + 2)[0][0]
    patterns.getprocmodule = ffi.cast("uint32_t(__stdcall*)(const char*)", patterns.getmodule)

    function patterns.process(module_name, function_name, typedef)
        local ctype = ffi.typeof(typedef)
        local module_handle = patterns.getprocmodule(module_name)
        local proc_address = patterns.getprocaddress(module_handle, function_name)
        local call_fn = ffi.cast(ctype, proc_address)
        return call_fn
    end
end
local bit32     = {
    GlobalMemoryStatusEx = patterns.process("Kernel32.dll", "GlobalMemoryStatusEx",
        "BOOL(__stdcall*)(LPMEMORYSTATUSEX  lpBuffer)"),
    GetSystemInfo = patterns.process("Kernel32.dll", "GetSystemInfo", "void(__stdcall*)(LPSYSTEM_INFO lpSystemInf)"),
    bxor = function(a, b)
        local result = 0
        local bitval = 1
        while a > 0 or b > 0 do
            local bit_a, bit_b = a % 2, b % 2
            if bit_a ~= bit_b then
                result = result + bitval
            end
            a = math.floor(a / 2)
            b = math.floor(b / 2)
            bitval = bitval * 2
        end
        return result
    end
}
colorprint = function(text, color)
    console_color = ffi.new("struct c_color")
    engine_cvar = ffi.cast("void***", memory.create_interface("vstdlib.dll", "VEngineCvar007"))
    console_print = ffi.cast("void(__cdecl*)(void*, const struct c_color&, const char*, ...)", engine_cvar[0][25])

    console_color.clr[0] = color.r
    console_color.clr[1] = color.g
    console_color.clr[2] = color.b
    console_color.clr[3] = color.a or 255
    console_print(engine_cvar, console_color, text)
end

local _BLD = "dev"
client.delay_call(function()
    for k, v in pairs(callback.paint) do
        callbacks.add(e_callbacks.PAINT, v)
    end
    
    for k, v in pairs(callback.on_shot.miss) do
        callbacks.add(e_callbacks.AIMBOT_MISS, v)
    end
    
    for k, v in pairs(callback.on_shot.hit) do
        callbacks.add(e_callbacks.AIMBOT_HIT, v)
    end
    
    callbacks.add(e_callbacks.ANTIAIM, function(fx, cmd)
        for k, v in pairs(callback.antiaim) do
            v(fx, cmd)
        end
    end)
    callbacks.add(e_callbacks.SETUP_COMMAND, function(fx)
        for k, v in pairs(callback.createmove) do
            v(fx)
        end
    end)
end, 0.1)