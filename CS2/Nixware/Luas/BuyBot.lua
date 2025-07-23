-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

-- ported by: Minarut
local ffi = require("ffi")


local m_iHealth = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_iHealth")
local m_iTeamNum = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_iTeamNum")


local previousHealth = -1
local timerRunningHP = false
local timerHP = 0


local ui_x = 520
local ui_y = 110
local ui_width = 320
local ui_height = 754
local is_ui_open = true
local is_dragging = false
local drag_offset_x = 0
local drag_offset_y = 0
local prev_mouse_down = false
local pistols_desired_height = 90
local weapons_desired_height = 220
local other_desired_height = 125


local selected_pistol = nil 
local selected_weapon = nil 
local selected_other = {}

local pistol_scroll_offset = 0
local weapon_scroll_offset = 0
local other_scroll_offset = 0
local scroll_step = 1 

local font = render.setup_font("C:/Windows/Fonts/verdanab.ttf", 14)


local prev_insert_down = false


local should_buy_round_start = false
local should_buy_hp = false
local buy_delay = 0.5 
local buy_time_round_start = 0
local buy_time_hp = 0


local global_time = 0


for i = 1, 100 do
    selected_other[i] = false
end


local pistols_visible_items = 1
local weapons_visible_items = 1
local other_visible_items = 1


ffi.cdef[[
    typedef struct {
        long x;
        long y;
    } POINT;

    int GetCursorPos(POINT* lpPoint);
    int ScreenToClient(void* hWnd, POINT* lpPoint);
    short GetAsyncKeyState(int vKey);
    void* GetForegroundWindow();

    unsigned long GetTickCount();

    // ��������� ����������� ������
    static const int VK_INSERT = 0x2D;
    static const int VK_LBUTTON = 0x01;
    static const int VK_UP = 0x26;
    static const int VK_DOWN = 0x28;
    static const int VK_PRIOR = 0x21; // Page Up
    static const int VK_NEXT = 0x22;  // Page Down
]]

local user32 = ffi.load("user32")
local kernel32 = ffi.load("kernel32")

local VK_INSERT = 0x2D
local VK_LBUTTON = 0x01
local VK_UP = 0x26
local VK_DOWN = 0x28
local VK_PRIOR = 0x21 
local VK_NEXT = 0x22  


local function get_mouse_pos()
    local point = ffi.new("POINT[1]")
    user32.GetCursorPos(point)
    local hwnd = user32.GetForegroundWindow()
    user32.ScreenToClient(hwnd, point)
    return vec2_t(point[0].x, point[0].y)
end


local function is_key_pressed(vk_key)
    return bit.band(user32.GetAsyncKeyState(vk_key), 0x8000) ~= 0
end

local function is_key_down(vk_key)
    return user32.GetAsyncKeyState(vk_key) < 0
end


local function get_player_health()
    local local_pawn = entitylist.get_local_player_pawn()
    if not local_pawn then
        return -1
    end

    local health_ptr = ffi.cast("int*", local_pawn[m_iHealth])
    if health_ptr == nil then
        return -1
    end

    local health = health_ptr[0]
    return health
end


local team = "T" 

local function update_team()
    local local_player_controller = entitylist.get_local_player_controller()
    if local_player_controller then
        local team_num_ptr = ffi.cast("int*", local_player_controller[m_iTeamNum])
        if team_num_ptr ~= nil then
            local team_num = team_num_ptr[0]
            if team_num == 2 then
                team = "T"
            elseif team_num == 3 then
                team = "CT"
            else
                team = "SPEC"
            end
        end
    end
end

local weapons_name_list = {
    "AK-47/M4A1-S",
    "AWP",
    "G3SG1/SCAR-20",
    "Galil AR/FAMAS",
    "AUG/SG 553",
    "SSG 08",
    "Nova",
    "XM1014",
    "MAG-7/Sawed-Off",
    "MAC-10/MP9",
    "UMP-45",
    "P90",
    "PP-Bizon",
    "MP7/MP5-SD",
    "Negev",
    "M249",
}

local weapons_commands_T = {
    "buy ak47;",
    "buy awp;",
    "buy g3sg1;",
    "buy galilar;",
    "buy sg556;",
    "buy ssg08;",
    "buy nova;",
    "buy xm1014;",
    "buy sawedoff;",
    "buy mac10;",
    "buy ump45;",
    "buy p90;",
    "buy bizon;",
    "buy mp5sd;",
    "buy negev;",
    "buy m249;",
}

local weapons_commands_CT = {
    "buy m4a1_silencer;",
    "buy awp;",
    "buy scar20;",
    "buy famas;",
    "buy aug;",
    "buy ssg08;",
    "buy nova;",
    "buy xm1014;",
    "buy mag7;",
    "buy mp9;",
    "buy ump45;",
    "buy p90;",
    "buy bizon;",
    "buy mp7;",
    "buy negev;",
    "buy m249;",
}


