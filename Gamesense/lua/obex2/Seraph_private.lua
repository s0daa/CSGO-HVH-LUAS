-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- Seraph ~ Coded by underscore#0001 / discord.gg/lagcomp

-- region | Obex

local obex_data = obex_fetch and obex_fetch() or {username = 'admin', build = 'private', discord=''}

local name = obex_data.username
if name == "Speeds" then
    name = "underscore"
end

local build = obex_data.build
if build == "User" then
    build = "Stable"
end
-- endregion

-- region | Library
-- Credits to Throw#9999 / LuaSense Scripting
local _ENV = getfenv()

local libs = {
    {"gamesense/clipboard", "clipboard"},
    {"gamesense/antiaim_funcs", "anti_aim"},
    {"gamesense/base64", "base64"},
    {"gamesense/images", "images"}
}

for _, lib in ipairs(libs) do
    local success, loaded_lib = pcall(require, lib[1])
    if success then
        _ENV[lib[2]] = loaded_lib
    else
        error("Failed to load module: " .. lib[1], 2)
    end
end

-- endregion

-- region | Variables
X, Y = client.screen_size()
notification_table = {}
hitgroups = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}

local cl_mouseenable = cvar.cl_mouseenable
cl_mouseenable:set_int(0)
Click_Time = 0

seraph = {}

seraph.ui = {
    state = "Standing",
    states = {"Standing", "Running", "Ducking", "In Air", "Air Duck", "Slow Walk"},
    antiaim = {},
}

seraph.handlers = {
    ui = {
        elements = {},
        config = {}
    },
    aa = {
        state = {}
    },
}

seraph.references = {
    antiaim = {}
}

state_to_menu = {
    ["Standing"] = "[S]",
    ["Running"] = "[R]",
    ["Ducking"] = "[D]",
    ["In Air"] = "[A]",
    ["Air Duck"] = "[A-D]",
    ["Slow Walk"] = "[SW]"
}

seraph.handlers.ui.new = function(element, condition, config, callback)
    condition = condition or true
    config = config or false
    callback = callback or function() end

    local update = function()
        for k, v in pairs(seraph.handlers.ui.elements) do
            if type(v.condition) == "function" then
                ui.set_visible(v.element, v.condition())
            else
                ui.set_visible(v.element, v.condition)
            end
        end
    end

    table.insert(seraph.handlers.ui.elements, { element = element, condition = condition})

    if config then
        table.insert(seraph.handlers.ui.config, element)
    end

    ui.set_callback(element, function(value)
        update()
        callback(value)
    end)

    update()

    return element
end

-- endregion

-- region | AA References
seraph.references.antiaim.master = ui.reference("AA", "Anti-aimbot angles", "Enabled")
seraph.references.antiaim.pitch, seraph.references.pitch_offset = ui.reference("AA", "Anti-aimbot angles", "Pitch")
seraph.references.antiaim.yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
seraph.references.antiaim.yaw, seraph.references.antiaim.yaw_offset = ui.reference("AA", "Anti-aimbot angles", "Yaw")
seraph.references.antiaim.yaw_jitter, seraph.references.antiaim.yaw_jitter_offset = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
seraph.references.antiaim.body_yaw, seraph.references.antiaim.body_yaw_offset = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
seraph.references.antiaim.freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
seraph.references.antiaim.edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw")
seraph.references.antiaim.freestanding, seraph.references.antiaim.freestanding_key = ui.reference("AA", "Anti-aimbot angles", "Freestanding")
seraph.references.antiaim.roll, seraph.references.antiaim.roll_offset = ui.reference("AA", "Anti-aimbot angles", "Roll")

-- endregion

-- region | Images
cog = images.load_svg([[<svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
width="44.751px" height="44.751px" viewBox="0 0 44.751 44.751" style="enable-background:new 0 0 44.751 44.751;"
xml:space="preserve">
<g>
<g>
   <path d="M22.373,13.518c-4.885,0-8.859,3.974-8.859,8.858c0,4.884,3.976,8.856,8.859,8.856c4.883,0,8.857-3.973,8.857-8.856
       C31.232,17.492,27.257,13.518,22.373,13.518z" fill = "white"/>
   <path d="M42.648,18.928l-4.238-0.343c-0.412-1.744-1.102-3.384-2.021-4.866l2.76-3.242c0.818-0.821,1.104-1.866,0.635-2.337
       l-3.176-3.173c-0.469-0.471-1.516-0.188-2.334,0.635L31.031,8.36c-1.48-0.919-3.121-1.606-4.865-2.02L25.822,2.1
       c0-1.159-0.539-2.1-1.203-2.1h-4.486c-0.664,0-1.202,0.938-1.202,2.1l-0.345,4.24c-1.743,0.412-3.385,1.101-4.864,2.02
       l-3.244-2.758c-0.82-0.821-1.865-1.104-2.336-0.635L4.967,8.142C4.495,8.611,4.78,9.656,5.603,10.477l2.758,3.242
       c-0.918,1.482-1.605,3.122-2.02,4.866l-4.238,0.343c-1.16,0-2.101,0.539-2.101,1.203v4.488c0,0.662,0.938,1.203,2.101,1.203
       l4.238,0.345c0.414,1.743,1.102,3.383,2.02,4.864l-2.758,3.242c-0.82,0.82-1.105,1.865-0.635,2.334l3.174,3.176
       c0.471,0.472,1.516,0.187,2.336-0.635l3.244-2.758c1.479,0.92,3.121,1.607,4.864,2.02l0.345,4.24c0,1.158,0.539,2.101,1.202,2.101
       h4.486c0.664,0,1.203-0.939,1.203-2.101l0.344-4.24c1.744-0.411,3.385-1.1,4.865-2.02l3.24,2.758
       c0.82,0.818,1.867,1.104,2.336,0.635l3.176-3.174c0.471-0.471,0.188-1.516-0.635-2.336l-2.76-3.242
       c0.92-1.481,1.607-3.121,2.021-4.864l4.238-0.345c1.16,0,2.102-0.541,2.102-1.203v-4.488
       C44.748,19.467,43.808,18.928,42.648,18.928z M22.373,33.673c-6.229,0-11.295-5.068-11.295-11.296
       c0-6.229,5.065-11.296,11.295-11.296c6.229,0,11.295,5.066,11.295,11.296C33.667,28.604,28.601,33.673,22.373,33.673z" fill = "white"/>
</g>
</g>
</svg>]])

head = images.load_svg([[<svg width="800px" height="800px" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
<path d="M13.1469 21.1972L14.8163 20.0286C19.1794 16.9744 21.3182 11.6252 20.2636 6.40484C20.212 6.14963 20.0447 5.93295 19.8108 5.8186L12 2L4.18923 5.8186C3.95533 5.93295 3.78795 6.14963 3.7364 6.40484C2.68177 11.6252 4.82058 16.9744 9.18369 20.0286L10.8531 21.1972C11.5417 21.6792 12.4583 21.6792 13.1469 21.1972Z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="white"/>
</svg>]])

info = images.load_svg([[<svg width="800px" height="800px" viewBox="0 0 16 16" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
<path fill="white" d="M6 0h4v4l-1 7h-2l-1-7z"></path>
<path fill="white" d="M10 14c0 1.105-0.895 2-2 2s-2-0.895-2-2c0-1.105 0.895-2 2-2s2 0.895 2 2z"></path>
</svg>]])
-- endregion

-- region | Custom Menu Tabs

local function draw_container(x, y, w, h, a)
	local c = {10, 60, 40, 40, 40, 60, 20}
	for i = 0,6,1 do
		renderer.rectangle(x+i, y+i, w-(i*2), h-(i*2), c[i+1], c[i+1], c[i+1], a)
	end
end

