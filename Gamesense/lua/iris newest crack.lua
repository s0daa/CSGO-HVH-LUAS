--[[
- Created by hazeyfrmdao x nanu 
]]
client.exec("clear")

client.exec("fps_max 0")

local http =            require("gamesense/http") or error("*you don't have the gamesense/http library installed, please install it and refresh the script!")
local json =            require("json") or error("*you don't have the JSON library installed, please install it and refresh the script!")
local ffi =             require("ffi") or error("*you don't have the FFI library installed, please install it and refresh the script!")

local iris = "~ Iris"
local loading = " Loading..."
local not_logged = " You're not authorized. To gain access, please utilize the /help command for authorization instructions."

-- loader
client.color_log(216, 233, 255, iris .. loading)

-- not logged in
client.delay_call(3, function()
    client.color_log(216, 233, 255, iris .. not_logged)
end)

-- Base64 decoding function
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function base64_decode(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r, f = '', (b:find(x) - 1)
        for i = 6, 1, -1 do r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and '1' or '0') end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c = 0
        for i = 1, 8 do c = c + (x:sub(i, i) == '1' and 2 ^ (8 - i) or 0) end
        return string.char(c)
    end))
end

-- Function to parse the encoded response
local function parse_response(response)
    if response.status == 200 then
        local decoded_body = base64_decode(response.body)
        local success, parsed_response = pcall(json.parse, decoded_body)
        if success then
            return parsed_response
        else
            client.color_log(154, 140, 212, "~ Iris Failed to parse JSON: " .. decoded_body)
            return nil
        end
    else
        client.color_log(154, 140, 212, "~ Iris HTTP error: " .. response.status)
        return nil
    end
end


local function login(username, password)
    local url = "http://a1005911.xsph.ru/login.php?username=" .. username .. "&password=" .. password
    http.get(url, function(success, response)
        if success then
            local data = parse_response(response)
            if data then
                if data.success then
                    if data.remaining_time then
                        client.color_log(154, 140, 212, "~ Iris Welcome back, " .. username .. "!")
                        client.color_log(154, 140, 212, "~ Iris Time remaining: " .. data.remaining_time)
                        -- Update user information or perform other actions based on remaining time
                    else
                        client.color_log(154, 140, 212, "~ Iris Couldn't fetch subscription")
                    end
                else
                    client.color_log(154, 140, 212, "~ Iris Failed to login: " .. (data.message or "Unknown error"))
                end
            else
                client.color_log(154, 140, 212, "~ Iris Failed to parse server response.")
            end
        else
            client.color_log(154, 140, 212, "~ Iris Failed to connect to the server.")
        end
    end)
end

local function register(username, password)
    local url = "http://a1005911.xsph.ru/register.php?username=" .. username .. "&password=" .. password
    http.get(url, function(success, response)
        if success then
            local data = parse_response(response)
            if data and data.success then
                client.color_log(154, 140, 212, "~ Iris You have successfully registered " .. username .. "!")
            else
                client.color_log(154, 140, 212, "~ Iris Registration failed: " .. (data and data.message or "Unknown error"))
            end
        else
            client.color_log(154, 140, 212, "~ Iris Failed to connect to the server.")
        end
    end)
end

local function redeem(username, code)
    local url = "http://a1005911.xsph.ru/redeem.php?code=" .. code .. "&username=" .. username
    http.get(url, function(success, response)
        if success then
            local data = parse_response(response)
            if data and data.success then
                client.color_log(154, 140, 212, "~ Iris Subscription redeemed for " .. data.duration .. " days")
            else
                client.color_log(154, 140, 212, "~ Iris Failed to redeem subscription key: " .. (data and data.message or "Unknown error"))
            end
        else
            client.color_log(154, 140, 212, "~ Iris Failed to connect to the server.")
        end
    end)
end

client.set_event_callback("console_print", function(text)
    if text == "[ephemeral] You don't have an active subscription" then
        user.username = "x"
    end
end)

local function execute_command(input)
    local cmd, arg1, arg2 = input:match("^/(%S+)%s*(%S*)%s*(.-)$")
    if cmd == "register" then
        if arg1 ~= "" and arg2 ~= "" then
            register(arg1, arg2)
        else
            client.color_log(154, 140, 212, "[ephemeral] Invalid: /register <username> <password>")
        end
    elseif cmd == "login" then
        if arg1 ~= "" and arg2 ~= "" then
            login(arg1, arg2)
        else
            client.color_log(154, 140, 212, "[ephemeral] Invalid: /login <username> <password>")
        end
    elseif cmd == "redeem" then
        if arg1 ~= "" and arg2 ~= "" then
            redeem(arg1, arg2)
        else
            client.color_log(154, 140, 212, "[ephemeral] Invalid: /redeem <username> <code>")
        end
    elseif cmd == "discord" then
        if arg1 ~= "" and arg2 ~= "" then
            link_discord(arg1, arg2)
        else
            client.color_log(154, 140, 212, "[ephemeral] Invalid: /linkdiscord <discord_username> <discord_id>")
        end
    elseif cmd == "help" then
        display_help()
    else
        -- Handle unknown command here
        client.color_log(154, 140, 212, "[ephemeral] Unknown command: " .. input)
    end
end

ui.new_label("LUA", "A", "📍 Active Scripts")

local scripts = {
    "✨ Im\aC5BBECB2pulse • 99 days left ", 
    "✨ Pa\aC5BBECB2ris • 99 days left", 
    "✨ Aven\aC5BBECB2sive • 99 days left", 
    "✨ Fu\aC5BBECB2sion • 99 days left", 
    "✨ Dan\aC5BBECB2gerous • 99 days left ", 
    "✨ Aim\aC5BBECB2tools • \aFF000092OLD / 99 days left", 
    "✨ Angel\aC5BBECB2wings • 99 days left",
    "✨ Wr\aC5BBECB2aith • \aFF000092NO ACCESS"
}

local script_list = ui.new_listbox("LUA", "A", "✨ Select Script", scripts)

local function load_script(script_name)
    local url = "http://a1005911.xsph.ru/luas/" .. script_name .. ".lua"
    http.get(url, function(success, response)
        if success then
            local script_content = response.body
            local chunk, err = load(script_content)
            if chunk then
                chunk()
            else
                client.color_log(178, 163, 236, "~ Iris Failed to load script: " .. err)
            end
        else
            client.color_log(178, 163, 236, "~ Iris Failed to load script.")
        end
    end)
end

client.set_event_callback("console_input", function(input)
    local cmd, arg1 = input:match("^/(%S+)%s*(.-)$")
    if cmd == "load" then
        load_script(arg1)
    end
end)

client.set_event_callback("console_input", function(input)
    execute_command(input)
end)

-- Define missing functions for completeness
local function link_discord(username, discord_id)
    client.color_log(154, 140, 212, "~ Iris Link Discord functionality not implemented yet.")
end

local function display_help()
    client.color_log(154, 140, 212, "~ Iris Available commands: /register, /login, /redeem, /linkdiscord, /help")
end

-- Ensure the user table is defined
local user = {}