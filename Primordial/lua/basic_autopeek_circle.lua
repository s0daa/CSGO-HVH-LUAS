--[[
   _____                         ____                                 _   _______ _____  
  / ____|                       |  _ \                               | | |__   __|  __ \ 
 | (___  _   _ ___  __ _ _ __   | |_) | __ _ _ __ _ __ _____      __ | |    | |  | |  | |
  \___ \| | | / __|/ _` | '_ \  |  _ < / _` | '__| '__/ _ \ \ /\ / / | |    | |  | |  | |
  ____) | |_| \__ \ (_| | | | | | |_) | (_| | |  | | | (_) \ V  V /  | |____| |  | |__| |
 |_____/ \__,_|___/\__,_|_| |_| |____/ \__,_|_|  |_|  \___/ \_/\_/   |______|_|  |_____/ 
                                                                                         
                                                                                         
    UHQ AUTO PEEK CIRCLE
]]--

local enable = menu.add_checkbox("susan barrow ltd | general", "enable autopeek circle", false)
local colour = enable:add_color_picker("colour")

function world_circle(origin, radius, color)
	local previous_screen_pos, screen

    for i = 0, radius*2 do
		local pos = vec3_t(radius * math.cos(i/3) + origin.x, radius * math.sin(i/3) + origin.y, origin.z);

        local screen = render.world_to_screen(pos)
        if not screen then return end
		if screen.x ~= nil and previous_screen_pos then
            render.line(previous_screen_pos, screen, color)
			previous_screen_pos = screen
        elseif screen.x ~= nil then
            previous_screen_pos = screen
		end
	end
end

function draw()
    if ragebot.get_autopeek_pos() and enable:get() then
        world_circle(ragebot.get_autopeek_pos(), 20, colour:get())
    end
end

callbacks.add(e_callbacks.PAINT, draw)