local hovered_index = nil
local function get_tab()
    local menu_x, menu_y = ui.menu_position()
    local mouse_x, mouse_y = ui.mouse_position()

    local tab_height = 64
    local padding = 6
    local tab_width = 75
    local top_padding = 20

    for i = 1, 9 do
        if mouse_x >= menu_x + padding and mouse_x <= menu_x + padding + tab_width and mouse_y >= menu_y + top_padding + (i - 1) * tab_height and mouse_y <= menu_y + top_padding + i * tab_height and client.key_state(0x01) then
            hovered_index = i
        end
    end
end

local x, o = '\x14\x14\x14\xFF', '\x0c\x0c\x0c\xFF'
local pattern = table.concat{
  x,x,o,x,
  o,x,o,x,
  o,x,x,x,
  o,x,o,x
}
local tex_id = renderer.load_rgba(pattern, 4, 4)

local selected_tab = 1
local r1, g2, b2, a2 = 0, 0, 0, 0
local function render_menu()
    if not ui.is_menu_open() then return end
    get_tab()
    if hovered_index ~= 2 then return end
    local menu_size = ui.menu_size()
    local menu_x, menu_y = ui.menu_position()

    local height = 75

    draw_container(menu_x, menu_y - height, menu_size, height, 255)

    local rectangle_width = menu_size / 3
    local rectangle_height = height - 14

    for i = 1, 3 do
        local w = rectangle_width - 7
        local x = menu_x + 7 + (w * (i - 1))
        local r, g, b, a = 12, 12, 12, 255

        local mouse_x, mouse_y = ui.mouse_position()
        if mouse_x >= x and mouse_x <= x + w + 8 and mouse_y >= menu_y - height + 7 and mouse_y <= menu_y - height + 7 + rectangle_height then
            r, g, b = 23, 23, 23
            if client.key_state(0x01) and selected_tab ~= i then
                selected_tab = i
            end
        end
        if selected_tab == i then
            renderer.texture(tex_id, x, menu_y - height + 7, w + 8, rectangle_height, 255, 255, 255, 255, 'r')
            r1, g2, b2, a2 = 209, 209, 209, 255
        else
            renderer.rectangle(x, menu_y - height + 7, w + 8, rectangle_height, r, g, b, a)
            r1, g2, b2, a2 = 167, 167, 167, 255
        end
        if i == 3 then
            cog:draw(x + w/2 - 18, menu_y - 60 + 3, 40, 40, r1, g2, b2, a2)
        end
        if i == 2 then
            head:draw(x + w/2 - 18, menu_y - 60 + 3, 40, 40, r1, g2, b2, a2)
        end
        if i == 1 then
            info:draw(x + w/2 - 18, menu_y - 60 + 3, 40, 40, r1, g2, b2, a2)
        end
        for k, v in pairs(seraph.handlers.ui.elements) do
            if type(v.condition) == "function" then
                ui.set_visible(v.element, v.condition())
            else
                ui.set_visible(v.element, v.condition)
            end
        end
    end
end

-- endregion

-- region | UI Elements
seraph.ui.label = seraph.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "\a69bdd2ff~Information~"), function()
    return selected_tab == 1
end)

seraph.ui.spacer = seraph.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " "), function()
    return selected_tab == 1
end)

seraph.ui.spacer = seraph.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "\a69bdd2ffLast Update: 27/04/2023"), function()
    return selected_tab == 1
end)

seraph.ui.spacer = seraph.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "\a69bdd2ffUsername: " .. name), function()
    return selected_tab == 1
end)

seraph.ui.spacer = seraph.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "\a69bdd2ffDiscord: discord.gg/lagcomp"), function()
    return selected_tab == 1
end)

seraph.ui.spacer = seraph.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "\a69bdd2ffSuggest New Features In The Discord"), function()
    return selected_tab == 1
end)

seraph.ui.label = seraph.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "\a69bdd2ff~Anti-Aim~"), function()
    return selected_tab == 2
end)

seraph.ui.spacer = seraph.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " "), function()
    return selected_tab == 2
end)

seraph.ui.antiaim.condition = seraph.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\a69bdd2ff Player Condition", seraph.ui.states), function()
    return selected_tab == 2
end)

for _, v in pairs(seraph.ui.states) do
    seraph.ui.antiaim[v] = {}
    seraph.ui.antiaim[v].master = seraph.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles",v .. "\a69bdd2ff Override"), function() return selected_tab == 2 and ui.get(seraph.ui.antiaim.condition) == v end)

    local function visible() return selected_tab == 2 and ui.get(seraph.ui.antiaim.condition) == v and ui.get(seraph.ui.antiaim[v].master) end
    seraph.ui.antiaim[v].yaw_base = seraph.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", state_to_menu[v] .. " \a69bdd2ffYaw base", {"Local view", "At targets"}), function() return visible() end)
    seraph.ui.antiaim[v].yaw_type = seraph.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", state_to_menu[v] .. " \a69bdd2ffYaw Type", {"Static", "Custom Desync", "Tickbased", "Sway"}), function() return visible() end)
    seraph.ui.antiaim[v].yaw_left = seraph.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", state_to_menu[v] .. " \a69bdd2ffAdd left", -180, 180, 0, true, "°"), function() return visible() and ui.get(seraph.ui.antiaim[v].yaw_type) == "Tickbased" end)
    seraph.ui.antiaim[v].yaw_right = seraph.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", state_to_menu[v] .. " \a69bdd2ffAdd right", -180, 180, 0, true, "°"), function() return visible() and ui.get(seraph.ui.antiaim[v].yaw_type) == "Tickbased" end)
    seraph.ui.antiaim[v].yaw_l = seraph.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", state_to_menu[v] .. " \a69bdd2ffL", -180, 180, 0, true, "°"), function() return visible() and ui.get(seraph.ui.antiaim[v].yaw_type) == "Custom Desync" end)
    seraph.ui.antiaim[v].yaw_r = seraph.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", state_to_menu[v] .. " \a69bdd2ffR", -180, 180, 0, true, "°"), function() return visible() and ui.get(seraph.ui.antiaim[v].yaw_type) == "Custom Desync" end)
    seraph.ui.antiaim[v].yaw_static = seraph.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", state_to_menu[v] .. " \a69bdd2ffYaw offset", -180, 180, 0, true, "°"), function() return visible() and ui.get(seraph.ui.antiaim[v].yaw_type) == "Static" end)
    seraph.ui.antiaim[v].yaw_sway_min = seraph.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", state_to_menu[v] .. " \a69bdd2ffMinimum sway", -180, 180, 0, true, "°"), function() return visible() and ui.get(seraph.ui.antiaim[v].yaw_type) == "Sway" end)
    seraph.ui.antiaim[v].yaw_sway_max = seraph.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", state_to_menu[v] .. " \a69bdd2ffMaximum sway", -180, 180, 0, true, "°"), function() return visible() and ui.get(seraph.ui.antiaim[v].yaw_type) == "Sway"  end)
    seraph.ui.antiaim[v].yaw_sway_speed = seraph.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", state_to_menu[v] .. " \a69bdd2ffSway speed", 1, 10, 1, true, "x"), function() return visible() and ui.get(seraph.ui.antiaim[v].yaw_type) == "Sway"  end)
    seraph.ui.antiaim[v].yaw_label = seraph.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles","\af25555ffCycle value must be higher than activation"), function() return visible() and ui.get(seraph.ui.antiaim[v].yaw_type) == "Tickbased" end)
    seraph.ui.antiaim[v].yaw_speed = seraph.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", state_to_menu[v] .. " \a69bdd2ffTick cycle", 1, 50, 10, true, "x"), function() return visible() and ui.get(seraph.ui.antiaim[v].yaw_type) == "Tickbased" end)
    seraph.ui.antiaim[v].tick_activation = seraph.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", state_to_menu[v] .. " \a69bdd2ffTick activation", 1, 10, 5, true, "t"), function() return visible() and ui.get(seraph.ui.antiaim[v].yaw_type) == "Tickbased" end)
    seraph.ui.antiaim[v].yaw_jitter = seraph.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", state_to_menu[v] .. " \a69bdd2ffYaw jitter", {"Off", "Offset", "Center", "Random", "Skitter"}), function() return visible() end)
    seraph.ui.antiaim[v].yaw_jitter_offset = seraph.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", state_to_menu[v] .. " \a69bdd2ffYaw jitter offset", -180, 180, 0, true, "°"), function() return visible() end)
    seraph.ui.antiaim[v].body_yaw = seraph.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", state_to_menu[v] .. " \a69bdd2ffBody yaw", {"Off", "Opposite", "Jitter", "Static"}), function() return visible() end)
    seraph.ui.antiaim[v].body_yaw_offset = seraph.handlers.ui.new(ui.new_slider("AA", "Anti-aimbot angles", state_to_menu[v] .. " \a69bdd2ffBody yaw offset", -180, 180, 0, true, "°"), function() return visible() end)
    seraph.ui.antiaim[v].defensive = seraph.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", state_to_menu[v] .. " \a69bdd2ffDefensive"), function() return visible() end)
