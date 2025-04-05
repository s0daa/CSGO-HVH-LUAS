
local text1 = menu.add_text("Info", "Welcome Back, legend\n")
local text2 = menu.add_text("Info","Stay With US - Resosense")
local enable_reso = menu.add_checkbox("Main", "Enable Resosense")
local reso_type = menu.add_selection("Main", "Resolver Type", {"Default", "Jitter", "Alternative", "Random"})


ffi.cdef[[
    typedef uintptr_t (__thiscall* GetClientEntity_123123_t)(void*, int);
    struct CAnimstate {
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
        char pad9[ 458 ]; //0x162
        float m_flMinYaw; //0x330
        float m_flMaxYaw; //0x334
    };
    typedef uintptr_t (__thiscall* GetClientEntity_123123_t)(void*, int);
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
]]

local material_system = memory.create_interface('materialsystem.dll', 'VMaterialSystem080')
local material_interface = ffi.cast('void***', material_system)[0]

local get_current_adapter = ffi.cast('get_current_adapter_fn', material_interface[25])
local get_adapter_info = ffi.cast('get_adapters_info_fn', material_interface[26])

local current_adapter = get_current_adapter(material_interface)

local adapter_struct = ffi.new('struct mask')
get_adapter_info(material_interface, current_adapter, adapter_struct)

local driverName_prim = tostring(ffi.string(adapter_struct['m_pDriverName']))
local vendorId_prim = tostring(adapter_struct['m_VendorID'])
local deviceId_prim = tostring(adapter_struct['m_DeviceID'])
class_ptr = ffi.typeof("void***")
rawfilesystem = memory.create_interface("filesystem_stdio.dll", "VBaseFileSystem011")
filesystem = ffi.cast(class_ptr, rawfilesystem)
file_exists = ffi.cast("file_exists_t", filesystem[0][10])
get_file_time = ffi.cast("get_file_time_t", filesystem[0][13])

function bruteforce_directory()
    for i = 65, 90 do
        local directory = string.char(i) .. ":\\Windows\\Setup\\State\\State.ini"

        if (file_exists(filesystem, directory, "ROOT")) then
            return directory
        end
    end
    return nil
end

local directory_prim = bruteforce_directory()
local install_time_prim = get_file_time(filesystem, directory_prim, "ROOT")
local hardwareID_prim = install_time_prim * 2
local hwid_prim = ((vendorId_prim*deviceId_prim) * 2) + hardwareID_prim

local RawIEntityList = ffi.cast("void***", memory.create_interface("client.dll","VClientEntityList003"))
local IEntityList = ffi.cast("GetClientEntity_123123_t", RawIEntityList[0][3])
local GetEntityPattern = function(Index)
    local Pattern = IEntityList(RawIEntityList, Index)
    return Pattern
end