local pistols_name_list = {
    "Glock-18/USP-S", 
    "Dual Berettas",
    "P250",
    "Tec-9/Five-SeveN/CZ75-Auto", 
    "Desert Eagle",
    "R8 Revolver",
}

local pistols_commands_T = {
    "buy glock;",
    "buy elite;",
    "buy p250;",
    "buy tec9; buy cz75a;",
    "buy deagle;",
    "buy revolver;",
}

local pistols_commands_CT = {
    "buy usp_silencer;",
    "buy elite;",
    "buy p250;",
    "buy fiveseven; buy cz75a;",
    "buy deagle;",
    "buy revolver;",
}


local other_name_list = {
    "Vest",
    "Vesthelm",
    "Taser",
    "Defuser", 
    "Flashbang",
    "Smoke Grenade",
    "HE Grenade",
    "Molotov/Incendiary",
    "Decoy Grenade"
}

local other_commands_T = {
    "buy vest;",
    "buy vesthelm;",
    "buy taser;",
    "", 
    "buy flashbang;",
    "buy smokegrenade;",
    "buy hegrenade;",
    "buy molotov;", 
    "buy decoy;",
}

local other_commands_CT = {
    "buy vest;",
    "buy vesthelm;",
    "buy taser;",
    "buy defuser;",
    "buy flashbang;",
    "buy smokegrenade;",
    "buy hegrenade;",
    "buy incgrenade;", 
    "buy decoy;",
}


function buy_bot()
    update_team() 

    local pistol_cmd = ""
    local weapon_cmd = ""
    local other_cmds = ""

    if team == "T" then
        if selected_pistol then
            pistol_cmd = pistols_commands_T[selected_pistol]
        end
        if selected_weapon then
            weapon_cmd = weapons_commands_T[selected_weapon]
        end
    elseif team == "CT" then
        if selected_pistol then
            pistol_cmd = pistols_commands_CT[selected_pistol]
        end
        if selected_weapon then
            weapon_cmd = weapons_commands_CT[selected_weapon]
        end
    end

    local other_commands_list = team == "T" and other_commands_T or other_commands_CT

    for i = 1, #selected_other do
        if selected_other[i] then
            local cmd = other_commands_list[i]
            if cmd and cmd ~= "" then
                other_cmds = other_cmds .. cmd
            end
        end
    end

    if pistol_cmd and pistol_cmd ~= "" then
        engine.execute_client_cmd(pistol_cmd)
    end
    if weapon_cmd and weapon_cmd ~= "" then
        engine.execute_client_cmd(weapon_cmd)
    end
    if other_cmds ~= "" then
        engine.execute_client_cmd(other_cmds)
    end
end


function on_round_start(event)
    
    should_buy_round_start = true
    buy_time_round_start = global_time + buy_delay
end


register_callback("round_start", on_round_start)


local function get_mouse_wheel_delta()
    
    local delta = 0
    if is_key_down(VK_PRIOR) then 
        delta = 1
    elseif is_key_down(VK_NEXT) then 
        delta = -1
    end
    return delta
end


