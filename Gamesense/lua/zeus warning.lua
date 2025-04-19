local style = ui.new_combobox("VISUALS", "Player ESP", "Zeus flag", "Off","Icon", "Text")
local stylecolor = ui.new_color_picker("VISUALS", "Player ESP", "\n", 235, 229, 52, 255)
local textureid = renderer.load_svg("<svg id=\"svg\" version=\"1.1\" width=\"608\" height=\"689\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" ><g id=\"svgg\"><path id=\"path0\" d=\"M185.803 18.945 C 184.779 19.092,182.028 23.306,174.851 35.722 C 169.580 44.841,157.064 66.513,147.038 83.882 C 109.237 149.365,100.864 163.863,93.085 177.303 C 88.686 184.901,78.772 202.072,71.053 215.461 C 63.333 228.849,53.959 245.069,50.219 251.505 C 46.480 257.941,43.421 263.491,43.421 263.837 C 43.421 264.234,69.566 264.530,114.025 264.635 L 184.628 264.803 181.217 278.618 C 179.342 286.217,174.952 304.128,171.463 318.421 C 167.974 332.714,160.115 364.836,153.999 389.803 C 147.882 414.770,142.934 435.254,143.002 435.324 C 143.127 435.452,148.286 428.934,199.343 364.145 C 215.026 344.243,230.900 324.112,234.619 319.408 C 238.337 314.704,254.449 294.276,270.423 274.013 C 286.397 253.750,303.090 232.582,307.519 226.974 C 340.870 184.745,355.263 166.399,355.263 166.117 C 355.263 165.937,323.554 165.789,284.798 165.789 C 223.368 165.789,214.380 165.667,214.701 164.831 C 215.039 163.949,222.249 151.366,243.554 114.474 C 280.604 50.317,298.192 19.768,298.267 19.444 C 298.355 19.064,188.388 18.576,185.803 18.945 \" stroke=\"none\" fill=\"#ffffff\" fill-rule=\"evenodd\"></path></g></svg>", 25, 25) -- icon from sandvich
client.set_event_callback("paint", function()
    local plist = entity.get_players(true)
    for i = 1, #plist do
        local enemy = plist[i]
        if not entity.is_alive(enemy) then return end
        local weapon = entity.get_player_weapon(enemy)
        local wepclass = entity.get_classname(weapon)
        if wepclass ~= "CWeaponTaser" then return end
        local bbox = { entity.get_bounding_box(enemy) }
        if bbox[1] == nil then return end
        local textsize = { renderer.measure_text("d-", "ZEUS") }
        local rgba = { ui.get(stylecolor) }
        if ui.get(style) == "Icon" then
            renderer.texture(textureid, bbox[1] - textsize[1], bbox[2], 25, 25, rgba[1], rgba[2], rgba[3], rgba[4])
        elseif ui.get(style) == "Text" then
            renderer.text(bbox[1] - textsize[1] / 2, bbox[2], rgba[1], rgba[2], rgba[3], rgba[4], "rd-", 0, "ZEUS")
        end
    end
end)