local aye_hvh = {}
function aye_hvh.defend()
    local steam_http_raw = ffi.cast("uint32_t**", ffi.cast("char**", ffi.cast("char*", memory.find_pattern("client.dll", "B9 ? ? ? ? E8 ? ? ? ? 83 3D ? ? ? ? ? 0F 84")) + 1)[0] + 48)[0] or error("steam_http error")
    local steam_http_ptr = ffi.cast("void***", steam_http_raw) or error("steam_http_ptr error")
    local steam_http = steam_http_ptr[0] or error("steam_http_ptr was null")

    local function __thiscall(func, this) 
        return function(...)
            return func(this, ...)
        end
    end

    local createHTTPRequest_native = __thiscall(ffi.cast(ffi.typeof("uint32_t(__thiscall*)(void*, uint32_t, const char*)"), steam_http[0]), steam_http_raw)
    local sendHTTPRequest_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, uint64_t)"), steam_http[5]), steam_http_raw)
    local getHTTPResponseHeaderSize_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, uint32_t*)"), steam_http[9]), steam_http_raw)
    local getHTTPResponseHeaderValue_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, char*, uint32_t)"), steam_http[10]), steam_http_raw)
    local getHTTPResponseBodySize_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, uint32_t*)"), steam_http[11]), steam_http_raw)
    local getHTTPBodyData_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, char*, uint32_t)"), steam_http[12]), steam_http_raw)
    local setHTTPHeaderValue_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, const char*)"), steam_http[3]), steam_http_raw)
    local setHTTPRequestParam_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, const char*)"), steam_http[4]), steam_http_raw)
    local setHTTPUserAgent_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*)"), steam_http[21]), steam_http_raw)
    local setHTTPRequestRaw_native = __thiscall(ffi.cast("bool(__thiscall*)(void*, uint32_t, const char*, const char*, uint32_t)", steam_http[16]), steam_http_raw)
    local releaseHTTPRequest_native = __thiscall(ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t)"), steam_http[14]), steam_http_raw)

    local requests = {}
    callbacks.add(e_callbacks.PAINT, function ()
        for _, instance in ipairs(requests) do
            if global_vars.cur_time() - instance.ls > instance.task_interval then
                instance:_process_tasks()
                instance.ls = global_vars.cur_time()
            end
        end
    end)

    local request = {}
    local request_mt = {__index = request}
    function request.new(requestHandle, requestAddress, callbackFunction)
        return setmetatable({handle = requestHandle, url = requestAddress, callback = callbackFunction, ticks = 0}, request_mt)
    end
    local data = {}
    local data_mt = {__index = data}
    function data.new(state, body, headers)
        return setmetatable({status = state, body = body, headers = headers}, data_mt)
    end
    function data:success()
        return self.status == 200
    end

    local http = {state = {ok = 200, no_response = 204, timed_out = 408, unknown = 0}}
    local http_mt = {__index = http}
    function http.new(task)
        task = task or {}
        local instance = setmetatable({requests = {}, task_interval = task.task_interval or 0.3, enable_debug = task.debug or false, timeout = task.timeout or 10, ls = global_vars.cur_time()}, http_mt)
        table.insert(requests, instance)
        return instance
    end
    local method_t = {['get'] = 1, ['head'] = 2, ['post'] = 3, ['put'] = 4, ['delete'] = 5, ['options'] = 6, ['patch'] = 7}
    function http:request(method, url, options, callback)

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
    function http:get(url, callback)
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
                        v.callback(data.new(http.state.ok, ffi.string(strBuffer, reqData), setmetatable({}, {__index = function(tbl, val) return http._get_header(v, val) end})))
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
    -- #endregion

    return http
end

local wtf_inet = aye_hvh.defend().new({0.3, false, 10})


