local lib = require("primordial/notification pop-up library.58")
lib:add_notification("Nado", "Don't Forget To Rate My Script", 7)

local screen_size = render.get_screen_size()

local ind = menu.add_checkbox("Indicators", "Enable Indica3tors")
local ind_col = ind:add_color_picker("Indicators Color", color_t(179, 176, 170, 175))
local ind2 = menu.add_text("Indicators", "Exploit Disable Color")
local ind_col2 = ind2:add_color_picker("Indicators Color", color_t(255, 255, 255, 175))

local function clamp(x, min, max) return x < min and min or x > max and max or x end

local imgs = {
    [1] = render.load_image("dt.png"),
    [2] = render.load_image("hs.png"),
    [3] = render.load_image("fd.png"),
}

local function indicators()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    if not ind:get() then return end

    local forcepred = menu.find("aimbot", "general", "exploits", "force prediction")
    local fakeduck = menu.find("antiaim", "main", "general", "fake duck")
    local doubletap = menu.find("aimbot","general","exploits","doubletap","enable")
    local hideshots = menu.find("aimbot","general","exploits","hideshots","enable")
    local damage_override = menu.find("aimbot", "auto", "target overrides", "force min. damage")
    local hitbox_override = menu.find("aimbot", "auto", "target overrides", "force hitbox")

    local dt_col = ind_col:get()
    local hs_col = ind_col:get()
    local fh_col = ind_col:get()
    local offset = - 20

	if fakeduck[2]:get() then
		render.texture(imgs[3].id, vec2_t(-45, screen_size[1]/2 + 0 + offset), vec2_t(150, 150), fh_col)
        offset = offset + imgs[3].size.y - 0	
    end

    if doubletap[2]:get() then
        if exploits.get_charge() > 0 then
            dt_col = ind_col:get()
        else
            dt_col = ind_col2:get()
        end

		render.texture(imgs[1].id, vec2_t(-35, screen_size[1]/2 + 0 + offset), vec2_t(150, 150), dt_col)
        offset = offset + imgs[1].size.y - 8
    end
	

    if hideshots[2]:get() then

		if exploits.get_charge() > 0 then
            dt_col = ind_col:get()
        else
            dt_col = ind_col2:get()
        end

		render.texture(imgs[2].id, vec2_t(-25, screen_size[1]/2 + 0 + offset), vec2_t(150, 150), dt_col)
        offset = offset + imgs[2].size.y - 4
    end

end

callbacks.add(e_callbacks.PAINT, function()
    local ind_enabled = ind:get()
    ind_col:set_visible(ind_enabled)

    indicators()
end)