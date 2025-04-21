local callback = client.set_event_callback
local indicator = renderer.indicator
local uicallback = ui.set_callback
local visible = ui.set_visible
local checkbox = ui.new_checkbox
local getui = ui.get
local combo = ui.new_combobox
local color = ui.new_color_picker
local text = renderer.text
local slider = ui.new_slider
local rectangle = renderer.rectangle

local w, h = client.screen_size()

local ui =
{
	style = combo("Lua", "B", "Style", "-", "Indicator", "Text"),
	bgcol = color("Lua", "B", "Background col", 35, 35, 35, 220),
	hits = checkbox("Lua", "B", "Hits"),
	hitscol = color("Lua", "B", "Hits col"),
	misses = checkbox("Lua", "B", "Misses"),
	missescol = color("Lua", "B", "Misses col"),
	percent = checkbox("Lua", "B", "Percent"),
	percentcol = color("Lua", "B", "Percent col"),
	xpos = slider("Lua", "B", "X position", 0, w, w / 2, true),
	ypos = slider("Lua", "B", "Y position", 0, h, h / 2, true),
}

visible(ui.hits, false)
visible(ui.hitscol, false)
visible(ui.misses, false)
visible(ui.missescol, false)
visible(ui.percent, false)
visible(ui.percentcol, false)
visible(ui.xpos, false)
visible(ui.ypos, false)
visible(ui.bgcol, false)

uicallback(ui.style, function()
	visible(ui.hits, getui(ui.style) ~= "-")
	visible(ui.hitscol, getui(ui.style) ~= "-")
	visible(ui.misses, getui(ui.style) ~= "-")
	visible(ui.missescol, getui(ui.style) ~= "-")
	visible(ui.percent, getui(ui.style) ~= "-")
	visible(ui.percentcol, getui(ui.style) ~= "-")
	visible(ui.xpos, getui(ui.style) == "Text")
	visible(ui.ypos, getui(ui.style) == "Text")
	visible(ui.bgcol, getui(ui.style) == "Text")
end)

local hits = 0
local misses = 0

local function hit(e)
	local localPlayer = entity.get_local_player()
	local attacker = client.userid_to_entindex(e.attacker)

    if attacker == nil then
    	return
    end

    if attacker ~= localPlayer then
    	return
    end

    hits = hits + 1
end

callback('player_hurt', hit)

local function miss(e)
	misses = misses + 1
end

callback('aim_miss', miss)

