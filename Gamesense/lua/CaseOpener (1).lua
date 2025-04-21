 --[[
    Made by coder man Bassn / hitome56
    Main Credits ::
        Sapphyrus - Big help for indexing paint kits as well as their images, big thanks :)
        Yukine    - Working file reading for images
        zPrism    - Main Test slave
        Kay       - Get Date Function
        And also the gamesense lua discord, lots of help from there <3 
]]
local ffi = require "ffi"
local localize = require "gamesense/localize" -- https://gamesense.pub/forums/viewtopic.php?id=30643
local images = require "gamesense/images" -- https://gamesense.pub/forums/viewtopic.php?id=22917
local csgo_weapons = require "gamesense/csgo_weapons" -- https://gamesense.pub/forums/viewtopic.php?id=18807

local InventoryAPI = panorama.open().InventoryAPI
local currency =  "¤"
local table_remove, table_insert = table.remove, table.insert
local get_absoluteframetime, globals_curtime = globals.absoluteframetime, globals.curtime
local database_read, database_write = database.read, database.write
local math_sin, math_pi, math_floor, math_random, math_min, math_max, math_abs = math.sin, math.pi, math.floor, client.random_int, math.min, math.max, math.abs
local ui_get, ui_set, ui_new_checkbox, ui_new_slider, ui_new_combobox, ui_new_listbox, ui_new_label, ui_set_visible, ui_reference, ui_new_hotkey = ui.get, ui.set, ui.new_checkbox, ui.new_slider, ui.new_combobox, ui.new_listbox, ui.new_label, ui.set_visible, ui.reference, ui.new_hotkey
local ui_menu_position, ui_new_multiselect, ui_menu_size, ui_is_menu_open, ui_mouse_position, ui_set_callback, ui_new_button = ui.menu_position, ui.new_multiselect, ui.menu_size, ui.is_menu_open, ui.mouse_position, ui.set_callback, ui.new_button
local client_color_log, client_screen_size, client_key_state, client_set_event_callback, client_userid_to_entindex, client_exec, client_delay_call, client_reload_active_scripts = client.color_log, client.screen_size, client.key_state, client.set_event_callback, client.userid_to_entindex, client.exec, client.delay_call, client.reload_active_scripts
local renderer_line, renderer_rectangle, renderer_gradient, renderer_text = renderer.line, renderer.rectangle, renderer.gradient, renderer.text
local entity_get_prop, entity_get_local_player, entity_get_player_name = entity.get_prop, entity.get_local_player, entity.get_player_name

local case_location       = "csgo_case_list_003"
local paint_kits_location = "cases_paint_kits_003"

local knife_location = "knife_list_003"
local glove_location = "glove_list_003"

local points_location     = "case_pointsx"
local inventory_location  = "case_inventoryX"

local case_menu_list = database_read(case_location) or nil
local case_do_update = false

