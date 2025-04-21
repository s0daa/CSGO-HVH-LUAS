local callback = client.set_event_callback
local checkbox = ui.new_checkbox
local getui = ui.get
local setprop = entity.set_prop
local slider = ui.new_slider
local color = ui.new_color_picker
local getprop = entity.get_prop
local getall = entity.get_all
local rectangle = renderer.rectangle
local gradient = renderer.gradient
local text = renderer.text
local uicallback = ui.set_callback
local visible = ui.set_visible
local indicator = renderer.indicator
local combo = ui.new_combobox
local triangle = renderer.triangle

local w, h = client.screen_size()

local menu = 
{
	enable = checkbox("Lua", "B", "Enable hud"),
	col = color("Lua", "B", "Col", 20, 20, 20, 255),
	style = combo("Lua", "B", "Style", "-", "Default", "New", "Another name"),
	full = checkbox("Lua", "B", "Full length"),
	reposition = checkbox("Lua", "B", "Reposition hud"),
	xpos = slider("Lua", "B", "X Position", 0, w, w / 2, true),
	ypos = slider("Lua", "B", "Y Position", 0, h, h / 2, true),
	resize = checkbox("Lua", "B", "Resize hud"),
	width = slider("Lua", "B", "Width", 0, w, 350, true),
	height = slider("Lua", "B", "Height", 0, h, 64, true),
}

visible(menu.style, false)
visible(menu.full, false)
visible(menu.col, false)
visible(menu.reposition, false)
visible(menu.xpos, false)
visible(menu.ypos, false)
visible(menu.resize, false)
visible(menu.width, false)
visible(menu.height, false)

--visibility--
uicallback(menu.style, function()
	visible(menu.col, getui(menu.style) == "Default")
	visible(menu.full, getui(menu.style) == "Default")
	visible(menu.resize, getui(menu.style) == "Default")
	visible(menu.reposition, getui(menu.style) ~= "New")
end)

uicallback(menu.enable, function() 
	visible(menu.style, getui(menu.enable))
end)

uicallback(menu.reposition, function()
	visible(menu.xpos, getui(menu.reposition))
	visible(menu.ypos, getui(menu.reposition))
end)

uicallback(menu.resize, function()
	visible(menu.width, getui(menu.resize))
	visible(menu.height, getui(menu.resize))
end)

