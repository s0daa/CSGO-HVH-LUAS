local l_color_0 = color;
local l_vector_0 = vector;
local l_error_0 = error;
local l_getmetatable_0 = getmetatable;
local l_setmetatable_0 = setmetatable;
local l_ipairs_0 = ipairs;
local l_pairs_0 = pairs;
local l_next_0 = next;
local l_require_0 = require;
local l_type_0 = type;
local l_pcall_0 = pcall;
local function v15(v11)
    -- upvalues: l_next_0 (ref)
    local v12 = {};
    for v13, v14 in l_next_0, v11 do
        v12[v13] = v14;
    end;
    return v12;
end;
serialize = function(v16)
    -- upvalues: l_type_0 (ref)
    local v17 = {};
    local v18 = nil;
    local v19 = nil;
    for v20 = 1, #v16 do
        v18 = v16[v20];
        if l_type_0(v18) == "table" then
            v19 = "{" .. serialize(v18) .. "}";
        else
            v19 = tostring(v18);
        end;
        table.insert(v17, v19);
    end;
    return table.concat(v17, ",");
end;
local function v24(v21)
    -- upvalues: l_setmetatable_0 (ref)
    local v22 = l_setmetatable_0({}, {
        __mode = "kv"
    });
    return function(...)
        -- upvalues: v22 (ref), v21 (ref)
        local v23 = serialize({
            ...
        });
        if not v22[v23] then
            v22[v23] = v21(...);
        end;
        return v22[v23];
    end;
end;
local v25 = v15(math);
local v26 = v15(string);
local v27 = v15(table);
local v28 = v15(ui);
local v29 = v15(render);
local v30 = v15(utils);
local v31 = v15(files);
local v32 = v15(entity);
local v33 = v15(l_require_0("ffi"));
local l_tonumber_0 = tonumber;
local l_tostring_0 = tostring;
local v36 = v24(v26.format);
local v37 = v24(v26.lower);
local v38 = v24(v26.sub);
local v39 = nil;
local _ = -1;
local v41 = "Arial";
local v42 = l_color_0(255);
local _ = l_vector_0(0, 0, 0);
local l_pi_0 = v25.pi;
local v45 = "elite";
local v46 = "15/06/2025";
local v47 = false;
local v48 = {};
local v49 = {};
local v50 = {};
local v51 = {};
local v52 = {};
local v53 = {};
local v54 = {};
local v55 = {};
local v56 = {};
local v57 = {};
local v58 = {};
local _ = {};
local v60 = {};
local v61 = {};
local v62 = {};
local v63 = {};
local v64 = {};
local v65 = {};
local v66 = {};
local v67 = {};
local v68 = {};
local v69 = {};
local v70 = {};
local v71 = {};
local v72 = {};
local v73 = {};
local v74 = {};
local v75 = {};
v33.cdef("\n    \n    typedef void*       HKL;\n    typedef void*       HANDLE;\n\n    typedef wchar_t*    LPWSTR;\n\n    typedef const char* LPCSTR;\n    typedef char*       LPSTR;\n\n    typedef uint32_t    UINT;\n    typedef uint32_t    WPARAM;\n    typedef uint32_t    DWORD;\n\n    typedef int64_t     LPARAM;\n    typedef int64_t     LRESULT;\n\n    typedef uint8_t     BYTE;\n    typedef uint8_t*    PBYTE;\n    typedef uint16_t    WORD;\n    \n    typedef HANDLE      HWND;\n    typedef HANDLE      HINSTANCE;\n    typedef HANDLE      HHOOK;\n\n    typedef int         BOOL;\n    typedef long        LONG;\n    typedef char        CHAR;\n    typedef wchar_t     WCHAR;\n    typedef const WCHAR *LPCWSTR;\n\n    // Typedef data structures\n\n    typedef struct \n    {\n        float x;\n        float y;\n        float z;\n    } vector_t;\n\n    typedef struct \n    {\n        uint8_t r;\n        uint8_t g;\n        uint8_t b;\n        uint8_t a;\n    } color_t;\n\n    typedef struct \n    {\n        char        pad_1[0x14];\n\n        uint32_t    m_order;\n        uint32_t    m_sequence;\n        float       m_prev_cycle;\n        float       m_weight;\n        float       m_weight_delta_rate;\n        float       m_playback_rate;\n        float       m_cycle;\n        void*       m_owner;     \n\n        char        pad_2[0x4];\n    } animation_overlay_t;\n\n    typedef struct\n    {\n        char        pad_1[0x60];\n\n        void*       m_entity;\n        void*       m_active_weapon;\n        void*       m_last_active_weapon;\n        float       m_last_update_time; \n        int         m_last_update_frame; \n        float       m_last_update_increment;\n        float       m_eye_yaw;\n        float       m_eye_pitch;\n        float       m_goal_feet_yaw;\n        float       m_last_feet_yaw;\n        float       m_move_yaw;\n        float       m_last_move_yaw;\n        float       m_lean_amount;\n\n        char        pad_2[0x4];\n\n        float       m_feet_cycle;\n        float       m_move_weight;\n        float       m_move_weight_smoothed;\n        float       m_duck_amount;\n        float       m_hit_ground_cycle;\n        float       m_recrouch_weight;\n        vector_t    m_origin;\n        vector_t    m_last_origin;\n        vector_t    m_velocity; \n        vector_t    m_velocity_normalized; \n        vector_t    m_velocity_normalized_non_zero; \n        float       m_velocity_lenght_2D; \n        float       m_jump_fall_velocity; \n        float       m_speed_normalized; \n        float       m_running_speed; \n        float       m_ducking_speed; \n        float       m_duration_moving; \n        float       m_duration_still; \n        bool        m_on_ground;\n        bool        m_hit_ground_animation;\n\n        char        pad_3[0x2];\n\n        float       m_next_lower_body_yaw_update_time;\n        float       m_duration_in_air;\n        float       m_left_ground_height; \n        float       m_hit_ground_weight;\n        float       m_walk_to_run_transition;\n\n        char        pad_4[0x4];\n\n        float       m_affected_fraction;\n\n        char        pad_5[0x208];\n\n        float       m_min_body_yaw;\n        float       m_max_body_yaw;\n        float       m_min_pitch;\n        float       m_max_pitch;\n        int         m_animset_version;\n    } animation_state_t;\n\n    typedef struct {\n        DWORD vkCode;\n        DWORD scanCode;\n        DWORD flags;\n        DWORD time;\n        DWORD dwExtraInfo;\n    } keybaord_low_level_hook_t; //KBDLLHOOKSTRUCT;\n\n    void* __stdcall URLDownloadToFileA(void* pCaller, const char* szURL, const char* szFileName, int dwReserved, int lpfnCB);\n    bool            DeleteUrlCacheEntryA(const char* lpszUrlName);\n\n    int             GetAsyncKeyState(int vKey);\n\n    int             VirtualProtect(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect);\n    void*           VirtualAlloc(void* lpAddress, unsigned long dwSize, unsigned long  flAllocationType, unsigned long flProtect);\n    int             VirtualFree(void* lpAddress, unsigned long dwSize, unsigned long dwFreeType);\n\n    // https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/ms644985(v=vs.85)\n    // https://learn.microsoft.com/he-il/windows/win32/api/winuser/nf-winuser-setwindowshookexa?redirectedfrom=MSDN\n\n    typedef LRESULT (__stdcall *HOOKPROC)(int code, WPARAM wParam, LPARAM lParam);\n    HINSTANCE       GetModuleHandleA(const char* lpModuleName); // FUCK THE PERSON WHO DESCIDED THAT SHIT\n    //HINSTANCE       GetModuleHandle(const char* lpModuleName);\n    HHOOK           SetWindowsHookExA(int idHook, void* lpfn, HINSTANCE hmod, DWORD dwThreadId);\n    LRESULT         CallNextHookEx(HHOOK hhk, int nCode, WPARAM wParam, LPARAM lParam);\n    BOOL            UnhookWindowsHookEx(HHOOK hhk);\n    DWORD           GetLastError();\n    int             ToUnicodeEx(UINT wVirtKey, UINT wScanCode, const BYTE *lpKeyState, LPWSTR pwszBuff, int cchBuff, UINT wFlags, HKL dwhkl); \n    HKL             GetKeyboardLayout(DWORD idThread);\n    int             GetKeyboardState(PBYTE lpKeyState);\n    \n    int             WideCharToMultiByte(UINT CodePage, DWORD dwFlags, const wchar_t* lpWideCharStr, int cchWideChar, char* lpMultiByteStr, int cbMultiByte, const char* lpDefaultChar, BOOL* lpUsedDefaultChar );\n\n    HWND            GetForegroundWindow();\n    HWND            GetWindowTextA(HWND hWnd, LPSTR lpString, int nMaxCount);\n    HWND            FindWindowA(const char* lpClassName, const char* lpWindowName);\n    bool            FlashWindow(HWND hWnd, bool bInvert);\n");
v33.vector_struct = v33.typeof("vector_t");
v33.libraries = {};
v33.library = function(v76)
    -- upvalues: v33 (ref), l_error_0 (ref), v36 (ref)
    if not v33.libraries[v76] then
        v33.libraries[v76] = v33.load(v76) or l_error_0(v36("Failed to load %s", v76));
    end;
    return v33.libraries[v76];
end;
v33.cast_color = v24(function(v77)
    -- upvalues: v33 (ref)
    local v78 = v33.new("color_t");
    local l_r_0 = v77.r;
    local l_g_0 = v77.g;
    local l_b_0 = v77.b;
    v78.a = v77.a;
    v78.b = l_b_0;
    v78.g = l_g_0;
    v78.r = l_r_0;
    return v78;
end);
local v82 = {};
local v83 = {};
v82.__index = v82;
v48.node = function(v84, v85)
    -- upvalues: l_setmetatable_0 (ref), v82 (ref)
    local v86 = {};
    l_setmetatable_0(v86, v82);
    v86.value = v84;
    v86.next = v85;
    return v86;
end;
v82.get_value = function(v87)
    return v87.value;
end;
v82.get_next = function(v88)
    return v88.next;
end;
v82.set_value = function(v89, v90)
    v89.value = v90;
end;
v82.set_next = function(v91, v92)
    v91.next = v92;
end;
v82.has_next = function(v93)
    -- upvalues: v39 (ref)
    return v93.next ~= v39;
end;
v83.__index = v83;
v48.queue = function()
    -- upvalues: l_setmetatable_0 (ref), v83 (ref), v39 (ref)
    local v94 = {};
    l_setmetatable_0(v94, v83);
    v94.tail = v39;
    v94.first = v39;
    return v94;
end;
v83.insert = function(v95, v96)
    -- upvalues: v48 (ref), v39 (ref)
    local v97 = v48.node(v96);
    if v95.first == v39 then
        v95.first = v97;
    else
        v95.tail:set_next(v97);
    end;
    v95.tail = v97;
end;
v83.remove = function(v98)
    -- upvalues: v39 (ref)
    if v98.first == v39 then
        return v39;
    else
        local v99 = v98.first:get_value();
        v98.first = v98.first:get_next();
        if v98.first == v39 then
            v98.tail = v39;
        end;
        return v99;
    end;
end;
v83.head = function(v100)
    -- upvalues: v39 (ref)
    if v100.first == v39 then
        return v39;
    else
        return v100.first:get_value();
    end;
end;
v83.is_empty = function(v101)
    -- upvalues: v39 (ref)
    return v101.first == v39;
end;
v83.copy = function(v102)
    -- upvalues: v48 (ref), v39 (ref)
    local v103 = v48.queue();
    local l_first_0 = v102.first;
    while l_first_0 ~= v39 do
        v103:insert(l_first_0.get_value(l_first_0));
        l_first_0 = l_first_0.get_next(l_first_0);
    end;
    return v103;
end;
v83.size = function(v105)
    -- upvalues: v39 (ref)
    local v106 = 0;
    local l_first_1 = v105.first;
    while l_first_1 ~= v39 do
        v106 = v106 + 1;
        l_first_1 = l_first_1.get_next(l_first_1);
    end;
    return v106;
end;
v83.to_string = function(v108)
    -- upvalues: v39 (ref), v36 (ref)
    local v109 = "";
    local l_first_2 = v108.first;
    while l_first_2 ~= v39 do
        v109 = v36("%s%s", v109, l_first_2.get_value(l_first_2));
        if l_first_2.has_next(l_first_2) then
            v109 = v36("%s, ", v109);
        end;
        l_first_2 = l_first_2.get_next(l_first_2);
    end;
    return v109;
end;
local v111 = {};
local v112 = {};
v111.active_windows = v48.queue();
v111.NO_ATTACH = 1;
v111.CENTER_ATTACH = 2;
v111.mouse_position = v28.get_mouse_position();
v111.active_mouse_position = v28.get_mouse_position();
v111.is_left_pressed = false;
v111.is_right_pressed = false;
v111.is_holding = v39;
v111.fade_back = 0;
v111.find = function(v113)
    -- upvalues: v111 (ref), v39 (ref)
    local l_first_3 = v111.active_windows.first;
    while true do
        if l_first_3 ~= v39 then
            current_window = l_first_3.get_value(l_first_3);
            if current_window._name == v113 then
                return current_window;
            else
                l_first_3 = l_first_3.get_next(l_first_3);
            end;
        else
            return v39;
        end;
    end;
end;
v111.process = function()
    -- upvalues: v111 (ref), v28 (ref), v29 (ref), l_vector_0 (ref), v50 (ref), l_color_0 (ref), v39 (ref)
    v111.active_mouse_position = v28.get_mouse_position();
    v111.is_left_pressed = common.is_button_down(1);
    v111.is_right_pressed = common.is_button_down(2);
    if not v111.is_left_pressed then
        v111.mouse_position = v28.get_mouse_position();
    end;
    if v111.fade_back > 0 then
        v29.rect(l_vector_0(0, 0), v50.screen_size, l_color_0(0, 150 * v111.fade_back));
    end;
    local l_first_4 = v111.active_windows.first;
    while true do
        if l_first_4 ~= v39 then
            current_window = l_first_4.get_value(l_first_4);
            if current_window and current_window._is_moving then
                v111.fade_back = v29.do_animation(v111.fade_back, 1);
                v111.is_holding = current_window;
                return;
            else
                l_first_4 = l_first_4.get_next(l_first_4);
            end;
        else
            v111.fade_back = v29.do_animation(v111.fade_back, 0);
            v111.is_holding = v39;
            return;
        end;
    end;
end;
v111.is_anything_moving = function()
    -- upvalues: v111 (ref), v39 (ref)
    return v111.is_holding ~= v39;
end;
v112.__index = v112;
v48.window = function(v116, v117, v118, v119)
    -- upvalues: l_setmetatable_0 (ref), v112 (ref), l_vector_0 (ref), v111 (ref)
    local v120 = {};
    l_setmetatable_0(v120, v112);
    v120._name = v116;
    v120._position = v117;
    v120._size = v118;
    v120._fade = 0;
    v120._is_moving = false;
    v120._move_delta = l_vector_0(0, 0);
    v120._attach = v119 or v111.NO_ATTACH;
    v120._is_attach = false;
    v120._render_calls = {};
    v111.active_windows:insert(v120);
    return v120;
end;
v112.set_position = function(v121, v122)
    v121._position = v122;
end;
v112.set_size = function(v123, v124)
    v123._size = v124;
end;
v112.set_fade = function(v125, v126)
    v125._fade = v126;
end;
v112.get_position = function(v127)
    return v127._position;
end;
v112.get_size = function(v128)
    return v128._size;
end;
v112.get_fade = function(v129)
    return v129._fade;
end;
v112.get_name = function(v130)
    return v130._name;
end;
v112.is_used = function(v131)
    return v131._is_using;
end;
v112.is_moving = function(v132)
    return v132._is_moving;
end;
v112.register = function(v133, v134, v135)
    v133[v134] = v135;
end;
v112.__call = function(v136, v137)
    -- upvalues: v39 (ref)
    if v137 == v39 then
        return self;
    else
        return v136[v137];
    end;
end;
v112.__eq = function(v138, v139)
    -- upvalues: l_type_0 (ref)
    if l_type_0(v139) == "string" then
        return v138._name == v139;
    else
        return v138._name == v139._name;
    end;
end;
v112.delete = function(v140)
    -- upvalues: v48 (ref), v111 (ref), l_pairs_0 (ref)
    local v141 = v48.queue();
    while not v111.active_windows:is_empty() do
        local v142 = v111.active_windows:remove();
        if v142:get_name() ~= v140:get_name() then
            v141:insert(v142);
        end;
    end;
    while not v141:is_empty() do
        v111.active_windows:insert(v141:remove());
    end;
    for v143 in l_pairs_0(v140._render_calls) do
        events.render:unset(v140._render_calls[v143]);
    end;
end;
v112.unregisrer_render = function(v144, v145)
    events.render:unset(v144._render_calls[v145]);
end;
v112.fade = function(v146, v147)
    -- upvalues: v29 (ref)
    v146._fade = v29.do_animation(v146._fade, v147);
end;
v112.register_render = function(v148, v149, v150)
    -- upvalues: v49 (ref), v39 (ref)
    protect = v49.safe_mode == v39 or v49.safe_mode or true;
    local v151 = protect and v49.protected_call(function()
        -- upvalues: v149 (ref), v148 (ref)
        v149(v148);
    end, v150) or v149;
    events.render:set(v151);
    v148._render_calls[v150] = v151;
end;
v112.override_position = function(v152, v153)
    -- upvalues: v28 (ref), v111 (ref), v51 (ref), v25 (ref), v30 (ref), v50 (ref)
    if v152._fade ~= 1 or v28.get_alpha() ~= 1 then
        return;
    else
        if v111.is_left_pressed and v111.mouse_position:is_in_bounds(v152._position, v153) and not v111.is_anything_moving() and not v51.use_element then
            v152._is_moving = true;
            v152._move_delta.x = v152._position.x - v111.active_mouse_position.x;
            v152._move_delta.y = v152._position.y - v111.active_mouse_position.y;
        end;
        if not v111.is_left_pressed and v152._is_moving then
            v152._is_moving = false;
        end;
        if v152._is_moving then
            v152._position.x = v25.floor(v152._move_delta.x + v111.active_mouse_position.x);
            if not v30.is_virtual_key_pressed(16) then
                v152._position.y = v25.floor(v152._move_delta.y + v111.active_mouse_position.y);
            end;
        end;
        if v152._attach == v111.CENTER_ATTACH then
            if v25.abs(v50.screen_size.x / 2 - (v152._position.x + v153.x / 2)) < 50 then
                v152._position.x = v50.screen_size.x / 2 - v153.x / 2;
                v152._is_attach = true;
            else
                v152._is_attach = false;
            end;
        end;
        return;
    end;
end;
local v154 = nil;
v154 = {
    color_print = v30.get_vfunc("vstdlib.dll", "VEngineCvar007", 25, "void(__cdecl*)(void*, const color_t&, const char*, ...)"), 
    does_file_exist = v30.get_vfunc("filesystem_stdio.dll", "VBaseFileSystem011", 10, "bool(__thiscall*)(void*, const char*, const char*)"), 
    is_console_open = v30.get_vfunc("engine.dll", "VEngineClient014", 11, "bool(__thiscall*)(void*)"), 
    play_sound = v30.get_vfunc("engine.dll", "IEngineSoundClient003", 12, "void*(__thiscall*)(void*, const char*, float, int, int, float)"), 
    find_material_by_name = v30.get_vfunc("materialsystem.dll", "VMaterialSystem080", 84, "void*(__thiscall*)(void*, const char*, const char*, bool, const char*)"), 
    sparks = v30.get_vfunc("client.dll", "IEffects001", 3, "void(__thiscall*)(void*, vector_t&, int, int, vector_t&)"), 
    get_clipboard_textcount = v30.get_vfunc("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)"), 
    set_clipboard_text = v30.get_vfunc("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)"), 
    get_clipboard_text_fn = v30.get_vfunc("vgui2.dll", "VGUI_System010", 11, "void(__thiscall*)(void*, int, const char*, int)"), 
    get_material_name = v30.get_vfunc(0, "const char*(__thiscall*)(void*)"), 
    alpha_modulate = v30.get_vfunc(27, "void(__thiscall*)(void*, float)"), 
    color_modulate = v30.get_vfunc(28, "void(__thiscall*)(void*, float, float, float)"), 
    set_flag = v30.get_vfunc(29, "void(__thiscall*)(void*, int, const bool)"), 
    get_attachment = v30.get_vfunc(84, "bool(__thiscall*)(void*, int, vector_t&)"), 
    get_attachment_index_1 = v30.get_vfunc(468, "int(__thiscall*)(void*, void*)"), 
    get_attachment_index_3 = v30.get_vfunc(469, "int(__thiscall*)(void*)")
};
local _ = print;
print = function(...)
    -- upvalues: v39 (ref), v42 (ref), v154 (ref), v33 (ref), l_tostring_0 (ref)
    local v156 = {
        ...
    };
    for v157 = 1, #v156, 2 do
        local v158 = v156[v157];
        local v159 = v156[v157 + 1];
        if v159 == v39 then
            v159 = v42;
        end;
        v154.color_print(v33.cast_color(v159), l_tostring_0(v158));
    end;
    v154.color_print(v33.cast_color(v42), "\n");
end;
local function v162(v160)
    -- upvalues: l_type_0 (ref), v37 (ref)
    local v161 = l_type_0(v160);
    if v161 == "userdata" and v160.__type then
        return v37(v160.__type.name);
    else
        return v161;
    end;
end;
local v163 = {
    _color = l_getmetatable_0(l_color_0()), 
    _vector = l_getmetatable_0(l_vector_0())
};
v163._color.override = function(v164, v165)
    return v164:alpha_modulate(v164.a * v165);
end;
v163._color.modulate = function(v166, v167)
    return v166:alpha_modulate(v166.a * v167 / 255);
end;
v163._vector.is_in_bounds = function(v168, v169, v170)
    if v168.x < v169.x or v168.x > v169.x + v170.x then
        return false;
    elseif v168.y < v169.y or v168.y > v169.y + v170.y then
        return false;
    else
        return true;
    end;
end;
v163._vector.calculate_angle = function(v171, v172)
    -- upvalues: v25 (ref), l_pi_0 (ref)
    local v173 = v25.atan((v171.y - v172.y) / (v171.x - v172.x));
    v173 = v25.normalize_yaw(v173 * 180 / l_pi_0);
    if v171.x - v172.x >= 0 then
        v173 = v25.normalize_yaw(v173 + 180);
    end;
    return v173;
end;
v163._vector.exterpolate = function(v174, v175, v176)
    return v174 + v175 * (globals.tickinterval * v176);
end;
v25.lerp = function(v177, v178, v179, v180)
    -- upvalues: v25 (ref)
    if v177 == v178 then
        return v178;
    else
        local v181 = (v178 - v177) * v179 + v177;
        if not v180 then
            v180 = 0.01;
        end;
        if v25.abs(v181 - v178) < v180 then
            return v178;
        else
            return v181;
        end;
    end;
end;
v25.clamp = v24(function(v182, v183, v184)
    if v182 < v183 then
        return v183;
    elseif v184 < v182 then
        return v184;
    else
        return v182;
    end;
end);
v25.to_int = v24(function(v185)
    -- upvalues: l_tostring_0 (ref), l_tonumber_0 (ref)
    local v186 = l_tostring_0(v185);
    local v187, _ = v186:find("%.");
    if v187 then
        return l_tonumber_0(v186:sub(1, v187 - 1));
    else
        return v185;
    end;
end);
v25.normalize_yaw = v24(function(v189)
    while v189 > 180 do
        v189 = v189 - 360;
    end;
    while v189 < -180 do
        v189 = v189 + 360;
    end;
    return v189;
end);
v27.clear = function(v190)
    -- upvalues: l_pairs_0 (ref), v39 (ref)
    for v191 in l_pairs_0(v190) do
        v190[v191] = v39;
    end;
end;
original_table_concat = v27.concat;
v27.concat = function(v192, v193)
    -- upvalues: l_type_0 (ref), l_tostring_0 (ref)
    if l_type_0(v192) == "table" then
        return original_table_concat(v192, v193);
    else
        return l_tostring_0(v192);
    end;
end;
v27.find = function(v194, v195)
    -- upvalues: l_pairs_0 (ref), v39 (ref)
    for v196, v197 in l_pairs_0(v194) do
        if v195 == v197 then
            return v196;
        end;
    end;
    return v39;
end;
v27.delete = function(v198, v199)
    -- upvalues: v27 (ref)
    local v200 = v27.find(v198, v199);
    if v200 then
        v27.remove(v198, v200);
    end;
end;
v27.reverse = function(v201)
    -- upvalues: v39 (ref)
    local v202 = {};
    if v201 == v39 then
        return v202;
    else
        for v203 = #v201, 1, -1 do
            v202[#v202 + 1] = v201[v203];
        end;
        return v202;
    end;
end;
v29.loaded_fonts = {};
v29.load_fonts = {};
v29.animation_cache = {};
v29.measures_cache = l_setmetatable_0({}, {
    __mode = "kv"
});
v29.animation_speed = 10;
v29.last_error = "";
v29.low_preformance = false;
v29.original = {
    load_font = v29.load_font, 
    measure_text = v29.measure_text, 
    text = v29.text, 
    blur = v29.blur
};
v29.blurs_options = {
    high = function(v204, v205, v206, v207, v208)
        -- upvalues: v29 (ref)
        v29.original.blur(v204, v205, v206, v207, v208);
    end, 
    low = function(_, _, _, _, _)

    end
};
v29.do_animation = function(v214, v215, v216, v217)
    -- upvalues: v29 (ref), v25 (ref)
    if not v217 then
        v217 = v29.animation_speed;
    end;
    return v25.lerp(v214, v215, globals.frametime * v217, v216);
end;
v29.do_vector_animation = function(v218, v219, v220)
    -- upvalues: v29 (ref)
    v218.x = v29.do_animation(v218.x, v219.x, v220);
    v218.y = v29.do_animation(v218.y, v219.y, v220);
    v218.z = v29.do_animation(v218.z, v219.z, v220);
    return v218;
end;
v29.do_color_animation = function(v221, v222, v223)
    -- upvalues: l_color_0 (ref), v29 (ref)
    local v224 = l_color_0();
    v224.r = v29.do_animation(v221.r, v222.r, v223);
    v224.g = v29.do_animation(v221.g, v222.g, v223);
    v224.b = v29.do_animation(v221.b, v222.b, v223);
    v224.a = v29.do_animation(v221.a, v222.a, v223);
    return v224;
end;
v29.get_animation_value = function(v225)
    -- upvalues: v29 (ref)
    return v29.animation_cache[v225] or 0;
end;
v29.create_animation = function(v226, v227)
    -- upvalues: v29 (ref)
    if not v29.animation_cache[v226] then
        v29.animation_cache[v226] = v227;
    end;
end;
v29.preform_animation = function(v228, v229, v230, v231)
    -- upvalues: v162 (ref), v29 (ref)
    local v232 = v162(v229);
    if not v29.animation_cache[v228] then
        if v232 == "number" then
            v29.animation_cache[v228] = 0;
        else
            v29.animation_cache[v228] = v229;
        end;
    end;
    if v232 == "number" then
        v29.animation_cache[v228] = v29.do_animation(v29.animation_cache[v228], v229, v230, v231);
    elseif v232 == "imcolor" then
        v29.animation_cache[v228] = v29.do_color_animation(v29.animation_cache[v228], v229, v230);
    elseif v232 == "vector" then
        v29.animation_cache[v228] = v29.do_vector_animation(v29.animation_cache[v228], v229, v230);
    end;
    return v29.animation_cache[v228];
end;
v29.clear_cache = function()
    -- upvalues: v27 (ref), v29 (ref)
    v27.clear(v29.animation_cache);
end;
v29.switch_preformance = function()
    -- upvalues: v29 (ref)
    v29.low_preformance = not v29.low_preformance;
    local v233 = v29.low_preformance and "low" or "high";
    v29.blur = v29.blurs_options[v233];
end;
v29.load_font = function(v234, v235, v236, v237)
    -- upvalues: v29 (ref), v39 (ref)
    v29.loaded_fonts[v234] = false;
    v29.load_fonts[#v29.load_fonts + 1] = {
        _name = v234, 
        _size = v235, 
        _data = v236, 
        _other_font = v237 or v39
    };
end;
v29.font = function(v238)
    -- upvalues: v29 (ref)
    return v29.loaded_fonts[v238];
end;
v29.measure_text = function(v239, v240, v241)
    -- upvalues: v36 (ref), v29 (ref)
    local v242 = v36("%s>>%s", v239, v241);
    if not v29.measures_cache[v242] or v29.measures_cache[v242].x == 0 then
        local v243 = v29.original.measure_text(v29.font(v239), v240, v241);
        v29.measures_cache[v242] = v243;
    end;
    return v29.measures_cache[v242];
end;
v29.text = function(v244, v245, v246, v247, v248)
    -- upvalues: v29 (ref)
    v29.original.text(v29.font(v244), v245, v246, v247, v248);
end;
v29.initialize_fonts = function()
    -- upvalues: v29 (ref), v41 (ref), v36 (ref), v27 (ref)
    for v249 = 1, #v29.load_fonts do
        local v250 = v29.load_fonts[v249];
        local v251 = v250._other_font or v41;
        v29.loaded_fonts[v250._name] = v29.original.load_font(v251, v250._size, v250._data);
        if not v29.loaded_fonts[v250._name] then
            v29.last_error = v36("Failed to load %s for %s", v251, v250._name);
            return false;
        end;
    end;
    v27.clear(v29.load_fonts);
    return true;
end;
v26.wrap_text = v24(function(v252, v253, v254)
    -- upvalues: l_ipairs_0 (ref), v36 (ref), v29 (ref), v39 (ref), v27 (ref)
    local v255 = {};
    local v256 = {};
    local v257 = "";
    for v258 in v252:gmatch("%S+") do
        v256[#v256 + 1] = v258;
    end;
    for _, v260 in l_ipairs_0(v256) do
        local v261 = v36("%s%s ", v257, v260);
        if v253 < v29.measure_text(v254, v39, v261).x then
            v255[#v255 + 1] = v257;
            v257 = v36("%s ", v260);
        else
            v257 = v261;
        end;
    end;
    v255[#v255 + 1] = v257;
    return v27.concat(v255, "\n");
end);
v26.fixed_number = v24(function(v262, v263)
    -- upvalues: l_type_0 (ref), l_error_0 (ref), v36 (ref)
    if l_type_0(v262) ~= "number" then
        l_error_0("Number must be a number dumbass");
    end;
    local v264 = "%0" .. v263 .. "d";
    return v36(v264, v262);
end);
v26.clear_color_codes = function(v265)
    -- upvalues: v26 (ref)
    if v26.find(v265, "\aDEFAULT") then
        v265 = v26.gsub(v265, "\aDEFAULT", "");
    end;
    if v26.find(v265, "\a") then
        v265 = v26.sub(v265, 1, v26.find(v265, "\a") - 1) .. v26.sub(v265, v26.find(v265, "\a") + 9);
    end;
    return v265;
end;
v26.clear = function(v266)
    -- upvalues: v26 (ref)
    local v267 = "";
    local v268 = false;
    for v269 = 1, #v266 do
        local v270 = v266:sub(v269, v269);
        if v26.byte(v270) == 0 then
            v268 = true;
        elseif not v268 then
            v267 = v267 .. v270;
        else
            break;
        end;
    end;
    return v267;
end;
v26.remove_last_char = function(v271)
    -- upvalues: v26 (ref)
    local v272 = #v271;
    if v272 == 0 then
        return "";
    else
        local l_v272_0 = v272;
        while true do
            if l_v272_0 > 0 then
                local v274 = v26.byte(v271, l_v272_0);
                if v274 < 128 then
                    return v26.sub(v271, 1, l_v272_0 - 1);
                elseif v274 >= 128 and v274 < 192 then
                    l_v272_0 = l_v272_0 - 1;
                else
                    return v26.sub(v271, 1, l_v272_0 - 1);
                end;
            else
                return "";
            end;
        end;
    end;
end;
v30.csgo_hwnd = v39;
v30.download_file = function(v275, v276)
    -- upvalues: v33 (ref), v39 (ref)
    v33.library("WinInet").DeleteUrlCacheEntryA(v275);
    v33.library("UrlMon").URLDownloadToFileA(v39, v275, v276, 0, 0);
end;
v30.file_exists = function(v277)
    -- upvalues: v154 (ref), v39 (ref)
    return v154.does_file_exist(v277, v39) or false;
end;
v30.is_virtual_key_pressed = function(v278)
    -- upvalues: v33 (ref)
    v33.C.GetAsyncKeyState(v278);
    return v33.C.GetAsyncKeyState(v278) ~= 0;
end;
v30.wide_char_to_multi_byte_string = function(v279)
    -- upvalues: v33 (ref), v39 (ref)
    local v280 = v33.C.WideCharToMultiByte(65001, 0, v279, -1, v39, 0, v39, v39);
    local v281 = v33.new("char[?]", v280);
    v33.C.WideCharToMultiByte(65001, 0, v279, -1, v281, v280, v39, v39);
    return v33.string(v281);
end;
v30.can_hit = function(v282, v283)
    -- upvalues: v32 (ref), v30 (ref)
    if not v283 then
        v283 = 1;
    end;
    local v284 = v32.get_local_player();
    local v285 = v284:get_eye_position():exterpolate(v284.m_vecVelocity, 2);
    local v286 = {
        [1] = 3, 
        [2] = 4, 
        [3] = 5, 
        [4] = 6, 
        [5] = 7, 
        [6] = 1
    };
    for v287 = 1, #v286 do
        local v288 = v282:get_hitbox_position(v286[v287]);
        if v283 < v30.trace_bullet(v284, v285, v288) then
            return true;
        end;
    end;
    return false;
end;
v30.get_worst_damage = function(v289, v290)
    -- upvalues: v30 (ref), v25 (ref)
    local v291 = v289:get_eye_position();
    local v292 = v291:exterpolate(v289.m_vecVelocity, 3);
    local v293 = v30.trace_bullet(v289, v291, v290);
    local v294 = v30.trace_bullet(v289, v292, v290);
    return v25.max(v293, v294);
end;
v30.get_window_text = function(v295)
    -- upvalues: v33 (ref)
    local v296 = v33.new("char[?]", 256);
    v33.C.GetWindowTextA(v295, v296, 256);
    return v33.string(v296);
end;
v30.is_csgo_selected = function()
    -- upvalues: v33 (ref), v30 (ref)
    local v297 = v33.C.GetForegroundWindow();
    return v30.get_window_text(v297) == v30.get_window_text(v30.csgo_hwnd);
end;
v30.flash_icon = function()
    -- upvalues: v30 (ref), v33 (ref)
    if not v30.csgo_hwnd then
        return;
    else
        v33.C.FlashWindow(v30.csgo_hwnd, true);
        return;
    end;
end;
v30.can_fire = function(v298)
    -- upvalues: v32 (ref)
    if not v298 or not v298:is_alive() then
        return false;
    else
        local v299 = v298:get_player_weapon();
        if not v299 then
            return false;
        else
            local v300 = v32.get_game_rules();
            if not v300 then
                return false;
            elseif v300.m_bFreezePeriod then
                return false;
            else
                local l_curtime_0 = globals.curtime;
                if l_curtime_0 < v298.m_flNextAttack then
                    return false;
                elseif l_curtime_0 < v299.m_flNextPrimaryAttack then
                    return false;
                else
                    return true;
                end;
            end;
        end;
    end;
end;
v30.get_clipboard = function()
    -- upvalues: v154 (ref), v33 (ref), v47 (ref)
    local v302 = v154.get_clipboard_textcount();
    if v302 > 0 then
        local v303 = v33.new("char[?]", v302);
        v154.get_clipboard_text_fn(0, v303, v302);
        local v304 = v33.string(v303, v302 - 1);
        if v47 then
            print(#v304);
        end;
        return v304;
    else
        return "";
    end;
end;
v30.set_clipboard = function(v305)
    -- upvalues: v154 (ref)
    if v305 then
        v154.set_clipboard_text(v305, v305:len());
    end;
end;
v163 = nil;
v163 = {
    execute = function(v306, v307)
        -- upvalues: v26 (ref)
        local v308 = "";
        for v309 = 1, #v306 do
            local v310 = v26.sub(v306, v309, v309);
            xor_byte = v26.byte(v310) + v307;
            v308 = v308 .. v26.char(xor_byte);
        end;
        return v308;
    end
};
local v311 = common.get_game_directory();
v31.full_path = v36("%s\\%s\\", v311, "DigitalDreams");
v31.last_error = "";
v31.default_config = "https://github.com/N0TH1NG1337/Digital-Dreams/raw/main/Files/Config1.digital";
v31.icons_list = {
    ["check.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/correct_icon.png", 
    ["tuning.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/tuning_icon.png", 
    ["data.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/data_icon.png", 
    ["sun.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/sun_icon.png", 
    ["rotate.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/sync_icon.png", 
    ["fire.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/fire_icon.png", 
    ["home.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/home_icon.png", 
    ["location.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/location_icon.png", 
    ["cloud.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/digital_dreams_icon.png", 
    ["unk_rotate.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/unk_rotate_icon.png", 
    ["headshot.svg"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Old_Files/Icons/HeadShot", 
    ["radar.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/radar.png", 
    ["armor.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/armor_icon.png", 
    ["blind.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/blind_icon.png", 
    ["health.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/health_icon.png", 
    ["bullet.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/bullet_icon.png", 
    ["search.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/search_icon.png", 
    ["arrow.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/arrow_icon.png", 
    ["keyboard.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/keyboard_icon.png", 
    ["warning.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/warning_icon.png", 
    ["color.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/color_icon.png", 
    ["load.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/load_icon.png", 
    ["check_list.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/check_list_icon.png", 
    ["save.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/save_icon.png", 
    ["close.png"] = "https://raw.githubusercontent.com/N0TH1NG1337/Digital-Dreams/main/Files/Icons/close_icon.png"
};
v31.sounds_list = {
    ["Tec-9.wav"] = "https://github.com/N0TH1NG1337/Digital-Dreams/raw/main/Old_Files/DigitalSounds/Tec-9.wav", 
    ["R8 Revolver.wav"] = "https://github.com/N0TH1NG1337/Digital-Dreams/raw/main/Old_Files/DigitalSounds/R8%20Revolver.wav", 
    ["USP-S.wav"] = "https://github.com/N0TH1NG1337/Digital-Dreams/raw/main/Old_Files/DigitalSounds/USP-S.wav", 
    ["menu_load.wav"] = "https://github.com/N0TH1NG1337/Digital-Dreams/raw/main/Files/Sounds/menu_load.wav", 
    ["G3SG1.wav"] = "https://github.com/N0TH1NG1337/Digital-Dreams/raw/main/Old_Files/DigitalSounds/G3SG1.wav", 
    ["fast_press.wav"] = "https://github.com/N0TH1NG1337/Digital-Dreams/raw/main/Files/Sounds/fast_press.wav", 
    ["AWP.wav"] = "https://github.com/N0TH1NG1337/Digital-Dreams/raw/main/Old_Files/DigitalSounds/AWP.wav", 
    ["woosh.wav"] = "https://github.com/N0TH1NG1337/Digital-Dreams/raw/main/Files/Sounds/woosh.wav", 
    ["Desert Eagle.wav"] = "https://github.com/N0TH1NG1337/Digital-Dreams/raw/main/Old_Files/DigitalSounds/Desert%20Eagle.wav", 
    ["ui_click.wav"] = "https://github.com/N0TH1NG1337/Digital-Dreams/raw/main/Files/Sounds/ui_click.wav", 
    ["Five-SeveN.wav"] = "https://github.com/N0TH1NG1337/Digital-Dreams/raw/main/Old_Files/DigitalSounds/Five-SeveN.wav", 
    ["error.wav"] = "https://github.com/N0TH1NG1337/Digital-Dreams/raw/main/Files/Sounds/error.wav", 
    ["SSG 08.wav"] = "https://github.com/N0TH1NG1337/Digital-Dreams/raw/main/Old_Files/DigitalSounds/SSG%2008.wav", 
    ["SCAR-20.wav"] = "https://github.com/N0TH1NG1337/Digital-Dreams/raw/main/Old_Files/DigitalSounds/SCAR-20.wav"
};
local function v315(v312, v313)
    -- upvalues: v36 (ref), v31 (ref), v30 (ref)
    local v314 = v36("%s%s\\%s", v31.full_path, "Icons", v312);
    if not v313 and v30.file_exists(v314) then
        return;
    else
        assert(v31.icons_list[v312], "Invalid Icon Index");
        v30.download_file(v31.icons_list[v312], v314);
        return;
    end;
end;
do
    local l_v311_0, l_v315_0 = v311, v315;
    local function v321(v318, v319)
        -- upvalues: v36 (ref), l_v311_0 (ref), v30 (ref), v31 (ref)
        local v320 = v36("%s\\%s\\%s", l_v311_0, "sound\\DigitalSounds", v318);
        if not v319 and v30.file_exists(v320) then
            return;
        else
            assert(v31.sounds_list[v318], "Invalid Sound Index");
            v30.download_file(v31.sounds_list[v318], v320);
            return;
        end;
    end;
    v31.load_icon = function(v322, v323)
        -- upvalues: v36 (ref), v31 (ref), v30 (ref), v39 (ref), v29 (ref)
        local v324 = v36("%s%s\\%s", v31.full_path, "Icons", v322);
        if not v30.file_exists(v324) then
            return v39;
        else
            return {
                img = v29.load_image_from_file(v324, v323), 
                size = v323
            };
        end;
    end;
    v31.initialize_icons = function()
        -- upvalues: v31 (ref), l_pcall_0 (ref), l_pairs_0 (ref), l_v315_0 (ref), v36 (ref), v30 (ref)
        v31.create_folder("csgo\\DigitalDreams");
        v31.create_folder("csgo\\DigitalDreams\\Icons");
        v31.create_folder("csgo\\DigitalDreams\\Configs");
        local v328, v329 = l_pcall_0(function()
            -- upvalues: l_pairs_0 (ref), v31 (ref), l_v315_0 (ref), v36 (ref), v30 (ref)
            for v325, _ in l_pairs_0(v31.icons_list) do
                l_v315_0(v325, false);
                local v327 = v36("%s%s\\%s", v31.full_path, "Icons", v325);
                if not v30.file_exists(v327) then
                    v31.last_error = v36("Failed to download / find the file %s", v325);
                    return false;
                end;
            end;
            return true;
        end);
        return v328 and v329;
    end;
    v31.initialize_sounds = function(_)
        -- upvalues: v31 (ref), l_pcall_0 (ref), l_pairs_0 (ref), v321 (ref), v36 (ref), l_v311_0 (ref), v30 (ref)
        v31.create_folder("csgo\\sound\\DigitalSounds");
        local v334, v335 = l_pcall_0(function()
            -- upvalues: l_pairs_0 (ref), v31 (ref), v321 (ref), v36 (ref), l_v311_0 (ref), v30 (ref)
            for v331, _ in l_pairs_0(v31.sounds_list) do
                v321(v331, false);
                local v333 = v36("%s\\%s\\%s", l_v311_0, "sound\\DigitalSounds", v331);
                if not v30.file_exists(v333) then
                    v31.last_error = v36("Failed to download / find the file %s", v331);
                    return false;
                end;
            end;
            return true;
        end);
        return v334 and v335;
    end;
    v31.initialize_configs = function(_)
        -- upvalues: v30 (ref), v36 (ref), v31 (ref)
        for v337 = 1, 8 do
            if not v30.file_exists(v36("%sConfigs\\Config%d.digital", v31.full_path, v337)) and not v31.write(v36("csgo\\DigitalDreams\\Configs\\Config%d.digital", v337), "?") then
                return false;
            end;
        end;
        if not v30.file_exists(v31.full_path .. "Configs\\AutoSave.digital") and not v31.write("csgo\\DigitalDreams\\Configs\\AutoSave.digital", "?") then
            return false;
        else
            return true;
        end;
    end;
end;
v49.ignored_methods = {};
v49.low_level_keyboard_event = {};
v49.keyboard_handle = v39;
v49.safe_mode = (db._DigitalDreams_SafeModeHook or {
    is = true
}).is;
v49.new = function(_, _, _, _)

end;
v315 = function(v342, v343, v344)
    -- upvalues: v49 (ref), v33 (ref), v39 (ref)
    if v342 >= 0 then
        for v345 = 1, #v49.low_level_keyboard_event do
            local v346 = v49.low_level_keyboard_event[v345];
            if v346 and v346(v342, v343, v344) == true then
                return 1;
            end;
        end;
    end;
    return v33.C.CallNextHookEx(v39, v342, v343, v344);
end;
v49.protected_call = function(v347, v348)
    -- upvalues: v49 (ref), l_pcall_0 (ref), v154 (ref), v31 (ref), v163 (ref), l_color_0 (ref), v42 (ref), v47 (ref)
    return function(...)
        -- upvalues: v49 (ref), v348 (ref), l_pcall_0 (ref), v347 (ref), v154 (ref), v31 (ref), v163 (ref), l_color_0 (ref), v42 (ref), v47 (ref)
        if v49.ignored_methods[v348] then
            return;
        else
            local v349, v350 = l_pcall_0(v347, ...);
            if not v349 then
                v49.ignored_methods[v348] = true;
                v154.play_sound("DigitalSounds/error.wav", 1, 100, 0, 0);
                v31.write("csgo\\DigitalDreams\\ErrorLog.digital", v163.execute(v350, 11));
                local v351 = l_color_0(255, 10, 10, 255);
                print("  digital  \194\183 ", v351, "looks like some error occurred in ", v42, v348, v351, ".\nPlease contact the lua developer in discord server via tickets and provide the next file ", v42, "ErrorLog.digital", v351, " that is located in \n", v42, v31.full_path, v351);
                if v47 then
                    print(v350);
                end;
                return;
            else
                return v350;
            end;
        end;
    end;
end;
v49.attach = function(v352, v353, v354)
    -- upvalues: v49 (ref)
    protect = v49.safe_mode;
    if v352 == "low_level_keyboard" then
        v49.low_level_keyboard_event[#v49.low_level_keyboard_event + 1] = v49.protected_call(v353, v354);
        return;
    else
        local v355 = protect and v49.protected_call(v353, v354) or v353;
        events[v352]:set(v355);
        return;
    end;
end;
v49.destroy = function()
    -- upvalues: v49 (ref), v33 (ref)
    if v49.keyboard_handle then
        v33.C.UnhookWindowsHookEx(v49.keyboard_handle);
    end;
end;
do
    local l_v315_1 = v315;
    v49.initialize = function()
        -- upvalues: v49 (ref), v33 (ref), l_v315_1 (ref), v39 (ref), v47 (ref)
        v49.keyboard_handle = v33.C.SetWindowsHookExA(13, v33.cast("HOOKPROC", l_v315_1), v33.cast("void*", 0), 0);
        if not v33.istype("void*", v49.keyboard_handle) then
            v49.keyboard_handle = v39;
            if v47 then
                print(v33.C.GetLastError());
            end;
            return false;
        else
            v49.attach("shutdown", v49.destroy, "lua::hooks::destroy");
            return true;
        end;
    end;
end;
v50.selected_theme = "black";
v50.screen_size = v29.screen_size();
v50.default_round = 8;
v29.load_font("theme::font", 16, "ad");
v29.load_font("theme::high", l_vector_0(20, 20, 1), "ad");
v29.load_font("theme::low", l_vector_0(14, 14, 1), "ad");
v29.load_font("manuals::arrows", l_vector_0(30, 25, 1), "ad");
v50.colors = {
    accent = l_color_0(150, 150, 255, 255), 
    background = l_color_0(10, 10, 30, 100), 
    outline = l_color_0(100, 100), 
    on_hover = l_color_0(39, 39, 42, 255), 
    text = l_color_0(247, 247, 247, 255)
};
v50.render_background = function(v357, v358, v359, v360)
    -- upvalues: v50 (ref), v29 (ref)
    if not v360 then
        v360 = v50.default_round;
    end;
    v29.blur(v357, v358, 1, v359, v360);
    v29.rect(v357, v358, v50.colors.background:override(v359), v360);
end;
v50.render_card = function(v361, v362, v363, v364, v365)
    -- upvalues: v50 (ref), v29 (ref)
    if not v365 then
        v365 = 0.3;
    end;
    if not v364 then
        v364 = v50.default_round;
    end;
    local v366 = v50.colors.outline:override(0);
    local v367 = v50.colors.outline:override(v363 * v365);
    v29.gradient(v361, v362, v366, v367, v366, v367, v364);
end;
v50.render_outline = function(v368, v369, v370, v371)
    -- upvalues: v50 (ref), v29 (ref)
    if not v371 then
        v371 = v50.default_round;
    end;
    v29.rect_outline(v368, v369, v50.colors.outline:override(v370), 1, v371);
end;
v50.render_accent = function(v372, v373, v374, v375, v376)
    -- upvalues: v50 (ref), v29 (ref)
    if not v375 then
        v375 = v50.default_round;
    end;
    if not v376 then
        v376 = v50.colors.accent;
    end;
    v29.shadow(v372, v373, v376.override(v376, v374), 40, 0, v375);
    v29.rect(v372, v373, v376.override(v376, v374), v375);
end;
v50.render_half_outline = function(v377, v378, v379, v380, v381)
    -- upvalues: v50 (ref), v29 (ref), l_vector_0 (ref)
    if not v381 then
        v381 = 0.3;
    end;
    if not v380 then
        v380 = v50.default_round;
    end;
    local v382 = v50.colors.outline:override(0);
    local v383 = v50.colors.outline:override(v379);
    local v384 = v50.colors.outline:override(v379 * v381);
    v29.gradient(v377, v378, v382, v384, v382, v384, v380);
    local v385 = (v378.x - v377.x) * 0.5;
    v29.push_clip_rect(l_vector_0(v377.x + v385, v377.y), v378);
    v50.render_outline(v377, v378, v379, v380);
    v29.pop_clip_rect();
    v29.gradient(v377, v377 + l_vector_0(v385, 1), v382, v383, v382, v383);
    v29.gradient(l_vector_0(v377.x, v378.y - 1), l_vector_0(v377.x + v385, v378.y), v382, v383, v382, v383);
end;
v50.render_text = function(v386, v387, v388, v389, ...)
    -- upvalues: v29 (ref), v50 (ref)
    v29.text(v386, v387, v50.colors.text:override(v388), v389, ...);
end;
v50.preform_colors = function()
    -- upvalues: v50 (ref), v51 (ref), v29 (ref)
    local _ = v50[v50.selected_theme];
    v50.colors.accent = v51.get("theme_accent");
    v50.colors.background = v51.get("theme_background");
    v50.screen_size = v29.screen_size();
end;
v311 = nil;
v311 = {
    active = v48.queue(), 
    temp = v48.queue(), 
    pad = 0, 
    screen = v29.screen_size()
};
v311.add = function(v391, v392)
    -- upvalues: v311 (ref)
    v311.active:insert({
        alpha = 0, 
        text = v391, 
        icon = v392, 
        time = globals.realtime
    });
end;
v311.render = function()
    -- upvalues: v311 (ref), v29 (ref), v39 (ref), l_vector_0 (ref), v25 (ref), v50 (ref), l_color_0 (ref)
    v311.pad = 0;
    if v311.active:is_empty() then
        return;
    else
        while not v311.active:is_empty() do
            local v393 = v311.active:remove();
            local v394 = v393.time + 5 > globals.realtime;
            v393.alpha = v29.do_animation(v393.alpha, v394 and 1 or 0, false);
            if v394 or v393.alpha ~= 0 then
                v311.temp:insert(v393);
            end;
            local v395 = v29.measure_text("theme::font", v39, v393.text);
            local v396 = l_vector_0(v395.x + 60 + 40, 60);
            local v397 = 50 * v25.abs(v393.alpha - 1);
            local v398 = l_vector_0(v311.screen.x / 2 - v396.x / 2 + v397, 20 + v311.pad * 90);
            local v399 = l_vector_0(v311.screen.x / 2 + v396.x / 2 + v397, v398.y + v396.y);
            v50.render_background(v398, v399, v393.alpha);
            if v393.icon then
                v29.texture(v393.icon.img, v398 + l_vector_0(20, 10), v393.icon.size, l_color_0(255, 180 * v393.alpha));
            end;
            v50.render_text("theme::font", v398 + l_vector_0(80, 30 - v395.y / 2), v393.alpha, v39, v393.text);
            v311.pad = v311.pad + v393.alpha;
        end;
        while not v311.temp:is_empty() do
            v311.active:insert(v311.temp:remove());
        end;
        return;
    end;
end;
v51.window = v48.window("lua::ui::main_window", l_vector_0(100, 100), l_vector_0(780, 600));
v51.icons = {};
v51.tabs_list = {};
v51.centered_tabs = 0;
v51.binded_keys = {};
v51.global_time = 0;
v51.fix_press = false;
v51.use_element = v39;
v51.active_tab = 1;
v51.hovered_table = "";
v51.color_picker = {
    is_alpha = false, 
    is_value_saturation = false, 
    is_hue = false, 
    hue = {}, 
    saturation = {}, 
    value = {}, 
    alpha = {}, 
    hue_colors = {
        l_color_0(255, 0, 0, 255), 
        l_color_0(255, 255, 0, 255), 
        l_color_0(0, 255, 0, 255), 
        l_color_0(0, 255, 255, 255), 
        l_color_0(0, 0, 255, 255), 
        l_color_0(255, 0, 255, 255), 
        l_color_0(255, 0, 0, 255)
    }, 
    saved_colors = {}
};
v51.is_binding_new_key = false;
v51.is_using_keyboard = false;
v51.keyboard_data = v39;
v51.keybind_data = v39;
v51.elements_ptrs = {};
v29.load_font("ui::item", l_vector_0(22, 20, 1), "a");
v51.virtual_keys = {
    [1] = nil, 
    [2] = nil, 
    [3] = "m3", 
    [4] = nil, 
    [5] = "m4", 
    [6] = "m5", 
    [7] = nil, 
    [8] = "Back", 
    [9] = "Tab", 
    [10] = nil, 
    [11] = nil, 
    [12] = nil, 
    [13] = "Enter", 
    [14] = nil, 
    [15] = nil, 
    [16] = "Shift", 
    [17] = "Ctrl", 
    [18] = "Alt", 
    [19] = "Pause", 
    [20] = "Caps", 
    [21] = nil, 
    [22] = nil, 
    [23] = nil, 
    [24] = nil, 
    [25] = nil, 
    [26] = nil, 
    [27] = "-", 
    [28] = nil, 
    [29] = nil, 
    [30] = nil, 
    [31] = nil, 
    [32] = "Space", 
    [33] = nil, 
    [34] = nil, 
    [35] = "End", 
    [36] = "Home", 
    [37] = "Left", 
    [38] = "Up", 
    [39] = "Right", 
    [40] = "Down", 
    [41] = "Select", 
    [42] = nil, 
    [43] = nil, 
    [44] = nil, 
    [45] = "Insert", 
    [46] = "Del", 
    [47] = nil, 
    [48] = "0", 
    [49] = "1", 
    [50] = "2", 
    [51] = "3", 
    [52] = "4", 
    [53] = "5", 
    [54] = "6", 
    [55] = "7", 
    [56] = "8", 
    [57] = "9", 
    [58] = nil, 
    [59] = nil, 
    [60] = nil, 
    [61] = nil, 
    [62] = nil, 
    [63] = nil, 
    [64] = nil, 
    [65] = "A", 
    [66] = "B", 
    [67] = "C", 
    [68] = "D", 
    [69] = "E", 
    [70] = "F", 
    [71] = "G", 
    [72] = "H", 
    [73] = "I", 
    [74] = "J", 
    [75] = "K", 
    [76] = "L", 
    [77] = "M", 
    [78] = "N", 
    [79] = "O", 
    [80] = "P", 
    [81] = "Q", 
    [82] = "R", 
    [83] = "S", 
    [84] = "T", 
    [85] = "U", 
    [86] = "V", 
    [87] = "W", 
    [88] = "X", 
    [89] = "Y", 
    [90] = "Z", 
    [91] = nil, 
    [92] = nil, 
    [93] = nil, 
    [94] = nil, 
    [95] = nil, 
    [96] = nil, 
    [97] = nil, 
    [98] = nil, 
    [99] = nil, 
    [100] = nil, 
    [101] = nil, 
    [102] = nil, 
    [103] = nil, 
    [104] = nil, 
    [105] = nil, 
    [106] = nil, 
    [107] = nil, 
    [108] = nil, 
    [109] = nil, 
    [110] = nil, 
    [111] = nil, 
    [112] = "F1", 
    [113] = "F2", 
    [114] = "F3", 
    [115] = "F4", 
    [116] = "F5", 
    [117] = "F6", 
    [118] = "F7", 
    [119] = "F8", 
    [120] = "F9", 
    [121] = "F10", 
    [122] = "F11"
};
v51.invalid_vk = {
    [163] = true, 
    [165] = true, 
    [164] = true, 
    [17] = true, 
    [18] = true, 
    [20] = true, 
    [8] = true, 
    [16] = true, 
    [13] = true, 
    [160] = true, 
    [161] = true, 
    [162] = true
};
v51.references = {
    anti_aim_enable = v28.find("Aimbot", "Anti Aim", "Angles", "Enabled"), 
    hidden = v28.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"), 
    pitch = v28.find("Aimbot", "Anti Aim", "Angles", "Pitch"), 
    yaw = v28.find("Aimbot", "Anti Aim", "Angles", "Yaw"), 
    yaw_base = v28.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
    body_yaw = v28.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
    yaw_offset = v28.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
    yaw_modifier = v28.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"), 
    yaw_modifier_offset = v28.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"), 
    body_yaw_options = v28.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
    left_limit = v28.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
    right_limit = v28.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
    freestand_desync = v28.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"), 
    freestand = v28.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
    inverter = v28.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
    slow_walk = v28.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
    fake_duck = v28.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
    double_tap = v28.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
    hide_shots = v28.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
    dormant_aimbot = v28.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"), 
    auto_peek = v28.find("Aimbot", "Ragebot", "Main", "Peek Assist"), 
    lag_options = v28.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"), 
    hide_shots_options = v28.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"), 
    scope = v28.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"), 
    removlas = v28.find("Visuals", "World", "Main", "Removals"), 
    legs_movement = v28.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"), 
    preserve_kill_feed = v28.find("Miscellaneous", "Main", "In-Game", "Preserve Kill Feed"), 
    hitchance = {
        v28.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Hit Chance"), 
        v28.find("Aimbot", "Ragebot", "Selection", "AWP", "Hit Chance"), 
        v28.find("Aimbot", "Ragebot", "Selection", "AutoSnipers", "Hit Chance"), 
        v28.find("Aimbot", "Ragebot", "Selection", "R8 Revolver", "Hit Chance"), 
        v28.find("Aimbot", "Ragebot", "Selection", "Desert Eagle", "Hit Chance"), 
        v28.find("Aimbot", "Ragebot", "Selection", "Pistols", "Hit Chance")
    }, 
    auto_scope = {
        v28.find("Aimbot", "Ragebot", "Accuracy", "SSG-08", "Auto Scope"), 
        v28.find("Aimbot", "Ragebot", "Accuracy", "AWP", "Auto Scope"), 
        v28.find("Aimbot", "Ragebot", "Accuracy", "AutoSnipers", "Auto Scope")
    }, 
    min_damage = v28.find("Aimbot", "Ragebot", "Selection", "Min. Damage")
};
v51.local_states = {
    [1] = "Global", 
    [2] = "Stand", 
    [3] = "Slow walk", 
    [4] = "Move", 
    [5] = "Air", 
    [6] = "Use"
};
v51.sub_states = {
    [1] = "Regular", 
    [2] = "Crouch", 
    [3] = "Fake lag"
};
v51.weapons = {
    [1] = "Scout", 
    [2] = "AWP", 
    [3] = "Auto", 
    [4] = "R8", 
    [5] = "Deagle", 
    [6] = "Pistols"
};
v51.sounds_list = {
    swao = "DigitalSounds/woosh.wav", 
    click = "DigitalSounds/ui_click.wav"
};
v51.get = function(v400)
    -- upvalues: v51 (ref)
    return v51.elements_ptrs[v400].value;
end;
v51.visible = function(v401, v402)
    -- upvalues: v39 (ref), v51 (ref)
    if v402 == v39 then
        return v51.elements_ptrs[v401].is_visible;
    else
        v51.elements_ptrs[v401].is_visible = v402;
        return;
    end;
end;
v51.new = function(v403, v404, ...)
    -- upvalues: v51 (ref)
    v51.elements_ptrs[v403] = v404(...);
end;
v51.has_bind = function(v405)
    -- upvalues: v51 (ref)
    return v51.binded_keys[v405].key ~= 27;
end;
v51.get_bind = function(v406)
    -- upvalues: v51 (ref)
    return v51.binded_keys[v406].value;
end;
v51.find = function(v407, v408, v409, v410)
    -- upvalues: v51 (ref), v39 (ref)
    local v411 = {
        search_point = true, 
        Script = true, 
        Configs = true, 
        result = true
    };
    for v412 = 1, #v51.tabs_list do
        local v413 = v51.tabs_list[v412];
        if (not v410 or v410[v412]) and v413._name == v407 then
            for v414 = 1, #v413.tables do
                local v415 = v413.tables[v414];
                if not v411[v415._name] and v415._name == v408 then
                    for v416 = 1, #v415.elements do
                        local v417 = v415.elements[v416];
                        if v417._name == v409 then
                            return v417;
                        end;
                    end;
                end;
            end;
        end;
    end;
    return v39;
end;
v51.get_config = function()
    -- upvalues: v51 (ref), v163 (ref)
    local v418 = {
        author = common.get_username(), 
        date = common.get_date("%d/%m/%Y"), 
        menu = {}, 
        keybinds = {}
    };
    local v419 = {
        search_point = true, 
        Script = true, 
        Configs = true, 
        result = true
    };
    local v420 = v51.get("tabs_selections");
    for v421 = 1, #v51.tabs_list do
        local v422 = v51.tabs_list[v421];
        if v420[v421] then
            for v423 = 1, #v422.tables do
                local v424 = v422.tables[v423];
                if not v419[v424._name] then
                    for v425 = 1, #v424.elements do
                        local v426 = v424.elements[v425];
                        local l__type_0 = v426._type;
                        if l__type_0 < 6 then
                            if l__type_0 == 5 then
                                local v428 = v51.binded_keys[v426._name];
                                v418.keybinds[#v418.keybinds + 1] = {
                                    _name = v426._name, 
                                    _key = v428.key, 
                                    _mode = v428.mode
                                };
                            else
                                local l_value_0 = v426.value;
                                if l__type_0 == 4 then
                                    l_value_0 = l_value_0:to_hex();
                                end;
                                v418.menu[#v418.menu + 1] = {
                                    _tab = v422._name, 
                                    _table = v424._name, 
                                    _item = v426._name, 
                                    _value = l_value_0
                                };
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
    local v430 = json.stringify(v418);
    return (v163.execute(v430, 10));
end;
v51.load_config = function(v431)
    -- upvalues: v163 (ref), v51 (ref), l_color_0 (ref), v27 (ref)
    local v432 = v163.execute(v431, -10);
    local v433 = json.parse(v432);
    local l_author_0 = v433.author;
    local l_date_0 = v433.date;
    local l_menu_0 = v433.menu;
    local l_keybinds_0 = v433.keybinds;
    for v438 = 1, #l_menu_0 do
        local v439 = l_menu_0[v438];
        local v440 = v51.find(v439._tab, v439._table, v439._item, v51.get("tabs_selections"));
        if v440 then
            local l__value_0 = v439._value;
            if v440._type == 4 then
                l__value_0 = l_color_0(l__value_0);
                v27.clear(v51.color_picker.hue);
                v27.clear(v51.color_picker.saturation);
                v27.clear(v51.color_picker.value);
                v27.clear(v51.color_picker.alpha);
            end;
            v440.value = l__value_0;
        end;
    end;
    for v442 = 1, #l_keybinds_0 do
        local v443 = l_keybinds_0[v442];
        v51.binded_keys[v443._name].key = v443._key;
        v51.binded_keys[v443._name].mode = v443._mode;
    end;
    return l_author_0, l_date_0;
end;
v51.is_open = function()
    -- upvalues: v28 (ref)
    return v28.get_alpha() > 0;
end;
v51.create_tab = function(v444, v445, v446)
    -- upvalues: v51 (ref)
    local v447 = #v51.tabs_list + 1;
    if not v446 then
        v446 = false;
    end;
    if not v446 then
        v51.centered_tabs = v51.centered_tabs + 1;
    end;
    v51.tabs_list[v447] = {
        _name = v444, 
        _icon = v445, 
        tables = {}, 
        is_lower = v446
    };
    return v51.tabs_list[v447].tables;
end;
v51.create_table = function(v448, v449, v450, v451)
    local v452 = #v448 + 1;
    v448[v452] = {
        current_length = 0, 
        alpha = 0, 
        animate_name = 0, 
        animate_scroll = 0, 
        scroll_factor = 0, 
        start_scroll = false, 
        _name = v449, 
        is_right = v450 or false, 
        max_length = 10 + v451 * 40, 
        elements = {}
    };
    return v448[v452].elements;
end;
v51.create_checkbox = function(v453, v454, v455, v456)
    -- upvalues: v39 (ref)
    local v457 = v455 or false;
    local v458 = v456 == v39 or v456;
    local v459 = #v453 + 1;
    v453[v459] = {
        menu_size = 1, 
        _type = 1, 
        _name = v454, 
        value = v457, 
        is_visible = v458
    };
    return v453[v459];
end;
v51.create_slider = function(v460, v461, v462, v463, v464, v465, v466)
    local v467 = v464 or v462;
    local v468 = v465 or true;
    local v469 = #v460 + 1;
    v460[v469] = {
        menu_size = 1, 
        _type = 2, 
        _name = v461, 
        value = v467, 
        is_visible = v468, 
        extands = {
            min = v462, 
            max = v463, 
            values_names = v466
        }
    };
    return v460[v469];
end;
v51.create_list = function(v470, v471, v472, v473, v474, v475)
    local v476 = v473 or v472[1];
    if v474 and v476 == v472[1] then
        v476 = false;
    end;
    local v477 = v475 or true;
    local l_v476_0 = v476;
    if v474 then
        l_v476_0 = {};
        for v479 = 1, #v472 do
            l_v476_0[v479] = v476;
        end;
    end;
    local v480 = #v470 + 1;
    v470[v480] = {
        menu_size = 1, 
        _type = 3, 
        _name = v471, 
        value = l_v476_0, 
        is_visible = v477, 
        extands = {
            items = v472, 
            is_multi = v474
        }
    };
    return v470[v480];
end;
v51.create_color = function(v481, v482, v483, v484)
    -- upvalues: l_color_0 (ref)
    local v485 = v483 or l_color_0(255);
    local v486 = v484 or true;
    local v487 = #v481 + 1;
    v481[v487] = {
        menu_size = 1, 
        _type = 4, 
        _name = v482, 
        value = v485, 
        is_visible = v486, 
        extands = {
            default_color = v485:clone()
        }
    };
    return v481[v487];
end;
v51.create_keybind = function(v488, v489, v490, v491, v492)
    -- upvalues: v51 (ref), v39 (ref)
    local v493 = v490 or 27;
    local v494 = v492 or true;
    local v495 = v491 or false;
    v51.binded_keys[v489] = {
        value = false, 
        mode = "hold", 
        key = v493, 
        last_key = v39, 
        is_mode_disabled = v495
    };
    local v496 = #v488 + 1;
    v488[v496] = {
        menu_size = 1, 
        _type = 5, 
        _name = v489, 
        value = v51.binded_keys[v489], 
        is_visible = v494, 
        extands = {
            is_mode_disabled = v495
        }
    };
    return v488[v496];
end;
v51.create_button = function(v497, v498, v499, v500, v501)
    local v502 = v501 or true;
    local v503 = #v497 + 1;
    v497[v503] = {
        menu_size = 1, 
        _type = 6, 
        _name = v498, 
        is_visible = v502, 
        extands = {
            to_call = v499, 
            icon = v500
        }
    };
    return v497[v503];
end;
v51.create_input = function(v504, v505, v506, v507, v508)
    local v509 = v508 or true;
    local v510 = #v504 + 1;
    v504[v510] = {
        menu_size = 2, 
        _type = 7, 
        _name = v505, 
        value = v506 or "", 
        is_visible = v509, 
        extands = {
            callback = v507
        }
    };
    v504[v510].extands.item = v504[v510];
    return v504[v510];
end;
v51.create_text = function(v511, v512, v513, v514)
    local v515 = v514 or true;
    local v516 = #v511 + 1;
    v511[v516] = {
        menu_size = 0, 
        _type = 8, 
        _name = v512, 
        value = v513, 
        is_visible = v515
    };
    return v511[v516];
end;
v51.play_sound = function(v517)
    -- upvalues: v51 (ref), v154 (ref)
    if not v51.get("menu_sounds") then
        return;
    else
        if v517 == "click" then
            v154.play_sound("DigitalSounds/ui_click.wav", 0.3, 100, 0, 0);
        end;
        if v517 == "swap" then
            v154.play_sound("DigitalSounds/woosh.wav", 0.3, 100, 0, 0);
        end;
        return;
    end;
end;
v315 = function(v518, v519, v520, v521)
    -- upvalues: v111 (ref), l_vector_0 (ref), v51 (ref), v29 (ref), v36 (ref), v50 (ref), v39 (ref), l_color_0 (ref)
    local v522 = v111.mouse_position:is_in_bounds(v518, l_vector_0(300, 30)) and not v51.use_element;
    local v523 = v29.preform_animation(v36("%s_hovered_alpha", v521), v522 and 255 or 180) * v520;
    local v524 = v29.preform_animation(v36("%s_color", v521), v519.value and v50.colors.accent or v50.colors.outline);
    local v525 = v29.preform_animation(v36("%s_progress", v521), v519.value and 1 or 0);
    local v526 = v29.measure_text("theme::font", v39, v519._name);
    v50.render_text("theme::font", v518 + l_vector_0(0, 20 - v526.y / 2), v523 / 255, v39, v519._name);
    local v527 = l_vector_0(v518.x + 300 - 38, v518.y + 11);
    local v528 = l_vector_0(v518.x + 300, v518.y + 29);
    v29.shadow(v527, v528, v524:override(v520), 40, 0, 8);
    v29.rect(v527, v528, v524:override(v520), 8);
    v29.circle(l_vector_0(v518.x + 300 - 28 + 19 * v525, v518.y + 20), l_color_0(255, 255 * v520), 7, 0, 1);
    if v520 > 0 and v522 and v111.is_left_pressed and not v51.use_element and not v51.fix_press then
        v519.value = not v519.value;
        v51.fix_press = true;
        v51.play_sound("click");
    end;
end;
local function v547(v529, v530, v531, v532)
    -- upvalues: v111 (ref), l_vector_0 (ref), v51 (ref), v29 (ref), v36 (ref), v39 (ref), v50 (ref), v25 (ref), v30 (ref)
    local v533 = v111.mouse_position:is_in_bounds(v529, l_vector_0(300, 30)) and not v51.use_element;
    local v534 = v51.use_element == v532;
    local l_extands_0 = v530.extands;
    local v536 = v29.preform_animation(v36("%s_hovered_alpha", v532), (not not v533 or v534) and 255 or 180) * v531;
    local v537 = v29.measure_text("theme::font", v39, v530._name);
    v50.render_text("theme::font", v529 + l_vector_0(0, 20 - v537.y / 2), v536 / 255, v39, v530._name);
    local l_value_1 = v530.value;
    if l_extands_0.values_names and l_extands_0.values_names[l_value_1] then
        l_value_1 = l_extands_0.values_names[l_value_1];
    end;
    local v539 = v29.measure_text("theme::font", v39, l_value_1);
    local v540 = 100;
    local v541 = v529 + l_vector_0(300 - v540, 18);
    local v542 = v529 + l_vector_0(300, 22);
    v29.rect(v541, v542, v50.colors.outline:override(v531), 2);
    local v543 = v540 / (l_extands_0.max - l_extands_0.min);
    local v544 = v25.floor((v530.value - l_extands_0.min) * v543);
    if v544 > 0 then
        v50.render_accent(v529 + l_vector_0(300 - v540, 18), v529 + l_vector_0(300 - v540 + v544, 22), v531, 2);
    end;
    v50.render_text("theme::font", v529 + l_vector_0(300 - v539.x - v540 - 10, 20 - v539.y / 2), v536 / 255, v39, l_value_1);
    v29.circle(v529 + l_vector_0(300 - v540 + v544, 20), v50.colors.accent:override(v531), 2 + v536 / 255 * 6, 0, 1);
    if v531 > 0 and not v51.use_element then
        v541.y = v541.y - 5;
        if v111.mouse_position:is_in_bounds(v541, l_vector_0(v540, 14)) then
            if v111.is_left_pressed then
                v51.use_element = v532;
            end;
            if v30.is_virtual_key_pressed(17) then
                local v545 = v530.value + v25.clamp(common.get_mouse_wheel_delta(), -1, 1);
                temp_value = v25.clamp(v545, l_extands_0.min, l_extands_0.max);
                v530.value = temp_value;
            end;
        end;
    end;
    if v51.use_element == v532 then
        local v546 = l_extands_0.min + v25.to_int((v111.active_mouse_position.x - (v529.x + 300 - v540)) / v543);
        v530.value = v25.clamp(v546, l_extands_0.min, l_extands_0.max);
        if not v111.is_left_pressed then
            v51.use_element = v39;
        end;
    end;
end;
local function v576(v548, v549, v550, v551, v552)
    -- upvalues: v111 (ref), l_vector_0 (ref), v51 (ref), v29 (ref), v36 (ref), v39 (ref), v50 (ref), v25 (ref), v27 (ref), v38 (ref), l_color_0 (ref), v48 (ref)
    local v553 = v111.mouse_position:is_in_bounds(v548, l_vector_0(300, 40)) and not v51.use_element;
    local v554 = v51.use_element == v551;
    local v555 = v29.preform_animation(v36("%s_hovered_alpha", v551), (not not v553 or v554) and 1 or 0);
    local v556 = 0;
    local v557 = v29.measure_text("theme::font", v39, v549._name);
    v50.render_text("theme::font", v548 + l_vector_0(0, 20 - v557.y / 2), v25.max(180, 255 * v555) * v550 / 255, v39, v549._name);
    v557 = v549.value;
    if v549.extands.is_multi then
        new_value = {};
        for v558 = 1, #v549.extands.items do
            if v549.value[v558] then
                new_value[#new_value + 1] = v549.extands.items[v558];
            end;
        end;
        v557 = v27.concat(new_value, ",");
    end;
    if v557 == "" then
        v557 = "none";
    end;
    local v559 = v29.measure_text("theme::font", v39, v557);
    if v559.x > 100 then
        v557 = v38(v557, 0, 18);
        v557 = v36("%s...", v557);
        v559 = v29.measure_text("theme::font", v39, v557);
    end;
    v29.texture(v51.icons.menu.img, l_vector_0(v548.x + 300 - 30, v548.y), v51.icons.menu.size, l_color_0(255, 100):override(v550 * v555));
    v50.render_text("theme::font", v548 + l_vector_0(300 - v559.x - 40 * v555, 20 - v559.y / 2), v25.max(180, 255 * v555) * v550 / 255, v39, v557);
    v50.render_accent(v548 + l_vector_0(300 - 32 * v555, 10), v548 + l_vector_0(300 - 30 * v555, 30), v555, 1);
    for v560 = 1, #v549.extands.items do
        local v561 = v29.measure_text("theme::font", v39, v549.extands.items[v560]);
        if v556 < v561.x then
            v556 = v561.x;
        end;
    end;
    if v550 > 0 and v553 and v111.is_left_pressed and not v51.use_element then
        v51.use_element = v551;
        v51.play_sound("swap");
        v557 = #v549.extands.items * 40;
        v559 = v556 + 20 + 40;
        local v562 = v48.window(v36("lua::ui::window_%s", v551), v548 + l_vector_0(300 - v559, 40), l_vector_0(v559, v557));
        v562:register("should_draw", true);
        v562:register_render(function(v563)
            -- upvalues: l_vector_0 (ref), v25 (ref), v29 (ref), l_color_0 (ref), v50 (ref), v549 (ref), v36 (ref), v551 (ref), v39 (ref), v111 (ref), v51 (ref), v552 (ref)
            v563:fade(v563("should_draw") and 1 or 0);
            local v564 = v563._position + l_vector_0(-50 * v25.abs(v563._fade - 1), 0);
            v29.shadow(v564, v564 + v563._size, l_color_0(10, 200 * v563._fade), 70, 0, 10);
            v50.render_background(v564, v564 + v563._size, v563._fade, 10);
            for v565 = 1, #v549.extands.items do
                local v566 = v549.extands.items[v565];
                local v567 = v36("%s^%s", v551, v566);
                local v568 = v29.measure_text("theme::font", v39, v566);
                local v569 = v564 + l_vector_0(0, 40 * (v565 - 1));
                local v570 = l_vector_0(v563._size.x, 30);
                local v571 = v111.mouse_position:is_in_bounds(v569, v570);
                local v572 = v549.extands.is_multi and v549.value[v565] or v549.value == v566;
                local v573 = v29.preform_animation(v567, v572 and 1 or 0) * v563._fade;
                local v574 = v29.preform_animation(v36("%s_hover", v567), v571 and 1 or 0);
                local v575 = 40 * (v565 - 1) + 20;
                v50.render_text("theme::font", v564 + l_vector_0(10 + 30 * v573 + 10 * v574, v575 - v568.y / 2), v25.max(180, 255 * v574) * v563._fade / 255, v39, v566);
                v29.texture(v51.icons.check.img, l_vector_0(v564.x + 5, v564.y + 40 * (v565 - 1) + 5), v51.icons.check.size, l_color_0(255, 180):override(v573));
                if v563._fade > 0.9 and v571 and v111.is_left_pressed and not v51.fix_press then
                    v51.fix_press = true;
                    v51.play_sound("click");
                    if v549.extands.is_multi then
                        v549.value[v565] = not v549.value[v565];
                    else
                        v549.value = v566;
                    end;
                end;
            end;
            if not v111.mouse_position:is_in_bounds(v564, v563._size) and v111.is_left_pressed and v563._fade == 1 then
                v563:register("should_draw", false);
                v51.play_sound("swap");
            end;
            if v552._fade ~= 1 and v563("should_draw") then
                v563:register("should_draw", false);
                v51.play_sound("swap");
            end;
            if not v563("should_draw") and v563._fade == 0 then
                v563:delete();
                v51.use_element = v39;
            end;
        end, v36("lua::ui::window_%s::render", v551));
    end;
end;
local function v633(v577, v578, v579, v580, v581)
    -- upvalues: v111 (ref), l_vector_0 (ref), v51 (ref), v29 (ref), v36 (ref), v39 (ref), v50 (ref), l_color_0 (ref), v48 (ref), v25 (ref), v27 (ref)
    local v582 = v111.mouse_position:is_in_bounds(v577, l_vector_0(300, 40)) and not v51.use_element;
    local v583 = v51.use_element == v580;
    local v584 = v29.preform_animation(v36("%s_hovered_alpha", v580), (not not v582 or v583) and 1 or 0);
    local v585 = v29.measure_text("theme::font", v39, v578._name);
    v50.render_text("theme::font", v577 + l_vector_0(0, 20 - v585.y / 2), (180 + 74 * v584) * v579 / 255, v39, v578._name);
    v29.texture(v51.icons.color.img, l_vector_0(v577.x + 300 - 30, v577.y), v51.icons.color.size, l_color_0(255, 100):override(v579 * v584));
    v29.circle_outline(l_vector_0(v577.x + 300 - 10 - 40 * v584, v577.y + 20), v50.colors.outline:override(v579), 9, 0, 1);
    v29.circle(l_vector_0(v577.x + 300 - 10 - 40 * v584, v577.y + 20), v578.value:override(v579), 8, 0, 1);
    v50.render_accent(v577 + l_vector_0(300 - 32 * v584, 10), v577 + l_vector_0(300 - 30 * v584, 30), v584, 1);
    if v579 > 0 and v582 and v111.is_left_pressed and not v51.use_element then
        v51.use_element = v580;
        v51.play_sound("swap");
        v585 = 310;
        local v586 = 250;
        local v587 = v578.value:clone();
        if not v51.color_picker.hue[v580] then
            local l_hue_0 = v51.color_picker.hue;
            local l_saturation_0 = v51.color_picker.saturation;
            local l_value_2 = v51.color_picker.value;
            local v591, v592, v593 = v587:to_hsv();
            l_value_2[v580] = v593;
            l_saturation_0[v580] = v592;
            l_hue_0[v580] = v591;
        end;
        local v594 = v48.window(v36("lua::ui::window_%s", v580), v577 + l_vector_0(300 - v586, 30), l_vector_0(v586, v585));
        v594:register("should_draw", true);
        v594:register_render(function(v595)
            -- upvalues: l_vector_0 (ref), v25 (ref), v29 (ref), l_color_0 (ref), v50 (ref), v51 (ref), v580 (ref), v578 (ref), v111 (ref), v27 (ref), v581 (ref), v39 (ref)
            v595:fade(v595("should_draw") and 1 or 0);
            local v596 = v595._position + l_vector_0(-50 * v25.abs(v595._fade - 1), 0);
            v29.shadow(v596, v596 + v595._size, l_color_0(10, 200 * v595._fade), 70, 0, 10);
            v50.render_background(v596, v596 + v595._size, v595._fade, 10);
            v50.render_half_outline(v596, v596 + v595._size, v595._fade, 10, 1);
            local v597 = l_vector_0(v596.x + 10, v596.y + 250);
            for v598 = 1, 6 do
                v29.gradient(v597 + l_vector_0((v598 - 1) * 38.333333333333336, 0), v597 + l_vector_0(v598 * 38.333333333333336, 4), v51.color_picker.hue_colors[v598]:override(v595._fade), v51.color_picker.hue_colors[v598 + 1]:override(v595._fade), v51.color_picker.hue_colors[v598]:override(v595._fade), v51.color_picker.hue_colors[v598 + 1]:override(v595._fade));
            end;
            local v599 = l_color_0():as_hsv(v51.color_picker.hue[v580], 1, 1):override(v595._fade);
            v29.circle(v597 + l_vector_0(0, 2), v51.color_picker.hue_colors[1]:override(v595._fade), 2, 90, 0.5);
            v29.circle(v597 + l_vector_0(230, 2), v51.color_picker.hue_colors[1]:override(v595._fade), 2, 270, 0.5);
            v29.circle(v597 + l_vector_0(v51.color_picker.hue[v580] * 230, 2), v599, 6, 0, 1);
            local v600 = v578.value.a / 255;
            v29.gradient(v597 + l_vector_0(-2, 20), v597 + l_vector_0(232, 24), l_color_0(0, 0), v578.value:alpha_modulate(v595._fade * 255), l_color_0(0, 0), v578.value:alpha_modulate(v595._fade * 255), 3);
            local v601 = l_color_0(0, 255):lerp(v578.value:alpha_modulate(255), v600):override(v595._fade);
            v29.circle(v597 + l_vector_0(v600 * 230, 22), v601, 6, 0, 1);
            local v602 = l_color_0(0, 0, 0, 255 * v595._fade);
            local v603 = l_color_0(0, 0, 0, 0);
            local v604 = l_color_0(255, 255 * v595._fade);
            local v605 = v596 + l_vector_0(10, 10);
            v29.gradient(v605, v605 + l_vector_0(230, 230), v604, v599, v604, v599, 5);
            v29.gradient(v605, v605 + l_vector_0(230, 230), v603, v603, v602, v602, 5);
            local v606 = v605 + l_vector_0(230 * v51.color_picker.saturation[v580], 230 * (1 - v51.color_picker.value[v580]));
            v29.circle_outline(v606, l_color_0(230, 170 * v595._fade), 10, 0, 1);
            v29.circle(v606, v578.value:alpha_modulate(255 * v595._fade), 8, 0, 1);
            local v607 = not v51.color_picker.is_hue and not v51.color_picker.is_value_saturation and not v51.color_picker.is_alpha;
            local v608 = l_vector_0(v597.x, v597.y + 30);
            local v609 = l_vector_0(21, 21);
            v29.rect(v608, v608 + v609, l_color_0(10, 10, 30, 50 * v595._fade), 5);
            v29.text("theme::font", l_vector_0(11 + v597.x, v597.y + 41), l_color_0(255, 180 * v595._fade), "c", "+");
            local v610 = #v51.color_picker.saved_colors;
            if v111.is_left_pressed and v610 < 7 and v111.mouse_position:is_in_bounds(v608, v609) and v607 and not v51.fix_press then
                v51.fix_press = true;
                v51.color_picker.saved_colors[#v51.color_picker.saved_colors + 1] = v578.value:clone();
            end;
            if v111.is_right_pressed and v51.global_time + 1 < globals.realtime and v111.mouse_position:is_in_bounds(v608, v609) then
                local v611 = v578.extands.default_color:clone();
                local l_hue_1 = v51.color_picker.hue;
                local l_v580_0 = v580;
                local l_saturation_1 = v51.color_picker.saturation;
                local l_v580_1 = v580;
                local l_value_3 = v51.color_picker.value;
                local l_v580_2 = v580;
                local v618, v619, v620 = v611:to_hsv();
                l_value_3[l_v580_2] = v620;
                l_saturation_1[l_v580_1] = v619;
                l_hue_1[l_v580_0] = v618;
                v600 = v611.a / 255;
            end;
            for v621 = 1, v610 do
                local v622 = v51.color_picker.saved_colors[v621];
                if v622 then
                    local v623 = l_vector_0(40 + v597.x + (v621 - 1) * 30, v597.y + 41);
                    v29.circle_outline(v623, v50.colors.outline:override(v595._fade), 11, 0, 1);
                    v29.circle(v623, v622:override(v595._fade), 10, 0, 1);
                    if v111.mouse_position:is_in_bounds(v623 - l_vector_0(10, 10), l_vector_0(20, 20)) and v607 then
                        if v111.is_left_pressed and not v51.fix_press then
                            v51.fix_press = true;
                            local l_hue_2 = v51.color_picker.hue;
                            local l_v580_3 = v580;
                            local l_saturation_2 = v51.color_picker.saturation;
                            local l_v580_4 = v580;
                            local l_value_4 = v51.color_picker.value;
                            local l_v580_5 = v580;
                            local v630, v631, v632 = v622:to_hsv();
                            l_value_4[l_v580_5] = v632;
                            l_saturation_2[l_v580_4] = v631;
                            l_hue_2[l_v580_3] = v630;
                            v600 = v622.a / 255;
                        end;
                        if v111.is_right_pressed and v51.global_time + 0.5 < globals.realtime then
                            v51.global_time = globals.realtime;
                            v27.remove(v51.color_picker.saved_colors, v621);
                        end;
                    end;
                end;
            end;
            v608 = v111.mouse_position:is_in_bounds(v597, l_vector_0(230, 6));
            v609 = v111.mouse_position:is_in_bounds(v597 + l_vector_0(0, 20), l_vector_0(230, 6));
            v610 = v111.mouse_position:is_in_bounds(v605, l_vector_0(230, 230));
            if v595._fade == 1 and v111.is_left_pressed then
                if v607 then
                    if v608 then
                        v51.color_picker.is_hue = true;
                    end;
                    if v609 then
                        v51.color_picker.is_alpha = true;
                    end;
                    if v610 then
                        v51.color_picker.is_value_saturation = true;
                    end;
                end;
            else
                if v51.color_picker.is_hue then
                    v51.color_picker.is_hue = false;
                end;
                if v51.color_picker.is_value_saturation then
                    v51.color_picker.is_value_saturation = false;
                end;
                if v51.color_picker.is_alpha then
                    v51.color_picker.is_alpha = false;
                end;
            end;
            if v51.color_picker.is_value_saturation then
                v608 = l_vector_0(v111.active_mouse_position.x - v605.x, v111.active_mouse_position.y - v605.y);
                v608.x = v25.clamp(v608.x, 0, 230);
                v608.y = v25.clamp(v608.y, 0, 230);
                v51.color_picker.value[v580] = 1 - v608.y / 230;
                v51.color_picker.saturation[v580] = v608.x / 230;
            end;
            if v51.color_picker.is_hue then
                v608 = v111.active_mouse_position.x - v597.x;
                v608 = v25.clamp(v608, 0, 229);
                v51.color_picker.hue[v580] = v608 / 230;
            end;
            if v51.color_picker.is_alpha then
                v608 = v111.active_mouse_position.x - v597.x;
                v600 = v25.clamp(v608, 0, 230) / 230;
            end;
            v578.value = l_color_0():as_hsv(v51.color_picker.hue[v580], v51.color_picker.saturation[v580], v51.color_picker.value[v580], v600);
            if v607 and not v111.mouse_position:is_in_bounds(v596, v595._size) and v111.is_left_pressed and v595._fade == 1 then
                v595.should_draw = false;
                v51.play_sound("swap");
            end;
            if v581._fade ~= 1 and v595("should_draw") then
                v595.should_draw = false;
                v51.play_sound("swap");
            end;
            if not v595("should_draw") and v595._fade == 0 then
                v595:delete();
                v51.use_element = v39;
            end;
        end, v36("lua::ui::window_%s::render", v580));
    end;
end;
local function v665(v634, v635, v636, v637, v638)
    -- upvalues: v111 (ref), l_vector_0 (ref), v51 (ref), v29 (ref), v36 (ref), v39 (ref), v50 (ref), l_color_0 (ref), v25 (ref), v48 (ref), v49 (ref), l_pairs_0 (ref), v30 (ref)
    local v639 = v111.mouse_position:is_in_bounds(v634, l_vector_0(300, 40)) and not v51.use_element;
    local v640 = v51.use_element == v637;
    local v641 = v29.preform_animation(v36("%s_hovered_alpha", v637), (not not v639 or v640) and 1 or 0);
    local v642 = v29.measure_text("theme::font", v39, v635._name);
    v50.render_text("theme::font", v634 + l_vector_0(0, 20 - v642.y / 2), (180 + 74 * v641) * v636 / 255, v39, v635._name);
    v642 = v51.binded_keys[v635._name].key;
    local v643 = v51.virtual_keys[v642];
    local v644 = v635.extands.is_mode_disabled and "press" or v51.binded_keys[v635._name].mode;
    local v645 = v36("%s: %s", v644, v643);
    local v646 = v29.measure_text("theme::font", v39, v645);
    v29.texture(v51.icons.keys.img, l_vector_0(v634.x + 300 - 30, v634.y), v51.icons.keys.size, l_color_0(255, 100):override(v636 * v641));
    v50.render_accent(v634 + l_vector_0(300 - 32 * v641, 10), v634 + l_vector_0(300 - 30 * v641, 30), v641, 1);
    v50.render_text("theme::font", v634 + l_vector_0(300 - v646.x - 40 * v641, 20 - v646.y / 2), v25.max(180, 255 * v641) * v636 / 255, v39, v645);
    if v636 > 0 and v639 and v111.is_left_pressed and not v51.use_element then
        v51.use_element = v637;
        v51.play_sound("swap");
        v642 = 100;
        v643 = 150;
        v644 = v48.window(v36("lua::ui::window_%s", v637), v634 + l_vector_0(320 - v643, -v642 / 2), l_vector_0(v643, v642));
        v644:register("should_draw", true);
        v644:register_render(function(v647)
            -- upvalues: l_vector_0 (ref), v25 (ref), v29 (ref), l_color_0 (ref), v50 (ref), v49 (ref), v51 (ref), v635 (ref), v39 (ref), v111 (ref), v36 (ref), v637 (ref), l_pairs_0 (ref), v30 (ref), v638 (ref)
            v647:fade(v647.should_draw and 1 or 0);
            local v648 = v647._position + l_vector_0(-50 * v25.abs(v647._fade - 1), 0);
            v29.shadow(v648, v648 + v647._size, l_color_0(10, 170 * v647._fade), 30, 0, 10);
            v50.render_background(v648, v648 + v647._size, v647._fade, 10);
            local v649 = not v49.keyboard_handle;
            local l_key_0 = v51.binded_keys[v635._name].key;
            local v651 = v51.virtual_keys[l_key_0];
            local v652 = v29.measure_text("theme::font", v39, v651);
            local v653 = v648 + l_vector_0(v647._size.x / 2, 30);
            local v654 = v111.mouse_position:is_in_bounds(v653 - v652 / 2, v652);
            local v655 = v649 and v51.is_binding_new_key or v51.keybind_data ~= v39;
            local v656 = v29.preform_animation(v36("%s_hover_animation", v637), (not not v654 or v655) and 1 or 0);
            local v657 = v29.preform_animation(v36("%s_binding_color", v637), v655 and l_color_0(255, 10, 10, 255) or v50.colors.accent);
            v29.shadow(v653, v653 + l_vector_0(1, 1), v657:override(v647._fade), 40 + 30 * v656);
            v50.render_text("theme::font", v653, v647._fade, "c", v651);
            if v647._fade == 1 and v654 and not v655 and v111.is_left_pressed then
                v51.play_sound("click");
                if v649 then
                    v51.is_binding_new_key = true;
                else
                    v51.is_using_keyboard = true;
                    v51.keybind_data = {
                        _name = v635._name
                    };
                end;
            end;
            v656 = v649 and v51.is_binding_new_key or v51.is_using_keyboard and v51.keybind_data and v51.keybind_data._name == v635._name;
            if not v654 and v656 and v111.is_left_pressed then
                if v649 then
                    v51.is_binding_new_key = false;
                else
                    v51.is_using_keyboard = false;
                    v51.keybind_data = v39;
                end;
            end;
            if v649 and v51.is_binding_new_key then
                for v658, _ in l_pairs_0(v51.virtual_keys) do
                    if v30.is_virtual_key_pressed(v658) then
                        v51.is_binding_new_key = false;
                        v51.binded_keys[v635._name].key = v658;
                    end;
                end;
                if v30.is_virtual_key_pressed(2) then
                    v51.is_binding_new_key = false;
                    v51.binded_keys[v635._name].key = 27;
                end;
            end;
            if not v649 and v51.keybind_data and v30.is_virtual_key_pressed(2) then
                v51.is_using_keyboard = false;
                v51.keybind_data = v39;
                v51.binded_keys[v635._name].key = 27;
            end;
            if not v635.extands.is_mode_disabled then
                v657 = {
                    [1] = "hold", 
                    [2] = "toggle", 
                    [3] = "always"
                };
                local v660 = 0;
                for v661 = 1, 3 do
                    local v662 = v657[v661];
                    local v663 = v29.measure_text("theme::font", v39, v662);
                    local v664 = v648 + l_vector_0(10 + v660, 60);
                    if v51.binded_keys[v635._name].mode == v662 then
                        v50.render_accent(v664 + l_vector_0(2, 18), v664 + l_vector_0(v663.x - 2, 22), v647._fade, 2);
                    end;
                    v50.render_text("theme::font", v664, v647._fade, v39, v662);
                    if v647._fade == 1 and v51.binded_keys[v635._name].mode ~= v662 and v111.mouse_position:is_in_bounds(v664, v663) and v111.is_left_pressed then
                        v51.play_sound("click");
                        v51.binded_keys[v635._name].mode = v662;
                    end;
                    v660 = v660 + v663.x + 10;
                end;
            end;
            if not v111.mouse_position:is_in_bounds(v648, v647._size) and v111.is_left_pressed and v647._fade == 1 then
                v647.should_draw = false;
                v51.play_sound("swap");
            end;
            if v638._fade ~= 1 and v647("should_draw") then
                v647.should_draw = false;
                v51.play_sound("swap");
            end;
            if not v647.should_draw and v647._fade == 0 then
                v647:delete();
                v51.use_element = v39;
                if v656 then
                    v51.is_binding_new_key = false;
                    v51.is_using_keyboard = false;
                    v51.keybind_data = v39;
                end;
            end;
        end, v36("lua::ui::window_%s::render", v637));
    end;
end;
local function v674(v666, v667, v668, v669)
    -- upvalues: v111 (ref), l_vector_0 (ref), v51 (ref), v29 (ref), v36 (ref), v39 (ref), l_color_0 (ref), v50 (ref)
    local v670 = v111.mouse_position:is_in_bounds(v666, l_vector_0(300, 40)) and not v51.use_element;
    local v671 = v29.preform_animation(v36("%s_hovered_alpha", v669), v670 and 1 or 0);
    local _ = v29.preform_animation(v36("%s_active_alpha", v669), 20);
    local v673 = v29.measure_text("theme::font", v39, v667._name);
    v29.text("theme::font", v666 + l_vector_0(0, 20 - v673.y / 2), l_color_0(255, (180 + 74 * v671) * v668), v39, v667._name);
    v29.texture(v667.extands.icon.img, l_vector_0(v666.x + 300 - 30, v666.y), v667.extands.icon.size, l_color_0(255, 100):override(v668 * v671));
    v50.render_accent(v666 + l_vector_0(300 - 32 * v671, 10), v666 + l_vector_0(300 - 30 * v671, 30), v671, 1);
    if v670 and v111.is_left_pressed and not v51.fix_press then
        v51.fix_press = true;
        v29.animation_cache[v36("%s_active_alpha", v669)] = 255;
        if v667.extands.to_call then
            v667.extands.to_call();
        end;
    end;
end;
local function v686(v675, v676, v677, v678)
    -- upvalues: v111 (ref), l_vector_0 (ref), v51 (ref), v29 (ref), v36 (ref), v39 (ref), l_color_0 (ref), v25 (ref), v50 (ref), v30 (ref)
    local v679 = v111.mouse_position:is_in_bounds(v675, l_vector_0(300, 60)) and not v51.use_element;
    local v680 = v51.use_element == v678;
    local v681 = v29.preform_animation(v36("%s_hovered_alpha", v678), (not not v679 or v680) and 255 or 180);
    local v682 = v29.measure_text("theme::font", v39, v676._name);
    v29.text("theme::font", v675 + l_vector_0(0, 20 - v682.y / 2), l_color_0(255, v681 * v677), v39, v676._name);
    local v683 = v29.preform_animation(v36("%s_used", v678), v680 and 1 or 0);
    local v684 = v29.measure_text("theme::font", v39, v676.value);
    v29.shadow(v675 + l_vector_0(20, 55), v675 + l_vector_0(20 + v684.x, 56), l_color_0(255, 10, 10, 255 * v683), 70);
    v29.text("theme::font", v675 + l_vector_0(20, 55 - v684.y / 2), l_color_0(255, v681 * v677), v39, v676.value);
    if v676.value == "" and not v680 then
        v29.text("theme::font", v675 + l_vector_0(20, 50), l_color_0(255, v681 * v677 * 0.5), v39, "Press here to type");
    end;
    if v683 > 0 then
        local v685 = v25.abs(v25.sin(globals.realtime * 2));
        v50.render_accent(v675 + l_vector_0(22 + v684.x, 47), v675 + l_vector_0(24 + v684.x, 63), v683 * v685, 1);
    end;
    v683 = v111.mouse_position:is_in_bounds(v675 + l_vector_0(0, 40), l_vector_0(300, 30));
    if v676.is_visible and v677 > 0 and v683 and not v51.use_element and v111.is_left_pressed then
        v51.use_element = v678;
        v51.is_using_keyboard = true;
        v51.keyboard_data = v676.extands;
    end;
    if v680 and (v30.is_virtual_key_pressed(27) or v30.is_virtual_key_pressed(13) or not v683 and v111.is_left_pressed or not v676.is_visible or v677 == 0) then
        v51.use_element = v39;
        v51.is_using_keyboard = false;
        v51.keyboard_data = v39;
    end;
end;
local function v693(v687, v688, v689, _)
    -- upvalues: v29 (ref), v39 (ref), l_vector_0 (ref), l_color_0 (ref)
    local v691 = v29.measure_text("theme::font", v39, v688.value);
    local v692 = v688.menu_size * 40 / 2;
    v29.text("theme::font", v687 + l_vector_0(0, v692 - v691.y / 2), l_color_0(255, 255 * v689), v39, v688.value);
end;
local v694 = {
    [1] = v315, 
    [2] = v547, 
    [3] = v576, 
    [4] = v633, 
    [5] = v665, 
    [6] = v674, 
    [7] = v686, 
    [8] = v693
};
do
    local l_v694_0 = v694;
    v51.render_main_window = function(v696)
        -- upvalues: v28 (ref), v111 (ref), v51 (ref), v50 (ref), v29 (ref), l_vector_0 (ref), l_color_0 (ref), v36 (ref), v25 (ref), v39 (ref), v30 (ref), v26 (ref), l_v694_0 (ref)
        v696:fade(v28.get_alpha());
        if v696._fade == 0 then
            return;
        else
            if not v111.is_left_pressed then
                v51.fix_press = false;
            end;
            local v697 = v696._position + v696._size;
            v50.render_background(v696._position, v697, v696._fade, 18);
            v29.push_clip_rect(v696._position, v697, true);
            v29.texture(v51.icons.cloud.img, l_vector_0(v696._position.x + 15, v696._position.y + 14), v51.icons.cloud.size, l_color_0(255, 180 * v696._fade));
            local v698 = v111.is_anything_moving() and 0 or 1;
            local v699 = {
                [1] = l_vector_0(v696._position.x + 90, v696._position.y + 20), 
                [2] = l_vector_0(v696._position.x + 440, v696._position.y + 20)
            };
            local v700 = #v51.tabs_list;
            local v701 = v696._position.y + v696._size.y / 2 - (v51.centered_tabs * 60 - 20) / 2;
            for v702 = 1, v700 do
                local v703 = v51.tabs_list[v702];
                local v704 = v36("ui::menu::tab_%s", v703._name);
                assert(v703, v36("Failed to index %s", v704));
                local v705 = v51.active_tab == v702;
                local v706 = nil;
                if not v703.is_lower then
                    v706 = l_vector_0(v696._position.x + 15 * v696._fade, v701 + (v702 - 1) * 60);
                else
                    v706 = l_vector_0(v696._position.x + 15 * v696._fade, v696._position.y + v696._size.y - 15 - v703._icon.size.y);
                end;
                local v707 = v29.preform_animation(v704, v705 and v698 or 0) * v696._fade;
                v50.render_accent(v706 + l_vector_0(45, 1), v706 + l_vector_0(49, 1 + v703._icon.size.y * v707), v707, 2);
                v29.texture(v703._icon.img, v706, v703._icon.size, l_color_0(255):override(v25.max(0.4, v707 - 0.2) * v696._fade));
                if v111.is_left_pressed and v111.mouse_position:is_in_bounds(v706, v703._icon.size) and v51.active_tab ~= v702 then
                    v51.active_tab = v702;
                    v51.play_sound("swap");
                end;
                if v707 > 0 then
                    local v708 = v25.abs(v707 - 1);
                    local v709 = {
                        [1] = 0, 
                        [2] = 0
                    };
                    for v710 = 1, #v703.tables do
                        local v711 = v703.tables[v710];
                        local v712 = v36("%s::table_%s", v704, v711._name);
                        assert(v711, v36("Failed to index %s", v712));
                        local v713 = v29.get_animation_value(v712) * v707;
                        local v714 = v711.is_right and 2 or 1;
                        local v715 = l_vector_0(v699[v714].x, v699[v714].y + v709[v714] - 50 * v708);
                        local v716 = v25.min(v711.max_length, v711.current_length);
                        local v717 = l_vector_0(v715.x + 320, v715.y + v716);
                        local v718 = v111.mouse_position:is_in_bounds(v715, l_vector_0(320, v716));
                        if v718 then
                            v51.hovered_table = v712;
                        elseif not v718 and v51.hovered_table == v712 then
                            v51.hovered_table = "";
                        end;
                        local v719 = 1;
                        if v51.get("menu_group_names") and v713 > 0 and not v51.use_element and v51.hovered_table ~= "" then
                            if v51.hovered_table ~= v712 then
                                v719 = 0.2;
                                v711.animate_name = v29.do_animation(v711.animate_name, 0);
                            else
                                v711.animate_name = v29.do_animation(v711.animate_name, 1);
                            end;
                        else
                            v711.animate_name = v29.do_animation(v711.animate_name, 0);
                        end;
                        if v711.animate_name > 0 then
                            v29.text("theme::font", v715 + l_vector_0(30, -18), l_color_0(255, 180 * v713 * v711.animate_name), v39, v711._name);
                        end;
                        local v720 = v711.start_scroll and v718;
                        v50.render_half_outline(v715, v717, v713);
                        if not v51.use_element and v720 and not v30.is_virtual_key_pressed(17) then
                            v711.scroll_factor = v711.scroll_factor + common.get_mouse_wheel_delta() * 20;
                            v711.scroll_factor = v25.clamp(v711.scroll_factor, -v711.current_length + v711.max_length, 0);
                        end;
                        if not v711.start_scroll then
                            v711.scroll_factor = 0;
                        end;
                        local v721 = v29.preform_animation(v36("%s_scrolldown", v712), v711.scroll_factor, v39);
                        if v711.start_scroll then
                            local v722 = (v717.y - v715.y) / v711.current_length;
                            local v723 = v711.max_length * v722;
                            local v724 = v25.abs(v721) * v722;
                            v50.render_accent(v715 + l_vector_0(0, v724), v715 + l_vector_0(4, v724 + v723), v713, 2);
                        else
                            v50.render_accent(v715, l_vector_0(v715.x + 4, v717.y), v713, 2);
                        end;
                        local v725 = 5;
                        v29.push_clip_rect(v715, v717, true);
                        for v726 = 1, #v711.elements do
                            local v727 = v711.elements[v726];
                            local v728 = v36("%s::element_%s", v712, v727._name);
                            assert(v727, v36("Failed to index %s", v728));
                            local v729 = l_vector_0(v715.x + 10, v715.y + v725 + v721);
                            if v727._type == 8 and v727.menu_size == 0 then
                                v727.value = v26.wrap_text(v727.value, 300, "theme::font");
                                local v730 = v29.measure_text("theme::font", v39, v727.value);
                                v727.menu_size = v25.ceil(v730.y / 40);
                            end;
                            local v731 = v727.menu_size * 40;
                            if v729:is_in_bounds(l_vector_0(v715.x, v715.y), l_vector_0(320, v716 - v731)) then
                                local _ = v727.is_visible;
                            end;
                            local v733 = v29.preform_animation(v36("%s_alpha", v728), v727.is_visible and 1 or 0);
                            local v734 = v729:is_in_bounds(l_vector_0(v715.x, v715.y), l_vector_0(320, v716 - v731));
                            local v735 = v29.preform_animation(v36("%s_alpha_in_table", v728), (v734 and 1 or 0) * v713) * v733;
                            if v735 > 0 then
                                l_v694_0[v727._type](v729, v727, v735, v728, v696);
                            end;
                            v725 = v725 + v731 * v733;
                        end;
                        v29.pop_clip_rect();
                        v725 = v725 + 5;
                        v711.start_scroll = v711.max_length < v725;
                        v29.preform_animation(v712, (v725 > 20 and 1 or 0) * v719);
                        v711.current_length = v29.do_animation(v711.current_length, v725, 100);
                        v709[v714] = v709[v714] + (v716 + 20) * (v713 ~= 0 and 1 or 0);
                    end;
                end;
            end;
            v29.pop_clip_rect();
            v696:override_position(l_vector_0(70, 70));
            return;
        end;
    end;
    v51.handle_keybinds = function()
        -- upvalues: l_pairs_0 (ref), v51 (ref), v30 (ref), v39 (ref), l_error_0 (ref), v36 (ref)
        for v736, v737 in l_pairs_0(v51.binded_keys) do
            if v737.key == 27 then
                v737.value = false;
            elseif v737.mode == "hold" then
                v737.value = v30.is_virtual_key_pressed(v737.key);
            elseif v737.mode == "toggle" then
                if v737.last_key == v39 and v30.is_virtual_key_pressed(v737.key) then
                    v737.last_key = v737.key;
                    v737.value = not v737.value;
                end;
                if v737.last_key ~= v39 and not v30.is_virtual_key_pressed(v737.key) then
                    v737.last_key = v39;
                end;
            elseif v737.mode == "always" then
                v737.value = true;
            else
                l_error_0(v36("Failed to find mode for bind %s", v736));
            end;
        end;
    end;
end;
v51.keyboard_interact = function(_, v739, v740)
    -- upvalues: v51 (ref), v33 (ref), v26 (ref), v39 (ref), v30 (ref)
    if not v51.is_using_keyboard then
        return;
    else
        local v741 = v33.cast("keybaord_low_level_hook_t*", v740);
        if v739 ~= 256 then
            return;
        else
            local l_vkCode_0 = v741.vkCode;
            if v51.keyboard_data and l_vkCode_0 == 8 and v51.keyboard_data.item.value ~= "" then
                v51.keyboard_data.item.value = v26.remove_last_char(v51.keyboard_data.item.value);
                v51.keyboard_data.callback(v51.keyboard_data.item.value);
                return true;
            elseif v51.invalid_vk[l_vkCode_0] then
                return;
            elseif v51.keybind_data and v51.virtual_keys[l_vkCode_0] then
                v51.binded_keys[v51.keybind_data._name].key = l_vkCode_0;
                v51.keybind_data = v39;
                v51.is_using_keyboard = false;
                return true;
            else
                local v743 = v33.new("BYTE[256]");
                v33.C.GetKeyboardState(v743);
                local v744 = v33.C.GetKeyboardLayout(0);
                local v745 = v33.new("wchar_t[3]");
                local v746 = v33.C.ToUnicodeEx(l_vkCode_0, v741.scanCode, v743, v745, 3, 0, v744);
                v745[v746] = 0;
                if v746 > 0 then
                    local v747 = v30.wide_char_to_multi_byte_string(v745);
                    if v51.keyboard_data then
                        if v51.keyboard_data.item.value == v39 then
                            v51.keyboard_data.item.value = "";
                        end;
                        v51.keyboard_data.item.value = v51.keyboard_data.item.value .. v747;
                        v51.keyboard_data.callback(v51.keyboard_data.item.value);
                    end;
                    return true;
                else
                    return;
                end;
            end;
        end;
    end;
end;
v51.mouse_interact = function()
    -- upvalues: v51 (ref)
    if v51.is_open() then
        return false;
    else
        return;
    end;
end;
v51.initialize_icons = function()
    -- upvalues: l_vector_0 (ref), v51 (ref), v31 (ref)
    local v748 = l_vector_0(40, 40);
    local v749 = l_vector_0(30, 30);
    local _ = l_vector_0(64, 64);
    v51.icons.cloud = v31.load_icon("cloud.png", v748);
    v51.icons.home = v31.load_icon("home.png", v748);
    v51.icons.anti_aim = v31.load_icon("rotate.png", v748);
    v51.icons.visuals = v31.load_icon("sun.png", v748);
    v51.icons.indicators = v31.load_icon("data.png", v748);
    v51.icons.misc = v31.load_icon("tuning.png", v748);
    v51.icons.search = v31.load_icon("search.png", v748);
    v51.icons.check = v31.load_icon("check.png", v749);
    v51.icons.open_check = v31.load_icon("check.png", v748);
    v51.icons.menu = v31.load_icon("check_list.png", v748);
    v51.icons.color = v31.load_icon("color.png", v748);
    v51.icons.keys = v31.load_icon("keyboard.png", v748);
    v51.icons.reset = v31.load_icon("rotate.png", v748);
    v51.icons.error = v31.load_icon("warning.png", v748);
    v51.icons.save = v31.load_icon("save.png", v748);
    v51.icons.load = v31.load_icon("load.png", v748);
    v51.icons.keybinds = v31.load_icon("keyboard.png", v749);
    v51.icons.watermark = v31.load_icon("cloud.png", v749);
    v51.icons.warning = v31.load_icon("warning.png", v749);
    v51.icons.hit = v31.load_icon("check.png", v749);
    v51.icons.miss = v31.load_icon("close.png", v749);
    v51.icons.health = v31.load_icon("health.png", v749);
    v51.icons.armor = v31.load_icon("armor.png", v749);
    v51.icons.headshot = v31.load_icon("headshot.svg", l_vector_0(20, 20));
    v51.icons.arrow = v31.load_icon("arrow.png", v749);
    v51.icons.manual = v31.load_icon("arrow.png", l_vector_0(20, 20));
    v51.icons.bullet = v31.load_icon("bullet.png", v749);
    v51.icons.blind = v31.load_icon("blind.png", v749);
    v51.icons.radar = v31.load_icon("radar.png", v749);
    v51.icons.unk_rotate = v31.load_icon("unk_rotate.png", v749);
    v51.icons.location = v31.load_icon("location.png", v749);
    return true;
end;
v51.initialize_elements = function()
    -- upvalues: v51 (ref), v36 (ref), v46 (ref), l_color_0 (ref), v30 (ref), v64 (ref), v29 (ref), v311 (ref), v154 (ref), v26 (ref), v49 (ref), v39 (ref), v31 (ref), v27 (ref), v57 (ref), v37 (ref), v50 (ref), v25 (ref)
    local v751 = v51.create_tab("Home", v51.icons.home);
    local v752 = v51.create_tab("Anti aim", v51.icons.anti_aim);
    local v753 = v51.create_tab("Visuals", v51.icons.visuals);
    local v754 = v51.create_tab("Indicators", v51.icons.indicators);
    local v755 = v51.create_tab("Misc", v51.icons.misc);
    local v756 = v51.create_tab("Search", v51.icons.search, true);
    local v757 = v51.create_table(v751, "Welcome", false, 5);
    v51.create_text(v757, "Welcome text", v36("Welcome back %s", common.get_username()));
    v51.create_text(v757, "pad1", " ");
    v51.create_text(v757, "Update", v36("Last update was %s", v46));
    local v758 = v51.create_table(v751, "Theme", false, 5);
    v51.new("theme_accent", v51.create_color, v758, "Theme color", l_color_0(150, 150, 255, 255));
    v51.new("theme_background", v51.create_color, v758, "Background color", l_color_0(10, 10, 30, 100));
    v51.new("menu_sounds", v51.create_checkbox, v758, "Menu sounds", true);
    v51.new("menu_group_names", v51.create_checkbox, v758, "Menu group names", true);
    v51.new("animation_speed", v51.create_slider, v758, "Animation speed", 1, 20, 12);
    local v759 = v51.create_table(v751, "Script", false, 4);
    v51.create_text(v759, "Resert explained", "If you experience some fps drops, \nyou can reset render cache or change performance mode");
    v51.new("reset_render", v51.create_button, v759, "Reset render cache", function()
        -- upvalues: v30 (ref), v64 (ref), v29 (ref), v311 (ref), v51 (ref), v154 (ref)
        v30.execute_after(3, function()
            -- upvalues: v64 (ref), v29 (ref)
            v64.clear_killfeed();
            v29.clear_cache();
        end);
        v311.add("Resetting render cache in 3 seconds", v51.icons.reset);
        v154.play_sound("DigitalSounds/error.wav", 1, 100, 0, 0);
    end, v51.icons.reset);
    v51.new("reset_render", v51.create_button, v759, "Switch performance mode", function()
        -- upvalues: v30 (ref), v29 (ref), v154 (ref), v311 (ref), v51 (ref)
        v30.execute_after(3, function()
            -- upvalues: v29 (ref), v154 (ref)
            v29.switch_preformance();
            v29.clear_cache();
            v154.play_sound("DigitalSounds/menu_load.wav", 1, 100, 0, 0);
        end);
        v311.add("Reloading performance mode in 3 seconds", v51.icons.reset);
        v154.play_sound("DigitalSounds/fast_press.wav", 1, 100, 0, 0);
    end, v51.icons.reset);
    v51.create_text(v759, "Safe mode explained", "Disabling Lua\226\128\153s safe mode can slightly improve performance, but it increases the risk of game crashes. Use with caution.");
    v51.create_text(v759, "Safe mode state", v26.format("Safe mode is %s", v49.safe_mode and "on" or "off"));
    v51.new("switch_safe_mode", v51.create_button, v759, "Switch safe mode", function()
        -- upvalues: v49 (ref), v311 (ref), v36 (ref), v51 (ref), v154 (ref), v30 (ref)
        local v760 = not v49.safe_mode;
        db._DigitalDreams_SafeModeHook = {
            is = v760
        };
        v311.add(v36("Switching safe mode mode in 3 seconds. new state %s", tostring(v760)), v51.icons.reset);
        v154.play_sound("DigitalSounds/fast_press.wav", 1, 100, 0, 0);
        v30.execute_after(3, function()
            common.reload_script();
        end);
    end, v51.icons.reset);
    local v761 = v51.create_table(v751, "Configs", true, 10);
    local function v766(v762)
        -- upvalues: v39 (ref), v311 (ref), v51 (ref), v154 (ref), v36 (ref)
        if v762 == v39 or v762 == "?" then
            v311.add("Invalid or empty config", v51.icons.error);
            v154.play_sound("physics/glass/glass_cup_break2.wav", 1, 100, 0, 0);
            return;
        else
            local v763, v764 = v51.load_config(v762);
            local v765 = v36("Loaded config by %s. Last update %s", v763, v764);
            v311.add(v765, v51.icons.load);
            v154.play_sound("DigitalSounds/fast_press.wav", 1, 100, 0, 0);
            return;
        end;
    end;
    do
        local l_v766_0 = v766;
        v51.new("load_default", v51.create_button, v761, "Load default config", function()
            -- upvalues: l_v766_0 (ref), v31 (ref)
            l_v766_0(network.get(v31.default_config));
        end, v51.icons.load);
        v51.new("load_autosave", v51.create_button, v761, "Load last settings", function()
            -- upvalues: l_v766_0 (ref), v31 (ref), v36 (ref)
            l_v766_0(v31.read(v36("csgo\\DigitalDreams\\Configs\\%s.digital", "AutoSave")));
        end, v51.icons.load);
        v51.new("configs_selection", v51.create_list, v761, "Select config", {
            [1] = "Config1", 
            [2] = "Config2", 
            [3] = "Config3", 
            [4] = "Config4", 
            [5] = "Config5", 
            [6] = "Config6", 
            [7] = "Config7", 
            [8] = "Config8"
        });
        v51.new("tabs_selections", v51.create_list, v761, "Select tabs", {
            [1] = "Home", 
            [2] = "Anti aim", 
            [3] = "Visuals", 
            [4] = "Indicators", 
            [5] = "Misc"
        }, true, true);
        v51.new("save_config", v51.create_button, v761, "Save config", function()
            -- upvalues: v51 (ref), v31 (ref), v36 (ref), v311 (ref), v154 (ref)
            local v768 = v51.get_config();
            if not v31.write(v36("csgo\\DigitalDreams\\Configs\\%s.digital", v51.get("configs_selection")), v768) then
                v311.add("Failed to save config", v51.icons.error);
                v154.play_sound("physics/glass/glass_cup_break2.wav", 1, 100, 0, 0);
                return;
            else
                v311.add("Config saved", v51.icons.save);
                v154.play_sound("DigitalSounds/fast_press.wav", 1, 100, 0, 0);
                return;
            end;
        end, v51.icons.save);
        v51.new("load_config", v51.create_button, v761, "Load config", function()
            -- upvalues: v51 (ref), l_v766_0 (ref), v31 (ref), v36 (ref)
            local v769 = v51.get("configs_selection");
            l_v766_0(v31.read(v36("csgo\\DigitalDreams\\Configs\\%s.digital", v769)));
        end, v51.icons.load);
    end;
    v757 = v51.create_table(v752, "Main", false, 6);
    v51.new("override_anti_aim", v51.create_checkbox, v757, "Override anti aim");
    v51.new("override_pitch", v51.create_checkbox, v757, "Pitch down");
    v51.new("override_yaw", v51.create_list, v757, "Yaw base", {
        [1] = "None", 
        [2] = "Local view", 
        [3] = "At target"
    });
    v51.new("at_target_in_air", v51.create_checkbox, v757, "At target in air");
    v758 = v51.create_table(v752, "Modes", false, 3);
    v51.new("anti_aim_mode", v51.create_list, v758, "Select anti aim mode", {
        [1] = "Auto presets", 
        [2] = "Default builder"
    });
    v51.new("select_preset", v51.create_list, v758, "Select preset", {
        [1] = "Static", 
        [2] = "Old Center", 
        [3] = "Break"
    });
    v51.new("enable_preset_freestand", v51.create_checkbox, v758, "Enable desync freestand");
    v759 = v51.create_table(v752, "Misc", false, 5);
    v51.new("enable_anti_aim_misc", v51.create_list, v759, "Select misc settings", {
        [1] = "Allow on use", 
        [2] = "Anti bruteforce", 
        [3] = "Break lc in air", 
        [4] = "Disable on round-end", 
        [5] = "Static on manuals", 
        [6] = "Static on warmup", 
        [7] = "Override desync freestand"
    }, v39, true);
    v51.new("resert_anti_bruteforce", v51.create_button, v759, "Reset anti bruteforce", function()
        -- upvalues: v27 (ref), v57 (ref), v311 (ref), v51 (ref), v154 (ref)
        v27.clear(v57.presets);
        v57.misses = 0;
        v311.add("Reset anti bruteforce data", v51.icons.reset);
        v154.play_sound("DigitalSounds/error.wav", 1, 100, 0, 0);
    end, v51.icons.reset);
    v51.new("invert_freestand", v51.create_checkbox, v759, "Invert desync freestand");
    v51.new("limit_freestand", v51.create_checkbox, v759, "Limit freestand calculations");
    v51.new("edge_yaw", v51.create_keybind, v759, "Edge yaw");
    v51.new("defensive_snap", v51.create_keybind, v759, "Defensive snap");
    v51.new("defensive_pitch", v51.create_slider, v759, "Delay pitch", 1, 20, 8);
    v51.new("defensive_yaw", v51.create_slider, v759, "Delay yaw", 1, 20, 4);
    v51.new("defensive_settings", v51.create_list, v759, "Defensive addons", {
        [1] = "Linear pitch", 
        [2] = "Linear yaw", 
        [3] = "Wide angle"
    }, None, true);
    v51.new("manual_left", v51.create_keybind, v759, "Manual left", v39, true);
    v51.new("manual_right", v51.create_keybind, v759, "Manual right", v39, true);
    v51.new("manual_back", v51.create_keybind, v759, "Manual back", v39, true);
    v757 = v51.create_table(v752, "States", true, 4);
    v51.new("default_states", v51.create_list, v757, "Select state", v51.local_states);
    for v770 = 1, #v51.local_states do
        local v771 = v37(v51.local_states[v770]);
        local v772 = v771 == "global";
        v51.new(v36("enable_state_%s", v771), v51.create_checkbox, v757, v36("Enable %s", v771), v772, false);
        v51.new(v36("select_sub_state_%s", v771), v51.create_list, v757, v36("Select %s sub state", v771), v51.sub_states);
        for v773 = 1, 3 do
            local v774 = v37(v51.sub_states[v773]);
            local v775 = v774 == "regular";
            local v776 = v36("%s_%s", v771, v774);
            v51.new(v36("enable_%s", v776), v51.create_checkbox, v757, v36("Override %s on %s", v774, v771), v775, false);
            local v777 = v51.create_table(v752, v36("%s on %s", v774, v771), true, 9);
            v51.new(v36("yaw_left_%s", v776), v51.create_slider, v777, "Yaw left", -180, 180, 0);
            v51.new(v36("yaw_right_%s", v776), v51.create_slider, v777, "Yaw right", -180, 180, 0);
            v51.new(v36("yaw_modifier_%s", v776), v51.create_list, v777, "Yaw modifier", {
                [1] = "Disabled", 
                [2] = "Center", 
                [3] = "Offset", 
                [4] = "Random", 
                [5] = "Spin", 
                [6] = "3-Way", 
                [7] = "5-Way", 
                [8] = "Devided delta"
            });
            v51.new(v36("yaw_modifier_delta_%s", v776), v51.create_slider, v777, "Modifier degree", -180, 180, 0);
            v51.new(v36("yaw_modifier_mode_%s", v776), v51.create_slider, v777, "Modifier mode", 3, 6, 3);
            v51.new(v36("left_limit_%s", v776), v51.create_slider, v777, "Left limit", 0, 59, 30);
            v51.new(v36("right_limit_%s", v776), v51.create_slider, v777, "Right limit", 0, 59, 30);
            v51.new(v36("fake_options_%s", v776), v51.create_list, v777, "Desync options", {
                [1] = "Avoid overlap", 
                [2] = "Jitter", 
                [3] = "Randomize jitter"
            }, v39, true);
            v51.new(v36("freestand_desync_%s", v776), v51.create_list, v777, "Desync freestand", {
                [1] = "Off", 
                [2] = "Peek fake", 
                [3] = "Peek real"
            });
        end;
    end;
    v757 = v51.create_table(v753, "World", false, 9);
    v51.new("enable_bloom", v51.create_checkbox, v757, "Enable bloom");
    v51.new("bloom_scale", v51.create_slider, v757, "Bloom scale", 1, 100, 30);
    v51.new("exposure_scale", v51.create_slider, v757, "Exposure scale", 1, 100, 50);
    v51.new("model_brightness", v51.create_slider, v757, "Model brightness", 1, 100, 20);
    v51.new("enable_impacts", v51.create_checkbox, v757, "Enable splash impact");
    v51.new("only_local_impacts", v51.create_checkbox, v757, "Only local");
    v51.new("impacts_color", v51.create_color, v757, "Splash impacts color", l_color_0(255));
    v758 = v51.create_table(v753, "Local", false, 5);
    v51.new("animate_transparency", v51.create_checkbox, v758, "Animate transparency");
    v51.new("select_animation_state", v51.create_list, v758, "Select animation state", {
        [1] = "On move", 
        [2] = "In air", 
        [3] = "On land"
    });
    v51.new("air_legs_movement", v51.create_list, v758, "In air legs", {
        [1] = "Regular", 
        [2] = "Static", 
        [3] = "Move"
    });
    v51.new("air_legs_movement_factor", v51.create_slider, v758, "In air legs factor", 0, 100, 20);
    v51.new("air_body_lean_factor", v51.create_slider, v758, "In air body lean", 0, 101, 100);
    v51.new("move_legs_movement", v51.create_list, v758, "On move legs", {
        [1] = "Regular", 
        [2] = "Static", 
        [3] = "Jitter", 
        [4] = "Move"
    });
    v51.new("move_legs_movement_factor", v51.create_slider, v758, "On move legs factor", 0, 100, 20);
    v51.new("move_body_lean_factor", v51.create_slider, v758, "On move body lean", 0, 101, 100);
    v51.new("on_land_options", v51.create_list, v758, "On land", {
        [1] = "Regular", 
        [2] = "Disable pitch", 
        [3] = "Disable crouch"
    });
    v759 = v51.create_table(v753, "View", true, 10);
    v51.new("select_view_list", v51.create_list, v759, "Select view settings", {
        [1] = "Aspect ratio", 
        [2] = "View model", 
        [3] = "Custom scope"
    });
    v51.new("aspect_ratio", v51.create_slider, v759, "Aspect ratio", 0, 150, 100, v39, {
        [0] = "Disable", 
        [100] = "Default"
    });
    v51.new("enable_view_model", v51.create_checkbox, v759, "Override view model");
    v51.new("view_offset_x", v51.create_slider, v759, "Offset x", -40, 40, 0);
    v51.new("view_offset_y", v51.create_slider, v759, "Offset y", -40, 40, 0);
    v51.new("view_offset_z", v51.create_slider, v759, "Offset z", -40, 40, 0);
    v51.new("view_offset_fov", v51.create_slider, v759, "Offset fov", 0, 170, 60);
    v51.new("view_knife_opposite", v51.create_checkbox, v759, "Knife on opposite hand");
    v51.new("enable_scope", v51.create_checkbox, v759, "Override scope");
    v51.new("scope_origin", v51.create_slider, v759, "Origin", 0, 150, 10);
    v51.new("scope_width", v51.create_slider, v759, "Width", 0, 350, 110);
    v51.new("scope_inner_color", v51.create_color, v759, "Inner color", l_color_0(255));
    v51.new("scope_outer_color", v51.create_color, v759, "Outer color", l_color_0(255, 0));
    v51.new("scope_lines", v51.create_list, v759, "Select lines", {
        [1] = "Top", 
        [2] = "Left", 
        [3] = "Right", 
        [4] = "Bottom"
    }, true, true);
    v51.new("scope_settings", v51.create_list, v759, "Additional settings", {
        [1] = "Spread Offset", 
        [2] = "Second Zoom"
    }, v39, true);
    v757 = v51.create_table(v754, "Window settings", false, 10);
    v51.new("select_window_settings", v51.create_list, v757, "Select window", {
        [1] = "Headup display", 
        [2] = "Keybinds", 
        [3] = "Logs", 
        [4] = "Side indicators", 
        [5] = "Velocity warning", 
        [6] = "Watermark"
    });
    if not v49.keyboard_handle then
        v51.new("warning_hud_text", v51.create_text, v757, "Hud warning", "Warning ! Custom chat doesnt work, do not press the keys to open chat if you enable hud");
    else
        v51.new("warning_hud_text", v51.create_text, v757, "Hud warning", "Warning ! Before you enable HUD, select your in game keybinds for chats");
    end;
    v51.new("enable_all_chat", v51.create_keybind, v757, "All chat", 89, true);
    v51.new("enable_team_chat", v51.create_keybind, v757, "Team chat", 85, true);
    v51.new("enable_hud", v51.create_checkbox, v757, "Enable HUD");
    v51.new("hud_ct_color", v51.create_color, v757, "Counter terrorist color", l_color_0(50, 50, 255, 255));
    v51.new("hud_t_color", v51.create_color, v757, "Terrorist color", l_color_0(255, 50, 50, 255));
    v51.new("hud_local_color", v51.create_color, v757, "Local kill color", l_color_0(255, 50, 50, 255));
    v51.new("enable_keybinds", v51.create_checkbox, v757, "Enable keybinds");
    v51.new("enable_logs", v51.create_checkbox, v757, "Enable logs");
    v51.new("logs_settings", v51.create_list, v757, "Specific logs settings", {
        [1] = "Hit", 
        [2] = "Miss", 
        [3] = "Purchase"
    });
    v51.new("logs_hit_enable", v51.create_list, v757, "Hit logs", {
        [1] = "Console", 
        [2] = "Screen"
    }, v39, true);
    v51.new("logs_hit_color", v51.create_color, v757, "Hit color", l_color_0(255));
    v51.new("logs_falsehit_color", v51.create_color, v757, "False hit color", l_color_0(255));
    v51.new("logs_kill_color", v51.create_color, v757, "Kill color", l_color_0(255));
    v51.new("logs_miss_enable", v51.create_list, v757, "Miss logs", {
        [1] = "Console", 
        [2] = "Screen"
    }, v39, true);
    v51.new("logs_correction_color", v51.create_color, v757, "Correction color", l_color_0(255));
    v51.new("logs_spread_color", v51.create_color, v757, "Spread color", l_color_0(255));
    v51.new("logs_othermiss_color", v51.create_color, v757, "Other miss color", l_color_0(255));
    v51.new("logs_purchase_enable", v51.create_checkbox, v757, "Purchase log");
    v51.new("logs_purchase_color", v51.create_color, v757, "Purchase color", l_color_0(255));
    v51.new("enable_side_indicators", v51.create_checkbox, v757, "Enable side indicators");
    v51.new("side_indicators_mode", v51.create_list, v757, "Mode", {
        [1] = "Normal", 
        [2] = "Muzzle"
    });
    v51.new("side_indicators_options", v51.create_list, v757, "Options", {
        [1] = "Double tap / Hide shots", 
        [2] = "Min damage", 
        [3] = "Dormant aim", 
        [4] = "Auto peek", 
        [5] = "Freestand", 
        [6] = "Defensive snap"
    }, v39, true);
    v51.new("enable_velocity_warning", v51.create_checkbox, v757, "Enable velocity warning");
    v51.new("velocity_warning_effect", v51.create_checkbox, v757, "Warning view Effect");
    v51.new("enable_watermark", v51.create_checkbox, v757, "Enable watermark");
    v51.new("watermark_settings", v51.create_list, v757, "Watermark settings", {
        [1] = "Disable grid", 
        [2] = "Build", 
        [3] = "Name", 
        [4] = "Ping", 
        [5] = "Time"
    }, v39, true);
    v758 = v51.create_table(v754, "World", true, 7);
    v51.new("enable_damage", v51.create_checkbox, v758, "Enable damage markers");
    v51.new("damage_head_color", v51.create_color, v758, "Head damage color", l_color_0(255));
    v51.new("damage_other_color", v51.create_color, v758, "Other damage color", l_color_0(255));
    v51.new("damage_settings", v51.create_list, v758, "Damage settings", {
        [1] = "Glow", 
        [2] = "Animate", 
        [3] = "Local only"
    }, v39, true);
    v51.new("enable_shots", v51.create_checkbox, v758, "Enable shot markers");
    v51.new("hit_color", v51.create_color, v758, "Hit color", l_color_0(255));
    v51.new("miss_color", v51.create_color, v758, "Miss color", l_color_0(255));
    v51.new("manuals_indicators", v51.create_checkbox, v758, "Enable manuals indicators");
    v757 = v51.create_table(v755, "General", false, 7);
    v51.new("clantag", v51.create_checkbox, v757, "Enable clantag");
    v51.new("killsay", v51.create_checkbox, v757, "Enable killsay");
    v51.new("round_flash", v51.create_checkbox, v757, "Notify on round start");
    v51.new("remove", v51.create_list, v757, "Remove", {
        [1] = "Chat", 
        [2] = "Radar", 
        [3] = "Ragdoll Physics", 
        [4] = "Decals", 
        [5] = "Foot Shadow", 
        [6] = "Blood Splash", 
        [7] = "Unsused elements"
    }, v39, true);
    v758 = v51.create_table(v755, "Movement", false, 5);
    v51.new("fast_ladder", v51.create_checkbox, v758, "Fast ladder climb");
    v51.new("avoid_collisions", v51.create_checkbox, v758, "Avoid collisions");
    v51.new("slow_walk", v51.create_slider, v758, "Slow walk", 0, 75, 0, v39, {
        [0] = "Disable"
    });
    v759 = v51.create_table(v755, "Sound", true, 6);
    v51.new("local_hurt", v51.create_list, v759, "Local hurt sound", {
        [1] = "Disable", 
        [2] = "Switch", 
        [3] = "Warning", 
        [4] = "Wood Stop", 
        [5] = "Wood Strain", 
        [6] = "Wood Plank", 
        [7] = "Error 1", 
        [8] = "Woosh"
    });
    v51.new("local_hurt_volume", v51.create_slider, v759, "Sound volume", 0, 100, 80);
    v51.new("weapons_sounds", v51.create_checkbox, v759, "Override weapons sounds");
    v51.new("weapons_sounds_volume", v51.create_slider, v759, "Weapons volume", 0, 100, 30);
    v761 = v51.create_table(v755, "Weapons", true, 1);
    v51.new("select_weapon", v51.create_list, v761, "Select weapon", v51.weapons);
    for v778 = 1, #v51.weapons do
        local v779 = v51.weapons[v778];
        local v780 = v51.create_table(v755, v36("%s exploit", v779), false, 5);
        local v781 = v51.create_table(v755, v36("%s hitchace", v779), true, 6);
        v779 = v37(v779);
        v51.new(v36("%s_hideshots", v779), v51.create_checkbox, v780, "Adaptive hideshots");
        v51.new(v36("%s_uncharge_attack", v779), v51.create_checkbox, v780, "Uncharge attack");
        v51.new(v36("%s_uncharge_attack_delay", v779), v51.create_slider, v780, "Uncharge delay", 0, 10, 0);
        v51.new(v36("%s_allow_hideshots", v779), v51.create_checkbox, v780, "Allow hideshots teleport");
        v51.new(v36("%s_air_hitchance", v779), v51.create_slider, v781, "Air hitchance", -1, 100, -1, v39, {
            [-1] = "Disabled"
        });
        if v778 < 4 then
            v51.new(v36("%s_noscope_hitchance", v779), v51.create_slider, v781, "No scope hitchance", -1, 100, -1, v39, {
                [-1] = "Disabled"
            });
            v51.new(v36("%s_noscope_distance", v779), v51.create_slider, v781, "No scope distance", 0, 1000, 500);
        end;
    end;
    if v49.keyboard_handle then
        v757 = v51.create_table(v756, "result", true, 16);
        v758 = v51.create_text(v757, "search_result", "");
        v759 = v51.create_table(v756, "search_point", false, 6);
        v51.create_text(v759, "search_hint", "If you cannot find something. Just type in the text-box");
        do
            local l_v758_0 = v758;
            v51.create_input(v759, "Find", v39, function(v783)
                -- upvalues: v51 (ref), v37 (ref), v26 (ref), v50 (ref), v36 (ref), v27 (ref), v29 (ref), v39 (ref), l_v758_0 (ref), v25 (ref)
                local l_v783_0 = v783;
                if #l_v783_0 < 2 then
                    return;
                else
                    local v785 = {};
                    for v786 = 1, #v51.tabs_list do
                        local v787 = v51.tabs_list[v786];
                        for v788 = 1, #v787.tables do
                            local v789 = v787.tables[v788];
                            for v790 = 1, #v789.elements do
                                local v791 = v789.elements[v790];
                                local v792 = v37(v791._name);
                                local v793 = v37(l_v783_0);
                                if v26.find(v792, v37(l_v783_0)) then
                                    local v794 = v26.gsub(v792, v793, v26.format("\a%s%s\aDEFAULT", v50.colors.accent:to_hex(), v793));
                                    local v795 = #v785 + 1;
                                    local v796 = v36("%d. %s -> %s -> %s", v795, v787._name, v789._name, v794);
                                    v785[v795] = v26.wrap_text(v796, 290, "theme::font");
                                end;
                            end;
                        end;
                    end;
                    if #v785 > 20 then
                        return;
                    else
                        local v797 = v27.concat(v785, "\n");
                        size = v29.measure_text("theme::font", v39, v797);
                        l_v758_0.value = v797;
                        l_v758_0.menu_size = v25.ceil(size.y / 40);
                        return;
                    end;
                end;
            end);
        end;
    else
        v757 = v51.create_table(v756, "result", false, 10);
        v51.create_text(v757, "search_result", "Some error occurred on load, and therefore search option is not available");
    end;
    return true;
end;
v51.organize_elements = function()
    -- upvalues: v51 (ref), v29 (ref), v37 (ref), v36 (ref), v49 (ref), v39 (ref)
    if not v51.is_open() then
        return;
    else
        v29.animation_speed = v51.get("animation_speed");
        if v51.active_tab ~= 1 then
            if v51.active_tab == 2 then
                local v798 = v51.get("override_anti_aim");
                v51.visible("override_pitch", v798);
                v51.visible("override_yaw", v798);
                v51.visible("at_target_in_air", v798 and v51.get("override_yaw") == "Local view");
                v51.visible("anti_aim_mode", v798);
                v51.visible("select_preset", v798 and v51.get("anti_aim_mode") == "Auto presets");
                v51.visible("enable_preset_freestand", v798 and v51.get("anti_aim_mode") == "Auto presets");
                v51.visible("enable_anti_aim_misc", v798);
                v51.visible("resert_anti_bruteforce", v798 and v51.get("enable_anti_aim_misc")[2]);
                v51.visible("invert_freestand", v798 and v51.get("enable_anti_aim_misc")[7]);
                v51.visible("limit_freestand", v798 and v51.get("enable_anti_aim_misc")[7]);
                v51.visible("edge_yaw", v798);
                v51.visible("defensive_snap", v798);
                v51.visible("defensive_pitch", v798 and v51.has_bind("Defensive snap"));
                v51.visible("defensive_yaw", v798 and v51.has_bind("Defensive snap"));
                v51.visible("defensive_settings", v798 and v51.has_bind("Defensive snap"));
                v51.visible("manual_left", v798);
                v51.visible("manual_right", v798);
                v51.visible("manual_back", v798);
                local v799 = v798 and v51.get("anti_aim_mode") == "Default builder";
                v51.visible("default_states", v799);
                local v800 = v37(v51.get("default_states"));
                for v801 = 1, #v51.local_states do
                    local v802 = v37(v51.local_states[v801]);
                    local v803 = v802 == v800 and v799;
                    if v802 ~= "global" then
                        v51.visible(v36("enable_state_%s", v802), v803);
                    end;
                    local v804 = v803 and v51.get(v36("enable_state_%s", v802));
                    v51.visible(v36("select_sub_state_%s", v802), v804);
                    local v805 = v37(v51.get(v36("select_sub_state_%s", v802)));
                    for v806 = 1, 3 do
                        local v807 = v37(v51.sub_states[v806]);
                        local v808 = v36("%s_%s", v802, v807);
                        local v809 = v805 == v807 and v804;
                        if v807 ~= "regular" then
                            v51.visible(v36("enable_%s", v808), v809);
                        end;
                        local v810 = v809 and v51.get(v36("enable_%s", v808));
                        v51.visible(v36("yaw_left_%s", v808), v810);
                        v51.visible(v36("yaw_right_%s", v808), v810);
                        v51.visible(v36("yaw_modifier_%s", v808), v810);
                        local v811 = v51.get(v36("yaw_modifier_%s", v808));
                        v51.visible(v36("yaw_modifier_delta_%s", v808), v810 and v811 ~= "Disabled");
                        v51.visible(v36("yaw_modifier_mode_%s", v808), v810 and v811 == "Devided delta");
                        v51.visible(v36("left_limit_%s", v808), v810);
                        v51.visible(v36("right_limit_%s", v808), v810);
                        v51.visible(v36("fake_options_%s", v808), v810);
                        v51.visible(v36("freestand_desync_%s", v808), v810);
                    end;
                end;
            elseif v51.active_tab == 3 then
                v51.visible("bloom_scale", v51.get("enable_bloom"));
                v51.visible("exposure_scale", v51.get("enable_bloom"));
                v51.visible("model_brightness", v51.get("enable_bloom"));
                v51.visible("only_local_impacts", v51.get("enable_impacts"));
                v51.visible("impacts_color", v51.get("enable_impacts"));
                local v812 = v51.get("select_animation_state");
                v51.visible("air_legs_movement", v812 == "In air");
                v51.visible("air_legs_movement_factor", v812 == "In air");
                v51.visible("air_body_lean_factor", v812 == "In air");
                v51.visible("move_legs_movement", v812 == "On move");
                v51.visible("move_legs_movement_factor", v812 == "On move");
                v51.visible("move_body_lean_factor", v812 == "On move");
                v51.visible("on_land_options", v812 == "On land");
                v812 = v51.get("select_view_list");
                local v813 = v812 == "View model" and v51.get("enable_view_model");
                local v814 = v812 == "Custom scope" and v51.get("enable_scope");
                v51.visible("aspect_ratio", v812 == "Aspect ratio");
                v51.visible("enable_view_model", v812 == "View model");
                v51.visible("view_offset_x", v813);
                v51.visible("view_offset_y", v813);
                v51.visible("view_offset_z", v813);
                v51.visible("view_offset_fov", v813);
                v51.visible("view_knife_opposite", v813);
                v51.visible("enable_scope", v812 == "Custom scope");
                v51.visible("scope_origin", v814);
                v51.visible("scope_width", v814);
                v51.visible("scope_inner_color", v814);
                v51.visible("scope_outer_color", v814);
                v51.visible("scope_lines", v814);
                v51.visible("scope_settings", v814);
            elseif v51.active_tab == 4 then
                local v815 = v51.get("select_window_settings");
                v51.visible("enable_keybinds", v815 == "Keybinds");
                v51.visible("enable_logs", v815 == "Logs");
                local v816 = v815 == "Logs" and v51.get("enable_logs");
                v51.visible("logs_settings", v816);
                local v817 = v816 and v51.get("logs_settings") == "Hit";
                v51.visible("logs_hit_enable", v817);
                v51.visible("logs_hit_color", v817);
                v51.visible("logs_falsehit_color", v817);
                v51.visible("logs_kill_color", v817);
                local v818 = v816 and v51.get("logs_settings") == "Miss";
                v51.visible("logs_miss_enable", v818);
                v51.visible("logs_correction_color", v818);
                v51.visible("logs_spread_color", v818);
                v51.visible("logs_othermiss_color", v818);
                local v819 = v816 and v51.get("logs_settings") == "Purchase";
                v51.visible("logs_purchase_enable", v819);
                v51.visible("logs_purchase_color", v819);
                v51.visible("warning_hud_text", v815 == "Headup display");
                v51.visible("enable_all_chat", v815 == "Headup display" and v49.keyboard_handle ~= v39);
                v51.visible("enable_team_chat", v815 == "Headup display" and v49.keyboard_handle ~= v39);
                v51.visible("enable_hud", v815 == "Headup display");
                v816 = v815 == "Headup display" and v51.get("enable_hud");
                v51.visible("hud_ct_color", v816);
                v51.visible("hud_t_color", v816);
                v51.visible("hud_local_color", v816);
                v51.visible("enable_side_indicators", v815 == "Side indicators");
                v51.visible("side_indicators_mode", v815 == "Side indicators" and v51.get("enable_side_indicators"));
                v51.visible("side_indicators_options", v815 == "Side indicators" and v51.get("enable_side_indicators"));
                v51.visible("enable_velocity_warning", v815 == "Velocity warning");
                v51.visible("velocity_warning_effect", v815 == "Velocity warning" and v51.get("enable_velocity_warning"));
                v51.visible("enable_watermark", v815 == "Watermark");
                v51.visible("watermark_settings", v815 == "Watermark" and v51.get("enable_watermark"));
                v51.visible("damage_head_color", v51.get("enable_damage"));
                v51.visible("damage_other_color", v51.get("enable_damage"));
                v51.visible("damage_settings", v51.get("enable_damage"));
                v51.visible("hit_color", v51.get("enable_shots"));
                v51.visible("miss_color", v51.get("enable_shots"));
                v51.visible("manuals_indicators", v51.get("override_anti_aim"));
            elseif v51.active_tab == 5 then
                local v820 = v51.get("select_weapon");
                for v821 = 1, #v51.weapons do
                    local v822 = v51.weapons[v821];
                    local v823 = v822 == v820;
                    v822 = v37(v822);
                    v51.visible(v36("%s_hideshots", v822), v823);
                    v51.visible(v36("%s_uncharge_attack", v822), v823);
                    local v824 = v51.get(v36("%s_uncharge_attack", v822));
                    v51.visible(v36("%s_uncharge_attack_delay", v822), v823 and v824);
                    v51.visible(v36("%s_allow_hideshots", v822), v823 and v824);
                    v51.visible(v36("%s_air_hitchance", v822), v823);
                    if v821 < 4 then
                        v51.visible(v36("%s_noscope_hitchance", v822), v823);
                        v51.visible(v36("%s_noscope_distance", v822), v823);
                    end;
                end;
            end;
        end;
        return;
    end;
end;
v51.destroy = function()
    -- upvalues: v51 (ref), v31 (ref)
    local v825 = v51.get_config();
    v31.write("csgo\\DigitalDreams\\Configs\\AutoSave.digital", v825);
end;
v51.initialize_window = function()
    -- upvalues: v51 (ref), v48 (ref), l_vector_0 (ref), v49 (ref)
    v51.window = v48.window("lua::ui::main_window", l_vector_0(100, 100), l_vector_0(780, 600));
    v51.window:register_render(v51.render_main_window, "lua::ui::main_window::render");
    v49.attach("render", v51.handle_keybinds, "lua::ui::handle_keybinds");
    v49.attach("render", v51.organize_elements, "lua::ui::organize_elements");
    v49.attach("mouse_input", v51.mouse_interact, "lua::ui::main::mouse_input");
    v49.attach("low_level_keyboard", v51.keyboard_interact, "lua::ui::main::keyboard_input");
    v49.attach("shutdown", v51.destroy, "lua::ui::unload");
    return true;
end;
v52.local_player = v32.get_local_player;
v52.thread = v32.get_threat;
v52.is_alive = false;
v52.is_in_air = false;
v52.is_fake_lag = false;
v52.is_crouch = false;
v52.update = function()
    -- upvalues: v52 (ref), v39 (ref), v30 (ref)
    v52.is_alive = v52.local_player() ~= v39 and v52.local_player().m_iHealth > 0;
    local v826 = v52.local_player() ~= v39 and v52.local_player().m_fFlags or v39;
    v52.is_in_air = v826 ~= v39 and bit.band(v826, 1) == 0 or v30.is_virtual_key_pressed(32);
    v52.is_fake_lag = v52.local_player() ~= v39 and rage.exploit:get() == 0;
    v52.is_crouch = v52.local_player() ~= v39 and v52.local_player().m_flDuckAmount > 0.1;
end;
v52.get_active_weapon = function()
    -- upvalues: v52 (ref), v39 (ref)
    local v827 = v52.local_player():get_player_weapon();
    if not v827 then
        return;
    else
        local v828 = v827:get_weapon_info();
        local v829 = v827:get_weapon_index();
        if v828.is_revolver then
            return "r8";
        elseif v829 == 1 then
            return "deagle";
        elseif v828.weapon_type == 1 then
            return "pistols";
        elseif v829 == 40 then
            return "scout";
        elseif v829 == 9 then
            return "awp";
        elseif v829 == 38 or v829 == 1 then
            return "auto";
        else
            return v39;
        end;
    end;
end;
v52.get_enemy = function()
    -- upvalues: v52 (ref), v39 (ref), v25 (ref), l_ipairs_0 (ref), v32 (ref)
    if not v52.local_player() then
        return v39;
    elseif not v52.local_player():is_alive() then
        return v39;
    else
        local v830 = v52.local_player():get_origin();
        local l_huge_0 = v25.huge;
        local l_v39_0 = v39;
        for _, v834 in l_ipairs_0(v32.get_players(true)) do
            if v834 and v834:is_alive() then
                local v835 = v830:dist((v834:get_origin()));
                if v835 <= l_huge_0 then
                    l_huge_0 = v835;
                    l_v39_0 = v834;
                end;
            end;
        end;
        return l_v39_0;
    end;
end;
v53.destroy = function()
    -- upvalues: v51 (ref), v39 (ref)
    v51.references.hide_shots_options:override(v39);
end;
v53.defensive_activity = 0;
v53.is_lag_exploiting = function(v836)
    -- upvalues: v30 (ref), v25 (ref), v53 (ref)
    local v837 = v30.net_channel();
    local v838 = v836:get_simulation_time();
    local v839 = v25.floor((v838.current - v838.old) / globals.tickinterval + 0.5);
    if v839 < 0 then
        v53.defensive_activity = globals.tickcount + v25.abs(v839) - v25.floor(v837.latency[0] / globals.tickinterval + 0.5);
    end;
    return v53.defensive_activity > globals.tickcount;
end;
v53.hideshots = function()
    -- upvalues: v52 (ref), v51 (ref), v36 (ref), v53 (ref), v32 (ref)
    if not v52.is_alive then
        return;
    else
        local v840 = v52.get_active_weapon();
        if not v840 then
            return;
        elseif not v51.get(v36("%s_hideshots", v840)) then
            v53.destroy();
            return;
        else
            local v841 = v32.get_threat(false);
            if not v841 then
                return;
            else
                v51.references.hide_shots_options:override((not v841:is_visible() or v53.is_lag_exploiting(v52.local_player())) and "Break LC" or "Favor Fire Rate");
                return;
            end;
        end;
    end;
end;
v53.did_teleport = false;
v53.safe_teleport = function()
    -- upvalues: v53 (ref)
    rage.exploit:force_teleport();
    rage.exploit:allow_charge(false);
    v53.did_teleport = true;
end;
v53.uncharge_attack = function()
    -- upvalues: v52 (ref), v51 (ref), v36 (ref), v32 (ref), v30 (ref), v53 (ref)
    if not v52.is_alive then
        return;
    else
        local v842 = v52.get_active_weapon();
        if not v842 then
            return;
        elseif not v51.get(v36("%s_uncharge_attack", v842)) then
            return;
        elseif not v51.get(v36("%s_allow_hideshots", v842)) and v51.references.hide_shots:get() and not v51.references.double_tap:get() then
            return;
        else
            local v843 = v51.get(v36("%s_uncharge_attack_delay", v842)) / 100;
            local v844 = v32.get_threat(true);
            if not v844 then
                return;
            elseif v30.is_virtual_key_pressed(32) then
                return;
            elseif v52.local_player().m_vecVelocity.z > -85 then
                return;
            elseif rage.exploit:get() ~= 1 then
                return;
            elseif v844.m_vecOrigin:dist(v52.local_player().m_vecOrigin) > 1000 or not v30.can_hit(v844) then
                return;
            else
                if v843 == 0 then
                    v53.safe_teleport();
                else
                    v30.execute_after(v843, v53.safe_teleport);
                end;
                return;
            end;
        end;
    end;
end;
v53.handle_charge = function()
    -- upvalues: v52 (ref), v53 (ref), v30 (ref)
    if not v52.is_alive then
        return;
    else
        if v53.did_teleport and not v52.is_in_air then
            v53.did_teleport = false;
            v30.execute_after(1, function()
                rage.exploit:allow_charge(true);
            end);
        end;
        return;
    end;
end;
v54.fixed_disable = false;
v54.destroy = function()
    -- upvalues: v54 (ref), v51 (ref), v39 (ref)
    if v54.fixed_disable then
        return;
    else
        for v845 = 1, #v51.weapons do
            v51.references.hitchance[v845]:override(v39);
            if v51.references.auto_scope[v845] then
                v51.references.auto_scope[v845]:override(v39);
            end;
        end;
        v54.fixed_disable = true;
        return;
    end;
end;
v54.update = function()
    -- upvalues: v52 (ref), v54 (ref), v51 (ref), v37 (ref), v36 (ref), v39 (ref), v25 (ref)
    if not v52.is_alive then
        v54.destroy();
        return;
    else
        local l_m_bIsScoped_0 = v52.local_player().m_bIsScoped;
        local v847 = v52.get_enemy();
        local v848 = -1;
        if v847 then
            v848 = v52.local_player():get_origin():dist(v847:get_origin());
        end;
        for v849 = 1, #v51.weapons do
            local v850 = v37(v51.weapons[v849]);
            local v851 = v849 < 4;
            local v852 = v851 and v848 ~= -1 and v848 < v51.get(v36("%s_noscope_distance", v850));
            local v853 = v851 and v51.get(v36("%s_noscope_hitchance", v850)) or -1;
            local v854 = v852 and v853 ~= -1 and not l_m_bIsScoped_0;
            local v855 = v51.get(v36("%s_air_hitchance", v850));
            local v856 = v855 ~= -1 and v52.is_in_air;
            if v51.references.auto_scope[v849] then
                if v854 then
                    v51.references.auto_scope[v849]:override(false);
                else
                    v51.references.auto_scope[v849]:override(v39);
                end;
            end;
            if not v856 and not v854 then
                v51.references.hitchance[v849]:override(v39);
            elseif v856 and not v854 then
                v51.references.hitchance[v849]:override(v855);
            elseif not v856 and v854 then
                v51.references.hitchance[v849]:override(v853);
            elseif v856 and v854 then
                v51.references.hitchance[v849]:override(v25.max(v853, v855));
            end;
        end;
        return;
    end;
end;
v55.disable_pitch = false;
v55.should_disable = false;
v55.createmove = function(v857)
    -- upvalues: v51 (ref), v55 (ref), v30 (ref), v52 (ref), v39 (ref), v32 (ref)
    if not v51.get("override_anti_aim") or not v51.get("enable_anti_aim_misc")[1] then
        v55.disable_pitch = false;
        return;
    else
        v55.disable_pitch = v30.is_virtual_key_pressed(69);
        v55.should_disable = false;
        local v858 = v52.local_player():get_origin();
        local v859 = v52.local_player():get_player_weapon();
        if v859 == v39 then
            return;
        else
            if v859:get_classname() == "CC4" then
                v55.should_disable = true;
            else
                local v860 = {};
                v860[#v860 + 1] = v32.get_entities(97);
                v860[#v860 + 1] = v32.get_entities("CPropDoorRotating");
                if v52.local_player().m_iTeamNum == 3 then
                    v860[#v860 + 1] = v32.get_entities(129);
                end;
                for v861 = 1, #v860 do
                    local v862 = v860[v861];
                    if v862 ~= v39 then
                        for v863 = 1, #v862 do
                            local v864 = v862[v863];
                            if v864 and v858:dist(v864.m_vecOrigin) < 120 then
                                v55.should_disable = true;
                                break;
                            end;
                        end;
                    end;
                    if v55.should_disable then
                        break;
                    end;
                end;
            end;
            if not v55.should_disable then
                v857.in_use = 0;
            end;
            return;
        end;
    end;
end;
v56.is_wall = false;
v56.yaw = 0;
v56.trace = v39;
v56.createmove = function(_)
    -- upvalues: v56 (ref), v51 (ref), v55 (ref), v52 (ref), v29 (ref), v39 (ref), v25 (ref), l_vector_0 (ref), v30 (ref)
    v56.is_wall = false;
    v56.yaw = 0;
    if not v51.get("override_anti_aim") or not v51.get_bind("Edge yaw") then
        return;
    elseif v55.disable_pitch or not v52.is_alive then
        return;
    else
        local v866 = v52.local_player():get_eye_position();
        if not v866 then
            return;
        else
            local v867 = v29.camera_angles();
            if not v867 then
                return;
            else
                local v868 = 8192;
                local l_v39_1 = v39;
                for v870 = v867.y - 90, v867.y + 90, 15 do
                    local v871 = v25.rad(v870);
                    local v872 = v866 + l_vector_0(v25.cos(v871) * 100, v25.sin(v871) * 100);
                    v56.trace = v30.trace_line(v866, v872, v52.local_player(), v39, 1);
                    if v56.trace.fraction * 100 < v868 then
                        v868 = v56.trace.fraction * 100;
                        l_v39_1 = v872;
                    end;
                end;
                if v868 > 30 then
                    return;
                else
                    local v873 = v866:calculate_angle(l_v39_1);
                    local v874 = v25.normalize_yaw(v867.y - 180);
                    local v875 = v25.normalize_yaw(v873 - v874);
                    v56.is_wall = true;
                    v56.yaw = v875;
                    return;
                end;
            end;
        end;
    end;
end;
v57.is_active = false;
v57.time = 0;
v57.misses = 0;
v57.is_enable = false;
v57.presets = db._DigitalDreams_AntiBruteforce_ or {};
v57.create_copy = function()
    -- upvalues: v51 (ref)
    return {
        [1] = v51.references.yaw_modifier_offset:get_override() or v51.references.yaw_modifier_offset:get(), 
        [2] = v51.references.body_yaw_options:get_override() or v51.references.body_yaw_options:get(), 
        [3] = false
    };
end;
v57.detect_bullet = function(v876)
    -- upvalues: v57 (ref), v52 (ref), v32 (ref), v39 (ref), l_vector_0 (ref)
    if not v57.is_enable then
        return;
    elseif not v52.is_alive then
        return;
    elseif v57.time == globals.realtime then
        return;
    else
        local v877 = v32.get(v876.userid, true);
        if not v877 then
            return;
        elseif not v877:is_enemy() or v52.local_player() == v877 then
            return;
        else
            local l_x_0 = v876.x;
            local l_y_0 = v876.y;
            local l_z_0 = v876.z;
            if l_x_0 == v39 or l_y_0 == v39 or l_z_0 == v39 then
                return;
            else
                local v881 = l_vector_0(l_x_0, l_y_0, l_z_0);
                local v882 = v52.local_player():get_eye_position();
                if not v882 then
                    return;
                else
                    local v883 = v877:get_eye_position();
                    if not v883 then
                        return;
                    elseif v882:closest_ray_point(v881, v883):dist(v882) > 75 then
                        return;
                    else
                        v57.time = globals.realtime;
                        v57.misses = v57.misses + 1;
                        return;
                    end;
                end;
            end;
        end;
    end;
end;
v57.rework = function()
    -- upvalues: v57 (ref), v39 (ref), v25 (ref), v27 (ref)
    if v57.presets[v57.misses] == v39 then
        return;
    else
        v57.presets[v57.misses][1] = v25.random(-80, 40);
        if v25.random() > 0.5 then
            v27.delete(v57.presets[v57.misses][2], "Jitter");
            v57.presets[v57.misses][3] = v25.random() > 0.5;
        else
            v27.insert(v57.presets[v57.misses][2], "Jitter");
        end;
        return;
    end;
end;
v57.detect_hit = function(v884)
    -- upvalues: v57 (ref), v52 (ref), v32 (ref)
    if not v57.is_enable then
        return;
    elseif not v52.is_alive then
        return;
    elseif v57.time + 5 < globals.realtime or v57.misses == 0 then
        return;
    else
        local v885 = v32.get(v884.userid, true);
        if not v885 or v52.local_player() ~= v885 then
            return;
        else
            local l_hitgroup_0 = v884.hitgroup;
            if not l_hitgroup_0 or l_hitgroup_0 ~= 1 then
                return;
            else
                v57.rework();
                return;
            end;
        end;
    end;
end;
v57.createmove = function(_)
    -- upvalues: v57 (ref), v51 (ref), v52 (ref), v39 (ref)
    v57.is_active = false;
    v57.is_enable = v51.get("override_anti_aim") and v51.get("enable_anti_aim_misc")[2];
    if not v57.is_enable then
        return;
    elseif not v52.is_alive then
        return;
    elseif v57.time + 5 < globals.realtime then
        v57.misses = 0;
        return;
    else
        if not v57.presets[v57.misses] then
            v57.presets[v57.misses] = v57.create_copy();
            v57.rework();
        end;
        v57.is_active = v57.presets[v57.misses] ~= v39;
        return;
    end;
end;
v57.save = function()
    -- upvalues: v57 (ref)
    db._DigitalDreams_AntiBruteforce_ = v57.presets;
end;
v58.manual_side = 0;
v58.last_key = v39;
v58.disable = false;
v58.override_settings = {
    yaw_offset = 0, 
    yaw_modifier = v39, 
    yaw_modifier_offset = v39, 
    body_options = {}, 
    left_limit = v39, 
    right_limit = v39, 
    freestand = v39
};
v58.fix_close = false;
v58.switch_pitch = 1;
v58.switch_yaw = 1;
v58.jitter_check = false;
v58.override_freestand = v39;
v58.should_freestand = false;
v58.angles = {
    [1] = 90, 
    [2] = 75, 
    [3] = 60, 
    [4] = 30, 
    [5] = -30, 
    [6] = 60, 
    [7] = 75, 
    [8] = 90
};
v58.delta_jitter = {
    override = {}, 
    setup = {}, 
    save = {}
};
v58.did_hit_ground = false;
v58.round_end = function(_)
    -- upvalues: v58 (ref)
    v58.disable = true;
end;
v58.round_start = function(_)
    -- upvalues: v58 (ref)
    v58.disable = false;
end;
v58.death = function(v890)
    -- upvalues: v32 (ref), v52 (ref), v58 (ref)
    local v891 = v32.get(v890.userid, true);
    if v891 and v891 == v52.local_player() then
        v58.manual_side = 0;
    end;
end;
v58.neverlose_ui = function(v892)
    -- upvalues: v51 (ref)
    v51.references.yaw_offset:disabled(v892);
    v51.references.yaw_modifier:disabled(v892);
    v51.references.yaw_modifier_offset:disabled(v892);
    v51.references.body_yaw_options:disabled(v892);
    v51.references.left_limit:disabled(v892);
    v51.references.right_limit:disabled(v892);
    v51.references.freestand_desync:disabled(v892);
    v51.references.hidden:disabled(v892);
end;
v58.static_settings = function(v893, v894)
    -- upvalues: v58 (ref)
    v58.override_settings.yaw_offset = 0;
    v58.override_settings.yaw_modifier = "Disabled";
    v58.override_settings.yaw_modifier_offset = 0;
    v58.override_settings.body_options = {
        [1] = ""
    };
    v58.override_settings.left_limit = v893 and 58 or 0;
    v58.override_settings.right_limit = v893 and 58 or 0;
    v58.override_settings.freestand = v894 and "Peek Fake" or "Off";
end;
v58.find_yaw = function(_)
    -- upvalues: v58 (ref), v55 (ref), v51 (ref), v52 (ref)
    if v58.manual_side ~= 0 or v55.disable_pitch then
        return "Local View";
    elseif v51.get("override_yaw") == "Local view" then
        if v52.is_in_air and v51.get("at_target_in_air") then
            return "At Target";
        else
            return "Local View";
        end;
    else
        return "At Target";
    end;
end;
v58.preform_overrides = function(v896)
    -- upvalues: v57 (ref), v58 (ref), v51 (ref), v56 (ref), v39 (ref), v27 (ref)
    local v897 = v57.presets[v57.misses];
    local v898 = v58.manual_side * 90;
    v51.references.yaw_offset:override(v56.is_wall and v58.manual_side == 0 and v56.yaw or v58.override_settings.yaw_offset + v898);
    v51.references.yaw_modifier:override(v58.override_settings.yaw_modifier);
    v51.references.left_limit:override(v58.override_settings.left_limit);
    v51.references.right_limit:override(v58.override_settings.right_limit);
    if v51.get("enable_anti_aim_misc")[7] then
        v51.references.freestand_desync:override("Off");
        if v58.override_freestand == v39 then
            v58.should_freestand = not v58.should_freestand;
            v51.references.body_yaw_options:override(v57.is_active and v897[2] or v58.override_settings.body_options);
        else
            local v899 = v51.references.body_yaw_options:get_override() or v51.references.body_yaw_options:get();
            v27.delete(v899, "Jitter");
            v51.references.body_yaw_options:override(v899);
        end;
        if v58.override_freestand == 0 then
            rage.antiaim:inverter(true);
        end;
        if v58.override_freestand == 1 then
            rage.antiaim:inverter(false);
        end;
        if v58.override_freestand == 2 then
            rage.antiaim:inverter(v58.should_freestand);
            if v896.choked_commands == 0 then
                v58.should_freestand = not v58.should_freestand;
            end;
        end;
    else
        v51.references.body_yaw_options:override(v57.is_active and v897[2] or v58.override_settings.body_options);
        v51.references.freestand_desync:override(v58.override_settings.freestand);
    end;
    if v57.is_active and not v27.find(v897[2], "Jitter") then
        rage.antiaim:inverter(v897[3]);
        v51.references.yaw_modifier_offset:override(0);
    else
        v51.references.yaw_modifier_offset:override(v57.is_active and v897[1] or v58.override_settings.yaw_modifier_offset);
    end;
end;
v58.preform_general = function(v900)
    -- upvalues: v55 (ref), v51 (ref), v58 (ref), v39 (ref), v52 (ref)
    local v901 = v55.disable_pitch or not v51.get("override_pitch");
    v51.references.pitch:override(v901 and "Disabled" or "Down");
    v901 = v55.disable_pitch or v51.get("override_yaw") == "None";
    v51.references.yaw:override(v901 and "Disabled" or "Backward");
    v51.references.yaw_base:override(v58.find_yaw(v900));
    if v55.disable_pitch then
        v51.references.freestand:override(false);
    else
        v51.references.freestand:override(v39);
    end;
    v901 = v51.get("enable_anti_aim_misc");
    if v901[4] and v58.disable and not v52.thread() then
        v51.references.anti_aim_enable:override(false);
    else
        v51.references.anti_aim_enable:override(v39);
    end;
    v51.references.lag_options:override(v901[3] and v52.is_in_air and "Always on" or v39);
end;
v58.auto_preset = function(_)
    -- upvalues: v51 (ref), v58 (ref)
    local v903 = v51.get("select_preset");
    if v903 == "Static" then
        v58.static_settings(true, v51.get("enable_preset_freestand"));
    elseif v903 == "Old Center" then
        v58.override_settings.yaw_offset = 0;
        v58.override_settings.yaw_modifier = "Center";
        v58.override_settings.yaw_modifier_offset = -73;
        v58.override_settings.body_options = {
            [1] = "Jitter"
        };
        v58.override_settings.left_limit = 58;
        v58.override_settings.right_limit = 58;
        v58.override_settings.freestand = "Off";
    elseif v903 == "Break" then
        v58.override_settings.yaw_offset = rage.antiaim:inverter() and -24 or 37;
        v58.override_settings.yaw_modifier = "Offset";
        v58.override_settings.yaw_modifier_offset = 26;
        v58.override_settings.body_options = {
            [1] = "Jitter", 
            [2] = "Randomize Jitter"
        };
        v58.override_settings.left_limit = 58;
        v58.override_settings.right_limit = 58;
        v58.override_settings.freestand = "Peek Real";
    end;
end;
v58.get_state = function()
    -- upvalues: v52 (ref), v30 (ref), v51 (ref)
    if not v52.local_player() then
        return "global";
    else
        local v904 = v52.local_player().m_vecVelocity:length2d();
        if v30.is_virtual_key_pressed(69) then
            return "use";
        elseif v52.is_in_air then
            return "air";
        elseif v904 <= 5 then
            return "stand";
        elseif v51.references.slow_walk:get() then
            return "slow walk";
        elseif v904 > 5 then
            return "move";
        else
            return "global";
        end;
    end;
end;
v58.get_sub_state = function()
    -- upvalues: v52 (ref)
    if v52.is_fake_lag then
        return "fake lag";
    elseif v52.is_crouch then
        return "crouch";
    else
        return "regular";
    end;
end;
v58.calculate_jitter = function(v905, v906, v907, v908)
    -- upvalues: v58 (ref), v25 (ref)
    if not v58.delta_jitter.override[v908] then
        v58.delta_jitter.override[v908] = 1;
    end;
    if not v58.delta_jitter.setup[v908] then
        v58.delta_jitter.setup[v908] = 0;
    end;
    if not v58.delta_jitter.save[v908] then
        v58.delta_jitter.save[v908] = v907;
    end;
    if v58.delta_jitter.save[v908] ~= v907 then
        v58.delta_jitter.override[v908] = 1;
        v58.delta_jitter.setup[v908] = 0;
        v58.delta_jitter.save[v908] = v907;
    end;
    local v909 = v58.delta_jitter.save[v908] / v906;
    if v905.command_number % 4 > 1 and v905.send_packet ~= false then
        if v25.abs(v58.delta_jitter.setup[v908]) > v25.abs(v58.delta_jitter.save[v908] + v909) then
            v58.delta_jitter.setup[v908] = 0;
        else
            v58.delta_jitter.setup[v908] = v58.delta_jitter.setup[v908] + v909 * v58.delta_jitter.override[v908];
            v58.delta_jitter.override[v908] = v58.delta_jitter.override[v908] * -1;
            v58.delta_jitter.setup[v908] = v58.delta_jitter.setup[v908] * v58.delta_jitter.override[v908];
        end;
    end;
    return v58.delta_jitter.setup[v908];
end;
v58.default_builder = function(v910)
    -- upvalues: v58 (ref), v51 (ref), v36 (ref)
    local v911 = v58.get_state();
    local v912 = v51.get(v36("enable_state_%s", v911)) and v911 or "global";
    local v913 = v58.get_sub_state();
    local v914 = v36("%s_%s", v912, v913);
    if not v51.get(v36("enable_%s", v914)) or not v914 then
        v914 = v36("%s_regular", v912);
    end;
    local v915 = rage.antiaim:inverter();
    local v916 = 0;
    local v917 = v51.get(v36("yaw_modifier_%s", v914));
    local v918 = v51.get(v36("yaw_modifier_delta_%s", v914));
    if v917 == "Devided delta" then
        v58.override_settings.yaw_modifier = "Disabled";
        v58.override_settings.yaw_modifier_offset = 0;
        v916 = v58.calculate_jitter(v910, v51.get(v36("yaw_modifier_mode_%s", v914)), v918, "Builder");
    else
        v58.override_settings.yaw_modifier = v917;
        v58.override_settings.yaw_modifier_offset = v918;
    end;
    v58.override_settings.yaw_offset = v916 + (v915 and v51.get(v36("yaw_left_%s", v914)) or v51.get(v36("yaw_right_%s", v914)));
    local v919 = {};
    local v920 = v51.get(v36("fake_options_%s", v914));
    if v920[1] then
        v919[#v919 + 1] = "Avoid Overlap";
    end;
    if v920[2] then
        v919[#v919 + 1] = "Jitter";
    end;
    if v920[3] then
        v919[#v919 + 1] = "Randomize Jitter";
    end;
    v58.override_settings.body_options = v919;
    v58.override_settings.left_limit = v51.get(v36("left_limit_%s", v914));
    v58.override_settings.right_limit = v51.get(v36("right_limit_%s", v914));
    v58.override_settings.freestand = v51.get(v36("freestand_desync_%s", v914));
end;
v58.decide_settings = function(v921)
    -- upvalues: v51 (ref), v32 (ref), v58 (ref)
    local v922 = v51.get("enable_anti_aim_misc");
    local v923 = v32.get_game_rules();
    if v922[5] and v58.manual_side ~= 0 or v922[6] and v923.m_bWarmupPeriod then
        return v58.static_settings(true, false);
    elseif v51.get("anti_aim_mode") == "Auto presets" then
        return v58.auto_preset();
    else
        v58.default_builder(v921);
        return;
    end;
end;
v58.manuals = function()
    -- upvalues: v52 (ref), v154 (ref), v51 (ref), v58 (ref), v39 (ref), v30 (ref)
    if not v52.is_alive then
        return;
    elseif v154.is_console_open() then
        return;
    elseif v51.get_bind("Manual back") then
        v58.manual_side = 0;
        return;
    else
        if v58.last_key == v39 and v51.get_bind("Manual right") then
            v58.manual_side = v58.manual_side == 1 and 0 or 1;
            v58.last_key = v51.binded_keys["Manual right"].key;
        end;
        if v58.last_key == v39 and v51.get_bind("Manual left") then
            v58.manual_side = v58.manual_side == -1 and 0 or -1;
            v58.last_key = v51.binded_keys["Manual left"].key;
        end;
        if v58.last_key and not v30.is_virtual_key_pressed(v58.last_key) then
            v58.last_key = v39;
        end;
        return;
    end;
end;
v58.get_freestand = function()
    -- upvalues: v51 (ref)
    local v924 = rage.antiaim:get_target();
    local v925 = rage.antiaim:get_target(true);
    if v925 and v924 and v51.references.freestand:get() then
        return v924 + v925;
    else
        return 0;
    end;
end;
v58.render_manuals = function()
    -- upvalues: v52 (ref), v154 (ref), v51 (ref), v58 (ref), v29 (ref), v50 (ref), l_vector_0 (ref)
    if not v52.is_alive then
        return;
    elseif v154.is_console_open() then
        return;
    elseif not v51.get("manuals_indicators") then
        return;
    else
        local v926 = v58.manual_side == -1;
        local v927 = v58.manual_side == 1;
        local v928 = v29.preform_animation("Manual Left", v926 and 1 or 0);
        local v929 = v29.preform_animation("Manual right", v927 and 1 or 0);
        local v930 = v29.preform_animation("Scope manuals offset", v52.local_player().m_bIsScoped and 1 or 0);
        local v931 = v51.icons.manual.size / 2;
        if v928 > 0 then
            v29.push_rotation(270);
            v29.texture(v51.icons.manual.img, v50.screen_size / 2 - v931 - l_vector_0((1 + v928) * 30, v930 * 20), v51.icons.manual.size, v50.colors.accent:override(v928));
            v29.pop_rotation();
        end;
        if v929 > 0 then
            v29.texture(v51.icons.manual.img, v50.screen_size / 2 - v931 + l_vector_0((1 + v929) * 30, -v930 * 20), v51.icons.manual.size, v50.colors.accent:override(v929));
        end;
        return;
    end;
end;
v58.defensive_switch = function()
    -- upvalues: v51 (ref), v58 (ref), v39 (ref), v25 (ref)
    if not v51.get_bind("Defensive snap") and not v58.did_hit_ground then
        v51.references.hidden:override(v39);
        return;
    else
        local v932 = v58.did_hit_ground and -2 or 0;
        local v933 = v51.get("defensive_pitch") + v932;
        local v934 = v51.get("defensive_yaw") + v932;
        local v935 = v51.get("defensive_settings");
        local v936 = v935[3] and -90 or -45;
        local v937 = v935[3] and 90 or 45;
        v51.references.hidden:override(true);
        if v935[1] then
            value = v25.lerp(89, -89, v25.sin(globals.curtime * (20 - v933) % 1));
            rage.antiaim:override_hidden_pitch(value);
        else
            if globals.tickcount % v933 == 0 then
                v58.switch_pitch = v58.switch_pitch * -1;
            end;
            rage.antiaim:override_hidden_pitch(v58.switch_pitch == 1 and -72 or 70);
        end;
        if v935[2] then
            value = v25.lerp(v936, v937, v25.sin(globals.curtime * (20 - v934) % 1));
            rage.antiaim:override_hidden_yaw_offset(value);
        else
            if globals.tickcount % v934 == 0 then
                v58.switch_yaw = v58.switch_yaw * -1;
            end;
            rage.antiaim:override_hidden_yaw_offset(v58.switch_yaw == 1 and v937 or v936);
        end;
        return;
    end;
end;
v58.update_freestand = function()
    -- upvalues: v58 (ref), v39 (ref), v51 (ref), v52 (ref), v25 (ref), l_vector_0 (ref), v30 (ref)
    v58.override_freestand = v39;
    if not v51.get("enable_anti_aim_misc")[7] then
        return;
    elseif not v52.thread() then
        return;
    else
        local v938 = 0;
        local v939 = 0;
        local v940 = v52.local_player():get_origin();
        local v941 = v52.thread():get_origin();
        local v942 = v940:calculate_angle(v941);
        local v943 = v940:dist(v941);
        if v52.thread():is_dormant() and v943 > 2000 then
            return;
        else
            local v944 = v52.local_player():get_hitbox_position(1);
            local v945 = v52.local_player().m_vecVelocity:length();
            v945 = v25.clamp(v945, 30, 200);
            local v946 = #v58.angles;
            if v51.get("limit_freestand") then
                if v946 ~= 4 then
                    v58.angles = {
                        [1] = 90, 
                        [2] = 45, 
                        [3] = -45, 
                        [4] = 90
                    };
                end;
            elseif v946 == 4 then
                v58.angles = {
                    [1] = 90, 
                    [2] = 75, 
                    [3] = 60, 
                    [4] = 30, 
                    [5] = -30, 
                    [6] = 60, 
                    [7] = 75, 
                    [8] = 90
                };
            end;
            for v947 = 1, #v58.angles do
                local v948 = v58.angles[v947];
                local v949 = v25.rad(v942 + v948);
                local v950 = v944 + l_vector_0(v25.cos(v949) * v945, v25.sin(v949) * v945, 0);
                local v951 = v30.get_worst_damage(v52.thread(), v950);
                if v948 > 0 then
                    if v938 < v951 then
                        v938 = v951;
                    end;
                elseif v939 < v951 then
                    v939 = v951;
                end;
            end;
            if v938 + v939 == 0 then
                return;
            else
                local v952 = v51.get("invert_freestand");
                if v939 < v938 then
                    v58.override_freestand = v952 and 1 or 0;
                elseif v938 < v939 then
                    v58.override_freestand = v952 and 0 or 1;
                else
                    v58.override_freestand = 2;
                end;
                return;
            end;
        end;
    end;
end;
v58.destroy = function()
    -- upvalues: v58 (ref), v57 (ref), v51 (ref), v39 (ref)
    v58.neverlose_ui(false);
    v57.save();
    v51.references.freestand:override(v39);
    v51.references.yaw:override(v39);
    v51.references.yaw_base:override(v39);
    v51.references.pitch:override(v39);
    v51.references.yaw_offset:override(v39);
    v51.references.yaw_modifier:override(v39);
    v51.references.yaw_modifier_offset:override(v39);
    v51.references.left_limit:override(v39);
    v51.references.right_limit:override(v39);
    v51.references.body_yaw_options:override(v39);
    v51.references.freestand_desync:override(v39);
    v51.references.anti_aim_enable:override(v39);
    v51.references.hidden:override(v39);
end;
v58.main = function(v953)
    -- upvalues: v51 (ref), v58 (ref), v52 (ref)
    if not v51.get("override_anti_aim") then
        if not v58.fix_close then
            v58.destroy();
            v58.fix_close = true;
        end;
        return;
    else
        v58.fix_close = false;
        if not v52.is_alive then
            return;
        else
            v51.references.body_yaw:override(true);
            v58.update_freestand();
            v58.preform_general(v953);
            v58.decide_settings(v953);
            v58.preform_overrides(v953);
            return;
        end;
    end;
end;
v58.each_frame = function()
    -- upvalues: v51 (ref), v52 (ref), v58 (ref)
    if not v51.get("override_anti_aim") then
        return;
    elseif not v52.is_alive then
        return;
    else
        v58.defensive_switch();
        v58.render_manuals();
        return;
    end;
end;
v60.settings = {};
v60.render = function()
    -- upvalues: v51 (ref), v39 (ref), v52 (ref), v50 (ref), v29 (ref), v25 (ref), l_vector_0 (ref)
    v51.references.scope:override(v39);
    if not v51.get("enable_scope") then
        return;
    elseif not v52.is_alive then
        return;
    else
        local v954 = v52.local_player():get_player_weapon();
        if not v954 then
            return;
        else
            v51.references.scope:override("Remove All");
            local v955 = {
                origin = v51.get("scope_origin"), 
                width = v51.get("scope_width"), 
                inner_color = v51.get("scope_inner_color"), 
                outer_color = v51.get("scope_outer_color"), 
                lines = v51.get("scope_lines"), 
                settings = v51.get("scope_settings")
            };
            local l_m_bIsScoped_1 = v52.local_player().m_bIsScoped;
            local v957 = v954:get_inaccuracy() * 100;
            local v958 = v50.screen_size / 2;
            local v959 = v29.preform_animation("Scope fade", l_m_bIsScoped_1 and 1 or 0);
            local v960 = v29.preform_animation("Scope spread", v955.settings[1] and l_m_bIsScoped_1 and v957 or 0);
            v29.preform_animation("Scope zoom", (v954.m_zoomLevel == 2 and 30 or 0) * v959);
            local v961 = {
                outer = v955.outer_color:override(v959), 
                inner = v955.inner_color:override(v959)
            };
            local v962 = v25.abs(v959 - 1);
            local v963 = v955.origin + v960;
            if v959 == 0 then
                return;
            else
                local v964 = v955.width + v963;
                local v965 = v955.width * v962 + v963;
                if v955.lines[1] then
                    v29.gradient(l_vector_0(v958.x, v958.y - v964), l_vector_0(v958.x + 1, v958.y - v965), v961.outer, v961.outer, v961.inner, v961.inner);
                end;
                if v955.lines[2] then
                    v29.gradient(l_vector_0(v958.x - v964, v958.y), l_vector_0(v958.x - v965, v958.y + 1), v961.outer, v961.inner, v961.outer, v961.inner);
                end;
                if v955.lines[3] then
                    v29.gradient(l_vector_0(v958.x + v965 + 1, v958.y), l_vector_0(v958.x + v964 + 1, v958.y + 1), v961.inner, v961.outer, v961.inner, v961.outer);
                end;
                if v955.lines[4] then
                    v29.gradient(l_vector_0(v958.x, v958.y + v965 + 1), l_vector_0(v958.x + 1, v958.y + v964 + 1), v961.inner, v961.inner, v961.outer, v961.outer);
                end;
                return;
            end;
        end;
    end;
end;
v60.view = function(v966)
    -- upvalues: v51 (ref), v52 (ref), v29 (ref)
    if not v51.get("enable_scope") or not v51.get("scope_settings")[2] then
        return;
    elseif not v52.is_alive then
        return;
    else
        local v967 = v29.get_animation_value("Scope zoom");
        if not v967 or v967 == 0 then
            return;
        else
            v966.fov = v966.fov - v967;
            return;
        end;
    end;
end;
v60.destroy = function()
    -- upvalues: v51 (ref), v39 (ref)
    v51.references.scope:override(v39);
end;
v61.cvars = {
    offset_x = cvar.viewmodel_offset_x, 
    offset_y = cvar.viewmodel_offset_y, 
    offset_z = cvar.viewmodel_offset_z, 
    fov = cvar.viewmodel_fov, 
    aspect_ration = cvar.r_aspectratio, 
    righthand = cvar.cl_righthand
};
v61.fix = {
    aspect_ration = false, 
    change_hand = false, 
    view_model = false, 
    aspect_ration_value = true, 
    original_hand = v61.cvars.righthand:int(), 
    aspect_ration_original = v50.screen_size.x / v50.screen_size.y
};
v29.create_animation("Aspect ratio", v61.fix.aspect_ration_original);
v61.override_view_model = function(v968, v969, v970, v971)
    -- upvalues: v61 (ref)
    v61.cvars.offset_x:int(v968, true);
    v61.cvars.offset_y:int(v969, true);
    v61.cvars.offset_z:int(v970, true);
    v61.cvars.fov:int(v971, true);
end;
v61.override_aspect_ration = function(v972)
    -- upvalues: v61 (ref)
    v61.cvars.aspect_ration:float(v972, true);
    v61.fix.aspect_ration_value = false;
end;
v61.override_knife = function()
    -- upvalues: v51 (ref), v52 (ref), v64 (ref), v61 (ref)
    value = v51.get("view_knife_opposite");
    player = v52.local_player();
    if not player then
        return;
    else
        weapon = player:get_player_weapon();
        if not weapon then
            return;
        else
            weapon_type = v64.weapons_type_sorted[weapon:get_weapon_info().weapon_type];
            if weapon_type == 3 then
                if value then
                    new_value = v61.fix.original_hand == 1 and 0 or 1;
                    v61.cvars.righthand:int(new_value);
                    v61.fix.change_hand = true;
                end;
                return;
            else
                if v61.fix.change_hand then
                    v61.cvars.righthand:int(v61.cvars.righthand:int() == 1 and 0 or 1);
                    v61.fix.change_hand = false;
                end;
                v61.fix.original_hand = v61.cvars.righthand:int();
                return;
            end;
        end;
    end;
end;
v61.view_model = function()
    -- upvalues: v51 (ref), v61 (ref)
    if not v51.get("enable_view_model") then
        if v61.fix.view_model then
            v61.override_view_model(0, 0, 0, 60);
            v61.cvars.righthand:int(v61.fix.original_hand);
            v61.fix.view_model = false;
        end;
        return;
    else
        v61.override_view_model(v51.get("view_offset_x"), v51.get("view_offset_y"), v51.get("view_offset_z"), v51.get("view_offset_fov"));
        v61.override_knife();
        v61.fix.view_model = true;
        return;
    end;
end;
v61.aspect_ratio = function()
    -- upvalues: v29 (ref), v61 (ref), v51 (ref), v50 (ref)
    local v973 = v29.get_animation_value("Aspect ratio");
    if v973 == 0 then
        v973 = v61.fix.aspect_ration_original;
    end;
    if v61.fix.aspect_ration_value then
        v61.override_aspect_ration(v973);
    end;
    local v974 = v51.get("aspect_ratio");
    if v974 == 0 then
        if v973 ~= v61.fix.aspect_ration_original then
            v29.preform_animation("Aspect ratio", v61.fix.aspect_ration_original);
            v61.fix.aspect_ration_value = true;
        end;
        return;
    else
        local v975 = v974 * 0.01;
        local v976 = v50.screen_size.x * v975 / v50.screen_size.y;
        v29.preform_animation("Aspect ratio", v976);
        v61.fix.aspect_ration_value = true;
        return;
    end;
end;
v61.render = function()
    -- upvalues: v52 (ref), v61 (ref)
    if not v52.is_alive then
        return;
    else
        v61.view_model();
        v61.aspect_ratio();
        return;
    end;
end;
v61.destroy = function()
    -- upvalues: v61 (ref)
    v61.fix.aspect_ration_value = true;
    v61.override_aspect_ration(0);
    v61.override_view_model(0, 0, 0, 60);
end;
v62.cvars = {
    disable_bloom = cvar.mat_disable_bloom, 
    model_brightness = cvar.r_modelAmbientMin
};
v62.fixed_bloom = false;
v62.fixed_splash_color = false;
v62.impact_material = v39;
v62.impact_color = l_color_0(255);
v62.override_bloom = function(v977, v978, v979, v980, v981)
    -- upvalues: v62 (ref), v32 (ref), l_ipairs_0 (ref)
    v62.cvars.model_brightness:float(v977, true);
    local v982 = v32.get_entities(69);
    for _, v984 in l_ipairs_0(v982) do
        v984.m_bUseCustomAutoExposureMin = v978;
        v984.m_bUseCustomAutoExposureMax = v978;
        v984.m_flCustomAutoExposureMin = v979;
        v984.m_flCustomAutoExposureMax = v980;
        v984.m_flCustomBloomScale = v981;
    end;
end;
v62.override_material_color = function(v985)
    -- upvalues: v62 (ref), v154 (ref)
    if not v62.impact_material then
        return;
    else
        v154.alpha_modulate(v62.impact_material, v985.a / 255);
        v154.color_modulate(v62.impact_material, v985.r / 255, v985.g / 255, v985.b / 255);
        v62.impact_color = v985;
        return;
    end;
end;
v62.render = function()
    -- upvalues: v62 (ref), v154 (ref), v39 (ref), v51 (ref), v27 (ref)
    if not globals.is_in_game then
        v62.fixed_splash_color = true;
        return;
    else
        if v62.fixed_splash_color then
            v62.impact_material = v154.find_material_by_name("effects/spark", v39, true, v39);
            v62.override_material_color(v51.get("impacts_color"));
            v62.fixed_splash_color = false;
        end;
        if not v51.get("enable_bloom") then
            if v62.fixed_bloom then
                v51.references.removlas:override(v51.references.removlas:get());
                v62.override_bloom(0, false, 0, 0, 0);
                v62.fixed_bloom = false;
            end;
            return;
        else
            local v986 = {
                bloom_scale = v51.get("bloom_scale") / 10, 
                exposure = v51.get("exposure_scale") / 100, 
                model_brightness = v51.get("model_brightness") / 10
            };
            if v62.cvars.disable_bloom:int() == 1 then
                v62.cvars.disable_bloom:int(0, true);
            end;
            v62.override_bloom(v986.model_brightness, true, v986.exposure, v986.exposure, v986.bloom_scale);
            local v987 = v51.references.removlas:get();
            v27.delete(v987, "Post Processing");
            v51.references.removlas:override(v987);
            v62.fixed_bloom = true;
            return;
        end;
    end;
end;
v62.impact = function(v988)
    -- upvalues: v51 (ref), v52 (ref), v32 (ref), v62 (ref), v154 (ref), v39 (ref), v33 (ref)
    if not v51.get("enable_impacts") then
        return;
    elseif not v52.is_alive then
        return;
    else
        local v989 = v32.get(v988.userid, true);
        if not v989 then
            return;
        else
            local v990 = v51.get("only_local_impacts");
            local v991 = v51.get("impacts_color");
            if v990 and v989 ~= v52.local_player() then
                return;
            else
                local l_x_1 = v988.x;
                local l_y_1 = v988.y;
                local l_z_1 = v988.z;
                if not l_x_1 or not l_y_1 or not l_z_1 then
                    return;
                else
                    if not v62.impact_material then
                        v62.impact_material = v154.find_material_by_name("effects/spark", v39, true, v39);
                    end;
                    if v991 ~= v62.impact_color then
                        v62.override_material_color(v991);
                    end;
                    v154.sparks(v33.vector_struct(l_x_1, l_y_1, l_z_1), 3, 2, v33.vector_struct());
                    return;
                end;
            end;
        end;
    end;
end;
v62.destroy = function()
    -- upvalues: v51 (ref), v62 (ref)
    v51.references.removlas:override(v51.references.removlas:get());
    v62.override_bloom(0, false, 0, 0, 0);
end;
v63.get_animation_overlay = function(v995, v996)
    -- upvalues: v33 (ref)
    local v997 = v33.cast("void***", v995[0]);
    return v33.cast("animation_overlay_t**", v33.cast("char*", v997) + 10640)[0][v996 or 0];
end;
v63.get_animation_state = function(v998)
    -- upvalues: v33 (ref)
    local v999 = v33.cast("void***", v998[0]);
    return v33.cast("animation_state_t**", v33.cast("char*", v999) + 39264)[0];
end;
v63.update = function(v1000)
    -- upvalues: v52 (ref), v63 (ref), v51 (ref), v58 (ref), v39 (ref)
    if not v1000 then
        return;
    elseif not v52.is_alive then
        return;
    elseif v1000 ~= v52.local_player() then
        return;
    else
        local v1001 = {
            [12] = v63.get_animation_overlay(v1000, 12), 
            [6] = v63.get_animation_overlay(v1000, 6), 
            [7] = v63.get_animation_overlay(v1000, 7)
        };
        if not v1001[12] or not v1001[6] or not v1001[7] then
            return;
        else
            local v1002 = v63.get_animation_state(v1000);
            if not v1002 then
                return;
            else
                local v1003 = {
                    on_land = v51.get("on_land_options"), 
                    air_legs = v51.get("air_legs_movement"), 
                    air_legs_factor = v51.get("air_legs_movement_factor"), 
                    air_body_factor = v51.get("air_body_lean_factor"), 
                    move_legs = v51.get("move_legs_movement"), 
                    move_legs_factor = v51.get("move_legs_movement_factor"), 
                    move_body_factor = v51.get("move_body_lean_factor")
                };
                v58.did_hit_ground = v1002.m_hit_ground_animation;
                if v1003.on_land == "Disable pitch" then
                    if v1002.m_hit_ground_animation and not common.is_button_down(32) then
                        v1000.m_flPoseParameter[12] = 0.5;
                    end;
                elseif v1003.on_land == "Disable crouch" then
                    v1002.m_hit_ground_animation = false;
                    v1002.m_hit_ground_weight = 1;
                    v1002.m_hit_ground_cycle = 0;
                end;
                local v1004 = v1000.m_vecVelocity:length2d();
                if v52.is_in_air then
                    if v1003.air_body_factor > 0 then
                        v1001[12].m_weight = v1003.air_body_factor / 100;
                        if v1003.move_body_factor == 101 then
                            v1001[7].m_weight = 1;
                            v1001[7].m_sequence = 7;
                        end;
                    end;
                    if v1003.air_legs == "Static" then
                        v1000.m_flPoseParameter[6] = 1 - v1003.air_legs_factor / 100;
                    end;
                    if v1003.air_legs == "Move" and v1004 > 5 then
                        v1001[6].m_weight = 1 - v1003.air_legs_factor / 100;
                    end;
                elseif v1004 > 5 and not v51.references.slow_walk:get() then
                    if v1003.move_body_factor > 0 then
                        v1001[12].m_weight = v1003.move_body_factor / 100;
                        if v1003.move_body_factor == 101 then
                            v1001[7].m_weight = 1;
                            v1001[7].m_sequence = 7;
                        end;
                    end;
                    if v1003.move_legs == "Static" then
                        v51.references.legs_movement:override("Sliding");
                        v1000.m_flPoseParameter[0] = v1003.move_legs_factor / 100;
                    end;
                    if v1003.move_legs == "Jitter" then
                        v51.references.legs_movement:override("Sliding");
                        if globals.tickcount % 4 > 1 then
                            v1000.m_flPoseParameter[0] = v1003.move_legs_factor / 100;
                        end;
                    end;
                    if v1003.move_legs == "Move" then
                        v51.references.legs_movement:override("Walking");
                        v1000.m_flPoseParameter[7] = v1003.move_legs_factor / 100;
                    end;
                end;
                if v1003.move_legs == "Regular" then
                    v51.references.legs_movement:override(v39);
                end;
                return;
            end;
        end;
    end;
end;
v63.destroy = function()
    -- upvalues: v51 (ref), v39 (ref)
    v51.references.legs_movement:override(v39);
end;
v63.transparency = function(v1005)
    -- upvalues: v51 (ref), v52 (ref), v29 (ref)
    if not v51.get("animate_transparency") then
        return;
    elseif not v52.local_player() then
        return;
    else
        local v1006 = v52.local_player():get_player_weapon();
        if not v1006 then
            return;
        else
            local v1007 = v1006:get_weapon_info().weapon_type == 9;
            if not v52.local_player().m_bIsScoped then
                local _ = v1007;
            end;
            return (v29.preform_animation("Local transperecy", v1005, 30, 30));
        end;
    end;
end;
v64.enable = false;
v64.fixed_chat = false;
v64.safe_zone = l_vector_0(0, 0);
v64.fade = 0;
v64.prepare_ctrl = false;
v64.is_dead = false;
v64.player = v39;
v64.cvars = {
    freeze_time = cvar.mp_freezetime, 
    c4_timer = cvar.mp_c4timer, 
    draw_hud = cvar.cl_drawhud, 
    safe_zone_x = cvar.safezonex, 
    safe_zone_y = cvar.safezoneY, 
    crosshair_size = cvar.cl_crosshairsize, 
    crosshair_dot = cvar.cl_crosshairdot, 
    crosshair_gap = cvar.cl_crosshairgap, 
    crosshair_color = {
        r = cvar.cl_crosshaircolor_r, 
        g = cvar.cl_crosshaircolor_g, 
        b = cvar.cl_crosshaircolor_b, 
        a = cvar.cl_crosshairalpha
    }, 
    crosshair_t = cvar.cl_crosshair_t, 
    crosshair_outline = cvar.cl_crosshair_drawoutline, 
    hide_hud = cvar.hidehud
};
v64.weapons_type_sorted = {
    [0] = 3, 
    [1] = 2, 
    [2] = 1, 
    [3] = 1, 
    [4] = 1, 
    [5] = 1, 
    [6] = 1, 
    [7] = nil, 
    [8] = nil, 
    [9] = 4, 
    [10] = nil, 
    [11] = nil, 
    [12] = nil, 
    [13] = nil, 
    [14] = nil, 
    [15] = nil, 
    [16] = 3
};
v64.global_weapon_data = {
    last = v39, 
    time = globals.realtime
};
v64.weapons_names_load = {
    [1] = "usp_silencer", 
    [2] = "usp_silencer_off", 
    [3] = "inferno", 
    [4] = "hegrenade", 
    [5] = "flashbang", 
    [6] = "smokegrenade", 
    [7] = "decoy", 
    [8] = "molotov", 
    [9] = "ssg08", 
    [10] = "awp", 
    [11] = "g3sg1", 
    [12] = "scar20", 
    [13] = "deagle", 
    [14] = "revolver", 
    [15] = "glock", 
    [16] = "cz75a", 
    [17] = "p250", 
    [18] = "fiveseven", 
    [19] = "elite", 
    [20] = "tec9", 
    [21] = "hkp2000", 
    [22] = "mac10", 
    [23] = "mp9", 
    [24] = "mp7", 
    [25] = "ump45", 
    [26] = "bizon", 
    [27] = "p90", 
    [28] = "galilar", 
    [29] = "famas", 
    [30] = "ak47", 
    [31] = "m4a1", 
    [32] = "m4a1_silencer", 
    [33] = "m4a1_silencer_off", 
    [34] = "sg556", 
    [35] = "aug", 
    [36] = "nova", 
    [37] = "xm1014", 
    [38] = "sawedoff", 
    [39] = "mag7", 
    [40] = "m249", 
    [41] = "negev", 
    [42] = "knife_m9_bayonet", 
    [43] = "knife_widowmaker", 
    [44] = "knife", 
    [45] = "bayonet", 
    [46] = "knife_css", 
    [47] = "knife_flip", 
    [48] = "knife_gut", 
    [49] = "knife_karambit", 
    [50] = "knife_tactical", 
    [51] = "knife_falchion", 
    [52] = "knife_survival_bowie", 
    [53] = "knife_butterfly", 
    [54] = "knife_push", 
    [55] = "knife_cord", 
    [56] = "knife_canis", 
    [57] = "knife_ursus", 
    [58] = "knife_gypsy_jackknife", 
    [59] = "knife_outdoor", 
    [60] = "knife_stiletto", 
    [61] = "knife_skeleton", 
    [62] = "knife_t", 
    [63] = "planted_c4", 
    [64] = "taser"
};
v64.round_data = {
    message = "", 
    team_won = 0, 
    end_time = 0, 
    bomb_time = 0, 
    is_bomb_planted = false, 
    show_end = 0
};
v64.end_particals = {
    [1] = {
        [1] = nil, 
        [2] = 0, 
        [3] = 1, 
        [1] = l_vector_0(-100, 120)
    }, 
    [2] = {
        [1] = nil, 
        [2] = 0, 
        [3] = 1.1, 
        [1] = l_vector_0(100, 110)
    }, 
    [3] = {
        [1] = nil, 
        [2] = 0, 
        [3] = 1.5, 
        [1] = l_vector_0(-70, 100)
    }, 
    [4] = {
        [1] = nil, 
        [2] = 0, 
        [3] = 2, 
        [1] = l_vector_0(60, 150)
    }, 
    [5] = {
        [1] = nil, 
        [2] = 0, 
        [3] = 2.3, 
        [1] = l_vector_0(-120, 120)
    }, 
    [6] = {
        [1] = nil, 
        [2] = 0, 
        [3] = 3, 
        [1] = l_vector_0(-40, 100)
    }
};
v64.enable_type = {
    all = false, 
    team = false
};
v64.csgo_hud = panorama.loadstring("        var is_visible = false;\n\n        var change_hud_state = function(new_opacity) {\n            var ctx_panel = $.GetContextPanel();\n            ctx_panel.FindChildTraverse(\"HudBottomRight\").style.opacity   = new_opacity;\n            ctx_panel.FindChildTraverse(\"HudHealthArmor\").style.opacity   = new_opacity;\n            ctx_panel.FindChildTraverse(\"HudTeamCounter\").style.opacity   = new_opacity;\n            ctx_panel.FindChildTraverse(\"StatusPanel\").style.opacity      = new_opacity;\n            ctx_panel.FindChildTraverse(\"HudDeathNotice\").style.opacity   = new_opacity;\n            ctx_panel.FindChildTraverse(\"HudWinPanel\").style.opacity      = new_opacity;\n            ctx_panel.FindChildTraverse(\"HudMoney\").style.opacity         = new_opacity;\n            ctx_panel.FindChildTraverse(\"MoneyBG\").style.opacity          = new_opacity;\n\n        }\n\n        return {\n            change_hud_state: change_hud_state,\n        }\n    ", "CSGOHud")();
v64.string_to_send = "";
v64.weapons_icons = {};
v64.deaths = {};
v64.messages = {};
v64.last_error = "";
v64.initialize = function()
    -- upvalues: v64 (ref), v29 (ref), v26 (ref), v36 (ref)
    for v1009 = 1, #v64.weapons_names_load do
        local v1010 = v64.weapons_names_load[v1009];
        v64.weapons_icons[v1010] = v29.load_image_from_file(v26.format("materials/panorama/images/icons/equipment/%s.svg", v1010));
        if not v64.weapons_icons[v1010] then
            v64.last_error = v36("failed to load %s weapon icon", v1010);
            return false;
        end;
    end;
    return true;
end;
v64.setup = function()
    -- upvalues: v51 (ref), v52 (ref), v39 (ref), v64 (ref), v29 (ref), v32 (ref), l_vector_0 (ref), v50 (ref)
    local v1011 = v51.get("enable_hud") and v52.local_player() ~= v39;
    if v1011 then
        v64.fade = v29.do_animation(v64.fade, 1);
    else
        v64.fade = v29.do_animation(v64.fade, 0);
    end;
    v64.enable = v64.fade > 0;
    if not v52.local_player() then
        v64.player = v39;
    elseif not v52.is_alive then
        v64.player = v32.get(v52.local_player().m_hObserverTarget);
    else
        v64.player = v32.get_local_player();
    end;
    if not v1011 and not v64.enable then
        if v64.fixed_chat then
            v64.csgo_hud.change_hud_state(1);
            v64.fixed_chat = false;
        end;
        return;
    else
        local v1012 = l_vector_0(v50.screen_size.x / 2 - 10, v50.screen_size.y / 2 - 10);
        v64.safe_zone.x = v1012.x * (1 - v64.cvars.safe_zone_x:float());
        v64.safe_zone.y = v1012.y * (1 - v64.cvars.safe_zone_y:float());
        v64.fixed_chat = true;
        v64.csgo_hud.change_hud_state(0);
        return;
    end;
end;
v64.destroy = function()
    -- upvalues: v64 (ref)
    v64.csgo_hud.change_hud_state(1);
    v64.fixed_chat = false;
end;
v64.crosshair = function()
    -- upvalues: v64 (ref), l_color_0 (ref), v50 (ref), v29 (ref), l_vector_0 (ref)
    if not v64.enable then
        return;
    else
        return;
    end;
end;
v64.health_and_armor = function()
    -- upvalues: v64 (ref), v25 (ref), v29 (ref), l_vector_0 (ref), v50 (ref), v51 (ref), l_color_0 (ref)
    if not v64.enable then
        return;
    elseif not v64.player then
        return;
    else
        local v1013 = v25.min(v64.player.m_iHealth, 100);
        local v1014 = v25.min(v64.player.m_ArmorValue or 0, 100);
        local v1015 = v1013 / 100;
        local v1016 = 1 - v1015;
        local v1017 = (100 - v1014) / 100;
        local v1018 = v29.preform_animation("Headup health", v1014 > 0 and 1 or 0) * v64.fade;
        local v1019 = l_vector_0(v64.safe_zone.x + 10, v50.screen_size.y - 50 - v1018 * 35 - v64.safe_zone.y);
        v50.render_background(v1019, v1019 + l_vector_0(100, 40 + v1018 * 35), v64.fade, 5);
        v29.texture(v51.icons.health.img, v1019 + l_vector_0(10, 5), v51.icons.health.size, l_color_0(255, v1015 * 255, v1015 * 255, 180 * v64.fade));
        v50.render_accent(v1019 + l_vector_0(51, 5 + 30 * v1016), v1019 + l_vector_0(53, 35), v64.fade, 2);
        v29.text("theme::font", v1019 + l_vector_0(75, 20), l_color_0(255, 180 * v64.fade), "c", v1013);
        if v1018 > 0 then
            v29.texture(v51.icons.armor.img, v1019 + l_vector_0(10, 40), v51.icons.armor.size, l_color_0(255, 180 * v1018));
            v50.render_accent(v1019 + l_vector_0(51, 40 + 30 * v1017), v1019 + l_vector_0(53, 70), v1018, 2);
            v29.text("theme::font", v1019 + l_vector_0(75, 55), l_color_0(255, 180 * v1018), "c", v1014);
        end;
        return;
    end;
end;
v64.get_weapons = function()
    -- upvalues: v64 (ref), v39 (ref), v32 (ref)
    local v1020 = {
        [1] = {}, 
        [2] = {}, 
        [3] = {}, 
        [4] = {}, 
        [5] = {}
    };
    if v64.player.m_hMyWeapons == v39 then
        return;
    else
        for v1021 = 0, 63 do
            local v1022 = v32.get(v64.player.m_hMyWeapons[v1021]);
            if v1022 then
                local l_weapon_type_0 = v1022:get_weapon_info().weapon_type;
                local v1024 = v64.weapons_type_sorted[l_weapon_type_0] or 5;
                v1020[v1024][#v1020[v1024] + 1] = v1022;
            end;
        end;
        return v1020;
    end;
end;
v64.weapons = function()
    -- upvalues: v64 (ref), l_vector_0 (ref), v50 (ref), v39 (ref), v29 (ref), v36 (ref), v27 (ref), l_color_0 (ref), v26 (ref), v25 (ref), v51 (ref)
    if not v64.enable then
        return;
    elseif not v64.player then
        return;
    else
        local v1025 = l_vector_0(v50.screen_size.x - 10 - v64.safe_zone.x, v50.screen_size.y - v64.safe_zone.y);
        local v1026 = v64.get_weapons();
        if v1026 == v39 then
            return;
        else
            local v1027 = v64.player:get_player_weapon();
            if v1027 ~= v64.global_weapon_data.last then
                v64.global_weapon_data.last = v1027;
                v64.global_weapon_data.time = globals.realtime;
            end;
            local v1028 = v29.preform_animation("Headup global weapon", v64.global_weapon_data.time + 5 < globals.realtime and 0 or 1);
            local v1029 = 0;
            local v1030 = #v1026;
            for v1031 = 1, v1030 do
                local v1032 = v1026[v1031];
                assert(v1032, v36("Failed to index %d in weapons", v1031));
                local v1033 = v36("Headup - weapon %d", v1031);
                local v1034 = v1032[v27.find(v1032, v1027) or v1030 + 1];
                local v1035 = #v1032;
                local v1036 = v36("%s width", v1033);
                local v1037 = v36("%s warning", v1033);
                local v1038 = {
                    active = v29.preform_animation(v36("%s active", v1033), v1035 > 0 and v1034 and 1 or 0), 
                    valid = v29.preform_animation(v36("%s valid", v1033), v1035 > 0 and 1 or 0), 
                    warning = v29.get_animation_value(v1037), 
                    width = v29.get_animation_value(v1036)
                };
                local v1039 = v1038.active == 1 and 1 or v1028;
                local v1040 = v64.fade * v1039 * v1038.valid;
                if v1038.valid > 0 then
                    local v1041 = 10;
                    if v1038.warning > 0 then
                        v29.shadow(v1025 - l_vector_0(v1038.width, 50 - v1029), v1025 - l_vector_0(0, 10 - v1029), l_color_0(255, 10, 10, v1038.warning * v1040), 100, 0, 5);
                    end;
                    v50.render_background(v1025 - l_vector_0(v1038.width, 50 - v1029), v1025 - l_vector_0(0, 10 - v1029), v1040, 5);
                    for v1042 = 1, v1035 do
                        local v1043 = v1032[v1042];
                        if v1043 then
                            local v1044 = v1043:get_weapon_icon();
                            local v1045 = v1043 == v1027 and 1 or 0.5;
                            v29.texture(v1044, v1025 - l_vector_0(v1041 + v1044.width, 30 + v1044.height / 2 - v1029), l_vector_0(v1044.width, v1044.height), l_color_0(255, 180 * v1045 * v1040));
                            v1041 = v1041 + v1044.width + 10;
                        end;
                    end;
                    local v1046 = {
                        width = 0, 
                        text = "", 
                        warning = false
                    };
                    if v1031 == 1 or v1031 == 2 then
                        v1046.text = v1034 and v36("\a%s%s \aDEFAULT: %s", v50.colors.accent:to_hex(), v26.fixed_number(v1034.m_iClip1, 2), v26.fixed_number(v1034.m_iPrimaryReserveAmmoCount, 2)) or "";
                        v1046.width = (v29.original.measure_text(v29.font("theme::low"), v39, v1046.text).x + 30) * v1038.active;
                        if v1034 and v1034.m_iClip1 <= 3 then
                            v1046.warning = true;
                        end;
                    end;
                    local v1047 = v1046.warning and 40 or 0;
                    v29.preform_animation(v1037, v1046.warning and v25.abs(v25.sin(globals.realtime)) * 255 or 0);
                    v29.preform_animation(v1036, v1041 + v1046.width + v1047);
                    if v1038.active and v1034 then
                        if v1046.text ~= "" then
                            v50.render_accent(v1025 - l_vector_0(v1041 + 10, 45 - v1029), v1025 - l_vector_0(v1041 + 10 - 2, 15 - v1029), v1038.active * v64.fade);
                            v29.text("theme::low", v1025 - l_vector_0(v1038.width - 10, 38 - v1029), l_color_0(255, 180 * v1038.active * v64.fade), v39, v1046.text);
                        end;
                        if v1046.warning then
                            local v1048 = v25.abs(v25.sin(globals.realtime * 5)) * 180 * v1038.active * v64.fade;
                            v29.texture(v51.icons.warning.img, v1025 - l_vector_0(v1041 + 50, 45 - v1029), v51.icons.warning.size, l_color_0(255, 10, 10, v1048));
                        end;
                    end;
                end;
                v1029 = v1029 + -50 * v1038.valid * v1039;
            end;
            return;
        end;
    end;
end;
v64.get_player_color = function(v1049)
    -- upvalues: l_color_0 (ref), v51 (ref)
    local v1050 = l_color_0(255);
    if v1049.m_iTeamNum == 2 then
        v1050 = v51.get("hud_t_color");
    elseif v1049.m_iTeamNum == 3 then
        v1050 = v51.get("hud_ct_color");
    end;
    return v1050;
end;
v64.on_kill = function(v1051)
    -- upvalues: v64 (ref), v52 (ref), v32 (ref), v39 (ref), l_vector_0 (ref), v29 (ref), v51 (ref)
    if not v64.enable then
        return;
    elseif not v52.local_player() then
        return;
    else
        local v1052 = v32.get(v1051.attacker, true);
        local v1053 = v32.get(v1051.userid, true);
        if v1052 == v39 or v1053 == v39 then
            return;
        else
            local l_weapon_0 = v1051.weapon;
            if l_weapon_0 == v39 or l_weapon_0 == "world" then
                return;
            else
                local v1055 = v64.weapons_icons[l_weapon_0];
                if not v1055 then
                    return;
                else
                    local l_headshot_0 = v1051.headshot;
                    if l_headshot_0 == v39 then
                        return;
                    else
                        local v1057 = v1053:get_name();
                        local v1058 = v1052:get_name();
                        local v1059 = 20 / v1055.height;
                        local v1060 = l_vector_0(v1055.width * v1059, v1055.height * v1059);
                        local v1061 = v29.measure_text("theme::low", v39, v1057);
                        local v1062 = v29.measure_text("theme::low", v39, v1058);
                        local v1063 = l_headshot_0 and v51.icons.headshot.size.x + 10 or 0;
                        local v1064 = v1062.x + v1061.x + 64 + v1060.x + v1063 + 20;
                        local v1065 = v1052 == v52.local_player();
                        local v1066 = v1065 and v51.get("hud_local_color") or v64.get_player_color(v1052);
                        local v1067 = v64.get_player_color(v1053);
                        v64.deaths[#v64.deaths + 1] = {
                            fade = 0, 
                            victim = v1057, 
                            attacker = v1058, 
                            weapon = v1055, 
                            icon_size = v1060, 
                            victim_name_size = v1061, 
                            attacker_name_size = v1062, 
                            headshot_scale = v1063, 
                            width = v1064, 
                            time = globals.realtime, 
                            fade_time = v1065 and 9999 or 6, 
                            is_me = v1065, 
                            is_headshot = l_headshot_0, 
                            attacker_color = v1066, 
                            victim_color = v1067
                        };
                        return;
                    end;
                end;
            end;
        end;
    end;
end;
v64.clear_killfeed = function()
    -- upvalues: v27 (ref), v64 (ref)
    v27.clear(v64.deaths);
end;
v64.killfeed = function()
    -- upvalues: v64 (ref), l_vector_0 (ref), v50 (ref), v51 (ref), l_ipairs_0 (ref), v29 (ref), l_color_0 (ref), v39 (ref)
    if not v64.enable then
        return;
    elseif not v64.player then
        return;
    else
        local v1068 = #v64.deaths;
        if v1068 == 0 then
            return;
        else
            local v1069 = l_vector_0(v50.screen_size.x - 10 - v64.safe_zone.x, 50 + v64.safe_zone.y);
            local v1070 = 0;
            local _ = v51.get("hud_local_color");
            for _, v1073 in l_ipairs_0(v64.deaths) do
                if not v51.references.preserve_kill_feed:get() and v1073.fade_time == 9999 then
                    v1073.fade_time = 6;
                end;
                if v1073.time + v1073.fade_time < globals.realtime then
                    v1073.fade = v29.do_animation(v1073.fade, 0);
                else
                    v1073.fade = v29.do_animation(v1073.fade, 1);
                end;
                if v1073.fade ~= 0 and v1073.weapon then
                    local v1074 = v1069 + l_vector_0(-v1073.width, v1070 * 40);
                    local _ = v1070 * 40 + 30;
                    local v1076 = v1073.fade * 180;
                    local v1077 = 20 + v1073.attacker_name_size.x;
                    v50.render_background(v1074, v1074 + l_vector_0(v1077, 30), v1073.fade, 5);
                    v29.text("theme::low", v1074 + l_vector_0(10, 7), l_color_0(255, v1076), v39, v1073.attacker);
                    v1077 = v1077 + 5;
                    v50.render_accent(v1074 + l_vector_0(v1077, 5), v1074 + l_vector_0(v1077 + 2, 25), v1073.fade, 2, v1073.attacker_color:override(v1073.fade));
                    v1077 = v1077 + 7;
                    v50.render_background(v1074 + l_vector_0(v1077, 0), v1074 + l_vector_0(v1077 + 20 + v1073.icon_size.x + v1073.headshot_scale, 30), v1073.fade, 5);
                    v29.texture(v1073.weapon, v1074 + l_vector_0(v1077 + 10, 15 - v1073.icon_size.y / 2), v1073.icon_size, l_color_0(255, v1076));
                    if v1073.is_headshot then
                        v29.texture(v51.icons.headshot.img, v1074 + l_vector_0(v1077 + 20 + v1073.icon_size.x, 15 - v51.icons.headshot.size.y / 2), v51.icons.headshot.size, l_color_0(255, v1076));
                    end;
                    v1077 = v1077 + 5 + 20 + v1073.icon_size.x + v1073.headshot_scale;
                    v50.render_accent(v1074 + l_vector_0(v1077, 5), v1074 + l_vector_0(v1077 + 2, 25), v1073.fade, 2, v1073.victim_color:override(v1073.fade));
                    v1077 = v1077 + 7;
                    v50.render_background(v1074 + l_vector_0(v1077, 0), v1074 + l_vector_0(v1077 + 20 + v1073.victim_name_size.x, 30), v1073.fade, 5);
                    v29.text("theme::low", v1074 + l_vector_0(v1077 + 10, 7), l_color_0(255, v1076), v39, v1073.victim);
                    v1070 = v1070 + v1073.fade;
                end;
            end;
            if v1070 == 0 and v1068 > 0 then
                v64.clear_killfeed();
            end;
            return;
        end;
    end;
end;
v64.round_start = function(_)
    -- upvalues: v64 (ref)
    if not v64.enable then
        return;
    else
        v64.clear_killfeed();
        v64.round_data.is_bomb_planted = false;
        v64.round_data.bomb_time = globals.curtime;
        return;
    end;
end;
v64.player_death = function(v1079)
    -- upvalues: v64 (ref), v52 (ref), v32 (ref)
    if not v64.enable then
        return;
    elseif not v64.player then
        return;
    else
        local v1080 = v52.local_player();
        if not v1080 then
            return;
        else
            local v1081 = v32.get(v1079.userid, true);
            if not v1081 then
                return;
            else
                if v1080 == v1081 then
                    v64.is_dead = true;
                end;
                return;
            end;
        end;
    end;
end;
v64.player_spawn = function()
    -- upvalues: v64 (ref), v52 (ref)
    if not v64.enable then
        return;
    elseif not v64.player then
        return;
    else
        local v1082 = v52.local_player();
        if not v1082 then
            return;
        else
            if v1082:is_alive() and v64.is_dead then
                v64.is_dead = false;
                v64.clear_killfeed();
            end;
            return;
        end;
    end;
end;
v64.round_end = function(v1083)
    -- upvalues: v64 (ref)
    if not v64.enable then
        return;
    elseif v1083.winner ~= 2 and v1083.winner ~= 3 then
        return;
    else
        v64.round_data.end_time = globals.realtime;
        v64.round_data.team_won = v1083.winner;
        v64.round_data.message = (v1083.winner == 3 and "Counter Terrorist" or v1083.winner == 2 and "Terrorist" or "?") .. " won the Round";
        return;
    end;
end;
v64.bomb_planted = function(_)
    -- upvalues: v64 (ref)
    if not v64.enable then
        return;
    else
        v64.round_data.is_bomb_planted = true;
        v64.round_data.bomb_time = globals.curtime;
        return;
    end;
end;
v64.get_round_time = function()
    -- upvalues: v32 (ref), v64 (ref), v25 (ref), v36 (ref), v26 (ref)
    local v1085 = v32.get_game_rules();
    local v1086 = v64.cvars.freeze_time:int();
    local v1087 = v64.round_data.is_bomb_planted and v64.cvars.c4_timer:int() or v1085.m_bFreezePeriod and v1086 or v1085.m_iRoundTime + v1086;
    local v1088 = v64.round_data.bomb_time + v1087 - globals.curtime;
    if v1088 <= 0 then
        return "00:00";
    else
        local v1089 = v25.floor(v1088 / 60);
        local v1090 = v25.floor(v1088 % 59);
        return (v36("%s:%s", v26.fixed_number(v1089, 2), v26.fixed_number(v1090, 2)));
    end;
end;
v64.get_players_alive = function()
    -- upvalues: v32 (ref)
    local v1091 = 0;
    local v1092 = 0;
    local v1093 = v32.get_players(false, true);
    if not v1093 then
        return;
    else
        for v1094 = 1, #v1093 do
            local v1095 = v1093[v1094];
            if v1095 then
                if v1095.m_iTeamNum == 2 and v1095:is_alive() then
                    v1092 = v1092 + 1;
                end;
                if v1095.m_iTeamNum == 3 and v1095:is_alive() then
                    v1091 = v1091 + 1;
                end;
            end;
        end;
        return v1091, v1092;
    end;
end;
v64.round = function()
    -- upvalues: v64 (ref), l_vector_0 (ref), v50 (ref), v32 (ref), v51 (ref), v29 (ref), v39 (ref), v25 (ref), l_color_0 (ref)
    if not v64.enable then
        return;
    elseif not v64.player then
        return;
    else
        local v1096 = l_vector_0(v50.screen_size.x / 2, 10 + v64.safe_zone.y);
        local v1097 = v32.get_game_rules();
        local v1098 = v64.get_round_time();
        local v1099, v1100 = v64.get_players_alive();
        local v1101 = v32.get_entities("CCSTeam");
        if not v1101 then
            return;
        else
            local l_m_scoreTotal_0 = v1101[4].m_scoreTotal;
            local l_m_scoreTotal_1 = v1101[3].m_scoreTotal;
            local _ = v1097.m_bWarmupPeriod;
            local v1105 = v51.get("hud_t_color"):override(v64.fade);
            local v1106 = v51.get("hud_ct_color"):override(v64.fade);
            local v1107 = 180 * v64.fade;
            local v1108 = 0;
            local v1109 = v29.measure_text("theme::low", v39, v25.max(l_m_scoreTotal_0, l_m_scoreTotal_1)).x + 55;
            if v64.round_data.is_bomb_planted then
                v1108 = v25.abs(v25.sin(globals.realtime * 5)) * 255 * v64.fade;
                v29.shadow(v1096 + l_vector_0(-v1109, 0), v1096 + l_vector_0(v1109, 30), l_color_0(255, 10, 10, v1108), 100, 0, 5);
            end;
            v50.render_background(v1096 + l_vector_0(-v1109, 0), v1096 + l_vector_0(v1109, 30), v64.fade, 5);
            v29.text("theme::low", v1096 + l_vector_0(0, 15), l_color_0(255, v1107), "c", v1098);
            v29.text("theme::low", v1096 + l_vector_0(-50, 15), l_color_0(255, v1107), "c", l_m_scoreTotal_1);
            v29.text("theme::low", v1096 + l_vector_0(50, 15), l_color_0(255, v1107), "c", l_m_scoreTotal_0);
            v50.render_accent(v1096 + l_vector_0(-30, 2), v1096 + l_vector_0(-28, 28), v64.fade, 2, v1105);
            v50.render_accent(v1096 + l_vector_0(28, 2), v1096 + l_vector_0(30, 28), v64.fade, 2, v1106);
            v50.render_background(v1096 + l_vector_0(-150, 10), v1096 + l_vector_0(-100, 50), v64.fade, 5);
            v50.render_accent(v1096 + l_vector_0(-140, 30), v1096 + l_vector_0(-110, 32), v64.fade, 2, v1105);
            v29.text("theme::low", v1096 + l_vector_0(-125, 20), l_color_0(255, v1107), "c", v1100);
            v29.text("theme::low", v1096 + l_vector_0(-125, 40), l_color_0(255, v1107), "c", "alive");
            v50.render_background(v1096 + l_vector_0(100, 10), v1096 + l_vector_0(150, 50), v64.fade, 5);
            v50.render_accent(v1096 + l_vector_0(110, 30), v1096 + l_vector_0(140, 32), v64.fade, 2, v1106);
            v29.text("theme::low", v1096 + l_vector_0(125, 20), l_color_0(255, v1107), "c", v1099);
            v29.text("theme::low", v1096 + l_vector_0(125, 40), l_color_0(255, v1107), "c", "alive");
            local v1110 = v29.preform_animation("Headup - round end message", v64.round_data.end_time + 5 < globals.realtime and 0 or 1);
            local v1111 = (v29.measure_text("theme::low", v39, v64.round_data.message).x / 2 + 10) * v1110;
            if v1110 > 0 then
                local v1112 = l_color_0(255);
                if v64.round_data.team_won == 3 then
                    v1112 = v1106;
                elseif v64.round_data.team_won == 2 then
                    v1112 = v1105;
                end;
                for v1113 = 1, #v64.end_particals do
                    local v1114 = v64.end_particals[v1113];
                    v1114[2] = v29.do_animation(v1114[2], v64.round_data.end_time + v1114[3] < globals.realtime and 1 or 0);
                    local v1115 = 40 * v1114[2];
                    local v1116 = v25.abs(v1114[2] - 1);
                    v29.shadow(v1096 + v1114[1] - l_vector_0(v1115, v1115), v1096 + v1114[1] + l_vector_0(v1115, v1115), v1112.override(v1112, v1116), 200, 0, v1115);
                end;
                local v1117 = v1096 + l_vector_0(-v1111, 80 + 20 * v1110);
                local v1118 = v1096 + l_vector_0(v1111, 130 + 20 * v1110);
                v50.render_background(v1117, v1118, v64.fade * v1110, 5);
                v50.render_accent(v1096 + l_vector_0(-v1111 + 10, 135), v1096 + l_vector_0(v1111 - 10, 137), v64.fade * v1110, 2, v1112);
                v29.text("theme::low", v1096 + l_vector_0(0, 100 + 20 * v1110), l_color_0(255, v1107 * v1110), "c", v64.round_data.message);
            end;
            return;
        end;
    end;
end;
v64.capture_messages = function(v1119)
    -- upvalues: v64 (ref), v32 (ref), l_color_0 (ref), v51 (ref), v26 (ref)
    if not v64.enable then
        return;
    elseif not v64.player then
        return;
    else
        local v1120 = v32.get(v1119.userid, true);
        if not v1120 then
            return;
        else
            local l_text_0 = v1119.text;
            if not l_text_0 then
                return;
            else
                local v1122 = v1120:is_alive() and "" or "DEAD \194\183 ";
                local v1123 = l_color_0(255);
                if v1120.m_iTeamNum == 3 then
                    v1123 = v51.get("hud_ct_color");
                elseif v1120.m_iTeamNum == 2 then
                    v1123 = v51.get("hud_t_color");
                end;
                v1123 = v1123.to_hex(v1123);
                local v1124 = v26.format("\aDEFAULT%s\a%s%s\aDEFAULT \194\183 %s", v1122, v1123, v1120:get_name(), l_text_0);
                v1124 = v26.wrap_text(v1124, 400, "theme::low");
                v64.messages[#v64.messages + 1] = {
                    fade = 0, 
                    text = v1124, 
                    time = globals.realtime
                };
                return;
            end;
        end;
    end;
end;
v64.enable_chat = function(_, v1126, v1127)
    -- upvalues: v64 (ref), v30 (ref), v154 (ref), v28 (ref), v33 (ref), v51 (ref)
    if not v64.enable then
        return;
    elseif not v30.is_csgo_selected() then
        return;
    elseif v154.is_console_open() then
        return;
    elseif v28.get_alpha() > 0 then
        return;
    elseif v64.enable_type.all or v64.enable_type.team then
        return;
    else
        local v1128 = v33.cast("keybaord_low_level_hook_t*", v1127);
        if v1126 ~= 256 then
            return;
        else
            local l_vkCode_1 = v1128.vkCode;
            local l_key_1 = v51.binded_keys["All chat"].key;
            local l_key_2 = v51.binded_keys["Team chat"].key;
            if l_vkCode_1 == l_key_1 then
                if v64.player then
                    v64.enable_type.all = true;
                end;
                return true;
            elseif l_vkCode_1 == l_key_2 then
                if v64.player then
                    v64.enable_type.team = true;
                end;
                return true;
            else
                return;
            end;
        end;
    end;
end;
v64.capture_input = function(_, v1133, v1134)
    -- upvalues: v64 (ref), v30 (ref), v154 (ref), v33 (ref), v51 (ref), v26 (ref)
    if not v64.enable then
        return;
    elseif not v30.is_csgo_selected() then
        return;
    elseif not v64.player then
        return;
    elseif v154.is_console_open() then
        return;
    elseif not v64.enable_type.all and not v64.enable_type.team then
        return;
    else
        local v1135 = v33.cast("keybaord_low_level_hook_t*", v1134);
        local l_vkCode_2 = v1135.vkCode;
        if v1133 == 257 and l_vkCode_2 == 162 then
            v64.prepare_ctrl = false;
        end;
        if v1133 == 260 then
            local l_key_3 = v51.binded_keys["All chat"].key;
            local l_key_4 = v51.binded_keys["Team chat"].key;
            if l_vkCode_2 == l_key_3 or l_vkCode_2 == l_key_4 then
                return true;
            end;
        end;
        if v1133 ~= 256 then
            return;
        elseif l_vkCode_2 == 27 then
            v64.enable_type.all = false;
            v64.enable_type.team = false;
            return true;
        elseif l_vkCode_2 == 13 then
            if v64.enable_type.team then
                v30.console_exec(v26.format("say_team \"%s\"", v64.string_to_send));
                v64.enable_type.team = false;
            end;
            if v64.enable_type.all then
                v30.console_exec(v26.format("say \"%s\"", v64.string_to_send));
                v64.enable_type.all = false;
            end;
            v64.string_to_send = "";
            return true;
        elseif l_vkCode_2 == 8 and v64.string_to_send ~= "" then
            if v64.prepare_ctrl then
                v64.string_to_send = "";
            else
                v64.string_to_send = v26.remove_last_char(v64.string_to_send);
            end;
            return true;
        elseif l_vkCode_2 == 162 then
            v64.prepare_ctrl = true;
            return true;
        elseif v51.invalid_vk[l_vkCode_2] then
            return;
        else
            if v64.prepare_ctrl then
                if l_vkCode_2 == 67 then
                    v30.set_clipboard(v64.string_to_send);
                    return true;
                elseif l_vkCode_2 == 86 then
                    local v1139 = v30.get_clipboard();
                    v1139 = v26.clear(v1139);
                    if v1139 ~= "" then
                        v64.string_to_send = v26.format("%s%s", v64.string_to_send, v1139);
                    end;
                    return true;
                end;
            end;
            local v1140 = v33.new("BYTE[256]");
            v33.C.GetKeyboardState(v1140);
            local v1141 = v33.C.GetKeyboardLayout(0);
            local v1142 = v33.new("wchar_t[3]");
            if v33.C.ToUnicodeEx(l_vkCode_2, v1135.scanCode, v1140, v1142, 3, 0, v1141) > 0 then
                local v1143 = v30.wide_char_to_multi_byte_string(v1142);
                if v1143 ~= "" then
                    v64.string_to_send = v26.format("%s%s", v64.string_to_send, tostring(v1143));
                end;
                return true;
            else
                return;
            end;
        end;
    end;
end;
v64.chat = function()
    -- upvalues: v64 (ref), l_vector_0 (ref), v50 (ref), v29 (ref), v26 (ref), v39 (ref), l_color_0 (ref), v25 (ref), v51 (ref), v27 (ref), v111 (ref), v30 (ref)
    if not v64.enable then
        return;
    elseif not v64.player then
        return;
    else
        local v1144 = l_vector_0(v64.safe_zone.x + 10, v50.screen_size.y - 120 - v64.safe_zone.y);
        local v1145 = v64.enable_type.all or v64.enable_type.team;
        local v1146 = v29.preform_animation("Headup - input show", v1145 and 1 or 0) * v64.fade;
        if v1146 > 0 then
            local v1147 = "";
            if v64.enable_type.all then
                v1147 = "All \194\183";
            elseif v64.enable_type.team then
                v1147 = "Team \194\183";
            end;
            v1147 = v26.format("%s %s", v1147, v64.string_to_send);
            local v1148 = v29.measure_text("theme::low", v39, v1147);
            local v1149 = v29.preform_animation("Headup - input width", v1148.x + 20, 2);
            v50.render_background(v1144, v1144 + l_vector_0(v1149, 20), v1146, 4);
            v29.push_clip_rect(v1144, v1144 + l_vector_0(v1149, 20));
            v29.text("theme::low", v1144 + l_vector_0(10, 10 - v1148.y / 2), l_color_0(255, 180 * v1146), v39, v1147);
            v29.pop_clip_rect();
            local v1150 = v25.abs(v25.sin(globals.realtime * 2));
            v50.render_accent(v1144 + l_vector_0(v1149 - 6, 2), v1144 + l_vector_0(v1149 - 4, 18), v1146 * v1150, 1);
        end;
        local v1151 = #v64.messages;
        if v51.get("remove")[1] then
            if v1151 > 0 then
                v27.clear(v64.messages);
            end;
            return;
        else
            if globals.is_in_game then
                if v1151 > 20 then
                    v27.remove(v64.messages, 1);
                end;
            elseif v1151 > 0 then
                v27.clear(v64.messages);
            end;
            v1144 = l_vector_0(v64.safe_zone.x + 10, v50.screen_size.y - 140 - v64.safe_zone.y);
            local v1152 = 0;
            for v1153 = v1151, 1, -1 do
                local v1154 = v64.messages[v1153];
                if v1154 then
                    if v1145 then
                        v1154.fade = v29.do_animation(v1154.fade, 1) * v64.fade;
                    else
                        v1154.fade = v29.do_animation(v1154.fade, v1154.time + 5 < globals.realtime and 0 or 1) * v64.fade;
                    end;
                    if v1154.fade > 0 then
                        local v1155 = v29.measure_text("theme::low", v39, v1154.text);
                        v50.render_background(v1144 + l_vector_0(0, v1152 - v1155.y), v1144 + l_vector_0(v1155.x + 10, v1152 + 10), v1154.fade, 5);
                        v29.text("theme::low", v1144 + l_vector_0(5, v1152 - v1155.y + 4), l_color_0(255, 180 * v1154.fade), v39, v1154.text);
                        if (v64.enable_type.all or v64.enable_type.team) and v111.is_left_pressed and v111.mouse_position:is_in_bounds(v1144 + l_vector_0(0, v1152 - v1155.y), l_vector_0(v1155.x + 10, v1155.y + 10)) and not v51.fix_press then
                            v51.fix_press = true;
                            v30.set_clipboard(v26.clear_color_codes(v26.gsub(v1154.text, "\194\183", ":")));
                        end;
                        v1152 = v1152 - (v1155.y + 20) * v1154.fade;
                    end;
                end;
            end;
            return;
        end;
    end;
end;
v64.capture_mouse = function()
    -- upvalues: v64 (ref)
    if not v64.enable then
        return;
    elseif v64.enable_type.all or v64.enable_type.team then
        return false;
    else
        return;
    end;
end;
v64.show_spectate = function()
    -- upvalues: v64 (ref), v52 (ref), v29 (ref), v26 (ref), v39 (ref), l_vector_0 (ref), v50 (ref), v25 (ref), l_color_0 (ref)
end;
v65.database = db._DigitalDreams_Keybinds_Position or {
    y = 200, 
    x = 200
};
v65.window = v48.window("lua::keybinds", l_vector_0(v65.database.x, v65.database.y), l_vector_0(150, 30));
v65.modes = {
    [1] = "hold", 
    [2] = "toggle"
};
v65.find_value = function(v1156, v1157)
    -- upvalues: v162 (ref), v38 (ref), v27 (ref), v65 (ref), l_tostring_0 (ref)
    if v162(v1156) == "table" then
        local v1158 = {};
        for v1159 = 1, #v1156 do
            v1158[v1159] = v38(v1156[v1159], 1, 2);
        end;
        return (v27.concat(v1158, ", "));
    elseif v162(v1156) == "boolean" then
        return v65.modes[v1157];
    else
        return l_tostring_0(v1156);
    end;
end;
v65.is_any_active = false;
v65.get = function()
    -- upvalues: v28 (ref), v65 (ref), l_pairs_0 (ref), v51 (ref)
    local v1160 = {};
    local v1161 = v28.get_binds();
    v65.is_any_active = false;
    for v1162, v1163 in l_pairs_0(v51.binded_keys) do
        if not v1163.is_mode_disabled then
            v1160[#v1160 + 1] = {
                _name = v1162, 
                _is_active = v1163.value, 
                _value = v1163.mode
            };
            if v1163.value then
                v65.is_any_active = true;
            end;
        end;
    end;
    for v1164 = 1, #v1161 do
        local v1165 = v1161[v1164];
        v1160[#v1160 + 1] = {
            _name = v1165.name, 
            _is_active = v1165.active, 
            _value = v65.find_value(v1165.value, v1165.mode)
        };
        if v1165.active then
            v65.is_any_active = true;
        end;
    end;
    return v1160;
end;
v65.render = function(v1166)
    -- upvalues: v51 (ref), v65 (ref), v28 (ref), v29 (ref), v50 (ref), l_vector_0 (ref), l_color_0 (ref), v39 (ref), v25 (ref)
    local v1167 = v51.get("enable_keybinds");
    local v1168 = v65.get();
    local v1169 = #v1168;
    v1166:fade(v1167 and (v65.is_any_active or v28.get_alpha() > 0) and 1 or 0);
    if not v1167 and v1166._fade == 0 then
        return;
    else
        local v1170 = 0;
        local v1171 = 0;
        local l__position_0 = v1166._position;
        local v1173 = v29.get_animation_value("Keybinds pad width");
        v50.render_background(l__position_0 + l_vector_0(0, 2), l__position_0 + l_vector_0(38, 2 + v1166._size.y), v1166._fade, 5);
        v29.texture(v51.icons.keybinds.img, l__position_0 + l_vector_0(4, 2), v51.icons.keybinds.size, l_color_0(255, 150 * v1166._fade));
        local v1174 = v29.get_animation_value("Keybinds pad length");
        v50.render_accent(l__position_0 + l_vector_0(44, 0), l__position_0 + l_vector_0(46, v1174), v1166._fade, 2);
        local _ = v29.measure_text("theme::low", v39, "Keybinds");
        l__position_0 = l__position_0 + l_vector_0(54, 0);
        local v1176 = 4;
        for v1177 = 1, v1169 do
            local v1178 = v1168[v1177];
            local v1179 = v29.preform_animation(v1178._name, v1178._is_active and 1 or 0) * v1166._fade;
            local v1180 = v25.abs(v1179 - 1);
            local v1181 = v29.measure_text("theme::low", v39, v1178._name) + l_vector_0(10, 10);
            local v1182 = v29.measure_text("theme::low", v39, v1178._value) + l_vector_0(10, 10);
            if v1179 > 0 then
                if v1170 < v1182.x then
                    v1170 = v1182.x;
                end;
                if v1171 < v1181.x then
                    v1171 = v1181.x;
                end;
            end;
            local v1183 = l__position_0 + l_vector_0(10 * v1180, v1176);
            local v1184 = l__position_0 + l_vector_0(v1173 + 10, v1176);
            v50.render_background(v1183, v1183 + v1182, v1179, 5);
            v29.text("theme::low", v1183 + l_vector_0(5, 5), v50.colors.accent:override(v1179), v39, v1178._value);
            v50.render_background(v1184, v1184 + v1181, v1179, 5);
            v29.text("theme::low", v1184 + l_vector_0(5, 5), l_color_0(255, 180 * v1179), v39, v1178._name);
            v1176 = v1176 + 30 * v1179;
        end;
        v29.preform_animation("Keybinds pad length", v25.max(v1176, v1166._size.y), v39, 8);
        v29.preform_animation("Keybinds pad width", v1170, 1);
        v1166:override_position(l_vector_0(38, v1166._size.y));
        return;
    end;
end;
v65.destroy = function()
    -- upvalues: v65 (ref)
    db._DigitalDreams_Keybinds_Position = {
        x = v65.window._position.x, 
        y = v65.window._position.y
    };
end;
v66.database = db._DigitalDreams_Watermark_Position or {
    y = 10, 
    x = 10
};
v66.window = v48.window("lua::watermark", l_vector_0(v66.database.x, v66.database.y), l_vector_0(38, 30), v111.CENTER_ATTACH);
v66.render = function(v1185)
    -- upvalues: v51 (ref), v50 (ref), l_vector_0 (ref), v29 (ref), l_color_0 (ref), v39 (ref), v45 (ref), v30 (ref), v25 (ref), v36 (ref), v26 (ref), v111 (ref)
    local v1186 = v51.get("enable_watermark");
    local v1187 = v51.get("watermark_settings");
    v1185:fade(v1186 and 1 or 0);
    if v1185._fade == 0 then
        return;
    else
        local l__position_1 = v1185._position;
        v50.render_background(l__position_1, l__position_1 + l_vector_0(38, v1185._size.y), v1185._fade, 5);
        v29.texture(v51.icons.watermark.img, l__position_1 + l_vector_0(4, -2), v51.icons.watermark.size, l_color_0(255, 150 * v1185._fade));
        local v1189 = {
            build = v29.preform_animation("Watermark build", v1187[2] and 1 or 0) * v1185._fade, 
            name = v29.preform_animation("Watermark name", v1187[3] and 1 or 0) * v1185._fade, 
            ping = v29.preform_animation("Watermark ping", v1187[4] and 1 or 0) * v1185._fade, 
            time = v29.preform_animation("Watermark time", v1187[5] and 1 or 0) * v1185._fade
        };
        local v1190 = 50;
        if v1189.build > 0 or v1189.name > 0 or v1189.ping > 0 or v1189.time > 0 then
            local v1191 = v29.get_animation_value("Watermark width");
            v50.render_accent(l__position_1 + l_vector_0(43, 0), l__position_1 + l_vector_0(45, v1185._size.y), v1185._fade, 2);
            v50.render_background(l__position_1 + l_vector_0(50, 0), l__position_1 + l_vector_0(50 + v1191, v1185._size.y), v1185._fade, 5);
        end;
        if v1189.build > 0 then
            local v1192 = v29.measure_text("theme::low", v39, v45).x + 10;
            v29.text("theme::low", l__position_1 + l_vector_0(v1190 + 10, 7), l_color_0(255, 180 * v1189.build), v39, v45);
            v1190 = v1190 + (v1192 + 10) * v1189.build;
        end;
        if v1189.name > 0 then
            local v1193 = common.get_username();
            local v1194 = v29.measure_text("theme::low", v39, v1193).x + 10;
            v29.text("theme::low", l__position_1 + l_vector_0(v1190 + 10, 7), l_color_0(255, 180 * v1189.name), v39, v1193);
            v1190 = v1190 + (v1194 + 10) * v1189.name;
        end;
        if v1189.ping > 0 then
            local v1195 = v30.net_channel();
            local v1196 = v25.floor(v1195 and v1195.latency[1] * 1000 or 0);
            local v1197 = v36("%d ms", v1196);
            local v1198 = v29.measure_text("theme::low", v39, v1197).x + 10;
            v29.text("theme::low", l__position_1 + l_vector_0(v1190 + 10, 7), l_color_0(255, 180 * v1189.ping), v39, v1197);
            v1190 = v1190 + (v1198 + 10) * v1189.ping;
        end;
        if v1189.time > 0 then
            local v1199 = common.get_system_time();
            local v1200 = v36("%s:%s", v26.fixed_number(v1199.hours, 2), v26.fixed_number(v1199.minutes, 2));
            local v1201 = v29.measure_text("theme::low", v39, v1200).x + 10;
            v29.text("theme::low", l__position_1 + l_vector_0(v1190 + 10, 7), l_color_0(255, 180 * v1189.time), v39, v1200);
            v1190 = v1190 + (v1201 + 10) * v1189.time;
        end;
        v1185._size.x = v1190;
        v1190 = v1190 - 50;
        v29.preform_animation("Watermark width", v1190, 2);
        v1185:override_position(v1185._size);
        if not v1187[1] then
            v1185._attach = v111.CENTER_ATTACH;
        else
            v1185._attach = v111.NO_ATTACH;
        end;
        return;
    end;
end;
v66.destroy = function()
    -- upvalues: v66 (ref)
    db._DigitalDreams_Watermark_Position = {
        x = v66.window._position.x, 
        y = v66.window._position.y
    };
end;
v67.hitboxes = {
    [0] = "generic", 
    [1] = "head", 
    [2] = "chest", 
    [3] = "stomach", 
    [4] = "left arm", 
    [5] = "right arm", 
    [6] = "left leg", 
    [7] = "right leg", 
    [8] = "neck", 
    [9] = "generic", 
    [10] = "gear"
};
v67.list = {};
v67.database = db._DigitalDreams_LogSystem_Position or {
    y = 70, 
    x = 10
};
v67.window = v48.window("lua::log_system", l_vector_0(v67.database.x, v67.database.y), l_vector_0(100, 40), v111.CENTER_ATTACH);
v67.is_center = 0;
v67.rounds_count = 0;
v67.push_event = function(v1202, v1203, v1204)
    -- upvalues: v67 (ref)
    v67.list[#v67.list + 1] = {
        icon_fade = 0, 
        text_fade = 0, 
        text = v1202, 
        icon = v1203, 
        color = v1204, 
        time = globals.realtime
    };
end;
v67.get_text = function(v1205)
    -- upvalues: v36 (ref), v27 (ref)
    local v1206 = {};
    for v1207 = 1, #v1205, 2 do
        local v1208 = v1205[v1207];
        local v1209 = v1205[v1207 + 1];
        v1206[#v1206 + 1] = v36("\a%s%s", v1209:to_hex(), v1208);
    end;
    return v27.concat(v1206);
end;
v67.aim_fire = function(v1210)
    -- upvalues: v51 (ref), v39 (ref), v42 (ref), v67 (ref), l_tostring_0 (ref)
    if not v51.get("enable_logs") then
        return;
    else
        local l_state_0 = v1210.state;
        local l_target_0 = v1210.target;
        if not l_target_0 then
            return;
        else
            local v1213 = l_target_0:get_name();
            if l_state_0 == v39 then
                local v1214 = l_target_0.m_iHealth <= 0;
                local v1215 = v1210.wanted_damage > v1210.damage + 10;
                local v1216 = v51.get("logs_hit_color");
                if v1215 then
                    v1216 = v51.get("logs_falsehit_color");
                end;
                if v1214 then
                    v1216 = v51.get("logs_kill_color");
                end;
                local v1217 = v51.get("logs_hit_enable");
                local v1218 = v1215 and "false hit " or "hit ";
                if v1217[1] then
                    if v1214 then
                        print("  digital  \194\183 ", v1216, "killed ", v42, v1213, v1216, " in ", v42, v67.hitboxes[v1210.hitgroup], v1216, ", bt ", v42, l_tostring_0(v1210.backtrack), v1216, " ticks", v42);
                    else
                        print("  digital  \194\183 ", v1216, v1218, v42, v1213, v1216, "'s ", v42, v67.hitboxes[v1210.hitgroup], v1216, " for ", v42, l_tostring_0(v1210.damage), v1216, " damage (preferred ", v42, l_tostring_0(v1210.wanted_damage), v1216, "), bt ", v42, l_tostring_0(v1210.backtrack), v1216, " ticks", v42);
                    end;
                end;
                if v1217[2] then
                    local l_v39_2 = v39;
                    if v1214 then
                        l_v39_2 = {
                            [1] = "killed ", 
                            [2] = nil, 
                            [3] = nil, 
                            [4] = nil, 
                            [5] = " in ", 
                            [2] = v42, 
                            [3] = v1213, 
                            [4] = v1216, 
                            [6] = v42, 
                            [7] = v67.hitboxes[v1210.hitgroup], 
                            [8] = v1216
                        };
                    else
                        l_v39_2 = {
                            [1] = nil, 
                            [2] = nil, 
                            [3] = nil, 
                            [4] = nil, 
                            [5] = "'s ", 
                            [6] = nil, 
                            [7] = nil, 
                            [8] = nil, 
                            [9] = " for ", 
                            [10] = nil, 
                            [11] = nil, 
                            [12] = nil, 
                            [13] = " damage", 
                            [1] = v1218, 
                            [2] = v42, 
                            [3] = v1213, 
                            [4] = v1216, 
                            [6] = v42, 
                            [7] = v67.hitboxes[v1210.hitgroup], 
                            [8] = v1216, 
                            [10] = v42, 
                            [11] = l_tostring_0(v1210.damage), 
                            [12] = v1216, 
                            [14] = v42
                        };
                    end;
                    v67.push_event(v67.get_text(l_v39_2), v51.icons.hit, v1216);
                end;
                return;
            else
                local v1220 = v51.get("logs_othermiss_color");
                local v1221 = v51.get("logs_miss_enable");
                if l_state_0 == "correction" then
                    v1220 = v51.get("logs_correction_color");
                elseif l_state_0 == "spread" then
                    v1220 = v51.get("logs_spread_color");
                end;
                if v1221[1] then
                    print("  digital  \194\183 ", v1220, "missed ", v42, v1213, v1220, "'s ", v42, v67.hitboxes[v1210.wanted_hitgroup], v1220, " due to ", v42, l_state_0, v1220, " (preferred ", v42, l_tostring_0(v1210.wanted_damage), v1220, " damage), bt ", v42, l_tostring_0(v1210.backtrack), v1220, " ticks", v42);
                end;
                if v1221[2] then
                    local v1222 = {
                        [1] = "missed ", 
                        [2] = nil, 
                        [3] = nil, 
                        [4] = nil, 
                        [5] = "'s ", 
                        [6] = nil, 
                        [7] = nil, 
                        [8] = nil, 
                        [9] = " due to ", 
                        [2] = v42, 
                        [3] = v1213, 
                        [4] = v1220, 
                        [6] = v42, 
                        [7] = v67.hitboxes[v1210.wanted_hitgroup], 
                        [8] = v1220, 
                        [10] = v42, 
                        [11] = l_state_0, 
                        [12] = v1220
                    };
                    v67.push_event(v67.get_text(v1222), v51.icons.miss, v1220);
                end;
                return;
            end;
        end;
    end;
end;
v67.grenades = function(v1223)
    -- upvalues: v51 (ref), v52 (ref), v32 (ref), l_tostring_0 (ref), v42 (ref), v67 (ref)
    if not v51.get("enable_logs") then
        return;
    elseif not v52.local_player() then
        return;
    else
        local v1224 = v32.get(v1223.attacker, true);
        if not v1224 or v1224 ~= v52.local_player() then
            return;
        else
            local v1225 = v32.get(v1223.userid, true);
            if not v1225 then
                return;
            else
                local v1226 = v1225:get_name();
                local l_dmg_health_0 = v1223.dmg_health;
                if not l_dmg_health_0 then
                    return;
                else
                    local v1228 = l_tostring_0(v1223.weapon);
                    local v1229 = "";
                    if v1228 == "inferno" or v1228 == "hegrenade" then
                        v1229 = v1228 == "inferno" and "burned " or "naded ";
                        local v1230 = v1225.m_iHealth <= 0 and v51.get("logs_kill_color") or v51.get("logs_hit_color");
                        local v1231 = v51.get("logs_hit_enable");
                        if v1231[1] then
                            print("  digital  \194\183 ", v1230, v1229, v42, v1226, v1230, " for ", v42, l_tostring_0(l_dmg_health_0), v1230, " damage", v42);
                        end;
                        if v1231[2] then
                            local v1232 = {
                                [1] = nil, 
                                [2] = nil, 
                                [3] = nil, 
                                [4] = nil, 
                                [5] = " for ", 
                                [6] = nil, 
                                [7] = nil, 
                                [8] = nil, 
                                [9] = " damage", 
                                [1] = v1229, 
                                [2] = v42, 
                                [3] = v1226, 
                                [4] = v1230, 
                                [6] = v42, 
                                [7] = l_tostring_0(l_dmg_health_0), 
                                [8] = v1230, 
                                [10] = v42
                            };
                            v67.push_event(v67.get_text(v1232), v51.icons.hit, v1230);
                        end;
                        return;
                    else
                        return;
                    end;
                end;
            end;
        end;
    end;
end;
v67.purshes = function(v1233)
    -- upvalues: v51 (ref), v52 (ref), v32 (ref), v26 (ref), v42 (ref)
    if not v51.get("enable_logs") or not v51.get("logs_purchase_enable") then
        return;
    elseif not v52.local_player() then
        return;
    else
        local v1234 = v32.get(userid, true);
        if not v1234 then
            return;
        elseif v1233.team == v52.local_player().m_iTeamNum then
            return;
        else
            local v1235 = v51.get("logs_purchase_color");
            local l_weapon_1 = v1233.weapon;
            local v1237 = v1234:get_name();
            if v26.find(l_weapon_1, "weapon_") then
                l_weapon_1 = v26.gsub(l_weapon_1, "weapon_", "");
            end;
            if v26.find(l_weapon_1, "item_") then
                l_weapon_1 = v26.gsub(l_weapon_1, "item_", "");
            end;
            print("  digital  \194\183 ", v1235, "player ", v42, v1237, v1235, " bought ", v42, l_weapon_1, v1235);
            return;
        end;
    end;
end;
v67.round_start = function()
    -- upvalues: v51 (ref), v67 (ref), v50 (ref), v42 (ref), l_tostring_0 (ref)
    if v51.get("enable_logs") then
        v67.rounds_count = v67.rounds_count + 1;
        print("\n");
        print("  digital  \194\183 ", v50.colors.accent, "round number ", v42, l_tostring_0(v67.rounds_count), v50.colors.accent);
    end;
end;
v67.calculate = function(v1238)
    -- upvalues: v29 (ref), v39 (ref), l_vector_0 (ref)
    local v1239 = v29.measure_text("theme::low", v39, v1238.text);
    return l_vector_0(50 + (v1239.x + 10 + 12) * v1238.text_fade, 30), v1239;
end;
v67.render_log = function(v1240, v1241, v1242, v1243)
    -- upvalues: v50 (ref), l_vector_0 (ref), v29 (ref), l_color_0 (ref), v39 (ref)
    v50.render_background(v1241, v1241 + l_vector_0(40, v1242.y), v1240.icon_fade, 5);
    v29.texture(v1240.icon.img, v1241 + l_vector_0(5, 0), v1240.icon.size, v1240.color:override(v1240.icon_fade));
    v50.render_accent(v1241 + l_vector_0(45, 0), v1241 + l_vector_0(47, v1242.y), v1240.icon_fade, 2, v1240.color);
    v50.render_background(v1241 + l_vector_0(52, 0), v1241 + v1242, v1240.text_fade, 5);
    v29.push_clip_rect(v1241, v1241 + v1242, true);
    v29.text("theme::low", v1241 + l_vector_0(62, 15 - v1243.y / 2), l_color_0(255, 180 * v1240.text_fade), v39, v1240.text);
    v29.pop_clip_rect();
end;
v67.render = function(v1244)
    -- upvalues: v51 (ref), v28 (ref), v50 (ref), v67 (ref), l_vector_0 (ref), v29 (ref), v27 (ref)
    local v1245 = v51.get("enable_logs");
    local v1246 = nil;
    v1244:fade(v28.get_alpha() > 0 and v1245 and 1 or 0);
    local v1247 = {
        text = "this is example log, you can move this around", 
        icon = v51.icons.hit, 
        icon_fade = v1244._fade, 
        text_fade = v1244._fade, 
        color = v50.colors.accent
    };
    local v1248, v1249 = v67.calculate(v1247);
    v67.render_log(v1247, v1244._position, v1248, v1249);
    v1244:override_position(v1248);
    v1246 = l_vector_0(v1244._position.x, v1244._position.y);
    if v1244._is_attach then
        v1246.x = v50.screen_size.x / 2;
        v67.is_center = 1;
    else
        v1246.x = v1244._position.x;
        v67.is_center = 0;
    end;
    if not v1245 then
        return;
    else
        v1247 = 50 * v1244._fade;
        v1248 = false;
        v1249 = #v67.list;
        for v1250 = v1249, 1, -1 do
            local v1251 = v67.list[v1250];
            if v1251 then
                local v1252 = v1251.time + 5 < globals.realtime;
                local v1253, v1254 = v67.calculate(v1251);
                v67.render_log(v1251, v1246 + l_vector_0(-v1253.x / 2 * v67.is_center, v1247), v1253, v1254);
                v1247 = v1247 + (v1253.y + 10) * v1251.icon_fade;
                if v1252 then
                    v1251.text_fade = v29.do_animation(v1251.text_fade, 0);
                    if v1251.text_fade == 0 then
                        v1251.icon_fade = v29.do_animation(v1251.icon_fade, 0);
                    end;
                    if v1251.icon_fade ~= 0 then
                        v1248 = true;
                    end;
                else
                    v1248 = true;
                    v1251.icon_fade = v29.do_animation(v1251.icon_fade, 1);
                    if v1251.icon_fade == 1 then
                        v1251.text_fade = v29.do_animation(v1251.text_fade, 1);
                    end;
                end;
            end;
        end;
        if not v1248 and v1249 > 0 then
            v27.clear(v67.list);
        end;
        return;
    end;
end;
v67.destroy = function()
    -- upvalues: v67 (ref)
    db._DigitalDreams_LogSystem_Position = {
        x = v67.window._position.x, 
        y = v67.window._position.y
    };
end;
v68.database = db._DigitalDreams_WarningSystem_Position or {
    y = 100, 
    x = v50.screen_size.x / 2 - 60
};
v68.window = v48.window("lua::warning_system", l_vector_0(v68.database.x, v68.database.y), l_vector_0(150, 30), v111.CENTER_ATTACH);
v68.window:register("view_fade", 0);
v68.render = function(v1255)
    -- upvalues: v52 (ref), v51 (ref), v28 (ref), v29 (ref), v39 (ref), v25 (ref), v50 (ref), l_vector_0 (ref), l_color_0 (ref)
    if not v52.local_player() then
        return;
    else
        local l_m_flVelocityModifier_0 = v52.local_player().m_flVelocityModifier;
        if not l_m_flVelocityModifier_0 then
            return;
        else
            if not v51.get("enable_velocity_warning") then
                if v1255._fade == 0 then
                    return;
                else
                    v1255:fade(0);
                end;
            else
                v1255:fade((not (v28.get_alpha() <= 0) or l_m_flVelocityModifier_0 < 1) and 1 or 0);
            end;
            v1255.view_fade = v29.do_animation(v1255.view_fade, l_m_flVelocityModifier_0);
            if v1255._fade > 0 then
                local v1257 = v29.measure_text("theme::low", v39, "Slowed down");
                local v1258 = v25.abs(v25.sin(globals.realtime * 4)) * v1255._fade;
                v50.render_background(v1255._position, v1255._position + l_vector_0(52 + v1257.x + 10, v1255._size.y), v1255._fade, 5);
                v29.texture(v51.icons.warning.img, v1255._position + l_vector_0(5, 0), v51.icons.warning.size, l_color_0(255, 10, 10, 255 * v1258));
                local v1259 = v29.preform_animation("Velocity dropdown", v1255._size.y * l_m_flVelocityModifier_0, v39, 8);
                v50.render_accent(v1255._position + l_vector_0(45, 0), v1255._position + l_vector_0(47, v1259), v1255._fade, 2);
                v29.text("theme::low", v1255._position + l_vector_0(57, 7), l_color_0(255, 180 * v1255._fade), v39, "Slowed down");
                v1255._size.x = 62 + v1257.x;
                v1255:override_position(v1255._size);
                if v25.abs(v50.screen_size.x / 2 - (v1255._position.x + v1255._size.x / 2)) < 50 then
                    v1255._position.x = v50.screen_size.x / 2 - v1255._size.x / 2;
                end;
            end;
            return;
        end;
    end;
end;
v68.view = function(v1260)
    -- upvalues: v51 (ref), v52 (ref), v68 (ref)
    if not v51.get("enable_velocity_warning") or not v51.get("velocity_warning_effect") then
        return;
    elseif not v52.is_alive then
        return;
    else
        if v68.window.view_fade < 1 then
            v1260.fov = v1260.fov - 10 * v68.window._fade * (1 - v68.window.view_fade);
        end;
        return;
    end;
end;
v68.destroy = function()
    -- upvalues: v68 (ref)
    db._DigitalDreams_WarningSystem_Position = {
        x = v68.window._position.x, 
        y = v68.window._position.y
    };
end;
v69.right_hand = cvar.cl_righthand;
v69.lagcompensation = cvar.cl_lagcompensation;
v69.list = {
    [1] = function(v1261)
        -- upvalues: v51 (ref), v29 (ref), v50 (ref), l_vector_0 (ref), l_color_0 (ref)
        local v1262 = v51.references.hide_shots:get();
        local v1263 = v51.references.double_tap:get();
        local v1264 = v1263 or v1262;
        local v1265 = v29.preform_animation("Side indicator - double tap", v1264 and 1 or 0);
        if v1265 > 0 then
            local v1266 = v29.preform_animation("Side indicator - hideshors", (not v1262 or v1263) and 1 or 0.2) * v1265;
            local v1267 = v29.preform_animation("Side indicator - double tap charged", rage.exploit:get()) * v1265;
            v50.render_background(v1261, v1261 + l_vector_0(40 + 20 * v1267, 40), v1265, 5);
            v29.texture(v51.icons.arrow.img, v1261 + l_vector_0(10, 5), v51.icons.arrow.size, l_color_0(255, 255 * v1266));
            v29.texture(v51.icons.arrow.img, v1261 + l_vector_0(10 + 15 * v1267, 5), v51.icons.arrow.size, v50.colors.accent:override(v1267));
        end;
        return v1265;
    end, 
    [2] = function(v1268)
        -- upvalues: v28 (ref), v51 (ref), v29 (ref), v25 (ref), v39 (ref), l_vector_0 (ref), v50 (ref), l_color_0 (ref)
        local v1269 = v28.get_binds();
        local v1270 = false;
        local v1271 = v51.references.min_damage:get();
        for v1272 = 1, #v1269 do
            local v1273 = v1269[v1272];
            if v1273.name == "Min. Damage" and v1273.active then
                v1270 = true;
                v1271 = v1273.value;
                break;
            end;
        end;
        local v1274 = v29.preform_animation("Side indicator - min damage", v1270 and 1 or 0);
        v1271 = v29.preform_animation("Side indicator - min damage value", v1271, 1, 16);
        v1271 = v25.floor(v1271);
        if v1274 > 0 then
            local v1275 = v29.measure_text("theme::high", v39, v1271);
            local v1276 = l_vector_0(30 + v1275.x + 30, 40);
            v50.render_background(v1268, v1268 + v1276, v1274, 5);
            v29.texture(v51.icons.bullet.img, v1268 + l_vector_0(10, 5), v51.icons.bullet.size, l_color_0(255, 255 * v1274));
            v29.text("theme::high", v1268 + l_vector_0(50, 20 - v1275.y / 2), v50.colors.accent:override(v1274), v39, v1271);
        end;
        return v1274;
    end, 
    [3] = function(v1277)
        -- upvalues: v51 (ref), v29 (ref), v50 (ref), l_vector_0 (ref), l_color_0 (ref)
        local v1278 = v51.references.dormant_aimbot:get();
        local v1279 = v29.preform_animation("Side indicator - dormant", v1278 and 1 or 0);
        if v1279 > 0 then
            v50.render_background(v1277, v1277 + l_vector_0(50, 40), v1279, 5);
            v29.texture(v51.icons.blind.img, v1277 + l_vector_0(10, 5), v51.icons.blind.size, l_color_0(255, 255 * v1279));
        end;
        return v1279;
    end, 
    [4] = function(v1280)
        -- upvalues: v51 (ref), v29 (ref), v50 (ref), l_vector_0 (ref), l_color_0 (ref)
        local v1281 = v51.references.auto_peek:get();
        local v1282 = v29.preform_animation("Side indicator - auto peek", v1281 and 1 or 0);
        if v1282 > 0 then
            v50.render_background(v1280, v1280 + l_vector_0(50, 40), v1282, 5);
            v29.texture(v51.icons.location.img, v1280 + l_vector_0(10, 5), v51.icons.location.size, l_color_0(255, 255 * v1282));
        end;
        return v1282;
    end, 
    [5] = function(v1283)
        -- upvalues: v51 (ref), v29 (ref), v50 (ref), l_vector_0 (ref), l_color_0 (ref)
        local v1284 = v51.references.freestand:get();
        local v1285 = v29.preform_animation("Side indicator - freestand", v1284 and 1 or 0);
        if v1285 > 0 then
            v50.render_background(v1283, v1283 + l_vector_0(50, 40), v1285, 5);
            v29.texture(v51.icons.radar.img, v1283 + l_vector_0(10, 5), v51.icons.radar.size, l_color_0(255, 255 * v1285));
        end;
        return v1285;
    end, 
    [6] = function(v1286)
        -- upvalues: v51 (ref), v29 (ref), v50 (ref), l_vector_0 (ref), l_color_0 (ref)
        local v1287 = v51.get_bind("Defensive snap");
        local v1288 = v29.preform_animation("Side indicator - defensive", v1287 and 1 or 0);
        if v1288 > 0 then
            v50.render_background(v1286, v1286 + l_vector_0(50, 40), v1288, 5);
            v29.texture(v51.icons.unk_rotate.img, v1286 + l_vector_0(10, 5), v51.icons.unk_rotate.size, l_color_0(255, 255 * v1288));
        end;
        return v1288;
    end
};
v69.get_muzzle = function(v1289)
    -- upvalues: v52 (ref), v32 (ref), v39 (ref), v33 (ref), v154 (ref), l_vector_0 (ref)
    local v1290 = v52.local_player():get_player_weapon();
    if not v1290 then
        return;
    else
        local v1291 = v1289 and v1290.m_hWeaponWorldModel or v52.local_player().m_hViewModel[0];
        local v1292 = v1290[0];
        local v1293 = v32.get(v1291)[0];
        if v1292 == v39 or v1293 == v39 then
            return;
        else
            local v1294 = v33.new("vector_t[1]");
            local v1295 = v1289 and v154.get_attachment_index_3(v1292) or v154.get_attachment_index_1(v1292, v1293);
            if v1295 > 0 and v154.get_attachment(v1293, v1295, v1294[0]) then
                return l_vector_0(v1294[0].x, v1294[0].y, v1294[0].z);
            else
                return v39;
            end;
        end;
    end;
end;
v69.render = function()
    -- upvalues: v51 (ref), v52 (ref), v69 (ref), l_vector_0 (ref), v29 (ref), v50 (ref), v39 (ref)
    if not v51.get("enable_side_indicators") then
        return;
    elseif not v52.is_alive then
        return;
    else
        local v1296 = v51.get("side_indicators_mode") == "Muzzle";
        local v1297 = nil;
        if v1296 then
            local v1298 = v69.get_muzzle(false);
            local v1299 = v52.local_player():get_origin() + l_vector_0(0, 0, 40);
            if not v1299 then
                return;
            else
                if common.is_in_thirdperson() then
                    v1298 = v1299;
                end;
                if not v1298 then
                    return;
                else
                    v1297 = v29.world_to_screen(v1298);
                    if not v1297 then
                        return;
                    elseif not common.is_in_thirdperson() then
                        if v69.right_hand:int() == 0 then
                            v1297.x = v1297.x + 20;
                        else
                            v1297.x = v1297.x + -100;
                        end;
                    else
                        local v1300 = v29.world_to_screen(v52.local_player():get_origin());
                        if not v1300 then
                            v1297.x = v50.screen_size.x / 2 - 100;
                        else
                            v1297.x = v1300.x - 100;
                        end;
                    end;
                end;
            end;
        else
            local v1301 = v50.screen_size.y / 2 + 5;
            v1297 = l_vector_0(10, v1301);
        end;
        local v1302 = v29.preform_animation("Side indicators position", v1297, v39, 6);
        local v1303 = v51.get("side_indicators_options");
        local v1304 = 0;
        for v1305 = 1, #v69.list do
            if v1303[v1305] then
                v1304 = v1304 + 50 * v69.list[v1305](v1302 + l_vector_0(0, v1304));
            end;
        end;
        return;
    end;
end;
v70.damage_list = {};
v70.shot_list = {};
v70.last_time = 0;
v70.push_damage = function(v1306, v1307, v1308)
    -- upvalues: v70 (ref), v36 (ref), v29 (ref)
    local l_realtime_0 = globals.realtime;
    local v1310 = v70.damage_list[#v70.damage_list];
    if v1310 and v1310._position:dist(v1307) < 20 then
        v1310._damage[#v1310._damage + 1] = {
            [1] = nil, 
            [2] = 0, 
            [1] = v36("%d", v1306)
        };
        v1310._time = l_realtime_0;
    else
        v70.damage_list[#v70.damage_list + 1] = {
            _fade = 0, 
            _damage = {
                [1] = {
                    [1] = nil, 
                    [2] = 0, 
                    [1] = v36("%d", v1306)
                }
            }, 
            _position = v1307, 
            _vector = v29.world_to_screen(v1307), 
            _is_head = v1308, 
            _time = l_realtime_0
        };
    end;
    v70.last_time = l_realtime_0;
end;
v70.push_hurt = function(v1311, v1312)
    -- upvalues: v70 (ref)
    v70.shot_list[#v70.shot_list + 1] = {
        _fade = 0, 
        _position = v1311, 
        _color = v1312
    };
end;
v70.player_hurt = function(v1313)
    -- upvalues: v51 (ref), v52 (ref), v32 (ref), l_vector_0 (ref), v70 (ref)
    if not v51.get("enable_damage") then
        return;
    elseif not v52.local_player() then
        return;
    else
        local v1314 = v32.get(v1313.userid, true);
        if not v1314 then
            return;
        else
            local v1315 = v32.get(v1313.attacker, true);
            if not v1315 or v51.get("damage_settings")[3] and v1315 ~= v52.local_player() then
                return;
            else
                local l_m_vecOrigin_0 = v1314.m_vecOrigin;
                local v1317 = l_vector_0(l_m_vecOrigin_0.x, l_m_vecOrigin_0.y, l_m_vecOrigin_0.z + v1314.m_vecViewOffset.z);
                if not v1317 then
                    return;
                else
                    v70.push_damage(v1313.dmg_health, v1317, v1313.hitgroup == 1);
                    return;
                end;
            end;
        end;
    end;
end;
v70.shots = function(v1318)
    -- upvalues: v51 (ref), v39 (ref), v70 (ref)
    if not v51.get("enable_shots") then
        return;
    else
        local v1319 = v1318.state == v39 and v51.get("hit_color") or v51.get("miss_color");
        v70.push_hurt(v1318.aim, v1319);
        return;
    end;
end;
v70.render_damage = function()
    -- upvalues: v51 (ref), v52 (ref), v70 (ref), v29 (ref), v39 (ref), l_vector_0 (ref), v27 (ref)
    if not v51.get("enable_damage") then
        return;
    elseif not v52.local_player() then
        return;
    else
        local v1320 = {
            head_color = v51.get("damage_head_color"), 
            other_color = v51.get("damage_other_color"), 
            settings = v51.get("damage_settings")
        };
        local v1321 = #v70.damage_list;
        local v1322 = false;
        for v1323 = 1, v1321 do
            local v1324 = v70.damage_list[v1323];
            if v1324 then
                local v1325 = v1324._time + 1.5 > globals.realtime;
                v1324._fade = v29.do_animation(v1324._fade, v1325 and 1 or 0);
                if v1324._fade > 0 then
                    local v1326 = (v1324._is_head and v1320.head_color or v1320.other_color):override(v1324._fade);
                    local v1327 = v29.world_to_screen(v1324._position);
                    if v1327 ~= v39 then
                        if v1320.settings[2] and v1324._vector ~= v39 then
                            v1324._vector = v29.do_vector_animation(v1324._vector, v1327);
                        else
                            v1324._vector = v1327;
                        end;
                        local v1328 = #v1324._damage;
                        if v1320.settings[1] then
                            v29.shadow(v1324._vector - l_vector_0(0, -v1328 * 16 / 2), v1324._vector + l_vector_0(0, v1328 * 16 / 2), v1326, 70);
                        end;
                        local v1329 = 0;
                        for v1330 = 1, v1328 do
                            local v1331 = v1324._damage[v1330];
                            v1331[2] = v29.do_animation(v1331[2], 1);
                            v29.text("theme::low", v1324._vector + l_vector_0(0, v1329), v1326:override(v1331[2]), "c", v1331[1]);
                            v1329 = v1329 + 16 * v1331[2];
                        end;
                        v1324._position.z = v1324._position.z + globals.frametime * 10;
                    end;
                    v1322 = true;
                elseif v1325 then
                    v1322 = true;
                end;
            end;
        end;
        if not v1322 and v1321 > 0 then
            v27.clear(v70.damage_list);
        end;
        return;
    end;
end;
v70.render_shots = function()
    -- upvalues: v51 (ref), v52 (ref), v70 (ref), v25 (ref), v29 (ref), l_vector_0 (ref), v27 (ref)
    if not v51.get("enable_shots") then
        return;
    elseif not v52.local_player() then
        return;
    else
        local v1332 = #v70.shot_list;
        local v1333 = false;
        for v1334 = 1, v1332 do
            local v1335 = v70.shot_list[v1334];
            if v1335 then
                v1335._fade = v25.lerp(v1335._fade, 1, globals.frametime * 2);
                if v1335._fade ~= 1 then
                    v1333 = true;
                end;
                local v1336 = v25.abs(v1335._fade - 1);
                local v1337 = v1335._color:override(v1336);
                local v1338 = v29.world_to_screen(v1335._position);
                if v1338 then
                    v29.shadow(v1338 - l_vector_0(50 * v1335._fade, 50 * v1335._fade), v1338 + l_vector_0(50 * v1335._fade, 50 * v1335._fade), v1337, 100, 0, 50 * v1335._fade);
                end;
            end;
        end;
        if not v1333 and v1332 > 0 then
            v27.clear(v70.shot_list);
        end;
        return;
    end;
end;
v71.build = {
    [1] = "\194\183 ", 
    [2] = " \194\183 ", 
    [3] = "  \194\183 ", 
    [4] = "l  \194\183 ", 
    [5] = "al  \194\183 ", 
    [6] = "tal  \194\183 ", 
    [7] = "ital  \194\183 ", 
    [8] = "gital  \194\183 ", 
    [9] = "igital  \194\183 ", 
    [10] = "digital  \194\183 ", 
    [11] = "digital  \194\183 ", 
    [12] = "digital \194\183 ", 
    [13] = "digital \194\183 ", 
    [14] = "digita \194\183 ", 
    [15] = "digit \194\183 ", 
    [16] = "digi \194\183 ", 
    [17] = "dig \194\183 ", 
    [18] = "di \194\183 ", 
    [19] = "d \194\183 ", 
    [20] = " \194\183 "
};
v71.last_text = v39;
v71.update = function(v1339)
    -- upvalues: v71 (ref)
    if v71.last_text ~= v1339 then
        common.set_clan_tag(v1339);
        v71.last_text = v1339;
        return true;
    else
        return false;
    end;
end;
v71.handle = function()
    -- upvalues: v51 (ref), v71 (ref), v39 (ref), v30 (ref), v25 (ref)
    local v1340 = v51.get("clantag");
    if not globals.is_connected then
        v71.last_text = v39;
        return;
    elseif not v1340 then
        v71.update(" ");
        return;
    else
        local v1341 = v30.net_channel();
        if not v1341 then
            return;
        else
            local v1342 = v1341.latency[0] / globals.tickinterval;
            local v1343 = globals.tickcount + v1342;
            local v1344 = v25.floor(v25.fmod(v1343 / 25, #v71.build));
            if v71.build[v1344] then
                v71.update(v71.build[v1344]);
            end;
            return;
        end;
    end;
end;
v71.destroy = function()
    common.set_clan_tag(" ");
end;
v72.phrases = {
    [1] = "iq?", 
    [2] = "\208\191\208\184\208\180\208\190\209\128\208\176\209\129\208\184\208\186 o(>\207\137<)o", 
    [3] = "\209\133\209\129", 
    [4] = "\209\135\208\188\208\190 \209\131\209\136\208\176\209\129\209\130\208\190\208\181 \208\177\208\187\209\143\209\130\209\140", 
    [5] = "\208\181\208\177\208\176\209\130\209\140 \209\130\209\139 \208\186\209\131\208\180\208\176 \208\191\208\190\208\187\208\181\209\130\208\181\208\187", 
    [6] = "outclassed by legend", 
    [7] = "\208\178 \209\129\208\187\208\181\208\180\209\131\209\142\209\137\208\181\208\188 \209\128\208\176\209\131\208\189\208\180\208\181 \208\189\208\181 \208\191\208\190\208\178\209\130\208\190\209\128\208\184\209\130\209\129\209\143 \208\190\209\130\208\178\208\181\209\135\208\176\209\142", 
    [8] = "\208\183\208\176\209\135\208\181\208\188 \208\178\208\178 \208\191\208\184\208\186\208\176\208\181\209\136\209\140", 
    [9] = "\208\188\208\180\208\176 \209\143 \209\130\208\181\208\177\209\143 \209\129\208\189\208\190\208\178\208\176 \208\191\208\181\209\128\208\181\208\184\208\179\209\128\208\176\208\187", 
    [10] = "\208\187\208\181\208\179\208\181\208\189\208\180\209\131 \208\189\208\181 \208\178\209\139\208\184\208\179\209\128\208\176\209\130\209\140 \208\179\208\176\208\189\208\180\208\190\208\189", 
    [11] = "\208\189\208\176 \209\130\208\190\208\185 \208\182\208\181 \208\190\209\136\208\184\208\177\208\186\208\181 \209\143 \209\130\209\143 \208\191\208\190\208\185\208\188\208\176\208\187 \208\180\208\190\208\187\208\177\208\190\208\181\208\177", 
    [12] = "\209\130\208\181\208\177\208\181 \208\188\208\176\208\186\208\176\209\128\208\190\208\189\209\139 \208\189\208\176 \209\133\209\131\208\185 \208\178\208\181\209\136\208\176\209\142\209\130, \209\131 \209\130\209\143 \209\133\209\131\208\185\208\189\209\143 \209\129\208\186\209\128\208\184\208\191\209\130 \208\180\208\181\208\177\208\184\208\187", 
    [13] = "\208\187\209\131\209\135\209\136\208\181 \208\191\208\190\208\180\209\131\208\188\208\176\208\185 \208\179\208\190\208\187\208\190\208\178\208\190\208\185 \208\178 \209\129\208\187\208\181\208\180\209\131\209\142\209\137\208\184\208\185 \209\128\208\176\208\183", 
    [14] = "LACHDAB ON UR GRAVE", 
    [15] = "\208\190\208\191\209\143\209\130\209\140 \209\143 \209\130\209\143 \208\183\208\176\208\177\208\176\208\185\209\130\208\184\208\187 \208\191\208\184\208\180\208\190\209\128", 
    [16] = "\208\178\209\139\208\186\209\131\209\128\208\184\208\187 \208\178\208\181\209\129\209\140 \208\191\209\128\208\176\209\133 \208\188\208\176\208\188\208\176\209\136\208\184 \209\130\208\178\208\190\208\181\208\185", 
    [17] = "1.", 
    [18] = "\209\130\209\128\208\176\209\133\208\189\209\131\208\187 \208\177\208\181\208\183\208\183\209\131\208\177\208\190\208\179\208\190", 
    [19] = "\208\165\208\163\208\149\208\161\208\158\208\161 (\239\188\131\239\191\163\207\137\239\191\163)", 
    [20] = "\208\180\208\190\208\191\209\128\209\139\208\179\208\176\208\187\209\129\209\143 \208\191\208\184\208\180\208\190\209\128\208\176\209\129", 
    [21] = "\208\189\208\176\209\133\209\131\208\185 \209\141\209\130\208\184 \208\176\208\189\209\130\208\184-\208\176\208\184\208\188\209\139, \208\191\208\190\208\186\209\131\208\191\208\176\208\185 digital-dreams.lua", 
    [22] = "\209\143 \209\130\209\143 \209\129\209\133\208\176\208\178\208\176\208\187 \209\130\208\190\208\186 \209\135\209\130o", 
    [23] = "\208\184 \208\186\209\132\208\179 \208\184 \208\187\209\131\208\176 \209\133\209\131\208\185\208\189\209\143 \208\176\209\133\209\131\208\181\209\130\209\140 \208\191\209\128\208\190\209\129\209\130\208\190", 
    [24] = "laff", 
    [25] = "\208\190\209\130\208\187\208\181\209\130\208\176\208\185 \209\135\209\131\208\180\208\184\208\186", 
    [26] = "\208\180\208\184\208\179\208\184\209\130\208\176\208\187 \208\180\209\128\208\184\208\188\209\129 \208\189\208\181 \208\191\208\181\209\128\208\181\208\184\208\179\209\128\208\176\209\130\209\140", 
    [27] = "\208\190\208\191, \208\176 \209\135\208\184\209\130 \209\130\208\190 \209\135\209\131\209\128\208\186\209\131 \209\131\208\177\208\184\208\187", 
    [28] = "\209\141\209\130\208\190 \208\186\208\190\208\179\208\190 \209\143 \208\183\208\176\209\133\209\131\209\143\209\135\208\184\208\187 \208\187\208\181\208\179\208\181\208\189\208\180\209\131?", 
    [29] = "\208\161 \208\148\208\189\208\181\208\188 \208\180\208\190\209\133\208\187\208\190\208\185 \208\188\208\176\209\130\208\181\209\128\208\184 \209\133\209\131\208\181\209\129\208\190\209\129", 
    [30] = "\208\159\209\131\208\191\209\129\208\184\208\186 \208\178 \209\129\208\187\208\181\208\180 \209\128\208\176\208\183 \208\144\208\144 \208\178\208\186\208\187\209\142\209\135\208\184", 
    [31] = "\208\177\208\187\209\143\209\130\209\140 \208\186\208\176\208\186 \209\143 \209\130\208\178\208\190\208\184 \208\144\208\144 \208\187\208\181\208\179\208\181\208\189\208\180\209\139 \208\183\208\176\209\132\208\184\208\186\209\129\208\184\208\187,\208\163\209\132\209\132\209\132", 
    [32] = "\208\152\208\183\208\178\208\184\208\189\208\184, \209\135\209\130\208\190 \209\131\208\177..., \208\176 \208\187\208\176\208\180\208\189\208\190 \208\191\208\190\209\133\209\131\208\185", 
    [33] = "\209\129\208\186\208\184\209\130\208\181\209\128\208\176 \209\131\208\177\208\184\208\187 \208\191\208\190\208\185\208\180\209\131 \208\186\209\132\208\179 \208\191\209\128\208\190\208\180\208\176\208\188", 
    [34] = "ana\197\132 \195\179ldi \208\191\208\190\208\189\209\143\208\187", 
    [35] = "\208\187\208\184\209\134\208\190 \208\190\209\130 \209\129\208\191\208\181\209\128\208\188\209\139 \208\178\209\139\209\130\209\128\208\184", 
    [36] = "\227\129\130\227\129\170\227\129\159\227\129\174\227\129\138\231\136\182\227\129\149\227\130\147\227\129\175\227\131\155\227\131\162\227\129\167\227\129\153 \208\189\208\176 \209\130\208\178\208\190\208\181\208\188 \208\176\208\189\208\184\208\188\208\181\209\136\208\189\208\190\208\188 \208\189\208\176\208\191\208\184\209\129\208\176\208\187", 
    [37] = "\209\129\209\133\208\190\208\180\208\184 \209\135\209\130\208\190\208\187\209\140 \209\136\208\186\208\190\208\187\209\131 \208\183\208\176\208\186\208\190\208\189\209\135\208\184", 
    [38] = "\208\180\208\184\208\179\208\184\209\130\208\176\208\187 \208\180\209\128\208\184\208\188\209\129 \208\179\208\181\209\130\208\189\209\131\208\187 \209\130\208\181\208\191\208\181\209\128\209\140 \209\133\208\176\209\135\208\181\208\185 \209\131\208\177\208\184\208\178\208\176\209\142", 
    [39] = "\208\191\208\190\208\187\208\190\208\178\208\176\209\143 \209\130\209\128\209\143\208\191\208\186\208\176 \209\130\209\139))))))))", 
    [40] = "\208\177\208\187\209\143\209\130\209\140 \208\188\209\131\209\129\208\190\209\128 \208\178 \208\186\208\184\208\187\208\187 \208\177\208\176\209\128 \208\191\208\190\208\191\208\176\208\187", 
    [41] = "\209\129\209\133\208\190\208\180\208\184 \209\129\208\176\208\187\209\140\209\134\208\176 \208\189\208\176\208\181\208\177\208\189\208\184 \208\180\208\190\209\133\208\187\209\143\208\186", 
    [42] = "\208\186\208\176\209\136\208\186\209\131 \208\183\208\176 \208\188\208\176\208\188\209\131, \209\135\209\130\208\190\208\177 \208\178\208\190\209\129\208\186\209\128\208\181\209\129\208\187\208\176", 
    [43] = "\208\152\208\180\208\181\209\130 \208\189\208\181\208\179\209\128 \208\191\208\190 \208\191\209\131\209\129\209\130\209\139\208\189\208\184, \208\176 \209\135\209\145 \209\143 \209\130\208\181\208\177\208\181 \209\128\208\176\209\129\209\129\208\186\208\176\208\183\209\139\208\178\208\176\209\142, \209\130\209\139 \208\182 \208\191\208\190-\209\128\209\131\209\129\209\129\208\186\208\184 \208\189\208\181 \208\178\208\180\209\131\208\191\208\187\209\143\208\181\209\136\209\140", 
    [44] = "\208\178\209\139\208\180\208\190\209\133\208\189\208\184, \209\135\209\131\209\130\209\140-\209\135\209\131\209\130\209\140 \208\191\208\190\209\137\208\184\208\191\208\176\208\181\209\130 \208\184 \208\191\209\128\208\190\208\185\208\180\209\145\209\130", 
    [45] = "\208\157\208\190\208\178\209\131\209\142 \208\180\209\139\209\128\208\186\209\131 \208\180\208\187\209\143 \208\181\208\177\208\187\208\184 \209\129\208\180\208\181\208\187\208\176\208\187 \208\178 \209\130\208\181\208\177\208\181", 
    [46] = "\208\159\208\190 \208\188\208\176\209\130\208\181\209\136\208\181 \208\191\208\190\208\188\208\190\209\135\209\140 \209\130\208\181\208\177\208\181?", 
    [47] = "\208\167\208\163\208\156\208\145\208\144 \208\162\208\171 \208\167\208\162\208\158 \208\154\208\152\208\145\208\149\208\160\208\159\208\161\208\152\208\165?", 
    [48] = "\208\149\208\179\208\190\209\128 \208\154\209\128\208\184\208\180 \209\137\208\176\209\129 \208\178 \208\188\208\190\208\180\208\181? \208\156\208\189\208\181 \208\180\208\187\209\143 \208\188\208\181\208\180\208\184\208\184 \208\191\209\128\208\190\209\129\209\130\208\190", 
    [49] = "\208\159\208\184\209\131-\208\191\208\184\209\131 \209\130\209\139 \209\131\208\177\208\184\209\130 \208\155\208\158\208\165", 
    [50] = "\209\130\208\176\208\186 \208\177\208\190\208\187\209\140\209\136\208\181 \208\189\208\181 \209\131\208\188\208\184\209\128\208\176\208\185 \208\190\209\130 \208\187\208\181\208\179\208\181\208\189\208\180\209\139", 
    [51] = "\209\130\208\190\208\187\209\140\208\186\208\190 \208\189\208\181 \208\190\208\177\208\184\208\182\208\176\208\185\209\129\209\143 \208\178 \208\180\209\128\209\131\208\179\208\190\208\185 \209\128\208\176\208\183 \208\191\208\190 \208\181\208\177\208\187\209\131 \208\178 \208\180\208\178\208\190\208\185\208\189\208\181 \208\191\208\190\208\187\209\131\209\135\208\184\209\136\209\140", 
    [52] = "\208\175 \209\135\208\181 \208\146\208\184\209\130\208\188\209\131 \208\183\208\176\209\133\209\131\209\143\209\135\208\184\208\187!?!", 
    [53] = "\209\131\208\177\208\184\208\187 \208\180\209\131\209\128\208\176\208\186\208\176, \208\191\208\190\209\130\208\190\208\188\209\131 \209\135\209\130\208\190 \209\142\208\183\208\181\209\128\208\176 Digital Dreams.lua \208\189\208\181 \208\191\208\181\209\128\208\181\208\184\208\179\209\128\208\176\209\130\209\140", 
    [54] = "\208\187\208\176\208\180\208\189\208\190, \208\188\208\190\208\179 \208\177\209\139 \208\184 \208\189\208\181 \208\191\208\190\208\180\208\176\208\178\208\176\209\130\209\140\209\129\209\143", 
    [55] = "\208\149\209\129\208\187\208\184 iq \208\189\208\181 \209\133\208\178\208\176\209\130\208\176\208\181\209\130 \208\189\208\176\209\133\209\131\209\143 \209\142\208\183\208\181\209\128\208\176 Digital dreams \208\191\208\184\208\186\208\176\209\130\209\140", 
    [56] = "\208\177\208\181\208\183\208\177\208\176\209\136\208\181\208\189\208\189\209\139\208\185 \208\186\209\131\208\180\208\176 \209\130\209\139 \208\191\208\190\208\180 \208\191\209\131\208\187\208\184 \208\187\208\181\208\183\208\181\209\136\209\140", 
    [57] = "\208\190\209\130\208\191\208\184\209\136\208\181\209\136\209\140 \208\186\208\190\208\179\208\180\208\176 \208\188\208\190\208\183\208\179 \208\178\208\186\208\187\209\142\209\135\208\184\209\136\209\140", 
    [58] = "\209\136\208\181\208\186\208\181\208\187\209\140 \208\180\208\176\208\188 \209\135\209\130\208\190\208\177 \209\130\209\139 \208\177\208\190\208\187\209\140\209\136\208\181 \208\189\208\181 \208\191\208\190\208\183\208\190\209\128\208\184\208\187\209\129\209\143", 
    [59] = "\208\187\209\131\209\135\209\136\208\181 \209\143 \209\130\208\181\208\177\209\143 \208\186\208\184\208\187\209\140\208\189\209\131, \209\135\208\181\208\188 \208\186\208\176\208\186\208\190\208\185 \209\130\208\190 \208\182\208\184\209\128\208\176\208\183\209\131", 
    [60] = "\208\191\208\190\209\129\208\191\208\184 \208\186\208\184\209\129\209\131\208\187\209\140", 
    [61] = "\208\189\208\184\209\135\208\181\208\179\208\190 \209\129\209\130\209\128\208\176\209\136\208\189\208\190\208\179\208\190 \208\178 \209\129\208\187\208\181\208\180 \209\128\208\176\209\131\208\189\208\180\208\181 \208\191\208\190\208\184\208\179\209\128\208\176\208\181\209\136\209\140", 
    [62] = "\209\130\209\139 \209\133\208\190\209\128\208\190\209\136\208\190 \208\184\208\179\209\128\208\176\208\181\209\136\209\140, \208\189\208\190 \208\188\208\190\208\185 walkbot \208\187\209\131\209\135\209\136\208\181", 
    [63] = "\209\143 \208\181\209\137\208\181 \208\180\208\176\208\182\208\181 \208\186\209\132\208\179\208\181\209\136\208\186\209\131 \208\189\208\181 \208\183\208\176\208\179\209\128\209\131\208\183\208\184\208\187, \208\176 \209\130\209\139 \209\131\208\182\208\181 \208\189\208\176 \208\189\208\181\208\177\208\181\209\129\208\176\209\133", 
    [64] = "\208\180\208\187\209\143 \209\130\208\181\208\177\209\143 \209\129\208\186\208\184\208\180\208\190\209\135\208\186\209\131 \208\190\209\132\208\190\209\128\208\188\208\187\209\142 \208\189\208\176 \208\180\208\184\208\179\208\184\209\130\208\176\208\187 \208\180\209\128\208\184\208\188\209\129.lua", 
    [65] = "\208\180\208\176 \209\130\209\139 \208\191\209\128\209\143\208\188 \209\133\208\178\209\133 \208\186\208\190\209\128\208\190\208\187\208\181\208\178\208\176", 
    [66] = "\209\141\209\130\208\176\208\179\208\190 \209\129\208\190\209\135\208\189\208\184\208\186\208\176 \209\131\208\177\208\184\208\178 \209\129\208\187\208\181\208\180\209\131\209\137\208\184\208\185 \208\189\208\176 \208\188\208\181\208\180\208\184\209\142", 
    [67] = "\208\187\208\176\209\136\208\190\208\186 \208\180\208\176\208\178\208\176\208\185 \208\189\208\176 \208\177\208\190\208\186\208\190\208\178\209\131\209\142", 
    [68] = "2x2 \208\184\208\180\208\181\208\188 \209\133\209\131\208\181\209\129\208\190\209\129", 
    [69] = "\208\190\209\130\208\180\209\139\209\133\208\176\208\185 \208\180\209\131\209\128\208\189\208\190\208\181", 
    [70] = "\208\186\208\176\208\188\208\176\208\183 \208\188\208\176\209\130\209\131\209\133\209\131 \209\130\208\178\208\190\209\142 \209\131\208\182\208\181 \208\178\209\135\208\181\209\128\208\176 \208\191\208\181\209\128\208\181\208\181\209\133\208\176\208\187", 
    [71] = "\209\130\209\128\209\131\208\191 \208\177\208\176\209\130\209\140\208\186\208\176 \209\129 \208\177\208\176\208\187\208\186\208\190\208\189\208\176 \208\178\209\139\208\186\208\184\208\189\209\140 \208\180\209\131\209\128\208\181\208\189\209\140", 
    [72] = "\208\178 \208\186\208\187\208\176\208\178\208\184\209\136\208\176\209\133 \208\183\208\176\208\191\209\131\209\130\208\176\208\187\209\129\209\143 \208\180\208\190\208\187\208\177\208\176\209\145\208\177", 
    [73] = "\208\190\208\185 \208\144\208\157602 \209\130\208\181\208\177\208\181 \208\178 \208\181\208\177\208\176\208\187\209\140\208\189\208\184\208\186 \208\191\209\128\208\184\208\187\208\181\209\130\208\181\208\187\208\176", 
    [74] = "\208\186\208\176\208\186 \209\130\208\176\208\188 \208\178 \208\186\208\176\208\183\208\176\209\133\209\129\209\130\208\176\208\189\208\181 \208\189\208\190\209\128\208\188 \208\186\209\131\209\128 \208\181\208\177\209\145\209\130\208\181?", 
    [75] = "\208\178\208\181\209\129\209\140 \208\178 \208\188\208\176\209\130\209\140 \208\191\208\190\209\136\208\181\208\187 \209\130\208\176\208\186 \208\182\208\181 \208\190\209\130 \208\191\209\131\208\187\208\184 \209\129\208\180\208\190\209\133", 
    [76] = "\208\190\208\180\208\189\208\190\208\179\208\190 \208\191\208\184\208\180\208\176\209\128\208\176\209\129\208\176 \208\183\208\176\209\133\209\131\209\143\209\135\208\184\208\187 \208\190\209\129\209\130\208\176\208\187\208\190\209\129\209\140 \208\181\209\137\208\181 \208\189\208\181\209\129\208\186\208\190\208\187\209\140\208\186\208\190", 
    [77] = "\208\191\209\128\209\143\208\188 \208\189\208\190\209\128\208\188\208\176\208\187\209\140\208\189\208\190 \208\181\208\177\208\176\208\187\209\140\208\189\208\184\208\186 \209\128\208\176\209\129\208\186\208\178\208\176\209\129\208\184\208\187 \208\180\209\131\209\128\208\190\209\135\208\186\209\131", 
    [78] = "\209\130\209\131\209\135\209\131 \209\133\209\131\208\181\208\178 \209\130\208\181\208\177\208\181 \208\178 \209\129\209\128\208\176\208\186\209\131 \208\177\208\181\208\183\208\180\208\176\209\128\209\140", 
    [79] = "\209\129\209\140\208\181\208\177\208\184\209\129\209\140 \209\129 \208\180\208\190\209\128\208\190\208\179\208\184 \209\133\209\131\208\181\208\191\208\187\209\145\209\130 \208\181\208\177\208\187\208\184\208\178\209\139\208\185", 
    [80] = "\208\183\208\176\208\181\208\177\208\184\209\129\209\140 \209\130\208\181\208\177\208\181 \208\186\209\128\209\142\208\186\208\190\208\188 \208\189\208\176 \208\186\208\187\208\176\208\178\208\184\209\136\208\184 \208\182\208\188\208\176\209\130\209\140", 
    [81] = "\208\183\209\128\209\143 \209\129 \209\128\208\181\209\129\208\191\209\139 \208\178\209\139\209\136\208\187\208\176 \209\136\208\188\208\176\209\128\208\176", 
    [82] = "\208\179\208\187\209\131\208\191\209\139\208\185 \209\129\208\178\208\184\208\189", 
    [83] = "\209\128\209\131\208\186\208\184 \209\129 \208\186\208\187\208\176\208\178\209\139 \209\131\208\177\209\128\208\176\208\187 \208\184 \208\184\208\180\208\184 \208\180\208\190\208\188\208\176\209\133\209\131 \208\180\208\181\208\187\208\176\208\185", 
    [84] = "\209\129\208\190\208\182\209\128\208\176\208\187 \208\186\209\128\208\184\208\191\208\190\209\135\208\186\208\176", 
    [85] = "\208\189\208\181 \208\190\209\128\208\184 \208\179\208\176\208\189\208\180\208\190\208\189", 
    [86] = "\208\186\209\131\208\180\209\128\209\143\208\178\209\139\208\185 \208\179\208\176\208\189\208\179\209\129\209\130\208\181\209\128 \208\180\208\176\208\178\208\176\208\185 \208\189\208\176\208\183\208\176\208\180 \208\178 \208\191\208\190\208\180\208\178\208\176\208\187", 
    [87] = "\209\132\209\131\208\189\208\186\209\134\208\184\208\190\208\189\208\176\208\187 \209\130\208\178\208\190\208\181\208\185 \208\187\209\131\208\176\209\136\208\186\208\184 \209\133\209\131\208\181\208\178\209\139\208\185 \209\131 \208\188\208\181\208\189\209\143 \208\187\209\131\209\135\209\136\208\181", 
    [88] = "\208\188\208\176\208\189\208\184\208\186\209\142\209\128 \208\189\208\181 \208\183\208\176\208\191\208\176\209\135\208\186\208\176\208\185", 
    [89] = "\209\145\208\187\208\186\208\184 \208\191\208\176\208\187\208\186\208\184 \209\133\209\131\208\181\208\178\208\181\208\185 \209\130\208\181\208\177\209\143 \209\130\208\190\208\186 \209\129\208\176\208\189\209\135\208\181\208\183"
};
v72.on_death = function(v1345)
    -- upvalues: v51 (ref), v52 (ref), v32 (ref), v72 (ref), v30 (ref), v36 (ref)
    if not v51.get("killsay") then
        return;
    elseif not v52.local_player() then
        return;
    else
        local v1346 = v32.get(v1345.attacker, true);
        if not v1346 then
            return;
        else
            local v1347 = v32.get(v1345.userid, true);
            if not v1347 then
                return;
            elseif v1346 ~= v52.local_player() then
                return;
            elseif v1347 == v52.local_player() then
                return;
            else
                local v1348 = v72.phrases[v30.random_int(1, #v72.phrases)];
                if not v1348 then
                    return;
                else
                    v30.execute_after(v30.random_float(1.1, 3.3), function()
                        -- upvalues: v30 (ref), v36 (ref), v1348 (ref)
                        v30.console_exec(v36("say %s ", tostring(v1348)));
                    end);
                    return;
                end;
            end;
        end;
    end;
end;
v311.on_round_start = function(_)
    -- upvalues: v51 (ref), v30 (ref)
    if not v51.get("round_flash") then
        return;
    elseif not v30.is_csgo_selected() then
        return;
    else
        v30.flash_icon();
        return;
    end;
end;
v73.cvars = {
    chat = cvar.cl_chatfilters, 
    radar = cvar.cl_drawhud_force_radar, 
    ragdoll = cvar.cl_ragdoll_physics_enable, 
    decals = cvar.r_drawdecals, 
    legs_shadow = cvar.cl_foot_contact_shadows, 
    blood = cvar.violence_hblood, 
    disable_freezcam = cvar.cl_disablefreezecam, 
    showhelp = cvar.cl_showhelp, 
    autohelp = cvar.cl_autohelp, 
    rain = cvar.r_drawrain, 
    sprites = cvar.r_drawsprites
};
v73.override = function(v1350)
    -- upvalues: v73 (ref)
    v73.cvars.chat:int(v1350[1] and 0 or 63);
    v73.cvars.radar:int(v1350[2] and -1 or 1);
    v73.cvars.ragdoll:int(v1350[3] and 0 or 1);
    v73.cvars.decals:int(v1350[4] and 0 or 1);
    v73.cvars.legs_shadow:int(v1350[5] and 0 or 1);
    v73.cvars.blood:int(v1350[6] and 0 or 1);
    v73.cvars.disable_freezcam:int(v1350[7] and 1 or 0);
    v73.cvars.showhelp:int(v1350[7] and 0 or 1);
    v73.cvars.autohelp:int(v1350[7] and 0 or 1);
    v73.cvars.rain:int(v1350[7] and 0 or 1);
    v73.cvars.sprites:int(v1350[7] and 0 or 1);
end;
v73.update = function()
    -- upvalues: v51 (ref), v73 (ref)
    if not globals.is_connected then
        return;
    else
        local v1351 = v51.get("remove");
        v73.override(v1351);
        return;
    end;
end;
v73.destroy = function()
    -- upvalues: v73 (ref)
    v73.override({
        [1] = false, 
        [2] = false, 
        [3] = false, 
        [4] = false, 
        [5] = false, 
        [6] = false, 
        [7] = false
    });
end;
v75.trace = v39;
v75.should_crouch = false;
v75.fast_ladder = function(v1352)
    -- upvalues: v51 (ref), v52 (ref), v75 (ref), v25 (ref)
    if not v51.get("fast_ladder") then
        return;
    elseif not v52.is_alive then
        return;
    elseif not (v52.local_player().m_MoveType == 9) then
        if v75.should_crouch then
            v1352.in_duck = 1;
            v75.should_crouch = false;
        end;
        return;
    else
        v75.should_crouch = false;
        if v1352.sidemove == 0 then
            v1352.view_angles.y = v1352.view_angles.y + 45;
        end;
        if v1352.in_forward then
            if v1352.sidemove < 0 then
                v1352.view_angles.y = v25.normalize_yaw(v1352.view_angles.y + 90);
            end;
            v1352.in_moveleft = false;
            v1352.in_moveright = true;
            v1352.in_forward = true;
        end;
        if v1352.in_back then
            if v1352.sidemove > 0 then
                v1352.view_angles.y = v25.normalize_yaw(v1352.view_angles.y + 90);
            end;
            v1352.in_moveleft = true;
            v1352.in_moveright = false;
        end;
        if v1352.view_angles.x > -45 then
            v1352.view_angles.x = -45;
        end;
        if not v75.should_crouch then
            v75.should_crouch = true;
        end;
        return;
    end;
end;
v75.avoid_collisions = function(v1353)
    -- upvalues: v51 (ref), v52 (ref), v29 (ref), v25 (ref), l_vector_0 (ref), v75 (ref), v30 (ref), v39 (ref)
    if not v51.get("avoid_collisions") then
        return;
    elseif not v1353.in_jump then
        return;
    elseif v51.references.slow_walk:get() then
        return;
    elseif v1353.in_moveright or v1353.in_moveleft or v1353.in_back then
        return;
    else
        local v1354 = v52.local_player().m_vecVelocity:length();
        local l_m_vecOrigin_1 = v52.local_player().m_vecOrigin;
        local v1356 = v29.camera_angles();
        local _ = v1356.y;
        local l_huge_1 = v25.huge;
        local l_huge_2 = v25.huge;
        for v1360 = v1356.y - 90, v1356.y + 90, 15 do
            local v1361 = v25.rad(v1360);
            local v1362 = l_m_vecOrigin_1 + l_vector_0(v25.cos(v1361) * 70, v25.sin(v1361) * 70, 30);
            v75.trace = v30.trace_line(l_m_vecOrigin_1, v1362, v52.local_player(), v39, 1);
            local v1363 = l_m_vecOrigin_1:dist(v75.trace.end_pos);
            if v1363 < l_huge_1 then
                l_huge_1 = v1363;
                l_huge_2 = v1360;
            end;
        end;
        if l_huge_1 > 35 then
            return;
        else
            l_huge_2 = l_huge_2 - (v1356.y - 90);
            v1353.forwardmove = v25.abs(v1354 * v25.cos(v25.rad(l_huge_2)));
            v1353.sidemove = v1354 * v25.sin(v25.rad(l_huge_2)) * (l_huge_2 >= 90 and 1 or -1);
            return;
        end;
    end;
end;
v75.slow_walk = function(v1364)
    -- upvalues: v52 (ref), v51 (ref), v25 (ref)
    if not v52.is_alive then
        return;
    elseif not v51.references.slow_walk:get() then
        return;
    else
        local v1365 = v51.get("slow_walk");
        if v1365 == 0 then
            return;
        else
            v1364.forwardmove = v25.clamp(v1364.forwardmove, -v1365, v1365);
            v1364.sidemove = v25.clamp(v1364.sidemove, -v1365, v1365);
            return;
        end;
    end;
end;
v74.locations = {
    ["Error 1"] = "DigitalSounds/error.wav", 
    ["Wood Plank"] = "physics/wood/wood_plank_impact_hard4.wav", 
    ["Wood Strain"] = "physics/wood/wood_strain7.wav", 
    ["Wood Stop"] = "doors/wood_stop1.wav", 
    Warning = "resource/warning.wav", 
    Switch = "buttons/arena_switch_press_02.wav", 
    Woosh = "DigitalSounds/menu_load.wav"
};
v74.snd = cvar.snd_setmixer;
v74.on_local_hurt = function(v1366)
    -- upvalues: v32 (ref), v51 (ref), v74 (ref), v154 (ref)
    local v1367 = v32.get_local_player();
    if not v1367 then
        return;
    else
        local v1368 = v51.get("local_hurt");
        if not v1368 or v1368 == "Disable" then
            return;
        else
            local v1369 = v32.get(v1366.userid, true);
            if not v1369 or v1369 ~= v1367 then
                return;
            elseif not v32.get(v1366.attacker, true) then
                return;
            else
                local v1370 = v74.locations[v1368];
                v154.play_sound(v1370, v51.get("local_hurt_volume") / 100, 100, 0, 0);
                return;
            end;
        end;
    end;
end;
v74.player_weapon = function()
    -- upvalues: v52 (ref), v154 (ref), v36 (ref), v51 (ref)
    local v1371 = v52.local_player():get_player_weapon():get_name();
    v154.play_sound(v36("DigitalSounds/%s.wav", v1371), v51.get("weapons_sounds_volume") / 100, 100, 0, 0);
end;
v74.manual_shoot = function(v1372)
    -- upvalues: v74 (ref), v52 (ref), v51 (ref), v30 (ref)
    v74.snd:call("Weapons1", "vol", 0.7);
    if not v52.is_alive then
        return;
    elseif not v51.get("weapons_sounds") then
        return;
    else
        local v1373 = v52.local_player():get_player_weapon();
        if not v1373 then
            return;
        elseif v1373:get_weapon_info().is_revolver then
            return;
        else
            if v1372.in_attack and v30.can_fire(v52.local_player()) and not v51.references.fake_duck:get() then
                v74.player_weapon();
            end;
            v74.snd:call("Weapons1", "vol", 0);
            return;
        end;
    end;
end;
v74.auto_fire = function()
    -- upvalues: v51 (ref), v74 (ref)
    if not v51.get("weapons_sounds") then
        return;
    else
        v74.player_weapon();
        return;
    end;
end;
v315 = nil;
v315 = {};
v547 = function(v1374)
    -- upvalues: v29 (ref), v41 (ref), v154 (ref), v49 (ref), v39 (ref), l_vector_0 (ref), l_color_0 (ref)
    local v1375 = v29.screen_size();
    local v1376 = v29.original.load_font(v41, 16, "ad");
    local v1377 = v29.original.load_font(v41, 70, "abd");
    v154.play_sound("DigitalSounds/error.wav", 1, 100, 0, 0);
    v49.attach("render", function()
        -- upvalues: v29 (ref), v1376 (ref), v39 (ref), v1374 (ref), l_vector_0 (ref), v1375 (ref), l_color_0 (ref), v1377 (ref)
        local v1378 = v29.preform_animation("lua::error::alpha", 1);
        if v1378 == 0 then
            return;
        else
            local v1379 = v29.original.measure_text(v1376, v39, v1374);
            local v1380 = v1378 * 150;
            v29.push_clip_rect(l_vector_0(100, v1375.y / 2 - 80), l_vector_0(500, v1375.y / 2 + 80));
            v29.circle_gradient(l_vector_0(300, v1375.y / 2), l_color_0(150, 0), l_color_0(150, 150, 255, v1380), 190, 0, 1);
            v29.pop_clip_rect();
            v29.blur(l_vector_0(100, v1375.y / 2 - 80), l_vector_0(501, v1375.y / 2 + 81), v1378 * 0.1, v1378, 10);
            v29.rect(l_vector_0(100, v1375.y / 2 - 80), l_vector_0(500, v1375.y / 2 + 80), l_color_0(10, 10, 30, 100 * v1378), 10);
            v29.original.text(v1376, l_vector_0(120 + v1379.x / 2, v1375.y / 2), l_color_0(255, 255 * v1378), "c", v1374);
            v29.original.text(v1377, l_vector_0(460, v1375.y / 2), l_color_0(255, 255 * v1378), "c", "!");
            return;
        end;
    end, "lua::error::render", false);
end;
do
    local l_v547_0 = v547;
    v315.main = function(_)
        -- upvalues: v47 (ref), v49 (ref), v30 (ref), v33 (ref), v39 (ref), l_v547_0 (ref), v31 (ref), v36 (ref), v29 (ref), v51 (ref), v311 (ref), v64 (ref), v111 (ref), v50 (ref), v71 (ref), v52 (ref), v58 (ref), v70 (ref), v60 (ref), v61 (ref), v62 (ref), v69 (ref), v66 (ref), v65 (ref), v67 (ref), v68 (ref), v74 (ref), v53 (ref), v54 (ref), v73 (ref), v75 (ref), v55 (ref), v56 (ref), v57 (ref), v72 (ref), v63 (ref), v46 (ref), v154 (ref)
        cvar.clear:call();
        if v47 then
            print(v49.safe_mode);
        end;
        v30.csgo_hwnd = v33.C.FindWindowA("Valve001", v39);
        if not v33.istype("void*", v30.csgo_hwnd) then
            return l_v547_0("Failed to find csgo window handle.\nPlease contact our support via Discord sever");
        elseif not v31.initialize_icons() then
            return l_v547_0(v36("Failed to download Icons.\n%s\nTry to avoid using third party application like Migi,\n and join our discord server\nfor more information.", v31.last_error));
        elseif not v31.initialize_sounds() then
            return l_v547_0(v36("Failed to download Sounds.\n%s\nTry to avoid using third party application like Migi,\n and join our discord server\nfor more information.", v31.last_error));
        elseif not v31.initialize_configs() then
            return l_v547_0("Failed to setup Configs.\nPlease Join our discord server\nfor more information.");
        elseif not v29.initialize_fonts() then
            return l_v547_0(v36("Failed to setup render fonts.\nError : %s", v29.last_error));
        elseif not v51.initialize_icons() then
            return l_v547_0("Failed to setup menu icons.\nPlease Join our discord server\nfor more information.");
        else
            if not v49.initialize() then
                v311.add("Failed to setup Keyboard Hook. Some options wont be available", v51.icons.error);
            end;
            if not v51.initialize_elements() then
                return l_v547_0("Failed to setup menu elements.\nPlease Join our discord server\nfor more information.");
            else
                if not v64.initialize() then
                    v311.add(v64.last_error, v51.icons.error);
                end;
                v49.attach("render", v111.process, "lua::windows::process");
                v49.attach("render", v50.preform_colors, "lua::theme::preform_colors");
                v49.attach("render", v71.handle, "lua::clantag::render");
                v49.attach("render", v52.update, "lua::global::update");
                v49.attach("render", v58.manuals, "lua::anti_aim::manuals");
                v49.attach("render", v58.each_frame, "lua::anti_aim::each_frame");
                v49.attach("render", v64.setup, "lua::headup_display::setup");
                v49.attach("render", v64.health_and_armor, "lua::headup_display::setup");
                v49.attach("render", v64.weapons, "lua::headup_display::setup");
                v49.attach("render", v64.killfeed, "lua::headup_display::setup");
                v49.attach("render", v64.round, "lua::headup_display::setup");
                v49.attach("render", v64.chat, "lua::headup_display::setup");
                v49.attach("render", v70.render_shots, "lua::markers::shots");
                v49.attach("render", v70.render_damage, "lua::markers::damage");
                v49.attach("render", v60.render, "lua::scope::render");
                v49.attach("render", v61.render, "lua::view::render");
                v49.attach("render", v62.render, "lua::world::render");
                v49.attach("render", v69.render, "lua::side_indicators::render");
                v49.attach("render", v64.player_spawn, "lua::headup_display::player_spawn");
                v66.window:register_render(v66.render, "lua::watermark::render");
                v65.window:register_render(v65.render, "lua::keybinds::render");
                v67.window:register_render(v67.render, "lua::logs_system::render");
                v68.window:register_render(v68.render, "lua::warning_system::render");
                if not v51.initialize_window() then
                    return l_v547_0("Failed to setup menu window.\nPlease Join our discord server\nfor more information.");
                else
                    v49.attach("low_level_keyboard", v64.enable_chat, "lua::headup_display::enable_chat");
                    v49.attach("low_level_keyboard", v64.capture_input, "lua::headup_display::capture_input");
                    v49.attach("mouse_input", v64.capture_mouse, "lua::headup_display::capture_mouse");
                    v49.attach("render", v311.render, "lua::notify::render");
                    v49.attach("createmove", v74.manual_shoot, "lua::sounds::manual_shoot");
                    v49.attach("createmove", v53.hideshots, "lua::exploits::hideshots");
                    v49.attach("createmove", v53.uncharge_attack, "lua::exploits::uncharge_attack");
                    v49.attach("createmove", v53.handle_charge, "lua::exploits::handle_charge");
                    v49.attach("createmove", v54.update, "lua::hitchance::update");
                    v49.attach("createmove", v73.update, "lua::removes::update");
                    v49.attach("createmove", v75.avoid_collisions, "lua::movement::avoid_collisions");
                    v49.attach("createmove", v75.fast_ladder, "lua::movement::fast_ladder");
                    v49.attach("createmove", v75.slow_walk, "lua::movement::slow_walk");
                    v49.attach("createmove", v55.createmove, "lua::on_use::createmove");
                    v49.attach("createmove", v56.createmove, "lua::edge_yaw::createmove");
                    v49.attach("createmove", v57.createmove, "lua::anti_bruteforce::createmove");
                    v49.attach("createmove", v58.main, "lua::anti_aim::createmove");
                    v49.attach("override_view", v60.view, "lua::scope::view");
                    v49.attach("override_view", v68.view, "lua::warning_system::view");
                    v49.attach("player_death", v58.death, "lua::anti_aim::death");
                    v49.attach("player_death", v72.on_death, "lua::killsay::death");
                    v49.attach("player_death", v64.on_kill, "lua::headup_display::on_kill");
                    v49.attach("player_death", v64.player_death, "lua::headup_display::player_death");
                    v49.attach("round_start", v58.round_start, "lua::anti_aim::round_start");
                    v49.attach("round_start", v67.round_start, "lua::logs_system::round_start");
                    v49.attach("round_start", v311.on_round_start, "lua::notify::round_start");
                    v49.attach("round_start", v64.round_start, "lua::headup_display::round_start");
                    v49.attach("round_end", v58.round_end, "lua::anti_aim::round_end");
                    v49.attach("round_end", v64.round_end, "lua::headup_display::round_end");
                    v49.attach("bomb_planted", v64.bomb_planted, "lua::headup_display::bomb_planted");
                    v49.attach("player_say", v64.capture_messages, "lua::headup_display::capture_messages");
                    v49.attach("player_hurt", v74.on_local_hurt, "lua::sounds::local_hurt");
                    v49.attach("player_hurt", v57.detect_hit, "lua::anti_bruteforce::hurt");
                    v49.attach("player_hurt", v67.grenades, "lua::logs_system::hurt");
                    v49.attach("player_hurt", v70.player_hurt, "lua::markers::hurt");
                    v49.attach("bullet_impact", v57.detect_bullet, "lua::anti_bruteforce::bullet");
                    v49.attach("bullet_impact", v62.impact, "lua::world::bullet");
                    v49.attach("aim_ack", v67.aim_fire, "lua::logs_system::aim_fire");
                    v49.attach("aim_ack", v70.shots, "lua::markers::aim_fire");
                    v49.attach("aim_fire", v74.auto_fire, "lua::sounds::aim_fire");
                    v49.attach("item_purchase", v67.purshes, "lua::logs_system::item_purchase");
                    v49.attach("post_update_clientside_animation", v63.update, "lua::animations::post_update");
                    v49.attach("localplayer_transparency", v63.transparency, "lua::animations::transparency");
                    v49.attach("shutdown", v71.destroy, "lua::clantag::destroy");
                    v49.attach("shutdown", v64.destroy, "lua::headup_display::destroy");
                    v49.attach("shutdown", v58.destroy, "lua::anti_aim::destroy");
                    v49.attach("shutdown", v60.destroy, "lua::scope::destroy");
                    v49.attach("shutdown", v61.destroy, "lua::view::destroy");
                    v49.attach("shutdown", v62.destroy, "lua::world::destroy");
                    v49.attach("shutdown", v65.destroy, "lua::keybinds::destroy");
                    v49.attach("shutdown", v66.destroy, "lua::watermark::destroy");
                    v49.attach("shutdown", v67.destroy, "lua::logs_system::destroy");
                    v49.attach("shutdown", v68.destroy, "lua::warning_system::destroy");
                    v49.attach("shutdown", v73.destroy, "lua::removes::destroy");
                    v49.attach("shutdown", v63.destroy, "lua::animations::destroy");
                    v49.attach("shutdown", v53.destroy, "lua::exploits::destroy");
                    v49.attach("shutdown", v54.destroy, "lua::hitchance::destroy");
                    v311.add(v36("Welcome back %s. Last update was %s", common.get_username(), v46), v51.icons.open_check);
                    v154.play_sound("DigitalSounds/menu_load.wav", 1, 100, 0, 0);
                    return;
                end;
            end;
        end;
    end;
end;
v315.main();