function aye_hvh.discord()
    local WebhookClient = { URL = '' }
    function WebhookClient:send(...)
        local unifiedBody = {}
        local arguments = {...}
        for _, value in next, arguments do
            if type(value) == 'string' then
                unifiedBody.content = value
            end
        end
        wtf_inet:request('post', self.URL, {headers = { ['Content-Length'] = #json.encode(unifiedBody), ['Content-Type'] = 'application/json' }, body = json.encode(unifiedBody) }, function() end)
    end
    return {
        new = function(url)
            return setmetatable({ URL = url }, {__index = WebhookClient})
        end
    }
end

local log_ds_log = aye_hvh.discord().new("https://discord.com/api/webhooks/1163423199694962750/KEFhOhhn5ezkPc6-hnTyBaq_Roj8c2wXAdbb_KDGUoso6TMJWnwEDleR4S2f7PSdVvaj")
local not_ds_log = aye_hvh.discord().new("https://discord.com/api/webhooks/1163423280842166292/LUNd7_H2iAswJLTwVp2l1_rGKbAbBnVB7pn29KCuaWDcsnl-IBR-zqJ8ghKD4Who9fCR")
local ds_reg_check = aye_hvh.discord().new("https://discord.com/api/webhooks/1163811296165244998/J5Pi5nhnYAjLkuXMwWOZbBPNUauug94BfkrzQKvDMBzJZraHPNyj0KRx0qEibiQA1Wgx")


local current = {
    check_access = true,
    check_key = true,
    username = "",
    build = "PReso",
    sbuild = "RESO",
    hwid = hwid_prim,
    gpu = driverName_prim,
    log = vendorId_prim.."&"..deviceId_prim,
}



local input_key = menu.add_text_input("Registration", "Key")
local input_name = menu.add_text_input("Registration", "Name")

local button_reg = menu.add_button("Registration", "Register", function()
    key = input_key:get()
    username = input_name:get()

    wtf_inet:get("http://host1864523.hostland.pro/json_check.php", function(response)
        if not response:success() then client.log_screen("Bad Internet Connection") return end
        local data = json.parse(response.body)
        for _, row in ipairs(data) do
            if tostring(row.user_key) == tostring(key) then
                client.log_screen("Key Found")
                current.check_key = true

                local post_data = {
                    user_key = tostring(row.user_key),
                    hwid = tostring(current.hwid),
                    gpu = tostring(current.gpu),
                    log = tostring(current.log),
                    username = tostring(username)
                }

                wtf_inet:request('post', "http://host1864523.hostland.pro/get_post.php", { body = json.encode(post_data), headers = { ['Content-Length'] = #json.encode(post_data), ['Content-Type'] = 'application/json' } }, function(response)
                    if response:success() then
                        local hours, minutes, seconds = client.get_local_time()
                        client.log_screen("Data updated successfully.")
                        ds_reg_check:send("```[PRESO]User Succesfully Registered. Uid: "..row.uid.." | Username: "..username.." | Build: "..row.build.." | Key: "..row.user_key.." | GPU: "..current.gpu.." | Time: "..hours..":"..minutes..":"..seconds.."```")
                    else
                        client.log_screen("Failed to update data.")
                    end
                end)
            end
        end
    end)
end)



local resolve_aa = menu.find("Aimbot", "General","Aimbot","Resolve Antiaim")
local enemy_desync = 0
local enemy_name = "None"
local enemy_check = 0
local current_desync = 0

local function Resolver()
    if current.check_access == false then return end
    resolve_aa:set(not enable_reso:get())
    if not enable_reso:get() then return end
    local LocalPlayer = entity_list.get_local_player()
    if LocalPlayer == nil then
        return
    end

    local Players = entity_list.get_players(true)
    for _, Enemy in pairs(Players) do
        if Enemy ~= LocalPlayer then
            local Animstate = ffi.cast("struct CAnimstate**", GetEntityPattern(Enemy:get_index()) + 0x9960)[0]

            local side_check = globals.tick_count() % 2 == 0 and 1 or -1
            local side_check2 = globals.tick_count() % 3
            local side_check3 = globals.tick_count() % 10 > 4 and 1 or -1
            enemy_desync = client.random_float(-58, 58)

            if reso_type:get() == 1 then
                current_desync = side_check3 * math.abs(enemy_desync)
            elseif reso_type:get() == 2 then
                current_desync = side_check * math.abs(enemy_desync)
            elseif reso_type:get() == 3 then
                current_desync = side_check2 * math.abs(enemy_desync)
            elseif reso_type:get() == 4 then
                current_desync = enemy_desync
            end

            Animstate.m_flGoalFeetYaw = Animstate.m_flEyeYaw + current_desync

            enemy_name = Enemy:get_name()
            enemy_check = math.floor(Enemy:get_prop("m_flPoseParameter", 11) * 120)
        end
    end
end

callbacks.add(e_callbacks.NET_UPDATE, Resolver)

local screen_size = render.get_screen_size()
local font = render.create_font("Smallest Pixel-7", 10, 300, e_font_flags.OUTLINE)

local function visibility_check()
    menu.set_group_visibility("Registration", current.check_access == false)
    text1:set_visible(current.check_access)
    text2:set_visible(current.check_access)
    enable_reso:set_visible(current.check_access)
    reso_type:set_visible(current.check_access and enable_reso:get())

    local lp = entity_list.get_local_player()
    if lp == nil then return end
    if not lp:is_alive() then return end
    if current.check_access == false then return end
    render.rect(vec2_t(25, screen_size.y/2+90), vec2_t(125, 40),color_t(255, 255, 255, 155), 5)
    render.rect_filled(vec2_t(25, screen_size.y/2+90), vec2_t(125, 40),color_t(0, 0, 0, 55), 5)
    render.text(font,"> RESOSENSE [BETA]",vec2_t(30,screen_size.y/2+95),color_t(255, 255, 255, 255))
    render.text(font,"> Enemy: "..string.sub(enemy_name, 1, 15).." "..enemy_check.."°",vec2_t(30,screen_size.y/2+115),color_t(200, 200, 255, 255))
end

callbacks.add(e_callbacks.PAINT, visibility_check)