end

seraph.ui.antiaim.export = seraph.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "Export Anti-Aim Data", function() end), function()
    return selected_tab == 2
end)
seraph.ui.antiaim.import = seraph.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "Import Anti-Aim Data", function() end), function()
    return selected_tab == 2
end)

seraph.ui.default_config = seraph.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "Load Default Config", function() end), function()
    return selected_tab == 2
end)

seraph.ui.antiaim.copy_select = seraph.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\a69bdd2ffCondition Select", seraph.ui.states), function()
    return selected_tab == 2
end)

seraph.ui.antiaim.copy = seraph.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "Send AA Data To Selected Condition", function() end), function()
    return selected_tab == 2
end)

seraph.ui.spacer = seraph.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " "), function()
    return selected_tab == 2
end)

seraph.ui.freestanding = seraph.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "»\a69bdd2ff Freestanding"), function()
    return selected_tab == 2
end)

seraph.ui.freestanding_key = seraph.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", "\a69bdd2ff Freestanding Key", true), function()
    return selected_tab == 2
end)

seraph.ui.manual_left = seraph.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "»\a69bdd2ff Manual Left"), function()
    return selected_tab == 2
end)

seraph.ui.manual_left_key = seraph.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", "\a69bdd2ff Manual Left Key", true), function()
    return selected_tab == 2
end)

seraph.ui.manual_right = seraph.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "»\a69bdd2ff Manual Right"), function()
    return selected_tab == 2
end)

seraph.ui.manual_right_key = seraph.handlers.ui.new(ui.new_hotkey("AA", "Anti-aimbot angles", "\a69bdd2ff Manual Right Key", true), function()
    return selected_tab == 2
end)


seraph.ui.label = seraph.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "\a69bdd2ff~Miscellaneous~"), function()
    return selected_tab == 3
end)

seraph.ui.spacer = seraph.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", " "), function()
    return selected_tab == 3
end)

seraph.ui.aimbot_notifications = seraph.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\a69bdd2ffAimbot Notifications"), function()
    return selected_tab == 3
end)

seraph.ui.aimbot_notifications_style = seraph.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", " »\a69bdd2ff Style", {"Glow", "GS"}), function()
    return selected_tab == 3 and ui.get(seraph.ui.aimbot_notifications)
end)

seraph.ui.height_adv = seraph.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\a69bdd2ffHeight Advantage"), function()
    return selected_tab == 3
end)

seraph.ui.ind = seraph.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\a69bdd2ffCrosshair Indicator"), function()
    return selected_tab == 3
end)

seraph.ui.ind_col = seraph.handlers.ui.new(ui.new_color_picker("AA", "Anti-aimbot angles", "\a69bdd2ffCrosshair Indicator", 105,189,210,255), function()
    return selected_tab == 3
end)

seraph.ui.ind_spacer = seraph.handlers.ui.new(ui.new_label("AA", "Anti-aimbot angles", "\af25555ffInteract with indicators to enable"), function()
    return selected_tab == 3 and ui.get(seraph.ui.ind)
end)

seraph.ui.velocity_warning = seraph.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\a69bdd2ffVelocity Warning"), function()
    return selected_tab == 3
end)

seraph.ui.aimbot_stats = seraph.handlers.ui.new(ui.new_checkbox("AA", "Anti-aimbot angles", "\a69bdd2ffAimbot Statistics"), function()
    return selected_tab == 3
end)

seraph.ui.aimbot_stats_button = seraph.handlers.ui.new(ui.new_button("AA", "Anti-aimbot angles", "Reset Aimbot Statistics", function() end), function()
    return selected_tab == 3 and ui.get(seraph.ui.aimbot_stats)
end)

seraph.ui.watermark_style = seraph.handlers.ui.new(ui.new_combobox("AA", "Anti-aimbot angles", "\a69bdd2ff Watermark", {"Default", "Discord", "Sensemark"}), function()
    return selected_tab == 3
end)

-- endregion

-- region | Cheat Functions

function rounded_rectangle(x, y, w, h, radius, r, g, b, a)
    renderer.rectangle(x + radius, y, w - radius * 2, radius, r, g, b, a)
    renderer.rectangle(x, y + radius, radius, h - radius * 2, r, g, b, a)
    renderer.rectangle(x + radius, y + h - radius, w - radius * 2, radius, r, g, b, a)
    renderer.rectangle(x + w - radius, y + radius, radius, h - radius * 2, r, g, b, a)
    renderer.rectangle(x + radius, y + radius, w - radius * 2, h - radius * 2, r, g, b, a)
    renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
    renderer.circle(x + w - radius, y + radius, r, g, b, a, radius, 90, 0.25)
    renderer.circle(x + radius, y + h - radius, r, g, b, a, radius, 270, 0.25)
    renderer.circle(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25)
end

-- Credits to solus ui
function outline_glow(x, y, w, h, radius, r, g, b, a)
    renderer.rectangle(x + 2, y + radius + 6, 1, h - 6 * 2 - radius * 2, r, g, b, a)
    renderer.rectangle(x + w - 3, y + radius + 6, 1, h - 6 * 2 - radius * 2, r, g, b, a)
    renderer.rectangle(x + radius + 6, y + 2, w - 6 * 2 - radius * 2, 1, r, g, b, a)
    renderer.rectangle(x + radius + 6, y + h - 3, w - 6 * 2 - radius * 2, 1, r, g, b, a)
    renderer.circle_outline(x + radius + 6, y + radius + 6, r, g, b, a, radius + 4, 180, 0.25, 1)
    renderer.circle_outline(x + w - radius - 6, y + radius + 6, r, g, b, a, radius + 4, 270, 0.25, 1)
    renderer.circle_outline(x + radius + 6, y + h - radius - 6, r, g, b, a, radius + 4, 90, 0.25, 1)
    renderer.circle_outline(x + w - radius - 6, y + h - radius - 6, r, g, b, a, radius + 4, 0, 0.25, 1)
end

-- Credits to xdxd#1111
local ctx = {}
ctx.m_render = {
    rec = function(self, x, y, w, h, radius, color)
        radius = math.min(x/2, y/2, radius)
        local r, g, b, a = unpack(color)
        renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
        renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
        renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
        renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
        renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
        renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
        renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
    end,

    rec_outline = function(self, x, y, w, h, radius, thickness, color)
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
    end,

    glow_module = function(self, x, y, w, h, width, rounding, accent, accent_inner)
        local thickness = 1
        local offset = 1
        local r, g, b, a = unpack(accent)
        if accent_inner then
            self:rec(x , y, w, h + 1, rounding, accent_inner)
            --renderer.blur(x , y, w, h)
            --m_render.rec_outline(x + width*thickness - width*thickness, y + width*thickness - width*thickness, w - width*thickness*2 + width*thickness*2, h - width*thickness*2 + width*thickness*2, color(r, g, b, 255), rounding, thickness)
        end
        for k = 0, width do
            if a * (k/width)^(1) > 5 then
                local accent = {r, g, b, a * (k/width)^(2)}
                self:rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
            end
        end
    end
}

