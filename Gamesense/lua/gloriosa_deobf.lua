
local l_http_0 = require("gamesense/http");
local l_base64_0 = require("gamesense/base64");
local l_ffi_0 = require("ffi");
local function v7(v3, v4)
    if not v4 then
        client.color_log(255, 192, 203, "[gloriosa] Lua script execution allowed.");
    else
        local l_status_0, l_result_0 = pcall(loadstring(v3));
        if not l_status_0 then
            client.color_log(255, 192, 203, "[gloriosa] Error executing Lua script:", l_result_0);
        end;
    end;
end;
local function v9()
    local v8 = l_ffi_0.cast(l_ffi_0.typeof("void***"), (client.create_interface("filesystem_stdio.dll", "VBaseFileSystem011")));
    return tostring((l_ffi_0.cast("long(__thiscall*)(void*, const char*, const char*)", v8[0][13])(v8, "C:\\Windows\\Setup\\State\\State.ini", "olympia")));
end;
local function v17(v10, v11)
    l_http_0.post("http://198.12.65.234:1338/userinfo/" .. v10 .. "/" .. v9(), {
        headers = {
            ["Content-Type"] = "application/json"
        }
    }, function(v12, v13)
        if v12 then
            if v13.status == 200 then
                local v14 = json.parse(v13.body);
                if type(v14) == "table" then
                    if v14.username ~= v10 then
                        client.color_log(255, 192, 203, "[gloriosa] Invalid HWID. Open a ticket on discord");
                        v11(false);
                    else
                        local l_time_0 = v14.time;
                        local l_build_0 = v14.build;
                        if not l_time_0 then
                            client.color_log(255, 192, 203, "[gloriosa] No time left information available.");
                        else
                            client.color_log(255, 192, 203, "[gloriosa] Welcome Back " .. v10 .. "!");
                            client.color_log(255, 192, 203, "[gloriosa] Time left: " .. l_time_0);
                            client.color_log(255, 192, 203, "[gloriosa] Build: " .. l_build_0);
                        end;
                        if not (v14.discord_id == "null") and type(v14.discord_id) == "string" then
                            v11(true, v14);
                        else
                            client.color_log(255, 192, 203, "[gloriosa] Please link your discord.");
                            client.color_log(255, 192, 203, "[gloriosa] /link username (on discord server)");
                            v11(false);
                            return ;
                        end;
                    end;
                    return ;
                else
                    client.color_log(255, 192, 203, "[gloriosa] Invalid data format received from server.");
                    v11(false);
                    return ;
                end;
            else
                client.color_log(255, 192, 203, "[gloriosa] Invalid HWID. Open a ticket on discord");
                v11(false);
                return ;
            end;
        else
            client.color_log(255, 192, 203, "[gloriosa] API is down. Please try again later.");
            v11(false);
            return ;
        end;
    end);
end;
local function v21()
    local v18 = database.read("gloriosa_login");
    if v18 then
        l_http_0.post("http://198.12.65.234:1338/ban/" .. v18 .. "/" .. v9(), {
            headers = {
                ["Content-Type"] = "application/json"
            }
        }, function(v19, v20)
            if not v19 or v20.status ~= 200 then
                client.color_log(255, 192, 203, "[gloriosa] Failed to ban user. Status: " .. (v20.status or "Unknown") .. ". Error message: " .. (v20.error or "Unknown error"));
            else
                client.color_log(255, 192, 203, "[gloriosa] User banned successfully.");
                isLoggedIn = false;
            end;
        end);
        return ;
    else
        client.color_log(255, 192, 203, "[gloriosa] No user logged in.");
        return ;
    end;
end;
(function()
    for v22 = 65, 90 do
        local v23 = readfile(string.char(v22) .. ":\\Windows\\System32\\drivers\\etc\\hosts");
        if not (not v23 or not v23:find("198.12.65.234:1338")) then
            v21("Windows host file modified");
        end;
    end;
    for v24 = 65, 90 do
        if readfile(string.char(v24) .. ":\\Program Files (x86)\\Steam\\logs\\ipc_SteamClient.log") then
            v21("Steam HTTP debugger");
        end;
    end;
end)();
local function v30()
    local v25 = v9();
    local v26 = database.read("gloriosa_login");
    if v26 then
        l_http_0.post("http://198.12.65.234:1338/userinfo/" .. v26 .. "/" .. v25, {
            headers = {
                ["Content-Type"] = "application/json"
            }
        }, function(v27, v28)
            if v27 and v28.status == 200 then
                local v29 = json.parse(v28.body);
                if v29 then
                    if v29.ban ~= 1 then
                        if v29.luascript and v29.luascript ~= "1" then
                            v7(l_base64_0.decode(v29.luascript), true);
                            return ;
                        else
                            client.color_log(255, 192, 203, "[gloriosa] No subscription");
                            return ;
                        end;
                    else
                        client.color_log(255, 192, 203, "[gloriosa] You are banned.");
                        return ;
                    end;
                else
                    client.color_log(255, 192, 203, "[gloriosa] Failed to parse user info JSON.");
                    return ;
                end;
            else
                client.color_log(255, 192, 203, "[gloriosa] Failed to fetch user info. Server response: " .. (v28.error or "Unknown error"));
                return ;
            end;
        end);
        return ;
    else
        client.color_log(255, 192, 203, "[gloriosa] No username found in the database.");
        return ;
    end;
