local master_switch = ui.new_checkbox("VISUALS", "Player ESP", "Zeus warning")
local elect_svg = renderer.load_svg("<svg id=\"svg\" version=\"1.1\" width=\"608\" height=\"689\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" ><g id=\"svgg\"><path id=\"path0\" d=\"M185.803 18.945 C 184.779 19.092,182.028 23.306,174.851 35.722 C 169.580 44.841,157.064 66.513,147.038 83.882 C 109.237 149.365,100.864 163.863,93.085 177.303 C 88.686 184.901,78.772 202.072,71.053 215.461 C 63.333 228.849,53.959 245.069,50.219 251.505 C 46.480 257.941,43.421 263.491,43.421 263.837 C 43.421 264.234,69.566 264.530,114.025 264.635 L 184.628 264.803 181.217 278.618 C 179.342 286.217,174.952 304.128,171.463 318.421 C 167.974 332.714,160.115 364.836,153.999 389.803 C 147.882 414.770,142.934 435.254,143.002 435.324 C 143.127 435.452,148.286 428.934,199.343 364.145 C 215.026 344.243,230.900 324.112,234.619 319.408 C 238.337 314.704,254.449 294.276,270.423 274.013 C 286.397 253.750,303.090 232.582,307.519 226.974 C 340.870 184.745,355.263 166.399,355.263 166.117 C 355.263 165.937,323.554 165.789,284.798 165.789 C 223.368 165.789,214.380 165.667,214.701 164.831 C 215.039 163.949,222.249 151.366,243.554 114.474 C 280.604 50.317,298.192 19.768,298.267 19.444 C 298.355 19.064,188.388 18.576,185.803 18.945 \" stroke=\"none\" fill=\"#fff200\" fill-rule=\"evenodd\"></path></g></svg>", 25, 25)

local function get_player_weapons(idx)
	local list = {}

    for i = 0, 64 do
        local cwpn = entity.get_prop(idx, "m_hMyWeapons", i)

		if cwpn ~= nil then
			table.insert(list, cwpn)
		end
	end

	return list
end

client.set_event_callback("paint", function()
    local me = entity.get_local_player()

    if not ui.get(master_switch) or elect_svg == nil or me == nil or not entity.is_alive(me) then
        return
    end
    
    for _, i in pairs(entity.get_players(true)) do
        local esp_data = entity.get_esp_data(i)

        if esp_data ~= nil then
            local has_taser = 0
            local x1, y1, x2, y2, a = entity.get_bounding_box(i)

            if esp_data.weapon_id == 31 then
                has_taser = 2
            end

            for _, v in pairs(get_player_weapons(i)) do
                if v ~= nil and has_taser == 0 and entity.get_prop(v, "m_iItemDefinitionIndex") == 31 then
                    has_taser = 1
                end
            end

            if x1 ~= 0 and a > 0.000 and has_taser > 0 then
                local g, b = 255, 255

                if has_taser == 2 then
                    g, b = 0, 0
                end

                renderer.texture(elect_svg, x1 - 24, y1, 25, 25, 255, g, b, a*255)
            end
        end
    end
end)