function lerp(a, b, t)
    return a + (b - a) * t
end

function movement(offset, when, original, new_place, speed)
    if when == true then
        offset = lerp(offset, new_place, globals.frametime() * speed)
    else
        offset = lerp(offset, original, globals.frametime() * speed)
    end

    return offset
end

function print_table(tbl, indent)
    indent = indent or 0
    local indentStr = string.rep(" ", indent)
    
    if type(tbl) ~= "table" then
        print(indentStr .. tostring(tbl))
        return
    end
    
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            print(indentStr .. tostring(k) .. " = {")
            print_table(v, indent + 4)
            print(indentStr .. "}")
        else
            print(indentStr .. tostring(k) .. " = " .. tostring(v))
        end
    end
end

function gs_frame(x, y, w, h, a)
	local c = {10, 60, 40, 40, 40, 60, 20}
	for i = 0,6,1 do
		renderer.rectangle(x+i, y+i, w-(i*2), h-(i*2), c[i+1], c[i+1], c[i+1], a)
	end
end

local offset = 0
offset = 30
function notifications()
    for k, v in pairs(notification_table) do
        if k > 8 then return end
        if v.time < globals.realtime() then table.remove(notification_table, k) end

        local text = v.text
        local text_size = {renderer.measure_text("b", text)}
        local side_padding = 20
        if ui.get(seraph.ui.aimbot_notifications_style) == "GS" then
            offset = 35
        end
        if ui.get(seraph.ui.aimbot_notifications_style) == "Glow" then
            offset = 30
        end

        v.position = movement(v.position, v.time > globals.realtime(), Y*0.7 + k*offset, Y*0.7 + (k-1)*offset, 10)

        if ui.get(seraph.ui.aimbot_notifications_style) == "GS" then
            gs_frame(X/2 - text_size[1]/2 - side_padding/2, v.position, text_size[1] + side_padding, 30, 255)
            renderer.text(X/2 - text_size[1]/2, v.position + text_size[2]/2 - 2.5 + 5, 255, 255, 255, 255, "b", nil, text)
        end

        if ui.get(seraph.ui.aimbot_notifications_style) == "Glow" then
            if v.hit then
                ctx.m_render:glow_module(X/2 - text_size[1]/2 - side_padding/2, v.position,  text_size[1] + side_padding, 20, 6 , 5, {159, 202, 43, 60}, {159, 202, 43, 60})
            elseif v.miss then
                ctx.m_render:glow_module(X/2 - text_size[1]/2 - side_padding/2, v.position,  text_size[1] + side_padding, 20, 6 , 5, {242, 85, 85, 60}, {242, 85, 85, 60})
            else
                ctx.m_render:glow_module(X/2 - text_size[1]/2 - side_padding/2, v.position,  text_size[1] + side_padding, 20, 6 , 5, {105,189,210, 50}, {105,189,210, 50})
            end

            rounded_rectangle(X/2 - text_size[1]/2 - side_padding/2, v.position, text_size[1] + side_padding, 20, 5, 20, 20, 20, 255)
            renderer.text(X/2 - text_size[1]/2, v.position + text_size[2]/2 - 2.5, 255, 255, 255, 255, "b", nil, text)
        end

    end
end

_, is_dt = ui.reference("RAGE", "Aimbot", "Double tap")
_, is_hs = ui.reference("AA", "Other", "On shot anti-aim")
is_fd = ui.reference("RAGE", "Other", "Duck peek assist")
is_baim = ui.reference("Rage", "Aimbot", "Force body aim")
fakelag = ui.reference("AA", "Fake lag", "Enabled")
slow_walk = {ui.reference("AA", "Other", "Slow motion")}

local ground_ticks = 0
function state_get(cmd)
    if not entity.get_local_player() then return end
    
    local player = entity.get_local_player()
    local flags = entity.get_prop(player, "m_fFlags")
    local vel1, vel2 = entity.get_prop(player,"m_vecVelocity")
    local velocity = math.floor(math.sqrt(vel1^2 + vel2^2))
    
    local ducking = cmd.in_duck == 1
    local air = ground_ticks < 5
    local running = velocity >=2
    local standing = velocity <= 1
    local slow_walking = ui.get(slow_walk[1]) and ui.get(slow_walk[2])
    ground_ticks = bit.band(flags, 1) == 0 and 0 or (ground_ticks < 5 and ground_ticks + 1 or ground_ticks)


    if air and not ducking then
        seraph.ui.state = "In Air"
    elseif air and ducking then
        seraph.ui.state = "Air Duck"
    elseif ducking then
        seraph.ui.state = "Ducking"
    elseif slow_walking then
        seraph.ui.state = "Slow Walk"
    elseif running then
        seraph.ui.state = "Running"
    elseif standing then
        seraph.ui.state = "Standing"
    end

end

local sway = function(speed,min,max)
    return   math.min(math.max(math.floor(math.sin(globals.curtime() * speed) * max),min),max)
end

local aa_state
local switch = false
local defensive_enabled = false
local initial_sway_set = false
local reached_max = false
local reached_min = false
function set_aa(cmd)

    aa_state = seraph.ui.state
    if not ui.get(seraph.ui.antiaim[aa_state].master) then return end

    ui.set(seraph.references.antiaim.pitch, "Down")
    ui.set(seraph.references.antiaim.yaw_base, ui.get(seraph.ui.antiaim[aa_state].yaw_base))
    ui.set(seraph.references.antiaim.yaw, "180")

    ui.set(seraph.references.antiaim.yaw_jitter, ui.get(seraph.ui.antiaim[aa_state].yaw_jitter))
    ui.set(seraph.references.antiaim.yaw_jitter_offset, ui.get(seraph.ui.antiaim[aa_state].yaw_jitter_offset))
    ui.set(seraph.references.antiaim.body_yaw, ui.get(seraph.ui.antiaim[aa_state].body_yaw))
    ui.set(seraph.references.antiaim.body_yaw_offset, ui.get(seraph.ui.antiaim[aa_state].body_yaw_offset))

    if ui.get(seraph.ui.antiaim[aa_state].yaw_type) == "Static" then
        ui.set(seraph.references.antiaim.yaw_offset, ui.get(seraph.ui.antiaim[aa_state].yaw_static))
    elseif ui.get(seraph.ui.antiaim[aa_state].yaw_type) == "Custom Desync" then
        if globals.tickcount() % 2 == 1 then
            if not switch then
                ui.set(seraph.references.antiaim.yaw_offset, ui.get(seraph.ui.antiaim[aa_state].yaw_l))
                switch = true
            elseif switch then
                ui.set(seraph.references.antiaim.yaw_offset, ui.get(seraph.ui.antiaim[aa_state].yaw_r))
                switch = false
            end
        end
    elseif ui.get(seraph.ui.antiaim[aa_state].yaw_type) == "Tickbased" then
        if globals.tickcount() % ui.get(seraph.ui.antiaim[aa_state].yaw_speed) == ui.get(seraph.ui.antiaim[aa_state].tick_activation) then
            if not switch then
                ui.set(seraph.references.antiaim.yaw_offset, ui.get(seraph.ui.antiaim[aa_state].yaw_left))
                switch = true
            elseif switch then
                ui.set(seraph.references.antiaim.yaw_offset, ui.get(seraph.ui.antiaim[aa_state].yaw_right))
                switch = false
            end
        end
    elseif ui.get(seraph.ui.antiaim[aa_state].yaw_type) == "Sway" then
        local min = ui.get(seraph.ui.antiaim[aa_state].yaw_sway_min)
        local max = ui.get(seraph.ui.antiaim[aa_state].yaw_sway_max)
        local swaying = sway(ui.get(seraph.ui.antiaim[aa_state].yaw_sway_speed),min,max)
        ui.set(seraph.references.antiaim.yaw_offset, swaying)
    end



    if ui.get(seraph.ui.antiaim[aa_state].defensive) and ui.get(is_dt) and seraph.ui.state == aa_state then
        defensive_enabled = true
        cmd.force_defensive = 1
    else 
        defensive_enabled = false
        cmd.force_defensive = 0
    end

