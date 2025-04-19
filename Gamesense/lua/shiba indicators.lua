local w, h = client.screen_size()
local center = { w/2, h/2 }
local offset = 64
local r, g, b, a

local menu = {
    enabled = ui.new_checkbox("VISUALS", "Other ESP", "Crosshair indicator"),
    color = ui.new_color_picker("VISUALS", "Other ESP", "Crosshair indicator color", 0, 255, 0, 255)
}

ui.set_callback(menu.color, function(self)
    r, g, b, a = ui.get(self)
end)
r, g, b, a = ui.get(menu.color)

local states = {
    { { ui.reference("RAGE", "Other", "Duck peek assist") }, "DUCK" },
    { { ui.reference("RAGE", "Other", "Double tap") }, "DT" },
    { { ui.reference("AA", "Anti-aimbot angles", "Freestanding") }, "FREESTANDING" },
    { { ui.reference("AA", "Other", "On shot anti-aim") }, "ONSHOT" },
    { { ui.reference("RAGE", "Other", "Force body aim") }, "FORCE BAIM" },
    { { ui.reference("RAGE", "Aimbot", "Force safe point") }, "SP FORCE" },
}

function bool_to_number(value)
    return value and 1 or 0
end

client.set_event_callback("paint", function()
    if ui.get(menu.enabled) then
        local total_states = 0
        local time_of_render = globals.curtime()
        for i = 1, #states do 
            local active = 0
            local cur_check = states[i][1]

            for n = 1, #cur_check do 
                local value = ui.get(cur_check[n])
                local type = type(value)
                if type == "boolean" then
                    active = active + bool_to_number(value)
                elseif type == "table" and value[1] ~= nil then 
                    active = active + 1
                end
            end

            if active >= #cur_check then
                total_states = total_states + 1
                renderer.text(center[1], center[2] - offset - (total_states * 12), r, g, b, a, "cb", 0, states[i][2])
            end
        end
    end
end)