function paint()
    
    global_time = global_time + render.frame_time()

    
    if should_buy_round_start and global_time >= buy_time_round_start then
        buy_bot()
        should_buy_round_start = false
    end

    
    local currentHealth = get_player_health()
    if currentHealth == -1 then
        
        previousHealth = -1
    else
        
        if previousHealth == 0 and currentHealth >= 100 then
            
            timerRunningHP = true
            timerHP = 0
        end
        previousHealth = currentHealth
    end

    
    if timerRunningHP then
        timerHP = timerHP + render.frame_time()
        if timerHP >= buy_delay then
            
            buy_bot()
            timerRunningHP = false
        end
    end

    
    local insert_down = is_key_pressed(VK_INSERT)
    if insert_down and not prev_insert_down then
        is_ui_open = not is_ui_open
    end
    prev_insert_down = insert_down

    if not is_ui_open then
        return
    end

    
    local mouse_pos = get_mouse_pos()
    local mouse_down = is_key_pressed(VK_LBUTTON)
    local mouse_click = mouse_down and not prev_mouse_down

    
    local wheel_delta = get_mouse_wheel_delta()

    
    local fixed_height = 30 
    fixed_height = fixed_height + 20 * 3 
    fixed_height = fixed_height + 10 * 2 

    
    local total_menu_height = ui_height - fixed_height

    
    local total_desired_height = pistols_desired_height + weapons_desired_height + other_desired_height

    
    local scale = total_menu_height / total_desired_height

    
    local pistol_list_height = pistols_desired_height * scale
    local weapon_list_height = weapons_desired_height * scale
    local other_list_height = other_desired_height * scale

    
    pistols_visible_items = math.max(1, math.floor(pistol_list_height / 20))
    weapons_visible_items = math.max(1, math.floor(weapon_list_height / 20))
    other_visible_items = math.max(1, math.floor(other_list_height / 20))

    
    local function is_over_text_elements(mouse_x, mouse_y)
        
        local x = ui_x
        local y = ui_y + 30 

        
        y = y + 20 
        local pistol_list_top = y
        local pistol_list_height_local = pistols_visible_items * 20
        local pistol_list_bottom = pistol_list_top + pistol_list_height_local

        for i = 1 + pistol_scroll_offset, math.min(#pistols_name_list, pistol_scroll_offset + pistols_visible_items) do
            local item_y = y + (i - 1 - pistol_scroll_offset) * 20
            if mouse_x >= x + 20 and mouse_x <= x + ui_width - 10 and mouse_y >= item_y and mouse_y <= item_y + 20 then
                return true
            end
        end
        y = pistol_list_bottom + 10

        
        y = y + 20 
        local weapon_list_top = y
        local weapon_list_height_local = weapons_visible_items * 20
        local weapon_list_bottom = weapon_list_top + weapon_list_height_local

        for i = 1 + weapon_scroll_offset, math.min(#weapons_name_list, weapon_scroll_offset + weapons_visible_items) do
            local item_y = y + (i - 1 - weapon_scroll_offset) * 20
            if mouse_x >= x + 20 and mouse_x <= x + ui_width - 10 and mouse_y >= item_y and mouse_y <= item_y + 20 then
                return true
            end
        end
        y = weapon_list_bottom + 10

        
        y = y + 20 
        local other_list_top = y
        local other_list_height_local = other_visible_items * 20
        local other_list_bottom = other_list_top + other_list_height_local

        for i = 1 + other_scroll_offset, math.min(#other_name_list, other_scroll_offset + other_visible_items) do
            local item_y = y + (i - 1 - other_scroll_offset) * 20
            if mouse_x >= x + 20 and mouse_x <= x + ui_width - 10 and mouse_y >= item_y and mouse_y <= item_y + 20 then
                return true
            end
        end

        
        return false
    end

    
    if mouse_click then
        local over_text = is_over_text_elements(mouse_pos.x, mouse_pos.y)
        if not over_text and mouse_pos.x >= ui_x and mouse_pos.x <= ui_x + ui_width and mouse_pos.y >= ui_y and mouse_pos.y <= ui_y + ui_height then
            is_dragging = true
            drag_offset_x = mouse_pos.x - ui_x
            drag_offset_y = mouse_pos.y - ui_y
        end
    end

    if not mouse_down then
        is_dragging = false
    end

    if is_dragging then
        ui_x = mouse_pos.x - drag_offset_x
        ui_y = mouse_pos.y - drag_offset_y
    end

    prev_mouse_down = mouse_down

    
    local x = ui_x
    local y = ui_y

    
    render.rect_filled(vec2_t(x - 10, y - 10), vec2_t(x + ui_width + 10, y + ui_height + 10), color_t(0, 0, 0, 0.8), 5)

    
    render.text("Buy Bot", font, vec2_t(x + ui_width / 2 - 50, y), color_t(1, 1, 1, 1))
    y = y + 30

    
    render.text("Pistols:", font, vec2_t(x + 10, y), color_t(1, 1, 1, 1))
    y = y + 20

    local pistol_list_start = x + 10
    local pistol_list_end = x + ui_width - 10
    local pistol_list_top = y
    local pistol_list_bottom = y + pistol_list_height

    
    render.rect_filled(vec2_t(pistol_list_start - 5, pistol_list_top - 5), vec2_t(pistol_list_end + 5, pistol_list_bottom + 5), color_t(0.1, 0.1, 0.1, 1), 5)

    
    if mouse_pos.x >= pistol_list_start and mouse_pos.x <= pistol_list_end and mouse_pos.y >= pistol_list_top and mouse_pos.y <= pistol_list_bottom then
        if wheel_delta ~= 0 then
            local max_pistols_scroll_offset = math.max(0, #pistols_name_list - pistols_visible_items)
            pistol_scroll_offset = math.max(0, math.min(pistol_scroll_offset - wheel_delta * scroll_step, max_pistols_scroll_offset))
        end
    end

    
    for i = 1 + pistol_scroll_offset, math.min(#pistols_name_list, pistol_scroll_offset + pistols_visible_items) do
        local item_y = y + (i - 1 - pistol_scroll_offset) * 20
        local item_hovered = mouse_pos.x >= x + 20 and mouse_pos.x <= x + ui_width - 10 and mouse_pos.y >= item_y and mouse_pos.y <= item_y + 20
        local is_selected = selected_pistol == i
        local text_color = is_selected and color_t(0, 1, 0, 1) or color_t(1, 1, 1, 1)

        
        local outline_color = item_hovered and color_t(0, 0, 0, 1) or color_t(0, 0, 0, 0.8)
        render.rect(vec2_t(x + 15, item_y), vec2_t(x + ui_width - 15, item_y + 20), outline_color)

        render.text(pistols_name_list[i], font, vec2_t(x + 20, item_y), text_color)
        
        if mouse_click and item_hovered then
            if is_selected then
                selected_pistol = nil 
            else
                selected_pistol = i
            end
        end
    end
    y = pistol_list_bottom + 10

    
    render.text("Weapon:", font, vec2_t(x + 10, y), color_t(1, 1, 1, 1))
    y = y + 20

    local weapon_list_start = x + 10
    local weapon_list_end = x + ui_width - 10
    local weapon_list_top = y
    local weapon_list_bottom = y + weapon_list_height

    
    render.rect_filled(vec2_t(weapon_list_start - 5, weapon_list_top - 5), vec2_t(weapon_list_end + 5, weapon_list_bottom + 5), color_t(0.1, 0.1, 0.1, 1), 5)

    
    if mouse_pos.x >= weapon_list_start and mouse_pos.x <= weapon_list_end and mouse_pos.y >= weapon_list_top and mouse_pos.y <= weapon_list_bottom then
        if wheel_delta ~= 0 then
            local max_weapons_scroll_offset = math.max(0, #weapons_name_list - weapons_visible_items)
            weapon_scroll_offset = math.max(0, math.min(weapon_scroll_offset - wheel_delta * scroll_step, max_weapons_scroll_offset))
        end
    end

    
    for i = 1 + weapon_scroll_offset, math.min(#weapons_name_list, weapon_scroll_offset + weapons_visible_items) do
        local item_y = y + (i - 1 - weapon_scroll_offset) * 20
        local item_hovered = mouse_pos.x >= x + 20 and mouse_pos.x <= x + ui_width - 10 and mouse_pos.y >= item_y and mouse_pos.y <= item_y + 20
        local is_selected = selected_weapon == i
        local text_color = is_selected and color_t(0, 1, 0, 1) or color_t(1, 1, 1, 1)

        
        local outline_color = item_hovered and color_t(0, 0, 0, 1) or color_t(0, 0, 0, 0.8)
        render.rect(vec2_t(x + 15, item_y), vec2_t(x + ui_width - 15, item_y + 20), outline_color)

        render.text(weapons_name_list[i], font, vec2_t(x + 20, item_y), text_color)
        
        if mouse_click and item_hovered then
            if is_selected then
                selected_weapon = nil 
            else
                selected_weapon = i
            end
        end
    end
    y = weapon_list_bottom + 10

    
    render.text("Other:", font, vec2_t(x + 10, y), color_t(1, 1, 1, 1))
    y = y + 20

    local other_list_start = x + 10
    local other_list_end = x + ui_width - 10
    local other_list_top = y
    local other_list_bottom = y + other_list_height

    
    render.rect_filled(vec2_t(other_list_start - 5, other_list_top - 5), vec2_t(other_list_end + 5, other_list_bottom + 5), color_t(0.1, 0.1, 0.1, 1), 5)

    
    if mouse_pos.x >= other_list_start and mouse_pos.x <= other_list_end and mouse_pos.y >= other_list_top and mouse_pos.y <= other_list_bottom then
        if wheel_delta ~= 0 then
            local max_other_scroll_offset = math.max(0, #other_name_list - other_visible_items)
            other_scroll_offset = math.max(0, math.min(other_scroll_offset - wheel_delta * scroll_step, max_other_scroll_offset))
        end
    end

    
    for i = 1 + other_scroll_offset, math.min(#other_name_list, other_scroll_offset + other_visible_items) do
        local item_y = y + (i - 1 - other_scroll_offset) * 20
        local item_hovered = mouse_pos.x >= x + 20 and mouse_pos.x <= x + ui_width - 10 and mouse_pos.y >= item_y and mouse_pos.y <= item_y + 20
        local is_selected = selected_other[i]
        local text_color = is_selected and color_t(0, 1, 0, 1) or color_t(1, 1, 1, 1)

        
        local outline_color = item_hovered and color_t(0, 0, 0, 1) or color_t(0, 0, 0, 0.8)
        render.rect(vec2_t(x + 15, item_y), vec2_t(x + ui_width - 15, item_y + 20), outline_color)

        render.text(other_name_list[i], font, vec2_t(x + 20, item_y), text_color)
        
        if mouse_click and item_hovered then
            selected_other[i] = not selected_other[i]
        end
    end
end


register_callback("paint", paint)