end


function overrides()

    if ui.get(seraph.ui.manual_left_key) then
        ui.set(seraph.references.antiaim.yaw_offset, -90 or 0)
    end

    if ui.get(seraph.ui.manual_right_key) then
        ui.set(seraph.references.antiaim.yaw_offset, 90 or 0)
    end
    

    local freestanding = ui.get(seraph.ui.freestanding_key)

    ui.set(seraph.references.antiaim.freestanding_key, freestanding)
    ui.set(seraph.references.antiaim.freestanding, freestanding)
end

function height_advtange()
    if not entity.get_local_player() then return end
    if not entity.is_alive(entity.get_local_player()) then return end
    if not ui.get(seraph.ui.height_adv) then return end
    local player = entity.get_local_player()
    local height = {entity.get_prop(player, "m_vecOrigin")}
    local threat = client.current_threat()
    local t_height = 0

    if threat ~= nil then
        t_height = {entity.get_prop(threat, "m_vecOrigin")}
        if height[3] > t_height[3] then
            renderer.indicator(0, 255, 0, 255, "HEIGHT")
        end
    end
end

local over_width = 0
local alpha = 0
local alpha_glow = 0
function defensive_ind()
    if not entity.get_local_player() then return end
    if not entity.is_alive(entity.get_local_player()) then return end

    if not defensive_enabled then
        over_width = 0
        alpha = 0
        alpha_glow = 0
    end

    if defensive_enabled and ui.get(is_dt) then

        local text = "defensive charging"
        local text_size = {renderer.measure_text("b", text)}
        local bg_width = 46
        over_width = movement(over_width, over_width < 50, 0, 50, 3)
        alpha = movement(alpha, defensive_enabled, 0, 255, 2)
        alpha_glow = movement(alpha_glow, defensive_enabled, 0, 60, 2)
        if over_width > 45 then over_width = 0 end

        ctx.m_render:glow_module(X/2 - bg_width, Y*0.25-1,  bg_width*2, 4, 10 , 2, {105,189,210, alpha_glow}, {105,189,210, alpha_glow})
        --x, y, w, h, width, rounding, accent, accent_inner
        renderer.text(X/2 - text_size[1]/2, Y*0.235, 255, 255, 255, alpha, "", nil, text)
        rounded_rectangle(X/2 - bg_width, Y*0.25, bg_width*2, 4, 1, 20, 20, 20, alpha)
        rounded_rectangle(X/2 - over_width, Y*0.25+1, over_width*2, 2, 1, 105,189,210,alpha)
    else
        over_width = 0
        alpha = 0
        alpha_glow = 0
    end
end

local filled_width = 0
function vel_ind()
    if not ui.get(seraph.ui.velocity_warning) then return end
    if not entity.get_local_player() then return end
    if not entity.is_alive(entity.get_local_player()) then return end
    local velocity = entity.get_prop(entity.get_local_player(), "m_flVelocityModifier") + 0.01

    if ui.is_menu_open() then
        velocity = entity.get_prop(entity.get_local_player(), "m_flVelocityModifier")
    end

    if velocity == 1.01 then return end

    local percent = math.floor(velocity*100)

    local text = string.format('velocity warning ~ %.0f%%', percent)
    local text_size = {renderer.measure_text("", text)}
    local bg_width = 46

    filled_width = percent / 100 * 45

    ctx.m_render:glow_module(X/2 - bg_width, Y*0.3,  bg_width*2, 5 ,10 ,2 , {105,189,210, 60}, {105,189,210, 60})
    rounded_rectangle(X/2 - bg_width, Y*0.3, bg_width*2, 5, 1, 20, 20, 20, 255)
    rounded_rectangle(X/2 - filled_width, Y*0.3+1, filled_width*2, 3, 1, 105,189,210,255)
    renderer.text(X/2 - text_size[1]/2, Y*0.29 - 5, 255, 255, 255, 255, "", nil, text)
end
local x, y, w, h= database.read('waterx') or X*0.9, database.read('watery') or Y*0.55, 51, 12
function watermark()

    if ui.get(seraph.ui.watermark_style) == "Sensemark" then

        local text = animate_text(globals.realtime() * 5, "S E R A P H", 255,255,255, 255, 20, 20, 20, 255)
        local t = ""
        for _, v in pairs(text) do
            t = t .. v
        end
        renderer.text(x, y, 0, 0, 0, 0, "", 0, t)
        if ui.is_menu_open() then
            local pulse = math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255;
            renderer.text(x - 6, y - 20, 255, 255, 255, pulse, "", nil, "drag to move")
        end

        local mouseposx, mouseposy = ui.mouse_position()
        if client.key_state(0x01) and mouseposy <= y+h and mouseposy >= y and mouseposx <= x+w and mouseposx >= x then
            x = mouseposx - w/2
            y = mouseposy - h/2
            database.write('waterx', x)
            database.write('watery', y)
        end
    end

    if ui.get(seraph.ui.watermark_style) == "Default" then
        local time = {client.system_time()}
        local actual_time = string.format("%02d:%02d:%02d", time[1], time[2], time[3])
        local text = "seraph • \a69bdd2ff".. name .. "\affffffff • \a69bdd2ff"..build.."\affffffff • " .. actual_time
        local text_size = {renderer.measure_text("b", text)}
        local side_padding = 20

        ctx.m_render:glow_module(X - text_size[1] - side_padding - 10, 10, text_size[1] + side_padding, 25, 15 , 5, {105,189,210, 90}, {105,189,210, 90})

        rounded_rectangle(X - text_size[1] - side_padding - 10, 10, text_size[1] + side_padding, 25, 5, 20, 20, 20, 255)
        renderer.text(X - text_size[1] - side_padding, 10 + text_size[2]/2, 255, 255, 255, 255, "b", nil, text)
    end

    if ui.get(seraph.ui.watermark_style) == "Discord" then
        local text = "discord.gg/\a69bdd2fflagcomp"
        local text_size = {renderer.measure_text("b", text)}
        ctx.m_render:glow_module(X - text_size[1] - 5, text_size[2] - 3, text_size[1], 5 , 10 , 1, {105,189,210, 90}, {105,189,210, 90})
        renderer.text(X - text_size[1] - 5, 5, 255, 255, 255, 255, "b", nil, text)
    end

end

function rgba_to_hex(r, g, b, a)
    return string.format("%02X%02X%02X%02X", r, g, b, a)
end

