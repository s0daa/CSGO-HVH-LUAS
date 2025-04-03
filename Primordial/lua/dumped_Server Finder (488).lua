local tbl =  {
    {
        server = "46.174.52.172:1488",
        type = 1
    },
    {
        server = "37.230.228.178:1337",
        type = 1
    },
    {
        server = "188.187.188.121:27015",
        type = 1
    },
    {
        server = "37.230.228.144:27015",
        type = 1
    },
    {
        server = "194.125.248.50:27015",
        type = 1
    },
    {
        server = "65.108.42.222:27030",
        type = 1
    },
    {
        server = "95.217.61.238:27015",
        type = 1
    },
    {
        server = "5.252.100.53:27042",
        type = 1
    },
    {
        server = "46.174.51.137:7777",
        type = 1
    },
    {
        server = "62.122.215.105:6666",
        type = 1
    },
    {
        server = "37.230.210.209:27015",
        pass = "R8-Project",
        type = 2
    },
    {
        server = "37.230.210.209:27025",
        pass = "R8-Project",
        type = 2
    },
    {
        server = "37.230.210.209:27035",
        pass = "R8-Project",
        type = 2
    },
    {
        server = "37.230.210.209:27045",
        pass = "R8-Project",
        type = 2
    },
    {
        server = "37.230.210.209:27055",
        pass = "R8-Project",
        type = 2
    },
    {
        server = "37.230.210.209:27065",
        pass = "R8-Project",
        type = 2
    },
    {
        server = "135.125.188.152:27013",
        type = 2
    },
    {
        server = "135.125.188.152:27014",
        type = 2
    },
    {
        server = "135.125.188.152:27018",
        type = 2
    },
    {
        server = "135.125.188.152:27015",
        type = 2
    },
    {
        server = "135.125.188.152:27016",
        type = 2
    },
    {
        server = "135.125.188.152:27017",
        type = 2
    },
    {
        server = "135.125.188.152:27019",
        type = 2
    },
    {
        server = "135.125.188.152:27073",
        type = 2
    },
    {
        server = "135.125.188.152:27050",
        type = 2
    },
    {
        server = "135.125.188.152:27042",
        type = 2
    },
    {
        server = "135.125.188.152:27060",
        type = 2
    },
    {
        server = "135.125.188.152:27055",
        type = 2
    },
    {
        server = "135.125.188.152:27064",
        type = 2
    },
    {
        server = "135.125.188.152:27065",
        type = 2
    },
    {
        server = "135.125.188.152:27072",
        type = 2
    },
    {
        server = "135.125.188.152:27075",
        type = 2
    },
    {
        server = "135.125.188.152:27045",
        type = 2
    },
    {
        server = "135.125.188.152:27037",
        type = 2
    },
    {
        server = "135.125.188.152:27035",
        type = 2
    },
    {
        server = "62.122.213.72:27015",
        type = 2
    },
    {
        server = "194.93.2.173:27015",
        type = 2
    },
    {
        server = "46.174.54.86:27015",
        type = 2
    },
    {
        server = "194.147.90.113:27014",
        type = 2
    },
    {
        server = "194.147.90.113:27017",
        type = 2
    },
    {
        server = "46.174.55.224:27015",
        type = 2
    },
    {
        server = "46.174.55.202:27015",
        type = 2
    },
    {
        server = "62.122.214.158:27015",
        type = 2
    },
    {
        server = "194.93.2.169:27015",
        type = 3
    },
    {
        server = "37.230.162.24:1337",
        type = 3
    },
    {
        server = "46.174.51.108:27015",
        type = 3
    },
    {
        server = "62.122.214.79:27015",
        type = 3
    },
    {
        server = "37.230.210.191:2701",
        type = 3
    },
    {
        server = "37.230.162.30:2701",
        type = 3
    },
    {
        server = "194.93.2.148:2701",
        type = 3
    },
}

local httpfac = require "primordial/Lightweight HTTP Library.46"
local json = require "primordial/JSON Library.97"
local http = httpfac.new({
    task_interval = 0.3,
    enable_debug = false,
    timeout = 300
})
local info_w = menu.add_text("Server Finder [INFO]", ("Welcome, %s [%s]"):format(user.name, user.uid))
local _ = menu.add_separator("Server Finder [INFO]")
local info_s = menu.add_text("Server Finder [INFO]", "Total Server Count: " .. #tbl)
local loading_t = menu.add_text("Server Finder", "Loading ...")
local types = menu.add_selection("Server Finder", "Server Type", {"Public", "2X2", "DM"})
local info_i = menu.add_text("Server Finder [INFO]", "Server Types: " .. #types:get_items())
local list_box = menu.add_list("Server Finder", "Server", {})
local list_data = {[1] = {}, [2] = {}, [3] = {}}
local ready_to_upd = false

local cached_data = {[1] = {""}, [2] = {""}, [3] = {""}}
local function find_val(val) for i=1, #tbl do local tb = tbl[i] if tb.infor == val then return i end end end
local btn = menu.add_button("Server Finder", "Connect", function() 
    if list_box:get() == nil or not ready_to_upd then return end
    local pos = find_val(list_box:get_item_name(list_box:get()))
    if pos == nil then return end
    local vl = tbl[pos].pass ~= nil and ("%s;password %s"):format(tbl[pos].server, tbl[pos].pass) or tbl[pos].server
    if vl == nil then return end
    engine.execute_cmd("connect " .. vl)
end)

local function cat_update()
if ready_to_upd then cached_data = {[1] = {""}, [2] = {""}, [3] = {""}} end
for i=1, #tbl do
local v = tbl[i]
if v.infor == nil then goto con end
cached_data[v.type][#cached_data[v.type] + 1] = v.infor
::con::
if i == #tbl then
list_box:set_items(cached_data[types:get()])
end
end
end

local count = 0
local function update_lc()
if ready_to_upd then list_data = {[1] = {}, [2] = {}, [3] = {}} end
for i=1, #tbl do
local d = tbl[i]
local ip = d.server
local req = "https://api.steampowered.com/IGameServersService/GetServerList/v1/?key=AF1919C53966A1996C656BE18807F831&filter=addr\\" .. ip
http:get(req, function(r)
local success, info = pcall(json.parse, r.body)
local data
count = count + 1
if not success or not r.status or info["response"] == nil or info["response"]["servers"] == nil or info["response"]["servers"][1] == nil then
    tbl[i].invalid = true
    goto continue
end
if d == nil or tbl[i].invalid == true then goto continue end
data = info["response"]["servers"][1]
d.infor = ("%s - %s/%s"):format(data.name, data.players, data.max_players)
::continue::
if count == #tbl then
    cat_update()
    ready_to_upd = true
    handle_loading()
end
end)
end
end

update_lc()

local refresh_btn = menu.add_button("Server Finder", "Refresh", function() 
if not ready_to_upd then return end
update_lc()
end)

function handle_loading()
types:set_visible(ready_to_upd)
list_box:set_visible(ready_to_upd)
refresh_btn:set_visible(ready_to_upd)
btn:set_visible(ready_to_upd)
loading_t:set_visible(not ready_to_upd)
end
handle_loading()

local ls
local function update_list()
if not ready_to_upd or not menu.is_open() or types:get() == ls or list_box:get_items() == nil or list_box:get_items() == "" then return end
ls = types:get()
list_box:set_items(cached_data[types:get()])
end
callbacks.add(e_callbacks.PAINT, update_list)