local function paint_hud(ctx)
	if getui(menu.enable, true) then
		local localPlayer = entity.get_local_player()
		local hp = getprop(localPlayer, "m_iHealth")
		local armor = getprop(localPlayer, "m_ArmorValue")
		local inBuyzone = getprop(localPlayer, "m_bInBuyZone")
		local money = getprop(localPlayer, "m_iAccount")
		local currentWeapon = getprop(localPlayer, "m_hActiveWeapon")
		local playerResource = getall("CCSPlayerResource")[1]
		local c4Holder = getprop(playerResource, "m_iPlayerC4")
		local hasHelmet = getprop(localPlayer, "m_bHasHelmet")
		local ammo = getprop(entity.get_player_weapon(entity.get_local_player()), "m_iClip1")
		local ammoReserve = getprop(entity.get_player_weapon(entity.get_local_player()), "m_iPrimaryReserveAmmoCount")

		local i = 1

		setprop(localPlayer, "m_iHideHud", 8200)

		if getui(menu.style) == "-" then
			visible(menu.full, false)
			visible(menu.col, false)
			visible(menu.reposition, false)
			visible(menu.xpos, false)
			visible(menu.ypos, false)
			visible(menu.resize, false)
			visible(menu.width, false)
			visible(menu.height, false)
		elseif getui(menu.style) == "Default" then
			local images_lib = require "images"
			local imageIcons = images_lib.load(require("imagepack_icons"))

			local r, g, b, a = getui(menu.col)

			if getui(menu.resize, true) then
					hudWidth = getui(menu.width)
					hudHeight = getui(menu.height)
				else
					hudWidth = 350
					hudHeight = 64
				end

				if getui(menu.reposition, true) then
					x = getui(menu.xpos)
					y = getui(menu.ypos)
				else
					useless, y = client.screen_size()
					x = 0
				end

			if getui(menu.full, true) then
				--hp/armor--
				rectangle(x, y - 68 + 4, w, 68 - 4, 10, 10, 10, 255)
				rectangle(x + 1, y - 67 + 4, w - 2, 66 - 4, 60, 60, 60, 255)
				rectangle(x + 2, y - 66 + 4, w - 4, 64 - 4, 40, 40, 40, 255)
				rectangle(x + 5, y - 64 + 4, w - 9, 60 - 4, 60, 60, 60, 255)
				rectangle(x + 6, y - 63 + 4, w - 11, 58 - 4, r, g, b, a)
				gradient(x + 7, y - 62 + 4, w / 2 - 11, 1, 56, 176, 218, 255, 201, 72, 205, 255, true)
				gradient(x + 7 + w / 2 - 13, y - 62 + 4, w / 2, 1, 201, 72, 205, 255, 204, 227, 53, 255, true)
				text(x + 75, y - 35 - 3, 108, 195, 18, 255, "c+", 0, hp)
				text(x + 75, y - 16 - 3, 255, 255, 255, 255, "c", 0, "Health")
				text(x + 275, y - 35 - 3, 85, 155, 215, 255, "c+", 0, armor)
				text(x + 275, y - 16 - 3, 255, 255, 255, 255, "c", 0, "Armor")

				if hp > 0 then
					if ammo == -1 then
					elseif ammo >= 0 and ammo < 10 and ammoReserve >= 0 and ammoReserve < 10 then
						text(w - 115, h - 32, 255, 255, 255, 255, "c+", 0, ammoReserve)
						text(w - 135, h - 33, 255, 255, 255, 255, "c+", 0, "|")
						text(w - 155, h - 32, 255, 255, 255, 255, "c+", 0, ammo)
					elseif ammo >= 10 or ammoReserve >= 10 then
						text(w - 110, h - 32, 255, 255, 255, 255, "c+", 0, ammoReserve)
						text(w - 135, h - 33, 255, 255, 255, 255, "c+", 0, "|")
						text(w - 160, h - 32, 255, 255, 255, 255, "c+", 0, ammo)
					end
				end
			else
				--hp/armor--
				rectangle(x, y - 68 + 4, hudWidth, hudHeight --[[64--]], 10, 10, 10, 255)
				rectangle(x + 1, y - 67 + 4, hudWidth - 2, hudHeight - 2, 60, 60, 60, 255)
				rectangle(x + 2, y - 66 + 4, hudWidth - 4, hudHeight - 4, 40, 40, 40, 255)
				rectangle(x + 5, y - 64 + 4, hudWidth - 9, hudHeight - 8, 60, 60, 60, 255)
				rectangle(x + 6, y - 63 + 4, hudWidth - 11, hudHeight - 10, r, g, b, a)
				gradient(x + 7, y - 62 + 4, (hudWidth - 11) / 2, 1, 56, 176, 218, 255, 201, 72, 205, 255, true)
				gradient(x + 7 + ((hudWidth - 14) / 2), y - 62 + 4, (hudWidth - 11) / 2, 1, 201, 72, 205, 255, 204, 227, 53, 255, true)
				text(x + 75, y - 35 - 3, 108, 195, 18, 255, "c+", 0, hp)
				text(x + 75, y - 16 - 3, 255, 255, 255, 255, "c", 0, "Health")
				text(x + 275, y - 35 - 3, 85, 155, 215, 255, "c+", 0, armor)
				text(x + 275, y - 16 - 3, 255, 255, 255, 255, "c", 0, "Armor")
			end

			if c4Holder == localPlayer then
				--loop through all elements in images_icons
				local image = imageIcons["c4"]
				--calculate x and y of the current image
				local x_i, y_i = x+math.floor(((i-1) / 16))*125, y+(i % 16)*30
				--draw the image, only specify the height (width is calculated automatically to match the aspect ratio)
				local width, height = image:draw(x + 135, h - 53 + 1, nil, 40, 255, 255, 255, 255)
			end

			if hasHelmet == 1 then
				--loop through all elements in images_icons
				local image = imageIcons["armor_helmet"]
				--calculate x and y of the current image
				local x_i, y_i = x+math.floor(((i-1) / 16))*125, 0+(i % 16)*30
				--draw the image, only specify the height (width is calculated automatically to match the aspect ratio)
				local width, height = image:draw(x + 180, y - 53 + 7, nil, 32, 255, 255, 255, 255)
			elseif armor > 0 and hasHelmet == 0 then
				--loop through all elements in images_icons
				local image = imageIcons["armor"]
				--calculate x and y of the current image
				local x_i, y_i = x+math.floor(((i-1) / 16))*125, y+(i % 16)*30
				--draw the image, only specify the height (width is calculated automatically to match the aspect ratio)
				local width, height = image:draw(x + 180, y - 53 + 7, nil, 32, 255, 255, 255, 255)
			end

			if inBuyzone == 1 then
				indicator(255, 255, 255, 255, "$".. money)
			end

			indicator(255, 255, 255, 0, " ")
		elseif getui(menu.style) == "New" then
			visible(menu.full, false)
			visible(menu.col, false)
			visible(menu.reposition, false)
			visible(menu.xpos, false)
			visible(menu.ypos, false)
			visible(menu.resize, false)
			visible(menu.width, false)
			visible(menu.height, false)

			--hp--
			rectangle(w / 2 - w * 0.025, h / 2 - 51, 17, 102, 20, 20, 20, 255)

			local r, g, b = 125, hp * 2, 0

			if hp <= 100 then
				rectangle(w / 2 - w * 0.025 + 1, h / 2 - 50 + 100 - hp, 15, hp, r, g, b, 255)
			else
				rectangle(w / 2 - w * 0.025 + 1, h / 2 - 50, 15, 100, r, g, b, 255)
			end

			text(w / 2 - w * 0.025 + 10, h / 2 + 57, 255, 255, 255, 255, "c", 0, hp.."%")

			--ammo--
			rectangle(w / 2 + w * 0.025 - 17, h / 2 - 51, 17, 102, 20, 20, 20, 255)
			if hp > 0 then
				if ammo <= 10 then
					rectangle(w / 2 + w * 0.025 + 1 - 17, h / 2 - 50 + 100 - ammo * 10, 15, ammo * 10, 255, 255, 255, 255)
				else
					rectangle(w / 2 + w * 0.025 + 1 - 17, h / 2 - 50, 15, 100, 255, 255, 255, 255)
				end

				if ammo >= 0 then
					text(w / 2 + w * 0.025 - 8, h / 2 + 57, 255, 255, 255, 255, "c", 0, ammo)
				else
					text(w / 2 + w * 0.025 - 8, h / 2 + 57, 255, 255, 255, 255, "c", 0, "0")
				end
			else
				text(w / 2 + w * 0.025 - 8, h / 2 + 57, 255, 255, 255, 255, "c", 0, "0")
			end

			--armor--
			if hasHelmet == 1 then
				text(w / 2, h / 2 + 57, 0, 0, 255, 255, "c", 0, "hk")
			elseif armor > 0 and hasHelmet == 0 then
				text(w / 2, h / 2 + 57, 0, 0, 220, 255, "c", 0, "k")
			end

			--money--
			if inBuyzone == 1 then
				text(w / 2, h / 2 - 57, 255, 255, 255, 255, "c", 0, "$"..money)
			end
		elseif getui(menu.style) == "Another name" then
			if getui(menu.reposition, true) then
				x = getui(menu.xpos)
				y = getui(menu.ypos)
			else
				useless, y = client.screen_size()
				x = 20
			end

			local up = 20

			--black
			--left triangle
			triangle(x - 1, y - 1 - up, x - 1, y + 16 - up, x - 17, y + 16 - up, 0, 0, 0, 255)
			--rectangle
			rectangle(x - 1, y - 1 - up, 72, 17, 0, 0, 0, 255)
			--right triangle
			triangle(x + 71, y - 1 - up, x + 92, y - 1 - up, x + 71, y + 16 - up, 0, 0, 0, 255)

			local r, g, b = 125, hp * 2, 0

			if hp >= 100 then
				--left triangle
				triangle(x, y - up, x, y + 15 - up, x - 15, y + 15 - up, r, g, b, 255)
				--rectangle
				rectangle(x, y - up, 70, 15, r, g, b, 255)
				--right trangle
				triangle(x + 70, y - up, x + 90, y - up, x + 70, y + 15 - up, r, g, b, 255)
			elseif hp >= 86 and hp < 100 then
				--left triangle
				triangle(x, y - up, x, y + 15 - up, x - 15, y + 15 - up, r, g, b, 255)
				--rectangle
				rectangle(x, y - up, 70, 15, r, g, b, 255)
				--right trangle
				triangle(x + 70 - (14 - hp) - 90, y - up, x + 90 - (14 - hp) - 90, y - up, x + 70 - (14 - hp) - 90, y + 15 - up, r, g, b, 255)
			elseif hp > 14 and hp < 86 then
				--left triangle
				triangle(x, y - up, x, y + 15 - up, x - 15, y + 15 - up, r, g, b, 255)
				--rectangle
				rectangle(x, y - up, hp - 15, 15, r, g, b, 255)
			elseif hp <= 14 and hp > 0 then
				--left triangle
				triangle(x - (14 - hp), y + (14 - hp) - up, x - (14 - hp), y + 15 - up, x - 15, y + 15 - up, r, g, b, 255)
			end
		end
	else
		visible(menu.style, false)
		visible(menu.full, false)
		visible(menu.col, false)
		visible(menu.reposition, false)
		visible(menu.xpos, false)
		visible(menu.ypos, false)
		visible(menu.resize, false)
		visible(menu.width, false)
		visible(menu.height, false)
	end
end

callback('paint', paint_hud)