local function hitrate(ctx)
	local total = hits + misses
	local hitPercent = hits / total
	local hitPercentFixed = 0

	if (hitPercent > 0)  then
		hitPercentFixed = hitPercent * 100
		hitPercentFixed = string.format("%2.1f", hitPercentFixed)
	end

	local hr, hg, hb, ha = getui(ui.hitscol)
	local mr, mg, mb, ma = getui(ui.missescol)
	local pr, pg, pb, pa = getui(ui.percentcol)

	if getui(ui.style) == "Indicator" then
		if getui(ui.percent, true) then
			indicator(hr, hg, hb, ha, "%: ".. hitPercentFixed)
		end

		if getui(ui.misses, true) then
			indicator(mr, mg, mb, ma, "Misses: ".. misses)
		end

		if getui(ui.hits, true) then
			indicator(pr, pg, pb, pa, "Hits: ".. hits)
		end
	elseif getui(ui.style) == "Text" then
		local br, bg, bb, ba = getui(ui.bgcol)

		if getui(ui.hits, true) and getui(ui.misses, true) and getui(ui.percent, true) then
			rectangle(getui(ui.xpos), getui(ui.ypos) - 20, 61, 53, br, bg, bb, ba)

			text(5 + getui(ui.xpos), getui(ui.ypos) - 15, 255, 255, 255, 255, "", 0, "Hits: ")
			text(32 + getui(ui.xpos), getui(ui.ypos) - 15, hr, hg, hb, ha, "", 0, hits)

			text(5 + getui(ui.xpos), getui(ui.ypos), 255, 255, 255, 255, "", 0, "Misses: ")
			text(47 + getui(ui.xpos), getui(ui.ypos), mr, mg, mb, ma, "", 0, misses)

			text(5 + getui(ui.xpos), getui(ui.ypos) + 15, 255, 255, 255, 255, "", 0, "Percent: ")
			text(50 + getui(ui.xpos), getui(ui.ypos) + 15, pr, pg, pb, pa, "", 0, hitPercentFixed)
		elseif getui(ui.hits, true) and getui(ui.misses, true) and not getui(ui.percent, true) then
			rectangle(getui(ui.xpos), getui(ui.ypos) - 20, 61, 38, br, bg, bb, ba)

			text(5 + getui(ui.xpos), getui(ui.ypos) - 15, 255, 255, 255, 255, "", 0, "Hits: ")
			text(32 + getui(ui.xpos), getui(ui.ypos) - 15, hr, hg, hb, ha, "", 0, hits)

			text(5 + getui(ui.xpos), getui(ui.ypos), 255, 255, 255, 255, "", 0, "Misses: ")
			text(47 + getui(ui.xpos), getui(ui.ypos), mr, mg, mb, ma, "", 0, misses)
		elseif getui(ui.hits, true) and not getui(ui.misses, true) and getui(ui.percent, true) then
			rectangle(getui(ui.xpos), getui(ui.ypos) - 5, 61, 38, br, bg, bb, ba)

			text(5 + getui(ui.xpos), getui(ui.ypos), 255, 255, 255, 255, "", 0, "Hits: ")
			text(32 + getui(ui.xpos), getui(ui.ypos), hr, hg, hb, ha, "", 0, hits)

			text(5 + getui(ui.xpos), getui(ui.ypos) + 15, 255, 255, 255, 255, "", 0, "Percent: ")
			text(50 + getui(ui.xpos), getui(ui.ypos) + 15, pr, pg, pb, pa, "", 0, hitPercentFixed)
		elseif not getui(ui.hits, true) and getui(ui.misses, true) and getui(ui.percent, true) then
			rectangle(getui(ui.xpos), getui(ui.ypos) - 5, 61, 38, br, bg, bb, ba)

			text(5 + getui(ui.xpos), getui(ui.ypos), 255, 255, 255, 255, "", 0, "Misses: ")
			text(47 + getui(ui.xpos), getui(ui.ypos), mr, mg, mb, ma, "", 0, misses)

			text(5 + getui(ui.xpos), getui(ui.ypos) + 15, 255, 255, 255, 255, "", 0, "Percent: ")
			text(50 + getui(ui.xpos), getui(ui.ypos) + 15, pr, pg, pb, pa, "", 0, hitPercentFixed)
		elseif getui(ui.hits, true) and not getui(ui.misses, true) and not getui(ui.percent, true) then
			rectangle(getui(ui.xpos), getui(ui.ypos) - 5, 61, 23, br, bg, bb, ba)

			text(5 + getui(ui.xpos), getui(ui.ypos), 255, 255, 255, 255, "", 0, "Hits: ")
			text(32 + getui(ui.xpos), getui(ui.ypos), hr, hg, hb, ha, "", 0, hits)
		elseif not getui(ui.hits, true) and getui(ui.misses, true) and not getui(ui.percent, true) then
			rectangle(getui(ui.xpos), getui(ui.ypos) - 5, 61, 23, br, bg, bb, ba)

			text(5 + getui(ui.xpos), getui(ui.ypos), 255, 255, 255, 255, "", 0, "Misses: ")
			text(47 + getui(ui.xpos), getui(ui.ypos), mr, mg, mb, ma, "", 0, misses)
		elseif not getui(ui.hits, true) and not getui(ui.misses, true) and getui(ui.percent, true) then
			rectangle(getui(ui.xpos), getui(ui.ypos) - 5, 61, 23, br, bg, bb, ba)

			text(5 + getui(ui.xpos), getui(ui.ypos), 255, 255, 255, 255, "", 0, "Percent: ")
			text(50 + getui(ui.xpos), getui(ui.ypos), pr, pg, pb, pa, "", 0, hitPercentFixed)
		end
	end
end

callback('paint', hitrate)
