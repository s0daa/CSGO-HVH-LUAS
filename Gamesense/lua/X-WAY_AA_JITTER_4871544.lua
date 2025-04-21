local kloc = ui.create("kloc", "X-WAY")
local current_stage = 1
local yaw_mod_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset")
local angles = ui.find("Aimbot", "Anti Aim", "Angles")
local mode = kloc:combo('Mode', {'3Way', '5Way'})
local xway_degree = kloc:slider('X-WAY Degree', -180, 180, 0)

local function choking(cmd)
    local Choke = false

    if cmd.send_packet == false or globals.choked_commands > 1 then
        Choke = true
    else
        Choke = false
    end

    return Choke
end
events.createmove:set(function(cmd)
    local three_ways = {-xway_degree:get(), 0, xway_degree:get()}
    local five_ways = {-xway_degree:get()/2, -xway_degree:get(), 0, xway_degree:get()/2, xway_degree:get()}
    if cmd.command_number % 4 > 1 and choking(cmd) == false then
        current_stage = current_stage + 1
    end
    if current_stage == 4 and mode:get() == '3Way' then
        current_stage = 1
    end
    if current_stage == 6 and mode:get() == '5Way' then
        current_stage = 1
    end
    yaw_mod_offset:set(mode:get() == '5Way' and five_ways[current_stage] or mode:get() == '3Way' and three_ways[current_stage])
end)

local function gradient(r1, g1, b1, a1, r2, g2, b2, a2, text)
    local output = ''
    local len = #text-1
    local rinc = (r2 - r1) / len
    local ginc = (g2 - g1) / len
    local binc = (b2 - b1) / len
    local ainc = (a2 - a1) / len
    for i=1, len+1 do
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
        r1 = r1 + rinc
        g1 = g1 + ginc
        b1 = b1 + binc
        a1 = a1 + ainc
    end

    return output
end

local function logsclr(color)
    local output = ''
    output = output .. ('\a%02x%02x%02x'):format(color.r, color.g, color.b)
    return output
end

ui.sidebar(gradient(0, 40, 255, 255, 245, 0, 245, 255, "X-WAY"), "layer-group")


local function to_boolean(str)
	if str == "true" or str == "false" then
		return (str == "true")
	else
		return str
    end
end