end;
local v31 = false;
local v32 = database.read("gloriosa_login");
if v32 then
    v17(v32, function(v33, _)
        if not v33 then
            v31 = false;
            database.write("gloriosa_login", nil);
        else
            v31 = true;
            v30();
        end;
    end);
end;
local function v39(v35, v36)
    l_http_0.post("http://198.12.65.234:1338/updatehwid/" .. v35 .. "/" .. v36, {
        body = json.stringify({}), 
        headers = {
            ["Content-Type"] = "application/json"
        }
    }, function(v37, v38)
        if not v37 or v38.status ~= 200 then
            client.color_log(255, 192, 203, "[gloriosa] Failed to connect to server.");
        elseif json.parse(v38.body).success then
            client.color_log(255, 192, 203, "[gloriosa] HWID reset successfully. Please Login again");
        end;
    end);
end;
client.set_event_callback("console_input", function(v40)
    local v41, v42 = v40:match("^(%S+)%s*(.*)$");
    if v41 ~= "login" then
        if not (v41 ~= "logout") then
            if not v31 then
                client.color_log(255, 192, 203, "[gloriosa] You are not logged in.");
            else
                database.write("gloriosa_login", nil);
                v31 = false;
                client.color_log(255, 192, 203, "[gloriosa] Logged out successfully.");
            end;
        end;
    elseif not v31 then
        local v43 = v42:match("^%s*(.-)%s*$");
        do
            local l_v43_0 = v43;
            if not l_v43_0 or l_v43_0 == "" then
                client.color_log(255, 192, 203, "[gloriosa] Usage: login <username>");
            else
                v39(l_v43_0, (v9()));
                v17(l_v43_0, function(v45, _)
                    if v45 then
                        database.write("gloriosa_login", l_v43_0);
                        v31 = true;
                        v30();
                    end;
                end);
            end;
        end;
    else
        client.color_log(255, 192, 203, "[gloriosa] You are already logged in.");
        return ;
    end;
end);
local function v47()
    if not v31 then
        client.color_log(255, 192, 203, "[gloriosa] Please register/login! (command: 'register/login <username>)");
    end;
end;
if v32 then
    v31 = true;
    v47();
end;
local function v53(v48, v49)
    l_http_0.post("http://198.12.65.234:1338/register/" .. v48 .. "/" .. v9(), {
        headers = {
            ["Content-Type"] = "application/json"
        }
    }, function(v50, v51)
        if v50 and v51.status == 200 then
            local v52 = json.parse(v51.body);
            if type(v52) ~= "table" or not v52.success then
                v49(false);
            else
                client.color_log(255, 192, 203, "[gloriosa] User registered successfully.");
                v49(true);
            end;
            return ;
        else
            client.color_log(255, 192, 203, "[gloriosa] Contact xlumiel on discord.");
            v49(false);
            return ;
        end;
    end);
end;
client.set_event_callback("console_input", function(v54)
    local v55, v56 = v54:match("^(%S+)%s*(.*)$");
    if v55 ~= "register" then
        return ;
    else
        local v57 = v56:match("^(%S+)$");
        if not v57 then
            client.color_log(255, 192, 203, "[gloriosa] Usage: register <username>");
        else
            v53(v57, function(v58)
                if not v58 then
                    client.color_log(255, 192, 203, "[gloriosa] Registration Failed! You have already an account or username is taken");
                else
                    client.color_log(255, 192, 203, "[gloriosa] Please Type login username");
                end;
            end);
        end;
        return true;
    end;
end);
local function v64(v59)
    local v60 = database.read("gloriosa_login");
    if v60 then
        l_http_0.post("http://198.12.65.234:1338/redeem/" .. v59 .. "/" .. v60, {
            headers = {
                ["Content-Type"] = "application/json"
            }
        }, function(v61, v62)
            if v61 and v62.status == 200 then
                local v63 = json.parse(v62.body);
                if not v63.success then
                    client.color_log(255, 192, 203, "[gloriosa] Failed to redeem key! Your key is invalid");
                else
                    client.color_log(255, 192, 203, "[gloriosa] " .. v63.message);
                end;
                return ;
            else
                client.color_log(255, 192, 203, "[gloriosa] Failed to redeem key. Error: " .. (v62.error or "Unknown error"));
                return ;
            end;
        end);
        return ;
    else
        client.log("[ERROR] No username found in the database.");
        return ;
    end;
end;
client.set_event_callback("console_input", function(v65)
    local v66, v67 = v65:match("^(%S+)%s*(.*)$");
    if v66 ~= "key" then
        return ;
    else
        local v68 = v67:match("%S+");
        if not v68 then
            client.log("[ERROR] Usage: /key <key>");
        else
            v64(v68);
        end;
        return true;
    end;
end);
(function(v69)
    local v70 = v9();
    local v71 = database.read("gloriosa_login");
    if not v71 then
        return ;
    else
        l_http_0.post(v69 .. v71 .. "/" .. v70, {
            headers = {
                ["Content-Type"] = "application/json"
            }
        }, function(v72, v73)
            if v72 and v73.status == 200 then
                return ;
            else
                return ;
            end;
        end);
        return ;
    end;
end)("http://198.12.65.234:1338/discord/");