local function update_cases(start, finish)
    local found_something = false
    for i = start, finish do -- all csgo cases are inside these indexs
        local id = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(i, 0)
        if InventoryAPI.GetLootListItemsCount(id) > 0 and InventoryAPI.GetAssociatedItemsCount(id) > 0 then
            local first_item = InventoryAPI.GetLootListItemIdByIndex(id, 0)
            local slot = InventoryAPI.GetSlot(first_item)

            if slot ~= "" and slot ~= "musickit" and slot ~= "flair0" and slot ~= "customplayer" then --thx sapph
                local case_name = InventoryAPI.GetItemName(id)
                case_menu_list[#case_menu_list + 1] = tostring(case_name)
                database_write(case_name, i) -- key system
                found_something = true
            end
        end
    end
    return found_something
end

local function index_all_cases() -- gotta do right here so the combobox has all items
    if case_menu_list == nil then
        case_menu_list = {}
        local updated = update_cases(4000, 5000)
        if updated then
            database_write(case_location, case_menu_list)
        end
    else
        local last_case = database_read(case_menu_list[#case_menu_list]) + 1
        local updated = update_cases(last_case, 5000)
        if updated then
            print("UPDATING CASES")
            case_do_update = true
            database_write(case_location, case_menu_list)
        end
    end
end
index_all_cases()

local mp = {"LUA", "B"}
local manual_sort = false
local menu = {
    cases_enable  = ui_new_checkbox(mp[1], mp[2], "⟡ Bassn's Case Opener ⟡"),
    cases_hotkey  = ui_new_hotkey  (mp[1], mp[2], " Open Case Hotkey"),

    cases_locked  = ui_new_checkbox(mp[1], mp[2], " Lock Window Position"),
    cases_pos     = ui_new_combobox(mp[1], mp[2], "\n", {"Top", "Bottom"}, 1),
    cases_i_pos   = ui_new_combobox(mp[1], mp[2], " Inventory Side", {"Right", "Left"}, 1),

    cases_audio   = ui_new_checkbox(mp[1], mp[2], " Audio"),
    cases_volume  = ui_new_slider  (mp[1], mp[2], "\nVolume", 1, 100, 50, true, "%"),
    cases_speed   = ui_new_checkbox(mp[1], mp[2], " Speed"),
    cases_speed_v = ui_new_slider  (mp[1], mp[2], "\nSpeed", 1, 5, 1, true, "x"),
    cases_stats   = ui_new_checkbox(mp[1], mp[2], " Show Statistics"),
    
    cases_sell    = ui_new_checkbox(mp[1], mp[2], " Auto Sell"),
    cases_sell_v  = ui_new_multiselect(mp[1], mp[2], "\nSell Type", {"Mil-spec grade", "Restricted", "Classified", "Covert", "Exceedingly Rare"}),
    
    cases_show    = ui_new_checkbox(mp[1], mp[2], " Always Show"),
    
    cases_skin_c  = ui_new_slider  (mp[1], mp[2], " Inventory Rows", 0, 5, 2, true, nil, 1, {[0] = "Hidden"}),
    
    cases_sort_t  = ui_new_combobox(mp[1], mp[2], " Inventory Sort mode", {"Price", "Rarity", "Chance"}, 1),
    cases_do_sort = ui_new_button  (mp[1], mp[2], " Sort Inventory", function()
        manual_sort = true
    end),
    cases_ascend  = ui_new_checkbox(mp[1], mp[2], " Sort Ascendingly (Inverse Sort)"),
    cases_auto    = ui_new_checkbox(mp[1], mp[2], " Auto Sort Inventory"),

    cases_chat    = ui_new_checkbox(mp[1], mp[2], " Show Unbox in Chat"),
    cases_chat_v  = ui_new_combobox(mp[1], mp[2], "\nChat Type", {"All Chat", "Realistic Radio", "Fake Radio", "Team Chat"}, 1),
    cases_chance  = ui_new_checkbox(mp[1], mp[2], "        -  Include skin details"),
    cases_indent  = ui_new_checkbox(mp[1], mp[2], "        -  Indent Unbox Message"),
    cases_rares   = ui_new_checkbox(mp[1], mp[2], "        -  Only send message when skin is rare"),
    
    --cases_luck    = ui_new_slider  (mp[1], mp[2], "Luck", 1, 1000, 1), -- sshhhhhhhhhhhhhhh, very secret ;)
    cases_case    = ui_new_listbox (mp[1], mp[2], " Select Case", case_menu_list, 1),

    cases_update  = ui_new_button  (mp[1], mp[2], " Force Update Cases (Lag Spike)", function()
        database_write(case_location, nil)
        database_write(paint_kits_location, nil)
        database_write(knife_location, nil)
        database_write(glove_location, nil)
        client_reload_active_scripts()
    end),

    cases_debug   = ui_new_checkbox(mp[1], mp[2], " Debug"),
    cases_spacer  = ui_new_label   (mp[1], mp[2], "\nCases Spacer")    
}

local function setTableVisibility(table, state) -- thx to whoever made this
    for i = 1, #table do
        ui_set_visible(table[i], state)
    end
end

client_set_event_callback("paint_ui", function()  --menu item handler
    setTableVisibility({menu.cases_sort_t, menu.cases_ascend, menu.cases_auto, menu.cases_show, menu.cases_locked, menu.cases_sell, menu.cases_audio, menu.cases_volume, menu.cases_spacer, menu.cases_case, menu.cases_hotkey, menu.cases_stats, menu.cases_speed, menu.cases_chat, menu.cases_skin_c, menu.cases_update, menu.cases_debug}, ui_get(menu.cases_enable))
    setTableVisibility({menu.cases_pos, menu.cases_i_pos}, ui_get(menu.cases_locked) and ui_get(menu.cases_enable)) 
    ui_set_visible(menu.cases_do_sort, not ui_get(menu.cases_auto) and ui_get(menu.cases_enable))
    ui_set_visible(menu.cases_volume,  ui_get(menu.cases_audio) and ui_get(menu.cases_enable))
    ui_set_visible(menu.cases_speed_v, ui_get(menu.cases_speed) and ui_get(menu.cases_enable))
    ui_set_visible(menu.cases_sell_v,  ui_get(menu.cases_sell)  and ui_get(menu.cases_enable))
    setTableVisibility({menu.cases_chat_v, menu.cases_rares}, ui_get(menu.cases_chat) and ui_get(menu.cases_enable))
    setTableVisibility({menu.cases_chance, menu.cases_indent}, (ui_get(menu.cases_chat_v) ~= "Realistic Radio") and ui_get(menu.cases_chat) and ui_get(menu.cases_enable))
end)

--main variables
local dpi_scale = ui_reference("MISC", "Settings", "DPI scale")
local s = tonumber(ui_get(dpi_scale):sub(1, -2))/100
local b_w = s * 7 -- border width
local x, y, w, h = database_read("cases_x") or 200, database_read("cases_y") or 200, database_read("cases_w") or 600 * s, database_read("cases_h") or 200
local screen_w, screen_h = client_screen_size()

local function clamp(num, min, max)
	if num < min then
		num = min
	elseif num > max then
		num = max    
	end
	return num
end

ui_set_callback(menu.cases_locked, function()
    if not ui_get(menu.cases_locked) then
        x = x + (50 * s)
        y = y + (50 * s)

        x = clamp(x, 0, screen_w - 100)
        y = clamp(y, 0, screen_h - 100)   
    end
end)

--hehe

local points    = database_read(points_location) or 5000
local inventory = database_read(inventory_location) or {}

local hide_case_opener = database_read("cases_hide_menu") or false

local min_width, min_height = 200, 100

local got_offset, got_click, is_dragging, is_resizing, off_click, do_open_case, fill_case, is_in_animation, got_hide_button, added_item = false, false, false, false, false, false, true, false, false, false
local is_rsize_t, is_rsize_rb, is_rsize_l, offset_x, offset_y, offset_w, offset_h, click_x, click_y, scaled_w, scaled_h
local bttn_rest, case_item_num, case_cost, spin_speed, points_added_alpha, dpi_off_y, current_case_name, inv_page, max_pages = 0, nil, 250, 0, 0, 0, "", 0, 1

local this_case = {}
local skin_opened = {}
local skin_hover = {}
local prev_skin_hover = {}

local rarity_int = {
    ["Exceedingly Rare"] = 5,
    ["Covert"] = 4,
    ["Classified"] = 3,
    ["Restricted"] = 2,
    ["Mil-spec grade"] = 1,
}

local spin_x_offset, holder_h, scaled_w_ref = 0, 0, 0

--main funcs

local function valid_instance()
    return (ui_is_menu_open() or ui_get(menu.cases_show))
end

local function log(text, int)
    if int == 1 then
        client_color_log(255, 69, 0,    "[Bass's Cases] " .. text)
    elseif int == 2 then
        client_color_log(0, 255, 69,    "[Bass's Cases] " .. text)
    elseif int == 3 then
        client_color_log(0, 100, 255,   "[Bass's Cases] " .. text)
    elseif int == 4 then
        client_color_log(255, 255, 255, "[Bass's Cases] " .. text)
    end
end

local function contains(item, val)
    table = ui.get(item)
    for i=1,#table do
        if table[i] == val then 
            return true
        end
    end
    return false
end

local function sort(in_table, ascend, method) -- super fucking scuffed, i just want to get this over with
    local out_table = in_table
    local n = #out_table
    for i = 2, n do 
        local key = out_table[i]
        local j = i - 1

        if method == "rarity" then
            if ascend then
                while (j > 0) and rarity_int[out_table[j][method]] > rarity_int[key[method]] do
                    out_table[j + 1] = out_table[j]
                    j = j - 1
                end
            else
                while (j > 0) and rarity_int[out_table[j][method]] < rarity_int[key[method]] do
                    out_table[j + 1] = out_table[j]
                    j = j - 1
                end
            end
        else
            -- not proud of it, but it works
            if ascend then
                while (j > 0) and (method == "percentage" and 100 - tonumber(string.sub(out_table[j][method], 1, #out_table[j][method] - 1)) or out_table[j][method]) > (method == "percentage" and 100 - tonumber(string.sub(key[method], 1, #key[method] - 1)) or key[method]) do
                    out_table[j + 1] = out_table[j]
                    j = j - 1
                end
            else
                while (j > 0) and (method == "percentage" and 100 - tonumber(string.sub(out_table[j][method], 1, #out_table[j][method] - 1)) or out_table[j][method]) < (method == "percentage" and 100 - tonumber(string.sub(key[method], 1, #key[method] - 1)) or key[method]) do
                    out_table[j + 1] = out_table[j]
                    j = j - 1
                end
            end
        end
        out_table[j + 1] = key
    end
    return out_table
end

local function date_sort(in_table, ascend)
    local out_table = in_table
    local n = #out_table
    for i = 2, n do 
        local key = out_table[i]
        local j = i - 1

        if ascend then
            while (j > 0) and out_table[j]["date"] > key["date"] do
                out_table[j + 1] = out_table[j]
                j = j - 1
            end
        else
            while (j > 0) and out_table[j]["date"] < key["date"] do
                out_table[j + 1] = out_table[j]
                j = j - 1
            end
        end
        out_table[j + 1] = key
    end
    return out_table
end

local function pulsate(time, range, speed) 
    return range * (math_sin(2 * math_pi * ((speed / 10) / (range / 10) ) * time)) / 10
end

-- randomly get numbers like 69.00000000001, this fixes | also for ez 2 decimal numbers
local function fix_float(num) 
    return math_floor(num * 100) / 100
end
-- colors :)
function fromhex(str)
    return (str:gsub('..', function (cc)
        return string.char(tonumber(cc, 16))
    end))
end

local function tabIndexOverflow(seed, table)
    for i = 1, #table do
        if seed - table[i] <= 0 then
            return i, seed
        end
        seed = seed - table[i]
    end
end

-- Credits: Kay
local function get_date()
	local unix = client.unix_time()
	assert(unix == nil or type(unix) == "number" or unix:find("/Date%((%d+)"), "Please input a valid number to \"getDate\"")
	local unix = (type(unix) == "string" and unix:match("/Date%((%d+)") / 1000 or unix) -- This is for a certain JSON compatability. It works the same even if you don't need it
	local dayCount, year, days, month = function(yr) return (yr % 4 == 0 and (yr % 100 ~= 0 or yr % 400 == 0)) and 366 or 365 end, 1970, math.ceil(unix/86400)
	while days >= dayCount(year) do 
        days = days - dayCount(year) year = year + 1 
    end
	month, days = tabIndexOverflow(days, {31,(dayCount(year) == 366 and 29 or 28),31,30,31,30,31,31,30,31,30,31})
    
	return string.format("%02d/%02d/%04d", month, days, year)
end

-- Credit: Yukine / dev
local readFile_native = vtable_bind("filesystem_stdio.dll", "VBaseFileSystem011", 0, "int(__thiscall*)(void* _this, void* buf, int size, void* hFile)")
local openFile_native = vtable_bind("filesystem_stdio.dll", "VBaseFileSystem011", 2, "void*(__thiscall*)(void* _this, const char* path, const char* mode, const char* base)")
local closeFile_native = vtable_bind("filesystem_stdio.dll", "VBaseFileSystem011", 3, "void(__thiscall*)(void* _this, void* hFile)")
local getFileSize_native = vtable_bind("filesystem_stdio.dll", "VBaseFileSystem011", 7, "unsigned int(__thiscall*)(void* _this, void* hFile)")

local function validFile(path) -- kinda scuffed, works tho
    local hFile = openFile_native(path, "r", "GAME")
    local to_return = false
    if hFile then
        local fileSize = getFileSize_native(hFile)
        if fileSize > 0 then 
            to_return = true
        end
    end
    return to_return
end

local function readFile(path)
    local hFile = openFile_native(path, "r", "GAME")
    if hFile then
        local fileSize = getFileSize_native(hFile)
        local buffer = ffi.new("char[?]", fileSize + 1)
        return {
            get = function ()
                return readFile_native(buffer, fileSize, hFile) and ffi.string(buffer, fileSize) or nil
            end,
            free = function ()
                closeFile_native(hFile)
            end
        }
    end
end

-- Credit: Sapphyrus
local function get_call_target(ptr)
	local insn = ffi.cast("uint8_t*", ptr)

	if insn[0] == 0xE8 then
		-- relative, displacement relative to next instruction
		local offset = ffi.cast("uint32_t*", insn+1)[0]

		return insn + offset + 5
	elseif insn[0] == 0xFF and insn[1] == 0x15 then
		-- absolute
		local call_addr = ffi.cast("uint32_t**", ffi.cast("const char*", ptr)+2)

		return call_addr[0][0]
	else
		error("unknown instruction!")
	end
end
-- Credit: Sapphyrus
local native_GetItemSchemaPointer = ffi.cast("intptr_t(__stdcall*)()", client.find_signature("client.dll", "\xA1\xCC\xCC\xCC\xCC\x85\xC0\x75\x53"))
local native_GetPaintKitDefinitionPointer = ffi.cast("void*(__thiscall*)(void*, int)", get_call_target(client.find_signature("client.dll", "\xE8\xCC\xCC\xCC\xCC\x8B\xF0\x8B\x4E\x7C")))
local CPaintKit_t = ffi.typeof([[
	struct {
		int nID;

		struct {
			char* buffer;
			int capacity;
			int grow_size;
			int length;
		} name;

		int pad[4];

		struct {
			char* buffer;
			int capacity;
			int grow_size;
			int length;
		} tag;
	} *
]])
-- Credit: Sapphyrus
local function get_paint_kit(index)
	local item_schema = native_GetItemSchemaPointer()
	if item_schema == nil then
		return
	end

	local paint_kit_addr = native_GetPaintKitDefinitionPointer(ffi.cast("void*", item_schema + 4), index)
	if paint_kit_addr == nil then
		return
	end

	return ffi.cast(CPaintKit_t, paint_kit_addr)
end

local debug_list = {}

--stattrak item, for csgo the image for stattrack is acutally stattrack_advert.vtf so...
local queued_case, current_case, queued_case_data = {}, {}, {}
local paint_kits = database_read(paint_kits_location)
local total_kits, last_kit = 1, 0

if paint_kits == nil or case_do_update then
    paint_kits = {}
    for i = 1, 11000 do -- index 9001 == workshop_default
        if i == 3000 then
            i = 10000
        end
        
        local paint_kit = get_paint_kit(i)
        if paint_kit ~= nil then		
            local name = ffi.string(paint_kit.name.buffer, paint_kit.name.length-1)
            local tag = ffi.string(paint_kit.tag.buffer, paint_kit.tag.length-1)
            local temp = paint_kits[localize(tag)]

            if name == "sp_nightstripe" then
                table_insert(debug_list, {name, i})
            end

            if temp == nil then
                paint_kits[localize(tag)] = {{name, i}}
            else			
                table_insert(paint_kits[localize(tag)], #temp + 1, {name, i})
            end  
        end
    end

    database_write(paint_kits_location, paint_kits)
end

local knives = {
    {"weapon_knife_css", "Classic Knife", "Classic knife", 503},
    {"weapon_bayonet", "Bayonet", "Bayonet", 500},
    {"weapon_knife_butterfly","Butterfly Knife", "Butterfly", 515},
    {"weapon_knife_canis", "Survival Knife", "Survival", 518},
    {"weapon_knife_cord", "Paracord Knife", "Paracord", 517},
    {"weapon_knife_falchion", "Falchion Knife", "Falchion", 512},
    {"weapon_knife_flip", "Flip Knife", "Flip", 505},
    {"weapon_knife_gut", "Gut Knife", "Gut", 506},
    {"weapon_knife_gypsy_jackknife", "Navaja Knife", "Navaja", 520},
    {"weapon_knife_karambit", "Karambit", "Karambit", 507},
    {"weapon_knife_m9_bayonet", "M9 Bayonet", "M9 Bayonet", 508},
    {"weapon_knife_outdoor", "Nomad Knife", "Nomad", 521},
    {"weapon_knife_push", "Shadow Daggers", "Shadow dagger", 516},
    {"weapon_knife_skeleton", "Skeleton Knife", "Skeleton", 525},
    {"weapon_knife_stiletto", "Stiletto Knife", "Stiletto", 522},
    {"weapon_knife_survival_bowie", "Bowie Knife", "Survival bowie", 514},
    {"weapon_knife_tactical", "Huntsman Knife", "Tactical", 509},
    {"weapon_knife_ursus", "Ursus Knife", "Ursus", 519},
    {"weapon_knife_widowmaker", "Talon Knife", "Talon", 523}
}

local valid_knife_skins = database_read(knife_location) or {} -- mega lag on first load, have detect method for new skins / cases ... etc

if valid_knife_skins[knives[1][1]] == nil or case_do_update then
    for i = 1, #knives do
        for j, v in pairs(paint_kits) do
            for k, n in ipairs(v) do
                local skin_name  = n[1]  
                local item_image = string.format("resource/flash/econ/default_generated/%s_%s_light_large.png", knives[i][1], skin_name)
                local valid_file = validFile(item_image)
                if valid_file then
                    local data = { 
                        name = knives[i][2] .. " | " .. j, skin = j, image = item_image , index = n[2]
                    }

                    if j == "sp_mesh_tan" then
                        table_insert(debug_list, {knives[i][1], data.index})
                    end
                    
                    local temp = valid_knife_skins[knives[i][1]]
                    if temp == nil then
                        valid_knife_skins[knives[i][1]] = {data}
                    else			    
                        table.insert(valid_knife_skins[knives[i][1]], data )
                    end  
                end
            end
        end
    end
    database_write(knife_location, valid_knife_skins)
end

--decalre glove tags
local gloves = {
    {"leather_handwraps", "Hand Wraps", "Wraps"},
    {"motorcycle_gloves", "Moto Gloves", "Motorcycle"},
    {"slick_gloves", "Driver Gloves", "Driver"},
    {"specialist_gloves", "Specialist Gloves", "Specialist"},
    {"sporty_gloves", "Sport Gloves", "Sport"},
    {"studded_bloodhound_gloves", "Bloodhound Gloves", "Bloodhound"},
    {"studded_brokenfang_gloves", "Broken Fang Gloves", "Broken Fang"},
    {"studded_hydra_gloves", "Hydra Gloves", "Hydra"}
}

local valid_glove_skins = database_read(glove_location) or {} -- mega lag on first load, have detect method for new skins / cases ... etc
if valid_glove_skins[gloves[1][1]] == nil then
    for i = 1, #gloves do
        for j, v in pairs(paint_kits) do
            local skin_name = v[1][1]
            local item_image = string.format("resource/flash/econ/default_generated/%s_%s_light_large.png", gloves[i][1], skin_name)
            local valid_file = validFile(item_image)
            if valid_file then
                local data = { 
                    name = gloves[i][2] .. " | " .. j, skin = j, image = item_image, index = v[1][2]
                }
                
                local temp = valid_glove_skins[gloves[i][1]]
                if temp == nil then
                    valid_glove_skins[gloves[i][1]] = {data}
                else			
                    table.insert(valid_glove_skins[gloves[i][1]], data )
                end  
            end
        end
    end
    database_write(glove_location, valid_glove_skins)
end

-- Partial Credit: Sapphyrus (Built off his foundation)
local function load_queued_case()
    queued_case = {}
    queued_case_data = {}
    local case_selected = case_menu_list[(ui_get(menu.cases_case) or 0)  + 1]
    local case_index = database_read(case_selected)
    local case_itemid = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(case_index, 0)
	local case_skin_count = InventoryAPI.GetLootListItemsCount(case_itemid)
    if ui_get(menu.cases_debug) then
        client_color_log(0, 155, 255, "\nItems in " .. case_selected .. " (" .. case_index .. ") | " .. case_skin_count .. " skins")
    end
    queued_case_data[6] = case_skin_count
    for i = 1, case_skin_count do
        local itemid = InventoryAPI.GetLootListItemIdByIndex(case_itemid, i-1)
        local item_image, item_name, item_rarity
        local skin_index, weapon_idx = -1, -1
        local fixed_index = case_skin_count - (i - 1)
        local skin_image_file, valid_file = nil, false
        local while_loop_is_scary = 1
        while not valid_file and while_loop_is_scary <= 15 do -- very scary while loop, needed a safety net
            if itemid == "0" then
                item_name = localize(InventoryAPI.GetLootListUnusualItemName(case_itemid))
                item_rarity = 1
                item_image = string.format("resource/flash/%s.png", InventoryAPI.GetLootListUnusualItemImage(case_itemid))
            else
                item_name = InventoryAPI.GetItemName(itemid)
                item_rarity = 8 - InventoryAPI.GetItemRarity(itemid)
                local tag_name = InventoryAPI.GetItemName(itemid):match(" | (.*)") -- game skin name
                --client_color_log(255, 255, 255, "\nIID : " .. tostring(itemid) .. "\nSTACK : " .. tostring(while_loop_is_scary) .. "\nIndex : " .. i .. " of " .. case_skin_count .. "\nCase : " .. tostring(case_selected) .. " - ".. tostring(case_itemid) .. "\nTag : " .. InventoryAPI.GetItemName(itemid) .. " - ".. tostring(tag_name))             
                local skin_name = paint_kits[tag_name][while_loop_is_scary][1] -- getting skin file name using the game skin name as a key
                skin_index = paint_kits[tag_name][while_loop_is_scary][2] -- skin indexed
                item_image = string.format("resource/flash/econ/default_generated/%s_%s_light_large.png", InventoryAPI.GetItemDefinitionName(itemid), skin_name)
                weapon_idx = InventoryAPI.GetItemDefinitionIndex(itemid)
            end

            
            valid_file = validFile(item_image)
            if ui_get(menu.cases_debug) then
                if valid_file then
                    client_color_log(33, 255, 33, "Valid " .. while_loop_is_scary .. "  : " .. item_image)
                else
                    client_color_log(255, 33, 33, "Invalid " .. while_loop_is_scary .. ": " .. item_image)
                    client_color_log(255, 33, 33, "Trying next instance - " .. while_loop_is_scary + 1)
                end
            end
            while_loop_is_scary = while_loop_is_scary + 1
        end
        skin_image_file = readFile(item_image)

        local final_image = images.load(skin_image_file.get())
        local _weapon     = string.find(item_name, "|") or 2
        local _skin_name  = string.find(item_name, "|") or #item_name

        queued_case[fixed_index] = {
            image = final_image, 
            full_name  = item_name,
            skin_name  = string.sub(item_name, _skin_name + 2, #item_name),
            weapon     = string.sub(item_name, 1, _weapon - 2) or "Knife",
            weapon_idx = weapon_idx,
            image_dir  = item_image,
            index = skin_index
        }
        queued_case_data[item_rarity] = (queued_case_data[item_rarity] or 0) + 1

        if ui_get(menu.cases_debug) then
            client_color_log(255, 255, 255, fixed_index .. " - {Image= " .. item_image .. " | Name= " .. queued_case[fixed_index].full_name ..  "}")
        end
    end
end
load_queued_case()
ui_set_callback(menu.cases_case, load_queued_case)

local function get_start_finish(cfg, rarity)
    local strt, fnsh, counter = 0, 0, 0
    if rarity ~= 6 then -- errpr
        rarity = rarity + 1

        for i = rarity - 1, 6 do -- start array pos
            strt = math_abs(strt - cfg[6 - counter])
            counter = counter + 1
        end
        
        strt, counter = strt + 1, 0

        for i = rarity, 6 do -- finsih array pos
            fnsh = math_abs(fnsh - cfg[6 - counter])
            counter = counter + 1
        end
    else
        strt, fnsh = 1, 1
    end

    return {start = strt, finish = fnsh}
end

local rarity_colors = { 
    {r = 202, g = 171, b = 005, rarity = "Exceedingly Rare"}, 
    {r = 235, g = 075, b = 075, rarity = "Covert"}, 
    {r = 211, g = 044, b = 230, rarity = "Classified"}, 
    {r = 136, g = 071, b = 255, rarity = "Restricted"}, 
    {r = 017, g = 085, b = 221, rarity = "Mil-spec grade"},
    {r = 255, g = 255, b = 255, rarity = "Error"},  
}

local function get_skin_details(cfg, rarity)
    local r_info = rarity_colors[rarity]
    local num_pos = get_start_finish(cfg, rarity)
    r_info.num = math_random(num_pos.start, num_pos.finish)
    return r_info.r, r_info.g, r_info.b, r_info.rarity, r_info.num
end

local function get_r_skin(luck, item_num, cfg)  
    local total_points = 0
    local return_skin = {}
    
    local f_roll = fix_float(100 - (math_random(1, 10000) / 100)) -- case filler items roll
    local r_roll = fix_float(100 - (math_random(1, 10000 / luck) / 100)) -- case main item roll
    local skin_rarity = 0

    if item_num ~= 35 then
        if f_roll <= 89.10 then -- blue
            skin_rarity = 5
            total_points = total_points + math_random(10, 60)
        elseif f_roll > 89.10 and f_roll <= 97.1  then -- pruple
            skin_rarity = 4
            total_points = total_points + math_random(40, 310)
        elseif f_roll > 97.10 and f_roll <= 99.74 then -- pink
            skin_rarity = 3
            total_points = total_points + math_random(550, 2900)
        elseif f_roll > 99.74 and f_roll <= 100   then  -- red
            skin_rarity = 2
            total_points = total_points + math_random(2500, 10500)
        end
    else
        if r_roll <= 75.96 then -- blue
            skin_rarity = 5
            total_points = total_points + math_random(10, 60)
        elseif r_roll > 75.96 and r_roll <= 94.90 then -- pruple
            skin_rarity = 4
            total_points = total_points + math_random(40, 310)
        elseif r_roll > 94.90 and r_roll <= 98.90 then -- pink
            skin_rarity = 3
            total_points = total_points + math_random(550, 2900)
        elseif r_roll > 98.90 and r_roll <= 99.55 then  -- red
            skin_rarity = 2
            total_points = total_points + math_random(2500, 10500)
        elseif r_roll > 99.55 and r_roll <= 100   then  -- gold
            skin_rarity = 1
            total_points = total_points + math_random(8000, 85000)
        end
    end

    return_skin.r, return_skin.g, return_skin.b, return_skin.rarity, return_skin.num = get_skin_details(cfg, skin_rarity)
    return_skin.rarity_int = 6 - skin_rarity

    local w_roll = fix_float(100 - (math_random(0, 10000) / 100))
    if w_roll >= 0 and w_roll <= 9.93 then
        return_skin.wear     = "Battle-Scarred"
        return_skin.wear_int = math_random(44, 100)
        total_points = total_points * 0.65
    elseif w_roll > 9.93 and w_roll <= 17.85  then
        return_skin.wear  = "Well-Worn"
        return_skin.wear_int = math_random(38, 45)
        total_points = total_points * 0.8
    elseif w_roll > 17.85  and w_roll <= 61.03 then
        return_skin.wear  = "Field Tested"
        return_skin.wear_int = math_random(15, 39)
        total_points = total_points * 1
    elseif w_roll > 61.03 and w_roll <= 85.71 then
        return_skin.wear  = "Minimal Wear"
        return_skin.wear_int = math_random(7, 16)
        total_points = total_points * 1.4
    elseif w_roll > 85.71 and w_roll <= 100 then
        return_skin.wear_int = math_random(0, 8)
        return_skin.wear  = "Factory New"
        total_points = total_points * 2
    end

    return_skin.stattrack = math_random(1, 10) == 1 and current_case[1].full_name ~= "★ Gloves ★"
    if return_skin.stattrack then
        total_points = total_points * 2.3
    end

    return_skin.percentage  = tostring(fix_float((100 - r_roll) / (return_skin.stattrack and 10 or 1))) .. "%"
    return_skin.points = math_floor(total_points)
    
    local s_roll = math_random(0, 1000) -- case filler items roll
    return_skin.seed = s_roll
    return return_skin
end

local knife_enable, knife_combo = ui_reference("SKINS", "Model options", "Knife changer")
local glove_enable, glove_combo, glove_combo2 = ui_reference("SKINS", "Model options", "Glove changer")

local skins_listbox = ui_reference("SKINS", "Weapon Skin", "Skin")
local idx_reference = ui_reference("SKINS", "Weapon skin", "Weapon")
ui_set_visible(idx_reference, false)

local knife_apply = nil
local function idx_apply(skin)
    local c_idx = ui_get(idx_reference)
    if skin.type == "knife" then
        ui_set(knife_enable, true)
        ui_set(knife_combo, skin.eso_name)
        knife_apply = skin
    elseif skin.type == "glove" then
        ui_set(glove_enable, true)
        ui_set(glove_combo, skin.eso_name)
        ui_set(glove_combo2, skin.skin_name)
    else
        ui_set(idx_reference, skin.weapon_idx)

        local skins_enable   = ui_reference("SKINS", "Weapon Skin", "Enabled")
        local skins_stattrak = ui_reference("SKINS", "Weapon Skin", "StatTrak")
        local skins_quality  = ui_reference("SKINS", "Weapon Skin", "Quality")
        local skins_seed     = ui_reference("SKINS", "Weapon Skin", "Seed")

        ui_set(skins_enable, true)
        ui_set(skins_listbox, skin.index)
        ui_set(skins_stattrak, skin.stattrack)
        ui_set(skins_quality, 100 - skin.wear_int)
        ui_set(skins_seed, skin.seed)
        ui_set(idx_reference, c_idx)
    end 
end

local t_knife = {}
client_set_event_callback("net_update_start", function() -- skin applying handling
    local local_player = entity.get_local_player()
    if not entity.is_alive(local_player) or knife_apply == nil then return end
    
	local weapon_ent = entity.get_player_weapon(local_player)
    local current_weapon = csgo_weapons(weapon_ent) -- current_weapon.name
    if current_weapon.type == "knife" then
        local skins_enable   = ui_reference("SKINS", "Weapon Skin", "Enabled")
        local skins_stattrak = ui_reference("SKINS", "Weapon Skin", "StatTrak")
        local skins_quality  = ui_reference("SKINS", "Weapon Skin", "Quality")
        local skins_seed     = ui_reference("SKINS", "Weapon Skin", "Seed")

        t_knife = knife_apply
        client.delay_call(0.15, function()
            ui_set(skins_enable, true)
            ui_set(skins_listbox, t_knife.index)
            ui_set(skins_stattrak, t_knife.stattrack)
            ui_set(skins_quality, 100 - t_knife.wear_int)
            ui_set(skins_seed, t_knife.seed)
        end)
        knife_apply = nil
    end
end)

local function add_item_to_inventory(case, skin)
    if skin.rarity ~= "Exceedingly Rare" then
        inventory[#inventory + 1] = {
            num = skin.num,
            name = case[skin.num].full_name,
            weapon = case[skin.num].weapon,
            weapon_idx = case[skin.num].weapon_idx,
            skin_name  = case[skin.num].skin_name,
            wear = skin.wear,
            wear_int = skin.wear_int,
            rarity = skin.rarity,
            points = skin.points,
            seed = skin.seed, 
            percentage = skin.percentage,  
            stattrack = skin.stattrack,
            image_dir = case[skin.num].image_dir,
            index = case[skin.num].index,
            r = skin.r, g = skin.g, b = skin.b,
            date = get_date(),
            type = "gun",
        }
    else
        if case[1].full_name == "★ Gloves ★" then
            local rolled_int = math_random(1, 8) 
            local rolled_glove = valid_glove_skins[gloves[rolled_int][1]]
            local glove_skin = rolled_glove[math_random(1, #rolled_glove)]

            local new_skin = {
                num = skin.num,
                name = glove_skin.name,
                weapon = gloves[rolled_int][2],
                eso_name = gloves[rolled_int][2],
                skin_name = glove_skin.skin,
                wear = skin.wear,
                rarity = skin.rarity,
                points = skin.points,
                percentage = skin.percentage,  
                stattrack = skin.stattrack,
                image_dir = glove_skin.image,
                index = glove_skin.index,
                r = skin.r, g = skin.g, b = skin.b,
                date = get_date(),
                type = "glove",
            }
            inventory[#inventory + 1] = new_skin
        else
            local rolled_int = math_random(2, 19)
            --lol
            if current_case_name == "Operation Breakout Weapon Case" then
                rolled_int = 3
            elseif current_case_name == "CS20 Case" then
                rolled_int = 1
            elseif current_case_name == "Huntsman Weapon Case" then
                rolled_int = 17
            elseif current_case_name == "Falchion Case" then
                rolled_int = 6
            elseif current_case_name == "Shadow Case" then
                rolled_int = 13
            elseif current_case_name == "Operation Wildfire Case" then
                rolled_int = 16
            end

            local rolled_knife = valid_knife_skins[knives[rolled_int][1]]
            local knife_skin = rolled_knife[math_random(1, #rolled_knife)]

            local new_skin = {
                num = skin.num,
                name = knife_skin.name,
                weapon = knives[rolled_int][2],
                weapon_idx = knives[rolled_int][4],
                eso_name = knives[rolled_int][3],
                skin_name = knife_skin.skin,
                wear = skin.wear,
                wear_int = skin.wear_int,
                rarity = skin.rarity,
                points = skin.points,
                seed = skin.seed, 
                percentage = skin.percentage,  
                stattrack = skin.stattrack,
                image_dir = knife_skin.image,
                index = knife_skin.index,
                r = skin.r, g = skin.g, b = skin.b,
                date = get_date(),
                type = "knife",
            }
            inventory[#inventory + 1] = new_skin
        end
    end
    database_write(inventory_location, inventory)
end

local function load_inventory()
    local mod_inventory = inventory -- temp copy
    for i = 1, #mod_inventory do
        local i_skin = mod_inventory[i]
        local skin_dir = i_skin.image_dir
        if validFile(skin_dir) then
            local skin_image_file = readFile(skin_dir)
            mod_inventory[i].image = images.load(skin_image_file.get())
        end
    end
    inventory = mod_inventory
end
load_inventory()

-- sort
local function sort_inventory()
    local type, method = ui_get(menu.cases_sort_t), "rarity_int"
    if type == "Price" then
        method = "points"
    elseif type == "Rarity" then
        method = "rarity"
    elseif type == "Chance" then
        method = "percentage"
    end   
    local mod_inventory = sort(inventory, not ui_get(menu.cases_ascend), method)
    inventory = mod_inventory
end

local function calc_points(difference)
    points = points + difference
    database_write(points_location, points)
end

local function do_stats(skin_rarity)
    if skin_rarity == "Mil-spec grade" then
        local old_total = database_read("cases_blues") or 0
        database_write("cases_blues", old_total + 1)
    elseif skin_rarity == "Restricted" then
        local old_total = database_read("cases_purps") or 0
        database_write("cases_purps", old_total + 1)
    elseif skin_rarity == "Classified" then
        local old_total = database_read("cases_pinks") or 0
        database_write("cases_pinks", old_total + 1)
    elseif skin_rarity == "Covert" then
        local old_total = database_read("cases_reds") or 0
        database_write("cases_reds", old_total + 1)
    elseif skin_rarity == "Exceedingly Rare" then
        local old_total = database_read("cases_golds") or 0
        database_write("cases_golds", old_total + 1)
    end

    local old_total = database_read("cases_opened") or 0
    database_write("cases_opened", old_total + 1) 
end

local function reset_all() -- for whenever neccesary
    database_write("cases_opened", nil)
    database_write("cases_blues", nil)
    database_write("cases_purps", nil)
    database_write("cases_pinks", nil)
    database_write("cases_reds", nil)
    database_write("cases_golds", nil)
    database_write(points_location, 250000)
    database_write(inventory_location, nil)
    database_write(case_location, nil)
    points = database_read(points_location)--need to update
end
-- reset_all()

client_set_event_callback('setup_command', function (cmd) 
    -- when menu is open dont have the mouse doin shit behind it
    -- sadly doesnt work in csgo's main menu
    if not ui_is_menu_open() or not ui_get(menu.cases_enable) then
        return
    end

    cmd.in_attack = false
    cmd.in_attack2 = false 
end)

local spin_lock = false
local function activate_spin()
    if not spin_lock then
        calc_points(-case_cost)

        current_case = queued_case
        current_case_name = case_menu_list[(ui_get(menu.cases_case) or 0) + 1]

        bttn_rest = true
        fill_case = true
        do_open_case = true    
        fill_case = true
        is_in_animation = false
        spin_speed = 1
        spin_x_offset = 0

        added_item = false
    end
end

local function skeet_box(s_x, s_y, s_w, s_h, s_alpha, do_gradient)
    renderer_rectangle(s_x - 6, s_y - 6, s_w + 12, s_h + 12, 12, 12, 12, s_alpha)
    renderer_rectangle(s_x - 5, s_y - 5, s_w + 10, s_h + 10, 60, 60, 60, s_alpha)
    renderer_rectangle(s_x - 4, s_y - 4, s_w + 8, s_h + 8, 40, 40, 40, s_alpha)
    renderer_rectangle(s_x - 1, s_y - 1, s_w + 2, s_h + 2, 60, 60, 60, s_alpha)
    renderer_rectangle(s_x, s_y, s_w, s_h, 23, 23, 23, s_alpha)
    if do_gradient then
        renderer_gradient(s_x + 1, s_y + 1, s_w / 2 - 1, s, 55, 177, 218, s_alpha, 201, 84, 205, s_alpha, true)
        renderer_gradient(s_x + s_w / 2 - 1, s_y + 1, s_w / 2, s, 201, 84, 205, s_alpha, 204, 207, 53, s_alpha, true)
    end
end

local function rectangle_outline(x, y, w, h, r, g, b, a)
	renderer_line(x, y, x + w, y, r, g, b, a) -- top
    renderer_line(x, y + h + 1, x + w, y + h + 1, r, g, b, a) -- bottom
    renderer_line(x, y, x, y + h, r, g, b, a) -- left
    renderer_line(x + w, y, x + w, y + h, r, g, b, a) -- right
end

local old_menu_x, old_menu_y = 0, 0
local menu_moved = false
local page_clicked = false
local function add_arrow_button(a_x, a_y, a_w, a_h, arrow, button_num)-- ▲ ▼ ▶ ◀ -- simple modified button function
    local mouse_x, mouse_y = ui_mouse_position()
    renderer_rectangle(a_x,     a_y,     a_w,     a_h,    15, 15, 15, 255)
    renderer_rectangle(a_x + 1, a_y + 1, a_w - 2, a_h - 2, 45, 45, 45, 255)  
    if mouse_x >= a_x and mouse_x <= a_x + a_w and mouse_y >= a_y and mouse_y <= a_y + a_h then
        renderer_gradient(a_x + 2, a_y + 2, a_w - 4, a_h - 4, 45, 45, 45, 255, 35, 35, 35, 255, false)
    else
        renderer_gradient(a_x + 2, a_y + 2, a_w - 4, a_h - 4, 40, 40, 40, 255, 30, 30, 30, 255, false)
    end
    renderer_text(a_x + 2 + (7.5 * s), a_y + (s == 1 and (s * 7) or (s * 5)), 255, 255, 255, 155, "bcd", 0, arrow) 

    if button_num == 3 or button_num == 4 then
        if ui_is_menu_open() and not menu_moved then
            if client_key_state(0x01) then -- click
                if click_x >= a_x and click_x <= a_x + a_w and click_y >= a_y and click_y <= a_y + a_h then
                    if not page_clicked then
                        page_clicked = true
                        if button_num == 3 and inv_page > 0 then
                            inv_page = inv_page - 1
                        elseif button_num == 4 and inv_page < max_pages then
                            inv_page = inv_page + 1
                        end
                        
                    end
                end
            else
                page_clicked = false
            end
        end
    end
end
local inventory_h_offset = 0
local function mouse_listener() -- self explanitory
    local menu_pos_x, menu_pos_y = ui_menu_position()          
    local menu_pos_w, menu_pos_h = ui_menu_size()
    local mouse_x, mouse_y = ui_mouse_position()

    if old_menu_x ~= menu_pos_x or old_menu_y ~= menu_pos_y then
        menu_moved = true
        old_menu_x = menu_pos_x
        old_menu_y = menu_pos_y
    else
        menu_moved = false
    end

    if ui_get(menu.cases_locked) then
        local side = ui_get(menu.cases_pos)     
        if side == "Top" then
            x = menu_pos_x + 6
            y = menu_pos_y - h
            w = menu_pos_w - 12
        elseif side == "Bottom" then
            x = menu_pos_x  + 6
            y = menu_pos_y + menu_pos_h
            w = menu_pos_w - 12
        end
    end

    if client_key_state(0x01) and ui_is_menu_open() and not menu_moved then -- click
        off_click = true
        if not got_click then
            click_x, click_y = ui_mouse_position()
            got_click = true
        end
        -- hide menu hit
        if (click_x >= x + w - 12 - (15 * s) and click_x <= x + w - 12 - (15 * s) + (15 * s) and click_y >= y + (10 * s) - s + 1 and click_y <= y + (10 * s) - s + 1 + (15 * s)) and not is_dragging and not is_resizing then 
            if not got_hide_button then
                hide_case_opener = not hide_case_opener
                database_write("cases_hide_menu", hide_case_opener)
                got_hide_button = true 
            end

            click_x = 0
            click_y = 0
        --hit main button
        --x + b_w, y + h - (b_w/2) - dpi_off_y, w - b_w * 2, dpi_off_y - 4   
        elseif (click_x >= x + b_w and click_x <= (x + b_w - 2) + (w - b_w * 2) and click_y >= y + h - (b_w/2) - dpi_off_y and click_y <= (y + h - (b_w/2) - dpi_off_y) + dpi_off_y - 4) and not bttn_rest and not is_in_animation and not is_dragging and not is_resizing and not hide_case_opener then    
            if points >= case_cost then
                if ui_get(menu.cases_audio) then
                    client_exec("playvol ui/csgo_ui_crate_open " .. ui_get(menu.cases_volume) / 100)
                end

                activate_spin()        
                spin_lock = true               
            else
                bttn_rest = true
                client_exec("playvol ui/panorama/lobby_error_01.wav " .. ui_get(menu.cases_volume) / 100)
            end
        elseif (click_x >= x + b_w and click_x <= (x + b_w - 2) + (w - b_w * 2) and click_y >= y + h - (b_w/2) - dpi_off_y and click_y <= (y + h - (b_w/2) - dpi_off_y) + dpi_off_y - 4) and not is_dragging and not is_resizing and not hide_case_opener then 
        -- holding main button
            renderer_gradient(x + b_w, y + h - (b_w/2) - dpi_off_y, w - b_w * 2, dpi_off_y - 4, 30, 30, 30, 255, 20, 20, 20, 255, false)
        elseif (click_x <= x + w and click_x >= x  and click_y <= y + h + inventory_h_offset and click_y >= y or is_dragging) and not is_resizing and not ui_get(menu.cases_locked) then --drag
            is_dragging = true

            if not got_offset then
                offset_x, offset_y = mouse_x - x, mouse_y - y
                got_offset = true
            end

            x = clamp(mouse_x - offset_x, 5, screen_w - w - 5)
            y = clamp(mouse_y - offset_y, 5, screen_h - h - 5)   
        elseif (click_x <= x + w + 6 and click_x >= x + w - 6 and click_y <= y + h + 6 + inventory_h_offset and click_y >= y - 6 or is_resizing) and not is_dragging and not ui_get(menu.cases_locked) then --resize
            is_resizing = true

            if not got_offset then
                offset_w = w
                got_offset = true
            end

            w = clamp(math_abs(mouse_x - x), 400 * s, screen_w)
        end
    else
        if off_click then
            is_rsize_t = false
            is_rsize_rb = false
            is_rsize_l = false

            bttn_rest = false

            off_click = false

            is_dragging = false
            is_resizing = false

            got_offset = false
            got_click = false

            got_hide_button = false

            database_write("cases_x", x)
            database_write("cases_y", y)
            database_write("cases_w", w)
            database_write("cases_h", h)
        end
    end
end
client_set_event_callback("paint_ui", function() -- main
    -- menu item handler
    if ui_get(menu.cases_enable) then
        if valid_instance() then
            s = tonumber(ui_get(dpi_scale):sub(1, -2))/100
            b_w = s * 6
            
            local menu_pos_x, menu_pos_y = ui_menu_position()          
            local menu_pos_w, menu_pos_h = ui_menu_size()
            local mouse_x, mouse_y = ui_mouse_position()            
            local hover = false

            skeet_box(x, y, w, h, 255, true)

            if hide_case_opener then
                h = 26 * s
                add_arrow_button(x + w - 14 - (15 * s), y + (5 * s), (15 * s) + 4, (15 * s) + 4, (ui_get(menu.cases_pos) == "Top" and "▲" or "▼"), 1)
                mouse_listener()
            else
                -------------------------------
                -- MAIN CASE OPENEING WINDOW --
                -------------------------------
                local is_locked = ui_get(menu.cases_locked)
                h = 120 * s
                image_width, image_height = 512, 384 -- static, fuck u
                local icon_scale = math_min(holder_h / image_height, (w - 20) / image_width)
                scaled_w, scaled_h = image_width * icon_scale, image_height * icon_scale
                local y_offset = ((holder_h / 2) - (scaled_h / 2))     
                scaled_w_ref = scaled_w

                --button
                dpi_off_y = 50 * (s / 2)
                renderer_rectangle(x + b_w - 2, y + h - (b_w/2) - 2 - dpi_off_y, w - (b_w - 2) * 2, dpi_off_y, 15, 15, 15, 255)
                renderer_rectangle(x + b_w - 1, y + h - (b_w/2) - 1 - dpi_off_y, w - (b_w - 1) * 2, dpi_off_y - 2, 45, 45, 45, 255)
                renderer_gradient(x + b_w, y + h - (b_w/2) - dpi_off_y, w - b_w * 2, dpi_off_y - 4, 40, 40, 40, 255, 30, 30, 30, 255, false)

                --case holder
                holder_h = h - dpi_off_y + (-dpi_off_y) -- what
                renderer_rectangle(x + 12 + scaled_w, y + (10 * s), w - 24 - (scaled_w * 2), holder_h - 2, 45, 45, 45, 255) -- holder background
                
                --hover
                if mouse_x >= x + b_w and mouse_x <= (x + b_w - 2) + (w - b_w * 2) and mouse_y >= y + h - (b_w/2) - dpi_off_y and mouse_y <= (y + h - (b_w/2) - dpi_off_y) + dpi_off_y - 4 then -- main button
                    renderer_gradient(x + b_w, y + h - (b_w/2) - dpi_off_y, w - b_w * 2, dpi_off_y - 4, 45, 45, 45, 255, 35, 35, 35, 255, false)
                end

                --items
                if not fill_case then 
                    for i = 1, #this_case do
                        local c_icon = current_case[this_case[i].num].image

                        this_case[i].w = scaled_w
                        this_case[i].h = scaled_h

                        --holy fuck me, what an equation lol
                        local modified_x = x + 15 + ((w - 15) / 2) - (scaled_w / 2) - spin_x_offset + ((i + 5) * (scaled_w + (s * 4)))
                        local modified_y = y + (10 * s) + y_offset

                        this_case[i].x = modified_x
                        this_case[i].y = modified_y

                        -- if should be on the screen
                        if modified_x > x + 6 and modified_x + scaled_w < x + w - 12 then
                            renderer_gradient(modified_x, modified_y, scaled_w, scaled_h , 40, 40, 40, 255, 10, 10, 10, 255, false)
                            renderer_gradient(modified_x, modified_y + (scaled_h / 2 - (s * 2)), scaled_w, scaled_h / 2, 30, 30, 30, 0, this_case[i].r, this_case[i].g, this_case[i].b, 111, false)
                            c_icon:draw(modified_x, modified_y, scaled_w, scaled_h, 255, 255, 255, 255)
                            renderer_rectangle(modified_x, modified_y + (scaled_h - (s * 2)) - 2, scaled_w, s * 2, this_case[i].r, this_case[i].g, this_case[i].b, 185)
                            renderer_gradient(modified_x, modified_y + (scaled_h / 2 - (s * 2)), scaled_w, scaled_h / 2, 30, 30, 30, 0, this_case[i].r, this_case[i].g, this_case[i].b, 122, false)
                            --rectangle_outline(modified_x, modified_y, scaled_w, scaled_h - 1, 0, 0, 0, 255) 

                            local middle_of_image = modified_x + (scaled_w / 2)
                            if middle_of_image > (x + w / 2) - (scaled_w / 2) + (3 * s) and middle_of_image < (x + w / 2) + (scaled_w / 2) - (3 * s) then
                                if ui_get(menu.cases_audio) then
                                    if prev_skin_hover ~= this_case[i] then
                                        prev_skin_hover = this_case[i] 
                                        client_exec("playvol ui/csgo_ui_crate_item_scroll " .. ui_get(menu.cases_volume) / 100)
                                    end
                                end  

                                case_item_num = i
                                skin_hover = this_case[i]            
                            end
                            if ui_get(menu.cases_debug) then
                                renderer_text(modified_x + (scaled_w / 2), modified_y + 5, 255, 255, 255, 155,"bcd", 0, i)
                            end
                        end
                    end
                end

                --covers of overlap
                renderer_rectangle(x, y + (10 * s) - 3, scaled_w + 11, holder_h + 6, 23, 23, 23, 255)
                renderer_rectangle(x + w - scaled_w - 11, y + (10 * s) - 3, scaled_w + 10, holder_h + 6, 23, 23, 23, 255)

                --holder outline
                rectangle_outline(x + 10 + scaled_w, y + (10 * s) - 1, w - 20 - (scaled_w * 2), holder_h + 3, 30, 30, 30, 15)   
                rectangle_outline(x + 11 + scaled_w, y + (10 * s), w - 22 - (scaled_w * 2), holder_h - 1, 45, 45, 45, 255)      
                rectangle_outline(x + 12 + scaled_w, y + (10 * s) + 1, w - 24 - (scaled_w * 2), holder_h - 3, 15, 15, 15, 255)  

                --middle line
                renderer_rectangle(x + w / 2 + 1, y + (10 * s) + 6, s, holder_h - 14, 255, 255, 255, 155)

                -- mouse listenter activation
                mouse_listener()

                -- hotkey activation 
                if ui_get(menu.cases_hotkey) and not is_in_animation then
                    if points >= case_cost then
                        activate_spin()
                        spin_lock = true
                    end
                end

                --hide menu icon
                add_arrow_button(x + w - 14 - (15 * s), y + (10 * s) - s - 1, (15 * s) + 4, (15 * s) + 4, (ui_get(menu.cases_pos) == "Top" and "▼" or "▲"), 2)

                --button text
                renderer_text(x + (w / 2), y + h - (b_w/2) - 2 - dpi_off_y + (dpi_off_y / 2), 205, 205, 205, 255,"cd", 0, "Open Case - " .. case_cost .. " " .. currency)

                -- points label
                renderer_text(x + b_w, y + (10 * s) - s, 205, 205, 205, 255,"d", 0, points .. " " .. currency)

                if ui_get(menu.cases_stats) then
                    local d = s * 10 -- spacing offset
                    local t = s      -- top offset
                    local t_x_o = 45 -- dpi scaling nonsense
                    renderer_text(x + b_w, y - s + t + (2 * d), 155, 155, 155, 255,"d", 0, "Case: ")
                    renderer_text(x + b_w + (s * t_x_o), y - s + t + (2 * d), 220, 220, 220, 255,"d", 0, (database_read("cases_opened") or 0) )

                    renderer_text(x + b_w, y - s + t + (3 * d), 155, 155, 155, 255,"d", 0, "Blues:")
                    renderer_text(x + b_w + (s * t_x_o), y - s + t + (3 * d), 017, 085, 221, 255,"d", 0, (database_read("cases_blues") or 0) )

                    renderer_text(x + b_w, y - s + t + (4 * d), 155, 155, 155, 255,"d", 0, "Purples:")
                    renderer_text(x + b_w + (s * t_x_o), y - s + t + (4 * d), 136, 071, 255, 255,"d", 0, (database_read("cases_purps") or 0) )

                    renderer_text(x + b_w, y - s + t + (5 * d), 155, 155, 155, 255,"d", 0, "Pinks:")
                    renderer_text(x + b_w + (s * t_x_o), y - s + t + (5 * d), 211, 044, 230, 255,"d", 0, (database_read("cases_pinks") or 0) )

                    renderer_text(x + b_w, y - s + t + (6 * d), 155, 155, 155, 255,"d", 0, "Reds:")
                    renderer_text(x + b_w + (s * t_x_o), y - s + t + (6 * d), 235, 075, 075, 255,"d", 0, (database_read("cases_reds") or 0) )

                    renderer_text(x + b_w, y - s + t + (7 * d), 155, 155, 155, 255,"d", 0, "Golds:")
                    renderer_text(x + b_w + (s * t_x_o), y - s + t + (7 * d), 202, 171, 005, 255,"d", 0, (database_read("cases_golds") or 0) )      
                end 
            end
        end
    end
end)

local time_diff_old_1 = 0
local item_inv_alpha, inv_hover_past, sold_item = 0, nil, nil

local r_off_click, item_clicked, r_clicked, l_clicked = false, false, false
local rick = {-- rick_y / rick_i = "Ricky"  lol -- right click pos
    skin = nil,
    x = nil,
    y = nil, 
    i = nil, 
    t = 0
}

local o_x, o_y, o_w, o_h = 0, 0, 0, 0

client_set_event_callback("paint_ui", function() -- inventory handling
    if ui_get(menu.cases_enable) then
        if valid_instance() and not hide_case_opener then
            local mouse_x, mouse_y = ui_mouse_position()
            local menu_pos_x, menu_pos_y = ui_menu_position()          
            local menu_pos_w, menu_pos_h = ui_menu_size()
            ------------------------------
            --     INVENTORY WINDOW     --
            ------------------------------
            if scaled_h ~= nil and scaled_w ~= nil then
                local input_rows = ui_get(menu.cases_skin_c)
                if input_rows ~= 0 then
                    local is_locked = ui_get(menu.cases_locked)
                    local w_i, h_i = (is_locked and ((scaled_w + (b_w * 1.5)) * input_rows) or w), (is_locked and menu_pos_h - 12 or (25 * s) + ((scaled_h + b_w) * input_rows))
                    local x_i, y_i = (is_locked and (ui_get(menu.cases_i_pos) == "Right" and menu_pos_x + menu_pos_w or menu_pos_x - w_i) or x), (is_locked and menu_pos_y + 6 or y + h + 6)

                    inventory_h_offset = h_i

                    if is_locked then
                        skeet_box(x_i, y_i, w_i, h_i, 255, true)
                    else
                        skeet_box(x_i, y_i, w_i, h_i, 255, false)
                    end

                    if valid_instance() and not menu_moved then
                        local valid_skin = true

                        if client_key_state(0x02) then -- right click
                            r_off_click = true
                            if not r_clicked then
                                r_clicked = true
                                rick.x, rick.y, rick.skin, rick.i = mouse_x, mouse_y, nil, nil
                            end
                        elseif client_key_state(0x01) then
                            if not l_clicked then
                                l_clicked = true
                                if click_x > o_x and click_x < o_x + o_w and click_y > o_y and click_y < o_y + (valid_skin and (o_h / 2) or o_h) then
                                    sold_item = rick.skin
                                    table_remove(inventory, rick.i)
                                    calc_points(sold_item.points)
                                    load_inventory()
                                    rick.t = globals_curtime()
                                    points_added_alpha = 1
                                elseif click_x > o_x and click_x < o_x + o_w and click_y > o_y + (o_h / 2) and click_y < o_y + o_h and valid_skin then
                                    idx_apply(rick.skin)
                                end
                                rick.x, rick.y, rick.skin, rick.i = nil, nil, nil, nil
                            end
                        else
                            if r_off_click then
                                r_off_click = false
                                r_clicked = false
                                l_clicked = false
                            end
                        end
                    end

                    -- manual sort check
                    if manual_sort then
                        manual_sort = false
                        sort_inventory()
                    end

                    local j = 0
                    local skins_per_row = math_floor(w_i / (scaled_w + b_w))
                    local max_rows = math_floor((h_i - (is_locked and 25 * s or 0)) / (scaled_h + b_w)) 
                    local s_w = math_max(b_w, (w_i - (skins_per_row * scaled_w + b_w)) / skins_per_row) -- item spacer width
                    local max_length = (scaled_w * (skins_per_row) + ((s_w * skins_per_row) + s_w))

                    local skins_per_page = skins_per_row * max_rows
                    local page_correction = (skins_per_page* inv_page) + 1
                    max_pages = math_floor(#inventory / skins_per_page)

                    if inv_page > max_pages then
                        inv_page = max_pages
                    end

                    local inv_hover, inv_hover_pos = {}, {}
                    for i = page_correction, #inventory do
                        local inverse_i = (#inventory + 1) - i
                        if j < max_rows then
                            local do_skin = inventory[inverse_i]
                            local c_icon = do_skin.image   
                            
                            -- im often impressed by my brain power
                            local row_length = (j * max_length)
                            local x_off, i_off = (s_w * (i - page_correction + 1)) + (j * s_w), scaled_w * ((i - page_correction + 1) - 1) - row_length + ((w_i - max_length) / 2)
                            local y_off, j_off = b_w * (j + 1), scaled_h * j
                            local modified_x, modified_y = x_i + x_off + i_off, y_i + y_off + j_off

                            renderer_gradient(modified_x, modified_y, scaled_w, scaled_h, 40, 40, 40, 255, 10, 10, 10, 255, false)
                            renderer_gradient(modified_x, modified_y + (scaled_h / 2), scaled_w, scaled_h / 2, 30, 30, 30, 0, do_skin.r, do_skin.g, do_skin.b, 75, false)           
                            c_icon:draw(modified_x, modified_y, scaled_w, scaled_h, 255, 255, 255, 255)
                            renderer_rectangle(modified_x, modified_y, s * 2, scaled_h, do_skin.r, do_skin.g, do_skin.b, 185)
                            renderer_gradient(modified_x, modified_y + (scaled_h / 2), scaled_w, scaled_h / 2, 30, 30, 30, 0, do_skin.r, do_skin.g, do_skin.b, 125, false) 
                            --rectangle_outline(modified_x, modified_y, scaled_w, scaled_h, 255, 255, 255, 255)

                            if mouse_x > modified_x and mouse_x < modified_x + scaled_w and mouse_y > modified_y and mouse_y < modified_y + scaled_h then
                                inv_hover, inv_hover_pos = do_skin, {x = modified_x, y = modified_y, w = scaled_w, h = scaled_h} 
                            end
                            if rick.x ~= nil and rick.y ~= nil then
                                if rick.x > modified_x and rick.x < modified_x + scaled_w and rick.y > modified_y and rick.y < modified_y + scaled_h then
                                    rick.skin = do_skin
                                    rick.i = inverse_i
                                end
                            end
                        end

                        if i % skins_per_row == 0 then
                            j = j + 1
                        end
                    end 
                    if inv_hover ~= inv_hover_past then
                        inv_hover_past = inv_hover
                        item_inv_alpha = 0
                    end

                    if inv_hover ~= {} and inv_hover_pos.x ~= nil and inv_hover_pos.y ~= nil then
                        item_inv_alpha = clamp(item_inv_alpha + 30, 0, 255)

                        local d_w, d_h = inv_hover_pos.w * 1.65, (s * 3) + (66 * s) + (inv_hover.stattrack and (12 * s) or 0)
                        local d_x, d_y = (ui_get(menu.cases_i_pos) == "Right" and inv_hover_pos.x + inv_hover_pos.w + (s * 6) or inv_hover_pos.x - d_w - (s * 6)), inv_hover_pos.y + 5

                        skeet_box(d_x, d_y, d_w, d_h, item_inv_alpha, false)

                        renderer_text(d_x + (s * 5), d_y + (s * 3), 220, 220, 220, item_inv_alpha, "d", 0, inv_hover.name)

                        renderer_text(d_x + (s * 5),            d_y + (s * 3) + (12 * s), 155, 155, 155, item_inv_alpha, "d", 0, "Rarity: ")
                        renderer_text(d_x + (s * 5) + (s * 50), d_y + (s * 3) + (12 * s), inv_hover.r, inv_hover.g, inv_hover.b, item_inv_alpha, "d", 0, inv_hover.rarity)

                        renderer_text(d_x + (s * 5),            d_y + (s * 3) + (22 * s), 155, 155, 155, item_inv_alpha, "d", 0, "Exterior: ")
                        renderer_text(d_x + (s * 5) + (s * 50), d_y + (s * 3) + (22 * s), 220, 220, 220, item_inv_alpha, "d", 0, inv_hover.wear)

                        renderer_text(d_x + (s * 5),            d_y + (s * 3) + (32 * s), 155, 155, 155, item_inv_alpha, "d", 0, "Points: ")
                        renderer_text(d_x + (s * 5) + (s * 50), d_y + (s * 3) + (32 * s), 220, 220, 220, item_inv_alpha, "d", 0, inv_hover.points .. " " .. currency)

                        renderer_text(d_x + (s * 5),            d_y + (s * 3) + (42 * s), 155, 155, 155, item_inv_alpha, "d", 0, "Chance: ")
                        renderer_text(d_x + (s * 5) + (s * 50), d_y + (s * 3) + (42 * s), 220, 220, 220, item_inv_alpha, "d", 0, inv_hover.percentage)

                        renderer_text(d_x + (s * 5),            d_y + (s * 3) + (53 * s), 135, 135, 135, item_inv_alpha / 2, "d", 0, "Opened on " .. inv_hover.date)

                        renderer_text(d_x + (s * 5),            d_y + (s * 3) + (63 * s), 220, 220, 220, item_inv_alpha, "d", 0, (inv_hover.stattrack and "StatTrak™ " or ""))
                    else
                        item_inv_alpha = clamp(item_inv_alpha - 30, 0, 255)
                    end 

                    if rick.skin ~= nil then
                        o_x, o_y, o_w, o_h = rick.x + (s * 8), rick.y + (s * 1), (s * 50), s * 30
                        skeet_box(o_x - (s * 3), o_y, o_w + (s * 6), o_h, 255, false)
                        renderer_text(o_x, o_y + s * 2,  rick.skin.r, rick.skin.g, rick.skin.b, 255, "d", 0, "Sell Item") 
                        renderer_text(o_x, o_y + s * 17, 220, 220, 220, 255, "d", 0, "Apply Skin")
                    end

                    local pages_y = y_i + h_i - b_w - ((15 * s) + 4)
                    add_arrow_button(x_i + b_w , pages_y, (15 * s) + 4, (15 * s) + 4, "◀", 3)
                    add_arrow_button(x_i + w_i - b_w - ((15 * s) + 4), pages_y, (15 * s) + 4, (15 * s) + 4, "▶", 4)
                    renderer_text(x_i + (w_i / 2), pages_y + (s * 10), 220, 220, 220, 255, "cd", 0, "Page " .. inv_page + 1 .. "/" .. max_pages + 1)
                end
            end
        end
    end
end)

local start_time, end_time = 0, 0
local box_alpha = 0
local time_diff_old_2 = 0
local item_det_alpha, points_added_alpha_flip = 0, false

client_set_event_callback("paint_ui", function() -- seperate callback because literally cant combine them
    if not ui_get(menu.cases_enable) or hide_case_opener then
        return
    end

    if valid_instance() then
        local time_diff = math_floor(globals_curtime() * 100) / 100 -- to normalize times so speed is not affected by FPS
        if time_diff ~= time_diff_old_1 then
            time_diff_old_1 = time_diff

            local speed_multiplier = (ui_get(menu.cases_speed) and (ui_get(menu.cases_speed_v)) or 1)
            for i = 1, speed_multiplier do
                if do_open_case then
                    if fill_case then
                        for j = 1, 60 do
                            local luck = 1
                            if menu.cases_luck ~= nil then
                                luck = ui_get(menu.cases_luck)
                            end
                            this_case[j] = get_r_skin(luck, j, queued_case_data)   
                        end
                        fill_case = false
                        is_in_animation = true
                        start_time = globals_curtime()
                        spin_x_offset = -math_floor(math_random(-scaled_w_ref / 2.7, scaled_w_ref / 2.7))
                        if ui_get(menu.cases_debug) then
                            log("Filled New Case", 2)
                            log("Spin Offset : " .. spin_x_offset, 3)
                        end
                    end
                    
                    -- elseif block to make the csgo spin time has slightly different modes
                    -- closest way i could get to the actual csgo spin time / animation
                    if spin_speed > 0.47 then
                        spin_speed = math_max(spin_speed - ((spin_speed * spin_speed) / (120)), 0)
                    elseif spin_speed > 0.3 then
                        spin_speed = math_max(spin_speed - ((spin_speed * spin_speed) / (60)), 0)
                    elseif spin_speed > 0.2 then
                        spin_speed = math_max(spin_speed - ((spin_speed * spin_speed) / (35)), 0)
                    elseif spin_speed > 0.1 then
                        spin_speed = math_max(spin_speed - ((spin_speed * spin_speed) / (24)), 0)
                    else
                        spin_speed = math_max(spin_speed - (0.03 / 52), 0)
                    end

                    spin_x_offset = (spin_x_offset + ( spin_speed * (25 * s)))

                    if spin_speed <= 0 then
                        box_alpha = 0
                        is_in_animation = false
                        spin_lock = false
                    end

                    if not is_in_animation then
                        end_time = globals_curtime()
                        skin_opened = this_case[case_item_num]
                        
                        do_stats(skin_opened.rarity)

                        if not added_item then
                            if ui_get(menu.cases_sell) and contains(menu.cases_sell_v, skin_opened.rarity) then
                                sold_item = skin_opened
                                calc_points(skin_opened.points)
                                rick.t = globals_curtime()
                                points_added_alpha = 1
                            else
                                add_item_to_inventory(current_case, skin_opened)

                                -- chat unbox handler
                                if ui_get(menu.cases_chat) then
                                    local local_player = entity_get_local_player()
                                    if local_player ~= nil then  
                                        local unbox_type = ui_get(menu.cases_chat_v)
                                        local white = fromhex("01")
                                        local yellow = fromhex("09")
                                        local item_name
                                        local pre_item_name = (ui_get(menu.cases_chance) and skin_opened.wear .. ", " or "") .. tostring(skin_hover.rarity == "Exceedingly Rare" and "★ " or "") .. (skin_hover.stattrack and "StatTrak™ " or "")    
                                        if string.find(current_case[skin_opened.num].full_name, "★") then
                                            item_name = inventory[#inventory].name
                                        else
                                            item_name = current_case[skin_opened.num].full_name
                                        end
                                        print("NAME : " .. skin_opened.num)
                                        if ui_get(menu.cases_chance) and unbox_type ~= "Realistic Radio" then
                                            item_name = item_name .. white .. " (".. skin_opened.percentage .. ")"
                                        end

                                        local rarity = skin_opened.rarity      
                                        local name_end = (unbox_type ~= "Realistic Radio" and pre_item_name or "")                              
                                        if rarity == "Mil-spec grade" or rarity == "Restricted" then -- no purple color :( , so just use blue
                                            pre_item_name = fromhex("0C") .. name_end
                                        elseif rarity == 'Classified' then
                                            pre_item_name = fromhex("0E") .. name_end
                                        elseif rarity == "Exceedingly Rare" or rarity == "Covert" then
                                            pre_item_name = fromhex("0F") .. name_end
                                        end
                            
                                        local should_send = true
                                        if ui_get(menu.cases_rares) then
                                            if rarity == "Mil-spec grade" or rarity == "Restricted" then
                                                should_send = false
                                            end
                                        end

                                        if should_send then             
                                            local team_color = (unbox_type ~= "Realistic Radio" and fromhex("04") or fromhex("03"))
                                            if unbox_type ~= "Realistic Radio" then
                                                local message = "opened a " .. yellow .. current_case_name .. white .. " and found a: " .. (ui_get(menu.cases_indent) and " " or "")  .. pre_item_name .. item_name
                                                if unbox_type == "Fake Radio" then
                                                    client_exec("playerchatwheel . \"", " " .. team_color .. entity_get_player_name(local_player) .. white .. " " .. message .. "\"")
                                                elseif unbox_type == "All Chat" then
                                                    client_exec("say " .. message)
                                                else
                                                    client_exec("say_team " .. message)
                                                end
                                            else
                                                local message = "has opened a container and found: " .. pre_item_name  .. item_name
                                                client_exec("playerchatwheel . \"", "Cheer! " .. team_color .. entity_get_player_name(local_player) .. white .. " " .. message .. "\"")
                                            end
                                        end
                                    end
                                end

                                if ui_get(menu.cases_auto) then
                                    sort_inventory()
                                end
                                load_inventory()
                            end
                            added_item = true
                        end
                        
                        do_open_case = false

                        rick.skin = nil
                        rick.x = nil 
                        rick.y = nil

                        if ui_get(menu.cases_debug) then
                            log("Case Time : " .. end_time - start_time, 3)
                        end
                        if ui_get(menu.cases_audio) then
                            client_exec("playvol ui/csgo_ui_crate_display " .. ui_get(menu.cases_volume) / 100)
                        end
                    end
                end
            end
        end
    end
end)

client_set_event_callback("paint_ui", function() -- function at line xxx has more than 60 upvalues
    if not ui_get(menu.cases_enable) or hide_case_opener then
        return
    end

    if valid_instance() then
        local skin_valid = (skin_opened ~= nil and skin_opened.x ~= nil and skin_opened.y ~= nil and skin_opened.w ~= nil and skin_opened.h ~= nil)
        if skin_valid or sold_item ~= nil or points_added_alpha > 0 then
            local time_diff = fix_float(globals_curtime()) -- speed based off of time not fps
            if time_diff ~= time_diff_old_2 then
                time_diff_old_2 = time_diff
                box_alpha = clamp(math_abs(pulsate(globals_curtime() - end_time, 325, 45) * 10), 0, 255)

                local mouse_x, mouse_y = ui_mouse_position()
                -- if hover on item opened
                if skin_valid then
                    if mouse_x > skin_opened.x and mouse_x < skin_opened.x + skin_opened.w and mouse_y > skin_opened.y and mouse_y < skin_opened.y + skin_opened.h then
                        item_det_alpha = item_det_alpha + 30
                    else
                        item_det_alpha = item_det_alpha - 30
                    end
                end
                if points_added_alpha > 0 then
                    points_added_alpha = clamp(pulsate(globals_curtime() - rick.t + 0.01, 1000, 165) * 10, 0, 255)
                end
            end
            if skin_valid then
                if not is_in_animation and current_case[skin_opened.num] ~= nil then
                    rectangle_outline(skin_opened.x + 1, skin_opened.y + 2, skin_opened.w - 3, skin_opened.h - 6, skin_opened.r, skin_opened.g, skin_opened.b, box_alpha)
                
                    item_det_alpha = clamp(item_det_alpha, 0, 255)
                    local d_x, d_y, d_w, d_h = skin_opened.x + skin_opened.w + (s * 6), skin_opened.y + 5, skin_opened.w * 1.65, (s * 3) + (56 * s) + (skin_opened.stattrack and (12 * s) or 0)

                    skeet_box(d_x, d_y, d_w, d_h, item_det_alpha, false)

                    renderer_text(d_x + (s * 5), d_y + (s * 3), 220, 220, 220, item_det_alpha, "d", 0, current_case[skin_opened.num].full_name)

                    renderer_text(d_x + (s * 5),            d_y + (s * 3) + (12 * s), 155, 155, 155, item_det_alpha, "d", 0, "Rarity: ")
                    renderer_text(d_x + (s * 5) + (s * 50), d_y + (s * 3) + (12 * s), skin_opened.r, skin_opened.g, skin_opened.b, item_det_alpha, "d", 0, skin_opened.rarity)

                    renderer_text(d_x + (s * 5),            d_y + (s * 3) + (22 * s), 155, 155, 155, item_det_alpha, "d", 0, "Exterior: ")
                    renderer_text(d_x + (s * 5) + (s * 50), d_y + (s * 3) + (22 * s), 220, 220, 220, item_det_alpha, "d", 0, skin_opened.wear)

                    renderer_text(d_x + (s * 5),            d_y + (s * 3) + (32 * s), 155, 155, 155, item_det_alpha, "d", 0, "Points: ")
                    renderer_text(d_x + (s * 5) + (s * 50), d_y + (s * 3) + (32 * s), 220, 220, 220, item_det_alpha, "d", 0, skin_opened.points .. " " .. currency)

                    renderer_text(d_x + (s * 5),            d_y + (s * 3) + (42 * s), 155, 155, 155, item_det_alpha, "d", 0, "Chance: ")
                    renderer_text(d_x + (s * 5) + (s * 50), d_y + (s * 3) + (42 * s), 220, 220, 220, item_det_alpha, "d", 0, skin_opened.percentage)

                    renderer_text(d_x + (s * 5),            d_y + (s * 3) + (53 * s), 220, 220, 220, item_det_alpha, "d", 0, (skin_opened.stattrack and "StatTrak™ " or ""))
                end
            end
                
            if sold_item ~= nil then
                -- used for when selling thing
                renderer_text(x + scaled_w_ref + 5, y + (10 * s) - s, sold_item.r, sold_item.g, sold_item.b, points_added_alpha, "rd", 0, " +" .. sold_item.points .. " " .. currency)
            end
        end
    end
end)

client_set_event_callback('player_death', function(e) -- points
    local victim = client_userid_to_entindex(e.userid)

    if victim == entity_get_local_player() or client_userid_to_entindex(e.attacker) ~= entity_get_local_player() then
        return
    end

    local CCSPlayerResource = entity.get_player_resource()
    local ping = entity.get_prop(CCSPlayerResource, "m_iPing", victim)

    if ping ~= 0 then -- anti bot protection
        if e.headshot then
            calc_points(125)
        else
            calc_points(75)
        end
        database_write(points_location, points)
    end
end)