function animate_text(time, string, ri, gi, bi, ai, r, g, b, a)
    local t_out, t_out_iter = {}, 1

    local r_add = (ri - r)
    local g_add = (gi - g)
    local b_add = (bi - b)
    local a_add = (a)
    for i = 1, #string do
        local iter = (i - 1) / (#string - 1) + time
        t_out[t_out_iter] = "\a" ..
        rgba_to_hex( r + r_add * math.abs(math.cos(iter)), g + g_add * math.abs(math.cos(iter)),
                b + b_add * math.abs(math.cos(iter)) , a_add)

        t_out[t_out_iter + 1] = string:sub(i, i)
        t_out_iter = t_out_iter + 2
    end

    return t_out
end


------------------- MY FUCKING BRAIN HURTSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS

indicators_table_gradient= {
    { enabled = false, index = 0, alpha = 0, menu = is_dt, name = "DOUBLETAP", padding = 0, sufix_padding = 0, clip = {charging = 0, ready = 0}},
    { enabled = false, index = 0, alpha = 0, menu = is_hs, name = "OSAA" , padding = 0 },
    {enabled = false, index = 0, alpha = 0, menu = is_fd, name = "DUCK", padding = 0},
    {enabled = false, index = 0, alpha = 0, menu = is_baim, name = "BAIM", padding = 0}
}

seraph_padding = 0
movement_padding = 0
crosshair_inds = function()
    if not ui.get(seraph.ui.ind) then return end
    if not entity.get_local_player() then return end
    local LButton = client.key_state(0x01)
    local mouseX, mouseY = ui.mouse_position()
    local isScoped = entity.get_prop(entity.get_local_player(), "m_bIsScoped", 0) == 1
    local size = renderer.measure_text("b", "seraph")
    seraph_padding = movement(seraph_padding, isScoped , size * 0.5, -6, 12)
    local size = renderer.measure_text("-", string.upper(seraph.ui.state))
    movement_padding = movement(movement_padding, isScoped , size * 0.5 + 1, -5, 12)
    local col = {ui.get(seraph.ui.ind_col)}


    local text = animate_text(globals.realtime() * 3, "seraph", col[1],col[2],col[3], 255, 20, 20, 20, 255)
    local t = ""
    for _, v in pairs(text) do
        t = t .. v
    end
    renderer.text(X/2 - seraph_padding, Y * 0.5 + 35, 0, 0, 0, 0, "b", 0, t)

    local incrementor = 12

    local size, size_y = renderer.measure_text("-", string.upper(seraph.ui.state))
    renderer.text(X/2 - movement_padding, Y*0.5 + 56 - size_y, 255, 255, 255, 255, "-", 0, string.upper(seraph.ui.state))
    for _, v in pairs(indicators_table_gradient) do
        local condition = ui.get(v["menu"]) and v.enabled
        if ui.is_menu_open() then condition = true end
        local text_x, text_y = renderer.measure_text("-", v.name)
        if condition then incrementor = incrementor + 10 end
        local alpha = 0
        if v.enabled then alpha = 255 end
        if not v.enabled then alpha = ui.is_menu_open() and 100 or 0 end
        v["padding"] = movement(v["padding"], isScoped, text_x * 0.5, 0 - 6, 12)
        v["index"] = movement(v["index"], condition, 0, incrementor, 30)
        v["alpha"] = movement(v["alpha"], condition, 0, alpha, 30)

        renderer.text(X/2 - v["padding"] - 1, Y * 0.5 + math.floor(v["index"]) + 35, 255, 255, 255,
        v["alpha"], "-", 0,
        string.upper(v["name"]))

        if ui.is_menu_open() and LButton and Click_Time < globals.realtime() and mouseX >= X * 0.5 - v["padding"] and mouseX <= X * 0.5 + v["padding"] and mouseY >= Y * 0.5 + math.floor(v["index"]) + 35 - text_y * 0.1 and mouseY <= Y * 0.5 + math.floor(v["index"]) + 35 + text_y then
            Click_Time = globals.realtime() + 0.2
            v.enabled = not v.enabled
        end

    end
end
-- endregion

-- region | Callbacks
client.set_event_callback('setup_command', function(cmd)
    if ui.is_menu_open() then
        cmd.in_attack = false
        cmd.in_attack2 = false
    end
end)

client.set_event_callback('paint_ui', function()
    render_menu()
end)

client.set_event_callback("paint_ui", function()
    for _, v in pairs(seraph.references.antiaim) do
        ui.set_visible(v, false)
    end
end)

client.set_event_callback("shutdown", function()
    for _, v in pairs(seraph.references.antiaim) do
        ui.set_visible(v, true)
    end
end)

local alphabet = "base64"
ui.set_callback(seraph.ui.antiaim.export, function()
    local data = {}
    for _, v in pairs(seraph.ui.states) do
        local state_name = v
        data[state_name] = {
            master = ui.get(seraph.ui.antiaim[state_name].master),
            yaw_base = ui.get(seraph.ui.antiaim[state_name].yaw_base),
            yaw_left = ui.get(seraph.ui.antiaim[state_name].yaw_left),
            yaw_right = ui.get(seraph.ui.antiaim[state_name].yaw_right),
            yaw_l = ui.get(seraph.ui.antiaim[state_name].yaw_l),
            yaw_r = ui.get(seraph.ui.antiaim[state_name].yaw_r),
            yaw_speed = ui.get(seraph.ui.antiaim[state_name].yaw_speed),
            yaw_jitter = ui.get(seraph.ui.antiaim[state_name].yaw_jitter),
            yaw_jitter_offset = ui.get(seraph.ui.antiaim[state_name].yaw_jitter_offset),
            body_yaw = ui.get(seraph.ui.antiaim[state_name].body_yaw),
            body_yaw_offset = ui.get(seraph.ui.antiaim[state_name].body_yaw_offset),
            tick_activation = ui.get(seraph.ui.antiaim[state_name].tick_activation),
            defensive = ui.get(seraph.ui.antiaim[state_name].defensive),
            yaw_static = ui.get(seraph.ui.antiaim[state_name].yaw_static),
            yaw_sway_min = ui.get(seraph.ui.antiaim[state_name].yaw_sway_min),
            yaw_sway_max = ui.get(seraph.ui.antiaim[state_name].yaw_sway_max),
            yaw_sway_speed = ui.get(seraph.ui.antiaim[state_name].yaw_sway_speed),
            yaw_type = ui.get(seraph.ui.antiaim[state_name].yaw_type)
        }
    end
    data.owner = "obex name function :nerd:"
    local text = json.stringify(data)
    local encoded = base64.encode(text, alphabet)
    local text = "seraph • \a9FCA2Bffsuccessfully exported anti-aim data to clipboard"
    notification_table[#notification_table+1] = {text = text, time = globals.realtime() + 5, position = Y*0.7, alpha = 0}
    clipboard.set(encoded)
end)

function import_config(text)
    local protected = function()
        local decoded = base64.decode(text, alphabet)
        local parsed = json.parse(decoded)
        if parsed ~= nil then
            for k, v in pairs(parsed) do
                if seraph.ui.antiaim[k] then
                    ui.set(seraph.ui.antiaim[k].master, v.master)
                    ui.set(seraph.ui.antiaim[k].yaw_base, v.yaw_base)
                    ui.set(seraph.ui.antiaim[k].yaw_left, v.yaw_left)
                    ui.set(seraph.ui.antiaim[k].yaw_right, v.yaw_right)
                    ui.set(seraph.ui.antiaim[k].yaw_l, v.yaw_l)
                    ui.set(seraph.ui.antiaim[k].yaw_r, v.yaw_r)
                    ui.set(seraph.ui.antiaim[k].yaw_speed, v.yaw_speed)
                    ui.set(seraph.ui.antiaim[k].yaw_jitter, v.yaw_jitter)
                    ui.set(seraph.ui.antiaim[k].yaw_jitter_offset, v.yaw_jitter_offset)
                    ui.set(seraph.ui.antiaim[k].body_yaw, v.body_yaw)
                    ui.set(seraph.ui.antiaim[k].body_yaw_offset, v.body_yaw_offset)
                    ui.set(seraph.ui.antiaim[k].tick_activation, v.tick_activation)
                    ui.set(seraph.ui.antiaim[k].defensive, v.defensive)
                    ui.set(seraph.ui.antiaim[k].yaw_static, v.yaw_static)
                    ui.set(seraph.ui.antiaim[k].yaw_sway_min, v.yaw_sway_min)
                    ui.set(seraph.ui.antiaim[k].yaw_sway_max, v.yaw_sway_max)
                    ui.set(seraph.ui.antiaim[k].yaw_sway_speed, v.yaw_sway_speed)
                    ui.set(seraph.ui.antiaim[k].yaw_type, v.yaw_type)
                end
            end
            local text = "seraph • \a9FCA2Bffsuccessfully imported anti-aim data"
            notification_table[#notification_table+1] = {text = text, time = globals.realtime() + 5, position = Y*0.7, alpha = 0}
        end
    end


    local s, m = pcall(protected)
    if not s then
        local text = "seraph • \af25555fffailed to import data"
        notification_table[#notification_table+1] = {text = text, time = globals.realtime() + 5, position = Y*0.7, alpha = 0}
        return
    end

end

ui.set_callback(seraph.ui.default_config, function()
    import_config("eyJEdWNraW5nIjp7Inlhd19zd2F5X21pbiI6MCwieWF3X3R5cGUiOiJDdXN0b20gRGVzeW5jIiwieWF3X3IiOjM0LCJ5YXdfc3BlZWQiOjEwLCJib2R5X3lhdyI6IlN0YXRpYyIsInlhd19sIjotNDEsInRpY2tfYWN0aXZhdGlvbiI6NSwieWF3X3N3YXlfc3BlZWQiOjEsImJvZHlfeWF3X29mZnNldCI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd19zdGF0aWMiOjAsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInlhd19zd2F5X21heCI6MCwibWFzdGVyIjp0cnVlLCJ5YXdfaml0dGVyX29mZnNldCI6MCwieWF3X2xlZnQiOjAsInlhd19yaWdodCI6MCwiZGVmZW5zaXZlIjpmYWxzZX0sIlNsb3cgV2FsayI6eyJ5YXdfc3dheV9taW4iOjAsInlhd190eXBlIjoiVGlja2Jhc2VkIiwieWF3X3IiOjAsInlhd19zcGVlZCI6MTAsImJvZHlfeWF3IjoiSml0dGVyIiwieWF3X2wiOjAsInRpY2tfYWN0aXZhdGlvbiI6NSwieWF3X3N3YXlfc3BlZWQiOjEsImJvZHlfeWF3X29mZnNldCI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd19zdGF0aWMiOjAsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInlhd19zd2F5X21heCI6MCwibWFzdGVyIjp0cnVlLCJ5YXdfaml0dGVyX29mZnNldCI6MCwieWF3X2xlZnQiOjYwLCJ5YXdfcmlnaHQiOi0zMCwiZGVmZW5zaXZlIjpmYWxzZX0sIm93bmVyIjoib2JleCBuYW1lIGZ1bmN0aW9uIDpuZXJkOiIsIkFpciBEdWNrIjp7Inlhd19zd2F5X21pbiI6MCwieWF3X3R5cGUiOiJDdXN0b20gRGVzeW5jIiwieWF3X3IiOjM4LCJ5YXdfc3BlZWQiOjEwLCJib2R5X3lhdyI6IlN0YXRpYyIsInlhd19sIjotMTksInRpY2tfYWN0aXZhdGlvbiI6NSwieWF3X3N3YXlfc3BlZWQiOjEsImJvZHlfeWF3X29mZnNldCI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd19zdGF0aWMiOjAsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInlhd19zd2F5X21heCI6MCwibWFzdGVyIjp0cnVlLCJ5YXdfaml0dGVyX29mZnNldCI6MCwieWF3X2xlZnQiOjAsInlhd19yaWdodCI6MCwiZGVmZW5zaXZlIjp0cnVlfSwiSW4gQWlyIjp7Inlhd19zd2F5X21pbiI6MCwieWF3X3R5cGUiOiJUaWNrYmFzZWQiLCJ5YXdfciI6MCwieWF3X3NwZWVkIjo2LCJib2R5X3lhdyI6IlN0YXRpYyIsInlhd19sIjowLCJ0aWNrX2FjdGl2YXRpb24iOjUsInlhd19zd2F5X3NwZWVkIjoxLCJib2R5X3lhd19vZmZzZXQiOjAsInlhd19qaXR0ZXIiOiJPZmYiLCJ5YXdfc3RhdGljIjowLCJ5YXdfYmFzZSI6IkF0IHRhcmdldHMiLCJ5YXdfc3dheV9tYXgiOjAsIm1hc3RlciI6dHJ1ZSwieWF3X2ppdHRlcl9vZmZzZXQiOjAsInlhd19sZWZ0Ijo0OCwieWF3X3JpZ2h0IjotMTQsImRlZmVuc2l2ZSI6dHJ1ZX0sIlJ1bm5pbmciOnsieWF3X3N3YXlfbWluIjowLCJ5YXdfdHlwZSI6IlRpY2tiYXNlZCIsInlhd19yIjowLCJ5YXdfc3BlZWQiOjcsImJvZHlfeWF3IjoiU3RhdGljIiwieWF3X2wiOjAsInRpY2tfYWN0aXZhdGlvbiI6NiwieWF3X3N3YXlfc3BlZWQiOjEsImJvZHlfeWF3X29mZnNldCI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd19zdGF0aWMiOjAsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInlhd19zd2F5X21heCI6MCwibWFzdGVyIjp0cnVlLCJ5YXdfaml0dGVyX29mZnNldCI6MCwieWF3X2xlZnQiOjQ2LCJ5YXdfcmlnaHQiOi0zMCwiZGVmZW5zaXZlIjpmYWxzZX0sIlN0YW5kaW5nIjp7Inlhd19zd2F5X21pbiI6MCwieWF3X3R5cGUiOiJDdXN0b20gRGVzeW5jIiwieWF3X3IiOi0zNCwieWF3X3NwZWVkIjoxMCwiYm9keV95YXciOiJTdGF0aWMiLCJ5YXdfbCI6MzQsInRpY2tfYWN0aXZhdGlvbiI6NSwieWF3X3N3YXlfc3BlZWQiOjEsImJvZHlfeWF3X29mZnNldCI6MCwieWF3X2ppdHRlciI6Ik9mZiIsInlhd19zdGF0aWMiOjAsInlhd19iYXNlIjoiQXQgdGFyZ2V0cyIsInlhd19zd2F5X21heCI6MCwibWFzdGVyIjp0cnVlLCJ5YXdfaml0dGVyX29mZnNldCI6MCwieWF3X2xlZnQiOjAsInlhd19yaWdodCI6MCwiZGVmZW5zaXZlIjpmYWxzZX19")
end)

ui.set_callback(seraph.ui.antiaim.import, function()
    import_config(clipboard.get())
end)

local current = "Standing"
local selected = "Standing"
ui.set_callback(seraph.ui.antiaim.copy, function()
    current = ui.get(seraph.ui.antiaim.condition)
    selected = ui.get(seraph.ui.antiaim.copy_select)
    local send = {}
    send[selected] = {
        master = ui.get(seraph.ui.antiaim[current].master),
        yaw_base = ui.get(seraph.ui.antiaim[current].yaw_base),
        yaw_left = ui.get(seraph.ui.antiaim[current].yaw_left),
        yaw_right = ui.get(seraph.ui.antiaim[current].yaw_right),
        yaw_l = ui.get(seraph.ui.antiaim[current].yaw_left),
        yaw_r = ui.get(seraph.ui.antiaim[current].yaw_right),
        yaw_speed = ui.get(seraph.ui.antiaim[current].yaw_speed),
        yaw_jitter = ui.get(seraph.ui.antiaim[current].yaw_jitter),
        yaw_jitter_offset = ui.get(seraph.ui.antiaim[current].yaw_jitter_offset),
        body_yaw = ui.get(seraph.ui.antiaim[current].body_yaw),
        body_yaw_offset = ui.get(seraph.ui.antiaim[current].body_yaw_offset),
        tick_activation = ui.get(seraph.ui.antiaim[current].tick_activation),
        defensive = ui.get(seraph.ui.antiaim[current].defensive),
        yaw_static = ui.get(seraph.ui.antiaim[current].yaw_static),
        yaw_sway_min = ui.get(seraph.ui.antiaim[current].yaw_sway_min),
        yaw_sway_max = ui.get(seraph.ui.antiaim[current].yaw_sway_max),
        yaw_sway_speed = ui.get(seraph.ui.antiaim[current].yaw_sway_speed),
        yaw_type = ui.get(seraph.ui.antiaim[current].yaw_type)
    }
    for k, v in pairs(send) do
        ui.set(seraph.ui.antiaim[k].master, v.master)
        ui.set(seraph.ui.antiaim[k].yaw_base, v.yaw_base)
        ui.set(seraph.ui.antiaim[k].yaw_left, v.yaw_left)
        ui.set(seraph.ui.antiaim[k].yaw_right, v.yaw_right)
        ui.set(seraph.ui.antiaim[k].yaw_l, v.yaw_l)
        ui.set(seraph.ui.antiaim[k].yaw_r, v.yaw_r)
        ui.set(seraph.ui.antiaim[k].yaw_speed, v.yaw_speed)
        ui.set(seraph.ui.antiaim[k].yaw_jitter, v.yaw_jitter)
        ui.set(seraph.ui.antiaim[k].yaw_jitter_offset, v.yaw_jitter_offset)
        ui.set(seraph.ui.antiaim[k].body_yaw, v.body_yaw)
        ui.set(seraph.ui.antiaim[k].body_yaw_offset, v.body_yaw_offset)
        ui.set(seraph.ui.antiaim[k].tick_activation, v.tick_activation)
        ui.set(seraph.ui.antiaim[k].defensive, v.defensive)
        ui.set(seraph.ui.antiaim[k].yaw_static, v.yaw_static)
        ui.set(seraph.ui.antiaim[k].yaw_sway_min, v.yaw_sway_min)
        ui.set(seraph.ui.antiaim[k].yaw_sway_max, v.yaw_sway_max)
        ui.set(seraph.ui.antiaim[k].yaw_sway_speed, v.yaw_sway_speed)
        ui.set(seraph.ui.antiaim[k].yaw_type, v.yaw_type)
    end

    local welcome_text = string.format("seraph • \a9FCA2BFFsucessfully sent AA data from '%s' to '%s'", current, selected)
    notification_table[#notification_table+1] = {text = welcome_text, time = globals.realtime() + 5, position = Y*0.7, alpha = 0}
end)


client.set_event_callback("setup_command", function(cmd)
    state_get(cmd)
    set_aa(cmd)
    overrides()
end)

client.set_event_callback("paint_ui", function()
    notifications()
    height_advtange()
    defensive_ind()
    watermark()
    crosshair_inds()
    vel_ind()
end)

local shots = 0
local hits = 0
local death_miss = 0
local unknown_miss = 0
local spread_miss = 0
local prediction_miss = 0
local miss = 0
client.set_event_callback("aim_hit", function (e)
    hits = hits +1
    if not ui.get(seraph.ui.aimbot_notifications) then return end
    local text = string.format("seraph • hit \a9FCA2BFF%s\aFFFFFFFF (damage:\a9FCA2BFF%s\aFFFFFFFF hitbox:\a9FCA2BFF%s\aFFFFFFFF bt:\a9FCA2BFF%s\aFFFFFFFF)", entity.get_player_name(e.target), e.damage, hitgroups[e.hitgroup + 1] or "?", bt)
    notification_table[#notification_table+1] = {text = text, time = globals.realtime() + 5, position = Y*0.7, alpha = 0, hit = true}
end)

client.set_event_callback("aim_miss", function (e)
    if e.reason == "?" then
        unknown_miss = unknown_miss + 1
    elseif e.reason == "death" then
        death_miss = death_miss + 1
    elseif e.reason == "spread" then
        spread_miss = spread_miss + 1
    elseif e.reason == "prediction error" then
        prediction_miss = prediction_miss + 1
    end
    miss = miss + 1
    if not ui.get(seraph.ui.aimbot_notifications) then return end
    local text = string.format("seraph • missed \af25555ff%s\aFFFFFFFF (predicted:\af25555ff%s\aFFFFFFFF hitbox:\af25555ff%s\aFFFFFFFF reason:\af25555ff%s\aFFFFFFFF)",entity.get_player_name(e.target), predicted_damage, hitgroups[e.hitgroup + 1] or "?", e.reason)
    notification_table[#notification_table+1] = {text = text, time = globals.realtime() + 5, position = Y*0.7, alpha = 0, miss = true}
end)

client.set_event_callback("aim_fire", function (e)
    shots = shots + 1
    predicted_damage = e.damage
    bt = (globals.tickcount()-e.tick)
    id = e.id
    hitchance = math.ceil(e.hit_chance)
end)

function gs_line(x1, y1, x2, y2, r, g, b, a)
    renderer.line(x1, y1, x2, y2, math.min(r + 2, 255), math.min(g + 2, 255), math.min(b + 2, 255), a)
end

function gs_outline(x, y, w, h, r, g, b, a)
    gs_line(x, y, x + w, y, r, g, b, a)
    gs_line(x + w, y, x + w, y + h, r, g, b, a)
    gs_line(x + w, y + h, x, y + h, r, g, b, a)
    gs_line(x, y + h, x, y, r, g, b, a)
end

function gs_fill(x, y, w, h, r, g, b, a)
    renderer.rectangle(x, y, w, h, math.min(r + 2, 255), math.min(g + 2, 255), math.min(b + 2, 255), a)
end


function blur_frame(x,y,w,h,r,g,b,a)
    renderer.blur(x-w/2+5, y, w, h, 1, 1)
end

local x, y, w, h = database.read('statsx') or 10, database.read('statsy') or Y*0.32, 92, 60


client.set_event_callback("paint_ui", function()
    if not entity.get_local_player() then return end
    if not ui.get(seraph.ui.aimbot_stats) then return end
    gs_frame(x-6, y-6, w+4, h+4, 255)
    rounded_rectangle(x-4, y-4, w, h, 1, 12, 12, 12, 255)
    renderer.texture(tex_id, x-4, y-4, w, h, 255, 255, 255, 255, 'r')
    renderer.text(x, y, 255, 255, 255, 255, "", nil, "hits: " .. hits .. "/" .. shots .. " (" .. math.floor((hits/shots)*100, 1) .. "%)")
    renderer.text(x, y + 10, 255, 255, 255, 255, "", nil, "unknown: " .. unknown_miss)
    renderer.text(x, y + 20, 255, 255, 255, 255, "", nil, "spread: " .. spread_miss)
    renderer.text(x, y + 30, 255, 255, 255, 255, "", nil, "prediction: " .. prediction_miss)
    renderer.text(x, y + 40, 255, 255, 255, 255, "", nil, "death: " .. death_miss)

    if ui.is_menu_open() then
        local pulse = math.sin(math.abs(-math.pi + (globals.realtime() * (1 / 0.5)) % (math.pi * 1))) * 255;
        renderer.text(x + 8, y - 20, 255, 255, 255, pulse, "", nil, "drag to move")
    end
    local mouseposx, mouseposy = ui.mouse_position()
    if client.key_state(0x01) and mouseposy <= y+h and mouseposy >= y and mouseposx <= x+w and mouseposx >= x then
        x = mouseposx - w/2
        y = mouseposy - h/2
        database.write('statsx', x)
        database.write('statsy', y)
    end
end)


ui.set_callback(seraph.ui.aimbot_stats_button, function()
    shots = 0
    hits = 0
    death_miss = 0
    unknown_miss = 0
    spread_miss = 0
    miss = 0
    prediction_miss = 0
    local text = string.format("seraph • \a9FCA2BFFsuccessfully reset aimbot statistics")
    notification_table[#notification_table+1] = {text = text, time = globals.realtime() + 5, position = Y*0.7, alpha = 0}
end)
-- endregion

local welcome_text = "seraph • \a69bdd2ffwelcome ".. name .."\affffffff • " .. build
notification_table[#notification_table+1] = {text = welcome_text, time = globals.realtime() + 5, position = Y*0.7, alpha = 0}